Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7CEC8C9AA
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfHNCoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:44:02 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38115 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfHNCoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 22:44:02 -0400
Received: by mail-qk1-f193.google.com with SMTP id u190so17774690qkh.5
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 19:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J9k3mS1855SVt82Lg09UQWt7RE18uX1jFzmRpdNquAQ=;
        b=ajCOAbvDQ89ZPQ2LMjxDOQC1JY3BavirpPuojmAjjzzBQdy70NzQm4Is/+7AUL9Kpy
         SoxuFeuHbSfjadO8YufmMdpqbxI1vNw6eQnGVFkVei6fVMUoBrf1Msztib3MDvJ2bK22
         ko11KFnescIgYSaaUIFZUN4sA8HBFDhO0cTdXDVhqsPN/PqWLJRGdjD2sD/1LKz78ULq
         W6GkVGYOXZYAQiDyc01/UHrPi5FNUFEJk+cYnxJzUU6/jWwkAXF+i5IS4LRFOyKBn53L
         /Q5odDP2QkmaOK9NKrut723mbVuZGrvqWIUs/fBmX3M5F0eQEasa7cIiLVPl2KK2vo2v
         sJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J9k3mS1855SVt82Lg09UQWt7RE18uX1jFzmRpdNquAQ=;
        b=HhpqhDujkwwCwxeMtequEqMxZbfq5h3Z0Darj5PAb22K/CXmHRX9Rbk5TPbaH2GC7l
         GpJ6bmbud0CvqOBn++TLgBuV+fDp/bv4Xn8PuTTMTyRbwLtANBHI4+oPQ0M2FVyKUwio
         dJ5Nv90MabUs9p4+GWm/NSlmjsnbAv7phZQw9jZpKvGo/l34pzQ/lvqcgUccxq+lU8iq
         VdtkHyEPfBLQVRWtnCQACa73Liq9jXozXfJ2e3SnB1nSkfYqvF0YdwZ8cGai3L779THi
         vvu90TKcyzfm78wiM2sfVsE8y5g5HtLelD/o6UUQHRp/1x+msADGGwUB+bNn8R5nKaXy
         Wjpw==
X-Gm-Message-State: APjAAAVZ6tH4vgrRCMuQGVu8Ql82k3IxG7xTvc7kasIwyNUMUMAbro9K
        HmGbk2vdL7O4+1LrlXyDM9+rOQ==
X-Google-Smtp-Source: APXvYqxmz72RuCJk75qotzt1nPOOzEYlvSPuuM6perkDXcFxntNhR9gqTX+wLTYoX0Sqs32qArWJRw==
X-Received: by 2002:a37:a358:: with SMTP id m85mr36850278qke.190.1565750641073;
        Tue, 13 Aug 2019 19:44:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s184sm6203341qkf.73.2019.08.13.19.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 19:44:00 -0700 (PDT)
Date:   Tue, 13 Aug 2019 19:43:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, liuhangbin@gmail.com, davem@davemloft.net,
        joe@perches.com
Subject: Re: [PATCH net v2] ibmveth: Convert multicast list size for
 little-endian system
Message-ID: <20190813194037.464bea2c@cakuba.netronome.com>
In-Reply-To: <1565644386-22284-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1565644386-22284-1-git-send-email-tlfalcon@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 16:13:06 -0500, Thomas Falcon wrote:
> The ibm,mac-address-filters property defines the maximum number of
> addresses the hypervisor's multicast filter list can support. It is
> encoded as a big-endian integer in the OF device tree, but the virtual
> ethernet driver does not convert it for use by little-endian systems.
> As a result, the driver is not behaving as it should on affected systems
> when a large number of multicast addresses are assigned to the device.
> 
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Okay, applied, but:

> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index 77af9c2c0571..5641c00d34f2 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -1643,7 +1643,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  	struct net_device *netdev;
>  	struct ibmveth_adapter *adapter;
>  	unsigned char *mac_addr_p;
> -	unsigned int *mcastFilterSize_p;
> +	__be32 *mcastFilterSize_p;
>  	long ret;
>  	unsigned long ret_attr;
>  
> @@ -1665,8 +1665,9 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  		return -EINVAL;
>  	}
>  
> -	mcastFilterSize_p = (unsigned int *)vio_get_attribute(dev,
> -						VETH_MCAST_FILTER_SIZE, NULL);
> +	mcastFilterSize_p = (__be32 *)vio_get_attribute(dev,
> +							VETH_MCAST_FILTER_SIZE,
> +							NULL);
>  	if (!mcastFilterSize_p) {
>  		dev_err(&dev->dev, "Can't find VETH_MCAST_FILTER_SIZE "
>  			"attribute\n");
> @@ -1683,7 +1684,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  
>  	adapter->vdev = dev;
>  	adapter->netdev = netdev;
> -	adapter->mcastFilterSize = *mcastFilterSize_p;
> +	adapter->mcastFilterSize = be32_to_cpu(*mcastFilterSize_p);
>  	adapter->pool_config = 0;
>  	ibmveth_init_link_settings(adapter);

ibmveth_init_link_settings() is part of your net-next patch which
you're respining, so I had to apply manually. Please double check your
patches apply cleanly to the designated tree.
