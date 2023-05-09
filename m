Return-Path: <netdev+bounces-1043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C8E6FBFE3
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 233181C20B06
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7323FF9;
	Tue,  9 May 2023 07:04:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567C43D61
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:04:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75826E81
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683615890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g+PavQnsDrQ3Ziaclav5kottbUNlilAfnc2SUG1Hbbs=;
	b=MAPsTjP7C/rOYpusV+qKjLomJaZgBWhPMPFbdn+yG46ly5xqHgb/hH52dDLktYlO5ZfZGh
	3vyOrBJ14EpouDcUyLGoTh5FSEwqW9rBfZNWDMCja3qWEUo6Jp7PqPMS+YDupbszeW2e16
	4BT4zV1eCdQ8yk7ZP6aNrCTEzybMJ4A=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-dyoiA7cdMYGJvXugIF4d5A-1; Tue, 09 May 2023 03:04:48 -0400
X-MC-Unique: dyoiA7cdMYGJvXugIF4d5A-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-5ef4d54d84cso10170426d6.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 00:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683615888; x=1686207888;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+PavQnsDrQ3Ziaclav5kottbUNlilAfnc2SUG1Hbbs=;
        b=eKjZeXlcjKAMhQaKU0zuZh0Qs19+Balz8sw9tIEJQgJQb3hbed5tR9ycAk0mqzlkdJ
         xVgxDV8hxm1KiYFAhi7SSoUCTl2C/7PGZhPyiqqR4syqTj2G3rujF2CvbHDvh4BA6bGf
         ydksW60ITvnDi1p/VSQYybwp/zbzi1bGezcQ8QWHPj4TUAwdvyCjdmcqdxjmbFWJ4cUc
         EeLjhuvVpggEIJiviu7MZFMeKjR/e4gkoJeL4oUviGvjle9yp++0f/RIzjTTxMGFbaEe
         IKvBljO3otJ5306hwXLe0aNa0jfYovCjSGvVJKM6CNjf+LuAbTDZCITtEwhmveZwVglc
         Cd5w==
X-Gm-Message-State: AC+VfDwF0jzqsPZfOUnbQV8HqiJuA6xIt7HcF8J8pci1uNWcXhMHiDdH
	nj6aYkNBGEwm2TBaE6OjS/dzO1oz6ntDyIy1QFWIfuEdWIDOUYBI9eAhRsetE5H25j16y9HMj40
	oZ87LrpGBDUGCPrvvIiZkg0Pl
X-Received: by 2002:a05:6214:5290:b0:61b:7115:55a9 with SMTP id kj16-20020a056214529000b0061b711555a9mr17505923qvb.0.1683615888270;
        Tue, 09 May 2023 00:04:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7xcooT/xK5gavWdwem56NjI42j7fRg+aB9WVumPKuESVRQojNiPJ/4T05I173D0VVw7nSfzA==
X-Received: by 2002:a05:6214:5290:b0:61b:7115:55a9 with SMTP id kj16-20020a056214529000b0061b711555a9mr17505911qvb.0.1683615887961;
        Tue, 09 May 2023 00:04:47 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-255-65.dyn.eolo.it. [146.241.255.65])
        by smtp.gmail.com with ESMTPSA id g14-20020a0ce4ce000000b005ef608dc422sm572876qvm.41.2023.05.09.00.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 00:04:47 -0700 (PDT)
Message-ID: <80ebc863cd77158a964698f7a887b15dc88e4631.camel@redhat.com>
Subject: Re: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
From: Paolo Abeni <pabeni@redhat.com>
To: Leon Romanovsky <leon@kernel.org>, Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org, 
	dan.carpenter@linaro.org
Date: Tue, 09 May 2023 09:04:39 +0200
In-Reply-To: <20230507082556.GG525452@unreal>
References: 
	<168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
	 <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
	 <20230507082556.GG525452@unreal>
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

On Sun, 2023-05-07 at 11:25 +0300, Leon Romanovsky wrote:
> On Fri, May 05, 2023 at 08:46:01PM -0400, Chuck Lever wrote:
> > From: Chuck Lever <chuck.lever@oracle.com>
> >=20
> > If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
> > twice.
> >=20
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handl=
ing handshake requests")
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > ---
> >  net/handshake/netlink.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >=20
> > diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> > index 7ec8a76c3c8a..032d96152e2f 100644
> > --- a/net/handshake/netlink.c
> > +++ b/net/handshake/netlink.c
> > @@ -101,10 +101,8 @@ static int handshake_dup(struct socket *sock)
> > =20
> >  	file =3D get_file(sock->file);
> >  	newfd =3D get_unused_fd_flags(O_CLOEXEC);
> > -	if (newfd < 0) {
> > -		fput(file);
> > +	if (newfd < 0)
> >  		return newfd;
>=20
> IMHO, the better way to fix it is to change handshake_nl_accept_doit()
> do not call to fput(sock->file) in error case. It is not right thing
> to have a call to handshake_dup() and rely on elevated get_file()
> for failure too as it will be problematic for future extension of
> handshake_dup().

I agree with the above: I think a failing helper should leave the
larger scope status unmodified. In this case a failing handshake_dup()
should not touch file refcount, and handshake_nl_accept_doit() should
be modified accordingly, something alike:

---
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index e865fcf68433..8897a17189ad 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -138,14 +138,15 @@ int handshake_nl_accept_doit(struct sk_buff *skb, str=
uct genl_info *info)
 	}
 	err =3D req->hr_proto->hp_accept(req, info, fd);
 	if (err)
-		goto out_complete;
+		goto out_put;
=20
 	trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
 	return 0;
=20
+out_put:
+	fput(sock->file);
 out_complete:
 	handshake_complete(req, -EIO, NULL);
-	fput(sock->file);
 out_status:
 	trace_handshake_cmd_accept_err(net, req, NULL, err);
 	return err;
---

Somewhat related: handshake_nl_done_doit() releases the file refcount
even if the req lookup fails. If that is caused by a concurrent
req_cancel - not sure if possible at all, possibly syzkaller could
guess if instructed about the API - such refcount will underflow, as it
is rightfully decremented by req_cancel, too.

I think it should be safer adding a chunk like:

---
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index e865fcf68433..3e3e849f302a 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -172,7 +173,6 @@ int handshake_nl_done_doit(struct sk_buff *skb, struct =
genl_info *info)
 	req =3D handshake_req_hash_lookup(sock->sk);
 	if (!req) {
 		err =3D -EBUSY;
-		fput(sock->file);
 		goto out_status;
 	}
---

Possibly explicitly documenting the used ownership rules for the file
refcount in the relevant functions could help with future maintenance.

Finally it's not clear to me if we agreed to a target tree or not ;) I
see no replies so my suggestion.

Thanks!

Paolo


