Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91E22B0EBA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgKLUDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgKLUDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 15:03:22 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1A8C0613D1;
        Thu, 12 Nov 2020 12:03:22 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id z2so6393893ilh.11;
        Thu, 12 Nov 2020 12:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CvRBkFjB61TpD/PrK8UELlhzlQvkJ9wAUe4KMJS37gk=;
        b=Q2Au6/xPP0zfMtDQmC3BqKiFnjKM+g65v8J+ae/MVGPCXYjHrV3UIHuyB1Tqllj0hR
         DyiT1yR8UtJOxPqbgCnn2YNwwWERzHeTlMOHm4Mt9e276ghKpLX4GsPduam0aFuTe1CN
         W0dNrdw9Nxw0KOqO26idzVcjJEBbjAa/CEnjV1LFwra70s/BTyhiZGUf7EyNT8CO4y9L
         HVFsQHeJye+T0jneNfuTKPbWG2CgTb3WR3JIfkFns9F+9M5eadLpvqQPSKNZ5xLKd5tf
         2LxRtoo/l7RwWgpeeje9ZqPiM+GgWa8CXCTCwl6wzwk7hbtSUf/8tBp49P8mDkMe4PBp
         ukQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CvRBkFjB61TpD/PrK8UELlhzlQvkJ9wAUe4KMJS37gk=;
        b=Z5WQZEH5C2g6luMUsd65RsGi+HtbmGqAydK5p9D0HpUPLtHT5Ml4XZSDF0vJZBAupb
         AflC/u8uhtLSASb103cbxAG9dyb8hyGWdQaX34s2pibhYTIKASS/m5iZm5LMgUhjtwB/
         CVfsilHSoGr85kp8TKFtm3e6YEa/0FoRRQJciG3SPd8P35TfISYHwDWvmuxKNCb6oo2Y
         yBJ2rnkYx5uJWY7I243ZUN9bUEoxJDFsKX1euC5OTDBjSEB21f8Fie4g3NYQVq8cwDIz
         emrzFci29Df4GDutysmWIzQc89P91JdolSocVVnOCThjmIU1gc4DuLFB1URvxKy7YVIg
         oJgQ==
X-Gm-Message-State: AOAM532MijD2MNC+iNQOkm8nFzF3TMtHC7RoIuhh5sVQuiIg1eSNAzYW
        kEIsRHdB8HE7SX6kZI9wix78CsvQ7UKGIzbj/8A+XzOgnYM=
X-Google-Smtp-Source: ABdhPJzS5cJZ5mfArNRSyRNUhX8FeZEzQ2fENrlxGk6oSmsVsuLbT//IXK/VD0DBJzXjblVlDdYGQUolwLqP5TiIdWg=
X-Received: by 2002:a92:ca86:: with SMTP id t6mr945597ilo.95.1605211401813;
 Thu, 12 Nov 2020 12:03:21 -0800 (PST)
MIME-Version: 1.0
References: <20201111071404.29620-1-naveenm@marvell.com> <20201111071404.29620-3-naveenm@marvell.com>
In-Reply-To: <20201111071404.29620-3-naveenm@marvell.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Nov 2020 12:03:10 -0800
Message-ID: <CAKgT0UdAQvcAtzorSEkqKvd4kgS625hwKG=X9JB57Z48Vh=RDg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 02/13] octeontx2-af: Verify MCAM entry channel
 and PF_FUNC
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

On Tue, Nov 10, 2020 at 11:18 PM Naveen Mamindlapalli
<naveenm@marvell.com> wrote:
>
> From: Subbaraya Sundeep <sbhatta@marvell.com>
>
> This patch adds support to verify the channel number sent by
> mailbox requester before writing MCAM entry for Ingress packets.
> Similarly for Egress packets, verifying the PF_FUNC sent by the
> mailbox user.
>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

