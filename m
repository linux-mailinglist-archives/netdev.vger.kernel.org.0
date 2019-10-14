Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499AFD686F
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbfJNR0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:26:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41218 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732686AbfJNR0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:26:53 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9EH88VC029215;
        Mon, 14 Oct 2019 10:26:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jEVhRhQmpA6v6FCoYkKxYwLxXY+FAXBzCVC0nOBOiZY=;
 b=W0inwtApezNYC+RfheqC9d7xI9n/THY//1UknOMo2VMAKxI2RYLUT8SOPEVMBxJnKBP7
 6DZjwqStpH8i0V44VMhRatpfSByl/Zjhh5KdBT6SvpmMzpdsIKXr+JpofKnGExpkmOMc
 2LZ3PD58iGO+X5uoXPli5GrrWFmAHuv/Ft8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vkagnfxn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 14 Oct 2019 10:26:46 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 14 Oct 2019 10:26:44 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 14 Oct 2019 10:26:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mf5PMtuE8lHc2AGpzYLgKKTGXn/lCUYDGz3rioyCyfLxovvAJLqrvTJLsR5LLfAxrcfPpiACwLe3V1up2REBcbIS+8N3Ie7m/uFsLtPpOKSUb74/7h/PBUXoHmFzeoQf2ChpgTvWTwBpL9xy+mLlPuBgEbR5ul4tQh4j3SmaCpigsZwPfSXXAth+tpHd5T4hNtvOWp1BrIZ4ATpidHucKY54aMPGcv9Jd9B3DywhzJlud/ZgjkYifWMB12dGJQpqcPLAfuBG7tsVcbWwHYrBm37U1yaVcSlH3rCH4eTB5NgfPM92psjLfYxxgk1iLaxzXFBAwXQyLsr3HSt9PpjYtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEVhRhQmpA6v6FCoYkKxYwLxXY+FAXBzCVC0nOBOiZY=;
 b=STOwcp7exB5ftp9PSQSmdkc/9NgiD7VpZeJYhMz3+OzuSM+FXnVtRcr34J33P8E45dJFPC7nH+lKvzLanNupAKZ0emPyhH9VJXtWUF/JMGMNTMlZY/DC+YwtA+MWSlDLRuNhhAcij0LpnJw73TgD3Jc0oOlnnZgpHCMXq+cq2kqVcJNsD0HvcD/3kI7mV4YlrVQFvHyb1Xdq8uUkWuSyBDkS1w12VjrjfRqbLGPJAZ+/jO5/QYDs1Ufa01dlXnsucL8lgWRRs+AqQm/CnxSF0IAOprY6sz4XbtqbRFCKgDWoSPWvs95dQdhr97wM6LpMCbEBfKt68VHDcIrUzrKbFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEVhRhQmpA6v6FCoYkKxYwLxXY+FAXBzCVC0nOBOiZY=;
 b=ksZZagf/yuZZm/EH8TBOIa31J5ZPCGhDAUznRyDMOPv16ed5bwXHubzV3CqwGdOQ05mtvJr3WIzKpm4EzCh7+22v7CWup8+EBntbwupOw/gu6775ZL9Ek1Z97PKaW+n+4Zi/2PV2eWWL35kA0BvvqcxvK71sPQuakhLo6CvIJqs=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3712.namprd15.prod.outlook.com (52.132.174.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Mon, 14 Oct 2019 17:26:43 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.023; Mon, 14 Oct 2019
 17:26:43 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <weiwan@google.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Race condition in route lookup
Thread-Topic: Race condition in route lookup
Thread-Index: AQHVfrqzp034SiLNvUyIFpgTa/vMKqdTjKQAgAH4ioCAABJQAIAAJNSAgADadwCAArbUgIABHgEA
Date:   Mon, 14 Oct 2019 17:26:43 +0000
Message-ID: <20191014172640.hezqrjpu43oggqjt@kafai-mbp.dhcp.thefacebook.com>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
 <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter>
 <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <20191012065608.igcba7tcjr4wkfsf@kafai-mbp.dhcp.thefacebook.com>
 <CAEA6p_A_kNA8kVLmVn0e=fp=vx3xpHTTaVrx62NVCDLowVxaog@mail.gmail.com>
In-Reply-To: <CAEA6p_A_kNA8kVLmVn0e=fp=vx3xpHTTaVrx62NVCDLowVxaog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:a03:100::32) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:6574]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eb6225e-2114-4ef8-db07-08d750cbae9a
x-ms-traffictypediagnostic: MN2PR15MB3712:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR15MB3712A0E41F15E179672626C9D5900@MN2PR15MB3712.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(376002)(39860400002)(396003)(51914003)(189003)(199004)(51444003)(81156014)(8936002)(81166006)(4326008)(25786009)(76176011)(52116002)(6436002)(99286004)(8676002)(14454004)(6306002)(6246003)(9686003)(6512007)(478600001)(6916009)(66476007)(66446008)(64756008)(66556008)(966005)(6486002)(66946007)(2906002)(6116002)(229853002)(316002)(71190400001)(7736002)(54906003)(86362001)(305945005)(486006)(66574012)(186003)(1076003)(446003)(46003)(256004)(14444005)(11346002)(102836004)(53546011)(386003)(71200400001)(6506007)(476003)(5660300002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3712;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ff4adPjOoj/0gRZAQvU8yh/IgpvH+pDB21dski71I2PFv3UxWAdIoGckGM52gGc9qmL3dJrJpoT/xMXhqwDSTlS1g0sqX3956XiKhcOaWX8ot5O62g6c35iZqxXFLkG5gTpwRQipUCaTgT3WbxcdVZoLDzuc7IjQPG/RO6fjpGgwSrvBndzWOfyW1ofiV1DkKxpll6Y3qndlHSWVfoVOsjM7KKfsUyk8hLn1G+RV3HzcRHVaXYeEnAO8aWboSaSGoMZa65nEBQoxiwLY88F5kxIs8/BHT0uX9W2R7Z9HRbf63NVPP3trHvEvdIpcR20nYQPUdJ28gmRKoncNyoSo3viSe++EQwVvRZpn5uQdTDcXZXmII3BkuRyE0GYuTxm/D6vY48v+1A8Hyr2h3o9/ggiaxXGmt/f4UR/9EQDnkzMgddSF0D590cOn/pFwPf2HZnzxRNI+u+7pcowiS3oZ4Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5950B4AA7B7A2641B178360032B991DF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb6225e-2114-4ef8-db07-08d750cbae9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2019 17:26:43.6100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: okCQpGSkg91l/RHDsbTz1himUN5nWMcyuIKfK8fnexvcrjr2qf4NPkVaRTaBuzXN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3712
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-14_09:2019-10-11,2019-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910140145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 05:23:01PM -0700, Wei Wang wrote:
> On Fri, Oct 11, 2019 at 11:56 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 10:54:13AM -0700, Wei Wang wrote:
> > > On Fri, Oct 11, 2019 at 8:42 AM Ido Schimmel <idosch@idosch.org> wrot=
e:
> > > >
> > > > On Fri, Oct 11, 2019 at 09:36:51AM -0500, Jesse Hathaway wrote:
> > > > > On Thu, Oct 10, 2019 at 3:31 AM Ido Schimmel <idosch@idosch.org> =
wrote:
> > > > > > I think it's working as expected. Here is my theory:
> > > > > >
> > > > > > If CPU0 is executing both the route get request and forwarding =
packets
> > > > > > through the directly connected interface, then the following ca=
n happen:
> > > > > >
> > > > > > <CPU0, t0> - In process context, per-CPU dst entry cached in th=
e nexthop
> > > > > > is found. Not yet dumped to user space
> > > > > >
> > > > > > <Any CPU, t1> - Routes are added / removed, therefore invalidat=
ing the
> > > > > > cache by bumping 'net->ipv4.rt_genid'
> > > > > >
> > > > > > <CPU0, t2> - In softirq, packet is forwarded through the nextho=
p. The
> > > > > > cached dst entry is found to be invalid. Therefore, it is repla=
ced by a
> > > > > > newer dst entry. dst_dev_put() is called on old entry which ass=
igns the
> > > > > > blackhole netdev to 'dst->dev'. This netdev has an ifindex of 0=
 because
> > > > > > it is not registered.
> > > > > >
> > > > > > <CPU0, t3> - After softirq finished executing, your route get r=
equest
> > > > > > from t0 is resumed and the old dst entry is dumped to user spac=
e with
> > > > > > ifindex of 0.
> > > > > >
> > > > > > I tested this on my system using your script to generate the ro=
ute get
> > > > > > requests. I pinned it to the same CPU forwarding packets throug=
h the
> > > > > > nexthop. To constantly invalidate the cache I created another s=
cript
> > > > > > that simply adds and removes IP addresses from an interface.
> > > > > >
> > > > > > If I stop the packet forwarding or the script that invalidates =
the
> > > > > > cache, then I don't see any '*' answers to my route get request=
s.
> > > > >
> > > > > Thanks for the reply and analysis Ido, I tested with an additiona=
l script which
> > > > > adds and deletes a route in a loop, as you also saw this increase=
d the
> > > > > frequency of blackhole route replies from the first script.
> > > > >
> > > > > Questions:
> > > > >
> > > > > 1. We saw this behavior occurring with TCP connections traversing=
 our routers,
> > > > > though I was able to reproduce it with only local route requests =
on our router.
> > > > > Would you expect this same behavior for TCP traffic only in the k=
ernel which
> > > > > does not go to userspace?
> > > >
> > > > Yes, the problem is in the input path where received packets need t=
o be
> > > > forwarded.
> > > >
> > > > >
> > > > > 2. These blackhole routes occur even though our main routing tabl=
e is not
> > > > > changing, however a separate route table managed by bird on the L=
inux router is
> > > > > changing. Is this still expected behavior given that the ip-rules=
 and main
> > > > > route table used by these route requests are not changing?
> > > >
> > > > Yes, there is a per-netns counter that is incremented whenever cach=
ed
> > > > dst entries need to be invalidated. Since it is per-netns it is
> > > > incremented regardless of the routing table to which your insert th=
e
> > > > route.
> > > >
> > > > >
> > > > > 3. We were previously rejecting these packets with an iptables ru=
le which sent
> > > > > an ICMP prohibited message to the sender, this caused TCP connect=
ions to break
> > > > > with a EHOSTUNREACH, should we be silently dropping these packets=
 instead?
> > > > >
> > > > > 4. If we should just be dropping these packets, why does the kern=
el not drop
> > > > > them instead of letting them traverse the iptables rules?
> > > >
> > > > I actually believe the current behavior is a bug that needs to be f=
ixed.
> > > > See below.
> > > >
> > > > >
> > > > > > BTW, the blackhole netdev was added in 5.3. I assume (didn't te=
st) that
> > > > > > with older kernel versions you'll see 'lo' instead of '*'.
> > > > >
> > > > > Yes indeed! Thanks for solving that mystery as well, our routers =
are running
> > > > > 5.1, but we upgraded to 5.4-rc2 to determine whether the issue wa=
s still
> > > > > present in the latest kernel.
> > > >
> > > > Do you remember when you started seeing this behavior? I think it
> > > > started in 4.13 with commit ffe95ecf3a2e ("Merge branch
> > > > 'net-remove-dst-garbage-collector-logic'").
> > > >
> > > > Let me add Wei to see if/how this can be fixed.
> > > >
> > > > Wei, in case you don't have the original mail with the description =
of
> > > > the problem, it can be found here [1].
> > > >
> > > > I believe that the issue Jesse is experiencing is the following:
> > > >
> > > > <CPU A, t0> - Received packet A is forwarded and cached dst entry i=
s
> > > > taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()
> > > >
> > > > <t1> - Given Jesse has busy routers ("ingesting full BGP routing ta=
bles
> > > > from multiple ISPs"), route is added / deleted and rt_cache_flush()=
 is
> > > > called
> > > >
> > > > <CPU B, t2> - Received packet B tries to use the same cached dst en=
try
> > > > from t0, but rt_cache_valid() is no longer true and it is replaced =
in
> > > > rt_cache_route() by the newer one. This calls dst_dev_put() on the
> > > > original dst entry which assigns the blackhole netdev to 'dst->dev'
> > > >
> > > > <CPU A, t3> - dst_input(skb) is called on packet A and it is droppe=
d due
> > > > to 'dst->dev' being the blackhole netdev
> > > >
> > > > The following patch "fixes" the problem for me:
> > > >
> > > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > > index 42221a12bdda..1c67bdb80fd5 100644
> > > > --- a/net/ipv4/route.c
> > > > +++ b/net/ipv4/route.c
> > > > @@ -1482,7 +1482,6 @@ static bool rt_cache_route(struct fib_nh_comm=
on *nhc, struct rtable *rt)
> > > >         prev =3D cmpxchg(p, orig, rt);
> > > >         if (prev =3D=3D orig) {
> > > >                 if (orig) {
> > > > -                       dst_dev_put(&orig->dst);
> > > >                         dst_release(&orig->dst);
> > > >                 }
> > > >         } else {
> > > >
> > > > But if this dst entry is cached in some inactive socket and the net=
dev
> > > > on which it took a reference needs to be unregistered, then we can
> > > > potentially wait forever. No?
> > > >
> > > Yes. That's exactly the reason we need to free the dev here.
> > > Otherwise as you described, we will see "unregister_netdevice: waitin=
g
> > > for xxx to become free. Usage count =3D x" flushing the screen... Not
> > > fun...
> > >
> > >
> > > > I'm thinking that it can be fixed by making 'nhc_rth_input' per-CPU=
, in
> > > > a similar fashion to what Eric did in commit d26b3a7c4b3b ("ipv4: p=
ercpu
> > > > nh_rth_output cache").
> > > >
> > > Hmm... Yes... I would think a per-CPU input cache should work for the
> > > case above.
> > > Another idea is: instead of calling dst_dev_put() in rt_cache_route()
> > > to switch out the dev, we call, rt_add_uncached_list() to add this
> > > obsolete dst cache to the uncached list. And if the device gets
> > > unregistered, rt_flush_dev() takes care of all dst entries in the
> > > uncached list. I think that would work too.
> > >
> > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > index dc1f510a7c81..ee618d4234ce 100644
> > > --- a/net/ipv4/route.c
> > > +++ b/net/ipv4/route.c
> > > @@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common
> > > *nhc, struct rtable *rt)
> > >         prev =3D cmpxchg(p, orig, rt);
> > >         if (prev =3D=3D orig) {
> > >                 if (orig) {
> > > -                       dst_dev_put(&orig->dst);
> > > +                       rt_add_uncached_list(orig);
> > >                         dst_release(&orig->dst);
> > >                 }
> > >         } else {
> > >
> > > + Martin for his idea and input.
> > The above fix should work and a simple one liner for net.
> > percpu may be a too big hammer for bug fix.
> > It is only needed for input route?  A comment would be nice.
> >
> > While reading around, I am puzzling why a rt has to be recreated
> > for the same route.  I could be missing something.
> >
> > I don't recall that is happening to ipv6 route even that tree-branch's
> > fn_sernum has changed.
> >
> > It seems v4 sk has not stored the last lookup rt_genid.
> > e.g. __sk_dst_check(sk, 0).  Everyone is sharing the rt->rt_genid
> > to check for changes, so the rt must be re-created?
> >
> I think the reason rt has to be created is v4 code uses per net
> rt_genid. So changes to any route in the namespace will invalidate all
> other routes. (As David pointed out in his email.) However, v6 code
> uses per fib_node fn_sernum, and has a way to only invalidate route
> that are affected. (fib6_update_sernum_upto_root())
> And v4 code not caching rt_genid seems to be separate issue, I think...
Understood that v6 impact is smaller on route changes because there is per
fib6_node fn_sernum.

AFAICT, even for the route that are affected by fib6_update_sernum_upto_roo=
t(),
I don't see the RTF_PCPU route is re-created.  v6 sk does
dst_check() =3D> re-lookup the fib6 =3D>
found the same RTF_PCPU (but does not re-create it) =3D>
update the sk with new cookie in ip6_dst_store()

>=20
>=20
> > >
> > > > Two questions:
> > > >
> > > > 1. Do you agree with the above analysis?
> > > > 2. Do you have a simpler/better solution in mind?
> > > >
> > > > Thanks
> > > >
> > > > [1] https://lore.kernel.org/netdev/CANSNSoVM1Uo106xfJtGpTyXNed8kOL4=
JiXqf3A1eZHBa7z3=3Dyg@mail.gmail.com/T/#medece9445d617372b4842d44525ef0d3ba=
1ea083
