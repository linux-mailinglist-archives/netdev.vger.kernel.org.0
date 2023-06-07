Return-Path: <netdev+bounces-8778-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88382725B41
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4AFA28116D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E937B35B2A;
	Wed,  7 Jun 2023 10:05:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59D97488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:05:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9F51707
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 03:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686132326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pabWd2MRgsuVxUvV0DGgCD7SRbaF3wZm1tvsg81rdig=;
	b=OYh/t9VNalbP5qPd43n6ksnJ16+GO3YhfFtt+xVZ2a8lG9EdpBBGfXgH+rxRI7Rvpqbm0J
	rEn+xEzPHgwW/SUSEDLM1U3f/Gj+FWywEd4mX6PRlI9dvKUiySzxcViPHcxdw81To2+XWp
	QQRZxihT6mX5dkT3dPbDaKTBopAFI8U=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-zJlbzbyANh2i8IOTUV0xEA-1; Wed, 07 Jun 2023 06:05:24 -0400
X-MC-Unique: zJlbzbyANh2i8IOTUV0xEA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-62615f764b4so8672066d6.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 03:05:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686132324; x=1688724324;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pabWd2MRgsuVxUvV0DGgCD7SRbaF3wZm1tvsg81rdig=;
        b=k/zzmiQ0coU+vAVuGGxkG9ayQmdbGpd2S2fGEIA9EIV9ESz+WmcDyPwfO13yp03Hcf
         epbEvi38hLx3B33OEvGgFgneH3rTF4KrGHxrJZESyuuwXKbAf2ajKWuE+LdLpE3ygtK/
         F+a8BbgmZ0HqyKfsd6KUrrIKUGH3ZcUXn7GYO0/mB0YxBEPsaSTABHua3FmUFZD/kLAT
         eSWyHbSEkK/XMssAGWB7H6CFJERKlEMvTnZRgGTwNpZ62Qdk5Z2+4Dp0laMXda45Hm2v
         x6KIKKssoTw/8JN+qAzVRXGlrYiAqDsLgLmWRhSFP+0zWcOc6n3ke/Xu/hLz8lW8kTzB
         1NyQ==
X-Gm-Message-State: AC+VfDxyfKXGzbcXM3vBnJZUi4hxWL3Bj52Cokr6FApkH4fS5sV4OmFF
	RzM5p58IimP3yB1EO5DHD7XO2GndqwBUv/I3LaYeRePmWQopE7wO3sM5MuxGa8NoBvoIGVLahSv
	nwE0xCCJoO5GkZA9YOA1KaAgN
X-Received: by 2002:a05:6214:5297:b0:625:77a1:2a5f with SMTP id kj23-20020a056214529700b0062577a12a5fmr1380579qvb.5.1686132324229;
        Wed, 07 Jun 2023 03:05:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7sCXPPAWyY9MZsxKcdqeTNcw91QomhRFU3GqMhd2G/fj4dGIw1ubuYxSotSN/dL/v4EjVLzA==
X-Received: by 2002:a05:6214:5297:b0:625:77a1:2a5f with SMTP id kj23-20020a056214529700b0062577a12a5fmr1380549qvb.5.1686132323832;
        Wed, 07 Jun 2023 03:05:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-247-199.dyn.eolo.it. [146.241.247.199])
        by smtp.gmail.com with ESMTPSA id y9-20020ad457c9000000b00626161ea7a3sm6033222qvx.2.2023.06.07.03.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 03:05:23 -0700 (PDT)
Message-ID: <c4707459ac2cb0b48cb9552e83ad4057ae5b9300.camel@redhat.com>
Subject: Re: [PATCH RESEND net-next 2/5] net/sched: taprio: keep child Qdisc
 refcount elevated at 2 in offload mode
From: Paolo Abeni <pabeni@redhat.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Jamal Hadi
 Salim <jhs@mojatatu.com>,  Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
 <jiri@resnulli.us>, Vinicius Costa Gomes <vinicius.gomes@intel.com>,
 linux-kernel@vger.kernel.org,  intel-wired-lan@lists.osuosl.org, Muhammad
 Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>, Peilin Ye
 <yepeilin.cs@gmail.com>,  Pedro Tammela <pctammela@mojatatu.com>
Date: Wed, 07 Jun 2023 12:05:19 +0200
In-Reply-To: <20230606155605.so7xpob6zbuugnwv@skbuf>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
	 <20230602103750.2290132-3-vladimir.oltean@nxp.com>
	 <6bce1c55e1cd4295a3f36cb4b37398d951ead07b.camel@redhat.com>
	 <20230606155605.so7xpob6zbuugnwv@skbuf>
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

