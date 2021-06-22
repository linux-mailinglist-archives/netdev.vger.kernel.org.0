Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADD13B0D3A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbhFVSye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFVSyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:54:33 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B60C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 11:52:16 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j2so14306989wrs.12
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 11:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yj0I8GYVveKrE61j7Up1RtewsPEiyk6JOHutJblNkRs=;
        b=Be6ekq+l6ZsOSCywWCLXAqn7l0fLOpCX1QSHDpjEH3ezavGd28x0lPuTdpVNxC+8Ir
         bZPTJC1nTc9fqzMsyyVwaDrNX4ul+46ZRUhC3MnopvZDg0ulQ0RME9/nlHDLJkdqY8v9
         8P87wIcF5qovG7l0+wNlprfPLZupY6zUbzfNSBGMTscA+IgZ9Br9WWod+qin4r02dsCZ
         SDz1ZtuvQFopktqQGNcgxO+X1FeFHquf7Q8idVmBGTpkbnUa8riKVpbwEu5fMFaPPSZ3
         g4u2k/teD6IuFVXFOwm+ZVIpTFUdWUpGX2dQ0P3ZJB3MzYqF+8i+3259Pv3wVhqXLarq
         jxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yj0I8GYVveKrE61j7Up1RtewsPEiyk6JOHutJblNkRs=;
        b=uhFIIV2LnOpRIThgk64z85NdsLZBQvVAsNIerClt9pE1CxDy6rnAxHhVdwyQoDCFwP
         XG8l08RV73xfOsvwBtiiKfvDMPHIYZIM3GnX43SDTvkL5Z6S8xyU7tcZxGIw58W1TtOj
         4ziNhPfgsGnpc3NH8AXeJd/TVEFK7DRZ0BFUWmYwJSHySEFkWJ4h3WRIjfMb5D27MBJf
         I4sUVvOnCLcITbZgKl05Rj00vt6zy8yH+eM2zySzjbAmRFijmhuy6jEQgFBzX7oDN2/1
         xJGwkroTkmNH2SruztZueYcpE8FfZCP/5KIDA50//Hl0gf6Z3itrt7aY0wcKM6YNhdDk
         Eusg==
X-Gm-Message-State: AOAM5321vzaU5+r/z18h0r2rjLQbU64sWzTVjfg8Wa26AZJtjyfcxodU
        pJFB5i2FhMWRppRpL5yWDCY=
X-Google-Smtp-Source: ABdhPJxQzmh35xbrVDH7TJTRsehSU99zjqudycRtlvfZXROg2iM/iheMigUA18/wSJ5sw5i8OaLTZg==
X-Received: by 2002:a5d:6da2:: with SMTP id u2mr6571036wrs.355.1624387935245;
        Tue, 22 Jun 2021 11:52:15 -0700 (PDT)
Received: from [10.0.0.15] ([37.164.53.25])
        by smtp.gmail.com with ESMTPSA id b71sm3385484wmb.2.2021.06.22.11.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 11:52:14 -0700 (PDT)
Subject: Re: [PATCH] bonding: avoid adding slave device with IFF_MASTER flag
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        zhudi <zhudi21@huawei.com>
Cc:     vfalico@gmail.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, rose.chen@huawei.com
References: <20210622030929.51295-1-zhudi21@huawei.com>
 <21984.1624385801@famine>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bf84fc7b-8829-420a-3aca-00a378921f61@gmail.com>
Date:   Tue, 22 Jun 2021 20:52:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <21984.1624385801@famine>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/21 8:16 PM, Jay Vosburgh wrote:
> zhudi <zhudi21@huawei.com> wrote:
> 
>> From: Di Zhu <zhudi21@huawei.com>
>>
>> The following steps will definitely cause the kernel to crash:
>> 	ip link add vrf1 type vrf table 1
>> 	modprobe bonding.ko max_bonds=1
>> 	echo "+vrf1" >/sys/class/net/bond0/bonding/slaves
>> 	rmmod bonding
>>
>> The root cause is that: When the VRF is added to the slave device,
>> it will fail, and some cleaning work will be done. because VRF device
>> has IFF_MASTER flag, cleanup process  will not clear the IFF_BONDING flag.
>> Then, when we unload the bonding module, unregister_netdevice_notifier()
>> will treat the VRF device as a bond master device and treat netdev_priv()
>> as struct bonding{} which actually is struct net_vrf{}.
>>
>> By analyzing the processing logic of bond_enslave(), it seems that
>> it is not allowed to add the slave device with the IFF_MASTER flag, so
>> we need to add a code check for this situation.
> 
> 	I don't believe the statement just above is correct; nesting
> bonds has historically been permitted, even if it is of questionable
> value these days.  I've not tested nesting in a while, but last I recall
> it did function.
> 
> 	Leaving aside the question of whether it's really useful to nest
> bonds or not, my concern with disabling this is that it will break
> existing configurations that currently work fine.
> 
> 	However, it should be possible to use netif_is_bonding_master
> (which tests dev->flags & IFF_MASTER and dev->priv_flags & IFF_BONDING)
> to exclude IFF_MASTER devices that are not bonds (which seem to be vrf
> and eql), e.g.,
> 
> 	if ((slave_dev->flags & IFF_MASTER) &&
> 		!netif_is_bond_master(slave_dev))
> 
> 	Or we can just go with this patch and see if anything breaks.
> 

syzbot for sure will stop finding stack overflows and other issues like that :)

I know that some people used nested bonding devices in order to implement complex qdisc setups.
(eg HTB on the first level, netem on the second level).

