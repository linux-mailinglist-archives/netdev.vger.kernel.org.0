Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BDE661F87
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjAIH5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbjAIH5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:57:17 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB80913DDF;
        Sun,  8 Jan 2023 23:57:10 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Nr5nW543bz67bpd;
        Mon,  9 Jan 2023 15:54:39 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 9 Jan 2023 07:57:07 +0000
Message-ID: <885a23b1-78d2-1e62-8d07-91ff33863cbf@huawei.com>
Date:   Mon, 9 Jan 2023 10:57:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 11/12] samples/landlock: Add network demo
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-12-konstantin.meskhidze@huawei.com>
 <2ff97355-18ef-e539-b4c1-720cd83daf1d@digikod.net>
 <94a8ef89-b59e-d218-77a1-bf2f9d4096c7@huawei.com>
 <5c941be9-ac6a-d259-997e-13fdff09aeb4@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <5c941be9-ac6a-d259-997e-13fdff09aeb4@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



1/6/2023 10:34 PM, Mickaël Salaün пишет:
> 
> On 05/01/2023 04:46, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/16/2022 5:25 PM, Mickaël Salaün пишет:
> 
> [...]
> 
>>>
>>>>    		fprintf(stderr,
>>>>    			"Hint: You should update the running kernel "
>>>>    			"to leverage Landlock features "
>>>> @@ -259,16 +342,36 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>>>    	access_fs_ro &= ruleset_attr.handled_access_fs;
>>>>    	access_fs_rw &= ruleset_attr.handled_access_fs;
>>>>
>>>> +	/* Removes bind access attribute if not supported by a user. */
>>>> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
>>>> +	if (!env_port_name) {
>>>
>>> You can move this logic at the populate_ruleset_net() call site and
>>> update this helper to not call getenv() twice for the same variable.
>> 
>>     But here I exclude ruleset attributes, not rule itself. It will break
>>     the logic: creating a ruleset then applying rules.
>>     I suggest to leave here as its.
> 
> Right, but you can still avoid the duplicate getenv() calls.

   OK. Will fix it.
> 
> 
>>>
>>>
>>>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_BIND_TCP;
>>>> +	}
>>>> +	/* Removes connect access attribute if not supported by a user. */
>>>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>>>> +	if (!env_port_name) {
>>>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>>>> +	}
>>>> +	ruleset_attr.handled_access_net &= access_net_tcp;
> .
