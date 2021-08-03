Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF023DF68B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhHCUo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:44:58 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:53543
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229551AbhHCUo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 16:44:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAxeQ7k6FTyjO+czZeTR/tzqb3pEkq/mbEJICnpKDgtWn2KNoOTaQfxFz6rOaxjJcp2amB+RpS1HnGDVV32QuLY43EZWAGRloVhJhu7EnppaAZ6S/NZDb2bxbnYH08q095VnHEBkSF0YAGXcPH+quARKcepn8OzNJknOhJmv6oY8uG0dNCjXuEM7PNLZL1Ob5dn8v13fH+hP644i11V5PFw59SRkLXG/MFw0y1q2cSy8wR41qjpx+8J5CQxtxuMEDNy+65WSN8xmiKES+EsqX4uHznYe1JyxQRNP7gfkN93/gtqJ/3v6AfXBIu0NQARzMb93NbUDMw6r/65UFustCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naiLnK5Z8Oi+Ea1QkJfEpIzr9B1/OLmKcdpkiIqCX8E=;
 b=ef81KhvBJbK0dfxmQMgTPicOzYG2l0oPFyp8B71IlOhgJuN2LIys1UIijCYsopSv5yA5o08FQFqAB93A8JeS/vTIKM1TwWboHuO68rN9M5/u9W2W5XWSvk5w0jHvSQbj2fEWhZSFocdmbtBGZbI0+l31N2Bqc1ZsrpxHQfpwrj0r1hKTyGZW13cuh3gX5meobzYjNJPshhaEiYekzgOqqs0SY63NQ6sUoaMFzf6ICvNffzUepqFbEPb4P80IzF3HntrTXz9ZWHHW229yDEeHtwMgyUCC11fBYEF2tc3b4b78UZqHqeIFT/In/b1o2WBkcKfocj4zz/DFF5ldSxsPMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naiLnK5Z8Oi+Ea1QkJfEpIzr9B1/OLmKcdpkiIqCX8E=;
 b=tBC72Clqx0DFpxW9bmsjMhmt4keThU4nE9N5QeoDOQTD6Nro2sueiysSKrcX3upv7M/CC5xqZfUgdaoaX8X446JMxYJpfjD8gONDd9FNvYDTnNWPh+WYE+l2fNEjta7AKCPQXQIWEqCwqmFbnrAkUFOKeYTJBj7BeVfTnKGCeKI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 20:44:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Tue, 3 Aug 2021
 20:44:43 +0000
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
Subject: Re: [PATCH net-next 0/2] Convert switchdev_bridge_port_{,un}offload
 to notifiers
Thread-Topic: [PATCH net-next 0/2] Convert switchdev_bridge_port_{,un}offload
 to notifiers
