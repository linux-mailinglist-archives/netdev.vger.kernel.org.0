Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490FDB9AE1
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404978AbfITXsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 19:48:24 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42858 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388569AbfITXsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 19:48:24 -0400
Received: by mail-qk1-f195.google.com with SMTP id f16so9043692qkl.9
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 16:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=alvzEj4s+aL0DXNaap0VLRizAOjDsZM5K3ZpyX8RN8A=;
        b=ktuYLu6713HTXqcuPeepF3szIRvHyEWrkX3fYSLpR+ziEDqPGoPcB4mVd/dK9+jrUO
         vzvlAUP3MX59CZFdMWCNyaLzeixwNXf2H+DIlBih+5s3B0V1hsXJ00wvpJe/JyWThk79
         W4FQAav87dj2Aakrzot9H3jtIWhjjNXnAYTGv+b6rergMw9pLcCU4QNirtjkBcxfBP/q
         m7As/aerc5BTmfcut+b/j9frF58mnEcuefW5XbnCZD1t+O0QyWFWWECdR4OXieobVfu/
         n4ZB4K+5HgZfDhAkyO0Pc4f6/urxcId/D8VfGd997kzPz0Q8WMdX3JE01bhnfQ3Vbch+
         lrPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=alvzEj4s+aL0DXNaap0VLRizAOjDsZM5K3ZpyX8RN8A=;
        b=U+emVM3AtenaRwcgLYrmc70zCg/+hkH5F8eHsiNyxzN/GJzCD6WqYwabRVPRKEv0yw
         j3rY1FoU2C3QC8x+Tn66KZNxhqWOGIcoH7qnFWOj0MzOTIESU37mDd+jlHUkBsoe3hU9
         z2NEnJ2hUf//yolJNM5bHwniQTmDd9BGqkKmqvcuz2N12UiIVCyCD+9snQPl3z5mxhRv
         GRGECcqIykVEDI0NtS+xOh+9L8hUbVDoQP2ZggjkJxl+W/HlsFabbGgCqqJmLje+qL/s
         n2Eh77KxCs595jVgWX8JqqXbL1aQp3WO0HYdtbXpb9qI0MEhMxbxJZCLp8XaJSs6zHW9
         zuoA==
X-Gm-Message-State: APjAAAWvUhTD5SOKHpFBwJmgDn+pBCe2id+ysjTDONCrNmHBO6mGH9yW
        e/LkiNyNtD02e2fTw8qF660+/w==
X-Google-Smtp-Source: APXvYqyIEmVlvwWLdRpD45qAlrsOca6Dyof9gOiE8px4S6ihcRLhyMkt3Eh1JAilit2DGaeTXqa5DA==
X-Received: by 2002:a37:95c6:: with SMTP id x189mr6392775qkd.323.1569023302980;
        Fri, 20 Sep 2019 16:48:22 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2448295qtb.2.2019.09.20.16.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 16:48:22 -0700 (PDT)
Date:   Fri, 20 Sep 2019 16:48:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Subject: Re: [PATCH net v3 10/11] vxlan: add adjacent link to limit depth
 level
Message-ID: <20190920164816.55a77053@cakuba.netronome.com>
In-Reply-To: <20190916134802.8252-11-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
        <20190916134802.8252-11-ap420073@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Sep 2019 22:48:01 +0900, Taehee Yoo wrote:
> Current vxlan code doesn't limit the number of nested devices.
> Nested devices would be handled recursively and this routine needs
> huge stack memory. So, unlimited nested devices could make
> stack overflow.
> 
> In order to fix this issue, this patch adds adjacent links.
> The adjacent link APIs internally check the depth level.

> Fixes: acaf4e70997f ("net: vxlan: when lower dev unregisters remove vxlan dev as well")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Minor nit picks here, I hope you don't mind.

> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 3d9bcc957f7d..0d5c8d22d8a4 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -3567,6 +3567,8 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
>  	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
>  	struct vxlan_dev *vxlan = netdev_priv(dev);
>  	struct vxlan_fdb *f = NULL;
> +	struct net_device *remote_dev = NULL;
> +	struct vxlan_rdst *dst = &vxlan->default_dst;

Especially in places where reverse christmas tree variable ordering is
adhered to, could you please preserve it? That'd mean:

	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
	struct vxlan_dev *vxlan = netdev_priv(dev);
	struct net_device *remote_dev = NULL;
	struct vxlan_fdb *f = NULL;
	bool unregister = false;
	struct vxlan_rdst *dst;
	int err;

	dst = &vxlan->default_dst;

here.

