Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35275A594D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiH3CVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiH3CVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:21:45 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A33B8E4DF
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:21:42 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id d15so5506947ilf.0
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=hSrtmbD5tGbHhzXL/Xxe83Hw7sJKH+j6Af+kAfpm9lY=;
        b=B6vmMUyPFpsrub0HDxKgNKC5vIEPxtv+6uZ27pmZS/+4pyJL65sPsUpjdPO5NsCaXb
         3kANtiRlIisJYNfhK4/SKSLbAKUrqYW8j8YjqUcCMLip8sIz3Lel3iNIvu1mRTrGiZHi
         0SZxg0ZxefDqHc+ldEuKe2MBiIKTCAk+mzzgXwVxJhNA8RAgFfszb8dfqAzoiFRBFSqd
         6aprfGrSQdh1tGFpN4lZGKE7xeyuS+y4e/B0S0/8JT890vlHnN9FeH6/VuV3UfbPkxaP
         CWuYKN9ssNSbxL8hHS0LK2AQKPp3PPO/6vXPdn3yUJFiV4/fSfqzBDgi801Ndv1arEN+
         kcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=hSrtmbD5tGbHhzXL/Xxe83Hw7sJKH+j6Af+kAfpm9lY=;
        b=IUeSnnlHU+3fkYUGYbwaHxZrW+UDUHP/AwhwmXTDadeRzTUyoTWLSXn8E+2P6HWhii
         b4cjwt8j/BN9D4nobhBV1vUpzEn/ydM7l6qqnlTTDw3xEblPhpZAwP1YH7QpKMA4os33
         GJ8dN5j1V4h8yaUnyIxXLByW/sll+3K4zNG/cfVca9peqLizVLFIvs+Co4c3HdLM71AH
         UkvYPm449mojLUJUmihyUwiTKqZUADDOanZ+FvKzr8bSYTMa7PeR4MyXrcl109tiUdau
         sm7+xbWVttc4Ppu3VHrgOPTxGGUdIdjA+4WfggPgx+9UYsncuS4AwxqaRd/4OKgvK1Q5
         jtUQ==
X-Gm-Message-State: ACgBeo2fN4bfdDk2GrBRLs9Z0eauJkGKW1Z0bqMQMBs+RzrURn7FUyDQ
        xWkQVm7zROuTSFNZWX5TBX5VNvV2HZpawgTjTx4=
X-Google-Smtp-Source: AA6agR40YzS+IWyNeEEuvP8N9FgSwX3SWxNaBo3umgt243cxkPKz/Pzch+AHrgLuAcvWkcRkjKrA4nj2PYFgtJsWd+M=
X-Received: by 2002:a05:6e02:170b:b0:2e6:7ab0:648a with SMTP id
 u11-20020a056e02170b00b002e67ab0648amr11766336ill.140.1661826101652; Mon, 29
 Aug 2022 19:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220816042405.2416972-1-m.chetan.kumar@intel.com>
