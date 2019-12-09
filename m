Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9258117270
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLIRHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:07:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12372 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbfLIRHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:07:05 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9Gubi7002152;
        Mon, 9 Dec 2019 09:06:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=R6dpOr4g+UDDKrwR4wUtouqGLYprtcBJp8LJ4XPhF+U=;
 b=BCFHKQ9mh/HdA8rEAZfEvMZFbIZgm0qmQNFHgENQuALa3+LmWBuyFuK0Jfjxi4CZv1Qq
 1pFp+iZOjnCauBl66LGgTPwG0oYvpv1EgJq7sstCmunDpuA9k4b6GeEcw2jIF5OjDHfc
 0RV5whtC4/ZswE2x4Au+rU/fEdKwp0G9t98= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrbrh9epv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Dec 2019 09:06:51 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 9 Dec 2019 09:06:49 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 9 Dec 2019 09:06:48 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Dec 2019 09:06:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGhJxcpghGugvy3NMciaJE5I2gnR+k22+xY+n0lestDbwUe2IX/kRlUiJc5FFDbRHwfSId8jV2Qslh6Aqcjn5DvTcpb25oJMgRVouTZYhXAcCD5OP3s5oHVTYR6ZZKPvBqUoNoXY56FgUoK3ite9vxNRKRn5yPKGdZcZXRq4O0xwFdlB1tRcuv/QEwXn14MD9HAdJ3AUKHlOwv2cgpQEqQhoozc6/LaI7k/AYMfmPZNtahodVk5k5c+CeKzN+qCx0eohHKURoMlG09I+2/htCy8W5ke7dCMzaVFU6L+j868UzLpHcmKIHfgA2sfuXxOy76SWcjyXKJYse5IC2SHI2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6dpOr4g+UDDKrwR4wUtouqGLYprtcBJp8LJ4XPhF+U=;
 b=Y8T0YNcy/nM82TA3EMsbXwUDpqcKAsw7z3Ay04Yvl3Z+85Lvx9RmK84lTW5XDICtGKI1UZG6BM9kYhS9ifzHZAfthXjm69A8zagCXjRTxIH6+E/6bYjUEFDnzZMs3QItPvFWOhyHqlkbJB2wUy7FHE7wzdJX8IIOuQpx8HiIaW+ZhPG/iWREIDssf8SKhH8poqkYnhA3wjx754Vtr4v12SaDOIXqhTJ7nOL2Pu08kOtu3hNwpqnsXfC1s4jbMsDDy2eO9EDntrS8akQZt0fqDxhq4srZHw2u5r9v8GQ6qgdL9lCN9RGthdRNRQkAQVvnVLONXwXTssYTvgJpKyUtJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6dpOr4g+UDDKrwR4wUtouqGLYprtcBJp8LJ4XPhF+U=;
 b=TXfaWXlnK7+P5zo4aH+vceJLI9NDE9ut18tAEKCM6euNYHhhzzZcEpB6XhWdcfWsAkOHVQD+MkdIp20lPXi+jG3Kc7qfqtMeQ9r/u5IaxL45okCX+k7QrTFSeEicuWljfHxLTdpc+nc7WTU5G04sq6bNKwI2OCO34hUI8ufL5FM=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3135.namprd15.prod.outlook.com (20.178.252.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Mon, 9 Dec 2019 17:06:47 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 17:06:47 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH bpf-next v2] bpf, x86, arm64: enable jit by default when
 not built as always-on
Thread-Topic: [PATCH bpf-next v2] bpf, x86, arm64: enable jit by default when
 not built as always-on
Thread-Index: AQHVrqKGbB2PV2jnH0qredTuhIn+XKeyCMsA
Date:   Mon, 9 Dec 2019 17:06:47 +0000
Message-ID: <20191209170644.tgsqlwaei3cf7sgi@kafai-mbp>
References: <f78ad24795c2966efcc2ee19025fa3459f622185.1575903816.git.daniel@iogearbox.net>
In-Reply-To: <f78ad24795c2966efcc2ee19025fa3459f622185.1575903816.git.daniel@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0082.namprd17.prod.outlook.com
 (2603:10b6:300:c2::20) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:b5df]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7e06da2-395f-40c9-a8dd-08d77cca2ccb
