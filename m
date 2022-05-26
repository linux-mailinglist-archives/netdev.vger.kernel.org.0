Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338FF534DA4
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiEZK67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 06:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiEZK65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 06:58:57 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F088CEB87;
        Thu, 26 May 2022 03:58:53 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24Q99OE6022048;
        Thu, 26 May 2022 03:57:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pfpt0220; bh=ivqjH5toYJSfs0wcoHW14DPOTzybjgWJFjAhcoJ5Ot8=;
 b=WWXJORHL3UuzuxMgiyL/psVfQBsXxqEPvg+WhY5d+xONwMi83X+0Fj3LzaZOxnw9w/Ro
 D9XGCQ3B23TM4BEBLXTGmBXN6AoGAwplmFGg5VL3c/X8kU9w5PovnpkaeCLxBTVStprJ
 2uHa8vm9UVgTY2OKjzoJDzRGDSNTltLBLjBcm/4EnFMrjK+shkQNp9jq10bBH+WiegAq
 EVdVWECzfAdRHSoUPHFhXVhBRXYG2mpvu87X7kCKYY7gNekpx9uQMi2Om+oUBLyA0DIm
 6iPuPsAQWT7a4BB7cHYPznpOKGukMIInn3K8p+ydUz2x01/28Zvc8wuyqpE2pnLR4UMI rw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3g93ty8cpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 May 2022 03:57:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 26 May
 2022 03:57:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 May 2022 03:57:20 -0700
Received: from Dell2s-9 (unknown [10.110.150.250])
        by maili.marvell.com (Postfix) with ESMTP id DFCD03F70A8;
        Thu, 26 May 2022 03:57:20 -0700 (PDT)
Date:   Thu, 26 May 2022 03:57:20 -0700
From:   Piyush Malgujar <pmalgujar@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chandrakala Chavva" <cchavva@marvell.com>,
        Damian Eppel <deppel@marvell.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
Subject: Re: [PATCH] Marvell MDIO clock related changes.
Message-ID: <20220526105720.GA4922@Dell2s-9>
References: <CH0PR18MB4193CF9786F80101D08A2431A3FC9@CH0PR18MB4193.namprd18.prod.outlook.com>
 <Ymv1NU6hvCpAo5+F@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Ymv1NU6hvCpAo5+F@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: Xjsy_p5LYX-EpN9TEKAnqE8DuqKqtMlY
X-Proofpoint-ORIG-GUID: Xjsy_p5LYX-EpN9TEKAnqE8DuqKqtMlY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_03,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 04:24:53PM +0200, Andrew Lunn wrote:
> > > > 2) Marvell MDIO clock frequency attribute change:
> > > > This MDIO change provides an option for user to have the bus speed set
> > > > to their needs which is otherwise set to default(3.125 MHz).
> > > 
> > > Please read 802.3 Clause 22. The default should be 2.5MHz.
> > > 
> > 
> > These changes are only specific to Marvell Octeon family.
> 
> Are you saying the Marvell Octeon family decide to ignore 802.3?  Have
> you tested every possible PHY that could be connected to this MDIO bus
> and they all work for 3.125MHz, even though 802.3 says they only need
> to support up to 2.5Mhz?
> 
>      Andrew

Hi Andrew,

Yes, but as for Marvell Octeon family it defaults to 3.125 MHz and this
driver is already existing in the kernel.
This patch is not changing that, only adding support to configure
clock-freq from DTS.
Also, following PHYs have been verified with it:
PHY_MARVELL_88E1548,
PHY_MARVELL_5123,
PHY_MARVELL_5113,
PHY_MARVELL_6141,
PHY_MARVELL_88E1514,
PHY_MARVELL_3310,
PHY_VITESSE_8574

Thanks,
Piyush
