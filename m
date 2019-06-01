Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327CD320A4
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 22:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFAUC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 16:02:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34056 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFAUC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 16:02:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id c14so5835414pfi.1
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 13:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xy8MS2h0CWCw9bCHyV9wMr6WM+l0cnsYOJ5ENcwhPQU=;
        b=KIgHCCMmCRxtATSwhQzp7Xt6whGBcSGWws0Ev9SBl6KxYrEkYH6pWjGD+H/rWa4n2Z
         oxmp3pPPUKo+SoXRn4LiuYzF4GSoaikRH122gljJcnN8CB4XgBF1JD9YjOVcKDUuX8tA
         sXXBbJyQES7trxmV3hqo3a/k2l0NlH1qHKL2KuVgnw5scQAl+NI/EqGjt5ISp0zRFRKR
         dXSUzL7xkPz6yBoWTcGhToZkaBPPfik5hiKcQYrfixMb7qF2LXFYmSBgSSQpdQNM1DLq
         X3k2/O8h/05z6PC+Dt1kj8EhD3UC9o5DEZEVIz2lA0MuHFAWlWghRwbiC7N/QdTGE4Fj
         MhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xy8MS2h0CWCw9bCHyV9wMr6WM+l0cnsYOJ5ENcwhPQU=;
        b=arW6ldk5NF2xKRN16EHDgBhAWOd6RPVkj0oZa+To7V8ZiYIqCo1JAxXZWI4TM5lM7g
         zbyiy8LRdIrwPjLFnkgdrdaCPGns3Dh6am1DAsy9e9fx2jQplRbqzG917SUQTRnXmN72
         Z1K24UCVTapcDX92QzHA34FQBVOOoQUsYEfFD5eIBdr5CsalW7lZjl7X13maybfd6G0S
         1meQTfr7d+8Q/7CAcu88cyON9ctM4s3WB+LgI7RHluYQNWMf+IKST5uo27REb4qvF+ng
         TjvxcqpnNqoqXTzHZ65nzopL+vo1fI6IY5oC+QflcLYtPoh4QHo9pN1Zk0wrzAuSmuqd
         WUPQ==
X-Gm-Message-State: APjAAAX8JhU0+PK5+0EC1nPc+oZZuzN60SAa5t7eOuF0QUuS2tom5jNa
        o9X8eJl5vSmJpMtMheMqWih1nw==
X-Google-Smtp-Source: APXvYqyE9zHR6wpcd+ILpl+RnJ2+hgV9hy8h9CYO7M2UFxvNRxMBxmMX99JZFHLzB7CBlemQHiIkuQ==
X-Received: by 2002:a62:ee05:: with SMTP id e5mr19263697pfi.117.1559419347074;
        Sat, 01 Jun 2019 13:02:27 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id p13sm9604796pff.2.2019.06.01.13.02.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 01 Jun 2019 13:02:26 -0700 (PDT)
Date:   Sat, 1 Jun 2019 13:02:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     toke@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, brouer@redhat.com, bpf@vger.kernel.org,
        saeedm@mellanox.com
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
Message-ID: <20190601130223.5ef947fa@cakuba.netronome.com>
In-Reply-To: <20190531094215.3729-2-bjorn.topel@gmail.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
        <20190531094215.3729-2-bjorn.topel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 11:42:14 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 44b47e9df94a..f3a875a52c6c 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1940,6 +1940,9 @@ struct net_device {
>  #endif
>  	struct hlist_node	index_hlist;
> =20
> +	struct bpf_prog		*xdp_prog_hw;

IDK if we should pay the cost of this pointer for every netdev on the
system just for the single production driver out there that implements
HW offload :(  I'm on the fence about this..

> +	u32			xdp_flags;
> +
>  /*
>   * Cache lines mostly used on transmit path
>   */

> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index adcc045952c2..5e396fd01d8b 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1360,42 +1360,44 @@ static int rtnl_fill_link_ifmap(struct sk_buff *s=
kb, struct net_device *dev)
>  	return 0;
>  }
> =20
> -static u32 rtnl_xdp_prog_skb(struct net_device *dev)
> +static unsigned int rtnl_xdp_mode_to_flag(u8 tgt_mode)
>  {
> -	const struct bpf_prog *generic_xdp_prog;
> -
> -	ASSERT_RTNL();
> -
> -	generic_xdp_prog =3D rtnl_dereference(dev->xdp_prog);
> -	if (!generic_xdp_prog)
> -		return 0;
> -	return generic_xdp_prog->aux->id;
> -}
> -
> -static u32 rtnl_xdp_prog_drv(struct net_device *dev)
> -{
> -	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf, XDP_QUERY_PROG);
> +	switch (tgt_mode) {
> +	case XDP_ATTACHED_DRV:
> +		return XDP_FLAGS_DRV_MODE;
> +	case XDP_ATTACHED_SKB:
> +		return XDP_FLAGS_SKB_MODE;
> +	case XDP_ATTACHED_HW:
> +		return XDP_FLAGS_HW_MODE;
> +	}
> +	return 0;
>  }
> =20
> -static u32 rtnl_xdp_prog_hw(struct net_device *dev)
> +static u32 rtnl_xdp_mode_to_attr(u8 tgt_mode)
>  {
> -	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
> -			       XDP_QUERY_PROG_HW);
> +	switch (tgt_mode) {
> +	case XDP_ATTACHED_DRV:
> +		return IFLA_XDP_DRV_PROG_ID;
> +	case XDP_ATTACHED_SKB:
> +		return IFLA_XDP_SKB_PROG_ID;
> +	case XDP_ATTACHED_HW:
> +		return IFLA_XDP_HW_PROG_ID;
> +	}
> +	return 0;
>  }
> =20
>  static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device *d=
ev,
> -			       u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
> -			       u32 (*get_prog_id)(struct net_device *dev))
> +			       u32 *prog_id, u8 *mode, u8 tgt_mode)
>  {
>  	u32 curr_id;
>  	int err;
> =20
> -	curr_id =3D get_prog_id(dev);
> +	curr_id =3D dev_xdp_query(dev, rtnl_xdp_mode_to_flag(tgt_mode));
>  	if (!curr_id)
>  		return 0;
> =20
>  	*prog_id =3D curr_id;
> -	err =3D nla_put_u32(skb, attr, curr_id);
> +	err =3D nla_put_u32(skb, rtnl_xdp_mode_to_attr(tgt_mode), curr_id);
>  	if (err)
>  		return err;
> =20
> @@ -1420,16 +1422,13 @@ static int rtnl_xdp_fill(struct sk_buff *skb, str=
uct net_device *dev)
> =20
>  	prog_id =3D 0;
>  	mode =3D XDP_ATTACHED_NONE;
> -	err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_SKB,
> -				  IFLA_XDP_SKB_PROG_ID, rtnl_xdp_prog_skb);
> +	err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_SKB=
);
>  	if (err)
>  		goto err_cancel;
> -	err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_DRV,
> -				  IFLA_XDP_DRV_PROG_ID, rtnl_xdp_prog_drv);
> +	err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_DRV=
);
>  	if (err)
>  		goto err_cancel;
> -	err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_HW,
> -				  IFLA_XDP_HW_PROG_ID, rtnl_xdp_prog_hw);
> +	err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_HW);
>  	if (err)
>  		goto err_cancel;
> =20

So you remove all the attr and flag params just to add a conversion
helpers to get them based on mode?  Why?  Seems like unnecessary churn,
and questionable change :S

Otherwise looks good to me!
