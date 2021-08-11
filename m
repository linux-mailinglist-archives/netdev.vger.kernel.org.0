Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FE53E9930
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhHKTrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbhHKTrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 15:47:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C19C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 12:47:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r6so4673061wrt.4
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 12:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mL9Nq5+hvNDX7rqoPl9Guy8KMKJCyuX3u7UQuSze7qU=;
        b=F7YYHGR/bQIBFVo/CLLHpN3z37Z41UZeoo202csziFmtd1MpS4PvrOHeIxxGQQx3oU
         qd2xCt/ywvsmKMAHVOM6kGEoBBT4BKlzJmIikJYbAKd2LQEz3cqoF6kpkBRz75LKagw8
         BZVkFcCrZFFUyqO7kzP4eEwb7eMNnqGrxnjqFLpEvJTvp43B+TV7qdATJdcJAbBhKu/C
         eY3JzAcwngjxYxaM//UzAwlQtqOtoiubYWXyqYG7VdRS6qx7MSeW119MBF83NBKUn7Qd
         pKS2Q3A+0U/siT2+7iUnIIUfSSVQlQ3VzRZeGnEsB7b60+NBI+byDyUEHJ9EX/8vT1iM
         Ga6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mL9Nq5+hvNDX7rqoPl9Guy8KMKJCyuX3u7UQuSze7qU=;
        b=syPxb6PBIMH9RSpRMWKtMywpsRa43Jgs51NW0fyqn/KZDQJqJT/2ZrcomRRVpWQy/r
         oBdb3LKJaCBw/uTTLpleqqYli2mX0dw3yBmjR2ysrd67jqOoB7C8asGiD0iFQBFAJZ+9
         LRZrGP89kVgejiZ9UL8CjeMf2IXsbJp0qp1sFD3iOq83h2Nx6Bf/1FLM85M+LZ+IMRXn
         tlFgU/3/3iMLEk0SFwSUMh0s8iiDxASLA1TIlQkyXB7tKasngKr0iCjz4nKAMEcJZBP2
         ixI9f7a0hpDh8T060hLdJYg1/UGkPsHj1xryN0s9aSe8rIzu+TK6USBnux6GlKy1i38z
         7KOA==
X-Gm-Message-State: AOAM533ZUk5VkiPhPBNrmxHc8GWQFckAskePHJR+XitFjujJ2IcTCBzG
        u/G/2GPPka/PY5ABx+g6r/o=
X-Google-Smtp-Source: ABdhPJzh2xSopHto4/pAbEQ16Y2QnOJBBm08gBBZJ6gio2IgeBTi3l7CdmLQiYACZJnO6ijBAxeXRw==
X-Received: by 2002:adf:d20c:: with SMTP id j12mr146492wrh.74.1628711245705;
        Wed, 11 Aug 2021 12:47:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:988:dfda:c500:b22? (p200300ea8f10c2000988dfdac5000b22.dip0.t-ipconnect.de. [2003:ea:8f10:c200:988:dfda:c500:b22])
        by smtp.googlemail.com with ESMTPSA id u23sm7093526wmc.24.2021.08.11.12.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 12:47:25 -0700 (PDT)
To:     "Late @ Gmail" <ljakku77@gmail.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
 <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
 <0415fc0d-1514-0d79-c1d8-52984973cca5@gmail.com>
 <3e3b4402-3b6f-7d26-10f3-8e2b18eb65c4@gmail.com>
 <eb4b6c25-539a-9a94-27a4-398031725709@gmail.com>
 <efe87588-e480-ebc9-32d7-a1489b25f45a@gmail.com>
 <60619b13-fdd4-e9f9-2b80-0807c381a247@gmail.com>
 <56ab5e00-a26e-de3e-3002-3e5b2dfb2009@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: NET: r8168/r8169 identifying fix
