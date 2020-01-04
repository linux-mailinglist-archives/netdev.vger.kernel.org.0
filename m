Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007C8130057
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 04:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgADDBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 22:01:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727255AbgADDBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 22:01:06 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00430EGx005310;
        Fri, 3 Jan 2020 19:00:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=64ZNoXcHx6ltjc90/42qvPeBQZUBYeYIfSt/l8jy6aI=;
 b=jBFdc6hdl4KT3NNgWHFtqNJACHF6/IaIHf+5hcd6aF89xf/ndBfNG75vZW2A8g6E3U22
 3vA7CH5tdP/mwqMLr+8QkH2aCK55AYH+Eo5b1NK4wC4bDR82o3Rqx+iBuRGtJGB289DN
 /BqM51h094WA8ZmcrWFRxUvVzJTVbJu9Frw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x9tnw52w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jan 2020 19:00:49 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 3 Jan 2020 19:00:48 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 3 Jan 2020 19:00:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0NkFQQU5E+4v6w6hycFWlt78ax9lCWmBuppTaYydFVlhTeeekST2SLio8PTkvxDQUKPJvi/V5q/JR/zCgOt30RQxsoAmqMTaxzamS8BdG5VYyTrlxOZe9G2IyVenlaXnCrvvmnPtB4oiXTlA2jEM9pB97RLQtmVNiyYWueBXiwm+MRIhHhK8ksq7x9toNUq6OQj5Hodzu++XlsoOIQU+gcMUxUFBroMVTyKsHaTCXV2DlBDbcscvyCsLiSvonjoXlcS0XNBlKtDBofaHDjXghUj3Rh/DGt4z401pbPkgz8hfCRmXiiJInuIjv8rvtkr7aP7AZ4EJJ3jl0+vacJIdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64ZNoXcHx6ltjc90/42qvPeBQZUBYeYIfSt/l8jy6aI=;
 b=EbYkkZMzvdLj/u7WJuK6OUhSBJsrgnm5L0euhWHvVWbNWa55hAPuI0ijXI8eHo/MKYkg+af4Hd+0ChMUj81UPsZTf4zVgY5ejaju84xGj0FUmL1+mDF7uFGrlCAAxFT5BefY+/pLzMxSgB6LTOV1uVjQcU17gsIY1bN+atpspbx6fU2LSlLUg/JCNT+D+QNQK2txAVYBn9yO57QTG3XNRDuPP+hHnlSzR/ruAlUdZVO2tXGKl7PQTB0k0MpOLc92B5QCRvoSN2rQmOw+ULAGHRIkCpWveH39mUFRozfggcq7bPlwKGKsU4oYL9ptxo+qKZWgucGC4XTaCgLkZYHpTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64ZNoXcHx6ltjc90/42qvPeBQZUBYeYIfSt/l8jy6aI=;
 b=ayu/qncVteuLqCLJXAdhPFCQ9kGEbnE/K43HEZf/nTRRuTjrpJqan/BUN5T5Ml1v+1h+j8BdoUeYxWciI6/5FCuQIr0ia15IBRx9X6jq/368QC8Ep0PAIf15s3SziwJ6huHnIR9Skx1Bvt9lya8NtAbhH77XA/4vF7eF1TRCkwk=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB2389.namprd15.prod.outlook.com (52.135.195.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Sat, 4 Jan 2020 03:00:46 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60%3]) with mapi id 15.20.2581.014; Sat, 4 Jan 2020
 03:00:46 +0000
