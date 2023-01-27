Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEE667E339
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 12:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbjA0L1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 06:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbjA0L1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 06:27:37 -0500
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF8B42DCA
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:26:14 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id fl11-20020a05600c0b8b00b003daf72fc844so5198333wmb.0
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G9MTrzGBfDiuhKj+t6VjWnEJV6kfvMcUTaz092cpzQw=;
        b=J3x/HNeTTpywIGBjHit4+qc5dSiCYPA2G1tAQm0RPXO+pbg10CeV/4uSWG1RvLrSXS
         dSe2DbfvssnAH1i/bigSJUoYQzDeMphhFiqf9WroRF9XEWqKYTBP7waBBq9yFesOWl1N
         FDr//5BwtB0vzGv8CFDpfcBJOPgLfZ9J04krJTzkOD1yZNmw9PZUhjt3iFr+4AfePCdj
         zUG5SJPYiSvk/7QtJK3wLWJZx94M8mIx9xzwvU9DgckoA72EJWSDhy0u0eGNYpfLhG6h
         IjbqEkEteD+8oGbsxHvHmlSD+iFVTl/KuN03f73zB6J+QLo7tGl19QabTAFjv4nrrmEm
         3ORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9MTrzGBfDiuhKj+t6VjWnEJV6kfvMcUTaz092cpzQw=;
        b=mVtJegvGVrTamvokbzasrMCM063/mv+HlFUVeRDDXcxqLnvAlgLgMThAmBHeLSrVky
         D4iS0uUHaHdLuLkQcAlOEMdPJH+xFXRcUFYozHc+pFAoiADIiezVWzPy52pyrONzs/v9
         T1y6Aem4liC0bBcP4d4I/nbRnWwOWGWKoEfACKXVZCsz/Yf/xm1nZR5/KkFd0g7LbWcd
         j4VhMvwtNr15z9KAvg0MeGClf/mPIrywR2iMt/58Sej/ldjXhGmiKIbD+5UG4Xmh9HJv
         CB7+4knriH9KRHM2gXrE1AV0OnVOAJK+rU4boIuzfrvNYUttGiItE28K6HLv0u76uqb/
         QUGA==
X-Gm-Message-State: AFqh2koZThtio+ZEzb5k71DKv2moYRuIOZ1I2ZLTnyrsusw9to4r1EJY
        nf5A7rDIRTbZavuYx3D/335NmRApu3g=
X-Google-Smtp-Source: AMrXdXt54tJVR9i3mB0m0F9JjbglPt+k3haMLetn+xhx33p3EpG/NlXy1hb9Ihql1KsJDGHJS6yWhg==
X-Received: by 2002:a05:600c:5409:b0:3da:f66a:e866 with SMTP id he9-20020a05600c540900b003daf66ae866mr39354375wmb.10.1674818431666;
        Fri, 27 Jan 2023 03:20:31 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id v6-20020a05600c444600b003db09692364sm8295180wmn.11.2023.01.27.03.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 03:20:31 -0800 (PST)
Date:   Fri, 27 Jan 2023 11:20:28 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH v3 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <Y9OzfKzbuSDAD12v@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com
References: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
 <20230127093651.54035-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127093651.54035-3-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 09:36:45AM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Support for devlink info command.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
>  Documentation/networking/devlink/sfc.rst |  57 ++++
>  drivers/net/ethernet/sfc/efx_devlink.c   | 404 +++++++++++++++++++++++
>  drivers/net/ethernet/sfc/efx_devlink.h   |  17 +
>  drivers/net/ethernet/sfc/mcdi.c          |  72 ++++
>  drivers/net/ethernet/sfc/mcdi.h          |   3 +
>  5 files changed, 553 insertions(+)
>  create mode 100644 Documentation/networking/devlink/sfc.rst
> 
> diff --git a/Documentation/networking/devlink/sfc.rst b/Documentation/networking/devlink/sfc.rst
> new file mode 100644
> index 000000000000..e2541a2f18ee
> --- /dev/null
> +++ b/Documentation/networking/devlink/sfc.rst

Update the MAINTAINERS file to add our support for this new file.

