Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9234ADB96
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378440AbiBHOxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355051AbiBHOxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:53:12 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96493C061579;
        Tue,  8 Feb 2022 06:53:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhEAxHLXqr2cD8udIjzY/Dms0gj2dRJ4WiQhqcj2OOg4gVkDkmLFgD642XlZ4B+MNG3gL1T8syYhDJ8r1wrbhY1HVO6VSNrArzOlyt/g9SV38LpqlY4cS/CeXNNJPq2rYxLbo68JCS4TARDA4sA5Ok7lBq9rdhjcTY6078zZXZCLEggJfyxfbpmfywwDvTxDbxyILybJ1yFXejmAXDjPwbzGFKpiz7NpejdtpXiQFJWEYaKd9hRVHYdPpR6RgAgDyCIFRbV9LCVEUKTGQCCBqFP+ECwa2i2k/Ivfzh4TaIK2YDRQVKavcPimffNj1/vQDiw6dx61fIqn+fNYeMIreg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCTb8JnJFLaHiX9rDZvxULLNTsh5j+8g15vwp1ECOjM=;
 b=kood2iDRRI76Mjs9b7XXH8WE434DkPpUb8yVJwv79FYevC4PCMUmxCkK3Ugm+KCpR6x1Jomdb8xz83l8khGMtYe1FyKjIIdoMr4EVVsVrlhWGNdWeclnN2q05qz6bxMMy72LDJ126CMZ8ZU6E8fdMJ02WS+z131V3T/Bqm/8J4mvIisB01QCPsVFAF16Mk1fsSEjJralPs66AtfQe46Exg+9NOChOf2mh3FPfBSaBwvuVG9L7KjlihFv1s6Yk/RokAEc5tMV1Vi92S1GNUTlQPkE4SG+zYzV75gMOdIT4usXo97jTJXTYUDX1PpYBv78/ECdQtzFUx/8lXmdr/bvOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCTb8JnJFLaHiX9rDZvxULLNTsh5j+8g15vwp1ECOjM=;
 b=TohezDeKhp1JOJKuwkN00Fv45GmDLOHaWuM5qj30kQkBFy4k/3FBpMrErbV+2OxQzGImRIFpRRFUDJYWssn8l2bkuurUBCSnwH+i0SsdGKdqYKd3Mh+vEO6/aFOWkPDL29YmJH9JyeqDS0WL1PXo9BWqNqHKOsZwbPw1ZXzXyFw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8908.eurprd04.prod.outlook.com (2603:10a6:20b:40b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Tue, 8 Feb
 2022 14:53:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 14:53:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 0/3] use bulk reads for ocelot statistics
