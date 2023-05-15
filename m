Return-Path: <netdev+bounces-2619-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F16D4702B90
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E37A11C20B41
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC4DC2C3;
	Mon, 15 May 2023 11:35:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF751C13
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:35:25 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBCF136
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:35:22 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-965f7bdab6bso2223049966b.3
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684150521; x=1686742521;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xztHzgcijUmplEitwv5lAMxAAeOSekWVxsiQy/edhE4=;
        b=ZskkHAf+hKHUuZja6DF3GXrz7NmyvtTG86Nj5f8c6nE0UyqfmakLr0s/AEZT5IKzpR
         ZO6Rzv+xE8v4ftzW7xXoej1aqdbddrMcNLgsUW5W0XLfUOz/iCNXpYqqQABRIZpQxq/B
         Sh8AQzF5X6bAZ07852RrtGZxE7tY2WkseFCMg3ANhIrep6L/3ut/P8+pM2ZD0oihAyRi
         ZPT/E6Gyjd0+q9Mz/c527ktePNT5p/Z/C0v5b6fjQ2VRssomasjhiHIevHwCX6niJgwW
         1Q8rDdCeE5GqRuR/grjOFQjVRPMM/tnu+KO71sSO0jUnkTru5Yhv/7Ds0JmyT3xngM3F
         e0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684150521; x=1686742521;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xztHzgcijUmplEitwv5lAMxAAeOSekWVxsiQy/edhE4=;
        b=HyzwU1kAVgElnk4LPHU28gtuEopqoAzK7uTpIUNC1S2ew96rQk5ikbMeI/o25WAMm7
         iPKgIpdCnyt16ph8wxQp5+oeShLvbIsTPkxbfFigfdCc/7/rnK0gxzMj187oxC7YxCLz
         51mYOOlv9zC73ba7HjGF/jHvO09jybMn/5Ghn9p0kbbN48bRZu/ZwXlOpSoDFkz5YeDI
         RKaoUYQdCuknWTVwntGjs4rarLhrAYYKbbmdgNjfqA7G6ktmgcbU3/jv+lvcMDckLlbY
         7uVov/+uefiRcHS0wB8JkLhviDCHtPKNlj+QAv7iQFhdSkSW0HZT3vwqq/p/8wM5zGFe
         edVg==
X-Gm-Message-State: AC+VfDzOm/oQrf1BTlC7A96U3wmU2ujtbl71Vb7aHT6jexGnfH249BcL
	+qF6X2fBUD6yDZHgBvuZjzDUpw==
X-Google-Smtp-Source: ACHHUZ4O2iGOq+TkBJdHcs/nKlxGNM/KJkL7dZmPqNSsb1f1Fs9bSh5iIcltomwGeBoAhrMdqFb8LA==
X-Received: by 2002:a17:906:dac8:b0:94e:e97b:c65 with SMTP id xi8-20020a170906dac800b0094ee97b0c65mr28729965ejb.60.1684150520603;
        Mon, 15 May 2023 04:35:20 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y10-20020a170906914a00b009663cf5dc3bsm9269129ejw.53.2023.05.15.04.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 04:35:20 -0700 (PDT)
Date: Mon, 15 May 2023 13:35:18 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, jacob.e.keller@intel.com,
	saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to
 static one
Message-ID: <ZGIY9jOHkHxbnTjq@nanopsycho>
References: <20230510144621.932017-1-jiri@resnulli.us>
 <CGME20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7@eucas1p2.samsung.com>
 <600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 15, 2023 at 11:09:10AM CEST, m.szyprowski@samsung.com wrote:
