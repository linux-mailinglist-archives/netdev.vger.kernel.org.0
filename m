Return-Path: <netdev+bounces-10649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D72E372F899
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 931242813BC
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC23A53A2;
	Wed, 14 Jun 2023 09:03:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02D87FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:03:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA63135
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686733401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L6yrRaUgNP0i+itIFPIOL5T5KvN+cJDDLn7deutEHlM=;
	b=HIAsBTcIjkhCZDrRJdIVLBlnTKukxtcJciGzkXWy7r+M4AKIPMlRLN4iwQdMFFllC+Qb9V
	HvdHRQR29eV0epMnTgYwXtOowOeDrq2fR2m80bQuLe/AV/mPS74wMLI9SxWQqrxTNZUUUF
	Et7yfvXGWcgeSXvfZEAHNuBnvhN5sVk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-ht2wcAvlPs-Rh9fI02GCNg-1; Wed, 14 Jun 2023 05:03:20 -0400
X-MC-Unique: ht2wcAvlPs-Rh9fI02GCNg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-30fc1bc8a90so466534f8f.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686733399; x=1689325399;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L6yrRaUgNP0i+itIFPIOL5T5KvN+cJDDLn7deutEHlM=;
        b=lPOot0wORDhewGITHTZny6WM9Gl4H3NjEL1Ey8WSc5P4Aapw8sKshO9ih9Q3xHkx23
         sJeKmxyFvn9e8u6nSPXD8ar3krHorg3T7RbS8s5Pq6ls3aMZL3yBQeFEMqe4/aPHNnA7
         kTD6YqX7nMCfzcvA5vK3f29SJtqnuu6xFIK6mw5MHiCUf5kMrxh7SDxiFXvWSjpo940t
         gAtwcFUMfclTgzfWoy3KbQhD7ezkaEJmzC7c6tSFzreM3VVApYzbLu0h4KBYou+BquPQ
         +LHoNxfzjhc32Jg1D8T44N9lCrf9J2ftlebNQHApeypsbj1Qaazun4OjA3Re1RFGDnYQ
         YqiQ==
X-Gm-Message-State: AC+VfDxFGG8XnTZyi5z0e16kklSb0+qch3YJ2v6qwd7ChsY4D/W95D2u
	Ru9fZFAua7Ke9C+KaXyiKTtZo2QjJMB1ETikS4bEn9tZAfvlDUJQG/TaYopdvE1ZNg57FqdSLsY
	ow78bSGaSdYZmeyWI
X-Received: by 2002:a5d:4590:0:b0:30f:b0e0:218c with SMTP id p16-20020a5d4590000000b0030fb0e0218cmr8292344wrq.6.1686733399194;
        Wed, 14 Jun 2023 02:03:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4jiUqHfnQ2bghPHFY6v44vRSv2dUGCqyT8FogcenSaMB8cB48qFagbofYV098rUQqIB64HOQ==
X-Received: by 2002:a5d:4590:0:b0:30f:b0e0:218c with SMTP id p16-20020a5d4590000000b0030fb0e0218cmr8292331wrq.6.1686733398902;
        Wed, 14 Jun 2023 02:03:18 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-67.dyn.eolo.it. [146.241.244.67])
        by smtp.gmail.com with ESMTPSA id i1-20020adfefc1000000b0030647449730sm17796417wrp.74.2023.06.14.02.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:03:18 -0700 (PDT)
Message-ID: <a9d5cf824500c3a4d86f26bd18ec29b6dfd2daf8.camel@redhat.com>
Subject: Re: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
 IFLA_VF_INFO
From: Paolo Abeni <pabeni@redhat.com>
To: "Keller, Jacob E" <jacob.e.keller@intel.com>, Gal Pressman
 <gal@nvidia.com>,  Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>,  David Ahern <dsahern@gmail.com>, Michal Kubecek
 <mkubecek@suse.cz>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 Edwin Peer <edwin.peer@broadcom.com>, Edwin Peer <espeer@gmail.com>
Date: Wed, 14 Jun 2023 11:03:17 +0200
In-Reply-To: <CO1PR11MB50899E098BB3FFE0DE322222D654A@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230611105108.122586-1-gal@nvidia.com>
	 <20230611080655.35702d7a@hermes.local>
	 <9b59a933-0457-b9f2-a0da-9b764223c250@nvidia.com>
	 <CO1PR11MB50899E098BB3FFE0DE322222D654A@CO1PR11MB5089.namprd11.prod.outlook.com>
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

On Mon, 2023-06-12 at 05:34 +0000, Keller, Jacob E wrote:
> > -----Original Message-----
> > From: Gal Pressman <gal@nvidia.com>
> > Sent: Sunday, June 11, 2023 10:59 AM
> > To: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.=
org>;
> > David Ahern <dsahern@gmail.com>; Michal Kubecek <mkubecek@suse.cz>;
> > netdev@vger.kernel.org; Edwin Peer <edwin.peer@broadcom.com>; Edwin Pee=
r
> > <espeer@gmail.com>
> > Subject: Re: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS=
 to
> > IFLA_VF_INFO
> >=20
> > On 11/06/2023 18:06, Stephen Hemminger wrote:
> >=20
> > > Better but it is still possible to create too many VF's that the resp=
onse
> > > won't fit.
> >=20
> > Correct, no argues here.
> > It allowed me to see around ~200 VFs instead of ~70, a step in the righ=
t
> > direction.
>=20
> I remember investigating this a few years ago and we hit limits of ~200 t=
hat were essentially unfixable without creating a new API that can separate=
 the reply over more than one message. The VF info data was not designed in=
 the current op to allow processing over multiple messages. It also (unfort=
unately) doesn't report errors so it ends up just truncating instead of pro=
ducing an error.
>=20
> Fixing this completely is non-trivial.

As it looks like the is substantial agreement on this approach being a
step in the right direction and I can't think of anything better, I
suggest to merge this as is, unless someone voices concerns very soon,
very loudly.

Thanks!

Paolo


