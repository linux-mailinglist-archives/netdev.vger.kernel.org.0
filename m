Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BE435BC47
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbhDLIfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:35:53 -0400
Received: from mail-mw2nam08on2130.outbound.protection.outlook.com ([40.107.101.130]:47520
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237350AbhDLIfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 04:35:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TchIH39emyxG+PEIoAldyBDcZ4y75gLE1xwTd21isWFM0SZ08N/Z+QtDskUAduFtO2ruHqyaLa6nSdjeg0WJhz7biIp5HldslaSgKFDt6TtKe1MTOYeIEeS+xD2lIE1LrBnZkOw1Wz0de+VzHsVtQcqYDrYG9c269PyHgu6kTZF8f+SS9p1oBOQfeiXHSfcEUHkzmfNQk5qeO/4QBrrIpkOUeBOCy8w17xU6sMuMWCAGZGsgy8VoK06+D+QTEfic18X6w6K1z51rdhjdkZ8fAjluub+wJZqF/mVC2oRG86lmOTpniQZz3Zz8mcalrwTkIAYcJCVH8Slq/VlFxSCGoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZI94hHnGZqxgOMxnl8Et2AK29cHRN+NQykRoVlr3fk=;
 b=dxUS9F2K16jxktGhF4Wcs7R0uQM25DxtwlRIfszq5/Nw8M2/EIZFKR08GsD3L56nLCpftkCwSTcq5tfi6+L4/PpfdpC7jiSHuq6f/6UoQYcDVqZlf9tEufoGQpoZbYBCRCRBl1up/4AyssfTPX/hfV4BAuZHMJJ3lzzP4mhMJlrGMwF6d+txn/IR3N1PbbTkp2aSn+ob0A3KolpVlaOEUGEqn/lEB9alnVF3wCJAopE9iXngEbPidfHMiCBWdSuycXwiRcqqp/hw7Im9k2/9WVmUSnE3mR6OWpkibDgVn4wVrfCjGRMp/vvdUzAMKKoTsGwvWnaxC8XPdPMa+XWCqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZI94hHnGZqxgOMxnl8Et2AK29cHRN+NQykRoVlr3fk=;
 b=JrMzg7abxQ8+PW+tBPFNoXSL1fBhsvhyWClZfcibOOGLpuLtFqoINGXEuFZYg1EFWIoKNaGz1dfeRHgh4nc+lGaMPQcMA7MF0WsY6n3CQ/2XqIrU6XgNk+5w8U9BnHzFtcMPSfoxZ8QIhaS0IUvub7yW4DIId+2eDj2K05GzbEM=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0142.namprd21.prod.outlook.com
 (2603:10b6:300:78::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.4; Mon, 12 Apr
 2021 08:35:32 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.010; Mon, 12 Apr 2021
 08:35:32 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXL2/zok+TxRuwHk2RzEnwF60u5qqwht+g
Date:   Mon, 12 Apr 2021 08:35:32 +0000
Message-ID: <MW2PR2101MB08920145C271FCEF8D337BE2BF709@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210412023455.45594-1-decui@microsoft.com>
 <YHP6s2zagD67Xr0z@unreal>
In-Reply-To: <YHP6s2zagD67Xr0z@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=526e3c65-3877-4cfd-888e-135257d4baba;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-12T08:07:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:6473:731a:ac25:3e78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db2a4a2f-a0c6-4287-3553-08d8fd8defc4
x-ms-traffictypediagnostic: MWHPR21MB0142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB014245FD353673FE8B7978ACBF709@MWHPR21MB0142.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P3AxOMo9WCqBT8f941TbWmYdaozZkioW/dSw9l97Bo+RXyDR1ZVMxfCIPfCu0vggHqkQSmUFs6JHGAOl6sC6Mf9c95YKQKtvs1klpnZ589Lghn1NH8SOTAfWr8ZNCuNZdo05Jrm7oVDtY8mugZ7dUlcm4brbqFZyFC2XdSCyeDSAxvSODTpaVJ6LTKdW66Z8tFjps8Myd0ba7q2xfG4eTodX6LvEE57tkOsaTCucRspfGy9rKCykyDKI1CqQuN+I55RfeVRl4dwU5LPSYNthGUJUueifOosVkNfV/z5If4CI1P1V1GNsH1tEIKQIjE9s/bhGgZWUQX+uojtgALlUnlCAHkCO4lDjReusMRPM6db9Dr40XAXaNdx3NsC5b9vSkDEdq8FRgAti7Q4Y5Z4+s/aQoBPV0tVCQvwCqCGRTrKqJ2TmIoJ//zvInkr0q53dsKmduwqRhzyRk8GOijJPI8txr9nSVSDx+3usSL/JPP1z8uRhdWoNnAwEFQwxz7XdAfGBhoqm7hEXFXAvNY0gDb4cLt8DmPrLov3TSN9fZQzMLjDHialOpTzUdj2jbxFNJqW9Fuv04V7kSMg3NL3DW0noXDx9BfaKMVDG37vV12A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(47530400004)(83380400001)(66946007)(71200400001)(10290500003)(478600001)(7416002)(186003)(82960400001)(54906003)(2906002)(5660300002)(53546011)(82950400001)(66476007)(4326008)(86362001)(66556008)(38100700002)(316002)(66446008)(55016002)(8676002)(9686003)(64756008)(6916009)(8936002)(33656002)(6506007)(52536014)(76116006)(8990500004)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?r1WlxYqRbNgtsL038W4tj3enR7dNAVYxMBhKQOWeWJ3H6ORtG5UliKHYZ7ap?=
 =?us-ascii?Q?N0Kt+R6tVbn7LvAHL1yLMDO7+/MwoxV6OSr8QfZy5/VoRdf4r5XxzqkoY2X/?=
 =?us-ascii?Q?qrtuGuyEOhdTj38ICpVKH4lMSyqbWqV51op9/q/3pdorAwt4PzneLq4PFbff?=
 =?us-ascii?Q?cJJrlpRGIYJN3Imc1B+K/1NhFUMHSfDOOPkbX7taWD5yzxH+T1Ql3kcYd5BV?=
 =?us-ascii?Q?l+dS0W77jxyCT+me/Afii8sxTFNPMvcG/V8BZOsjaCwGJoATuB1dvI9B4fkh?=
 =?us-ascii?Q?q8RLmEoQQy/5NMyDPX5CT/R7m1KC1KoiB5BPkQSsRDqqT6RHRYxRH/Xs/1RJ?=
 =?us-ascii?Q?4jj9/qwNXPhxlJKPlRP1kzrUC2ibuVxujo+x1tAmdHsRNyOJKRkLLy7cC9db?=
 =?us-ascii?Q?O48ScvVHjUFGwTTOkLffsl71eleKHSMrlRPLDU2rehDMtEqH6NyQDjIUR8i9?=
 =?us-ascii?Q?+MdQmDGNg9ylNp8Lnka4pmWPP9anHCZ65T5WhLK6MApa1cNPTP6ULZmztd+l?=
 =?us-ascii?Q?NdGoGj4bffkUtqmMk8p/gvyBsaDiqtuoaIqTC6y91ZhtpA0oxL7LJXwuK0V7?=
 =?us-ascii?Q?2zAq1cfpIAS/Yf3P9l2nUbVdSC83f4JIAwXkZsH9iSK/4o+MAcBNyWKETxRs?=
 =?us-ascii?Q?FWYG7y3aj1ok2anDtLtP0/hMaTx86DadBuZ72f66h/ZPbgqJQznD0ck20dKI?=
 =?us-ascii?Q?QgGsamK5+EgfPVEX6eLbRkuTFEG8Ri4PGjGhY9qm+JIIqbDkrZU1zJe2ZGiW?=
 =?us-ascii?Q?5Qz4rqMytFx63Z1RLoGtwWF17+k0iq2ixdXr8DcNqPukBBXylyIFgUMDO/te?=
 =?us-ascii?Q?FPQ+4pwkcB4WCQVXodL0Q4uzRCacoWxX8JTrp/Q54TFd9F2IWBHjge6QkJlu?=
 =?us-ascii?Q?DzS7X0U79NJ/ffDVkjNgCDMY4sXtUtQ1T7I3+BU2PkEM6tBAgCoXbClUpeFs?=
 =?us-ascii?Q?YnBjcRh7cM3E9w6KHdrl9jb9NLj37DyD1iy1jIE3UDgfSV/GTNKWOMmKd7MM?=
 =?us-ascii?Q?i2Mf2uDL/AWsfrHQPfE8ujbgY26nbTivyqzLMUWczXN3jtwpQ1e7Srs1orLU?=
 =?us-ascii?Q?48fzHdbKyOnm/5uk3s1XnSmdu818wnpRsY45SgWHCPcCMNiavJug+t1xWH5p?=
 =?us-ascii?Q?qjBAKbll1X1+EAbmiKEsIekOLvNS/UNOY3KCWSqriJgG3y3SWD61g3h2oKF3?=
 =?us-ascii?Q?BNGTF7FE7nve8LoT1zXewsJxZ2glTKe92yZA4WqnDBhlfphY4FVJYb9mnTYP?=
 =?us-ascii?Q?Mi8CWI0yx6ha/ZgMUiPmfYCk/zt8yieBbmSigNTTurIbCsfUWqOsT6w3hnqa?=
 =?us-ascii?Q?Jp0nh47JzpUtBnD/j1i4KF8/D4VGZkbEHe/Kj0qdMC3zsUNG60NW0yOSRckU?=
 =?us-ascii?Q?qWzQSnmWqC+dieqbgFxPD4NhM4Bq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db2a4a2f-a0c6-4287-3553-08d8fd8defc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 08:35:32.7174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q8k/wl8s9MVi3M5SqGN1Ig2qcNpS7uapjYkhEB3IVmw9W0lCsjPST3R2JdSwhJGuO34Yhe00J9Zb6+MPhw92OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, April 12, 2021 12:46 AM
> To: Dexuan Cui <decui@microsoft.com>
> > ...
> > +#define ANA_MAJOR_VERSION	0
> > +#define ANA_MINOR_VERSION	1
> > +#define ANA_MICRO_VERSION	1
>=20
> Please don't introduce drier versions.

This is not the usual "driver version", though it's called  "drv version" :=
-)
As you can see, the driver does not use the macro MODULE_VERSION().

Here the "drv version" actually means the version of the VF-to-PF protocol,
with which the Azure Network Adapter ethernet NIC driver (i.e. the VF drive=
r)
talks to the PF driver.  The protocol version determines the formats of the
messages that are sent from the VF driver to the PF driver, e.g. query the
MAC address, create Send/Receive queues, configure RSS, etc.

Currently the protocol versin is 0.1.1 You may ask why it's called
"drv version" rather than "protocol version" -- it's because the PF driver
calls it that way, so I think here the VF driver may as well use the same
name. BTW, the "drv ver" info is passed to the PF driver in the below
function:

static int mana_query_client_cfg(struct ana_context *ac, u32 drv_major_ver,
                                 u32 drv_minor_ver, u32 drv_micro_ver,
                                 u16 *max_num_vports)
{
        struct gdma_context *gc =3D ac->gdma_dev->gdma_context;
        struct ana_query_client_cfg_resp resp =3D {};
        struct ana_query_client_cfg_req req =3D {};
        struct device *dev =3D gc->dev;
        int err =3D 0;

        mana_gd_init_req_hdr(&req.hdr, ANA_QUERY_CLIENT_CONFIG,
                             sizeof(req), sizeof(resp));
        req.drv_major_ver =3D drv_major_ver;
        req.drv_minor_ver =3D drv_minor_ver;
        req.drv_micro_ver =3D drv_micro_ver;

        err =3D mana_send_request(ac, &req, sizeof(req), &resp, sizeof(resp=
));

Thanks,
Dexuan

