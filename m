Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85452581F7A
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 07:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240240AbiG0F2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 01:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiG0F2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 01:28:18 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63563DBC3;
        Tue, 26 Jul 2022 22:28:17 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id fy29so29495735ejc.12;
        Tue, 26 Jul 2022 22:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p53et6f2dSmIm5ec786uki7wKg6LtXZdHNVeRvOXgf4=;
        b=Bx9ibcauQHdAh8mnDX2ZONhdqudEQzoZ+TptnTG+nnM2zHCMVVaw0jfYOeJc4E7h3j
         Mxm5B0okv8EQTgPTJ6Vm/JY0dwdzVamjSOpWXpol2axCXL/vhHzj6rPPkGTfFD9SWORG
         ntPzOs3mqwyxDBm4q2JvmsaTbYWxn25dxzUDBj5VfI9tLDOzDf1qA3iyE2oONVniE4/i
         BwpawF9Kit27R5Dky1oZe9/WjIJh2eDsy3F2VegIdZBkrRxc2fEASZq43rc/aCB/1UUh
         uuEqo1dYMIljCviiM8d1azxgKLtt4/LBznzSt6WM0jVV73TCqJx9WOVzUMwuQNEJEJfD
         LsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p53et6f2dSmIm5ec786uki7wKg6LtXZdHNVeRvOXgf4=;
        b=4e7l9Iu8UvOlabGFekDu5y6bWMYoN3XCEU6rtNe44HBHBu362ILyz4WSah8qjNJ2Ub
         Et4tgRSnua6SRrXoC2mp0c5MQzdaNgD1Zy56OzKL8t/Qn4zJEJT/i6iHja3ydcZffVGh
         CU3v5eDakvpqS46NghwZWa8RdzzNogfwb4zMsbA0586XBfwR4zwz3RFOacO90POZwFAa
         AeYytEm+93+tMi6bxtYZTYdXX2Y3bdA4fm8kzOVFhQ94NVXbV4GZVsy6Jfh4wlY57V/F
         RtMEgTFWaYC+9dvw4lK6mOn0DYgkH+9a8eHyfejEQKivsXtasbHHxyrP2V9sf51LaweU
         O6pA==
X-Gm-Message-State: AJIora/mxb/H5h44Fj9JevoeVkGpd9iD37l4t5vuPuw/URltaXrsiUYk
        Ol9XkEZHi6FbCEd/S2I9Fnk=
X-Google-Smtp-Source: AGRyM1sSHlf3YckWfx5CdyTV7NzC8bClsvf5K0hnK6dRbclggQ3vlYwBp3vXw3zvogTZn1GiVO6IfQ==
X-Received: by 2002:a17:906:5d0b:b0:72f:b107:c09f with SMTP id g11-20020a1709065d0b00b0072fb107c09fmr16311964ejt.639.1658899696090;
        Tue, 26 Jul 2022 22:28:16 -0700 (PDT)
Received: from [192.168.0.104] ([77.126.166.31])
        by smtp.gmail.com with ESMTPSA id u14-20020a056402064e00b0043c8d7d94besm1281806edx.5.2022.07.26.22.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 22:28:15 -0700 (PDT)
Message-ID: <23d40f8c-ad5b-c908-4081-24f882514ad7@gmail.com>
Date:   Wed, 27 Jul 2022 08:28:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH] octeontx2-pf: Use only non-isolated cpus in irq
 affinity
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
References: <20220725094402.21203-1-gakula@marvell.com>
 <20220726200804.72deb465@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220726200804.72deb465@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 6:08 AM, Jakub Kicinski wrote:
> On Mon, 25 Jul 2022 15:14:02 +0530 Geetha sowjanya wrote:
>> This patch excludes the isolates cpus from the cpus list
>> while setting up TX/RX queue interrupts affinity
>>
>> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
>> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> 
> Hm, housekeeping_cpumask() looks barely used by drivers,
> do you have any references to discussions indicated drivers
> are expected to pay attention to it? Really seems like something
> that the core should take care of.
> 
> Tariq, thoughts?

I agree.
IMO this logic best fits inside the new sched API I proposed last week 
(pending Ack...), transparent to driver.

Find here:
https://lore.kernel.org/all/20220719162339.23865-2-tariqt@nvidia.com/

