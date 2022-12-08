Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D136475FB
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLHTIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiLHTH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:07:57 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687474B745
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:07:55 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id g1so2040346pfk.2
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LJ7eeOZL8N+ixNEyuwLxJlm56Cp+9F6miXSVQSvbV1w=;
        b=tBRJ1B4gYb29BzwSOqyC11vVld7yLj8K4I0/vHbVZtJt50a4MFZtk/GrPyKMGpU05v
         JY2sNRF5IPmR5Mfcy8p0A8i+ld7MUgHhAuN/So2mkphayZOdLmkcHy9/C49qhQs2k8x1
         grAs+nmD+MRtC5opnn2FBNBzGgXzpui4YgyAB1OK8UP1lv1S4PAGwNHlUR/tiAIDUf1N
         TWIRKcZ1MFyamXIx65L96P5dgBRhIkwSQhIYN4wOtW+iqtRU2Yo8MlO1c8pMIJkJxvh0
         2RtenYAgnvGCPOYr9YlmYiNArNC5pLX6rmM4d/SO9iv3lWLLJkPtHpj3iOjcGA/iVKL1
         +iEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LJ7eeOZL8N+ixNEyuwLxJlm56Cp+9F6miXSVQSvbV1w=;
        b=HpEL8vZdbYIGvPEyaU3ciORr5LM1/qvVA4MNc0HVYFxPFLFj5Hg3IW7XHB7GDmfoTD
         yn0pHettcr26Ik+kiaJP9tU7DXQAOf+jvCGUvqhfHSnrbHiFYx2TlpCEQeWjvFcVFcVH
         Xrb4qqeXwhh576SsgP9EDcKighS8muomYE2HiScENc7iCue6NVhbbqWO1CnkWgTaSanl
         7Tw+G9cc56NNurbqUzpcbj2EIDMT0ie5xO6jhruT6CHj91LTOq+zchr7Ge08SRY6oLAd
         iasWihM97GL2JmW7j5JsKhP0xDZ8aMUlsCkGYNWFFcgeA7T8UKi1zuZOddSrkz4Y/79K
         wB7A==
X-Gm-Message-State: ANoB5pklEkiX32dC5hjkDLUtl4ExFwNUKyp63JWf9EAbe3dEnWB/qVWS
        PjscwTiL4gRi4W+W4bY+cgeqNu7A/HcIbPSj9dxBqQ==
X-Google-Smtp-Source: AA0mqf7GfkAQ1EMUVVxDe6o/VMPnCRS///aZLSdE3MRghnCupekr3vOIvq1jseuMZGjXkH4/zM4SYYwwc0N0OtdWmdc=
X-Received: by 2002:a62:5b43:0:b0:573:6cfc:2210 with SMTP id
 p64-20020a625b43000000b005736cfc2210mr80595152pfb.55.1670526474708; Thu, 08
 Dec 2022 11:07:54 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-4-sdf@google.com>
 <20221207210019.41dc9b6b@kernel.org>
In-Reply-To: <20221207210019.41dc9b6b@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 11:07:43 -0800
Message-ID: <CAKH8qBtAQe=b1BLR5RKu7mBynQf0arp4G9+DtvcWVNKNK_27vA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
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

On Wed, Dec 7, 2022 at 9:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> The offload tests still pass after this, right?

Yeah, had to bring them back in shape just for the purpose of making
sure they're still happy:
https://lore.kernel.org/bpf/20221206232739.2504890-1-sdf@google.com/

> TBH I don't remember this code well enough to spot major issues.

No worries! Appreciate the review and the comments on consistency; I'm
also mostly unaware how this whole offloading works :-)

> On Mon,  5 Dec 2022 18:45:45 -0800 Stanislav Fomichev wrote:
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
>
> > @@ -2476,10 +2477,18 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
> >                                      struct net_device *netdev);
> >  bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
> >
> > +void *bpf_offload_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
>
> There seems to be some mis-naming going on. I expected:
>
>   offloaded =~ nfp
>   dev_bound == XDP w/ funcs
>
> *_offload_resolve_kfunc looks misnamed? Unless you want to resolve
> for HW offload?

Yeah, I had the same expectations, but I was also assuming that this
bpf_offload_resolve_kfunc might also at some point handle offloaded
metadata kfuncs.
But looking at it again, agree that the following looks a bit off:

if (bpf_prog_is_dev_bound()) {
   xxx = bpf_offload_resolve_kfunc()
}

Let me use the dev_bound prefix more consistently here and in the
other places you've pointed out.

> >  void unpriv_ebpf_notify(int new_state);
> >
> >  #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
> >  int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
> > +void bpf_offload_bound_netdev_unregister(struct net_device *dev);
>
> ditto: offload_bound is a mix of terms no?

Ack, will do bpf_dev_bound_netdev_unregister here, thanks!

