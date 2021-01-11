Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498EC2F24E7
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391686AbhALAZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390777AbhAKWvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:51:11 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BMijwB023274;
        Mon, 11 Jan 2021 14:50:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zFMRE4e3YXtmxVV+kv7RMcq0Bj1T3cKBLCLEhJouEUg=;
 b=CtAL/EOiZr71Uk312QzD0vjH0Ujaf4dC4awtuLPa/C2clQtBMKBO9GTzSMGX7AZxGSB6
 IDRVBAiXL04F1U4TsEJ4l32Gu6bbviD945VVIDl10eastvIgcBmkmqdBdvB+IqvD+gr8
 jcO/WG4IdbntSl4d4kHV8+iyuH7vp3erXrk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywduqgve-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 14:50:08 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 14:50:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZLDOi5oZhVw6Nq/Fz8fjpxXa0U4Ifjgs7D6fCRZ1IeQ3TEZXJC+I3XfD3N4R9jp0pA/Ljc7boHNfJ0e5YUAGio2B/0NO61ducfBr1+lO64QhBWncnFkvI43GoGkRma9cDodykffD84SvWaNYEIXYa3MIPUnKHAhFL+2OcS4j5c2YXE2T2HCdzf8XBPGyoOKFKAI1SQ7O0x3Zz3ylMbKJGY2HZoI31M/xRZI54Fgnyillm46V6wMu/BSHfoh1AvlqpUXQh/3n6PlqXxQOT0yvqLoQAZlyHifwyzB85X5zJwYJ7SODKBR7b4OO2HNmp2LSOW/4ApNHI5zQXEI+qa+eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFMRE4e3YXtmxVV+kv7RMcq0Bj1T3cKBLCLEhJouEUg=;
 b=XpjCO+3cuMikyRxFfjkA8xoa2bRM4FT9+7F1IXD094QJGR5embxly/sk0t+Whbzvdj4SloHd07WeZzKSH7voot5FsdRum0VxzjtQd2AuK9w4Q1yBtcDhZfpPBvU2o/SAFy5pwaWDyk/0y+RP2z+d65voU9TsElmsn3FSaL/IcrY72E8KRBPShVm+Wj11NOhxUdVOm5RVfjdT3ljZI+OVefc9+b6WJ2F2rOU1GPV5AqPV5rHDEaUH8Y0T6VpsuUXsjSptSrse3KWBqIEidyZZs/hYSSO5KFtMHbd5lMDYItG+egNIKAZemBcuCM5Wf4JZlr4PM3E3uI8zYrf4940gRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFMRE4e3YXtmxVV+kv7RMcq0Bj1T3cKBLCLEhJouEUg=;
 b=jVbVE6kbHrl8EMxkKNAM5vvmkUAFjMo0ipFktcLEi754D6rOjJa+xxTUU8Pjb30ANY/eWIm6vJiSFqV7HdNyUmXt7C9gjGfIdMZgTxAPQIjmSuJFVs1OQ/cltIjroSz0maQPPfAsD8MyXUfYqJnTVKlPSnF7wXLJt3l1mRL6CEA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4204.namprd15.prod.outlook.com (2603:10b6:a03:2c8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 22:50:06 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 22:50:06 +0000
From:   Song Liu <songliubraving@fb.com>
To:     KP Singh <kpsingh@kernel.org>
CC:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <Kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for task
 local storage
Thread-Topic: [PATCH bpf-next 2/4] selftests/bpf: add non-BPF_LSM test for
 task local storage
Thread-Index: AQHW5hZK9xMR4omnHkq1KgYEe27pC6oistUAgAAD0gCAAFVhgA==
Date:   Mon, 11 Jan 2021 22:50:06 +0000
Message-ID: <9D7ECABD-4964-431E-AF33-AB34F3F35183@fb.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-3-songliubraving@fb.com>
 <4eac4156-9c81-ff4d-46f5-d45d9d575a16@fb.com>
 <CACYkzJ6y1xnR2vnbiJDOWftEsH-qnsdXYcoX+nUmvw0LD1bUAg@mail.gmail.com>
In-Reply-To: <CACYkzJ6y1xnR2vnbiJDOWftEsH-qnsdXYcoX+nUmvw0LD1bUAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:f14a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40b56f84-2795-41ac-8b3b-08d8b6833d99
x-ms-traffictypediagnostic: SJ0PR15MB4204:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB42049D1AB237C628ECDD199FB3AB0@SJ0PR15MB4204.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5CBZ20NJqAd3YZ4PWBIBbgnYwGpOx5poGcfX4jq4CIp/hNgQpwwE+WUwbxYdSsIa/O079YlqmfYFJFcBHyV8u568XBVvNsNomYP7TrhZ2I62XJjbmtWYPB5obB7l3JpZFngGgS8v19rLMsSozrPF22f5dPFxqnEcfee68FX+Pr7YoIGi9htl+YRChdxORSw915uBnZ1yVvouHxVh5CyWiK/pcZeyshu1xWAt7X064IstH5uCkEwUBiP88a31rQs7fHwJ5PHbycm7kmWxTC/6ejqXxSXoKBEYWCngowjNTzZBPdi8J1XprN/lF//WtIRvIiJHGCJjz5rio+GAAl/8LY2yqlkf3HBSgFQn6TQyxhD19pLBwNOQ3dbZiLO9O3kuLFMHK8Wv/G6yzZzBRo8pGHb0VcjHkCfZyxPZpDrUqx0agIvUFtnhs7DvtI4u/LmE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(376002)(396003)(136003)(316002)(66556008)(64756008)(71200400001)(66446008)(66476007)(76116006)(86362001)(91956017)(54906003)(6916009)(4744005)(2616005)(4326008)(186003)(5660300002)(66946007)(2906002)(6506007)(53546011)(478600001)(8676002)(6486002)(7416002)(6512007)(33656002)(8936002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KhEeAjV8jFSXbM09XsoTtp1TS25DFkMlxUmZXt7CjTC2K0tUu2XloJAJW6U1?=
 =?us-ascii?Q?2Xia3bQpa8RnqksQzunEvRXvvxxVXR/9EkrrSFE+nMObCFkuXN9LzHSE71iy?=
 =?us-ascii?Q?oncYt+fiCAoeauk9a42y8KbRmGO8WfRHIEMiiM4vIGZ8eNNP4HGpPEHSCWKz?=
 =?us-ascii?Q?9Vazvim+vWewMTDytUct1lNIabWGCJYw7SWluuhTdNq++dyS3Fkf/Jqd1E+7?=
 =?us-ascii?Q?9PFmEJWgSZ8p0XOlT2NPl1ZpMzVY0DiK0NtkFoUTbrID3Dcv6EHNvaODoTl2?=
 =?us-ascii?Q?ztwJjo9GychyIU0uPUAJrxII2Cxkcwrqa3bihzF7BR6fy1fvokK5DVIgjZ/e?=
 =?us-ascii?Q?IYsTRltBIoJrePiJgjLgmSMbqP78jxeJKaetAuKjT05LcyE5mYP6qipYEP+y?=
 =?us-ascii?Q?qanJLxhS17ITAJgDG4fSzvSqAYpinc5bGw3LwPMcIu5YDi3y4QK2ToBusEXY?=
 =?us-ascii?Q?5alw+cDyuAaLAW+gaNf87orvqHEbaAfKVanLppCfCDHVU1Lwo/uLGkfkMm0X?=
 =?us-ascii?Q?OX4jIJmGzfB2TRm2FuPIJbWaTgLRDgo8HBuh9mIC26+UAU8BEh7pSPE5YWMe?=
 =?us-ascii?Q?0HfCM3HKvgrZuYPKSCA/ylOGlRz0mgIqNDEse8FBReiJ6B2Dszo+aOb2vSe2?=
 =?us-ascii?Q?zbD7Tq1mjimQ7HA2WJCpNZE/X9hTIs7Izpw+lA7m2adoVUEm4LnuQIHQJ0I/?=
 =?us-ascii?Q?Ds007pkYjQe79qnvPgJ5toSYSNm5yI0YYdkoWealDMPNsS+hSpOoUdr1B53M?=
 =?us-ascii?Q?TpbZl2y29ddimzAg4ew1J0IvVlnRlli49gAIccEi0s9kpHrsMZ7llxLnckQY?=
 =?us-ascii?Q?PjRnrc97dxDFzA0voOBLzueyC3rYPRMaTbhd6/OAYqTqKMwPbZle/U5PoMwN?=
 =?us-ascii?Q?yiCHOCaz5XifsPAo5lilMis5jbhZzVLFPGH47G6T1+h+wW8dI80wuoKql2X/?=
 =?us-ascii?Q?5vIJVX1wTY1OByo/yD7yHhv+7YnGxkXSFrTZzsTSQ4H8Ct/jMiMS4R/FwRwB?=
 =?us-ascii?Q?QCyYFdpDDy2AzKEzTMi6RgUV3tGBPT74p5deF/JAkBHifg0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CEF0F0259E0D1B46933421FAB100B45F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b56f84-2795-41ac-8b3b-08d8b6833d99
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 22:50:06.2329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Unzp7iFC9oyoq+la704ccDA/9KbcOBgUlmGGwJiWfzrSWaNsqQk4c9O44FGmqTKeZSqOBe41x9lzmg1xpFsv1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4204
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 priorityscore=1501 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 11, 2021, at 9:44 AM, KP Singh <kpsingh@kernel.org> wrote:
>=20
> On Mon, Jan 11, 2021 at 6:31 PM Yonghong Song <yhs@fb.com> wrote:
>>=20
>>=20
>>=20
>> On 1/8/21 3:19 PM, Song Liu wrote:
>>> Task local storage is enabled for tracing programs. Add a test for it
>>> without CONFIG_BPF_LSM.
>=20
> Can you also explain what the test does in the commit log?
>=20
> It would also be nicer to have a somewhat more realistic selftest which
> represents a simple tracing + task local storage use case.

Let me try to make this more realistic.=20

Thanks,
Song

[...]

