Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C739226D10
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgGTRYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgGTRYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:24:52 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BD6C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:24:52 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s189so10575622pgc.13
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 10:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6tXbJd4oEVmSqiGnziAAflmb4MGrnOQpZX5+lHSdW3g=;
        b=jNANyFXgAgqogkWNgrJoj6QtdoyB0yR54rUSu+O4nZVCVb/7hJZiOX6O4uSHF5Atso
         ItdU4dvRixI5slgLsUGF6Z1uawSBBTJnKZgWo11KLDx8JECBDRW8nr4j9+sM0peyA8vo
         /qfKucK6NlSY6FRrqC4W3rIolIkfF7MNoNV7GmIXgaGQZ+vB1QwC075G84MoosS5n4wS
         OJQ8ihNqJZJFZcnWopsyZUXi0T9t6mm8xYD799vZpU14tj3GftLFIaG4pJhETMBK4OSb
         EDenfd10pqs5KddO/+hBoHqqMxC/qyPXviQ/6TDYt7Q8FpxSSQKDQn9LEdgAgWdURRWJ
         LCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tXbJd4oEVmSqiGnziAAflmb4MGrnOQpZX5+lHSdW3g=;
        b=L3hn1qdsb+tktBn/CM1hv+/49klR9WmfUHL8c/PRDqXN2+Wo3Ity8MXTMw1eETBKsb
         eZu29JFbW1PnMpx/gR6H57zLp7dDm/7379iJMdtrWNt4a5RdhQJgfKXCfIGDV6/Nv1/h
         xuM5ud8CniqLSEmFo8yYv+HunsL54FtyeHABW776tFk93myDuChkYlGWzN67hx93r8jN
         ZkbUvzajs5xlWOWVpnDrRJ9Rf+/pDut5xrhCN83W8JLG/IbSdi9tN0LO+CrEIO4DtA/Z
         jQQlApJnOmwzmf0/+mdsyKDOssMygrH6Ge72LAtRb6ioGlF7iVO5h7K/tJ35ey4eRC2x
         K4Cw==
X-Gm-Message-State: AOAM531Cvp9GrW4NL3V4t9XGNBzZJQPn0mGQM0qaeV3eDwOtR+Q1t2NX
        2Cxq7nBNYWbzlc9ZrLVCityYlQ==
X-Google-Smtp-Source: ABdhPJx2Og1skqUry9DiKMzcmFRiYWZ31mk7FqDM7ufVQ3k37RbqfBypuApaoSr5H7ormO+7hIXfVQ==
X-Received: by 2002:a63:f90f:: with SMTP id h15mr19068452pgi.53.1595265891947;
        Mon, 20 Jul 2020 10:24:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z11sm17365435pfk.46.2020.07.20.10.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 10:24:51 -0700 (PDT)
Date:   Mon, 20 Jul 2020 10:24:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Chi Song <chisong@linux.microsoft.com>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: hyperv: Add attributes to show TX
 indirection table
Message-ID: <20200720102443.63d8ddf2@hermes.lan>
In-Reply-To: <alpine.LRH.2.23.451.2007192357400.30908@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <alpine.LRH.2.23.451.2007192357400.30908@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 00:12:10 -0700 (PDT)
Chi Song <chisong@linux.microsoft.com> wrote:

> An imbalanced TX indirection table causes netvsc to have low
> performance. This table is created and managed during runtime. To help
> better diagnose performance issues caused by imbalanced tables, add
> device attributes to show the content of TX indirection tables.
> 
> Signed-off-by: Chi Song <chisong@microsoft.com>
> ---


> v2: remove RX as it's in ethtool already, show single value in each file,
>  and update description.
> 
> Thank you for comments. Let me know, if I miss something.
> 
> ---
>  drivers/net/hyperv/netvsc_drv.c | 53 +++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> index 6267f706e8ee..222c2fad9300 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2370,6 +2370,55 @@ static int netvsc_unregister_vf(struct net_device
> *vf_netdev)
>  	return NOTIFY_OK;
>  }
> 
> +static struct device_attribute
> dev_attr_netvsc_dev_attrs[VRSS_SEND_TAB_SIZE];
> +static struct attribute *netvsc_dev_attrs[VRSS_SEND_TAB_SIZE + 1];
> +
> +const struct attribute_group netvsc_dev_group = {
> +	.name = NULL,
> +	.attrs = netvsc_dev_attrs,
> +};
> +
> +static ssize_t tx_indirection_table_show(struct device *dev,
> +					 struct device_attribute
> *dev_attr,
> +					 char *buf)
> +{
> +	struct net_device *ndev = to_net_dev(dev);
> +	struct net_device_context *ndc = netdev_priv(ndev);
> +	ssize_t offset = 0;

useless initialization

> +	int index = dev_attr - dev_attr_netvsc_dev_attrs;
> +
> +	offset = sprintf(buf, "%u\n", ndc->tx_table[index]);
> +
> +	return offset;
why not just
	return sprintf(buf, "%u\n", ndc->tx_table[index]);
> +}
> +
> +static void netvsc_attrs_init(void)
> +{
> +	int i;
> +	char buffer[32];
> +
> +	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++) {
> +		sprintf(buffer, "tx_indirection_table_%02u", i);

Although this has one value per file it leads to a mess.
Why not put it in a separate directory (/sys/class/net/eth0/tx_indirection/N)?
