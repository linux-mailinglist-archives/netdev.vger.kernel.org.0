Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82102F2442
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405453AbhALAZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39216 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404186AbhAKXmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:42:32 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BNcpbN013210;
        Mon, 11 Jan 2021 15:41:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=obEVIEPBj6QXNSg8B1jVAnK8BCfVfPJtbQC8Ys5Vvak=;
 b=Fw/sfvmFNsWGHUwhtsX9DYHsi7LjNyw51at6KTYUhGxho75jKH8+uE6p7UlZ2yOCGBPg
 v9mTxsW13Q2ACUW8521YfDmPQOa7ZDJXT3UJJ6bLcf5GLQi9uPcFaFdKYR6RH2J54aeE
 FhBqlyNn16z4qujzvVgZoN6yDFENsGUO6fE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywdbqt2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 15:41:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 15:41:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4LK05RG4ZKrwXlc2i/md0/VvSmVBBdwj/aC7Un7T0tXbrc/u+Jt1jGkV97kmMOrsfjqGHHiqIFscvy2h/LHHCHPUnfLhgHHZ2A8pDALtEvzYoWzFWvhu/MgsmUx2T6cjwgfc+cxCHs3nn81U5Sp7qmTy7znwzt0TR4YOYCucK8aB4i4g6P5V2WDDaW6Pf3m+I0giOcmRV2Op9WrqOB72iPr/hcVYXAwJLJNDDHjJlsCIRQBWiV3iM+a0S9ev5/Ri8motfPq9WE/6AlwIITJIgzLuV+o/fuYgs3fd1EONAzqCRMNvQrnutKmUhflw+X8Dno4sVpzJk5GAe27BCURcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obEVIEPBj6QXNSg8B1jVAnK8BCfVfPJtbQC8Ys5Vvak=;
 b=WDYsckfcLzBCCYIjaDbBDf5OaLOQ+zJo1On/X20Nqx2DHQbjQElFGQs1hALP8FhHcIb1n9m5EaMei1cVkw8vcIh9NugUJ7SmEdX8RYzlRKLxiOMA88FWbGfJfiMbHBY3Y21aoI7zzETYr07cfUX6krvkcsor/1imqEihAPTMh74GUsJhMzWmPKyw024SV0HU6Jj/US/x7Ko3eXuyc6fJRskkiVPceTNH4fTkq9YlVmEvWSA1NWdKqMtSbH1KbXWYcBTHiNsQkgohRbQ2cvPJInSBgIKo+P3pZZ3nDbLXrvK3b+09kFyQfwzdXN9YlcehgyPULKl4bzjHkUmXrXp1bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obEVIEPBj6QXNSg8B1jVAnK8BCfVfPJtbQC8Ys5Vvak=;
 b=SNOOqKdXac+zawDIlveBasze4DZIiWChqEOdSejKwJIeNx0EyQCYtiX9pUOuvlcZq/hImxCFUNzkKYf1uydChFsgxaFxDkwJPCKc81Ci86HdE7Po/5fkFI+JKsCxNfyTt/653YhuVXt+3T23EDL1hi9S8ZqUzdlgK33ciO6x0jE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3666.namprd15.prod.outlook.com (2603:10b6:a03:1fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Mon, 11 Jan
 2021 23:41:27 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 23:41:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>,
        "haoluo@google.com" <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Thread-Topic: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Thread-Index: AQHW5hbxN1bu8adE10+5MJhm5YS4VaoiytsAgABPhAA=
Date:   Mon, 11 Jan 2021 23:41:26 +0000
Message-ID: <4D0333B1-C729-41BF-AB1D-9AC233431094@fb.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
x-originating-ip: [2620:10d:c090:400::5:f14a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 933adb73-fc8e-49f5-da28-08d8b68a69d9
x-ms-traffictypediagnostic: BY5PR15MB3666:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3666A127D09D61CC65FC6561B3AB0@BY5PR15MB3666.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l1XPceyy5+kRewuH+pj/y8mob+WErWBpbQwxnnJYeTCnnaPMxrSPAxmzYHKEc6skwIe/I4MFfcpRUv4HmSQE90aM+q/gA4dJNMo24jrl5XNPHdJh3UXfWhnIFal9aA9hJyALi1x8ep8UsInaJhRjIV0s220uUB6TltvySFQ8ibOvhn2fcBerRmTVnXZNmetYy3yNLzk3P9BkSGNJOzWT2fbQB/t+HXpsVH12Mbp72qDESuatYCoiSQvZHvmN0drSbh+FKaRrYXndKk2gAJGZCZ+fEXWl+Ve2c2PnW71sxe4m1el88r4H+UcQnxRdAz8h5YlhLGSZ90Ii5+brzx9rDkTtY2bPo/lJ8E6iGG11gO6/7vikLAdWZc6cpcCPY3s8Y8rgiDSUPp2DhEHQfWt7WGUJnEKht9CVqx8WVrVZdfeqxF3wgim0Vwq+SmGSGugk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(396003)(366004)(66946007)(478600001)(8676002)(186003)(76116006)(66446008)(64756008)(53546011)(91956017)(66476007)(316002)(37006003)(71200400001)(5660300002)(36756003)(54906003)(86362001)(83380400001)(33656002)(6636002)(2616005)(2906002)(7416002)(66556008)(6512007)(6486002)(4326008)(8936002)(6862004)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qRMv260IZE4Fvs7YLS43Tr2EiUnfQaqC9UBSjDh6KNM8zbVvZei5a/Olh4WU?=
 =?us-ascii?Q?N3lYilWk1vHMfSzRsiiKzqUWGE+G/tyTG49VN8gxzVMaJnSa/G3ZyT5Tbndj?=
 =?us-ascii?Q?9SXTSmqWws5KdVJeffnM9WKYOSZVhvF2cDclnZclx7R/4myZwzdU7z/S/yJe?=
 =?us-ascii?Q?9mA/83bOjri7jPdl+Bcbp4etXwxPFSzoAjGepCWnpUrpmZJ2L5Xkp31M63cY?=
 =?us-ascii?Q?0N1q+wbCCvfwO5Yeon7abQu6U+N4VZl9z+c4isSF7B3/aG3S04h7mGcUi8xW?=
 =?us-ascii?Q?FTmBSki6cjAWWvU7AlLKaP/YZfC4MjJe8bzP6Tr4ynxCe8qYZoXOL3Po3r1G?=
 =?us-ascii?Q?VDzQ3EQoMEmCAq+fivUA2ii+ww2H3E6g/EECj7xzkpJwNy7rAVd/Aj1SHxDD?=
 =?us-ascii?Q?UDtZQ+2E+abJuDlMFqwoQxITh8NdiE22VVqE52M8GFszjf0YHx/id4fx54eG?=
 =?us-ascii?Q?2cwxytyUpQzx5tnhV+qvNU0sPSAiUopMcoKfq5W3ikC9AFFXZi0C+1ultBVY?=
 =?us-ascii?Q?il9F3ztS1IJiWUPdWWoEqRdlHie1FcWJgW4hBTSwthKLjH76hkNW//avgyLe?=
 =?us-ascii?Q?a9hF/HuPKy6ZRcwh4zy34mJtDT6skHA72/GDI8+ieOutUgVddPjTjSvs2ews?=
 =?us-ascii?Q?eapA8G9hmn4v2U7C27f7JAOlwV6IQAj7191sxYbUUPfF/P6JWKspDmVVXyF/?=
 =?us-ascii?Q?z4+D6Y8nuG+q3ag7pltrPDI5mQ2/PoMuyE2bc6aUEtcxBr5LAoFXSb4GpOj+?=
 =?us-ascii?Q?6pKDSF3eEcGy+m4c7TYwPH3REFJm+tX/1jVpf+/qNQ93lMkt6R3p5p4ueLFB?=
 =?us-ascii?Q?eg5tp6OH0gLX+/qs9GdjnHvFGbSSeAcJpfLBSk62w5aIkZXfXRCFBYTnsWzU?=
 =?us-ascii?Q?RkzlmEwNJbIJZkY4O43X5ptMPPCmkHiTgAZPrR72xF/Ul6DC19vW9c9HWeia?=
 =?us-ascii?Q?tGObwZIxsfMTnbV3Cf+HawLbcQ32G8yEIzl62V4RIRSapbu7nSMSb/IJxDAu?=
 =?us-ascii?Q?Cn3M7bv9hiMyklmp89TY3wdH5sRzrf3meKmkk28KpYRYaoE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9AE85DC217BCC46A44CF4881D671C58@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933adb73-fc8e-49f5-da28-08d8b68a69d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 23:41:27.0072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cq460RPYwsaMVdQvlOx6b6LQeCwuH3riOJHPOQh6If4PV/bLyXlLizqeTmVnWRXnXrjaPEHMNzNGD/9W8wupwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3666
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 mlxlogscore=942 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 11, 2021, at 10:56 AM, Martin Lau <kafai@fb.com> wrote:
>=20
> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
>=20
> [ ... ]
>=20
>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_stora=
ge.c
>> index dd5aedee99e73..9bd47ad2b26f1 100644
>> --- a/kernel/bpf/bpf_local_storage.c
>> +++ b/kernel/bpf/bpf_local_storage.c
>> @@ -140,17 +140,18 @@ static void __bpf_selem_unlink_storage(struct bpf_=
local_storage_elem *selem)
>> {
>> 	struct bpf_local_storage *local_storage;
>> 	bool free_local_storage =3D false;
>> +	unsigned long flags;
>>=20
>> 	if (unlikely(!selem_linked_to_storage(selem)))
>> 		/* selem has already been unlinked from sk */
>> 		return;
>>=20
>> 	local_storage =3D rcu_dereference(selem->local_storage);
>> -	raw_spin_lock_bh(&local_storage->lock);
>> +	raw_spin_lock_irqsave(&local_storage->lock, flags);
> It will be useful to have a few words in commit message on this change
> for future reference purpose.
>=20
> Please also remove the in_irq() check from bpf_sk_storage.c
> to avoid confusion in the future.  It probably should
> be in a separate patch.

Do you mean we allow bpf_sk_storage_get_tracing() and=20
bpf_sk_storage_delete_tracing() in irq context? Like

diff --git i/net/core/bpf_sk_storage.c w/net/core/bpf_sk_storage.c
index 4edd033e899c0..14dd5e3c67402 100644
--- i/net/core/bpf_sk_storage.c
+++ w/net/core/bpf_sk_storage.c
@@ -425,7 +425,7 @@ BPF_CALL_4(bpf_sk_storage_get_tracing, struct bpf_map *=
, map, struct sock *, sk,
 BPF_CALL_2(bpf_sk_storage_delete_tracing, struct bpf_map *, map,
           struct sock *, sk)
 {
-       if (in_irq() || in_nmi())
+       if (in_nmi())
                return -EPERM;

        return ____bpf_sk_storage_delete(map, sk);

[...]=
