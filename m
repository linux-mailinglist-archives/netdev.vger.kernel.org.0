Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B826468524
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 14:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345187AbhLDNtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:49:04 -0500
Received: from mail-eopbgr20067.outbound.protection.outlook.com ([40.107.2.67]:26501
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344655AbhLDNtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 08:49:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIXGLNfMdhQcP0P0/ZVGWKJjMkuwW1AueqXy1lMOLuY1p0id/RSPl53L3hzErGPnAcUuYQm9EUrjsXtNtSrZHUqid3EW8UZovXrqau64AkRxWxUaVg2xGwYulCMA2En05W+kIh+a7mEu0hMArQ7HBlN+LbdZgdGsP9VN9TqWX9s71X7ZCubVIgPpANiwV0I2Tvijajw5En5TA2mSf1zgzwlV58yYo+73BvvKt1HR59iKr9LDVok9O4bcSmadIOB5/QmuTgotUBdeRi9RfcWQ4GD9PopvFc/Mp+l/+X9oDi0wXOImF7uUQ6XQ1d63V8tfyRXNv4bkRTqkxjgMWEjqvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIYYWyiSWg+W7Nr8aybf/sOlDE8v6zKIAnE4aJXow1o=;
 b=Fl9XxHFg1/NObVq5+Jq94xhmQuw4L/wy1q3z0kOp8duMNwDNC9e7DaSIN5NEEgENZ2A0eWZfKNVcKVHEsNOs/Lw62JPyN0SHUGbQMxYAp7ejf/PD9p/Fz4TKqw+tXVizL+/oVNjpjC/WikVhs0/Zg3R+g/f5amGX23vYQiRBCX6GSibmMEuRj8shK07HbTrg87ZXqXV/lThfkPoskPCispXM7yxFQfJiItwB1nnKXH3tY/gFPmNYyXRwcVIXIUaUc9AgKsqErPYPo2iU1ZNP6e7cxD+l1a/OyspUUAdaWKQFRD+y1/pV3bkt1zHC4Lf1m59sUeQosNlvDNpbw+scmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIYYWyiSWg+W7Nr8aybf/sOlDE8v6zKIAnE4aJXow1o=;
 b=k1O9zVGL/NTfj4IrdR/BoqQ7OdMq2KiED8BX8n9rcZzQLX8nTQEZeE+YleYb6GK+Im2aeYpExBXB5ZtVXMSVF2eGkqNn4Hf/lxHWl8FLFOgL9bU5COVZj3U8gPmQ2u+nFnF2NngwAF4CSdL4HPQWN4NPctb1/kILNOMWscJzyp8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Sat, 4 Dec
 2021 13:45:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 13:45:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v4 2/4] net: ocelot: add and export
 ocelot_ptp_rx_timestamp()
Thread-Topic: [PATCH net-next v4 2/4] net: ocelot: add and export
 ocelot_ptp_rx_timestamp()
Thread-Index: AQHX6GoAMHQlfMnq0kOK2gyGKRszQKwiWZcA
Date:   Sat, 4 Dec 2021 13:45:35 +0000
Message-ID: <20211204134534.7kqvfqyicdojjbld@skbuf>
References: <20211203171916.378735-1-clement.leger@bootlin.com>
 <20211203171916.378735-3-clement.leger@bootlin.com>
