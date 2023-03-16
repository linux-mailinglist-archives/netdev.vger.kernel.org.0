Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05776BCF9E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCPMh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCPMhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:37:24 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45F6A2245
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:37:21 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so1027622wmq.1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678970240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=514h8Ll5c2ZEp3l/zYfk/oJdo5XaAivqw3cyq8ZPZSw=;
        b=bhaldaQm/jln74qCapYv4qWtRbz2JpUYOl7nJhAgaRQtWdo0utw7U6PPRr/WNU9ooN
         dkviyz7Feenie0jg+2ekmn/dWx/Fvr8ASEBufpH0kVO7bGe0a/TCqqi2je96INnirGao
         qRHprIeFmDro+yQ8ZfoxolaTbKIN+QKK1sYR28doKNZBTfrVXQ7H7PG+w2HtORe2FtOw
         0XTbf76G0iwlvLQLjZBfn0KPaUTyWnP63Coa861PBv+ck/cPuBT7VI5C2BbaFIxdIaba
         ciP8KUOHfcmZ2Xui2StYR/UfxTJlKHcIAB0bPA9r+dr1P/ZLsLRCKCGXkhmJWf2YEend
         5MCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678970240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=514h8Ll5c2ZEp3l/zYfk/oJdo5XaAivqw3cyq8ZPZSw=;
        b=HyCX0hKsQr3rG2bI4gZ2kUHQvGUZqTcFKx1qFtGyEGTLqS/+LdEtbzLK7HSpCjPNY+
         Kl73MAUnn/nIspkhsv5l8our8jHaQBRKADCE6HbrO9laYPYTzuF3I/pOdROFEyaQvtzt
         8fHu8koA+WcGguBiCaSItOOPxVsz5CrckJHHVokOLuWV15DQvq5eczENvYsNcdAJGXmM
         oGQAZ4zD54MIuoxIDUH6ZgoTlnB3nBdmtIiqPUkZxb+tykkG/rGK8MkxNCyLgj4tHSqT
         ZmOyfPQ4UC5mD/xlaboskUsRZHQ4G5rZFpd6Onh0UWbFrriLvvjRigzuhOWLjP7W7SOT
         JnIw==
X-Gm-Message-State: AO0yUKX9E6Qyy0Q0Z7NnkHLflVod966Gyz8MJXsNhEPw2WOMhFyDcfGL
        HJhdcLvB3G1pnh0heWIpKDUOhw==
X-Google-Smtp-Source: AK7set8ekJppoTaEs+bnyNw+oQE2sm8fXEl7zubfiVhYZ+bLOFl9uW5yvLguLiixXLXTFVdWY1gnVQ==
X-Received: by 2002:a05:600c:ccf:b0:3eb:36fa:b78d with SMTP id fk15-20020a05600c0ccf00b003eb36fab78dmr21637699wmb.23.1678970240433;
        Thu, 16 Mar 2023 05:37:20 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k3-20020a7bc403000000b003ed1f69c967sm4950954wmi.9.2023.03.16.05.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 05:37:19 -0700 (PDT)
Date:   Thu, 16 Mar 2023 13:37:18 +0100
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
Message-ID: <ZBMNfjJjY9TL2Vif@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Why is this mandatory? I'm now working on mlx5 implementation, don't
really know what to put here for SyncE. The type of the pin SyncE tells
all I need. I would like to avoid description fill-up.


>+		ret = -EINVAL;
>+		goto release;
>+	}
>+	pin->prop.description = kstrdup(prop->description, GFP_KERNEL);
>+	if (!pin->prop.description) {
>+		ret = -ENOMEM;
>+		goto release;
>+	}

[...]
