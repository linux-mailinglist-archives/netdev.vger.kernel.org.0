Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7DF2DF50C
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 11:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgLTKxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 05:53:04 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16738 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726541AbgLTKxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 05:53:03 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BKAk7G5026174;
        Sun, 20 Dec 2020 02:50:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=xewrPprrNTz7OBc1nW+ajHDqM7SlvHGoJ1XWILNbrsU=;
 b=ThYrWQ2b8UMw/TkcI81MFslAZ/zU2ArpUbf3co5o6Mo93jM+NLPKKlAwqKa5PZIR/aIv
 2VZcqCygHzgPZ/vu4e9yWfuFyQc7LSYiMJN0tk/RfLdeTbjVvgDNjUyBHCZ4VVXE0Sfr
 NL69fBHvkXPJWK7CDbWr/VmE99Rms9jSZLP4cQmh2AjEJBjKFEhWhOBHO3qPo4oIALJO
 DScRFd9oE0EPDMc25oDWxYkmGqIsWDqHJQWAkGLyPncCMMzip3MT72BTKwX0omPVy5rd
 J37NhOYslI3HaS72OKOi7AUviwu15DnGlCE7BvRBC4/EXN8qmyLao2SI9Gk9VOnPy7pN Tg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 35hfru1vrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 20 Dec 2020 02:50:04 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 20 Dec
 2020 02:50:04 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 20 Dec
 2020 02:50:03 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 20 Dec 2020 02:50:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da502pOYtAajD9uCdknBO1MXgj2CRguW9g8xXRVAIhmgavZrod5X8zuoRwRwhTWNOEfGNnL5MlJnokoGrRrkNPt3rDPpF5OL92KVwF59XUcUnTUVGA9WS4fWE8L6kuRFbBIyfY1vqxrBFDMHAcFnC17mTysIBLe2M0W2hM4BlSp3D21v/qq5DoZwiGPU3iqS9V6UKXWlXriTY3M+klotjybtAPfFG+8xyCx27agwEwJX95FOdLZvyL2O4n/RHkcvIdVVh5lcNXvDQbuBUX98zoOlMjTIJ4WWncYG9eX5WXY+MTkaJPqlGUkH18yjIjmMn4f5SzR1O595JySnQqbzbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xewrPprrNTz7OBc1nW+ajHDqM7SlvHGoJ1XWILNbrsU=;
 b=DvMufptbMSxfnjvs3f8Uo24SXkirwMDOk1kBZlucccKboG4NuVilAFmY4Jeq1XCtY5zvC9oVKVOujrD4TctAbptDmZw/B17IO+LzHnyvoszYLY62flI+IE3M0PKJjIFSgxesVcgjWD0gFus8O4Te8KAURBbbkURpFYxroAsY34dIO+U4s1lok2fXS0XG81ealmlTVnkAS0nxZgQWU+2ep7qIJU7bx8foGSD4g6XpVBsX3+a/MohbwQqd/zpBAcnOEDE4QwAfMA0CMKwCc+IlTT6Ab5KXttQwTwwG2QUUbjkjvH/3E7fazPF+lUKNsBjLFYgIXbIqRhAwer1kAy7mZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xewrPprrNTz7OBc1nW+ajHDqM7SlvHGoJ1XWILNbrsU=;
 b=IyiCPyzajyukWXRjSVYCbLZUwHr+QHhChk6mCgI2XxC5Cj+FmRiaMuco9gQ9Ks7xa/0K7cD07XT1iuDw0FD3KdoX9XHbY4WyNd04kyW2AGcjP8MDsevPbWlfe5wFyWVhoQIuR67UCotm8+uIklbzxDlca3bR6xdQonoWNc+pa1Y=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1167.namprd18.prod.outlook.com (2603:10b6:300:a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Sun, 20 Dec
 2020 10:49:59 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3676.031; Sun, 20 Dec 2020
 10:49:59 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net v3] net: mvpp2: Fix GoP port 3 Networking
 Complex Control configurations
Thread-Topic: [EXT] Re: [PATCH net v3] net: mvpp2: Fix GoP port 3 Networking
 Complex Control configurations
Thread-Index: AQHW1HFsFppZFHLMZkWdy2soZ3S/Dan+uHOAgAEZlIA=
Date:   Sun, 20 Dec 2020 10:49:58 +0000
Message-ID: <CO6PR18MB38730422BDF0FF5310117B05B0C10@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1608208648-13710-1-git-send-email-stefanc@marvell.com>
 <20201219095917.67401234@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201219095917.67401234@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d08d4b73-02dd-4f46-0367-08d8a4d4fef4
