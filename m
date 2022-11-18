Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA062EF1F
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbiKRIXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbiKRIXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:23:37 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD5FDF3E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:23:35 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id i186-20020a1c3bc3000000b003cfe29a5733so6975001wma.3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PI3PpC+s1GjgrJxChzGspCtUYSuG0huNKOwO1QvgNa8=;
        b=m76D0gDJ3D1q8SAnWo74V/Osu4+ALn4vxBk+v2xMrkirrARHJrm4gRrP/r8MwYbBBP
         IdHTBtcp5M2PyBIG6ZoFdv2KuI6xFeC1uvAQSwfLqeXTnYUQsy8rsaQMOluEVx6/PZKZ
         BvAQCgoQ/tr0RTMcSa+4GZ6rnoxWEyCQyk2yIRxFXL0Cv9HvGAA5eI8XyUPhsukTQVxZ
         ExtDmw8JpwAZkr4GRFr/DmMdou19QkRoG/xN42yfxQJTmJQg5vG+Y+LSHcIMj2iCOmQ5
         1JeBpI6KVpgWcpj2D2O3gXluJxIKSj14Yl3LMEwL3AJL+XPPepx+hqMucXjGqrfX7ZED
         HC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PI3PpC+s1GjgrJxChzGspCtUYSuG0huNKOwO1QvgNa8=;
        b=6QsOygGk7VlDgxFnOcbjp5T4HABbjs+LndM0zsSJIxlKyscr5dpEnnDGtjLfbjHmp/
         HNQK7FBFPl7drkf0sC9de39AJ9LV4OpvmuUxe+n9Vykmif7xdLBh72vuMna7Z35zMkR9
         Kc/pdppLLB5tKhpVnc4azaLqzJ/xznGvspNEyiOId360nhpURgOLJE1dntFvkyMFIcxo
         nAC0lfDUMfALztSRWERZuZzPF1sN+2KtjGNTYBT7p+ncljSjgUREBn4Kerp6ytMZ3+qt
         qKFryTqX/91gMLBQfq9l6t/lM8L7yyhs6A8OTYm1FU0op/m+KPEZSzxyJUDw4+6txhNQ
         aJXw==
X-Gm-Message-State: ANoB5pnVRaDjSdfl2GZUAwSXfP868S/3DYfhtCpJniWlg1w5SjC/hB2V
        hrZwy9jyopzsO2F5dy0d6dtzau0xFEE=
X-Google-Smtp-Source: AA0mqf4V9Qb3EQ78QwRCEXZSn9os9GyuC8ZN3bJ3qLPZ0YxPRnQJknpP57CyUnBRGXBvyd02QFd7mA==
X-Received: by 2002:a1c:7409:0:b0:3cf:713a:c947 with SMTP id p9-20020a1c7409000000b003cf713ac947mr4226284wmc.40.1668759813345;
        Fri, 18 Nov 2022 00:23:33 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id z2-20020a1c4c02000000b003cfe1376f68sm3723160wmf.9.2022.11.18.00.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 00:23:32 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH net-next 2/5] sfc: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 18 Nov 2022 09:23:31 +0100
Message-ID: <8192948.T7Z3S40VBb@suse>
In-Reply-To: <20221117222557.2196195-3-anirudh.venkataramanan@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <20221117222557.2196195-3-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On gioved=EC 17 novembre 2022 23:25:54 CET Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page().
> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
> and kunmap_local() respectively.
>=20
> Note that kmap_atomic() disables preemption and page-fault processing, but
> kmap_local_page() doesn't. Converting the former to the latter is safe on=
ly
> if there isn't an implicit dependency on preemption and page-fault handli=
ng
> being disabled, which does appear to be the case here.

NIT: It is always possible to disable explicitly along with the conversion.
However, you are noticing that we don't need to do it.

I'm noticing the same wording in other of your patches, but there are no=20
problems with them.=20

>=20
> Also note that the page being mapped is not allocated by the driver, and =
so
> the driver doesn't know if the page is in normal memory. This is the reas=
on
> kmap_local_page() is used as opposed to page_address().
>=20
> I don't have hardware, so this change has only been compile tested.
>=20
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Cc: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  drivers/net/ethernet/sfc/tx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index c5f88f7..4ed4082 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -207,11 +207,11 @@ static void efx_skb_copy_bits_to_pio(struct efx_nic
> *efx, struct sk_buff *skb, skb_frag_t *f =3D &skb_shinfo(skb)->frags[i];
>  		u8 *vaddr;
>=20
> -		vaddr =3D kmap_atomic(skb_frag_page(f));
> +		vaddr =3D kmap_local_page(skb_frag_page(f));
>=20
>  		efx_memcpy_toio_aligned_cb(efx, piobuf, vaddr +=20
skb_frag_off(f),
>  					   skb_frag_size(f),=20
copy_buf);
> -		kunmap_atomic(vaddr);
> +		kunmap_local(vaddr);
>  	}
>=20
>  	EFX_WARN_ON_ONCE_PARANOID(skb_shinfo(skb)->frag_list);
> --
> 2.37.2

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio


