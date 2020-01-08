Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D84F134ED2
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgAHVZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:25:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726836AbgAHVZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:25:12 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008LOqEA011244;
        Wed, 8 Jan 2020 13:24:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=A73NC/ZWQIV4bxxWAVw4RJZk9tEpsZOElsp/ySK2Q+I=;
 b=iZwMtAzblWwRvyClQ5REljwEv24B5DwdhCORqW8VTYaULnF35EaNVYCvFKSEVycDLJqE
 0OFnQCoz8LweGx5njo8D4wvyaCBnWYqhcQh5FTaUQtjCJur64XORIgrnwDrOCszxec7u
 yqyhRbeSHodj9qxYFHOqzMypIAciEKRT7O4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdcnqk9em-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Jan 2020 13:24:58 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 8 Jan 2020 13:24:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0lhNz2u6fXU7PFhnIxWdsqxdgQgj6PhoW3ehLhI1h9zh1H8tMrPR9ue1Gi37Vd8+VAiJfsIcMLVeY+fig9D4lfV4x6yM7qtS7aJ1nf+743kTiyz76eWrwvvxmgmG1/S8yN7r0utWqqGiSB7WPciJ7Xi44JivAzzJpc8Z3ZgJzzW5e0nC4rA4wZ9tlS+NZISrLdq8GpEpeWXeL8G7T6TsQ3kQKWw/sXmgRP+rXCtUWTJs7yYxjzACoaCwE7POVh2Iu5r+ofb+PYksjMs74D0ju9bhG0J8Nd97UxKB5269FZ7B9CpRc1IPGUMKagEQFDAqJFh/GZN65wmBJJ6Tq6WVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A73NC/ZWQIV4bxxWAVw4RJZk9tEpsZOElsp/ySK2Q+I=;
 b=aFEXacQ5OSurInRbhWnlb6cLp4gPXbNrT+tM0mNGIt6iwJBqCFPfb/6Kj265DAZaJIEC3bNtxUUTON+wz+fyNA+rH73wLxeugXC9Qq/HNEGETAV28/SkuMDyq6pwTQjYwb/jYodFnE4MoUHcMTgME35Jv2gipe0htAGRzl0ZuQCjA0nCc8Z+HnzhpK0uAPMI6cFkGT+8HSYsrgfiO159lky10pmzNGbEabTjaVf5TTjpDCZp/gyJZTOrecPBzWWuCHAPK0nIx3wrUmw6nMwx/rfOZA0vRnGdzYr20GO3MdbsAlwzoYIHOcEsAU2R1OXCReP2eJmkvpno+rtwjpwVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A73NC/ZWQIV4bxxWAVw4RJZk9tEpsZOElsp/ySK2Q+I=;
 b=Ixz81jUkOvJpBiUKw3IMX/IJF1+Hm3jXIIdzjxw99Qj8g4EnBVe+0rSJIs266CDOF40DqiPdyO4pwAliaRFgGPxV5s71/nH7+cZljoPXhm+sZcUk8FVlA1R331AKi7MB42SXSAhp13QlRJUKe8dgZ8xmzAUmyaV2ZR5nWI77Cu0=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB2567.namprd15.prod.outlook.com (20.179.155.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 21:24:55 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 21:24:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/6] bpf: Introduce function-by-function
 verification
Thread-Topic: [PATCH bpf-next 3/6] bpf: Introduce function-by-function
 verification
Thread-Index: AQHVxfUHa80wphBbsEuavS3rckiVo6fhIs6AgAATfQCAABHvgA==
Date:   Wed, 8 Jan 2020 21:24:55 +0000
Message-ID: <8721D350-1733-4327-A702-0575BDE6BBF6@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-4-ast@kernel.org>
 <2A66F154-7F54-4856-B6ED-E787EE215631@fb.com>
 <20200108202043.bo6sdqe5i7lttgvp@ast-mbp>
In-Reply-To: <20200108202043.bo6sdqe5i7lttgvp@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:180::938d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17cafcdb-952f-4fed-12db-08d7948134f8
x-ms-traffictypediagnostic: BYAPR15MB2567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2567CE3E9D906048BF443454B33E0@BYAPR15MB2567.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(136003)(39860400002)(366004)(51914003)(199004)(189003)(81156014)(36756003)(81166006)(53546011)(6506007)(6486002)(8936002)(4326008)(86362001)(54906003)(15650500001)(316002)(71200400001)(5660300002)(8676002)(2616005)(66556008)(66946007)(186003)(66476007)(76116006)(66446008)(91956017)(64756008)(2906002)(33656002)(478600001)(6916009)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2567;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: djiR8QsWjtWSz8DAs08lW0dMn4XeMqCMNx3g+oidWaT2aSWy3jEsRGS1SZygPQfMYBN4QXXkuphrNVB5ILzOBWYNubvYFoF5RtYVQfoOW2sBcZ7hF3rOGa0+Qh5fxZSWH+bBOVq11ODUbjrIGoSQvJY7YNg0PD64xsTa5XUBrQ+Zd+YgbZedgT8CDKev6w/gdOoN0S73eHmxIfnp2lknNC+sTqUm03a3LIwo00H9kBCQhONgVRfg6slaljcDz59HtmEClGbGib8FNo0wWMv+jiZeKpm+2iNsHtnUEImBBAHfYT3m0nUHXY/ByVEhJ/TjXR3+ElhEQqpBUzIFnrG3g+4zqqFveq1zo2Dztr7g3IREuJk7U9ZVlarnjou0CFJGpTApI1+damqUeQFBd4aMmK9djSN+d1i0TgOcvKVq/2tVjiU4fMuCO8au0UHMTdnaH/CLUqb4fmcuhwTreycVeiztPWJq6OYB9gDr5aQKJ1CsSlBP0+CXmK2Fva74Uvzh
Content-Type: text/plain; charset="us-ascii"
Content-ID: <109A94AB3277CC4FB570D4CB01996BEB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 17cafcdb-952f-4fed-12db-08d7948134f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 21:24:55.5420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1KuDZNqSyOQN9qHuPL/8dWbqwe2Oo/WNpum/YW2JYZJuwxypRxXMc9xVUkDo6GaChNvKN5eMafBz1IWYiQ76Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2567
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_06:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1011 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001080167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 8, 2020, at 12:20 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Wed, Jan 08, 2020 at 07:10:59PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Jan 7, 2020, at 11:25 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>>>=20
>>> New llvm and old llvm with libbpf help produce BTF that distinguish glo=
bal and
>>> static functions. Unlike arguments of static function the arguments of =
global
>>> functions cannot be removed or optimized away by llvm. The compiler has=
 to use
