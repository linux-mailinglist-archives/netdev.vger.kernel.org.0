Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D190322650
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhBWHRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:17:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3714 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231974AbhBWHRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 02:17:23 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11N7DjEb004128;
        Mon, 22 Feb 2021 23:16:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jj7lI8sSvxh4aY5HOz5aTxd6c+6ItJ0k8SLNpsPGTDI=;
 b=pZNOssBAIrRVVtLNw9Fc/c8sJt8YNo9930DpbYf56w/zqlJ7VhfnIgxBsvwM6K2uo8at
 rrvQFanvzOO0qSzsULehJHvZHDRFp5q7pzkM95d//XKCVUEjBEqQG3bbyfl4JdiX6nAH
 1ycVxBOMDl6ScsAjh/JvB0Ltl1qFQqFMS1k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36u14q4q4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Feb 2021 23:16:22 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Feb 2021 23:16:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HlWH5PMVBdC/V6g3qCim8u+pvyZl06LJZUuCNgp0dURJwCfIjoFFJfFjWXXPZDOwF5C97WP8SJnaEEft7KqEP8cnzISDSkt8YPQZfSNGUbDuD8hRy5T89/qWYJqGgo9SFJC7fO0vnI2HUdHbRXynGBc8rrkUXZagkQUIPuDT3HFqMijP5x6JLfe+llZ+/DRqQjA4ES6Qto34oLcU9o0rjIAXvW5pFD0JhLlAgF1qGS5S6P8JprM7yWMzAq1Jy6yPASBKpFKpGNluyLJqUH4Z4mWlRkfmQfpOc2R7G/DGClrDT0GROnlazNGmfPC3+L3qXym1Gw54qMDJMzRcgzraMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jj7lI8sSvxh4aY5HOz5aTxd6c+6ItJ0k8SLNpsPGTDI=;
 b=h39egWLCs0sbstxmfUcdIZoa8bsX2xFgKhnBQcc8ClIF31blSzmJytNJ3QWXonxQFOvzX0H6R3/HtzIUv5s6c8aE8SGd9eu0YeMZ1paW2txTvJpTN4kWQLwCGU/o4XITXZNfZe5XZY2CBXfHEzCPJmqsDQJEIGzeeyF2P850sd7KnIqVyN8PmWPvRIgxLb/CD8cqIhzAyzEPW/SswEImdPd1jEG2ZN8MEKIvg58kRKYXKBhZqtDTRsY7H2U5oYUAXUWTfH5iLpA+4DxaSTrNTiW238UdbVwUjLmgu6Wej+/6d0MTkusfuGFR9zjcqk4swRctlGzH+AVc++e3MzBKMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4711.namprd15.prod.outlook.com (2603:10b6:a03:37c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30; Tue, 23 Feb
 2021 07:16:18 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::8cd0:7956:3c0b:7910]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::8cd0:7956:3c0b:7910%6]) with mapi id 15.20.3846.042; Tue, 23 Feb 2021
 07:16:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "Peter Ziljstra" <peterz@infradead.org>
Subject: Re: [PATCH v4 bpf-next 2/6] bpf: prevent deadlock from recursive
 bpf_task_storage_[get|delete]
Thread-Topic: [PATCH v4 bpf-next 2/6] bpf: prevent deadlock from recursive
 bpf_task_storage_[get|delete]
Thread-Index: AQHXCYIynt1KuoobvEWNWRDMRSL2HaplRT0AgAAPSwA=
Date:   Tue, 23 Feb 2021 07:16:18 +0000
Message-ID: <6A4F1927-AF73-4AC8-AE44-5878ACEDF944@fb.com>
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-3-songliubraving@fb.com>
 <CAEf4BzaZ0ATbJsLoQu_SRUYgzkak9zv61N+T=gijOQ+X=57ErA@mail.gmail.com>
