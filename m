Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0179443DCF7
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJ1Iea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:34:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21540 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229791AbhJ1Iea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 04:34:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19S0QJfD011426;
        Thu, 28 Oct 2021 01:31:57 -0700
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by mx0a-0016f401.pphosted.com with ESMTP id 3by9rtug5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 01:31:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjM3uoPMTKpvBxfnBfHLRU1gpvuN6NOBgwF/xO52Y1bs8l109Nl+W88ywNEoxijbaaJQkEO39Bg4Gm+ffLTslt6JpSaKjw0HztH+R/xe06nMkbqj+OWz++L+l7o6Uywh1jeAWoDAHs/gZ1a2JSRBWsHovaLaY0GFH4Xbcv9Dftn2idYgUuiGrj4gRdXmRTuAT7c+USPV7LUHTt66RAkj2s1sOPtvkTcRzSw6n4FtvIHTPOcms9XGlAI+R0xhvUyXLF+G4pS+TozjRkjxuJxyScmSG7u0VGZBz7rFgzzccADXBeNrGSDpXbkhht5SJtDnIVdVDHzwVgAZHQeNNht+iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCWJmXqLovwFs32cJoedtsGD0avrWjludD11oOHgUic=;
 b=T3vMBZPw7I74KEB2GtXHq7ok+x+qToNZ2OJYwz8azyTWwmLz4JpJabMggryOwn8XgYu9IRT7XbKvjWL6T9qHbUnhho/OZysRzk6d50S2QTt5iWHT8dnVb5rfk9jh44tUSgzI66SJhUPMBoI2lXcUvc9LQSwFzkNmgHLPQcNFjx8i3+ZJ0VMgjS0pARTPuGeXGaH7/DRFRfQniULzFNkf+5gdmGEFkg8mxIQaQvMCUnIdAZDAZgsz/bFLWm6AQl3dqOSC32zIYF/WUGD5825VxmK4GsyRUC+0mZPxwd1lXzFED6LmVIFrBC+wJs1qyyGdf3T9vIxOtOI+3LhSvuoSEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCWJmXqLovwFs32cJoedtsGD0avrWjludD11oOHgUic=;
 b=Lvt0zQEggFmyFpRZJpDtOFmKJaV3yCo4AYoipOQtopkXaxC09jCn7we7FEKVIJXdCCrGSQSW6fQllqAN5u9TOy8N3RvliuOyPQj/nq5NSiKJhVP38XWbtLQVSTpS+wC7Zw/b83fToNm8NpRal7jfTE9xcTni9DUm/zIV2iB6VBg=
Received: from PH0PR18MB4655.namprd18.prod.outlook.com (2603:10b6:510:c6::17)
 by PH0PR18MB4842.namprd18.prod.outlook.com (2603:10b6:510:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 08:31:55 +0000
Received: from PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::18a1:f96:a309:3bfb]) by PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::18a1:f96:a309:3bfb%5]) with mapi id 15.20.4628.023; Thu, 28 Oct 2021
 08:31:55 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Manish Chopra <manishc@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Topic: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Index: AQHXyqEA7jl+kkKwVE2k6p2laLQP2KvlxdmAgACEIOCAAJepgIABL3BQ
Date:   Thu, 28 Oct 2021 08:31:55 +0000
Message-ID: <PH0PR18MB4655F97255C0E8AEF5E3FDCDC4869@PH0PR18MB4655.namprd18.prod.outlook.com>
References: <20211026193717.2657-1-manishc@marvell.com>
        <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
 <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e936e80-1c52-404a-4e9c-08d999ed6693
