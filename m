Return-Path: <netdev+bounces-3560-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0FA4707DE2
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49512281164
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C13B11CBC;
	Thu, 18 May 2023 10:18:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A40DAD46
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:18:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C831FC3
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684405104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eIx29nfXbRPfWiffUOHQhU7PT7ohBhqyNGs4DB0Evwg=;
	b=NW94xZEqbkoCSY2MDo47KtUYyMmsWB/BP4csHC2TXL28I58crcoZrgkl3OIMhOUiPv79G9
	kPz6UrPz2wEzLACQNGFosYW9mj3tfxpY3APZ6b8mansGXQ36RD1Kh/NmUq3B4z+YLkkHTI
	L10bm5j5YGX40pDwMp/zfhBzEeMcdxk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-sIHTkWyvPr-NTPkKT4aRCw-1; Thu, 18 May 2023 06:18:23 -0400
X-MC-Unique: sIHTkWyvPr-NTPkKT4aRCw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-61b636b5f90so3599546d6.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:18:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684405102; x=1686997102;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eIx29nfXbRPfWiffUOHQhU7PT7ohBhqyNGs4DB0Evwg=;
        b=YxUdkRUelPR4XR2PKCBic0FlUSpplxTjUra+pXRnacZp1WP+JYa1jhLZSr3ZMOYmpA
         OPirt/AtQdVQRZf52cNls0baWVz0tl2DyrLmW46IancSzjBDO4yuLU20zx7uX0qb0veL
         e4HFMT1lofTmROkThftS6TFp0igAuUPuc6be9kpsJQhKOaz32+XLokNOy9tVxN13BN7t
         u5Di/haFyRfuqyxE8ZfVpfDz6kv/HnfKRGeZeUhloJrd8mUXo2x7Zze+9lA6AXmnZjXu
         i9gW6WDu+0/nPPFjk7gTF1aNQXqSb2NeyDlbrFDJ690vLPwejHAZW0oKlJXfJGNhP7/z
         TZZA==
X-Gm-Message-State: AC+VfDwwIpa6MvuVQi0+08+estZzMWKGgFj8KDdLIucLE1OsmH9lzEDP
	30SjLJ4q4ZFNUuPmKqkAvpCx32M/0z2P7iqXQGhN+J97k+MIhQ2HqISidf/wyOnfNYp7XLv6OKi
	7TXE/z+zmpHNcHw1rFOW5Bw1p
X-Received: by 2002:a05:6214:21a7:b0:616:73d9:b9d8 with SMTP id t7-20020a05621421a700b0061673d9b9d8mr10251791qvc.3.1684405102525;
        Thu, 18 May 2023 03:18:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6nN6x3ou94K5gGUMcf7XH2IE+qjty02wfmiS8FnYgqYPo+FzQ6YWzX8smeCzbnint3EmFdIg==
X-Received: by 2002:a05:6214:21a7:b0:616:73d9:b9d8 with SMTP id t7-20020a05621421a700b0061673d9b9d8mr10251768qvc.3.1684405102221;
        Thu, 18 May 2023 03:18:22 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-175.dyn.eolo.it. [146.241.239.175])
        by smtp.gmail.com with ESMTPSA id ml7-20020a056214584700b0061a0f7fb340sm426736qvb.6.2023.05.18.03.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 03:18:21 -0700 (PDT)
Message-ID: <5a49aee53de52cf3c24246ccf18391aabc0c5e50.camel@redhat.com>
Subject: Re: [PATCH net] sctp: fix an issue that plpmtu can never go to
 complete state
From: Paolo Abeni <pabeni@redhat.com>
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, 
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet
 <edumazet@google.com>,  Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 18 May 2023 12:18:18 +0200
In-Reply-To: <e72cc6c6ac5699659bb550fe04ec215ba393dd48.1684286522.git.lucien.xin@gmail.com>
References: 
	<e72cc6c6ac5699659bb550fe04ec215ba393dd48.1684286522.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-16 at 21:22 -0400, Xin Long wrote:
> When doing plpmtu probe, the probe size is growing every time when it
> receives the ACK during the Search state until the probe fails. When
> the failure occurs, pl.probe_high is set and it goes to the Complete
> state.
>=20
> However, if the link pmtu is huge, like 65535 in loopback_dev, the probe
> eventually keeps using SCTP_MAX_PLPMTU as the probe size and never fails.
> Because of that, pl.probe_high can not be set, and the plpmtu probe can
> never go to the Complete state.
>=20
> Fix it by setting pl.probe_high to SCTP_MAX_PLPMTU when the probe size
> grows to SCTP_MAX_PLPMTU in sctp_transport_pl_recv(). Also, increase
> the probe size only when the next is less than SCTP_MAX_PLPMTU.
>=20
> Fixes: b87641aff9e7 ("sctp: do state transition when a probe succeeds on =
HB ACK recv path")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/transport.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index 2f66a2006517..b0ccfaa4c1d1 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -324,9 +324,11 @@ bool sctp_transport_pl_recv(struct sctp_transport *t=
)
>  		t->pl.probe_size +=3D SCTP_PL_BIG_STEP;
>  	} else if (t->pl.state =3D=3D SCTP_PL_SEARCH) {
>  		if (!t->pl.probe_high) {
> -			t->pl.probe_size =3D min(t->pl.probe_size + SCTP_PL_BIG_STEP,
> -					       SCTP_MAX_PLPMTU);
> -			return false;
> +			if (t->pl.probe_size + SCTP_PL_BIG_STEP < SCTP_MAX_PLPMTU) {
> +				t->pl.probe_size +=3D SCTP_PL_BIG_STEP;
> +				return false;
> +			}
> +			t->pl.probe_high =3D SCTP_MAX_PLPMTU;

It looks like this way the probed mtu can't reach SCTP_MAX_PLPMTU
anymore, while it was possible before.

What about something alike:

		if (!t->pl.probe_high) {
			if (t->pl.probe_size < SCTP_MAX_PLPMTU) {
				t->pl.probe_size =3D min(t->pl.probe_size + SCTP_PL_BIG_STEP,
						       SCTP_MAX_PLPMTU);
				return false;
			}
			t->pl.probe_high =3D SCTP_MAX_PLPMTU;
>  		}
>  		t->pl.probe_size +=3D SCTP_PL_MIN_STEP;
>  		if (t->pl.probe_size >=3D t->pl.probe_high) {
> @@ -341,7 +343,8 @@ bool sctp_transport_pl_recv(struct sctp_transport *t)
>  	} else if (t->pl.state =3D=3D SCTP_PL_COMPLETE) {
>  		/* Raise probe_size again after 30 * interval in Search Complete */
>  		t->pl.state =3D SCTP_PL_SEARCH; /* Search Complete -> Search */
> -		t->pl.probe_size +=3D SCTP_PL_MIN_STEP;
> +		if (t->pl.probe_size + SCTP_PL_MIN_STEP < SCTP_MAX_PLPMTU)
> +			t->pl.probe_size +=3D SCTP_PL_MIN_STEP;

In a similar way, should the above check be:

		if (t->pl.probe_size + SCTP_PL_MIN_STEP <=3D SCTP_MAX_PLPMTU)
			t->pl.probe_size +=3D SCTP_PL_MIN_STEP;

or simply:
		t->pl.probe_size =3D min(t->pl.probe_size + SCTP_PL_MIN_STEP, SCTP_MAX_PL=
PMTU)
>=20
Cheers,

Paolo


