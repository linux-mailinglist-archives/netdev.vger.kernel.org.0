Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB0B11FF0A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 08:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfLPHil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 02:38:41 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5278 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbfLPHil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 02:38:41 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBG7bATb005950;
        Sun, 15 Dec 2019 23:38:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=mQr1ux3txJmhNFVkpLSVkkC5Dpsn2/QzhuZmogvfr+s=;
 b=V7WzYDA9+gVNPYQ9CN01H8MtAg9WaQy8TlLym7LJk1LIkCvXweIY3fCmlKySXQgedjYl
 dmkfEA+/ey0qPrRRZWJBjLS4Fpii/nTadU3nvGVt7WSyUrc7hCOI/gfsIcnTLN8/JjS0
 Y4kDLJeWWM+utXjhiQOYNQJOyQsUYlSlO+bo4FhT1XXqXHPVD/buWsw2XaRNUXEBezp5
 dbHTXkWaTRaEoJh8oZ91yYtZZAHZXxGUIMTgtJapaULz1QC9nYftsCzv+/QA5VJ0xGxc
 WpbTBQ4GOmgqkeAURpgJ+BnJvwLCUMXOdMjoT4M6R1RXPJJC8pWg2teFY5QfWNBso+xl oA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ww04tn2gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 23:38:37 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 15 Dec
 2019 23:38:36 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 15 Dec 2019 23:38:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngVoBSoxXJTCq2vdDBD0vyGMTdWCXQI8bzDO5XY8BcPXiU93WEgtNMNfW1zYSPZCZdrI35as/B7cqNGWKV1+hEZEpz3WT2OhM97QMAUXAfKSgvMSs9+UzurOuPDfboVbbTJoYjeqvLGoPAB70W/KB9z7SXC5waNAPd2/wMPqvzq2TRKymQ4VRnZu5KZMBFSkWKZApiwyDDgzbF0PC1t6Bk4/pfJeETdsDgesoXftaLM8Z9Q1MNYuAJleDvx03Uc7z8LuRdldPBWyL6sKpF+zDqitz4noeueqrY1Y+y520GKCkjHm1oOMzM6VXLcDpVn6KlXX4XKqQw4KdwhlomEbmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQr1ux3txJmhNFVkpLSVkkC5Dpsn2/QzhuZmogvfr+s=;
 b=LeeQO37HiksB7nfY1i2jI3boevlbmssiTOXNF6xk4DzV7+6oYNYUij3+lSeb0/MVjYBPAa6515qLfRy8wA35a/BlHU8yL8B+hJGuYY1OdxDhC0ZA002WlEWEJLoEOdy2Ik5bGK3fmVrea5DMD09y5mBid3Rxj9WoZ5mOT7eDI6cehN7GEhiOEmAr47+cq1C7csbvy9r0bfaZh2nP4wRQpOlOUY5KabBJPT8qv+jCg/lFsOuW94afN/JbExp8G3E4PyyBumlu+jq1MT8cWkmT5f5mASpGPOy1t+JSkJsgRbK5CrEtd0cBgSwruKd7D1oPH/y61ViYUzQo8knFQntQwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQr1ux3txJmhNFVkpLSVkkC5Dpsn2/QzhuZmogvfr+s=;
 b=DCfVsz0+O/ZFvoCdw6i2xqQoNmaJCaAsxaUS0OW2Ljt1VDkTX9jZlZnewF4B0T9VxD2TpPBVxQY9+KNPsA0N1bXTLe0W4L0jrrWELrK5MmqXqnP4bSxq0jqp6uJ0t+d/A7BpdJNKd0pAuzsKU3Mvd4Rw10DNBiaiG/iclsQbuU0=
Received: from DM6PR18MB3388.namprd18.prod.outlook.com (10.255.174.205) by
 DM6PR18MB3068.namprd18.prod.outlook.com (20.179.50.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 07:38:34 +0000
Received: from DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::c0ba:31d1:92b1:e003]) by DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::c0ba:31d1:92b1:e003%3]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 07:38:34 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: LRO/HW_GRO is not disabled when native xdp is installed
Thread-Topic: [EXT] Re: LRO/HW_GRO is not disabled when native xdp is
 installed
Thread-Index: AdWxYyOH9Q0NPNE5QOubY6DZVvHbMwACD3OAAAq2EKAAGNjDgAAvQFEAADHXweA=
Date:   Mon, 16 Dec 2019 07:38:34 +0000
Message-ID: <DM6PR18MB33886C0A0BDBDA82ACBEC92FAB510@DM6PR18MB3388.namprd18.prod.outlook.com>
References: <DM6PR18MB338861990B56CCA5A4384779AB540@DM6PR18MB3388.namprd18.prod.outlook.com>
        <CACKFLi=30KJXL0xbdfgYqxWML5C5ZWyDPjtATByVf7hsao9gZQ@mail.gmail.com>
        <BY5PR18MB3379AC23267423E0CE9EEA05AB540@BY5PR18MB3379.namprd18.prod.outlook.com>
        <CACKFLin=JS-5mou=0-b9nvHh=4=9AopZUDGLb+ZkkVYbAsk3WQ@mail.gmail.com>
 <20191214114228.45d88138@cakuba.netronome.com>
