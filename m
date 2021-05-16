Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106DC381E6A
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 13:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhEPLHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 07:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhEPLGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 07:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EFC61164;
        Sun, 16 May 2021 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621163139;
        bh=WiC71pXk8emvv0zY/+crSWWI5AVm2BipMB73EoTW0/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JM453Ghyhuz63ImQutMJufUHPmhQ6tFdPI0GR+Rg2kHyM/AtV5VnTRIOmSC370U+n
         R/JzUbyVrlnDywOklmGfhst0Yqq8L/lNM4eHL6EGz1oCaNB1OZpSd54ZOVYtZ/NciP
         djoCIjAKqAkzoy1c2uIrUOh0MM+LvNWFPWXsn6lMmj+KPBlXiVIw4qI5vygTNH/0zp
         9EU4oQ3KREzQJ9Zpe9vglC8oSxKr3PPgqYv1B21TfWTot7q2oQ8P3zMf5lxGweFCAb
         USog7Dusv7h3hO4zrJ8f36yvXzrrMsytcjPXL1q6wPK6gfv7YaTdtDFtziNFv19rzs
         xTODgMQoqlzmw==
Date:   Sun, 16 May 2021 14:05:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net] netns: export get_net_ns_by_id()
Message-ID: <YKD8f7wP2EzUU7PX@unreal>
References: <20210512212956.4727-1-ryazanov.s.a@gmail.com>
 <20210514121433.2d5082b3@kicinski-fedora-PC1C0HJN>
 <CAHNKnsSM6dcMDnOOEo5zs6wdzdA1S43pMpB+rkKpuuBrBxj3pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsSM6dcMDnOOEo5zs6wdzdA1S43pMpB+rkKpuuBrBxj3pg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 11:52:51PM +0300, Sergey Ryazanov wrote:
> On Fri, May 14, 2021 at 10:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 13 May 2021 00:29:56 +0300 Sergey Ryazanov wrote:
> > > No one loadable module is able to obtain netns by id since the
> > > corresponding function has not been exported. Export it to be able to
> > > use netns id API in loadable modules too as already done for
> > > peernet2id_alloc().
> >
> > peernet2id_alloc() is used by OvS, what's the user for get_net_ns_by_id()?
> 
> There are currently no active users of get_net_ns_by_id(), that is why
> I did not add a "Fix" tag. Missed function export does not break
> existing code in any way.

It is against kernel rule to do not expose APIs, even internal to the kernel,
without real users. There are many patches every cycle that remove such EXPORT_*()s.

EXPORT_*() creates extra entries in Module.symvers and can be seen as unnecessary
namespace pollution.

Thanks
