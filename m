Return-Path: <netdev+bounces-542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE936F80BF
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 037D11C216FA
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0833B4C8D;
	Fri,  5 May 2023 10:30:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F094CBA51
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:30:05 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E519219426
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:30:02 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-953343581a4so240335166b.3
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 03:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683282601; x=1685874601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0zEEWPURLzLc29PpkMvuHfunPeqWFI4LDFz37TVYXgU=;
        b=TaYWMqZ64NSjIM+PaA0/SXNmCwqfyHcIofKucfNO5CeMwj4vhFc1K9qdgN3r7dRor9
         or7s134yj186lmBh3mtJkpfPPCK6mRY8xORPV3j0Pd1VPZndsb0TETGxBJ25z4f66AWM
         sVf8sug73c4OrJT+0VmMoM7SrXuvmUGnglH3S4JGnzyi7HmqC5UBPvesDr/Al5G0VYkv
         l1Ulwe6bModaCiZsKkUhCKqHv6CYkZzIy0XIGz2i0sKDdfVnpd3zXIW1fpJIQ/H49PRu
         yuBoaLWT4Qpr1UQarPFYqGeCGSp6GpEiZV87x6ElOFKm0iEQOBmqySX2k+t175ZQtpln
         Q9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683282601; x=1685874601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0zEEWPURLzLc29PpkMvuHfunPeqWFI4LDFz37TVYXgU=;
        b=adusGTMxEEC3CiMEmrEuHZ7zt1TyxAGhqBVgUEIMWE+MfJy+J/DHgyh/4HKSO/SzSJ
         z+/qjNZfWHtfgT47xmDRjVlQrNtCC28hhnb5qJgo+HqE1iUz4TaXT2IWzghHPQE7E8rX
         alLLy5tf/E5v2g0zoRKqx82WGXFkUQBNrkSpf8LdKc3Ds1+pBoAbmYb84BKzhvqbnvT/
         L2j0DfucA/9mwZC29NjSNvS6IdOqliguPkVM/ZcgER/8MyxD9KDkuHKq1Vu8bMsHdP2y
         u04g/bNhKs1Gw2PELXcveYq0Bz2n6LPt8XdpRSo3S38ZsuwEeJ4Ktq0yyWLbKSYqwjPg
         GLOg==
X-Gm-Message-State: AC+VfDyfE2t+7ioVDhSiGtzyM+YS5PoHN7B/mRR0CvydexqbgXQO7lDM
	gZmqrxdgrDrC+qTiKUGKqlcmEg==
X-Google-Smtp-Source: ACHHUZ4rVSFml9uF2WLr4fy3Jcja4p2LW0wH4xEM6OmdQqrd1zxMgn0clzkh5apQnyrsTv6dOorCEQ==
X-Received: by 2002:a17:907:7b92:b0:94e:edf3:dccd with SMTP id ne18-20020a1709077b9200b0094eedf3dccdmr929797ejc.0.1683282601306;
        Fri, 05 May 2023 03:30:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id hf27-20020a1709072c5b00b00965ddf2e221sm708829ejc.93.2023.05.05.03.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 03:30:00 -0700 (PDT)
Date: Fri, 5 May 2023 12:29:59 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vadim Fedorenko <vadfed@meta.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org, poros@redhat.com,
	mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZFTap8tIHWdbzGwp@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com>
 <ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504142451.4828bbb5@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 04, 2023 at 11:24:51PM CEST, kuba@kernel.org wrote:
>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:

[...]

>
>> >+    name: device
>> >+    subset-of: dpll
>> >+    attributes:
>> >+      -
>> >+        name: id
>> >+        type: u32
>> >+        value: 2
>> >+      -
>> >+        name: dev-name
>> >+        type: string
>> >+      -
>> >+        name: bus-name
>> >+        type: string
>> >+      -
>> >+        name: mode
>> >+        type: u8
>> >+        enum: mode
>> >+      -
>> >+        name: mode-supported
>> >+        type: u8
>> >+        enum: mode
>> >+        multi-attr: true
>> >+      -
>> >+        name: lock-status
>> >+        type: u8
>> >+        enum: lock-status
>> >+      -
>> >+        name: temp
>> >+        type: s32
>> >+      -
>> >+        name: clock-id
>> >+        type: u64
>> >+      -
>> >+        name: type
>> >+        type: u8
>> >+        enum: type
>> >+      -
>> >+        name: pin-prio
>> >+        type: u32
>> >+        value: 19  
>> 
>> Do you still need to pass values for a subset? That is odd. Well, I
>> think is is odd to pass anything other than names in subset definition,
>> the rest of the info is in the original attribute set definition,
>> isn't it?
>> Jakub?
>
>Probably stale code, related bug was fixed in YNL a few months back.
>Explicit value should no longer be needed.

What about the rest, like type, enum, multi-attr etc. Are they needed
for subset? If yes, why?



