Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77404380ED
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfFFWiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:38:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49340 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726538AbfFFWiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:38:11 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56MYjIN023019;
        Thu, 6 Jun 2019 15:37:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=abCJEcXejy0cfcfgctCC9MQLD4ixr6oHrFyfS2oJamk=;
 b=XG+LmyRXAl08fgM7lGiohonLYklCzeZ2kI2Kil6Qzv5wswOWBk4v3bMCwgAkEkGFX4DN
 mDDsM3yf1ulBAVBCBgJ6wYh/j+dO3l3rsvOYrxFwRy6lZcSRWQE29YBw46mCdzxHU9oL
 nVjX01CFJAMlCZvNFEJIu0zQ5saW0QiYscQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy6mj19qa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 15:37:17 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 15:37:13 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 15:37:13 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 15:37:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abCJEcXejy0cfcfgctCC9MQLD4ixr6oHrFyfS2oJamk=;
 b=LSSpXs4yOKbA+7rFCgHhrvSdS3L5psae5K5B+sxRpbufoPMGMdxweBrMpn2SJbxpkOv4ErlZXGFSxYmovdr6K7wMvcVfkGO78sBJ7ZatxseEUAXdi8liwHAIwgWOhXN37vcntYpesBnywEno2fk9cVsy2yVMuHgRVcRBrAJOEOY=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1856.namprd15.prod.outlook.com (10.174.255.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Thu, 6 Jun 2019 22:37:11 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 22:37:11 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stefano Brivio <sbrivio@redhat.com>
CC:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        "Wei Wang" <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Topic: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Index: AQHVHKR0wP/xeYS/HEuAq3WE7PiYfKaPKOAAgAAJLoCAAAVngA==
Date:   Thu, 6 Jun 2019 22:37:11 +0000
Message-ID: <20190606223707.s2fyhnqnt3ygdtdj@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
 <20190606214456.orxy6274xryxyfww@kafai-mbp.dhcp.thefacebook.com>
 <20190607001747.4ced02c7@redhat.com>
In-Reply-To: <20190607001747.4ced02c7@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::19) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::538e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ce0fcf6-a3b9-430e-299b-08d6eacf839d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1856;
x-ms-traffictypediagnostic: MWHPR15MB1856:
x-microsoft-antispam-prvs: <MWHPR15MB185636E40881D7F00C6A9DAFD5170@MWHPR15MB1856.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(43544003)(51914003)(52314003)(199004)(5660300002)(99286004)(486006)(25786009)(9686003)(6116002)(6916009)(6246003)(1076003)(14444005)(66476007)(76176011)(8676002)(256004)(52116002)(68736007)(64756008)(66446008)(66556008)(6436002)(2906002)(7736002)(81166006)(102836004)(53936002)(71190400001)(71200400001)(305945005)(446003)(11346002)(54906003)(81156014)(86362001)(478600001)(66946007)(4326008)(6512007)(73956011)(6486002)(229853002)(14454004)(6506007)(386003)(46003)(316002)(8936002)(476003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1856;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e+XVSyi3yywnNq9CRlwiI2uXO6kIpZQwomRUY/aYyHtsALDYw1KbJFcjIir8LaU181k5FNmdKlUW7L41H5p4zNRUhpzAiipHfE1MJFXcGgjG9roVhF0gPvPWCTZIZJoU0vdOw08EIGkaQx0s1hCNmZB3mIRJsjTPuiGcgrAovzBUfcVfbET7B0eUL87E/m2Wljnl5kkm++C5tm9GpIz4FoUy/jNuTIfTQhj2qTX3HtqrLD0Fd+KwgscWhjbPkX7w28lP8Q7Dm8E62c/E2WaO5j/q+zE8h+pQfiN5Y+88U5zn0IYTn4dKUjWMTUu8xjlO7RA6SBb76ZA7ma9NyJhIsgAZ3onQJ6Rwhfg+qKrhKIFEJwHh9hPNeCWuNl0u/3gbWDBdrREBeyZwN0yHr/NGl/479BAoPtUa2nms0xodoGc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <30F41DD48B3A024DBD547D9FB9FD0E06@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce0fcf6-a3b9-430e-299b-08d6eacf839d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 22:37:11.3564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1856
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 12:17:47AM +0200, Stefano Brivio wrote:
> On Thu, 6 Jun 2019 21:44:58 +0000
> Martin Lau <kafai@fb.com> wrote:
>=20
> > > +	if (!(filter->flags & RTM_F_CLONED)) {
> > > +		err =3D rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
> > > +				    RTM_NEWROUTE,
> > > +				    NETLINK_CB(arg->cb->skb).portid,
> > > +				    arg->cb->nlh->nlmsg_seq, flags);
> > > +		if (err)
> > > +			return err;
> > > +	} else {
> > > +		flags |=3D NLM_F_DUMP_FILTERED;
> > > +	}
> > > +
> > > +	bucket =3D rcu_dereference(rt->rt6i_exception_bucket);
> > > +	if (!bucket)
> > > +		return 0;
> > > +
> > > +	for (i =3D 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
> > > +		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
> > > +			if (rt6_check_expired(rt6_ex->rt6i))
> > > +				continue;
> > > +
> > > +			err =3D rt6_fill_node(net, arg->skb, rt,
> > > +					    &rt6_ex->rt6i->dst,
> > > +					    NULL, NULL, 0, RTM_NEWROUTE,
> > > +					    NETLINK_CB(arg->cb->skb).portid,
> > > +					    arg->cb->nlh->nlmsg_seq, flags); =20
> > Thanks for the patch.
> >=20
> > A question on when rt6_fill_node() returns -EMSGSIZE while dumping the
> > exception bucket here.  Where will the next inet6_dump_fib() start?
>=20
> And thanks for reviewing.
>=20
> It starts again from the same node, see fib6_dump_node(): w->leaf =3D rt;
> where rt is the fib6_info where we failed dumping, so we won't skip
> dumping any node.
If the same node will be dumped, does it mean that it will go through this
loop and iterate all exceptions again?

>=20
> This also means that to avoid sending duplicates in the case where at
> least one rt6_fill_node() call goes through and one fails, we would
> need to track the last bucket and entry sent, or, alternatively, to
> make sure we can fit the whole node before dumping.
My another concern is the dump may never finish.

>=20
> I don't think that can happen in practice, or at least I haven't found a
> way to create enough valid exceptions for the same node.
That I am not sure.  It is not unusual to have many pmtu exceptions in
a gateway node.

>=20
> Anyway, I guess that would be nicer, but the fix is going to be much
> bigger, and I don't think we even have to guarantee that. I'd rather
> take care of that as a follow-up. Any preferred solution by the way?
>=20
> --=20
> Stefano
