Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156D92CC313
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387604AbgLBRKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:10:00 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33660 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387597AbgLBRJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:09:59 -0500
Received: by mail-wr1-f65.google.com with SMTP id u12so4871646wrt.0
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 09:09:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=GoUPntqhXFDjjdaeTnhfFJL5oEa4kYUd17b0TGS2u7k=;
        b=VEXeRhLfzEQNhu+B6m2db+7dEZpQ1HamgFDS10lXKS0GEvmZVodq4aLZ/bGeHbXk/B
         BrooN0IeLo4I2oSvR3XLbrGG42M+pfHZU5JO9H3tDmjFDZd9bhXZTE4xmYIRPrw2VveS
         1+Ox6EflsKxbEDujpve1m0O1cGv67pFHWt9V/h4UnuCKMFuqeMa2stRJOAVQw+65L6hA
         k1wsBEj4JZV7G4g49bm3W+w4NMDl/hAir8udh7s3LvcMD4LfmDEq+l/gOkIvrakAWxxn
         0N170cqoRR6NhrLkI0LfU5LxKvc9tsdU75QBAnNPHpVB3N9ya8ak5QLyVZC+yJdywKnj
         yhUg==
X-Gm-Message-State: AOAM532mMmV83djwx/HL+0CAm1FIFFzgJiOwc81/p4TdjHCc2PG7E0x8
        aqX7dQJJNoFPHslD7NR1IJo=
X-Google-Smtp-Source: ABdhPJznKeckZhW9rWUW65mLhVivpzwyWAhTqLJVucXVn1UNTkHoxYP0FriL9A7PNtscpIYGn9cSwA==
X-Received: by 2002:adf:8b8f:: with SMTP id o15mr4580549wra.311.1606928957805;
        Wed, 02 Dec 2020 09:09:17 -0800 (PST)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id d15sm3119071wrx.93.2020.12.02.09.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 09:09:15 -0800 (PST)
Message-ID: <087c2fe7fd6d09fbafc8907940a0dfa829001958.camel@debian.org>
Subject: Re: [PATCH iproute2 v2] tc/mqprio: json-ify output
From:   Luca Boccassi <bluca@debian.org>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Date:   Wed, 02 Dec 2020 17:09:11 +0000
In-Reply-To: <77134dfe-8e5f-5bcc-25b4-dde91cf3492c@gmail.com>
References: <20201127152625.61874-1-bluca@debian.org>
         <20201128183015.15889-1-bluca@debian.org>
         <77134dfe-8e5f-5bcc-25b4-dde91cf3492c@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-0uuWvC7MsFDOgsK3Lw94"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-0uuWvC7MsFDOgsK3Lw94
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-12-02 at 09:42 -0700, David Ahern wrote:
> On 11/28/20 11:30 AM, Luca Boccassi wrote:
> > @@ -287,9 +293,9 @@ static int mqprio_print_opt(struct qdisc_util *qu, =
FILE *f, struct rtattr *opt)
> >  					return -1;
> >  				*(min++) =3D rta_getattr_u64(r);
> >  			}
> > -			fprintf(f, "	min_rate:");
> > +			open_json_array(PRINT_ANY, is_json_context() ? "min_rate" : "	min_r=
ate:");
> >  			for (i =3D 0; i < qopt->num_tc; i++)
> > -				fprintf(f, "%s ", sprint_rate(min_rate64[i], b1));
> > +				print_string(PRINT_ANY, NULL, "%s ", sprint_rate(min_rate64[i], b1=
));
>=20
> close_json_array?
>=20
> >  		}
> > =20
> >  		if (tb[TCA_MQPRIO_MAX_RATE64]) {
> > @@ -303,9 +309,9 @@ static int mqprio_print_opt(struct qdisc_util *qu, =
FILE *f, struct rtattr *opt)
> >  					return -1;
> >  				*(max++) =3D rta_getattr_u64(r);
> >  			}
> > -			fprintf(f, "	max_rate:");
> > +			open_json_array(PRINT_ANY, is_json_context() ? "max_rate" : "	max_r=
ate:");
> >  			for (i =3D 0; i < qopt->num_tc; i++)
> > -				fprintf(f, "%s ", sprint_rate(max_rate64[i], b1));
> > +				print_string(PRINT_ANY, NULL, "%s ", sprint_rate(max_rate64[i], b1=
));
> >  		}
>=20
> close_json_array?
>=20
> >  	}
> >  	return 0;
> >=20

Whops, fixed in v3, thanks.

--=20
Kind regards,
Luca Boccassi

--=-0uuWvC7MsFDOgsK3Lw94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/HyjcACgkQSylmgFB4
UWIgSAf/dWJNZbNDvNz8UX9SuCjU7i8bwNc3TGHwKn7t/tyjEFB8lofr2WOr1/3L
xpjxhewz1XZRNT6W6swB4laWcWikbLWiBW1cSEfIiSd7Xh0tKIzk2/atHtEyV9TT
BrViptd1xLO2rjWeglz5daRHQLhw5+LoPV3Dwehh1bn35grTLaj7aDUXFjtiFHGk
D6+QT24vMElbULeyz50HUViL7QXdgbxH7PG8UrfYKkBlDYiZS0uxw8VY1fb38d2N
ecHcO+8LZRRbPC0rU5dMqrK/Vf1Sbg0Hq1PMew0/gl42x3Gtkc++Vt8/XLWlTuM8
p59mIolzxoe+Nh4JP8XTdGb2donWpw==
=q/Mq
-----END PGP SIGNATURE-----

--=-0uuWvC7MsFDOgsK3Lw94--
