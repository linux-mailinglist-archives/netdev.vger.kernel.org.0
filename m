Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A3A5AA717
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 07:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiIBEu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 00:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIBEu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 00:50:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3066F39B9A
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 21:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662094225; x=1693630225;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=qfujnOJpX30vK1SCXE5KzujlH1+F6INjqBSDMJ0tEJU=;
  b=K+NghC4pldgdVKZ+9k78KAjxePphpj6WW4+/IGy2teHPP84Z7Dqwi4VO
   /fwDKFKcWKGyL/IrrDgxeNuxC5gMSMc9/MvVAa8rDr34mZ7OZ3anq+Ij1
   1GyaaoZ5/XtW0xKKfSjkuv14P4LNmhYHEzQ7BGz6LjSGUNO8PhvS/YaW1
   KN1sUD06BMN4kF40/U9LbZgJQAhlwr7/GljxsZknBie8Nigc2Nh7/kzd3
   LPCq4woqJ3OnOQblTe1eqRXN835mRkjVxMri7xOvvVBlVLKj/0sKjhaTj
   YVYxK/mvPElJJDl7ssxzip3/YiqUO7eJBTWpLYoCdF+2LoGU0cJmB86c3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="295899569"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="295899569"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 21:50:24 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="674198656"
Received: from nrajeevx-mobl2.gar.corp.intel.com (HELO [10.213.87.51]) ([10.213.87.51])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 21:50:21 -0700
Message-ID: <56a42938-c746-9937-58cb-7a065815a93f@linux.intel.com>
Date:   Fri, 2 Sep 2022 10:20:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Subject: Re: [PATCH net-next 3/5] net: wwan: t7xx: PCIe reset rescan
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
References: <20220816042353.2416956-1-m.chetan.kumar@intel.com>
 <CAHNKnsTVGZXF_kUU5YgWmM64_8yAE75=2w1H2A40Wb0y=n8YMg@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAHNKnsTVGZXF_kUU5YgWmM64_8yAE75=2w1H2A40Wb0y=n8YMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2022 7:32 AM, Sergey Ryazanov wrote:
> On Tue, Aug 16, 2022 at 7:12 AM <m.chetan.kumar@intel.com> wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> PCI rescan module implements "rescan work queue". In firmware flashing
>> or coredump collection procedure WWAN device is programmed to boot in
>> fastboot mode and a work item is scheduled for removal & detection.
>> The WWAN device is reset using APCI call as part driver removal flow.
>> Work queue rescans pci bus at fixed interval for device detection,
>> later when device is detect work queue exits.
> 
> [skipped]
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
>> index 871f2a27a398..2f5c6fbe601e 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_pci.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_pci.c
>> @@ -715,8 +716,11 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>                  return ret;
>>          }
>>
>> +       t7xx_rescan_done();
>>          t7xx_pcie_mac_set_int(t7xx_dev, MHCCIF_INT);
>>          t7xx_pcie_mac_interrupts_en(t7xx_dev);
>> +       if (!t7xx_dev->hp_enable)
>> +               pci_ignore_hotplug(pdev);
> 
> pci_ignore_hotplug() also disables hotplug events for a parent bridge.
> Is that how this call was intended?

I am checking on it. Will get back.

