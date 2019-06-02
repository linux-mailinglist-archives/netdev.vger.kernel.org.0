Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB9733216D
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 03:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfFBBKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 21:10:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726547AbfFBBKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 21:10:06 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5212fuB006160;
        Sat, 1 Jun 2019 18:09:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BA1A5eEU/nQRQfAwHX/KPXgjeBQ4D0dvvGkD1nRrPig=;
 b=EJyUmOxQ36xAFzU2XC/R/btwRbdnpN/9HKmJYRp0cYgVhcezmHmAva6Yu5nY2dCl4CxN
 051QQR2HwCmopxXgLBHxKAqTprXfiyOBfgBHZEtaHxj/oZ7VMF4mgcdZ9X+pO6p425r5
 YwQwaMDF1ANXRp6C+voGoEgVHVn9sqlRdqM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2sunq5hgrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 01 Jun 2019 18:09:45 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 1 Jun 2019 18:09:44 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 1 Jun 2019 18:09:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BA1A5eEU/nQRQfAwHX/KPXgjeBQ4D0dvvGkD1nRrPig=;
 b=QjObQ8meN84gzZkC53es0FOfQE8Rp3GRvyy15bAX1fJ38NtBygh8D5Gpg9YIKS9TtpGA1mPA8z3bx1dd7iiXN4oPbhia8/++4JRVRn8JvqhLcmmn0xTt+8fcUPeZ93UWA22ZUGoHAYVDkFQo15DCYeSq0sb4oUSFHuMX/gfW0SA=
