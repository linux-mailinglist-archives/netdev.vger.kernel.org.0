Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDD84AA49F
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377854AbiBDXwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:52:15 -0500
Received: from mail-centralusazon11021014.outbound.protection.outlook.com ([52.101.62.14]:50486
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233631AbiBDXwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 18:52:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUiEwO23/asKn+e5fDmJSI+qk5DNNZMF4AyvcAHp6uhmF5RcPvpxmQbFp69msY8lPGPj4iIQLye1Gd7yJa/uvhkSrvE5z1dVmhTpJzIScSvgfXyyGz3A8P7IEDJe03z2DyH9ZX1w79GrX0SJjLjvDoVU4ikD75KbOcCMWxDudD4FhRzcuw0UxOO6dbQyBb68oGcmIfnHiwh+MAR4MZR5DXWRacnvMrJeQUefNo3vP5n19RhZMS88JevC+jCtmdOxVBbPV2MhszjpD827G1gSfseqpidy+Ur56jovdeTquPj0r78FoFixW2MmEM+hfq11jB8ResA5wYBU7QGQCvcFuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xbk0xBCq1n42cskUdd8fMf1Il/iIpK1+93Cx2EwWD1E=;
 b=gANl2nvw+v9nQDJgduEHB8B8dRYl6HvxxjvdrIqJjfyR5Yg0Dx3/uwHjtM6ppNKbEftLnJwNNhYdxSbz7l8Vz5d4Lw9uKo0Q4lkZ2RBTheR6NN3VwhLlyZdUfliHpflW3tgfx8+HBYJDm5UL+X/rrc+K0epksJn7aNOMuATGJoVdckhFDIeqWHBAE8ddRj7yQ6A3y96dCZx7nLNVaO2FsB1uRr5rAMqbeSGWN8i0H9LYdUj70pBZB3EICCpTKpVheCjXeBWiCTdql8KXntdn6PtwFHTTkaVsMR0PiNhSMAY52PDyzcW8RHdZo4U675pCeGgMzDobpfhCZuXr6rC8rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xbk0xBCq1n42cskUdd8fMf1Il/iIpK1+93Cx2EwWD1E=;
 b=GWtysoJBpG+H63XcVMy30YcN/J7BzeO5qBkNVOAhmArkwZWsRYzuX66iYth/Z0jmuaEuG9CWTs34Y2YAEDyqlQdn4SOosYK/d1hLaSc28Qfh+4BYtNp50LYoXNVTKWmkQwZAtlYRzBszsQ496N2LuyC/M7xtAQSkKnLLxFerX1U=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SN4PR2101MB1599.namprd21.prod.outlook.com (2603:10b6:803:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Fri, 4 Feb
 2022 23:52:11 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::e9fa:3037:e252:66e7]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::e9fa:3037:e252:66e7%5]) with mapi id 15.20.4975.008; Fri, 4 Feb 2022
 23:52:10 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUNCATED
Thread-Topic: [PATCH net-next, 1/2] net: mana: Add handling of
 CQE_RX_TRUNCATED
Thread-Index: AQHYGhkbeRvgdAM01065wHv1w3gWGKyEECaA
Date:   Fri, 4 Feb 2022 23:52:10 +0000
Message-ID: <BYAPR21MB12706B0DA2C2C7E972F13A81BF299@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
 <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=14ea5df0-2e3d-44ea-a635-90c1ed85c02a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-02-04T23:51:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3abd8639-4a71-45cc-7f26-08d9e8395c5a
