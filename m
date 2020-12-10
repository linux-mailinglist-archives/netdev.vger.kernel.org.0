Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E3A2D647B
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392561AbgLJSHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 13:07:31 -0500
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:17807
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392817AbgLJSHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 13:07:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBLjfYxmWyXRCD475pWfMJxpebanGG1OSgSIlyMRNFzyVhvo9z/7+3cmkoogwXKgfdv3aRzpNQTpFoujXlhrcC4YzRuOIi9Soc0iVTxAxhZTro/38P32OkWpfLdWpUTlTJcP22cnaaj8top+k+wVAt0G0otbSsQlk5o1OK+56iKpTjueGxg4f9aKbeE0aJl7HCFDib+JqRJrKhLzQ7CxeLfZKbxaSw0vzqPB24A42yN6f4OHR0h8q8jfoabCUKO9QXiH4aFcFNrRI274oMGzrteL9e0YIZ5eSBO2yEBE0XnJGffIjBVD3Av421wd99DeLDF7gRdq6KAvu+gynt4KXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kPDyGumhAU5/mzADkxtq7JlASdd8D3d/MRvbjPBpiE=;
 b=PX0Nh73UanrKjZ8Oy+OPuniEv4sdMayIvd+nDn86PrjxUw0khHPo+7JHTVoiGAklZm2iAq2YR+PlxH2f5fAwmMAAQsv1OCRe9BN38VmpEiktQHSAZxcWc4Z4XCtcBfVjlcLkPteGz3P/IutxDP0ftz9j3GfS6CkUao9CxdJ3ulhB1ccYyVozszxhxgLPRwT2QqoBuVDuKbbqKOV3hMgqr0VxtzcNesmAB46EP9Lxn60/qB0cLvn3gxGndlhgZXdPbJOYkdLL3LFDtiJ6DsQz/D3dbuXQz/7N8LjWV3kjNgdwS2ObvapA3xPnTj1E22SGKgImzK7GUwe594kWkYokTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kPDyGumhAU5/mzADkxtq7JlASdd8D3d/MRvbjPBpiE=;
 b=QnjriXWxg5e4+oon0mATS1uXdAz/3lbl81aMAp3WnteU0vH9RSalPC8pahh6npB3wppW5zcIztgVBEZmfRYzEH6v66eyTdlhWUdtJD8coeSXqkFC0Co0TDU/m1SWgCwDU4jRe+eS+UGsMk9hgMBdSimcdn5uOXZwCqAn7LhnNUU=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3326.eurprd04.prod.outlook.com
 (2603:10a6:803:8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Thu, 10 Dec
 2020 18:06:39 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3632.023; Thu, 10 Dec 2020
 18:06:39 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Daniel Thompson <daniel.thompson@linaro.org>
CC:     "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Thread-Topic: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Thread-Index: AQHWzxpfkmhJ4/PRJUyjg6gvz97H0KnwoDEA
Date:   Thu, 10 Dec 2020 18:06:39 +0000
Message-ID: <20201210180636.nsfwvzs5xxzpqt7n@skbuf>
References: <20200629184712.12449-2-ioana.ciornei () nxp ! com>
 <20201210173156.mbizovo6rxvkda73@holly.lan>
In-Reply-To: <20201210173156.mbizovo6rxvkda73@holly.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10b3ee73-f82f-4c07-d652-08d89d3657a6
x-ms-traffictypediagnostic: VI1PR0402MB3326:
x-microsoft-antispam-prvs: <VI1PR0402MB33264A85036EF2EFA90FD32CE0CB0@VI1PR0402MB3326.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIRuf6UJFUo3yuD1fb9gaPlBIZfoHRrBS9OcYFkvBUVFMIjCP8kB0dQQrwD7iwMqzJn1RNpMyeKFjbanSDwn22hTcktSmDPd95wjxUftyghKz6Mg4g7Qpfg7EtWkhnymZXfJr0H+0ouXqv4kz/o/arqhiTpKVGMbKykKR4DsyGwYx5zxwMcwQjN7HPOq/W2xfzEYguFGFadM2C0vTBu3OOY517wdO5kY0x+adh1rGw1O03fCCWgP1zmjPfzyCRMW6XISO/3ohTHOP6oGNNJhmUHNPlCPTSL/eowVqnsv7g2f0Zw9gA0AUN7htwuwQuvDycmcQ3m4kkEWjaQP5bh9tQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(366004)(39860400002)(346002)(136003)(376002)(316002)(6916009)(26005)(186003)(44832011)(54906003)(86362001)(83380400001)(71200400001)(66446008)(66556008)(66476007)(66946007)(1076003)(64756008)(30864003)(33716001)(5660300002)(76116006)(91956017)(8676002)(8936002)(45080400002)(6486002)(478600001)(9686003)(4326008)(6506007)(6512007)(2906002)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5sh9GGPuSSE2PS2gnoBX9zTMsWY9sBg0G7KDlF/2A3gr7dFMR79VKiVGuDGb?=
 =?us-ascii?Q?5Vm3EBc1KLYMBXiX/tG1BnmvpqOuJ6HcCfNtood5TzeiaA2EvXbBhQ+zhneA?=
 =?us-ascii?Q?NnY61qVqDxCy9f3vP2FRLivBuvy+iPZSv2vqTj+nWCPY1fSuri20ptTXdZR/?=
 =?us-ascii?Q?aA6EWKKadl7YPWDxvFbi6NAdJYBp9v3AHt9ANVJw+3fHf9/qLNCIBKJm46VR?=
 =?us-ascii?Q?fMav/mceIg6oChNrgpaHen6yX3VpjR0HySy++BGkcJZ6+5KSTJ9GI1XvEell?=
 =?us-ascii?Q?MOlsPCExE+ixIvKacnbtMNW8kCkknG8jZAegS/Nzoneu9Q71j6/BLLMiZgeC?=
 =?us-ascii?Q?SNPFJIEl5RrgQbpVk4GWWg87e/4Dwct8a5MVG9TUVUhPOk8GYE8udQRz97sl?=
 =?us-ascii?Q?We8Qch8WNPdoQxppjRR3MF1+SjBFYS9foK08/SNqVT7evpsLMsKDYp7LvhyN?=
 =?us-ascii?Q?CwjfM36P4V6qdm0MMF4x6drbrpZ4V7mwJ2YdSeaAdYVHlAjnXxHRKGE9vTSM?=
 =?us-ascii?Q?8BioAgU5ew8PME/76M3+QeQCi3mB32LSkjIHy2ZrBvR63vZ4s+X11PShDfow?=
 =?us-ascii?Q?wXjCdNOMtz63njfibV2UTqauYXtpEH9UOy0t4Y3BOLwxSHE3N0Da3NXdigpP?=
 =?us-ascii?Q?ZZUSL47xs2/o00qfP2ehPZT5m3i99DrBmLODQKpm1L0WMlnbtRwfGKXdGPIa?=
 =?us-ascii?Q?0F+QAnKpFp8x7JX/eB/TuXtTEnAysFGveOaSWhGNIKYlmEUpK+a5nXgznc32?=
 =?us-ascii?Q?mgrYCj4a8Y8QkObvTRsW2Wb9RYQ0xgBpKMz2r/W5meJupb+PXLz2N1gXBUeo?=
 =?us-ascii?Q?otiwMdIZiUwckdxqG4ybZKxbMZdF/BlIDE1bkZe2saBb61B7FnHMs+LKOESu?=
 =?us-ascii?Q?mPJ5kDoIihb1K9QM7G/Vmkd7gjOh4hGUkHrGummlghdxhOqhqlVk9Be4nINY?=
 =?us-ascii?Q?6e+GWFUeglR6tQ76zxgOMsKsmqhOdHn1qTo4nOiRs6W585qb5JeXCEkl4NIf?=
 =?us-ascii?Q?EMqV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4F5569A9B4553F4FA04EB0856917B0CF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b3ee73-f82f-4c07-d652-08d89d3657a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 18:06:39.6222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BpSrOfP0fXJvPQd4M67W/QaROjeEIeTnl7VXh9/g0IuM03qz6ZjLCa8U7e/O8WL4e1IcFkC327OhwWrg9iggSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Added also the netdev mailing list, I haven't heard of linux-netdev
before but kept it]

