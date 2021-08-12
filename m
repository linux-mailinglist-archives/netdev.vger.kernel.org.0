Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61433EA0B2
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhHLIiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbhHLIit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:38:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3C5C0613D3
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 01:38:23 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q18so241533wrm.6
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 01:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Ssid/NE8KDjJqY6onCXht5Qn1Jv0AK+U0Nic+jj0uw=;
        b=YG4Rt0UR1QH3/E5WPBY4AeAKCRlQgHUZhkOEADpYjPufk9F9oqJY59EkvYLo/gQX/0
         MM4IOAshJdiktzNq/jR5yp7GfPD/GcH1ChVKcqq8ka/5moebU0k2QDSBo9FBUHe5V1Et
         zSg481kgUCZtx7uuwO8Ralmj7LofvADlzcy5rPJlhtCK10yHTw6NZ1pjhHZCQicafyA4
         byZnkr5YRw3UM6hFnKNsECACedw22s6NlzXAdTGdqZoThKXx8Xijnaujra8nzh3LA6vC
         IhsYEEsyPJO3A0iwvqLTFU+mHqZIZWXJTfgv5FZaF9NvSQwuJJCTdTQBcfgyJkWeYmk7
         tMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Ssid/NE8KDjJqY6onCXht5Qn1Jv0AK+U0Nic+jj0uw=;
        b=HScCYHwUSxX7421tH6lBWyLTPxfOIhd2G+a8n9DzPFhc54fqcJBdnLLAWdoqP/iBeE
         /jZMwwCAYL/Y81UHspAl2Fx3PUuXhz7D/+WB2O0kEuCMFB8sd5xrt6zGlaAJcEE7QlCk
         GM8YVlUI8n4I5VroJB1FQRG1AydYskV+ia3rA88dOjlLuLTz8N2iXspCiOURGuZn26LC
         mIhysjpwMnNF9NohLiLIw/MQAtRccfBskBKa7gYjy67WdDik32TJvupCAjlsSSb5h27e
         qvrait9pnlcWcNg5bSUZ+HgZkMM0E6ChhxH51A8Ery2OfLaDpwEhrOyIp/WKpw0p0G+u
         QCWw==
X-Gm-Message-State: AOAM531LjMBiyEo+YNxLbF9HFH1FiUmSQRd8GtmTf6CQwh+q2ZQGWxIk
        Ur3sHrTz2ix1fw5ppwTgibM=
X-Google-Smtp-Source: ABdhPJwm2P/3CdLeD31TN58eama9huBbFKPfGtWglI7n4eS798zhefmsae8lSDZTs1u0hyjp2EdJXw==
X-Received: by 2002:a05:6000:100a:: with SMTP id a10mr2751620wrx.42.1628757502243;
        Thu, 12 Aug 2021 01:38:22 -0700 (PDT)
Received: from ?IPv6:2a01:cb05:8192:e700:90a4:fe44:d3d1:f079? (2a01cb058192e70090a4fe44d3d1f079.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:90a4:fe44:d3d1:f079])
        by smtp.gmail.com with ESMTPSA id f10sm2148056wrx.40.2021.08.12.01.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 01:38:21 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: dsa: tag_8021q: don't broadcast during
 setup/teardown
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
 <20210811134606.2777146-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c08d8fac-708f-64e8-f002-0c98a0fb1888@gmail.com>
Date:   Thu, 12 Aug 2021 01:38:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811134606.2777146-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/2021 6:46 AM, Vladimir Oltean wrote:
> Currently, on my board with multiple sja1105 switches in disjoint trees
> described in commit f66a6a69f97a ("net: dsa: permit cross-chip bridging
> between all trees in the system"), rebooting the board triggers the
> following benign warnings:
> 
> [   12.345566] sja1105 spi2.0: port 0 failed to notify tag_8021q VLAN 1088 deletion: -ENOENT
> [   12.353804] sja1105 spi2.0: port 0 failed to notify tag_8021q VLAN 2112 deletion: -ENOENT
> [   12.362019] sja1105 spi2.0: port 1 failed to notify tag_8021q VLAN 1089 deletion: -ENOENT
> [   12.370246] sja1105 spi2.0: port 1 failed to notify tag_8021q VLAN 2113 deletion: -ENOENT
> [   12.378466] sja1105 spi2.0: port 2 failed to notify tag_8021q VLAN 1090 deletion: -ENOENT
> [   12.386683] sja1105 spi2.0: port 2 failed to notify tag_8021q VLAN 2114 deletion: -ENOENT
> 
> Basically switch 1 calls dsa_tag_8021q_unregister, and switch 1's TX and
> RX VLANs cannot be found on switch 2's CPU port.
> 
> But why would switch 2 even attempt to delete switch 1's TX and RX
> tag_8021q VLANs from its CPU port? Well, because we use dsa_broadcast,
> and it is supposed that it had added those VLANs in the first place
> (because in dsa_port_tag_8021q_vlan_match, all CPU ports match
> regardless of their tree index or switch index).
> 
> The two trees probe asynchronously, and when switch 1 probed, it called
> dsa_broadcast which did not notify the tree of switch 2, because that
> didn't probe yet. But during unbind, switch 2's tree _is_ probed, so it
> _is_ notified of the deletion.
> 
> Before jumping to introduce a synchronization mechanism between the
> probing across disjoint switch trees, let's take a step back and see
> whether we _need_ to do that in the first place.
> 
> The RX and TX VLANs of switch 1 would be needed on switch 2's CPU port
> only if switch 1 and 2 were part of a cross-chip bridge. And
> dsa_tag_8021q_bridge_join takes care precisely of that (but if probing
> was synchronous, the bridge_join would just end up bumping the VLANs'
> refcount, because they are already installed by the setup path).
> 
> Since by the time the ports are bridged, all DSA trees are already set
> up, and we don't need the tag_8021q VLANs of one switch installed on the
> other switches during probe time, the answer is that we don't need to
> fix the synchronization issue.
> 
> So make the setup and teardown code paths call dsa_port_notify, which
> notifies only the local tree, and the bridge code paths call
> dsa_broadcast, which let the other trees know as well.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
