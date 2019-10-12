Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862B8D4DDD
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 09:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfJLHPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 03:15:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45124 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726728AbfJLHPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 03:15:47 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9C7FXv7027544;
        Sat, 12 Oct 2019 00:15:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9p8DwJV7aB3a8jp3BpOidVjpN9aR59FGI8zu8bEsBUk=;
 b=qRMWn7BrAnh71y3VpjqaxkUtYhQThhf6pOdeHielmR3qZwIdWiihfZziXecdXmR+phtA
 HFARssyr+orgtOeZzrH9xwiG74Jadf8zMC6ewIzKMB0J7wyjo+qBc2EPyrpzim9G8AWs
 KZ0bFKygqJcMOih5BOQ6qYQpRCKkDKfkWCA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vka5qg0f1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 12 Oct 2019 00:15:34 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 12 Oct 2019 00:15:33 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 12 Oct 2019 00:15:32 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 12 Oct 2019 00:15:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L79BzV+LTtlIICWqL+ldcayFbPuS5K6V8zsoXnnf4GcOgVwiUTWNgM1kA74+P52rjoQZ+gfwNUs0mua4buAhyeePAcbIIeDD8Hfp2DjKULnyWrV5XpvQ/Ri9ZdJ+ltcv6y6VcJqXtxUnchFplnpr8hWSWyiikHZZdbYJounRFqiCvcl8TzHt8G/T5eZpjZ09bQkcM9yifXZVQmP3Pha/cE5PTMgYukFu23OL4kUo5q8EGnajKOWZI5+FKPHzmw5rxIJ9IGqQbWk96A0b2Qyta0X1W7XaBA7p9Gnk2TxMDZYmx9R7NEW+HzesgFpfsbJW5KgE8A7MT4XzOipuIK40DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9p8DwJV7aB3a8jp3BpOidVjpN9aR59FGI8zu8bEsBUk=;
 b=gBPzVfUXDWRnWMTCVfxUxlH7WpzJ0QEujqNucIKOxVC2ca1HYPTCs9OvyBV6jf5XpxQDwAl75ZFkLE5Z4nbFNVK72wUErm0DDWZEZJv50SAWvJF2D4bmGvQGIYL/FfclI3iQ26SOAinb3zl6KFNNFKXxNbM8QmMTpykm6Vo230mw9m7pWbdL07T4JNEuJdQnFim2LsiJYpXeylwoIXvmanAS4Ky/E8Uef/aM7kR7orsKh65yK4670tM2l6gDrxjPFYg+PxhgKdLPKC5ypZgeTfxObt9ywos4uHigOrAUeMT/vy9DUvb6lTslcyrpeX9hZT8xxggKzCVsHJ6Isn2nbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9p8DwJV7aB3a8jp3BpOidVjpN9aR59FGI8zu8bEsBUk=;
 b=g3qUw9JhxAo8M/rC+WXLfPWmxmFJV4EXehlWbdGviCiTqdKjk00fJIX+fUXH45vrG4KHFxzK/vwuYqRoag/2Wof9GBNhSq4J6Cbp7yTkfeQwa5+5pdvgIcGJmXRCzyngLzprmSb3/eaatEeglJnYWr/H8aR52Zfl5amo/b8GWbg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2989.namprd15.prod.outlook.com (20.178.251.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Sat, 12 Oct 2019 07:15:30 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.021; Sat, 12 Oct 2019
 07:15:30 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH v2 bpf-next 0/2] selftests/bpf Makefile
 cleanup and fixes
Thread-Topic: [Potential Spoof] [PATCH v2 bpf-next 0/2] selftests/bpf Makefile
 cleanup and fixes
Thread-Index: AQHVgH+2GkIxUaB8IESMrsJhJHMPCadWmKQA
Date:   Sat, 12 Oct 2019 07:15:30 +0000
Message-ID: <20191012071526.lgrzyvyhnyvzh7ao@kafai-mbp.dhcp.thefacebook.com>
References: <20191011220146.3798961-1-andriin@fb.com>
In-Reply-To: <20191011220146.3798961-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR06CA0060.namprd06.prod.outlook.com
 (2603:10b6:104:3::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::3588]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b6c0726-e57d-4649-c530-08d74ee3f6bf
x-ms-traffictypediagnostic: MN2PR15MB2989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2989C1CE0153CF6021CCA774D5960@MN2PR15MB2989.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(39860400002)(366004)(396003)(189003)(199004)(478600001)(1076003)(81156014)(81166006)(8936002)(6486002)(6436002)(25786009)(4326008)(46003)(476003)(11346002)(5660300002)(486006)(446003)(6862004)(9686003)(6512007)(558084003)(6246003)(256004)(86362001)(316002)(6116002)(14454004)(386003)(6506007)(102836004)(186003)(52116002)(76176011)(8676002)(6636002)(229853002)(2906002)(71200400001)(71190400001)(54906003)(66946007)(66476007)(66556008)(64756008)(66446008)(305945005)(7736002)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2989;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I+Rs+CW/BBgaLGwqi9i+34Yqas35JdasLYzJR9qgNMvDL3colY79GfZpvOD8ZcF91vTTikimgIaHC+el9Fht6kiQaiL16hrt2RPOxo/2eD3troEWNPDsbqzNtJ0Zd1cUq07RgWzIP2WDVlwYXoXTl7z+IVBwzHzmzEt12Q7ffGhEgKbsY4Eig7mLo6hnESVeIwMiMfobhwRBzUgDOvR7LWeZ5l6Ik1aqNwkDp/ViYToP3eRSQvw6e7BhgBNohpDxQP72Qhd7+iOFUGhVQrm4Q9N+2LZu/Vvn8T/M51IxjzCvUj2nWf5GJ7Fqx/qBbi45dDNbn6f2jkUbVPGw2ObXZTy5dAZzYuv/bJjQudPW/3Ob9iu3noQGXDAWiHtUwPw+bFnRm1Ll09Rq4Kfh3HCAeHSa8MjFVVwiQINyxq9ha3Y=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E4F9429AFD27DA48A106A23BC282219C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b6c0726-e57d-4649-c530-08d74ee3f6bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 07:15:30.4098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JzB1avS+zAAupMHmrUEUNvNoKyjqDyj9bPb064NY7Cyjt1jvdegc9SJfFIWBL1U0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2989
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-12_03:2019-10-10,2019-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=582 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910120066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 03:01:44PM -0700, Andrii Nakryiko wrote:
> Patch #1 enforces libbpf build to have bpf_helper_defs.h ready before tes=
t BPF
> programs are built.
> Patch #2 drops obsolete BTF/pahole detection logic from Makefile.
Acked-by: Martin KaFai Lau <kafai@fb.com>
