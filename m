Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEF02B2377
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKMSPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:15:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28538 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726004AbgKMSPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:15:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADIBDWG014063;
        Fri, 13 Nov 2020 10:14:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0FP1XS02vG4uhnHX2i6W0axP0ldN7NLRuOx94EhDsBM=;
 b=iOPCQ5C4J0ovLMuNI7+z/YoW/nOpb98JLNSQBRvuGfRqHmGaCeb7w61ukbIqF4FwXv6j
 qjqc4OOpJvBYtMd/eoQIbmWLZi25vNl4TJKIRxB9hjtwvVNQSB00wR6EL4qlHazzlThK
 O5zEat076mScXxjQbtkSqE1WKYdJnA/SlYU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34rf8sxvvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 10:14:52 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 10:14:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAGR+8LdvJrxq958jVcgcoQW6/FwZ5ZvMa2RBELpEwtTQv3L69XXEN0++/fuEjotvBtAf5cSSa6ZLjknwIAN8q/qZ9uxPG038/EsJdOA2fPZ1wwxRj1XLyox1JpI3Ko9ZB0gCvrMQueHEdUc8G/Gv/Eq+dSen1HYNymxvBKkR0blhjs5JL4HjchPZbi5NsuZhosYu5l9cx+Bfqm6jhRuvPr9qI/62ViwtxGbH3ed2uo5c9VSbdjhXPedf9RljlZNhGRN1T08lFuihi7HQSU5+ei7FXyFG/Abh5Ya0dPs3BwDpFAau1P0TEHbn19FXxpIja3Dz+46Lr1DiYLlCFxETw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FP1XS02vG4uhnHX2i6W0axP0ldN7NLRuOx94EhDsBM=;
 b=ItI5ZHWpXpayg4E+dI3cy0xmfILojNC2CCAZx84fKaXseL3NBdrUSWA1rSgLuveW0VbC1LuMFU7Y7/l7k65pGtAQHnSv+jILjMTdNIBK8F4PLqBT8ayWfriPZFqAMO3sEI3ZqTq8rFnoRLXU9yvVhzV7F5fh0cuuUPGFQ9W/2wb/1g5QwB/+jiP642LE8Guh+/+dExUzOz3LEwOXxLBIDBjMWqPeVlEmJn4N0JQqEIPvvqrNFf2E18PYt/VVOr4oByreNFIqSbNOONoACBwRA3Nev4te/Asyd2jTN54rS0FKOBR0l78HSy1d5al31Ifp3dfoFGdZRGsxdu1qCMClaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FP1XS02vG4uhnHX2i6W0axP0ldN7NLRuOx94EhDsBM=;
 b=aneDo2cK2ls2sx/kCZqXUe5/YC/paOaPc7AWdMYmpSHByDrq26Us5nlB6ZHec5bFjcwYkHzvR9DleMopinHw9PTCSpOctkwSFe6Ni4ghGbgBCrgJwrH88Vhzk3tOYlKnnwYQSKnBrjXQ6DHTNth9KsZXoOkmRQ+l4Z3KPbmlmlk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3617.namprd15.prod.outlook.com (2603:10b6:a03:1fc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 13 Nov
 2020 18:14:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 18:14:48 +0000
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
Thread-Index: AQHWuUFqlzOfptSqHUWGJwxUOMopjanGXzqA
Date:   Fri, 13 Nov 2020 18:14:48 +0000
Message-ID: <4270B214-010E-4554-89E8-3FD279C44B7A@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-32-guro@fb.com>
In-Reply-To: <20201112221543.3621014-32-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f6d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad28cc8d-8bf3-49de-d7ab-08d8880001ad
x-ms-traffictypediagnostic: BY5PR15MB3617:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3617F337F408754F2BF29566B3E60@BY5PR15MB3617.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yeoY6oUOvlq3OYGzPKlY+O0MnuW8ttMPCFm83MByFBQb3ultE1WLuVWdNQtRXJ8jXLTJ02RhqTaaD7CZ85pMbDXNIT7NeR7FBbrpsGupokGnLZ5jHfoBqp/DbY0eXzOkqLztRKf4KuK49aqpVbVvbB9fV8CAhBiUb7P82BcS15lj63z+uhiudr0yDuWuZFWzObw5vkBovyqCnn/vObCkIb2s5K+Y+mhPEE4i3djIN0RM5WZ/ENZRw++WAfzU1vVj+UzJyaD0N4HTs6+L+5h7fBgpRU1it3TuTtd5vhTaKBQD8CxzTgMI9MlJgodSogxDi2uKI9LKmYcheLx+vrU95w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(54906003)(5660300002)(4326008)(86362001)(6636002)(83380400001)(33656002)(316002)(478600001)(6486002)(37006003)(76116006)(2906002)(2616005)(186003)(6506007)(6512007)(8676002)(53546011)(8936002)(66556008)(66476007)(36756003)(64756008)(66446008)(4744005)(66946007)(15650500001)(71200400001)(91956017)(6862004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ucdoBDvlv0nHXuN6rpFJG0xCP+RtZ6pEnagiV6zyZpRLPBQiwbXVXSHQxRb56uiwXtx0FXDHvvsUREoTcpP+teM+tTkjc04t7dVlxUnOnPXcs0DAucR7BZzxHCi/wrP/N5PRJ1FQ6osXDZ9BFrIId0cYL91377TJfGYvQY9IOr4qOKuqO0+Y8/xPTBSy7YnaYZLOGdhECH2oI2QsErjfhv31p2Q2hHJ62/zZIJQZHo+pryC+PdnTPgspd2PQAH6KcVMa0EDqWVFKVFjqFKCNxZtO9N8A/vhxksBekjchxQOO3Cfc9B1MCPS5pJj4bC1bZySWHQv0mcue4vARi2mVJoZS3De6O+B3ybQKn983awxDHeXDiFcnOucfHmySvpREF7VUZ1qL9hAmq6jZNaFJzBpPShBOTyuDj3e1/0wYbgpwZcurGEs2+5+hfFcrqoi3vjPRbQ7jXH/1o9aDThJloSPQmQxekICWZ8r32N7leVsFoWD0Ri8HtFcw+nZIQMhqk8BjNN00JRXS95z23PS0IdFl8BNB4hGWzDT5V8czZCcm8OYWCWlvGay3MBfJcN8QLMC5rR8OhP+Rv0oclx3ilJiOSXcENXrfAIO9mUmTK65zMsSBSnTNiG6SpUAikpNEcvk3LJcQZCveuJjJ26ruhXc/KaqtDLgOe+ufzW152+kt0loS/SnL9p6o0wY7OG0uzJFuP/ZEE7aTrInp6iivGzqA4iZOwqojlpY1xX+o4Dkf54Dt20Xium9IAnOeSP5FmrVUBltdFwBnG++dfK1TEDoR2qpDSwIvf3dcBSAM0rLxOymk6gqZ3PtsX9wmENOxi8np2PrfPd/J0JPLqO8u8JrD/YG3kjLsPUzRkOl8JQYEL+W95d+ytz8VMZ6Z358YKuaJ29VqUTIjObUDsWgzwg+Cx0rjkPrFIG++BQIo4qk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AB3253BC83F5C4DA4579BE9E31111E9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad28cc8d-8bf3-49de-d7ab-08d8880001ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 18:14:48.1203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4y/s9B3QF22YxoonRApXeUZICRYeCGbgKDjYyTJQg07Rq+Y6ZlrbF6h4KDXJ6ZsKOEhsxcoKVERjvR3H/VllA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3617
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=841 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Do not use rlimit-based memory accounting for bpf local storage maps.
> It has been replaced with the memcg-based memory accounting.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---
> kernel/bpf/bpf_local_storage.c | 11 -----------
> 1 file changed, 11 deletions(-)
>=20
> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storag=
e.c
> index fd4f9ac1d042..3b0da5a04d55 100644
> --- a/kernel/bpf/bpf_local_storage.c
> +++ b/kernel/bpf/bpf_local_storage.c

Do we need to change/remove mem_charge() and mem_uncharge() in=20
bpf_local_storage.c? I didn't find that in the set.=20

Thanks,
Song

[...]=
