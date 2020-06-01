Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC301EB006
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgFAULf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgFAULf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:11:35 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEF2C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 13:11:34 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id c11so9784552ljn.2
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 13:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=co62w2L5dRRlAaf0gfkaRyKQaS37VgV3kWh/LyCiC0A=;
        b=LTp78B78FUPzNGZDH/te2vXPiP7nKVzU17Gaj8GEOW0bdYmpIlf3PzV7jCp13+TSdE
         nLZFJKpDTEmi44zYR0x3x3otv9uo9F6rX5gEQnBwqe9Fjyo5kKDWLRgxF09btWvNwa11
         e7i127TXaFODgH8yXO9qHTL1BJK+alSyBM7Wx6DknGsOM6jzVlXBS951tY74z/QO8Wc1
         BOCD9LRx1KlZt36kmGRcL2REOqU+IoyXSLbU2jOOKZeVQdLgEu6bAVszzI5Cz27LfPFH
         d4DND+huG2tw3YTSFZORzHAgdYtMqlRa1l3PtRY7IYF4KYGGvvY3UdNfBVdYC1Y9qzL9
         KBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=co62w2L5dRRlAaf0gfkaRyKQaS37VgV3kWh/LyCiC0A=;
        b=ouMnRim1p8N2yzaSH2klrPYhyoL3W6TXYvpjXUztZHcEEa/F5y/uIduWCvhwsqOlUg
         TIduU8+iqCVce5ljI/4DO2ZvCzFeBAlIkZIEUhFCdH+8tlfV00LQbdIsJyD6BT1yOdJj
         imIXx71cbB8GELItz5NGWc24u8Pv1vMB4chKXCrmKI26OoanL81tHI9If6NdtJs1gDgx
         e6HmBB58BIBtwVEff31Rsx73c1ZCVOPhZHAdRqooDfLd9ridQgnK+kPtf21eCafnVjU2
         MdmlQVjqDOwB/F9uhLjCdAwXCSYHvStM+lBenJH02p9X/PFFIUJLd9Q1jNKlul9VfDka
         fntw==
X-Gm-Message-State: AOAM5304Axg3044aeJ3GNoEsJV+xzEaU9/VWBhi0lqmlBP9qWNggO71S
        XM5uW22wFBFTszaQvbv1LOAiPJODVP8=
X-Google-Smtp-Source: ABdhPJyPl907YSW3wi5UvgRT1reADuWf/6Yq5MZsui+nxmozPf69SQxYToJOn1Knvt53oXXQt9xz8g==
X-Received: by 2002:a2e:b8ce:: with SMTP id s14mr3484058ljp.89.1591042292515;
        Mon, 01 Jun 2020 13:11:32 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:42cb:40f3:c0fd:7859:f21:5d63])
        by smtp.gmail.com with ESMTPSA id u30sm109847ljd.94.2020.06.01.13.11.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jun 2020 13:11:31 -0700 (PDT)
Subject: Re: [PATCH v3] devres: keep both device name and resource name in
 pretty name
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        bgolaszewski@baylibre.com, mika.westerberg@linux.intel.com,
        efremov@linux.com, ztuowen@gmail.com,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20200601095826.1757621-1-olteanv@gmail.com>
 <7d88d376-dde7-828e-ad0a-12c0cb596ac1@cogentembedded.com>
 <CA+h21hotyQhJeMLJz5SaNc+McRF=w2m4m_qAAQV2D6phE6apkA@mail.gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <1839b906-2e1a-4340-0da8-04b603a96ca1@cogentembedded.com>
