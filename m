Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F6C33A3B0
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 10:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhCNI4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 04:56:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229539AbhCNI4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 04:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615712173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LyaH1dab1qBISD1dv3cUf9pEcqtmk2xN7TDwrY2qafc=;
        b=RCW/wy/c0RjBjZILV9ATo8aHrg56ncoTLvYbttlcE99kyXcZ6uM2NnJoZwqiwCSFhck6JI
        YoLXXyiGoH2Z76vJSR+Hr/Wlkg8/3Jd9b4iHlvUMpgfwL7CWkqH1fwO8R4E0fHNDG4goTe
        wg6lPivJtq/kP1yqjmN2AOCE5srINbA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-LBpYNqwmMUazY2jG-8OPJQ-1; Sun, 14 Mar 2021 04:56:11 -0400
X-MC-Unique: LBpYNqwmMUazY2jG-8OPJQ-1
Received: by mail-wr1-f69.google.com with SMTP id y5so13525747wrp.2
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 00:56:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LyaH1dab1qBISD1dv3cUf9pEcqtmk2xN7TDwrY2qafc=;
        b=ecY3AV09EUb4Q1wovmWTUF/VmaCQMNYA1891Nb8ivcTA48y0T4I4iMHwYVQBuAVZom
         3509EFOrmHXdoOqdENHIgHMb8rKOgqNVmc85IoMjUIzwiziPcGJQ1qoaM0h+tpMUAS3C
         BnYyZ+AoH7Mi77oTgbxFYGoUYphe9bsLzb1hFZYm6mJuzQyXbsb/AuBFsPVsQHLsMC7v
         xZBwOQ2zz9MOOZDQ1fgp5kBpYRQn8XK1qVshYAUuL2gihhL+Mmp8bwl+tqVM0ICIHzwc
         ZZ+m1SHrsi3Bm5Y7oqdVOPLsJEtHnqHDBZvKJSW1rxW0fI0JkZJ9fdYIvhZUjrkjik0h
         Gmjw==
X-Gm-Message-State: AOAM530BORxnJN3Imyj8ahU0va8zKyACWQLuEaXVcQCvf7XRMvRhjjWd
        A9KbxZSqP92fMAYxBDgVjIvXQzqK7uYqLdKaTDgvkGwy+9v05fYupvK5vMDmwgTsSalWkYdcxrj
        620heQXtrQg/rS0Gs
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr22950870wrk.146.1615712170120;
        Sun, 14 Mar 2021 00:56:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5nAlSrO335TBU3WBHpmFz/LXcg2/JrE7facrTQ+RdwLovH3VigAS7iOHC73pus5SKoqDvMg==
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr22950845wrk.146.1615712169946;
        Sun, 14 Mar 2021 00:56:09 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id o14sm14006144wri.48.2021.03.14.00.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 00:56:09 -0800 (PST)
Date:   Sun, 14 Mar 2021 04:56:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, simon.horman@netronome.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, drivers@pensando.io,
        snelson@pensando.io, netanel@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, jasowang@redhat.com,
        pv-drivers@vmware.com, doshir@vmware.com, alexanderduyck@fb.com,
        Kernel-team@fb.com
Subject: Re: [net-next PATCH 07/10] virtio_net: Update driver to use
 ethtool_sprintf
Message-ID: <20210314045559-mutt-send-email-mst@kernel.org>
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
 <161557132651.10304.9382850626606060019.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161557132651.10304.9382850626606060019.stgit@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 09:48:46AM -0800, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Update the code to replace instances of snprintf and a pointer update with
> just calling ethtool_sprintf.
> 
> Also replace the char pointer with a u8 pointer to avoid having to recast
> the pointer type.
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c |   18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e97288dd6e5a..77ba8e2fc11c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2138,25 +2138,21 @@ static int virtnet_set_channels(struct net_device *dev,
>  static void virtnet_get_strings(struct net_device *dev, u32 stringset, u8 *data)
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
> -	char *p = (char *)data;
>  	unsigned int i, j;
> +	u8 *p = data;
>  
>  	switch (stringset) {
>  	case ETH_SS_STATS:
>  		for (i = 0; i < vi->curr_queue_pairs; i++) {
> -			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++) {
> -				snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_%s",
> -					 i, virtnet_rq_stats_desc[j].desc);
> -				p += ETH_GSTRING_LEN;
> -			}
> +			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++)
> +				ethtool_sprintf(&p, "rx_queue_%u_%s", i,
> +						virtnet_rq_stats_desc[j].desc);
>  		}
>  
>  		for (i = 0; i < vi->curr_queue_pairs; i++) {
> -			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++) {
> -				snprintf(p, ETH_GSTRING_LEN, "tx_queue_%u_%s",
> -					 i, virtnet_sq_stats_desc[j].desc);
> -				p += ETH_GSTRING_LEN;
> -			}
> +			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++)
> +				ethtool_sprintf(&p, "tx_queue_%u_%s", i,
> +						virtnet_sq_stats_desc[j].desc);
>  		}
>  		break;
>  	}
> 

