Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FA0204360
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730892AbgFVWPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgFVWPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:15:23 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6191920738;
        Mon, 22 Jun 2020 22:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592864122;
        bh=vEPF3QHZSG88UIS1f+UfYPfeu2Wme3edT4i/j95Q9xc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y0MhcMwGCpIi3dZuB694pDXY7J8J7fevOTbdI4/weNvBzfLFHi8hSpDykOAB6lzOk
         O9HQKRYW9vU7UQX+Zf+eMHwKbCqUPsSVUjxI7RELhwGC1dg/KgJJADsQiRjgVAfhRn
         U5To28uUmCB+06pcb9AdoIYvcslRk/S5SRX/rczA=
Date:   Mon, 22 Jun 2020 15:15:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v1 5/5] hinic: add support to get eeprom
 information
Message-ID: <20200622151520.79ab2af9@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200620094258.13181-6-luobin9@huawei.com>
References: <20200620094258.13181-1-luobin9@huawei.com>
        <20200620094258.13181-6-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 17:42:58 +0800 Luo bin wrote:
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
> index 5c916875f295..0d0354241345 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
> @@ -677,6 +677,37 @@ struct hinic_led_info {
>  	u8	reset;
>  };
>  
> +#define MODULE_TYPE_SFP		0x3
> +#define MODULE_TYPE_QSFP28	0x11
> +#define MODULE_TYPE_QSFP	0x0C
> +#define MODULE_TYPE_QSFP_PLUS	0x0D
> +
> +#define STD_SFP_INFO_MAX_SIZE	640

Please use the existing defines, e.g. from #include <linux/sfp.h>
there is no need for every driver to redefine those constants.
