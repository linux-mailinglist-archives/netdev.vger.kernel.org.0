Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6485C2A1DE8
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgKAMdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgKAMdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:33:21 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AC8C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 04:33:21 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id b3so5485715wrx.11
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 04:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wpE/Qw5vzBCGQoUPotJLVkW5r32KD2vRuICL3bKyJCc=;
        b=mkD5SuZ6ZYA3rkLX76bqSAxutep22QqafXXFygGLtfDAxgJUmaGLYUB2QhaRlHP+7K
         cY7fFGqqdv7/3Iqg8YoWJ313kDc0wBfqOFFhmQ/4NNI8LkvCaNX2ncJ93phubgCIPiYs
         /2RAwBvLdQO51+RFwOKaU2s4q81i7NSg0lIDgslzknuK4mXNGcTIq3ThalLbh4LLADff
         MnCy8DuXTwZn5F9WNQXAElA+uBoTnWm4CcteIC7Sobvhm4fjOibGdNXqOm4yzZKu5UZr
         wa791KFLxYubfXa5FRf1o+h3BUyCy6t3X+u0HWBWnlYnySHDbsXFL/I7UphgkgSD24X8
         yPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wpE/Qw5vzBCGQoUPotJLVkW5r32KD2vRuICL3bKyJCc=;
        b=DtE+OcJnAjhUq0sjiqlJot1NWJ+b4EwDLTft72r7kVhtsmsPzBRJASQrzp4elGUVnP
         6XbP2+yG+zZkUICdYwRuN6ohU9miR6VK2SqfoY6mFU6GIbjLNTSJQd+yCibevWpWfSnK
         KjP19UQVxgB8kIRkNYVctlF5e08EcHDxjKvaS6bYzZlp4OJIIRDZdooB3sWqiXO50j75
         KEktByz6tcno3A8JeWxhybyWxZWA5tww1uyVc1q1Cx1ZGi5M4QADbdku1qvl/YhaPR/n
         TTgRSNZ8KVocmIAUSS/litf7XQ+bh+9BE/xYw9/Qq1l4VJ1BOz1KZn+BumGu88pro60o
         Xu7g==
X-Gm-Message-State: AOAM532gmrmurt3Nr7fopDpZPF2J8UAfNk2OHTdYu0bDXgGoWF1AFNQA
        wVjvS5x9q5sTGMLHRGCs5WnKKovza6g=
X-Google-Smtp-Source: ABdhPJwThHaeCfGdKO9iZubaPLKZM9g9vvpZN7nSEWSJYx0iqDr3ab1W5JtQB35PLCRKdnx8F2U6bA==
X-Received: by 2002:adf:dd09:: with SMTP id a9mr14512134wrm.208.1604233999353;
        Sun, 01 Nov 2020 04:33:19 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:dc4f:e3f6:2803:90d0? (p200300ea8f232800dc4fe3f6280390d0.dip0.t-ipconnect.de. [2003:ea:8f23:2800:dc4f:e3f6:2803:90d0])
        by smtp.googlemail.com with ESMTPSA id s9sm20431280wrf.90.2020.11.01.04.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 04:33:18 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/5] net: add and use dev_get_tstats64
Message-ID: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
Date:   Sun, 1 Nov 2020 13:33:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a frequent pattern to use netdev->stats for the less frequently
accessed counters and per-cpu counters for the frequently accessed
counters (rx/tx bytes/packets). Add a default ndo_get_stats64()
implementation for this use case. Subsequently switch more drivers
to use this pattern.

Heiner Kallweit (5):
  net: core: add dev_get_tstats64 as a ndo_get_stats64 implementation
  net: make ip_tunnel_get_stats64 an alias for dev_get_tstats64
  ip6_tunnel: use ip_tunnel_get_stats64 as ndo_get_stats64 callback
  net: dsa: use net core stats64 handling
  tun: switch to net core provided statistics counters

 drivers/net/tun.c         | 127 ++++++++++----------------------------
 include/linux/netdevice.h |   1 +
 include/net/ip_tunnels.h  |   4 +-
 net/core/dev.c            |  15 +++++
 net/dsa/dsa.c             |   7 +--
 net/dsa/dsa_priv.h        |   2 -
 net/dsa/slave.c           |  29 +++------
 net/ipv4/ip_tunnel_core.c |   9 ---
 net/ipv6/ip6_tunnel.c     |  32 +---------
 9 files changed, 58 insertions(+), 168 deletions(-)

-- 
2.29.2

