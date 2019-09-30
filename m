Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE8C1B46
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfI3GI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:08:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35128 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbfI3GI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 02:08:26 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8U67qQJ027898;
        Sun, 29 Sep 2019 23:07:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=F3F21BYuXWueTtrOKdcBzV97+lmy2gurUWhzKriov+k=;
 b=cuFgXMzFleT1HynAxIiuNZIPiQQnwTuxWxL8Tuhzyb57Y7fYtsyV1/bRlU9ECWV70/Fk
 hmPrWtR47eEJPW8Hx4SpfMlCRnQDvCa4+O+XcveMcz7r1s1L32J9ow49pQT0r0m8KBpU
 j1X5f53VdJD7WEnOw81cevvmYjDCADn3bxE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vaq7t40xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Sep 2019 23:07:52 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 29 Sep 2019 23:07:51 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 29 Sep 2019 23:07:50 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 29 Sep 2019 23:07:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPanGKmaEpZipzjbbGf+FmFcDB3R5Vu+1/Lwi5XHcnOISofM1jrgzbUu9PFT57S7L+BwJ+JjRsQxNTwKut905fDwldd49N6Szu+dvv+EcXzQ2xwZhw9C7nTQOok+aL0Q7nDPVxNmdWGNV27jFbRTJw4aY10gW+fveo+qAQqMorjBgDlKjATsJPUcmIwX8STv4hnt61wTnzZIZzEmqDXjjoW5N569ULHI+v5V7EW4CspJ0YXaJbRB0NYVJHjDm1tFxQz0Rvo2+5rk/0h7RzLjzhhKs0VqWWIUwXfaZaI3TTYYoURlcpzAaRJuFMDvhzP16uncPt2SDgrgbb96Gfb2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3F21BYuXWueTtrOKdcBzV97+lmy2gurUWhzKriov+k=;
 b=iSD6TKuDFrPLrY5s7pqcdg//21djjOg3t7aUKZBLxL4ehK2URGnyE28SXEWlaULU30+2RGSef7abCry7rV1CyGmIGRpRvOe7+KwRsez/Jj667PDH2yvVoGudJCzgDPkqOmUbfsibA5w3vgbnuEZYuog4GDkNM4bsgSetP3C6ZNT2nsRM6SEdZYfwrtagx921UFpyrQkg7Mhb67YFpJq+xxVVN3w8s3s75lQVI0b324U8KpsFIo19GRlK4pYMVyFXwKodnI/TwWmmC3ymy3Z96eVgx7moCyjeTm+SmUsraKzbpmcWOsIY5IudKnNBQGhicgkLTfU4YlBIlLouRN73CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3F21BYuXWueTtrOKdcBzV97+lmy2gurUWhzKriov+k=;
 b=BCUYVTaFxku8UtxVCrw4NkuwI4/BiSBkbfhTMxWTgiiS8/W8tA/q476FhsfARSA5SyMaTkkrAGs92w3NjlX6200It8d8dr5rNLLMFHF6mRs5BcaZhAurkKpmLPAbpTjYxroeunI/qVoY6HeA/paIXTaB4pMFmkoN2cV5VkNnUSU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Mon, 30 Sep 2019 06:07:47 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 06:07:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
CC:     Stephen Kitt <steve@sk2.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] bpf: use flexible array members, not zero-length
Thread-Topic: [PATCH] bpf: use flexible array members, not zero-length
Thread-Index: AQHVdgvJY5waAsiNhEOsaINEV/KuxadCJ12AgAGXToA=
Date:   Mon, 30 Sep 2019 06:07:47 +0000
Message-ID: <F15E974F-4B7F-4819-B640-682A0A3A47C5@fb.com>
References: <20190928144814.27002-1-steve@sk2.org>
 <02a551bc-7551-7c0e-0215-5ac8856b0512@embeddedor.com>
