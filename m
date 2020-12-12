Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BD22D89C2
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407804AbgLLTfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:35:22 -0500
Received: from mail-eopbgr10051.outbound.protection.outlook.com ([40.107.1.51]:9846
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2501941AbgLLTfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:35:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jI6dITAglbXyapJqFcy+/y3NAKeOg0mOu1OqFnq9Yy5OvkKDzaWskGzs6x+vvdSb3n0A1aLjm/ndurju87QbQTqMgHzBwUpiFmgwxg6AZsXqvtYGw4uSbRiLS2g1TWxl+y6U1FDwN9EXNyNZOxwlLfi2DWct20kziS2L+YGQACye57ECwfFDpMyixmOMyrhf52ZH713nXbX5mHXQWVSjEFM1wYNmDaxSiLpkFfLtsWbp3D7nchg9j3thMWWSQEzoczyKv/AKPxnFpsiz/i6LfZDb+CqC7sL2Gn3HunerrqRZsIspgaY2IvezSR29Z47nlKxcDkw+hXVgA/4ijjX0FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeHSBjJZmhTos4gHam9ixcpL1A31BGPRV2AhNLQhW/8=;
 b=TeKHYh66MuUf58vB5LZiTeBRH/MZxdHmjvE8WbDWxjhL7viVy5ZhwOrt9ZI82c1QqBrwPoKnK0QU2/irniDSGVdyDpMAR/B6skKxFmvUek6UXVjO0aaQtc6MndcOKJS4Yw+z+7h5yBMV1shB7Tnpo3DGdv2uG4JX7SVYMA+reV0PxjacRV+QvcwsNynRUD7IEME30RdwIStrwK42CiMQYO86eUGSL3/RwT0ip0LUDkZy5mOxeWbpzf+5wlDaO9p9G2owZ93dKaJvRW+2W1mU8aAz5s0G7i/IJrcijG2zI1qeU8jKFSK6d4+P5eVBDoqJdITR4DyjUlMgtUlo7oo1WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeHSBjJZmhTos4gHam9ixcpL1A31BGPRV2AhNLQhW/8=;
 b=dqqQMQUvYCgs/63kbdwGhgGGVSBIFXHy+Eb17JiBoJxruqGzor3OV2edEoqN9puD7EikJ7Wsnl/1PZhtiqx0UaDdY/R/Aip1JUsFrnvBlN1nbcrFFOZgzEdS8gnKtFI+NMEvfp4sOeZHdUTFvxg8AyDUZu3DFOW+q6qsuKZOuY4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0401MB2415.eurprd04.prod.outlook.com
 (2603:10a6:800:2b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Sat, 12 Dec
 2020 19:31:36 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f%6]) with mapi id 15.20.3654.021; Sat, 12 Dec 2020
 19:31:36 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jon Nettleton <jon@solid-run.com>
CC:     Daniel Thompson <daniel.thompson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Thread-Topic: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Thread-Index: AQHWzxpfkmhJ4/PRJUyjg6gvz97H0KnwoDEAgAFN1QCAAClLAIAABxQAgAGCygCAADtqgA==
Date:   Sat, 12 Dec 2020 19:31:35 +0000
Message-ID: <20201212193135.a7772drfln7kevon@skbuf>
References: <20201210173156.mbizovo6rxvkda73@holly.lan>
 <20201210180636.nsfwvzs5xxzpqt7n@skbuf>
 <20201211140126.25x4z2x6upctyin5@skbuf>
 <20201211162914.pa3eua4nerviysyy@holly.lan>
 <20201211165434.6qdk6hswmryhn7z6@skbuf>
 <CABdtJHvyWSaJw1F0c9J8XbdJsxrkP9d++D0btseaO0eRRNJcyg@mail.gmail.com>
In-Reply-To: <CABdtJHvyWSaJw1F0c9J8XbdJsxrkP9d++D0btseaO0eRRNJcyg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: solid-run.com; dkim=none (message not signed)
 header.d=none;solid-run.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7821a60f-593e-46de-d930-08d89ed48a1f
