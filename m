Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF13A233A14
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgG3Uxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:53:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46950 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728048AbgG3Uxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 16:53:54 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UKoJot009492;
        Thu, 30 Jul 2020 13:53:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ToC3KU+PjZMygFI4DeQmlZYADa07HvV7h73P+ynsGus=;
 b=kWwEKdQNtThl2vG7ONAqbBbepeOu/0OSScISc8q40BwborYS1eBEMFU08MRuUSg8YT+a
 ZJK/5NNMFxqmAHzc6CIL8knOlCgT7snxxpqwgLTxOjsVw0fZjYr7MH5BY84yinVR3ubW
 6G+9to2DMDzu6ll20OfuP/B6amzXF001efI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32jk9dd5xp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 13:53:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 13:53:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpByyJ2qNb7t/+Y5sXPkLpVPXNQvWsKk1uOcYhm9at1JBPr0StLmCfF/k9N8vB3REDXSxRdWajqo8QvTEn2nPjZn8dhhjmx68jp8nzrItHD1JcpncrQ9zEGN17TemT0+V+Ew1K+OjURENbmB04A0e/In/hvVikYchbwoHcvXHPQTNhFDyjwTpT9jrDN/umLZt9BI9pOQle5lhHqCWPwuqogH9hG2VHp3k9iz3UcOocwdx88DWgC1MahkkH8UqJ9atst8Xh2v85KmH1TEEQ6WUo9vLdHv2l/q5Pb4DepJVJ5btDGUO++G3GYZKzPaa4/jikqS3vT7vUKaDf9KroSnjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ToC3KU+PjZMygFI4DeQmlZYADa07HvV7h73P+ynsGus=;
 b=nOaxu8QcWRW6Zt21Y3vXoGoIu4OUykbXzyfkVgvt5tXcphZkjS5rfuYzt2GOaVnZ5SqrsmUkoOUHHDSv+ByDmNEbIRE1drhUEBkWC6d0WG49VsFG+MI9T+PB0VLxem3xVggN6oNx1by2kK69YDEMkR8z3cxwBDBwi6SKmy4UDQiTRIkUQIrsqZkhOsIcksGwcwkVGmNYDfvdN0zFp0mmGWXoOBLT/brLLno5HjHsrm4HJ0kmF7TvNLIi2O7j2QKfSXw8g79ZP0ee1XQcq0MRlWZ6kQ9+TLcmSsUAjpAK2906A0zif6mSCiNnR/v2Cf5hIRxB1fH3xRWH0PQLsv89sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ToC3KU+PjZMygFI4DeQmlZYADa07HvV7h73P+ynsGus=;
 b=ZrnGrP6VkZPX9T/BzLVQ7SH6Reym0Id0xFz5WmG8TRe4ycCv0IyrZuymk5Iw+WInBDHY7Jihj557kCpFROSxkN76xaHFdAvmeqGlQCacjyqU9u2mDCAnz04PZwErXrG4RF7Wkshz/jubTbl8wAJ3hHa5L7SqD1eEBW30PMl4+NI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3367.namprd15.prod.outlook.com (2603:10b6:a03:105::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 30 Jul
 2020 20:53:37 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 20:53:36 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 1/5] bpf: add support for forced LINK_DETACH
 command
Thread-Topic: [PATCH bpf-next 1/5] bpf: add support for forced LINK_DETACH
 command
Thread-Index: AQHWZfzM10o3KVlXF0C1TJ9tT1+b76kgZdmAgAAWiYCAAB6ggA==
Date:   Thu, 30 Jul 2020 20:53:36 +0000
Message-ID: <AB15F376-3AD2-431B-BABC-B66A139864DC@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
 <20200729230520.693207-2-andriin@fb.com>
 <E5C327CB-962D-46B9-9816-29169F62C4EF@fb.com>
 <CAEf4BzZsYoBZjsSKgQ-+OYRCa=Xn1EVwmdjGM5FG5oZv7_9vkw@mail.gmail.com>
