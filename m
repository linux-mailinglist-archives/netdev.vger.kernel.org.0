Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7CA4C1F31
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244104AbiBWW6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBWW6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:58:45 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB9C47575
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:58:16 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gb21so343752pjb.5
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fRzgdkP18Y2NeKsCrWyeL2/zO0mpe2rS+OnFUp7UEKQ=;
        b=XRq+lLOdrGoB3cz/Q//6ouyDTNcSTMmRYQes7ZObAS4xn4boj+vAt5mGvBFKtlq8Mx
         oKVU9SWFk83242zMpDKOpVA52weP9Zpwjss0f3sdRunkn9kxcXGKbmEqCTuqudNJdGWX
         TbXNhN3JantkxfSCrnRgMQ/jeUSHomMM1u3helYEfs4HkfwBrfYP5e9SdUjz6bcOQXQj
         F1jsUAzYcGLaCuEBizTJ2AkVnpru4fdViFcmCMtFiNIEz4pfyrWO5N9eFbIqsZ7NeT9n
         7Z+dPu4JEhqkkd8exfOAdXa9iqXXHEtVjOb7HEjXq8+3bCP5istSrEqyBwOptyERGDDG
         8kWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fRzgdkP18Y2NeKsCrWyeL2/zO0mpe2rS+OnFUp7UEKQ=;
        b=qmIzdCpOKCEVG4Id49InsSDb5YKJl+3a0ZjJm5LgtpduBAdSSfefrZWJYdWRwFrufy
         c3gTu3jKrGt9FvR5qh0MCtB8m4HOT6CwxKysv6HidR8AXegfAKWToKdaPE5UA/9yfcRZ
         V8si/gJxNA6aaAYhtKTble4WmyAd/2op8oi0mabWNw5bzfYsmveEbxQisw+6YNUvUPNu
         aWNuaQA0MNTxbpx1epwNZjoNHW9VX8zwLoE3hDYMz2xtSWOxqKarO2rq2UrwNTIkzN4V
         BYtI2tHjTTdHIiWF0DxFjqrGsJZRfVbXeMV8LcA6CeS3kHeQi5MJi8KF8CieFQpYyhul
         H1Og==
X-Gm-Message-State: AOAM531qCTLLFxKWxswBrAzt/8DFkP67gHyLo69wwLcIdmtPa3RDMC9+
        pOBiHFT8fyC5xYB4d74Q82w=
X-Google-Smtp-Source: ABdhPJwitlFr2ZQ24Y0qR0bYa4q6A5uuRsotF4PZVUJHVzmJ22ElEBMRTOOoWx+CWgogrpaas6+IVw==
X-Received: by 2002:a17:903:40ca:b0:14e:8885:1f29 with SMTP id t10-20020a17090340ca00b0014e88851f29mr1142pld.137.1645657095758;
        Wed, 23 Feb 2022 14:58:15 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id k22-20020a17090a591600b001b7f9cf30desm3794697pji.36.2022.02.23.14.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 14:58:15 -0800 (PST)
Message-ID: <6a815a39-0a0b-b3b2-443d-11370ed7d091@gmail.com>
Date:   Wed, 23 Feb 2022 14:58:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
 <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
 <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
 <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
 <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
 <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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



On 2/23/2022 2:48 PM, Jakub Kicinski wrote:
> On Wed, 23 Feb 2022 09:54:26 -0800 Florian Fainelli wrote:
>>> I have no problems working with you to improve the driver, the problem
>>> I have is this is currently a regression in 5.17 so I would like to
>>> see something land, whether it's reverting the other patch, landing
>>> thing one or another straight forward fix and then maybe revisit as
>>> whole in 5.18.
>>
>> Understood and I won't require you or me to complete this investigating
>> before fixing the regression, this is just so we understand where it
>> stemmed from and possibly fix the IRQ layer if need be. Given what I
>> just wrote, do you think you can sprinkle debug prints throughout the
>> kernel to figure out whether enable_irq_wake() somehow messes up the
>> interrupt descriptor of interrupt and test that theory? We can do that
>> offline if you want.
> 
> Let me mark v2 as Deferred for now, then. I'm not really sure if that's
> what's intended but we have 3 weeks or so until 5.17 is cut so we can
> afford a few days of investigating.
> 
> I'm likely missing the point but sounds like the IRQ subsystem treats
> IRQ numbers as unsigned so if we pass a negative value "fun" is sort
> of expected. Isn't the problem that device somehow comes with wakeup
> capable being set already? Isn't it better to make sure device is not
> wake capable if there's no WoL irq instead of adding second check?
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index cfe09117fe6c..7dea44803beb 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -4020,12 +4020,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
>   
>   	/* Request the WOL interrupt and advertise suspend if available */
>   	priv->wol_irq_disabled = true;
> -	if (priv->wol_irq > 0) {
> +	if (priv->wol_irq > 0)
>   		err = devm_request_irq(&pdev->dev, priv->wol_irq,
>   				       bcmgenet_wol_isr, 0, dev->name, priv);
> -		if (!err)
> -			device_set_wakeup_capable(&pdev->dev, 1);
> -	}
> +	else
> +		err = -ENOENT;
> +	device_set_wakeup_capable(&pdev->dev, !err);

Yes, this looks more elegant and is certainly more correct.

However there must have been something else going on with Peter's 
provided information.

We clearly did not have an interrupt registered for the Wake-on-LAN 
interrupt line as witnessed by the outputs of /proc/interrupts, however 
if we managed to go past the device_can_wakeup() check in 
bcmgenet_set_wol(), then we must have had devm_request_irq() return 
success on an invalid interrupt number or worse, botch the interrupt 
number in priv->irq1 to the point where the handler got re-installed 
maybe and we only end-up calling bcmgenet_wol_isr but no longer 
bcmgenet_isr1.. Hummm.
-- 
Florian
