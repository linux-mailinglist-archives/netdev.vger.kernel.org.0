Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAC4502D3B
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350085AbiDOPpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355205AbiDOPpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:45:00 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2062.outbound.protection.outlook.com [40.107.22.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4039C985B5
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:42:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoL8aGgO2BOpnde91KuaC/1Ue+7jiyQkpqo8FXp5KMCSZXI4WfgEKsLUTpra46SV5JFi6XhxYc2KBCCgEWhab0C2eL16zuj2rsojN/crYKNBI9wX6Ug8nGGgBp0//wuh4BdVSoFJye8MXNJCWNdl7Yro3Oo45gckVMHbznPMWCxH4byDan2Ux6R7HZnf4fnT0M9gwOtIQUSmiwmK6gnRPaGVgrkbZCa7WBiPtWOevEdzXXWztItr8e8tjyZnEt9ZYhKjWmbhtk6zgk/c+wnyWYrDYKMPeC4ThDhOeGVRfI+joXmc6yvG7mhRrXui91T0KxRgXvrMi0iwdo372pmNEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RAB6efxcxAJfzIUsM2L6OvkbjfyHwOPIb3Fd14YeWq8=;
 b=PWYSEAvu+RKFcOhzSbgRWncI/zC/7j9hfah4TnFnU7i2mSkFktzBlEwdtA2TnhQ8sJ8RZyP0P2eDteXyw4biZMAaq92cq9JWWvE70IgfYxayjTjNIECaX0KIdkabi1s4iF0dAWhwef+tUtJc3ecO8erjD0BzZ/Cl/hmxxZMQHSKwxUKKjQmqXF9xjKpGD5lDjMO0BAony8B5psyp9796Tp7JeDjcmHNC6J9l7ipXuE4scW8KeNlz62Bxk4YEsm7LV39BNvmbioBYbCMnA5KN94/LP9EDTZ5mtqqvwv60Y8cKrLG4cONUJwWzc7FUEGb0oldPtVdySGYpYvFzWZqEZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAB6efxcxAJfzIUsM2L6OvkbjfyHwOPIb3Fd14YeWq8=;
 b=f2OjKWrvUsyjCmNT8FQHprarW5+t4yl/rapcJO8nfpcth8PNvX1xdlsIh3LYT6J61FrLhz3d9WhGp99TeRepW7W/lSZoQWjDaX/ewcPtuWZXpCFSGVrvkGiDNvRbUwvVYnjsanYV9pIp3S7ntT2vI49pCNs3JQIX6toVlHDH6Zs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7715.eurprd04.prod.outlook.com (2603:10a6:20b:285::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:42:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:42:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>
Subject: Re: Offloading Priority Tables for queue classification
Thread-Topic: Offloading Priority Tables for queue classification
Thread-Index: AQHYUN6zSsGc5K6OCUmQVm72S/TmSazxHRaA
Date:   Fri, 15 Apr 2022 15:42:29 +0000
Message-ID: <20220415154229.pmzgkgvlau5mftkp@skbuf>
References: <20220415173718.494f5fdb@fedora>
In-Reply-To: <20220415173718.494f5fdb@fedora>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 156fd848-a29e-409c-effb-08da1ef68ce0
x-ms-traffictypediagnostic: AM9PR04MB7715:EE_
x-microsoft-antispam-prvs: <AM9PR04MB77154671CD5583C2ECD9D11BE0EE9@AM9PR04MB7715.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 70m9AS1BDI72iqcNMaDoPOelIzPwJ1RtQ+HTff1bjhIpogcMXvRZdBlQZVPyJ9iI2Oi16VT5QRbBFRFgVqUMfPk1cw1ZvfZJIhYoorJG8dD3l/QQsbygPmogpXxuRIUaWENUbSxuFP4oLT5Uo0ehyGa9TsUbbJMQD9KKo5Bp2y5ZCEk/k2HJKbJn7Cy7pgRTNcRU/ypU+aTxGoHY5h08bFtc6bz1geWoKQJKzIklXoyIg3Wc61tkbZ+TaveGZxCM4I6u8dG2dfpuFHTh26onnRgoXveLb9jF2LvlS/pP6G8m6TRWPwM/mpOk+PbdAA+KCgh3nDlzWVSfIrwL78JH68KNHtn89hEq1gfRt/XDobtNPagAFSIF/C5L9KzKHMfwuyzP/vvCEVwLNDMBbkwr07C6sH4Bh2dOdChsVRO9yMCcZwz94WqNvyHcWUHVbf0wiTH9isjQyNRfzZuGKosja1dWT66yGBfbh+BzsnNU8y4CnfcwiUZ2oNlNDlTnTcSFYEhjR/SgcN60hCeHeZlIix/n5StuLkT6f29RYpn4C0IO1gmZwmNh2DUwRrpLq6dHNXRmOtaX6gH/ON/gGrKEdsdF/Jzc4pwg/cv7G1dnCp5gg60rAWAnZkbEluMoJ+P5A+a/gIOgly1c904QzWNTo9XFf2jmox2IQfhEoBWi7iGSk3fVlIaF1PKBaR0i8+REME7tE4zVcNlgMLCjtmi7DDZh5M/iwoSB50BB/DcNQZurAIdCL8KlepGKTTUxhupDnDiLRV65qsLF5QVOIEp+XWCP8jiyK5ybM40Vfzye+gU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(38100700002)(54906003)(71200400001)(122000001)(6916009)(8936002)(316002)(86362001)(76116006)(26005)(6486002)(1076003)(66946007)(64756008)(66556008)(66476007)(8676002)(66446008)(4326008)(9686003)(966005)(6512007)(83380400001)(2906002)(186003)(38070700005)(33716001)(6506007)(5660300002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U8J5ZAfJ8oiKxTzu9b69SnMzI91kcVuCSqPA4IGOk04GynQx10sMT4wk5AWD?=
 =?us-ascii?Q?sziR45todQv7e03Yyoyz4MVBAENn3s/0hwi0vci26GGLrIef8ye9eTZdObfG?=
 =?us-ascii?Q?lexkIBvQ+ANdSG4JwRtD5vL+Dg39oXLZ5XeioozgMCIUjEw/T800xFQrxay0?=
 =?us-ascii?Q?ST7mqKEdLKEkZqXZI/2FjYkkFOhm/g+NXotrUE6s32gT50dvtlSGHzSwwn89?=
 =?us-ascii?Q?ENZlVXn//VEJm6nLYOkwFq+RYhoiLOoKhV98rBN/QVScp/kQ8B1QUPDXfVjG?=
 =?us-ascii?Q?hywhjcYp+optG/dr2cVKvnSUtwHN4ZpvI0dNps83pZ/59s/oVqC867RgOww8?=
 =?us-ascii?Q?TxuSzs37nBJQ6cMiy47uO+LeVeFZC0mNdDMZGLRXMrYoz4qPJzNiqWewqs78?=
 =?us-ascii?Q?xpX1NiAoCfoUCnGuoGLOI1PNHGdFjoT2bjjxEz+azQWW7tJMkeJusCDUKk+5?=
 =?us-ascii?Q?xD2ma+njXFQOoPwJA+Hn6L7ik0E+ylhkrHNmbLooAwBUf3OF52Q22YZXCjWl?=
 =?us-ascii?Q?9U18Z8QZ96e5XDEiiOtp0mEneSV1eneWfo4MinP0ajt1ScgH772Jd1FcyRmG?=
 =?us-ascii?Q?L3IDOYKutcPeg0JorM+x+Jy/WM7VjZJ2BtfkOgEjx6SbGnsbGILlGMcrvvZp?=
 =?us-ascii?Q?2klGzg8VSqNDBWaTIlGKtDS7oC4lhFjD/lwCgzwgcCH8Onxw4Cvq3mz3haK+?=
 =?us-ascii?Q?7jDlZV+v33NfKhV7PV+TE30VACoFaNVEYAu04INiQJzANVbkX4Ay1pVgF0Bv?=
 =?us-ascii?Q?Kd/BjMMW2e1MQ4wO3k1U+nzTqQAxl/q+QHr0JESG5hpu9YlAxxQoeYxMRIqT?=
 =?us-ascii?Q?xp2UMIylibDjBJo6UpLLt6K5USvkkq7z9fXlN9c8k62p6RRBwQ18yIV5SoA8?=
 =?us-ascii?Q?ypHUElg0Dh5UaNIO1pR4pwiuKvXs22PudyPErpPWcOpJ6jCj/li+eIHXByHY?=
 =?us-ascii?Q?2wn0+jyCc7CT9oLXtjac2c3M/N2uY8ogwmbu/85VQ48XjJYVz8htY1imM/07?=
 =?us-ascii?Q?0M8HS5FSW0pb5q4U9i3snzY+mpyh0bs1uy3zbYudxnP/OpYrBijsIvDWu+nh?=
 =?us-ascii?Q?gxYzHE84gYbbna4FEyn5y/LPCs/LgwCnZgy+LD0GhKECYav+/5+nrDW3A40T?=
 =?us-ascii?Q?NvRx2uewXv2t7vfmEgYEsyroJI3ClNTLFUXTRIwcdD3dKPDdpRsFfX+/OZKD?=
 =?us-ascii?Q?xsMwWfMHBl6a3DJVyXOp+ZF/NwcB5RoSBzIhon4Wc0ZNZSDctUW6IV4VbzHW?=
 =?us-ascii?Q?Y90NK8KZp6Hueg/hxNDXjVUPteCqNXGwy8XBeLQYNp8ImhDmF3XwEhwXfTlg?=
 =?us-ascii?Q?Ee3NWlmbXbNMqWMJcf3CvaIWGp+7tKHtsOUskMGibo1UzEQGn8mC7CnAkkt3?=
 =?us-ascii?Q?Aq5JCr2WXwToYkFCxwU6mwsNZFuvVwRmuRsPhzNWBgnKsvqktQPTgwAv6+Oo?=
 =?us-ascii?Q?M9LUfHA84DsD9egyYr/rE7WYvXhG/v07C97KogBIwZsPOs9vuXlEagw0S7aA?=
 =?us-ascii?Q?Cr0O14OEGdryT/f6MrmYnhET/X9rszXGuaMLeerX3QCVw6ZRxB3LMQs8XxYy?=
 =?us-ascii?Q?jWcipumrxVcJaaPz/8Q9tEaPShKktdBv5Y2//ekWHgRTVEBc6cZA9CBlrWJ2?=
 =?us-ascii?Q?xfVX7WMYFcTPXHf6HgaIi209REn6G/X6Hwh4Avj+zqmwp63aY6+D+QHGIbTB?=
 =?us-ascii?Q?gGZr7OU0hL7QfFB/HeL4dOoFTJwLpHRJoGaCilK7AsdfzPRDWcQheFYSLToh?=
 =?us-ascii?Q?2LOsW5qPYnYqEOsIIvJD55G7OKhjkSk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B988C4EA5250C546A4774F7D34F2F534@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156fd848-a29e-409c-effb-08da1ef68ce0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 15:42:29.9905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WwlVjcd/msR0j2RjA8nOdxSqoM2l3xXStiANdBwH3j1P7lQ5voFBpIPEo9ct2zjMagfgITSiXBiMybYbD2GTzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7715
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime!

On Fri, Apr 15, 2022 at 05:37:18PM +0200, Maxime Chevallier wrote:
> Hello everyone,
>=20
> I'm starting this thread before any kind of series submission to
> discuss on the manner with which we could deal with Queue
> Classification in NICs, and more specifically how we could handle
> internal classification tables like DSCP, VLAN Prio and any other
> tables that we can populate in modern NICs to quickly assign a priority
> to both egress and ingress traffic, and use that priority to select a
> queue in which the packet will be enqueued/dequeued from.
>=20
> The use-case we have in mind is to offload all of these classification
> steps into a switch , where traffic would be classified internally
> into queues, that we could configure for Frame-Preemption or any other
> QoS techniques. I know that Frame Preemption itself and the way to
> configure it is still under discussion, with debate on where to
> configure the queue preemptability (hence why some of you ended-up CC'd
> to that thread) :
>=20
> https://lore.kernel.org/netdev/20210626003314.3159402-1-vinicius.gomes@in=
tel.com/
>  =20
> There are already ways to do this classification, but from what
> I've gathered, it looks like it's scattered across several places :
>=20
>  - In TC, we can of course use TC flower for that. We can neatly decide
>    which flows goes where, match on any of the fields that we can use
>    to determine the priority of the packet. This however scales poorly
>    when the underlying hardware uses tables dedicated only to matching
>    specific fields, to assign each DSCP or VLAN a priority.
>=20
>    TC flower works well when we want to use a full-featured
>    classifier, using a TCAM of some sort combined with complete
>    classification rules. Using TC flower to configure such tables would
>    mean entering one rule per entry in our tables, which could work for
>    VLAN prio, but not that much for DSCP tables for example.
>=20
>  - TC skbedit with the priority offloading is exactly what we want to
>    achieve, that is to emulate the skb->priority behaviour that we can
>    configure with various ways, and map this priority to queues with
>    mqpriofor example. tc-skbedit priority when offloaded handles that
>    notion of "packet priority" that is used internally in a switch.
>=20
>  - TC mqprio and TC taprio can be used for the actual prio->queue
>    mapping, even though there's the "traffic class" layer sitting in
>    the middle.
>=20
>  - It looks like DCB could be a way to go to configure the DSCP/VLAN
>    prio/any other QoS tables, since we can configure all of these tables
>    with the "dcb app" command, which then calls hooks into the driver to
>    configure offloading of these tables. Using DCB for this is perfect,
>    since the traffic to prio assignment really is independant to the
>    mqprio layer.
>=20
>  - Finally for the last part of the chain, we can setup the queues for
>    PFC or Frame-Preemption, possibly using ethtool as suggested in the
>    above-mentionned thread.
>=20
> So in the end, my question would be : Is it OK to mix all of these
> together ? Using the dcb layer to configure the internal mapping of
> traffic -> priority, then using mqprio to configure the priority ->
> queue mapping, and then either TC again or ethtool do configure the
> behaviour of the queues themselves ? Or is there some other way that
> we've missed ?

I think it's ok to mix all of those together. At least the ocelot/felix
DSA switches do support both advance QoS classification using tc-flower
+ skbedit priority action, and basic QoS classification (port-based or
IP DSCP based) using the dcbnl application table. In short, at the end
of the QoS classification process, a traffic class for the packet is
selected. Then, the frame preemption would operate on the packet's
traffic class.

Do you have any particular concerns?=
