Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C1F1E9A78
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgEaVNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgEaVNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 17:13:34 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83493C061A0E;
        Sun, 31 May 2020 14:13:33 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id f7so7346500ejq.6;
        Sun, 31 May 2020 14:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0IbSTE/Xrv9GWB/H0hTk4DCSalmOsj/ZCdeTy2SmcfM=;
        b=XB8FIvM+yrtJQE59puzOqM28Rmq5wkc3C6lVlAuPOWX0qsAMpJt+P4qHHLY+fdB6ni
         VsqIgA8NUYiNCK4LP9aw3pLh23JFhZjLFx4pNq3o341hU/iVhLLnYhS2EZlfM9pHuz99
         6oRS8X6q0V/bXVFo4bVUZugQu+rjnj0V8BqX7XtJyTcBkkrIjkiZ1804dXdKLjhyEiC0
         c3r3A2tE2GnoIl/ciKexGXoM/FTYpMNJumdm1g30U0kLvS33MdDiwQmhJrAjY7lLES5I
         7F7RMTgeGy3GSCRstjVNRwspd7gSloz4gXJY9Cp2v5SfmLaxaoN1pQnye0vNWdfcCTdu
         Zdpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0IbSTE/Xrv9GWB/H0hTk4DCSalmOsj/ZCdeTy2SmcfM=;
        b=ii5jLIxyay9T/1H7NJFH7yFfNLdWPHSoSm5ECROMuzRBtjxDe3BKIWX8bfghqFcGvT
         DYUyWnpUw9RWQPpuXKICAgYq7TLKvHO4eeaegbO1ZKffBA4j1ebCH/YcMtiVV8YXTYx3
         7LsXH0kfRu4J0nKEXyDigP9utjSQ9PX35rTIX5abUfCfyeQJC+gdD7lEPzu6CpZgESes
         HpgLamgasDHFXGCZhTJZ0h7pQ/VggG5U8a1h3Fmd8yqIrfMT5GnJToyRNh0z9SEDDiY7
         YYT68CESrNxCjdPS2sVm3tHMW054XwKBDdlSYqC6Z2D565gay3Ju60fTfSL0V3mB2VR+
         50HQ==
X-Gm-Message-State: AOAM530Jt8nEf7BJQZENqSQBuCV1IuUC5E/eKUYFE05r5xq45NRcfbPq
        x4VGk1slvz4EW0HmGiwVsLvjnN+DibTX5WemBB8=
X-Google-Smtp-Source: ABdhPJxAzywj6vYZwVVOQwM0Sv8xAs3tPkRvO805mSmRPaatId2sGZKUECq6JqQ/ASI/W4RWS32andW1AnUgV1FayXA=
X-Received: by 2002:a17:906:e47:: with SMTP id q7mr3488598eji.279.1590959612081;
 Sun, 31 May 2020 14:13:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200531180758.1426455-1-olteanv@gmail.com> <CAHp75Vc5NrDUZwv7uW+P=Ly+tz3a9XgEukX6ZgSccj_1sMYQaw@mail.gmail.com>
In-Reply-To: <CAHp75Vc5NrDUZwv7uW+P=Ly+tz3a9XgEukX6ZgSccj_1sMYQaw@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 1 Jun 2020 00:13:21 +0300
Message-ID: <CA+h21ho-XYzWo8BqHwu9REnBVEgG2Zynuux=j_UJ8hvhXATOVA@mail.gmail.com>
Subject: Re: [PATCH v2] devres: keep both device name and resource name in
 pretty name
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "efremov@linux.com" <efremov@linux.com>,
        "ztuowen@gmail.com" <ztuowen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jun 2020 at 00:05, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>