Thread-Topic: [PATCH v5 net-next 0/3] use bulk reads for ocelot statistics
Thread-Index: AQHYHKbrycuT10vzCEeS0T0tAzVYxayJprYAgAAHDwCAABAXgA==
Date:   Tue, 8 Feb 2022 14:53:07 +0000
Message-ID: <20220208145307.djt6do75bpuygfjb@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208133016.axi7ruhop2lc65ly@skbuf> <20220208135532.GB246307@euler>
In-Reply-To: <20220208135532.GB246307@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9b2c952-6d4a-4505-db0f-08d9eb12b81d
x-ms-traffictypediagnostic: AM9PR04MB8908:EE_
x-microsoft-antispam-prvs: <AM9PR04MB890861568F3DBFDBA3712A6CE02D9@AM9PR04MB8908.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fMLM/sfcWtc5eGgAqXD0duioV+olmeCceKAxHk9PWq9cG8VVNE2S71Z9IpF/uk4imIZaVCmerWrQ/0c9zQzDY99CKaqVrckFUZTElhTLjcNLNlHV0zPS/bmdp5RPMr1WKMNBS/19Takr6alOXQLgJ4R5ZJ2H49U6Iw5cPNIlGb5nwXfGqHHTvEzGugDuMCYzHTJqwf+eVDEQQulRi4vOnelSwCEidLoLqkbKmPoJdfTDCnET2m4f1YM+81ePJOIQAi4onv6++ITc1LW8llHXKvV2ieq3OBCqj4d54cNj/fjECyJ/p3LZW7wZq+oNMvF/QYpstcobnMw3Zv2Irigkp4pmhbnAFnXbqdAOZoQGsEHOAlcGHKeFvf420oewg9M3rqAR2YfJt8n7OXRjFFC1Tyrg7K17ROGaRTBU5txJe/KyJ1z/JF2A9dnuMNPb1cVnAvI2LvbeqxJ/UDv2gPAAuQgwvO0urMtSU/TghfHzEF9d1qv8REOnmOnQwH6iBX41wyiKh9UFGJFa8ED+LcbOXoIUbhHaFU7xgFb+1wNK4uez13ohusQ9krRMnPRKMnfA1hcyx+TohRcanQj82RzbbWTGantGzpXHyLMDNrgxDZXP9xjh17P3WNpAxJfGIqz83GkvdWycHyDWyOv7DD0Dm6/2oku0gRV3qkQJbWfHZGrSvuvs2d88N5t5XLOrfUqY2MKXhhTxu52h4Mr/saX9yA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(5660300002)(2906002)(44832011)(30864003)(6506007)(38070700005)(6486002)(33716001)(66476007)(6512007)(508600001)(122000001)(83380400001)(8936002)(8676002)(76116006)(66946007)(91956017)(45080400002)(66446008)(9686003)(71200400001)(316002)(186003)(86362001)(66556008)(26005)(64756008)(54906003)(1076003)(38100700002)(6916009)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5sagdlXOhV3QxSdRQaqNMuHjP67bf9Ck3xzuwQ8Id70u6CXIkRp6s/FjMAPi?=
 =?us-ascii?Q?JEecyYKCGiRUFLZrwxbFCGEvXSp+JuqXB8hfx/8K7hYhY/2po25CsegO5suE?=
 =?us-ascii?Q?oH82T/Rv4l/wtxCi0nNqNM82RCIQeTzXLmwW9jZ65byPFCEgcYSTiykvpgIv?=
 =?us-ascii?Q?pJcnmxByI+Oszw1wOKTeKyFlBo9kW/2NNdHzSszVlmPDl3FKJECXX3mz9Fuz?=
 =?us-ascii?Q?VmfcbaMP6wR9DKrmWHEORfX+NTsCWCOwHQhL8dnEp6zXYzlYme41pXe3ANbc?=
 =?us-ascii?Q?uu3TgSchhguCqeeyJ5Irb/UMPEeEmSUSBKnWFcr/1HEwB0UtZQGXNkaIUmjS?=
 =?us-ascii?Q?XxjRlT7NT51BLiuQObTKaR8tyP0FoPilwt/iKHJ5DLKt7YeSQWlICwgf25uI?=
 =?us-ascii?Q?800sP3p2PbKv83jsFBICAIAAOdNbDKS9LxTAQId7TupRf8Fe7ZyP8MJw/r9a?=
 =?us-ascii?Q?ubBEWZAoavyi9M8bTDdKtLgLP12T5dFRH1GUeGd1aHNGC8JsGCPYoKiBpAj2?=
 =?us-ascii?Q?VNG/L3FmGMyq8ToTWpGxdYPAp14wTVO6HDAIWxtXg9lvuszJGTjJT5yM8BHZ?=
 =?us-ascii?Q?zzKAyj6bKi6Y5ivPFb54JPb1bHybE59fAfvYOLs8/Zz83aWttUWQkDqevI5y?=
 =?us-ascii?Q?djG+1ewMO3uv+/Mcr+fo7gKdBAbhnLOckcqhTFknWReUC4OVUAyTqudi8VVz?=
 =?us-ascii?Q?v0gLlcEAY+UmMUsMcAQup+GeU8lQeC+VXbUG0cOG9qEOe49B8k5XHogFOeT6?=
 =?us-ascii?Q?2iZdgrIU9trvqc8Pk9SdocIqXd9NVm7iemjkNbcI+9klGRihMuDSIfbwiGp9?=
 =?us-ascii?Q?D57mG/ZYALkWPyNqTLAupb5ibeLxmFI9xCuaaeuDznVM7s9HLsj4nxywyAp1?=
 =?us-ascii?Q?CIUSwDkdl7TwhfnbdGfuPwv8R/Ao4JUlpqCv34HeWpi/n6rbF8M3kVzAKGpq?=
 =?us-ascii?Q?obHpD1Eq4Xtmp+CvkZZGd5LbTUQ8NkGco8prvZnPcO/RrB18rlwqttIjqA0G?=
 =?us-ascii?Q?eNuLiLQi+uCoDaUKAh+FRPxYYfoNnfv36w7eq+JiUTAza58ozdnHe+qjhFef?=
 =?us-ascii?Q?YlteLsigRu/+2+1/pjxUSyThOHDj+sGyqX5akudiAoNOZEPMRU6ph45AS1Hl?=
 =?us-ascii?Q?Yz5D5MTq39x7/HJyl/ksqIs/Pl/KNNeip1kLKRGQBZbGUtxVwewFZ7vhvXnj?=
 =?us-ascii?Q?2J+1bhzv4TVJ8Qt4MHQB+u8Ik9WyggsdBFBca4hG8vzeJ9sG5ZQpBm/6iGWz?=
 =?us-ascii?Q?R60WAb53UOSbuCcaOZqYyK+SRvHaDZ/wB0iDhwvT9KPi/0NvIfETR/DrnzWs?=
 =?us-ascii?Q?EPLd1oi+jQooXwufzi6r+TlaEj7ebtjEC6vEFSzjUEXr4hf2AyeQX8Lxt+qv?=
 =?us-ascii?Q?YrNOK+/NXetrb9zTQIw/5yq3LZW7UwgcH7XdjpH6EuvoUQzFNCZtMsNZ/IkK?=
 =?us-ascii?Q?PLfHKA1kRArFFD0qv7BjFYUlOZEAWSSi2GNP+4WgGsXKld9M2MOZysrrl6eg?=
 =?us-ascii?Q?lOdpaNwB54NsEZ0zVmTIuwBl2YeJwSEhiIraqRsSLjSYuUDE4hZfgin6v+M2?=
 =?us-ascii?Q?Txp8sq+xFJbxTkqyey+/puKeBIPmDpB9YeaaLok1DU41119Pv7UHhirAwOvB?=
 =?us-ascii?Q?7F4qpleVJ2aqmjrympb9MYM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B57673622FCF9F4293F6F13C0C597217@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b2c952-6d4a-4505-db0f-08d9eb12b81d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 14:53:07.8976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eCoJsPkzY9+pJ/dsI0iheO61oik6TaeLUGymzZeJjiZKgnT7k51CLYJI9RaRHpwXxlRirMQaF/IohWRAZil1nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8908
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 05:55:32AM -0800, Colin Foster wrote:
> On Tue, Feb 08, 2022 at 01:30:16PM +0000, Vladimir Oltean wrote:
> > On Mon, Feb 07, 2022 at 08:46:41PM -0800, Colin Foster wrote:
> > > Ocelot loops over memory regions to gather stats on different ports.
> > > These regions are mostly continuous, and are ordered. This patch set
> > > uses that information to break the stats reads into regions that can =
get
> > > read in bulk.
> > >
> > > The motiviation is for general cleanup, but also for SPI. Performing =
two
> > > back-to-back reads on a SPI bus require toggling the CS line, holding=
,
> > > re-toggling the CS line, sending 3 address bytes, sending N padding
> > > bytes, then actually performing the read. Bulk reads could reduce alm=
ost
> > > all of that overhead, but require that the reads are performed via
> > > regmap_bulk_read.
> > >
> > > v1 > v2: reword commit messages
> > > v2 > v3: correctly mark this for net-next when sending
> > > v3 > v4: calloc array instead of zalloc per review
> > > v4 > v5:
> > >     Apply CR suggestions for whitespace
> > >     Fix calloc / zalloc mixup
> > >     Properly destroy workqueues
> > >     Add third commit to split long macros
> > >
> > >
> > > Colin Foster (3):
> > >   net: ocelot: align macros for consistency
> > >   net: mscc: ocelot: add ability to perform bulk reads
> > >   net: mscc: ocelot: use bulk reads for stats
> > >
> > >  drivers/net/ethernet/mscc/ocelot.c    | 78 ++++++++++++++++++++++---=
--
> > >  drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++
> > >  include/soc/mscc/ocelot.h             | 57 ++++++++++++++------
> > >  3 files changed, 120 insertions(+), 28 deletions(-)
> > >
> > > --
> > > 2.25.1
> > >
> >=20
> > Please do not merge these yet. I gave them a run on my board and the
> > kernel crashed on boot.
> >=20
> > [    8.043170] mscc_felix 0000:00:00.5: Found PCS at internal MDIO addr=
ess 0
> > [    8.050241] mscc_felix 0000:00:00.5: Found PCS at internal MDIO addr=
ess 1
> > [    8.057142] mscc_felix 0000:00:00.5: Found PCS at internal MDIO addr=
ess 2
> > [    8.064021] mscc_felix 0000:00:00.5: Found PCS at internal MDIO addr=
ess 3
> > [    8.128668] ------------[ cut here ]------------
> > [    8.133315] WARNING: CPU: 1 PID: 44 at drivers/net/dsa/ocelot/felix_=
vsc9959.c:1007 vsc9959_wm_enc+0x2c/0x40
> > [    8.143107] Modules linked in:
> > [    8.146181] CPU: 1 PID: 44 Comm: kworker/u4:2 Not tainted 5.17.0-rc2=
-07010-ga9b9500ffaac-dirty #2104
> > [    8.155355] Hardware name: LS1028A RDB Board (DT)
> > [    8.160079] Workqueue: events_unbound deferred_probe_work_func
> > [    8.165945] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> > [    8.172940] pc : vsc9959_wm_enc+0x2c/0x40
> > [    8.176967] lr : ocelot_setup_sharing_watermarks+0x94/0x1fc
> > [    8.182568] sp : ffff800008863810
> > [    8.185896] x29: ffff800008863810 x28: 0000000000000308 x27: 0000000=
000000001
> > [    8.193079] x26: 000000000300001a x25: 0000000000000008 x24: 0000000=
000000080
> > [    8.200261] x23: 0000000088888889 x22: 0000000000000000 x21: 0000000=
000000000
> > [    8.207441] x20: 00000000ffff2d17 x19: ffff2d17039d8010 x18: ffffd8e=
2afa23b28
> > [    8.214623] x17: 0000000000000015 x16: 0000000000000041 x15: 0000000=
000000000
> > [    8.221803] x14: ffffd8e2afa49228 x13: 0000000000025700 x12: 0000000=
000000009
> > [    8.228984] x11: ffff2d1703a96c18 x10: 0000000000000004 x9 : ffffd8e=
2ad6ce0f8
> > [    8.236165] x8 : ffff2d1700be4240 x7 : ffffd8e2af981000 x6 : 0000000=
000000001
> > [    8.243345] x5 : ffffd8e2ad1e1440 x4 : 0000000000000000 x3 : 0000000=
000000000
> > [    8.250525] x2 : 0000000000000000 x1 : ffffd8e2ad3d2810 x0 : 0000000=
0000040c0
> > [    8.257706] Call trace:
> > [    8.260162]  vsc9959_wm_enc+0x2c/0x40
> > [    8.263841]  ocelot_devlink_sb_register+0x33c/0x380
> > [    8.268742]  felix_setup+0x438/0x750
> > [    8.272334]  dsa_register_switch+0x988/0x114c
> > [    8.276713]  felix_pci_probe+0x138/0x1fc
> > [    8.280654]  local_pci_probe+0x4c/0xc0
> > [    8.284423]  pci_device_probe+0x1b0/0x1f0
> > [    8.288451]  really_probe.part.0+0xa4/0x310
> > [    8.292654]  __driver_probe_device+0xa0/0x150
> > [    8.297030]  driver_probe_device+0xcc/0x164
> > [    8.301231]  __device_attach_driver+0xc4/0x130
> > [    8.305695]  bus_for_each_drv+0x84/0xe0
> > [    8.309547]  __device_attach+0xe4/0x190
> > [    8.313400]  device_initial_probe+0x20/0x30
> > [    8.317601]  bus_probe_device+0xac/0xb4
> > [    8.321454]  deferred_probe_work_func+0x98/0xd4
> > [    8.326004]  process_one_work+0x294/0x700
> > [    8.330037]  worker_thread+0x80/0x480
> > [    8.333717]  kthread+0x10c/0x120
> > [    8.336961]  ret_from_fork+0x10/0x20
> > [    8.340554] irq event stamp: 50432
> > [    8.343968] hardirqs last  enabled at (50431): [<ffffd8e2ade442b0>] =
_raw_spin_unlock_irqrestore+0x90/0xb0
> > [    8.353581] hardirqs last disabled at (50432): [<ffffd8e2ade36e44>] =
el1_dbg+0x24/0x90
> > [    8.361448] softirqs last  enabled at (50148): [<ffffd8e2ac6908f0>] =
__do_softirq+0x480/0x5f8
> > [    8.369923] softirqs last disabled at (50143): [<ffffd8e2ac728e3c>] =
__irq_exit_rcu+0x17c/0x1b0
> > [    8.378577] ---[ end trace 0000000000000000 ]---
> > [    8.383304] ------------[ cut here ]------------
> > [    8.387942] WARNING: CPU: 1 PID: 44 at drivers/net/dsa/ocelot/felix_=
vsc9959.c:1007 vsc9959_wm_enc+0x2c/0x40
> > [    8.397729] Modules linked in:
> > [    8.400800] CPU: 1 PID: 44 Comm: kworker/u4:2 Tainted: G        W   =
      5.17.0-rc2-07010-ga9b9500ffaac-dirty #2104
