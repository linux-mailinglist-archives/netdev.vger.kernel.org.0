Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4612B0EB5
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgKLUCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgKLUCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 15:02:13 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45837C0613D1;
        Thu, 12 Nov 2020 12:02:13 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id o11so7338521ioo.11;
        Thu, 12 Nov 2020 12:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AF4OkJVFDnImMNJP1h9DKgAEggI96n+VpJtZTsS6eSo=;
        b=IW/asP/lBn4FK8Sy11uUcIEtwsoqiHCCaGvjP5Erz54fDHscKlwvtbPiMtMUT4UyCH
         ekIQ7KQv9uphLHAyVgOI/xDQtBPRDMLFn3Jg8xqWYmXpQRBCK2jN4QM0hbzCqT5S5Jmj
         aA+NlpbGIrkNPIqBTfjd2bLtfuwq1Qzs9In3u4fiHf4xl5FNY/JTzxqV7+EINcwBx7qb
         vmQ9vDVQv7EVPe2vaXA+t08XySe3Zbkw15KnYvvciyAtAbhXJt9dNLfokbf4r7Ehrz+C
         s7rQMylghl1ISbYgSOmSfzH45OjlpujEF00nme8fcMce6dMRNgCOhv2rjaRhhlc1iC+a
         MM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AF4OkJVFDnImMNJP1h9DKgAEggI96n+VpJtZTsS6eSo=;
        b=PxzUrPrD+TvKL+bIm2d293KWDyHl4iNNufcCf/LhoNQS5l7DStjdgF0QHBach0yMey
         fszShXDGO/p2gWMvSXYMGj6Q0yBtSzZF/vrYpOuG+62XC4UGF8aXt0fqmoREJo3QVLUe
         5jGwOtXuSsbaTeVd1apniMNu0cuKqQZv9f/lm7uI3pzfW3TERCd08CM04suJiSWcjFKI
         z7aPBA8I8VKugcJNJJ6HP8MUGK6xvqIA0eM2oFXkeEaIFx/W9xO5KZqVjIMoKbJrhoeY
         y3+hXpfRIgv8Z6IkkCvtv2WGnQo77D85ozWyuJ6tX8E0Mf6q/WdvPXfdQjJyBrh4nsxV
         k5bw==
X-Gm-Message-State: AOAM531SHuhd0heoMIbHwA9262nX2OLAwkd5B0dcqDVsILkxBACnvIrN
        C8ozx9j7v1C9p7yfbWI3/Tbnb1ASmjfgAqKJRwEsnXpM8a0=
X-Google-Smtp-Source: ABdhPJzSSXzEmfYl5c97AWJT79TMT2VPnKUz6aDwmB0Na6Ahrsl+GgC+/dhv72csarVoyt1nJzbbOsWpFUmQfmrl9Rk=
X-Received: by 2002:a6b:780b:: with SMTP id j11mr624752iom.5.1605211332457;
 Thu, 12 Nov 2020 12:02:12 -0800 (PST)
MIME-Version: 1.0
References: <20201111071404.29620-1-naveenm@marvell.com> <20201111071404.29620-2-naveenm@marvell.com>
In-Reply-To: <20201111071404.29620-2-naveenm@marvell.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Nov 2020 12:02:01 -0800
Message-ID: <CAKgT0Ud5L60j90pCikPNLBn51o5PJ3XQOsbVcOffWwmeF2-njw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 01/13] octeontx2-af: Modify default KEX
 profile to extract TX packet fields
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, saeed@kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, hkelam@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 11:22 PM Naveen Mamindlapalli
<naveenm@marvell.com> wrote:
>
> From: Stanislaw Kardach <skardach@marvell.com>
>
> The current default Key Extraction(KEX) profile can only use RX
> packet fields while generating the MCAM search key. The profile
> can't be used for matching TX packet fields. This patch modifies
> the default KEX profile to add support for extracting TX packet
> fields into MCAM search key. Enabled Tx KPU packet parsing by
> configuring TX PKIND in tx_parse_cfg.
>
> Also modified the default KEX profile to extract VLAN TCI from
> the LB_PTR and exact byte offset of VLAN header. The NPC KPU
> parser was modified to point LB_PTR to the starting byte offset
> of VLAN header which points to the tpid field.
>
> Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

