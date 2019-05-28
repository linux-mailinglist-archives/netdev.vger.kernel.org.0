Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898492CFB5
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfE1ToH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:44:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46398 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbfE1ToG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:44:06 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SJgcEP004415;
        Tue, 28 May 2019 12:43:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yhUYvJTPSVO43FtV9LuZGVl3h/Mkzvo8J7v5p7WcWxs=;
 b=IhZL1ahsj2py6t6xOeruAz54po4s8RkSnBV+6kEKPBHveXnoR6YjPzSOdxSJu0SvDifT
 SE73cqh1nyfvgkPzcQOStWKoJKjBmy83HomEGVMlDXsRNHmMdmrToK6iucdveB4HSCVI
 a5/Zx/cpVMUPP8QHMnREjaWYFHYSWS8TD2s= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss8rd0n6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 May 2019 12:43:49 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 28 May 2019 12:43:48 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 28 May 2019 12:43:48 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 28 May 2019 12:43:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhUYvJTPSVO43FtV9LuZGVl3h/Mkzvo8J7v5p7WcWxs=;
 b=rnk/mGqWhksH4h+ZbjYr0y2eUgB4I1ruBfFl/v6m9EU2Onlj1wDYlGKCukhHqhjtyCgKQJP05Q4CIDLcrWyLRCykUOjftaN3Nqr+CLVgU36QrFqIrFIfh6sAdaW2sUwcCL50YbIIsksGNbUIxKlkspy9T+iQ7jLic97epQAO31o=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB3383.namprd15.prod.outlook.com (20.179.59.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.16; Tue, 28 May 2019 19:43:46 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 19:43:46 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v3 3/4] bpf: cgroup: properly use bpf_prog_array
 api
Thread-Topic: [PATCH bpf-next v3 3/4] bpf: cgroup: properly use bpf_prog_array
 api
Thread-Index: AQHVFYNuZOejCl/kQUWLljlEI/uGLKaA8EcA
Date:   Tue, 28 May 2019 19:43:46 +0000
Message-ID: <20190528194342.GC20578@tower.DHCP.thefacebook.com>
References: <20190528182946.3633-1-sdf@google.com>
 <20190528182946.3633-3-sdf@google.com>
In-Reply-To: <20190528182946.3633-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0035.namprd02.prod.outlook.com
 (2603:10b6:301:74::48) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3dca]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14b666cb-3337-4c8a-4af0-08d6e3a4cc8c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3383;
x-ms-traffictypediagnostic: BYAPR15MB3383:
x-microsoft-antispam-prvs: <BYAPR15MB3383A1E89C1F68A0FE539F15BE1E0@BYAPR15MB3383.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(346002)(376002)(39860400002)(189003)(199004)(76176011)(186003)(66476007)(8936002)(52116002)(81156014)(316002)(68736007)(66446008)(81166006)(486006)(99286004)(46003)(66946007)(73956011)(476003)(6512007)(54906003)(53936002)(9686003)(446003)(11346002)(4326008)(6916009)(2906002)(33656002)(14454004)(6246003)(64756008)(102836004)(386003)(6506007)(66556008)(25786009)(8676002)(305945005)(6116002)(6486002)(6436002)(14444005)(1076003)(5024004)(256004)(229853002)(71190400001)(478600001)(86362001)(71200400001)(5660300002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3383;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9PaTJpmAN6zLSfxmd2vc2fkTBRjZPdWjpmtA0lgHPDmHi3crdAgxfrYgu6KsEEJr2EmK8OolqAs4UlxyytHAmMhwkP27Dsak2/yN58s2adFY/E0hB2Gwhwn6nF9I7AwX/BasOKzEAybaplnb2PWXv/BulfTpTGjjQo6ompW5kWJh9BMLQR3Em+U5zcfJoNEaJcRlvp3Es+49zsaQYepMNr8Qz7UCHYAZFf9Ugn3F0n3cTICmPsE+WTox82CGEfRYXASYrZBDkR3nYNLf8KjPhxnedOAq4L8xrJ8J8Y49d2cz+uYMQ6/q41+jV88QrzBHTUyeIU+K/vRAG4ZcBeSbbxOp8Qp1/1qGP4P5JE3qgEkFo97k8HpkFLiz12WidGYF/jaY4M5RfcDQx/emoZsWEw+YcUrITVuqOT3ZW/q9KIw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E99262BF8C4F047A2BF72F52272A078@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b666cb-3337-4c8a-4af0-08d6e3a4cc8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 19:43:46.8060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3383
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=993 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 11:29:45AM -0700, Stanislav Fomichev wrote:
> Now that we don't have __rcu markers on the bpf_prog_array helpers,
> let's use proper rcu_dereference_protected to obtain array pointer
> under mutex.
>=20
> We also don't need __rcu annotations on cgroup_bpf.inactive since
> it's not read/updated concurrently.
>=20
> v3:
> * amend cgroup_rcu_dereference to include percpu_ref_is_dying;
>   cgroup_bpf is now reference counted and we don't hold cgroup_mutex
>   anymore in cgroup_bpf_release
>=20
> v2:
> * replace xchg with rcu_swap_protected
>=20
> Cc: Roman Gushchin <guro@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup.h |  2 +-
>  kernel/bpf/cgroup.c        | 32 +++++++++++++++++++++-----------
>  2 files changed, 22 insertions(+), 12 deletions(-)
>=20
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 9f100fc422c3..b631ee75762d 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -72,7 +72,7 @@ struct cgroup_bpf {
>  	u32 flags[MAX_BPF_ATTACH_TYPE];
> =20
>  	/* temp storage for effective prog array used by prog_attach/detach */
> -	struct bpf_prog_array __rcu *inactive;
> +	struct bpf_prog_array *inactive;
> =20
>  	/* reference counter used to detach bpf programs after cgroup removal *=
/
>  	struct percpu_ref refcnt;
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index d995edbe816d..118b70175dd9 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -22,6 +22,13 @@
>  DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
>  EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> =20
> +#define cgroup_rcu_dereference(cgrp, p)					\
> +	rcu_dereference_protected(p, lockdep_is_held(&cgroup_mutex) ||	\
> +				  percpu_ref_is_dying(&cgrp->bpf.refcnt))

Some comments why percpu_ref_is_dying(&cgrp->bpf.refcnt) is enough here wil=
l
be appreciated.

Thanks!
