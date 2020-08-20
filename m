Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E63C24BE73
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgHTN0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbgHTNZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:25:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853FBC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:25:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id z3so1613180ilh.3
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wPBhf+um4hFujs2wXTsrfA04pkfe3gednCPRBu86Qks=;
        b=JuMS27bMxEGxNR38HlZkCCviVt2sn9VP7b8swON+XUBYje8LPJ7CzsDbjb8Iypm9TT
         5Mxgz5bc+U2hAXFmvhyma3AKs1PifGYQoRKF1oBGcoIkAAiIwesHh34TLLuGDnf8lQa2
         EYpcV3NByHjJKlAojbhA2nn/hkSufhpouRmESnKmZTL2dFMYiAIwClfYk1I673bjxboU
         mUSNworCPsSVYc6ixFJzWimHlzVQExBPuhYzGRoSXJPr6PyS5qYAWqz225W31Vya+R1S
         PAFKEn+TmAfi1PTR0PCIqlO0NHziJzZsziji4S/rdbgqPLRCC6tMbsDLuv1vEiOzBL+s
         Bv2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wPBhf+um4hFujs2wXTsrfA04pkfe3gednCPRBu86Qks=;
        b=rk8BZvIQQ6QZriXqUyvgjswffZjL7HdWQcHjsnZHGXvMMDIx0pWL5BnbCJGT/SmDVk
         GXCFj5qOd2EJUoAiNpzTdS2TRCKcdj7VHX1tqNI2Ne/g/YzKYO9/IbovpR+B8wW59pEG
         xnpnc8qi3xCwA6hg1DfZs/OvUxrhkO00YJHTj3SqHCBKY/d7DMEhdlEOqpx7WjgbiSuo
         5ptgp2xkOn5fJltgECVipukzzL6dtUZhkBok0bmKW3PYK3xwgiv7MpeJhnYjqNDXs/xP
         EZEMTnJqrVfHGOHYnynuGw/2BnIwPp9KR0dMU9ksCn3RQsGNNX2BudnJ4iTWRzl+hR9l
         Y5mA==
X-Gm-Message-State: AOAM533lH/zBJX/J5NaeAeDF3IwQ9BUuXMxZRLjCxdXsJ2OEnd3FJZM4
        KqbQeW3yWOLNkOx0HO05UnVQxmiWqFM8N6M8DGg=
X-Google-Smtp-Source: ABdhPJzD33vbUfqH/4tJB2nD6bqJFoYCqbgDd6G12uIZaAEPaSNFXcOYENJtflXNBGZztMg3AmTfy8YUwLwkFqvk+38=
X-Received: by 2002:a92:ce07:: with SMTP id b7mr2639953ilo.270.1597929954531;
 Thu, 20 Aug 2020 06:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <1597770557-26617-1-git-send-email-sundeep.lkml@gmail.com>
 <1597770557-26617-2-git-send-email-sundeep.lkml@gmail.com> <20200819083817.00000a02@intel.com>
In-Reply-To: <20200819083817.00000a02@intel.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 20 Aug 2020 18:55:43 +0530
Message-ID: <CALHRZupUSrgV0wFAOCiT0KbQDJ-cTeu6NnbxOa8QWtuhZPBcXQ@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 1/3] octeontx2-af: Support to enable/disable
 HW timestamping
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Zyta Szpak <zyta@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 19, 2020 at 9:08 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> sundeep.lkml@gmail.com wrote:
>
> > From: Zyta Szpak <zyta@marvell.com>
> >
> > Four new mbox messages ids and handler are added in order to
> > enable or disable timestamping procedure on tx and rx side.
> > Additionally when PTP is enabled, the packet parser must skip
> > over 8 bytes and start analyzing packet data there. To make NPC
> > profiles work seemlesly PTR_ADVANCE of IKPU is set so that
> > parsing can be done as before when all data pointers
> > are shifted by 8 bytes automatically.
> >
> > Signed-off-by: Zyta Szpak <zyta@marvell.com>
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
>
> I know these patches are already acked by a couple of people in v4, but
> I have a few more minor concerns that I'd like you to consider listed
> below. Up to DaveM whether he wants to apply without the fixes I
> mention.
>
>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 29 ++++++++++++
> >  drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  4 ++
> >  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  4 ++
> >  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
> >  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 54 ++++++++++++++++++++++
> >  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 52 +++++++++++++++++++++
> >  .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 27 +++++++++++
> >  7 files changed, 171 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > index a4e65da..8f17e26 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> > @@ -468,6 +468,35 @@ static void cgx_lmac_pause_frm_config(struct cgx *cgx, int lmac_id, bool enable)
> >       }
> >  }
> >
>
> Generally what I'd like to see is that you have a comment here in
> kernel doc format, I suppose your driver probably doesn't have any of
> these, but it is particularly important to describe what each function
> is meant to do especially when it is a symbol callable from other
> files/modules. Something like:
>
> /**
>  * cgx_lmac_ptp_config - enable or disable timestamping
>  * @cgxd: driver context
>  * @lmac_id: ID used to get register offset
>  * @enable: true if timestamping should be enabled, false if not
>  *
>  * Here would be a multi-line description of what this function does
>  * and if it has a return value, what it's for.
>  */
>
I agree but we have lot of non static functions because of mbox handlers
and adding kernel doc for all those didn't look good. We try best to use
proper function names.