On Tue, 2023-06-06 at 18:56 +0300, Vladimir Oltean wrote:
> On Tue, Jun 06, 2023 at 12:27:09PM +0200, Paolo Abeni wrote:
> > On Fri, 2023-06-02 at 13:37 +0300, Vladimir Oltean wrote:
> > > The taprio qdisc currently lives in the following equilibrium.
> > >=20
> > > In the software scheduling case, taprio attaches itself to all TXQs,
> > > thus having a refcount of 1 + the number of TX queues. In this mode,
> > > q->qdiscs[] is not visible directly to the Qdisc API. The lifetime of
> > > the Qdiscs from this private array lasts until qdisc_destroy() ->
> > > taprio_destroy().
> > >=20
> > > In the fully offloaded case, the root taprio has a refcount of 1, and
> > > all child q->qdiscs[] also have a refcount of 1. The child q->qdiscs[=
]
> > > are visible to the Qdisc API (they are attached to the netdev TXQs
> > > directly), however taprio loses a reference to them very early - duri=
ng
> > > qdisc_graft(parent=3D=3DNULL) -> taprio_attach(). At that time, tapri=
o frees
> > > the q->qdiscs[] array to not leak memory, but interestingly, it does =
not
> > > release a reference on these qdiscs because it doesn't effectively ow=
n
> > > them - they are created by taprio but owned by the Qdisc core, and wi=
ll
> > > be freed by qdisc_graft(parent=3D=3DNULL, new=3D=3DNULL) -> qdisc_put=
(old) when
> > > the Qdisc is deleted or when the child Qdisc is replaced with somethi=
ng
> > > else.
> > >=20
> > > My interest is to change this equilibrium such that taprio also owns =
a
> > > reference on the q->qdiscs[] child Qdiscs for the lifetime of the roo=
t
> > > Qdisc, including in full offload mode. I want this because I would li=
ke
> > > taprio_leaf(), taprio_dump_class(), taprio_dump_class_stats() to have
> > > insight into q->qdiscs[] for the software scheduling mode - currently
> > > they look at dev_queue->qdisc_sleeping, which is, as mentioned, the s=
ame
> > > as the root taprio.
> > >=20
> > > The following set of changes is necessary:
> > > - don't free q->qdiscs[] early in taprio_attach(), free it late in
> > >   taprio_destroy() for consistency with software mode. But:
> > > - currently that's not possible, because taprio doesn't own a referen=
ce
> > >   on q->qdiscs[]. So hold that reference - once during the initial
> > >   attach() and once during subsequent graft() calls when the child is
> > >   changed.
> > > - always keep track of the current child in q->qdiscs[], even for ful=
l
> > >   offload mode, so that we free in taprio_destroy() what we should, a=
nd
> > >   not something stale.
> > >=20
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >  net/sched/sch_taprio.c | 28 +++++++++++++++++-----------
> > >  1 file changed, 17 insertions(+), 11 deletions(-)
> > >=20
> > > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > > index b1c611c72aa4..8807fc915b79 100644
> > > --- a/net/sched/sch_taprio.c
> > > +++ b/net/sched/sch_taprio.c
> > > @@ -2138,23 +2138,20 @@ static void taprio_attach(struct Qdisc *sch)
> > > =20
> > >  			qdisc->flags |=3D TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> > >  			old =3D dev_graft_qdisc(dev_queue, qdisc);
> > > +			/* Keep refcount of q->qdiscs[ntx] at 2 */
> > > +			qdisc_refcount_inc(qdisc);
> > >  		} else {
> > >  			/* In software mode, attach the root taprio qdisc
> > >  			 * to all netdev TX queues, so that dev_qdisc_enqueue()
> > >  			 * goes through taprio_enqueue().
> > >  			 */
> > >  			old =3D dev_graft_qdisc(dev_queue, sch);
> > > +			/* Keep root refcount at 1 + num_tx_queues */
> > >  			qdisc_refcount_inc(sch);
> > >  		}
> > >  		if (old)
> > >  			qdisc_put(old);
> > >  	}
> > > -
> > > -	/* access to the child qdiscs is not needed in offload mode */
> > > -	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> > > -		kfree(q->qdiscs);
> > > -		q->qdiscs =3D NULL;
> > > -	}
> > >  }
> > > =20
> > >  static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
> > > @@ -2183,15 +2180,24 @@ static int taprio_graft(struct Qdisc *sch, un=
signed long cl,
> > >  	if (dev->flags & IFF_UP)
> > >  		dev_deactivate(dev);
> > > =20
> > > -	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> > > +	/* In software mode, the root taprio qdisc is still the one attache=
d to
> > > +	 * all netdev TX queues, and hence responsible for taprio_enqueue()=
 to
> > > +	 * forward the skbs to the child qdiscs from the private q->qdiscs[=
]
> > > +	 * array. So only attach the new qdisc to the netdev queue in offlo=
ad
> > > +	 * mode, where the enqueue must bypass taprio. However, save the
> > > +	 * reference to the new qdisc in the private array in both cases, t=
o
> > > +	 * have an up-to-date reference to our children.
> > > +	 */
> > > +	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
> > >  		*old =3D dev_graft_qdisc(dev_queue, new);
> > > -	} else {
> > > +	else
> > >  		*old =3D q->qdiscs[cl - 1];
> > > -		q->qdiscs[cl - 1] =3D new;
> > > -	}
> > > =20
> > > -	if (new)
> > > +	q->qdiscs[cl - 1] =3D new;
> > > +	if (new) {
> > > +		qdisc_refcount_inc(new);
> > >  		new->flags |=3D TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> > > +	}
> > > =20
> > Isn't the above leaking a reference to old with something alike:
> >=20
> > tc qdisc replace dev eth0 handle 8001: parent root stab overhead 24 tap=
rio flags 0x2 #...
> > 	# each q in q->qdiscs has refcnt =3D=3D 2
> > tc qdisc replace dev eth0 parent 8001:8 cbs #...
> > 	# -> taprio_graft(..., cbs, ...)
> > 	# cbs refcnt is 2
> > 	# 'old' refcnt decreases by 1, refcount will not reach 0?!?
> >=20
> > kmemleak should be able to see that.
>=20
> You're right - in full offload mode, the refcount of "old" (pfifo, parent=
 8001:8)
