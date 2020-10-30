Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0137E2A0A60
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgJ3Pu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgJ3PuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:50:24 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B264C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:50:23 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id r17so1547488vkf.6
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gtkXqSXeZ0niBcrY1U1mimvyg988mPc0A08k1zPHfyo=;
        b=Xj6zpqLY6m6TGo2+TWWnmV5XQolSSy2qt4J/xqlbdfCOsimKOYNB2+Ghq7b2ylJoCS
         PtPUNkiQa/kQ5atpFV/jp7iddjyij2QFdluzGVVffMfPmKGb+yg8xWW2FCpykG/wo2Hh
         oaUGvDrQo6fk0UAs0CUaECTmW1X/gzRPeymkkWI7hELduvL1uQOwA1PfwQhO+c+LqPg/
         y2eZOnGVGZ9VvGcoQPWrRcKDgs6o4PpmLwAT577C2SwnR1rJYwalMMQ11ojO8dXZ09Jj
         dVVBRTILIV78x9eGahkbS7VO/Po2y9MnC5TIrZFduBWzVQSXujX6uSygWzPpgm2dVHIL
         j+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gtkXqSXeZ0niBcrY1U1mimvyg988mPc0A08k1zPHfyo=;
        b=liRzvVahOEJgWx0GwmkViRKOwuCP4I3c6YL/dCLk387p5Nbf//Iq+ynALHHOIjEqQP
         dHR0CcAi5cm+kZeYCn9oagUjeB7MCwP4E9U8zhAIzHmNca0aGe6E6GNtHBfAriIed9H1
         aOoegk+2SCBbSDqDQwDksM1f80hHwWSpdkjpi8W0KY7e+6+4fQMfGmOEl4v9cZZuQstU
         kZGNU1Ku+Bf9iFD9cjq3WJdsKeaE98S3fp/TNm5xkbPFn6Wz80U1WAUoHNHaKBBVkCPw
         0YY0AOKaoHoyeTH5qEo+c3WpstUPAs9eJgNYltHnllb3Hlgrda23N6EIvVFFIWV901UZ
         DvQQ==
X-Gm-Message-State: AOAM531onUPoD/FWygb+HBqBUo5PawXijVToxvUUMdEjiGwK/BFbGHq/
        aQQN8Qm4XLs8Y05jNLBHgPK9dvCT/+g=
X-Google-Smtp-Source: ABdhPJyKU16y0gbr4tLUCiPIv/AxoDkuUKo+qLmL+6Gz7JxxlYe27Ku7JC75AtTiNSVGDGID3zbVCg==
X-Received: by 2002:a1f:2389:: with SMTP id j131mr7651535vkj.18.1604073022171;
        Fri, 30 Oct 2020 08:50:22 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id c21sm230891vsh.31.2020.10.30.08.50.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 08:50:21 -0700 (PDT)
Received: by mail-vs1-f44.google.com with SMTP id x11so1035903vsx.12
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:50:20 -0700 (PDT)
X-Received: by 2002:a67:c981:: with SMTP id y1mr7538434vsk.14.1604073020412;
 Fri, 30 Oct 2020 08:50:20 -0700 (PDT)
