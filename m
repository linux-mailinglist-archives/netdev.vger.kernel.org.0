Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA8C38B59D
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 19:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbhETR6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 13:58:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5862 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235086AbhETR6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 13:58:09 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KHYhrI005043;
        Thu, 20 May 2021 10:56:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=eKJtE3tBu1W38yyQgW0oEkNnYGsBqk/NTTEvpKTrbXI=;
 b=JHtbXN9g+2WBOUUXOvI2PjTTEP/9cWR2E9owgi8D39GiZlAoPq8R0Yv0opGn6H4cK4yS
 YY0UjPL1dCJgjtbi6DxwC9bkGVm8SKU1iyxwr4CA0rLjBNQfL6KNqQQ7uIGK7NqHShiQ
 r5urzkpE03Gk96SmkDnzm8b4h7Db/Aq8Bzs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38mync1ut2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 10:56:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:56:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GME5Yzz1nMlDqycR2MdtCosDWrGu7XBnbNZzATiU1fdpunET9a22/uFKyqMM4lFyR+khlyQBtV9UInxguxlhfrx7ECyDtLLVXDtndHW3FPPWXRkzlRlBWVKAHVuF+GWX4Zb9fUHPhsNoNz+U2/XoH5avP/4pIg9YFU5VG7MbkKXFS4kHgkfW/D0dLExropyJDFKc08la+7TYo/W7Ax41VGbYgdgG9m7YHG1edtlFTchH7Z3zO5/K4ygpwy5Zhp9lh5ZUBb+obn9vN0DSVvuVTpceYWxM8yjVNNk3lxEU6qoMN/KOJqX/Scbnvwvdjt5XWJAq1bEfY9ETjdc/pkRJSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKJtE3tBu1W38yyQgW0oEkNnYGsBqk/NTTEvpKTrbXI=;
 b=lnFsdhN+wgUJJyR2t9Mx5RWgqinoxvZHyPJ5n2BM2Xs5xl6OemV7/NuiSbHA9dUhtElKR1K/dDKpkV+kZ5XSeutBqigVUMK/n/BTbyxvAEJHHlsHzc5N1G49Fv4ANdq1ok2RWvglo51l1kvPeivCpLKmuQ36WAVs3FBBa0OJ9tTEkOZuy8MTGfu+jYXoQ0MdtFnoIpFgIIsKMO2S1SX6RBGYDdv6RXoXX+fMmuZmuqWGlvgAUY368XP5o4fWb785m4pM2FBXW6dnUVSNd3mx+igf4HREpzxh9sBRcVE+YkjqqEsNJmpniiZD7m3sxiWFECMK/7Y9uz88j38bz7s6uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3207.namprd15.prod.outlook.com (2603:10b6:a03:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.31; Thu, 20 May
 2021 17:56:30 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 17:56:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Dmitrii Banshchikov <me@ubique.spb.ru>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 00/11] bpfilter
Thread-Topic: [PATCH bpf-next 00/11] bpfilter
Thread-Index: AQHXS2+BfiCEtb8dTUOLdshZKTKHZKrr0aKAgAAx6YCAAJd2gIAAEQuA
Date:   Thu, 20 May 2021 17:56:30 +0000
Message-ID: <2D15A822-5BE1-4C4A-84B2-46FFA27AC32B@fb.com>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <7312CC5D-510B-4BFD-8099-BB754FBE9CDF@fb.com>
 <20210520075323.ehagaokfbazlhhfj@amnesia>
 <CAADnVQJbxTikruisH=nfsFrC1UZW5zTXr8bUrL+U0jMBSApTTw@mail.gmail.com>
