Return-Path: <netdev+bounces-255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A8206F66DF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FD29280C9A
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8F34A2C;
	Thu,  4 May 2023 08:10:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E10C10FC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:10:55 +0000 (UTC)
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40BC4EEB
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 01:10:52 -0700 (PDT)
Received: from [172.16.75.132] (unknown [49.255.141.98])
	by mail.codeconstruct.com.au (Postfix) with ESMTPSA id DA4BE20058;
	Thu,  4 May 2023 16:10:45 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=codeconstruct.com.au; s=2022a; t=1683187847;
	bh=UKM1NNbw8wUTX6oC12D+LK2+i5/frLVnl4aJ4QukLgE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fx+O123F07wkb8hLd5e3UCoYN8DR3yxV9a058t0xorX3Xe30CaCqferZIgcKQW+td
	 RMaFR4COkIUEjNtEcCaCdY2uppojXCtIf07X0d8pLsLfG7Bd78IMumjtYQLagUFIm4
	 qObspqnmue951WHKt3kPCtOBsYbXdbFmu37eVYwfJRvEYDMd37B81sSJgqaqDxIwLW
	 VKioxCejuH3iAHvcOPhworpiPi2EyvYCYlkgIhQaKaADrHYarTTMuNvQYsXP8gLmcQ
	 qhFUkGuVA2pe9mKCQkitP5fjY273lr49iV6HftT+lMy7RtF7p98rk4KS1svfXCF2Te
	 XzfZue6jBOuPA==
Message-ID: <fdb140d04c2f5ccc7cf453e75bbbb3d7e8716a16.camel@codeconstruct.com.au>
Subject: Re: [RFC PATCH v1 0/1] net: mctp: MCTP VDM extension
From: Jeremy Kerr <jk@codeconstruct.com.au>
To: "Richert, Krzysztof" <krzysztof.richert@intel.com>, 
	matt@codeconstruct.com.au
Cc: davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Date: Thu, 04 May 2023 16:10:44 +0800
In-Reply-To: <632501d4-5126-b5e3-d06b-8a88f8556e50@intel.com>
References: <20230425090748.2380222-1-krzysztof.richert@intel.com>
	 <aceee8aa24b33f99ebf22cf02d2063b9e3b17bb3.camel@codeconstruct.com.au>
	 <67d9617d-4f77-5a1c-3bae-d14350ccaed5@intel.com>
	 <61b1f1f0c9aab58551e98ba396deba56e77f1f89.camel@codeconstruct.com.au>
	 <4ab1d6c1-d03b-d541-39a0-263e73197521@intel.com>
	 <ce269480332ed97c153d61452ee93829d4df5c73.camel@codeconstruct.com.au>
	 <31b56a8b-d3a8-1a28-f612-34c9a4ddb2ee@intel.com>
	 <00357b1aff6d9be445f070172feb969639274a21.camel@codeconstruct.com.au>
	 <632501d4-5126-b5e3-d06b-8a88f8556e50@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Krzysztof,

> > The mark is just an arbitrary u32 (or whatever type we choose) that get=
s
> > set on the skb when the packet is routed for local input.
> >=20
> > Vendors using a subtype mechanism would have a little BPF code that
> > applies a mark to the packet, by looking at whatever subtype format tha=
t
> > vendor packet uses (from your case: a u8 that appears in the second
> > byte). The mark value does not need to match the subtype value; the mar=
k
> > just needs to be unique against the vendor-id for that specific system.
> >=20
> > Then, the userspace program implementing that subtype protocol would
> > bind() with:
> >=20
> > =C2=A0- the MCTP type 0x7e/0x7f;
> > =C2=A0- the PCI/IANA value specific to that vendor
> > =C2=A0- the mark set to the value set above (ie, defined by what the BP=
F
> > =C2=A0=C2=A0=C2=A0sets)
> >=20
> > ... and hence only receive packets for that specific vendor id and
> > subtype.
> >=20
> > Would that work?
> Thanks, I think I got it.
> Yes, it seems it would work.

OK, super!

> Unfortunately have no experience if it comes
> to BPF code, but I assume if there are several processes which want to
> consume VDM then on of them (or maybe dedicated one) should install prope=
r
> BPF handler for an incoming packet, right ?

Yes, exactly. I'm not super familiar with BPF either, but I'm happy to
work with you on getting the infrastructure going for this.

In general, we would need the vendor mark field on the skb, the mark as
a member of the sockaddr, and some glue code to allow BPF to set the skb
mark.

> It's out of the topic but maybe you know how the BPF usually is distribut=
e.
> In case when kernel itself would parse VDM for all vendors there are no
> worries, but in BPF case, if I understand correctly, vendor must provide
> BPF code which actually support marks for all VDMs across all vendors,=
=20
> correct ?

No, it would only need to apply the mark needed for that vendor+subtype
combination. I was imagining a design where the bind()-ing process
provides the BPF code itself, just for its own subtype. The specific u32
for the mark value could either be predefined by the vendor, or could be
probed at runtime.

[we would need some facility to prevent mark collision; I suspect we'll
want to require unique (mark, vendor) values on bind()]

Cheers,


Jeremy

