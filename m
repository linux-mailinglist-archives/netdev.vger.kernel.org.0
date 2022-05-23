Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175D7531ECE
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiEWWtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiEWWtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:49:49 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30068.outbound.protection.outlook.com [40.107.3.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110A05A14C
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 15:49:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMo4tgYi4XBIbeNKpfcaWVLXK6y6N8Jhl7Rzzw85sJpiW7maI1ZpJLNICDR5BQ7kO22U6tHl78NhtgNkHDB+5K2vL9yMwzC46k7jWJTEdk/kW4CqxBpzdx+qAguMoH8HiY1tjAF2H59RbEpmg4wtz4wO9RhDoaW4CyPO97A50+AlQ1+A1qvrtsush1udvTp4pXXnn5tDTzZ9CmmA3+dn2Dk4vs+gLOeFUhI2cJFvvt8Kx1XjlMuknXiPtCrhVpcbrDSqAu7jQjiqtiV+n9P+TSGEc6r95aw6/6W1YeA9qPmXJrZdU2jBZb17YezstE5KVUwWEbWqEJvkk8UCTxLxRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZr2wxuUX/UufRoup0HjTN1h6DuxkzDVhCxcnmOyrpc=;
 b=ArE+ZI9IvPPfarXYlQveygoWu+o0WYBY465rMpDPj970fEI2eyvgBpxPU2kfKQIyFc0T44a/oOBRUU8pNTjrRulRq0itmF33tpNQ0wqOvnU6Mlks5m/fX/rnwMYB92z2UrfU1hvg8emolCrshhfCWBctpU16lfxh+JWxWvZznk4p1TbXrectlsS02ED3G4gphfY7Y0zoLH7UIrT+c+nSCDSqUPuEiaq0wX+/0n5FTnopR17fosHvu2Zdld667hQRigfNetJ6MMYr/Zxr7DIURAELBbVXInXY1/jjjI2W7Eh8069OaBrU5jFsrjl3ppDw9cMMeRpXu91AgxJ5u94MkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZr2wxuUX/UufRoup0HjTN1h6DuxkzDVhCxcnmOyrpc=;
 b=fFNU92lpskpKzraKsyNavs39Uf9Y6oBqMaFxVv6/15hL+Dp4w3u2bvGyLYssFq67hdPQ2ryRi3VHvRByum+e2+rQ8iYaXeDtwEtGYP02o4dH1D5/dsXfzHXLw3Hb65bedaevJg377q6qLb4xR7gEAp/26OR2gJFVX1zcq2ND6nQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6744.eurprd04.prod.outlook.com (2603:10a6:20b:f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Mon, 23 May
 2022 22:49:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 22:49:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v5 00/11] ethtool: Add support for frame
 preemption
Thread-Topic: [PATCH net-next v5 00/11] ethtool: Add support for frame
 preemption
Thread-Index: AQHYa+cqehaWXK64WUeB49V4C8aceq0oW6eAgAEUSACAA3WRAIAACxEAgAAQfgCAABXrgA==
Date:   Mon, 23 May 2022 22:49:44 +0000
Message-ID: <20220523224943.75oyvbxmyp2kjiwi@skbuf>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
 <20220520153413.16c6830b@kernel.org> <20220521150304.3lhpraxpssjxfhai@skbuf>
 <20220523125238.6f73b9f5@kernel.org> <20220523203214.ooixl3vb5q6cgwfq@skbuf>
 <20220523143116.47df6b34@kernel.org>
In-Reply-To: <20220523143116.47df6b34@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5753139-473b-4ec7-05f7-08da3d0e87d3
x-ms-traffictypediagnostic: AM6PR04MB6744:EE_
x-microsoft-antispam-prvs: <AM6PR04MB674451881B27C1C2D096F644E0D49@AM6PR04MB6744.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vZsmh0hZuf3YRCCjC/9mtZeTmY2xPeyfuUMo7ZPNqIRLVwKA0B2SlebQTFblAeYKQupJBAH4oLpirIAtjTyE2kZkHESTylL0LisMYqwrfkSMonONA8B2W2x+jQKDV0XIGaKPFEumuFdM6vA4oVU1FCDgs2pZZYY7KvUz7tGeaRaXp3aOuX+qgo2D5vziT6ta8ssDprIVP5nn1rWZsMYuA6ssQmRdUAYbgGltkZUAq+SCi8jSrK2UnaV9otWysqG5X8MWgpsmx9NKFM6WMvXBErAMkYyb1ILbmZaGu9GDmc/+Vgs3DKmvwjoPYjSeG9QlsQpFpk/wOZT1nvGUyLWoXFfLsVwnbhpiThiGA+sPSyM7+XAvMX6VAW1pV7GBgHGSFW8XD+/jvHkw35SshahdDZvz2Z9anJPwIughbBYAR+VGZwhfmbzKn3NDU/wyUpKx0h33m07Gdc65wjaR3EHdc/qZrm39e72DxkZfpypa+qqs7FqNvoea/u2GGCEhFoWIx4+KBTLb43+c0aoEYgu4az83tXhLrV0xYxRIok1pKybh7JZsxrl1Ao+59XCVigm9BUVnmSzcDUBbP6aprB+FN3tC7ay2+prSGgBHZsAYmjGafOg/qjFUQ/WvEIYRlynskJ515rU39rTEugPILvigjX6PIU/r0AXubzvWVLqRxpOHAqlkLtKahGMWZi6PHcuimOigO3KLFCieKSTl+JGqueYxb8wl9/cJR51xzzIdiUr4/mG5NInQlJHbbjWTfyBYXgeEmvu8ZFWoXnrU3L8JE6D/Qmw0cs+N6U6LwLHgyBY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(2906002)(1076003)(4326008)(8676002)(186003)(316002)(54906003)(76116006)(86362001)(91956017)(5660300002)(6916009)(122000001)(966005)(6486002)(6512007)(6506007)(38070700005)(38100700002)(44832011)(66946007)(71200400001)(508600001)(66476007)(66556008)(9686003)(64756008)(66446008)(33716001)(8936002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SUX59qhnuRj8ql1Xt6nId794mV5JXxH0mr8W03dmbAbU0yzmg6v+uGVYoy0m?=
 =?us-ascii?Q?t5pHl2V3+Z65VkV7IlZ8SWobfH9HbazVeHPgslQtNi+v4J5fNSp/vF06Kj5q?=
 =?us-ascii?Q?hehQjDogqTQM9c0CFtgQDNCMYFHmImfWSG/F4qdTEhX0OaRBQ26Vm7CHVmzL?=
 =?us-ascii?Q?Iwi282xmiIlQpJYo4m+CvK3uRiKbuyd5JXyajrEnlUJPdGSViWRHVQzwWwcd?=
 =?us-ascii?Q?aVQMt203/IadalzqvNyOuMTMH76h5nWoiwzbzpVbiIrK9B0HR1RmFvS6ZuLT?=
 =?us-ascii?Q?ByIHo+EdvkXJneOYHhJHzHnAS8FZzUr3iHS9kSoSilxdphT3PIJJH6c0sV4c?=
 =?us-ascii?Q?PltlvrDBqqIm3gJcgemgqm/gRVcp6LK4gBnip1cagg6A0HzheTe0zDIQUXjl?=
 =?us-ascii?Q?gHKDjk7VdR/humtFT5N5S3Tu8Xwoel45i0CSUODtD1zxeeyR9PAx+bhJGkU4?=
 =?us-ascii?Q?fk8h6/jRCWVnWHdGemxtcHVzF5pskBvkXTziZgUWu3kAz3SYBdShTqd69GCL?=
 =?us-ascii?Q?qlnNPAFLA5+9y/uNW+BrzUsvqAUCGKMSqZ7DJwAtJkO4YjXgw21YYG4Tdyhr?=
 =?us-ascii?Q?x1h++kukQt5B3LoJtcS1/1AFFzSmvDltcNrl9vBb/BRE16aM0lSmFBQV7psi?=
 =?us-ascii?Q?kE19Apv680uGMPlC3k+rNgjUuK6u8BLjXfEuZg2oKHWQxBYk+C2Fy481Wq1O?=
 =?us-ascii?Q?8NEgdN/j1CdGdImgB4pA4/TvPvb8km9Qd/yCEYACHTqevPG96UfUkHGcgq5c?=
 =?us-ascii?Q?DiUoMJHhu570BRnskQf+88fqWwOAEQJua6VaFgEm0HYTzQtZ9SWwI7/lrTbf?=
 =?us-ascii?Q?PXrEieJk19TuWD539HsVlo+5tgUh6Slef9mFN+O7ODxm6jo8XAbmImWBr3b6?=
 =?us-ascii?Q?sYXWv8tHU+RUK0TCT/hf3LBP/7V2Y22+M3pgLOO0TcL5ZdrHTXjw3pk00Zpw?=
 =?us-ascii?Q?vWIR5ldMC8jfQ7INJZqYMcbcQX3WU8vPGLpuxF5YedOWFpdcZRsdg+zlgDl1?=
 =?us-ascii?Q?rL+s8c1Z55XDaeSYpt+Vwg2f/Fh/lki1zVCGhTOWp8/Lb8HqoVC+nMxjUoiK?=
 =?us-ascii?Q?qIzIAyG8hMYbgjM68qpY1QNszH80S+c9JG64e1lMXdokZsRXnsYqVPKgUEsB?=
 =?us-ascii?Q?ExXPSW9xPBFIe0tzkMkxWTbutc32rXR5f2bqQgtTAEiQ+V1iMXo88rxm6AT0?=
 =?us-ascii?Q?lhdBbCQ3j4cL245B5Ud5OfIIQnaddNRxHxHUJlOg6G+4F4zGPjOs7zYe55vy?=
 =?us-ascii?Q?8vFuwGUJFCwDp5b4evXGy4KnJR63p4bT3cPUmVbRrVdaMT9zMAVI6sHBvcP+?=
 =?us-ascii?Q?lpMIKkuyaJ5q+v4SHNVECz4tGlj74Vid70IrQ20yx/sQP8IP3Yd83gLmOzJv?=
 =?us-ascii?Q?xvB4/RLEnlmOHhFL87dRhVTCmMkcOQoWGxA5dD3nIH5ZyAGGweM+N+Ue2xdD?=
 =?us-ascii?Q?3zT7FqBm0esL5VrZC8rafqsPPX31cuxMpNmOqq7cBk5uk1khUkdZW2Djj24e?=
 =?us-ascii?Q?jKXqXJjZSMy5Y/Km0aOZ4qlTCnmt02oHXgQvJO8ODOM6a/H8OHehQEQ/QzUt?=
 =?us-ascii?Q?lZCtiXmAQvWd/OWk9PtB5oOhyXz49KXJCvStnahRkcdAGwEa96Akp8yeXXyD?=
 =?us-ascii?Q?0CSNG7/0TFeCdXZA5WtLNc9+8V2fKP5/rVYYXb7q9oDsf6HXRjszqxI0583S?=
 =?us-ascii?Q?U7HlhOn83ZhaL7tfpQjGFqLTVvnh8mX9+9LKUvJLMjkC6ZLnitlW7M5Q4obH?=
 =?us-ascii?Q?QCs5mxs+0YB7JSHOOWY92ni2gXi4jVs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <128474833B0CBB40B055F3A15AD1B9AC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5753139-473b-4ec7-05f7-08da3d0e87d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 22:49:44.3780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lY6BJA218BYwYl7XvcqPDuMe4AFClf42ACgjqWM7WKhOyGGxkHwAWnZdhH01dUONFhfLZj5puylfX3yz9fOXug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6744
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 02:31:16PM -0700, Jakub Kicinski wrote:
> > > If we wanted to expose prio mask in ethtool, that's a different story=
. =20
> >=20
> > Re-reading what I've said, I can't say "I was right all along"
> > (not by a long shot, sorry for my part in the confusion),
>=20
> Sorry, I admit I did not go back to the archives to re-read your
> feedback today. I'm purely reacting to the fact that the "preemptible
> queue mask" attribute which I have successfully fought off in the
> past have now returned.
>=20
> Let me also spell out the source of my objection - high speed NICs
> have multitude of queues, queue groups and sub-interfaces. ethtool
> uAPI which uses a zero-based integer ID will lead to confusion and lack
> of portability because users will not know the mapping and vendors
> will invent whatever fits their HW best.

I'm re-reading even further back and noticing that I really did not use
the "traffic class" term with its correct meaning. I really meant
"priority" here too, in Dec 2020:
https://patchwork.kernel.org/project/netdevbpf/cover/20201202045325.3254757=
-1-vinicius.gomes@intel.com/#23827347

I see you were opposed to the "preemptable queue mask" idea, and so was
I, but apparently the way in which I formulated this was not quite clear.

> > but I guess the conclusion is that:
> >=20
> > (a) "preemptable queues" needs to become "preemptable priorities" in th=
e
> >     UAPI. The question becomes how to expose the mask of preemptable
> >     priorities. A simple u8 bit mask where "BIT(i) =3D=3D 1" means "pri=
o i
> >     is preemptable", or with a nested netlink attribute scheme similar
> >     to DCB_PFC_UP_ATTR_0 -> DCB_PFC_UP_ATTR_7?
>=20
> No preference there, we can also put it in DCBnl, if it fits better.

TBH I don't think I understand what exactly belongs in dcbnl and what
doesn't. My running hypothesis so far was that it's the stuff negotiable
through the DCBX protocol, documented as 802.1Q clause 38 to be
(a) Enhanced Transmission Selection (ETS)
(b) Priority-based Flow Control (PFC)
(c) Application Priority TLV
(d) Application VLAN TLV

but
(1) Frame Preemption isn't negotiated through DCBX, so we should be safe th=
ere
(2) I never quite understood why the existence of the DCBX protocol or
    any other protocol would mandate what the kernel interfaces should
    look like. Following this model results in absurdities - unless I'm
    misunderstanding something, an extreme case of this seems to be ETS
    itself. As per the spec, the ETS parameters are numTrafficClassesSuppor=
ted,
    TCPriorityAssignment and TCBandwidth. What's funny, though, is that
    coincidentally they aren't ETS-specific information, and we seem to
    be able to set the number of TCs of a port both with DCB_CMD_SNUMTCS
    and with tc-mqprio. Same with the priority -> tc map (struct ieee_ets :=
:
    prio_tc), not to mention shapers per traffic class which are also in
    tc-mqprio, etc.

My instinct so far was to stay away from adding new code to dcbnl and I
think I will continue to do that going forward, thank you.

> > (b) keeping the "preemptable priorities" away from tc-qdisc is ok
>=20
> Ack.
>=20
> > (c) non-standard hardware should deal with prio <-> queue mapping by
> >     itself if its queues are what are preemptable
>=20
> I'd prefer if the core had helpers to do the mapping for drivers,=20
> but in principle yes - make the preemptible queues an implementation
> detail if possible.

Yeah, those are details already.=
