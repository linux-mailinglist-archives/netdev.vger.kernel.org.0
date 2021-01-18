Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DA32FAA82
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437384AbhARTsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:48:00 -0500
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:26766
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437193AbhARTrW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 14:47:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4pymAaveC1T9RFUNgDQvd1TJ3LqgdMB2xgs/4tUf9mDj+Yj1hQNfQpBzB0FecnycwjjBZZ7EImFR4xyMMBSut2YfmsQ92ju0efaXSwQPBl5bfLGi1IIJn736FEQiOmI2SNfZ/CB/Ns4bdvDGV12/OP5eZeZt88wibbTq7cS0DfVtPZCCUoow9aR6QTPUaeOGfSw1u2DJTMeu4W5YcNA405pzA3aChsM/gvkSp5ys1u7S4+2QGpVXUQHlStoJcbJLxHzDyflxLAt48yXop5JXqVPSbO19etihJy9Ye37CW+MP73AIcjL7Tx04So+SzjtR9WrXFIXUeb3APM27JoOvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huQKRyF+cPxGTnM5qH6yP4lujS2G2fERkw+bjRcbVXo=;
 b=YGr3TS257v08egw6XYAr9QU9DKBakOXQZgrFcDl/O8okjXbfrdbQhFususULHkKoCY5J8GlarijgVGMptBjYKbXnHWYyIlKVNpSL4d1Ed0RLHmPdFKcI7iqVJZ3+IXqSzfJYD+huM7gYDcVKsojzuS2Vt8w0hx0vwbW8xGOHHtKcipgWhuRcjKaTZrEBvgiQhc/Gtanga56oFQedP31sU5RlmWzyPEpVr2rB4Ap6UU2eR0GPKiWCMgy7K/OJEfHIy5c1MGs0VZx66mjdKFUDvcQlBEOmszJyTD8iR7duIId7x/SQjJTbwBSijhw7pyXUhvLfYZd0/4GHhjrim6o3LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huQKRyF+cPxGTnM5qH6yP4lujS2G2fERkw+bjRcbVXo=;
 b=YQuBD4UMfHDULURXoRJEleZJNqv465Vjw3Ct12e+/HLln0wQ69QYFbX2wwLmhrQYYHb+O4Nf5mherSQ0uhmKd1QY84UKLGt/Wdd+LM6uxmPQQ8JQOJKdHaayg36ORUDMSXNWB3U1ciaggxa/+7l3oo2k+f/s1DL53Vjdm3KAgB8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5296.eurprd04.prod.outlook.com (2603:10a6:803:55::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 19:46:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::2c43:e9c9:db64:fa57%5]) with mapi id 15.20.3763.013; Mon, 18 Jan 2021
 19:46:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
Thread-Topic: [PATCH net] net: mrp: use stp state as substitute for
 unimplemented mrp state
Thread-Index: AQHW7cWjvIuaHRmLXUOsoJYbcslYzqotu6kAgAAOCQA=
Date:   Mon, 18 Jan 2021 19:46:33 +0000
Message-ID: <20210118194632.zn5yucjfibguemjq@skbuf>
References: <20210118181319.25419-1-rasmus.villemoes@prevas.dk>
 <20210118185618.75h45rjf6qqberic@soft-dev3.localdomain>
