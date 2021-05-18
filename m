Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21116386FE4
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 04:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240089AbhERCVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 22:21:35 -0400
Received: from mail-eopbgr1320121.outbound.protection.outlook.com ([40.107.132.121]:2626
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237658AbhERCVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 22:21:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQmAlrAGXYN8kPXSOg8DSxwChQ1+pdU3ffxh87kP/MAaf0KeC0hd1BaqT0sDlQ3ZAAjnOTl4aF3bE89VC7L4hEpukuUwoJzlclXHGyfuhh0uPlg2vDBEaqWK8NnihN/IY/cTeHDOf1kQqP4CWd8Mzu8AnH+GsFTXvGPwRNNgq09PO4LKjta8cZF3+W7bFghetmKOql6GgOFy5pr2u4Fdrs0xzj4SJPm+7BQ65sb5iSn6k9PkAmRy8pHrl60H8i2hZT7vNFwQikDNlRizO9C1xj6sF906MvmIDOEu08Suk9b7jOYXHuJLG23rnms1zq/jDLY8PpIPGYMAQmZciEHNsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+BNbyS3ogmImMR4G08jEPTqsfwAgFNa0dHwIR5XtxY=;
 b=W7pk5xx8NU+PDRk7mnC+EtFuysFMZ3jWgjzcaQy9BktqTFaJ16szvkJhOWT9qEQUjBxQPh/6XRUIrW67duR+D7QM+kW0nXeqmsrJUnDx4ElBu4gUfpS4Kjjm9zoZ4wFw9N5Y5h6DIS5XK10JZyDOJEpH/Pg6Sth8lb64dwibM7x5+JpotGnTU0gxESVeoQMgBB4G0SLbGPBZtBWlibhHYf/PiHlf6qdcD7j6C+9LzG7PRJX12UTTi4Wcn88fET8rOW7Ifuj+Oh3It4ghd80BAapr6y0mKBbI8siHXefNo89Fa6dGbbAwQzBX9B+++lyxhpEifGFlsMxjVGbofjGL9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+BNbyS3ogmImMR4G08jEPTqsfwAgFNa0dHwIR5XtxY=;
 b=gRpaKmPFgff8FH+2Tv1wUjD9IvA5RPyPl6SQF36W2fhQFKsFpWIJIgHsCKXpOxvTDAJ5jvHjRXgVMAh9QukQMZxAcjonaYgUz28Fy3DBRSWLmi3+C0O5n5/ADGsnqhOlpO3Tb8cBZ0omU+MBZMq3qFJecZVMiU+rn+/R7MDMBx8=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY2PR01MB3515.jpnprd01.prod.outlook.com (2603:1096:404:d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 02:20:12 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::e413:c5f8:a40a:a349]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::e413:c5f8:a40a:a349%4]) with mapi id 15.20.4129.031; Tue, 18 May 2021
 02:20:12 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
Thread-Topic: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
Thread-Index: AQHXNmo4snkvFkzf+kiCjGV8r1I+Z6raKfAAgADjaICAAZGPAIALm+wAgABtBaA=
Date:   Tue, 18 May 2021 02:20:12 +0000
Message-ID: <TY2PR01MB369233B20CC5A48072BA474CD82C9@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
 <68291557-0af5-de1e-4f4f-b104bb65c6b3@gmail.com>
 <04c93015-5fe2-8471-3da5-ee85585d9e6c@gmail.com>
 <TY2PR01MB369211466F9F6DB5EDC41183D8549@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <0ce3a5e2-8e42-3648-83c3-fea7b1147b5a@gmail.com>
