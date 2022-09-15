Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AD95B9868
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiIOKAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiIOKAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:00:04 -0400
Received: from eu-smtp-delivery-197.mimecast.com (eu-smtp-delivery-197.mimecast.com [185.58.86.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6BA6745D
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 02:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=camlingroup.com;
        s=mimecast20210310; t=1663235794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6MnNOIxwoF79csux46c8oHT9IzU5EfpdIqeq7enyi5M=;
        b=KH/rOTIDeDycfh3cpDtLgh1GJkFblOvhISihtU7y7yS0LRPy6d+BAKBZebmAnxZ7PvIYjB
        xkjXOMCfWefsKCebCvvNfC65mXmyGw68OILZ3GRDJT9XxO5WaHVEDKH9rtfQuBzgeR+biv
        +iev2+qXR/BoWWs3vxze4b1ysjR6k6k=
Received: from GBR01-LO2-obe.outbound.protection.outlook.com
 (mail-lo2gbr01lp2050.outbound.protection.outlook.com [104.47.21.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 uk-mta-185-_Ryym0HCMvSQillFZkhgmw-1; Thu, 15 Sep 2022 10:56:29 +0100
X-MC-Unique: _Ryym0HCMvSQillFZkhgmw-1
Received: from CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:142::9)
 by LO0P123MB5726.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:228::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 09:56:26 +0000
Received: from CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM
 ([fe80::1066:dd62:379f:a429]) by CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM
 ([fe80::1066:dd62:379f:a429%7]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 09:56:26 +0000
Message-ID: <8bea4eed-5b71-9fd4-c705-926bdad0ee47@camlingroup.com>
Date:   Thu, 15 Sep 2022 11:56:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: wfx: Memory corruption during high traffic with WFM200 on i.MX6Q
 platform
From:   Lech Perczak <lech.perczak@camlingroup.com>
To:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Pawe=c5=82_Lenkow?= <pawel.lenkow@camlingroup.com>
CC:     Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?Q?Krzysztof_Drobi=c5=84ski?= 
        <krzysztof.drobinski@camlingroup.com>,
        Kirill Yatsenko <kirill.yatsenko@camlingroup.com>
References: <16b90f1d-69b4-72ac-7018-66d524f514f9@camlingroup.com>
 <3193501.44csPzL39Z@pc-42>
 <12e5adcd-8aed-f0f7-70cc-4fb7b656b829@camlingroup.com>
In-Reply-To: <12e5adcd-8aed-f0f7-70cc-4fb7b656b829@camlingroup.com>
X-ClientProxiedBy: BE1P281CA0073.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::18) To CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:142::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWXP123MB5267:EE_|LO0P123MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: 40a0faca-d080-49f7-e21e-08da97008e00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TwWk9BYc0K1YtxL+405nMXo0DT0PIHNfH4PN5qiqRd1D0jdHp7QEJgH49QdgFgAoLduQ/UQ+DF6S5y7OVBZDvCeB9ei4wn6QSuLLIsc5e9OrWgXuAeDSaXI6eJpD0XW/SHUurNcTm/p7uSHFbzJi+L3AGLXJ2cnbbAERyd6j964hjPwbYMTH0wKHrYDj30r7cFHnpjzGvjc5QvHFLCm+IKFlgJDB6+C927sJxM8Vhf2JcdDTOv+nVB/Ytn0s/P/jK7wp+rhGEkb0RiOnJ2uxtve24EW2ljwcs8dNu8OT9K+SeKzlT40SjkMtLMaMaGF1WcUUXiMHik7ENprpvWie/tW/T9kxg8qVMtSOhw4shsAXAX10Ar7I+L8GFagduYpju8AbcvM+uOP+zTZq3up0dH/TiowN8jQMJIfanKYrKtefVCk/Xnw6OBlIz0/6fCdrtC6yi/pK/WaVI4YwF0WouETMjRQdLFcoKeT2TwDgu+1zCHJC8PbuoD5WNdTtAJ5h6O7MmhWhtyCczl+4EucO4ozBl4uw3jLs6wDpYDhjd5LaVMXrUwuN7uQv5slKiStC23U+4DENcH6p01HaCygUJn3Q7sm+bv+Nhpwmm0pKOM9Qv2APjb82Cr0ipiepohhsPxSqZQD3WwaqNLAw7LAqmTMwppfGvRAXZEkUuzvRYG8OgR03xY6QI4D379hsWl6ugKmth7Kd4o6U5LwP9gn1N9hAaVEkUxGQRth4ckf42MMaeqIrYqHrX7AG7HKabwRcredDx8qbBx4Hk9xzya3zRvDfz1yWk7flPXHlysngurW3q7o7zSP2aB5UogOe9VB3w0LYGwmjQAm6NrnWnINYvy9SMiJWl73aUL3aSLnGQrc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(39850400004)(136003)(451199015)(2906002)(66556008)(66476007)(316002)(66946007)(4326008)(8936002)(8676002)(66574015)(6486002)(2616005)(186003)(52116002)(6506007)(31696002)(30864003)(6636002)(45080400002)(36756003)(966005)(38100700002)(41300700001)(6512007)(110136005)(54906003)(44832011)(83380400001)(86362001)(107886003)(31686004)(478600001)(5660300002)(43740500002)(45980500001)(18886065003);DIR:OUT;SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lyt3bJpBz4aUAIc+OL/UpE6Bz4hF9DUagSWYijvOdqvxWjAvhyAO9I+CZ2yP?=
 =?us-ascii?Q?NmNpPkBgKPiVsigca9V0LZVBoXJfhdn9YvxhOxW+/DO9Wh1aaP4bdx7e8Jbk?=
 =?us-ascii?Q?7bx7fEl7vau3Qmp2SEjFjNEGUKSrXDxtl9NEMF6OShrMx1ksWksS1wylZzGe?=
 =?us-ascii?Q?+9HlRNIfQWKLImfgSdozfIJ/BLqjmiuXfvLmEsOhyw9wLDlS95LAr52+f57o?=
 =?us-ascii?Q?/QjTdykdPqj4XGANEk6DXuASEuzo9XKvIj62CWs4mP3f8u2USNkGfRhEVqOm?=
 =?us-ascii?Q?wd8YREE+h4SPioMWLVxyjYl5aIb/8J5nJeWOGnQS3Bly45xmKeX1mQauKW2X?=
 =?us-ascii?Q?KQWlwIy0RQedVsNspuKj244dMgoO5eAVja4NEfWgF8kzd8moRB67DjZ3X7Mw?=
 =?us-ascii?Q?35bxPfjKjsAU9UnK8rwAG1h/isSDl5adyjuw/TW96BjHF+KY87eU2NH7IQcl?=
 =?us-ascii?Q?sTu26SEzgsW25GOYpFCdANOaBNHSRE+HdPmcfV6R0NF+7XG08ndsmHYtj9cX?=
 =?us-ascii?Q?Rzvn5bq9Qy3/obk4C9cGGFFk12KYsodu8QdvywrvIQ20AR+AUOOTqoLQ8hd1?=
 =?us-ascii?Q?jE5D+9gikJ0L4C7ESGCYn9+JZZ1jjdHhW8rja3ST+oSMDpLtIgBO8sEna8ui?=
 =?us-ascii?Q?SOvUiE5Lshca/LC10y+wIa9djw1LS+ef6/8esnJnKsUFc/agclcevHYyAk28?=
 =?us-ascii?Q?ixyaN3JSqJI8HdEeQqDxmY/97e5bJvhDfvAn3mCH5EPwh8bwZG6IZd+fuL5E?=
 =?us-ascii?Q?P5h3N12V9PdE4TVQls59SJaWRgWYhVgWfFIf0o+xvbfYiCI+D8NB3M+KFmmT?=
 =?us-ascii?Q?3uy84ocOJWSUzh5KBCWNLkca8rfI+gF2z4LwTRLpgolF0aLb7ALJMKL9r4S9?=
 =?us-ascii?Q?go1Xy1ul8rhpNAzx9zcGuEmdPkbOv7bmY5nIbHtpov3DBfmRtRfh5TwUI1aI?=
 =?us-ascii?Q?oWJNZN3Dz6DnRDEAVdibNvl8lGgIsioqaphB/88c8PiDRWwfvZeEDSbx51ja?=
 =?us-ascii?Q?zZ6IxTF8mwRYX0uRbIwRstsfiYWWqY2CSFaeFzjSnRfyNIDg+4oPFesX+1Op?=
 =?us-ascii?Q?MzcucyitzN/uWF8pTQRVvVDJg7C3nUS/mHDhgY07Ijwz47q0AcuQUdWX1KG0?=
 =?us-ascii?Q?pzkcGX2rqkmdt9AizH5fvnqbI/1GZ3kkUSc+KCBZxeHrsJBwaVUgAOK7yNRR?=
 =?us-ascii?Q?Rjcwi104HJm7c5kmCq9ivR0idgvmL4i2Qcly+WyNX2qCHZ+LC5XtCvKvX2Sh?=
 =?us-ascii?Q?g9ARRvlwxtw2i3R/8nMh9Mrv9ola0+Kdd/s13yw9FFgbv5ygFOLwnYsxx2YA?=
 =?us-ascii?Q?OlLwVmfeUolr84VvsI+uRTf8Z0T66eIuzP0qVZ+GgEoz4ETu1pUBXACUNfBk?=
 =?us-ascii?Q?cUERCTuAqCI6Ju6jzKcMOOtYif1eWEKVSECpA2pnHF93IAVAAlrWsYBY7AC0?=
 =?us-ascii?Q?D17jEAP9/WJHch8gztVofSf/gyaVMkNG/OdD37DHKUurVioZoomoi0Ai2Z5z?=
 =?us-ascii?Q?VCcFB+7zZAnKapcILz/z7ToiYMEq9Uc8twQWZhGeP3m/9yJTFVxOxtcRpLQ/?=
 =?us-ascii?Q?lIeaBJhYbG8RPufsz493/6ccAlPX0AScWR/HY0FiZNlfuCbySldxU1LUzbfd?=
 =?us-ascii?Q?weT/WWhP/F8KqDhRigukuaONs8+N2fT0gI9I9JxsLQ+X04Zmix2+Ki3KZDrh?=
 =?us-ascii?Q?JEU/Gg=3D=3D?=
X-OriginatorOrg: camlingroup.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a0faca-d080-49f7-e21e-08da97008e00
X-MS-Exchange-CrossTenant-AuthSource: CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 09:56:26.5656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNpEoWLkXNLU2ea7tcEpHVTx9rXdzp1qXSor5o6E2jympuQsMP349Shy//ge0QW8hPqwRxpVntKeur9eLAEZkhPI2xaQr5eCvNUpeqifGpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB5726
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: camlingroup.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi J=C3=A9r=C3=B4me,

Just a quick note, so you don't have to redo our work - Pawe=C5=82 found th=
e root cause,
patch is coming very shortly.

TL;DR is that hw->max_rates in wfx_init_common was set to 8 initially,
which is over the maximum of 4 specified by mac80211,
causing out-of-bounds writes all over the place.

Kind regards,
Lech

W dniu 12.09.2022 o=C2=A018:46, Lech Perczak pisze:
> Hi J=C3=A9r=C3=B4me,
>
> Probably a Thunderbird mess-up. Let's try again, I hope it works - I prob=
ably fiddled too much with the settings to make it send plain-text.
>
> We're trying to get a WFM200S022XNN3 module working on a custom i.MX6Q bo=
ard using SDIO interface, using upstream kernel.
> Our patches concern primarily the device tree for the board - and upstrea=
m firmware from linux-firmware repository.
>
> During that, we stumbled upon a memory corruption issue, which appears wh=
en big traffic is passing through the device.
> Our adapter is running in AP mode. This can be reproduced with 100% rate =
using iperf3,
> by starting an AP interface on the device, and an iperf3 server.
> Then, the client station runs iperf3 with "iperf3 -c <hostname> -t 3600" =
command - so the AP is sending data for up to one hour,
> however - the kernel on our device crashes after around a few minutes of =
traffic, sometimes less than a minute.
>
> The behaviour is the same on kernel v5.19.7, v5.19.2, and even with v6.0-=
rc5. Tests on v6.0-rc5 have shown most detailed stacktrace so far:
>
> 8<--- cut here ---
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
101
> [00000101] *pgd=3D00000000
> Internal error: Oops: 17 [#1] PREEMPT SMP ARM
> Modules linked in: xt_LOG nf_log_syslog xt_limit iptable_mangle xt_connma=
rk xt_tcpudp xt_conntrack
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_tab=
les cdc_mbim cdc_wdm cdc_ncm
> cdc_ether usbnet cdc_acm usb_serial_simple usbserial usb_f_rndis u_ether =
wfx mac80211 libarc4 cfg80211 evbug
> phy_generic ci_hdrc_imx ci_hdrc adt7475 hwmon_vid ulpi roles usbmisc_imx =
pwm_imx27
> pwm_beeper libcomposite configfs udc_core
> CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 6.0.0-rc5-dnm3pv2+g047dc4cf9=
a10 #1
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> PC is at kfree_skb_list_reason+0x10/0x24
> LR is at ieee80211_report_used_skb+0xd0/0x5b4 [mac80211]
> pc : [<80773238>]=C2=A0=C2=A0=C2=A0 lr : [<7f136538>]=C2=A0=C2=A0=C2=A0 p=
sr: 20000113
> sp : f0801e60=C2=A0 ip : 00000000=C2=A0 fp : 838f04e2
> r10: 00000001=C2=A0 r9 : 838f04e2=C2=A0 r8 : 00000000
> r7 : 82661580=C2=A0 r6 : 00000000=C2=A0 r5 : 82660580=C2=A0 r4 : 00000101
> r3 : 838f0700=C2=A0 r2 : 00000032=C2=A0 r1 : 00000001=C2=A0 r0 : 00000101
> Flags: nzCv=C2=A0 IRQs on=C2=A0 FIQs on=C2=A0 Mode SVC_32=C2=A0 ISA ARM=
=C2=A0 Segment none
> Control: 10c5387d=C2=A0 Table: 11d0004a=C2=A0 DAC: 00000051
> Register r0 information: non-paged memory
> Register r1 information: non-paged memory
> Register r2 information: non-paged memory
> Register r3 information: slab kmalloc-1k start 838f0400 pointer offset 76=
8 size 1024
> Register r4 information: non-paged memory
> Register r5 information: slab kmalloc-8k start 82660000 pointer offset 14=
08 size 8192
> Register r6 information: NULL pointer
> Register r7 information: slab kmalloc-8k start 82660000 pointer offset 55=
04 size 8192
> Register r8 information: NULL pointer
> Register r9 information: slab kmalloc-1k start 838f0400 pointer offset 22=
6 size 1024
> Register r10 information: non-paged memory
> Register r11 information: slab kmalloc-1k start 838f0400 pointer offset 2=
26 size 1024
> Register r12 information: NULL pointer
> Process ksoftirqd/0 (pid: 10, stack limit =3D 0x1fff5f96)
> Stack: (0xf0801e60 to 0xf0802000)
> 1e60: 8393cd80 7f136538 00000000 81590f34 80f050b4 20000193 f0801ecc 7f18=
9a7c
> 1e80: 00000032 00000005 823f0458 f0801f18 81c51a00 8368504c 7f189854 8389=
8000
> 1ea0: 8226ac40 40000210 00000200 80f04ec8 f17ddddc 00000000 f0801f18 8266=
0580
> 1ec0: 8393cd80 00000000 00000000 8393cd98 838f04e2 7f13791c 00000000 0000=
0000
> 1ee0: 82660580 00004288 00000000 838f04e2 82660580 8393cd98 82660580 838f=
04e2
> 1f00: 82660a8c 7f1906b0 7f190708 00000000 40000006 7f137d18 8368578c 8393=
cd98
> 1f20: 8393cd80 00000000 00000000 00000000 00000000 00000000 82660a8c 80f0=
4ec8
> 1f40: 8393cd80 82660580 82660a7c 7f1347f8 00000000 80f04ec8 00000001 8266=
0a64
> 1f60: 00000000 eefad338 00000000 00000006 80be7f14 801246f8 00000006 80f0=
3098
> 1f80: 80f03080 81504c80 00000101 8010140c f0861e78 80915818 8225e100 f080=
1f90
> 1fa0: 80f03080 80e543c0 80c059f4 0000000a 80e56a40 80e56a40 80e54334 80c2=
84f4
> 1fc0: 00005a10 80f03d40 80a01e20 04208040 80c059f4 80e56a40 20000013 ffff=
ffff
> 1fe0: f0861eb4 81504c80 81504c80 80f050b4 f0861e78 801245ac 80144024 8047=
72fc
> kfree_skb_list_reason from ieee80211_report_used_skb+0xd0/0x5b4 [mac80211=
]
> ieee80211_report_used_skb [mac80211] from ieee80211_tx_status_ext+0x4c8/0=
x850 [mac80211]
> ieee80211_tx_status_ext [mac80211] from ieee80211_tx_status+0x74/0x9c [ma=
c80211]
> ieee80211_tx_status [mac80211] from ieee80211_tasklet_handler+0xb0/0xd8 [=
mac80211]
> ieee80211_tasklet_handler [mac80211] from tasklet_action_common.constprop=
.0+0xb0/0xc4
> tasklet_action_common.constprop.0 from __do_softirq+0x14c/0x2c0
> __do_softirq from irq_exit+0x98/0xc8
> irq_exit from call_with_stack+0x18/0x20
> call_with_stack from __irq_svc+0x98/0xc8
> Exception stack(0xf0861e80 to 0xf0861ec8)
> 1e80: 00000001 00000002 00000001 81504c80 eefafdc0 00000000 81590880 0000=
0000
> 1ea0: 81504c80 81505248 80f050b4 f0861f14 f0861f18 f0861ed0 80915bec 8014=
4024
> 1ec0: 20000013 ffffffff
> __irq_svc from finish_task_switch+0xa8/0x270
> finish_task_switch from __schedule+0x25c/0x628
> __schedule from schedule+0x5c/0xb4
> schedule from smpboot_thread_fn+0xbc/0x23c
> smpboot_thread_fn from kthread+0xf4/0x124
> kthread from ret_from_fork+0x14/0x2c
> Exception stack(0xf0861fb0 to 0xf0861ff8)
> 1fa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 00000000 00000000 00000000 00000000
> 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000=
0000
> 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> Code: e92d4010 e2504000 08bd8010 e1a00004 (e5944000) =C2=A0
> [=C2=A0 5]=C2=A0 24.00-25.00=C2=A0 sec=C2=A0=C2=A0 765 KBy---[ end trace =
0000000000000000 ]---
> tes=C2=A0 6.27 Mbits/sec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Kernel panic - not syncing: Fatal exception =
in interrupt
> CPU2: stopping
> CPU: 2 PID: 0 Comm: swapper/2 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.0.0-rc=
5-dnm3pv2+g047dc4cf9a10 #1
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> unwind_backtrace from show_stack+0x10/0x14
> show_stack from dump_stack_lvl+0x40/0x4c
> dump_stack_lvl from do_handle_IPI+0x100/0x128
> do_handle_IPI from ipi_handler+0x18/0x20
> ipi_handler from handle_percpu_devid_irq+0x8c/0x138
> handle_percpu_devid_irq from generic_handle_domain_irq+0x24/0x34
> generic_handle_domain_irq from gic_handle_irq+0x74/0x88
> gic_handle_irq from generic_handle_arch_irq+0x58/0x78
> generic_handle_arch_irq from call_with_stack+0x18/0x20
> call_with_stack from __irq_svc+0x98/0xc8
> Exception stack(0xf0871f10 to 0xf0871f58)
> 1f00:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 00000002 80bf66e8 00000001 6e16f000
> 1f20: 00000000 80f0a668 00000000 00000000 a05c2adc a0629de7 eefc50c8 0000=
007b
> 1f40: fffffff5 f0871f60 80155d84 807006d8 60030013 ffffffff
> __irq_svc from cpuidle_enter_state+0x158/0x358
> cpuidle_enter_state from cpuidle_enter+0x40/0x50
> cpuidle_enter from do_idle+0x19c/0x208
> do_idle from cpu_startup_entry+0x18/0x1c
> cpu_startup_entry from secondary_start_kernel+0x148/0x150
> secondary_start_kernel from 0x10101620
> CPU3: stopping
> CPU: 3 PID: 0 Comm: swapper/3 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.0.0-rc=
5-dnm3pv2+g047dc4cf9a10 #1
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> unwind_backtrace from show_stack+0x10/0x14
> show_stack from dump_stack_lvl+0x40/0x4c
> dump_stack_lvl from do_handle_IPI+0x100/0x128
> do_handle_IPI from ipi_handler+0x18/0x20
> ipi_handler from handle_percpu_devid_irq+0x8c/0x138
> handle_percpu_devid_irq from generic_handle_domain_irq+0x24/0x34
> generic_handle_domain_irq from gic_handle_irq+0x74/0x88
> gic_handle_irq from generic_handle_arch_irq+0x58/0x78
> generic_handle_arch_irq from call_with_stack+0x18/0x20
> call_with_stack from __irq_svc+0x98/0xc8
> Exception stack(0xf0875f10 to 0xf0875f58)
> 5f00:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 00000003 80bf66e8 00000001 6e17a000
> 5f20: 00000000 80f0a668 00000000 00000000 a05c5ef1 a0629de7 eefd00c8 0000=
007b
> 5f40: fffffff5 f0875f60 80155d84 807006d8 60000013 ffffffff
> __irq_svc from cpuidle_enter_state+0x158/0x358
> cpuidle_enter_state from cpuidle_enter+0x40/0x50
> cpuidle_enter from do_idle+0x19c/0x208
> do_idle from cpu_startup_entry+0x18/0x1c
> cpu_startup_entry from secondary_start_kernel+0x148/0x150
> secondary_start_kernel from 0x10101620
> CPU1: stopping
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.0.0-rc=
5-dnm3pv2+g047dc4cf9a10 #1
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> unwind_backtrace from show_stack+0x10/0x14
> show_stack from dump_stack_lvl+0x40/0x4c
> dump_stack_lvl from do_handle_IPI+0x100/0x128
> do_handle_IPI from ipi_handler+0x18/0x20
> ipi_handler from handle_percpu_devid_irq+0x8c/0x138
> handle_percpu_devid_irq from generic_handle_domain_irq+0x24/0x34
> generic_handle_domain_irq from gic_handle_irq+0x74/0x88
> gic_handle_irq from generic_handle_arch_irq+0x58/0x78
> generic_handle_arch_irq from call_with_stack+0x18/0x20
> call_with_stack from __irq_svc+0x98/0xc8
> Exception stack(0xf086df10 to 0xf086df58)
> df00:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 00000001 80bf66e8 00000001 6e164000
> df20: 00000000 80f0a668 00000000 00000000 a05c2d77 a0629de7 eefba0c8 0000=
007b
> df40: fffffff5 f086df60 80155d84 807006d8 600e0013 ffffffff
> __irq_svc from cpuidle_enter_state+0x158/0x358
> cpuidle_enter_state from cpuidle_enter+0x40/0x50
> cpuidle_enter from do_idle+0x19c/0x208
> do_idle from cpu_startup_entry+0x18/0x1c
> cpu_startup_entry from secondary_start_kernel+0x148/0x150
> secondary_start_kernel from 0x10101620
>
> However, the corruption can manifest itself in different ways as well -
> - sometimes even damaging contents of onboard NAND flash.
> Similar traces have appeared previously in other places as well.
> In addition to testing on 6.0-rc5, we tried cherry-picking 047dc4cf9a10b4=
f2dc164b8bf192de583f3ebfee
> from wireless-next as well, but this seems unrelated to the issue on firs=
t glance,
> and doesn't prevent crashes.
>
> I post relevant bits of device tree we used to get the module to work bel=
ow.
> We're using in-band IRQ of the SDIO interface:
>
> / {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wfx_pwrseq: wfx_pwrseq {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 compatible =3D "mmc-pwrseq-simple";
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-names =3D "default";
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-0 =3D <&pinctrl_wfx_reset>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 reset-gpios =3D <&gpio7 8 GPIO_ACTIVE_LOW>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
> =C2=A0};
>
> &iomuxc {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 usdhc1 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl_usdhc1_3: usdhc1grp-3 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs=
l,pins =3D <
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_CMD__SD1_CMD=
=C2=A0=C2=A0=C2=A0 0x17059
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_CLK__SD1_CLK=
=C2=A0=C2=A0=C2=A0 0x10059
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_DAT0__SD1_DATA=
0 0x17059
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_DAT1__SD1_DATA=
1 0x17059
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_DAT2__SD1_DATA=
2 0x17059
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_DAT3__SD1_DATA=
3 0x17059
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD3_CLK__GPIO7_IO0=
3 0x17041
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD3_CMD__GPIO7_IO0=
2 0x13019
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 >;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 };
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl_wfx_reset: wfx-reset-grp {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs=
l,pins =3D <
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD3_RST__GPIO7_IO0=
8 0x1B030
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 >;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 };
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
> };
>
> &usdhc1 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 status =3D "okay";
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #address-cells =3D <1>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #size-cells =3D <0>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-names =3D "defau=
lt";
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-0 =3D <&pinctrl_=
usdhc1_3>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap-power-off-card;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 keep-power-in-suspend;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap-sdio-irq;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wakeup-source;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disable-wp;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap-sd-highspeed;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bus-width =3D <4>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 non-removable;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 no-mmc;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 no-sd;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mmc-pwrseq =3D <&wfx_pwr=
seq>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wifi@1 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 compatible =3D "silabs,brd8023a";
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 reg =3D <1>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 wakeup-gpios =3D <&gpio7 2 GPIO_ACTIVE_HIGH>;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
> };
>
> With that, the device probes successfully, and we can get 22Mbps of traff=
ic with a 1T1R peer
> in HT20 mode in both directions.
> SDIO singals were checked with the oscilloscope, and they look perfectly =
fine,
> so I think we can rule out any hardware issue.
>
> By adding a canary to slab allocator, we managed to find, that the skb st=
ructures gets damaged,
> and then improperly dereferenced by the driver somewhere in TX queue hand=
ling code.
>
> With SMP disabled, the issue still manifests itself, hinting at synchroni=
zation issue
> between the interrupt context, and the tasklets handling the bulk of work=
.
> However, it usually takes a longer time to reproduce - still in order of =
a few minutes.
> In some cases the kernel would detect use-after-free by itself - without =
modification -
> or the reference counts get corrupted.
>
> This stacktrace comes from one of the runs with CONFIG_SMP disabled:
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 10 at lib/refcount.c:28 ieee80211_tx_status_ext+0x4f=
8/0x968 [mac80211]
> refcount_t: underflow; use-after-free.
> Modules linked in: xt_LOG nf_log_syslog xt_limit iptable_mangle xt_connma=
rk xt_tcpudp xt_conntrack
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_tab=
les cdc_mbim cdc_wdm cdc_ncm
> cdc_ether usbnet cdc_acm usb_serial_simple usbserial usb_f_rndis u_ether =
wfx mac80211 libarc4 evbug
> phy_generic cfg80211 adt7475 hwmon_vid ci_hdrc_imx ci_hdrc ulpi roles usb=
misc_imx pwm_imx27
> pwm_beeper libcomposite configfs udc_core
> CPU: 0 PID: 10 Comm: ksoftirqd/0 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.19.2+ge4fb=
6643395f #1
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> unwind_backtrace from show_stack+0x10/0x14
> show_stack from dump_stack_lvl+0x24/0x2c
> dump_stack_lvl from __warn+0xb0/0xd8
> __warn from warn_slowpath_fmt+0x98/0xc8
> warn_slowpath_fmt from ieee80211_tx_status_ext+0x4f8/0x968 [mac80211]
> ieee80211_tx_status_ext [mac80211] from ieee80211_tx_status+0x74/0x9c [ma=
c80211]
> ieee80211_tx_status [mac80211] from ieee80211_tasklet_handler+0xb0/0xd8 [=
mac80211]
> ieee80211_tasklet_handler [mac80211] from tasklet_action_common.constprop=
.0+0xb4/0xc0
> tasklet_action_common.constprop.0 from __do_softirq+0x12c/0x290
> __do_softirq from irq_exit+0x90/0xbc
> irq_exit from call_with_stack+0x18/0x20
> call_with_stack from __irq_svc+0x94/0xc4
> Exception stack(0xf0859e98 to 0xf0859ee0)
> 9e80:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00000001 81080780
> 9ea0: 00000001 81080780 00000000 00000002 822f0780 808e82cc 81080780 8108=
0c50
> 9ec0: 00000000 f0859f14 f0859f18 f0859ee8 801404f0 80140624 20000013 ffff=
ffff
> __irq_svc from finish_task_switch+0x78/0x1f8
> finish_task_switch from __schedule+0x244/0x580
> __schedule from schedule+0x5c/0xb4
> schedule from smpboot_thread_fn+0xb8/0x224
> smpboot_thread_fn from kthread+0xe4/0x114
> kthread from ret_from_fork+0x14/0x2c
> Exception stack(0xf0859fb0 to 0xf0859ff8)
> 9fa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 00000000 00000000 00000000 00000000
> 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000=
0000
> 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> ---[ end trace 0000000000000000 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1131 at lib/refcount.c:22 __tcp_transmit_skb+0x7a4/0=
xa8c
> =C2=A0=C2=A0 =C2=A0
> refcount_t: saturated; leaking memory.
> Modules linked in: xt_LOG nf_log_syslog xt_limit iptable_mangle xt_connma=
rk xt_tcpudp xt_conntrack
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_tab=
les cdc_mbim cdc_wdm cdc_ncm
> cdc_ether usbnet cdc_acm usb_serial_simple usbserial usb_f_rndis u_ether =
wfx mac80211 libarc4 evbug
> phy_generic cfg80211 adt7475 hwmon_vid ci_hdrc_imx ci_hdrc ulpi roles usb=
misc_imx pwm_imx27
> pwm_beeper libcomposite configfs udc_core
> CPU: 0 PID: 1131 Comm: kworker/0:2H Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.19.2+ge=
4fb6643395f #1
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Workqueue: wfx_bh_wq bh_work [wfx]
> unwind_backtrace from show_stack+0x10/0x14
> show_stack from dump_stack_lvl+0x24/0x2c
> dump_stack_lvl from __warn+0xb0/0xd8
> __warn from warn_slowpath_fmt+0x98/0xc8
> warn_slowpath_fmt from __tcp_transmit_skb+0x7a4/0xa8c
> __tcp_transmit_skb from __tcp_send_ack.part.0+0xd0/0x13c
> __tcp_send_ack.part.0 from tcp_delack_timer_handler+0xb0/0x180
> tcp_delack_timer_handler from tcp_delack_timer+0x2c/0x128
> tcp_delack_timer from call_timer_fn.constprop.0+0x18/0x80
> call_timer_fn.constprop.0 from run_timer_softirq+0x2ec/0x3b0
> run_timer_softirq from __do_softirq+0x12c/0x290
> __do_softirq from call_with_stack+0x18/0x20
> call_with_stack from do_softirq+0x6c/0x70
> do_softirq from __local_bh_enable_ip+0xd8/0xdc
> __local_bh_enable_ip from __netdev_alloc_skb+0x14c/0x170
> __netdev_alloc_skb from bh_work+0x1b0/0x650 [wfx]
> bh_work [wfx] from process_one_work+0x1b8/0x3ec
> process_one_work from worker_thread+0x4c/0x57c
> worker_thread from kthread+0xe4/0x114
> kthread from ret_from_fork+0x14/0x2c
> Exception stack(0xf161dfb0 to 0xf161dff8)
> dfa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 00000000 00000000 00000000 00000000
> dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000=
0000
> dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> ---[ end trace 0000000000000000 ]---
> [=C2=A0 5] 536.16-537.00 sec=C2=A0 26.9 KBytes=C2=A0=C2=A0 261 Kbits/sec=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0
> [=C2=A0 5] 537.00-538.00 sec=C2=A0 2.71 MBytes=C2=A0 22.7 Mbits/sec=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =C2=A0
> 8<--- cut here ---
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
11c
> [0000011c] *pgd=3D00000000
> Internal error: Oops: 5 [#1] PREEMPT ARM
> Modules linked in: xt_LOG nf_log_syslog xt_limit iptable_mangle xt_connma=
rk xt_tcpudp
> xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip=
_tables x_tables
> cdc_mbim cdc_wdm cdc_ncm cdc_ether usbnet cdc_acm usb_serial_simple usbse=
rial
> usb_f_rndis u_ether wfx mac80211 libarc4 evbug phy_generic cfg80211 adt74=
75
> hwmon_vid ci_hdrc_imx ci_hdrc ulpi roles usbmisc_imx pwm_imx27 pwm_beeper
> libcomposite configfs udc_core
> CPU: 0 PID: 10 Comm: ksoftirqd/0 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.19.2+ge4fb=
6643395f #1
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> PC is at ip6_rcv_core+0x110/0x68c
> LR is at ip6_rcv_core+0xb0/0x68c
> pc : [<8084d278>]=C2=A0=C2=A0=C2=A0 lr : [<8084d218>]=C2=A0=C2=A0=C2=A0 p=
sr: 20000013
> sp : f0859e18=C2=A0 ip : 00000000=C2=A0 fp : 80e13cc0
> r10: 00000000=C2=A0 r9 : 80e13cf4=C2=A0 r8 : 81b65000
> r7 : 80e6d7c8=C2=A0 r6 : 82024c00=C2=A0 r5 : 812a8760=C2=A0 r4 : 81be5b40
> r3 : 00000000=C2=A0 r2 : 00000100=C2=A0 r1 : 000000d7=C2=A0 r0 : 00000000
> Flags: nzCv=C2=A0 IRQs on=C2=A0 FIQs on=C2=A0 Mode SVC_32=C2=A0 ISA ARM=
=C2=A0 Segment none
> Control: 10c53c7d=C2=A0 Table: 12338059=C2=A0 DAC: 00000051
> Register r0 information: NULL pointer
> Register r1 information: non-paged memory
> Register r2 information: non-paged memory
> Register r3 information: NULL pointer
> Register r4 information: slab skbuff_head_cache start 81be5b40 pointer of=
fset 0 size 48
> Register r5 information: non-slab/vmalloc memory
> Register r6 information: slab kmalloc-1k start 82024c00 pointer offset 0 =
size 1024
> Register r7 information: non-slab/vmalloc memory
> Register r8 information: slab kmalloc-2k start 81b65000 pointer offset 0 =
size 2048
> Register r9 information: non-slab/vmalloc memory
> Register r10 information: NULL pointer
> Register r11 information: non-slab/vmalloc memory
> Register r12 information: NULL pointer
> Process ksoftirqd/0 (pid: 10, stack limit =3D 0x7cac7060)
> Stack: (0xf0859e18 to 0xf085a000)
> 9e00:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 81b65000 80e13d00
> 9e20: 80e6d7c8 80e13cc8 00000040 80e13cf4 00000000 8084da90 80d0ce80 80d0=
424c
> 9e40: 80d0ce80 81b65000 80e13d00 00000001 80e13cc8 80d0424c 8084da60 80e1=
3d00
> 9e60: 00000001 807691c0 00000001 81be5b40 80d06654 80d0424c 81be5b40 8076=
9348
> 9e80: 00000001 80e13d00 00000040 f0859ecb 80dd6000 00008b6a f0859ed4 8076=
9ec4
> 9ea0: 00000001 81080780 00000000 80e13d00 0000012c 00000000 f0859ecc 8076=
a2d8
> 9ec0: 00008b6c 81080780 00859f18 f0859ecc f0859ecc f0859ed4 f0859ed4 80d0=
424c
> 9ee0: 00000051 00000000 00000003 80e15834 80e15828 81080780 00000100 80ad=
b4e4
> 9f00: 40000003 801013f4 821d9540 00000000 f0859f5c 80e15828 80d0d390 80e1=
3c80
> 9f20: 80af6e3c 0000000a 80d0b588 80b19518 00008b6b 80dd6000 04208040 8090=
1dd0
> 9f40: 81080780 00000000 8102de00 81080780 80d0b558 00000001 00000001 0000=
0000
> 9f60: 00000000 80120a18 00000000 8013e590 8102de40 8102df00 8013e42c 8102=
de00
> 9f80: 81080780 f0835e30 00000000 8013a85c 8102de40 8013a778 00000000 0000=
0000
> 9fa0: 00000000 00000000 00000000 80100148 00000000 00000000 00000000 0000=
0000
> 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000=
0000
> 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 0000=
0000
> ip6_rcv_core from ipv6_rcv+0x30/0xd4
> ipv6_rcv from __netif_receive_skb_one_core+0x5c/0x80
> __netif_receive_skb_one_core from process_backlog+0x70/0xe4
> process_backlog from __napi_poll+0x2c/0x1f0
> __napi_poll from net_rx_action+0x140/0x264
> net_rx_action from __do_softirq+0x12c/0x290
> __do_softirq from run_ksoftirqd+0x34/0x3c
> run_ksoftirqd from smpboot_thread_fn+0x164/0x224
> smpboot_thread_fn from kthread+0xe4/0x114
> kthread from ret_from_fork+0x14/0x2c
> Exception stack(0xf0859fb0 to 0xf0859ff8)
> 9fa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 00000000 00000000 00000000 00000000
> 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000=
0000
> 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> Code: e5843024 e5843028 e584302c 0a000055 (e1d231bc) =C2=A0
> ---[ end trace 0000000000000000 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
>
> Now, the questions:
> - Is "silabs,brd8023a" the proper compatible string for WFM200S022XNN3, o=
r should we create our
> =C2=A0 own for the bare module, even if just the in-band SDIO IRQ, and an=
 external antenna is in use?
> - In order to try out the out-of-band IRQ - in hope that it resolves the =
issue somehow - do we need to create custom PDS file?
> =C2=A0 With the IRQ enabled, probe fails with "Chip did not answer" error=
.
> - Tracing memory corruptions is hard - is there a mechanism that could he=
lp us out better than generic methods like kprobes,
> =C2=A0 or implementing canaries? As skb's are heavily re-used for perform=
ance reasons, tracing their lifecycle is especially hard.
> =C2=A0 Our first idea was to lock their respective pages from writing, on=
ce they are enqueued in the wfx TX queue,
> =C2=A0 so MMU detects the corruption at the exact time it happens, but we=
 haven't figure out how to modify skb allocator to accomplish that,
> =C2=A0 especially given that the issue mostly happens when transmitting, =
so skbs are allocated outside of the driver.
> =C2=A0 Maybe there exists a similar mechanism - that could help us out - =
even if just in the works?
>
> Any help will be greatly appreciated - we'll be very happy to provide a p=
atch if we manage to figure the issue out.
>
>
> W dniu 12.09.2022 o=C2=A018:15, J=C3=A9r=C3=B4me Pouiller pisze:
>> On Monday 12 September 2022 17:16:24 CEST Lech Perczak wrote:
>>> Hello,
>>>
>>> We're trying to get a WFM200S022XNN3 module working on a custom i.MX6Q =
board using SDIO interface, using upstream kernel. Our patches concern prim=
arily the device tree for the board - and upstream firmware from linux-firm=
ware repository.
>>>
>>> During that, we stumbled upon a memory corruption issue, which appears =
when big traffic is passing through the device. Our adapter is running in A=
P mode. This can be reproduced with 100% rate using iperf3, by starting an =
AP interface on the device, and an iperf3 server. Then, the client station =
runs iperf3 with "iperf3 -c <hostname> -t 3600" command - so the AP is send=
ing data for up to one hour, however - the kernel on our device crashes aft=
er around a few minutes of traffic, sometimes less than a minute.
>>>
>>> The behaviour is the same on kernel v5.19.7, v5.19.2, and even with v6.=
0-rc5. Tests on v6.0-rc5 have shown most detailed stacktrace so far:
>>>
>> Hello Lech,
>>
>> It seems that something somewhere (Ms Exchange, I am looking at you) has
>> removed all the newlines of your mail :-/. Can you try to fix the proble=
m?
>> I think that sending mails using base64 encoding would solve the issue.
>>
>>
>> [...]
>>
>> --
>> J=C3=A9r=C3=B4me Pouiller

--=20
Pozdrawiam/With kind regards,
Lech Perczak

Sr. Software Engineer
Camlin Technologies Poland Limited Sp. z o.o.
Strzegomska 54,
53-611 Wroclaw
Tel:     (+48) 71 75 000 16
Email:   lech.perczak@camlingroup.com
Website: http://www.camlingroup.com

