Return-Path: <netdev+bounces-5642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4CE87124E7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0449F1C21042
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433DE742C1;
	Fri, 26 May 2023 10:39:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3817617C9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:39:34 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790A912A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:39:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51440706e59so766621a12.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685097570; x=1687689570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nnaGXZy0EI8Syg5zP9M4YNVm4y2Oe3wo0VJ6UyZ1uIw=;
        b=zxrhNc1mJUsS4852rPJmlSFlhzK0Pcla7b/5zqYZ6cP7hUIgnNPSF/qXPFuIUiKhZp
         YeS10qFFVqQ5SqMADLMxsDLx/4MGQV/DSQrGea9mBB0pti04AZdXYLyj/KBIYa/EMni3
         +EO0Plwxs7gEJrdTbGS0po0d3jTanw8Pxfd24Jg87/kbA++olBDUHGhNy0NOSqRRkspp
         1C/tiX1Ag8k71mR9y2E9YXf2ABey+KPfyIia7AkyMKeEW1F8sEQi1vOvcKv+zJCPN7fr
         /uvnFID3VJUquh2wrIYO9iGVSAuyRjZBpch/PorT1Q+eSMgXAnoJerB2IobjDMHciQFR
         qXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685097570; x=1687689570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnaGXZy0EI8Syg5zP9M4YNVm4y2Oe3wo0VJ6UyZ1uIw=;
        b=atFCb00U2NcvwBh3oOiNGbasoVaDgkXWw/w0GMDbK3FHQslEf+PUdnSwmbQ3NFgvv9
         4ivEB0V/SYrsJ08LbF2eHz3521tr/XWUNWN6EFSszWXJdO6LQqQ+F8By4L0xwncq7NCm
         rH6kMMjOJn4l5qWP1joPT28ugnQVlIw69vwOhGYx+91mkwgpuwiysAIjRZPU4J9yWiiT
         M4ILHoSqsqfkwU+o6XYmZISmf3srWqi92Rx7JuJDjWv0ZnqUKrPjqfGKWlRft+0tVadH
         UUBs8rz0qBJmlMyAKRnZC9L3HMJH4Nx6bmTIT9sdqkGKha+2zUHFDrBtC/+KSqY1xZaQ
         JUAg==
X-Gm-Message-State: AC+VfDwo3QAz/0jpggf4zu8dh0VD+M/CG9r+mZEPgswA4ElDmKYzKmeG
	S+CGWLJmMfvAjq8rIr+kPS653A==
X-Google-Smtp-Source: ACHHUZ7QzX0ywzRsxsFjcM6NqyJniGVWg4W4KK8SfdbnzGuSeMSCR+HCckHhxmEXu8FOMB75MTSN4Q==
X-Received: by 2002:aa7:d8cd:0:b0:510:f1dc:86c0 with SMTP id k13-20020aa7d8cd000000b00510f1dc86c0mr937375eds.32.1685097569882;
        Fri, 26 May 2023 03:39:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z6-20020aa7c646000000b00501d73cfc86sm1426697edr.9.2023.05.26.03.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:39:29 -0700 (PDT)
Date: Fri, 26 May 2023 12:39:28 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v7 0/8] Create common DPLL configuration API
Message-ID: <ZHCMYJGMYS5a2+Bf@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <ZGSp/XRLExRqOKQs@nanopsycho>
 <DM6PR11MB46572080791FCA02107289549B479@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB46572080791FCA02107289549B479@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 26, 2023 at 12:14:00PM CEST, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Wednesday, May 17, 2023 12:19 PM
>>
>>Let me summarize the outcome of the discussion between me and Jakub
>>regarding attributes, handles and ID lookups in the RFCv7 thread:
>>
>>--------------------------------------------------------------
>>** Needed changes for RFCv8 **
>>
>>1) No scoped indexes.
>>   The indexes passed from driver to dpll core during call of:
>>        dpll_device_get() - device_idx
>>        dpll_pin_get() - pin_idx
>>   should be for INTERNAL kernel use only and NOT EXPOSED over uapi.
>>   Therefore following attributes need to be removed:
>>   DPLL_A_PIN_IDX
>>   DPLL_A_PIN_PARENT_IDX
>>
>
>Seems doable.
>So just to be clear, configuring a pin-pair (MUXed pins) will now be done
>with DPLL_A_PIN_PARENT nested attribute.
>I.e. configuring state of pin on parent:
>DPLL_CMD_PIN_SET
>	DPLL_A_PIN_ID		(id of pin being configured)
>	DPLL_A_PIN_PARENT	(nested)
>		DPLL_A_PIN_ID	(id of parent pin)
>		DPLL_A_PIN_STATE(expected state)
>		...		(other pin-pair attributes to be set)
>
>Is that ok, or we need separated attribute like DPLL_A_PIN_PARENT_ID??
>I think there is no need for separated one, documentation shall just reflect
>that.
>Also we have nested attribute DPLL_A_DEVICE which is used to show connections
>between PIN and multiple dpll devices, to make it consistent I will rename
>it to `DPLL_A_DEVICE_PARENT` and make configuration set cmd for the pin-dpll
>pair similar to the above:
>DPLL_CMD_PIN_SET
>	DPLL_A_PIN_ID		(id of pin being configured)
>	DPLL_A_DEVICE_PARENT	(nested)

