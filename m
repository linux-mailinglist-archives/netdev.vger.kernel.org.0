Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481283EF9E1
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 07:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbhHRFNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 01:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237618AbhHRFNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 01:13:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E679C0613CF;
        Tue, 17 Aug 2021 22:13:09 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so4561018pje.0;
        Tue, 17 Aug 2021 22:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=90dW0tJPb1k97SIWgHh2sABddZEFDaN0VEgYFRlfpPo=;
        b=DWQuRvO1G7ty2TbQBSl+NCROP3gNOYFX3N/mVUho4VsYn4Dbk9hGj9k19Ipkja4r68
         VqFFQOMi/t4b6hwTqwE8WBN+ovYuvG8Mzqjuym7Pw464aurW013UvQpG/vzLOIP9Uk+0
         Zmk9hksqAKV2QKiS59WIlSOOMVCip5owDycuPD2KbpP6PffT0GVGVpnzQE1pqgOOeunI
         mJwpGxHRSOzkcvQzsZawONzqyhqHsDzNn8FpN07NrKIGs26+YRCLDvq8caClU9imCRBl
         q3ek7UMQ3WFce3+TtmpRsmF1g1zbzg2Acxjnt7TO0QqAllMtDQIjNlSupuTMEF64daUl
         rY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=90dW0tJPb1k97SIWgHh2sABddZEFDaN0VEgYFRlfpPo=;
        b=ZC9rkaeGLABgVb2hVGWD8cXNtZasw2g0SMEhoJbXCSTGeWM8MQCekmIsYtja74eoVy
         PxkFf8qcXCjRRhX/FYeiE+Sh9/Z9ej4USaFKJ862Ob7txsvkjmvJxiOwclAmVSLswH+x
         qFroTNxW/4zazBO0QfdSDnn8+nY+qIAXFvCIyWP2XnnKYz8Yi98OtyXA6wwf12MmOR/T
         5vRddPkxTo5uHLEdHDkKrlMK9cVWKWNi2IUhwp5nIkrRqx7YzMhxngrWBK3UHZAGAf+5
         gAAwHM8yH67KPJEuzbVpigVb4PYnPsUuBU2PyMiO7IsuZdHPJNL2+AUwfEUuFY/EZHD7
         n6kw==
X-Gm-Message-State: AOAM532Zvgqy5bt33ZrNpmiZM56ALoQCyimjIJk8piJumIOKRspdwJvH
        gEm2bwJfLiH5Ryzsc7nMpf4=
X-Google-Smtp-Source: ABdhPJzb/KFABKI6RX7nTPrqqWvjz7OPMOjIQNTHTdxBRvM5SyG25reArcEYDoXM4SSnQeXvPtNYPA==
X-Received: by 2002:a17:90a:930e:: with SMTP id p14mr7379131pjo.132.1629263588776;
        Tue, 17 Aug 2021 22:13:08 -0700 (PDT)
Received: from fedora ([112.79.153.28])
        by smtp.gmail.com with ESMTPSA id gg6sm3718430pjb.46.2021.08.17.22.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 22:13:08 -0700 (PDT)
Date:   Wed, 18 Aug 2021 10:42:57 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Wang Hai <wanghai38@huawei.com>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Richard Sanger <rsanger@wand.net.nz>,
        jiapeng.chong@linux.alibaba.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: Can a valid vnet header have both csum_start and csum_offset 0?
Message-ID: <YRyW2c/yxcSq8S4O@fedora>
References: <YRLONiYsdqKLeja3@fedora>
 <YRSlXr2bsFfZOBgw@fedora>
 <CAF=yD-JqJAGY9x8LzVhK13R0-nZvwu5uDGKENoEu8AUSrsYX-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-JqJAGY9x8LzVhK13R0-nZvwu5uDGKENoEu8AUSrsYX-g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks a lot for this explanation.

On Mon, Aug 16, 2021 at 08:17:08AM -0700, Willem de Bruijn wrote:
> On Wed, Aug 11, 2021 at 10:09 PM Shreyansh Chouhan
> <chouhan.shreyansh630@gmail.com> wrote:
> >
> > On Wed, Aug 11, 2021 at 12:36:38AM +0530, Shreyansh Chouhan wrote:
> > > Hi,
> > >
> > > When parsing the vnet header in __packet_snd_vnet_parse[1], we do not
> > > check for if the values of csum_start and csum_offset given in the
> > > header are both 0.
> > >
> > > Having both these values 0, however, causes a crash[2] further down the
> > > gre xmit code path. In the function ipgre_xmit, we pull the ip header
> > > and gre header from skb->data, this results in an invalid
> > > skb->csum_start which was calculated from the vnet header. The
> > > skb->csum_start offset in this case turns out to be lower than
> > > skb->transport_header. This causes us to pass a negative number as an
> > > argument to csum_partial[3] and eventually to do_csum[4], which then causes
> > > a kernel oops in the while loop.
> > >
> > > I do not understand what should the correct behavior be in this
> > > scenario, should we consider this vnet header as invalid?
> >
> > Something like the following diff:
> >
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index 57a1971f29e5..65bff1c8f75c 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -2479,13 +2479,17 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
> >
> >  static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
> >  {
> > +       __u16 csum_start = __virtio16_to_cpu(vio_le(), vnet_hdr->csum_start);
> > +       __u16 csum_offset = __virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset);
> > +       __u16 hdr_len = __virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len);
> > +
> > +       if (csum_start + csum_offset == 0)
> > +               return -EINVAL;
> > +
> 
> Yet another virtio_net_hdr validation issue.
> 
> The issue is not unique to value 0, but true for any csum_start <
> skb->transport_header at the time of the call to lco_csum. That
> function not unreasonably assumes that csum_start >= l4_hdr.
> 

