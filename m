Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020132A73B8
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgKEA00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:26:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3142 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726746AbgKEA0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:26:15 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A50JqUj028618;
        Wed, 4 Nov 2020 16:25:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=s8B9W7Jf8bbbGlUaBtPSEEkSBBdJ4gRkieu857Y4cfw=;
 b=KyqyGCZVClzatBCcyWPCwm8AE5I6DMeaUx6ba/ySH/QgjHcSR37x7q6zDOQqxTW0zW8i
 3jcNnSz2L950B2Yw8yiYIypQ8+eTedXak3HDOHvYaBGhx54CQtm8hl/EWOVFHDuia3m2
 zZhV/wXcXFSMlFA3wtHNaIR1bZgOAI9v2SA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34kbn7ged7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Nov 2020 16:25:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 16:25:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5ciKZDYz3f8LIsPa+ZGNf5A+AJ8RCwF5TscqDtdACaVaGN5XycsN5rIVDmL5tTDGKZipd9aDxM1bi6H4NPKx+H4kcyvUzfzzzOKcd+LfLRwUbDLWy/QxIv8tBFenRm0CBTF857eoYEfBQglZZOo8I6PL3LsZ4uQZn3cVSJBQB8Zd3G1dICvLayAPG7pkvplCPb4TvDRjR6j0+/Sutv5iLTtX8pz3wT/sWJbbb8asvaJ6Z4uNI/KGnrJZi7d4vgQG0bYkn4hexhYcH/QBLLDBsmAvEcxOPj+70+YHZ9G/+ryt+v+GCISkAowkZXPg7qs94uQcsYcbVx1dNNhImJGBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8B9W7Jf8bbbGlUaBtPSEEkSBBdJ4gRkieu857Y4cfw=;
 b=e9Dbl8YglbGFbuTtQknc5aTnw8Dmyzb/p+uUJL+YKmUbaVBg+svbK2lMUG7ajyPkBf3j6HWHKk3M3GW96WByMSVgB7ZobwmKItLSg3RDqx/kbSez4yq3sr5nYBJjrh+7+lyrMz60lQMJ/bgMhNRzcFwQtPKzRsKoA6yI2Wi1DsYBW7DosKjlbG8Djho+45WwC9exBMXuNPWmCa/RUhz3qitdCSkfNoJQ/wCgIXcx5IataZN1RSidNEbefgdnypLxUx1IgjIgySBBtDtG4WTuCarjQjKGH+daj0RTOdt5kZSPRT/PGNdleknBAkqqfNXmJEaWFi3+JDtaFzbDAbnoJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8B9W7Jf8bbbGlUaBtPSEEkSBBdJ4gRkieu857Y4cfw=;
 b=MKGAM+9YV2NiL0KuX44ukhuwWSY12Z5G3iSsAchgOJ0oHxA2Dxuay8EjartyAH4WW6id1a4NYwTj3+J3c6e1nRXWqdgSCR9Ey7nTqavyV/iDQvZq94jD8VBimQMZsfnIIdmzInsO2zMR3s+muQv5T1n8/Ovrd6HOp+W5bcbOhUI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3714.namprd15.prod.outlook.com (2603:10b6:a03:1f7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 5 Nov
 2020 00:25:12 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Thu, 5 Nov 2020
 00:25:12 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Chen Yu <yu.chen.surf@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Nathan Chancellor" <natechancellor@gmail.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        "Marco Elver" <elver@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] compiler-clang: remove version check for BPF Tracing
Thread-Topic: [PATCH] compiler-clang: remove version check for BPF Tracing
Thread-Index: AQHWst5LRYvR+6qVI0WcGVRxibf35am4bdGAgABAsIA=
Date:   Thu, 5 Nov 2020 00:25:12 +0000
Message-ID: <7A3072CD-AF97-4BD6-AECB-5B71DCC9234C@fb.com>
References: <20201104191052.390657-1-ndesaulniers@google.com>
 <20201104203339.GA692084@kernel.org>
In-Reply-To: <20201104203339.GA692084@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:ca49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4cd7c3a-9a33-4f5e-dbaf-08d881214298
x-ms-traffictypediagnostic: BY5PR15MB3714:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB37144A8BA48ACBFA6889C94EB3EE0@BY5PR15MB3714.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tkepw6wPPDUzs7eeXBY6OKoCXGOYCKhEszCc1BqY8jIueVHTfgf+43inrgPNbHHeAg7nBxKqS0lhAqviSk23DGbS+ZR5Lpralm53RqsLry/WGTS/VPdl3Q4w5Ng2hKvdsoCBrSLL2YjxVBXHBkeA/kNm85+SMMlaYe32dmjYhXeCfz/si3TXSaL9TprBIQcnaX3sMD3HEQ/ABlCvLKt3bil6c0Vh9ukvYYbVIYnIQeKYttjOUjE+DOaiHqlfxxOn0hwzjJDwyHUwwKTL7v6I8crSAszIvS3tc5N4OCab3ZvCXUBN7iinGHNJteoXPkzQYZLNo2ALySdsN6w7AogueQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(366004)(376002)(6506007)(478600001)(4744005)(66446008)(66556008)(66476007)(186003)(76116006)(64756008)(36756003)(91956017)(66946007)(6486002)(53546011)(33656002)(71200400001)(5660300002)(6512007)(86362001)(2616005)(8676002)(54906003)(6916009)(7416002)(4326008)(8936002)(2906002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: P6ee7psWe9e3nmpdKFmwR8DYg8M5xLf3YYGDAShciLPhlI0tFW+Jso1IyNS+pKql1RDWJGov3fgy6Y+Kn/x+hTCAsvtxayrDNaFnmKb4dJ4kBp9X+lZpF9GJFIyxZHWLyDvFC4PjbIYh5rGpSnMR/SUuxu3zP9wnWu7qsvissFPChFrgd28cgM48nXjuXqdPLZ/a/Tq9hEVsuAqXRcPJ6rKXkHxMbBRw99R5dX9Oorpz2gL9smQgK6hHCRXIFfv7PANxtHDcXhPncjzFar3/7C8/qpCgUroRo5iE6s51tgTn60J7wm+un7UYU44v4Go1GaBTH2plxNWB5V1890sk6FxRmV/XmLDJU5ojXk89JOfBsC/+OrNIgX9YkZ1Ep95C4WKmrBpnGuKbruYVaaq35oIlM3ofA/kLbtVCUNU+B0ObKaQFDvJsGT2/1TX65AnAm0y8CedI6RgZrgNe99d2zgrGgi4FrYedMuXARIFxDe2K2l9qCmM2ErSNfUH99ShJEo7iazFnfBJdWOoJqqkFSqbLgiDpxEww5g6Y+1DUKWVaHlMu6xtr3yYf7Az10F3ENmromqaSZSbp4aLebhAy/XiW1EYkqj4SAK/WHrVfMINN1lFrNcl0hcfNA5VXilRP49i3breH6sEZFlzALp2W4J1WqcHLiYi5Am3xcLbyZQLCBp1WiGWF7/zUmoaI2nVp
Content-Type: text/plain; charset="us-ascii"
Content-ID: <613D254596E3944CAD2F867DB4AF199A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4cd7c3a-9a33-4f5e-dbaf-08d881214298
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2020 00:25:12.3763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RsAAilhhy6uwg044hPCEUrTf22htmN5EvFXPpkn6iNFVf28kp7jEs7zdvAUZlE7DycvvwkB7biZZ+RmseEoK7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3714
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_17:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=0
 clxscore=1011 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=913 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011050001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 4, 2020, at 12:33 PM, Jarkko Sakkinen <jarkko@kernel.org> wrote:
>=20
> On Wed, Nov 04, 2020 at 11:10:51AM -0800, Nick Desaulniers wrote:
>> bpftrace parses the kernel headers and uses Clang under the hood. Remove
>> the version check when __BPF_TRACING__ is defined (as bpftrace does) so
>> that this tool can continue to parse kernel headers, even with older
>> clang sources.
>>=20
>> Cc: <stable@vger.kernel.org>
>> Fixes: commit 1f7a44f63e6c ("compiler-clang: add build check for clang 1=
0.0.1")
>> Reported-by: Chen Yu <yu.chen.surf@gmail.com>
>> Reported-by: Jarkko Sakkinen <jarkko@kernel.org>
>> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>> ---
>=20
> Thank you, resolved my issue.
>=20
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Tested-by: Jarkko Sakkinen <jarkko@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

