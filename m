Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DA46B8EC4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjCNJaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjCNJaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:30:08 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4660810273
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:30:06 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v16so13702104wrn.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678786205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o8V5CcLaIIx69q/4n/y9EnU07a2ryv7HSzjXQiidp/o=;
        b=4GOXd4xGHb0FiE8xd2Gz2cxlK1qqemTQyEmEzFHlIcv282xVkNAow0ji76wCtBoKtN
         mvrEgJSJoLyDwQejcx4XwbNrcOdTZ4xrAH8hZYs57XwwF63tzV4d5cw2fVBZTIHdKzdT
         iyp3BSmVNbL06cz8yGcfNGEcM/3Fn+7uSMTeS9yAQy8tj9//BDWANchbAHs6M06ra0OF
         RKrIHuGG4iVoe9/a5lYowzH20SBZtbGpxeseJcZoL2fUJkGc2kNiX+m3w5io3IvIK1zn
         rO+SqfdbKaYIBPFj/FR0EGkmHotabBbBAKy36cV68Hgp6p4KrovwonPi5LruIp2e9D4N
         Kn0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678786205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o8V5CcLaIIx69q/4n/y9EnU07a2ryv7HSzjXQiidp/o=;
        b=hEOuaEJ70WoBqeAUT9gSFLl084IG5xWf6b6lYPmRrnBM21/bknuITbel1ouTPEgDVz
         UBhe3SI3WOgpShn/4MqARb/VOQ9Xv1ttL7dVb9aUjTKyck1KfI7cimSL2j6yFdBJ3wZj
         wE9IVIN0GdCIEZT1WHtybDoyAfLNMsQ5uECcflr3rSlWprcYNbaJRl8YlRJExw7fE4+3
         g7HNEY+hpcvHNKLnr8+pc8UqWzSv8CYjwRi20zEZrbWrs+MUjSnSNzxptvHTi4Gs9Afl
         8SObITlldcGGRtj/5soB2hbBJLKUk+gxXnSyMFtBBEodlF/ay3cqixF8a7VtZYEUoLy8
         GJng==
X-Gm-Message-State: AO0yUKX6ev3FnTSDgn2U6orWYYllmJAzSWZe9sq2q+QyqYhV2Utnu2fG
        3jdAa9nwst9uxrq0+ptd20iBfg==
X-Google-Smtp-Source: AK7set9P9j4NR2knpezskSyByqskTsKqLKNLMGBXu1k+IbCbEYd8mz6Iaow2TwGlnIjdSvyQtRVUBQ==
X-Received: by 2002:a5d:5962:0:b0:2cf:e4ab:3725 with SMTP id e34-20020a5d5962000000b002cfe4ab3725mr3326038wri.51.1678786204657;
        Tue, 14 Mar 2023 02:30:04 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g16-20020a5d46d0000000b002be505ab59asm1538249wrs.97.2023.03.14.02.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 02:30:04 -0700 (PDT)
Date:   Tue, 14 Mar 2023 10:30:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZBA+m254jlGHEtJw@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]


>+struct dpll_pin *
>+dpll_pin_alloc(u64 clock_id, u8 device_drv_id,	struct module *module,
>+	       const struct dpll_pin_properties *prop)
>+{
>+	struct dpll_pin *pin;
>+	int ret;
>+
>+	pin = kzalloc(sizeof(*pin), GFP_KERNEL);
>+	if (!pin)
>+		return ERR_PTR(-ENOMEM);
>+	pin->dev_driver_id = device_drv_id;
>+	pin->clock_id = clock_id;
>+	pin->module = module;
>+	refcount_set(&pin->refcount, 1);
>+	if (WARN_ON(!prop->description)) {
>+		ret = -EINVAL;
>+		goto release;
>+	}
>+	pin->prop.description = kstrdup(prop->description, GFP_KERNEL);
>+	if (!pin->prop.description) {
>+		ret = -ENOMEM;
>+		goto release;
>+	}
>+	if (WARN_ON(prop->type <= DPLL_PIN_TYPE_UNSPEC ||
>+		    prop->type > DPLL_PIN_TYPE_MAX)) {
>+		ret = -EINVAL;
>+		goto release;
>+	}
>+	pin->prop.type = prop->type;
>+	pin->prop.capabilities = prop->capabilities;
>+	pin->prop.freq_supported = prop->freq_supported;
>+	pin->prop.any_freq_min = prop->any_freq_min;
>+	pin->prop.any_freq_max = prop->any_freq_max;
>+	xa_init_flags(&pin->dpll_refs, XA_FLAGS_ALLOC);
>+	xa_init_flags(&pin->parent_refs, XA_FLAGS_ALLOC);
>+	ret = xa_alloc(&dpll_pin_xa, &pin->idx, pin,
>+		       xa_limit_16b, GFP_KERNEL);
>+release:
>+	if (ret) {
>+		xa_destroy(&pin->dpll_refs);
>+		xa_destroy(&pin->parent_refs);
>+		kfree(pin->prop.description);
>+		kfree(pin->rclk_dev_name);
>+		kfree(pin);
>+		return ERR_PTR(ret);
>+	}

This is odd flow. Just return 0 before "release" and have the goto-label
dedicated to error path only.

>+
>+	return pin;
>+}

[...]
