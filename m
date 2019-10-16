Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167E5D972E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406257AbfJPQYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 12:24:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406242AbfJPQYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 12:24:25 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9GGNvUl032056;
        Wed, 16 Oct 2019 09:24:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Y8b3O0izGH6B6oAvyk29Fca6qMkN85XhYT8t4N2ucvI=;
 b=T3eq0IbvsFC+wVKXexuoaLFSJrstHV1aVx4FHBO2JfSxjrrOvyD6p5z6B+Ghx7AQkXmb
 5TvmxwMdqDXR0E0PBWfqpyuaWAEP9xgJaNPnuM4CfdL4Eo+JPTsSB9CpHFmS4R3VJh/4
 9+DCiTxsIr1R6TO/LJ1cWDdq+iIMjcRJDvg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vp3uk0wm0-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 09:24:10 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 16 Oct 2019 09:24:09 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Oct 2019 09:24:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUKpf6yFjkg5cxguWZkwflZuh9SC4fZdZwluR06xwvUOn3v1xDgsxdOhGOYp1uCYqf2p6JUa+RQCm4u8vrYHbwg2hwjk2PGG5LxHZ3ZK2or86c9mxBNoUnK+05v9FnLgJrtazrl8938NG2VlST6uH031VF6iDG6/qQmpf5mtoW4B1GLlv3J4g7aqxsXaaHg4VBD2oPHDjGBo/28i9KRDEQfp3ULOdOu95U1nCRGchb6fiBsUOHdu0BYsaygNNrnxu5VmOcWtVPm1lQnp5fwenr/Z6K8OJYgzh5HE9lXCmFaoBlvKocqfcu6JeyE53GG8d0VMldWZy0f9vNDicVWhgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8b3O0izGH6B6oAvyk29Fca6qMkN85XhYT8t4N2ucvI=;
 b=C3n4cpTbyM+4F0/Nu77C8lcq8Fl6j8Depq+kn3w0fdL1HpG2qeiscXRosct+5NIdU19NPMTncqWNRllU/r0kB6FdgLSo9Rc9rgRawK/ixXsxqypjdfqKEUdvvfQHFPxvS7Cd5wZsoer++AMWYgAe0r4cQazosPm5tRcR2yWwGruSch6nM/2YjsOry16wjL1cz7QMR2x2Nyqy6glRBuuyN6yTIdoS4RJr/ZPPpKZ3mix+ELHaYnurjvfKcyRSHG77ghdVqAuXtPxMQuoS9fQV+LlZj4WNwnPvswkzLLBt243RWIaMCovhFmwc0af/CsRInXYpSZZxGmoVSMa/QJxIuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8b3O0izGH6B6oAvyk29Fca6qMkN85XhYT8t4N2ucvI=;
 b=ixMfxQcW9wvYZ26SGqYqBqqP5HFhfR0mrrJ5+j+M/dxZeJo9TsPLxPZRc77muGUqcVy7K+L+Yifrvr/YZ/tOHYuQ9dFqorHlgsGC1+NQbXOAx+n8Q9BXg6opIFbSUMzfneLPY+s5BGWyIxtKVv0OOvxHIE71XXnFTpVzcDStn58=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3037.namprd15.prod.outlook.com (20.178.254.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 16 Oct 2019 16:24:08 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:24:08 +0000
From:   Martin Lau <kafai@fb.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH bpf] xdp: Handle device unregister for devmap_hash map
 type
Thread-Topic: [PATCH bpf] xdp: Handle device unregister for devmap_hash map
 type
