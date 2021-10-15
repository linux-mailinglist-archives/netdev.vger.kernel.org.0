Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CBC42E968
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 08:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhJOGxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 02:53:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235775AbhJOGxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 02:53:50 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19F6lEkP014797;
        Thu, 14 Oct 2021 23:51:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=65ghZENwuqwIlqwVit43QkYOEhMPd0AL7K1xVaDP2hs=;
 b=CPnGehBWf+Yhb+/y94PH7fmM4ihGQiESR81fHrk9w2SkX0haOFtFtpSb7uhk4tcXI5HP
 6qEVxmym7BiZ+b5JFwQ9+/rSYHLejoFORFuC8nFFeXaA+AVkw83Jk7vtGQ58JLryRZwS
 C+aW2hIstvmWQkOKPUhy6Cfu8qRlvP80eL4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3bq4p800hu-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Oct 2021 23:51:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 23:51:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czXgag6qwniqJwOcOvb5YLlnmGwcQHM71NcLc46y8WtU0jw1kDzgKJVWqu/MuQOvOnEeupk589FsBygOFcZnnkGC6yU3X0UX+a3LlCbLdDQn/vtCjn/vnN7WbEDB6ElYz64oxAXmD9Gak+w3A0LWmUdgMUpl3tnr9x9qgXqxqhtaG7mQavwe2IXGH1vGHy95qCsIFFB4h/ODIKAcCHG1/rYPNuJ/J4kCUNnvdB1u1KbUt1ZP83wOen1IpTzi5WxOF5YBlXnO+5ytRwPCed3zf3+YzfOy0w8PKTTzvjc9lyQXe5psJ9DDeGRUuBpZdkzsMI4wLvIDsMtJAutQROJjPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65ghZENwuqwIlqwVit43QkYOEhMPd0AL7K1xVaDP2hs=;
 b=eqmaaqBvZfGcqNpJcz+lS+WZnp5HkNZvG4f1GmIy33QS/QjCnP9l6bYdLtmYpqh0aqqLAdY1TgKK2JkjnpaB2ZqWQK7WX4HAzZ+XfcYNn88iBN0sDlnuzCeJvna9Ibq/lDvYirOQoCWkxZBgCIo7WNT5YFBWxj1eoor39icBrvE9e8PqzV9GU+FPkDdIirJAymvDJ9iV7JpcTiK6oEA7iqqyzDWVLdpAHK0XX/dbHyKIBI8qnMpFOch2DLFhJJgHFwQyNtB/cZQE9T7edmicCdj8MmXLtbKw8eCnG9r1Vj7lTZ4TTJRFZAb6/DaU40pj9GvvQA6Pqi8kE7UaPWF/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5061.namprd15.prod.outlook.com (2603:10b6:806:1dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 06:51:40 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 06:51:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add weak ksym support to
 gen_loader
Thread-Topic: [PATCH bpf-next v3 3/8] libbpf: Add weak ksym support to
 gen_loader
Thread-Index: AQHXwT4Miz9CYpSiqEqIW9+KOrRmVKvTn7iA
Date:   Fri, 15 Oct 2021 06:51:40 +0000
Message-ID: <D18CB1D5-7B7C-4952-AF51-7C19883DAF19@fb.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
 <20211014205644.1837280-4-memxor@gmail.com>
In-Reply-To: <20211014205644.1837280-4-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa112ccc-e8b0-4aa1-3c73-08d98fa83dd1
x-ms-traffictypediagnostic: SA1PR15MB5061:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB50610E8568489BA683024021B3B99@SA1PR15MB5061.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jx/PueS9tCPf+zUUrrBxrqkXsactRivkfzLGO8Mz/99/GQ4NZUqvicjHKJy3MYyU6JjRr032HtQm1trTVeUrXa238eCcs5TV/BudP1oMgbp/k5CT7uYysKVw2wU4bZISj8RrISwjpK81v2aKiGaOfyHFOO3MM+gCowwc+vv3dLWqZaPvTEx6XVraIyPBTKvE0syKDYimvRkg3HLR3Pwoz3izukWNfuqoEIDVDI1wbYMBrl3UX3MeeNr3H5vnlWdp05dHd36PFCzVRnMLRUSLCeV8L0zm1D6KfYG4HBgYEazq3O3koN3qsD9+wUgayq7CZr8/X5AIUMLLz6sOdGKrtV669a704rQGv96gGGDmnDZ4nv317BmYhuaIBfZPTc7zC+UoWKMLcJiC6AzAVRHJFsSKsS71Rcn69SA0OsyC6TAV0B8GrzkWP8yiy0yPXH3Mfci4I13oWxwCjniG+A09rK88TMVQ7m69S0nBQBG0F1bh5HU7Drp1Y/LtSHnUPGqcxlGh9jP13OKoAwpi1MjQUpglG/5AFHh9SSaIQ+qQ5f6wCSGvPoSBTlkgVMdc5wh0YVbR7YlX3UvFvNE+916qwqXnonZhUsPbdzoJCBW3higoIs0bWNDbU4WN6svHnPtcl6woSdJC6pzZ3rKOgQp9dKtOgfRLwynQw+bhAW58DyibrbZUWSginwcIR/fXcyGL431KebR/GXQyzyBiW8BTmbzUessNWNeUgd7902AlNA89vCzFxdjM0y2cXez/NZFg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6916009)(316002)(53546011)(38100700002)(122000001)(6506007)(508600001)(33656002)(54906003)(36756003)(76116006)(83380400001)(2616005)(186003)(6512007)(66476007)(2906002)(64756008)(66946007)(66556008)(91956017)(5660300002)(66446008)(8936002)(38070700005)(8676002)(71200400001)(86362001)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?avgqeT4M/3JoYCNJsmlGwFpAawiYzmvA04XA/3DmMzx+3ZTX3ejOcLa86K?=
 =?iso-8859-1?Q?gUAeZEUfs8QsVwCAWDus6QnYAcpBB9vKif8i297fZriWFOwgYbzP60o6Gx?=
 =?iso-8859-1?Q?EmyhxKv1Ztd8hGfM3OV7izFvJpWR2lSh9T2pKwKVpOfoTOncxo4Y4jGkNz?=
 =?iso-8859-1?Q?EQXpOjuPhl0EuTUiodYaMBF0vPq6rKJ5tdO2KV+G3iFAN5O914ayIdVcQ6?=
 =?iso-8859-1?Q?m2IynuS7aVhM3W2xs1cD5bsMvB9YgqeBvzKEeqWjXoQ0FCTwEMj5ujvxcT?=
 =?iso-8859-1?Q?iGkF/B5PTXUy82bYbhFoaYqH88IgiXL72NrqsgexFux1qgaPdyJVY5dTSw?=
 =?iso-8859-1?Q?IjoFH3lMlK8MZsTOfZOVYUE3pGTvcLX0JND0rkBvXyXS1sP2/fLvIngsTm?=
 =?iso-8859-1?Q?DtcF+K2OoZ8KyjtzChebtUUq2PJQ57MQqovQtcbx2mWeh3iAxDfg+0wRUf?=
 =?iso-8859-1?Q?+mb9ubJ162bZ8XLUiZJnUNxWsJZAqsA0RlZqwYvd06DeN8xTnphoNuc0Tq?=
 =?iso-8859-1?Q?Mrv9h3/PlXow0NShbPVfnPXtjZy7OuWOOpMmHdLr6NzqNKHSA83Ond6Yrb?=
 =?iso-8859-1?Q?cwhluQmfwOha0++Gwv/zNGhlTSLbyFNhz+ISuc97sUjWfcxUl4ZjyXyJyg?=
 =?iso-8859-1?Q?IUpnlWpXOVkjvamf5VN/L9sbNkWtjEkpx+oUPjoMQYSVyM3irbyiO0mnYp?=
 =?iso-8859-1?Q?ISqAJ3uAHyuzHUEA9QYxTR0XRhN+dnlvw+aQ8T/yJYAd2gWRRCqqNdwUh+?=
 =?iso-8859-1?Q?+hd+Ol8voj1DZ1H4rzklNQZNTYxx9Ma+L+SXxKw8mxFZZNAMk8dBFPr4iV?=
 =?iso-8859-1?Q?g6Y9T424UMw4DtUL3ulJRJxNbdqOAGF22N3P5cdVHw2mAPSjmN36KlFEcD?=
 =?iso-8859-1?Q?Jc58rgFwizhukhZYaaY6+dKBR+71Ur5OMrvmwramI69M5E/rga+fpyI6NQ?=
 =?iso-8859-1?Q?PMkUISYrYMx4DDpchmkO/A/zBto1qJnNW+CU87tLtCA11gwLuyTtnsdwkB?=
 =?iso-8859-1?Q?3Rq7+3RtKlssUBT8Knv4lBVm+PQ5GPn7+uMVcDi+/6WlZs4oEsgHGysoZG?=
 =?iso-8859-1?Q?2FPf9ADy/Hay3m6YCkAhi0/JTovNWdYNV2k4FC+iUFTZ13Lllh1FnGXN2N?=
 =?iso-8859-1?Q?LsXhU64szpthPStETjFN+5OKBVoYdKcWxm7E20tA3K9A/J7ma6X79dRjUl?=
 =?iso-8859-1?Q?sM88ZPqba8mwHfHocL6hr4WKWQv/nltGkqp9aIzQMm7UhYo29D4Fv69sfL?=
 =?iso-8859-1?Q?9nBaXKdTrtS9iOppYXOCI6JMZiBWrX/lE05JPBB8AU2PI8Fqf7Kjux5Bla?=
 =?iso-8859-1?Q?d8MFim3U+EbeeF+qC7r+BXNtHFZ/ArC/QWr/AhSMcR4bbbUZLLsRVB2ZzI?=
 =?iso-8859-1?Q?RK0S1lpFewsDNCVQpfnEqLhDcZlbqeGfEwqSkh0lf/SWlKZq7pKIY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <24D44C131D0B1E4184995C7B10ADD959@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa112ccc-e8b0-4aa1-3c73-08d98fa83dd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 06:51:40.3184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: noC1WL2iIP/wSePmQ+m7oMcfRr3UhBZnOLif9M26DrOYIYR+uaU9TMpGml3SHZvuFk3kVfRnaPERf9gWgtWd3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5061
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: -cZpu_kyAfpTeQuvZwmOznuplTQgemhX
X-Proofpoint-GUID: -cZpu_kyAfpTeQuvZwmOznuplTQgemhX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-15_02,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110150041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 14, 2021, at 1:56 PM, Kumar Kartikeya Dwivedi <memxor@gmail.com> w=
rote:
>=20
> This extends existing ksym relocation code to also support relocating
> weak ksyms. Care needs to be taken to zero out the src_reg (currently
> BPF_PSEUOD_BTF_ID, always set for gen_loader by bpf_object__relocate_data=
)
> when the BTF ID lookup fails at runtime.  This is not a problem for
> libbpf as it only sets ext->is_set when BTF ID lookup succeeds (and only
> proceeds in case of failure if ext->is_weak, leading to src_reg
> remaining as 0 for weak unresolved ksym).
>=20
> A pattern similar to emit_relo_kfunc_btf is followed of first storing
> the default values and then jumping over actual stores in case of an
> error. For src_reg adjustment, we also need to perform it when copying
> the populated instruction, so depending on if copied insn[0].imm is 0 or
> not, we decide to jump over the adjustment.
>=20
> We cannot reach that point unless the ksym was weak and resolved and
> zeroed out, as the emit_check_err will cause us to jump to cleanup
> label, so we do not need to recheck whether the ksym is weak before
> doing the adjustment after copying BTF ID and BTF FD.
>=20
> This is consistent with how libbpf relocates weak ksym. Logging
> statements are added to show the relocation result and aid debugging.
>=20
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

