Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E84484039
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiADK5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiADK5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:57:45 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2A5C061761;
        Tue,  4 Jan 2022 02:57:45 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id x194so9188037pgx.4;
        Tue, 04 Jan 2022 02:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hn5eFdr5rw5/OpN7yZoLYXJGWzqzZZgrg1LfspswN7M=;
        b=OGmY0yXF0uJl3zaziNQdwKDsCBMlSs+chkm28jhw9Rl5XHrlfzf5V+FxlgLE+8KvQ2
         M3LwoUWei9bHltXKnqpXiztDY3BntpKPRj2mAinND2/3k8e9Qg/nQtiN8jxyJ59hEfys
         CQU7SnwugmXJBhiKp4Rxhwr5VdOvydSJvO2UTr5hs8oDBmtjbMygKcYxJMWHeFdkoJoL
         Ghq/KZnb1uI5T0pFhfAyhp6KxdEfhRxEmMu9K9+ncCDTZxlu+1ljBFOwM7GUQvq+JypG
         0AHa+mjZrm/fhltilcpjE4Pte9FpQx5Evw4xI0sCoPYvTP7sj0Dl99LkmrsoFIoGfUkQ
         TVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hn5eFdr5rw5/OpN7yZoLYXJGWzqzZZgrg1LfspswN7M=;
        b=Gh4bjZFwAD2sawTqjk5KD03TYqKHtny24W/tCGIEWxRrY+JpIHPNya5Be11pIbToFe
         TJaj1adWqUwCRsVpTPEpbt3laz/4trhRguuU/bzyn7YYu/qWDgABoGFRz7859ke6lDIp
         Xg8xkuf80MfIXgnNJ1Jt16YO+kq9NuOkZoyYKHgc6su7m+OcHzZcdh9KyK5Q3dXewWME
         aGuEQwV05nZRpXWexUU8EkcvfpOM5kEZMRjJzakYWQa2QSn/UaaIh4G3YnZgF95LPFzb
         gNdyPxRvv2z2f6DxJ0HzcF09PLdhaJY1QkEQLWKREzTCjKBYA0rr1KKlU7sh+SGVlj8e
         qSeg==
X-Gm-Message-State: AOAM532qEVEjIhvNyggka0ZEop+C27EA5gpRTuu9KQvxgHruuDvPAMCw
        v3k5wOsjL1aNMbtAUH0cCzk=
X-Google-Smtp-Source: ABdhPJxdxB/cClrALKt0FJPKOtERSfkH/CLWzs25rAkBnaCzUBYOQBdMMmntK83Hbq53hqYbEWPIdg==
X-Received: by 2002:aa7:9515:0:b0:4ba:77b5:ef82 with SMTP id b21-20020aa79515000000b004ba77b5ef82mr50985648pfp.11.1641293864907;
        Tue, 04 Jan 2022 02:57:44 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g21sm41648276pfc.75.2022.01.04.02.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 02:57:44 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     xu.xin16@zte.com.cn, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ipv4: Namespaceify two sysctls related with mtu
Date:   Tue,  4 Jan 2022 10:57:39 +0000
Message-Id: <20220104105739.601448-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

The following patch series enables the min_pmtu and mtu_expires to
be visible and configurable per net namespace. Different namespace
application might have different requirements on the setting of
min_pmtu and mtu_expires.

If these two patches are applied, inside a net namespace we create,
we can see two more sysctls under /proc/sys/net/ipv4/route:
1. min_pmtu
2. mtu_expires

where min_pmtu and mtu_expires are configurable.

xu xin (2):
namespaceify-min-pmtu
Namespaceify pmtu_expires

xu xin (2):
  Namespaceify min_pmtu sysctl
  Namespaceify mtu_expires sysctl

 include/net/netns/ipv4.h |  3 ++
 net/ipv4/route.c         | 74 ++++++++++++++++++++++++++--------------
 2 files changed, 51 insertions(+), 26 deletions(-)

-- 
2.25.1

