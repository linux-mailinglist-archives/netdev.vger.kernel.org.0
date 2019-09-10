Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1BAAF21F
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 22:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfIJUAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 16:00:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8176 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725263AbfIJUAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 16:00:01 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8AJrolT029482;
        Tue, 10 Sep 2019 12:59:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mchjRyIDGp6gcw6aR7A6G7iBlcSMGYnjufvmcqtKAXU=;
 b=PwTjk8sQzAM26GlGKL7n2Ql2ZeGcAsy56ps8hEL8AMeXztiMG/q2QR/mUoqFuLu1UxCj
 /dMGfg2HnVUhKmC1vjccTNIELQUmCG+uVznwWjgmPWKHKpmzweuCct81eoCcr7GsIHZv
 BC+MmsaX1Q8IzsqSBTMsRSK3C4MkBqvqRl4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uxaj2txa2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Sep 2019 12:59:58 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Sep 2019 12:59:54 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Sep 2019 12:59:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGq0y0an0a+FuLKMMCKaPafDC1g+vO/YTaBLX3BY0FTm+Dg7UGQsNsb2ffzZYG2ytXH8fMbN7KPp7W2P7AbhH3bhgNMb0Zq04M3p+gnUvfCD0TNhkYdRC3aHhiuho4QqDW15NT4n7JTjfkre2b++UETv9ikD0AF0f1OGyOjwnFvx719L72ZEdHABaERITyjJVo+y38mkglU2UUi9c1enEpxt/ytfiK+bvYjfjm4YGuky/PC9R1llIjwu1ah/F/4LmXpBhZcly5d8JAASuFPXGix6EtFyNdGynzQTLBR/6SqkyTQv5Wwj9ROHgG9nPojrafTqUmetkHjoeT4qA0kVCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mchjRyIDGp6gcw6aR7A6G7iBlcSMGYnjufvmcqtKAXU=;
 b=CiTkpzBq14j4Zf8OuLRWbGblGse19zXYsHy/MiyOH1AweMt+VcygEeBlTmuu9JXmlFP31phhClVg2eYyMoVPEpvFgnZaPjx4/nwaLwbSv29m7kp0kVWWm9vn1Xzu+YdsvfxB4Kdhehblm7PglYiDYsvaugzAtLPCclPsVINkY3GnTss3NKWXZ6R1T7FR6ZsKzEG4Pn6lEMzYNSsGPM8MAHK4MZAiCQyfOxBJ1zoj8paYNzFRtFl/B5wMpjd2tKmOSEPoWA4kfSGorlZS2HxodBZ4IvdbY856vbEakig/mdAwXdSg+6C6WgRoyeADcRr46GknzZXFIERxQ+3NkVOmqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mchjRyIDGp6gcw6aR7A6G7iBlcSMGYnjufvmcqtKAXU=;
 b=Q5P9tR0aAuAVUKm7KLG4i39mhEYeGzU4DUI4Ijg524R2ALvWdNXfHg9lnMxMQhDTA2eq9gIROAf/3BZUani2xw43O5qq0NH1NbdYJarK0EDWopQLNEMF6cwwB8nqjRPUC/yC4X98ipCmDsQRQrw1zmOJuSC8b6pk8jrYklJqZjA=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1814.namprd15.prod.outlook.com (10.172.77.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.13; Tue, 10 Sep 2019 19:59:53 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 19:59:53 +0000
From:   Thomas Higdon <tph@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>
Subject: Re: [PATCH] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Topic: [PATCH] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Index: AQHVZxszhFTLlrWuGku6/tljj0uS4acjcMgAgAHlnQA=
Date:   Tue, 10 Sep 2019 19:59:53 +0000
Message-ID: <20190910195950.GB89051@tph-mbp>
References: <20190909142844.347495-1-tph@fb.com>
 <CANn89iJ5wANqhpR28y5AYf6GTBgzTau+u0N0ogG690C71LbxaA@mail.gmail.com>
In-Reply-To: <CANn89iJ5wANqhpR28y5AYf6GTBgzTau+u0N0ogG690C71LbxaA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:208:134::36) To CY4PR15MB1207.namprd15.prod.outlook.com
 (2603:10b6:903:110::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:500::2:876b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cdc70fc-d30f-4a9c-635f-08d736297210
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR15MB1814;
x-ms-traffictypediagnostic: CY4PR15MB1814:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB181484DC4EF5999F00539CD6DDB60@CY4PR15MB1814.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(376002)(136003)(346002)(396003)(366004)(39860400002)(199004)(189003)(102836004)(14454004)(305945005)(71200400001)(8676002)(71190400001)(1076003)(6506007)(386003)(81156014)(81166006)(14444005)(486006)(256004)(8936002)(46003)(53546011)(11346002)(476003)(446003)(33656002)(186003)(5660300002)(316002)(54906003)(4326008)(6246003)(33716001)(478600001)(99286004)(6436002)(52116002)(229853002)(86362001)(6486002)(25786009)(2906002)(66946007)(64756008)(66476007)(66446008)(66556008)(6512007)(9686003)(7736002)(53936002)(6116002)(6916009)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1814;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FNTskwCcEJIXOk+f2I0WhmUkOiFwlrb0Nty0IdNZJ7NgOfDcv28tfuGN0rFPYuIzM7GOXIue1r45N7akpjvvxeXHzaKJySATln7wLfU84SPaG55QCo9+uBBO2OC8lIXfd0iHnv6vCsHZBqf1r5AMZhK4I1+KVRxiftleR8lye/TipUy8zw1wshgWSfYJWZs05/V1dRzxvrjOszqQoaGMoEDEFkGlBiLflakKIwi+DnWfuB9jInPEx7FRXrGewR/uuN2oIH/Bdtv/sLL42rDdLkLNrb885f1Rgs9nn0ly3tq8Nna3R8vNemod6alKdvF+K4JrUppl5YAEX6nItd0HuvWDqSwAeOOG1jE/X03XTD775jSMjDF+6LlI2Diu15xko/l2DEDOuJOriAa0mQ6lLMgmWGeYlFx/2/OjyjQCwtQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DE1CD4B3CAA7494189EAA4598C7685AA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdc70fc-d30f-4a9c-635f-08d736297210
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 19:59:53.4658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WGeshSgBeqdEbk8VDpGuh+DE3jsWFWL8IBOdrm1wzPXUVJueS9v/Ix4kiiR2viD8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1814
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_11:2019-09-10,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1011 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909100188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 05:01:46PM +0200, Eric Dumazet wrote:
> On Mon, Sep 9, 2019 at 4:30 PM Thomas Higdon <tph@fb.com> wrote:
> > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > index b3564f85a762..20237987ccc8 100644
> > --- a/include/uapi/linux/tcp.h
> > +++ b/include/uapi/linux/tcp.h
> > @@ -270,6 +270,8 @@ struct tcp_info {
> >         __u64   tcpi_bytes_retrans;  /* RFC4898 tcpEStatsPerfOctetsRetr=
ans */
> >         __u32   tcpi_dsack_dups;     /* RFC4898 tcpEStatsStackDSACKDups=
 */
> >         __u32   tcpi_reord_seen;     /* reordering events seen */
> > +
> > +       __u32   tcpi_rcv_ooopack;    /* Out-of-order packets received *=
/
>=20
> This is problematic : you create a 32bit hole in this structure that
> we will never be able to fill.
>=20
> We need to add another metric here so that the whole 64bit space is used.

I don't have another metric to add currently. Perhaps I could first place
a '__u32 _reserved' member so that someone else may replace it with
a 32-bit member in the future. Unless there is a canonical way to do
this? I couldn't find any prior examples.

> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 706cbb3b2986..2774680c5d05 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -4555,6 +4555,7 @@ static void tcp_data_queue_ofo(struct sock *sk, s=
truct sk_buff *skb)
> >         tp->pred_flags =3D 0;
> >         inet_csk_schedule_ack(sk);
> >
> > +       tp->rcv_ooopack++;
>=20
> We count skbs or we count segments ?
>=20
> (GRO might have aggregated multiple segments)

Let's count segments -- I will copy the technique of tcp_segs_in(), which
checks the maximum of 1 and gso_segs from the lower layer. Interestingly,
on my development machine, which uses the virtio-net driver, when LRO is
enabled, gso_segs is always zero, even when an aggregated segment is
passed up the stack. I guess this may be a problem with virtio-net? It
still seems that using gso_segs here is the correct solution.
