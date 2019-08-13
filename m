Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F06E8AC53
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfHMA7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:59:09 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42565 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHMA7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 20:59:09 -0400
Received: by mail-qk1-f193.google.com with SMTP id 201so78383805qkm.9
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mPJTqoEi9dDohjSAdm3blaPA5kqbV2uHthJQ9kvFTKA=;
        b=KfXfVTszmXleTMDObTyKfBSZehNSvdLzAGqdghoZBxMHvUezcdFjfTRBXbccTuNznu
         sFQa1JlNMOFOxreRfZjrAN4j7DtZoHPHr/a+QUs5pv9IMRGTcTaewkC04soCKziAL9Jx
         A6pdSqpsH7ZpiKcdSfbttqI6UvO7tkQE1WN30t3tFuS82Fj7FpYBfN3u4/+d1qxeVego
         kWw8i771w4uv4Sc/m7uzMckCOxqKTdInoXje4hG090raegvOWafRKyOarnL7vyRTaWVV
         B30ORBPzmuHp5cTaGvDZ+8VPTpGLCQfYsBbsVREmH7Tf1NgmFLw1YPdw5w6HjrzHBwy5
         FmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mPJTqoEi9dDohjSAdm3blaPA5kqbV2uHthJQ9kvFTKA=;
        b=WTtRDIHEWAc3Rw1i6RR2jBfCF+cEQHIeXJE68dRyMgJetxUsT+s5C6RK3ZPQbdLAsi
         dg1r5qR8ES2L7Mdb587BF1eB+tmGj5BlnHYl6qndIWdinV/Yz9z8sDdr3S/kSLdLVsj5
         PvEsKvPuF4TKdGf5YYIH1kNFZwWjSnkwSFsYIQt1aaDUqK72PEsRaZ2z3DFAcrzV5Y5H
         yRYsssFAiTC+D36fuxgmNt0Cw1nzbiam8W4PWICp4NNB44nzefpOAo4BSPVZQ85mwmTC
         rBNPIk7cqwCZR+lgXjogqCJ/SyWdhx7MT3KGTwZiXYPGQxsxk2wy4O5VtoId/IcjN43f
         L+ww==
X-Gm-Message-State: APjAAAXFT/yKHD6BccFV9pWe/jVGxF/K6m8gudKWeWuS48FV8LNnskYN
        YCBqDacom5sp+ZYhW1EY2eD4YA==
X-Google-Smtp-Source: APXvYqwOUyAd4FgJcqqnCf1mQRoJWj+ab42tccCASPioTUzgjF8TazrIUW8PGY8vkeCerMRAENsQrA==
X-Received: by 2002:a37:4e4b:: with SMTP id c72mr31378011qkb.91.1565657948313;
        Mon, 12 Aug 2019 17:59:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a2sm7298235qkd.76.2019.08.12.17.59.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 17:59:08 -0700 (PDT)
Date:   Mon, 12 Aug 2019 17:58:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] netdevsim: implement support for devlink
 region and snapshots
Message-ID: <20190812175859.3e0275e3@cakuba.netronome.com>
In-Reply-To: <20190812101620.7884-1-jiri@resnulli.us>
References: <20190812101620.7884-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 12:16:20 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Implement dummy region of size 32K and allow user to create snapshots
> or random data using debugfs file trigger.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

I'm nacking all the netdevsim patches unless the selftest 
is posted at the same time :/

You're leaking those features one by one what if you get distracted 
and the tests never materialize :/

This is all dead code.

> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 08ca59fc189b..e76ea6a3cb60 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -27,6 +27,41 @@
>  
>  static struct dentry *nsim_dev_ddir;
>  
> +#define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
> +
> +static ssize_t nsim_dev_take_snapshot_write(struct file *file,
> +					    const char __user *data,
> +					    size_t count, loff_t *ppos)
> +{
> +	struct nsim_dev *nsim_dev = file->private_data;
> +	void *dummy_data;
> +	u32 id;
> +	int err;
> +
> +	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
> +	if (!dummy_data) {
> +		pr_err("Failed to allocate memory for region snapshot\n");
> +		goto out;
> +	}
> +
> +	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
> +
> +	id = devlink_region_shapshot_id_get(priv_to_devlink(nsim_dev));
> +	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
> +					     dummy_data, id, kfree);
> +	if (err)
> +		pr_err("Failed to create region snapshot\n");
> +
> +out:
> +	return count;

why not return an error?

> +}
> +
> +static const struct file_operations nsim_dev_take_snapshot_fops = {
> +	.open = simple_open,
> +	.write = nsim_dev_take_snapshot_write,
> +	.llseek = generic_file_llseek,
> +};
> +
>  static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
>  {
>  	char dev_ddir_name[16];
> @@ -44,6 +79,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
>  			   &nsim_dev->max_macs);
>  	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
>  			    &nsim_dev->test1);
> +	debugfs_create_file("take_snapshot", 0200, nsim_dev->ddir, nsim_dev,
> +			    &nsim_dev_take_snapshot_fops);
>  	return 0;
>  }
>  
> @@ -248,6 +285,26 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
>  		nsim_dev->test1 = saved_value.vbool;
>  }
>  
> +#define NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX 16
> +
> +static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
> +				      struct devlink *devlink)
> +{
> +	nsim_dev->dummy_region =
> +		devlink_region_create(devlink, "dummy",
> +				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
> +				      NSIM_DEV_DUMMY_REGION_SIZE);
> +	if (IS_ERR(nsim_dev->dummy_region))
> +		return PTR_ERR(nsim_dev->dummy_region);
> +
> +	return 0;

PTR_ERR_OR_ZERO()

> +}
> +
> +static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
> +{
> +	devlink_region_destroy(nsim_dev->dummy_region);
> +}
> +
>  static int nsim_dev_reload(struct devlink *devlink,
>  			   struct netlink_ext_ack *extack)
>  {