In-Reply-To: <20220816042405.2416972-1-m.chetan.kumar@intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 30 Aug 2022 05:21:28 +0300
Message-ID: <CAHNKnsT1E1A25iNN143kRZ=R5cC=P6zDJ+RkXhKYZopG4i38yQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,THIS_AD,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 7:12 AM <m.chetan.kumar@intel.com> wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>
> This patch brings-in support for t7xx wwan device firmware flashing &
> coredump collection using devlink.
>
> Driver Registers with Devlink framework.
> Implements devlink ops flash_update callback that programs modem firmware.
> Creates region & snapshot required for device coredump log collection.
> On early detection of wwan device in fastboot mode driver sets up CLDMA0 HW
> tx/rx queues for raw data transfer then registers with devlink framework.
> Upon receiving firmware image & partition details driver sends fastboot
> commands for flashing the firmware.
>
> In this flow the fastboot command & response gets exchanged between driver
> and device. Once firmware flashing is success completion status is reported
> to user space application.
>
> Below is the devlink command usage for firmware flashing
>
> $devlink dev flash pci/$BDF file ABC.img component ABC
>
> Note: ABC.img is the firmware to be programmed to "ABC" partition.
>
> In case of coredump collection when wwan device encounters an exception
> it reboots & stays in fastboot mode for coredump collection by host driver.
> On detecting exception state driver collects the core dump, creates the
> devlink region & reports an event to user space application for dump
> collection. The user space application invokes devlink region read command
> for dump collection.
>
> Below are the devlink commands used for coredump collection.
>
> devlink region new pci/$BDF/mr_dump
> devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
> devlink region del pci/$BDF/mr_dump snapshot $ID
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
> index a87c4cae94ef..1017d21aad59 100644
> --- a/drivers/net/wwan/t7xx/t7xx_pci.h
> +++ b/drivers/net/wwan/t7xx/t7xx_pci.h
> @@ -59,6 +59,7 @@ typedef irqreturn_t (*t7xx_intr_callback)(int irq, void *param);
>   * @md_pm_lock: protects PCIe sleep lock
>   * @sleep_disable_count: PCIe L1.2 lock counter
>   * @sleep_lock_acquire: indicates that sleep has been disabled
> + * @dl: devlink struct
>   */
>  struct t7xx_pci_dev {
>         t7xx_intr_callback      intr_handler[EXT_INT_NUM];
> @@ -79,6 +80,7 @@ struct t7xx_pci_dev {
>         spinlock_t              md_pm_lock;             /* Protects PCI resource lock */
>         unsigned int            sleep_disable_count;
>         struct completion       sleep_lock_acquire;
> +       struct t7xx_devlink     *dl;
>  };
>
>  enum t7xx_pm_id {
> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
> index 6a96ee6d9449..070097a658d1 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port.h
> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
> @@ -129,6 +129,7 @@ struct t7xx_port {
>         int                             rx_length_th;
>         bool                            chan_enable;
>         struct task_struct              *thread;
> +       struct t7xx_devlink     *dl;

The devlink state container is the device wide entity, and the device
state container already carries a pointer to it. So why do we need a
pointer copy inside the port state container?

>  };
>
>  int t7xx_get_port_mtu(struct t7xx_port *port);
> diff --git a/drivers/net/wwan/t7xx/t7xx_port_devlink.c b/drivers/net/wwan/t7xx/t7xx_port_devlink.c
> new file mode 100644
> index 000000000000..026a1db42f69
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_port_devlink.c
> @@ -0,0 +1,705 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022, Intel Corporation.
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/debugfs.h>
> +#include <linux/vmalloc.h>
> +
> +#include "t7xx_hif_cldma.h"
> +#include "t7xx_pci_rescan.h"
> +#include "t7xx_port_devlink.h"
> +#include "t7xx_port_proxy.h"
> +#include "t7xx_state_monitor.h"
> +#include "t7xx_uevent.h"
> +
> +static struct t7xx_devlink_region_info t7xx_devlink_region_list[T7XX_TOTAL_REGIONS] = {
> +       {"mr_dump", T7XX_MRDUMP_SIZE},
> +       {"lk_dump", T7XX_LKDUMP_SIZE},
> +};

This array probably should be const.

Also, region indexes can be used in the array initialization to
clearly state element relations with other arrays:

static const t7xx_devlink_region_info t7xx_devlink_region_infos[] = {
   [T7XX_MRDUMP_INDEX] = {"mr_dump", T7XX_MRDURM_SIZE},
   [T7XX_LDDUMP_INDEX] = {"ld_dump", T7XX_LKDUMP_SIZE},
};

> +static int t7xx_devlink_port_read(struct t7xx_port *port, char *buf, size_t count)
> +{
> +       int ret = 0, read_len;
> +       struct sk_buff *skb;
> +
> +       spin_lock_irq(&port->rx_wq.lock);
> +       if (skb_queue_empty(&port->rx_skb_list)) {
> +               ret = wait_event_interruptible_locked_irq(port->rx_wq,
> +                                                         !skb_queue_empty(&port->rx_skb_list));
> +               if (ret == -ERESTARTSYS) {
> +                       spin_unlock_irq(&port->rx_wq.lock);
> +                       return -EINTR;
> +               }
> +       }
> +       skb = skb_dequeue(&port->rx_skb_list);
> +       spin_unlock_irq(&port->rx_wq.lock);
> +
> +       read_len = count > skb->len ? skb->len : count;
> +       memcpy(buf, skb->data, read_len);
> +       dev_kfree_skb(skb);

Here the call will lose the remaining packet data if the buffer is
less than the skb data. Should the driver keep the skb leftover data
for subsequent port read calls? E.g.

if (read_len < skb->len) {
    skb_pull(skb, read_len);
    skb_queue_head(&port->rx_skb_list, skb);
} else {
    consume_skb(skb);
}

> +
> +       return ret ? ret : read_len;
> +}
> +
> +static int t7xx_devlink_port_write(struct t7xx_port *port, const char *buf, size_t count)
> +{
> +       const struct t7xx_port_conf *port_conf = port->port_conf;
> +       size_t actual_count;
> +       struct sk_buff *skb;
> +       int ret, txq_mtu;
> +
> +       txq_mtu = t7xx_get_port_mtu(port);
> +       if (txq_mtu < 0)
> +               return -EINVAL;
> +
> +       actual_count = count > txq_mtu ? txq_mtu : count;
> +       skb = __dev_alloc_skb(actual_count, GFP_KERNEL);

This way the function will lose data past the MTU boundary. Should the
fragmentation code be implemented here and should the
t7xx_devlink_fb_send_buffer() wrapper be dropped? Or maybe place
WARN_ON() here at least?

> +       if (!skb)
> +               return -ENOMEM;
> +
> +       skb_put_data(skb, buf, actual_count);
> +       ret = t7xx_port_send_raw_skb(port, skb);
> +       if (ret) {
> +               dev_err(port->dev, "write error on %s, size: %zu, ret: %d\n",
> +                       port_conf->name, actual_count, ret);
> +               dev_kfree_skb(skb);
> +               return ret;
> +       }
> +
> +       return actual_count;
> +}
> +
> +static int t7xx_devlink_fb_handle_response(struct t7xx_port *port, int *data)
> +{
> +       int ret = 0, index = 0, return_data = 0, read_bytes;
> +       char status[T7XX_FB_RESPONSE_SIZE + 1];
> +
> +       while (index < T7XX_FB_RESP_COUNT) {
> +               index++;
> +               read_bytes = t7xx_devlink_port_read(port, status, T7XX_FB_RESPONSE_SIZE);
> +               if (read_bytes < 0) {
> +                       dev_err(port->dev, "status read failed");
> +                       ret = -EIO;
> +                       break;
> +               }
> +
> +               status[read_bytes] = '\0';
> +               if (!strncmp(status, T7XX_FB_RESP_INFO, strlen(T7XX_FB_RESP_INFO))) {
> +                       break;
> +               } else if (!strncmp(status, T7XX_FB_RESP_OKAY, strlen(T7XX_FB_RESP_OKAY))) {
> +                       break;
> +               } else if (!strncmp(status, T7XX_FB_RESP_FAIL, strlen(T7XX_FB_RESP_FAIL))) {
> +                       ret = -EPROTO;
> +                       break;
> +               } else if (!strncmp(status, T7XX_FB_RESP_DATA, strlen(T7XX_FB_RESP_DATA))) {
> +                       if (data) {
> +                               if (!kstrtoint(status + strlen(T7XX_FB_RESP_DATA), 16,
> +                                              &return_data)) {
> +                                       *data = return_data;
> +                               } else {
> +                                       dev_err(port->dev, "kstrtoint error!\n");
> +                                       ret = -EPROTO;
> +                               }
> +                       }
> +                       break;
> +               }
> +       }
> +
> +       return ret;
> +}
> +
> +static int t7xx_devlink_fb_raw_command(char *cmd, struct t7xx_port *port, int *data)
> +{
> +       int ret, cmd_size = strlen(cmd);
> +
> +       if (cmd_size > T7XX_FB_COMMAND_SIZE) {

Just curious, is T7XX_FB_COMMAND_SIZE a real hardware limitation or is
this just-in-case check?

> +               dev_err(port->dev, "command length %d is long\n", cmd_size);
> +               return -EINVAL;
> +       }
> +
> +       if (cmd_size != t7xx_devlink_port_write(port, cmd, cmd_size)) {
> +               dev_err(port->dev, "raw command = %s write failed\n", cmd);
> +               return -EIO;
> +       }
> +
> +       dev_dbg(port->dev, "raw command = %s written to the device\n", cmd);
> +       ret = t7xx_devlink_fb_handle_response(port, data);
> +       if (ret)
> +               dev_err(port->dev, "raw command = %s response FAILURE:%d\n", cmd, ret);
> +
> +       return ret;
> +}
> +
> +static int t7xx_devlink_fb_send_buffer(struct t7xx_port *port, const u8 *buf, size_t size)
> +{
> +       size_t remaining = size, offset = 0, len;
> +       int write_done;
> +
> +       if (!size)
> +               return -EINVAL;
> +
> +       while (remaining) {
> +               len = min_t(size_t, remaining, CLDMA_DEDICATED_Q_BUFF_SZ);
> +               write_done = t7xx_devlink_port_write(port, buf + offset, len);
> +
> +               if (write_done < 0) {
> +                       dev_err(port->dev, "write to device failed in %s", __func__);
> +                       return -EIO;
> +               } else if (write_done != len) {
> +                       dev_err(port->dev, "write Error. Only %d/%zu bytes written",
> +                               write_done, len);
> +                       return -EIO;
> +               }
> +
> +               remaining -= len;
> +               offset += len;
> +       }
> +
> +       return 0;
> +}
> +
> +static int t7xx_devlink_fb_download_command(struct t7xx_port *port, size_t size)
> +{
> +       char download_command[T7XX_FB_COMMAND_SIZE];
> +
> +       snprintf(download_command, sizeof(download_command), "%s:%08zx",
> +                T7XX_FB_CMD_DOWNLOAD, size);
> +       return t7xx_devlink_fb_raw_command(download_command, port, NULL);
> +}
> +
> +static int t7xx_devlink_fb_download(struct t7xx_port *port, const u8 *buf, size_t size)
> +{
> +       int ret;
> +
> +       if (size <= 0 || size > SIZE_MAX) {
> +               dev_err(port->dev, "file is too large to download");
> +               return -EINVAL;
> +       }
> +
> +       ret = t7xx_devlink_fb_download_command(port, size);
> +       if (ret)
> +               return ret;
> +
> +       ret = t7xx_devlink_fb_send_buffer(port, buf, size);
> +       if (ret)
> +               return ret;
> +
> +       return t7xx_devlink_fb_handle_response(port, NULL);
> +}
> +
> +static int t7xx_devlink_fb_flash(const char *cmd, struct t7xx_port *port)
> +{
> +       char flash_command[T7XX_FB_COMMAND_SIZE];
> +
> +       snprintf(flash_command, sizeof(flash_command), "%s:%s", T7XX_FB_CMD_FLASH, cmd);
> +       return t7xx_devlink_fb_raw_command(flash_command, port, NULL);
> +}
> +
> +static int t7xx_devlink_fb_flash_partition(const char *partition, const u8 *buf,
> +                                          struct t7xx_port *port, size_t size)
> +{
> +       int ret;
> +
> +       ret = t7xx_devlink_fb_download(port, buf, size);
> +       if (ret)
> +               return ret;
> +
> +       return t7xx_devlink_fb_flash(partition, port);
> +}
> +
> +static int t7xx_devlink_fb_get_core(struct t7xx_port *port)
> +{
> +       struct t7xx_devlink_region_info *mrdump_region;
> +       char mrdump_complete_event[T7XX_FB_EVENT_SIZE];
> +       u32 mrd_mb = T7XX_MRDUMP_SIZE / (1024 * 1024);
> +       struct t7xx_devlink *dl = port->dl;
> +       int clen, dlen = 0, result = 0;
> +       unsigned long long zipsize = 0;
> +       char mcmd[T7XX_FB_MCMD_SIZE];
> +       size_t offset_dlen = 0;
> +       char *mdata;
> +
> +       set_bit(T7XX_MRDUMP_STATUS, &dl->status);
> +       mdata = kmalloc(T7XX_FB_MDATA_SIZE, GFP_KERNEL);
> +       if (!mdata) {
> +               result = -ENOMEM;
> +               goto get_core_exit;
> +       }
> +
> +       mrdump_region = dl->dl_region_info[T7XX_MRDUMP_INDEX];
> +       mrdump_region->dump = vmalloc(mrdump_region->default_size);

Maybe move this allocation to the devlink initialization function to
make it symmetrical to the buffer freeing on devlink deinitialization?

> +       if (!mrdump_region->dump) {
> +               kfree(mdata);
> +               result = -ENOMEM;
> +               goto get_core_exit;
> +       }
> +
> +       result = t7xx_devlink_fb_raw_command(T7XX_FB_CMD_OEM_MRDUMP, port, NULL);
> +       if (result) {
> +               dev_err(port->dev, "%s command failed\n", T7XX_FB_CMD_OEM_MRDUMP);
> +               vfree(mrdump_region->dump);
> +               kfree(mdata);
> +               goto get_core_exit;
> +       }
> +
> +       while (mrdump_region->default_size > offset_dlen) {
> +               clen = t7xx_devlink_port_read(port, mcmd, sizeof(mcmd));

Just terminate the response string and you can use strcmp() below. E.g.

clen = t7xx_devlink_port_read(port, mcmd, sizeof(mcmd) - 1);
mcmd[clen] = '\0';
if (strcmp(mcmd, ....) != 0) {
    ...
} else if (strcmp(mcmd, ...) != 0) {
    ....
}

> +               if (clen == strlen(T7XX_FB_CMD_RTS) &&
> +                   (!strncmp(mcmd, T7XX_FB_CMD_RTS, strlen(T7XX_FB_CMD_RTS)))) {
> +                       memset(mdata, 0, T7XX_FB_MDATA_SIZE);
> +                       dlen = 0;
> +                       memset(mcmd, 0, sizeof(mcmd));
> +                       clen = snprintf(mcmd, sizeof(mcmd), "%s", T7XX_FB_CMD_CTS);
> +
> +                       if (t7xx_devlink_port_write(port, mcmd, clen) != clen) {

This command string copying and sending can be simplified to:

t7xx_devlink_fb_raw_command(T7XX_FB_CMD_CTS, port, NULL)

> +                               dev_err(port->dev, "write for _CTS failed:%d\n", clen);
> +                               goto get_core_free_mem;
> +                       }
> +
> +                       dlen = t7xx_devlink_port_read(port, mdata, T7XX_FB_MDATA_SIZE);
> +                       if (dlen <= 0) {
> +                               dev_err(port->dev, "read data error(%d)\n", dlen);
> +                               goto get_core_free_mem;
> +                       }
> +
> +                       zipsize += (unsigned long long)(dlen);
> +                       memcpy(mrdump_region->dump + offset_dlen, mdata, dlen);

Why is this reading into the intermediate buffer needed?
t7xx_devlink_port_read() will copy the data from an skb to the buffer
using memcpy(). So why not just use the dump buffer with a proper
offer? E.g.

t7xx_devlink_port_read(..., mrdump_region->dump + offset_dlen,
mrdump_region->default_size - offset_dlen);

BTW, copying memory between the buffers without the dlen check can
potentially cause a buffer overflow.

> +                       offset_dlen += dlen;
> +                       memset(mcmd, 0, sizeof(mcmd));
> +                       clen = snprintf(mcmd, sizeof(mcmd), "%s", T7XX_FB_CMD_FIN);
> +                       if (t7xx_devlink_port_write(port, mcmd, clen) != clen) {

t7xx_devlink_fb_raw_command(T7XX_FB_CMD_FIN, port, NULL) ?

> +                               dev_err(port->dev, "%s: _FIN failed, (Read %05d:%05llu)\n",
> +                                       __func__, clen, zipsize);
> +                               goto get_core_free_mem;
> +                       }
> +               } else if ((clen == strlen(T7XX_FB_RESP_MRDUMP_DONE)) &&
> +                         (!strncmp(mcmd, T7XX_FB_RESP_MRDUMP_DONE,
> +                                   strlen(T7XX_FB_RESP_MRDUMP_DONE)))) {
> +                       dev_dbg(port->dev, "%s! size:%zd\n", T7XX_FB_RESP_MRDUMP_DONE, offset_dlen);
> +                       mrdump_region->actual_size = offset_dlen;
> +                       snprintf(mrdump_complete_event, sizeof(mrdump_complete_event),
> +                                "%s size=%zu", T7XX_UEVENT_MRDUMP_READY, offset_dlen);
> +                       t7xx_uevent_send(dl->dev, mrdump_complete_event);
> +                       kfree(mdata);
> +                       result = 0;
> +                       goto get_core_exit;
> +               } else {
> +                       dev_err(port->dev, "getcore protocol error (read len %05d)\n", clen);
> +                       goto get_core_free_mem;
> +               }
> +       }
> +
> +       dev_err(port->dev, "mrdump exceeds %uMB size. Discarded!", mrd_mb);
> +       t7xx_uevent_send(port->dev, T7XX_UEVENT_MRD_DISCD);
> +
> +get_core_free_mem:
> +       kfree(mdata);
> +       vfree(mrdump_region->dump);
> +       clear_bit(T7XX_MRDUMP_STATUS, &dl->status);
> +       return -EPROTO;
> +
> +get_core_exit:
> +       clear_bit(T7XX_MRDUMP_STATUS, &dl->status);
> +       return result;
> +}
> +
> +static int t7xx_devlink_fb_dump_log(struct t7xx_port *port)
> +{
> +       struct t7xx_devlink_region_info *lkdump_region;
> +       char lkdump_complete_event[T7XX_FB_EVENT_SIZE];
> +       struct t7xx_devlink *dl = port->dl;
> +       int dlen, datasize = 0, result;
> +       size_t offset_dlen = 0;
> +       u8 *data;
> +
> +       set_bit(T7XX_LKDUMP_STATUS, &dl->status);
> +       result = t7xx_devlink_fb_raw_command(T7XX_FB_CMD_OEM_LKDUMP, port, &datasize);
> +       if (result) {
> +               dev_err(port->dev, "%s command returns failure\n", T7XX_FB_CMD_OEM_LKDUMP);
> +               goto lkdump_exit;
> +       }
> +
> +       lkdump_region = dl->dl_region_info[T7XX_LKDUMP_INDEX];
> +       if (datasize > lkdump_region->default_size) {
> +               dev_err(port->dev, "lkdump size is more than %dKB. Discarded!",
> +                       T7XX_LKDUMP_SIZE / 1024);
> +               t7xx_uevent_send(dl->dev, T7XX_UEVENT_LKD_DISCD);
> +               result = -EPROTO;
> +               goto lkdump_exit;
> +       }
> +
> +       data = kzalloc(datasize, GFP_KERNEL);
> +       if (!data) {
> +               result = -ENOMEM;
> +               goto lkdump_exit;
> +       }
> +
> +       lkdump_region->dump = vmalloc(lkdump_region->default_size);
> +       if (!lkdump_region->dump) {
> +               kfree(data);
> +               result = -ENOMEM;
> +               goto lkdump_exit;
> +       }
> +
> +       while (datasize > 0) {
> +               dlen = t7xx_devlink_port_read(port, data, datasize);
> +               if (dlen <= 0) {
> +                       dev_err(port->dev, "lkdump read error ret = %d", dlen);
> +                       kfree(data);
> +                       result = -EPROTO;
> +                       goto lkdump_exit;
> +               }
> +
> +               memcpy(lkdump_region->dump + offset_dlen, data, dlen);
> +               datasize -= dlen;
> +               offset_dlen += dlen;
> +       }
> +
> +       dev_dbg(port->dev, "LKDUMP DONE! size:%zd\n", offset_dlen);
> +       lkdump_region->actual_size = offset_dlen;
> +       snprintf(lkdump_complete_event, sizeof(lkdump_complete_event), "%s size=%zu",
> +                T7XX_UEVENT_LKDUMP_READY, offset_dlen);
> +       t7xx_uevent_send(dl->dev, lkdump_complete_event);
> +       kfree(data);
> +       clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
> +       return t7xx_devlink_fb_handle_response(port, NULL);
> +
> +lkdump_exit:
> +       clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
> +       return result;
> +}
> +
> +static int t7xx_devlink_flash_update(struct devlink *devlink,
> +                                    struct devlink_flash_update_params *params,
> +                                    struct netlink_ext_ack *extack)
> +{
> +       struct t7xx_devlink *dl = devlink_priv(devlink);
> +       const char *component = params->component;
> +       const struct firmware *fw = params->fw;
> +       char flash_event[T7XX_FB_EVENT_SIZE];
> +       struct t7xx_port *port;
> +       int ret;
> +
> +       port = dl->port;
> +       if (port->dl->mode != T7XX_FB_DL_MODE) {
> +               dev_err(port->dev, "Modem is not in fastboot download mode!");
> +               ret = -EPERM;
> +               goto err_out;
> +       }
> +
> +       if (dl->status != T7XX_DEVLINK_IDLE) {
> +               dev_err(port->dev, "Modem is busy!");
> +               ret = -EBUSY;
> +               goto err_out;
> +       }
> +
> +       if (!component || !fw->data) {
> +               ret = -EINVAL;
> +               goto err_out;
> +       }
> +
> +       set_bit(T7XX_FLASH_STATUS, &dl->status);
> +       dev_dbg(port->dev, "flash partition name:%s binary size:%zu\n", component, fw->size);
> +       ret = t7xx_devlink_fb_flash_partition(component, fw->data, port, fw->size);
> +       if (ret) {
> +               devlink_flash_update_status_notify(devlink, "flashing failure!",
> +                                                  params->component, 0, 0);
> +               snprintf(flash_event, sizeof(flash_event), "%s for [%s]",
> +                        T7XX_UEVENT_FLASHING_FAILURE, params->component);
> +       } else {
> +               devlink_flash_update_status_notify(devlink, "flashing success!",
> +                                                  params->component, 0, 0);
> +               snprintf(flash_event, sizeof(flash_event), "%s for [%s]",
> +                        T7XX_UEVENT_FLASHING_SUCCESS, params->component);
> +       }
> +
> +       t7xx_uevent_send(dl->dev, flash_event);
> +
> +err_out:
> +       clear_bit(T7XX_FLASH_STATUS, &dl->status);
> +       return ret;
> +}
> +
> +static int t7xx_devlink_reload_down(struct devlink *devlink, bool netns_change,
> +                                   enum devlink_reload_action action,
> +                                   enum devlink_reload_limit limit,
> +                                   struct netlink_ext_ack *extack)
> +{
> +       struct t7xx_devlink *dl = devlink_priv(devlink);
> +
> +       switch (action) {
> +       case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
> +               dl->set_fastboot_dl = 1;

A devlink expert may correct me, but this use of the driver reload
action to implicitly switch to fastboot mode looks like an incorrect
API use (see the reload action description in
Documentation/networking/devlink/devlink-reload.rst).

Most probably, the driver should implement a devlink param that
controls the device operation mode: normal or fastboot. Or just one
boolean param 'fastboot' that enables/disables fastboot mode. And only
after explicitly switching the device mode, the user should fire the
driver/firmware reload command.

To me, this looks like a less surprising way for the user to switch
between normal and flashing modes.

> +               return 0;
> +       case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
> +               return t7xx_devlink_fb_raw_command(T7XX_FB_CMD_REBOOT, dl->port, NULL);
> +       default:
> +               /* Unsupported action should not get to this function */
> +               return -EOPNOTSUPP;
> +       }
> +}
> +
> +static int t7xx_devlink_reload_up(struct devlink *devlink,
> +                                 enum devlink_reload_action action,
> +                                 enum devlink_reload_limit limit,
> +                                 u32 *actions_performed,
> +                                 struct netlink_ext_ack *extack)
> +{
> +       struct t7xx_devlink *dl = devlink_priv(devlink);
> +       *actions_performed = BIT(action);
> +       switch (action) {
> +       case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
> +       case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
> +               t7xx_rescan_queue_work(dl->mtk_dev->pdev);
> +               return 0;
> +       default:
> +               /* Unsupported action should not get to this function */
> +               return -EOPNOTSUPP;
> +       }
> +}
> +
> +/* Call back function for devlink ops */
> +static const struct devlink_ops devlink_flash_ops = {
> +       .supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT,

There is no such flag since f94b606325c1 ("net: devlink: limit flash
component name to match version returned by info_get()").

> +       .flash_update = t7xx_devlink_flash_update,
> +       .reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
> +                         BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
> +       .reload_down = t7xx_devlink_reload_down,
> +       .reload_up = t7xx_devlink_reload_up,
> +};
> +
> +static int t7xx_devlink_region_snapshot(struct devlink *dl, const struct devlink_region_ops *ops,
> +                                       struct netlink_ext_ack *extack, u8 **data)
> +{
> +       struct t7xx_devlink_region_info *region_info = ops->priv;
> +       struct t7xx_devlink *t7xx_dl = devlink_priv(dl);
> +       u8 *snapshot_mem;
> +
> +       if (t7xx_dl->status != T7XX_DEVLINK_IDLE) {
> +               dev_err(t7xx_dl->dev, "Modem is busy!");
> +               return -EBUSY;
> +       }
> +
> +       dev_dbg(t7xx_dl->dev, "accessed devlink region:%s index:%d", ops->name, region_info->entry);

Since the region info pointer is stored inside the ops private data
pointer, the region index can be evaluated using pointer arithmetic:

int idx = region_info - t7xx_devlink_region_list;

if (idx == T7XX_MRDUMP_INDEX) {
    ...
} else if (idx == T7XX_LKDUMP_INDEX) {
    ...
} else {
    return -ENOENT;
}

> +       if (!strncmp(ops->name, "mr_dump", strlen("mr_dump"))) {
> +               if (!region_info->dump) {
> +                       dev_err(t7xx_dl->dev, "devlink region:%s dump memory is not valid!",
> +                               region_info->region_name);
> +                       return -ENOMEM;
> +               }
> +
> +               snapshot_mem = vmalloc(region_info->default_size);
> +               if (!snapshot_mem)
> +                       return -ENOMEM;
> +
> +               memcpy(snapshot_mem, region_info->dump, region_info->default_size);
> +               *data = snapshot_mem;
> +       } else if (!strncmp(ops->name, "lk_dump", strlen("lk_dump"))) {
> +               int ret;
> +
> +               ret = t7xx_devlink_fb_dump_log(t7xx_dl->port);
> +               if (ret)
> +                       return ret;
> +
> +               *data = region_info->dump;
> +       }
> +
> +       return 0;
> +}
> +
> +/* To create regions for dump files */
> +static int t7xx_devlink_create_region(struct t7xx_devlink *dl)

This function is entitled 'create_region', but it creates multiple
regionS at once. It is better to rename it to 'create_regionS'.

Am I right if I say that this code was copied from the iosm driver? I
am asking because the iosm devlink integration was merged too quickly
without proper review. My bad. And now I see that it suffers from the
same issues as noted below.

> +{
> +       struct devlink_region_ops *region_ops;
> +       int rc, i;
> +
> +       region_ops = dl->dl_region_ops;
> +       for (i = 0; i < T7XX_TOTAL_REGIONS; i++) {
> +               region_ops[i].name = t7xx_devlink_region_list[i].region_name;

As Ilpo already said, it is a matter of taste how to design the loops,
but I had construct it like this:

BUILD_BUG_ON(ARRAY_SIZE(t7xx_devlink_region_list) > ARRAY_SIZE(dl->regions));
for (i = 0; i < ARRAY_SIZE(t7xx_devlink_region_list); ++i) {
    region_ops = &dl->dl_region_ops[i];
    region_ops->name = t7xx_devlink_region_list[i].name;

Please note the BUILD_BUG_ON() use: checking the sizes of related
arrays may save a lot of time in the future and helps to document this
relationship.

> +               region_ops[i].snapshot = t7xx_devlink_region_snapshot;
> +               region_ops[i].destructor = vfree;
> +               dl->dl_region[i] =
> +               devlink_region_create(dl->dl_ctx, &region_ops[i], T7XX_MAX_SNAPSHOTS,
> +                                     t7xx_devlink_region_list[i].default_size);

indentation

> +

Odd empty line between the region creation call and the result check.

> +               if (IS_ERR(dl->dl_region[i])) {
> +                       rc = PTR_ERR(dl->dl_region[i]);
> +                       dev_err(dl->dev, "devlink region fail,err %d", rc);
> +                       for ( ; i >= 0; i--)
> +                               devlink_region_destroy(dl->dl_region[i]);
> +
> +                       return rc;
> +               }
> +
> +               t7xx_devlink_region_list[i].entry = i;
> +               region_ops[i].priv = t7xx_devlink_region_list + i;
> +       }
> +
> +       return 0;
> +}
> +
> +/* To Destroy devlink regions */
> +static void t7xx_devlink_destroy_region(struct t7xx_devlink *dl)
> +{
> +       u8 i;
> +
> +       for (i = 0; i < T7XX_TOTAL_REGIONS; i++)
> +               devlink_region_destroy(dl->dl_region[i]);
> +}
> +
> +int t7xx_devlink_register(struct t7xx_pci_dev *t7xx_dev)
> +{
> +       struct devlink *dl_ctx;
> +
> +       dl_ctx = devlink_alloc(&devlink_flash_ops, sizeof(struct t7xx_devlink),
> +                              &t7xx_dev->pdev->dev);
> +       if (!dl_ctx)
> +               return -ENOMEM;
> +
> +       devlink_set_features(dl_ctx, DEVLINK_F_RELOAD);
> +       devlink_register(dl_ctx);
> +       t7xx_dev->dl = devlink_priv(dl_ctx);
> +       t7xx_dev->dl->dl_ctx = dl_ctx;
> +
> +       return 0;
> +}
> +
> +void t7xx_devlink_unregister(struct t7xx_pci_dev *t7xx_dev)
> +{
> +       struct devlink *dl_ctx = priv_to_devlink(t7xx_dev->dl);
> +
> +       devlink_unregister(dl_ctx);
> +       devlink_free(dl_ctx);
> +}
> +
> +/**
> + * t7xx_devlink_region_init - Initialize/register devlink to t7xx driver
> + * @port: Pointer to port structure
> + * @dw: Pointer to devlink work structure
> + * @wq: Pointer to devlink workqueue structure
> + *
> + * Returns: Pointer to t7xx_devlink on success and NULL on failure
> + */
> +static struct t7xx_devlink *t7xx_devlink_region_init(struct t7xx_port *port,
> +                                                    struct t7xx_devlink_work *dw,
> +                                                    struct workqueue_struct *wq)

This function is entitled 'region_init', but it contains the common
devlink initialization code. Probably some or all of its contents
should be moved to the caller function (t7xx_devlink_init) to
consolidate the initialization code.

> +{
> +       struct t7xx_pci_dev *mtk_dev = port->t7xx_dev;
> +       struct t7xx_devlink *dl = mtk_dev->dl;
> +       int rc, i;
> +
> +       dl->dl_ctx = mtk_dev->dl->dl_ctx;
> +       dl->mtk_dev = mtk_dev;
> +       dl->dev = &mtk_dev->pdev->dev;
> +       dl->mode = T7XX_FB_NO_MODE;
> +       dl->status = T7XX_DEVLINK_IDLE;
> +       dl->dl_work = dw;
> +       dl->dl_wq = wq;
> +       for (i = 0; i < T7XX_TOTAL_REGIONS; i++) {
> +               dl->dl_region_info[i] = &t7xx_devlink_region_list[i];

This assignment will lead to various hard-to-investigate issues once a
user connects a couple of modems to a host. Since the region_info
structure contains the run-time modified fields. See also comments
near the structure definition above.

> +               dl->dl_region_info[i]->dump = NULL;
> +       }
> +       dl->port = port;
> +       port->dl = dl;
> +
> +       rc = t7xx_devlink_create_region(dl);
> +       if (rc) {
> +               dev_err(dl->dev, "devlink region creation failed, rc %d", rc);
> +               return NULL;
> +       }
> +
> +       return dl;
> +}
> +
> +/**
> + * t7xx_devlink_region_deinit - To unintialize the devlink from T7XX driver.
> + * @dl:        Devlink instance
> + */
> +static void t7xx_devlink_region_deinit(struct t7xx_devlink *dl)
> +{
> +       dl->mode = T7XX_FB_NO_MODE;
> +       t7xx_devlink_destroy_region(dl);
> +}
> +
> +static void t7xx_devlink_work_handler(struct work_struct *data)
> +{
> +       struct t7xx_devlink_work *dl_work;
> +
> +       dl_work = container_of(data, struct t7xx_devlink_work, work);
> +       t7xx_devlink_fb_get_core(dl_work->port);
> +}
> +
> +static int t7xx_devlink_init(struct t7xx_port *port)
> +{
> +       struct t7xx_devlink_work *dl_work;
> +       struct workqueue_struct *wq;
> +
> +       dl_work = kmalloc(sizeof(*dl_work), GFP_KERNEL);
> +       if (!dl_work)
> +               return -ENOMEM;
> +
> +       wq = create_workqueue("t7xx_devlink");
> +       if (!wq) {
> +               kfree(dl_work);
> +               dev_err(port->dev, "create_workqueue failed\n");
> +               return -ENODATA;
> +       }
> +
> +       INIT_WORK(&dl_work->work, t7xx_devlink_work_handler);
> +       dl_work->port = port;
> +       port->rx_length_th = T7XX_MAX_QUEUE_LENGTH;
> +
> +       if (!t7xx_devlink_region_init(port, dl_work, wq))
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
> +static void t7xx_devlink_uninit(struct t7xx_port *port)
> +{
> +       struct t7xx_devlink *dl = port->dl;
> +       struct sk_buff *skb;
> +       unsigned long flags;
> +
> +       vfree(dl->dl_region_info[T7XX_MRDUMP_INDEX]->dump);
> +       if (dl->dl_wq)
> +               destroy_workqueue(dl->dl_wq);
> +       kfree(dl->dl_work);
> +
> +       t7xx_devlink_region_deinit(port->dl);
> +       spin_lock_irqsave(&port->rx_skb_list.lock, flags);
> +       while ((skb = __skb_dequeue(&port->rx_skb_list)) != NULL)
> +               dev_kfree_skb(skb);
> +       spin_unlock_irqrestore(&port->rx_skb_list.lock, flags);

skb_queue_purge(&port->rx_skb_list) ?

> +}

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_port_devlink.h b/drivers/net/wwan/t7xx/t7xx_port_devlink.h
> new file mode 100644
> index 000000000000..85384e40519e
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_port_devlink.h
> @@ -0,0 +1,85 @@
> +/* SPDX-License-Identifier: GPL-2.0-only
> + *
> + * Copyright (c) 2022, Intel Corporation.
> + */
> +
> +#ifndef __T7XX_PORT_DEVLINK_H__
> +#define __T7XX_PORT_DEVLINK_H__
> +
> +#include <net/devlink.h>
> +
> +#include "t7xx_pci.h"
> +
> +#define T7XX_MAX_QUEUE_LENGTH 32
> +#define T7XX_FB_COMMAND_SIZE  64
> +#define T7XX_FB_RESPONSE_SIZE 64
> +#define T7XX_FB_MCMD_SIZE     64
> +#define T7XX_FB_MDATA_SIZE    1024
> +#define T7XX_FB_RESP_COUNT    30
> +
> +#define T7XX_FB_CMD_RTS          "_RTS"
> +#define T7XX_FB_CMD_CTS          "_CTS"
> +#define T7XX_FB_CMD_FIN          "_FIN"
> +#define T7XX_FB_CMD_OEM_MRDUMP   "oem mrdump"
> +#define T7XX_FB_CMD_OEM_LKDUMP   "oem dump_pllk_log"
> +#define T7XX_FB_CMD_DOWNLOAD     "download"
> +#define T7XX_FB_CMD_FLASH        "flash"
> +#define T7XX_FB_CMD_REBOOT       "reboot"
> +#define T7XX_FB_RESP_MRDUMP_DONE "MRDUMP08_DONE"
> +#define T7XX_FB_RESP_OKAY        "OKAY"
> +#define T7XX_FB_RESP_FAIL        "FAIL"
> +#define T7XX_FB_RESP_DATA        "DATA"
> +#define T7XX_FB_RESP_INFO        "INFO"
> +
> +#define T7XX_FB_EVENT_SIZE      50
> +
> +#define T7XX_MAX_SNAPSHOTS  1
> +#define T7XX_MAX_REGION_NAME_LENGTH 20
> +#define T7XX_MRDUMP_SIZE    (160 * 1024 * 1024)
> +#define T7XX_LKDUMP_SIZE    (256 * 1024)
> +#define T7XX_TOTAL_REGIONS  2
> +
> +#define T7XX_FLASH_STATUS   0
> +#define T7XX_MRDUMP_STATUS  1
> +#define T7XX_LKDUMP_STATUS  2
> +#define T7XX_DEVLINK_IDLE   0
> +
> +#define T7XX_FB_NO_MODE     0
> +#define T7XX_FB_DL_MODE     1
> +#define T7XX_FB_DUMP_MODE   2
> +
> +#define T7XX_MRDUMP_INDEX   0
> +#define T7XX_LKDUMP_INDEX   1

Maybe convert these macros to enum and use them more actively? E.g.

/* Internal region indexes */
enum t7xx_regions {
    T7XX_REGION_MRDUMP,
    T7XX_REGION_LKDUMP,
    T7XX_REGIONS_NUM
};

> +struct t7xx_devlink_work {
> +       struct work_struct work;
> +       struct t7xx_port *port;
> +};

You can embed the _work_ structure into the t7xx_devlink structure, so
you do not need this ad hoc structure with all the dynamic memory
allocation and pointers juggling associated with it.

> +struct t7xx_devlink_region_info {
> +       char region_name[T7XX_MAX_REGION_NAME_LENGTH];
> +       u32 default_size;
> +       u32 actual_size;
> +       u32 entry;
> +       u8 *dump;
> +};

This structure mixes static initialization data and run-time state.
Also, the set of arrays inside the t7xx_devlink structure makes the
code harder to read. What if we split this structure into a static
configuration structure and a runtime state container structure? And
place all runtime data (e.g. ops, devlink region pointer, etc.) into
this common state container.

struct t7xx_devlink_region_info {
    const char *name;
    size_t size;
};

struct t7xx_devlink_region {
    const struct t7xx_devlink_region_info *info;
    struct devlink_region_ops ops;
    struct devlink_region *dlreg;
    size_t data_len;
    void *buf;
};

struct t7xx_devlink {
    ...
    struct t7xx_devlink_region regions[T7XX_TOTAL_REGIONS];
};

So the initialization will become:

for (...) {
    dl->region[i].info = &t7xx_devlink_regions[i];
    dl->region[i].ops.name = dl->region[i].info->name;
    dl->region[i].ops.priv = &dl->region[i];
    ...
}

And the region index always can be evaluated from the info pointer:

idx = ((struct t7xx_devlink_region *)ops->priv)->info - t7xx_devlink_regions;

> +struct t7xx_devlink {
> +       struct t7xx_pci_dev *mtk_dev;
> +       struct t7xx_port *port;
> +       struct device *dev;

This field is unused.

> +       struct devlink *dl_ctx;
> +       struct t7xx_devlink_work *dl_work;
> +       struct workqueue_struct *dl_wq;
> +       struct t7xx_devlink_region_info *dl_region_info[T7XX_TOTAL_REGIONS];
> +       struct devlink_region_ops dl_region_ops[T7XX_TOTAL_REGIONS];
> +       struct devlink_region *dl_region[T7XX_TOTAL_REGIONS];
> +       u8 mode;
> +       unsigned long status;
> +       int set_fastboot_dl;
> +};
> +
> +int t7xx_devlink_register(struct t7xx_pci_dev *t7xx_dev);
> +void t7xx_devlink_unregister(struct t7xx_pci_dev *t7xx_dev);
> +
> +#endif /*__T7XX_PORT_DEVLINK_H__*/

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> index 9c222809371b..00e143c8d568 100644
> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c

[skipped]

> @@ -239,8 +252,16 @@ static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int
>                         return;
>                 }
>
> +               if (lk_event == LK_EVENT_CREATE_PD_PORT)
> +                       port->dl->mode = T7XX_FB_DUMP_MODE;
> +               else
> +                       port->dl->mode = T7XX_FB_DL_MODE;
>                 port->port_conf->ops->enable_chl(port);
>                 t7xx_cldma_start(md_ctrl);
> +               if (lk_event == LK_EVENT_CREATE_PD_PORT)
> +                       t7xx_uevent_send(dev, T7XX_UEVENT_MODEM_FASTBOOT_DUMP_MODE);
> +               else
> +                       t7xx_uevent_send(dev, T7XX_UEVENT_MODEM_FASTBOOT_DL_MODE);
>                 break;
>
>         case LK_EVENT_RESET:

[skipped]

> @@ -318,6 +349,7 @@ static void fsm_routine_ready(struct t7xx_fsm_ctl *ctl)
>
>         ctl->curr_state = FSM_STATE_READY;
>         t7xx_fsm_broadcast_ready_state(ctl);
> +       t7xx_uevent_send(&md->t7xx_dev->pdev->dev, T7XX_UEVENT_MODEM_READY);
>         t7xx_md_event_notify(md, FSM_READY);
>  }

These UEVENT things look at least unrelated to the patch. If the
deriver is really need it, please factor out it into a separate patch
with a comment describing why userspace wants to see these events.

On the other hand, this looks like a custom tracing implementation. It
might be better to use simple debug messages instead or even the
tracing API, which is much more powerful than any uevent.

--
Sergey
