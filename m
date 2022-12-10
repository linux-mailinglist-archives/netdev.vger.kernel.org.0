Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D5F64911F
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 23:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLJWwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 17:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJWwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 17:52:08 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A21E22D;
        Sat, 10 Dec 2022 14:52:06 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id fc4so19434659ejc.12;
        Sat, 10 Dec 2022 14:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fs0w8x3eRKaXQuvD4TDdN0ceHq7te0SPonwI+xQedyI=;
        b=hQbbvv1EtePxSJDgdlXZTwNzuO/6ichTYYRDKj8ihdrB3BUsgA2IBjsYKmk1bTRugX
         FRFRKDqyvxrShQF9/jbzwQFaIkF57qZydUIVtfKKz9Re1V71tSP69BURp5C4Je/sX1lM
         U+bu6NP+L+sesA6gffjyQxsjS86t3pK0fTqcWPTAspzkfMNyQDxgETuPX7jA4eKGe0/F
         BLoX+KNSvylsaHdEEI0mz47Urk9hNc5frIeKzDfFE8wxaIBGl/3OKcrOBt+l6mWLmCdi
         fEUauL4lQf3iGwgYi719VYZ4vmpcKpDCCTBt3qUd/n3Jv8XYJAnTosSZN6gVhYgk6x7h
         T93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fs0w8x3eRKaXQuvD4TDdN0ceHq7te0SPonwI+xQedyI=;
        b=XQhrW7R8bx8BK2MFmUuT6b8E6x4G54Az1fr4vI15jf1r4cOgMjuwufxvxQCe/DfvEv
         wQGM0AVhambNbhI77ALW1/J0msNzaSrgbsAd+8cEu5ToeF5eN5lf93EaKav92MkuGRsv
         99u2P9V63kIWkgMtqBDVvTzKVHPo5LLxQfLOLQXsZZNmCjTpe6CHbW4O4Wm78lYy0T6I
         3BfBnwm4wkvYmofJHj7GiNaw9inEFp7DEaP40bj6foIlRZGGHmgJEwfwxKP67Im8J7R3
         PkMf7NKbMp5VqVT9sx+mK3dZqeKSxOBJZt0iXfAwXgqV8zljVOG/Ju0VtbzsJ6X12c3E
         EiJQ==
X-Gm-Message-State: ANoB5pltlWz7zcAEYZj3pn+ZgLLRrJ2Qa/Wg9nnuouMcGeT3PqOvBJUo
        1crKk2l+uRuTuKvx3ghNrTw=
X-Google-Smtp-Source: AA0mqf6qVBwA3eGG0rOiWFplObw6ZFofpspBvRL4I8hJNhhZxR+mwT0tZq9gCCt6j9SHA2JEyQK1Bg==
X-Received: by 2002:a17:906:bccf:b0:7c1:11fd:9b98 with SMTP id lw15-20020a170906bccf00b007c111fd9b98mr9011733ejb.27.1670712724619;
        Sat, 10 Dec 2022 14:52:04 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id w18-20020aa7d292000000b0044ef2ac2650sm2118628edq.90.2022.12.10.14.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 14:52:04 -0800 (PST)
Date:   Sat, 10 Dec 2022 23:52:03 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v3 ethtool-next 0/2] add support for PLCA RS
Message-ID: <cover.1670712544.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the IEEE802.3cg-2019 Clause 148 PLCA
Reconciliation Sublayer. It adds get/set configuration and get status
functions. Additionally, shows PLCA capabilities and status when invoked
without arguments.

Piergiorgio Beruto (2):
  update UAPI header copies
  add support for IEEE 802.3cg-2019 Clause 148 - PLCA RS

 Makefile.am                  |   1 +
 ethtool.c                    |  21 +++
 netlink/extapi.h             |   6 +
 netlink/plca.c               | 295 +++++++++++++++++++++++++++++++++++
 netlink/settings.c           |  89 ++++++++++-
 uapi/linux/ethtool.h         |   3 +
 uapi/linux/ethtool_netlink.h |  39 +++++
 7 files changed, 452 insertions(+), 2 deletions(-)
 create mode 100644 netlink/plca.c

-- 
2.37.4

