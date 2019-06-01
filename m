Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1983211E
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 01:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFAXGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 19:06:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbfFAXGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 19:06:04 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x51N0wT4023811;
        Sat, 1 Jun 2019 16:06:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=B/7JPhpHhIjeIyR7PsTHUCrUo0IuCmvLSvSTz14BzVM=;
 b=Yqn3j/GhaM1A43JzCNswKhvLN5lY2xyABvQp0WsNcKsTuNxoUqAiUqSp48xKVIEkClwn
 YILL/sUsYymGnm7Ii685U/mn9SBlPZ+kjqWSI62LmDrs5p67VnF/MtF4RACyPrPYWBg8
 aQnBi1Pbe+zKNFlqiOz9+R9QVNqPSngsEw4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sunhk9dvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 01 Jun 2019 16:06:02 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 1 Jun 2019 16:06:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 1 Jun 2019 16:06:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/7JPhpHhIjeIyR7PsTHUCrUo0IuCmvLSvSTz14BzVM=;
 b=nVrYOks+vkea0EIEmNW4jDGinmPiZEQDkoOJwHkxqzyqiajIuVacVuyHUlpdMM7CZEZ0yi26lgQEalH1DVPsdEI5VzhKq8kBAMNGGHJgxCIJWHyiuEndOkk+nh8iaSAosk16teVyhfBrgzNtdmYUls30iLE9rBeSfViDSB5SM2I=
Received: from BN6PR15MB1154.namprd15.prod.outlook.com (10.172.208.137) by
 BN6PR15MB1332.namprd15.prod.outlook.com (10.172.206.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Sat, 1 Jun 2019 23:05:58 +0000
Received: from BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd]) by BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd%2]) with mapi id 15.20.1922.021; Sat, 1 Jun 2019
 23:05:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [PATCH v3 bpf-next 2/2] libbpf: remove qidconf and better support
 external bpf programs.
Thread-Topic: [PATCH v3 bpf-next 2/2] libbpf: remove qidconf and better
 support external bpf programs.
Thread-Index: AQHVF+KsuNMMv38RaEuJ4ZgVEhrKwqaHbV6A
Date:   Sat, 1 Jun 2019 23:05:58 +0000
Message-ID: <02CA9EF5-1380-4FE0-9479-C619C1792C2E@fb.com>
References: <20190531185705.2629959-1-jonathan.lemon@gmail.com>
 <20190531185705.2629959-3-jonathan.lemon@gmail.com>
