Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A27123484
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 19:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfLQSOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 13:14:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60908 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbfLQSOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 13:14:18 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHIDY7g013884;
        Tue, 17 Dec 2019 10:14:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=sfUyY5BdBHyDF5AgPOe37D6i1VWrCtGLj7DIxBRjgX8=;
 b=i8JrjAiQOlbyTSGLNA7Uh4eluT7akpWWS96CUy9+T266Se0I4ps8N3NJsHK8zXvcKPyG
 u2ecMdIcSNapKrXuRMWBtOzRb+ceM+FVnS78IsHjDY6m5OPrQBUhDFLdjyLzKMXQ/DBG
 IZ8KU1iXMrdx0fwmGJsB7de2vUyxhAbKQUs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxph0kbtd-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Dec 2019 10:14:04 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 10:14:02 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 10:14:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktkLLKHn+sKItUUMWGf+DgA5Xe/8FxVay22CkR3iKQdMUjfqemrgpejFikMVi5zAA9eBGWj2IgddtTh7+mKeG+nfqOf+cBYRwkaNMJNMckrvDkxsDXHKQh5AK5uo3yKTi75xMmjmYxRSXBOSuvP3Hzd/V0n1Ewm3L6qKzGD6GGHktvqrwuLeVjCON5rDwqSEu/rhEOFmjwCbBWf2b7QtrqmSl+D2JNF1mdJfzwhCCaChXgBvQaWtNeggO3tkQOAYQWDtx86o644kUtrzIwDqXflnNYdAoOXO2SULdZTSbQzEBaJrOc5uJdXmnSsew1cCreqliZKUqT/BuD1DWdHLVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfUyY5BdBHyDF5AgPOe37D6i1VWrCtGLj7DIxBRjgX8=;
 b=mhcZw3bPcyuEuMb2dzzyeU/c80XEBw7DbYTtHLacgEqw+6XySlhZyUuOHjbZLgltiKJyrrBEexMHyIvv3F4k2UeYRtrzarTzDlltZuCpDZcXDhNjDYX4ekgGw5eNjWoXGrxhy4ivjtdesF+CedXlJ8qk4+LMZqI43YTeoG6zmQD5sF3rTn2yEBeWnkFaqvTl1cbGk6QToDqSe/n4HDhhEZ2kiGzdqRBXTtESYkVgHLY0mlpxTQvytGGAW+ewqfQRB1nEKs0JAjgS7agg+M0+7gCywIcpgO55EfgBPTqzzLeoDMAkJDQNLlfptHdjJqt3ct8HnDNrtaI+6Mh8bmH47w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfUyY5BdBHyDF5AgPOe37D6i1VWrCtGLj7DIxBRjgX8=;
 b=irqWmWmbwy+RxT3IPsU1M/x1eiaZZQ276BkWRhdZ7D8WsAQC12nPyuHTWZY5l7N9v0VeGrhZNe7s6t0vQtPHfvFiGCY9V4HacXye1oK6H4gNnPcJg75t+aDamM0oT74YEJnM+LztxyUmfX3+H5IXTuRx1kQYCW3C1JmVa/droVg=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB2262.namprd15.prod.outlook.com (52.135.198.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Tue, 17 Dec 2019 18:14:00 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60%3]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 18:14:00 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Martin Lau" <kafai@fb.com>
Subject: Re: [PATCH bpf] bpf: Fix cgroup local storage prog tracking
Thread-Topic: [PATCH bpf] bpf: Fix cgroup local storage prog tracking
Thread-Index: AQHVtNWALMD+CH4eO0aG2y/1BAs1m6e+odIA
Date:   Tue, 17 Dec 2019 18:14:00 +0000
Message-ID: <20191217181356.GA5770@localhost.localdomain>
References: <1471c69eca3022218666f909bc927a92388fd09e.1576580332.git.daniel@iogearbox.net>
In-Reply-To: <1471c69eca3022218666f909bc927a92388fd09e.1576580332.git.daniel@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:150::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::d582]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b528259-cb9e-49f9-a041-08d7831ce3fc
x-ms-traffictypediagnostic: BYAPR15MB2262:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2262BF9271C6FE77FCD417CBBE500@BYAPR15MB2262.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(39860400002)(396003)(366004)(199004)(189003)(33656002)(6916009)(5660300002)(66946007)(186003)(86362001)(81156014)(4744005)(478600001)(6506007)(2906002)(52116002)(71200400001)(8676002)(66476007)(64756008)(66556008)(4326008)(66446008)(6512007)(54906003)(1076003)(8936002)(9686003)(81166006)(6486002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2262;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fajMiPmQG6If48o6mAqz9gm3AwEFUQItpp6garmcmxyLKKG0OpJl0AJGaM3bQo8UmSD4JbnyLfzQrZdtMbYnxVO/QkbnwR/2fq2wKrqmhl35+Jpf8XL0GTe9azKG/SR7bQm1deTeO+bNoSqF9eRp0KhM7IQhAtvjFjCxm7O2F9sZXcMuG0V7S4KJ2JYmG5maSvCue8/guSeeTXbw8Z2rX7gVcxAYL02kExhdPKo3tRS2SGtSZwH4eW4Q49MIQji6RcjlHjKgRcvCUmfaS5PZveKPFF8BNfWr+dxmmErskRsa4143icjniKwIU4+hKsdR4Vgj0lB65wnRvUM7qqx0lDJjXPiEZRNtYOSuvXWfjNkgu9akSdwIAnIuCbaaz/ufsy3nNulxHN+eD8oeZXYmRkUL7X3EbIm6Sx2ZljYKddwsNPVcKJs9KqTEgN5kTdQM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1F122C2F79A4124B9B046F55AB91DBC5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b528259-cb9e-49f9-a041-08d7831ce3fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 18:14:00.6290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S+Wi5Ab+dxdzo+VM9T09W7dOVmQHHz6UPm2w5rzv2X1sRhp0Mk1FfZ5LpKrejDB8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2262
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_03:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1011 mlxscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxlogscore=888 malwarescore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912170143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:28:16PM +0100, Daniel Borkmann wrote:
> Recently noticed that we're tracking programs related to local storage ma=
ps
> through their prog pointer. This is a wrong assumption since the prog poi=
nter
> can still change throughout the verification process, for example, whenev=
er
> bpf_patch_insn_single() is called.

Oh, I didn't know it.

>=20
> Therefore, the prog pointer that was assigned via bpf_cgroup_storage_assi=
gn()
> is not guaranteed to be the same as we pass in bpf_cgroup_storage_release=
()
> and the map would therefore remain in busy state forever. Fix this by usi=
ng
> the prog's aux pointer which is stable throughout verification and beyond=
.
>=20
> Fixes: de9cbbaadba5 ("bpf: introduce cgroup storage maps")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>

Acked-by: Roman Gushchin <guro@fb.com>

Thank you, Daniel!
