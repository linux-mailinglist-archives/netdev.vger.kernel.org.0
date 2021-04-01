Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA336350F82
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhDAGx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:53:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14842 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233465AbhDAGx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 02:53:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1316igHO007172;
        Wed, 31 Mar 2021 23:52:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ARqPPUogQV4LhwO8dx9z2cqEmFqA35SEKzLDqYYuYt0=;
 b=F9EflcnPypnu0nKywYZ9Q38VxYwWZ5KoKnmNK0c9O4UwmQL65vZx3JP0WDC4mTTtyeM8
 /4mzLfDf7iakbUBwJUQsDQJlvZZTS2lce6No+MhVmDXU/eqPbUEm7Nn/1zherc4VYIV2
 vrK0LJnTFEs+BEYHIhD+//c0WfO0OGSRdN0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37n28mhrf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Mar 2021 23:52:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 31 Mar 2021 23:52:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fy/MYHiWYBkuaHvGLuDB7qMT9Jlo5M1GEj+DiQoPfnmgG9lBKJGKApUdORdTqG9QWhVt5aPfS0NiqAPfwdFrk75m9MAyYrvU6lXp7L1V++DdCGCjecRvoNiOsOE0M53uZnbk0oPwNi97U0GeX/2owU28tHyk5L4bzisvAyhw3RYmlmn1cnH2WrGGtn7MZjg8bOkGH8dPAbYlu5gkauNsZHX7o3WNPlJH7eTP5Hx5wTVTYmwLQrQnQDTaYn4BEs9GhG6UnWeRlZGB/ihhctcFH6W3XKc0p95AkD57vi2XKWOtGuz1PGDaSu9GcHIgarYPivR0R0+IRSuzq60rqZ28QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARqPPUogQV4LhwO8dx9z2cqEmFqA35SEKzLDqYYuYt0=;
 b=kFsZ91yadzX7Lq8wxNPssuAuOzCZ6c2Wyuw9wtE34z5V+vsA558gx3aFT47T6WwVv95LaiQ7ckSmXT/HpS/IPK/VO6tTwy8y9cw2K5hr8QOsWRIFZpZ1QzBeWDJxEg+X28dJgt4O+7EQ/WW4piCQCbmL856YaS1UpwGMPCU53kLZ0QummBt5F3Xl17x0zw+5rWhJM850TFiWHygCa3rc7CtGattEajcJaoHVQAvptkYkPpAdzjSt7hcxO6Zeto7Uq9rBnSXYjA3nUW4g4arSDKlj084dRyVZERUQ1bDrOfCzi3SU948cKocAe7QIpLKvCZZEY44crCexqEJ/3v3y3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4757.namprd15.prod.outlook.com (2603:10b6:a03:37a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 06:52:50 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Thu, 1 Apr 2021
 06:52:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        "kael_w@yeah.net" <kael_w@yeah.net>
Subject: Re: [PATCH] linux/bpf-cgroup.h: Delete repeated struct declaration
Thread-Topic: [PATCH] linux/bpf-cgroup.h: Delete repeated struct declaration
Thread-Index: AQHXJsLshGmKwxP9CE6yRsi0BsnmGqqfOb0A
Date:   Thu, 1 Apr 2021 06:52:50 +0000
Message-ID: <F8591253-0CD3-418F-A1DA-58E10BBA23D5@fb.com>
References: <20210401064637.993327-1-wanjiabing@vivo.com>
In-Reply-To: <20210401064637.993327-1-wanjiabing@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: vivo.com; dkim=none (message not signed)
 header.d=none;vivo.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:7a9f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12914a06-c52c-43d5-4755-08d8f4dac479
x-ms-traffictypediagnostic: SJ0PR15MB4757:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4757DD46D9463672AF7AF6C0B37B9@SJ0PR15MB4757.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 06qiOp5BLFR8WJNHO6z2AoO+3wnFNTbbwem9dfxEaofdWVc0qpf5d98Go0SU4A8isnrh6q07jRPajDBgbVhf0duGBAwyioS9y/SNqsmEYdA8zwW7NxME1Vx1g4T3L/6RxHDa6/8mUHcY6xIJjC/lf7XS56XMiYGWvcfcXBoYuF07p24ZoEtGJxGLpxgVhjExaOm4fNTMFS72HT8Wn82QDL+AVZVL174rXX0uFLuyNR++SKYDS9TnMKo9zv1EUOGkoch7USOpOdvMoGQYTnzZiuD9gTXQ3C6dNwn8s4f1t0jXwMudUGuvA7FuSQnuMUxwo/CdUVT7klKcdrABrxfdgdChFbE00lvI+jHT1h+Ih7mYD48P0ItHDphAqJp7R0ptZdhqNAXb43ode2eg1WCrRaTEX+4eRuA//Ead9pJhbUKdhGHBtOCeyoKJBbLZCvYTD62JxU5GJAQl+tQbEzmHCKLD4lAEEdWCMEd8sIt9PQhSPUzLxZJIvtR+ywWBvI8tkY9WGB9xR4h8n/B4EF+ySActnnPbYATImWAKmvc0mpxNqYSdncroy7qEGCCyjFxU1o/2618HmMgqPuFNVxP9HEvQfWXSQfjuyvrMSXJKn+LbpXVA9HYiZw9gA+TcY7d/thspbOFeikPZXOf3VPXgCBknOE2bc40Tx1Gebx2wdiAroCkvUHdy67WLS8zKBMbU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(71200400001)(54906003)(8676002)(38100700001)(76116006)(33656002)(316002)(36756003)(6486002)(7416002)(186003)(2906002)(2616005)(66946007)(4744005)(64756008)(6916009)(8936002)(66476007)(66446008)(478600001)(66556008)(5660300002)(4326008)(86362001)(53546011)(6506007)(6512007)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?b9PddLSUSZ3hlYHVU/i/AMlpeHL+xMgQNhbiLFpI1iw060gfDtib28Me/evZ?=
 =?us-ascii?Q?1MG2e02tGJF/HaxVAacba58NyGCC222mK36R5SO7TPj+LAKX7jTDnRLGPZGw?=
 =?us-ascii?Q?nH9EYhZjiVQe28xJW8G0MgAKr0uRB7aAyN4LfCJgnpNTmfErnw/GkyQcdHNB?=
 =?us-ascii?Q?VdxEX6Ci+5rHA4snHU+HbvY2hhApTxyTe1/FyikVcKAIfCM8nG34USXB3yKj?=
 =?us-ascii?Q?JwYuE4Z8WdtoIuvndVuDB+DVbQi8h1YwvPkpLycI0D67ZlYaZudvACPTD8BZ?=
 =?us-ascii?Q?AjYK1Sv92uuojcvowLwRX6vnrWT9AyQMQ0BBZvxHqEzC4wxHSybizH1ZxbBa?=
 =?us-ascii?Q?3dNl2quHKkH1gnhIzyt1en0mPedr3RufWqDLEY9GHdoC4CynsxEO+ow3kUQk?=
 =?us-ascii?Q?on5v6itbcUIMRLTPPq0KM+tQ6ObLqgNuj9C7ulCBNY3Bq+KgeswnA7iDAzij?=
 =?us-ascii?Q?nCHG09Jjl826TxwQegMIT9PzyaPvQoMtYaHbELHIgCIcZ9/zKC0vBsNiz7kv?=
 =?us-ascii?Q?6UBHx02Mtq54fcbBFirCTMfRYeUuetXijQoRrE5FM7k02VwMlyLuvkP3IOdj?=
 =?us-ascii?Q?/sVwhCxzlqIhYWK/ecuk84Z61gku45wIM0uXtGQGLk714pmGgG8afVcV5a/t?=
 =?us-ascii?Q?OrNnG6DyiU6ODbHSa/ab6eQDdYKm6ZY6rg4XvAm1qfrILopZ5M3Vvsit443b?=
 =?us-ascii?Q?QhHzXP/8lpmYn4WH4QFmKzbtd/NGZPp5+rSxdj15EX5q0lE8zN5MghwYfQOD?=
 =?us-ascii?Q?K7UTNG9QxZUFLltEGRr3BqQU2qVnpip2koIIfBJwFSGzK0maMNQJ2cx+sMw/?=
 =?us-ascii?Q?HsMjRfrDBGHRiyXB20c5ywQeTEHWDuC77pdC03RLfJ7ePxB9mPQjhN+cWey4?=
 =?us-ascii?Q?EyRGKfBCCxXOrWuB449dSM3MHLqbrTKbqO6CsnZLDf0QH51QaMipVvoQUr6T?=
 =?us-ascii?Q?AD1at+90X+CP/Bs6PMhTNaI6290Y8Sm9OzCjxDvbOPZZKoA/Navp9yK8NNUa?=
 =?us-ascii?Q?MEFFSEbU9o8hTOUKg35Np9jm6bgW38zP5sQ9FDnGL2Y1BpGMjCNhmQum/AQo?=
 =?us-ascii?Q?i5QVGxaly+LSk6NHDfFPjrVqEchCmeFIPqHpGmYRWKwhBjGW+kXstTvafkcq?=
 =?us-ascii?Q?U9N7deflECBeJpMriSvPkSjRB9efSvvCnl1r+VA1NCHxaIRvoKJjgkGa87Rr?=
 =?us-ascii?Q?A64LH3SWQYKnhz5RYgjl5fu9r0CZ2nvwh3c6GHuQlsQCbt+UWvGASAS86Og0?=
 =?us-ascii?Q?nMYdzWN2G3f7k7NUE0J3RroXhE8v8KLXkfjAD6d3QQ2MSgFrMQ1v72DOOvh+?=
 =?us-ascii?Q?TdkmjV0DsBOFo3EGyB5nkX/hcIJok7vB0ljl2+jWIG9Le1DypzSmCsLGvyWn?=
 =?us-ascii?Q?yobGQos=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19533660CB036443B5CE15F5C0AA7AD0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12914a06-c52c-43d5-4755-08d8f4dac479
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2021 06:52:50.7616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNzkafjctBbnjqv647m/BEpu9Eo/BD8hB3hwdQFG7cStZ/ahcyBh/P0vLFjd9+vQPme4TIB+AQ5SFrL/gHDJEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4757
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 7_Qp_UZQNrYXsgAH7ku6rZ1L-gDP7NoI
X-Proofpoint-GUID: 7_Qp_UZQNrYXsgAH7ku6rZ1L-gDP7NoI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_03:2021-03-31,2021-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104010047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 31, 2021, at 11:46 PM, Wan Jiabing <wanjiabing@vivo.com> wrote:
>=20
> struct bpf_prog is declared twice. There is one declaration
> which is independent on the MACRO at 18th line.
> So the below one is not needed though. Remove the duplicate.
>=20
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> include/linux/bpf-cgroup.h | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index c42e02b4d84b..57b4d4b980e7 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -418,7 +418,6 @@ int cgroup_bpf_prog_query(const union bpf_attr *attr,
> 			  union bpf_attr __user *uattr);
> #else
>=20
> -struct bpf_prog;
> struct cgroup_bpf {};
> static inline int cgroup_bpf_inherit(struct cgroup *cgrp) { return 0; }
> static inline void cgroup_bpf_offline(struct cgroup *cgrp) {}
> --=20
> 2.25.1
>=20

