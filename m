Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E909544B8E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 21:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfFMTET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 15:04:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41109 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbfFMTES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 15:04:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id 33so15691310qtr.8
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 12:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4tPzVQ5P5MhF+Kdaq2kPYhAcGvrTr3/WWcquKgZjznM=;
        b=N5EwqmqbPIqA1i2J3VIBiuj5vtDH9rzezPrMnoeH2fUJ+bnxWQ2srC+FH9KRub/QSl
         /F0i00Xyom57mxb9NPo4ah2+dnJXTT0i3vNzgcDeHi9a37dB7nLJhK/zsv79QhQ3XpVc
         ESFTv0u6AP6eAdFROsOAu1bgPKJ5MHBX2DJjflzAaHZ8N+yx4TXBKmiuPsZq4rFH14l/
         pyM4k+iJhaF4C1rtBbNzhGD1UO699nzbHX7hZdWQeajLgUhXi61/kzD680AgoK7enRQr
         7oxYhZHflTCbDFAE4A9n7xK7sDjpy5A1ZQ48uepZlevOjKDYU2tReYspjuetnPGWfexB
         s7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4tPzVQ5P5MhF+Kdaq2kPYhAcGvrTr3/WWcquKgZjznM=;
        b=eDS5tVTiCm5W0ZQbpSAWgH8jyyK73ZuCssr4A39KDkz2XaqLB9dMXIII0HGnTW4SYw
         /YnWGRZNgEAJ3SCpX1R5ixme0pxJGb7fhxPqYuFINPhTB2wCU2+oXsFcPcb0IHnZRIIb
         kHNlbyCC/3HtqpQ4XjfKR4NARBK5fGTY9/D4SlKqmfUGOYyyC8hjFXI31OeQkJP78OmU
         35BtJIdax4+BlbUHLclHsNy0BK2os1EZCk8LOD7mXOnJbyLsSU0/aDdFQNEe+H59ooss
         4AqLDPeWbAAczII91TpQH5llby5kxKUAHI5R6Qyp7L20MeZuYegV2nRp5GB+doBm2meC
         o6IQ==
X-Gm-Message-State: APjAAAXl4jlt0So/BYNCrDs49qyi/sTqdOfy/KOAtrUSG1MKagSyl4iB
        d7WUGQKOPDfFVktk38lvGVudrQ==
X-Google-Smtp-Source: APXvYqxAR5fh4yeOZq8Kt8Zse+cnVD7bFzFeruCBV7CQ3HI+LByJcpCxC3e1eSVuD5u2o4ZXsBUEKA==
X-Received: by 2002:a0c:b0ce:: with SMTP id p14mr4870955qvc.51.1560452657612;
        Thu, 13 Jun 2019 12:04:17 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b5sm228764qkk.45.2019.06.13.12.04.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 12:04:17 -0700 (PDT)
Date:   Thu, 13 Jun 2019 12:04:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, brouer@redhat.com, bpf@vger.kernel.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next 2/6] xsk: add support for need_wakeup flag in
 AF_XDP rings
Message-ID: <20190613120411.35ef3c52@cakuba.netronome.com>
In-Reply-To: <1560411450-29121-3-git-send-email-magnus.karlsson@intel.com>
References: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
        <1560411450-29121-3-git-send-email-magnus.karlsson@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jun 2019 09:37:26 +0200, Magnus Karlsson wrote:
>  
> -	if (!dev->netdev_ops->ndo_bpf ||
> -	    !dev->netdev_ops->ndo_xsk_async_xmit) {
> +	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
>  		err = -EOPNOTSUPP;
>  		goto err_unreg_umem;
>  	}

> @@ -198,7 +258,8 @@ static int xsk_zc_xmit(struct sock *sk)
>  	struct xdp_sock *xs = xdp_sk(sk);
>  	struct net_device *dev = xs->dev;
>  
> -	return dev->netdev_ops->ndo_xsk_async_xmit(dev, xs->queue_id);
> +	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> +					       XDP_WAKEUP_TX);
>  }
>  
>  static void xsk_destruct_skb(struct sk_buff *skb)

Those two look like they should be in the previous patch?  Won't it
break build?