MIME-Version: 1.0
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com> <94ca05ca-2871-3da6-e14f-0a9cb48ed2a5@solarflare.com>
In-Reply-To: <94ca05ca-2871-3da6-e14f-0a9cb48ed2a5@solarflare.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 11:49:44 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdaPV_ZsU=YfT6vAx-ScGWu1O1Ji1ubNmgxe4PZYYNfZw@mail.gmail.com>
Message-ID: <CA+FuTSdaPV_ZsU=YfT6vAx-ScGWu1O1Ji1ubNmgxe4PZYYNfZw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] sfc: implement encap TSO on EF100
To:     Edward Cree <ecree@solarflare.com>
Cc:     linux-net-drivers@solarflare.com, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 9:39 PM Edward Cree <ecree@solarflare.com> wrote:
>
> The NIC only needs to know where the headers it has to edit (TCP and
>  inner and outer IPv4) are, which fits GSO_PARTIAL nicely.
> It also supports non-PARTIAL offload of UDP tunnels, again just
>  needing to be told the outer transport offset so that it can edit
>  the UDP length field.
> (It's not clear to me whether the stack will ever use the non-PARTIAL
>  version with the netdev feature flags we're setting here.)
>
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/ef100_nic.c | 13 ++++++--
>  drivers/net/ethernet/sfc/ef100_tx.c  | 45 ++++++++++++++++------------
>  2 files changed, 37 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index 3148fe770356..bf92cdc60cda 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -182,8 +182,16 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>         if (rc)
>                 return rc;
>
> -       if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3))
> -               efx->net_dev->features |= NETIF_F_TSO | NETIF_F_TSO6;
> +       if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
> +               struct net_device *net_dev = efx->net_dev;
> +               netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
> +                                       NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
> +
> +               net_dev->features |= tso;
> +               net_dev->hw_features |= tso;
> +               net_dev->hw_enc_features |= tso;
> +               net_dev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
> +       }
>         efx->num_mac_stats = MCDI_WORD(outbuf,
>                                        GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
>         netif_dbg(efx, probe, efx->net_dev,
> @@ -1101,6 +1109,7 @@ static int ef100_probe_main(struct efx_nic *efx)
>         nic_data->efx = efx;
>         net_dev->features |= efx->type->offload_features;
>         net_dev->hw_features |= efx->type->offload_features;
> +       net_dev->hw_enc_features |= efx->type->offload_features;
>
>         /* Populate design-parameter defaults */
>         nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
> diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
> index a90e5a9d2a37..d267b12bdaa0 100644
> --- a/drivers/net/ethernet/sfc/ef100_tx.c
> +++ b/drivers/net/ethernet/sfc/ef100_tx.c
> @@ -54,8 +54,6 @@ static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
>         struct efx_nic *efx = tx_queue->efx;
>         struct ef100_nic_data *nic_data;
>         struct efx_tx_buffer *buffer;
> -       struct tcphdr *tcphdr;
> -       struct iphdr *iphdr;
>         size_t header_len;
>         u32 mss;
>
> @@ -98,20 +96,6 @@ static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
>         buffer->unmap_len = 0;
>         buffer->skb = skb;
>         ++tx_queue->insert_count;
> -
> -       /* Adjust the TCP checksum to exclude the total length, since we set
> -        * ED_INNER_IP_LEN in the descriptor.
> -        */
> -       tcphdr = tcp_hdr(skb);
> -       if (skb_is_gso_v6(skb)) {
> -               tcphdr->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
> -                                                &ipv6_hdr(skb)->daddr,
> -                                                0, IPPROTO_TCP, 0);
> -       } else {
> -               iphdr = ip_hdr(skb);
> -               tcphdr->check = ~csum_tcpudp_magic(iphdr->saddr, iphdr->daddr,
> -                                                  0, IPPROTO_TCP, 0);
> -       }
>         return true;
>  }
>
> @@ -209,17 +193,35 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
>                 ESE_GZ_TX_DESC_IP4_ID_INC_MOD16;
>         u16 vlan_enable =  efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX ?
>                 skb_vlan_tag_present(skb) : 0;
> +       bool gso_partial = skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL;
>         unsigned int len, ip_offset, tcp_offset, payload_segs;
> +       unsigned int outer_ip_offset, outer_l4_offset;
>         u16 vlan_tci = skb_vlan_tag_get(skb);
>         u32 mss = skb_shinfo(skb)->gso_size;
> +       bool encap = skb->encapsulation;
> +       struct tcphdr *tcp;
> +       u32 paylen;
>
>         len = skb->len - buffer->len;
>         /* We use 1 for the TSO descriptor and 1 for the header */
>         payload_segs = segment_count - 2;
> -       ip_offset =  skb_network_offset(skb);
> -       tcp_offset = skb_transport_offset(skb);
> +       if (encap) {
> +               outer_ip_offset = skb_network_offset(skb);
> +               outer_l4_offset = skb_transport_offset(skb);
> +               ip_offset = skb_inner_network_offset(skb);
> +               tcp_offset = skb_inner_transport_offset(skb);
> +       } else {
> +               ip_offset =  skb_network_offset(skb);
> +               tcp_offset = skb_transport_offset(skb);
> +               outer_ip_offset = outer_l4_offset = 0;
> +       }
> +
> +       /* subtract TCP payload length from inner checksum */
> +       tcp = (void *)skb->data + tcp_offset;
> +       paylen = skb->len - tcp_offset;
> +       csum_replace_by_diff(&tcp->check, (__force __wsum)htonl(paylen));
>
> -       EFX_POPULATE_OWORD_13(*txd,
> +       EFX_POPULATE_OWORD_17(*txd,
>                               ESF_GZ_TX_DESC_TYPE, ESE_GZ_TX_DESC_TYPE_TSO,
>                               ESF_GZ_TX_TSO_MSS, mss,
>                               ESF_GZ_TX_TSO_HDR_NUM_SEGS, 1,
> @@ -231,6 +233,11 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
>                               ESF_GZ_TX_TSO_INNER_L4_OFF_W, tcp_offset >> 1,
>                               ESF_GZ_TX_TSO_ED_INNER_IP4_ID, mangleid,
>                               ESF_GZ_TX_TSO_ED_INNER_IP_LEN, 1,
> +                             ESF_GZ_TX_TSO_OUTER_L3_OFF_W, outer_ip_offset >> 1,
> +                             ESF_GZ_TX_TSO_OUTER_L4_OFF_W, outer_l4_offset >> 1,
> +                             ESF_GZ_TX_TSO_ED_OUTER_UDP_LEN, encap && !gso_partial,

This is a boolean field to signal whether the NIC needs to fix up the
udp length field ?

Which in the case of GSO_PARTIAL has already been resolved by the gso
layer (in __skb_udp_tunnel_segment).

Just curious, is this ever expected to be true? Not based on current
advertised features, right?

> +                             ESF_GZ_TX_TSO_ED_OUTER_IP4_ID, encap ? mangleid :
> +                                                                    ESE_GZ_TX_DESC_IP4_ID_NO_OP,
>                               ESF_GZ_TX_TSO_VLAN_INSERT_EN, vlan_enable,
>                               ESF_GZ_TX_TSO_VLAN_INSERT_TCI, vlan_tci
>                 );
>
