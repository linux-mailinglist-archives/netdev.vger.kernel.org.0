Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A263B0B7D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhFVRhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:37:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10984 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231549AbhFVRhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:37:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MH9rji030353;
        Tue, 22 Jun 2021 10:34:43 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0b-0016f401.pphosted.com with ESMTP id 39ap176xa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 10:34:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Li4HlKr40zp5UeU0TA9YV4rW+R5GJQkEltq0txevGuoJ2U4WUfH7PBECQw2uaAco1sXHkCwuMNxozqW1sMB0Cp/ceiPRjI+D52KKux8YdqHAKlGmA6w4rkfpFNCRNUAoUl2KVag9ussoP2xdPBvLRklf1gJwxaYgLoMFQIrrpWqAFKRALZbVkahbTsaXGZ/lz98HxFU+NdP83gUxQA1Sten/rAep54oqDlAR7aTAK1VF1+HAwVUf8P2TI9TFkZuw4QdQ742U5uVNFylQDUCH9choJVtkqGzz1raBmy2m2EOXjzsAoP06lZDWREN1eKnHEU+3pIrn1g4tUhAECA9JOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmIjCyq2QARAciMxjTsMkpM1X0B9PGEdz16TOYKk4jk=;
 b=MWlBUx1PPRu7S2jm8D6DOMJkc4MNHyrPFONgyqLPqkoPbumEZs9GCsaFPftniugRjE4nfnQEGTusJWKPErYaVmn/S9i4aVgn9ioE8e/DwVoosu0ktoE0ToE/fZ2H9P+783dUMpFeSgsj5/UMpwuKR0kt1EN0+NsjSYz7EoxJAvc42s1M4OkB2e6s+ZprUdgI3o88a9sKNRt6tS0o+60Gg/TLZpQB8Dwb+KY7CZpzhM+DAxDf0mVaIxOkvap5iEddKKobdxXHk+yoVpSLO75xvT4IEm7ol4CZGrGAHtyzQPC3N4v3JCRnREDbk0Pabf/SnIQBU3TDQ/+GdXffiLv9/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmIjCyq2QARAciMxjTsMkpM1X0B9PGEdz16TOYKk4jk=;
 b=BCZq3AW50LjenE3u73B/d/aIgQh3VMzRBQ4aNHu8dAf5hlkEUOdT7ija2OiL9l3mc4HMWb+EFTR+sV1aB7GNkA+9elKyrxBbdVFqZb3ppa4jqIS52Fro6+/63xnhOTCazpqJjKfKC8B6g3Ofv47dh+DE18HxioWAGmuIiebUlrI=
Received: from BY5PR18MB3298.namprd18.prod.outlook.com (2603:10b6:a03:1ae::32)
 by BYAPR18MB3045.namprd18.prod.outlook.com (2603:10b6:a03:112::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 17:34:41 +0000
Received: from BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::98ed:f663:3857:12a4]) by BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::98ed:f663:3857:12a4%5]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 17:34:41 +0000
From:   Sunil Kovvuri Goutham <sgoutham@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next 1/2] net: ethtool: Support setting
 ntuple rule count
Thread-Topic: [EXT] Re: [PATCH net-next 1/2] net: ethtool: Support setting
 ntuple rule count
Thread-Index: AQHXYq5VUTtl8j6Y5EG/MQGN8HpAqqsW7MqAgAFC7iCACCQ0YA==
Date:   Tue, 22 Jun 2021 17:34:41 +0000
Message-ID: <BY5PR18MB3298D48970CC992604275E29C6099@BY5PR18MB3298.namprd18.prod.outlook.com>
References: <1623847882-16744-1-git-send-email-sgoutham@marvell.com>
        <1623847882-16744-2-git-send-email-sgoutham@marvell.com>
 <20210616105731.05f1c98c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB329854137536121BC345502BC60E9@BY5PR18MB3298.namprd18.prod.outlook.com>