In-Reply-To: <20190531185705.2629959-3-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::6be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 448447dc-afdc-4658-d5bf-08d6e6e5b564
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR15MB1332;
x-ms-traffictypediagnostic: BN6PR15MB1332:
x-microsoft-antispam-prvs: <BN6PR15MB1332B06D6749506E12DF9E5BB31A0@BN6PR15MB1332.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(376002)(346002)(396003)(199004)(189003)(486006)(2616005)(476003)(82746002)(6436002)(53936002)(6116002)(305945005)(36756003)(68736007)(6512007)(4326008)(2906002)(7736002)(11346002)(5660300002)(57306001)(8936002)(25786009)(54906003)(316002)(33656002)(8676002)(81156014)(81166006)(66946007)(6486002)(50226002)(446003)(6246003)(91956017)(76116006)(66446008)(64756008)(66556008)(66476007)(73956011)(46003)(6916009)(229853002)(99286004)(14444005)(256004)(53546011)(6506007)(86362001)(83716004)(102836004)(478600001)(71200400001)(71190400001)(186003)(76176011)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR15MB1332;H:BN6PR15MB1154.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sExcIq3h9VIfiJpStyC8IZ0CBtv1x8InF68pk5Lo7i71IlEbdniwptsDpKZXV0e/GJ5De2v+8M+k91QMp5uxwZ6PBXq1pY5AgIc0MY6tcEydwuqHzmL23sQHRWdYEZEnWMmjYeGlXwZ+zRyG5RVPhCiDMQckouC6Xkgw4QCvl4I7iir5lV6TYz6B0TRgqM1YbFXrMsMfJ/cu8htcjhi/7h2Ilhq9OJLullH1YO5zk353hCjYvUpU6erCPcJ3WZwLK20xLSlQijjEeYoLf0V61DgEnILrGMVppt193GwUM8xnuZvMbqDDg9Mc4BY5SmkMIDuCwyHSJxM4edLgf7zfde1wsw8peiQqAhxGGOIYATpJthDRhSLVMrninxuAxWKOMoerRpBzTYTfRIjwlwk3JwMbXOiHiGpxCTyZm4iIPHA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EE7953A85AE51E4C9C5675530D7B6EA1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 448447dc-afdc-4658-d5bf-08d6e6e5b564
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2019 23:05:58.2615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1332
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906010166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 31, 2019, at 11:57 AM, Jonathan Lemon <jonathan.lemon@gmail.com> w=
rote:
>=20
> Use the recent change to XSKMAP bpf_map_lookup_elem() to test if
> there is a xsk present in the map instead of duplicating the work
> with qidconf.
>=20
> Fix things so callers using XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD
> bypass any internal bpf maps, so xsk_socket__{create|delete} works
> properly.
>=20
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
> tools/lib/bpf/xsk.c | 79 +++++++++------------------------------------
> 1 file changed, 16 insertions(+), 63 deletions(-)
>=20
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 38667b62f1fe..7ce7494b5b50 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -60,10 +60,8 @@ struct xsk_socket {
> 	struct xsk_umem *umem;
> 	struct xsk_socket_config config;
> 	int fd;
> -	int xsks_map;
> 	int ifindex;
> 	int prog_fd;
> -	int qidconf_map_fd;
> 	int xsks_map_fd;
> 	__u32 queue_id;
> 	char ifname[IFNAMSIZ];
> @@ -265,15 +263,11 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk=
)
> 	/* This is the C-program:
> 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> 	 * {
> -	 *     int *qidconf, index =3D ctx->rx_queue_index;
> +	 *     int index =3D ctx->rx_queue_index;
> 	 *
> 	 *     // A set entry here means that the correspnding queue_id
> 	 *     // has an active AF_XDP socket bound to it.
> -	 *     qidconf =3D bpf_map_lookup_elem(&qidconf_map, &index);
> -	 *     if (!qidconf)
> -	 *         return XDP_ABORTED;
> -	 *
> -	 *     if (*qidconf)
> +	 *     if (bpf_map_lookup_elem(&xsks_map, &index))
> 	 *         return bpf_redirect_map(&xsks_map, index, 0);
> 	 *
> 	 *     return XDP_PASS;
> @@ -286,15 +280,10 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk=
)
> 		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
> 		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
> -		BPF_LD_MAP_FD(BPF_REG_1, xsk->qidconf_map_fd),
> +		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
> 		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> 		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> -		BPF_MOV32_IMM(BPF_REG_0, 0),
> -		/* if r1 =3D=3D 0 goto +8 */
> -		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 8),
> 		BPF_MOV32_IMM(BPF_REG_0, 2),
> -		/* r1 =3D *(u32 *)(r1 + 0) */
> -		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
> 		/* if r1 =3D=3D 0 goto +5 */
> 		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
> 		/* r2 =3D *(u32 *)(r10 - 4) */
> @@ -366,18 +355,11 @@ static int xsk_create_bpf_maps(struct xsk_socket *x=
sk)
> 	if (max_queues < 0)
> 		return max_queues;
>=20
> -	fd =3D bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "qidconf_map",
> +	fd =3D bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
> 				 sizeof(int), sizeof(int), max_queues, 0);
> 	if (fd < 0)
> 		return fd;
> -	xsk->qidconf_map_fd =3D fd;
>=20
> -	fd =3D bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
> -				 sizeof(int), sizeof(int), max_queues, 0);
> -	if (fd < 0) {
> -		close(xsk->qidconf_map_fd);
> -		return fd;
> -	}
> 	xsk->xsks_map_fd =3D fd;
>=20
> 	return 0;
> @@ -385,10 +367,8 @@ static int xsk_create_bpf_maps(struct xsk_socket *xs=
k)
>=20
> static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
> {
> -	close(xsk->qidconf_map_fd);
> +	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
> 	close(xsk->xsks_map_fd);
> -	xsk->qidconf_map_fd =3D -1;
> -	xsk->xsks_map_fd =3D -1;
> }
>=20
> static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
> @@ -417,10 +397,9 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xs=
k)
> 	if (err)
> 		goto out_map_ids;
>=20
> -	for (i =3D 0; i < prog_info.nr_map_ids; i++) {
> -		if (xsk->qidconf_map_fd !=3D -1 && xsk->xsks_map_fd !=3D -1)
> -			break;
> +	xsk->xsks_map_fd =3D -1;
>=20
> +	for (i =3D 0; i < prog_info.nr_map_ids; i++) {
> 		fd =3D bpf_map_get_fd_by_id(map_ids[i]);
> 		if (fd < 0)
> 			continue;
> @@ -431,11 +410,6 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xs=
k)
> 			continue;
> 		}
>=20
> -		if (!strcmp(map_info.name, "qidconf_map")) {
> -			xsk->qidconf_map_fd =3D fd;
> -			continue;
> -		}
> -
> 		if (!strcmp(map_info.name, "xsks_map")) {
> 			xsk->xsks_map_fd =3D fd;
> 			continue;
> @@ -445,40 +419,18 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *x=
sk)
> 	}
>=20
> 	err =3D 0;
> -	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
> +	if (xsk->xsks_map_fd =3D=3D -1)
> 		err =3D -ENOENT;
> -		xsk_delete_bpf_maps(xsk);
> -	}
>=20
> out_map_ids:
> 	free(map_ids);
> 	return err;
> }
>=20
> -static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
> -{
> -	int qid =3D false;
> -
> -	bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
> -	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
> -}
> -
> static int xsk_set_bpf_maps(struct xsk_socket *xsk)
> {
> -	int qid =3D true, fd =3D xsk->fd, err;
> -
> -	err =3D bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, =
0);
> -	if (err)
> -		goto out;
> -
> -	err =3D bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id, &fd, 0);
> -	if (err)
> -		goto out;
> -
> -	return 0;
> -out:
> -	xsk_clear_bpf_maps(xsk);
> -	return err;
> +	return bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id,
> +				   &xsk->fd, 0);
> }
>=20
> static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> @@ -514,6 +466,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>=20
> out_load:
> 	close(xsk->prog_fd);
> +	xsk->prog_fd =3D -1;