x-ms-traffictypediagnostic: MWHPR18MB1167:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1167C4902F50EEF953D3D323B0C10@MWHPR18MB1167.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NaYZRvOhbyWfeVQNOOri1S94jUV/Gdhr7kEQcx+Zdtd56OuskpEYxMUorAf++hk5jqb42n/Vwwc+NrKM3P2doWgbknAM71NajPmURfqnxTcgKsP5SihwWPQqLfrKfDpD1SaZ0dXat2Ww3QowF79JP3EtD5SkRCpAzmOYL+ZrJ5zjNSVcpF3klIMt6V6rYrYhx2EF5nDEDAwi/Cet8eDW3uMRSe9kWOSOKyR2qfSw8qSUrENzmSfa0kpiNC9ZdI1jXKV3call5KlQcJX0VLa+vir8DrXWbdJ6pyebtTnLCY4ZaHseZ4Gd4LwBe5VgyaxAKaqN1dBTClWBLvSGhU97NL51ufexMI7r9HEwjeh2JrGOHOkoP8i2bRL2mHXL5nbRvj1T1UZHxQh9F+ZCxuZmgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39850400004)(376002)(71200400001)(54906003)(64756008)(86362001)(66556008)(4744005)(186003)(66476007)(66446008)(5660300002)(52536014)(26005)(6506007)(6916009)(8676002)(7416002)(478600001)(55016002)(66946007)(33656002)(2906002)(4326008)(9686003)(7696005)(76116006)(316002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rg3FDfqjO24YqQ2nn96JqMdcT1cCEHHFMUalo1856mcutXWm3AwRWY9B+Hh2?=
 =?us-ascii?Q?NrQoJT6EZ2uALtl2Vz2nZ/1PRG4RTfHI4UdxHFWJmTO5rxm3vnhKmmdoUhpQ?=
 =?us-ascii?Q?CFirCziYpimAlMTk3jAsFCXa/c5uSTYlW6ILCO2bu9KfL/EHXJxTVy5QTj2g?=
 =?us-ascii?Q?Eeoh0iL+GEhODg76SZpgeRjMSLlar3sn0D+kasIyNkiEcunJ1j8eJpu/Vb9Z?=
 =?us-ascii?Q?KoCb3YomwDim8RUiunM9LBhgzuLLpO+8YLHd55yqucwulO5h/UpHAcM7qBQe?=
 =?us-ascii?Q?WDpO3Pg2ZZqxouyvQ4FsJcV61L17nxeLopzu2jdvlVE8c9jr+lGgHUad471m?=
 =?us-ascii?Q?4ftm7usNR/dBDXvOD9qImeIB2xKWBkUYwp6E8vZ6VrEU3po4lS90nE82HBgp?=
 =?us-ascii?Q?gvhNd/DlYpqRH0W/CGK+lobdwBYJHKs246mQg1U46CAo1Z8bqrus7zD+JSPb?=
 =?us-ascii?Q?IcQM44APJwkyfPjEVqFtUuwpLNp+eHc1JttGh2Jwsr/0PA2Y8ofiykCP+t9O?=
 =?us-ascii?Q?WyYaQHZhffqY6Cgh4aE0sRPFd7qWAyuOtynpg1YpkFxB0CgV7ZlwYRis3+jU?=
 =?us-ascii?Q?DQrUYHM2ZXWbgFqvP7jiayvQgBZ7MUV3F4qGmvF9tsGSVakdLbOnUKi6oSlV?=
 =?us-ascii?Q?J1raSBdCzLkZC7WN2nHNTficyRSvQZitsBEs36RwY/cJErg/d7WoJF+YuDrr?=
 =?us-ascii?Q?DqgTVYrWtpjtWQmwED/4AiOjJQQfxphLnCtcgofkhKH52fL5j+kklvrQLJk6?=
 =?us-ascii?Q?8FhI3LF0PFZaidgaE28h5bq4B5xPJt0D2tp+zIw5JRJawg87dO+RghA+6+ot?=
 =?us-ascii?Q?eWjnv8gCrdXMoMxnGK4jBsjHak2KWO/ndGIX3A5m20Cbc0LJ0c1lath4dgEn?=
 =?us-ascii?Q?xu580OkzuWHwGW5rNrCdm0Zsnj5kJcR84GPaayDAEhVw7CFrtEU0tyUSeA9E?=
 =?us-ascii?Q?XqS8B74ldSlR0ZrlGuIsBKD2nM+APYjhdCvVntNG7FI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08d4b73-02dd-4f46-0367-08d8a4d4fef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2020 10:49:58.9704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k6c/Gw73NuuXt6Cfwvl21J4i2hFn713aeigw56QwH/DVZCOECKBjWARk88/t0peiFGdumRYg53j2EbQNELSDDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1167
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-20_03:2020-12-19,2020-12-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, 17 Dec 2020 14:37:28 +0200 stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > During GoP port 2 Networking Complex Control mode of operation
> > configurations, also GoP port 3 mode of operation was wrongly set.
> > Patch removes these configurations.
> > GENCONF_CTRL0_PORTX naming also fixed.
>=20
> Testing the stable backport it looks like this addition change will be
> problematic. Not to mention it goes against the "fixes should be minimal"=
 rule.
>=20
> Could you please send just a one liner which removes the offending ORing =
in
> of the bad bit?
>=20
> We can do the rename soon after in net-next, the trees are merged pretty
> much every week so it won't be a long wait.

I would repost with single line change.

Regards,
Stefan.
