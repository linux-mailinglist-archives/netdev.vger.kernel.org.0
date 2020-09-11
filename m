Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428A0267699
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgIKXuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgIKXtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 19:49:55 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0484C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 16:49:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q4so2459439pjh.5
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 16:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bUzLqdgvHRtWmYxCFZXCdIvA457HE1aL8qbIhlu9YUQ=;
        b=e90+CiBwXCp6ppxIS25zNwWVsu4mpOJKGTPKnxsaOEMvL2Vow1/6TGQ3iW+r4z9UpC
         obtHTN761TyiIj7ayFTGcn5t6iwYg0qgHTD2RKpXlbd1U3DlYIRg4bRVmZyYLwBlcpm0
         e4aT+Y2YXE7awC/AfSSp07aJW2bg3huv9VrGRXV04zVefP2+SlCcJNax541/UJKRamRS
         nXqViiweDL++o3YGHdnzFKKk01svTvZxwYBdcbCyk/SurEZmZWvr6hqk+dlJQyoOmAFU
         ZaRLaoVnRkMUf+nFtN1jG/6CjXR70LOI0pOPLRXbhCXUtdFL7pG0bJtz3HUjAaZyggA8
         vk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bUzLqdgvHRtWmYxCFZXCdIvA457HE1aL8qbIhlu9YUQ=;
        b=a0V7xnH/RNPi5u1b3P6YkK3ZQOWzicO0kfIU+PkkGXMxe7wZzpZhkSkvUl+uPkL+Id
         lfqWx2t1U+CJBaJ8gCLsEk0X8DwF0Wjbs1tVksGEhc54CPYl/mV/7EaicQTrufMaAXFF
         awKuf9Zy3BMFWHSlw9ZBqZJKuTkzxuzwJD1ziYKowkvHjlBdhWGzEd7XiCDDgFuArQRV
         CsSbv82uKBya1cWpfuzwlB0NBOn7dWqVjMpnHKaces/Xz7giXY2iMnDXJtMRyg2OLgVO
         pzZQKA9ljzjesYV3HvlGGAy/kAu2IGRWCwyPz3b9anjFDCyJDNxM8ijhe8dMF18pfOl1
         jIyw==
X-Gm-Message-State: AOAM53273EdLTAV3oMH/qo07NMWur4OmELRmBaJDxCVb8o2qvs+qTQk5
        /mARFFrlO0u6FmqWIzci8pS9Mz3u5q8=
X-Google-Smtp-Source: ABdhPJzd/k2pbwVJqX98hQH+uYP1YxaAd7D8j/KHAWlwkVIcoGVvHvoeUQGqYDfmj3d62rPZzZLFKA==
X-Received: by 2002:a17:90b:1083:: with SMTP id gj3mr4425562pjb.126.1599868193863;
        Fri, 11 Sep 2020 16:49:53 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mt8sm2866216pjb.17.2020.09.11.16.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 16:49:52 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/4] net: dsa: tag_8021q: add a context
 structure
To:     Vladimir Oltean <olteanv@gmail.com>, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20200910164857.1221202-1-olteanv@gmail.com>
 <20200910164857.1221202-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <18a9d5f7-0422-5ca2-9d65-10cd5fcdebc0@gmail.com>
Date:   Fri, 11 Sep 2020 16:49:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200910164857.1221202-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 9:48 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> While working on another tag_8021q driver implementation, some things
> became apparent:
> 
> - It is not mandatory for a DSA driver to offload the tag_8021q VLANs by
>    using the VLAN table per se. For example, it can add custom TCAM rules
>    that simply encapsulate RX traffic, and redirect & decapsulate rules
>    for TX traffic. For such a driver, it makes no sense to receive the
>    tag_8021q configuration through the same callback as it receives the
>    VLAN configuration from the bridge and the 8021q modules.
> 
> - Currently, sja1105 (the only tag_8021q user) sets a
>    priv->expect_dsa_8021q variable to distinguish between the bridge
>    calling, and tag_8021q calling. That can be improved, to say the
>    least.
> 
> - The crosschip bridging operations are, in fact, stateful already. The
>    list of crosschip_links must be kept by the caller and passed to the
>    relevant tag_8021q functions.
> 
> So it would be nice if the tag_8021q configuration was more
> self-contained. This patch attempts to do that.
> 
> Create a struct dsa_8021q_context which encapsulates a struct
> dsa_switch, and has 2 function pointers for adding and deleting a VLAN.
> These will replace the previous channel to the driver, which was through
> the .port_vlan_add and .port_vlan_del callbacks of dsa_switch_ops.
> 
> Also put the list of crosschip_links into this dsa_8021q_context.
> Drivers that don't support cross-chip bridging can simply omit to
> initialize this list, as long as they dont call any cross-chip function.
> 
> The sja1105_vlan_add and sja1105_vlan_del functions are refactored into
> a smaller sja1105_vlan_add_one, which now has 2 entry points:
> - sja1105_vlan_add, from struct dsa_switch_ops
> - sja1105_dsa_8021q_vlan_add, from the tag_8021q ops
> But even this change is fairly trivial. It just reflects the fact that
> for sja1105, the VLANs from these 2 channels end up in the same hardware
> table. However that is not necessarily true in the general sense (and
> that's the reason for making this change).
> 
> The rest of the patch is mostly plain refactoring of "ds" -> "ctx". The
> dsa_8021q_context structure needs to be propagated because adding a VLAN
> is now done through the ops function pointers inside of it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

This was indeed easier to review than v1.
-- 
Florian
