Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFDC52BD37
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbiEROKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238481AbiEROKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:10:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AC661AEC62
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652882992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zP8a12NAYm+dq56OvhkflKTAFol6UAgyVn/DbAn8sUs=;
        b=SNxRgoNr6Mz64LM5fjbKa9q6FUI51bCTZcvokdYk4lH1NEPQiYeUw3zH8NphPUJ7WdF9g5
        9SeOy9ECj305ctdf56owzIbkQEeQL/UMwh8jvTXzOOZRH0Jh7VjhOL5EnLyVB38pp3qsuT
        7q51Nw52GIKg2hAFwM0N5Ig+nVv2ExE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-JtaDjIsDPXautfyqGovqDQ-1; Wed, 18 May 2022 10:09:51 -0400
X-MC-Unique: JtaDjIsDPXautfyqGovqDQ-1
Received: by mail-qk1-f197.google.com with SMTP id bl27-20020a05620a1a9b00b0069994eeb30cso1635858qkb.11
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zP8a12NAYm+dq56OvhkflKTAFol6UAgyVn/DbAn8sUs=;
        b=4pMAMDW0HZHVMLenjILZ0Zw7Ho2aZgyFWW5o4cxBl87SB0qeNhEW+J5uBuUHlJNFTy
         P7AyFbaHWHKIHxjuKnazK39K0yc1bbuS6lemdElu8sSJpkOimEkr8efHfqbW5LKbBHrS
         E5rj9TS4A6NPispK6z2nMgeIEcpL9iTS3xPA08pGmOHGOPVXmhwM2N3/0+TQmmeQon5t
         4NlQ87cIslVSp7JiluGltsw9TUOhdn05BeOhtXsYvQ+0EgvqfG3g18rTcVCSUstOdE0c
         5g6fuP3mWt3akvJ1Mk2mDC4NXlaRsAowqh2cU2NZJne5d7dO5vD3Ezg1CnrOzMe+ZAFf
         FfSg==
X-Gm-Message-State: AOAM533/E9JQY/mGSxGENH+TQP0nFedBdAQ3hge8vjBQZSa0rRmRmF7T
        DZk6PqJpeP4rjlbyRN+Vn8QX45zK7gZrtFYvIlcIqlrMLiEjVeHF797EglFqHcKxklRtWxJgw7w
        3/kWYwjZ4t3sCtsJx
X-Received: by 2002:ac8:5bcc:0:b0:2f3:cf60:57c5 with SMTP id b12-20020ac85bcc000000b002f3cf6057c5mr24493484qtb.34.1652882990871;
        Wed, 18 May 2022 07:09:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdk6paZdQb1y/eStq9hef6FNT1CWEP4y0kb71nzkAZk3rnrbVMXqoa1yRA/f0H+b5GbwMFJw==
X-Received: by 2002:ac8:5bcc:0:b0:2f3:cf60:57c5 with SMTP id b12-20020ac85bcc000000b002f3cf6057c5mr24493330qtb.34.1652882989093;
        Wed, 18 May 2022 07:09:49 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id e13-20020ac8670d000000b002f39b99f6aasm1245070qtp.68.2022.05.18.07.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 07:09:48 -0700 (PDT)
Message-ID: <384c579a-ce41-1083-94f2-a7ec564d0888@redhat.com>
Date:   Wed, 18 May 2022 10:09:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [question] bonding: should assert dormant for active protocols
 like LACP?
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <de8d8ca4-4ead-0cef-1315-8764d93503c1@redhat.com>
 <4196.1652824157@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <4196.1652824157@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/22 17:49, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> So running the following script:
>>
>> --%<-----
>> ip link add name link-bond0 type veth peer name link-end0
>> ip link add bond0 type bond mode 4 miimon 100
>> ip link set link-bond0 master bond0 down
>> ip netns add n1
>> ip link set link-end0 netns n1 up
>> ip link set bond0 up
>> cat /sys/class/net/bond0/bonding/ad_partner_mac
>> cat /sys/class/net/bond0/operstate
>> --%<-----
>>
>> The bond reports its operstate to be "up" even though the bond will never
>> be able to establish an LACP partner. Should bonding for active protocols,
>> LACP, assert dormant[0] until the protocol has established and frames
>> actually are passed?
>>
>> Having a predictable operstate where up actually means frames will attempt
>> to be delivered would make management applications, f.e. Network Manager,
>> easier to write. I have developers asking me what detailed states for LACP
>> should they be looking for to determine when an LACP bond is "up". This
>> seems like an incorrect implementation of operstate and RFC2863 3.1.12.
>>
>> Does anyone see why this would be a bad idea?
> 
> 	The catch with LACP is that it has a fallback, in that ports
> that don't complete LACP negotiation go to "Solitary" state (I believe
> this was called "Individual" in older versions of the 802.1AX / 802.3ad
> standard; bonding calls this "is_individual" internally).
> 
> 	If there is no suitable partnered port, then a Solitary port is
> made active.  This permits connectivity if one end is set for LACP but
> the other end is not (e.g., PXE boot to a switch port set for LACP).
> For reference, I'm looking at 6.3.5 and 6.3.6 of IEEE 802.1AX-2020.
> 
> 	So, how should operstate be set if "has LACP partner" isn't
> really the test for whether or not the interface is (to use RCC 2863
> language) "in a condition to pass packets"?  In your example above, I
> believe the bond should be able to pass packets just fine, the packets
> just won't go anywhere after they leave the bond.

That makes sense and appears to work:

--%<------
sh -c 'ip link add name link-bond0 type veth peer name link-end0
ip link add bond0 type bond mode 4 miimon 100
ip link set link-bond0 master bond0 down
ip netns add n1
ip link set link-end0 netns n1 up
ip netns exec n1 ip link add name br0 type bridge
ip netns exec n1 ip link set br0 up
ip netns exec n1 ip link set link-end0 master br0
ip addr add 192.168.180.2/24 dev bond0
ip netns exec n1 ip addr add 192.168.180.3/24 dev br0
ip link set bond0 up
cat /sys/class/net/bond0/bonding/ad_partner_mac
cat /sys/class/net/bond0/operstate
sleep 20
ping -I bond0 -c8 192.168.180.3'
--%<------
00:00:00:00:00:00
up
PING 192.168.180.3 (192.168.180.3) from 192.168.180.2 bond0: 56(84) 
bytes of data.
64 bytes from 192.168.180.3: icmp_seq=1 ttl=64 time=0.065 ms
64 bytes from 192.168.180.3: icmp_seq=2 ttl=64 time=0.059 ms
64 bytes from 192.168.180.3: icmp_seq=3 ttl=64 time=0.046 ms
64 bytes from 192.168.180.3: icmp_seq=4 ttl=64 time=0.046 ms
64 bytes from 192.168.180.3: icmp_seq=5 ttl=64 time=0.045 ms
64 bytes from 192.168.180.3: icmp_seq=6 ttl=64 time=0.045 ms
64 bytes from 192.168.180.3: icmp_seq=7 ttl=64 time=0.044 ms
64 bytes from 192.168.180.3: icmp_seq=8 ttl=64 time=0.042 ms

--- 192.168.180.3 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 7191ms
rtt min/avg/max/mdev = 0.042/0.049/0.065/0.007 ms
[root@fedora ~]# uname -a
Linux fedora 5.17.5-200.fc35.x86_64 #1 SMP PREEMPT Thu Apr 28 15:41:41 
UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

Time to go ask more questions of these developers.

Thanks,
-Jon

