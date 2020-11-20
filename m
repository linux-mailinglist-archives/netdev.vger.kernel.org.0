Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976922B9FD9
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgKTBiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:38:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgKTBiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:38:21 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1HxKc008738;
        Thu, 19 Nov 2020 17:38:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4iMS5nESoPheLMYQTVITf1glq2uCihgNPli3uAt3m4Y=;
 b=ljyeoDPzyyymW4HuXsYGp693PbxJc59bTwSTpPUXa1Og5aTYy1SkOYaCIMx8qqJj+321
 IfQidPZZVnaJtQQEPAeCa+luLmCG4ALYErUtyP6PJ1LhzgSuLhwJxdjImTvqyekAXNXt
 xLpq6Ak1WUbt+d2MRt938iu6VMLUb0ybwMw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wtheuu9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:38:06 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:38:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgnxyxNCFIxaSc5ElBs1PFUfMtulMplbykpmgQj6ygAGTHX5KNMQ+hoOWQeKsQ2knUuQh3jd8NTPt6wzyIA9ibqXM0fy4Q1sqL/csQ55kdPUdXLms5rBvm/GeddQX/3UiIKpNw7h5ozuuIPo7N7tE4m7Xs56qXleS7b/0rZJWpfhX8krraZaJ7tB1OLMe0wixQGjOFwjvlJcwsB251VAfu8G9+nrRQXoDCe3XCrGXZWX9Vw0pCtcEjRwurBAWTrBwvU9Mu+SERZdrGRdpPWZg8mQcRYAODTt8Sfs2jqMUPe4jXZNwzaZPLynE7sQa+1oqRDU3VgtFDYde/JLoftSAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iMS5nESoPheLMYQTVITf1glq2uCihgNPli3uAt3m4Y=;
 b=dNg9KeGxUp8DKKDWM1kRhkmxc4QwELOFf+M20EmY5lR8kpgZKvW8+YLv3WWR0qyR8b4gCTbMq8m6nGHcN912blVaSBT/oqQSXqAIeDvxiWcAaJRxf09Y6pbkD5WoS48P619i4L3UCS/8uUNkIth/cqQrvdJYgsOF7TLKY6ht6sbmyrMOOzcTPjHFv8KGlo9RN/g1F1rzZZDNN4inlPpJKcfplgWUaZPLlKPAvXEKot79k1LtFkFnVM7BiR5Ox1Y5D0e6QGniBGpaco1mPBU0oK9W1lqsHKFUFjF+dNOTPun/4GTp7eIOBe+vsL1wUu3VImo/Mg4Hzq4WNgHJRd9Wxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iMS5nESoPheLMYQTVITf1glq2uCihgNPli3uAt3m4Y=;
 b=jQ0ose3TZTB20Fc0Nyz9Uz2Q+oemFlEGJZmlhFAmIEbE6O4ih+wl2/4p3DYaAdt+YKkAvhHjawWdPEB+dYNs7kxHrARx8BI4hAXINVE+Bzd19XA4q08eZnfLzeBLqrTuiZnGytUKQgdPkZXR3oQMQNOjRhpeoVvSBa/fK6Iw61A=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4118.namprd15.prod.outlook.com (2603:10b6:a02:bf::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Fri, 20 Nov
 2020 01:38:00 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:38:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 11/34] bpf: refine memcg-based memory
 accounting for devmap maps
Thread-Topic: [PATCH bpf-next v7 11/34] bpf: refine memcg-based memory
 accounting for devmap maps
