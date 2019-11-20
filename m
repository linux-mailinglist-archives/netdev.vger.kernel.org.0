Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA840103686
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 10:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfKTJVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 04:21:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36905 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725832AbfKTJVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 04:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574241689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yOBZdmcqWn7gWWQh1nEtEIBl9LQuwnQF2n5huMNUnIc=;
        b=MPeXl95dRqwZe5qkoZm5rqT20dGy+ul6aNHkAoG4oNK16idpTNPQuoKxFIEGw7WhbXRj08
        wkloC00C1+YaYZ8YeKSz9XprQECT1zEdM58rQtAEdQx6zoOlWCkgRjSQiD5Vc0CcT18P8N
        CSszd0Lp7RIxI8scPvDHcUAlftL0/5M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-Zr4R_YqjO0u7Beb9OFI5hA-1; Wed, 20 Nov 2019 04:21:26 -0500
X-MC-Unique: Zr4R_YqjO0u7Beb9OFI5hA-1
Received: by mail-wr1-f70.google.com with SMTP id w9so20861065wrn.9
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 01:21:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qes4iKKBcLRBc3lrJwufxSPsCOxi+9/IEvMCCTXdgak=;
        b=k5NFXenK7GSJ79CyJAbgmCvdWsN6QezVWvNeMpL8LpJ8EDAuEyM9HXfL/lH6PMKIc3
         gOQEM4W18/VuVZaoIeKEhU+ivge3ksfvRNVi9/R5mClAvzrkS2wXTgv4LR/EzM8irca6
         SC/KIkdE/2fc95VEWeSvTwqKRkS532fo0r1Iwj6MjvZDRZsBo4JfZWPT1ORSs3axKv+h
         brUzRl6cWWc9jbVHjyNN6KV6L9WFhWpyyjSWvYg2W/1zGUGxnZzSMvl8Nv/84qemlbhK
         v6PUSwkbA+2Swrq4/eDSTKl1sbUWSRolWA890BaFCwYTWhINnsKA6HTsMaOxTI1a+G9C
         pOnw==
X-Gm-Message-State: APjAAAVVc0ork3yZvXxo+/V2eUkbAtFwfhXcd2WDTSVy8uF36P6rrjRt
        iIVNeTokJjbJHiKNZh+fyxvL3gqUq7C+F6ZBEbAui6kQN2b87+AVk31vikPI0dUDCOo0rsF96eL
        bmxvCKjghiG3oCl3h
X-Received: by 2002:adf:d4c2:: with SMTP id w2mr2037910wrk.340.1574241684927;
        Wed, 20 Nov 2019 01:21:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqyMbyksMm4BcLxS/cfv1mlb70NLG+oyYiLzQlpFUCAezoPlYGq6jyhtcdEu8j+UMNMPCVBhwQ==
X-Received: by 2002:adf:d4c2:: with SMTP id w2mr2037869wrk.340.1574241684570;
        Wed, 20 Nov 2019 01:21:24 -0800 (PST)
Received: from localhost.localdomain ([77.139.212.74])
        by smtp.gmail.com with ESMTPSA id x11sm30971156wro.84.2019.11.20.01.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 01:21:23 -0800 (PST)
Date:   Wed, 20 Nov 2019 11:21:20 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org, mcroce@redhat.com
Subject: Re: [PATCH v4 net-next 3/3] net: mvneta: get rid of huge dma sync in
 mvneta_rx_refill
Message-ID: <20191120092120.GA2538@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <7bd772e5376af0c55e7319b7974439d4981aa167.1574083275.git.lorenzo@kernel.org>
 <20191119123850.5cd60c0e@carbon>
 <20191119121911.GC3449@localhost.localdomain>
 <20191119155143.0683f754@carbon>
 <20191119153827.GE3449@localhost.localdomain>
 <188EF030-DAB4-4FD0-AFD1-107C24A10943@gmail.com>
