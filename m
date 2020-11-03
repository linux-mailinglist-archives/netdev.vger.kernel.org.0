Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118222A3C28
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKCFoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:44:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65034 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726754AbgKCFo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:44:29 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A35ei4Y016340;
        Mon, 2 Nov 2020 21:44:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dZ0L2mejsLzi7wdrWGLeIWKYQ+aIrqiQjSwXvAJl+3k=;
 b=DoOZwl0hZmR0x4ourhTyE6foae65XmYVJx1Q9lBXoudPeuZaFVSwUgu+PadwDiST8Cso
 bbviqBH2RDtJ7ESLnhrRWPtuf5SdGejE6QSqWP5Dt8owcvQRZFQ4RAxQdbuV7Cylmrec
 Nb3v2DRrElcmogcMfVLC6H+LjUgjdJib/ZM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hqdu9fs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 21:44:16 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 21:44:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYm24z50364oVOWjMy+7ejBEXcmL8/Q8VPMpCXVkRn8698VejBJgINNb2DNfu/YP6h1cIG+qNaUWYyWhdJCxAMO4D1iuloVxCMfY2zSthmsfjn9o7NhEGKqUScMOOH2HhUAArtVYSwN4q2gLAEXTjCYh2pgbOktNMhYiOfo6UjEawt+APsyvU0WV8wpoT4Jsd8ed5UUWz2eJTgJNfnlbe26YSfCGw32rqF7CeW9teIrmZK1pSA8JsZvrkUkX12xxLarIf9eSjN2ZlLrA3h+zZzeeDrSJNvgXgx/Kq9TG9na/AIZvDcHCM8Fj9yxAF6ROwBWjPtuMcQhajDGvk2SXJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZ0L2mejsLzi7wdrWGLeIWKYQ+aIrqiQjSwXvAJl+3k=;
 b=XK4vrJr0NQg6S6MEsiWguWxMSfZOixIaR2OH19uwMXtYW1aRbL9PfPC5gY+caaHbinYEx2sx8Vrg2gB8YplJX+9WlvOc26NaDWVhS76DxLvQWuqMeGaj42A98ZtiObObB04F9RgFHQO8YS78J5tuAv101M5eH8xCk+yZRe4ERFVNZKlUnTdB3m3QQVnqDVj758c6KxjXCQYB7BxJB91uEO53NCL2jbo5bqTtmytqbc0ow0vhwZfdEQ9K1H8agqx3krK9CNWOjK2vP2aTDRDuRg87muCPShpCgcbnsfi26W7j0GwodvGeyBUeaNI0kfD2fi6nlbOs5BBD9MloYaGLwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZ0L2mejsLzi7wdrWGLeIWKYQ+aIrqiQjSwXvAJl+3k=;
 b=fEXfbqn2BwCYajUtnCYvecUG1lycG0SRPlYq3Cosww29TOVT5Ov/V0b7ZuGcNidHNiuKjG3zVXGNzVc523xaZnLAwqIXH8tIoP7ZSOyNl1AaIpSO7yP2yw6AKUY1zSSYaXJGi84ePbFzHBWa7vWb2pTtMloyrsQa5E2Zw01rfYQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 05:44:13 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 05:44:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 07/11] libbpf: fix BTF data layout checks and
 allow empty BTF
Thread-Topic: [PATCH bpf-next 07/11] libbpf: fix BTF data layout checks and
 allow empty BTF
Thread-Index: AQHWrY7NHg7l4OivSECIeWatLilZlqm1m9eAgABKqQCAAAcagA==
Date:   Tue, 3 Nov 2020 05:44:13 +0000
Message-ID: <0ECC1C71-119A-489F-BE6B-B04329357A5B@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-8-andrii@kernel.org>
 <DC33E827-1A58-4AFF-A91B-138FBC8728A6@fb.com>
 <CAEf4Bzbwmbx=q7o03q99866sgSijtAjBMWWTbSCgshtv76otyQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzbwmbx=q7o03q99866sgSijtAjBMWWTbSCgshtv76otyQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f1180d1-d603-4d9c-aaff-08d87fbb7eee
