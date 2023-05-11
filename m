Return-Path: <netdev+bounces-1693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFEEB6FED67
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8EC71C20ECD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7121B908;
	Thu, 11 May 2023 08:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9B21B8E2
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:03:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6DB2681
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683792226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/MyjpKaMMPMRovA00MxQ59INfmhjbXcjBdSyZMDY7ug=;
	b=fAufkbRITDpgSLHmlsJlXyeSIgHrx5bIDz8oSA4fw4SXYjrPyFtHNjQsn0JQHaVBVctSlN
	krDfopBwVya6x1MluIgvEJGrzLOgraNaDpp5OwkcayeDZBgMd5e1IP/1cAnjx3mFLKR+dh
	Ho5igS1WwRqvagyOEosEQe9PPsh+BxA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-gdUs953TOp2E5i1cUWAznA-1; Thu, 11 May 2023 04:03:45 -0400
X-MC-Unique: gdUs953TOp2E5i1cUWAznA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-61a3c7657aeso10283286d6.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683792225; x=1686384225;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/MyjpKaMMPMRovA00MxQ59INfmhjbXcjBdSyZMDY7ug=;
        b=FPD6MK3GcpdcT+/X+Hy9AIdxia0qS0F/meeTIa3664IPd9RYJJ6Ndj5WtzqVBcFDJU
         7Ca4sxt2CoATCNMpeVYKNxZXq5VHi2h70aK8pIf6UIeAhg1SAbH0++LMIPAoGbgJJBqX
         zw+b97DbXqPqw9drfOVlu75RmHhsB2/7dVvv/ZtjB31BVcdkamjG60BmzvrED9Gg4tgm
         FzsUq8qY9zP0S3dQQEtBjpuxYGThbyAl5f3EZQGj8eu7iBXQuOEuq9MF7w3mf2O01rc+
         mi0vh5xl7Sqv8UdReiXWHHxUUSwd5sq7TmRuzqmx+PsYydnLsyO079NQNXuDY6xToyQE
         JT5A==
X-Gm-Message-State: AC+VfDxbB9EfovdksI3+gXk77m73Mtjj3W78/5fYAnM7IJqg0+A3pGAO
	oTQOzNIVVdz9pQflSdhEHPx3g6UAEFxRSU3nWlD6jb6Levz6vIpDgJB/WainVAhAwG2XLccyFwO
	7ouKGfXkkou10Wg1/soyymvnz
X-Received: by 2002:a05:6214:5297:b0:616:870c:96b8 with SMTP id kj23-20020a056214529700b00616870c96b8mr29657253qvb.3.1683792224837;
        Thu, 11 May 2023 01:03:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5vLTxdpZftCDEyGD3Q8fceA4zi8n+/x/TzYE0gcAQQXu1LcJqBnVQOMl1iPqFrkjK1s2xW2g==
X-Received: by 2002:a05:6214:5297:b0:616:870c:96b8 with SMTP id kj23-20020a056214529700b00616870c96b8mr29657237qvb.3.1683792224581;
        Thu, 11 May 2023 01:03:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-149.dyn.eolo.it. [146.241.243.149])
        by smtp.gmail.com with ESMTPSA id s17-20020a0cdc11000000b005ef42af7eb7sm2107099qvk.25.2023.05.11.01.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 01:03:44 -0700 (PDT)
Message-ID: <9e16ad625a6ba27c2e491d147dbed2c22a8b378b.camel@redhat.com>
Subject: Re: [PATCH 1/3] net: set FMODE_NOWAIT for sockets
From: Paolo Abeni <pabeni@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org
Date: Thu, 11 May 2023 10:03:40 +0200
In-Reply-To: <20230509151910.183637-2-axboe@kernel.dk>
References: <20230509151910.183637-1-axboe@kernel.dk>
	 <20230509151910.183637-2-axboe@kernel.dk>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-09 at 09:19 -0600, Jens Axboe wrote:
> The socket read/write functions deal with O_NONBLOCK and IOCB_NOWAIT
> just fine, so we can flag them as being FMODE_NOWAIT compliant. With
> this, we can remove socket special casing in io_uring when checking
> if a file type is sane for nonblocking IO, and it's also the defined
> way to flag file types as such in the kernel.
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  net/socket.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/socket.c b/net/socket.c
> index a7b4b37d86df..6861dbbfadb6 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -471,6 +471,7 @@ struct file *sock_alloc_file(struct socket *sock, int=
 flags, const char *dname)
>  		return file;
>  	}
> =20
> +	file->f_mode |=3D FMODE_NOWAIT;
>  	sock->file =3D file;
>  	file->private_data =3D sock;
>  	stream_open(SOCK_INODE(sock), file);

The patch looks sane to me:

Reviewed-by: Paolo Abeni <pabeni@redhat.com>

I understand the intention is merging patch via the io_uring tree? If
so, no objections on my side: hopefully it should not cause any
conflicts with the netdev tree.

Thanks,

Paolo


