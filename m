Return-Path: <netdev+bounces-547-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2426F80EE
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F9191C217F7
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1706F538A;
	Fri,  5 May 2023 10:41:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0409F156C0
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:41:17 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7741A1F2
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:41:14 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-2fa47de5b04so1506807f8f.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 03:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683283273; x=1685875273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Nq9FdkBIx7qSryTVXqkeom+1RISA8nreL8gl42Y7iA=;
        b=aRXM1GWidgf8Okv7zsy+p23RkW4A7VS9PvC9GNkHVM3zrKKuhdA2WkYNRci3aNhwti
         WS7qBTTCy31SYNrRXFqkRKGQU4QuBkK1BtB4cb+NwGYLXUFmKFtCdYhA1WHAzQODEYTT
         cHvO55vJwuUBRrbCbmHny5TfPxwFP6tFvsZzwDQ7agH8+f1z6d/Tx5jVq2PdmCLR14Cz
         el85dxokm3LC+zxDGH+INLa5KqWsBi7eLfkpWesxin9bQZBMlWxG4BTGwBaKIt6Sp/y6
         RcRlTJynem2WpOKg7R8VDezVZAM/w8Y7smGK0K6mm2C8UThkycRNNcPJMgoQ23AIhWgA
         v5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683283273; x=1685875273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Nq9FdkBIx7qSryTVXqkeom+1RISA8nreL8gl42Y7iA=;
        b=WjfmwIk5romSGeKuM9weHUFVTR5oGFd5d5PVmexw9G69ss24ql1ownvhWuCTDN9Yh+
         UOif4sOtTitiZ39uY9+dpxjrFhl6yBjL4kF8MhSlQa/oFoya62ZCXuwLMZm3MWn5A7MO
         mmHNmerLjCRMOxB/sYUk+iVWXk0j0OZFXwFQl8ufX8jMFDO+OPvqK6DEHCFxyLLBIYnP
         eUCR0e6d8lKc0tQBUCh7dd4rvdEi1pbK/pEzM6CZQ2tUd0y8i6CYkrIQyvMFc5YxGHVg
         mwUNcA8TVTrIUX9i2U3PaGtWZsthHVyGP0xh+OFn9OyWfF9XHT3ait2lUoB+sjPpxDbR
         HE7A==
X-Gm-Message-State: AC+VfDzf6MsSWjgpdp67YGunK2XOx8i9uvny7P63f1uYneBrrrTcgLL2
	BTUWEYl0lUKpX2ddxaNWuPPYufZwzzSvqHE6C34=
X-Google-Smtp-Source: ACHHUZ5N1BYv2fq0cH1ZrnOoRhp0jMNO3Sek0h8iGuMTIFGDHe5roWYot3NxaGP4Kg3ciiwxq4JcMw==
X-Received: by 2002:a5d:4c8c:0:b0:2f5:3dfd:f4d2 with SMTP id z12-20020a5d4c8c000000b002f53dfdf4d2mr1102918wrs.64.1683283272788;
        Fri, 05 May 2023 03:41:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f16-20020a5d6650000000b003062c0ef959sm1993670wrw.69.2023.05.05.03.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 03:41:12 -0700 (PDT)
Date: Fri, 5 May 2023 12:41:11 +0200
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
Message-ID: <ZFTdR93aDa6FvY4w@nanopsycho>
References: <ZDwg88x3HS2kd6lY@nanopsycho>
 <20230417124942.4305abfa@kernel.org>
 <ZFDPaXlJainSOqmV@nanopsycho>
 <20230502083244.19543d26@kernel.org>
 <ZFITyWvVcqgRtN+Q@nanopsycho>
 <20230503191643.12a6e559@kernel.org>
 <ZFOQWmkBUtgVR06R@nanopsycho>
 <20230504090401.597a7a61@kernel.org>
 <ZFPwqu5W8NE6Luvk@nanopsycho>
 <20230504114421.51415018@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504114421.51415018@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 04, 2023 at 08:44:21PM CEST, kuba@kernel.org wrote:
>On Thu, 4 May 2023 19:51:38 +0200 Jiri Pirko wrote:
>> >> What is the next intelligible element to identify DPLL device here?  
>> >
>> >I don't know. We can always add more as needed.
>> >We presuppose that the devices are identifiable, so whatever info
>> >is used to identify them goes here.  
>> 
>> Allright. So in case of ptp_ocp and mlx5, module_name and clock_id
>> are enough. In case of ice, DPLL_A_TYPE, attr is the one to make
>> distinction between the 2 dpll instances there
>> 
>> So for now, we can have:
>>  CMD_GET_ID
>>    -> DPLL_A_MODULE_NAME  
>>       DPLL_A_CLOCK_ID
>>       DPLL_A_TYPE
>>    <- DPLL_A_ID
>> 
>> 
>> if user passes a subset which would not provide a single match, we error
>> out with -EINVAL and proper exack message. Makes sense?
>
>Yup, that sounds good to me.
>
>> >Same answer. Could be a name of the pin according to ASIC docs.
>> >Could be the ball name for a BGA package. Anything that's meaningful.  
>> 
>> Okay, for pin, the type and label would probably do:
>>  CMD_GET_PIN_ID
>>    -> DPLL_A_MODULE_NAME  
>>       DPLL_A_CLOCK_ID
>>       DPLL_A_PIN_TYPE
>>       DPLL_A_PIN_LABEL
>
>Label sounds dangerously open ended, too. Would that be the SMA

Well, every string is. And past RFCs of this patchset demonstrated guys
did serialize a lot of stuff in strings.


>connector label (i.e. front panel label)? Or also applicable to
>internal pins? It'd be easier to talk details if we had the user
>facing documentation that ships with these products.

I think is is use case specific. Some of the pins face the user over
physical port, they it is a front panel label. Others are internal
names. I have no clue how to define and mainly enforce rules here.

But as an example, if you have 2 pins of the same type, only difference
is they are connected to front panel connector "A" and "B", this is the
label you have to pass to the ID query. Do you see any other way?


>
>>    <- DPLL_A_PIN_ID
>> 
>> Again, if user passes a subset which would not provide a single match,
>> we error out with -EINVAL and proper exack message.
>> 
>> If there is only one pin for example, user query of DPLL_A_MODULE_NAME
>> and DPLL_A_CLOCK_ID would do return a single match. No need to pass
>> anything else.
>> 
>> I think this could work with both ice and ptp_ocp, correct guys?
>> 
>> For mlx5, I will have 2 or more pins with same module name, clock id
>> and type. For these SyncE pins the label does not really make sense.
>> But I don't have to query, because the PIN_ID is going to be exposed for
>> netdev over RT netlink. Clicks.
>> 
>> Makes sense?

