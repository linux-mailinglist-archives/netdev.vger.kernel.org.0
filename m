Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE425AF7C7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 00:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiIFWT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 18:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIFWT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 18:19:27 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAC5B9C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 15:19:23 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id l6so6693324ilk.13
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 15:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=MInJLRQ4vaFPx54m76Jvt3Xvz90sFb1fki9KnTFTgLw=;
        b=GRoy+/Dz2DAtYvyqONGyge65lgLBx5QE1eguOV/Q/cUo9YsDWKJoKheOTbaoyqvezz
         QCFACYr/PsKZMEDrqhmjz4r+JcBUjMvqLefUYCg4HQutb4pe3WwQLEmdaJzUE7JcFvdE
         2GR18qTMFZtnfbvAAoE1MsWrGhbCGZUYEv1S9/YHbpzXGwFYvXUzGrR+WAq2qnIoxjko
         FLiW+C8u904sTcLQP1nQqmVRf6QsQJB+/TOQVV0EVgHfGBhWbvtGCdP8bAAXGQEp5YyX
         wICZ+W9G+kmfemIFWLm068EeXBKlk6GB+BR9dNusCrpjUO6VSa503e8XRxTIOrT4FHiy
         WvUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MInJLRQ4vaFPx54m76Jvt3Xvz90sFb1fki9KnTFTgLw=;
        b=1eEsZRCZTWr/n/gFHDw7xtO/cFZT8HKhCOgqQ0FHSqP++1wfXlvrnKBEUxMDTcXnrn
         5uUVuZfT8OPZOPnwWmcv0T66OgiR8jVCnX+ZSJmuXYeaU+ua0rUJ3iAD6P8RZFaw6d0z
         X2qXJRBLs1R4gUR4r+KO2N9RSJOJ6ndaLTOdEOC0H6ZGF2hHlRU9cfltaGzeXZ32nsb1
         ghrH33jA2+Q4n2RHc/Yb40jJFVrHMCSDctElRbJN7Ofrt2ghj1nnVDJflbYGNaf5V74G
         fBkjRAupIud18ae89VQ3tWjMs8r7tn5jM8Y1qjwkJdONqOnCkINvmfoRLO2OF4xxt7FN
         8nRA==
X-Gm-Message-State: ACgBeo1lkKCGezBG/Zj/fKTtYk/PcaQDYrCZwEtKyYi//5A8kA+6Dkg/
        hl03C39ECVfLZw93PmjLVCR/CBOlx1rFEAgpDmc=
X-Google-Smtp-Source: AA6agR40wyM0/V9y5XxDRAESS1/DUdFRX/FtKOjPavDa5CHuw2QFsKaO3iqoDZyOBWuE5XUXaSov0hnOR5q3d2k+qYk=
X-Received: by 2002:a92:ca0b:0:b0:2f1:da1d:c229 with SMTP id
 j11-20020a92ca0b000000b002f1da1dc229mr349182ils.145.1662502763340; Tue, 06
 Sep 2022 15:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220816042353.2416956-1-m.chetan.kumar@intel.com>
 <CAHNKnsTVGZXF_kUU5YgWmM64_8yAE75=2w1H2A40Wb0y=n8YMg@mail.gmail.com> <56a42938-c746-9937-58cb-7a065815a93f@linux.intel.com>
In-Reply-To: <56a42938-c746-9937-58cb-7a065815a93f@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 7 Sep 2022 01:19:14 +0300
Message-ID: <CAHNKnsT7zC4fTmc_+17Vy05aP-=vfZhwjOhbYJLOd=OZNMVD0w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: wwan: t7xx: PCIe reset rescan
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
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

On Fri, Sep 2, 2022 at 7:50 AM Kumar, M Chetan
<m.chetan.kumar@linux.intel.com> wrote:
> On 8/30/2022 7:32 AM, Sergey Ryazanov wrote:
>> On Tue, Aug 16, 2022 at 7:12 AM <m.chetan.kumar@intel.com> wrote:
>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>
>>> PCI rescan module implements "rescan work queue". In firmware flashing
>>> or coredump collection procedure WWAN device is programmed to boot in
>>> fastboot mode and a work item is scheduled for removal & detection.
>>> The WWAN device is reset using APCI call as part driver removal flow.
>>> Work queue rescans pci bus at fixed interval for device detection,
>>> later when device is detect work queue exits.
>>
>> [skipped]
>>
>>> diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.c b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
>>> new file mode 100644
>>> index 000000000000..045777d8a843
>>> --- /dev/null
>>> +++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
>>
>> [skipped]
>>
>>> +static void t7xx_remove_rescan(struct work_struct *work)
>>> +{
>>> +       struct pci_dev *pdev;
>>> +       int num_retries = RESCAN_RETRIES;
>>> +       unsigned long flags;
>>> +
>>> +       spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
>>> +       g_mtk_rescan_context.rescan_done = 0;
>>> +       pdev = g_mtk_rescan_context.dev;
>>> +       spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
>>> +
>>> +       if (pdev) {
>>> +               pci_stop_and_remove_bus_device_locked(pdev);
>>
>> What is the purpose of removing the device then trying to find it by
>> rescanning the bus? Would not it be easier to save a PCI device
>> configuration, reset the device, and then restore the configuration?
>
> If hotplug is disabled, the device is not removed on reset. So in this
> case driver need to handle the device removal and rescan.

I still can not understand this part and need a clue. Why should the
driver disable the hotplug?

And is there a more gentle way to reset the firmware without the
device object removing?

>>> +               pr_debug("start remove and rescan flow\n");
>>> +       }
>>> +
>>> +       do {
>>> +               t7xx_pci_dev_rescan();
>>> +               spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
>>> +               if (g_mtk_rescan_context.rescan_done) {
>>> +                       spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
>>> +                       break;
>>> +               }
>>> +
>>> +               spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
>>> +               msleep(DELAY_RESCAN_MTIME);
>>> +       } while (num_retries--);
>>> +}

-- 
Sergey
