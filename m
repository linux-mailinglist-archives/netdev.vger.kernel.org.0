Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A06E2B25EE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgKMUxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:53:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22796 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbgKMUxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:53:48 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADKf9tL004367;
        Fri, 13 Nov 2020 12:53:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=puy4wuiD5nvb2dJldHTy6vEvR/UFTrSIbMb+SKikWWY=;
 b=magRjzxa1SbVcVDZZg2jn6rt/pXIFgmCXKs2sjkhlGEWU0Ul/exDDV/v2J+bsQWseIHL
 VL+jdwmCRbss2IgGgSj8KV6iXsPU+/hgyysRWI3b9YwYahfUGIw7mgYOmGl1EvIRxhOZ
 km+6G8+j4aKfSTW2ZNGMraerX4t5ihaRef0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34rf8syqnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 12:53:30 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 12:53:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oo1s68+HAmTZKUSNVb7yhf27PesHZnHGPfbMHbt20XySyk7eOoa68vADxBT7Y2pGY8Zgk7qSNWzx4dYTF1iEdUvqlraawl41a/urIZTbUSAeL4wG2Z+ywc0DM5igvq2uOApYir+q8uQg9aXeHOBkvVuLF8lKIr+NX5z6bXH7s5lWiqp+98lczook+LcKE9G9dQgF1vwKIq1883n/9PmdAtlE5/c6ULG0nXZX0YXYlsrl8G3goHVPeroHlJde0BwLvZLgf+VdLhGZ9fV8HznysgSUvrB/SMuWtHD3r1I+i6OZ+9dmZ8eiRkrB/2/Q5scdIVx4rubkA3z6yxauNa71qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puy4wuiD5nvb2dJldHTy6vEvR/UFTrSIbMb+SKikWWY=;
 b=Hw9AHKsLOtzaT5QFfUr9fSFb8P2y3sYnd7RywvQah9JFsHWMd2w1Ff5yKaHdZYvoxjjL68Y4FElKNowQjm/CrxHNidwYQtJ0kKseaHrjQpX7y+gabcb3QXevj61v5IAz+9Y2xDF+9dyjklRN8+QEFxOUf0uZDSKL6TWP1bJQfO2wC2bVoJCP4zFlKICJCCRm8oOXWbbuRyaMv3X72URMv7ycEl7xmMnMJbo5HpIYhbIGZDy8dNz6bltH/i8Eei/ja6iaf3Ug5357KnWprMR0hppn5LDXzWk5hLrKba0e1qQe1RX6JKrLCU3RCO/i8PBkko5X7qFJ+2uLqWS23JKV4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puy4wuiD5nvb2dJldHTy6vEvR/UFTrSIbMb+SKikWWY=;
 b=YQThIA+G6wY0ZF3IVhQlPwqrUiTbkkkIBaVjpKDmtw8TqDM9cQ730exOfQYEcCQ6hTr3XsRWFHDYYrJ0CEZdlfOEGVi3le75X8iH8+4RfyDWLet6++U+Ej8gNO8eu+8TUzg+/hujbBK+R9tq5rKPaxliu+c8c0guZmlKS74HSSc=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Fri, 13 Nov
 2020 20:53:25 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 20:53:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v5 31/34] bpf: eliminate rlimit-based memory
 accounting for bpf local storage maps
Thread-Topic: [PATCH bpf-next v5 31/34] bpf: eliminate rlimit-based memory
 accounting for bpf local storage maps
Thread-Index: AQHWuUFqlzOfptSqHUWGJwxUOMopjanGXzqAgAAV4ICAABZygA==
Date:   Fri, 13 Nov 2020 20:53:25 +0000
Message-ID: <0DE88C8F-54AC-4E90-90D9-6BCFB2442953@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-32-guro@fb.com>
 <4270B214-010E-4554-89E8-3FD279C44B7A@fb.com>
 <20201113193305.GC2955309@carbon.dhcp.thefacebook.com>
