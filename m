Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759DB3F1EC6
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhHSRKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhHSRKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 13:10:15 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62794C061575;
        Thu, 19 Aug 2021 10:09:39 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id a93so13679785ybi.1;
        Thu, 19 Aug 2021 10:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/4H4UABPimP8Hwji64bfX+s+r5drpqzWVOEiLeWsCY=;
        b=kr4aii8mG4Hwb889xrouTfyVm+TGpXlT8SjWTbm1QXGdFMb/dMv0oehb+dqcn3drku
         /WuoJlrx0Zq+Tb5GyCBGwGZdBIbussa4ND/aJOx4cWP34bFFlnvqtIgjeWWDKD1FMFKd
         xrld/doRXI8TbXOcXmdk8Iwq2bZyw1E3JVQCzoS6NYG9v7+HbL9CRh+1kpbmhjjhRtuE
         9yY59Mb6m2ie7qHBbdelqwH/uMA9ZIDi8pVyk6MrCdnwsFpRS9HVvZEOi9rO++U3IuXW
         M3n8I1TEQWJ16QxFrcjqhJBiSrB9BiX4X2QXpmrJ+5pe8fizrRQ3GSbiJXrGEOGxSLlN
         +7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/4H4UABPimP8Hwji64bfX+s+r5drpqzWVOEiLeWsCY=;
        b=o2NxYrcbv11Rf5g/1aEnUiv3q+mHDYOiPXSjNisjapu52Ddfzmz91w7AZcp/7RmA2t
         sXkjtWVLnRAxaAtQWAkx60lqb3lDuizilX5bOJ7iVM6al85W2nRHhs/ywbKvOtT1NmAY
         o7RRl2/X/7ZO01av8/k24P1vyAogTd/OgbSSwUMt1wzgAo03uzWvUQWJnp5Jrvxl3105
         vzQiFgxRWTFrcOE06gClqf7Ht9hYn9+pa63YNEGPHKSPd1fhE4dEw5QOks8ho7H2pp1m
         QUPvbBGkZyEjagcKhiEHQDFUpKLAaubyhb2Cl9+uzhV5r1Zf9qinbmhcW1/j3sTHsUT3
         oLDA==
X-Gm-Message-State: AOAM533hTOejcBV+d+wEoZ7qoVYkngAuMJyv9QlnO/Vmi7nGnbKUhbVv
        8aiJJiZ/4d4bKUu6ceiK5XjQt79nKGAQxZVJVkiYdgcUFGA=
X-Google-Smtp-Source: ABdhPJwbP8oNXRMd5W/eKJPRdDFo9D9IKDVDyq9YsabfpZmbYF7A81P75oVG7y4BGCkgvXT1Op+tVxStsXxo5wDLXD0=
X-Received: by 2002:a25:db89:: with SMTP id g131mr19432752ybf.302.1629392978676;
 Thu, 19 Aug 2021 10:09:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAFcO6XOLxfHcRFVNvUTPVNiyQ4FKwZ-x9SDgL7n9EJphoxawxQ@mail.gmail.com>
 <CAFcO6XOGjHzys4GywczXyePiPcEXw7P=gBPwYU5nv0f-a=eFig@mail.gmail.com> <20210819165731.GD200135@thinkpad>
In-Reply-To: <20210819165731.GD200135@thinkpad>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Fri, 20 Aug 2021 01:09:28 +0800
Message-ID: <CAFcO6XMBB-xgT0xECs+y=r_fbDRyLCW-Mg6jsmiejsprFMvB8w@mail.gmail.com>
Subject: Re: Another out-of-bound Read in qrtr_endpoint_post in net/qrtr/qrtr.c
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, no problem, I will send the fix later.

Regards,
 butt3rflyh4ck.

On Fri, Aug 20, 2021 at 12:57 AM Manivannan Sadhasivam <mani@kernel.org> wrote:
>
> Hi,
>
> On Wed, Aug 18, 2021 at 03:33:38PM +0800, butt3rflyh4ck wrote:
> > Here I make a patch for this issue.
>
> [...]
>
> > From 18d9f83f17375785beadbe6a0d0ee59503f65925 Mon Sep 17 00:00:00 2001
> > From: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
> > Date: Wed, 18 Aug 2021 14:19:38 +0800
> > Subject: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
> >
> > This check was incomplete, did not consider size is 0:
> >
> >       if (len != ALIGN(size, 4) + hdrlen)
> >                     goto err;
> >
> > if size from qrtr_hdr is 0, the result of ALIGN(size, 4)
> > will be 0, In case of len == hdrlen and size == 0
> > in header this check won't fail and
> >
> >       if (cb->type == QRTR_TYPE_NEW_SERVER) {
> >                 /* Remote node endpoint can bridge other distant nodes */
> >                 const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
> >
> >                 qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
> >         }
> >
> > will also read out of bound from data, which is hdrlen allocated block.
> >
> > Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
> > Fixes: ad9d24c9429e ("net: qrtr: fix OOB Read in qrtr_endpoint_post")
> > Signed-off-by: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
>
> Thanks for the bug report and the fix. Could you please send the fix as a proper
> patch as per: Documentation/process/submitting-patches.rst
>
> Thanks,
> Mani
>
> > ---
> >  net/qrtr/qrtr.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index 171b7f3be6ef..0c30908628ba 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
> >               goto err;
> >       }
> >
> > -     if (len != ALIGN(size, 4) + hdrlen)
> > +     if (!size || len != ALIGN(size, 4) + hdrlen)
> >               goto err;
> >
> >       if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
> > --
> > 2.25.1
> >
>


-- 
Active Defense Lab of Venustech