> does not drop to 0 after grafting something else to 8001:8.
>=20
> I believe this other implementation should work in all cases.
>=20
> static int taprio_graft(struct Qdisc *sch, unsigned long cl,
> 			struct Qdisc *new, struct Qdisc **old,
> 			struct netlink_ext_ack *extack)
> {
> 	struct taprio_sched *q =3D qdisc_priv(sch);
> 	struct net_device *dev =3D qdisc_dev(sch);
> 	struct netdev_queue *dev_queue =3D taprio_queue_get(sch, cl);
>=20
> 	if (!dev_queue)
> 		return -EINVAL;
>=20
> 	if (dev->flags & IFF_UP)
> 		dev_deactivate(dev);
>=20
> 	/* In offload mode, the child Qdisc is directly attached to the netdev
> 	 * TX queue, and thus, we need to keep its refcount elevated in order
> 	 * to counteract qdisc_graft()'s call to qdisc_put() once per TX queue.
> 	 * However, save the reference to the new qdisc in the private array in
> 	 * both software and offload cases, to have an up-to-date reference to
> 	 * our children.
> 	 */
> 	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> 		*old =3D dev_graft_qdisc(dev_queue, new);
> 		if (new)
> 			qdisc_refcount_inc(new);
> 		if (*old)
> 			qdisc_put(*old);
> 	} else {
> 		*old =3D q->qdiscs[cl - 1];
> 	}

Perhaps the above chunk could be:

	*old =3D q->qdiscs[cl - 1];
	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
		WARN_ON_ONCE(dev_graft_qdisc(dev_queue, new) !=3D *old);
		if (new)
			qdisc_refcount_inc(new);
		if (*old)
			qdisc_put(*old);
	}

(boldly assuming I'm not completely lost, which looks a wild bet ;)

> 	q->qdiscs[cl - 1] =3D new;
> 	if (new)
> 		new->flags |=3D TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
>=20
> 	if (dev->flags & IFF_UP)
> 		dev_activate(dev);
>=20
> 	return 0;
> }
>=20
> > BTW, what about including your tests from the cover letter somewhere un=
der tc-testing?
>=20
> I don't know about that. Does it involve adding taprio hw offload to netd=
evsim,
> so that both code paths are covered?

I guess I underlooked the needed effort and we could live without new
tests here.


Cheers,

Paolo


