Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6A96487EF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLIRr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIRr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:47:27 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D3759175
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:47:26 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id s7so5637304plk.5
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 09:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zhg6wBBIkUQ+69OvVEryImDiqjxDYG19JHFgfdHHGxo=;
        b=gCXVuoMOuai7KTph2UPXEkaRCw3rmHtOp3nQFsMXzWAcuy8+pgVwEXKAQqfJwL40G5
         tZm91jDnli4IdVGI6mT3VgYxDB2T7fQYEE9BP1o3WpidQmrW1jWvP9x6NjV5J9CSQAKT
         txVGUPSv+iz2S1zvfKPGH/CR/v/C7zSbpsVvIz1DYpZwBIMf9gVJPp46rw0SlUfXHLgU
         tuLKsPmiJ2xpp//nJr1RsIJ/slyYMU1k6fGSU9jGVGgCAQbb+yj0L/jDftHZ1VSwVTJ1
         62NyhNzqy0+ejcbJTTr9DHLSJAGMQg+Y1HXWaWHoprYb4ZY67+jMKmCh5JdWvomjNXDo
         4YoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zhg6wBBIkUQ+69OvVEryImDiqjxDYG19JHFgfdHHGxo=;
        b=J7fc6fTi5Ygfh+sJUIaBbnRh2bweZy+G/Q47FcL+wZFcOcLz+qa3mJdh6ylu8+xl4X
         SkEU+tgcMpwpQPjddzyM+eKptjaZ786WN11nyWtkNTIkSJEkJMsblA7rzgjhNcd2KupX
         ADq8tBjPUyjoxWC+oOAQNQMrqrqRvtelmO7cL1Jtrx6ziC8XWA5wx19682HI2XNN5SXK
         mFQHq8nlHOrFzxDg3UESGaZCh0QQvlUxPRyb1MIfbAol9olaEwvxdW47Be6a74xmjcJQ
         nESIg43dzfdtab+u/Ja2/wkKcfod6LqC2P1qn5VUPlSQjyPjwKEs/uWu0KzhRiYT6P8q
         Yp+g==
X-Gm-Message-State: ANoB5pkxNieJWPpmnCxnKjIDgNugdP35Vj7XGmKGU+e8StkWI+8LUYNG
        5GUv6Rp49n+CnsQduv8gnsJ/NsO+n/KgyfRY+KJzwA==
X-Google-Smtp-Source: AA0mqf5M9kt7HZbyb/j9FaVCke6Rb/YOpFiRFxNSASVPXCoKT5tF5b7Mz/x4Ifu7AAywotM2IBh3MMuMtcBrhpk3lvk=
X-Received: by 2002:a17:902:d711:b0:188:c7b2:2dd with SMTP id
 w17-20020a170902d71100b00188c7b202ddmr79410245ply.88.1670608045940; Fri, 09
 Dec 2022 09:47:25 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-4-sdf@google.com>
 <f2c89c57-c377-2f8e-fb4d-b047e58d3d38@redhat.com>
In-Reply-To: <f2c89c57-c377-2f8e-fb4d-b047e58d3d38@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 9 Dec 2022 09:47:14 -0800
Message-ID: <CAKH8qBuhYUZEbs0UaUDaBOnmqjcSuim4vQhUzsLcOzPRY_eLrw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
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

On Fri, Dec 9, 2022 at 3:11 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 06/12/2022 03.45, Stanislav Fomichev wrote:
> > There is an ndo handler per kfunc, the verifier replaces a call to the
> > generic kfunc with a call to the per-device one.
> >
> > For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> > implements all possible metatada kfuncs. Not all devices have to
> > implement them. If kfunc is not supported by the target device,
> > the default implementation is called instead.
> >
> > Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
> > we treat prog_index as target device for kfunc resolution.
> >
>
> [...cut...]
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 5aa35c58c342..2eabb9157767 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -74,6 +74,7 @@ struct udp_tunnel_nic_info;
> >   struct udp_tunnel_nic;
> >   struct bpf_prog;
> >   struct xdp_buff;
> > +struct xdp_md;
> >
> >   void synchronize_net(void);
> >   void netdev_set_default_ethtool_ops(struct net_device *dev,
> > @@ -1611,6 +1612,10 @@ struct net_device_ops {
> >       ktime_t                 (*ndo_get_tstamp)(struct net_device *dev,
> >                                                 const struct skb_shared_hwtstamps *hwtstamps,
> >                                                 bool cycles);
> > +     bool                    (*ndo_xdp_rx_timestamp_supported)(const struct xdp_md *ctx);
> > +     u64                     (*ndo_xdp_rx_timestamp)(const struct xdp_md *ctx);
> > +     bool                    (*ndo_xdp_rx_hash_supported)(const struct xdp_md *ctx);
> > +     u32                     (*ndo_xdp_rx_hash)(const struct xdp_md *ctx);
> >   };
> >
>
> Would it make sense to add a 'flags' parameter to ndo_xdp_rx_timestamp
> and ndo_xdp_rx_hash ?
>
> E.g. we could have a "STORE" flag that asks the kernel to store this
> information for later. This will be helpful for both the SKB and
> redirect use-cases.
> For redirect e.g into a veth, then BPF-prog can use the same function
> bpf_xdp_metadata_rx_hash() to receive the RX-hash, as it can obtain the
> "stored" value (from the BPF-prog that did the redirect).
>
> (p.s. Hopefully a const 'flags' variable can be optimized when unrolling
> to eliminate store instructions when flags==0)

Are we concerned that doing this without a flag and with another
function call will be expensive?
For xdp->skb path, I was hoping we would be to do something like:

timestamp = bpf_xdp_metadata_rx_hash(ctx);
bpf_xdp_metadata_export_rx_hash_to_skb(ctx, timestamp);

This should also let the users adjust the metadata before storing it.
Am I missing something here? Why would the flag be preferable?


> >   /**
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 55dbc68bfffc..c24aba5c363b 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -409,4 +409,33 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
> >
> >   #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
> >
> > +#define XDP_METADATA_KFUNC_xxx       \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
> > +                        bpf_xdp_metadata_rx_timestamp_supported) \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
> > +                        bpf_xdp_metadata_rx_timestamp) \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED, \
> > +                        bpf_xdp_metadata_rx_hash_supported) \
> > +     XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
> > +                        bpf_xdp_metadata_rx_hash) \
> > +
> > +enum {
> > +#define XDP_METADATA_KFUNC(name, str) name,
> > +XDP_METADATA_KFUNC_xxx
> > +#undef XDP_METADATA_KFUNC
> > +MAX_XDP_METADATA_KFUNC,
> > +};
> > +
> > +#ifdef CONFIG_NET
> > +u32 xdp_metadata_kfunc_id(int id);
> > +#else
> > +static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> > +#endif
> > +
> > +struct xdp_md;
> > +bool bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx);
> > +u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx);
> > +bool bpf_xdp_metadata_rx_hash_supported(const struct xdp_md *ctx);
> > +u32 bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx);
> > +
>
