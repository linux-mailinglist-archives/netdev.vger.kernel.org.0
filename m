Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491482D7BB1
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403823AbgLKQzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:55:37 -0500
Received: from mail-vi1eur05on2061.outbound.protection.outlook.com ([40.107.21.61]:35680
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390769AbgLKQz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 11:55:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxNeUTlaKVfEP2ooe2ia+HQ/kA1G4S0+zj7EFyTnZ7zU/dz9onh+VIdb3evMcisXk08YbdhSHvp/OVPXfxllwJnxkmDTFjGdnyJ4m7mt7HXqaZd7uyWeF156Q4sUEaOrivFzaRCuMLvMvXGC2C7b+YL++Y3J4RI0GTQFOIaYvU5cL5jqZN2ICmsTx3wN2Uhi19y5tXRQhQBmapQfVMaN1NWi0bBZFLFL1J3gTKWXBJfbvE/RVWOE1GGb+wAG/2x24Ojmvlu8qUZZ7/BpRsAou+TOVfG037WcAieflVChY23YQzGeifo/t7LU6uuIsgm3yzddoymBjj16zAhYRY6F8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyIjKNBQ2HUw0DogIU1sNjtCONeF1FsmcnBv8OAupwE=;
 b=FYUySt9f0wD4hsrraAKj5ncDp/rwbQPpzgo23UJL7J5Z6UXjIkLiG0UMaEC7iPkPRdPhs+QPOlbjgYwGkrHPj/tL+yXFqTZNze55n8OA6J9OMsAbkPrv80ho8whmq5oatKk9LMNWc7PwC+7JtMhGf4SEIk51yoaC3hlGRf4SuP/4FjwrlCBGLoc7+e/ZKh8wYmZyZA+vht+6IUk+2ic2ZFQ1mZAmNcfqYz0k9/7ZEJXYNodUyyZ9TXVGJacc757iIKqZClGPWSMeGTxpNFEenZpfWwQZbQtGsqV0R1Z/dinEYmcpv+vHS8SBop9bjjGJHaIgLIG67kVu0U/Dl/QZgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyIjKNBQ2HUw0DogIU1sNjtCONeF1FsmcnBv8OAupwE=;
 b=N5ZM6Zk1JLBzNOZ3mDgZtQ8DmgSXcCmsfUMvjuZDaH9aWxRIsF8ubAfVJYi5B/ZcEnHy+Rkuh3+YiTawzAjtjyQbnBDW8DaB9hfhWS6C7Y8Hilpl3RCkYfi+f4r6dL8Nud/QPlIA5ulcfVItX0IV7vh4bnSCcu4ixEU1LC63luI=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4768.eurprd04.prod.outlook.com
 (2603:10a6:803:53::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Fri, 11 Dec
 2020 16:54:37 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f%6]) with mapi id 15.20.3654.017; Fri, 11 Dec 2020
 16:54:37 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Daniel Thompson <daniel.thompson@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Thread-Topic: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
Thread-Index: AQHWzxpfkmhJ4/PRJUyjg6gvz97H0KnwoDEAgAFN1QCAAClLAIAABxQA
Date:   Fri, 11 Dec 2020 16:54:36 +0000
Message-ID: <20201211165434.6qdk6hswmryhn7z6@skbuf>
References: <20200629184712.12449-2-ioana.ciornei () nxp ! com>
 <20201210173156.mbizovo6rxvkda73@holly.lan>
 <20201210180636.nsfwvzs5xxzpqt7n@skbuf>
 <20201211140126.25x4z2x6upctyin5@skbuf>
 <20201211162914.pa3eua4nerviysyy@holly.lan>