On Thu, Dec 10, 2020 at 05:31:56PM +0000, Daniel Thompson wrote:
> Hi Ioana

Hi Daniel,

>=20
> On Mon, Jun 29, 2020 at 06:47:11PM +0000, Ioana Ciornei wrote:
> > Instead of realloc-ing the skb on the Tx path when the provided headroo=
m
> > is smaller than the HW requirements, create a Scatter/Gather frame
> > descriptor with only one entry.
> >=20
> > Remove the '[drv] tx realloc frames' counter exposed previously through
> > ethtool since it is no longer used.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
>=20
> I've been chasing down a networking regression on my LX2160A board
> (Honeycomb LX2K based on CEx7 LX2160A COM) that first appeared in v5.9.
>=20
> It makes the board unreliable opening outbound connections meaning
> things like `apt update` or `git fetch` often can't open the connection.
> It does not happen all the time but is sufficient to make the boards
> built-in networking useless for workstation use.
>=20
> The problem is strongly linked to warnings in the logs so I used the
> warnings to bisect down to locate the cause of the regression and it
> pinpointed this patch. I have confirmed that in both v5.9 and v5.10-rc7
> that reverting this patch (and fixing up the merge issues) fixes the
> regression and the warnings stop appearing.
>=20
> A typical example of the warning is below (io-pgtable-arm.c:281 is an
> error path that I guess would cause dma_map_page_attrs() to return
> an error):
>=20
> [  714.464927] WARNING: CPU: 13 PID: 0 at
> drivers/iommu/io-pgtable-arm.c:281 __arm_lpae_map+0x2d4/0x30c
> [  714.464930] Modules linked in: snd_seq_dummy(E) snd_hrtimer(E)
> snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) bridge(E)
> stp(E) llc(E) rfkill(E) caam_jr(E) crypto_engine(E) rng_core(E)
> joydev(E) evdev(E) dpaa2_caam(E) caamhash_desc(E) caamalg_desc(E)
> authenc(E) libdes(E) dpaa2_console(E) ofpart(E) caam(E) sg(E) error(E)
> lm90(E) at24(E) spi_nor(E) mtd(E) sbsa_gwdt(E) qoriq_thermal(E)
> layerscape_edac_mod(E) qoriq_cpufreq(E) drm(E) fuse(E) configfs(E)
> ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E)
> mbcache(E) jbd2(E) hid_generic(E) usbhid(E) hid(E) dm_crypt(E) dm_mod(E)
> sd_mod(E) fsl_dpaa2_ptp(E) ptp_qoriq(E) fsl_dpaa2_eth(E)
> xhci_plat_hcd(E) xhci_hcd(E) usbcore(E) aes_ce_blk(E) crypto_simd(E)
> cryptd(E) aes_ce_cipher(E) ghash_ce(E) gf128mul(E) at803x(E) libaes(E)
> fsl_mc_dpio(E) pcs_lynx(E) rtc_pcf2127(E) sha2_ce(E) phylink(E)
> xgmac_mdio(E) regmap_spi(E) of_mdio(E) sha256_arm64(E)
> i2c_mux_pca954x(E) fixed_phy(E) i2c_mux(E) sha1_ce(E) ptp(E) libphy(E)
> [  714.465131]  pps_core(E) ahci_qoriq(E) libahci_platform(E) nvme(E)
> libahci(E) nvme_core(E) t10_pi(E) libata(E) crc_t10dif(E)
> crct10dif_generic(E) crct10dif_common(E) dwc3(E) scsi_mod(E) udc_core(E)
> roles(E) ulpi(E) sdhci_of_esdhc(E) sdhci_pltfm(E) sdhci(E)
> spi_nxp_fspi(E) i2c_imx(E) fixed(E)
> [  714.465192] CPU: 13 PID: 0 Comm: swapper/13 Tainted: G        W   E
> 5.10.0-rc7-00001-gba98d13279ca #52
> [  714.465196] Hardware name: SolidRun LX2160A Honeycomb (DT)
> [  714.465202] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
> [  714.465207] pc : __arm_lpae_map+0x2d4/0x30c
> [  714.465211] lr : __arm_lpae_map+0x114/0x30c
> [  714.465215] sp : ffff80001006b340
> [  714.465219] x29: ffff80001006b340 x28: 0000002086538003=20
> [  714.465227] x27: 0000000000000a20 x26: 0000000000001000=20
> [  714.465236] x25: 0000000000000f44 x24: 00000020adf8d000=20
> [  714.465245] x23: 0000000000000001 x22: 0000fffffaeca000=20
> [  714.465253] x21: 0000000000000003 x20: ffff19b60d64d200=20
> [  714.465261] x19: 00000000000000ca x18: 0000000000000000=20
> [  714.465270] x17: 0000000000000000 x16: ffffcccb7cf3ca20=20
> [  714.465278] x15: 0000000000000000 x14: 0000000000000000=20
> [  714.465286] x13: 0000000000000003 x12: 0000000000000010=20
> [  714.465294] x11: 0000000000000000 x10: 0000000000000002=20
> [  714.465302] x9 : ffffcccb7d5b6e78 x8 : 00000000000001ff=20
> [  714.465311] x7 : ffff19b606538650 x6 : ffff19b606538000=20
> [  714.465319] x5 : 0000000000000009 x4 : 0000000000000f44=20
> [  714.465327] x3 : 0000000000001000 x2 : 00000020adf8d000=20
> [  714.465335] x1 : 0000000000000002 x0 : 0000000000000003=20
> [  714.465343] Call trace:
> [  714.465348]  __arm_lpae_map+0x2d4/0x30c
> [  714.465353]  __arm_lpae_map+0x114/0x30c
> [  714.465357]  __arm_lpae_map+0x114/0x30c
> [  714.465362]  __arm_lpae_map+0x114/0x30c
> [  714.465366]  arm_lpae_map+0xf4/0x180
> [  714.465373]  arm_smmu_map+0x4c/0xc0
> [  714.465379]  __iommu_map+0x100/0x2bc
> [  714.465385]  iommu_map_atomic+0x20/0x30
> [  714.465391]  __iommu_dma_map+0xb0/0x110
> [  714.465397]  iommu_dma_map_page+0xb8/0x120
> [  714.465404]  dma_map_page_attrs+0x1a8/0x210
> [  714.465413]  __dpaa2_eth_tx+0x384/0xbd0 [fsl_dpaa2_eth]
> [  714.465421]  dpaa2_eth_tx+0x84/0x134 [fsl_dpaa2_eth]
> [  714.465427]  dev_hard_start_xmit+0x10c/0x2b0
> [  714.465433]  sch_direct_xmit+0x1a0/0x550
> [  714.465438]  __qdisc_run+0x140/0x670
> [  714.465443]  __dev_queue_xmit+0x6c4/0xa74
> [  714.465449]  dev_queue_xmit+0x20/0x2c
> [  714.465463]  br_dev_queue_push_xmit+0xc4/0x1a0 [bridge]
> [  714.465476]  br_forward_finish+0xdc/0xf0 [bridge]
> [  714.465489]  __br_forward+0x160/0x1c0 [bridge]
> [  714.465502]  br_forward+0x13c/0x160 [bridge]
> [  714.465514]  br_dev_xmit+0x228/0x3b0 [bridge]
> [  714.465520]  dev_hard_start_xmit+0x10c/0x2b0
> [  714.465526]  __dev_queue_xmit+0x8f0/0xa74
> [  714.465531]  dev_queue_xmit+0x20/0x2c
> [  714.465538]  arp_xmit+0xc0/0xd0
> [  714.465544]  arp_send_dst+0x78/0xa0
> [  714.465550]  arp_solicit+0xf4/0x260
> [  714.465554]  neigh_probe+0x64/0xb0
> [  714.465560]  neigh_timer_handler+0x2f4/0x400
> [  714.465566]  call_timer_fn+0x3c/0x184
> [  714.465572]  __run_timers.part.0+0x2bc/0x370
> [  714.465578]  run_timer_softirq+0x48/0x80
> [  714.465583]  __do_softirq+0x120/0x36c
> [  714.465589]  irq_exit+0xac/0x100
> [  714.465596]  __handle_domain_irq+0x8c/0xf0
> [  714.465600]  gic_handle_irq+0xcc/0x14c
> [  714.465605]  el1_irq+0xc4/0x180
> [  714.465610]  arch_cpu_idle+0x18/0x30
> [  714.465617]  default_idle_call+0x4c/0x180
> [  714.465623]  do_idle+0x238/0x2b0
> [  714.465629]  cpu_startup_entry+0x30/0xa0
> [  714.465636]  secondary_start_kernel+0x134/0x180
> [  714.465640] ---[ end trace a84a7f61b559005f ]---
>=20
>=20
> Given it is the iommu code that is provoking the warning I should
> probably mention that the board I have requires
> arm-smmu.disable_bypass=3D0 on the kernel command line in order to boot.
> Also if it matters I am running the latest firmware from Solidrun
> which is based on LSDK-20.04.
>=20

