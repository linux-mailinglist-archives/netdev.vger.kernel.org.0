Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E57C4C02E9
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 21:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbiBVUP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 15:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiBVUP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 15:15:57 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6D6111180
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 12:15:27 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id ay3so7808922plb.1
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 12:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r+waxL8yk2UxUIAsYAFB37DIbYU/0PyyGGCofJDMo2c=;
        b=YoV3bnfOrlD6R9iQxyvaYCLJN0Cxs0K6iHgcyieVaiRFtncZhE4MR/ZoSoiM/UG32V
         ovuNAakabD13cN2cVq740YDUG8XBK+2vETSa8idKmY51lwRZqbsjTEoRsO34RaBxJYjB
         P2p+9/3w4f1nDhX6yaqWyJZ5bcQHIf8oGhvg/gGqyggL18sFJIi6xDZRu299sI/RjaUE
         1TZcPNVUDpNREnaYCEe20v6uaUVQBNjp+wROHlS47oumxgQby35szfQkxsm8KdiKK1jy
         EH0tF+smGIkRNETAj9J8+Uce5b84+bjwlUrJHckKiSshWOTlHz/8usfkFZyZz7q6a2m3
         6Jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r+waxL8yk2UxUIAsYAFB37DIbYU/0PyyGGCofJDMo2c=;
        b=76FN0qC0LPFGzfpuiyp3N8+apeCUHJmdBQaJk5QUk0EAYlgdRGKS3hcJoOC9HviyPq
         oOs4yk0Ss0zakxvA8N1DVZOb95EbcHuznp20AxcxgrzPdCIBug0DiFZ+nghRdEJgEhEx
         y6fHtvALgFpD4W8KHKo2dELIg2oR3SG/ZTkcrASb7k8W/N9ZiUZWhecyBJexvJiBqmAy
         +dpUNiTk4TuDP0oagQBCkGrqAJOB2igB98mALfb47P4Utrn2Q2ES8Vk6SktqsRe1MQLX
         N2g/3nOxXBwoAU6wwBNDOt6zV0JAI+DP3xKbPldtj4fi8LeD03b4ykZTTr9P7AuFQlm0
         pG8w==
X-Gm-Message-State: AOAM532z+Rv+6+IOxqfl2do/75xWnWnpQPhFCkYKEzOjkxd+npVOoQwr
        U4xetmnk4SR7Rpr7PfQu8TM=
X-Google-Smtp-Source: ABdhPJz8uxglh4YSSVXy4XmTfUTl8okQzBMpemnMenZNpWTBcTSvwmgTXioWhVp9QKleWEfwf+f4fg==
X-Received: by 2002:a17:90b:450b:b0:1b9:256c:6c7 with SMTP id iu11-20020a17090b450b00b001b9256c06c7mr5777285pjb.33.1645560926886;
        Tue, 22 Feb 2022 12:15:26 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b14sm17928663pfm.17.2022.02.22.12.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 12:15:26 -0800 (PST)
Message-ID: <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
Date:   Tue, 22 Feb 2022 12:15:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Peter Robinson <pbrobinson@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
 <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2022 12:07 PM, Peter Robinson wrote:
>> On 2/22/2022 1:53 AM, Peter Robinson wrote:
>>> The ethtool WoL enable function wasn't checking if the device
>>> has the optional WoL IRQ and hence on platforms such as the
>>> Raspberry Pi 4 which had working ethernet prior to the last
>>> fix regressed with the last fix, so also check if we have a
>>> WoL IRQ there and return ENOTSUPP if not.
>>>
>>> Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
>>> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
>>> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
>>> Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
>>> ---
>>>    drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> We're seeing this crash on the Raspberry Pi 4 series of devices on
>>> Fedora on 5.17-rc with the top Fixes patch and wired ethernet doesn't work.
>>
>> Are you positive these two things are related to one another? The
>> transmit queue timeout means that the TX DMA interrupt is not firing up
>> what is the relationship with the absence/presence of the Wake-on-LAN
>> interrupt line?
> 
> The first test I did was revert 9deb48b53e7f and the problem went
> away, then poked at a few bits and the patch also fixes it without
> having to revert the other fix. I don't know the HW well enough to
> know more.
> 
> It seems there's other fixes/improvements that could be done around
> WOL in the driver, the bcm2711 SoC at least in the upstream DT doesn't
> support/implement a WOL IRQ, yet the RPi4 reports it supports WOL.

There is no question we can report information more accurately and your 
patch fixes that.

> 
> This fix at least makes it work again in 5.17, I think improvements
> can be looked at later by something that actually knows their way
> around the driver and IP.

I happen to be that something, or rather consider myself a someone. But 
the DTS is perfectly well written and the Wake-on-LAN interrupt is 
optional, the driver assumes as per the binding documents that the 
Wake-on-LAN is the 3rd interrupt, when available.

What I was hoping to get at is the output of /proc/interrupts for the 
good and the bad case so we can find out if by accident we end-up not 
using the appropriate interrupt number for the TX path. Not that I can 
see how that would happen, but since we have had some interesting issues 
being reported before when mixing upstream and downstream DTBs, I just 
don't fancy debugging that again:

https://www.spinics.net/lists/arm-kernel/msg947308.html
-- 
Florian
