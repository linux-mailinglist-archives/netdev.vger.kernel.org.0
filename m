Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B391F6BA043
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCNUBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjCNUBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:01:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A80D93E9;
        Tue, 14 Mar 2023 13:01:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so16338836pjp.2;
        Tue, 14 Mar 2023 13:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678824068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jM1ID9LcDqIM45H8MEzh+CBxaYNRYYgq6IYrxeICah4=;
        b=WnDrncbZghPhaqYD0V+AWUUzLbi28wJ50KTDsV5emYahZ8TVw+BxLl3zdDEhTvk2Ob
         2Yhy5f4ClB6sYbP+W8IWVscRT8aLQG+TTjSS5UCR1TYqvnB4msBQX4zSlv7xTGLTy05Q
         xjt+hAxnHmR0Pc+Mw8XnJEykUbqutb6VyRxXUvNFNdQUdU0g7f3SsXL1y0FMLN+XhTQC
         +QHs2FBIoaH1gUFudcGjEPE0N/m6dVHqmQyA88byNQt4+poeGS8/KoCboaCyupK4nxxt
         Pso3mcn5WFhtN8dc8rSGbWORj+oOQWoYUHcoFV0S6HZw/b4fcs7YnAd/B1KCr1CZvukP
         L8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678824068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jM1ID9LcDqIM45H8MEzh+CBxaYNRYYgq6IYrxeICah4=;
        b=Spw9gPgCp1t2qDM7ks6tmN853c2sk9BYeWcWza8BsLflaeF0A3yCEaZKrhK+ZcGtyS
         LFYlC8XaxNOaBiewF4QNPAeRjToRmj2b4rRs2UTZefcGWAnvIMxqJKm+ZoQElDpReOKt
         JXmZlq2xSSzcEmI3O/JvBbUaZsOtTjGC2JzsNrXY/ncYVcYhLv6DA/z97Wino4zmN0YJ
         ENLSS1hxyI35RzQ63ceTd7dk/weiJFKnmsaqm3lCyFnYRr7X0Bkhh9JN6lx/sYJd7jRf
         Q1dyb352v0RoCDcMGI1p5JDCJ2KGkkWAwemMl4zMbFV0xdbPyCs5RzAmf/oapCJLMcLt
         c+xg==
X-Gm-Message-State: AO0yUKUeHLrHoLZAyg5IbiippGEll2AovB0cxpgAnvmM6MQ4SqVygpLK
        Im6iE+4X7BN7+Mu40usGZ0p3KPfxQ58=
X-Google-Smtp-Source: AK7set+8GqSO+eC4lQUSdYK4LG83zTFGuJfnLoetBgVyNvZEQwgfBtsjGPEoSQj+PoPcKQbq8607Hg==
X-Received: by 2002:a17:90a:355:b0:23d:4030:d11 with SMTP id 21-20020a17090a035500b0023d40300d11mr1104061pjf.1.1678824067948;
        Tue, 14 Mar 2023 13:01:07 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z4-20020a63e544000000b004fbb4a55b64sm1949652pgj.86.2023.03.14.13.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:01:07 -0700 (PDT)
Date:   Tue, 14 Mar 2023 13:01:05 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Zhang, Tianfei" <tianfei.zhang@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBDSgVFNVqCWkbxR@hoboy.vegasvil.org>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
 <BN9PR11MB5483E675D4FA5B37B2A86F76E3BE9@BN9PR11MB5483.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5483E675D4FA5B37B2A86F76E3BE9@BN9PR11MB5483.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 07:16:28AM +0000, Zhang, Tianfei wrote:

> > Need to handle NULL as well...
> 
> It looks like that it doesn't need check NULL for ptp_clock_register(), it handle the NULL case internally and return ERR_PTR(-ENOMEM).

You aren't looking in the right place.

Go back and READ the KernelDoc that I posted and you cut from your reply.

Thanks,
Richard
