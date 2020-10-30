Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A51A2A0ABD
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgJ3QJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3QJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:09:48 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51F2C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:09:48 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id x26so1881612uau.0
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lgH2HVgV31P4DjI/tPjJyBLSMiXfmIXY4gCXmNECm8g=;
        b=S3LvPdaEXV8lvJr2SqoMGEjeEroT0Mv1NiU5Bz2u2bvxDJ3HlBz2lw54KINtH4dWRL
         Q/QwhrLdsTfx4oxl3CfMbiC3mLv8GJmYhm/QadtnsQP59Vtz3koij8gMUVkg/24xXtIo
         sDxwbWWKzmKqhZyMZIkmLTIojbyZfheLmqP9oTiBmfDuEgiN33JlqdOV+NTh3ZNmUISu
         JXhLUoROLjOPUa0tv/X0DAr6gD2rCwZdxC1mW4MLFUIiwXKmXXcp+Gs5AKAev15FCRSV
         ufR+MLtbnNUA9jTThbZMVTTw2PeIGCrOFQLqLKY/2uTMqjH/S4UaJv11itQ5gTvdJTjQ
         816A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lgH2HVgV31P4DjI/tPjJyBLSMiXfmIXY4gCXmNECm8g=;
        b=S6df6k0MJSv7VJmyUXuYIo3j7nwPL91lvWpQBBhl0sVb1JBHd+equ0eoCemuPp1zAz
         vK+97FSQ22/CtdyXMGT9XtaeVwNs3pu7CdzBa3Db4+dzbx1bLlkKtdzi1/UZzat1Jsrp
         NIudTtUI350FRSMySnLa8hMH7I98RJfnyhUER7jctHGgpuGNf1ic8X6m3O5+Pl9ujwLq
         342A2hvLtjS7r3FAq+Ax0PWrUbl/+eQSBVLaSJejnxkH/9At0XHLl+dQm7q/8Nzp1PFe
         sDRZnC22P+PRf0P5Lk8O4cqpoXQa8RCN7BBnfTWOJqgIgx9eThPGys/YilTd9A2oViP1
         9VBA==
X-Gm-Message-State: AOAM5309BUOzIiOr1N20oMQ+z09LzoMbgFidA3pDhg2IohR90I+Xyad5
        JPlSsUCm1FQWMJEm61FgAKGzjPgKfik=
X-Google-Smtp-Source: ABdhPJyqtIeCg5ajqiGTFJpgoQQyNlghcEA4Qyr6LtIXZeCNO0Cx8XGt7s3PlEtZN4cxP4zQFv/IlA==
X-Received: by 2002:a9f:264a:: with SMTP id 68mr2071406uag.0.1604074187359;
        Fri, 30 Oct 2020 09:09:47 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id d12sm773455vkf.10.2020.10.30.09.09.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 09:09:43 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id b4so3693662vsd.4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:09:41 -0700 (PDT)
X-Received: by 2002:a05:6102:2f8:: with SMTP id j24mr7913538vsj.13.1604074180719;
 Fri, 30 Oct 2020 09:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20201028145015.19212-1-schalla@marvell.com> <20201028145015.19212-4-schalla@marvell.com>
In-Reply-To: <20201028145015.19212-4-schalla@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 12:09:04 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd+uKF6yWOJb6bSjNt7NY7PFwZBeZUL0UzTR171=HNuZQ@mail.gmail.com>
Message-ID: <CA+FuTSd+uKF6yWOJb6bSjNt7NY7PFwZBeZUL0UzTR171=HNuZQ@mail.gmail.com>
Subject: Re: [PATCH v8,net-next,03/12] octeontx2-af: add debugfs entries for
 CPT block
