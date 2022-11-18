Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A480E62EEFE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiKRIOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiKRIOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:14:31 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ADF10065
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:14:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id g12so8036613wrs.10
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wDArD510/IvbyRpz2OHDvm6EfNpVKXr7jgHkYf4T4Q=;
        b=FEjKp+CJtRauFhzagiFPzJrYy2uaV2LRKWMX4swCmz6srhbQpNeIGBDFZMcRKoulUG
         zyyK7xWauCa2opgyEv+4NFpSnGWAxOIDJk45KNIJ3yyK8wSqbFs2cVzheQW7r7OVaQdG
         PXWfHU88dBEOTQ5Lq4Y8tA2lhhyrSBYSI0ao/hX+YRcsWjelJhoJxS9DfhZQVJvcBS/J
         pqseDzXcn4R5L7oF/V4VqlwW6GHSOJLNK2vyURnIMt+o+GI2ADrNEwfuR+Vq4zBvG2P8
         INwSud5jCSHBj3E+dKa07HlCzKIxVAnOcbMREMW3WF0l4KzkgD/ixD2XD9Nr166o1sVh
         Mq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8wDArD510/IvbyRpz2OHDvm6EfNpVKXr7jgHkYf4T4Q=;
        b=y7oZSNY/JfF/1yMlx5WHZJvqXbOsS9ZN4wq5XZ+/ZUc0pZEs6P9CNWEOw4lnj80aNr
         NF+FgSFCmMf9SClDZSQSLDGQCRlegOL5/WHnesTS4t5cwrUyPB+e5sHI9WYmQXg41lO1
         9NlmciUXjYqPG8aiVVRQsoPP1hKYoaDN/M47VDPWDTUo7xmjYO0Q+kIorO7D7UXnxEsn
         qYXhs5FR70JsLJ9UaF4A1G3B/JChqN3xKUC4Lkay2s/zk3CXwUdIfbl7gW9cP+gCKSnA
         4H6WkDYdNPkUzNrwpD6jNxT3AXAsdxGie099C1JWjeDxQW3FfzyFlfXOgXfPOJ60zWWM
         V/dg==
X-Gm-Message-State: ANoB5pn0PGIHUosr6qPi4jM/wfPDuXxo30nMgQNaIHKMxqxoNK5CL2IG
        MhJg6gQNb7f4HkoFgF0EFj7wGz+PPsQ=
X-Google-Smtp-Source: AA0mqf6i+rgz/dYu/ZlOnQuhmPtUesH5X909nMyMn3MoGmECLcOKhBlfmtTwQbY7WdDHcAL99RXFwQ==
X-Received: by 2002:a5d:4ec2:0:b0:22e:4a38:3337 with SMTP id s2-20020a5d4ec2000000b0022e4a383337mr3603375wrv.86.1668759262633;
        Fri, 18 Nov 2022 00:14:22 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c4ed100b003c701c12a17sm9406061wmq.12.2022.11.18.00.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 00:14:21 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: [PATCH net-next 1/5] ch_ktls: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 18 Nov 2022 09:14:20 +0100
Message-ID: <2310788.ElGaqSPkdT@suse>
In-Reply-To: <20221117222557.2196195-2-anirudh.venkataramanan@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <20221117222557.2196195-2-anirudh.venkataramanan@intel.com>
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

On gioved=EC 17 novembre 2022 23:25:53 CET Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated in favor of kmap_local_page().
> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
> and kunmap_local() respectively.
>=20
> Note that kmap_atomic() disables preemption and page-fault processing,
> but kmap_local_page() doesn't. Converting the former to the latter is safe
> only if there isn't an implicit dependency on preemption and page-fault
> handling being disabled, which does appear to be the case here.
>=20
> Also note that the page being mapped is not allocated by the driver,
> and so the driver doesn't know if the page is in normal memory. This is t=
he
> reason kmap_local_page() is used as opposed to page_address().
>=20
> I don't have hardware, so this change has only been compile tested.
>=20
> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
> Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> Cc: Rohit Maheshwari <rohitm@chelsio.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls=
=2Ec
> b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c index
> da9973b..d95f230 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> @@ -1853,24 +1853,24 @@ static int chcr_short_record_handler(struct
> chcr_ktls_info *tx_info, i++;
>  			}
>  			f =3D &record->frags[i];
> -			vaddr =3D kmap_atomic(skb_frag_page(f));
> +			vaddr =3D kmap_local_page(skb_frag_page(f));
>=20
>  			data =3D vaddr + skb_frag_off(f)  + remaining;
>  			frag_delta =3D skb_frag_size(f) - remaining;
>=20
>  			if (frag_delta >=3D prior_data_len) {
>  				memcpy(prior_data, data,=20
prior_data_len);
> -				kunmap_atomic(vaddr);
> +				kunmap_local(vaddr);
>  			} else {
>  				memcpy(prior_data, data, frag_delta);
> -				kunmap_atomic(vaddr);
> +				kunmap_local(vaddr);
>  				/* get the next page */
>  				f =3D &record->frags[i + 1];
> -				vaddr =3D kmap_atomic(skb_frag_page(f));
> +				vaddr =3D=20
kmap_local_page(skb_frag_page(f));
>  				data =3D vaddr + skb_frag_off(f);
>  				memcpy(prior_data + frag_delta,
>  				       data, (prior_data_len -=20
frag_delta));
> -				kunmap_atomic(vaddr);
> +				kunmap_local(vaddr);
>  			}
>  			/* reset tcp_seq as per the prior_data_required=20
len */
>  			tcp_seq -=3D prior_data_len;
> --
> 2.37.2

The last conversion could have been done with memcpy_from_page(). However,=
=20
it's not that a big deal. Therefore...

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio



