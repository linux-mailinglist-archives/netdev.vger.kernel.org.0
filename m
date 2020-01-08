Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853B3134972
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 18:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbgAHRgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 12:36:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63742 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727328AbgAHRgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 12:36:01 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 008HZgO8007959;
        Wed, 8 Jan 2020 09:35:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QcQpzPpFPVSOPuDmZlxekZH47qK2py5LhsgKZDnxxks=;
 b=T5rSUPhnxhFC4/xGeDLlJ+t6hRdhdXM7hSi6lcFGqHyWD6ul4eSIdaP1OmlfQ59qH1dt
 1FSaClE713vTHlU2TzyhVi+Lkv5TnAuqY5i5vZJciLM4IXTwNQw9Db347XHMIWRYSOeB
 El8eAsTupInT+Sc3FYXJnwGJOzhWDtnZXPo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2xdh770uks-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 09:35:45 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 8 Jan 2020 09:35:39 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 8 Jan 2020 09:35:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6juItI2oMzpq+ZfkaPRFTte3D5FI60dBFS9Leb2dsv5/pLDbr37g94QlpasnfmOIRXvlt3bhOMUaY4TzbVTpe1X0/CM/go7DWZ4Oj2yOsV+5y1ObuweC4byoYMXSaaIiks9o7jYc3pNaaUcnGFgyRf11xorlPzbfmtGKQDNlj3bsTYQzFBvo0WGU/JRVtb+oDpweC1ruCI5GOgrPPcJjXFYCT8SHp/dWaZdW2lMuVgBrG9ctZRD9DjvIOwUI+kjxnPTA4cnzn54JT4nSTv0+wHBP3o414zpPvSg1dNzsyGwYEHWkdAZb2QYnronckywU5eE8ZmDMpQmpjqmT9jL5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcQpzPpFPVSOPuDmZlxekZH47qK2py5LhsgKZDnxxks=;
 b=TPdFSS32HR8E3BwLOqxpVOd5J4h/G6dYbU5tQcHpfP7Dwh0AJuNQaBzzGSJYTS2l+8vKeKvbDRcNa47DaxouzTjcr0R168LLY8qr64JHw4+TR9eCgDQT17tSiqfSg2QNw1+fz9ljohs0f7H09gGJCm91shX+vWowEmvh5vbZi4jUV8ugDTavfJ6dmZJ0ywFH4UdQV73hRKl+pY5m7d3R3aGtbKYBpSYarjCT4YlAfR4VTy9wVhzEUNFNt5jgNMse51wzLMZIjAG2S0E3WpbSr6kjttzdVc12IZkyY6cm9TcXV9x6uA0Dkl/BsLcLL4tjIR0rRhXVeURNFOQhAkzGiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcQpzPpFPVSOPuDmZlxekZH47qK2py5LhsgKZDnxxks=;
 b=b622ZL5eroD3V80mAkSKzjEF3tSjvR1SdgvYj7JwCeQ/lidaMN4puXozpS9f7jAuY9zYR0rN5NWIHWQTGPtrAlzYbkAfKfbyTLuz3CXvSt+xQd1WvYNkWqn4Zv+Zb6IFXdDaiUqwiegME494vLwbvPjFFtYW+clGazZhmQGNreM=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB3080.namprd15.prod.outlook.com (20.178.239.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Wed, 8 Jan 2020 17:35:38 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 17:35:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/6] libbpf: Sanitize BTF_KIND_FUNC linkage
Thread-Topic: [PATCH bpf-next 1/6] libbpf: Sanitize BTF_KIND_FUNC linkage
Thread-Index: AQHVxfTmliKARNE5qUWqn7g+hk2ocafhCCmA
Date:   Wed, 8 Jan 2020 17:35:37 +0000
Message-ID: <72DB93B5-BFEA-4FB6-8E5E-CCF69F0B32DA@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-2-ast@kernel.org>
In-Reply-To: <20200108072538.3359838-2-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:180::c159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 228c3561-b455-49a9-8a93-08d794612ce3
x-ms-traffictypediagnostic: BYAPR15MB3080:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3080B3B9B135580E95FD9DAAB33E0@BYAPR15MB3080.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(39860400002)(376002)(366004)(189003)(199004)(4326008)(5660300002)(316002)(6486002)(6512007)(36756003)(6916009)(71200400001)(558084003)(54906003)(478600001)(186003)(66946007)(66476007)(8936002)(81156014)(2616005)(81166006)(76116006)(86362001)(53546011)(2906002)(66446008)(64756008)(66556008)(8676002)(6506007)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3080;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w/z2sSiFjydGicGXnN6zc+kQjSb9QCeBYmc2yX67HL0JllFrWlz87D7DG0OFwM/J09trPWy37Pz2vkBx15RiZ26vI4/I+F4aVwlrgpLeDUHJz605MsRsnRuGrKeH5Yd20m+dchULnPMS1l5i1rhy+42o+5JkkkVphti1/V4648R9PFA912N6NWuhUQlPfOK4fNZD3fHJVpxkB3h/TPNmTtgj8OFRX0kIhsKKP9Ro9amj1U8D/Bli4KBfx4eQ4J1wt73v4FHRIRgaRwornom65AstTBIps/r4WGC3QT5caB8ZLa4S2caA9U7YHJeswJh+BKiFhA8OtB4G3LcD0jNZA/wOELia///JNSYIH/bdki20ZIEzGVJE9K/cMkhWnmHvnRaUbtHnIilV7U8dMo+mjNRtx5UFr7FmU/bIFvsjku4BUIeibX6Xi7pLUKkwI+5C
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E83F05268465D64895F805EC12AA5FE6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 228c3561-b455-49a9-8a93-08d794612ce3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 17:35:37.9644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gveAG0jGFgCs1Z+a8OdOtpSYeo5QtfRiaIawMQM/Ru8dPDxfFPwG6n3bdKpWE7WfG0QheTFTvE+G1MV96fVWnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3080
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0 clxscore=1015
 mlxlogscore=771 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001080142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 7, 2020, at 11:25 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> In case kernel doesn't support static/global/extern liknage of BTF_KIND_F=
UNC
                                                     ^^^ linkage
> sanitize BTF produced by llvm.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

