Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D2F263486
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgIIRWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgIIRWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:22:47 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F2AC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 10:22:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w186so2546457pgb.8
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 10:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7apD7CVmi5dm0cFYLhEy/3jRiVk1Oh36VdsX+2SvrOc=;
        b=Gqr50zvHnBY1tLQDnzxbBKwwq/V/Z7H2GdRwuhgoLovPKZyALkIae66rK40mqa8K0J
         Yhw/nl3tOXds1soQEF77H6WrIwSnbFBgSzWLm2fuDWOW/bKHMGlmEogsieJNBRmRap/2
         nBebre0XlzYR6SydWmZGrp0Ov2u+d3aBvRhvjozFA7od4BhIeXI1TuYpQU4JMSoydtNW
         rQsfbaGGUSbIUByoMVUbblnttRHGYGmj3Xck1jD/jVuF+UeHjP17bpy1dWWvcLYWAQgc
         SfozkG0qb2fxQ8XJIhikKAOl1rZwnVwZbXyg7oLO2nCBczhkrkCaqejvtcziQEr9O5Z4
         OvXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7apD7CVmi5dm0cFYLhEy/3jRiVk1Oh36VdsX+2SvrOc=;
        b=DDwnB6mYeJtcL6PuP5h60lUvibik1cixGw4iAKrq7LF4kS9SOHB+A0CS+xizvq6ho8
         eKm0koY4Qt1+2pTYoYtRsxKFn3RSFfQdUzjOfv4kPHG94I68qY9ofrTt2A2fDYr6vGGB
         XQt5NpExsM+cuUVZZE5xaZpcv1WqdkZqJFBeFoRZbK5zM3EeRXIe7lKwF/ypqz8UiRZU
         3xz+NsvQ/f/PAOqyix/0tc9/6D/AbtgvR4A1gw9VgT7JQXSQeQPe4lK+mI54G0t3sfG7
         Edsmsnraegq96ilhVUxUGc1Zmt8JQTPYe5TnCspfeswuKU5Fd7LQcarBUmE7Eq9gw+A9
         3+Ig==
X-Gm-Message-State: AOAM532gnyQKRzvW+UFNerA5Kqy9dfD1tf+MFlExyAaJuVeZFIT9t6gT
        rPEOL91VeT5e6UPZ+MBwZhq3yZhh7XU=
X-Google-Smtp-Source: ABdhPJznv7RiHj3kcfBcsw4Yk9g1qy/xLfx2q6vjpG9Xg4vf8dF9sGIDj78bzI8b1Y3XZgu0ZOpTSg==
X-Received: by 2002:a63:6b08:: with SMTP id g8mr1416179pgc.325.1599672164430;
        Wed, 09 Sep 2020 10:22:44 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s6sm2559283pjn.48.2020.09.09.10.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 10:22:43 -0700 (PDT)
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
 <a5e6cb01-88d0-a479-3262-b53dec0682cd@gmail.com>
 <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
 <20200909163105.nynkw5jvwqapzx2z@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <11268219-286d-7daf-9f4e-50bdc6466469@gmail.com>
Date:   Wed, 9 Sep 2020 10:22:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200909163105.nynkw5jvwqapzx2z@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 9:31 AM, Vladimir Oltean wrote:
> On Tue, Sep 08, 2020 at 05:02:06PM -0700, Florian Fainelli wrote:
>> Found the problem, we do not allow the CPU port to be configured as
>> untagged, and when we toggle vlan_filtering we actually incorrectly "move"
>> the PVID from 1 to 0,
> 
> pvid 1 must be coming from the default_pvid of the bridge, I assume.
> Where is pvid 0 (aka dev->ports[port].pvid) coming from? Is it simply
> the cached value from B53_VLAN_PORT_DEF_TAG, from a previous
> b53_vlan_filtering() call? Strange.

The logic that writes to B53_VLAN_PORT_DEF_TAG does not update the 
shadow copy in dev->ports[port].pvid which is how they are out of sync.

> 
>> which is incorrect, but since the CPU is also untagged in VID 0 this
>> is why it "works" or rather two mistakes canceling it each other.
> 
> How does the CPU end up untagged in VLAN 0?

The CPU port gets also programmed with 0 in B53_VLAN_PORT_DEF_TAG.

