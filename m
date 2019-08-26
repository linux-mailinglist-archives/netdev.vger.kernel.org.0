Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E4E9D98A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfHZWwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:52:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7060 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728062AbfHZWwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:52:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7QMojnX015848;
        Mon, 26 Aug 2019 15:52:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ycosy/cYSNdw5cI5VbH6OliCDfwWyMkYyNq5dv5bj+Y=;
 b=V+FZmKZeVCfQbKkA6LcdNNWZbkPojJnmZ3az8rjqkkdcQ+4W5N99DssESey/9HszJBic
 zaN8Ht8x9CagjlhdXwF4ROI3indN1BErtkl55Ayt0970NEt6sNSLYlox2UFlwhrF0BzZ
 ogLRO4Dk6G9SmXWlZrlmuYOgDGCLhB4+3GE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ummjhs571-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Aug 2019 15:52:17 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 26 Aug 2019 15:52:15 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 26 Aug 2019 15:52:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcRHvZBgN/ZuPqict7puX/q08n9rxzPyW/gJK3j88TI6fyW6ezATufeg7gNuaNHM+CTxclb4+ib7el2TC1CFzEjPl1N5s9+AHJMbg2Y75BDhJzw/60rTE0hfRTXEnfR2wD0+84KTW0c+X7fTXUWdyErdrlvBvEhHz+uZ5pDeDC8WPomPyv3ZtEMx++AtVx+rNY5d/vnl5WX7VytNHPAh+aZN5RBAUNrHVvbH6XIPxviehkkcXapkYyALhvKMvczlUu++MS6zXvE1NcRhowZykAmDSCW1mP0wI0J2voXlS2WRC9iZVhd9H7RdMji07ZiaVfll3nmAI8Xvwsx++CulqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ycosy/cYSNdw5cI5VbH6OliCDfwWyMkYyNq5dv5bj+Y=;
 b=T99z0Ui2gSZBUZGDV9d01R0EnYkCfimTnrGGYZ0LFD8DVjNCjvfmDdNtAI583R92eYOz8d3eBXrRoeyqzScN2aO4SzGO1Styqh3r5MDjdcnO3PKCA9mkc/hBcfUL9tQJQ6et3g02nkJhpVkTQJ2xNvG3bgRU/U0ysDFcHmxDdnI2y6Mx1NsNK9P7fbwPDzNZT08l5nz2y+kCpSjrf8/M5BX4uF1bPLSQJEDjI+Sh2HRrFuopTFhbDKChvqmEn+F0wjnl4t1Kt+NgT9qOl8jasWSWkeKA35crR82zX96BCoaIOIvLeYau/wEwGwFXwalBvjbgx9FGi//ZV2/4Xmq5RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ycosy/cYSNdw5cI5VbH6OliCDfwWyMkYyNq5dv5bj+Y=;
 b=XEPAfHXF10BjXLvAd0t6gN0n8zqKJEHSaLp6Zcj+6XR++vmkLjfncEw6TA37J0+TNQlsXIIHRZcp3Ghj85DWEG9zw7d9pGRnHd9/0dMdkvzuWyj3Hi0YbSbvlJzhVf4uk4rAlwoXRl0OJHZG9rFNpWNQSerhOcvHXuHnl5ETwok=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1568.namprd15.prod.outlook.com (10.173.234.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Mon, 26 Aug 2019 22:51:55 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Mon, 26 Aug 2019
 22:51:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: verifier precise tests
Thread-Topic: [PATCH bpf-next 3/4] selftests/bpf: verifier precise tests
Thread-Index: AQHVWXb0rEhfuVfHH0izKlqz0u99iKcM6YGAgAEkBoCAAAFBAA==
Date:   Mon, 26 Aug 2019 22:51:55 +0000
Message-ID: <30110E6F-8895-4C7C-B5C6-36361D294A2C@fb.com>
References: <20190823055215.2658669-1-ast@kernel.org>
 <20190823055215.2658669-4-ast@kernel.org>
 <CAPhsuW54=MiBfLp+AL2ASqaoGOf+p9D_VXxBYcR5fFpBrdEGSg@mail.gmail.com>
 <20190826224724.edxfxbkv6r5wkg6o@ast-mbp>
In-Reply-To: <20190826224724.edxfxbkv6r5wkg6o@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:73d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d7937af-7c69-48ae-8036-08d72a77fe56
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1568;
x-ms-traffictypediagnostic: MWHPR15MB1568:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1568F6AA7EDC69F7163CA667B3A10@MWHPR15MB1568.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(396003)(39860400002)(346002)(189003)(199004)(6436002)(25786009)(71190400001)(71200400001)(86362001)(5660300002)(6116002)(36756003)(53936002)(2906002)(6512007)(99286004)(476003)(53546011)(6506007)(6246003)(81166006)(81156014)(8936002)(50226002)(4326008)(102836004)(8676002)(54906003)(478600001)(486006)(46003)(2616005)(33656002)(316002)(14454004)(66476007)(66946007)(7736002)(66446008)(14444005)(256004)(57306001)(64756008)(66556008)(76116006)(6916009)(229853002)(11346002)(446003)(186003)(305945005)(76176011)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1568;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0YmbRshJxYyCLqOqX1gn1X8L2f9OnQ6AubBwjAz7nj7gPYzNXvoxK+xqsqQ4Dn4eDKX6z8wi5DRRCcNF+o7bZXIEnOZacZzYjfVM+lVVwBfUeps2WbAQ3wGbMIQoiinQJaoCC0UAO2Spw1Vh+DmlJ7StMG/BffiPYCQl6OCeNuiLtT/iEjce7ObOFOYL1LGT0HKHZ7TjohEVMdh0PvtikEJP6nowWlK5IOdvYzqy4QIQtI+w2t6DClc5+9xeW3PZAK0jlUXcesdGp69Z1Bm4MKslTpXCsWDBxaJ9ISNlxHcYCvWUb0xXwDbphll3XyIstJcg/aGEMu0upBOcX4b9b1Ly3AOwvLgG5pPJDvZ1tbJOUXnXLJ+PW+2HI7Yo5/Y6OGV5imdN9VE4kp1SNl1eOCV5HWLFNROS36Zzgisarho=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2BC07EAE2B562644AC19F9DA5274B3C2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7937af-7c69-48ae-8036-08d72a77fe56
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 22:51:55.0322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tHfVzKcElOGRQl/Uutrt/YYcBXOO5jYju/A9ZI8SfsysYRQpZ/jmN/RFgOSh0xzLnFeD02cxs7iL9LltLVOzkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1568
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-26_08:2019-08-26,2019-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908260212
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 26, 2019, at 3:47 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Sun, Aug 25, 2019 at 10:22:13PM -0700, Song Liu wrote:
>> On Fri, Aug 23, 2019 at 2:59 AM Alexei Starovoitov <ast@kernel.org> wrot=
e:
>>>=20
>>> Use BPF_F_TEST_STATE_FREQ flag to check that precision
>>> tracking works as expected by comparing every step it takes.
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>=20
>>> +static bool cmp_str_seq(const char *log, const char *exp)
>>=20
>> Maybe call it str_str_seq()?
>=20
> imo cmp*() returns the result of comparison.
> Which is either boolean or -1,0,1.
> Whereas str*() should return the address, index, or offset.
> Hence I used cmp_ prefix here.

Good point. I didn't think about this.=20

>=20
>>> static void do_test_single(struct bpf_test *test, bool unpriv,
>>>                           int *passes, int *errors)
>>> {
>>> @@ -897,14 +929,20 @@ static void do_test_single(struct bpf_test *test,=
 bool unpriv,
>>>                pflags |=3D BPF_F_STRICT_ALIGNMENT;
>>>        if (test->flags & F_NEEDS_EFFICIENT_UNALIGNED_ACCESS)
>>>                pflags |=3D BPF_F_ANY_ALIGNMENT;
>>> +       if (test->flags & ~3)
>>> +               pflags |=3D test->flags;
>> ^^^^^^ why do we need these two lines?
>=20
> To pass flags from test into attr.prog_flags.
> Older F_NEEDS_* and F_LOAD_* may use some cleanup and can be removed,
> but it would be a different patch.

Sounds good.=20

Acked-by: Song Liu <songliubraving@fb.com>

Thanks!

