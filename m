Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6AE6E7E52
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjDSPda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjDSPd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:33:29 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208502697
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:33:28 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4eed6ddcae1so1064981e87.0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1681918406; x=1684510406;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Kk4Em2/bjiRN0fo64MpLKMqZ5YrzI8WC3LxCGbRTBuY=;
        b=Esm9MUX3LpYftuUrciIC7znCvlyyav2a1aC+lPJoCEJ2Myir7DIBxm4mj6aCH8HB8x
         IPFRmV3kkIt+wZWyItkAw/UApoYZwolTyjWVDBhf4HIJIyNx/TunJwvt/GJVMyvNWaEp
         0JgyjJ/G22v0o0QLuySdI4GSGONbVI7THLHDBLsksmuv8t6dy5x1Asfnim2Brn7Ugc1L
         4mYip7GNhABUR4K41NG4NcnxEtvj7nnHf6AnWuqovaIP17Xg2MkgJ8BU/TXKC7P8sNhB
         YWfysMxwC0fedJHEZGKIKUFcCyQbkC7kcabPqma3NNaBL1RZRfqt6MifAGFAfzaLjgix
         aIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681918406; x=1684510406;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kk4Em2/bjiRN0fo64MpLKMqZ5YrzI8WC3LxCGbRTBuY=;
        b=bSvMczcQgj8Vlira5j2IGgbQGAk9PYecIkbAWa1jw9/pCI9Z2NhA5UIUeVfIIeYbex
         EFxZHdkZk1ZoIvOHJRCY0732LkLqRfRBUimQmfUQ3dyg66r3hLhvFK5CAx3sGDVMzhTJ
         7T357lqtdjgG3ATiVQxOsnGD5zE7slQGlkIXKbtWiLXJFHf6fCNftj9tCmlZvSaxwaMa
         rD6SEw6T1FRbAB1zYNr1N3ihfUaCgtpDQ7T8rVSEU52NsbpnMeLlZolIRDTYQOwf6MsR
         eMswU6Jb2ToF20cNTiRtEyC/VI2cFaq0QQDw5fDbf37MKK9ytjvD42D8aNGZvAMtQkcc
         QRYg==
X-Gm-Message-State: AAQBX9dJ5BlLq1gupOE0HehZOcTOfE6r3DeOsdPZlLmtPjdkSuuyfShD
        nXi2hgL+hhny034vONHe0YXlB/fc4B3apT7NBYg=
X-Google-Smtp-Source: AKy350bsR8Nuh0IPb5LpZdSBhZF73It5g0h4T8FX4EA6tZqyBT0XFq0vRY3VaTJunwxbEbsa0LJ9rQ==
X-Received: by 2002:ac2:5e88:0:b0:4ed:d5ce:7dea with SMTP id b8-20020ac25e88000000b004edd5ce7deamr1186363lfq.27.1681918406405;
        Wed, 19 Apr 2023 08:33:26 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id n10-20020a19550a000000b004eed63bc08csm122483lfe.131.2023.04.19.08.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:33:26 -0700 (PDT)
Date:   Wed, 19 Apr 2023 17:33:24 +0200
From:   =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <ZEAJxFs+l3ef2adX@debian>
References: <ZD/Nl+4JAmW2VTzh@debian>
 <03bd17cf-1763-4913-8249-eda6fbc31440@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03bd17cf-1763-4913-8249-eda6fbc31440@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 04:39:13PM +0200, Andrew Lunn wrote:
> On Wed, Apr 19, 2023 at 01:16:39PM +0200, Ramón Nordin Rodriguez wrote:
> > This patch adds support for the Microchip LAN867x 10BASE-T1S family
> > (LAN8670/1/2). The driver supports P2MP with PLCA.
> 
> It is normal to list here what has changed since the last
> version. That gives reviewers an idea what comments have been address,
> and if any have been missed.
> 

Sorry for missing the obvious, is it acceptable to ammend a list of
changes changes in this reply, or would you prefer a V3 submission?

Changes:
    v2:
- Removed mentioning of not supporting auto-negotiation from commit
  message
- Renamed file drivers/net/phy/lan867x.c ->
  drivers/net/phy/microchip_t1s.c
- Renamed Kconfig option to reflect implementation filename (from
  LAN867X_PHY to MICROCHIP_T1S_PHY)
- Moved entry in drivers/net/phy/KConfig to correct sort order
- Moved entry in drivers/net/phy/Makefile to correct sort order
- Moved variable declarations to conform to reverse christmas tree order
  (in func lan867x_config_init)
- Moved register write to disable chip interrupts to func lan867x_config_init, when omitting the irq disable all togheter I got null pointer dereference, see the call trace below:

    Call Trace:
     <TASK>
     phy_interrupt+0xa8/0xf0 [libphy]
     irq_thread_fn+0x1c/0x60
     irq_thread+0xf7/0x1c0
     ? __pfx_irq_thread_dtor+0x10/0x10
     ? __pfx_irq_thread+0x10/0x10
     kthread+0xe6/0x110
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x29/0x50
     </TASK>

- Removed func lan867x_config_interrupt and removed the member
  .config_intr from the phy_driver struct

Testing:
This has been tested with ethtool --set/get-plca-cfg and verified on an
oscilloscope where it was observed that:
- The PLCA beacon was enabled/disabled when setting the node-id to 0/not
  0
- The PLCA beacon is transmitted with the expected frequency when
  changing max nodes
- Two devices using the evaluation board EVB-LAN8670-USB could ping each
  other

Request for comments:
Now that the module has changed name, maybe the funcs lan867x_config_init
and lan867x_read_status should change name to
microchip_t1s_config_init/read_status?


> > Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
