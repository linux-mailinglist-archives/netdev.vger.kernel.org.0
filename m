Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CE23247CA
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbhBYAM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:12:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24850 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235348AbhBYAM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 19:12:27 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11P09eVa030002;
        Wed, 24 Feb 2021 16:11:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TQp+vThdwQpOwSjGIQzllj+pLy0snDMDc/Vnm1i+XbE=;
 b=ahYurEX8XRN+sIGWO0Cdge01kaHFPMMwOCQ+E5ZdQlGtXf1KeCykdIAlRYm5WBPKpphx
 3ElSHFHomVWr9fxQ4lJYQO6OjU1Z0N7f9HCoWvuzUQtTi7HE82UCIe47cCX2REyaLYvu
 m677g0a1Mxv9qh9KZaAjBMah8o0BEkt8XRg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36wdwf60vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Feb 2021 16:11:37 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 16:11:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ka5JtBpSyOayt50ebg4qtgQLAqaZcDzr0PjTqxMEIU2iFtaH9dtXByyRxCxt/OA4Tp0zphPQ1LKUEixPn+l2scAa9a8wC2/8ieYUNqRx7al5h/Rl/r1uStLtHmkX4gneNoO4sgaS5+Xty/Vlr+GtMFnCZQljmFZ1p3dUMEz7zdF8JYO2oZYtwDxQdLZ3Z43MoOgqRqVCnQ2/Ptz0yR44DmrXAgZtGKWj3raOzNcxMXxdze2/lJbzqPLy7ZfYYUhWc24fxQPjiqK3ac/WIbBYwiIZVs4up4bpSNjQsuyNV+Qew2Dup/zukUsRrYlujIN4BPyTGJjiGeEPF1B9TPKNMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQp+vThdwQpOwSjGIQzllj+pLy0snDMDc/Vnm1i+XbE=;
 b=JouWHBH1U8iwb9m5n0ddtWBk9nQpV3oT7vbbUiFW54yk5/sJTRJEhBkntc59GkEsnIAEDbGdRZ+zUzigQxn+/yyZVNgGeqopSFQipVBPjdf8j3A05e9a6ZuEdWLij9xUUqq2Ub/BcVmtYAlsKEdwFkZxDVlQd2KMlnY/9n2rBAWJcPccIZpMpLnLLIS1UvkikKg69csokcPL/IQRDzEkQzB0QGqnX3YTYF8m7wmjsbQaVnFqLimeqIqo8PYtmwrtuD/tm9d0l74YyelJezXCP0LJ18cXAIan70lKIq2KoiLVXFE0g7wwwWiTgaTuV6cPlBKz/D2SVIREnAZCaHtiEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB2787.namprd15.prod.outlook.com (2603:10b6:408:cf::28)
 by BN7PR15MB2228.namprd15.prod.outlook.com (2603:10b6:406:91::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30; Thu, 25 Feb
 2021 00:11:35 +0000
Received: from BN8PR15MB2787.namprd15.prod.outlook.com
 ([fe80::a430:4af:c5a1:d503]) by BN8PR15MB2787.namprd15.prod.outlook.com
 ([fe80::a430:4af:c5a1:d503%7]) with mapi id 15.20.3846.047; Thu, 25 Feb 2021
 00:11:35 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: RE: [PATCH net] net: fix race between napi kthread mode and busy poll
Thread-Topic: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Thread-Index: AQHXCj1yGIGjT6Gs4kqDsAg92xx4kKpnt6uAgAANnwCAAA7KAIAAELmAgAAW+YCAAAHngIAAAjqAgAAAR8A=
Date:   Thu, 25 Feb 2021 00:11:34 +0000
Message-ID: <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [50.39.189.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1369a8ef-3ddc-40c4-dec7-08d8d921e9b3
x-ms-traffictypediagnostic: BN7PR15MB2228:
x-microsoft-antispam-prvs: <BN7PR15MB22289CBBBA7329CAF7C88531BD9E9@BN7PR15MB2228.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MXiKtXlNNQEEBD79kx+GjokM8pqYh7CZWAr5wpZ4hPXUA6lHjhnRJjYMBJ+9qPopZ9egWAOY10q93jJMGrgHHfwFGXa47hQb3Ho62Io59SfnFOxUuLBmCoKyKca2fQxP5tKQ6AWnj0XeL0gFZOQOYvB0Nh9MIu19Q71n73g3j3uX3BGrlqwiFjdQPKdscwnkwbVKpoUuSlEdRWh72zuqqkzuswr0xSJe4ACa2kkRvxthg4MCX4k0kikclw6FRJ/xAFKdgtJTCwvtQZuB4oCBJt1o6vcByEf4wVsElusoSS61vAdXGFijtkcqRrqVL9imvQn1ABDj5wQzrRR/kacaWJPlTmySZBX9D+rin8qMFCXMBfzNc1ulLpMYoQ40/umd6A1GhEFJnrHXC0BS592rG82OLXCQq9iBTiXihXON0A1ZjQL37oImhH/ztOUav0285B+piNeDKSrdYS5dWC6X7hGx/qeycQL1nWGi31Kxlni9YmwW2JCFVCtgl2IMldKoe8J1xXPYhOgs3q5zBEoteA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB2787.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(346002)(39860400002)(4326008)(186003)(52536014)(316002)(54906003)(8676002)(2906002)(55016002)(5660300002)(26005)(8936002)(9686003)(7696005)(71200400001)(64756008)(66476007)(83380400001)(110136005)(478600001)(86362001)(66556008)(33656002)(6506007)(76116006)(66446008)(66946007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2mcQ1F84tEQFRNm4w/lMm4WMa2F2ZzXyCVtuYbWw6cc9a+kyT0jGWw7spHcf?=
 =?us-ascii?Q?Xl1LRGok7dslW+xItswrS2qlFIHR9KN9LaikMe4jDM0Y2efzGhuYTEtOzk5T?=
 =?us-ascii?Q?IIK9DmD8GPd8sR99QTPV49RxPs7t+4i12+IeFPyGVbK8tuzwGUdb1YN6TuSO?=
 =?us-ascii?Q?HIpy3vI0DwYiFkqeY3xsy7CESXmoU/xaQjIM+zgURW0lUFTLMUuJhmz3/B7R?=
 =?us-ascii?Q?XrK6eH3pq2IRSO5cbww0+a0qNMGmHYecIs5KOXy8KPonCX1aKqi05vkPCG9d?=
 =?us-ascii?Q?2JLOWZ1LAkGFfnaz8btBM+IMekH1X6ca2KUL2BpeBiUYSPJ6EKNJhT96LZpw?=
 =?us-ascii?Q?M/alSmCEnZUl/TLIFfdC6jyLmtF7nDrCVrL+gm7ekpPMUB1H+2OCEFIMJrEB?=
 =?us-ascii?Q?UnwAZ8vQC0rJgPLqjBukSpkSNh324v62OBeUpDWrBqPQgv3cXENr7AD6OafE?=
 =?us-ascii?Q?g6gywT71eHpFSh2ix+3ZFniGiRbfqGSlQRacDLCQooBm/2cmc+w614d76Vfx?=
 =?us-ascii?Q?jQGAzSqlNMPeir3dnEHJtU1rc1ASWY9ZY9b9pLHCTiiMULAR7IDjNHAup/7O?=
 =?us-ascii?Q?VQFY2rnNTQA6Ypkfq3zyekHFC7lN9SKVoNgJNz3XvElPnwUgaMMJc91Kn7fK?=
 =?us-ascii?Q?bS2rA+dvTs0VF0J3OGVJs6UGY0SHERRhoM+eyYWI/VdV0w+4f2IxILsLGcOi?=
 =?us-ascii?Q?rWySqwTFd83GjQiB/1Xbu6D28c8zZo/sxpdU06lK1RmMDhesUeA72yhcQIOf?=
 =?us-ascii?Q?Txv2IGMjaRZ3mn4KuNd42wlQ17KMqqJrB0I9zUiY6s7dJ0tnv2KD50e+UvlG?=
 =?us-ascii?Q?NjuTVxYjT5nhG8CaxXxWMUXPEtFD9oAPw/tefAcqhS/HsC8VMAg9EEgVPnZa?=
 =?us-ascii?Q?sdVr0i454JgHmNJOSF2mK40ek80YGFu6kQiB+j8sOES+Bfb4fhGxUjJ/uylU?=
 =?us-ascii?Q?wcKoq9XnVRYfJpAdp+StaiStoeB3JJBh+csk6MMk7Jb4on41zgYSURU3z5QS?=
 =?us-ascii?Q?IOL8EVpQN1babNXUVxGRdhItmKvlmKjjyqmGy/OX4bYnRIeEWDV0X/ztzrE9?=
 =?us-ascii?Q?C1cPD3d9Fbh8exUnF/DAU1ChbD2KKtMRAKJYdELEvDJwjkvjL8Is2yDvHiU+?=
 =?us-ascii?Q?LtddRBULJcRWqckG6DRyygkpuFgjWp6Q7EV1q1agqy8bPSo0C2IdhcewvS+F?=
 =?us-ascii?Q?RKWY8lvsLGME2M0ryqpvJqNciL1X89Jlt+JB6hn+Or7WZ8qiptnUdY02cGvn?=
 =?us-ascii?Q?SIH3AWy/yB08BKmItWeiO8kuK/7cZZt17rOdm+edVMbsT1QMZoSTVCssF6hf?=
 =?us-ascii?Q?LyA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB2787.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1369a8ef-3ddc-40c4-dec7-08d8d921e9b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 00:11:34.9333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wB9qEtUiGw2AWKWKGNaHBSYFkghngfxBGlCOiC68Ko72pve5iy2teVRu1RuxAuQY6PZrpocJla3oEAjbrxwJTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2228
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-24_13:2021-02-24,2021-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240190
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, February 24, 2021 4:07 PM
> To: Eric Dumazet <edumazet@google.com>
> Cc: Wei Wang <weiwan@google.com>; David S . Miller
> <davem@davemloft.net>; netdev <netdev@vger.kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Hannes Frederic Sowa
> <hannes@stressinduktion.org>; Alexander Duyck
> <alexanderduyck@fb.com>; Martin Zaharinov <micron10@gmail.com>
> Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
> poll
>=20
> On Thu, 25 Feb 2021 00:59:25 +0100 Eric Dumazet wrote:
> > On Thu, Feb 25, 2021 at 12:52 AM Jakub Kicinski <kuba@kernel.org> wrote=
:
> > > Interesting, vger seems to be CCed but it isn't appearing on the ML.
> > > Perhaps just a vger delay :S
> > >
> > > Not really upsetting. I'm just trying to share what I learned
> > > devising more advanced pollers. The bits get really messy really quic=
kly.
> > > Especially that the proposed fix adds a bit for a poor bystander
> > > (busy
> > > poll) while it's the threaded IRQ that is incorrectly not preserving
> > > its ownership.
> > >
> > > > Additional 16 bytes here, possibly in a shared cache line, [1] I
> > > > prefer using a bit in hot n->state, we have plenty of them availabl=
e.
> > >
> > > Right, presumably the location of the new member could be optimized.
> > > I typed this proposal up in a couple of minutes.
> > >
> > > > We worked hours with Alexander, Wei, I am sorry you think we did a
> poor job.
> > > > I really thought we instead solved the issue at hand.
> > > >
> > > > May I suggest you defer your idea of redesigning the NAPI model
> > > > for net-next ?
> > >
> > > Seems like you decided on this solution off list and now the fact
> > > that there is a discussion on the list is upsetting you. May I
> > > suggest that discussions should be conducted on list to avoid such
> situations?
> >
> > We were trying to not pollute the list (with about 40 different emails
> > so far)
> >
> > (Note this was not something I initiated, I only hit Reply all button)
> >
> > OK, I will shut up, since you seem to take over this matter, and it is
> > 1am here in France.
>=20
> Are you okay with adding a SCHED_THREADED bit for threaded NAPI to be
> set in addition to SCHED? At least that way the bit is associated with it=
's user.
> IIUC since the extra clear_bit() in busy poll was okay so should be a new
> set_bit()?

The problem with adding a bit for SCHED_THREADED is that you would have to =
heavily modify napi_schedule_prep so that it would add the bit. That is the=
 reason for going with adding the bit to the busy poll logic because it add=
ed no additional overhead. Adding another atomic bit setting operation or h=
eavily modifying the existing one would add considerable overhead as it is =
either adding a complicated conditional check to all NAPI calls, or adding =
an atomic operation to the path for the threaded NAPI.
