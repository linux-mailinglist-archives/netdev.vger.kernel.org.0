Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D123865AEC2
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 10:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjABJlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 04:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABJlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 04:41:08 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D7FDE2
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 01:41:04 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b88so31990938edf.6
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 01:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kDmA1WK4H//tAZ17afWlJRxfR1nYbtRqi0mSHRZvH+c=;
        b=PjRjUED6y90Wa+0v9nx5L7LCV/K+LjL9v43f0S+hVP9bzD+U4buOpGDOzogjreD2ZH
         V8gDkpZltc7qNWlc5Vu2UxiGVuImBdxoNinv6scDjvJc+eHmqe2Md7szcWstZsBmlLwP
         dft1i6HU9IFW5URWfybsF5/VH1x2+CSF2mkiP99mtwfUTcsF0HgVqX8J6FNDEYSAtGQP
         TWxNfXw73+CJjtlUxbhTW1ROEkk+JWmkMOlxFtim5pmqVgoGHYUWQOr71wqkgM3pATln
         Pc/HDyqqz+49CK+k55QhCaiGxXTNZDJktF3np1xYLCPxoKUBr+i0PXiB0xp35dvyGlad
         AVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kDmA1WK4H//tAZ17afWlJRxfR1nYbtRqi0mSHRZvH+c=;
        b=z8dJW9jOr3aDhfIj+NZB+RbyrUL15dHwsdTfIH1kQQtq+0Hd6FLMpNRFENw6oQyXIT
         Hn5/kt1J4e291tBfEJ+O7L7lP+ZOdrhOsjegHMsJpupdGX9i2XaRGlkDLK90KRXENWFc
         N6NoYXFkYwK19PIp7k6PbL2ysrRNByqaeHMk+YhmHc8ITOu4am8ANjJc/cx7OvWaFM4U
         hKLG98wZRuFba+tdGfwcvTW4N8hbLBmu711G8I/ShY9WtZhxKZ00e1L4T1JXZHAAO5AU
         mUPaOOQMlbGdW2w63LL0q5AFWRfSok15LS90JziLGsT/BfCgnN9OifzBA2UM0jrm8EPL
         g6Bg==
X-Gm-Message-State: AFqh2kqeOJfEeSdwilRvv3IWbIZwY84ddOAM0sWvx5TKJgU+TGqymNo+
        pr7fpxvEzr2hfFjci+/+b1abtj/cvwGsfXK9ISo=
X-Google-Smtp-Source: AMrXdXsy1Ba135wIgK1VcfIz01vYKVdVrogcTfltRR26rYWXyz7P20OAj27bvMeCl8L1/RiqJN1XNA==
X-Received: by 2002:a05:6402:2296:b0:46a:96b3:22bf with SMTP id cw22-20020a056402229600b0046a96b322bfmr42868898edb.17.1672652462920;
        Mon, 02 Jan 2023 01:41:02 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id k14-20020a05640212ce00b0045b910b0542sm12300984edx.15.2023.01.02.01.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 01:41:02 -0800 (PST)
