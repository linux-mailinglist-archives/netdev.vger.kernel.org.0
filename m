Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4819D6CCE2D
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjC1Xpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjC1Xpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:45:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8732E211D;
        Tue, 28 Mar 2023 16:45:32 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a25eabf3f1so1066855ad.0;
        Tue, 28 Mar 2023 16:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680047132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wcsC89TMs/40DIXf2vcZ1a58DRyiXyVzzYB42lI7f2w=;
        b=j1jl6MeIHKYDclcvMtg6crxh2h9kwOaof761LHGakGnGzW3xJKdPZ4vRXhl6zSxjt8
         RVb+9fOXnrCNgRywWT2H+YKftkKK6hj9wdVafFHpVqF8BhVZS6BRRbRzRV6M1tea17yx
         bgemOSsRx1onpK8+vQP1A9KGiEB6uFy5Lp6YT0aIzOxZdi+NQWYTRUwcZ6lxayl/gL9H
         V9p4ZFeIGCYpApjZuISofWklN5QnnOJ+SkEYuNRzB1dp6LeQgSZjzzVs/d2KRAAgsvwp
         guVrb2oG8is+KDFQEHxGq29IckVWwcgfj80AZhN4Jqo8qc4XN9g4eBLHKIwpdV2RcldI
         harQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680047132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wcsC89TMs/40DIXf2vcZ1a58DRyiXyVzzYB42lI7f2w=;
        b=rzoxW0wBe8RUrVJd4IWvD5+SzeDtZGwF3WIKoMA+DBzfSAvCuYUE4i+Ozl0Ojakp6I
         v20IrmVRydRsAeUrS89bLPOBXhMyEEwwkO2kOOn8L+kql5zwx93LeNhc+o/4kHVEnZET
         Kcbg6kVYihFn2i0FxqRODcMckHY1dOZEiTRGp+6VFGtCcZL4gy2awrILt6o9HzLuBu2Z
         frt0rX81KC2gIYzY1JXnIO5iMf2srCcxnTpr2tjD3ocA+LKanM80E3t1WEkYtmPjMHgE
         3HBkK928T9/vPIQJv7qsghVy2bYfcYSayrAMY8rR/TNJonCVTbqcvJAMIQXfUJBPgdRW
         +Q6A==
X-Gm-Message-State: AAQBX9eKYT9eDw8l4jYeLiRKNY7K+El2XKOcXc2cjbhEE0dRCoVYhN8Q
        pan1Puwaw6P2k63ovgwiapE=
X-Google-Smtp-Source: AKy350Yy6wWamxWoUo7byfc/Mvun9eQ71grBhbBB99TAbVWU1032ssp0iKlugg9kuehgACpXjZYCdg==
X-Received: by 2002:a05:6a00:4215:b0:5db:aa2d:9ea0 with SMTP id cd21-20020a056a00421500b005dbaa2d9ea0mr14771205pfb.2.1680047132052;
        Tue, 28 Mar 2023 16:45:32 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v7-20020a62a507000000b005e5b11335b3sm21595481pfm.57.2023.03.28.16.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 16:45:31 -0700 (PDT)
Date:   Tue, 28 Mar 2023 16:45:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Tianfei Zhang <tianfei.zhang@intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-fpga@vger.kernel.org,
        Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vinicius.gomes@intel.com, pierre-louis.bossart@linux.intel.com,
        marpagan@redhat.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com, Nicolas Pitre <nico@fluxnic.net>,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZCN8Gew/PIcfo6cY@hoboy.vegasvil.org>
References: <20230328142455.481146-1-tianfei.zhang@intel.com>
 <ZCL8veyS5xNUMCCt@hoboy.vegasvil.org>
 <acd9a75d-4363-4e64-97e7-7b53cbcc9b3b@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd9a75d-4363-4e64-97e7-7b53cbcc9b3b@app.fastmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 04:48:45PM +0200, Arnd Bergmann wrote:
> Using PTP_1588_CLOCK_OPTIONAL as a dependency for PTP_DFL_TOD would
> allow enabling the driver even when PTP_1588_CLOCK is completely
> disabled, which would cleanly build but not do anything useful
> because the driver only handles PTP and not also networking.

Okay, thanks for the explanation,

Richard
