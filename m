Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E427223996
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgGQKnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:43:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52872 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgGQKnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:43:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id q15so14172453wmj.2;
        Fri, 17 Jul 2020 03:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LSE9umRH3nWIvfdFNBwmB1m+0/8khnsXtG7gUR3+lhQ=;
        b=MTclCLxnSGTulDMf7kw9bdG5Rsenwxy0FR7VPd6FmSHhoQCGrM+Kh3ejyehZZDVROz
         e6NVV445Ter2u3ARYoEzQwa04Aa/8On2/gF3GjB+Vd1qBbt/8tyZvb+T5MGGd3LfSyAV
         eYCKUOo5tB1I8gYltMxENXQTvqkgEUI8phy3CMNQDvFjW93CaT1JQ9dYAOC4kWj4wvmz
         QUPkVivj2tDHp61MplATuZTojRIFG6Dm/5TGNfqTZuDhndRaOspCT2XBH7ymD9FNgeHu
         qvS2+sS4E+S3WmHxSiofyIPDK/2fMwnQxrswMVoH3zaUh43zyqFAu7z+9ig4rVyluYNi
         g+yg==
X-Gm-Message-State: AOAM530w/Jx7LKlVNvHqpDMRAM6Eof0kqjWwFlT0DlRztYu0W8G6GTp6
        QaFpBkhvCxRpijY4fIrAZZw=
X-Google-Smtp-Source: ABdhPJx8welwCuOA1l/xNh4E/9QDLWouXozoXt96oAhI1heXK8k2dfzmyqMAsKsdrZS8NTxZy7UyPQ==
X-Received: by 2002:a1c:4d11:: with SMTP id o17mr8486138wmh.134.1594982630965;
        Fri, 17 Jul 2020 03:43:50 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id w2sm13172955wrs.77.2020.07.17.03.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:43:50 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:43:48 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Chi Song <Song.Chi@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Message-ID: <20200717104348.epj54vr3evmullol@liuwe-devbox-debian-v2>
References: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chi

Thanks for your patch. A few things need to be fixed before it can be
accepted upstream.

On Fri, Jul 17, 2020 at 06:04:31AM +0000, Chi Song wrote:
> The network is observed with low performance, if TX indirection table
> is imbalance.  But the table is in memory and set in runtime, it's
> hard to know. Add them to attributes can help on troubleshooting.

Missing Signed-off-by here. I assume you wrote this patch so please add

    Signed-off-by: Chi Song <song.chi@microsoft.com>

If there are other authors, please add their SoBs too.

Please wrap the commit message to around 72 to 80 columns wide.

I notice you only talked about TX table but in the code your also added
support for RX table.

I would also suggest changing the commit message a bit to:

    An imbalanced TX indirection table causes netvsc to have low
    performance. This table is created and managed during runtime. To help
    better diagnose performance issues caused by imbalanced tables, add
    device attributes to show the content of TX and RX indirection tables.

Perhaps RX table causes low performance as well? If so, the above
message needs further adjustment to account for that too.

I will leave reviewing the code to Haiyang and Stephen.

Wei.


> ---
>  drivers/net/hyperv/netvsc_drv.c | 46 +++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 6267f706e8ee..cd6fe96e10c1 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2370,6 +2370,51 @@ static int netvsc_unregister_vf(struct net_device *vf_netdev)
>  	return NOTIFY_OK;
>  }
>  
> +static ssize_t tx_indirection_table_show(struct device *dev,
> +					 struct device_attribute *dev_attr,
> +					 char *buf)
> +{
> +	struct net_device *ndev = to_net_dev(dev);
> +	struct net_device_context *ndc = netdev_priv(ndev);
> +	int i = 0;
> +	ssize_t offset = 0;
> +
> +	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++)
> +		offset += sprintf(buf + offset, "%u ", ndc->tx_table[i]);
> +	buf[offset - 1] = '\n';
> +
> +	return offset;
> +}
> +static DEVICE_ATTR_RO(tx_indirection_table);
> +
> +static ssize_t rx_indirection_table_show(struct device *dev,
> +					 struct device_attribute *dev_attr,
> +					 char *buf)
> +{
> +	struct net_device *ndev = to_net_dev(dev);
> +	struct net_device_context *ndc = netdev_priv(ndev);
> +	int i = 0;
> +	ssize_t offset = 0;
> +
> +	for (i = 0; i < ITAB_NUM; i++)
> +		offset += sprintf(buf + offset, "%u ", ndc->rx_table[i]);
> +	buf[offset - 1] = '\n';
> +
> +	return offset;
> +}
> +static DEVICE_ATTR_RO(rx_indirection_table);
> +
> +static struct attribute *netvsc_dev_attrs[] = {
> +	&dev_attr_tx_indirection_table.attr,
> +	&dev_attr_rx_indirection_table.attr,
> +	NULL
> +};
> +
> +const struct attribute_group netvsc_dev_group = {
> +	.name = NULL,
> +	.attrs = netvsc_dev_attrs,
> +};
> +
>  static int netvsc_probe(struct hv_device *dev,
>  			const struct hv_vmbus_device_id *dev_id)
>  {
> @@ -2410,6 +2455,7 @@ static int netvsc_probe(struct hv_device *dev,
>  
>  	net->netdev_ops = &device_ops;
>  	net->ethtool_ops = &ethtool_ops;
> +	net->sysfs_groups[0] = &netvsc_dev_group;
>  	SET_NETDEV_DEV(net, &dev->device);
>  
>  	/* We always need headroom for rndis header */
> -- 
> 2.25.1
