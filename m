Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2811D5A5916
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiH3CDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiH3CDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:03:04 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCEA7A53E
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:03:03 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z72so8128300iof.12
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tfL0vadiWuDr5uuAYXsRYB0OjHcT/XLGu5xkl/qiv10=;
        b=XwlkR71LCfIs7IGXjJAFmStjujVtKoctmMof3L3XHYDW+lHBACHHeSqjF08q2tmhEP
         anMcZ1FOhfwBijQjI+HKK57/boi5wAxESZrkTfl7n0fk0RWSY0Yj0sWqhMy8a84PWH8R
         y9OaCdQCxTA0UiH+NKgYqZKymURfD+kvqzUlCJcySlxcxcqPgXVHUVWG41IKG8ZO00lm
         VdhUIeaAHDv4H8Pf6ifRzppbhY9mmtNF8YXntWa57UsoMTN1PtGbCukAU/bn93i7szYK
         t0un5+d2+fVBEbts1GiBHGP6VwAcF2IjYNMch915/lObjSQRqdnQKDuB6C76WO4ZKGwT
         opFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tfL0vadiWuDr5uuAYXsRYB0OjHcT/XLGu5xkl/qiv10=;
        b=auVXEjqOgO5bWxDyduEO3fY6HRoJ/Fjc3qXvUDTAVfOekRBzhRln789qMHOqfpAy+x
         sj5rLYJAMbfzYk+N74bbA7YaNIxo/I1wtryE78vZVuFMnTpqF6mjFdIAHdGm57Sx0S/d
         w6CRZGtfSTAzlKj8V/4kdBpe8q8za3c0CeoGsLvT0YnpZAlLvHViR7W7naPX5g1I7ggr
         ZFDgbrHdk98w4vuBh/+7fVpdR6ff+6uoL8SOL3zvaKK9/7fTcdLNAluhr1e+GlLjai/y
         D3vUnEUr9QiYY3y0+mLioENbvnatvQixlxWs76qvCnWwdSAhCcFzw6IDJQFDi0oWIoWe
         Tq2Q==
X-Gm-Message-State: ACgBeo2Xm0QSKL/qWSw6xafPuTUmXOMiNSv81RlGZItSNid70QYCk/UW
        bAZwYHAQrfIyPahDik/dIjIJjSVMqzTUcpLR+ng=
X-Google-Smtp-Source: AA6agR7vfC5WP2cijsuwG9gs0Dv1mamAfXrsg5N+mUDUvNe5PPOnnu4phUw3D0vohEogLPsDf/JgeiNrqnhpWMn9/1U=
X-Received: by 2002:a05:6602:154c:b0:689:c27b:93d with SMTP id
 h12-20020a056602154c00b00689c27b093dmr9305637iow.93.1661824982494; Mon, 29
 Aug 2022 19:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220816042353.2416956-1-m.chetan.kumar@intel.com>
In-Reply-To: <20220816042353.2416956-1-m.chetan.kumar@intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 30 Aug 2022 05:02:49 +0300
Message-ID: <CAHNKnsTVGZXF_kUU5YgWmM64_8yAE75=2w1H2A40Wb0y=n8YMg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: wwan: t7xx: PCIe reset rescan
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 7:12 AM <m.chetan.kumar@intel.com> wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> PCI rescan module implements "rescan work queue". In firmware flashing
> or coredump collection procedure WWAN device is programmed to boot in
> fastboot mode and a work item is scheduled for removal & detection.
> The WWAN device is reset using APCI call as part driver removal flow.
> Work queue rescans pci bus at fixed interval for device detection,
> later when device is detect work queue exits.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
> index 871f2a27a398..2f5c6fbe601e 100644
> --- a/drivers/net/wwan/t7xx/t7xx_pci.c
> +++ b/drivers/net/wwan/t7xx/t7xx_pci.c
> @@ -715,8 +716,11 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>                 return ret;
>         }
>
> +       t7xx_rescan_done();
>         t7xx_pcie_mac_set_int(t7xx_dev, MHCCIF_INT);
>         t7xx_pcie_mac_interrupts_en(t7xx_dev);
> +       if (!t7xx_dev->hp_enable)
> +               pci_ignore_hotplug(pdev);

