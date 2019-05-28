Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAC52D0B9
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfE1Uyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:54:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35766 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbfE1Uyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:54:40 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SKrEgb001474;
        Tue, 28 May 2019 13:54:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=k7u+ohxAngQcuygqvMmaptsskvWGbNRt6rFQ8agGP5I=;
 b=fMkrSGQLYoV7dJcNEHmk1iBnjfbBafEXvotY2fMYBNIi9WsA+n68RRvg6toooMUTx15i
 e6BsKCF/ciBNNCnBkcioCxh64yXF1F19NMMaxMOqzNSI7zbKoYum7vPkZBjKOAPHIK3H
 KaeJNDuWD7CXE30ApQPdp/qF176jnUa6QJg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss8rd0vy5-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 May 2019 13:54:14 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 13:53:58 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 28 May 2019 13:53:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7u+ohxAngQcuygqvMmaptsskvWGbNRt6rFQ8agGP5I=;
 b=mQnWIC+5O9hz4j8sb31ddjmkE6J9qmc5DJfSw0SSj6ZrPhyagwjXwYxbPiZTq0sGVEUerSKs2FzjWxiBgVj97ahPspMICpY/+rmPM3kaa+24trNiiamwVIOWtOad4zyHqmTpl1+CtNEmdLaIIVPa5K6zQrae87x3V3z3MvGzfRg=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB2807.namprd15.prod.outlook.com (20.179.158.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Tue, 28 May 2019 20:53:56 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 20:53:56 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v3 3/4] bpf: cgroup: properly use bpf_prog_array
 api
Thread-Topic: [PATCH bpf-next v3 3/4] bpf: cgroup: properly use bpf_prog_array
 api
Thread-Index: AQHVFYNuZOejCl/kQUWLljlEI/uGLKaAeu8AgAB+lgCAAApdAA==
Date:   Tue, 28 May 2019 20:53:55 +0000
Message-ID: <20190528205352.GB27847@tower.DHCP.thefacebook.com>
References: <20190528182946.3633-1-sdf@google.com>
 <20190528182946.3633-3-sdf@google.com>
 <20190528194342.GC20578@tower.DHCP.thefacebook.com>
 <20190528201646.GE3032@mini-arch>
In-Reply-To: <20190528201646.GE3032@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0018.namprd19.prod.outlook.com
 (2603:10b6:300:d4::28) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3dca]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94276d1e-62b6-4d61-37d3-08d6e3ae996e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2807;
x-ms-traffictypediagnostic: BYAPR15MB2807:
x-microsoft-antispam-prvs: <BYAPR15MB28077483255AC18F93448AEABE1E0@BYAPR15MB2807.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(396003)(346002)(136003)(189003)(199004)(7736002)(305945005)(8676002)(81156014)(81166006)(53936002)(6506007)(1076003)(71200400001)(386003)(8936002)(54906003)(52116002)(76176011)(102836004)(6916009)(71190400001)(478600001)(5024004)(14444005)(256004)(5660300002)(9686003)(6512007)(86362001)(229853002)(6486002)(6436002)(73956011)(68736007)(6246003)(33656002)(316002)(25786009)(486006)(99286004)(6116002)(64756008)(14454004)(66446008)(11346002)(446003)(66476007)(46003)(66556008)(2906002)(476003)(186003)(66946007)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2807;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vlQYMXZ44PxsIAqWrZ/md16P7KIZJvSg4cyGyI53fzQ7SXgpaj0zXDEuLPOvX4NtrH09D9haqKHU5aMbXJhCa4bR+ansrX8HeR6BibOf2gRGQITjzHXyVjL/EOktSgiX6lzmCotd8J3YtDvfIdioVzpdHnx4iWxdysFFcHBaOeTSrbWa88wKGtU1E9PcM/2qOhUERC1cznIykSXA3rh/ZnBxU4ze4ASokJbcb0Tp4kJqrJo98wBZhJw2B8Lr3Qnmic1oaDeZUxi3U5G9FOQNc18Sg+Oh2uLtshYg8lXJzf0gM1a5Cd3vfGhPAtjcI1XgTaS3u5YEgetAUGV125+qcsPzAsvJ/gGOljMx8mDbD16TaoE33Q5MUuVxuw8ctfiH2G/bY49ln4LNZXLtpmbLYT911voyCW9yjs5r3MD2Mjo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2B92DAE0F83356428185E0A49D7A35CF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 94276d1e-62b6-4d61-37d3-08d6e3ae996e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 20:53:55.9984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2807
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=984 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 01:16:46PM -0700, Stanislav Fomichev wrote:
> On 05/28, Roman Gushchin wrote:
> > On Tue, May 28, 2019 at 11:29:45AM -0700, Stanislav Fomichev wrote:
> > > Now that we don't have __rcu markers on the bpf_prog_array helpers,
> > > let's use proper rcu_dereference_protected to obtain array pointer
> > > under mutex.
> > >=20
> > > We also don't need __rcu annotations on cgroup_bpf.inactive since
> > > it's not read/updated concurrently.
> > >=20
> > > v3:
> > > * amend cgroup_rcu_dereference to include percpu_ref_is_dying;
> > >   cgroup_bpf is now reference counted and we don't hold cgroup_mutex
> > >   anymore in cgroup_bpf_release
> > >=20
> > > v2:
> > > * replace xchg with rcu_swap_protected
> > >=20
> > > Cc: Roman Gushchin <guro@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/linux/bpf-cgroup.h |  2 +-
> > >  kernel/bpf/cgroup.c        | 32 +++++++++++++++++++++-----------
> > >  2 files changed, 22 insertions(+), 12 deletions(-)
> > >=20
> > > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > > index 9f100fc422c3..b631ee75762d 100644
> > > --- a/include/linux/bpf-cgroup.h
> > > +++ b/include/linux/bpf-cgroup.h
> > > @@ -72,7 +72,7 @@ struct cgroup_bpf {
> > >  	u32 flags[MAX_BPF_ATTACH_TYPE];
> > > =20
> > >  	/* temp storage for effective prog array used by prog_attach/detach=
 */
> > > -	struct bpf_prog_array __rcu *inactive;
> > > +	struct bpf_prog_array *inactive;
> > > =20
> > >  	/* reference counter used to detach bpf programs after cgroup remov=
al */
> > >  	struct percpu_ref refcnt;
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index d995edbe816d..118b70175dd9 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -22,6 +22,13 @@
> > >  DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
> > >  EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> > > =20
> > > +#define cgroup_rcu_dereference(cgrp, p)					\
> > > +	rcu_dereference_protected(p, lockdep_is_held(&cgroup_mutex) ||	\
> > > +				  percpu_ref_is_dying(&cgrp->bpf.refcnt))
> >=20
> > Some comments why percpu_ref_is_dying(&cgrp->bpf.refcnt) is enough here=
 will
> > be appreciated.
> I was actually debating whether to just use raw
> rcu_dereference_protected(p, lockdep_is_held()) in __cgroup_bpf_query and
> rcu_dereference_protected(p, percpu_ref_is_dying()) in cgroup_bpf_release
> instead of having a cgroup_rcu_dereference which covers both cases.
>=20
> Maybe that should make it more clear (and doesn't require any comment)?

Yeah, this makes total sense to me.
