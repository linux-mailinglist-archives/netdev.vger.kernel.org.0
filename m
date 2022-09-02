Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987B65AB5C1
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 17:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbiIBPx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 11:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237449AbiIBPxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 11:53:41 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4698E3AD
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 08:47:38 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id l5so1764916qtv.4
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 08:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=I6DLbA6+N1avN3+xQJSnlQttqSVvWVJ9tAApzjqTJ1c=;
        b=Uhh349/XUA55qwTFjn9hG79/GPp9bRpIR1aM9LE6uhEclEy7E3Ms5nGNGPn12pa1U+
         cwUl3X/G8GdlU/hg1BNTVoVKRCaSH9EhX4iaASdKJKZW+xfrV0PFDjgPF9zBTb3aQMXH
         U5Se1p7dFFztZAerPr2FVf5CxdST4CulSB5wzHy4uzr0QKyF8S8WlLQKiHn6NmjUZTGt
         HGgygVS+ggsDNRgRQ9mLCIzxMnYZVOj1F59L/YASPAT01o9vAg7QKIE4JCLd6+hUx3/l
         3+MtrU/IDXkS5lVS+63o7DYAH/B3H+w8p75ga+AH5UCRF9DyFONp8mUSibcx5YxjBOSE
         6KzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=I6DLbA6+N1avN3+xQJSnlQttqSVvWVJ9tAApzjqTJ1c=;
        b=4PCJu+Noy5lwdp3RRhd1iSvb+3n3wilQKbtLMl5pTfF3IYYtz7IvFjLXK4Il8MfoPI
         8k9TTFga4ieuMvUg6jaMfmKsxjlTwJ/vfIUVl5fWVkQ+QF8988HL0RBL4oHD9C4ZenXJ
         16QUZlK2HOM15oI4+jq1zDeMcvWjbCZp2+UGENEtqOiypUvSIBiuM6a45WuS/FaYRvv5
         dYcOURk2qZhq0sN3q7huFEctttHFAAZWd+ATUbR7hxLpH29n1rjqOa8/75jEUcKojqCv
         iqtG6meU6ELcnTqgQNd9ZTBc6hPX9jnMx54QTvjW23TRJ0h+k5XfWmHruwphZuAMx1Lc
         BFNA==
X-Gm-Message-State: ACgBeo3iGpLCSsrRSClhW+2riluYvJMmznZenSTBsnqFIs0UxX2GDXrd
        o3LBQpqxWF+B4sf5QIMT9sA=
X-Google-Smtp-Source: AA6agR591Wl84MIxfuQdZozApxH08EIf2wfRTC/HwjmABw5la02qVQTGGjMsQWr8OLXtdqlzDhYWbQ==
X-Received: by 2002:a05:622a:1483:b0:343:7ba3:f60f with SMTP id t3-20020a05622a148300b003437ba3f60fmr28951418qtx.94.1662133657364;
        Fri, 02 Sep 2022 08:47:37 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a0bcd00b006bb82221013sm1796495qki.0.2022.09.02.08.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 08:47:36 -0700 (PDT)
Message-ID: <d4667ada-bee0-e7c8-4456-b27e30cfffd0@gmail.com>
Date:   Fri, 2 Sep 2022 08:47:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Content-Language: en-US
To:     =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
 <80f9cb5b-0e02-a367-5263-4fbffec055bb@gmail.com>
 <6703a552-8d23-6136-c0b8-c68845d00aa8@prolan.hu>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <6703a552-8d23-6136-c0b8-c68845d00aa8@prolan.hu>
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



On 9/2/2022 12:35 AM, Csókás Bence wrote:
> 
> On 2022. 09. 01. 18:26, Florian Fainelli wrote:
>>
>>>       schedule_delayed_work(&fep->time_keep, HZ);
>>>   }
>>> @@ -599,8 +593,6 @@ void fec_ptp_init(struct platform_device *pdev, 
>>> int irq_idx)
>>>       }
>>>       fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
>>> -    spin_lock_init(&fep->tmreg_lock);
>>
>> This change needs to be kept as there is no other code in the driver 
>> that would initialize the tmreg_lock otherwise. Try building a kernel 
>> with spinlock debugging enabled and you should see it barf with an 
>> incorrect spinlock bad magic.
> 
> `fec_ptp_init()` is called from `fec_probe()`, which init's the spinlock:
> 
>  > @@ -3907,7 +3908,7 @@ fec_probe(struct platform_device *pdev)
>  >         }
>  >
>  >         fep->ptp_clk_on = false;
>  > -       mutex_init(&fep->ptp_clk_mutex);
>  > +       spin_lock_init(&fep->tmreg_lock);

Ah indeed, I missed that, thanks!
-- 
Florian
