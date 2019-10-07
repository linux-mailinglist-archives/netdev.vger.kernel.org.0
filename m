Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C56CDC93
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 09:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfJGHvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 03:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfJGHvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 03:51:47 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A0918A004
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 07:51:47 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id j5so14441117qtn.10
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 00:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GOVJSTkP47ZzAOUaYmHijXMX3bsulzwv44tnyeETKMc=;
        b=nCAoIQCjRbJTmbzvPb9Uoiy3H3WAnk/1MRKSP4OepX+9kyMSzVtQmyo6pe6XNkLAdu
         qU2t/d4MHRmIutIjG2Vu9CmhUOrQIBDtgiwJkigwi7jvuOeAnRdK1nqIp35gFnrE/e2R
         dJibp5+66nIczoutE83XuJLMTf43tW+g2pHlsWSeFc/YXtcGDTgRY+r5RQos3UlLGJLL
         l52UCOnJ0G7H3xTyBKHllMr5Re+Qiq+A6qivv7fsxYeo2OImXrrY2M+/455ZdFOfxO/k
         yhunv2ccb2v0siQ2gOObJyaPv47LCn5D1gV21wgR+0Mp2nTRaWXIdAtevIMqvcEEY2xm
         OmAA==
X-Gm-Message-State: APjAAAX4LVwSj11PeCei570kCI08fiXTRcrDiENyCGxubNDPIXp4LWAk
        iO9sLie9rHGtiB7+ySXukipJUii4Tjga986cq8cVbgmHB+rvzMn7I8kThkQ6GCDOod15rX3X97x
        pATtg5WOAQaM4sm9R
X-Received: by 2002:ad4:44e2:: with SMTP id p2mr26157635qvt.126.1570434706378;
        Mon, 07 Oct 2019 00:51:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyh5wy9dVPoxCeQZme5V03ZIT8bKMQdLE9hxrwP4ww6u5ZVWq39NvDUn0/7YafSrKQswir0+A==
X-Received: by 2002:ad4:44e2:: with SMTP id p2mr26157623qvt.126.1570434706087;
        Mon, 07 Oct 2019 00:51:46 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id f27sm6665058qkh.42.2019.10.07.00.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 00:51:45 -0700 (PDT)
Date:   Mon, 7 Oct 2019 03:51:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     jcfaracco@gmail.com
Cc:     netdev@vger.kernel.org, jasowang@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dnmendes76@gmail.com
Subject: Re: [PATCH RFC net-next 2/2] drivers: net: virtio_net: Add
 tx_timeout function
Message-ID: <20191007034402-mutt-send-email-mst@kernel.org>
References: <20191006184515.23048-1-jcfaracco@gmail.com>
 <20191006184515.23048-3-jcfaracco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006184515.23048-3-jcfaracco@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 06, 2019 at 03:45:15PM -0300, jcfaracco@gmail.com wrote:
> From: Julio Faracco <jcfaracco@gmail.com>
> 
> To enable dev_watchdog, virtio_net should have a tx_timeout defined 
> (.ndo_tx_timeout). This is only a skeleton to throw a warn message. It 
> notifies the event in some specific queue of device. This function 
> still counts tx_timeout statistic and consider this event as an error 
> (one error per queue), reporting it.
> 
> Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> Cc: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 27f9b212c9f5..4b703b4b9441 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2585,6 +2585,29 @@ static int virtnet_set_features(struct net_device *dev,
>  	return 0;
>  }
>  
> +static void virtnet_tx_timeout(struct net_device *dev)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	u32 i;
> +
> +	/* find the stopped queue the same way dev_watchdog() does */

not really - the watchdog actually looks at trans_start.

> +	for (i = 0; i < vi->curr_queue_pairs; i++) {
> +		struct send_queue *sq = &vi->sq[i];
> +
> +		if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i)))
> +			continue;
> +
> +		u64_stats_update_begin(&sq->stats.syncp);
> +		sq->stats.tx_timeouts++;
> +		u64_stats_update_end(&sq->stats.syncp);
> +
> +		netdev_warn(dev, "TX timeout on send queue: %d, sq: %s, vq: %d, name: %s\n",
> +			    i, sq->name, sq->vq->index, sq->vq->name);

this seems to assume any running queue is timed out.
doesn't look right.

also - there's already a warning in this case in the core. do we need another one?

> +		dev->stats.tx_errors++;



> +	}
> +}
> +
>  static const struct net_device_ops virtnet_netdev = {
>  	.ndo_open            = virtnet_open,
>  	.ndo_stop   	     = virtnet_close,
> @@ -2600,6 +2623,7 @@ static const struct net_device_ops virtnet_netdev = {
>  	.ndo_features_check	= passthru_features_check,
>  	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
>  	.ndo_set_features	= virtnet_set_features,
> +	.ndo_tx_timeout		= virtnet_tx_timeout,
>  };
>  
>  static void virtnet_config_changed_work(struct work_struct *work)
> @@ -3018,6 +3042,9 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	dev->netdev_ops = &virtnet_netdev;
>  	dev->features = NETIF_F_HIGHDMA;
>  
> +	/* Set up dev_watchdog cycle. */
> +	dev->watchdog_timeo = 5 * HZ;
> +

Seems to be still broken with napi_tx = false.

>  	dev->ethtool_ops = &virtnet_ethtool_ops;
>  	SET_NETDEV_DEV(dev, &vdev->dev);
>  
> -- 
> 2.21.0