Thread-Index: AQHXiHT2bKwV5tFJ4EatXrPlu4SfBatiP8gA
Date:   Tue, 3 Aug 2021 20:44:43 +0000
Message-ID: <20210803204426.vw3s6mzo3yjeszpd@skbuf>
References: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc033873-4f5f-44a1-3d55-08d956bf8631
x-ms-traffictypediagnostic: VI1PR0401MB2509:
x-microsoft-antispam-prvs: <VI1PR0401MB250945A017EE00CDE09768C3E0F09@VI1PR0401MB2509.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ftGq7CnVJ/Tk5rc2oXhrtYCE9CVgZl51Ngbht47LW6mzLCCIxpss/zwG1kptZFCPOLFyTD1c0FrQgD/CSoEWoRp8z95WoHHJSoK/HyfCO5exuTxFSmD+iW5w8aRHTAP9kfSZer5jWZqrSc1tN9yE+PVW3sK1dgHcNMusLgrhv1T+uv0lPbeHXmd8O9UXx0rsP5Wqn3jF4UwTxz3Ziyha84ls+DddS5/rtfICi8ouqt/ndqX6USt6asrQ/RubYXj85rGe5lJhoFgnHkND455lq1siE5Tk+uPeiky8OVynDdSdA4BvrBvOUkOFKZvw1KdokctQbv7BLkCFbPlstRLgioWuDdsthY+eulK0sDHTFvn8a7xgw3WMSwYQU4y3jELQRnQNRLqvagTs+hOQDKJGbiRobYN6DoCmetFxonJtT/s7N8jpxjS+lGHGsSp/WTU0JUA1q+ImNJBstBa//V84wRJ5wcYiEnmCS9gKaGCm7iudS/TvDatZFsQaFyB3/etRp2tusxIf8zKo0Jmaels9Qqz1NOHU1Sxis9InS2WKIIV357CQWVlBSi/I6noQYCtPwk0/aESFKM3TvExA6mV3lAR0ndjHzvdMamgwpddN7rQqT+DrVcgTvuPn11drqnvOA29JiQABlfLwnWushiJJww+4stE4TfK4ITvb8R/loOhHrV6Oth/4r/a31GIzAE+F3W5leSUL/fBBuNc9gTvbCmFdUQ2ElwpyIBGwDJ5+e4gAhpVcTa+iIVQOCAu0TSIRAoFPaf90xC3A8d+C/ZIzEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39850400004)(366004)(346002)(136003)(376002)(38100700002)(2906002)(54906003)(44832011)(316002)(76116006)(122000001)(4326008)(71200400001)(66946007)(38070700005)(91956017)(6506007)(5660300002)(66556008)(66446008)(8676002)(66476007)(8936002)(7416002)(110136005)(6486002)(64756008)(86362001)(26005)(33716001)(558084003)(478600001)(966005)(6512007)(9686003)(186003)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fdymf7wSHqjPPXAIY38lzKmKBFXW1HHN3QztLDZqjj2NFrsn3pdiz9S00hlb?=
 =?us-ascii?Q?tJi5nrHKxHTWkpwpVp+T24yTO9rDfQtkMnTggt+yY6/oWe5RvuZJgX1gErdP?=
 =?us-ascii?Q?rT1pdA83aU+wqAKk/R/BU4WfOUq4ghu9w2p3BOvELUPKicbJscHjdZvaReC7?=
 =?us-ascii?Q?r9xMiTF3k7I8Xm/8EWbBLR34U4DnvZnCVsXFIJQFu9RcHR/dq/e6GcVOUQaL?=
 =?us-ascii?Q?IU4wIQpwZLm4vjXLJpCZ86O/cknvRolAq3YS9qidOQyQAQCsVOY5QaECiFUY?=
 =?us-ascii?Q?2OzHF9YNB2dnCBGEClti9U5stLj9mZLrYJ7xpwzUS4Qa5hRli/uStoXGszt4?=
 =?us-ascii?Q?C+pAuKsVckS5NVVS02EUJUbh5/wqRlwF+QbXpJOfFYn0BAR7I/zwEFsZQszT?=
 =?us-ascii?Q?did2xUEc/XbLTAvvaf6zhsUodpwfe+bMB/aFGqIV+b9XE2tiNV3Q1Z3uDLJV?=
 =?us-ascii?Q?a5L0XqjlBmll7fhnLPMHIogOIQM/28efvO0PdcsaPIfTETbi7RDhA3rsILub?=
 =?us-ascii?Q?0Is6yrPLuALZoEl3VEeMSTggflCZAMPiregzAOZvMGCajAf+8fB8ItG5dfPc?=
 =?us-ascii?Q?0Z3XNBkiL9nx3YsUMZe1Jaf7Q0xPj3YgwTTqVravy6vOt17FAh2QY5/JZ02G?=
 =?us-ascii?Q?Doj01IAVmOzN9jSjzRyc40YAblJVdYHJnsptpTdsD211diCjkykW34V0BJDD?=
 =?us-ascii?Q?Ec+6BGQcGYtnJqDlplT17EMJLGqiQbGbPSmIZSyghB0aXC2p1PcxwjJZcFtG?=
 =?us-ascii?Q?BNvjMBR9d5cSK6OZCjJUJoGdrUC3cEM/mMsR2UBmW3G+Rm1/brV0EqY2Fvzl?=
 =?us-ascii?Q?AsDa7pbBe5LsHaNBlzldppb0EdC/4pji0ph7tO9Lv9ZcvcMAf6wOMs+e5gJu?=
 =?us-ascii?Q?9OOE2g2jjwXOH0t5bb76/s1f0MkgmKJZEL6o41nANKA6kWZ1D2clGH7UVM30?=
 =?us-ascii?Q?njc+ZenPmAbHhiTNgDkPM4OrnR+1GEx4y/v1od/dmqfjOK1Yt/sNQIqIUZ+v?=
 =?us-ascii?Q?fVsoaAi72RiN99+F3dKCsh2jw6ddbP/ie8+jpjkBov/bWWNwGUMOtC9sLYLa?=
 =?us-ascii?Q?h3rYftQvWboBhgfrXOC89MFUUmToHQ+359QlvIFI8hOz0AbBrt4JgAl9bDSh?=
 =?us-ascii?Q?XFUotMylti0pNVEHctUiu4ijoczW1dnGRhu/oJ8u0JH6eZmCkJIWzPCV+mZB?=
 =?us-ascii?Q?HdFY8+Cxmx/upruMYBIVbhMQdRtbL0H1H4P80o4CpIMJftiEdCO1oNvFPAHW?=
 =?us-ascii?Q?pZXbmT/9Il8TQe/l1PVtBpXHIDLH78u7LmLQO+hFDlXq3+276JMPVz/7nsTx?=
 =?us-ascii?Q?7EtHdcuw2pdOJ11lnYBfoP81?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C03B995806504B498A9F42BBAFC65C89@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc033873-4f5f-44a1-3d55-08d956bf8631
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 20:44:43.7083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EwmIHTe/DyzW8Mw9Y860AdmVPWSIxzVC6dcnl0wi/5bjlNWWTie60OZ+KpJ5mwYjCWk6l55+vone3nBttlhtVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Obsoleted by v2:
https://patchwork.kernel.org/project/netdevbpf/cover/20210803203409.1274807=
-1-vladimir.oltean@nxp.com/=