>  	bool unregister = false;
>  	int err;
>  
> @@ -3577,14 +3579,14 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
>  	dev->ethtool_ops = &vxlan_ethtool_ops;
>  
>  	/* create an fdb entry for a valid default destination */
> -	if (!vxlan_addr_any(&vxlan->default_dst.remote_ip)) {
> +	if (!vxlan_addr_any(&dst->remote_ip)) {
>  		err = vxlan_fdb_create(vxlan, all_zeros_mac,
> -				       &vxlan->default_dst.remote_ip,
> +				       &dst->remote_ip,
>  				       NUD_REACHABLE | NUD_PERMANENT,
>  				       vxlan->cfg.dst_port,
> -				       vxlan->default_dst.remote_vni,
> -				       vxlan->default_dst.remote_vni,
> -				       vxlan->default_dst.remote_ifindex,
> +				       dst->remote_vni,
> +				       dst->remote_vni,
> +				       dst->remote_ifindex,
>  				       NTF_SELF, &f);
>  		if (err)
>  			return err;
> @@ -3595,26 +3597,43 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
>  		goto errout;
>  	unregister = true;
>  
> +	if (dst->remote_ifindex) {
> +		remote_dev = __dev_get_by_index(net, dst->remote_ifindex);
> +		if (!remote_dev)
> +			goto errout;
> +
> +		err = netdev_upper_dev_link(remote_dev, dev, extack);
> +		if (err)
> +			goto errout;
> +	}
> +
>  	err = rtnl_configure_link(dev, NULL);
>  	if (err)
> -		goto errout;
> +		goto unlink;
>  
>  	if (f) {
> -		vxlan_fdb_insert(vxlan, all_zeros_mac,
> -				 vxlan->default_dst.remote_vni, f);
> +		vxlan_fdb_insert(vxlan, all_zeros_mac, dst->remote_vni, f);
>  
>  		/* notify default fdb entry */
>  		err = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f),
>  				       RTM_NEWNEIGH, true, extack);
>  		if (err) {
>  			vxlan_fdb_destroy(vxlan, f, false, false);
> +			if (remote_dev)
> +				netdev_upper_dev_unlink(remote_dev, dev);
>  			goto unregister;
>  		}
>  	}
>  
>  	list_add(&vxlan->next, &vn->vxlan_list);
> +	if (remote_dev) {
> +		dst->remote_dev = remote_dev;
> +		dev_hold(remote_dev);
> +	}
>  	return 0;
> -
> +unlink:
> +	if (remote_dev)
> +		netdev_upper_dev_unlink(remote_dev, dev);
>  errout:
>  	/* unregister_netdevice() destroys the default FDB entry with deletion
>  	 * notification. But the addition notification was not sent yet, so
> @@ -3936,6 +3955,8 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
>  	struct net_device *lowerdev;
>  	struct vxlan_config conf;
>  	int err;
> +	bool linked = false;
> +	bool disabled = false;

Same here.

>  	err = vxlan_nl2conf(tb, data, dev, &conf, true, extack);
>  	if (err)
> @@ -3946,6 +3967,16 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
>  	if (err)
>  		return err;
>  
> +	if (lowerdev) {
> +		if (dst->remote_dev && lowerdev != dst->remote_dev) {
> +			netdev_adjacent_dev_disable(dst->remote_dev, dev);
> +			disabled = true;
> +		}
> +		err = netdev_upper_dev_link(lowerdev, dev, extack);
> +		if (err)
> +			goto err;

would you mind naming the label errout? there is an err variable, and
other places in this file use errout

> +		linked = true;
> +	}
>  	/* handle default dst entry */
>  	if (!vxlan_addr_equal(&conf.remote_ip, &dst->remote_ip)) {
>  		u32 hash_index = fdb_head_index(vxlan, all_zeros_mac, conf.vni);
> @@ -3962,7 +3993,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
>  					       NTF_SELF, true, extack);
>  			if (err) {
>  				spin_unlock_bh(&vxlan->hash_lock[hash_index]);
> -				return err;
> +				goto err;
>  			}
>  		}
>  		if (!vxlan_addr_any(&dst->remote_ip))
> @@ -3979,8 +4010,24 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
>  	if (conf.age_interval != vxlan->cfg.age_interval)
>  		mod_timer(&vxlan->age_timer, jiffies);
>  
> +	if (disabled) {
> +		netdev_adjacent_dev_enable(dst->remote_dev, dev);
> +		netdev_upper_dev_unlink(dst->remote_dev, dev);
> +		dev_put(dst->remote_dev);
> +	}
> +	if (linked) {
> +		dst->remote_dev = lowerdev;
> +		dev_hold(dst->remote_dev);
> +	}
> +
>  	vxlan_config_apply(dev, &conf, lowerdev, vxlan->net, true);
>  	return 0;
> +err:
> +	if (linked)
> +		netdev_upper_dev_unlink(lowerdev, dev);
> +	if (disabled)
> +		netdev_adjacent_dev_enable(dst->remote_dev, dev);
> +	return err;
>  }
>  
>  static void vxlan_dellink(struct net_device *dev, struct list_head *head)
> @@ -3991,6 +4038,10 @@ static void vxlan_dellink(struct net_device *dev, struct list_head *head)
>  
>  	list_del(&vxlan->next);
>  	unregister_netdevice_queue(dev, head);
> +	if (vxlan->default_dst.remote_dev) {
> +		netdev_upper_dev_unlink(vxlan->default_dst.remote_dev, dev);
> +		dev_put(vxlan->default_dst.remote_dev);
> +	}
>  }
>  
>  static size_t vxlan_get_size(const struct net_device *dev)
> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> index dc1583a1fb8a..08e237d7aa73 100644
> --- a/include/net/vxlan.h
> +++ b/include/net/vxlan.h
> @@ -197,6 +197,7 @@ struct vxlan_rdst {
>  	u8			 offloaded:1;
>  	__be32			 remote_vni;
>  	u32			 remote_ifindex;
> +	struct net_device	 *remote_dev;
>  	struct list_head	 list;
>  	struct rcu_head		 rcu;
>  	struct dst_cache	 dst_cache;

