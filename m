Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB312FFEC
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 02:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgADBNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 20:13:40 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63296 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbgADBNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 20:13:40 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0041AwV0014159;
        Fri, 3 Jan 2020 17:13:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2B7sRZu/IXS5r/ddttMrVkIE1jGEo1pL5oaSs+e7Hro=;
 b=WmbHoarUcrAk5SQSacRdmrolNpMdf60+SPJBvhAPn+KYj+RX81EssOCAwPRisjYK7vEk
 PxE5Ciw5OLxVKpPE9F2Y7sHjpIh4+5UjPPF7VkgWMe2Wb8qy8hMI3JXuK4jEQaDb3AXC
 FI+1G9ZVmZ6oZjy9VjtivCb5ZR70twWdKG4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x9e34yp1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 03 Jan 2020 17:13:26 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 3 Jan 2020 17:13:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My23QtM1xR4cXFrwj/gLHqwqdKDvJ6LS+pDRU+OlMLqKVaVh6zk2c12nPxE6ydYIu52k24XEX87iNTMSP19vWgKrMxYXkWFx8FfijbIwY2HiEE8enNOpIUMgQ1eUdm+rb1PIIGu776KxM0OWeRG+VtB6cA/+Gak1xvO4MG5FihlLOYwiIJd9DOyowEJAtJiwltz8fNnylYhpEd++VUUYIpuOo8JzKx1x5MOOmpURQIPyzp9/wDIXLAFvvSZ9bhjtu6J247+aBRPNq007WzXwZZnagcX2E+elIpr8Oqqed6of9FrCiGVLLRbMOp6iVH91oenaqrp1H1u4yYoDXt8uYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2B7sRZu/IXS5r/ddttMrVkIE1jGEo1pL5oaSs+e7Hro=;
 b=hA0P+C3yE7sz6Y8l8oimgFqJ5aPtiQC1EjGWuhBdam9DGmakcrUP+050uuU58IvM9+ZGkVY5Nsap95HRc/OI1VvqEwsL98MP+7y2hBlf6pir2rYARY1+U/+XqXUY1712CgKhYYeEs1Wh5d6Cp6YI+uPyWeeEY+pvtY+ICYmVc7qh6x0zfSwAnfT8kUn4hRdXChG5N17i2uCOb3L5siceyl/ktPdR/+V9KQR7kIcf5JKVYP5wfD1K3XSk21extNhvAsJ3aooWNzpVscnYgYCKQM60ILdUOU3CQ6LQDe0B6Yt4fc5TR0bQCIE7/qQFUm8+1d57MX9KFVQMH8AZHaypFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2B7sRZu/IXS5r/ddttMrVkIE1jGEo1pL5oaSs+e7Hro=;
 b=BN1YCtCzmt3rPi2LiscJmzStPZUJnbdoLZhisRLbJ62KteThwcTaJparW74t1v89uawgsoF3ZeQmPVgJQGHe7xDqTW43EzR/Z+rGmrOj+kLuwVz9XdQgR7s/ZYDAg7p3uQ3njLn4PrkjLdRRcqlfsxt862NYEtxRXxQdHqx9Fg0=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.136.151) by
 BN8PR15MB3380.namprd15.prod.outlook.com (20.179.76.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Sat, 4 Jan 2020 01:13:24 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::506c:fb1f:2e5a:4652]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::506c:fb1f:2e5a:4652%6]) with mapi id 15.20.2602.010; Sat, 4 Jan 2020
 01:13:24 +0000
