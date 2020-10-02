Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237AB2811F7
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387792AbgJBMFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgJBMFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 08:05:33 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1C9C0613D0;
        Fri,  2 Oct 2020 05:05:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id e10so525209pfj.1;
        Fri, 02 Oct 2020 05:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=w1TvZfZh4isNWotj7H9ZpgiclRpL+b6gwGNHtAMeGfA=;
        b=ffFurLmVaxtXwzcnJEaqB1gru5dm6vI+Yy2ehevm3MXFrs8meWnp0RONHY/qpj1ger
         gn6bOStiXStdWk2FP2aswkZ+LFRqEH19tfQ4LSVCPw2kwjiIH+S7+cRaBICWoqvZLZJE
         A64IP3YVBHEryefDcgtKOawzuuSQzsWzIOgQEMJMmUJE7iT4QT5JrQQzy8Vj6tg1XZip
         C3avl1yg+Lt+EAZRCwzDcfMG5rZTtaqkZOwmdXlOeBwih4EgbHbysFycZjTzKC/HmQy3
         ZNXgcObzNdT0kOd6Fbzqvt2KF7H5AZfITtfFb3aw1yu5yJLk4cDeBM5u1m2A+2Cmgs0D
         QBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=w1TvZfZh4isNWotj7H9ZpgiclRpL+b6gwGNHtAMeGfA=;
        b=Tnnkt+dRjveHHjdemKyrHNMvqv6bGZXB4E8nSTYQ3rSW/LCngXBXBs5Zy/ERKBFrrj
         6HQ13gKdbozqXpzq8NbhFtHbxfs7YeZe8KS94BhD3Rlkd0bsxYdEbVY6Hvq7wNOscQIr
         pn7HRcFwMmHZOi1an0oa6XjJoMMsFMhFRrRPnav5AwHEXs6Tm/bnyJYOf9zv+LXxvWrP
         OGA9CN5755ZbR2q8sULYOuz9xs/VO2FgNcJAYG8gISju1NEnZLOgIv+ENAvvoi8XH1Sz
         eRKm38QBkE4KCQSQxWziSAA6+TPRkmYMwjaSiAZE4XpQkcTMlwD4DHNa9+U2HYexVws5
         4fTw==
X-Gm-Message-State: AOAM531j2UtsWg5H2U/WraPsSkDNxSo9cKnVGDFVgImQB/drz7RbbX/p
        wsMK3K8VAHRf56dV8wb83zJBz9eKCYI7RV9I2TI=
X-Google-Smtp-Source: ABdhPJzgdyvn6+K1n7d3iUaIhztN8ozzw6PCYu3w2pr3T3t8cnbc9jj5J5XR82OT43GVhyoVmNILig==
X-Received: by 2002:a63:e:: with SMTP id 14mr1906638pga.426.1601640332098;
        Fri, 02 Oct 2020 05:05:32 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.217.69])
        by smtp.gmail.com with ESMTPSA id 1sm1541864pgm.4.2020.10.02.05.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 05:05:30 -0700 (PDT)
Subject: Re: [PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from
 setting uninit address
To:     Greg KH <greg@kroah.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        petkan@nucleusys.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
 <20201001.191522.1749084221364678705.davem@davemloft.net>
 <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
 <20201002115453.GA3338729@kroah.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <a19aa514-14a9-8c92-d41a-0b9e17daa8e3@gmail.com>
Date:   Fri, 2 Oct 2020 17:35:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20201002115453.GA3338729@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02-10-2020 17:24, Greg KH wrote:
> On Fri, Oct 02, 2020 at 05:04:13PM +0530, Anant Thazhemadam wrote:
>> On 02/10/20 7:45 am, David Miller wrote:
>>> From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>>> Date: Thu,  1 Oct 2020 13:02:20 +0530
>>>
>>>> When get_registers() fails (which happens when usb_control_msg() fails)
>>>> in set_ethernet_addr(), the uninitialized value of node_id gets copied
>>>> as the address.
>>>>
>>>> Checking for the return values appropriately, and handling the case
>>>> wherein set_ethernet_addr() fails like this, helps in avoiding the
>>>> mac address being incorrectly set in this manner.
>>>>
>>>> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
>>>> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
>>>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>>>> Acked-by: Petko Manolov <petkan@nucleusys.com>
>>> First, please remove "Linux-kernel-mentees" from the Subject line.
>>>
>>> All patch submitters should have their work judged equally, whoever
>>> they are.  So this Subject text gives no extra information, and it
>>> simply makes scanning Subject lines in one's mailer more difficult.
>> I will keep that in mind for all future submissions. Thank you.
>>
>>> Second, when a MAC address fails to probe a random MAC address should
>>> be selected.  We have helpers for this.  This way an interface still
>>> comes up and is usable, even in the event of a failed MAC address
>>> probe.
>> Okay... I see.
>> But this patch is about ensuring that an uninitialized variable's
>> value (whatever that may be) is not set as the ethernet address
>> blindly (without any form of checking if get_registers() worked
>> as expected, or not). And I didn't think uninitialized values being
>> set as MAC address was considered a good outcome (after all, it
>> seemed to have triggered a bug), especially when it could have
>> been avoided by introducing a simple check that doesn't break
>> anything.
> If the read from the device for the MAC address fails, don't abort the
> whole probe process and make the device not work at all, call the
> networking core to assign a random MAC address.
>
>> However, if I was mistaken, and if that is something that we can live
>> with after all, then I don't really see the understand the purpose of
>> similar checks being made (in all the many places that the return
>> value of get_registers() (or a similar function gets checked) in the first
>> place at all.
> Different values and registers determine what should be done with an
> error.  It's all relative.
>
> For this type of error, we should gracefully recover and keep on going.
> For others, maybe we just ignore the issue, or log it, or something
> else, it all depends.
>
> hope this helps,
>
> greg k-h
Yes, this clears things up for me. I'll see to it that this gets done in a v3.

Thanks,
Anant
