Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A941F4165
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 08:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbfKHHd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 02:33:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18512 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbfKHHd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 02:33:26 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA87TRfS029430;
        Thu, 7 Nov 2019 23:33:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NGBZMIXDfcjXddC7ut4x1O3ANNk0LlW5PT3FfELyBWc=;
 b=dS66sfMX0KlFSsko+M8bhZi+vL+ctynC05iaXEjBeP1NXMHgwL5Isj6rtzYvdjx67J5X
 nFSkjdiWgEBQKguGAIwWZ+Q+FLq1As4Iu9XGrkrWOREBvroKnu1uLxLqgG86zx6i/Bb6
 2cvolHtZaHMRKVNgMZLs5Jz2xefHEs1vW8w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u2st81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 23:33:07 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 23:33:00 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 23:33:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSzejuNG99ANWd/+/6cAw/tmGDo4E/5w86j2nGVuVZggF5G3oPJWmqCX2cmG484ZIzOHfobLz0nP7+4Xnv5rsFt7xeEd8bSFabwyjduB6bZABQGU6mx2QovUZWHnyXyBs1ZQUJJOoAe/RUqO41Kj40JG6X4dElo6UXGpIIDWogpncu55WdQEpX7twt5TyqELTfNwVOkGY41MAfMthzpR/QRg92iJ1MBWCTb9bEi/FSdYyWm3AibmZGV71Gu/Dvua8n0uDGaitVznaYjsApzXAiRrm37ApmQ+yj7X1YY+LPSd78jsL8IJ3ZKzxz+2TlilNPF8GfqFtfkMyrrId/S3bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGBZMIXDfcjXddC7ut4x1O3ANNk0LlW5PT3FfELyBWc=;
 b=MH+l56aY0vMCkQ5pGbewGy406ruJGPauXh8Vl/95nol+irSllAMSI/sI/r+tLDGYVM7jEaBRsMWEw0PiZmgBUZ/1kHFabgBAhUOxYyn1Xg04X83Xnp+uaRKQyHoOpI7OhDTaTlmKYb2bDiXXR/26SgtZ/dgXYJ9ut8mwr75F2jrNKKK2llTeYnz5BH+brl/WHmvefBiF0YNrtOr1TVBJiZ392Gpg+7dzxav89mCR/DxgTDUpWTYBUFuLnMML6Y/UimwC+3QZ2uRaHmDfuizmv9dFqVruQTi+icTI3sw/OhxEbDc1RZ+0bJQGcsTWRX0Mh3y/Md2l8aTLn56Ktg4DYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGBZMIXDfcjXddC7ut4x1O3ANNk0LlW5PT3FfELyBWc=;
 b=NJRU2p8simB8+vOOX8FhXYwnEspfnXZjA1j8cKP7KhS0nSIMmA46XEzKrqBzjaYBWYQEFuGZ+M1c5HITLUqjz0SwbHYSH6b8jGo0m84M/cx/Oa8jBrvv4/7S2TVZAnA+qkbQMEOFm3n4XRgXa0wLFzYhrzh13OFHz1/YpepZaF4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1598.namprd15.prod.outlook.com (10.173.234.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 07:32:58 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 07:32:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 13/18] bpf: Fix race in
 btf_resolve_helper_id()
Thread-Topic: [PATCH v3 bpf-next 13/18] bpf: Fix race in
 btf_resolve_helper_id()
Thread-Index: AQHVlf+ROsSnRhEyB0mzybcdV8yPA6eA4XwA
Date:   Fri, 8 Nov 2019 07:32:58 +0000
Message-ID: <F06B5253-8763-4D97-A4A4-54ACE4E14C52@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-14-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-14-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08fa88f5-bc65-4240-769e-08d7641de0fa
x-ms-traffictypediagnostic: MWHPR15MB1598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB15980106FC8956BE7BE6B02CB37B0@MWHPR15MB1598.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(2906002)(316002)(14454004)(6436002)(71190400001)(486006)(6116002)(186003)(476003)(46003)(86362001)(229853002)(11346002)(4326008)(478600001)(66446008)(71200400001)(64756008)(446003)(53546011)(6506007)(36756003)(6512007)(25786009)(256004)(8936002)(50226002)(7736002)(2616005)(99286004)(102836004)(66946007)(33656002)(76176011)(76116006)(4744005)(66556008)(14444005)(6246003)(8676002)(81156014)(66476007)(5660300002)(305945005)(6486002)(6916009)(54906003)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1598;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: In00LFfARERa72zRgpieUs8zAPkazQpPRwTdlc+sRc3Kh1GrSvC4xDduT/H120OIoW6vZaSJhb6pQ2bFXepfZTidwARR0lzzoKvYglCKqGbWo0BrW1RGypLqbXnrxLEGG3wQlvGL3KsRG8kq0ZZOqVDWUBcJELttmCeypONFy9AC+BSpkxHrvvps30RUIULrKgmNYCOnw0Y7H5wq45bE4ecEY5oV1odvchfLJhX/HB6E8cGMmYrJOZeVlQ86Rg/PhVT18OXqf3x2m0x3iraPSMNOErb43bwklANskJWMaoAy1zJZJ7eU2Of06GkO5Mn2tvd+4m9EiNTtLPJQrispemtZDV0HNMqnlijGqyTOBFy0tQG0ejrgdcdPhssIh6oDqSTfGESitj6IqDbnyWNH0icmJALOwaYy6sCLCJi8y8CnsR0ucg9+ciyPzfoctOqu
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40A8E05300B97F4A9497BD8C525D0E86@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 08fa88f5-bc65-4240-769e-08d7641de0fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 07:32:58.5045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YJtHnUmPGsc5lHSj4v7Ha3jFCyzXU+5F1pF6pmmh+IolK6Sw9iuZ20CTmNkrLBaF0R+hW6x6EikGuc3JHrFuDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1598
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 mlxlogscore=976 mlxscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> btf_resolve_helper_id() caching logic is a bit racy, since under root the
> verifier can verify several programs in parallel. Fix it with READ/WRITE_=
ONCE.
> Fix the type as well, since error is also recorded.
>=20
> Fixes: a7658e1a4164 ("bpf: Check types of arguments passed into helpers")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

