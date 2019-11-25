Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA8109562
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKYWHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:07:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43750 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbfKYWHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:07:18 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPM79hZ026896;
        Mon, 25 Nov 2019 14:07:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=szxTS4RoVX6d1XNw4/szmBwUUthjS6MOBTZEA3IWiuA=;
 b=Dn98ylYN1TLAi0y3iFsTTlDr3zRIk0OF30+0Up7WqpfUiwFV5qFv6zHIQPvniWYf7rUT
 z41zxOB5GViQr8JfVtZu+BeWNEZjZl/19idj3bsBo/3/xzkx8mV71keEyhnCaymubpZO
 n7BiAYP+eXvDRLA04OgE4KsbBMWidHv9g+A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wfnbg0c4y-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 25 Nov 2019 14:07:16 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 Nov 2019 14:07:14 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 25 Nov 2019 14:07:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbedQ9E3ytDdMKUhjQonp/MSZ1d6ERUhmUGo/bYqE1KsjOPVVjRRxyDgabOdYt8iXYApqwUUh3N0Ix8Fzc4yql2tdsZIbNG3oMqMGihJjrz9csqo0k0ClE8WWyJF0ysrS9dugaTbHTIhj0K89PSVyIPsy0KKQ0xvxV/oI2jKGGu3la5fOr2o4yW/x4PMypG5ygGgoK8Ghd9bdatRXfATu/BWNnEK0ATkSqjqXWDjkF5c4GO8ZEMT+si69TwEyWvKunDPCCpSxZPcf5u8/TyPpHgb7KpU+pJHHQ/PW9/NaK0JSeIMFsCrBA84KH5j5P1Pb75TaJoufduPfOjzx1e46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szxTS4RoVX6d1XNw4/szmBwUUthjS6MOBTZEA3IWiuA=;
 b=kItFmre6ViLiPcLeRMhKpyE2PPJvf8sZjbXEt0hakVs9fFuMEOsc0J6BvXkga6yDV1CfsRZGXyKsKxVqe9QR1tfNFfQUKS+haZNFyTOoxYzHYHEtaMaH1M8+M1Z0g6UTYnDYRpSV533LPKuH+LRHJdkm9hWYXHXXnX45tCkbar+L3KNa3gL7weG4wpK+CH3yWMS7crGe7oIFAgNDrj1jFLsYA2OeTdsHezabd76dNeRlFW/1PT7MV5s4yDjWo5HDanzx17pEZ2HE6b97ZYUF5q2G95qhqhkudSNnVTx13o77ndud6n/efTKczlVTvhnyxRJQSrgwmNM8Np4MPCuwOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szxTS4RoVX6d1XNw4/szmBwUUthjS6MOBTZEA3IWiuA=;
 b=bXs6jy9KGXh2nkXod4dsob3H2p/7WrI1IrX+l6D6V6m4LIRgRVjJbwNFDM0qj4OUmPem4EzC7guEI3KDsVWfSzFOF1mH8Z729bFR4hQ63HiMJEj8v8VsVyMaDyhliNTtvkSA/Dg5NV1CJ5AIFMStoTAgGBYdbiLpY+Jv5MWUZbM=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2653.namprd15.prod.outlook.com (20.179.144.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Mon, 25 Nov 2019 22:07:12 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 22:07:12 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: Allow selecting reuseport socket from a
 SOCKMAP
Thread-Topic: [PATCH bpf-next 5/8] bpf: Allow selecting reuseport socket from
 a SOCKMAP
Thread-Index: AQHVoe5PiHpu8fB2SUOKHVSV2UPsCKebGluAgAAwNACAAGslgIAAv8yA
Date:   Mon, 25 Nov 2019 22:07:12 +0000
Message-ID: <20191125220709.jqywizwbr3xwsazi@kafai-mbp>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-6-jakub@cloudflare.com>
 <20191125012440.crbufwpokttx67du@ast-mbp.dhcp.thefacebook.com>
 <5ddb55c87d06c_79e12b0ab99325bc69@john-XPS-13-9370.notmuch>
 <87o8x0nsra.fsf@cloudflare.com>
In-Reply-To: <87o8x0nsra.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0143.namprd04.prod.outlook.com (2603:10b6:104::21)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:c9b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f56d93ec-6526-4412-cdd4-08d771f3d2fc
x-ms-traffictypediagnostic: MN2PR15MB2653:
x-microsoft-antispam-prvs: <MN2PR15MB26537D28B34903FE5D5A9CC1D54A0@MN2PR15MB2653.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(376002)(136003)(39860400002)(346002)(366004)(189003)(199004)(316002)(2906002)(14454004)(4326008)(54906003)(71200400001)(71190400001)(478600001)(6486002)(6512007)(6436002)(229853002)(6116002)(8676002)(6246003)(8936002)(81166006)(256004)(14444005)(1076003)(53546011)(6506007)(5660300002)(99286004)(102836004)(305945005)(386003)(81156014)(9686003)(186003)(446003)(64756008)(66476007)(33716001)(66946007)(46003)(66446008)(66556008)(86362001)(76176011)(52116002)(7736002)(25786009)(11346002)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2653;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y3cQe/jsHbgNpjoMRz5ADk5kPNGelXwS8Nv3TebpQjoz2ZSM0vmjU7mOWJw3eYN+fcqafrft6T0GeAeh3mlFjcwu2wY/2GM6XDe/3ct/VUnnMGf5PjfZQooJvHmiKSoM2A1O6Z2PAKxh8WrrSS81g6Hmt339ok+wLryhV++AXepB9cwFb/QMBhAZt1w28xdR39VzOQE1Jay/s7x+hDGm5Rir9qFL54dIAGc8Uf936240Xc3Du24BcIWExf7nvyBIC8oR/YrKZsiuwyAE6rM1hoWQqPuuLnqPWL85igQ2KQZo8tuu/Kap8zs842IWjzHw5zeNFETnoUPg7ZcMCE8Pz+vAtijx232d36LPjUT2fReb978AIHmJCibDT+dM5aXFYkpeY0Hkk++8LVVNd0DqlRVOKa6eaBBfpsZI89kRJS/Kcjcr5Q1hhCTpbF1s9r/j
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8DFDC1A121754948BEE69FDE9BE22CEB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f56d93ec-6526-4412-cdd4-08d771f3d2fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 22:07:12.8958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oELJP2kJpDUqqwOFFCUn7vQMhRZEfqK2rtkGSjXMh0E6v6hVhOY5WQUSJdMXUeSR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2653
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_06:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 mlxlogscore=724
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911250176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 11:40:41AM +0100, Jakub Sitnicki wrote:
> On Mon, Nov 25, 2019 at 05:17 AM CET, John Fastabend wrote:
> > Alexei Starovoitov wrote:
> >> On Sat, Nov 23, 2019 at 12:07:48PM +0100, Jakub Sitnicki wrote:
> >> > SOCKMAP now supports storing references to listening sockets. Nothin=
g keeps
> >> > us from using it as an array of sockets to select from in SK_REUSEPO=
RT
> >> > programs.
> >> >
> >> > Whitelist the map type with the BPF helper for selecting socket. How=
ever,
> >> > impose a restriction that the selected socket needs to be a listenin=
g TCP
> >> > socket or a bound UDP socket (connected or not).
> >> >
> >> > The only other map type that works with the BPF reuseport helper,
> >> > REUSEPORT_SOCKARRAY, has a corresponding check in its update operati=
on
> >> > handler.
> >> >
> >> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> > ---
> >
> > [...]
> >
> >> > diff --git a/net/core/filter.c b/net/core/filter.c
> >> > index 49ded4a7588a..e3fb77353248 100644
> >> > --- a/net/core/filter.c
> >> > +++ b/net/core/filter.c
> >> > @@ -8723,6 +8723,8 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reus=
eport_kern *, reuse_kern,
> >> >  	selected_sk =3D map->ops->map_lookup_elem(map, key);
> >> >  	if (!selected_sk)
> >> >  		return -ENOENT;
> >> > +	if (!sock_flag(selected_sk, SOCK_RCU_FREE))
> >> > +		return -EINVAL;
If I read it correctly,
this is to avoid the following "if (!reuse)" to return -ENOENT,
and instead returns -EINVAL for non TCP_LISTEN tcp_sock.
It should at least only be done under the "if (!reuse)" then.

Checking SOCK_RCU_FREE to imply TCP_LISTEN is not ideal.
It is not immediately obvious.  Why not directly check
TCP_LISTEN?

Note that the SOCK_RCU_FREE check at the 'slow-path'
reuseport_array_update_check() is because reuseport_array does depend on
call_rcu(&sk->sk_rcu,...) to work, e.g. the reuseport_array
does not hold the sk_refcnt.

> >>
> >> hmm. I wonder whether this breaks existing users...
> >
> > There is already this check in reuseport_array_update_check()
> >
> > 	/*
> > 	 * sk must be hashed (i.e. listening in the TCP case or binded
> > 	 * in the UDP case) and
> > 	 * it must also be a SO_REUSEPORT sk (i.e. reuse cannot be NULL).
> > 	 *
> > 	 * Also, sk will be used in bpf helper that is protected by
> > 	 * rcu_read_lock().
> > 	 */
> > 	if (!sock_flag(nsk, SOCK_RCU_FREE) || !sk_hashed(nsk) || !nsk_reuse)
> > 		return -EINVAL;
> >
> > So I believe it should not cause any problems with existing users. Perh=
aps
> > we could consolidate the checks a bit or move it into the update paths =
if we
> > wanted. I assume Jakub was just ensuring we don't get here with SOCK_RC=
U_FREE
> > set from any of the new paths now. I'll let him answer though.
>=20
> That was exactly my thinking here.
>=20
> REUSEPORT_SOCKARRAY can't be populated with sockets that don't have
> SOCK_RCU_FREE set. This makes the flag check in sk_select_reuseport BPF
> helper redundant for this map type.
>=20
> SOCKMAP, OTOH, allows storing established TCP sockets, which don't have
> SOCK_RCU_FREE flag and shouldn't be used as reuseport targets. The newly
> added check protects us against it.
>=20
> I have a couple tests in the last patch for it -
> test_sockmap_reuseport_select_{listening,connected}. Admittedly, UDP is
> not covered.
>=20
> Not sure how we could go about moving the checks to the update path for
> SOCKMAP. At update time we don't know if the map will be used with a
> reuseport or a sk_{skb,msg} program.
or make these checks specific to the sockmap's lookup path.



digress a little from this patch,
will the upcoming patches/examples show the use case to have both
TCP_LISTEN and TCP_ESTABLISHED sk in the same sock_map?
