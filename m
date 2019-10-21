Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01657DE770
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 11:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfJUJJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 05:09:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42214 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfJUJJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 05:09:30 -0400
Received: by mail-qk1-f196.google.com with SMTP id f16so11837642qkl.9
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 02:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=guXRRoZLi7jDyATnz1qUsi0KITTgal2IWEFqGAsLHnQ=;
        b=Gojpe3osML3zGxMsS3sQhYyuaKqUFMMw7lQy4+XYpI27VRx998GolicAdSkir8lLRa
         weTDhP0pxgJLwxIzUjjyibIbuJkJTyUQ8+WG8KPsmRAVrar/8pysd8THcSw+CHJWFsKO
         KyAi5e0VpoYI1OetcMswIAXYBQPRFMgMsg8AM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=guXRRoZLi7jDyATnz1qUsi0KITTgal2IWEFqGAsLHnQ=;
        b=D4CoIU3/QKTYuE7zKVIaI0ortyVtQZAHrrQIAAjGuRB9uHJh7AmOdSiZw4h+npg4Bh
         kFrH9Ye5BONZjfGPo8V96GHTCdjV4vLb8EHur94cO09ebFg+arxhZuyf/SdGNUyqCLXe
         FNCRi99OHUjp8Y9g+bUZw9tDQPHuhNHaw7YReVgvdHRze00pAEW1xJJJGpQReod6Wes2
         GjuQdotlWeLN1/KENfcOQZ2oI6XtU883WKDZeYT2WDycM9EF94073MhpmYMKeb0dIUm8
         gQLgDQ4hASZiFxhy4Udok2Hu7Nc7vSGrstr07Dlz4uyhDU6mJ0vHulnNSrqN/aG7sYnS
         BHOw==
X-Gm-Message-State: APjAAAVTW81/h5hqzofnPN7d3q1g4gAZCDEeELjoAEHD3E8MOrIbMwDv
        VW+myPrAY9b0xQrk5j0roBEuiAnOtteTyYN36g7kvA==
X-Google-Smtp-Source: APXvYqyoPdgcDPMlKznf08MKHuqYsGx9XSMKrebx4zksukPQijF4grIMZZfpqOwIwCvr6WYgtd9Vd9xwyjpwe8lurZ8=
X-Received: by 2002:a37:71c7:: with SMTP id m190mr19655875qkc.478.1571648967881;
 Mon, 21 Oct 2019 02:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
 <1571313682-28900-2-git-send-email-sheetal.tigadoli@broadcom.com> <20191017121640.3a3436da@cakuba.netronome.com>
In-Reply-To: <20191017121640.3a3436da@cakuba.netronome.com>
From:   Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Date:   Mon, 21 Oct 2019 14:41:40 +0530
Message-ID: <CAFD6DHg7J68jHSmNEft7czS+w9pqO8FnjB0a4Ubr5jAUh8Tmdg@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] firmware: broadcom: add OP-TEE based BNXT f/w manager
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
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
        tee-dev@lists.linaro.org,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thanks for your comments.

