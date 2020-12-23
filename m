Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBCD2E1536
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbgLWCsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:48:50 -0500
Received: from mail-mw2nam10on2116.outbound.protection.outlook.com ([40.107.94.116]:20960
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730784AbgLWCsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:48:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ua5/FhRHZrJZYTHg3Pi6NyHmz0v5a4g0zBkjAS2qwVQ4lNF8c4npouwZg55kE/JItX4sfXLh3L2PcNmqoKUDKw6AJe59kOXMLSHFyknnYNOB1wfDjQ6bHYzeCLIBnrLzOAmTBFtYei/hW2Vl1lBvetFixaFnqBzUIAAEzHmi96ayKvsuyl2H3T2XcASianvX95ADWvJEqbeNnYynn9HQESgnOJKk5W86NGRHUSfVqyMIjtVCp6+nvuKrowjQpW5ExQrH0GwrHEJbJ8+LrPHf2gZgf+wAKdn0fnerD7jFV7nZF/8HU3lB9lbTp3hwszObNhGNOFBR38XEO7k2WJziYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jHyBGITz/48VnrXYemhxN7d9DnBoHqZOos/eDXEDH0=;
 b=MudLrk8zgz0iGFQXf7z/yhDwCU14GDCKOkDyvJwRCp6CNbp79UigmMl5OJ1ZDHgFhh7pRbyJuYpkt2OGCSx8tuB0N2B2MbFEuPM/ke2Sh+0W20ch0/5gWOXoL4j+UlyLd8MMEOR0eQ3pVV43jD+DKm/psVQpcarBnTPj/eYN1BWSdPPxFUmlVrE/Tyl0D1j8uQahYuHPx2A1QSP+MHs9NibjYE9RhT0334zq6aGy2VxFEUWHnmBZmuxC5ePN4rGcXLM2q1bexeumeWqDy7XMhWr5Xq2AIiX+kljwtgdFDXCpSXvkoIMb1pjZMrFQNAMCILLz8uRB432HonMUKBsR6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jHyBGITz/48VnrXYemhxN7d9DnBoHqZOos/eDXEDH0=;
 b=Nz4TcpiFZc4QpGIjIBZ7GUiFjIyFFnG5CMopI4XGgJzHDfm7GbNxVH05Ndt2uOjRthEEzHbZXN1zpMxVSr2uHejuZjQeWIMrHhVVrI9salwVGWRrk/YG7DbQh56X4nm538Z7iaYR4rxF7t7KXDeJ1y0Pr6OBqsHn0gGlBsY/+9c=
Received: from (2603:10b6:302:a::16) by
 MW2PR2101MB1801.namprd21.prod.outlook.com (2603:10b6:302:5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.7; Wed, 23 Dec
 2020 02:47:56 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::b8f6:e748:cdf2:1922]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::b8f6:e748:cdf2:1922%8]) with mapi id 15.20.3721.008; Wed, 23 Dec 2020
 02:47:56 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 4.14 40/66] hv_netvsc: Validate number of
 allocated sub-channels
Thread-Topic: [PATCH AUTOSEL 4.14 40/66] hv_netvsc: Validate number of
 allocated sub-channels
Thread-Index: AQHW2NLnGTY4mbmNTEmbkWwquw4gg6oD9yTQ
Date:   Wed, 23 Dec 2020 02:47:56 +0000
Message-ID: <MW2PR2101MB1052FDCC72FE8D5735553E3CD7DE9@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20201223022253.2793452-1-sashal@kernel.org>
 <20201223022253.2793452-40-sashal@kernel.org>
