Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAA65967A6
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 05:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbiHQDEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 23:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiHQDEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 23:04:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528FB9A9B8;
        Tue, 16 Aug 2022 20:04:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E52086149B;
        Wed, 17 Aug 2022 03:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C692FC433C1;
        Wed, 17 Aug 2022 03:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660705489;
        bh=hoCcUCDekBnv7uptRjLsaq3Oa8ABTbxOy7tabbuoeEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uxt5FAkslwdPocR18ObNyzePZxlC25vZ/FVvm7uSkQPBkd48TkOAyGCVpyhnN+IVm
         CaZYsqCqh9K0jpJK1gf0s7JKdwqzQXi4xi1PCYfS8IYfsMMlMuzt96EpT7gXydSMce
         2buYLdZLbEe4O6kRqEr39L1BLWwAv1FPBOGJzp35Xm6IeDZLuTAAegMmgHpuY9iCta
         jtx7dRmIg/SmuBAdMW2K4nR69Re5Hulmv0MY2E+wmvffPsPUG+Q1yi4cWuSMQS3R3l
         h9od2mLOSp95Tca3Ex/PogKiM8Bhi89gOI5knkaY52+PKjwanEWKZwmdSqVa40YfH6
         d/JrPq23N8iTQ==
Date:   Tue, 16 Aug 2022 20:04:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.3] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet phy
Message-ID: <20220816200447.0f9ebb7b@kernel.org>
In-Reply-To: <20220816111703.216-1-Frank.Sae@motor-comm.com>
References: <20220816111703.216-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 19:17:03 +0800 Frank wrote:
>  Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have verified
>  the driver on StarFive VisionFive development board, which is developed by
>  Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit ethernet
>  phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, and
>  wol(magic package).

Clang reports:

drivers/net/phy/motorcomm.c:1121:6: warning: variable 'changed' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
        if (err > 0)
            ^~~~~~~
drivers/net/phy/motorcomm.c:1124:47: note: uninitialized use occurs here
        return genphy_check_and_restart_aneg(phydev, changed);
                                                     ^~~~~~~
drivers/net/phy/motorcomm.c:1121:2: note: remove the 'if' if its condition is always true
        if (err > 0)
        ^~~~~~~~~~~~
drivers/net/phy/motorcomm.c:1095:18: note: initialize the variable 'changed' to silence this warning
        int err, changed;
                        ^
                         = 0
