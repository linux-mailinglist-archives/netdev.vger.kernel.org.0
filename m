Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3AE8C417
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfHMWIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:08:42 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35703 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfHMWIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:08:41 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so81065302qke.2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 15:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ye3DSmVtPuckPW+5hpulG7uaWni5fU74caNSdGIe0X0=;
        b=vKdDZoDaFJpDOC3IS0FHcnN2Ge3qbxgxFhTuyyQ2uwpt32nafc2cOWg2KqGVqzeqJG
         +tawhrPh1g/zbTl+glNdJb9hrLq5obU3YPnoaFMYh3w+ruu2gfGgTW0prxSBPR6w6P9e
         zpVEy/0P9wrtxvUPttFQzox6dXjtvdOTUhMchEKEac8HkBzgi0qirkyB3VQrC2tt50m0
         Q0X1jt7QNeGvIeiSnqZRt8RbhD4/K09vueCr4qfX6lSFehKAI8d/tgu0ptD1yNQJwYRz
         UIYzAMlCVNhfHfLDQRgNJRWwBhu8P8XtHWcf7R9eRycK+daOSg0vu9uk97WuUGw6cLJD
         9t6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ye3DSmVtPuckPW+5hpulG7uaWni5fU74caNSdGIe0X0=;
        b=gRH8bWw9gFSyznf+t7VdwyAdisrKdtKKYWh1XiwJRBREtx7+l2NUG2lLUa8ES5IERE
         fWr8J2mV1InwOwdMElyEgo3zJUay71SASlbrgQkxtwyhcykQXIyUuT7NjAZhtaoJRsfX
         5z0lz/kbepFQEg3bdFUiEPpgfQ74el+4onJgaN719ON/nwdnE/uJiO7s/PAIM2Pe35Fh
         Z1N8Lwd7AUEPZtuzKcMxau/fSx7WLaF87cY0kmWcyhtbobZkjvjEsQESJsa5Oy5EXoXG
         MGjAX1rc32DakbvrAtHN6sQ91yHM4+LazHy2Y0+gmBEDpRrWhiwg6liFBTagvDondWFI
         PxVQ==
X-Gm-Message-State: APjAAAXDuslbnGquhUc+6AWNutwaqWAhgXftGmF6GPILT6cZokUiibvB
        G//Fv04FWJRBn2wOiLC/bRm1Bg==
X-Google-Smtp-Source: APXvYqwRbpjRq0oQBBPOMy90VtDxe+WiLKxgOswlR6Q6duF/JF5sDCdgOqy1RICBg5k3uo9zKT+ZyA==
X-Received: by 2002:a37:5d07:: with SMTP id r7mr34681505qkb.4.1565734121020;
        Tue, 13 Aug 2019 15:08:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m10sm46765654qka.43.2019.08.13.15.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 15:08:40 -0700 (PDT)
Date:   Tue, 13 Aug 2019 15:08:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/2] netdevsim: implement support for
 devlink region and snapshots
Message-ID: <20190813150829.1012188c@cakuba.netronome.com>
In-Reply-To: <20190813144843.28466-2-jiri@resnulli.us>
References: <20190813144843.28466-1-jiri@resnulli.us>
        <20190813144843.28466-2-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 16:48:42 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Implement dummy region of size 32K and allow user to create snapshots
> or random data using debugfs file trigger.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Hmm.. did you send the right version?

> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 127aef85dc99..8485dd805f7c 100644
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

not needed, without __GFP_NOWARN there will be a huge OOM splat, anyway.

> +		goto out;

		return -ENOMEM;

> +	}
> +
> +	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
> +
> +	id = devlink_region_shapshot_id_get(priv_to_devlink(nsim_dev));
> +	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
> +					     dummy_data, id, kfree);
> +	if (err)
> +		pr_err("Failed to create region snapshot\n");

		return err;
	}

> +
> +out:
> +	return count;
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

	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);

> +}