On Fri, Oct 18, 2019 at 12:46 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 17 Oct 2019 17:31:20 +0530, Sheetal Tigadoli wrote:
> > From: Vikas Gupta <vikas.gupta@broadcom.com>
> >
> > This driver registers on TEE bus to interact with OP-TEE based
> > BNXT firmware management modules
> >
> > Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> > Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
> > ---
> >  drivers/firmware/broadcom/Kconfig             |   8 +
> >  drivers/firmware/broadcom/Makefile            |   1 +
> >  drivers/firmware/broadcom/tee_bnxt_fw.c       | 283 ++++++++++++++++++++++++++
> >  include/linux/firmware/broadcom/tee_bnxt_fw.h |  14 ++
> >  4 files changed, 306 insertions(+)
> >  create mode 100644 drivers/firmware/broadcom/tee_bnxt_fw.c
> >  create mode 100644 include/linux/firmware/broadcom/tee_bnxt_fw.h
> >
> > diff --git a/drivers/firmware/broadcom/Kconfig b/drivers/firmware/broadcom/Kconfig
> > index d03ed8e..79505ad 100644
> > --- a/drivers/firmware/broadcom/Kconfig
> > +++ b/drivers/firmware/broadcom/Kconfig
> > @@ -22,3 +22,11 @@ config BCM47XX_SPROM
> >         In case of SoC devices SPROM content is stored on a flash used by
> >         bootloader firmware CFE. This driver provides method to ssb and bcma
> >         drivers to read SPROM on SoC.
> > +
> > +config TEE_BNXT_FW
> > +     bool "Broadcom BNXT firmware manager"
> > +     depends on (ARCH_BCM_IPROC && OPTEE) || COMPILE_TEST
> > +     default ARCH_BCM_IPROC
> > +     help
> > +       This module help to manage firmware on Broadcom BNXT device. The module
> > +       registers on tee bus and invoke calls to manage firmware on BNXT device.
> > diff --git a/drivers/firmware/broadcom/Makefile b/drivers/firmware/broadcom/Makefile
> > index 72c7fdc..17c5061 100644
> > --- a/drivers/firmware/broadcom/Makefile
> > +++ b/drivers/firmware/broadcom/Makefile
> > @@ -1,3 +1,4 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  obj-$(CONFIG_BCM47XX_NVRAM)          += bcm47xx_nvram.o
> >  obj-$(CONFIG_BCM47XX_SPROM)          += bcm47xx_sprom.o
> > +obj-$(CONFIG_TEE_BNXT_FW)            += tee_bnxt_fw.o
> > diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
> > new file mode 100644
> > index 0000000..1e1e54c
> > --- /dev/null
> > +++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
> > @@ -0,0 +1,283 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright 2019 Broadcom.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/tee_drv.h>
> > +#include <linux/uuid.h>
> > +
> > +#include <linux/firmware/broadcom/tee_bnxt_fw.h>
> > +
> > +#define MAX_SHM_MEM_SZ       SZ_4M
> > +
> > +#define MAX_TEE_PARAM_ARRY_MEMB              4
> > +
> > +#define HANDLE_ERROR(ret, tee_ret, cmd)                                      \
> > +do {                                                                 \
> > +     if ((ret < 0) || (tee_ret != 0)) {                              \
>
> The parenthesis should be around macro parameters.
>
>         if ((ret) < 0 || (tee_ret) != 0) {
>
> || has low priority
>
> > +             dev_err(pvt_data.dev,                                   \
> > +                     #cmd " invoke failed TEE err: %x, ret:%x\n",    \
> > +                     tee_ret, ret);                                  \
> > +             return -EINVAL;                                         \
>
> macros shouldn't change control flow, return statements in macros are
> bad
Will remove the macro HANDLE_ERROR

>
> > +     }                                                               \
> > +} while (0)
> > +
> > +enum ta_cmd {
> > +     /*
> > +      * TA_CMD_BNXT_FASTBOOT - boot bnxt device by copying f/w into sram
> > +      *
> > +      *      param[0] unused
> > +      *      param[1] unused
> > +      *      param[2] unused
> > +      *      param[3] unused
> > +      *
> > +      * Result:
> > +      *      TEE_SUCCESS - Invoke command success
> > +      *      TEE_ERROR_ITEM_NOT_FOUND - Corrupt f/w image found on memory
> > +      */
> > +     TA_CMD_BNXT_FASTBOOT = 0,
> > +
> > +     /*
> > +      * TA_CMD_BNXT_COPY_COREDUMP - copy the core dump into shm
> > +      *
> > +      *      param[0] (in value) - value.a: offset, data to be copied from
> > +      *                            value.b: size of the data
> > +      *      param[1] unused
> > +      *      param[2] unused
> > +      *      param[3] unused
> > +      *
> > +      * Result:
> > +      *      TEE_SUCCESS - Invoke command success
> > +      *      TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> > +      *      TEE_ERROR_ITEM_NOT_FOUND - Corrupt core dump
> > +      */
> > +     TA_CMD_BNXT_COPY_COREDUMP = 3,
> > +};
> > +
> > +/**
> > + * struct tee_bnxt_fw_private - OP-TEE bnxt private data
> > + * @dev:             OP-TEE based bnxt device.
> > + * @ctx:             OP-TEE context handler.
> > + * @session_id:              TA session identifier.
> > + */
> > +struct tee_bnxt_fw_private {
> > +     struct device *dev;
> > +     struct tee_context *ctx;
> > +     u32 session_id;
> > +     struct tee_shm *fw_shm_pool;
> > +};
> > +
> > +static struct tee_bnxt_fw_private pvt_data;
> > +
> > +static inline void prepare_args(int cmd,
>
> No static inlines in .c files, please, the compiler will know what to
> inline.
Will change this to static function.

>
> > +                             struct tee_ioctl_invoke_arg *inv_arg,
>
> inv usually means invalid, please rename to arg
Ok.

>
> > +                             struct tee_param *param)
> > +{
> > +     memset(inv_arg, 0, sizeof(*inv_arg));
> > +     memset(param, 0, (MAX_TEE_PARAM_ARRY_MEMB * sizeof(*param)));
>
> array_size(), outer parens unnecessary
Ok.

>
> > +
> > +     inv_arg->func = cmd;
> > +     inv_arg->session = pvt_data.session_id;
> > +     inv_arg->num_params = MAX_TEE_PARAM_ARRY_MEMB;
> > +
> > +     /* Fill invoke cmd params */
> > +     switch (cmd) {
> > +     case TA_CMD_BNXT_COPY_COREDUMP:
> > +             param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
> > +             param[0].u.memref.shm = pvt_data.fw_shm_pool;
> > +             param[0].u.memref.size = MAX_SHM_MEM_SZ;
> > +             param[0].u.memref.shm_offs = 0;
> > +             param[1].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT;
> > +             break;
> > +     case TA_CMD_BNXT_FASTBOOT:
> > +     default:
> > +             /* Nothing to do */
> > +             break;
> > +     }
> > +}
> > +
> > +/**
> > + * tee_bnxt_fw_load() - Load the bnxt firmware
> > + *               Uses an OP-TEE call to start a secure
> > + *               boot process.
> > + * Returns 0 on success, negative errno otherwise.
> > + */
> > +int tee_bnxt_fw_load(void)
>
> This is a little strange. This function takes no parameters, so how
> does this thing know where to load the firmware? Is it not possible
> to have two devices that'd both require FW?
This function invokes command to optee pta, which is aware of where to load
the firmware and we don't have multiple devices

>
> > +{
> > +     int ret = 0;
> > +     struct tee_ioctl_invoke_arg inv_arg;
> > +     struct tee_param param[MAX_TEE_PARAM_ARRY_MEMB];
> > +
> > +     if (!pvt_data.ctx)
> > +             return -ENODEV;
> > +
> > +     prepare_args(TA_CMD_BNXT_FASTBOOT, &inv_arg, param);
> > +
> > +     ret = tee_client_invoke_func(pvt_data.ctx, &inv_arg, param);
> > +     HANDLE_ERROR(ret, inv_arg.ret, TA_CMD_BNXT_FASTBOOT);
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL(tee_bnxt_fw_load);
> > +
> > +/**
> > + * tee_bnxt_copy_coredump() - Copy coredump from the allocated memory
> > + *                       Uses an OP-TEE call to copy coredump
> > + * @buf:     desintation buffer where core dump is copied into
> > + * @offset:  offset from the base address of core dump area
> > + * @size:    size of the dump
> > + *
> > + * Returns 0 on success, negative errno otherwise.
> > + */
> > +int tee_bnxt_copy_coredump(void *buf, u32 offset, u32 size)
> > +{
> > +     struct tee_ioctl_invoke_arg inv_arg;
> > +     struct tee_param param[MAX_TEE_PARAM_ARRY_MEMB];
> > +     void *core_data;
> > +     u32 rbytes = size;
> > +     u32 nbytes = 0;
> > +     int ret = 0;
> > +
> > +     if (!pvt_data.ctx)
> > +             return -ENODEV;
> > +
> > +     if (!buf)
> > +             return -EINVAL;
>
> Generally we don't check args like that in the kernel, callers should
> not be broken.
Ok. will remove

>
> > +     prepare_args(TA_CMD_BNXT_COPY_COREDUMP, &inv_arg, param);
> > +
> > +     while (rbytes)  {
> > +             nbytes = rbytes;
> > +
> > +             nbytes = min_t(u32, rbytes, param[0].u.memref.size);
> > +
> > +             /* Fill additional invoke cmd params */
> > +             param[1].u.value.a = offset;
> > +             param[1].u.value.b = nbytes;
>
> But the doc above says param 1 is unused
will update the doc/enum description

>
> > +             ret = tee_client_invoke_func(pvt_data.ctx, &inv_arg, param);
> > +             HANDLE_ERROR(ret, inv_arg.ret, TA_CMD_BNXT_COPY_COREDUMP);
> > +
> > +             core_data = tee_shm_get_va(pvt_data.fw_shm_pool, 0);
> > +             if (IS_ERR(core_data)) {
> > +                     dev_err(pvt_data.dev, "tee_shm_get_va failed\n");
> > +                     return PTR_ERR(core_data);
> > +             }
> > +
> > +             memcpy(buf, core_data, nbytes);
> > +
> > +             rbytes -= nbytes;
> > +             buf += nbytes;
> > +             offset += nbytes;
> > +     }
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL(tee_bnxt_copy_coredump);
> > +
> > +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> > +{
> > +     if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> > +             return 1;
> > +     else
> > +             return 0;
>
> Also known as return ver->impl_id == TEE_IMPL_ID_OPTEE; ...
Ok.

>
> > +}
> > +
> > +static int tee_bnxt_fw_probe(struct device *dev)
> > +{
> > +     struct tee_client_device *bnxt_device = to_tee_client_device(dev);
> > +     int ret, err = -ENODEV;
> > +     struct tee_ioctl_open_session_arg sess_arg;
> > +     struct tee_shm *fw_shm_pool;
> > +
> > +     memset(&sess_arg, 0, sizeof(sess_arg));
> > +
> > +     /* Open context with TEE driver */
> > +     pvt_data.ctx = tee_client_open_context(NULL, optee_ctx_match, NULL,
> > +                                            NULL);
> > +     if (IS_ERR(pvt_data.ctx))
> > +             return -ENODEV;
> > +
> > +     /* Open session with Bnxt load Trusted App */
> > +     memcpy(sess_arg.uuid, bnxt_device->id.uuid.b, TEE_IOCTL_UUID_LEN);
> > +     sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> > +     sess_arg.num_params = 0;
> > +
> > +     ret = tee_client_open_session(pvt_data.ctx, &sess_arg, NULL);
> > +     if ((ret < 0) || (sess_arg.ret != 0)) {
>
> parens unnecessary
Will remove parens

>
> > +             dev_err(dev, "tee_client_open_session failed, err: %x\n",
> > +                     sess_arg.ret);
> > +             err = -EINVAL;
> > +             goto out_ctx;
> > +     }
> > +     pvt_data.session_id = sess_arg.session;
> > +
> > +     pvt_data.dev = dev;
> > +
> > +     fw_shm_pool = tee_shm_alloc(pvt_data.ctx, MAX_SHM_MEM_SZ,
> > +                                 TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> > +     if (IS_ERR(fw_shm_pool)) {
> > +             tee_client_close_context(pvt_data.ctx);
> > +             dev_err(pvt_data.dev, "tee_shm_alloc failed\n");
> > +             err = PTR_ERR(fw_shm_pool);
> > +             goto out_sess;
> > +     }
> > +
> > +     pvt_data.fw_shm_pool = fw_shm_pool;
> > +
> > +     return 0;
> > +
> > +out_sess:
> > +     tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
> > +out_ctx:
> > +     tee_client_close_context(pvt_data.ctx);
> > +
> > +     return err;
> > +}
> > +
> > +static int tee_bnxt_fw_remove(struct device *dev)
> > +{
> > +     tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
> > +     tee_client_close_context(pvt_data.ctx);
> > +     pvt_data.ctx = NULL;
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct tee_client_device_id tee_bnxt_fw_id_table[] = {
> > +     {UUID_INIT(0x6272636D, 0x2019, 0x0716,
> > +                 0x42, 0x43, 0x4D, 0x5F, 0x53, 0x43, 0x48, 0x49)},
> > +     {}
> > +};
> > +
> > +MODULE_DEVICE_TABLE(tee, tee_bnxt_fw_id_table);
> > +
> > +static struct tee_client_driver tee_bnxt_fw_driver = {
> > +     .id_table       = tee_bnxt_fw_id_table,
> > +     .driver         = {
> > +             .name           = KBUILD_MODNAME,
> > +             .bus            = &tee_bus_type,
> > +             .probe          = tee_bnxt_fw_probe,
> > +             .remove         = tee_bnxt_fw_remove,
> > +     },
> > +};
> > +
> > +static int __init tee_bnxt_fw_mod_init(void)
> > +{
> > +     return driver_register(&tee_bnxt_fw_driver.driver);
> > +}
> > +
> > +static void __exit tee_bnxt_fw_mod_exit(void)
> > +{
> > +     driver_unregister(&tee_bnxt_fw_driver.driver);
> > +}
> > +
> > +module_init(tee_bnxt_fw_mod_init);
> > +module_exit(tee_bnxt_fw_mod_exit);
>
> Someone should add a module_tee_driver macro, perhaps?
Not clear on this comment

>
> > +MODULE_AUTHOR("Broadcom");
>
> I think you can forego the author macro is it's a company.
will update it to individual

>
> > +MODULE_DESCRIPTION("Broadcom bnxt firmware manager");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/include/linux/firmware/broadcom/tee_bnxt_fw.h b/include/linux/firmware/broadcom/tee_bnxt_fw.h
> > new file mode 100644
> > index 0000000..f24c82d
> > --- /dev/null
> > +++ b/include/linux/firmware/broadcom/tee_bnxt_fw.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: BSD-2-Clause */
> > +/*
> > + * Copyright 2019 Broadcom.
> > + */
> > +
> > +#ifndef _BROADCOM_TEE_BNXT_FW_H
> > +#define _BROADCOM_TEE_BNXT_FW_H
> > +
> > +#include <linux/types.h>
> > +
> > +int tee_bnxt_fw_load(void);
> > +int tee_bnxt_copy_coredump(void *buf, u32 offset, u32 size);
> > +
> > +#endif /* _BROADCOM_TEE_BNXT_FW_H */
>
