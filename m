Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F034D8085
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbiCNLTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237631AbiCNLTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:19:05 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F01E1114F;
        Mon, 14 Mar 2022 04:17:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axlVaDqEL9u35jPYV0EsO+M/mx/JQ2PbKlloaqYN06p6yAqK41huhxte77W9R2BWyy66zT0Xo1FDp1Ml/RnCCdzyclYt1efDdtTBl/LxGZkbiUTrTSJfrVlrTtqwQrVSVZ5F0Ag+iPlAHkB+olZJ7EXToU48NITjfHfoZCVoQK0xJ/AAYPx2mWaZLlexcYAucr2qv0Dq9m2Rn5sWXlm/cfRYHgLwNlG8W+9Aj6MWhaG5sf9JlqS8Woo/XNu+kSbs02FodD+DMCaRCc2HlY8MDzwkTVpU3cuDymIWKe2pzr7K/eS5wB/M8BnYOt05KxNKmaWxTc/eDk6P0Ryt1Vr5XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/glIA9vRwfUQ5dpLKFCgbpuRMM+h/vbgutsg1LOPHY=;
 b=I+6gF8DiSHHWmDmuLIGwQb610O37vH9fj0LvCZ7qwmb+PfaLYHY17IspZzKlljb5J2EC4pyXtBDiE+e4POQbDrojaX81+8AZ3T3N7E+rNwOpWrpWYjls5PwK2HD/NHp2UW92ExwLsjxuE2rDGBbKOELKXiPj0DUyR0r1j9yF66UlvQ6zR0SoLoIihRzsHLPBjEdZFobGRNmfOrpPyQXCnQBorU6cFkTv+944yEBxGVKj3Bh8QXYabvZPIbaUrULHPD928Yb9jdp+PzuCPdhOA6mz60IJXs8WqD8qgKoTM9BC7acN+C7YhWI9aYlVuAf6Dg7Ml46uvnaTaoegQG1tuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/glIA9vRwfUQ5dpLKFCgbpuRMM+h/vbgutsg1LOPHY=;
 b=AnMUi93lF0Tv+sIkPOe8Dw+JNI2VelxSeEI4jlBM2sCBCj3ksggJbNOcoCpeiYA0aboAoQwQrQKIInG7V3bP6jKPsg3ceTFw6I2vvdnr4mn3QB1P+xskP2xnjdxMGD/SReqhuyF7ye6Tat8h/ACQ3dAEwGBV5jVwjqk86Ib9FG0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3564.eurprd04.prod.outlook.com (2603:10a6:7:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Mon, 14 Mar
 2022 11:17:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.026; Mon, 14 Mar 2022
 11:17:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Daniel Suchy <danny@danysek.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rafael.richter@gin.de" <rafael.richter@gin.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: patch problem - mv88e6xxx: flush switchdev FDB workqueue
Thread-Topic: patch problem - mv88e6xxx: flush switchdev FDB workqueue
Thread-Index: AQHYNuMUe6nsPJS+gkWlndMnOWNLUqy9WmoAgAEUJACAAAvrAIAAQggA
Date:   Mon, 14 Mar 2022 11:17:50 +0000
Message-ID: <20220314111750.ym5xiuvusj4kl4t4@skbuf>
References: <ccf51795-5821-203d-348e-295aabbdc735@danysek.cz>
 <20220313141030.ztwhuhfwxjfzi5nb@skbuf> <Yi7i+pebGu0NoIsF@kroah.com>
 <Yi7s+vh3GBTVtDN2@kroah.com>
In-Reply-To: <Yi7s+vh3GBTVtDN2@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6d57a88-d27f-4cc5-89fd-08da05ac46e3
x-ms-traffictypediagnostic: HE1PR0402MB3564:EE_
x-microsoft-antispam-prvs: <HE1PR0402MB35640C9D5910F0D2EFDBA251E00F9@HE1PR0402MB3564.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MKUnJ4ntEeJW0bbNK9AjazC3MoyJL0VPETQxzzHfEATtjFqym2DTcP6ikSf6Qfzhn9NHRJAj3m5A0RB3WDmhEcLPe+6jyOy5kGmEvX28kYFYkMSTKMt+ipqbKkuV3TNHslLW+ehFIfz076F+OWPl2C3RHK8/PqCUapsG91GglLTRyYhebha1+f/BnaEjuHk2/QAcCTW3vnWCuW9qUNxbVpqQSTz/e62wxU2YaQQVRPiFq1L3CNu6EeHzktyduKtruBMVKjAgZTQjYA1ej8xBXMRb4f3CgJhg4fBTyDgzCizxi284mJThHuStwOtlRuHV4F0Mt7RgtS95YKvTDilbaK7KzBHYj6cgkl1AwSmr3d5ULIL41LZGbHE9KNnV1uNfXucVcourFVvhlUlfg1Qp85LBj7eo/5X45pOHzyN5nzwyD8nKTWi4BidRnhVcl0lDA0DLM8a2GCG3YwiyCzxpM/DqQCiXi8UGkt+WMQI5OoZQDCnWKyJsMH2uOsSPqEnNzuYfiiRECcK2rkjFBHk0d3YWjc6tvxJU0FIGsYAJ7QX08RzzZezO8EwdDitXW/Qkgzf/1/zy/+RrkZWjJbF9QGv5qCPhS2GOTxXaM1dKjuJD10sRuU93QvXh1Q3jjMFFACOGdkZ2gPQSZORguy8RFvY79AxVeKleMOaKMdcTgLQDPdMfHn+snqGY82wFnDsqvTYbd2WF3ZpqvjoLB8znaaPj7B9q/SwhDSUvRoc4S4PumMJb2g+JwmbRZvtxtQEJ2sKlJSekflEbkWaW0QNfuULtNrp0yig2mHzH+0ctWTg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(86362001)(186003)(122000001)(1076003)(26005)(64756008)(66446008)(76116006)(66946007)(66476007)(66556008)(8676002)(4326008)(99936003)(71200400001)(6486002)(966005)(498600001)(38070700005)(9686003)(38100700002)(6506007)(6512007)(6916009)(2906002)(54906003)(33716001)(44832011)(8936002)(5660300002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hbFiWzNii+7JtRjvjZooaOQZwKc3eDL0fO0Bq4mXQp9Yfu0rci+LOdzNpbm4?=
 =?us-ascii?Q?sfrLrTwq6JGIyjKPOcw8C5RsdS7sPRgFQU+S3zC3FYL+izVLEmYs55sFXB8L?=
 =?us-ascii?Q?aoHm3q+t2SwQuCKML2+adRJKRH2mj5BXUv145gljg1IjU1nEPeiHgLl2kVPq?=
 =?us-ascii?Q?U9edEj8vt328hyFNS5lkkE2zPIsb6QO4lDZCgSqbsn3o2Rp7TDrMCAhNy1MB?=
 =?us-ascii?Q?qMu0mDcCaHbdGdKFi7G6qogRtTcBbVgBsACXtovbZgV1LjrLbyVPh6MqoI6X?=
 =?us-ascii?Q?FEysv4wIcNnnEu6t+ucpkWhFbqyCjtNi56kAINqrCctAF7ZrW/2AwqBqN9Ld?=
 =?us-ascii?Q?ywLzJEEye/DzuRQfJVg9JbXx7UIdVSgsjU5m9+iHi5oKv5nQfexZhPwXrz2Y?=
 =?us-ascii?Q?FBnEDm7wECf+5KBBIYd0IgGf2SQYB8941can1lnMoJrttR54vDsG2ndzxV6N?=
 =?us-ascii?Q?UUyshC7OSL+0YZN9bGafR58ypmClPwxJ3Muxq+EBD9u8KrVO4xWh52dq7S+D?=
 =?us-ascii?Q?WmA6IiljkfR1nbEFBItTkQtv8DD6ywNY4EWWbp1faddfjOIH7j6FprtJuD2w?=
 =?us-ascii?Q?hyLQTN1oyJMK2xbLHQ3SJG5EqQd0OIYGfjGXURj28TSLQ7euZaGj5gZnrIg0?=
 =?us-ascii?Q?EFKX8ayZrBVajYwwG1JRSR9hcUQraT00Q2jbtMw8OXDtsjTYxMu5yNmIRLKy?=
 =?us-ascii?Q?rNjvc1rC8ftp1coflTfoJhS0jJGjzOHSCSHQqc9r6cKlhqMSLb1brYmicEYR?=
 =?us-ascii?Q?3kL7a/TtsNRgO+mW+gOza7TTXpV93Uj62MnSfdVOCfXnuttXR0LMEty37Bh8?=
 =?us-ascii?Q?ws0yGOXuUOCaortLtkFvYCUqmahpQxZrLJucrAsFDyKZKWtbBp3OvQZgtL5Y?=
 =?us-ascii?Q?Ca/DZvYsilGohoeo2E/6YijfxF+nl7dQPBlpeptgVRYCLQpM+4MpakSCDQt6?=
 =?us-ascii?Q?ooqFiQ9+z/d02DBUCQZBFzK5HkJ5B11M0UPR7GUzSP/2NMLc3yw0N5P6OiJz?=
 =?us-ascii?Q?iOlwjIKouQWtLKk+pzlPooPTd4cyGbYd60LlIQ7DFrwLJqJWFqJd0deUvbNN?=
 =?us-ascii?Q?kva0KJoPf1VJs101Y2mgi0bpWOOrNhJ9g3+TjplVsK7is3HgXvBSNvn1acNv?=
 =?us-ascii?Q?j8AIfFKGuSoniuuOF6AYIGFTohOn0WmeGb7zRC1oY0pzep8ZFBRE1AA+5Dev?=
 =?us-ascii?Q?m19V/JrJ5/AVJTvu2ftpRAmqqWNUSJQKd7yjYif2ScMmyKDgV2YYPCyAxx1F?=
 =?us-ascii?Q?lW15UyMqYQSmCzhTU4mmafS2dfUGZb04OxzAYJzcYni4sqpoSqZnR3YhejVY?=
 =?us-ascii?Q?7pGlcN16OVtE+VZNRxDLf7efVvPoIBvZOlOWO8Z0PClbWpALN8EIYBn1+nTg?=
 =?us-ascii?Q?5jouqWfSYDR2EXXMhRcWd1DgAULv0Qge21hBbON2RHSaiyLFbyt+vYyM5RgB?=
 =?us-ascii?Q?1PnamT1sXA+4WjNKulkiauzC/3CovZ9ahkOyoYhf1L3iMLLZ/U/yRg=3D=3D?=
Content-Type: multipart/mixed;
        boundary="_002_20220314111750ym5xiuvusj4kl4t4skbuf_"
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d57a88-d27f-4cc5-89fd-08da05ac46e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 11:17:50.6771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ya23eU+sUz8kFPhret7QMou9leBxUWmUU5l+0gDKvxCG4/8+h3c+fZr2Emhix9kXkRt4XU6EZ5FrdPHZ+b3Org==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3564
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_20220314111750ym5xiuvusj4kl4t4skbuf_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB675ABB6033244B940EB1A06CCEF421@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 14, 2022 at 08:21:30AM +0100, gregkh@linuxfoundation.org wrote:
> On Mon, Mar 14, 2022 at 07:38:50AM +0100, gregkh@linuxfoundation.org wrot=
e:
> > On Sun, Mar 13, 2022 at 02:10:31PM +0000, Vladimir Oltean wrote:
> > > Hi Daniel,
> > >=20
> > > On Sun, Mar 13, 2022 at 03:03:07PM +0100, Daniel Suchy wrote:
> > > > Hello,
> > > >=20
> > > > I noticed boot problems on my Turris Omnia (with Marvell 88E6176 sw=
itch
> > > > chip) after "net: dsa: mv88e6xxx: flush switchdev FDB workqueue bef=
ore
> > > > removing VLAN" commit https://git.kernel.org/pub/scm/linux/kernel/g=
it/stable/linux.git/commit/?id=3D2566a89b9e163b2fcd104d6005e0149f197b8a48
> > > >=20
> > > > Within logs I catched hung kernel tasks (see below), at least first=
 is
> > > > related to DSA subsystem.
> > > >=20
> > > > When I revert this patch, everything works as expected and without =
any
> > > > issues.
> > > >=20
> > > > In my setup, I have few vlans on affected switch (i'm using ifupdow=
n2 v3.0
> > > > with iproute2 5.16 for configuration).
> > > >=20
> > > > It seems your this patch introduces some new problem (at least for =
5.15
> > > > kernels). I suggest revert this patch.
> > > >=20
> > > > - Daniel
> > >=20
> > > Oh wow, I'm terribly sorry. Yes, this patch shouldn't have been
> > > backported to kernel 5.15 and below, but I guess I missed the
> > > backport notification email and forgot to tell Greg about this.
> > > Patch "net: dsa: mv88e6xxx: flush switchdev FDB workqueue before
> > > removing VLAN" needs to be immediately reverted from these trees.
> > >=20
> > > Greg, to avoid this from happening in the future, would something lik=
e
> > > this work? Is this parsed in some way?
> > >=20
> > > Depends-on: 0faf890fc519 ("net: dsa: drop rtnl_lock from dsa_slave_sw=
itchdev_event_work") # which first appeared in v5.16
> >=20
> > The "Fixes:" tag will solve this, please just use that in the future.
>=20
> Ah, you did have a fixes tag here, so then use the way to say "you also
> need to add another patch here" by adding the sha to the line for the
> stable tree:
> 	cc: stable@vger.kernel.org # 0faf890fc519
>=20
> So, should I just backport that commit instead?  The "Fixes:" line says
> this needs to be backported to 4.14, which is why I added it to these
> trees.
>=20
> thanks,

No, don't backport the dependency, just revert the patch (hence my
question: how can I describe "don't backport beyond commit X"?).

Here, you can apply the revert attached.

--_002_20220314111750ym5xiuvusj4kl4t4skbuf_
Content-Type: text/x-diff;
	name="0001-Revert-net-dsa-mv88e6xxx-flush-switchdev-FDB-workque.patch"
Content-Description:
 0001-Revert-net-dsa-mv88e6xxx-flush-switchdev-FDB-workque.patch
Content-Disposition: attachment;
	filename="0001-Revert-net-dsa-mv88e6xxx-flush-switchdev-FDB-workque.patch";
	size=3851; creation-date="Mon, 14 Mar 2022 11:17:50 GMT";
	modification-date="Mon, 14 Mar 2022 11:17:50 GMT"
Content-ID: <EA91FE9C4553C343930C1F1D7C6673BB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSA1NzFjYTk4MmMwYTUzZDEyN2I0YzkyMzM5MjYyYzFlODk2ZTljNWExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5Abnhw
LmNvbT4NCkRhdGU6IE1vbiwgMTQgTWFyIDIwMjIgMDE6MjQ6NTkgKzAyMDANClN1YmplY3Q6IFtQ
QVRDSF0gUmV2ZXJ0ICJuZXQ6IGRzYTogbXY4OGU2eHh4OiBmbHVzaCBzd2l0Y2hkZXYgRkRCIHdv
cmtxdWV1ZQ0KIGJlZm9yZSByZW1vdmluZyBWTEFOIg0KDQpUaGlzIHJldmVydHMgY29tbWl0IDI1
NjZhODliOWUxNjNiMmZjZDEwNGQ2MDA1ZTAxNDlmMTk3YjhhNDguDQoNClRoZSBhYm92ZSBjaGFu
Z2UgZGVwZW5kcyBvbiB1cHN0cmVhbSBjb21taXQgMGZhZjg5MGZjNTE5ICgibmV0OiBkc2E6DQpk
cm9wIHJ0bmxfbG9jayBmcm9tIGRzYV9zbGF2ZV9zd2l0Y2hkZXZfZXZlbnRfd29yayIpLCB3aGlj
aCBpcyBub3QNCnByZXNlbnQgaW4gbGludXgtNS4xNS55LiBXaXRob3V0IHRoYXQgY2hhbmdlLCB3
YWl0aW5nIGZvciB0aGUgc3dpdGNoZGV2DQp3b3JrcXVldWUgY2F1c2VzIGRlYWRsb2NrcyBvbiB0
aGUgcnRubF9tdXRleC4NCg0KQmFja3BvcnRpbmcgdGhlIGRlcGVuZGVuY3kgY29tbWl0IGlzbid0
IHRyaXZpYWwvZGVzaXJhYmxlLCBzaW5jZSBpdA0KcmVxdWlyZXMgdGhhdCB0aGUgZm9sbG93aW5n
IGRlcGVuZGVuY2llcyBvZiB0aGUgZGVwZW5kZW5jeSBhcmUgYWxzbw0KYmFja3BvcnRlZDoNCg0K
ZGY0MDU5MTBhYjlmIG5ldDogZHNhOiBzamExMTA1OiB3YWl0IGZvciBkeW5hbWljIGNvbmZpZyBj
b21tYW5kIGNvbXBsZXRpb24gb24gd3JpdGVzIHRvbw0KZWIwMTZhZmQ4M2E5IG5ldDogZHNhOiBz
amExMTA1OiBzZXJpYWxpemUgYWNjZXNzIHRvIHRoZSBkeW5hbWljIGNvbmZpZyBpbnRlcmZhY2UN
CjI0NjgzNDZjNTY3NyBuZXQ6IG1zY2M6IG9jZWxvdDogc2VyaWFsaXplIGFjY2VzcyB0byB0aGUg
TUFDIHRhYmxlDQpmN2ViNGExYzA4NjQgbmV0OiBkc2E6IGI1Mzogc2VyaWFsaXplIGFjY2VzcyB0
byB0aGUgQVJMIHRhYmxlDQpjZjIzMWI0MzZmN2MgbmV0OiBkc2E6IGxhbnRpcV9nc3dpcDogc2Vy
aWFsaXplIGFjY2VzcyB0byB0aGUgUENFIHJlZ2lzdGVycw0KMzM4YTNhNDc0NWFhIG5ldDogZHNh
OiBpbnRyb2R1Y2UgbG9ja2luZyBmb3IgdGhlIGFkZHJlc3MgbGlzdHMgb24gQ1BVIGFuZCBEU0Eg
cG9ydHMNCg0KYW5kIHRoZW4gdGhpcyBidWdmaXggb24gdG9wOg0KDQo4OTQwZTZiNjY5Y2EgKCJu
ZXQ6IGRzYTogYXZvaWQgY2FsbCB0byBfX2Rldl9zZXRfcHJvbWlzY3VpdHkoKSB3aGlsZSBydG5s
X211dGV4IGlzbid0IGhlbGQiKQ0KDQpSZXBvcnRlZC1ieTogRGFuaWVsIFN1Y2h5IDxkYW5ueUBk
YW55c2VrLmN6Pg0KU2lnbmVkLW9mZi1ieTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRl
YW5AbnhwLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jIHwgNyAt
LS0tLS0tDQogaW5jbHVkZS9uZXQvZHNhLmggICAgICAgICAgICAgICAgfCAxIC0NCiBuZXQvZHNh
L2RzYS5jICAgICAgICAgICAgICAgICAgICB8IDEgLQ0KIG5ldC9kc2EvZHNhX3ByaXYuaCAgICAg
ICAgICAgICAgIHwgMSArDQogNCBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgOSBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5j
IGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCmluZGV4IDI2M2RhN2UyZDZiZS4u
MDU2ZTNiNjVjZDI3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlw
LmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5jDQpAQCAtMjI5MSwxMyAr
MjI5MSw2IEBAIHN0YXRpYyBpbnQgbXY4OGU2eHh4X3BvcnRfdmxhbl9kZWwoc3RydWN0IGRzYV9z
d2l0Y2ggKmRzLCBpbnQgcG9ydCwNCiAJaWYgKCFtdjg4ZTZ4eHhfbWF4X3ZpZChjaGlwKSkNCiAJ
CXJldHVybiAtRU9QTk9UU1VQUDsNCiANCi0JLyogVGhlIEFUVSByZW1vdmFsIHByb2NlZHVyZSBu
ZWVkcyB0aGUgRklEIHRvIGJlIG1hcHBlZCBpbiB0aGUgVlRVLA0KLQkgKiBidXQgRkRCIGRlbGV0
aW9uIHJ1bnMgY29uY3VycmVudGx5IHdpdGggVkxBTiBkZWxldGlvbi4gRmx1c2ggdGhlIERTQQ0K
LQkgKiBzd2l0Y2hkZXYgd29ya3F1ZXVlIHRvIGVuc3VyZSB0aGF0IGFsbCBGREIgZW50cmllcyBh
cmUgZGVsZXRlZA0KLQkgKiBiZWZvcmUgd2UgcmVtb3ZlIHRoZSBWTEFOLg0KLQkgKi8NCi0JZHNh
X2ZsdXNoX3dvcmtxdWV1ZSgpOw0KLQ0KIAltdjg4ZTZ4eHhfcmVnX2xvY2soY2hpcCk7DQogDQog
CWVyciA9IG12ODhlNnh4eF9wb3J0X2dldF9wdmlkKGNoaXAsIHBvcnQsICZwdmlkKTsNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL25ldC9kc2EuaCBiL2luY2x1ZGUvbmV0L2RzYS5oDQppbmRleCA0OWU1
ZWNlOTM2MWMuLmQ3ODRlNzYxMTNiOCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbmV0L2RzYS5oDQor
KysgYi9pbmNsdWRlL25ldC9kc2EuaA0KQEAgLTEwNTYsNyArMTA1Niw2IEBAIHZvaWQgZHNhX3Vu
cmVnaXN0ZXJfc3dpdGNoKHN0cnVjdCBkc2Ffc3dpdGNoICpkcyk7DQogaW50IGRzYV9yZWdpc3Rl
cl9zd2l0Y2goc3RydWN0IGRzYV9zd2l0Y2ggKmRzKTsNCiB2b2lkIGRzYV9zd2l0Y2hfc2h1dGRv
d24oc3RydWN0IGRzYV9zd2l0Y2ggKmRzKTsNCiBzdHJ1Y3QgZHNhX3N3aXRjaCAqZHNhX3N3aXRj
aF9maW5kKGludCB0cmVlX2luZGV4LCBpbnQgc3dfaW5kZXgpOw0KLXZvaWQgZHNhX2ZsdXNoX3dv
cmtxdWV1ZSh2b2lkKTsNCiAjaWZkZWYgQ09ORklHX1BNX1NMRUVQDQogaW50IGRzYV9zd2l0Y2hf
c3VzcGVuZChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpOw0KIGludCBkc2Ffc3dpdGNoX3Jlc3VtZShz
dHJ1Y3QgZHNhX3N3aXRjaCAqZHMpOw0KZGlmZiAtLWdpdCBhL25ldC9kc2EvZHNhLmMgYi9uZXQv
ZHNhL2RzYS5jDQppbmRleCA0ZmYwM2ZiMjYyZTAuLjQxZjM2YWQ4YjBlYyAxMDA2NDQNCi0tLSBh
L25ldC9kc2EvZHNhLmMNCisrKyBiL25ldC9kc2EvZHNhLmMNCkBAIC0zNDksNyArMzQ5LDYgQEAg
dm9pZCBkc2FfZmx1c2hfd29ya3F1ZXVlKHZvaWQpDQogew0KIAlmbHVzaF93b3JrcXVldWUoZHNh
X293cSk7DQogfQ0KLUVYUE9SVF9TWU1CT0xfR1BMKGRzYV9mbHVzaF93b3JrcXVldWUpOw0KIA0K
IGludCBkc2FfZGV2bGlua19wYXJhbV9nZXQoc3RydWN0IGRldmxpbmsgKmRsLCB1MzIgaWQsDQog
CQkJICBzdHJ1Y3QgZGV2bGlua19wYXJhbV9nc2V0X2N0eCAqY3R4KQ0KZGlmZiAtLWdpdCBhL25l
dC9kc2EvZHNhX3ByaXYuaCBiL25ldC9kc2EvZHNhX3ByaXYuaA0KaW5kZXggMzNhYjdkN2FmOWVi
Li5hNWM5YmM3YjY2YzYgMTAwNjQ0DQotLS0gYS9uZXQvZHNhL2RzYV9wcml2LmgNCisrKyBiL25l
dC9kc2EvZHNhX3ByaXYuaA0KQEAgLTE3MCw2ICsxNzAsNyBAQCB2b2lkIGRzYV90YWdfZHJpdmVy
X3B1dChjb25zdCBzdHJ1Y3QgZHNhX2RldmljZV9vcHMgKm9wcyk7DQogY29uc3Qgc3RydWN0IGRz
YV9kZXZpY2Vfb3BzICpkc2FfZmluZF90YWdnZXJfYnlfbmFtZShjb25zdCBjaGFyICpidWYpOw0K
IA0KIGJvb2wgZHNhX3NjaGVkdWxlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsNCit2
b2lkIGRzYV9mbHVzaF93b3JrcXVldWUodm9pZCk7DQogY29uc3QgY2hhciAqZHNhX3RhZ19wcm90
b2NvbF90b19zdHIoY29uc3Qgc3RydWN0IGRzYV9kZXZpY2Vfb3BzICpvcHMpOw0KIA0KIHN0YXRp
YyBpbmxpbmUgaW50IGRzYV90YWdfcHJvdG9jb2xfb3ZlcmhlYWQoY29uc3Qgc3RydWN0IGRzYV9k
ZXZpY2Vfb3BzICpvcHMpDQotLSANCjIuMjUuMQ0KDQo=

--_002_20220314111750ym5xiuvusj4kl4t4skbuf_--