x-ms-traffictypediagnostic: VI1PR0401MB2415:
x-microsoft-antispam-prvs: <VI1PR0401MB2415767F534C76B97FE4D2AFE0C90@VI1PR0401MB2415.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IYFkDc3kyqcwMmxXQmOIBymSyJ2hQut3AoAh8pCtL2OeqCEPLVtIcdSGkaX9b2R5HpS2FuGUqTCIolV9c2FDkG/hIEH5XRFgk1O3G6O/fnsHAHCY5lVRqyX9OerFUrRQpCI/KuGgCUqW/A6SpEL8m2HwVnvt+ZRzZiUE5mS7yxtEpcefz8R1e9mW/K3C/CKQMY/z0I/FKI37AUE+KOq4TDSQDl9h9sKpTekHHF4HRxa0euPiF3LVsOKitHORS46pF6Q2lN5233cAP9FSAbcAri9oL7JhyiYZ1HUDhzax4ZUhRqF7pzu6YWGu2GibCALGphpc8pU6x+5sshfxDnbzUT/6zRitqpBZTlrx8GYeMyPcWPFDctj3BRMswSkUjYJk06OY0nB1QuwpLBrIfYbY/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(136003)(346002)(396003)(39860400002)(54906003)(4326008)(53546011)(6506007)(83380400001)(478600001)(26005)(66556008)(45080400002)(5660300002)(66476007)(8676002)(2906002)(86362001)(64756008)(33716001)(316002)(1076003)(186003)(66446008)(8936002)(6512007)(66946007)(44832011)(9686003)(6486002)(6916009)(966005)(71200400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?q+fkHHAc7gx958TJcv1a3dJsJDVAWQ8Kz4G9KFX90Kdlw6icB31woyfCF6YE?=
 =?us-ascii?Q?4oiX2OUufKjpWxTbuDfp9K9guUU/SqVNXpZUbA4F//+FPcH/BjOcnJHJSgvS?=
 =?us-ascii?Q?bhBo9w7QWZekdenp70nCl7dOh6S439L2zCpRktlIlSlAJZnBCqdFkH7KP5+p?=
 =?us-ascii?Q?z6KTzqJiNNvIteuBGRfGfsLND7erEtYq+h1yLQOSJNpLI7BjhjaYIm2l2m3c?=
 =?us-ascii?Q?HggjUB7Ajw7qboTV060PPuJEy0E42qNlhUboR3AzN0Knz8MQPnE19AmPniAG?=
 =?us-ascii?Q?6Lp/19r145yn2enMxsncA7xidZagJbjXwaglyrMsgA++iVgufRiMpy7sXTzg?=
 =?us-ascii?Q?186b0LculLIprAvhicFxFlW10p3Ai0sPBKehH034vjAKfxDw1vhJmE4V2KS4?=
 =?us-ascii?Q?AT4JM++jXnQP6IWQ9e4MXorYhJ+5kLvDE0x1FLFygoEWCUq691ixd9k2zzW9?=
 =?us-ascii?Q?PUF6Xe7j3GVcjj77JqLnOia1mmAd2VSqRaD81IgJbm2TG+R9FrL9cb6eqth8?=
 =?us-ascii?Q?fOxNyev/HdLurX4+kotFPgAwmYvNnOukoz05aBT3c3G5+x5KhhIuCbV0EcSb?=
 =?us-ascii?Q?aZBNF7rs3e4++mvOCui+QeCO5ObnLVSKUACTYkbeCg2cT6hw2pmTWQJlfi3g?=
 =?us-ascii?Q?X7RWlOySntoVxbK9zwbmxvosSYOUkV10q2ri6AnUPgHkLEZsyQc/ULS+8n6G?=
 =?us-ascii?Q?rfZ0vubk4FCi4udc66Qai/R9nSMg4qTEt+EZG2iJjnT5+IuIFO3MTD88qpGF?=
 =?us-ascii?Q?j1sNljeuYN5zj2ETbDQvhtcBvuCMCc3piWl2FXlQBAMdLkADjBjpNyrHxT7z?=
 =?us-ascii?Q?JO3vupfcZjTdh3uxkU0ZqhaADah4V7fZhjG2YIHo6nEOFShinpU33VBlICso?=
 =?us-ascii?Q?U5lnDaYhY5OWBE7gFUxRzc78ymw/57e9t9L8EtxN/QUw1XlutqpCzqbLKUkN?=
 =?us-ascii?Q?c3xquwW0Rrflu1uX1lEnQYx1yUjUMeMkBtYMqWSLps4VD8uYTFE4FAKn6CmT?=
 =?us-ascii?Q?rxgo?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D8F0B6867FBB4448A50E54663C4601DE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7821a60f-593e-46de-d930-08d89ed48a1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2020 19:31:35.8814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qd4M+uIXWlrMMTkdiGGCHVIK5Lgam7sX5qcOsB0IhIQWHxDviaoIcH1ZCLc7crLt+J/dbUoJXQzoKdJmJvpNrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2415
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 04:58:56PM +0100, Jon Nettleton wrote:
> On Fri, Dec 11, 2020 at 5:56 PM Ioana Ciornei <ioana.ciornei@nxp.com> wro=
te:
> >
> > On Fri, Dec 11, 2020 at 04:29:14PM +0000, Daniel Thompson wrote:
> > > On Fri, Dec 11, 2020 at 02:01:28PM +0000, Ioana Ciornei wrote:
> > > > On Thu, Dec 10, 2020 at 08:06:36PM +0200, Ioana Ciornei wrote:
> > > > > [Added also the netdev mailing list, I haven't heard of linux-net=
dev
> > > > > before but kept it]
> > > > >
> > > > > On Thu, Dec 10, 2020 at 05:31:56PM +0000, Daniel Thompson wrote:
> > > > > > Hi Ioana
> > > > >
> > > > > Hi Daniel,
> > > > >
> > > > > >
> > > > > > On Mon, Jun 29, 2020 at 06:47:11PM +0000, Ioana Ciornei wrote:
> > > > > > > Instead of realloc-ing the skb on the Tx path when the provid=
ed headroom
> > > > > > > is smaller than the HW requirements, create a Scatter/Gather =
frame
> > > > > > > descriptor with only one entry.
> > > > > > >
> > > > > > > Remove the '[drv] tx realloc frames' counter exposed previous=
ly through
> > > > > > > ethtool since it is no longer used.
> > > > > > >
> > > > > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > > > > ---
> > > > > >
> > > > > > I've been chasing down a networking regression on my LX2160A bo=
ard
> > > > > > (Honeycomb LX2K based on CEx7 LX2160A COM) that first appeared =
in v5.9.
> > > > > >
> > > > > > It makes the board unreliable opening outbound connections mean=
ing
> > > > > > things like `apt update` or `git fetch` often can't open the co=
nnection.
> > > > > > It does not happen all the time but is sufficient to make the b=
oards
> > > > > > built-in networking useless for workstation use.
> > > > > >
> > > > > > The problem is strongly linked to warnings in the logs so I use=
d the
> > > > > > warnings to bisect down to locate the cause of the regression a=
nd it
> > > > > > pinpointed this patch. I have confirmed that in both v5.9 and v=
5.10-rc7
> > > > > > that reverting this patch (and fixing up the merge issues) fixe=
s the
> > > > > > regression and the warnings stop appearing.
> > > > > >
> > > > > > A typical example of the warning is below (io-pgtable-arm.c:281=
 is an
> > > > > > error path that I guess would cause dma_map_page_attrs() to ret=
urn
> > > > > > an error):
> > > > > >
> > > > > > [  714.464927] WARNING: CPU: 13 PID: 0 at
> > > > > > drivers/iommu/io-pgtable-arm.c:281 __arm_lpae_map+0x2d4/0x30c
> > > > > > [  714.464930] Modules linked in: snd_seq_dummy(E) snd_hrtimer(=
E)
> > > > > > snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) b=
ridge(E)
> > > > > > stp(E) llc(E) rfkill(E) caam_jr(E) crypto_engine(E) rng_core(E)
> > > > > > joydev(E) evdev(E) dpaa2_caam(E) caamhash_desc(E) caamalg_desc(=
E)
> > > > > > authenc(E) libdes(E) dpaa2_console(E) ofpart(E) caam(E) sg(E) e=
rror(E)
> > > > > > lm90(E) at24(E) spi_nor(E) mtd(E) sbsa_gwdt(E) qoriq_thermal(E)
> > > > > > layerscape_edac_mod(E) qoriq_cpufreq(E) drm(E) fuse(E) configfs=
(E)
> > > > > > ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) c=
rc16(E)
> > > > > > mbcache(E) jbd2(E) hid_generic(E) usbhid(E) hid(E) dm_crypt(E) =
dm_mod(E)
> > > > > > sd_mod(E) fsl_dpaa2_ptp(E) ptp_qoriq(E) fsl_dpaa2_eth(E)
> > > > > > xhci_plat_hcd(E) xhci_hcd(E) usbcore(E) aes_ce_blk(E) crypto_si=
md(E)
> > > > > > cryptd(E) aes_ce_cipher(E) ghash_ce(E) gf128mul(E) at803x(E) li=
baes(E)
> > > > > > fsl_mc_dpio(E) pcs_lynx(E) rtc_pcf2127(E) sha2_ce(E) phylink(E)
> > > > > > xgmac_mdio(E) regmap_spi(E) of_mdio(E) sha256_arm64(E)
> > > > > > i2c_mux_pca954x(E) fixed_phy(E) i2c_mux(E) sha1_ce(E) ptp(E) li=
bphy(E)
> > > > > > [  714.465131]  pps_core(E) ahci_qoriq(E) libahci_platform(E) n=
vme(E)
> > > > > > libahci(E) nvme_core(E) t10_pi(E) libata(E) crc_t10dif(E)
> > > > > > crct10dif_generic(E) crct10dif_common(E) dwc3(E) scsi_mod(E) ud=
c_core(E)
> > > > > > roles(E) ulpi(E) sdhci_of_esdhc(E) sdhci_pltfm(E) sdhci(E)
> > > > > > spi_nxp_fspi(E) i2c_imx(E) fixed(E)
> > > > > > [  714.465192] CPU: 13 PID: 0 Comm: swapper/13 Tainted: G      =
  W   E
