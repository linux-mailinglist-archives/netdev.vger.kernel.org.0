Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B552A12C4
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJaB5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:57:38 -0400
Received: from novek.ru ([213.148.174.62]:57650 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJaB5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 21:57:38 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2588C5019A8;
        Sat, 31 Oct 2020 04:59:44 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2588C5019A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1604109585; bh=C+1SWpEK5XM9jQfUmK5F7PYwBvmEMe8cQ7TN4WJHgeU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=guiTFdDH0ozLvEHYoPlFo6NLXH8E1xEccluxykkbs1tBmR7Z1OTapCnAgZZYSl8bm
         itMcUsBA8IkYfKvVNxL3SWVSRGak+jpr2rF8AZCwmHh7U3c3kSwhEdJcyktpf0kpWN
         XgeOhp6cF0OdrQs2Rh06YloxuFdQ1oCYcO5kjBqo=
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>
References: <20201016111156.26927-1-ovov@yandex-team.ru>
 <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
 <0E7BC212-3BBA-4C68-89B9-C6DA956553AD@yandex-team.ru>
 <CA+FuTSfNZoONM3TZxpC0ND2AsiNw0K-jgjKMe0FWkS9LVG6yNA@mail.gmail.com>
 <ABA7FBA9-42F8-4D6E-9D1E-CDEC74966131@yandex-team.ru>
 <CA+FuTSeejYh2eu80bB8MikUMb7KevQN-ka-+anfTfQATPSrKHA@mail.gmail.com>
 <93a65f76-3052-6162-a2f4-00091cd78927@novek.ru>
 <E9B679B3-58CA-4BB7-A9B9-1A28A6148D75@yandex-team.ru>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <8e2bf546-08db-4875-8fcb-6ab541437b7b@novek.ru>
Date:   Sat, 31 Oct 2020 01:57:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <E9B679B3-58CA-4BB7-A9B9-1A28A6148D75@yandex-team.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.10.2020 12:54, Alexander Ovechkin wrote:
> On 30 Oct 2020, at 14:01, Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>> Could not reproduce the bug. Could you please provide a test scenario?
> It can be reproduced if your net device doesn’t support udp tunnel segmentation (i.e its features do not have SKB_GSO_UDP_TUNNEL).
> If you try to send packet larger than the MTU fou6-only tunnel (without any other encap) it will be dropped, because of invalid skb->inner_ipproto (that will be equal to IPPROTO_UDP — outer protocol, instead of IPPROTO_IPV6).
> skb->inner_ipproto is used here:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/net/ipv4/udp_offload.c?id=07e0887302450a62f51dba72df6afb5fabb23d1c#n168
Ok, all my tests show that MPLS encap is working after this moving, so I have no 
concerns too.
