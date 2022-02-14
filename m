Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E453B4B3EE3
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 02:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbiBNBgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 20:36:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBNBgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 20:36:24 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2128.outbound.protection.outlook.com [40.107.223.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22E6527F7
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 17:36:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9LDISW2s+FtJbLc92MyBAYsLYgC787KMXL7XYPL90xE7/sZK2OG2Xs6wcSpXnwyY+kp8UR+MelIysQ7C5P/VUl/GkQZQVtbh8GpnrE0c9NbBY8Gj+PwSjuMXC8MBiE09epUmrkvN3Jeohls1z3kSqvf+Qxd7ya2H86xXPSnHMa5sC2NXvyZ2D+XT+1DXHIQnUPQ7u7VxsWmHLiGycjJZqDkA6oMGtFcM9sagaGO2j/c1VJLuI3x1ykvbFksfe4BHr6ulU/uhV9csRG3SbXmEX/1bXRmVT5Z8gPnw2HSoCYojK7tWe+Qun+gLCqeSjK9v1PV/JcWK3tnoCko8Wvo3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NeONfjmGMIPRH3AiUC8c/Re+vaDtL+sWM0UcydDnUhQ=;
 b=VpY5rcBh8367qJMsQGjNmbdd7GHmIncWr2O2hp9rTk6Cia61EeF9eZ2i+Xz2wbqg1iBJyJeK2irZQBowu2xHPUBjqpsvEsUxTONlB+qr/FfCMvDRoHg5FyhdTStIVkNlVfYxDDuwW7JBaCkB6cDycKHiibLiuPgNkPt2mfR41BPRjGSBsy1Talsrz7yagSyf4chwkBd3gO0M8z61lP12VkRQxGQfKBBpfYHi5L7w5Cw33+fo9xBobVIuU/dEnuB3oKvY/JBuEjlXj3i+/ODJwXtiMrL5SGym8ldp49XsRumuTEM3RCNYzRDCcop+hSIm5tI4Dzh2oaH5ZRB0ZH2kDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeONfjmGMIPRH3AiUC8c/Re+vaDtL+sWM0UcydDnUhQ=;
 b=pt3emOjg73lR1c3t5jSI+D2RumYeTmVnSMeUVLTkLmzKA/MMBlXU22s4R8ICbZi/Bv6jylYjCcR4BCfdd2p2PXTxsgxGPZtwXPqnHujHEplZylDCxikHI6Ju72flv9ppoOEVFmlDP+n63rvD2zbUxd3nxTh2SmIvTlrjA7dhYhM=
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by MW3PR22MB2138.namprd22.prod.outlook.com
 (2603:10b6:303:4e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Mon, 14 Feb
 2022 01:36:15 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::54ec:7a2b:ad0c:c89]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::54ec:7a2b:ad0c:c89%7]) with mapi id 15.20.4975.015; Mon, 14 Feb 2022
 01:36:14 +0000
From:   "Liu, Congyu" <liu3101@purdue.edu>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "security@kernel.org" <security@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: BUG: potential net namespace bug in IPv6 flow label management
Thread-Topic: BUG: potential net namespace bug in IPv6 flow label management
Thread-Index: AQHYIMSI8GnBA/CCckW7koPG3MiKnKyRpwkAgAB/fwCAABEPgIAAC4nn
Date:   Mon, 14 Feb 2022 01:36:14 +0000
Message-ID: <MWHPR2201MB1072762B0D261313A5D0E5F9D0339@MWHPR2201MB1072.namprd22.prod.outlook.com>
References: <MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com>
 <CA+FuTSeY-GNfBCppjRwhWrOnUg9JDOaesjby2+QbuvPOO5g-=Q@mail.gmail.com>
 <CA+FuTScRGQV5ePxbu7LReuAUc_AU3sQd7Mb8KGVmu+X2jSQSCQ@mail.gmail.com>
 <CA+FuTSc77mc6kwRpA4pvbyK-y5MdaJLkvWMqgXSohGp9XJFibw@mail.gmail.com>
