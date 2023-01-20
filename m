Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A036752E2
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjATLAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjATLAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:00:53 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E68CDC3
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:00:49 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id bk15so12942367ejb.9
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hoDMaWk2lzhWTny3tpmBkSpz7Jesu7FdzncFINoRras=;
        b=FN5uWFNrNLEVO8TFSG98vcj57FV1IOF9ctP/nSMLCCVjyCQmgWH9QnpL32d6DcyXWW
         pVAQ40vaor7N5nPtUTghAfvJXgaOG0CErIldkSpouQku46N7WrSSjUzicbBs/QVyBqrF
         FwOTTP+rpkDsInKDDa4MvPQ9IfHJGzOrGzFJz5QjinUzIN16wRHPnkAek6/UWuG5mdf+
         GEPdocShFPWL0Fj4c9PCr8+Or24Kk7uVpsLlTvpPUpFsd0FzDgv+lf1s1jefnI8Fdz5+
         I0stCequsJ3Un8OknQmm9yD/FYtjhPWYJ4PspDRYgmlcLJ7jQLYmpmt8iMQn4QxK3j/Y
         8zpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hoDMaWk2lzhWTny3tpmBkSpz7Jesu7FdzncFINoRras=;
        b=xvdQ5d4KPLUIEem/tEcevSAHqStmznxOVYcIprY/NnaIyiSkIS8k0dEHifEy894ka2
         OQtT4i1oy/s4Q/LrKwjYLhAiWlUDyIxTRd9WaNJ/fER6DKz4aek7vey1ECFHit0ZpIWB
         CgZ65xBS5cOqRqz+BlQ6yfNUVKwuFBvCArAu+JCSNNVBTvF075jmrVx9I/FK8APPOC0X
         wpfBKkV9ARcW7rq/K8SqIHCwwuNqgGm9iD/OtYR0VuBVihVLUTrHllGnz1PgU32xNppG
         mkiTSX2xBud8X1Z3i36CfcnEPXANk8m2HdQUmgjKQsTs9KTGJeNXPx9uGJGPgDLAEH/G
         9UTg==
X-Gm-Message-State: AFqh2kplJZhpdz/l8uXy/gee2oAsjgbIR+Ftftijk/xZGdG9u8qP1/WW
        nX3nh8+AzeS7PPeEg1+9PDGpu6fkyFNhDK1iSj0=
X-Google-Smtp-Source: AMrXdXu8yCyOGYtSWBOp7ERHpa4HjWSRap5MSwo07Y12dsRp1jshrwaI/dV//P95qLRRi5SYV+JnFg==
X-Received: by 2002:a17:907:c11:b0:844:79b1:ab36 with SMTP id ga17-20020a1709070c1100b0084479b1ab36mr38546571ejc.25.1674212447670;
        Fri, 20 Jan 2023 03:00:47 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id o11-20020a170906768b00b0084d242d07ffsm17344123ejm.8.2023.01.20.03.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 03:00:47 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:00:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm@gmail.com" <habetsm@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Message-ID: <Y8p0XUJX55dUVcUJ@nanopsycho>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
 <Y8k0FsF/3vFKKEU8@nanopsycho>
 <11c59e1f-0465-09c1-638b-d79447752735@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11c59e1f-0465-09c1-638b-d79447752735@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 19, 2023 at 03:51:53PM CET, alejandro.lucero-palau@amd.com wrote:
>
>On 1/19/23 12:14, Jiri Pirko wrote:
>> Thu, Jan 19, 2023 at 12:31:34PM CET, alejandro.lucero-palau@amd.com wrote:
>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>>
>>> Basic support for devlink info command.
>>>
>>> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>> ---
>>> drivers/net/ethernet/sfc/Kconfig       |   1 +
>>> drivers/net/ethernet/sfc/Makefile      |   3 +-
>>> drivers/net/ethernet/sfc/ef100_nic.c   |   6 +
>>> drivers/net/ethernet/sfc/efx_devlink.c | 427 +++++++++++++++++++++++++
>>> drivers/net/ethernet/sfc/efx_devlink.h |  20 ++
>>> drivers/net/ethernet/sfc/mcdi.c        |  72 +++++
>>> drivers/net/ethernet/sfc/mcdi.h        |   3 +
>>> drivers/net/ethernet/sfc/net_driver.h  |   2 +
>>> 8 files changed, 533 insertions(+), 1 deletion(-)
>>> create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
>>> create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h
>> Could you please split?
>>
>> At least the devlink introduction part and info implementation.
>> 
>
>Sure.
>
>>> diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
>>> index 0950e6b0508f..4af36ba8906b 100644
>>> --- a/drivers/net/ethernet/sfc/Kconfig
>>> +++ b/drivers/net/ethernet/sfc/Kconfig
>>> @@ -22,6 +22,7 @@ config SFC
>>> 	depends on PTP_1588_CLOCK_OPTIONAL
>>> 	select MDIO
>>> 	select CRC32
>>> +	select NET_DEVLINK
>>> 	help
>>> 	  This driver supports 10/40-gigabit Ethernet cards based on
>>> 	  the Solarflare SFC9100-family controllers.
>>> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
>>> index 712a48d00069..55b9c73cd8ef 100644
>>> --- a/drivers/net/ethernet/sfc/Makefile
>>> +++ b/drivers/net/ethernet/sfc/Makefile
>>> @@ -6,7 +6,8 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
>>> 			   mcdi.o mcdi_port.o mcdi_port_common.o \
>>> 			   mcdi_functions.o mcdi_filters.o mcdi_mon.o \
>>> 			   ef100.o ef100_nic.o ef100_netdev.o \
>>> -			   ef100_ethtool.o ef100_rx.o ef100_tx.o
>>> +			   ef100_ethtool.o ef100_rx.o ef100_tx.o \
>>> +			   efx_devlink.o
>>> sfc-$(CONFIG_SFC_MTD)	+= mtd.o
>>> sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>>>                             mae.o tc.o tc_bindings.o tc_counters.o
>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>>> index ad686c671ab8..14af8f314b83 100644
>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>>> @@ -27,6 +27,7 @@
>>> #include "tc.h"
>>> #include "mae.h"
>>> #include "rx_common.h"
>>> +#include "efx_devlink.h"
>>>
>>> #define EF100_MAX_VIS 4096
>>> #define EF100_NUM_MCDI_BUFFERS	1
>>> @@ -1124,6 +1125,10 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>>> 		netif_warn(efx, probe, net_dev,
>>> 			   "Failed to probe base mport rc %d; representors will not function\n",
>>> 			   rc);
>>> +	} else {
>>> +		if (efx_probe_devlink(efx))
>> I don't understand why the devlink register call is here.
>> 1) You can registers it for PF and VF. I don't follow why you do it only
>>     for PF.
>
>We discuss the possibility of creating the devlink interface for VFs, 
>but we decided not to. Arguably, this should not be available for VFs 
>owned by VMs/containers, or at least in our case, since the interface is 
>being used for getting information about the whole device or for 
>getting/setting the MAC address. We plan to support more devlink 
>functionalities in the near future, so maybe we add such support then if 
>we consider it is needed.

Okay.


>
>> 2) It should be done as the first thing in the probe flow. Then devlink
>>     port register, only after that netdev. It makes sense from the
>>     perspective of object hierarchy.
>
>I can not see a problem here. It is not the first thing done in the 
>probe function, but I can not see any dependency for being so. And it is 
>done before the devlink port registration and before the netdev 
>registration what seems to be what other drivers do. What am I missing 
>here?

Yep, currently, it does not matter for you, but when you implement
devlink reload for example, it will become a problem. Better to have it
done correctly from the beginning. Up to you.

