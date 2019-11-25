Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E5F10958B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfKYWiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:38:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36350 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbfKYWiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:38:55 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPMbjc0000822;
        Mon, 25 Nov 2019 14:38:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EwR9kULbYe9yTSXO2gvOneMBimYAfBo/RpRjxGqd29c=;
 b=jT6VGvd5rmU0bfA0tQuo9m1yr9Lcsd+g1FurvbmKBO++XFfxFRwtBhMDqwKO/GfGwOuD
 N774O/TnYwPZgJjgaWAVdtk0oi43GtyFa1K5sGx0ryDams6vpV8nb0ORMRUlFB7M2AJ5
 +j+wHjrUmeT7xkqgRCfvSYNJkBCyxkO4qjA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wfnbg0hjn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 14:38:52 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 25 Nov 2019 14:38:50 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 25 Nov 2019 14:38:50 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 25 Nov 2019 14:38:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUgPI/JkPKJ87+XXVbAbHZRgZVcaT2eeJ7yqts36SzaHoyDPdjSIZepNwtOwPHL6EqzSRBR07mRW+4sO1BHjwp63NMdD5DUTs+cpUBIw+gX+PTZc/tC+v/eCx0bedwakvc1+rBkjAZud+E+tcdc8pC71OoLHN7Htz4cXJk+iYdZHrbudVDoT5NR5qzzeAYJPnwGQYnq5sYKYqGYctWKCt2ipF+ECI4yzrpoeDRn0loQVYREdKaz7Q9RkQYvL7IkfLq2NeZ5SB7Wlb8TnirzvI95krNKLmsz/0e1Wnc7Wsx3gySu5dMfI0JANIg1qiS5n7C8UbxlTnxtESEKCC5rTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwR9kULbYe9yTSXO2gvOneMBimYAfBo/RpRjxGqd29c=;
 b=CXNbmCR/ThgYGmOvojiZv5RiuIV9c8i2N7LbDGRiNlkKQobSPG2/6RswtbWvyYLE7iZS2JcgklB/U6USLO/p7pI7x0TreNPgmsqaIuBuqlodd565OMFgcA+aZYDveoPG2cUA4ksWte9GnNO+q+9Am41m/GmJH+QH8Mbwu48X53/bSW5h2UMmIygJL4JPjtE9BalC53mA7i2fiPEVoPWMI3Q5f5/2BWdm4E+5v8hNbM5NRnu/qzqev8V/YyF1m+EEuuf4VyP4UpDkYmh5NWgM60jw1eajM/GzigIppMPjJBa6cRXp7U3U3/U77pjz/XX13R+Gg9HuTwnQXT0QcHxkfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwR9kULbYe9yTSXO2gvOneMBimYAfBo/RpRjxGqd29c=;
 b=MemP+4NRqK6LRHdeKO9fZMpoyCW/0dn9IHHZXlEfnGu7lFsnWHttGKh4RqZVHO/W6o1jTOfBz1/Ye9b15o0vow5gFi3cKgZIer8tO1EoLhGXwigLiNPm8i2oB7087DKqNkTgPhH1P6/bN3/5W54DEHE0H5V169R6ayf/b1q/RTg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3103.namprd15.prod.outlook.com (20.178.254.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Mon, 25 Nov 2019 22:38:49 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 22:38:49 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit
 psock or its ops on copy
Thread-Topic: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket
 inherit psock or its ops on copy
Thread-Index: AQHVoe5KSzr7pEIvm0S4q82BeKmlVKecflSA
Date:   Mon, 25 Nov 2019 22:38:49 +0000
Message-ID: <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-5-jakub@cloudflare.com>
In-Reply-To: <20191123110751.6729-5-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0079.namprd07.prod.outlook.com (2603:10b6:100::47)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:c9b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c3d616c-aa08-4d3a-9eff-08d771f83d3a
x-ms-traffictypediagnostic: MN2PR15MB3103:
x-microsoft-antispam-prvs: <MN2PR15MB3103EA1CF26DAB830816F57BD54A0@MN2PR15MB3103.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(346002)(376002)(396003)(366004)(136003)(189003)(199004)(386003)(2906002)(66476007)(66556008)(76176011)(6916009)(316002)(8936002)(81166006)(4326008)(81156014)(5660300002)(25786009)(305945005)(6436002)(64756008)(52116002)(229853002)(66946007)(86362001)(8676002)(14454004)(6116002)(102836004)(14444005)(6512007)(9686003)(33716001)(11346002)(6506007)(478600001)(46003)(71190400001)(54906003)(1076003)(186003)(6246003)(99286004)(256004)(6486002)(446003)(7736002)(71200400001)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3103;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?yMbXvxeDyQgtEmhlT3Y76qBFF+Ep0ly3D/ZypelAsHz3Vbj002F2wMqhdplf?=
 =?us-ascii?Q?8yxSKx4Hp8DVGWL0+7d3q5E5t0VEaC00TtKBb9YCho2dyFEwZT0pqX6+ihak?=
 =?us-ascii?Q?fKLbixf8Hm9CulzvDO+ZlupCrxC+ZlDbOo7eOGT4AtQU2lADD+wl0cyMnAkA?=
 =?us-ascii?Q?jKpUrv41DreXqUH2WYe2G/FOv2vjsIagsIHWxn4jp54R/T8lkY2+Im49nnZH?=
 =?us-ascii?Q?diTJnBzT6C6qvAsiiUoeoG1xHBpkRKgT3nIhf0aRq0M+Bngc+Wdbg6Oe2vJq?=
 =?us-ascii?Q?JRlX32QEdr+HZaF5TnCNkAJFIoC3toSGzV6+x1CAq/bac9gjXDBqt5KoRF8Q?=
 =?us-ascii?Q?DqIZae/i57i8vFE2ptuxTZkVozf1JH2DCgzNtbLQP4Qq4V9DaePAYVpNAwqj?=
 =?us-ascii?Q?jpdFkPPp5+TnCKJkHckinJkPDawG4Vt3U2LbSzsaam39WbFKwF3vM7Yiyw5E?=
 =?us-ascii?Q?bKX8jGaU5Io/c3aRQhlh9LQxXyUpJmUQ7NhG/GWL4CAqDdfEdXe1QioDnf6W?=
 =?us-ascii?Q?B0RKBeblL/9uiszsSMuW4pZyNATWU0ei2R/pZPbtKguPksMskcyarkoNBDtm?=
 =?us-ascii?Q?AMyFgFr3o/0oJwPutZvJYcPC5qwgcJB36X9XjfbBWULwpyBIsH6e1JpLRsxN?=
 =?us-ascii?Q?LLkEgE5DsYHiF4OdSlX0zhgrPLTZEV2l+szBYZyGCrI10liWhItXg0w6tvYc?=
 =?us-ascii?Q?RQbQVQFkMDBH5QJdVbYVbYWvnmDlBr0XI1ausd85vmCVKpPjzwD6cKE11XnI?=
 =?us-ascii?Q?9py7o3UR8HqoA7Z+uuXvAbMSjtUbxxgrOJTsm+o0QG2XIx9XKRsfpr5gaqT0?=
 =?us-ascii?Q?LFxPl72uTHkKQmdkhLYT9+NkDYPov+6edjc/kgV0TOo8WPOKxSHPy4PuvcHr?=
 =?us-ascii?Q?btwomDw03PAiytfgvT7F1TVu8A58bWVgzIcqVTl/Tq4Ls23H5p//BO0YmUh6?=
 =?us-ascii?Q?58NXCqird9ltXwY6kyMT+86gVMxGbSu48RJBM3CW3gSuSLUX/fr5xXofwKl3?=
 =?us-ascii?Q?0C9quTWVbZKLauNVb/kMqsWIcCUR++aTjhDR8h15qrgm35/QUHZUA+U2yktR?=
 =?us-ascii?Q?DM2HM7v3vg6zkVMZdVeQSJF9aMShT+3/5Y1SjUP42Y8pWWhOCiq2Ee6rQPZw?=
 =?us-ascii?Q?HLHYkbqsu9k2w1O5HAijr2KWJ/9HyIuB4DNUp9Kmq2kE7a18hvTepD7Jb/Ku?=
 =?us-ascii?Q?FeZivFsEAmb1Mg8FHdMB+sVxXu2K4odnbyDh+WrhRsxQlsMZTO6FB+vTgamh?=
 =?us-ascii?Q?BidSLhy+lWZVWr7pWiWvNPwg/+HFUzCp/vtJeAIoLg38A7/3kIUO+qhZO6Er?=
 =?us-ascii?Q?aSTOt1lCBzjwF7qhM8k45dfYfylGlTlXUQFi1RU11U+EJ557B1HgDv73DeUu?=
 =?us-ascii?Q?fVUbbatocRSm61M9QU9nHZ5vYARUt2nGhGIwZ3y1QHdibD7a8A4Y5US6sGce?=
 =?us-ascii?Q?d3Hg/dYiEUbH9C5yemnQ7kRqemdrCByddGTavaz7TnCyiOrtV/CfL/objkUp?=
 =?us-ascii?Q?IASZ7WPZKFUYdLkWKSeWwINiCXPE1xW+1RToP5e0M3+xysurRZ3z1GeqUYDA?=
 =?us-ascii?Q?fMWawuK1ug1qR9h62lg7CkfxjMY7r7LxvoVvY0myl5d+u4vph3Mm5NBz8L/V?=
 =?us-ascii?Q?rDlFl2vUh+OajSUgKBvn7QjPa8XjPpxsig9KvHUDjv9CIkAJJF8u51c9A4q6?=
 =?us-ascii?Q?LqcQJA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B44D8C4CB1B04A46928859D80F388773@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3d616c-aa08-4d3a-9eff-08d771f83d3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 22:38:49.1753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DTry+c1H9GGSiM14xguSYKJ7Yqs1A5degVKo76sggMptgoxvoQjmBt3nOfQCwQG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3103
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_06:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 mlxlogscore=508
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911250177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
[ ... ]

> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct soc=
k *sk,
>  			sk->sk_prot =3D psock->sk_proto;
>  		psock->sk_proto =3D NULL;
>  	}
> +
> +	if (psock->icsk_af_ops) {
> +		icsk->icsk_af_ops =3D psock->icsk_af_ops;
> +		psock->icsk_af_ops =3D NULL;
> +	}
>  }

