Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962D03CFBCD
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbhGTNeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:34:25 -0400
Received: from mail-eopbgr50064.outbound.protection.outlook.com ([40.107.5.64]:30702
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238408AbhGTNb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:31:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAugH6tCzDfWYw8J5vo0feUeP2jHB6POUv/t7l5xY0uYZcCQo3tcdtX01vsWH+z+Zp8rmW3cB95164AodGu/qnIUvmqYMONKFj4846Al6H8Rlvfupct4eh56E5S/vZQuJUPsFSA56v9O2wXnL2whbgua3rxKKNNfC1MOLb3RjOiY+FGYBoav8SyjKDa2OWcHBGfl2V97IpNhbFtjX40UpKZ4d8UpvrnBonmwby0183PME1Vo/Tyrc7okgYliRfTL6p5FoWsGu4jJAG/imil4NXLv8BC0vrqSS0nXiQgTFYW3tguoIl2RmVV1KLkLAsiEQTu7ibGPV/wWAzm9Kdh0vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FtfHsUJ0xVo6mBSS0eqRxwObXBZjq/upNin70ySGYI=;
 b=LhhkJeKXQXQt7Zrh41rJ+FBsbUc9g+1Xg6T6iI7mjB9lXFRDIoYaQnx6PK3G8/bQjARpj0d4JYmJHEONawiJ8FXo7qq2+OprhQ2q3o0CuvSOQ7NmGK/KN5h2IoAUn89HR3BMkqTldnzP6FruD3tiN2CgOW55Qvj2s9OfFc1ogopchoG0ZNINeO71Plej7ZQsfe2fXTg8ceOcvRd4ZK82XU4Jl4eL0iSH4ii1HRDKzsCNDzddIxgl/Z2UlCpoJfOOBBViR3504c2vyYeUoLcT1apuGsaZ6cXJAYNx7NA9frXQugpJ61DiIM9lAbGZQQi2zQ972aQIAe0j7Te2RI74tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FtfHsUJ0xVo6mBSS0eqRxwObXBZjq/upNin70ySGYI=;
 b=qFT8r5qs5R5dn1xb2pdtgllPZ7I3v5jBph5SVBcRVegWI4PEiWiWhSBU2p9RJJLbXmeslCxmH+v4sfKgcSaktLzuOXpSwGtZZm0eJwv8Kax/l6b9bQ8+zcEDhEFZXVuOoosL7IIdHzrFeRwryTLadA8rRFHTseRC5Fz7RA1kGmU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6013.eurprd04.prod.outlook.com (2603:10a6:803:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 14:12:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 14:12:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Thread-Topic: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Thread-Index: AQHXfW29xPYONAiJQkyZbYsuqj9IL6tL5LQAgAAC2QA=
Date:   Tue, 20 Jul 2021 14:12:01 +0000
Message-ID: <20210720141200.xgk3mlipp2mzerjl@skbuf>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
 <YPbXTKj4teQZ1QRi@shredder>
In-Reply-To: <YPbXTKj4teQZ1QRi@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe708f28-dea7-4163-acc1-08d94b88582b
x-ms-traffictypediagnostic: VI1PR04MB6013:
x-microsoft-antispam-prvs: <VI1PR04MB6013B5BAD2FE4691EFD03806E0E29@VI1PR04MB6013.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aMIvirj9a5tWnzF+Rha2I3e5a9zEavHGjnoHxuLnCt1/nMRnqnMFd1aUqj/umdtRUhtGcCyJ9WuL9pnYlgTAnBT+3nANAk3Vcrap9wdlN3HZ9MyNrSz4pROh9oGj5tdN6D6Lh4gcFv4hkA+/Uv03ELpTPZKYbcHBVmIAhjwLEjrbj/K4Dg0fkd4FmJzyMRdoq45XILn0ZisXTMfgOCv1AoOzlvh48meg/extfPlTxnX9DCXPuOR2qODII46d8mBC2ZffS7g8aGDDBi0qNbhobPizXy/8Z6RCPW8pcCmUvLL3J2u+igQL6cmt1bqI8pj5ZKXIMJ71B2zJdLgEXI0bKiX/406Ld/KZOQD98CPBTYvy6z3ScWHHcdSzT03/TNLWu9dWUlnk8GPPi9+PO58Cf94IbradamU0x9p8+Z9pqqSbBrN0CDi+L0zihOaktUvG53amEzGSskgdrvDJbV+IRCCcpv/MQ4gH0Sbdluyauyf+e/khpIiozBcprsB+hUfjPRhoujbk8EJypEB7RKkGPdcGCItgjohnG6jTFaU9rHedfjDp7ed+uQXwspuQjpmXaVknvytVtUICV8+duAkGySW++14IfZZhJkl8c+37yd4+nDE13TxOD0iXCKOHQI95of6IGL2pSoHOxjzsGl0Qrc3eKbYILPrGaNr5DamFBoBKPYY1ZCyCIR4YojNK0gto/9JXYr2tRRsJu/Cm6G+q0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(136003)(39860400002)(366004)(346002)(396003)(64756008)(4744005)(4326008)(66446008)(316002)(6916009)(86362001)(6486002)(8676002)(26005)(5660300002)(6506007)(54906003)(1076003)(478600001)(9686003)(71200400001)(186003)(7416002)(76116006)(2906002)(122000001)(66946007)(6512007)(91956017)(66476007)(66556008)(44832011)(33716001)(83380400001)(8936002)(38100700002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BlSvVHd0k8dEpD61Uagg3ig9tlZxzK7qBShqdsbWRk1h+H44R5+CMVGGxF/t?=
 =?us-ascii?Q?VoyGhPj/E7bBdINDNuyQQBCVRkrt8zRLPdANSF+H8PugiUo1ISWlEu/LcXaA?=
 =?us-ascii?Q?X6cbqMTdF/G+b7n22Xzmb0xCfVO9CzlNX9l70SBEiHc2tp8A3Daz9+6iZtpa?=
 =?us-ascii?Q?hQnJee0ITs4ibOtZ6sF4j7uHv7rX349wViayre3e1dYFrNU9DxS047za69Um?=
 =?us-ascii?Q?bdXIlOCfrzOq1JFVm3BL/goigv/d5zSjcdA6LEjN2MMCPiRkbCUCgwPX3FSU?=
 =?us-ascii?Q?kSGAWzuYBTkoAKssiWAYywXdLeHNEfo+AsKJgTEjh50XLxcu1wfGR6aBfmfg?=
 =?us-ascii?Q?dUr+YubBFo366zpTTfM+XY6VgkMoWhZDh2i3Z6bW0zNItLFKBYHIPjnB9J5g?=
 =?us-ascii?Q?vvAK0z0lA2Xir1y14hUYZCaOJeWutPj+WPMtKwOGOSarWfRA2hlrQf0ighuK?=
 =?us-ascii?Q?nzdlXP8OjCZT2ryxd7Q1LL2vs71S1tWvqQf1XJcqHjrjQDKTMhwD3t91IJdN?=
 =?us-ascii?Q?+YswZGfp+ckI8GTkizmkYCGHqP8Ef+D0jWvyGmUIAgTkPTqlCvIfcxOxodrJ?=
 =?us-ascii?Q?9EsWxAqCOAXl0L6nyA2unavp9ERkRMH63rsCGoae7Uil6S3vldiQ6JQjh1FE?=
 =?us-ascii?Q?0mf/PFq3mQKqXBRwsxCJYl0osTHInOlM74cPX3fSVSKpUMjoFzJIIGIIrnWl?=
 =?us-ascii?Q?U3DmJGwJxSOkYyOQ9IRejSwJc3XZtlcKjPhEYuS/z3hkOQcQxggkc/RQnQle?=
 =?us-ascii?Q?oL2G4OrxKSMztyY5osM6n1tqLtewMlL1iR4CbkvyskpqXIfofF3/LLaMKCbm?=
 =?us-ascii?Q?jzDATN2axHt49c8O8fsv5nIrklW02tTySKlzH5dX8MYS7eXKPaSZYwzyD+ET?=
 =?us-ascii?Q?xEuAHk1fvVN9VNypnz41yF5QxFKh41WPfAmmFIRq61l+kdL0itISuL9gS+B+?=
 =?us-ascii?Q?B3W2CGCBQVnMQfeUA68q3rPClJ6Bm0DGDoUGyEyx4gpO9Y8ZC/AMyM89H4pz?=
 =?us-ascii?Q?0vKlypRpWb9fmqtuMrxtxCes8Z1bmJ+V0ggQ5lBHocNaaPqi8WZHcMya7sSj?=
 =?us-ascii?Q?QeFtkw5aHu15z3fHjrT4wdBM5K1mgQRD7AcPX9zMmfbX4sPdnmKToT/L+tyA?=
 =?us-ascii?Q?HMxBMh0+6HtspJsj3FOAnXT7wLodRojfYg0eiBpsTktlpcGpkoS5XVEDe4XE?=
 =?us-ascii?Q?/MGdBK8SHTCuogvIqFhBt/bpg7EQBgSYn2gCK0KdtqxRdFZ9CoS9CwGwi2+K?=
 =?us-ascii?Q?EPdF3brlHmkPdSZJ0syHu4Y4CZggeYyZW/JxNYYsgx/q+z1DJd9y7xjhDr/m?=
 =?us-ascii?Q?zcSGqflLYsQ9gkRnDOU5jV8E?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2DD482720318ED4397DBBD6260B0C006@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe708f28-dea7-4163-acc1-08d94b88582b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 14:12:01.5948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9XWugWyJWssfE0HCX53kWypS+nXB14dxSFt7N7soqNn6beOcCNzO4oXo2wyU/tb5/r2UFVB8rovzZHX7UcLwIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 05:01:48PM +0300, Ido Schimmel wrote:
> > The patches were split from a larger series for easier review:
>=20
> This is not what I meant. I specifically suggested to get the TX
> forwarding offload first and then extending the API with an argument to
> opt-in for the replay / cleanup:

Yeah, ok, I did not get that and I had already reposted by the time you
clarified, sorry.

Anyway, is it so bad that we cannot look at the patches in the order
that they are in right now (even if this means that maybe a few more
days would pass)? To me it makes a bit more sense anyway to first
consolidate the code that is already in the tree right now, before
adding new logic. And I don't really want to rebase the patches again to
change the ordering and risk a build breakage without a good reason.=
