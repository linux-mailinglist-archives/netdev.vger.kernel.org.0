Return-Path: <netdev+bounces-4603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC2970D857
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0CAB281033
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A050A1DDFE;
	Tue, 23 May 2023 09:04:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927C21B91E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:04:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE28C119
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mh8toiKSONJxpueXVbWPsMK7oHcXlzbD/7oSSgzRjtc=;
	b=SU5ZmERVorEL4j1R7wqhZbjtvooIZl52AfJThAOaOC4ducEc6fLLlanj2oqe+DGZHjiITw
	MEQCyNpXs94D3V1ESQm5WYJs++kBtzzcDrkTRh1i8WjSoADWb80k2kebzcjTH9U2r6kxTq
	kuALe7x3qgOXc2VfHNsa5QY8OZ7eBQY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-NCgF2NTOODiyPqf4JEJBmA-1; Tue, 23 May 2023 05:04:31 -0400
X-MC-Unique: NCgF2NTOODiyPqf4JEJBmA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f5fde052b6so4336805e9.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684832670; x=1687424670;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mh8toiKSONJxpueXVbWPsMK7oHcXlzbD/7oSSgzRjtc=;
        b=E5xJyEpprmsX/kLk0a+KAkWECnjHVJxU2it8RV9er4IRSOL/z8ZWdr+QYa5Vsfa7kT
         JdRKTDXr9AjIj1mP++Wu38/Ug/prA8LQzmga7c1ES2NQEc1qWhZXlmzIW9kS40sFBATK
         1fLF8fIntSCKvUq+J3Wsk7rcI5qYHjaWHODOLbMWX5d15E8pa/b7b+2Yu4QBjScgrNrw
         hg5FrFc6NTQn/9PYQ6pp6/BgjzPHNFIDwWPtX7zmD7vrYKT1Ubsi0+ChjobQBC19jeVb
         OgkpRTxbRmQLS+DhsBz1DMiPdOxbe7zvWDz/9blsRkoSq8q7n9ZnWxxP4Gn2NIMBEocl
         sarg==
X-Gm-Message-State: AC+VfDxFt6uuQRMn9T7cFuHtm9ldtlrWJZ7NV/wr+jQ+EsSTZe3jhK85
	QUadrBV9Jl4CXqXwnS7Iwu9fREtamHJ3vqiVJIoA0NAKxwx7gOqH5KwXdD+WiBlI50An5+/JOwt
	r5YlRozAC5EDPgYQn
X-Received: by 2002:a5d:4109:0:b0:305:ed26:856e with SMTP id l9-20020a5d4109000000b00305ed26856emr7803100wrp.4.1684832670602;
        Tue, 23 May 2023 02:04:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Qdyz8m4c2KZ0ByEomruT/rDD4o1h49hH+E+Q+j0J/L4RZJ3hQM4OxIcO31NyWdS+H6P0gGQ==
X-Received: by 2002:a5d:4109:0:b0:305:ed26:856e with SMTP id l9-20020a5d4109000000b00305ed26856emr7803067wrp.4.1684832670216;
        Tue, 23 May 2023 02:04:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-246-0.dyn.eolo.it. [146.241.246.0])
        by smtp.gmail.com with ESMTPSA id f5-20020a5d4dc5000000b002fe13ec49fasm10326528wru.98.2023.05.23.02.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:04:29 -0700 (PDT)
Message-ID: <de69794bc23a7a019136134cee1e819937f0777a.camel@redhat.com>
Subject: Re: [PATCH net-next 1/5] skbuff: bridge: Add layer 2 miss indication
From: Paolo Abeni <pabeni@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, 
	razor@blackwall.org
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org, 
 davem@davemloft.net, edumazet@google.com, roopa@nvidia.com, 
 taras.chornyi@plvision.eu, saeedm@nvidia.com, leon@kernel.org,
 petrm@nvidia.com,  vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
 alexandre.belloni@bootlin.com,  UNGLinuxDriver@microchip.com,
 jhs@mojatatu.com, xiyou.wangcong@gmail.com,  jiri@resnulli.us,
 taspelund@nvidia.com
Date: Tue, 23 May 2023 11:04:27 +0200
In-Reply-To: <ZGx0/hwPmFFN2ivS@shredder>
References: <20230518113328.1952135-1-idosch@nvidia.com>
	 <20230518113328.1952135-2-idosch@nvidia.com>
	 <1ed139d5-6cb9-90c7-323c-22cf916e96a0@blackwall.org>
	 <ZGd+9CUBM+eWG5FR@shredder> <20230519145218.659b0104@kernel.org>
	 <ZGx0/hwPmFFN2ivS@shredder>
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

On Tue, 2023-05-23 at 11:10 +0300, Ido Schimmel wrote:
> On Fri, May 19, 2023 at 02:52:18PM -0700, Jakub Kicinski wrote:
> > On Fri, 19 May 2023 16:51:48 +0300 Ido Schimmel wrote:
> > > diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> > > index fc17b9fd93e6..274e55455b15 100644
> > > --- a/net/bridge/br_input.c
> > > +++ b/net/bridge/br_input.c
> > > @@ -46,6 +46,8 @@ static int br_pass_frame_up(struct sk_buff *skb)
> > >          */
> > >         br_switchdev_frame_unmark(skb);
> > > =20
> > > +       skb->l2_miss =3D BR_INPUT_SKB_CB(skb)->miss;
> > > +
> > >         /* Bridge is just like any other port.  Make sure the
> > >          * packet is allowed except in promisc mode when someone
> > >          * may be running packet capture.
> > >=20
> > > Ran these changes through the selftest and it seems to work.
> >=20
> > Can we possibly put the new field at the end of the CB and then have TC
> > look at it in the CB? We already do a bit of such CB juggling in strp
> > (first member of struct sk_skb_cb).
>=20
> Using the CB between different layers is very fragile and I would like
> to avoid it. Note that the skb can pass various layers until hitting the
> classifier, each of which can decide to memset() the CB.
>=20
> Anyway, I think I have a better alternative. I added the 'l2_miss' bit
> to the tc skb extension and adjusted the bridge to mark packets via this
> extension. The entire thing is protected by the existing 'tc_skb_ext_tc'
> static key, so overhead is kept to a minimum when feature is disabled.
> Extended flower to enable / disable this key when filters that match on
> 'l2_miss' are added / removed.
>=20
> bridge change to mark the packet:
> https://github.com/idosch/linux/commit/3fab206492fcad9177f2340680f02ced1b=
9a0dec.patch
>=20
> flow_dissector change to dissect the info from the extension:
> https://github.com/idosch/linux/commit/1533c078b02586547817a4e63989a0db62=
aa5315.patch
>=20
> flower change to enable / disable the key:
> https://github.com/idosch/linux/commit/cf84b277511ec80fe565c41271abc6b2e2=
f629af.patch
>=20
> Advantages compared to the previous approach are that we do not need a
> new bit in the skb and that overhead is kept to a minimum when feature
> is disabled. Disadvantage is that overhead is higher when feature is
> enabled.
>=20
> WDYT?

Looks good to me.

I think you would only need to set/add the extension when l2_miss is
true, right? (with no extension l2 hit is assumed). That will avoid
unneeded overhead for br_dev_xmit().

All the others involved paths look like slow(er) one, so the occasional
skb extension overhead should not be a problem.

Cheers,

Paolo


