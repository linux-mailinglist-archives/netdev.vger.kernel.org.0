Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6475D30B808
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhBBGwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbhBBGwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:52:50 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4A4C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 22:52:10 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id h12so26375142lfp.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 22:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UF8MefmUKkOn4gwoLIo0ZF9Fo4V3ogtg1CNeHK5x9WA=;
        b=Xx/fIjxZmldVGa+qMj3IU14T872spDjl2XNr+qPeZSoqE4emx633EpSjbnrOBwHbfC
         y128Jy8u6d/K5dTukIx+P0Hp4I9YT8MEwfC0J1pRwUlvXGSOafeS0iTIVZPk5GDtvZUK
         u3We4PqhfsyXdEKMFqPV9tO359Y1GtrP0ByYGuZ2K+AIhsbYeRlOwlQZmONXNDdnAwaA
         aLcth0aSM/+narrt3qvt0uhpiaI9mWRpen6MRbCc00clY26sOL67eWzNOnfK2VOZFQgh
         Jw1VMYZLGeaDBsPtsWrbTckkut1MoLLTA4WkbnrIu7l+I9+S9r9MmBWWPEB4nbHDMQTz
         VBfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UF8MefmUKkOn4gwoLIo0ZF9Fo4V3ogtg1CNeHK5x9WA=;
        b=OyY3Wh6/rB8IwD4dRjVMDuYf3BOt9FJLmcj3Gv9quLmNoBveEO9wgZdG54XqvvTt9v
         EhNei1bvCgvOGqiAV/5+gu8L08FPcrwLhDn1yeh01ZGZRHtRQT4Y3oS3qU/exv03Xv1Z
         63qtqtWotZTZ4ND2kHYu9r6m4zqhEAPILWbNvpyaGo+QF/AY+09A0DvtnRdMXCN5a+gT
         MAs6sOv8JkZ0qVf2GB0g6xFbEXoablMe1MQILQ5ep41EcYnkjGBb8vGc9XmiCoSHvzrO
         vAewJtmL1kqNgTqQ0I8G84zKOryfJ1lhdWYPuQcxTUdgrabhVfwKo/wZVpmL2CvPka/D
         zlew==
X-Gm-Message-State: AOAM530zGMqkueE4X0RSW+LdsFBm0A9/1CKewTbef3/BsTZGprfqQGeR
        c89+yHQYF4mIKwKjcNF5llyJdw==
X-Google-Smtp-Source: ABdhPJwvzgeSdJcrtxTGMJHdnVV6X0IUmVnL7VA3YCvWPP2b5bFtHiUuZeTmlJ7vO7VCqt9hvQY3Jg==
X-Received: by 2002:a19:f619:: with SMTP id x25mr3379468lfe.469.1612248728577;
        Mon, 01 Feb 2021 22:52:08 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id b26sm2535171lff.162.2021.02.01.22.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 22:52:08 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next 0/7] GTP
Date:   Tue,  2 Feb 2021 07:51:52 +0100
Message-Id: <20210202065159.227049-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's ongoing work in this driver to provide support for IPv6, GRO,
GSO, and "collect metadata" mode operation.  In order to facilitate this
work going forward, this short series accumulates already ACK:ed patches
that are ready for the next merge window.

All of these patches should be uncontroversial at this point, including
the first one in the series that reverts a recently added change to
introduce "collect metadata" mode.  As that patch produces 'broken'
packets when common GTP headers are in place, it seems better to revert
it and rethink things a bit before inclusion.

/Jonas

Jonas Bonn (7):
  Revert "GTP: add support for flow based tunneling API"
  gtp: set initial MTU
  gtp: include role in link info
  gtp: really check namespaces before xmit
  gtp: drop unnecessary call to skb_dst_drop
  gtp: set device type
  gtp: update rx_length_errors for abnormally short packets

 drivers/net/gtp.c                  | 540 +++++++++--------------------
 include/uapi/linux/gtp.h           |  12 -
 include/uapi/linux/if_link.h       |   1 -
 include/uapi/linux/if_tunnel.h     |   1 -
 tools/include/uapi/linux/if_link.h |   1 -
 5 files changed, 158 insertions(+), 397 deletions(-)

-- 
2.27.0