> > [    8.411369] Hardware name: LS1028A RDB Board (DT)
> > [    8.416092] Workqueue: events_unbound deferred_probe_work_func
> > [    8.421955] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> > [    8.428948] pc : vsc9959_wm_enc+0x2c/0x40
> > [    8.432975] lr : ocelot_setup_sharing_watermarks+0xc0/0x1fc
> > [    8.438573] sp : ffff800008863810
> > [    8.441900] x29: ffff800008863810 x28: 0000000000000308 x27: 0000000=
000000001
> > [    8.449081] x26: 000000000300001a x25: 0000000000000008 x24: 0000000=
000000080
> > [    8.456262] x23: 0000000088888889 x22: 0000000000000000 x21: 0000000=
000000000
> > [    8.463443] x20: 00000000ffff2d17 x19: ffff2d17039d8010 x18: ffffd8e=
2afa23b28
> > [    8.470623] x17: 0000000000000015 x16: 0000000000000041 x15: 0000000=
000000000
> > [    8.477804] x14: ffffd8e2afa49228 x13: 0000000000025700 x12: 0000000=
000000009
> > [    8.484984] x11: ffff2d1703a96c18 x10: 0000000000000004 x9 : ffffd8e=
2ad6ce124
> > [    8.492165] x8 : ffff2d1700be4240 x7 : ffffd8e2af981000 x6 : 0000000=
000000001
> > [    8.499345] x5 : ffffd8e2ad1e1440 x4 : 0000000000000000 x3 : 0000000=
000000001
> > [    8.506525] x2 : 0000000000000000 x1 : ffffd8e2ad3d2810 x0 : 0000000=
0000040c0
> > [    8.513705] Call trace:
> > [    8.516161]  vsc9959_wm_enc+0x2c/0x40
> > [    8.519840]  ocelot_devlink_sb_register+0x33c/0x380
> > [    8.524740]  felix_setup+0x438/0x750
> > [    8.528331]  dsa_register_switch+0x988/0x114c
> > [    8.532708]  felix_pci_probe+0x138/0x1fc
> > [    8.536648]  local_pci_probe+0x4c/0xc0
> > [    8.540415]  pci_device_probe+0x1b0/0x1f0
> > [    8.544443]  really_probe.part.0+0xa4/0x310
> > [    8.548646]  __driver_probe_device+0xa0/0x150
> > [    8.553022]  driver_probe_device+0xcc/0x164
> > [    8.557225]  __device_attach_driver+0xc4/0x130
> > [    8.561688]  bus_for_each_drv+0x84/0xe0
> > [    8.565540]  __device_attach+0xe4/0x190
> > [    8.569393]  device_initial_probe+0x20/0x30
> > [    8.573594]  bus_probe_device+0xac/0xb4
> > [    8.577447]  deferred_probe_work_func+0x98/0xd4
> > [    8.581997]  process_one_work+0x294/0x700
> > [    8.586026]  worker_thread+0x80/0x480
> > [    8.589706]  kthread+0x10c/0x120
> > [    8.592949]  ret_from_fork+0x10/0x20
> > [    8.596541] irq event stamp: 50450
> > [    8.599955] hardirqs last  enabled at (50449): [<ffffd8e2ade442b0>] =
_raw_spin_unlock_irqrestore+0x90/0xb0                                      =
                                                         =20
