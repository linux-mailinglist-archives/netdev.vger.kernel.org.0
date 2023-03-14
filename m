Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9DD6B9FEF
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjCNTqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCNTqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:46:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE2033477;
        Tue, 14 Mar 2023 12:46:51 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y189so5406921pgb.10;
        Tue, 14 Mar 2023 12:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678823211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iURV2AOyYGau4vP4rS069VdtxAgygFv9QiO+hFuMu9o=;
        b=CWZRoul+rm/KlKBeiBCF9ukeErpi6C8pRVO9lJ9WxtNipbSCFEdK3q9BWnV/HGPoXR
         E66JB372oOXoRQZzd8+TUw1uEdHrskrXveWqAHz/gscMtuNGIPy+BPzvPEgtriKK1G43
         4SKYpXGvmPhhi3pcbl5UtXSBXh9hQ1sijk819TjZTu8FZ5+9O8KXJ37CDQ4tUYjCSYYb
         CORdwmCbxM6SXsw9PJvHfomRJZFZdneccC1H7CH66TWZgO3aJSCm/XAIq3aLiTO7pkdM
         DBx+8vY4uXmykwVq/XBrfngDoG6CDRLvDMpwA4mMoi/9a0uNbAHcmIt1pWse51h+chVh
         eegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678823211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iURV2AOyYGau4vP4rS069VdtxAgygFv9QiO+hFuMu9o=;
        b=nrBCeGSi4xhU79oLr1OqIpkf72lRSGRzl9z3uWQ2r1ChXPK1FLJje1XsS9z1YRPECT
         ycinmbNpQ75papolN46oPOhvzaqjVX6Xp1xUP/ww0RZXwZz98aeiE2Tu3G3f/GjSLM+U
         sOiuDXCaDEPbR17zWlNZa+qlswAEDIJL9Ugl8CaEq7i4S+SWlL5DJ3iHKTfGBzGiJVCJ
         aedLTV9l/p8UG2vTCfJ9vtLV4WCGK2c7tcAfYNxlBnqSD1IfcypGxU7bTwQvzj3slDok
         ENqxy5tg9b1W87YUlq/l69iid5nUTKWJiNt6YuTF4wg2vPV/VlGHsq/kAgONjBESOQZC
         On2g==
X-Gm-Message-State: AO0yUKVdzTeIGNBLukHxN8tQdHHftzGbwaMmyDcSBT2zJuy0HQlqhdoN
        +a1gebp+Gq7vkGV6jXpeQZqluuGp28M=
X-Google-Smtp-Source: AK7set+aqzG2i1Mz9f/pyM3Auc6uWtxMo6D+kT+V68fKNiMX0xMNgCPrp6Gv4tN6uxZDzlUDPIK8lQ==
X-Received: by 2002:aa7:8591:0:b0:625:6439:657a with SMTP id w17-20020aa78591000000b006256439657amr3047109pfn.0.1678823211127;
        Tue, 14 Mar 2023 12:46:51 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w11-20020a65534b000000b00502f1256674sm1954812pgr.41.2023.03.14.12.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 12:46:50 -0700 (PDT)
Date:   Tue, 14 Mar 2023 12:46:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Tianfei Zhang <tianfei.zhang@intel.com>, netdev@vger.kernel.org,
        linux-fpga@vger.kernel.org, ilpo.jarvinen@linux.intel.com,
        russell.h.weight@intel.com, matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBDPKA7968sWd0+P@hoboy.vegasvil.org>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
 <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 12:47:03PM +0200, Andy Shevchenko wrote:
> The semantics of the above is similar to gpiod_get_optional() and since NULL
> is a valid return in such cases, the PTP has to handle this transparently to
> the user. Otherwise it's badly designed API which has to be fixed.

Does it now?  Whatever.

> TL;DR: If I'm mistaken, I would like to know why.

git log.  git blame.

Get to know the tools of trade.

Thanks,
Richard