One minor nit below. Otherwise looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  4 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  2 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 78 ++++++++++++++++++++++
>  3 files changed, 82 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> index a28a518c0eae..e8b5aaf73201 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> @@ -2642,7 +2642,7 @@ static void rvu_enable_afvf_intr(struct rvu *rvu)
>
>  #define PCI_DEVID_OCTEONTX2_LBK 0xA061
>
> -static int lbk_get_num_chans(void)
> +int rvu_get_num_lbk_chans(void)
>  {
>         struct pci_dev *pdev;
>         void __iomem *base;
> @@ -2677,7 +2677,7 @@ static int rvu_enable_sriov(struct rvu *rvu)
>                 return 0;
>         }
>
> -       chans = lbk_get_num_chans();
> +       chans = rvu_get_num_lbk_chans();
>         if (chans < 0)
>                 return chans;
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> index 5ac9bb12415f..1724dbd18847 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -445,6 +445,7 @@ int rvu_get_lf(struct rvu *rvu, struct rvu_block *block, u16 pcifunc, u16 slot);
>  int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf);
>  int rvu_get_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc);
>  int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero);
> +int rvu_get_num_lbk_chans(void);
>
>  /* RVU HW reg validation */
>  enum regmap_block {
> @@ -535,6 +536,7 @@ bool is_npc_intf_tx(u8 intf);
>  bool is_npc_intf_rx(u8 intf);
>  bool is_npc_interface_valid(struct rvu *rvu, u8 intf);
>  int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena);
> +int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel);
>
>  #ifdef CONFIG_DEBUG_FS
>  void rvu_dbg_init(struct rvu *rvu);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> index 989533a3d2ce..3666159bb6b6 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> @@ -28,6 +28,8 @@
>
>  #define NPC_PARSE_RESULT_DMAC_OFFSET   8
>  #define NPC_HW_TSTAMP_OFFSET           8
> +#define NPC_KEX_CHAN_MASK              0xFFFULL
> +#define NPC_KEX_PF_FUNC_MASK           0xFFFFULL
>
>  static const char def_pfl_name[] = "default";
>
> @@ -63,6 +65,54 @@ int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena)
>         return 0;
>  }
>
> +static int npc_mcam_verify_pf_func(struct rvu *rvu,
> +                                  struct mcam_entry *entry_data, u8 intf,
> +                                  u16 pcifunc)
> +{
> +       u16 pf_func, pf_func_mask;
> +
> +       if (is_npc_intf_rx(intf))
> +               return 0;
> +
> +       pf_func_mask = (entry_data->kw_mask[0] >> 32) &
> +               NPC_KEX_PF_FUNC_MASK;
> +       pf_func = (entry_data->kw[0] >> 32) & NPC_KEX_PF_FUNC_MASK;
> +
> +       pf_func = be16_to_cpu((__force __be16)pf_func);
> +       if (pf_func_mask != NPC_KEX_PF_FUNC_MASK ||
> +           ((pf_func & ~RVU_PFVF_FUNC_MASK) !=
> +            (pcifunc & ~RVU_PFVF_FUNC_MASK)))
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> +int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel)
> +{
> +       int pf = rvu_get_pf(pcifunc);
> +       u8 cgx_id, lmac_id;
> +       int base = 0, end;
> +
> +       if (is_npc_intf_tx(intf))
> +               return 0;
> +
> +       if (is_afvf(pcifunc)) {
> +               end = rvu_get_num_lbk_chans();
> +               if (end < 0)
> +                       return -EINVAL;
> +       } else {
> +               rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
> +               base = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0x0);
> +               /* CGX mapped functions has maximum of 16 channels */
> +               end = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0xF);
> +       }
> +
> +       if (channel < base || channel > end)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
>  void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf)
>  {
>         int blkaddr;
> @@ -1935,6 +1985,7 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
>         struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
>         struct npc_mcam *mcam = &rvu->hw->mcam;
>         u16 pcifunc = req->hdr.pcifunc;
> +       u16 channel, chan_mask;
>         int blkaddr, rc;
>         u8 nix_intf;
>
> @@ -1942,6 +1993,10 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
>         if (blkaddr < 0)
>                 return NPC_MCAM_INVALID_REQ;
>
> +       chan_mask = req->entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
> +       channel = req->entry_data.kw[0] & NPC_KEX_CHAN_MASK;
> +       channel &= chan_mask;
> +
>         mutex_lock(&mcam->lock);
>         rc = npc_mcam_verify_entry(mcam, pcifunc, req->entry);
>         if (rc)
> @@ -1963,6 +2018,17 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
>         else
>                 nix_intf = pfvf->nix_rx_intf;
>
> +       if (npc_mcam_verify_channel(rvu, pcifunc, req->intf, channel)) {
> +               rc = NPC_MCAM_INVALID_REQ;
> +               goto exit;
> +       }
> +
> +       if (npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf,
> +                                   pcifunc)) {
> +               rc = NPC_MCAM_INVALID_REQ;
> +               goto exit;
> +       }
> +
>         npc_config_mcam_entry(rvu, mcam, blkaddr, req->entry, nix_intf,
>                               &req->entry_data, req->enable_entry);
>
> @@ -2299,6 +2365,7 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
>         struct npc_mcam *mcam = &rvu->hw->mcam;
>         u16 entry = NPC_MCAM_ENTRY_INVALID;
>         u16 cntr = NPC_MCAM_ENTRY_INVALID;
> +       u16 channel, chan_mask;
>         int blkaddr, rc;
>         u8 nix_intf;
>
> @@ -2309,6 +2376,17 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
>         if (!is_npc_interface_valid(rvu, req->intf))
>                 return NPC_MCAM_INVALID_REQ;
>
> +       chan_mask = req->entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
> +       channel = req->entry_data.kw[0] & NPC_KEX_CHAN_MASK;
> +       channel &= chan_mask;
> +
> +       if (npc_mcam_verify_channel(rvu, req->hdr.pcifunc, req->intf, channel))
> +               return NPC_MCAM_INVALID_REQ;
> +

Why not just move the code for pulling the channel into the
npc_mcam_verify_channel function like you did with the pf_func? Then
you can avoid declaring variables here that won't be used anywhere
else in the function.


> +       if (npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf,
> +                                   req->hdr.pcifunc))
> +               return NPC_MCAM_INVALID_REQ;
> +
>         /* Try to allocate a MCAM entry */
>         entry_req.hdr.pcifunc = req->hdr.pcifunc;
>         entry_req.contig = true;
> --
> 2.16.5
>