Hmmm, from what I remember I think I tested this with the smmu bypassed
so that is why I didn't catch it.

> Is there any reason for this code not to be working for LX2160A?

I wouldn't expect this to be LX2160A specific but rather a bug in the
implementation.. sorry.

Let me reproduce it and see if I can get to the bottom of it and I will
get back with some more info.

Ioana

>=20
> Daniel.
>=20
>=20
> PS A few months have gone by so I decided not to trim the patch out
>    of this reply so you don't have to go digging!
>=20
>=20
>=20
> >  .../freescale/dpaa2/dpaa2-eth-debugfs.c       |   7 +-
> >  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 177 +++++++++++++++---
> >  .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   9 +-
> >  .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |   1 -
> >  4 files changed, 160 insertions(+), 34 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b=
/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> > index 2880ca02d7e7..5cb357c74dec 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
> > @@ -19,14 +19,14 @@ static int dpaa2_dbg_cpu_show(struct seq_file *file=
, void *offset)
> >  	int i;
> > =20
> >  	seq_printf(file, "Per-CPU stats for %s\n", priv->net_dev->name);
> > -	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s%16s%16s%16s\n",
> > +	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s%16s%16s\n",
> >  		   "CPU", "Rx", "Rx Err", "Rx SG", "Tx", "Tx Err", "Tx conf",
> > -		   "Tx SG", "Tx realloc", "Enq busy");
> > +		   "Tx SG", "Enq busy");
> > =20
> >  	for_each_online_cpu(i) {
> >  		stats =3D per_cpu_ptr(priv->percpu_stats, i);
> >  		extras =3D per_cpu_ptr(priv->percpu_extras, i);
> > -		seq_printf(file, "%3d%16llu%16llu%16llu%16llu%16llu%16llu%16llu%16ll=
u%16llu\n",
> > +		seq_printf(file, "%3d%16llu%16llu%16llu%16llu%16llu%16llu%16llu%16ll=
u\n",
> >  			   i,
> >  			   stats->rx_packets,
> >  			   stats->rx_errors,
> > @@ -35,7 +35,6 @@ static int dpaa2_dbg_cpu_show(struct seq_file *file, =
void *offset)
> >  			   stats->tx_errors,
> >  			   extras->tx_conf_frames,
> >  			   extras->tx_sg_frames,
> > -			   extras->tx_reallocs,
> >  			   extras->tx_portal_busy);
> >  	}
> > =20
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers=
/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index 712bbfdbe7d7..4a264b75c035 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -685,6 +685,86 @@ static int build_sg_fd(struct dpaa2_eth_priv *priv=
,
> >  	return err;
> >  }
> > =20
> > +/* Create a SG frame descriptor based on a linear skb.
> > + *
> > + * This function is used on the Tx path when the skb headroom is not l=
arge
> > + * enough for the HW requirements, thus instead of realloc-ing the skb=
 we
> > + * create a SG frame descriptor with only one entry.
> > + */
> > +static int build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
> > +				  struct sk_buff *skb,
> > +				  struct dpaa2_fd *fd)
> > +{
> > +	struct device *dev =3D priv->net_dev->dev.parent;
> > +	struct dpaa2_eth_sgt_cache *sgt_cache;
> > +	struct dpaa2_sg_entry *sgt;
> > +	struct dpaa2_eth_swa *swa;
> > +	dma_addr_t addr, sgt_addr;
> > +	void *sgt_buf =3D NULL;
> > +	int sgt_buf_size;
> > +	int err;
> > +
> > +	/* Prepare the HW SGT structure */
> > +	sgt_cache =3D this_cpu_ptr(priv->sgt_cache);
> > +	sgt_buf_size =3D priv->tx_data_offset + sizeof(struct dpaa2_sg_entry)=
;
> > +
> > +	if (sgt_cache->count =3D=3D 0)
> > +		sgt_buf =3D kzalloc(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN,
> > +				  GFP_ATOMIC);
> > +	else
> > +		sgt_buf =3D sgt_cache->buf[--sgt_cache->count];
> > +	if (unlikely(!sgt_buf))
> > +		return -ENOMEM;
> > +
> > +	sgt_buf =3D PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);
> > +	sgt =3D (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
> > +
> > +	addr =3D dma_map_single(dev, skb->data, skb->len, DMA_BIDIRECTIONAL);
> > +	if (unlikely(dma_mapping_error(dev, addr))) {
> > +		err =3D -ENOMEM;
> > +		goto data_map_failed;
> > +	}
> > +
> > +	/* Fill in the HW SGT structure */
> > +	dpaa2_sg_set_addr(sgt, addr);
> > +	dpaa2_sg_set_len(sgt, skb->len);
> > +	dpaa2_sg_set_final(sgt, true);
> > +
> > +	/* Store the skb backpointer in the SGT buffer */
> > +	swa =3D (struct dpaa2_eth_swa *)sgt_buf;
> > +	swa->type =3D DPAA2_ETH_SWA_SINGLE;
> > +	swa->single.skb =3D skb;
> > +	swa->sg.sgt_size =3D sgt_buf_size;
> > +
> > +	/* Separately map the SGT buffer */
> > +	sgt_addr =3D dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTI=
ONAL);
> > +	if (unlikely(dma_mapping_error(dev, sgt_addr))) {
> > +		err =3D -ENOMEM;
> > +		goto sgt_map_failed;
> > +	}
> > +
> > +	dpaa2_fd_set_offset(fd, priv->tx_data_offset);
> > +	dpaa2_fd_set_format(fd, dpaa2_fd_sg);
> > +	dpaa2_fd_set_addr(fd, sgt_addr);
> > +	dpaa2_fd_set_len(fd, skb->len);
> > +	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
> > +
> > +	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
> > +		enable_tx_tstamp(fd, sgt_buf);
> > +
> > +	return 0;
> > +
> > +sgt_map_failed:
> > +	dma_unmap_single(dev, addr, skb->len, DMA_BIDIRECTIONAL);
> > +data_map_failed:
> > +	if (sgt_cache->count >=3D DPAA2_ETH_SGT_CACHE_SIZE)
> > +		kfree(sgt_buf);
> > +	else
> > +		sgt_cache->buf[sgt_cache->count++] =3D sgt_buf;
> > +
> > +	return err;
> > +}
> > +
> >  /* Create a frame descriptor based on a linear skb */
> >  static int build_single_fd(struct dpaa2_eth_priv *priv,
> >  			   struct sk_buff *skb,
> > @@ -743,13 +823,16 @@ static void free_tx_fd(const struct dpaa2_eth_pri=
v *priv,
> >  		       const struct dpaa2_fd *fd, bool in_napi)
> >  {
> >  	struct device *dev =3D priv->net_dev->dev.parent;
> > -	dma_addr_t fd_addr;
> > +	dma_addr_t fd_addr, sg_addr;
> >  	struct sk_buff *skb =3D NULL;
> >  	unsigned char *buffer_start;
> >  	struct dpaa2_eth_swa *swa;
> >  	u8 fd_format =3D dpaa2_fd_get_format(fd);
> >  	u32 fd_len =3D dpaa2_fd_get_len(fd);
> > =20
> > +	struct dpaa2_eth_sgt_cache *sgt_cache;
> > +	struct dpaa2_sg_entry *sgt;
> > +
> >  	fd_addr =3D dpaa2_fd_get_addr(fd);
> >  	buffer_start =3D dpaa2_iova_to_virt(priv->iommu_domain, fd_addr);
> >  	swa =3D (struct dpaa2_eth_swa *)buffer_start;
> > @@ -769,16 +852,29 @@ static void free_tx_fd(const struct dpaa2_eth_pri=
v *priv,
> >  					 DMA_BIDIRECTIONAL);
> >  		}
> >  	} else if (fd_format =3D=3D dpaa2_fd_sg) {
> > -		skb =3D swa->sg.skb;
> > +		if (swa->type =3D=3D DPAA2_ETH_SWA_SG) {
> > +			skb =3D swa->sg.skb;
> > +
> > +			/* Unmap the scatterlist */
> > +			dma_unmap_sg(dev, swa->sg.scl, swa->sg.num_sg,
> > +				     DMA_BIDIRECTIONAL);
> > +			kfree(swa->sg.scl);
> > =20
> > -		/* Unmap the scatterlist */
> > -		dma_unmap_sg(dev, swa->sg.scl, swa->sg.num_sg,
> > -			     DMA_BIDIRECTIONAL);
> > -		kfree(swa->sg.scl);
> > +			/* Unmap the SGT buffer */
> > +			dma_unmap_single(dev, fd_addr, swa->sg.sgt_size,
> > +					 DMA_BIDIRECTIONAL);
> > +		} else {
> > +			skb =3D swa->single.skb;
> > =20
> > -		/* Unmap the SGT buffer */
> > -		dma_unmap_single(dev, fd_addr, swa->sg.sgt_size,
> > -				 DMA_BIDIRECTIONAL);
> > +			/* Unmap the SGT Buffer */
> > +			dma_unmap_single(dev, fd_addr, swa->single.sgt_size,
> > +					 DMA_BIDIRECTIONAL);
> > +
> > +			sgt =3D (struct dpaa2_sg_entry *)(buffer_start +
> > +							priv->tx_data_offset);
> > +			sg_addr =3D dpaa2_sg_get_addr(sgt);
> > +			dma_unmap_single(dev, sg_addr, skb->len, DMA_BIDIRECTIONAL);
> > +		}
> >  	} else {
> >  		netdev_dbg(priv->net_dev, "Invalid FD format\n");
> >  		return;
> > @@ -808,8 +904,17 @@ static void free_tx_fd(const struct dpaa2_eth_priv=
 *priv,
> >  	}
> > =20
> >  	/* Free SGT buffer allocated on tx */
> > -	if (fd_format !=3D dpaa2_fd_single)
> > -		skb_free_frag(buffer_start);
> > +	if (fd_format !=3D dpaa2_fd_single) {
> > +		sgt_cache =3D this_cpu_ptr(priv->sgt_cache);
> > +		if (swa->type =3D=3D DPAA2_ETH_SWA_SG) {
> > +			skb_free_frag(buffer_start);
> > +		} else {
> > +			if (sgt_cache->count >=3D DPAA2_ETH_SGT_CACHE_SIZE)
> > +				kfree(buffer_start);
> > +			else
> > +				sgt_cache->buf[sgt_cache->count++] =3D buffer_start;
> > +		}
> > +	}
> > =20
> >  	/* Move on with skb release */
> >  	napi_consume_skb(skb, in_napi);
> > @@ -833,22 +938,6 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *sk=
b, struct net_device *net_dev)
> >  	percpu_extras =3D this_cpu_ptr(priv->percpu_extras);
> > =20
> >  	needed_headroom =3D dpaa2_eth_needed_headroom(priv, skb);
> > -	if (skb_headroom(skb) < needed_headroom) {
> > -		struct sk_buff *ns;
> > -
> > -		ns =3D skb_realloc_headroom(skb, needed_headroom);
> > -		if (unlikely(!ns)) {
> > -			percpu_stats->tx_dropped++;
> > -			goto err_alloc_headroom;
> > -		}
> > -		percpu_extras->tx_reallocs++;
> > -
> > -		if (skb->sk)
> > -			skb_set_owner_w(ns, skb->sk);
> > -
> > -		dev_kfree_skb(skb);
> > -		skb =3D ns;
> > -	}
> > =20
> >  	/* We'll be holding a back-reference to the skb until Tx Confirmation=
;
> >  	 * we don't want that overwritten by a concurrent Tx with a cloned sk=
b.
> > @@ -867,6 +956,10 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *sk=
b, struct net_device *net_dev)
> >  		err =3D build_sg_fd(priv, skb, &fd);
> >  		percpu_extras->tx_sg_frames++;
> >  		percpu_extras->tx_sg_bytes +=3D skb->len;
> > +	} else if (skb_headroom(skb) < needed_headroom) {
> > +		err =3D build_sg_fd_single_buf(priv, skb, &fd);
> > +		percpu_extras->tx_sg_frames++;
> > +		percpu_extras->tx_sg_bytes +=3D skb->len;
> >  	} else {
> >  		err =3D build_single_fd(priv, skb, &fd);
> >  	}
> > @@ -924,7 +1017,6 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *sk=
b, struct net_device *net_dev)
> >  	return NETDEV_TX_OK;
> > =20
> >  err_build_fd:
> > -err_alloc_headroom:
> >  	dev_kfree_skb(skb);
> > =20
> >  	return NETDEV_TX_OK;
> > @@ -1161,6 +1253,22 @@ static int refill_pool(struct dpaa2_eth_priv *pr=
iv,
> >  	return 0;
> >  }
> > =20
> > +static void dpaa2_eth_sgt_cache_drain(struct dpaa2_eth_priv *priv)
> > +{
> > +	struct dpaa2_eth_sgt_cache *sgt_cache;
> > +	u16 count;
> > +	int k, i;
> > +
> > +	for_each_online_cpu(k) {
> > +		sgt_cache =3D per_cpu_ptr(priv->sgt_cache, k);
> > +		count =3D sgt_cache->count;
> > +
> > +		for (i =3D 0; i < count; i++)
> > +			kfree(sgt_cache->buf[i]);
> > +		sgt_cache->count =3D 0;
> > +	}
> > +}
> > +
> >  static int pull_channel(struct dpaa2_eth_channel *ch)
> >  {
> >  	int err;
> > @@ -1562,6 +1670,9 @@ static int dpaa2_eth_stop(struct net_device *net_=
dev)
> >  	/* Empty the buffer pool */
> >  	drain_pool(priv);
> > =20
> > +	/* Empty the Scatter-Gather Buffer cache */
> > +	dpaa2_eth_sgt_cache_drain(priv);
> > +
> >  	return 0;
> >  }
> > =20
> > @@ -3846,6 +3957,13 @@ static int dpaa2_eth_probe(struct fsl_mc_device =
*dpni_dev)
> >  		goto err_alloc_percpu_extras;
> >  	}
> > =20
> > +	priv->sgt_cache =3D alloc_percpu(*priv->sgt_cache);
> > +	if (!priv->sgt_cache) {
> > +		dev_err(dev, "alloc_percpu(sgt_cache) failed\n");
> > +		err =3D -ENOMEM;
> > +		goto err_alloc_sgt_cache;
> > +	}
> > +
> >  	err =3D netdev_init(net_dev);
> >  	if (err)
> >  		goto err_netdev_init;
> > @@ -3914,6 +4032,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *=
dpni_dev)
> >  err_alloc_rings:
> >  err_csum:
> >  err_netdev_init:
> > +	free_percpu(priv->sgt_cache);
> > +err_alloc_sgt_cache:
> >  	free_percpu(priv->percpu_extras);
> >  err_alloc_percpu_extras:
> >  	free_percpu(priv->percpu_stats);
> > @@ -3959,6 +4079,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device =
*ls_dev)
> >  		fsl_mc_free_irqs(ls_dev);
> > =20
> >  	free_rings(priv);
> > +	free_percpu(priv->sgt_cache);
> >  	free_percpu(priv->percpu_stats);
> >  	free_percpu(priv->percpu_extras);
> > =20
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers=
/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> > index 2d7ada0f0dbd..9e4ceb92f240 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> > @@ -125,6 +125,7 @@ struct dpaa2_eth_swa {
> >  	union {
> >  		struct {
> >  			struct sk_buff *skb;
> > +			int sgt_size;
> >  		} single;
> >  		struct {
> >  			struct sk_buff *skb;
> > @@ -282,7 +283,6 @@ struct dpaa2_eth_drv_stats {
> >  	__u64	tx_conf_bytes;
> >  	__u64	tx_sg_frames;
> >  	__u64	tx_sg_bytes;
> > -	__u64	tx_reallocs;
> >  	__u64	rx_sg_frames;
> >  	__u64	rx_sg_bytes;
> >  	/* Enqueues retried due to portal busy */
> > @@ -395,6 +395,12 @@ struct dpaa2_eth_cls_rule {
> >  	u8 in_use;
> >  };
> > =20
> > +#define DPAA2_ETH_SGT_CACHE_SIZE	256
> > +struct dpaa2_eth_sgt_cache {
> > +	void *buf[DPAA2_ETH_SGT_CACHE_SIZE];
> > +	u16 count;
> > +};
> > +
> >  /* Driver private data */
> >  struct dpaa2_eth_priv {
> >  	struct net_device *net_dev;
> > @@ -409,6 +415,7 @@ struct dpaa2_eth_priv {
> > =20
> >  	u8 num_channels;
> >  	struct dpaa2_eth_channel *channel[DPAA2_ETH_MAX_DPCONS];
> > +	struct dpaa2_eth_sgt_cache __percpu *sgt_cache;
> > =20
> >  	struct dpni_attr dpni_attrs;
> >  	u16 dpni_ver_major;
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/dri=
vers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > index e88269fe3de7..c4cbbcaa9a3f 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
> > @@ -43,7 +43,6 @@ static char dpaa2_ethtool_extras[][ETH_GSTRING_LEN] =
=3D {
> >  	"[drv] tx conf bytes",
> >  	"[drv] tx sg frames",
> >  	"[drv] tx sg bytes",
> > -	"[drv] tx realloc frames",
> >  	"[drv] rx sg frames",
> >  	"[drv] rx sg bytes",
> >  	"[drv] enqueue portal busy",
> > --=20
> > 2.25.1=
