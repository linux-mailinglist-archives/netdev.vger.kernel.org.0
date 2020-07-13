Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163BA21D699
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbgGMNSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbgGMNSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:18:34 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D24C061794
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 06:18:33 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e11so12086651qkm.3
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 06:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OinjwQHWtXinojYGvMx4rU5dNZcYHNAuKySun4EZBdo=;
        b=nF0uROir+OcoPFu9/bIzlhdCQnk8+wXgdBo+zpltdo9M88Bssd4B5plu8CJ5oGR+IL
         9QYifwCcvt7zRHrG4SdI/86EZiM3FhjM8b3081+g0PeYrhcBqbBu0d4fYxvzrzvHxzUG
         YvEe3lNjeGK2Fj+D77DDR3Zc9xSPSzuZ/f1dFk/SbFgEDbV6wqy5uN6jACTXXRaLxnDQ
         lT2v8QvwXlW9rrz9yimRIzQTMTqhVUibbl9Uu+JR/Qu1BgIsnOyKr6q1ymcaLlWbq9/C
         s5BzxV7ZHWU5S+FCTQZiU6zKgRCAMU2zuJLHPIOfAlPpQ906GCZt+Qe8imPTprTAlc22
         YspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OinjwQHWtXinojYGvMx4rU5dNZcYHNAuKySun4EZBdo=;
        b=jsZfqoMPAwFvRwrD/T9N3AZIEbD5HRxc+QAu3LxToB8H0hVvWViPnKHRVdVZxElv/5
         SG3T1oUFqD0goBlAydlUVdCSsrW0yttVx3BMzctMaU/8VGUp60DkeV9B4qQOXBlzUXJR
         JJs+WUTRmwiHDeeeoUosaKVpwTGx0FL8/qn/kn/Rjfp2FaKXfUFZFBG01adxqmS8kjvy
         BA7XykKo2ySCpZ7FKq4VP9y8NaymgpllIzivyI1wLJ739WzRvcExpAHA5QezoEI4Ybj8
         fAMCGv7hLMc/dETMzBT3h+3r63gh8ABfd3BRLM0F4aVZmzC8wSwfbF/lIqYA6Qtvqoac
         wBFA==
X-Gm-Message-State: AOAM531fWVOP588vewpOLn+Q/9RztmPJUEyzFSZV1r9Ly1nySp2YP3UY
        e9Cjmz608fKCC0pa8oZLMP75Mg==
X-Google-Smtp-Source: ABdhPJz4mWj04UJ9sAADhLTI7UiSxawOv6mtEbGLp+8OpMEqWHEf0ifeE9WpoCCtAj6rDTD20FIAnA==
X-Received: by 2002:a37:6642:: with SMTP id a63mr82726759qkc.5.1594646312656;
        Mon, 13 Jul 2020 06:18:32 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id g20sm20415119qtc.46.2020.07.13.06.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 06:18:31 -0700 (PDT)
Date:   Mon, 13 Jul 2020 09:18:25 -0400
From:   Qian Cai <cai@lca.pw>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: Re: [PATCH net-next v3 5/7] devlink: Add devlink health port
 reporters API
Message-ID: <20200713131824.GA4489@lca.pw>
References: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
 <1594383913-3295-6-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594383913-3295-6-git-send-email-moshe@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 03:25:11PM +0300, Moshe Shemesh wrote:
> From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> 
> In order to use new devlink port health reporters infrastructure, add
> corresponding constructor and destructor functions.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

This will trigger an use-after-free below while doing SR-IOV,

# echo 1 > /sys/class/net/enp11s0f1np1/device/sriov_numvfs
# git clone https://github.com/cailca/linux-mm
# cd linux-mm; make
#./random -x 0-100 -k0000:0b:01.2 (just use vfio-pci to passthrough via qemu-kvm.)

(arm64.config is also included in the repo.)

