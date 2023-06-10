Return-Path: <netdev+bounces-9787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFE572A969
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 08:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5276F1C20A5D
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 06:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B13408C7;
	Sat, 10 Jun 2023 06:35:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259561878
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 06:35:37 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3948E3AB4;
	Fri,  9 Jun 2023 23:35:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-655d1fc8ad8so2268380b3a.1;
        Fri, 09 Jun 2023 23:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686378935; x=1688970935;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EFSbkZj5+7sz5VdZAFbJYHV4A5Ae0seTfnnzDfBfHdM=;
        b=KkXbLfqsEZ0YzUHgtjm+GlyD0OlrjcsJE8y2MAkZJvOrxe+y94lSQ/nOUlFKhZozOn
         Ouyh6B4+tZwhUx0F/p0PTs2qw4/dAaDGMwqlewOg7TmTJ9JgPUFsZajWwOrFhJdRDF5E
         LkQkRjodTZLjNNtnorFXzMpGDJc6alwdSHlS8urO23oW//6OSjc10MUuFUEqOIdnjci1
         4L8u7RA4AEJqY7ykkqje5RgM2r2DOna6LDqIKVdZO5h9yPf83zKKdH0AKFrJYEvTnsJT
         ZOEVZCOpyRiacg/lSXK2YzfeYQfEn8fvLZ+ZnkcDrpEmYsBsQi4ODLvtBmtIjZLidSnA
         pe9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686378935; x=1688970935;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EFSbkZj5+7sz5VdZAFbJYHV4A5Ae0seTfnnzDfBfHdM=;
        b=KcsUUV54z/aE/uYXCliRrrJ3LcyrnHzykg74uwHVvey04EZQQJ2C5DIVbzEuAdU3uM
         Lr4uvmRd/a0MaeDNsXxqy63ISyOziSD1q4M1czdoC8AHBLt2QX4YqtOww9f2tj0M1mlS
         Xb44wiXKvU8aAXdZRI/0ELXhhG6crMINbdvoHMQHTgh/WVtTTOFTw/L87BMNsEYYaY5D
         TeDLjXqYHPLh0jm4TCppQ1jt56J+xkdVp3IAdiVUdxJhkGEBd+CmevKxbEWu6H4ix+xb
         MpD+Hu3Jnwc8D4CU5FC/ZPlVslwwBkrndUYyvsrRCqEmCMsg+2T4OTyoiFvkNbGOu8Fi
         mMoA==
X-Gm-Message-State: AC+VfDxgoj0ZZz6GxuuJtBDZ4+8bgOCtPJLjamZ7mOuZdkOIKmsb5m6j
	14OmwxNkBP2XXAwMqlhGYaI=
X-Google-Smtp-Source: ACHHUZ4Givo2p+dpDqCgdV863aZqNUC8ut50gbN/mvbWDvdT+JQn5qewuRBlafi7s458YOCMEI9sYw==
X-Received: by 2002:a05:6a00:190b:b0:647:4dee:62b7 with SMTP id y11-20020a056a00190b00b006474dee62b7mr3996252pfi.29.1686378935454;
        Fri, 09 Jun 2023 23:35:35 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id p18-20020aa78612000000b006414b2c9efasm3544492pfn.123.2023.06.09.23.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 23:35:34 -0700 (PDT)
Message-ID: <f969c91f-f7a1-bea8-ae72-67543bb3df83@gmail.com>
Date: Sat, 10 Jun 2023 13:35:30 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: Fwd: rtl8xxxu kernel module deauthenticate session from public
 open Wifi AP
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jes Sorensen <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 dbnusr495 <dbnusr4950@proton.me>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
 Linux Kernel Network Developers <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <31ab2156-e93e-4e0d-73a7-313d9d24ee6b@gmail.com>
Content-Language: en-US
In-Reply-To: <31ab2156-e93e-4e0d-73a7-313d9d24ee6b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/8/23 20:32, Bagas Sanjaya wrote:
> Hi,
> 

(also changing reporter's email to the proper one).

> I notice a bug report on Bugzilla [1]. Quoting from it:
> 
>> With Debian Sid, trying to use two different Realtek USB Wifi Adapters (with
>> Antenna).
>>
>> Using kernels including various Liquorix 6.2.x, 6.3.x , and the most recent
>>
>>     linux-image-6.3.4-1-liquorix-amd64
>>
>> also, Debian experimental
>>
>>     Debian (experimental) linux-image-6.3.0-0-amd64-unsigned
>> 6.3.5-1~exp1
>>
>>     Debian's linux-image-6.3.0-0-amd64 (Linux  6.3.0-0-amd64 #1 SMP
>> PREEMPT_DYNAMIC Debian 6.3.2-1~exp1 (2023-05-15) x86_64 GNU/Linux)
>>
>> same problem.
>>
>> At local library's public open wifi, no password required.  Using either
>>
>>     0bda:0179 (rtl8188eu) USB Wifi adapter,
>>
>> or
>>
>>     0bda:f179 (rtl8188fu) USB Wifi adapter
>>
>> Both adapters are loading
>>
>>     rtl8xxxu kernel module
>>
>> Using ( manual Wifi connection ) script , the system was able to obtain DHCP IP
>> address.  Normally, all HTTP(S) requests get redirected to a public usage
>> policy web page, where users have to click on "I agree" to continue.  Which
>> works fine with another USB adapter (mt7601 kernel module).
>>
>> However, with both Realtek adapters above, web browser will just time out, will
>> NOT even get redirect to a "Public Use Notice" web page.
>>
>> The relevant error message from system log shows
>>
>>     2023-05-15T16:57:48.491567-04:00 usrhostname kernel: wlan1: deauthenticated
>> from 7a:83:c2:8a:f1:13 (Reason: 6=CLASS2_FRAME_FROM_NONAUTH_STA)
>>
>> Apparently, the rtl8xxxu driver assumes an error condition, and immediately
>> deauthenticates and drops the Wifi connection, will not complete the
>> redirection to the "Public Use Notice" web page.
>>
>> Try to connect again, same problem, repeating itself, not allowing any
>> additional wifi traffic at all.
> 
> See Bugzilla for the full thread.
> 
> The reporter said that this is known rtl8xxxu issue (unusable on public,
> open WiFi access points [no WPA authentication?]). From his analysis:
> 
>> Let me know if I need to do anything else.  I looek at the code briefly, I belive the rtl8xxxu called a function from 802.11 layer to handle the return code (Reason code 6), which promptly call a function to deauthenticate the session, thus disconnected the device from further wifi traffic.
>>
>> I believe the 802.11 level handling is too harsh for public open AP.  However, i think the Realtek level code is too lazy.  Realtek driver code should check for reasonable return codes for situations like this and allow paasing at least a few of these before considering these as hacking attempts, which require deauthenticating, or disconnecting.  But then again, this would also be too strict for monitor mode handling of traffic.
>>
>> Don't know if 802.11 level specs even have considerations for situations like these at all, or they simply handle lower level logic and leave these things for the device drivers to cooperate with application layers to handle these.
> 
> Jes and Kalle, would you like to take a look on checking return codes
> (as reporter demands)?
> 

Hi,

FYI, from Bugzilla [1], the reporter posted (untested) fix. Would you
like to review it?

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217531#c8

-- 
An old man doll... just what I always wanted! - Clara


