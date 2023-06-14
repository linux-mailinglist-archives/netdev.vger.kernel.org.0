Return-Path: <netdev+bounces-10658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 796FD72F98C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB8531C208EA
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ADD611A;
	Wed, 14 Jun 2023 09:44:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845825693
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:44:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFF31BF9
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686735855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QiTpKaNcHheuAqTHACBRzRCRFnuRr4rkUQEm8xv8v/4=;
	b=av17rmKcXSxkmJtFmCNLyf4/p3xs0tlEo6MjIo519F6KsSy4BUpXpCpJmvh+IFm6ntSXQO
	5D/0U69SkYy+T/OxKTg1OsLbTuwi2wTcmid9DLW/FwOxapCzJ7Ygd2dzp/zgbtAYCtJHQ1
	q2wcCBWT9TFevzp7dlRqUMDXq/I1b7g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-N4CA7PCdNIWHupjsb1J29g-1; Wed, 14 Jun 2023 05:44:13 -0400
X-MC-Unique: N4CA7PCdNIWHupjsb1J29g-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3110acc0042so78607f8f.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686735852; x=1689327852;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QiTpKaNcHheuAqTHACBRzRCRFnuRr4rkUQEm8xv8v/4=;
        b=QAHbgNXmI7PUXdQGvg3TFYUjpF39x1wjLwKkyuN27nTuXAN+Rkb4DraY7XIJIlGXgp
         uTcHFhh/IkVVG3Wf5RAvrWG8YULlaL0LRoOh4PO1295FN90QxuJKPl/J9w3uei6jleAs
         DnFf73wCgThWbZddDhq0zDtsXs/9xFKdJMdn52bxzO+1SdN1z1xZqWiEIsKgWJimj5C1
         DfJwkABkLRoMzpbdUPVdU0DFKbOA3j/1gJ3oD3Xnx92zRoGuMVeTo1/8STrWts5HhD8m
         eQJjDseiHqTp8scVHy0HBl1n3dkug6rc1XofN05WM2JcQwP0hW89SPSMnTwafpm0ooXI
         sEmQ==
X-Gm-Message-State: AC+VfDyEt3KkoAK1snYwXiZtYo+021yaEKi2Gf84kl2YiD/UJ5jiPYnz
	VzIhJj2l6HAVRRzhpuuGUy6kpEAmWOiy6OC5QAdw5WHa0AgtaQoBKauABpaUA55Fa6L0ThWXcJF
	JothfWwqKUSy/oNZW
X-Received: by 2002:adf:fd84:0:b0:2c7:1c72:699f with SMTP id d4-20020adffd84000000b002c71c72699fmr10931933wrr.4.1686735852570;
        Wed, 14 Jun 2023 02:44:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6baYkWtu4XCSjrdY+uCwNL6ExilJb4E+AbjWjAaRwYvFRzKEYN1SVr37wObHtahf29dJp9pA==
X-Received: by 2002:adf:fd84:0:b0:2c7:1c72:699f with SMTP id d4-20020adffd84000000b002c71c72699fmr10931922wrr.4.1686735852275;
        Wed, 14 Jun 2023 02:44:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-67.dyn.eolo.it. [146.241.244.67])
        by smtp.gmail.com with ESMTPSA id y22-20020a7bcd96000000b003f7f2a1484csm16980813wmj.5.2023.06.14.02.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:44:11 -0700 (PDT)
Message-ID: <f50ad11eb5ca3cb777e7150ad6a8347e575f1667.camel@redhat.com>
Subject: Re: [PATCH] net: hsr: Disable promiscuous mode in offload mode
From: Paolo Abeni <pabeni@redhat.com>
To: Ravi Gunasekaran <r-gunasekaran@ti.com>, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, bigeasy@linutronix.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rogerq@kernel.org
Date: Wed, 14 Jun 2023 11:44:10 +0200
In-Reply-To: <dffbf0474b1352f1eac63125a973c8f8cd7b3e8d.camel@redhat.com>
References: <20230612093933.13267-1-r-gunasekaran@ti.com>
	 <dffbf0474b1352f1eac63125a973c8f8cd7b3e8d.camel@redhat.com>
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
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-06-14 at 11:42 +0200, Paolo Abeni wrote:
> On Mon, 2023-06-12 at 15:09 +0530, Ravi Gunasekaran wrote:
> > When port-to-port forwarding for interfaces in HSR node is enabled,
> > disable promiscuous mode since L2 frame forward happens at the
> > offloaded hardware.
> >=20
> > Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
> > ---
> >  net/hsr/hsr_device.c |  5 +++++
> >  net/hsr/hsr_main.h   |  1 +
> >  net/hsr/hsr_slave.c  | 15 +++++++++++----
> >  3 files changed, 17 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> > index 5a236aae2366..306f942c3b28 100644
> > --- a/net/hsr/hsr_device.c
> > +++ b/net/hsr/hsr_device.c
> > @@ -531,6 +531,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, s=
truct net_device *slave[2],
> >  	if (res)
> >  		goto err_add_master;
> > =20
> > +	/* HSR forwarding offload supported in lower device? */
> > +	if ((slave[0]->features & NETIF_F_HW_HSR_FWD) &&
> > +	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
> > +		hsr->fwd_offloaded =3D true;
> > +
> >  	res =3D register_netdevice(hsr_dev);
> >  	if (res)
> >  		goto err_unregister;
> > diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> > index 5584c80a5c79..0225fabbe6d1 100644
> > --- a/net/hsr/hsr_main.h
> > +++ b/net/hsr/hsr_main.h
> > @@ -195,6 +195,7 @@ struct hsr_priv {
> >  	struct hsr_self_node	__rcu *self_node;	/* MACs of slaves */
> >  	struct timer_list	announce_timer;	/* Supervision frame dispatch */
> >  	struct timer_list	prune_timer;
> > +	unsigned int            fwd_offloaded : 1; /* Forwarding offloaded to=
 HW */
>=20
> Please use plain 'bool' instead.
>=20
> Also there is an hole in 'struct hsr_priv' just after 'net_id', you
> could consider moving this new field there.

Oops, I almost forgot! Please include the target tree (net-next in this
case) in the subj prefix on your next submission.

Thanks,

Paolo


