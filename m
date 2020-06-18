Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99341FFB8F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgFRTKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbgFRTKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:10:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302EBC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QAZjagk/SI5MRG+A4XKOS/lZv5Y5TdDLvSEabVStRKc=; b=G7/4Qs93/ATO7lDa/aW+zJ3EV
        CQAFnyXVApkuCiC2f8uds+srU3xEQBApl3Ii7naHPiYujAV+NDU3jke0zH8sfVI8qdq8pBFZ/Bml5
        qSOML7y/g7nLZVOydcKQxAW1qNjBXgBEslJ/lEOE+BRt0DqCtLhy2AmpTKG3RMO19nWzggHOPEwMQ
        48jsh6mGS5jag4gH/7avDiVxO4z0ysvbT5U181elYI0h6B1Vj02nMYQzttS3UC4cmyeL5LtYG6EVL
        v8jfo8wWrGRWR7P0iCXb9Mh1efHsRtWdXg2XF3HyRM7J4SJxcJnW++ybDaMZIpM5QR8c/IBcwA0Fn
        3CihhEhXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58802)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlzvW-0005XS-M3; Thu, 18 Jun 2020 20:10:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlzvV-0004x3-Qk; Thu, 18 Jun 2020 20:10:17 +0100
Date:   Thu, 18 Jun 2020 20:10:17 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200618191017.GI1551@shell.armlinux.org.uk>
References: <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
 <20200617114025.GQ1551@shell.armlinux.org.uk>
 <20200617115201.GA30172@laureti-dev>
 <20200617120809.GS1551@shell.armlinux.org.uk>
 <20200618081433.GA22636@laureti-dev>
 <20200618084554.GY1551@shell.armlinux.org.uk>
 <91866c2b-77ea-c175-d672-a9ca937835bd@gmail.com>
 <20200618184908.GH1551@shell.armlinux.org.uk>
 <3eb49188-fb74-99fe-a9d9-7e295d2eaa8b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3eb49188-fb74-99fe-a9d9-7e295d2eaa8b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:02:13PM -0700, Florian Fainelli wrote:
> It should not, but that means that when you describe the fixed-link, the
> 'phy-mode' within the local fixed-link node is meant to describe how the
> other side is configured not how you are configured. For some reason I
> did not consider that to be intuitive when I sent out my response, but I
> suppose spelling it out would greatly help.

Right, so in the MAC-to-MAC setup that is being discussed in this
thread, the _local_ side MAC where phy-mode is specified should not
care which of the RGMII modes is specified, because the delays are
a function of "the other side" of the link.

So, the proposal that macb should limit itself to only accepting
"rgmii" in it's _local_ phy-mode property because the _local_ MAC
does not support delays is wrong.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