> 
>>
>>          return 0;
>>   }
> 
> [skipped]
> 
>> +static void __exit t7xx_pci_cleanup(void)
>> +{
>> +       int remove_flag = 0;
>> +       struct device *dev;
>> +
>> +       dev = driver_find_device(&t7xx_pci_driver.driver, NULL, NULL, t7xx_always_match);
>> +       if (dev) {
>> +               pr_debug("unregister t7xx PCIe driver while device is still exist.\n");
>> +               put_device(dev);
>> +               remove_flag = 1;
>> +       } else {
>> +               pr_debug("no t7xx PCIe driver found.\n");
>> +       }
>> +
>> +       pci_lock_rescan_remove();
>> +       pci_unregister_driver(&t7xx_pci_driver);
>> +       pci_unlock_rescan_remove();
>> +       t7xx_rescan_deinit();
>> +
>> +       if (remove_flag) {
>> +               pr_debug("remove t7xx PCI device\n");
>> +               pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
>> +       }
> 
> What is the purpose of these operations? Should not the PCI core do
> this for us on the driver unregister?

In removal flow the device need to be reset else the next insmod
would result in device handshake failure. So in driver removal flow
the device is reset and current dev is removed using 
pci_stop_and_remove_bus_device_locked().

If hotplug is disabled on PCI Express Root Port, the dev removal
procedure will not happen on device reset. So driver is explicitly
calling pci_stop_and_remove_bus_device_locked().

> 
>> +}
>> +
>> +module_exit(t7xx_pci_cleanup);
>>
>>   MODULE_AUTHOR("MediaTek Inc");
>>   MODULE_DESCRIPTION("MediaTek PCIe 5G WWAN modem T7xx driver");
> 
> [skipped]
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.c b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
>> new file mode 100644
>> index 000000000000..045777d8a843
>> --- /dev/null
>> +++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
> 
> [skipped]
> 
>> +void t7xx_pci_dev_rescan(void)
>> +{
>> +       struct pci_bus *b = NULL;
>> +
>> +       pci_lock_rescan_remove();
>> +       while ((b = pci_find_next_bus(b)))
>> +               pci_rescan_bus(b);
> 
> The driver does not need to rescan all buses. The device should appear
> on the same bus, so the driver just needs to rescan a single and
> already known bus.

On device reset the dev is removed so scanning all buses.

> 
>> +
>> +       pci_unlock_rescan_remove();
>> +}
> 
> [skipped]
> 
>> +static void t7xx_remove_rescan(struct work_struct *work)
>> +{
>> +       struct pci_dev *pdev;
>> +       int num_retries = RESCAN_RETRIES;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
>> +       g_mtk_rescan_context.rescan_done = 0;
>> +       pdev = g_mtk_rescan_context.dev;
>> +       spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
>> +
>> +       if (pdev) {
>> +               pci_stop_and_remove_bus_device_locked(pdev);
> 
> What is the purpose of removing the device then trying to find it by
> rescanning the bus? Would not it be easier to save a PCI device
> configuration, reset the device, and then restore the configuration?

If hotplug is disabled, the device is not removed on reset. So in this 
case driver need to handle the device removal and rescan.

> The DEVLINK_CMD_RELOAD description states that this command performs
> (see include/uapi/linux/devlink.h):
> 
> Hot driver reload, makes configuration changes take place. The
> devlink instance is not released during the process.
> 
> And the devlink_reload() function in net/core/devlink.c is able to
> survive the devlink structure memory freeing only by accident. But the
> PCI device removing should do exactly that: call the device removing
> callback, which will release the devlink instance. >
>> +               pr_debug("start remove and rescan flow\n");
>> +       }
>> +
>> +       do {
>> +               t7xx_pci_dev_rescan();
>> +               spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
>> +               if (g_mtk_rescan_context.rescan_done) {
>> +                       spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
>> +                       break;
>> +               }
>> +
>> +               spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
>> +               msleep(DELAY_RESCAN_MTIME);
>> +       } while (num_retries--);
>> +}
> 
> [skipped]
> 
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> index e53651ee2005..dfd7fb487fc0 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
>> @@ -156,6 +156,12 @@ static void t7xx_port_wwan_md_state_notify(struct t7xx_port *port, unsigned int
>>   {
>>          const struct t7xx_port_conf *port_conf = port->port_conf;
>>
>> +       if (state == MD_STATE_EXCEPTION) {
>> +               if (port->wwan_port)
>> +                       wwan_port_txoff(port->wwan_port);
>> +               return;
>> +       }
>> +
> 
> Looks unrelated to the patch description. Does this hunk really belong
> to the patch?

Will drop this.

> 
>>          if (state != MD_STATE_READY)
>>                  return;
>>
> 
> --
> Sergey

-- 
Chetan