In-Reply-To: <20210118185618.75h45rjf6qqberic@soft-dev3.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 72c17b8f-4109-4a9c-78b1-08d8bbe9c258
x-ms-traffictypediagnostic: VI1PR04MB5296:
x-microsoft-antispam-prvs: <VI1PR04MB529607A41DE8662381AD22CDE0A40@VI1PR04MB5296.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gcmBt8r4A9ih7haeRZ2vQmvb/ZcAakfFPLuNnCZ1Y9V7aHFkGdgOS3eamcf9BasV1jpBUK2G772aZ9g8zsJ7cEfmVS7Kdr8ONOVq4OCNWmum2dLXnlEHIMRBJHGwRVPO6n+iBnM7nJDXrqEe2+F/2GR0iL6Rp2Hy1Vv5BYAxeQ96caY/+oTeW3yDh8whRL5DzS8dGLuHr4UhxEnPj+NXIQnUCDg3aJio7OquVjOl80hvTuTT1l4sc3nZ21cZeA5W1lbQPzYBIXhgDPyPBDrm4AOEoV0ObOkrm8QvXNxReI29vZMQKxjNBQ/tF5rJdQCQowT4Q+SC/LHrBhwsVMLSMrPmOLuKI2bXpzHeHqy9dQ9HWPCFNdADw0HqCPwG2TjjcGSs1kmKLZ0SOi6yiQzQUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(316002)(1076003)(54906003)(6916009)(6486002)(186003)(4744005)(66446008)(76116006)(66476007)(64756008)(66556008)(2906002)(66946007)(86362001)(8936002)(71200400001)(8676002)(4326008)(44832011)(33716001)(478600001)(6512007)(5660300002)(6506007)(26005)(9686003)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZyPyGK+Vh7FMigdhLr0Kt+RRkXn8nWjr+l/T0fQ6Ee1tV2zD4FNYk4dY06n5?=
 =?us-ascii?Q?AqSGTjaQyMkV0BoHxPXfUZ3S7Q1u1/UItVJMfFW9DPa6Em5V+LANBRFcqi+9?=
 =?us-ascii?Q?3QGllsghFdwhNnZeqtZwnae/Im15otT5m2pfuTzKvdflrQz8rLUOb4iLkJyX?=
 =?us-ascii?Q?QlSTtO+woPmjtVaNR/TLH8P/dxLqOyUVk8SmD7pMBiaqGmnhwqwMBWK3q+30?=
 =?us-ascii?Q?LjEATxzRQffXG+XeGIx/6+gzoPrvqRPqtYQ2usAut4BvIMjHWgLregt8v546?=
 =?us-ascii?Q?Tss3vP2+ZmxKqItpqPhDD4hxsfI74n0sLvD2apl0jzCs4WbcZi+uXr53fOy6?=
 =?us-ascii?Q?K4DK7qrFKO5+2G2FM1POcSjSqdfvbIMniINY+4c3nR/NE3saCfRCheaEo3A6?=
 =?us-ascii?Q?R1dYOF6tQHy9FZcqmOy46tE+kNj9jKMO8XQrOm2CTN6EN50iLXrbqrjYmxK7?=
 =?us-ascii?Q?79ZLFAJCGUMvZvuhqtUKTrMAGPfUwaaiuYJwRhM4/bL9uwNkxiYzC1W9pwMK?=
 =?us-ascii?Q?K6RgRjMOVxB8aRwBExZOr5CRxTbMqR2byPtlqa5C9ioSDW8yUrCBrT79Zzcd?=
 =?us-ascii?Q?RIpH1v6oy3kaOqu7WtxrM4CXCcbghLcWhEze9m/EehjS2QUxEhh5WzmcUTyY?=
 =?us-ascii?Q?wi5j8wjXsTA33FstvJCiSuSeWyCF6zlbBeWxaCyHXyKJApyTF2PPD/UN1BCs?=
 =?us-ascii?Q?WpLr6L8LpZn1Whv6L7q7ivY+aF0aqa5xNQkf2mfdWDk40SXU2gAL7Je0m18+?=
 =?us-ascii?Q?Y780+eXsjXnv1xE1L0OeluoIPl+Rg/HMEaGTVBEp4bHrSz8FKclThN27f1mJ?=
 =?us-ascii?Q?J3MbsQyunq0TjVuFqPA7z2sJK0nRD9XNbvlEX+QGaG1999V18CF7cW+PEvEI?=
 =?us-ascii?Q?bRo3W5GeB2u7+mYhaRSza728n478ppLej6wAIk+Za0kKL9JJQPwX5zFsUtrT?=
 =?us-ascii?Q?e8fo4JME8ORIRnhhtc8zI3dV3OAH5e3M0hB0bI49m2Ru42CN0G0/t5rAg5sv?=
 =?us-ascii?Q?JbOE?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B34DD5F0C5F73846BE43860E1285F4DC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c17b8f-4109-4a9c-78b1-08d8bbe9c258
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 19:46:33.3848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hiR/cSvG+zy5ttBk+5o2oKDCFf1lx9ARy5/GcWbZNRYG52zbVEFFO0j7rceXfJ4+gKT0AV0VD0N6veEqNB/fWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5296
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 07:56:18PM +0100, Horatiu Vultur wrote:
> The reason was to stay away from STP, because you can't run these two
> protocols at the same time. Even though in SW, we reuse port's state.
> In our driver(which is not upstreamed), we currently implement
> SWITCHDEV_ATTR_ID_MRP_PORT_STATE and just call the
> SWITCHDEV_ATTR_ID_PORT_STP_STATE.

And isn't Rasmus's approach reasonable, in that it allows unmodified
switchdev drivers to offload MRP port states without creating
unnecessary code churn?

Also, if it has no in-kernel users, why does it even exist as a
switchdev attribute?=
