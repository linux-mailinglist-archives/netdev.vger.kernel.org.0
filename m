Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4A48B2D2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfHMIrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:47:20 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54024 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMIrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:47:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id 10so718262wmp.3;
        Tue, 13 Aug 2019 01:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:openpgp:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=03y8Wjx7U11up3+RZThjfaMw+lLqPQBXDguRRoaN+LY=;
        b=ncyhB6mKip2BS/qeyhDZu6RAVH1K5U/lFzQFg8QnqpsTWcpkVsPxr+kmH2ffSwT9K2
         0/5kneH0Mq6WT76DYFZPQqo7MmWMKVRIDdBkGCt+Sq1P7e+L8k8oGLGFF+0OmG8MW8ol
         zmQSfu84WwQdwqcA7nGEhMoTsW16bxKbYbM3nD276Fq9NQ6ITTik5JEqPzyvz1TuC6go
         +1rLOz5eLjWQuCKaRcCSIRR/glitHrjOXvy6GxDfdSCi3a/qts0EbLmu/P2ZHlizWoPD
         sJfSdBUYZMD7ps5PR6ttZS0GaaFIoqCGfev3H2HCNZ8G0cv+sIbcgZwJdlDi5v7Ux95z
         P1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:openpgp
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=03y8Wjx7U11up3+RZThjfaMw+lLqPQBXDguRRoaN+LY=;
        b=C16hToflD/IQ7z+TsArz7I91f6z6F36d6qpke6GCID45O4xyxxgA1Le1Pnek9dTTxj
         kfUQ9HsIdbvmbvh7a3s2mLakdpNEBu8wZW/53fEEJFRhw+prv6TkWweDFSvsgVKsg9L8
         4tKkiIqw8cZPquWciferwsLNlAJcFdXMwmtVGgk1CbknEenTjj/DKkZs4PyaxEKmC6g6
         +QwXilgjW8oP4UTauWbz+2ocSm/NXbZJBSkt3hkRx2rdgFDuM6n7k2tvnSlENTYHK2nm
         kLrFREo20h0P9ERhXgyMNrM0LuHXBE5eJ7Tj1MJL+ffJQYR1a2MByO+7QBUUGzes0tH3
         tjVQ==
X-Gm-Message-State: APjAAAWqIc6ciH9j4dZ28a/q5k2tNCNKrH5Yj0EpIX8bXde2e1Owc2e+
        bFRo9tm6n8RXdKsIjG3QSxkqMsP7
X-Google-Smtp-Source: APXvYqxydKntiX7YOVouyRug41eCWhL/ILs06ZTeA7wcYl2JOaFWwyH2oVevfaDyH3m518OCqkWTDQ==
X-Received: by 2002:a1c:18a:: with SMTP id 132mr1842163wmb.15.1565686036157;
        Tue, 13 Aug 2019 01:47:16 -0700 (PDT)
Received: from [192.168.1.35] (251.red-88-10-102.dynamicip.rima-tde.net. [88.10.102.251])
        by smtp.gmail.com with ESMTPSA id q18sm134573625wrw.36.2019.08.13.01.47.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 01:47:15 -0700 (PDT)
Subject: Re: [PATCH v4 8/9] MIPS: SGI-IP27: fix readb/writeb addressing
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:REAL TIME CLOCK (RTC) SUBSYSTEM" 
        <linux-rtc@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
 <20190809103235.16338-9-tbogendoerfer@suse.de>
 <CAHp75Vd_083R9sRsspVuJ3ZMTxpVR79PF5Lg-bpnMxRfN+b7wA@mail.gmail.com>
 <20190811072907.GA1416@kroah.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Openpgp: url=http://pgp.mit.edu/pks/lookup?op=get&search=0xE3E32C2CDEADC0DE
Message-ID: <90129235-58c2-aeed-a9d3-96f4a8f45709@amsat.org>
Date:   Tue, 13 Aug 2019 10:47:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190811072907.GA1416@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On 8/11/19 9:29 AM, Greg Kroah-Hartman wrote:
> On Sat, Aug 10, 2019 at 04:22:23PM +0300, Andy Shevchenko wrote:
>> On Fri, Aug 9, 2019 at 1:34 PM Thomas Bogendoerfer
>> <tbogendoerfer@suse.de> wrote:
>>>
>>> Our chosen byte swapping, which is what firmware already uses, is to
>>> do readl/writel by normal lw/sw intructions (data invariance). This
>>> also means we need to mangle addresses for u8 and u16 accesses. The
>>> mangling for 16bit has been done aready, but 8bit one was missing.
>>> Correcting this causes different addresses for accesses to the
>>> SuperIO and local bus of the IOC3 chip. This is fixed by changing
>>> byte order in ioc3 and m48rtc_rtc structs.
>>
>>>  /* serial port register map */
>>>  struct ioc3_serialregs {
>>> -       uint32_t        sscr;
>>> -       uint32_t        stpir;
>>> -       uint32_t        stcir;
>>> -       uint32_t        srpir;
>>> -       uint32_t        srcir;
>>> -       uint32_t        srtr;
>>> -       uint32_t        shadow;
>>> +       u32     sscr;
>>> +       u32     stpir;
>>> +       u32     stcir;
>>> +       u32     srpir;
>>> +       u32     srcir;
>>> +       u32     srtr;
>>> +       u32     shadow;
>>>  };
>>
>> Isn't it a churn? AFAIU kernel documentation the uint32_t is okay to
>> use, just be consistent inside one module / driver.
>> Am I mistaken?
> 
> No, but really it uint* shouldn't be used anywhere in the kernel source
> as it does not make sense.

If you respin your series, please send this cleanup as a separate patch.

Thanks,

Phil.