> > [    8.609566] hardirqs last disabled at (50450): [<ffffd8e2ade36e44>] =
el1_dbg+0x24/0x90
> > [    8.617431] softirqs last  enabled at (50446): [<ffffd8e2ac6908f0>] =
__do_softirq+0x480/0x5f8
> > [    8.625907] softirqs last disabled at (50435): [<ffffd8e2ac728e3c>] =
__irq_exit_rcu+0x17c/0x1b0
> > [    8.634559] ---[ end trace 0000000000000000 ]---
> > [    8.640586] device eth1 entered promiscuous mode
> > [    8.645499] Unable to handle kernel paging request at virtual addres=
s 00000010400020bc
> > [    8.653496] Mem abort info:
> > [    8.656340]   ESR =3D 0x96000044
> > [    8.659413]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > [    8.664784]   SET =3D 0, FnV =3D 0
> > [    8.667855]   EA =3D 0, S1PTW =3D 0
> > [    8.671044]   FSC =3D 0x04: level 0 translation fault
> > [    8.675979] Data abort info:
> > [    8.678875]   ISV =3D 0, ISS =3D 0x00000044
> > [    8.682762]   CM =3D 0, WnR =3D 1
> > [    8.685795] [00000010400020bc] user address but active_mm is swapper
> > [    8.692272] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> > [    8.697865] Modules linked in:
> > [    8.700928] CPU: 1 PID: 44 Comm: kworker/u4:2 Tainted: G        W   =
      5.17.0-rc2-07010-ga9b9500ffaac-dirty #2104
