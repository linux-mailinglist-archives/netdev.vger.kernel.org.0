Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8B6AA7FE
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbfIEQJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:09:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17000 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388167AbfIEQJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 12:09:15 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85G4Jwa009425;
        Thu, 5 Sep 2019 09:08:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HmdCIrboWkM9rUDFDSHelcJxJIvcYEcwzcIwg5HXSv4=;
 b=Nvr1CwMdhk5yTP752OlBaag9+s9vu7xtzAJh9L/y9KbfDZ6hBVXhBuooI2Rk5FQVq/mT
 oSOe8zV6Y7/Qshq3LXqZf61pVDiWWTBtRMMWcToZj5tJVfBTCsLIhezMYSqhOwaEkBHa
 4sIS54SSPAGC2u5VcDUB6vERhCjjdztdfmc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2utqxfk55h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Sep 2019 09:08:46 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Sep 2019 09:08:45 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Sep 2019 09:08:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDNDT1P6NUNFaYpIJWwA2kKU98bjWpweFAphE37ukYQY7BXd53XRGBughtlG3B9smXGCjpsNKk7uFTKpoxQbBHjWs8/W2VS0/Xb+QyhZXL3Y6Z5HjksVWkPcx0PrKe7WUA5BcIBegc/FudgVvTULBWryodAy9QuxhNxJXqK3cP6J1Rt76fXooRkrdiXKLvsFId/JJcGPby96BXhb8i2bI6NE2wvu4v2Au+cPpipPJGqozRGyxldJnHbajLaCsZstEgotSEohoqNy2gWHtN4SHZpGxIYuOPZ+Y8y6gHeSAso0A2YfuovnJT8XXC8nyKdK1oyDaKbrz3z4keYJyv5WAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmdCIrboWkM9rUDFDSHelcJxJIvcYEcwzcIwg5HXSv4=;
 b=QI3h//HARrEhJeUTj96jjTzSU/ffuCOnja7/rAkDZdTeKFFL71tsF2kWZA31QxyqChOsuq4fUIcAkPDfe31jPUuerVpq5utc92usAmTJT/1VanggEfymKM3Hx53QViyGCE7v3VcB6MXQ5AV2+BulVy2VH4qzdMubD9MmkAZ3L4WgkUsHtXT8/DFtBCZ0pFu1IDDPMRsqZf+bgtF2h5iQ/yVqUy0/P5YBNyEwAK4SL4+4YpXU8+ngjy8KhD7bCwGOqURdH1iQrtdsC8Eq7rLnBd6QqJql/L6UeeFO3U+yJ1wkpRyJMArgPaHzGBL2+Sk1j+WFAjzgTvh9h9qCbRs86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmdCIrboWkM9rUDFDSHelcJxJIvcYEcwzcIwg5HXSv4=;
 b=IcLFG45sga9sEnTnd1KwMjFeON3NbdIcyv69Xn/iGdKRfMPs+SnMbmRwOy9JOcJOgR3YFB0u0iMF+VL0wK2HEk7y81i3BMpikyR8rgbKW9DFNtVB4JcZDXBUS4ERJNq+3+eD0NfNwK8Yn82EpA45U0FR9uWBMBn08bcCCnPE/RE=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1616.namprd15.prod.outlook.com (10.175.142.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Thu, 5 Sep 2019 16:08:44 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 16:08:44 +0000
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
Thread-Index: AQHVY1Cvn0QzeDIQmEifJi8CsD4pqaccPMEAgAAQQQCAABYXAIAABpEAgADYFYA=
Date:   Thu, 5 Sep 2019 16:08:44 +0000
Message-ID: <A0BD5C17-3118-4C90-825F-23CE187209EA@fb.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
 <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
 <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
 <E342EC2A-24F6-4581-BFDC-119B5E02B560@fb.com>
 <20190905031518.behyq7olkh6fjsoe@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190905031518.behyq7olkh6fjsoe@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2:b3a5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b028d633-26dd-4ce8-53e6-08d7321b538e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1616;
x-ms-traffictypediagnostic: MWHPR15MB1616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1616B4295D5ECE5ED6D17791B3BB0@MWHPR15MB1616.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(71190400001)(57306001)(14444005)(316002)(256004)(54906003)(71200400001)(6916009)(76176011)(8936002)(5660300002)(102836004)(8676002)(6506007)(86362001)(81156014)(81166006)(53546011)(4326008)(50226002)(36756003)(6116002)(25786009)(446003)(46003)(476003)(7736002)(11346002)(305945005)(2616005)(2906002)(486006)(186003)(99286004)(6486002)(6512007)(6436002)(33656002)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(229853002)(53936002)(14454004)(6246003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1616;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0T38qyKJCGtdyNt7e6VdpHc4iBJ7YfkoeznQ1Q0QtcEtrCqh3bK98rKg5AIcR04Y1LwrvKrdaVcCiIcWlhRSXJGP9oHo8+kEaPqrscpqLtuRkTHp1cTaZoL4cZcqh7mbrabuP77GBKI2MZ3+lJEhT26VHnFAhUkQqlkCFFNaT8eyBGBxtBldYiBx1neCkwSOM6weo7OH3tsW8Ebo/41M/mnU3lXmGQEvTapbPzphdjqyGqLbiYEsF8RUEidKbJbzXHfB/YwVpwDXoJgFHy0Egacf3Lrpj9MxSzZ0uNNgGivn1cR+BFwcC9GyiQshNXV65rvgaJjyURGVGod0WU4Ud8BNGM4KrRTWNxFuICum0jSwOhAiUJjz0bgrS4LQhJRdeV4FT7/YBHSn2VpHuSQaAu4TSDL7CI989DoxZXiwI6s=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A33147E45FBAE45A2DA4C175F6E64EE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b028d633-26dd-4ce8-53e6-08d7321b538e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 16:08:44.1077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /gIcgxvTiHOpkqKMzYgpmyxcGzEpm2hU7eD+0bHwXlyBjNBdl42sN2161iGf3h3YuznkNgXbKJo28nFpTYwj7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1616
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_05:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 clxscore=1015 adultscore=0 impostorscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909050152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 4, 2019, at 8:15 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Sep 05, 2019 at 02:51:51AM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Sep 4, 2019, at 6:32 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>>=20
>>> On Thu, Sep 05, 2019 at 12:34:36AM +0000, Song Liu wrote:
>>>>=20
>>>>=20
>>>>> On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrot=
e:
>>>>>=20
>>>>> Implement permissions as stated in uapi/linux/capability.h
>>>>>=20
>>>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>>>=20
>>>>=20
>>>> [...]
>>>>=20
>>>>> @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr=
, union bpf_attr __user *uattr)
>>>>> 	is_gpl =3D license_is_gpl_compatible(license);
>>>>>=20
>>>>> 	if (attr->insn_cnt =3D=3D 0 ||
>>>>> -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT=
_INSNS : BPF_MAXINSNS))
>>>>> +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : =
BPF_MAXINSNS))
>>>>> 		return -E2BIG;
>>>>> 	if (type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
>>>>> 	    type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
>>>>> -	    !capable(CAP_SYS_ADMIN))
>>>>> +	    !capable_bpf())
>>>>> 		return -EPERM;
>>>>=20
>>>> Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_=
SKB
>>>> without CAP_BPF? If so, maybe highlight in the header?
>>>=20
>>> of course. there is no change in behavior.
>>> 'highlight in the header'?
>>> you mean in commit log?
>>> I think it's a bit weird to describe things in commit that patch
>>> is _not_ changing vs things that patch does actually change.
>>> This type of comment would be great in a doc though.
>>> The doc will be coming separately in the follow up assuming
>>> the whole thing lands. I'll remember to note that bit.
>>=20
>> I meant capability.h:
>>=20
>> + * CAP_BPF allows the following BPF operations:
>> + * - Loading all types of BPF programs
>>=20
>> But CAP_BPF is not required to load all types of programs.=20
>=20
> yes, but above statement is still correct, right?
>=20
> And right below it says:
> * CAP_BPF allows the following BPF operations:
> * - Loading all types of BPF programs
> * - Creating all types of BPF maps except:
> *    - stackmap that needs CAP_TRACING
> *    - devmap that needs CAP_NET_ADMIN
> *    - cpumap that needs CAP_SYS_ADMIN
> which is also correct, but CAP_BPF is not required
> for array, hash, prog_array, percpu, map-in-map ...
> except their lru variants...
> and except if they contain bpf_spin_lock...
> and if they need BTF it currently can be loaded with cap_sys_admin only..=
.
>=20
> If we say something about socket_filter, cg_skb progs in capability.h
> we should clarify maps as well, but then it will become too big for .h
> The comments in capability.h already look too long to me.
> All that info and a lot more belongs in the doc.

Agreed. We cannot put all these details in capability.h. Doc/wikipages=20
would be better fit for these information.=20

Thanks,
Song


