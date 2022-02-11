Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957834B2205
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346818AbiBKJdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:33:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiBKJdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:33:41 -0500
Received: from mxout014.mail.hostpoint.ch (mxout014.mail.hostpoint.ch [IPv6:2a00:d70:0:e::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB40F5B
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:33:37 -0800 (PST)
Received: from [10.0.2.44] (helo=asmtp014.mail.hostpoint.ch)
        by mxout014.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nISJ4-000Eqm-NK; Fri, 11 Feb 2022 10:33:34 +0100
Received: from [2001:1620:50ce:1969:35bf:a597:4774:8f96]
        by asmtp014.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nISJ4-000GpJ-L4; Fri, 11 Feb 2022 10:33:34 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <26d95ad3-0190-857b-8eb2-a065bf370ddc@kupper.org>
Date:   Fri, 11 Feb 2022 10:33:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
 <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
 <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
 <603a03f4-2765-c8e7-085c-808f67b42fa9@kupper.org>
 <14d2dc72-4454-3493-20e7-ab3539854e37@amd.com>
From:   Thomas Kupper <thomas@kupper.org>
In-Reply-To: <14d2dc72-4454-3493-20e7-ab3539854e37@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 08.02.22 um 17:24 schrieb Tom Lendacky:
> On 2/7/22 11:59, Thomas Kupper wrote:
>>
>> Am 07.02.22 um 16:19 schrieb Shyam Sundar S K:
>>>
>>> On 2/7/2022 8:02 PM, Tom Lendacky wrote:
>>>> On 2/5/22 12:14, Thomas Kupper wrote:
>>>>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>>>>> On 2/5/22 04:06, Thomas Kupper wrote:
>>>>>> Reloading the module and specify the dyndbg option to get some
>>>>>> additional debug output.
>>>>>>
>>>>>> I'm adding Shyam to the thread, too, as I'm not familiar with the
>>>>>> configuration for this chip.
>>>>>>
>>>>> Right after boot:
>>>>>
>>>>> [    5.352977] amd-xgbe 0000:06:00.1 eth0: net device enabled
>>>>> [    5.354198] amd-xgbe 0000:06:00.2 eth1: net device enabled
>>>>> ...
>>>>> [    5.382185] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
>>>>> [    5.426931] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>>>>> ...
>>>>> [    9.701637] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>>>> [    9.701679] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>>>>> [    9.701715] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>>>>> [    9.738191] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>>>>> [    9.738219] amd-xgbe 0000:06:00.2 enp6s0f2: starting I2C
>>>>> ...
>>>>> [   10.742622] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox
>>>>> command did not complete
>>>>> [   10.742710] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox reset
>>>>> performed
>>>>> [   10.750813] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>>>> [   10.768366] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>>>> [   10.768371] amd-xgbe 0000:06:00.2 enp6s0f2: fixed PHY 
>>>>> configuration
>>>>>
>>>>> Then after 'ifconfig enp6s0f2 up':
>>>>>
>>>>> [  189.184928] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>>>> [  189.191828] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>>>> [  189.191863] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>>>>> [  189.191894] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>>>>> [  189.196338] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>>>>> [  189.198792] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>>>> [  189.212036] genirq: Flags mismatch irq 69. 00000000 (enp6s0f2-pcs)
>>>>> vs. 00000000 (enp6s0f2-pcs)
>>>>> [  189.221700] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
>>>>> [  189.231051] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>>>> [  189.231054] amd-xgbe 0000:06:00.2 enp6s0f2: stopping I2C
>>>>>
>>>> Please ensure that the ethtool msglvl is on for drv and probe. I was
>>>> expecting to see some additional debug messages that I don't see here.
>>>>
>>>> Also, if you can provide the lspci output for the device (using -nn 
>>>> and
>>>> -vv) that might be helpful as well.
>>>>
>>>> Shyam will be the best one to understand what is going on here.
>>> On some other platforms, we have seen similar kind of problems getting
>>> reported. There is a fix sent for validation.
>>>
>>> The root cause is that removal of xgbe driver is causing interrupt 
>>> storm
>>> on the MP2 device (Sensor Fusion Hub).
>>>
>>> Shall submit a fix soon to upstream once the validation is done, you 
>>> may
>>> give it a try with that and see if that helps.
>>>
>>> Thanks,
>>> Shyam
>>>
>>>> Thanks,
>>>> Tom
>>
>> Shyam, I will check the git logs for the relevant commit then from 
>> time to time.
>> Looking at the code diff from OPNsense and the latest Linux kernel I 
>> assumed that there would much more to do then fix a irq strom (but I 
>> have no idea about the inner working of the kernel).
>>
>> Nevermind: Setting the 'msglvl 0x3' with ethtool the following info 
>> can be found in dmesg:
>>
>> Running : $ ifconfig enp6s0f2 up
>> SIOCSIFFLAGS: Invalid argument
>>
>> ... and 'dmesg':
>>
>> [   55.177447] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0: cpu=0, node=0
>> [   55.177456] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0: 
>> dma_regs=00000000d11bf3f1, dma_irq=74, tx=00000000dd57b5c4, 
>> rx=00000000d73e70f8
>> [   55.177464] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1: cpu=1, node=0
>> [   55.177467] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1: 
>> dma_regs=000000000d972dd7, dma_irq=75, tx=00000000573bcff8, 
>> rx=000000003d9a6f65
>> [   55.177473] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2: cpu=2, node=0
>> [   55.177476] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2: 
>> dma_regs=0000000046f71179, dma_irq=76, tx=00000000897116c9, 
>> rx=0000000004ba17e7
>> [   55.177480] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0 - Tx ring:
>> [   55.177502] amd-xgbe 0000:06:00.2 enp6s0f2: 
>> rdesc=00000000794657ba, rdesc_dma=0x000000010fad8000, 
>> rdata=0000000008ace7d8, node=0
>> [   55.177507] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0 - Rx ring:
>> [   55.177523] amd-xgbe 0000:06:00.2 enp6s0f2: 
>> rdesc=000000009313d9b3, rdesc_dma=0x0000000114538000, 
>> rdata=00000000510e3b77, node=0
>> [   55.177527] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1 - Tx ring:
>> [   55.177543] amd-xgbe 0000:06:00.2 enp6s0f2: 
>> rdesc=00000000d26d9194, rdesc_dma=0x000000010a774000, 
>> rdata=00000000b9419829, node=0
>> [   55.177547] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1 - Rx ring:
>> [   55.177564] amd-xgbe 0000:06:00.2 enp6s0f2: 
>> rdesc=0000000007bf60dd, rdesc_dma=0x000000010fb84000, 
>> rdata=00000000aa48e8c0, node=0
>> [   55.177568] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2 - Tx ring:
>> [   55.177584] amd-xgbe 0000:06:00.2 enp6s0f2: 
>> rdesc=00000000e7e6c52e, rdesc_dma=0x000000010fa2a000, 
>> rdata=0000000017b5d85c, node=0
>> [   55.177587] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2 - Rx ring:
>> [   55.177603] amd-xgbe 0000:06:00.2 enp6s0f2: 
>> rdesc=000000000898fbf4, rdesc_dma=0x0000000101f08000, 
>> rdata=00000000aded7d4c, node=0
>> [   55.182366] amd-xgbe 0000:06:00.2 enp6s0f2: TXq0 mapped to TC0
>> [   55.182381] amd-xgbe 0000:06:00.2 enp6s0f2: TXq1 mapped to TC1
>> [   55.182388] amd-xgbe 0000:06:00.2 enp6s0f2: TXq2 mapped to TC2
>> [   55.182395] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO0 mapped to RXq0
>> [   55.182400] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO1 mapped to RXq0
>> [   55.182405] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO2 mapped to RXq0
>> [   55.182410] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO3 mapped to RXq1
>> [   55.182414] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO4 mapped to RXq1
>> [   55.182418] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO5 mapped to RXq1
>> [   55.182423] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO6 mapped to RXq2
>> [   55.182427] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO7 mapped to RXq2
>> [   55.182473] amd-xgbe 0000:06:00.2 enp6s0f2: 3 Tx hardware queues, 
>> 21760 byte fifo per queue
>> [   55.182501] amd-xgbe 0000:06:00.2 enp6s0f2: 3 Rx hardware queues, 
>> 21760 byte fifo per queue
>> [   55.182544] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled 
>> for RXq0
>> [   55.182550] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled 
>> for RXq1
>> [   55.182556] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled 
>> for RXq2
>> [   56.178946] amd-xgbe 0000:06:00.2 enp6s0f2: SFP detected:
>> [   56.178954] amd-xgbe 0000:06:00.2 enp6s0f2:   vendor: MikroTik
>> [   56.178958] amd-xgbe 0000:06:00.2 enp6s0f2:   part number: S+AO0005
>> [   56.178961] amd-xgbe 0000:06:00.2 enp6s0f2:   revision level: 1.0
>> [   56.178963] amd-xgbe 0000:06:00.2 enp6s0f2:   serial number: 
>> STST050B1900001
>>
>
> Ah, it's been a while since I've had to use the debug support. Could 
> you also set the module debug parameter to 0x37 (debug=0x37) when 
> loading the module. That will capture some of the debug messages that 
> are issued on driver load. Sorry about that...
>
> Thanks,
> Tom

Thanks Tom, I now got time to update to 5.17-rc3 and add the 'debug' 
module parameter. I assume that parameter works with the non-debug 
kernel? I don't really see any new messages related to the amd-xgbe driver:

dmesg right after boot:

[    0.000000] Linux version 5.17.0-rc3-tk (jane@m920q-ubu21) (gcc 
(Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37) 
#12 SMP PREEMPT Tue Feb 8 19:52:19 CET 2022
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.17.0-rc3-tk 
root=UUID=8e462830-8ba0-4061-8f23-6f29ce751792 ro console=tty0 
console=ttyS0,115200n8 amd_xgbe.dyndbg=+p amd_xgbe.debug=0x37
...
[    5.275730] amd-xgbe 0000:06:00.1 eth0: net device enabled
[    5.277766] amd-xgbe 0000:06:00.2 eth1: net device enabled
[    5.665315] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
[    5.696665] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0

dmesg right after 'ifconfig enp6s0f2 up'

[   88.843454] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-0: cpu=0, node=0
[   88.843464] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-0: dma_regs=000000001078e433, dma_irq=55, 
tx=00000000e8736669, rx=00000000fadd04ec
[   88.843474] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-1: cpu=1, node=0
[   88.843478] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-1: dma_regs=000000003c3cbea8, dma_irq=56, 
tx=000000000836d88c, rx=00000000920d02c4
[   88.843485] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-2: cpu=2, node=0
[   88.843488] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-2: dma_regs=000000008d034191, dma_irq=57, 
tx=00000000a0664378, rx=00000000d72ce726
[   88.843493] amd_xgbe:xgbe_alloc_ring_resources: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-0 - Tx ring:
[   88.843514] amd_xgbe:xgbe_init_ring: amd-xgbe 0000:06:00.2 enp6s0f2: 
rdesc=00000000c6703013, rdesc_dma=0x0000000101c44000, 
rdata=0000000029951e4c, node=0
[   88.843519] amd_xgbe:xgbe_alloc_ring_resources: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-0 - Rx ring:
[   88.843537] amd_xgbe:xgbe_init_ring: amd-xgbe 0000:06:00.2 enp6s0f2: 
rdesc=000000003262c446, rdesc_dma=0x0000000103c74000, 
rdata=000000001b7a4275, node=0
[   88.843542] amd_xgbe:xgbe_alloc_ring_resources: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-1 - Tx ring:
[   88.843560] amd_xgbe:xgbe_init_ring: amd-xgbe 0000:06:00.2 enp6s0f2: 
rdesc=000000007ce3cc7e, rdesc_dma=0x00000001023c0000, 
rdata=00000000c0fc51d9, node=0
[   88.843565] amd_xgbe:xgbe_alloc_ring_resources: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-1 - Rx ring:
[   88.843583] amd_xgbe:xgbe_init_ring: amd-xgbe 0000:06:00.2 enp6s0f2: 
rdesc=00000000448612df, rdesc_dma=0x00000001185b6000, 
rdata=00000000a23b7f86, node=0
[   88.843587] amd_xgbe:xgbe_alloc_ring_resources: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-2 - Tx ring:
[   88.843606] amd_xgbe:xgbe_init_ring: amd-xgbe 0000:06:00.2 enp6s0f2: 
rdesc=00000000e509050e, rdesc_dma=0x0000000104db2000, 
rdata=000000000d605e1a, node=0
[   88.843610] amd_xgbe:xgbe_alloc_ring_resources: amd-xgbe 0000:06:00.2 
enp6s0f2: channel-2 - Rx ring:
[   88.843629] amd_xgbe:xgbe_init_ring: amd-xgbe 0000:06:00.2 enp6s0f2: 
rdesc=00000000436c5cc6, rdesc_dma=0x0000000114aaa000, 
rdata=00000000246ed062, node=0
[   88.848416] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: TXq0 mapped to TC0
[   88.848432] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: TXq1 mapped to TC1
[   88.848440] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: TXq2 mapped to TC2
[   88.848449] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: PRIO0 mapped to RXq0
[   88.848455] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: PRIO1 mapped to RXq0
[   88.848461] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: PRIO2 mapped to RXq0
[   88.848467] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: PRIO3 mapped to RXq1
[   88.848472] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: PRIO4 mapped to RXq1
[   88.848478] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: PRIO5 mapped to RXq1
[   88.848483] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: PRIO6 mapped to RXq2
[   88.848489] amd_xgbe:xgbe_config_queue_mapping: amd-xgbe 0000:06:00.2 
enp6s0f2: PRIO7 mapped to RXq2
[   88.848536] amd-xgbe 0000:06:00.2 enp6s0f2: 3 Tx hardware queues, 
21760 byte fifo per queue
[   88.848565] amd-xgbe 0000:06:00.2 enp6s0f2: 3 Rx hardware queues, 
21760 byte fifo per queue
[   88.848609] amd_xgbe:xgbe_enable_tx_flow_control: amd-xgbe 
0000:06:00.2 enp6s0f2: flow control enabled for RXq0
[   88.848619] amd_xgbe:xgbe_enable_tx_flow_control: amd-xgbe 
0000:06:00.2 enp6s0f2: flow control enabled for RXq1
[   88.848627] amd_xgbe:xgbe_enable_tx_flow_control: amd-xgbe 
0000:06:00.2 enp6s0f2: flow control enabled for RXq2
[   89.862558] amd_xgbe:xgbe_phy_sfp_eeprom_info: amd-xgbe 0000:06:00.2 
enp6s0f2: SFP detected:
[   89.862567] amd_xgbe:xgbe_phy_sfp_eeprom_info: amd-xgbe 0000:06:00.2 
enp6s0f2:   vendor:         MikroTik
[   89.862572] amd_xgbe:xgbe_phy_sfp_eeprom_info: amd-xgbe 0000:06:00.2 
enp6s0f2:   part number:    S+AO0005
[   89.862576] amd_xgbe:xgbe_phy_sfp_eeprom_info: amd-xgbe 0000:06:00.2 
enp6s0f2:   revision level: 1.0
[   89.862580] amd_xgbe:xgbe_phy_sfp_eeprom_info: amd-xgbe 0000:06:00.2 
enp6s0f2:   serial number:  STST050B1900001

again, dmesg diff after 'rmmod':

[  127.068380] ------------[ cut here ]------------
[  127.068386] remove_proc_entry: removing non-empty directory 'irq/53', 
leaking at least 'enp6s0f2-i2c'
[  127.068398] WARNING: CPU: 4 PID: 803 at fs/proc/generic.c:715 
remove_proc_entry+0x196/0x1b0
[  127.068411] Modules linked in: nls_iso8859_1 intel_rapl_msr 
intel_rapl_common snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi 
edac_mce_amd snd_hda_codec snd_hda_core snd_hwdep snd_pcm kvm snd_timer 
snd_rn_pci_acp3x snd rapl efi_pstore k10temp soundcore snd_pci_acp3x ccp 
mac_hid sch_fq_codel msr drm ip_tables x_tables autofs4 btrfs 
blake2b_generic zstd_compress raid10 raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 
raid0 multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel 
aesni_intel crypto_simd igb nvme cryptd dca xhci_pci amd_xgbe(-) 
i2c_piix4 i2c_amd_mp2_pci xhci_pci_renesas nvme_core i2c_algo_bit video 
spi_amd
[  127.068485] CPU: 4 PID: 803 Comm: rmmod Not tainted 5.17.0-rc3-tk #12
[  127.068490] Hardware name: Deciso B.V. DEC2700 - OPNsense 
Appliance/Netboard-A10 Gen.3, BIOS 05.32.50.0012-A10.20 11/15/2021
[  127.068493] RIP: 0010:remove_proc_entry+0x196/0x1b0
[  127.068499] Code: 60 50 5e 84 48 85 c0 48 8d 90 78 ff ff ff 48 0f 45 
c2 49 8b 54 24 78 4c 8b 80 a0 00 00 00 48 8b 92 a0 00 00 00 e8 38 56 81 
00 <0f> 0b e9 44 ff ff ff e8 9e c0 87 00 66 66 2e 0f 1f 84 00 00 00 00
[  127.068502] RSP: 0018:ffffaf2940fffb60 EFLAGS: 00010286
[  127.068506] RAX: 0000000000000000 RBX: ffff91fa4022ed80 RCX: 
0000000000000000
[  127.068509] RDX: 0000000000000001 RSI: ffffffff845bf281 RDI: 
00000000ffffffff
[  127.068511] RBP: ffffaf2940fffb90 R08: 0000000000000000 R09: 
ffffaf2940fff950
[  127.068513] R10: ffffaf2940fff948 R11: ffffffff84f55f48 R12: 
ffff91fa44e8c540
[  127.068515] R13: ffff91fa44e8c5c0 R14: 0000000000000036 R15: 
0000000000000036
[  127.068517] FS:  00007f3a68f9c400(0000) GS:ffff91fa6af00000(0000) 
knlGS:0000000000000000
[  127.068520] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  127.068522] CR2: 00007fd6c2e7fd04 CR3: 0000000104ee0000 CR4: 
00000000003506e0
[  127.068525] Call Trace:
[  127.068528]  <TASK>
[  127.068534]  unregister_irq_proc+0xe4/0x110
[  127.068541]  free_desc+0x2e/0x70
[  127.068546]  irq_free_descs+0x50/0x80
[  127.068550]  irq_domain_free_irqs+0x16b/0x1c0
[  127.068554]  __msi_domain_free_irqs+0xf1/0x160
[  127.068560]  msi_domain_free_irqs_descs_locked+0x20/0x50
[  127.068565]  pci_msi_teardown_msi_irqs+0x49/0x50
[  127.068571]  pci_disable_msix.part.0+0xff/0x160
[  127.068575]  pci_free_irq_vectors+0x45/0x60
[  127.068578]  xgbe_pci_remove+0x24/0x40 [amd_xgbe]
[  127.068596]  pci_device_remove+0x39/0xa0
[  127.068602]  __device_release_driver+0x181/0x250
[  127.068608]  driver_detach+0xd3/0x120
[  127.068612]  bus_remove_driver+0x59/0xd0
[  127.068615]  driver_unregister+0x31/0x50
[  127.068619]  pci_unregister_driver+0x40/0x90
[  127.068623]  xgbe_pci_exit+0x15/0x20 [amd_xgbe]
[  127.068639]  xgbe_mod_exit+0x9/0x880 [amd_xgbe]
[  127.068654]  __do_sys_delete_module.constprop.0+0x183/0x290
[  127.068660]  ? exit_to_user_mode_prepare+0x49/0x1e0
[  127.068666]  __x64_sys_delete_module+0x12/0x20
[  127.068670]  do_syscall_64+0x5c/0xc0
[  127.068676]  ? irqentry_exit_to_user_mode+0x9/0x20
[  127.068681]  ? irqentry_exit+0x33/0x40
[  127.068685]  ? exc_page_fault+0x89/0x180
[  127.068689]  ? asm_exc_page_fault+0x8/0x30
[  127.068694]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  127.068697] RIP: 0033:0x7f3a690cb8eb
[  127.068702] Code: 73 01 c3 48 8b 0d 45 e5 0e 00 f7 d8 64 89 01 48 83 
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 15 e5 0e 00 f7 d8 64 89 01 48
[  127.068704] RSP: 002b:00007ffed553a818 EFLAGS: 00000206 ORIG_RAX: 
00000000000000b0
[  127.068708] RAX: ffffffffffffffda RBX: 00007f3a6a02e7b0 RCX: 
00007f3a690cb8eb
[  127.068710] RDX: 000000000000000a RSI: 0000000000000800 RDI: 
00007f3a6a02e818
[  127.068712] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[  127.068714] R10: 00007f3a69163ac0 R11: 0000000000000206 R12: 
00007ffed553aa70
[  127.068716] R13: 00007ffed553b84a R14: 00007f3a6a02e2a0 R15: 
00007f3a6a02e7b0
[  127.068722]  </TASK>
[  127.068723] ---[ end trace 0000000000000000 ]---
[  127.068744] ------------[ cut here ]------------
[  127.068746] remove_proc_entry: removing non-empty directory 'irq/54', 
leaking at least 'enp6s0f2-pcs'
[  127.068755] WARNING: CPU: 4 PID: 803 at fs/proc/generic.c:715 
remove_proc_entry+0x196/0x1b0
[  127.068761] Modules linked in: nls_iso8859_1 intel_rapl_msr 
intel_rapl_common snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi 
edac_mce_amd snd_hda_codec snd_hda_core snd_hwdep snd_pcm kvm snd_timer 
snd_rn_pci_acp3x snd rapl efi_pstore k10temp soundcore snd_pci_acp3x ccp 
mac_hid sch_fq_codel msr drm ip_tables x_tables autofs4 btrfs 
blake2b_generic zstd_compress raid10 raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 
raid0 multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel 
aesni_intel crypto_simd igb nvme cryptd dca xhci_pci amd_xgbe(-) 
i2c_piix4 i2c_amd_mp2_pci xhci_pci_renesas nvme_core i2c_algo_bit video 
spi_amd
[  127.068810] CPU: 4 PID: 803 Comm: rmmod Tainted: G W         
5.17.0-rc3-tk #12
[  127.068814] Hardware name: Deciso B.V. DEC2700 - OPNsense 
Appliance/Netboard-A10 Gen.3, BIOS 05.32.50.0012-A10.20 11/15/2021
[  127.068815] RIP: 0010:remove_proc_entry+0x196/0x1b0
[  127.068820] Code: 60 50 5e 84 48 85 c0 48 8d 90 78 ff ff ff 48 0f 45 
c2 49 8b 54 24 78 4c 8b 80 a0 00 00 00 48 8b 92 a0 00 00 00 e8 38 56 81 
00 <0f> 0b e9 44 ff ff ff e8 9e c0 87 00 66 66 2e 0f 1f 84 00 00 00 00
[  127.068822] RSP: 0018:ffffaf2940fffb60 EFLAGS: 00010286
[  127.068825] RAX: 0000000000000000 RBX: ffff91fa4022ed80 RCX: 
0000000000000000
[  127.068827] RDX: 0000000000000001 RSI: ffffffff845bf281 RDI: 
00000000ffffffff
[  127.068829] RBP: ffffaf2940fffb90 R08: 0000000000000000 R09: 
ffffaf2940fff950
[  127.068830] R10: ffffaf2940fff948 R11: ffffffff84f55f48 R12: 
ffff91fa4eca7000
[  127.068832] R13: ffff91fa4eca7080 R14: 0000000000000037 R15: 
0000000000000037
[  127.068834] FS:  00007f3a68f9c400(0000) GS:ffff91fa6af00000(0000) 
knlGS:0000000000000000
[  127.068837] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  127.068839] CR2: 00007fd6c2e7fd04 CR3: 0000000104ee0000 CR4: 
00000000003506e0
[  127.068841] Call Trace:
[  127.068842]  <TASK>
[  127.068844]  unregister_irq_proc+0xe4/0x110
[  127.068849]  free_desc+0x2e/0x70
[  127.068852]  irq_free_descs+0x50/0x80
[  127.068856]  irq_domain_free_irqs+0x16b/0x1c0
[  127.068860]  __msi_domain_free_irqs+0xf1/0x160
[  127.068865]  msi_domain_free_irqs_descs_locked+0x20/0x50
[  127.068870]  pci_msi_teardown_msi_irqs+0x49/0x50
[  127.068873]  pci_disable_msix.part.0+0xff/0x160
[  127.068877]  pci_free_irq_vectors+0x45/0x60
[  127.068881]  xgbe_pci_remove+0x24/0x40 [amd_xgbe]
[  127.068896]  pci_device_remove+0x39/0xa0
[  127.068900]  __device_release_driver+0x181/0x250
[  127.068904]  driver_detach+0xd3/0x120
[  127.068908]  bus_remove_driver+0x59/0xd0
[  127.068911]  driver_unregister+0x31/0x50
[  127.068914]  pci_unregister_driver+0x40/0x90
[  127.068919]  xgbe_pci_exit+0x15/0x20 [amd_xgbe]
[  127.068933]  xgbe_mod_exit+0x9/0x880 [amd_xgbe]
[  127.068948]  __do_sys_delete_module.constprop.0+0x183/0x290
[  127.068952]  ? exit_to_user_mode_prepare+0x49/0x1e0
[  127.068957]  __x64_sys_delete_module+0x12/0x20
[  127.068961]  do_syscall_64+0x5c/0xc0
[  127.068964]  ? irqentry_exit_to_user_mode+0x9/0x20
[  127.068969]  ? irqentry_exit+0x33/0x40
[  127.068973]  ? exc_page_fault+0x89/0x180
[  127.068977]  ? asm_exc_page_fault+0x8/0x30
[  127.068980]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  127.068983] RIP: 0033:0x7f3a690cb8eb
[  127.068985] Code: 73 01 c3 48 8b 0d 45 e5 0e 00 f7 d8 64 89 01 48 83 
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 15 e5 0e 00 f7 d8 64 89 01 48
[  127.068987] RSP: 002b:00007ffed553a818 EFLAGS: 00000206 ORIG_RAX: 
00000000000000b0
[  127.068990] RAX: ffffffffffffffda RBX: 00007f3a6a02e7b0 RCX: 
00007f3a690cb8eb
[  127.068991] RDX: 000000000000000a RSI: 0000000000000800 RDI: 
00007f3a6a02e818
[  127.068993] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[  127.068994] R10: 00007f3a69163ac0 R11: 0000000000000206 R12: 
00007ffed553aa70
[  127.068996] R13: 00007ffed553b84a R14: 00007f3a6a02e2a0 R15: 
00007f3a6a02e7b0
[  127.068999]  </TASK>
[  127.069000] ---[ end trace 0000000000000000 ]---
[  127.667264] irq 31: nobody cared (try booting with the "irqpoll" option)
[  127.674758] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G W         
5.17.0-rc3-tk #12
[  127.674764] Hardware name: Deciso B.V. DEC2700 - OPNsense 
Appliance/Netboard-A10 Gen.3, BIOS 05.32.50.0012-A10.20 11/15/2021
[  127.674766] Call Trace:
[  127.674769]  <IRQ>
[  127.674773]  dump_stack_lvl+0x4c/0x63
[  127.674781]  dump_stack+0x10/0x12
[  127.674784]  __report_bad_irq+0x3a/0xaf
[  127.674789]  note_interrupt.cold+0xb/0x60
[  127.674793]  ? __this_cpu_preempt_check+0x13/0x20
[  127.674799]  handle_irq_event+0x71/0x80
[  127.674805]  handle_fasteoi_irq+0x95/0x1e0
[  127.674810]  __common_interrupt+0x6e/0x110
[  127.674815]  common_interrupt+0xbd/0xe0
[  127.674819]  </IRQ>
[  127.674820]  <TASK>
[  127.674822]  asm_common_interrupt+0x1e/0x40
[  127.674826] RIP: 0010:cpuidle_enter_state+0xdf/0x380
[  127.674834] Code: ff e8 25 76 73 ff 80 7d d7 00 74 17 9c 58 0f 1f 44 
00 00 f6 c4 02 0f 85 82 02 00 00 31 ff e8 18 8c 7a ff fb 66 0f 1f 44 00 
00 <45> 85 ff 0f 88 1a 01 00 00 49 63 d7 4c 89 f1 48 2b 4d c8 48 8d 04
[  127.674837] RSP: 0018:ffffaf29400e3e68 EFLAGS: 00000246
[  127.674841] RAX: ffff91fa6af00000 RBX: 0000000000000002 RCX: 
000000000000001f
[  127.674843] RDX: 0000000000000000 RSI: ffffffff845bf281 RDI: 
ffffffff845cddcf
[  127.674845] RBP: ffffaf29400e3ea0 R08: 0000001db98fd21c R09: 
0000001d7b8fd3fc
[  127.674847] R10: 0000000000000001 R11: ffff91fa6af2fd84 R12: 
ffff91fa41de6c00
[  127.674849] R13: ffffffff8506e4c0 R14: 0000001db98fd21c R15: 
0000000000000002
[  127.674854]  ? cpuidle_enter_state+0xbb/0x380
[  127.674860]  cpuidle_enter+0x2e/0x40
[  127.674864]  do_idle+0x203/0x290
[  127.674869]  cpu_startup_entry+0x20/0x30
[  127.674872]  start_secondary+0x118/0x150
[  127.674877]  secondary_startup_64_no_verify+0xd5/0xdb
[  127.674885]  </TASK>
[  127.674886] handlers:
[  127.677425] [<00000000b61e344c>] amd_mp2_irq_isr [i2c_amd_mp2_pci]
[  127.684335] Disabling IRQ #31

