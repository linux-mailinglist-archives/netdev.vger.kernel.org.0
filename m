Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B5F41BB7F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243402AbhI1X76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:59:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21860 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243371AbhI1X74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 19:59:56 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SM2Sh1003466;
        Tue, 28 Sep 2021 16:58:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zSRS9qDW4XM8L01lGwqXAMN4ZWo1KOgofrK1K4SZMwc=;
 b=Djq9FdrRYg/swWMSkBjclHzwSlEpcIDcwwq48bDv/iabokmaIovPQM8vQzyD67CcF5rg
 megswa400uD3Bfj8ItHTWZMeq39Bn4tpZemoopdWlTl9T+rKi5Fjjb+1+OvFd5xWwCx9
 Fd4u3Qjrd0JIKMIiGAFZpD8kNVk4GaLNKzc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bcbfhrmym-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Sep 2021 16:58:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 28 Sep 2021 16:58:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2EsXQ2dz+48r55vG93wpGCS/VusRhUaK0P1AVTvg43UQxPhzneaV1ne2F14/eLC9xryecxm10VMdCvo0wEEI5NTS9szvLhbE2wgYuaXtZWwUhc7Nf3QaTN6YgLW7gRMxhmkqHGbienLHS8rfLhkF3fOuHnnJZM9Qoj8mXtUz/e88IaLzNkdpMPHJI+G6+1LfjNBCFLaT5ALDDHXngShaMXBPADC/lYv9QW+YuQL8EkUqSsMDrAZvKXDHLZVt/g2sjZBpl4n2HsMkWXOguxNg/0x0UoYtg54Koh31yvCRj+w8hPSx9u4g5UrUpWc373B3u4ODklfSyKjg2fkQ4wZfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zSRS9qDW4XM8L01lGwqXAMN4ZWo1KOgofrK1K4SZMwc=;
 b=kVwwF+IXIGlnoO6C91nREt2wbGlef1NNpTlugVVzaEAfCJhPynaFv8gzbQpXPASM/6UtA0tb3js91gBiZIxxTX+LoRnVbuBk43wxmiJuz2NKA+WzQuRvLCKy5531CFvUBoGUqt/LGQ3MTrQHjEoL/0bxjgukRhn2jnJeRORvSsyMl8QNwzn6TOoq4z6nunFBoiKN5TBGgZjL0Gsp/ERoJgtfLIsHTb6MxSrlowfqHpuO8ckTpWSS18tGJlgLwQ8ev/ZvafNs0/PNcTZ/PKyiqzly6j3SlufhCdOwrszv89gXxkXhDUAU/Zp2mnJizepaATR0czKzyiu2dA4jHeCbGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5062.namprd15.prod.outlook.com (2603:10b6:806:1dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 23:58:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 23:58:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 11/12] bpf: selftests: Fix fd cleanup in
 get_branch_snapshot
Thread-Topic: [PATCH bpf-next v5 11/12] bpf: selftests: Fix fd cleanup in
 get_branch_snapshot
Thread-Index: AQHXs7ByHWpwilqmnUGjFDm9pSAk96u6If+A
Date:   Tue, 28 Sep 2021 23:58:10 +0000
Message-ID: <ECE882BB-B86B-41CB-AF2A-336DA95A5A4D@fb.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
 <20210927145941.1383001-12-memxor@gmail.com>