In-Reply-To: <20201211162914.pa3eua4nerviysyy@holly.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 81b7e721-61e2-43e2-430b-08d89df57196
x-ms-traffictypediagnostic: VI1PR04MB4768:
x-microsoft-antispam-prvs: <VI1PR04MB4768A7C868A610F65DF4FF74E0CA0@VI1PR04MB4768.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cO/Mw8jo9cI8/J/kf039e8BFpzT/rzd4bBMuVBAZtZgsz2fkKhu7SXhvV25zEStBQPhpDmN7IvCLcTmkJxYwLW/bIyAH5R5lRkB3Lng0gQQlNnrgDd2VVgruPnOnSonsUDCV1u2sMXqaSNfYBtzQFT7l/m60pIyQhzZ9tJgw0AMv1ZF2H2JdbRRPcRGG1XLoQDH3L5aIxN7JCcKfg6yHff/IWWADdHo8ephw7uqthUnWFBexN+WzGs2+6M/oop5pMGrgHQzE3g0xHnBKcdYCa+KzOGiJoPz4hLtpdlqWrBk6RwzfbkQ3eVvyYQ9jrWVrARXEy8U0VqlJ6TVcPhtL6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(45080400002)(83380400001)(54906003)(91956017)(478600001)(86362001)(9686003)(8936002)(6916009)(316002)(71200400001)(2906002)(66946007)(4326008)(33716001)(6486002)(66476007)(66446008)(66556008)(1076003)(8676002)(6512007)(186003)(26005)(6506007)(44832011)(76116006)(5660300002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pHKVPdcgs7GdhAtMYj1lnjG0yuEcGiauwiiUJvjt6rgzQ3tQ1rkhSlBONNhL?=
 =?us-ascii?Q?8YxwYgU1MisB3rQyYxs/sdLd4+9S//qvOTkMIszF4KwjlUwnmmKBEFYmlf6U?=
 =?us-ascii?Q?R2ji4SrIfET3HhaOGFzx29wx7AHkWkkTQ6O9k5w8f/ZnuPvjXkWB8sfxmLGp?=
 =?us-ascii?Q?+jDvv1g9cYTLLdpJPK1qPk9VcmsSQpPWVLHWS2yE0STW0gEvkOY+UZu8IJQH?=
 =?us-ascii?Q?AzgnBtZsJPgQIbghFRRyNYS8OKNnIwoGWxFYjUKZWdcGoizz3UOnW5ldBx3q?=
 =?us-ascii?Q?k8Lx9onOfKM31RtinjLJusHfPlxV8Z08dLON82U8ulaWtBUUN3LlvGO61Vax?=
 =?us-ascii?Q?kg7l/Tc/6Y2YTynQGa4f6UFcOq8EUvN0knHcMnPbaMRtYcql7zfhZNzbMo1g?=
 =?us-ascii?Q?FniYkzfDkl6Fw7U4f3lHbwHNYA/sGq6+di9dHR86nxKnWYJ9UPm/2eIXZbOi?=
 =?us-ascii?Q?xuGJrXZEJQ347jR7TVYvMckhFeUF5iJvKVLSjXrM0t4/OTierG2WLUgKNEY+?=
 =?us-ascii?Q?3pPXnCWlFFnr+pGXuqQGqPc/pQiW8bnpwJcki5M+tWJ9hExZJPiGToIRe543?=
 =?us-ascii?Q?IA6bCbnwboQR8nqYIbx2OqyylY/soSxHc599INPithDL1Y9MyX4Z8cZqr0fO?=
 =?us-ascii?Q?/GO+OftnkBGNNaWsPol4VLAShSzULVMz953cUBxdNR13ZVD0QULmnDVBS458?=
 =?us-ascii?Q?hfIZR0iMNHVZU3EeVgG7X5+lJr94IDWR4gjx/YlFViqK7C07rz88PdceSeyj?=
 =?us-ascii?Q?33cVKYl+NqzInAkbkwlJyzicUjWyuhRDnoXtsyfsI4/1r+kk4bF89yyED2tP?=
 =?us-ascii?Q?VBxz3wmVJSu+ANv2WiCV3AyF5hxKaP+/aozFIfwCBfTTj0y9vj8TClTRwwqN?=
 =?us-ascii?Q?6Ilhh1eLxRE6yBd6hH4WymBJUzlBOck5i7fpmt/JhjE29Cq4oNo3Mq8++UsL?=
 =?us-ascii?Q?MyZ63chAPNIGA7v0gkIyyqcCMQoYh3Z7ROF+kjt808nJyHTTJE+jjuxwaYIj?=
 =?us-ascii?Q?xPjv?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC112B45FEB1C2489615E271C1D91661@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b7e721-61e2-43e2-430b-08d89df57196
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2020 16:54:36.9967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ISPqZUNdwcxHG0PQPbuHiSuwTfd45mJs7sckj8hDfpBraHQT1Xulp1Qgi1R2dnm0BlU+Xm+27LcwBYvBQh+HBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4768
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 04:29:14PM +0000, Daniel Thompson wrote:
> On Fri, Dec 11, 2020 at 02:01:28PM +0000, Ioana Ciornei wrote:
> > On Thu, Dec 10, 2020 at 08:06:36PM +0200, Ioana Ciornei wrote:
> > > [Added also the netdev mailing list, I haven't heard of linux-netdev
> > > before but kept it]
> > >=20
> > > On Thu, Dec 10, 2020 at 05:31:56PM +0000, Daniel Thompson wrote:
> > > > Hi Ioana
> > >=20
> > > Hi Daniel,
> > >=20
> > > >=20
> > > > On Mon, Jun 29, 2020 at 06:47:11PM +0000, Ioana Ciornei wrote:
> > > > > Instead of realloc-ing the skb on the Tx path when the provided h=
eadroom
> > > > > is smaller than the HW requirements, create a Scatter/Gather fram=
e
> > > > > descriptor with only one entry.
> > > > >=20
> > > > > Remove the '[drv] tx realloc frames' counter exposed previously t=
hrough
> > > > > ethtool since it is no longer used.
> > > > >=20
> > > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > > ---
> > > >=20
> > > > I've been chasing down a networking regression on my LX2160A board
> > > > (Honeycomb LX2K based on CEx7 LX2160A COM) that first appeared in v=
5.9.
> > > >=20
> > > > It makes the board unreliable opening outbound connections meaning
> > > > things like `apt update` or `git fetch` often can't open the connec=
tion.
> > > > It does not happen all the time but is sufficient to make the board=
s
> > > > built-in networking useless for workstation use.
> > > >=20
> > > > The problem is strongly linked to warnings in the logs so I used th=
e
> > > > warnings to bisect down to locate the cause of the regression and i=
t
> > > > pinpointed this patch. I have confirmed that in both v5.9 and v5.10=
-rc7
> > > > that reverting this patch (and fixing up the merge issues) fixes th=
e
> > > > regression and the warnings stop appearing.
> > > >=20
> > > > A typical example of the warning is below (io-pgtable-arm.c:281 is =
an
> > > > error path that I guess would cause dma_map_page_attrs() to return
> > > > an error):
> > > >=20
> > > > [  714.464927] WARNING: CPU: 13 PID: 0 at
> > > > drivers/iommu/io-pgtable-arm.c:281 __arm_lpae_map+0x2d4/0x30c
> > > > [  714.464930] Modules linked in: snd_seq_dummy(E) snd_hrtimer(E)
> > > > snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) bridg=
e(E)
> > > > stp(E) llc(E) rfkill(E) caam_jr(E) crypto_engine(E) rng_core(E)
> > > > joydev(E) evdev(E) dpaa2_caam(E) caamhash_desc(E) caamalg_desc(E)
> > > > authenc(E) libdes(E) dpaa2_console(E) ofpart(E) caam(E) sg(E) error=
(E)
> > > > lm90(E) at24(E) spi_nor(E) mtd(E) sbsa_gwdt(E) qoriq_thermal(E)
> > > > layerscape_edac_mod(E) qoriq_cpufreq(E) drm(E) fuse(E) configfs(E)
> > > > ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16=
(E)
> > > > mbcache(E) jbd2(E) hid_generic(E) usbhid(E) hid(E) dm_crypt(E) dm_m=
od(E)
> > > > sd_mod(E) fsl_dpaa2_ptp(E) ptp_qoriq(E) fsl_dpaa2_eth(E)
> > > > xhci_plat_hcd(E) xhci_hcd(E) usbcore(E) aes_ce_blk(E) crypto_simd(E=
)
> > > > cryptd(E) aes_ce_cipher(E) ghash_ce(E) gf128mul(E) at803x(E) libaes=
(E)
> > > > fsl_mc_dpio(E) pcs_lynx(E) rtc_pcf2127(E) sha2_ce(E) phylink(E)
> > > > xgmac_mdio(E) regmap_spi(E) of_mdio(E) sha256_arm64(E)
> > > > i2c_mux_pca954x(E) fixed_phy(E) i2c_mux(E) sha1_ce(E) ptp(E) libphy=
(E)
> > > > [  714.465131]  pps_core(E) ahci_qoriq(E) libahci_platform(E) nvme(=
E)
> > > > libahci(E) nvme_core(E) t10_pi(E) libata(E) crc_t10dif(E)
> > > > crct10dif_generic(E) crct10dif_common(E) dwc3(E) scsi_mod(E) udc_co=
re(E)
> > > > roles(E) ulpi(E) sdhci_of_esdhc(E) sdhci_pltfm(E) sdhci(E)
> > > > spi_nxp_fspi(E) i2c_imx(E) fixed(E)
> > > > [  714.465192] CPU: 13 PID: 0 Comm: swapper/13 Tainted: G        W =
  E
