Return-Path: <netdev+bounces-4686-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEE5F70DDFE
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AE651C20CF5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9FCD1EA9E;
	Tue, 23 May 2023 13:52:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978361EA9C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:52:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E4DC4
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684849931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aa37LYIe9fc9a8xNJZN5WTlpKioSxVllB69UNVs1uJs=;
	b=MGg81uVPmdfpCNeBNS/lpYho7/WuJ4p9rqGNd9OVVW3teI33ra0j/eIZnFUPaEAp79J1YV
	IfD9dexlLsim57iPRrTh8vw6775VYb6pm3odACe4S6NfFZ2jDV1d6iMh53crOsSNVttpFW
	6lkGukPEDUEOSq9jwED6dZBE5qL2kiQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-UdEWNN-0NZqqAynUkJ4uMQ-1; Tue, 23 May 2023 09:52:09 -0400
X-MC-Unique: UdEWNN-0NZqqAynUkJ4uMQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f60eee2aacso370655e9.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684849928; x=1687441928;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Aa37LYIe9fc9a8xNJZN5WTlpKioSxVllB69UNVs1uJs=;
        b=H6H2XGgEmrJn6nVQexkmP8h0SPYVh8cuMt2DhM/2FinYgCrooBZCfxVA6tU8CZg/xr
         79FaLWYqqaAf+jxCRdoJwZBvFf0HDu8NAi97Qcz1xtOGQeMLBWTDtCyfOK2E8jP9+/rb
         SW+SK4Ze7KY8MNFKh072bRwFyyUpKiASqtu8vtImeuYOH0jSONMuBkpADtsNdqJCWDZL
         tCkU2etizgDvOiJA+4FJ6j/dn3wmoRio73dDMNwOPrrBmdUzRtEK9MiPGk2NW37hVJ/c
         BM0FVNr1t/l7h4Z+Fch59fUgZdhd0osSm3lFKL5E6TDrNEEk8JyDOPVyKJY+uKXrtYn9
         GRHA==
X-Gm-Message-State: AC+VfDzIk5rb5bbqva50Yr6vg3i+Vslon60iMdkWnkfBb7sx1PNTC6jE
	F3NeCq1S4nbb/nSA/A9KLL7mh/WwFIO1lRNhZabAqppkLQUSK3vQqNmo+Lp4dsN7UQREqhP7Z9G
	RwnJ9CLbgf/I+s4EB
X-Received: by 2002:adf:e70d:0:b0:307:cf5e:28a9 with SMTP id c13-20020adfe70d000000b00307cf5e28a9mr8132258wrm.5.1684849928529;
        Tue, 23 May 2023 06:52:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6WWjgFxh4LIvmH+h+mwz/9cPNI4GeUcNat57HvB/Lj8bwDj2XuSMpyITH65G5O619UwHLXRg==
X-Received: by 2002:adf:e70d:0:b0:307:cf5e:28a9 with SMTP id c13-20020adfe70d000000b00307cf5e28a9mr8132251wrm.5.1684849928245;
        Tue, 23 May 2023 06:52:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-246-0.dyn.eolo.it. [146.241.246.0])
        by smtp.gmail.com with ESMTPSA id g12-20020adff40c000000b00307c46f4f08sm11290112wro.79.2023.05.23.06.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 06:52:07 -0700 (PDT)
Message-ID: <c025952ddc527f0b60b2c476bb30bd45e9863d41.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] net/tcp: optimise locking for blocking
 splice
From: Paolo Abeni <pabeni@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org, 
 edumazet@google.com, davem@davemloft.net, dsahern@kernel.org,
 kuba@kernel.org
Date: Tue, 23 May 2023 15:52:06 +0200
In-Reply-To: <a6838ca891ccff2c2407d9232ccd2a46fa3f8989.1684501922.git.asml.silence@gmail.com>
References: <cover.1684501922.git.asml.silence@gmail.com>
	 <a6838ca891ccff2c2407d9232ccd2a46fa3f8989.1684501922.git.asml.silence@gmail.com>
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

On Fri, 2023-05-19 at 14:33 +0100, Pavel Begunkov wrote:
> Even when tcp_splice_read() reads all it was asked for, for blocking
> sockets it'll release and immediately regrab the socket lock, loop
> around and break on the while check.
>=20
> Check tss.len right after we adjust it, and return if we're done.
> That saves us one release_sock(); lock_sock(); pair per successful
> blocking splice read.
>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/ipv4/tcp.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 4d6392c16b7a..bf7627f37e69 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -789,13 +789,15 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t=
 *ppos,
>  	 */
>  	if (unlikely(*ppos))
>  		return -ESPIPE;
> +	if (unlikely(!tss.len))
> +		return 0;
> =20
>  	ret =3D spliced =3D 0;
> =20
>  	lock_sock(sk);
> =20
>  	timeo =3D sock_rcvtimeo(sk, sock->file->f_flags & O_NONBLOCK);
> -	while (tss.len) {
> +	while (true) {
>  		ret =3D __tcp_splice_read(sk, &tss);
>  		if (ret < 0)
>  			break;
> @@ -835,10 +837,10 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t=
 *ppos,
>  			}
>  			continue;
>  		}
> -		tss.len -=3D ret;
>  		spliced +=3D ret;
> +		tss.len -=3D ret;

The patch LGTM. The only minor thing that I note is that the above
chunk is not needed. Perhaps avoiding unneeded delta could be worthy.

Cheers,

Paolo


