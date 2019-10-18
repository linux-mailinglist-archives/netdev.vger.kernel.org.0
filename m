Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B5DDCBEB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408796AbfJRQv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:51:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24802 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391295AbfJRQv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:51:27 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IGmV8q024456;
        Fri, 18 Oct 2019 09:51:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VQMzERJIgKDvJJ8XljvowSvQSkNk92XbhSPLa6Adcjo=;
 b=mKJbX7cJiEtclEHq2tMFo/0nHqCXYVzkJIDgrFQMORMojTRrvEntR9ypGRTSFusistmJ
 AQCBYmZP7D4Ynm3RHy5gPMKzPtmci2iJ0rJ5Up+CrBeFLjuxC3dsKRb/ZNvFWxboGmX5
 DFAZUsPf2LJj9As50S2Zq1Haq2Wwj0zBeA8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vpw9rcp72-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 09:51:10 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 09:51:08 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 09:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHbeRblmVArlHI/H/crk9LddmZWFCEBX3L3MsEp0vEH7u660Ep+jBtwnFAOFrJc82vg8RpI+DY/XSecjI3n6j+e4TgoAhlyR1kJ3jha91PNDX/UaUaJHrOJZ0elYox7MOsIpWe6SjMcE5uDaPePHgqDbOTxnZCqbYg9zTXtkgpTvOVTGk5787CdqPHRhd+C/+c/oa3oR4HZndE5lzACaJOaLjFKpNlekUyjWSlxNADaVXQQBqSbDpcEJHcgQNWBKj/5ZufWZEbFEzarUcXj0Ur3Gzgidiees4zSQhta8Vh964zpMGKUL2FHRdUT9IXvM4lukFky1DIz9+CE1XxKIWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQMzERJIgKDvJJ8XljvowSvQSkNk92XbhSPLa6Adcjo=;
 b=AApMsir/kaC46jc+JNQiyTF7SYDIJDhY1xQk5HgCZl1f0IUEOQ3i+Pp52dfx8CKKla+XWPUDmJnsa9TLvzTzzCZaPU2mdsJ8QOOY7+THZUeJL0QUv39IhdcZWUVSNz+GdG81kQCAJkYDwze4N0FMrpIo04irbnXBSyPM+gqeCHjX4K7RpB+tokOjz/YMSOKzsI/Fimr6aI4NO7xjtPVCBBcTKATx3iV0CcKu67VcxdakjUXgkev0milu+ZDrKS1jTp0w4a4D9LvUgEG0TBlzK6lHr7rSAz+FK9i17SzjHyHEU1UnyivyevIAYXIdMlQ6xn1Y15yUGg7nLND6EzeC6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQMzERJIgKDvJJ8XljvowSvQSkNk92XbhSPLa6Adcjo=;
 b=A8pVG7d7Swy5MvWh8fE7Oi/j46uJNv3HQimASVbahnOnSyCi/KYieaD+iBtMiLZ5OcR6v8jzcp93RNAGp/P3/28u9OwPofhPFyA89A1sTYRmmh3Xdho1ItrazxLN5+QJUGOlSKoaIyFEvl/YkyTFS+cW8xFQ/yI8ttJmMBV39k0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3037.namprd15.prod.outlook.com (20.178.254.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Fri, 18 Oct 2019 16:50:57 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 16:50:57 +0000
From:   Martin Lau <kafai@fb.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf v2] xdp: Handle device unregister for devmap_hash map
 type
Thread-Topic: [PATCH bpf v2] xdp: Handle device unregister for devmap_hash map
 type
Thread-Index: AQHVhNkLfZlWSO7mI0yzFNGdtyQQtadfMRqAgAECVICAAGtDgA==
Date:   Fri, 18 Oct 2019 16:50:57 +0000
Message-ID: <20191018165049.rm6du3yq2e4vg45h@kafai-mbp>
References: <20191017105232.2806390-1-toke@redhat.com>
 <20191017190219.hpphf7jnyn6xapb6@kafai-mbp.dhcp.thefacebook.com>
 <87pniue4cw.fsf@toke.dk>
