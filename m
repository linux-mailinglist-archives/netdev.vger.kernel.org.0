Return-Path: <netdev+bounces-1191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9100A6FC8C7
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:22:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C5C21C2091C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2607A19522;
	Tue,  9 May 2023 14:22:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AC08BE3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:22:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982B930D3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683642127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kE6r/VIoNrxvbBfUUuCavzaZtEzU3MN6vFpxlb4Xa9A=;
	b=d1p2dsD+YqlgN5eg+9PWg4aJysJ4dLpb/QsKqz6pubwIwvmJRq3LOc5xwCLfl11LZT1gtc
	JjV1ca/pgesHqn3uiCqFmGM+a1w2TWD3ymP3T81KkymxEwbRwFbYCNJJfQAxBGWxsRNEk7
	bEHRAaeLdcynM1CXBr8fg6N66AfuujM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-FOJ2xBv5P3u6r2SUVXUR9g-1; Tue, 09 May 2023 10:22:06 -0400
X-MC-Unique: FOJ2xBv5P3u6r2SUVXUR9g-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-61b5f341341so8371616d6.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 07:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683642125; x=1686234125;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kE6r/VIoNrxvbBfUUuCavzaZtEzU3MN6vFpxlb4Xa9A=;
        b=E4mwlGI784i1iE4JjYC6lRd2LTrzntRp7NnOnym22BgH6T7jfL5JOie/AIRtK8lenq
         paaGySiTfCySa8Vqn5rSWNVK088DubDdKZZmQs21dwkOQRQo2Guxq+ordAlzsgsIPeQz
         CXYtcyo65R32PjLB0rclDJYwV2PElDdAy4m85nU2j9rGJffvJhX28ynjlnZujkqOMNzW
         6T4/Viyh/pPX42lpZYcMyZsc5a0kzmHoANFCrzSlIXxd+10aaNkKR5tIKT9bBOpE0Rod
         7sat1NBnQmUqcWc5QvM4hpLCuFLQi1v0luuuT/8vAsaGAjf/0knOvtjqRiE2z8BpgKmf
         qmTg==
X-Gm-Message-State: AC+VfDzTZyqwUgoTQp/kVKUeOKN/7rM4WSUAyAcbY713CP858FStRKmC
	j5YExk/cn/jKJArfBMZpZyuZcC9VJ0x03xRKOL1jNoKhq6mRgv9hnodBAJ9ZQWfFBe9Ma38ytED
	/vlVXYSuXqrtyv3/A
X-Received: by 2002:a05:6214:528d:b0:621:7d4:e05b with SMTP id kj13-20020a056214528d00b0062107d4e05bmr15514458qvb.0.1683642125320;
        Tue, 09 May 2023 07:22:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7+TTsuUg8X5U5mFyy2BPa8SWOcHMt5SSsWB5gIku4NnZOLT0QRo0UFnsILCG8b3NSu9KojCg==
X-Received: by 2002:a05:6214:528d:b0:621:7d4:e05b with SMTP id kj13-20020a056214528d00b0062107d4e05bmr15514427qvb.0.1683642124993;
        Tue, 09 May 2023 07:22:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-255-65.dyn.eolo.it. [146.241.255.65])
        by smtp.gmail.com with ESMTPSA id pr25-20020a056214141900b0061662aefa27sm780484qvb.128.2023.05.09.07.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 07:22:04 -0700 (PDT)
Message-ID: <2e1fb95f613b6991b173d7947334927b22e49242.camel@redhat.com>
Subject: Re: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
From: Paolo Abeni <pabeni@redhat.com>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Leon Romanovsky <leon@kernel.org>, Chuck Lever <cel@kernel.org>, 
 kernel-tls-handshake <kernel-tls-handshake@lists.linux.dev>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
 "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>
