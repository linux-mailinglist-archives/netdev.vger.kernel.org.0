Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AD134D475
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhC2QFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:05:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229515AbhC2QFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:05:38 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12TFxlLu012079;
        Mon, 29 Mar 2021 09:05:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aBFXoDRYCxWkBNJVob7+coYRN/Ym7OFlroJGzuBIzGE=;
 b=bqrEc/kPUfDLJ8QxLga2Ct/I5rOv0dqihquhb9Bd64xaJCeWLrp5vBdb4cmaRp6/65Aq
 Q76iwAJlYf/siviT6XwUxGHaZdge0Di4Sivc5bYpswzXeueBLfywXzCsAIBf3uLpTHrv
 4TPahWG+0YNBbcMs4PihnQfOQ1ZJ48+fS7U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37ka6sacu9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 09:05:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 09:05:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoEd9AHGOLkb4PEcHPpy7qJTkQuHrvMrtq81CZviFmwucM0lUD+3H+alJS6yhvjlYnC8x6NqybkB/SDkAmaUCeCBbPQzofEN9q66cWRnSi9W+KehZ9lK59aO6dhdjxpzVu9Neb6vP/9w8Hb0IoMTfp1H5ZiHkWcyw0LnmAXVKbFcCioea9nNp5OT/At0S8uA5GdYYWyUid52LMDzBQqDoTxa9C9Q4OL4I4pNYUt6Ad28Rs4wnCFgNeYXdbwVqomAJvRLgPem+zx7tovPCPirYiYh2H78O4U85Ru+0/XY1ylIjc+MhDOesADNd/FRLgfDFouy21hY3DF+aOCljd6zPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBFXoDRYCxWkBNJVob7+coYRN/Ym7OFlroJGzuBIzGE=;
 b=nowbFvJKw+jRywYVOj7quJNq40cIHpsreTNcHp9+MvmEsZQ4NhOfCNQDuUT2d6cYa+35lU8JrqAWzlyvsDww7EemUSkLQ+zauCNgRQIBYggFhP91L1mTYvVSFjRTmq+49Bxh3yHs220w6hDvcgGYB1haR5xVSl5cv0lUseZPpyxI48J6Ulpv27WnvEzYRhuCl8dqQAqztrJ9orIb07MAMSmTYsMOO0FQKiL2XHilYENLXCwymtsF9tV6qmpYwvg4t48KX/W+shU4OTpcmVSA5GyapJVRft5Ja0mvbXJi5dmVUMcBjevtSMlj8uRtolmiPG4vkhjQrdldqC0vu7bkkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4743.namprd15.prod.outlook.com (2603:10b6:a03:37c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Mon, 29 Mar
 2021 16:05:15 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Mon, 29 Mar 2021
 16:05:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pedro Tammela <pctammela@gmail.com>
CC:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: add 'BPF_RB_MAY_WAKEUP' flag
Thread-Topic: [PATCH bpf-next] bpf: add 'BPF_RB_MAY_WAKEUP' flag
Thread-Index: AQHXI+0OiPs45KDjv0C2tzMBh/zVpaqbIr+A
Date:   Mon, 29 Mar 2021 16:05:14 +0000
Message-ID: <6C4369B6-4ECF-4764-8084-F38310642D09@fb.com>
References: <20210328161055.257504-1-pctammela@mojatatu.com>
In-Reply-To: <20210328161055.257504-1-pctammela@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:876e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3230f29a-95b4-49e0-c4fd-08d8f2cc70bc
x-ms-traffictypediagnostic: SJ0PR15MB4743:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4743A59CFA6644E5B529D3DCB37E9@SJ0PR15MB4743.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5uVRfpQcIHXGIu/FJbr6HBqJhsHMEBzJ/xNnzxJNGsN1mNbMhTp9ARYnYcT5DDQdQvrsqUgxupfPaiLuIH16CIDastVbIEc3WTfRcY7soE3Ipy7SPnIJdpOsgm2BiyqU6xay5ftrIe5gXVz9ncLolmbPxKpUWdZQruG1Hnfp78DPu5zg5fxXD24fWslt9eTJRmKmzXE9PkamW3FIVaOtqVzQxZHzF2XifFR+qNhWBWLBLEcTyZtCZ+fbUs8cn6YGY+Jqkbn0oNH8SPL9ZUDRhXh028KfscJKFt2QSilwTtXiQgd9oAxf8+TkJ7ezpNSjqIn7aiYDnHZw3FTjeek6Y3jHBneBZDEDNmN1hFr7OgEHULLCrPrQ3Lkztvgl5nQUpOZaFYqwjwo4GdWy9bjb5td+jcKvEM+7nkMza8//s+gL0vqGqlOv8Rye5Ccco+jRYWRzZeHLvvK4zATfPbxJnPj5EP3ebxoeMXWPt3nCnW6F1CsUHWie2JysuhjD+lC8KtrfVEPSyJC0UfsMoTpdyo1FDiV+WfzqAPTWccOApTs1BDwIK3BEytiflLwULpNz6iF0apM3f15ORRcdGtaiHEsnn7x2vBMvWzF725hDVZV9GmCWi8lj9rFAwetFd0Afx/kiSMX8HL0WiHTi3cRzheGvp/8lwMcZijqi5ZoQopoHCWPSaIHY9lebbuz61hxp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(346002)(39860400002)(6486002)(2906002)(91956017)(54906003)(66476007)(64756008)(76116006)(66556008)(66446008)(316002)(66946007)(7416002)(186003)(478600001)(86362001)(36756003)(4744005)(5660300002)(4326008)(53546011)(2616005)(38100700001)(6512007)(6506007)(8936002)(71200400001)(6916009)(33656002)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/ZSbSt0m/ZqyimLHZ3YYLfdogduJjBzQu47ZLMEAKAQ6VEwMFaNteiUf8nAW?=
 =?us-ascii?Q?zUVYPLzofwJGO81yQsTK62WIZn5ZwHzrzVnIiF5aoTL/k/32ISEgHoLkoH+3?=
 =?us-ascii?Q?8aX0JMotIMs8nquPt2ZGXTwyUIeFuKeOAtCd/CBxRanZjGZVlyetyL/k4KPZ?=
 =?us-ascii?Q?Xh4fFyUZwORtj4LWf7i/0yQSX1zzzAguibAbhzIaXPbUWW6CGRuYxqlb1Qz/?=
 =?us-ascii?Q?iEoskJ0ia9GEpRNqXd9s/w+nwNa9RvVwsDnLz6CYXQCP5tIX3hYphgq/9Slq?=
 =?us-ascii?Q?+33APX3WUS5hbIQTgtd+1SMNxRbPXqs3guSXDKaxylqdedbHxqjfA2Tymndt?=
 =?us-ascii?Q?Yc7ocv5Bn200oG7fl4d+yZYbtpeb9cbK34HD2x+7laV5ZIrOZMM9ScRB9c9p?=
 =?us-ascii?Q?y2f57dfjLYb3Kv3Xj8vus2RJUTIMZZfvLUM71ZB/oF8gaTWIVr2clTdACs0J?=
 =?us-ascii?Q?K71Ysnh41aEkIvMi7Fhh468e6x3K6ypXq7tIjOfOMip3u+fo3tHaAMqCuiPy?=
 =?us-ascii?Q?xsmb5qEct/L0KSHfvts3zaZpszPSQVcuypdBYFT2kKSoJ2izb1LVODjP/2aX?=
 =?us-ascii?Q?OeDshssparshjZ/JCpIUOzVd3mYmVYPYxFujeMJ4TIKbB5JGuyaT4TY6+kXe?=
 =?us-ascii?Q?Rvfk0b9UH2solxud0ghoUqDMZhxkFq6VOu5TUQclQk+6eDAt5d8uaL4Og15e?=
 =?us-ascii?Q?In1qM3rac+RpCWSNXD1/vlSCNsk4Xrw7kZSKJs2LDh0OiMh5NOKBgtY4sOVC?=
 =?us-ascii?Q?MMyURjZZqVtpC3O2HDin/Zzz9z1Giwj5mnmcMmHQ/gOawj5IRdQOHa1oGCPu?=
 =?us-ascii?Q?Ow5g9pWOHjJ7CWuUt/4kKrcYrzhTaQYT2X6vTeo/uy7pDy4sQw0xP1is1egg?=
 =?us-ascii?Q?fO8XCYCROhcIQLam3U/qv1mg55FKqunCiZwkxfA01fSuxgyFLsYweHO3Kbrc?=
 =?us-ascii?Q?bUjlmpEb2lGSA9TJP0KVTOmPdkK4IRqkBMiwy/6wptAE3x4LbKS5UPa/QeBu?=
 =?us-ascii?Q?et6nzCO8Yh0pYxbUWh+bNUAgNCKtBESOwRrTuKZqJmtoUT3DNBMJ/y+xCU41?=
 =?us-ascii?Q?kKPd6hzDRDppMHg9S4ysra9YWyKq37xR3X3CwxDkKRopooxkmRzjNR5TsX82?=
 =?us-ascii?Q?27QKNg1GY90oVujeNw6U/xBw5v2sCHYM33jtCQtwyfjDnqVCvgdfXyRrkF3O?=
 =?us-ascii?Q?B2cgLDtD6QDhrVZxjdXpBXX2zv9IUz6vM1dJCR+kaXDMislc0GL6rpQmLBW5?=
 =?us-ascii?Q?yYgojzlHaXSkveZ7NVywZmH4B8WwOOH4XUom503XsfaALfLmcli/8jW73GpM?=
 =?us-ascii?Q?c6tyhUeAEvXf1nzrX0brSJVvPAz2gmWxudQ3G8YghIsuNLbQMALuTcXDxlUF?=
 =?us-ascii?Q?0NIVKWo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <576F596F8286664EB3CF09A0BF1D489A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3230f29a-95b4-49e0-c4fd-08d8f2cc70bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 16:05:14.9795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HF2Cj07cCVQFXJg+GCB1qBe8UoKo5eSGreBRghU8BdZ3DjEeWIpoJ3hHkMPBhoRg2/GL6440xEG1+SK5JdWgbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4743
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: qk-o3RRfPt-4mQzZih6-nCcyqkvBjyBf
X-Proofpoint-GUID: qk-o3RRfPt-4mQzZih6-nCcyqkvBjyBf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_10:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1011
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=762
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 28, 2021, at 9:10 AM, Pedro Tammela <pctammela@gmail.com> wrote:
>=20
> The current way to provide a no-op flag to 'bpf_ringbuf_submit()',
> 'bpf_ringbuf_discard()' and 'bpf_ringbuf_output()' is to provide a '0'
> value.
>=20
> A '0' value might notify the consumer if it already caught up in processi=
ng,
> so let's provide a more descriptive notation for this value.
>=20
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Acked-by: Song Liu <songliubraving@fb.com>

