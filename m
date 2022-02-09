Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DF84AEFF0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 12:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiBIL1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 06:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiBIL1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 06:27:39 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176A3E0969AF;
        Wed,  9 Feb 2022 02:21:29 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cf2so3995380edb.9;
        Wed, 09 Feb 2022 02:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HkPO0AGVSJ77TKhpfb80SADzW0ARBmPh6GNCbk7lmrM=;
        b=Pf5vkLS6cPpQ5pXhObwXKqRIi1EHsNwkjgOuOa/YseN2ddMt/AVXqIdoyJk3Ukrjc/
         sFw77R/VIC7pfahE4aRjgV8RXqj1X8wro2JHIJ3YfzkkO8yWpb+kU89Ie1QbXP7UpmmX
         C1GTdDav3TZBL+8qkGEkbE/JbNM6IKNogNBU3AYgTpYLKIDrcM08bDEEOtO2Px50SmcY
         c45e2GaAyTv+Qt9Upwv5nkTJ8UukW6CcByZB9nqiTPwPZezURGQpOGire3k/OQdhZmAF
         3b17UDq8d7C1nH2GOLo5//6O+KP8RjXZ24VsFeGf4Xsd0ejlqNjOjw63cHlmJ8hTaEwS
         PVdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HkPO0AGVSJ77TKhpfb80SADzW0ARBmPh6GNCbk7lmrM=;
        b=as3TEKYG1k0XsZ51EWJio0H0+og5wV6EC6EEPplFEfb0Ap+n6eCp0r7qMo5FGCehrm
         t4KJp/eaJi1WGsxKKwgvwcc4CALWRo4XfhYBbLEbJ+FN6AKv/ubMQjHHD7K8uo2v7Iu4
         wYK+ucb/mkLu64anFOSUSZhtpMvxabEoeR7ApMZoVsJQE85ajsVNzJyii/aSE1lu1rFQ
         GvLpIB5VD9itzkZfmyac4OR2CB3h1tSSByHKbucevZIkSt3qvqPETlp8gj/iH0oZppZS
         XFWZUm9akSCwk0kxDjhzfMUgkD+Q8bUkHiK0bBnQo9bZCnbP5I7mrtaemve2QukuG4OY
         MquQ==
X-Gm-Message-State: AOAM530idXOe9ePNk96veGk/5LMhFIzIH2H8rPVqBee3ylE9tCDYJ9Re
        TgQIzvgcwwgeQXbo/o5JC/g=
X-Google-Smtp-Source: ABdhPJxw9KX+3YSWHKExATGl3dQ+kkw3w8RMgwOuyi1zuq7fwXtnfr9xhcYUoRq5LIZGKwB30YDNxg==
X-Received: by 2002:aa7:d898:: with SMTP id u24mr1623473edq.60.1644402087635;
        Wed, 09 Feb 2022 02:21:27 -0800 (PST)
Received: from [192.168.0.108] ([77.126.86.139])
        by smtp.gmail.com with ESMTPSA id p19sm996929ejx.30.2022.02.09.02.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 02:21:27 -0800 (PST)
Message-ID: <bde548df-cb80-966a-599c-3e1cb8639716@gmail.com>
Date:   Wed, 9 Feb 2022 12:21:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [BUG] net: mellanox: mlx4: possible deadlock in mlx4_xdp_set()
 and mlx4_en_reset_config()
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, tariqt@nvidia.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4a850d04-ed6a-5802-7038-a94ad0d466c5@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <4a850d04-ed6a-5802-7038-a94ad0d466c5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 5:16 PM, Jia-Ju Bai wrote:
> Hello,
> 
> My static analysis tool reports a possible deadlock in the mlx4 driver 
> in Linux 5.16:
> 

Hi Jia-Ju,
Thanks for your email.

Which static analysis tool do you use? Is it standard one?

> mlx4_xdp_set()
>    mutex_lock(&mdev->state_lock); --> Line 2778 (Lock A)
>    mlx4_en_try_alloc_resources()
>      mlx4_en_alloc_resources()
>        mlx4_en_destroy_tx_ring()
>          mlx4_qp_free()
>            wait_for_completion(&qp->free); --> Line 528 (Wait X)

The refcount_dec_and_test(&qp->refcount)) in mlx4_qp_free() pairs with 
refcount_set(&qp->refcount, 1); in mlx4_qp_alloc.
mlx4_qp_event increases and decreasing the refcount while running 
qp->event(qp, event_type); to protect it from being freed.

> 
> mlx4_en_reset_config()
>    mutex_lock(&mdev->state_lock); --> Line 3522 (Lock A)
>    mlx4_en_try_alloc_resources()
>      mlx4_en_alloc_resources()
>        mlx4_en_destroy_tx_ring()
>          mlx4_qp_free()
>            complete(&qp->free); --> Line 527 (Wake X)
> 
> When mlx4_xdp_set() is executed, "Wait X" is performed by holding "Lock 
> A". If mlx4_en_reset_config() is executed at this time, "Wake X" cannot 
> be performed to wake up "Wait X" in mlx4_xdp_set(), because "Lock A" has 
> been already hold by mlx4_xdp_set(), causing a possible deadlock.
> 
> I am not quite sure whether this possible problem is real and how to fix 
> it if it is real.
> Any feedback would be appreciated, thanks :)
> 

Not possible.
These are two different qps, maintaining two different instances of 
refcount and complete, following the behavior I described above.
> 
> Best wishes,
> Jia-Ju Bai

Thanks,
Tariq
