Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E028A26689E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgIKTQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgIKTQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 15:16:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ACEC061573;
        Fri, 11 Sep 2020 12:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MSOm+YhchPha/Ywmk8Mz5tDd4CRt8uyIKrb/F7L6VkQ=; b=dcbfvu40/uDPgGemP/ebXWg8J
        dkdeKiZqGjO1M9rgsVaISsjDyMIrDnYWGcyKn15NWLScRgrFuGsD8B5Vde3nF+mfHPgJ+ofIrMgk8
        V+OdvFVaR453LxTdfDUNxAwqEbLuaupXABE5FDnHEV9NNp1JKg10v6cPVu22YQzfKHZ4n5YbE8gLc
        Uro86Snbh98nIe86506kZ4UcgEnemuSk0m1KVBaWZXUiPKc86qQ/IY85nQ8XZy60DX9EaGHLo+N9R
        UMdSQbLaqIEZ4HLVDAroUMwdEi3Qyg31xfaoErVpEPxHTntBCLFP7E0HCVq9651+RSBo8KUV91aE8
        P0BGGHXsg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33022)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kGoWt-0007qX-2c; Fri, 11 Sep 2020 20:16:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kGoWq-0008R2-Fy; Fri, 11 Sep 2020 20:16:12 +0100
Date:   Fri, 11 Sep 2020 20:16:12 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net: mvpp2: Initialize link in
 mvpp2_isr_handle_{xlg,gmac_internal}
Message-ID: <20200911191612.GH1551@shell.armlinux.org.uk>
References: <20200910174826.511423-1-natechancellor@gmail.com>
 <20200910.152811.210183159970625640.davem@davemloft.net>
 <20200911003142.GA2469103@ubuntu-n2-xlarge-x86>
 <20200911111158.GF1551@shell.armlinux.org.uk>
 <20200911082236.7dfb7937@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200911160101.GA4061896@ubuntu-n2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911160101.GA4061896@ubuntu-n2-xlarge-x86>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 09:01:01AM -0700, Nathan Chancellor wrote:
> On Fri, Sep 11, 2020 at 08:22:36AM -0700, Jakub Kicinski wrote:
> > On Fri, 11 Sep 2020 12:11:58 +0100 Russell King - ARM Linux admin wrote:
> > > On Thu, Sep 10, 2020 at 05:31:42PM -0700, Nathan Chancellor wrote:
> > > > Ah great, that is indeed cleaner, thank you for letting me know!  
> > > 
> > > Hmm, I'm not sure why gcc didn't find that. Strangely, the 0-day bot
> > > seems to have only picked up on it with clang, not gcc.
> > 
> > May be similar to: https://lkml.org/lkml/2019/2/25/1092
> > 
> > Recent GCC is so bad at catching uninitialized vars I was considering
> > build testing with GCC8 :/
> 
> It is even simpler than that, the warning was straight up disabled in
> commit 78a5255ffb6a ("Stop the ad-hoc games with -Wno-maybe-initialized").

Great, so now rather than getting false positive warnings, we now
get buggy code. That sounds like a good improvement to me.

Not.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
