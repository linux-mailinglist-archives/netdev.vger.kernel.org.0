Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12900145EDC
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgAVW6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:58:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47202 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgAVW6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:58:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MMuEuq021250;
        Wed, 22 Jan 2020 14:57:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Yc0x+9wSF9aIC8SKuqOk9glx+O1G//82ztKcdqXsjP8=;
 b=Xzz10rnsOssydQjweEDowmWEvRiht+39HpvrKOOmpMfIIoHZj6dA9Nd4vT3CuJJN/jJm
 dLnAmqplA40YS5o9NZgq6QWUkP92103eQL9mxixa8D+ZyTd9Yio9kwRcenZpu6NGa56E
 ZUJ46zofcAI/CiDEeK89PMSCYaaDpWMTvAI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpj9tknxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jan 2020 14:57:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 14:57:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXKqMLVSsaaosJGkecren/0Ut8Ot0TT4z+cChnQnpPLM7/lSSlzjGwldF08P1PJtqIXoVZSJM1fxfl18skt1dmvxRhQBAysPIL8/Vuum70oq4ZsrDYwzVf2Lw9uoZcJPbLbmVebSf/MDTSME4Yy02cVsCarVs16t+fgYbk5enhLJh7jm/iCK5IDdS6cWtU2nI/JKFrOq2Dz5Y1b9x4ifnOO8U7vs/3LGkTp6oKwvbjJgU5PmLaBSf/kPyS+kHlrwQ4Ao+FankqkoYDcjAAOMHByS/VI8bWNZLwQIa3tE7yWEWmOp0V3PttFKExx/R70R6MG8IvRmQ2NQLf4H8qeb+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc0x+9wSF9aIC8SKuqOk9glx+O1G//82ztKcdqXsjP8=;
 b=gw34onf3AvMaELIq979+782b4WusBe0pCmy2SCcUbh3R/wlYddiSrzgtApL4nCAcag3rJ7I8+34Zcyh3nKL7U4nmiz23UaPo3Q9w8YjltJS6jGoVqqRdacsBl1D8Dgssoip6RHlU5uZTwNL1YZd55D/zlmSXwFsfmxM5MdxFi11vA14o9Uydy4mqh9nccrgs5Ptlgu3VdPwFDTyYBBmmS0f4e6P6Oel1+sIYRg6UE4Mi4FMFozOl+rIZ3wClnUxVz/45Zyes7ll+MxTZJmIaq6vRX/5UJ4EHQgHhJncIJU3Abyza9gZhqanpS6na68pyypMshTO2rgoP91QdXNfYtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc0x+9wSF9aIC8SKuqOk9glx+O1G//82ztKcdqXsjP8=;
 b=h03Ya691hZ94GsNSYvdhJ61ML//+NdnMrjBZsFOXDYGiKjQ8v7PfVn86maUNy3DZa6QDiE72ElcYlu4vJz2WtTIYHx1FIQiXPkhcO9BH/nRnceqzVasr6K7JeMhvIr8NrOpu0JXrRyVBKMJho/WTqI2CbymQ58mSOjJEpiuQgT4=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3550.namprd15.prod.outlook.com (52.132.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 22:57:56 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 22:57:56 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::ccdf) by MWHPR20CA0002.namprd20.prod.outlook.com (2603:10b6:300:13d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.19 via Frontend Transport; Wed, 22 Jan 2020 22:57:54 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 02/12] net, sk_msg: Annotate lockless access
 to sk_prot on clone
Thread-Topic: [PATCH bpf-next v3 02/12] net, sk_msg: Annotate lockless access
 to sk_prot on clone
Thread-Index: AQHV0SSwIIWRmiPZ/0+yzfrBK7w/0qf3THYA
Date:   Wed, 22 Jan 2020 22:57:55 +0000
Message-ID: <20200122225752.caxnk5sylskbrzsg@kafai-mbp.dhcp.thefacebook.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
 <20200122130549.832236-3-jakub@cloudflare.com>
