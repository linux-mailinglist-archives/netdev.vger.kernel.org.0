Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DC0131B3F
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgAFWVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:21:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726695AbgAFWVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:21:03 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 006MIWVn007717;
        Mon, 6 Jan 2020 14:20:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+4wBXAXGI0Q237DNJMlnzEPaei5wMD323bc5jM8bZsk=;
 b=EGpFSFcXSIc9CM1/Zgo+cIwQO9R4MOU5skO5Ns7B8epLcTIpj04hu5fLdJrqI5kAMSWR
 glNRwLocjZYKeLtrWnwlX+Cjt1w+4Gmo8V/pIkWXkFKhzL+u2F+AYq0HaqcbnDnhJtJJ
 mDzknE5T7eZevj7czGqgtJZCA0EIJs/VSYk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xbba0r58v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jan 2020 14:20:49 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 6 Jan 2020 14:20:48 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 6 Jan 2020 14:20:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmvTilXJmPxJ4NhO26m6Dv0+AwiSaR+W0rd5iJuAzaEtxu/abmElgE52Gy5WIx6cTgFFNg/9QAtMzq8bZiP2liXouB6OAz7p23zHge2PFT+gFU8T+vTR5EPST5ZiuUWHu5h/mbMz//brEFSG9DUZOA8cZyhto3xoINCndRPaAIjZk/BvrNLg29i1uZSIir+soLL+SjawgPsS1AHQEcq1HGZm0jLGjYfi7yBk9gpwi/Fx974P4vSXIMSFfzI1Wv4g2+n+bVTQeVQVFxhIb6G6DVJl9IF6EF1k+fMYVb29mI6+85SLuYmTrjXeDwPb0SFPTbcjHvw8xAfUGRRZbVgXWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4wBXAXGI0Q237DNJMlnzEPaei5wMD323bc5jM8bZsk=;
 b=mkNIOEEuN42g4NHrs1OZWMxPs97uWF4ECurRVB6ut3XkaleFWFQJ20tpgKMjjxwoo8RHLpCfp+1X/T1hjfnDybbFKb+0S7F0zo5PG+ZBludXyV3nHxnIMhG8qmIzEyeNmBoTK6evjodwLnnXZsqsBZK8VOlHtQT51svApFXJ0TmfXg4r0AwJX2uYaYPFQ+lrDWkHeXcPwa/eo6etfEls1BpPEG1Ik3Wm3XIQjPd5/zX4LqGTM0r1rxDTvESQL7pHq/9m0XS1f6N0LYKn5XiVog+6XgHM92uQGIyZAtfl5KxmPYlihWOOxC4w/5tA06nLCtppxgsL3selvYaNbpBsyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4wBXAXGI0Q237DNJMlnzEPaei5wMD323bc5jM8bZsk=;
 b=DKg8IwdVvL2eOIPEADdt1NsejYeMMn7Lee3oN9OPIe8iqvHOM9cmunGgK+bhayzcpIN+n2qoGP1oKrGmrzrJbjkKQJk6zNsEJ+FkEuhVbL2XEwYWfS9Eosm95L3NLHwVXIMoia7zdZF27ejqD4gn9nkkqD3pndL9uA08efnqeUU=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB2791.namprd15.prod.outlook.com (20.179.156.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.13; Mon, 6 Jan 2020 22:20:47 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::ccb6:a331:77d8:d308]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::ccb6:a331:77d8:d308%7]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 22:20:47 +0000
