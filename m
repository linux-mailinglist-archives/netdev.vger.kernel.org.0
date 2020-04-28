Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521161BB7CF
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgD1HhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:37:17 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:49538
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbgD1HhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 03:37:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCx15sLqZnMZcAdOWlTPWpjxROsr7PBOTR6TBVtclxs5/Kyuwa3uAi4JmwFB9elST0RO6DD3ZHf0UHHhx61t6qPVM9kmNru9ZmGy3gJEvy5uD+sMrRTS2Fi92pDfMB17iaaYtPHSGOseB6jPQU77cqGMejrZsZgtoYkh+rEm/yFfkC+1ZXvNI1sRHjmZMRzu4Azzai0LB5KwfD0VdAhmhVyth1iFSnzSUM6QgxoYlil/pXojq03P1WxvtvrvgIkL3qB+6I6e6smGfqt1d5AOoa6StvlH6cOU3klrSnwveohbK6bFF3j1nxGtbWowfNyMOGvzwkQv9nbqdqLMUKabJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zIhMOc+Qz5G7PP+JcQR31xtmFg++offTit58ce5PHo=;
 b=Yx7O+PQiPXZJno34Rn7WMRuTe10Dzq3UcAKpjoPbQkNDqOhrY+5zZ6lGrH1y1vTWgjPjEdT58jSmI1pT1tMhR/GEMKllTTAvsX8EpXevdpt0giDEug08IPS7rzK56ILsGlgALU2c8C8o5RXrramiSmbqibMiby61uhgH1+p0C5S6SIrVB42x69IBMlYxnKaHflc/wI6pzkNAO8FwKvdW2l0lgIx9f8HQL14iO9Nj+etlKlEN5e1IiZFwS0A+Za9ETPIfVN5HLbTlDr+K3C9BFXaiGthv6DpmYfSZWaWsCXewYtoXkkFg3HqnsjYSGIvUSdu8v5Qepy7IIxyi5tML8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zIhMOc+Qz5G7PP+JcQR31xtmFg++offTit58ce5PHo=;
 b=G89ZiE3d0JOxPSc7qHgC697MLZ7KHKGtMcVeCScmQIJQ8zLl7BBwTNxCcDpEbgjeVT2c51Dbh/URgTOyxxXkmOrTfbzY/KMdlwJ9GYqeTf2k7lUAPiIFzkDDaOUQGIhQs5d8wV4y4JP1FDDqufpFfxPyoHy2czR+YesWxv20g7s=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB7141.eurprd04.prod.outlook.com (2603:10a6:20b:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:37:12 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b%5]) with mapi id 15.20.2937.020; Tue, 28 Apr 2020
 07:37:12 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [PATCH] ptp_qoriq: output PPS signal on FIPER2 in default
Thread-Topic: [PATCH] ptp_qoriq: output PPS signal on FIPER2 in default
Thread-Index: AQHWHEYE7veyRWIl2UmwpSoMXKncFaiM/XYAgAEnhBA=
Date:   Tue, 28 Apr 2020 07:37:12 +0000
Message-ID: <AM7PR04MB6885A1B5973486928FAF7538F8AC0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200427033903.9724-1-yangbo.lu@nxp.com>
 <20200427135152.GA26508@localhost>
