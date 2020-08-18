Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460C9248340
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgHRKnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgHRKnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:43:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A22C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LZ5Cf9jyAK8dSJHBzK3O3wT70LPaPGN8aMdjXe/s9kY=; b=V1dJsk4m7iTwk5AZnRUuqHFWE
        mdY1evc6xDQmHu/Nlpud158Tn5/LNeLAvmV5VQ1qdc6GPOuI+hfePryFLj4IcgvjFK+c3/H+2uF86
        JQS1nf4vUcgI0R0XsYbbFAyePDGfV/sB8PxcKvn1+uVb796bGEIGG4tj5ddFP3zOwBNH60jvK11v7
        p6a1kLBxFZRRahuzl3FeYLuBqFltQXUiUMkuPkxw4iiWcNmkesI51Ug6HWGEHs7URI7VbxOVKGtYp
        kv4eU/zozyHcX1+KWAgp3XYr1bz/CWYkmgp7G2j3aMJGUoLrn8HfhS+rW62/Iq0AbFJJ1ocqP8lIT
        8hN8+pnQA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54022)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k7z57-0000Jl-QP; Tue, 18 Aug 2020 11:43:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k7z57-0001Ld-AG; Tue, 18 Aug 2020 11:43:05 +0100
Date:   Tue, 18 Aug 2020 11:43:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v4 3/9] net: dsa: mv88e6xxx: Use generic helper function
Message-ID: <20200818104305.GB1551@shell.armlinux.org.uk>
References: <20200818103251.20421-1-kurt@linutronix.de>
 <20200818103251.20421-4-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818103251.20421-4-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 12:32:45PM +0200, Kurt Kanzenbach wrote:
> -static int is_pdelay_resp(u8 *msgtype)
> +static int is_pdelay_resp(const struct ptp_header *hdr)
>  {
> -	return (*msgtype & 0xf) == 3;
> +	return (hdr->tsmt & 0xf) == 3;

Forgive my ignorance about PTPv1, but does PTPv1 have these as well?
Is there a reason not to use the helper introduced in patch 2 here?
Should we have definitions for the message types?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
