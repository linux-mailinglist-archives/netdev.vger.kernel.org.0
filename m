Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9276807FA
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbjA3I4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbjA3I43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:56:29 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6BA27D7A
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:56:26 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v13so10195412eda.11
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4cF2CUyB3EHElg6yX0gxnuKTPhQUwF623r8IcXZaqUs=;
        b=MT/c60DlHRoBcmKOVwmsagcuIlX7cDJIaX7jE4v7/P9h38PKU0H5yVv1a98QpCNlXT
         DG9arSSwrQdb3okg0Ui+r8GYqcCAqp/zOqIbskfNgShpAwfR+Ik+NKVFAiMtlfwb2jUx
         /wcfXjLIx1L0UTrHCD7h7m19tLO+azfkD0WFn+YXNr3ihJp5N9omDUy0SFeiyuL468xj
         2macfjQJ2zevE0accDboLJ711tWga8yMHWW35fg6clQIpErw5O9BwBFWeunJxt3E4MXE
         KfQGsQaAr6I0JiwWEpd+RVHiHk7TchncP6cZ/fdbUJYc14vj47PVilb8rVg0G92JK0/+
         bN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cF2CUyB3EHElg6yX0gxnuKTPhQUwF623r8IcXZaqUs=;
        b=R6TxrhazF+lx0oZ83JtPkNerwYBl+o+WP9qaxh2mI7fH1706TJX38uw5Mx5lYdbo08
         Ojnl6ud2dQVZ++AUN8wt6PZmGksXddjianA7cMyO8Z5c0FmYHvAxYntCBa+mvSkN+33+
         h3rnEiTTpF6bVip5I8JzNC/NOx7ZzSup5hYNypu8yQ5hu8o+yBgyvHmGoobJKG9pXuvb
         dPLkT/ZsQxf4fspSIjcOFrI5B7R8WRC48xGx37oe08qv3FBmhxZ5MXWNr990QItiLFcc
         de9lC7KZ6Tf6dS1RejrbPsjCC9azrlwKaqPyTt2e0+t8ALataQ1kH/D/fIhyqd6etnA8
         vN/w==
X-Gm-Message-State: AFqh2kpv08T/GTKtdXr3CVSh/LRS3QnKTzlbkHTC0BSkYMZsp5VxRb3i
        zG2t2X1Z8UsO0VAUbwI0VUOeVQ==
X-Google-Smtp-Source: AMrXdXurtv7iREqNupd3p+TJzkQIkaM36NTVFjMv3wJNpAhDN11ivvBCeWYPPSzDv3Vb/ybhTWSTtw==
X-Received: by 2002:a05:6402:4496:b0:49e:ca5:244a with SMTP id er22-20020a056402449600b0049e0ca5244amr55236340edb.1.1675068984316;
        Mon, 30 Jan 2023 00:56:24 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id pv5-20020a170907208500b00888fddc4eb2sm1082347ejb.164.2023.01.30.00.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 00:56:23 -0800 (PST)
Message-ID: <cacda0ed-5590-f059-3461-fb670ee9cf07@blackwall.org>
Date:   Mon, 30 Jan 2023 10:56:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 07/16] net: bridge: Maintain number of MDB
 entries in net_bridge_mcast_port
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <cover.1674752051.git.petrm@nvidia.com>
 <1dcd4638d78c469eaa2f528de1f69b098222876f.1674752051.git.petrm@nvidia.com>
 <81821548-4839-e7ba-37b0-92966beb7930@blackwall.org>
 <Y9d69bP7tzp/2reQ@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <Y9d69bP7tzp/2reQ@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/01/2023 10:08, Ido Schimmel wrote:
