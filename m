Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3030599D04
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349267AbiHSNjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348729AbiHSNjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:39:04 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60086.outbound.protection.outlook.com [40.107.6.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41217E827
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 06:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQPcYwK8TOMCC3eY24RQjq96c5QcO22f8/c5J+/+mpA/Mk9Eix6WWLwrowQdKm0jU97LZNgcmjJIUXHnzlz9F8rr6Nbtja9d7OmxVzSkMNOhOcw8755Q0gpUwwom8FRc2BcIa3cH8znuygeg7SA4/y4XhPcYgo7wIATWCE0ItUnjnmITqUO7DqjIcWGgK0r1ugZ9FZ2SLrULofAN0lxD+l6T1z1/em0Nob8+ig/WtMqwK2uikzMseiIWwDPZ5dLPGdjMzU6isMjyaVvkjh7ZnvfkF4vVFvl9Ua+vfWeQc4bkzjCdaV4bhi5FG0TWieZ6pIroQbtn0dKoe/TIZ0O86A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diMOFrKggmzH7vA6giBRMebPkPaZ/vlLD+lhW0Q+/x0=;
 b=XCZMUekSaIv0HhkDcwZzR0/V7k+p7qQpBfTh9+E2ksqud5aVPJepaPNOec3t9XljssdciaAj+Ig6asfoNss5tL1x5wA/WYkApBoxeYchT6Wd37zuXaEYJFdBQLl4lps9PL8subseNtdVXN/Qzdgk9RL+8lLhEAlzLvIlYiLlSWYKl2xAKzHOmHk2nrIxThCAOX4Swu7d6YMBR1JDJ90XTEHNLJGks6amhtk+nSMfqHBn9L9fVGL3eQhatoeCTQmkfx1vr2YSsFRJcFhzdGFuUpULn0xls7/RF7QmTkc40WpHo4L/2lakFeut901TNSriX3Re66Vh2Oe6+kv5bSyfaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diMOFrKggmzH7vA6giBRMebPkPaZ/vlLD+lhW0Q+/x0=;
 b=X01svqq2S2dqLxIUOYbzFHg4p6DT7WZmbdgneTWtQj2i99/RIvVEycgCa50IF//5cf3IJiZ6jmjHXNDgx8B4TdXnU19ekzDu40raRP2sx9wv1Uf/7kTWX/v+1HzReLZLgpUJU1+BOocO92x5jnTc0AeOQIlxYu4TDtko8729Auk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4708.eurprd04.prod.outlook.com (2603:10a6:208:cc::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 13:39:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 13:39:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Thread-Topic: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Thread-Index: AQHYswnglvLyEnQT3EOaMpXlfQkMiK21me4AgAB3bYCAACpYAIAAAEuA
Date:   Fri, 19 Aug 2022 13:39:00 +0000
Message-ID: <20220819133859.7qzpo7kn3eviymzo@skbuf>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
 <20220818135256.2763602-9-vladimir.oltean@nxp.com>
 <20220818205856.1ab7f5d1@kernel.org> <20220819110623.aivnyw7wunfdndav@skbuf>
 <Yv+SNHDXrl3KyaRA@euler>
In-Reply-To: <Yv+SNHDXrl3KyaRA@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fd9fef5-1d92-4640-ee0e-08da81e82cab
x-ms-traffictypediagnostic: AM0PR04MB4708:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aFHdjEDVSS01W5I27J68XHH/XztentdtZKOYm2aKZ2jICZD4OiP7WmPVWgE+j3N//aoNmRgIzcJhpJMZ2zlZRxtJrfP8rVUsUWUfbAyEaYcQanXASuiBsWSMx6QvVhdLZI65H5koCrw4k9bfh/OMvpno9wVjLahBZsA5C1IGVd8kEHnIWTaXZuyMyMqaS55vmyQTDgwJmwv6vP7vjHLGXc5DBHDh84be4+NRu0QrlXbCsxKkSQQm5ghPpKvE5uPqIr2Qoi3poqO1rlMxz9Szp38hkP4A4yNYaTUFmjaetjNiFWOtOa2m5KR4ZiaaMlkNN/48o2jr/TGEihZZXpUyDS5iQI6KDO75zO2anOWT0aFUBR27qPE56wxbYz1yjTisF9LIhtzvA64N6HYZ8lphZ3AWin/5VjU/k994ThFHUYZeBMO/tdtRpoZ7B+c70hc3BCqjdPIg2tgd4BcJwbpzc1vcv/sdhyJ3b+Wog0z0ojxA9/6ZYLAmY+wcwzl1Gh2l2lEY5gZM6d41cmBoqwKdfXLyyec6R6qk3zYJbReivDNbOuVjN3k75tXS/eaooLsaX35pngXC7y82k0J576vo+IIbhNSqLsQOIMIAIOMrW+ij7T4ZCb4wh5cUihRPCkIaT8iyI+5sLULN95PL9wh99H9tREZRswF0tIYOsqhZaEf8KSrmL7BlZpvmS9y/z5OrrK5gzoTIo1DvUqJZjxAli5nRwc7kYGPCtPYbV+twn/k1Sda0H2R5HQ6t7efpsfMc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(6486002)(71200400001)(478600001)(316002)(33716001)(2906002)(54906003)(6916009)(38070700005)(41300700001)(86362001)(91956017)(9686003)(1076003)(186003)(83380400001)(38100700002)(26005)(6512007)(6506007)(4326008)(5660300002)(66946007)(76116006)(66476007)(4744005)(122000001)(66446008)(8676002)(7416002)(8936002)(44832011)(64756008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QnNPzIhmmaMIPDMsj7zk2xlORONMkyB+WwcrhfVZQIo2qMaVxtTEZ3qwNXOZ?=
 =?us-ascii?Q?O6xC+iyEWcEvDYhCl6RLZzWHwEXY/AMu0G6gsI7iL1aDi346zjYasx5ahsmJ?=
 =?us-ascii?Q?b6SinY+OCPio9pqc6rEL7WTMoOpqPgO/dJRr2FMItg6M68coJQFk7F55o4zS?=
 =?us-ascii?Q?/dpouVJg1tEY6ikC9YvK7S9ECo+xIq9l0ZkQfwiN4J60G0riaUqZgyKZ/1CT?=
 =?us-ascii?Q?1JNGTJT8QHHNsQKyVtnRWb5hKD+oHcwV5zRA85s+RUHYBf66Zvz4WpPTHnZd?=
 =?us-ascii?Q?CXCG3U1WJEZonj3FWkyTh6CbrnRUDzPC9xTEQeU8bs5oFUzbdpDAjfvje5Vq?=
 =?us-ascii?Q?+/ub1oT4Wc3PYXPM+BFm+1KkGlQ0j+PyWrsfHc1O63KxhK9BSfsBcvRTnA3d?=
 =?us-ascii?Q?GeYjQ7L0zyPYh4FNHvwe74Tr0zJC7Toitu8BeiWzR6K1ZR6RP7/9V2fqnlN6?=
 =?us-ascii?Q?rwPL3hN1+BB5XrbbG2iuUO2Cy/vS96FpgNIiUweer9PRqfw5OJhmH4fXYnWn?=
 =?us-ascii?Q?R9+iPGAzOsKwPgJs5HfuRKV5H8NHRpc4VcvuPEZHxhKSU9j0oLVRItiwAwSA?=
 =?us-ascii?Q?2Htbil+4I57sTRzjkr2Eaty3Xv+DeGl/mQVcLj9BrIYODKXm0lSNrbya8vdr?=
 =?us-ascii?Q?PMdYPoXAt83Uv45APJEr/n7uyE/9Q1ELNEgzLXWFGXncedNMYbIVuAdjfwxL?=
 =?us-ascii?Q?KxPXNuERa1ScFzDiY7F8JtfD0tOc2Qv61fFJsr5ov8D5DTflxBGWK2Trffpi?=
 =?us-ascii?Q?3UB/vc0kUaioA+LPTAhthX+LdW1yffZxkcmym9+1wBozj97wpIJU7Gt2fBDy?=
 =?us-ascii?Q?doDWrr2R2k4ip7KWCtHa/C8OQbUC4J7LLV1bQipVpo/lPvwHzqYZanHsIw6M?=
 =?us-ascii?Q?yPpVFw5YAC3WoMGk/0omBCX2TtgH25vq3C2elXvO1aHkE6dsxiQ9BqSowGQK?=
 =?us-ascii?Q?nYUsVqEq4+L1r4zvK3GD+TexSwDK9xh/6UytZw+PxOBXyo+haMMOaOAGhObj?=
 =?us-ascii?Q?4tWxYVrUyLlCj8Eg7YDoJy05bBzBODOiUX0mYpYvb5sk1KGOT2TmBqljt5Ws?=
 =?us-ascii?Q?RX1Wr1UPkNnhwwqp5da05T99SDD03vL0+KUFs5KdTv3m4EGAqiamFZLya67o?=
 =?us-ascii?Q?RfOU0NltgWa4FwW5Cxva/w3NgUT4w8VQF+ws/NaPBSSU2tVifK3Wsac1NKMG?=
 =?us-ascii?Q?FPXKhqu3Wj34oa8IROKPeMXowiDKhDj6IvfqYHMWwRDMWeGQ0vUOiV8D83e7?=
 =?us-ascii?Q?5ili90wic2MQe+xTf6lwtZp3Xcwmtr0N7NzDHehTlGOwuKechFz2a/3Po1Rs?=
 =?us-ascii?Q?TzXINUw8UvwF3KZN8CNy9xO5zuFepEtNUkMWB4Dp0zcg6lkZdzTFqHvTHEPp?=
 =?us-ascii?Q?oA9jb3gAgPs5N9SGtm2nDRepyOiq2PxSToLL620m6BdBg6s7KovZjlFS/UUh?=
 =?us-ascii?Q?0o+wxyMW3+2PqXQXSxCmDkxP6AGZSQO5nJoHOLuFXzlZX+XmjzMaQ0eyBeXF?=
 =?us-ascii?Q?mZcpP8cX/bKnSwKdhF+iC/wAY8NJE+bq9N2LCWctP3ythsWNnOHT9EbJ/zEW?=
 =?us-ascii?Q?ttGJJtui0dWNbzgrqpOLdRiIVJblFnqKBIbfb08jDgg5Le+MctoyAKlLt6j3?=
 =?us-ascii?Q?Xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B2799BE4F153C648AB7EDB0BA0022133@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd9fef5-1d92-4640-ee0e-08da81e82cab
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 13:39:00.7738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S+kuVHOVliskNluJbnX4CfOXHmhx4bv6EenTIP2IhJoaf4Zn46xRIR78jwTMS2tvaKAiIDMdgepHpPPwulJbXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4708
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 06:37:56AM -0700, Colin Foster wrote:
> On Fri, Aug 19, 2022 at 11:06:23AM +0000, Vladimir Oltean wrote:
> > On Thu, Aug 18, 2022 at 08:58:56PM -0700, Jakub Kicinski wrote:
> > > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa=
/ocelot/mscc_felix.ko] undefined!
> > > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa=
/ocelot/mscc_seville.ko] undefined!
> >=20
> > Damn, I forgot EXPORT_SYMBOL_GPL()....
> > Since I see you've marked the patches as changes requested already, I'l=
l
> > go ahead and resubmit.
>=20
> Any reason not to use the _NS() variants?

What's _NS() and why would I use it?=
