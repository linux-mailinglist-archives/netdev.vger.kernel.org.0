Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A52E4C19EE
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbiBWRfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiBWRfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:35:42 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C88F51E41
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:35:14 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z15so10263780pfe.7
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Mjv75NO7WogrUxzL984R+YnT4ikI0xflbq9PdNaNS8c=;
        b=LZ8Ou06fm6/+C2zSy+/YkroSwa7ZDJjeFBtADOzgbILfcDISL6clDRPgCJBrNuznhs
         vN6AZuQVuO+VvAxYmuXWgnVxZWyFqaU3o+n6Vd0ahAfAVsDEX6OU1elGHe4B/M/U6vV0
         wZwy/wk7uKe1rq5wHNlqPv89C+m9wRGfcrta85krjlMz/0USy/OG/97feKHKpYMIyRh4
         l2HMWfdYPw7fh6Sw4wDLRbHDM7uFm7ln18nT7gc3rv+NMmGwehgaNuC+1Jtlh1CWcydl
         6RjfP7k92fFig+6zhRXfYfLxTJAWshzExY5HA+xladhs3PCjTfdTWkZCKv9Hv6SXnOzJ
         lIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mjv75NO7WogrUxzL984R+YnT4ikI0xflbq9PdNaNS8c=;
        b=kTtzYF0HBhkTZw/AIXbSUngyQhzm419sPQWCc3dmvX7ROnk/DtAlVOHy6t+tgxbpJ2
         XYlCUx3+LCk9zTzHQlnaCIGRF5DrMZSEvhe/Cj9f/EBGuW2RJdjLZP+MjwDN4Bn990Ro
         KZv7JLz0mzqkHx4QjmPkOtn49RN8cpBLzm+oEuCukWQgjpb4h0giAvNcuvSu/7tpDV9P
         b9PxcQYIimjwYzPb7OMIwm3mBBWKKIpOMlyVee1tR9UeBXVlVB3+nRDLgRxc2jAvbxLg
         zC4in7wCFTLG4jhSSEnJuUJa27GZSObugIhniaoUlauEEyTGsedvkyd00OKoE/Xcwqz2
         zSBQ==
X-Gm-Message-State: AOAM5339DV1KXsuNXHbE+fv0nBWd2O9nqvK2fGF/pwL5ewYtfjYkENiB
        ftGuBNBIhqCbr5OTwFKxyqk=
X-Google-Smtp-Source: ABdhPJx6FXWykVmGUWag0n5bRpGgdpLuMR6Z0gkzFDKk3p/H09SCSSJWWKHV6yzy2xfmkdDRqE1qJQ==
X-Received: by 2002:a63:dc58:0:b0:373:a20a:29c2 with SMTP id f24-20020a63dc58000000b00373a20a29c2mr532250pgj.212.1645637712813;
        Wed, 23 Feb 2022 09:35:12 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id az22-20020a17090b029600b001bc6500625asm3464569pjb.45.2022.02.23.09.35.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 09:35:12 -0800 (PST)
Message-ID: <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
Date:   Wed, 23 Feb 2022 09:35:10 -0800
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
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
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



On 2/23/2022 3:40 AM, Peter Robinson wrote:
> On Tue, Feb 22, 2022 at 8:15 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 2/22/2022 12:07 PM, Peter Robinson wrote:
>>>> On 2/22/2022 1:53 AM, Peter Robinson wrote:
>>>>> The ethtool WoL enable function wasn't checking if the device
>>>>> has the optional WoL IRQ and hence on platforms such as the
>>>>> Raspberry Pi 4 which had working ethernet prior to the last
>>>>> fix regressed with the last fix, so also check if we have a
>>>>> WoL IRQ there and return ENOTSUPP if not.
>>>>>
>>>>> Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
>>>>> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
>>>>> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
>>>>> Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
>>>>> ---
>>>>>     drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
>>>>>     1 file changed, 4 insertions(+)
>>>>>
>>>>> We're seeing this crash on the Raspberry Pi 4 series of devices on
>>>>> Fedora on 5.17-rc with the top Fixes patch and wired ethernet doesn't work.
>>>>
>>>> Are you positive these two things are related to one another? The
>>>> transmit queue timeout means that the TX DMA interrupt is not firing up
>>>> what is the relationship with the absence/presence of the Wake-on-LAN
>>>> interrupt line?
>>>
>>> The first test I did was revert 9deb48b53e7f and the problem went
>>> away, then poked at a few bits and the patch also fixes it without
>>> having to revert the other fix. I don't know the HW well enough to
>>> know more.
>>>
>>> It seems there's other fixes/improvements that could be done around
>>> WOL in the driver, the bcm2711 SoC at least in the upstream DT doesn't
>>> support/implement a WOL IRQ, yet the RPi4 reports it supports WOL.
>>
>> There is no question we can report information more accurately and your
>> patch fixes that.
>>
>>>
>>> This fix at least makes it work again in 5.17, I think improvements
>>> can be looked at later by something that actually knows their way
>>> around the driver and IP.
>>
>> I happen to be that something, or rather consider myself a someone. But
>> the DTS is perfectly well written and the Wake-on-LAN interrupt is
>> optional, the driver assumes as per the binding documents that the
>> Wake-on-LAN is the 3rd interrupt, when available.
>>
>> What I was hoping to get at is the output of /proc/interrupts for the
>> good and the bad case so we can find out if by accident we end-up not
>> using the appropriate interrupt number for the TX path. Not that I can
>> see how that would happen, but since we have had some interesting issues
>> being reported before when mixing upstream and downstream DTBs, I just
>> don't fancy debugging that again:
> 
> The top two are pre/post plugging an ethernet cable with the patched
> kernel, the last two are the broken kernel. There doesn't seem to be a
> massive difference in interrupts but you likely know more of what
> you're looking for.

There is not a difference in the hardware interrupt numbers being 
claimed by GENET which are both GIC interrupts 189 and 190 (157 + 32 and 
158 + 32). In the broken case we can see that the second interrupt line 
(interrupt 190), which is the one that services the non-default TX 
queues does not fire up at all whereas it does in the patched case.

The transmit queue timeout makes sense given that transmit queue 2 
(which is not the default one, default is 0) has its interrupt serviced 
by the second interrupt line (190). We can see it not firing up, hence 
the timeout.

What I *think* might be happening here is the following:

- priv->wol_irq = platform_get_irq_optional(pdev, 2) returns a negative 
error code we do not install the interrupt handler for the WoL interrupt 
since it is not valid

- bcmgenet_set_wol() is called, we do not check priv->wol_irq, so we 
call enable_irq_wake(priv->wol_irq) and somehow irq_set_irq_wake() is 
able to resolve that irq number to a valid interrupt descriptor

- eventually we just mess up the interrupt descriptor for interrupt 49 
and it stops working

Now since this appears to be an ACPI-enabled system, we may be hitting 
this part of the code in platform_get_irq_optional():

           r = platform_get_resource(dev, IORESOURCE_IRQ, num);
           if (has_acpi_companion(&dev->dev)) {
                   if (r && r->flags & IORESOURCE_DISABLED) {
                           ret = acpi_irq_get(ACPI_HANDLE(&dev->dev), 
num, r);
                           if (ret)
                                   goto out;
                   }
           }

and then I am not clear what interrupt this translates into here, or 
whether it is possible to get a valid interrupt descriptor here.

The patch is fine in itself, but I would really prefer that we get to 
the bottom of this rather than have a superficial understanding of the 
nature of the problem.

Thanks for providing these dumps.
-- 
Florian
