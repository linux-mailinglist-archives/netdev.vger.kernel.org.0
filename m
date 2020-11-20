Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958172B9FD6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgKTBhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:37:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726799AbgKTBhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:37:46 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AK1bPJu029616;
        Thu, 19 Nov 2020 17:37:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TzRgS1qjjcOBA+XjVRWRu6P0UonR7hF4fJDLbnYuKL8=;
 b=b94n59j5wmce32fzCxrtqQ72Mpmxsi+KK0gb8X4HSET5V+0gj+zLU4cm3Gbv2RQVXfPI
 ohApk+Ud0fefskBANxwimoCuYMcDMUU2dY8NjUcOAYAGSO56Wk83KKQAlqL4Pi2/3Z7y
 UOJZ2uq5Xi1enfH5CkzE4hJIhzedy3J19AU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34whfkr5tc-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:37:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:37:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXUvcAet9q7RSVBR7qZHCYIwAGXCQALW05mRnknwjOqYArCj/qwEPzVVuZM1lvpPVtp+mi0gnU3GzWwrMIUZ4Bp0XIt5LCMqfDEvGVI49AiBPRQEIM2YpmhbvshGZqrCuuFUg7tiQUIS51Js3hf6j8mvhX6WsDjsnzhqMcICqexbpgbymJAifVDdXtzdRLLsRo9gTODhtekXwjOFWB+Xlt55M8Fs5gslJEcvi4kam6NyV1gGbbVcbjwgWsuoeqnHfSSTv8bwS/IeZfwpy10S6UaJvct7D9L7nsdwUtUCysojyG030NSNJstAROFGWdLDtBp+gWQchnXl5JwWLEdL7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzRgS1qjjcOBA+XjVRWRu6P0UonR7hF4fJDLbnYuKL8=;
 b=Fs1yXyS6VYbiQsLIsmtsZD5VV10q7tKjB5LsoXeW4P4OtYdIDj1uyZN+YcWVkh7j+6T2R2uqv8Of3bWbLta9RivAWidiG8hrs5/GEZ430ZgqNHUTT8Q+fZ62yXHwISMUQoB/6mgaS+Q1oNHXPNlIm+JzGrEjFla38MmY+D7RFl1KwDv/Jd+Yl+KMze8p3QwBCjcJH1KOUCVy85KI8vWBHpqIshzi+a8ZDdPP6f3eZhFrvmdEWTxrc6a+g9POxyXGJH/nDHXjcZx82u5MgI60Kt2oyDdBsFa8aVX+nvKpECk+abaFkunzbiV1V8MWcFO4rFlfEApRtqHctxXFyFukpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzRgS1qjjcOBA+XjVRWRu6P0UonR7hF4fJDLbnYuKL8=;
 b=GdUMmzAifI/T0z/V+1ETd8ftP83Oa+Ba9TjajTkf2xX+Iqi1L+ttmcOq7+zf39n0WduTxbLnbyWPW0rSI5NrCq7PUyn5gZzBT9WZSC5oK86D7FdwYoAs0pmolD5zV7mJDe5UdEEFn0W/2RSG4J0smfcWRs/NwtV3Qm49UFzzuxs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4118.namprd15.prod.outlook.com (2603:10b6:a02:bf::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Fri, 20 Nov
 2020 01:37:22 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:37:22 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 10/34] bpf: memcg-based memory accounting for
 cgroup storage maps
Thread-Topic: [PATCH bpf-next v7 10/34] bpf: memcg-based memory accounting for
 cgroup storage maps
Thread-Index: AQHWvprfyymIc34q/Ee78x9HUAQLa6nQPiqA
Date:   Fri, 20 Nov 2020 01:37:22 +0000
Message-ID: <2098EF09-3A28-4A7A-852A-865D729319F4@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-11-guro@fb.com>
In-Reply-To: <20201119173754.4125257-11-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 592167ec-7437-441b-ef65-08d88cf4d3c9
x-ms-traffictypediagnostic: BYAPR15MB4118:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB4118B81DB1E479777BB818D9B3FF0@BYAPR15MB4118.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C1e2LErBX1LJx369rKfCdkuwEJtyb8qSmGE+2Ak/DnEIZDinbVWN9UfCzqYNmiboJIFwjowWy1n4583DHfUBOUtOCrKR1xj5uzSZbxkB1+1PLnUOBQARJIuVyopp1OVXnNvAQkgOd3p6XNXoF8jfGbzvRgtcOBfmIOFCz+m/jEKHkwWx5TLbRiIhLBHrwfae1a/dOlSZRjZSjIKGcPstySns46ocm/lQOlzhBIUU8TMNJRcfHQBVjRDNMwYqajZ/hGr4XmBxUeS14x+3fa7ZnYyz59yEaa37l08msrfFM4pTmzMv6kq8DyBgzRj8zdBKy/R5I2xW8dAObl4P8Dvsig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(366004)(39860400002)(8936002)(2616005)(4326008)(6512007)(6506007)(8676002)(5660300002)(478600001)(33656002)(66946007)(53546011)(66446008)(91956017)(66556008)(86362001)(66476007)(64756008)(36756003)(76116006)(2906002)(83380400001)(71200400001)(37006003)(6862004)(186003)(54906003)(15650500001)(316002)(6636002)(6486002)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1wJDIs/ev9ImLvhcxpdhJwCh56SawWQu5jVMl4j9wb8iHZsb5FUpNhm3x8TWtRk8uToPDppkb0OmIp5Tc4nkkI525HmHpbdlDLKFbSrGK9YwXwsWCfe7KGCMSzLoowXRd1EwBNuTYgJyqHlo4B88r6SvQ5z2obq63XzAyYC53PigrL3Q6EH5pAj+N9BemJ6pD6aK+tvTDsf/AMoKFvTk4ACI6sfpeDbNKAnsHFUGmhBrrOkzT39APFNIPaH3a9NV6ydv+vFXrKnE0vVfi0Gzp2moqxLfw6az8+ftaLLzYAFVscnFmiYc2YIHtxwMF/FVrx9Da7RR3ISAXRDMx5YOdGX3Lp0eMmf6v9pUre3eXYLTtOwF68msJQM6BJBIlgUsFHoi8UIbi9jt5qicy6cjwPQkQmJfdR5nhWKPBMpAp8s7vafwgEBIoligmng251gjFl7+kF9tQQP0HEZ48wbD+8JyXX6M5sWEu6A2KqQ0hcN1IRK/7jX6Vlap6FjhupJnu6lqeJ6jna/TUWN/XlkcVVxtJYmJu+uso97TxWIm/eMaqYlAFnOZZrriqaAeckGqKrDTkkVRzvl+FZ4sjHJFqFQH/PGVFqI4P+D/mB8Mv0whqIGBlvPZcD7yFWZGKEZZiTrPq2BJ5mgyDLXLm9H9nOC6MN5SKhIPhTDGi4/w9to1piEOQ/em453s96JYtzJT0tkQ2rV21M2EbaSN4R9OpWhqmjvvK7AWXmUUx0ibTXX+TXsJfctSRlnZYFaDH2QT1ot45qOO8BrTGFf1KJtR4FqePhtE6DePZuHqtnLwbpnx7CUBL8ADtR0vE6lW+EK8wVdjNaOAFBaJGBKA7BeNe9RBLsYDrS7EICkEu/r4yBkNi2/ELwjglEHsdUXzQrDXBKmpp7ektqrLYvCJ2206SxTKShXyl4T4xNxvx3BQwv8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43E1A9745225304C96AD75AD0A7C6683@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592167ec-7437-441b-ef65-08d88cf4d3c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:37:22.5191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hG+Yr6ZrxnSb/FvVzLFEvxMwhD4LwWRz2idstKez1lVFJ0BIfhAZWw9iMcJPzV6+pFAeYAqThO5qSewo5n/Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4118
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=922 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Account memory used by cgroup storage maps including metadata
> structures.
>=20
> Account the percpu memory for the percpu flavor of cgroup storage.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>
>=20

Acked-by: Song Liu <songliubraving@fb.com>