Date:   Mon, 1 Jun 2020 23:11:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hotyQhJeMLJz5SaNc+McRF=w2m4m_qAAQV2D6phE6apkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2020 11:03 PM, Vladimir Oltean wrote:
> Hi Sergei,
> 
> On Mon, 1 Jun 2020 at 21:48, Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com> wrote:
>>
>> On 06/01/2020 12:58 PM, Vladimir Oltean wrote:
>>
>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>
>>> Sometimes debugging a device is easiest using devmem on its register
>>> map, and that can be seen with /proc/iomem. But some device drivers have
>>> many memory regions. Take for example a networking switch. Its memory
>>> map used to look like this in /proc/iomem:
>>>
>>> 1fc000000-1fc3fffff : pcie@1f0000000
>>>   1fc000000-1fc3fffff : 0000:00:00.5
>>>     1fc010000-1fc01ffff : sys
>>>     1fc030000-1fc03ffff : rew
>>>     1fc060000-1fc0603ff : s2
>>>     1fc070000-1fc0701ff : devcpu_gcb
>>>     1fc080000-1fc0800ff : qs
>>>     1fc090000-1fc0900cb : ptp
>>>     1fc100000-1fc10ffff : port0
>>>     1fc110000-1fc11ffff : port1
>>>     1fc120000-1fc12ffff : port2
>>>     1fc130000-1fc13ffff : port3
>>>     1fc140000-1fc14ffff : port4
>>>     1fc150000-1fc15ffff : port5
>>>     1fc200000-1fc21ffff : qsys
>>>     1fc280000-1fc28ffff : ana
>>>
>>> But after the patch in Fixes: was applied, the information is now
>>> presented in a much more opaque way:
>>>
>>> 1fc000000-1fc3fffff : pcie@1f0000000
>>>   1fc000000-1fc3fffff : 0000:00:00.5
>>>     1fc010000-1fc01ffff : 0000:00:00.5
>>>     1fc030000-1fc03ffff : 0000:00:00.5
>>>     1fc060000-1fc0603ff : 0000:00:00.5
>>>     1fc070000-1fc0701ff : 0000:00:00.5
>>>     1fc080000-1fc0800ff : 0000:00:00.5
>>>     1fc090000-1fc0900cb : 0000:00:00.5
>>>     1fc100000-1fc10ffff : 0000:00:00.5
>>>     1fc110000-1fc11ffff : 0000:00:00.5
>>>     1fc120000-1fc12ffff : 0000:00:00.5
>>>     1fc130000-1fc13ffff : 0000:00:00.5
>>>     1fc140000-1fc14ffff : 0000:00:00.5
>>>     1fc150000-1fc15ffff : 0000:00:00.5
>>>     1fc200000-1fc21ffff : 0000:00:00.5
>>>     1fc280000-1fc28ffff : 0000:00:00.5
>>>
>>> That patch made a fair comment that /proc/iomem might be confusing when
>>> it shows resources without an associated device, but we can do better
>>> than just hide the resource name altogether. Namely, we can print the
>>> device name _and_ the resource name. Like this:
>>>
>>> 1fc000000-1fc3fffff : pcie@1f0000000
>>>   1fc000000-1fc3fffff : 0000:00:00.5
>>>     1fc010000-1fc01ffff : 0000:00:00.5 sys
>>>     1fc030000-1fc03ffff : 0000:00:00.5 rew
>>>     1fc060000-1fc0603ff : 0000:00:00.5 s2
>>>     1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
>>>     1fc080000-1fc0800ff : 0000:00:00.5 qs
>>>     1fc090000-1fc0900cb : 0000:00:00.5 ptp
>>>     1fc100000-1fc10ffff : 0000:00:00.5 port0
>>>     1fc110000-1fc11ffff : 0000:00:00.5 port1
>>>     1fc120000-1fc12ffff : 0000:00:00.5 port2
>>>     1fc130000-1fc13ffff : 0000:00:00.5 port3
>>>     1fc140000-1fc14ffff : 0000:00:00.5 port4
>>>     1fc150000-1fc15ffff : 0000:00:00.5 port5
>>>     1fc200000-1fc21ffff : 0000:00:00.5 qsys
>>>     1fc280000-1fc28ffff : 0000:00:00.5 ana
>>>
>>> Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>> Changes in v2:
>>> Checking for memory allocation errors and returning -ENOMEM.
>>>
>>> Changes in v3:
>>> Using devm_kasprintf instead of open-coding it.
>>>
>>>  lib/devres.c | 11 ++++++++++-
>>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/lib/devres.c b/lib/devres.c
>>> index 6ef51f159c54..ca0d28727cce 100644
>>> --- a/lib/devres.c
>>> +++ b/lib/devres.c
>>> @@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
>>>  {
>>>       resource_size_t size;
>>>       void __iomem *dest_ptr;
>>> +     char *pretty_name;
>>>
>>>       BUG_ON(!dev);
>>>
>>> @@ -129,7 +130,15 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
>>>
>>>       size = resource_size(res);
>>>
>>> -     if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
>>> +     if (res->name)
>>> +             pretty_name = devm_kasprintf(dev, GFP_KERNEL, "%s %s",
>>
>>    What about "%s:%s"? I suspect it'd be better on the ABI side of things?
>>
>> [...]
>>
>> MBR, Sergei
> 
> I don't have a particular preference, but out of curiosity, why would
> it be better?

   No space amidst the name.

> Thanks,
> -Vladimir

MBR, Sergei
