Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99013B1911
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhFWLkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:40:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:63084 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhFWLkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 07:40:02 -0400
IronPort-SDR: wuCr1dXK9RS6zbUU3IUf46TOq5KARiqhOnrrBqGraRHY+jrSvuox6rIkq1awtVlEVDlWMpOPcD
 WmEIEtnr4FAg==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="204235219"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="204235219"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 04:37:45 -0700
IronPort-SDR: S2ADK69CeK8No3oXD0KFxKaw/YGcbSc+J+pgl1IhcTaSZkg92hNqFk8cBDVIaSdflZUCDmHVFL
 3TkBuwGHzxSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="454621510"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jun 2021 04:37:45 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 04:37:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 04:37:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 04:37:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjuorYrVjhAVxnRaYN/4KzgRf3DLK+lApwHsfHzxAXCC8xpzLTo8qh6s+gTAwRlSIlKA1hCMX8hA56elBHNXDc29MbRbP/+FrTAEJEaExr/Aunac/F5v1pXopji3sTqc+sFdxyctoOwhx0V3tQawnE+42djraGD8ChZCpcmJ86Q6+2Jdh61nDsVPCz3iZ6rYhSADU3c0nFbXQhv06c71pLCpV44nW3WUfs57Hz3Op5PehQ8UKCsmmKD8DWGDaRfO74YnbpXanOKhu4UOZ+fhV9a01e9Jj2MStI+1pBC1SdxBPSdmK99oDEaDEH+tUsT7Q2+4htAeg/ghYTj6id/5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7KeL2jfeAsF+yvoZxuZb1niT00HBEowrwiGKQyUQHs=;
 b=NbfYqQODJHf5bJTxxgKADlyyYXW63SjaslsMpC8+r0vMLrcB99TmwAJwsxUr6HWxvh0iFgqOW1YK3/PriR6i2SeD6dIgj5CQbH2JkDE7SrWnZbaYyDAdNLHLLaJGxDjWb+LjmENLadfkWFxpumqJ+ypeADt2oSOvShCyGeDpkjLtzDtA0fD44YYdZGqXb22D+hV19Gnsil8/xr1nx97N9oVKQku+5y2dyDuZTePTk1M9OLiuVQCZSIgHc8oav70soBOYmdPylhYxXqi4Bt3VFwuXEa1ZwtVCuSal25IvGmRV5YM2vkI+I1zLVsvnZ1aiJSo2rZiDsttwSNNC7Ldwag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7KeL2jfeAsF+yvoZxuZb1niT00HBEowrwiGKQyUQHs=;
 b=idmXIH5de7KE1ArlcqPRnWb20UKLKg4NRtYr8IIZ2X2eQv0+3vVa6TKIewLXqu78lQRdk/bfEJqlOpkzeT9XWAtdmXqeDivL6D57v43hUWfJ3ICrz/viu4f/2ZGjAAkVG/kcbwYbo5I0EbTwrUVzQ026zFGqS3obHAAwcnAz4nY=
