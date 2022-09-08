Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CFC5B1DAA
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiIHMvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiIHMvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:51:22 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20050.outbound.protection.outlook.com [40.107.2.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0807FD3468
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 05:51:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfN2F1mUEEp88o9vW3ITv1ARuayOTbpk8DS4h4o8L1OTipF8A2A1TmREziJUnRNLvP/8M9baLm2ymWkJfX2ZXvZniMHgnghzQO7Xg4m2vueQqlsurmt/f1hHf0tOeawx9h7BnF4Q4HNOWME6OAt9nFOmZnxx/Plnub8e+PhnDO3auk/Ne+4SA1HzBQVcMyfoiwMPAMJkXfO6nJQe2LQpc1W9+lS6L4WefKvZmoIQNuzAuwzVsn9peWIPspl7GZ3ND0lGB/lEqgYpm3TfkUmZAKPab2Tx3xJJxCCzE/TN1w5C2ACcghphtr6I/IfSCOqkq3ni52DJDxkYnWr0jUYd9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1FiJEVH5Y8ud0mmOhdwjiJJNJlfvjh7WdvZQNPLBP8=;
 b=AWq2Sahh99yCJghnNGqPo2oX3bnUMcTSFWBwyMhlWT9Ofkmq8peo4nyi59dQaYTqz0fx8OJRYU4APbnW25Hgl/O4Q6XDGapJ8c5Amo0HmxR1NZjOtZ4C8rcyujsPVKFI0Jzjgg2e0joIAYu4d++wlqnRkKWdraqq7tP30EWo7a/mSC+PZMQZR0TZ3BN9dz7NwUYTuGnRZWRx8OsiqU2vwHE4wlANycZp7fbDvC/DAa6IlOc2f0Z1Oan6zPRr8+yVinorc1p8jFyw792FfLMYlp41HXeah40fPS4y/5lhUN+h89J4mvXukFKmFGYlUg6c3/UTYNWM/8fb0LiNAs7sBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1FiJEVH5Y8ud0mmOhdwjiJJNJlfvjh7WdvZQNPLBP8=;
 b=ibtMsqj3UGnNeWicjTPeu9z9JM/nKh977H4f/JswgRKfh6es1+YnQVoEmGuKDgf5UYxdfXIMz5rJ5qTZj0BPe4Na3ozGmxo3kjA/NQ4YwYMyU/THnWK5StR2Xj5uBhKLuVIODrQRo5GjtDXtqlLgB5aCZst4XxIIWCUDdcZfBy8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8172.eurprd04.prod.outlook.com (2603:10a6:10:249::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Thu, 8 Sep
 2022 12:51:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 12:51:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Topic: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Index: AQHYwJCiMb7bHcv8sUSdQE+5fVlfzq3Sia2AgAAUKYCAAAPqgIAAJryAgAAOdoCAAAetgIACo56A
Date:   Thu, 8 Sep 2022 12:51:18 +0000
Message-ID: <20220908125117.5hupge4r7nscxggs@skbuf>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf> <YxeoFfxWwrWmUCkm@lunn.ch>
 <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
In-Reply-To: <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e737c756-27f4-44b6-3ef8-08da9198d2c7
x-ms-traffictypediagnostic: DB9PR04MB8172:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ixeJWB3KQ/e1hLOetPhKx9nGlmLPw/5DHhkHzCX8TAzR5j9CFSn9G/PccH1nr1/xYTB8meEJFEknj5rQMGNn7/wWp0LvYdDIPSdNMe9LoGf0NWxdrAFkqho7mN507Jur/IWGFsePKm5RoZu9hiwCEy8X50vlaVOyXjBG+EyPtQ7sbEAEHTEpMqwms3T+dV3r55gLEm5t2RNUZogfnFWPLu0a2HSGcf8suR4KpF6quucYG970oHAF/5vG2ECm0yPYbFjJ4YV4e9fyBT6oI5mL4bIwGy7x0V7tgDvSjnYAegkPzD7BjEN6pOq2U7nyCqR4EcnsUPWWuSXAdVNg45nbOpNOeKpdUPI6ipYSTeDZIZmxbYr7nsX3owaG/wZiuzcdrYerf1FxmAS5juPQZD0+m0lS/m6VwdeSsk5GjAugi9bs8LNhTBmlGEWXHiaDf9bUGuRnXDTkWDak0DB4ym1UOWt4jQdrto/N4JMddyNyOMmTbtSPMWzONTqHFSRwBIf3zGEIxmF8rZrybU+62jfVZZ1taaeCYCDkqwSh+EacLCk85C5dyO3VRbr6VvJV4Ztzps7cAObQsYiWTsvKNehPfR80kD4tx6uVHyRBjrnRAKddcoTOJgbS3wzmBWecqdu38i21fa5N6pf2eBrM2ZC6VgQecnr4xHu+ss9fHojhO8S3dfeVec3kvgD2CVyZxL+BRAX+WuvQTzZER+lnZBlzQgfGLv530zk6WblyDChH5dQoKXVK/yLLNow0MS4xjmXxMQRrAnmz9D4Cnr3LHJxTYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(38070700005)(122000001)(38100700002)(66446008)(76116006)(64756008)(8676002)(4326008)(66946007)(66556008)(91956017)(66476007)(86362001)(186003)(6512007)(9686003)(6506007)(53546011)(6486002)(41300700001)(478600001)(26005)(71200400001)(316002)(1076003)(6916009)(33716001)(54906003)(2906002)(44832011)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/ZMxWXSkurCVT9oCPjwmWPEPkMrRvNvtGpzUOHTYe9bD2j+NZTpPKGMqSrqR?=
 =?us-ascii?Q?ISIc0PxfT+S4yN/F76bXNtS4cU0NglD18jYZ9RFXWvAiFN9jaizBK7wQqeKp?=
 =?us-ascii?Q?tu21RqzBweU2OY4631qJQ1E7sqsLJJlyMdu7M1Iw8Gx7U1hB8KHTgxVbILK1?=
 =?us-ascii?Q?EHPTDIBKKFiKMPd1OJ6fA38SdlNPWgZvYKHQ3yX3XsHkfFlI4i+/gSQMQp3R?=
 =?us-ascii?Q?+DF7wGp47QlGkTfWI1yCtuM4MohoK3BF3nNkSldeqBR5OH+6gYnBMbDjXg+i?=
 =?us-ascii?Q?0/zHv1EjwaUzodgcYRmjx72ADBPPazq3l68PnPmcAJfBQI+kjEzIwvCbIYp6?=
 =?us-ascii?Q?h3lUXUsmr2y5MkegRy77e55SvkYnze1a/u92x+tJvIperZhRKCrd9R/xdhuV?=
 =?us-ascii?Q?Soa49foy5nqiuTL4gEWsxTCuTdKz3z1P9LjspSavaZtdTys7OESE9z7Rqaq5?=
 =?us-ascii?Q?gym6g/nAVyihGgW7l1mT/lA7snn3BTqu4HCoRlgjTybazyaHTrU8zwjeJdi8?=
 =?us-ascii?Q?WYmKSKDFL11i/EmJSd6Z6pPbxE+Ptmwrj3qj30lkV1duu8EPfUYHu/FzyBbv?=
 =?us-ascii?Q?aGde7QKBxulwZs5fN4Pf+lfwRyj231aJo3xNMScu4r7UjotEUN9bHq+xPNbB?=
 =?us-ascii?Q?e+k7VxCNQkRexz456e1yE0JDkaE7IgzJlJgk01ShpviB+IHoDpWYOxAkIYaV?=
 =?us-ascii?Q?XpjiMape6JgrXC1b6bv39ieAXrQ7E1+NcWrrCxhVxQhIh7EIrpFwlUenvK35?=
 =?us-ascii?Q?ArOINt5ZnJT4rBjsGtHTbpaVp3wZmwIIPWSFwl/ynfa3q8oJ5LWB6BoMchhW?=
 =?us-ascii?Q?HC9+iFwIgd4TtItIU6nVGYv4/0DSv6bAefRqmVZSaxe9S47MNiVEMm9XzXAw?=
 =?us-ascii?Q?uxH6HJPK9BlFdl2q5X18+dLCIRLmjjIiFIbcqWiyozfZDdeDGPHZx5YQSN7U?=
 =?us-ascii?Q?qTvKoIJ2rk3aldg2XKkCfpGBPSpbxrsnQw2zD5/w83isqae6+6bUBS8ogw1Q?=
 =?us-ascii?Q?vbNs/zmnNIKwd/hsYfof0eL6SeN1REVZd1/cgQ1I0PUT29cZIE22e0TAsXH9?=
 =?us-ascii?Q?iVbclU1SI8kF0+BldU7ynetWV7l4qoN7s8iygGz9RQ4NGd7mPuxCzbcO0KO+?=
 =?us-ascii?Q?PQkaOGS8vLmYRQ40eQ88oRzqnEQkMazSMDufESnn0kNRGCFK+vE02c2tjg3F?=
 =?us-ascii?Q?yRvqWNfZynU3NIE4Tsk2FbJD5yn8GuVPB2OEgsnu2Y6E1TCwp/7zyd4tt1ZR?=
 =?us-ascii?Q?C/uayhtvBDGx2oi1H64lZB00nixnD87vFn2JZw4RI5NRt2kAJLr+ZjpR5TBF?=
 =?us-ascii?Q?qY7M+Rlm6+gUrj6Vs/CQEYO0n7DjnJt6HzIdZlJlkGuLs6xD1AUhQGTo5uur?=
 =?us-ascii?Q?pCdtY9XaWqfxI0FUOs8d2JnPrc3p94DdlScM4repYlacJJXItYPx1HnzSvTN?=
 =?us-ascii?Q?X9ZcWTUstO3zPSWTph4vvlxdIMIXKmFI5/FnYvfJ9DD+Vvd/jjWpCY9AwW1O?=
 =?us-ascii?Q?MffMP90LWaGfLk26hm13vZa7pClhtmqAl1Kv569AhxwkaBvvJXqRcc0dykVK?=
 =?us-ascii?Q?MxWJceBh+jYkEO1GFEBtZH46GfVzFYwcn+HPXJFSgBoOW/I1aRjIEtUeRd4f?=
 =?us-ascii?Q?0g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3540B1415FF9347AFFCFE28FB74684F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e737c756-27f4-44b6-3ef8-08da9198d2c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 12:51:18.3207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lbhY+3stKPkrZpFmZJeBj75yulNvyUa2sZAgl+Nb9+AjlQtI+nESUYEGd103hGW+gflQvQOpJHYRi52R4BAVkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8172
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 01:33:09PM -0700, Florian Fainelli wrote:
> On 9/6/2022 1:05 PM, Andrew Lunn wrote:
> > > [ Alternative answer: how about "schnauzer"? I always liked how that =
word sounds. ]
> >=20
> > Unfortunately, it is not gender neutral, which i assume is a
> > requirement?
> >=20
> > Plus the plural is also schnauzer, which would make your current
> > multiple CPU/schnauzer patches confusing, unless you throw the rule
> > book out and use English pluralisation.
>=20
> What a nice digression, I had no idea you two mastered German that well :=
).
> How about "conduit" or "mgmt_port" or some variant in the same lexicon?

Proposing any alternative naming raises the question how far you want to
go with the alternative name. No user of DSA knows the "conduit interface"
or "management port" or whatnot by any other name except "DSA master".
What do we do about the user-visible Documentation/networking/dsa/configura=
tion.rst,
which clearly and consistently uses the 'master' name everywhere?
Do we replace 'master' with something else and act as if it was never
named 'master' in the first place? Do we introduce IFLA_DSA_MGMT_PORT as
UAPI and explain in the documentation "oh yeah, that's how you change
the DSA master"? "Ahh ok, why didn't you just call it IFLA_DSA_MASTER
then?" "Well...."

Also, what about the code in net/dsa/*.c and drivers/net/dsa/, do we
also change that to reflect the new terminology, or do we just have
documentation stating one thing and the code another?

At this stage, I'm much more likely to circumvent all of this, and avoid
triggering anyone by making a writable IFLA_LINK be the mechanism through
which we change the DSA master.=