> > @@ -1611,6 +1612,10 @@ struct net_device_ops {
> >       ktime_t                 (*ndo_get_tstamp)(struct net_device *dev,
> >                                                 const struct skb_shared_hwtstamps *hwtstamps,
> >                                                 bool cycles);
> > +     bool                    (*ndo_xdp_rx_timestamp_supported)(const struct xdp_md *ctx);
> > +     u64                     (*ndo_xdp_rx_timestamp)(const struct xdp_md *ctx);
> > +     bool                    (*ndo_xdp_rx_hash_supported)(const struct xdp_md *ctx);
> > +     u32                     (*ndo_xdp_rx_hash)(const struct xdp_md *ctx);
> >  };
>
> Is this on the fast path? Can we do an indirection?

No, we resolve them at load time from "generic"
bpf_xdp_metadata_rx_<xxx> to ndo_xdp_rx_<xxx>.

> Put these ops in their own struct and add a pointer to that struct
> in net_device_ops? Purely for grouping reasons because the netdev
> ops are getting orders of magnitude past the size where you can
> actually find stuff in this struct.

Oh, great idea, will do!

> >       bpf_free_used_maps(aux);
> >       bpf_free_used_btfs(aux);
> > -     if (bpf_prog_is_offloaded(aux))
> > +     if (bpf_prog_is_dev_bound(aux))
> >               bpf_prog_offload_destroy(aux->prog);
>
> This also looks a touch like a mix of terms (condition vs function
> called).

Here, not sure, open to suggestions. These
bpf_prog_offload_init/bpf_prog_offload_destroy are generic enough
(now) that I'm calling them for both dev_bound/offloaded.

The following paths trigger for both offloaded/dev_bound cases:

if (bpf_prog_is_dev_bound()) bpf_prog_offload_init();
if (bpf_prog_is_dev_bound()) bpf_prog_offload_destroy();

Do you think it's worth it having completely separate
dev_bound/offloaded paths? Or, alternatively, can rename to
bpf_prog_dev_bound_{init,destroy} but still handle both cases?

> > +static int __bpf_offload_init(void);
> > +static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
> > +                                          struct net_device *netdev);
> > +static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
> > +                                             struct net_device *netdev);
>
> fwd declarations are yuck

SG, will move them here instead.

> >  static int bpf_dev_offload_check(struct net_device *netdev)
> >  {
> >       if (!netdev)
> > @@ -87,13 +93,17 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> >           attr->prog_type != BPF_PROG_TYPE_XDP)
> >               return -EINVAL;
> >
> > -     if (attr->prog_flags)
> > +     if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
> >               return -EINVAL;
> >
> >       offload = kzalloc(sizeof(*offload), GFP_USER);
> >       if (!offload)
> >               return -ENOMEM;
> >
> > +     err = __bpf_offload_init();
> > +     if (err)
> > +             return err;
>
> leaks offload

Oops, let me actually move this to late_initcall as you suggest below.

> > @@ -209,6 +233,19 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
> >       up_read(&bpf_devs_lock);
> >  }
> >
> > +static void maybe_remove_bound_netdev(struct net_device *dev)
> > +{
>
> func name prefix ?

Good point, will rename to bpf_dev_bound_try_remove_netdev.

> > -struct bpf_offload_dev *
> > -bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
> > +static int __bpf_offload_init(void)
> >  {
> > -     struct bpf_offload_dev *offdev;
> >       int err;
> >
> >       down_write(&bpf_devs_lock);
> > @@ -680,12 +740,25 @@ bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
> >               err = rhashtable_init(&offdevs, &offdevs_params);
> >               if (err) {
> >                       up_write(&bpf_devs_lock);
> > -                     return ERR_PTR(err);
> > +                     return err;
> >               }
> >               offdevs_inited = true;
> >       }
> >       up_write(&bpf_devs_lock);
> >
> > +     return 0;
> > +}
>
> Would late_initcall() or some such not work for this?

Agreed, let's move it to the initcall instead.

> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 5b221568dfd4..862e03fcffa6 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -9228,6 +9228,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
> >                       NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");
>
> extack should get updated here, I reckon, maybe in previous patch

Oh, thanks for spotting, will fix.

> >                       return -EINVAL;
> >               }
> > +             if (bpf_prog_is_dev_bound(new_prog->aux) && !bpf_offload_dev_match(new_prog, dev)) {
>
> bound_dev_match() ?

Right, so this is another case where it works for both cases. Maybe
rename to bpf_dev_bound_match and use for both offloaded/dev_bound? Or
do you prefer completely separate paths?

> > +                     NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");
>
> different than.. ?

Borrowing from netdevsim, lmk if the following won't work here:

"Program bound to different device"

> > +                     return -EINVAL;
> > +             }
> >               if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
> >                       NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
> >                       return -EINVAL;
