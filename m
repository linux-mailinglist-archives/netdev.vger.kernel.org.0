Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC7861F1D0
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiKGL1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiKGL1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:27:42 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2083.outbound.protection.outlook.com [40.107.22.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06DB186CF;
        Mon,  7 Nov 2022 03:27:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kmx73ek/n/X4gNLuAOCJE8N2KCXA1t3jPYfPYGbhYd0iLu66X30MeKbs7xFfD3iAsgUINVAeog22SqUFUCik/9zVTYDnrXtJuEYoU1WR5a42IA7yKTfKK8KDQJnMkhrM5ggG5vzy4xAqgEnasJPhOZxup7QAFU+f4UQfIJvojp2T2Ah/I359STAmddv1mt0Em5sk2UAEGhnn+ftzxoJjebYA/yLWpt3KD1wd9JFgZ5YZV434TSldG8bEKFP343NpRRfo2jfcfFTblgPu+YxP1rjGCtgh8/bDrmAff8WaS6PO6YITWxBoceJbtUGEltqbzk/4AUSFyIAS3CCHIRwF4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvT3ukkDNAaUwpTtzUVC8HlFP+3P78SgZPtxxeWqn+o=;
 b=j8g+Qm47IwGd61rYBTrCKixtY3pygpYHYDQn4lzwCsyMqG8eALMRy488Li1p5x+e9zx2QUAJF7SF96vF6IgOcgwvgCSc4mmkTWRFUJHyY5KWrNITOo25U8C7ftHYknEZo5+vOYzj5Yk9Wg2EsWjveY4/LEphuytMBhz3HyLWmC4s0XuESkUMJb0uHhx0NJdgAN9L8Aqcx5z3NfZSOKSJXywx/7Ua+ni7FV1SSs7L1R4W4KnEbnDBb+6UbTRy+n3lCU7z7PJwQtIoRdGud9a5n+pUYAmYeQicXrh+Aw/aaKjHU9m8mhFfxn9+6yW9rnEX/XZdZiL/o7ngAkSmFGG5FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvT3ukkDNAaUwpTtzUVC8HlFP+3P78SgZPtxxeWqn+o=;
 b=Hc22qd2LPpHs99AzZDkVNuSpHSS/pM6NJ5izzsIJrW3QCiOwg4BCAvx8LVBGj2zKyeJRwc/S62aCaY/uCuVmjd+XPO4SB9cWbFoPw2TCBQ/6AzjvR4UzEByx0OJCJV31w41Ou6HhJQsCkXY/H/f11LrNp1wzL7t1lQCh/4Dm660=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8270.eurprd04.prod.outlook.com (2603:10a6:102:1c7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Mon, 7 Nov
 2022 11:27:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d%7]) with mapi id 15.20.5791.024; Mon, 7 Nov 2022
 11:27:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHY8HTAfetHoGxM5E6HcRPQNrr8s64vpgIAgAOw8wA=
Date:   Mon, 7 Nov 2022 11:27:37 +0000
Message-ID: <20221107112736.mbdfflh6z37sijwg@skbuf>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
 <20221104174151.439008-4-maxime.chevallier@bootlin.com>
 <20221104200530.3bbe18c6@kernel.org>