Received: from tower.dhcp.thefacebook.com (2620:10d:c090:200::3:fe4) by MWHPR17CA0081.namprd17.prod.outlook.com (2603:10b6:300:c2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Mon, 6 Jan 2020 22:20:45 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "tj@kernel.org" <tj@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: cgroup: prevent out-of-order release of cgroup
 bpf
Thread-Topic: [PATCH bpf] bpf: cgroup: prevent out-of-order release of cgroup
 bpf
Thread-Index: AQHVvP+26yjH3drshkGEPJ14gI885qfZs7aAgAAKlQCAABXHAIAACDqAgARlKgCAAAObAA==
Date:   Mon, 6 Jan 2020 22:20:46 +0000
Message-ID: <20200106222042.GA18722@tower.dhcp.thefacebook.com>
References: <20191227215034.3169624-1-guro@fb.com>
 <20200104003523.rfte5rw6hbnncjes@ast-mbp>
 <20200104011318.GA11376@localhost.localdomain>
 <20200104023112.6edfdvsff6cgsstn@ast-mbp>
 <20200104030041.GA12685@localhost.localdomain>
 <20200106220746.fm3hp3zynaiaqgly@ast-mbp>
In-Reply-To: <20200106220746.fm3hp3zynaiaqgly@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0081.namprd17.prod.outlook.com
 (2603:10b6:300:c2::19) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:150::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:fe4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02f23599-5843-4fde-1657-08d792f6ad71
x-ms-traffictypediagnostic: BYAPR15MB2791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2791910D68B8C9BC3B1E1FA9BE3C0@BYAPR15MB2791.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(396003)(346002)(136003)(199004)(189003)(33656002)(8676002)(86362001)(71200400001)(6916009)(81156014)(54906003)(2906002)(81166006)(8936002)(316002)(5660300002)(6506007)(4326008)(16526019)(52116002)(64756008)(66446008)(66946007)(7696005)(66556008)(186003)(9686003)(55016002)(1076003)(66476007)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2791;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zXRC6CouZDx78aJ9Tf6l9DpzlOuEUU8Uf2k4Oo2V37Ht6anhJZI1L4iHx9UOKKeto+TP07bSawg60QxS/o6KEeXuR8CMw3y0kMUG4R17GNq+B4wSm3WYdOC9dW0FafYKxu7/bwATU3O+jABhfGd2plFbwZ1nKkqscqFPyUFj+ne00MChsYkchKCUtKyqQZVZL32yVHhZj7GdNAUviHkex1o281IR7yqxhgvOQGvrW8X0GeLVX4/Uv1x3hL721BXIlhavhUNOOtA4880UmaU9Ne0lnBRDuSwOwtHk6NSRqKhusYoqjiC1Shny23kbnifIuvZINfnzfQOsDnbKE95Nza4NqKe9aZTiXCV1iFzx87cyUXXXSdRHFMr5PEeehoe/zP5MJQ51R3Vpg9dHY3225PukEFVbBcvyUtFlEkxc5ot5JGx+djjMB8gZDDkxGiG9
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6E23FC56919DC847ADB2DB80105569DE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f23599-5843-4fde-1657-08d792f6ad71
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 22:20:46.8592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EjeRYoQG2WTe4nXrLOs0SnISKuE/WpkVqtJ73frmd7L29Y2tddxZgsGhxnbm+/2K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2791
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-06_07:2020-01-06,2020-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001060185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 02:07:48PM -0800, Alexei Starovoitov wrote:
> On Sat, Jan 04, 2020 at 03:00:46AM +0000, Roman Gushchin wrote:
> > On Fri, Jan 03, 2020 at 06:31:14PM -0800, Alexei Starovoitov wrote:
> > > On Sat, Jan 04, 2020 at 01:13:24AM +0000, Roman Gushchin wrote:
> > > > On Fri, Jan 03, 2020 at 04:35:25PM -0800, Alexei Starovoitov wrote:
> > > > > On Fri, Dec 27, 2019 at 01:50:34PM -0800, Roman Gushchin wrote:
> > > > > > Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgro=
up_bpf
> > > > > > from cgroup itself") cgroup bpf structures were released with
> > > > > > corresponding cgroup structures. It guaranteed the hierarchical=
 order
> > > > > > of destruction: children were always first. It preserved attach=
ed
> > > > > > programs from being released before their propagated copies.
> > > > > >=20
> > > > > > But with cgroup auto-detachment there are no such guarantees an=
ymore:
> > > > > > cgroup bpf is released as soon as the cgroup is offline and the=
re are
> > > > > > no live associated sockets. It means that an attached program c=
an be
> > > > > > detached and released, while its propagated copy is still livin=
g
> > > > > > in the cgroup subtree. This will obviously lead to an use-after=
-free
> > > > > > bug.
> > > > > ...
> > > > > > @@ -65,6 +65,9 @@ static void cgroup_bpf_release(struct work_st=
ruct *work)
> > > > > > =20
> > > > > >  	mutex_unlock(&cgroup_mutex);
> > > > > > =20
> > > > > > +	for (p =3D cgroup_parent(cgrp); p; p =3D cgroup_parent(p))
> > > > > > +		cgroup_bpf_put(p);
> > > > > > +
> > > > >=20
> > > > > The fix makes sense, but is it really safe to walk cgroup hierarc=
hy
> > > > > without holding cgroup_mutex?
> > > >=20
> > > > It is, because we're holding a reference to the original cgroup and=
 going
> > > > towards the root. On each level the cgroup is protected by a refere=
nce
> > > > from their child cgroup.
> > >=20
> > > cgroup_bpf_put(p) can make bpf.refcnt zero which may call cgroup_bpf_=
release()
> > > on another cpu which will do cgroup_put() and this cpu p =3D cgroup_p=
arent(p)
> > > would be use-after-free?
> > > May be not due to the way work_queues are implemented.
> > > But it feels dangerous to have such delicate release logic.
> >=20
> > If I understand your concern correctly: you assume that parent's
> > cgroup_bpf_release() can be finished prior to the child's one and
> > the final cgroup_put() will release the parent?
> >=20
> > If so, it's not possible, because the child hold a reference to the
> > parent (independent to all cgroup bpf stuff), which exists at least
> > until the final cgroup_put() in cgroup_bpf_release(). Please, look
> > at css_free_rwork_fn() for details.
> >=20
> > > Why not to move the loop under the mutex and make things obvious?
> >=20
> > Traversing the cgroup tree to the root cgroup without additional
> > locking seems pretty common to me. You can find a ton of examples in
> > mm/memcontrol.c. So it doesn't look scary or adventurous to me.
> >=20
> > I think it doesn't matter that much here, so I'm ok with putting it
> > under the mutex, but IMO it won't make the code any safer.
> >=20
> >=20
> > cc Tejun for the second opinion on cgroup locking
>=20
> Checked with TJ offline. This seems fine.
>=20
> I tweaked commit log:
> - extra 'diff' lines were confusing 'git am'
> - commit description shouldn't be split into multiline

Hm, I thought we don't break it only on the "Fixes:" line. Maybe it's
subtree-dependent :)

>=20
> And applied to bpf tree. Thanks

Thank you!