Date: Tue, 09 May 2023 16:22:01 +0200
In-Reply-To: <CD7ADFAB-137C-407C-93D4-4AF314FE0E52@oracle.com>
References: 
	<168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
	 <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
	 <20230507082556.GG525452@unreal>
	 <80ebc863cd77158a964698f7a887b15dc88e4631.camel@redhat.com>
	 <CD7ADFAB-137C-407C-93D4-4AF314FE0E52@oracle.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-09 at 13:59 +0000, Chuck Lever III wrote:
>=20
> > On May 9, 2023, at 12:04 AM, Paolo Abeni <pabeni@redhat.com> wrote:
> >=20
> > On Sun, 2023-05-07 at 11:25 +0300, Leon Romanovsky wrote:
> > > On Fri, May 05, 2023 at 08:46:01PM -0400, Chuck Lever wrote:
> > > > From: Chuck Lever <chuck.lever@oracle.com>
> > > >=20
> > > > If get_unused_fd_flags() fails, we ended up calling fput(sock->file=
)
> > > > twice.
> > > >=20
> > > > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > > > Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for h=
andling handshake requests")
> > > > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > > > ---
> > > > net/handshake/netlink.c |    4 +---
> > > > 1 file changed, 1 insertion(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> > > > index 7ec8a76c3c8a..032d96152e2f 100644
> > > > --- a/net/handshake/netlink.c
> > > > +++ b/net/handshake/netlink.c
> > > > @@ -101,10 +101,8 @@ static int handshake_dup(struct socket *sock)
> > > >=20
> > > > file =3D get_file(sock->file);
> > > > newfd =3D get_unused_fd_flags(O_CLOEXEC);
> > > > - if (newfd < 0) {
> > > > - fput(file);
> > > > + if (newfd < 0)
> > > > return newfd;
> > >=20
> > > IMHO, the better way to fix it is to change handshake_nl_accept_doit(=
)
> > > do not call to fput(sock->file) in error case. It is not right thing
> > > to have a call to handshake_dup() and rely on elevated get_file()
> > > for failure too as it will be problematic for future extension of
> > > handshake_dup().
> >=20
> > I agree with the above: I think a failing helper should leave the
> > larger scope status unmodified. In this case a failing handshake_dup()
> > should not touch file refcount, and handshake_nl_accept_doit() should
> > be modified accordingly, something alike:
> >=20
> > ---
> > diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> > index e865fcf68433..8897a17189ad 100644
> > --- a/net/handshake/netlink.c
> > +++ b/net/handshake/netlink.c
> > @@ -138,14 +138,15 @@ int handshake_nl_accept_doit(struct sk_buff *skb,=
 struct genl_info *info)
> > }
> > err =3D req->hr_proto->hp_accept(req, info, fd);
> > if (err)
> > - goto out_complete;
> > + goto out_put;
> >=20
> > trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
> > return 0;
> >=20
> > +out_put:
> > + fput(sock->file);
> > out_complete:
> > handshake_complete(req, -EIO, NULL);
> > - fput(sock->file);
> > out_status:
> > trace_handshake_cmd_accept_err(net, req, NULL, err);
> > return err;
>=20
> I'm happy to accommodate these changes, but it's not clear to me
> whether you want this hunk applied /in addition to/ my fix or
> /instead of/.

It's above (completely untested!) chunk is intended to be a replace for
patch 2/6

> > ---
> >=20
> > Somewhat related: handshake_nl_done_doit() releases the file refcount
> > even if the req lookup fails.
>=20
> That's because sockfd_lookup() increments the file ref count.

Ooops, I missed that.

Then in the successful path handshake_nl_done_doit() should call
fput() twice ?!? 1 for the reference acquired by sockfd_lookup() and 1
for the reference owned by  'req' ?!? Otherwise a ref will be leaked.

> > If that is caused by a concurrent
> > req_cancel - not sure if possible at all, possibly syzkaller could
> > guess if instructed about the API - such refcount will underflow, as it
> > is rightfully decremented by req_cancel, too.
>=20
> More likely, req_cancel might take the file ref count to zero
> before sockfd_lookup can increment it, resulting in a UAF?
>=20
> Let me think about this.

I now think this race is not possible, but I now fear the refcount leak
mentioned above.

Cheers,

Paolo