>>> exactly the arguments specified in a function prototype. The argument t=
ype
>>> information allows the verifier validate each global function independe=
ntly.
>>> For now only supported argument types are pointer to context and scalar=
s. In
>>> the future pointers to structures, sizes, pointer to packet data can be
>>> supported as well. Consider the following example:
>>=20
>> [...]
>>=20
>>> The type information and static/global kind is preserved after the veri=
fication
>>> hence in the above example global function f2() and f3() can be replace=
d later
>>> by equivalent functions with the same types that are loaded and verifie=
d later
>>> without affecting safety of this main() program. Such replacement (re-l=
inking)
>>> of global functions is a subject of future patches.
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>> ---
>>> include/linux/bpf.h          |   7 +-
>>> include/linux/bpf_verifier.h |   7 +-
>>> include/uapi/linux/btf.h     |   6 +
>>> kernel/bpf/btf.c             | 147 +++++++++++++++++-----
>>> kernel/bpf/verifier.c        | 228 +++++++++++++++++++++++++++--------
>>> 5 files changed, 317 insertions(+), 78 deletions(-)
>>>=20
>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>> index b14e51d56a82..ceb5b6c13abc 100644
>>> --- a/include/linux/bpf.h
>>> +++ b/include/linux/bpf.h
>>> @@ -558,6 +558,7 @@ static inline void bpf_dispatcher_change_prog(struc=
t bpf_dispatcher *d,
>>> #endif
>>>=20
>>> struct bpf_func_info_aux {
>>> +	u32 linkage;
>>=20
>> How about we use u16 or even u8 for linkage? We are using BTF_INFO_VLEN(=
) which=20
>> is 16-bit long. Maybe we should save some bits for future extensions?
>=20
> sure. u16 is fine.
> Will also introduce btf_func_kind() helper to avoid misleading BTF_INFO_V=
LEN macro.
>=20
>>> -int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog=
)
>>> +/* Compare BTF of a function with given bpf_reg_state */
>>> +int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog=
,
>>> +			     struct bpf_reg_state *reg)
>>=20
>> I think we need more comments for the retval of btf_check_func_arg_match=
().
>=20
> sure.
>=20
>>> {
>>> -	struct bpf_verifier_state *st =3D env->cur_state;
>>> -	struct bpf_func_state *func =3D st->frame[st->curframe];
>>> -	struct bpf_reg_state *reg =3D func->regs;
>>> 	struct bpf_verifier_log *log =3D &env->log;
>>> 	struct bpf_prog *prog =3D env->prog;
>>> 	struct btf *btf =3D prog->aux->btf;
>> [...]
>>> +
>>> +/* Convert BTF of a function into bpf_reg_state if possible */
>>> +int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
>>> +			  struct bpf_reg_state *reg)
>>> +{
>>> +	struct bpf_verifier_log *log =3D &env->log;
>>> +	struct bpf_prog *prog =3D env->prog;
>>> +	struct btf *btf =3D prog->aux->btf;
>>> +	const struct btf_param *args;
>>> +	const struct btf_type *t;
>>> +	u32 i, nargs, btf_id;
>>> +	const char *tname;
>>> +
>>> +	if (!prog->aux->func_info ||
>>> +	    prog->aux->func_info_aux[subprog].linkage !=3D BTF_FUNC_GLOBAL) {
>>> +		bpf_log(log, "Verifier bug\n");
>>=20
>> IIUC, this should never happen? Maybe we need more details in the log, a=
nd=20
>> maybe also WARN_ONCE()?
>=20
> Should never happen and I think it's pretty clear from the diff, since
> this function is called after =3D=3D FUNC_GLOBAL check in the caller.
> I didn't add WARN to avoid wasting .text even more here.
> Single 'if' above already feels a bit overly defensive.
> It's not like other cases in the verifier where we have WARN_ONCE.
> Those are for complex things. Here it's one callsite and trivial control =
flow.

Agreed. Current check is good enough.=20

>=20
>>> +	if (prog->aux->func_info_aux[subprog].unreliable) {
>>> +		bpf_log(log, "Verifier bug in function %s()\n", tname);
>>> +		return -EFAULT;
>>=20
>> Why -EFAULT instead of -EINVAL? I think we treat them the same?=20
>=20
> EFAULT is a verifier bug like in all other places in the verifier
> where EFAULT is returned. EINVAL is normal error.

Thanks for the explanation.=20

Song

