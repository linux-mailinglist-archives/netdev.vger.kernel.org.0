Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D10F3ED9BF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhHPPSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhHPPSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 11:18:20 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED6EC061764;
        Mon, 16 Aug 2021 08:17:49 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d5so5103448qtd.3;
        Mon, 16 Aug 2021 08:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XbI2WQ6NoRATPIcJzk2W3unjepFn2oxt+/scph8/U7U=;
        b=rapmxdW/JfshslR3ZUJydZLb3u7osvhuBA1aTOB+RJPQ7cNI1zeco7gaSWVN85fcz/
         yKQZ8l4em7ciuiFQCrTc2W1+buX9y4++Jq3xpX8bbatZtlL6dDkRq8As5I3dF3JdylNB
         xilK5hLtFyERsSRl8bfmY8KDl8fAz85wYnL/ZyqDJ0+8kgOYxrr7pWh5dPScRApPeiBx
         8fHB4sqnXYID091fNvzYQdjrr3IqIRzXfindot+WeVAJCCKOx9vMQLKekY874XI5dhCs
         P8PVW9E0uoBi3/6aT4Omefow6ol9MFFkmRJv8AIifaXniGxp1INApEUT7d061d3asToq
         8Z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XbI2WQ6NoRATPIcJzk2W3unjepFn2oxt+/scph8/U7U=;
        b=XUcpYgajIaOsMK8UBpGKC1UeNOF2WebD/h4B1l138dLY2wYssi3ZFSRfQts+Br442m
         +AZ+a9l6w2cHU7TGaHSaLNeqVsDqhXgAo7P1VeS9yQgMVHafyaYVFCr/ZCDTYtDX4CS9
         WazVF8t/pSIRskYd6FzJF5DMBBPeYa7yYEbRB9p4tFVAdJnFBQFFtqh/hPzju1+cZCip
         Zm5wCWkF+NBwCdkzAdVZKK55W0Ue3tOKMn51lmAFwrXxq5IRfvba2tSHsywqG8wh9t5B
         RA+Erk4/5Fwnu7js3A+Nnyq0f2GgWx6KvCsoTrhowBCgF9rB8mCV7yKJUKvKCUot12g6
         kdcQ==
X-Gm-Message-State: AOAM530nERC0xhLD0iHKPbyHxsYoATWTlm6BGdwtiOXaVn1bLL8EC9wq
        AqI5zDKoo5rjrLmgT8TFM9vYnE7ra62oSlvpCF6JtRhHlibafQ==
X-Google-Smtp-Source: ABdhPJwGIFAEhPEaq5jycgkhy6A1kX+DfwSS2F6oL5Iotap+kTdmuJEE+S+b+1QxmQfEf0hFKQAsagFbGsemvGBIK5M=
X-Received: by 2002:ac8:5745:: with SMTP id 5mr3449154qtx.347.1629127068107;
 Mon, 16 Aug 2021 08:17:48 -0700 (PDT)
MIME-Version: 1.0
References: <YRLONiYsdqKLeja3@fedora> <YRSlXr2bsFfZOBgw@fedora>
In-Reply-To: <YRSlXr2bsFfZOBgw@fedora>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 16 Aug 2021 08:17:08 -0700
Message-ID: <CAF=yD-JqJAGY9x8LzVhK13R0-nZvwu5uDGKENoEu8AUSrsYX-g@mail.gmail.com>
Subject: Re: Can a valid vnet header have both csum_start and csum_offset 0?
To:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 10:09 PM Shreyansh Chouhan
<chouhan.shreyansh630@gmail.com> wrote:
>
> On Wed, Aug 11, 2021 at 12:36:38AM +0530, Shreyansh Chouhan wrote:
> > Hi,
> >
> > When parsing the vnet header in __packet_snd_vnet_parse[1], we do not
> > check for if the values of csum_start and csum_offset given in the
> > header are both 0.
> >
> > Having both these values 0, however, causes a crash[2] further down the
> > gre xmit code path. In the function ipgre_xmit, we pull the ip header
> > and gre header from skb->data, this results in an invalid
> > skb->csum_start which was calculated from the vnet header. The
> > skb->csum_start offset in this case turns out to be lower than
> > skb->transport_header. This causes us to pass a negative number as an
> > argument to csum_partial[3] and eventually to do_csum[4], which then causes
> > a kernel oops in the while loop.
> >
> > I do not understand what should the correct behavior be in this
> > scenario, should we consider this vnet header as invalid?
>
> Something like the following diff:
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 57a1971f29e5..65bff1c8f75c 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2479,13 +2479,17 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
>
>  static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
>  {
> +       __u16 csum_start = __virtio16_to_cpu(vio_le(), vnet_hdr->csum_start);
> +       __u16 csum_offset = __virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset);
> +       __u16 hdr_len = __virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len);
> +
> +       if (csum_start + csum_offset == 0)
> +               return -EINVAL;
> +

