Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C319BF4152
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 08:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfKHHY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 02:24:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26436 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbfKHHY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 02:24:28 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA87NIdL024859;
        Thu, 7 Nov 2019 23:24:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=F5KmE0JXiNRtPg8J5OWLB1ZIHR4ukq+C2Z0WWyUH9CA=;
 b=nIE0nDSkEd2j/dZHmuZbr8FUY/qJoGhCqR2b9m/sS6fDTAk5VuKnBIG/nxLLUrglrLmu
 306bUsVqV9fQtS93ekqfEzNf7YsvTNAgHJFbNCN6tKKBu9JHOZBUDM3qUQGeutEhmzhe
 pwjpNTwaRU0oCdoHxlQXCuotr8Tlen6z6e0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41w6sswu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 23:24:12 -0800
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 23:24:11 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 23:24:10 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 23:24:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5l5x+nh7c1rlMvhtJjBKMmVZ9WaqNEZe/Emcx3Q4LkhDr9+ki8dG8gNIbcN/qLCsc9FVr6lnn32x3iEqzJFaeGO8zLhEA8a2ZEXNb4MjElgBnIeg668lHCfLKcTa8v50P4Fn8XsiK4psQGEf+j6njjBheorQ/5wdh7Y13xvseEOTPNo8HcJZnmgI8oMuNbLmCQbnIC4XOgR91zEim8LPfkmpFDAfigVcC3KNyTsR8vDWZ5OZ7ZMdnGBRjFesyZ6FOk5YnOTWB9Aj1zlSuOZ6tVruhnlbbO1qwyp2hT6i3gcTtG9LBKMdVtMIg9aMP2qMr5+qvBOD0p1lzjeqpKV5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5KmE0JXiNRtPg8J5OWLB1ZIHR4ukq+C2Z0WWyUH9CA=;
 b=Zm7sNuq5r6zFYloJCv+2YCRq4q4qjbCdsArNE/MoWkGuchDYz3cCdTDv9+UN61bGfRFJNczv10vj0Hefs2UWNao8XVZQhcxla43hh5CQjb/39laiz7gExF5+Qbj5D7cqxlx1PxWo7/bztWD++1r7ComcH3E3CDcB+Mq2Zyc+ggSKVuz13OR0dmyjfLsVyhkhrGgoHVclpi4eo/W+19zokXp6Gk/PeIC8FtXV3ya5WjdzwfYMmbzmc79d+u+FuoMeQR+A9rrqmMEdprKyFnB2C7hAhlmZveFPFaT0WweivcztZ/8nCEuU24G5XVqBGcTNJmMobu3unv/DjlD74bYwVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5KmE0JXiNRtPg8J5OWLB1ZIHR4ukq+C2Z0WWyUH9CA=;
 b=BnDnfFyzPv+ByeyZ7/iyWrc/f40sqM4lpF/olCrQmjk7pdR/x1lXJ8s5XgSwaC4J+A3mY08NS1RHDhX3v76/x5uvE50PUsBGQ4L1KrILr1eJD2DmYCj0hRxdsr4Rz0mKI+v8nRRxgxI7/USr8OTC9Nt0ZSIl/sByFl8PK8VkhOk=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1870.namprd15.prod.outlook.com (10.174.96.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 07:24:09 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 07:24:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 11/18] selftests/bpf: Add stress test for
 maximum number of progs
Thread-Topic: [PATCH v3 bpf-next 11/18] selftests/bpf: Add stress test for
 maximum number of progs
Thread-Index: AQHVlf+C5SeYjS+RYUG9oQn8HiYBsKeA3waA
Date:   Fri, 8 Nov 2019 07:24:09 +0000
Message-ID: <5C60BCEB-B39A-409E-A9C9-FB975E7D2C73@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-12-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-12-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2172f9ac-3a60-4aea-5214-08d7641ca5aa
x-ms-traffictypediagnostic: MWHPR15MB1870:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB187040535A16209E07CABE23B37B0@MWHPR15MB1870.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(366004)(396003)(39860400002)(189003)(199004)(81156014)(4326008)(478600001)(316002)(66476007)(64756008)(14454004)(5660300002)(54906003)(66556008)(66946007)(76116006)(66446008)(6246003)(33656002)(36756003)(86362001)(256004)(5024004)(99286004)(305945005)(186003)(46003)(2906002)(11346002)(446003)(558084003)(25786009)(486006)(6916009)(6486002)(53546011)(6506007)(6436002)(76176011)(6116002)(229853002)(6512007)(71190400001)(8936002)(81166006)(71200400001)(102836004)(50226002)(7736002)(476003)(2616005)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1870;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wCH4jmGtW2TpLu6w9RRklI8vuYpHcA0dpeNonTY40g8jO6B7dhRPas8QA8W8YHvvn7mHDZ0QS4yQYaDNtDOKUurZjEOvyjdhGOYM10fzVe9gpzIZMQUbWXVam5wGMohsWhRv5E7oallD3WiFMs9NFmo00sZuJQtOrBfSZPPeoqerVk56LBb0HhrmGeDKPQqJip3bcrqjahMGSbpIgohAVB8ZBXX3LslNkF6jyeBznt3Qz+IWsPO+yoMDBeYWXogUpqBFx3gOcX5ZXnBGNqBNkzZi1ECz9hQANEzRZJTaL1VHh1DCZG86ZyqKBuA6zJhMtxsqi+f0mlKd3Wu7LS27RJZE82GYXokB5RupwhLys2BVa8gJHbEqC07oZ0pJjwNQ/44Mo5LBHdYtwPVg+/s+z5zIcShiih+BHnFsa7IUhFsee/MV/iovDfHIfvMbeNB1
Content-Type: text/plain; charset="us-ascii"
Content-ID: <788F835C9530794491C38189E4335F3A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2172f9ac-3a60-4aea-5214-08d7641ca5aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 07:24:09.5919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aU8iS+FdQWs6lJNT2uexfuxw2qcXDdbVnp4hbECWpRTelaHSdQPJ1TdVEzYLrZ5t7A87iwv5/17yxCw0zo/aHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1870
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015
 mlxlogscore=651 suspectscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911080073
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add stress test for maximum number of attached BPF programs per BPF tramp=
oline.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

