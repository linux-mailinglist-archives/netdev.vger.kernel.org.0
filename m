Return-Path: <netdev+bounces-3518-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42987707AAA
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0C10281588
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F5D2A9CA;
	Thu, 18 May 2023 07:14:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138DD17F7
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:14:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015F91BD2
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684394080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LMF9iQxS4+e096ixTrmjYfyxlJK1AWBZxgFG+XUX9Uo=;
	b=GQULVnOBbIKrNike930Fqi7DA4bLJWwCk+LRJgDa0Y2mKLtrN5V2nQfoKssAatXdk5pTIb
	xX5ntfkXapbxNtdwm8i7Y4rGwdgU7HaaLkvjgnKOFrCyEC6zLGvbsTEA5FVHs58voMKUPN
	YKBfTGaNV/mY3Ved7KwzbELIaUK4cGo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-a4S5rJATMZOI96ougHO9vg-1; Thu, 18 May 2023 03:14:38 -0400
X-MC-Unique: a4S5rJATMZOI96ougHO9vg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3f386bb966cso1009951cf.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684394078; x=1686986078;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LMF9iQxS4+e096ixTrmjYfyxlJK1AWBZxgFG+XUX9Uo=;
        b=ba/n4zhxT8Q9PG6iwDd19tZT/z0a4XFGZdlP9U9r0GDYYSRZKu4zmMtYE2D/f1Mt7Z
         ZlSQq3ccg9VOvHIOgduifjPlGbsp90tqCSGYcbylfWiEPzIYdNwTZ6zyN4mUmDcOp53m
         qc/O48Der56ToicQztyYi2yLvZyl1mnzu4EXrCpzehCenyxk45qQTGpGlXc8LHMztkgf
         tFBEvF5Aih2kUSXy+3skAzJrntgYyPvLsrw2xs8qn1rMOsp6igNWCV3kvrxYiJMAtZtU
         n/RvJnmwmRBcMlAbMfy7kSIJ3p0SsVoFVt0/uxFdFd4cIHHY2iE/nV4fwuiSUvrAkDKs
         jhYw==
X-Gm-Message-State: AC+VfDxV/tFnDJGfSgGNxl3hPjux6dFRrBGOnxekpAy8LWO1TshRXudz
	m/IZ8QWv5boOfNwwJYWkJR/vmB2pF8H1Cx/arNiwiO3cvc2fd8/mKnAhamvTFqyYeU+jlZRkAmM
	P+o3j0jph/xAoTowt
X-Received: by 2002:ac8:7f16:0:b0:3f4:fdaa:8e14 with SMTP id f22-20020ac87f16000000b003f4fdaa8e14mr10695383qtk.2.1684394077914;
        Thu, 18 May 2023 00:14:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5wd4ylClQrAVa6bfDgK3AEgnKytECM9HuphhORsAdS5nxU1tdek68Vbw/wS8823V49shwfjg==
X-Received: by 2002:ac8:7f16:0:b0:3f4:fdaa:8e14 with SMTP id f22-20020ac87f16000000b003f4fdaa8e14mr10695372qtk.2.1684394077628;
        Thu, 18 May 2023 00:14:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-175.dyn.eolo.it. [146.241.239.175])
        by smtp.gmail.com with ESMTPSA id u8-20020ac87508000000b003e4dab0776esm301661qtq.40.2023.05.18.00.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 00:14:37 -0700 (PDT)
Message-ID: <40235375c0001845dc11b559a4352337e1d90e65.camel@redhat.com>
Subject: Re: linux-next: build failure after merge of the net tree
From: Paolo Abeni <pabeni@redhat.com>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Marc Kleine-Budde
 <mkl@pengutronix.de>,  Stephen Rothwell <sfr@canb.auug.org.au>, David
 Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>,  Linux
 Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Date: Thu, 18 May 2023 09:14:34 +0200
In-Reply-To: <CABGWkvr-LBVA0XehWHnRaVMT5n-m_V91GzqG4R30fj4QYbuV5g@mail.gmail.com>
References: <20230518090634.6ec6b1e1@canb.auug.org.au>
	 <20230517214200.33398f82@kernel.org>
	 <11ab22ff9ecf7e7a330ac45e9ac08bf04aa7f6df.camel@redhat.com>
	 <CABGWkvr-LBVA0XehWHnRaVMT5n-m_V91GzqG4R30fj4QYbuV5g@mail.gmail.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-18 at 08:52 +0200, Dario Binacchi wrote:
> Hi all,
>=20
> On Thu, May 18, 2023 at 8:47=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> w=
rote:
> >=20
> > On Wed, 2023-05-17 at 21:42 -0700, Jakub Kicinski wrote:
> > > On Thu, 18 May 2023 09:06:34 +1000 Stephen Rothwell wrote:
> > > > Hi all,
> > > >=20
> > > > After merging the net tree, today's linux-next build (arm
> > > > multi_v7_defconfig) failed like this:
> > > >=20
> > > > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > > > FATAL ERROR: Unable to parse input tree
> > > > make[2]: *** [scripts/Makefile.lib:419: arch/arm/boot/dts/stm32f746=
-disco.dtb] Error 1
> > > > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > > > FATAL ERROR: Unable to parse input tree
> > > > make[2]: *** [scripts/Makefile.lib:419: arch/arm/boot/dts/stm32f769=
-disco.dtb] Error 1
> > > > Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
> > > > FATAL ERROR: Unable to parse input tree
> > > >=20
> > > > Caused by commit
> > > >=20
> > > >   0920ccdf41e3 ("ARM: dts: stm32: add CAN support on stm32f746")
> > > >=20
> > > > I have used the net tree from next-20230517 for today.
> > >=20
> > > Dario, Marc, can we get an immediate fix for this?
> >=20
> > Dario, Marc: we are supposed to send the net PR to Linus today. Lacking
> > a fix, I'll be forced to revert the mentioned commit in a little time.
> >=20
>=20
> Marc reverted the commit:
> https://lore.kernel.org/all/20230517181950.1106697-1-mkl@pengutronix.de/

Thanks for the pointer!

@Marc: could you please formally send the revert to netdev, too?

Thanks!

Paolo


