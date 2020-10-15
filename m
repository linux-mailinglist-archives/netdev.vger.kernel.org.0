Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7569B28F8FB
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391243AbgJOS4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391214AbgJOS4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:56:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A2D22203;
        Thu, 15 Oct 2020 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602788207;
        bh=h9H7MfGkVZEtGRU8G3mXGwKdxB+rvRRijM3a/AJ1TF0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gny40sOvk+IJG+h0WMba5SeHcPxvb/n+QcR/fC5gh9A+4V6BqvbfCGfrJUBtGRZFp
         sLhqar70zwGwu3+pNMWW+yMb7KdME2S5ZFiquOsS82g4E2JNqPu9g/bhsSXjuNGO1v
         9azo058IoVy8sFBmz1zNA4/2xX3SOYw184D/ARRQ=
Date:   Thu, 15 Oct 2020 11:56:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpfilter: Fix build error with CONFIG_BPFILTER_UMH
Message-ID: <20201015115643.3a4d4820@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAADnVQKJ=iDMiJpELmuATsdf2vxGJ=Y9r+vjJG6m4BDRNPmP3g@mail.gmail.com>
References: <20201014091749.25488-1-yuehaibing@huawei.com>
        <20201015093748.587a72b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQKJ=iDMiJpELmuATsdf2vxGJ=Y9r+vjJG6m4BDRNPmP3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 11:53:08 -0700 Alexei Starovoitov wrote:
> On Thu, Oct 15, 2020 at 9:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 14 Oct 2020 17:17:49 +0800 YueHaibing wrote:  
> > > IF CONFIG_BPFILTER_UMH is set, building fails:
> > >
> > > In file included from /usr/include/sys/socket.h:33:0,
> > >                  from net/bpfilter/main.c:6:
> > > /usr/include/bits/socket.h:390:10: fatal error: asm/socket.h: No such file or directory
> > >  #include <asm/socket.h>
> > >           ^~~~~~~~~~~~~~
> > > compilation terminated.
> > > scripts/Makefile.userprogs:43: recipe for target 'net/bpfilter/main.o' failed
> > > make[2]: *** [net/bpfilter/main.o] Error 1
> > >
> > > Add missing include path to fix this.
> > >
> > > Signed-off-by: YueHaibing <yuehaibing@huawei.com>  
> >
> > Applied, thank you!  
> 
> Please revert. The patch makes no sense.

How so? It's using in-tree headers instead of system ones.
Many samples seem to be doing the same thing.

> Also please don't take bpf patches.

You had it marked it as netdev in your patchwork :/
