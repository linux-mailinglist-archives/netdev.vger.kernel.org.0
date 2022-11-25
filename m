Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433BC638D95
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiKYPka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiKYPkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:40:11 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DDF2CCBE
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:40:10 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v1so7286834wrt.11
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=114XLRD0ivQwdldZ3CGUjLGyIKkOsz9/gsIrmcaoAsU=;
        b=f7ynFeLFsXuBsBVAUBeAHW/RB47WwcTHbFz/DwZm7GibdYLHRHnwCC1RX7ocTxL13v
         Iu/Lt++W7Ru9X6crGKz/CZyEZo2fGsarKI8+pKDSsz8S4nVfGI9TmdHTOL4GPCSAL5+q
         cPzen6JWYj6lhql5RO6chkaXblDgMj/qFWtfAYcnHf/9z2zxl0lJc+r7BSO9I1oJA7JO
         Mm6fYBYh7Xt2r8My3DoWcqYAlomEe0vkuMpGfaTfiKcs/H+mVfy7wTc2EdWFw2cBzANn
         TBqx6woGUqEKBpxa3gc+5TCQwrMuQdsj52M+jm67Z9Izf3iGqXuf3mfxlySl98j5ecuY
         iHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=114XLRD0ivQwdldZ3CGUjLGyIKkOsz9/gsIrmcaoAsU=;
        b=cYvuJdkZywOjYOTcPwLSfnTekfI9UpflkkbThf1dr96znspnhutwnL4fpw7LDt7G2k
         4vDiCV87bt4WtiiACxppHXpvlqWvTvYfPe7b3O96eKAuYZ8OQvetxeAW2RYahM7UgnuO
         g2QLo4RZ+M8tZXw+q3ZrwL9biyn7naRKAgI23DnLz9GyA7V+f79pdXioNffu0FYMnjhM
         n/J/BKKm3jWjv5g0hM9uoxJJEbCIUXXhF9CEXMMFwwzhQEUT1J+ZByjKgtkvBHn+5MNy
         eIwxMj6T4LIpJU7HVgIiNrnd+N+awKqHe87xBwPsAOtDOLa5mNmqIejTTtcucKprdSQg
         9vLA==
X-Gm-Message-State: ANoB5pmW64HFMmVrab7Pugh8aE2TlWB7HmQVlEW9KEPoRnfeCX0tpbc8
        MFtj36JkPYVetuxfWePW5ZoW7yUmz/0=
X-Google-Smtp-Source: AA0mqf67YhuFe4KDTLxvtCM66B3It99mN1KDOWmhq+9Fz0PBPSYjL2/UWdUhQ5TtRLMaEbkH3zjt3w==
X-Received: by 2002:a5d:46d0:0:b0:242:91c:a12f with SMTP id g16-20020a5d46d0000000b00242091ca12fmr1239084wrs.524.1669390808373;
        Fri, 25 Nov 2022 07:40:08 -0800 (PST)
Received: from suse.localnet (host-79-55-110-244.retail.telecomitalia.it. [79.55.110.244])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c310b00b003cfd4e6400csm6406595wmo.19.2022.11.25.07.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 07:40:06 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH v2 net-next 5/6] sunvnet: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 25 Nov 2022 16:40:05 +0100
Message-ID: <4229713.ejJDZkT8p0@suse>
In-Reply-To: <20221123205219.31748-6-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com> <20221123205219.31748-6-anirudh.venkataramanan@intel.com>
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

On mercoled=EC 23 novembre 2022 21:52:18 CET Anirudh Venkataramanan wrote:
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
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
> v1 -> v2: Update commit message
> ---
>  drivers/net/ethernet/sun/sunvnet_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio

> diff --git a/drivers/net/ethernet/sun/sunvnet_common.c
> b/drivers/net/ethernet/sun/sunvnet_common.c index 80fde5f..a6211b9 100644
> --- a/drivers/net/ethernet/sun/sunvnet_common.c
> +++ b/drivers/net/ethernet/sun/sunvnet_common.c
> @@ -1085,13 +1085,13 @@ static inline int vnet_skb_map(struct ldc_channel=
=20
*lp,
> struct sk_buff *skb, u8 *vaddr;
>=20
>  		if (nc < ncookies) {
> -			vaddr =3D kmap_atomic(skb_frag_page(f));
> +			vaddr =3D kmap_local_page(skb_frag_page(f));
>  			blen =3D skb_frag_size(f);
>  			blen +=3D 8 - (blen & 7);
>  			err =3D ldc_map_single(lp, vaddr +=20
skb_frag_off(f),
>  					     blen, cookies + nc,=20
ncookies - nc,
>  					     map_perm);
> -			kunmap_atomic(vaddr);
> +			kunmap_local(vaddr);
>  		} else {
>  			err =3D -EMSGSIZE;
>  		}
> --
> 2.37.2




