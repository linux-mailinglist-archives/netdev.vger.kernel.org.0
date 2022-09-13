Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C665B6C3B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 13:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiIMLJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 07:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiIMLJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 07:09:06 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6BB5F9B1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 04:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663067337; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=CETPnR8Ev251ZQ8ZhfVuB/riW8RFpyrrIFyYIGBfgEQuq2m5n4N9FlPpbhYzyB8L6cPDyMHQdWwaPCnNVic4vBAW/acHiRT6vjhepKhfKFM8drjOrpHcIo2TlZTtl2ISwBeB4mkRpT2sT+oqxOrHMP84eRB+9Kr6UboXRdk3aaA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663067337; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LbHb4ucJ0FGJApse6nRvb8WXxHTJOMdfIbhs+3SSRhc=; 
        b=J68tsPl+NXvmItQMI2eKUVMXeCBv6+sIEvFbvuz0Rlo0DDzt3+HmpQGtdl0AB4NowOWt/TEv4egYpuLHLSY4l5YyQrKrdP6Zfaz9nDqMRQFx1w+vHESX2yefxarwSgWG137pUtCeY8u4CJS/9ZuFME3G1fGDVfhgQpq4KRpAcxA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663067337;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=LbHb4ucJ0FGJApse6nRvb8WXxHTJOMdfIbhs+3SSRhc=;
        b=fOeQ8jxQelqDTvs7+ukacZPfOStHzd6K+l15h4HAlJg6ys3nDJSMP7HGqpccN2ya
        tE+f9qfEll9BFORIpKcK7sefiqnp0B2fU5b+UyX8vrIJ40W4Q6t3Dr5SsQHXmSwi8G0
        wtrRER0HZL182xPvdjc3JVTAPEGkSMxZLLPDbxRo=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663067336862754.0414853082491; Tue, 13 Sep 2022 04:08:56 -0700 (PDT)
Message-ID: <693820e5-5e8c-fc36-5e5e-f7ca3bdcce72@arinc9.com>
Date:   Tue, 13 Sep 2022 14:08:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
Content-Language: en-US
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, paulmck@kernel.org
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <Yx8thSbBKJhxv169@lore-desk> <Yx9z9Dm4vJFxGaJI@lore-desk>
 <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
 <Yx+W9EoEfoRsq1rt@lore-desk>
 <CAMhs-H8wWNrqb0RgQdcL4J+=oGws8pB8Uv_H=6Q8AyzXDgF89Q@mail.gmail.com>
 <CAMhs-H8Wsin67gTLPfv9x=hHM-prz4YYensNtyc=hZx+s4d=9Q@mail.gmail.com>
 <10e9ead9-5adc-5065-0c13-702aabd5dcb0@arinc9.com>
 <YyBibTHeSxwa31Cm@lore-desk>
 <CAMhs-H_oe-pCBBTDQT_uzyEYUoSvJB=DveZpyUUmdB2Sz--Hww@mail.gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CAMhs-H_oe-pCBBTDQT_uzyEYUoSvJB=DveZpyUUmdB2Sz--Hww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.09.2022 14:07, Sergio Paracuellos wrote:
> Hi Lorenzo,
> 
> On Tue, Sep 13, 2022 at 12:58 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>
>>> On 13.09.2022 11:31, Sergio Paracuellos wrote:
>>>> Hi Lorenzo,
>>>>
>>>> On Tue, Sep 13, 2022 at 5:32 AM Sergio Paracuellos
>>>> <sergio.paracuellos@gmail.com> wrote:
>>>>>
>>>>> Hi Lorenzo,
>>>>>
>>>>> On Mon, Sep 12, 2022 at 10:30 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>>>>>
>>>>>>> Hi Lorenzo,
>>>>>>>
>>>>>>> On 12.09.2022 21:01, Lorenzo Bianconi wrote:
>>>>>>>>>> Ethernet for MT7621 SoCs no longer works after changes introduced to
>>>>>>>>>> mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fine. Packets are
>>>>>>>>>> sent out from the interface fine but won't be received on the interface.
>>>>>>>>>>
>>>>>>>>>> Tested with MT7530 DSA switch connected to gmac0 and ICPlus IP1001 PHY
>>>>>>>>>> connected to gmac1 of the SoC.
>>>>>>>>>>
>>>>>>>>>> Last working kernel is 5.19. The issue is present on 6.0-rc5.
>>>>>>>>>>
>>>>>>>>>> Arınç
>>>>>>>>>
>>>>>>>>> Hi Arınç,
>>>>>>>>>
>>>>>>>>> thx for testing and reporting the issue. Can you please identify
>>>>>>>>> the offending commit running git bisect?
>>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>> Lorenzo
>>>>>>>>
>>>>>>>> Hi Arınç,
>>>>>>>>
>>>>>>>> just a small update. I tested a mt7621 based board (Buffalo WSR-1166DHP) with
>>>>>>>> OpenWrt master + my mtk_eth_soc series and it works fine. Can you please
>>>>>>>> provide more details about your development board/environment?
>>>>>>>
>>>>>>> I've got a GB-PC2, Sergio has got a GB-PC1. We both use Neil's gnubee-tools
>>>>>>> which makes an image with filesystem and any Linux kernel of choice with
>>>>>>> slight modifications (maybe not at all) on the kernel.
>>>>>>>
>>>>>>> https://github.com/neilbrown/gnubee-tools
>>>>>>>
>>>>>>> Sergio experiences the same problem on GB-PC1.
>>>>>>
>>>>>> ack, can you please run git bisect in order to identify the offending commit?
>>>>>> What is the latest kernel version that is working properly? 5.19.8?
>>>>>
>>>>> I'll try to get time today to properly bisect and identify the
>>>>> offending commit. I get a working platform with 5.19.8, yes but with
>>>>> v6-rc-1 my network is totally broken.
>>>>
>>>> + [cc: Paul E. McKenney <paulmck@kernel.org> as commit author]
>>>>
>>>> Ok, so I have bisected the issue to:
>>>> 1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more patient
>>>> for RCU Tasks boot-time testing
>>>>
>>>> This is the complete bisect log:
>>>>
>>>> $ git bisect log
>>>> git bisect start
>>>> # good: [70cb6afe0e2ff1b7854d840978b1849bffb3ed21] Linux 5.19.8
>>>> git bisect good 70cb6afe0e2ff1b7854d840978b1849bffb3ed21
>>>> # bad: [568035b01cfb107af8d2e4bd2fb9aea22cf5b868] Linux 6.0-rc1
>>>> git bisect bad 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
>>>> # good: [3d7cb6b04c3f3115719235cc6866b10326de34cd] Linux 5.19
>>>> git bisect good 3d7cb6b04c3f3115719235cc6866b10326de34cd
>>>> # bad: [b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1] Merge tag
>>>> 'drm-next-2022-08-03' of git://anongit.freedesktop.org/drm/drm
>>>> git bisect bad b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1
>>>> # bad: [526942b8134cc34d25d27f95dfff98b8ce2f6fcd] Merge tag
>>>> 'ata-5.20-rc1' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
>>>> git bisect bad 526942b8134cc34d25d27f95dfff98b8ce2f6fcd
>>>> # good: [2e7a95156d64667a8ded606829d57c6fc92e41df] Merge tag
>>>> 'regmap-v5.20' of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
>>>> git bisect good 2e7a95156d64667a8ded606829d57c6fc92e41df
>>>> # good: [c013d0af81f60cc7dbe357c4e2a925fb6738dbfe] Merge tag
>>>> 'for-5.20/block-2022-07-29' of git://git.kernel.dk/linux-block
>>>> git bisect good c013d0af81f60cc7dbe357c4e2a925fb6738dbfe
>>>> # bad: [aad26f55f47a33d6de3df65f0b18e2886059ed6d] Merge tag 'docs-6.0'
>>>> of git://git.lwn.net/linux
>>>> git bisect bad aad26f55f47a33d6de3df65f0b18e2886059ed6d
>>>> # good: [c2a24a7a036b3bd3a2e6c66730dfc777cae6540a] Merge tag
>>>> 'v5.20-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
>>>> git bisect good c2a24a7a036b3bd3a2e6c66730dfc777cae6540a
>>>> # bad: [34bc7b454dc31f75a0be7ee8ab378135523d7c51] Merge branch
>>>> 'ctxt.2022.07.05a' into HEAD
>>>> git bisect bad 34bc7b454dc31f75a0be7ee8ab378135523d7c51
>>>> # bad: [e72ee5e1a866b85cb6c3d4c80a1125976020a7e8] rcu-tasks: Use
>>>> delayed_work to delay rcu_tasks_verify_self_tests()
>>>> git bisect bad e72ee5e1a866b85cb6c3d4c80a1125976020a7e8
>>>> # good: [f90f19da88bfe32dd1fdfd104de4c0526a3be701] rcu-tasks: Make RCU
>>>> Tasks Trace stall warning handle idle offline tasks
>>>> git bisect good f90f19da88bfe32dd1fdfd104de4c0526a3be701
>>>> # good: [dc7d54b45170e1e3ced9f86718aa4274fd727790] rcu-tasks: Pull in
>>>> tasks blocked within RCU Tasks Trace readers
>>>> git bisect good dc7d54b45170e1e3ced9f86718aa4274fd727790
>>>> # good: [e386b6725798eec07facedf4d4bb710c079fd25c] rcu-tasks:
>>>> Eliminate RCU Tasks Trace IPIs to online CPUs
>>>> git bisect good e386b6725798eec07facedf4d4bb710c079fd25c
>>>> # good: [eea3423b162d5d5cdc08af23e8ee2c2d1134fd07] rcu-tasks: Update comments
>>>> git bisect good eea3423b162d5d5cdc08af23e8ee2c2d1134fd07
>>>> # bad: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more
>>>> patient for RCU Tasks boot-time testing
>>>> git bisect bad 1cf1144e8473e8c3180ac8b91309e29b6acfd95f
>>>> # first bad commit: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f]
>>>> rcu-tasks: Be more patient for RCU Tasks boot-time testing
>>>>
>>>> I don't really understand the relationship with my broken network
>>>> issue. I am using debian buster and the effect I see is that when the
>>>> network interface becomes up it hangs waiting for a "task running to
>>>> raise network interfaces". After about one minute the system boots,
>>>> the login prompt is shown but I cannot configure at all network
>>>> interfaces: dhclient does not respond and manually ifconfig does not
>>>> help also:
>>>>
>>>> root@gnubee:~#
>>>> root@gnubee:~# dhclient ethblack
>>>> ^C
>>>> root@gnubee:~# ifconfig ethblack 192.168.1.101
>>>> root@gnubee:~# ping 19^C
>>>> root@gnubee:~# ping 192.168.1.47
>>>> PING 192.168.1.47 (192.168.1.47) 56(84) bytes of data.
>>>> ^C
>>>> --- 192.168.1.47 ping statistics ---
>>>> 3 packets transmitted, 0 received, 100% packet loss, time 120ms
>>>>
>>>> I have tried to revert the bad commit directly in v6.0-rc1 but
>>>> conflicts appeared with the git revert command in
>>>> 'kernel/rcu/tasks.h', so I am not sure what I can do now.
>>>
>>> I've pinpointed the issue to 23233e577ef973c2c5d0dd757a0a4605e34ecb57 ("net:
>>> ethernet: mtk_eth_soc: rely on page_pool for single page buffers"). Ethernet
>>> works fine after reverting this and newer commits for mtk_eth_soc.
>>
>> Hi Arınç,
>>
>> yes, I run some bisect here as well and this seems the offending commit. Can
>> you please try the patch below?
>>
>> Regards,
>> Lorenzo
>>
>> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> index ec617966c953..67a64a2272b9 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> @@ -1470,7 +1470,7 @@ static void mtk_update_rx_cpu_idx(struct mtk_eth *eth)
>>
>>   static bool mtk_page_pool_enabled(struct mtk_eth *eth)
>>   {
>> -       return !eth->hwlro;
>> +       return MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2);
>>   }
>>
>>   static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,
> 
> I have applied this patch on the top of v6-0-rc5 and the network is
> back, so this patch seems to fix the network issue for my GNUBee pC1:
> 
> Tested-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Can confirm the same behaviour on my GB-PC2.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Arınç