In-Reply-To: <CA+FuTSc77mc6kwRpA4pvbyK-y5MdaJLkvWMqgXSohGp9XJFibw@mail.gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 47596dd2-2942-588b-4f25-539c884970e8
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purdue.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2609ce33-afc1-471c-3a3b-08d9ef5a63ba
x-ms-traffictypediagnostic: MW3PR22MB2138:EE_
x-microsoft-antispam-prvs: <MW3PR22MB213816ED8D0E1CF784C711DCD0339@MW3PR22MB2138.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9LQZroF/4liwog4heAT0rSPEKlmJBJGGHK1hJ4qwB6d+YEJzCrmMqoaBlKOwmzhxal0YMEZYp42R5X5EfbYbzvOFN0hAxiqrtc5lgCcDr1WNJeyJBrCkT8CEMgRruJ41WCO5ji9MhveOQTNUfQq8p7UYf0XfSQEkznR1fbYir22VyOVY2ePqdcWbtgcm+2393zcC0oAzQoqJgGCt9VukKaI3RoGxv8DUknqG3diLDVhGJfK0+jmlu7Zv9DHGObWM7fzzx3l754OW3t6SPR/a8UeaQaGgngEMvvvvsw3Fk6au9quuvrXDZI9rZfH6QZsapGttXUYLrx2pOU+t9XEu51mFYY8uVBrxbEyK1BWTd/77OIyoX04EchLDCQT8VTmZVO8Vr6hN6JFmtmlMvEBT7DD3QJPy1zV1e6kYAOcBP8sSh8uItcP/lVqm00QLotUMbCqnZ6Ak0JyRIILn+nxKWBGVGc4GSxfuZhHdxwNuvinKb7kurhCHtbEKRBakkiTgCOaAJC/49gbQAMLIMU/Wz8rZAPDY5/rEZ+LUKJd5h0vWqZ1xBiyKs6f3625GnU7b5Qw/LwU9tunLRAK8rt2/97m/dsXtDrtYJaj6tsIgquelhnIDkj7ys3GNkW6+yT4skYAXKMzqgiYDR/eV1zSZM4p7uElEQXWAJOsv0p2GeVwry90B38JAML+v610v9XEoHPk9uUbWX4+1+Glpd7srkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38070700005)(83380400001)(6916009)(786003)(316002)(5660300002)(86362001)(54906003)(52536014)(8936002)(75432002)(33656002)(7696005)(55016003)(9686003)(122000001)(66946007)(53546011)(38100700002)(66556008)(66476007)(186003)(8676002)(508600001)(91956017)(76116006)(71200400001)(6506007)(66446008)(4326008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Zc6rEFHFzyUDcs0/8c+Fhc7o9KTmllvBj7vGe/rJyvsh8NenI5r3m8fN52?=
 =?iso-8859-1?Q?9tDTj5kA/eKfcOfvI7E2qPzraELbDe4cfAUtYxhxmERdBmKWOhZOEmWXZa?=
 =?iso-8859-1?Q?SttbkeeTEZrXOgpFeo9wR+FOUqzFLfEYke/ZBaHvWIdu048HJ1Ht6SunU0?=
 =?iso-8859-1?Q?KwSYa3tDNBvGZpl0sTliORfRynzDJGST0c8WJZ5pxG4g19KLsqQsA1oQ0t?=
 =?iso-8859-1?Q?qYe32G2MoyVHhnSdtAmMp9Px2Eme3EexCy8H7COLDxpibI7AFhdIXiirgS?=
 =?iso-8859-1?Q?8IaGe8HHZhv7vGBReSmVujuze3CoERJOESJOhFapnIUznJIFGePCSk2wMr?=
 =?iso-8859-1?Q?d6QfvKI+Yt5QFt/ARR3JpaydHBVTFSFyq3UFEq3EJfMvVJ7oAZbQ1Y7w54?=
 =?iso-8859-1?Q?xu+CXqzaXufgLmRHF0NepktS8ROnWiK73c28Hv53TCuav+k4r7wTo4lOGu?=
 =?iso-8859-1?Q?QXdksrxMdFWVxp5B1edPaHbR5FHZwoVqHgTgNHyC9ClX/CY7OK1jWbo9DA?=
 =?iso-8859-1?Q?m5iwhDPtG5R9BFmvu3wpSLkXe6exG8Hr4rs6ssUu/iFoAN1QRqyzGBSw5+?=
 =?iso-8859-1?Q?VOcY6O33L3f+IJo2vbBJNUlGNem/EW6McRq9eO+61RAGS7jKeaj6cl18E3?=
 =?iso-8859-1?Q?JkgM2aW6R2tP/XPHKAqPwXpy4oWSpvu/Pbz3Mn/aiiBSM1RZCp/GO0eCEd?=
 =?iso-8859-1?Q?HUEJLwAREYMV0hgOUMEg1/gBllNMf9Gk/r45gYVtFv9aYr8P+BXevDwzZC?=
 =?iso-8859-1?Q?UyspB9Jv2NiyqYRmhZ7RbnYTmtYpmrsesuaF/LDxNjL/wUJP+Bx66qIT6r?=
 =?iso-8859-1?Q?LIUOIISFtmBxBqSGpVBMIdvuCZbv2+x4bfXdo31/GccC/6zz7VyIkW6dQI?=
 =?iso-8859-1?Q?PxZ51NXb8o72/3shn4InpgJUsQPUxj3KHK+DanOnivF7Hm2QqHS4vBBSnW?=
 =?iso-8859-1?Q?8voLNx7opE0tKGsJ3xg0DuR4+CKpWlOMjMkdfboSvxWQzERFKi/2bKpkBE?=
 =?iso-8859-1?Q?7zlkcCGDvZJkxkxiWj7h0y3BaWDgm2CQGuFvHfjL2SOu7f/wvSNZp54WfU?=
 =?iso-8859-1?Q?k00xSZ8ZQkL+I4NObhzQTGYQ412hZnJ306mKW22gfQO44lW4Yxyu0MI2bL?=
 =?iso-8859-1?Q?HWOfSngQbm5X+Lo83KKmupPW651o7Ndjcd+UAvmwD6qO/anWWZgRGkPtrk?=
 =?iso-8859-1?Q?imynVOqS8bzS3T/JSB23MHF2QbR8N0OLSyHw53U+bZHacBfpUjU70DSMAL?=
 =?iso-8859-1?Q?/hGBrdIzpxqcOH52v+axo0NE6P3e7jlsRiD5ZYrTHa8hVtTBvoUrtEXerx?=
 =?iso-8859-1?Q?82ETJA0gPKAKSqu6BHn6omjKHdTYVEZ+qZu3li5FdPT5wd/saEgCKWLpwp?=
 =?iso-8859-1?Q?dZlOtKEpqCnT8K4rBs/SVLxC8MQMOxddKjzBn4mCzPY1CoPS4Tm4ntemRQ?=
 =?iso-8859-1?Q?HIMeNniwwiNYEeXOJSldIEKRjr/n7VpbcqA4rg4b5560Rp6VFLat4XoqX8?=
 =?iso-8859-1?Q?vP7dohoc2+4IDWdUsEyvB6g4HnUrPJ68LEMrym/naKyOMKYNpfLMKZtqj4?=
 =?iso-8859-1?Q?SjhCkKHfqtt8+myq6HTookY+PNSjE6K5EhDmqtuxy6gdV+eZa98SqSPE0R?=
 =?iso-8859-1?Q?hkveKEe262Sd+ZQo37jq3Sq+J7/bE8aZDKoKoQKvwQJ4x2ptAFqWB/q1zN?=
 =?iso-8859-1?Q?Aa/UOxE8zaIVIB0OauZvwd2+RGZp5XzzcTN8N+jZ1uoDGx+jV+KHtEINQn?=
 =?iso-8859-1?Q?xOsw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2609ce33-afc1-471c-3a3b-08d9ef5a63ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 01:36:14.3880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +BjpeCqUS5su44SJqvs4bqATeKXcpKlIcjgzGpCSxcMYr7f0QGCCeMBi9Hsooo2uv1lzx0cqdlsMqnOwzucF1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR22MB2138
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you! I just tested the patch using previous PoC. The bug is fixed.=0A=
=0A=
Thanks,=0A=
Congyu=0A=
________________________________________=0A=
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>=0A=
Sent: Sunday, February 13, 2022 19:48=0A=
To: Willem de Bruijn=0A=
Cc: Liu, Congyu; security@kernel.org; netdev@vger.kernel.org=0A=
Subject: Re: BUG: potential net namespace bug in IPv6 flow label management=
=0A=
=0A=
On Sun, Feb 13, 2022 at 6:47 PM Willem de Bruijn=0A=
<willemdebruijn.kernel@gmail.com> wrote:=0A=
>=0A=
> On Sun, Feb 13, 2022 at 11:10 AM Willem de Bruijn=0A=
> <willemdebruijn.kernel@gmail.com> wrote:=0A=
> >=0A=
> > On Sun, Feb 13, 2022 at 5:31 AM Liu, Congyu <liu3101@purdue.edu> wrote:=
=0A=
> > >=0A=
> > >=0A=
> > > Hi,=0A=
> > >=0A=
> > > In the test conducted on namespace, I found that one unsuccessful IPv=
6 flow label=0A=
> > > management from one net ns could stop other net ns's data transmissio=
n that requests=0A=
> > > flow label for a short time. Specifically, in our test case, one unsu=
ccessful=0A=
> > > `setsockopt` to get flow label will affect other net ns's `sendmsg` w=
ith flow label=0A=
> > > set in cmsg. Simple PoC is included for verification. The behavior de=
scirbed above=0A=
> > > can be reproduced in latest kernel.=0A=
> > >=0A=
> > > I managed to figure out the data flow behind this: when asking to get=
 a flow label,=0A=
> > > some `setsockopt` parameters can trigger function `ipv6_flowlabel_get=
` to call `fl_create`=0A=
> > > to allocate an exclusive flow label, then call `fl_release` to releas=
e it before returning=0A=
> > > -ENOENT. Global variable `ipv6_flowlabel_exclusive`, a rate limit jum=
p label that keeps=0A=
> > > track of number of alive exclusive flow labels, will get increased in=
stantly after calling=0A=
> > > `fl_create`. Due to its rate limit design, `ipv6_flowlabel_exclusive`=
 can only decrease=0A=
> > > sometime later after calling `fl_decrease`. During this period, if da=
ta transmission function=0A=
> > > in other net ns (e.g. `udpv6_sendmsg`) calls `fl_lookup`, the false `=
ipv6_flowlabel_exclusive`=0A=
> > > will invoke the `__fl_lookup`. In the test case observed, this functi=
on returns error and=0A=
> > > eventually stops the data transmission.=0A=
> > >=0A=
> > > I further noticed that this bug could somehow be vulnerable: if `sets=
ockopt` is called=0A=
> > > continuously, then `sendmmsg` call from other net ns will be blocked =
forever. Using the PoC=0A=
> > > provided, if attack and victim programs are running simutaneously, vi=
ctim program cannot transmit=0A=
> > > data; when running without attack program, the victim program can tra=
nsmit data normally.=0A=
> >=0A=
> > Thanks for the clear explanation.=0A=
> >=0A=
> > Being able to use flowlabels without explicitly registering them=0A=
> > through a setsockopt is a fast path optimization introduced in commit=
=0A=
> > 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases=0A=
> > exist").=0A=
> >=0A=
> > Before this, any use of flowlabels required registering them, whether=
=0A=
> > the use was exclusive or not. As autoflowlabels already skipped this=0A=
> > stateful action, the commit extended this fast path to all non-exclusiv=
e=0A=
> > use. But if any exclusive flowlabel is active, to protect it, all=0A=
> > other flowlabel use has to be registered too.=0A=
> >=0A=
> > The commit message does state=0A=
> >=0A=
> >     This is an optimization. Robust applications still have to revert t=
o=0A=
> >     requesting leases if the fast path fails due to an exclusive lease.=
=0A=
> >=0A=
> > Though I can see how the changed behavior has changed the perception of=
 the API.=0A=
> >=0A=
> > That this extends up to a second after release of the last exclusive=0A=
> > flowlabel due to deferred release is only tangential to the issue?=0A=
> >=0A=
> > Flowlabels are stored globally, but associated with a netns=0A=
> > (fl->fl_net). Perhaps we can add a per-netns check to the=0A=
> > static_branch and maintain stateless behavior in other netns, even if=
=0A=
> > some netns maintain exclusive leases.=0A=
>=0A=
> The specific issue could be avoided by moving=0A=
>=0A=
>        if (fl_shared_exclusive(fl) || fl->opt)=0A=
>                static_branch_deferred_inc(&ipv6_flowlabel_exclusive);=0A=
>=0A=
> until later in ipv6_flowlabel_get, after the ENOENT response.=0A=
>=0A=
> But reserving a flowlabel is not a privileged operation, including for=0A=
> exclusive use. So the attack program can just be revised to pass=0A=
> IPV6_FL_F_CREATE and hold a real reservation. Then it also does=0A=
> not have to retry in a loop.=0A=
>=0A=
> The drop behavior is fully under control of the victim. If it reserves=0A=
> the flowlabel it intends to use, then the issue does not occur. For=0A=
> this reason I don't see this as a vulnerability.=0A=
>=0A=
> But the behavior is non-obvious and it is preferable to isolate netns=0A=
> from each other. I'm looking into whether we can add a per-netns=0A=
> "has exclusive leases" check.=0A=
=0A=
Easiest is just to mark the netns as requiring the check only once it=0A=
starts having exclusive labels:=0A=
=0A=
+++ b/include/net/ipv6.h=0A=
@@ -399,7 +399,8 @@ extern struct static_key_false_deferred=0A=
ipv6_flowlabel_exclusive;=0A=
 static inline struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk,=0A=
                                                    __be32 label)=0A=
 {=0A=
-       if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key))=0A=
+       if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&=0A=
+           READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))=0A=
                return __fl6_sock_lookup(sk, label) ? : ERR_PTR(-ENOENT);=
