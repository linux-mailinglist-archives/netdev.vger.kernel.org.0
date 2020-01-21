Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8861446C6
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 23:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgAUWBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 17:01:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727847AbgAUWBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 17:01:10 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00LM0LAu010410;
        Tue, 21 Jan 2020 14:00:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BhgMeg4v0+wTjX9iErsBFlmjUePxruA26uSd+vltNVQ=;
 b=GQn7fTK0gnzZHNOleRThGhMPKz5JC+wvCCHh37mcKiWQuoyOM2qMWQJCQuX2t7hBSFg5
 aKtb/AIztaWJENtTcYKnqJEFTG4/nMybEjgwUjqxt4hmfp+LXa3N82AbpGcrZNYs0/Sv
 Z3QO0wZWJWPJL5LLSi/Okx3JCSRb7+d/p1E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 2xp8jc0arh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Jan 2020 14:00:48 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 14:00:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjQjX2GOfDfwlggldge60kiZ/h5EOQBym37V80WfLoV6q/Hv11TneZQO/mVrgGPNN+EoVBsxlgL7tPHae5xR60Zy+RAfUNPJvpPwfa3sl6zW7sv+uHXPH11Lof+IilsajiOC5BSrSBsjGLgl2V+84WbEi0f437u76zYjPajt1VR5ORcoxCJF0YCcUPTi8DCtp2Hdpxg+/AcEUKLEF7EH5SeLZzWRNcjFNlvb81wwNOTKt79QdFLl+A5qmFiHN6jnfaJ9pf2hknd/gGbqqF+RDRpHuLxLluROhBuObBAl7z0gXuDSEyVckhHMTW1Ea0zWxasuep4dwwJEzYwWM0ev2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhgMeg4v0+wTjX9iErsBFlmjUePxruA26uSd+vltNVQ=;
 b=jM+Y7LALVkYYAwfPPE6CJ8JZOOx4xvn9saSE+ro6sU9hWKvm6lRqxhf0ZkBfstS1gOntlT1aO29Psca2pX9nYlvMRbIvy7Pn+jysBs9mEN2hV62Dk4AU+SFssDFRf67S3QF+kF4ofSJIMgqDQsMED76S7nl1Yy9KJDm5vii13wOmCZKKmn/7230o0wUhURKKTg6kAPR+rGwxnDeYacm1XvxjA5VIkJI9CQ8Ud8ZbRpt3jL8LuQBQeFL+85TjmFSuaHhPXHyLhuPWTgab0qaRchlFDT7FdqW5HCT7rRGqHdqlIYwPCMWpx4aLhzoKTxPz+Ho+8uux/pRk3M9sOwykRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhgMeg4v0+wTjX9iErsBFlmjUePxruA26uSd+vltNVQ=;
 b=KjpoGXa+eDjW8a0x0H7fWV2QagJY5QfJ3zRZsasRg0OqKdKLsOrsyrPd8rc+BylU77UCLLgz0KGBxdSxGjjsDWQ1mrAOKBmGn9l5saFYBYXNLhFpC+LAoBs9A4WG21RdV4c3HCqG2kn3ij9FXv8rtv87cgjELXh1+jDcYqFfhjU=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2701.namprd15.prod.outlook.com (20.179.146.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Tue, 21 Jan 2020 22:00:25 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.026; Tue, 21 Jan 2020
 22:00:25 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::aa6d) by MWHPR1201CA0013.namprd12.prod.outlook.com (2603:10b6:301:4a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Tue, 21 Jan 2020 22:00:23 +0000
From:   Martin Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/3] bpf: tcp: Add bpf_cubic example
Thread-Topic: [PATCH bpf-next 3/3] bpf: tcp: Add bpf_cubic example
Thread-Index: AQHV0JkG/xAOEG2KskiDKxfoUGoCoaf1qyYA
Date:   Tue, 21 Jan 2020 22:00:25 +0000
Message-ID: <20200121220020.mg6iekrxywnh2nhq@kafai-mbp.dhcp.thefacebook.com>
References: <20200121195408.3756734-1-kafai@fb.com>
 <20200121195427.3758504-1-kafai@fb.com>
 <7b8770e1-6cac-2e67-fb79-2feb2a35a0e5@gmail.com>
In-Reply-To: <7b8770e1-6cac-2e67-fb79-2feb2a35a0e5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0013.namprd12.prod.outlook.com
 (2603:10b6:301:4a::23) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::aa6d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abc35d6e-e41a-4d0f-83e9-08d79ebd5171
