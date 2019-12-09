Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B992116B63
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfLIKtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:49:00 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:42415 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfLIKtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 05:49:00 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 5DA3341BFC;
        Mon,  9 Dec 2019 18:48:55 +0800 (CST)
Subject: Re: Question about flow table offload in mlx5e
To:     Paul Blakey <paulb@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
 <VI1PR05MB34224DF57470AE3CC46F2CACCF4E0@VI1PR05MB3422.eurprd05.prod.outlook.com>
 <746ba973-3c58-31f8-42ce-db880fd1d8f4@ucloud.cn>
 <VI1PR05MB3422BEDAB38E12C26DF7C6C6CF4E0@VI1PR05MB3422.eurprd05.prod.outlook.com>
 <64285654-bc9a-c76e-5875-dc6e434dc4d4@ucloud.cn>
 <AM4PR05MB3411EE998E04B7AA9E0081F0CF4B0@AM4PR05MB3411.eurprd05.prod.outlook.com>
 <1b13e159-1030-2ea3-f69e-578041504ee6@ucloud.cn>
 <84874b42-c525-2149-539d-e7510d15f6a6@mellanox.com>
 <dc72770c-8bc3-d302-be73-f19f9bbe269f@ucloud.cn>
 <057b0ab1-5ce3-61f0-a59e-1c316e414c84@mellanox.com>
 <4ecddff0-5ba4-51f7-1544-3d76d43b6b39@mellanox.com>
 <5ce27064-97ee-a36d-8f20-10a0afe739cf@ucloud.cn>
 <c06ff5a3-e099-9476-7085-1cd72a9ffc56@ucloud.cn>
 <e8fadfa2-0145-097b-9779-b5263ff3d7b7@mellanox.com>
 <052c1c18-89cb-53ed-344c-decd4d296db3@mellanox.com>
 <c042b39b-3db8-3a61-841d-da930a912a79@ucloud.cn>
 <01602d82-b46c-07d2-dea7-baa3545db80f@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <52204ad2-e700-2e45-d562-7ceaa0e08b1b@ucloud.cn>
Date:   Mon, 9 Dec 2019 18:48:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <01602d82-b46c-07d2-dea7-baa3545db80f@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0pCS0tLS0lCTk1IQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6My46Ggw6Tzg4KUkIAS0QURoI
        AiowCRNVSlVKTkxOQ0NDTkhOTkJMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSkpPT0o3Bg++
