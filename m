Return-Path: <netdev+bounces-105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1F66F52BC
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14E8F1C20B84
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A151F63BE;
	Wed,  3 May 2023 08:09:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DED138F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:09:30 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2124ED1
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 01:09:03 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-94f6c285d92so936491966b.3
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 01:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683101342; x=1685693342;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jFzfNEO9N0rAd0IFSTlhL/1/k8fjRgZbN+iRGB6LEKU=;
        b=lKN7VlvPrYcsCywJxCAEmjv2pVo5SdKgxV9kxVicMrTQ+TkD4FDlZpTaeSZSqVziBk
         L0apNiNKvoZFNrq7aqkxz5aT4W7OnzkBcggtyrDaTxzqSjsh/R75GM9SDtHnuCiYDeLf
         cLQiVyAbzhSyZYHrpTKOl0ADkvr+d0UL+N/lrs16ZIAdEQdNpsqP0RApBXY3Sr4yNI+l
         Fw8HiwNCb9WmNyw4WDcyoQt7lO/el8ozB6ZqltT/LFA/MdCq6ZNmX9dPTUKKw4imF3PX
         AclElk8u7kwnWmfsJMhW+lbKTgZt2KYQcfIiBzK+rn+W3bguMqU/iqCX9BXDSQzqMW57
         LmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683101342; x=1685693342;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFzfNEO9N0rAd0IFSTlhL/1/k8fjRgZbN+iRGB6LEKU=;
        b=l1dy7+0Vbr1h6ga0tUBkFs9y9IHeYV4jOCSFIDINeXssmo7ppv5L+Pc9LbK6++lFQU
         s4EJ1C6PH+nQG5OULYMTOVw175GeWNA8COwP00s4FT0hJpog64odZqdgO+lvODx2UoXB
         2bUsQZirY0nODxcoxep3vr/OB+xbSEBE0Ros+zC7CXnQdpf/8C1MwlSJYnmyt1RhqrKg
         Yb/dNkObVvSvbZhIH3bD7v0frGT/R78UalswRupCBqUgGb69tIerbW+4D7SJIFNG4CMD
         Ow37cO5/yrMk6rcx242jjqQKNcNBuJ5sqhlkNJoai8RzyR/O4rOTOk9qKN6KZEWxympY
         bNRg==
X-Gm-Message-State: AC+VfDwFaTieZETU9cbVUIEplmJ1Dwig1Wsrm2rpQu2sDyk3KbjdQV4x
	4KOMhCAs1Ysa5e72F6KxqbTicg==
X-Google-Smtp-Source: ACHHUZ5n2wZ9MUJaRcjAEgAzJu51k/4LrzZRMOXMfsvy1FLjJyPTF9duZadCiXNMd/IA+v5s4ajGZQ==
X-Received: by 2002:a17:907:9288:b0:953:3e29:f35c with SMTP id bw8-20020a170907928800b009533e29f35cmr2175425ejc.45.1683101341714;
        Wed, 03 May 2023 01:09:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bo2-20020a0564020b2200b0050bc6983041sm416801edb.96.2023.05.03.01.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 01:09:01 -0700 (PDT)
Date: Wed, 3 May 2023 10:09:00 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
	mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Message-ID: <ZFIWnDjVQ1YrHBRg@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-3-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Apr 28, 2023 at 02:20:03AM CEST, vadfed@meta.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[...]


>+static struct dpll_pin *
>+dpll_pin_alloc(u64 clock_id, u8 pin_idx, struct module *module,
>+	       const struct dpll_pin_properties *prop)
>+{
>+	struct dpll_pin *pin;
>+	int ret, fs_size;
>+
>+	pin = kzalloc(sizeof(*pin), GFP_KERNEL);
>+	if (!pin)
>+		return ERR_PTR(-ENOMEM);
>+	pin->pin_idx = pin_idx;
>+	pin->clock_id = clock_id;
>+	pin->module = module;
>+	refcount_set(&pin->refcount, 1);
>+	if (WARN_ON(!prop->label)) {

Why exactly label has to be mandatory? In mlx5, I have no use for it.
Please make it optional. IIRC, I asked for this in the last review
as well.


>+		ret = -EINVAL;
>+		goto err;
>+	}
>+	pin->prop.label = kstrdup(prop->label, GFP_KERNEL);

Labels should be static const string. Do you see a usecase when you need
to dup it? If not, remove this please.



>+	if (!pin->prop.label) {
>+		ret = -ENOMEM;
>+		goto err;
>+	}


[...]

