Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDF9DB760
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503466AbfJQTWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:22:09 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40010 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503454AbfJQTWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:22:08 -0400
Received: by mail-lf1-f67.google.com with SMTP id f23so2790693lfk.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 12:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ufaGCovz/0EljJJx7b3P7B+K54l8yKQrt1mgyUCDFIQ=;
        b=jbcreWSqkXHkJAzvoPetAwV7I6zFFo/owCd15IT+Lgax4MHJJg1oXlxLQDoCK8BUpF
         CN81PtVXlomyFoYLS3okM3nBQe+ScjCCAjstKRKWHtE9nFKJJKTqCKY27D+wqaH7gJ1b
         awhcCSvoKWE3FWsbAMribuLgzASdtZuQOrJy3Uex9y6O0NFrCYlseh4cLYD0Cs142Mw9
         JaL84cSVdOwpnUWZ02xD5gniQL/v8aOyucScZbjcDoUndv1swJ6wCfrFgzH3ws+AFAFz
         LdFP2+FcNanEqi3Uu/A6/57Nz1DSLTpd1hb4F2UgdxxSqhIQvXIs566kY01oHzsRI/3a
         hrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ufaGCovz/0EljJJx7b3P7B+K54l8yKQrt1mgyUCDFIQ=;
        b=RyUWRRSvSmHBhrVXQxExtQ1OvTf51Q+QfiKfa38OucJPN5YPlVOjMqg/kDwYBbogRv
         5u5cBTkioO/aMdCrgEqRPbApDweWitzBTRDXyM6aLIJHvwS5xUC4iQvIJ0xmMkSxxVJf
         88Fg20cvnSf8lV8RI3wJ5BTskV4Oo8kYxnIIRp22Tquq7MISMXboqijDYVE3BdM1CvRn
         NvPZB+uFs2VYMZN3kOPh/JvvYDo+AV1l6+WxgcJlLBDeZnSJY8+JpmwJZxksnjaZzafd
         dmwvvlW6pb2zS+tSueiERK0UgVbNV96OS7eKm8MNzdQ/mvQAxPQcmn2ElS24h6e7XU5h
         loNQ==
X-Gm-Message-State: APjAAAU3FOLpo2+iHm8c5JCuCTdt+h9g0N+fMIlbSytcCwRkxU3SCx1/
        KwepeKMjuFHUgYErVt40/wlXPw==
X-Google-Smtp-Source: APXvYqwx/b/RAtAsPXRp8jdixyhaZHSpj5quqpCp+ibcRPiPczXYKvW4XUKOjeVMXxNUXZYF2g6hkA==
X-Received: by 2002:a19:23d7:: with SMTP id j206mr1401520lfj.187.1571340125843;
        Thu, 17 Oct 2019 12:22:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r75sm2862084lff.7.2019.10.17.12.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 12:22:05 -0700 (PDT)
Date:   Thu, 17 Oct 2019 12:21:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH V2 3/3] bnxt_en: Add support to collect crash dump via
 ethtool
Message-ID: <20191017122156.4d5262ac@cakuba.netronome.com>
In-Reply-To: <1571313682-28900-4-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
        <1571313682-28900-4-git-send-email-sheetal.tigadoli@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 17:31:22 +0530, Sheetal Tigadoli wrote:
> From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> 
> Driver supports 2 types of core dumps.
> 
> 1. Live dump - Firmware dump when system is up and running.
> 2. Crash dump - Dump which is collected during firmware crash
>                 that can be retrieved after recovery.
> Crash dump is currently supported only on specific 58800 chips
> which can be retrieved using OP-TEE API only, as firmware cannot
> access this region directly.
> 
> User needs to set the dump flag using following command before
> initiating the dump collection:
> 
>     $ ethtool -W|--set-dump eth0 N
> 
> Where N is "0" for live dump and "1" for crash dump
> 
> Command to collect the dump after setting the flag:
> 
>     $ ethtool -w eth0 data Filename
> 
> Cc: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  3 ++
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 36 +++++++++++++++++++++--
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 ++
>  3 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index 0943715..3e7d1fb 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -1807,6 +1807,9 @@ struct bnxt {
>  
>  	u8			num_leds;
>  	struct bnxt_led_info	leds[BNXT_MAX_LED];
> +	u16			dump_flag;
> +#define BNXT_DUMP_LIVE		0
> +#define BNXT_DUMP_CRASH		1
>  
>  	struct bpf_prog		*xdp_prog;
>  
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index 51c1404..1596221 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -3311,6 +3311,23 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
>  	return rc;
>  }
>  
> +static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
> +{
> +	struct bnxt *bp = netdev_priv(dev);
> +
> +#ifndef CONFIG_TEE_BNXT_FW
> +	return -EOPNOTSUPP;
> +#endif

	if (!IS_ENABLED(...))
		return x;

reads better IMHO

But also you seem to be breaking live dump for systems with
CONFIG_TEE_BNXT_FW=n

> +	if (dump->flag > BNXT_DUMP_CRASH) {
> +		netdev_err(dev, "Supports only Live(0) and Crash(1) dumps.\n");

more of an _info than _err, if at all

> +		return -EINVAL;
> +	}
> +
> +	bp->dump_flag = dump->flag;
> +	return 0;
> +}
> +
>  static int bnxt_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
>  {
>  	struct bnxt *bp = netdev_priv(dev);
> @@ -3323,7 +3340,12 @@ static int bnxt_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
>  			bp->ver_resp.hwrm_fw_bld_8b << 8 |
>  			bp->ver_resp.hwrm_fw_rsvd_8b;
>  
> -	return bnxt_get_coredump(bp, NULL, &dump->len);
> +	dump->flag = bp->dump_flag;
> +	if (bp->dump_flag == BNXT_DUMP_CRASH)
> +		dump->len = BNXT_CRASH_DUMP_LEN;
> +	else
> +		bnxt_get_coredump(bp, NULL, &dump->len);
> +	return 0;
>  }
>  
>  static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
> @@ -3336,7 +3358,16 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
>  
>  	memset(buf, 0, dump->len);
>  
> -	return bnxt_get_coredump(bp, buf, &dump->len);
> +	dump->flag = bp->dump_flag;
> +	if (dump->flag == BNXT_DUMP_CRASH) {
> +#ifdef CONFIG_TEE_BNXT_FW
> +		return tee_bnxt_copy_coredump(buf, 0, dump->len);
> +#endif
> +	} else {
> +		return bnxt_get_coredump(bp, buf, &dump->len);
> +	}
> +
> +	return 0;
>  }
>  
>  void bnxt_ethtool_init(struct bnxt *bp)
> @@ -3446,6 +3477,7 @@ void bnxt_ethtool_free(struct bnxt *bp)
>  	.set_phys_id		= bnxt_set_phys_id,
>  	.self_test		= bnxt_self_test,
>  	.reset			= bnxt_reset,
> +	.set_dump		= bnxt_set_dump,
>  	.get_dump_flag		= bnxt_get_dump_flag,
>  	.get_dump_data		= bnxt_get_dump_data,
>  };
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> index b5b65b3..01de7e7 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> @@ -59,6 +59,8 @@ struct hwrm_dbg_cmn_output {
>  	#define HWRM_DBG_CMN_FLAGS_MORE	1
>  };
>  
> +#define BNXT_CRASH_DUMP_LEN	(8 << 20)
> +
>  #define BNXT_LED_DFLT_ENA				\
>  	(PORT_LED_CFG_REQ_ENABLES_LED0_ID |		\
>  	 PORT_LED_CFG_REQ_ENABLES_LED0_STATE |		\

