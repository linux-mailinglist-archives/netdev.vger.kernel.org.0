Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1681E356FFB
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353427AbhDGPRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:17:06 -0400
Received: from mail-dm6nam11on2100.outbound.protection.outlook.com ([40.107.223.100]:45793
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232001AbhDGPRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:17:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMwaLmwGF5We2NYCDlnx9jQR4gPATjLb0swTjGkMafz5Zd4SqLUzIOKiZUui44kwKD35Wm1wvmOEp0cFVksZQTLzl1qnnpURROa+q4wGG0EaIdFLtB26lMObqP+r+c3bxNAcIstPY2TteLCjcvEbkM9UGKVpYVGbe6k4tXDWRTNkeWf6KVwH9idCQG2WUxdCvOhzjsZ5h/TG2qATnFDjtzCPFTbD3EIk0ZUlUKLlZF90qhmr6HHvPwdBD4jkay2fT6sXZ0CofHenYi6nT0ofmuMgpc+2xDt5NyJh2OsAGmLT5nUAxVXFuHdPAC5ZJO9yMi4TvymW7lTgSnKnnKsQ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jn3t7GNHwxNK7HB81uJkmA6/dbFDeSl1b9ZMahOY4ok=;
 b=fm7xbLyBBAwriIenVa/n8RpwdRTWNdr/plKYl5oi8q1VJp04jhW05Z36SzhQnyKWeMB1jtWP75MnKB9yfTpT53rnhKLFpRvjNdB/k9kgrK7EoFH54BX+7sg+rWgkSEL/A0qBNp34lauRhDb+YCeU0A3CpEd5Tyn5OqswSwu/G0c9lLHgdYCykTi2ymE6Kl8kETk60Gu2RMMajGesGj9KVG82wg7X5hCc4lYpCS20dOkBoR7zdsT+sGefLkmYCMcxGapeV066LZc5klsuk7iBZvnMVtYd9MU1skzgHao7H9ZHJ+xNuX8xnUMmE7ajCdsBrN7QJGQIiZ68yYnymcB40w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jn3t7GNHwxNK7HB81uJkmA6/dbFDeSl1b9ZMahOY4ok=;
 b=erlJ7vscvn9xSt0t73611FTBU54fcXxr1ZzVPxW1FxSPclE/oTX+U/k3wEx9vqoKqrltfiTNnfM2BGJKyF1e5s8z6Qohha5Rf/bp4enLnr7DtCyXXpVKoXURkedeDXgFH0HV7VuqThe/hNQULQ5/CHpLy9TnkyRBTI0hM+tDluE=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by MN2PR21MB1391.namprd21.prod.outlook.com
 (2603:10b6:208:203::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 15:16:54 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785%3]) with mapi id 15.20.4042.006; Wed, 7 Apr 2021
 15:16:54 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Wei Liu <wei.liu@kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXKzvmwFT+jLn9hE+ope3TVVs2GqqpCiOAgAAUhFCAAAhhAIAAAeVA
Date:   Wed, 7 Apr 2021 15:16:54 +0000
Message-ID: <BL0PR2101MB093056EC7D9206C151119FEECA759@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <20210407131705.4rwttnj3zneolnh3@liuwe-devbox-debian-v2>
 <DM5PR2101MB0934D037F5541B0FA449FA34CA759@DM5PR2101MB0934.namprd21.prod.outlook.com>
 <20210407150030.wvwz6cebxjtjpgfv@liuwe-devbox-debian-v2>
