Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2551AD187
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 22:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgDPUwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 16:52:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11688 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbgDPUwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 16:52:41 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03GKiAwT007744;
        Thu, 16 Apr 2020 13:52:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nRD/yd5Tjmc+SQiWOXIPEDIj5ZI52vAeUE+ZKIPZRCA=;
 b=UUl1GpnZmS+rR838t2xNwntyeZCgCXTwARLwKvgVtQMie6XmRh9c5ceNB0pyL1kafN3x
 3+qgimIDOGjTrzHqTDC4YOW1SBe9oR+CSpRFKDnrDCQ9ECyqcXXk2BQDwYCnHNG5dB1M
 6EbPXkLdY7iRp1rqnYCrM3cyY+/tCC2R9JI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7c63d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Apr 2020 13:52:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 16 Apr 2020 13:52:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gv6FnjiXWYD29zozliGSUzviPcvJtDoLMciZ+r/OCt/+zVnWbl3wtgJsgeeAaJBytcOh14NNY86o0gX3lvMsAiG5BB3zan/dF6TRjJmQPTwmKgTutrtqxRCuzY0+0jSmeyKoMKkbFgu6ezMk8Ew5Vvmy4O+a2z84E9Jd811T+RuN4ymVRpu26nQVmyGOqQJQ3DbiLdJoBFaK7sLCMOROvOZx74jV4dV4FpMpdYnwHaAkte1iaVQ/PEg+DK/hIljOmfuowsqo5qv7F23xU3R8XeVtERjdLQGwwPD40T6YkorF+yuYwcqzCr2unOXwh6s7dDpnbr66H7EEezDDrmxaiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRD/yd5Tjmc+SQiWOXIPEDIj5ZI52vAeUE+ZKIPZRCA=;
 b=lynUDofimVQiAh8oTKWi5dgT1fofhQuBiWU0wS4NmATFKUad35LHv00oIXneoCu3X8ktbB+hB4ujSr8nZFLuNj/77hcNr2by8jXh27xKH+u5HBWshfS82jkglhpz0SPU0TCbJuyD5Dqz4lUD/lHqFwBhu6XguX6vwaQk+0fed3hBkmpnSBbuCbFr55/6FFPrQdWdtU+mYHNaDwLDwDNDyuCdlzS85Oa4zBwtO09V360KM93tyXX6wYnHyWnBay2WYepRrNG2TPwLM01if13l2i4JFffnPAKwEw+b4kWTlwDy3NdHRIj5Uxt06ph5WLpZ94sOE7U9/tvVBKYjXoTONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRD/yd5Tjmc+SQiWOXIPEDIj5ZI52vAeUE+ZKIPZRCA=;
 b=iiGF0hMrHqe3tMZpOyFMNoTAzpgrjQvf7hYnWSClDZIHPwM5cwiMilt0LPkSyPA6nQYzzAZOGDewi9FpievStTnt96qlRc/wsrJ5GfQbGCiZPhJucLRNZtlsvrXwIUC1Gvqhs9/EWXDOz7JrGESAGwwc4sK0zUg0RRqbiKot8Fo=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3399.namprd15.prod.outlook.com (2603:10b6:a03:10a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Thu, 16 Apr
 2020 20:52:20 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2921.027; Thu, 16 Apr 2020
 20:52:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jann Horn <jannh@google.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: Use pointer type whitelist for XADD
Thread-Topic: [PATCH bpf] bpf: Use pointer type whitelist for XADD
Thread-Index: AQHWE2cxz6CDj3cjDEeXDSK1b23HuKh8OwkA
Date:   Thu, 16 Apr 2020 20:52:20 +0000
Message-ID: <9229787E-6243-4F22-B809-819A3F24B5DD@fb.com>
References: <20200415204743.206086-1-jannh@google.com>
In-Reply-To: <20200415204743.206086-1-jannh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:f50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fdd54e9-bed0-43e6-d4df-08d7e2480e85
x-ms-traffictypediagnostic: BYAPR15MB3399:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3399A6506375600B2BC2CB9AB3D80@BYAPR15MB3399.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(39860400002)(366004)(396003)(346002)(376002)(8676002)(91956017)(5660300002)(66946007)(76116006)(66446008)(316002)(64756008)(66556008)(6512007)(8936002)(81156014)(54906003)(66476007)(6506007)(186003)(6916009)(36756003)(86362001)(478600001)(4326008)(6486002)(2616005)(33656002)(53546011)(71200400001)(2906002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DQfCnrWgzi1CG5eWA3MRVhoiwyWKnGXcyfjdqGgTmKWsIvg/KyjyOBq5JVDFeU4lyAiwKDeZvhSWyPlvSgcK/cCmRrJA2tPgXTRd82gPl4Z5hMZoajbR4j9FnPyIVn9BZjSoZLnzKAIEzo1ehXylXIiA05+/IRnS4xl3P5UCBO3IpCm5O2iYWYGIM1iPIsCgq1ZtIiwGD8I8aJ0v2m1vpBTZAcqGd4KQCaw1gG1vwqDUJNhYBJ4ynd2rFpURwLdChaPSEi0WAisbliLz8fiyNml7ZKKSLZ7swdBJX/qZtT/F4kaMJiP2V+vNeAKLsrDR/K1UJ+ggwT/FJbIIGH2be9hQZ2mbKtPUyVuLMPypPZ7g+UOaiTFQKFT/u+pTWuvzia6iuXl9TMlq75fXbWT3tfA2xlywzF2cbzIFTN0OO37b6dOiL74ah9cClMbkSJm2
x-ms-exchange-antispam-messagedata: ovUfevddebsbHbJFpuhGumx9BNWPWHqcAJ3eLlFlWbT5LHOP9BQi9VT8gq3j9FHpyu5sQDCPSlbcfx5vpgIQzAs9QJiMJBhMgqsyv5EuSW0mBQI/uQWwrYRxJfllC5g0J6C46qGBMGkFB13A4pRyZYQ4IIGW6kBm8AG24P4y7/Iw9ayy4cfttdVGAgiHL4Za
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6578E13FECB81347A11658DF1D2CEBB0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fdd54e9-bed0-43e6-d4df-08d7e2480e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 20:52:20.3710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vjg3qmizBFcxU5ivuCtsjzwTq3IbuLX/2ysfKQ94euNlI3lnGrLVCCHLYnAnShSH6jgnUMVYYahQoAtDlHuJ3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3399
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_09:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004160144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 15, 2020, at 1:47 PM, Jann Horn <jannh@google.com> wrote:
>=20
> At the moment, check_xadd() uses a blacklist to decide whether a given
> pointer type should be usable with the XADD instruction. Out of all the
> pointer types that check_mem_access() accepts, only four are currently le=
t
> through by check_xadd():
>=20
> PTR_TO_MAP_VALUE
> PTR_TO_CTX           rejected
> PTR_TO_STACK
> PTR_TO_PACKET        rejected
> PTR_TO_PACKET_META   rejected
> PTR_TO_FLOW_KEYS     rejected
> PTR_TO_SOCKET        rejected
> PTR_TO_SOCK_COMMON   rejected
> PTR_TO_TCP_SOCK      rejected
> PTR_TO_XDP_SOCK      rejected
> PTR_TO_TP_BUFFER
> PTR_TO_BTF_ID
>=20
> Looking at the currently permitted ones:
>=20
> - PTR_TO_MAP_VALUE: This makes sense and is the primary usecase for XADD.
> - PTR_TO_STACK: This doesn't make much sense, there is no concurrency on
>   the BPF stack. It also causes confusion further down, because the first
>   check_mem_access() won't check whether the stack slot being read from i=
s
>   STACK_SPILL and the second check_mem_access() assumes in
>   check_stack_write() that the value being written is a normal scalar.
>   This means that unprivileged users can leak kernel pointers.
> - PTR_TO_TP_BUFFER: This is a local output buffer without concurrency.
> - PTR_TO_BTF_ID: This is read-only, XADD can't work. When the verifier
>   tries to verify XADD on such memory, the first check_ptr_to_btf_access(=
)
>   invocation gets confused by value_regno not being a valid array index
>   and writes to out-of-bounds memory.
>=20
> Limit XADD to PTR_TO_MAP_VALUE, since everything else at least doesn't ma=
ke
> sense, and is sometimes broken on top of that.
>=20
> Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> I'm just sending this on the public list, since the worst-case impact for
> non-root users is leaking kernel pointers to userspace. In a context wher=
e
> you can reach BPF (no sandboxing), I don't think that kernel ASLR is very
> effective at the moment anyway.

IIUC, this is to fix leaking kernel pointers? If this is accurate, we shoul=
d
include this information in the commit log.=20

>=20
> This breaks ten unit tests that assume that XADD is possible on the stack=
,
> and I'm not sure how all of them should be fixed up; I'd appreciate it if
> someone else could figure out how to fix them. I think some of them might
> be using XADD to cast pointers to numbers, or something like that? But I'=
m
> not sure.

Could you please list which tests are broken by this? We need to be careful
because some tools probably depend on this.=20

Thanks,
Song
