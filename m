Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CAC4D079B
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 20:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbiCGTYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 14:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbiCGTYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 14:24:10 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5D35DF1E
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 11:23:14 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73F4A153B;
        Mon,  7 Mar 2022 11:23:14 -0800 (PST)
Received: from [192.168.122.164] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EE653F7F5;
        Mon,  7 Mar 2022 11:23:14 -0800 (PST)
Message-ID: <f0f12f2a-b2ac-6292-55eb-a207c8a965f1@arm.com>
Date:   Mon, 7 Mar 2022 13:23:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
 <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
 <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
 <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
 <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
 <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <922fab4e-0608-0d46-9379-026a51398b7a@arm.com>
 <e0fbf7c7-c09f-0f39-e53a-3118c1b2f193@redhat.com>
 <6fc548ca-1195-8941-5caa-2e3384debad7@arm.com>
 <de377891-c220-64f8-a0c2-69976d0c8513@gmail.com>
 <4da6b03a-603f-c5e8-2356-e7ecd9756508@arm.com>
 <1d95ecda-75a9-0a66-7f5e-42b986556466@gmail.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
In-Reply-To: <1d95ecda-75a9-0a66-7f5e-42b986556466@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/7/22 12:44, Florian Fainelli wrote:
> On 3/7/22 10:27 AM, Jeremy Linton wrote:
>> Hi,
>>
>> Sorry about the delay, i'm flipping between a couple different things here.
>>
>> On 3/4/22 14:12, Florian Fainelli wrote:
>>>
>>>
>>> On 3/4/2022 9:33 AM, Jeremy Linton wrote:
>>>> Hi,
>>>>
>>>> On 3/3/22 14:04, Javier Martinez Canillas wrote:
>>>>> Hello Jeremy,
>>>>>
>>>>> On 3/3/22 21:00, Jeremy Linton wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 2/23/22 16:48, Jakub Kicinski wrote:
>>>>>>> On Wed, 23 Feb 2022 09:54:26 -0800 Florian Fainelli wrote:
>>>>>>>>> I have no problems working with you to improve the driver, the
>>>>>>>>> problem
>>>>>>>>> I have is this is currently a regression in 5.17 so I would like to
>>>>>>>>> see something land, whether it's reverting the other patch, landing
>>>>>>>>> thing one or another straight forward fix and then maybe revisit as
>>>>>>>>> whole in 5.18.
>>>>>>>>
>>>>>>>> Understood and I won't require you or me to complete this
>>>>>>>> investigating
>>>>>>>> before fixing the regression, this is just so we understand where it
>>>>>>>> stemmed from and possibly fix the IRQ layer if need be. Given what I
>>>>>>>> just wrote, do you think you can sprinkle debug prints throughout
>>>>>>>> the
>>>>>>>> kernel to figure out whether enable_irq_wake() somehow messes up the
>>>>>>>> interrupt descriptor of interrupt and test that theory? We can do
>>>>>>>> that
>>>>>>>> offline if you want.
>>>>>>>
>>>>>>> Let me mark v2 as Deferred for now, then. I'm not really sure if
>>>>>>> that's
>>>>>>> what's intended but we have 3 weeks or so until 5.17 is cut so we can
>>>>>>> afford a few days of investigating.
>>>>>>>
>>>>>>> I'm likely missing the point but sounds like the IRQ subsystem treats
>>>>>>> IRQ numbers as unsigned so if we pass a negative value "fun" is sort
>>>>>>> of expected. Isn't the problem that device somehow comes with wakeup
>>>>>>> capable being set already? Isn't it better to make sure device is not
>>>>>>> wake capable if there's no WoL irq instead of adding second check?
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>>>>>> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>>>>>> index cfe09117fe6c..7dea44803beb 100644
>>>>>>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>>>>>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>>>>>> @@ -4020,12 +4020,12 @@ static int bcmgenet_probe(struct
>>>>>>> platform_device *pdev)
>>>>>>>         /* Request the WOL interrupt and advertise suspend if
>>>>>>> available */
>>>>>>>         priv->wol_irq_disabled = true;
>>>>>>> -    if (priv->wol_irq > 0) {
>>>>>>> +    if (priv->wol_irq > 0)
>>>>>>>             err = devm_request_irq(&pdev->dev, priv->wol_irq,
>>>>>>>                            bcmgenet_wol_isr, 0, dev->name, priv);
>>>>>>> -        if (!err)
>>>>>>> -            device_set_wakeup_capable(&pdev->dev, 1);
>>>>>>> -    }
>>>>>>> +    else
>>>>>>> +        err = -ENOENT;
>>>>>>> +    device_set_wakeup_capable(&pdev->dev, !err);
>>>>>>>         /* Set the needed headroom to account for any possible
>>>>>>>          * features enabling/disabling at runtime
>>>>>>>
>>>>>>
>>>>>>
>>>>>> I duplicated the problem on rpi4/ACPI by moving to gcc12, so I have
>>>>>> a/b
>>>>>> config that is close as I can achieve using gcc11 vs 12 and the one
>>>>>> built with gcc12 fails pretty consistently while the gcc11 works.
>>>>>>
>>>>>
>>>>> Did Peter's patch instead of this one help ?
>>>>>
>>>>
>>>> No, it seems to be the same problem. The second irq is registered,
>>>> but never seems to fire. There are a couple odd compiler warnings
>>>> about infinite recursion in memcpy()/etc I was looking at, but
>>>> nothing really pops out. Its like the adapter never gets the command
>>>> submissions (although link/up/down appear to be working/etc).
>>>
>>> There are two "main" interrupt lines which are required and an
>>> optional third interrupt line which is the side band Wake-on-LAN
>>> interrupt from the second level interrupt controller that aggregates
>>> all wake-up sources.
>>>
>>> The first interrupt line collects the the default RX/TX queue
>>> interrupts (ring 16) as well as the MAC link up/down and other
>>> interrupts that we are not using. The second interrupt line is only
>>> for the TX queues (rings 0 through 3) transmit done completion
>>> signaling. Because the driver is multi-queue aware and enabled, the
>>> network stack will chose any of those 5 queues before transmitting
>>> packets based upon a hash, so if you want to reliably prove/disprove
>>> that the second interrupt line is non-functional, you would need to
>>> force a given type of packet(s) to use that queue specifically. There
>>> is an example on how to do that here:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/multiqueue.rst#n47
>>>
>>>
>>> With that said, please try the following debug patch so we can get
>>> more understanding of how we managed to prevent the second interrupt
>>> line from getting its interrupt handler serviced. Thanks
>>
>> Right, I applied your patch to rc7, and it prints the following
>> (trimming uninterresting bits)
>>
>>
>>
>> [    7.044681] bcmgenet BCM6E4E:00: IRQ0: 28 (29), IRQ1: -6 (28), Wol
>> IRQ: 29 (4294967290)
> 
> OK, my debug patch was a bit messed up in that it should have been:
> 
> +	dev_info(&pdev->dev, "IRQ0: %d (%u), IRQ1: %d (%u), Wol IRQ: %d (%u)\n",
> +		 priv->irq0, priv->irq0, priv->irq1,
> +		 priv->irq1, priv->wol_irq, priv->wol_irq);
> 
> still, we have the information we want, that is, both IRQ0 and IRQ1 are
> valid with the values 28, 49, however wol_irq is -ENXIO as expected.
> 
> So I really do not think that the Wake-on-LAN interrupt has anything to
> do with getting the transmit queue timeout. I have seen reports that it
> look like switching the checksum offload might be responsible for these
> timeouts:
> 
> https://github.com/raspberrypi/linux/issues/3850
> https://github.com/raspberrypi/linux/issues/3850#issuecomment-698206124
> 
> If that is the case, would you try the following patch in addition to
> the previous one:
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 1ff0e9a0998e..5ee92b7f70e4 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -4034,8 +4034,7 @@ static int bcmgenet_probe(struct platform_device
> *pdev)
>          priv->msg_enable = netif_msg_init(-1, GENET_MSG_DEFAULT);
> 
>          /* Set default features */
> -       dev->features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
> -                        NETIF_F_RXCSUM;
> +       dev->features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_RXCSUM;
>          dev->hw_features |= dev->features;
>          dev->vlan_features |= dev->features;