> > > > 5.10.0-rc7-00001-gba98d13279ca #52
> > > > [  714.465196] Hardware name: SolidRun LX2160A Honeycomb (DT)
> > > > [  714.465202] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=3D-=
-)
> > > > [  714.465207] pc : __arm_lpae_map+0x2d4/0x30c
> > > > [  714.465211] lr : __arm_lpae_map+0x114/0x30c
> > > > [  714.465215] sp : ffff80001006b340
> > > > [  714.465219] x29: ffff80001006b340 x28: 0000002086538003=20
> > > > [  714.465227] x27: 0000000000000a20 x26: 0000000000001000=20
> > > > [  714.465236] x25: 0000000000000f44 x24: 00000020adf8d000=20
> > > > [  714.465245] x23: 0000000000000001 x22: 0000fffffaeca000=20
> > > > [  714.465253] x21: 0000000000000003 x20: ffff19b60d64d200=20
> > > > [  714.465261] x19: 00000000000000ca x18: 0000000000000000=20
> > > > [  714.465270] x17: 0000000000000000 x16: ffffcccb7cf3ca20=20
> > > > [  714.465278] x15: 0000000000000000 x14: 0000000000000000=20
> > > > [  714.465286] x13: 0000000000000003 x12: 0000000000000010=20
> > > > [  714.465294] x11: 0000000000000000 x10: 0000000000000002=20
> > > > [  714.465302] x9 : ffffcccb7d5b6e78 x8 : 00000000000001ff=20
> > > > [  714.465311] x7 : ffff19b606538650 x6 : ffff19b606538000=20
> > > > [  714.465319] x5 : 0000000000000009 x4 : 0000000000000f44=20
> > > > [  714.465327] x3 : 0000000000001000 x2 : 00000020adf8d000=20
> > > > [  714.465335] x1 : 0000000000000002 x0 : 0000000000000003=20
> > > > [  714.465343] Call trace:
> > > > [  714.465348]  __arm_lpae_map+0x2d4/0x30c
> > > > [  714.465353]  __arm_lpae_map+0x114/0x30c
> > > > [  714.465357]  __arm_lpae_map+0x114/0x30c
> > > > [  714.465362]  __arm_lpae_map+0x114/0x30c
> > > > [  714.465366]  arm_lpae_map+0xf4/0x180
> > > > [  714.465373]  arm_smmu_map+0x4c/0xc0
> > > > [  714.465379]  __iommu_map+0x100/0x2bc
> > > > [  714.465385]  iommu_map_atomic+0x20/0x30
> > > > [  714.465391]  __iommu_dma_map+0xb0/0x110
> > > > [  714.465397]  iommu_dma_map_page+0xb8/0x120
> > > > [  714.465404]  dma_map_page_attrs+0x1a8/0x210
> > > > [  714.465413]  __dpaa2_eth_tx+0x384/0xbd0 [fsl_dpaa2_eth]
> > > > [  714.465421]  dpaa2_eth_tx+0x84/0x134 [fsl_dpaa2_eth]
> > > > [  714.465427]  dev_hard_start_xmit+0x10c/0x2b0
> > > > [  714.465433]  sch_direct_xmit+0x1a0/0x550
> > > > [  714.465438]  __qdisc_run+0x140/0x670
> > > > [  714.465443]  __dev_queue_xmit+0x6c4/0xa74
> > > > [  714.465449]  dev_queue_xmit+0x20/0x2c
> > > > [  714.465463]  br_dev_queue_push_xmit+0xc4/0x1a0 [bridge]
> > > > [  714.465476]  br_forward_finish+0xdc/0xf0 [bridge]
> > > > [  714.465489]  __br_forward+0x160/0x1c0 [bridge]
> > > > [  714.465502]  br_forward+0x13c/0x160 [bridge]
> > > > [  714.465514]  br_dev_xmit+0x228/0x3b0 [bridge]
> > > > [  714.465520]  dev_hard_start_xmit+0x10c/0x2b0
> > > > [  714.465526]  __dev_queue_xmit+0x8f0/0xa74
> > > > [  714.465531]  dev_queue_xmit+0x20/0x2c
> > > > [  714.465538]  arp_xmit+0xc0/0xd0
> > > > [  714.465544]  arp_send_dst+0x78/0xa0
> > > > [  714.465550]  arp_solicit+0xf4/0x260
> > > > [  714.465554]  neigh_probe+0x64/0xb0
> > > > [  714.465560]  neigh_timer_handler+0x2f4/0x400
> > > > [  714.465566]  call_timer_fn+0x3c/0x184
> > > > [  714.465572]  __run_timers.part.0+0x2bc/0x370
> > > > [  714.465578]  run_timer_softirq+0x48/0x80
> > > > [  714.465583]  __do_softirq+0x120/0x36c
> > > > [  714.465589]  irq_exit+0xac/0x100
> > > > [  714.465596]  __handle_domain_irq+0x8c/0xf0
> > > > [  714.465600]  gic_handle_irq+0xcc/0x14c
> > > > [  714.465605]  el1_irq+0xc4/0x180
> > > > [  714.465610]  arch_cpu_idle+0x18/0x30
> > > > [  714.465617]  default_idle_call+0x4c/0x180
> > > > [  714.465623]  do_idle+0x238/0x2b0
> > > > [  714.465629]  cpu_startup_entry+0x30/0xa0
> > > > [  714.465636]  secondary_start_kernel+0x134/0x180
> > > > [  714.465640] ---[ end trace a84a7f61b559005f ]---
> > > >=20
> > > >=20
> > > > Given it is the iommu code that is provoking the warning I should
> > > > probably mention that the board I have requires
> > > > arm-smmu.disable_bypass=3D0 on the kernel command line in order to =
boot.
> > > > Also if it matters I am running the latest firmware from Solidrun
> > > > which is based on LSDK-20.04.
> > > >=20
> > >=20
> > > Hmmm, from what I remember I think I tested this with the smmu bypass=
ed
> > > so that is why I didn't catch it.
> > >=20
> > > > Is there any reason for this code not to be working for LX2160A?
> > >=20
> > > I wouldn't expect this to be LX2160A specific but rather a bug in the
> > > implementation.. sorry.
> > >=20
> > > Let me reproduce it and see if I can get to the bottom of it and I wi=
ll
> > > get back with some more info.
> > >=20
> >=20
> > Hi Daniel,
> >=20
> > It seems that the dma-unmapping on the SGT buffer was incorrectly done
> > with a zero size since on the Tx path I initialized the improper field.
> >=20
> > Could you test the following diff and let me know if you can generate
> > the WARNINGs anymore?
>=20
> I fired this up and, with your change, I've not been able to trigger
> the warning with the tests that I used the drive my bisect.
>=20

Great, thanks for testing this.

I will take care of sending the fix to -net.

Ioana

> Thanks for the quick response.
>=20
>=20
> Daniel.
>=20
>=20
> >=20
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -878,7 +878,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct =
dpaa2_eth_priv *priv,
> >         swa =3D (struct dpaa2_eth_swa *)sgt_buf;
> >         swa->type =3D DPAA2_ETH_SWA_SINGLE;
> >         swa->single.skb =3D skb;
> > -       swa->sg.sgt_size =3D sgt_buf_size;
> > +       swa->single.sgt_size =3D sgt_buf_size;
> > =20
> >         /* Separately map the SGT buffer */
> >         sgt_addr =3D dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BID=
IRECTIONAL);
> >=20
> >=20
> > Ioana=
