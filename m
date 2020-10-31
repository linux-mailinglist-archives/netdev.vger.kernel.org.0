Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688732A18D0
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 17:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgJaQvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 12:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgJaQvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 12:51:47 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9C402063A;
        Sat, 31 Oct 2020 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604163107;
        bh=PHQGRPHcGLLK60dmR2cplns/9aVCOpO64PtP8D0Yxos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fgd4vIZIt6glqq9SklROznt0VUEwI/ZfQo0ptz7WZ85dVl2g/QH1EqW3YxBA7Hyra
         ObuM4NIo/uQVUx7iH0k1I9RR8t9cTXz1QqhWfEjgh3dar25Eu6w08b0i8tnQD6A2aR
         xB9CXJqheyIFgFKXVHJ6R/bGFaopRlObucc9/dZw=
Date:   Sat, 31 Oct 2020 09:51:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
Message-ID: <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com>
References: <20201028070504.362164-1-xie.he.0141@gmail.com>
        <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 22:10:42 -0700 Xie He wrote:
> > The usual way of getting rid of old code is to move it to staging/
> > for a few releases then delete it, like Arnd just did with wimax.  
> 
> Oh. OK. But I see "include/linux/if_frad.h" is included in
> "net/socket.c", and there's still some code in "net/socket.c" related
> to it. If we move all these files to "staging/", we need to change the
> "include" line in "net/socket.c" to point to the new location, and we
> still need to keep a little code in "net/socket.c". So I think if we
> move it to "staging/", we can't do this in a clean way.

I'd just place that code under appropriate #ifdef CONFIG_ so we don't
forget to remove it later.  It's just the dlci_ioctl_hook, right?

Maybe others have better ideas, Arnd?