> > > > > > 5.10.0-rc7-00001-gba98d13279ca #52
> > > > > > [  714.465196] Hardware name: SolidRun LX2160A Honeycomb (DT)
> > > > > > [  714.465202] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=
=3D--)
> > > > > > [  714.465207] pc : __arm_lpae_map+0x2d4/0x30c
> > > > > > [  714.465211] lr : __arm_lpae_map+0x114/0x30c
> > > > > > [  714.465215] sp : ffff80001006b340
> > > > > > [  714.465219] x29: ffff80001006b340 x28: 0000002086538003
> > > > > > [  714.465227] x27: 0000000000000a20 x26: 0000000000001000
> > > > > > [  714.465236] x25: 0000000000000f44 x24: 00000020adf8d000
> > > > > > [  714.465245] x23: 0000000000000001 x22: 0000fffffaeca000
> > > > > > [  714.465253] x21: 0000000000000003 x20: ffff19b60d64d200
> > > > > > [  714.465261] x19: 00000000000000ca x18: 0000000000000000
> > > > > > [  714.465270] x17: 0000000000000000 x16: ffffcccb7cf3ca20
> > > > > > [  714.465278] x15: 0000000000000000 x14: 0000000000000000
> > > > > > [  714.465286] x13: 0000000000000003 x12: 0000000000000010
> > > > > > [  714.465294] x11: 0000000000000000 x10: 0000000000000002
> > > > > > [  714.465302] x9 : ffffcccb7d5b6e78 x8 : 00000000000001ff
> > > > > > [  714.465311] x7 : ffff19b606538650 x6 : ffff19b606538000
> > > > > > [  714.465319] x5 : 0000000000000009 x4 : 0000000000000f44
> > > > > > [  714.465327] x3 : 0000000000001000 x2 : 00000020adf8d000
> > > > > > [  714.465335] x1 : 0000000000000002 x0 : 0000000000000003
> > > > > > [  714.465343] Call trace:
> > > > > > [  714.465348]  __arm_lpae_map+0x2d4/0x30c
> > > > > > [  714.465353]  __arm_lpae_map+0x114/0x30c
> > > > > > [  714.465357]  __arm_lpae_map+0x114/0x30c
> > > > > > [  714.465362]  __arm_lpae_map+0x114/0x30c
> > > > > > [  714.465366]  arm_lpae_map+0xf4/0x180
> > > > > > [  714.465373]  arm_smmu_map+0x4c/0xc0
> > > > > > [  714.465379]  __iommu_map+0x100/0x2bc
> > > > > > [  714.465385]  iommu_map_atomic+0x20/0x30
> > > > > > [  714.465391]  __iommu_dma_map+0xb0/0x110
> > > > > > [  714.465397]  iommu_dma_map_page+0xb8/0x120
> > > > > > [  714.465404]  dma_map_page_attrs+0x1a8/0x210
> > > > > > [  714.465413]  __dpaa2_eth_tx+0x384/0xbd0 [fsl_dpaa2_eth]
> > > > > > [  714.465421]  dpaa2_eth_tx+0x84/0x134 [fsl_dpaa2_eth]
> > > > > > [  714.465427]  dev_hard_start_xmit+0x10c/0x2b0
> > > > > > [  714.465433]  sch_direct_xmit+0x1a0/0x550
> > > > > > [  714.465438]  __qdisc_run+0x140/0x670
> > > > > > [  714.465443]  __dev_queue_xmit+0x6c4/0xa74
> > > > > > [  714.465449]  dev_queue_xmit+0x20/0x2c
> > > > > > [  714.465463]  br_dev_queue_push_xmit+0xc4/0x1a0 [bridge]
> > > > > > [  714.465476]  br_forward_finish+0xdc/0xf0 [bridge]
> > > > > > [  714.465489]  __br_forward+0x160/0x1c0 [bridge]
> > > > > > [  714.465502]  br_forward+0x13c/0x160 [bridge]
> > > > > > [  714.465514]  br_dev_xmit+0x228/0x3b0 [bridge]
> > > > > > [  714.465520]  dev_hard_start_xmit+0x10c/0x2b0
> > > > > > [  714.465526]  __dev_queue_xmit+0x8f0/0xa74
> > > > > > [  714.465531]  dev_queue_xmit+0x20/0x2c
> > > > > > [  714.465538]  arp_xmit+0xc0/0xd0
> > > > > > [  714.465544]  arp_send_dst+0x78/0xa0
> > > > > > [  714.465550]  arp_solicit+0xf4/0x260
> > > > > > [  714.465554]  neigh_probe+0x64/0xb0
> > > > > > [  714.465560]  neigh_timer_handler+0x2f4/0x400
> > > > > > [  714.465566]  call_timer_fn+0x3c/0x184
> > > > > > [  714.465572]  __run_timers.part.0+0x2bc/0x370
> > > > > > [  714.465578]  run_timer_softirq+0x48/0x80
> > > > > > [  714.465583]  __do_softirq+0x120/0x36c
> > > > > > [  714.465589]  irq_exit+0xac/0x100
> > > > > > [  714.465596]  __handle_domain_irq+0x8c/0xf0
> > > > > > [  714.465600]  gic_handle_irq+0xcc/0x14c
> > > > > > [  714.465605]  el1_irq+0xc4/0x180
> > > > > > [  714.465610]  arch_cpu_idle+0x18/0x30
> > > > > > [  714.465617]  default_idle_call+0x4c/0x180
> > > > > > [  714.465623]  do_idle+0x238/0x2b0
> > > > > > [  714.465629]  cpu_startup_entry+0x30/0xa0
> > > > > > [  714.465636]  secondary_start_kernel+0x134/0x180
> > > > > > [  714.465640] ---[ end trace a84a7f61b559005f ]---
> > > > > >
> > > > > >
> > > > > > Given it is the iommu code that is provoking the warning I shou=
ld
> > > > > > probably mention that the board I have requires
> > > > > > arm-smmu.disable_bypass=3D0 on the kernel command line in order=
 to boot.
