Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E189B483EE8
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiADJMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:12:09 -0500
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:14561
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230130AbiADJMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 04:12:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVKdB69di0VO7lXbvs06Cjxz4C5PDjqfpJLuoynLEuTvMX1ZU6XayQbHUFg5pNOFiWAFiFEROYuidOstcj+V1UzByntc8Jd3UTKQU0YOgLh0+SDcNbnNawyR7ao2Hx65Hw0Xj59z96uJHW47SC0F9GlySlSzH14m/M869Ro9X2+xo/jx+xf/HPcpy5XYmce2O3QC0F66138CiThWkf06DAnkwF0E4G9IiCNdn3VPuhWrk1LRZGqvW0pfyDqpkRDjrZp70sze9iF0LnAL7d9YHVE31LKlUgpN/0Cd34ifXHPDRuK12/3Rixe7Baf2L8fn5cgC82+dZ6VhI8kyPtjvDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HX/voe1zcXgA3qbcFer3JhxNukJl/kHwC5XCnyZ+Q1o=;
 b=JgwsUO8UOImNf905L0J12uLRBrwdvqzZuEcZHZncu1FVY+WAAdnmcMkucmIfzUFaPNgh2C6za12PCbPCH/Ba10X3+PzIw62tODPq3AdRC7Ajju5vHxizXWkYxNDBOn7I6DscizW/bVxiJEg4HVWacADiSRiU5jvjbzK5m0qq1isgWpdGgw8oNlSgTjf5FobFZjFXcjqnxBAUAUD17zdSHtat/ecLfOylziiv3ua4dru53sMepf/lSvTu48ddbo1nAIDD+m6n1rIaZjsQuZw2Zk0mzonyM7uSUoaVIl8jO3qYtHdUO4goVJI1cdPhpcitwDZN3XOi+3eGTjYq9rkxXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HX/voe1zcXgA3qbcFer3JhxNukJl/kHwC5XCnyZ+Q1o=;
 b=gXw5aUKCMBjlV+oSLpiya1vVpS4MQMO7qieqmdyqD14RixRu9TKVe3KhxbmSbHtWGR7NhBd8dk9OqMdbwJRPU8omqt/jag41h5gBDcfd2sguzhYxX2aKUwCci4s8xVsuzRSUwonoIu3Yj2qJN8QUOaYTcog/MR3PmJr9EHw5sBs=
Received: from BL3PR02MB8187.namprd02.prod.outlook.com (2603:10b6:208:33a::24)
 by BL0PR02MB4755.namprd02.prod.outlook.com (2603:10b6:208:53::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Tue, 4 Jan
 2022 09:12:07 +0000
Received: from BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::1c78:cded:bca2:3446]) by BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::1c78:cded:bca2:3446%9]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 09:12:07 +0000
From:   Harini Katakam <harinik@xilinx.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Radhey Shyam Pandey <radheys@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
Thread-Topic: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
Thread-Index: AQHYAUmW3hIc4ElK302hVEgJxlXyIqxSkzwQ
Date:   Tue, 4 Jan 2022 09:12:06 +0000
Message-ID: <BL3PR02MB8187165DAF278F65C8024567C94A9@BL3PR02MB8187.namprd02.prod.outlook.com>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
 <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
 <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk>
 <CAFcVECJeRwgjGsxtcGpMuA23nnmywsNkA2Yngk6aDK_JuVE3NQ@mail.gmail.com>
 <CAFcVEC+N0Y7ESFe-qcfpmkbPjRSvCJ=AOXoM6XSK6xGo=J1YNw@mail.gmail.com>
 <YdQMyfYU0wxHrT40@shell.armlinux.org.uk>