> @@ -0,0 +1,57 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===================
> +sfc devlink support
> +===================
> +
> +This document describes the devlink features implemented by the ``sfc``
> +device driver for the ef100 device.
> +
> +Info versions
> +=============
> +
> +The ``sfc`` driver reports the following versions
> +
> +.. list-table:: devlink info versions implemented
> +    :widths: 5 5 90
> +
> +   * - Name
> +     - Type
> +     - Description
> +   * - ``fw.mgmt.suc``
> +     - running
> +     - For boards where the management function is split between multiple
> +       control units, this is the SUC control unit's firmware version.
> +   * - ``fw.mgmt.cmc``
> +     - running
> +     - For boards where the management function is split between multiple
> +       control units, this is the CMC control unit's firmware version.
> +   * - ``fpga.rev``
> +     - running
> +     - FPGA design revision.
> +   * - ``fpga.app``
> +     - running
> +     - Datapath programmable logic version.
> +   * - ``fw.app``
> +     - running
> +     - Datapath software/microcode/firmware version.
> +   * - ``coproc.boot``
> +     - running
> +     - SmartNIC application co-processor (APU) first stage boot loader version.
> +   * - ``coproc.uboot``
> +     - running
> +     - SmartNIC application co-processor (APU) co-operating system loader version.
> +   * - ``coproc.main``
> +     - running
> +     - SmartNIC application co-processor (APU) main operating system version.
> +   * - ``coproc.recovery``
> +     - running
> +     - SmartNIC application co-processor (APU) recovery operating system version.
> +   * - ``fw.exprom``
> +     - running
> +     - Expansion ROM version. For boards where the expansion ROM is split between
> +       multiple images (e.g. PXE and UEFI), this is the specifically the PXE boot
> +       ROM version.
> +   * - ``fw.uefi``
> +     - running
> +     - UEFI driver version (No UNDI support).
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index fab06aaa4b8a..ff5adfe3905e 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -21,7 +21,411 @@ struct efx_devlink {
>  	struct efx_nic *efx;
>  };
>  
> +static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
> +					    struct devlink_info_req *req,
> +					    unsigned int partition_type,
> +					    const char *version_name)
> +{
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	u16 version[4];
> +	int rc;
> +
> +	rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
> +				     0);
> +	if (rc)
> +		return rc;
> +
> +	snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u", version[0],
> +		 version[1], version[2], version[3]);
> +	devlink_info_version_stored_put(req, version_name, buf);
> +
> +	return 0;
> +}
> +
> +static void efx_devlink_info_stored_versions(struct efx_nic *efx,
> +					     struct devlink_info_req *req)
> +{
> +	efx_devlink_info_nvram_partition(efx, req, NVRAM_PARTITION_TYPE_BUNDLE,
> +					 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
> +	efx_devlink_info_nvram_partition(efx, req,
> +					 NVRAM_PARTITION_TYPE_MC_FIRMWARE,
> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
> +	efx_devlink_info_nvram_partition(efx, req,
> +					 NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
> +					 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
> +	efx_devlink_info_nvram_partition(efx, req,
> +					 NVRAM_PARTITION_TYPE_EXPANSION_ROM,
> +					 EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
> +	efx_devlink_info_nvram_partition(efx, req,
> +					 NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
> +					 EFX_DEVLINK_INFO_VERSION_FW_UEFI);
> +}
> +
> +#define EFX_VER_FLAG(_f)	\
> +	(MC_CMD_GET_VERSION_V5_OUT_ ## _f ## _PRESENT_LBN)
> +
> +static void efx_devlink_info_running_v2(struct efx_nic *efx,
> +					struct devlink_info_req *req,
> +					unsigned int flags, efx_dword_t *outbuf)
> +{
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	union {
> +		const __le32 *dwords;
> +		const __le16 *words;
> +		const char *str;
> +	} ver;
> +	struct rtc_time build_date;
> +	unsigned int build_id;
> +	size_t offset;
> +	u64 tstamp;
> +
> +	if (flags & BIT(EFX_VER_FLAG(BOARD_EXT_INFO))) {
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%s",
> +			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_NAME));
> +		devlink_info_version_fixed_put(req,
> +					       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
> +					       buf);
> +
> +		/* Favour full board version if present (in V5 or later) */
> +		if (~flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
> +			snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u",
> +				 MCDI_DWORD(outbuf,
> +					    GET_VERSION_V2_OUT_BOARD_REVISION));
> +			devlink_info_version_fixed_put(req,
> +						       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
> +						       buf);
> +		}
> +
> +		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_SERIAL);
> +		if (ver.str[0])
> +			devlink_info_board_serial_number_put(req, ver.str);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(FPGA_EXT_INFO))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V2_OUT_FPGA_VERSION);
> +		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u_%c%u",
> +				  le32_to_cpu(ver.dwords[0]),
> +				  'A' + le32_to_cpu(ver.dwords[1]),
> +				  le32_to_cpu(ver.dwords[2]));
> +
> +		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_FPGA_EXTRA);
> +		if (ver.str[0])
> +			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
> +				 " (%s)", ver.str);
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_FPGA_REV,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(CMC_EXT_INFO))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V2_OUT_CMCFW_VERSION);
> +		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +				  le32_to_cpu(ver.dwords[0]),
> +				  le32_to_cpu(ver.dwords[1]),
> +				  le32_to_cpu(ver.dwords[2]),
> +				  le32_to_cpu(ver.dwords[3]));
> +
> +		tstamp = MCDI_QWORD(outbuf,
> +				    GET_VERSION_V2_OUT_CMCFW_BUILD_DATE);
> +		if (tstamp) {
> +			rtc_time64_to_tm(tstamp, &build_date);
> +			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
> +				 " (%ptRd)", &build_date);
> +		}
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC,
> +						 buf);
> +	}
> +
> +	ver.words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V2_OUT_VERSION);
> +	offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			  le16_to_cpu(ver.words[0]), le16_to_cpu(ver.words[1]),
> +			  le16_to_cpu(ver.words[2]), le16_to_cpu(ver.words[3]));
> +	if (flags & BIT(EFX_VER_FLAG(MCFW_EXT_INFO))) {
> +		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_ID);
> +		snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
> +			 " (%x) %s", build_id,
> +			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_NAME));
> +	}
> +	devlink_info_version_running_put(req,
> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
> +					 buf);
> +
> +	if (flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V2_OUT_SUCFW_VERSION);
> +		tstamp = MCDI_QWORD(outbuf,
> +				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
> +		rtc_time64_to_tm(tstamp, &build_date);
> +		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN,
> +			 "%u.%u.%u.%u type %x (%ptRd)",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]), le32_to_cpu(ver.dwords[3]),
> +			 build_id, &build_date);
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
> +						 buf);
> +	}
> +}
> +
> +static void efx_devlink_info_running_v3(struct efx_nic *efx,
> +					struct devlink_info_req *req,
> +					unsigned int flags, efx_dword_t *outbuf)
> +{
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	union {
> +		const __le32 *dwords;
> +		const __le16 *words;
> +		const char *str;
> +	} ver;
> +
> +	if (flags & BIT(EFX_VER_FLAG(DATAPATH_HW_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V3_OUT_DATAPATH_HW_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_DATAPATH_HW,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(DATAPATH_FW_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V3_OUT_DATAPATH_FW_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_DATAPATH_FW,
> +						 buf);
> +	}
> +}
> +
> +static void efx_devlink_info_running_v4(struct efx_nic *efx,
> +					struct devlink_info_req *req,
> +					unsigned int flags, efx_dword_t *outbuf)
> +{
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	union {
> +		const __le32 *dwords;
> +		const __le16 *words;
> +		const char *str;
> +	} ver;
> +
> +	if (flags & BIT(EFX_VER_FLAG(SOC_BOOT_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SOC_BOOT_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_SOC_BOOT,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(SOC_UBOOT_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SOC_UBOOT_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_SOC_UBOOT,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(SOC_MAIN_ROOTFS_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +					GET_VERSION_V4_OUT_SOC_MAIN_ROOTFS_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_SOC_MAIN,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(SOC_RECOVERY_BUILDROOT_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SOC_RECOVERY_BUILDROOT_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(SUCFW_VERSION)) &&
> +	    ~flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SUCFW_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
> +						 buf);
> +	}
> +}
> +
> +static void efx_devlink_info_running_v5(struct efx_nic *efx,
> +					struct devlink_info_req *req,
> +					unsigned int flags, efx_dword_t *outbuf)
> +{
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	union {
> +		const __le32 *dwords;
> +		const __le16 *words;
> +		const char *str;
> +	} ver;
> +
> +	if (flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V5_OUT_BOARD_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(BUNDLE_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V5_OUT_BUNDLE_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID,
> +						 buf);
> +	}
> +}
> +
> +static void efx_devlink_info_running_versions(struct efx_nic *efx,
> +					      struct devlink_info_req *req)
> +{
> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	union {
> +		const __le32 *dwords;
> +		const __le16 *words;
> +		const char *str;
> +	} ver;
> +	size_t outlength;
> +	unsigned int flags;
> +	int rc;
> +
> +	rc = efx_mcdi_rpc(efx, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
> +			  outbuf, sizeof(outbuf), &outlength);
> +	if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN)
> +		return;
> +
> +	/* Handle previous output */
> +	if (outlength < MC_CMD_GET_VERSION_V2_OUT_LEN) {
> +		ver.words = (__le16 *)MCDI_PTR(outbuf,
> +					       GET_VERSION_EXT_OUT_VERSION);
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le16_to_cpu(ver.words[0]),
> +			 le16_to_cpu(ver.words[1]),
> +			 le16_to_cpu(ver.words[2]),
> +			 le16_to_cpu(ver.words[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
> +						 buf);
> +		return;
> +	}
> +
> +	/* Handle V2 additions */
> +	flags = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_FLAGS);
> +	efx_devlink_info_running_v2(efx, req, flags, outbuf);
> +
> +	if (outlength < MC_CMD_GET_VERSION_V3_OUT_LEN)
> +		return;
> +
> +	/* Handle V3 additions */
> +	efx_devlink_info_running_v3(efx, req, flags, outbuf);
> +
> +	if (outlength < MC_CMD_GET_VERSION_V4_OUT_LEN)
> +		return;
> +
> +	/* Handle V4 additions */
> +	efx_devlink_info_running_v4(efx, req, flags, outbuf);
> +
> +	if (outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
> +		return;
> +
> +	/* Handle V5 additions */
> +	efx_devlink_info_running_v5(efx, req, flags, outbuf);
> +}
> +
> +#define EFX_MAX_SERIALNUM_LEN	(ETH_ALEN * 2 + 1)
> +
> +static void efx_devlink_info_board_cfg(struct efx_nic *efx,
> +				       struct devlink_info_req *req)
> +{
> +	char sn[EFX_MAX_SERIALNUM_LEN];
> +	u8 mac_address[ETH_ALEN];
> +	int rc;
> +
> +	rc = efx_mcdi_get_board_cfg(efx, (u8 *)mac_address, NULL, NULL);
> +	if (!rc) {
> +		snprintf(sn, EFX_MAX_SERIALNUM_LEN, "%pm", mac_address);
> +		devlink_info_serial_number_put(req, sn);
> +	}
> +}
> +
> +static int efx_devlink_info_get(struct devlink *devlink,
> +				struct devlink_info_req *req,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct efx_devlink *devlink_private = devlink_priv(devlink);
> +	struct efx_nic *efx = devlink_private->efx;
> +
> +	efx_devlink_info_board_cfg(efx, req);
> +	efx_devlink_info_stored_versions(efx, req);
> +	efx_devlink_info_running_versions(efx, req);
> +	return 0;
> +}
> +
>  static const struct devlink_ops sfc_devlink_ops = {
> +	.info_get			= efx_devlink_info_get,
>  };
>  
>  void efx_fini_devlink_start(struct efx_nic *efx)
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
> index 55d0d8aeca1e..8bcd077d8d8d 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.h
> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
> @@ -14,6 +14,23 @@
>  #include "net_driver.h"
>  #include <net/devlink.h>
>  
> +/* Custom devlink-info version object names for details that do not map to the
> + * generic standardized names.
> + */
> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC	"fw.mgmt.suc"
> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC	"fw.mgmt.cmc"
> +#define EFX_DEVLINK_INFO_VERSION_FPGA_REV	"fpga.rev"
> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_HW	"fpga.app"
> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_FW	DEVLINK_INFO_VERSION_GENERIC_FW_APP
> +#define EFX_DEVLINK_INFO_VERSION_SOC_BOOT	"coproc.boot"
> +#define EFX_DEVLINK_INFO_VERSION_SOC_UBOOT	"coproc.uboot"
> +#define EFX_DEVLINK_INFO_VERSION_SOC_MAIN	"coproc.main"
> +#define EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY	"coproc.recovery"
> +#define EFX_DEVLINK_INFO_VERSION_FW_EXPROM	"fw.exprom"
> +#define EFX_DEVLINK_INFO_VERSION_FW_UEFI	"fw.uefi"
> +
> +#define EFX_MAX_VERSION_INFO_LEN	64
> +
>  int efx_probe_devlink(struct efx_nic *efx);
>  void efx_probe_devlink_done(struct efx_nic *efx);
>  void efx_fini_devlink_start(struct efx_nic *efx);
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> index af338208eae9..328cae82a7d8 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -2308,6 +2308,78 @@ static int efx_mcdi_nvram_update_finish(struct efx_nic *efx, unsigned int type)
>  	return rc;
>  }
>  
> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
> +			    u32 *subtype, u16 version[4], char *desc,
> +			    size_t descsize)

This is inside an #ifdef CONFIG_SFC_MTD
which is why the kernel test robot is reporting the modpost
errors.
Move it outside of that ifdef.

Martin

> +{
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
> +	efx_dword_t *outbuf;
> +	size_t outlen;
> +	u32 flags;
> +	int rc;
> +
> +	outbuf = kzalloc(MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2, GFP_KERNEL);
> +	if (!outbuf)
> +		return -ENOMEM;
> +
> +	MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
> +
> +	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_NVRAM_METADATA, inbuf,
> +				sizeof(inbuf), outbuf,
> +				MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2,
> +				&outlen);
> +	if (rc)
> +		goto out_free;
> +	if (outlen < MC_CMD_NVRAM_METADATA_OUT_LENMIN) {
> +		rc = -EIO;
> +		goto out_free;
> +	}
> +
> +	flags = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_FLAGS);
> +
> +	if (desc && descsize > 0) {
> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN)) {
> +			if (descsize <=
> +			    MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)) {
> +				rc = -E2BIG;
> +				goto out_free;
> +			}
> +
> +			strncpy(desc,
> +				MCDI_PTR(outbuf, NVRAM_METADATA_OUT_DESCRIPTION),
> +				MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen));
> +			desc[MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)] = '\0';
> +		} else {
> +			desc[0] = '\0';
> +		}
> +	}
> +
> +	if (subtype) {
> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN))
> +			*subtype = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_SUBTYPE);
> +		else
> +			*subtype = 0;
> +	}
> +
> +	if (version) {
> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN)) {
> +			version[0] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_W);
> +			version[1] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_X);
> +			version[2] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Y);
> +			version[3] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Z);
> +		} else {
> +			version[0] = 0;
> +			version[1] = 0;
> +			version[2] = 0;
> +			version[3] = 0;
> +		}
> +	}
> +
> +out_free:
> +	kfree(outbuf);
> +	return rc;
> +}
> +
>  int efx_mcdi_mtd_read(struct mtd_info *mtd, loff_t start,
>  		      size_t len, size_t *retlen, u8 *buffer)
>  {
> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> index 7e35fec9da35..5cb202684858 100644
> --- a/drivers/net/ethernet/sfc/mcdi.h
> +++ b/drivers/net/ethernet/sfc/mcdi.h
> @@ -378,6 +378,9 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
>  			size_t *size_out, size_t *erase_size_out,
>  			bool *protected_out);
>  int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
> +			    u32 *subtype, u16 version[4], char *desc,
> +			    size_t descsize);
>  int efx_mcdi_nvram_test_all(struct efx_nic *efx);
>  int efx_mcdi_handle_assertion(struct efx_nic *efx);
>  int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
> -- 
> 2.17.1
