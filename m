Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769771950C6
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 06:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgC0FsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 01:48:02 -0400
Received: from mail-vi1eur05on2084.outbound.protection.outlook.com ([40.107.21.84]:6031
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbgC0FsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 01:48:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flGUfK8RhJEQBvoYq6Pl72fdqHlvEj2fl+1/+G+pivaK7cf8xJXRdkRdiLGvyDTVZQXnwmbfEZBf7FAMHE1ytjhT6kGr9K9ObIhPG8tHExXLt622z2h7zqWEEUiUSLYhBz56gKNfUuYESmDph1mn5jC36/CxeEqrCAzC0wn3W7IaRL8pvr6CMT38wDwgAmC9O/jdyHsw0kO2DVaIpfBTkSW9n4WbL9LIhZRhu/w10kvf6pCXCyHq1f2F3Zq3ciqNOmoc6hCsVGwpbDsv5ZoWV+4+u3yOmf7I44qdtDGhXGlhq6J7AdAUagziTrDE1HZ2+k0NgY3t8lZltaUYbytcpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LzBWGCPJsGHNkKTKbFDO42rKN/9KhWCwQ9q/Qc9ceE=;
 b=g77DK8z/MsXEd3Ko0FABqBifPii2NfYfz18V9A8GcKMmnS33/ukneT+qoPPbmDqkvrN+oiBpYxIpJAc0ikp99D+2vjWsNbPjFgb8tGip5r+MNxpi5k2MzyABefyVOWW5QFi93QgTTek7Wvzwr6scaNEGqd4EEvOx99mdiH2jAV8euzOBU74oxBMJOK9Hhy+PEDnLy0L8R/51tPnxafgzUyNF9+J7Jb6PhmX/qL8/qSuq84gcSai+4EPoSJCwkLyBBd5851pLLmIrbcJyi2Hatz69cu2QYZE/ZgOyFfXSXPxBf26MqSdjKE/J0wlXxbr3uMK6tCOIwvNizBp1Yiay5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LzBWGCPJsGHNkKTKbFDO42rKN/9KhWCwQ9q/Qc9ceE=;
 b=AOkUBp756sMU7rWt2Zjj0un8SxK/UDLTRe35OJ5r95qWmS26Dd0/ynL4zUW6oo8aTb3muKwrWmroTA9373QnV4VO7OFlkxvZr7F++uLmBz677z9HyYSsR/MW9d3D373l31hhXDFz3102CL0kU9non+hhrAz/lx3If4BqT3g+3BM=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7189.eurprd04.prod.outlook.com (52.135.56.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Fri, 27 Mar 2020 05:47:56 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 05:47:55 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Topic: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Index: AQHV/qQWBIiKj5A/T0WD8BjMeGVxRqhXvRSAgADnAvCAALTjgIABSqMQgABMsoCAAQih4A==
Date:   Fri, 27 Mar 2020 05:47:55 +0000
Message-ID: <AM7PR04MB6885113954C96DFD69F2C692F8CC0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com> <20200324130733.GA18149@localhost>
 <AM7PR04MB688500546D0FC4A64F0DA19DF8CE0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200325134147.GB32284@localhost>
 <AM7PR04MB68853749A1196B30C917A232F8CF0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200326135941.GA20841@localhost>
In-Reply-To: <20200326135941.GA20841@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a34ec04-094c-428f-0c99-08d7d2126608
x-ms-traffictypediagnostic: AM7PR04MB7189:|AM7PR04MB7189:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB7189BE72F4B3BFC2B356298BF8CC0@AM7PR04MB7189.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(86362001)(9686003)(52536014)(33656002)(71200400001)(5660300002)(6506007)(4326008)(55016002)(53546011)(54906003)(2906002)(8676002)(478600001)(186003)(81166006)(8936002)(26005)(316002)(7696005)(64756008)(66556008)(66476007)(76116006)(6916009)(66446008)(66946007)(81156014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w5VLmWIMFNNXYJ8HgFSuRshEmZWg6eag6L76cudnzA6l4+w2CdE24dKD7ZoADm3YwR3bhg5egFEJHTmPzEm2uuc6RLApq9xdhkCZdCvfygYC+Qm5or2pGO/FD2+D0YcKgA2s0FQD117bfeQNmQJzutSBjfPkK/k5R70BXl0bTrkYlv/RlkJrKoGZ0s3Xm/zif2vQXu2oD32EKyodhGiPA0vRxf9hvx6lZZ5wKC0YqyikM3SlLnynBRfv2Hp0ED3GSzuLrL+D1JszidOFCG6JGh3+xjlKiBvrYTq40Xx0FvdTksGYIM4iGDYtzxH0LImred5084mfoUVrs4uUhzY6YrYUZDhcrczdes50T6HlMXPFYFfB8dxNfdRKmDxDxZ57EfcNOF6pzgBsqrveyoipx3GCWvbO7HQiKUsMD7bOihobptN5YMlhhReRomoqBiLU
x-ms-exchange-antispam-messagedata: U1bz0796T4oGc1i0yHNnFEmxmjWFNCK3nsHvSRYT5BuNOQAN8fnv9y85rURXTcyrqGUNRYe2/BSow2iQ/tReBzwAW/A4rtHQwhviKtePB43E9Enf3eSy7hjlFlyYa5BdiUivaY76iY22Ur2/bKsZ1Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a34ec04-094c-428f-0c99-08d7d2126608
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 05:47:55.8465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q9MRBNjT36byQ0kX34dm00U6aydomQcAO5JwJ5qxUs+S4hb7aO1LW9Bd9Z8/PWEgX3s3smmKGdnPnuj9yAUStg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, March 26, 2020 10:00 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; David S . Mille=
r
> <davem@davemloft.net>; Vladimir Oltean <vladimir.oltean@nxp.com>;
> Claudiu Manoil <claudiu.manoil@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
> Vivien Didelot <vivien.didelot@gmail.com>; Florian Fainelli
> <f.fainelli@gmail.com>; Alexandre Belloni <alexandre.belloni@bootlin.com>=
;
> Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
>=20
> On Thu, Mar 26, 2020 at 09:34:52AM +0000, Y.b. Lu wrote:
> > > Of course, that is horrible, and I am going to find a way to fix it.
> >
> > Thanks a lot.
> > Do you think it is ok to move protection into ptp_set_pinfunc() to prot=
ect
> just pin_config accessing?
> > ptp_disable_pinfunc() not touching pin_config could be out of protectio=
n.
> > But it seems indeed total ptp_set_pinfunc() should be under protection.=
..
>=20
> Yes, and I have way to fix that.  I will post a patch soon...
>=20
> > I could modify commit messages to indicate the pin supports both
> PTP_PF_PEROUT and PTP_PF_EXTTS, and PTP_PF_EXTTS support will be added
> in the future.
>=20
> Thanks for explaining.  Since you do have programmable pin, please
> wait for my patch to fix the deadlock.

Thanks a lot. Will wait your fix-up.

Best regards,
Yangbo Lu

>=20
> Thanks,
> Richard
