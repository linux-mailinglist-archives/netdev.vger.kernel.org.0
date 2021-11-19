Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C504576C0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbhKSS4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234998AbhKSS4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 13:56:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51C160E54;
        Fri, 19 Nov 2021 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637347987;
        bh=bkEC59vwr6ACcyDrI/o8TXZEvLkZv65iduYBaycj1So=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t9kNIPRPkPCFX0/Hdiv2jhilymqje7gbvS1IKr3indwougpjnJ6FHdOqJht3vLHvs
         Bmypf/hfMW+kKS3GBBpgJuseqEhxZGAzYMoEzkHuliRs28rj0n5uWNthW3rYB5tVQ5
         Z72gW6W0rHxh39M/WLRAZueemDTJkDTIcP7UXBDbH2DAz2UW1n9JzrrcoNRhoOzvl0
         H+F/FNbsqduSAxNUiwoOaXFkYikhqXHsH6U9bQ9+WMj+C1a3hnFk3DmJZ/MnBKFkrB
         117oucvZm1MUFuVNHVeF/qiJE4roMjrhGDVGi8vtLf8AG9v4CaxYoEwbcNb0ZjKMu4
         BZk4zSFKAXxHQ==
Date:   Fri, 19 Nov 2021 10:53:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] skbuff: Switch structure bounds to struct_group()
Message-ID: <20211119105253.1db523b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119104144.7cb1eac6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211118183615.1281978-1-keescook@chromium.org>
        <20211118231355.7a39d22f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <202111191015.509A0BD@keescook>
        <20211119104144.7cb1eac6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 10:41:44 -0800 Jakub Kicinski wrote:
> On Fri, 19 Nov 2021 10:26:19 -0800 Kees Cook wrote:
> > On Thu, Nov 18, 2021 at 11:13:55PM -0800, Jakub Kicinski wrote:  
> > > This adds ~27k of these warnings to W=1 gcc builds:
> > > 
> > > include/linux/skbuff.h:851:1: warning: directive in macro's argument list    
> > 
> > Hrm, I can't reproduce this, using several GCC versions and net-next. What
> > compiler version[1] and base commit[2] were used here?  
> 
> gcc version 11.2.1 20210728 (Red Hat 11.2.1-1) (GCC) 
> 
> HEAD was at: 3b1abcf12894 Merge tag 'regmap-no-bus-update-bits' of git://...

Ah, damn, I just realized, it's probably sparse! The build sets C=1.
