Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099542AA1C3
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 01:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgKGAU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 19:20:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728131AbgKGAU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 19:20:56 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A70EnH1003543;
        Fri, 6 Nov 2020 16:20:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+nEP0C8T7Yo9xppULdsovxP1VLg9y59Th6izGSVb7eE=;
 b=hPMUf5PtgwbawDyF0OUcnK37FdnA7QsCD+SO5lqFasWI0G//b4adIpnp+ffyRTMvgE0P
 tpTNjRlI4HWe5JFPn7w7+/u6rkgSqBUg+Uw0T6suhIxPX0gk1k7NR9hjxnPY2YSfAsRF
 DhMjmx8NyoMpqPxUgqEGFtD0kgATscIRCeE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34mr9bf74w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 16:20:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 16:20:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgaTzveFWbZHZ3I0xt89Yco9eG8WMyUbkwYDB3Bly1cRw4T6r7LZaDbRclUux8jAOvGWPudQH9dAcCXdju58rbCSnRJY2zb0QB815Ue6UQWt4c+zMWP4GywqUvwWZJ2Fjss04h8UOnVQYIsO1eka2DjDHI7Nl7P4fvrUUNpdBPsJLJ944l3d6aP9Kg0Ga+iESyKuldMvuTzy2l+YUDL+T57CNTm7lmHz5Lx83DMRKXoW0VJv8tXc3uVmju5kBECO5i2JD06rJnxifP79whiiXQOjFSiGOvXsIENmeFL57iCg/pMU2+LuYNgkUnN2PIpy4LG9DeTHF2OHH5gmRDngSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nEP0C8T7Yo9xppULdsovxP1VLg9y59Th6izGSVb7eE=;
 b=hl/6w/9stDzU2DVVOTvvKw+JlaMOpVzj/57G/0ssHKlbeMBIoEJZxk1wtvl0FuLNVYFzuOrOsE2wSwi6ZI2a5jJkFplTIXfSgVMrJ73s7Z+vXz8GBS6xjMzLRBMkoCpdGGMkSNIhRZXgiF5vk24aoL05HfqGSAn1xy1bY9CyxHM6OmvaH5WCTIIl1VbOsQJXTFTvmcUJoGWW+CANeF+2qk+1iB7Xy1T3wMyOllCFLASaenH8zHVYa9CYqGamKO/XWSyLBMLqJjxp3ujii1yvf0vBv6F83o1RDJWcoqhHHL5JvvpBzr16MCEQt6zl7nfS05bab4YP2eC5CLS246IPJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nEP0C8T7Yo9xppULdsovxP1VLg9y59Th6izGSVb7eE=;
 b=QG2mMyUCSIfe8yhIsDFbTVbeXwJZhPW4I+cyUUlqjQ6sq0qC4JETz0ne0rIwUOus+ThfsU9mG+v71Utp7qHQNtOCxgVPnKBAp3yafaaOD2N/mnnNjqqm54cQv5O3EJk0BOfNHuKekW/t3/LGjxu27QVnWQNozg/goPD0JubKCGQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3208.namprd15.prod.outlook.com (2603:10b6:a03:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Sat, 7 Nov
 2020 00:20:38 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Sat, 7 Nov 2020
 00:20:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Thread-Topic: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Thread-Index: AQHWtIlRNBRBFFP0rUOaRcDTIizKBKm7t9EAgAAFX4CAABFegA==
Date:   Sat, 7 Nov 2020 00:20:38 +0000
Message-ID: <0394ED25-D8FB-4FA4-A021-98A403A248EA@fb.com>
References: <20201106220750.3949423-1-kafai@fb.com>
 <20201106220803.3950648-1-kafai@fb.com>
 <8FA16B3B-DC01-4FAB-B5F6-1871C5151D67@fb.com>
 <20201106231639.ipyrsxjj3jduw7f6@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201106231639.ipyrsxjj3jduw7f6@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:ca49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c401c176-00b0-4394-9c4b-08d882b2f40d
x-ms-traffictypediagnostic: BYAPR15MB3208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB320813D361E055E0D52B82D2B3EC0@BYAPR15MB3208.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ptVVY/PMqCH/T8huDL4AYcuowyHEOv7g+UXyyKJ7uAYUrHTMWhXk9OYI5zNzm/TeqFTcAXUQgLQqiQmZb9QhozwT85Zowl30WGDGHhPTFG5Lqt9k/aHgjWSb1oQyb0aUmS1y2ACpoRZd7J3TMesV6zQZECCyTehXv88Bgaf3BuEJmR5hAMd7N0gPLgzKvotbBj7LUkUKjkplvkxXMo2sc72J/gpjn5dWUvKQ0JGQrozL4+iaX2ASjROqBVy6fFcDo7FDdaYBDHFXmWu5PS6nXvSx/rcyGz8ynIjB+5xb5PFtuEN3PWfOAoiiCje2yBJWudbwbvGxyi5rWMXMARruxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(396003)(366004)(316002)(8676002)(6862004)(37006003)(478600001)(53546011)(4326008)(86362001)(6506007)(186003)(36756003)(76116006)(66476007)(64756008)(6512007)(2906002)(66556008)(54906003)(8936002)(66946007)(5660300002)(71200400001)(6486002)(83380400001)(6636002)(91956017)(33656002)(66446008)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: y1+GUPzBlc+jk4geIbTzfz6jNtMpfDEuiuDQiiNOShH7F8fZO0F+ElnYkRfKQEDiy5dFw8UqH/Mqm55bGZaeZ2wbqfOh681FQ5xWwHj4RwX5h2ihhWwzgiDenTFJFf/V/xKLzu9pxTycHX2OlcurVA9rymPv+Gtpn+nkHoMXnS1jWLm6IXV8OAuHBBO/qjEENVI5FuMqs0CYrPsYJ00le1Qb5RWCacFJgoy05NOPPguHz+2PL27rN1o0ppQf+NYUFvXRX4U0blZU7TgPnm5Y1o9itZS0FPyCsIInMl61oYc7B6bVKMnBVces5MaLCiweE6XvubShzGVidrl41SE502WVThCdtDkVixIx7C8xDRanRJ3cDD1+CPambiUFP84iiBztK5Fw/nrHsdh3koB2UE5/uTbBuIf9VhVyXY4N8jxXXU07NBW/zL6+DScAraScekc6uHNmd89ioODLaFyPAL9BA9nA0ozJMQfORa8w2DRjNmOG1Zi9BlOP9CnScQzbULUoV+gFurGSA4Dln5wEAfTlRjI1iFUAU+EEak7vgGD+zvcUxq7WImsHPV5mpiRZ7NF6y3sFqIsntFm9842adHKEiAJpDYzJ7chqPT0diGvqBl9a9giqA7dyyXURGvFcY2Rr3B14mEemyF0aD8bPJQVz1O3UwkqA9al+4bQWXRR/3F2DaQT2s/DXFTDEqk27
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01A1AAD20215234088F99C7B0BD9399C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c401c176-00b0-4394-9c4b-08d882b2f40d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2020 00:20:38.2437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aO8/y94UYYsimK3fhQfvY0yC/vAeaXq2GfO7SQRc04V/BdxS6y33AXTLChiODRRctMy3zwmfDND9z6Ajitm0PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3208
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011070000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2020, at 3:18 PM, Martin Lau <kafai@fb.com> wrote:
>=20
> On Fri, Nov 06, 2020 at 02:59:14PM -0800, Song Liu wrote:
>>=20
>>=20
>>> On Nov 6, 2020, at 2:08 PM, Martin KaFai Lau <kafai@fb.com> wrote:
>>>=20

[...]

>>> +static bool bpf_sk_storage_tracing_allowed(const struct bpf_prog *prog=
)
>>> +{
>>> +	const struct btf *btf_vmlinux;
>>> +	const struct btf_type *t;
>>> +	const char *tname;
>>> +	u32 btf_id;
>>> +
>>> +	if (prog->aux->dst_prog)
>>> +		return false;
>>> +
>>> +	/* Ensure the tracing program is not tracing
>>> +	 * any *sk_storage*() function and also
>>> +	 * use the bpf_sk_storage_(get|delete) helper.
>>> +	 */
>>> +	switch (prog->expected_attach_type) {
>>> +	case BPF_TRACE_RAW_TP:
>>> +		/* bpf_sk_storage has no trace point */
>>> +		return true;
>>> +	case BPF_TRACE_FENTRY:
>>> +	case BPF_TRACE_FEXIT:
>>> +		btf_vmlinux =3D bpf_get_btf_vmlinux();
>>> +		btf_id =3D prog->aux->attach_btf_id;
>>> +		t =3D btf_type_by_id(btf_vmlinux, btf_id);
>>=20
>> What happens to fentry/fexit attach to other BPF programs? I guess
>> we should check for t =3D=3D NULL?
> It does not support tracing BPF program and using bpf_sk_storage
> at the same time for now, so there is a "if (prog->aux->dst_prog)" test e=
arlier.
> It could be extended to do it later as a follow up.
> I missed to mention that in the commit message. =20
>=20
> "t" should not be NULL here when tracing a kernel function.
> The verifier should have already checked it and ensured "t" is a FUNC.

Ah, I missed the dst_prog check. Thanks for the explanation.=20

Acked-by: Song Liu <songliubraving@fb.com>

