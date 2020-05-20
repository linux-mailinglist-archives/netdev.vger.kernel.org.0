Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4351DC00E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgETUYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:24:49 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:50070
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726827AbgETUYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 16:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsRPnPwxjvUir6+hcRoUvHXI25aOcgPvTDUqDnmySWJ6t6VrG2YteXfV+jxB5nGCQ+YBUZ0VVQ33LMZlRXow9YCawcpkZn5xIv69LAq3s1FbT1h+vNbK/l3sUBM61AzaY7d1zK2fDdomQbDM2WgYUXQpJFB7vJAkMrSi/5oi0Sdu+GZ1oqQcpLb4HIk+mWme5Lk5kINMaDBmZDQknUN7VwvbykCztXb7yHBgLtbhSpzxFcgfHnFMttsYMF6kOOvqTjeE0ZKXChdB9nDtx+yhUidPaaxdO+kXcn4hJ3xdtDqz2+YJb1A3xhXH1ZwHtdOguTq9QU8Ffkp8Td1A3DXriw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqvlIjg7qaF7JCVZ9gRUR5CCzNmRpqPTplkDcdAxTCo=;
 b=eyCDl+C/Af3Ar9XDRPZmKIQ2IsKLsu1mhLIeEuKW/TVvACFIHhQiDY4LKhd2vOpSwzACbGf0s4GHxoyxzpdMJdTP/v0q9vRTxnUJu3aHCAm7CyTnFZPheiwcKwZCBs7GykFfUPPr3dcmRTvoVOyqwj5PzS20Um6/vFMIvFlf5yvG0FJPgvrB3HxxjrHkds+vWOdgZocHGKl9wApzylvLnwO+2EoIewxB89Uw6UAjUvxkPfNbwWColGAp1aaWl4QFuq/kaS7FGXWOkKDPimU56bU+To+ZjbYjfNyufW08i/ZahepKqDpHCGRWNKysg5NOhNEH9ntR9cp1J+lJCd5jIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqvlIjg7qaF7JCVZ9gRUR5CCzNmRpqPTplkDcdAxTCo=;
 b=a4+rOd7YF5ygaStE3wt1YlfWY4yiF8ZDxHYnvNledqHLB5cnPo4BRj9eVGfesUEGDxvkLMVOKcHBJFqWFQQzdFmEON5eTVP6F0/gizgUxfwvi0AgIyILTVcJYbNc9XlRJ/CmtMxAkTnPlQRzeyTj8k93d0WtYggTOAVYyNDh4mg=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3567.eurprd04.prod.outlook.com
 (2603:10a6:803:c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 20 May
 2020 20:24:43 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3000.033; Wed, 20 May 2020
 20:24:43 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOECAAAN2gIAAEXFggAAcYgCAAKFaYIAD5lUAgADH7GCAALvkAIAAGOkQgAAXEYCAASQ/sIAARkIAgAAAluA=
Date:   Wed, 20 May 2020 20:24:43 +0000
Message-ID: <VI1PR0402MB38710DAD1F17B80F83403396E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200519114342.331ff0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387192A5F1A47C6779D0958DE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200519143525.136d3c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871686102702FC257853855E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200520121252.6cee8674@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520121252.6cee8674@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6eccb466-5ef3-4f9e-c0c6-08d7fcfbd4f2
x-ms-traffictypediagnostic: VI1PR0402MB3567:
x-microsoft-antispam-prvs: <VI1PR0402MB356776D16BC0EC1D5FC6B6D3E0B60@VI1PR0402MB3567.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UdQnF5guPGbLefPm4Mluq/lQAjPiwYbaGDUo/HMSGepJalw1+q7YPDOZhJtQGxf6F/Z/xIq0Wuu2pKqUnOB4M+HmAw5aVAwzSjJ+LG+vScyxozx/DMzJ/dZ/8lhmrvemIp3SmOiLFRzoRpHQSzgfG7oJDBxHk1CsuY3VZSYtOliDXO/xGIMbs9Z5akl6RLx+xUAQJEAiZMgEaDKSLjY8a3I8qubjvoIq1OECJaXYrPJSvquI9/UpzQiM3w6t0G1HUJtK3rchTRwTFjnLS49BXBtOJU4nxEPUVZ54EmpOFRZgaYEHq35lHEBFUGEtFg82+8wb3yG7uFv1Q/KJDAJ+Tg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(86362001)(71200400001)(55016002)(52536014)(316002)(76116006)(66556008)(186003)(26005)(66476007)(54906003)(66946007)(64756008)(478600001)(7696005)(33656002)(66446008)(5660300002)(9686003)(6506007)(6916009)(2906002)(8676002)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: H8cSshgyYEoYEkhxAZuJcUPcdTNfhQFXWNjmM3l5Km4gt+P9LA1qwNWRHbGXc6t7SPL3IHpUy1MG7LERh9FMQet8Dg7u4fPwRcqkCkBg4n/bWAfTykKUfGDwpw5DSW+Woz5OO6bxSkfUc6Op1NeXpPYQvhSvhJC0Jjsjy9t4gqUIo0MrjMyFpX4IidFVaEgFMsdk2tfhpv6ZgiHUIbj6JAutKGSSy2Ia0rhuPh1yiLa3RU7Ap0dIkct0Mhv2gXHoBZ6x+T77CeyhlkU2J/AF06kmxngR/E2CHkhQLWoWNwMaabPNhGIRMPKVcz3j6tRGIx6JUOXoJSkNMQ+/VrFHFx6Kyq6FNExhoq6or2xWoHWZ9a8Ba6DCC1mBK2Umq3iu9WNQW4vtY6AfqMBuwQlasieCl5oKVS0VkwIf2Q096vWRcNYMtb8QOCPidwQYz1eilru68FcXwD71LUUhYSjok6q3b0Gw1BQS2rqEquuqSeKH6wyLCrMEcaAweSOSrbAh
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eccb466-5ef3-4f9e-c0c6-08d7fcfbd4f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 20:24:43.4335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q1synFHcJhL5+sk0ZdOIItmMpdnnmRBG5GUcVGeROKwR25+kpJ4ySq5Jd/vE2p88R/nFFlSjcQWdCZq9sKnsTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3567
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Wed, 20 May 2020 15:10:42 +0000 Ioana Ciornei wrote:
> > DPAA2 has frame queues per each Rx traffic class and the decision from
> > which queue to pull frames from is made by the HW based on the queue
> > priority within a channel (there is one channel per each CPU).
>=20
> IOW you're reading the descriptor for the device memory/iomem address and
> the HW will return the next descriptor based on configured priority?

That's the general idea but the decision is not made on a frame by frame ba=
ses
but rather on a dequeue operation which can, at a maximum, return
16 frame descriptors at a time.

> Presumably strict priority?

Only the two highest traffic classes are in strict priority, while the othe=
r 6 TCs
form two priority tiers - medium(4 TCs) and low (last two TCs).

>=20
> > If this should be modeled in software, then I assume there should be a
> > NAPI instance for each traffic class and the stack should know in
> > which order to call the poll() callbacks so that the priority is respec=
ted.
>=20
> Right, something like that. But IMHO not needed if HW can serve the right
> descriptor upon poll.

After thinking this through I don't actually believe that multiple NAPI ins=
tances
would solve this in any circumstance at all:

- If you have hardware prioritization with full scheduling on dequeue then =
job on the
driver side is already done.
- If you only have hardware assist for prioritization (ie hardware gives yo=
u multiple
rings but doesn't tell you from which one to dequeue) then you can still us=
e a single
NAPI instance just fine and pick the highest priority non-empty ring on-the=
-fly basically.

What I am having trouble understanding is how the fully software implementa=
tion
of this possible new Rx qdisc should work. Somehow the skb->priority should=
 be taken
into account when the skb is passing though the stack (ie a higher priority=
 skb should
surpass another previously received skb even if the latter one was received=
 first, but
its priority queue is congested).

I don't have a very deep understanding of the stack but I am thinking that =
the
enqueue_to_backlog()/process_backlog() area could be a candidate place for =
sorting out
bottlenecks. In case we do that I don't see why a qdisc would be necessary =
at all and not
have everybody benefit from prioritization based on skb->priority.

Ioana
