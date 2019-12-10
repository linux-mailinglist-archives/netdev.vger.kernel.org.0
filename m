Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8441180D4
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 07:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfLJGxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 01:53:20 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:33965 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbfLJGxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 01:53:20 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8FCC641A06;
        Tue, 10 Dec 2019 14:53:18 +0800 (CST)
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
Message-ID: <b2c878e0-bf8a-5fa5-77d8-598291137bf5@ucloud.cn>
Date:   Tue, 10 Dec 2019 14:53:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <01602d82-b46c-07d2-dea7-baa3545db80f@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUhMS0tLSktMTE1OSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MU06Ohw5Tzg5PUk5ISsOKj8c
        GjQKCh5VSlVKTkxOQk1LTEJDTEpNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSENNQjcG
X-HM-Tid: 0a6eee9565c82086kuqy8fcc641a06
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

Indeed, I test with a mlx5e_rep_indr_setup_ft_c, it is also work as well.

Thanks paul!