Received: from DM5PR15MB1788.namprd15.prod.outlook.com (10.174.109.138) by
 DM5PR15MB1706.namprd15.prod.outlook.com (10.174.108.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Sun, 2 Jun 2019 01:09:29 +0000
Received: from DM5PR15MB1788.namprd15.prod.outlook.com
 ([fe80::75ae:1c29:4d2:9044]) by DM5PR15MB1788.namprd15.prod.outlook.com
 ([fe80::75ae:1c29:4d2:9044%8]) with mapi id 15.20.1943.018; Sun, 2 Jun 2019
 01:09:29 +0000
From:   Martin Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [PATCH bpf 2/2] bpf: udp: Avoid calling reuseport's bpf_prog from
 udp_gro
Thread-Topic: [PATCH bpf 2/2] bpf: udp: Avoid calling reuseport's bpf_prog
 from udp_gro
Thread-Index: AQHVGABUggllN+JbhUuo+KpmYLZc56aHescAgAAU24A=
Date:   Sun, 2 Jun 2019 01:09:29 +0000
Message-ID: <20190602010925.eifdfmuao4pv5mui@kafai-mbp.dhcp.thefacebook.com>
References: <20190531222910.2499861-1-kafai@fb.com>
 <20190531222913.2500781-1-kafai@fb.com>
 <AB1E485E-DAEE-49BD-BC86-1299C6830B7F@fb.com>
In-Reply-To: <AB1E485E-DAEE-49BD-BC86-1299C6830B7F@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0068.namprd22.prod.outlook.com
 (2603:10b6:300:12a::30) To DM5PR15MB1788.namprd15.prod.outlook.com
 (2603:10b6:4:5b::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::2ddf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 494c06c9-b2de-4341-3a43-08d6e6f6f65a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1706;
x-ms-traffictypediagnostic: DM5PR15MB1706:
x-microsoft-antispam-prvs: <DM5PR15MB17069D1F87B300C779E6E359D51B0@DM5PR15MB1706.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(39860400002)(376002)(396003)(189003)(199004)(6116002)(229853002)(256004)(76176011)(81166006)(6436002)(7736002)(305945005)(8676002)(99286004)(52116002)(8936002)(186003)(102836004)(71190400001)(446003)(53936002)(81156014)(46003)(486006)(11346002)(6506007)(1076003)(476003)(53546011)(68736007)(6246003)(316002)(54906003)(71200400001)(386003)(478600001)(6486002)(6636002)(86362001)(64756008)(14454004)(66446008)(66556008)(73956011)(66476007)(66946007)(2906002)(25786009)(4326008)(6512007)(5660300002)(6862004)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1706;H:DM5PR15MB1788.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s9yuoPT6AndASe0kVkIVJmfNkBgGGLTIuQniQa0EjgkyLG6eiEA1nWQSunIjlLUIb35fAAHnRoIzjpL+jbJgJlpeYdB6jBrx6Hq3U+ikTuluSNcS3WXSe69oz528XT1+XnxPfnnDKZVlKbJinjRpISJp+5Dj4bL1TiSbv2wDFmmYTXyUdkqKj36KXBKHMy3plOtBuy7bADeUdMgyuXxQa3OMTSs/fe4UD0hUjPvkAPdIKgy/1L/4n1BCPBZQBcIqF+611KspI/NglSQj/x9W1oCKF4woSXiWEOZuLboj9sv+zNvflZDGO8keAmS6Jd3bAr+jiiI34M/zz44DL9HNsvA5zxRkIeMGwjMHeB+x7v1fqbJOkZvPwZNPQySHANGzz7Ruyt1+y1Dj7xZahi/+AnVw85jnvHYbaUho0o+is+U=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <56E53FCE4511F04EB2FD90FA18F926AC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 494c06c9-b2de-4341-3a43-08d6e6f6f65a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2019 01:09:29.2408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1706
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=962 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906020006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 04:54:46PM -0700, Song Liu wrote:
>=20
>=20
> > On May 31, 2019, at 3:29 PM, Martin KaFai Lau <kafai@fb.com> wrote:
> >=20
> > When the commit a6024562ffd7 ("udp: Add GRO functions to UDP socket")
> > added udp[46]_lib_lookup_skb to the udp_gro code path, it broke
> > the reuseport_select_sock() assumption that skb->data is pointing
> > to the transport header.
> >=20
> > This patch follows an earlier __udp6_lib_err() fix by
> > passing a NULL skb to avoid calling the reuseport's bpf_prog.
> >=20
> > Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
> > Cc: Tom Herbert <tom@herbertland.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> > net/ipv4/udp.c | 6 +++++-
> > net/ipv6/udp.c | 2 +-
> > 2 files changed, 6 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 8fb250ed53d4..85db0e3d7f3f 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -503,7 +503,11 @@ static inline struct sock *__udp4_lib_lookup_skb(s=
truct sk_buff *skb,
Note that this patch is changing the below "udp4_lib_lookup_skb()"
instead of the above "__udp4_lib_lookup_skb()".

> > struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
> > 				 __be16 sport, __be16 dport)
> > {
> > -	return __udp4_lib_lookup_skb(skb, sport, dport, &udp_table);
> > +	const struct iphdr *iph =3D ip_hdr(skb);
> > +
> > +	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
> > +				 iph->daddr, dport, inet_iif(skb),
> > +				 inet_sdif(skb), &udp_table, NULL);
>=20
> I think we can now remove the last argument of __udp4_lib_lookup()?
The last arg of __udp4_lib_lookup() is skb.
__udp4_lib_lookup_skb(), which is not changed in this patch, is still
calling __udp4_lib_lookup() with a skb and the skb is used by the
reuseport's bpf_prog.  Hence, it cannot be removed.

>=20
>=20
> > }
> > EXPORT_SYMBOL_GPL(udp4_lib_lookup_skb);
> >=20
> > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > index 133e6370f89c..4e52c37bb836 100644
> > --- a/net/ipv6/udp.c
> > +++ b/net/ipv6/udp.c
> > @@ -243,7 +243,7 @@ struct sock *udp6_lib_lookup_skb(struct sk_buff *sk=
b,
> >=20
> > 	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
> > 				 &iph->daddr, dport, inet6_iif(skb),
> > -				 inet6_sdif(skb), &udp_table, skb);
> > +				 inet6_sdif(skb), &udp_table, NULL);
> > }
> > EXPORT_SYMBOL_GPL(udp6_lib_lookup_skb);
> >=20
> > --=20
> > 2.17.1
> >=20
>=20
