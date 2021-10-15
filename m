Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706C842E95F
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 08:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhJOGxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 02:53:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58606 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235747AbhJOGxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 02:53:09 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19F6YciN021488;
        Thu, 14 Oct 2021 23:51:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4ItC6/4rZvPaq6NdPMlE3cbJik/VaZJVTi5s4AZos5U=;
 b=dI8PipOXdO6ko6Wm3gl1/xnkpBUPgF3hvTC0trPvs/1Oa5y9vLG2tuBd86u7J1G8z3/N
 O0GKeFfMhwYgPIsLKrqRcj0cfqzSB4ky7IT9xm9/t6H7Qn8s7r/8ALIV3B7SJr1za2g8
 cJTP2wDyQSFqm6b1rIkhjwzFW6IGWN+tlwc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bq46ur484-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Oct 2021 23:51:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 23:51:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRY+ys1i5XbbpFUY8BnpekIGqpZePMDsYrDO6VWO5gkUU/hCpca+k1xQIH/E9T9qbcdL1XVO+bOrd4N/KOJiPPv0oY7N01Uhw5dcE69aEe7mtOCadXguHZ+lGDuxnX22eO+wPIjwHVJ7PGlOPB3p+StsH5QYsZqlyfueOWsIuU+v0LxkXh+0MFc8t4/Bas2cughxV9/cbbLhRBkJSNprEAcqZmasuf6V8IqCPBPBwg7562t/4uVeuVMacsIWH1p92CdtKKSsILqq2+9B0LdBSbwEScPQjXsXRV8Wlw8R/8X7b/JWNNabvodmBrvKoUEjLfKcKcYJj11MZgZZKavaEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ItC6/4rZvPaq6NdPMlE3cbJik/VaZJVTi5s4AZos5U=;
 b=Oc3X4WiZRoNHlJT1StlOjy0mndl52Aa6zsH/oEXfV4T4MScdBmU9P+7O+36w5h7Vx+Zy1UsABHWrNeBzqjgSvlKpVYbr9YeVzhSfQMIgTluYrbyDZA3PsfMu2cmF173U7a7udoZ2YsGDXLBZjlICKmcT2Ze3fvz3UTK5ZU30b8iEfDzlvuwfs7avm27kue8RX9xMToF/iZJVQDO88sn8/7FDyS7PCyon7VS/vXB1VPbaz28BiOrff4tNeYFhYbwpyGF1KvzSsRMeajD45Hjig08iA68UGOAcnDW+DNwDENjv/ssSxNwBfOKegpBTubGpcqM6w2R+60lqf2DuWb55Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5064.namprd15.prod.outlook.com (2603:10b6:806:1df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 06:51:01 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 06:51:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 2/8] libbpf: Add typeless ksym support to
 gen_loader
Thread-Topic: [PATCH bpf-next v3 2/8] libbpf: Add typeless ksym support to
 gen_loader
Thread-Index: AQHXwT4J9rgUxUs9s0yxDtQyrldAgKvTn4mA
Date:   Fri, 15 Oct 2021 06:51:00 +0000
Message-ID: <EADA8A00-6CAC-48B9-BB15-24E121D21BD3@fb.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
 <20211014205644.1837280-3-memxor@gmail.com>