Thread-Index: AQHVhCdnOR3nrj1xGEaiOpwmcUHfkqddc+mA
Date:   Wed, 16 Oct 2019 16:24:08 +0000
Message-ID: <20191016162357.b2kdf6cflw3c5gzb@kafai-mbp.dhcp.thefacebook.com>
References: <20191016132802.2760149-1-toke@redhat.com>
In-Reply-To: <20191016132802.2760149-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:102:1::52) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f9fb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fba8a5a1-fa80-4bcc-9e01-08d752554529
x-ms-traffictypediagnostic: MN2PR15MB3037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB303710CF878D8D1DF075F9FED5920@MN2PR15MB3037.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(136003)(39860400002)(346002)(396003)(199004)(189003)(11346002)(71200400001)(6506007)(81156014)(316002)(8936002)(81166006)(86362001)(7736002)(478600001)(6916009)(54906003)(8676002)(102836004)(52116002)(76176011)(186003)(6116002)(229853002)(486006)(476003)(305945005)(446003)(14444005)(386003)(256004)(99286004)(25786009)(46003)(71190400001)(6246003)(9686003)(2906002)(4326008)(6486002)(66946007)(66476007)(5660300002)(14454004)(6436002)(66574012)(66446008)(1076003)(64756008)(66556008)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3037;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bYdKlqimPGi6Qz5rdkOQFaneIOz0Fk+y3CeCWG0eTCpwK0NOX9JrIQ7WuTIUAdC2NXOmNyhs/0j9yGxdsd56tKBW7B1hDZZrbsEM5t4Em31QRpmlcDbsuTPF7btzMbyN1ay9MggEvWBBGxpz+z1M727U51yEYWSlIinwQL1X0asGLWSLqWFubNEVszlMjaEtj4Q68+gzK4CkrWXy8mAhLsZ6HjOeHiCNZlxoJWPKrzEqlGT1AZ4NKY5sRj3kg08ahS6dBtMbZY22D9KIBNs5ER5f+l4MeEXO2LGlH6H2KGgr/Cw8HbAhvB+5M7m+FglLKjNoqZAfiY97Nl6uU9yWitMqc2HNVmGKFaAb+2dVWCZAgcBEPg895FGuS+Wju+0W91TeS2bG7xQ0ttPC2vLjzcX9bVVfR4YrayHc3ue3/aA=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4C918A4FAAC0444D87AA2CF002261D22@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fba8a5a1-fa80-4bcc-9e01-08d752554529
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:24:08.4526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bOu6Lh3aBnzOUtgAsUC9gc3vhL9leefJ+EyeGI99/OG6L2+yrJ7SzG4ilCp1sV3q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3037
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_07:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=800 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1011 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 03:28:02PM +0200, Toke H=F8iland-J=F8rgensen wrote:
> It seems I forgot to add handling of devmap_hash type maps to the device
> unregister hook for devmaps. This omission causes devices to not be
> properly released, which causes hangs.
>=20
> Fix this by adding the missing handler.
>=20
> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up device=
s by hashed index")
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> ---
>  kernel/bpf/devmap.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>=20
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index d27f3b60ff6d..deb9416341e9 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -719,6 +719,35 @@ const struct bpf_map_ops dev_map_hash_ops =3D {
>  	.map_check_btf =3D map_check_no_btf,
>  };
> =20
> +static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
> +				       struct net_device *netdev)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < dtab->n_buckets; i++) {
> +		struct bpf_dtab_netdev *dev, *odev;
> +		struct hlist_head *head;
> +
> +		head =3D dev_map_index_hash(dtab, i);
> +		dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head)),
> +				       struct bpf_dtab_netdev,
> +				       index_hlist);
> +
> +		while (dev) {
> +			odev =3D (netdev =3D=3D dev->dev) ? dev : NULL;
> +			dev =3D hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(&dev->ind=
ex_hlist)),
> +					       struct bpf_dtab_netdev,
> +					       index_hlist);
> +
> +			if (odev) {
> +				hlist_del_rcu(&odev->index_hlist);
Would it race with the dev_map_hash's update/delete side?

> +				call_rcu(&odev->rcu,
> +					 __dev_map_entry_free);
> +			}
> +		}
> +	}
> +}
> +
>  static int dev_map_notification(struct notifier_block *notifier,
>  				ulong event, void *ptr)
>  {
> @@ -735,6 +764,11 @@ static int dev_map_notification(struct notifier_bloc=
k *notifier,
>  		 */
>  		rcu_read_lock();
>  		list_for_each_entry_rcu(dtab, &dev_map_list, list) {
> +			if (dtab->map.map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
> +				dev_map_hash_remove_netdev(dtab, netdev);
> +				continue;
> +			}
> +
>  			for (i =3D 0; i < dtab->map.max_entries; i++) {
>  				struct bpf_dtab_netdev *dev, *odev;
> =20
> --=20
> 2.23.0
>=20
