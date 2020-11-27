Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887032C6CF9
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732323AbgK0VnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:43:05 -0500
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:44733
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731634AbgK0VlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 16:41:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuxbo1no6JG0/CFTbXvBhJviOmNkqiwlDrMiJTxZuPUqAxuDFjUWxYXPQP3CWUwY4I4PIyab6P5Bw158Tp4QblxP2j7WNfuXSa6BxH8vqgvvPASxHfrYxv7xwfXra9pcY8+45L6UcJz8C7dIJWJOOhOzMJB0xQkBxfbsVkglApNZzqW1ltlTi9mjjPZhoOpRGA9Qhm7EeoOmaygBegyktjsPf3+6O4yCwjqtWM287Oboqy3iAAREGDoU4R9q7r4jbqIjv5H0M42wQebovjPBpLJGYBuG29xoyI7FEXSeJUPXO3Ju0VBnPQvGTVPJ+8fKYmbd/3iqKVWDaqFxEO8irw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7R4TlyY9oWIG1qcNrkmpBvhQ403rs83mzBHL7rxW+M=;
 b=fcyFgV+d/eWWSeAWD1ffQRydYZU95a1ynRaneK7lXWfZvjLC/D5fPA2czy3dJOTj30P09FHxTWBrHVJF+VdnEo3lWwI5snV6AdpKbEwWBZn2yvxmu1ZsMzLp7o8vZaFrzSHDgmlIIm3u0wPEBmvIAwQ4vwr5AzGzj8QB+2tzu9QYPUusHWI6E+8zYCkxRGJ4PZCE3zHnoRW8/ZirAnQN4ML9684yT15ZojifaEqDtfPZ70KL/y7ad4/nGEU99q5AaB8H95NMjb7uMxYoKbaqsN0cP98DtZnkXCWHx0QDMku4mWyHm7tIkPWd/yf0rPcUscCaxzWWqYE/88519TkS9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7R4TlyY9oWIG1qcNrkmpBvhQ403rs83mzBHL7rxW+M=;
 b=BEpss+kG37+X30/38Dxt8kMU34i9iWXdtwQuqbsMYVYccRsv9zPdcnFq4PWroBfHRQVjvmDmr2zbb7t2iS7XJ/c9T3kQBdUVAxxidiWaol8YXtnWU+dtCNvK1gNOMan6mNbzOwfXWzlMCF5zAUFcC5ueBLXwgYITYTwBZdeGXAU=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 27 Nov
 2020 21:41:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3589.032; Fri, 27 Nov 2020
 21:41:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
Thread-Topic: [PATCH net] net: dsa: reference count the host mdb addresses
Thread-Index: AQHWozn45OsHCx59Jk67oCoKlCMeg6mfxkaAgDz/R4A=
Date:   Fri, 27 Nov 2020 21:41:03 +0000
Message-ID: <20201127214103.4cqmyehngfaruheo@skbuf>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
 <f48587de-f42b-760b-cbd2-675f2096609e@gmail.com>