In-Reply-To: <20201223022253.2793452-40-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-12-23T02:47:54Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=14b1380b-8369-4463-ad23-cc6073ccb7aa;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 59cd08dc-8192-420c-e1c6-08d8a6ed2702
x-ms-traffictypediagnostic: MW2PR2101MB1801:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB180145DE9A1D7AFE5699D728D7DE9@MW2PR2101MB1801.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5I0wew8S+nSXxg0HOJ7Iw8us2aN6ANZahDTknqPk+pXT/kIIxf8y0/q/2Pmp7Ldy2mziJ/ORlhcF3KSLU2xOWf4uVR/jgdphzEWw5MIYW05/HGEVcHxkGr3e/9QrXz9E+aRB49U5kmPQSnhDO/NWGuCcKOqGJmoEh+R7w/pxuvnjpBiG6VwiRju99GTMIKbsywGCLE7hb/Fpz7No16fPJfNmiAr5ZlC7KCjQeYzsjn597UosBh8+i/+aCij8cdBBBSastEgi5HuUJRce85O5dUg0uj8UJekgX+YDwT+9e3nd7j5d1Wop53GdSpqY8orQY1AdEeF5ZM+dAfDQWcIX266ErKHJeEnV31tY1L/EJOqpFF9PWVB60C6aPOOnd7h+WKZ1UTaFLdzUvIKYGeTDaWKHJTM1Ni1j+6CLw2Ffk71C5x416pqPcsgc7ul77f1IbH1Nm46jgFzEwTR0K24LZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(2906002)(82960400001)(82950400001)(966005)(4326008)(66556008)(66946007)(5660300002)(6506007)(66446008)(478600001)(66476007)(8936002)(186003)(64756008)(52536014)(8676002)(316002)(7696005)(8990500004)(55016002)(76116006)(54906003)(110136005)(26005)(33656002)(10290500003)(9686003)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vjWnBeoqrkcoxaFALZSsv9NMuUW/nRWTS7sP3nJtRb6sPQx7N+GeHeK5A62Z?=
 =?us-ascii?Q?ZVWU4mkFTPLkjCnmg18j16r1r+52eke2YE+jcl/uUeia/FXV2pV0Mg5B4sst?=
 =?us-ascii?Q?YyhphVxAbAK6KxZfyeF2MdLvTn91qe6/ALVEFBHGdVUYzpKW0+dCMByQiJ/b?=
 =?us-ascii?Q?gD0se2gTyOhRKZFq3tN2toFA9lApux/hdfaLy5vVVzPsiATR3bL2UPitbe3l?=
 =?us-ascii?Q?U3JN++K9rV70NLd0JKy/cqPK1DOyORis2vXTYkjWjtqG3MO6UfiNdwlKxDky?=
 =?us-ascii?Q?z5TiYbyPSu97Ivzx4E0g2ukefBLQrJEEZ5qrXlrFX9KVPNdqA1OxYHZjJVzm?=
 =?us-ascii?Q?M55dm+ENI1EShpk6SGVsowncphvFisdOzno0mPyiLUoZF6d+oAsCV31Bmb1L?=
 =?us-ascii?Q?gaYb7r84q1xSX8zXosu5TO/23v1CaPfkhew8Z2khEwhzRkt2rcOTJC0n9TQd?=
 =?us-ascii?Q?F7C7m7Jctimiql99uYP0o44lh5QM8UdsuSytrh13nXuUcX3ObsqrLAGHTTUs?=
 =?us-ascii?Q?Ol9YBMZUfdRdT6YX1SWOm4k/KBFk/kAfPW75SaVhIy/uCiJUgukIKoUdkvW7?=
 =?us-ascii?Q?Kxkdh+JSwAfvzb2nAjhxDI28hoUMI9SE5ml5VypbfjIDN1Vpf6TM28N0grNk?=
 =?us-ascii?Q?vdIzJbBwDd0AO35kAH/jkQ0IE96AYcxRGBGkH4xans/nysm1b9UZtClNcvb8?=
 =?us-ascii?Q?6lffkmY6ekL94P088qr5XbxO0N7BrOjlToWsFLFASZTsW20qNeUS+pDdxTxg?=
 =?us-ascii?Q?f67ZLs5tXw9OBPy8bMztDCG9d00HgcwzCfXOkpM6VcPf1mkW2RThgkUfJ7s7?=
 =?us-ascii?Q?E32LfKnfIQRLbFignKOmocIlNuONBE7bFIcvLADuhczISvAa0TX48WvDZANl?=
 =?us-ascii?Q?ZLod1LzHGxPJRqnuSmcJ55AgTGLQwQJrDLEW/I2l5r/6645OyUlVwAuVbEYk?=
 =?us-ascii?Q?qYJin+DFRtkBmR95wIqdHsB5wI71kXgpmWFJAKLMB4U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cd08dc-8192-420c-e1c6-08d8a6ed2702
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2020 02:47:56.3916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vm3riTGHwmFVZXyl6olN3RUPLZkFcjy9LnVDyFNQlXPgTZYTYaflFBujYeEOE/f500BDZ2Qqe9U+jm6jPv9IJiRoUyeoWLMaf/sJS/O3b0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1801
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Levin <sashal@kernel.org> Sent: Tuesday, December 22, 2020 6:22=
 PM
>=20
> From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
>=20
> [ Upstream commit 206ad34d52a2f1205c84d08c12fc116aad0eb407 ]
>=20
> Lack of validation could lead to out-of-bound reads and information
> leaks (cf. usage of nvdev->chan_table[]).  Check that the number of
> allocated sub-channels fits into the expected range.
>=20
> Suggested-by: Saruhan Karademir <skarade@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Link:
> https://lore.kernel.org/linux-hyperv/20201118153310.112404-1-parri.andrea=
@gmail.com/
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/hyperv/rndis_filter.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20

Sasha -- This patch is one of an ongoing group of patches where a Linux
guest running on Hyper-V will start assuming that hypervisor behavior might
be malicious, and guards against such behavior.  Because this is a new
assumption,  these patches are more properly treated as new functionality
rather than as bug fixes.  So I would propose that we *not* bring such patc=
hes
back to stable branches.

Michael