In-Reply-To: <20201113193305.GC2955309@carbon.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f6d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7450a60c-c8e4-4d49-ec22-08d888162a8b
x-ms-traffictypediagnostic: BY5PR15MB3569:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB35693B69508C67B5C64F3D64B3E60@BY5PR15MB3569.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5g2DEwz0zeSzyqViljpoxk+P1qqNW1Ye92CuxfYq3hcJQVZQBJsk0Zli3650aFhkhFsZWYUyGKY7/o/WNZeK7xFGOD1ZoM5Jtt+C/WPMhSWSd4rQCEZZ79g7q0uvvrlBKTMizF+TaPX8AMlaGyq5ONma9EKrd78KJRvEtdPC39hSaArqY8Ozjs/nE+GgKtr90BAZfH8qBWHznwNrSxhB89r5ifoVANcqIny2lxcztgJq8ZDZua7P22+vIAMJlZ2+jITHlnTHEC10D6KmoL/XxxoMpUzEfsiE5V0EIDY4CO9urJ5juxqLR9c0wOnrxHStXGNcbuDZ3xJfo0RwJ1i+wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(366004)(83380400001)(76116006)(6512007)(8936002)(4326008)(66476007)(91956017)(66446008)(8676002)(66556008)(5660300002)(64756008)(66946007)(71200400001)(6862004)(36756003)(33656002)(37006003)(15650500001)(2906002)(316002)(6636002)(6486002)(86362001)(2616005)(6506007)(53546011)(54906003)(186003)(478600001)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mMCDfXDXeZcsfTw464iPdDXZsabshP4GpCHz+0Ng8nPdCXv/Q9JJGhGU6fpJ7fj6rUD6YWk3GMc620+Pft/FFgMbWqXw0pvm4qGt2BFkyo2E9YMyFBI03C8AaVT1QZko24aef73WbSd2jbjECqpIV8EtXMFIz8g9C9guAxq20IAf6pEAqPLJ/ecfn1LAZlYsIUuYD7BD04KTfLoXrqrtRoGaO5pKofqgMl76UTQDa9WZ6Rfl5006x+RbPOPWrGbAfmXp98Nvk1yK74wRuQcAQqdOxN/ssOMOgaYLWJoZyodsKYvIr9MTjmZMnV9XQOvl1h1tn6XOj15kPB687cM3u60kDGdYy2397g9WvkF/wuj2gFqD4kkGyUepWm1+KPu++JqtlOqNEFlL9/EOkiIR+WSc1R2MeMV1SP5UgaWg01urjRgsg0cSyKAC9T1Ec/TOsSYl0XJNi/6vXoB5nJCv1V5gVQMFJY5WDnBS/vsV2SjiZ55JrYfZvWTkXhpu0eTZHS4dJ0m4BEwtQX2oKJbgJLIvdvGUsGFtNspK17MwSlVsD4sCwpFHMwzlQJ6vIBwF0m3L2slUPZoESzSLghzznsbYQJGFND22unoFuAWLHoitf28HOqKKPtSsxhlfm93hSMc/gTk5RG9lnCGzO/9zY5jgv8ZSbBzC9IcGJRzn1tGafhFWLzqhDEezBU3e7z2r7JtG33olzvS+489+FAwJDBszbM3WaRgR2BBfqcXEhE/7QGS9hd7NQMSWNSaa0sPQIkSXlfOhW2v1CAbDo6eXulqNx38yItdjYxdmvBUtgk8pripUzq4wNF/oAF0WEOENV5isM8vaMMj8mvn25KUwcjS15towcZAng+y3pdX0egN2NwjDTQ5E25EDyD+AhEOMNyOf/fVCLzHRM9WDvDRNNdCTu2Ckmb5bhThYKPSpcFA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C97486A773374246A4CCD57F8BDEA2BA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7450a60c-c8e4-4d49-ec22-08d888162a8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 20:53:25.7126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JHJKwSBgss93qheUf4iYC6kzbhQ3vY1LauZUmbM45tiuyxQ9P2Yq7Pw0s5jMiEKZX3KQ44KgeY7aoqMcwJaB9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_19:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=865 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 13, 2020, at 11:33 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> On Fri, Nov 13, 2020 at 10:14:48AM -0800, Song Liu wrote:
>>=20
>>=20
>>> On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
>>>=20
>>> Do not use rlimit-based memory accounting for bpf local storage maps.
>>> It has been replaced with the memcg-based memory accounting.
>>>=20
>>> Signed-off-by: Roman Gushchin <guro@fb.com>
>>> ---
>>> kernel/bpf/bpf_local_storage.c | 11 -----------
>>> 1 file changed, 11 deletions(-)
>>>=20
>>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_stor=
age.c
>>> index fd4f9ac1d042..3b0da5a04d55 100644
>>> --- a/kernel/bpf/bpf_local_storage.c
>>> +++ b/kernel/bpf/bpf_local_storage.c
>>=20
>> Do we need to change/remove mem_charge() and mem_uncharge() in=20
>> bpf_local_storage.c? I didn't find that in the set.
>=20
> No, those are used for per-socket memory limits (see sk_storage_charge()
> and omem_charge()).

I see. Thanks for the explanation.=20

Acked-by: Song Liu <songliubraving@fb.com>

