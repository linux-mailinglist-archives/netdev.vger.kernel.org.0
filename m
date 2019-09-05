Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0266A9896
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 04:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbfIECwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 22:52:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24092 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730780AbfIECwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 22:52:24 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x852oIVE019773;
        Wed, 4 Sep 2019 19:51:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/XSmviBsMqSly6iBKt9wd5aTOwXpqXldqAvFWlMlR7g=;
 b=RFtkSP6XQBk8iAhmOMzciiJ4/ldiihn9phlg6xhkOBp0Gv7vwj9cKNLG3ucRsoVWPqtm
 J9kCZQPVp/7SBUREMuZLGFKr9PZOfnV9lUowA49Ly6NNxLV/EM/z6Q6crux9RBShuBBV
 Wb8AcIfzAg3YkZA3usxqV+4TdUQv13wfl0E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2utknmhh0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Sep 2019 19:51:54 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Sep 2019 19:51:53 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Sep 2019 19:51:52 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 4 Sep 2019 19:51:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8wWFBmlcSmMxmj0jN9dtkqYRGZZ34+fuq5Gk05ox9xV3afiv/gBLjbhZOzowU7XLdzvAVYdgKsGgAEmllCxkFE0CidWfwYBd5tQ+aHccFbUyBMQDhY+Q1u5bX9rfdpbG1BMeFLaXjdn0eeuFKIAlVx/RC4nvGFamrsdV3CvkPnFlcqzHw7lWKuXi5rC3C6aANUIwZCPpGyp48Bpy+7ItLiRjp6vUcTdQZ/lY6mgCdJZ2PjsTXW1cjYFaftFjLuOKbTwidNqjdIeYMxHA90qZ4wX/OOc6g/BpwKaublqPql/ZdyxubQi8qbuYgutUK30JI924dpdbxQPEb0nUZgLKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XSmviBsMqSly6iBKt9wd5aTOwXpqXldqAvFWlMlR7g=;
 b=BbemDYLQmBuFLCK90H1mMjxhhE3lMI/oEQOK40HVaV5M/XolnCqgx4lk0sM+AmHSLdFaVuuGqxd8HPBkkMS3RSfdp9FylRTeeiFHOj4EZm7RkoTXU32YyE8tnNpgayy8Hl0JMsuVSCIRH1a/DPXIFhOOvaCMluX1TYVI7wykApBZSZ+r4pRmiBmOHM5WmlPXJNJsEh6vFuUPSCVv6NNpmk+Mxv5HlPj5e/W4kKtMKkRqDX8JL+Pb9UqBr5U4UVnF/BOfaKHML1yt5nT9pceuSWfq5g1AiN5DMqoem4RspzghA5d+XiH5R/34m6oLzvibcp/MJbiA7M3itVf1MXBtww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XSmviBsMqSly6iBKt9wd5aTOwXpqXldqAvFWlMlR7g=;
 b=AgCQxaD0iEk/6JNvZF28TmQUvHuC1VuX0jtZ+NSK5HwTF75+5roFxOQSYXWVcnFEYwW57qrKA/HRjOuB+3Tslc+IbVtQtf6IGRh/EguA4P2m4My/yzm4//zIK1vFlvvIBzfmvacaj85Ov2a8yT1XxasGvQcXfy4ZUxmMNkwJY4c=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1871.namprd15.prod.outlook.com (10.174.255.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Thu, 5 Sep 2019 02:51:51 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 02:51:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Topic: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Index: AQHVY1Cvn0QzeDIQmEifJi8CsD4pqaccPMEAgAAQQQCAABYXAA==
Date:   Thu, 5 Sep 2019 02:51:51 +0000
Message-ID: <E342EC2A-24F6-4581-BFDC-119B5E02B560@fb.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
 <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
 <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1bdd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d7905db-2dd8-43fc-45c7-08d731ac00d1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1871;
x-ms-traffictypediagnostic: MWHPR15MB1871:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1871F016904CA74B1FAB5489B3BB0@MWHPR15MB1871.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39860400002)(366004)(136003)(376002)(189003)(199004)(14454004)(50226002)(81166006)(305945005)(86362001)(316002)(76116006)(57306001)(8676002)(81156014)(64756008)(66446008)(7736002)(8936002)(6246003)(486006)(54906003)(6486002)(66476007)(66556008)(6436002)(446003)(6512007)(36756003)(46003)(33656002)(2906002)(66946007)(14444005)(53546011)(6506007)(6916009)(53936002)(5660300002)(25786009)(229853002)(11346002)(71200400001)(71190400001)(256004)(102836004)(99286004)(4326008)(478600001)(476003)(186003)(6116002)(76176011)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1871;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: adshxj9c4DjJv2cXlM8GzY5qkn+0GcdW+x2Y46l8DZ/5nzC2TmBzN0t1VsoCSMuU/rrTJ+zuxbQzc3KAWFr5hNZP9ZMpF39NDtjqzE8HmjW84UU3V6wH37dqPJk9riGTESVw+XYe53jXZtRa1kpG8/VUvgac9PtHQus1Q6W0QU38rE62roMMOv85mLQBYpwpkuH+taCObTEHofTD7CR1ORa1s8b5fhBDK6VhVxEe4p8teUHlOdzRigp4IFEfQDq2+dXGvD5V1Jvnmpw65Ip7tBlmCKFGr6a1SuHKSkH6ryTr+94U3j/BmNmCzUSZBvBzdBft7nN9TUXNeMXpa6nJyRN2G2UxQ6ZyCfotgHj5hAEIEkQLkHtZHbW6SPI5V2HkFIzWAVGy5Wu0EU5dET7BhXOQJhzZGPzM006jASOkByI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1DB836E0E5592C479D9DA2D528334C1A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7905db-2dd8-43fc-45c7-08d731ac00d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 02:51:51.2436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 12cTpQkpE6mOVbRj78QsOY0cBJxlhPjXYgRERpA4aHIYnE+pa0bgk4DJvrUQBChludOEvzDoDYAfjQDRj+d+Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1871
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_01:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909050030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 4, 2019, at 6:32 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Sep 05, 2019 at 12:34:36AM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrote:
>>>=20
>>> Implement permissions as stated in uapi/linux/capability.h
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>=20
>>=20
>> [...]
>>=20
>>> @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr, =
union bpf_attr __user *uattr)
>>> 	is_gpl =3D license_is_gpl_compatible(license);
>>>=20
>>> 	if (attr->insn_cnt =3D=3D 0 ||
>>> -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_I=
NSNS : BPF_MAXINSNS))
>>> +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : BP=
F_MAXINSNS))
>>> 		return -E2BIG;
>>> 	if (type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
>>> 	    type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
>>> -	    !capable(CAP_SYS_ADMIN))
>>> +	    !capable_bpf())
>>> 		return -EPERM;
>>=20
>> Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_SK=
B
>> without CAP_BPF? If so, maybe highlight in the header?
>=20
> of course. there is no change in behavior.
> 'highlight in the header'?
> you mean in commit log?
> I think it's a bit weird to describe things in commit that patch
> is _not_ changing vs things that patch does actually change.
> This type of comment would be great in a doc though.
> The doc will be coming separately in the follow up assuming
> the whole thing lands. I'll remember to note that bit.

I meant capability.h:

+ * CAP_BPF allows the following BPF operations:
+ * - Loading all types of BPF programs

But CAP_BPF is not required to load all types of programs.=20

On a second thought, I am not sure whether we will keep capability.h
up to date with all features. So this is probably OK.=20

Thanks,
Song