In-Reply-To: <20211203171916.378735-3-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17a95b29-4616-42f5-4a26-08d9b72c595f
x-ms-traffictypediagnostic: VI1PR04MB5501:
x-microsoft-antispam-prvs: <VI1PR04MB5501498E5AB1E158707E3752E06B9@VI1PR04MB5501.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lx4AzMe4b0EEuFz1QYmDgxyWNpMQEYHrI9+DBe0Dh+cqoSgr1YtU/yeJdWbd9B2dzk/Vj7CBEE+Bk03hmFxYhRKBl7tnPoL3g6x6rAvEuISZuCh5GXvQI8VYP61MWil4ArLxGuY2JC9vAgYL2ZF97UhwgxAIyU+o3I5GXE1sPsHZ4zvAw/YBzhj+Ws6MFGvmAELKU6WGT2rD5zWApZ4I4jSrQBKv3rGOpHCNuyclT8xlIWYJveRQfMTv3eB1g+2YHE1xdWHKAXRnJUOc85J1v7+WP2yTw2xp+eOblFHYfatPJgivekPyGqkmLgDa3ctAe+RTN87LXC9aF582UmiD5nrRT51HJHwqayceSfsgfJh0wsQD5m5UECqW1btR0cCbKnRmDsxTZ5hR1kh3EbvXQ7Ib4tVtxY/y8X3zKmYtf1aNukOILZKNhXQpGaVeeqRjl2bKz/7/CrotPzYQYCfqS87FoaFKROEmLuPmnd07ucMfp9GFC11pi21Q/mZqhaUBJtkSzTRdhGzf8qv/bfaZrYf2z2nmMLRey75otbDH8V8bmqSX8A8fMA/FKUKD/NfUJYQtwRniVSw3WKUW51bQGJ/fD69hSbeSLQ6SDuZN3k2fad/43WJ3cRJigedzDSCr9ySLsJmGpLo1uqO8X5Hlh3Ex0rwqi7CcxYkt5zAseSkJ+qUR+sbXpqNQE+vtht8ST0D/507Rc0Jh2Hyoewxgxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66556008)(66446008)(316002)(38070700005)(33716001)(66476007)(38100700002)(86362001)(5660300002)(54906003)(2906002)(122000001)(8936002)(8676002)(66946007)(26005)(4744005)(64756008)(71200400001)(508600001)(83380400001)(186003)(91956017)(76116006)(66574015)(7416002)(1076003)(44832011)(4326008)(6486002)(6512007)(6506007)(9686003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rpAaj9+SzP7AFnjiGPT+YFztdVpZpc/qKkfOyDLgzNFJ/G1h8pXsDlHEnh?=
 =?iso-8859-1?Q?b4BF2VDs56c36Q+pecsaSiXqJZhnUe5SuErz8bGhVOqQjAZCecTvoL3qeU?=
 =?iso-8859-1?Q?rbnWibYMIU4JWmYWa9dHRwEkBYZ4jDTpwX8DM2zj4yZm12MIvI6H37cdeq?=
 =?iso-8859-1?Q?VaQfV2OPDC9tqHv0YDENYE9ZKgX/bfq9zkQG0BAMXuIne4s8vqSFze25b/?=
 =?iso-8859-1?Q?lgdh9VV3rD2OcXMRwPhbElSeQvxFvJ2jkCrDMSLnf9JGrEm66EaUs+VG5R?=
 =?iso-8859-1?Q?eZm81yTlhjD3iSWKBPyzxf4Nr5SjD9jO/6LQEHgJsbGj1YhIBkoFC8iskw?=
 =?iso-8859-1?Q?Z0vrqKFUxCIXjirmGKcAD45N7u59vkGtdbCGTnqW8vtnkJoQTejoENGak9?=
 =?iso-8859-1?Q?ahmftxdGUz/7G0u7ILuU9IccHjySOGlKyXUhpZ8Lhv5aItceg88ZIIZGwt?=
 =?iso-8859-1?Q?TZUZwnuw50qpvd10SW8B4SOAoZ9uKKQZcxvF8zDeCjqTXm5ZDnGADKL6iK?=
 =?iso-8859-1?Q?uczqOJrWr5Apxa/WeTN/9fIBxLFABNZJrHrkDGrZMzhVuFVxjhX3llO4h8?=
 =?iso-8859-1?Q?B/c6sHABexltPSesKeO14UmKmhhBHuLQ2yccyIISgoTTa0d8XFjPIVAgD+?=
 =?iso-8859-1?Q?HACjC0KeBUc8YqoatuhfQPA3xkcN97JrrdpcoRM6Rn1Zg62aemF+tOPRXj?=
 =?iso-8859-1?Q?udG1Gk5RBkybuBqCmOR2iNV2VtBlgnawAD3VbwseHAqf/jrlhqogApFj5o?=
 =?iso-8859-1?Q?guWxjS6AePHEUk7P70ZrJQ6sTfPTvC0dZ3FBL7WzVp7F3QCUq0LCXsoABS?=
 =?iso-8859-1?Q?OLY13+D+4srtV4gsCbsbpElZBxAv6XzYxlw9fqCcHneIanMSGd2U3MlVK5?=
 =?iso-8859-1?Q?2VKz4pIeugSvouHX16H8I08hMMfe1VPxjKWJsUSfGluw7HpOwk4+1Vi/Ml?=
 =?iso-8859-1?Q?MuzT0s7Itc96yeJ0P+D7vBtCnOG9Fid9WoQ+4i4YvifMLZe5KBWyI7+jbL?=
 =?iso-8859-1?Q?cPm80YSCtqdZhDRr14w2W8twY8fYcMbHiNNjJjAHUgCIqDzqWSnTCRKtAQ?=
 =?iso-8859-1?Q?Ym+NZJd1q2bEQJy87XkoFEyvFhv74jiYjjYVTu25+jHkrif/sUdM5R6rCw?=
 =?iso-8859-1?Q?xIs8D/LZ4iNI+N7WZtA//8huA7CtFXq1WWRqNiKsasb/MTfCluahnDuRQg?=
 =?iso-8859-1?Q?yuj5wvkDeSPq2DWrmLG9n109m1KeAHsddtM0NyxKVUhOPwLv22tMUlou7/?=
 =?iso-8859-1?Q?LWEoqOvBlrEtuC1ltmzdkFU+oTDGoI+L9Lm1nun2Gb/lMhoJvIY4eoFy7O?=
 =?iso-8859-1?Q?f7DSVmkNVozpJ61/Fkx9dUp4wZ1S2zWeT/6C0KmYAk1kkMB2mifSllZBCs?=
 =?iso-8859-1?Q?SUTJZo6QAkjOYJbd1J3SEysfmzEE06nKsLscW53oS5FGsploYGiZbnHQGH?=
 =?iso-8859-1?Q?xsRX2pduaPawXzOrRk+TdV3bbGPpfwb2HJOJr7chnu7fyi1tSH0JFbf4hd?=
 =?iso-8859-1?Q?yMbnkdV6p9IrFqnN6QTZLUKMmu9izTyRdEP4hLG+gJ66H7VUH8WrFHuhfe?=
 =?iso-8859-1?Q?pvx/EeAMCS8yfFnxMpdW/J3CE91YFcQMiHun/Bh7PIAE3uPX4IpP3XzUbg?=
 =?iso-8859-1?Q?q3RylkFQFBw9C/pN6MT6T5gmQB5Tf7QgfRJhYPmRj91pp2O6BnMiAFt7Br?=
 =?iso-8859-1?Q?TbU5vB4hrb+EIX4U/8E=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <31C760CCD14C2A4ABFEC4AD70DFE7895@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a95b29-4616-42f5-4a26-08d9b72c595f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 13:45:35.4403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hAiBFVOIOvLcL6XvkKmK2Um0G6Zd2Qo05CFXJK4U7iuwlO7SdgmXNAv13bwMgbaXo4vr5AFi8m4N4kgUs0V44g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 06:19:14PM +0100, Cl=E9ment L=E9ger wrote:
> In order to support PTP in FDMA, PTP handling code is needed. Since
> this is the same as for register-based extraction, export it with
> a new ocelot_ptp_rx_timestamp() function.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
