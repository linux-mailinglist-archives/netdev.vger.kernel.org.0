Return-Path: <netdev+bounces-6323-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA9D715B43
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14D9E2810D8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6A7174D4;
	Tue, 30 May 2023 10:16:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47043171DF
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:16:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7965219C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685441774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBi0Aj2fRSbGyE/2z5Smhv5UQ9L2C2jnz9dmYBZ4RJA=;
	b=axeCT2LOWgziyWMFpdl7oCVICl29/lC6ogO8LYyern7VDswtHd51RN6JlK4OtMnsAa2Bgv
	1jseM+UquEaOiyyJJZter5G4v+R84duBum+vuoQkymq89umgJqFa7GH5mlveMxxZ2LaTge
	2Iek02W/ZmubtPR0tJg/1qWXWL1RmSU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-YYIgSw-VNaKPwBvle-bH2g-1; Tue, 30 May 2023 06:16:13 -0400
X-MC-Unique: YYIgSw-VNaKPwBvle-bH2g-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30ae547a7ddso27912f8f.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685441772; x=1688033772;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NBi0Aj2fRSbGyE/2z5Smhv5UQ9L2C2jnz9dmYBZ4RJA=;
        b=VbIvE9LDuZMtEwzwyk8b5wlic4yso9HEawn8XnC5aWGgsMLDdsLFf+yk9bW8fmv3J+
         MFCy4S0qfiqN7P9hMvGuEpfN3FEDdD8v9UCoYAikGhYJ2Ka4fMOdGc+6vX+G4T8H5ckp
         qhAVS6UtsxKNjs0suW9gJ8h965IeJWpO06fhq2AhEWS0nVhNszpO9o2qpxdZFGtNlIDG
         sOrtR1CJKWRLqqOXOAiypamL54o9vDzvHq9vVn7LbRFpbAKviY40D+95NZIymt5Ca/0A
         3CGF6TKQ0y1xZv/QQ2qikbF4jYpXb7Yq7QhHZbK3eXxD34xovu+A78huTrHHZTSWh95f
         nZuA==
X-Gm-Message-State: AC+VfDx98JHdOPr9n7zAhZw733ifB+udt9WfZ+vU21W1pW8V3++YYlVs
	rKjGsQvNSQZZTtPXT0jmuUYJPq6bxTVIJEKhDTZUpjU5Vp3wTViucq75HfIULWkkkJWQP0X8ygx
	9QLlH0TZeNKNDGjoy
X-Received: by 2002:a5d:5144:0:b0:2f8:15d8:e627 with SMTP id u4-20020a5d5144000000b002f815d8e627mr966225wrt.7.1685441772338;
        Tue, 30 May 2023 03:16:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4C2Lzb6fc39LFwghuO1jclX6EszieEA7g4PYvRKdsiTvPkip+s0WxEKZXNuv5H2bMLt8fWWA==
X-Received: by 2002:a5d:5144:0:b0:2f8:15d8:e627 with SMTP id u4-20020a5d5144000000b002f815d8e627mr966210wrt.7.1685441772076;
        Tue, 30 May 2023 03:16:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-248-97.dyn.eolo.it. [146.241.248.97])
        by smtp.gmail.com with ESMTPSA id m4-20020a5d4a04000000b003079c402762sm2790248wrq.19.2023.05.30.03.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 03:16:11 -0700 (PDT)
Message-ID: <9cf98c8ae48c99850a0a25ae7919420ce5dfa7b4.camel@redhat.com>
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in
 mq_attach
From: Paolo Abeni <pabeni@redhat.com>
To: Peilin Ye <yepeilin.cs@gmail.com>, Jamal Hadi Salim <jhs@mojatatu.com>
Cc: shaozhengchao <shaozhengchao@huawei.com>, netdev@vger.kernel.org, 
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, weiyongjun1@huawei.com, 
	yuehaibing@huawei.com, wanghai38@huawei.com, peilin.ye@bytedance.com, 
	cong.wang@bytedance.com
Date: Tue, 30 May 2023 12:16:10 +0200
In-Reply-To: <ZHVAlCtzFeJrwKvc@C02FL77VMD6R.googleapis.com>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
	 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
	 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
	 <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
	 <CAM0EoMk+zO0RcnJ4Uie7jU+MNdFz7Mc37W223jVZip62QMRdzQ@mail.gmail.com>
	 <ZHVAlCtzFeJrwKvc@C02FL77VMD6R.googleapis.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-29 at 17:17 -0700, Peilin Ye wrote:
> On Mon, May 29, 2023 at 09:53:28AM -0400, Jamal Hadi Salim wrote:
> > On Mon, May 29, 2023 at 4:59=E2=80=AFAM Peilin Ye <yepeilin.cs@gmail.co=
m> wrote:
> > > Ack, they are different: patch [4/6] prevents ingress (clsact) Qdiscs
> > > from being regrafted (to elsewhere), and Zhengchao's patch prevents o=
ther
> > > Qdiscs from being regrafted to ffff:fff1.
> >=20
> > Ok, at first glance it was not obvious.
> > Do we catch all combinations? for egress (0xffffffff) allowed minor is
> > 0xfff3 (clsact::) and 0xffff. For ingress (0xfffffff1) allowed minor
> > is 0xfff1 and 0xfff2(clsact).
>=20
> ffff:fff1 is special in tc_modify_qdisc(); if minor isn't fff1,
> tc_modify_qdisc() thinks user wants to graft a Qdisc under existing ingre=
ss
> or clsact Qdisc:
>=20
> 	if (clid !=3D TC_H_INGRESS) {	/* ffff:fff1 */
> 		p =3D qdisc_lookup(dev, TC_H_MAJ(clid));
> 		if (!p) {
> 			NL_SET_ERR_MSG(extack, "Failed to find specified qdisc");
> 			return -ENOENT;
> 		}
> 		q =3D qdisc_leaf(p, clid);
> 	} else if (dev_ingress_queue_create(dev)) {
> 		q =3D dev_ingress_queue(dev)->qdisc_sleeping;
> 	}
>=20
> This will go to the "parent !=3D NULL" path in qdisc_graft(), and
> sch_{ingress,clsact} doesn't implement cl_ops->graft(), so -EOPNOTSUPP wi=
ll
> be returned.
>=20
> In short, yes, I think ffff:fff1 is the only case should be fixed.
>=20
> By the way I just noticed that currently it is possible to create a e.g.
> HTB class with a class ID of ffff:fff1...
>=20
>   $ tc qdisc add dev eth0 root handle ffff: htb default fff1
>   $ tc class add dev eth0 \
>             parent ffff: classid ffff:fff1 htb rate 100%
>=20
> Regrafting a Qdisc to such classes won't work as intended at all.  It's a
> separate issue though.

Jamal, are you ok with the above explanation? Perhaps it would be
worthy to add a specific test-case under tc-testing for this issue?

Thanks!

Paolo


