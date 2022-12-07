Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD5064500F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiLGAOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLGAOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:14:15 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1513A4AF11;
        Tue,  6 Dec 2022 16:14:13 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id a16so22674305edb.9;
        Tue, 06 Dec 2022 16:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FjD33XBCjBjlL9V3wxoPhJx57MGOAvENyDvWmnhM+3w=;
        b=RqqJiXUZXF62miMji1tNuYVWTfQ69wB0RwVJLPqHpFZ+T8QiwFlYc/PxnJerEFmpFv
         8x52x6s+v+Gj33zN+mq0H9VshcX7oom7x3bJF9l8bQ8/3JGYIrbfUKpCOgHSBYXD78UE
         6qTxPIgERgPrKQG0hLeQbmp42jm8wOB3Iso3wwKbS3O+HjgEYfTWYi46G80r5GCBP98d
         q8quSymsFjWoTHbgxSPnOCh/V5x+2hPW6pXu6hl1zhbB545HlFke0QJTuQasT7duScS2
         vYj5Uq1AhyiGE6EZ7EvfJ+T23VFdN1Rfhs5SPpYY9wVPsjT+fXI0L4VKPzbjxMrSVTM3
         jgFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjD33XBCjBjlL9V3wxoPhJx57MGOAvENyDvWmnhM+3w=;
        b=8JCLSzr8r8hAqL/bqJQpDII4gwUSnB93kzYZANoZehwvB0sWa9thBbhO5FpXA8SEHo
         HEjPTTfjgDu80YU50DlQemJxxBuxRVYI6A2GK7767+CwnoaiplpPCXpUasBPDklCgQYM
         BgZCMARaPMXsy1RDvm0UitIuoBBF4QesL0SLMZv8WxdTbBxp8zInDZmYEQIXrfGybuGn
         p/fYUCdhtuNkFRWoiw/S0juMNaoUI3Y6KqA4SEZKxd5XZF3UisCgJyxJ0r3+fJD/JDM0
         Y60TwMPZMsCVHHwJ00/ZJiY/pDwqf20l6M+96QJ7WgDAGsn9PMXJy5rBxt8Tkz8VtOT+
         2qug==
X-Gm-Message-State: ANoB5pmDxwh/xCAJc1CtMVJdnyLzvE0qFjOwrc8adP+aQhCXALUnORbT
        DyoITNCYMjqqJpCBaPROxA0=
X-Google-Smtp-Source: AA0mqf7uKtpD++c9M56H3huPpf+6c7y4tqQc20X591VIjN8ORWgB8OkkadLjPaBdNMh6mj2xuJQILw==
X-Received: by 2002:aa7:da01:0:b0:46b:9f6e:4005 with SMTP id r1-20020aa7da01000000b0046b9f6e4005mr28156064eds.203.1670372051636;
        Tue, 06 Dec 2022 16:14:11 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id v6-20020a170906180600b007c0c679ca2fsm5496664eje.26.2022.12.06.16.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 16:14:10 -0800 (PST)
Date:   Wed, 7 Dec 2022 01:14:21 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v2 ethtool-next 0/2] add support for PLCA RS
Message-ID: <cover.1670371908.git.piergiorgio.beruto@gmail.com>
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
 netlink/plca.c               | 304 +++++++++++++++++++++++++++++++++++
 netlink/settings.c           |  89 +++++++++-
 uapi/linux/ethtool.h         |   3 +
 uapi/linux/ethtool_netlink.h |  39 +++++
 7 files changed, 461 insertions(+), 2 deletions(-)
 create mode 100644 netlink/plca.c

-- 
2.35.1