[ ... ]

> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
> +					  struct sk_buff *skb,
> +					  struct request_sock *req,
> +					  struct dst_entry *dst,
> +					  struct request_sock *req_unhash,
> +					  bool *own_req)
> +{
> +	const struct inet_connection_sock_af_ops *ops;
> +	void (*write_space)(struct sock *sk);
> +	struct sk_psock *psock;
> +	struct proto *proto;
> +	struct sock *child;
> +
> +	rcu_read_lock();
> +	psock =3D sk_psock(sk);
> +	if (likely(psock)) {
> +		proto =3D psock->sk_proto;
> +		write_space =3D psock->saved_write_space;
> +		ops =3D psock->icsk_af_ops;
It is not immediately clear to me what ensure
ops is not NULL here.

It is likely I missed something.  A short comment would
be very useful here.

> +	} else {
> +		ops =3D inet_csk(sk)->icsk_af_ops;
> +	}
> +	rcu_read_unlock();
> +
> +	child =3D ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
> +
> +	/* Child must not inherit psock or its ops. */
> +	if (child && psock) {
> +		rcu_assign_sk_user_data(child, NULL);
> +		child->sk_prot =3D proto;
> +		child->sk_write_space =3D write_space;
> +
> +		/* v4-mapped sockets don't inherit parent ops. Don't restore. */
> +		if (inet_csk(child)->icsk_af_ops =3D=3D inet_csk(sk)->icsk_af_ops)
> +			inet_csk(child)->icsk_af_ops =3D ops;
> +	}
> +	return child;
> +}
> +
>  enum {
>  	TCP_BPF_IPV4,
>  	TCP_BPF_IPV6,
> @@ -597,6 +642,7 @@ enum {
>  static struct proto *tcpv6_prot_saved __read_mostly;
>  static DEFINE_SPINLOCK(tcpv6_prot_lock);
>  static struct proto tcp_bpf_prots[TCP_BPF_NUM_PROTS][TCP_BPF_NUM_CFGS];
> +static struct inet_connection_sock_af_ops tcp_bpf_af_ops[TCP_BPF_NUM_PRO=
TS];
> =20
>  static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
>  				   struct proto *base)
> @@ -612,13 +658,23 @@ static void tcp_bpf_rebuild_protos(struct proto pro=
t[TCP_BPF_NUM_CFGS],
>  	prot[TCP_BPF_TX].sendpage		=3D tcp_bpf_sendpage;
>  }
> =20
> -static void tcp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto=
 *ops)
