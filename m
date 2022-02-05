Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5FA4AA65A
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379228AbiBEEDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:03:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57492 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbiBEEC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:02:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39EE861182;
        Sat,  5 Feb 2022 04:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4053CC340E8;
        Sat,  5 Feb 2022 04:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644033778;
        bh=c3EdVIr+qi9Rx5v8/PHg5sm7wCbJ8Yeb5ODBDIoL6n4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p+NtqexJKDbSUr+I10mtVeNBMbz7msVPlFS/AQF5VrRVnF2yWSK+PVRS64E/f66e7
         7rI2eG5IMe/4wtqveNffMgtILn/MCjeVVTPR33Jxtxqfsn9m5o9MF2ffT+/wi7iE7F
         ZnrzXLPp1LBQA/uXYUbVUSYLDN7dthhJHH9AqVUWRW/riqiN//P5f1eRtDW4iK1MbQ
         JlE0rf1UluIvMYViQj6ZnCL64JuwQuRo6ABWrs1m/SCrhrAL6pfKaoQK7u+2f/XOI6
         N51c5bo60QqRubHiY1arsJpTvgFdJOdpTo6prBDASJzj7s0HiIGN3SvfUsA1mVGy/O
         TyUrOFPMc9saQ==
Date:   Fri, 4 Feb 2022 20:02:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Pavel.Parkhomenko@baikalelectronics.ru>
Cc:     <michael@stapelberg.de>, <afleming@gmail.com>,
        <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <Alexey.Malahov@baikalelectronics.ru>,
        <Sergey.Semin@baikalelectronics.ru>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Message-ID: <20220204200256.641d757b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 05:29:11 +0000
Pavel.Parkhomenko@baikalelectronics.ru wrote:
> It is mandatory for a software to issue a reset upon modifying RGMII
> Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
> Specific Control register 2 (page 2, register 21) otherwise the changes
> won't be perceived by the PHY (the same is applicable for a lot of other
> registers). Not setting the RGMII delays on the platforms that imply
> it's being done on the PHY side will consequently cause the traffic loss.
> We discovered that the denoted soft-reset is missing in the
> m88e1121_config_aneg() method for the case if the RGMII delays are
> modified but the MDIx polarity isn't changed or the auto-negotiation is
> left enabled, thus causing the traffic loss on our platform with Marvell
> Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
> delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
> method.
> 
> Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
> Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
> Reviewed-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Appears not to apply to net, please rebase on top of:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

and repost (do keep Russell's tag and address Andrew's question).
