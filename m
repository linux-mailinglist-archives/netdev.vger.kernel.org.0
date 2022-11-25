Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B978638D96
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKYPlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiKYPlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:41:14 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FCD30F7F
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:41:13 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso3688781wmo.1
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PdHKfoOKj9qL1+FUY7DGoem5DFghb/fZNXo7kfobhOQ=;
        b=EbSH+u82knpZzm7GFUNwYDQe46mblna6Xwj1Ivn28wvEOKNSGt+dl7zklKtTj0ps/Q
         zZPUAVJMrg+HfGYxUNlaEZVH01hvwi2N5gafwoFcKj1WzeFDYBb3YD0jlqd+vOeHP7lJ
         iwkz4LuEvV0FQEuCxomMYPAR3nOewkzefDoIXs47lSCW1lZPlAsyPUX/XGsVwKsBP7H6
         YRU1+N6jqywn4hAD2uJa20Jd+LEmNiOAvUFmbQXFbvat8PWxrwH7pSeMS1Rs7oqndGRg
         eZzvseJdsNignC+ss6pJnflWmjZBQuYx3O+EUnqYs3vPayOG+Te1sXIS9Z0pqE49ArTo
         n+LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PdHKfoOKj9qL1+FUY7DGoem5DFghb/fZNXo7kfobhOQ=;
        b=OsNAVLf4fJYXPhkBAXHIFMP8y29tUmsOEHjPoZPYnfVmTLtT9nWyZ56z5RVN/AoAc0
         l9ERtPM7n1TGrb81P59SKoS87uvl3Yh4y3D6sK0sZhwbOYKQPPVuWsl/pkuIGnuu6T/U
         sHq6PRHd7D4ZkkTfp1anScAV6LF14b0sFSMIRYmwCVRwnk8qRBxkAdquubugQqEh0Y80
         wQq8ozTs3LqOlzaFSvsebKvZRK3ydXZaX/f+ged+KSw+6N6T7tllp2GWIfPxpEezcvml
         xtVrlejwsRlPQSMeYZweVNm9X3yH2HduOWQh1DbaCo/PMGquKVkSab0KHkGE2x8Up3gm
         QSOQ==
X-Gm-Message-State: ANoB5pk7KRHmY7dZen6oA1sQehSPatFmyYrxRHUSZCxyOzQKKUrHxT88
        nYUd96Bk81rwCFQs+4zSVL6IMU9gTmU=
X-Google-Smtp-Source: AA0mqf7J4P6T2jakCXBFUpohZwsO3sDreQZ9sDtsYDzAMkT1ViZmqQXVe9rzwhcC5+FhJLCl6VtSxQ==
X-Received: by 2002:a7b:c38e:0:b0:3cf:d8b1:246c with SMTP id s14-20020a7bc38e000000b003cfd8b1246cmr21772166wmj.165.1669390872121;
        Fri, 25 Nov 2022 07:41:12 -0800 (PST)
Received: from suse.localnet (host-79-55-110-244.retail.telecomitalia.it. [79.55.110.244])
        by smtp.gmail.com with ESMTPSA id bg16-20020a05600c3c9000b003b497138093sm6172523wmb.47.2022.11.25.07.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 07:41:11 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: Re: [PATCH v2 net-next 6/6] net: thunderbolt: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 25 Nov 2022 16:41:10 +0100
Message-ID: <3525329.R56niFO833@suse>
In-Reply-To: <20221123205219.31748-7-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com> <20221123205219.31748-7-anirudh.venkataramanan@intel.com>
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

On mercoled=EC 23 novembre 2022 21:52:19 CET Anirudh Venkataramanan wrote:
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
> Cc: Michael Jamet <michael.jamet@intel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Yehezkel Bernat <YehezkelShB@gmail.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  drivers/net/thunderbolt.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio

> diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
> index a52ee2b..b20cd37 100644
> --- a/drivers/net/thunderbolt.c
> +++ b/drivers/net/thunderbolt.c
> @@ -1051,7 +1051,7 @@ static void *tbnet_kmap_frag(struct sk_buff *skb,
> unsigned int frag_num, const skb_frag_t *frag =3D
> &skb_shinfo(skb)->frags[frag_num];
>=20
>  	*len =3D skb_frag_size(frag);
> -	return kmap_atomic(skb_frag_page(frag)) + skb_frag_off(frag);
> +	return kmap_local_page(skb_frag_page(frag)) + skb_frag_off(frag);
>  }
>=20
>  static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
> @@ -1109,7 +1109,7 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff=
=20
*skb,
> dest +=3D len;
>=20
>  			if (unmap) {
> -				kunmap_atomic(src);
> +				kunmap_local(src);
>  				unmap =3D false;
>  			}
>=20
> @@ -1147,7 +1147,7 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff=
=20
*skb,
> dest +=3D len;
>=20
>  		if (unmap) {
> -			kunmap_atomic(src);
> +			kunmap_local(src);
>  			unmap =3D false;
>  		}
>=20
> @@ -1162,7 +1162,7 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff=
=20
*skb,
> memcpy(dest, src, data_len);
>=20
>  	if (unmap)
> -		kunmap_atomic(src);
> +		kunmap_local(src);
>=20
>  	if (!tbnet_xmit_csum_and_map(net, skb, frames, frame_index + 1))
>  		goto err_drop;
> --
> 2.37.2