In-Reply-To: <20211014205644.1837280-3-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea46d0c2-0bad-4b8e-71ab-08d98fa8262e
x-ms-traffictypediagnostic: SA1PR15MB5064:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5064E2010836E57F665C8BFCB3B99@SA1PR15MB5064.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 99NuXK01AYAIZSCr4DpWj8+xedFykg56lY37uvmn6CRfOB4PnfRrr96XQrkYElHTc4KhbAq5mcDlBPfi9DeBKEaoGyDa3eLOWBEIpajAVMTPXTk6AjmuxOqDEQIuvclSVANodxie2vd+WXK6Dy/Bi6nf4xuEdkddWu9CquzqhTPBVbovvh871XOQMf4zps0PjGvT7LzunG7QQq1RZIKMHmLq/xcULG9WL1TWXZ7dtrKrUDeWGvuYZ1zvXdM3b8DTzOQbDOIeytRZAWjwI/sJDXf10D5ASeFJywuYHcAoOFcp5Ob5Zd/1m/hNAvtnfJ19AwaJ8giBZOHwu1JHkiX1zqzhN3Qt93jzgSScvQeaxJMXOxzRBS/i9s+VqX5bP0mSY/U4SBR6jz9p3Ca3ZEl8Fen9pksIl9lCeE+VZqquB6Jk8FYOlltUahNP3uy+cn2LZxy1XE6M0Q2Y1VuMfgRfqaossB27vNLt+JsjOduLj82ksGDznMKKnxv4UpJi0qt5nuTuMUo+ZQHv4VSCh4rn7oKgk0dec36VM++lELTgDxScAzEVS+B4fsKOQ6Omptwra7AWde1ipirsPdbiE1cauhCr8+R+bI69ZIIvahPLIqXJeXoDR8tayEgxjdepBFIB4nzZ5OZawUjbqXAIFqsfB/DuMh8LdGB5jgJDt0v8uLd1CWuNQX0yzeLgQp5LwTfB+OKZtA5T811+k5bZiBpqDD2qMqfLHglukt3Z/pR6ebszzUaKg3A5UknaSzBF/ipb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(5660300002)(316002)(53546011)(64756008)(66556008)(66476007)(66446008)(38070700005)(6506007)(8936002)(186003)(66946007)(54906003)(8676002)(4744005)(71200400001)(76116006)(33656002)(91956017)(4326008)(2616005)(6916009)(508600001)(2906002)(86362001)(6512007)(6486002)(83380400001)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?8ZWlUvtZsa+V20ct4XQzN7jq7ZjKx4rIrjhUj9HwWFpN+2qIquTm9fCvdO?=
 =?iso-8859-1?Q?YUUGK/wFb3k/sCfSXiuu6QYtxz8l3B+l/CKFuOu5PqfFtUcoLcj8KjEpG7?=
 =?iso-8859-1?Q?5GWN/R89J5MN/wowtmgLGfsdiK+MJZbd/MmIa+GHAePMQ53P/s6uAdoZwQ?=
 =?iso-8859-1?Q?+UHe+/QNxYyO5FvtwdjQDj9UXASGzRIEFmLRaLuT9t4u0YpKxeR8+3Log5?=
 =?iso-8859-1?Q?EnYnheCCY1kffdoxeVgW8QSDdAeuIHuGLgwGXvxSnHwBpdXA1d+/KUDgiV?=
 =?iso-8859-1?Q?pA6VlEcRh+Kfk4ecUw5FC1hFo9Dfrta7ojToCZqhUuiJ4YpDYyRRUpmBTo?=
 =?iso-8859-1?Q?wZQbcxykNd2VvTEWPuNiXlu2oqC8mYWp7JRgfuYiWxqDkajWdM+CWg21Si?=
 =?iso-8859-1?Q?2Vrb4ZWxu4nJt94uUFw7do7UAuXJk1r9aHbzutc0CrwdSp64I6+aBlPPuQ?=
 =?iso-8859-1?Q?56IhsLvWrNK0RzI3f6x96ltoiRbsUFBLqP00B/csMX8/CvX/a9wQExP2Wl?=
 =?iso-8859-1?Q?/W9eISEGr2CUSJomeZy313hKRPxLhFSIU6qdbuRjraKIRCIS8R8WmL4mFV?=
 =?iso-8859-1?Q?+TgPc+x92KKk3Uq3G2ChXvSkIC8/I1Xb2koE4qw0TB7EH7B/SV4JiXdnD2?=
 =?iso-8859-1?Q?fQ1DVA4+rJFUGf68V72j0EPMfHxw625faasWBYS+lQ/NLbjRDZR/rQpIf0?=
 =?iso-8859-1?Q?OtaDjLvVJh8QEgFpSVmDg/oMgLWXCqdTQLVqbOrp4UU3NsV8j0XO4sIkF9?=
 =?iso-8859-1?Q?b4Q3ukc80fh2REVOYFUE8hYhFNMYD1QHciyZGII2miTW/YCWTSdOqkw6rF?=
 =?iso-8859-1?Q?2qLI0nT8eVhW5WFzxX07UDXzACdDa6Vr2Sxa5979PG5uJkM9bB8oXRia25?=
 =?iso-8859-1?Q?WhJOCEfKfN0AWbqfDP0tk+cotCAUqlI6Xt26CD3z0jPz40138btlsuznFd?=
 =?iso-8859-1?Q?0mk4c4yr3EfDhi4TwHymt/hlZsWo0stIWt/qKqC1zhPgRl88rK+1OAJPea?=
 =?iso-8859-1?Q?yMM9Y9UNfo9e45wsTLmK00D/r+j4ptqoO+jv0jCespSqOb0axrRV/X7Nl6?=
 =?iso-8859-1?Q?Hh8UG64I0zU3xfinq1uXu2JVUHUXbhRqY+cKIfQIl0dxHyeL7Et2o6LAfV?=
 =?iso-8859-1?Q?5ueLfaBRiBJmCVTr5qTSSccyVXyOnTXcSvHJ6NxkKFUtAUOGyE7xjoNVNi?=
 =?iso-8859-1?Q?cczQuYhCirtEVJsfiUPCxMy7bB5aIrOtC/RuomNo9JTkrJ0CQeaBAaqHy0?=
 =?iso-8859-1?Q?aZbBtXNtCbZLxCENBj9SvwX2Wx4l5ANNa86gA+zlYys5juf2IfwR95b+lK?=
 =?iso-8859-1?Q?8ccBOtkomg3qhVM9dL1x9DpeEINLwO2I8pg/LLyl+ZguKsIST5nujHQ2o9?=
 =?iso-8859-1?Q?C35xUNQJoTEv02amGYGv1nh+VpIZ4JFhKEMjHjvDcnHQrAXG+OVT0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <E47561DE241F61418B92C55315C026A1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea46d0c2-0bad-4b8e-71ab-08d98fa8262e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 06:51:00.6575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CO+2RdVld1Q6TryeHHqvvetAXW0V2Y/TaeRocHnWBs2H4j3mjUig/a0HY+IA1rDLdOHfoUsILo/OopTnpQEn8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5064
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: j3LjTRzyJ49Cy2rottAVR5EOtqWeJ4yG
X-Proofpoint-GUID: j3LjTRzyJ49Cy2rottAVR5EOtqWeJ4yG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-15_02,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=945 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110150042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 14, 2021, at 1:56 PM, Kumar Kartikeya Dwivedi <memxor@gmail.com> w=
rote:
>=20
> This uses the bpf_kallsyms_lookup_name helper added in previous patches
> to relocate typeless ksyms. The return value ENOENT can be ignored, and
> the value written to 'res' can be directly stored to the insn, as it is
> overwritten to 0 on lookup failure. For repeating symbols, we can simply
> copy the previously populated bpf_insn.
>=20
> Also, we need to take care to not close fds for typeless ksym_desc, so
> reuse the 'off' member's space to add a marker for typeless ksym and use
> that to skip them in cleanup_relos.
>=20
> We add a emit_ksym_relo_log helper that avoids duplicating common
> logging instructions between typeless and weak ksym (for future commit).
>=20
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

LGTM!=20

Acked-by: Song Liu <songliubraving@fb.com>=
