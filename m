Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EDF49B002
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiAYJWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456999AbiAYJNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:13:52 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ECDC061744;
        Tue, 25 Jan 2022 01:06:24 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id x11so12833922plg.6;
        Tue, 25 Jan 2022 01:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSZ2MCYaAgnou8TOlrpilfOFZgn86OLEFUO+LImgoUI=;
        b=D1XSzdhpeqcHpFkLgUViW7bE3eKL+8VLkOyuXZGFc9lwCfHwLy9biWBU51hsWZ8PgX
         In2DhTbBd/BAm024SFnXAoAF4//Viwfmq78NJNPPrhOVRAcUsRQFakTQ+6Tq2d/XD2ST
         cNZjdGfDJkgY3H6Lv9f6FmfbwQbLOgaQuYcrVk3avgZilmqNvhrS4lrJ4VgljTbACvcZ
         x3xQSDcgfQQ0zowiUYL1b8bI7uvvla0qGPyDW41VhrWcg3LU62j3Fxqa1PeVM6GmBmSY
         saGKcl4YvH7paEiWd4U/XPUBxoiEuVxEtoxOxJ8TmkDAXYKfODX++KDon0Zumlrz2mUB
         gRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSZ2MCYaAgnou8TOlrpilfOFZgn86OLEFUO+LImgoUI=;
        b=4t4C231Yb/t5+E4Ei6Cht2HfE/2ik8wrwT7PdHVhCFlVnvSxZonyZ2Ultm7RNn4ptw
         NW2rjUoac+50QbFhhH7DQM4yw8FI3rr/UvOnE7W4JKmCNxVMbL3dxnu+0zqeuQx8T4Mw
         eEFny7dhhfDQE4REbSbrSPsieUwqqcjnEZLi7/vBH4PyYBd+YBBNd+oU+cElXJaHB9y1
         eTCeXXD2FM2I6DcqVonncBcSSh36J/T6txsVb9p+OTQlouyo+mFKxQNV95V/jswnA+g+
         qUrZ1Sp1Kycdnh2rFflckVXZDXgMcuKSwSbtsJk4/hfBGCLA0TA2TYLoJflN/fj9AW7u
         lXTQ==
X-Gm-Message-State: AOAM530bd1+FfHlgd7JPy8JSvzObmvGP/ZBSaiDGU566KyvrtHOp3cyo
        pm8mKD6CO4UDUnFHwoZWUd1b8V+FcfmQjc+BwWGwJMtrnKpK07+G
X-Google-Smtp-Source: ABdhPJy+zkAEsFS42pQrvVT0J2jq+oXJn6lE0OUpa5TDxwUwzHLfjfzM1R1pRoAYvSNR0a/voSFWX28s4jCuLkFBHqw=
X-Received: by 2002:a17:902:b110:b0:14a:197:dfea with SMTP id
 q16-20020a170902b11000b0014a0197dfeamr17449396plr.142.1643101584150; Tue, 25
 Jan 2022 01:06:24 -0800 (PST)
MIME-Version: 1.0
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com> <20220124165547.74412-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20220124165547.74412-3-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 25 Jan 2022 10:06:13 +0100
Message-ID: <CAJ8uoz1a-71CBCYTd5-F1zsueMq+eu9LUqUsPgQH_SawdO6GEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/8] ice: xsk: force rings to be sized to
 power of 2
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 8:38 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> With the upcoming introduction of batching to XSK data path,
> performance wise it will be the best to have the ring descriptor count
> to be aligned to power of 2.
>
> Check if rings sizes that user is going to attach the XSK socket fulfill

nit: rings -> ring if you are making a v5 for some other reason.

> the condition above. For Tx side, although check is being done against
> the Tx queue and in the end the socket will be attached to the XDP
> queue, it is fine since XDP queues get the ring->count setting from Tx
> queues.

For me, this is fine as it makes the driver simpler and faster. But if
anyone out there is using a non power-of-2 ring size together with the
ice zero-copy driver and wants to keep it that way, now would be a
good time to protest.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 2388837d6d6c..0350f9c22c62 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -327,6 +327,14 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
>         bool if_running, pool_present = !!pool;
>         int ret = 0, pool_failure = 0;
>
> +       if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
> +           !is_power_of_2(vsi->tx_rings[qid]->count)) {
> +               netdev_err(vsi->netdev,
> +                          "Please align ring sizes at idx %d to power of 2\n", qid);
> +               pool_failure = -EINVAL;
> +               goto failure;
> +       }
> +
>         if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
>
>         if (if_running) {
> @@ -349,6 +357,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
>                         netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
>         }
>
> +failure:
>         if (pool_failure) {
>                 netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
>                            pool_present ? "en" : "dis", pool_failure);
> --
> 2.33.1
>
