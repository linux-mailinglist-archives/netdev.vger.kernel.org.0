Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472FD381D3
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfFFXcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:32:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57226 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbfFFXcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:32:31 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x56NM3AE010240;
        Thu, 6 Jun 2019 16:31:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vvtYJbms1RxBuOiUtWW/n9FR1pimoOLSBC44Vlbohmc=;
 b=FNXC1EchoKWlRvWmFl7jnFZ22Q+ELiEU53QwUVMRcVq6HU+BprirNtWmgJ3SzTtRbW6s
 A2w0KajjaeyCRqaMVk0LyTWGjjpZy+9clzZB9qBbhQH5GiYQNiLtAKrx1v4whPPnWteJ
 Vhs4mlzRphEB3HG2WBSCVqlCo58CFmGkviY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2sy0e8arj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 16:31:59 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 16:31:57 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 16:31:57 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 16:31:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvtYJbms1RxBuOiUtWW/n9FR1pimoOLSBC44Vlbohmc=;
 b=Xbm5TJ9eIQsAYU5f7+ZutfKNAJh2i2v/JuoAPcz2nhN8CZOw/t8Bo7Xh0C26+R3jbIRpAyJlUhOXgwSHNpck1Bw9+gh8/nESpxae0MpnTfssR53L8moSdxBUXa2N/4Vrk1kgEejdNYM55n87VSj9m0rgtoci4hrbmALVxVyHCUI=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1904.namprd15.prod.outlook.com (10.174.98.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.13; Thu, 6 Jun 2019 23:31:56 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 23:31:56 +0000
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
Thread-Index: AQHVHKR0wP/xeYS/HEuAq3WE7PiYfKaPKOAAgAAJLoCAAAVngIAABhMAgAAJOoA=
Date:   Thu, 6 Jun 2019 23:31:55 +0000
Message-ID: <20190606233153.rnuhm5jmkzqxdrfn@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
 <20190606214456.orxy6274xryxyfww@kafai-mbp.dhcp.thefacebook.com>
 <20190607001747.4ced02c7@redhat.com>
 <20190606223707.s2fyhnqnt3ygdtdj@kafai-mbp.dhcp.thefacebook.com>
 <20190607005852.2aee8784@redhat.com>
In-Reply-To: <20190607005852.2aee8784@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0166.namprd04.prod.outlook.com
 (2603:10b6:104:4::20) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::538e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fe76127-e3ef-4d2c-baa9-08d6ead72986
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1904;
x-ms-traffictypediagnostic: MWHPR15MB1904:
x-microsoft-antispam-prvs: <MWHPR15MB1904B3C38EC85BC0B91CC142D5170@MWHPR15MB1904.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39860400002)(136003)(366004)(376002)(43544003)(51914003)(189003)(199004)(25786009)(2906002)(6246003)(6436002)(6506007)(8936002)(54906003)(73956011)(99286004)(6512007)(68736007)(6916009)(66476007)(64756008)(66446008)(66556008)(9686003)(66946007)(4326008)(53936002)(229853002)(46003)(305945005)(6116002)(6486002)(5660300002)(7736002)(486006)(11346002)(476003)(446003)(386003)(14444005)(86362001)(256004)(102836004)(81166006)(52116002)(81156014)(316002)(76176011)(71190400001)(71200400001)(1076003)(186003)(8676002)(478600001)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1904;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XOIILSUfgfYckwDjyIvNKWbrt/FtzIUtP8RPX2BDyZC1x+9mvXvz3TSfa/TUTwf6CjjXdmV5KyYKseAZXB4oToiiR0rocOBYU8dBIWo3S3vbqp4NxoFnBSh4tOOBDMmA6cXUnuRVy0SjBhCd9A6IfdtRDmAlNxqVV5g1tkjKLhySvjwWALXm1E056upjxDcPdvqUqv4uxdiaoJ/cLPgWKQk950hj//ZYImMnYyEqH9rF5r5ENg2cchIYdd3GB2MBJaV8IEpsUSPCc1+kKWxuP9mGuSs+rvNenIWTV0iXZ6sqz01QQvWrhSXR72PdjZo2kfvTDgoEQ6NVs8LcNwuRzBsbkRiKSFcl/0W5X4nZ6ItPGWsTCwWP0bqWw06F0QnkjgdWtZV/ofeFxXO2RMpn5zX6niPIQoaqEBLKMvwx/kU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D1D38B7A0CA954FB8AED440099068A3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe76127-e3ef-4d2c-baa9-08d6ead72986
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 23:31:56.0161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1904
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 12:58:52AM +0200, Stefano Brivio wrote:
> On Thu, 6 Jun 2019 22:37:11 +0000
> Martin Lau <kafai@fb.com> wrote:
>=20
> > On Fri, Jun 07, 2019 at 12:17:47AM +0200, Stefano Brivio wrote:
> > > On Thu, 6 Jun 2019 21:44:58 +0000
> > > Martin Lau <kafai@fb.com> wrote:
> > >  =20
> > > > > +	if (!(filter->flags & RTM_F_CLONED)) {
> > > > > +		err =3D rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
> > > > > +				    RTM_NEWROUTE,
> > > > > +				    NETLINK_CB(arg->cb->skb).portid,
> > > > > +				    arg->cb->nlh->nlmsg_seq, flags);
> > > > > +		if (err)
> > > > > +			return err;
> > > > > +	} else {
> > > > > +		flags |=3D NLM_F_DUMP_FILTERED;
> > > > > +	}
> > > > > +
> > > > > +	bucket =3D rcu_dereference(rt->rt6i_exception_bucket);
> > > > > +	if (!bucket)
> > > > > +		return 0;
> > > > > +
> > > > > +	for (i =3D 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
> > > > > +		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
> > > > > +			if (rt6_check_expired(rt6_ex->rt6i))
> > > > > +				continue;
> > > > > +
> > > > > +			err =3D rt6_fill_node(net, arg->skb, rt,
> > > > > +					    &rt6_ex->rt6i->dst,
> > > > > +					    NULL, NULL, 0, RTM_NEWROUTE,
> > > > > +					    NETLINK_CB(arg->cb->skb).portid,
> > > > > +					    arg->cb->nlh->nlmsg_seq, flags);   =20
> > > > Thanks for the patch.
> > > >=20
> > > > A question on when rt6_fill_node() returns -EMSGSIZE while dumping =
the
> > > > exception bucket here.  Where will the next inet6_dump_fib() start?=
 =20
> > >=20
> > > And thanks for reviewing.
> > >=20
> > > It starts again from the same node, see fib6_dump_node(): w->leaf =3D=
 rt;
> > > where rt is the fib6_info where we failed dumping, so we won't skip
> > > dumping any node. =20
> > If the same node will be dumped, does it mean that it will go through t=
his
> > loop and iterate all exceptions again?
>=20
> Yes (well, all the exceptions for that node).
>=20
> > > This also means that to avoid sending duplicates in the case where at
> > > least one rt6_fill_node() call goes through and one fails, we would
> > > need to track the last bucket and entry sent, or, alternatively, to
> > > make sure we can fit the whole node before dumping. =20
> > My another concern is the dump may never finish.
>=20
> That's not a guarantee in general, even without this, because in theory
> the skb passed might be small enough that we can't even fit a single
> node without exceptions.
That is arguably the caller's responsibility to retry
with a larger buffer if it cannot even get a single route.

If caller provides a large enough buffer for a single route,
the kernel should guarantee forward progress.

I think the minimum is to remember how many exceptions have to be
skipped.

>=20
> We could add a guard on w->leaf not being the same before and after the
> walk in inet6_dump_fib() and, if it is, terminate the dump. I just
> wonder if we have to do this at all -- I can't find this being done
> anywhere else (at a quick look at least).
>=20
> By the way, we can also trigger a never-ending dump by touching the
> tree frequently enough during a dump: it would always start again from
> the root, see fib6_dump_table().
This case "cb->args[5] !=3D w->root->fn_sernum"?  It seems there is a w->sk=
ip
to take care of it.

Regardless, I don't think we should make it worse.