Received: from SA2PR11MB4777.namprd11.prod.outlook.com (2603:10b6:806:115::24)
 by SA0PR11MB4688.namprd11.prod.outlook.com (2603:10b6:806:72::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 11:37:43 +0000
Received: from SA2PR11MB4777.namprd11.prod.outlook.com
 ([fe80::4426:b918:4325:f2ea]) by SA2PR11MB4777.namprd11.prod.outlook.com
 ([fe80::4426:b918:4325:f2ea%9]) with mapi id 15.20.4242.023; Wed, 23 Jun 2021
 11:37:43 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     netdev <netdev@vger.kernel.org>
CC:     Jose Abreu <joabreu@synopsys.com>
Subject: [BUG] Kernel panic when running stmmac selftest
Thread-Topic: [BUG] Kernel panic when running stmmac selftest
Thread-Index: Addn/CZFyMX+RtMtS0K/3u5i9rQBrw==
Date:   Wed, 23 Jun 2021 11:37:43 +0000
Message-ID: <SA2PR11MB47770A9C3665761D697086C6D5089@SA2PR11MB4777.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [175.136.124.169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c89234dc-a69e-4f25-e6e3-08d9363b50a8
x-ms-traffictypediagnostic: SA0PR11MB4688:
x-microsoft-antispam-prvs: <SA0PR11MB46884EBAD3710AE4584936FAD5089@SA0PR11MB4688.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YYyiOYPC07K5Xltlzr4HgixpXLwci5YsqXQhIFASqCaFey8a+E1pjHCtb7wWV3fRltdxbrAIa7SJZiLE9JwJk+yTyU1xML47FnsgymBs3XnQjkHfL/jIoeN5C1wlzbIsNCM+8kjz2aFffQWvCk0kl0ZT7CShEr24KWy2VaeT/D+lU9NcCiN/ZkP7do3/PnWI9UVPhAyS3OSjcjqdvDsAlpP1smexwbO7TivCOGYhFbwGT2Wby3YGWwTuTbNe3VqVvVjcNwrwvY8sVQTSsvyfOzQ7x6Qg3Y/WTDj+iTrQI1D31YWdA327rNgQeO/foeN0chPAmrCX/R7RGEMT6SIPZZ2OvVYxajW3BtK9kelJuCd0AxzMa+6EdKGaemIZIxyGqY4T61oVyiNM8PNdf7Jjzsr/Vca43mZixpGRQgAfec6OJIHqe1IYshgjuYfhCy4/pKKWm3wC7AY2ThvBAkqIG5fkj3PsCfhEogyd9VAvhgH/n3dHc7vEJZiEDbwdrSqqN8FlJJ6lSuIZYBTt1xYCufPRwkmmRoM4q7FFEIVvZbBJPOPx316uAIPHJdn+S1mdbTLNh8rhRfNREDJBgHXJZ2KuxhAanacG4vOMQV+0HYr646+ElIJEilFh2xBTujO/JSYbfq1Y8yYPaoDJTJhZtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4777.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(366004)(346002)(39860400002)(66946007)(83380400001)(76116006)(2906002)(71200400001)(4326008)(45080400002)(316002)(38100700002)(66556008)(64756008)(8676002)(8936002)(66446008)(66476007)(6916009)(122000001)(86362001)(478600001)(26005)(55016002)(9686003)(52536014)(7696005)(5660300002)(186003)(33656002)(6506007)(55236004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wLoqJvRdrwyofUfY8LQF85gmV3VV+4ImJpl4cnOasXYTJ1YwKfwp9eA1WXVd?=
 =?us-ascii?Q?PkCix8FpYuFOfPjo0/AnhgJU4d62OZT7YIvSRReakwAq12nARjnuDe+Mdc++?=
 =?us-ascii?Q?TQMF8nt7xToEQ0swlLn26hIhvGUll+nR7fG+YcdjUgmbvPnh5GBy7YSWAWEA?=
 =?us-ascii?Q?JXpnKcab4C7RjKxcsu40yRlSsQvB0dz3axam2QkKI9F1gx2xaTnRyVHb5+nX?=
 =?us-ascii?Q?Ar8VYqid8ejoGPidCm0ZdTKvON0ppOAO8kYRvPpJAuK9akSTY5QStB+G/NCc?=
 =?us-ascii?Q?uF9taqTx9+Yv/0OP2KWLoyZBQHAcOCMFTVoCf+cCMQyuyxLMIWuNt3nQNL0D?=
 =?us-ascii?Q?b3FzzVYvMkiaesE+g+TY9HkKg9sMeJIrRNT3AAB5fRpeyhZIbcMK9NGiIE35?=
 =?us-ascii?Q?jVb5OTvqRRKAy/eMokWc1Vc+O8/XCv4ayY/79Juf3MJ3Sx6miHYCj/wJpqbX?=
 =?us-ascii?Q?X0pFnKhg+74hdCQeAwP+HudPnXAJyIWnto1SYSE7YLuQtBU0FCrjs/AM8wtx?=
 =?us-ascii?Q?EHIQbCzB9Si2QYBZ/TtZIkdHDU5516UtNaturq6fLjVG5ZQUTEYOA2Kq2f5z?=
 =?us-ascii?Q?mPZ6IRXxiO21ZTP58BqJy5W61m8QFZ1MePuuiVKlvt61ooNir1iXQ62/5FCl?=
 =?us-ascii?Q?R4cmzVk6pahaHv6+DBPvV5SRgD3IjaGURDH5aE2G7/g6dF6rXm9SIQYlEeJO?=
 =?us-ascii?Q?1YApS65oKiGCKF4fQGkS+q43m+AMckOHOptthwx7xgC16Mp2LVtnhDRGbOqi?=
 =?us-ascii?Q?Tu/H80VxjadVefJWros/g25fvqKa41Pkt8Snphc9GEOLr1Vmpn7s1E/iJLEx?=
 =?us-ascii?Q?x+pt0cFvCGiL91fyNFn9dG/qXOQXkB7H7YOgU9DuTcEeoC+IaYjNdYtzOJUF?=
 =?us-ascii?Q?TSWwXYe9dZfs84Ka+yMVpvlzhI5CoJGuq4roB19VKuR42hNjDaTqtAR1HZkd?=
 =?us-ascii?Q?P6fHfHt0/QxV1z1fPSHzMrwiY3HmHIZiIrgP+M9Vl24dwIEqUjMashLAY5Sr?=
 =?us-ascii?Q?z0vBG2KmL2x8L44+nUFfwVxhxYboeMBdvJSZCXK6a8vpJo7g8CdYVVdWr5H4?=
 =?us-ascii?Q?/ky2vGGKX3Ech6tfS5ApGbUx4RfoKKzkaM9y8oiSaw6awc1H678dU9XZ/3cz?=
 =?us-ascii?Q?tFegM7qUihcQIpC8AbxKlZP7DsZ0NJ0aRP8YAWlo8iG6b2CP/u1ESPxCoXHZ?=
 =?us-ascii?Q?2iDKeLjson3b/C6NSosvcpouXwLUFo2MmW/+n4P5Hl8y6paM/MQHsJ2q4qKF?=
 =?us-ascii?Q?gz7iBQiCwDoojatd+qG4/GgVVuI3P5RC5GyWM5QHorTm2oFimX+qj93GlZpl?=
 =?us-ascii?Q?7eh1aWDvI1AZsi4F54aCKPUV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4777.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89234dc-a69e-4f25-e6e3-08d9363b50a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 11:37:43.2996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJuxb/UK4O4hvU1ds5rJ3CMHlO0Yoip4yzpjnF7L1suPcjirDNnaZyDochU7ZJIAAAPEk0uOpudMJ7adUEDv50S3BotzodKv8ghkOFMfKKyn9mqJhOauZ+QUuOFaNzdI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4688
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm getting Kernel panic when running stmmac selftest using "ethtool -t enp=
0s30f4 offline" command. I'm using net/master branch with last commit ID f4=
b29d2ee903 (net/master) Merge git://git.kernel.org/pub/scm/linux/kernel/git=
/pablo/nf.
It is tested on Intel ElkhartLake platform which has DesignWare Core Ethern=
et QoS version 5.20 (MAC), DesignWare Core Ethernet PCS version 3.30 and Ma=
rvell88E2110 PHY.

Below is the Kernel dump:

[   40.099871] ------------[ cut here ]------------
[   40.105049] kernel BUG at net/core/skbuff.c:1673!
[   40.110331] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   40.116179] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G     U            5.=
13.0-rc6-intel-lts-mismail5+ #89
[   40.126786] Hardware name: Intel Corporation Elkhart Lake Embedded Platf=
orm/ElkhartLake LPDDR4x T4 RVP1, BIOS EHLSFWI1.R00.3192.A01.2105041421 05/0=
4/2021
[   40.142135] RIP: 0010:pskb_expand_head+0x24b/0x2d0
[   40.147491] Code: df e8 c9 fc ff ff e9 ae fe ff ff 44 2b 74 24 04 31 c0 =
44 01 b3 d0 00 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b <0f=
> 0b be 02 00 00 00 e8 49 41 be ff e9 67 ff ff ff f6 c2 01 75 0d
[   40.168474] RSP: 0018:ffffa78100003b78 EFLAGS: 00010202
[   40.174308] RAX: 000000000000028d RBX: ffff8c0907ac3300 RCX: 00000000000=
00a20
[   40.182272] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8c0907a=
c3300
[   40.190241] RBP: ffffa78100003bf0 R08: ffff8c0907ac33d4 R09: 00000000000=
00043
[   40.198212] R10: 0000000000000008 R11: ffff8c0908788090 R12: 00000000000=
00224
[   40.206182] R13: ffff8c0907ac3300 R14: ffff8c090896bd40 R15: ffff8c0907a=
c3300
[   40.214150] FS:  0000000000000000(0000) GS:ffff8c0a64200000(0000) knlGS:=
0000000000000000
[   40.223188] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.229602] CR2: 00007f81a5a99e30 CR3: 0000000103c6c000 CR4: 00000000003=
50ef0
[   40.237573] Call Trace:
[   40.240297]  <IRQ>
[   40.242528]  __pskb_pull_tail+0x4f/0x3b0
[   40.246924]  stmmac_test_loopback_validate+0x6c/0x220 [stmmac]
[   40.253452]  __netif_receive_skb_core+0x66a/0x1120
[   40.258800]  ? domain_unmap+0x6e/0xf0
[   40.262888]  __netif_receive_skb_list_core+0x10d/0x280
[   40.268625]  ? mod_timer+0x1b5/0x320
[   40.272614]  netif_receive_skb_list_internal+0x1cd/0x2d0
[   40.278537]  gro_normal_list.part.160+0x19/0x40
[   40.283594]  napi_complete_done+0x65/0x150
[   40.288165]  stmmac_napi_poll_rx+0xc7f/0xd70 [stmmac]
[   40.293811]  ? __napi_schedule+0x7a/0x90
[   40.298190]  __napi_poll+0x28/0x140
[   40.302082]  net_rx_action+0x23d/0x290
[   40.306268]  __do_softirq+0xa3/0x2ef
[   40.310258]  irq_exit_rcu+0xbc/0xd0
[   40.314151]  common_interrupt+0xaf/0xe0
[   40.318434]  </IRQ>
[   40.320772]  asm_common_interrupt+0x1e/0x40
[   40.325443] RIP: 0010:cpuidle_enter_state+0xd9/0x370
[   40.330987] Code: 85 c0 0f 8f 0a 02 00 00 31 ff e8 a2 71 7c ff 45 84 ff =
74 12 9c 58 f6 c4 02 0f 85 47 02 00 00 31 ff e8 0b 43 82 ff fb 45 85 f6 <0f=
> 88 ab 00 00 00 49 63 ce 48 2b 2c 24 48 89 c8 48 6b d1 68 48 c1
[   40.351969] RSP: 0018:ffffffff93803e50 EFLAGS: 00000202
[   40.357806] RAX: ffff8c0a64200000 RBX: 0000000000000001 RCX: 00000000000=
0001f
[   40.365774] RDX: 0000000956207c60 RSI: ffffffff93664a37 RDI: ffffffff936=
6ed64
[   40.373742] RBP: 0000000956207c60 R08: 0000000000000000 R09: 00000000000=
2a340
[   40.381712] R10: 0000001a53fb88c6 R11: ffff8c0a64229ae4 R12: ffffc780ffc=
24618
[   40.389679] R13: ffffffff93977380 R14: 0000000000000001 R15: 00000000000=
00000
[   40.397650]  cpuidle_enter+0x29/0x40
[   40.401638]  do_idle+0x250/0x290
[   40.405238]  cpu_startup_entry+0x19/0x20
[   40.409608]  start_kernel+0x537/0x55c
[   40.413695]  secondary_startup_64_no_verify+0xb0/0xbb
[   40.419335] Modules linked in: bnep 8021q bluetooth ecryptfs marvell10g =
nfsd snd_sof_pci_intel_tgl iTCO_wdt snd_sof_intel_hda_common x86_pkg_temp_t=
hermal intel_ishtp_loader mei_hdcp soundwire_intel sch_fq_codel iTCO_vendor=
_support intel_ishtp_hid kvm_intel marvell soundwire_generic_allocation sou=
ndwire_cadence soundwire_bus kvm snd_hda_codec_hdmi snd_sof_xtensa_dsp uio =
snd_soc_acpi_intel_match uhid dwmac_intel snd_soc_acpi irqbypass stmmac int=
el_rapl_msr igb pcspkr snd_hda_intel pcs_xpcs snd_intel_dspcfg phylink i2c_=
i801 snd_intel_sdw_acpi libphy dca intel_ish_ipc snd_hda_codec mei_me snd_h=
da_core intel_ishtp mei i2c_smbus 8250_lpss spi_dw_pci dw_dmac_core spi_dw =
thermal tpm_crb tpm_tis tpm_tis_core parport_pc parport tpm intel_pmc_core =
i915 fuse configfs snd_sof_pci snd_sof snd_soc_core snd_compress ac97_bus l=
edtrig_audio snd_pcm snd_timer snd soundcore
[   40.503980] ---[ end trace a6a698bb4b2d1455 ]---
[   40.561709] RIP: 0010:pskb_expand_head+0x24b/0x2d0
[   40.567069] Code: df e8 c9 fc ff ff e9 ae fe ff ff 44 2b 74 24 04 31 c0 =
44 01 b3 d0 00 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b <0f=
> 0b be 02 00 00 00 e8 49 41 be ff e9 67 ff ff ff f6 c2 01 75 0d
[   40.588052] RSP: 0018:ffffa78100003b78 EFLAGS: 00010202
[   40.593888] RAX: 000000000000028d RBX: ffff8c0907ac3300 RCX: 00000000000=
00a20
[   40.601864] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8c0907a=
c3300
[   40.609838] RBP: ffffa78100003bf0 R08: ffff8c0907ac33d4 R09: 00000000000=
00043
[   40.609840] R10: 0000000000000008 R11: ffff8c0908788090 R12: 00000000000=
00224
[   40.609841] R13: ffff8c0907ac3300 R14: ffff8c090896bd40 R15: ffff8c0907a=
c3300
[   40.609841] FS:  0000000000000000(0000) GS:ffff8c0a64200000(0000) knlGS:=
0000000000000000
[   40.609843] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.609844] CR2: 00007f81a5a99e30 CR3: 0000000103c6c000 CR4: 00000000003=
50ef0
[   40.609845] Kernel panic - not syncing: Fatal exception in interrupt
[   40.609885] Kernel Offset: 0x11200000 from 0xffffffff81000000 (relocatio=
n range: 0xffffffff80000000-0xffffffffbfffffff)
[   40.727867] ---[ end Kernel panic - not syncing: Fatal exception in inte=
rrupt ]---

I`m not really have much knowledge and expertise on skb framework. It look =
like the issue is due to the skb is still shared by other user before runni=
ng skb_linearize().

The Kernel panic can be fixed (as workaround) by below change:

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drive=
rs/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 0462dcc93e53..53b1a9efb3d4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -261,6 +261,10 @@ static int stmmac_test_loopback_validate(struct sk_buf=
f *skb,
        if (!skb)
                goto out;
=20
+       skb =3D skb_share_check(skb, GFP_ATOMIC);
+       if (!skb)
+               goto out;
+
        if (skb_linearize(skb))
                goto out;
        if (skb_headlen(skb) < (STMMAC_TEST_PKT_SIZE - ETH_HLEN))

Please comment and advise.

Thank you.

Regards,
Athari