It is a parent of pin, not device. The name is confusing. But see below.


>		DPLL_A_ID	(id of parent dpll)
>		DPLL_A_PIN_STATE(expected state)
>		...		(other pin-dpll attributes to be set)
>
>Does it make sense?

Yeah, good idea. I like this. We will have consistent approach for
parent pin and device. To take it even further, we can have one nested
attr for parent and decide the parent type according to the id attr
given:

DPLL_CMD_PIN_SET
	DPLL_A_PIN_ID		(id of pin being configured)
	DPLL_A_PIN_PARENT	(nested)
		DPLL_A_PIN_ID	(id of parent pin)
		DPLL_A_PIN_STATE(expected state)
		...		(other pin-pair attributes to be set)

DPLL_CMD_PIN_SET
	DPLL_A_PIN_ID		(id of pin being configured)
	DPLL_A_PIN_PARENT	(nested)
		DPLL_A_ID	(id of parent dpll)
		DPLL_A_PIN_STATE(expected state)
		...		(other pin-dpll attributes to be set)


Same for PIN_GET

Makes sense?



>
>
>>2) For device, the handle will be DPLL_A_ID == dpll->id.
>>   This will be the only handle for device for every
>>   device related GET, SET command and every device related notification.
>>   Note: this ID is not deterministing and may be different depending on
>>   order of device probes etc.
>>
>
>Seems doable.
>
>>3) For pin, the handle will be DPLL_A_PIN_ID == pin->id
>>   This will be the only handle for pin for every
>>   pin related GET, SET command and every pin related notification.
>>   Note: this ID is not deterministing and may be different depending on
>>   order of device probes etc.
>>
>
>Seems doable.
>
>>4) Remove attribute:
>>   DPLL_A_PIN_LABEL
>>   and replace it with:
>>   DPLL_A_PIN_PANEL_LABEL (string)
>>   DPLL_A_PIN_XXX (string)
>>   where XXX is a label type, like for example:
>>     DPLL_A_PIN_BOARD_LABEL
>>     DPLL_A_PIN_BOARD_TRACE
>>     DPLL_A_PIN_PACKAGE_PIN
>>
>
>Sorry, I don't get this idea, what are those types?
>What are they for?

The point is to make the driver developer to think before passing
randomly constructed label strings. For example, "board_label" would lead
the developer to check how the pin is labeled on the board. The
"panel_label" indicates this is label on a panel. Also, developer can
fill multiple labels for the same pin.



>
>>5) Make sure you expose following attributes for every device and
>>   pin GET/DUMP command reply message:
>>   DPLL_A_MODULE_NAME
>>   DPLL_A_CLOCK_ID
>>
>
>Seems doable.
>
>>6) Remove attributes:
>>   DPLL_A_DEV_NAME
>>   DPLL_A_BUS_NAME
>>   as they no longer have any value and do no make sense (even in RFCv7)
>>
>
>Seems doable.
>
>>
>>--------------------------------------------------------------
>>** Lookup commands **
>>
>>Basically these would allow user to query DEVICE_ID and PIN_ID
>>according to provided atributes (see examples below).
>>
>>These would be from my perspective optional for this patchsets.
>>I believe we can do it as follow-up if needed. For example for mlx5
>>I don't have usecase for it, since I can consistently get PIN_ID
>>using RT netlink for given netdev. But I can imagine that for non-SyncE
>>dpll driver this would make sense to have.
>>
>>1) Introduce CMD_GET_ID - query the kernel for a dpll device
>>                          specified by given attrs
>>   Example:
>>   -> DPLL_A_MODULE_NAME
>>      DPLL_A_CLOCK_ID
>>      DPLL_A_TYPE
>>   <- DPLL_A_ID
>>   Example:
>>   -> DPLL_A_MODULE_NAME
>>      DPLL_A_CLOCK_ID
>>   <- DPLL_A_ID
>>   Example:
>>   -> DPLL_A_MODULE_NAME
>>   <- -EINVAL (Extack: "multiple devices matched")
>>
>>   If user passes a subset of attrs which would not result in
>>   a single match, kernel returns -EINVAL and proper extack message.
>>
>
>Seems ok.
>
>>2) Introduce CMD_GET_PIN_ID - query the kernel for a dpll pin
>>                              specified by given attrs
>>   Example:
>>   -> DPLL_A_MODULE_NAME
>>      DPLL_A_CLOCK_ID
>>      DPLL_A_PIN_TYPE
>>      DPLL_A_PIN_PANEL_LABEL
>>   <- DPLL_A_PIN_ID
>>   Example:
>>   -> DPLL_A_MODULE_NAME
>>      DPLL_A_CLOCK_ID
>>   <- DPLL_A_PIN_ID    (There was only one pin for given module/clock_id)
>>   Example:
>>   -> DPLL_A_MODULE_NAME
>>      DPLL_A_CLOCK_ID
>>   <- -EINVAL (Extack: "multiple pins matched")
>>
>>   If user passes a subset of attrs which would not result in
>>   a single match, kernel returns -EINVAL and proper extack message.
>
>
>Seems ok.
>
>Will try to implement those now.

Cool, thx!


>
>Thank you,
>Arkadiusz

