Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98A825F018
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgIFTXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgIFTXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 15:23:31 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ADDC061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 12:23:29 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j7so649617plk.11
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 12:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dZ/mALwkRZ2Vwyf6mefuv3Dp8Q4+Ajn/xkw0QFpZnxw=;
        b=KAJEU0c02Yv97kcXzdmLo/u290KHGxs1GrxpdAjsE4YtJ2+kvgB38t6KflS77BIkZt
         ZuPWS5JGJIxCi60JSzRau+4St325H/NvYneqZfIA34C24ftOY8jh6RNJwMKtHSkuMIGO
         wIdQiy79+11ZJaedSghoeTWWKjJzoKnTYaL7sqFaNvcvJ1ilvu8vSFF/ft9iYG2iE33a
         wqr4hiOlSUwHWD3O+WKfYn98k92NvXV73FKQTJhnTbRkktfH5VTH0Z97xwk22yI8lUOe
         nmZOl6UVEugD1VDW932/FrBApAV2fz5U7LjVmhuBSrN7zzA9D9TjW3zmhqb6WTufnm8/
         liPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dZ/mALwkRZ2Vwyf6mefuv3Dp8Q4+Ajn/xkw0QFpZnxw=;
        b=FHR/stYD5b5EDljznCxpPEf6JYefwmltTP+WWjk5YySiHFPGr/TxlwKD4+t7vpEQOf
         OFtoWNDr0+KoYk8xMRIHaDK7VrzYML0VS04Do1hGlR7Hd3HMtGxKNzXpdTpiMt3qyS+F
         ESulwgOzNx9Q4r7aj9sT9mXWyAS7joOXGnl3H5rSqLEnxhlhckLbnou/EJ6oB5DkSN7v
         hjWs6yUantIsPmNHsKHNqaQPRhX/wbUtXQ6g5FlYEIQl7E4CgnXMUNBt5lDxSAs+1YfN
         0Xi5Ke+Kd4shGo35cMtwNe57Wgy+OrJuGLAwSn/waEkYjWyrPaoS3g/O8U8eNpx7r5+K
         d0Zg==
X-Gm-Message-State: AOAM533JVjW8/uvTbHuMG2pa6sY4mXvjq5Doqb9OCGE6M3sKAPU8BRRk
        oxbzOna8ISdRdrlutw+tHK0=
X-Google-Smtp-Source: ABdhPJzThJKyiJbu2p0VK9OwqRxjDOJ+jgan3355q54Z94jwma+rlgaVTXVZEfaiPgHk6bY/ky2Gnw==
X-Received: by 2002:a17:90a:4314:: with SMTP id q20mr17833036pjg.49.1599420206087;
        Sun, 06 Sep 2020 12:23:26 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i11sm11280383pjg.50.2020.09.06.12.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2020 12:23:25 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>, jtoppins@redhat.com,
        Netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
References: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
 <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200906111249.GA2419244@shredder.lan>
 <20200906101335.47b2b60b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Failing to attach bond(created with two interfaces from different
 NICs) to a bridge
Message-ID: <0502c0a4-0c2e-65d8-cd1e-860856510391@gmail.com>
Date:   Sun, 6 Sep 2020 12:23:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200906101335.47b2b60b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2020 10:13 AM, Jakub Kicinski wrote:
> On Sun, 6 Sep 2020 14:12:49 +0300 Ido Schimmel wrote:
>> On Thu, Sep 03, 2020 at 12:14:28PM -0700, Jakub Kicinski wrote:
>>> On Thu, 3 Sep 2020 12:52:25 +0530 Vasundhara Volam wrote:
>>>> Hello Jiri,
>>>>
>>>> After the following set of upstream commits, the user fails to attach
>>>> a bond to the bridge, if the user creates the bond with two interfaces
>>>> from different bnxt_en NICs. Previously bnxt_en driver does not
>>>> advertise the switch_id for legacy mode as part of
>>>> ndo_get_port_parent_id cb but with the following patches, switch_id is
>>>> returned even in legacy mode which is causing the failure.
>>>>
>>>> ---------------
>>>> 7e1146e8c10c00f859843817da8ecc5d902ea409 net: devlink: introduce
>>>> devlink_compat_switch_id_get() helper
>>>> 6605a226781eb1224c2dcf974a39eea11862b864 bnxt: pass switch ID through
>>>> devlink_port_attrs_set()
>>>> 56d9f4e8f70e6f47ad4da7640753cf95ae51a356 bnxt: remove
>>>> ndo_get_port_parent_id implementation for physical ports
>>>> ----------------
>>>>
>>>> As there is a plan to get rid of ndo_get_port_parent_id in future, I
>>>> think there is a need to fix devlink_compat_switch_id_get() to return
>>>> the switch_id only when device is in SWITCHDEV mode and this effects
>>>> all the NICs.
>>>>
>>>> Please let me know your thoughts. Thank you.
>>>
>>> I'm not Jiri, but I'd think that hiding switch_id from devices should
>>> not be the solution here. Especially that no NICs offload bridging
>>> today.
>>>
>>> Could you describe the team/bridge failure in detail, I'm not that
>>> familiar with this code.
>>
>> Maybe:
>>
>> br_add_slave()
>> 	br_add_if()
>> 		nbp_switchdev_mark_set()
>> 			dev_get_port_parent_id()
>>
>> I believe the last call will return '-ENODATA' because the two bnxt
>> netdevs member in the bond have different switch IDs. Perhaps the
>> function can be changed to return '-EOPNOTSUPP' when it's called for an
>> upper device that have multiple parent IDs beneath it:
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index d42c9ea0c3c0..7932594ca437 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -8646,7 +8646,7 @@ int dev_get_port_parent_id(struct net_device *dev,
>>                  if (!first.id_len)
>>                          first = *ppid;
>>                  else if (memcmp(&first, ppid, sizeof(*ppid)))
>> -                       return -ENODATA;
>> +                       return -EOPNOTSUPP;
>>          }
>>   
>>          return err;
> 
> LGTM, or we could make bridge ignore ENODATA (in case the distinctions
> is useful?)
> 
> I was searching for the early versions of Florian's patch set but
> I can't find it :( Florian, do you remember if there was a reason to
> fail bridge in this case?

v3: https://patchwork.kernel.org/patch/10798697/
v2: https://lore.kernel.org/patchwork/patch/1038907/
v1: 
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1921358.html

I went back to check the tree before 
d6abc5969463359c366d459247b90366fcd6f5c5 and the logic for return 
-ENODATA was copied from switchdev_port_attr_get():

...
           /* Switch device port(s) may be stacked under
            * bond/team/vlan dev, so recurse down to get attr on
            * each port.  Return -ENODATA if attr values don't
            * compare across ports.
            */

           netdev_for_each_lower_dev(dev, lower_dev, iter) {
                   err = switchdev_port_attr_get(lower_dev, attr);
                   if (err)
                           break;
                   if (first.id == SWITCHDEV_ATTR_ID_UNDEFINED)
                           first = *attr;
                   else if (memcmp(&first, attr, sizeof(*attr)))
                           return -ENODATA;
           }

           return err;
   }
   EXPORT_SYMBOL_GPL(switchdev_port_attr_get);

the bridge code would specifically treat -EOPNOTSUPP as success and 
return early, whereas other error code would be treated as a failure.

Jiri or Ido, do you remember the reason for return -ENODATA here?
-- 
Florian