and command line output after 'modprobe -vvv amd_xgbe':

jane@dec740-ubu21:~$ sudo modprobe -vvv amd_xgbe
modprobe: INFO: ../libkmod/libkmod.c:365 kmod_set_log_fn() custom 
logging function 0x7f74d79de780 registered
modprobe: DEBUG: ../libkmod/libkmod-index.c:757 index_mm_open() 
file=/lib/modules/5.17.0-rc3-tk/modules.dep.bin
modprobe: DEBUG: ../libkmod/libkmod-index.c:757 index_mm_open() 
file=/lib/modules/5.17.0-rc3-tk/modules.alias.bin
modprobe: DEBUG: ../libkmod/libkmod-index.c:757 index_mm_open() 
file=/lib/modules/5.17.0-rc3-tk/modules.symbols.bin
modprobe: DEBUG: ../libkmod/libkmod-index.c:757 index_mm_open() 
file=/lib/modules/5.17.0-rc3-tk/modules.builtin.alias.bin
modprobe: DEBUG: ../libkmod/libkmod-index.c:757 index_mm_open() 
file=/lib/modules/5.17.0-rc3-tk/modules.builtin.bin
modprobe: DEBUG: ../libkmod/libkmod-module.c:556 
kmod_module_new_from_lookup() input alias=amd_xgbe, normalized=amd_xgbe
modprobe: DEBUG: ../libkmod/libkmod-module.c:562 
kmod_module_new_from_lookup() lookup modules.dep amd_xgbe
modprobe: DEBUG: ../libkmod/libkmod.c:595 kmod_search_moddep() use 
mmaped index 'modules.dep' modname=amd_xgbe
modprobe: DEBUG: ../libkmod/libkmod.c:403 kmod_pool_get_module() get 
module name='amd_xgbe' found=(nil)
modprobe: DEBUG: ../libkmod/libkmod.c:411 kmod_pool_add_module() add 
0x7f74d83862a0 key='amd_xgbe'
modprobe: DEBUG: ../libkmod/libkmod-module.c:202 
kmod_module_parse_depline() 0 dependencies for amd_xgbe
modprobe: DEBUG: ../libkmod/libkmod-module.c:589 
kmod_module_new_from_lookup() lookup amd_xgbe=0, list=0x7f74d8385c40
modprobe: DEBUG: ../libkmod/libkmod.c:500 lookup_builtin_file() use 
mmaped index 'modules.builtin' modname=amd_xgbe
modprobe: DEBUG: ../libkmod/libkmod-module.c:1760 
kmod_module_get_initstate() could not open 
'/sys/module/amd_xgbe/initstate': No such file or directory
modprobe: DEBUG: ../libkmod/libkmod-module.c:1770 
kmod_module_get_initstate() could not open '/sys/module/amd_xgbe': No 
such file or directory
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=snd_pcsp mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=snd_usb_audio mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=cx88_alsa mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=snd_atiixp_modem mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=snd_intel8x0m mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=snd_via82xx_modem mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=amd_xgbe mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1409 
kmod_module_get_options() passed = modname=amd_xgbe mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=md_mod mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=bonding mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=dummy mod->name=amd_xgbe mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=amd_xgbe mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1409 
kmod_module_get_options() passed = modname=amd_xgbe mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1404 
kmod_module_get_options() modname=amd_xgbe mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1409 
kmod_module_get_options() passed = modname=amd_xgbe mod->name=amd_xgbe 
mod->alias=(null)
modprobe: DEBUG: ../libkmod/libkmod-module.c:1760 
kmod_module_get_initstate() could not open 
'/sys/module/amd_xgbe/initstate': No such file or directory
modprobe: DEBUG: ../libkmod/libkmod-module.c:1770 
kmod_module_get_initstate() could not open '/sys/module/amd_xgbe': No 
such file or directory
modprobe: DEBUG: ../libkmod/libkmod-module.c:750 kmod_module_get_path() 
name='amd_xgbe' 
path='/lib/modules/5.17.0-rc3-tk/kernel/drivers/net/ethernet/amd/xgbe/amd-xgbe.ko'
modprobe: DEBUG: ../libkmod/libkmod-module.c:750 kmod_module_get_path() 
name='amd_xgbe' 
path='/lib/modules/5.17.0-rc3-tk/kernel/drivers/net/ethernet/amd/xgbe/amd-xgbe.ko'
insmod 
/lib/modules/5.17.0-rc3-tk/kernel/drivers/net/ethernet/amd/xgbe/amd-xgbe.ko 
dyndbg="+pfm" debug=0x37 dyndbg=+p debug=0x37
modprobe: DEBUG: ../libkmod/libkmod-module.c:750 kmod_module_get_path() 
name='amd_xgbe' 
path='/lib/modules/5.17.0-rc3-tk/kernel/drivers/net/ethernet/amd/xgbe/amd-xgbe.ko'
modprobe: DEBUG: ../libkmod/libkmod-module.c:468 kmod_module_unref() 
kmod_module 0x7f74d83862a0 released
modprobe: DEBUG: ../libkmod/libkmod.c:419 kmod_pool_del_module() del 
0x7f74d83862a0 key='amd_xgbe'
modprobe: INFO: ../libkmod/libkmod.c:332 kmod_unref() context 
0x7f74d83854c0 released

and the corresponding dmesg diff:

[  151.599892] amd-xgbe 0000:06:00.1 eth0: net device enabled
[  151.601333] amd-xgbe 0000:06:00.2 eth1: net device enabled
[  151.606044] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
[  151.646262] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1


Cheers
Thomas