In-Reply-To: <CAEf4BzaZ0ATbJsLoQu_SRUYgzkak9zv61N+T=gijOQ+X=57ErA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:8f65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 948c1cd3-10d6-400d-537d-08d8d7caea40
x-ms-traffictypediagnostic: SJ0PR15MB4711:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB47117CED2DE6004080EC65DDB3809@SJ0PR15MB4711.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JRr/Zm49jDaI5g7CQAMi4y2yFBxebVDa1yxEqEOluQ6/MuhPQVELFzWVvQl0i5ys5j+dRmNkxKQvU4lcMF8MURL7BkFR+gZKk2PIzpXTB0WikM/SWMTjlnM1nFhoKAGax/oBD096Lrjb83X9gA3W+h+rwKohXcJ1LdHO32K8iSqK1ktGVCrbVz7DTbYI/xJv1vtrDTQVpIpFhWriWPatFbG9iHHngK/37GYaG7lQ1eiR6fhbstY8UjyaB3QO4KQfeDT37QBpFnTg9Mjien9qgMYst/ogpvnY4pAaQ2I9A8nVEZ6B54/6EiTxZP6ga4Nkrvh2HKjwW1CKvIaN0FajdHXUm/yhVeve1Rq0mcRczGhn6FJFyXIeem5STidJmKCALCM0FP+zXrRCyuzd4/AzCl6aG6GKsVU0RoBUZa7TXw09Sw+L1WfsT92V85GNb85/P64LPqjRGiU04YIGru6ooaIRQbxh454DCO5di1g7XK41gTaEiK47YBCkSgSlqj8pykj8WNuDDxl82ORdtFJFBMez/Sv9fyDQIPHlnZTymhSxk5eSi5BBjMV08mrPYU8XQ91vVMMl79V1Quqh8OC/yw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(186003)(66556008)(6512007)(86362001)(6486002)(33656002)(8676002)(66946007)(2616005)(91956017)(71200400001)(2906002)(76116006)(478600001)(4326008)(8936002)(66446008)(64756008)(66476007)(6916009)(316002)(83380400001)(5660300002)(53546011)(54906003)(36756003)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?r5tetsnduT4uYlcgIo6EL71gIB08AXaZ8jvN8zhGVP+lBKeMM+7XJbsZYSjc?=
 =?us-ascii?Q?4jPcS9ewPrPc9Gw98Ml7vZ46Y8jdfYzkUjzKZ39Dfut/7zPTNTrZ8iL+tqm/?=
 =?us-ascii?Q?3erhrTkaxL4nxWOrxtX85y8Bu3gMypftIIwBTWyDJw1s+igfRJqg+xmpKqUg?=
 =?us-ascii?Q?xXezGjnp5yAi4dGM6mNuD323rgb/YzTuefuUqWQp95vQnf3cAJeQJfOw/pgC?=
 =?us-ascii?Q?G4njI5T3dafM0CDYpsdiMg5auEDUHgrmVk5QgM46CPcvrqTWsivyvTvnuWOr?=
 =?us-ascii?Q?pXJax0VyvqK9vxuq52pviBwEucjwg7GKuK6/5CltW2VYppgigw0zsPEC6XT8?=
 =?us-ascii?Q?58JSU5gqVHUMdfQFUyZYxgmWCcBo4hPVEhlga+hc7Yl7oDEvlHjB1dGPmSbW?=
 =?us-ascii?Q?aFrRpzlhJcWPCIhI4wGu/ydf3FhHwIBs3SUTk7yMZuzb1ezaEyKKnCkh18w7?=
 =?us-ascii?Q?vcHhT5i7vPTK58pPf8zEtYIjy2MpbZ6AuFDsbi7p9DhdCuvYtBqbdSHk5vSi?=
 =?us-ascii?Q?m+0v/++lR8EpZQ31zhfeMkgvMBNimP6ev6g0rOe8HlxLF8wzZAxSADPl/z3L?=
 =?us-ascii?Q?Z5lifYYYKjX7Rx+OhCzCfZEe9Xux2ZKgT/K21KtRNiL3OHfQiYP2iQHyfdG5?=
 =?us-ascii?Q?zLiR0AN0588KlgcDYoVG57jIqOa2YaT//HMnfadsuEl0T/7YYDOS8MOgGh2F?=
 =?us-ascii?Q?KJBHwYbVEWjJhuN9YuTdaCc6CrIcvvn2eegIkKze5pt9rncUXWeI4fBMQ3Nf?=
 =?us-ascii?Q?R9FoZXdz2AuFowdUFQIVWkJqhcUnO3lMqnEAxJnkFyvSkq7Vlk9WriXBnjp5?=
 =?us-ascii?Q?MPjW+Ls0jBDAzRcGBLF1umWikLo+6/z5s0lHg1s7a0NU0wtYJugSYs3vPeK6?=
 =?us-ascii?Q?cAlDRvG6BZIeGe15llwh1wRFBiYk71bkYp1GNj25bdk3IH4N2kCAOMPTKEta?=
 =?us-ascii?Q?o7MXwPgjNr6Lz5rlKdDoIgwQhzfHlunwmVCEGGuRVf+BpSSKx6TKDn46nl23?=
 =?us-ascii?Q?68is5nI7fOtiWPn1iSfF/nZmOp74oFoPYex7yGJFKT5TYQxQRGQ8rA01x4Z/?=
 =?us-ascii?Q?W+DBDfAqm8z8vxwmLum1ATbNf9YQvhdyUhkTW10nlJjCeRErKatZ8lP9y7TQ?=
 =?us-ascii?Q?f99w+8B028/2PnYBPA7PhMC5N13DxNzbV0t7AaQ6Pcq5l2H7p1SMRUlHSZ7+?=
 =?us-ascii?Q?IGAAGFL3hHQ1dK1YVhblmH14EM2ZogCHKiL8DOc9EYIt5znjTm/0xYhnYQ7S?=
 =?us-ascii?Q?JlVoByR3CY1e4m8E166Eh6z3jBTQwh5lMm7S6vk9xe1OVklGpfM7tnTuU+0p?=
 =?us-ascii?Q?nQWA4w6HcdYgdsQvaFFCwwIrD7yHuOjirTm/wv3j9HPVWG45mFGv5oYrjm8A?=
 =?us-ascii?Q?6uMrs8c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <56FFB24331712B43B00CE1763F75904D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948c1cd3-10d6-400d-537d-08d8d7caea40
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 07:16:18.4885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vgLu5HY+WNU6SB+RVQyuH843rr8lXAj4mr1FEVglW5RVBYscNvt3aeyIO9SIzHiEspQcavQXKv8IuRgxXOFH6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4711
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_02:2021-02-22,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230059
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 22, 2021, at 10:21 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Mon, Feb 22, 2021 at 5:23 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> BPF helpers bpf_task_storage_[get|delete] could hold two locks:
>> bpf_local_storage_map_bucket->lock and bpf_local_storage->lock. Calling
>> these helpers from fentry/fexit programs on functions in bpf_*_storage.c
>> may cause deadlock on either locks.
>>=20
>> Prevent such deadlock with a per cpu counter, bpf_task_storage_busy, whi=
ch
>> is similar to bpf_prog_active. We need this counter to be global, becaus=
e
>> the two locks here belong to two different objects: bpf_local_storage_ma=
p
>> and bpf_local_storage. If we pick one of them as the owner of the counte=
r,
>> it is still possible to trigger deadlock on the other lock. For example,
>> if bpf_local_storage_map owns the counters, it cannot prevent deadlock
>> on bpf_local_storage->lock when two maps are used.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> kernel/bpf/bpf_task_storage.c | 57 ++++++++++++++++++++++++++++++-----
>> 1 file changed, 50 insertions(+), 7 deletions(-)
>>=20
>=20
> [...]
>=20
>> @@ -109,7 +136,9 @@ static void *bpf_pid_task_storage_lookup_elem(struct=
 bpf_map *map, void *key)
