Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128782D7758
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406046AbgLKOC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:02:58 -0500
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:31872
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395310AbgLKOCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 09:02:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9SZ0K+5hx7hWic5lWp5BbQ5+6VshQLagSXe/AyEXTKdOuWE6mKRIecwpdu/cqnSK9aZjhFKLWRZJWwlt8vQHXUkw6fam386wQostiIqEJfaGj8LpYUgTCIXZue4c2RTZZyScCATnMUglwYpkfAzgaetZ3DUGBDSLWyEq0wY5O2yUh0FXw3tE1opPsbz2Qm5bo+7vU3cGt/UlohfEyMQXS58H6AusFLbr1fwGNFQ95YM4Q8AjBVJB2rPgMvzRTpmRTvSVieFMIAaYRGWTQv3VrTYwAtAx3ePwgiNlJr5oGY/jT9nLZvTl++QmkGM218ShBVy8DJO0gG2i/9sZYF4YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbzVwvk1rnns94krOjC5GzPjHByaB1bExPhoJQzyJ2k=;
 b=UobfvMriNAq8wepSBLBmr6LQHKrWLP+cATWMdPq75TiKWBFpgia4A3y/fLclyZOW06On0LSnSJ4r3uhGJZwTu+U1HqmHdezLv+/FbbW40oN3ePvzaJwT5EK9v1Yt9IHsmWMbB8iYhHXBHiLRD9gXT2DwTq0V0kVp2W2Bq5mLnEyGjroTabttgMA1MqltEYnliUD94VmeL73sE13xT1lG5lJU3CH2PbjT2FibYxDUEv1IjhPIAmWwyykAH3hPk8iL71xT9ytkZjPsKKH1Waph6R7yu2KtB/zUQLPdj6TZDqrlyF+WSvAD3Z6pt56sgVgvyPpj5DQdcV5HHXcIqG6G5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbzVwvk1rnns94krOjC5GzPjHByaB1bExPhoJQzyJ2k=;
 b=FmzgNSUDQ6Iw154kcJw3bwWfBNoz1FmuNTssSaCP9JI69ol3Bi8YkFDTvfqDwyJp+SRrpq7zZQTOEKICr7E2/ldT0hTWRUwXsIZZIPd1JCpbEtzgxnlFXiGAfh51YOeiWw2JdI5BqIMuBPAfg92mS0dVxdl0sGjc8LS1qv2X6Tg=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5245.eurprd04.prod.outlook.com
 (2603:10a6:803:5a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 11 Dec
 2020 14:01:28 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f%6]) with mapi id 15.20.3654.017; Fri, 11 Dec 2020
 14:01:28 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Daniel Thompson <daniel.thompson@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Thread-Topic: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Thread-Index: AQHWzxpfkmhJ4/PRJUyjg6gvz97H0KnwoDEAgAFN1QA=
Date:   Fri, 11 Dec 2020 14:01:28 +0000
Message-ID: <20201211140126.25x4z2x6upctyin5@skbuf>
References: <20200629184712.12449-2-ioana.ciornei () nxp ! com>
 <20201210173156.mbizovo6rxvkda73@holly.lan>
 <20201210180636.nsfwvzs5xxzpqt7n@skbuf>
