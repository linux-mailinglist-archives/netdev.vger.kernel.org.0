Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7030F470B1F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbhLJT6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:58:20 -0500
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:62720
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243456AbhLJT6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 14:58:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaQg89XUDXB1cwrD29XFmb3bw5/E760dA1j+L6HCrWJilOVDAk9qb77zFRBa05VLAjzOG8GNIQYC80ctiErZYdPJu27cUsR4SjQvwJCL5BSK03uOpyffCicuPIAHmRHyx+O3b8Q4RzQ6EPatN/Rn2NJ327SAgCbaQNxWgA+t5koQfmgm9QtJTyrX470nxiogijVNEfrw8nFcZqQrfhgzjYIqh4P4hKrjolVB7WBwXYzugqfnF7B2LAipzuzWBCQoRlWL5leTajQrI68OzJImeMTgIk3QGRhPjHi6eBYaFZ2WUWdxjMsE+Ou5sDS0SbzPYsDCyulhZHJSGmrCQX8QKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWHnkBoUiwkF3JkkrGXRUD9xpjQT551q2i6ND1aL5eI=;
 b=BeyMzIsXUDRYJV8khurey80ShhDxP9BkAhs/vKvlSUc7vji3LNNQc1wD2eLyG9u9ndmfAapdaBM9p7GoBKuN2GO8hbOalo7BVoyfNzvEGA/cs0XxGsV8ReHqdOV9RvGiWFJ3UvmA9tFYA1M3Z9xHwSuv2o38kyQ5olobMUlFS9jkb31jSVD1r7Ou+zgdRWpp9DYvsSObhjY1w3JTtZqE+cpzIbp8b0EIk6zdjneSVmKYgK9QyTgsWnLPAvINLFfXbXwBqKzBMBu1CEta1/uykWHtdqAId/E+USppv0AKSBaNcvefYUav1hiTYnIA/3h9dl6ItC/jqnXwS30yb5oSOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWHnkBoUiwkF3JkkrGXRUD9xpjQT551q2i6ND1aL5eI=;
 b=C7YppWZulOWJlNBwddOfwWyePbHAPmyvsvIvxKGFqAUh0i4thRL5AFObOaE4aNOHF9PPF5A5KPY2VDxiyJEbwrhNxQ92pxqOG8xi2ZTqlRnXh69HIYWjOBJZX+Au1teQcVz+b7P4ofiMX0kmqO/FZrYBTpbUpBtUVeB1JPz9WeU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6701.eurprd04.prod.outlook.com (2603:10a6:803:124::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 19:54:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 19:54:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Thread-Topic: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Thread-Index: AQHX7SPAys/vPXh1a06w39SkUSlBS6wrFFcAgADg3gCAAAJAgIAAAVQAgAAD6wCAAAnbAIAAElCAgAAEw4CAAAUfgIAAAoGA
Date:   Fri, 10 Dec 2021 19:54:42 +0000
Message-ID: <20211210195441.6drqtckl2m6rbmk6@skbuf>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
 <20211210170242.bckpdm2qa6lchbde@skbuf>
 <61b38a18.1c69fb81.95975.8545@mx.google.com>
 <20211210171530.xh7lajqsvct7dd3r@skbuf>
 <61b38e7f.1c69fb81.96d1c.7933@mx.google.com>
 <61b396c3.1c69fb81.17062.836a@mx.google.com>
 <61b3a621.1c69fb81.b4bf5.8dd2@mx.google.com>
 <20211210192723.noa3hb2vso6t7zju@skbuf>
 <61b3ae6b.1c69fb81.9a57f.8856@mx.google.com>
In-Reply-To: <61b3ae6b.1c69fb81.9a57f.8856@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77a70a32-1f15-47ca-f9a3-08d9bc16e893
x-ms-traffictypediagnostic: VE1PR04MB6701:EE_
x-microsoft-antispam-prvs: <VE1PR04MB6701DE9E4BB4C60A0C7901C6E0719@VE1PR04MB6701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 33Dq0BgOwCprXJHq2MRCnm/j6+7M0fZgRxJ2bLU5kbEWySZ3CEqqmwXR7Jszz/dFG+NB/SB2RehvcuWWSYfVno9zA2FnrxyJ2k7sxLip/vaZ7SsxIhR6LCLjiWDaQPYUI1IYS9pKpDsNRK8bN3jA+3EOrcgxDzyAMgD1Bg4PX39ATG2rO9VMYFJlk6mi+yrEcMJvfpG5SEIgb/Ptg77all4H9D9r1scdqGp40x06cMB8W7m/F7WUuqeA3lnfYW4+6Tw6qjH6u+BMKEhLZ481T+3ROdo6pA0YO/ZtGNbdfy2pQWLqc7McRKtdMvX6wTC2hvipKbjb1f17jTd1uv57USnyfb1clfngNZramKVSwzYYSKpPwWu+vAgrTNYyRwfD7Y5IFkEjeHo4I6XGcaDinCQcF2bKC+pLHMo9jSMrtnk6x9QKDgb+BBBE8FijmIo3OAX4dPcfQvUGpWGoATlvIOaYfmJy9EZHxHtlhNU2atPONqeL1jtleIAbVPcNhJG72ZXhRZ6NnbgNv6t+lyrU1RlxySCiXXYTQ7km72QwXIqBJZ50BTQZLELAvumeHGh/81hkWDUC26qJwjpoqHQCm6EjnhtsjGL6uQlSG1S0TTvVTf9lMIEjqrRvL2QiYaxGCep0mvmGeazEjcGc5ssFy+dqRg7hij3fhyvX28RhHDvcZCOIfXfScwQGapeYiR+rN1HbqXzRHfY/v4XPFKeZZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(9686003)(33716001)(6512007)(4326008)(1076003)(8936002)(8676002)(2906002)(44832011)(26005)(6916009)(6486002)(91956017)(508600001)(38070700005)(64756008)(66446008)(66556008)(316002)(66476007)(66946007)(38100700002)(6506007)(54906003)(83380400001)(71200400001)(76116006)(122000001)(86362001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n8iUOMN2ywO0VdDaPh7PqbibSGlfUiHfmV5yIj7WPF6ClfnQxaMYSDfdfjSL?=
 =?us-ascii?Q?C+rGQz05sbuX6+GGVGYDRHB3tsSp1Eum7XnPm95t12sabIBBBOcMtzV1vIsR?=
 =?us-ascii?Q?Y4+x0oTkjd3WPWIZnBsJLZ89Gsdj50exYW18Ee9DSFxWWdsrEsixkFrQqHEA?=
 =?us-ascii?Q?BmMfCdSQYuODEoOnMmvgwftuwxfrQqjGMkLQjpfuMLUFrCE7ShY/ei46Jmb7?=
 =?us-ascii?Q?VbGXzZ/X9+fr+wIfMIZHsr1pw0cBtzv50MWLaNDArdaP5V972xPYXbgQLPkR?=
 =?us-ascii?Q?JaK6Qs5BY65Sj9Sl5UO69sjFDipCQKgAmIF8Tyglflohgg+27JsbQgt5AZsr?=
 =?us-ascii?Q?fE0N6kE5gfcA7AuexnDTvZ0Yuj1Q/kmpJ+rrJUShmwebdwD6vNLfultccAM/?=
 =?us-ascii?Q?13d2/7GCycAiLawrcFXBOXus1mYaLLicyUVmSOcDNc5Hco4iyTlqaAd0WhLV?=
 =?us-ascii?Q?gaKf8ka8ISvfgvWeS0wr76U2tJOrprIpUBWD1aMUhMEGVSMJCIXMYBVSCkrA?=
 =?us-ascii?Q?cXia6ax7JtDU2O019GIVf8zKHirVFxVLY5D0FUOI059adyokpooExllTXqEf?=
 =?us-ascii?Q?Nd/PDlwESrx/ltItANc88/lwTBhTSmEHTb6Gol+MCgH6RFvgkbJVMjsW1uG0?=
 =?us-ascii?Q?YdFdT/k04nUMaXDAQN7VnBwGrY1qj1h3G1dnNGQMXNXGGfgv9tVPiwNSq9UY?=
 =?us-ascii?Q?O2Fez0afZ+U80FCatIGihgNQwqIlpeuiooNbJgy+xarAa8mB7gYfuIgnG5Mx?=
 =?us-ascii?Q?K7l/g6PCYpuRJcgHM2cgcAEpQu/XmmyH5Ct9Cqudg214pHMOlFmBkfRIpehj?=
 =?us-ascii?Q?pFHlKbbFk3fEN3jHGjMF/PXfvrkzUjIaIUibMUzcmSGoT3Z2PCc6ydX7Dwiq?=
 =?us-ascii?Q?PoouNfYmNAnfvvNYdgKc/y4+qoaTrXfZhOnx8VSZl7/Xj7eEMsRT1lCejWSA?=
 =?us-ascii?Q?7IPg38P0M9fPOxPuZ0SgOtiL56XR8fkdvo3lAO60EYWp0QZAyAW+a5RLDyc4?=
 =?us-ascii?Q?H6oH8B5StPmG6ldu2FV+YzIyK57wUPci9/Hepm4jMgnYWUIsdNEOcoqrxyCP?=
 =?us-ascii?Q?qhWvju4L2vKXfIoqcCRbjK0u0QHt0kzLBDNDL4KtYYviw9iDx8Ighw4fvBPX?=
 =?us-ascii?Q?2L/eIcPmlju8ZlwHESRu7z/NEbaP/HA4ee8fwbP6RS7uAwXl8oFZruFRTHQh?=
 =?us-ascii?Q?6AAYIiK+HxspDVAOzTFTYKUTJvwvgbwbeS89HG7u2PCJyPkQDpEGU5AaYXe3?=
 =?us-ascii?Q?sUpOm71NbTdRlNwXPPg+KjQEZwwGiZrv9JsSFvgmyouQl/DuXujWdzRpVOqe?=
 =?us-ascii?Q?88mKMgUR+dQ9mxcHjzrFqMW/qcxCMITnBA3PDeVvlPUQKBoONM9QmClHNnpP?=
 =?us-ascii?Q?7RtRtYQaBfRQ0yAArLKBld03XJW89AbG6Oy5tKTZNl7oBCoi58KiZtMRGyVi?=
 =?us-ascii?Q?8fMIOUkYWJqqEkDqu8GEfjM5HJjmeoNGejq4SOJS3argZ1F2VedKbI7SU1Zu?=
 =?us-ascii?Q?89v7nWFl5ZA/hna9sN5MyebiNL+iROfXf7bSj3e/WHdfoe7Q7P/KZtgfto48?=
 =?us-ascii?Q?XtbeaBo0vgJBDu6rLPwgA7mh8WZrORuIygzN90isJHpRXj9bYy/V8eiiLQN0?=
 =?us-ascii?Q?Tvhdb3AGZz+VmFMVhKBH1RI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <895A201A77D3A540BAC9E467660C1681@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a70a32-1f15-47ca-f9a3-08d9bc16e893
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 19:54:42.6325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJMBH6RxSRQr+/Px3dc+ucIoNrvHfAGYTvphJaBrVXGu3WMCs+Uoxcw18oLeezZj8jRxXSE27rmm0kYTVYs5DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 08:45:43PM +0100, Ansuel Smith wrote:
> > Anyway the reason why I didn't say anything about this is because I
> > don't yet understand how it is supposed to work. Specifically:
> >=20
> > rtnl_lock
> >=20
> > dev_open()
> > -> __dev_open()
> >    -> dev->flags |=3D IFF_UP;
> >    -> dev_activate()
> >       -> transition_one_qdisc()
> > -> call_netdevice_notifiers(NETDEV_UP, dev);
> >=20
> > rtnl_unlock
> >=20
> > so the qdisc should have already transitioned by the time NETDEV_UP is
> > emitted.
> >=20
> > and since we already require a NETDEV_UP to have occurred, or dev->flag=
s
> > to contain IFF_UP, I simply don't understand the following
> > (a) why would the qdisc be noop when we catch NETDEV_UP
> > (b) who calls netdev_state_change() (or __dev_notify_flags ?!) after th=
e
> >     qdisc changes on a TX queue? If no one, then I'm not sure how we ca=
n
> >     reliably check for the state of the qdisc if we aren't notified
> >     about changes to it.
>=20
> The ipv6 check is just a hint. The real clue was the second
> NETDEV_CHANGE called by linkwatch_do_dev in link_watch.c
> That is the one that calls the CHANGE event before the ready stuff.
>=20
> I had problem tracking this as the change logic is "emit CHANGE when flag=
s
> change" but netdev_state_change is also called for other reason and one
> example is dev_activate/dev_deactivate from linkwatch_do_dev.
> It seems a bit confusing that a generic state change is called even when
> flags are not changed and because of this is a bit problematic track why
> the CHANGE event was called.
>=20
> Wonder if linkwatch_do_dev should be changed and introduce a flag? But
> that seems problematic if for whatever reason a driver use the CHANGE
> event to track exactly dev_activate/deactivate.

Yes, I had my own "aha" moment just minutes before you sent this email
about linkwatch_do_dev. So indeed that's the source of both the
dev_activate(), as well as the netdev_state_change() notifier.

As to my previous question (why would the qdisc be noop when we catch
NETDEV_UP): the answer is of course in the code as well:

dev_activate() has:
	if (!netif_carrier_ok(dev))
		/* Delay activation until next carrier-on event */
		return;

which is then actually picked up from linkwatch_do_dev().

Let's not change linkwatch_do_dev(), I just wanted to understand why it
works. Please confirm that it also works for you to make master_admin_up
depend on qdisc_tx_is_noop() instead of the current ingress_queue check,
then add a comment stating the mechanism through which we are tracking
the dev_activate() calls, and then this should be good to go.
I'd like you to pick up the patches and post them together with your
driver changes. I can't post the patches on my own since I don't have
any use for them. I'll leave a few more "review" comments on them in a
minute.=