In-Reply-To: <87pniue4cw.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:104:1::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:a4bc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5101464d-b973-43db-a4e7-08d753eb58f7
x-ms-traffictypediagnostic: MN2PR15MB3037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB30377C7F89391ADC54254F21D56C0@MN2PR15MB3037.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(366004)(346002)(376002)(136003)(39860400002)(199004)(189003)(66476007)(66946007)(6486002)(2906002)(4326008)(9686003)(5660300002)(1076003)(64756008)(66556008)(66574012)(66446008)(6246003)(6512007)(6436002)(33716001)(14454004)(8936002)(86362001)(478600001)(8676002)(7736002)(54906003)(11346002)(6916009)(316002)(81156014)(305945005)(446003)(476003)(71200400001)(81166006)(6506007)(25786009)(99286004)(46003)(71190400001)(6116002)(486006)(102836004)(229853002)(52116002)(186003)(76176011)(256004)(386003)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3037;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GUVWvdPyE79UBoF9V6+oe1aA4siVZlvi2RxwqhqjcXrW0TmjUTS1SGcdQPUNAWG8u5eeXoM16M4KrpnoVJxEnsFppVD5Nj/9H2y2iOxd2ak75uskgfXdWmrlfpzMQoXiq1HeE4Z1jbfzwT71LR8/LHtxLm9ydVHK1RB8yAbJZbZkP54ZF957ZZCWzPTDg7JDlUIdafX5crJEqRoTs7HoOluFc7P5ZDtPErOZ0/ocFPu67qKEPnbr2hHoGPO1hhUaHOyWL3EWJj/SLKnSCe9FAjnajkaDFRoMYfr5UN4/IvKkVx9YCjC8Ep/bRWpr83YqG/5Hf0oUeGopcKgTBTm7IrL5JDKFNUvIjaeYr9K51vLynU+7+AdkU1C2xSyyeCoSG8ab+7NttiCjq+xKR6ZRjNcai6yE2/LuJVxVrVbC1BM=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <160DED47FB3C1E429E98868CFB1A58F8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5101464d-b973-43db-a4e7-08d753eb58f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 16:50:57.3917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K39vKxAAdLVU6qiUHHefDhgDvRm0yDyLhCSQXPybtaeMwIbtOOqaJ1Fe+Uvw++Yo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3037
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=554
 lowpriorityscore=0 mlxscore=0 suspectscore=0 phishscore=0 clxscore=1015
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 12:26:55PM +0200, Toke H=F8iland-J=F8rgensen wrote:
> Martin Lau <kafai@fb.com> writes:
>=20
> > On Thu, Oct 17, 2019 at 12:52:32PM +0200, Toke H=F8iland-J=F8rgensen wr=
ote:
> >> It seems I forgot to add handling of devmap_hash type maps to the devi=
ce
> >> unregister hook for devmaps. This omission causes devices to not be
> >> properly released, which causes hangs.
> >>=20
> >> Fix this by adding the missing handler.
> >>=20
> >> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up dev=
ices by hashed index")
> >> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> >> Signed-off-by: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> >> ---
> >> v2:
> >>   - Grab the update lock while walking the map and removing entries.
> >>=20
> >>  kernel/bpf/devmap.c | 37 +++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 37 insertions(+)
> >>=20
> >> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >> index d27f3b60ff6d..a0a1153da5ae 100644
> >> --- a/kernel/bpf/devmap.c
> >> +++ b/kernel/bpf/devmap.c
> >> @@ -719,6 +719,38 @@ const struct bpf_map_ops dev_map_hash_ops =3D {
> >>  	.map_check_btf =3D map_check_no_btf,
> >>  };
> >> =20
> >> +static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
> >> +				       struct net_device *netdev)
> >> +{
> >> +	unsigned long flags;
> >> +	int i;
> > dtab->n_buckets is u32.
>=20
> Oh, right, will fix.
>=20
> >> +
> >> +	spin_lock_irqsave(&dtab->index_lock, flags);
> >> +	for (i =3D 0; i < dtab->n_buckets; i++) {
> >> +		struct bpf_dtab_netdev *dev, *odev;
> >> +		struct hlist_head *head;
> >> +
> >> +		head =3D dev_map_index_hash(dtab, i);
> >> +		dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head))=
,
> > The spinlock has already been held.  Is rcu_deref still needed?
>=20
> I guess it's not strictly needed, but since it's an rcu-protected list,
> and hlist_first_rcu() returns an __rcu-annotated type, I think we will
> get a 'sparse' warning if it's omitted, no?
>=20
> And since it's just a READ_ONCE, it doesn't actually hurt since this is
> not the fast path, so I'd lean towards just keeping it? WDYT?
>
Can hlist_for_each_safe() be used instead then?
A bonus is the following long line will go away.
I think the change will be simpler also.


> +                                    struct bpf_dtab_netdev,
> +                                    index_hlist);
> +
> +             while (dev) {
> +                     odev =3D (netdev =3D=3D dev->dev) ? dev : NULL;
> +                     dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_=
next_rcu(&dev->index_hlist)),
> +                                            struct bpf_dtab_netdev,
> +                                            index_hlist);
> +
> +                     if (odev) {
> +                             hlist_del_rcu(&odev->index_hlist);
> +                             call_rcu(&odev->rcu,
> +                                      __dev_map_entry_free);
> +                     }
> +             }
> +     }
> +     spin_unlock_irqrestore(&dtab->index_lock, flags);
> +}
> +