To:     Srujana Challa <schalla@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 10:22 PM Srujana Challa <schalla@marvell.com> wrote:
>
> Add entries to debugfs at /sys/kernel/debug/octeontx2/cpt.
>
> cpt_pc: dump cpt performance HW registers.
> Usage:
> cat /sys/kernel/debug/octeontx2/cpt/cpt_pc
>
> cpt_ae_sts: show cpt asymmetric engines current state
> Usage:
> cat /sys/kernel/debug/octeontx2/cpt/cpt_ae_sts
>
> cpt_se_sts: show cpt symmetric engines current state
> Usage:
> cat /sys/kernel/debug/octeontx2/cpt/cpt_se_sts
>
> cpt_engines_info: dump cpt engine control registers.
> Usage:
> cat /sys/kernel/debug/octeontx2/cpt/cpt_engines_info
>
> cpt_lfs_info: dump cpt lfs control registers.
> Usage:
> cat /sys/kernel/debug/octeontx2/cpt/cpt_lfs_info
>
> cpt_err_info: dump cpt error registers.
> Usage:
> cat /sys/kernel/debug/octeontx2/cpt/cpt_err_info
>
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
>  .../marvell/octeontx2/af/rvu_debugfs.c        | 304 ++++++++++++++++++
>  2 files changed, 305 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> index c37e106d7006..ba18171c87d6 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -50,6 +50,7 @@ struct rvu_debugfs {
>         struct dentry *npa;
>         struct dentry *nix;
>         struct dentry *npc;
> +       struct dentry *cpt;
>         struct dump_ctx npa_aura_ctx;
>         struct dump_ctx npa_pool_ctx;
>         struct dump_ctx nix_cq_ctx;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> index 77adad4adb1b..24354bfb4e94 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> @@ -1676,6 +1676,309 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
>         debugfs_remove_recursive(rvu->rvu_dbg.npc);
>  }
>
> +/* CPT debugfs APIs */
> +static int rvu_dbg_cpt_ae_sts_display(struct seq_file *filp, void *unused)
> +{
> +       struct rvu *rvu = filp->private;
> +       u64 busy_sts = 0, free_sts = 0;
> +       u32 e_min = 0, e_max = 0, e, i;
> +       u16 max_ses, max_ies, max_aes;
> +       int blkaddr;
> +       u64 reg;
> +
> +       blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
> +       if (blkaddr < 0)
> +               return -ENODEV;
> +
> +       reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
> +       max_ses = reg & 0xffff;
> +       max_ies = (reg >> 16) & 0xffff;
> +       max_aes = (reg >> 32) & 0xffff;
> +
> +       e_min = max_ses + max_ies;
> +       e_max = max_ses + max_ies + max_aes;
> +
> +       for (e = e_min, i = 0; e < e_max; e++, i++) {
> +               reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
> +               if (reg & 0x1)
> +                       busy_sts |= 1ULL << i;
> +
> +               if (reg & 0x2)
> +                       free_sts |= 1ULL << i;
> +       }
> +       seq_printf(filp, "FREE STS : 0x%016llx\n", free_sts);
> +       seq_printf(filp, "BUSY STS : 0x%016llx\n", busy_sts);
> +
> +       return 0;
> +}
> +
> +RVU_DEBUG_SEQ_FOPS(cpt_ae_sts, cpt_ae_sts_display, NULL);
> +
> +static int rvu_dbg_cpt_se_sts_display(struct seq_file *filp, void *unused)
> +{
> +       struct rvu *rvu = filp->private;
> +       u64 busy_sts = 0, free_sts = 0;
> +       u32 e_min = 0, e_max = 0, e;
> +       u16 max_ses;
> +       int blkaddr;
> +       u64 reg;
> +
> +       blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
> +       if (blkaddr < 0)
> +               return -ENODEV;
> +
> +       reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
> +       max_ses = reg & 0xffff;
> +
> +       e_min = 0;
> +       e_max = max_ses;
> +
> +       for (e = e_min; e < e_max; e++) {
> +               reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
> +               if (reg & 0x1)
> +                       busy_sts |= 1ULL << e;
> +
> +               if (reg & 0x2)
> +                       free_sts |= 1ULL << e;
> +       }
> +       seq_printf(filp, "FREE STS : 0x%016llx\n", free_sts);
> +       seq_printf(filp, "BUSY STS : 0x%016llx\n", busy_sts);
> +
> +       return 0;
> +}
> +
> +RVU_DEBUG_SEQ_FOPS(cpt_se_sts, cpt_se_sts_display, NULL);
> +
> +static int rvu_dbg_cpt_ie_sts_display(struct seq_file *filp, void *unused)
> +{
> +       struct rvu *rvu = filp->private;
> +       u64 busy_sts = 0, free_sts = 0;
> +       u32 e_min = 0, e_max = 0, e, i;
> +       u16 max_ses, max_ies;
> +       int blkaddr;
> +       u64 reg;
> +
> +       blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
> +       if (blkaddr < 0)
> +               return -ENODEV;
> +
> +       reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
> +       max_ses = reg & 0xffff;
> +       max_ies = (reg >> 16) & 0xffff;
> +
> +       e_min = max_ses;
> +       e_max = max_ses + max_ies;
> +
> +       for (e = e_min, i = 0; e < e_max; e++, i++) {
> +               reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
> +               if (reg & 0x1)
> +                       busy_sts |= 1ULL << i;
> +
> +               if (reg & 0x2)
> +                       free_sts |= 1ULL << i;
> +       }
> +       seq_printf(filp, "FREE STS : 0x%016llx\n", free_sts);
> +       seq_printf(filp, "BUSY STS : 0x%016llx\n", busy_sts);
> +
> +       return 0;
> +}

The above three are very similar. Could they use a single helper?
