Return-Path: <netdev+bounces-1068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F606FC0CB
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC15028118A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABEE171CE;
	Tue,  9 May 2023 07:53:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C0538C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:53:13 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA041FC2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:53:10 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-94a342f7c4cso968863666b.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 00:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683618789; x=1686210789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=feUQTmDsglXzlQR46XLSaIS8pInOXk6yAAJ3q99bp6I=;
        b=hjRhYZ2sqanoRvze/04alzqj9JiiwPhCoxB+BI/eJx6dHRi6cYVOLmaRH9YzRfEfv6
         T3ZXVRAubpUacBIo/dQ1Oe6Ccb8QgQhq8ZZyqE4K3gqrMkiztqLy40BvjiJrSpLAq/Et
         D5CExYDCCSTBwJUZJaiAnXUj+uvuTSbyouSFBVHyZIWGpiHNKyGCmgqG0WBQJvHcsLlr
         D0s7voEYioCxU7RFpIUN39peWz4+qm+s7GB6IczkO65xQ2rOLlQ1/KxMhF8pDHefm+oH
         SMNyWsNxQhQnjC5bN2bD59vzIffXLhoebYhPhQUl9Wxe19W38bupMDXk2WzIzp9m0ij3
         sCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683618789; x=1686210789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=feUQTmDsglXzlQR46XLSaIS8pInOXk6yAAJ3q99bp6I=;
        b=eO8D0Hmfo9cLIZFYrNpr6XFhtm43WwSlKNwYFYdKURExcVufKc7tHgH5zOy+7DFwQ5
         cONRPKU+LcJM+T6BpkmSSH6xz/IG/wN9FzpENWKlPZV3htWTO1dEfWyoEUzxkMhzIHOa
         pUAfGjqgz367aMWPMEyoKH2kuvz+k8zog8CWsYX+W+iulOdwQhar4HCvhuSvckqIugII
         btFOJzpbyKiQkUN3SievlVQQR4NPmeqnuMwBq6SsPw85U4z/Q1jgGU68UOez6Zhgif2A
         FZutYhkAVT9a+I0S18geRWz79xQSg6qdDYzpsGV68r1iSkQYxp4hgGWvVxsopGNVMnVD
         qCEg==
X-Gm-Message-State: AC+VfDw8Efc7EzRKN5jNotw+olUWHIahdJUJihTfsTtSWebNBub8dE9d
	IGIyScj/sd2j5k0cVp4gFI3Gx87PV8LseXiENAgPhg==
X-Google-Smtp-Source: ACHHUZ4Ys5JPUT5yfL7I2Ptl2Kgw41O9I1am/CVOQxdIoqUTW0+/rjArOEcpP2Y6DgIN8YjOjWtTBA==
X-Received: by 2002:a17:907:1c9a:b0:966:2fdf:f66c with SMTP id nb26-20020a1709071c9a00b009662fdff66cmr9304626ejc.3.1683618788710;
        Tue, 09 May 2023 00:53:08 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d21-20020a170906c21500b00965fdb90801sm990212ejz.153.2023.05.09.00.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 00:53:08 -0700 (PDT)
Date: Tue, 9 May 2023 09:53:07 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Vadim Fedorenko <vadfed@meta.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, poros <poros@redhat.com>,
	mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZFn74xJOtiXatfHQ@nanopsycho>
References: <ZFOQWmkBUtgVR06R@nanopsycho>
 <20230504090401.597a7a61@kernel.org>
 <ZFPwqu5W8NE6Luvk@nanopsycho>
 <20230504114421.51415018@kernel.org>
 <ZFTdR93aDa6FvY4w@nanopsycho>
 <20230505083531.57966958@kernel.org>
 <ZFdaDmPAKJHDoFvV@nanopsycho>
 <d86ff1331a621bf3048123c24c22f49e9ecf0044.camel@redhat.com>
 <ZFjoWn9+H932DdZ1@nanopsycho>
 <20230508124250.20fb1825@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508124250.20fb1825@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 08, 2023 at 09:42:50PM CEST, kuba@kernel.org wrote:
>On Mon, 8 May 2023 14:17:30 +0200 Jiri Pirko wrote:
>> >> Hmm, that would kind of embed the pin type into attr which feels wrong.  
>
>An attribute which changes meaning based on a value of another attribute
>feels even more wrong.

It wouldn't change meaning, it would be still "a label". Either on a
back of a PCI card or internal pin in a board scheme. Still the same
meaning (for mux type for example).



>
>> >Looking at the above from a different angle, the
>> >DPLL_A_PIN_FRONT_PANEL_LABEL attribute will be available only for
>> >DPLL_PIN_TYPE_EXT type pins, which looks legit to me - possibly
>> >renaming DPLL_A_PIN_FRONT_PANEL_LABEL as DPLL_A_PIN_EXT_LABEL.  
>
>Yup. Even renaming EXT to something that's less.. relative :(

Suggestion?


>
>> Well sure, in case there is no "label" attr for the rest of the types.
>> Which I believe it is, for the ice implementation in this patchset.
>> Otherwise, there is no way to distinguish between the pins.
>> To have multiple attrs for label for multiple pin types does not make
>> any sense to me, that was my point.
>
>Come on, am I really this bad at explaining this?

Or perhaps I'm just slow.


>
>If we make a generic "label" attribute driver authors will pack
>everything they want to expose to the user into it, and then some.

What's difference in generic label string attr and type specific label
string attr. What is stopping driver developers to pack crap in either
of these 2. Perhaps I'm missing something. Could you draw examples?


>
>So we need attributes which will feel *obviously* *wrong* to abuse.

Sure, I get what you say and agree. I'm just trying to find out the
actual attributes :)