> On Sun, Jan 29, 2023 at 06:55:26PM +0200, Nikolay Aleksandrov wrote:
>> On 26/01/2023 19:01, Petr Machata wrote:
>>> The MDB maintained by the bridge is limited. When the bridge is configured
>>> for IGMP / MLD snooping, a buggy or malicious client can easily exhaust its
>>> capacity. In SW datapath, the capacity is configurable through the
>>> IFLA_BR_MCAST_HASH_MAX parameter, but ultimately is finite. Obviously a
>>> similar limit exists in the HW datapath for purposes of offloading.
>>>
>>> In order to prevent the issue of unilateral exhaustion of MDB resources,
>>> introduce two parameters in each of two contexts:
>>>
>>> - Per-port and per-port-VLAN number of MDB entries that the port
>>>   is member in.
>>>
>>> - Per-port and (when BROPT_MCAST_VLAN_SNOOPING_ENABLED is enabled)
>>>   per-port-VLAN maximum permitted number of MDB entries, or 0 for
>>>   no limit.
>>>
>>> The per-port multicast context is used for tracking of MDB entries for the
>>> port as a whole. This is available for all bridges.
>>>
>>> The per-port-VLAN multicast context is then only available on
>>> VLAN-filtering bridges on VLANs that have multicast snooping on.
>>>
>>> With these changes in place, it will be possible to configure MDB limit for
>>> bridge as a whole, or any one port as a whole, or any single port-VLAN.
>>>
>>> Note that unlike the global limit, exhaustion of the per-port and
>>> per-port-VLAN maximums does not cause disablement of multicast snooping.
>>> It is also permitted to configure the local limit larger than hash_max,
>>> even though that is not useful.
>>>
>>> In this patch, introduce only the accounting for number of entries, and the
>>> max field itself, but not the means to toggle the max. The next patch
>>> introduces the netlink APIs to toggle and read the values.
>>>
>>> Note that the per-port-VLAN mcast_max_groups value gets reset when VLAN
>>> snooping is enabled. The reason for this is that while VLAN snooping is
>>> disabled, permanent entries can be added above the limit imposed by the
>>> configured maximum. Under those circumstances, whatever caused the VLAN
>>> context enablement, would need to be rolled back, adding a fair amount of
>>> code that would be rarely hit and tricky to maintain. At the same time,
>>> the feature that this would enable is IMHO not interesting: I posit that
>>> the usefulness of keeping mcast_max_groups intact across
>>> mcast_vlan_snooping toggles is marginal at best.
>>>
>>
>> Hmm, I keep thinking about this one and I don't completely agree. It would be
>> more user-friendly if the max count doesn't get reset when mcast snooping is toggled.
>> Imposing order of operations (first enable snooping, then config max entries) isn't necessary
>> and it makes sense for someone to first set the limit and then enable vlan snooping.
>> Also it would be consistent with port max entries, I'd prefer if we have the same
>> behaviour for port and vlan pmctxs. If we allow to set any maximum at any time we
>> don't need to rollback anything, also we already always lookup vlans in br_multicast_port_vid_to_port_ctx()
>> to check if snooping is enabled so we can keep the count correct regardless, the same as
>> it's done for the ports. Keeping both limits with consistent semantics seems better to me.
>>
>> WDYT ?
> 
> The current approach is strict and prevents user space from performing
> configuration that does not make a lot of sense:
> 
> 1. Setting the maximum to be less than the current count.
> 
> 2. Increasing the port-VLAN count above port-VLAN maximum when VLAN
> snooping is disabled (i.e., maximum is not enforced) and then enabling
> VLAN snooping.
> 
> However, it is not consistent with similar existing behavior where the
> kernel is more liberal. For example:
> 
> 1. It is possible to set the global maximum to be less than the current
> number of entries.
> 
> 2. Other port-VLAN attributes are not reset when VLAN snooping is
> toggled.
> 

Right, 2) is my main concern and could be surprising. I'd also like to
have consistent behaviour for both limits - port and vlan.

> And it also results in order of operations problems like you described.
> 
> So, it seems to me that we have more good reasons to not reset the
> maximum than to reset it. Regardless of which path we take, it is
> important to document the behavior in the man page (and in the commit
> message, obviously) to avoid "bug reports" later on.

+1
Absolutely agree.

Thanks,
 Nik

