Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605F4619FB7
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiKDSWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiKDSWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:22:11 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAD34AF28
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 11:22:00 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id o13so3009537ilc.7
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 11:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K1k4WN2r7t/52mL+ugQRSlpNfDTjZcSRsmfM/st8EfQ=;
        b=NlOjSeut/Chjx9weuZnDn0wAec7Z5R9jiU7mFJRiMWsKCli0GmxJHUCin/Oh+0s/0k
         bDnY42jcAwS3M1Sa49AL8vAviZi1gszjv+ollhC317fRIvcrtXznA35Fy2RLkWe061J0
         +FZryw8HiQVOvM6prKMFJVSez5nyYshL2L4TWOpyWXC57f15w1BkqMHiJapPoViSiDM4
         1TMDTPYMWSFUOacJyaITm/BxSs2hYg3t4SHZrkLnsjUMmCc1LOQUJSvFKYej1POjAG2t
         RSUqKuk3cX6pAsgnWoTiGqQndg5t26yTCwkrmKl9lR45vXkBhUm5R1+KBTXN/pwfA5Fk
         tqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K1k4WN2r7t/52mL+ugQRSlpNfDTjZcSRsmfM/st8EfQ=;
        b=dpqKDDUpueKf2eJ14BFV6ITfawoaYOlwh09o7JKQ8JkimxT1qIYkoRJzOPdWpJWC5+
         AzYYNUTzAW3EbPcOxjqAcXaE6FJlKEqL8qhxKIsQy/HFRdZbAzrZZVt8wNq5e/gRKetF
         qB1v/mNFKPZra7lch59puvcOaiPzxP6aATA7ILH1ztMcwgw3KisNA08At9l6Dl0lZL49
         0bkk3uamQlNjpUB+a/JUqg4nhCI8jgdISCMLetcNA5MLO7WyzgPKZyKXUvfdwejear5B
         GlXEv1dmJ+hzU9BeBD93LpUFpyynAaJ56IH58uPM725MWVeqn/fC8VZv/4jIbwcnSSmn
         b71w==
X-Gm-Message-State: ACrzQf1o4yYg8IZMbPte5Han7YTiu3Ur66M2zRBccvHldeg3YV0EUEUP
        aKBALLmaulmvxJJWpunqcLNeSU1JbEFO/8yLylTGuA==
X-Google-Smtp-Source: AMsMyM70/MrBu8d7nQRFy0qecyRBPBOyVm88lmIP3GwrqmytkGF4i+QrzWrr4vvTceF6CORiXQSlRTFz/GZDSOsUdf4=
X-Received: by 2002:a92:d3ca:0:b0:2ff:fb6a:5c38 with SMTP id
 c10-20020a92d3ca000000b002fffb6a5c38mr22312218ilh.259.1667586120229; Fri, 04
 Nov 2022 11:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-11-sdf@google.com>
 <20221104143547.3575615-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221104143547.3575615-1-alexandr.lobakin@intel.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 4 Nov 2022 11:21:47 -0700
Message-ID: <CAKH8qBuaJ1usZEirN9=ReugusS8t_=Mn0LoFdy93iOYpHs2+Yg@mail.gmail.com>
Subject: Re: [RFC bpf-next v2 10/14] ice: Support rx timestamp metadata for xdp
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
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

On Fri, Nov 4, 2022 at 7:38 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Stanislav Fomichev <sdf@google.com>
> Date: Thu,3 Nov 2022 20:25:28 -0700
>
> > COMPILE-TESTED ONLY!
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
> >  drivers/net/ethernet/intel/ice/ice.h      |  5 ++
> >  drivers/net/ethernet/intel/ice/ice_main.c |  1 +
> >  drivers/net/ethernet/intel/ice/ice_txrx.c | 75 +++++++++++++++++++++++
> >  3 files changed, 81 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> > index f88ee051e71c..c51a392d64a4 100644
> > --- a/drivers/net/ethernet/intel/ice/ice.h
> > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > @@ -925,6 +925,11 @@ int ice_open_internal(struct net_device *netdev);
> >  int ice_stop(struct net_device *netdev);
> >  void ice_service_task_schedule(struct ice_pf *pf);
> >
> > +struct bpf_insn;
> > +struct bpf_patch;
> > +void ice_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
> > +                   struct bpf_patch *patch);
> > +
> >  /**
> >   * ice_set_rdma_cap - enable RDMA support
> >   * @pf: PF struct
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> > index 1f27dc20b4f1..8ddc6851ef86 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -9109,4 +9109,5 @@ static const struct net_device_ops ice_netdev_ops = {
> >       .ndo_xdp_xmit = ice_xdp_xmit,
> >       .ndo_xsk_wakeup = ice_xsk_wakeup,
> >       .ndo_get_devlink_port = ice_get_devlink_port,
> > +     .ndo_unroll_kfunc = ice_unroll_kfunc,
> >  };
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > index 1b6afa168501..e9b5e883753e 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/netdevice.h>
> >  #include <linux/prefetch.h>
> >  #include <linux/bpf_trace.h>
> > +#include <linux/bpf_patch.h>
> >  #include <net/dsfield.h>
> >  #include <net/mpls.h>
> >  #include <net/xdp.h>
> > @@ -1098,8 +1099,80 @@ ice_is_non_eop(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
> >
> >  struct ice_xdp_buff {
> >       struct xdp_buff xdp;
> > +     struct ice_rx_ring *rx_ring;
> > +     union ice_32b_rx_flex_desc *rx_desc;
> >  };
> >
> > +void ice_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
> > +                   struct bpf_patch *patch)
> > +{
> > +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
> > +             return xdp_metadata_export_to_skb(prog, patch);
>
> Hey,
>
> FYI, our team wants to write a follow-up patch with ice support
> added, not like a draft, more of a mature code. I'm thinking of
> calling ice C function which would process Rx descriptors from
> that BPF code from the unrolling callback -- otherwise,
> implementing a couple hundred C code lines from ice_txrx_lib.c
> would be a bit too much :D

Sounds good! I would gladly drop all/most of the driver changes for
the non-rfc posting :-)
I'll probably have a mlx4 one because there is a chance I might find
HW, but the rest I'll drop most likely.
(they are here to show how the driver changes might look like, hence
compile-tested only)

Btw, does it make sense to have some small xsk selftest binary that
can be used to test the metadata with the real device?
The one I'm having right now depends on veth/namespaces; having a
similar one for the real hardware to qualify it sounds useful?
Something simple that sets up af_xdp for all queues, divers some
traffic, and exposes to the userspace consumer all the info about
frame metadata...
Or maybe there is something I can reuse already?


> > +     } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > +             /* return true; */
> > +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
> > +     } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
>
> [...]
>
> > --
> > 2.38.1.431.g37b22c650d-goog
>
> Thanks,
> Olek
