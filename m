Return-Path: <netdev+bounces-815-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4422E6FA022
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1EEF280E78
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682E715488;
	Mon,  8 May 2023 06:50:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3034420
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:50:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D2B72BE
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 23:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683528619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=32UpXCzVyg7syon/NdEm9BVsI1w4xTARICsqJk7H+no=;
	b=A8nPBEIgOOSU0NWD0o6EmDqxNBb148hKuuJEfSn9KJw/NEm5+NjGmgwCFCLl81bFD6LdzD
	1DdmDZjxNbXZkO8aFZ8yGMo/yapbMG6Y98Ty0fWEMY6M4gnegS3XOxPbBB8wialazEQBiM
	yyWHRj8Yv0hEJFv4G5vEiV/quSyNtBo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-gRvgffq9MoS-kcRVygui1g-1; Mon, 08 May 2023 02:50:14 -0400
X-MC-Unique: gRvgffq9MoS-kcRVygui1g-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-61acaa32164so7959916d6.1
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 23:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683528614; x=1686120614;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=32UpXCzVyg7syon/NdEm9BVsI1w4xTARICsqJk7H+no=;
        b=cp8rNEMb81JZ3wSlbYRCQg9c6Gva0xRJHM6p08j5fTWKE8BRVS2cVgZecYfnlHvViR
         2MIATs2yGO89l6yAbx3eH/i52r0+etCv/iPy4bH0YAnHXJ0gu7PDlCniKt4fRHnCTPlf
         zW4lWvzhS5Y6/VJro0PZvkH35RlzBEmNwzSrK2b4OjljQIquKiWmuX3l4HwW06Y5IcTp
         ITPCg61seoA/aC1CH4bys3i6VMTdaJKlNuKZy2OEkctQ0XlcR//odydN01zPfFE78hHC
         zIC5uQwyWNVl8RVyvwAFelTmuhohvoHoEvlWYi3uHqcFckV+/akCc9Zjgby/4+mvCJR4
         ju7w==
X-Gm-Message-State: AC+VfDwiWXyRU+p0PlEunpBEYy6spIvvbF6SxWTywJmorzhAe/GfCMbw
	faqBhfrnKZK4Hg/ybxye31gUAgY8xD+AmvPRKv26BjH7P3yzg4UBpu/xOOPWIx/lUW2TyUjYayj
	NSF5esDMu88HUtaYs
X-Received: by 2002:ad4:5ecf:0:b0:5df:55b5:b1a with SMTP id jm15-20020ad45ecf000000b005df55b50b1amr13016792qvb.4.1683528614392;
        Sun, 07 May 2023 23:50:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5q5ghOczOmNoK3lScvQqhcZZ6tdqJVH5UXF5t5HvbVS/LDnf2+1HpA70aZES2YbbGS4w+1MA==
X-Received: by 2002:ad4:5ecf:0:b0:5df:55b5:b1a with SMTP id jm15-20020ad45ecf000000b005df55b50b1amr13016781qvb.4.1683528614096;
        Sun, 07 May 2023 23:50:14 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-175.dyn.eolo.it. [146.241.244.175])
        by smtp.gmail.com with ESMTPSA id t17-20020a0ce2d1000000b005ef442226bbsm2552489qvl.8.2023.05.07.23.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 23:50:13 -0700 (PDT)
Message-ID: <d86ff1331a621bf3048123c24c22f49e9ecf0044.camel@redhat.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
From: Paolo Abeni <pabeni@redhat.com>
To: Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>, Vadim
 Fedorenko <vadim.fedorenko@linux.dev>, Vadim Fedorenko <vadfed@meta.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>, poros <poros@redhat.com>,
 mschmidt <mschmidt@redhat.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>,  linux-arm-kernel@lists.infradead.org,
 "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, "Olech, Milena"
 <milena.olech@intel.com>,  "Michalik, Michal" <michal.michalik@intel.com>
Date: Mon, 08 May 2023 08:50:09 +0200
In-Reply-To: <ZFdaDmPAKJHDoFvV@nanopsycho>
References: <ZFDPaXlJainSOqmV@nanopsycho>
	 <20230502083244.19543d26@kernel.org> <ZFITyWvVcqgRtN+Q@nanopsycho>
	 <20230503191643.12a6e559@kernel.org> <ZFOQWmkBUtgVR06R@nanopsycho>
	 <20230504090401.597a7a61@kernel.org> <ZFPwqu5W8NE6Luvk@nanopsycho>
	 <20230504114421.51415018@kernel.org> <ZFTdR93aDa6FvY4w@nanopsycho>
	 <20230505083531.57966958@kernel.org> <ZFdaDmPAKJHDoFvV@nanopsycho>
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

On Sun, 2023-05-07 at 09:58 +0200, Jiri Pirko wrote:
> Fri, May 05, 2023 at 05:35:31PM CEST, kuba@kernel.org wrote:
> > On Fri, 5 May 2023 12:41:11 +0200 Jiri Pirko wrote:
> > >=20
> > Sound perfectly fine, if it's a front panel label, let's call=20
> > the attribute DPLL_A_PIN_FRONT_PANEL_LABEL. If the pin is not
> > brought out to the front panel it will not have this attr.
> > For other type of labels we should have different attributes.
>=20
> Hmm, that would kind of embed the pin type into attr which feels wrong.

Looking at the above from a different angle, the
DPLL_A_PIN_FRONT_PANEL_LABEL attribute will be available only for
DPLL_PIN_TYPE_EXT type pins, which looks legit to me - possibly
renaming DPLL_A_PIN_FRONT_PANEL_LABEL as DPLL_A_PIN_EXT_LABEL.

Cheer,

Paolo