In-Reply-To: <20210407150030.wvwz6cebxjtjpgfv@liuwe-devbox-debian-v2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=59edeabc-23bd-4ef9-a7b3-9f8481585db7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T15:07:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 734bf35f-e514-43d4-ecd1-08d8f9d82da0
x-ms-traffictypediagnostic: MN2PR21MB1391:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1391659F4D760F46FDB597A7CA759@MN2PR21MB1391.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D6iUnED/cD0blURgTdeOZ+rJO0Pgo2wwaAyv3l1OCYtS8whApQikTNn3aD4HPeOIBlETX9qSFc0wituyTjgp1EyuC+s6/OMU8Y/Iw4fB8OTxXp+34NTiQW7Yk5T/tUNKAJ7cRrjczv0I3z9glnrZ5qgjI/c4F2UAyunarNAboIol+JPWH2juONed8asFshNFB9HsEmp2yEfhXtXfPWUExB662kC3q5l94xj7yEvp1CybYpkEqKfmk1zjzSQJGE+9NTdbpRgFDzx2q3dNRcrJA27yBO2aHaNZDP72MG1ieUJGpVrvftMTIuihOgQGg6uNY04mM11fit6ROxGMwpW1BfdlFwKLoHExtSZGbmSHIxkUsLCmabkURnzrSo2QSWJfuBODR4IieqckLw9deTuGSpxSCzkFsLoX9p1OkzeLyozWjBkqiwnav9UqKDioxLcXFM6xH8xFr/xiUdXVlg8uc7bk0UUAACsLpo8afhmQS+rnG6xo2gr37/23Aa0rwq1LFEsW6g9gdkdMCj0IQ88D6sLPGq98cfKq/PV9GZqdWLXooyzMd4tYmYBqGig+mVmPKNx1VPKpsOC5LIi+MuHfOU04TKLhsmUqWgRDl0gNG1Uj2GjDYFjmvnYygn2MxzoQ72gedmyFwtZ3BkJavKV8KPuaHOSxuucETbfRQyhKYg0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(47530400004)(82960400001)(478600001)(2906002)(82950400001)(53546011)(6506007)(10290500003)(8990500004)(4326008)(316002)(8676002)(64756008)(5660300002)(66946007)(66446008)(66556008)(66476007)(7696005)(38100700001)(71200400001)(76116006)(8936002)(186003)(33656002)(26005)(6916009)(83380400001)(9686003)(55016002)(52536014)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wH0gjzEiOFXHzW0WLGlrwgtllzHm/VRJLX5Thy60fjY7ekueuhBZuZHYE1Gh?=
 =?us-ascii?Q?1jVmEkDkTY6d/aTBkJY6O0gBuFyJ6No3uCE8fXPqV5fYLU8YmuEJE4TJ/9Pf?=
 =?us-ascii?Q?Ug4cIhcxcFC4g/1hfMdAYJ1v53CkjfU9OwubVBqr2MdWkE9TK4M0KcrS1RXy?=
 =?us-ascii?Q?jucxqgFWd8hr4v1OPh6WQXPSmkKajr3fhD8UXIAWTzjlU3KZtgortVXpDOS8?=
 =?us-ascii?Q?07ETw338QT72A1wJ+uEIsRF4FdqyQR++oG8J0n5rrivTny0eYm3Vc5Ts6gx2?=
 =?us-ascii?Q?4JtfNdlPrEJZjBhysGO4m4ARUDOgHfGmWaGTMqaKN+iThNjkC1KExg11rB4t?=
 =?us-ascii?Q?EMzRpK4VAyYOW9yu4HufL577RTuF01rojl+hk/9CBsQ2IZQ3D9OcJfCDNsim?=
 =?us-ascii?Q?cQorgrqLJYycslt3UvUnUbPdn9xHET2tnDip5LZTgUoNde0d69bWPRhuZYuF?=
 =?us-ascii?Q?NgwEqbwYNgfohDdWCeWAn1/ssB6Jmqfjnw3Oond+Lyk7e3G/CxuAsOzJnT4M?=
 =?us-ascii?Q?nWUrHP/A6Z2zlc6FK9lD0clM2Wt4ENpIIFn22ct9KE8ZABHv5f8zY854d4A9?=
 =?us-ascii?Q?x9/e4nu4TW7xV16NU51kYhaRTe4NoBTl9JBYLiUf5YrqiQefvDKizAffH4vp?=
 =?us-ascii?Q?yqyL9Q+/ZuFVRnDrYmT8ODDUvlRG9LjJ2rQIyfqi0RioG8eNoENSmioBqSf+?=
 =?us-ascii?Q?H1xD7JwLZZTvOyV3fDiKsUmr5tir+xFBn3j+GW2/Fe4WBDKiMsEm4ybmi4WL?=
 =?us-ascii?Q?r/f2D4dcvSsNJCQKz/8iAllNyOBUTE3J6e1zB9vB4TCNueeKxdUOf8gz3ONX?=
 =?us-ascii?Q?kSoLDVPL8VG9DkLCDEHqA0nnS8aXgoRN7tIps6t+V/RWG/zwVFrqmAhfERvE?=
 =?us-ascii?Q?AAb6XKEBNRgOZE9SU8JdPdidV1LYVZQ9Z8ZfQHcHPrmx9MeH2rPbSWadezMG?=
 =?us-ascii?Q?U8eg6BdBmhx6OXHzNpwZ/03fZJuWSkwQ4tr66yBUUoZh9ITAHFN1eIDtj4aH?=
 =?us-ascii?Q?uuEj/Ia58J0lfjqyO19YuAHbHijVf2TuLfwe4y3THiEiDOlSGsVUEVoTdeBF?=
 =?us-ascii?Q?YBBybgWMmX2/g+Fa+mi/QOf60z9REj77246GC/MKQYObc2v35rdjKvbgvFet?=
 =?us-ascii?Q?/MjdmbGfi0Ogxz8yvhscY1vgfn2Le82ttHpkZ9O173YBzGd+vpwWznFfu639?=
 =?us-ascii?Q?kesP+W8Cg2BW/kjxSSnnQ5FY8i46W+lkSXIaqdOC4BpUVNQ5VFvmrtkH2Erb?=
 =?us-ascii?Q?PKaZ+zP05e4Aks6FeF6bVI4gRm9aoeasWpbF3KMNGAQKutSGwdui0Y890Bzg?=
 =?us-ascii?Q?cRSvMzVD0o3ISTSrUoFrAZp4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 734bf35f-e514-43d4-ecd1-08d8f9d82da0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 15:16:54.4319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SjHNRlwiDjiWKC6RSIjWdpp100jApgtgkfwo+7SMj1RsJJW40WosivI/Hbu4I0uHQpMoJs71qWeMLZtNdmX5Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1391
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Wei Liu <wei.liu@kernel.org>
> Sent: Wednesday, April 7, 2021 11:01 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>; Dexuan Cui <decui@microsoft.com>;
> davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <liuwe@microsoft.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
> Network Adapter (MANA)
>=20
> On Wed, Apr 07, 2021 at 02:34:01PM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Wei Liu <wei.liu@kernel.org>
> > > Sent: Wednesday, April 7, 2021 9:17 AM
> > > To: Dexuan Cui <decui@microsoft.com>
> > > Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> > > <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen
> > > Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> > > <liuwe@microsoft.com>; netdev@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> > > Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft
> > > Azure Network Adapter (MANA)
> > >
> > > On Tue, Apr 06, 2021 at 04:23:21PM -0700, Dexuan Cui wrote:
> > > [...]
> > > > +config MICROSOFT_MANA
> > > > +	tristate "Microsoft Azure Network Adapter (MANA) support"
> > > > +	default m
> > > > +	depends on PCI_MSI
> > > > +	select PCI_HYPERV
> > >
> > > OOI which part of the code requires PCI_HYPERV?
> > >
> > > Asking because I can't immediately find code that looks to be
> > > Hyper-V specific (searching for vmbus etc). This device looks like
> > > any other PCI devices to me.
> >
> > It depends on the VF nic's PCI config space which is presented by the
> pci_hyperv driver.
>=20
> I think all it matters is the PCI bus is able to handle the configuration=
 space
> access, right? Assuming there is an emulated PCI root complex which
> exposes the config space to the driver, will this driver still work?
>=20
> I'm trying to understand how tightly coupled with Hyper-V PCI this driver=
 is.
> In an alternative universe, Microsft may suddenly decide to sell this
> hardware and someone wants to passthrough an VF via VFIO. I don't see
> how this driver wouldn't work, hence the original question.
>=20
> There is no need to change the code. I'm just curious about a tiny detail=
 in
> the implementation.

Currently, the PCI config space only comes from pci_hyperv, so we have this=
=20
dependency.

If the pci config space is presented from other ways in an "alternative uni=
verse",=20
we may need to add other dependencies. And yes, the VF should continue to w=
ork:)

Thanks,
- Haiyang