In-Reply-To: <20200122130549.832236-3-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0002.namprd20.prod.outlook.com
 (2603:10b6:300:13d::12) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ccdf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4bd565b-7530-4dee-5b84-08d79f8e84b7
x-ms-traffictypediagnostic: MN2PR15MB3550:
x-microsoft-antispam-prvs: <MN2PR15MB3550C4C784CA534BD4999E18D50C0@MN2PR15MB3550.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(136003)(39860400002)(376002)(199004)(189003)(8676002)(71200400001)(66946007)(2906002)(5660300002)(8936002)(55016002)(81156014)(81166006)(478600001)(316002)(7696005)(52116002)(1076003)(186003)(16526019)(86362001)(9686003)(6506007)(6916009)(4326008)(66446008)(64756008)(66476007)(54906003)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3550;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CMAMjQzkwMFMTmcEolObVVzliJQTq/cCENEXRf/OnWp3dSY03SAe6IsrP6m8RgyoBC4+H42x2KxmHhSGSRhL5dxPXanAFDj5rTIlJX3SF+Z+p0k0ysmNogA9p+/GY9lKzQBLHZYkjHjbMGanhYALzoLK39pNOaCCqnD6FYJeJsOMEx11uHETIch21llB4gt5H9bw12N2IQrxFdAxsnnd3KBX309ttngE0pUK2ifRt24ohfXqJnQY5e/EH7CKUITZg21sahcjCoPubeFTwUapa0wzQo3ZcISiaKYxNgqw8BaBJPJVjvFJuehjbTYItNbSvY4/ltf6Jtzr6K2rw/1xV63yioJ8Luc40euIWvBFcPE7fwv3MWV0H35nHW1OeDyLSpGaiqWGarmG7IMA2uY0qKKoYlaY5a7vTV2ZaISxak0XyOAxb2Qsoh4F3nBpZn4J
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <593C252AEE9B7B48AC5CD984AF61944C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d4bd565b-7530-4dee-5b84-08d79f8e84b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 22:57:55.9514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cpO61aD+v45WPNrDYDse53d0333E2UntElaqrVz5zwWyBFapodBF5ysRigfCqHcU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3550
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=695 bulkscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:05:39PM +0100, Jakub Sitnicki wrote:
> sk_msg and ULP frameworks override protocol callbacks pointer in
> sk->sk_prot, while tcp accesses it locklessly when cloning the listening
> socket, that is with neither sk_lock nor sk_callback_lock held.
>=20
> Once we enable use of listening sockets with sockmap (and hence sk_msg),
> there will be shared access to sk->sk_prot if socket is getting cloned
> while being inserted/deleted to/from the sockmap from another CPU:
>=20
> Read side:
>=20
> tcp_v4_rcv
>   sk =3D __inet_lookup_skb(...)
>   tcp_check_req(sk)
>     inet_csk(sk)->icsk_af_ops->syn_recv_sock
>       tcp_v4_syn_recv_sock
>         tcp_create_openreq_child
>           inet_csk_clone_lock
>             sk_clone_lock
>               READ_ONCE(sk->sk_prot)
>=20
> Write side:
>=20
> sock_map_ops->map_update_elem
>   sock_map_update_elem
>     sock_map_update_common
>       sock_map_link_no_progs
>         tcp_bpf_init
>           tcp_bpf_update_sk_prot
>             sk_psock_update_proto
>               WRITE_ONCE(sk->sk_prot, ops)
>=20
> sock_map_ops->map_delete_elem
>   sock_map_delete_elem
>     __sock_map_delete
>      sock_map_unref
>        sk_psock_put
>          sk_psock_drop
>            sk_psock_restore_proto
>              tcp_update_ulp
>                WRITE_ONCE(sk->sk_prot, proto)
>=20
> Mark the shared access with READ_ONCE/WRITE_ONCE annotations.
Acked-by: Martin KaFai Lau <kafai@fb.com>
