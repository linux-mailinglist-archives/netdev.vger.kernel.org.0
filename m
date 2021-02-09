Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6751B315AB9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhBJAKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:10:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13148 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234016AbhBJABj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:01:39 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119Nud2n027353;
        Tue, 9 Feb 2021 15:58:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=vBGL5m03EO0ANGSSnJuybACZfp804J6DZo/Ydf8geLI=;
 b=KHXhc6zb+FXUXiiTH2Wf5TDh56H46Ow9IrcqnhpzKEfiOLTMsBgrvnOrDoOUQHER5SyT
 5rSVOLHwuHKzg9LpuZDCiW8XY4ooxrRAh5DeMif/10RWV8j/3/kYiolr+N4rtzChSucb
 dLDDq5Cp2Ue4C5zak0gf7u+/71xWPinuUoqq62gQRE16Nw4uqx1phGu2oBC8XRalzVGv
 /C9P7yNHcq3JcqAnUzqlwidIqOB0GX7sKrUCTaCSe6h6lnz8YkaIPXGq6PNKdaaDU8W3
 In4LMKJdaequLZ25RwK/xWRHdC5iz9jno0DdbJG/h1nOf57Rr3NECFmdmli/O1gPfZnH 7w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrjf1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 15:58:41 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 15:58:40 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 15:58:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 9 Feb 2021 15:58:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilBVuhBYz6Oj6k2h4ZuTrSGstoOKX0RWkb+ptW1x25tVly1TtYhdhYwER+1uCUAKnfsE2bbGDdl9DTRAvXYI6eioUttwCMWo15mClAZlvaiK6u8++H2i2dcSj85XsoxcrNXmpugMgRIZSI7DdVrfR+wuaze5wcZ/J1eJJ4lmD1ewii9gqC6rB5UJ0RB0j/HERA7vEua2doTb6RWoEdmq9bWcQTRyHVYWmkaIzRo2+g0dJE6rzeDeeh/Ux+Or6XnVBKLrCxRdnfYdK/710AtCP56zjT+DnLNxP/lFBk//IW037vg6hxXju+vglvlIOJzTQZ2VB4kLmDCKFJwb+jHoxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBGL5m03EO0ANGSSnJuybACZfp804J6DZo/Ydf8geLI=;
 b=Lil+/rofrxAq7iVxyJY7F+z9NeNiKKBRahsPOrpG8DmfYey6mJ36mhKnBdJEHbQ/z+bXbB3G4McwP+GSso78IEjEnLvaraR+WPV8Ar2yDZT6FW9uNu16DXHWxwXGIWbhWaQdfrCASw4+h/5Ss3kVrzp6BlLocUOgKdbTJ90DXY2jwbGN9FPl9UP5JOzqOLMsxTmIP8xqTvFk+zF4UGnpBmDABmCamSB0/xPl48qaioxzIdJu/JKiNaXLwy4bYi3zPBKgYQgtSOThSx2F5PoUEhZfVemjZW7o6aPD4ZkDvqqJz6NbI8FMa54bsmKHBKmCwaHdQAFcvlHoyKQ5VymmKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBGL5m03EO0ANGSSnJuybACZfp804J6DZo/Ydf8geLI=;
 b=UK0s3Em4MdQ8SPhOG9SKK3RbKlC6H8keWMkJWN4kvCr1RQrsDSeb29a2Vmd+SHGcNDoN79zlIrTWNIEjs2d6Zd424SywncLeZMVNKviZiuHojU3G21imtvrJyE8s1pOh23G1X/GTPM3aw6gVKSVNHLUFB5egJgOScSdmbO3zF3w=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by DM6PR18MB2410.namprd18.prod.outlook.com (2603:10b6:5:187::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 23:58:37 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::d0c1:d773:7535:af80]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::d0c1:d773:7535:af80%6]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 23:58:36 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Sunil Kovvuri Goutham" <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "Srujana Challa" <schalla@marvell.com>