x-ms-traffictypediagnostic: PH0PR18MB4842:
x-microsoft-antispam-prvs: <PH0PR18MB48426DE250522296C7E13C5BC4869@PH0PR18MB4842.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hXR3pTxkBhxHCZVqKUo3IpkZrKftger1VQ3QSTparktWPwLWj/R5nswg6QvruDOzSp6PHCrRZ44uwbxc0piW/cbyEwv7bBJYliptyFmdrOLvC8opBThbt9mUeVP1c0I9FZPD/q/lzRBDe/bRMkygJX/BABxX6jmOa14ARBkiq9KBTCFqzP56ZqDyDLRPZMYD0bpfT+ICut2kDbqytqbfNtzF/HHv+yksSApmci6pEZ+XLPKv6fCA1u37CXWEr8wP+cEsEr9+6nx811VhSdWc14AYutet6yYrs+x7sXwVqePoHag0Mmet9fqLcMUmfw2ag9g2F5AK79buFUy5Pl7fwVefzP0VZN+IFzCH7kRl0RsdvrLvkOpDHFKYJePJZsop3Ll87bJGi1aZnSC5x6ECLvuwuNN/6uPN24z8bQxr+uKROusMlSF6h1Pe2XWAIoJhFUkO0jao1wfA0+jkJ4F3MxM70ZXDPSu2++WLd4aqrtxsdLTZwjgk/rV6le8qZpPL5HCwp7FdLAltIKEDtFGkiP8+h/B4RZRIcT98eLKu72Suh0Bomal3mu9//zQ0rwXp2VONjGvo5xR3n9RyqcxaUDYSVqiquc53z+e5JVw5w0/GfLfMBn0yjugFQMWiWTY0K75eSvM/OGI2UOPSPjGOfD3mcpPwjD2ANgQ3sm/HWK8x/VWji7wGB3kA3GJIUdRi4t2QYHJu4It+qbYhBlB+MGSi9X0bSzSAcR7BBskrgtzMpc4EZNg/HPn1u/PEjv0ikL6nsQDeZageM+QzfN01Ou51VFhEY1ACQv1iCWvhMP4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4655.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(8936002)(186003)(26005)(122000001)(38100700002)(966005)(53546011)(76116006)(64756008)(86362001)(7696005)(66556008)(66476007)(508600001)(6506007)(66446008)(6916009)(83380400001)(5660300002)(54906003)(2906002)(8676002)(52536014)(33656002)(55016002)(66946007)(71200400001)(4326008)(316002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NLNLr6vniebD7mLfnfjgkkU3U2EUZ8kJaEvUnghgX6sGt9M4yzIwkuMX+D0g?=
 =?us-ascii?Q?nTSwv2Q/eP6+Ikn5vJAneWQ7+SIkjWP+52h59L1lW2dLr5VZ1OtVRu4VtF7E?=
 =?us-ascii?Q?RXM/LqrECKtmgn3OSg+bSUGnmjMr1m1aZX3sUogcGbFm+4sbe0uJfdaSCLti?=
 =?us-ascii?Q?uMPqC6pj0U+xQ3WsyBqZLQ2DQejCyAnGVQkQ6LNGH3sOxcOHAfDlsaVLO6NB?=
 =?us-ascii?Q?8GU7GEWI2ulMr4FZn7O5TbLBMBZpPGXT7FZO83SYUz+Jvy3YOMn90dXaJ+2s?=
 =?us-ascii?Q?9VKsR7ZklF9ozQIJcsm7ezHuEP8/K6PMS/rufL1DiifUQukRyhMkZ2PqfL+d?=
 =?us-ascii?Q?QALhSmu7Sb1rYJIiKDt/4NCs+3GD/xhMAZIgRpHW4QppadkYMobOOVeenYYu?=
 =?us-ascii?Q?zfob7AfjVnfXFEJFzjWfEUEnRqueU7nEPRtvj8mfizjUb5t66X1ae84yaMdF?=
 =?us-ascii?Q?rvnnJvMVaQY66x/FGrPX4pemKPvfxMMqUAbIv6u9bFmhW+q4hDW4xptvHQBQ?=
 =?us-ascii?Q?CoPYnUafpGkCcDSCs+RIzL3L9oIBdDgkEdLL/YxVirdHLS8MnSOHrL7X/vdO?=
 =?us-ascii?Q?Py+Ay8mC04egCdJE1G2piMqNr1mvuVmaLxo4Wt+ea45wj9Ufw012aJq0fu56?=
 =?us-ascii?Q?xLkODcjQqeGeCZ6iVvQCYQ5RQnJ+3pZnuT2+pCw2zmP5f9rAkmnOinIhVqUG?=
 =?us-ascii?Q?UqsxZ7EJ1oTr1kCJTmFwJd4gQw2IrbUkCEvoY5nCFUgR2BdbMOhT3wYmtzdc?=
 =?us-ascii?Q?qcTiLpFNW6TvE0VLrPi8KFHywoImC7h/Z7kXUsUHyxJJXta1A/TYrEj+mSol?=
 =?us-ascii?Q?56btko1bBwHkT6b9kOuFT3C6cirIYWkQngU3uRMPD+Z4Kgqp/SaT4VuG83hb?=
 =?us-ascii?Q?oghKhoFN4OoAsCi9JUKzLrjgZ4UkGxO1c0AAthM3EUp1gns0T6JxsGvUR+Yk?=
 =?us-ascii?Q?AcWc5XFd0WR118LcYTlVGHhWKWoWkXbMRS2xbzEgS5bVcxfou3eNzLzclOuP?=
 =?us-ascii?Q?39VBVGIenKhZWjULTC6hqGogX3hCRkYjiauNpucY5KloTX0wL7adHoZZh3Op?=
 =?us-ascii?Q?NoL4Gx2NYtM/n8qbwTfGlwphnHnM8mD33JaIg/tZJxA50puvZLNpDKPqp+PV?=
 =?us-ascii?Q?3zT38hLcO0RIG2Yk/oWqWOJYWmE5AffW8Ot18Gf8kC3n5080W7DUdgzvYEhx?=
 =?us-ascii?Q?S7B9IDBRXV2AdxUd3Ufv/5/cjjENDuyTO/BLpaonl4OpQ6W51KLVh1YPvHQQ?=
 =?us-ascii?Q?Df4gCCTpr71oBhfWmgjLzW7o2QVpEzm5XeWGEDiPyfxiv2OqgydTgsinUUME?=
 =?us-ascii?Q?O89BxO20F+ZXuflhzNtt87oiuA5UyoHgi2v6Ka78vLgF/MQqCaEvq4a91bAY?=
 =?us-ascii?Q?BgCQVOcq/R6NNbRt1sDo1HTL9VHkK20dM4+sKSZICdUTwQJtWiB8Jx1SAdv0?=
 =?us-ascii?Q?BNImcwhOUNGo4hQyR4gS5UTYyDayMjaYaDZbir7fZBKGMuHvOXC5G+LkwrIV?=
 =?us-ascii?Q?9Nt3ZrhX8FjYx+EMJbOMV5ddqfhOXGPKKA7oQygXeHXcdf1aeJrMygAaGm1U?=
 =?us-ascii?Q?TP6KSR98NTuxjqE8GC6Yav6fDu+W5aagBVQwEfltlIVIaZ8kjdOUKDcI9hoy?=
 =?us-ascii?Q?Tg61o+CHSxJPawDC6vYxEFs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4655.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e936e80-1c52-404a-4e9c-08d999ed6693
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 08:31:55.1587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wcSHx9WFQHp1dCqr4iCK4MeAZcMmQiOwXuwwKBCyQaOTztDWQnDktx0chMj3V488j5wQ5CRj4JURV1XFM9RnvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4842
X-Proofpoint-ORIG-GUID: 1entY9yQ6EW2ADmruUq1LgFRa7gbuwhl
X-Proofpoint-GUID: 1entY9yQ6EW2ADmruUq1LgFRa7gbuwhl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, October 27, 2021 5:04 PM
> To: Ariel Elior <aelior@marvell.com>
> Cc: Manish Chopra <manishc@marvell.com>; Greg KH
> <gregkh@linuxfoundation.org>; netdev@vger.kernel.org;
> stable@vger.kernel.org; Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> malin1024@gmail.com; Shai Malin <smalin@marvell.com>; Omkar Kulkarni
> <okulkarni@marvell.com>; Nilesh Javali <njavali@marvell.com>; GR-everest-
> linux-l2@marvell.com; Andrew Lunn <andrew@lunn.ch>
> Subject: Re: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.=
20.0
>=20
> On Wed, 27 Oct 2021 05:17:43 +0000 Ariel Elior wrote:
> > You may recall we had a discussion on this during our last FW upgrade t=
oo.
>=20
> "During our last FW upgrade" is pretty misleading here. The discussion
> seems to have been after user reported that you broke their systems:
>=20
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_netdev_ffbcf99c-2D8274-2Deca1-2D5166-
> 2Defc0828ca05b-
> 40molgen.mpg.de_&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DcWBgNIF
> UifZRx2xhypdcaYrfIsMGt93NxP1r8GQtC0s&m=3D7SlExiNTnqs5yykfN6rmIWZvB
> wQtSHCEW1ZmdHhe3S4&s=3D5OfVYQjTBOqb9GeN7GmGw70U_7MZLYz9YDyl
> o1iqdtQ&e=3D
>=20
> Now you want to make your users' lives even more miserable by pushing
> your changes into stable.
>=20
> > Please note this is not FW which resides in flash, which may or may not=
 be