> 
>> I still need to confirm this, but the bridge in VLAN filtering mode seems to
>> support receiving frames with the default_pvid as tagged, and it will untag
>> it for the bridge master device transparently.
> 
> So it seems.
> 
>> The reason for not allowing the CPU port to be untagged
>> (ca8931948344c485569b04821d1f6bcebccd376b) was because the CPU port could be
>> added as untagged in several VLANs, e.g.: when port0-3 are PVID 1 untagged,
>> and port 4 is PVID 2 untagged. Back then there was no support for Broadcom
>> tags, so the only way to differentiate traffic properly was to also add a
>> pair of tagged VIDs to the DSA master.
>> I am still trying to remember whether there were other concerns that
>> prompted me to make that change and would appreciate some thoughts on that.
> 
> I think it makes some sense to always configure the VLANs on the CPU
> port as tagged either way. I did the same in Felix and it's ok. But that
> was due to a hardware limitation. On sja1105 I'm keeping the same flags
> as on the user port, and that is ok too.

How do you make sure that the CPU port sees the frame untagged which 
would be necessary for a VLAN-unaware bridge? Do you have a special 
remapping rule?

Initially the concern I had was with the use case described above which 
was a 802.1Q separation, but in hindsight MAC address learning would 
result in the frames going to the appropriate ports/VLANs anyway.

> 
>> Tangentially, maybe we should finally add support for programming the CPU
>> port's VLAN membership independently from the other ports.
> 
> How?

Something like this:

https://lore.kernel.org/lkml/20180625091713.GA13442@apalos/T/

> 
>> The following appears to work nicely now and allows us to get rid of the
>> b53_vlan_filtering() logic, which would no longer work now because it
>> assumed that toggling vlan_filtering implied that there would be no VLAN
>> configuration when filtering was off.
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c
>> b/drivers/net/dsa/b53/b53_common.c
>> index 26fcff85d881..fac033730f4a 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -1322,23 +1322,6 @@ EXPORT_SYMBOL(b53_phylink_mac_link_up);
>>   int b53_vlan_filtering(struct dsa_switch *ds, int port, bool
>> vlan_filtering)
>>   {
>>          struct b53_device *dev = ds->priv;
>> -       u16 pvid, new_pvid;
>> -
>> -       b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
>> -       if (!vlan_filtering) {
>> -               /* Filtering is currently enabled, use the default PVID
>> since
>> -                * the bridge does not expect tagging anymore
>> -                */
>> -               dev->ports[port].pvid = pvid;
>> -               new_pvid = b53_default_pvid(dev);
>> -       } else {
>> -               /* Filtering is currently disabled, restore the previous
>> PVID */
>> -               new_pvid = dev->ports[port].pvid;
>> -       }
>> -
>> -       if (pvid != new_pvid)
>> -               b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
>> -                           new_pvid);
> 
> Yes, much simpler.
> 
>>
>>          b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
>>
>> @@ -1389,7 +1372,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
>>                          untagged = true;
>>
>>                  vl->members |= BIT(port);
>> -               if (untagged && !dsa_is_cpu_port(ds, port))
>> +               if (untagged)
>>                          vl->untag |= BIT(port);
>>                  else
>>                          vl->untag &= ~BIT(port);
>> @@ -1427,7 +1410,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>>                  if (pvid == vid)
>>                          pvid = b53_default_pvid(dev);
>>
>> -               if (untagged && !dsa_is_cpu_port(ds, port))
>> +               if (untagged)
> 
> Ok, so you're removing this workaround now. A welcome simplification.
> 
>>                          vl->untag &= ~(BIT(port));
>>
>>                  b53_set_vlan_entry(dev, vid, vl);
>> @@ -2563,6 +2546,8 @@ struct b53_device *b53_switch_alloc(struct device
>> *base,
>>          dev->priv = priv;
>>          dev->ops = ops;
>>          ds->ops = &b53_switch_ops;
>> +       ds->configure_vlan_while_not_filtering = true;
>> +       dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
>>          mutex_init(&dev->reg_mutex);
>>          mutex_init(&dev->stats_mutex);
>>
>>
>> -- 
>> Florian
> 
> Looks good!
> 
> I'm going to hold off with my configure_vlan_while_not_filtering patch.
> You can send this one before me.

That's the plan, thanks!
-- 
Florian
