Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D12F26654B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIKQ5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgIKQ5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:57:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F6DC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:57:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id jw11so1987229pjb.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xKNXCRbpfdi9S8BZPsnTLsKUoioinzp443ev3GlQVY=;
        b=DGj0BTQ0EEZqUSes7A6hUn2QsDsAHaqZVq+oPxHokbAl8NcTG8ycZcfxbTLmOASg0L
         M6lIDuVDTFX5hgmRq+0XWAAeeHJW91NbYs47S2oED9h14F3HI8ncnkU1LJGqWuZDbwfm
         RMDSdCjWnOFEHidByXwARveibgfsa+YKhZ4v148ACyF0IQiZSZEhGF9cIULKxmftExLg
         yxkHxWyLNaQgq30hOJtp0y2xenpMxA6RJ46OepX39UkNYvCsVmTPonmIGXhgGAQQU3W7
         Ows7aaayCTBrDJq9FMjLpmksYbBIZ0Ls8wDD3By9s8HtSJUCvQqj7spM55WN1WnXh6Pv
         aZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xKNXCRbpfdi9S8BZPsnTLsKUoioinzp443ev3GlQVY=;
        b=UpzyIqPm6X85Z0KzSvYAjSYdKNdH7FHGzniXbUPZ9JqmLjx9JYYGfus0PyYzJISvsr
         mPQso7ViCk79gIN6ZuKlDDmp6JphsGk6ue691WAZbhQdh4yER5Ri52qAIgXStwY2i9TJ
         5SyV1Nu+MnmwKdWTRpOHLqMuS1z3BJxJgLITRRG8qJvop10Uy49aIOg86nwxfv1VZjUd
         U95UsuF1U8kxg6dygxtLFlyqq41g+lMU+Hi17YwIktM358jj/IU4d2ao+MP3iVWNS3D2
         FVsb6NjIv6T+KAOQkSeYELk15+QOt/v/gKo6e0VuL5WefoCOeJo1Lh/4NZjBTd/+B1S1
         nAOA==
X-Gm-Message-State: AOAM530Idxl+VR6FUxfXyLTspP+v+hcCDtYpPQ4JLehWE7YOOBzVAaQ5
        Eeq+tvsOEh3Paig8YdMW9d8=
X-Google-Smtp-Source: ABdhPJyLHCvDFhDL5f9hXVNTRqMKK2zVG14Da8y033knl2er8z3D7OlGJIHi1VLcK+9753Bb5uNPzw==
X-Received: by 2002:a17:90a:fb52:: with SMTP id iq18mr3089782pjb.162.1599843452072;
        Fri, 11 Sep 2020 09:57:32 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s8sm3089067pfd.153.2020.09.11.09.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 09:57:31 -0700 (PDT)
Subject: Re: VLAN filtering with DSA
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
 <a5e0a066-0193-beca-7773-5933d48696e8@gmail.com>
 <20200911132058.GA3154432@shredder> <20200911163042.u5xegcsfpwzh6zkf@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <64168d1e-1f37-c2d6-fd67-19fc9071fc48@gmail.com>
Date:   Fri, 11 Sep 2020 09:57:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200911163042.u5xegcsfpwzh6zkf@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/2020 9:30 AM, Vladimir Oltean wrote:
> On Fri, Sep 11, 2020 at 04:20:58PM +0300, Ido Schimmel wrote:
>> On Thu, Sep 10, 2020 at 11:41:04AM -0700, Florian Fainelli wrote:
>>> +Ido,
>>>
>>> On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
>>>> Florian, can you please reiterate what is the problem with calling
>>>> vlan_vid_add() with a VLAN that is installed by the bridge?
>>>>
>>>> The effect of vlan_vid_add(), to my knowledge, is that the network
>>>> interface should add this VLAN to its filtering table, and not drop it.
>>>> So why return -EBUSY?
>>
>> Can you clarify when you return -EBUSY? At least in mlxsw we return an
>> error in case we have a VLAN-aware bridge taking care of some VLAN and
>> then user space tries to install a VLAN upper with the same VLAN on the
>> same port. See more below.
>>
> 
> In the original post Message-ID: <20200910150738.mwhh2i6j2qgacqev@skbuf>
> I had copied this piece of code:
> 
> static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
> 				     u16 vid)
> {
> 	...
> 
> 	/* Check for a possible bridge VLAN entry now since there is no
> 	 * need to emulate the switchdev prepare + commit phase.
> 	 */
> 	if (dp->bridge_dev) {
> 		...
> 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
> 		 * device, respectively the VID is not found, returning
> 		 * 0 means success, which is a failure for us here.
> 		 */
> 		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
> 		if (ret == 0)
> 			return -EBUSY;
> 	}
> }
> 
>>> Most of this was based on discussions we had with Ido and him explaining to
>>> me how they were doing it in mlxsw.
>>>
>>> AFAIR the other case which is that you already have a 802.1Q upper, and then
>>> you add the switch port to the bridge is permitted and the bridge would
>>> inherit the VLAN into its local database.
>>
>> If you have swp1 and swp1.10, you can put swp1 in a VLAN-aware bridge
>> and swp1.10 in a VLAN-unaware bridge. If you add VLAN 10 as part of the
>> VLAN-aware bridge on swp1, traffic tagged with this VLAN will still be
>> injected into the stack via swp1.10.
>>
>> I'm not sure what is the use case for such a configuration and we reject
>> it in mlxsw.
> 
> Maybe the problem has to do with the fact that Florian took the
> .ndo_vlan_rx_add_vid() callback as a shortcut for deducing that there is
> an 8021q upper interface.

Yes, that was/is definitively the assumption when that code was added, 
and as you indicate below, as of today, only 802.1Q upppers call that NDO.

> 
> Currently there are other places in the network stack that don't really
> work with a network interface that has problems with an interface that
> has "rx-vlan-filter: on" in ethtool -k. See this discussion with Jiri on
> the use of tc-vlan:
> 
> https://www.spinics.net/lists/netdev/msg645931.html
> 
> So, even though today .ndo_vlan_rx_add_vid() is only called from 8021q,
> maybe we should dispel the myth that it's specific to 8021q somehow.
> 
> Maybe DSA should start tracking its upper interfaces, after all? Not
> convinced though.

If we started doing that, it may make sense to refactor the existing 
mlxsw code into something more generic that can be used almost as-is by 
switchdev driver as well as DSA, which ... are switchdev drivers to some 
extent as well.
-- 
Florian
