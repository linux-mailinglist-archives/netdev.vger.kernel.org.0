Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4405A34DD62
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhC3BTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:19:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229479AbhC3BTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:19:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12U1D3A2005131;
        Mon, 29 Mar 2021 18:18:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=si2S1esC+vJCqXamLu585tqjO1bBKUwwqkvUyoVwa4Q=;
 b=RwPjd1bG9KVzHSVVme8lrvPAUccNVVZ/wdqp2+aAIKYaJkMUdueVuhP094cst9OcgLlV
 WxDbZwwbg34NNqv5Fo/Nj/MrRWExTnxoK2AXJ4Una9x2wyG8654oAZgueU7WtZEcFICW
 8MhN/aB19nF1FimuPNl3f1/w5SRqckoHtRo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 37kad45fhx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 18:18:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 18:18:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACVjiBinCGEAo2wzTonkqPKNVibchA7ITKcsB32TfHhG5UCUJoSjYqVGj7CHAnoT14aQbXXeIUBK118FHcMGBXSCNBH8QmZm4amNmSR7Dg1CYBSmqiZv+pdf7csFt3daVrWGf757I5lSDy7+6nQqdhrvB7qHLnaYSHjaCtpKWZYPFI3NhABeus/Pwzqo0Uc+Y3cmGB0If+YTOUkoJAsguHBPCATGCKZq6HMuxS3OLR2KA0+pmJ8NHmyk0tnf+objKff/31VeOJsm387tXgNSDvXUXzZeHJ1ytHpTra76nFdCmuTO56oxjGmxFmGwJBQvIZthmhEBfrcqzirSLUZHww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=si2S1esC+vJCqXamLu585tqjO1bBKUwwqkvUyoVwa4Q=;
 b=b+YA2X0dZnYsoPt9awsJaG9xjzygKu7tbvGDiqidsVKgK/JjikTUDv1YvwWqS+VPmGFJIn2qMTxEUgt5YJlnpihbdCsGQmlzOSFHY0FNV96waULj4rD5ln9zg0FaVWdjovOS7fwzM3AeGkaHYLBdR27qTzsdXHhhrVYPiOviRI4/DGR0Mvm5et5ojARov6PI5H6asujNV8HE2WBka6YJl1WEUvuZmilMcfWXhfODIGmsUDsd03NPGn9rlStZlDBRTO1UV82EPW1FWx+ADEAvaqDucItJr1lMrH9cq5cDCLG803Fbxc9vK+DxtP5Ru/Mqwwzf5VIKEmLq2ShvGyikNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 30 Mar
 2021 01:18:51 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 01:18:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
