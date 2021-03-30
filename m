Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E6E34E160
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 08:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhC3GlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 02:41:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47822 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230463AbhC3GlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 02:41:08 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12U6buk3009716;
        Mon, 29 Mar 2021 23:40:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+iBxQvkVm0N+/M/FQY5FHQEJq4WNOOCN3SRMXfqbREY=;
 b=PI3fdnBAVPayRtH0pAsl8oCgqi9jaFCtY4DFn+4ICA9fu4GOgOoaUKoc/qlgn3ev+N8m
 rkx3p9bLj5dCaFEK5ztcliNbzSs8Nnp1tgZY0L3DipUGI7McgOaaFhxIiHjaliGulJ4Q
 YQzkkrXzZPZg78NvidT4hRpr2HQSSDYI9Zo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37kdyt5kh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 23:40:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:40:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kt2D/QlsTNFk3Kk7YwH+0DDBQLieJgYQcbucizwkt7HIetfOXJlsORngRT9eP1Xd1eA177ZN5jn12XPlYOq2dObWF+dTA7EIdC3cBgnOtny2TtibYb5awS0TpvJ8gVAxQfRcLxANAwQbi8eiEJvJ+2rn+Vg6wp8oWLFJ4DEbM9ToYzSqUcswJIm+PhAlXM9dbFTUG3safOfSw3ZoMvB2fd7VFYmR/WIWOGcbCKJ91YLZpRP6nWf6Mst+kPIFnfQ9Huzr/YmHRfLP+SygSgdJKWkqwUaonZfiKTWXSsAl+/JjoEF/+dog1SZiY0brmtGf+AVaK6ADLsG6G5Xhlq/KxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iBxQvkVm0N+/M/FQY5FHQEJq4WNOOCN3SRMXfqbREY=;
 b=mvfGHwZgFL4dLbjTKqiMOP/H09i1QMFpvAdm6B50jyDKlg4X80tVicdDLwdbJwYayNK3VN7cvoGlNpXrMrhBORc/GS5MnizqcXEGXqIqoAv8cW03kBmgKVhjnpQJLJ6G56YdqYjYCoSPie+NPtcO6EtfsUIiFJBsDs23RdxPDPsNYb1Dg3HDzpZQQUA8TAlA7Y9S7mugGP8pqBM9U519NCBZ8kMmeKH8R/pNRT+ulHuj3N9ZrzxMB5WKqZmhl1c+8hN1ZF3MtP8efEBSmiy2X3/JtHX0YTQY2binb2t1nmVwnVwcHzRf2McG8WAVxDUbuZqhzV7eNlY+dkiv2xbuJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4679.namprd15.prod.outlook.com (2603:10b6:a03:37c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 30 Mar
 2021 06:40:50 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 06:40:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] bpf: selftests: Update clang requirement in
 README.rst for testing kfunc call
Thread-Topic: [PATCH bpf-next 2/2] bpf: selftests: Update clang requirement in
 README.rst for testing kfunc call
Thread-Index: AQHXJSd1RbVPCLC45Ey0mqMO4tacj6qcFPAA
Date:   Tue, 30 Mar 2021 06:40:50 +0000
Message-ID: <CFEABAE1-DDE3-4679-AED7-B04FC0D34784@fb.com>
References: <20210330054143.2932947-1-kafai@fb.com>
 <20210330054156.2933804-1-kafai@fb.com>