Message-ID: <c04548d9-8d07-0412-dae8-2daf4e4f7e8b@blackwall.org>
Date:   Mon, 2 Jan 2023 11:41:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] vxlan: Fix memory leaks in error path
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20230102065556.3886530-1-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230102065556.3886530-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/01/2023 08:55, Ido Schimmel wrote:
> The memory allocated by vxlan_vnigroup_init() is not freed in the error
> path, leading to memory leaks [1]. Fix by calling
> vxlan_vnigroup_uninit() in the error path.
> 
> The leaks can be reproduced by annotating gro_cells_init() with
> ALLOW_ERROR_INJECTION() and then running:
> 
>  # echo "100" > /sys/kernel/debug/fail_function/probability
>  # echo "1" > /sys/kernel/debug/fail_function/times
>  # echo "gro_cells_init" > /sys/kernel/debug/fail_function/inject
>  # printf %#x -12 > /sys/kernel/debug/fail_function/gro_cells_init/retval
>  # ip link add name vxlan0 type vxlan dstport 4789 external vnifilter
>  RTNETLINK answers: Cannot allocate memory
> 
> [1]
> unreferenced object 0xffff88810db84a00 (size 512):
>   comm "ip", pid 330, jiffies 4295010045 (age 66.016s)
>   hex dump (first 32 bytes):
>     f8 d5 76 0e 81 88 ff ff 01 00 00 00 00 00 00 02  ..v.............
>     03 00 04 00 48 00 00 00 00 00 00 01 04 00 01 00  ....H...........
>   backtrace:
>     [<ffffffff81a3097a>] kmalloc_trace+0x2a/0x60
>     [<ffffffff82f049fc>] vxlan_vnigroup_init+0x4c/0x160
>     [<ffffffff82ecd69e>] vxlan_init+0x1ae/0x280
>     [<ffffffff836858ca>] register_netdevice+0x57a/0x16d0
>     [<ffffffff82ef67b7>] __vxlan_dev_create+0x7c7/0xa50
>     [<ffffffff82ef6ce6>] vxlan_newlink+0xd6/0x130
>     [<ffffffff836d02ab>] __rtnl_newlink+0x112b/0x18a0
>     [<ffffffff836d0a8c>] rtnl_newlink+0x6c/0xa0
>     [<ffffffff836c0ddf>] rtnetlink_rcv_msg+0x43f/0xd40
>     [<ffffffff83908ce0>] netlink_rcv_skb+0x170/0x440
>     [<ffffffff839066af>] netlink_unicast+0x53f/0x810
>     [<ffffffff839072d8>] netlink_sendmsg+0x958/0xe70
>     [<ffffffff835c319f>] ____sys_sendmsg+0x78f/0xa90
>     [<ffffffff835cd6da>] ___sys_sendmsg+0x13a/0x1e0
>     [<ffffffff835cd94c>] __sys_sendmsg+0x11c/0x1f0
>     [<ffffffff8424da78>] do_syscall_64+0x38/0x80
> unreferenced object 0xffff88810e76d5f8 (size 192):
>   comm "ip", pid 330, jiffies 4295010045 (age 66.016s)
>   hex dump (first 32 bytes):
>     04 00 00 00 00 00 00 00 db e1 4f e7 00 00 00 00  ..........O.....
>     08 d6 76 0e 81 88 ff ff 08 d6 76 0e 81 88 ff ff  ..v.......v.....
>   backtrace:
>     [<ffffffff81a3162e>] __kmalloc_node+0x4e/0x90
>     [<ffffffff81a0e166>] kvmalloc_node+0xa6/0x1f0
>     [<ffffffff8276e1a3>] bucket_table_alloc.isra.0+0x83/0x460
>     [<ffffffff8276f18b>] rhashtable_init+0x43b/0x7c0
>     [<ffffffff82f04a1c>] vxlan_vnigroup_init+0x6c/0x160
>     [<ffffffff82ecd69e>] vxlan_init+0x1ae/0x280
>     [<ffffffff836858ca>] register_netdevice+0x57a/0x16d0
>     [<ffffffff82ef67b7>] __vxlan_dev_create+0x7c7/0xa50
>     [<ffffffff82ef6ce6>] vxlan_newlink+0xd6/0x130
>     [<ffffffff836d02ab>] __rtnl_newlink+0x112b/0x18a0
>     [<ffffffff836d0a8c>] rtnl_newlink+0x6c/0xa0
>     [<ffffffff836c0ddf>] rtnetlink_rcv_msg+0x43f/0xd40
>     [<ffffffff83908ce0>] netlink_rcv_skb+0x170/0x440
>     [<ffffffff839066af>] netlink_unicast+0x53f/0x810
>     [<ffffffff839072d8>] netlink_sendmsg+0x958/0xe70
>     [<ffffffff835c319f>] ____sys_sendmsg+0x78f/0xa90
> 
> Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan/vxlan_core.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index 92224b36787a..b1b179effe2a 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -2917,16 +2917,23 @@ static int vxlan_init(struct net_device *dev)
>  		vxlan_vnigroup_init(vxlan);
>  
>  	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
> -	if (!dev->tstats)
> -		return -ENOMEM;
> +	if (!dev->tstats) {
> +		err = -ENOMEM;
> +		goto err_vnigroup_uninit;
> +	}
>  
>  	err = gro_cells_init(&vxlan->gro_cells, dev);
> -	if (err) {
> -		free_percpu(dev->tstats);
> -		return err;
> -	}
> +	if (err)
> +		goto err_free_percpu;
>  
>  	return 0;
> +
> +err_free_percpu:
> +	free_percpu(dev->tstats);
> +err_vnigroup_uninit:
> +	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
> +		vxlan_vnigroup_uninit(vxlan);
> +	return err;
>  }
>  
>  static void vxlan_fdb_delete_default(struct vxlan_dev *vxlan, __be32 vni)

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
