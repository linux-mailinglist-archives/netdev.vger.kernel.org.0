Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386FA2CF07
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfE1S6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:58:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35906 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfE1S6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:58:12 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SIrlju023554;
        Tue, 28 May 2019 11:57:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IJJo6LBOBCnDYQVk8QzPtXYgyaI8jKnak3Z5L0gW9Hk=;
 b=o3tb10ZBK2RsVH+xFJLR1vq/L8Ynfs/YSJBIN51+mbeNBGQkCg04EKaaTeiIRDoc+5gd
 WrBDhN5E93dzgC4mQrPC3hvEOkO3iRy/ISQX2NUaE2+Mwhot1Qts2Vu2txEtMcAnWDhj
 YNtCU7b0nwM41bXRJrNhrEJGfF56h/2qUOA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss90y0dqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 May 2019 11:57:48 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 11:57:48 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 28 May 2019 11:57:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJJo6LBOBCnDYQVk8QzPtXYgyaI8jKnak3Z5L0gW9Hk=;
 b=BfrwgxbHTHn7VoKLTySHaErHHd5kymTw/sDeDOVHkNOi5U7Q8BuwlDVh3hdcTIKiSOs3Q/u6LOYX4MpC+ot5XaErC9aOHmg8dB0DendEcsu9nh5btLxbC5p3iVTlXyVaQ0bD+DVh1JTdiGTOJDFVYCmWPzeF3lcOlrapWPW3TFI=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB3016.namprd15.prod.outlook.com (20.178.238.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Tue, 28 May 2019 18:57:45 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 18:57:45 +0000
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
Thread-Index: AQHVFYNuZOejCl/kQUWLljlEI/uGLKaA420A
Date:   Tue, 28 May 2019 18:57:45 +0000
Message-ID: <20190528185741.GB20578@tower.DHCP.thefacebook.com>
References: <20190528182946.3633-1-sdf@google.com>
 <20190528182946.3633-3-sdf@google.com>
In-Reply-To: <20190528182946.3633-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0069.namprd17.prod.outlook.com
 (2603:10b6:300:93::31) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3dca]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54e7c2ce-5f86-46e9-fb3e-08d6e39e5ebe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB3016;
