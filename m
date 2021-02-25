Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7DE32487D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhBYBXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:23:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62434 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229993AbhBYBXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:23:08 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11P1EnE5030097;
        Wed, 24 Feb 2021 17:22:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=e3gCE9eLbG531mODUtz22GWGdm16CWNqqsdxf2/idRc=;
 b=L3Yv8wDWQQPgFspVJGwGPTODblmVGWGsDYsfdJT0gdUDFWpO2WJn/guYlUSMg+qTL8am
 l2ucHzUKe9ozbCSQnXieJdabxkK6omKrWyefxKxuPzfTmvUkPxauxVCZnRrm79FC5CSS
 cpkD8uM92DahD1mYnAP3dpEfnuTkDiTAO2c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36w7j1gbs1-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Feb 2021 17:22:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 17:22:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOz9Pe9rItnAOTacNq4CkLqgLnx69W5ngQtOgx1o61rgwxl8tekDmZ7BBu+seZVQLiajpN0zdsXDkFSjZ8IOJGxDJQ7nWGMFFWftDFx9owuQv1q9dMZt7V4tZqX1T8bpnalr2ytYbtzCR5EayJmhqrDnUDiwajw2MpDVdCsevt9S9/nEXvpl6CEtm0VrAAGMu1rmwVzl+HRKGYfG7wCsCiiaCRL+zV1/miy/RmaKsQS//vSjvigU7P2JR0OPqW02YXA6DeXu6GQtLcnhzqnBKHFYerF66bUutqG5NpXSyVy73TJB/KsZhKJe/zNALY4oGwRUAfzA8JHEpnox/I40Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3gCE9eLbG531mODUtz22GWGdm16CWNqqsdxf2/idRc=;
 b=TN65ECS6CA8+ujuHsqjMw7BIV2Yqh/Oa183mNiEGVmwLf+cAAK3nVJ+EswsPwXsZ55jJWff8voZkEXVFBTnxOtSFbXv+e+qeUd2I3MvWmmv5IalGMdp+j1xDjaBTDxuDDWXKQERjVHsIW0OQYOzpnKvBP0cQK3njzcod6Y9yO5er5PnjXlNFb2Ycz4p9m6312603V2DBgefFvDdcnk5Zg5I19ZMiJL46Xe9YYl5KQa3mLxbxr7TcvpGaLw7lIdG7G35cb4vBShswMASRq5ZyBx76L6agNzZfsZBLcZHmMR5Z7Jvp+n0HS/eG1feojSmgl2/8qOu9Mni9B43PtpnNZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB2787.namprd15.prod.outlook.com (2603:10b6:408:cf::28)
 by BN7PR15MB4097.namprd15.prod.outlook.com (2603:10b6:406:b8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 25 Feb
 2021 01:22:08 +0000
Received: from BN8PR15MB2787.namprd15.prod.outlook.com
 ([fe80::a430:4af:c5a1:d503]) by BN8PR15MB2787.namprd15.prod.outlook.com
 ([fe80::a430:4af:c5a1:d503%7]) with mapi id 15.20.3846.047; Thu, 25 Feb 2021
 01:22:08 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: RE: [PATCH net] net: fix race between napi kthread mode and busy poll
Thread-Topic: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Thread-Index: AQHXCj1yGIGjT6Gs4kqDsAg92xx4kKpnt6uAgAANnwCAAA7KAIAAELmAgAAW+YCAAAHngIAAAjqAgAAAR8CAAAOFgIAAEM8g
Date:   Thu, 25 Feb 2021 01:22:08 +0000
Message-ID: <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
        <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [50.39.189.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a83ff7a4-91d7-491d-c07a-08d8d92bc51f
x-ms-traffictypediagnostic: BN7PR15MB4097:
x-microsoft-antispam-prvs: <BN7PR15MB409700F8FE3351B22CA5622FBD9E9@BN7PR15MB4097.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XRCwozP9zOH9cDMzv1qqoOZp0K7hBTLWAj5tTqHVJBB25Eih/zl4sr/b9BrpCSbLe0zGX3GGL3VmdIExwn9iPppwV241RFvHjQyLf5PAu/XCOdJNxgC7O+XHiIQnqFV3Dmpve6DFeZLWz8YduPvLX+Oospn0mzVA30/uC4M7oitP9BOsjW26ywk2hboRJy/KlbpWDrlc4uhaoThsxRdP0LFz+nyxC2JhCJjrty4pz8txiXYbhwLQuulU3hge885YcsXsH/EEnj1E0QfQrD5C7RSwOxMgZ5uMsNKVn1iebtoo8qKLPDkUG1dVtonPgPKYUJSefKbgDUEONs06zVZGNcZ9TrYxgMsu0U1VbOVRzmX3UlsJrnyqsFHpOExkwpnqPWMd9fJIvDPvj7NIE23MpAQ8w1gzstcTyB0XXdY9wMh/CCMoR9Vsm3ITpieuSnjLcZvBfI3E2a6rt9pMbAGnzEGUcNwWJCqfK2+KeosPXSTCYrPo/GmmDdM9yl4pKHm1Jzj3yc1fn1Mb21z3qK+Q5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB2787.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(54906003)(478600001)(83380400001)(26005)(86362001)(7696005)(66476007)(52536014)(66946007)(6506007)(9686003)(33656002)(66556008)(8676002)(64756008)(8936002)(76116006)(5660300002)(2906002)(71200400001)(53546011)(186003)(55016002)(316002)(4326008)(6916009)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Qw2PLLu2kFe2C5F/FvgZ+dof5jb3Pi3tqS1/gAMm8YTHPReaE0UEv4ZHuqQ5?=
 =?us-ascii?Q?8AY/KkTChSt8fR+pm19k+SQaPqvJsPhMx8ye9KNC8c8NB0Y9Um7O5XIRoXgS?=
 =?us-ascii?Q?D28SBG1JAKVM/bG3FmanlUp8J/Yo8df5f8joT1YufJZBKA5tm362vcP5FMxX?=
 =?us-ascii?Q?++AWTPKJrsxieLz9ihiLcXPyMlxkIRR/Sor4O4HIDsOQ/LxxvqYbcvEvpS77?=
 =?us-ascii?Q?FzmNkFAOBz5T+Biy/OJmnsr3caS1Pg22lvKEmoBxAK+Ji5womjs1+5Gvf9Zu?=
 =?us-ascii?Q?mAEoOP8Zv1ZF1Obl++HiGxgd/6OwPghFuyVC1FAEkxqLIzX7F65uuby3MEQ2?=
 =?us-ascii?Q?aMW4TBRbZd8eeibEq3pr3sp5MgJisGjtNnhYjHG8hp4bA/+oBQZ3LOeVoXjZ?=
 =?us-ascii?Q?HnNmnoGY2nB/4lhD3iaMZTnIHO2FfAcCDaIk3xRo1FQ7/qWgSMiUZc7uoBdQ?=
 =?us-ascii?Q?IgwIBCCKiUw5lUr/NYl4nnCO88I1T94W8XP4sFJLDoiE+BOTX2y7Svd0X4TH?=
 =?us-ascii?Q?Et7+UY8CcOVKL3kKD17HrLJXG9UKYuR2ca3npesUChZFTK7eUa5fuIHiiocm?=
 =?us-ascii?Q?QPCAEFXQ0j4rwM7VUSllfqr1TBjkUHjm7mpuCw+U1QBJlZewDs4zc/zvnqUy?=
 =?us-ascii?Q?fZMLCpb1cYfv1qfQ5lnbBLY/kCG06RoiT28/WZ95y5gbJdS7w4MOs0f6dUnF?=
 =?us-ascii?Q?fX7fKgc6tB9d1Ikj3ByQHXIs+kpihLJkrfqEV+VrcNrYwcNcMPN1zo91gDGg?=
 =?us-ascii?Q?evKPTs1OSyW0v+m9wG/NiYXa5LKrzgNKFbcQVwbRTs7PED5hK8vHQqBX5q/s?=
 =?us-ascii?Q?A2n6NP8wS+2oUDv06HkWcnwyAJclG0olb3IePOtu7PIkeHWhERcnUZASuA1W?=
 =?us-ascii?Q?qQpaugm25nevA+KJDPTN0Wm1/j7uWmrenJ1Lv6ymmMKrfIFnaH/y3fs/kzzg?=
 =?us-ascii?Q?R7x1aZ29xsbCv80Z8FDXd4hUu431JDw8M4VvqomR0a+jWLSBydqVNz8kFcvm?=
 =?us-ascii?Q?bR/h0aOL0MtJPQFqpa2Pvpr31OMrKq8VhlwdGlDmdqdmOtRpqDEoCZGQNXC8?=
 =?us-ascii?Q?8mRr2hHtA3R8kojel0hkPtGd84Di3jMWTAF+mlaMQW361bXD4rIXyVu89EIL?=
 =?us-ascii?Q?zB/HsVs1uMW7niLVp1EnPGV6vUg8lmaI3VfR4eBYJNu5eGN4f6fpQyS88tXz?=
 =?us-ascii?Q?rh92OXzJ/7eUGHCeHuQ51q+3d9OlAPmIW9ROaq/BvV/3h5CZ9RaibVHBCpfP?=
 =?us-ascii?Q?Le+HdZ8LjKIeBOf5kB4y9eXgbTjq7eXIZQHIX39ROrApueEM+lR66BI5FqDt?=
 =?us-ascii?Q?e9w=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB2787.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a83ff7a4-91d7-491d-c07a-08d8d92bc51f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 01:22:08.5549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wuN4MewUyqRJSQ7wOxdyTsy0x9a78clSbUfADtsuJi7ysWZcvmHjdAdiLslbe8eghV+u1ltOSn1ewCQhCxoAiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB4097
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-24_13:2021-02-24,2021-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, February 24, 2021 4:21 PM
> To: Alexander Duyck <alexanderduyck@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>; Wei Wang
> <weiwan@google.com>; David S . Miller <davem@davemloft.net>; netdev
> <netdev@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>; Hannes
> Frederic Sowa <hannes@stressinduktion.org>; Martin Zaharinov
> <micron10@gmail.com>
> Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
> poll
>=20
> On Thu, 25 Feb 2021 00:11:34 +0000 Alexander Duyck wrote:
> > > > We were trying to not pollute the list (with about 40 different
> > > > emails so far)
> > > >
> > > > (Note this was not something I initiated, I only hit Reply all
> > > > button)
> > > >
> > > > OK, I will shut up, since you seem to take over this matter, and
> > > > it is 1am here in France.
> > >
> > > Are you okay with adding a SCHED_THREADED bit for threaded NAPI to
> > > be set in addition to SCHED? At least that way the bit is associated =
with it's
> user.
> > > IIUC since the extra clear_bit() in busy poll was okay so should be
> > > a new set_bit()?
> >
> > The problem with adding a bit for SCHED_THREADED is that you would
> > have to heavily modify napi_schedule_prep so that it would add the
> > bit. That is the reason for going with adding the bit to the busy poll
> > logic because it added no additional overhead. Adding another atomic
> > bit setting operation or heavily modifying the existing one would add
> > considerable overhead as it is either adding a complicated conditional
> > check to all NAPI calls, or adding an atomic operation to the path for
> > the threaded NAPI.
>=20
> I wasn't thinking of modifying the main schedule logic, just the threaded
> parts:
>=20
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h index
> ddf4cfc12615..6953005d06af 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -360,6 +360,7 @@ enum {
>         NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI =
*/
>         NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softi=
rq
> processing*/
>         NAPI_STATE_THREADED,            /* The poll is performed inside i=
ts own
> thread*/
> +       NAPI_STATE_SCHED_THREAD,        /* Thread owns the NAPI and will =
poll
> */
>  };
>=20
>  enum {
> diff --git a/net/core/dev.c b/net/core/dev.c index
> 6c5967e80132..23e53f971478 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4294,6 +4294,7 @@ static inline void ____napi_schedule(struct
> softnet_data *sd,
>                  */
>                 thread =3D READ_ONCE(napi->thread);
>                 if (thread) {
> +                       set_bit(NAPI_STATE_SCHED_THREAD, &napi->state);
>                         wake_up_process(thread);
>                         return;
>                 }
> @@ -6486,7 +6487,8 @@ bool napi_complete_done(struct napi_struct *n,
> int work_done)
>                 WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
>=20
>                 new =3D val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> -                             NAPIF_STATE_PREFER_BUSY_POLL);
> +                             NAPIF_STATE_PREFER_BUSY_POLL |
> +                             NAPI_STATE_SCHED_THREAD);
>=20
>                 /* If STATE_MISSED was set, leave STATE_SCHED set,
>                  * because we will call napi->poll() one more time.
> @@ -6971,7 +6973,9 @@ static int napi_thread_wait(struct napi_struct
> *napi)
>         set_current_state(TASK_INTERRUPTIBLE);
>=20
>         while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> -               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> +               if (test_bit(NAPI_STATE_SCHED_THREAD, &napi->state)) {
> +                       WARN_ON(!test_bit(test_bit(NAPI_STATE_SCHED,
> +                                                  &napi->state)));
>                         WARN_ON(!list_empty(&napi->poll_list));
>                         __set_current_state(TASK_RUNNING);
>                         return 0;

Yeah, that was the patch Wei had done earlier. Eric complained about the ex=
tra set_bit atomic operation in the threaded path. That is when I came up w=
ith the idea of just adding a bit to the busy poll logic so that the only e=
xtra cost in the threaded path was having to check 2 bits instead of 1.
