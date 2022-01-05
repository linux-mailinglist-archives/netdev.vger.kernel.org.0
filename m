Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A155E485895
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243112AbiAESjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:39:45 -0500
Received: from mail-eopbgr140075.outbound.protection.outlook.com ([40.107.14.75]:62434
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243156AbiAESjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 13:39:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9FI+pRIlmoMAWO2PttNk1HmvOC7/45rNVynA0ew5hOxrv0oHh4ERL2NtHOfKKU2cWWznmiNnmD2Yc+l+vdTQZb3t66K18UTdJR7dlLbb/+nzTrOahVrml7StsJsDaH6RftpyL/IgaS8rRXjVQIApgTZqxqZV37ErnovQCz50tsebdHGoFP/jvazmRc/GYIhuhJeGJl5qLaqCqS3xICKOxiGAkyCQKQwxF7yQk821kdyi170pDDJUJBq+FZISfxVMx5act8kow2Js3cOw1Wupx6hnpXuy46JPuiNTNhRtLSMHwO0psVg+NJg8am1QM6Y8T9ty12E7DdAR85MtuT8Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gf5e/Zd63hOZksU0Q2KDW6Dm3ICh4simKu2sSUMBgZ4=;
 b=GtgUkLh/VFBitU2K6NanaHSvlq1IjYsjyDwPi0thYaT6+vJ/uomBDSsgrOkMmqypPfnS1BtkYr+h5/2BVcp34N6Vizw5Q2pWmpaWlEMtsaefHx8TkelWMShuLCAD6V1/IGUAq0AzqeYHq1ZVUgIfgNzFffRk8ijviujauCdPdf89uFUWJAL31CAGdzzL3RGaKvVK0T0/bSQp9/5sfsXfJyfMp2EivrJev6oDlDMr2qqqRH5Zpk9Zr/CAWpab7J577pg2EBL5X+x1Qdo2ZJsg4zmhVzg1T8uP4sEXcsSSlfVaof3LTDEo0NW5Ot67Z5E7PxbEetm/PyvZIO7BCcpoRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gf5e/Zd63hOZksU0Q2KDW6Dm3ICh4simKu2sSUMBgZ4=;
 b=U3ESxJujnQgoC0D/MxJeHjLXOkeL4FigMxMQR4SYyqRnoEITo7N8R7ToH63sVDlu0SufW2ksLe0DE/gRMYz2qTttgnfTQxZiuKXFnUlMs5h6RrvBOt4zlPQ/+Y1FoEKhft2GsErrLyey8YC2o1CijJ8UWKT3JPIB1IO3x6eDEFQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6013.eurprd04.prod.outlook.com (2603:10a6:803:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 18:39:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 18:39:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct
 dsa_port into a single u8
Thread-Topic: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct
 dsa_port into a single u8
Thread-Index: AQHYAjc04aU5hROR7Ua9AmYaIwi8WKxUwFAAgAACbAA=
Date:   Wed, 5 Jan 2022 18:39:34 +0000
Message-ID: <20220105183934.yxidfrcwcuirm7au@skbuf>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-3-vladimir.oltean@nxp.com>
 <d41c058c-d20f-2e9f-ea2c-0a26bdb5fea3@gmail.com>
In-Reply-To: <d41c058c-d20f-2e9f-ea2c-0a26bdb5fea3@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa8e03ab-0cf4-4ec1-81f1-08d9d07ab887
x-ms-traffictypediagnostic: VI1PR04MB6013:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6013207EDE75C28BD9A1F106E04B9@VI1PR04MB6013.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: buhiXKUF3rv8PnZ4HRPAOBajVJGdJlICEJLS5NFjrSUAjyp0lEZgJbj2aAPvcM36u+/S7VX922qTwfP5FsZgxXye0f9PKKdQCWPEP/5o0VCbrrbcWba/Nppl8F73B3s075DvVHYu8D8Ju8encpOrVUxyJ+t/TxnRFqT0kNgZmAoD6kxm4uKDCGfk85vxEJn2q+Cj+FhgRXYihNcvg6doR1dwgUtf+ybMUwEir+dxh18UXc0a0fVPJC/475/zLr4uMz5OZfxQXxW4ERFyUsjnN/V+ALtP3zoiqnLOuHpnRH8vY7g23qkvpYEKMyFv5JSHDlhhivc+4EM3ScHiFeJOPUDbDGuHQiq/yJA89obsI/4FZACrxJnMh2sp49ANAP30xBe7b/lgetUbeF8ckRb03f5iNOeG5IrggHk8klLTwJQstka0/femkytt8iXYKgtjRqA+GEqDjhchtiw5xtlijXRBIphch7rIDjdrCgnVqA6+cSSvQM8Pr6Dd+vrAhc7t/UPpjfQ7c6GMTX7wsshETW6tkgTl4srSJphzyeKzJtGz0+q7bXTcUC2IaewqjAPFsXUXan/K3F1xSwvH93CM6wKMAT0zT+gsNOZ14r4K3hmfan9yhUdT2Zh8JVrG4++D3suJI6ZELX6c+gaRbM2zVWxeSpo5jL3jsJrMdQzzfLjghnTck5TWBNEQcua7lm1W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(4744005)(83380400001)(66476007)(2906002)(66946007)(186003)(508600001)(6512007)(26005)(38070700005)(6506007)(8676002)(1076003)(5660300002)(76116006)(71200400001)(66446008)(33716001)(38100700002)(66556008)(86362001)(316002)(122000001)(64756008)(4326008)(6486002)(44832011)(8936002)(6916009)(54906003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ILkN1yKEACpXYPksYxWhoh9iBPWP2rh1rJ7TdKmGqUQzU1YGYkYyGDOUuNux?=
 =?us-ascii?Q?bhqZ7MFgaLfw3ESL66SNRQ7TG9Lin3YBQ0O5u412tkmDI9vog2bWCcWd5IRb?=
 =?us-ascii?Q?f73HNKY2+kQ71NsZbcdTp2eecUp+XUazfdD8kziAENllJzDLwwAJ1Ln+1WXA?=
 =?us-ascii?Q?HZzRs5lsRpLdntt66x8rsqfUKKgjzj6yZ3wM3t7kR6IHrgsZMNWTkYoncPJs?=
 =?us-ascii?Q?BcpDCK94wewUeSHSkkRbj+iCcLRX2btVPHpiPwRvvIsBFiTaAZ+ycM0H2gkk?=
 =?us-ascii?Q?DYBkkonZvNMfiji5UU0CL1bQWCIT95QX0Lh/jXDwe1afnlm/IhVZJBOMB0Ok?=
 =?us-ascii?Q?VNDf1lGJOF4N/ShEw5yWrmigRBw6ZUNEAl9r2wKmFK5fPvc7F5f6UwGAROjf?=
 =?us-ascii?Q?QruvgeHtVet9hZaU76Qz8IFg+yHIQjOv9Sl56HZpCWyQCqX1XnZDbvIUrpEp?=
 =?us-ascii?Q?17RgdUL6BWYABOCtPPH1pFpI62oN/14mtLjH9SkBnVcHK4jCKo5k5i6yOjyx?=
 =?us-ascii?Q?f7CQNfNx6OTJ0okGO/n8QOtGuWZTQLF9O1Sn/bQPEyjNzIzpdLm1gLY9gSy5?=
 =?us-ascii?Q?LyHKEpduYTIDP5JZ1GGmGHhR8O5VlT1FBEHpQFv477RVHau7UrVa2VLZ3kRJ?=
 =?us-ascii?Q?3QZ+HJfjEFeCGn8S5w/BpFiqiU+aL9UyLdHoe4/VDYWIaknWCfpOBFZ62EAe?=
 =?us-ascii?Q?dHp/RlngRExfwO8VJcAGW281JaE7ZUuxXLov9Pl1o7FZwVbH7jDRLw2q2W1j?=
 =?us-ascii?Q?zHSV4JzeH9PtMc/4Azl2RK30UFw4+CYUTGvf+PDwKNjc0pgPwgEu4SW+J4Mj?=
 =?us-ascii?Q?1siJXiRKlKRjheNg/nh57/k00jtvB2F6aGSpi/kPTCnTA2vCFtGLPi6cDJKU?=
 =?us-ascii?Q?ipzsXUXwbeY89wA+yZYP25ak2Edxjxv32Po/7YnSDHMJuHEDAJief7kbcpE3?=
 =?us-ascii?Q?TRmG6iwQa09oI1bfCe4anayD59H8ggcHHwgseNY8pSMfF6uaGMUOBmmE4VoB?=
 =?us-ascii?Q?A0VPy5JDfL72T/+j9c6n+T69jLDrZb6+OEoFy1bNhmnMatGyAMjYCKbvAw9Q?=
 =?us-ascii?Q?dFMFQgF8Lo5XdZWRT+H9LiWkTEn998dc7XseNUsKSFMU833U1rCSbdxcnIZH?=
 =?us-ascii?Q?mRRH9qL2RX3xjSRRNGv4n96HD5k+R5iY0k4hX/izC7Zz7XgO24XlJf//qdCT?=
 =?us-ascii?Q?jpd4f7Zp7wuPyjH5uLsWQfidpNyRyVIT8M+2r3crLJ1oOgqXudyk0VVrEVCK?=
 =?us-ascii?Q?G00yWgAC5MYcjUeXGOmj7XM26CJ638MqFXDT1yxzZXhcFm1T8+Z5b+awYj7C?=
 =?us-ascii?Q?oA+B2W/D5ZNeQHcpLkMO3RzpDZaqARmbvUJjXUifSxCjEfAAI7oqOAwKF7ov?=
 =?us-ascii?Q?0te/5NeDG1pT6PgNhXEoQeExGSdwmwsELyyfLlS/r9ceCEP4MbayYKTXt3k3?=
 =?us-ascii?Q?37eayyvKLCp85SqZ5XZmiCguJm4EB8U6PVBaUFBDEhw6azMygOfQQIkcCdPk?=
 =?us-ascii?Q?jelOCiDnAa0svv6fvfmJea+wqbgOk4aNJGKnIBiUQPeRtXrA2/X6aEsNdX8V?=
 =?us-ascii?Q?J6txMSDN214V45Uu4e4nzqyefQF65ipfIEi2SW6OX3ZWmtMEvqyeagZme5qp?=
 =?us-ascii?Q?xGvwcuoEC306Q3Veirye12Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E83F98950D5AAD4184527F43066499C5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8e03ab-0cf4-4ec1-81f1-08d9d07ab887
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 18:39:34.9643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZaoXvVD3KuVcqIuQVwe061MoFsljJem6IoQKhCGQd6M+q4r6hZ4df/ugyBBVNCZzM92cpIbGHNtDGQboSWHFKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Jan 05, 2022 at 10:30:54AM -0800, Florian Fainelli wrote:
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks a lot for the review.

I'm a bit on the fence on this patch and the other one for dsa_switch.
The thing is that bit fields are not atomic in C89, so if we update any
of the flags inside dp or ds concurrently (like dp->vlan_filtering),
we're in trouble. Right now this isn't a problem, because most of the
flags are set either during probe, or during ds->ops->setup, or are
serialized by the rtnl_mutex in ways that are there to stay (switchdev
notifiers). That's why I didn't say anything about it. But it may be a
caveat to watch out for in the future. Do you think we need to do
something about it? A lock would not be necessary, strictly speaking.=