I thought of that, but then when I went further back in the code
execution path, and saw the code that parses the virtio net header, I thought
that if VIRTIO_NET_HDR_F_NEEDS_CSUM then the csum_start and csum_offset
together must point to some valid location inside the packet.

Thanks a lot for explaining this. Looks like I backtracked more than
necessary.

> The packet socket code is protocol agnostic. It does not know that
> this is an IP GRE packet with greh->flags & TUNNEL_CSUM. We cannot add
> checks there.
> 
> This does appear to be specific to the GRE checksum field, so it won't
> be relevant to other ip tunnel devices:
> 
>                 if (flags & TUNNEL_CSUM &&
>                     !(skb_shinfo(skb)->gso_type &
>                       (SKB_GSO_GRE | SKB_GSO_GRE_CSUM))) {
>                         *ptr = 0;
>                         if (skb->ip_summed == CHECKSUM_PARTIAL) {
>                                 *(__sum16 *)ptr = csum_fold(lco_csum(skb));
> 
> Then the check can be performed between where the ip header is pulled,
> in ipgre_xmit:
> 
>         if (dev->header_ops) {
>                 if (skb_cow_head(skb, 0))
>                         goto free_skb;
> 
>                 tnl_params = (const struct iphdr *)skb->data;
> 
>                 /* Pull skb since ip_tunnel_xmit() needs skb->data pointing
>                  * to gre header.
>                  */
>                 skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));   <--------
>                 skb_reset_mac_header(skb);
>         } else {
>                 if (skb_cow_head(skb, dev->needed_headroom))
>                         goto free_skb;
> 
>                 tnl_params = &tunnel->parms.iph;
>         }
> 
>         if (gre_handle_offloads(skb, !!(tunnel->parms.o_flags & TUNNEL_CSUM)))
>                 goto free_skb;
> 
>         __gre_xmit(skb, dev, tnl_params, skb->protocol);
> 
> and when gre_build_header resets the transport header and calls
> lco_csum. gre_build_header is called from __gre_xmit in the above.
> 
> gre_handle_offloads might then be a good location. Perhaps:
> 
>     static int gre_handle_offloads(struct sk_buff *skb, bool csum)
>     {
>     +       if (csum && skb->csum_start < skb->data)
>     +               return -EINVAL;
>     +
>             return iptunnel_handle_offloads(skb, csum ?
> SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
>      }
> 
> And same for ip6gre.
> 
> Having to add branches inside the hotpath that normally sees well
> behaved packets coming from the kernel stack, only to be robust
> against with malformed packets with bad virtio_net_hdr, is
> unfortunate. This way, the check is at least limited to GRE packets
> with TUNNEL_CSUM.
> 

I see, I had no idea about this being a hotpath as well. Thank you for
clearing all of this out. This does help in isolating the branches to
gre packets that require a checksum.

I will make a patch according to the diff that you suggested, and send
it.

Regards,
Shreyansh Chouhan

> >         if ((vnet_hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
> > -           (__virtio16_to_cpu(vio_le(), vnet_hdr->csum_start) +
> > -            __virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset) + 2 >
> > -             __virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len)))
> > +           csum_start + csum_offset + 2 > hdr_len)
> >                 vnet_hdr->hdr_len = __cpu_to_virtio16(vio_le(),
> > -                        __virtio16_to_cpu(vio_le(), vnet_hdr->csum_start) +
> > -                       __virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset) + 2);
> > +                               csum_start + csum_offset + 2);
> >
> >         if (__virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len) > len)
> >                 return -EINVAL;
> >
> > > Or should we rather accomodate for both csum_start
> > > and csum_offset values to be 0 in ipgre_xmit?
> > >
> > > Regards,
> > > Shreyansh Chouhan
> > >
> > > --
> > >
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/packet/af_packet.c#n2480
> > > [2] https://syzkaller.appspot.com/bug?id=c391f74aac26dd8311c45743ae618f9d5e38b674
> > > [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/skbuff.h#n4662
> > > [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/lib/csum-partial_64.c#n35
