Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BB14A4FD1
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 21:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiAaUGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 15:06:08 -0500
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:6768
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229534AbiAaUGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 15:06:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0ANX9no67En4cl59lJ1mDS6m0o21pepeXQ6tAKUrgsHvCpU77I5etiOYysJWowQrL65m6b8YtbEBhLzBcJsAGb8QIng67D7tMvbU0EXfkNrSPne+xZXGlXI2sToO5WdSiHDEwFa/RUTFd6b98ssmNtvUHJTtTsOqfl4O4+1cneYBZ+ZOiBsalsE455zxrS3B5Ng/aE6icj583HGQiUy+EM887pNYF+UR5PbIJbBVq3pN7a4lIuw+azbh+B9w6bF74cKAWhHZBrU8X2bwfSM4w+x2laG8szRrQiVpzWTyqz/HucYFZb/XRTEx+kDRSswUPpQMRDwdu+sSMBRy99A4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/l75HWt94P3qDYDnOa/lHyZABvTI2YpDUfRu7q19zY=;
 b=eQCyHFd7iB/nCdqJyiBZk97ULdvE09Ks+JMzcqKRP+v86ERVnpBjQN2/H6kozWOsqpx7nNhQocUXqrkm17r2AqdyNosqlUE6xquDqZtNr2hI4X589UFr71vyNwDD4a0s4OLM9FhZLIZztSWlVKQSJE9KztQnxBjy2QbsGsD4FqD9CMUXKgHjuHLqeq8wCYYQy6hURlkbJmFiNqMXZ9uzZAytWfub4KhsecbKFPpCqCYrk/gM8Gi8kbFhCSPG6j4jJpXQCtmQQ5Vte3IFzcXdoGJGhyIBKkUO3f1C5HqBFjl0K+VOiW8eHe7hL9gu5fJ0QW8WYq5Ce8FSQwU8Jbxg6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/l75HWt94P3qDYDnOa/lHyZABvTI2YpDUfRu7q19zY=;
 b=jhYJLgORNJiZp5Eeibjf/hfxK1hyuRW8vq+UM3SHn5xB2kMNXgvrVE1o86bLaFqVAKZNJx81tk2F/8YNAtFGX8JnjTp0xHqMfaCBFXGBg3e0y9JJHgczGZsJQx9d5vVNLQRTOQBLc6CIOXaG8CBolc6GhxwzZvgG3vlQeAS8PrY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6977.eurprd04.prod.outlook.com (2603:10a6:208:189::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22; Mon, 31 Jan
 2022 20:06:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 20:06:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Colin Foster <colin.foster@in-advantage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v4 net-next 0/2] use bulk reads for ocelot statistics
Thread-Topic: [PATCH v4 net-next 0/2] use bulk reads for ocelot statistics
Thread-Index: AQHYFIJ8ACyf1j3JaEubMb+rEidhLqx9kDeAgAACtwA=
Date:   Mon, 31 Jan 2022 20:06:05 +0000
Message-ID: <20220131200604.orl7da2oyljh626c@skbuf>
References: <20220128200549.1634446-1-colin.foster@in-advantage.com>
 <20220131115621.50296adf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220131115621.50296adf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84f88152-6ea4-4b10-ce2f-08d9e4f51d20