Message-ID: <ef00cbfc-08ef-ebb3-9964-378369dd09f3@gmail.com>
Date:   Wed, 11 Aug 2021 21:47:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <56ab5e00-a26e-de3e-3002-3e5b2dfb2009@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.08.2021 15:17, Late @ Gmail wrote:
> Hi All,
> 
> Ok, I will not send patch with the hacky-stuff anymore. I do realize the hacky stuff is not acceptable, but it is a starting point
> 
> .. you gotta start from somewhere, and get some comments about the patch.
> 
> 
> That means that I need some help, what i'm trying to grasp is what the patch does, so that the driver
> 
> works with my HW (witch needs the patch (hacky yeah) to work out of the boot ok).
> 
> 
> The modprobe reload does something to driver/hw/??? that it is ok, when the module's probe return zero at all times.
> 
> .. that is hacky partly reason: I'm not familiar with kernel's code base yet -> It may seem hacky for many, but i'm
> 
> trying to get picture in my head what and why works like it works.
> 
> 
> The hacky-bit works for me -> in principle the way to fix in concept is ok, now just to make it non-hacky and align
> 
> with current architechture and design of overall kernel codebase.
> 
> 
> hmm, i'm thinking of debugging the module's reloading steps with stacktraces to figure out more and
> 
> possibly make quirk bit(s) for re-probe within initial module load & handle unloading properly in
> 
> between.
> 
> 
> So basicly what i'm trying to reproduce in boot-time is:
> 
> 
>     modprobe -r r8169
> 
>     modprobe r8169
> 
That's the interesting: find out why after a reload of the module the chip suddenly
provides the correct PHY ID. It shouldn't be something in probe() because this one
we execute on first load already. Maybe something related to remove().
E.g. you could check whether a pci_disable_device() / pci_enable_device()
cycle before r8169_mdio_register() makes a difference.