> > [    8.711490] Hardware name: LS1028A RDB Board (DT)
> > [    8.716206] Workqueue: events_unbound deferred_probe_work_func
> > [    8.722065] pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> > [    8.729051] pc : ocelot_phylink_mac_link_down+0x70/0x314
> > [    8.734381] lr : felix_phylink_mac_link_down+0x24/0x30
> > [    8.739536] sp : ffff800008863840
> > [    8.742856] x29: ffff800008863840 x28: 0000000000000000 x27: ffffd8e=
2af8ef180
> > [    8.750022] x26: 0000000000000001 x25: 0000001040002000 x24: 0000000=
000000000
> > [    8.757187] x23: 0000000000000180 x22: ffff2d1703a92000 x21: 0000000=
000000004
> > [    8.764352] x20: 0000000000000004 x19: ffff2d17039d8010 x18: ffffd8e=
2afa23b28
> > [    8.771516] x17: 0000000000040006 x16: 0000000500030008 x15: fffffff=
fffffffff
> > [    8.778680] x14: ffffffffffff0000 x13: ffffffffffffffff x12: 0000000=
000000010
> > [    8.785845] x11: 0101010101010101 x10: 0000000000000004 x9 : ffffd8e=
2ad3d0814
> > [    8.793009] x8 : fefefefefeff6a6d x7 : 0000ffffffffffff x6 : 0000000=
000000000
> > [    8.800173] x5 : 00000000ffffffff x4 : 0000000000000001 x3 : 0000000=
00d000007
> > [    8.807338] x2 : 0000000000000010 x1 : 0000000000000000 x0 : 0000001=
040002000
> > [    8.814502] Call trace:
> > [    8.816949]  ocelot_phylink_mac_link_down+0x70/0x314
> > [    8.821929]  felix_phylink_mac_link_down+0x24/0x30
> > [    8.826734]  dsa_port_link_register_of+0xa8/0x240
> > [    8.831454]  dsa_port_setup+0xb4/0x180
> > [    8.835212]  dsa_register_switch+0xdb4/0x114c
> > [    8.839581]  felix_pci_probe+0x138/0x1fc
> > [    8.843515]  local_pci_probe+0x4c/0xc0
> > [    8.847275]  pci_device_probe+0x1b0/0x1f0
> > [    8.851296]  really_probe.part.0+0xa4/0x310
> > [    8.855490]  __driver_probe_device+0xa0/0x150
> > [    8.859860]  driver_probe_device+0xcc/0x164
> > [    8.864054]  __device_attach_driver+0xc4/0x130
> > [    8.868510]  bus_for_each_drv+0x84/0xe0
> > [    8.872355]  __device_attach+0xe4/0x190
> > [    8.876200]  device_initial_probe+0x20/0x30
> > [    8.880395]  bus_probe_device+0xac/0xb4
> > [    8.884240]  deferred_probe_work_func+0x98/0xd4
> > [    8.888783]  process_one_work+0x294/0x700
> > [    8.892808]  worker_thread+0x80/0x480
> > [    8.896480]  kthread+0x10c/0x120
> > [    8.899715]  ret_from_fork+0x10/0x20
> > [    8.903303] Code: 52800202 f874d839 52800001 aa1903e0 (b900bf25)
> > [    8.909417] ---[ end trace 0000000000000000 ]---
> >=20
> > Investigating...
>=20
> I just did a sanity check on my latest tree and it doesn't crash. I'll
> keep an eye out here as well.
>=20
> Gives me an opportunity to fix up your other suggestion.
>=20
> Thanks for reviewing and testing Vladimir!

I don't know why this glitch happened. I couldn't reproduce this a
second time. Booting patch by patch with KASAN enabled also showed
nothing. And the stack traces don't make much sense either. I'll just
ignore it for now.

But anyway, I found some actual bugs in the code while testing, I'll
reply on the individual patch.=
