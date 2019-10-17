Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B81DB74F
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503410AbfJQTQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:16:53 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42035 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731883AbfJQTQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:16:53 -0400
Received: by mail-lf1-f68.google.com with SMTP id z12so2770554lfj.9
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 12:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iRBQ4Yr6nxx0lKRlcnqEJX5UTc2N10GEwqP7LcTULdI=;
        b=HKiCWziTcaaiXa8b2ghl6LR8rkBcMLIMYJDyaeXJxORPttjWgIYE8MBKdoRTOWnCu8
         bDATf4ciMSKmqGbkMnr2ez+OjS0pdqljyKB5zqH7dOLBTtutQAGSnK3JfQvbRKR9eQSt
         lI8Wb5QaxLYSu2bs5Nx+b7YjZ+Gcny/vx9NqfPJvkdkEXGLwUf5zx8kaOKNv1nSNq3xW
         nxEMqDKq7POV816mjrq3GAT1ImWpVn6mToMIvSWkuqYJTmG6imTwvzEO/CJSpwwxNRHX
         aBpsfGU41+O8VwuGPpg88gr71VFk5yS8MhQyRaCzUDRh1VX//chGM9vDcE3QT4Gg0tZm
         evXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iRBQ4Yr6nxx0lKRlcnqEJX5UTc2N10GEwqP7LcTULdI=;
        b=g/0rFLzaVjMulZUnzEU7sRlgYVIgHuF2iKBTIOz+iymCfu5PCaRauH6q1n05r59ICE
         DstcRMfP3ug6Xr03puTTZJPTm5EukHY4YJ3Mp1Ahmt9hm6a1YvPvJAGG4LuasDgD4VVe
         0ZXcUJLQMoiuvyPKrlQAxoU9LnO8Qm9/IOY4Tcln9e7MDhw5hCRcY9G7/1/eAWFiSlBX
         sgwnOdu6XNtIDq90a09YfNlhvlWDl/B0+Ki1/ynzotN143ojMs2xJi8qQ8M26svAq+VQ
         Jk1vchqPwJo97LkDkbeh5RS6hk1cLbL2tXWiEXqIFc/ypEZioVI8xvt4vNOPAGN0r0mS
         +1CA==
X-Gm-Message-State: APjAAAU7m+s0SHvHXiz2P/EMUFlWExMGfFcLBrTC84mxEuZh+tLPrSg5
        wJWtJ9LomzcirKF+7PvEVbROIQ==
X-Google-Smtp-Source: APXvYqykIpYPaXMCo8Abm2AyciBg94pY00VayV1B5xCTd0MxG9+aWF2evVsbmqdFTncLXWZkT7KC7Q==
X-Received: by 2002:ac2:5542:: with SMTP id l2mr3357335lfk.119.1571339810683;
        Thu, 17 Oct 2019 12:16:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t135sm1557029lff.70.2019.10.17.12.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 12:16:50 -0700 (PDT)
Date:   Thu, 17 Oct 2019 12:16:40 -0700
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
Subject: Re: [PATCH V2 1/3] firmware: broadcom: add OP-TEE based BNXT f/w
 manager
Message-ID: <20191017121640.3a3436da@cakuba.netronome.com>
In-Reply-To: <1571313682-28900-2-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
        <1571313682-28900-2-git-send-email-sheetal.tigadoli@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 17:31:20 +0530, Sheetal Tigadoli wrote:
> From: Vikas Gupta <vikas.gupta@broadcom.com>
> 
> This driver registers on TEE bus to interact with OP-TEE based
> BNXT firmware management modules
> 
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
> ---
>  drivers/firmware/broadcom/Kconfig             |   8 +
>  drivers/firmware/broadcom/Makefile            |   1 +
>  drivers/firmware/broadcom/tee_bnxt_fw.c       | 283 ++++++++++++++++++++++++++
>  include/linux/firmware/broadcom/tee_bnxt_fw.h |  14 ++
>  4 files changed, 306 insertions(+)
>  create mode 100644 drivers/firmware/broadcom/tee_bnxt_fw.c
>  create mode 100644 include/linux/firmware/broadcom/tee_bnxt_fw.h
> 
> diff --git a/drivers/firmware/broadcom/Kconfig b/drivers/firmware/broadcom/Kconfig
> index d03ed8e..79505ad 100644
> --- a/drivers/firmware/broadcom/Kconfig
> +++ b/drivers/firmware/broadcom/Kconfig
> @@ -22,3 +22,11 @@ config BCM47XX_SPROM
>  	  In case of SoC devices SPROM content is stored on a flash used by
>  	  bootloader firmware CFE. This driver provides method to ssb and bcma
>  	  drivers to read SPROM on SoC.
> +
> +config TEE_BNXT_FW
> +	bool "Broadcom BNXT firmware manager"
> +	depends on (ARCH_BCM_IPROC && OPTEE) || COMPILE_TEST
> +	default ARCH_BCM_IPROC
> +	help
> +	  This module help to manage firmware on Broadcom BNXT device. The module
> +	  registers on tee bus and invoke calls to manage firmware on BNXT device.
> diff --git a/drivers/firmware/broadcom/Makefile b/drivers/firmware/broadcom/Makefile
> index 72c7fdc..17c5061 100644
> --- a/drivers/firmware/broadcom/Makefile
> +++ b/drivers/firmware/broadcom/Makefile
> @@ -1,3 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_BCM47XX_NVRAM)		+= bcm47xx_nvram.o
>  obj-$(CONFIG_BCM47XX_SPROM)		+= bcm47xx_sprom.o
> +obj-$(CONFIG_TEE_BNXT_FW)		+= tee_bnxt_fw.o
> diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
> new file mode 100644
> index 0000000..1e1e54c
> --- /dev/null
> +++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
> @@ -0,0 +1,283 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2019 Broadcom.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/tee_drv.h>
> +#include <linux/uuid.h>
> +
> +#include <linux/firmware/broadcom/tee_bnxt_fw.h>
> +
> +#define MAX_SHM_MEM_SZ	SZ_4M
> +
> +#define MAX_TEE_PARAM_ARRY_MEMB		4
> +
> +#define HANDLE_ERROR(ret, tee_ret, cmd)					\
> +do {									\
> +	if ((ret < 0) || (tee_ret != 0)) {				\

The parenthesis should be around macro parameters.

	if ((ret) < 0 || (tee_ret) != 0) {

|| has low priority

> +		dev_err(pvt_data.dev,					\
> +			#cmd " invoke failed TEE err: %x, ret:%x\n",	\
> +			tee_ret, ret);					\
> +		return -EINVAL;						\

macros shouldn't change control flow, return statements in macros are
bad

> +	}								\
> +} while (0)
> +
> +enum ta_cmd {
> +	/*
> +	 * TA_CMD_BNXT_FASTBOOT - boot bnxt device by copying f/w into sram
> +	 *
> +	 *	param[0] unused
> +	 *	param[1] unused
> +	 *	param[2] unused
> +	 *	param[3] unused
> +	 *
> +	 * Result:
> +	 *	TEE_SUCCESS - Invoke command success
> +	 *	TEE_ERROR_ITEM_NOT_FOUND - Corrupt f/w image found on memory
> +	 */
> +	TA_CMD_BNXT_FASTBOOT = 0,
> +
> +	/*
> +	 * TA_CMD_BNXT_COPY_COREDUMP - copy the core dump into shm
> +	 *
> +	 *	param[0] (in value) - value.a: offset, data to be copied from
> +	 *			      value.b: size of the data
> +	 *	param[1] unused
> +	 *	param[2] unused
> +	 *	param[3] unused
> +	 *
> +	 * Result:
> +	 *	TEE_SUCCESS - Invoke command success
> +	 *	TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> +	 *	TEE_ERROR_ITEM_NOT_FOUND - Corrupt core dump
> +	 */
> +	TA_CMD_BNXT_COPY_COREDUMP = 3,
> +};
> +
> +/**
> + * struct tee_bnxt_fw_private - OP-TEE bnxt private data
> + * @dev:		OP-TEE based bnxt device.
> + * @ctx:		OP-TEE context handler.
> + * @session_id:		TA session identifier.
> + */
> +struct tee_bnxt_fw_private {
> +	struct device *dev;
> +	struct tee_context *ctx;
> +	u32 session_id;
> +	struct tee_shm *fw_shm_pool;
> +};
> +
> +static struct tee_bnxt_fw_private pvt_data;
> +
> +static inline void prepare_args(int cmd,

No static inlines in .c files, please, the compiler will know what to
inline.

> +				struct tee_ioctl_invoke_arg *inv_arg,

inv usually means invalid, please rename to arg

> +				struct tee_param *param)
> +{
> +	memset(inv_arg, 0, sizeof(*inv_arg));
> +	memset(param, 0, (MAX_TEE_PARAM_ARRY_MEMB * sizeof(*param)));

array_size(), outer parens unnecessary

> +
> +	inv_arg->func = cmd;
> +	inv_arg->session = pvt_data.session_id;
> +	inv_arg->num_params = MAX_TEE_PARAM_ARRY_MEMB;
> +
> +	/* Fill invoke cmd params */
> +	switch (cmd) {
> +	case TA_CMD_BNXT_COPY_COREDUMP:
> +		param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
> +		param[0].u.memref.shm = pvt_data.fw_shm_pool;
> +		param[0].u.memref.size = MAX_SHM_MEM_SZ;
> +		param[0].u.memref.shm_offs = 0;
> +		param[1].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT;
> +		break;
> +	case TA_CMD_BNXT_FASTBOOT:
> +	default:
> +		/* Nothing to do */
> +		break;
> +	}
> +}
> +
> +/**
> + * tee_bnxt_fw_load() - Load the bnxt firmware
> + *		    Uses an OP-TEE call to start a secure
> + *		    boot process.
> + * Returns 0 on success, negative errno otherwise.
> + */
> +int tee_bnxt_fw_load(void)

This is a little strange. This function takes no parameters, so how
does this thing know where to load the firmware? Is it not possible 
to have two devices that'd both require FW?

> +{
> +	int ret = 0;
> +	struct tee_ioctl_invoke_arg inv_arg;
> +	struct tee_param param[MAX_TEE_PARAM_ARRY_MEMB];
> +
> +	if (!pvt_data.ctx)
> +		return -ENODEV;
> +
> +	prepare_args(TA_CMD_BNXT_FASTBOOT, &inv_arg, param);
> +
> +	ret = tee_client_invoke_func(pvt_data.ctx, &inv_arg, param);
> +	HANDLE_ERROR(ret, inv_arg.ret, TA_CMD_BNXT_FASTBOOT);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(tee_bnxt_fw_load);
> +
> +/**
> + * tee_bnxt_copy_coredump() - Copy coredump from the allocated memory
> + *			    Uses an OP-TEE call to copy coredump
> + * @buf:	desintation buffer where core dump is copied into
> + * @offset:	offset from the base address of core dump area
> + * @size:	size of the dump
> + *
> + * Returns 0 on success, negative errno otherwise.
> + */
> +int tee_bnxt_copy_coredump(void *buf, u32 offset, u32 size)
> +{
> +	struct tee_ioctl_invoke_arg inv_arg;
> +	struct tee_param param[MAX_TEE_PARAM_ARRY_MEMB];
> +	void *core_data;
> +	u32 rbytes = size;
> +	u32 nbytes = 0;
> +	int ret = 0;
> +
> +	if (!pvt_data.ctx)
> +		return -ENODEV;
> +
> +	if (!buf)
> +		return -EINVAL;

Generally we don't check args like that in the kernel, callers should
not be broken.

> +	prepare_args(TA_CMD_BNXT_COPY_COREDUMP, &inv_arg, param);
> +
> +	while (rbytes)  {
> +		nbytes = rbytes;
> +
> +		nbytes = min_t(u32, rbytes, param[0].u.memref.size);
> +
> +		/* Fill additional invoke cmd params */
> +		param[1].u.value.a = offset;
> +		param[1].u.value.b = nbytes;

But the doc above says param 1 is unused

> +		ret = tee_client_invoke_func(pvt_data.ctx, &inv_arg, param);
> +		HANDLE_ERROR(ret, inv_arg.ret, TA_CMD_BNXT_COPY_COREDUMP);
> +
> +		core_data = tee_shm_get_va(pvt_data.fw_shm_pool, 0);
> +		if (IS_ERR(core_data)) {
> +			dev_err(pvt_data.dev, "tee_shm_get_va failed\n");
> +			return PTR_ERR(core_data);
> +		}
> +
> +		memcpy(buf, core_data, nbytes);
> +
> +		rbytes -= nbytes;
> +		buf += nbytes;
> +		offset += nbytes;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(tee_bnxt_copy_coredump);
> +
> +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> +{
> +	if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> +		return 1;
> +	else
> +		return 0;

Also known as return ver->impl_id == TEE_IMPL_ID_OPTEE; ...

> +}
> +
> +static int tee_bnxt_fw_probe(struct device *dev)
> +{
> +	struct tee_client_device *bnxt_device = to_tee_client_device(dev);
> +	int ret, err = -ENODEV;
> +	struct tee_ioctl_open_session_arg sess_arg;
> +	struct tee_shm *fw_shm_pool;
> +
> +	memset(&sess_arg, 0, sizeof(sess_arg));
> +
> +	/* Open context with TEE driver */
> +	pvt_data.ctx = tee_client_open_context(NULL, optee_ctx_match, NULL,
> +					       NULL);
> +	if (IS_ERR(pvt_data.ctx))
> +		return -ENODEV;
> +
> +	/* Open session with Bnxt load Trusted App */
> +	memcpy(sess_arg.uuid, bnxt_device->id.uuid.b, TEE_IOCTL_UUID_LEN);
> +	sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> +	sess_arg.num_params = 0;
> +
> +	ret = tee_client_open_session(pvt_data.ctx, &sess_arg, NULL);
> +	if ((ret < 0) || (sess_arg.ret != 0)) {

parens unnecessary

> +		dev_err(dev, "tee_client_open_session failed, err: %x\n",
> +			sess_arg.ret);
> +		err = -EINVAL;
> +		goto out_ctx;
> +	}
> +	pvt_data.session_id = sess_arg.session;
> +
> +	pvt_data.dev = dev;
> +
> +	fw_shm_pool = tee_shm_alloc(pvt_data.ctx, MAX_SHM_MEM_SZ,
> +				    TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> +	if (IS_ERR(fw_shm_pool)) {
> +		tee_client_close_context(pvt_data.ctx);
> +		dev_err(pvt_data.dev, "tee_shm_alloc failed\n");
> +		err = PTR_ERR(fw_shm_pool);
> +		goto out_sess;
> +	}
> +
> +	pvt_data.fw_shm_pool = fw_shm_pool;
> +
> +	return 0;
> +
> +out_sess:
> +	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
> +out_ctx:
> +	tee_client_close_context(pvt_data.ctx);
> +
> +	return err;
> +}
> +
> +static int tee_bnxt_fw_remove(struct device *dev)
> +{
> +	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
> +	tee_client_close_context(pvt_data.ctx);
> +	pvt_data.ctx = NULL;
> +
> +	return 0;
> +}
> +
> +static const struct tee_client_device_id tee_bnxt_fw_id_table[] = {
> +	{UUID_INIT(0x6272636D, 0x2019, 0x0716,
> +		    0x42, 0x43, 0x4D, 0x5F, 0x53, 0x43, 0x48, 0x49)},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(tee, tee_bnxt_fw_id_table);
> +
> +static struct tee_client_driver tee_bnxt_fw_driver = {
> +	.id_table	= tee_bnxt_fw_id_table,
> +	.driver		= {
> +		.name		= KBUILD_MODNAME,
> +		.bus		= &tee_bus_type,
> +		.probe		= tee_bnxt_fw_probe,
> +		.remove		= tee_bnxt_fw_remove,
> +	},
> +};
> +
> +static int __init tee_bnxt_fw_mod_init(void)
> +{
> +	return driver_register(&tee_bnxt_fw_driver.driver);
> +}
> +
> +static void __exit tee_bnxt_fw_mod_exit(void)
> +{
> +	driver_unregister(&tee_bnxt_fw_driver.driver);
> +}
> +
> +module_init(tee_bnxt_fw_mod_init);
> +module_exit(tee_bnxt_fw_mod_exit);

Someone should add a module_tee_driver macro, perhaps?

> +MODULE_AUTHOR("Broadcom");

I think you can forego the author macro is it's a company.

> +MODULE_DESCRIPTION("Broadcom bnxt firmware manager");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/firmware/broadcom/tee_bnxt_fw.h b/include/linux/firmware/broadcom/tee_bnxt_fw.h
> new file mode 100644
> index 0000000..f24c82d
> --- /dev/null
> +++ b/include/linux/firmware/broadcom/tee_bnxt_fw.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: BSD-2-Clause */
> +/*
> + * Copyright 2019 Broadcom.
> + */
> +
> +#ifndef _BROADCOM_TEE_BNXT_FW_H
> +#define _BROADCOM_TEE_BNXT_FW_H
> +
> +#include <linux/types.h>
> +
> +int tee_bnxt_fw_load(void);
> +int tee_bnxt_copy_coredump(void *buf, u32 offset, u32 size);
> +
> +#endif /* _BROADCOM_TEE_BNXT_FW_H */

