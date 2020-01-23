Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BF5147370
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgAWVyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:54:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45522 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728899AbgAWVyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:54:25 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NLqE0f029303;
        Thu, 23 Jan 2020 13:54:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ffswxkbw33QmyI7VE9zIj74O+WAy5Ga3Q/k9yhu6viI=;
 b=N8AS05vHPetT1ch58ExRMJ8hM+211bVdSwbUI9GMH0GgDxmHUtaJj24vNWjyVPyCqbLa
 PaHezPbValAgAo+pdjGnYr1JLbgAUKw3Ka7bsFZpGwpiEOTGHc4AYBLaTrgqRcEeYDHL
 PbFWux1/0se1d/d9TmwcloYVeXlGZ8rU2rs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xqemehm86-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 13:54:10 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 13:53:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEzQVgddDzpnRNzUtsm3sGIhUlhn5b/dzldolcffA/VBjJt9dqZTiWrVe2U/fVSwMyxIFgVZvzlX0LdAB+bddcqOWnEE7pzsefAm0mI8VM9NXOtQb/3s5knTeeZ1Dp3GCY9p1vhbo5mXuheGNijQVrVmEDThsIkC15me+uzHWTkiTGXQ+KzGr9mJrLoR5hCP9LJtENbSZyb9zYGl8kAgCjV+83gLkXs3Xa0r/l4+Rzp4Eba6rHehP90xkUEKKuqYHGQTv1FkfloQ6B6vCQRV8by4Y3/Op1o75MopxIb4RVFnZ+VmlLOY3wfjODlqEVuJH6TUK672SOrnIsEzYzW1Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffswxkbw33QmyI7VE9zIj74O+WAy5Ga3Q/k9yhu6viI=;
 b=BxhrblyngYUbxnBlan64OgIe6fy18W0b+Shy5dGn+6Bj/T8GjUZjDFaIDEVyEQTpnmT9aLx3b3m5eC44ge/yfl71uV1bcxn/L0ra3nQHO+kFII5QmV9Fxu6RYD+M0Gjc1AiHh2XxpRcHGcdVLSzQ2WtTmWLLU3W6cjHESfvsxLVIbjF25A+S2gNkrObVFOlLRxb/AAY03FSzULOlV4eI7tH/jxzsKXblipVw7MpouKtUXosHtTEq9Y8aeEaLns9lhrHJnDKcDTid4TwJjTF79+DVEPr6nT4TFY9iuP7fnepA872BvoCxkp3KK8rIUi4gl7pJCZJAhmObdCU8Ig807A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffswxkbw33QmyI7VE9zIj74O+WAy5Ga3Q/k9yhu6viI=;
 b=Eba9Y1V5K7pjvJMrJIH5leNiQnBvu/oqHXgEgYPeFg+chs7Uyso25m6wbc8RMMX8Hr7m561MR78uqEYVR3WFVpHgfCQcG7Y4CYg1uG9T6Dkjvt/dzjfixMrsMj5DiQLj3XS4hegO+AxT6BBCDMNHJaY+V/AGvbvWUox+X1M1xrY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3741.namprd15.prod.outlook.com (52.132.173.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Thu, 23 Jan 2020 21:53:52 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 21:53:52 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::2:d66d) by MWHPR21CA0037.namprd21.prod.outlook.com (2603:10b6:300:129::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.8 via Frontend Transport; Thu, 23 Jan 2020 21:53:50 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf 2/4] selftests: bpf: ignore RST packets for reuseport
 tests
Thread-Topic: [PATCH bpf 2/4] selftests: bpf: ignore RST packets for reuseport
 tests
Thread-Index: AQHV0g6NwgtJo3iSuUOeG+lkP8Lweqf4yxEA
Date:   Thu, 23 Jan 2020 21:53:51 +0000
Message-ID: <20200123215348.zql3d5xpg2if7v6q@kafai-mbp.dhcp.thefacebook.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-3-lmb@cloudflare.com>
In-Reply-To: <20200123165934.9584-3-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0037.namprd21.prod.outlook.com
 (2603:10b6:300:129::23) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:d66d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7872a064-d5ae-48cf-2f0e-08d7a04ebbfb
x-ms-traffictypediagnostic: MN2PR15MB3741:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3741E95DC7D1A210915F123ED50F0@MN2PR15MB3741.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(396003)(39860400002)(136003)(189003)(199004)(71200400001)(316002)(6506007)(2906002)(6916009)(8936002)(86362001)(9686003)(186003)(16526019)(7696005)(4326008)(54906003)(55016002)(52116002)(81156014)(4744005)(8676002)(478600001)(66946007)(5660300002)(81166006)(64756008)(1076003)(66476007)(66446008)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3741;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RKos86YICvFbX/60zuj8itj36fLtC4zj13/Jvxv1zIUGr5V3WnerNyLmN9MpB6QyOCVradUbthQZ4GLcFDEyfGUx+BduKNNJ4FnZo6/BIPvv6sdBvfZYIyAOYTqWlx5461q3Iqugxxmeior4BjcuGP+3kv+lq9C7mfKiJuK4vQmEuHkNrbvuBtpgeERKO7nZKMuzv6yqLi7YJ/kTSeDkICV2kuFN6chIFZ/YvTnNP1bfqKHtcH37xavB8eFzfJ+PQgZ8NbACHrlU524v/4MPst8pG76bLh3voCZc4MHNFVjMAVp3rRKoPNspAVZGtvqxFwAMEPL37SO94OffeU32/LxdTykUgogluGSRnKtuclGw5rRY/unZT/scPJ8hDQqF3CPteGn082CwDtmKTlvXCay2OhUb6iqBPTPJtnJul/2OOFhpd75qbnUPw7S1sw9p
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A68A724B88B69458192663067C9A9DE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7872a064-d5ae-48cf-2f0e-08d7a04ebbfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 21:53:52.1456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ho9VcVXXhgvypFh488KDbW3+7zuAIXRz7hvlxVoRUAUVZAG+VHOWK6biXmzoJp0E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3741
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_13:2020-01-23,2020-01-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=560 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001230161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 04:59:31PM +0000, Lorenz Bauer wrote:
> The reuseport tests currently suffer from a race condition: RST
> packets count towards DROP_ERR_SKB_DATA, since they don't contain
> a valid struct cmd. Tests will spuriously fail depending on whether
> check_results is called before or after the RST is processed.
>=20
> Exit the BPF program early if FIN is set.
btw, it needs a Fixes tag.

Patch 4 and Patch 1 also need a Fixes tag.