> > updated during the life cycle of a specific board deployment, but rathe=
r an
> > initialization sequence recipe which happens to contain FW content (as =
well
> as
> > many other register and memory initializations) which is activated when
> driver
> > loads. We do have Flash based FW as well, with which we are fully
> backwards and
> > forwards compatible. There is no method to build the init sequence in a
> > backwards compatible mode for these devices - it would basically mean
> > duplicating most of the device interaction logic (control plane and dat=
a
> plane).
> > To support these products we need to be able to update this from time t=
o
> time.
>=20
> And the driver can't support two versions of init sequence because...?
Well. Generally speaking on the architecture of these devices, the init seq=
uence
includes programing the PRAM of the processors on the fastpath, so two diff=
erent
init sequences would mean two different FW versions, and supporting
two different data planes. It would also mean drastic changes in control pl=
ane
as well, for the same reason: the fastpath FW expects completely
different structures and messaging from one version to the next. For these
two versions, however, changes are admittedly not that big.

>=20
> > Please note these devices are EOLing, and therefore this may well be th=
e
> last
> > update to this FW.
>=20
> Solid argument.
At this time we don't have any plans on further replacing the FW, so hopefu=
lly
we won't find ourselves here again. Another important point: the major fix =
we
are pushing here is a breakage in the SR-IOV virtual function compatibility
implementation in the FW (introduced in the previous FW version). If we
would maintain the ability to support that older FW in the PF driver, we
would also be maintaining the presence of the breakage. In other words you
may be better off with the driver failing to load with a clear message of "=
need
new FW file" rather than having it load, but then having all your virtual
functions which are passed through to virtual machines with distro kernel f=
ail
in weird and unpredictable ways. For this reason we also ask to expedite
the acceptance of this change, as it is desirable to limit the exposure of =
this
problem. Back to the EOLing point: the set of people still familiar with th=
is
 >13 years old architecture is severely reduced, so would rather not to try=
