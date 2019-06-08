Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF5639B4C
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 07:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfFHFkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 01:40:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbfFHFkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 01:40:36 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x585cfhw020350;
        Fri, 7 Jun 2019 22:40:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hjmPwHzX+6o5YPp0Jn9ReX08zgaTa4UHayRa/n4B/HY=;
 b=caeRfF8/IflcsSTzhUNrX45f3+PBb+sTdtcba/lXuHaT1y37+TGKFyR22YPOSyezYX02
 m+ezkshvTO90uHNr0wtEdTMzyC398rjfx/1/YPz5ZC8WKd9vJhA5WXoePwEgF0UtZQ4n
 xcbgBUR4slDyGZ1eeSNOdDUhaVsJbW0G9cQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2syq412xu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Jun 2019 22:40:27 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 7 Jun 2019 22:40:26 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 7 Jun 2019 22:40:26 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 7 Jun 2019 22:40:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjmPwHzX+6o5YPp0Jn9ReX08zgaTa4UHayRa/n4B/HY=;
 b=JNTyOUfkZrJENUiJ19crScntJElQGFnKbe+WricDhipVKOO+iaXFw5Y6GeAcNen43b6A788vz4MxWdXXRa+rNMcS885YQ8Ba3PlYTYsy+m1V9RHxLaB8Bu6pMGILyoBrIOziwKCzQIjWo6WZT6NSc2+8hZbnq3hCx4y+ZCClPzk=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1887.namprd15.prod.outlook.com (10.174.255.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Sat, 8 Jun 2019 05:40:06 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Sat, 8 Jun 2019
 05:40:06 +0000
From:   Martin Lau <kafai@fb.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Topic: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Index: AQHVHKR0wP/xeYS/HEuAq3WE7PiYfKaPG6OAgAAF3wCAABi1AIACBb2A
Date:   Sat, 8 Jun 2019 05:40:06 +0000
Message-ID: <20190608054003.5uwggebuawjtetyg@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
 <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
 <20190606231834.72182c33@redhat.com>
 <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
In-Reply-To: <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0151.namprd04.prod.outlook.com (2603:10b6:104::29)
 To MWHPR15MB1790.namprd15.prod.outlook.com (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:14ab]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a9bcf31-6fb0-4bd4-ec1b-08d6ebd3c2d3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1887;
x-ms-traffictypediagnostic: MWHPR15MB1887:
x-microsoft-antispam-prvs: <MWHPR15MB188757D5B811668DD79DFB09D5110@MWHPR15MB1887.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0062BDD52C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(376002)(346002)(189003)(199004)(76176011)(54906003)(73956011)(68736007)(6512007)(9686003)(446003)(46003)(6916009)(53936002)(6246003)(6486002)(11346002)(52116002)(316002)(25786009)(4326008)(6116002)(476003)(486006)(478600001)(229853002)(66476007)(186003)(66556008)(66446008)(99286004)(81156014)(64756008)(6436002)(66946007)(305945005)(1076003)(256004)(8936002)(81166006)(86362001)(8676002)(7736002)(386003)(5660300002)(71190400001)(53546011)(14454004)(71200400001)(1411001)(6506007)(2906002)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1887;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4SW6s8Xh1Rok+lDGGkSlbiOnuKUYX7pVbbfmwDIc537ZY4vcPAuiu2j09fsDLMxtPQoAQHqHPJs+EsJkIi/pINhV6m1aG1xtm6RUE6CDai5nwibTer6Cz+fDk+Y5VGtGvmbkfUwba5lpUZwC9v0syibBpARhX4BBiWiiDoHZeknb5N8lq/D5B26LUTjimNnagdBiTCCHN9seQUkM0qbKsQRPwDftIejd+mZbz2aCcZ1R/NoOOxrmO+Lwywv1THDi2NeWOnnkBttzvYadGQDZm+MFhA2TxVAlkfgmQlIvVhyKW74oMBxMjnGQ9vzq/EhJ4aIwHDbFt2Rr0NsmTMoz1ly1oEaT2JtAZpk3672bqXLwKHM9cxK5eM6RXjd6Mpv5cCJJPsCQEUlhDNuPiLOW4Jx5RfNJeg6yrcTmcV9US4c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D46E724C6DCB74FA51A84C7AD79584A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9bcf31-6fb0-4bd4-ec1b-08d6ebd3c2d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2019 05:40:06.2352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1887
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=831 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 04:47:00PM -0600, David Ahern wrote:
> On 6/6/19 3:18 PM, Stefano Brivio wrote:
> > On Thu, 6 Jun 2019 14:57:33 -0600
> > David Ahern <dsahern@gmail.com> wrote:
> >=20
> >>> This will cause a non-trivial conflict with commit cc5c073a693f
> >>> ("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
> >>> an equivalent patch against net-next, if it helps.
> >>>  =20
> >>
> >> Thanks for doing this. It is on my to-do list.
> >>
> >> Can you do the same for IPv4?
> >=20
> > You mean this same fix? On IPv4, for flushing, iproute2
> > uses /proc/sys/net/ipv4/route/flush in iproute_flush_cache(), and that
> > works.
> >=20
> > Listing doesn't work instead, for some different reason I haven't
> > looked into yet. That doesn't look as critical as the situation on IPv6
> > where one can't even flush the cache: exceptions can also be fetched
> > with 'ip route get', and that works.
> >=20
> > Still, it's bad, I can look into it within a few days.
> >=20
>=20
> I meant the ability to dump the exception cache.
>=20
> Currently, we do not get the exceptions in a fib dump. There is a flag
> to only show cloned (cached) entries, but no way to say 'no cloned
> entries'. Maybe these should only be dumped if the cloned flag is set.
> That's the use case I was targeting:
> 1. fib dumps - RTM_F_CLONED not set
I also think the fib dump should stay as is.

To be clear, I do not expect exception routes output from the
'ip [-6] r l'.  Otherwise, I will get pages of exceptions
that I am not interested at.  This should apply for both
v4 and v6.

> 2. exception dump - RTM_F_CLONED set
