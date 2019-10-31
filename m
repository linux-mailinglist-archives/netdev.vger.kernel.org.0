Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0547EEB48E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfJaQTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:19:42 -0400
Received: from plaes.org ([188.166.43.21]:34782 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfJaQTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 12:19:42 -0400
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id 787DD404A6;
        Thu, 31 Oct 2019 16:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1572538780; bh=l3zqhRz3MXLgYaz06UXpXX6TG/GU0lHnMs/TZoipX9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kEHlxeI2zoUtKesfSGjg7a9zvFz3uSKIu0SDDHQ1A0o4a5aMsvuE3I1OBBAeiSyX6
         W38qXq6D0uFrZZl43zEXLzt2FSwrTwRpd5hAoxwrSXrxAvmp5qoLcaBiI/VN+cDqz6
         DvnVDYAfsnHEV8PI7Yk+zMGHSsRuziEsnjLCswe7jm1mSeV6LyZc1jta1cdCqSs57B
         u6rCp+QaSOPHuDEm97Ecdvv5Ps7+6NElCMH529NLdaOCh4VhDvxgHxifGwGR5iFzL1
         NTgGFZr8XImHZXwUzyaS/iMnoWZorG9Gu4z9KsthNCdHlnDaKY8Ya7topq8FHapmMO
         0v9nk1767LP7g==
Date:   Thu, 31 Oct 2019 16:19:39 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-sunxi@googlegroups.com, wens@csie.org,
        netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Subject: Re: sun7i-dwmac: link detection failure with 1000Mbit parters
Message-ID: <20191031161939.GA12834@plaes.org>
References: <20191030202117.GA29022@plaes.org>
 <20191031130422.GJ10555@lunn.ch>
 <20191031131404.GK10555@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031131404.GK10555@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 02:14:04PM +0100, Andrew Lunn wrote:
> On Thu, Oct 31, 2019 at 02:04:22PM +0100, Andrew Lunn wrote:
> > On Wed, Oct 30, 2019 at 08:21:17PM +0000, Priit Laes wrote:
> > > Heya!
> > > 
> > > I have noticed that with sun7i-dwmac driver (OLinuxino Lime2 eMMC), link
> > > detection fails consistently with certain 1000Mbit partners (for example Huawei
> > > B525s-23a 4g modem ethernet outputs and RTL8153-based USB3.0 ethernet dongle),
> > > but the same hardware works properly with certain other link partners (100Mbit GL AR150
> > > for example).
> > 
> > Hi Pritt
> > 
> > What PHY is used? And what happens if you use the specific PHY driver,
> > not the generic PHY driver?
> 
> Schematics of the board are here:
> 
> https://github.com/OLIMEX/OLINUXINO/blob/master/HARDWARE/A20-OLinuXino-LIME2/1.%20Latest%20hardware%20revision/A20-OLinuXino-Lime2_Rev_K2_COLOR.pdf
> 
> So it has a KSZ9031. The micrel driver supports that device. And there
> is a patch which might be relevant:
> 
> commit 3aed3e2a143c9619f4c8d0a3b8fe74d7d3d79c93
> Author: Antoine Tenart <antoine.tenart@bootlin.com>
...
> Please test using the Micrel PHY driver and see if that solves your
> problem.

Thanks, CONFIG_MICREL_PHY=y helped!

> 
> 	Andrew