Subject: Re: [EXT] Re: [net-next v4 00/14] Add Marvell CN10K support
Thread-Topic: [EXT] Re: [net-next v4 00/14] Add Marvell CN10K support
Thread-Index: AQHW/BFawZyckkm2jEudp0J5EiVCQqpOivQAgAH472s=
Date:   Tue, 9 Feb 2021 23:58:36 +0000
Message-ID: <DM6PR18MB260256F1B0FC45DA92206D5DCD8E9@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20210205225013.15961-1-gakula@marvell.com>,<20210208094052.1d90443f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208094052.1d90443f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.252.145.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9a35f54-64d5-40b5-f660-08d8cd569db6
x-ms-traffictypediagnostic: DM6PR18MB2410:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB24100FF49630FC3C6070D079CD8E9@DM6PR18MB2410.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hucQtPtlIFcowY7rF8bTuRjkDspPTdPZhEmdLpmMVmbyxr/Ts7I7ThrAgNKbKbACp6y2GI0/4NVcIa7cTAPTmOF4G0cmMdez8LJvH6zCUWoA/Ep7z3Wk3POOsHKcw9rib563vAnXZd8kE1eYGwhZ0F/ruiQZe1jQhgFQB7NKCDY1Y0DKErFk02Qi0RFPjBqucepXzLdIyN4yo4JtxOjg8XSMkz03J1s8pgOp8bEN2eRSoCp2PAClZD6ZF9KZQEEAhoyqecWizzUqPb6SGfwRv/viL3i4bEP0iWMG4+4myZDRboxupmytZx7GUUQZqNjCNtQKilEjMjiNL2U3BGEKRXBxSaE/Vf93bB2Z9Nevf6rAVdQIhA8mN7mueT/Ql1GknRiHsfbzP1Or2+nSyQYlfjseigb3HGMZ7ocZDGSBJNO+YGK49ctn5EZtlYDcWJHqg5GSiVd5jPaVFvtGRE+J3wXhMiyyqYIGVAtGw9e9MAkk/QdFFihWCAl6v5JTnnFi/mb/nb7YB0gwZzhLtxURbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(33656002)(8936002)(66946007)(4326008)(66556008)(76116006)(52536014)(8676002)(64756008)(66476007)(71200400001)(2906002)(6506007)(5660300002)(53546011)(83380400001)(86362001)(54906003)(107886003)(55016002)(9686003)(186003)(26005)(6916009)(498600001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Qm91aa2I/V5INXTx/iHf6xm+kEAhrxEg7TLff8aMkdNUKC6KtlfRPjoQSedC?=
 =?us-ascii?Q?f1ZCbNdhhyxnwOnKgcSoFo6tJUQ33jmsPp/+KoiKxiuNqqCg9HFSog+MLbvz?=
 =?us-ascii?Q?3wIKDabj9pEoox4WWSeNQOc1GBFy8u/twxSoVNi9hrjaYfH/X69flWIZW1W2?=
 =?us-ascii?Q?GWsYtxXCRc2HYs0DU31IMGo8AKor2FpiW8bhVdUsmiMHAcY9yrFGtGDkdhSC?=
 =?us-ascii?Q?MKsJx+QzswKrlwACy7+LxRvozOWTJWtt1TN/usYXBlQCGir009HnQwEs9J5l?=
 =?us-ascii?Q?9Lh/UiHpHv6PmPR1r3nRKQteMAZ6q5xPU1qSWSb70KoTMFkwTgmE/l0SDUJM?=
 =?us-ascii?Q?KkhY8N1D50tHgPAuteorAEdRC/ByeSEssfOiIlYthJj+xDF1RxCIEg1/Nj5s?=
 =?us-ascii?Q?gV+MeBtfJ9g8E+veoEemK/vw2KJxpwqONHhRUg+9OYJ8odHOWLm50yjBQW+p?=
 =?us-ascii?Q?KC4vWsES7hPhbUCsXWzjrEJqzYz3KV/0F4KGAHNYtQ5CqVad7TxUthjTxIJi?=
 =?us-ascii?Q?DaizhIdFVBtlutExgOcz3o0iWRDHuTWqaOFT5qsr/8mhWwkXTc+cCkpMHVO4?=
 =?us-ascii?Q?MHTikGXzaTQfNZKZXWWXbc3FtrNFF9il70w8Uf1z1Df9qeIVluEnLWdx1EfU?=
 =?us-ascii?Q?XJWfpW6Vnk7ttL7PPSMBSHhQrodxWAN91KkyENpVGAxNpg0tXwPw90YdJEj1?=
 =?us-ascii?Q?TcqUS+lhlbL5HE6LsWAgJf31o/2BuPTikY7OLn27Y4kjOVzWB4V8fl2mXAUf?=
 =?us-ascii?Q?kHMFc+kK/o6HAlEHlQ0hWTOSJxTBUxbjswgd7Ag/zbHZtmZ3ta/8SV6c2Ex0?=
 =?us-ascii?Q?DnsSO/nREXXUu/EQpYRNblmqJIdY4js9URJIDf0FjXCEOAn2TScT0eoVCVav?=
 =?us-ascii?Q?hlxJgcD7IEZOKTPHiQ+Ujj0pkf8O0ZUtvx+jqzpwzDlMsBAZncU/vDhVUxVC?=
 =?us-ascii?Q?AFEqkPDPlYZ2d2Vy93ftgFQjGKE0yR+kmiQ4bBYCFgcI11ANgATlBvCznsBl?=
 =?us-ascii?Q?Q8rKdUt8vVMXfu5PENZf0/3h5AL/rO8dPRJYsLVJq3etucB7IIYecIaPamTG?=
 =?us-ascii?Q?FmuD91O98XSOWyGrx9LV8lGvLp2cVRCWk2FPiIxreJoH3LtQe5wFrtbUmbnS?=
 =?us-ascii?Q?oEWdXTGMHLQ/fkAg3yG8a9WKuai/MonC4Ed4cwVfvHObU2q6RLuouw9Vfm6L?=
 =?us-ascii?Q?EcP5uiv3HmPQP263aDht3uxwxAx3slRe5C4ggYtcRQ45Q7sbcd9G1aj6ye05?=
 =?us-ascii?Q?osI0z6RVJAHO38C+jS1FkNivFun+Wr50SNGy8HlRYvt5IeDwY85DUA12yzjb?=
 =?us-ascii?Q?69TzZUG52wYLPkkhtuS8/IUI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a35f54-64d5-40b5-f660-08d8cd569db6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 23:58:36.3084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KrEQ0I4GHtQm1F8PntE1dh6ncV864Old3o1VYKb+hp5Ltair/xLQdF8+v7L7hKAzfWFworw1XX8XjKwLiL+YAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2410
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_08:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jakub. Overlooked new warnings as I was using C=3D2 flag.
Will fix it in the next version.


________________________________________
From: Jakub Kicinski <kuba@kernel.org>
Sent: Monday, February 8, 2021 11:10 PM
To: Geethasowjanya Akula
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-crypto@vger=
.kernel.org; Sunil Kovvuri Goutham; davem@davemloft.net; Subbaraya Sundeep =
Bhatta; Hariprasad Kelam; Jerin Jacob Kollanukkaran; Linu Cherian; bbrezill=
on@kernel.org; arno@natisbad.org; Srujana Challa
Subject: [EXT] Re: [net-next v4 00/14] Add Marvell CN10K support

External Email

----------------------------------------------------------------------
On Sat, 6 Feb 2021 04:19:59 +0530 Geetha sowjanya wrote:
> The current admin function (AF) driver and the netdev driver supports
> OcteonTx2 silicon variants. The same OcteonTx2's
> Resource Virtualization Unit (RVU) is carried forward to the next-gen
> silicon ie OcteonTx3, with some changes and feature enhancements.
>
> This patch set adds support for OcteonTx3 (CN10K) silicon and gets
> the drivers to the same level as OcteonTx2. No new OcteonTx3 specific
> features are added.
>
> Changes cover below HW level differences
> - PCIe BAR address changes wrt shared mailbox memory region
> - Receive buffer freeing to HW
> - Transmit packet's descriptor submission to HW
> - Programmable HW interface identifiers (channels)
> - Increased MTU support
> - A Serdes MAC block (RPM) configuration
>
> v3-v4
> Fixed compiler warnings.

Still 4 new sparse warnings in patch 1.