In-Reply-To: <BY5PR18MB329854137536121BC345502BC60E9@BY5PR18MB3298.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.162.188.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ef31a1f-7a32-4e88-8153-08d935a4047c
x-ms-traffictypediagnostic: BYAPR18MB3045:
x-microsoft-antispam-prvs: <BYAPR18MB3045E8B615975EA7B4B793ECC6099@BYAPR18MB3045.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eGQld5+hOWsLkTYdJI4BIyO9P5LPKYo1yoOAc3wp7wW5l1t6BqS/DpwLlCQOwgnUsdzbUuRTDnPqaLxC5lJ6Yp2zmpwb3NXPERCwupgD09NGVaob3eahOV32ja/UKvCgVbIYxBBNtYeYbRk3HT34/R5LpdIrmT6xKTfmAPkWdejMD3N3OSb8Un95h3JK/RTJYcWP5pGAMS3+Kw95KymhdDcfR5zoq7dHJKx/GifOwWwgdfAWnVzQpXYMuVszMyJLgUW1UqA/NzhaF/qlRni37lTS73qDo/nu19/9sPSWYznujFABCZ9YhsKoMzhxO1DH1ehzxjD1oQmi9FTFdkRWhyt2C6PKftSMxCM5MjugHiUGQCKkYzJEkg9PfywuPz3uRTDduLcbbgqkpcOuVZC5Ywca4DIHcQUcqD8mds7v1bq5vAVQbY0mg421euckfFbqGWyalx/j9dttD0QrWL+KhoXhagNesR7nNjDs5ceSTosXz6Lpq3CpCY/5dxUCfLXIfwcdQ1jpjIs1qXb02we9edWeIRMbmZVWKAqBeRAhlzZa6hXyyFItKlfek2HZdbBEoPIeibA0+UZiDF1ScKM7lryyni2Zi+tDxf/mXZZwcJg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3298.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39850400004)(396003)(136003)(376002)(2906002)(478600001)(76116006)(66446008)(64756008)(66556008)(186003)(4326008)(86362001)(66476007)(9686003)(66946007)(83380400001)(8936002)(33656002)(122000001)(38100700002)(8676002)(26005)(71200400001)(316002)(54906003)(53546011)(55016002)(5660300002)(52536014)(7696005)(6916009)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?snGDcWYP8gpDJj/fdkHBuk5rzg6SQ60iRnG8jz61Ky0CBF4xt7RsV2jO87FP?=
 =?us-ascii?Q?05yL4+BmuZkXqK0sjR18Gcgr5P8MJsywSoMiDYtH7JSx4h49Xw1afWuk0p9f?=
 =?us-ascii?Q?wxa1eMCMR0qpthNNXTTnChmXWr6Lk5gsEUMLd7qXc4k6yXwnBnq5wbxEaRpb?=
 =?us-ascii?Q?p7Xa1l9jP96xTg44x2V41IQy/W6wU11HduRsI8YbkeRvyJ5l5rkxWc1arNRD?=
 =?us-ascii?Q?7dziI1YSFDAMRDvvAzpS8YO1HWgr83KnkI1Bp2rb2CeiKdWdAQpMVmN/fLiD?=
 =?us-ascii?Q?t23tHToz3ozW2dPmxfsKgiymN1JrxSt32QAX9Qiza5JVnkhyp6kHC3yEbfpg?=
 =?us-ascii?Q?WBrlYkKiRGmKlcAiQUvL5V85k+xcrvQFaxEJ2Sk1jfFTNCTwwsyLi3K8gtSk?=
 =?us-ascii?Q?66MN2FHNjGXwsN9tTZLhfcymM5epuP38y76jRjhamqcjgAxRJ9uhiaFEAUaJ?=
 =?us-ascii?Q?a8WMfKrotC/WKytkkiHf0TilhqUQRHmPByguW+NJ5AHrdYHiQoeUQFbtsDV8?=
 =?us-ascii?Q?HsipSRFbHrZFOChw0f+silc1MMC9xSLYQK9+fYitXQ94D/0Oz4ufAmxLH6EB?=
 =?us-ascii?Q?5UXv2RbIBeiw4pzmyEbUTTrY7Jv5Mr+yCuG+B1EUfIlsPuljXckJd5klm/2Q?=
 =?us-ascii?Q?biRdH/gIj5YVD46HW9qkCPADfTRanAUwufnbUWW504vfnV/96oO061Fh3cNO?=
 =?us-ascii?Q?xBjiiMp/uZMEeLLwFCsMo7hUad45242q68FfWF+FQRaBQfS3pIXSXUkxuh+c?=
 =?us-ascii?Q?IOg6mKcN8CYXYLvkOk8Qrfvld9WHkctNHHmSRqjJ6HcOuVc0XkLs27wunXvh?=
 =?us-ascii?Q?bTDNox9myQePnIumUK98Y+WVqkYlM/Y/ZYRxPZZ6l4i3dEk1TmcpW+DDKhjc?=
 =?us-ascii?Q?NeURvj5SMdUHO4w5XkyCIxUX9N1u8oM5aJgwTvxdBkLjNZXnEF0Mqqz0turw?=
 =?us-ascii?Q?nPtwZlMYgmmDSd++7sajE0mVx7hvoMuvT5nvsJhjytP6zaj1w6IwuVt4bgy6?=
 =?us-ascii?Q?TsBKemsRHG7OYt3PeDrhaj/Us8OMB4vMKiEkNZ54zcukW9/annozIXg2S81L?=
 =?us-ascii?Q?bYRkn64hv6unUKsZT6/alXvXP7CRXl0jlQqewD/PpYJazH80suCUx1M7rGaX?=
 =?us-ascii?Q?qconjTscrOzJAwMnNdKYxpAZ2t7pXqqeD0FOFtMXhrBCNbJSJGJTQ7jQnvUa?=
 =?us-ascii?Q?W5o0ARv1fK5B2g92muiAvClun4GcLGJjFW1LyayEiMYNuqaP2/R12q54LIn5?=
 =?us-ascii?Q?j+GYVcUOw9wZTWy6SMabzs8BZORzxjY7wPFpZvFucwUjgVkulYBK71vAIuFt?=
 =?us-ascii?Q?LgQYE4CZhQFEwBgjup+1zf+Q?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3298.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef31a1f-7a32-4e88-8153-08d935a4047c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 17:34:41.4933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EhWlnQaurBE93jiIHPRwvhGfkcrswVeyBVDPJgzmL1psLBM6DW9mFcxnDnAUC00J5NK6bRSIafh7ubBLJrdl6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3045