x-ms-traffictypediagnostic: SN4PR2101MB1599:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <SN4PR2101MB1599118B2ACEC33A1F52ED0FBF299@SN4PR2101MB1599.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kKEIwhbpP6H+7eRTlruhE+K3xu0G3KKBxePPqS66XIm137qkvJkmjNChKRuoCbJW0QPZ/ZEvStG4l14RYI1UgxLGD+pErGWKAfn3n7wI8aGkriGBhV3iqV57XgTLB5eKDDpctkGnXUSETgIRrlNpr4B26umQ8ItRSV/3tHrGc7vuF1/DQlAVigkQc9O8xH7Gz06PQRWtsL7Pwqq5pmMP9xCA/8s8RBifnjJKMWfBzqPtG40FgCjxdt2SmnebG04mMzrP0i4JFe5XTXt9Ms+TKTamzkRYvOiQ3q+Ck2nueNKWkQiJq2vpYFMVJetfJGip+2Fr/AeXE5Z/u5vk22IG/wsF4ufj853jQyCciD0AT3tEBlcmpFt49QWM8vUzcqQT/ZIfVJgiiuKXJY2HwxqZ63SDwNN+sakOtFcFHS51SI7PC3Uirv5ZlaaINHFjUSaIVsIaBYgT9FpfTDnE+ZGczQPM6aAgdBXRMnJZqHuG/kgtv6HP+SXdmeJUe4SW1orEFJJN+RhuG/7DIvTnpKM2zwnKDOaQqYD9W1Poh7XL+BV6SD6BVKVVbPNKFWRsagdCSJu/Hw3/W2h7ed/tSEpjIF1I/HtCBnxHTDFqViMCfB4/2akHMw4q2p3NdiUlkhODUutEOv7OTGNHMIlAkolvrB9XZIoQSIVu6qp7sZBLrV/VJh5iComPTcLXPThbS4f4pA+Sb4vWkxX6fxkgMWy1KGy/ZUol2xeQZw3fu6xbKPxxhzE1YZ+3XIRRjrJHJlM0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(316002)(52536014)(8676002)(26005)(86362001)(186003)(66476007)(8990500004)(2906002)(4326008)(66946007)(76116006)(66446008)(64756008)(110136005)(54906003)(5660300002)(66556008)(55016003)(9686003)(122000001)(508600001)(38070700005)(6506007)(558084003)(7696005)(71200400001)(33656002)(82950400001)(38100700002)(10290500003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FMOG7KPCNT5YFGt1aGbYIbO4QOFMCBMQ1l71CEmeyoC/ORs1V9YQcIn9gqKL?=
 =?us-ascii?Q?qqB01oIqYF8wcOX4iC77J1R0KqGpHgDrN71HR+oltNdN01xA0zDIL98mgfGv?=
 =?us-ascii?Q?GBd8CgzPlqK+zdHMwW0ecpHrDWzQxIkotCxyLmd2KcN+NQ3G58igcywDwZyw?=
 =?us-ascii?Q?JhxwlkI8CiQW8iOPEgVp+d4u3KzJ88qdxs0EmviSFZJUK8GLebkR8virS1pA?=
 =?us-ascii?Q?5obR6EsE701vCVT4Lyt0PqU9mydNcDI940qYCAokBOjzj2FPp/iFQGRX2LfY?=
 =?us-ascii?Q?ANrAv9D5/fOzDiQcAy0m/99L7iL1a7ZsiF8TtApdgcNOKq0DdK7pWpBoPGJM?=
 =?us-ascii?Q?xMvIPQIEake9zAyZu8eFBiRtvOawhib3L9ihsDtrKj7nBQ2N95gr3miSnYDG?=
 =?us-ascii?Q?wvweFWxG0SyeIxo4VT1vBI6PD6JfDr91HiC0kSvOPGWazvDqr2t3gbq9kzoN?=
 =?us-ascii?Q?gkpiWaBlkLeBivAvQEgysYEp1jEWko+Wtbli9NTel8/D2c6OzBVrlJQmHr0U?=
 =?us-ascii?Q?9D1VNhceI+qZocMxBPwiZ61AOZfPXbCnt01W7KVMaUpXOQjObcBeM2dtWP/U?=
 =?us-ascii?Q?E+bao2BseGfEA7VFbeOOvDUWBPesW5GGfzNuBFeCnZGpB87UN06bvu1knizX?=
 =?us-ascii?Q?Y1UYYGAFVN0JafTYXTDkaPG7wDmEqOEUfvRKiR1Bhk7ZlIetypPURULdntlk?=
 =?us-ascii?Q?L9TVoawm7/MQYjL7AJaKRelwIP/L9kBebAEkbwAn5Jto+wyVC2PIM3dkaSRz?=
 =?us-ascii?Q?RJ4JZ1UFTnSgiqdfLiGHHme5hB77lg0yNtBCtD9si7Tdt6e5Mp43ngX0OrRU?=
 =?us-ascii?Q?OhrwllczWcY8X3fGZS3Lc/O16LSoe/VPtkMWx2oU0LhByjzIWpa30I7h6tJc?=
 =?us-ascii?Q?iQHConHnkIawx/3Tb+cjZ/Q0ZdOFa8DPrWkrdCJMVG2YKxONYhcxbO9Ru/zo?=
 =?us-ascii?Q?c/Ru8WE0s3TVkQ6L/9pbanl0nTGx0AyVq0+Y+bzW74JAFC0pmJLVlphx6Pbi?=
 =?us-ascii?Q?PUzv9VljbO2tYxq5w+483nav9J6lC7e4YveQ/E0Lg8TNhKFMTlrS8AvF7Bs1?=
 =?us-ascii?Q?hDzZAo6pZAR17ywaoNHbYqLKYgNGOJMKRUOkJ9LdShaWIBL7/OybcyR8nxOu?=
 =?us-ascii?Q?CvlhryLhgiPyZdKWdFQ+2QE/xBOWLeuM2r9lfjoGNKBcVA8ONYZE4KRqJgg4?=
 =?us-ascii?Q?O/qoMj8JErVC8rDcawAvHAzagUTKxkNzyIrxjMBhk/gXOPjqxFHJk3AL7K9p?=
 =?us-ascii?Q?+0vmycJE4KL5m/0Ia5qgy8d2bJLsExP80ZETfR5jk9ZIlRpNVZY/KlcpVbwJ?=
 =?us-ascii?Q?VHpNnEAOyMb1InMQxwIYMQ1Qkf91B3X1hbttpL48t+/rKOtfZNU/tSshr5oz?=
 =?us-ascii?Q?dtYiYeQo4rzsRSYk6GCwD907VZ1cxMcNgz8bxnEX00XV6lDKUM1lI4J0N8la?=
 =?us-ascii?Q?WADM6i7/cNQfIJgyXWXO05b38WW/NsSgwMNK5g9AJzKhqKCWyV4ekRoykIbC?=
 =?us-ascii?Q?wDmSmiFaYbhvIiWSlWS8eQwEbjPwH2rA4socYV6gSK9e2U7oneAlMgDX5Ver?=
 =?us-ascii?Q?xCKQHL+GXT3ezqFRb8N7yAhR/jUtWY/9HKQeMfHugMqj9e8xRp4EkqyI+Lec?=
 =?us-ascii?Q?RtXWfbfr5GbO6JnnXExu0iQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3abd8639-4a71-45cc-7f26-08d9e8395c5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 23:52:10.7950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5fB/7cqU9JK0k527zMsP8bYo6l63tFmsQ/4mQb4vFMM8rKrjXvFO2JJ0dSgSNJJejEzOasHpT0DHJXzTSnQ3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB1599
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang
> Sent: Friday, February 4, 2022 2:46 PM
>  ..
> The proper way to drop this kind of CQE is advancing rxq tail
> without indicating the packet to the upper network layer.
>=20
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>