x-ms-traffictypediagnostic: BYAPR15MB2407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB24074C79B53DC50A801167CAB3110@BYAPR15MB2407.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EgSzlC6B/8lNTVCtCB87PyHLDxg8K85HUResfipBW4keSTAqb9gEPgzUXL81rZSd7R+x9kb9w5+pJdF+2aoWPeCO29FwrujeJiYH32puvIcL9vT+wkWOIZn6KIct5K9jdskC5U035pbX5YzWE0TQ21w3kCRTJFPhXU4Dvsg20Qxrdh4lGbD5Uz8qiEICwQff0Sd822lUjJogtoOjKjR50rBE2T61NmHqmBh3yDG+QpTOPWouLY9dY6XtmX2TkCkCU/OFfvMFYH8Izs4Vhu+drf5+U9QOPuhMk9YYKxqd9hTna/pUcdR1uBMXyTSzAXsMfAAoNKL3VbHTTCkQJd9xUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(6512007)(33656002)(6486002)(8936002)(6506007)(53546011)(2616005)(36756003)(8676002)(186003)(6916009)(5660300002)(83380400001)(66556008)(66946007)(86362001)(2906002)(71200400001)(316002)(54906003)(66476007)(64756008)(478600001)(4326008)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: BHRfqMHdenirPLLy0jw1BcKWkWwJ+O2HP+4CvFoORjwEKKRjzdYPCgqa1YvnQ1y49ggeL3KGAJr/ndILz9+BAYWrgYHW6lwohUwWIIAzns2lx86andjQ+ZULXjtcvTy/VUPv9lo3z7LqvOoz96ip+7hLK3HYTsxmQBFwnaw8vq+6yubl1VKSMY5oGlr/AXdauZsMhivn0iGP95McEyxC6FB2QzWxtN1P1d1GfDQh9WDy7RQxQ1fskCZXCjRbCnwWNaR1pW+MyTYcg9Sgr/uA0uCroADtZPOwUrGoCSArYKPIcsnvZ1o4YxBDhO8gTdw1rIBnW30/1I7iGtHYzb0JVNdJplOOngM/mfIX5gf5Mg5wIpEEjw1MX9NXPvRtX79FDrJ+Ml6BGOZLcKi5R/t4bIjFDtIkEZrmSzEItebrxo48H7w1hjvjemtMZK4WdLmvXG2e3xfEv7fuVOvrhCN+ddGPwTzMu2ENobGF51A8HQ/SpDBoNcefCG0byvjTcju9/7D/O5nwAObxAY+/AegzPFHFzIFUNxouaKE/Ds7hB8tbAhpTq2LTD0H8Xw2scKH7RDMErxjZDyan90SOoPdaH9n5J+xwrgJbOvYmDBzqXriw9UYBdDckZQL9f+BPGsn8Gms1oREvkTvESKmsKlwPMtM4B/kw8LdumOdSjsVbLK3t7rY3PF7uTbODBGOSPlYe
Content-Type: text/plain; charset="us-ascii"
Content-ID: <304D57D891AC1949A932B719F1522E1C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1180d1-d603-4d9c-aaff-08d87fbb7eee
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 05:44:13.6808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBsrZqbNUJJmr+kZk3/6nmXQOwVgRW33N5xFfwFK9bKcW4eEj0txUkxaLlhjIOARDEotY1WjxWRt9ckgjzGHSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 2, 2020, at 9:18 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Mon, Nov 2, 2020 at 4:51 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>>>=20
>>> Make data section layout checks stricter, disallowing overlap of types =
and
>>> strings data.
>>>=20
>>> Additionally, allow BTFs with no type data. There is nothing inherently=
 wrong
>>> with having BTF with no types (put potentially with some strings). This=
 could
>>> be a situation with kernel module BTFs, if module doesn't introduce any=
 new
>>> type information.
>>>=20
>>> Also fix invalid offset alignment check for btf->hdr->type_off.
>>>=20
>>> Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>> tools/lib/bpf/btf.c | 16 ++++++----------
>>> 1 file changed, 6 insertions(+), 10 deletions(-)
>>>=20
>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>>> index 20c64a8441a8..9b0ef71a03d0 100644
>>> --- a/tools/lib/bpf/btf.c
>>> +++ b/tools/lib/bpf/btf.c
>>> @@ -245,22 +245,18 @@ static int btf_parse_hdr(struct btf *btf)
>>>              return -EINVAL;
>>>      }
>>>=20
>>> -     if (meta_left < hdr->type_off) {
>>> -             pr_debug("Invalid BTF type section offset:%u\n", hdr->typ=
e_off);
>>> +     if (meta_left < hdr->str_off + hdr->str_len) {
>>> +             pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
>>>              return -EINVAL;
>>>      }
>>=20
>> Can we make this one as
>>        if (meta_left !=3D hdr->str_off + hdr->str_len) {
>=20
> That would be not forward-compatible. I.e., old libbpf loading new BTF
> with extra stuff after the string section. Kernel is necessarily more
> strict, but I'd like to keep libbpf more permissive with this.

Yeah, this makes sense. Let's keep both checks AS-IS.=20

Thanks,
Song

