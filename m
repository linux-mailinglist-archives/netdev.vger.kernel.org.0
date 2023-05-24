Return-Path: <netdev+bounces-5120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B93470FB82
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0C782812F6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D0919E4C;
	Wed, 24 May 2023 16:15:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E683619BDB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:15:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157E3B0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684944900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FdhgoVf2OQy8N/RHwUzfzmuq+TRciWhT7h9EPoEclnA=;
	b=B8K9AxHeomX3dxy08PnWyF0tJUvDGdwCompcWqoypacs/OthqJB7va1c0/z3QL5IQyLvH0
	3MoZSWC3+tXZvV6mYNZlncNzS0+Mc2KvYHImRyKYLx8C/O05M9ZoGa0nJHVtd+ZanLj/no
	sIXKcfqB30Ai3HmOifrd8DkbdCLEo2U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425--JJk3KRuN8ezHRMQav-RYA-1; Wed, 24 May 2023 12:14:58 -0400
X-MC-Unique: -JJk3KRuN8ezHRMQav-RYA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f602cec801so1931605e9.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684944897; x=1687536897;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FdhgoVf2OQy8N/RHwUzfzmuq+TRciWhT7h9EPoEclnA=;
        b=VZXATceVQgrb8+RoUQu0dP185fOdwmED7ckkduY/0H+EgbnfIuQXcqBg2X2ZEMUf/Z
         VtjN1C01jM0Ab1D51aaovzb+VswsyIRLgec2q8HRqcusR9z36q44YVq6pJdiN6Ordmg3
         E97ynn62LWS+4jqbg+ZhC0kB/j1JXU/C6TyQN77XawMtWetNYFF8xji9oS486GhaogMz
         FmF2vVUmoA6t3zIu5gQ7PNXuTGaNdckezolt777UhRLyffl/umBaVr7v63yMEj1CCknK
         bZEapijPPi4OHlC9vlcp3Y/SwxR5cIgNSETpcGmAm/XbcTpTyN26Oj4wFPiB8fqjK5RS
         4OpQ==
X-Gm-Message-State: AC+VfDzyVVR1qk5v5vy7LlD4iNSx2I9V90Wmga+On9Sqyagcm6/DJ111
	bX7FKCHvid310okfuv7AwWiw3EMzz6GwAPaxMiS+BlVIFVFueX1u3TYhRMpa8n90Fnmko1AEahq
	1NE+9DIGzxVbrgg/f
X-Received: by 2002:adf:e345:0:b0:307:a582:330a with SMTP id n5-20020adfe345000000b00307a582330amr1957696wrj.2.1684944897474;
        Wed, 24 May 2023 09:14:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6WQeyuJxT78YS+/zO3WWJJdwAS6NiP1Co9nzB/TFj9Fs45KKNkBO8STxxNCJSksIQOTFrzSQ==
X-Received: by 2002:adf:e345:0:b0:307:a582:330a with SMTP id n5-20020adfe345000000b00307a582330amr1957685wrj.2.1684944897174;
        Wed, 24 May 2023 09:14:57 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-207.dyn.eolo.it. [146.241.242.207])
        by smtp.gmail.com with ESMTPSA id x2-20020adfdcc2000000b003077f3dfcc8sm14841220wrm.32.2023.05.24.09.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 09:14:56 -0700 (PDT)
Message-ID: <2ecb3189855ceb4f7399271bf99af5a27926e59c.camel@redhat.com>
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
From: Paolo Abeni <pabeni@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>, Willem de Bruijn
	 <willemdebruijn.kernel@gmail.com>
Cc: Simon Horman <simon.horman@corigine.com>, Louis Peens
	 <louis.peens@corigine.com>, David Miller <davem@davemloft.net>, 
	netdev@vger.kernel.org, oss-drivers@corigine.com, Willem de Bruijn
	 <willemb@google.com>
Date: Wed, 24 May 2023 18:14:55 +0200
In-Reply-To: <20230524083813.65cdee0d@kernel.org>
References: <20230522141335.22536-1-louis.peens@corigine.com>
	 <beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
	 <20230523142005.3c5cc655@kernel.org> <ZG31Plb6/UF3XKd3@corigine.com>
	 <20230524082216.1e1fed93@kernel.org>
	 <CAF=yD-JH2NHTXCg-Z=cUw-JK0g9Y9pb-pcyboq5AkES+ohShkg@mail.gmail.com>
	 <20230524083813.65cdee0d@kernel.org>
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

On Wed, 2023-05-24 at 08:38 -0700, Jakub Kicinski wrote:
> On Wed, 24 May 2023 11:33:15 -0400 Willem de Bruijn wrote:
> > The OCP draft spec already has this wording, which covers UDP:
> >=20
> > "RSS defines two rules to derive queue selection input in a
> > flow-affine manner from packet headers. Selected fields of the headers
> > are extracted and concatenated into a byte array. If the packet is
> > IPv4 or IPv6, not fragmented, and followed by a transport layer
> > protocol with ports, such as TCP and UDP, then extract the
> > concatenated 4-field byte array { source address, destination address,
> > source port, destination port }. Else, if the packet is IPv4 or IPv6,
> > extract 2-field byte array { source address, destination address }.
> > IPv4 packets are considered fragmented if the more fragments bit is
> > set or the fragment offset field is non-zero."
>=20
> Ugh, that's what I thought. I swear I searched it for "fragment"
> yesterday and the search came up empty. I blame google docs :|
>=20
> We should probably still document the recommendation that if the NIC
> does not comply and hashes on ports with MF set - it should disable=20
> UDP hashing by default (in kernel docs).

FTR, the above schema could still move the same flow on different
queues - if some datagrams in the given flow are fragmented and some
are not.

Out of sheer ignorance I really don't know if/how many NICs implement
RSS hashing=C2=A0with the above schema (using different data according to
the IP header fragments related fields). I'm guessing some (most?) use
a simpler schema (always L4 if available or never L4).

I *think* we could as well suggest always using L4 for UDP. If users
care about fragments they will have to explicitly deal with them
anyway.

Cheers,

Paolo


