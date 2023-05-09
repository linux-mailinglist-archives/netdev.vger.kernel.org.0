Return-Path: <netdev+bounces-1205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF156FCA20
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:21:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15DA11C20C19
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036A01800B;
	Tue,  9 May 2023 15:21:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB0F17FE6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:21:48 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EC9189
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:21:46 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96622bca286so678020666b.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 08:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683645704; x=1686237704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5wvCEZfId/fWNIx4HgBGUsppKXANxR0uG7KeHB2lWb8=;
        b=HcQTsWgDvkDpMrebpBesWV3VrgkRlui8LjtpJlxitySTXOX70fwW6jWgA6iCJGzBDC
         48YfxXgR/pm8g5XGJVXBCSNLQxSFaTXBipsmRQMzuGdfKlUy+7GqDrNjw/EF0WWJK4jq
         G1lAgla/93C2XJc0/e5HbpGZMRaE8lyrukcHoutDDTTjeF3AdzBORs5imU8hGJoxpr2b
         EMyRwhwz6gnHdgC7HIwWQ1YgpvHd/eveNlVeaPpZzNoIYSmSmks/ZGllmeNbrCDenyd1
         zW3VkYIFjvPOEN7si+CdGkqvtX0nnc7HB2k0+6VLNaBwuNC18kiSUdo/X2b53PbvKQ3X
         Vo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645704; x=1686237704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wvCEZfId/fWNIx4HgBGUsppKXANxR0uG7KeHB2lWb8=;
        b=cwBShHHUadbjyl1Iy8rAa4CvFxNM6qp9PfHJFB5p00eVX8VnW4Z+7fL5vuKsLV34WZ
         Qk5WMXtX45JDls/IrdetqV96ZSpz50xWJmEracGWvmo+2H0f3KkaHJTEIS+xloOOGViB
         8Jv2P5wA977S3J1mIQPWWcN6vsRrYDqTXapHsx1KPPcH8o1dBHxm0HzC62wFtt12PZhf
         aKwcbbZRyOHlag/K4L/xDm9nDQmxynA4erSEYoTFhZmlzHnoCT7qh3auLbFQflh+GWxN
         Lujo6miVilrgpDwzl1MZg+wc2+8LROrJHOwsN7yHGXrXKfB71IkDebUdd3hgjXIQ9MOk
         ce2g==
X-Gm-Message-State: AC+VfDwyedcA3dDuz6hAK+TH0jwXrTHERVvj09Vu3Uz7JmTixXVbFqYQ
	l5xA1HS+tOIfxrPx9vALG/CI4w==
X-Google-Smtp-Source: ACHHUZ7hkZqAjy1MhZ9RwgKJeNps/7jxzvhtYzIuCS9ctN0awt0ruwSz29mq/RH7b1Rz1fWVkYjcag==
X-Received: by 2002:a17:907:d91:b0:933:4d37:82b2 with SMTP id go17-20020a1709070d9100b009334d3782b2mr12927600ejc.57.1683645704296;
        Tue, 09 May 2023 08:21:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id jz10-20020a17090775ea00b00965ef79ae14sm1423719ejc.189.2023.05.09.08.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:21:43 -0700 (PDT)
Date: Tue, 9 May 2023 17:21:42 +0200
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
Message-ID: <ZFplBpF3etwRY5nv@nanopsycho>
References: <ZFPwqu5W8NE6Luvk@nanopsycho>
 <20230504114421.51415018@kernel.org>
 <ZFTdR93aDa6FvY4w@nanopsycho>
 <20230505083531.57966958@kernel.org>
 <ZFdaDmPAKJHDoFvV@nanopsycho>
 <d86ff1331a621bf3048123c24c22f49e9ecf0044.camel@redhat.com>
 <ZFjoWn9+H932DdZ1@nanopsycho>
 <20230508124250.20fb1825@kernel.org>
 <ZFn74xJOtiXatfHQ@nanopsycho>
 <20230509075247.2df8f5aa@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509075247.2df8f5aa@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 09, 2023 at 04:52:47PM CEST, kuba@kernel.org wrote:
>On Tue, 9 May 2023 09:53:07 +0200 Jiri Pirko wrote:
>> >Yup. Even renaming EXT to something that's less.. relative :(  
>> 
>> Suggestion?
>
>Well, is an SMT socket on the board an EXT pin?
>Which is why I prefer PANEL.

Makes sense.
To speak code, we'll have:

/**
 * enum dpll_pin_type - defines possible types of a pin, valid values for
 *   DPLL_A_PIN_TYPE attribute
 * @DPLL_PIN_TYPE_UNSPEC: unspecified value
 * @DPLL_PIN_TYPE_MUX: aggregates another layer of selectable pins
 * @DPLL_PIN_TYPE_PANEL: physically facing user, for example on a front panel
 * @DPLL_PIN_TYPE_SYNCE_ETH_PORT: ethernet port PHY's recovered clock
 * @DPLL_PIN_TYPE_INT_OSCILLATOR: device internal oscillator
 * @DPLL_PIN_TYPE_GNSS: GNSS recovered clock
 */
enum dpll_pin_type {
        DPLL_PIN_TYPE_UNSPEC,
        DPLL_PIN_TYPE_MUX,
        DPLL_PIN_TYPE_PANEL,
        DPLL_PIN_TYPE_SYNCE_ETH_PORT,
        DPLL_PIN_TYPE_INT_OSCILLATOR,
        DPLL_PIN_TYPE_GNSS,

        __DPLL_PIN_TYPE_MAX,
        DPLL_PIN_TYPE_MAX = (__DPLL_PIN_TYPE_MAX - 1)
};


>
>> >> Well sure, in case there is no "label" attr for the rest of the types.
>> >> Which I believe it is, for the ice implementation in this patchset.
>> >> Otherwise, there is no way to distinguish between the pins.
>> >> To have multiple attrs for label for multiple pin types does not make
>> >> any sense to me, that was my point.  
>> >
>> >Come on, am I really this bad at explaining this?  
>> 
>> Or perhaps I'm just slow.
>> 
>> >If we make a generic "label" attribute driver authors will pack
>> >everything they want to expose to the user into it, and then some.  
>> 
>> What's difference in generic label string attr and type specific label
>> string attr. What is stopping driver developers to pack crap in either
>> of these 2. Perhaps I'm missing something. Could you draw examples?
>> 
>> >So we need attributes which will feel *obviously* *wrong* to abuse.  
>> 
>> Sure, I get what you say and agree. I'm just trying to find out the
>> actual attributes :)
>
>PANEL label must match the name on the panel. User can take the card
>into their hand, look at the front, and there should be a label/sticker/
>/engraving which matches exactly what the kernel reports.
>
>If the label is printed on the board it's a BOARD_LABEL, if it's the
>name of a trace in board docs it's a BOARD_TRACE, if it's a pin of 
>the ASIC it's a PACKAGE_PIN.
>
>If it's none of those, or user does not have access to the detailed
>board / pinout - don't use the label.

To speak code, we'll have:
DPLL_A_PIN_PANEL_LABEL (string)
   available always when attr[DPLL_A_PIN_TYPE] == DPLL_PIN_TYPE_PANEL
DPLL_A_PIN_BOARD_LABEL (string)
   may be available for any type, optional
DPLL_A_PIN_BOARD_TRACE (string)
   may be available for any type, optional
DPLL_A_PIN_PACKAGE_PIN (string)
   may be available for any type, optional

Makes sense?

But this does not prevent driver developer to pack random crap in the
string anyway :/