X-HM-Tid: 0a6eea46bf922086kuqy5da3341bfc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/9/2019 3:48 PM, Paul Blakey wrote:
> On 12/9/2019 5:18 AM, wenxu wrote:
>> Hi  Paul,
>>
>>
>> Thanks for your fix, I will test it.
>>
>> On 12/8/2019 5:39 PM, Paul Blakey wrote:
>>> Here's the temp fix:
>>>
>>>
>>> The problem is TC + FT offload, and this revealed a bug in the driver.
>>>
>>> For the tunnel test, we changed tc block offload to ft callback, and
>>> didn't change the indr block offload.
>>>
>>> So the tunnel unset rule is offloaded from indr tc callback (it's
>>> indirect because it's on tun1 device):
>>>
>>> mlx5e_rep_indr_setup_block_cb
>> Maybe It should add a "mlx5e_rep_indr_setup_ft_cb" makes the FT offload can support the indr setup?
>>
>> Or all indr setup through TC offload?
> Adding a "mlx5e_rep_indr_setup_ft_cb" with the correct flags (FT) and 
> (EGRESS) should work as well, but this is just a test...
>
> For upstream, I see you're talking with pablo about the pending tunnel 
> offload support.

I test your fix patch, it is work now.

But if there is no your fix patch and  I only add a  mlx5e_rep_indr_setup_ft_cb

with the FT flags, it also can't work (both rep_setup and indr_rep_setup with

FT flags. I can make it work with adding your fix patch.  It seems not a problem of

TC + FT offload?


>
>
>>> this offloaded the rule to hardware in the TC domain.
>>>
>>> Now the tunnel set (encap) rule was offloaded to FT domain.
>>>
>>>
>>> Since TC comes before FT in software, we should have connected the miss
>>> on TC domain to FT domain,
>>>
>>> but this didn't work.
>>>
>>> The below fix should fix that connection:
>>>
>>>
>>> ------------------------------------------
>>>
>>>
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
>>> @@ -763,9 +763,6 @@ static struct mlx5_flow_table
>>> *find_closest_ft_recursive(struct fs_node  *root,
>>>           struct fs_node *iter = list_entry(start, struct fs_node, list);
>>>           struct mlx5_flow_table *ft = NULL;
>>>
>>> -       if (!root || root->type == FS_TYPE_PRIO_CHAINS)
>>> -               return NULL;
>>> -
>>>           list_for_each_advance_continue(iter, &root->children, reverse) {
>>>                   if (iter->type == FS_TYPE_FLOW_TABLE) {
>>>                           fs_get_obj(ft, iter);
>>> @@ -792,7 +789,10 @@ static struct mlx5_flow_table
>>> *find_closest_ft(struct fs_prio *prio, bool revers
>>>           parent = prio->node.parent;
>>>           curr_node = &prio->node;
>>>           while (!ft && parent) {
>>> -               ft = find_closest_ft_recursive(parent, &curr_node->list,
>>> reverse);
>>> +               if (parent->type != FS_TYPE_PRIO_CHAINS)
>>> +                       ft = find_closest_ft_recursive(parent,
>>> + &curr_node->list,
>>> +                                                      reverse);
>>>                   curr_node = parent;
>>>                   parent = curr_node->parent;
>>>           }
>>>
>>>
>>> ------------------------------------------
>>>
>>>
>>> I will do this patch for upstream if needed after our last patchset that
>>> also touched this area.
>>>
>>> Thanks,
>>>
>>> Paul.
>>>
>>>
>>>
>>>
>>> On 12/5/2019 5:17 PM, Paul Blakey wrote:
>>>> On 12/2/2019 5:37 AM, wenxu wrote:
>>>>
>>>>> Hi Paul,
>>>>>
>>>>>
>>>>> Sorry for trouble you again. I think it is a problem in ft callback.
>>>>>
>>>>> Can your help me fix it. Thx!
>>>>>
>>>>> I did the test like you with route tc rules to ft callback.
>>>>>
>>>>> # ifconfig mlx_p0 172.168.152.75/24 up
>>>>> # ip n r 172.16.152.241 lladdr fa:fa:ff:ff:ff:ff dev mlx_p0
>>>>>
>>>>> # ip l add dev tun1 type gretap external
>>>>> # tc qdisc add dev tun1 ingress
>>>>> # tc qdisc add dev mlx_pf0vf0 ingress
>>>>>
>>>>> # tc filter add dev mlx_pf0vf0 pref 2 ingress  protocol ip flower
>>>>> skip_sw  action tunnel_key set dst_ip 172.168.152.241 src_ip 0 id
>>>>> 1000 nocsum pipe action mirred egress redirect dev tun1
>>>>>
>>>>>
>>>>> In The vm:
>>>>> # ifconfig eth0 10.0.0.75/24 up
>>>>> # ip n r 10.0.0.77 lladdr fa:ff:ff:ff:ff:ff dev eth0
>>>>>
>>>>> # iperf -c 10.0.0.77 -t 100 -i 2
>>>>>
>>>>> The syn packets can be offloaded successfully.
>>>>>
>>>>> # # tc -s filter ls dev mlx_pf0vf0 ingress
>>>>> filter protocol ip pref 2 flower chain 0
>>>>> filter protocol ip pref 2 flower chain 0 handle 0x1
>>>>>     eth_type ipv4
>>>>>     skip_sw
>>>>>     in_hw in_hw_count 1
>>>>>      action order 1: tunnel_key  set
>>>>>      src_ip 0.0.0.0
>>>>>      dst_ip 172.168.152.241
>>>>>      key_id 1000
>>>>>      nocsum pipe
>>>>>       index 1 ref 1 bind 1 installed 252 sec used 252 sec
>>>>>      Action statistics:
>>>>>      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>>>      backlog 0b 0p requeues 0
>>>>>
>>>>>      action order 2: mirred (Egress Redirect to device tun1) stolen
>>>>>        index 1 ref 1 bind 1 installed 252 sec used 110 sec
>>>>>        Action statistics:
>>>>>      Sent 3420 bytes 11 pkt (dropped 0, overlimits 0 requeues 0)
>>>>>      Sent software 0 bytes 0 pkt
>>>>>      Sent hardware 3420 bytes 11 pkt
>>>>>      backlog 0b 0p requeues 0
>>>>>
>>>>> But Then I add another decap filter on tun1:
>>>>>
>>>>> tc filter add dev tun1 pref 2 ingress protocol ip flower enc_key_id
>>>>> 1000 enc_src_ip 172.168.152.241 action tunnel_key unset pipe action
>>>>> mirred egress redirect dev mlx_pf0vf0
>>>>>
>>>>> # iperf -c 10.0.0.77 -t 100 -i 2
>>>>>
>>>>> The syn packets can't be offloaded. The tc filter counter is also not
>>>>> increase.
>>>>>
>>>>>
>>>>> # tc -s filter ls dev mlx_pf0vf0 ingress
>>>>> filter protocol ip pref 2 flower chain 0
>>>>> filter protocol ip pref 2 flower chain 0 handle 0x1
>>>>>     eth_type ipv4
>>>>>     skip_sw
>>>>>     in_hw in_hw_count 1
>>>>>      action order 1: tunnel_key  set
>>>>>      src_ip 0.0.0.0
>>>>>      dst_ip 172.168.152.241
>>>>>      key_id 1000
>>>>>      nocsum pipe
>>>>>       index 1 ref 1 bind 1 installed 320 sec used 320 sec
>>>>>      Action statistics:
>>>>>      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>>>      backlog 0b 0p requeues 0
>>>>>
>>>>>      action order 2: mirred (Egress Redirect to device tun1) stolen
>>>>>        index 1 ref 1 bind 1 installed 320 sec used 178 sec
>>>>>        Action statistics:
>>>>>      Sent 3420 bytes 11 pkt (dropped 0, overlimits 0 requeues 0)
>>>>>      Sent software 0 bytes 0 pkt
>>>>>      Sent hardware 3420 bytes 11 pkt
>>>>>      backlog 0b 0p requeues 0
>>>>>
>>>>> # tc -s filter ls dev tun1 ingress
>>>>> filter protocol ip pref 2 flower chain 0
>>>>> filter protocol ip pref 2 flower chain 0 handle 0x1
>>>>>     eth_type ipv4
>>>>>     enc_src_ip 172.168.152.241
>>>>>     enc_key_id 1000
>>>>>     in_hw in_hw_count 1
>>>>>      action order 1: tunnel_key  unset pipe
>>>>>       index 2 ref 1 bind 1 installed 391 sec used 391 sec
>>>>>      Action statistics:
>>>>>      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>>>      backlog 0b 0p requeues 0
>>>>>
>>>>>      action order 2: mirred (Egress Redirect to device mlx_pf0vf0) stolen
>>>>>        index 2 ref 1 bind 1 installed 391 sec used 391 sec
>>>>>        Action statistics:
>>>>>      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>>>      backlog 0b 0p requeues 0
>>>>>
>>>>>
>>>>> So there maybe some problem for ft callback setup. When there is
>>>>> another reverse
>>>>> decap rule add in tunnel device, The encap rule will not offloaded
>>>>> the packets.
>>>>>
>>>>> Expect your help Thx!
>>>>>
>>>>>
>>>>> BR
>>>>> wenxu
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>> Hi I reproduced it.
>>>>
>>>> I'll find the reason and fix for it and get back to you soon.
>>>>
>>>> We are planing on expanding our chain and prio supported range, and in
>>>> that we also move the FT offload code a bit.
>>>>
>>>> If what I think happens happened it would fix it anyway.
>>>>
>>>> Thanks.
>>>>
