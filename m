Return-Path: <netdev+bounces-2866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D51807045C3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB0E1C20D4F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D026107B9;
	Tue, 16 May 2023 07:07:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590AC101EC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:07:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA9C1BD3
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 00:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684220860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q2/jG0CqRWsSGJSAoe82IzilNICtj9ZU3hzw25K3C5M=;
	b=awuDaejYQqlJuNclBuQBafC/PECmaWGXr3mFxdzdnyzq87XRADDyBB1ixIVlVu05T3jcH+
	+yM+vhgAwmvj47pnWlubJTzNXXWyEYIctk2n7UNlX5ztp5b/0TB30l+aVg4333R1Flb1Fz
	Ov/XlVVn6YmWhdGaGFjvIIKg5cLgrVM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-i7q8V253MqKYGLDOyfJtaQ-1; Tue, 16 May 2023 03:07:38 -0400
X-MC-Unique: i7q8V253MqKYGLDOyfJtaQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f4b96aa44aso9544215e9.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 00:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684220857; x=1686812857;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q2/jG0CqRWsSGJSAoe82IzilNICtj9ZU3hzw25K3C5M=;
        b=YwbkpDrwvNnZrb3vLKeunO8octbG3cFqItclivzoTAPyolVb38Ozff+0CkJjlhTee0
         l+lwKxn8s6twRUTpkBivL/RdS+8PpRMkp5tCQ2WKhRWIm4UeK6VJdJa4afftWgRDOpjK
         gvU2aGdI/NNqOMypPeiP8xlQQ3iXThvxjsu69Jooa7BXyuE6QEa5XQVdwcL92pvhFQMX
         kdxSWJSSS+TuL3E72778JRiJPnBPqfGmEYkXJQPNsAdwd796MT3oI91JvI7DRp0NeqjP
         HTeyxk4YsCLglf3zmfupxVEVHezozW8ha6QmnlqUjac75ykEUb+siRHRNmmvVgzEnTB/
         0yKA==
X-Gm-Message-State: AC+VfDzSC//9bZ9bmIQ1mSX8HUz86J7ACuJV0IgB5Yc9ajQYhioBCNnT
	wn/osZDw5X+Ljbhk56wNdiNpbxZ2vmK2cXhBI0T5iGKCdGvgLB/oGPAC8Rf83NMc33fKUb9vjTU
	W6WvKI8oL3ot76NMa
X-Received: by 2002:a05:600c:1d13:b0:3f4:27ec:9d12 with SMTP id l19-20020a05600c1d1300b003f427ec9d12mr1316207wms.4.1684220857694;
        Tue, 16 May 2023 00:07:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Pk2rHz8r6RepJeoG4HzSBnLlCjskbfrF7eE6Y3yskyh3sRkXTMsQUzTryzgWvSTQlNX4yWQ==
X-Received: by 2002:a05:600c:1d13:b0:3f4:27ec:9d12 with SMTP id l19-20020a05600c1d1300b003f427ec9d12mr1316176wms.4.1684220857315;
        Tue, 16 May 2023 00:07:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-225-74.dyn.eolo.it. [146.241.225.74])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b003f0ad8d1c69sm1220209wmg.25.2023.05.16.00.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 00:07:36 -0700 (PDT)
Message-ID: <ff3c537ada67e27823d7605686ef0b5c05c13ab5.camel@redhat.com>
Subject: Re: [PATCH net-next 2/7] net: lan966x: Add support for offloading
 pcp table
From: Paolo Abeni <pabeni@redhat.com>
To: Piotr Raczynski <piotr.raczynski@intel.com>, Horatiu Vultur
	 <horatiu.vultur@microchip.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 davem@davemloft.net,  edumazet@google.com, kuba@kernel.org,
 UNGLinuxDriver@microchip.com
Date: Tue, 16 May 2023 09:07:35 +0200
In-Reply-To: <ZGIGkZDW84tHr04f@nimitz>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
	 <20230514201029.1867738-3-horatiu.vultur@microchip.com>
	 <ZGIGkZDW84tHr04f@nimitz>
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

On Mon, 2023-05-15 at 12:16 +0200, Piotr Raczynski wrote:
> On Sun, May 14, 2023 at 10:10:24PM +0200, Horatiu Vultur wrote:

[...]

> > +static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_=
app *app)
> > +{
> > +	struct dcb_app app_itr;
> > +	int err;
> > +	u8 prio;
> > +
> > +	err =3D lan966x_dcb_app_validate(dev, app);
> > +	if (err)
> > +		goto out;
> > +
> > +	/* Delete current mapping, if it exists */
> > +	prio =3D dcb_getapp(dev, app);
> > +	if (prio) {
> > +		app_itr =3D *app;
> > +		app_itr .priority =3D prio;
> Compiles OK, still looks little weird :).

Since it looks like a v2 is required to update later patches, please
additionally remove the unneeded whitespace above:

		app_itr.priority =3D prio;

Thanks!

Paolo


