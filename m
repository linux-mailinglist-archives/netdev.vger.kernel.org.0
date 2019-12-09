Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C361174B2
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfLISnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:43:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26022 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbfLISnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:43:42 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9Ie2iS030254;
        Mon, 9 Dec 2019 10:42:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xRLvkCk8Q7E8xLj9KY+tfBOK0VjDUbUqo7zVqZsoYWo=;
 b=muC5x5sHtuuI99IzB3qNF27kKZ895xAZN0BYxrxsbUbNpCKUstjswrjQBGaVBwK0izOD
 w0J6XCq8AXwUz6t7F3GMQByspvvFCpEFmFY8H5+3gG+Wt3IliXE3y88w47DQfEk8SANP
 0jxw2qTQQ6vTqBmKxHh4DW0eRjjIf3Qxqv0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrc269u9n-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Dec 2019 10:42:36 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 9 Dec 2019 10:42:26 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Dec 2019 10:42:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MF0p4dyCCtLkNsANTIRgL8V4R2AWDnS7K7BTgZPcTRkkgwo8HlAUD51GbKXC9ynY1GGzwkt6N/peKmZqipE2vPIt+Pa4MRf0k2DbW7Sz3wVEZAcAiXg0qlrpp82jwKVJCQWN1QXY6xK8di6X+VVBISvTMPHWVsf6NJein+8evcAAdWYQB3YTiwqotegUwgfFtB1rigGK3GCZhjJVQQ9fLjq8087Ad4lJV6T8NHQ7VF/10c40reRLG0Uv1oPiOU6bu+Of/+7BEzgqiZXQ6FSL6n99gNwKvLhLOvoXFG96FrrXrkyVduly/Jnr9qBOz0xw1llPy9pNthzxEq/gjmakVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRLvkCk8Q7E8xLj9KY+tfBOK0VjDUbUqo7zVqZsoYWo=;
 b=nI0pV4RzJEGy5iq5ZI5gqQN0Hgvp4Qoic44bQ/5kFHY+wNCPkr0Eocecy4LpLbZLXXdnJc92+cBuhtVygfdDXVPqDAS9u9FKnJD8y1XA68f3+/t5Jwq+3wxVLiAZYx09an3g/PrjKV8NF533hFxAB9uw8tf81rk9ZWc4yyFbrr0vn3Y9db1YGGy7aaycgi7JohIQA3uwxeLPkLSOuKzfbA5yEC6rCtaOkzDtf3HkJMHF8lNIq3ANPX49UtDKbGDlkwD9+Ntv38a6Nfi6K/PB9kGFDDyGuUHIUfH2rp/Gx3ezGoCdZtgsVUY+xhMys85vJlKWZX6wXMUPaANVhf6ChQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRLvkCk8Q7E8xLj9KY+tfBOK0VjDUbUqo7zVqZsoYWo=;
 b=ciYhHbHKWNwLY0Cd0C9zma1siqygL9JHY1hYI7YLd/LabZnTQpZUL1Xci00xuoLp4s2YS7yI5YgpdrZtt+nvYA+C09TgBNIZaoUJh38s0N0eK4LEv/GoHgdoL2lwntMT9u2VDmB8Dju46JIRMF8otZf1L00L2J12WeUimkbu5qo=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3373.namprd15.prod.outlook.com (20.179.20.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Mon, 9 Dec 2019 18:42:25 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 18:42:25 +0000
From:   Martin Lau <kafai@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf 0/3] bpf: Make BPF trampoline friendly to ftrace
Thread-Topic: [PATCH bpf 0/3] bpf: Make BPF trampoline friendly to ftrace
Thread-Index: AQHVriPKlxpSO96taE6u8ud7YGSL6aeyJICA
Date:   Mon, 9 Dec 2019 18:42:25 +0000
Message-ID: <20191209184221.loxqkxlagbmpr5km@kafai-mbp>
References: <20191209000114.1876138-1-ast@kernel.org>
In-Reply-To: <20191209000114.1876138-1-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0039.namprd22.prod.outlook.com
 (2603:10b6:301:16::13) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:b5df]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99bd45df-0994-471e-98c7-08d77cd788a7
x-ms-traffictypediagnostic: MN2PR15MB3373:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB33730F8DB3510E691EE0E2ADD5580@MN2PR15MB3373.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(136003)(376002)(39860400002)(396003)(346002)(199004)(189003)(305945005)(81166006)(81156014)(71200400001)(71190400001)(4744005)(33716001)(8936002)(186003)(66446008)(66556008)(86362001)(6506007)(6916009)(64756008)(66476007)(66946007)(5660300002)(54906003)(8676002)(316002)(52116002)(478600001)(6512007)(9686003)(6486002)(4326008)(1076003)(229853002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3373;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zzQwvUOaNweABduK5Y55fYpv/Z/9XWW1yMlW8+3c6gyLoaIr47f1gJF5uvvrQkWbjQoOPTOPEq/kN2eiiuZdMbGciZ7PA4La7gZz2K6/PCaGgKsdI1yC3swmAq53wzpeMeAer3Bq/yeYcR8sXjgews90J0vcGULtn5HQA1WYQ7nYf4igmwwHR9w6Y3SD+sCm/3GA7SkTXxmSkY4bIsaqHgTq29Vi4TeFaLO8SUyFQ/aXK9Xw6Lul9DuETVPWcpB/wWfZpVtXlpwnApDeCx/Yxagxs7GgTDEwGzWPkH+I6oP7QF0wsc8wDSmzPBrTEehCa4XWm9rVQX60MKDeAemuVLtNla8IL70ebl9gCTRp/WrJzIFtmgef2Nm1pF/uSqc6yN2EKulZ3TrxexuFzF5Omi3WUEbjD8YtnSgRkgam7Vhgkrp3oIDtUPTINscNEJG3
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB5C1C20E43C3D48AE1182FBBEB9DB6E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 99bd45df-0994-471e-98c7-08d77cd788a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 18:42:25.0831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVWH+MMSagjub5M4JPa1N4lNHXoDeM0wiWWfOUiThgoQZrVeL9A63XpiiFd3nbQp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3373
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_04:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=244
 suspectscore=0 mlxscore=0 phishscore=0 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912090150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 08, 2019 at 04:01:11PM -0800, Alexei Starovoitov wrote:
> Patch 1 - fix crash function_graph tracer encounters BPF trampoline
> Patch 2 - use register_ftrace_direct() API to attach BPF trampoline
> Patch 3 - simple test
>=20
> Alexei Starovoitov (3):
>   ftrace: Fix function_graph tracer interaction with BPF trampoline
>   bpf: Make BPF trampoline use register_ftrace_direct() API
>   selftests/bpf: test function_graph tracer and bpf trampoline together
Acked-by: Martin KaFai Lau <kafai@fb.com>