=20
and invent new ways of doing things.

>=20
> > The only theoretical way we can think of getting around this if we
> > had to is adding the entire thing as a huge header file and have the
> > driver compile with it. This would detach the dependency on the FW
> > file being present on disk, but has big disadvantages of making the
> > compiled driver huge, and bloating the kernel with redundant headers
> > filled with what is essentially a binary blob. We do make sure to add
> > the FW files to the FW sub tree in advance of modifying the drivers
> > to use them.
>=20
> All the patch is doing is changing some offsets. Why can't you just
> make the offset the driver uses dependent on the FW version?
>=20
> Would be great if the engineer who wrote the code could answer that.
My original answer was more for the general design/architecture of these
products, and a general design of supporting multiple FW versions on them.
Specifically for this FW change, as relatively little has changed, we
*could* maintain two sets of offsets based on the FW version. This might
impact driver performance, however, as some of the offsets are used in
data plane (e.g. updating the L2 ring producers), although I suppose we
could also work around that by preparing a new "generic" array of offsets,
populate it at FW load time and use that. However, as I stated above, I don=
't
think it is desirable in this case, as the previous version contains some n=
asty
behavior, and it may take us some considerable time to build that design,
allowing the problematic FW to spread to further Linux distributions.

Thanks,
Ariel