I found xsk->prog_fd confusing. Why do we need to set it here?=20

I think we don't need to call xsk_delete_bpf_maps() in out_load path?=20

> out_maps:
> 	xsk_delete_bpf_maps(xsk);
> 	return err;
> @@ -643,9 +596,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, c=
onst char *ifname,
> 		goto out_mmap_tx;
> 	}
>=20
> -	xsk->qidconf_map_fd =3D -1;
> -	xsk->xsks_map_fd =3D -1;
> -
> +	xsk->prog_fd =3D -1;
> 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> 		err =3D xsk_setup_xdp_prog(xsk);
> 		if (err)
> @@ -708,8 +659,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> 	if (!xsk)
> 		return;
>=20
> -	xsk_clear_bpf_maps(xsk);
> -	xsk_delete_bpf_maps(xsk);
> +	if (xsk->prog_fd !=3D -1) {
> +		xsk_delete_bpf_maps(xsk);
> +		close(xsk->prog_fd);

Here, we use prog_fd !=3D -1 to gate xsk_delete_bpf_maps(), which is=20
confusing. I looked at the code for quite sometime, but still cannot=20
confirm it is correct.=20

Thanks,
Song

> +	}
>=20
> 	optlen =3D sizeof(off);
> 	err =3D getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
> --=20
> 2.17.1
>=20