In-Reply-To: <CAEf4BzZsYoBZjsSKgQ-+OYRCa=Xn1EVwmdjGM5FG5oZv7_9vkw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1c38a8b-b7c0-4437-5e46-08d834caa177
x-ms-traffictypediagnostic: BYAPR15MB3367:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33675A9676FD270B13CFD335B3710@BYAPR15MB3367.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6B2Bb+hi/tNvTdkExx8BCGGHSrckqjUQ+OFDPAnGhRzBYgTljriOGRm+W7PCpERDpT1J2KostOrXvUE4/k1X8dlZd3UmrutbDF3hUHegFi7UO9/7afPeM2g0MeuEJ834qd6tihOIb60qxzbZPLS3URpf1RAzCoNo3mN++4kir8fYovQea23I1wEhXW9Yh0mVmB06ZUx3PelMzKYHsQD8UM9p0XjXv76vJeyO/WWSjWPGUIiDIqHgmtwBHYr4+rwKvBgWMdd5BmPz4jEThgdJ4lxPqeCh2tcyPzzrm4h0qIJ5S/n9H2XDRXukg6OkSM9b3Sc4tP3+2lax472kBFDznw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(6916009)(36756003)(6486002)(83380400001)(86362001)(186003)(4326008)(5660300002)(2616005)(71200400001)(6506007)(53546011)(76116006)(33656002)(316002)(54906003)(6512007)(66556008)(66446008)(8676002)(2906002)(66476007)(64756008)(8936002)(66946007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4immLlbivkNVYkKxnsh3y1XACx5ul128jXaAxF127l199laSiGPyJnqmY18LI2+srh3TUoXs8F76Bhafsy7yl289CUsBBBJZVMsGogUklvxuuZNG+1aQCo5n4RqVcebkB3vmQnpOBTonyLDK8McP/kB8SAsvvtXRSMgPpqg5V894aKczM9AXkYUtvlL+Jmo/Gtj+oJDGOD0TLRcM9o5qZd3Up3J81l3uTsDr7M09LOUDTXDDKPL2vnilcbwDKa8VzSR8UrOO/IQqP2+r/USfyUqyDVxS312mYzlaJbtWq9BAHyw/Bge/DI04rv5Zqv0gubmzPmfwKKrlRiRB51thfCdH72G+gmNJ8YMtF9r8sbNkJFvRScOF0n2KA3rdMr33X2IkMarr6iZ2BcM1v8ETAXC0tcJ835mHrP0o7vsubRa66ZGP/v18uUkTQtAqmKQ6kYAS8si4VbGEiOt3jf4w8GrqW5A0AtCdFbmMvrtlVtFpI227bW3/2uI9owRfcuATZMXdY4IczWSzfrEwRwu8RA==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FA7E7A70ABCCD8458E3C8E6F9EC61BDD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c38a8b-b7c0-4437-5e46-08d834caa177
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 20:53:36.8598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZWOUxbxwxwkAmgTOv97UIn11aojVddheBcYEr3sPvOp/Kb8OR00UQ67Ew2NIpeXdaS2MYUEDBIbmHbtK7yU6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3367
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2020, at 12:03 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Thu, Jul 30, 2020 at 10:43 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Add LINK_DETACH command to force-detach bpf_link without destroying it.=
 It has
>>> the same behavior as auto-detaching of bpf_link due to cgroup dying for
>>> bpf_cgroup_link or net_device being destroyed for bpf_xdp_link. In such=
 case,
>>> bpf_link is still a valid kernel object, but is defuncts and doesn't ho=
ld BPF
>>> program attached to corresponding BPF hook. This functionality allows u=
sers
>>> with enough access rights to manually force-detach attached bpf_link wi=
thout
>>> killing respective owner process.
>>>=20
>>> This patch implements LINK_DETACH for cgroup, xdp, and netns links, mos=
tly
>>> re-using existing link release handling code.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>=20
>> The code looks good to me. My only question is, do we need both
>> bpf_link_ops->detach and bpf_link_ops->release?
>=20
> I think so. release() is mandatory for final clean up, after the last
> FD was closed, so every type of bpf_link has to implement this.
> detach() is optional, though, and potentially can do different things
> than release(). It just so happens right now that three bpf_linkl
> types can re-use release as-is (with minimal change to netns release
> specifically for detach use case). So I think having two is better and
> more flexible.

I see. Thanks for the explanation.=20

Acked-by: Song Liu <songliubraving@fb.com>