X-Proofpoint-GUID: SNtZHaWiY9fQOTrTp5A__KqWrRyQ-BAq
X-Proofpoint-ORIG-GUID: SNtZHaWiY9fQOTrTp5A__KqWrRyQ-BAq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_11:2021-06-22,2021-06-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sunil Kovvuri Goutham
> Sent: Thursday, June 17, 2021 6:46 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: davem@davemloft.net; netdev@vger.kernel.org
> Subject: RE: [EXT] Re: [PATCH net-next 1/2] net: ethtool: Support setting
> ntuple rule count
>=20
>=20
>=20
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, June 16, 2021 11:28 PM
> > To: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org
> > Subject: [EXT] Re: [PATCH net-next 1/2] net: ethtool: Support setting
> > ntuple rule count
> >
> > External Email
> >
> > ----------------------------------------------------------------------
> > On Wed, 16 Jun 2021 18:21:21 +0530 sgoutham@marvell.com wrote:
> > > From: Sunil Goutham <sgoutham@marvell.com>
> > >
> > > Some NICs share resources like packet filters across multiple
> > > interfaces they support. From HW point of view it is possible to use
> > > all filters for a single interface.
> > > Currently ethtool doesn't support modifying filter count so that
> > > user can allocate more filters to a interface and less to others.
> > > This patch adds ETHTOOL_SRXCLSRLCNT ioctl command for modifying
> > > filter count.
> > >
> > > example command:
> > > ./ethtool -U eth0 rule-count 256
> >
> > man devlink-resource ?
>=20
> Since ntuple rule insert and delete are part of ethtool, I thought having=
 this
> config also in ethtool will make user life easy ie all ntuple related stu=
ff within
> one tool.
>=20
> Thanks,
> Sunil.

Any further feedback or objections to these change ?

Thanks,
Sunil.

