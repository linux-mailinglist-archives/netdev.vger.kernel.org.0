Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6E1416735
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 23:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243293AbhIWVNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 17:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243247AbhIWVNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 17:13:49 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA1DC061757
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 14:12:17 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y16so1208872ybm.3
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 14:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4I0eibrZ4QXFLaZnyg/T68NEGU52nG0wW6n1XbQIjQ=;
        b=dG37ybSuZM/2PWO2WUAlCFTgei4CWvCR+/3V/ba5AqbouIgMtK6R/N88t2fL6e8ES2
         HXlfmDfLIxlNVt61DT2aeO3iHi1ERInV9PLlsO/SPeZ8qseDFM20DxIJnOXzZymLl5ma
         Sf4KMe1TIhD6jwCpVfOKcATIO++tuc9tkqgIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4I0eibrZ4QXFLaZnyg/T68NEGU52nG0wW6n1XbQIjQ=;
        b=a8ozUXWL+7gK/QH0gBny0LjDm5Fx/afoLUBizC7aExldW+xnj+cjFqZ5QY6n3JuydM
         LwQMpInF/UKdlF6LN0a9D7nf+Jmeeir7rU8tpvYX9IF/spUagihbw5yzBV+TbnLTYEE2
         O63VBffSpQDHhU+fjjxxouMNt2iIEg9D/wFkq3PzOH4298q9HxpbD+u3PHEaJ/42DTM8
         gMBiWYdVfBChRk/bftES/jMzYrnj/BC8hnqyEZj7Twc4COFljgDdt05fmXAF0oOVpaVp
         JRn5fmZGBOe2lm5o9qRdWcBfI6qsk/Yp6Mydk4zuuBYwHSn9r0J+hITIt5buooHxuYwd
         3KQw==
X-Gm-Message-State: AOAM530az/I7XNrFxu57hICHFMCZjNL5Ox8UGFKT9Wb6U+McErAZ27zH
        xel3PnBUDxRLEj4NypnlUkJPgY58N0SJ+dD/H1p+ww==
X-Google-Smtp-Source: ABdhPJzPbZJuTOrMwImBU82x1iGNKaxl7ZrrpRIXcHLQEZ89VXGY0DTN1rpeXB3OFka4syEsC81GUEXozb35nSZ2MSQ=
X-Received: by 2002:a25:748c:: with SMTP id p134mr7788992ybc.361.1632431536689;
 Thu, 23 Sep 2021 14:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632420430.git.leonro@nvidia.com> <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
In-Reply-To: <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Thu, 23 Sep 2021 14:11:40 -0700
Message-ID: <CAKOOJTz4A2ER8MQE1dW27Spocds09SYafjeuLcFDJ0nL6mKyOw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] bnxt_en: Check devlink allocation and
 registration status
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 11:13 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> devlink is a software interface that doesn't depend on any hardware
> capabilities. The failure in SW means memory issues, wrong parameters,
> programmer error e.t.c.
>
> Like any other such interface in the kernel, the returned status of
> devlink APIs should be checked and propagated further and not ignored.
>
> Fixes: 4ab0c6a8ffd7 ("bnxt_en: add support to enable VF-representors")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  5 ++++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 13 ++++++-------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h | 13 -------------
>  3 files changed, 10 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 037767b370d5..4c483fd91dbe 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -13370,7 +13370,9 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>         }
>
>         bnxt_inv_fw_health_reg(bp);
> -       bnxt_dl_register(bp);
> +       rc = bnxt_dl_register(bp);
> +       if (rc)
> +               goto init_err_dl;
>
>         rc = register_netdev(dev);
>         if (rc)
> @@ -13390,6 +13392,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>
>  init_err_cleanup:
>         bnxt_dl_unregister(bp);
> +init_err_dl:
>         bnxt_shutdown_tc(bp);
>         bnxt_clear_int_mode(bp);
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index bf7d3c17049b..dc0851f709f5 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -134,7 +134,7 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
>  {
>         struct bnxt_fw_health *health = bp->fw_health;
>
> -       if (!bp->dl || !health)
> +       if (!health)
>                 return;
>
>         if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) || health->fw_reset_reporter)
> @@ -188,7 +188,7 @@ void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
>  {
>         struct bnxt_fw_health *health = bp->fw_health;
>
> -       if (!bp->dl || !health)
> +       if (!health)
>                 return;
>
>         if ((all || !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) &&
> @@ -781,6 +781,7 @@ int bnxt_dl_register(struct bnxt *bp)
>  {
>         const struct devlink_ops *devlink_ops;
>         struct devlink_port_attrs attrs = {};
> +       struct bnxt_dl *bp_dl;
>         struct devlink *dl;
>         int rc;
>
> @@ -795,7 +796,9 @@ int bnxt_dl_register(struct bnxt *bp)
>                 return -ENOMEM;
>         }
>
> -       bnxt_link_bp_to_dl(bp, dl);
> +       bp->dl = dl;
> +       bp_dl = devlink_priv(dl);
> +       bp_dl->bp = bp;
>
>         /* Add switchdev eswitch mode setting, if SRIOV supported */
>         if (pci_find_ext_capability(bp->pdev, PCI_EXT_CAP_ID_SRIOV) &&
> @@ -826,7 +829,6 @@ int bnxt_dl_register(struct bnxt *bp)
>  err_dl_port_unreg:
>         devlink_port_unregister(&bp->dl_port);
>  err_dl_free:
> -       bnxt_link_bp_to_dl(bp, NULL);
>         devlink_free(dl);
>         return rc;
>  }
> @@ -835,9 +837,6 @@ void bnxt_dl_unregister(struct bnxt *bp)
>  {
>         struct devlink *dl = bp->dl;
>
> -       if (!dl)
> -               return;
> -

minor nit: There's obviously nothing incorrect about doing this (and
adding the additional error label in the cleanup code above), but bnxt
has generally adopted a style of having cleanup functions being
idempotent. It generally makes error handling simpler and less error
prone.

>         if (BNXT_PF(bp)) {
>                 bnxt_dl_params_unregister(bp);
>                 devlink_port_unregister(&bp->dl_port);
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
> index d889f240da2b..406dc655a5fc 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
> @@ -20,19 +20,6 @@ static inline struct bnxt *bnxt_get_bp_from_dl(struct devlink *dl)
>         return ((struct bnxt_dl *)devlink_priv(dl))->bp;
>  }
>
> -/* To clear devlink pointer from bp, pass NULL dl */
> -static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
> -{
> -       bp->dl = dl;
> -
> -       /* add a back pointer in dl to bp */
> -       if (dl) {
> -               struct bnxt_dl *bp_dl = devlink_priv(dl);
> -
> -               bp_dl->bp = bp;
> -       }
> -}
> -
>  #define NVM_OFF_MSIX_VEC_PER_PF_MAX    108
>  #define NVM_OFF_MSIX_VEC_PER_PF_MIN    114
>  #define NVM_OFF_IGNORE_ARI             164
> --
> 2.31.1
>

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>

Regards,
Edwin Peer
