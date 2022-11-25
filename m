Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB71638D8F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiKYPj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKYPj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:39:26 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332E12CCBE
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:39:25 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o30so3752644wms.2
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txi+hPEyoiqftLcKrh8osttChlqWlTs7d7scLKgooo4=;
        b=FTjFgeuI4P7ydFGbWGHlGMgRmnG5rklgVHLUYo0h8b/33SxW1cVhIbg5jehJDBVosO
         /7pJiBw7hav2H1qf8yO7O2K5RbNFdAkrM1JsaeAXf9Ai4ur/vYCFUD3YxVGxABJH13AC
         HkSBwqnI7M62XxGktPMV0JphFk84MIdDid0w0Inv3xzRpxZJavLuDIbtFZccWSijedZN
         gaX31qaNDm8dPHueb59fuDYMyHM0MJ+/lsxWd3ybpuTv4shXBWTU7HJbuTlGjdlzb0jj
         dyCPLzwPTaihT+bFw1i2+W+ouxQ1cn7ymnEd8Fe5QhfsDVUo7U6U2988QsDpWfPmrKzR
         An+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=txi+hPEyoiqftLcKrh8osttChlqWlTs7d7scLKgooo4=;
        b=VzTdqFYL0coGQ1LgSvDVzcy2GqhWpOi0RRIWFHJZiiNm2Q9hz8y770d8lCwZhWyqWJ
         TVOGUNUbpfBrJMJfCL8D/xeeSINpIrkpJ0vCHECbbBKtlkzT9eUKXZH/5+azvz2cvRDn
         KYEYsiv3i3f2f5gOFjSPjJMih85JO/1Ap5hZpSlSN4T0CLe7Dls7EhnwwTJbF6IO55fw
         czIctw72QMAzI+uhjP1Z1OBBhIuLYcDe2n8nfNrej35/vCU5EOVaO5Oooedo6oj70cd3
         g3N0f8Mp5K4OICviQTuDeh1di1c1fCUiXzayYTQ7c0zj78AVZGuaG3kfQd5s5ihX9BSe
         F2nA==
X-Gm-Message-State: ANoB5pl6Ovk/C1HjoGx9wfPuQUHaZuXeqDbZqpL60q4drEE2+cyIkTiv
        16EoFL52O7stRSb8IwJW+imHQAITNZ4=
X-Google-Smtp-Source: AA0mqf7QBlftjsDy6NWw2R9p8FXGS87F6cCbj2LRmE3d7O4UIQUbBzFaKOYmYKjNBe4WlHN+azNNYQ==
X-Received: by 2002:a05:600c:4a9a:b0:3c6:d811:6cff with SMTP id b26-20020a05600c4a9a00b003c6d8116cffmr32573285wmp.43.1669390763033;
        Fri, 25 Nov 2022 07:39:23 -0800 (PST)
Received: from suse.localnet (host-79-55-110-244.retail.telecomitalia.it. [79.55.110.244])
        by smtp.gmail.com with ESMTPSA id bd9-20020a05600c1f0900b003c6bd12ac27sm5668505wmb.37.2022.11.25.07.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 07:39:22 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH v2 net-next 4/6] cassini: Use memcpy_from_page() instead of k[un]map_atomic()
Date:   Fri, 25 Nov 2022 16:39:21 +0100
Message-ID: <22871774.6Emhk5qWAg@suse>
In-Reply-To: <20221123205219.31748-5-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com> <20221123205219.31748-5-anirudh.venkataramanan@intel.com>
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

On mercoled=EC 23 novembre 2022 21:52:17 CET Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page(). Replace
> the map-memcpy-unmap usage pattern (done using k[un]map_atomic()) with
> memcpy_from_page(), which internally uses kmap_local_page() and
> kunmap_local(). This renders the variable 'vaddr' unnecessary, and so
> remove this too.
>=20
> Note that kmap_atomic() disables preemption and page-fault processing, but
> kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
> to check if the code being executed between the map/unmap implicitly
> depends on page-faults and/or preemption being disabled. If yes, then code
> to disable page-faults and/or preemption should also be added for
> functional correctness. That however doesn't appear to be the case here,
> so just memcpy_from_page() is used.
>=20
> Also note that the page being mapped is not allocated by the driver, and =
so
> the driver doesn't know if the page is in normal memory. This is the reas=
on
> kmap_local_page() is used (via memcpy_from_page()) as opposed to
> page_address().
>=20
> I don't have hardware, so this change has only been compile tested.
>=20
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
> v1 -> v2:
>  Use memcpy_from_page() as suggested by Fabio
>  Add a "Suggested-by" tag
>  Rework commit message
> ---
>  drivers/net/ethernet/sun/cassini.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio

> diff --git a/drivers/net/ethernet/sun/cassini.c
> b/drivers/net/ethernet/sun/cassini.c index 2f66cfc..4ef05ba 100644
> --- a/drivers/net/ethernet/sun/cassini.c
> +++ b/drivers/net/ethernet/sun/cassini.c
> @@ -90,8 +90,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/jiffies.h>
>=20
> -#define cas_page_map(x)      kmap_atomic((x))
> -#define cas_page_unmap(x)    kunmap_atomic((x))
>  #define CAS_NCPUS            num_online_cpus()
>=20
>  #define cas_skb_release(x)  netif_rx(x)
> @@ -2781,18 +2779,14 @@ static inline int cas_xmit_tx_ringN(struct cas *c=
p,
> int ring,
>=20
>  		tabort =3D cas_calc_tabort(cp, skb_frag_off(fragp), len);
>  		if (unlikely(tabort)) {
> -			void *addr;
> -
>  			/* NOTE: len is always > tabort */
>  			cas_write_txd(cp, ring, entry, mapping, len -=20
tabort,
>  				      ctrl, 0);
>  			entry =3D TX_DESC_NEXT(ring, entry);
> -
> -			addr =3D cas_page_map(skb_frag_page(fragp));
> -			memcpy(tx_tiny_buf(cp, ring, entry),
> -			       addr + skb_frag_off(fragp) + len -=20
tabort,
> -			       tabort);
> -			cas_page_unmap(addr);
> +			memcpy_from_page(tx_tiny_buf(cp, ring, entry),
> +					 skb_frag_page(fragp),
> +					 skb_frag_off(fragp) + len -=20
tabort,
> +					 tabort);
>  			mapping =3D tx_tiny_map(cp, ring, entry, tentry);
>  			len     =3D tabort;
>  		}
> --
> 2.37.2




