Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9377010B08E
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfK0Nq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:46:26 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:19744 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfK0Nq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:46:26 -0500
Received: from [192.168.1.7] (unknown [180.157.109.16])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id CA2A041B4E;
        Wed, 27 Nov 2019 21:46:20 +0800 (CST)
Subject: Re: Question about flow table offload in mlx5e
To:     Paul Blakey <paulb@mellanox.com>
Cc:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
 <20191119.163923.660983355933809356.davem@davemloft.net>
 <2a08a1aa-6aa8-c361-f825-458d234d975f@ucloud.cn>
 <AM4PR05MB3411591D31D7B22EE96BC6C3CF4E0@AM4PR05MB3411.eurprd05.prod.outlook.com>
 <f0552f13-ae5d-7082-9f68-0358d560c073@ucloud.cn>
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
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <5ce27064-97ee-a36d-8f20-10a0afe739cf@ucloud.cn>
Date:   Wed, 27 Nov 2019 21:45:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <4ecddff0-5ba4-51f7-1544-3d76d43b6b39@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQkpNS0tLS0tDTkNIS0xZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MEk6Sww6TDg9EwMLDDEvIwo5
        DwkwChdVSlVKTkxPQ01JSENKSkhMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSktCVUpNWVdZCAFZQU9MTkw3Bg++
X-HM-Tid: 0a6ead1cdff12086kuqyca2a041b4e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/11/27 21:20, Paul Blakey 写道:
> On 11/27/2019 3:11 PM, Paul Blakey wrote:
>> On 11/27/2019 2:16 PM, wenxu wrote:
>>
>>> Sorry maybe something mess you,  Ignore with my patches.
>>>
>>>
>>> I also did the test like you with route tc rules to ft callback.
>>>
>>>
>>> please also did the following test:  mlx_p0 is the pf and mlx_pf0vf0 
>>> is the vf .
>>>
>> Are you  in switchdev mode (via devlink) or default legacy mode?
>>
>>
> mlx_pf0vf0  is representor device created after entring switchdev mode? and eth0 in vm is the binded mlx5 VF?

Yes, mlx_pf0vf0 is the representor and eth0 in vm is VF. It also in the switchdev mode.


sudo grep -ri "" /sys/class/net/*/phys_* 2>/dev/null
/sys/class/net/mlx_p0/phys_port_name:p0
/sys/class/net/mlx_p0/phys_switch_id:34ebc100034b6b50
/sys/class/net/mlx_pf0vf0/phys_port_name:pf0vf0
/sys/class/net/mlx_pf0vf0/phys_switch_id:34ebc100034b6b50
/sys/class/net/mlx_pf0vf1/phys_port_name:pf0vf1
/sys/class/net/mlx_pf0vf1/phys_switch_id:34ebc100034b6b50

The problem is when the last filter add in the tun1 will lead the outgoing syn packets can't be real offloaded

>
> Can you run this command:
>
> sudo grep -ri "" /sys/class/net/*/phys_* 2>/dev/null
>
> example:
> /sys/class/net/ens1f0_0/phys_port_name:pf0vf0
> /sys/class/net/ens1f0_0/phys_switch_id:b828a50003078a24
> /sys/class/net/ens1f0_1/phys_port_name:pf0vf1
> /sys/class/net/ens1f0_1/phys_switch_id:b828a50003078a24
> /sys/class/net/ens1f0/phys_port_name:p0
> /sys/class/net/ens1f0/phys_switch_id:b828a50003078a24
>
> and
> sudo ls /sys/class/net/*/device/virtfn*/net
>
> example:
> /sys/class/net/ens1f0/device/virtfn0/net:
> ens1f2
>
> /sys/class/net/ens1f0/device/virtfn1/net:
> ens1f3
>
> and even
>
> lspci | grep -i mellanox ; ls -l /sys/class/net
>
>
>
>
>
>
> Thansk.
>
>
