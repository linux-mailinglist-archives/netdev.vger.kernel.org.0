Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE65B5E7E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiILQq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiILQq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:46:57 -0400
X-Greylist: delayed 5418 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Sep 2022 09:46:53 PDT
Received: from eu-smtp-delivery-197.mimecast.com (eu-smtp-delivery-197.mimecast.com [185.58.86.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C302D1EC
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 09:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=camlingroup.com;
        s=mimecast20210310; t=1663001211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CuxseI0oQ1PTi9QxGxWo2l/Ar5QWZ6fow3y+R2oEdkk=;
        b=cz816At/3nh6pwBcEBbWUYgTRTp1Ad+c421FZA9wkS5m1mynH8WlJCLUZhQYABqU/x10YL
        sRM85pka83kQmzgcfNvP4+Asc7gIz60hXPLibVuGgrG37LopumfD1G/E6z9yYQgCZfRzaj
        ztW8PhSvrvIR1iHPdfnfuSY5oUwjAK0=
Received: from GBR01-LO2-obe.outbound.protection.outlook.com
 (mail-lo2gbr01lp2050.outbound.protection.outlook.com [104.47.21.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 uk-mta-55-l-PBogUKPmW045DnQKP7JQ-1; Mon, 12 Sep 2022 17:46:47 +0100
X-MC-Unique: l-PBogUKPmW045DnQKP7JQ-1
Received: from CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:142::9)
 by LO0P123MB6736.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:2cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 16:46:46 +0000
Received: from CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM
 ([fe80::1066:dd62:379f:a429]) by CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM
 ([fe80::1066:dd62:379f:a429%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 16:46:46 +0000
Message-ID: <12e5adcd-8aed-f0f7-70cc-4fb7b656b829@camlingroup.com>
Date:   Mon, 12 Sep 2022 18:46:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: wfx: Memory corruption during high traffic with WFM200 on i.MX6Q
 platform
To:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Pawe=c5=82_Lenkow?= <pawel.lenkow@camlingroup.com>
CC:     Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?Q?Krzysztof_Drobi=c5=84ski?= 
        <krzysztof.drobinski@camlingroup.com>,
        Kirill Yatsenko <kirill.yatsenko@camlingroup.com>
References: <16b90f1d-69b4-72ac-7018-66d524f514f9@camlingroup.com>
 <3193501.44csPzL39Z@pc-42>
From:   Lech Perczak <lech.perczak@camlingroup.com>
In-Reply-To: <3193501.44csPzL39Z@pc-42>
X-ClientProxiedBy: BE1P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::9) To CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:142::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWXP123MB5267:EE_|LO0P123MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: cd60df61-cf1a-40d5-8e23-08da94de6111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: FdzaSGOkgSQYCsmCDMJd8TDHWaDlzubJm+x+UZukjrX60Hh87OAtnrkE7yoYDythcFljFFq24q3O81I8ei8uXMv5FEtMmkFgGxLw++vIVidm6aNZdldJ71vxA6ZP5+5L3mT3dzhRKH9iKjFq7cOvoyL2ZvDE2oG+WwTjJLFlJ+JXloASs4AxvS/IQOdVbNJ5MfJNrkn5ZIzjw/+BJao5KxUPoNkSPZ7OjpuRpoDEqLcI7B7CiW5+9G009VZAxciZZh0nRmLWFmQjQN6u7XbuSwWKr617b3Cn2kl2oEbYwctmgbgcNHP3oRwahyMr5+vtpWLglfHhSQRbnrt/vnLiF1IXoj2bBUtGJ+xDNsCw5eFCo+jYJmQoVrgZdI5mDql1aoRLL9eR1F7HJe62Imlc5LT9iFtthnHp1c9HgQRlhCsxMmaGKBawRCfmvBQU56aQ3InA6pV35Seun2lJzQdWHsgcbuj1NfEnlcbZFFaSrOUhg5Eg9npd68ARIgMb5fnpMfp+YvLt19KnQtrq8Z4TZRYJpnEt0xUzPhN/jXgwK0mwxuN9SXkKcauiYMJ0nSkondsNgE2e4lQOLqouD+sCsOhHy1pgWfxPd4Dd+uqYE0OiSiorsBPmKLafZyLNuTPtS7lyiCZGlcMr5goFiI5vPvAE4JUa5CQaQeIHa5/IkiHjBXvuo7mXXh07siQxIfx/TP4LZMCvsR45p+vfXuN0o2uVjXbU8lHZWNLmh5zwgOb7af2BTf4wSBh0A7Ncy3gfU1e1flQyu/OvuQ/tZBNNLe2JGOkLrZaidFzVii9rXrfEEHJTX01ficQiVfdg183x0A0K3vR+kwcruTpbHLcbOIVs/oaFGe3jEgOI5MCzva4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230017)(39850400004)(396003)(346002)(376002)(136003)(366004)(41300700001)(8936002)(186003)(2616005)(36756003)(6506007)(6512007)(2906002)(38100700002)(52116002)(44832011)(86362001)(31696002)(30864003)(66574015)(83380400001)(31686004)(6486002)(478600001)(316002)(6636002)(54906003)(966005)(110136005)(5660300002)(107886003)(8676002)(4326008)(45080400002)(66476007)(66556008)(66946007)(45980500001)(43740500002)(18886065003);DIR:OUT;SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OCsZ8KtiQe0is+H5FKdDephK3zHhkhBLV2x7KlBVLV6Vg4aIMiHV8VahohkI?=
 =?us-ascii?Q?H3YoznuBauJ+GUgP9vlsfjiI5M0ECzTax+mMmDXxfktmzG4/2TJL8VX6nk8I?=
 =?us-ascii?Q?VNqzcmgCeenkCa9K1kjODeB+OFFdT7WpvOYLptBoDo8PEB0zs+ZUqrwwvMR8?=
 =?us-ascii?Q?oLEb28GXiU4cbqyYOdiZHYalssULWlPiFV5qUbW29tAhasHxEuyHHWFbJzLQ?=
 =?us-ascii?Q?3WIvAC0kLW6XMS7DqKaIxoYYvxdphQLbKc6UDggJTgzKfmSNt22/4k3yHcyK?=
 =?us-ascii?Q?QAAgK28BIm+tii4RKScdYQt3xCg7Ab5ZjmQhyvKNwsBeBvwuyc3hjcnbsWi/?=
 =?us-ascii?Q?Yxl/z6nwbAXJBnOdOUqOLaNkf/Xmc1ks0UmCOC+UoXuYXmMq+woKJLjoRMfs?=
 =?us-ascii?Q?S2tcFtdrvo88P3zvfA71ubpwi+5/uBQgtXIYUYgfrFEY8lW1YiPJ6BSuhKhE?=
 =?us-ascii?Q?qBZIerhLpohBiVYKGzIECtF5Sq8LqUs0u6gGJHeIcQdk1UJzUpCNxn/bSItq?=
 =?us-ascii?Q?XwUgtO1c2KhYYciO3LrwjAzWCSGMRwPsdMwW/d+4+UoSZwJlhGeZ7RvgVR5Q?=
 =?us-ascii?Q?d2fWISnrpG14oUo82LyAYWv96BrnOJ5Xjh1DHcilOilDy4yuU56qAdZ/b/42?=
 =?us-ascii?Q?WK1+6BSOCPbUYhYOeswrbdbUMoEUvnE6yOxk+o7D6G/lIStoMfaB+NrTgyxL?=
 =?us-ascii?Q?404NQJG2xwwu5NozARkPc651UB3T0GMaCFngnUXicN2BZ7SXBjJ3om83LF6d?=
 =?us-ascii?Q?QQ0N62+EqAxXZQnsADfG3TRS6iICgdFsYNQUnEFRNAw3nr+jhTLC2YAve+f/?=
 =?us-ascii?Q?bvl0OXlPCdxSPfl8TjDHMN7gXAfcMbz/Mhc58EtBSI3hVm8+1p8YU7ktW6s2?=
 =?us-ascii?Q?apXHsLHwl2cQK3tM9Iv9sB7AXZ9yavRvtTMJGZlCPMIEyC5B44oTw7nnu1dG?=
 =?us-ascii?Q?2HP9eLloYUUhdxwFOi8JWKmNmDFu3KZi3b+Rl4czI25/g+ruKep5HsvMFwFV?=
 =?us-ascii?Q?YNPHhIhsaIQHs1WX7cH+/O+JQseiRkCSvCH3VN1beN7NV32GbPgkJND0H1oF?=
 =?us-ascii?Q?/WdsXiBfWdoAeuPh7YKmhjZF5GXArkfvhv8/CjyfI3FhAOpLk1aussjmCK+f?=
 =?us-ascii?Q?o35Q2VzZS3EgTjP4MV8tY897fzH8jcvz9iE/YxjrHUg9LTji1wfQd+xd4OdR?=
 =?us-ascii?Q?+16SJfs4ZjvIBhV2JunZgzbUT6mLSRv1GVtqt1Dxdz8pl7hn8jAak+Qi/5WE?=
 =?us-ascii?Q?zDcC+Abe5axHrxy21XYGWuuxevAeZGOl9asXCXpQpHYzMlJ3Yx9tkwIDUOgG?=
 =?us-ascii?Q?OISF+snE7crtDs04CXwKU7tn1H/GfxgOpezZW+xZo4yg1bs2twQBpMk7cu6N?=
 =?us-ascii?Q?0XzxIRbp8r4kT40NZiUwds2GGHiUmdL8wEuKtb6wNS+YCHn/n/uR6q932dzV?=
 =?us-ascii?Q?C7d9WsyE0yKUPdTdUG7jPfoJly/dV+PajK65qwP4C64eD0R77wAwlbdaYIGD?=
 =?us-ascii?Q?HSShx+LRWT5yEifFGJNdm+Qp1hPxUtZMxso5oOhSeDc2JQGFlBxAR+V1zYRE?=
 =?us-ascii?Q?nN8fAgh6X9+L/xaeEKs60ltfGarFb26miMnWR9f8LTZYtsyT05a50ul88OmR?=
 =?us-ascii?Q?e86yinuYhArd5/+L2yfG15mABk/juyAadzRej5FtSocIAJxUvXHckqfLu9SP?=
 =?us-ascii?Q?eGfcfw=3D=3D?=
X-OriginatorOrg: camlingroup.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd60df61-cf1a-40d5-8e23-08da94de6111
X-MS-Exchange-CrossTenant-AuthSource: CWXP123MB5267.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 16:46:45.9630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chtE0ubiQSbfViXApHCCqQVfj1ymA0pzQ3c7f1THvuk+630SIsY7vNZwWueQeptr/iLuf1hrNF+kZhsEoCu0kc4kFniAnhByfAp/qs+J4po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB6736
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: camlingroup.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi J=C3=A9r=C3=B4me,

Probably a Thunderbird mess-up. Let's try again, I hope it works - I probab=
ly fiddled too much with the settings to make it send plain-text.

We're trying to get a WFM200S022XNN3 module working on a custom i.MX6Q boar=
d using SDIO interface, using upstream kernel.
Our patches concern primarily the device tree for the board - and upstream =
firmware from linux-firmware repository.

During that, we stumbled upon a memory corruption issue, which appears when=
 big traffic is passing through the device.
Our adapter is running in AP mode. This can be reproduced with 100% rate us=
ing iperf3,
by starting an AP interface on the device, and an iperf3 server.
Then, the client station runs iperf3 with "iperf3 -c <hostname> -t 3600" co=
mmand - so the AP is sending data for up to one hour,
however - the kernel on our device crashes after around a few minutes of tr=
affic, sometimes less than a minute.

The behaviour is the same on kernel v5.19.7, v5.19.2, and even with v6.0-rc=
5. Tests on v6.0-rc5 have shown most detailed stacktrace so far:

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 0000010=
1
[00000101] *pgd=3D00000000
Internal error: Oops: 17 [#1] PREEMPT SMP ARM
Modules linked in: xt_LOG nf_log_syslog xt_limit iptable_mangle xt_connmark=
 xt_tcpudp xt_conntrack
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_table=
s cdc_mbim cdc_wdm cdc_ncm
cdc_ether usbnet cdc_acm usb_serial_simple usbserial usb_f_rndis u_ether wf=
x mac80211 libarc4 cfg80211 evbug
phy_generic ci_hdrc_imx ci_hdrc adt7475 hwmon_vid ulpi roles usbmisc_imx pw=
m_imx27
pwm_beeper libcomposite configfs udc_core
CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 6.0.0-rc5-dnm3pv2+g047dc4cf9a1=
0 #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
PC is at kfree_skb_list_reason+0x10/0x24
LR is at ieee80211_report_used_skb+0xd0/0x5b4 [mac80211]
pc : [<80773238>]=C2=A0=C2=A0=C2=A0 lr : [<7f136538>]=C2=A0=C2=A0=C2=A0 psr=
: 20000113
sp : f0801e60=C2=A0 ip : 00000000=C2=A0 fp : 838f04e2
r10: 00000001=C2=A0 r9 : 838f04e2=C2=A0 r8 : 00000000
r7 : 82661580=C2=A0 r6 : 00000000=C2=A0 r5 : 82660580=C2=A0 r4 : 00000101
r3 : 838f0700=C2=A0 r2 : 00000032=C2=A0 r1 : 00000001=C2=A0 r0 : 00000101
Flags: nzCv=C2=A0 IRQs on=C2=A0 FIQs on=C2=A0 Mode SVC_32=C2=A0 ISA ARM=C2=
=A0 Segment none
Control: 10c5387d=C2=A0 Table: 11d0004a=C2=A0 DAC: 00000051
Register r0 information: non-paged memory
Register r1 information: non-paged memory
Register r2 information: non-paged memory
Register r3 information: slab kmalloc-1k start 838f0400 pointer offset 768 =
size 1024
Register r4 information: non-paged memory
Register r5 information: slab kmalloc-8k start 82660000 pointer offset 1408=
 size 8192
Register r6 information: NULL pointer
Register r7 information: slab kmalloc-8k start 82660000 pointer offset 5504=
 size 8192
Register r8 information: NULL pointer
Register r9 information: slab kmalloc-1k start 838f0400 pointer offset 226 =
size 1024
Register r10 information: non-paged memory
Register r11 information: slab kmalloc-1k start 838f0400 pointer offset 226=
 size 1024
Register r12 information: NULL pointer
Process ksoftirqd/0 (pid: 10, stack limit =3D 0x1fff5f96)
Stack: (0xf0801e60 to 0xf0802000)
1e60: 8393cd80 7f136538 00000000 81590f34 80f050b4 20000193 f0801ecc 7f189a=
7c
1e80: 00000032 00000005 823f0458 f0801f18 81c51a00 8368504c 7f189854 838980=
00
1ea0: 8226ac40 40000210 00000200 80f04ec8 f17ddddc 00000000 f0801f18 826605=
80
1ec0: 8393cd80 00000000 00000000 8393cd98 838f04e2 7f13791c 00000000 000000=
00
1ee0: 82660580 00004288 00000000 838f04e2 82660580 8393cd98 82660580 838f04=
e2
1f00: 82660a8c 7f1906b0 7f190708 00000000 40000006 7f137d18 8368578c 8393cd=
98
1f20: 8393cd80 00000000 00000000 00000000 00000000 00000000 82660a8c 80f04e=
c8
1f40: 8393cd80 82660580 82660a7c 7f1347f8 00000000 80f04ec8 00000001 82660a=
64
1f60: 00000000 eefad338 00000000 00000006 80be7f14 801246f8 00000006 80f030=
98
1f80: 80f03080 81504c80 00000101 8010140c f0861e78 80915818 8225e100 f0801f=
90
1fa0: 80f03080 80e543c0 80c059f4 0000000a 80e56a40 80e56a40 80e54334 80c284=
f4
1fc0: 00005a10 80f03d40 80a01e20 04208040 80c059f4 80e56a40 20000013 ffffff=
ff
1fe0: f0861eb4 81504c80 81504c80 80f050b4 f0861e78 801245ac 80144024 804772=
fc
kfree_skb_list_reason from ieee80211_report_used_skb+0xd0/0x5b4 [mac80211]
ieee80211_report_used_skb [mac80211] from ieee80211_tx_status_ext+0x4c8/0x8=
50 [mac80211]
ieee80211_tx_status_ext [mac80211] from ieee80211_tx_status+0x74/0x9c [mac8=
0211]
ieee80211_tx_status [mac80211] from ieee80211_tasklet_handler+0xb0/0xd8 [ma=
c80211]
ieee80211_tasklet_handler [mac80211] from tasklet_action_common.constprop.0=
+0xb0/0xc4
tasklet_action_common.constprop.0 from __do_softirq+0x14c/0x2c0
__do_softirq from irq_exit+0x98/0xc8
irq_exit from call_with_stack+0x18/0x20
call_with_stack from __irq_svc+0x98/0xc8
Exception stack(0xf0861e80 to 0xf0861ec8)
1e80: 00000001 00000002 00000001 81504c80 eefafdc0 00000000 81590880 000000=
00
1ea0: 81504c80 81505248 80f050b4 f0861f14 f0861f18 f0861ed0 80915bec 801440=
24
1ec0: 20000013 ffffffff
__irq_svc from finish_task_switch+0xa8/0x270
finish_task_switch from __schedule+0x25c/0x628
__schedule from schedule+0x5c/0xb4
schedule from smpboot_thread_fn+0xbc/0x23c
smpboot_thread_fn from kthread+0xf4/0x124
kthread from ret_from_fork+0x14/0x2c
Exception stack(0xf0861fb0 to 0xf0861ff8)
1fa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00=
000000 00000000 00000000 00000000
1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: e92d4010 e2504000 08bd8010 e1a00004 (e5944000) =C2=A0
[=C2=A0 5]=C2=A0 24.00-25.00=C2=A0 sec=C2=A0=C2=A0 765 KBy---[ end trace 00=
00000000000000 ]---
tes=C2=A0 6.27 Mbits/sec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 Kernel panic - not syncing: Fatal exception in =
interrupt
CPU2: stopping
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.0.0-rc5-d=
nm3pv2+g047dc4cf9a10 #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
unwind_backtrace from show_stack+0x10/0x14
show_stack from dump_stack_lvl+0x40/0x4c
dump_stack_lvl from do_handle_IPI+0x100/0x128
do_handle_IPI from ipi_handler+0x18/0x20
ipi_handler from handle_percpu_devid_irq+0x8c/0x138
handle_percpu_devid_irq from generic_handle_domain_irq+0x24/0x34
generic_handle_domain_irq from gic_handle_irq+0x74/0x88
gic_handle_irq from generic_handle_arch_irq+0x58/0x78
generic_handle_arch_irq from call_with_stack+0x18/0x20
call_with_stack from __irq_svc+0x98/0xc8
Exception stack(0xf0871f10 to 0xf0871f58)
1f00:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00=
000002 80bf66e8 00000001 6e16f000
1f20: 00000000 80f0a668 00000000 00000000 a05c2adc a0629de7 eefc50c8 000000=
7b
1f40: fffffff5 f0871f60 80155d84 807006d8 60030013 ffffffff
__irq_svc from cpuidle_enter_state+0x158/0x358
cpuidle_enter_state from cpuidle_enter+0x40/0x50
cpuidle_enter from do_idle+0x19c/0x208
do_idle from cpu_startup_entry+0x18/0x1c
cpu_startup_entry from secondary_start_kernel+0x148/0x150
secondary_start_kernel from 0x10101620
CPU3: stopping
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.0.0-rc5-d=
nm3pv2+g047dc4cf9a10 #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
unwind_backtrace from show_stack+0x10/0x14
show_stack from dump_stack_lvl+0x40/0x4c
dump_stack_lvl from do_handle_IPI+0x100/0x128
do_handle_IPI from ipi_handler+0x18/0x20
ipi_handler from handle_percpu_devid_irq+0x8c/0x138
handle_percpu_devid_irq from generic_handle_domain_irq+0x24/0x34
generic_handle_domain_irq from gic_handle_irq+0x74/0x88
gic_handle_irq from generic_handle_arch_irq+0x58/0x78
generic_handle_arch_irq from call_with_stack+0x18/0x20
call_with_stack from __irq_svc+0x98/0xc8
Exception stack(0xf0875f10 to 0xf0875f58)
5f00:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00=
000003 80bf66e8 00000001 6e17a000
5f20: 00000000 80f0a668 00000000 00000000 a05c5ef1 a0629de7 eefd00c8 000000=
7b
5f40: fffffff5 f0875f60 80155d84 807006d8 60000013 ffffffff
__irq_svc from cpuidle_enter_state+0x158/0x358
cpuidle_enter_state from cpuidle_enter+0x40/0x50
cpuidle_enter from do_idle+0x19c/0x208
do_idle from cpu_startup_entry+0x18/0x1c
cpu_startup_entry from secondary_start_kernel+0x148/0x150
secondary_start_kernel from 0x10101620
CPU1: stopping
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.0.0-rc5-d=
nm3pv2+g047dc4cf9a10 #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
unwind_backtrace from show_stack+0x10/0x14
show_stack from dump_stack_lvl+0x40/0x4c
dump_stack_lvl from do_handle_IPI+0x100/0x128
do_handle_IPI from ipi_handler+0x18/0x20
ipi_handler from handle_percpu_devid_irq+0x8c/0x138
handle_percpu_devid_irq from generic_handle_domain_irq+0x24/0x34
generic_handle_domain_irq from gic_handle_irq+0x74/0x88
gic_handle_irq from generic_handle_arch_irq+0x58/0x78
generic_handle_arch_irq from call_with_stack+0x18/0x20
call_with_stack from __irq_svc+0x98/0xc8
Exception stack(0xf086df10 to 0xf086df58)
df00:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00=
000001 80bf66e8 00000001 6e164000
df20: 00000000 80f0a668 00000000 00000000 a05c2d77 a0629de7 eefba0c8 000000=
7b
df40: fffffff5 f086df60 80155d84 807006d8 600e0013 ffffffff
__irq_svc from cpuidle_enter_state+0x158/0x358
cpuidle_enter_state from cpuidle_enter+0x40/0x50
cpuidle_enter from do_idle+0x19c/0x208
do_idle from cpu_startup_entry+0x18/0x1c
cpu_startup_entry from secondary_start_kernel+0x148/0x150
secondary_start_kernel from 0x10101620

However, the corruption can manifest itself in different ways as well -
- sometimes even damaging contents of onboard NAND flash.
Similar traces have appeared previously in other places as well.
In addition to testing on 6.0-rc5, we tried cherry-picking 047dc4cf9a10b4f2=
dc164b8bf192de583f3ebfee
from wireless-next as well, but this seems unrelated to the issue on first =
glance,
and doesn't prevent crashes.

I post relevant bits of device tree we used to get the module to work below=
.
We're using in-band IRQ of the SDIO interface:

/ {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wfx_pwrseq: wfx_pwrseq {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 compatible =3D "mmc-pwrseq-simple";
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 pinctrl-names =3D "default";
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 pinctrl-0 =3D <&pinctrl_wfx_reset>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 reset-gpios =3D <&gpio7 8 GPIO_ACTIVE_LOW>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
=C2=A0};

&iomuxc {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 usdhc1 {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 pinctrl_usdhc1_3: usdhc1grp-3 {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fsl,p=
ins =3D <
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_CMD__SD1_CMD=C2=
=A0=C2=A0=C2=A0 0x17059
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_CLK__SD1_CLK=C2=
=A0=C2=A0=C2=A0 0x10059
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_DAT0__SD1_DATA0 0=
x17059
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_DAT1__SD1_DATA1 0=
x17059
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_DAT2__SD1_DATA2 0=
x17059
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD1_DAT3__SD1_DATA3 0=
x17059
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD3_CLK__GPIO7_IO03 0=
x17041
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD3_CMD__GPIO7_IO02 0=
x13019
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 >;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 };

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 pinctrl_wfx_reset: wfx-reset-grp {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fsl,p=
ins =3D <
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MX6QDL_PAD_SD3_RST__GPIO7_IO08 0=
x1B030
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 >;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 };
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
};

&usdhc1 {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 status =3D "okay";
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #address-cells =3D <1>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #size-cells =3D <0>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-names =3D "default=
";
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pinctrl-0 =3D <&pinctrl_us=
dhc1_3>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap-power-off-card;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 keep-power-in-suspend;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap-sdio-irq;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wakeup-source;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disable-wp;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cap-sd-highspeed;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bus-width =3D <4>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 non-removable;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 no-mmc;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 no-sd;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mmc-pwrseq =3D <&wfx_pwrse=
q>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wifi@1 {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 compatible =3D "silabs,brd8023a";
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 reg =3D <1>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 wakeup-gpios =3D <&gpio7 2 GPIO_ACTIVE_HIGH>;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
};

With that, the device probes successfully, and we can get 22Mbps of traffic=
 with a 1T1R peer
in HT20 mode in both directions.
SDIO singals were checked with the oscilloscope, and they look perfectly fi=
ne,
so I think we can rule out any hardware issue.

By adding a canary to slab allocator, we managed to find, that the skb stru=
ctures gets damaged,
and then improperly dereferenced by the driver somewhere in TX queue handli=
ng code.

With SMP disabled, the issue still manifests itself, hinting at synchroniza=
tion issue
between the interrupt context, and the tasklets handling the bulk of work.
However, it usually takes a longer time to reproduce - still in order of a =
few minutes.
In some cases the kernel would detect use-after-free by itself - without mo=
dification -
or the reference counts get corrupted.

This stacktrace comes from one of the runs with CONFIG_SMP disabled:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 10 at lib/refcount.c:28 ieee80211_tx_status_ext+0x4f8/=
0x968 [mac80211]
refcount_t: underflow; use-after-free.
Modules linked in: xt_LOG nf_log_syslog xt_limit iptable_mangle xt_connmark=
 xt_tcpudp xt_conntrack
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_table=
s cdc_mbim cdc_wdm cdc_ncm
cdc_ether usbnet cdc_acm usb_serial_simple usbserial usb_f_rndis u_ether wf=
x mac80211 libarc4 evbug
phy_generic cfg80211 adt7475 hwmon_vid ci_hdrc_imx ci_hdrc ulpi roles usbmi=
sc_imx pwm_imx27
pwm_beeper libcomposite configfs udc_core
CPU: 0 PID: 10 Comm: ksoftirqd/0 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.19.2+ge4fb=
6643395f #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
unwind_backtrace from show_stack+0x10/0x14
show_stack from dump_stack_lvl+0x24/0x2c
dump_stack_lvl from __warn+0xb0/0xd8
__warn from warn_slowpath_fmt+0x98/0xc8
warn_slowpath_fmt from ieee80211_tx_status_ext+0x4f8/0x968 [mac80211]
ieee80211_tx_status_ext [mac80211] from ieee80211_tx_status+0x74/0x9c [mac8=
0211]
ieee80211_tx_status [mac80211] from ieee80211_tasklet_handler+0xb0/0xd8 [ma=
c80211]
ieee80211_tasklet_handler [mac80211] from tasklet_action_common.constprop.0=
+0xb4/0xc0
tasklet_action_common.constprop.0 from __do_softirq+0x12c/0x290
__do_softirq from irq_exit+0x90/0xbc
irq_exit from call_with_stack+0x18/0x20
call_with_stack from __irq_svc+0x94/0xc4
Exception stack(0xf0859e98 to 0xf0859ee0)
9e80:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00000001 81080780
9ea0: 00000001 81080780 00000000 00000002 822f0780 808e82cc 81080780 81080c=
50
9ec0: 00000000 f0859f14 f0859f18 f0859ee8 801404f0 80140624 20000013 ffffff=
ff
__irq_svc from finish_task_switch+0x78/0x1f8
finish_task_switch from __schedule+0x244/0x580
__schedule from schedule+0x5c/0xb4
schedule from smpboot_thread_fn+0xb8/0x224
smpboot_thread_fn from kthread+0xe4/0x114
kthread from ret_from_fork+0x14/0x2c
Exception stack(0xf0859fb0 to 0xf0859ff8)
9fa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00=
000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1131 at lib/refcount.c:22 __tcp_transmit_skb+0x7a4/0xa=
8c
=C2=A0=C2=A0 =C2=A0
refcount_t: saturated; leaking memory.
Modules linked in: xt_LOG nf_log_syslog xt_limit iptable_mangle xt_connmark=
 xt_tcpudp xt_conntrack
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_table=
s cdc_mbim cdc_wdm cdc_ncm
cdc_ether usbnet cdc_acm usb_serial_simple usbserial usb_f_rndis u_ether wf=
x mac80211 libarc4 evbug
phy_generic cfg80211 adt7475 hwmon_vid ci_hdrc_imx ci_hdrc ulpi roles usbmi=
sc_imx pwm_imx27
pwm_beeper libcomposite configfs udc_core
CPU: 0 PID: 1131 Comm: kworker/0:2H Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.19.2+ge=
4fb6643395f #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Workqueue: wfx_bh_wq bh_work [wfx]
unwind_backtrace from show_stack+0x10/0x14
show_stack from dump_stack_lvl+0x24/0x2c
dump_stack_lvl from __warn+0xb0/0xd8
__warn from warn_slowpath_fmt+0x98/0xc8
warn_slowpath_fmt from __tcp_transmit_skb+0x7a4/0xa8c
__tcp_transmit_skb from __tcp_send_ack.part.0+0xd0/0x13c
__tcp_send_ack.part.0 from tcp_delack_timer_handler+0xb0/0x180
tcp_delack_timer_handler from tcp_delack_timer+0x2c/0x128
tcp_delack_timer from call_timer_fn.constprop.0+0x18/0x80
call_timer_fn.constprop.0 from run_timer_softirq+0x2ec/0x3b0
run_timer_softirq from __do_softirq+0x12c/0x290
__do_softirq from call_with_stack+0x18/0x20
call_with_stack from do_softirq+0x6c/0x70
do_softirq from __local_bh_enable_ip+0xd8/0xdc
__local_bh_enable_ip from __netdev_alloc_skb+0x14c/0x170
__netdev_alloc_skb from bh_work+0x1b0/0x650 [wfx]
bh_work [wfx] from process_one_work+0x1b8/0x3ec
process_one_work from worker_thread+0x4c/0x57c
worker_thread from kthread+0xe4/0x114
kthread from ret_from_fork+0x14/0x2c
Exception stack(0xf161dfb0 to 0xf161dff8)
dfa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00=
000000 00000000 00000000 00000000
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
---[ end trace 0000000000000000 ]---
[=C2=A0 5] 536.16-537.00 sec=C2=A0 26.9 KBytes=C2=A0=C2=A0 261 Kbits/sec=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0
[=C2=A0 5] 537.00-538.00 sec=C2=A0 2.71 MBytes=C2=A0 22.7 Mbits/sec=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =C2=A0
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 0000011=
c
[0000011c] *pgd=3D00000000
Internal error: Oops: 5 [#1] PREEMPT ARM
Modules linked in: xt_LOG nf_log_syslog xt_limit iptable_mangle xt_connmark=
 xt_tcpudp
xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_t=
ables x_tables
cdc_mbim cdc_wdm cdc_ncm cdc_ether usbnet cdc_acm usb_serial_simple usbseri=
al
usb_f_rndis u_ether wfx mac80211 libarc4 evbug phy_generic cfg80211 adt7475
hwmon_vid ci_hdrc_imx ci_hdrc ulpi roles usbmisc_imx pwm_imx27 pwm_beeper
libcomposite configfs udc_core
CPU: 0 PID: 10 Comm: ksoftirqd/0 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.19.2+ge4fb=
6643395f #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
PC is at ip6_rcv_core+0x110/0x68c
LR is at ip6_rcv_core+0xb0/0x68c
pc : [<8084d278>]=C2=A0=C2=A0=C2=A0 lr : [<8084d218>]=C2=A0=C2=A0=C2=A0 psr=
: 20000013
sp : f0859e18=C2=A0 ip : 00000000=C2=A0 fp : 80e13cc0
r10: 00000000=C2=A0 r9 : 80e13cf4=C2=A0 r8 : 81b65000
r7 : 80e6d7c8=C2=A0 r6 : 82024c00=C2=A0 r5 : 812a8760=C2=A0 r4 : 81be5b40
r3 : 00000000=C2=A0 r2 : 00000100=C2=A0 r1 : 000000d7=C2=A0 r0 : 00000000
Flags: nzCv=C2=A0 IRQs on=C2=A0 FIQs on=C2=A0 Mode SVC_32=C2=A0 ISA ARM=C2=
=A0 Segment none
Control: 10c53c7d=C2=A0 Table: 12338059=C2=A0 DAC: 00000051
Register r0 information: NULL pointer
Register r1 information: non-paged memory
Register r2 information: non-paged memory
Register r3 information: NULL pointer
Register r4 information: slab skbuff_head_cache start 81be5b40 pointer offs=
et 0 size 48
Register r5 information: non-slab/vmalloc memory
Register r6 information: slab kmalloc-1k start 82024c00 pointer offset 0 si=
ze 1024
Register r7 information: non-slab/vmalloc memory
Register r8 information: slab kmalloc-2k start 81b65000 pointer offset 0 si=
ze 2048
Register r9 information: non-slab/vmalloc memory
Register r10 information: NULL pointer
Register r11 information: non-slab/vmalloc memory
Register r12 information: NULL pointer
Process ksoftirqd/0 (pid: 10, stack limit =3D 0x7cac7060)
Stack: (0xf0859e18 to 0xf085a000)
9e00:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 81b65000 80e13d00
9e20: 80e6d7c8 80e13cc8 00000040 80e13cf4 00000000 8084da90 80d0ce80 80d042=
4c
9e40: 80d0ce80 81b65000 80e13d00 00000001 80e13cc8 80d0424c 8084da60 80e13d=
00
9e60: 00000001 807691c0 00000001 81be5b40 80d06654 80d0424c 81be5b40 807693=
48
9e80: 00000001 80e13d00 00000040 f0859ecb 80dd6000 00008b6a f0859ed4 80769e=
c4
9ea0: 00000001 81080780 00000000 80e13d00 0000012c 00000000 f0859ecc 8076a2=
d8
9ec0: 00008b6c 81080780 00859f18 f0859ecc f0859ecc f0859ed4 f0859ed4 80d042=
4c
9ee0: 00000051 00000000 00000003 80e15834 80e15828 81080780 00000100 80adb4=
e4
9f00: 40000003 801013f4 821d9540 00000000 f0859f5c 80e15828 80d0d390 80e13c=
80
9f20: 80af6e3c 0000000a 80d0b588 80b19518 00008b6b 80dd6000 04208040 80901d=
d0
9f40: 81080780 00000000 8102de00 81080780 80d0b558 00000001 00000001 000000=
00
9f60: 00000000 80120a18 00000000 8013e590 8102de40 8102df00 8013e42c 8102de=
00
9f80: 81080780 f0835e30 00000000 8013a85c 8102de40 8013a778 00000000 000000=
00
9fa0: 00000000 00000000 00000000 80100148 00000000 00000000 00000000 000000=
00
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 000000=
00
ip6_rcv_core from ipv6_rcv+0x30/0xd4
ipv6_rcv from __netif_receive_skb_one_core+0x5c/0x80
__netif_receive_skb_one_core from process_backlog+0x70/0xe4
process_backlog from __napi_poll+0x2c/0x1f0
__napi_poll from net_rx_action+0x140/0x264
net_rx_action from __do_softirq+0x12c/0x290
__do_softirq from run_ksoftirqd+0x34/0x3c
run_ksoftirqd from smpboot_thread_fn+0x164/0x224
smpboot_thread_fn from kthread+0xe4/0x114
kthread from ret_from_fork+0x14/0x2c
Exception stack(0xf0859fb0 to 0xf0859ff8)
9fa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00=
000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000000=
00
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: e5843024 e5843028 e584302c 0a000055 (e1d231bc) =C2=A0
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Fatal exception in interrupt

Now, the questions:
- Is "silabs,brd8023a" the proper compatible string for WFM200S022XNN3, or =
should we create our
=C2=A0 own for the bare module, even if just the in-band SDIO IRQ, and an e=
xternal antenna is in use?
- In order to try out the out-of-band IRQ - in hope that it resolves the is=
sue somehow - do we need to create custom PDS file?
=C2=A0 With the IRQ enabled, probe fails with "Chip did not answer" error.
- Tracing memory corruptions is hard - is there a mechanism that could help=
 us out better than generic methods like kprobes,
=C2=A0 or implementing canaries? As skb's are heavily re-used for performan=
ce reasons, tracing their lifecycle is especially hard.
=C2=A0 Our first idea was to lock their respective pages from writing, once=
 they are enqueued in the wfx TX queue,
=C2=A0 so MMU detects the corruption at the exact time it happens, but we h=
aven't figure out how to modify skb allocator to accomplish that,
=C2=A0 especially given that the issue mostly happens when transmitting, so=
 skbs are allocated outside of the driver.
=C2=A0 Maybe there exists a similar mechanism - that could help us out - ev=
en if just in the works?

Any help will be greatly appreciated - we'll be very happy to provide a pat=
ch if we manage to figure the issue out.


W dniu 12.09.2022 o=C2=A018:15, J=C3=A9r=C3=B4me Pouiller pisze:
> On Monday 12 September 2022 17:16:24 CEST Lech Perczak wrote:
>> Hello,
>>
>> We're trying to get a WFM200S022XNN3 module working on a custom i.MX6Q b=
oard using SDIO interface, using upstream kernel. Our patches concern prima=
rily the device tree for the board - and upstream firmware from linux-firmw=
are repository.
>>
>> During that, we stumbled upon a memory corruption issue, which appears w=
hen big traffic is passing through the device. Our adapter is running in AP=
 mode. This can be reproduced with 100% rate using iperf3, by starting an A=
P interface on the device, and an iperf3 server. Then, the client station r=
uns iperf3 with "iperf3 -c <hostname> -t 3600" command - so the AP is sendi=
ng data for up to one hour, however - the kernel on our device crashes afte=
r around a few minutes of traffic, sometimes less than a minute.
>>
>> The behaviour is the same on kernel v5.19.7, v5.19.2, and even with v6.0=
-rc5. Tests on v6.0-rc5 have shown most detailed stacktrace so far:
>>
> Hello Lech,
>
> It seems that something somewhere (Ms Exchange, I am looking at you) has
> removed all the newlines of your mail :-/. Can you try to fix the problem=
?
> I think that sending mails using base64 encoding would solve the issue.
>
>
> [...]
>
> --
> J=C3=A9r=C3=B4me Pouiller

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

