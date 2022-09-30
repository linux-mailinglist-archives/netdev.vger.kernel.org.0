Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB3B5F165C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiI3W4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiI3W4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:56:44 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60049.outbound.protection.outlook.com [40.107.6.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C74ACE9AE
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:56:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxrjj8ty9pL4cNsnC4efgJMIW8N9aeVAZMPW/1qqiqTXd1pxlP8JBaRTVvFp591vXRSws1Lm10gfd0F8daLJdpORCQEQeLFZplK/v9olaBbeHiyVTNdGK5GUYYz05AMWQM0qC+ZuZTUrpxOnvE0koLl6ij10vFND92lwJqkjAVlCj3QpYiINLNjEKga+gn8aBqvKIh1NgzHyheIA2LO7GFy+8bL4p6FqdH9iL8mDP3w9xUPu/VL7NJ/lpLEeFxciuy3Qw9ROOtoLMsgBAFAlIy93v5EOylHBOkglQV1kZ2abm0kNc/nL5icUS3IEz118N/KRuwnmQi98VLGYus+TOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSzqyaRK09qDGHaFHRSb6+InCaw7ij68OVsYx27lNW8=;
 b=Jp6tisQDXC6o8qzBSN1F4q4ZhRLyIJ+Ui62b9c1sMJBBAoJWaVKIowU79CCS2t5nYTqM8f/ECx6bXd5/wzj0diTLaZof2cfqcfglvNPSqjcfm9uphzAAPEcXQRikNmeAW0Ot91u+f3A639BOJuKME9XjQ+EVC77nqruRv8aC8ZKjoJCTKfzdATVwFTZuwUHnq7QDjWq/mSoxjpNZ1qYnnFvCPFyAJI/Kn1zsDmWndx5P8BmbMZ2B7sgwk41HvCeder7C/h2xvFXZ188gE9VQ3klOUNyycICAofQkz2CV0saCah9tM4NAWK5AUZm8DWCs5eENbdnAvgh8nODIStOG/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSzqyaRK09qDGHaFHRSb6+InCaw7ij68OVsYx27lNW8=;
 b=Qc+YImdzY4j6FwEKruDJRG1XEjD+uSqWEF72pUbZig7KipkwE2kuoeXqvI0QWpBvtAd5PkvJWy5Vv0f5Xgv/AkITzdUfHclyvcjw3L5KY0G3joWpBbQMvwJFe4ZvQyoYBO5shMCWElldnXtMgvVh/pD6FC6np1xdYH+3F4otIXg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9467.eurprd04.prod.outlook.com (2603:10a6:10:35b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 22:56:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Fri, 30 Sep 2022
 22:56:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yannick.vignon@nxp.com" <yannick.vignon@nxp.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net v1] net/sched: taprio: Fix crash when adding child
 qdisc
Thread-Topic: [PATCH net v1] net/sched: taprio: Fix crash when adding child
 qdisc
Thread-Index: AQHY1RxOd1dFmi5dEk+opmYKbXniaq34lZOA
Date:   Fri, 30 Sep 2022 22:56:40 +0000
Message-ID: <20220930225639.q4hr4vcqhy7zyomk@skbuf>
References: <20220930223042.351022-1-vinicius.gomes@intel.com>
In-Reply-To: <20220930223042.351022-1-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU0PR04MB9467:EE_
x-ms-office365-filtering-correlation-id: 54820e6a-c784-4652-61b5-08daa33709b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lNzqdOhrJeI3/dyxAgm+KZsuZX/ISywy9FzKozknHO+p3zuEgYLV6D8icgXgv/668ToqVU6SCEbao9l2dGZWSKnJLuUlWiy1arbaz9AWRiDNuRapsa3etYC69ksHHTAnhtL090ZcPgBaL82xLKynX9gKjJ7wjAEilIcea/B3+0HgBZ+bZH062K5GneN5ZwKML8XQjPvcckaGriqctuwg7Tu1+5REEpAIRa9JgUAQBUq26kLXFTc6XGcXiwPA0v0plMEBIRCFq5Kph7zZqAoUTWzQ+L2wc+Ce1dhwVwAMsjHCHGFMh6dRsmVLl7jrMxquBuHvLeDIEwUm/NUltrhBQSBhJEHG+LQ56iE1zRFF119ns0wS0yafk0MJqXzNYsVB0moToO9+b5/GZBaTIMYUixLaqWXpApXwVdtBRn5/a/Tyhli4jwCpyTI6bRvAVYUYYBc2yfAUk0xWRLY/FQ4kASbBdGByrLtCy+inyQC2JjQ7geZDqfdgDX/r5sOd73wfsOEF0JA9ZoYUV9SytCF4gPc3LE8SuH4vznakC/RslNtBWBdEwCx7SISMnsNGuqX/GBHQ4CwOhvoqVK+EYGcZnA5Cq3dhjm51lCfKhtCSxW0C4j+QwAfAuJRCz/f8LFPSVGNY4VgBzTLxPvrtVQWw12oZtaUgp3TzkKeXDPMIK/UNOzujG958z0mVmBUeiOdoof2JP9xVnscFMoeNowdzryFMddUw80jStQLlIXEzW3XD8dLs1oDTkaWBIe+mz6BmoqGle5nM6ltnx+M+TeaAag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(478600001)(6506007)(66476007)(66446008)(64756008)(8676002)(4326008)(66556008)(66946007)(76116006)(316002)(45080400002)(6486002)(71200400001)(6916009)(54906003)(122000001)(38100700002)(38070700005)(1076003)(186003)(9686003)(6512007)(26005)(33716001)(86362001)(83380400001)(2906002)(8936002)(44832011)(66899015)(41300700001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ibSNn6HhqnrhNwEDjD3P19C8PTBmAz6axwO47xMCN4mu7sr11o5o5Wmv8v7a?=
 =?us-ascii?Q?wggxQj5sk4DX9wy5pVmo64gGcCrf8cEjN1ei6BD+rRaKcdGFbNrA1szPsg2d?=
 =?us-ascii?Q?0+Rx+10MCyINsfkr0u1nJDCPbUkpx9bzCGTF6nd6UYaNGmXrzhCutj8ILf4G?=
 =?us-ascii?Q?IzAjdu91zTdSqVKarzzJ/36naEOsH5fpgAvCGDNItqDZvRCNbQh2xsf0EDop?=
 =?us-ascii?Q?HQWuy8zdt67ZtMCCxxHbJhZ8p0cg1mRkvcD7C4bYaDcGX68JMeNGlhWgv5/J?=
 =?us-ascii?Q?2mVETJRgtn2DylnQSfyppj5EL/byGjUPT2L+8lKXKmKwi9ylgVDecNCgu4uy?=
 =?us-ascii?Q?66zMTNF5MidabEtouo3JaYTqOBAxYoh2LZI9Byu9cvS7UlI6fZRri5972Km+?=
 =?us-ascii?Q?cE8zK7iaWu3LaN/vlC5zU0iqEPn0+5Fmxh5H/EWAqsTCS/gBadYcGp1VTxe4?=
 =?us-ascii?Q?54BJwmhDkJrq5i9T/JoXdbnDPAj4PahbxTRTLdQjQ9Mw7NCfHCtc1a94BYNv?=
 =?us-ascii?Q?8fdPVaWdDLStetBwSqAwzcpryVLP9J1D8o/MxMNM4jUVwkw2255s3t2w/tb9?=
 =?us-ascii?Q?4YXFalrTZr9yy40tDhmGR88zT82NGZ3qI3D3d6ulf5HNlO9SCPUmRtyylkhH?=
 =?us-ascii?Q?E4uIwbF37+1IbWayL/UytGIpPn6PVB8QoawwzdLBIm7CV1Y/TPRo646LKn0U?=
 =?us-ascii?Q?BKUAY4gv8lzBBWnjoudqYOXpnok7kLbDW1KdUEtHsx08NdaZTx6A2KvGXX0V?=
 =?us-ascii?Q?LRkOGva3WtZ3hW+13XSNR60iNBYYjV8xQNBl+B/+G/2pVpJqXbdumJjWknXr?=
 =?us-ascii?Q?fd406AFQfrZ2pmKg4G/WW11AZhtZzDZh6cU1QIRnJCAgejp74CSnBD5Je/YO?=
 =?us-ascii?Q?WgUUaWcyrtO9yzBN4BZtUgtLB8bqus68f3PV9JisVfyhgvVpPbrCr/iZ3KHh?=
 =?us-ascii?Q?zmpdKmUFmcmeaKvKEWHP6EZb/CHiPD6ptYRPg2OrPxRW5cu/VcCnLpw0iTYw?=
 =?us-ascii?Q?RdzImlCK7qVLSmWkfJKIp/govewZt9ypYOujwrJm08jDzFvKi4OZPP/sfkCq?=
 =?us-ascii?Q?3SGAUqToRVUKneFcWULdP+0QUi9tL5GIMCZG9jV16wtZimh4db+UpDUOR4n5?=
 =?us-ascii?Q?KiNe76wIg6VUBCOG+ziaPJzlE/JEkxbRX5RbKJcnL74o8eHuL8gQoKM/8lQf?=
 =?us-ascii?Q?MeIgl7s37yPPE/5LEsE30n9NjD1BxcRWLwAHY+Fn8NQKRa533AFTUUugMCWk?=
 =?us-ascii?Q?EjbF1Zz7FBaabI7zjZ2s3F7EvaHohZ/xndDjykAbPh1yJ1h8ddULzbs2RnEl?=
 =?us-ascii?Q?CmPanUd4NXSTBhRZUPFZZxD4dmkFiladtLJQb82owhJgMtbeO1vM0gbl0PZu?=
 =?us-ascii?Q?mnT941j1kDX+ioTJbKGSvrfdybTU87Xba5BAXzdqAdtGy4Fer6VNGw1aJ7GR?=
 =?us-ascii?Q?fLZHDbpZSDwZqYCfOnVuAwTJB01bwpwWLMX0MpFCWnL7fu25vR7usI/OwJfF?=
 =?us-ascii?Q?WgaemHG9ochnHEk7oylQFlkvH8mzjE6Ic7ZP1r2LUap8+16wPcIaYcbqa/W7?=
 =?us-ascii?Q?DrBfPOjDiCE+EZkTpRE+Kp6FGRRiM4Slqsdiwsg/fhlyMhLWErFFCEtHsfHp?=
 =?us-ascii?Q?bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3106A717700A147A2C1C9B6FB7167DA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54820e6a-c784-4652-61b5-08daa33709b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 22:56:40.7706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fq+LYsqY8qvGM2p9ArE/lZmnZ8cht4RV4sbzriyJ1fRVtDgJQvhI+jwVXQs6da4MO5JDEQ1/zBXVS7WRqA/p5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9467
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 03:30:42PM -0700, Vinicius Costa Gomes wrote:
> It was reported by Husaini that since commit 1461d212ab27 ("net/sched:
> taprio: make qdisc_leaf() see the per-netdev-queue pfifo child
> qdiscs"), there was a NULL dereference when adding a child qdisc (ETF
> in this case) when using taprio full offload.
>=20
> The issue seems to be that since commit 13511704f8d7 ("net: taprio
> offload: enforce qdisc to netdev queue mapping"), the array of child
> qdiscs (q->qdiscs[]) was not used, and even free'd when full offload
> mode is used, in attach().
>=20
> The current implementation since 1461d212ab27 (which I feel is a
> sensible change) requires that the q->qdiscs[] array is always valid.
> The fix is to not deallocate it, and keep it having references to each
> child qdisc.
>=20
> Log:
>=20
> [ 2295.318620] IPv6: ADDRCONF(NETDEV_CHANGE): enp170s0: link becomes read=
y
> [ 2371.758745] BUG: kernel NULL pointer dereference, address: 00000000000=
00008
> [ 2371.765697] #PF: supervisor read access in kernel mode
> [ 2371.770825] #PF: error_code(0x0000) - not-present page
> [ 2371.775952] PGD 0 P4D 0
> [ 2371.778494] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [ 2371.782844] CPU: 0 PID: 17964 Comm: tc Tainted: G     U  W          6.=
0.0-rc6-intel-ese-standard-lts+ #95
> [ 2371.792374] Hardware name: Intel Corporation Tiger Lake Client Platfor=
m/TigerLake U DDR4 SODIMM RVP, BIOS TGLIFUI1.R00.4204.A00.2105270302 05/27/=
2021
> [ 2371.805701] RIP: 0010:taprio_leaf+0x1e/0x30 [sch_taprio]
> [ 2371.811011] Code: Unable to access opcode bytes at RIP 0xffffffffc1112=
ff4.
> [ 2371.817867] RSP: 0018:ffffae7f82263a28 EFLAGS: 00010206
> [ 2371.823078] RAX: 0000000000000000 RBX: 0000000001000002 RCX: ffff8a704=
ff38000
> [ 2371.830190] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a704=
3f29000
> [ 2371.837307] RBP: ffff8a7043f29000 R08: 0000000000000000 R09: ffffae7f8=
2263b98
> [ 2371.844420] R10: 0000000000000002 R11: ffff8a7045df0000 R12: ffff8a705=
19cc400
> [ 2371.851534] R13: ffffae7f82263b98 R14: ffffffff9a04fb00 R15: ffff8a704=
ff38000
> [ 2371.858646] FS:  00007fd2fc262740(0000) GS:ffff8a7790a00000(0000) knlG=
S:0000000000000000
> [ 2371.866707] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2371.872435] CR2: ffffffffc1112ff4 CR3: 00000001053ac003 CR4: 000000000=
0770ef0
> [ 2371.879546] PKRU: 55555554
> [ 2371.882261] Call Trace:
> [ 2371.884719]  <TASK>
> [ 2371.886831]  tc_modify_qdisc+0x75/0x7c0
> [ 2371.890667]  rtnetlink_rcv_msg+0x141/0x3c0
> [ 2371.894764]  ? _copy_to_iter+0x1b0/0x5a0
> [ 2371.898685]  ? rtnl_calcit.isra.0+0x140/0x140
> [ 2371.903040]  netlink_rcv_skb+0x4e/0x100
> [ 2371.906878]  netlink_unicast+0x197/0x240
> [ 2371.910797]  netlink_sendmsg+0x246/0x4a0
> [ 2371.914718]  sock_sendmsg+0x5f/0x70
> [ 2371.918207]  ____sys_sendmsg+0x20f/0x280
> [ 2371.922130]  ? copy_msghdr_from_user+0x72/0xb0
> [ 2371.926570]  ___sys_sendmsg+0x7c/0xc0
> [ 2371.930233]  ? ___sys_recvmsg+0x89/0xc0
> [ 2371.934070]  __sys_sendmsg+0x59/0xa0
> [ 2371.937647]  do_syscall_64+0x40/0x90
> [ 2371.941224]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [ 2371.946273] RIP: 0033:0x7fd2fc38e707
> [ 2371.949847] Code: 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1=
f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <=
48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> [ 2371.968521] RSP: 002b:00007fffafdf9ce8 EFLAGS: 00000246 ORIG_RAX: 0000=
00000000002e
> [ 2371.976070] RAX: ffffffffffffffda RBX: 0000000063359bf0 RCX: 00007fd2f=
c38e707
> [ 2371.983183] RDX: 0000000000000000 RSI: 00007fffafdf9d50 RDI: 000000000=
0000003
> [ 2371.990293] RBP: 0000000000000000 R08: 0000000000000001 R09: 000000000=
0000000
> [ 2371.997406] R10: 00007fd2fc28d670 R11: 0000000000000246 R12: 000000000=
0000001
> [ 2372.004520] R13: 00005583e730c476 R14: 00005583e730c48a R15: 00005583e=
7333280
> [ 2372.011637]  </TASK>
> [ 2372.013830] Modules linked in: sch_taprio bnep 8021q bluetooth ecdh_ge=
neric ecc ecryptfs nfsd sch_fq_codel uio uhid iwlwifi cfg80211 i915 x86_pkg=
_temp_thermal kvm_intel kvm hid_sensor_als hid_sensor_incl_3d hid_sensor_gy=
ro_3d hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_trigger hid_sensor_=
iio_common hid_sensor_custom hid_sensor_hub atkbd mei_hdcp intel_ishtp_hid =
libps2 mei_wdt vivaldi_fmap dwc3 dwmac_intel stmmac e1000e ax88179_178a usb=
net mii mei_me igc thunderbolt udc_core mei pcs_xpcs wdat_wdt irqbypass spi=
_pxa2xx_platform phylink intel_ish_ipc i2c_i801 dw_dmac tpm_crb intel_rapl_=
msr pcspkr dw_dmac_core i2c_smbus intel_ishtp tpm_tis parport_pc intel_pmc_=
core igen6_edac tpm_tis_core thermal parport i8042 tpm edac_core dwc3_pci v=
ideo drm_buddy ttm drm_display_helper fuse configfs snd_hda_intel snd_intel=
_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_pcm snd_timer snd=
 soundcore
> [ 2372.092427] CR2: 0000000000000008
> [ 2372.095744] ---[ end trace 0000000000000000 ]---
> [ 2372.276814] RIP: 0010:taprio_leaf+0x1e/0x30 [sch_taprio]
> [ 2372.282140] Code: Unable to access opcode bytes at RIP 0xffffffffc1112=
ff4.
> [ 2372.288995] RSP: 0018:ffffae7f82263a28 EFLAGS: 00010206
> [ 2372.294215] RAX: 0000000000000000 RBX: 0000000001000002 RCX: ffff8a704=
ff38000
> [ 2372.301329] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a704=
3f29000
> [ 2372.308442] RBP: ffff8a7043f29000 R08: 0000000000000000 R09: ffffae7f8=
2263b98
> [ 2372.315550] R10: 0000000000000002 R11: ffff8a7045df0000 R12: ffff8a705=
19cc400
> [ 2372.322663] R13: ffffae7f82263b98 R14: ffffffff9a04fb00 R15: ffff8a704=
ff38000
> [ 2372.329774] FS:  00007fd2fc262740(0000) GS:ffff8a7790a00000(0000) knlG=
S:0000000000000000
> [ 2372.337840] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2372.343569] CR2: ffffffffc1112ff4 CR3: 00000001053ac003 CR4: 000000000=
0770ef0
> [ 2372.350680] PKRU: 55555554
>=20
> Fixes: 1461d212ab27 ("net/sched: taprio: make qdisc_leaf() see the per-ne=
tdev-queue pfifo child qdiscs")
> Reported-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.c=
om>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
> This patch is more to make others aware of this issue and to explain
> what I think is going on. Perhaps the correct solution is something
> else. (and that explicit refcount seems wrong, but getting warnings
> without it).
>=20
> I am questioning my sanity, I have clear memories about testing the
> commit above and it working fine.
>=20
> Reverting commit 1461d212ab27 is another alternative, but I think it's
> worth to keep that and fix the problem that it exposed.
>=20
>=20
>  net/sched/sch_taprio.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 86675a79da1e..75aacfff2d5e 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1763,12 +1763,6 @@ static void taprio_attach(struct Qdisc *sch)
>  		if (old)
>  			qdisc_put(old);
>  	}
> -
> -	/* access to the child qdiscs is not needed in offload mode */
> -	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> -		kfree(q->qdiscs);
> -		q->qdiscs =3D NULL;
> -	}
>  }

omfg, I didn't include this hunk in the patch? yikes, sorry.

> =20
>  static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
> @@ -1801,8 +1795,9 @@ static int taprio_graft(struct Qdisc *sch, unsigned=
 long cl,
>  		*old =3D dev_graft_qdisc(dev_queue, new);
>  	} else {
>  		*old =3D q->qdiscs[cl - 1];
> -		q->qdiscs[cl - 1] =3D new;
>  	}
> +	q->qdiscs[cl - 1] =3D new;
> +	qdisc_refcount_inc(new);

What warning are you getting without this part of the change?

> =20
>  	if (new)
>  		new->flags |=3D TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
> --=20
> 2.37.3
>=
