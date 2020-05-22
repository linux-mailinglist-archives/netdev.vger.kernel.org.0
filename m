Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E40E1DE869
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 15:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgEVN6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 09:58:45 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:6123
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728947AbgEVN6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 09:58:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gi9s+faNRg1N2It2UNEQ8qFf3LFRwcNqB0fSDZbHy0zF1usShshPcUPp++JAlgcOpGWzpfjH3iGwu0nP/mfSdfQjKHdKwTYdaqiMzamZqIRAeACzM1EnTlHfSJtIbPug2NSQ76/jLzIeRwBGbCv5u4kTaSs2PWgp5cAgDYogijpnYeSCcaw0Z7Q2JLs0dRllxMVbTNe8GaQGa/i3Y+38miecWqVsa6aXHsoSfL6ZwvyNoCDq68aT42fxLwHRVLDyDWFZm4og8pxX0fm9wf0Qh0ZaLuMc3hwnKY5HthbKmAiJGghKDYZCDEzS/ai2P6jv0U7+jvtWbItOM5p9mKuZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6NfQOmx9crMVyer8gIiXxaVJuERlV5PznOkZVznq6k=;
 b=BUuKYm07cxmz7BF0Wl6G1jhSFKkO/t9+pquYev7LJ9VMH3MpQ6cUlYYpdjx7I4psJAHN4Cfo0QK1jySfCX5SAoeja5gt/uNHyBELQld4qCAV5y+qgChZXqAe0CpLkyTEPtOLQHHAntHhFjbTh87qd73EanfyEIMIENAgaw7SvJlnLonRYuXmI3oMY9dTEyABdBDA/2qGCw/3N5whf+iW2thgl0UQGH8x2MiYhj3q9PnoT3LfTHoXWJHYiW27g+JTQ1jGPTZgaafSvbzGbz9bEQvcAbesL1hYaULTVKRbI1YRoRQwkai89a4sG45li+W+Owbhk2aOH2DkHJS3ishw0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6NfQOmx9crMVyer8gIiXxaVJuERlV5PznOkZVznq6k=;
 b=kl9CCem4LtcBZQ1vuhcWsYm0Zq6iyoXGJitdUrz/Zsm47vImojT30wRm4ysReTBW4UNKoM5gDFeb5CYfNoGnIep3t180Bs1ZXZVoX/Eq+NZ0ry4ZMmFAGyx1heWdcGB75yUC5Tf006M7vzsm5U8mN4E74zG9pR/SV/xplezLnRc=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3565.eurprd04.prod.outlook.com
 (2603:10a6:803:12::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Fri, 22 May
 2020 13:58:41 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3021.027; Fri, 22 May 2020
 13:58:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOECAAAN2gIAAEXFggAAcYgCAAKFaYIAD5lUAgADH7GCAALvkAIAAGOkQgAAXEYCAASQ/sIAARkIAgAAAluCAAZBZAIABOrvQ
Date:   Fri, 22 May 2020 13:58:41 +0000
Message-ID: <VI1PR0402MB387142F1D317717D7382DB3CE0B40@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
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
        <VI1PR0402MB38710DAD1F17B80F83403396E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200521120752.07fd83aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200521120752.07fd83aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3b2c92c3-948a-466d-c3fd-08d7fe583bfb
x-ms-traffictypediagnostic: VI1PR0402MB3565:
x-microsoft-antispam-prvs: <VI1PR0402MB3565D8A546B414F52AEBE2C2E0B40@VI1PR0402MB3565.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04111BAC64
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ImR0QpPvt4Ax48r4Kh0NM6yPVfGQKkmeCkAaisq9CdP4MjxkFFxPNHm0RLYej3NGs5JIKXB567GwnD8O/nkPB9sOv/35f6tMMNmY8iKrx7HvZtHroI1I6XIgClqNFadiAWTqd61ZX7PQt0nhxuF5NmV2FsOQrlERtuCSXYW7vYMpUOw6/4N3/4nEwaymrlNDz5nEbNEGoZh3FcwuQ3ipXcWTgcmSPgF2w9ZYATbPdb84vMt+jhvRCe+LX9ma6nNryfUHqDNoMpu5yq+WWLprhgneWxucfsarCA0usDBRk1uR2U/vRqdjyOptaooMxakI0W8fCqEa8zoZ/wAQ8RZmpM7N3HTCDoEaLUHezLgRswzmSQuG3X5ebVDEKUFIO71FlWZyY9wkHFXAh8OaLGHi96Okv8d2pkR+8dCdY23Osc212pDj1QqlPtvbYiA8Zo3D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(478600001)(2906002)(71200400001)(8936002)(44832011)(8676002)(66446008)(6506007)(54906003)(6916009)(66476007)(66946007)(5660300002)(64756008)(66556008)(33656002)(7696005)(9686003)(316002)(186003)(4326008)(52536014)(55016002)(86362001)(26005)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 77YvSbz6C9Q7edvtu+jZRr8BhJgtmWDg1/wHOdSHN/dUmCnShM0D2zyitkeEkUA/H/IMjJ+qaErjq6LefEKpmsdQJ2muskWVQaSwfo0odX5GyZSeTLDCbgu6tyUcgWqb0MfbZ68uAaNx9tymVj6H/DawRQeq9R2whfnBSZfZsxdwf2KYPhobcr68xbvPHAkOTKj8Fr3jezE8Ga9hzokjLZ+Lb4ttABdCxhIP00MDMWYOuGMJs7h1GbNFQgoRG7d495lOqdRW73BOKdRoDCht34Ph+134Ad/XP+cU0LoV04ecjk3rogaUlWOyzAC80o3pSKy1GuIGrRGGEedrLzAECVCScBvOoQ5qZY+Gmdu6/DV7inTh4iKAoGBLIruEApZvbwz5+ZX+iCwD/qK6yoE0t02C5bDuQ+mHYSQV4fR7iShLBKm1g/TYaSElGzO9JfPKfWWpOwERoRL2pEEZQsCUCfbpmn5vBQH2H2ceXIR5oohxxYM6soXH5XXXmrSohjXE
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2c92c3-948a-466d-c3fd-08d7fe583bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2020 13:58:41.2267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l4JrEcR1N4rQdHzCu4uJxca929PZVJrZz/bX68dZsHzRXKUKAQPQCgHsCGjwProAqO1CSI5lQIhVD1do+KmqTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3565
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Wed, 20 May 2020 20:24:43 +0000 Ioana Ciornei wrote:
> > > Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx
> > > traffic classes
> > >
> > > On Wed, 20 May 2020 15:10:42 +0000 Ioana Ciornei wrote:
> > > > DPAA2 has frame queues per each Rx traffic class and the decision
> > > > from which queue to pull frames from is made by the HW based on
> > > > the queue priority within a channel (there is one channel per each =
CPU).
> > >
> > > IOW you're reading the descriptor for the device memory/iomem
> > > address and the HW will return the next descriptor based on configure=
d
> priority?
> >
> > That's the general idea but the decision is not made on a frame by
> > frame bases but rather on a dequeue operation which can, at a maximum,
> > return
> > 16 frame descriptors at a time.
>=20
> I see!
>=20
> > > Presumably strict priority?
> >
> > Only the two highest traffic classes are in strict priority, while the
> > other 6 TCs form two priority tiers - medium(4 TCs) and low (last two T=
Cs).
> >
> > > > If this should be modeled in software, then I assume there should
> > > > be a NAPI instance for each traffic class and the stack should
> > > > know in which order to call the poll() callbacks so that the priori=
ty is
> respected.
> > >
> > > Right, something like that. But IMHO not needed if HW can serve the
> > > right descriptor upon poll.
> >
> > After thinking this through I don't actually believe that multiple
> > NAPI instances would solve this in any circumstance at all:
> >
> > - If you have hardware prioritization with full scheduling on dequeue
> > then job on the driver side is already done.
> > - If you only have hardware assist for prioritization (ie hardware
> > gives you multiple rings but doesn't tell you from which one to
> > dequeue) then you can still use a single NAPI instance just fine and pi=
ck the
> highest priority non-empty ring on-the-fly basically.
> >
> > What I am having trouble understanding is how the fully software
> > implementation of this possible new Rx qdisc should work. Somehow the
> > skb->priority should be taken into account when the skb is passing
> > though the stack (ie a higher priority skb should surpass another
> > previously received skb even if the latter one was received first, but =
its priority
> queue is congested).
>=20
> I'd think the SW implementation would come down to which ring to service =
first.
> If there are multiple rings on the host NAPI can try to read from highest=
 priority
> ring first and then move on to next prio.
> Not sure if there would be a use case for multiple NAPIs for busy polling=
 or not.
>=20
> I was hoping we can solve this with the new ring config API (which is com=
ing any
> day now, ehh) - in which I hope user space will be able to assign rings t=
o NAPI
> instances, all we would have needed would be also controlling the queryin=
g
> order. But that doesn't really work for you, it seems, since the selectio=
n is
> offloaded to HW :S
>=20

Yes, I would need only the configuration of traffic classes and their prior=
ities and
not the software prioritization.

I'll keep a close eye on the mailing list to see what the new ring config A=
PI
that you're referring to is adding.

> > I don't have a very deep understanding of the stack but I am thinking
> > that the
> > enqueue_to_backlog()/process_backlog() area could be a candidate place
> > for sorting out bottlenecks. In case we do that I don't see why a
> > qdisc would be necessary at all and not have everybody benefit from
> prioritization based on skb->priority.
>=20
> I think once the driver picks the frame up it should run with it to compl=
etion (+/-
> GRO). We have natural batching with NAPI processing.
> Every NAPI budget high priority rings get a chance to preempt lower ones.