In-Reply-To: <20200427135152.GA26508@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9b43e63b-17b8-45fa-4f2e-08d7eb46f738
x-ms-traffictypediagnostic: AM7PR04MB7141:|AM7PR04MB7141:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB71410FA9C861D3EE45EF4E57F8AC0@AM7PR04MB7141.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(8936002)(55016002)(9686003)(54906003)(53546011)(6506007)(478600001)(8676002)(33656002)(52536014)(81156014)(2906002)(66446008)(4744005)(76116006)(66476007)(6916009)(316002)(186003)(7696005)(86362001)(4326008)(71200400001)(64756008)(5660300002)(66556008)(66946007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: USst5YKe8MI5xUwTbAZnfd/7IOEbDMwelrezFE0MviIkIPtkjSKTxshOl6kRR82G1aQ2lEvhn5lF54R2XSU4A0AnDLLBJqfxY5lOSjHYxgPDVCshFb8YEWjsFZObtXiHRNafvPacX7dBwmuSr4j8N8u3AhKTK/VPBjR+qwAXSr2PNfn4gdgkNNx/uruNA38bcfD30HDd82jydKwGg0pVGc3kELloeUSnisIKxzHqYihRVXSAGRwqDx1P3i/y51TSfcgbQCXqBWuMxWUUDgB7k4k3aGBekGv7ZGapTe7kFKWowvpHY2Gdkt9wqRFYg+AMVaSIqRkB0b8EtTn1U7UE9oBTFWtvpZOecyq5VFYp1SLRwKkIQiZKjlhErwsL8o1FJOFB7qOu+dUT6aFJ6NVwVA0+azsabOiNUspDExjAMnech7BDizgVaWWhKyO7BupQ
x-ms-exchange-antispam-messagedata: uVCrFATvUtzDE3y9g9ZUmLh/u8CnSF0SDOyZK/UqJB4v24rgtT3oQu8fhQMaUuYwtrv4RAmd1lcXHKQNCncVGj9MXIn0HuvyYJeLoVun2ybhRIQV2dZ9ToIKAvuti/NukGLFzPiyiXQDS+W6j1P+LDdSButwlRMRiQ6bN2sMgYkPD0GV9weuXAi6k382oW9mVME+dkFNJpXcf1floxbbRSLjQp0b1Qw8D60X1EDyUWiW+SWpDbRyILf2QvTpDfX1PP5xYuqlI7LDoPPKtCgblwpuPlPthV7MSO1yRmrBzUKp0McnlCOm8cxxycbla3MPZNsvs+mOluJZQp1p7ZegSTZS/yN/SuN2Tf101Ys6v+mtjP9CgSoibU5Piq2mY9V83WTcLp7KtKGguYNO8LJ3iYkpnZaClI1CKsrTlBurbjgy9ezhjRJZUEeVfDGVN+losDj7A1zhnwetrQa0uaLmSQA+u/UWJemMCBRoLsWFQuQN5MSEP4X8leNx/Zo/sUS+2qAzvVkVMJItI2Q1p02NRUXrMEm4nMAfqgCv4Zd6riCWSfCwxJuOeaCMoVZqoP5J71Fw2j06zHNg0TYp2r3Egi0ymYaBzN1DueJb30aCZbDE8o+OHjTexlD0nVLsOkHGqFOIdtDe/BTCygnvbCaPg+5H7CJ8eEH7/U6StlewgS2dw4Dd+GxC7EcjBEaanQTpjmZj5WuVXJkd9wbwdHkrfB4Ok0Mum0PPB0qtz7/84m1aTkRtHLqlYxfWt5xwMSKd083TwooHzMgrJI6BPrhyfluyAzR5kzdqNwpC/54leHI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b43e63b-17b8-45fa-4f2e-08d7eb46f738
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 07:37:12.2193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dT+doCHi3rZmTUszMDfQ1gBaqL2kGRw4HE3aUy5vhaq8GFjC3/vD1Nyf0T5C2ic3ouFsQxjfT/vVj19exW6AMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Monday, April 27, 2020 9:52 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>; Leo L=
i
> <leoyang.li@nxp.com>
> Subject: Re: [PATCH] ptp_qoriq: output PPS signal on FIPER2 in default
>=20
> On Mon, Apr 27, 2020 at 11:39:03AM +0800, Yangbo Lu wrote:
> > Output PPS signal on FIPER2 (Fixed Period Interval Pulse) in default
> > which is more desired by user.
>=20
> FIPER1 is already 1-PPS by default, and the user can load anything
> they want in the device tree, so I don't really see the need for this
> change.
>=20
> But, I am not really opposed to it, either.

Thanks a lot, Richard.
Yes, I understand. I just think as the default configuration, PPS may be pr=
operer than 100 us period pulse which I don't know used for.

>=20
> Thanks,
> Richard
