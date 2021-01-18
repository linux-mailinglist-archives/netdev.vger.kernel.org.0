Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7702FAC62
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437677AbhARVQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437982AbhARVQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:16:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5310A22CB1;
        Mon, 18 Jan 2021 21:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611004530;
        bh=56i95D8vuhTOrNNXMbFEkyehpTTSktJh8vSW/Tx3g/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C81zKtKwwoGY9rzl97SVGpC/8nDfkA43/JWv+b4vC2VnnaCByyPv166Cx9SHLgncP
         E01SFmWElw+ZlOlAs5PoGnUtaXhBVh5Zq7STJsHom/FtgFx86058HyEsmHUdtREKoX
         eKu3NXPK2W1G2pZskkMulhwPIhDxdFJd5p4RPpHXVihXcAk4DWFvNaivlNOeilvy+K
         aBiDePc9JsppaWh303JRofY1iGsJ7ox76VGWRuDkjkpiFHl3k6p+oGUr5fqCc09Or6
         nS2R1nq9ar/vp/SqeCaHC95nSWJ4nknyjr0uG72zlzs4+zEbgsLE8NkuInIUnmpwhn
         2whlSaPzZGlxQ==
Date:   Mon, 18 Jan 2021 13:15:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     menglong8.dong@gmail.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dong.menglong@zte.com.cn,
        daniel@iogearbox.net, gnault@redhat.com, ast@kernel.org,
        nicolas.dichtel@6wind.com, ap420073@gmail.com, edumazet@google.com,
        pabeni@redhat.com, jakub@cloudflare.com, bjorn.topel@intel.com,
        keescook@chromium.org, viro@zeniv.linux.org.uk, rdna@fb.com,
        maheshb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: Namespace-ify sysctl_wmem_default
 and sysctl_rmem_default
Message-ID: <20210118131528.72e194d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118111518.nsrtv52xsanf7q6d@wittgenstein>
References: <20210117102319.193756-1-dong.menglong@zte.com.cn>
        <20210118111518.nsrtv52xsanf7q6d@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 12:15:18 +0100 Christian Brauner wrote:
> On Sun, Jan 17, 2021 at 06:23:19PM +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <dong.menglong@zte.com.cn>
> > 
> > For now, sysctl_wmem_default and sysctl_rmem_default are globally
> > unified. It's not convenient in some case. For example, when we
> > use docker and try to control the default udp socket receive buffer
> > for each container.
> > 
> > For that reason, make sysctl_wmem_default and sysctl_rmem_default
> > per-namespace.
> > 
> > Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> > ---  
> 
> Hey Menglong,
> 
> I was about to review the two patches you sent:
> 
> 1. [PATCH net-next] net: core: Namespace-ify sysctl_rmem_max and sysctl_wmem_max
>    https://lore.kernel.org/lkml/20210117104743.217194-1-dong.menglong@zte.com.cn
> 2. [PATCH net-next] net: core: Namespace-ify sysctl_wmem_default and sysctl_rmem_default
>    https://lore.kernel.org/lkml/20210117102319.193756-1-dong.menglong@zte.com.cn

And perhaps

  0. [PATCH net-next] net: core: init every ctl_table in netns_core_table

? 

I'm dropping these three from patchwork please follow Christian
suggestions on how to repost properly, thanks!

> and I had to spend some time figuring out that 2. is dependent on 1. I
> first thought I got the base wrong.
> 
> I'd suggest you resend both patches as a part of a single series with a
> cover letter mentioning the goal and use-case for these changes and also
> pass --base=<base-commit>
> when creating the patch series which makes it way easier to figure out
> what to apply it to when wanting to review a series in the larger
> context of a tree.

