Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE38D38A0
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 07:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfJKFPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 01:15:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33954 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbfJKFPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 01:15:38 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9B5FNMN002972;
        Thu, 10 Oct 2019 22:15:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MTVhGVSrY4Dacj3mSYYh/yAGE3BpS+OZYTCuvQrIApE=;
 b=VKm4yRmI9gydugGRVtytzE8mMkVE3PvCOmyDFdwyJdsjkgQPIGvkbMIA7ZaWzwg76glG
 z81ZiBR5IhMovO8T64ew6YBJ0Y0ueCoBnQBuZjmTBt/ztfTruPK1RXSKNAGhUfG3u7Ov
 z4ckJeEff5yuAm+tbyW9qf/DGDsLWJ03KP0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vj65fbw7c-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Oct 2019 22:15:25 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Oct 2019 22:15:13 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Oct 2019 22:15:12 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 10 Oct 2019 22:15:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l40pHgA/pFwU1PXekKolcLtDfowO5lVGttuKeYzxdrEj6bFiD4Aav/w7xnT2drnN5Eg1EN6gn2yBXS8lXGwrvk1zHHHsgDRZ7qdldL9w2kprouJaXgdkCj9q9mlGx/zSn9jDjqVo+v1Dw5RE5/8506qG7GRtxNvblg29YskCMplZky2PShj9rHlZsGb5fJ7ohRmV5gQpvkU9crfkVGMU3iR9wpZLSTy7q6DzQ9M+/OrxQm4RCEwEFvxAgE49EeLaa3x4tjMAsCDyQu+nNj6aN9GMEh3QoZlTXXMb23CBHb6uu1PFZISSxRESoeeIlJCL0t4m/pH/iOdTscKMBMkz/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTVhGVSrY4Dacj3mSYYh/yAGE3BpS+OZYTCuvQrIApE=;
 b=Ni8O4Qs9nZeWQEkath3Kao6rJLsMNrhH+zP5avMQJF15IvmRlU3YxGKX04+Z7vB7JonUNGqadh2ZHAsxpde4bhQl73wSP+oBrghiHrjxI4roglUza+0ClEzMldnscznyFu8lOmNZcFneMoO7tO8+eryKUK3dJC3lf90uKiB0KzXye4ziUb3gG5TNk4sWRTNAmHV2kSGCOnZ7D70qHC3b+Hp2Xf/dq6mGmaim9lwdRFGUn6vUaj9NAjPrNaT0agIp/TdzHhP0+RQK68BtnhKmRP5zOra9cJKIF6s9wPYwCABENpRfUe3Vuv+TdadbRzU2bW+w83omTkYeIZHirNsdQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTVhGVSrY4Dacj3mSYYh/yAGE3BpS+OZYTCuvQrIApE=;
 b=gaRDBhzSlCMAJRYS75LlD5wI3yJXm2EfLsgLNrRKOjlSgFWOzO+KHRGzCVWqljPX7XZJ8xUBdqhsuza0LG/6ypipD0ciI3ep68GFj6k3gpihpCnEKdARB8soI9pvcok4n/feG1YshKf44P4bTgq6tNncG3PuA/W+IQxJqG82iF4=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2781.namprd15.prod.outlook.com (20.179.144.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Fri, 11 Oct 2019 05:15:12 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 05:15:12 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [Potential Spoof] [PATCH bpf-next] bpf: fix cast to pointer from
 integer of different size warning
Thread-Topic: [Potential Spoof] [PATCH bpf-next] bpf: fix cast to pointer from
 integer of different size warning
Thread-Index: AQHVf+yPhHfGo6/zZE201kBAh+qI06dU5diA
Date:   Fri, 11 Oct 2019 05:15:11 +0000
Message-ID: <20191011051507.akhuheqjizpfq7xx@kafai-mbp.dhcp.thefacebook.com>
References: <20191011042925.731290-1-andriin@fb.com>
In-Reply-To: <20191011042925.731290-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0021.namprd10.prod.outlook.com (2603:10b6:301::31)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::daf2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3627f50b-5f41-41b5-9c74-08d74e09fde1
x-ms-traffictypediagnostic: MN2PR15MB2781:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2781EAC928162F5A5002CAE0D5970@MN2PR15MB2781.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(376002)(346002)(136003)(189003)(199004)(81156014)(8936002)(4744005)(6246003)(8676002)(81166006)(1076003)(71200400001)(71190400001)(9686003)(6512007)(446003)(54906003)(46003)(229853002)(186003)(6486002)(476003)(486006)(11346002)(14454004)(52116002)(99286004)(66556008)(6506007)(102836004)(478600001)(6436002)(256004)(316002)(25786009)(66946007)(6116002)(14444005)(7736002)(6862004)(305945005)(76176011)(386003)(2906002)(86362001)(66446008)(66476007)(4326008)(64756008)(5660300002)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2781;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Bs8gneRaXfCadJWabxGK4EwhlpG7ZtNHtGB8HnXj3PtXGKYMenyIl2YuUa1RqUGMGyOT7qmJMk8ue5N/G8n2e/xPbHBxDGBOGrAAJhtKSz42yh93U1Ag7Hdzz0xsano1Ia3RdhUE7ljzm7BE/q0WN1PkTKJxMcKv4rNpsE3vaw87M1jDhM/NmjyPIWZ5X/dwIik+7meLUfKhzfv4LR3V9PGU4jHEzVlzG3HjB73d9elwa3mT9EsPBQIOO+BgQgMOaduerOas7ci4D7VxKQOTg56C7ahqQ501wVGTODIEe74vrFL3VUs0b9q7ueH4ZWKHDptOlaMBvsV6PfE1/j9MFgOsJRwcE5mmTbqKc9A49yNGHu6ev9keI1BBDGA9abbD8hB8vbiQDNyssijBEiRJ1XSxUGhSU3Krkq6hpD7n0w=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3EFA54B64CE32649A0EBABC2B0AFFE2B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3627f50b-5f41-41b5-9c74-08d74e09fde1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 05:15:11.9816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qwx51yXA3JfOWpnCKv7SiUDrywBQN/KKqcSdYBghok0QLow7tobHMGWOPFRebXaC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2781
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_03:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=717 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 09:29:25PM -0700, Andrii Nakryiko wrote:
> Fix "warning: cast to pointer from integer of different size" when
> casting u64 addr to void *.
>=20
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")

Acked-by: Martin KaFai Lau <kafai@fb.com>
