Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E49A4C1A48
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243569AbiBWRy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243570AbiBWRy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:54:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196836439
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:54:29 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id bx9-20020a17090af48900b001bc64ee7d3cso1019149pjb.4
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UvJUz/mA/GjRr4t2uf1yXFQlkY7z4z8dctthRY1eReM=;
        b=MNIgVzYkyWRJz7cApR5sPblbvGKUX0cxDt7CNPTyN+2Kbk9AOXbBePlzXuXmHLEMa0
         B6eA8VxAskvXn0kD5L9oqKR/RWgc3pRNSZ/2Cr8YVHcd1bemgERwhKPZJkqtByjW+gm0
         BcIkM08eEnngHwMCay2DO7Sh9oocb325Fy7TTzm9xSG5hEpOXxtWiLALNv5HbeR8acO9
         nXZLvg4ygoBI4HMlLwQVmgw2YIWZT88wMvBwyxcOJ3f2Z5USDUj62OYPnzqkwoBBw/4a
         vJ1UGbPSZpuJ6i8YlwUZ8tkpMCFoVztL7V/Qnv1i1LUjdK8v442303KwwsB4KXsOhoik
         X3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UvJUz/mA/GjRr4t2uf1yXFQlkY7z4z8dctthRY1eReM=;
        b=oeDXLhv/MFepuLC01mEQRgIlzg15X2nGmXL1Y+zzB/1cbemZTUlqziGZEetLUgVO68
         rRDMNgX3GQRnEOQAm5Y1FoA6j6D5GhjICr7+RoWGtsHrgChzDuXaF166ruQNQSLYO5kG
         gTIc4a94A2qBzVvia0Xb8Qh8JS7wu4eZGvtuDAx8N7Lpdr3muJwY2QzDmC8jDe9zc2Oy
         SqQopwD6VTIeVPfSIj/xgiRNiPqIi6jhIPbNKM5MmrSC75HuB3YHAVYhZqB0NVI79pPy
         J7RrxkAhS2IQAdNKiB5ZOJorJI6ylOp8tqyyFfqX1kzNMJ4Ec/j/aN1cm4RNhHu3q925
         Ve6w==
X-Gm-Message-State: AOAM531GD7ac+9QzwY2wSpXL9F+m0F38BG8EhtscNJgqV5BZBAa/4yLJ
        M9VKGb2Fl2z1prL9VKZl7Lz3vIyLZDg=
X-Google-Smtp-Source: ABdhPJwNuynktaChxpZ2S+EYv4PnIxBDP5qdwoBNSc/aqZPDAlDLpioYmbG2rF34wJayHcj7mfOgTw==
X-Received: by 2002:a17:902:f64e:b0:14d:20db:8478 with SMTP id m14-20020a170902f64e00b0014d20db8478mr719679plg.158.1645638868552;
        Wed, 23 Feb 2022 09:54:28 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u8sm134854pgf.83.2022.02.23.09.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 09:54:28 -0800 (PST)
Message-ID: <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
Date:   Wed, 23 Feb 2022 09:54:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Peter Robinson <pbrobinson@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
 <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
 <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
 <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
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



On 2/23/2022 9:45 AM, Peter Robinson wrote:
>>> The top two are pre/post plugging an ethernet cable with the patched
>>> kernel, the last two are the broken kernel. There doesn't seem to be a
>>> massive difference in interrupts but you likely know more of what
>>> you're looking for.
>>
>> There is not a difference in the hardware interrupt numbers being
>> claimed by GENET which are both GIC interrupts 189 and 190 (157 + 32 and
>> 158 + 32). In the broken case we can see that the second interrupt line
>> (interrupt 190), which is the one that services the non-default TX
>> queues does not fire up at all whereas it does in the patched case.
>>
>> The transmit queue timeout makes sense given that transmit queue 2
>> (which is not the default one, default is 0) has its interrupt serviced
>> by the second interrupt line (190). We can see it not firing up, hence
>> the timeout.
>>
>> What I *think* might be happening here is the following:
>>
>> - priv->wol_irq = platform_get_irq_optional(pdev, 2) returns a negative
>> error code we do not install the interrupt handler for the WoL interrupt
>> since it is not valid
>>
>> - bcmgenet_set_wol() is called, we do not check priv->wol_irq, so we
>> call enable_irq_wake(priv->wol_irq) and somehow irq_set_irq_wake() is
>> able to resolve that irq number to a valid interrupt descriptor
>>
>> - eventually we just mess up the interrupt descriptor for interrupt 49
>> and it stops working
>>
>> Now since this appears to be an ACPI-enabled system, we may be hitting
>> this part of the code in platform_get_irq_optional():
>>
>>             r = platform_get_resource(dev, IORESOURCE_IRQ, num);
>>             if (has_acpi_companion(&dev->dev)) {
>>                     if (r && r->flags & IORESOURCE_DISABLED) {
>>                             ret = acpi_irq_get(ACPI_HANDLE(&dev->dev),
>> num, r);
>>                             if (ret)
>>                                     goto out;
>>                     }
>>             }
>>
>> and then I am not clear what interrupt this translates into here, or
>> whether it is possible to get a valid interrupt descriptor here.
>>
>> The patch is fine in itself, but I would really prefer that we get to
>> the bottom of this rather than have a superficial understanding of the
>> nature of the problem.
> 
> I have no problems working with you to improve the driver, the problem
> I have is this is currently a regression in 5.17 so I would like to
> see something land, whether it's reverting the other patch, landing
> thing one or another straight forward fix and then maybe revisit as
> whole in 5.18.

Understood and I won't require you or me to complete this investigating 
before fixing the regression, this is just so we understand where it 
stemmed from and possibly fix the IRQ layer if need be. Given what I 
just wrote, do you think you can sprinkle debug prints throughout the 
kernel to figure out whether enable_irq_wake() somehow messes up the 
interrupt descriptor of interrupt and test that theory? We can do that 
offline if you want.
-- 
Florian
