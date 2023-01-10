Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9F2663B38
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjAJIgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237967AbjAJIfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:35:44 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE31C4D70F
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:35:32 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id e76so11046133ybh.11
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iut40nCHyytrA7iXMWilpOeK2BSxhph4VUkz02uA4d8=;
        b=L5eoPVPo7ZAZ7gklj8aJC5o9QP/VoFpQtXh7YLZkM40XlrlyrBY4vjBnObDmHe0ZwP
         eaVDCUbgOC4v0ul4LF6Ff0CmJqbJ3dsYH0obFDYNf5Yi7QXQ9Bx9Pz+CMtgr4q5QyQaQ
         Jhi0Bszh7MbQBYYprBwqdCLbABBPmfmwmtMGw2O4HJcadFKbQos9zixOWIMe0isu50Yl
         /PmqTon95rNbIL8EPPIga3aSe4fX4g7yqIbBIfFKOCZjhaZoz1rCI83+X7WP4JXjzc75
         VVm6SWJKiOR0Hs6wm0yD8MYD7mHVBS+3JnvwQIe4OsCsit3FUoVnbsknsMC23QsZJitg
         yPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iut40nCHyytrA7iXMWilpOeK2BSxhph4VUkz02uA4d8=;
        b=jHPEdBYWhvrIg00S/cXAZmYwQRgaRpDklhnUMNtT4jpQNRZ4EHC96X49wcZUOb/OW3
         ddHZWc3LS1faWeNEOG1tDnlX8Tzf0itiwzZNd/TbIF3ISRVp2vWH7CZPoXW0MUKfTciO
         9tyDSaqGJcOhDP46dufYxJvmfhDOvPcclnt22SKfZE6lBGbbULZHOgs0+rTFFx3JsE9z
         k72XRAQkwt0LhEu+fBs45pUd9mXEzzWE9fcwUAjCoqezzITbaBepfRoKRkGYpCUme4D0
         5XWsIL8qXncFPXAiBpkupNH/NeFX410zOWw5gp18LonepuXaYTkJajp4PPK/UibLQMU4
         /LRg==
X-Gm-Message-State: AFqh2kpujB5kxCU3yjpy2rSZi14agIjd+8SxmW6zWa3jujuPOEptctW7
        hjl9UrAqfXxcsCwA733XL9JhVbdA16gRPQHtIyUIHQ==
X-Google-Smtp-Source: AMrXdXuDdb3KJlPnmd94D8UeDeZ6veDTR+CCx+zoa/M+qWzUIidA8ttAG0hkIv8vuPfCfmzFYbIgOFYRWnO3foaaBzQ=
X-Received: by 2002:a25:8f89:0:b0:7b3:bb8:9daf with SMTP id
 u9-20020a258f89000000b007b30bb89dafmr1307710ybl.427.1673339731765; Tue, 10
 Jan 2023 00:35:31 -0800 (PST)
MIME-Version: 1.0
References: <20230107044139.25787-1-gakula@marvell.com> <Y7rAUVXiRNFsuR8y@unreal>
 <DM6PR18MB2602C7D1546455B12340D140CDFF9@DM6PR18MB2602.namprd18.prod.outlook.com>
 <DM6PR18MB26020126CE7BB48D3C2AEC26CDFF9@DM6PR18MB2602.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB26020126CE7BB48D3C2AEC26CDFF9@DM6PR18MB2602.namprd18.prod.outlook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 10 Jan 2023 09:35:20 +0100
Message-ID: <CANn89i+Sunn-C-pcG3utPQsx4qykYJ9kLvS2FVZPMELALcq0UA@mail.gmail.com>
Subject: Re: [net PATCH] octeontx2-pf: Use GFP_ATOMIC in atomic context
To:     Geethasowjanya Akula <gakula@marvell.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 8:54 AM Geethasowjanya Akula <gakula@marvell.com> w=
rote:
>
>
>
> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Sunday, January 8, 2023 6:39 PM
> To: Geethasowjanya Akula <gakula@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kuba@kernel.org=
; pabeni@redhat.com; davem@davemloft.net; edumazet@google.com; Subbaraya Su=
ndeep Bhatta <sbhatta@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>; =
Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Subject: [EXT] Re: [net PATCH] octeontx2-pf: Use GFP_ATOMIC in atomic con=
text
>
> External Email
>
> ----------------------------------------------------------------------
> On Sat, Jan 07, 2023 at 10:11:39AM +0530, Geetha sowjanya wrote:
> >> Use GFP_ATOMIC flag instead of GFP_KERNEL while allocating memory in
> >> atomic context.
>
> >Awesome, but the changed functions don't run in atomic context.
>
> drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>     1368         /* Flush accumulated messages */
>     1369         err =3D otx2_sync_mbox_msg(&pfvf->mbox);
>     1370         if (err)
>     1371                 goto fail;
>     1372
>     1373         get_cpu();
>                  ^^^^^^^^^
> The get_cpu() disables preemption.

Forcing GFP_ATOMIC in init functions is not desirable.

Please move around the get_cpu() so that we keep GFP_KERNEL whenever possib=
le.

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 88f8772a61cd527c2ab138fb5a996470a7dfd456..2e628e12cd1ff92756f054639ab=
d777ea185680f
100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1370,7 +1370,6 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
        if (err)
                goto fail;

-       get_cpu();
        /* Allocate pointers and free them to aura/pool */
        for (qidx =3D 0; qidx < hw->tot_tx_queues; qidx++) {
                pool_id =3D otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1388,13 +1387,17 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
                        err =3D otx2_alloc_rbuf(pfvf, pool, &bufptr);
                        if (err)
                                goto err_mem;
+                       /* __cn10k_aura_freeptr() needs to be called
+                        * with preemption disabled.
+                        */
+                       get_cpu();
                        pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
+                       put_cpu();
                        sq->sqb_ptrs[sq->sqb_count++] =3D (u64)bufptr;
                }
        }

 err_mem:
-       put_cpu();
        return err ? -ENOMEM : 0;

 fail:
