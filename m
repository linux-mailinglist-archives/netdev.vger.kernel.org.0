Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8367E2337ED
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgG3Rvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:51:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38848 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728035AbgG3Rvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:51:50 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UHor4Y028113;
        Thu, 30 Jul 2020 10:51:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=u/gzrupJC0+mxkmxYXVcbP9aZFsovPBr7F+J81FPEro=;
 b=CHZnumBsc2/VU5MVUbO2VBGxIwhpb4J7rq9D8Z5wB2FGHtlOKYg95FkIxB1F8nKNAQ1O
 j8Ii6xKzHMACsQ4Vx/0GQgCsT+rmHqXtHJWt1UQIO9VAej26uKh2Jf6FeHH4Rx4NkMet
 h6W7WEmUXXysAPGiaygDotR+lPI6y1B1ReE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32jp0uukn8-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 10:51:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 10:51:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYfGwthaO4ymA7jIsVZLnMLjqMF+2bTwuz3es8vW3ZbCLjMnUAGTNIr39/F4jLh1Ifer7vwylfjKe8FNpBEtcYQxL7+DH7xOo4RGrFkt+sjdAMubcw8vvK04/HpGtE9VlnmbYPtEvuNJ6r3xVbIR2ZCFHfSczIuhrxXX+kTVXKj8jKeqECCYj7ky8/LqiB/7IbBw7YSCwAtiv4eJOe+wCI1XI8O8aObftLKte6ECVEq5+YYhyGRXRrmxOhfXTZPPmBvwNwDGImUWsv0GSQjBOOUgLL3PaC4EzA/yolyegz3T264theZC6RR7eXCBU+cj//RibtUWiRP22+hEVAnhlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/gzrupJC0+mxkmxYXVcbP9aZFsovPBr7F+J81FPEro=;
 b=HG3x7hTF6i1A8ZRl7WXsTX1GzGigHes68vtyX+GLT6hjomj4RM7Z8uVYsM8Z820FBaq9TTk1z5QJFsYGjrwj9ht3fTqR05KdMIzvFtSkHCBJyzc5BSauZPqbrnoaa0EwsDqjxHj/fNaJds5z9cGfF6EDE3zsBrWcKw+GF4m07U2Q3ZV25e7uZ1ygFUe242PH9+Ym4/z+k8QLhCXW5IydyYdx24BByu/yiA2oLaUX0TWVgqklQj3h9PxzS/URVFpCq2I8rdCt9bSmjL/xQz9Wn+B3cUZn59+6oVOdSpsG/xyLOV0omHZ1x7huyGRwmn28DKGZ2jMHin9T+gsK1gbL2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/gzrupJC0+mxkmxYXVcbP9aZFsovPBr7F+J81FPEro=;
 b=FQModLoKUkGgnwhRH547+RNd/ce86WstyCFjYyhxkvzdxftR8IX2n73pIBpYh6x3wLk0Pk+Uhw1QUnpKzolaRBzI9aL6a7EibLkBOOQOXzfKoyUNPEVcyk9Ku6HHUeP6YiHzBJJ/r1j7Lahzb04sRABCWrQJHJh8BzJcK9VZP7g=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Thu, 30 Jul
 2020 17:51:17 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 17:51:17 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: add bpf_link detach APIs
Thread-Topic: [PATCH bpf-next 2/5] libbpf: add bpf_link detach APIs
Thread-Index: AQHWZfzZ70qIcOi2KU2m/MoPWxxmVKkgaBEA
Date:   Thu, 30 Jul 2020 17:51:17 +0000
Message-ID: <5F019E18-DDF2-4F15-AEE7-41C9A248F124@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
 <20200729230520.693207-3-andriin@fb.com>
In-Reply-To: <20200729230520.693207-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7c82dfb-bb60-4961-780b-08d834b128ec
x-ms-traffictypediagnostic: BYAPR15MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2693CBEF74A4FC53505627BFB3710@BYAPR15MB2693.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ebEQjE9Lp4LLe5Ru+DzhqG1NIZby7ik5B0FSzabnv+L5rUZNY21t93+6LD9XNRddwVqieiHqEeVXXl8XvLzHWZoyCzGqBP1+rsnnpnE0jIfO5NO4CMuKD+g/+OlFhJIDcAsHdm1OjSW/5u+soHWy34rtCNjSv0ILxSILTW2odmWdyN/bZ9FDB4mliswtXXVXDM+c3e268EumlIz2DfR5G4aKcj7U8vtQrgPk/2UJ88a3W/BA0q+WhUSJKrk264c7J10ebHGzjoqum1vytLxgW9ypiBuYkzp9nfvlzKIfW6F5gSnRPDP82DneBfE5FlO7ZWcByzxFDKpMv+qIH9Sljw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(136003)(396003)(366004)(66946007)(66476007)(66446008)(64756008)(66556008)(33656002)(6486002)(8936002)(6862004)(54906003)(36756003)(2616005)(76116006)(53546011)(37006003)(4744005)(6506007)(5660300002)(186003)(6636002)(86362001)(8676002)(6512007)(4326008)(2906002)(316002)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sJyZQ95RBZnz2DsW1JAbjPBx2dujZhB5mEK95xZaloaSBvl9+70vx0UrNuz98DGZJPSUznTvPUjJHzS1oiFgHZ1KM1FUuUss2wpClYGplA5ZWS9wB9nUGZZLzxDQ3T2H0Spd7XGUus7QMjq7U/IeJ7j0wC2r8o+PPltXLgJRII44P8U9Y1vkyXc0WnQoZw+EjIydQojB1Mp86ZWPemeUyf8bJ+r8grrXIjzRSWrg88SgcxcXCoz30r1KPW4Bv0mbzX8j/5kRvfW8gYYVItVnI/hiIp9n/S6cjeKgi+0IGPwOCL29qJgDr+F1FkYRHbETBYnDZf+SxVzDCs24FD0FNeEKPTYqv1efY4uXZ6CoW2O7wxGs3MjKk1x3S+CUMvYi/OQ0UMld+dlcMh0AkH8tdETn6A3nDPewLMS6kT68DK09E8oOkNQFQCPx5CBiUFXaO6T7Sq/nIhPEI+GaM57TqsQNaA0UTibyEAmA6rrj1jMCYZyX8iYHWskAQSDUsCq98YKLd0fI3S6l1p4khpYpIA==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C3E69AB0B7E93947BE674344C6FA6426@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c82dfb-bb60-4961-780b-08d834b128ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 17:51:17.2117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IEAU5NvEMlKacsekPkHVvPpB+54qp4st5HzAwZyVN+65lK9oZn0Qr0Wkpd8NCbk5BqlHole8NCSINKLWtTS9eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_13:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 mlxlogscore=852 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add low-level bpf_link_detach() API. Also add higher-level bpf_link__deta=
ch()
> one.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>=20

[...]

>=20
> LIBBPF_0.1.0 {
> 	global:
> +		bpf_link__detach;
> +		bpf_link_detach;

I didn't realize capital_letter < '_' < small_letter until just now. :)

> 		bpf_map__ifindex;
> 		bpf_map__key_size;
> 		bpf_map__map_flags;
> --=20
> 2.24.1
>=20

