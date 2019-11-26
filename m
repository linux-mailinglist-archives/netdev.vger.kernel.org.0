Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DAE10A445
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 20:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfKZTDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 14:03:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726200AbfKZTDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 14:03:14 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAQIsEml029155;
        Tue, 26 Nov 2019 11:03:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VJJf2dKL2LxDnELD9lWcabtz38+ymXRlJVRpSs8DtZI=;
 b=TDfPqEYK8YbQucSM14ArMJkds/a1bGEv1a4ND9KBf7IpMsS13CgxhdmLma/vQ9NCjR8N
 2RE+DSpJgBkLKUrrzbuO6+JtMWBfHPmExPaZ5FJUq08O4d9uHPxBiMg2I1K5hGUz2k5q
 FqP7zQmTqv1J5V8Okrhp/lB/7ZHPQnRBuys= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2wgqdynb83-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Nov 2019 11:03:11 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Nov 2019 11:03:09 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Nov 2019 11:03:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9UFVWIoPqCx06wxbxub12T1p842054Rv+/uwgiPq7KjMfyXVnZfYkg7qEe38400H+PxeMHp+XFfMAsdOX/kJTzS2j/+HUCCEOFUce1aFWldDSiQKl/JyXofzT7oBWT3V9Y6N0QZcbMIHx3JJKyuuCZYfOyF/Bqq7vaEl5M0DZqNHQxtolaCjBGcHy0VY+iq2yiggyM6l/UikZ67F05DKY4mLFa0UBH4g9hml3fMQ/gYF5GgbAEMFT3UwzUK9B3kff8+OdW3S+0TstMl/4qQvsD0MwUlrz7iN25GLbS/2TioEzS2Xcj26/L8PoQzIjH5bd7eHBy5KNagZdtICFQFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJJf2dKL2LxDnELD9lWcabtz38+ymXRlJVRpSs8DtZI=;
 b=lXn9kvnP9H2TJi0f75sHD1XqxbzX0vXpdhe61AYyxY5upuAdc/Hua5VqlIedOZBs4HY/QkfhyYQyknhtuM/3BGxAvkhiMkMuS8IPV6Z3WYpXhj+lxThcsfj8QLcmjXZ8+q2wwKe7GZm48o3abxi01d+8iZZYdNzKZrwckRV6gL9qUnuqesqYrUvQmaY1NwuiUz9NvR+25tsoBD5i8O9Kw131s7o/uAg7Sk5Yl8Xp2SeGPvJ5FJHhoqJqVlGwIxKuqhO//4JKgcrmQ2BySRnfAw7M8WJti86dUXMIBZW3OLz6TuaaVzyjw+K3jThQ8mGBHTiNi6OtL0tO3GLJB6mGbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJJf2dKL2LxDnELD9lWcabtz38+ymXRlJVRpSs8DtZI=;
 b=eAU/CEK1p138ONRINc5cDsiQfIIfWMfzyzR0p7cE/XS8PEV17xY4pmpx3Ph3zU0NyMg8uD0ZyrSi3RPQ/2d/1Gt3yi0T9ycwF878Gt3l1aw8Kl4GBh9FTnNfjPLNbcCCNchiA9s5qO2EYbMW0VcSe1/iQTPrTZjWQFp+b3imwIo=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3229.namprd15.prod.outlook.com (20.179.20.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.23; Tue, 26 Nov 2019 19:03:04 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 19:03:04 +0000
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
Thread-Index: AQHVoe5PiHpu8fB2SUOKHVSV2UPsCKebGluAgAAwNACAAGslgIAAv8yAgAES3oCAAEwEgA==
Date:   Tue, 26 Nov 2019 19:03:04 +0000
Message-ID: <20191126190301.quwvjihpdzfjhdbe@kafai-mbp.dhcp.thefacebook.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-6-jakub@cloudflare.com>
 <20191125012440.crbufwpokttx67du@ast-mbp.dhcp.thefacebook.com>
 <5ddb55c87d06c_79e12b0ab99325bc69@john-XPS-13-9370.notmuch>
 <87o8x0nsra.fsf@cloudflare.com> <20191125220709.jqywizwbr3xwsazi@kafai-mbp>
 <87imn6ogke.fsf@cloudflare.com>
In-Reply-To: <87imn6ogke.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0032.namprd12.prod.outlook.com
 (2603:10b6:301:2::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:de8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f95fb59-13bd-4850-6ae8-08d772a3441c
x-ms-traffictypediagnostic: MN2PR15MB3229:
x-microsoft-antispam-prvs: <MN2PR15MB3229954C5F33AFC33C1628AAD5450@MN2PR15MB3229.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(64756008)(66446008)(66476007)(66556008)(66946007)(478600001)(6246003)(1076003)(8676002)(81166006)(8936002)(46003)(446003)(11346002)(186003)(25786009)(7736002)(305945005)(6512007)(9686003)(81156014)(6486002)(316002)(14454004)(54906003)(229853002)(6916009)(6436002)(99286004)(3716004)(6116002)(71200400001)(71190400001)(14444005)(4326008)(256004)(2906002)(102836004)(86362001)(5660300002)(53546011)(76176011)(386003)(52116002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3229;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NO8C41LI7P26QZqaUY7LzaJFWObpyyIeJYIW1RqsLi3Wc0jTBp7/TOCZkl/L0hOz4VSs56JtChNPO2jdioEJ8IhVT85yAJG7FwOeXt8Ko0m2xAT8gnWd0oX1o/9uColigAju5v5mRM9lGoLVav2+B87PXvFjYBGAswMF602A2sFJjK//CnL36F9teAx605asdzj31JF4Hl08NXVfAEulVlt4MhV0s8qFcZJ3uRgoNVfKf1p8Fu+LqcF1sj1f5hTRs3keRls8/nZIEt0nAvFftU+o9TjLKV7uxt37utY1Jo1zKM4+gGjWu/PtZ/K7EDlLjw5kKzjzp5MPRe1hcdsPuU3dErLaOG/EnPvrbDXduSvdcQBH4rxZppKZGJZ7k1TicfNYDzuE0MUbSqdkdqemVpSHtnwnXz9mpR0RfcxqkdXaV2AZJ1hoNtdTBs2I+8WS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <993245046956E44D899412BF61AA6898@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f95fb59-13bd-4850-6ae8-08d772a3441c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 19:03:04.7481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8dsh9Em5nd+BaS6EpgsaxZeQXC6Vphvj8x3yQkVgY+msiDHhi1ekr6o276RfD73d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3229
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_05:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 mlxlogscore=875 lowpriorityscore=0 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911260160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 03:30:57PM +0100, Jakub Sitnicki wrote:
> On Mon, Nov 25, 2019 at 11:07 PM CET, Martin Lau wrote:
> > On Mon, Nov 25, 2019 at 11:40:41AM +0100, Jakub Sitnicki wrote:
> >> On Mon, Nov 25, 2019 at 05:17 AM CET, John Fastabend wrote:
> >> > Alexei Starovoitov wrote:
> >> >> On Sat, Nov 23, 2019 at 12:07:48PM +0100, Jakub Sitnicki wrote:
> >> >> > SOCKMAP now supports storing references to listening sockets. Not=
hing keeps
> >> >> > us from using it as an array of sockets to select from in SK_REUS=
EPORT
> >> >> > programs.
> >> >> >
> >> >> > Whitelist the map type with the BPF helper for selecting socket. =
However,
> >> >> > impose a restriction that the selected socket needs to be a liste=
ning TCP
> >> >> > socket or a bound UDP socket (connected or not).
> >> >> >
> >> >> > The only other map type that works with the BPF reuseport helper,
> >> >> > REUSEPORT_SOCKARRAY, has a corresponding check in its update oper=
ation
> >> >> > handler.
> >> >> >
> >> >> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> >> > ---
> >> >
> >> > [...]
> >> >
> >> >> > diff --git a/net/core/filter.c b/net/core/filter.c
> >> >> > index 49ded4a7588a..e3fb77353248 100644
> >> >> > --- a/net/core/filter.c
> >> >> > +++ b/net/core/filter.c
> >> >> > @@ -8723,6 +8723,8 @@ BPF_CALL_4(sk_select_reuseport, struct sk_r=
euseport_kern *, reuse_kern,
> >> >> >  	selected_sk =3D map->ops->map_lookup_elem(map, key);
> >> >> >  	if (!selected_sk)
> >> >> >  		return -ENOENT;
> >> >> > +	if (!sock_flag(selected_sk, SOCK_RCU_FREE))
> >> >> > +		return -EINVAL;
> > If I read it correctly,
> > this is to avoid the following "if (!reuse)" to return -ENOENT,
> > and instead returns -EINVAL for non TCP_LISTEN tcp_sock.
> > It should at least only be done under the "if (!reuse)" then.
>=20
> Yes, exactly. For an established TCP socket in SOCKMAP we would get
> -ENOENT because sk_reuseport_cb is not set. Which is a bit confusing
> since the map entry exists.
>=20
> Returning -EINVAL matches the REUSEPORT_SOCKARRAY update operation
> semantics for established TCP sockets.
>=20
> But this is just about returning an informative error so you're
> completely right that this should be done under "if (!reuse)" branch to
> avoid the extra cost on the happy path.
>=20
> > Checking SOCK_RCU_FREE to imply TCP_LISTEN is not ideal.
> > It is not immediately obvious.  Why not directly check
> > TCP_LISTEN?
>=20
> I agree, it's not obvious. When I first saw this check in
> reuseport_array_update_check it got me puzzled too. I should have added
> an explanatory comment there.
>=20
> Thing is we're not matching on just TCP_LISTEN. REUSEPORT_SOCKARRAY
> allows selecting a connected UDP socket as a target as well. It takes
> some effort to set up but it's possible even if obscure.
How about this instead:
if (!reuse)
 	/* reuseport_array only has sk that has non NULL sk_reuseport_cb.
	 * The only (!reuse) case here is, the sk has already been removed from
	 * reuseport_array, so treat it as -ENOENT.
	 *
	 * Other maps (e.g. sock_map) do not provide this guarantee and the sk may
	 * never be in the reuseport to begin with.
	 */
	return map->map_type =3D=3D BPF_MAP_TYPE_REUSEPORT_SOCKARRAY ? -ENOENT : -=
EINVAL;

>=20
> > Note that the SOCK_RCU_FREE check at the 'slow-path'
> > reuseport_array_update_check() is because reuseport_array does depend o=
n
> > call_rcu(&sk->sk_rcu,...) to work, e.g. the reuseport_array
> > does not hold the sk_refcnt.
>=20
> Oh, so it's not only about socket state like I thought.
>=20
> This raises the question - does REUSEPORT_SOCKARRAY allow storing
> connected UDP sockets by design or is it a happy accident? It doesn't
> seem particularly useful.
Not by design/accident on the REUSEPORT_SOCKARRAY side ;)

The intention of REUSEPORT_SOCKARRAY is to allow sk that can be added to
reuse->socks[].
