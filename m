Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADF16865AB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjBAMD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBAMDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:03:25 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBE619F3A
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:03:21 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id lu11so13417972ejb.3
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 04:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xZejuGD2cCI3lG/NTMotMi9ajlFXlE2yUTBQBel0Sjw=;
        b=5kJjQeHgxTNwLQ5jfKWTqUylPyfHSyHetZydV5dFpq6Xm2sfNag68YUAptNyIQ2JIt
         KJUGIQeX73skRL8BDm13+KFHjN5BgOJJqSnFfayVwAUo1YJV7A7sC9O3uadSWmG7pNtM
         5wBitRDKGNptS1dJtQh+SayJI5N5fSOrFagpdrgE1xyDzWMzwASLzI00b3/Fv99MD7Z6
         ZDwhZIvFmUN50vNRWZSJFl0QCbIvjajs0/EzvMHBhbzW3UyJT3Oj5rCkD8fx1/3YF07Q
         wW0LVQC7jo9xoFEpX03ovMVmsnS4hlJ8TDSbpcqJ6PiCsnRprY5SqidtuTnZHjAWgIXU
         Leew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZejuGD2cCI3lG/NTMotMi9ajlFXlE2yUTBQBel0Sjw=;
        b=kp83TTzEfx5EIYMQyJhx+FFgJmmJ26kh1bj4M0oIOeav6NI2JSF6rs88KV1anFnl3w
         +N/yUhtxNSrH7Qj8fqPUv8joOpfPG/QwYoKSXeIIl5Yw/ilB78orzWPUbcKKEXhjPCmz
         rBDyJWZ/Bn4UE782YQ28rsx0PkJiDc0dKgUcvJXatJuo2B736N4pIKO8rNslEjf4BVDh
         Z3V6ZCnOdNabAKRCQihZh0F0/S2/nmjy/HGTuMSFfCD9ehGV+y9tlmMainUNccM/+jtB
         QmvoNYZa6t17Fte9O8f1lM/bk285vG6eMcSgIr/W9rbOcQsHZiCRmCB7yYv3XB1finP5
         Iq6Q==
X-Gm-Message-State: AO0yUKWnUIWBlV4saXgcJdHakP/PFWpm3/G187wN9UMhHe77IwZNsnuZ
        c52FkiqUSrAC1u4+s2k2DxJp9g==
X-Google-Smtp-Source: AK7set8jRTOMmpLqXlb+MJkxa/zCmtaM1ukjVeK5KkZFRq0TkJ0FWFKtyHIByHQfrWxKWvuEpVLHcQ==
X-Received: by 2002:a17:906:fc13:b0:87f:d08:1064 with SMTP id ov19-20020a170906fc1300b0087f0d081064mr5620775ejb.6.1675252999971;
        Wed, 01 Feb 2023 04:03:19 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h13-20020a1709063b4d00b008787becf3a8sm9536187ejf.79.2023.02.01.04.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:03:19 -0800 (PST)
Date:   Wed, 1 Feb 2023 13:03:18 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v4 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <Y9pVBgSf8CCWdAFy@nanopsycho>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
 <20230131145822.36208-3-alejandro.lucero-palau@amd.com>
 <Y9k7z4zUlsSz7/sE@nanopsycho>
 <f7b80063-9bb5-6a29-2874-69168ced0d13@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7b80063-9bb5-6a29-2874-69168ced0d13@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 01, 2023 at 10:09:59AM CET, alejandro.lucero-palau@amd.com wrote:
>
>
>On 1/31/23 16:03, Jiri Pirko wrote:
>> Tue, Jan 31, 2023 at 03:58:16PM CET, alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com> wrote:
>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com>>
>>>
>>> Support for devlink info command.
>>>
>>> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com <mailto:alejandro.lucero-palau@amd.com>>
>>> ---
>>> Documentation/networking/devlink/sfc.rst | 57 ++++
>>> MAINTAINERS | 1 +
>>> drivers/net/ethernet/sfc/efx_devlink.c | 404 +++++++++++++++++++++++
>>> drivers/net/ethernet/sfc/efx_devlink.h | 17 +
>>> drivers/net/ethernet/sfc/mcdi.c | 72 ++++
>>> drivers/net/ethernet/sfc/mcdi.h | 3 +
>>> 6 files changed, 554 insertions(+)
>>> create mode 100644 Documentation/networking/devlink/sfc.rst
>>>
>>> diff --git a/Documentation/networking/devlink/sfc.rst b/Documentation/networking/devlink/sfc.rst
>>> new file mode 100644
>>> index 000000000000..e2541a2f18ee
>>> --- /dev/null
>>> +++ b/Documentation/networking/devlink/sfc.rst
>>> @@ -0,0 +1,57 @@
>>> +.. SPDX-License-Identifier: GPL-2.0
>>> +
>>> +===================
>>> +sfc devlink support
>>> +===================
>>> +
>>> +This document describes the devlink features implemented by the ``sfc``
>>> +device driver for the ef100 device.
>>> +
>>> +Info versions
>>> +=============
>>> +
>>> +The ``sfc`` driver reports the following versions
>>> +
>>> +.. list-table:: devlink info versions implemented
>>> + :widths: 5 5 90
>>> +
>>> + * - Name
>>> + - Type
>>> + - Description
>>> + * - ``fw.mgmt.suc``
>>> + - running
>>> + - For boards where the management function is split between multiple
>>> + control units, this is the SUC control unit's firmware version.
>>> + * - ``fw.mgmt.cmc``
>>> + - running
>>> + - For boards where the management function is split between multiple
>>> + control units, this is the CMC control unit's firmware version.
>>> + * - ``fpga.rev``
>>> + - running
>>> + - FPGA design revision.
>>> + * - ``fpga.app``
>>> + - running
>>> + - Datapath programmable logic version.
>>> + * - ``fw.app``
>>> + - running
>>> + - Datapath software/microcode/firmware version.
>>> + * - ``coproc.boot``
>>> + - running
>>> + - SmartNIC application co-processor (APU) first stage boot loader version.
>>> + * - ``coproc.uboot``
>>> + - running
>>> + - SmartNIC application co-processor (APU) co-operating system loader version.
>>> + * - ``coproc.main``
>>> + - running
>>> + - SmartNIC application co-processor (APU) main operating system version.
>>> + * - ``coproc.recovery``
>>> + - running
>>> + - SmartNIC application co-processor (APU) recovery operating system version.
>>> + * - ``fw.exprom``
>>> + - running
>>> + - Expansion ROM version. For boards where the expansion ROM is split between
>>> + multiple images (e.g. PXE and UEFI), this is the specifically the PXE boot
>>> + ROM version.
>>> + * - ``fw.uefi``
>>> + - running
>>> + - UEFI driver version (No UNDI support).
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index f82dd8d43c2b..57c9cb55cfd3 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -18920,6 +18920,7 @@ M: Martin Habets <habetsm.xilinx@gmail.com <mailto:habetsm.xilinx@gmail.com>>
>>> L: netdev@vger.kernel.org <mailto:netdev@vger.kernel.org>
>>> S: Supported
>>> F: drivers/net/ethernet/sfc/
>>> +F: Documentation/networking/devlink/sfc.rst
>>>
>>> SFF/SFP/SFP+ MODULE SUPPORT
>>> M: Russell King <linux@armlinux.org.uk <mailto:linux@armlinux.org.uk>>
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
>>> index fab06aaa4b8a..ff5adfe3905e 100644
>>> --- a/drivers/net/ethernet/sfc/efx_devlink.c
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
>>> @@ -21,7 +21,411 @@ struct efx_devlink {
>>> struct efx_nic *efx;
>>> };
>>>
>>> +static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>>> + struct devlink_info_req *req,
>>> + unsigned int partition_type,
>>> + const char *version_name)
>>> +{
>>> + char buf[EFX_MAX_VERSION_INFO_LEN];
>>> + u16 version[4];
>>> + int rc;
>>> +
>>> + rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
>>> + 0);
>>> + if (rc)
>>> + return rc;
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u", version[0],
>>> + version[1], version[2], version[3]);
>>> + devlink_info_version_stored_put(req, version_name, buf);
>>> +
>>> + return 0;
>>> +}
>>> +
>>> +static void efx_devlink_info_stored_versions(struct efx_nic *efx,
>>> + struct devlink_info_req *req)
>>> +{
>>> + efx_devlink_info_nvram_partition(efx, req, NVRAM_PARTITION_TYPE_BUNDLE,
>>> + DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
>>> + efx_devlink_info_nvram_partition(efx, req,
>>> + NVRAM_PARTITION_TYPE_MC_FIRMWARE,
>>> + DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
>>> + efx_devlink_info_nvram_partition(efx, req,
>>> + NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
>>> + EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
>>> + efx_devlink_info_nvram_partition(efx, req,
>>> + NVRAM_PARTITION_TYPE_EXPANSION_ROM,
>>> + EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
>>> + efx_devlink_info_nvram_partition(efx, req,
>>> + NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
>>> + EFX_DEVLINK_INFO_VERSION_FW_UEFI);
>>> +}
>>> +
>>> +#define EFX_VER_FLAG(_f) \
>>> + (MC_CMD_GET_VERSION_V5_OUT_ ## _f ## _PRESENT_LBN)
>>> +
>>> +static void efx_devlink_info_running_v2(struct efx_nic *efx,
>>> + struct devlink_info_req *req,
>>> + unsigned int flags, efx_dword_t *outbuf)
>>> +{
>>> + char buf[EFX_MAX_VERSION_INFO_LEN];
>>> + union {
>>> + const __le32 *dwords;
>>> + const __le16 *words;
>>> + const char *str;
>>> + } ver;
>>> + struct rtc_time build_date;
>>> + unsigned int build_id;
>>> + size_t offset;
>>> + u64 tstamp;
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(BOARD_EXT_INFO))) {
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%s",
>>> + MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_NAME));
>>> + devlink_info_version_fixed_put(req,
>>> + DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
>>> + buf);
>>> +
>>> + /* Favour full board version if present (in V5 or later) */
>>> + if (~flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u",
>>> + MCDI_DWORD(outbuf,
>>> + GET_VERSION_V2_OUT_BOARD_REVISION));
>>> + devlink_info_version_fixed_put(req,
>>> + DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
>>> + buf);
>>> + }
>>> +
>>> + ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_SERIAL);
>>> + if (ver.str[0])
>>> + devlink_info_board_serial_number_put(req, ver.str);
>>> + }
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(FPGA_EXT_INFO))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V2_OUT_FPGA_VERSION);
>>> + offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u_%c%u",
>>> + le32_to_cpu(ver.dwords[0]),
>>> + 'A' + le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]));
>>> +
>>> + ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_FPGA_EXTRA);
>>> + if (ver.str[0])
>>> + snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
>>> + " (%s)", ver.str);
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_FPGA_REV,
>>> + buf);
>>> + }
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(CMC_EXT_INFO))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V2_OUT_CMCFW_VERSION);
>>> + offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]),
>>> + le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]),
>>> + le32_to_cpu(ver.dwords[3]));
>>> +
>>> + tstamp = MCDI_QWORD(outbuf,
>>> + GET_VERSION_V2_OUT_CMCFW_BUILD_DATE);
>>> + if (tstamp) {
>>> + rtc_time64_to_tm(tstamp, &build_date);
>>> + snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
>>> + " (%ptRd)", &build_date);
>>> + }
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC,
>>> + buf);
>>> + }
>>> +
>>> + ver.words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V2_OUT_VERSION);
>>> + offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le16_to_cpu(ver.words[0]), le16_to_cpu(ver.words[1]),
>>> + le16_to_cpu(ver.words[2]), le16_to_cpu(ver.words[3]));
>>> + if (flags & BIT(EFX_VER_FLAG(MCFW_EXT_INFO))) {
>>> + build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_ID);
>>> + snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
>>> + " (%x) %s", build_id,
>>> + MCDI_PTR(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_NAME));
>>> + }
>>> + devlink_info_version_running_put(req,
>>> + DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
>>> + buf);
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V2_OUT_SUCFW_VERSION);
>>> + tstamp = MCDI_QWORD(outbuf,
>>> + GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
>>> + rtc_time64_to_tm(tstamp, &build_date);
>>> + build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN,
>>> + "%u.%u.%u.%u type %x (%ptRd)",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]), le32_to_cpu(ver.dwords[3]),
>>> + build_id, &build_date);
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
>>> + buf);
>>> + }
>>> +}
>>> +
>>> +static void efx_devlink_info_running_v3(struct efx_nic *efx,
>>> + struct devlink_info_req *req,
>>> + unsigned int flags, efx_dword_t *outbuf)
>>> +{
>>> + char buf[EFX_MAX_VERSION_INFO_LEN];
>>> + union {
>>> + const __le32 *dwords;
>>> + const __le16 *words;
>>> + const char *str;
>>> + } ver;
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(DATAPATH_HW_VERSION))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V3_OUT_DATAPATH_HW_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_DATAPATH_HW,
>>> + buf);
>>> + }
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(DATAPATH_FW_VERSION))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V3_OUT_DATAPATH_FW_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_DATAPATH_FW,
>>> + buf);
>>> + }
>>> +}
>>> +
>>> +static void efx_devlink_info_running_v4(struct efx_nic *efx,
>>> + struct devlink_info_req *req,
>>> + unsigned int flags, efx_dword_t *outbuf)
>>> +{
>>> + char buf[EFX_MAX_VERSION_INFO_LEN];
>>> + union {
>>> + const __le32 *dwords;
>>> + const __le16 *words;
>>> + const char *str;
>>> + } ver;
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(SOC_BOOT_VERSION))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V4_OUT_SOC_BOOT_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]),
>>> + le32_to_cpu(ver.dwords[3]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_SOC_BOOT,
>>> + buf);
>>> + }
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(SOC_UBOOT_VERSION))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V4_OUT_SOC_UBOOT_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]),
>>> + le32_to_cpu(ver.dwords[3]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_SOC_UBOOT,
>>> + buf);
>>> + }
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(SOC_MAIN_ROOTFS_VERSION))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V4_OUT_SOC_MAIN_ROOTFS_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]),
>>> + le32_to_cpu(ver.dwords[3]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_SOC_MAIN,
>>> + buf);
>>> + }
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(SOC_RECOVERY_BUILDROOT_VERSION))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V4_OUT_SOC_RECOVERY_BUILDROOT_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]),
>>> + le32_to_cpu(ver.dwords[3]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY,
>>> + buf);
>>> + }
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(SUCFW_VERSION)) &&
>>> + ~flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V4_OUT_SUCFW_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]),
>>> + le32_to_cpu(ver.dwords[3]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
>>> + buf);
>>> + }
>>> +}
>>> +
>>> +static void efx_devlink_info_running_v5(struct efx_nic *efx,
>>> + struct devlink_info_req *req,
>>> + unsigned int flags, efx_dword_t *outbuf)
>>> +{
>>> + char buf[EFX_MAX_VERSION_INFO_LEN];
>>> + union {
>>> + const __le32 *dwords;
>>> + const __le16 *words;
>>> + const char *str;
>>> + } ver;
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V5_OUT_BOARD_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]),
>>> + le32_to_cpu(ver.dwords[3]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
>>> + buf);
>>> + }
>>> +
>>> + if (flags & BIT(EFX_VER_FLAG(BUNDLE_VERSION))) {
>>> + ver.dwords = (__le32 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_V5_OUT_BUNDLE_VERSION);
>>> +
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
>>> + le32_to_cpu(ver.dwords[2]),
>>> + le32_to_cpu(ver.dwords[3]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID,
>>> + buf);
>>> + }
>>> +}
>>> +
>>> +static void efx_devlink_info_running_versions(struct efx_nic *efx,
>>> + struct devlink_info_req *req)
>>> +{
>>> + MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
>>> + MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
>>> + char buf[EFX_MAX_VERSION_INFO_LEN];
>>> + union {
>>> + const __le32 *dwords;
>>> + const __le16 *words;
>>> + const char *str;
>>> + } ver;
>>> + size_t outlength;
>>> + unsigned int flags;
>>> + int rc;
>>> +
>>> + rc = efx_mcdi_rpc(efx, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
>>> + outbuf, sizeof(outbuf), &outlength);
>>> + if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN)
>>> + return;
>>> +
>>> + /* Handle previous output */
>>> + if (outlength < MC_CMD_GET_VERSION_V2_OUT_LEN) {
>>> + ver.words = (__le16 *)MCDI_PTR(outbuf,
>>> + GET_VERSION_EXT_OUT_VERSION);
>>> + snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
>>> + le16_to_cpu(ver.words[0]),
>>> + le16_to_cpu(ver.words[1]),
>>> + le16_to_cpu(ver.words[2]),
>>> + le16_to_cpu(ver.words[3]));
>>> +
>>> + devlink_info_version_running_put(req,
>>> + DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
>>> + buf);
>>> + return;
>>> + }
>>> +
>>> + /* Handle V2 additions */
>>> + flags = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_FLAGS);
>>> + efx_devlink_info_running_v2(efx, req, flags, outbuf);
>>> +
>>> + if (outlength < MC_CMD_GET_VERSION_V3_OUT_LEN)
>>> + return;
>>> +
>>> + /* Handle V3 additions */
>>> + efx_devlink_info_running_v3(efx, req, flags, outbuf);
>>> +
>>> + if (outlength < MC_CMD_GET_VERSION_V4_OUT_LEN)
>>> + return;
>>> +
>>> + /* Handle V4 additions */
>>> + efx_devlink_info_running_v4(efx, req, flags, outbuf);
>>> +
>>> + if (outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
>>> + return;
>>> +
>>> + /* Handle V5 additions */
>>> + efx_devlink_info_running_v5(efx, req, flags, outbuf);
>>> +}
>>> +
>>> +#define EFX_MAX_SERIALNUM_LEN (ETH_ALEN * 2 + 1)
>>> +
>>> +static void efx_devlink_info_board_cfg(struct efx_nic *efx,
>>> + struct devlink_info_req *req)
>>> +{
>>> + char sn[EFX_MAX_SERIALNUM_LEN];
>>> + u8 mac_address[ETH_ALEN];
>>> + int rc;
>>> +
>>> + rc = efx_mcdi_get_board_cfg(efx, (u8 *)mac_address, NULL, NULL);
>>> + if (!rc) {
>>> + snprintf(sn, EFX_MAX_SERIALNUM_LEN, "%pm", mac_address);
>>> + devlink_info_serial_number_put(req, sn);
>>> + }
>>> +}
>>> +
>>> +static int efx_devlink_info_get(struct devlink *devlink,
>>> + struct devlink_info_req *req,
>>> + struct netlink_ext_ack *extack)
>>> +{
>>> + struct efx_devlink *devlink_private = devlink_priv(devlink);
>>> + struct efx_nic *efx = devlink_private->efx;
>>> +
>>> + efx_devlink_info_board_cfg(efx, req);
>>> + efx_devlink_info_stored_versions(efx, req);
>>> + efx_devlink_info_running_versions(efx, req);
>> I wonder, why don't you propagate error to the user? He may be
>> interested that you had troubles of getting some info, instead of silent
>> failure.
>
>That is true.
>
>If any of those functions fail the system messages will show the 
>problem, but I agree the user invoking this devlink function should 
>receive some feedback about it.

Don't forget to fillup extack message in case of error.


>
>I'll add it.
>
>Thanks
>
>>
>>> + return 0;
>>> +}
>>> +
>>> static const struct devlink_ops sfc_devlink_ops = {
>>> + .info_get = efx_devlink_info_get,
>>> };
>>>
>>> void efx_fini_devlink_start(struct efx_nic *efx)
>>> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
>>> index 55d0d8aeca1e..8bcd077d8d8d 100644
>>> --- a/drivers/net/ethernet/sfc/efx_devlink.h
>>> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
>>> @@ -14,6 +14,23 @@
>>> #include "net_driver.h"
>>> #include <net/devlink.h>
>>>
>>> +/* Custom devlink-info version object names for details that do not map to the
>>> + * generic standardized names.
>>> + */
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC "fw.mgmt.suc"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC "fw.mgmt.cmc"
>>> +#define EFX_DEVLINK_INFO_VERSION_FPGA_REV "fpga.rev"
>>> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_HW "fpga.app"
>>> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_FW DEVLINK_INFO_VERSION_GENERIC_FW_APP
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_BOOT "coproc.boot"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_UBOOT "coproc.uboot"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_MAIN "coproc.main"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY "coproc.recovery"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_EXPROM "fw.exprom"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_UEFI "fw.uefi"
>>> +
>>> +#define EFX_MAX_VERSION_INFO_LEN 64
>>> +
>>> int efx_probe_devlink(struct efx_nic *efx);
>>> void efx_probe_devlink_done(struct efx_nic *efx);
>>> void efx_fini_devlink_start(struct efx_nic *efx);
>>> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
>>> index af338208eae9..a7f2c31071e8 100644
>>> --- a/drivers/net/ethernet/sfc/mcdi.c
>>> +++ b/drivers/net/ethernet/sfc/mcdi.c
>>> @@ -2175,6 +2175,78 @@ int efx_mcdi_get_privilege_mask(struct efx_nic *efx, u32 *mask)
>>> return 0;
>>> }
>>>
>>> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
>>> + u32 *subtype, u16 version[4], char *desc,
>>> + size_t descsize)
>>> +{
>>> + MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
>>> + efx_dword_t *outbuf;
>>> + size_t outlen;
>>> + u32 flags;
>>> + int rc;
>>> +
>>> + outbuf = kzalloc(MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2, GFP_KERNEL);
>>> + if (!outbuf)
>>> + return -ENOMEM;
>>> +
>>> + MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
>>> +
>>> + rc = efx_mcdi_rpc_quiet(efx, MC_CMD_NVRAM_METADATA, inbuf,
>>> + sizeof(inbuf), outbuf,
>>> + MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2,
>>> + &outlen);
>>> + if (rc)
>>> + goto out_free;
>>> + if (outlen < MC_CMD_NVRAM_METADATA_OUT_LENMIN) {
>>> + rc = -EIO;
>>> + goto out_free;
>>> + }
>>> +
>>> + flags = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_FLAGS);
>>> +
>>> + if (desc && descsize > 0) {
>>> + if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN)) {
>>> + if (descsize <=
>>> + MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)) {
>>> + rc = -E2BIG;
>>> + goto out_free;
>>> + }
>>> +
>>> + strncpy(desc,
>>> + MCDI_PTR(outbuf, NVRAM_METADATA_OUT_DESCRIPTION),
>>> + MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen));
>>> + desc[MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)] = '\0';
>>> + } else {
>>> + desc[0] = '\0';
>>> + }
>>> + }
>>> +
>>> + if (subtype) {
>>> + if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN))
>>> + *subtype = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_SUBTYPE);
>>> + else
>>> + *subtype = 0;
>>> + }
>>> +
>>> + if (version) {
>>> + if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN)) {
>>> + version[0] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_W);
>>> + version[1] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_X);
>>> + version[2] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Y);
>>> + version[3] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Z);
>>> + } else {
>>> + version[0] = 0;
>>> + version[1] = 0;
>>> + version[2] = 0;
>>> + version[3] = 0;
>>> + }
>>> + }
>>> +
>>> +out_free:
>>> + kfree(outbuf);
>>> + return rc;
>>> +}
>>> +
>>> #ifdef CONFIG_SFC_MTD
>>>
>>> #define EFX_MCDI_NVRAM_LEN_MAX 128
>>> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
>>> index 7e35fec9da35..5cb202684858 100644
>>> --- a/drivers/net/ethernet/sfc/mcdi.h
>>> +++ b/drivers/net/ethernet/sfc/mcdi.h
>>> @@ -378,6 +378,9 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
>>> size_t *size_out, size_t *erase_size_out,
>>> bool *protected_out);
>>> int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
>>> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
>>> + u32 *subtype, u16 version[4], char *desc,
>>> + size_t descsize);
>>> int efx_mcdi_nvram_test_all(struct efx_nic *efx);
>>> int efx_mcdi_handle_assertion(struct efx_nic *efx);
>>> int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
>>> -- 
>>> 2.17.1
>>>
>
>
>
