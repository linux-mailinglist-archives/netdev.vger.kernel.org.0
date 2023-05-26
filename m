Return-Path: <netdev+bounces-5795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A94712C40
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9595B1C210F7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2203C290F7;
	Fri, 26 May 2023 18:13:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B2615BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:13:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30564D3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685124812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YqrTfPHvU/4ASCCEEgua/Tzk3hxyao1PjTjuEQJVK4=;
	b=M6DIjZkHU1myZA3lDMvmFc7R/d8p0SMKTsd0YT5KEMogfP1lx5UfyJiJzkJV6Ujtn9AW0H
	D6gx9yPMHiJmeAeDdJD7aKr1U3JharDs6b/jslRn73z6LAfVVI3sYAUBlex0VBDNgb4jDK
	jDgS+Xi7geYxKlDq6AhcZrTURAoeUkY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-zlbzHE8HN8qmLaAwKmuvXw-1; Fri, 26 May 2023 14:13:28 -0400
X-MC-Unique: zlbzHE8HN8qmLaAwKmuvXw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f60eee2aacso992845e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685124808; x=1687716808;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7YqrTfPHvU/4ASCCEEgua/Tzk3hxyao1PjTjuEQJVK4=;
        b=UPXAe38HTG1/Rj3DFE+ImkvPo99PneQzfYpNQPr4tZyznYF5duYCtg8f/8jFWSW+EB
         YbEByzu2FIKHItlbxgUufnraMMSuvQYsfmm+Ry9tNqL0RLaegs75voptpb+xOYc6u1Vu
         /fYIfn2RFR6+c4CYjO6SJ4s7VU2FWHrNYOK3GnchGyf6jtdJLutS96AVd8JcoVcUmtPY
         nAZNYCHfskSN9cIRNEtZ6ZCACMud6aTxzyYwdB7tsqd3AuZ2ndqQKh4U/yFMM2HxMDB1
         YpSVA7GOMJSwyjifc7pLiw/FPDh+Nx0EpHnMGC4debHLZlBqi6a6mkzEb895IE79s4cp
         BoRw==
X-Gm-Message-State: AC+VfDz4bQFWNUb8wYBwftjLmuCgROwdc2eMRw/bCc9l0wB6otzjaK6e
	IUgRCqsMPKzd+XLOEupgx7gD43IXqNJvhPMzFPn6ZuFbd1Hpbl22D3lqnN/Oeae55sr4GXHH4pU
	FjU3gdJTufnQZVsX+
X-Received: by 2002:a05:600c:5027:b0:3f6:5dc:59f6 with SMTP id n39-20020a05600c502700b003f605dc59f6mr2386444wmr.4.1685124807843;
        Fri, 26 May 2023 11:13:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4lxnZT2eYP/BCIcXpgusjrXGQt4s7zCyCTGNaTw52E+GCphviq7a6Xr4+C6qEQuNaQ3OcQmQ==
X-Received: by 2002:a05:600c:5027:b0:3f6:5dc:59f6 with SMTP id n39-20020a05600c502700b003f605dc59f6mr2386427wmr.4.1685124807565;
        Fri, 26 May 2023 11:13:27 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-241-255.dyn.eolo.it. [146.241.241.255])
        by smtp.gmail.com with ESMTPSA id n11-20020a05600c294b00b003f6129d2e30sm9559138wmd.1.2023.05.26.11.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 11:13:27 -0700 (PDT)
Message-ID: <815ce4d97f6d673799ee7a94d90eeda58b1e51e4.camel@redhat.com>
Subject: Re: [PATCH] udp6: Fix race condition in udp6_sendmsg & connect
From: Paolo Abeni <pabeni@redhat.com>
To: =?UTF-8?Q?=D0=95=D1=84=D0=B0=D0=BD=D0=BE=D0=B2_?=
	=?UTF-8?Q?=D0=92=D0=BB=D0=B0=D0=B4=D0=B8=D1=81=D0=BB=D0=B0=D0=B2_?=
	=?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?=
	=?UTF-8?Q?=D0=B2=D0=B8=D1=87?=
	 <vefanov@ispras.ru>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, David Ahern
 <dsahern@kernel.org>,  Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
Date: Fri, 26 May 2023 20:13:25 +0200
In-Reply-To: <027d28a0-b31b-ab42-9eb6-2826c04c9364@ispras.ru>
References: <20230526150806.1457828-1-VEfanov@ispras.ru>
	 <27614af23cd7ae4433b909194062c553a6ae16ac.camel@redhat.com>
	 <027d28a0-b31b-ab42-9eb6-2826c04c9364@ispras.ru>
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

On Fri, 2023-05-26 at 18:58 +0300, =D0=95=D1=84=D0=B0=D0=BD=D0=BE=D0=B2 =D0=
=92=D0=BB=D0=B0=D0=B4=D0=B8=D1=81=D0=BB=D0=B0=D0=B2 =D0=90=D0=BB=D0=B5=D0=
=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2=D0=B8=D1=87
wrote:
> I don't think that we can just move sk_dst_set() call.
>=20
> I think we can destroy dst of sendmsg task in this case.

AFAICS ip6_sk_dst_lookup_flow tries to acquire a reference to the
cached dst. If the connect() clears the cache, decreasing the refcnt,
the counter of the dst in use by sendmsg() must still be non zero.

IMHO the problem you see is that sk_setup_caps() keeps using the dst
after transferring the ownership to the dst cache, which is illegal.
The suggested patch addressed that.

If I'm wrong your syzkaller repro will keep splatting. Please have just
have a spin, thanks.

Paolo


