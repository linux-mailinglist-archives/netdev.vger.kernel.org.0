Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6A7597E9
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfF1JvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:51:17 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:42695 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfF1JvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:51:17 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id 5B427C10FE;
        Fri, 28 Jun 2019 17:51:11 +0800 (CST)
Subject: Re: [PATCH 2/3 nf-next] netfilter:nf_flow_table: Support bridge type
 flow offload
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
 <1561545148-11978-2-git-send-email-wenxu@ucloud.cn>
 <20190626183816.3ux3iifxaal4ffil@breakpoint.cc>
 <20190626191945.2mktaqrcrfcrfc66@breakpoint.cc>
 <dce5cba2-766c-063e-745f-23b3dd83494b@ucloud.cn>
 <20190627125839.t56fnptdeqixt7wd@salvia>
 <b2a48653-9f30-18a9-d0e1-eaa940a361a9@ucloud.cn>
 <20190628060617.az2quv4bodrenuli@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <6c0f1fb6-426d-0af0-13a5-b9c95c8abf21@ucloud.cn>
Date:   Fri, 28 Jun 2019 17:51:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190628060617.az2quv4bodrenuli@breakpoint.cc>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVklVSU9DS0tLSk9PQk5DTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OSo6Hhw4KzgxUQsjDwFIAxIa
        Sz8wCkpVSlVKTk1KTEpOT0xKTU9JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUNMSjcG
X-HM-Tid: 0a6b9d7ef4b82085kuqy5b427c10fe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/28/2019 2:06 PM, Florian Westphal wrote:
> wenxu <wenxu@ucloud.cn> wrote:
>> ns21 iperf to 10.0.0.8 with dport 22 in ns22
>> first time with OFFLOAD enable
>>
>> nft add flowtable bridge firewall fb2 { hook ingress priority 0 \; devices = { veth21, veth22 } \; }
>> nft add chain bridge firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
>> nft add rule bridge firewall ftb-all counter ct zone 2 ip protocol tcp flow offload @fb2
>>
>> # iperf -c 10.0.0.8 -p 22 -t 60 -i2
> [..]
>> [  3]  0.0-60.0 sec   353 GBytes  50.5 Gbits/sec
>>
>> The second time on any offload:
>> # iperf -c 10.0.0.8 -p 22 -t 60 -i2
>> [  3]  0.0-60.0 sec   271 GBytes  38.8 Gbits/sec
> Wow, this is pretty impressive.  Do you have numbers without
> offload and no connection tracking?

There is no other connection  on the bridge in zone 2

>
> Is this with CONFIG_RETPOLINE=y (just curious)?
Yes, it is enable.