Received: from localhost.localdomain (2620:10d:c090:180::5d5) by MWHPR14CA0001.namprd14.prod.outlook.com (2603:10b6:300:ae::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Sat, 4 Jan 2020 01:13:22 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Thread-Index: AQHVvP+26yjH3drshkGEPJ14gI885qfZs7aAgAAKlQA=
Date:   Sat, 4 Jan 2020 01:13:24 +0000
Message-ID: <20200104011318.GA11376@localhost.localdomain>
References: <20191227215034.3169624-1-guro@fb.com>
 <20200104003523.rfte5rw6hbnncjes@ast-mbp>
In-Reply-To: <20200104003523.rfte5rw6hbnncjes@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0001.namprd14.prod.outlook.com
 (2603:10b6:300:ae::11) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c2::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fd92055-1ac1-41bc-a566-08d790b34bc7
x-ms-traffictypediagnostic: BN8PR15MB3380:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB3380D408A9FE72DBE6A85F9DBE220@BN8PR15MB3380.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 02723F29C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(366004)(136003)(346002)(199004)(189003)(52116002)(6916009)(2906002)(66446008)(4326008)(316002)(16526019)(186003)(86362001)(66556008)(6506007)(66946007)(64756008)(33656002)(54906003)(1076003)(478600001)(66476007)(7696005)(8676002)(8936002)(69590400006)(81156014)(81166006)(5660300002)(9686003)(71200400001)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3380;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Qrp22IHn2Y+tjv8EQnwk8IOFxm6Xtx1oFEwXTbZRxoEDlVTneECE2JNvo5lJqF4C5P64MvXMwlnveNDH6/ITKk+bYaerFFTL7I103+Z24ZzI36BsM0P0XZ/wyJPpewpub45mcOsADkNORl/kHTYWZ8mysIML+Np+LClXFLW6TMLrMSxNV9tZdUmqqXIDBHpboJgqTT1Z0nYWc3KdD5TeKMxfqNL8ou8vJi1SCJQrwec3CZ+fpw/XoeJmw4pmNfpreRCKsBUBQ+qDoHa7LlAsS+OqTKrDrLwmff+kbgYJYnHBsPTu7Z6drGjQ4QW+DvXLNkDwe578Fcbflq3j68cq6xNfmImAiVO3DufULBoIWRwFZakosUWXW/WdGk4IjkcNELbjvHHXmRoI5/gsvZCEcpBYGzTnV8nzUj5yhKabcAnH7hOxogG+toNyOsIzpEkM08NemncazroO7wlnT7uXt1Z8lFdWcVUiTIPDQ2SAmucGxx3HPsSGV0AMVlbKhzX
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2EC9F6EE2BBA334D8C4F001C4E795C81@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd92055-1ac1-41bc-a566-08d790b34bc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2020 01:13:24.2704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zu/1pzShoXCeGnGU679XUN2c6dWYubz1487Mkd8AS06vP9eoU8KBONd+Vs0J3ncu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3380
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-03_06:2020-01-02,2020-01-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 clxscore=1011 bulkscore=0 mlxlogscore=948
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001040009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 04:35:25PM -0800, Alexei Starovoitov wrote:
> On Fri, Dec 27, 2019 at 01:50:34PM -0800, Roman Gushchin wrote:
> > Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf
> > from cgroup itself") cgroup bpf structures were released with
> > corresponding cgroup structures. It guaranteed the hierarchical order
> > of destruction: children were always first. It preserved attached
> > programs from being released before their propagated copies.
> >=20
> > But with cgroup auto-detachment there are no such guarantees anymore:
> > cgroup bpf is released as soon as the cgroup is offline and there are
> > no live associated sockets. It means that an attached program can be
> > detached and released, while its propagated copy is still living
> > in the cgroup subtree. This will obviously lead to an use-after-free
> > bug.
> ...
> > @@ -65,6 +65,9 @@ static void cgroup_bpf_release(struct work_struct *wo=
rk)
> > =20
> >  	mutex_unlock(&cgroup_mutex);
> > =20
> > +	for (p =3D cgroup_parent(cgrp); p; p =3D cgroup_parent(p))
> > +		cgroup_bpf_put(p);
> > +
>=20
> The fix makes sense, but is it really safe to walk cgroup hierarchy
> without holding cgroup_mutex?

It is, because we're holding a reference to the original cgroup and going
towards the root. On each level the cgroup is protected by a reference
from their child cgroup.

Thanks!