> > > > > > Also if it matters I am running the latest firmware from Solidr=
un
> > > > > > which is based on LSDK-20.04.
> > > > > >
> > > > >
> > > > > Hmmm, from what I remember I think I tested this with the smmu by=
passed
> > > > > so that is why I didn't catch it.
> > > > >
> > > > > > Is there any reason for this code not to be working for LX2160A=
?
> > > > >
> > > > > I wouldn't expect this to be LX2160A specific but rather a bug in=
 the
> > > > > implementation.. sorry.
> > > > >
> > > > > Let me reproduce it and see if I can get to the bottom of it and =
I will
> > > > > get back with some more info.
> > > > >
> > > >
> > > > Hi Daniel,
> > > >
> > > > It seems that the dma-unmapping on the SGT buffer was incorrectly d=
one
> > > > with a zero size since on the Tx path I initialized the improper fi=
eld.
> > > >
> > > > Could you test the following diff and let me know if you can genera=
te
> > > > the WARNINGs anymore?
> > >
> > > I fired this up and, with your change, I've not been able to trigger
> > > the warning with the tests that I used the drive my bisect.
> > >
> >
> > Great, thanks for testing this.
> >
> > I will take care of sending the fix to -net.
> >
> > Ioana
>=20
> Ioana,
>=20
> Please CC me when you send the patch to -net, I will put my Tested-by: on=
 it.
>=20

Hi Jon,

I sent out the patch yesterday. You are also copied.

https://lore.kernel.org/netdev/20201211171607.108034-1-ciorneiioana@gmail.c=
om/


Ioana=
