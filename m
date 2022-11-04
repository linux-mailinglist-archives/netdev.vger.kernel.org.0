Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15852619C00
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiKDPqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiKDPqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:46:31 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435E43204D
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:46:29 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w4so3292343qts.0
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EMdL8frPtC09UobH5ezNbC8q6/0SO/j0tS/fg1dr0Jc=;
        b=Hqh0FSUo1VbF1hBNdCZ3rvLtSZxApntHLLOxU5MjvThqQN8+ue9vw5nDZVEn3dBspJ
         h1IvMm/PaPFrv/QRvi+wGyIRhTO5K5BGGP2Pfp/eq4l/4vei0MlAz498SCrYBoFpWNzQ
         G3Lp0IAPSzlkYCIdjoPyh6nbo42tlKvl6WuJ/naCcQlVkuy4ajpa4jl+SuiNHSDR+oRt
         qxqTtYIonBrJ5PDWyoSWenpqkAPESQ6056NjFn2tLz0eqyUgjzZAEhhNeZm+KILcn1OX
         9RdhR8PCRviKSWlF2kdrCwyGTvcHuf8tq554VY87O52BHwS383AByE9FFpZtf94fUGil
         C2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMdL8frPtC09UobH5ezNbC8q6/0SO/j0tS/fg1dr0Jc=;
        b=zWRbvixnVr/g8/Ph5EKxUKdHHpHiOAUSgtbBbiie3vFjacmmIeR2Z5jBsMlwaamTsw
         d1s8s0GOfTyqKanz9TE2cZruxpo+hu22ipChbV8OWKsS9uP5y9jxKoKfIkmOqgYRig8L
         JlM/StL3e6l5HrA6oylamSBPd9u/piizowmmORmrB934KNxXaGbnI4xd7qCU/jeL56Pl
         MyUPlhTIjUaqOd7hQSEZlBbYSau0i82gXCbjt4wJPCHyOvKjRjvGo1i2JHLrraY+Z3ha
         4oMiGMm3PJD3CCrQNjqQcSQ3DOIJOcjxo7sik+jpK+42M36qcN49rqLJB02JzKhdvxgY
         0ndw==
X-Gm-Message-State: ACrzQf0fP1LQIY18O6hw6vuR9Lt146mOxdoH1bOIXW3wTA/2DHf8y6OA
        1a09rJRqPZnKJGoTcachwDcShw==
X-Google-Smtp-Source: AMsMyM5TVwsaW5JJKdAl3ylOyp7OBqbSGw2sSssds63kvC6a4nJQvWwMLno0ew9cTNYhm72A84mZbQ==
X-Received: by 2002:a05:622a:352:b0:3a5:4f9b:2141 with SMTP id r18-20020a05622a035200b003a54f9b2141mr8570633qtw.599.1667576788422;
        Fri, 04 Nov 2022 08:46:28 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:aad6:acd8:4ed9:299b? ([2601:586:5000:570:aad6:acd8:4ed9:299b])
        by smtp.gmail.com with ESMTPSA id d11-20020a05620a240b00b006b95b0a714esm3272220qkn.17.2022.11.04.08.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 08:46:27 -0700 (PDT)
Message-ID: <2f80c103-4b35-122d-b30f-4bdd8f643a31@linaro.org>
Date:   Fri, 4 Nov 2022 11:46:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC][PATCH v3 23/33] timers: nfc: pn533: Use
 timer_shutdown_sync() before freeing timer
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chengfeng Ye <cyeaa@connect.ust.hk>, Lin Ma <linma@zju.edu.cn>,
        Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org
References: <20221104054053.431922658@goodmis.org>
 <20221104054916.096085393@goodmis.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221104054916.096085393@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2022 01:41, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Before a timer is freed, timer_shutdown_sync() must be called.
> 
> Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home/

I think link has to be updated.

Best regards,
Krzysztof

