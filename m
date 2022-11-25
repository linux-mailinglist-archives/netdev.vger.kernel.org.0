Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33503638D81
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiKYPem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKYPek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:34:40 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BE72AE24
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:34:39 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id n3so7298054wrp.5
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OkjTnMrO+Hlw0n0ax0HVp3QpXu8VFdtWL/kNK02uXU=;
        b=JlrjqaFyq9HofgWdPAPlt5KVfChQp3Jdc25lcz9CiZee4rqbCe7ze+UzW9ZnA07Nrc
         M01QjudoiSDJWtf8wHxJhWjwTRgXHozF9fipu95Uc9yJVTKJVLgjJZaBFLQOf4zHzLGr
         zjXQVa9XcRsfBx1B5d6wjvFR7KGdyRW5DXMN8oKO2uei3o2rRrAcAsL8r0QvaT5TncLQ
         qIZ/EvNW0kNpdY48ylczit5H9AIy6pkZtnZ4LSMfzDtbFQd180yUbdkav0rbIL8bRl5U
         udej+8xCXBodlijkk5nj21MlLok0M2R1F2ti2FYqOK6r67G5P9uWTdkXGGlfFjRxMLKs
         dU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3OkjTnMrO+Hlw0n0ax0HVp3QpXu8VFdtWL/kNK02uXU=;
        b=oreVRxVY6xbZ8dynTOI4tpIdlFILAlCyUUfVKjFkKabQ3K+bqhfoep8sqOpPWvhwKz
         P7gWTZeWTIDSFHYiR9oQ0fXgLSEQXE5y8Y7M49tv7SvCS2LIZdIbMYFOu4LZO8sJtfhf
         uUtt185rUkU4tyFrFD0N4mRcd1hEzMPm0qLN9NHPUVG9F21k7sZFrtcEVXSNREaCqJZx
         /7ri3KaQFqttvGFIK+0Ofc6Ig6t7DOdbH73VF0vU7LiQFEIhzBxdXcLhqPOhV36qQWWM
         TQ2XWMkIEX2fVIScLNj/UnKtVLDmOyDTD9s8YP9n/lY8uOOkEZ5TjBRlzmONFSyu7Zhd
         oltQ==
X-Gm-Message-State: ANoB5pnZ+SSapfOu4ALQkZ8sjcfGEOXRU02I55ZL3b9RgAlWg43VIYTb
        hPUwYPRKCixVGogrxvNSvAwKvkCrYyE=
X-Google-Smtp-Source: AA0mqf78XhYr243mBZE16nF9dmVOtdeSCJo0azlvRrRgl9LtdW2MLczVKcNx5PFgoxoS9OK2n0ag3w==
X-Received: by 2002:a5d:48c3:0:b0:241:784b:1b7f with SMTP id p3-20020a5d48c3000000b00241784b1b7fmr24547532wrs.38.1669390477590;
        Fri, 25 Nov 2022 07:34:37 -0800 (PST)
Received: from suse.localnet (host-79-55-110-244.retail.telecomitalia.it. [79.55.110.244])
        by smtp.gmail.com with ESMTPSA id x10-20020a05600c21ca00b003a6125562e1sm5057622wmj.46.2022.11.25.07.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 07:34:36 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH v2 net-next 1/6] ch_ktls: Use memcpy_from_page() instead of k[un]map_atomic()
Date:   Fri, 25 Nov 2022 16:34:35 +0100
Message-ID: <5779845.MhkbZ0Pkbq@suse>
In-Reply-To: <20221123205219.31748-2-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com> <20221123205219.31748-2-anirudh.venkataramanan@intel.com>
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

On mercoled=EC 23 novembre 2022 21:52:14 CET Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page(). Replace
> the map-memcpy-unmap usage pattern (done using k[un]map_atomic()) with
> memcpy_from_page(), which internally uses kmap_local_page() and
> kunmap_local(). This renders the variables 'data' and 'vaddr' unnecessary,
> and so remove these too.
>=20
> Note that kmap_atomic() disables preemption and page-fault processing, but
> kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
> to check if the code being executed between the map/unmap implicitly
> depends on page-faults and/or preemption being disabled. If yes, then code
> to disable page-faults and/or preemption should also be added for
> functional correctness. That however doesn't appear to be the case here,
> so just memcpy_from_page() is used.

Just two marginal notes:

It looks like you are explaining your mental process and teaching how =20
developers should approach these kinds of conversions. Although I'm OK with=
=20
this exposition, a plain assurance that the code being executed between the=
=20
map / unmap did not depend on page-faults and/or preemption being disabled=
=20
would have sufficed. :-)

Ira were suggesting to not use "it appears" and replace with stronger and=20
clearer assertions like "it is" or "I can confirm that" (or whatever else l=
ike =20
these).

As said, no problems at all with regard to the overall goodness of this and=
=20
the other patches.

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
> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
> v1 -> v2:
>  Use memcpy_from_page() as suggested by Fabio
>  Add a "Suggested-by" tag
>  Rework commit message
>  Some emails cc'd in v1 are defunct. Drop them. The MAINTAINERS file for
>  Chelsio drivers likely needs an update
> ---
>  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 26 +++++++++----------
>  1 file changed, 12 insertions(+), 14 deletions(-)

It looks good to me.

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio

> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls=
=2Ec
> b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c index
> da9973b..1a5fdd7 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> @@ -1839,9 +1839,7 @@ static int chcr_short_record_handler(struct
> chcr_ktls_info *tx_info, */
>  		if (prior_data_len) {
>  			int i =3D 0;
> -			u8 *data =3D NULL;
>  			skb_frag_t *f;
> -			u8 *vaddr;
>  			int frag_size =3D 0, frag_delta =3D 0;
>=20
>  			while (remaining > 0) {
> @@ -1853,24 +1851,24 @@ static int chcr_short_record_handler(struct
> chcr_ktls_info *tx_info, i++;
>  			}
>  			f =3D &record->frags[i];
> -			vaddr =3D kmap_atomic(skb_frag_page(f));
> -
> -			data =3D vaddr + skb_frag_off(f)  + remaining;
>  			frag_delta =3D skb_frag_size(f) - remaining;
>=20
>  			if (frag_delta >=3D prior_data_len) {
> -				memcpy(prior_data, data,=20
prior_data_len);
> -				kunmap_atomic(vaddr);
> +				memcpy_from_page(prior_data,=20
skb_frag_page(f),
> +						 skb_frag_off(f) +=20
remaining,
> +						 prior_data_len);
>  			} else {
> -				memcpy(prior_data, data, frag_delta);
> -				kunmap_atomic(vaddr);
> +				memcpy_from_page(prior_data,=20
skb_frag_page(f),
> +						 skb_frag_off(f) +=20
remaining,
> +						 frag_delta);
> +
>  				/* get the next page */
>  				f =3D &record->frags[i + 1];
> -				vaddr =3D kmap_atomic(skb_frag_page(f));
> -				data =3D vaddr + skb_frag_off(f);
> -				memcpy(prior_data + frag_delta,
> -				       data, (prior_data_len -=20
frag_delta));
> -				kunmap_atomic(vaddr);
> +
> +				memcpy_from_page(prior_data +=20
frag_delta,
> +						 skb_frag_page(f),
> +						 skb_frag_off(f),
> +						 prior_data_len -=20
frag_delta);
>  			}
>  			/* reset tcp_seq as per the prior_data_required=20
len */
>  			tcp_seq -=3D prior_data_len;
> --
> 2.37.2



