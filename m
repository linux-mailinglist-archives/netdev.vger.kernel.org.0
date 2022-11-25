Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D78638D8C
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKYPhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKYPhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:37:33 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA4721B0
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:37:31 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id cl5so7290811wrb.9
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sdkldajMZESm6aO9ZNM/JTQ4CO8soGLzGpbkr8qZewA=;
        b=plfWSSuxGuoBmFYpUOXss3ch/OWnTJ9NS0mIJSy5T7ULLmbhVWSAAMx9GrPJsPGSmT
         N5DJ2b6IRplfqSEe4fBS/tn5FQaKH3Xtn/qpzNfS06AuCL20xP4nvqpGGRD+lhGHSSiR
         d0k0LPCtCV3HUUWN/TOq4E8MVTlUBsLHISdC1ReMIS8tTZ1ogpiFkDbKG+SaqZkhDNsU
         aDsK2fEFyzu70KCoeWwKj8e4XDLAOaziC3S2+sD3bXSOTuUbmbaHrW7qCWFTC4aznvvl
         LDm2DCCUaXGrnL1m1c3B0xsC/yxiExQ20OlIuhwNxk+u8JyOfqDgGwGF2meVfTlmq00T
         d5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sdkldajMZESm6aO9ZNM/JTQ4CO8soGLzGpbkr8qZewA=;
        b=6r1q0H53jkjTfUV4T+KAC/qHbMs0ke2cHFk2BaKo679lRuvgAiII4yoL4nyyrmLUfM
         YCoRZAjGs0SLvqkc/DUV2FC2cIpdGIUEuHcdnns9a4bLdmR1o7JSrIOyYYPl4UDZccer
         dS52jqcYLmdfvgd1ASjv9Hjr9Yw1etPmbHyXO+Ba2ysIpq2itmV7sKFd3Kwr3OIW8KC+
         8+Ir/h3MFuITGqATHZujOqS5UylNATyhPU4vb6xDJ0GWQL0ggdXgKIFTH6nO6g9OJysi
         TPsbIXvZC32nllyHi1lD0HTyG6VfwhzluXMmfGUiumZ5E4lWFZ9wZNKitLird+ImAk7/
         KDPQ==
X-Gm-Message-State: ANoB5pnm49XnlyQGDEvrjyku5uQEF1BifI/MAsOwBzUSvXmYjbXvKjZG
        bhQZdUjlNd8XnTvBYVobw4eFq9aAVZc=
X-Google-Smtp-Source: AA0mqf50lwWRSeo6i+T9o5ZmT4GqGtK5TbdWYGxhn2yW/DXiQ3IKKV1KJTwz+5h8aXLZz5WXiUrN7g==
X-Received: by 2002:adf:e50e:0:b0:241:cce2:1af with SMTP id j14-20020adfe50e000000b00241cce201afmr19259363wrm.615.1669390649280;
        Fri, 25 Nov 2022 07:37:29 -0800 (PST)
Received: from suse.localnet (host-79-55-110-244.retail.telecomitalia.it. [79.55.110.244])
        by smtp.gmail.com with ESMTPSA id u17-20020a05600c19d100b003c6f8d30e40sm10392304wmq.31.2022.11.25.07.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 07:37:28 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH v2 net-next 2/6] sfc: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 25 Nov 2022 16:37:27 +0100
Message-ID: <8186695.NyiUUSuA9g@suse>
In-Reply-To: <20221123205219.31748-3-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com> <20221123205219.31748-3-anirudh.venkataramanan@intel.com>
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

On mercoled=EC 23 novembre 2022 21:52:15 CET Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page(). Replace
> kmap_atomic() and kunmap_atomic() with kmap_local_page() and kunmap_local=
()
> respectively.
>=20
> Note that kmap_atomic() disables preemption and page-fault processing, but
> kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
> to check if the code being executed between the map/unmap implicitly
> depends on page-faults and/or preemption being disabled. If yes, then code
> to disable page-faults and/or preemption should also be added for
> functional correctness. That however doesn't appear to be the case here,
> so just kmap_local_page() is used.
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
> v1 -> v2: Update commit message
> ---
>  drivers/net/ethernet/sfc/tx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio

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




