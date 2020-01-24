Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088C61478BF
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 08:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgAXHBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 02:01:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60468 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725817AbgAXHBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 02:01:24 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00O70uiZ029696;
        Thu, 23 Jan 2020 23:01:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wdzDnSUMQPVC+LjddWEzVONaC5s8rQoCwwEE4YitAjY=;
 b=d6tUhso/DuMlTlEz8F6SDkfDej4mBvyiAapc3l3wOukY3kisGbgKgskN+VKsqy+LcCCX
 BlWPx9YAsXEhYtev7QeI6Lwc5ySJTVaWKrPb957IJcHRhIGRLRPhx4DV/pedTDLRqJSt
 1hT4fDGQhHHJ6JjStW58VSmyy2wSgEk2exw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2xpxanf14b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 23:01:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 23:01:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0SRtbJZhEGz1akNRXkn9YNqDjZWszbEjSfHViuhX0av2mCVmbMLiJghV2ThC4MrrAxguIdOgYB2QSTETQIj+MVyNWzOqIY7LnD0tKrLk30RIbuvn7SYLCKcq+gcc70/qqCeFR2hgLJSu8f95BbGqLZ6/g56HRXyZEyZ/639Gf1QqcePik+af/pFu4F3k0LZMEDGToFj+QWoLfRyk2ZJMJX3qtuLLF3jZKf6muegB7vdcrOjdwaSghd6HQxYl+l31GoMvk3vxSuAAfgQg2bDA4LBULnFb4LTRkGkZk6bfAfbsTdggz0I3ujO0jMO0pDGds0yjL3IeMSdXBqAuItD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdzDnSUMQPVC+LjddWEzVONaC5s8rQoCwwEE4YitAjY=;
 b=Mu1zaSFUp3RsEnSziBZs0v4FLsFBM2RNxToNR+5uD0wZVUt4A9g1d9bQgzU/VzaAz3OzdgrN7QKg1j4e0gQASFX9y6STponHXec/rwtOKBjnicHnyYCyDSm5NkKYZsv46wsFsdmZ5WHKsGYY3gN5tpUFdPyG8xjzOvaADzHgoFl2WbNn3cK8ewQ8gWGI3qbCbfQyy13his5q6zA/IaYw+05XsrHFxi8ZV9u9F6NLjNvA6JFxZwGMOqn6dc4ZX4zcg8RcIv9plTRnYYL3jZdmPD6+2+E1FvnjY5buE0TScm9vu94y9e7WdTYYjXHNjQzNmT1LXhaX+LlWvYApMQKqeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdzDnSUMQPVC+LjddWEzVONaC5s8rQoCwwEE4YitAjY=;
 b=jRBkRIokhLvho+yb7PfGK0unbyudURIKwkGTDx/To0ogvWdwN88FrLE3TLwSVZgTl+frT6GWDWgafLkX3uAM8s8mcFpCblD6ZY/2OP6nk9bUqshU1i/UIzZ4p8H1dnZExAjhQpQmCjQk4i+M3YaSwTt6a0YZV1YAd4pi/LFYDns=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2893.namprd15.prod.outlook.com (20.178.250.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 24 Jan 2020 07:01:09 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 07:01:09 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::d6ea) by MWHPR14CA0023.namprd14.prod.outlook.com (2603:10b6:300:ae::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 07:01:07 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpftool: print function linkage in BTF dump
Thread-Topic: [PATCH bpf-next] bpftool: print function linkage in BTF dump
Thread-Index: AQHV0nk7oQ9gzuQIGEuDkSQ0JqpEn6f5YyMA
Date:   Fri, 24 Jan 2020 07:01:08 +0000
Message-ID: <20200124070104.gd6hpbxqhlkbtklv@kafai-mbp.dhcp.thefacebook.com>
References: <20200124054317.2459436-1-andriin@fb.com>
In-Reply-To: <20200124054317.2459436-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0023.namprd14.prod.outlook.com
 (2603:10b6:300:ae::33) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d6ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a146ae1-82d2-4cce-6b41-08d7a09b3005
x-ms-traffictypediagnostic: MN2PR15MB2893:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB28938E555201C9EC669B0ACFD50E0@MN2PR15MB2893.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(376002)(366004)(396003)(189003)(199004)(64756008)(66446008)(66476007)(66946007)(8676002)(66556008)(2906002)(478600001)(16526019)(5660300002)(81166006)(1076003)(81156014)(8936002)(6506007)(7696005)(52116002)(71200400001)(55016002)(186003)(6636002)(9686003)(316002)(558084003)(6862004)(4326008)(54906003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2893;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JDVvZMfIHs6pAxortrL/VTfqQ4gflug47NSrPJW4lfWPudHc2174KFUk0lvz1tCTrenaLf+u7S3tALbKJHT+DA+B94vT9ifE6VBcJZTqhjTPZG3T473HVTXSZDuSupSYzmhw+t6LxpbdKX3RLRYihcvDNjO2lJEe79pNV4TIo9TzLdBxxNtAq9BHwyfNWofGw8Hxp+KjbD1APbrzV4sUgO/YMFw+vv+KkmXYhfH5ZPM6tHluwEuSiG4HX1iee/brRsH9Asi97ctB/nNyJGC2koSVMBREEPlOdq2Mv/f9WLKfylS5Sue2/YIEytKlU+MnyWuy0STGjXL2auYsQ1boLusSMPOc3S8f1TTDFRlRIdl4khfKrpNPu4XEGLKOvu4NzqgcYkIz3MljVE8AcdbfcLIzCeDoGYiuTGqfgOOd8hJwzJEUIDD/cKFiDBDRn8Ea
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8B1B17049FECAE448E2738460DB94A38@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a146ae1-82d2-4cce-6b41-08d7a09b3005
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 07:01:08.8307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: giBG9GwqQ7SlwEFfRNQNGFZ9QwHSbgnqsLnfA3RsvyM5KH+slh4HH/K7wC2JuH4p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2893
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_01:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=525 mlxscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001240056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 09:43:17PM -0800, Andrii Nakryiko wrote:
> Add printing out BTF_KIND_FUNC's linkage.
Acked-by: Martin KaFai Lau <kafai@fb.com>