> +static void tcp_bpf_rebuild_af_ops(struct inet_connection_sock_af_ops *o=
ps,
> +				   const struct inet_connection_sock_af_ops *base)
> +{
> +	*ops =3D *base;
> +	ops->syn_recv_sock =3D tcp_bpf_syn_recv_sock;
> +}
> +
> +static void tcp_bpf_check_v6_needs_rebuild(struct sock *sk, struct proto=
 *ops,
> +					   const struct inet_connection_sock_af_ops *af_ops)
>  {
>  	if (sk->sk_family =3D=3D AF_INET6 &&
>  	    unlikely(ops !=3D smp_load_acquire(&tcpv6_prot_saved))) {
>  		spin_lock_bh(&tcpv6_prot_lock);
>  		if (likely(ops !=3D tcpv6_prot_saved)) {
>  			tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV6], ops);
> +			tcp_bpf_rebuild_af_ops(&tcp_bpf_af_ops[TCP_BPF_IPV6],
> +					       af_ops);
>  			smp_store_release(&tcpv6_prot_saved, ops);
>  		}
>  		spin_unlock_bh(&tcpv6_prot_lock);
> @@ -628,6 +684,8 @@ static void tcp_bpf_check_v6_needs_rebuild(struct soc=
k *sk, struct proto *ops)
>  static int __init tcp_bpf_v4_build_proto(void)
>  {
>  	tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV4], &tcp_prot);
> +	tcp_bpf_rebuild_af_ops(&tcp_bpf_af_ops[TCP_BPF_IPV4], &ipv4_specific);
> +
>  	return 0;
>  }
>  core_initcall(tcp_bpf_v4_build_proto);
> @@ -637,7 +695,8 @@ static void tcp_bpf_update_sk_prot(struct sock *sk, s=
truct sk_psock *psock)
>  	int family =3D sk->sk_family =3D=3D AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_I=
PV4;
>  	int config =3D psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
> =20
> -	sk_psock_update_proto(sk, psock, &tcp_bpf_prots[family][config]);
> +	sk_psock_update_proto(sk, psock, &tcp_bpf_prots[family][config],
> +			      &tcp_bpf_af_ops[family]);
>  }
> =20
>  static void tcp_bpf_reinit_sk_prot(struct sock *sk, struct sk_psock *pso=
ck)
> @@ -677,6 +736,7 @@ void tcp_bpf_reinit(struct sock *sk)
> =20
>  int tcp_bpf_init(struct sock *sk)
>  {
> +	struct inet_connection_sock *icsk =3D inet_csk(sk);
>  	struct proto *ops =3D READ_ONCE(sk->sk_prot);
>  	struct sk_psock *psock;
> =20
> @@ -689,7 +749,7 @@ int tcp_bpf_init(struct sock *sk)
>  		rcu_read_unlock();
>  		return -EINVAL;
>  	}
> -	tcp_bpf_check_v6_needs_rebuild(sk, ops);
> +	tcp_bpf_check_v6_needs_rebuild(sk, ops, icsk->icsk_af_ops);
>  	tcp_bpf_update_sk_prot(sk, psock);
>  	rcu_read_unlock();
>  	return 0;
> --=20
> 2.20.1
>=20
