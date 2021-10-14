Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE6A42DAF8
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 15:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhJNOA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJNOA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:00:28 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638EAC061570;
        Thu, 14 Oct 2021 06:58:23 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i76so3382985pfe.13;
        Thu, 14 Oct 2021 06:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dS0i6alI3BCHNaXfp1uM+JXm7ZDsa47H0oTFoSaCWMw=;
        b=ndusAQ61wdgQFI7E6PkbvYr3ncmwCpa+P08lKrxTbW+l0njiL37dsZTK8PHGZSLp06
         lYg4PTJ+fKeCHJfdmLS0F6yrU8+2PBPgJrmrghIo38lEXug25NFKS8/K6Px0f8/fkJcT
         BkTr/5xnf7OtN7BZECHZegvUxkUuSgr5HUzJJ0S6nCYuWgxvN1VLL4/DXiwv+R3ugSob
         PU654j614ktsavGien4Vo1+VWveuRmzcK/XsOYpU4u3o1sRPtZJX75Hd5I5KBDcOLjNP
         93D0xzNryxXIepdP0eMtk1Whbtke9jRC8m/qX8nkT9/nq9hsAjpA01RGhl9R2k1NzFWK
         VKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dS0i6alI3BCHNaXfp1uM+JXm7ZDsa47H0oTFoSaCWMw=;
        b=LAMQ34E9rn8t3o+T/gqIpAB939LYad/AHVj7HzMOAUMZnFp9XKSFltS9iIhI1g0pbP
         rPXr64GBl0oU+uaCqcBCjt3iVxt7kkbaIfmqzV4qm4Qmz1x7mVAY0Jro5nXWm4sagASx
         yV7ndvQLxhQ/+9cy4DblQOLvEmMOh6JMKFzgAeSapJRqQSrZhzxG7bxFLUdV8SjUJhfX
         WW6c/pP8u8xV5PZxlA4m6By5f5GSRpR7qeMtwYdPeNLmUzA9tnvFoVMIdhZ/BX7KZwy8
         lTCVOdy+Xbkm1R95jl1k3tBxR8Td1GjgKWvsW1BZitah1liM2pTY3zrZlXgzN/ud5F2u
         3lhg==
X-Gm-Message-State: AOAM5336gDaivRdCTs9BJHKGGxZz6Z3779NnP2uI/v1OdMKevNAEuVHD
        5XJHqh3/KDWTHVTpYprfgZptwZ4vf+E=
X-Google-Smtp-Source: ABdhPJyyGc2oq5hhrdTOCQTBJCh4dUs6RzdGwbjgcpLodj6H7Cdwm29aHAUvSnAGURGmFclxzdGkgg==
X-Received: by 2002:a63:3f05:: with SMTP id m5mr4346881pga.240.1634219902587;
        Thu, 14 Oct 2021 06:58:22 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p30sm2634991pgn.60.2021.10.14.06.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 06:58:22 -0700 (PDT)
Subject: Re: [PATCH V4 net-next 1/6] ethtool: add support to set/get tx
 copybreak buf size via ethtool
To:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        amitc@mellanox.com, idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014113943.16231-2-huangguangbin2@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e4e276c6-9545-cf6a-b23e-a80123e896a0@gmail.com>
Date:   Thu, 14 Oct 2021 06:58:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211014113943.16231-2-huangguangbin2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/21 4:39 AM, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> Add support for ethtool to set/get tx copybreak buf size.

What is the unit ?

Frankly, having to size the 'buffer' based on number of slots in TX ring buffer
is not good.

What happens later when/if ethtool -G tx xxxxx' is trying
to change number of slots ?

The 'tx copybreak' should instead give a number of bytes per TX ring slot.

Eg, 128 or 256 bytes.

This is very similar to what drivers using net/core/tso.c do.

They usually use TSO_HEADER_SIZE for this.

> 
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  include/uapi/linux/ethtool.h | 1 +
>  net/ethtool/common.c         | 1 +
>  net/ethtool/ioctl.c          | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index a2223b685451..7bc4b8def12c 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -231,6 +231,7 @@ enum tunable_id {
>  	ETHTOOL_RX_COPYBREAK,
>  	ETHTOOL_TX_COPYBREAK,
>  	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
> +	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
>  	/*
>  	 * Add your fresh new tunable attribute above and remember to update
>  	 * tunable_strings[] in net/ethtool/common.c
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index c63e0739dc6a..0c5210015911 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -89,6 +89,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
>  	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
>  	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
>  	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
> +	[ETHTOOL_TX_COPYBREAK_BUF_SIZE] = "tx-copybreak-buf-size",
>  };
>  
>  const char
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index bf6e8c2f9bf7..617ebc4183d9 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2383,6 +2383,7 @@ static int ethtool_tunable_valid(const struct ethtool_tunable *tuna)
>  	switch (tuna->id) {
>  	case ETHTOOL_RX_COPYBREAK:
>  	case ETHTOOL_TX_COPYBREAK:
> +	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
>  		if (tuna->len != sizeof(u32) ||
>  		    tuna->type_id != ETHTOOL_TUNABLE_U32)
>  			return -EINVAL;
> 
