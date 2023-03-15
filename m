Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9912B6BB955
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjCOQPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCOQPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:15:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CB7241F4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 09:14:18 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id y14so5148381wrq.4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 09:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678896855;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R4/UuPvh6kPc0vYE5U38acpKpWULJRtyaGBvdQCHFss=;
        b=F3ezDqYqm7+L1Dq0pZyRGejGx5GA9IWWL6dUyNG98pOGb0olZOEO1fhILjYU7D1tA0
         VA9PSidKhwl46wn8i4k+Xd3Cbs46KW2x4QZI2tjXL4QKMfzlMM2MZZ7Fqz9/c2C3ujQ3
         jBEX1q8XX/rTf9YyCui6pbg4UeQWsKXSV2Fm8nYIquA8t7GK4kLXaG+C9ct3fuq7ixBz
         Krcm1C9SroX9KodYD/iDNN7tsBPJi8qjawJ0yvtHWCbMMH1yWl9OKGeLfv16Tu3AkQh1
         aSsAuMSLgV5sMIJCTCtD5qY3DCyVgHFf/S2y0BhyfXuu1hRzA1QDvH2c7rGegT2d5oqM
         tN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678896855;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4/UuPvh6kPc0vYE5U38acpKpWULJRtyaGBvdQCHFss=;
        b=FqRjlx44NGSqwLUxV/00zq9FxYlQmJqqoRgO4j9YUjzz17sxqfUfXU4zcwA5C+k8iz
         asAstHbQgOe+zoWp62GKiZ9IP7S/ZpxHfAv2d6KYquM1R9Sp9O5N72CbQ2vCveysp0wH
         /tYnW/V2xOUqegfUF2bk0epB95FOEQQVymClfwK64JoqsnDQ8cOORWBm6Gl3sv3FPvjr
         YolWwTsAcHOvxQ6g+N/JaQoHtkpmy7yHp6Xu4+MpMca3+Kpli3l/CZlzz91mMPoL9SSt
         SVje2nLnpBij0bv5HquqsBoUtlM6h4t+OqJ44t/Axxbp2l/549cu0/rszNCn3owogrf8
         EPYQ==
X-Gm-Message-State: AO0yUKWky09JzpaTePRMzOBUYf6r3su5a7T2qfXpSRnUi2HGajkQUoW8
        MiA/aW/W34wV3WnhUjC6wpE=
X-Google-Smtp-Source: AK7set8Xi3dyzYhFBfvwyYpCoSxMGlVzHyPvyoR1ibL4E8KyStyQo03z7Q9GNZGbSOA68bv9vKf6Vg==
X-Received: by 2002:a5d:595d:0:b0:2ce:a3c7:d2a4 with SMTP id e29-20020a5d595d000000b002cea3c7d2a4mr2378829wri.25.1678896855451;
        Wed, 15 Mar 2023 09:14:15 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id l10-20020a5d560a000000b002cfeffb442bsm3131145wrv.57.2023.03.15.09.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 09:14:15 -0700 (PDT)
Subject: Re: [PATCH RESEND net-next v4 3/4] sfc: support unicast PTP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230314100925.12040-1-ihuguet@redhat.com>
 <20230314100925.12040-4-ihuguet@redhat.com>
 <71e22d1e-336a-8e6a-9b36-708f07c632b2@gmail.com>
 <698e750d-6e56-7fa3-99f4-e363c8fee90a@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <5c302a4b-3021-1f76-bab7-209672fb9e74@gmail.com>
Date:   Wed, 15 Mar 2023 16:14:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <698e750d-6e56-7fa3-99f4-e363c8fee90a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 08:48, Íñigo Huguet wrote:
> I've never used rhashlist, it would be a good learning exercise. How do you see if I submit that as an optimization in a future patch?

Yep, that'd be fine.  (Hence the Ack.)

>> Why does failing to insert one filter mean we need to remove *all*
>>  the unicast filters we have?  (I'm not even sure it's necessary
>>  to remove the new EVENT filter if the GENERAL filter fails.)
> 
> Well, my reasoning was that it shouldn't fail in a first place. If it does, it's something very weird. Instead of implementing more complex logic to try checking if the current state is valid or not, just remove all and try to install them again the next time. If it fails again, probably the system is not in a very good state.

I don't think any complex logic is needed - any insertion that fails
 will mean that there's no corresponding entry on the list, so next
 time we call efx_ptp_filter_exists() it'll return false and we'll
 go ahead and insert.  I.e. every state is 'valid' as long as the
 rxfilters_ucast list matches what's actually in the hardware.
