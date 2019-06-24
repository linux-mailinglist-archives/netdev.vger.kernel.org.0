Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FB651B24
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 21:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfFXTFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 15:05:25 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32831 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729938AbfFXTFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 15:05:25 -0400
Received: by mail-qt1-f195.google.com with SMTP id w40so5127315qtk.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 12:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AyuRS8Lwp7vEBwCUi0j+D6xyHz2b0vyBNyOhbTtwtYU=;
        b=Z88sjk6Oy1WaO3+yCDQDFOSbz8ukF6kaN/e53K7UPw19c9G4PMe0KXNDQ/dKqFnmAd
         shxS/mq9FNfhBZyQ1N7StT8XRemQpqA+DWEpZRLx8HYuRDM1LcZF3ad4u3N+MEEUbbVs
         L89mZKHlHmWYcVoWMxIwO9TQn0z35be2TPvWCxBIFvfZEymZv+U7erpPcW1rrjKdgg/G
         JUD5T+rmZ9+Oln1tBy8vI8dH1gwVHQO/w2jApOPAtPrzi1U49hfyDC5ANRj1HFzo8/XP
         yqlbRBXHrgcii9xwRgeGGfWEdxKtgadBpMBv6xmtpcXRmRxv2mWl15B2K5XXGJayEIGD
         xX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AyuRS8Lwp7vEBwCUi0j+D6xyHz2b0vyBNyOhbTtwtYU=;
        b=Y+wGIogtxRdQocHKpHQNf5LbAVLFZk5e9F9d4yT4NV52oMEJxfW5DsIyoSLPXK5zn8
         2rq4h01ZGrBT8Y1cM8Rz6JYjhrkqc9to1Nt1PVRPWQzZ3GUgEwgg6+lp6sqyLTHEbwRF
         y3jZygmfsl5DP9Ri1itWI6wEmyNE4Xnsn6/JQrgeFjhGH5tEkcjjV9YhpedZokxixvTz
         gNcaAUIjaWRRJaYEzHWHa+4Nq1Rhuu9hPvNPg0C9Tkwq9x6bgaN7HjIFdVxWzUOe7AnZ
         RNjoXyU9MSOemySdKaLPGfRpAYbHP0Oy7ogKrpBqOr9eRyrf8ly49NbWnuiheMbohOEk
         QrVQ==
X-Gm-Message-State: APjAAAUds1vBnLsVEqnesKtQYY6GYU1E6TpoOP+zaRy/D0MOEIhmxhJo
        CuY2iZ051LEJQ+P6/yAz+O7VCA==
X-Google-Smtp-Source: APXvYqxxKgDZPrZjQ+nMk6dZ1YsT4ETp55XKhQk8ZqXTj/pbdZwyLqfTdPwdA59WtozoaqyvZJNf3Q==
X-Received: by 2002:ac8:685:: with SMTP id f5mr57301924qth.9.1561403124388;
        Mon, 24 Jun 2019 12:05:24 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e4sm7095824qtc.3.2019.06.24.12.05.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 12:05:24 -0700 (PDT)
Date:   Mon, 24 Jun 2019 12:05:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xue Chaojing <xuechaojing@huawei.com>, <davem@davemloft.net>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>, <wulike1@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v2] hinic: implement the statistical interface
 of ethtool
Message-ID: <20190624120519.4ec22e19@cakuba.netronome.com>
In-Reply-To: <20190624035012.7221-1-xuechaojing@huawei.com>
References: <20190624035012.7221-1-xuechaojing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 03:50:12 +0000, Xue Chaojing wrote:
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> index be28a9a7f033..8d98f37c88a8 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> @@ -438,6 +438,344 @@ static u32 hinic_get_rxfh_indir_size(struct net_device *netdev)
>  	return HINIC_RSS_INDIR_SIZE;
>  }
>  
> +#define ARRAY_LEN(arr) ((int)((int)sizeof(arr) / (int)sizeof(arr[0])))
> +
> +#define HINIC_NETDEV_STAT(_stat_item) { \
> +	.name = #_stat_item, \
> +	.size = FIELD_SIZEOF(struct rtnl_link_stats64, _stat_item), \
> +	.offset = offsetof(struct rtnl_link_stats64, _stat_item) \
> +}
> +
> +static struct hinic_stats hinic_netdev_stats[] = {
> +	HINIC_NETDEV_STAT(rx_packets),
> +	HINIC_NETDEV_STAT(tx_packets),
> +	HINIC_NETDEV_STAT(rx_bytes),
> +	HINIC_NETDEV_STAT(tx_bytes),
> +	HINIC_NETDEV_STAT(rx_errors),
> +	HINIC_NETDEV_STAT(tx_errors),
> +	HINIC_NETDEV_STAT(rx_dropped),
> +	HINIC_NETDEV_STAT(tx_dropped),
> +	HINIC_NETDEV_STAT(multicast),
> +	HINIC_NETDEV_STAT(collisions),
> +	HINIC_NETDEV_STAT(rx_length_errors),
> +	HINIC_NETDEV_STAT(rx_over_errors),
> +	HINIC_NETDEV_STAT(rx_crc_errors),
> +	HINIC_NETDEV_STAT(rx_frame_errors),
> +	HINIC_NETDEV_STAT(rx_fifo_errors),
> +	HINIC_NETDEV_STAT(rx_missed_errors),
> +	HINIC_NETDEV_STAT(tx_aborted_errors),
> +	HINIC_NETDEV_STAT(tx_carrier_errors),
> +	HINIC_NETDEV_STAT(tx_fifo_errors),
> +	HINIC_NETDEV_STAT(tx_heartbeat_errors),
> +};

I think we wanted to stop duplicating standard netdev stats in ethtool
-S.  Chaojing please post a patch to remove this part, the other stats
are good.
