Return-Path: <netdev+bounces-737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D4D6F9768
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 09:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EDC12811D0
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 07:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202071FB8;
	Sun,  7 May 2023 07:58:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1423D1C04
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 07:58:12 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB2213284
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 00:58:10 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f18dacd392so21882635e9.0
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 00:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683446289; x=1686038289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UB+NswfmVrXW5kaqHoy4lL5OJPXOFxZhDY7qp6RLj74=;
        b=LOcZ6gcb3WmoGZhlUvRdvhkG0HdLBbV+rTpcszpFfmkhh4MaWj0K279YU2/iIBzuh+
         NDy10KrohOrMaKcXAvwkR1GkSeGqYqJWV9WBUaZFqNQtjmikC9Ff0xnO2aXyplOxq+Lr
         iLCofJpW4LsZBgUJ0+BehQlZ6BzKp6x9p3lsZd8S2z8jn5pjbhnP3vb26Ti18uihlT22
         ZhgA0hfjv8PB1zVzodcLLFTJWsOQsN45lEMrYIAVs72YF4lIMxZamhS+H7UVkzkEniuf
         jsThpceT43jzsaBAqk55aqMQ1e19qCGWTbP+iw5u1d9FEMV2zwxnvHnQgTcif4nfeR6+
         ATlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683446289; x=1686038289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UB+NswfmVrXW5kaqHoy4lL5OJPXOFxZhDY7qp6RLj74=;
        b=Z8CVaDEqtrKSLieDoXE52xstwvtP2pfTwCDyVfmjhy9xoq3tWUlgATIPJ/aRfTWI4y
         qSBhg2JCRtmE0bcGpcH5TPDVGDYMvQuXOZDVfkAiBn7+BuRQndm8fN38ptiBibYbEIfY
         aWuxYDvzVB3SxGzjaKWQu4gr62PorJOnJEFmITELTJcWON4OKfO4xEU2M7evn17dFRyL
         IfumRJ0HgoXAG/X6dWZS63zFC+QQDKTxSM70GgKXUhagqTVhYz6yv57yQKxuzUhqe4EY
         jw8t0gc514lTggajyuYTbPpOs7x8TtjXiru+A1669nUvnT+lngAKT+lCxQimsqZ6Rk0k
         yxdw==
X-Gm-Message-State: AC+VfDz5KkM40oxDJC+UyIDuiUzb4kS1TQsBwIRT4z3IP3yAhfc1R/nF
	AENIifyv/cSE3SWnqDXBVHz5Vw==
X-Google-Smtp-Source: ACHHUZ6KPm680po8KAulMQOmJRdB0pu0NBqFPiwv1dL0DL6A0bBWRi6nVuVVPRzgU+WoOdHK72ouzg==
X-Received: by 2002:a1c:ed03:0:b0:3ee:6d55:8b73 with SMTP id l3-20020a1ced03000000b003ee6d558b73mr4441022wmh.29.1683446288666;
        Sun, 07 May 2023 00:58:08 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x16-20020a05600c21d000b003f318be9442sm13095502wmj.40.2023.05.07.00.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 00:58:07 -0700 (PDT)
Date: Sun, 7 May 2023 09:58:06 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Vadim Fedorenko <vadfed@meta.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, poros <poros@redhat.com>,
	mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZFdaDmPAKJHDoFvV@nanopsycho>
References: <ZFDPaXlJainSOqmV@nanopsycho>
 <20230502083244.19543d26@kernel.org>
 <ZFITyWvVcqgRtN+Q@nanopsycho>
 <20230503191643.12a6e559@kernel.org>
 <ZFOQWmkBUtgVR06R@nanopsycho>
 <20230504090401.597a7a61@kernel.org>
 <ZFPwqu5W8NE6Luvk@nanopsycho>
 <20230504114421.51415018@kernel.org>
 <ZFTdR93aDa6FvY4w@nanopsycho>
 <20230505083531.57966958@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505083531.57966958@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 05, 2023 at 05:35:31PM CEST, kuba@kernel.org wrote:
>On Fri, 5 May 2023 12:41:11 +0200 Jiri Pirko wrote:
>> >connector label (i.e. front panel label)? Or also applicable to
>> >internal pins? It'd be easier to talk details if we had the user
>> >facing documentation that ships with these products.  
>> 
>> I think is is use case specific. Some of the pins face the user over
>> physical port, they it is a front panel label. Others are internal
>> names. I have no clue how to define and mainly enforce rules here.
>
>It should be pretty easy to judge if we see the user-facing
>documentation vendors have.

Intel, Vadim, do you have such documentation?
As I wrote, for mlx5 the label is not really applicable as the link
netdev->pin is defining what the pin is.


>
>> But as an example, if you have 2 pins of the same type, only difference
>> is they are connected to front panel connector "A" and "B", this is the
>> label you have to pass to the ID query. Do you see any other way?
>
>Sound perfectly fine, if it's a front panel label, let's call 
>the attribute DPLL_A_PIN_FRONT_PANEL_LABEL. If the pin is not
>brought out to the front panel it will not have this attr.
>For other type of labels we should have different attributes.

Hmm, that would kind of embed the pin type into attr which feels wrong.
We already have the pin type exposed:
enum dpll_pin_type {
	DPLL_PIN_TYPE_UNSPEC,
	DPLL_PIN_TYPE_MUX,
	DPLL_PIN_TYPE_EXT,
	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
	DPLL_PIN_TYPE_INT_OSCILLATOR,
	DPLL_PIN_TYPE_GNSS,

       __DPLL_PIN_TYPE_MAX,
       DPLL_PIN_TYPE_MAX = (__DPLL_PIN_TYPE_MAX - 1)
};

It case of front panel pin label, the type is "EXT" as for external pin.



