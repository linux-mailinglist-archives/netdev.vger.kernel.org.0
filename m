Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF095410DB0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 00:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhISWu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 18:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhISWu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 18:50:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB60C061574
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 15:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=opTTE7PsVA8myzPfZ4WSKUgVye0Zs2gZsnMqTgOV6hw=; b=Uwf2BJ8otgXtOSEBcMQSYcS4RE
        cyJHCl9600vbt78IiEhyR7HWRBPoTXB2BJIUIVJ0sDOdz6/evo/w1Gw/SPbCqqIWl4crJzWXZ+nqh
        jSw6CRCZafJCAPYxDQBDFyGlEfyaKLlzCzmfBXt+2fVsnpztAwKhs422R6Sk+Nyq8Y4gZJQRwRQPs
        sLRv7h2Jnc2wp6NBhi04PGVaHfqiebgd8pB/QxAhu5D5UpT84ykOv50pBhg1LyhM7SmPlZb+PQBhs
        tn9v/cBLEc9lSnWbgxUPoJ8tojXpauRkV5t1IJ8Oempmxxes0Do+qo8+GFbYmhqrKIZ3Z7/uxEr53
        bWGE+FvA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54654)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mS5ck-00019f-2A; Sun, 19 Sep 2021 23:49:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mS5cg-0001hE-TJ; Sun, 19 Sep 2021 23:49:22 +0100
Date:   Sun, 19 Sep 2021 23:49:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sched: fix initialiser warning in sch_frag.c
Message-ID: <YUe+cq0CLRIA2Pn2@shell.armlinux.org.uk>
References: <E1mS5U9-002wsa-TC@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mS5U9-002wsa-TC@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 11:40:33PM +0100, Russell King (Oracle) wrote:
> Debian gcc 10.2.1 complains thusly:

Correction: this is with ARM gcc 4.9.4 with the 5.14 kernel which is
no longer supported by 5.15-rc. Please ignore.

> 
> net/sched/sch_frag.c:93:10: warning: missing braces around initializer [-Wmissing-braces]
>    struct rtable sch_frag_rt = { 0 };
>           ^
> net/sched/sch_frag.c:93:10: warning: (near initialization for 'sch_frag_rt.dst') [-Wmissing-braces]
> 
> Fix it by removing the unnecessary '0' initialiser, leaving the
> braces.
> 
> Fixes: 31fe34a0118e ("net/sched: sch_frag: fix stack OOB read while fragmenting IPv4 packets")
> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  net/sched/sch_frag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
> index 8c06381391d6..ab359d63287c 100644
> --- a/net/sched/sch_frag.c
> +++ b/net/sched/sch_frag.c
> @@ -90,7 +90,7 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
>  	}
>  
>  	if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
> -		struct rtable sch_frag_rt = { 0 };
> +		struct rtable sch_frag_rt = { };
>  		unsigned long orig_dst;
>  
>  		sch_frag_prepare_frag(skb, xmit);
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