A bit more documentation would be useful. However other than that the
code itself appears to make sense.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
>  .../ethernet/marvell/octeontx2/af/npc_profile.h    | 71 ++++++++++++++++++++--
>  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  6 ++
>  2 files changed, 72 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
> index 199448610e3e..c5b13385c81d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
> @@ -13386,8 +13386,8 @@ static struct npc_mcam_kex npc_mkex_default = {
>         .kpu_version = NPC_KPU_PROFILE_VER,
>         .keyx_cfg = {
>                 /* nibble: LA..LE (ltype only) + Channel */
> -               [NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x49247,
> -               [NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | ((1ULL << 19) - 1),
> +               [NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x249207,
> +               [NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x249200,
>         },
>         .intf_lid_lt_ld = {
>         /* Default RX MCAM KEX profile */
//
Any sort of explanation for what some of these magic numbers means
might be useful. I'm left wondering if the lower 32b is a bitfield or
a fixed value. I am guessing bit field based on the fact that it was
originally being set using ((1ULL << X) - 1) however if there were
macros defined for each bit explaining what each bit was that would be
useful.

> @@ -13405,12 +13405,14 @@ static struct npc_mcam_kex npc_mkex_default = {
>                         /* Layer B: Single VLAN (CTAG) */
>                         /* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
>                         [NPC_LT_LB_CTAG] = {
> -                               KEX_LD_CFG(0x03, 0x0, 0x1, 0x0, 0x4),
> +                               KEX_LD_CFG(0x03, 0x2, 0x1, 0x0, 0x4),
>                         },

Similarly here some explanation for KEX_LD_CFG would be useful. From
what I can tell it seems like this may be some sort of fix as you are
adjusting the "hdr_ofs" field from 0 to 2.

>                         /* Layer B: Stacked VLAN (STAG|QinQ) */
>                         [NPC_LT_LB_STAG_QINQ] = {
> -                               /* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
> -                               KEX_LD_CFG(0x03, 0x4, 0x1, 0x0, 0x4),
> +                               /* Outer VLAN: 2 bytes, KW0[63:48] */
> +                               KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
> +                               /* Ethertype: 2 bytes, KW0[47:32] */
> +                               KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x4),

Just to confirm, are you matching up the outer VLAN with the inner
Ethertype here? It seems like an odd combination. I assume you need
the inner ethertype in order to identify the L3 traffic?

>                         },
>                         [NPC_LT_LB_FDSA] = {
>                                 /* SWITCH PORT: 1 byte, KW0[63:48] */
> @@ -13450,6 +13452,65 @@ static struct npc_mcam_kex npc_mkex_default = {
>                         },
>                 },
>         },
> +
> +       /* Default TX MCAM KEX profile */
> +       [NIX_INTF_TX] = {
> +               [NPC_LID_LA] = {
> +                       /* Layer A: Ethernet: */
> +                       [NPC_LT_LA_IH_NIX_ETHER] = {
> +                               /* PF_FUNC: 2B , KW0 [47:32] */
> +                               KEX_LD_CFG(0x01, 0x0, 0x1, 0x0, 0x4),

I'm assuming you have an 8B internal header that is being parsed? A
comment explaining that this is parsing a preamble that is at the
start of things might be useful.

> +                               /* DMAC: 6 bytes, KW1[63:16] */
> +                               KEX_LD_CFG(0x05, 0x8, 0x1, 0x0, 0xa),
> +                       },
> +               },
> +               [NPC_LID_LB] = {
> +                       /* Layer B: Single VLAN (CTAG) */
> +                       [NPC_LT_LB_CTAG] = {
> +                               /* CTAG VLAN[2..3] KW0[63:48] */
> +                               KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
> +                               /* CTAG VLAN[2..3] KW1[15:0] */
> +                               KEX_LD_CFG(0x01, 0x4, 0x1, 0x0, 0x8),
> +                       },
> +                       /* Layer B: Stacked VLAN (STAG|QinQ) */
> +                       [NPC_LT_LB_STAG_QINQ] = {
> +                               /* Outer VLAN: 2 bytes, KW0[63:48] */
> +                               KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
> +                               /* Outer VLAN: 2 Bytes, KW1[15:0] */
> +                               KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x8),
> +                       },
> +               },
> +               [NPC_LID_LC] = {
> +                       /* Layer C: IPv4 */
> +                       [NPC_LT_LC_IP] = {
> +                               /* SIP+DIP: 8 bytes, KW2[63:0] */
> +                               KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10),
> +                               /* TOS: 1 byte, KW1[63:56] */
> +                               KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf),
> +                       },
> +                       /* Layer C: IPv6 */
> +                       [NPC_LT_LC_IP6] = {
> +                               /* Everything up to SADDR: 8 bytes, KW2[63:0] */
> +                               KEX_LD_CFG(0x07, 0x0, 0x1, 0x0, 0x10),
> +                       },
> +               },
> +               [NPC_LID_LD] = {
> +                       /* Layer D:UDP */
> +                       [NPC_LT_LD_UDP] = {
> +                               /* SPORT: 2 bytes, KW3[15:0] */
> +                               KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
> +                               /* DPORT: 2 bytes, KW3[31:16] */
> +                               KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),

I am curious why this is being done as two pieces instead of just one.
From what I can tell you could just have a single rule that copies the
4 bytes for both ports in one shot and they would end up in the same
place wouldn't they?

> +                       },
> +                       /* Layer D:TCP */
> +                       [NPC_LT_LD_TCP] = {
> +                               /* SPORT: 2 bytes, KW3[15:0] */
> +                               KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
> +                               /* DPORT: 2 bytes, KW3[31:16] */
> +                               KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
> +                       },
> +               },
> +       },
>         },
>  };
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index 8bac1dd3a1c2..8c11abdbd9d1 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -57,6 +57,8 @@ enum nix_makr_fmt_indexes {
>         NIX_MARK_CFG_MAX,
>  };
>
> +#define NIX_TX_PKIND   63ULL
> +

A comment explaining the magic number would be useful. From what I can
tell this looks like a "just turn everything on" sort of config where
you are enabling bit flags 0 - 5.


>  /* For now considering MC resources needed for broadcast
>   * pkt replication only. i.e 256 HWVFs + 12 PFs.
>   */
> @@ -1182,6 +1184,10 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
>         /* Config Rx pkt length, csum checks and apad  enable / disable */
>         rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_CFG(nixlf), req->rx_cfg);
>
> +       /* Configure pkind for TX parse config, 63 from npc_profile */
> +       cfg = NIX_TX_PKIND;
> +       rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
> +
>         intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
>         err = nix_interface_init(rvu, pcifunc, intf, nixlf);
>         if (err)
> --
> 2.16.5
>
