Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5DF3B014B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhFVK1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVK1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 06:27:12 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA56C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 03:24:56 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id d19so23215916oic.7
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 03:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZoLESQh3hZJz4EFv8RqAxndLJoMjBsafpxo4pfq0u8o=;
        b=NpyU9ennYly7h/nsobQYaWe21USV6U5SPIcEFkHzdMsOqid+xCuAaUfMCiyi5e1rIC
         SdHciITWOSXHoYtu/U2NqtPam98VD4gaih2uLP6iTRvk56Y59kkj5DInHSmQ5rLDAZL0
         SS1hAnldnMCaxTys5+xQ+n1MtZeNQxjDflzXgrxTfvFq4gW4QCHpgMI1SukYDoLxGG8+
         slPIFJK8Sg6QYAHcxKJ1MbfSoV30AoUnKS/5A30LmoFDZ5WRdAWd5+Vd+e7fo2b+MIHw
         54Ac+Phpq7dBjIo9Utky2io9Im7Su5KYS4n6uRx4pFYThV7ko7LNc3JDTPe7FPAxEnEC
         ISTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZoLESQh3hZJz4EFv8RqAxndLJoMjBsafpxo4pfq0u8o=;
        b=pg+s6IK0PZBLfjiWdSjyXyC7TdzMv66RO2T1UDwuJSsQO4Ak/2+9+L8KY+yaZ95NPA
         Rafg9bIEAKkWcLLdmY4V/OkhE/A0D3PqGjktkjue8lZrLEy+dvxpFLDFFHbFfoceBK3M
         D5/RPWboWm+SjQJxSuhVTaxBVR1XC7iHbfmeAVHwHbtGfX6R0P7JqQP4P2MNoVLy+bEE
         QDElp4mIXu3nQJ/XE/8K05asdlrJzBnBgOYdmFVL64FAvkMFgz0TQdQP4LHcNME0CEDx
         NXs1cnLtoXjWkzXmHH2XEZb3439q8BOGeuyFIcGDNUfp21+2HZ4z7pibsjYJ3+Q0y+qr
         nNjw==
X-Gm-Message-State: AOAM530/sEie43aYUHhW4yGvX3f0Ffb2GK79uWY226srxJ4C/YGta2/X
        NpT7u+ByaHt7qLtQ+30xA03IcK1EfK7uCGwsV5E=
X-Google-Smtp-Source: ABdhPJwXlKz7xELhwSqaZglWFx9JgXVT57BMYpLKyJ0Posfo3jXmkCCjroEjxR7QW/5qz4ncqf/JZSMhRn9KJZmd9fI=
X-Received: by 2002:a05:6808:1388:: with SMTP id c8mr2400582oiw.17.1624357494985;
 Tue, 22 Jun 2021 03:24:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210622003210.22765-1-ryazanov.s.a@gmail.com>
 <20210622003210.22765-2-ryazanov.s.a@gmail.com> <CAMZdPi9h+EzmCtn9nKE73cKZMWTP0tLLpawxiyTbVVGacHj_iw@mail.gmail.com>
In-Reply-To: <CAMZdPi9h+EzmCtn9nKE73cKZMWTP0tLLpawxiyTbVVGacHj_iw@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 22 Jun 2021 13:24:44 +0300
Message-ID: <CAHNKnsRvJHtjJStL3WRbExkfrjW349YwjPyv+YjNy1D+8c71DQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 1/2] iplink: add support for parent device
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 9:46 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> On Tue, 22 Jun 2021 at 02:32, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> Add support for specifying a parent device (struct device) by its name
>> during the link creation and printing parent name in the links list.
>> This option will be used to create WWAN links and possibly by other
>> device classes that do not have a "natural parent netdev".
>>
>> Add the parent device bus name printing for links list info
>> completeness. But do not add a corresponding command line argument, as
>> we do not have a use case for this attribute.
>>
>> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>> ---
>>  ip/ipaddress.c | 14 ++++++++++++++
>>  ip/iplink.c    |  6 +++++-
>>  2 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
>> index 06ca7273..7dc38ff1 100644
>> --- a/ip/ipaddress.c
>> +++ b/ip/ipaddress.c
>> @@ -1242,6 +1242,20 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
>>                 }
>> +
>> +               if (tb[IFLA_PARENT_DEV_BUS_NAME]) {
>> +                       print_string(PRINT_ANY,
>> +                                    "parentdevbus",
>
> Parav suggested previously to simply name it 'parentbus'.

Khm. Sounds reasonable. Will do it in V3.

>> +                                    "parentdevbus %s ",
>> +                                    rta_getattr_str(tb[IFLA_PARENT_DEV_BUS_NAME]));
>> +               }
>> +
>> +               if (tb[IFLA_PARENT_DEV_NAME]) {
>> +                       print_string(PRINT_ANY,
>> +                                    "parentdev",
>> +                                    "parentdev %s ",
>> +                                    rta_getattr_str(tb[IFLA_PARENT_DEV_NAME]));
>> +               }
>>         }

-- 
Sergey