[ 1882.029101][ T4248] BUG: KASAN: use-after-free in devlink_port_health_reporter_destroy+0x150/0x198
devlink_port_health_reporter_destroy at net/core/devlink.c:5490
[ 1882.038060][ T4248] Read of size 8 at addr ffff0089b4115028 by task random/4248
[ 1882.045375][ T4248] CPU: 20 PID: 4248 Comm: random Not tainted 5.8.0-rc4-next-20200713 #1
[ 1882.053547][ T4248] Hardware name: HPE Apollo 70             /C01_APACHE_MB         , BIOS L50_5.13_1.11 06/18/2019
[ 1882.063977][ T4248] Call trace:
[ 1882.067119][ T4248]  dump_backtrace+0x0/0x398
[ 1882.071474][ T4248]  show_stack+0x14/0x20
[ 1882.075481][ T4248]  dump_stack+0x140/0x1c8
[ 1882.079663][ T4248]  print_address_description.constprop.10+0x54/0x550
[ 1882.086187][ T4248]  kasan_report+0x134/0x1b8
[ 1882.090541][ T4248]  __asan_report_load8_noabort+0x2c/0x50
[ 1882.096023][ T4248]  devlink_port_health_reporter_destroy+0x150/0x198
[ 1882.102521][ T4248]  mlx5e_reporter_rx_destroy+0x3c/0xc8 [mlx5_core]
[ 1882.108915][ T4248]  mlx5e_health_destroy_reporters+0x14/0x28 [mlx5_core]
[ 1882.115743][ T4248]  mlx5e_nic_cleanup+0x14/0x88 [mlx5_core]
[ 1882.121442][ T4248]  mlx5e_destroy_netdev+0x84/0xb8 [mlx5_core]
[ 1882.127401][ T4248]  mlx5e_remove+0x50/0x68 [mlx5_core]
[ 1882.132666][ T4248]  mlx5_remove_device+0x1f8/0x298 [mlx5_core]
[ 1882.138625][ T4248]  mlx5_unregister_device+0x5c/0x1b8 [mlx5_core]
[ 1882.144845][ T4248]  mlx5_unload_one+0x38/0x240 [mlx5_core]
[ 1882.150457][ T4248]  remove_one+0x58/0x98 [mlx5_core]
[ 1882.155510][ T4248]  pci_device_remove+0x8c/0x1e0
[ 1882.160213][ T4248]  device_release_driver_internal+0x1bc/0x3e0
[ 1882.166129][ T4248]  device_driver_detach+0x38/0x50
[ 1882.171003][ T4248]  unbind_store+0x174/0x1c8
[ 1882.175356][ T4248]  drv_attr_store+0x60/0xa0
[ 1882.179710][ T4248]  sysfs_kf_write+0xdc/0x128
[ 1882.184151][ T4248]  kernfs_fop_write+0x23c/0x448
[ 1882.188852][ T4248]  vfs_write+0x160/0x4a0
[ 1882.192944][ T4248]  ksys_write+0xe8/0x1b8
[ 1882.197037][ T4248]  __arm64_sys_write+0x68/0x98
[ 1882.201652][ T4248]  do_el0_svc+0x124/0x220
[ 1882.205833][ T4248]  el0_sync_handler+0x260/0x410
[ 1882.210533][ T4248]  el0_sync+0x140/0x180
[ 1882.214545][ T4248] Allocated by task 1341:
[ 1882.218726][ T4248]  kasan_save_stack+0x24/0x50
[ 1882.223253][ T4248]  __kasan_kmalloc.isra.10+0xc4/0xe0
[ 1882.228387][ T4248]  kasan_kmalloc+0xc/0x18
[ 1882.232567][ T4248]  kmem_cache_alloc_trace+0x1ec/0x318
[ 1882.237789][ T4248]  __devlink_health_reporter_create+0x78/0x290
[ 1882.243791][ T4248]  devlink_port_health_reporter_create+0xb8/0x1d8
[ 1882.250098][ T4248]  mlx5e_reporter_rx_create+0x34/0xb8 [mlx5_core]
[ 1882.256404][ T4248]  mlx5e_health_create_reporters+0x1c/0x28 [mlx5_core]
[ 1882.263144][ T4248]  mlx5e_nic_init+0x898/0xe18 [mlx5_core]
[ 1882.268756][ T4248]  mlx5e_create_netdev+0xb4/0x200 [mlx5_core]
[ 1882.274714][ T4248]  mlx5e_add+0x180/0x530 [mlx5_core]
[ 1882.279892][ T4248]  mlx5_add_device+0xb8/0x2d0 [mlx5_core]
[ 1882.285504][ T4248]  mlx5_register_device+0xe4/0x150 [mlx5_core]
[ 1882.291549][ T4248]  mlx5_load_one+0x3b4/0x10d8 [mlx5_core]
[ 1882.297162][ T4248]  init_one+0x6c4/0xca0 [mlx5_core]
[ 1882.302212][ T4248]  local_pci_probe+0xc0/0x168
[ 1882.306741][ T4248]  work_for_cpu_fn+0x4c/0x90
[ 1882.311182][ T4248]  process_one_work+0x7f0/0x1b28
[ 1882.315969][ T4248]  worker_thread+0x32c/0xac8
[ 1882.320410][ T4248]  kthread+0x398/0x440
[ 1882.324329][ T4248]  ret_from_fork+0x10/0x18
[ 1882.328600][ T4248] Freed by task 4248:
[ 1882.332433][ T4248]  kasan_save_stack+0x24/0x50
[ 1882.336959][ T4248]  kasan_set_track+0x24/0x38
[ 1882.341400][ T4248]  kasan_set_free_info+0x20/0x40
[ 1882.346187][ T4248]  __kasan_slab_free+0x118/0x188
[ 1882.350974][ T4248]  kasan_slab_free+0x10/0x18
[ 1882.355416][ T4248]  slab_free_freelist_hook+0x110/0x298
[ 1882.360723][ T4248]  kfree+0x128/0x568
[ 1882.364469][ T4248]  devlink_health_reporter_put+0x74/0xc8
[ 1882.369950][ T4248]  devlink_port_health_reporter_destroy+0x10c/0x198
[ 1882.376430][ T4248]  mlx5e_reporter_rx_destroy+0x3c/0xc8 [mlx5_core]
[ 1882.382823][ T4248]  mlx5e_health_destroy_reporters+0x14/0x28 [mlx5_core]
[ 1882.389650][ T4248]  mlx5e_nic_cleanup+0x14/0x88 [mlx5_core]
[ 1882.395348][ T4248]  mlx5e_destroy_netdev+0x84/0xb8 [mlx5_core]
[ 1882.401307][ T4248]  mlx5e_remove+0x50/0x68 [mlx5_core]
[ 1882.406572][ T4248]  mlx5_remove_device+0x1f8/0x298 [mlx5_core]
[ 1882.412530][ T4248]  mlx5_unregister_device+0x5c/0x1b8 [mlx5_core]
[ 1882.418749][ T4248]  mlx5_unload_one+0x38/0x240 [mlx5_core]
[ 1882.424360][ T4248]  remove_one+0x58/0x98 [mlx5_core]
[ 1882.429411][ T4248]  pci_device_remove+0x8c/0x1e0
[ 1882.434112][ T4248]  device_release_driver_internal+0x1bc/0x3e0
[ 1882.440027][ T4248]  device_driver_detach+0x38/0x50
[ 1882.444901][ T4248]  unbind_store+0x174/0x1c8
[ 1882.449253][ T4248]  drv_attr_store+0x60/0xa0
[ 1882.453607][ T4248]  sysfs_kf_write+0xdc/0x128
[ 1882.458047][ T4248]  kernfs_fop_write+0x23c/0x448
[ 1882.462747][ T4248]  vfs_write+0x160/0x4a0
[ 1882.466839][ T4248]  ksys_write+0xe8/0x1b8
[ 1882.470931][ T4248]  __arm64_sys_write+0x68/0x98
[ 1882.475546][ T4248]  do_el0_svc+0x124/0x220
[ 1882.479726][ T4248]  el0_sync_handler+0x260/0x410
[ 1882.484425][ T4248]  el0_sync+0x140/0x180
[ 1882.488436][ T4248] The buggy address belongs to the object at ffff0089b4115000
[ 1882.488436][ T4248]  which belongs to the cache kmalloc-512 of size 512
[ 1882.502339][ T4248] The buggy address is located 40 bytes inside of
[ 1882.502339][ T4248]  512-byte region [ffff0089b4115000, ffff0089b4115200)
[ 1882.515371][ T4248] The buggy address belongs to the page:
[ 1882.520855][ T4248] page:000000009f41bfb0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8a3411
[ 1882.530940][ T4248] flags: 0x7ffff800000200(slab)
[ 1882.535645][ T4248] raw: 007ffff800000200 ffffffe0225514c8 ffffffe022552788 ffff000000320680
[ 1882.544079][ T4248] raw: 0000000000000000 00000000002a002a 00000001ffffffff ffff0089b411e601
[ 1882.552511][ T4248] page dumped because: kasan: bad access detected
[ 1882.558772][ T4248] page->mem_cgroup:ffff0089b411e601
[ 1882.563823][ T4248] Memory state around the buggy address:
[ 1882.569305][ T4248]  ffff0089b4114f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[ 1882.577217][ T4248]  ffff0089b4114f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[ 1882.585128][ T4248] >ffff0089b4115000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1882.593039][ T4248]                                   ^
[ 1882.598260][ T4248]  ffff0089b4115080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1882.606172][ T4248]  f================int
[ 1888.192093][ T6454] vfio-pci 0000:0b:01.2: enabling device (0000 -> 0002)

