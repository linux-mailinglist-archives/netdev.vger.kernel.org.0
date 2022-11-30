Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D863DA79
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiK3QYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiK3QYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:24:06 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5EE27914
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:24:01 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r26so22657623edc.10
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6dECmYVoFeM8QvkxQM+EpP0QXKcCHnjY2XXjno6msVc=;
        b=ATB9MUuPd4tV+cbC2Fo4pGLB7I7ofbtE3dJuSo07zfvZgzgxU9+ZskS1GvcyA6+pDh
         FKQ4YttslVJyjDhFkm0hQSREZtLbFwiUwA27VVMmWT6+7ZmmAy3LF94EcDepNv9tTfQG
         hMoE6PtcsIStYn1OLOvqMXtPW9ggTmg3xBsoEw2grDy5l0PhuHUG3b/LWPON+rfhD3aK
         MVv7ZLNHauQpd8mU/0Pr/egyqLNG5VPnc0eSfHJZYDT7x1ChE2iaKFxxi8SjHrSwXcMl
         rRl5skjM38bFPx8g25zkjWYK7bRbV4P6evHe5x0OmFzyTT/gj1Pd8yFw5IbWG+Sx0hZ+
         j/Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dECmYVoFeM8QvkxQM+EpP0QXKcCHnjY2XXjno6msVc=;
        b=aW7UNcmrHlcOx8KNu+d4pxclGZulr+1hXwaZ5ha7kRE7H+fQ4fUl/8vmeEzR5xY5ix
         wHchFRhTULB3r4Bskn9gOjYZK5wowyzGmwJzhGRLgfBFSdWXTAsnSVdz47PXAg6uj0VK
         7Mmk+D5r48mxrbeUOAuWi1qvfB6dU/rBbitp4pXmkMqyWbFqnJl8zqElLzd//By9Zny5
         9d2n0eiuo3ZocdLTNS2hkZfPQaNY1JUed1JHGWQQC0yw8Hr6sg3LH51IcXvU/wcGXG9v
         M/YHKN6Y7FVbX9KcE/BSLdxW3LITCExupRv+pOHk72G24VTJ5bJFqqqS5J+HnScrFYiG
         LP+w==
X-Gm-Message-State: ANoB5pkGeigogfH9osM9FR0dbxgoCxie1lkqN8eQwy9i4xS1f9505vIj
        836nuloYoLkVkDdUoMm8Z1S3Ew==
X-Google-Smtp-Source: AA0mqf4IDgDcF80Na0efP4E3n0kxN0A6261l6BDq1BohioAULXBFnQY0Jyrp8xY87DIKr11dFFFNXw==
X-Received: by 2002:aa7:c60b:0:b0:462:750b:bced with SMTP id h11-20020aa7c60b000000b00462750bbcedmr54855627edq.313.1669825439888;
        Wed, 30 Nov 2022 08:23:59 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090623ea00b00782ee6b34f2sm788580ejg.183.2022.11.30.08.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 08:23:58 -0800 (PST)
Date:   Wed, 30 Nov 2022 17:23:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <Y4eDnrFcv+Issnem@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-3-vfedorenko@novek.ru>
 <Y4d06WPsKwqeYesC@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4d06WPsKwqeYesC@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 30, 2022 at 04:21:13PM CET, jiri@resnulli.us wrote:
>Tue, Nov 29, 2022 at 10:37:22PM CET, vfedorenko@novek.ru wrote:
>>From: Vadim Fedorenko <vadfed@fb.com>

[...]

>>+struct dpll_device {
>
>Just "dpll" please. Device somehow indicates this is managing device on
>the bus. It is misleading.

Hmm, on a second thought, I think it is okay to have the "device" here.
Please ignore this comment :)
