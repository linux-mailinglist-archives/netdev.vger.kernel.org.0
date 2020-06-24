Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21C1207005
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389317AbgFXJ30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388336AbgFXJ3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:29:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D88C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 02:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IkSikJ2zD0ApB1TF3OqT7Ky1kAfvqjeSmYPD0vUYKaM=; b=zMbKSD6WFzUSSw//1Wd6PbWAh
        AvQ/sBR7sFaos+coL74sTOV0ZswYLws4ok621gvDBPfuVBzlWwCvSCwEkYwPIKE9nQUVNwPCzI1vP
        aHrEV+GgmDmin+NBlK9KsQgN45+f8Hrb1RTe4MypI5RPUnX1CPdDKhDuYd0iWn69hTtAcSzAMtKmy
        90qIIzfPBy3Iv24LIu6Y24JxaN9wOGN/eED2SGPCxLox1UQ4MvJpcj+eYApZbluMdebnUbThKZdE5
        iWnegWyUFbKSrYOHFvMD503WUcRjWJzTPFm3ViL36FjqZeEbs7v9bV/SOOHQJD9joIqjafrapJ6mE
        t0VcmPdbw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59048)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jo1iZ-0002o0-Hd; Wed, 24 Jun 2020 10:29:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jo1iV-0001pI-SW; Wed, 24 Jun 2020 10:29:15 +0100
Date:   Wed, 24 Jun 2020 10:29:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
Message-ID: <20200624092915.GW1551@shell.armlinux.org.uk>
References: <3268996.Ej3Lftc7GC@tool>
 <20200521151916.GC677363@lunn.ch>
 <20200521152656.GU1551@shell.armlinux.org.uk>
 <CABwr4_vdWWRBMXeK9uGLnuK++9uuM_FBygypv_2PhCRnsOEcEA@mail.gmail.com>
 <20200605094910.GI1551@shell.armlinux.org.uk>
 <CABwr4_u-UiJE5StOOREjAyMKSckisLSQSuFMCaQ7f9Vs8kx54g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABwr4_u-UiJE5StOOREjAyMKSckisLSQSuFMCaQ7f9Vs8kx54g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Sun, Jun 07, 2020 at 02:25:11AM +0200, Daniel González Cabanelas wrote:
> Hi Russell,
> 
> El vie., 5 jun. 2020 a las 11:49, Russell King - ARM Linux admin
> (<linux@armlinux.org.uk>) escribió:
> >
> > On Thu, May 21, 2020 at 05:55:19PM +0200, Daniel González Cabanelas wrote:
> > > Thanks for the comments.
> > >
> > > I'll look for a better approach.
> >
> >
> > Hi Daniel,
> >
> > I've just pushed out phylink a patch adding this functionality. I'm
> > intending to submit it when net-next re-opens. See:
> >
> > http://git.armlinux.org.uk/cgit/linux-arm.git/patch/?id=58c81223e17e39433895cfaf3dbf401134334779
> >
> 
> Thank you.

Are you preparing a patch for mvneta, or are you expecting me to do
that? I'm not able to test WoL on any of my mvneta platforms.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
