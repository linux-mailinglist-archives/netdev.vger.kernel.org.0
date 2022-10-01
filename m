Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3895F1A0A
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 07:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJAFrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 01:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiJAFra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 01:47:30 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3925E2B24E
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 22:47:27 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 130-20020a1c0288000000b003b494ffc00bso5599089wmc.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 22:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Kyb2X4uCHXKuVg8roYPGr870rePi13E6LThzOWMSSjQ=;
        b=rx3qPq58caH+zXlyP5pHnDpMACOhHNsptQruEtJ6FyUlt7uxQ1aOUQHZCldHspYrE/
         CghI3aqF5hu1zsOBtfxOrNhVYnq0PMXVZplT7f6a5nIxHYL7g8PWTQ/mKOc3Ma9QSgaU
         gEIIrA5MeDB9Q5Dr1VR1s1KMnEmqP34tnNfuee27SIDDH3i/xDLv9/XxNmkSroblTy6s
         jwMdyFQfEi8GhJBtPJKdxBC/5zHYmbw3/tVq84CCwpISiwOpwY4WeNXUTeOCr02TMzo1
         KPT5n4MmJYUBN2H+hj8bPD5jfr1vs13AfQ4Wu4GW4mHAEeNb41XtJKFGpWq+N16CtH64
         t/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Kyb2X4uCHXKuVg8roYPGr870rePi13E6LThzOWMSSjQ=;
        b=wL21NZ1ISyASqSK+eCTqc3rdAvqDRCKPdksBAhNhRT87ZnZoxl+qGBRfJ0Gn58Csgc
         fUE/IrI1FgVgI9T09x+/ayZz4/ROSHEMeTVpwpwDVkxgqJ80ch0uWl0JlICuGqe6z8+y
         uRz25FcLjQQQ60HnwbRO+dmj/NuqdP1QHGaMLSJa1Q+ohm18WmzLVzfe6qGtab4II2fp
         QWN0aq/Z9fV8yC++byHRyiP9A3PnUzRbTlugVir3BGFNnuV13IllE8x1LdpB3sFrpfyM
         4alytbvhGNzX6u7Nxc13SDETIvxULogGqXGWa8qRvqztkBFLe8F7zXPhFYcs0bni3hw2
         Y8zQ==
X-Gm-Message-State: ACrzQf0iBMotbTHVUzcK7yLvJwKSqOOQIFSnwgkz88LetxUdWdGzpvMf
        HkKFgIQ7oricNBOE3I+vs7Ddwg==
X-Google-Smtp-Source: AMsMyM6KigH+LzH4Pix/cjcYO4sdy1TowdY2XSLO+trnCOI0ryHEARAOuTHYrw2xlEgzFxDGrtMihQ==
X-Received: by 2002:a05:600c:444b:b0:3b4:cb9e:bd93 with SMTP id v11-20020a05600c444b00b003b4cb9ebd93mr774148wmn.39.1664603246203;
        Fri, 30 Sep 2022 22:47:26 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c35d200b003a84375d0d1sm9405920wmq.44.2022.09.30.22.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 22:47:25 -0700 (PDT)
Date:   Sat, 1 Oct 2022 07:47:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] Create common DPLL/clock configuration API
Message-ID: <YzfUbKtWlxuq+FzI@nanopsycho>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <YzWESUXPwcCo67LP@nanopsycho>
 <6b80b6c8-29fd-4c2a-e963-1f273d866f12@novek.ru>
 <Yzap9cfSXvSLA+5y@nanopsycho>
 <20220930073312.23685d5d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930073312.23685d5d@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Sep 30, 2022 at 04:33:12PM CEST, kuba@kernel.org wrote:
>On Fri, 30 Sep 2022 10:33:57 +0200 Jiri Pirko wrote:
>> >> Also, did you consider usage of sysfs? Why it isn't a better fit than
>> >> netlink?  
>> >
>> >We already have sysfs implemented in the ptp_ocp driver. But it looks like
>> >more hardware is going to be available soon with almost the same functions,
>> >so it would be great to have common protocol to configure such devices.  
>> 
>> Sure, but more hw does not mean you can't use sysfs. Take netdev as an
>> example. The sysfs exposed for it is implemented net/core/net-sysfs.c
>> and is exposed for all netdev instances, no matter what the
>> driver/hardware is.
>
>Wait, *you* are suggesting someone uses sysfs instead of netlink?
>
>Could you say more because I feel like that's kicking the absolute.

I don't understand why that would be a problem. What I'm trying to say
is, perhaps sysfs is a better API for this purpose. The API looks very
neat and there is no probabilito of huge grow. Also, with sysfs, you
don't need userspace app to do basic work with the api. In this case, I
don't see why the app is needed. These are 2 biggest arguments for sysfs
in this case as I see it.