>On 10.05.2023 16:46, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>>
>> The commit 565b4824c39f ("devlink: change port event netdev notifier
>> from per-net to global") changed original per-net notifier to be
>> per-devlink instance. That fixed the issue of non-receiving events
>> of netdev uninit if that moved to a different namespace.
>> That worked fine in -net tree.
>>
>> However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
>> separate devlink instance for ethernet auxiliary device") and
>> commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
>> case of PCI device suspend") were merged, a deadlock was introduced
>> when removing a namespace with devlink instance with another nested
>> instance.
>>
>> Here there is the bad flow example resulting in deadlock with mlx5:
>> net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
>> devlink_pernet_pre_exit() -> devlink_reload() ->
>> mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
>> mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
>> mlx5e_destroy_devlink() -> devlink_free() ->
>> unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)
>>
>> Steps to reproduce:
>> $ modprobe mlx5_core
>> $ ip netns add ns1
>> $ devlink dev reload pci/0000:08:00.0 netns ns1
>> $ ip netns del ns1
>>
>> Resolve this by converting the notifier from per-devlink instance to
>> a static one registered during init phase and leaving it registered
>> forever. Use this notifier for all devlink port instances created
>> later on.
>>
>> Note what a tree needs this fix only in case all of the cited fixes
>> commits are present.
>>
>> Reported-by: Moshe Shemesh <moshe@nvidia.com>
>> Fixes: 565b4824c39f ("devlink: change port event netdev notifier from per-net to global")
>> Fixes: ee75f1fc44dd ("net/mlx5e: Create separate devlink instance for ethernet auxiliary device")
>> Fixes: 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in case of PCI device suspend")
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>This patch landed recently in linux-next as commit e93c9378e33f 
>("devlink: change per-devlink netdev notifier to static one"). 
>Unfortunately it causes serious regression with kernel compiled from 
>multi_v7_defconfig (ARM 32bit) on all my test boards. Here is a example 
>of the boot failure observed on QEMU's virt ARM 32bit machine:
>
>8<--- cut here ---
>Unable to handle kernel execution of memory at virtual address e5150010 
>when execute
>[e5150010] *pgd=4267a811, *pte=04750653, *ppte=04750453
>Internal error: Oops: 8000000f [#1] SMP ARM
>Modules linked in:
>CPU: 0 PID: 779 Comm: ip Not tainted 6.4.0-rc2-next-20230515 #6688
>Hardware name: Generic DT based system
>PC is at 0xe5150010
>LR is at notifier_call_chain+0x60/0x11c
>pc : [<e5150010>]    lr : [<c0365f50>]    psr: 60000013
>...
>Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>Control: 10c5387d  Table: 4397806a  DAC: 00000051
>...
>Process ip (pid: 779, stack limit = 0x82b757b5)
>Stack: (0xe9201a00 to 0xe9202000)
>...
>  notifier_call_chain from raw_notifier_call_chain+0x18/0x20
>  raw_notifier_call_chain from __dev_open+0x74/0x190
>  __dev_open from __dev_change_flags+0x17c/0x1f4
>  __dev_change_flags from dev_change_flags+0x18/0x54
>  dev_change_flags from do_setlink+0x24c/0xefc
>  do_setlink from rtnl_newlink+0x534/0x818
>  rtnl_newlink from rtnetlink_rcv_msg+0x250/0x300
>  rtnetlink_rcv_msg from netlink_rcv_skb+0xb8/0x110
>  netlink_rcv_skb from netlink_unicast+0x1f8/0x2bc
>  netlink_unicast from netlink_sendmsg+0x1cc/0x44c
>  netlink_sendmsg from ____sys_sendmsg+0x9c/0x260
>  ____sys_sendmsg from ___sys_sendmsg+0x68/0x94
>  ___sys_sendmsg from sys_sendmsg+0x4c/0x88
>  sys_sendmsg from ret_fast_syscall+0x0/0x54
>Exception stack(0xe9201fa8 to 0xe9201ff0)

Thanks for the report. From the first sight, don't have a clue what may
be wrong. Debugging.


>...
>---[ end trace 0000000000000000 ]---
>[....] Configuring network interfaces...Segmentation fault
>ifup: failed to bring up lo
>
>
>Reverting $subject patch on top of linux next-20230515 fixes this issue.
>
>
>> ---
>>   net/devlink/core.c          | 16 +++++++---------
>>   net/devlink/devl_internal.h |  1 -
>>   net/devlink/leftover.c      |  5 ++---
>>   3 files changed, 9 insertions(+), 13 deletions(-)
>>
>> diff --git a/net/devlink/core.c b/net/devlink/core.c
>> index 777b091ef74d..0e58eee44bdb 100644
>> --- a/net/devlink/core.c
>> +++ b/net/devlink/core.c
>> @@ -204,11 +204,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>>   	if (ret < 0)
>>   		goto err_xa_alloc;
>>   
>> -	devlink->netdevice_nb.notifier_call = devlink_port_netdevice_event;
>> -	ret = register_netdevice_notifier(&devlink->netdevice_nb);
>> -	if (ret)
>> -		goto err_register_netdevice_notifier;
>> -
>>   	devlink->dev = dev;
>>   	devlink->ops = ops;
>>   	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
>> @@ -233,8 +228,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>>   
>>   	return devlink;
>>   
>> -err_register_netdevice_notifier:
>> -	xa_erase(&devlinks, devlink->index);
>>   err_xa_alloc:
>>   	kfree(devlink);
>>   	return NULL;
>> @@ -266,8 +259,6 @@ void devlink_free(struct devlink *devlink)
>>   	xa_destroy(&devlink->params);
>>   	xa_destroy(&devlink->ports);
>>   
>> -	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink->netdevice_nb));
>> -
>>   	xa_erase(&devlinks, devlink->index);
>>   
>>   	devlink_put(devlink);
>> @@ -303,6 +294,10 @@ static struct pernet_operations devlink_pernet_ops __net_initdata = {
>>   	.pre_exit = devlink_pernet_pre_exit,
>>   };
>>   
>> +static struct notifier_block devlink_port_netdevice_nb __net_initdata = {
>> +	.notifier_call = devlink_port_netdevice_event,
>> +};
>> +
>>   static int __init devlink_init(void)
>>   {
>>   	int err;
>> @@ -311,6 +306,9 @@ static int __init devlink_init(void)
>>   	if (err)
>>   		goto out;
>>   	err = register_pernet_subsys(&devlink_pernet_ops);
>> +	if (err)
>> +		goto out;
>> +	err = register_netdevice_notifier(&devlink_port_netdevice_nb);
>>   
>>   out:
>>   	WARN_ON(err);
>> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>> index e133f423294a..62921b2eb0d3 100644
>> --- a/net/devlink/devl_internal.h
>> +++ b/net/devlink/devl_internal.h
>> @@ -50,7 +50,6 @@ struct devlink {
>>   	u8 reload_failed:1;
>>   	refcount_t refcount;
>>   	struct rcu_work rwork;
>> -	struct notifier_block netdevice_nb;
>>   	char priv[] __aligned(NETDEV_ALIGN);
>>   };
>>   
>> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
>> index dffca2f9bfa7..cd0254968076 100644
>> --- a/net/devlink/leftover.c
>> +++ b/net/devlink/leftover.c
>> @@ -7073,10 +7073,9 @@ int devlink_port_netdevice_event(struct notifier_block *nb,
>>   	struct devlink_port *devlink_port = netdev->devlink_port;
>>   	struct devlink *devlink;
>>   
>> -	devlink = container_of(nb, struct devlink, netdevice_nb);
>> -
>> -	if (!devlink_port || devlink_port->devlink != devlink)
>> +	if (!devlink_port)
>>   		return NOTIFY_OK;
>> +	devlink = devlink_port->devlink;
>>   
>>   	switch (event) {
>>   	case NETDEV_POST_INIT:
>
>Best regards
>-- 
>Marek Szyprowski, PhD
>Samsung R&D Institute Poland
>