x-ms-traffictypediagnostic: BYAPR15MB3016:
x-microsoft-antispam-prvs: <BYAPR15MB3016AB7BE349F1E21F3E5B62BE1E0@BYAPR15MB3016.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(366004)(396003)(199004)(189003)(99286004)(76176011)(52116002)(54906003)(316002)(6506007)(102836004)(68736007)(4326008)(14454004)(86362001)(478600001)(81156014)(81166006)(8676002)(25786009)(386003)(53936002)(6246003)(6916009)(229853002)(71200400001)(8936002)(5660300002)(186003)(66446008)(71190400001)(7736002)(305945005)(6512007)(9686003)(6116002)(2906002)(6436002)(64756008)(66946007)(66556008)(66476007)(73956011)(446003)(11346002)(46003)(486006)(476003)(1076003)(33656002)(14444005)(256004)(5024004)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3016;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Fmm8/HadnX8jFAYIT70sI1xTwJtbw8OivlIKYivvHi2f1b4HWBh9TtMgRACP8WKRK8DM09yt/PySkpSGIW8hrY20kR1CmqtIuRwZ4KGshKC+gJ5bPHaOOtvad7LvIXL8adGK43xUwtLe+hx98QbdWQYrb/y4+GvO2bJbDStTitfiJjBpTFArXUmcmkBRZd0/naN+Fe4V0/bWLO3NNZviUUOjnri/SdHpDlCJOe7npVMBFlA8BRceGa8U5uZ3E4pblkYM5McGyX5N8aaDZ0sE+hIpYIItVzzroAE63EYHQf43JXE+t1lc977rjJiW2nqlCGHsWDu6N75gtPp/lrvPY49f7Ua5U/z/uQFmiKWGc5GvCfdWnsRkWX3lqlRU2MQ/lBgoN1XgNxZjiXBidZ0tzzYEeTwGJ5segc4fcHhE8m8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <87EC26C469EA3F4C91E3EB0549D0992C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e7c2ce-5f86-46e9-fb3e-08d6e39e5ebe
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 18:57:45.6434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3016
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280118
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
> +
> +#define cgroup_rcu_swap(rcu_ptr, ptr)					\
> +	rcu_swap_protected(rcu_ptr, ptr, lockdep_is_held(&cgroup_mutex))
> +
>  void cgroup_bpf_offline(struct cgroup *cgrp)
>  {
>  	cgroup_get(cgrp);
> @@ -38,6 +45,7 @@ static void cgroup_bpf_release(struct work_struct *work=
)
>  	struct cgroup *cgrp =3D container_of(work, struct cgroup,
>  					   bpf.release_work);
>  	enum bpf_cgroup_storage_type stype;
> +	struct bpf_prog_array *old_array;
>  	unsigned int type;
> =20
>  	for (type =3D 0; type < ARRAY_SIZE(cgrp->bpf.progs); type++) {
> @@ -54,7 +62,9 @@ static void cgroup_bpf_release(struct work_struct *work=
)
>  			kfree(pl);
>  			static_branch_dec(&cgroup_bpf_enabled_key);
>  		}
> -		bpf_prog_array_free(cgrp->bpf.effective[type]);
> +		old_array =3D cgroup_rcu_dereference(cgrp,
> +						   cgrp->bpf.effective[type]);
> +		bpf_prog_array_free(old_array);
>  	}
> =20
>  	percpu_ref_exit(&cgrp->bpf.refcnt);
> @@ -126,7 +136,7 @@ static bool hierarchy_allows_attach(struct cgroup *cg=
rp,
>   */
>  static int compute_effective_progs(struct cgroup *cgrp,
>  				   enum bpf_attach_type type,
> -				   struct bpf_prog_array __rcu **array)
> +				   struct bpf_prog_array **array)
>  {
>  	enum bpf_cgroup_storage_type stype;
>  	struct bpf_prog_array *progs;
> @@ -164,17 +174,15 @@ static int compute_effective_progs(struct cgroup *c=
grp,
>  		}
>  	} while ((p =3D cgroup_parent(p)));
> =20
> -	rcu_assign_pointer(*array, progs);
> +	*array =3D progs;
>  	return 0;
>  }
> =20
>  static void activate_effective_progs(struct cgroup *cgrp,
>  				     enum bpf_attach_type type,
> -				     struct bpf_prog_array __rcu *array)
> +				     struct bpf_prog_array *old_array)
>  {
> -	struct bpf_prog_array __rcu *old_array;
> -
> -	old_array =3D xchg(&cgrp->bpf.effective[type], array);
> +	cgroup_rcu_swap(cgrp->bpf.effective[type], old_array);
>  	/* free prog array after grace period, since __cgroup_bpf_run_*()
>  	 * might be still walking the array
>  	 */
> @@ -191,7 +199,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
>   * that array below is variable length
>   */
>  #define	NR ARRAY_SIZE(cgrp->bpf.effective)
> -	struct bpf_prog_array __rcu *arrays[NR] =3D {};
> +	struct bpf_prog_array *arrays[NR] =3D {};
>  	int ret, i;
> =20
>  	ret =3D percpu_ref_init(&cgrp->bpf.refcnt, cgroup_bpf_release_fn, 0,
> @@ -477,10 +485,13 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const u=
nion bpf_attr *attr,
>  	enum bpf_attach_type type =3D attr->query.attach_type;
>  	struct list_head *progs =3D &cgrp->bpf.progs[type];
>  	u32 flags =3D cgrp->bpf.flags[type];
> +	struct bpf_prog_array *effective;
>  	int cnt, ret =3D 0, i;
> =20
> +	effective =3D cgroup_rcu_dereference(cgrp, cgrp->bpf.effective[type]);
> +
>  	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> -		cnt =3D bpf_prog_array_length(cgrp->bpf.effective[type]);
> +		cnt =3D bpf_prog_array_length(effective);
>  	else
>  		cnt =3D prog_list_length(progs);
> =20
> @@ -497,8 +508,7 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const uni=
on bpf_attr *attr,
>  	}
> =20
>  	if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> -		return bpf_prog_array_copy_to_user(cgrp->bpf.effective[type],
> -						   prog_ids, cnt);
> +		return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
>  	} else {
>  		struct bpf_prog_list *pl;
>  		u32 id;
> --=20
> 2.22.0.rc1.257.g3120a18244-goog
>=20

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