In-Reply-To: <20221104200530.3bbe18c6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8270:EE_
x-ms-office365-filtering-correlation-id: d7d7759f-cf23-4e64-ae03-08dac0b312ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mNrjuIj32Vc9J4igFQJThrgR+Id6lcHUo0FqFfZ5cuEoa1GQG/pTfDUhRv0lsr4tMcwuY3nx0xxbit7SBjreJ/m7gmWfVgM5EOExSlMzN5PteLn/wIasCHy5/FE99T0sl4ccRRg5zIqHa5hXT5Wa7jiO7rG5hkmE0MpLUQVw/HF510E5BtpAsVgF2cCwcHrGE1bqMcSyEMHgK9uZyjwH8HSBFF/t8NUvjmkKLVrGMu/aUw75C0ovOf04ZRnS+r6HGXZ6imEe3pF0XZHSS+j3iw6ua9w7lZib5uyp7i4ebO7rp4zVPwD8Lk4ueqHkNRUG18tmkDRx0mUJNMP5melCwzunuPdIdv9Em9ENmNCFEprrhcIpSyY6maw6ZLbmqZUHnrtLlJcRHpW4/pOPa+2r3lHlFc0i7T6FbzKclAeWMWq+U+V+9eZtybYK/NvBf+mA7l7BTTmgFz2AfHozm4nrtX3/qMPPbnYRcpAwMNz7eqy0m66U3ogURuVjYNYU8+wotJVvVFlKThgq4h3Zjo41uDcBTZiGbd+JoyyH0QN9LPFrr8hj1+uI2a4hRYfJhSbAjcKjuJc9m+gAO0F8JVaIHSdlhnkFqB6rBnxl//RqKVsVNZM+xFz5w0SHDHYiEGUoiuEYDeGEtCAOhVHaKNf8Nj1CvlHx3fWwi3XtRuCzymlhk5p1sFWKSWNxxm7KJTG2WF2r36P8bLPEqap9NariSzyAg5JvIa+nAjexy2Oh3gYa1KkHb8XfAadvsH07a7ilWSPq9F5b/52tHO+4DI9ozRpzDtflzN8jHY+cVXlaKJc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199015)(86362001)(38070700005)(7416002)(5660300002)(44832011)(2906002)(6506007)(26005)(9686003)(1076003)(186003)(38100700002)(83380400001)(122000001)(6512007)(66899015)(66946007)(76116006)(54906003)(33716001)(4326008)(66446008)(66556008)(91956017)(64756008)(66476007)(6916009)(8676002)(8936002)(316002)(71200400001)(6486002)(478600001)(41300700001)(10944003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Zw8uqw0Y2RI3T5fYA7KYyF4BtS8ypcG/au66pPGGi3qb9dwjlpVC3slTJuIV?=
 =?us-ascii?Q?oUu4C9LNYetvy/PF8+mkn1mXEs7P1sQ1A+eRkgojLXpG96FQsn+d/NKd/Vvl?=
 =?us-ascii?Q?ulYilGLSmThzRuIM/gLQgn0vu5spVpbpQVVjppcM8wosJe7tb/K5YaHR6JdY?=
 =?us-ascii?Q?CEgLYP/bxvaaj7CSl5gsh/3JBZ5O0lgjGGLyDyUyjKe+VCfKtW2jfFpeEywI?=
 =?us-ascii?Q?FT2te7+HCOpMqB133SIHcQ/jEChuJVezQG9xvsPywxQOlyBIIW51mpkL0NOe?=
 =?us-ascii?Q?6MsWEyxFWDdpaq7SQgOtBjmtHdElrArlWipRVfyd+FgID19nwuKCRPO9SySq?=
 =?us-ascii?Q?hcBPSYRqUZ6ye+IwF/eu0qq8POniFKiYPeY/JSPl0JoTiVa3AOslwpLXpJ69?=
 =?us-ascii?Q?ghkX64E1XbhndyTfYYSmfsvPKJF/wFqGW/NmUvMkn9LpUdJL3/PJfr2SvzXB?=
 =?us-ascii?Q?EmxasBypqTaFFePzwTjpKGP65kjOp6mReFc0uiYpxRA6uVHlE18d2ivM+WiF?=
 =?us-ascii?Q?2uUMguvkCNJYk0zsGZuJB6Bb8D/W4c4oBu28y4NBtywUZ5vUbtO3ey8eyXjS?=
 =?us-ascii?Q?2RXJdWURR8ZG1YFHpkJo9rJmzrCZ3XAHsxg8nB8tYK6nBanPjR4uv5gHBhO1?=
 =?us-ascii?Q?W8oZmQRT2uM6IH9uIAssC0rn9RAyYdsyeCic10J7AfGuJKcUnkAegTK/6SE+?=
 =?us-ascii?Q?ailApkgktcHSZt84U+vNy9M/1PkvxGk/5aZY0Wv2nJltJnRu+/1tvus52Dk1?=
 =?us-ascii?Q?ZaihP9PbqN51z6NsD5z9UJrqBEjfm/Ms4PNzBsno7/U0oYSuyeYo2YMGtV7G?=
 =?us-ascii?Q?wpuwQ0HU+Gb88N0aZEm046JU+lkXRv7NEomaVKmMzryXqrdKxg9C2FPcnUW5?=
 =?us-ascii?Q?5ZID2+dJMOAceWL3Gdop8XMbgM374foFiCmA4pG40Fwfbefl3V7cigdzZxRv?=
 =?us-ascii?Q?Kkyw6O75y+O+ueTIJ36jY/MoPps3CT7ydRnEAli/TATya5MiE+NZhX4rVCYK?=
 =?us-ascii?Q?Z8g4YUXWbTKu5D7IM8pCzzbgaUletoeVDwNjkoVameUn/LuvoQ+Q7IMAuYFH?=
 =?us-ascii?Q?qi2fzsIRBtv+m2EyM+UkoIP8tPbsi92BQhkHMKeiRAxLqGoph67C+oFAWQk3?=
 =?us-ascii?Q?DpvtnYiQKWNBHI0l35bsnbLvNt63PLoH/Oql2jIdLkEUvJaH5tzoXl94uCN1?=
 =?us-ascii?Q?DqjcbPSQ32UBn/AthaxmMXX97hfSknbd/TEAnGVifxetnkEh2sk7qJotzzVp?=
 =?us-ascii?Q?bEPSrYSlZA2obL2jp+pRgRschJ1P9kuQUILwqx8lVK4KEGqlE/AY7caaA/LY?=
 =?us-ascii?Q?bTmgLayCDn3H55aRRvt32yA8kMaZz9K1Qa0GFLYHi2cxETS8PBK2i8q3ZMPD?=
 =?us-ascii?Q?5SzTn9n/eMcQalehWeMV+WSrpLxlNmKWmUoqT0szGuIs+TgtuFiwXzt0zQHh?=
 =?us-ascii?Q?9hcNkLIYZ9kSmUubfXHl4govccZ0YKeZgmJ8Gj7UkoVWlMxiayEt+HBbNXOA?=
 =?us-ascii?Q?EX4TYph6gnccIll2q6vumKhTZ7yD0wX9WXeu/liXkQUrKLK6X517ffG0HhM1?=
 =?us-ascii?Q?18vYFvMWmEx5aHObrQl+UmLBkBRYb4xsAb44c+MuyRqYrhJ3EjYUS5PNvHua?=
 =?us-ascii?Q?Fg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DF655BDE7533F4438087FD5416E3243A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d7759f-cf23-4e64-ae03-08dac0b312ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 11:27:37.2093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RIMC/2yovuY6iIB187GPsYmZJr+9Tw8cbnJ4q+osUqTJruC23a3DZePbKhSrp+dqCWi9G3dUdnbhY2TiQe5DIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Nov 04, 2022 at 08:05:30PM -0700, Jakub Kicinski wrote:
> On Fri,  4 Nov 2022 18:41:49 +0100 Maxime Chevallier wrote:
> > Add a new tagging protocol based on SKB extensions to convey the
> > information about the destination port to the MAC driver
>
> This is what METADATA_HW_PORT_MUX is for, you shouldn't have
> to allocate a piece of memory for every single packet.

Since this is the model that skb extensions propose and not something
that Maxime invented for this series, I presume that's not such a big
deal? What's more, couldn't this specific limitation of skb extensions
be addressed in a punctual way, via one-time calls to __skb_ext_alloc()
and fast path calls to __skb_ext_set()?

I'm unfamiliar to the concept of destination cache entries and even more
so to the concept of struct dst_entry * carrying metadata. I suppose the
latter were introduced for lack of space in struct sk_buff, to carry
metadata between layers that aren't L3/L4 (where normal dst_entry structs
are used)? What makes metadata dst's preferable to skb extensions?
The latter are more general; AFAIK they can be used between any layer
and any other layer, like for example between RX and TX in the
forwarding path. Side note, I am not exactly clear what are the lifetime
guarantees of a metadata dst entry, and if DSA's use would be 100% safe
(DSA is kind of L3, since it has an ETH_P_XDSA packet_type handler, not
an rx_handler).

More importantly, what happens if a DSA switch is used together with a
SRIOV-capable DSA master which already uses METADATA_HW_PORT_MUX for
PF-VF communication? (if I understood the commit message of 3fcece12bc1b
("net: store port/representator id in metadata_dst") correctly)=
