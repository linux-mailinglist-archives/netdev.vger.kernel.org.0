Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8B1BF671
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgD3LU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726483AbgD3LU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:20:28 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7624DC035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 04:20:27 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f11so6083334ljp.1
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 04:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7QEu8lQDX7asS/EZnMosCw8iJ8orrbIm4oxu4zfa7w8=;
        b=HucCPpnpma0D9qFGBTzTef+mq4pL65ONVeTzpZom5AgHG+MJYKVQrLsrWUbXmKSWRA
         RsmDdNSJ8Lcfq2n85ORjZE7iWC3gulDmD1hdMaONaELzssFXRIg1uvtrYgDcI6limxZN
         EZJiO5nW2WdKnP7m5Ndy1ZNZ85oi6eISP3/a8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7QEu8lQDX7asS/EZnMosCw8iJ8orrbIm4oxu4zfa7w8=;
        b=GgQJF2Su4oGFlMOSYht1q4ph7hZDz3hnsAWu9wRFSA2luu0a6sgHdr29SfeKw4Sv16
         a5RSkGlNblWQ2iCtk/Yhk7wMJgFNPO03L7rKcQLSi+YHyuU1xWH2xF8Ut4C9xmQJ9IE9
         6X0tKuVjhFX5Y7Buwsf6MqMAPRHVYwRkXztGSpXnf3Am3hQl+34YPDUR+sR09A1SadjY
         Kx6HKve/0k6qCj9r2AWkCYQKjiOOgFaAtte7zt/IbubjXv0UA2CBgfAAsbs1ezMVx6SO
         DNaxqDL0d5Z/oy0HrfHSxmejKsRoC0o2fyhAeLr96ijuDQjtm1KBxtOPzrQViu/LW1Xj
         k6ug==
X-Gm-Message-State: AGi0PuZol4YLi/TCAA8PYJcLjPZntH8a/F2B3b+YHJvIzRTUSyT7LKob
        F2sqt9TyaErtl0xex1n8wVyVh3SOJRwTsQ==
X-Google-Smtp-Source: APiQypLGoRK/B5UEMM3ebOwPImgOIEU58k6prYsh3w5eqcv3NsOneJlrmwbIIVMBMK48+FaohW+KLw==
X-Received: by 2002:a05:651c:449:: with SMTP id g9mr1937084ljg.278.1588245625383;
        Thu, 30 Apr 2020 04:20:25 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a12sm4050511ljj.64.2020.04.30.04.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 04:20:24 -0700 (PDT)
Subject: Re: BUG: soft lockup while deleting tap interface from vlan aware
 bridge
To:     Ido Schimmel <idosch@idosch.org>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>, netdev@vger.kernel.org
References: <85b1e301-8189-540b-b4bf-d0902e74becc@profihost.ag>
 <20200430105551.GA4068275@splinter>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <4b3a6079-d8d4-24c5-8fc9-15bcb96bca80@cumulusnetworks.com>
Date:   Thu, 30 Apr 2020 14:20:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200430105551.GA4068275@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/04/2020 13:55, Ido Schimmel wrote:
> On Wed, Apr 29, 2020 at 10:52:35PM +0200, Stefan Priebe - Profihost AG wrote:
>> Hello,
>>
>> while running a stable vanilla kernel 4.19.115 i'm reproducably get this
>> one:
>>
>> watchdog: BUG: soft lockup - CPU#38 stuck for 22s! [bridge:3570653]
>>
>> ...
>>
>> Call
>> Trace:nbp_vlan_delete+0x59/0xa0br_vlan_info+0x66/0xd0br_afspec+0x18c/0x1d0br_dellink+0x74/0xd0rtnl_bridge_dellink+0x110/0x220rtnetlink_rcv_msg+0x283/0x360
> 
> Nik, Stefan,
> 
> My theory is that 4K VLANs are deleted in a batch and preemption is
> disabled (please confirm). For each VLAN the kernel needs to go over the

Right, that's what I was expecting. :-)

> entire FDB and delete affected entries. If the FDB is very large or the
> FDB lock is contended this can cause the kernel to loop for more than 20
> seconds without calling schedule().

Indeed, we already have that issue also with expire which goes over all entries.
I have rough patches that improve the situation from way back, will have to go over and
polish them to submit when I got more time. Long ago I've tested it with expiring 10 million
entries but on a rather powerful CPU.

> 
> To reproduce I added mdelay(100) in br_fdb_delete_by_port() and ran
> this:
> 
> ip link add name br10 up type bridge vlan_filtering 1
> ip link add name dummy10 up type dummy
> ip link set dev dummy10 master br10
> bridge vlan add vid 1-4094 dev dummy10 master
> bridge vlan del vid 1-4094 dev dummy10 master
> 
> Got a similar trace to Stefan's. Seems to be fixed by attached:
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index a774e19c41bb..240e260e3461 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -615,6 +615,7 @@ int br_process_vlan_info(struct net_bridge *br,
>                                                v - 1, rtm_cmd);
>                                 v_change_start = 0;
>                         }
> +                       cond_resched();
>                 }
>                 /* v_change_start is set only if the last/whole range changed */
>                 if (v_change_start)
> 
> WDYT?
> 

Maybe we can batch the deletes at say 32 at a time?
Otherwise looks good to me, thanks!
