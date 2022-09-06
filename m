Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4791F5AF442
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 21:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiIFTOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 15:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIFTOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 15:14:00 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20082.outbound.protection.outlook.com [40.107.2.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB88A833E
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 12:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrqrI5DiHR8Tbe7eu3G0M9KqlrfK3z0T4V6TyCwAi4W7OFjEFgqQKFGH8nztLmM1uXGvMmAzc5nHHe9l2XC1UL8eZEFcT8F6vnpnY6GHeptGOLAClUZScZH7AcDMS4RTJpLMOXaITO9LyeDSHCCqdWrR7xNfhkEL0gP2zy69piy08+xSH5ykCb+6IbfFFrANh5at6gcQn25jF79+DnaQo+A+JA+MlBZ99/ISdUbNDpLPj/USSQyXCk/u9IH7wWrORsC29E3LzvKnL78eBRy0uF6sqRR5C8abnUvi//+mOFEnIOi/H8CYMA54muPKoVLwgq0yeB8vQDOH7d7Hr8CWJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRMFQ0sJgJ/vtqSg5jkst0GYUN/HATEad+HhdHK9xQ0=;
 b=TTUv3OqRR3gh9obO8z/V2y8r6n1MrvcFlnqfriaOUK9wCygk5OC4LkOLH+LcxUSntgLzwJawG+gsa2qrdYeEBar2WH6w4ujnbCEcKUlA4fsDdurSQgZVmeOpGW8kKGAbMzWzwlLaFxgm7KNqsNTTOfn+soluBGbW3TQKHUqsC9bel0AiSKlkn0VoyfSyAhSIGxMpAtkJyp2hfi58U5UhHgo1c8lJfnvEnlz20Klp67M5dLbdps/hqJgKiJwXrec0onZO4rCBsMWKgF3sT4/M71itI6bg95xB5nOClfvK2UhzAAdhabTeMvkyxZLnTo71tBTuaerO6cjtSd6A69XPSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRMFQ0sJgJ/vtqSg5jkst0GYUN/HATEad+HhdHK9xQ0=;
 b=BsaJQPbZzx39ljZSKB0L2UJ9Z00Es+BLx7q6VbLyohwix2Q7vEBnLN8ez7sH1ODIGyrlDbtux5LMj5dudg9kj+lwnzLo44/Glq5t3u/JiuCSbCVj2sYiPsRKyxgVZeFxvg95u5Dqqrie6Eff1q69uT7APGv2uoImexy2AubsFF8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4420.eurprd04.prod.outlook.com (2603:10a6:208:72::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 19:13:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Tue, 6 Sep 2022
 19:13:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Topic: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Index: AQHYwJCiMb7bHcv8sUSdQE+5fVlfzq3Sia2AgAAUKYCAAAPqgIAAJryA
Date:   Tue, 6 Sep 2022 19:13:56 +0000
Message-ID: <20220906191355.bnimmq4z36p5yivo@skbuf>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
In-Reply-To: <20220906095517.4022bde6@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddf23982-a9f8-4af6-091c-08da903bf1db
x-ms-traffictypediagnostic: AM0PR04MB4420:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9dHr6w1V2Vmb7D2W9/DeE9TT5xKeM45fscQUceWe1th3mFSxBK4WBUk+8bB/uTri4698BbAMU+3mEEOEO0Mr/R7C8TNigacLU89MHPXsiyXEspwaePUWB7AZtLpgUGqdV6L98EG2LbwGDoSIFuOQxV6TvTbDUKrKqP/7nefhNk62FR2ZVFRGmXTn/rYpzAuBPfkaxThWDPOy61bUfaBMyuOnBVc/k5VGbufipoSaTOxAuaM/mLVz6uHjzOmyVIYsg2aJ4c7tsukxdic5GEQNubV/qtFhIOn9UJ7ftW4YYqSdPfH31IaqwZrQco/+DHltCJJsGf1XfjQp/aLyVHiqduMnHRSXt+lqAx+tZv1JTfHyZbRmkMDqWL9Hq6XJq27M5psEzv5rZbH34kt0UDtZplBC5vhKpJPwpmhhqMysjbp0xvhvWzuXJAaV+Ch/pnp5PrAEQxO1habsoFfdjv5BemgV5A+E4eKgFqYUcC1eRT+QgjFrIlKrtEfh1idtvPNk7hbGFul4nrAe3I+WisezQ57ZvYh4lIUer4PAE1qzmNHNgiE4drBe0ILB9IwbWTvXQjMWdAOyy/95gEksNCqXdJGU77PTwKPVma9svf/fj3WFhELBRLMBOd9f6HOZfdFHjqnTobqK+wouheJVXkq4enmiJQRejDRgo3tIUiSwJ2Xe9zhmPa4bgwgZUBR7k/Utfrkw/IShS9KtSDSRHt+Ol5HD/juvWmMj7/DuMojYH/0PFzzMqAuAGJSYT+Q8C0Ee86m81Bfs1dwy/Y3LkVHSUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(9686003)(6486002)(38100700002)(6512007)(86362001)(26005)(966005)(6506007)(41300700001)(33716001)(71200400001)(478600001)(122000001)(38070700005)(66556008)(1076003)(186003)(44832011)(316002)(2906002)(4326008)(8676002)(76116006)(66446008)(64756008)(66946007)(6916009)(91956017)(54906003)(5660300002)(66476007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IxaIJktHCV+TcrMz1MkXNXcQlSmMRBDJiymtmZ4EDngXB0WAT0PiEqHO0qkP?=
 =?us-ascii?Q?hbaOPUw5Z1iagOd7J7EJ5sF+Q5/2xNVr4h/5zP+qQ0i/vIroac6E4q3iIsF1?=
 =?us-ascii?Q?+hLsSfU4czHzxYQDAUNs1vk0lTAz9Bt3sFm2OvxclDgydCqujRPI0yh6ybji?=
 =?us-ascii?Q?nk0nVYZ0vVsgaOJW1g8uhVDQs0yupAC3E/rn6IfF3Doxo7+D3CjveuWUNFpH?=
 =?us-ascii?Q?NBRFAXW/DEGtb/tXzBInQJ6LXLzOaTwaicLTktwgpbpUbkNj/zP5tWPLizLu?=
 =?us-ascii?Q?k7EJCLllInl+vPPH+ALyxT9/d1Hrx75niJ+C0WmDu3FU72+v74KnG6rHiWtz?=
 =?us-ascii?Q?814QBM456KBxDEqElYxsPhJHhYTyo07T+qDbVI3S6a9OoUoMYmUqu96Ax9qp?=
 =?us-ascii?Q?wAclnBDuUGscsVtNphtS/DBzc1EzQor5Y3twujRZH7A0Fn8dXjWQuwwOPOwY?=
 =?us-ascii?Q?IITwkQoV7Ff6SxRazi5T3AyOYCnvaNfkw89u+Ca+EuWCMv3y2Co8hdSv0sw9?=
 =?us-ascii?Q?CaaIFl0nZQra4QEUGUj0BqUAEMJoa3lU1xB5cU9AdF/W19U7InPn0Ko/Eyww?=
 =?us-ascii?Q?ogXBX9ZmfbHglJ3E0LCpT8bsnzzF0dXBwjtBCOigrbmjgAsUoD/DLcgLL5nd?=
 =?us-ascii?Q?9nhxNFcK5P6GJetBxhHSfFckFbEPhbuX6ghceXx9OQo3HOPb+Nsdtq+oKQcQ?=
 =?us-ascii?Q?i+5Bzl/IEfajDc2mC1iUEpWxqmkcUJUSDd4NBVvmpl/TxV+bJ7kT3ZmvsM6t?=
 =?us-ascii?Q?xUoA897Gl8mFzzeVrwRP1cXUY14IrNOC5Xi4gSgvUKTA1ZEWvZZ108e7T1gU?=
 =?us-ascii?Q?PPjlBOmwcOQ+HZqX62py+gtR4U1MbLZj286JoBVzKD2nP0NDBJp2ygj6bW86?=
 =?us-ascii?Q?FtQABUpo14vD9/SvZTr57X4irMt6//+jLNHdq3bsTh6qwU8WyMvxej2nWzqo?=
 =?us-ascii?Q?nR0ks5CGPJR62sNDqMNRFic8Di1GsOZv0IhDadtwOBjxfZanTHmnGB8QpW0M?=
 =?us-ascii?Q?LjF7doBUdV6RH2XaA8zWAJ/GN28Ut4/lv5rfIaWwt9q/5aqINsrScmA/PKD6?=
 =?us-ascii?Q?E6xLGiyM3C9kXfjwWlFEieUu4w/7m0LBbyKSNGHarWYf3XdafpbEt82CERrZ?=
 =?us-ascii?Q?U+Z4kZWG1lQBtT0cn37QL71YlB3FQvARp/ctUlJW6FPQA86C57NcmQFGWktP?=
 =?us-ascii?Q?432dxuFyP8CMGlYeC8RdDM0L3Wtfof+7MN0RnFU8+TXv3txvOt/SaByd/Xym?=
 =?us-ascii?Q?4NHnJwWI5HfSaeBRG9kF2qPDcKgJMP2bApSoCR0LsDKZAGhkl5PCAJAwSUhX?=
 =?us-ascii?Q?E4MUJoNVoA5jn9RHgdpPhsSfwUIY8sWcJVA5jvzLhjxvKF0TNa73Z8+DVqOB?=
 =?us-ascii?Q?HHBfQ78dtN1DB7/qgV5yNoQygtElTZh97WfqVxabgOGkEAZyndUHIw7zy/GB?=
 =?us-ascii?Q?xaAlx2cXqHmLDhdPe1en/MgkZqgIcjezqVPq0tEuKakl9tUHu5WjSTUoUyvZ?=
 =?us-ascii?Q?wrG53bwCIAdzr10c8RU48uWZYTGzYsJ3/X5dxplwXYKeKSCj421gqCnBqhPG?=
 =?us-ascii?Q?REytM/WnOIDMv6CBDX48jacvwdFnmM5ca859aEiVF+5gP4SEVeUBngs4JVav?=
 =?us-ascii?Q?LA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1F83FDD5F0514842BA454FC3652F4CDD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf23982-a9f8-4af6-091c-08da903bf1db
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 19:13:56.1011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MpwqjyxrPvF/ffHDBWktj1LK4SlSmlDGM/MQeXxI52Sg47XA+vhe81ys+zV0bpU0HcTUfm0zzzSqEvOEAMGxHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4420
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 09:55:17AM -0700, Stephen Hemminger wrote:
> > > Using the term master is an unfortunate choice.
> > > Although it is common practice in Linux it is not part of any
> > > current standard and goes against the Linux Foundation non-inclusive
> > > naming policy. =20
> >=20
> > Concretely, what is it that you propose?
>=20
> Maybe "switch" instead of "master"?

"Switch" and "DSA master" are not interchangeable concepts. A DSA master
is a regular Ethernet controller that is connected to a local (onboard
or embedded) switch and handles its management traffic. The use of the
term has existed since the introduction of DSA in 2008 and has reached a
wide audience among users through the papers that popularized DSA later, ma=
inly
https://legacy.netdevconf.info/2.1/papers/distributed-switch-architecture.p=
df
Whereas a switch is a multi-port Ethernet device that handles L2
forwarding by MAC DA and VLAN ID, essentially containing a hardware
implementation of the Linux bridge.

[ Alternative answer: how about "schnauzer"? I always liked how that word s=
ounds. ]=
