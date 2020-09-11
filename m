Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258942668FA
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgIKTjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIKTjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 15:39:04 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1572DC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 12:39:04 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bh1so1343375plb.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 12:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K9asYVYmHIcSvRpgN2yvidrLkwHqTDQA64xGFqPJzi4=;
        b=lOQn6AM4nhYN/vP/z7sCxM6j46SWZEgg6R2G+71JbAiXSBp8iCS7JWc366/hF58tfX
         7KkKfdbNINzx9JEh6km2Pm0k3GAbP5f1KLBbP5tXKDGvzNAcSsj0vrpLU/y0qcoxCPHf
         kUX+Pdrc3Yep19DNIIIM0a4YuOSMoopOUndYYuU8VsFekgPYakho85C8fE2+Wo4fOo0C
         hgv80PaRN243bvrmQfjP9AgP/QKI0SHdIu0P7wMFJ83DoTPfnNN2TgYaDW/g+sy14IwE
         MytT24n+O3FkBd6n8V8+zc1isi2MHDMabRIPXi+S2HYBwKV3RmlBdu1D6XyVh+KulIOM
         qIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K9asYVYmHIcSvRpgN2yvidrLkwHqTDQA64xGFqPJzi4=;
        b=WZqe+f94KxLSvgarXma9a4h/o2tOlFV3OnLgzCKv3X7NyMQ66gq98EyukLwRSNovGd
         dz41pH3Liz/Q8oiDlEmuPr5WbDCuNjsJeGX9Z64//FQQUfR5gbIdy616NnGUgmNAGvau
         7K3gEAXKMvPUDu81fJTheCuoG2AiHmp8lQMnGKNGiCfeSXvK5PUFdamGKecx23FtQASV
         HuwR78PRapeCmACKkw997lxB8VFeiM06bO7EF3kHySM8ACYpRaz+E762Lwbvx8UzGq5T
         h4dQnJKR5fFsZBgGkGSAeR2VGF0WyPA4p9yyQMa0RdsmAEBZToc/2ApQfijc2wdCFuQb
         GRdQ==
X-Gm-Message-State: AOAM532ra1iQwDjIEiyEp78huKjzddemjFfp0vx8J2CHWLty0KrnYDwU
        FQxHqwnGSgoHVVK9biArVgqDmO3+W9Q=
X-Google-Smtp-Source: ABdhPJzH8PlP2joQf2n0TjkltND/si4rjnaVjCkG6AoyPxHyWq+tR5CrTNwgsGFcictTGU4p4RWCfg==
X-Received: by 2002:a17:902:82c2:: with SMTP id u2mr3500476plz.129.1599853142267;
        Fri, 11 Sep 2020 12:39:02 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 63sm3064068pfw.42.2020.09.11.12.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 12:39:01 -0700 (PDT)
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
References: <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
 <20200909163105.nynkw5jvwqapzx2z@skbuf>
 <11268219-286d-7daf-9f4e-50bdc6466469@gmail.com>
 <20200909175325.bshts3hl537xtz2q@skbuf>
 <5edf3aa2-c417-e708-b259-7235de7bc8d2@gmail.com>
 <7e45b733-de6a-67c8-2e28-30a5ba84f544@gmail.com>
 <20200911000337.htwr366ng3nc3a7d@skbuf>
 <04823ca9-728f-cd06-a4b2-bb943d04321b@gmail.com>
 <20200911154340.mfe7lwtklfepd5go@skbuf>
 <b6ec9450-6b3e-0473-a2f9-b57016f010c1@gmail.com>
 <20200911183556.l3cazdcwkosyw45v@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <ac73600d-6c1d-83a3-9b49-19f853ba0226@gmail.com>
Date:   Fri, 11 Sep 2020 12:39:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200911183556.l3cazdcwkosyw45v@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/2020 11:35 AM, Vladimir Oltean wrote:
> On Fri, Sep 11, 2020 at 11:23:28AM -0700, Florian Fainelli wrote:
>> On 9/11/2020 8:43 AM, Vladimir Oltean wrote:
>>>> The slightly confusing part is that a vlan_filtering=1 bridge accepts the
>>>> default_pvid either tagged or untagged whereas a vlan_filtering=0 bridge
>>>> does not, except for DHCP for instance. I would have to add a br0.1 802.1Q
>>>> upper to take care of the default_pvid being egress tagged on the CPU port.
>>>>
>>>> We could solve this in the DSA receive path, or the Broadcom tag receive
>>>> path as you say since that is dependent on the tagging format and switch
>>>> properties.
>>>>
>>>> With Broadcom tags enabled now, all is well since we can differentiate
>>>> traffic from different source ports using that 4 bytes tag.
>>>>
>>>> Where this broke was when using a 802.1Q separation because all frames that
>>>> egressed the CPU were egress tagged and it was no longer possible to
>>>> differentiate whether they came from the LAN group in VID 1 or the WAN group
>>>> in VID 2. But all of this should be a thing of the past now, ok, all is
>>>> clear again now.
>>>
>>> Or we could do this, what do you think?
>>
>> Yes, this would be working, and I just tested it with the following delta on
>> top of my b53 patch:
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c
>> b/drivers/net/dsa/b53/b53_common.c
>> index 46ac8875f870..73507cff3bc4 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -1427,7 +1427,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
>>                          untagged = true;
>>
>>                  vl->members |= BIT(port);
>> -               if (untagged)
>> +               if (untagged && !dsa_is_cpu_port(ds, port))
>>                          vl->untag |= BIT(port);
>>                  else
>>                          vl->untag &= ~BIT(port);
>> @@ -1465,7 +1465,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>>                  if (pvid == vid)
>>                          pvid = b53_default_pvid(dev);
>>
>> -               if (untagged)
>> +               if (untagged && !dsa_is_cpu_port(ds, port))
>>                          vl->untag &= ~(BIT(port));
>>
>>                  b53_set_vlan_entry(dev, vid, vl);
>>
>> and it works, thanks!
>>
> 
> I'm conflicted. So you prefer having the CPU port as egress-tagged?

I do, because I realized that some of the switches we support are still 
configured in DSA_TAG_NONE mode because the CPU port they chose is not 
Broadcom tag capable and there is an user out there who cares a lot 
about that case not to "break".

> 
> Also, I think I'll also experiment with a version of this patch that is
> local to the DSA RX path. The bridge people may not like it, and as far
> as I understand, only DSA has this situation where pvid-tagged traffic
> may end up with a vlan tag on ingress.

OK so something along the lines of: port is bridged, and bridge has 
vlan_filtering=0 and switch does egress tagging and VID is bridge's 
default_pvid then pop the tag?

Should this be a helper function that is utilized by the relevant tagger 
drivers or do you want this in dsa_switch_rcv()?
-- 
Florian
