Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01C5210276
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 05:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGADWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 23:22:39 -0400
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:62270
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgGADWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 23:22:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1DKFMaImQg93dRSHK4eJoKPyV6rpNzTHdHKoo64tSsaz60sXpctCvN9fNlAe+TxQl31oTX1C/kAnaN3UITZ24mTA6zWOqGnTiuX5YVWRycLUtfJhj7kh5pFaNZOnGGxU+Utdriz/fGYx0JOhYgxd08YSNkVc1SR2HmdaJwNIw4jGxA+bS3CJzCiwJiTv1wxG3WtqIu94sT9Fm96Wbq4dQA/8M/F1J8XdMd/TB1e0Hb7ttsRX8oFanG4GnGUnutI089cCMm4V04c3A3MwCjaE06Q5t6hKcPGMCVibyxLC3KS6ZvD7NKxeX1D8ewFZBH8KOHUwV72v9ehtx+IFMJEBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZVYJ7wydWnY8f9v9DlnsypJXbZCOEM3qSd8CD5gjbo=;
 b=J+i+hjsqZGOyFxwwhGyZZqAgnKbwi5eRqRgV8b+VmPThhE3ESKW97L5MPSsTMmQtWAaLmqiS6Z7+E3zogGCz+1BkdEEaaAOR9Ga7i/2UXOhTHdEzOKYqoPuR0E7vhAOdwctSc37W8AFHKiYhrSusPe3oaGT+YXfKA/4tY71z+kIcPDlr3rt52DIp1qFj/hgxfLNXz8dj+Oa03FRiE3AdP/As/jbWEyd1o5VaENbf8ufi4tJ1f0vUACb2KHzZz229D1ADje096m8zCfLIVmWzxmxFjujJo8bmPeW7uMs30vwSd0QpKBu3CtegaC71A2HxfuPXedYTh1VCqp14n//KMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZVYJ7wydWnY8f9v9DlnsypJXbZCOEM3qSd8CD5gjbo=;
 b=doTgNtc9aHYdvYPtJzWMJ7t4hFpgbbmGzAcOzoH/c0CT95lXdni0ruAIrFjakOl99YZYTPcag2b3AOs0A7J+tpxIHwJfoUGSzOWOPBhjB3f7DnJHV4b5xmvP3p3a3XHzgu4rhI2IwBOJuUFs9k4ebHLBTAuG4VLNI/uqAP25grI=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM5PR0402MB2932.eurprd04.prod.outlook.com
 (2603:10a6:203:9c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Wed, 1 Jul
 2020 03:22:35 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3131.030; Wed, 1 Jul 2020
 03:22:35 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net] net: ethernet: fec: prevent tx starvation
 under high rx load
Thread-Topic: [EXT] Re: [PATCH net] net: ethernet: fec: prevent tx starvation
 under high rx load
Thread-Index: AQHWTlDvbOQDqevPPEa7enA8dpldvqjwtekAgADe+gCAAHuGAA==
Date:   Wed, 1 Jul 2020 03:22:35 +0000
Message-ID: <AM6PR0402MB3607AC71BEDBE8784F8970D0FF6C0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200629.130731.932623918439489841.davem@davemloft.net>
        <C3U8BLV1WZ9R.1SDRQTA6XXRPB@wkz-x280>
 <20200630.125802.533305649716945637.davem@davemloft.net>
In-Reply-To: <20200630.125802.533305649716945637.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 943f2684-3782-4461-f0d3-08d81d6dfff0
x-ms-traffictypediagnostic: AM5PR0402MB2932:
x-microsoft-antispam-prvs: <AM5PR0402MB2932C2FB0A0878D9B322AD4FFF6C0@AM5PR0402MB2932.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VpBGkIae+Wm+cfVqtaGS4t9+OJPkY8wZ3nw9/77HJcJRLFaEfuBFO4J6rTbWl8te4VR3urmO670mqMV3VLQela2gAVngmqOeTy25J9yBbGH4UYhodhITsP9DWojoTcjXAN/CVVrqqKjXui1Mjih53ooDcwezww6B6AY0aoNP0bogGtxyiZ59rukXvrIrNj+aWAs/Q0wFJWHjKqB7HMM9nJgEX0zHGCy9lU0omIZ/GSgZbY2AnT0j4HzFDzKI+SJvksB7y7Nt2uoVgXvxOE0fl9dinEIx3x6x3fTu/1+TIrGacyK30inEV7nHHeB+mcpp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(33656002)(4326008)(52536014)(83380400001)(478600001)(9686003)(2906002)(76116006)(66476007)(66556008)(66946007)(66446008)(64756008)(71200400001)(86362001)(7696005)(5660300002)(55016002)(186003)(26005)(8676002)(8936002)(6506007)(316002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 4uwK2x5i8dq+qaw7jbVbx2OTug05ynITD3SzBUYDHE8p3kJGZlgDl6m4gUkTv+WeHm5mFt7rZn832yFyV+V+jwxFZZPgwa5yWdVshMvebO0UBzVR9u4rBJq8SIqXWvzZErAzdSRKpaYv4xhUdqQxFXw91aO22RR9/LpfV9+Xon0VuRqJAhyE0PjpDOHDjwuML1muZPZMeUD5znDLuN3LWJkmAaSYtxl9r6yyx6ImPWbf2s85uq6scBTxptAjyG+dvB8kL5sYxvnaLuNTfTQ1613oreHwjykb+x6EOkIixvSpMXPFXBuAnic5MOsD/8aNpV8tmCVP93K3HYdFvUY0fy65Mw0Z3Y5lUZHpkcTnWAB6V1FH0j2t9I2ramk4m8S9f+yDM+IhwoR1VLXbFVU/MeySduE+jJpVDH2AjPcEElLTYqjcydyspCKBy3x4OAkancZBAq6knluVvff73r8o2BksiK4iGaW/Boo96D3Oi5LfdBwcqsbqpjhPswXg28z1
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943f2684-3782-4461-f0d3-08d81d6dfff0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 03:22:35.4593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A9rjgEfrieICDvXWzHoWEqQ5t20AMwQ9wRwBhUHOcVilBrdvdl45zwmK+d//XjGtWbrewR0xoTkBq4qsSJxAQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2932
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Wednesday, July 1, 2020 3:58=
 AM
> From: "Tobias Waldekranz" <tobias@waldekranz.com>
> Date: Tue, 30 Jun 2020 08:39:58 +0200
>=20
> > On Mon Jun 29, 2020 at 3:07 PM CEST, David Miller wrote:
> >> I don't see how this can happen since you process the TX queue
> >> unconditionally every NAPI pass, regardless of what bits you see set
> >> in the IEVENT register.
> >>
> >> Or don't you? Oh, I see, you don't:
> >>
> >> for_each_set_bit(queue_id, &fep->work_tx, FEC_ENET_MAX_TX_QS) {
> >>
> >> That's the problem. Just unconditionally process the TX work
> >> regardless of what is in IEVENT. That whole ->tx_work member and the
> >> code that uses it can just be deleted. fec_enet_collect_events() can
> >> just return a boolean saying whether there is any RX or TX work at all=
.
> >
> > Maybe Andy could chime in here, but I think the ->tx_work construction
> > is load bearing. It seems to me like that is the only thing stopping
> > us from trying to process non-existing queues on older versions of the
> > silicon which only has a single queue.
>=20
> Then iterate over "actually existing" queues.
Yes, the iterate over real queues, but only bit2 has the chance to be set, =
so it
Is compatible with single queue.

