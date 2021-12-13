Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADAE472BBC
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 12:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhLMLqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 06:46:09 -0500
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:45154
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231452AbhLMLqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 06:46:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwaCpaQff18WcYGSUVZV0HBffWwJxeFtm70+/p27BiCy/YkG4sOI74iputmVo19yB7p1y8wjKseisn0gdRpfioAPmhM7ycrxZ8zDlsLEJjLBSnZsMN9tR84JsBYD0Y8obfsU4oDW6fdHKbQF3UIB7otAfloa7p3W0oV9uJ6eEWh8qAs/SA6QOmIls6EswKuKOXRg8E4P9nVaIrTtJExQ8deZs2sLHu94wu7YRTNfGuz4WlXNO7ozGyMihxp89obSuVgrJtmTBq8WyaF2axzCO7vanRYpBLXsRY3lOSekiubLR8PcAvsGj6jySJQTeRn8DQuoZAs2EugKpaF1wizdCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0ohea10PJQ+Tx5KQVzoRugjCwgVQYxdStfEEi8czdM=;
 b=NmTlLZxhEqedOBLF/OCi17mbvHUo9gkN+YVPkVePDaPnhezoeWCXqcwMlRaR4wpVqwdp4RSt8TDi4oTO9d1Q+fcs/3X365YzyOwPnuZnisYsTujoKCDTfjHWuoQPIWAuiIPzzK+EI74c8cVjxoPRohCUS/aASbdtiSXTge9T4lTfo1FEyewfSbYkNAvGoh9w93Y6iv125sB2Kec2Hoct/v3bXC0iNBDHL3f45pC/HEkSt/0T9AXUp/0Gc8PqHN7Tnm3qSyIZaw5PK0OwCd+wmwrwsN99wU21GGvGs+agkYO3XefH4j8Sb7E+u93NDerUmyL453hvKV3kb1+qSgc3kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0ohea10PJQ+Tx5KQVzoRugjCwgVQYxdStfEEi8czdM=;
 b=AXLZEQSZeGTMEyH/mEFdPLiOSUWhCjAvFp9bZzP783JcDChF5c8UBOcVKV8QYYvorSj/vsHVPWzYcxZ8AYfXtWMVcpTNx/309AOy5C3xCRDMgJq+taFSDtFWTQ7zafArUJmXB/3D/1nJLrO7qT9X+e3dsOGBTKqP3g0tHlopqEg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 11:46:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Mon, 13 Dec 2021
 11:46:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Topic: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Index: AQHX7OGqma9W7JTLPke3A5iwt0gyh6wqKbcAgAA0OYCABfZPgA==
