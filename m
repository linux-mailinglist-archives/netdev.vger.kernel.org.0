Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB455524B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 19:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376847AbiFVRYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 13:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376815AbiFVRYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 13:24:40 -0400
Received: from mail-ua1-x964.google.com (mail-ua1-x964.google.com [IPv6:2607:f8b0:4864:20::964])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC70124962
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:24:39 -0700 (PDT)
Received: by mail-ua1-x964.google.com with SMTP id x24so3624900uaf.11
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:mime-version:references
         :in-reply-to:from:date:message-id:subject:to:cc;
        bh=Eg7pKoREa62TqDRaU+yo2zrV2x8I6979kwBHk4P4AYE=;
        b=uWqXmA+3SWzyGtNt8JeAAPkv8BhbdkET96rOzpziK2akKqf7L4QwhciozDo7V+WGan
         lAUZMruq1x8gJlFUY1fgFE6swRVhNlKqImQsfODwbW+/F9wGPIG2Xrp5DqD5ZLCFC1Id
         VXCqkrfCyn/Ku20gVH6SP+Ysr4qyAy2R9D1LdZUl31tL6aucVNwmd9UfaagYWmTi/EoL
         ujuotmWns665mXD8pcVApAgxbMFwCkeEtS8vBHs6IIJr1zs/kzCZmc0A5NIieFU4pBIb
         1IDF1t5BTOFCGufFSvMKxi2CSUQGeWytb40xnKfETA1nhE6yyqnjr0ro1PKhKG6eifHg
         ZDfw==
X-Gm-Message-State: AJIora/cLHCnItjDxhOts4TodP2Hafz5h94MQ3r6wx98CWga/Nd5VGZX
        I0WkU47pOJlEwgmGQM8Wc4JU1afQUjegtY1aod+7d9EpVbJ/fw==
X-Google-Smtp-Source: AGRyM1uY/nPkF/cTgCINdqf9wFR2D4bOjlCr5Ki7liDXiMGfFuF8z49GC3yt5o5HKoITskUvN0cbMG2iAgK+
X-Received: by 2002:ab0:482b:0:b0:37f:10e3:54e0 with SMTP id b40-20020ab0482b000000b0037f10e354e0mr2611662uad.2.1655918678844;
        Wed, 22 Jun 2022 10:24:38 -0700 (PDT)
Received: from riotgames.com ([163.116.128.209])
        by smtp-relay.gmail.com with ESMTPS id y12-20020ab05b8c000000b0036934fac38csm2112907uae.2.2022.06.22.10.24.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 10:24:38 -0700 (PDT)
X-Relaying-Domain: riotgames.com
Received: by mail-qv1-f72.google.com with SMTP id t5-20020a0cb385000000b0046e63b0cef8so17839103qve.23
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eg7pKoREa62TqDRaU+yo2zrV2x8I6979kwBHk4P4AYE=;
        b=U40zH1A0nsIU3C11b6t2RtEag/I6/6Q5eEbPZKTaTfpUbfOjaEWrGDc866SG/INK35
         1EFdMcPJZteT9+M4NW1Yms+k4RBYZvvsYuX9CEothlBXRGGl9bnK+Mbz3vvxLNbgsWTX
         FcfEwQev8Nj+DBdD55qFCN6OJutEpn/XZ/TS0=
X-Received: by 2002:a05:620a:4591:b0:6a7:5a82:3d2d with SMTP id bp17-20020a05620a459100b006a75a823d2dmr3163071qkb.694.1655918677016;
        Wed, 22 Jun 2022 10:24:37 -0700 (PDT)
X-Received: by 2002:a05:620a:4591:b0:6a7:5a82:3d2d with SMTP id
 bp17-20020a05620a459100b006a75a823d2dmr3163048qkb.694.1655918676729; Wed, 22
 Jun 2022 10:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220622091447.243101-1-ciara.loftus@intel.com>
In-Reply-To: <20220622091447.243101-1-ciara.loftus@intel.com>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Wed, 22 Jun 2022 12:24:25 -0500
Message-ID: <CAC1LvL2zjEF16_Gbwrxwke7wpeKxNKR=vd_E2N_CpDezeo4sbw@mail.gmail.com>
Subject: Re: [PATCH net-next] i40e: xsk: read the XDP program once per NAPI
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Content-Type: text/plain; charset="UTF-8"
x-netskope-inspected: true
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 4:15 AM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> Similar to how it's done in the ice driver since 'eb087cd82864 ("ice:
> propagate xdp_ring onto rx_ring")', read the XDP program once per NAPI
> instead of once per descriptor cleaned. I measured an improvement in
> throughput of 2% for the AF_XDP xdpsock l2fwd benchmark in busy polling
> mode on my platform.
>

Should the same improvement be made to i40e_run_xdp/i40e_clean_rx_irq for the
non-AF_XDP case?

> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index af3e7e6afc85..2f422c61ac11 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -146,17 +146,13 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
>   *
>   * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR}
>   **/
> -static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
> +static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp,
> +                          struct bpf_prog *xdp_prog)
>  {
>         int err, result = I40E_XDP_PASS;
>         struct i40e_ring *xdp_ring;
> -       struct bpf_prog *xdp_prog;
>         u32 act;
>
> -       /* NB! xdp_prog will always be !NULL, due to the fact that
> -        * this path is enabled by setting an XDP program.
> -        */
> -       xdp_prog = READ_ONCE(rx_ring->xdp_prog);
>         act = bpf_prog_run_xdp(xdp_prog, xdp);
>
>         if (likely(act == XDP_REDIRECT)) {
> @@ -339,9 +335,15 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
>         u16 next_to_clean = rx_ring->next_to_clean;
>         u16 count_mask = rx_ring->count - 1;
>         unsigned int xdp_res, xdp_xmit = 0;
> +       struct bpf_prog *xdp_prog;
>         bool failure = false;
>         u16 cleaned_count;
>
> +       /* NB! xdp_prog will always be !NULL, due to the fact that
> +        * this path is enabled by setting an XDP program.
> +        */
> +       xdp_prog = READ_ONCE(rx_ring->xdp_prog);
> +
>         while (likely(total_rx_packets < (unsigned int)budget)) {
>                 union i40e_rx_desc *rx_desc;
>                 unsigned int rx_packets;
> @@ -378,7 +380,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
>                 xsk_buff_set_size(bi, size);
>                 xsk_buff_dma_sync_for_cpu(bi, rx_ring->xsk_pool);
>
> -               xdp_res = i40e_run_xdp_zc(rx_ring, bi);
> +               xdp_res = i40e_run_xdp_zc(rx_ring, bi, xdp_prog);
>                 i40e_handle_xdp_result_zc(rx_ring, bi, rx_desc, &rx_packets,
>                                           &rx_bytes, size, xdp_res, &failure);
>                 if (failure)
> --
> 2.25.1
>