In-Reply-To: <0ce3a5e2-8e42-3648-83c3-fea7b1147b5a@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:50c0:3460:71a2:ab8f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a80efc8-f168-482d-018a-08d919a3775a
x-ms-traffictypediagnostic: TY2PR01MB3515:
x-microsoft-antispam-prvs: <TY2PR01MB35159B067640E7CFD2849D50D82C9@TY2PR01MB3515.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ge8MSOMf/vY9vINk9YsVE9WcKgKnP7O7JZ2SNQ33JFgrXhANuHZgTFZQ2+baA4A8CRb5zmDm5Yp6fpiP7RVHYpOReb5ejYVRX0iLmsxslR079Ob4BBv1/OssF2l+/lA8z14DnKsU3mrWCvVVXrcLPGaHsH/5W166hGGaMomNPapKMVGD9M8au0mK3h/8ijDiS+HBR992/DT6uI5+6ud0vktvLJDdHSMhlhaYZluWR8WbfEgyhrrDvRREMTmNNitFxcNwaxrDfYb4qklLkI5hIXcX2iWU6UCQTzXnGIg9vmmmiaw8USszu8oq8SWpP3cUsG8HckAFHBkNZr+8h/KJ7qiSlITQGHn00SfUuy/K6nV8+JwNaOF6U5lSSJ3ttF4T5JAX+m9HZoKI5DUi4o5oitl7mZQg2pkafLQ1Z1E/wZXt8ggy49M41mjqPlA6L8ZG6TNpAySZ3TT6J2uhDeUbxFFklxhp2pzGuW2ST6y1ARvdYGUte1dgmLfUzZMd7H3Zh9HqwPF4xUZlCi+JKjOz4QOpWMNklNr7Xt9WgEa58IBjeDRGNs3/sw0VpusdB3Meb+85oXmX8fU+gpAkTtq5yXsK2jilUnx0M2/Kk+1idIhRD2YH5oYg1bqSPJKQEeNG1L4vccCtovxWNmqPoh50qFW3rlid7mGpaXFBW0IAZL6rM266K6EwPPVNdYd4o2+qYOsfxY14vskEYusVTsy+1+VfmMtzeyAOZcOZGz0e15oiRtljQltSrtAxKchpLmLb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(76116006)(122000001)(83380400001)(33656002)(7696005)(71200400001)(6506007)(66556008)(45080400002)(966005)(316002)(478600001)(66476007)(186003)(54906003)(6916009)(52536014)(8936002)(5660300002)(64756008)(86362001)(53546011)(4326008)(66946007)(8676002)(38100700002)(2906002)(66446008)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UtRGBZF8Plt8e0R3QdF1OwNdhyo7nIi0pKKORa5Z/JFjUpuhgE1TQ2H6yOU3?=
 =?us-ascii?Q?RuEI/XZjCBI1JQl8kUOyz7FqCUc5PyZ68VggO6z4pOVFusGD/QVnUJjhzB2G?=
 =?us-ascii?Q?Vn5VHlGgx44e0ddIRULHdMM5LJCOeA+Q6Z6yAli2114DkOBNq7BUBD9bXhnq?=
 =?us-ascii?Q?XjwyYb1iOzi0dktTv9DLNcL+9BFC6t8wtb6vXTSN5dD7XTzlvsVm3SfV5wZ5?=
 =?us-ascii?Q?MA8yq3z6eGleMQp1Wrv3i3i0Y3m7oNTlSltLVX2QxYtxCj+GDLdJty22g3O+?=
 =?us-ascii?Q?mprnHN3XPayuDPtPzayAF/HiaMYHAhNEeewGsfkCMyKcLJ1Mwf77Bldq+JYA?=
 =?us-ascii?Q?jAohF6qfjVJHNQgEMaD+Xk7E7KSgEDcGkySzuc4X8BqRm8F350p3HLLFebiV?=
 =?us-ascii?Q?XAV+svY0l1j+2LsTB06CqTtdR7UWh2xz8hncpkKaJGICD7ppmoH4RyD6Kw58?=
 =?us-ascii?Q?caL4km9lXzzKnoXz43rp8EdzCDIqtfMp9C2L+QYkKUFVUuXZHTjlkvj71W5F?=
 =?us-ascii?Q?wYSQ79SmKd5RJbO/ih5yP8ELR77TAQIE8pWKDQLsonGfCiSCWGI4wtglhYuI?=
 =?us-ascii?Q?iRyCEzrts5R8JHpflXeDWlI1TBWzmSoG3HWlhup+h4Eo7dt2WYwv0enYBRC7?=
 =?us-ascii?Q?vmdzxVoQnzFtyOIbPJ7f/H/tjQdfhiw/Mbj17BBm7HGLRgdCdhkkjAk2fudk?=
 =?us-ascii?Q?oBsk3R6z8UlHnS3u76WBNCKzc4xzwEYCSBs7d75tSy5Zk0wa++5dx0lRdpvj?=
 =?us-ascii?Q?pv3GdTHCf/yXBWzl18vRB+sW54DaxSQoenEvjTSuHp4F3oYpU6aC/G/ejFuO?=
 =?us-ascii?Q?cy3YDDOboYfBhLSU1xPiEYsdYFIz+4uE4P2+xpGuEdoAOyKedyVHFcWYz6JR?=
 =?us-ascii?Q?yf/cwoEiSimzlJHr/pSSPzyVFVWdzQ/jqAPTIa30fQbtFizJiujlst9Ku5F4?=
 =?us-ascii?Q?uj9nv/q2jyznXVQ7BqLS122qjVFSYrzajulVwPkj7ocTbmkRSJtXSHCAOP7w?=
 =?us-ascii?Q?gfCuupJZLi4vOPuRpWLEBFCDMR53a9ddA4QneR5Cd/zG+0tLK3E6QtF9PmCm?=
 =?us-ascii?Q?iLuZWj37d4VMUrLAi6bYML7IIU7ej8noMFCg1WbPFaCD0HWguOfNoNbLvXBw?=
 =?us-ascii?Q?AYzw5HckXoU3mmqh5nwgCMtubeCPSpDqBIkmJLNsPqOX2CSVgKQYTk4cPZww?=
 =?us-ascii?Q?6sE9TChlup2JpFUehFXoJ065vP0nlH5m73DdAAp9Hjd5ZDEvJxL6WsIxgplu?=
 =?us-ascii?Q?wRrayekq5OtuileqMtpm+xpvftZQeX16/2q0oyK1GeR40DGoh927ff/2XC86?=
 =?us-ascii?Q?1nt+e4jy+hD8FahwUjd5MSUWTqqOK0fMdCE7PlNmoiTzOwQbiA2jRQQ0C3sj?=
 =?us-ascii?Q?sEcKPHM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a80efc8-f168-482d-018a-08d919a3775a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2021 02:20:12.0957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cKzhXZ3JACk2BS53sZLIGccpvY9TosZtZjLtbxuLawcnNVzqlbr66odH34womqnlUKcqCwDz07g/tMujZ1jaq0ue1r5iL8kTG97AupyJ45dClgIBIryG6QIOxiwO01Xe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3515
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