Yet another virtio_net_hdr validation issue.

The issue is not unique to value 0, but true for any csum_start <
skb->transport_header at the time of the call to lco_csum. That
function not unreasonably assumes that csum_start >= l4_hdr.

The packet socket code is protocol agnostic. It does not know that
this is an IP GRE packet with greh->flags & TUNNEL_CSUM. We cannot add
checks there.

This does appear to be specific to the GRE checksum field, so it won't
be relevant to other ip tunnel devices:

                if (flags & TUNNEL_CSUM &&
                    !(skb_shinfo(skb)->gso_type &
                      (SKB_GSO_GRE | SKB_GSO_GRE_CSUM))) {
                        *ptr = 0;
                        if (skb->ip_summed == CHECKSUM_PARTIAL) {
                                *(__sum16 *)ptr = csum_fold(lco_csum(skb));

Then the check can be performed between where the ip header is pulled,
in ipgre_xmit:

        if (dev->header_ops) {
                if (skb_cow_head(skb, 0))
                        goto free_skb;

                tnl_params = (const struct iphdr *)skb->data;

                /* Pull skb since ip_tunnel_xmit() needs skb->data pointing
                 * to gre header.
                 */
                skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));   <--------
                skb_reset_mac_header(skb);
        } else {
                if (skb_cow_head(skb, dev->needed_headroom))
                        goto free_skb;

                tnl_params = &tunnel->parms.iph;
        }

        if (gre_handle_offloads(skb, !!(tunnel->parms.o_flags & TUNNEL_CSUM)))
                goto free_skb;

        __gre_xmit(skb, dev, tnl_params, skb->protocol);

and when gre_build_header resets the transport header and calls
lco_csum. gre_build_header is called from __gre_xmit in the above.

gre_handle_offloads might then be a good location. Perhaps:

    static int gre_handle_offloads(struct sk_buff *skb, bool csum)
    {
    +       if (csum && skb->csum_start < skb->data)
    +               return -EINVAL;
    +
            return iptunnel_handle_offloads(skb, csum ?
SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
     }

And same for ip6gre.

Having to add branches inside the hotpath that normally sees well
behaved packets coming from the kernel stack, only to be robust
against with malformed packets with bad virtio_net_hdr, is
unfortunate. This way, the check is at least limited to GRE packets
with TUNNEL_CSUM.

>         if ((vnet_hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
> -           (__virtio16_to_cpu(vio_le(), vnet_hdr->csum_start) +
> -            __virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset) + 2 >
> -             __virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len)))
> +           csum_start + csum_offset + 2 > hdr_len)
>                 vnet_hdr->hdr_len = __cpu_to_virtio16(vio_le(),
> -                        __virtio16_to_cpu(vio_le(), vnet_hdr->csum_start) +
> -                       __virtio16_to_cpu(vio_le(), vnet_hdr->csum_offset) + 2);
> +                               csum_start + csum_offset + 2);
>
>         if (__virtio16_to_cpu(vio_le(), vnet_hdr->hdr_len) > len)
>                 return -EINVAL;
>
> > Or should we rather accomodate for both csum_start
> > and csum_offset values to be 0 in ipgre_xmit?
> >
> > Regards,
> > Shreyansh Chouhan
> >
> > --
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/packet/af_packet.c#n2480
> > [2] https://syzkaller.appspot.com/bug?id=c391f74aac26dd8311c45743ae618f9d5e38b674
> > [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/skbuff.h#n4662
> > [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/lib/csum-partial_64.c#n35
