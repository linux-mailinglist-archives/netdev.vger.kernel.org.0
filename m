Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5F624941F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgHSEaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgHSEaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:30:20 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E05C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 21:30:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h12so10760908pgm.7
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 21:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L/vcUapC1FJA+kOJR7gkKoD6WGo8IXo0Vf27Fev2kxc=;
        b=YaO1INA/TqhqB9USURQcoNnG4lTwXPWabiuh4/dBrES3V43RRIbKaUDcc764bgBxiz
         MqMukupZD9LdaS3lReOa6oyZq5oVqLO5JmJGOSmvR/xrwTmrBFUWTAJ5FgOzwOXPaJDJ
         QPo/YYZly8UzHn3+4buJ9aW/4FwUMdkHeH5jNxCMAX6Te9cEzQv/2ck9m8Pv6Y+ghZtx
         u4IfF8NAJDyA2g3p2FD/OaMho+CsLxD/HjpByU7v8WiD318mK/PXl2gUQ8Ay1cxm5SgY
         P44Z10FHj6jY9f+g37EU7TQ+I0qSiu9UBETeUA83wCiwjIyjD3GBSYMxNaZCsdrV0sdY
         OmWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L/vcUapC1FJA+kOJR7gkKoD6WGo8IXo0Vf27Fev2kxc=;
        b=GqqohR8hwwZIYH/n04Rwx2k6hoWt/BbfCoGNwb7QttuNYahPlUbrPo3vn7mrKzRmMh
         cNn3PeMlPzJQNG78paE0WIOVBbFNPUr4w68+DpaAtarWHsAaS1CymwMtzdSJnHyfiy5U
         RAYAwEUtXMeQbb0D9mL69FKKa+3C4D185t/tmaoKCWtcNuMNKRT1SlxPrynb08Bsz63k
         zYDfTNCIBwbv1lqPZwn/v8QM3e+vL41CaZu/lMIrfNLdhzhKSDFQV+lM8SHycgxYX9lh
         jIo51HOQjVBsvoBTBVzWm+fMTKZLiM+QwXaN+WJjwaEDZ2g6URURnGTk0zL9zVj9gPKR
         apKQ==
X-Gm-Message-State: AOAM532hgyAzjv/AFzcAi2A93QjnabwL+apInUNcvn+7KGCOj9CNcfh5
        Fj2l2aN4bw4EpEyrSsahauY=
X-Google-Smtp-Source: ABdhPJy8UVLmlKJJ6OTeRWGe9jLDSWvo81aix7egeESGTWMdUzJvVsgZfVZTtJA+sVv0qcBBKbgDjw==
X-Received: by 2002:a62:1505:: with SMTP id 5mr14126529pfv.41.1597811419447;
        Tue, 18 Aug 2020 21:30:19 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b20sm26258552pfp.140.2020.08.18.21.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 21:30:18 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com, roopa@nvidia.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, tariqt@nvidia.com,
        ayal@nvidia.com, mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
 <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
Date:   Tue, 18 Aug 2020 21:30:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/2020 8:35 PM, Jakub Kicinski wrote:
> On Tue, 18 Aug 2020 20:43:11 -0600 David Ahern wrote:
>> On 8/18/20 6:24 PM, Jakub Kicinski wrote:
>>> On Mon, 17 Aug 2020 15:50:53 +0300 Ido Schimmel wrote:
>>>> From: Ido Schimmel <idosch@nvidia.com>
>>>>
>>>> This patch set extends devlink to allow device drivers to expose device
>>>> metrics to user space in a standard and extensible fashion, as opposed
>>>> to the driver-specific debugfs approach.
>>>
>>> I feel like all those loose hardware interfaces are a huge maintenance
>>> burden. I don't know what the solution is, but the status quo is not
>>> great.
>>
>> I don't agree with the 'loose' characterization.
> 
> Loose as in not bound by any standard or best practices.
> 
>> Ido and team are pushing what is arguably a modern version of
>> `ethtool -S`, so it provides a better API for retrieving data.
> 
> ethtool -S is absolutely terrible. Everybody comes up with their own
> names for IEEE stats, and dumps stats which clearly have corresponding
> fields in rtnl_link_stats64 there. We don't need a modern ethtool -S,
> we need to get away from that mess.
> 
>>> I spend way too much time patrolling ethtool -S outputs already.
>>
>> But that's the nature of detailed stats which are often essential to
>> ensuring the system is operating as expected or debugging some problem.
>> Commonality is certainly desired in names when relevant to be able to
>> build tooling around the stats.
> 
> There are stats which are clearly detailed and device specific,
> but what ends up happening is that people expose very much not
> implementation specific stats through the free form interfaces,
> because it's the easiest.
> 
> And users are left picking up the pieces, having to ask vendors what
> each stat means, and trying to create abstractions in their user space
> glue.

Should we require vendors to either provide a Documentation/ entry for 
each statistics they have (and be guaranteed that it will be outdated 
unless someone notices), or would you rather have the statistics 
description be part of the devlink interface itself? Should we define 
namespaces such that standard metrics should be under the standard 
namespace and the vendor standard is the wild west?

> 
>> As an example, per-queue stats have been
>> essential to me for recent investigations. ethq has been really helpful
>> in crossing NIC vendors and viewing those stats as it handles the
>> per-vendor naming differences, but it requires changes to show anything
>> else - errors per queue, xdp stats, drops, etc. This part could be simpler.
> 
> Sounds like you're agreeing with me?
> 
>> As for this set, I believe the metrics exposed here are more unique to
>> switch ASICs.
> 
> This is the list from patch 6:
> 
>     * - ``nve_vxlan_encap``
>     * - ``nve_vxlan_decap``
>     * - ``nve_vxlan_decap_errors``
>     * - ``nve_vxlan_decap_discards``
> 
> What's so unique?
> 
>> At least one company I know of has built a business model
>> around exposing detailed telemetry of switch ASICs, so clearly some find
>> them quite valuable.
> 
> It's a question of interface, not the value of exposed data.
> 
> If I have to download vendor documentation and tooling, or adapt my own
> scripts for every new vendor, I could have as well downloaded an SDK.

Are not you being a bit over dramatic here with your example? At least 
you can run the same command to obtain the stats regardless of the 
driver and vendor, so from that perspective Linux continues to be the 
abstraction and that is not broken.
-- 
Florian