Thread-Topic: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
Thread-Index: AQHXI8U+0OFFbTd6V0Ki5HugmCJi76qbvb0A
Date:   Tue, 30 Mar 2021 01:18:51 +0000
Message-ID: <3769AEAD-120B-4936-98DF-C73CEC11CFD6@fb.com>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-2-jolsa@kernel.org>
In-Reply-To: <20210328112629.339266-2-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:876e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc5c6a98-ae4d-479e-d276-08d8f319c718
x-ms-traffictypediagnostic: BY5PR15MB3571:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB357128E8D58390C23F71F1D2B37D9@BY5PR15MB3571.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rH9VnWbbBsYWm3uotXiqPgcI6XjwapyXyZzEuFgaQSBUQ1u4ObzClI1mPkVn9TloLGQBVZwzR7XuGs7GsayUuhOUAmtML5zeajzcVN41MxCCp7cQ8QaT8MA2NSeTieqqmA/brxNqLXQ6EnsC4SsJI/wVN0A/jdIbla6eFePQQ6j37ojgHhmbF2hdPqQoVHIH0dbYeEXMe2olINk9VUzDrHvAkuajsggOlmgh76S9RA4+FXm7wc4ubCGRMNGdPTY+R7rxcnGYArRzCVdQuWSRFAWj+JdUKSwWnJQYaUXgBjlhFGvbtUSm5pkQBLPkIL8r2VG+4ja12PNt677kaO3qwjT6Lf+X1ziqSiVPMBW6y7Q867IbtXOAn7C0GuEVD+FgW0mtBzD7xV9512B34m1EhdkzEq70jC8Ty9a4IZg928Iani40wGazucwU+d87I5aThD/iNaLjk7Zl6op3SgJuNN9vV/mT6g8lL8A0q8iXcSW3Mfe6HkHafal8g8vD0kiJop/p+7V08AZiDkV4y37ycAOiLRsAR6rc1Oe39Txin1cQjxmIrLXlDQp3RoLKQEINH5vg6RgnF2XXoMdrVd35IhWwUmsAkH851CdvGK+gwAejkWYc447XBwGHkd9J8BXA0knDqdz/aiN/ipKcvw26N//fh7G1KFqs4PG4sX4KvaitE+UdbW/vEdSgBia2kyI+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(346002)(366004)(4744005)(478600001)(36756003)(53546011)(6486002)(38100700001)(66556008)(66446008)(86362001)(2906002)(66946007)(66476007)(6916009)(71200400001)(8676002)(2616005)(186003)(316002)(91956017)(54906003)(64756008)(33656002)(5660300002)(4326008)(6512007)(76116006)(6506007)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?RT7yMlt53aTYN1GH5ovqhoG+g/0Ko2/kLho9IacUSZGEGsTZ0FC5oRmng+?=
 =?iso-8859-1?Q?11wNQNswlm7h+bhDKJqrogIfz1NYL8FQg82U7Z2zA9kGttQzT5V/JlkgDB?=
 =?iso-8859-1?Q?p+ZfkaRxYPNKLBqIDahHXB7K2mScxg3DemJ1hCjp2PyeYkHH03Z2TIOE5H?=
 =?iso-8859-1?Q?YE08vvdb2UsZQBSLsB1s7RMss8R+QywsBGgdBfca9LANvu3MUzc4c8M3qx?=
 =?iso-8859-1?Q?C8UUyr+DjTovNE44/mNnhIw6Me1h8GK0dX5+M9n1PYgqGfZyxFJSfZ/bxG?=
 =?iso-8859-1?Q?TxDG0XkTqN9mkFFOjf+bDsHYvO/iZxA0cUaElvxHzg1E8hgm9LpbKvHR5z?=
 =?iso-8859-1?Q?/CTfCmGSxbvpLlrRxfbBlyvhaZ+BBpZlnsg8g/g3H73xsElQyTLso4Grfk?=
 =?iso-8859-1?Q?ymx2Z1Ta4TZvbN7jjzjZD8+i/onsjKSZGG7+M3GnbfBxsPcdcWNc8B2aWS?=
 =?iso-8859-1?Q?O7hVKEY3CSJ4Z69WMY7JzdnqhHSnsVgpjIIPejNs98ll1gJZcXyvxx0/t6?=
 =?iso-8859-1?Q?0o3p9ct+KSG9HlV7INQT1bMwfixhIlvtNQhA5mlb6aUEbnkZHoan4u1UIl?=
 =?iso-8859-1?Q?H9R5WwV+1LLx2sOrYhyqX3vLHjgCdmnohmf+3pHmgF7Cd1mM5EbvaL3oR9?=
 =?iso-8859-1?Q?xg//e7HItE+ZPiCKuzox5gZ5gFtOgOO5tojo7BVSJR1lRa5rtCOgEkGO9+?=
 =?iso-8859-1?Q?Ln8wLJmgWq4b+WdoadBy/pxMds/fGJL66NckG9dF8rNQfyU11GJEv3NQ4J?=
 =?iso-8859-1?Q?t+wc7pb1/35R0I3OrLE7tzGoDw2opGO0GzBCFiSoefTEoou+NZufqqeyOt?=
 =?iso-8859-1?Q?IhlhyoyfydRdoviVcB1kChEkKiH/M7LChZjLjCjlR81lRZUlNKoJBTwtCt?=
 =?iso-8859-1?Q?HTaFLol5DDn3Y0lXXR6fecc6VYFF92juWIzR3e1aRIghRHvjwPWJvFBvoA?=
 =?iso-8859-1?Q?N7e2CXSk5r1ItSQAnU4zeRuTLtIf7UvyUm/XpTf0Pqkredxf5pxJpkRZmV?=
 =?iso-8859-1?Q?VAL6I/j8QEuJP+RDqOtOR3YmYTrz+R+m287Z/7ZPi+QwNLZD2IkRH0luGM?=
 =?iso-8859-1?Q?oR72VROf9zp01CWaZsvQe3D4qWPfo4EBLHTfhsN96jYxGow8FpqEmWHUQT?=
 =?iso-8859-1?Q?WIxxs0A+MDXQ5Dqbi07fzhp4i3KfYuJOPaUqkkFoQLbsns8D0gZbdjocq2?=
 =?iso-8859-1?Q?PzBUPWHWsZSWbkXQrR6OuaEeH9BdutkaTzHCrjB+RV7OOh2R/83UEKZnpG?=
 =?iso-8859-1?Q?GZ02wgIfZR818hM9WbaSVZcEkUIHLlLGZTktTqBi5lUXiUlHGPnfVX2A9V?=
 =?iso-8859-1?Q?5SnHEW+y9ryNXJbWy6oeoE1nsIM/o0f4ZeEn2f7MeRzcR5eetJ+ovFvptg?=
 =?iso-8859-1?Q?LVnQhM/seUy1HhT+gtl3N9xAxVG/Q7T9jrfqe9o4ubj/nAbbg9BsE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <7564136F92161B42AE9E485A8588D648@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5c6a98-ae4d-479e-d276-08d8f319c718
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 01:18:51.2200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gHr5TVbwkLB6S3a3zoQq1PdUz0Vv58wsrZCAha90yhY9rNW3WPHpbCwOvdjmLXMp5ZIcG09IzkV7T7fKQm1ZSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3571
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Qx-7z3OGNVHfQ1sAzd_R8nyDEAy_-N4z
X-Proofpoint-GUID: Qx-7z3OGNVHfQ1sAzd_R8nyDEAy_-N4z
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_16:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=671
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 28, 2021, at 4:26 AM, Jiri Olsa <jolsa@kernel.org> wrote:
>=20
> Currently we don't allow re-attaching of trampolines. Once
> it's detached, it can't be re-attach even when the program
> is still loaded.
>=20
> Adding the possibility to re-attach the loaded tracing
> kernel program.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

LGTM.=20

Acked-by: Song Liu <songliubraving@fb.com>

[...]
