Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63C21A4366
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 10:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgDJIPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 04:15:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61754 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725926AbgDJIPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 04:15:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03A8Bnb1024649;
        Fri, 10 Apr 2020 01:15:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ysGWZQFak1hnTJxqE42nhdCU6RIoCOtYSwXrS8F3ocI=;
 b=vJObKhp+CiSJbF5gyJMhqsh/UIfchPvbU2FnnJFHbOnPSH8OYHAtA6kzkNGgzqIf+/Eb
 t4jc5NX+WhKFdmYD9aCWpB3EUwBEwkuStUEMMH4XFr6cHwkivQAxkqvjsThhI2yKNoJZ
 bSalyTNwbuTb0820+xaz2vCJEFjWL4QHWt0ogO4OhE5itX/QiK7+31oCVlDR+E2/bDQo
 GHMwIUo4Nnq2CgVfK+uJmjA7i8KTvTcmMgHmn7GxltrFfLRuD2/PqDUhqxrlgkpM0VuS
 tJx1IE/RuRJZEt8HBtPL4ZtZ3IDABwobHA8kdsskMdFf6rtHmS8m4bDPmVS3P05ceAig Yg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 3091jwmd0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 10 Apr 2020 01:15:08 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 10 Apr
 2020 01:15:07 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.54) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 10 Apr 2020 01:15:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nh2EgUQC21mfKffz+Xn0Ac7s2eT4znSZhGgc8EsCCQSV+YFBqgPl2k2hBlNjl8S8NpExgSHOaA0VFJjKhmmW8T7uQQwLljRuF3b+oWORiybeU2c1+sxm7/H0RZmJYP5+1H15uP/nC8b9wuVjyEn/zdIkvJB0vJ0CwUzSdc9rc8s3RdkMrKxvnXcqZQ21ujnf8cQXhsWqh9ioW/wBJSRgyrnsmpKY4kyEzjT8i9Et0UHHA9Ddxb+qA46eU6d/wKoBxmrensibZ4Shfdn8ByHEbloZutg/CNdO5uWStf6IZA2u6nPuKZsATcFZtCoWjYackBWFtdKfgd3qFscun+r7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysGWZQFak1hnTJxqE42nhdCU6RIoCOtYSwXrS8F3ocI=;
 b=WWDmGJKIx+QaWpWxHBich0Q7uADPxc+NNzanz7I7joqNkA8EES4vfCGtBy9+ZaAFN77Xr2iRXIMxvgp3RpEJ2gdm+XPzyhdP4kRhTxKyaBxXd71sRWL0EQQNHOLQ1B6vvqA9BO/FbHrme0D0OshUUlzmIYfBGhOVemSJm5XtEU8prFH9oyBaQLPNJ4RIbs7+wQNnj9nbZFPocXOPC31oY20Ubs9vUUPuAkf0kOn7M/usHiGknz5AXp0ukRb0EEXS60NF+aMIpvdRg2WvHpJVphE/n2SOZq0On+gmJI1Gm5WtI4aWRORXUiwDIgLdL3bF6NgI+cT7ZTDW5h910A0R4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysGWZQFak1hnTJxqE42nhdCU6RIoCOtYSwXrS8F3ocI=;
 b=r4qrj8EynyQoGO6GyFmURgSQuz+1DKcdHkbiryoV3grno8taVWjYr9b9p3woG+nRlOncbWHV6Pg28jteNSvzLZK5VwaeHmh3vf4DDqy5JD+JN+E9nXgGqAVa8U1qoMMkyMau+ASHX0O+VHTbPVdh5Lvg1YmTTlutb/97tb7kL8s=