> ---
>  include/net/devlink.h |  9 +++++++++
>  net/core/devlink.c    | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index bb11397..913e867 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1338,9 +1338,18 @@ struct devlink_health_reporter *
>  devlink_health_reporter_create(struct devlink *devlink,
>  			       const struct devlink_health_reporter_ops *ops,
>  			       u64 graceful_period, void *priv);
> +
> +struct devlink_health_reporter *
> +devlink_port_health_reporter_create(struct devlink_port *port,
> +				    const struct devlink_health_reporter_ops *ops,
> +				    u64 graceful_period, void *priv);
> +
>  void
>  devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
>  
> +void
> +devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
> +
>  void *
>  devlink_health_reporter_priv(struct devlink_health_reporter *reporter);
>  int devlink_health_report(struct devlink_health_reporter *reporter,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index b4a231c..20a83aa 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -5372,6 +5372,42 @@ struct devlink_health_reporter {
>  }
>  
>  /**
> + *	devlink_port_health_reporter_create - create devlink health reporter for
> + *	                                      specified port instance
> + *
> + *	@port: devlink_port which should contain the new reporter
> + *	@ops: ops
> + *	@graceful_period: to avoid recovery loops, in msecs
> + *	@priv: priv
> + */
> +struct devlink_health_reporter *
> +devlink_port_health_reporter_create(struct devlink_port *port,
> +				    const struct devlink_health_reporter_ops *ops,
> +				    u64 graceful_period, void *priv)
> +{
> +	struct devlink_health_reporter *reporter;
> +
> +	mutex_lock(&port->reporters_lock);
> +	if (__devlink_health_reporter_find_by_name(&port->reporter_list,
> +						   &port->reporters_lock, ops->name)) {
> +		reporter = ERR_PTR(-EEXIST);
> +		goto unlock;
> +	}
> +
> +	reporter = __devlink_health_reporter_create(port->devlink, ops,
> +						    graceful_period, priv);
> +	if (IS_ERR(reporter))
> +		goto unlock;
> +
> +	reporter->devlink_port = port;
> +	list_add_tail(&reporter->list, &port->reporter_list);
> +unlock:
> +	mutex_unlock(&port->reporters_lock);
> +	return reporter;
> +}
> +EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
> +
> +/**
>   *	devlink_health_reporter_create - create devlink health reporter
>   *
>   *	@devlink: devlink
> @@ -5441,6 +5477,20 @@ struct devlink_health_reporter *
>  }
>  EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
>  
> +/**
> + *	devlink_port_health_reporter_destroy - destroy devlink port health reporter
> + *
> + *	@reporter: devlink health reporter to destroy
> + */
> +void
> +devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
> +{
> +	mutex_lock(&reporter->devlink_port->reporters_lock);
> +	__devlink_health_reporter_destroy(reporter);
> +	mutex_unlock(&reporter->devlink_port->reporters_lock);
> +}
> +EXPORT_SYMBOL_GPL(devlink_port_health_reporter_destroy);
> +
>  static int
>  devlink_nl_health_reporter_fill(struct sk_buff *msg,
>  				struct devlink *devlink,
> -- 
> 1.8.3.1
> 
