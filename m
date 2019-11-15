Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5C0FD757
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfKOHuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:50:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42610 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725829AbfKOHuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:50:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573804205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Putlfl1JOk335f4mgoT5ePJWJmrLSR9v1SEKLsGnwyA=;
        b=YYt0XEtF3wJs7/vdKcXNnX8+857mhtr8/Gmc/kKE5jO1fWTuuUlOnk/G8XdvqyAVdL+8gp
        fvngBBvmtydfWZqxNDLyobxngxOe0WNcTblVBksKps1KSLYKYtppsObTTpyAuqeRaIBNQS
        BoMCpokeLAFIs7FgoDSDhRFII+uh/QY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-J2Kn-uZxN1SxO_0gMtUcqw-1; Fri, 15 Nov 2019 02:50:04 -0500
X-MC-Unique: J2Kn-uZxN1SxO_0gMtUcqw-1
Received: by mail-wr1-f69.google.com with SMTP id y1so7264613wrl.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 23:50:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dqfUaaEfCl54QTIDQtUmGOWyRUA+vTp0kjnjhWpY7JM=;
        b=lybnh+Urk5XhOT79OtlUYwMa/XnQlqC9hiQHPYjGKCx2vZYmLTmknNNsjuTN0rQ7Ij
         xusT8DDtqAuJFin73j2SwV8VxeR8s76Tpa4wzfr7BRIQWCxNLtnjhXRPE5wcrsSEYuu0
         dvB3HTHy97sfHXTdnvHyBwGAGm/iZJmbDJ96RfzQYW5DoYACcNvMETG7BTsgjSHiBk20
         U4cYDZBi2P+9Gbf+tz8XPajsNR8+kR0D/5H+LQSE9yG59QAHS5pcoQgjkbifCfg1iwpp
         dzXH2KuwpC4dwM7ZbYqQBI30CYWxRDdicceyd9IuD4jQIl/WYgsGSLduqYkHfsae5ZJc
         gVow==
X-Gm-Message-State: APjAAAW9JaQLUyle7hl+mffuUDtnRjWPojfolkavzQiSPqVOEcn3cz9Q
        S+7DR+9MgAmq3usu4QICzYiQHEHd9rjw8Ey59EuP3De5d0EyX9Vl6WEhjV94yEU/VkJFSUPgg/X
        KHdL97ce+qQB18CUI
X-Received: by 2002:a1c:e0c4:: with SMTP id x187mr13640095wmg.93.1573804203225;
        Thu, 14 Nov 2019 23:50:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqyd8252d3LdOmf63sOS7Lnnr4GL0ZY0dCyefA0WME/5rf3bLJ7lUjHTmf4EnQZDCtohWvUOPQ==
X-Received: by 2002:a1c:e0c4:: with SMTP id x187mr13640061wmg.93.1573804202927;
        Thu, 14 Nov 2019 23:50:02 -0800 (PST)
Received: from localhost.localdomain ([77.139.212.74])
        by smtp.gmail.com with ESMTPSA id z8sm10074128wrp.49.2019.11.14.23.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 23:50:02 -0800 (PST)
Date:   Fri, 15 Nov 2019 09:49:58 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Message-ID: <20191115074743.GB10037@localhost.localdomain>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
 <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
 <20191114204227.GA43707@PC192.168.49.172>
 <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
 <20191114224309.649dfacb@carbon>
 <20191115070551.GA99458@apalos.home>
MIME-Version: 1.0
In-Reply-To: <20191115070551.GA99458@apalos.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Nov 14, 2019 at 10:43:09PM +0100, Jesper Dangaard Brouer wrote:
> > On Thu, 14 Nov 2019 13:04:26 -0800
> > "Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:
> >=20
> > > On 14 Nov 2019, at 12:42, Ilias Apalodimas wrote:
> > >=20
> > > > Hi Jonathan,
> > > >
> > > > On Thu, Nov 14, 2019 at 12:27:40PM -0800, Jonathan Lemon wrote: =20
> > > >>
> > > >>
> > > >> On 14 Nov 2019, at 10:53, Ilias Apalodimas wrote:
> > > >> =20
> > > >>> [...] =20
> > > >>>>> index 2cbcdbdec254..defbfd90ab46 100644
> > > >>>>> --- a/include/net/page_pool.h
> > > >>>>> +++ b/include/net/page_pool.h
> > > >>>>> @@ -65,6 +65,9 @@ struct page_pool_params {
> > > >>>>>  =09int=09=09nid;  /* Numa node id to allocate from pages from =
*/
> > > >>>>>  =09struct device=09*dev; /* device, for DMA pre-mapping purpos=
es */
> > > >>>>>  =09enum dma_data_direction dma_dir; /* DMA mapping direction *=
/
> > > >>>>> +=09unsigned int=09max_len; /* max DMA sync memory size */
> > > >>>>> +=09unsigned int=09offset;  /* DMA addr offset */
> > > >>>>> +=09u8 sync;
> > > >>>>>  }; =20
> > > >>>>
> > > >>>> How about using PP_FLAG_DMA_SYNC instead of another flag word?
> > > >>>> (then it can also be gated on having DMA_MAP enabled) =20
> > > >>>
> > > >>> You mean instead of the u8?
> > > >>> As you pointed out on your V2 comment of the mail, some cards don=
't=20
> > > >>> sync back to device.
> > > >>>
> > > >>> As the API tries to be generic a u8 was choosen instead of a flag
> > > >>> to cover these use cases. So in time we'll change the semantics o=
f
> > > >>> this to 'always sync', 'dont sync if it's an skb-only queue' etc.
> > > >>>
> > > >>> The first case Lorenzo covered is sync the required len only inst=
ead=20
> > > >>> of the full buffer =20
> > > >>
> > > >> Yes, I meant instead of:
> > > >> +=09=09.sync =3D 1,
> > > >>
> > > >> Something like:
> > > >>         .flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC
> > > >>
> >=20
> > I actually agree and think we could use a flag. I suggest
> > PP_FLAG_DMA_SYNC_DEV to indicate that this DMA-sync-for-device.
> >=20
> > Ilias notice that the change I requested to Lorenzo, that dma_sync_size
> > default value is 0xFFFFFFFF (-1).  That makes dma_sync_size=3D=3D0 a va=
lid
> > value, which you can use in the cases, where you know that nobody have
> > written into the data-area.  This allow us to selectively choose it for
> > these cases.
>=20
> Okay, then i guess the flag is a better fit for this.
> The only difference would be that the sync semantics will be done on 'per
> packet' basis,  instead of 'per pool', but that should be fine for our ca=
ses.

Ack, fine for me.
Do you think when checking for PP_FLAG_DMA_SYNC_DEV we should even verify
PP_FLAG_DMA_MAP? Something like:

if ((pool->p.flags & (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)) =3D=3D
    (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV))
=09page_pool_dma_sync_for_device();

Regards,
Lorenzo

>=20
> Cheers
> /Ilias
> >=20
> > --=20
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> >=20
>=20

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXc5YowAKCRA6cBh0uS2t
rIdoAP4+kPQTeI5XhZwHKPAuHRdDHpLQqE27aXT4RYpQnsnW6wEAo9WiHhU8I454
e0HOfCqioNmSgA4sfLZmRDMWHqTkmQA=
=BolR
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--

