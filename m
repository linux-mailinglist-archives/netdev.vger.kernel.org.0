Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DAF350F23
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhDAGjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:39:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3978 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232565AbhDAGit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 02:38:49 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1316OJgY011033;
        Wed, 31 Mar 2021 23:38:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=69WZwS9nCfEIDm9oy1sv4OTVvXJ0H5QvFXkSnqAOxyw=;
 b=Qryothgfb6r7lQJeZZst1j6gYGPIEv66mlK9Mitf7nA6bLKUpIuH7ZaihPN5P4uMow2n
 ucK8JDT3i5UBSsU/uGEl6+b7HHJmJeZpfW7AviIVR7qfQXBkLMMGd/P5kNbekoHA1AwT
 z10FJfL62hIwiIr2NjXJyXgEzxnYmqnFz3Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37n2a21r2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Mar 2021 23:38:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 31 Mar 2021 23:38:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcGa+vBNgEpEirQgcpyO9wMnIJUxUXRsICeKqPdnsh2hlEz1q0Ts6yoy6Q9L3zAl/sX+uhE5EffZa290A9vpydL5Ayajc1ANLxGLkuuwpzvCKbXBCSzh+blZExUab6AVnO1yI517yugJOawyFlKIQVleCoPiRTm1nHGgfN0Y+ikGOuLrWK3+ZcPdeO4Ce9bLWP9EyTnnVHLTvMXvZdXvfu1zhzFETuodYbmM6+G76yCiddoyQ0Z1gofgNkFa7v/ulEj1BgueTf8YfP9kxBuH7nNerDBNjGbMqVRlsf5LGB+HuBhtFNNzn7DVV3P5AHTKaxTeZoEYf62dfQeNocNlzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69WZwS9nCfEIDm9oy1sv4OTVvXJ0H5QvFXkSnqAOxyw=;
 b=nDKOcn7r2iOOtfflHIXfdkrsBEZykrIfQosfpTT0OcLX7szUoNGlNTYktix7xmLa2v7HY1QskczBHFKzYURwXSch5GUmKwfGYtp/jWmkHMBBVPtqgFm2ggNZKBCN/onz5rJFdGggtPNNSdHS1RE/h3bawBOZb1I7AqE7MKY9DT6rG6S8cJDy6Pl7nO9dUQy4cueA+7sw52DuWuiRzPnj4HXN1oinE1d4o8CcoPoDzkj0WYS7YCDy0pgTkWGGuGklrMvh6CzvIBKt719mrd02TM1F6zA7NldRo4ILCD2a4PibBieqVYAmMm/dAbmZ6CDvK73PegYygI0sXLRfux9sNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4744.namprd15.prod.outlook.com (2603:10b6:a03:37d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 1 Apr
 2021 06:38:33 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Thu, 1 Apr 2021
 06:38:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Cong Wang" <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
Thread-Topic: [RFC Patch bpf-next] bpf: introduce bpf timer
Thread-Index: AQHXJq9GCj74A7YdlUumCh5fgR8tjaqfNeUA
Date:   Thu, 1 Apr 2021 06:38:33 +0000
Message-ID: <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:7a9f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1dd124c1-9541-4c1e-f3f7-08d8f4d8c54d
x-ms-traffictypediagnostic: SJ0PR15MB4744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4744D823FF67A6F71EED5A1FB37B9@SJ0PR15MB4744.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C6CEodPwwgNpfzi/pOwXUBT5YO8ft/Iy3WxscDZDGmHuFYNIIaJfddB00kfBOul0elXYwRX2R3h+4jAvaGehOZ2yAWT+UU52ATbLUG9MnDyw5vx93yHGK260SseUIYp2S+pLomwGMsGCDnafOzG8A5ZpE1mKeuxGYDImBsIy1IborW0NWkOGpbUKUgUOITlz/zvF6zmGKxjMQGK+FLAKA7uWztwkIajNSoj2J8iFpTz/GF+8ntsrhS3NfUHrqy9ZNIigMaN5sGBNBwG4g2baBWruDdSmEw3aOlwwVQRWmvi0ivHTzRS218bOEBQXX9odo1AJdSOJZkdXNBc+dMibOggw5AXa+OmhPFqvmF+ULbXeeWb9CxD90Tl9wepzAIr7Yy7Z4rROPY6oCakagGJm79tNjtUiCXEtDYw1H1U9WNxPksRxbl0tunf+DW8c1TBLQ42AZJPExeA48bNJfXUWtVx07jU4nTQ9c0TMvxKwCnvk8hTGwrRWwqqKd2jQXA3BV6xqAuVUocRO3UWHFcNNOx41i8HbRVlmD2pEfGW5/75U82+D5IXhZoe9uFvtpYMFYWtm/gC6Oj6hl7ocUkfgrpZsSjHSydhdgEZ0w6uN72wIy6AhR39RjwyS75XfRWxz+5hMdMdMjgqv6vjEFkT9zw/KS8Vzm8PtitSQe/LRvk2cnqCuOn+BBDbylDJ26JrR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(39860400002)(396003)(6506007)(186003)(8936002)(6486002)(4326008)(91956017)(53546011)(8676002)(6916009)(33656002)(316002)(2616005)(38100700001)(7416002)(66446008)(66946007)(66476007)(64756008)(83380400001)(76116006)(36756003)(478600001)(54906003)(2906002)(6512007)(5660300002)(71200400001)(86362001)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BWUuyyozFIjxweoBBl8czX64KZtk0YehmNmdS61stfRe2wZkFwnOru//frab?=
 =?us-ascii?Q?5xhN71nQKP0ARhZCnxFrqvR2THTLyDmTDjpHWYJ0UmLxFTtZU4rlSgRioOGj?=
 =?us-ascii?Q?IKHIwIOoLoQkvcjWGQDCB//XQPL21Y9z7cyZzmfvH36Mo3ZK0XxuAMeOrA9E?=
 =?us-ascii?Q?bBnd1BQLDlEies1EIQDnYBCgikfgifNEV26ZICO1fuhjK3+sobusMHKwFYHC?=
 =?us-ascii?Q?QWZiV08rHai4ferXzL8ZB+uFx+9hVSvHQcTZw1NOCN3v9VDx/ayME5YDn6zt?=
 =?us-ascii?Q?Tq+M6hJeAtIoH01YH3bba1uvkq4oO1UMaa00b+zB/rjqgq2omf3l66Y8jJpX?=
 =?us-ascii?Q?LUimHxYXqJRvPAtgAJDN+XWqNy1xxdJrbUvCpjHysvOtkU0bVpz7gizS0M5x?=
 =?us-ascii?Q?/DE7wc98LIc6nGVOhCmzpriidQhmW6jNMf3MMyBatp5TH0ODWPJRIBZ3kR33?=
 =?us-ascii?Q?JrLZtlPKRObPZzIOr+SNC9P5Mb8+FNqTmyLY2QY5gfVtJIytGKiTlPE8ffqI?=
 =?us-ascii?Q?PSQfwJW4UZS9jRxRo8lrUZmCiItZ5MbD9uot2tkgzTXNztmvdasKlp7sMUMn?=
 =?us-ascii?Q?vBacynJfvpL1WMzVG2nkCC0CkLXMEbI9cD/MPWXOp1UlfxHcu+2CIBOpyhnV?=
 =?us-ascii?Q?KUPH9tEuJhLAjLVkoC/MWkHK3Ple108MfXRPA7EoqENRtbS/BbYReA/RuzjJ?=
 =?us-ascii?Q?lcJZUe+JYZQdh7vbhP5ljH7Ju96VfPNX33sjbErEwPYmuE45/a9CLQ1mZYb6?=
 =?us-ascii?Q?xeBJbiVIHkh9BXFRPnkBSGeskzHH8CK0PQ9WS5eFhep999PqBSZOAy5SvONI?=
 =?us-ascii?Q?yUoaJJCOWQGoZLczH2bg69hbJVgXOD3yNqxnShV4592KchezZYCmRBdhdHjq?=
 =?us-ascii?Q?ueYoDUrHmclIjXiHgUYwLo5V7ROwPM+SyZ54rRPrMTw5gYCPxFnHIjiBnuF8?=
 =?us-ascii?Q?vA+OInGS8SJkeeQSJOgyOaD8ufmI26PAp4jbxfMChMfYUtMuXRmO8bPw74ie?=
 =?us-ascii?Q?Ch/DTqJ/SkmpCUxAkOz6qMTfK5pJQI3XR+VS8etrb765HZoY3pFXXDfgKx0p?=
 =?us-ascii?Q?T6evmq/OLMfMG5TRK/RyKwYC9heDSeEnL8pryIfQtsgiI689fMHBw5J0ZqJv?=
 =?us-ascii?Q?3tqrmdrbhq4PNXx+7b0mnAFEv/HQfak/kjS+5FKCIxw5GpEhA9rsfa2/X5C/?=
 =?us-ascii?Q?Yj+XTub4g9cegPzy3GGrbpaMbGXOId6LPMtMdk5ZCgPCLe4RascpUT0/q1Ky?=
 =?us-ascii?Q?23eXlOdJX31jQAB/seSNaxUV5aXe/p9r/eBrTx5kccsSCo8UcfgyuULXpSWc?=
 =?us-ascii?Q?8yWbI42eC+1CBFyulwYpKIkY3LpPZLxm+uU/f8sUOfZI23/s4T1ek4W4RRtU?=
 =?us-ascii?Q?gSdygfM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3839A364BF2865468C2AA31C9956A32E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd124c1-9541-4c1e-f3f7-08d8f4d8c54d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2021 06:38:33.1769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v76hz4QfiYsSxDVoXfOTmgRbjya2yUKF35daRqw18t6AXRSlaOJh+wDqFAhTm3hdWLhsvzwBZ9jIfYmp39i2vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4744
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: kG6Z-aft2uivqJuWJXcjPDMm8bnZmZyW
X-Proofpoint-ORIG-GUID: kG6Z-aft2uivqJuWJXcjPDMm8bnZmZyW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_02:2021-03-31,2021-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1011 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104010046
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> From: Cong Wang <cong.wang@bytedance.com>
>=20
> (This patch is still in early stage and obviously incomplete. I am sendin=
g
> it out to get some high-level feedbacks. Please kindly ignore any coding
> details for now and focus on the design.)

Could you please explain the use case of the timer? Is it the same as=20
earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?=20

Assuming that is the case, I guess the use case is to assign an expire=20
time for each element in a hash map; and periodically remove expired=20
element from the map.=20

If this is still correct, my next question is: how does this compare
against a user space timer? Will the user space timer be too slow?

>=20
> This patch introduces a bpf timer map and a syscall to create bpf timer
> from user-space.
>=20
> The reason why we have to use a map is because the lifetime of a timer,
> without a map, we have to delete the timer before exiting the eBPF progra=
m,
> this would significately limit its use cases. With a map, the timer can
> stay as long as the map itself and can be actually updated via map update
> API's too, where the key is the timer ID and the value is the timer expir=
e
> timer.
>=20
> Timer creation is not easy either. In order to prevent users creating a
> timer but not adding it to a map, we have to enforce this in the API whic=
h
> takes a map parameter and adds the new timer into the map in one shot.

I think we don't have to address "creating a timer but not adding it to a m=
ap"=20
problem in the kernel. If the user forgot it, the user should debug it.=20

Thanks,
Song

[...]=