> > +void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
> > +{
> > +     struct cgx *cgx = cgxd;
> > +     u64 cfg;
> > +
> > +     if (!cgx)
> > +             return;
> > +
> <snip>
>
> > +int rvu_mbox_handler_nix_lf_ptp_tx_enable(struct rvu *rvu, struct msg_req *req,
> > +                                       struct msg_rsp *rsp)
> > +{
> > +     struct rvu_hwinfo *hw = rvu->hw;
> > +     u16 pcifunc = req->hdr.pcifunc;
> > +     struct rvu_block *block;
> > +     int blkaddr;
> > +     int nixlf;
> > +     u64 cfg;
> > +
> > +     blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
> > +     if (blkaddr < 0)
> > +             return NIX_AF_ERR_AF_LF_INVALID;
> > +
> > +     block = &hw->block[blkaddr];
> > +     nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
> > +     if (nixlf < 0)
> > +             return NIX_AF_ERR_AF_LF_INVALID;
> > +
> > +     cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf));
> > +     cfg |= BIT_ULL(32);
>
> I'm not super excited by the magic numbers here, without even a
> comment, you should make a define for bit 32, and not leave me guessing
> if this is the "enable" bit or is for something else.
>
Because of the huge number of registers and bit definitions we are
avoiding adding macros for simpler cases like the one above.

> > +     rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
> > +
> > +     return 0;
> > +}
> > +
> > +int rvu_mbox_handler_nix_lf_ptp_tx_disable(struct rvu *rvu, struct msg_req *req,
> > +                                        struct msg_rsp *rsp)
> > +{
> > +     struct rvu_hwinfo *hw = rvu->hw;
> > +     u16 pcifunc = req->hdr.pcifunc;
> > +     struct rvu_block *block;
> > +     int blkaddr;
> > +     int nixlf;
> > +     u64 cfg;
> > +
> > +     blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
> > +     if (blkaddr < 0)
> > +             return NIX_AF_ERR_AF_LF_INVALID;
> > +
> > +     block = &hw->block[blkaddr];
> > +     nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
> > +     if (nixlf < 0)
> > +             return NIX_AF_ERR_AF_LF_INVALID;
> > +
> > +     cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf));
> > +     cfg &= ~BIT_ULL(32);
> > +     rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
> > +
> > +     return 0;
> > +}
> > +
>
> Is this and the function above exactly the same 20+ lines of code
> with a one line difference? Before you passed an "enable" bool to
> another function, why the difference here?
>
Agreed. I will modify it.

> >  int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
> >                                       struct nix_lso_format_cfg *req,
> >                                       struct nix_lso_format_cfg_rsp *rsp)
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> > index 0a21408..8179bbe 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> > @@ -27,6 +27,7 @@
> >  #define NIXLF_PROMISC_ENTRY  2
> >
> >  #define NPC_PARSE_RESULT_DMAC_OFFSET 8
> > +#define NPC_HW_TSTAMP_OFFSET         8
> >
> >  static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
> >                                     int blkaddr, u16 pcifunc);
> > @@ -61,6 +62,32 @@ int rvu_npc_get_pkind(struct rvu *rvu, u16 pf)
> >       return -1;
> >  }
> >
> > +int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool en)
> > +{
> > +     int pkind, blkaddr;
> > +     u64 val;
> > +
> > +     pkind = rvu_npc_get_pkind(rvu, pf);
> > +     if (pkind < 0) {
> > +             dev_err(rvu->dev, "%s: pkind not mapped\n", __func__);
> > +             return -EINVAL;
> > +     }
> > +
> > +     blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, pcifunc);
> > +     if (blkaddr < 0) {
> > +             dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
> > +             return -EINVAL;
> > +     }
> > +     val = rvu_read64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind));
> > +     val &= ~0xff00000ULL; /* Zero ptr advance field */
>
> Please don't use trailing comments *ever* in a code section, the only
> place it is marginally ok, is in structure definitions.
>
Okay will fix it.
> Also, What's up with the magic number? At least you had a comment.
>
>
Sure will fix it.

Thanks,
Sundeep