pci_ignore_hotplug() also disables hotplug events for a parent bridge.
Is that how this call was intended?

>
>         return 0;
>  }

[skipped]

> +static void __exit t7xx_pci_cleanup(void)
> +{
> +       int remove_flag = 0;
> +       struct device *dev;
> +
> +       dev = driver_find_device(&t7xx_pci_driver.driver, NULL, NULL, t7xx_always_match);
> +       if (dev) {
> +               pr_debug("unregister t7xx PCIe driver while device is still exist.\n");
> +               put_device(dev);
> +               remove_flag = 1;
> +       } else {
> +               pr_debug("no t7xx PCIe driver found.\n");
> +       }
> +
> +       pci_lock_rescan_remove();
> +       pci_unregister_driver(&t7xx_pci_driver);
> +       pci_unlock_rescan_remove();
> +       t7xx_rescan_deinit();
> +
> +       if (remove_flag) {
> +               pr_debug("remove t7xx PCI device\n");
> +               pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
> +       }

What is the purpose of these operations? Should not the PCI core do
this for us on the driver unregister?

> +}
> +
> +module_exit(t7xx_pci_cleanup);
>
>  MODULE_AUTHOR("MediaTek Inc");
>  MODULE_DESCRIPTION("MediaTek PCIe 5G WWAN modem T7xx driver");

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.c b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
> new file mode 100644
> index 000000000000..045777d8a843
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c

[skipped]

> +void t7xx_pci_dev_rescan(void)
> +{
> +       struct pci_bus *b = NULL;
> +
> +       pci_lock_rescan_remove();
> +       while ((b = pci_find_next_bus(b)))
> +               pci_rescan_bus(b);

The driver does not need to rescan all buses. The device should appear
on the same bus, so the driver just needs to rescan a single and
already known bus.

> +
> +       pci_unlock_rescan_remove();
> +}

[skipped]

> +static void t7xx_remove_rescan(struct work_struct *work)
> +{
> +       struct pci_dev *pdev;
> +       int num_retries = RESCAN_RETRIES;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
> +       g_mtk_rescan_context.rescan_done = 0;
> +       pdev = g_mtk_rescan_context.dev;
> +       spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
> +
> +       if (pdev) {
> +               pci_stop_and_remove_bus_device_locked(pdev);

What is the purpose of removing the device then trying to find it by
rescanning the bus? Would not it be easier to save a PCI device
configuration, reset the device, and then restore the configuration?

The DEVLINK_CMD_RELOAD description states that this command performs
(see include/uapi/linux/devlink.h):

Hot driver reload, makes configuration changes take place. The
devlink instance is not released during the process.

And the devlink_reload() function in net/core/devlink.c is able to
survive the devlink structure memory freeing only by accident. But the
PCI device removing should do exactly that: call the device removing
callback, which will release the devlink instance.

> +               pr_debug("start remove and rescan flow\n");
> +       }
> +
> +       do {
> +               t7xx_pci_dev_rescan();
> +               spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
> +               if (g_mtk_rescan_context.rescan_done) {
> +                       spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
> +                       break;
> +               }
> +
> +               spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
> +               msleep(DELAY_RESCAN_MTIME);
> +       } while (num_retries--);
> +}

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> index e53651ee2005..dfd7fb487fc0 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> +++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
> @@ -156,6 +156,12 @@ static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int
>  {
>         const struct t7xx_port_conf *port_conf = port->port_conf;
>
> +       if (state == MD_STATE_EXCEPTION) {
> +               if (port->wwan_port)
> +                       wwan_port_txoff(port->wwan_port);
> +               return;
> +       }
> +

Looks unrelated to the patch description. Does this hunk really belong
to the patch?

>         if (state != MD_STATE_READY)
>                 return;
>

--
Sergey