>
>
> On Sunday, May 31, 2020, Vladimir Oltean <olteanv@gmail.com> wrote:
>>
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> Sometimes debugging a device is easiest using devmem on its register
>> map, and that can be seen with /proc/iomem. But some device drivers have
>> many memory regions. Take for example a networking switch. Its memory
>> map used to look like this in /proc/iomem:
>>
>> 1fc000000-1fc3fffff : pcie@1f0000000
>>   1fc000000-1fc3fffff : 0000:00:00.5
>>     1fc010000-1fc01ffff : sys
>>     1fc030000-1fc03ffff : rew
>>     1fc060000-1fc0603ff : s2
>>     1fc070000-1fc0701ff : devcpu_gcb
>>     1fc080000-1fc0800ff : qs
>>     1fc090000-1fc0900cb : ptp
>>     1fc100000-1fc10ffff : port0
>>     1fc110000-1fc11ffff : port1
>>     1fc120000-1fc12ffff : port2
>>     1fc130000-1fc13ffff : port3
>>     1fc140000-1fc14ffff : port4
>>     1fc150000-1fc15ffff : port5
>>     1fc200000-1fc21ffff : qsys
>>     1fc280000-1fc28ffff : ana
>>
>> But after the patch in Fixes: was applied, the information is now
>> presented in a much more opaque way:
>>
>> 1fc000000-1fc3fffff : pcie@1f0000000
>>   1fc000000-1fc3fffff : 0000:00:00.5
>>     1fc010000-1fc01ffff : 0000:00:00.5
>>     1fc030000-1fc03ffff : 0000:00:00.5
>>     1fc060000-1fc0603ff : 0000:00:00.5
>>     1fc070000-1fc0701ff : 0000:00:00.5
>>     1fc080000-1fc0800ff : 0000:00:00.5
>>     1fc090000-1fc0900cb : 0000:00:00.5
>>     1fc100000-1fc10ffff : 0000:00:00.5
>>     1fc110000-1fc11ffff : 0000:00:00.5
>>     1fc120000-1fc12ffff : 0000:00:00.5
>>     1fc130000-1fc13ffff : 0000:00:00.5
>>     1fc140000-1fc14ffff : 0000:00:00.5
>>     1fc150000-1fc15ffff : 0000:00:00.5
>>     1fc200000-1fc21ffff : 0000:00:00.5
>>     1fc280000-1fc28ffff : 0000:00:00.5
>>
>> That patch made a fair comment that /proc/iomem might be confusing when
>> it shows resources without an associated device, but we can do better
>> than just hide the resource name altogether. Namely, we can print the
>> device name _and_ the resource name. Like this:
>>
>> 1fc000000-1fc3fffff : pcie@1f0000000
>>   1fc000000-1fc3fffff : 0000:00:00.5
>>     1fc010000-1fc01ffff : 0000:00:00.5 sys
>>     1fc030000-1fc03ffff : 0000:00:00.5 rew
>>     1fc060000-1fc0603ff : 0000:00:00.5 s2
>>     1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
>>     1fc080000-1fc0800ff : 0000:00:00.5 qs
>>     1fc090000-1fc0900cb : 0000:00:00.5 ptp
>>     1fc100000-1fc10ffff : 0000:00:00.5 port0
>>     1fc110000-1fc11ffff : 0000:00:00.5 port1
>>     1fc120000-1fc12ffff : 0000:00:00.5 port2
>>     1fc130000-1fc13ffff : 0000:00:00.5 port3
>>     1fc140000-1fc14ffff : 0000:00:00.5 port4
>>     1fc150000-1fc15ffff : 0000:00:00.5 port5
>>     1fc200000-1fc21ffff : 0000:00:00.5 qsys
>>     1fc280000-1fc28ffff : 0000:00:00.5 ana
>>
>
> All of this seems an ABI change.
> But also see below.
>

Yes, indeed. What should I understand from your comment though?

>>
>> Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
>>  lib/devres.c | 17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/devres.c b/lib/devres.c
>> index 6ef51f159c54..3d67588c15a7 100644
>> --- a/lib/devres.c
>> +++ b/lib/devres.c
>> @@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
>>  {
>>         resource_size_t size;
>>         void __iomem *dest_ptr;
>> +       char *pretty_name;
>>
>>         BUG_ON(!dev);
>>
>> @@ -129,7 +130,21 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
>>
>>         size = resource_size(res);
>>
>> -       if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
>> +       if (res->name) {
>> +               int len = strlen(dev_name(dev)) + strlen(res->name) + 2;
>> +
>> +               pretty_name = devm_kzalloc(dev, len, GFP_KERNEL);
>> +               if (!pretty_name)
>> +                       return IOMEM_ERR_PTR(-ENOMEM);
>> +
>> +               sprintf(pretty_name, "%s %s", dev_name(dev), res->name);
>
>
> Reimplementing devm_kasprintf(), why?
>

Mostly because I didn't remember how it was called, thanks for pointing it out.

>>
>> +       } else {
>> +               pretty_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
>> +               if (!pretty_name)
>> +                       return IOMEM_ERR_PTR(-ENOMEM);
>> +       }
>> +
>> +       if (!devm_request_mem_region(dev, res->start, size, pretty_name)) {
>>                 dev_err(dev, "can't request region for resource %pR\n", res);
>>                 return IOMEM_ERR_PTR(-EBUSY);
>>         }
>> --
>> 2.25.1
>>
>
>
> --
> With Best Regards,
> Andy Shevchenko
>
>

Thanks,
-Vladimir
