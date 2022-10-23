Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A252260960A
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 22:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJWUPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 16:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiJWUPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 16:15:21 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2119.outbound.protection.outlook.com [40.107.22.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B33F33405;
        Sun, 23 Oct 2022 13:15:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5feHCWf8TwkLN7Odg5X5tib84rm13Zy2/patnPH8fnC4rrJvC344lBsCA66UsuKsiLWUsNknXC4t0PVLp/CzUvAdIyY8WwizD6US89iI8sWECj4mfmEXWP6kuDaFz3lVDDzccXV8070Q6/TVzPZ43jOH8FjO8ClIXQ9btfp2n2fAGbPVBuE+NP6Car7MCjOO8ufHY4ut6yzFeXWxip799m/xWv8cqQifAAAeZJ5KNp5hdJ/vHnfTiqmEv+KThYPx1KXJK1gywpZoohjvU+9bBtqnnUSnImKKa7VHKY4UakeWGuXnOgB7QZOMkmGOS/4r+v2osLdAV+VjYdU59yHzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8a+bNiBhbvBWIzILyL2zqAMVuYeSepgmat41qz9Big0=;
 b=i5ZezJItP/7UKq9Pp0wj+Skb9KifD1pz2NDUAbaBSPGHYAcN1AIImydWPhkKeIACWpYVrb9gZtYLiMpNPxK/uoJi04JShepsbSATabm065AJXQJgK+U8AzCAgtpg45KBVvtMUHfSZWzdldF5TO0multS+Z4hV5PMylP+JnF9PJQVaYqYC+e85kbEfzkSPQUgohpZDx3jM+i16rLryMFW+QFQaqR6oddQrPVvTKJM79AupA++ffAoEPAHmW6WObBHGV7fxeTmza6R5EuuwbgVLwRjFQGrcWD39LI0em4tAEvmDfU0EuZWuAfpZqk22zV0u+LloaGuQD5VryjLBXFG2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=gmail.com smtp.mailfrom=arri.de; dmarc=none
 action=none header.from=arri.de; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8a+bNiBhbvBWIzILyL2zqAMVuYeSepgmat41qz9Big0=;
 b=qlqyMrTGkP4oGL09uHRpnqxMf/fYF+fax1KY/43SAtpDLWN6lE1fU3zJcEWmjrENPWGlLDEHqnkw8VznWDCsSDsYpaWc3qn4rdkojgna7MXwP4OBAam6OsnBPAVq6GMBBUibbsS/vuKnER6ZUVUeSHieiqZY1Sqa2LkDS9Y7yGs=
Received: from DU2PR04CA0167.eurprd04.prod.outlook.com (2603:10a6:10:2b0::22)
 by AS8PR07MB8186.eurprd07.prod.outlook.com (2603:10a6:20b:375::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.20; Sun, 23 Oct
 2022 20:15:14 +0000
Received: from DB5EUR02FT045.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:10:2b0:cafe::df) by DU2PR04CA0167.outlook.office365.com
 (2603:10a6:10:2b0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21 via Frontend
 Transport; Sun, 23 Oct 2022 20:15:14 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 DB5EUR02FT045.mail.protection.outlook.com (10.13.59.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Sun, 23 Oct 2022 20:15:13 +0000
Received: from n95hx1g2.localnet (192.168.54.14) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.32; Sun, 23 Oct
 2022 22:15:12 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     <olteanv@gmail.com>, <Arun.Ramadoss@microchip.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <b.hutchman@gmail.com>
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support for LAN937x switch
Date:   Sun, 23 Oct 2022 22:15:12 +0200
Message-ID: <1843632.tdWV9SEqCh@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com> <20221018102924.g2houe3fz6wxlril@skbuf> <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.14]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB5EUR02FT045:EE_|AS8PR07MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: 930ae06e-cada-40ae-9689-08dab5334b6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mna+ANBSPY31yVWyd11Yzu6kbOzftmO0R2U0PE696X+w+1d2QFI32krkdWVWdJlyDWX1MotOEkeBT8wyViK/4aPsoLa3wJSn5NCR2PfyG9E7Pi2Ucc7EcuqGyHNy44sTFayFqvcU8sh0RvOkQSvGJpZijJxBhut5tz2Go2UH8UnBKrO1Wt2kUSPc/TJ/mkIx7KImAMwKOxLQv9Yav8GkNPstdAk8/SygaMAKfRLr/1TuShQ3qfi7g0fttvy4B/kSJZw43LoOhQFNEvGN9aAeiW2Ji7P4eXMVAb7HEVJ7SnuCsrh+NTpgg1NJMOzLAC67l5m2ln8fBoopaAHzTb+tZQkelQ4FDHXUnMpptB2MM6q1VY0Snk0GUYtiK6lSf3JYdIf10UGMoxPKgNqJ9nls2EEoVKDpsptylLHSg/Sy31+aO/myXMmYu4sKd3WoDxye3y9I8J2hiqAKqpTT584n0I3CHI1c7TE1ObvwYfbrwS626GOGkIi/eiJRk7zV+UFw30jJkLEpAVeXAoa9gX2DZUUwpR3RztCRrMtwKjZC3U0wbeu9+R79uEPIw+lz275Fvc5jTd7EKRXmCkBCSMf/4PdXi/7r1RJTVRBQqEUl9WmPvCDDUJKE0OeW053zkrXDUMl2vLc6ab+YKWCpdLSaFtKQlmg2pmylrkt+wZa2kuVspiJ4bUzyhBhSNWm72SC5CNDNaYUFk5b/qvTC36cMYnmHZv20Enwrd9oWSDAZczByF/hdgHGPx4YXOTSQ8/TXLtiPkeCIKSaxhPI3gO+FnhtbHv+EsOvpcUXKuzI2wQSeEDFgOdXHWZS9hL39yy/UA1EzMjOu/4AvIa8SBuZzuw==
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(39840400004)(346002)(451199015)(46966006)(36840700001)(5660300002)(8936002)(9576002)(2906002)(36860700001)(45080400002)(41300700001)(478600001)(40480700001)(54906003)(110136005)(70586007)(356005)(8676002)(4326008)(70206006)(81166007)(9686003)(86362001)(107886003)(450100002)(336012)(26005)(186003)(16526019)(426003)(36916002)(33716001)(316002)(83380400001)(47076005)(82310400005)(39026012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 20:15:13.9129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 930ae06e-cada-40ae-9689-08dab5334b6f
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR02FT045.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB8186
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun, hi Vladimir,

On Tuesday, 18 October 2022, 15:42:41 CEST, Arun.Ramadoss@microchip.com wrote:
> Thanks Vladimir. I will wait for Christian feedback.
> 
> Hi Christian,
> To test this patch on KSZ9563, we need to increase the number of
> interrupts port_nirqs in KSZ9893 from 2 to 3. Since the chip id of
> KSZ9893 and KSZ9563 are same, I had reused the ksz_chip_data same for
> both chips. But this chip differ with number of port interrupts. So we
> need to update it. We are generating a new patch for adding the new
> element in the ksz_chip_data for KSZ9563.
> For now, you can update the code as below for testing the patch
> 
> -- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1266,7 +1266,7 @@ const struct ksz_chip_data ksz_switch_chips[] =
> {         
>                  .num_statics = 16,
>                  .cpu_ports = 0x07,      /* can be configured as cpu
> port */
>                  .port_cnt = 3,          /* total port count */
>  -               .port_nirqs = 2,
>  +               .port_nirqs = 3,
>                  .ops = &ksz9477_dev_ops,
>                  .mib_names = ksz9477_mib_names,
>                  .mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
> 
> --

sorry for the delay. I'm currently quite busy with my own work and
my kids' school stuff. Additionally I had to update my internal kernel tree
from 5.15.y-stable-rt to the latest netdev which took longer than I
expected. (Preempt-RT patches tend to become smaller, my ones are only
getting larger).

Prior applying the patches, everything seems to build and run fine.

After applying the patch series, I had some trouble with linking. I had
configured nearly everything as a module:

CONFIG_PTP_1588_CLOCK=m
CONFIG_NET_DSA=m
CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON=m    [ksz_switch.ko]
CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C=m
CONFIG_NET_DSA_MICROCHIP_KSZ_PTP=y       [builtin]

With this configuration, kbuild doesn't even try to compile ksz_ptp.c:

ERROR: modpost: "ksz_hwtstamp_get" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_hwtstamp_set" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_port_txtstamp" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_ptp_clock_register" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_port_deferred_xmit" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_ptp_clock_unregister" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_ptp_irq_free" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_tstamp_reconstruct" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_get_ts_info" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
ERROR: modpost: "ksz_ptp_irq_setup" [drivers/net/dsa/microchip/ksz_switch.ko] undefined!

After setting all of the above to 'y', the build process works (but I would prefer
being able to build as modules). At startup I get a NULL pointer dereference (see below),
but I haven't tried to track down the source yet (will continue tomorrow).

regards,
Christian

[   17.749629] ksz9477-switch 0-005f: Port2: using phy mode rmii instead of rgmii
[   17.785998] 8<--- cut here ---
[   17.789732] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   17.798006] [00000000] *pgd=00000000
[   17.801573] Internal error: Oops: 805 [#1] THUMB2
[   17.806331] Modules linked in: st_magn_i2c st_sensors_i2c st_magn as73211 usb_storage st_sensors industrialio_triggered_buffer ksz9477_i2c(+) btusb rtc_rv3028 at24 kfifo_b
 spidev leds_gpio leds_pwm led_class iio_trig_sysfs imx6sx_adc industrialio micrel fec imx_napi at25 spi_imx i2c_imx nfsv3 nfs lockd grace sunrpc usb_f_ncm u_ether libcomposi
[   17.847335] CPU: 0 PID: 201 Comm: udevd Not tainted 6.1.0-rc1+ #198
[   17.853768] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
[   17.860060] PC is at ksz_connect_tag_protocol+0x6/0x18
[   17.865286] LR is at dsa_register_switch+0x5a9/0x780
[   17.870336] pc : [<c02cc6be>]    lr : [<c03a4f45>]    psr: 60000033
[   17.876774] sp : c22abc30  ip : ffffffff  fp : 00000000
[   17.882095] r10: c047660c  r9 : c0476e70  r8 : c5dcb400
[   17.887412] r7 : c4f31808  r6 : c1ba1f40  r5 : c4f31800  r4 : c1ba1f40
[   17.894058] r3 : 00000000  r2 : c02d1325  r1 : 00000007  r0 : 00000000
[   17.900766] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment none
[   17.908211] Control: 50c53c7d  Table: 822b0059  DAC: 00000051
[   17.914055] Register r0 information: NULL pointer
[   17.918929] Register r1 information: non-paged memory
[   17.924068] Register r2 information: non-slab/vmalloc memory
[   17.929828] Register r3 information: NULL pointer
[   17.934613] Register r4 information: slab kmalloc-192 start c1ba1f00 pointer offset 64 size 192
[   17.943535] Register r5 information: slab kmalloc-64 start c4f31800 pointer offset 0 size 64
[   17.952131] Register r6 information: slab kmalloc-192 start c1ba1f00 pointer offset 64 size 192
[   17.961071] Register r7 information: slab kmalloc-64 start c4f31800 pointer offset 8 size 64
[   17.969665] Register r8 information: slab kmalloc-512 start c5dcb400 pointer offset 0 size 512
[   17.978434] Register r9 information: non-slab/vmalloc memory
[   17.984254] Register r10 information: non-slab/vmalloc memory
[   17.990103] Register r11 information: NULL pointer
[   17.994977] Register r12 information: non-paged memory
[   18.000206] Process udevd (pid: 201, stack limit = 0x4afbccb6)
[   18.006223] Stack: (0xc22abc30 to 0xc22ac000)
[   18.010658] bc20:                                     00000000 c22abc48 c0c01300 ff8064a4
[   18.018992] bc40: ffffffff 00000002 c7eee0e4 00000000 00000168 bf981240 bf9810b8 c5dcbc00
[   18.027527] bc60: 40000113 00000004 c22abc94 c0306423 40000113 c22f8cd0 c7ef70a8 c0306423
[   18.035857] bc80: c22abc9c c030823d c7ef73cc c22f8cd0 00000007 c2249240 00000000 c7ef70a8
[   18.044186] bca0: 000008e0 00000007 c051acdd c05414e4 c05414f9 c02cd2fb 00000000 00000000
[   18.052718] bcc0: 00000000 00000002 ffffffff ffffffff c0fdf020 000000c4 c2249240 c0fdf000
[   18.061047] bce0: 00000003 c0fdf020 c224928c bf981240 bf9810b8 bf9800ab c22abd24 bf9810b3
[   18.069375] bd00: 00000010 00000001 00000000 00000000 00000000 00000020 00000000 00000000
[   18.077893] bd20: 00000000 00000000 00000000 00000000 00000000 bf98002f bf98002b c2249258
[   18.086222] bd40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   18.094611] bd60: 0000ffff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   18.102940] bd80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   18.111270] bda0: 00000001 00000001 00000000 00000000 00000000 00000000 00000000 00000000
[   18.119684] bdc0: c32bffc0 c0fdf000 bf980033 bf98201c c0fdf020 c081f0c0 00000026 0000017b
[   18.128019] bde0: 00000000 c02f8a8d c02f894b 00000000 c0fdf020 bf98201c 00000000 c02993f5
[   18.136349] be00: 00000001 c0877380 c087748c bf98201c c0fdf020 c0299557 c0fdf064 00000000
[   18.144739] be20: c0fdf020 bf98201c c080abd8 c081f0c0 c3035d34 c0299853 00000000 c0fdf020
[   18.153068] be40: bf98201c c02997c7 c080abd8 c029880b c0d17dcc c1878ab0 bf98201c c3035d00
[   18.153068] be40: bf98201c c02997c7 c080abd8 c029880b c0d17dcc c1878ab0 bf98201c c3035d00
[   18.161477] be60: 00000000 c0298a93 bf98109f bf9810a0 0000006b bf98201c b6e6a290 c23dba00
[   18.169808] be80: 00000000 c081f0c0 c23dba00 c0299c1b bf982074 bf982000 b6e6a290 c02f8875
[   18.178137] bea0: 00000000 bf9b0001 b6e6a290 c0101907 c0c01100 00000cc0 ffffffff 00000008
[   18.186525] bec0: 00000cc0 c01c1aa7 00006c65 00000000 00000000 c32bfc80 c0138a27 c32bfc80
[   18.194853] bee0: 00000008 00000040 c32bfc80 c01ab021 00000cc0 ffffffff bf982080 b6e6a290
[   18.203182] bf00: c32bfc80 0000017b c010027c c0138a41 bf982080 c7fb50e0 00000000 b6e6a290
[   18.211592] bf20: 00000009 c0139cd1 c22abf38 7fffffff 00000000 00000002 c95aa000 c95ac958
[   18.219922] bf40: c95aca40 c95aa000 001de8b0 c97764d0 c97762c8 c9733218 00003000 00003080
[   18.228311] bf60: 00012340 000030e3 00000000 00000000 00000000 00000000 00000000 00012330
[   18.236640] bf80: 00000749 0000074a 00000279 00000000 00000272 00000000 00000000 b6e7b670
[   18.244971] bfa0: 0000017b c0100041 00000000 b6e7b670 00000009 b6e6a290 00000000 00000000
[   18.253373] bfc0: 00000000 b6e7b670 0000017b 0000017b 00000000 b6e7b670 00020000 00000000
[   18.261710] bfe0: b6e6a290 befaa918 b6e66a23 b6ed4c22 40000030 00000009 00000000 00000000
[   18.270240]  ksz_connect_tag_protocol from dsa_register_switch+0x5a9/0x780
[   18.277243]  dsa_register_switch from ksz_switch_register+0x417/0x48c
[   18.283797]  ksz_switch_register from ksz9477_i2c_probe+0x79/0xfce [ksz9477_i2c]
[   18.291583]  ksz9477_i2c_probe [ksz9477_i2c] from i2c_device_probe+0x143/0x15a
[   18.299016]  i2c_device_probe from really_probe+0xb1/0x188
[   18.304597]  really_probe from driver_probe_device+0x2b/0x88
[   18.310354]  driver_probe_device from __driver_attach+0x8d/0x9e
[   18.316438]  __driver_attach from bus_for_each_dev+0x2b/0x42
[   18.322196]  bus_for_each_dev from bus_add_driver+0x6f/0x128
[   18.327955]  bus_add_driver from driver_register+0x59/0x8e
[   18.333537]  driver_register from i2c_register_driver+0x35/0x54
[   18.339642]  i2c_register_driver from do_one_initcall+0x2b/0xbc
[   18.345677]  do_one_initcall from do_init_module+0x2d/0x1a0
[   18.351347]  do_init_module from sys_finit_module+0x65/0x6c
[   18.357018]  sys_finit_module from ret_fast_syscall+0x1/0x5c
[   18.362838] Exception stack(0xc22abfa8 to 0xc22abff0)
[   18.367982] bfa0:                   00000000 b6e7b670 00000009 b6e6a290 00000000 00000000
[   18.376311] bfc0: 00000000 b6e7b670 0000017b 0000017b 00000000 b6e7b670 00020000 00000000
[   18.384717] bfe0: b6e6a290 befaa918 b6e66a23 b6ed4c22
[   18.389862] Code: 0093 6a03 2000 4a02 (601a) 4a02
[   18.394903] ---[ end trace 0000000000000000 ]---