Well I "fixed" it, by fully serializing the register writes with 
writel/readl instead of write/readl_relaxed. So, I'm looking for cases 
where the descriptor read/write in memory, isn't assured to be in order 
with accessing the device.

> 
> 
> 
> 
> 
>> [    7.064731] bcmgenet BCM6E4E:00: GENET 5.0 EPHY: 0x0000
>> [    8.533639] bcmgenet BCM6E4E:00 enabcm6e4ei0: renamed from eth0
>> [   56.803894] bcmgenet BCM6E4E:00: configuring instance for external
>> RGMII (RX delay)
>> [   56.896851] bcmgenet BCM6E4E:00 enabcm6e4ei0: Link is Down
>> [   60.045071] bcmgenet BCM6E4E:00 enabcm6e4ei0: Link is Up - 1Gbps/Full
>> - flow control off
>> [   60.055872] IPv6: ADDRCONF(NETDEV_CHANGE): enabcm6e4ei0: link becomes
>> ready
>> [   62.283525] ------------[ cut here ]------------
>> [   62.290811] NETDEV WATCHDOG: enabcm6e4ei0 (bcmgenet): transmit queue
>> 2 timed out
>> [   62.301080] WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:529
>> dev_watchdog+0x234/0x240
>> [   62.312220] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6
>> nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
>> nft_chain_nat nf_nat ns
>> [   62.370353] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.17.0-rc7G12+ #58
>> [   62.380052] Hardware name: Raspberry Pi Foundation Raspberry Pi 4
>> Model B/Raspberry Pi 4 Model B, BIOS EDK2-DEV 02/08/2022
>> [   62.394151] pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS
>> BTYPE=--)
>> [   62.404211] pc : dev_watchdog+0x234/0x240
>> [   62.411304] lr : dev_watchdog+0x234/0x240
>> [   62.418371] sp : ffff8000080b3a40
>> [   62.424715] x29: ffff8000080b3a40 x28: ffffdd4ed64c7000 x27:
>> ffff8000080b3b20
>> [   62.434899] x26: ffffdd4ed5f40000 x25: 0000000000000000 x24:
>> ffffdd4ed64cec08
>> [   62.445095] x23: 0000000000000100 x22: ffffdd4ed64c7000 x21:
>> ffff1bd254e58000
>> [   62.455259] x20: 0000000000000002 x19: ffff1bd254e584c8 x18:
>> ffffffffffffffff
>> [   62.465439] x17: 64656d6974203220 x16: 0000000000000001 x15:
>> 6d736e617274203a
>> [   62.475615] x14: 2974656e65676d63 x13: ffffdd4ed51700d8 x12:
>> ffffdd4ed65bd5f0
>> [   62.485787] x11: 00000000ffffffff x10: ffffdd4ed65bd5f0 x9 :
>> ffffdd4ed420c0fc
>> [   62.495978] x8 : 00000000ffffdfff x7 : ffffdd4ed65bd5f0 x6 :
>> 0000000000000001
>> [   62.506173] x5 : 0000000000000000 x4 : ffff1bd2fb7b1408 x3 :
>> ffff1bd2fb7bddb0
>> [   62.516334] x2 : ffff1bd2fb7b1408 x1 : ffff3e842586e000 x0 :
>> 0000000000000044
>> [   62.526520] Call trace:
>> [   62.531969]  dev_watchdog+0x234/0x240
>> [   62.538671]  call_timer_fn+0x3c/0x15c
>> [   62.545331]  __run_timers.part.0+0x288/0x310
>> [   62.552579]  run_timer_softirq+0x48/0x80
>> [   62.559466]  __do_softirq+0x128/0x360
>> [   62.566055]  __irq_exit_rcu+0x138/0x140
>> [   62.572823]  irq_exit_rcu+0x1c/0x30
>> [   62.580799]  el1_interrupt+0x38/0x54
>> [   62.580817]  el1h_64_irq_handler+0x18/0x24
>> [   62.580822]  el1h_64_irq+0x7c/0x80
>> [   62.580827]  arch_cpu_idle+0x18/0x2c
>> [   62.580832]  default_idle_call+0x4c/0x140
>> [   62.580836]  cpuidle_idle_call+0x14c/0x1a0
>> [   62.580844]  do_idle+0xb0/0x100
>> [   62.580849]  cpu_startup_entry+0x30/0x8c
>> [   62.580854]  secondary_start_kernel+0xe4/0x110
>> [   62.580862]  __secondary_switched+0x94/0x98
>> [   62.580871] ---[ end trace 0000000000000000 ]---
>>
>> It should be noted that the irq0/1/2 numbers are a bit messed up in the
>> patch, but the general idea should be visible here.
>>
>> The full log is here https://pastebin.centos.org/view/22c2aede
>>
>> The WOL paths aren't required to trigger this, which is why I questioned
>> the other patch.
>>
> 
> 

