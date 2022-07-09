Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0470856C77D
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 08:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGIGOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 02:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIGOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 02:14:19 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05olkn2042.outbound.protection.outlook.com [40.92.91.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73216165B8
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 23:14:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=II1V9jxL8U2drjSqmVhdVmnz+S9WIssQqKfhPw7ZcFjeDZFUq6E7N4mM/NPg8hzLzJiaBITH/SgdzJ8xLiBPP4rBDC1JHeilM2GRMLsnLduB7rAcvU3BS7DABo4sMZpSM29NsN6OwvWeDiXBdKUuf3Tm29RIlf4SfrW18QYdGW8ifoA3tEo8LtzvJRHbaEUu1mGuD10pryY3UmuQwWOAm2UCaGNvaElqtzxolwWpG7DjqXojSc0h42OitWTBuf79AZj7/lTUsivziJsNJojhkM73VCUytzJ0E6fcvkhhB5pdESvS22yeo6V71OTqqTvI0CSZmaswPDAgSpP6P3/LrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLUj3OqGejrqUExp/rTcjaGiXe8/NL+9y1z2tW/AYDA=;
 b=LE8YfTglMay2o9yvyG/TbjGr/FE2VQjufDyvrSLsB+TEdh3Qy/3tn8ATpdQxcMIv5U6o+Gt+SYaBwCa33OWqk57dl+r9q06oexytGrrS8VxbtEJhGoJqv3ZJo/R2ENlGfC8onFCcmh5kF869nRju5E4p7r99LM9JZD2nh2dtJi3FpHBT0FgOk3Gtm0aDIZPusJdK+ZtflmBZOicwUf29UpavX05mSbTbQ4tLfWNOaOhFbvn7Nx6lP/YTAnKvuO70G8HGXhz+8hei6A+yojJWYfpjU37rcnoyf4Z9DlPRt1hVO/1QWmPk2R6kvujXfciiYS1fHmCDpgmZP7qTolhZbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLUj3OqGejrqUExp/rTcjaGiXe8/NL+9y1z2tW/AYDA=;
 b=tLDIoC5MCs0HFE3sBSURp/S1vezPoQ8uGO3gw/cwOwOYt1w3P28IuhTUrgK+BkORC15fmHUcDbyXNnavL1OZNVUXJoqKw8mIrfABdEV1uFami8AN3hbVhMmGc45Q7lYJc14I/wYuWes8w8CnE/zT7uLmJFEODk/ikYbsrli1H865+NadN3pxzaebGZ5llkhFVboy/LEm/okuWoUTQ0QQYIDeNxPXheljfBCWKrPbhCA8nCPxcR/z38fd0vayLr1K33KZouhjvMW4UiZqtRNk2/2dn7uLiQIwU6loV2+wtpchif/a1FBEAPqv8a5AE/Xn0xSQI30uIaQ1w0Nq+q/cEg==
Received: from HE1P193MB0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:3:101::11) by
 PAXP193MB1344.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:132::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.15; Sat, 9 Jul 2022 06:14:15 +0000
Received: from HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
 ([fe80::566:bfa:a746:b3c2]) by HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
 ([fe80::566:bfa:a746:b3c2%8]) with mapi id 15.20.5417.023; Sat, 9 Jul 2022
 06:14:14 +0000
