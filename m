Return-Path: <netdev+bounces-846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE64C6FAFC2
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87C81280EAD
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A99171C0;
	Mon,  8 May 2023 12:17:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31453171AE
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:17:37 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7882E3D6
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 05:17:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30796c0cbcaso892960f8f.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 05:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683548253; x=1686140253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oPwugTUEtVq5Uj3H7DR5qqfTvvaV0QUu9h3q5nQeCX4=;
        b=VVg+QTowSAgRtuHW8vb93EmhtYhqGVCX9BzBM6g61T94jqpBacMgF9b+tB7h+T8/lG
         TfbShgF9dGpPk7qtZN9muE4EBalexkiiv3fXHkCQb2F8G50DECZlOHJVISvNt1jjOtIL
         BCFhO48sGe9pP6W3rkDpEqLgV8wut+zPMsINaphirm+ieoTBmKEPJCcTbti+cuorrpUG
         +pGdg4zeC/Rh9Iyx6/BGFDjlsLlgrzUdkoEUS1FtEWI352/Vdo7ltG8q/992ODusD7un
         d5N49WjIbEEFo4RRL/zpeY4ef2m0m4oEu4Pgsa1N6Oi7wztMRx8p3NLzQxHXPfXnPYDs
         UOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683548253; x=1686140253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPwugTUEtVq5Uj3H7DR5qqfTvvaV0QUu9h3q5nQeCX4=;
        b=IBgFACXOnIj9vPtYncKuIrGn+fLE/gmUG/PmvZ6tq0AeJ0KBf/LGIl4BZWpSACgmL0
         NRl9k/oncP1Xno90CambbGOYZeJdiW5X7visbx7Q09y0SXJp1bch9ue4Sz0DDH829IDZ
         bXg0EMVyhUomyNZaMlPo7gLMKquUbUAaN0KJyMqODCjDvnuism56bANxJ2qOPY5W6e3P
         sc6jCzRQjwRhIoHdUWd1MxD7zKgvX0kAQDYStecm/KaBZgamxHrh/jxmw+R+H39mHxkM
         B2GwmK9CCV7EJurMSeH0IpmkEmtCCzGs2O2oi12vmCLsJ2dnm1F1CM6f6BuUR9Ll9Q2S
         3fxg==
X-Gm-Message-State: AC+VfDzjbxVVEwaUGOeYMLQ7xbVn25W+1aHleNEISwuOIhyeDBZYbKzN
	lqJBXUbD2+hrJD0bKAr98VL9Fw==
X-Google-Smtp-Source: ACHHUZ4E6ajP9+kyFa3qZr84KHy9kUfD8AcS49xwioZ0VY0cqr2mu/Czkz/SCfQdsmMB7lKFUi4czw==
X-Received: by 2002:a5d:4749:0:b0:2f2:79ce:4836 with SMTP id o9-20020a5d4749000000b002f279ce4836mr7291868wrs.60.1683548252581;
        Mon, 08 May 2023 05:17:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z6-20020adff746000000b002f103ca90cdsm11181011wrp.101.2023.05.08.05.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 05:17:31 -0700 (PDT)
Date: Mon, 8 May 2023 14:17:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <ZFjoWn9+H932DdZ1@nanopsycho>
References: <ZFITyWvVcqgRtN+Q@nanopsycho>
 <20230503191643.12a6e559@kernel.org>
 <ZFOQWmkBUtgVR06R@nanopsycho>
 <20230504090401.597a7a61@kernel.org>
 <ZFPwqu5W8NE6Luvk@nanopsycho>
 <20230504114421.51415018@kernel.org>
 <ZFTdR93aDa6FvY4w@nanopsycho>
 <20230505083531.57966958@kernel.org>
 <ZFdaDmPAKJHDoFvV@nanopsycho>
 <d86ff1331a621bf3048123c24c22f49e9ecf0044.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d86ff1331a621bf3048123c24c22f49e9ecf0044.camel@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 08, 2023 at 08:50:09AM CEST, pabeni@redhat.com wrote:
>On Sun, 2023-05-07 at 09:58 +0200, Jiri Pirko wrote:
>> Fri, May 05, 2023 at 05:35:31PM CEST, kuba@kernel.org wrote:
>> > On Fri, 5 May 2023 12:41:11 +0200 Jiri Pirko wrote:
>> > > 
>> > Sound perfectly fine, if it's a front panel label, let's call 
>> > the attribute DPLL_A_PIN_FRONT_PANEL_LABEL. If the pin is not
>> > brought out to the front panel it will not have this attr.
>> > For other type of labels we should have different attributes.
>> 
>> Hmm, that would kind of embed the pin type into attr which feels wrong.
>
>Looking at the above from a different angle, the
>DPLL_A_PIN_FRONT_PANEL_LABEL attribute will be available only for
>DPLL_PIN_TYPE_EXT type pins, which looks legit to me - possibly
>renaming DPLL_A_PIN_FRONT_PANEL_LABEL as DPLL_A_PIN_EXT_LABEL.

Well sure, in case there is no "label" attr for the rest of the types.
Which I believe it is, for the ice implementation in this patchset.
Otherwise, there is no way to distinguish between the pins.
To have multiple attrs for label for multiple pin types does not make
any sense to me, that was my point.


>
>Cheer,
>
>Paolo
>

