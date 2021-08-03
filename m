Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EB63DF84A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhHCXPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:15:38 -0400
Received: from mail-eopbgr60082.outbound.protection.outlook.com ([40.107.6.82]:55876
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232864AbhHCXPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:15:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yn2tQlYXqGqtlfx29jJtvfPUFnrIQo4hW2b4wJeoHCTV7mph7AdfCCQm1uHL/IbRnKJrMO9TQ3rq3rm30a/+kj/xE4QtLy0NRJ3d5bHcJbXt1fnxfcju86j8WRywxREWd8VHsCm+WraDWSRzGcOHud6cEuX7M2l3KB4PfU++KgbrTd0+iMX/cAkEOYhKhe4OVWWvFuEZ5tnf0TWGiQZu1CTQH6W5DYN5TTFZzlnFbfMfVOg54HncS87+EsnEr3KMNcsEk2eeu//70ellYoQSEieIKe1ebk16JHTkszE7IfiztfUw44lAJGCWcfNA2UAbvhni/lowpotDYvPF5QuAHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibWjDYu68BL98//0lJA5+SS6IB70lIF2mPax0NjfKPM=;
 b=dUPVvY+oSZ+dMhEW/PY410rUbxf75q8o8q7BcASNH2mJQcpK9r11IIT8f9mGZS/mnAgnnTLzCz6Y9EIsSQ26ZCj7qTJNzvLO72CJjZt+7gGZ7dMQozAM8ppA9857puHJx9KghcGyG8IC9BUTPPF6MZS980ofxphsJED3trvpbG6Tn5N8vzYhdL8GJ1Sxkanfebldys2TWhsFdqX9EApgEZ9g7gKtxeJ/qA0COS0TaEHQp+Zp55rbn3irPa7R9/yqz5YbGFGC5Ky8tYCebaB8doWVtGY0FFuj/Ydnu3DJDZMFfcQbjpaumKwGlXbnsQ94aX0nwpQS4mS7SAp5jvnz+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibWjDYu68BL98//0lJA5+SS6IB70lIF2mPax0NjfKPM=;
 b=QL8UHmjxl8PqvyBmdp3yo1u5zoSip2zxMS2l7++g7zHSFKl1x7FS9aXYQIobTnHqwE7cTMWOUub6Xb2x5T8KOG5MeNK1UplM6BpcbgG0I32a036p/WIpwMDKMx79f3E/fBaFMqUA/WgKqT5UkuxCLXHXJQEnvngLOp6YGd1puoY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4432.eurprd04.prod.outlook.com (2603:10a6:803:69::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 23:15:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Tue, 3 Aug 2021
 23:15:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v2 net-next 0/2] Convert
 switchdev_bridge_port_{,un}offload to notifiers
Thread-Topic: [PATCH v2 net-next 0/2] Convert
 switchdev_bridge_port_{,un}offload to notifiers
Thread-Index: AQHXiKbyhpFkUdec2Uq1lsCmG7pc1atiPyCAgAAqcIA=
Date:   Tue, 3 Aug 2021 23:15:23 +0000
Message-ID: <20210803231523.fgddxdurgg4x5u4e@skbuf>
References: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
 <20210803204329.534dpqxrlk64kqqi@skbuf>
In-Reply-To: <20210803204329.534dpqxrlk64kqqi@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc3c3d30-da0e-45cb-a1cc-08d956d4928c
x-ms-traffictypediagnostic: VI1PR04MB4432:
x-microsoft-antispam-prvs: <VI1PR04MB44329197DBFF6250ABB1C5E0E0F09@VI1PR04MB4432.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w/yIW42F+x4vQNoQ8A+FnRIg+jKzra2C4/RSe4ouZpeco02sJin8foQX/TqBRgzJMifubCywMp0hFjQFvuvFOKsRdOA6XzKD3sT2NYv9fTFCt9YVq/zwfxesXDTRuP0d8nSeWCyqzck1JS3sqVx1Y/hvlYEvWbUS72720InUH6iBB4w6p9MmZvNb08ehx9VvViiWBxIk+Uhzm2cVAExmUTnal0qA0e+k+y2S/hixfSABUJA2TkQn1Sx9Z9PnOy5Hkewy8QtKFOKkzMiCHtkvlcQ+V0s3UX64AQnsoDOXb18dGcbPMyH4/sCZb62OqIPG/5BHjJX+sMlmfEE/cSbs/EUCC807eLHYpTvPF/oVt2qgwu/dQR1lTRBoImNo9NaxilCnGmkjtuMI0AVz1Abmb8UDqTy3y7oqWQYqdiRiYMf9l6pMbBzKYccaf5QMePXcDOpCMI9Oe7KKjpZzZz8LfKH/IcpFYXAHFeRSk7jiP6xIa8yXyaCSZoymMj8fXBvjxpSk0WabtqUKzCX5U59naeFq5G3SQDouuRs517zGHAHEJR0Q1Xi8q679KZYwptWkjJrUicYYuRuXuzBd89i7EJU6a6KiM0HEZWVk7sxiZqL0gN9S1SGVHHjTVN2YlBx3+3Sr6rvTUzpfxZAw1pJ5tA8v7ganDN21n7MDYpa4EyjYIylXiZ4D2Le0lSV0kSf13aMWzMKLahe1DVJ9AQJ+8BelYl0Aim2wAN4Zy4F29hHhw0wTms/jShF1ngDaNKYSon7ng00Sre/nbpwiFKSQpDvkIRiLEAXOKgj0TRah2Oc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(54906003)(4326008)(33716001)(316002)(6486002)(38070700005)(110136005)(76116006)(66476007)(66556008)(64756008)(66446008)(44832011)(66946007)(5660300002)(9686003)(6512007)(2906002)(122000001)(8676002)(26005)(38100700002)(8936002)(966005)(71200400001)(508600001)(186003)(6506007)(86362001)(1076003)(558084003)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KADjjXAycIcK+qOTh17xBK1VimHubbfx5/rmJwhVvTCIYeGsSfR+1udwLpMb?=
 =?us-ascii?Q?IisyOJiliknSPNbplQhgZ7HO5dZmjdHnxmqpBDPaUriSMBCbUd4iGdmGkH+d?=
 =?us-ascii?Q?9mjhgxLHaZmFXcRUz25TN8G9mmGncuXmBCQ7Fj3Jq+eztiPl3F8rmyjOU0Jc?=
 =?us-ascii?Q?eut2QfEYd6vB9zQaLzUlkpejbSCwQFapIINR6VyjwxHfq39yogaBFHE30BO2?=
 =?us-ascii?Q?3OY7wo5dK42WKe1bBF03/0rxwD4pd+uKqvV5U85CnAGdXHo04O7iW2LIstbA?=
 =?us-ascii?Q?LhQA50X+3I4BXwMyFlThQPcRK7WqMDoYoJTYztBvDaBEkFvpdZoAct+4zcve?=
 =?us-ascii?Q?5Ol6m/KRwQFT+GPk5KLr8EsSDuA+4OeYwtRhwaWKUmNJdfLsnssaARuqXG/I?=
 =?us-ascii?Q?S5LzpLDN3nPbJF3wKeznl3bN/K7cfm0RhWvTY2MVifU/JOpdim4tWsxvCzqh?=
 =?us-ascii?Q?CMIUf31vhUgq+4NHyxVkJUPXgU2lwqN7Ny6SJyPVyKHjWQ9pyYydz2u1Po5p?=
 =?us-ascii?Q?Q46XXOdld4k1L1O+05wT/nOx5SyX8AxxYwbtvuiTVFEp+XHIQDH/DlbsWt+2?=
 =?us-ascii?Q?pPfX5d1rAYga/K4wfKbn980Twp5mPfx54hreh9xk20nhV1iKLkNrJI5GrP+i?=
 =?us-ascii?Q?rUXE4b0BdMxMICbplHvhCE+5t02Moq2RJaM69fpQgKo2VCMjeSf/BXUNOkUl?=
 =?us-ascii?Q?EZZAo4ouywI1+R+ppwe/cGUwJ3cBubcNygquJF3MgjRyVQg0YOwwDWE/mFfn?=
 =?us-ascii?Q?oqakKVLgTQfBdwaPdO8NgtHQDrrIbQkqdfO6R8hcoeeg534mWMrNAp8dZKtP?=
 =?us-ascii?Q?/IJZRWvAQ/i++nOjecrKw7oob095pvQW9Hxn+COt25XWsLjCmmt1SDZGn1AU?=
 =?us-ascii?Q?J0nkmsYxuC4lg5oak3cGX0sD4m5hou/MZqQgnKt4u+il2w0r+hTYZFL5Tsau?=
 =?us-ascii?Q?H0miHLqTsOfmK4qNuSzB6SyTST1wnlvM6YnfhNqV8wQq9zaKVyCRgYB5yoS+?=
 =?us-ascii?Q?UTdH6XLLFCAS2MNby2uvNG+cDLEV/h8X+oWB7kOVJDqLGuKmCBR4svjlaB7Z?=
 =?us-ascii?Q?plzvk5641bc6dzmC/Y78eIe+C0EPFuHDCcOSSKSOIvQeUdjPSs6k6u6xX4XT?=
 =?us-ascii?Q?KppKIbC8dDb2ETXLnO6bBOlDo6VIQo8LPrZ5jOD3ZYX6yGVUqTA+RXSd3dNc?=
 =?us-ascii?Q?hGGdfZQGy0qOekce4mpQehTTXtrecJsNtiLsrGR7VrreF5K4TiVGHllf/Ajy?=
 =?us-ascii?Q?l+ViTY+h+TtaalsSzG+vcRkEbtRcpSfmBdKOn+IVZvT0+KD26EBmrnX/Dgh+?=
 =?us-ascii?Q?NTwg6EOQPe/VtizO3jukibCC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <015063BB9F45144CB1B42C9FF9BEC493@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc3c3d30-da0e-45cb-a1cc-08d956d4928c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 23:15:23.9912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mYxqzqodohkVnnkoqNOsioMlEuKGLx8vFpolghpjZgVUeDBBWg9/g4vomuUm90zDOCXjsUV/jtBEXcl/HcmKng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 11:43:29PM +0300, Vladimir Oltean wrote:
> Obsoleted by v2:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210803203409.12748=
07-1-vladimir.oltean@nxp.com/

Sorry, this is in fact v2, the most up to date version currently, it is
not obsoleted by anything.=