x-ms-traffictypediagnostic: MN2PR15MB3135:
x-microsoft-antispam-prvs: <MN2PR15MB3135E8F6E9AFD316DE616330D5580@MN2PR15MB3135.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(39860400002)(376002)(346002)(396003)(136003)(189003)(199004)(4326008)(86362001)(66556008)(66946007)(64756008)(66446008)(478600001)(229853002)(186003)(66476007)(1076003)(9686003)(6512007)(6486002)(5660300002)(54906003)(33716001)(2906002)(6506007)(6916009)(52116002)(8936002)(81156014)(8676002)(316002)(305945005)(71200400001)(81166006)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3135;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yz1ZdOJjbSZy9/bJm04VRuVyr7HDZ/t9GBwJXnyWeTqakQvceZZJVZYDfWJb2DOaaefl3PwCElhha1ISS5PVrqKzbITXo0jE5XN2kvYGiQiALuSWPz1eSGB7DyNhXLPR+MvL+I3M4zcQxpJX/1rz0dECiHiA/au6kYAzuuJ9tU8k8jxB0RA0XjzRtWVgzGYxc3PcMGrFqJHPE1BkF08/56VwOsq4h19cyW/pu6o2x3gx5fqfh8thmXqKWqGiC4Q4+OrP6QLCGT/NAHj/xJ+f8izjzQwXRrFNNT5lN2ALGT5SwNeqyPlKhHCO6UWM7aLe8Atyhm3bulf1T3aaM9y1CctE2A2RaboCx6vAq/xB/D0q7Pjc7fUK/9k8mpbPj/k00B3vWsYv/MUp9iev/Zdt65hOKbeldWUSXGaN8hwGxWdkKGu+xJrdD4yzf/3QnWZf
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F72A3D18C080CF48B79301FB45AAFCCD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e06da2-395f-40c9-a8dd-08d77cca2ccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 17:06:47.5745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N4MgM1qvdIhQCOi/tHBcyFgHaSn4YIZ7f71oC8S9yJ0fkLV9NgrfQD3UnaDb4Mx5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3135
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_04:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1011 mlxlogscore=698
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912090142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 04:08:03PM +0100, Daniel Borkmann wrote:
> After Spectre 2 fix via 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON
> config") most major distros use BPF_JIT_ALWAYS_ON configuration these day=
s
> which compiles out the BPF interpreter entirely and always enables the
> JIT. Also given recent fix in e1608f3fa857 ("bpf: Avoid setting bpf insns
> pages read-only when prog is jited"), we additionally avoid fragmenting
> the direct map for the BPF insns pages sitting in the general data heap
> since they are not used during execution. Latter is only needed when run
> through the interpreter.
>=20
> Since both x86 and arm64 JITs have seen a lot of exposure over the years,
> are generally most up to date and maintained, there is more downside in
> !BPF_JIT_ALWAYS_ON configurations to have the interpreter enabled by defa=
ult
> rather than the JIT. Add a ARCH_WANT_DEFAULT_BPF_JIT config which archs c=
an
> use to set the bpf_jit_{enable,kallsyms} to 1. Back in the days the
> bpf_jit_kallsyms knob was set to 0 by default since major distros still
> had /proc/kallsyms addresses exposed to unprivileged user space which is
> not the case anymore. Hence both knobs are set via BPF_JIT_DEFAULT_ON whi=
ch
> is set to 'y' in case of BPF_JIT_ALWAYS_ON or ARCH_WANT_DEFAULT_BPF_JIT.
Acked-by: Martin KaFai Lau <kafai@fb.com>