In-Reply-To: <20201210180636.nsfwvzs5xxzpqt7n@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0abbca14-5362-4b49-5fa3-08d89ddd41a2
x-ms-traffictypediagnostic: VI1PR04MB5245:
x-microsoft-antispam-prvs: <VI1PR04MB52453E1E2BE965F8A8B5228DE0CA0@VI1PR04MB5245.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YWyBDn2y7BCJiMh/dm/uCXTYDvL4vu0q+4XsdjWUFak93j2krlw+F8J3Ntf7rDyrlkh3jVTbU0C2FMf/iMSNinD6ayvRmiz6ZwnwKCBs/ekyqwAe2+HbF26uetzVWsbCPWyuM5Ps0bXkXTWLMyX74bwGHkzFvgYRHSd6Ol7tZB5Yk+EOdIb2YCFGinXMzmsZb7RT0UQCnU3FCHekA6GOH0kgIVTYEHpGSIdxT4t/clGImt/AQXCY/HZzIuCDl7PzWL/PXuXi9CfIGT367HRxVcysQ8FOutmx7y6R+J5/LJ7kjwkHYtnHBaNYBbZbU5uteAuSG02VykS4WIb8t613Gg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(5660300002)(66476007)(64756008)(66446008)(66556008)(478600001)(2906002)(45080400002)(71200400001)(86362001)(6916009)(8676002)(6486002)(91956017)(66946007)(26005)(76116006)(33716001)(186003)(316002)(54906003)(9686003)(6506007)(6512007)(44832011)(8936002)(4326008)(83380400001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?mPNBI+/xPUyt4PPpQW4/oJCH194W6WVPrckaMY478P/CxXkzZm4441t+I/xL?=
 =?us-ascii?Q?bn8M60dIgl12uRPon0JfDNmya03kS8j28v33wxpPzJLkHqgk0ZzPPCIHex5r?=
 =?us-ascii?Q?akv8P/csbjNZ/JK04VcbT3rHn7IcWao5YfJIn/wKtc4E+yp34+bPrvhzPYvn?=
 =?us-ascii?Q?eol5Op9ey66t512xNl8iW76ygaCHac8XFVMyLJptGerTL5imyxZJxFQjBMFl?=
 =?us-ascii?Q?XRTMzyeLW9N45zxTDwxa7qpdbLaKv1X92uSuhEOFx4D+ra1XnOJwpee1Ev2a?=
 =?us-ascii?Q?BqohOYU3ztz+KJ+DzvR9VpaWq3pv3Ncvz2UesmwrtcsNFnElh9TjE9zbHbLK?=
 =?us-ascii?Q?cH3bo9zuMlBzbJ+ubvIkVyn9VSW46U5SfUuwOP8ALXzevpFZg8pr0Ues2e/H?=
 =?us-ascii?Q?Jl+7u9EUNC84V2sS4NuciuIRLcdNBkzpX/GBhm1qtVErV43EwdV0q7G4+qdC?=
 =?us-ascii?Q?pb9VJdTbki4XRYWNSUDoVcG4tp/lc+38M6mfVTA9W75N7i7KpxvYnEFVXCus?=
 =?us-ascii?Q?ev2tnrMovODyF+UgoKxrNA7aX/bSYeISNQlw6mZcx9J9x9LP49E+W0GODSWk?=
 =?us-ascii?Q?dzvszlTeX5OMR4LChvEfzABLQYyDB18TkjJaQjPKGKnJZb/A9i2UC+A3cgbE?=
 =?us-ascii?Q?R01zB7vSx90eBm1CotKwbyCPXi2MeirfTyCuKYX1uujGOAP8NXVpoIykw196?=
 =?us-ascii?Q?xZLXOWW4Ko86M+NlW490owJhkVJZWm8Q7PqQsWF0TuuEaxwtlX7tloNfVEpn?=
 =?us-ascii?Q?xreJAIxkJ4od6MUzksXcBT9zA8G2QYJRd4l9vUiLhq1FmkHt1ESQ8nMJjupj?=
 =?us-ascii?Q?Qz5iOvEsuzp4Sbj60M5O6VBCCb2wGVwf8xLjgRLNP1jZVtbayXZV+QqdZtd3?=
 =?us-ascii?Q?dzzidI8/Nl4cxL8zFJZDaETqKcQfKmdgzv+mUjk8dSIdsb4gnWN4r1azCUl/?=
 =?us-ascii?Q?WhX7gUhFddlmpn2tiYhLPn6z9G0lB8pKl3XdnbDH+XL6NcytPQ2UN8BCbZTB?=
 =?us-ascii?Q?ZJpN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1BEB62ED078DDE40B9FFC13ECD704B5E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abbca14-5362-4b49-5fa3-08d89ddd41a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2020 14:01:28.6559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WGc2o8n8HIk93c14Rb3qd91D0NksfFpSrC7/otZ/v+vf8j4Xr+i158BTQ/ieOjOH4uhWQWpEJMejS/eaFgRq4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5245
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 08:06:36PM +0200, Ioana Ciornei wrote:
> [Added also the netdev mailing list, I haven't heard of linux-netdev
> before but kept it]
>=20
> On Thu, Dec 10, 2020 at 05:31:56PM +0000, Daniel Thompson wrote:
> > Hi Ioana
>=20
> Hi Daniel,
>=20
> >=20
> > On Mon, Jun 29, 2020 at 06:47:11PM +0000, Ioana Ciornei wrote:
> > > Instead of realloc-ing the skb on the Tx path when the provided headr=
oom
> > > is smaller than the HW requirements, create a Scatter/Gather frame
> > > descriptor with only one entry.
> > >=20
> > > Remove the '[drv] tx realloc frames' counter exposed previously throu=
gh
> > > ethtool since it is no longer used.
> > >=20
> > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > ---
> >=20
> > I've been chasing down a networking regression on my LX2160A board
> > (Honeycomb LX2K based on CEx7 LX2160A COM) that first appeared in v5.9.
> >=20
> > It makes the board unreliable opening outbound connections meaning
> > things like `apt update` or `git fetch` often can't open the connection=
.
> > It does not happen all the time but is sufficient to make the boards
> > built-in networking useless for workstation use.
> >=20
> > The problem is strongly linked to warnings in the logs so I used the
> > warnings to bisect down to locate the cause of the regression and it
> > pinpointed this patch. I have confirmed that in both v5.9 and v5.10-rc7
> > that reverting this patch (and fixing up the merge issues) fixes the
> > regression and the warnings stop appearing.
> >=20
> > A typical example of the warning is below (io-pgtable-arm.c:281 is an
> > error path that I guess would cause dma_map_page_attrs() to return
> > an error):
> >=20
> > [  714.464927] WARNING: CPU: 13 PID: 0 at
> > drivers/iommu/io-pgtable-arm.c:281 __arm_lpae_map+0x2d4/0x30c
> > [  714.464930] Modules linked in: snd_seq_dummy(E) snd_hrtimer(E)
> > snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) bridge(E)
> > stp(E) llc(E) rfkill(E) caam_jr(E) crypto_engine(E) rng_core(E)
> > joydev(E) evdev(E) dpaa2_caam(E) caamhash_desc(E) caamalg_desc(E)
> > authenc(E) libdes(E) dpaa2_console(E) ofpart(E) caam(E) sg(E) error(E)
> > lm90(E) at24(E) spi_nor(E) mtd(E) sbsa_gwdt(E) qoriq_thermal(E)
> > layerscape_edac_mod(E) qoriq_cpufreq(E) drm(E) fuse(E) configfs(E)
> > ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E)
> > mbcache(E) jbd2(E) hid_generic(E) usbhid(E) hid(E) dm_crypt(E) dm_mod(E=
)
> > sd_mod(E) fsl_dpaa2_ptp(E) ptp_qoriq(E) fsl_dpaa2_eth(E)
> > xhci_plat_hcd(E) xhci_hcd(E) usbcore(E) aes_ce_blk(E) crypto_simd(E)
> > cryptd(E) aes_ce_cipher(E) ghash_ce(E) gf128mul(E) at803x(E) libaes(E)
> > fsl_mc_dpio(E) pcs_lynx(E) rtc_pcf2127(E) sha2_ce(E) phylink(E)
> > xgmac_mdio(E) regmap_spi(E) of_mdio(E) sha256_arm64(E)
> > i2c_mux_pca954x(E) fixed_phy(E) i2c_mux(E) sha1_ce(E) ptp(E) libphy(E)
> > [  714.465131]  pps_core(E) ahci_qoriq(E) libahci_platform(E) nvme(E)
> > libahci(E) nvme_core(E) t10_pi(E) libata(E) crc_t10dif(E)
> > crct10dif_generic(E) crct10dif_common(E) dwc3(E) scsi_mod(E) udc_core(E=
)
> > roles(E) ulpi(E) sdhci_of_esdhc(E) sdhci_pltfm(E) sdhci(E)
> > spi_nxp_fspi(E) i2c_imx(E) fixed(E)
> > [  714.465192] CPU: 13 PID: 0 Comm: swapper/13 Tainted: G        W   E
> > 5.10.0-rc7-00001-gba98d13279ca #52
> > [  714.465196] Hardware name: SolidRun LX2160A Honeycomb (DT)
> > [  714.465202] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
> > [  714.465207] pc : __arm_lpae_map+0x2d4/0x30c
> > [  714.465211] lr : __arm_lpae_map+0x114/0x30c
> > [  714.465215] sp : ffff80001006b340
> > [  714.465219] x29: ffff80001006b340 x28: 0000002086538003=20
> > [  714.465227] x27: 0000000000000a20 x26: 0000000000001000=20
> > [  714.465236] x25: 0000000000000f44 x24: 00000020adf8d000=20
> > [  714.465245] x23: 0000000000000001 x22: 0000fffffaeca000=20
> > [  714.465253] x21: 0000000000000003 x20: ffff19b60d64d200=20
> > [  714.465261] x19: 00000000000000ca x18: 0000000000000000=20
> > [  714.465270] x17: 0000000000000000 x16: ffffcccb7cf3ca20=20
> > [  714.465278] x15: 0000000000000000 x14: 0000000000000000=20
> > [  714.465286] x13: 0000000000000003 x12: 0000000000000010=20
> > [  714.465294] x11: 0000000000000000 x10: 0000000000000002=20
> > [  714.465302] x9 : ffffcccb7d5b6e78 x8 : 00000000000001ff=20
> > [  714.465311] x7 : ffff19b606538650 x6 : ffff19b606538000=20
> > [  714.465319] x5 : 0000000000000009 x4 : 0000000000000f44=20
> > [  714.465327] x3 : 0000000000001000 x2 : 00000020adf8d000=20
> > [  714.465335] x1 : 0000000000000002 x0 : 0000000000000003=20
> > [  714.465343] Call trace:
> > [  714.465348]  __arm_lpae_map+0x2d4/0x30c
> > [  714.465353]  __arm_lpae_map+0x114/0x30c
> > [  714.465357]  __arm_lpae_map+0x114/0x30c
> > [  714.465362]  __arm_lpae_map+0x114/0x30c
> > [  714.465366]  arm_lpae_map+0xf4/0x180
> > [  714.465373]  arm_smmu_map+0x4c/0xc0
> > [  714.465379]  __iommu_map+0x100/0x2bc
> > [  714.465385]  iommu_map_atomic+0x20/0x30
> > [  714.465391]  __iommu_dma_map+0xb0/0x110
> > [  714.465397]  iommu_dma_map_page+0xb8/0x120
> > [  714.465404]  dma_map_page_attrs+0x1a8/0x210
> > [  714.465413]  __dpaa2_eth_tx+0x384/0xbd0 [fsl_dpaa2_eth]
> > [  714.465421]  dpaa2_eth_tx+0x84/0x134 [fsl_dpaa2_eth]
> > [  714.465427]  dev_hard_start_xmit+0x10c/0x2b0
> > [  714.465433]  sch_direct_xmit+0x1a0/0x550
> > [  714.465438]  __qdisc_run+0x140/0x670
> > [  714.465443]  __dev_queue_xmit+0x6c4/0xa74
> > [  714.465449]  dev_queue_xmit+0x20/0x2c
> > [  714.465463]  br_dev_queue_push_xmit+0xc4/0x1a0 [bridge]
> > [  714.465476]  br_forward_finish+0xdc/0xf0 [bridge]
> > [  714.465489]  __br_forward+0x160/0x1c0 [bridge]
> > [  714.465502]  br_forward+0x13c/0x160 [bridge]
> > [  714.465514]  br_dev_xmit+0x228/0x3b0 [bridge]
> > [  714.465520]  dev_hard_start_xmit+0x10c/0x2b0
> > [  714.465526]  __dev_queue_xmit+0x8f0/0xa74
> > [  714.465531]  dev_queue_xmit+0x20/0x2c
> > [  714.465538]  arp_xmit+0xc0/0xd0
> > [  714.465544]  arp_send_dst+0x78/0xa0
> > [  714.465550]  arp_solicit+0xf4/0x260
> > [  714.465554]  neigh_probe+0x64/0xb0
> > [  714.465560]  neigh_timer_handler+0x2f4/0x400
> > [  714.465566]  call_timer_fn+0x3c/0x184
> > [  714.465572]  __run_timers.part.0+0x2bc/0x370
> > [  714.465578]  run_timer_softirq+0x48/0x80
> > [  714.465583]  __do_softirq+0x120/0x36c
> > [  714.465589]  irq_exit+0xac/0x100
> > [  714.465596]  __handle_domain_irq+0x8c/0xf0
> > [  714.465600]  gic_handle_irq+0xcc/0x14c
> > [  714.465605]  el1_irq+0xc4/0x180
> > [  714.465610]  arch_cpu_idle+0x18/0x30
> > [  714.465617]  default_idle_call+0x4c/0x180
> > [  714.465623]  do_idle+0x238/0x2b0
> > [  714.465629]  cpu_startup_entry+0x30/0xa0
> > [  714.465636]  secondary_start_kernel+0x134/0x180
> > [  714.465640] ---[ end trace a84a7f61b559005f ]---
> >=20
> >=20
> > Given it is the iommu code that is provoking the warning I should
> > probably mention that the board I have requires
> > arm-smmu.disable_bypass=3D0 on the kernel command line in order to boot=
.
> > Also if it matters I am running the latest firmware from Solidrun
> > which is based on LSDK-20.04.
> >=20
>=20
> Hmmm, from what I remember I think I tested this with the smmu bypassed
> so that is why I didn't catch it.
>=20
> > Is there any reason for this code not to be working for LX2160A?
>=20
> I wouldn't expect this to be LX2160A specific but rather a bug in the
> implementation.. sorry.
>=20
> Let me reproduce it and see if I can get to the bottom of it and I will
> get back with some more info.
>=20

Hi Daniel,

It seems that the dma-unmapping on the SGT buffer was incorrectly done
with a zero size since on the Tx path I initialized the improper field.

Could you test the following diff and let me know if you can generate
the WARNINGs anymore?

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -878,7 +878,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa=
2_eth_priv *priv,
        swa =3D (struct dpaa2_eth_swa *)sgt_buf;
        swa->type =3D DPAA2_ETH_SWA_SINGLE;
        swa->single.skb =3D skb;
-       swa->sg.sgt_size =3D sgt_buf_size;
+       swa->single.sgt_size =3D sgt_buf_size;
=20
        /* Separately map the SGT buffer */
        sgt_addr =3D dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIREC=
TIONAL);


Ioana=