In-Reply-To: <20210330054156.2933804-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
x-originating-ip: [2620:10d:c090:400::5:6e51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5760361-53eb-43b8-390f-08d8f346c272
x-ms-traffictypediagnostic: SJ0PR15MB4679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4679384BAA11959BF3B06D16B37D9@SJ0PR15MB4679.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gjK7pK+5KhV7DpamRjshrxmXWOlF1ZZWTSQvffYqPY6v3VuX7VZsOSRvMotlyjSyCiXP322FuqqMykgtcWEFCnz2jecb3OSP3Pxk2g6XHh7p52CPWsn0ODQviiVbgW28C3Ouybxc3dG2qxZBAEWD5T9pqE0mRfi9DtEtpI+RPRjjTryv+EAnLpmTvGEfh7WxwBNli7eeVf6vA4Mzhl3bqO7fkEeIDYKEVWBtX40ZeAIAM0EKKiVIC61lDcIpc8CJE30zDuJRd8wmC+cn5OtRaDqH+LnjzTKoX8BKdZMzg8uTLc0K8TuIyAAsUyd1wc0sA1SA1n8nuAIrNLKgkjmN2o3BwlE5HapQKCVmIe2qqolvu+qoJ5U980vJ+FV5aNsFn/MaQtw30n+DEq4nkXJOqrqLly8ZNaipwwat8vIOzr9Bfrw2kEYCcaBtWro2OM+UFk7YqXAnUYvY7uZPxjOV36M2AVjXpp95znuxZwIPQZTVlp0T5Av78nkjPpFxUeph3JvC6syo+efO3KkrthuSkVUgepaVPcG/tlpIRzqv3t338P16QquT0TdZG2uDbok2Ce1kcpvuQukZl4x6DHBSqIr+UAVlkXqB5e5Nb7KYktvSVlDpIVk17e4QThBLRINQIyDe83bIwpbtzkiuOdhmBuz6XXXqnkJN95tr7ST4IDnKfudIaj09sl4wmm7ZyAUN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(396003)(376002)(8936002)(8676002)(53546011)(6486002)(91956017)(15650500001)(316002)(33656002)(76116006)(71200400001)(2616005)(66946007)(6506007)(86362001)(66556008)(54906003)(66476007)(558084003)(37006003)(64756008)(6512007)(186003)(478600001)(38100700001)(6636002)(4326008)(66446008)(5660300002)(83380400001)(2906002)(6862004)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?t+3bBGRnHzbWCTm0JBcszcB8TjpL2taKzqpdY20Ce+nXo9BARQhuZYwOGYIu?=
 =?us-ascii?Q?7JG8SQkg2ArfWU0GWyeJQEVoIKWtRMXbFlh9N744+VofRmWC5rzM1Zltuhsg?=
 =?us-ascii?Q?gO48evrhcCWHvo+BPGk3nJbTquwKuxyLpHUR7rF4yzmmCER/dhF9gWqrqTCa?=
 =?us-ascii?Q?S8JBNtPDNVEeBDhSKjT2pAm5DH/sAbRr3hQfcpbKZGk8QjYC63ZPwl2VuGN2?=
 =?us-ascii?Q?GfaIOrmDqwnLts5wpK2o1AcBKSHk4Lez5p1vunoOrftpMHFHHtI16PzvSdOW?=
 =?us-ascii?Q?MgdY7Aayc2p6Qjmb2ricVFvmxkf7l0cU6z8PaqLE4MpZGZzbXGKsz3mEyT78?=
 =?us-ascii?Q?Ryn6MHQC2ki1fjr7ZkH+eVuamUQTYFL9DAfOCPESS+aB0XQYkn1tdPS7Jfwx?=
 =?us-ascii?Q?Toy0RF8dyAOyL3124qtIL80hYGZRzQKRpd1WWbNS+JuTgbHUzcDc/iZ57eDs?=
 =?us-ascii?Q?5zRwJ1KgeWjYXlHvBWzbw/uDIvrg0NSOmLCtHHvy/yNjUDz4rxd/bGfD0GX+?=
 =?us-ascii?Q?4X2+K0e+lFOsdlnechKn+UL42n2LKjj080jj8/yoZSDsZ2BbLsTEwJSHD1Ps?=
 =?us-ascii?Q?2JJwLDrGPtBx0DQchLiwEg13R3ukA29FdLShkrVJiwdGJtwoNRSqal7W2dIi?=
 =?us-ascii?Q?KUt8vHoWoIlCBsm6F9MVHpF2hIezEM1u4Bb/V35r+dyEbJO8+JOW8IpJ93yu?=
 =?us-ascii?Q?sk0pi2Y/jvSCpIXWiTMpF8dBkHkeJsJZ+DlyO9+whOr5tn8flXsi/KH9jgLW?=
 =?us-ascii?Q?ynzKk5hlzHiC4eiSxgkfVoIZuNnEXSdb40eJ3aKdQSb3j+53zAzOGolVCazU?=
 =?us-ascii?Q?x6Ry54bHZNUclV0dNW56Yk1uKTCZaNvSeHwJMT07BGmuM+1OXTZd5DnUu7rR?=
 =?us-ascii?Q?zaQCTM9/5CCMTpXE2Lz7npzEONqgOal4tXqABnuaws+SY0NFFwSTVLJ3VfZW?=
 =?us-ascii?Q?93CgFtsFOIQ9TkWEUlGpGK1FQv1CkF7jLy3tWVFNLzdwW0OB9HqhOgKQi1SR?=
 =?us-ascii?Q?5vlDoF+mSf2y23onVWC93plEYLrCh152FZMlxgY1G+eme7TZqhgx2+Tx7T0r?=
 =?us-ascii?Q?QfC+ZaM9aYDo2FnOisDnZbjbq+YvsKu9lk4Wwrr7JOojUYHlcjsLJdCP7o0Y?=
 =?us-ascii?Q?qCi4E6Rop1XhJnpMEHCuxIIJ8hDZcUih3/toWpG9awpP+YDzZaxghcis+xrG?=
 =?us-ascii?Q?L7IU72ENlKGEMg+3bDeMFWw9zczqCLvxOx/8GiudvPnxZLf/+DEJv6YgDCis?=
 =?us-ascii?Q?t9o+QwPuxolAR16uVlvqnCWR7uc0LBwabYzTGKrc+marLNdWG4w0B/7+88oA?=
 =?us-ascii?Q?vz5l+ZC1cMxS0G966Heiisgk8gf2/fHhrpD3wYYNePPuepp3GrqsyiqwOXMT?=
 =?us-ascii?Q?BNgM1gs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2569E59A7F7AA94BA8261F8B7DA9CF02@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5760361-53eb-43b8-390f-08d8f346c272
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 06:40:50.7281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yOoKd0tslzGlStnjoYTDEfF+MaxJzfj6dl5BTMapI5hmRNQwVla+Ax2BRff02wXyTjDKQjC+ZIuhEzaaHMQO4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4679
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: cS-xxOSA8hIjLWzXUT9tCbNxPl9iTwF4
X-Proofpoint-ORIG-GUID: cS-xxOSA8hIjLWzXUT9tCbNxPl9iTwF4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_02:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 clxscore=1015 phishscore=0
 mlxlogscore=864 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103300045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 29, 2021, at 10:41 PM, Martin KaFai Lau <kafai@fb.com> wrote:
>=20
> This patch updates the README.rst to specify the clang requirement
> to compile the bpf selftests that call kernel function.
>=20
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