In-Reply-To: <YdQMyfYU0wxHrT40@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edf5a862-5e7e-4364-de14-08d9cf6247f8
x-ms-traffictypediagnostic: BL0PR02MB4755:EE_
x-microsoft-antispam-prvs: <BL0PR02MB47553D9E77A7BD8C8B9286DAC94A9@BL0PR02MB4755.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: os6laXA3bwinJoxZ9DHd20f9uwAeostJHLOdy2PDMdNAzdxzeNqYzgeDlUUTgZyskt/8Y6DclYejOH15BjGkySW25Lw3jaq3J46md8oCCcS5t0C84+ORgQkaHCpbGknL/5pSoKOoVM4rb8/FvUQA46UFjTTpoWo/BvsC45lPQXPhfAwMtKFrr1qX+sG9iPjqSP61v6pgbnUTHqJgwexaSYpR6RYPObXsLVU+VXBYlSSOIkBQWy3VNCxYMdZpqXt/nlPizNT4gF+0ioyOCtO9ts092jDVuZA0YIDfWmj2nYNwGm2cFaG2PAGbF32zw4EAaygjyEaR+JP+0VD1dSPJ8X665W7+WKeX+IcpttkzHR/2DfIcY483I7JETLuB8t7fspqSJu19CSdPojPaWYxtgLstfhgKvFIyOweQGaHfyN78bEKUdhJLHoZFolwcWIZ4VZTLNalfk8NXYfCXyZeombx4/BTVmXMAXZvIAKVpFKCB1mvpRakg6ooEDvdFxzrQVf6OCvVsRfNqg8ulQvqOCU/N2OCZ5O72NOVDT7NGTnz9SNvxPvtN4QcOdqxPDZUxazNO4N5lunV3UebvnDwk6q+x8L6U5r2tW20oGTa7Bx+FWwxP+jX6vJjfMauigejsIJk3xn4dUXaCQ1I5el2DBI3VrDsmNz/mpwIBFbCamvFgTG9crqmEsOhjdNhdm/1ZpVv+hJO0/y014GBr98c6Gg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR02MB8187.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(55016003)(71200400001)(66446008)(9686003)(38070700005)(316002)(8936002)(8676002)(52536014)(33656002)(86362001)(508600001)(6916009)(122000001)(5660300002)(66946007)(2906002)(66476007)(76116006)(53546011)(6506007)(54906003)(66556008)(38100700002)(83380400001)(64756008)(7696005)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k5NSvJw6olSf+1tcei22wo45lrU8MxMYUFilYH6UUxBn+FQcFhMU9Nw/GXyy?=
 =?us-ascii?Q?bzcMbceDxn+BMhhnt6OviLh9S9MwIdgx3xVd3prtCD67C1xIdaP8obNc5v+X?=
 =?us-ascii?Q?+2i48ghq3Nk/iUppLsorDPpnQvjtEibseqh8xNW02Pk4YPpO5+GE93bgt/Il?=
 =?us-ascii?Q?VyctVrAMsM44KypxPVOS1O5a8d/ZaKjDAe1jEqfTYrHk7SfTYnDLi2yrXxbB?=
 =?us-ascii?Q?ahyFHdlxm+g9v2SozfufqCr0TjeHaeArv1l6e8gwH9EZulItKtSn2q0vA6J8?=
 =?us-ascii?Q?IZyZRMbiMQsiScQGJIZHv+w7NMgp5nt6rKBEq0/qTpex9OD3jcg7K3cSWDS6?=
 =?us-ascii?Q?M5u0JGFIVcNDCl3kqmu/4XPAVg7EG4Y9+xNps0UxSg1Y/bWyyBH9j40hFTpp?=
 =?us-ascii?Q?H56hgUqbIxLJy8caHHeC/uvbiIjAqi88yB01M/v74I9xKM+MNx8H0nRpZtA1?=
 =?us-ascii?Q?UeBUf1Mef+/trLqR5eme54uleWp5rV4SLPAyGG9QJMXm3bDlsD2tBHMiKqeU?=
 =?us-ascii?Q?mUe3OWla29TgADNsOgAdbb7lFFKyWYj6+PUfXUGGCP3dzmn1ozX0j4+IQKoG?=
 =?us-ascii?Q?QnjdFgxl64uQm3p8xmSYrXP+l1mdWf1fadjEPSTrUnSa1v5Yonx6i597MbH3?=
 =?us-ascii?Q?IBCigD5dwEbBYIxSMQt8kjWhkAFt7eJXI0eiC2ZwWZI748orzGQ1rWLXjYJh?=
 =?us-ascii?Q?IvNJnJr+ZkHk9iOBVNeuOQR9ByVWWinqPLDxLzj0j3uWrpJ12ITZaYjk7BCe?=
 =?us-ascii?Q?z9O9L/AvmqcX7Z3dwo4owp4QFzXR5cIxIrB+YoAf7xJFdHidW1F918A2HVM8?=
 =?us-ascii?Q?+6n38fuT+8BdrH7aLHQcHZR35m3Rc5iFkVx2rlNWfqWxRRbBUH5ocioJfWGh?=
 =?us-ascii?Q?9wkMxAGj7K01DQ0eZflw5NksoLm7vWy25XjCk32/cJI4SkO1GNviu4y47rmY?=
 =?us-ascii?Q?4a28h2In157vZE4BsS39ADpeq35iPUoLtwfZEzwkyOLdE+Vs6a5DpVU1PC05?=
 =?us-ascii?Q?ChFwLZ2+qBozqGD5kKrwYDHecDNC/Iki1tWi8yMm9tyrApcE/50EamsoaJI+?=
 =?us-ascii?Q?28aUEG33IZh+a+nRQj0D0GTTfmFwnHmeCZScfpiUy2wjN3XRvEQBbCEcV1tA?=
 =?us-ascii?Q?nxi/HvyeIV60iQNLA/kCXH8aS9z1q5p80/+ZCT97Njg+ye+NEPFHxFv7gMBt?=
 =?us-ascii?Q?xOSbqB1AYjPCEjlcJvDHG/7rDr5ti+n5KRyoqkH+v7dqPWSkxKDR/rTgcFhH?=
 =?us-ascii?Q?zPoV61YHAYLDql0lkqNy2mc9lrzythFyk9gWxOoy6PAiXQynmoP/lwGE+nGU?=
 =?us-ascii?Q?6IBtWKDyfwOa29B8XZit0X6Vhdf60VY6Rv1tYPLFqWTIsUuYhro6GMpqoays?=
 =?us-ascii?Q?FC+ZlmfioY51VdFxzoewSwmAunMuLe3FUpY23x5WhRWWNCmsxEBYDLPx26zd?=
 =?us-ascii?Q?sq8P6RaShryWIgfzBBvtvW43M9R/VeXuofB6XbgbMhEbzg4uldqs5B8eSC9X?=
 =?us-ascii?Q?qOpj3ybFOoA8BFA1vw2LXCOF9/TVBh01lLydy1cjwZzBwLoPp1MyykjlITHa?=
 =?us-ascii?Q?IWEYP+8DVco34AytSzWNG1nnDH4IKVdMjZ/es4Pj50UX9ssH2YmB2hRTf1sw?=
 =?us-ascii?Q?gdOrMCkRA/pFC7XZKP2GWFc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR02MB8187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf5a862-5e7e-4364-de14-08d9cf6247f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 09:12:06.9558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tHZp2gTuzH0JI2xAPw69CY9v7HKWBJ7HTJ+9qoxOZUSQszXchMhRG78vmvGrEzsPRKtkbPWW9yG+DJW+HznqcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4755
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Tuesday, January 4, 2022 2:31 PM
> To: Harini Katakam <harinik@xilinx.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; Michal Simek <michals@xilinx.com>;
> Radhey Shyam Pandey <radheys@xilinx.com>; Sean Anderson
> <sean.anderson@seco.com>; David S. Miller <davem@davemloft.net>;
> netdev <netdev@vger.kernel.org>; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pc=
s
>=20
> On Tue, Jan 04, 2022 at 01:26:28PM +0530, Harini Katakam wrote:
> > On Fri, Dec 17, 2021 at 1:55 PM Harini Katakam <harinik@xilinx.com> wro=
te:
> > >
> > > Hi Russell,
> > >
> > > On Fri, Dec 17, 2021 at 5:26 AM Russell King (Oracle)
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Thu, Dec 16, 2021 at 07:15:13AM -0800, Jakub Kicinski wrote:
> > > > > On Thu, 16 Dec 2021 12:48:45 +0000 Russell King (Oracle) wrote:
> > > > > > Convert axienet to use the phylink_pcs layer, resulting in it
> > > > > > no longer being a legacy driver.
> > > > > >
> > > > > > One oddity in this driver is that lp->switch_x_sgmii controls
> > > > > > whether we support switching between SGMII and 1000baseX.
> > > > > > However, when clear, this also blocks updating the 1000baseX
> > > > > > advertisement, which it probably should not be doing.
> > > > > > Nevertheless, this behaviour is preserved but a comment is adde=
d.
> > > > > >
> > > > > > Signed-off-by: Russell King (Oracle)
> > > > > > <rmk+kernel@armlinux.org.uk>
> > > > >
> > > > > drivers/net/ethernet/xilinx/xilinx_axienet.h:479: warning: Functi=
on
> parameter or member 'pcs' not described in 'axienet_local'
> > > >
> > > > Fixed that and the sha1 issue you raised in patch 2. Since both
> > > > are "documentation" issues, I won't send out replacement patches
> > > > until I've heard they've been tested on hardware though.
> > >
> > > Thanks for the patches.
> > > Series looks good and we're testing at our end; will get back to you
> > > early next week.
> >
> > Thanks Russell. I've tested AXI Ethernet and it works fine.
>=20
> Happy new year!
>=20
> Thanks - can I use that as a tested-by please, and would you be happy for=
 me
> to send the patches for merging this week?

Sure, yes and yes.
Tested-by: Harini Katakam <harini.katakam@xilinx.com>

Happy new year to you too!

Regards,
Harini