In-Reply-To: <02a551bc-7551-7c0e-0215-5ac8856b0512@embeddedor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::387f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b21fa51-7acf-4895-e6e0-08d7456c8462
x-ms-traffictypediagnostic: MWHPR15MB1165:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1165FC1DD257B825E140DC9AB3820@MWHPR15MB1165.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(366004)(39860400002)(346002)(136003)(199004)(189003)(66556008)(446003)(66476007)(76176011)(478600001)(6512007)(476003)(64756008)(8936002)(81156014)(256004)(99286004)(91956017)(76116006)(486006)(81166006)(305945005)(2616005)(4326008)(66946007)(8676002)(6436002)(5660300002)(11346002)(316002)(25786009)(71200400001)(71190400001)(46003)(14454004)(2906002)(6486002)(102836004)(229853002)(6246003)(186003)(6916009)(66446008)(7736002)(6116002)(50226002)(86362001)(33656002)(6506007)(36756003)(53546011)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1165;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RhzOLXOgp5Nmn5vb4x/4MiLOh0f0knFjoknWg5TNKO3zGRMgTgg6sSiew+RuRrZduuon0RyTg9wM9CF4/Y7HKzlJKltY6RhMi6PuNssMuyuQDU8kFxtmMe5RB3wi9enkcEmMWlkZvaOBb85JlqCwsyn5uZlk6c+PJ+verwvtq2ANK/rijTFkRhd6oMkHSBd5NQDko03hUVB4n3b8hAj1+BikIJBR2Pvi3G0gfg5sGoYQqG/i+8vDe8EUFOXiukCcG/KODi0H4Eqffn8NoAOJNVAu1eRXTTOSuvdKihx0pJR9L0Ms6nxXQBjnAlYcw4NP3hfk4l7V5l/IW5Fm+bgDVztIG3gTtiMsUszeIKqtUnk6hG4ClYLwzszqt11u0olgRjdwEauw9gJQ8WY1qfrt+tl5vPql8xGjOkVYPwjFVxY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B0E49F048999546AC9E78A9D4672E28@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b21fa51-7acf-4895-e6e0-08d7456c8462
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 06:07:47.4913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2daoBlwys4j2B5hioLjlu+TTopeACKrXCycB8TFgCWcZ+ljbAwi93sJ7ZzwgC+AZuWeTop4HSD0Z4Tv+5p7/Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1165
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_02:2019-09-25,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 mlxscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 28, 2019, at 10:49 PM, Gustavo A. R. Silva <gustavo@embeddedor.com=
> wrote:
>=20
>=20
>=20
> On 9/28/19 09:48, Stephen Kitt wrote:
>> This switches zero-length arrays in variable-length structs to C99
>> flexible array members. GCC will then ensure that the arrays are
>> always the last element in the struct.
>>=20
>> Coccinelle:
>> @@
>> identifier S, fld;
>> type T;
>> @@
>>=20
>> struct S {
>>  ...
>> - T fld[0];
>> + T fld[];
>>  ...
>> };
>>=20
>> Signed-off-by: Stephen Kitt <steve@sk2.org>
>> ---
>> Documentation/bpf/btf.rst       | 2 +-
>> tools/lib/bpf/libbpf.c          | 2 +-
>> tools/lib/bpf/libbpf_internal.h | 2 +-
>> 3 files changed, 3 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
>> index 4d565d202ce3..24ce50fc1fc1 100644
>> --- a/Documentation/bpf/btf.rst
>> +++ b/Documentation/bpf/btf.rst
>> @@ -670,7 +670,7 @@ func_info for each specific ELF section.::
>>         __u32   sec_name_off; /* offset to section name */
>>         __u32   num_info;
>>         /* Followed by num_info * record_size number of bytes */
>> -        __u8    data[0];
>> +        __u8    data[];
>>      };
>>=20
>> Here, num_info must be greater than 0.
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index e0276520171b..c02ea0e1a588 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -5577,7 +5577,7 @@ static struct perf_buffer *__perf_buffer__new(int =
map_fd, size_t page_cnt,
>> struct perf_sample_raw {
>> 	struct perf_event_header header;
>> 	uint32_t size;
>> -	char data[0];
>> +	char data[];
>> };
>>=20
>> struct perf_sample_lost {
>> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inte=
rnal.h
>> index 2e83a34f8c79..26eaa3f594aa 100644
>> --- a/tools/lib/bpf/libbpf_internal.h
>> +++ b/tools/lib/bpf/libbpf_internal.h
>> @@ -86,7 +86,7 @@ struct btf_ext_info_sec {
>> 	__u32	sec_name_off;
>> 	__u32	num_info;
>> 	/* Followed by num_info * record_size number of bytes */
>> -	__u8	data[0];
>> +	__u8 data[];
>=20
> I think you should preserve the tab here.

Agreed.=20

Besides this:

Acked-by: Song Liu <songliubraving@fb.com>

