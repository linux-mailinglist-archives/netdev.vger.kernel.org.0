Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C0D566575
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 10:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGEIw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 04:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiGEIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 04:52:27 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03olkn2019.outbound.protection.outlook.com [40.92.58.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B7DDF3F
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 01:52:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EECbl1Kdt+7bsCeFROoIfTdjAKFVTqi6kRcfxA5v9DJ0H4uWX7JiASxKkItc8GjYBnROxRozAmVZJg6LCOG89eSJX98kji8g3RqAck9EnNnchnlOOljSzlXTktWKbeLSL6/8fgLByQnAROgI9so59zahwl4NT3UXJuJIhMdbqJetcFCASiz2x0MnVEDov8rhx7XyMRz+f106T4mz1dP278pw31VXinWIRqEChWvYYViARQZxtCIEuMAv6rpPM3Xuieu6ZEYea63wHaXboJeuQE9PevgSXsh09rsyfZEyQTspjZbZMLml70rQhCvWlADAzGwQh5C1zRoUhVx7wzpC8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+mSBB6D66KKv3L3soLOezYxJaP0r89reWe9UJQI2tw=;
 b=LGfdgof2l0I3rnZ7t6O3MnxDe3hoimHD8Fr5nA4gw8oT5DcHYfJ0JhjTURB4W+ZzXqB9CbfoJlKKwRHb2GXvhWXu0C43EU9ZkiSpwf3u4fRfLrX4ohrFAbdGTkcFS1gjgrAPBNQfXHjQoHkp53UdIiA4DrL06E+YyCSEGU1z1299GcVwV9RfEFLKWmnRy62OfWHG+KfoKM5mvL6A0ezpTvGwKkxnol0aT6G6boN2+xbkIgW+So7551/OMlD2OkMxfgKgd80Gj3k2yNh2XDzig8Q8255de3M3vAaaJ+TB2WEzpGgAICZ+MVJRDZnL3pc/8X80inqjOs1R5XIE0jfW/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+mSBB6D66KKv3L3soLOezYxJaP0r89reWe9UJQI2tw=;
 b=pSPz0cuw94+UrvyhI9dCKbV1+Xo+QRluiPhBHPN42TBOJ+utUWX0GiZmOM0V0kKx1WZQbdsWfuyL/hCXusGZukl0VfXJpI/GdYeWiKyncHeGVfPkTqrhWY+eSuzOjjSG4S6vOT/m5y0kTnz972V58W8z1NiwKYXHg48iZ9FawpBgahcyp/nCTeYG/Z6cl5vc+DzCdylsboF+HF462lMzm8t4kCtBnW9vzq0RaJVlyAiW1JEeDCO8+9xT90vAgtrlbFx8GTs0A49lSB/8oOlgt85qjRaCLpqlc2Hq7/2RMKt6i884EVCicWP5UuuXbT4pwq2+9nCJQUANR6nog0fl+A==
Received: from HE1P193MB0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:3:101::11) by
 AS8P193MB1621.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:399::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.15; Tue, 5 Jul 2022 08:52:23 +0000
