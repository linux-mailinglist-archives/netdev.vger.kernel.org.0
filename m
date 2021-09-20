Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89F04114DF
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbhITMvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbhITMvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:51:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9537DC061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 05:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zPbk7FSzoDNjkUglXnkYbQsblfsq5zLr1n7fNPKCYI8=; b=1rfo8yqR11OR1uPNFPpoiWblGP
        G8rr7FvWvm8S2rRA+/1XHHCKS89Up+Xw7I2nj5GFDEEvA8aiYss9hfJg97TI+YjiaQkPM1qnI1gmj
        m17k68bmqGBV7RRHE/S70aiO4BnmoH5BCfWb40AtCGzCrhsxWY7BwcpFTi21DpdxGig2yPXPCeefT
        SIeJLzfnCu4QoiHMnphlp6s3VjohUpzrptOFtKapNDv9GPqqgHrHf894PGKPt0Ezui6dk4fh6Q4E8
        +NtTXFWxPLyCGg3gCqmUJSe1700IiFA71fqEBA+q8bxDNxUJ0EAvvUokq6V4sDIy3mwRxnm5r7iAk
        MgxvMlwA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54668)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mSIje-0001dE-FM; Mon, 20 Sep 2021 13:49:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mSIjb-0002J2-6X; Mon, 20 Sep 2021 13:49:23 +0100
Date:   Mon, 20 Sep 2021 13:49:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sched: fix initialiser warning in sch_frag.c
Message-ID: <YUiDU9mT71M8r7E6@shell.armlinux.org.uk>
References: <E1mS5U9-002wsa-TC@rmk-PC.armlinux.org.uk>
 <YUhPpaas69u4vZdp@dcaratti.users.ipa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUhPpaas69u4vZdp@dcaratti.users.ipa.redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:08:53AM +0200, Davide Caratti wrote:
> On Sun, Sep 19, 2021 at 11:40:33PM +0100, Russell King (Oracle) wrote:
> > Debian gcc 10.2.1 complains thusly:
> > 
> > net/sched/sch_frag.c:93:10: warning: missing braces around initializer [-Wmissing-braces]
> >    struct rtable sch_frag_rt = { 0 };
> >           ^
> > net/sched/sch_frag.c:93:10: warning: (near initialization for 'sch_frag_rt.dst') [-Wmissing-braces]
> > 
> > Fix it by removing the unnecessary '0' initialiser, leaving the
> > braces.
> 
> hello Russell, thanks a lot for reporting!
>  
> > diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
> > index 8c06381391d6..ab359d63287c 100644
> > --- a/net/sched/sch_frag.c
> > +++ b/net/sched/sch_frag.c
> > @@ -90,7 +90,7 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
> >  	}
> >  
> >  	if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
> > -		struct rtable sch_frag_rt = { 0 };
> > +		struct rtable sch_frag_rt = { };
> 
> this surely fixes the -Wmissing-braces, but then -Wpedantic
> would complain about usage of GNU extension (I just tried on godbolt
> with x86_64 gcc 11.2):
> 
> warning: ISO C forbids empty initializer braces [-Wpedantic]
> 
> While we are fixing this, probably the best thing is to initialize the
> 'dst' struct member  to 0: in my understanding this should be sufficient
> to let the compiler fill all the struct members with 0.
> 
> Oh, and I might have inserted a similar thing in openvswitch kernel
> module (see [1]), if you agree I will send a patch that fixes this as
> well. WDYT?

ISO C may forbid it, but the kernel build uses -std=gnu89 - which is
c89 with GNU extensions. One of the GNU extensions is to allow the
empty initialiser, which means "initialise all members of this struct
to zero".

However, as I say, this was found using gcc 4.9.4 under 5.14, where
4.9.4 is a permissable compiler. However, under 5.15-rc it is no
longer so the patch should not be applied to development kernels.
It leaves the question open whether it should be fixed in stable or
not, since stable kernels _do_ permit gcc 4.9.4.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