MIME-Version: 1.0
In-Reply-To: <188EF030-DAB4-4FD0-AFD1-107C24A10943@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 19 Nov 2019, at 7:38, Lorenzo Bianconi wrote:
>=20
> > [...]
> > > > > > -=09=09page_pool_recycle_direct(rxq->page_pool,
> > > > > > -=09=09=09=09=09 virt_to_head_page(xdp->data));
> > > > > > +=09=09__page_pool_put_page(rxq->page_pool,
> > > > > > +=09=09=09=09     virt_to_head_page(xdp->data),
> > > > > > +=09=09=09=09     xdp->data_end - xdp->data_hard_start,
> > > > > > +=09=09=09=09     true);
> > > > >=20
> > > > > This does beg for the question: Should we create an API wrapper f=
or
> > > > > this in the header file?
> > > > >=20
> > > > > But what to name it?
> > > > >=20
> > > > > I know Jonathan doesn't like the "direct" part of the
> > > > > previous function
> > > > > name page_pool_recycle_direct.  (I do considered calling
> > > > > this 'napi'
> > > > > instead, as it would be inline with networking use-cases,
> > > > > but it seemed
> > > > > limited if other subsystem end-up using this).
> > > > >=20
> > > > > Does is 'page_pool_put_page_len' sound better?
> > > > >=20
> > > > > But I want also want hide the bool 'allow_direct' in the API name=
.
> > > > > (As it makes it easier to identify users that uses this from
> > > > > softirq)
> > > > >=20
> > > > > Going for 'page_pool_put_page_len_napi' starts to be come
> > > > > rather long.
> > > >=20
> > > > What about removing the second 'page'? Something like:
> > > > - page_pool_put_len_napi()
> > >=20
> > > Well, we (unfortunately) already have page_pool_put(), which is used
> > > for refcnt on the page_pool object itself.
> >=20
> > __page_pool_put_page(pp, data, len, true) is a more generic version of
> > page_pool_recycle_direct where we can specify even the length. So what
> > about:
> >=20
> > - page_pool_recycle_len_direct
> > - page_pool_recycle_len_napi
>=20
> I'd suggest:
>=20
> /* elevated refcounts, page may seen by networking stack */
> page_pool_drain(pool, page, count)              /* non napi, len =3D -1 *=
/
> page_pool_drain_direct(pool, page, count)       /* len =3D -1 */
>=20
> page_pool_check_put_page(page)                  /* may not belong to pool=
 */
>=20
> /* recycle variants drain/expect refcount =3D=3D 1 */
> page_pool_recycle(pool, page, len)
> page_pool_recycle_direct(pool, page, len)
>=20
> page_pool_put_page(pool, page, len, mode)=09    /* generic, for __xdp_ret=
urn

I am not against the suggestion but personally I would prefer to explicitat=
e in
the routine name where/how it is actually used. Moreover page_pool_recycle_=
direct or
page_pool_put_page are currently used by multiple drivers and it seems to m=
e
out of the scope of this series. I think we can address it in a follow-up s=
eries
and use __page_pool_put_page for the moment (it is actually just used by mv=
neta).
Agree?

Regards,
Lorenzo

> */
>=20
>=20
> I'd rather add len as a parameter, than add more wrapper variants.
> --=20
> Jonathan
>=20
>=20
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
> > > --=20
> > > Best regards,
> > >   Jesper Dangaard Brouer
> > >   MSc.CS, Principal Kernel Engineer at Red Hat
> > >   LinkedIn: http://www.linkedin.com/in/brouer
> > >=20
>=20

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXdUFjQAKCRA6cBh0uS2t
rEJGAP9z8tBnEC2qElgNE7TbwkcZAc9N6T2iMuIU3mnVowdkKQEAuaoa1YqHTjLz
Svar7gog88rV7NZ3bzV02s2NMutBAAM=
=3Ok0
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--

