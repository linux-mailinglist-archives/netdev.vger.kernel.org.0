Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091356B812A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCMSu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjCMSuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:50:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CA3EC55;
        Mon, 13 Mar 2023 11:49:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so17909218pjb.3;
        Mon, 13 Mar 2023 11:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678733397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bwVFmElxaJ6pag7qpqDBgtLenVnnGYB88h3pyoscq6s=;
        b=InFM/fbA+L3yLg8B/l+4DtVQy4XpYiEIOPRzzCmgcSb+7UhB0u+xCJGb2zD7iHGcMy
         HJshMnYWlwuSaRtUDLerub+3aXaC/36Gl2JA6MRpX1uq0kSut9ui2oHyvG6ihPA3POjH
         ArFwkorB+fyILsbmWr+gXTP3zIBSP2/ox/UtX8IvKlsxLwpr0h3rsJMksXAXpPol+dfd
         uImNgIh+/2Dvu7nan0GI2R7s8ZRhdEbDezqVayw6rYzWIlGdHmsaL8ENyRrsKdVrBhcr
         o3RgkqHIW2TNQD9+IxwaXEL6EzygXzM3Zof+1K7Oh8c0w4/yf6yUf4dSc7JvYhM+UzMw
         gtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678733397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bwVFmElxaJ6pag7qpqDBgtLenVnnGYB88h3pyoscq6s=;
        b=MsrUM6t6MC+AQnQqAtdlB3vnsS9VMT4OnjE2lyBVEfvbI1ksOCWeJdSCTTetanN8HU
         WmdOo2vbQFwe3MuWBz1lCNavipcUkGEEdL/yW53PR6PoPjEaDKb/yVfgFiEZ3rH8svgd
         bTDpEKcbyL6WhmGU/BkYeFtFgggyTuzowGB7HqVKcBsHHdnM2G2lY9+7AGK75dBk55Fq
         vWsqkHGiMIXulawyiKGaXXWvNVSV8+7LuxMLvs5Z26VwIGdjdFJxN/dchBy6YzNDY0mx
         h9xotiUjuQUtRBrwYuhB+a94HYh4PBKDuH81DGC5Dg+5xfKpvwo1nkS+KE6fkecY62VB
         uX/A==
X-Gm-Message-State: AO0yUKUobsr78chi5ZkFfhZKP6jWzlN5AfmzDCqfln9hy0KxzU7gowxW
        yUynsWlFE4TvsmnLVQb8zMQ=
X-Google-Smtp-Source: AK7set/uTBIvuFtmH6Hw5vqHjmdnzr8+uwIAUybQ4l/mMs0L/zjP5Gq98eHYOxnU9PdA5SK40RFYlg==
X-Received: by 2002:a17:90a:990e:b0:233:a836:15f4 with SMTP id b14-20020a17090a990e00b00233a83615f4mr13771926pjp.1.1678733397170;
        Mon, 13 Mar 2023 11:49:57 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f55100b0019f3a28ea29sm199464plf.160.2023.03.13.11.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 11:49:56 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:49:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tianfei Zhang <tianfei.zhang@intel.com>
Cc:     netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        russell.h.weight@intel.com, matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313030239.886816-1-tianfei.zhang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 11:02:39PM -0400, Tianfei Zhang wrote:


> +static int dfl_tod_probe(struct dfl_device *ddev)
> +{
> +	struct device *dev = &ddev->dev;
> +	struct dfl_tod *dt;
> +
> +	dt = devm_kzalloc(dev, sizeof(*dt), GFP_KERNEL);
> +	if (!dt)
> +		return -ENOMEM;
> +
> +	dt->tod_ctrl = devm_ioremap_resource(dev, &ddev->mmio_res);
> +	if (IS_ERR(dt->tod_ctrl))
> +		return PTR_ERR(dt->tod_ctrl);
> +
> +	dt->dev = dev;
> +	spin_lock_init(&dt->tod_lock);
> +	dev_set_drvdata(dev, dt);
> +
> +	dt->ptp_clock_ops = dfl_tod_clock_ops;
> +
> +	dt->ptp_clock = ptp_clock_register(&dt->ptp_clock_ops, dev);
> +	if (IS_ERR(dt->ptp_clock))
> +		return dev_err_probe(dt->dev, PTR_ERR(dt->ptp_clock),
> +				     "Unable to register PTP clock\n");

Need to handle NULL as well...

/**
 * ptp_clock_register() - register a PTP hardware clock driver
 *
 * @info:   Structure describing the new clock.
 * @parent: Pointer to the parent device of the new clock.
 *
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.
 */

Thanks,
Richard