>>                goto out;
>>        }
>>=20
>> +       bpf_task_storage_lock();
>>        sdata =3D task_storage_lookup(task, map, true);
>> +       bpf_task_storage_unlock();
>>        put_pid(pid);
>>        return sdata ? sdata->data : NULL;
>> out:
>> @@ -141,8 +170,10 @@ static int bpf_pid_task_storage_update_elem(struct =
bpf_map *map, void *key,
>>                goto out;
>>        }
>>=20
>> +       bpf_task_storage_lock();
>>        sdata =3D bpf_local_storage_update(
>>                task, (struct bpf_local_storage_map *)map, value, map_fla=
gs);
>=20
> this should probably be container_of() instead of casting

bpf_task_storage.c uses casting in multiple places. How about we fix it in =
a=20
separate patch?

Thanks,
Song

>=20
>> +       bpf_task_storage_unlock();
>>=20
>>        err =3D PTR_ERR_OR_ZERO(sdata);
>> out:
>> @@ -185,7 +216,9 @@ static int bpf_pid_task_storage_delete_elem(struct b=
pf_map *map, void *key)
>>                goto out;
>>        }
>>=20
>> +       bpf_task_storage_lock();
>>        err =3D task_storage_delete(task, map);
>> +       bpf_task_storage_unlock();
>> out:
>>        put_pid(pid);
>>        return err;
>=20
> [...]

