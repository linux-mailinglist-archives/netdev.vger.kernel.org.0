Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBAC30A9A4
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhBAOZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhBAOYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:24:50 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D32C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 06:24:10 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s11so19081694edd.5
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 06:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rthSfKrL/oeMzQQH38UaXAOhhP0IpS3lFL7a1GInz/E=;
        b=iaSwfKpnoOXTMzbI7fX9pLo7gELb+KTldufvxxV7/RogeTJ7WAJCpNMn5W/1hFs1R3
         6exUFE3aJmZrGs/Y4WCWn2Foge590oMkca4jaxXgewjfAZGdP1Wn8XO68XS3NyllLzr3
         jzvlgE64EqsXZLebkIE8d4pK2Ptmn9b90jao39eJkGpc29lL3sRFHIc1nz6DtithEORW
         t2+vQgvfKru7W01Ikw5bk6ZePVSibJEFNENYYXaEIa2ps0yRi0zLMs8gdUogJzyghSEk
         cGbVx0tYuCdfkRkslAu5epaqvlPibpl3+jXs64GP17jnteZt+aOxtOdCdcPNakxP7mdM
         5HBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rthSfKrL/oeMzQQH38UaXAOhhP0IpS3lFL7a1GInz/E=;
        b=K9aCKS7BHsRpZaue7LifGNTNwCD47vtH+Dh7inENSMFDG8M+QG5X76YWa3i1N7yE1h
         gIzXthuV9kwAwsP4IHjiXCEv/xlqs5hdZEkfu76AcgW0Vr4vh32VWZirSUE8ZDLshyC8
         iA3JNSb/ZZqfbRgqWE3DEnB5yFskvr21Nr35d+2nJXeCVn1nwxOmdkgcYM2OA8QjBQsU
         rE8MoWT5dDcMiac1mTqVhRCGKl6a3ju53wL06n1B37I0ldZ6T19EWLIvDIgCecb90KtY
         zY/Y0tnBxZsR8XYlGtVcPCShdWpOqHc6z8Y2XbfMq59Cb/3ZP/LYAghj2g1so4hFzDNZ
         +a/A==
X-Gm-Message-State: AOAM530elkOVmTlOl8nxYx5rBWtVMwuEMK8yZHb1ZXRlaj8YyGZSxpT+
        LLI0zYVu2SpN3uYdBjYXKVi3KV2OQ59CjbU2YLTbPXbR
X-Google-Smtp-Source: ABdhPJymvPffq1hyFyH4UZXBuCHfGqEDnZ8zppIP+U3WrnBAA4IihWuqbYtanuGywdT+MzfijjC2AcKJOhSWzINTKno=
X-Received: by 2002:a05:6402:318e:: with SMTP id di14mr19003800edb.223.1612189448507;
 Mon, 01 Feb 2021 06:24:08 -0800 (PST)
MIME-Version: 1.0
References: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org>
 <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAMZdPi_6tBkdQn+wakUmeMC+p8N3HStEja5ZfA3K-+x4DcM68g@mail.gmail.com>
In-Reply-To: <CAMZdPi_6tBkdQn+wakUmeMC+p8N3HStEja5ZfA3K-+x4DcM68g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Feb 2021 09:23:32 -0500
Message-ID: <CAF=yD-+UFHO8nKsB3Z7n-xhoFtXwge2GEZj-2+-7=EETLjYXFA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mhi-net: Add de-aggeration support
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 3:08 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>
> Hi Jakub, Willem,
>
> On Sat, 30 Jan 2021 at 02:01, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 25 Jan 2021 16:45:57 +0100 Loic Poulain wrote:
> > > When device side MTU is larger than host side MRU, the packets
> > > (typically rmnet packets) are split over multiple MHI transfers.
> > > In that case, fragments must be re-aggregated to recover the packet
> > > before forwarding to upper layer.
> > >
> > > A fragmented packet result in -EOVERFLOW MHI transaction status for
> > > each of its fragments, except the final one. Such transfer was
> > > previoulsy considered as error and fragments were simply dropped.
> > >
> > > This patch implements the aggregation mechanism allowing to recover
> > > the initial packet. It also prints a warning (once) since this behavior
> > > usually comes from a misconfiguration of the device (modem).
> > >
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> >
> > > +static struct sk_buff *mhi_net_skb_append(struct mhi_device *mhi_dev,
> > > +                                       struct sk_buff *skb1,
> > > +                                       struct sk_buff *skb2)
> > > +{
> > > +     struct sk_buff *new_skb;
> > > +
> > > +     /* This is the first fragment */
> > > +     if (!skb1)
> > > +             return skb2;
> > > +
> > > +     /* Expand packet */
> > > +     new_skb = skb_copy_expand(skb1, 0, skb2->len, GFP_ATOMIC);
> > > +     dev_kfree_skb_any(skb1);
> > > +     if (!new_skb)
> > > +             return skb2;
> >
> > I don't get it, if you failed to grow the skb you'll return the next
> > fragment to the caller? So the frame just lost all of its data up to
> > where skb2 started? The entire fragment "train" should probably be
> > dropped at this point.
>
> Right, there is no point in keeping the partial packet in that case.
>
> >
> > I think you can just hang the skbs off skb_shinfo(p)->frag_list.
> >
> > Willem - is it legal to feed frag_listed skbs into netif_rx()?
>
> In QMAP case, the packets will be forwarded to rmnet link, which works
> with linear skb (no NETIF_F_SG), does the linearization will be
> properly performed by the net core, in the same way as for xmit path?

What is this path to rmnet, if not the usual xmit path / validate_xmit_skb?