Thread-Index: AQHWvprWsHosAwAPeUq5t7KsumxNqanQPlkA
Date:   Fri, 20 Nov 2020 01:38:00 +0000
Message-ID: <2ECB6BE2-C431-4574-840A-FC23C0506984@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-12-guro@fb.com>
In-Reply-To: <20201119173754.4125257-12-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d888f167-23bd-41a6-94ec-08d88cf4eaa6
x-ms-traffictypediagnostic: BYAPR15MB4118:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB4118127AB9525F28A6B7CF4AB3FF0@BYAPR15MB4118.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:549;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PC9ZidU0ZxpCgzy8gInpWPPbnFRxuhP/T5EUIUytPBdR6KRO/tkOIdoFh8b/Am/KESvWFx8ksi+dZ5/aDe3QuGlqhQC0GreO5aCjAujorpp68zuza+X5Vu64ye+X+jSf4mZIj0FdNUNXrYdXs1JLmqaTUV4KB22vjBdwx14/tcdAqs9fiLupM939H+PCHzO8W5adaWEnp4SDYyCYgxAjqaiLGiqHsKVspK/GMW0FwmOI7Ar6ZVR+2valPqpr66ZDzagfvrOKFVKHETFHlt2HUB5hw2HmVFcmP9YET8E4A5ZxLZWcMgQOLuqG3+chmZ1ymhCJKZFL2aknCzap5v4kvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(366004)(39860400002)(8936002)(2616005)(4326008)(6512007)(6506007)(8676002)(5660300002)(478600001)(33656002)(66946007)(53546011)(66446008)(91956017)(66556008)(86362001)(66476007)(64756008)(36756003)(76116006)(2906002)(83380400001)(71200400001)(37006003)(6862004)(186003)(54906003)(15650500001)(316002)(6636002)(6486002)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0+DSzWa6kuJt3RfLLF7S0PT3EABy4j2/rdqSCNgPuyN4PMQ6lRatwZ8Ya/4FDQafBJUm1G07xBJJHH1ljrq6WX+q6AB/gtJp2llOrFxkYHF5V+d/K5dd03IPz4aOYxvEi1uEzqC6QBTPlGWZ8gmnG2rzWoGimDZBArjIm9PPCxAm2KqJdMQATM6jE+5dKyiCi4z7gw3ihYluQhWXCF9ZQLZ3Or3f3qBT202vcivgpVPzYmzZJ+KFjQhCc5U3kbDBAuCCPC5kDoGCTF5Y/F+PRP2K/zlhM5mE87zS+exyzQex3KbBmIoDh2sY7TyCxKXif/Sb6SrjGu1zV36TP5ditAieEdF9QGj4NUAsMsnIzetaGv8mk4nSzriSHnGY7eSyVtKOs6VG9GoLkFb1/FIs3Z2r4N4wYSNVd6UqEYw/cXnt7PYdX617lg682kpjxDZu4YSnQFyMZ+MibBctH+XdGKoegpdYg6cEUq28EBuEzG/09AOw84UGag33YRK6DJsdcNUOq0cRvHqHO+2SXmbeAGJKZq+KFZfwDjNhOHr7BFyN3ZiwRf1QZ0wR+UFVpnAh3QQKu1tblnHrpjZNk8otVApEO84jdhSMN/ZvlVwld1yFP8/4EztSIh0n60XOYjzCGTtMJ9uPJtNmGSVXVa++77fjJRyGvgSfgoftBvHwGxSU/pT0Y9/r8UcQy5TxrWlpf2UJeDuUDNST6M7p97zEP+iLFvVNGabtOhiLddWwMRzChnjSn+222W+usRRB1JRE6e4lmHKuaZtP/S8f+BBMc6mUayOrsDi/ANgoB11ZbzQUHc4xaMYqj5sTiFM3DWeGDS3OfWd3P6nqAjS5BYdKI+gVKVBRUFZw94D3k1SDtxY767ctRgxJ7qh+jGp3HyyspL1ksx53pTewPRhyJnq4/dYhFRu8Q1M2x6Myjb/mLSw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C2C07E23A7FA3C4DAF21CEC06E3761E2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d888f167-23bd-41a6-94ec-08d88cf4eaa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:38:00.8470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YrZRaVdjBDrhlZqxlC0g38MUBAbyyhY36WWgGZI8kCNZOGtiFw6RjnTc3X7O0UOs1SYrSAp6hRNzMVlr8CXNKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4118
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=905
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Include map metadata and the node size (struct bpf_dtab_netdev)
> into the accounting.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

