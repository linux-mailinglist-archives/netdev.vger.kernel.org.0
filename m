Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764C03C59EE
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344759AbhGLJQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 05:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386848AbhGLJQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 05:16:19 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AB8C05BD29;
        Mon, 12 Jul 2021 02:09:28 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d1so13422052qto.4;
        Mon, 12 Jul 2021 02:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Hb4dRGQaLYUGOw/97dBG/9ft0r02/qtDhdKS1aLQhY=;
        b=F2WRzrh92USD1R81KIWzagjewtnabzUnm6mBgrT41r0CFTr30dSUEf4xI0MwXvBQ5O
         tnjOPWBjCcWxo1n4XK/xB+DTWBoyIjpW4OS0MjcXzZT7soZzl1oKNs7X/ze1zfutUoQI
         4/mGBepuM7tjzr0zqIXQxnemW8/X8yhwjdzXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Hb4dRGQaLYUGOw/97dBG/9ft0r02/qtDhdKS1aLQhY=;
        b=hvcj8Rod3tPKhykRMJ3I10hVMoyqX8ec+U4iyBfAUHaR9kBYIQaEnahB+8xHrZ9Ub5
         AJeWmO0KoiZF06eu8XAtGeLYqtET0RSbOKPUpVhyNyeK26KkoR5/Qv0z1r30e7+uRrzH
         H0Nmw71uJCfjoxCJomu/65S9rSZkcHrPGH3cncVKSSP8NTYxd8P9GEqEgW4U6ENNt9Kv
         fXHh1zHHEyENaE8aGMDqifRIeB2K3RIvtoqksO8VWg8lrWn7qAp0C5/rEpCf+lHTNlqm
         bLRW9gFSQU6v5I5ofBcElVHyFmJDaAGRWgTMjxh4uRkgTpRWrWpo6zBjj5xi5VY8zz0A
         C0Ug==
X-Gm-Message-State: AOAM533jgJJJY3xJhYMB6WuRy4T4L9CsRVM70jw1HBX01tDgp56pFQom
        w5I+cdkqEGMxK06DGCPpHHZVrw8vcvHj9v9yn1c=
X-Google-Smtp-Source: ABdhPJyToliZLHFnqZ8syXg4Y03QiwsYTKpHEyW2zOfd12JZgZ+RqmnvsIaw3P6B3EnDucnrgc6D9QhtXSC4tf18m5Q=
X-Received: by 2002:ac8:6697:: with SMTP id d23mr43113869qtp.135.1626080967396;
 Mon, 12 Jul 2021 02:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210708122754.555846-1-i.mikhaylov@yadro.com> <20210708122754.555846-2-i.mikhaylov@yadro.com>
In-Reply-To: <20210708122754.555846-2-i.mikhaylov@yadro.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 12 Jul 2021 09:09:15 +0000
Message-ID: <CACPK8Xe2W-qTPjyuAHkTGq6Kz0sWYRz23Cqqdxu0CL2XNc=T0w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] net/ncsi: fix restricted cast warning of sparse
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Jul 2021 at 12:27, Ivan Mikhaylov <i.mikhaylov@yadro.com> wrote:
>
> Sparse reports:
> net/ncsi/ncsi-rsp.c:406:24: warning: cast to restricted __be32
> net/ncsi/ncsi-manage.c:732:33: warning: cast to restricted __be32
> net/ncsi/ncsi-manage.c:756:25: warning: cast to restricted __be32
> net/ncsi/ncsi-manage.c:779:25: warning: cast to restricted __be32

Strange, I don't get these warnings from sparse on my system.

$ sparse --version
0.6.3 (Debian: 0.6.3-2)

>
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
> ---
>  net/ncsi/ncsi-manage.c | 6 +++---
>  net/ncsi/ncsi-rsp.c    | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> index ca04b6df1341..42b54a3da2e6 100644
> --- a/net/ncsi/ncsi-manage.c
> +++ b/net/ncsi/ncsi-manage.c
> @@ -700,7 +700,7 @@ static int ncsi_oem_gma_handler_bcm(struct ncsi_cmd_arg *nca)
>         nca->payload = NCSI_OEM_BCM_CMD_GMA_LEN;
>
>         memset(data, 0, NCSI_OEM_BCM_CMD_GMA_LEN);
> -       *(unsigned int *)data = ntohl(NCSI_OEM_MFR_BCM_ID);
> +       *(unsigned int *)data = ntohl((__force __be32)NCSI_OEM_MFR_BCM_ID);

This looks wrong, the value you're passing isn't big endian. It would
make more sense if the byte swap was ntohl, as it's coming from the
cpu and going into the NCSI packet.

>         data[5] = NCSI_OEM_BCM_CMD_GMA;
>
>         nca->data = data;
> @@ -724,7 +724,7 @@ static int ncsi_oem_gma_handler_mlx(struct ncsi_cmd_arg *nca)
>         nca->payload = NCSI_OEM_MLX_CMD_GMA_LEN;
>
>         memset(&u, 0, sizeof(u));
> -       u.data_u32[0] = ntohl(NCSI_OEM_MFR_MLX_ID);
> +       u.data_u32[0] = ntohl((__force __be32)NCSI_OEM_MFR_MLX_ID);
>         u.data_u8[5] = NCSI_OEM_MLX_CMD_GMA;
>         u.data_u8[6] = NCSI_OEM_MLX_CMD_GMA_PARAM;
>
> @@ -747,7 +747,7 @@ static int ncsi_oem_smaf_mlx(struct ncsi_cmd_arg *nca)
>         int ret = 0;
>
>         memset(&u, 0, sizeof(u));
> -       u.data_u32[0] = ntohl(NCSI_OEM_MFR_MLX_ID);
> +       u.data_u32[0] = ntohl((__force __be32)NCSI_OEM_MFR_MLX_ID);
>         u.data_u8[5] = NCSI_OEM_MLX_CMD_SMAF;
>         u.data_u8[6] = NCSI_OEM_MLX_CMD_SMAF_PARAM;
>         memcpy(&u.data_u8[MLX_SMAF_MAC_ADDR_OFFSET],
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index 888ccc2d4e34..04bc50be5c01 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -403,7 +403,7 @@ static int ncsi_rsp_handler_ev(struct ncsi_request *nr)
>         /* Update to VLAN mode */
>         cmd = (struct ncsi_cmd_ev_pkt *)skb_network_header(nr->cmd);
>         ncm->enable = 1;
> -       ncm->data[0] = ntohl(cmd->mode);
> +       ncm->data[0] = ntohl((__force __be32)cmd->mode);
>
>         return 0;
>  }
> --
> 2.31.1
>