In-Reply-To: <f48587de-f42b-760b-cbd2-675f2096609e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b2e374cd-e518-46c2-1748-08d8931d2425
x-ms-traffictypediagnostic: VI1PR04MB4223:
x-microsoft-antispam-prvs: <VI1PR04MB4223B625BFBDE73325C247AEE0F80@VI1PR04MB4223.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RMsTpRPq+ZRa8am1RsTReZf/nHrih52JZELY2Z0JOBam2Ur0GshTzKB4yO6xFlGIhGk0RZnAPl0gIlJXGWf59Nh6tXWMpvV4td4K5U0jZ8opOR1yTqhNKd9ExowuRuIWKu5/NypcJAWNOiT5HHOzBqHnfcus88naQszyFqJ5RwyMo2ZCV0G0pF5glfJqPbI14Kxh3BhV5x1KJpmfmmUEZDJ3WOZSbRIbWaKzJ1GO2s8CUYvLxUP+3gBQ7pz7jXNdzdYhl/EdgS08+/48SRbRGPe3FFarYwuiPzb66mgJsNqiz34WrohVwW/VxRZJxQMk6rDS8UQl39U/g10n75ja0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(346002)(136003)(39860400002)(366004)(396003)(6512007)(9686003)(54906003)(86362001)(316002)(1076003)(71200400001)(2906002)(83380400001)(44832011)(66446008)(66476007)(66556008)(66946007)(64756008)(76116006)(478600001)(5660300002)(186003)(6916009)(33716001)(6486002)(26005)(4326008)(53546011)(8936002)(8676002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ByIoLsuzm7spSpUFAXllmvqT2cuNwGoagxUteTR6Drz+jRfG13ROGqU0b4/k?=
 =?us-ascii?Q?Xbi0GQUIavtRfA6XmmNATSQnxMrenB0v6oLHvyui3VSdfc063ywkxCnN1+u9?=
 =?us-ascii?Q?E6qRnoUNW1Bhp3OMOxMSDVGSqHFAg8+U1wqlTb2Qi1BywcWNhYYuy90lQtly?=
 =?us-ascii?Q?OJZOM5EcKfLoqbbJ/GQIO3Hnot46TBq1Fg7A+nJdgQzaU4wjREqPlnst8Tqk?=
 =?us-ascii?Q?kdKlKrGvSzh9KWE79O7q5NroOhAP47X3dNbVNhE6J1AoXw2gYYdLUQSLIQyE?=
 =?us-ascii?Q?Ipb8XHFvAj1AgOpwPYy5yss+7LpjEnRIdqMQ555OdMnLptCzxukqxTJlFiE3?=
 =?us-ascii?Q?Wd2XSbok1qIajf7tsaiDz6lq6BBVmK5/nP9CaHeX7zkG3e/VqSTqxuyrAK4A?=
 =?us-ascii?Q?VIXGq+ioHav0xXyNlEqH1HdgB5+LtNnpew2e+WLSjq4n4/Qg4zjxDItLrq8a?=
 =?us-ascii?Q?zMN9qZGAtOUeAFGRVSlL3Eu9TZs4NDbPa5J0wpqBSxRfEdUNJ4Hi2PXX30UH?=
 =?us-ascii?Q?JRQOnibHlnN3tPfIpDILsB4nJLbFgrTjWA6fHd8m1u0kacpY0J9SCCiIdO1p?=
 =?us-ascii?Q?eptolwFtbW/GNiCv6aqbmjGLAxeLQeMgev2GhmqC0Y2DtJk+nMXOx1/hVcPv?=
 =?us-ascii?Q?R8e3dzBksHGCrRGpA/SnBjN2o/YbyNUs8bE0M5dFRm+pGt6HDyKSMg1LlMED?=
 =?us-ascii?Q?OkQKCzAmT6hRkKzeivhs7JxAj3LA387A3GSqObYt0I/d4jJi9VWcSGOr2t8c?=
 =?us-ascii?Q?Dk84oI7+ErDF+JQwFbGt41hkrxdrRGTanAh4NoWS1C76+v+r9Y1AyoQP1fCi?=
 =?us-ascii?Q?ZPrfW8NEtR/xQn5dmHEX2uw5NAaAtrUPvoYM3jKwvUu6p0wPDKd8SW2IdUZk?=
 =?us-ascii?Q?gPyReyAalbMcubHu/fOdbjuyRWg9Sx9qIXBQJ+GmcOynuZLWp4niz3+COyN0?=
 =?us-ascii?Q?/S4c9obUw8HSq/MbWww00sgOCdOKktObxKS4fPDdC6NjpF5bDwmiK/J7S8hE?=
 =?us-ascii?Q?cCw2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <532A0B57FFC9AC429E9B6D5DE8655618@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e374cd-e518-46c2-1748-08d8931d2425
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2020 21:41:04.1690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBjRDLYTdZk7E/AwHe6k94HFZ0cAFZrjHn2Reix7vHjPRtTMKxi9Y92UrNT/UkR3ORqxv8wugD5as3qOS4aduQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, Oct 19, 2020 at 07:11:47PM -0700, Florian Fainelli wrote:
> On 10/15/2020 2:27 PM, Vladimir Oltean wrote:
> > Currently any DSA switch that implements the multicast ops (properly,
> > that is) gets these errors after just sitting for a while, with at leas=
t
> > 2 ports bridged:
> >
> > [  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=3D-2) to del o=
bject (id=3D3)
> >
> > The reason has to do with this piece of code:
> >
> > 	netdev_for_each_lower_dev(dev, lower_dev, iter)
> > 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
> >
> > called from:
> >
> > br_multicast_group_expired
> > -> br_multicast_host_leave
> >     -> br_mdb_notify
> >        -> br_mdb_switchdev_host
> >
> > Basically, that code is correct. It tells each switchdev port that the
> > host can leave that multicast group. But in the case of DSA, all user
> > ports are connected to the host through the same pipe. So, because DSA
> > translates a host MDB to a normal MDB on the CPU port, this means that
> > when all user ports leave a multicast group, DSA tries to remove it N
> > times from the CPU port.
> >
> > We should be reference-counting these addresses.
> >
> > Fixes: 5f4dbc50ce4d ("net: dsa: slave: Handle switchdev host mdb add/de=
l")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This looks good to me, just one possible problem below:
>
> [snip]
>
> > +
> > +	a =3D kzalloc(sizeof(*a), GFP_KERNEL);
> > +	if (!a)
> > +		return -ENOMEM;
>
> I believe this needs to be GFP_ATOMIC if we are to follow
> net/bridge/br_mdb.c::br_mdb_notify which does its netlink messages
> allocations using GFP_ATOMIC. On a side note, it woul dbe very helpful if=
 we
> could annotate all bridge functions accordingly with their context (BH,
> process, etc.).

We are not in atomic context here, since Andrew took care to use
SWITCHDEV_F_DEFER in br_mdb_switchdev_host_port(). Honestly, if he
wouldn't have done that, we would have been pretty toast anyway, since
we end up calling dsa_port_mdb_add(), which assumes it can sleep. And
deferring in DSA is super complicated, due to the fact that
SWITCHDEV_OBJ_ID_HOST_MDB is transactional.

So it's ok to use GFP_KERNEL, I'll leave this as-is when I respin.=
