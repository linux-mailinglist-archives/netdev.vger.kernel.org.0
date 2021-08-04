Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634C63E03E1
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhHDPHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237378AbhHDPHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:07:41 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6580C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 08:07:28 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id h1so2750712iol.9
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 08:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RWDjzodGnhZfwxccSgG7VT6HhBEQtoLSkZbWFg0VfT8=;
        b=EmFXLVq9TtTpkgJ8rvOAI08qcDBQyB+Fv/L06hjYiodSgH+GQXZoptoIVMjlMBpUGB
         lUBkkEgvvn+XCKIl1y38imCqmqJEYPx2qWwmuzhr3bYBNEYjYrboAw4xV6kK5Y2SLPf8
         wlfUfhkE4K03tcMz6m1Zq6ffzS/j9TADLti8D80Xf6Y0+yS2FcAGFhXWOmo1ke/nJgd0
         6/LI9fr1rptjBu6LCACpG4mKhYUBbBp3NhDM5O0IC8pEcXbZMFHHs5h6xNZ3CTuFbd7y
         MKpND5KTueImSMbVOIakr/y7PLYIPGV+V2Gm56tW8gNLKo6IcfkzPweXO3RFgqruMRp6
         pEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RWDjzodGnhZfwxccSgG7VT6HhBEQtoLSkZbWFg0VfT8=;
        b=WuvCXrMzUzmBpo6zuvgPujHot0soJREDbb/WiKailYtImpYijdnYxugKUAYVbxHbEM
         FfIH57Oqg+sysUGyKDL3y5IjYOx2Hd4K7KJKUUKEetiYtegU8jN9Hh/WOVGcvQ5cKZcq
         iEAITcbFWBpQXb1s4gEchS/iAjWZWmMvBojZUoJcC0pAWvN6jCMJmy5BLRDHHrNWGuz5
         vSegWjQrzlRcB5tgXVEEnEowHYzgEjNbfJvk40Za1nCaB07t0Tik7aNIc85idPH1ymI6
         2di5Gn+8IjnUF4uLJHbyMvPoMar6yYD50LMVgVtK+XL6nIZog/TRDCubGjReF9J++hwH
         9MhQ==
X-Gm-Message-State: AOAM5335e9Ypd88A75tgxyzWzI9REBcVzZOj72XCzdEKCG4uIs0u3ddt
        y+f2pVQOzIJBCRPf2W3t5sUv1zMYAoyIrikZZ/w=
X-Google-Smtp-Source: ABdhPJxhAeob5VyA2a0O34Fhx3Mo2JxS+SrD/RJaxIL51y9TwrahhsvLd6MSZbDfdQ+7N9NXh0pghsqn7c1g0msyTDg=
X-Received: by 2002:a6b:e602:: with SMTP id g2mr641933ioh.50.1628089648273;
 Wed, 04 Aug 2021 08:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-5-borisp@nvidia.com>
 <20210723060631.GA32369@lst.de> <CAJ3xEMjFOPFfU4ibFJPYdYUSh0nFkRwfW1cdAV2BMvg1aaP_eg@mail.gmail.com>
 <20210804072918.17ba9cff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210804072918.17ba9cff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 4 Aug 2021 18:07:06 +0300
Message-ID: <CAJ3xEMjYSPczpZ1c_5DnhFtGgpU9PT3VQ0_vgDinizXjLxL_0A@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 04/36] net/tls: expose get_netdev_for_sock
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Yoray Zack <yorayz@nvidia.com>,
        benishay@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 5:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 4 Aug 2021 16:26:31 +0300 Or Gerlitz wrote:
> > On Fri, Jul 23, 2021 at 9:09 AM Christoph Hellwig <hch@lst.de> wrote:
> > > On Thu, Jul 22, 2021 at 02:02:53PM +0300, Boris Pismenny wrote:
> > > > From: Boris Pismenny <borisp@mellanox.com>
> > > >
> > > > get_netdev_for_sock is a utility that is used to obtain
> > > > the net_device structure from a connected socket.
> > > >
> > > > Later patches will use this for nvme-tcp DDP and DDP DDGST offloads.
> > > >
> > > > Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> > > > Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> > >
> > > I don't think this should be an inline.  Please move it to net/core/dev.c,
> > > andd add an EXPORT_SYMBOL_GPL and a kerneldoc comment.
> >
> > Jakub,
> >
> > What's your preference here?
>
> Fine either way.

copying the list and few ppl
