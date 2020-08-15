Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35CD2452A0
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgHOVxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgHOVwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:52:40 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C7DC004585
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 11:24:03 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id v13so11159783oiv.13
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/WD7gDl+XCmPqlIM7nO2KOimmNxRDcsCujVimXn1HcY=;
        b=g4DTmlN0AX+cftqo1QEpMKcjQk7ZLxWak6EyvPZavjAmBIk8W1XU8uNdWZCTLi1DW6
         DVT6Hhi6wWp4aBdUSYuGixUeEKS0TAC+Cttb3icJugW6uKVYJcwIWLbU6HY9ZpjqRk93
         TJivnlGJ5p2LOhQabFmwvkVDTnN1kZQuXElbRNiIA5/Lq7bimj65Y2kxx92n0v/XcQzc
         KJXsSBW1G4fZGw+G4fxmPBgSuBhW2sI2qFaeni0qQfISXO6Fpa8oJwoOnkwr2xdukwJj
         q88RPcEN0CeiSwHbpisoTCWPyghNabqi4ZRUUqqVtogrSGbuGQKNp61Y5oEZSTC1KHEJ
         dVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/WD7gDl+XCmPqlIM7nO2KOimmNxRDcsCujVimXn1HcY=;
        b=rbw0fpnqh3nnYnOLpi75zg52qnbyqsQmj8dgrGKNzv7AnybkhiLzMK9hfkxhwWtO1U
         3eQ9HPZtpTak3B5Z1ajNwRss50BXRbl0gduVj0FTqyabUuCYoXsT2AUJtpFvuX2Zf1CF
         EIsV0rSX1+gGdoNjHy57NybpCsjGxoYx/34QM8K6cB/qa2/kYtL+V30WyDVzBQsErZNZ
         pfNYFGdjaWFKzsqi2j+qKA1E8ZRpcC3o/+pyib+ltejGS1dIJprJzb/DfNv+W0++dbRz
         aEQVWhs9Vqy29uJhLK4yRWy6+O5DUZKKp/gaWMWYuvqWCDwC6HtIXMmbKHlDx+8rYSwE
         QnSw==
X-Gm-Message-State: AOAM533pDVpN92alDbdAeBX+90G/HZDi9G+1pg2fIi4env3DpDcEykWR
        Z0C/iqf/JZkwB/oTmB6nUpoz4w==
X-Google-Smtp-Source: ABdhPJxqwP+YD3muYShKpb0m6VaIwQRrEiPMwvh26QMq87kIaKeWCvE0KzX/JwlMmukEVl0cU0TLwg==
X-Received: by 2002:aca:e144:: with SMTP id y65mr4848449oig.101.1597515841901;
        Sat, 15 Aug 2020 11:24:01 -0700 (PDT)
Received: from foo.attlocal.net (108-232-117-128.lightspeed.sntcca.sbcglobal.net. [108.232.117.128])
        by smtp.gmail.com with ESMTPSA id z72sm2397820ooa.42.2020.08.15.11.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 11:24:01 -0700 (PDT)
From:   Pascal Bouchareine <kalou@tfz.net>
To:     linux-kernel@vger.kernel.org
Cc:     linux-api@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Pascal Bouchareine" <kalou@tfz.net>
Subject: [RFC PATCH 0/2] proc,socket: attach description to sockets
Date:   Sat, 15 Aug 2020 11:23:42 -0700
Message-Id: <20200815182344.7469-1-kalou@tfz.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checking to see if this could fit in struct sock.

This goes against v5.8

I tried to make it tl;dr in commit 2/2 but motivation is also described
a bit in https://lore.kernel.org/linux-api/CAGbU3_nVvuzMn2wo4_ZKufWcGfmGsopVujzTWw-Bbeky=xS+GA@mail.gmail.com/

