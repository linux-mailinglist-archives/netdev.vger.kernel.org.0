Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E9830196F
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 04:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhAXD40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 22:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbhAXD4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 22:56:25 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4478C0613D6
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 19:55:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id g15so6423826pjd.2
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 19:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z8p1cg791IOBOg3jouOVxKLCS8JU3pUKCWAsXYCDxgI=;
        b=UCNNe9kx0Ck4ws+JZLocZVaYyR9CzLndNEwHP4d/f0iTmfrHyWyrlRajbyQNKxHeiK
         EYNQiLW6pzSIu2IfF9qaGBAWxJGGVx0mnhMnl9xINER3PcKTLciyPbdu2OMdDnTfVb3k
         Y7L5qpv3LfMUYtjGuXhxs37hBuKxNCGiNnlWcCN8bZ/eKbxTWOoUgKc6XFPzEnf2Wz/9
         iNlVYP4x0xePEcz5UiKjPrq9V9cknltFoxIMH8iJUfCL26hFnxOAl/byovqNNwjAvnY5
         Ec4xv53dsXMThbIzX5MOpGwR6lU/oVc3W7woQq6r2kPI0x1YVWQzleNWgALMqrtq7lNu
         XMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z8p1cg791IOBOg3jouOVxKLCS8JU3pUKCWAsXYCDxgI=;
        b=ea5UluSaggU4rz8uG5HSOAK7/ajnXqGPCMEdb3k/IeZoeXK8X28Kq27FIQQroRw5Bh
         A4GrMozyP9tXAoqj9DZh7Kv12z9C7WIc5rf5bzGMZlpHx7uijxS3voT8oArxvRfsIbKv
         nh501G7CMXKQNZxRBLg14l02WYWuPy7BbVmv6TfP5LC0j0xukzHMVUkBuZQ6nMSqiGh4
         Pg7UVHJspkoWnERp6qUOKym/qbNO6aGhC9yQrTLzzAciOCgKx9IKPECn7E5nplLUfa0+
         3O66RXVY5eH3Hu6mJdzsWHe9346xOUhWZRIGvnZ+gBM9X2SgxrZs1h893/7p/SuYWk8z
         XQrw==
X-Gm-Message-State: AOAM530BX3lRsvxKt4v9cwaRm9l8FskpNGggXQqb5h2hJG9c122ykxIH
        S4OXD+foYycs07Ukv3xzG54=
X-Google-Smtp-Source: ABdhPJwanmAlLJIpD8jP4uoNu2T6M4tcckDPZvRCwSygRktuz/P9JcfrTj98//etmkRd1xobZtam5A==
X-Received: by 2002:a17:902:c394:b029:df:e6bf:79b1 with SMTP id g20-20020a170902c394b02900dfe6bf79b1mr2039053plg.68.1611460545177;
        Sat, 23 Jan 2021 19:55:45 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id d4sm499083pgq.32.2021.01.23.19.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 19:55:42 -0800 (PST)
Date:   Sun, 24 Jan 2021 11:55:35 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH net-next 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
Message-ID: <20210124035535.GA635475@pek-khao-d2.corp.ad.wrs.com>
References: <20210123115903.31302-1-haokexin@gmail.com>
 <20210123115903.31302-2-haokexin@gmail.com>
 <20210123125221.528cd9e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20210123125221.528cd9e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 23, 2021 at 12:52:21PM -0800, Jakub Kicinski wrote:
> On Sat, 23 Jan 2021 19:59:00 +0800 Kevin Hao wrote:
> > +void *page_frag_alloc(struct page_frag_cache *nc,
> > +		      unsigned int fragsz, gfp_t gfp_mask)
> > +{
> > +	return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
> > +}
> >  EXPORT_SYMBOL(page_frag_alloc);
>=20
> Isn't it better to make this a static inline now?

Sure. I will also inline the {netdev,napi}_alloc_frag().

>=20
> Either way you'll need to repost after net is merged into net-next
> (probably ~this Friday), please mark the posting as RFC before that.

Sorry, I missed that. I will repost after the net is merged into net-next.

> Please make sure you CC the author of the code.

Will do.

Thanks,
Kevin

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmAM77cACgkQk1jtMN6u
sXGy2Af/esvxzz8KVpoRfQPATJGzjAOAB3UmuDILJIYMb494FT1wfOKwV9D1WIpr
ekX94Ax36bX2WAy9yzeJhSOUNJlmDJuNt7BQgfv+0VwF9xH/F0lQaxoChnbkb7TW
GYHaUXyN/yWMH8Vdfz9C3OLfpBCcjQEfinGW5v/hzGNnWWNwfjYVIX95Kh4b9AXJ
rbdrQsaiGEpG+7krlZiyoNn3bpAM5bOmcYwAZ/Ryhn2dQ/Qoa3MXpNFj0i3BC4kA
NNKeKZvc+DBcixnyNHKgupDa48kHBqTAYaqRdA855hS3Jmnub1LPDf4/yySk5zph
fjozo+EKQunm1KxxrsfqlFW1Xtn2BA==
=Bek2
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