> From: Sergei Shtylyov, Sent: Tuesday, May 18, 2021 4:36 AM
>=20
> On 5/10/21 1:29 PM, Yoshihiro Shimoda wrote:
>=20
> >>>     Posting a review of the already commited (over my head) patch. It=
 would have
> >>> been appropriate if the patch looked OK but it's not. :-/
> >>>
> >>>> When a lot of frames were received in the short term, the driver
> >>>> caused a stuck of receiving until a new frame was received. For exam=
ple,
> >>>> the following command from other device could cause this issue.
> >>>>
> >>>>      $ sudo ping -f -l 1000 -c 1000 <this driver's ipaddress>
> >>>
> >>>     -l is essential here, right?
> >
> > Yes.
> >
> >>>     Have you tried testing sh_eth sriver like that, BTW?
> >>
> >>     It's driver! :-)
> >
> > I have not tried testing sh_eth driver yet. I'll test it after I got an=
 actual board.
>=20
>    Now you've got it, let's not rush forth with the fix this time.

I sent a report yesterday:
https://patchwork.kernel.org/project/linux-renesas-soc/patch/20210421045246=
.215779-1-yoshihiro.shimoda.uh@renesas.com/#24181167

> >>>> The previous code always cleared the interrupt flag of RX but checks
> >>>> the interrupt flags in ravb_poll(). So, ravb_poll() could not call
> >>>> ravb_rx() in the next time until a new RX frame was received if
> >>>> ravb_rx() returned true. To fix the issue, always calls ravb_rx()
> >>>> regardless the interrupt flags condition.
> >>>
> >>>     That bacially defeats the purpose of IIUC...
> >>                                            ^ NAPI,
> >>
> >>     I was sure I typed NAPI here, yet it got lost in the edits. :-)
> >
> > I could not understand "that" (calling ravb_rx() regardless the interru=
pt
> > flags condition) defeats the purpose of NAPI. According to an article o=
n
> > the Linux Foundation wiki [1], one of the purpose of NAPI is "Interrupt=
 mitigation".
>=20
>    Thank you for the pointer, BTW! Would have helped me with enabling NAP=
I in sh_eth
> (and ravb) drivers...
>=20
> > In poll(), the interrupts are already disabled, and ravb_rx() will chec=
k the
> > descriptor's status. So, this patch keeps the "Interrupt mitigation" II=
UC.
>=20
>    I think we'll still have the short race window, described in section 5=
.1
> of this doc. So perhaps what we should do is changing the order of the co=
de in
> the poll() method, not eliminating the loops totally. Thoughts?

The ravb hardware acts as "non-level sensitive IRQs". However, fortunately,
the hardware can set an interrupt flag even if the interrupt is masked.
So, I don't think this patch have any race window.

Best regards,
Yoshihiro Shimoda

> > [1]
> >
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwiki.=
linuxfoundation.org%2Fnetworking%2Fnapi&amp;d
> ata=3D04%7C01%7Cyoshihiro.shimoda.uh%40renesas.com%7C0102c1f2995947bcca16=
08d9196af978%7C53d82571da1947e49cb4625a166a4a
> 2a%7C0%7C0%7C637568769530134169%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM=
DAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6
> Mn0%3D%7C1000&amp;sdata=3D47kgAmI3d%2Fz%2BHunT0a8bzHRRQk1VdnxRETSExLkTrdI=
%3D&amp;reserved=3D0
> >
> > Best regards,
> > Yoshihiro Shimoda
>=20
> MBR, Sergei
