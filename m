Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AC164BE10
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiLMUnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 15:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbiLMUmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 15:42:52 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15515F9A
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 12:42:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id js9so4659978pjb.2
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 12:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mw6o97BKfXktyyVGSYdZ6GG05jkfRnabZbvxc9SPzNo=;
        b=NREQaBQ8vd+Ik0nteikGkPcAliQveseVFD2CJihuTvy+lzMdb1PxCCa5UUgYrzijxb
         Bi/cnVnRiPPe7brAvH4nAxNurWz5e0RkgrxW0P14RyiR9X/b0bUeCZyhU9Yd2fpMhr2+
         6nzEd9u2v+4SKt6nj1tCjJ4Ziw5bMCGcAsPC7O2v7o3xrxFnvZMt5MqC+FhY/5pQkbxk
         MJcv7kVkWplKdQnsrydqDbz/6idQFKopxTT2KpiJY5XgGNVacRozi8ZwUqMDR9hhEw4M
         EqJCC8mdgWVkCZG9bg/oBLODGvyXtGV8eLg8dY0/vlf2Ebbpr2Q3M6JOOQJpcU7e9wNT
         aBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mw6o97BKfXktyyVGSYdZ6GG05jkfRnabZbvxc9SPzNo=;
        b=CScEZqupY19QOlTMY8dRddJtHA3ZRdBtu7hcOnEqqXUebcBjRh5jDq+SDdid+FYkot
         NBoLgsmF86M8qI2Preaw1AJNoDUJPFR8PPo67ohe8mp8EA2U4+IfrFjPf7tEpuCZyXKi
         faqDgB17LHlETlRFObjYcAKtFam+vspINoV0NSeV+sR1eWmY1BSe7I1UVq549HJJgJE0
         id9EW3Y+iD2k/5BpO69x84Mqr3wv2jxnw1BqFDlzT4JcKaRMsyvmVBvX/6Dbe6n6S4oi
         zq7ZJYnyq8i7Y1eLg3IGHl+aJSkNat4X+iY2kqv3Z+2Wh+PKEYGaguLIqxj9LM8VNlF7
         4cow==
X-Gm-Message-State: ANoB5pk43m0uFANbhgg+MXLblnlsuNbwrpVvsAIqBuDdg985vdC8CH/z
        JGbiHZZiN7kupn7Q/BXhWAmKi1IRqY9m5gikVXEpVQ==
X-Google-Smtp-Source: AA0mqf7PdrGhtnuitcAaimxm2QKamEUQRI2MG8nDZ6vjPXAtRyL2DZBW5mag1YBOrsWTFMaqr9Ow9a+Q2gBP9mLG1B8=
X-Received: by 2002:a17:902:ab5c:b0:189:97e2:ab8b with SMTP id
 ij28-20020a170902ab5c00b0018997e2ab8bmr49293561plb.131.1670964171088; Tue, 13
 Dec 2022 12:42:51 -0800 (PST)
MIME-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com> <20221213023605.737383-9-sdf@google.com>
 <7ca8ac2c-7c07-a52f-ec17-d1ba86fa45ab@redhat.com>
In-Reply-To: <7ca8ac2c-7c07-a52f-ec17-d1ba86fa45ab@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 13 Dec 2022 12:42:39 -0800
Message-ID: <CAKH8qBvCxnJ2-5gd9j1HYxMA8CNi6cQM-5WOUBghiZjHUHya3A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 08/15] veth: Support RX XDP metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 7:55 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 13/12/2022 03.35, Stanislav Fomichev wrote:
> > The goal is to enable end-to-end testing of the metadata for AF_XDP.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   drivers/net/veth.c | 24 ++++++++++++++++++++++++
> >   1 file changed, 24 insertions(+)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 04ffd8cb2945..d5491e7a2798 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -118,6 +118,7 @@ static struct {
> >
> >   struct veth_xdp_buff {
> >       struct xdp_buff xdp;
> > +     struct sk_buff *skb;
> >   };
> >
> >   static int veth_get_link_ksettings(struct net_device *dev,
> > @@ -602,6 +603,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
> >
> >               xdp_convert_frame_to_buff(frame, xdp);
> >               xdp->rxq = &rq->xdp_rxq;
> > +             vxbuf.skb = NULL;
> >
> >               act = bpf_prog_run_xdp(xdp_prog, xdp);
> >
> > @@ -823,6 +825,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
> >       __skb_push(skb, skb->data - skb_mac_header(skb));
> >       if (veth_convert_skb_to_xdp_buff(rq, xdp, &skb))
> >               goto drop;
> > +     vxbuf.skb = skb;
> >
> >       orig_data = xdp->data;
> >       orig_data_end = xdp->data_end;
> > @@ -1601,6 +1604,21 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> >       }
> >   }
> >
> > +static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
> > +{
> > +     *timestamp = ktime_get_mono_fast_ns();
>
> This should be reading the hardware timestamp in the SKB.
>
> Details: This hardware timestamp in the SKB is located in
> skb_shared_info area, which is also available for xdp_frame (currently
> used for multi-buffer purposes).  Thus, when adding xdp-hints "store"
> functionality, it would be natural to store the HW TS in the same place.
> Making the veth skb/xdp_frame code paths able to share code.

Does something like the following look acceptable as well?

*timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;
if (!*timestamp)
        *timestamp = ktime_get_mono_fast_ns(); /* sw fallback */

Because I'd like to be able to test this path in the selftests. As
long as I get some number from veth_xdp_rx_timestamp, I can test it.
No amount of SOF_TIMESTAMPING_{SOFTWARE,RX_SOFTWARE,RAW_HARDWARE}
triggers non-zero hwtstamp for xsk receive path. Any suggestions?


> > +     return 0;
> > +}
> > +
> > +static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
> > +{
> > +     struct veth_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     if (_ctx->skb)
> > +             *hash = skb_get_hash(_ctx->skb);
> > +     return 0;
> > +}
> > +
> >   static const struct net_device_ops veth_netdev_ops = {
> >       .ndo_init            = veth_dev_init,
> >       .ndo_open            = veth_open,
> > @@ -1622,6 +1640,11 @@ static const struct net_device_ops veth_netdev_ops = {
> >       .ndo_get_peer_dev       = veth_peer_dev,
> >   };
> >
> > +static const struct xdp_metadata_ops veth_xdp_metadata_ops = {
> > +     .xmo_rx_timestamp               = veth_xdp_rx_timestamp,
> > +     .xmo_rx_hash                    = veth_xdp_rx_hash,
> > +};
> > +
> >   #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
> >                      NETIF_F_RXCSUM | NETIF_F_SCTP_CRC | NETIF_F_HIGHDMA | \
> >                      NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL | \
> > @@ -1638,6 +1661,7 @@ static void veth_setup(struct net_device *dev)
> >       dev->priv_flags |= IFF_PHONY_HEADROOM;
> >
> >       dev->netdev_ops = &veth_netdev_ops;
> > +     dev->xdp_metadata_ops = &veth_xdp_metadata_ops;
> >       dev->ethtool_ops = &veth_ethtool_ops;
> >       dev->features |= NETIF_F_LLTX;
> >       dev->features |= VETH_FEATURES;
>