Received: from localhost.localdomain (2620:10d:c090:180::dfd4) by MWHPR15CA0071.namprd15.prod.outlook.com (2603:10b6:301:4c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend Transport; Sat, 4 Jan 2020 03:00:44 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
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
Thread-Index: AQHVvP+26yjH3drshkGEPJ14gI885qfZs7aAgAAKlQCAABXHAIAACDqA
Date:   Sat, 4 Jan 2020 03:00:46 +0000
Message-ID: <20200104030041.GA12685@localhost.localdomain>
References: <20191227215034.3169624-1-guro@fb.com>
 <20200104003523.rfte5rw6hbnncjes@ast-mbp>
 <20200104011318.GA11376@localhost.localdomain>
 <20200104023112.6edfdvsff6cgsstn@ast-mbp>
In-Reply-To: <20200104023112.6edfdvsff6cgsstn@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0071.namprd15.prod.outlook.com
 (2603:10b6:301:4c::33) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:150::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::dfd4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4be83e1b-1bbb-40bc-7bbe-08d790c24b60
x-ms-traffictypediagnostic: BYAPR15MB2389:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB23896F866C559A6398FBF19EBE220@BYAPR15MB2389.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02723F29C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(66446008)(16526019)(186003)(8676002)(52116002)(8936002)(66556008)(478600001)(64756008)(7696005)(55016002)(110136005)(81166006)(54906003)(71200400001)(6506007)(33656002)(66476007)(2906002)(9686003)(81156014)(69590400006)(1076003)(5660300002)(86362001)(66946007)(316002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2389;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tigk6s6cttKBZz6bZai9Ibtip9XLFVf/j9pEo0BH79p9RUP7d3Re5liVwNvWKmjnl/tIIUY8Fammzpvb0R/7pQIqTw42IytcBFsIMq4X/sTaQopw6w7yk2KEJpy4eZSWlPTm+VmzDR/K2VYhNc3xtvj0i1kS2mPZAfnwwuKpI4NRaNQqlyRx81z7U+n3W9nOlzjmbT+YXsFQkNoPT6hC0q96ejhMVGC6pTzm+ryEghIcoCS7g3n6IJlvlqL+1zy/uBgdWNUEe8nhrgpxqh8Zwy/f0XDU8wG+fKveKnUFSDMvhYOwUbjTrFpPp+62OUSjkYoHahdW8mW5ehObuBTSE4K4bl0XanYP3DnwpRvtSObJBcxygo+8+qlPhrKoVZOiYaYXCJxa1R3x9chUZAk8WbO/Xt6+DbhRjU1T7oRc4pHP+KmKnZ0FyWzFJd2AYkgkke1o4hVnMbqF9Xl1/mwXePdxbBYFKYF9lprjNW7oOOQFfeTaA/KCliwFjWC8N7Di
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FCBC2CEE694DEF4DB82ACACD9CF20058@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be83e1b-1bbb-40bc-7bbe-08d790c24b60
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2020 03:00:46.0842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0/aQv1RzWCskVdyCEmcTYdPI5m6Vw2DKeCPYRWwPgMu8sxKuVRw8QuRQIxMvOPOR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-03_06:2020-01-02,2020-01-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001040027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 06:31:14PM -0800, Alexei Starovoitov wrote:
> On Sat, Jan 04, 2020 at 01:13:24AM +0000, Roman Gushchin wrote:
> > On Fri, Jan 03, 2020 at 04:35:25PM -0800, Alexei Starovoitov wrote:
> > > On Fri, Dec 27, 2019 at 01:50:34PM -0800, Roman Gushchin wrote:
> > > > Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_b=
pf
> > > > from cgroup itself") cgroup bpf structures were released with
> > > > corresponding cgroup structures. It guaranteed the hierarchical ord=
er
> > > > of destruction: children were always first. It preserved attached
> > > > programs from being released before their propagated copies.
> > > >=20
> > > > But with cgroup auto-detachment there are no such guarantees anymor=
e:
> > > > cgroup bpf is released as soon as the cgroup is offline and there a=
re
> > > > no live associated sockets. It means that an attached program can b=
e
> > > > detached and released, while its propagated copy is still living
> > > > in the cgroup subtree. This will obviously lead to an use-after-fre=
e
> > > > bug.
> > > ...
> > > > @@ -65,6 +65,9 @@ static void cgroup_bpf_release(struct work_struct=
 *work)
> > > > =20
> > > >  	mutex_unlock(&cgroup_mutex);
> > > > =20
> > > > +	for (p =3D cgroup_parent(cgrp); p; p =3D cgroup_parent(p))
> > > > +		cgroup_bpf_put(p);
> > > > +
> > >=20
> > > The fix makes sense, but is it really safe to walk cgroup hierarchy
> > > without holding cgroup_mutex?
> >=20
> > It is, because we're holding a reference to the original cgroup and goi=
ng
> > towards the root. On each level the cgroup is protected by a reference
> > from their child cgroup.
>=20
> cgroup_bpf_put(p) can make bpf.refcnt zero which may call cgroup_bpf_rele=
ase()
> on another cpu which will do cgroup_put() and this cpu p =3D cgroup_paren=
t(p)
> would be use-after-free?
> May be not due to the way work_queues are implemented.
> But it feels dangerous to have such delicate release logic.

If I understand your concern correctly: you assume that parent's
cgroup_bpf_release() can be finished prior to the child's one and
the final cgroup_put() will release the parent?

If so, it's not possible, because the child hold a reference to the
parent (independent to all cgroup bpf stuff), which exists at least
until the final cgroup_put() in cgroup_bpf_release(). Please, look
at css_free_rwork_fn() for details.

> Why not to move the loop under the mutex and make things obvious?

Traversing the cgroup tree to the root cgroup without additional
locking seems pretty common to me. You can find a ton of examples in
mm/memcontrol.c. So it doesn't look scary or adventurous to me.

I think it doesn't matter that much here, so I'm ok with putting it
under the mutex, but IMO it won't make the code any safer.


cc Tejun for the second opinion on cgroup locking