In-Reply-To: <CAADnVQJbxTikruisH=nfsFrC1UZW5zTXr8bUrL+U0jMBSApTTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 270f66fb-b116-4420-5b01-08d91bb898f1
x-ms-traffictypediagnostic: BYAPR15MB3207:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB320719CEF2708EEA3ED47536B32A9@BYAPR15MB3207.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e6IBkORg6KIPAaKEXTkyaQkEWyuwiEXuvibZ4qAhxnp4hs06RtahDiAAwdOOvaijBu2Srl7HKcbJoJUORpY1pZTG69UuEOo//BMCny7Am14UEyZj0cQM3QE3vy557YjhbfodOWos0ilF0jkFeQ4sthIhBLzwr+IaaD6CeqDdZjEQ8Dfnvh+l9Rj+NMRJ+lZfm9fn3d5hBl8LvCXILXl54e5i0lHd9QXF3cqBmoXReSiMuYH/x03hkcI5H8hFp63Hkt7gxjgfHj45O8W4KiG/H8VUVGsFeJUM+U/uUtgzkluds6WhN1ucUa+A4zAuuZwQ9Vfv5lHONxfq4v8JSLxjzMuKsYQ6jnR52dPCr+6gFi3JwLRVe8YjYQ9oIT7cqzhqFFipiMIS1mLAc2+BZLxABEYnzYr6BjCreWFdEqZtdaGl2FtcnaYhw2l+qRiFcGNWkNF7HB+j/tFIs+Kcc0dOZdUY6ais3ITz1SjKGv6Rr3P/+GoJQ9uC0gzYDFVTbeOqvMUeA9Cer5k+QGOvTXfJJ28RE612ermw4wLQQZgh/CqS1yBheUFy5dY6DwD0xo6ihcx6SmEA6v137HsRJjgymqGSKxCSpZNAMH7dLyOxN4Mz2Wnf23sdeylnAMmGpgu0VyCrI1OrOvre1mcfzSZk0YIxZLniNEuoInp6JP3n0eJHHr9+nBHE1eJf0zLI69dng/3M2n1HJpnBz465171OTKkQUAOGD6rMsOIEfpEgsyDK/9JZKqz+Aj5Kjjv4Q0CxmADMd7zOxfzTetH3K16eEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(7416002)(6512007)(478600001)(54906003)(966005)(38100700002)(6486002)(6506007)(316002)(53546011)(5660300002)(71200400001)(122000001)(6916009)(2906002)(4326008)(83380400001)(86362001)(36756003)(8936002)(2616005)(8676002)(64756008)(66446008)(66556008)(66946007)(91956017)(186003)(33656002)(66476007)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vLNgk7FAPOlO0D3w/sfeE1YN1XC/cG/1JdmLq5KOxBh/MHPZPJeFM1QIFwxR?=
 =?us-ascii?Q?E+s4YZe3Rjp941WIYiJCedT/9yZbgGpPx8xj8tQcGtOgRx9kMTI2SloBrXxm?=
 =?us-ascii?Q?dfhRlcKbAQ53rtb2UB4P7v6sxr3CBNzHn0aTa3HoTc9a8epHDUijLwJrzCxJ?=
 =?us-ascii?Q?cJimlDXkDhUThUi+SFUOfeJpX9ps4JUGRrsOSJrCo/g7JJOkGfvC1kUHeCNE?=
 =?us-ascii?Q?Y+NvRbCbPecWyk4YBrVV308U/CaACJ7IjLHdW6aX2hYnCfaAcqZdyrYZ0c1A?=
 =?us-ascii?Q?AYzVjT/XGAIzR44uQGWB5y/vg7nHO26EUwjm1xRdIqqC2Qz5kHUDN1ooXjnj?=
 =?us-ascii?Q?hO6gBDxk7HE/g0WhXJTLchhuZqIJZX4wdC1kbhvLyv+wUY7Dyowv4N6BkG+z?=
 =?us-ascii?Q?n9Ems35SpwHXzsO4atIIokzkyioOWfHllZQZa3UblHlSp0jdDc5CPlUiD7fA?=
 =?us-ascii?Q?bHyee1wCIL/HhoH8nYFdC5cAMbPEX+ic3eOHysvmGnSz5TRJAkkFN0Skcxxg?=
 =?us-ascii?Q?ykNyxWc0C4mzhJqToXGRdx7x76MCZGx86v2eEp44S+d+YBILup1pbo6ID2Yd?=
 =?us-ascii?Q?XT9PP/qaJ401+H7uElPWuuhWl17g61Lkuyh0aHGKpHkdlEZpDkBX8J358BMm?=
 =?us-ascii?Q?a5I3FHtjmfpUICW5W8nDoTlf1B5DtzFLK9b8/7HV8P339N4tRj+Ux3y87bEG?=
 =?us-ascii?Q?h81aggbBbfT5v82AIeYL699brUhC6N3h0qN+kQ9NG0qsT6X4ta9dFD/PgcfC?=
 =?us-ascii?Q?Zrh7wjOrmPKUxsb9/NXQ4R46wQLnVrQW/rybmhSdDQqXDuCVAGmR2NUpLyIH?=
 =?us-ascii?Q?Nt1XI2AOIoTkeq4VFZ0ed9Jzz5Ha44sG/fVsmyZVWZ0Mn7+5MBEeSfn5FKjr?=
 =?us-ascii?Q?gXv9/qpc8+rm4hJaKR0H5a7iY5J+HnQMSV9X4dej5RSLxdS44Pb5ALudk6it?=
 =?us-ascii?Q?u8rF8MfSD+50SawCq/QGqkZE7M9pDC5t4532W5W99uzSOOsj/rRXreofuWeS?=
 =?us-ascii?Q?ZunoJkdBvpKztUEAZByVlmcc8Y7Qk1hi8TM1SKIt84lybayRDywRoMkAkHDp?=
 =?us-ascii?Q?5OtWfCTg0DpIdCWzubI6wRaLaTKgPi2GExFODbk81bqPiNG+TbtnauNGjuSB?=
 =?us-ascii?Q?expKQs2BYNg6Q80CS+BkE2TOZu44XhhPe3JPhntYTXA+EHgP6F7s6iVAO6ER?=
 =?us-ascii?Q?cbKleyWhdFepv4SIcmJCUHmxPndhzEfI4ujHwMA9+II0uq4VjMewREr7nNZ1?=
 =?us-ascii?Q?OlHHQnAW8q/Jj3KHDRIqLUBdM7vjkpwkmogMTsgmw+a5EZK726WA7y7CdBWt?=
 =?us-ascii?Q?/ND5oX/vrvCGN12dtTQSFLM0JZa+oNV4pmrmo4ONWuinVSTXiXdekdiPdmZJ?=
 =?us-ascii?Q?1hG43dc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6500F9756795634BBF0C1AFF3211BC83@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270f66fb-b116-4420-5b01-08d91bb898f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 17:56:30.2443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6U7Pmvaffqd0gmX2HNBA59oqYzegwmKD7/r2ArU62fXVWnzmejjgEO/4YIGqTpJ91xm6A3rVauu8Hl4K54fVwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3207
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: KXpsDpjFizN22Vop9UP-6NkofItcdqbn
X-Proofpoint-ORIG-GUID: KXpsDpjFizN22Vop9UP-6NkofItcdqbn
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_04:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 20, 2021, at 9:55 AM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Thu, May 20, 2021 at 12:53 AM Dmitrii Banshchikov <me@ubique.spb.ru> w=
rote:
>>=20
>> On Thu, May 20, 2021 at 04:54:45AM +0000, Song Liu wrote:
>>>=20
>>>=20
>>>> On May 17, 2021, at 3:52 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wr=
ote:
>>>>=20
>>>> The patchset is based on the patches from David S. Miller [1] and Dani=
el
>>>> Borkmann [2].
>>>>=20
>>>> The main goal of the patchset is to prepare bpfilter for iptables'
>>>> configuration blob parsing and code generation.
>>>>=20
>>>> The patchset introduces data structures and code for matches, targets,=
 rules
>>>> and tables.
>>>>=20
>>>> It seems inconvenient to continue to use the same blob internally in b=
pfilter
>>>> in parts other than the blob parsing. That is why a superstructure wit=
h native
>>>> types is introduced. It provides a more convenient way to iterate over=
 the blob
>>>> and limit the crazy structs widespread in the bpfilter code.
>>>>=20
>>>=20
>>> [...]
>>>=20
>>>>=20
>>>>=20
>>>> 1. https://lore.kernel.org/patchwork/patch/902785/
>>>=20
>>> [1] used bpfilter_ prefix on struct definitions, like "struct bpfilter_=
target"
>>> I think we should do the same in this version. (Or were there discussio=
ns on
>>> removing the prefix?).
>>=20
>> There were no discussions about it.
>> As those structs are private to bpfilter I assumed that it is
>> safe to save some characters.
>> I will add the prefix to all internal structs in the next
>> iteration.
>=20
> For internal types it's ok to skip the prefix otherwise it's too verbose.
> In libbpf we skip 'bpf_' prefix in such cases.

Do we have plan to put some of this logic in a library? If that is the case=
, the=20
effort now may save some pain in the future.=20

Thanks,
Song

