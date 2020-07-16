Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853C4222BA0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgGPTNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:13:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22839 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728374AbgGPTNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594926782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Typg0prut+UBd62a+6lGuGYW0kgoqEQ0hjc0jEFMbb0=;
        b=GtD0nAzo9yDXJPS4ZHWoyetY0XDEtYXzftJdhATW+EqGWQvfDGTEfJVF93gsyg62DxNb1W
        GH9X7wo5CCSqNj4tLasspRJwBxMayL4SEVfpt/bBb5QDYI6aKXg99Oih73MiMea63Veoar
        YMszbb6Dvata83sjw5yyg0JTW2ZBEXQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-BBuVZnHtN9aYS2XDx7VGaw-1; Thu, 16 Jul 2020 15:12:57 -0400
X-MC-Unique: BBuVZnHtN9aYS2XDx7VGaw-1
Received: by mail-wm1-f71.google.com with SMTP id q20so5609418wme.3
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:12:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Typg0prut+UBd62a+6lGuGYW0kgoqEQ0hjc0jEFMbb0=;
        b=ZKMxSRwyLJ2OaycQah+9Fr3E6pw7QIPQzeRDgB4/GZKK0dhU/T/aJTRlb7qZl+55Q1
         VoGqLeZK7vqMQvVxp8d/zttByUYTy7T9dUg+u9EngwIsrRyXep0HpCSkfYOlMaIhOXsw
         2MK2P/A3rQTIos68dOcIOWQ3BVQwS2BSfwzzQ4EmBMCR0l6xCo0zABHFMCt75Y4BpeaG
         sLtX49FNR1S0CF8r0q0wT6mRtjAbXJQMKFcoNotEBf+K7OFLlp+Mb1B+ZQDaLYwz1XFu
         19Eom4ztnWrJkBrPQ4dXzZuLfGhYH5lMlqpUc+paowS+hRXN44bpVzRoFpEMNs7u6Y2k
         Ytuw==
X-Gm-Message-State: AOAM533vQhKXoAFF0kJxiNWUg7JzYVskcvFwp18cPExVlIZDV7TeZEtE
        eHnC9gdwKPwNtw/Rx/aDWCojYfPsWA4onMe1zJroKHBgq2ObKE9kfau5zOjsuBfH050rP9CRRwO
        vhx2mWI8Riv1SjbhV
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr5423923wml.36.1594926776523;
        Thu, 16 Jul 2020 12:12:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNgdIIeS8zEiH608NBKn1aPtmMjKUFjxYAD179Q3Ej5z/QUnThzpjtc5zDkHM6IkR/xCAulw==
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr5423899wml.36.1594926776242;
        Thu, 16 Jul 2020 12:12:56 -0700 (PDT)
Received: from localhost ([151.48.133.17])
        by smtp.gmail.com with ESMTPSA id u186sm10046512wmu.10.2020.07.16.12.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 12:12:55 -0700 (PDT)
Date:   Thu, 16 Jul 2020 21:12:51 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, bpf@vger.kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com
Subject: Re: [PATCH 2/6] net: mvneta: move skb build after descriptors
 processing
Message-ID: <20200716191251.GH2174@localhost.localdomain>
References: <cover.1594309075.git.lorenzo@kernel.org>
 <f5e95c08e22113d21e86662f1cf5ccce16ccbfca.1594309075.git.lorenzo@kernel.org>
 <20200715125844.567e5795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="N8ia4yKhAKKETby7"
Content-Disposition: inline
In-Reply-To: <20200715125844.567e5795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--N8ia4yKhAKKETby7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu,  9 Jul 2020 17:57:19 +0200 Lorenzo Bianconi wrote:
> > +		frag->bv_offset =3D pp->rx_offset_correction;
> > +		skb_frag_size_set(frag, data_len);
> > +		frag->bv_page =3D page;
> > +		sinfo->nr_frags++;
>=20
> nit: please use the skb_frag_* helpers, in case we have to rename those
>      fields again. You should also consider adding a helper for the
>      operation of appending a frag, I bet most drivers will needs this.

Hi Jakub,

thx for the review. Ack, I will fix them in v2.

>=20
> > +static struct sk_buff *
> > +mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *=
rxq,
> > +		      struct xdp_buff *xdp, u32 desc_status)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	int i, num_frags =3D sinfo->nr_frags;
> > +	skb_frag_t frags[MAX_SKB_FRAGS];
> > +	struct sk_buff *skb;
> > +
> > +	memcpy(frags, sinfo->frags, sizeof(skb_frag_t) * num_frags);
> > +
> > +	skb =3D build_skb(xdp->data_hard_start, PAGE_SIZE);
> > +	if (!skb)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
> > +
> > +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> > +	skb_put(skb, xdp->data_end - xdp->data);
> > +	mvneta_rx_csum(pp, desc_status, skb);
> > +
> > +	for (i =3D 0; i < num_frags; i++) {
> > +		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> > +				frags[i].bv_page, frags[i].bv_offset,
> > +				skb_frag_size(&frags[i]), PAGE_SIZE);
> > +		page_pool_release_page(rxq->page_pool, frags[i].bv_page);
> > +	}
> > +
> > +	return skb;
> > +}
>=20
> Here as well - is the plan to turn more of this function into common
> code later on? Looks like most of this is not really driver specific.

I agree. What about adding it when other drivers will add multi-buff suppor=
t?
(here we have even page_pool dependency)

Regards,
Lorenzo

>=20

--N8ia4yKhAKKETby7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXxCmsAAKCRA6cBh0uS2t
rNBEAQCQ8OYOoFKohD+CxSij8yI2WUCcLGFWMdiR2GEMZMMALwD8DCCMbVRT3xn/
vTLa/NxDMa8qxBomWKomWWxN/pchwwM=
=J16m
-----END PGP SIGNATURE-----

--N8ia4yKhAKKETby7--

