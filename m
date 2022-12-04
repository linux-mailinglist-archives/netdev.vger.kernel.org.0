Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8745641A74
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 03:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiLDCh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 21:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLDChx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 21:37:53 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CF526DD;
        Sat,  3 Dec 2022 18:37:51 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id gu23so20022601ejb.10;
        Sat, 03 Dec 2022 18:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NVTd7YblBJw8WVygy8pkP9cYiuGqm/Kx98vGCHEwEQA=;
        b=NWbkdIq1DQi8dtmbz1J8wf4UvEixJ+ZHd6K4HHrvVYspO/zwnz9LLHc1vzSmH/209e
         zsk6biwMCyoJUNrsFxXJhwBwZbst6jEjDqyBWdOWC3EQjfB6xtPQXzIOPbxJ4lnERUNd
         qaUOGAM5E7MTV5lcubXMESwdq4kDrQkgZ2wxAKaZnAPt35PCGDo6zugceaPhd5KqTqNh
         uPN7wRvt1a/TbVlK8bb+wjN2M/FnXMWb+0R69IrizseE+NURSqebAB0kiUS5x/Iyjr88
         L2gOlYuwrha1dT08vWk8U969Ch1pcdsfUQgesKiMBzIkEQN9r68Y9/f15y6KkwJ/CBOe
         e/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVTd7YblBJw8WVygy8pkP9cYiuGqm/Kx98vGCHEwEQA=;
        b=Swwfn5M9FLPSrLcbS2WaCFtdyPVr2GBMt4dHaDci+Lg+yGUsIYBb2+BukwBoSQB5Bl
         jbZEdNtU4V484z2EvoWhms1NpHG62U4is0DXs966za378B42s4lJ5gJOTzvUzVPwk3CA
         RWHGBPg5XRUJCgzu2R9vZGp/8KH0EWNPBMJcDtV0CBDMjpmKgbDXx9ovva2GuN7a5bpB
         7npeP3qQVd8x5CBuOUowPf6xIX5Yxx0Mqm5ElxZtf1VMnzfuLyhs5OXZHibJdmrptB/1
         e3JFi68Ie9YaD9TqcDXgTg9TO/xISZDCsbhgLXaOoRhf7jEhbcjP/ogA0p1bSUHvkKcK
         jPQA==
X-Gm-Message-State: ANoB5pkOXHpO3tXk8TePjj9UedgFyS0rKmImjvdVEAxAh5wonqhfoKBN
        67Oq800VoMLW7E2IgdAtwl4=
X-Google-Smtp-Source: AA0mqf68+z6eaCi/DELLcQB+4YEM2fjjngrWdA7pNXzryEacWmMSSjl4egjYONnxo9b49n+3xRW8Bg==
X-Received: by 2002:a17:906:a843:b0:79e:1059:6d65 with SMTP id dx3-20020a170906a84300b0079e10596d65mr48228468ejb.695.1670121469950;
        Sat, 03 Dec 2022 18:37:49 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090676d200b007c0e23b5615sm769205ejn.34.2022.12.03.18.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 18:37:49 -0800 (PST)
Date:   Sun, 4 Dec 2022 03:37:57 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 0/2] ethtool: add PLCA RS support
Message-ID: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
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

This patchset is related to the proposed "add PLCA RS support and onsemi
NCN26000" patchset on the kernel. It adds userland support for
getting/setting the configuration of the Physical Layer Collision
Avoidance (PLCA) Reconciliation Sublayer (RS) defined in the IEEE 802.3
specifications, amended by IEEE802.3cg-2019.

Piergiorgio Beruto (2):
  Update UAPI files
  Add support for IEEE 802.3cg-2019 Clause 148 - PLCA RS

 Makefile.am                  |   1 +
 ethtool.c                    |  21 +++
 netlink/extapi.h             |   6 +
 netlink/plca.c               | 311 +++++++++++++++++++++++++++++++++++
 netlink/settings.c           |  86 +++++++++-
 uapi/linux/ethtool.h         | 104 ++++++++++--
 uapi/linux/ethtool_netlink.h |  49 +++++-
 uapi/linux/genetlink.h       |   6 +-
 uapi/linux/if_link.h         |  23 ++-
 uapi/linux/netlink.h         |  41 +++--
 uapi/linux/rtnetlink.h       |   8 +-
 11 files changed, 616 insertions(+), 40 deletions(-)
 create mode 100644 netlink/plca.c

-- 
2.35.1

