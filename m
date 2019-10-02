Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E37C92C8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 22:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfJBULk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 16:11:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45500 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfJBULk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 16:11:40 -0400
Received: by mail-qt1-f193.google.com with SMTP id c21so320191qtj.12
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 13:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=v4ilG1LetHwRQdisJJSkJYkok1aQfUu7qi47lcADeaQ=;
        b=0IzsF0VHLF8iIwO1p414GXtf+4H8Q420eHfasC8yUozj35HhNeQAw17N6rzByTas5b
         +leFq6h/X7hK5YklutfHKus90ecYRPo7om7drQPiSjCWVH+QULNMWobyosroyn6weZ6l
         4Nq4SVL9yl86c9xZH187eaZuVjujr27byVc2qnIBd29dNn5gFnAhcP5EDuNCZnkY4TyJ
         gJNn2aTHcf+MAfSi9+R6FZg7KTEFyRcn/i3yuAhpatVOzJf+z2IkgITccOiviNIHSQcP
         ffER28lQWV784//NDKvb13rZC9ILT6Oc7f2LoBR6E5WSUVAARnOsOYzK8ro2z8wv4xQN
         +8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=v4ilG1LetHwRQdisJJSkJYkok1aQfUu7qi47lcADeaQ=;
        b=Sr4LRQF14Q0QpxM5BMa5QixnA3yxYOmQglTHTqtjZOVNsP3IcoXMWze1LLFGkTsU2s
         +c1Uvs1Pck+FOExp8GxL8h0x4CortAvPZAjGS9uzOivs15sMBy2yS38NtefdbZVTEvCe
         Ib9UMJX7WPif8WtSslxEdKTWdF8EHRtoylAoBXCsS280EtBeWXGq6fIAb43y79pmoHlw
         Ni8ufDOMs56ahVOluDXLRq580rT0vns1r9e+8vbooEtbN/gTovEFNWmQMdoCjyM3MQIJ
         aCYuOQIcm34KvRW/v5l84IPydt5NX+lvM3rnFKg1ZnHVZlWuRdfa05w346onQEvON7B7
         E+Kw==
X-Gm-Message-State: APjAAAVCZAF+9JRRTt30k9oPqk91k0b/Hk2QHEsdFkd0NySiNbTKhzQ2
        W6Ye+vQ1sVigT3ZFq2OkV1AU4w==
X-Google-Smtp-Source: APXvYqzaQ/mOIS8woRM5i3CeIl3FFnkzMLgAhue/+Yc6bx1lKf3UmaEWwPwkg7sfTiE9eRbIMdiOtA==
X-Received: by 2002:a05:6214:2e4:: with SMTP id h4mr4896318qvu.127.1570047099001;
        Wed, 02 Oct 2019 13:11:39 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c201sm110825qke.128.2019.10.02.13.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 13:11:38 -0700 (PDT)
Date:   Wed, 2 Oct 2019 13:11:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: Re: [PATCH V2 net-next 5/5] net: ena: ethtool: support set_channels
 callback
Message-ID: <20191002131132.7b81f339@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191002082052.14051-6-sameehj@amazon.com>
References: <20191002082052.14051-1-sameehj@amazon.com>
 <20191002082052.14051-6-sameehj@amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Oct 2019 11:20:52 +0300, sameehj@amazon.com wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
>=20
> Set channels callback enables the user to change the count of queues
> used by the driver using ethtool. We decided to currently support only
> equal number of rx and tx queues, this might change in the future.
>=20
> Also rename dev_up to dev_was_up in ena_update_queue_count() to make
> it clearer.
>=20
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 17 ++++++++++++++
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 22 ++++++++++++++++---
>  drivers/net/ethernet/amazon/ena/ena_netdev.h  |  3 +++
>  3 files changed, 39 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/=
ethernet/amazon/ena/ena_ethtool.c
> index c9d760465..f58fc3c68 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> @@ -744,6 +744,22 @@ static void ena_get_channels(struct net_device *netd=
ev,
>  	channels->combined_count =3D 0;
>  }
> =20
> +static int ena_set_channels(struct net_device *netdev,
> +			    struct ethtool_channels *channels)
> +{
> +	struct ena_adapter *adapter =3D netdev_priv(netdev);
> +	u32 new_channel_count;
> +
> +	if (channels->rx_count !=3D channels->tx_count ||

If you use the same IRQ and NAPI to service RX and TX it's a combined
channel, not rx and tx channels.

> +	    channels->max_tx !=3D channels->max_rx)

Hm.. maxes are generally ignored on set =F0=9F=A4=94

> +		return -EINVAL;
> +
> +	new_channel_count =3D clamp_val(channels->tx_count,
> +				      ENA_MIN_NUM_IO_QUEUES, channels->max_tx);

You should return an error if the value is not within bounds, rather
than guessing.

> +	return ena_update_queue_count(adapter, new_channel_count);
> +}
> +
>  static int ena_get_tunable(struct net_device *netdev,
>  			   const struct ethtool_tunable *tuna, void *data)
>  {
> @@ -807,6 +823,7 @@ static const struct ethtool_ops ena_ethtool_ops =3D {
>  	.get_rxfh		=3D ena_get_rxfh,
>  	.set_rxfh		=3D ena_set_rxfh,
>  	.get_channels		=3D ena_get_channels,
> +	.set_channels		=3D ena_set_channels,
>  	.get_tunable		=3D ena_get_tunable,
>  	.set_tunable		=3D ena_set_tunable,
>  };
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/e=
thernet/amazon/ena/ena_netdev.c
> index e964783c4..7d44b3440 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -2044,14 +2044,30 @@ int ena_update_queue_sizes(struct ena_adapter *ad=
apter,
>  			   u32 new_tx_size,
>  			   u32 new_rx_size)
>  {
> -	bool dev_up;
> +	bool dev_was_up;
> =20
> -	dev_up =3D test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
> +	dev_was_up =3D test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
>  	ena_close(adapter->netdev);
>  	adapter->requested_tx_ring_size =3D new_tx_size;
>  	adapter->requested_rx_ring_size =3D new_rx_size;
>  	ena_init_io_rings(adapter);
> -	return dev_up ? ena_up(adapter) : 0;
> +	return dev_was_up ? ena_up(adapter) : 0;
> +}
> +
> +int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_=
count)
> +{
> +	struct ena_com_dev *ena_dev =3D adapter->ena_dev;
> +	bool dev_was_up;
> +
> +	dev_was_up =3D test_bit(ENA_FLAG_DEV_UP, &adapter->flags);
> +	ena_close(adapter->netdev);
> +	adapter->num_io_queues =3D new_channel_count;
> +       /* We need to destroy the rss table so that the indirection
> +	* table will be reinitialized by ena_up()
> +	*/
> +	ena_com_rss_destroy(ena_dev);
> +	ena_init_io_rings(adapter);
> +	return dev_was_up ? ena_open(adapter->netdev) : 0;

You should try to prepare the resources for the new configuration
before you attempt the change. Otherwise if allocation of new rings
fails the open will leave the device in a broken state.

This is not always enforced upstream, but you can see mlx5 or nfp for
examples of drivers which do this right..

>  }
> =20
>  static void ena_tx_csum(struct ena_com_tx_ctx *ena_tx_ctx, struct sk_buf=
f *skb)
