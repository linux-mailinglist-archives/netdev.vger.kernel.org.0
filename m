Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDF84B2BF2
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352247AbiBKRmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:42:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352238AbiBKRmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:42:03 -0500
Received: from mxout014.mail.hostpoint.ch (mxout014.mail.hostpoint.ch [IPv6:2a00:d70:0:e::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D40DC69
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:42:00 -0800 (PST)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout014.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nIZvh-000PfO-TD; Fri, 11 Feb 2022 18:41:57 +0100
Received: from [2001:1620:50ce:1969:31c9:b7d0:104f:3f3]
        by asmtp013.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nIZvh-0009Uu-OW; Fri, 11 Feb 2022 18:41:57 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <5efe4499-0ef1-9575-4c6d-b07a0d9df757@kupper.org>
Date:   Fri, 11 Feb 2022 18:41:57 +0100
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
 <26d95ad3-0190-857b-8eb2-a065bf370ddc@kupper.org>
 <cee9f8ff-7611-a09f-a8fe-58bcf7143639@amd.com>
 <57cf8ba6-98a7-5d4a-76d0-4b533da06819@amd.com>
From:   Thomas Kupper <thomas@kupper.org>
In-Reply-To: <57cf8ba6-98a7-5d4a-76d0-4b533da06819@amd.com>
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


Am 11.02.22 um 16:48 schrieb Tom Lendacky:
> On 2/11/22 03:49, Shyam Sundar S K wrote:
>> On 2/11/2022 3:03 PM, Thomas Kupper wrote:
>>> Am 08.02.22 um 17:24 schrieb Tom Lendacky:
>>>> On 2/7/22 11:59, Thomas Kupper wrote:
>>>>> Am 07.02.22 um 16:19 schrieb Shyam Sundar S K:
>>>>>> On 2/7/2022 8:02 PM, Tom Lendacky wrote:
>>>>>>> On 2/5/22 12:14, Thomas Kupper wrote:
>>>>>>>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>>>>>>>> On 2/5/22 04:06, Thomas Kupper wrote:
>
>>>
>>> Thanks Tom, I now got time to update to 5.17-rc3 and add the 'debug'
>>> module parameter. I assume that parameter works with the non-debug
>>> kernel? I don't really see any new messages related to the amd-xgbe 
>>> driver:
>>>
>>> dmesg right after boot:
>>>
>>> [    0.000000] Linux version 5.17.0-rc3-tk (jane@m920q-ubu21) (gcc
>>> (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37)
>>> #12 SMP PREEMPT Tue Feb 8 19:52:19 CET 2022
>>> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.17.0-rc3-tk
>>> root=UUID=8e462830-8ba0-4061-8f23-6f29ce751792 ro console=tty0
>>> console=ttyS0,115200n8 amd_xgbe.dyndbg=+p amd_xgbe.debug=0x37
>>> ...
>>> [    5.275730] amd-xgbe 0000:06:00.1 eth0: net device enabled
>>> [    5.277766] amd-xgbe 0000:06:00.2 eth1: net device enabled
>>> [    5.665315] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>>> [    5.696665] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
>
> Hmmm... that's strange. There should have been some messages issued by 
> the
> xgbe-phy-v2.c file from the xgbe_phy_init() routine.
>
> Thomas, if you're up for a bit of kernel hacking, can you remove the
> "if (netif_msg_probe(pdata)) {" that wrap the dev_dbg() calls in the
> xgbe-phy-v2.c file? There are 5 locations.
>
Thanks Tom,

I did try dyndbg with another the Intel igb module to make sure there's 
nothing wrong with my setup ... and that worked fine.
I then replace all 'if (netif_msg_probe(pdata))' with 'if (1)' in the 
AMD XGBE code. Now we got some debug messages:

[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.17.0-rc3-tk 
root=UUID=8e462830-8ba0-4061-8f23-6f29ce751792 ro console=tty0 
console=ttyS0,115200n8 debug amd_xgbe.dyndbg=+p amd_xgbe.debug=0x37
[    0.021516] Kernel command line: 
BOOT_IMAGE=/boot/vmlinuz-5.17.0-rc3-tk 
root=UUID=8e462830-8ba0-4061-8f23-6f29ce751792 ro console=tty0 
console=ttyS0,115200n8 debug amd_xgbe.dyndbg=+p amd_xgbe.debug=0x37
...
[    5.425856] amd-xgbe 0000:06:00.1: xgmac_regs = 0000000090a80b23
[    5.432628] amd-xgbe 0000:06:00.1: xprop_regs = 00000000d329c23a
[    5.448610] amd-xgbe 0000:06:00.1: xi2c_regs  = 000000003612f52a
[    5.463393] amd-xgbe 0000:06:00.1: xpcs_regs  = 0000000091508acb
[    5.475558] amd-xgbe 0000:06:00.1: xpcs window def  = 0x00001060
[    5.488971] amd-xgbe 0000:06:00.1: xpcs window sel  = 0x00001064
[    5.500838] amd-xgbe 0000:06:00.1: xpcs window      = 0x0000b000
[    5.511736] amd-xgbe 0000:06:00.1: xpcs window size = 0x00001000
[    5.522924] amd-xgbe 0000:06:00.1: xpcs window mask = 0x00000fff
[    5.522948] amd-xgbe 0000:06:00.1: port property 0 = 0x15800800
[    5.535474] amd-xgbe 0000:06:00.1: port property 1 = 0x03030303
[    5.550344] amd-xgbe 0000:06:00.1: port property 2 = 0x00040004
[    5.550346] amd-xgbe 0000:06:00.1: port property 3 = 0x2dc0e100
[    5.564845] amd-xgbe 0000:06:00.1: port property 4 = 0x00001c03
[    5.578070] amd-xgbe 0000:06:00.1: max tx/rx channel count = 3/3
[    5.578072] amd-xgbe 0000:06:00.1: max tx/rx hw queue count = 3/3
[    5.593733] amd-xgbe 0000:06:00.1: Hardware features:
[    5.609665] amd-xgbe 0000:06:00.1:   1GbE support              : yes
[    5.624537] amd-xgbe 0000:06:00.1:   VLAN hash filter          : yes
[    5.635628] amd-xgbe 0000:06:00.1:   MDIO interface            : yes
[    5.635630] amd-xgbe 0000:06:00.1:   Wake-up packet support    : no
[    5.649437] amd-xgbe 0000:06:00.1:   Magic packet support      : no
[    5.649439] amd-xgbe 0000:06:00.1:   Management counters       : yes
[    5.649440] amd-xgbe 0000:06:00.1:   ARP offload               : yes
[    5.661697] amd-xgbe 0000:06:00.1:   IEEE 1588-2008 Timestamp  : yes
[    5.661698] amd-xgbe 0000:06:00.1:   Energy Efficient Ethernet : yes
[    5.719737] amd-xgbe 0000:06:00.1:   TX checksum offload       : yes
[    5.726837] amd-xgbe 0000:06:00.1:   RX checksum offload       : yes
[    5.733934] amd-xgbe 0000:06:00.1:   Additional MAC addresses  : 31
[    5.740937] amd-xgbe 0000:06:00.1:   Timestamp source          : 
internal/external
[    5.749393] amd-xgbe 0000:06:00.1:   SA/VLAN insertion         : yes
[    5.756493] amd-xgbe 0000:06:00.1:   VXLAN/NVGRE support       : yes
[    5.763592] amd-xgbe 0000:06:00.1:   RX fifo size              : 65536
[    5.770882] amd-xgbe 0000:06:00.1:   TX fifo size              : 65536
[    5.778177] amd-xgbe 0000:06:00.1:   IEEE 1588 high word       : yes
[    5.785274] amd-xgbe 0000:06:00.1:   DMA width                 : 48
[    5.792276] amd-xgbe 0000:06:00.1:   Data Center Bridging      : yes
[    5.799375] amd-xgbe 0000:06:00.1:   Split header              : yes
[    5.806475] amd-xgbe 0000:06:00.1:   TCP Segmentation Offload  : yes
[    5.813572] amd-xgbe 0000:06:00.1:   Debug memory interface    : yes
[    5.820671] amd-xgbe 0000:06:00.1:   Receive Side Scaling      : yes
[    5.827771] amd-xgbe 0000:06:00.1:   Traffic Class count       : 3
[    5.834676] amd-xgbe 0000:06:00.1:   Hash table size           : 256
[    5.841773] amd-xgbe 0000:06:00.1:   L3/L4 Filters             : 8
[    5.848679] amd-xgbe 0000:06:00.1:   RX queue count            : 3
[    5.855583] amd-xgbe 0000:06:00.1:   TX queue count            : 3
[    5.862484] amd-xgbe 0000:06:00.1:   RX DMA channel count      : 3
[    5.869387] amd-xgbe 0000:06:00.1:   TX DMA channel count      : 3
[    5.876292] amd-xgbe 0000:06:00.1:   PPS outputs               : 0
[    5.883198] amd-xgbe 0000:06:00.1:   Auxiliary snapshot inputs : 0
[    5.890103] amd-xgbe 0000:06:00.1: TX/RX DMA channel count = 3/3
[    5.896815] amd-xgbe 0000:06:00.1: TX/RX hardware queue count = 3/3
[    5.903814] amd-xgbe 0000:06:00.1: max tx/rx max fifo size = 65536/65536
[    5.911499] amd-xgbe 0000:06:00.1: multi MSI-X interrupts enabled
[    5.918323] amd-xgbe 0000:06:00.1:  dev irq=59
[    5.923349] amd-xgbe 0000:06:00.1:  ecc irq=60
[    5.928316] amd-xgbe 0000:06:00.1:  i2c irq=61
[    5.933290] amd-xgbe 0000:06:00.1:   an irq=62
[    5.938268] amd-xgbe 0000:06:00.1:  dma0 irq=63
[    5.943335] amd-xgbe 0000:06:00.1:  dma1 irq=64
[    5.948404] amd-xgbe 0000:06:00.1:  dma2 irq=65
[    5.953529] amd-xgbe 0000:06:00.1: adjusted TX/RX DMA channel count = 3/3
[    5.961149] amd-xgbe 0000:06:00.1: I2C features: MAX_SPEED_MODE=2, 
RX_BUFFER_DEPTH=15, TX_BUFFER_DEPTH=15
[    5.971905] amd-xgbe 0000:06:00.1: port mode=8
[    5.976880] amd-xgbe 0000:06:00.1: port id=0
[    5.987690] amd-xgbe 0000:06:00.1: port speeds=0x16
[    5.987695] amd-xgbe 0000:06:00.1: conn type=1
[    6.004349] amd-xgbe 0000:06:00.1: mdio addr=0
[    6.009320] amd-xgbe 0000:06:00.1: redrv present
[    6.014487] amd-xgbe 0000:06:00.1: redrv i/f=0
[    6.019459] amd-xgbe 0000:06:00.1: redrv addr=0x0
[    6.024720] amd-xgbe 0000:06:00.1: redrv lane=0
[    6.029791] amd-xgbe 0000:06:00.1: redrv model=0
[    6.039430] amd-xgbe 0000:06:00.1: SFP: mux_address=0x73
[    6.050427] amd-xgbe 0000:06:00.1: SFP: mux_channel=0
[    6.063769] amd-xgbe 0000:06:00.1: SFP: gpio_address=0x21
[    6.077779] amd-xgbe 0000:06:00.1: SFP: gpio_mask=0x2
[    6.089176] amd-xgbe 0000:06:00.1: SFP: gpio_rx_los=13
[    6.103384] amd-xgbe 0000:06:00.1: SFP: gpio_tx_fault=14
[    6.109326] amd-xgbe 0000:06:00.1: SFP: gpio_mod_absent=12
[    6.115461] amd-xgbe 0000:06:00.1: SFP: gpio_rate_select=0
[    6.121600] amd-xgbe 0000:06:00.1: phy 
supported=0x0000000,00000000,000064c0
[    6.130337] amd-xgbe 0000:06:00.1 eth1: net device enabled
[    6.136645] amd-xgbe 0000:06:00.2: xgmac_regs = 00000000013cde0a
[    6.147680] amd-xgbe 0000:06:00.2: xprop_regs = 00000000c2a793ff
[    6.159477] amd-xgbe 0000:06:00.2: xi2c_regs  = 00000000cfbf31f0
[    6.173891] amd-xgbe 0000:06:00.2: xpcs_regs  = 00000000a1eda099
[    6.188606] amd-xgbe 0000:06:00.2: xpcs window def  = 0x00001060
[    6.209526] amd-xgbe 0000:06:00.2: xpcs window sel  = 0x00001064
[    6.216248] amd-xgbe 0000:06:00.2: xpcs window      = 0x0000b000
[    6.222967] amd-xgbe 0000:06:00.2: xpcs window size = 0x00001000
[    6.229687] amd-xgbe 0000:06:00.2: xpcs window mask = 0x00000fff
[    6.240916] amd-xgbe 0000:06:00.2: port property 0 = 0x15800801
[    6.252578] amd-xgbe 0000:06:00.2: port property 1 = 0x03030303
[    6.266891] amd-xgbe 0000:06:00.2: port property 2 = 0x00040004
[    6.281498] amd-xgbe 0000:06:00.2: port property 3 = 0x2980a100
[    6.293861] amd-xgbe 0000:06:00.2: port property 4 = 0x00001c13
[    6.308933] amd-xgbe 0000:06:00.2: max tx/rx channel count = 3/3
[    6.315651] amd-xgbe 0000:06:00.2: max tx/rx hw queue count = 3/3
[    6.322480] amd-xgbe 0000:06:00.2: Hardware features:
[    6.333849] amd-xgbe 0000:06:00.2:   1GbE support              : yes
[    6.340948] amd-xgbe 0000:06:00.2:   VLAN hash filter          : yes
[    6.348047] amd-xgbe 0000:06:00.2:   MDIO interface            : yes
[    6.355146] amd-xgbe 0000:06:00.2:   Wake-up packet support    : no
[    6.362146] amd-xgbe 0000:06:00.2:   Magic packet support      : no
[    6.369148] amd-xgbe 0000:06:00.2:   Management counters       : yes
[    6.376244] amd-xgbe 0000:06:00.2:   ARP offload               : yes
[    6.383345] amd-xgbe 0000:06:00.2:   IEEE 1588-2008 Timestamp  : yes
[    6.390443] amd-xgbe 0000:06:00.2:   Energy Efficient Ethernet : yes
[    6.397539] amd-xgbe 0000:06:00.2:   TX checksum offload       : yes
[    6.404636] amd-xgbe 0000:06:00.2:   RX checksum offload       : yes
[    6.411734] amd-xgbe 0000:06:00.2:   Additional MAC addresses  : 31
[    6.418737] amd-xgbe 0000:06:00.2:   Timestamp source          : 
internal/external
[    6.427195] amd-xgbe 0000:06:00.2:   SA/VLAN insertion         : yes
[    6.434292] amd-xgbe 0000:06:00.2:   VXLAN/NVGRE support       : yes
[    6.441391] amd-xgbe 0000:06:00.2:   RX fifo size              : 65536
[    6.448684] amd-xgbe 0000:06:00.2:   TX fifo size              : 65536
[    6.455976] amd-xgbe 0000:06:00.2:   IEEE 1588 high word       : yes
[    6.463075] amd-xgbe 0000:06:00.2:   DMA width                 : 48
[    6.470078] amd-xgbe 0000:06:00.2:   Data Center Bridging      : yes
[    6.477178] amd-xgbe 0000:06:00.2:   Split header              : yes
[    6.484276] amd-xgbe 0000:06:00.2:   TCP Segmentation Offload  : yes
[    6.491375] amd-xgbe 0000:06:00.2:   Debug memory interface    : yes
[    6.498471] amd-xgbe 0000:06:00.2:   Receive Side Scaling      : yes
[    6.505570] amd-xgbe 0000:06:00.2:   Traffic Class count       : 3
[    6.512472] amd-xgbe 0000:06:00.2:   Hash table size           : 256
[    6.519571] amd-xgbe 0000:06:00.2:   L3/L4 Filters             : 8
[    6.526476] amd-xgbe 0000:06:00.2:   RX queue count            : 3
[    6.533379] amd-xgbe 0000:06:00.2:   TX queue count            : 3
[    6.540282] amd-xgbe 0000:06:00.2:   RX DMA channel count      : 3
[    6.547183] amd-xgbe 0000:06:00.2:   TX DMA channel count      : 3
[    6.554087] amd-xgbe 0000:06:00.2:   PPS outputs               : 0
[    6.560992] amd-xgbe 0000:06:00.2:   Auxiliary snapshot inputs : 0
[    6.567894] amd-xgbe 0000:06:00.2: TX/RX DMA channel count = 3/3
[    6.574606] amd-xgbe 0000:06:00.2: TX/RX hardware queue count = 3/3
[    6.581609] amd-xgbe 0000:06:00.2: max tx/rx max fifo size = 65536/65536
[    6.589256] amd-xgbe 0000:06:00.2: multi MSI-X interrupts enabled
[    6.596079] amd-xgbe 0000:06:00.2:  dev irq=84
[    6.601045] amd-xgbe 0000:06:00.2:  ecc irq=85
[    6.606008] amd-xgbe 0000:06:00.2:  i2c irq=86
[    6.610974] amd-xgbe 0000:06:00.2:   an irq=87
[    6.615938] amd-xgbe 0000:06:00.2:  dma0 irq=88
[    6.621002] amd-xgbe 0000:06:00.2:  dma1 irq=89
[    6.626072] amd-xgbe 0000:06:00.2:  dma2 irq=90
[    6.631176] amd-xgbe 0000:06:00.2: adjusted TX/RX DMA channel count = 3/3
[    6.638772] amd-xgbe 0000:06:00.2: I2C features: MAX_SPEED_MODE=2, 
RX_BUFFER_DEPTH=15, TX_BUFFER_DEPTH=15
[    6.649472] amd-xgbe 0000:06:00.2: port mode=8
[    6.654443] amd-xgbe 0000:06:00.2: port id=1
[    6.659216] amd-xgbe 0000:06:00.2: port speeds=0x16
[    6.664668] amd-xgbe 0000:06:00.2: conn type=1
[    6.669634] amd-xgbe 0000:06:00.2: mdio addr=0
[    6.674598] amd-xgbe 0000:06:00.2: redrv present
[    6.679758] amd-xgbe 0000:06:00.2: redrv i/f=0
[    6.684726] amd-xgbe 0000:06:00.2: redrv addr=0x0
[    6.689974] amd-xgbe 0000:06:00.2: redrv lane=0
[    6.695038] amd-xgbe 0000:06:00.2: redrv model=0
[    6.700196] amd-xgbe 0000:06:00.2: SFP: mux_address=0x73
[    6.706131] amd-xgbe 0000:06:00.2: SFP: mux_channel=1
[    6.711776] amd-xgbe 0000:06:00.2: SFP: gpio_address=0x21
[    6.717808] amd-xgbe 0000:06:00.2: SFP: gpio_mask=0x2
[    6.723452] amd-xgbe 0000:06:00.2: SFP: gpio_rx_los=9
[    6.729097] amd-xgbe 0000:06:00.2: SFP: gpio_tx_fault=10
[    6.735031] amd-xgbe 0000:06:00.2: SFP: gpio_mod_absent=8
[    6.741063] amd-xgbe 0000:06:00.2: SFP: gpio_rate_select=0
[    6.747201] amd-xgbe 0000:06:00.2: phy 
supported=0x0000000,00000000,000064c0
[    6.765905] amd-xgbe 0000:06:00.2 eth2: net device enabled
[    6.830271] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth1
[    6.873079] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth2

I'll try and debug why 'netif_msg_probe(pdata)' doesn't work, next week.

>>>
>>> dmesg right after 'ifconfig enp6s0f2 up'
>>>
>>> [   88.843454] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2
>>> enp6s0f2: channel-0: cpu=0, node=0
>
>
>> Can you add this change and see if it solves the problem?
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=68c2d6af1f1e 
>>
>
> I would imagine that patch has nothing to do with the real issue. Given
> the previous messages of:
>
>> [  648.038655] genirq: Flags mismatch irq 59. 00000000 (enp6s0f2-pcs) 
>> vs. 00000000 (enp6s0f2-pcs)
>> [  648.048303] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
>
> There should be no reason for not being able to obtain the IRQ.
>
> I suspect it is something in the BIOS setup that is not correct and thus
> the Linux driver is not working properly because of bad input/setup from
> the BIOS. This was probably worked around by the driver used in the
> OPNsense DEC740 firewall.
>
> Shyam has worked more closely with the embedded area of this device, I'll
> let him take it from here.
>
> Thanks,
> Tom
>
Thanks for your help Tom! I'll wait to hear back from Shyam.