Remember, what other drivers do does not mean it is a good practise :


>
>>
>>     It is also usual to have the devlink priv as the "main" driver
>>     structure storage, see how that is done in mlx5 of mlxsw for example.
>
>I will check the way others drivers use the devlink priv.
>
>>
>>
>>> +			netif_warn(efx, probe, net_dev,
>>> +				   "Failed to register devlink\n");
>>> 	}
>>>
>>> 	rc = efx_init_tc(efx);
>>> @@ -1157,6 +1162,7 @@ void ef100_remove(struct efx_nic *efx)
>>> {
>>> 	struct ef100_nic_data *nic_data = efx->nic_data;
>>>
>>> +	efx_fini_devlink(efx);
>>> 	efx_mcdi_detach(efx);
>>> 	efx_mcdi_fini(efx);
>>> 	if (nic_data)
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>>> new file mode 100644
>>> index 000000000000..c506f8f35d25
>>> --- /dev/null
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>>> @@ -0,0 +1,427 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/****************************************************************************
>>> + * Driver for AMD network controllers and boards
>>> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms of the GNU General Public License version 2 as published
>>> + * by the Free Software Foundation, incorporated herein by reference.
>>> + */
>>> +
>>> +#include <linux/rtc.h>
>>> +#include "net_driver.h"
>>> +#include "ef100_nic.h"
>>> +#include "efx_devlink.h"
>>> +#include "nic.h"
>>> +#include "mcdi.h"
>>> +#include "mcdi_functions.h"
>>> +#include "mcdi_pcol.h"
>>> +
>>> +/* Custom devlink-info version object names for details that do not map to the
>>> + * generic standardized names.
>>> + */
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC	"fw.mgmt.suc"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC	"fw.mgmt.cmc"
>>> +#define EFX_DEVLINK_INFO_VERSION_FPGA_REV	"fpga.rev"
>>> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_HW	"fpga.app"
>>> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_FW	DEVLINK_INFO_VERSION_GENERIC_FW_APP
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_BOOT	"coproc.boot"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_UBOOT	"coproc.uboot"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_MAIN	"coproc.main"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY	"coproc.recovery"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_EXPROM	"fw.exprom"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_UEFI	"fw.uefi"
>>> +
>>> +#define EFX_MAX_VERSION_INFO_LEN	64
>>> +
>>> +static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>>> +					    struct devlink_info_req *req,
>>> +					    unsigned int partition_type,
>>> +					    const char *version_name)
>>> +{
>>> +	char buf[EFX_MAX_VERSION_INFO_LEN];
>>> +	u16 version[4];
>>> +	int rc;
>>> +
>>> +	rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
>>> +				     0);
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u", version[0],
>>> +		 version[1], version[2], version[3]);
>>> +	devlink_info_version_stored_put(req, version_name, buf);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void efx_devlink_info_stored_versions(struct efx_nic *efx,
>>> +					     struct devlink_info_req *req)
>>> +{
>>> +	efx_devlink_info_nvram_partition(efx, req, NVRAM_PARTITION_TYPE_BUNDLE,
>>> +					 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
>>> +	efx_devlink_info_nvram_partition(efx, req,
>>> +					 NVRAM_PARTITION_TYPE_MC_FIRMWARE,
>>> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
>>> +	efx_devlink_info_nvram_partition(efx, req,
>>> +					 NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
>>> +					 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
>>> +	efx_devlink_info_nvram_partition(efx, req,
>>> +					 NVRAM_PARTITION_TYPE_EXPANSION_ROM,
>>> +					 EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
>>> +	efx_devlink_info_nvram_partition(efx, req,
>>> +					 NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
>>> +					 EFX_DEVLINK_INFO_VERSION_FW_UEFI);
>>> +}
>>> +
>>> +#define EFX_MAX_SERIALNUM_LEN	(ETH_ALEN * 2 + 1)
>>> +
>>> +static void efx_devlink_info_board_cfg(struct efx_nic *efx,
>>> +				       struct devlink_info_req *req)
>>> +{
>>> +	char sn[EFX_MAX_SERIALNUM_LEN];
>>> +	u8 mac_address[ETH_ALEN];
>>> +	int rc;
>>> +
>>> +	rc = efx_mcdi_get_board_cfg(efx, (u8 *)mac_address, NULL, NULL);
>>> +	if (!rc) {
>>> +		snprintf(sn, EFX_MAX_SERIALNUM_LEN, "%pm", mac_address);
>>> +		devlink_info_serial_number_put(req, sn);
>>> +	}
>>> +}
>>> +
>>> +#define EFX_VER_FLAG(_f)	\
>>> +	(MC_CMD_GET_VERSION_V5_OUT_ ## _f ## _PRESENT_LBN)
>>> +
>>> +static void efx_devlink_info_running_versions(struct efx_nic *efx,
>>> +					      struct devlink_info_req *req)
>>> +{
>>> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
>>> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
>>> +	char buf[EFX_MAX_VERSION_INFO_LEN];
>>> +	unsigned int flags, build_id;
>>> +	union {
>>> +		const __le32 *dwords;
>>> +		const __le16 *words;
>>> +		const char *str;
>>> +	} ver;
>>> +	struct rtc_time build_date;
>>> +	size_t outlength, offset;
>>> +	u64 tstamp;
>>> +	int rc;
>>> +
>>> +	rc = efx_mcdi_rpc(efx, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
>>> +			  outbuf, sizeof(outbuf), &outlength);
>>> +	if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN)
>>> +		return;
>>> +
>>> +	/* Handle previous output */
>>> +	if (outlength < MC_CMD_GET_VERSION_V2_OUT_LEN) {
>>> +		ver.words = (__le16 *)MCDI_PTR(outbuf,
>>> +					       GET_VERSION_EXT_OUT_VERSION);
>>> +		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +				  le16_to_cpu(ver.words[0]),
>>> +				  le16_to_cpu(ver.words[1]),
>>> +				  le16_to_cpu(ver.words[2]),
>>> +				  le16_to_cpu(ver.words[3]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
>>> +						 buf);
>>> +		return;
>>> +	}
>>> +
>>> +	/* Handle V2 additions */
>>> +	flags = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_FLAGS);
>>> +	if (flags & BIT(EFX_VER_FLAG(BOARD_EXT_INFO))) {
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%s",
>>> +			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_NAME));
>>> +		devlink_info_version_fixed_put(req,
>>> +					       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
>>> +					       buf);
>>> +
>>> +		/* Favour full board version if present (in V5 or later) */
>>> +		if (~flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
>>> +			snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u",
>>> +				 MCDI_DWORD(outbuf,
>>> +					    GET_VERSION_V2_OUT_BOARD_REVISION));
>>> +			devlink_info_version_fixed_put(req,
>>> +						       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
>>> +						       buf);
>>> +		}
>>> +
>>> +		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_SERIAL);
>>> +		if (ver.str[0])
>>> +			devlink_info_board_serial_number_put(req, ver.str);
>>> +	}
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(FPGA_EXT_INFO))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V2_OUT_FPGA_VERSION);
>>> +		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u_%c%u",
>>> +				  le32_to_cpu(ver.dwords[0]),
>>> +				  'A' + le32_to_cpu(ver.dwords[1]),
>>> +				  le32_to_cpu(ver.dwords[2]));
>>> +
>>> +		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_FPGA_EXTRA);
>>> +		if (ver.str[0])
>>> +			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
>>> +				 " (%s)", ver.str);
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_FPGA_REV,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(CMC_EXT_INFO))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V2_OUT_CMCFW_VERSION);
>>> +		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +				  le32_to_cpu(ver.dwords[0]),
>>> +				  le32_to_cpu(ver.dwords[1]),
>>> +				  le32_to_cpu(ver.dwords[2]),
>>> +				  le32_to_cpu(ver.dwords[3]));
>>> +
>>> +		tstamp = MCDI_QWORD(outbuf,
>>> +				    GET_VERSION_V2_OUT_CMCFW_BUILD_DATE);
>>> +		if (tstamp) {
>>> +			rtc_time64_to_tm(tstamp, &build_date);
>>> +			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
>>> +				 " (%ptRd)", &build_date);
>>> +		}
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC,
>>> +						 buf);
>>> +	}
>>> +
>>> +	ver.words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V2_OUT_VERSION);
>>> +	offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +			  le16_to_cpu(ver.words[0]), le16_to_cpu(ver.words[1]),
>>> +			  le16_to_cpu(ver.words[2]), le16_to_cpu(ver.words[3]));
>>> +	if (flags & BIT(EFX_VER_FLAG(MCFW_EXT_INFO))) {
>>> +		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_ID);
>>> +		snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
>>> +			 " (%x) %s", build_id,
>>> +			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_NAME));
>>> +	}
>>> +	devlink_info_version_running_put(req,
>>> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
>>> +					 buf);
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V2_OUT_SUCFW_VERSION);
>>> +		tstamp = MCDI_QWORD(outbuf,
>>> +				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
>>> +		rtc_time64_to_tm(tstamp, &build_date);
>>> +		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN,
>>> +			 "%u.%u.%u.%u type %x (%ptRd)",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]), le32_to_cpu(ver.dwords[3]),
>>> +			 build_id, &build_date);
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (outlength < MC_CMD_GET_VERSION_V3_OUT_LEN)
>>> +		return;
>>> +
>>> +	/* Handle V3 additions */
>>> +	if (flags & BIT(EFX_VER_FLAG(DATAPATH_HW_VERSION))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V3_OUT_DATAPATH_HW_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_DATAPATH_HW,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(DATAPATH_FW_VERSION))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V3_OUT_DATAPATH_FW_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_DATAPATH_FW,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (outlength < MC_CMD_GET_VERSION_V4_OUT_LEN)
>>> +		return;
>>> +
>>> +	/* Handle V4 additions */
>>> +	if (flags & BIT(EFX_VER_FLAG(SOC_BOOT_VERSION))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V4_OUT_SOC_BOOT_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]),
>>> +			 le32_to_cpu(ver.dwords[3]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_SOC_BOOT,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(SOC_UBOOT_VERSION))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V4_OUT_SOC_UBOOT_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]),
>>> +			 le32_to_cpu(ver.dwords[3]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_SOC_UBOOT,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(SOC_MAIN_ROOTFS_VERSION))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V4_OUT_SOC_MAIN_ROOTFS_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]),
>>> +			 le32_to_cpu(ver.dwords[3]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_SOC_MAIN,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(SOC_RECOVERY_BUILDROOT_VERSION))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V4_OUT_SOC_RECOVERY_BUILDROOT_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]),
>>> +			 le32_to_cpu(ver.dwords[3]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(SUCFW_VERSION)) &&
>>> +	    ~flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V4_OUT_SUCFW_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]),
>>> +			 le32_to_cpu(ver.dwords[3]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
>>> +		return;
>>> +
>>> +	/* Handle V5 additions */
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V5_OUT_BOARD_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]),
>>> +			 le32_to_cpu(ver.dwords[3]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
>>> +						 buf);
>>> +	}
>>> +
>>> +	if (flags & BIT(EFX_VER_FLAG(BUNDLE_VERSION))) {
>>> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> +						GET_VERSION_V5_OUT_BUNDLE_VERSION);
>>> +
>>> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> +			 le32_to_cpu(ver.dwords[2]),
>>> +			 le32_to_cpu(ver.dwords[3]));
>>> +
>>> +		devlink_info_version_running_put(req,
>>> +						 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID,
>>> +						 buf);
>>> +	}
>>> +}
>>> +
>>> +#undef EFX_VER_FLAG
>>> +
>>> +static void efx_devlink_info_query_all(struct efx_nic *efx,
>>> +				       struct devlink_info_req *req)
>>> +{
>>> +	efx_devlink_info_board_cfg(efx, req);
>>> +	efx_devlink_info_stored_versions(efx, req);
>>> +	efx_devlink_info_running_versions(efx, req);
>>> +}
>>> +
>>> +struct efx_devlink {
>>> +	struct efx_nic *efx;
>>> +};
>>> +
>>> +static int efx_devlink_info_get(struct devlink *devlink,
>>> +				struct devlink_info_req *req,
>>> +				struct netlink_ext_ack *extack)
>>> +{
>>> +	struct efx_devlink *devlink_private = devlink_priv(devlink);
>>> +	struct efx_nic *efx = devlink_private->efx;
>>> +
>>> +	efx_devlink_info_query_all(efx, req);
>> I don't understand the reason for having efx_devlink_info_query_all() as
>> a separate function in compare to inline its code here.
>>
>
>Yes, it could be do as you say. I'll do.
>
>Thanks
>
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct devlink_ops sfc_devlink_ops = {
>>> +	.info_get			= efx_devlink_info_get,
>>> +};
>>> +
>>> +void efx_fini_devlink(struct efx_nic *efx)
>>> +{
>>> +	if (efx->devlink) {
>>> +		struct efx_devlink *devlink_private;
>>> +
>>> +		devlink_private = devlink_priv(efx->devlink);
>>> +
>>> +		devlink_unregister(efx->devlink);
>>> +		devlink_free(efx->devlink);
>>> +		efx->devlink = NULL;
>>> +	}
>>> +}
>>> +
>>> +int efx_probe_devlink(struct efx_nic *efx)
>>> +{
>>> +	struct efx_devlink *devlink_private;
>>> +
>>> +	efx->devlink = devlink_alloc(&sfc_devlink_ops,
>>> +				     sizeof(struct efx_devlink),
>>> +				     &efx->pci_dev->dev);
>>> +	if (!efx->devlink)
>>> +		return -ENOMEM;
>>> +	devlink_private = devlink_priv(efx->devlink);
>>> +	devlink_private->efx = efx;
>>> +
>>> +	devlink_register(efx->devlink);
>>> +
>>> +	return 0;
>>> +}
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
>>> new file mode 100644
>>> index 000000000000..997f878aea93
>>> --- /dev/null
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
>>> @@ -0,0 +1,20 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/****************************************************************************
>>> + * Driver for AMD network controllers and boards
>>> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms of the GNU General Public License version 2 as published
>>> + * by the Free Software Foundation, incorporated herein by reference.
>>> + */
>>> +
>>> +#ifndef _EFX_DEVLINK_H
>>> +#define _EFX_DEVLINK_H
>>> +
>>> +#include "net_driver.h"
>>> +#include <net/devlink.h>
>>> +
>>> +int efx_probe_devlink(struct efx_nic *efx);
>>> +void efx_fini_devlink(struct efx_nic *efx);
>>> +
>>> +#endif	/* _EFX_DEVLINK_H */
>>> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
>>> index af338208eae9..328cae82a7d8 100644
>>> --- a/drivers/net/ethernet/sfc/mcdi.c
>>> +++ b/drivers/net/ethernet/sfc/mcdi.c
>>> @@ -2308,6 +2308,78 @@ static int efx_mcdi_nvram_update_finish(struct efx_nic *efx, unsigned int type)
>>> 	return rc;
>>> }
>>>
>>> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
>>> +			    u32 *subtype, u16 version[4], char *desc,
>>> +			    size_t descsize)
>>> +{
>>> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
>>> +	efx_dword_t *outbuf;
>>> +	size_t outlen;
>>> +	u32 flags;
>>> +	int rc;
>>> +
>>> +	outbuf = kzalloc(MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2, GFP_KERNEL);
>>> +	if (!outbuf)
>>> +		return -ENOMEM;
>>> +
>>> +	MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
>>> +
>>> +	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_NVRAM_METADATA, inbuf,
>>> +				sizeof(inbuf), outbuf,
>>> +				MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2,
>>> +				&outlen);
>>> +	if (rc)
>>> +		goto out_free;
>>> +	if (outlen < MC_CMD_NVRAM_METADATA_OUT_LENMIN) {
>>> +		rc = -EIO;
>>> +		goto out_free;
>>> +	}
>>> +
>>> +	flags = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_FLAGS);
>>> +
>>> +	if (desc && descsize > 0) {
>>> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN)) {
>>> +			if (descsize <=
>>> +			    MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)) {
>>> +				rc = -E2BIG;
>>> +				goto out_free;
>>> +			}
>>> +
>>> +			strncpy(desc,
>>> +				MCDI_PTR(outbuf, NVRAM_METADATA_OUT_DESCRIPTION),
>>> +				MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen));
>>> +			desc[MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)] = '\0';
>>> +		} else {
>>> +			desc[0] = '\0';
>>> +		}
>>> +	}
>>> +
>>> +	if (subtype) {
>>> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN))
>>> +			*subtype = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_SUBTYPE);
>>> +		else
>>> +			*subtype = 0;
>>> +	}
>>> +
>>> +	if (version) {
>>> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN)) {
>>> +			version[0] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_W);
>>> +			version[1] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_X);
>>> +			version[2] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Y);
>>> +			version[3] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Z);
>>> +		} else {
>>> +			version[0] = 0;
>>> +			version[1] = 0;
>>> +			version[2] = 0;
>>> +			version[3] = 0;
>>> +		}
>>> +	}
>>> +
>>> +out_free:
>>> +	kfree(outbuf);
>>> +	return rc;
>>> +}
>>> +
>>> int efx_mcdi_mtd_read(struct mtd_info *mtd, loff_t start,
>>> 		      size_t len, size_t *retlen, u8 *buffer)
>>> {
>>> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
>>> index 7e35fec9da35..63b090587f7a 100644
>>> --- a/drivers/net/ethernet/sfc/mcdi.h
>>> +++ b/drivers/net/ethernet/sfc/mcdi.h
>>> @@ -379,6 +379,9 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
>>> 			bool *protected_out);
>>> int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
>>> int efx_mcdi_nvram_test_all(struct efx_nic *efx);
>>> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
>>> +			    u32 *subtype, u16 version[4], char *desc,
>>> +			    size_t descsize);
>>> int efx_mcdi_handle_assertion(struct efx_nic *efx);
>>> int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
>>> int efx_mcdi_wol_filter_set_magic(struct efx_nic *efx, const u8 *mac,
>>> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>>> index 3b49e216768b..d036641dc043 100644
>>> --- a/drivers/net/ethernet/sfc/net_driver.h
>>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>>> @@ -994,6 +994,7 @@ enum efx_xdp_tx_queues_mode {
>>>   *      xdp_rxq_info structures?
>>>   * @netdev_notifier: Netdevice notifier.
>>>   * @tc: state for TC offload (EF100).
>>> + * @devlink: reference to devlink structure owned by this device
>>>   * @mem_bar: The BAR that is mapped into membase.
>>>   * @reg_base: Offset from the start of the bar to the function control window.
>>>   * @monitor_work: Hardware monitor workitem
>>> @@ -1179,6 +1180,7 @@ struct efx_nic {
>>> 	struct notifier_block netdev_notifier;
>>> 	struct efx_tc_state *tc;
>>>
>>> +	struct devlink *devlink;
>>> 	unsigned int mem_bar;
>>> 	u32 reg_base;
>>>
>>> -- 
>>> 2.17.1
>>>
>