Received: from HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
 ([fe80::566:bfa:a746:b3c2]) by HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
 ([fe80::566:bfa:a746:b3c2%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 08:52:23 +0000
From:   Michelle Bies <mimbies@outlook.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: TPROXY + Attempt to release TCP socket in state 1
Thread-Topic: TPROXY + Attempt to release TCP socket in state 1
Thread-Index: AQHYkErevbS8bXbfdEm0spXJu4GhIg==
Date:   Tue, 5 Jul 2022 08:52:23 +0000
Message-ID: <HE1P193MB01236F580D05214179C7AAC0A8819@HE1P193MB0123.EURP193.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 588be29d-4716-4fad-247a-9e7d0c556a62
x-tmn:  [4KESTCPFxcPz/Vv6V9FZ7f+0UvekYt82BIJx5RoFQ4o=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e20bb41-52fe-44b0-ffdd-08da5e63ade2
x-ms-traffictypediagnostic: AS8P193MB1621:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wM64JDQt3NJl1DubFhzyi7Kxe6HW5yomjnX6bHbQqpzWPkitbklTAR/9anjLiHLjJMxNFmuAbemKUM+/e0DLD9GML3S3vVEQ1t8KAOOXv4AKiofzbM8PoVTapAmsfCMRxZyuJrKZ0IefonwlHnby+mXOLe5cjOa/q8O5mFzPfD88wSw3MwAxuSqRBegzdmvZ+4XcoCp5+3TspcivUWEHpLMF6DfJxCK7lylSn/MrSr8yMy5ElA2dtjvTFSmm48aRFOG9yy2h6aAJiv8crnXGjmlDvWaklBq2uO3U7/uT03jDzM/TVHZJ5qZtowMk9a6oX7I86K2NermNK7VWKZgKpuSSQKBshbc2986aN+labkVHzQhNHzjM1hCW2Ks2udWaQdmYzAMsjIrEHHtg6EyeVMvZsw7/MZFr5rKjlL1ABQvebpLM/gq/DLsbIBG0/6LadtkEEAgVk0aDDvyVtCuix9T19RmMC8fjhsD7+8oHKSSspL5sKetwJK+YE4fsWxALg+IyDNfI7J6wUH1oQm+GaJzw33E5u5RDSnv/JGTm2iJ8sGAQEeB23FdfdGz6M4cOZQJ8n/VGrxEXmOYV3nxsFTEieyUI9d9DP0iRYMb5MTLo3vdAGE0X5wYcROX+SKSUf8Lz87V4xTi+Mj4VrHI0CA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?U4aSGs5T4L/ah2kjUBSfgqtmIgigJzAZ4DgDpw++PRDr7Xffhfzjxkqc0J?=
 =?iso-8859-1?Q?Dm66tS8dc40JXzE1Gc4+DtnjswzNqqgWf6c0Pf8ranbqiOZSHJjq/POgL9?=
 =?iso-8859-1?Q?+w4qfe7s9rkoOIPiP3kQq7Nj3Pp3A2/ncbGYgVaBTc4fWgwci7z7TQnueY?=
 =?iso-8859-1?Q?3aRcGyZufyV18rfDE7qeRiyYFkLnX4LJsZVebyR2XU8q6bWqW+gBxSlbye?=
 =?iso-8859-1?Q?LT/a81FY0NJPZTGtt25d365zpPpVJ0+mCYKK4JIXq+nwFDbno2d+d10/y9?=
 =?iso-8859-1?Q?RFAbPbA1Vx2RtAbJNa3q1viDdDwANmhQT6SQp7zeAHWI21vyQhtHi6c9MC?=
 =?iso-8859-1?Q?aq5F3qPOhLAhiZxPMWyl7Fo4lSxbaKmJwlwnL9j6YczP3K46itlehja/+v?=
 =?iso-8859-1?Q?Tpvrvd/EAUyIRu9TsbBbSHlxuzodRk1iM67AROO99nkS7xidHEvbLDYqtg?=
 =?iso-8859-1?Q?hr3ai5Lq7VC0DBpQYm8zRi8PbSika7fGVoi0UdV5zmZA7V3HhbxU/Ir3cB?=
 =?iso-8859-1?Q?PGbRcQUxx0HJMo3KHjD/QqlNJGSA6trW8XaXQnM/0Flw7qUesqn/H/nCF/?=
 =?iso-8859-1?Q?xNcOKROHQZ7ipVGxBRLL1/vaKFE0DArqiJOTNKI3Q/rCA9FUFrslBuaY6I?=
 =?iso-8859-1?Q?TgVVQe7g9yowD2RSnH0vC/zb6wK9q7ZKXUpbnGibxBaB+iou58abvFVevD?=
 =?iso-8859-1?Q?s/Om4ZPaKGyqR+7mL651mSjip8hcGKFwYXJeaJHXVk21qGMbwQmGEcArqg?=
 =?iso-8859-1?Q?HwE7cbZzV4L3xuLMajQdmVyqTjPBJbEe4+WGc2TtiwaJu1fpjY5Upwb+tO?=
 =?iso-8859-1?Q?Fpf195Kw/rn9wyRHogaq3/RM+icxa3X593DXF2j413QbKGXejGyTUKujkE?=
 =?iso-8859-1?Q?nVopQ4Rm5g7QvjDO2JDeAiMgIUECa28xbmf2uyH8KVliYB+5VAtaB2IJXi?=
 =?iso-8859-1?Q?vesSExZBICcGWFn3aX8cqAn9IPI++zqr10cBO7TY7UY6O5lFNjuQj6uev6?=
 =?iso-8859-1?Q?/9VWfb78MA4/AaH7s4feJ9popurQ+IsIwhwPOClJ6y7UkoO4JuDphUZgfD?=
 =?iso-8859-1?Q?4PoATB324T1VWam2lV+gUh62R7CT9w2Daqjik3G/k4eVnT8xga167a72fY?=
 =?iso-8859-1?Q?UqBW/cx0/6uC0FecLxFSEXVjNdaAX+v/fTLErJfjjJwAvjJFo1177qmIWV?=
 =?iso-8859-1?Q?6OOJbZxh3p1MTXr5WVl2gTDgOWHLNTgT2eyKR7h7P01SUWYkptGpo4awuZ?=
 =?iso-8859-1?Q?/90qC/cJYAl9DE6HmNbAtxGgeAL6zsg3p4WYVJ7/aaEpMh3WF4joMF116a?=
 =?iso-8859-1?Q?ICfM?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1P193MB0123.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e20bb41-52fe-44b0-ffdd-08da5e63ade2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 08:52:23.7829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P193MB1621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi=0A=
=0A=
I'm trying to run squid with TPROXY enabled but the system reboots after lo=
gging these messages:=0A=
=0A=
  IPv4: Attempt to release TCP socket in state 1 00000000dfe7f997=0A=
=0A=
and after some seconds:=0A=
=0A=
  rcu: INFO: rcu_sched detected stalls on CPUs/tasks:=0A=
  rcu:5-....: (6 GPs behind) idle=3Df9e/0/0x1 softirq=3D184030/184030 fqs=
=3D1901=0A=
  (detected by 1, t=3D6302 jiffies, g=3D894549, q=3D17504)=0A=
  Sending NMI from CPU 1 to CPUs 5:=0A=
  NMI backtrace for cpu 5=0A=
  CPU: 5 PID: 0 Comm: swapper/5 Tainted: GO 5.4.181+ #9=0A=
  Hardware name: Dell Inc. PowerEdge R630/02C2CP, BIOS 2.12.1 12/04/2020=0A=
  RIP: 0010:__inet_lookup_established+0x4c/0xf7=0A=
  Code: 48 89 f5 53 48 c1 e5 20 44 89 cb 48 09 c5 44 09 c3 e8 7b fe ff ff 4=
1 89 c6 41 89 c5 49 8b 07 45 23 77 10 4e 8d 3c f0 49 8b 17 <f6> c2 01 0f 85=
 89 00 00 00 44 39 6a a0 75 7b 39 5a a4 75 76 48 39=0A=
  RSP: 0018:ffffc90000208c48 EFLAGS: 00000a12=0A=
  RAX: ffff88844ad00000 RBX: 0000000001bb18e1 RCX: 00000000baf65c60=0A=
  RDX: 000000000002b145 RSI: 00000000e5cc7389 RDI: 000000009da543b1=0A=
  RBP: 490e1a683c63a8c0 R08: 00000000000018e1 R09: 0000000001bb0000=0A=
  R10: ffff8883c96da400 R11: 00000000000018e1 R12: ffffffff822b3740=0A=
  R13: 00000000593d39c6 R14: 00000000000139c6 R15: ffff88844ad9ce30=0A=
  FS:0000000000000000(0000) GS:ffff88844d940000(0000) knlGS:000000000000000=
0=0A=
  CS:0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
  CR2: 00007fd0297e8eb0 CR3: 00000003d37d4005 CR4: 00000000003606e0=0A=
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000=0A=
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400=0A=
  Call Trace:=0A=
 <IRQ>=0A=
 nf_sk_lookup_slow_v4+0x224/0xfbe [nf_socket_ipv4]=0A=
 ? do_raw_spin_lock+0x2b/0x52=0A=
 socket_match.isra.0+0x2f/0xf9 [xt_socket]=0A=
 ipt_do_table+0x26f/0x5c1 [ip_tables]=0A=
 ? nf_ct_key_equal+0x38/0x5d [nf_conntrack]=0A=
 ? nf_conntrack_in+0x2bd/0x46b [nf_conntrack]=0A=
 nf_hook_slow+0x3c/0xb4=0A=
 nf_hook.constprop.0+0xa5/0xc8=0A=
 ? l3mdev_l3_rcv.constprop.0+0x50/0x50=0A=
 ip_rcv+0x41/0x61=0A=
 __netif_receive_skb_one_core+0x74/0x95=0A=
 process_backlog+0x97/0x122=0A=
 net_rx_action+0xf5/0x2a3=0A=
 __do_softirq+0xc2/0x1c6=0A=
 irq_exit+0x41/0x80=0A=
 call_function_single_interrupt+0xf/0x20=0A=
 </IRQ>=0A=
  RIP: 0010:mwait_idle+0x5f/0x75=0A=
  Code: f0 31 d2 48 89 d1 65 48 8b 04 25 40 ac 01 00 0f 01 c8 48 8b 08 48 c=
1 e9 03 83 e1 01 75 0e e8 2b c3 6c ff 48 89 c8 fb 0f 01 c9 <eb> 01 fb bf 15=
 00 00 00     65 48 8b 34 25 40 ac 01 00 e9 26 c3 6c ff=0A=
  RSP: 0018:ffffc900000f3ee0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff04=0A=
  RAX: 0000000000000000 RBX: ffff88844beee3c0 RCX: 0000000000000000=0A=
  RDX: 0000000000000000 RSI: ffff88844beee3c0 RDI: 0000000000000015  =0A=
  RBP: 0000000000000000 R08: 0000000000840188 R09: 0000000000000000=0A=
  R10: ffff88844d964b80 R11: ffff88844d964bc0 R12: 0000000000000000=0A=
  R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000=0A=
 do_idle+0xcf/0x1da=0A=
 ? do_idle+0x2/0x1da =0A=
 cpu_startup_entry+0x1a/0x1c =0A=
 start_secondary+0x14b/0x169 =0A=
 secondary_startup_64+0xa4/0xb0=0A=
  ------------[ cut here ]------------ =0A=
  NETDEV WATCHDOG: eth2 (igb): transmit queue 4 timed out =0A=
  WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:480 dev_watchdog+0xcf/0=
x128=0A=
  Modules linked in: xt_CLASSIFY xt_nfacct sch_sfq xt_IMQ xt_NFLOG xt_limit=
 xt_pkttype xt_nat xt_MASQUERADE xt_REDIRECT xt_connlimit nf_conncount xt_t=
ime xt_geoip(O) xt_iprange xt_NFQUEUE xt_TPROXY nf_tproxy_ipv6 nf_tproxy_ip=
v4 xt_mac xt_mark 8021q garp mrp xt_multiport xt_socket nf_socket_ipv4 nf_s=
ocket_ipv6 ebtable_filter ebtable_nat ebtables xt_state xt_conntrack iptabl=
e_filter iptable_nat xt_set xt_connlabel xt_connmark iptable_mangle xt_rece=
nt iptable_raw sch_htb ip_set_hash_ipportip ip_set_hash_ip nfnetlink_acct n=
f_nat_pptp nf_conntrack_pptp nf_nat_irc nf_conntrack_irc nf_nat_tftp nf_con=
ntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat_h323 nf_conntrack_h323 nf_na=
t_sip nf_conntrack_sip nf_nat nfnetlink_log ip_set nfnetlink_queue nf_connt=
rack_netlink tun nfnetlink intel_lpss_pci intel_lpss imq igb sch_fq_codel n=
f_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bonding llc e1000e e1000 ip_table=
s=0A=
  CPU: 1 PID: 0 Comm: swapper/1 Tainted: G O5.4.181+ #9=0A=
  Hardware name: Dell Inc. PowerEdge R630/02C2CP, BIOS 2.12.1 12/04/2020=0A=
  RIP: 0010:dev_watchdog+0xcf/0x128=0A=
  Code: 4b a1 00 00 75 38 48 89 ef c6 05 39 4b a1 00 01 e8 2e 7b fd ff 44 8=
9 e1 48 89 ee 48 c7 c7 fb e6 0d 82 48 89 c2 e8 a0 98 0d 00 <0f> 0b eb 10 41=
 ff c4 48 05 40 01 00 00 41 39 f4 75 9d eb 13 48 8b=0A=
  RSP: 0018:ffffc90000158ec0 EFLAGS: 00010282=0A=
  RAX: 0000000000000000 RBX: ffff88844b234440 RCX: 0000000000000007=0A=
  RDX: 00000000000003f2 RSI: ffffc90000158db4 RDI: ffff88844d85b5b0=0A=
  RBP: ffff88844b234000 R08: 0000000000000001 R09: 0000000000014600=0A=
  R10: 0000000000000000 R11: 000000000000005c R12: 0000000000000004=0A=
  R13: ffffc90000158ef8 R14: ffffffff822050c0 R15: 0000000000000002=0A=
  FS:0000000000000000(0000) GS:ffff88844d840000(0000) knlGS:000000000000000=
0 =0A=
  CS:0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
  CR2: 00007faad50f2000 CR3: 0000000437d0e005 CR4: 00000000003606e0=0A=
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000=0A=
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400=0A=
  Call Trace:=0A=
 <IRQ> =0A=
 call_timer_fn.isra.0+0x18/0x6f=0A=
 ? netif_tx_lock+0x7a/0x7a =0A=
 __run_timers.part.0+0x12d/0x163 =0A=
 ? hrtimer_forward+0x73/0x7b =0A=
 ? tick_sched_timer+0x57/0x62=0A=
 ? timerqueue_add+0x62/0x68=0A=
 run_timer_softirq+0x21/0x43 =0A=
 __do_softirq+0xc2/0x1c6 =0A=
 irq_exit+0x41/0x80=0A=
 smp_apic_timer_interrupt+0x6f/0x7a=0A=
 apic_timer_interrupt+0xf/0x20=0A=
 </IRQ>=0A=
  RIP: 0010:mwait_idle+0x5f/0x75=0A=
  Code: f0 31 d2 48 89 d1 65 48 8b 04 25 40 ac 01 00 0f 01 c8 48 8b 08 48 c=
1 e9 03 83 e1 01 75 0e e8 2b c3 6c ff 48 89 c8 fb 0f 01 c9 <eb> 01 fb bf 15=
 00 00 00 65 48 8b 34 25 40 ac 01 00 e9 26 c3 6c ff=0A=
  RSP: 0018:ffffc900000d3ee0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13=0A=
  RAX: 0000000000000000 RBX: ffff88844beeaac0 RCX: 0000000000000000=0A=
  RDX: 0000000000000000 RSI: ffff88844beeaac0 RDI: 0000000000000015=0A=
  RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000=0A=
  R10: ffff88844d864b80 R11: ffff88844d864bc0 R12: 0000000000000000=0A=
  R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000=0A=
 do_idle+0xcf/0x1da=0A=
 cpu_startup_entry+0x1a/0x1c=0A=
 start_secondary+0x14b/0x169=0A=
 secondary_startup_64+0xa4/0xb0=0A=
  ---[ end trace 9e50b2e05e0ee06d ]---=0A=
=0A=
My current kernel is 5.4 and these are my iptables config:=0A=
=0A=
 iptables -t mangle -A PREROUTING -p tcp -m multiport --sport 80 -m socket =
-m conntrack --ctdir REPLY -j DIVERT=0A=
 iptables -t mangle -A DIVERT -j MARK --set-mark 1=0A=
 iptables -t mangle -A DIVERT -j ACCEPT=0A=
 iptables -t mangle -A PREROUTING -p tcp -m multiport --dports 80 -j TPROXY=
 --tproxy-mark 1 --on-port 3129=
