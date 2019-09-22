Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1755ABA01A
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 03:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfIVBGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 21:06:17 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42758 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfIVBGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 21:06:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id q12so6871741pff.9
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 18:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=RK9fvAABFqmYbCjM31CT9Mzch9oS1DtW+7B02lwGjwQ=;
        b=g9xU1VBg1mkkJEaBeY1IcuLhyR7kq5LaN/qUmwoBZ5w3GxRFdetKdwUCMvG7KdZBmB
         Mo9TfgSB7NYgAcRjcrveFfTPIKjd+GNOuHxdLcjGfQxz3vjT9JXnT4kax1FBBUfdXRP3
         KSj7qFrJs2zw0PEdKku/OAECeYgKMFycrIjxssow4+HZVdtZ1PRJO1XjBy4spX5/6U4p
         WsfhGgi7dcpD71/jOFioG6r7J1huTam+Tr0gBH1/xpMZo9DF65BYshv3GM5q4i7LR0yS
         nWdrcShVHp2RJr/7qEP5mk6Y2C/GjzgumE0chDnvRZOAwH7a373hLv6LFJ1KvTB9fQl/
         wWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RK9fvAABFqmYbCjM31CT9Mzch9oS1DtW+7B02lwGjwQ=;
        b=jEp3+dPxcJPKZJ+xKr7sj7xyruaUZ8YcGTOlFy4Z/UIfaPzkzN8qLTUyXPJ3RS5D4H
         KLqGvb6vWyKshKxMQaH8mijN86zd9l6d7ecQHLx5X25n0Rh4+VZQFTFBfyq7SbNVzi+E
         ZTfJ2oDHOaO3ElD44X2IVHkoJaID9WPVEugmg3RPWyAqjKVwdl+pvmd82Or4KZoLLCOg
         jzSlnL3VanfNBklW0/tA3Y7rD7jAJqUOB9PVvKVsbBV574878iW5eygBqRYZ3HJtxvjF
         5wj2QnLTFHU+uVOiCC7UlV8D46mpupAzl27zqd0JllZciyswWOs+1Kw8mRD6Ob6INB+c
         Nc5g==
X-Gm-Message-State: APjAAAX9ZgEkTQgT0MyXhvzUsBBei0ZLoH27GEQzZFVS0TwTqjkO/r1q
        RPBzdlBNCrnQFCuz17AuFq8yhw==
X-Google-Smtp-Source: APXvYqz6dM1oWoKFWxd4Cb/mPL2DCgcfyJzhr+ycZrVn6pp5W49xe3foPAPxNvQl4R7qUJLUFbcOPA==
X-Received: by 2002:a62:788b:: with SMTP id t133mr25951309pfc.218.1569114375987;
        Sat, 21 Sep 2019 18:06:15 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id g5sm7208570pgd.82.2019.09.21.18.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 18:06:15 -0700 (PDT)
Date:   Sat, 21 Sep 2019 18:06:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     xiangxia.m.yue@gmail.com
Cc:     gvrose8192@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org,
        Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH net] net: openvswitch: fix possible memleak on create
 vport fails
Message-ID: <20190921180612.6fa6b7fd@cakuba.netronome.com>
In-Reply-To: <1568734808-42628-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1568734808-42628-1-git-send-email-xiangxia.m.yue@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 23:40:08 +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> If we register a net device which name is not valid
> (dev_get_valid_name), register_netdevice will return err
> codes and will not run dev->priv_destructor. The memory
> will leak. This patch adds check in ovs_vport_free and
> set the vport NULL.
> 
> Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_netdevice() is failed.")
> Cc: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Thanks for the patch, I see what you're trying to do, but..

> diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
> index d2437b5..074c43f 100644
> --- a/net/openvswitch/vport-internal_dev.c
> +++ b/net/openvswitch/vport-internal_dev.c
> @@ -159,7 +159,6 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>  	struct internal_dev *internal_dev;
>  	struct net_device *dev;
>  	int err;
> -	bool free_vport = true;
>  
>  	vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
>  	if (IS_ERR(vport)) {
> @@ -190,10 +189,8 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>  
>  	rtnl_lock();
>  	err = register_netdevice(vport->dev);
> -	if (err) {
> -		free_vport = false;
> +	if (err)
>  		goto error_unlock;
> -	}
>  
>  	dev_set_promiscuity(vport->dev, 1);
>  	rtnl_unlock();
> @@ -207,8 +204,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>  error_free_netdev:
>  	free_netdev(dev);
>  error_free_vport:
> -	if (free_vport)
> -		ovs_vport_free(vport);
> +	ovs_vport_free(vport);
>  error:
>  	return ERR_PTR(err);
>  }
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 3fc38d1..281259a 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -157,11 +157,20 @@ struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
>   */
>  void ovs_vport_free(struct vport *vport)
>  {
> +	/* We should check whether vport is NULL.
> +	 * We may free it again, for example in internal_dev_create
> +	 * if register_netdevice fails, vport may have been freed via
> +	 * internal_dev_destructor.
> +	 */
> +	if (unlikely(!vport))
> +		return;
> +
>  	/* vport is freed from RCU callback or error path, Therefore
>  	 * it is safe to use raw dereference.
>  	 */
>  	kfree(rcu_dereference_raw(vport->upcall_portids));
>  	kfree(vport);
> +	vport = NULL;

vport here is a function argument, seems like setting it to NULL 
right before the function ends will do nothing. Should we rather 
set internal_dev->vport to NULL somehow? 

Perhaps someone more familiar with OvS can chime in and review..

>  }
>  EXPORT_SYMBOL_GPL(ovs_vport_free);
>  
