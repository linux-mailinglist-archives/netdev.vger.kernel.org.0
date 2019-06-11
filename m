Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C013DBC3
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 22:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406495AbfFKUVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 16:21:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34658 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406240AbfFKUVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 16:21:00 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BKH0Nb022534;
        Tue, 11 Jun 2019 13:19:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YvBfReVwJJP2xl1dgwNSTllzQHvf9td2MDu34F8Uo7Q=;
 b=GgA48ZMczCWc1tRybU2naUrwj0hba6GnrQG0EP8voiALQwUbR1T18unS/aJBDD+DDA85
 hAkE2Sc8Wmgg0DKTNZvwZX7EUcnfXhSAZdGEXyo2utLedeY0qPakDtJI6Aj9hLdRkY86
 9gmtndXrjrORsRwfwojrZPRPhTBJWEufeyA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2t2dkmsdc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 11 Jun 2019 13:19:51 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 11 Jun 2019 13:19:50 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 11 Jun 2019 13:19:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 11 Jun 2019 13:19:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvBfReVwJJP2xl1dgwNSTllzQHvf9td2MDu34F8Uo7Q=;
 b=CUpaKGcxvac4vVLIUuxCzrKeu6CJmZWu+mK+vsav7L8P03JZaF7M+Ylu4gnt+Y9Y2kjpbBNFhyLmCexgrw+ydQX/RNLmM2QDc7foZwFER0b9yR9PEnuyDSMFXl0tcZWk4YWyGZCi8e/b/VRYK22gqLBizWxJbI+S5ikxYn344+c=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1823.namprd15.prod.outlook.com (10.174.254.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 11 Jun 2019 20:19:48 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1965.017; Tue, 11 Jun 2019
 20:19:48 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stefano Brivio <sbrivio@redhat.com>
CC:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v3 0/2] ipv6: Fix listing and flushing of cached route
 exceptions
Thread-Topic: [PATCH net v3 0/2] ipv6: Fix listing and flushing of cached
 route exceptions
Thread-Index: AQHVHiW7EB+fm/k9V0qJI3aslTUcg6aVbUgAgAAEPICAAA9JAIABaO0A
Date:   Tue, 11 Jun 2019 20:19:48 +0000
Message-ID: <20190611201946.tokf7su5hlxyrlhs@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1560016091.git.sbrivio@redhat.com>
 <37a62d04-0285-f6de-84b5-e1592c31a913@gmail.com>
 <20190610235315.46faca79@redhat.com> <20190611004758.1e302288@redhat.com>
In-Reply-To: <20190611004758.1e302288@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0093.namprd22.prod.outlook.com
 (2603:10b6:301:5e::46) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ebc5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b9940bb-b665-415f-f76e-08d6eeaa2664
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1823;
x-ms-traffictypediagnostic: MWHPR15MB1823:
x-microsoft-antispam-prvs: <MWHPR15MB1823586F5DF6E9D5CDAD0917D5ED0@MWHPR15MB1823.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(366004)(396003)(376002)(189003)(199004)(6436002)(6506007)(486006)(11346002)(102836004)(476003)(386003)(446003)(66446008)(66476007)(66556008)(73956011)(66946007)(64756008)(7736002)(229853002)(68736007)(6486002)(186003)(305945005)(81166006)(81156014)(8676002)(53936002)(46003)(8936002)(4326008)(6916009)(6512007)(25786009)(9686003)(6246003)(14454004)(54906003)(316002)(71200400001)(256004)(1076003)(5660300002)(71190400001)(86362001)(6116002)(508600001)(99286004)(52116002)(76176011)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1823;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tVipn7Gq4F7eTi/WtcW0hRNRA06BOMT6+jqA5XZdujbkK9xqNTXLuzLh31ti29mcVg1F+QwUi3l7ZIqXjtoUReNiwYBrtEYwVab665frDx9zx86Xe58+0LhGYHxJd5OcJ12UIl26uI6r2IeDh9F5IBlLKWgzcSm7FmSd9GZFYfBYVhCc9c4TQ33XvRWRdrxj0xjF4/d2fwoMvUyx6cjzvZHDmujqPWJh0/H+fjxqnu+fkaMEzVOI+DwWiy0COm7e5R8s4DTFOqxTRTpzZmWpNl7LGFtZHruwSc7+Oy/rVi9euED/U3KBrlS33dGzEpnmg7uXzqh+0ysPmxbJvzX62jQA60ibBl2JrdPnrIYv3xzv1Ywbwh9qIPeVybJhHVxfaK8yZdTi1fV7iyR7+XpoUBU4mB4tV2TcasrMPkShjWs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <335345C3DBDDD1488D361241CB4C6912@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9940bb-b665-415f-f76e-08d6eeaa2664
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 20:19:48.0970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1823
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=822 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 12:47:58AM +0200, Stefano Brivio wrote:
> On Mon, 10 Jun 2019 23:53:15 +0200
> Stefano Brivio <sbrivio@redhat.com> wrote:
>=20
> > On Mon, 10 Jun 2019 15:38:06 -0600
> > David Ahern <dsahern@gmail.com> wrote:
> >=20
> > > in dot releases of stable trees, I think it would be better to conver=
ge
> > > on consistent behavior between v4 and v6. By that I mean without the
> > > CLONED flag, no exceptions are returned (default FIB dump). With the
> > > CLONED flag only exceptions are returned. =20
> >=20
> > Again, this needs a change in iproute2, because RTM_F_CLONED is *not*
> > passed on 'flush'. And sure, let's *also* do that, but not everybody
> > runs recent versions of iproute2.
>=20
> One thing that sounds a bit more acceptable to me is:
>=20
> - dump (in IPv4 and IPv6):
>   - regular routes only, if !RTM_F_CLONED and NLM_F_MATCH
>   - exceptions only, if RTM_F_CLONED and NLM_F_MATCH
That seems reasonable since DavidAhern pointed out iproute2 already has
#define NLM_F_DUMP      (NLM_F_ROOT|NLM_F_MATCH)

>   - everything if !NLM_F_MATCH
I am not sure how may the kernel change looks like.  At least I don't
see the current ipv6/route.c or ipv6/ip6_fib.c is handling
nlmsg_flags.  I would defer to DavidAhern for comment.

>=20
> - fix iproute2 so that RTM_F_CLONED is passed on 'flush cache', or
I would just pass RTM_F_CLONED with NLM_F_DUMP.

>   don't pass NLM_F_MATCH in that case
>=20
> this way, the kernel respects the intended semantics of flags, and we
> fix a bug in iproute2 (that was always present).
>=20
> I think it's not ideal, because the kernel unexpectedly changed the
> behaviour and we're not guaranteeing that older iproute2 works. The
> fact it was broken for two years is probably a partial excuse for this,
> though.
>=20
> What do you think? I'll prepare a v4 for net-next if we all agree.
>=20
> I'm not entirely sure which trees I should target. I guess this
> introduces a feature in the kernel, so net-next, and fixes a bug in
> iproute2, so iproute2.git?
>=20
> --=20
> Stefano
