Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFAF39E9A4
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFGWdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhFGWdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:33:45 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2072BC061574;
        Mon,  7 Jun 2021 15:31:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso1004723pji.0;
        Mon, 07 Jun 2021 15:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k0Gibv+bD+eHkuXgdz7vGCoUy+Phh5uZCFsKPHQwf5M=;
        b=MjKHxcINz7f13VFJl9zJdLMjebYODWXCJZYxTECX2EifsD+MQwRvXOzVsrNlNkCiWF
         toAUorcFfi6ymdtw+8T2SLqTyjMZaV/zBhx81oTO6zNGw3Hxvi45gwh6AEI8jq7+5H3C
         a9oZY4mMjU4N1wbG7XIGAHH3KNHqDLAKXOu+EuHV0p8csXKIvVwrFY0AJtBTBP8fegwc
         G+U9P9uknhTe3mtkiG2exh/8CLBx7HPdICrwfqbrV9qT66GhBlZWzfuN08TQKj2QJRr4
         XvdH+WqBhu4XdTTf1fo8xqm/NosNF2/aN9XIE1Es4uqvNowWS+Iu47qlkMHyaKcMrvQT
         fd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k0Gibv+bD+eHkuXgdz7vGCoUy+Phh5uZCFsKPHQwf5M=;
        b=SLCWORLvJoZaq+L8nqmH1I0fIYIAZXk2WdGRjBx+wTuEzagGs7cno2dOeeqkof15mK
         FrXM8G1t1Xkg7UQ5T/t4hM5BDGgVSOXfST9RliNTb3ZiQmxCvafME5LZ+DfSZNBEz+F2
         TMbI9YnPm527E3mh1+XykGzFk3O1G+JmPjFXsmC5twd4X7tegjzID5o0x91aMPdHQWam
         FnoDWVxzPO/YaM0lCiTYWIIfypKHBlpwgwM3qXmlyUCnP+WD9Y+0OeWGFt/7i6Xj+4uJ
         JGCWf2so9NzAV+un6Y/beQWFCOz8SjfRBN/iHuCT4XB+RqFY9eGKfYMjbpg+nNEpeufT
         kDOw==
X-Gm-Message-State: AOAM532oO0NrdT3C8B0Ol3xramK5np9IWHP29PCGkrYAizH9SV89WkdW
        I/Z6JdiytqbUAtkZvU7eyeJkv7pbL3U=
X-Google-Smtp-Source: ABdhPJwZX6btJwT+NL99d7T/2jc4NnT71nM16LEm5eg/E0RtAWGCSPt0+CRkt9VulwTssCooBpN1vQ==
X-Received: by 2002:a17:90a:2f01:: with SMTP id s1mr22627089pjd.204.1623105103225;
        Mon, 07 Jun 2021 15:31:43 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w2sm9103582pfc.126.2021.06.07.15.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 15:31:42 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: b53: Do not force tagging on CPU
 port VLANs
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210607220843.3799414-1-f.fainelli@gmail.com>
 <20210607220843.3799414-2-f.fainelli@gmail.com>
 <20210607222250.zxqnwvosqeavhqhi@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7ee3b08f-c734-99fe-bd97-cddb018199c5@gmail.com>
Date:   Mon, 7 Jun 2021 15:31:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210607222250.zxqnwvosqeavhqhi@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2021 3:22 PM, Vladimir Oltean wrote:
> On Mon, Jun 07, 2021 at 03:08:42PM -0700, Florian Fainelli wrote:
>> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
>> VLANs") forced the CPU port to be always tagged in any VLAN membership.
>> This was necessary back then because we did not support Broadcom tags
>> for all configurations so the only way to differentiate tagged and
>> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
>> port into being always tagged.
>>
>> This is not necessary anymore since 8fab459e69ab ("net: dsa: b53: Enable
>> Broadcom tags for 531x5/539x families") and we can simply program what
>> we are being told now, regardless of the port being CPU or user-facing.
>>
>> Reported-by: Matthew Hagan <mnhagan88@gmail.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/dsa/b53/b53_common.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
>> index 3ca6b394dd5f..56e3b42ec28c 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -1477,7 +1477,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
>>  		untagged = true;
>>  
>>  	vl->members |= BIT(port);
>> -	if (untagged && !dsa_is_cpu_port(ds, port))
>> +	if (untagged)
>>  		vl->untag |= BIT(port);
>>  	else
>>  		vl->untag &= ~BIT(port);
>> @@ -1514,7 +1514,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>>  	if (pvid == vlan->vid)
>>  		pvid = b53_default_pvid(dev);
>>  
>> -	if (untagged && !dsa_is_cpu_port(ds, port))
>> +	if (untagged)
>>  		vl->untag &= ~(BIT(port));
>>  
>>  	b53_set_vlan_entry(dev, vlan->vid, vl);
>> -- 
>> 2.25.1
>>
> 
> Don't you want to keep this functionality for BCM5325 / BCM5365 and
> such, which still use DSA_TAG_PROTO_NONE?

Humm, in premise yes, however I am debating removing support for
5325/5365 entirely, nobody that I know of has even been trying to get
those devices to work with that driver.
-- 
Florian