In-Reply-To: <20191214114228.45d88138@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c18d7ce-b50a-4098-ecc5-08d781faf4fe
x-ms-traffictypediagnostic: DM6PR18MB3068:
x-microsoft-antispam-prvs: <DM6PR18MB30688C8F137118885E7A513BAB510@DM6PR18MB3068.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(13464003)(199004)(189003)(26005)(81166006)(8676002)(81156014)(33656002)(86362001)(4326008)(186003)(71200400001)(66476007)(66556008)(64756008)(66446008)(66946007)(2906002)(76116006)(6506007)(53546011)(478600001)(7696005)(52536014)(55016002)(110136005)(8936002)(9686003)(5660300002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB3068;H:DM6PR18MB3388.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T9TDcqcUBM99sb4C/RBse/nOxY3zOj2N0zR7R2YgRiCfj8LvE9O5au9WHGZB3SrNt7eLxLuPkvc1OBgo8ykVLC5URfcFP6pxGe+mSpnHhHCipvetyAKL653yAp/VKd5tgq/GDkTxHnUS7YP87uRVLwn91KEty+SkfXqZQ5IlRxbJhddd7MpRLaE6uPRJCXz9Ip/IqRCWgyWwAsDYDpORke4nVrgjjvVjsgYfkZbMe+X/cXUyDEEVOPmjScYQftc3FfvGxw4s2XEwOEK/Bx9YulRSw1G2BfYlkE6rjeIDFzcmsWOnFPAC6kfhbNJZ5tksq9Zjc1I5/gpFnPWaHBts1aCOQrIMetUumL7zSit1oQxcK9s052d/w1FCuxam4ZRfcUotk083AULOsjC3XTWkEEFqkhiWzkzMHYnC8ucb/b/MM6ohfJOSXEZmQ1kIb9XK1hNPpcxL53rUonr4lIinN4tAykW5o5OKhOs5WO2brex/CkE0wHfulL1wYgN2Ooqk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c18d7ce-b50a-4098-ecc5-08d781faf4fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 07:38:34.6410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bwS8ZH+Y3Am+VBRLaKk5f8anpJbdXNBEeWmArSMl+wvHaV/vw6/Nk8P7S+k321UHjICAjBxeOCWNWxf/bYmgxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3068
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_01:2019-12-16,2019-12-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Sunday, December 15, 2019 1:12 AM
> To: Michael Chan <michael.chan@broadcom.com>
> Cc: Manish Chopra <manishc@marvell.com>; netdev@vger.kernel.org
> Subject: Re: [EXT] Re: LRO/HW_GRO is not disabled when native xdp is
> installed
>=20
> On Fri, 13 Dec 2019 13:09:31 -0800, Michael Chan wrote:
> > On Fri, Dec 13, 2019 at 1:45 AM Manish Chopra <manishc@marvell.com>
> wrote:
> >
> > > It used to be the case for our devices as well long back. but after
> > > the commit 18c602dee4726 ("qede: Use NETIF_F_GRO_HW") that part
> was
> > > removed from our driver and commit 56f5aa77cdad1 ("net: Disable
> > > GRO_HW when generic XDP is installed on a device") was added to
> achieve the same instead of individual driver doing it, but it wasn't cau=
ght
> that time why later commit only does for generic xdp, not for native xdp.=
 So
> today when native xdp is attached to our device, HW GRO aggregation
> remains enabled on our device.
> > > Please let me know if that fix is good enough to be posted. Will test=
 it
> out and post.
> > >
> >
> > The driver knows when an xdp program is attached and can disable any
> > features that are not compatible, so I think it is more efficient to
> > keep it this way.  Generic XDP on the other hand, does not involve the
> > driver and so we need to disable them for the driver.
>=20
> The only question is should the driver refuse the XDP prog installation (=
with
> a nice extack message) or should it silently disable the feature?
> IIRC ixgbe opts for returning -EINVAL if RSC/LRO is enabled. Micheal says=
 that
> bnxt disables automatically. My preference is for the former, because it'=
s
> simpler - we all keep the MTU intact and don't disable queues to make roo=
m
> for XDP, IOW don't automatically change user controlled configuration is =
a
> simpler policy. But I don't feel too strongly, we should just make sure w=
e
> document what's the expected behaviour (even better make netdevsim
> behave that way and write a test).
>=20
> Manish, if you were to go ahead with your patch please make sure you don'=
t
> disable the features when program is installed in offload mode, though.

Thanks Michael and Jakub,

I will rather opt to fix this in qede driver -  qede will implicitly disabl=
e the HW gro and
allow the xdp prog installation instead of failing it (just the way bridgin=
g disables LRO
implicitly on underlined NIC). I could also choose to fail xdp installation=
 if HW gro is enabled,
but that will require some user intervention to disable HW gro explicitly b=
y user and I am not
sure if such failure from qede can lead to unexpected issues in some deploy=
ment environment.

Regards,
Manish=20