x-ms-traffictypediagnostic: MN2PR15MB2701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2701D126716C46136CE18753D50D0@MN2PR15MB2701.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(366004)(136003)(39860400002)(199004)(189003)(7696005)(66446008)(66556008)(71200400001)(66946007)(5660300002)(1076003)(64756008)(66476007)(6916009)(52116002)(8676002)(478600001)(8936002)(81156014)(6506007)(53546011)(316002)(54906003)(16526019)(186003)(86362001)(55016002)(2906002)(4326008)(9686003)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2701;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m1loqsIQP6y1UNhXUDd1DqbHOWKZ/dhftGfLqNij1u2/uPB1OI43eio5j+GcQfpgBWGBQ6yyWAd/ReJF081mlA0uBdYBnUMCXDFRDK3NKqu2YEp4qpj91NT3kRHT9tke7A1kYvfQTWC5TKEyNNr8isHl7HUaGFUL9m3kEL676YBqzGfu2HXoDIloyNAgNesI4bfAeDIec6M1MCM8opMPFbNC67iLXSQhh82+wZHilL52f4vE1T6tNUh4OW1maFjyLPAdsCrr8f368uW2LsMkwTftlNZssbBANiAenewBgklg4RsJOQOA8qcUGziDUgUJnItkhJze1imcYVtIk9sdtiZPztWffjNz5dJLCuQlyrAx5gI9e80nH/se9sZetAsnvxTJnPgUWyAWsF/vRbl/OjpqQUOTS5k8qXLdnboiF+KfS2e6+Gj+QEtoFX7fjNm6
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E520787BC097DE4ABA02F66AC4177943@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: abc35d6e-e41a-4d0f-83e9-08d79ebd5171
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 22:00:25.3213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bdAXHHV6A64jgPDIvlqr8q7gZX/SCtx9+EHkM+/KE0ge4w+i0BSK1cWfQDAEyWl+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2701
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 12:26:07PM -0800, Eric Dumazet wrote:
>=20
>=20
> On 1/21/20 11:54 AM, Martin KaFai Lau wrote:
> > This patch adds a bpf_cubic example.  Some highlights:
> > 1. CONFIG_HZ kconfig is used.  For example, CONFIG_HZ is used in the us=
ecs
> >    to jiffies conversion in usecs_to_jiffies().
> > 2. In bitctcp_update() [under tcp_friendliness], the original
> >    "while (ca->ack_cnt > delta)" loop is changed to the equivalent
> >    "ca->ack_cnt / delta" operation
>=20
>=20
> ...
>=20
> > +	/* cubic function - calc*/
> > +	/* calculate c * time^3 / rtt,
> > +	 *  while considering overflow in calculation of time^3
> > +	 * (so time^3 is done by using 64 bit)
> > +	 * and without the support of division of 64bit numbers
> > +	 * (so all divisions are done by using 32 bit)
> > +	 *  also NOTE the unit of those veriables
> > +	 *	  time  =3D (t - K) / 2^bictcp_HZ
> > +	 *	  c =3D bic_scale >> 10
> > +	 * rtt  =3D (srtt >> 3) / HZ
> > +	 * !!! The following code does not have overflow problems,
> > +	 * if the cwnd < 1 million packets !!!
> > +	 */
> > +
> > +	t =3D (__s32)(tcp_jiffies32 - ca->epoch_start);
> > +	t +=3D usecs_to_jiffies(ca->delay_min);
> > +	/* change the unit from HZ to bictcp_HZ */
> > +	t <<=3D BICTCP_HZ;
> > +	t /=3D HZ;
> >
>=20
> Note that this part could use usec resolution instead of jiffies
> to avoid all these inlines for {u|n}secs_to_jiffies()=20
>=20
> 	t =3D (__s32)(tcp_jiffies32 - ca->epoch_start) * (USEC_PER_JIFFY);
> 	t +=3D ca->delay_min;
> 	/* change the unit from usec to bictcp_HZ */
> 	t <<=3D BICTCP_HZ;
> 	t /=3D USEC_PER_SEC;
>=20
> ie :
>=20
> diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
> index 8f8eefd3a3ce116aa8fa2b7ef85c7eb503fa8da7..9ba58e95dbe6b15098bcfd045=
e1d0bb8874d713f 100644
> --- a/net/ipv4/tcp_cubic.c
> +++ b/net/ipv4/tcp_cubic.c
> @@ -271,11 +271,11 @@ static inline void bictcp_update(struct bictcp *ca,=
 u32 cwnd, u32 acked)
>          * if the cwnd < 1 million packets !!!
>          */
> =20
> -       t =3D (s32)(tcp_jiffies32 - ca->epoch_start);
> -       t +=3D usecs_to_jiffies(ca->delay_min);
> -       /* change the unit from HZ to bictcp_HZ */
> +       t =3D (s32)(tcp_jiffies32 - ca->epoch_start) * (USEC_PER_SEC / HZ=
);
> +       t +=3D ca->delay_min;
> +       /* change the unit from usec to bictcp_HZ */
>         t <<=3D BICTCP_HZ;
> -       do_div(t, HZ);
> +       do_div(t, USEC_PER_SEC);
> =20
>         if (t < ca->bic_K)              /* t - K */
>                 offs =3D ca->bic_K - t;
>=20
>=20
> But this is a minor detail.
Thanks for the suggestion and the corresponding explanation in tcp_cubic.c

USEC_PER_JIFFY is simpler than my current approach.  I will give it a spin.