From:   Michelle Bies <mimbies@outlook.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: TPROXY + Attempt to release TCP socket in state 1
Thread-Topic: TPROXY + Attempt to release TCP socket in state 1
Thread-Index: AQHYkErevbS8bXbfdEm0spXJu4GhIq11kwpR
Date:   Sat, 9 Jul 2022 06:14:14 +0000
Message-ID: <HE1P193MB01233D583E9A7B1418A77713A8859@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
References: <HE1P193MB01236F580D05214179C7AAC0A8819@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
In-Reply-To: <HE1P193MB01236F580D05214179C7AAC0A8819@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: fd3d0298-8bbd-b080-2b5e-74d4163df9e3
x-tmn:  [wtFPOdQD+koeO61s620CF8BIN1jnQZ0d4n1v3xf2ECc=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f71b6ccf-20c5-42a2-6501-08da61723f8a
x-ms-traffictypediagnostic: PAXP193MB1344:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nUdDEohmUEH/I1KLYOgI8WnLVM/j8Qdh9lAu6Arj2sOBu+PK/86y4GQd4mCToOI1t4nMr0MHaaiKHoFp9ctlq9P6ySE4+/WN/Zm24PjUFwVJnLlfzbHsfPv5Wh3nDSXq/yZ9cDhgbaONBsa4+JALJwYdAKBaOLQH/nbS6XGRFZid8PUY9HvO5htPh0mkP0mLJ46583DanwL6UcS5fxUX4Y2Snuhtdvay5z/pi83aoJsHgifX53jubNIqFgIJZ1b/KUkXtuLmBPgjf8na/lWphj8WP2fg9w1jk0SWu8wnMmRYNmAcSoMmC24BIuSeoDUaJPziP6CYm5OGZWlYx+vIwqWIgOxW60rp2ZHZxLkUj2FU83slRvRdXkXzbva6pFopJ1xWcvkPn8DWbGqLw/CaHN6WnGbJrRjoXGzYZhC/A5vg5YEL8jt1EeaTrsKXf2eb0rmA+CyNMPxJiZa4C1wLH/4NvG2GL+xQO1+yjH3IQfEM59zgf8TfyjsYFX8YEe/vfQzT+/XlidHjk/1diFxFOV6w97iGtwSBbvuJ7JNWqI0JFdrrN4f1AQVnkM9EPoT7s8XjLfCajyhyM1l/Y78OCzM4DXe6zvNhQ0WXeHVOstQjvywk3BSKO7gIQ+7RDQh1e2p6q/0B75ttDobcSv65yaRfGzAsCPYORxg3EQvSOtvINWC55IC2dFc0dWhIRjRtAqmfp5il39s/tXWlM66MGl3uAYeakGoXhKDep6EzoYo=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?vGnDWkB9C3bimLqQ/nCX8OJKR3i3GaV3zWXyRj8e6E73jAvraSAT52lFCM?=
 =?iso-8859-1?Q?e9fwhjvSJ9BqqOmYPFkd5AiSFBga1CYpKm59K7u4a3VhvjcpbaohF8LNyT?=
 =?iso-8859-1?Q?XynkImQncweIHv2Dohar+uanzLGkQglCkOiXj3hCHHOvgsq5mlU2zTKD0n?=
 =?iso-8859-1?Q?syjJPYsyII/Uo6OI12KxwgwO9lih5rMicnkomwfDuD4/b5DUGYq3xNjusA?=
 =?iso-8859-1?Q?Q+p76ClJUo0Mua7ny/AviWzUnunxQgXE517gxkzhISTzLD3DobyCdPhLsL?=
 =?iso-8859-1?Q?vGoFuwEKpuYN3SWns74SzYNMNu561w4b3ArC4SRI/FlxgdUd7+10GG6k0/?=
 =?iso-8859-1?Q?RtPb5dhabQQ7f7Ufrxo1hY/eCUTGb9kVCeBl1brkHqpOkB86L3jmS7RhPe?=
 =?iso-8859-1?Q?DTv3HFAqIR5u/3nhUt18Ep2Ua8mSfw3RNj/kqhBhOvrEgZIBAkwSAVo6UM?=
 =?iso-8859-1?Q?2P/V+IW4YtscP6cFTmSwpyjw/YaORg0IcwS5mkrNLA2pBkTQJUuSCbsBzd?=
 =?iso-8859-1?Q?CVlRDWdlTpHLisfYEGCpIFlKkQmj4x7mc1f0TQgONhXUE8c8GuHHxRoM3K?=
 =?iso-8859-1?Q?JzjDi1u3j5GCR1lBy8kUYAZ3xmRSuVkK3Kwu4vZ3J78nTIovJaQOQUaeDx?=
 =?iso-8859-1?Q?BfMhct10Jz8gqdtb0xjNtCURJKMsf1YQs8DC8zesPEcB3nidvFi2lWIfXQ?=
 =?iso-8859-1?Q?Tm2oeT5CeADaMO6Nx/irBeH/z/SZ+wAwEhRP++98nmLYYh8AFYwa2Ok0hh?=
 =?iso-8859-1?Q?+KyDi4W0pwWxTWURa/KFRKrLCyR39c4TGZEF6y4mmZAv/V9zeEq64PUJS7?=
 =?iso-8859-1?Q?3K+3kBO21mW8X0o2WSRZfPR5DcCzpIThA9jaVpynf9eITh9XrZDUeBlS21?=
 =?iso-8859-1?Q?EurBlLSmwbEN7K+w0PhkJmvHJz7PNzZHxRvhZECFU9U8VmmHXsc9kcREoc?=
 =?iso-8859-1?Q?zwNyM6jYqX2sO0F5p+zpYeiUcYYZQYU8oYidQmCSjq6utrEwjcuovp4RT1?=
 =?iso-8859-1?Q?cewFWhJhwRJbCQYNQKZTMMCKM2T76wlDkaWGEXINCH2wXT47/Dy947mfcv?=
 =?iso-8859-1?Q?8JXPDD+8uojbQCfB5PIUl/Onh+eG8gNg5o1Z+Jg41hqupASiiAX9lZivpm?=
 =?iso-8859-1?Q?nWST1rQRrF84APWPUlhb90ET0XAeePkQqWvAQrPq6zrauPBfJTtbl0VcKA?=
 =?iso-8859-1?Q?pdrOvBLR0R8/2mnpNmsjW8FNtfgUZmKCyHl+Ztu9gWPRRQo8XMoQyItd3/?=
 =?iso-8859-1?Q?HTLSmuFbEcsxf0L9dyH96RZD2zBIcoxmzP4U6Q4/Y12wL86Fv7e3yil3y7?=
 =?iso-8859-1?Q?Kho+?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: f71b6ccf-20c5-42a2-6501-08da61723f8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 06:14:14.6078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP193MB1344
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric=0A=
unfortunately, nobody response to my problem :(=0A=
Did I report my problem to the right mailing list? =0A=
=0A=
=0A=
On 05 July 2022 09:52, Michelle Bies wrote:=0A=
> Hi=0A=
>=0A=
> I'm trying to run squid with TPROXY enabled but the system reboots after =
logging these messages:=0A=
> =0A=
>   IPv4: Attempt to release TCP socket in state 1 00000000dfe7f997=0A=
> =0A=
> and after some seconds:=0A=
> =0A=
>   rcu: INFO: rcu_sched detected stalls on CPUs/tasks:=0A=
>   rcu:5-....: (6 GPs behind) idle=3Df9e/0/0x1 softirq=3D184030/184030 fqs=
=3D1901=0A=
>   (detected by 1, t=3D6302 jiffies, g=3D894549, q=3D17504)=0A=
>   Sending NMI from CPU 1 to CPUs 5:=0A=
>   NMI backtrace for cpu 5=0A=
>   CPU: 5 PID: 0 Comm: swapper/5 Tainted: GO 5.4.181+ #9=0A=
>   Hardware name: Dell Inc. PowerEdge R630/02C2CP, BIOS 2.12.1 12/04/2020=
=0A=
>   RIP: 0010:__inet_lookup_established+0x4c/0xf7=0A=
>   Code: 48 89 f5 53 48 c1 e5 20 44 89 cb 48 09 c5 44 09 c3 e8 7b fe ff ff=
 41 89 c6 41 89 c5 49 8b 07 45 23 77 10 4e 8d 3c f0 49 8b 17 <f6> c2 01 0f =
85 89 00 00 00 44 39 6a a0 75 7b 39 5a a4 75 76 48 39=0A=
>   RSP: 0018:ffffc90000208c48 EFLAGS: 00000a12=0A=
>   RAX: ffff88844ad00000 RBX: 0000000001bb18e1 RCX: 00000000baf65c60=0A=
>   RDX: 000000000002b145 RSI: 00000000e5cc7389 RDI: 000000009da543b1=0A=
>   RBP: 490e1a683c63a8c0 R08: 00000000000018e1 R09: 0000000001bb0000=0A=
>   R10: ffff8883c96da400 R11: 00000000000018e1 R12: ffffffff822b3740=0A=
>   R13: 00000000593d39c6 R14: 00000000000139c6 R15: ffff88844ad9ce30=0A=
>   FS:0000000000000000(0000) GS:ffff88844d940000(0000) knlGS:0000000000000=
000=0A=
>   CS:0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
>   CR2: 00007fd0297e8eb0 CR3: 00000003d37d4005 CR4: 00000000003606e0=0A=
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000=0A=
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400=0A=
>   Call Trace:=0A=
>  <IRQ>=0A=
>  nf_sk_lookup_slow_v4+0x224/0xfbe [nf_socket_ipv4]=0A=
>  ? do_raw_spin_lock+0x2b/0x52=0A=
>  socket_match.isra.0+0x2f/0xf9 [xt_socket]=0A=
>  ipt_do_table+0x26f/0x5c1 [ip_tables]=0A=
>  ? nf_ct_key_equal+0x38/0x5d [nf_conntrack]=0A=
>  ? nf_conntrack_in+0x2bd/0x46b [nf_conntrack]=0A=
>  nf_hook_slow+0x3c/0xb4=0A=
>  nf_hook.constprop.0+0xa5/0xc8=0A=
>  ? l3mdev_l3_rcv.constprop.0+0x50/0x50=0A=
>  ip_rcv+0x41/0x61=0A=
>  __netif_receive_skb_one_core+0x74/0x95=0A=
>  process_backlog+0x97/0x122=0A=
>  net_rx_action+0xf5/0x2a3=0A=
>  __do_softirq+0xc2/0x1c6=0A=
>  irq_exit+0x41/0x80=0A=
>  call_function_single_interrupt+0xf/0x20=0A=
>  </IRQ>=0A=
>   RIP: 0010:mwait_idle+0x5f/0x75=0A=
>   Code: f0 31 d2 48 89 d1 65 48 8b 04 25 40 ac 01 00 0f 01 c8 48 8b 08 48=
 c1 e9 03 83 e1 01 75 0e e8 2b c3 6c ff 48 89 c8 fb 0f 01 c9 <eb> 01 fb bf =
15 00 00 00     65 48 8b 34 25 40 ac 01 00 e9 26 c3 6c ff=0A=
>   RSP: 0018:ffffc900000f3ee0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff04=
=0A=
>   RAX: 0000000000000000 RBX: ffff88844beee3c0 RCX: 0000000000000000=0A=
>   RDX: 0000000000000000 RSI: ffff88844beee3c0 RDI: 0000000000000015=0A=
>   RBP: 0000000000000000 R08: 0000000000840188 R09: 0000000000000000=0A=
>   R10: ffff88844d964b80 R11: ffff88844d964bc0 R12: 0000000000000000=0A=
>   R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000=0A=
>  do_idle+0xcf/0x1da=0A=
>  ? do_idle+0x2/0x1da=0A=
>  cpu_startup_entry+0x1a/0x1c=0A=
>  start_secondary+0x14b/0x169=0A=
>  secondary_startup_64+0xa4/0xb0=0A=
>   ------------[ cut here ]------------=0A=
>   NETDEV WATCHDOG: eth2 (igb): transmit queue 4 timed out=0A=
>   WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:480 dev_watchdog+0xcf=
/0x128=0A=
>   Modules linked in: xt_CLASSIFY xt_nfacct sch_sfq xt_IMQ xt_NFLOG xt_lim=
it xt_pkttype xt_nat xt_MASQUERADE xt_REDIRECT xt_connlimit nf_conncount xt=
_time xt_geoip(O) xt_iprange xt_NFQUEUE xt_TPROXY nf_tproxy_ipv6 nf_tproxy_=
ipv4 xt_mac xt_mark 8021q garp mrp xt_multiport xt_socket nf_socket_ipv4 nf=
_socket_ipv6 ebtable_filter ebtable_nat ebtables xt_state xt_conntrack ipta=
ble_filter iptable_nat xt_set xt_connlabel xt_connmark iptable_mangle xt_re=
cent iptable_raw sch_htb ip_set_hash_ipportip ip_set_hash_ip nfnetlink_acct=
 nf_nat_pptp nf_conntrack_pptp nf_nat_irc nf_conntrack_irc nf_nat_tftp nf_c=
onntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat_h323 nf_conntrack_h323 nf_=
nat_sip nf_conntrack_sip nf_nat nfnetlink_log ip_set nfnetlink_queue nf_con=
ntrack_netlink tun nfnetlink intel_lpss_pci intel_lpss imq igb sch_fq_codel=
 nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bonding llc e1000e e1000 ip_tab=
les=0A=
>   CPU: 1 PID: 0 Comm: swapper/1 Tainted: G O5.4.181+ #9=0A=
>   Hardware name: Dell Inc. PowerEdge R630/02C2CP, BIOS 2.12.1 12/04/2020=
=0A=
>   RIP: 0010:dev_watchdog+0xcf/0x128=0A=
>   Code: 4b a1 00 00 75 38 48 89 ef c6 05 39 4b a1 00 01 e8 2e 7b fd ff 44=
 89 e1 48 89 ee 48 c7 c7 fb e6 0d 82 48 89 c2 e8 a0 98 0d 00 <0f> 0b eb 10 =
41 ff c4 48 05 40 01 00 00 41 39 f4 75 9d eb 13 48 8b=0A=
>   RSP: 0018:ffffc90000158ec0 EFLAGS: 00010282=0A=
>   RAX: 0000000000000000 RBX: ffff88844b234440 RCX: 0000000000000007=0A=
>   RDX: 00000000000003f2 RSI: ffffc90000158db4 RDI: ffff88844d85b5b0=0A=
>   RBP: ffff88844b234000 R08: 0000000000000001 R09: 0000000000014600=0A=
>   R10: 0000000000000000 R11: 000000000000005c R12: 0000000000000004=0A=
>   R13: ffffc90000158ef8 R14: ffffffff822050c0 R15: 0000000000000002=0A=
>   FS:0000000000000000(0000) GS:ffff88844d840000(0000) knlGS:0000000000000=
000=0A=
>   CS:0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
>   CR2: 00007faad50f2000 CR3: 0000000437d0e005 CR4: 00000000003606e0=0A=
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000=0A=
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400=0A=
>   Call Trace:=0A=
>  <IRQ>=0A=
>  call_timer_fn.isra.0+0x18/0x6f=0A=
>  ? netif_tx_lock+0x7a/0x7a=0A=
>  __run_timers.part.0+0x12d/0x163=0A=
>  ? hrtimer_forward+0x73/0x7b=0A=
>  ? tick_sched_timer+0x57/0x62=0A=
>  ? timerqueue_add+0x62/0x68=0A=
>  run_timer_softirq+0x21/0x43=0A=
>  __do_softirq+0xc2/0x1c6=0A=
>  irq_exit+0x41/0x80=0A=
>  smp_apic_timer_interrupt+0x6f/0x7a=0A=
>  apic_timer_interrupt+0xf/0x20=0A=
>  </IRQ>=0A=
>   RIP: 0010:mwait_idle+0x5f/0x75=0A=
>   Code: f0 31 d2 48 89 d1 65 48 8b 04 25 40 ac 01 00 0f 01 c8 48 8b 08 48=
 c1 e9 03 83 e1 01 75 0e e8 2b c3 6c ff 48 89 c8 fb 0f 01 c9 <eb> 01 fb bf =
15 00 00 00 65 48 8b 34 25 40 ac 01 00 e9 26 c3 6c ff=0A=
>   RSP: 0018:ffffc900000d3ee0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13=
=0A=
>   RAX: 0000000000000000 RBX: ffff88844beeaac0 RCX: 0000000000000000=0A=
>   RDX: 0000000000000000 RSI: ffff88844beeaac0 RDI: 0000000000000015=0A=
>   RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000=0A=
>   R10: ffff88844d864b80 R11: ffff88844d864bc0 R12: 0000000000000000=0A=
>   R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000=0A=
>  do_idle+0xcf/0x1da=0A=
>  cpu_startup_entry+0x1a/0x1c=0A=
>  start_secondary+0x14b/0x169=0A=
>  secondary_startup_64+0xa4/0xb0=0A=
>   ---[ end trace 9e50b2e05e0ee06d ]---=0A=
> =0A=
> My current kernel is 5.4 and these are my iptables config:=0A=
> =0A=
>  iptables -t mangle -A PREROUTING -p tcp -m multiport --sport 80 -m socke=
t -m conntrack --ctdir REPLY -j DIVERT=0A=
>  iptables -t mangle -A DIVERT -j MARK --set-mark 1=0A=
>  iptables -t mangle -A DIVERT -j ACCEPT=0A=
>  iptables -t mangle -A PREROUTING -p tcp -m multiport --dports 80 -j TPRO=
XY --tproxy-mark 1 --on-port 3129=0A=
> =0A=