In-Reply-To: <20210927145941.1383001-12-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ba67c28-1748-42e1-a823-08d982dbd3ab
x-ms-traffictypediagnostic: SA1PR15MB5062:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5062422438982253D7D7C446B3A89@SA1PR15MB5062.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CfTgMktLz+faHU/O8VMgnEVB2WoL32PkbnO+0opwjgH9dlM5gT1bTJU0jpFb3/O31NziK5WsHvuFmWNRlvmWiH3Op6Gr8+M1YC9R0HWjsCPZN9EELB7N4CJs3eFInIGPY1uxg879vh68gByN2X+K7Ipg84PoaDH9fqVop17YRicOpzpSpepMXj5iaP22VIJJenGadthGgMjDp+h1dGu70K8mZXgYy+kcqiRde6u+Fq1BtjGZ/+3RDUFBsOcy802T9zUWR+tL+s1wR0grLU2vEp9kKWXhNjgvDX/PwpNStUv1hQAr7A+Abb1LHYfgnv3nB+coWCzCKieTIOXyy5FMo/MEQWoG7VLF0zJhkTdEKpqHiG6rIJ0n0Y1Z+M0XKmnLYi8nqT/ZtZNvFKDWmNicgRhDYVXUYaXim3sT2NCctmOTPSn+HcqIbXsaTyR9Cwv5lSdh2pUaBdLj9F4OJxm2OmXZgtlc1vcAIXvJx2CkxDrTLTFPoPsFPjFGF5cUuwnfvTqXSWeD/Mvue6NR6vvtucGlPzCwXHpZy/whap7Ib88n2YooIdQBFarfs5T+SkA+T0ihwFg1rEq75T9UmAzh7HoeauxogEgqrIsi8GzVE0bWY2VczDbXr6C++JVw/SY/sEgf2pVpmiK7/0MFbpw5JZAlkG0U8RXzwo0dsd9kf8kWkZL6OP8xRArn1nBUwWXI9TL7DY/jyMKlUaSKkuF0NmcLMYTYw1wFRNUX8Kh7KE08PkViZ7S3/fphUi2cpZVf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(508600001)(6512007)(4326008)(38070700005)(122000001)(38100700002)(36756003)(5660300002)(186003)(66946007)(8936002)(86362001)(54906003)(8676002)(71200400001)(66476007)(66556008)(2616005)(76116006)(6506007)(6486002)(83380400001)(53546011)(91956017)(33656002)(316002)(6916009)(64756008)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?QSCeU9AL1SU1GJh2UYd8ZtxOqeQ8gC8WB2fsOA3o5sg5FPOUQ9Dl17XrN0?=
 =?iso-8859-1?Q?W4F8izcAsy9uimqaWmir3xHROGA7qEls+qTZX3fJ9fP+lp/uiDgzvJlOQc?=
 =?iso-8859-1?Q?iGIs7fckfHFRPezURAyse56CVxLUUNR3eX6zVDkd/xmpuf7jTHiYC7R/uw?=
 =?iso-8859-1?Q?KjNUpHjtyGN9BfaTfDaevgSTT+IUFhf78uvilZyNp+SQgUTwqyuIuA9AkB?=
 =?iso-8859-1?Q?QM3v1H0qpNj6tm/Ej99tThZ2Yb8evaOSV8tL1wYpSLRJlfMXH0+cDJ9tuB?=
 =?iso-8859-1?Q?HB3+quMf1kKcwSiw0+9icJ7eoL1ejdEFNwn2vbat+FQbI7/bGXmKFNpOlP?=
 =?iso-8859-1?Q?VvHnFhrjar9X9PhdhbYaZzatt7cJICB8ZLxYfyAtcgVrUVkOThXClGbUmr?=
 =?iso-8859-1?Q?ua+fBJsNaVG83bidB6J5ASyhDzyip1q7BCCK6dAUP6uSuFyEah72oEyIh7?=
 =?iso-8859-1?Q?QPt8Zsai6Mo+607BT3sIQcpvCrFudopjRNEk/TysPc5gC7JuN0VK66onln?=
 =?iso-8859-1?Q?qswzYYGXILALuFe2Mjhem13/kBePLQ7u4hElK9L9WJsnrSEJK6hmRyR2dA?=
 =?iso-8859-1?Q?Sqm3cPhiLMEOX7VIv0EhsDuTxKRBgBwTndX6mAR9TyVt3VNEWpeHpThwcJ?=
 =?iso-8859-1?Q?kaR2EyclLCufXjA9pbmZ/kKCtmf/SPQODk53eZ4XUZoSgZueNF+k0X4LK5?=
 =?iso-8859-1?Q?tVp1IM3LYsQ+UECjrl8GaGNwT1Y5BIugtUmuMekj1mRIDYGwLFvZOBaJ8f?=
 =?iso-8859-1?Q?cQNPfKLLNSPcE4kG1OootQ/MMvkvlM8Cc4nU8R4JcvYukncG3MBwLXa5F3?=
 =?iso-8859-1?Q?q5W/CxNCkC6FMX6uwSYkk5N7e0rlj7s18gv5N5ulhcjNfJPvVXrTyLpsHQ?=
 =?iso-8859-1?Q?FRh4PfgOTZFe5sTWK2vz5i/t8VBVJkl16ug5vmTGThTusvVH1ZqfgV5HBL?=
 =?iso-8859-1?Q?Qvvu2hhcHfCR1bkAWDmpw8OLPDZlCDkI0B6OlHFVgfw7sPfjqsh8dC3PYh?=
 =?iso-8859-1?Q?J+6p+rw5ac2Rk/IgNpnAsh4FJXW2iDrpURefO5UbistCaoFI4jn0cGKGvH?=
 =?iso-8859-1?Q?9j77v9Pd64W0leXWnFtkitE24lMxa75xP8JIoUFyqhmtIIA94iMOPoAZhC?=
 =?iso-8859-1?Q?LdpiOK3MGoL5uRIfFtb1S/YTOomdFMrKwky3biWTDC/6eV/deLtHXDSLVP?=
 =?iso-8859-1?Q?EbtwJ3j0gbUtSyif3e3TSy4JC1W95KekIJC/eOVie5b8ExCYIlml1wWKkJ?=
 =?iso-8859-1?Q?xzX6PtL1BeRLxfY3NWJfA2St4l1FmGR7fpkD0Cf8g8ZDdG06oCSybxtU41?=
 =?iso-8859-1?Q?MPlPOziB/OmX9w1K+v2FO49IYqCoQqdJFgAZLZQ3BuZK0CdIp3Yb1MLAHI?=
 =?iso-8859-1?Q?8dfd1xhdtEU552SzgWx2UWYBwZqpnxfFvYSMZ1+Apv8ujN/fKB2hE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <B605783900807E46884BADE3FD8B67C2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba67c28-1748-42e1-a823-08d982dbd3ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 23:58:10.8484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 90CosWt8S9fDLGO3ZTbasj7o3NyrddtIh5CsSQQIpTX1+2as17uM8C76ftRrVCmYch0ZCIrrrMKKhC0ftwOcOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5062
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: RjSKlrkq5-0pxbxbR5dubtGQhmTrtTGE
X-Proofpoint-ORIG-GUID: RjSKlrkq5-0pxbxbR5dubtGQhmTrtTGE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_11,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 27, 2021, at 7:59 AM, Kumar Kartikeya Dwivedi <memxor@gmail.com> w=
rote:
>=20
> Cleanup code uses while (cpu++ < cpu_cnt) for closing fds, which means
> it starts iterating from 1 for closing fds. If the first fd is -1, it
> skips over it and closes garbage fds (typically zero) in the remaining
> array. This leads to test failures for future tests when they end up
> storing fd 0 (as the slot becomes free due to close(0)) in ldimm64's BTF
> fd, ending up trying to match module BTF id with vmlinux.
>=20
> This was observed as spurious CI failure for the ksym_module_libbpf and
> module_attach tests. The test ends up closing fd 0 and breaking libbpf's
> assumption that module BTF fd will always be > 0, which leads to the
> kernel thinking that we are pointing to a BTF ID in vmlinux BTF.
>=20
> Cc: Song Liu <songliubraving@fb.com>
> Fixes: 025bd7c753aa (selftests/bpf: Add test for bpf_get_branch_snapshot)
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Thanks for the fix!

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c=
 b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> index f81db9135ae4..67e86f8d8677 100644
> --- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> +++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> @@ -38,10 +38,9 @@ static int create_perf_events(void)
>=20
> static void close_perf_events(void)
> {
> -	int cpu =3D 0;
> -	int fd;
> +	int cpu, fd;
>=20
> -	while (cpu++ < cpu_cnt) {
> +	for (cpu =3D 0; cpu < cpu_cnt; cpu++) {
> 		fd =3D pfd_array[cpu];
> 		if (fd < 0)
> 			break;
> --=20
> 2.33.0
>=20