Date:   Mon, 13 Dec 2021 11:46:05 +0000
Message-ID: <20211213114603.jdvv5htw22vd3azj@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
In-Reply-To: <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3e70041-e660-4548-e435-08d9be2e256c
x-ms-traffictypediagnostic: VI1PR04MB4685:EE_
x-microsoft-antispam-prvs: <VI1PR04MB4685C29314589F073C9834D5E0749@VI1PR04MB4685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AaLdcrJXEuWBYhO/p3rjNQjdXzWFL/wlVCJ31tGd6FUH0ry4K4EOd28qqNgs5DJ1wvtmdvEunFh6VYk8IwPGDMOeTSOEvdlqxLx8uW9PVDMN7yS11xi2DCp91y6Uem6Oe3kSc93je4jHc/luT8Tm3ltV5AuKHpLgdYL6Ucy1nhglBHkAWXvnaYDxn9oQw45LNt3PmJR/2G36hL18OmMutldljDrtO6vvRueAyNBUuPTWrusTfGI0gF623swRnY03CMBB4HH8mISSGL+ARzsew4eeb2P5/g1Iindsz/UkOpLyRPk20EykQqJFXrcHAr+2eC/oahmhOdmaeWCryyVaMcBRHXz3d7+naN9sfVASJa3SrTZozNAC3K7BgvkuoWEwVaNK8K5uPYxCTXTUry+eJBfJz6L2AF145UkKkJVoOgtnSatFMHpO7I687wn/+SapRSu3jvWcW8NyaL9oap+7f+hJI9FAmubRe3O2SBy/d2VRXGnqWk6InvIRJigT+lCXcocQJBFWjrRa6Jau4lj1iF/duCsXI4hvRXrgQMNeKZufuLw0WYPbWqElD3Wz1MXVGS2dtcziUITAE/3xwOkdJIVHynw0v1wPqQPHdLbu5XuGthPFwHlDco8AMI6WWRyfhPwd1racoWEtRfkqz9D4R7Sz9xvp9XO4HJnWU0MW7/Ops2m7JuPw+UzoLOI1J2ZhkcROVILV+RMIeqN7N8npLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(64756008)(38100700002)(1076003)(8676002)(66556008)(66476007)(66446008)(186003)(76116006)(26005)(316002)(91956017)(38070700005)(66946007)(508600001)(71200400001)(54906003)(86362001)(6486002)(44832011)(122000001)(6506007)(4326008)(33716001)(2906002)(5660300002)(83380400001)(6916009)(9686003)(6512007)(8936002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GgpjhJ5c+6+9fb8bsADDbmsi4sjd2Jv9ycLbsErfm1bVG4AthXKfNx2p5yuG?=
 =?us-ascii?Q?5zFk3HMatGu3CFX2HTXbKJRCwrTqfHNFrLaBIe6IfnnIfVKNKCeCOKktFf6J?=
 =?us-ascii?Q?u/9aQ5+ReulmoABB3yW/0dTyNfWchp1PUNe4jKu+X6tvdfcEllVG/Z1l1EZG?=
 =?us-ascii?Q?W51XqSS296FUUdePG1MSovQNQRmKoqMf6MpEIRuzBRjkmTN6FjticaSMr+8i?=
 =?us-ascii?Q?B7Scew9GYnHrCST6yAFfufMqFLbgYmIDEQDtrB8pslVK5wdYEoG/Zchut7JT?=
 =?us-ascii?Q?ySC3KZOV2brjPHmtcXPuoVTzMdvga3RwPlK3sxicrokkIg33NLbrVZWpPob8?=
 =?us-ascii?Q?xgmh4BTp84q4YoLbYvn1+U/GFFlPqnIxdjBS/1qxIqcsct76zxnTDTaujvgw?=
 =?us-ascii?Q?GhZEZono1DS3x9W8J7482nEEr34VhQdjyWnhYs3qxZ1biXjFgJcaXxk+9H0E?=
 =?us-ascii?Q?3ivS4RHl9bvELMIgx5Os+mSDG/D6STiN/oqCzeK/VuiAHf+aXo++qz7po5XG?=
 =?us-ascii?Q?MnM97H0z7Ot2VP0hwWlYL8iEonNBdSNF2H8A7eEOnbFElrvDNUN39FIfHFWj?=
 =?us-ascii?Q?bGmB/W8cR7HtQdqIVakY9nHG+Yt3OOiI7qBIqEA86vaMoxTbV78zCr0HKkMp?=
 =?us-ascii?Q?Z7IGAVIxe/E83VRktBGnaKvVDBLJMNitZehmauBWG2fpTxhn2UoEpS83G6cs?=
 =?us-ascii?Q?3mF6fx1G6xdwDcfrVHwz/TS39yiqLQ06V3DFWWvyAqUo1nTLx8dzaAkSEI1u?=
 =?us-ascii?Q?lMdZ8CDpoQ9WhfMtOzi40pLfrIRPpLnTUqZTqgd9JDDcMYOa6u2AmztaEEB8?=
 =?us-ascii?Q?mvHYQ2yC9fn8M91hWZNdpuivVnG1IU4Yh0lPWMZPXZyaTI55wsZLvF2i2Fo7?=
 =?us-ascii?Q?/1vk8mDVu2H9NIWR8ffpMaxoe8toWGx0QCT7Iqdo05VCVCrBu7nRwHAUgtyF?=
 =?us-ascii?Q?A16lGrvNYjegjbDXKlI2BzBK/jNuXLC5+P0Esw8BjvpMd7Ttvo7WXaDKvRur?=
 =?us-ascii?Q?i0FzeWErA+Q6S7E3pi5Lev9FDIySf3e3P6d/eRvyiWpAEcGrOG/pkA5ZEg7g?=
 =?us-ascii?Q?x+KvSFRsxPSfyGRqK77FzZ3pH9jmZWRSQVfrzV5IuPoW7ZN7gp/Y7F4WzRqu?=
 =?us-ascii?Q?ZhXCVF9CmArqBOGnBj3sSgLGkp3qCwj0Vvi2Sh/DlOBzkFH4IZBTxF+4GeH6?=
 =?us-ascii?Q?AjMpAmBrN+bKx1Lk7cjzYjZpJRDwtzueI3XY1KpVs9KsvV8744GfHWgPJduV?=
 =?us-ascii?Q?MQ+8Uf5yEjyJbUtacOiAJGa3qRjFfLyDiRab3frOkUPzYtJMdxPrJuqwjRZR?=
 =?us-ascii?Q?LXO1O2AaApc4a4gPEY6qLPplBX099UIl1JJrS+h8HZn4EL4yRHeWuUrr4ToF?=
 =?us-ascii?Q?Vv5DwuHxMywQyreDyd8KZvo7TPbuCxMZPZwTXzQv37C4uz60lAWNf6pjdcwA?=
 =?us-ascii?Q?7Tb2NFQ/qRe6MEpa1ed+9x7O5Jik6BioEebKLwI2VgbnVLjjYM00shji+I8k?=
 =?us-ascii?Q?BgrRAYmaiERKb8d5YuAMkkr3+l1nnvzdqFCHd36i5eQ0tTKCtDURJ6zLA5Eh?=
 =?us-ascii?Q?qzD/+iS1qyVr0iWyJyuzJaS/YVrzLeWJES1bfrOLpgGISHaa02KD12U8+4OG?=
 =?us-ascii?Q?NXSEMMLwMgek1wVBqCClBDA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A723559F15A3124C83A082C890259669@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e70041-e660-4548-e435-08d9be2e256c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 11:46:05.4208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PeKPQfShXfyeh9WSZaTXUBnadR4NHAqbvewPNdEVfG7cN+NVM3+b/tWh1ikkV6q2BKhsRk6stiolygj/T5H8JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 05:43:11PM +0100, Horatiu Vultur wrote:
> > My documentation of CPU_SRC_COPY_ENA says:
> >=20
> > If set, all frames received on this port are
> > copied to the CPU extraction queue given by
> > CPUQ_CFG.CPUQ_SRC_COPY.
> >=20
> > I think it was established a while ago that this isn't what promiscuous
> > mode is about? Instead it is about accepting packets on a port
> > regardless of whether the MAC DA is in their RX filter or not.
>=20
> Yes, I am aware that this change interprets the things differently and I
> am totally OK to drop this promisc if it is needed.

I think we just need to agree on the observable behavior. Promiscuous
means for an interface to receive packets with unknown destination, and
while in standalone mode you do support that, in bridge mode you're a
bit on the edge: the port accepts them but will deliver them anywhere
except to the CPU. I suppose you could try to make an argument that you
know better than the bridge, and as long as the use cases for that are
restricted enough, maybe it could work for most scenarios. I don't know.

> > Hence the oddity of your change. I understand what it intends to do:
> > if this is a standalone port you support IFF_UNICAST_FLT, so you drop
> > frames with unknown MAC DA. But if IFF_PROMISC is set, then why do you
> > copy all frames to the CPU? Why don't you just put the CPU in the
> > unknown flooding mask?
>=20
> Because I don't want the CPU to be in the unknown flooding mask. I want
> to send frames to the CPU only if it is required.

What is the strategy through which this driver accepts things like
pinging the bridge device over IPv6, with the Neighbor Discovery
protocol having the ICMP6 neighbor solicitation messages delivered to
(according to my knowledge) an unregistered IPv6 multicast address?
Whose responsibility is it to notify the driver of that address, and
does the driver copy those packets to the CPU in the right VLAN?

> > How do you handle migration of an FDB entry pointing towards the CPU,
> > towards one pointing towards a port?
>=20
> Shouldn't I get 2 calls that the entry is removed from CPU and then
> added to a port?

Ok.=