=0A=
=0A=
@@ -77,9 +77,10 @@ struct netns_ipv6 {=0A=
        spinlock_t              fib6_gc_lock;=0A=
        unsigned int             ip6_rt_gc_expire;=0A=
        unsigned long            ip6_rt_last_gc;=0A=
+       unsigned char           flowlabel_has_excl;=0A=
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES=0A=
-       unsigned int            fib6_rules_require_fldissect;=0A=
        bool                    fib6_has_custom_rules;=0A=
+       unsigned int            fib6_rules_require_fldissect;=0A=
=0A=
+++ b/net/ipv6/ip6_flowlabel.c=0A=
@@ -450,8 +450,10 @@ fl_create(struct net *net, struct sock *sk,=0A=
struct in6_flowlabel_req *freq,=0A=
                err =3D -EINVAL;=0A=
                goto done;=0A=
        }=0A=
-       if (fl_shared_exclusive(fl) || fl->opt)=0A=
+       if (fl_shared_exclusive(fl) || fl->opt) {=0A=
+               WRITE_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl, 1);=0A=
                static_branch_deferred_inc(&ipv6_flowlabel_exclusive);=0A=
+       }=0A=
        return fl;=0A=
=0A=
Clearing flowlabel_has_excl when it stops using labels is more complex,=0A=
requiring either an atomic_t or walking the entire flowlabel hashtable on=
=0A=
each flowlabel free in the namespace. It can be skipped.=0A=