> 
> Sequence.
> 
> 
> --Lauri
> 
> On 11.8.2021 9.09, Heiner Kallweit wrote:
>> On 10.08.2021 23:50, Late @ Gmail wrote:
>>> Hi,
>>>
>>> Now I solved the reloading issue, and r8169 driver works line charm.
>>>
>> This patch is a complete hack and and in parts simply wrong.
>> In addition it misses the basics of how to submit a patch.
>> Quality hasn't improved since your first attempt, so better stop
>> trying to submit this to mainline.
>>
>>> Patch:
>>>
>>> From: Lauri Jakku <lja@lja.fi>
>>> Date: Mon, 9 Aug 2021 21:44:53 +0300
>>> Subject: [PATCH] net:realtek:r8169 driver load fix
>>>
>>>    net:realtek:r8169 driver load fix
>>>
>>>      Problem:
>>>
>>>        The problem is that (1st load) fails, but there is valid
>>>        HW found (the ID is known) and this patch is applied, the second
>>>        time of loading module works ok, and network is connected ok
>>>        etc.
>>>
>>>      Solution:
>>>
>>>        The driver will trust the HW that reports valid ID and then make
>>>        re-loading of the module as it would being reloaded manually.
>>>
>>>        I do check that if the HW id is read ok from the HW, then pass
>>>        -EAGAIN ja try to load 5 times, sleeping 250ms in between.
>>>
>>> Signed-off-by: Lauri Jakku <lja@lja.fi>
>>> diff --git a/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c b/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
>>> index c7af5bc3b..d8e602527 100644
>>> --- a/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -634,6 +634,8 @@ struct rtl8169_private {
>>>      struct rtl_fw *rtl_fw;
>>>  
>>>      u32 ocp_base;
>>> +
>>> +    int retry_probeing;
>>>  };
>>>  
>>>  typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
>>> @@ -5097,13 +5099,16 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>      tp->phydev = mdiobus_get_phy(new_bus, 0);
>>>      if (!tp->phydev) {
>>>          return -ENODEV;
>>> -    } else if (!tp->phydev->drv) {
>>> -        /* Most chip versions fail with the genphy driver.
>>> -         * Therefore ensure that the dedicated PHY driver is loaded.
>>> +    } else if (tp->phydev->phy_id != RTL_GIGA_MAC_NONE) {
>> You compare two completely different things here. The phy_id has nothing
>> to do with the chip version enum.
>>
>>> +        /* Most chip versions fail with the genphy driver, BUT do rerport valid IW
>>> +         * ID. Re-starting the module seem to fix the issue of non-functional driver.
>>>           */
>>> -        dev_err(&pdev->dev, "no dedicated PHY driver found for PHY ID 0x%08x, maybe realtek.ko needs to be added to initramfs?\n",
>>> +        dev_err(&pdev->dev,
>>> +            "no dedicated driver, but HW found: PHY PHY ID 0x%08x\n",
>>>              tp->phydev->phy_id);
>>> -        return -EUNATCH;
>>> +
>>> +        dev_err(&pdev->dev, "trying re-probe few times..\n");
>>> +
>>>      }
>>>  
>>>      tp->phydev->mac_managed_pm = 1;
>>> @@ -5250,6 +5255,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>      enum mac_version chipset;
>>>      struct net_device *dev;
>>>      u16 xid;
>>> +    int savederr = 0;
>>>  
>>>      dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
>>>      if (!dev)
>>> @@ -5261,6 +5267,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>      tp->dev = dev;
>>>      tp->pci_dev = pdev;
>>>      tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
>>> +    tp->retry_probeing = 0;
>>>      tp->eee_adv = -1;
>>>      tp->ocp_base = OCP_STD_PHY_BASE;
>>>  
>>> @@ -5410,7 +5417,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>  
>>>      pci_set_drvdata(pdev, tp);
>>>  
>>> -    rc = r8169_mdio_register(tp);
>>> +    savederr = r8169_mdio_register(tp);
>>> +
>>> +    if (
>>> +        (tp->retry_probeing > 0) &&
>>> +        (savederr == -EAGAIN)
>>> +       ) {
>>> +        netdev_info(dev, " retry of probe requested..............");
>>> +    }
>>> +
>>>      if (rc)
>>>          return rc;
>>>  
>>> @@ -5435,6 +5450,14 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>      if (pci_dev_run_wake(pdev))
>>>          pm_runtime_put_sync(&pdev->dev);
>>>  
>>> +    if (
>>> +        (tp->retry_probeing > 0) &&
>>> +        (savederr == -EAGAIN)
>>> +       ) {
>>> +        netdev_info(dev, " retry of probe requested..............");
>>> +        return savederr;
>> You can not simply return here. You have to clean up.
>>
>>> +    }
>>> +
>>>      return 0;
>>>  }
>>>  
>>> diff --git a/linux-5.14-rc4/drivers/net/phy/phy_device.c b/linux-5.14-rc4/drivers/net/phy/phy_device.c
>>> index 5d5f9a9ee..59c6ac031 100644
>> No mixing of changes in phylib and drivers.
>>
>>> --- a/linux-5.14-rc4/drivers/net/phy/phy_device.c
>>> +++ b/linux-5.14-rc4/drivers/net/phy/phy_device.c
>>> @@ -2980,6 +2980,9 @@ struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
>>>  }
>>>  EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
>>>  
>>> +
>>> +static int phy_remove(struct device *dev);
>>> +
>> No forward declarations.
>>
>>>  /**
>>>   * phy_probe - probe and init a PHY device
>>>   * @dev: device to probe and init
>>> @@ -2988,13 +2991,22 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
>>>   *   set the state to READY (the driver's init function should
>>>   *   set it to STARTING if needed).
>>>   */
>>> +#define REDO_PROBE_TIMES    5
>>>  static int phy_probe(struct device *dev)
>>>  {
>>>      struct phy_device *phydev = to_phy_device(dev);
>>>      struct device_driver *drv = phydev->mdio.dev.driver;
>>>      struct phy_driver *phydrv = to_phy_driver(drv);
>>> +    int again = 0;
>>> +    int savederr = 0;
>>> +again_retry:
>>>      int err = 0;
>>>  
>>> +    if (again > 0) {
>>> +        pr_err("%s: Re-probe %d of driver.....\n",
>>> +               phydrv->name, again);
>>> +    }
>>> +
>>>      phydev->drv = phydrv;
>>>  
>>>      /* Disable the interrupt if the PHY doesn't support it
>>> @@ -3013,6 +3025,17 @@ static int phy_probe(struct device *dev)
>>>  
>>>      if (phydev->drv->probe) {
>>>          err = phydev->drv->probe(phydev);
>>> +
>>> +        /* If again requested. */
>>> +        if (err == -EAGAIN) {
>> This doesn't make sense. You check the PHY driver probe return code,
>> mixing it up with the MAC driver return code.
>>
>>> +            again++;
>>> +            savederr = err;
>>> +            err = 0;
>>> +
>>> +            pr_info("%s: EAGAIN: %d ...\n",
>>> +                phydrv->name, again);
>>> +        }
>>> +
>>>          if (err)
>>>              goto out;
>>>      }
>>> @@ -3081,6 +3104,20 @@ static int phy_probe(struct device *dev)
>>>  
>>>      mutex_unlock(&phydev->lock);
>>>  
>>> +    if ((savederr == -EAGAIN) &&
>>> +        ((again > 0) && (again < REDO_PROBE_TIMES))
>>> +       ) {
>>> +        pr_err("%s: Retry removal driver..\n",
>>> +            phydrv->name);
>>> +
>>> +        phy_remove(dev);
>>> +
>>> +        pr_err("%s: Re-probe driver..\n",
>>> +            phydrv->name);
>>> +        savederr = 0;
>>> +        goto again_retry;
>>> +    }
>>> +
>>>      return err;
>>>  }
>>>  
>>> @@ -3108,6 +3145,7 @@ static int phy_remove(struct device *dev)
>>>      return 0;
>>>  }
>>>  
>>> +
>>>  static void phy_shutdown(struct device *dev)
>>>  {
>>>      struct phy_device *phydev = to_phy_device(dev);
>>>
>>>
>>>
>>> On 11.3.2021 18.43, gmail wrote:
>>>> Heiner Kallweit kirjoitti 11.3.2021 klo 18.23:
>>>>> On 11.03.2021 17:00, gmail wrote:
>>>>>> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
>>>>>>
>>>>>>     On 15.04.2020 16:39, Lauri Jakku wrote:
>>>>>>
>>>>>>         Hi, There seems to he Something odd problem, maybe timing
>>>>>>         related. Stripped version not workingas expected. I get back to
>>>>>>         you, when  i have it working.
>>>>>>
>>>>>>     There's no point in working on your patch. W/o proper justification it
>>>>>>     isn't acceptable anyway. And so far we still don't know which problem
>>>>>>     you actually have.
>>>>>>     FIRST please provide the requested logs and explain the actual problem
>>>>>>     (incl. the commit that caused the regression).
>>>>>>
>>>>>>
>>>>>>              13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com
>>>>>>         <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll
>>>>>>         strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote: On
>>>>>>         Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi,
>>>>>>         Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On
>>>>>>         Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From
>>>>>>         2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00
>>>>>>         2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020
>>>>>>         13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>>>>         The driver installation determination made properly by checking
>>>>>>         PHY vs DRIVER id's. ---
>>>>>>         drivers/net/ethernet/realtek/r8169_main.c | 70
>>>>>>         ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2
>>>>>>         files changed, 72 insertions(+), 9 deletions(-) I would say that
>>>>>>         most of the code is debug prints. I tought that they are helpful
>>>>>>         to keep, they are using the debug calls, so they are not visible
>>>>>>         if user does not like those. You are missing the point of who
>>>>>>         are your users. Users want to have working device and the code.
>>>>>>         They don't need or like to debug their kernel. Thanks
>>>>>>
>>>>>>     Hi, now i got time to tackle with this again :) .. I know the proposed fix is quite hack, BUT it does give a clue what is wrong.
>>>>>>
>>>>>>     Something in subsystem is not working at the first time, but it needs to be reloaded to work ok (second time). So what I will do
>>>>>>     is that I try out re-do the module load within the module, if there is known HW id available but driver is not available, that
>>>>>>     would be much nicer and user friendly way.
>>>>>>
>>>>>>
>>>>>>     When the module setup it self nicely on first load, then can be the hunt for late-init of subsystem be checked out. Is the HW
>>>>>>     not brought up correct way during first time, or does the HW need time to brough up, or what is the cause.
>>>>>>
>>>>>>     The justification is the same as all HW driver bugs, the improvement is always better to take in. Or do this patch have some-
>>>>>>     thing what other patches do not?
>>>>>>
>>>>>>     Is there legit reason why NOT to improve something, that is clearly issue for others also than just me ? I will take on the
>>>>>>     task to fiddle with the module to get it more-less hacky and fully working version. Without the need for user to do something
>>>>>>     for the module to work.
>>>>>>
>>>>>>         --Lauri J.
>>>>>>
>>>>>>
>>>>> I have no clue what you're trying to say. The last patch wasn't acceptable at all.
>>>>> If you want to submit a patch:
>>>>>
>>>>> - Follow kernel code style
>>>>> - Explain what the exact problem is, what the root cause is, and how your patch fixes it
>>>>> - Explain why you're sure that it doesn't break processing on other chip versions
>>>>>    and systems.
>>>>>
>>>> Ok, i'll make nice patch that has in comment what is the problem and how does the patch help the case at hand.
>>>>
>>>> I don't know the rootcause, but something in subsystem that possibly is initializing bit slowly, cause the reloading
>>>>
>>>> of the module provides working network connection, when done via insmod cycle. I'm not sure is it just a timing
>>>>
>>>> issue or what. I'd like to check where is the driver pointer populated, and put some debugs to see if the issue is just
>>>>
>>>> timing, let's see.
>>>>
>>>>
>>>> The problem is that (1st load) fails, but there is valid HW found (the ID is known), when the hacky patch of mine
>>>>
>>>> is applied, the second time of loading module works ok, and network is connected ok etc.
>>>>
>>>>
>>>> I make the change so that when the current HEAD code is going to return failure, i do check that if the HW id is read ok
>>>>
>>>> from the HW, then pass -EAGAIN ja try to load 5 times, sleeping 250ms in between.
>>>>
>>>>
>>>> --Lauri J.
>>>>
>>>>
>>>>
>>>>