x-ms-traffictypediagnostic: AM0PR04MB6977:EE_
x-microsoft-antispam-prvs: <AM0PR04MB697758C10A2B4C3BDB35E99AE0259@AM0PR04MB6977.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KHzymhapRqFn9e0olWM3hurdwg2KuB9OJZzeU4C6oNs9Y5aO3ptjKOjpUtojrVemtjQDjUA46MqUFx0GoMUi3EnIrX52TCWnIu4ak7gKMTv/tR7QYtEwy1RJz3MP3CaAQu3hgeTRN6wmqDjGD4AOr+Y4LSteO/6dWFGXEPqKbiRkC/FUJjS95z4OUspoCAcd3umtisceo1Q3WuiI0fnOONOhKsMmZpDxc/qXWH7wWwTmqcGTCSAkHxwwWMV8uu47lu1HDFDYMLIXuOVGvglEVr6F7pXaFguo0ekuWjFz1rgffrV+gOQi7KSEGSnp23VgHOkLUbYfwy3iR77mOt3oAIFOC+tQ01YsUYx4vEGfm6At6ztcAvbcAh4x7opmhwyYaqc8gzYszZiE8JDTPUPuU6EFCELaGn02O2BwrdujxjsYlKWbP2n5SeGLFeuwHtENmG2lKSrrJBHXXxSzULxBwd1DeacpHxlgu0SZNXhMekBC2Vc37VG9k2p1FlsgicSgSrvuTuY2kQ1w+YDD5wJzrnEZscwDmZmaZ6959Ik3eyxz56pBy/n6Zrur+qEBFhddBv22B/ugf8BnwOE/6Gq6ZSBzOvFp65nK8i8pWnqpBasGzROTyG+bTb2DzgMyeZTJ2vWUHyKLWwqpIOCnghqD/DT2Mikfo7/nyeJ4w85AXQIKjs077A3YhfkoZDxolOlJcE/wplo2Bhe/abPY9j1mzL4CVSs3Yplm3kCJJ1q4dqC86zx0wojxZ6DItWlgYXh1gxT/D+ZRGytsEZPbjZapgiFaXbOidWZAnm5f2rTP//M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6506007)(6512007)(9686003)(38070700005)(71200400001)(508600001)(5660300002)(44832011)(2906002)(122000001)(1076003)(186003)(83380400001)(26005)(76116006)(66946007)(54906003)(91956017)(38100700002)(66556008)(66476007)(6486002)(966005)(86362001)(4326008)(66446008)(64756008)(8936002)(316002)(33716001)(8676002)(6916009)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jRlLcHQ70YyEteVnlnZPLy4DpMqghzAYDgbKykTQ4WdFKsNXZwqiJbc7+sqp?=
 =?us-ascii?Q?yBLON7lMG/0eId9Yzd8SqdHzhRm5ImC3Xoi9ncy2Lk0cprIrXk3+B5Z1whDF?=
 =?us-ascii?Q?tcThxf3muNUm8oxFVYgumUeuoXVgvtAXOlQzk0kmveKWgnu/VtaCZv3Pb/zw?=
 =?us-ascii?Q?HDmk2v5tAUAMO4xzNSLpNSygHlskDc5Msp4VKExd8fBw/SJNKBsElH+7EIaj?=
 =?us-ascii?Q?L5I6HaawbfoSCoxDvGo6gUK2N/Ez60hKdJroa6NrtEQG7ymshDIGACFnCgsM?=
 =?us-ascii?Q?beB9J0yPXJkDN1xo3rD392Th0H6gA2iIf8Z625m6l7XIipMFeGUgSV54MLP8?=
 =?us-ascii?Q?vSfaGAHCxSLWhSlrq+4D6zLvY73AXMbvG7zI2qoHt2TKSDgx0nyiFbSCFx5x?=
 =?us-ascii?Q?VFrbNsj48rYdSRG3ck7rgD1edSh0kVTCrcakuhpwjfExLw6OZbVO2e6v5ux3?=
 =?us-ascii?Q?9dRzjIcr9URjXYGHf/OuHkvC8dhHUTWVgvPY5E8zj0lK/MOMnDyu23dC8M4D?=
 =?us-ascii?Q?3/3V08g1s1S4YVPdK34eR5vSJqJZXoxOsHLZUhCUVU8G+xhLG2oaGDrx/66i?=
 =?us-ascii?Q?4Zscn38WTRikXlLEVOCqzILHcADT/fDj/nSYqwpn5X8XPNDxEx4wjVl5uSCj?=
 =?us-ascii?Q?kCfi4entySbRPVgnrfE21WH5aBmyCA4iW4yyvSZFdjLB4Nxb53MTRhI2TWg8?=
 =?us-ascii?Q?W8OvYTP2mjlxYa9ZV7GD4An6m4uDbaMcUPk+55vW/3KGL1BoD4nzSuBSTRMV?=
 =?us-ascii?Q?TN1nVzUc4CIyWLBCSADxD19UUZcay08Ynm9gtAvrqEX9EqKd8+WQn5V8cZif?=
 =?us-ascii?Q?/2feVMM5ZHBNEl6++4/EEefU/B4Mecrp1oAybojqimseiZ8Dg+i4H2xCiRk9?=
 =?us-ascii?Q?uXZ9pMLSdZ7RZ7oxWX2Jno6q86uIBxUY5wZsyKq97b5t7SyYpFG0lFl0vrYs?=
 =?us-ascii?Q?iZnDw1iwlF+zmDzHa/gtPGjAs/NQ5wyICJARlUQz56Rbmh4rA3qAkvJl+60n?=
 =?us-ascii?Q?yqSHcX1KIyLrkdeymQq3Dkrpz5T02KVlQNXm36VH95xNlfgbJdd/EdQGg+j0?=
 =?us-ascii?Q?HIyv7EHEwAByFGLAzoO+mEY3RdoVm1MKFoixWFlCf/1q30qYW6u0XEESWb3d?=
 =?us-ascii?Q?/O87QjT+XPKQoojqt87hgis+XaUEC6OqGK7/lPegR14aoE6qaYXnJMU/lAT3?=
 =?us-ascii?Q?pjhSkzrakMWONkuoBbL0IbjLurr/Lr2ZLxCe+8IJyNeIAY4mIc/aBlBpHs2P?=
 =?us-ascii?Q?Y5vD8JwR5qTLm/4vxwAQ6Yji/lBsWUCF+Wq50jNYVwCcNhsGaKypa2YzXT46?=
 =?us-ascii?Q?EeEkKRZKWP2XvfKobyy/zuGOTAfzUEs6+16cdKeztW7hqPlgjsCpm4Jk8PDC?=
 =?us-ascii?Q?9X0bO7QX2dbDE8sgX4h9PHMfrjp7hHYT+0SIdYfpdxJTf3sw7FxXzQtvoV5F?=
 =?us-ascii?Q?PqVrSYUVZtGPMUEoSc3bF9CtCMgGLllMKV/jt9RjZhJYYTzb4JHlvgLbnEsJ?=
 =?us-ascii?Q?RHaaNpu/lc92CJIJj64AiDHr/aUymw7MQ++zOTLo3TLmcKaH3/qlsj+s8Fsl?=
 =?us-ascii?Q?SfLOKHgmL4rv1g5T5dT83jjctXpdkQz5kTzI8xLb42ghktJaN6AayqAiQdrb?=
 =?us-ascii?Q?xu/EizyQMYoknbTsnMeSbNI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <933FB3B4C9FF0C4CB60B42316FC2FF73@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f88152-6ea4-4b10-ce2f-08d9e4f51d20
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 20:06:05.5195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ffxb5K0dCRtCB2YZ/gIyxkvMg5rrgjnmq5+EzA9/XbGIsS3U1v3YL+nyge4O2WBO968H3rv7tfvIIZn5DIG3QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6977
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 11:56:21AM -0800, Jakub Kicinski wrote:
> On Fri, 28 Jan 2022 12:05:47 -0800 Colin Foster wrote:
> > Ocelot loops over memory regions to gather stats on different ports.
> > These regions are mostly continuous, and are ordered. This patch set
> > uses that information to break the stats reads into regions that can ge=
t
> > read in bulk.
> >=20
> > The motiviation is for general cleanup, but also for SPI. Performing tw=
o
> > back-to-back reads on a SPI bus require toggling the CS line, holding,
> > re-toggling the CS line, sending 3 address bytes, sending N padding
> > bytes, then actually performing the read. Bulk reads could reduce almos=
t
> > all of that overhead, but require that the reads are performed via
> > regmap_bulk_read.
>=20
> This got into Changes Requested state in patchwork, I'm not sure why.
>=20
> I revived it and will apply it by the end of the day PST if nobody
> raises comments.

Maybe this is the reason?
https://patchwork.kernel.org/project/netdevbpf/patch/20220125071531.1181948=
-3-colin.foster@in-advantage.com/#24717872=
