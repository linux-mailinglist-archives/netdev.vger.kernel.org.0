Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BD3584D2E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 10:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiG2ILI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 04:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiG2ILH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 04:11:07 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3237E814
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:11:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l4so5041642wrm.13
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uakZq5jjI3k3Wqdc3kNF9IpIwnGj43FMnuJpnIZFyDE=;
        b=STmqqbhOq0hT2em/dkhL5QkjUXaSR7EfXG8Iy2BQq2KYYfx/kbk2kk9NQup2XgXlsy
         6hnpnbZFrP8Bi1m1vfsT3iBEEEUK4Oebk5m3+VxqKK24lp768qyfAU7uuq1LDsbviApB
         5AwzP/MbiPk2bQ0KCDQsB/UESVe6OmWICZctS44+jm7QQlV2YVDtxIWZwKDT+/yZkIvA
         9/HhmS73O+c4eEqzOIg+Vod2v0JbZ/nKtr2pSWXO+0CH9sVuf/7NS8ESfVmYlYGd5dB1
         bReC1MO71dLOl0L4F7J16JThdc0VHJ+0xMtCzrSzk8eH3WNsUaEcMrnrZcVCjkIFAHOz
         IyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uakZq5jjI3k3Wqdc3kNF9IpIwnGj43FMnuJpnIZFyDE=;
        b=robuh2nd37eeLutHckI8dXPl0SCkkIkD4VxDCYxJsCOWHqkoyaryCvJoGF4A6fj5Lk
         6TNCCcdSgrK3aZu3VsZ842xeNhjwutCVV3MHyGIzDw+t7PNfpQWpWc5Az3OSBVX+BOhl
         opqjjPp4Qv0L8Ixw8iJ+9WGBjrl79jauPqrO7QNvRPAetv8TauGOPv/OitNyOS5WcWey
         A0bDFiUfXKGYkKnLAEwg3wGo8wCltUOqJ1tbo1KRtWfs0GYdVwiFYHIObv+PKCa7VfrS
         S1n0q7HGNtc/lHcNjkdO/KMNTXuNqtRS+VTerSJVzlSAW3/wJQfGV/PyczmYUK446DYn
         kH2w==
X-Gm-Message-State: ACgBeo3RT2DM5/than4w98tSU84UBvlHrexD0E5+OGmGOvNibSD4TwVy
        fxF7qwaCri4LrAXvvVlGAjOr8Q==
X-Google-Smtp-Source: AA6agR5kcl0wdu0ft/WBQaXd0Pq4W2Bq8UKv7WphlBoCYb04bUYj3ViuIYWJTjw6p8pHCm+gVmgOFw==
X-Received: by 2002:adf:ffc1:0:b0:21d:66a1:c3ee with SMTP id x1-20020adfffc1000000b0021d66a1c3eemr1534007wrs.364.1659082261728;
        Fri, 29 Jul 2022 01:11:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q2-20020a5d6582000000b0021e52020198sm2928398wru.61.2022.07.29.01.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 01:11:01 -0700 (PDT)
Date:   Fri, 29 Jul 2022 10:11:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Li zeming <zeming@nfschina.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/net/act: Remove temporary state variables 
Message-ID: <YuOWFM/xRaJSuX5M@nanopsycho>
References: <20220727094146.5990-1-zeming@nfschina.com>
 <20220728201556.230b9efd@kernel.org>
 <YuN+i2WtzfA0wDQb@nanopsycho>
 <20220728235121.43bedc43@kernel.org>
 <YuOFd2oqA1Cbl+at@nanopsycho>
 <20220729001842.5bc9f0b2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729001842.5bc9f0b2@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 29, 2022 at 09:18:42AM CEST, kuba@kernel.org wrote:
>On Fri, 29 Jul 2022 09:00:07 +0200 Jiri Pirko wrote:
>> >> What backports do you have in mind exactly?  
>> >
>> >Code backports. I don't understand the question.  
>> 
>> Code backports of what where?
>> Are you talking about:
>> 1) mainline kernels
>> 2) distrubutions kernels? Or even worse, in-house kernels of companies?
>> 
>> If 2), I believe it is not relevant for the upstream discussion, at all.
>
>Fixes and stable. Frankly it's just a generic justification 

Was there a significant value of breakages for net and stable backports
in past?


>to discourage people from sending subjective code cleanups.
>I'd never argue for the benefit of (2) :)

Uff, for a second, it did sound like it :)


>
>There's been a string of patches cleaning up return values
>of functions in the last few days. If people have a lot of

Well, I think it is good to send a patch to clean something up when you
spot it. If you don't do it, someone else might do it again in the
future anyway.

Plus there is one good reason at least to do this kinds of cleanups.
People tend to copy&paste code without thinking twice. So if you clean
it up here, it might not get copied into other code. That's good.


>time on their hands they should go do something useful, like
>converting netdev features to a bitmap. Hell, go fix W=1 warnings, 
>even easier.

Random spot&clean is hardly comparable to this.


>
>The time spent reviewing those "cleanups" adds up, and I suspect
>there's hundreds of places they can be applied. Hence my question
>about automation... 