Received: from DM5PR18MB1484.namprd18.prod.outlook.com (2603:10b6:3:bb::7) by
 DM5PR18MB1452.namprd18.prod.outlook.com (2603:10b6:3:be::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.18; Fri, 10 Apr 2020 08:15:06 +0000
Received: from DM5PR18MB1484.namprd18.prod.outlook.com
 ([fe80::f0a4:83ab:9954:d029]) by DM5PR18MB1484.namprd18.prod.outlook.com
 ([fe80::f0a4:83ab:9954:d029%9]) with mapi id 15.20.2900.015; Fri, 10 Apr 2020
 08:15:06 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Christian Deacon <gamemann@gflclan.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: TC BPF Program Crashing With Bnx2x Drivers
Thread-Topic: [EXT] Re: TC BPF Program Crashing With Bnx2x Drivers
Thread-Index: AQHWDfkzLSU3jH8Se02IqWrV/UfaaKhv33OAgAAHlQCAAUQ7AIAA2HPg
Date:   Fri, 10 Apr 2020 08:15:06 +0000
Message-ID: <DM5PR18MB14847F91C06C7BAB5FA2B03CC4DE0@DM5PR18MB1484.namprd18.prod.outlook.com>
References: <853f67f9-6713-a354-07f7-513d654ede91@gflclan.com>
        <c3c44050-132e-44f7-1611-95d30b0b4b47@iogearbox.net>
        <0a96d4ee-e875-e89c-e6bb-e6b62061abdd@gflclan.com>
        <54d3af61-8f00-6f65-23a4-0f1d5a9aba8e@iogearbox.net>
 <20200409121810.26ad70aa@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200409121810.26ad70aa@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [5.102.238.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54041e18-139c-4d4a-ca2f-08d7dd274750
x-ms-traffictypediagnostic: DM5PR18MB1452:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB14529E949EFFED08E01251C9C4DE0@DM5PR18MB1452.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0369E8196C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB1484.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(7696005)(33656002)(478600001)(86362001)(71200400001)(54906003)(110136005)(316002)(6506007)(53546011)(5660300002)(4326008)(8936002)(8676002)(66556008)(66946007)(66476007)(55016002)(81156014)(2906002)(9686003)(76116006)(66446008)(52536014)(64756008)(26005)(186003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nb0iJYvb9ek18AXv4RjURhQuuN2xt+VtHbnMRJ7heRRNWpVH86svnl2yjri6qY4ATP/gRgDFEaTvHRuDqiIUReJMNFKvxBb97d23mH9O0kQOBykGu7sfjcyR1tCg+b2wioA4IIMyvIxvUnkS5nUFPVe99utzUyJv9/8LcN0yOwjtwGylJor31MYkQyyOLaZzD11oo1hMTQwapSdikAh3PUlVGrnC4/sFC4lWQXtyhL60wWZB1tBTSTczDIZvRQY5czQ4MofFs7YmGi3mrOYt6eymzVpfNbff0I54emhXLxetjx0QLJqgEqyCWU2rOeQKHBK1ygHZWe2gmPN9E8rEhG/6aINPa3pf2tMsjREYb9meWr7gfTRqlTsskfAZJiOywA4JuwUng4api4rV+HkUVAqRE0Y8chOW6j0g8o6fTA6Fb5906sKfhOWwB0BVCCx7
x-ms-exchange-antispam-messagedata: xVF9QL/mzU3Zuo1A//kO11Qet8eIW/vj0ZWIcwIt8wEnrBCfzUPOSUYAyYyy5PZxUlZ8LkOsmEgBbdyvI3ODEDU3RzB6GpN3TpDbfKr22H5StFuTX5DGqlz/W3bPsXjWvQevc+cGIv38ke6KTKFVvA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 54041e18-139c-4d4a-ca2f-08d7dd274750
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2020 08:15:06.4655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJi997xnBYtX9rWdeP1/pCml+/DIk/P2xwfin6E7/RDE4cxJXty0Fi9RXmDvMQ4IdaSgDvytkYrYhcZBSHIgww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1452
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_02:2020-04-07,2020-04-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 9, 2020 10:18 PM
> To: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Christian Deacon <gamemann@gflclan.com>; bpf@vger.kernel.org; Ariel
> Elior <aelior@marvell.com>; Sudarsana Reddy Kalluru
> <skalluru@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] Re: TC BPF Program Crashing With Bnx2x Drivers
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, 9 Apr 2020 01:57:42 +0200 Daniel Borkmann wrote:
> > On 4/9/20 1:30 AM, Christian Deacon wrote:
> > > Hey Daniel,
> > >
> > >
> > > Thank you for your response and I'm glad I'm in the correct area!
> > >
> > >
> > > When the individual ran:
> > >
> > >
> > > ```
> > >
> > > ethtool -K eth0 tso off
> > >
> > > ```
> > >
> > >
> > > The program started operating without crashing. It has been around 20
> minutes so far and no crash. Therefore, I'd assume that stopped the crash=
ing
> considering it usually crashed 20 - 30 seconds after starting the program=
 each
> time beforehand. I'm not entirely sure what TSO does with this network dr=
iver,
> but I'll try doing some research.
> >
> > Yep, don't think it should crash anymore after you turned it off and
> > it survived since then. ;) I presume GSO is still on in your case,
> > right (check via `ethtool -k eth0`)?
> >
> > > I was suspecting it may be the 'bpf_skb_adjust_room()' function as
> > > well since I'm using a mode that was implemented in later kernels.
> > > This function removes the outer IP header in my program from the
> > > outgoing IPIP packet. I'm not sure what would be causing the
> > > crashing, though.
> >
> > Probably bnx2x folks might be able to help but as mentioned looks
> > like the tso handling in there has an issue with the ipip which leads
> > to the nic hang eventually.
>=20
> IMHO this is not a bnx2x problem. The drivers should not have to
> re-validate GSO flags..
>=20
> Let's see if I get this right. We have an IPinIP encap, IPXIP4 GSO skb
> comes down and TC bpf pulls the outer header off, but the gso flags
> remain unchanged. The driver then sees IPXIP4 GSO but there are no
> headers so it implodes. Is this correct?
>=20
> And we have the ability to add the right gso flags for encap, not decap
> (bpf_skb_net_grow() vs bpf_skb_net_shrink()).

Hi,
I would still like to get an ethtool -d output after this happens, to revie=
w
the device state. Even if the skb was illegal, the error we got was device
crash, which seems too severe. I wonder what would happen if a VF
would provide such an SKB.
Thanks,
Ariel
