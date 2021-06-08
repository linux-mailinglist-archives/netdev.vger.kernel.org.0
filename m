Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B00C3A07C8
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhFHXdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:33:21 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:45909 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhFHXdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 19:33:20 -0400
Received: by mail-ot1-f54.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso9048976oto.12
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 16:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VA6HpTZTggQzmDDm2zRbyLc42cW39MJeFVBC4/t8+Aw=;
        b=Me/k+jPlkZCEGcgcxyxfIdPl94uE+KVz2Ha7HuDBW8vLwTHaATIUIOLx8QhaXFirMK
         OvThRZNN/IaIxJbwHRSVzNdWohmk46Z8gqcM5NiuzOxfHTRx4lILvpWZCTxYX/qSHWLj
         Q5brkZxCzrdsYHMqVUyeF234/M+cDYDTArEyUGOXeWdVPH5BbigYMeVCavz2v6H67AW/
         SKn7yLNyqa3TwFwqYml/YyLfWZ2iUJqjgQmN0N5rSdmeIWt44f+aGVzeN/PyR7HG/X+4
         whn70dXB1PUiv+xKTaD9SW/QjYPUJPkRZKynzqNPw5Hc/crYhoezzTZgCvtB9W2mN0PJ
         esgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VA6HpTZTggQzmDDm2zRbyLc42cW39MJeFVBC4/t8+Aw=;
        b=PCtrM5HLfOwlhIGRq0Xg2PEV8lqvp+vR8UArkXsSEskkNzfTRpYW+K/SBc/TwceS1q
         ZgYA9Tbc/6/23PM2/6OckD7b7qxRDvblkVLv7SHKK1ESl+sDerPUdGG9pP3/7QyWFxIV
         k5G+D71JLRnHxZxNLs2wMj/t7USZ5E9ETY5BQpaEO1seysaxje54xvgSuj7QjsE+Gqkx
         U7tGcDxH9znNs3f2ABHk3Bil8vrDcsI9GNIzc51z1TP1kI7myC6Kr/VyW2uOhqcPBWV/
         Z2LvjJxmRx3awa6nD49AEo0wo8dJNChUTzUfPNSe6+sL097PGlHJDLEy1HP5KBtuxxDg
         rJPA==
X-Gm-Message-State: AOAM530G1WU+o36Po/eOL7gJdaGJdPY9jUlTz2zZIrVCSgOBfHKyfWFw
        qwu1S/E4hjMS72E27xpRpBBuvUIyGUdRlXUWyTI=
X-Google-Smtp-Source: ABdhPJycT0izrj2bSw+NaiBPb/cBpm/heEoVDQCzaDxU6QMaIey7uz3Zy1R8Pfw60+RoF1+G/VQvQ2wleMKbs0ZRHtk=
X-Received: by 2002:a9d:3e5:: with SMTP id f92mr20059271otf.181.1623195027052;
 Tue, 08 Jun 2021 16:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <1623161227-29930-1-git-send-email-loic.poulain@linaro.org>
 <1623161227-29930-3-git-send-email-loic.poulain@linaro.org> <PH0PR12MB5481A464F99D1BAD60006AFEDC379@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481A464F99D1BAD60006AFEDC379@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 9 Jun 2021 02:30:15 +0300
Message-ID: <CAHNKnsSuAMK8NEAbeVT7g-Rm1a2yS1JiVwxz-5Y0x_0QxXNQow@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] rtnetlink: fill IFLA_PARENT_DEV_NAME on link dump
To:     Parav Pandit <parav@nvidia.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Parav,

On Tue, Jun 8, 2021 at 7:54 PM Parav Pandit <parav@nvidia.com> wrote:
>> From: Loic Poulain <loic.poulain@linaro.org>
>> Sent: Tuesday, June 8, 2021 7:37 PM
>>
>> From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>>
>> Return a parent device using the FLA_PARENT_DEV_NAME attribute during
>> links dump. This should help a user figure out which links belong to a
>> particular HW device. E.g. what data channels exists on a specific WWAN
>> modem.
>>
> Please add the output sample in the commit message, for this additional field possibly for a more common netdevice of a pci device or some other one.
>
>> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>> ---
>>  net/core/rtnetlink.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c index 56ac16a..120887c
>> 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -1819,6 +1819,11 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>>       if (rtnl_fill_prop_list(skb, dev))
>>               goto nla_put_failure;
>>
>> +     if (dev->dev.parent &&
>> +         nla_put_string(skb, IFLA_PARENT_DEV_NAME,
>> +                        dev_name(dev->dev.parent)))
>> +             goto nla_put_failure;
>> +
> A device name along with device bus establishes a unique identity in the system.

Sure. To uniquely identify an abstract device we need a full path,
including a device parent. In sysfs it will be a device bus. But
IFLA_PARENT_DEV_NAME was introduced to identify the parent device
within a scope of a specific subsystem, which is specified by the
IFLA_INFO_KIND attribute. IFLA_PARENT_DEV_NAME should become a sane
alternative for the IFLA_LINK usage when the link parent is not a
netdev themself.

You can find more details in the description of IFLA_PARENT_DEV_NAME
introduction patch [1], my explanation, why we need to make the
attribute common [2] and see a usage example in the wwan interface
creation patch [3].

1. https://lore.kernel.org/netdev/1623161227-29930-2-git-send-email-loic.poulain@linaro.org/
2. https://lore.kernel.org/netdev/CAHNKnsTKfFF9EckwSnLrwaPdH_tkjvdB3PVraMD-OLqFdLmp_Q@mail.gmail.com/
3. https://lore.kernel.org/netdev/1623161227-29930-4-git-send-email-loic.poulain@linaro.org/

> Hence you should add IFLA_PARENT_DEV_BUS_NAME and return it optionally if the device is on a bus.
> If (dev->dev.parent->bus)
>  return parent->bus->name string.

Looks like we are able to export the device bus name. Do you have a
use case for this attribute? And even so, should we bloat this simple
patch with auxiliary attributes?

I would even prefer that this patch was merged with the attribute
introduction patch into a single patch. This way the purpose of the
attribute will become more clear.

-- 
Sergey
