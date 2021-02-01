Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06D830AF76
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhBASe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhBASeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:34:23 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12660C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 10:33:42 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id rv9so25906335ejb.13
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 10:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GxDX9DaVMoGHl1jPDqPxW58NMOCXx4OQ18M6TRTNqRM=;
        b=LHcNf05PZLU06HZIiNVsMtgldW5EFPxbqVpeM39ftXg9uRCF8dASJSJK8beAr4tCb9
         C12xk+gc+96F3bWikbYAv/cfpRgEJLOk0M4GmfVbhjHzyEXGKFld6ospapS1h6gEwqll
         c9UUYVl+EbLWU2DWMW7Tghe3sCzgB2NYkNvXoFr5PloKDXz9SlclIbDWiHLDuA4WiyDG
         lHRn9QBC55l2vtiXeaDiw1af3AVgHoeujdjCcDuXwl/mYOYUmScSkFKgQ3FoDMGUlwYL
         R74TIuEITlKP7E9FRBiE1zye2E0W/luU3mP7TCW4aYcTVC8HmbMsRPw36SOi/US9ZMvH
         yfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GxDX9DaVMoGHl1jPDqPxW58NMOCXx4OQ18M6TRTNqRM=;
        b=JTVz9n663+VibAXhPp0VKwKV/gr3vhHhHVsTJYmBFIFUazgWCNFDL/AU9vys6x/heV
         LfJjTBjiF5HRgPVSSLwHtjBKvIrbNECh5vikjGp49GKFhBmvPa91bBOXyvG5l4x7hIQN
         i0mQgRAxG1Sg96gzO8NaNAAN/CKdkl63B38Rg2+Ino/bjuxWj0pp1Gi5B2ddvjig7eDo
         mnjO7+FegnKV5AVo3K9a+ThgBD6F/jGKJlbnuZXMdUuPDvnKhfX66V2mtC+1kFL/edi5
         LXDPyv248QADSWxaWTQXOy/fCrF/lgXZNFJ7EK6E7lBX/E5CS/VKQvm/WNy+nzhakBLW
         8SFw==
X-Gm-Message-State: AOAM531YQnt+FPZt2KuZR5NTsnpNenq4n3IiFVRPZsBpcGSLuWd1mq6q
        iHV2jEshNN7z/C5751Dbf95sPNmtChDOxjJe0qo=
X-Google-Smtp-Source: ABdhPJwbxSQYSzPj6LIAMjvWqa+J+AqwMAJFuzKshdipuSw5+MZBo29LvWMjkB1hu+YyFpb3c0bdwAF6yKO5Du9Kl4U=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr19268005ejd.119.1612204420825;
 Mon, 01 Feb 2021 10:33:40 -0800 (PST)
MIME-Version: 1.0
References: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org>
 <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi_6tBkdQn+wakUmeMC+p8N3HStEja5ZfA3K-+x4DcM68g@mail.gmail.com>
 <CAF=yD-+UFHO8nKsB3Z7n-xhoFtXwge2GEZj-2+-7=EETLjYXFA@mail.gmail.com> <CAMZdPi_dMBDafAVoHbqwR9RDbtZSJpGd48oCMmL1qAgR+PCFGQ@mail.gmail.com>
In-Reply-To: <CAMZdPi_dMBDafAVoHbqwR9RDbtZSJpGd48oCMmL1qAgR+PCFGQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Feb 2021 13:33:05 -0500
Message-ID: <CAF=yD-KT0nPEV4CphRH3xVJhXqpK=FQHM-3TkK+88ZqA9afeFw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mhi-net: Add de-aggeration support
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 11:41 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>
> On Mon, 1 Feb 2021 at 15:24, Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Mon, Feb 1, 2021 at 3:08 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> > >
> > > Hi Jakub, Willem,
> > >
> > > On Sat, 30 Jan 2021 at 02:01, Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Mon, 25 Jan 2021 16:45:57 +0100 Loic Poulain wrote:
> > > > > When device side MTU is larger than host side MRU, the packets
> > > > > (typically rmnet packets) are split over multiple MHI transfers.
> > > > > In that case, fragments must be re-aggregated to recover the packet
> > > > > before forwarding to upper layer.
> > > > >
> > > > > A fragmented packet result in -EOVERFLOW MHI transaction status for
> > > > > each of its fragments, except the final one. Such transfer was
> > > > > previoulsy considered as error and fragments were simply dropped.
> > > > >
> > > > > This patch implements the aggregation mechanism allowing to recover
> > > > > the initial packet. It also prints a warning (once) since this behavior
> > > > > usually comes from a misconfiguration of the device (modem).
> > > > >
> > > > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > >
> > > > > +static struct sk_buff *mhi_net_skb_append(struct mhi_device *mhi_dev,
> > > > > +                                       struct sk_buff *skb1,
> > > > > +                                       struct sk_buff *skb2)
> > > > > +{
> > > > > +     struct sk_buff *new_skb;
> > > > > +
> > > > > +     /* This is the first fragment */
> > > > > +     if (!skb1)
> > > > > +             return skb2;
> > > > > +
> > > > > +     /* Expand packet */
> > > > > +     new_skb = skb_copy_expand(skb1, 0, skb2->len, GFP_ATOMIC);
> > > > > +     dev_kfree_skb_any(skb1);
> > > > > +     if (!new_skb)
> > > > > +             return skb2;
> > > >
> > > > I don't get it, if you failed to grow the skb you'll return the next
> > > > fragment to the caller? So the frame just lost all of its data up to
> > > > where skb2 started? The entire fragment "train" should probably be
> > > > dropped at this point.
> > >
> > > Right, there is no point in keeping the partial packet in that case.
> > >
> > > >
> > > > I think you can just hang the skbs off skb_shinfo(p)->frag_list.
> > > >
> > > > Willem - is it legal to feed frag_listed skbs into netif_rx()?
> > >
> > > In QMAP case, the packets will be forwarded to rmnet link, which works
> > > with linear skb (no NETIF_F_SG), does the linearization will be
> > > properly performed by the net core, in the same way as for xmit path?
> >
> > What is this path to rmnet, if not the usual xmit path / validate_xmit_skb?
>
> I mean, not sure what to do exactly here, instead of using
> skb_copy_expand to re-aggregate data from the different skbs, Jakub
> suggests chaining the skbs instead (via 'frag_list' and 'next' pointer
> I assume), and to push this chained skb to net core via netif_rx. In
> that case, I assume the de-fragmentation/linearization will happen in
> the net core, right? If the transported protocol is rmnet, the packet
> is supposed to reach the rmnet_rx_handler at some point, but rmnet
> only works with standard/linear skbs.

If it has that limitation, the rx_handler should have a check and linearize.

That is simpler than this skb_copy_expand, and as far as I can see no
more expensive.
