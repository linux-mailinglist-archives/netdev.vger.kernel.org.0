Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3111351F969
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiEIKMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbiEIKLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:11:49 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC221B1F7B;
        Mon,  9 May 2022 03:07:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P22eI2LPaoRzBke8J46VdGDkAR32ZExAIWbXsFLQAdk7/U3peejl1LJlGkP0nrXI7DYS0UeE4i3jGydpWYY1JwDTEIZKiR4UWQtiZiEJoMDLkudZ1tsKr3Tr6uhcmiaGVFOuRMYHbf5HTbEDTBCjAQ5hVH7kBZvJu5tSBL9Knxx8iTQSLizQQaD/LaDcxXgfSHVsEp0T2b22mvkn8Qn56J9fT62jsMuxFz6705hUgAg5DqhgW0nTQjwX0kUWK/C8ta4/byo++z53mmACaTILD22ORL7Q795ptcY5Nmm8lM79AP6shnQaRHgknR1o8aHEW3HmYuxxTo65PoUD+WfvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRK2w9bk9YJyvdrgjSXZno8OOt9yRNpcrMZQQNi9p+Y=;
 b=ZxBGvqDcyfANi2ovd33TBj4LaV8mkIF/xI86Py+f8HJ7rwa/NcGP+aIX6kq25XkXBX1f/DGYgktfqhJ9uqt4M5DkRjrzuORN29/r2NODHXj8uSzLWHvK22I0wOnn6KxlS0sg2GuSXmRlnW0yrjvaxdA17crodVrVqStn0cG/onvWjfvsRv3mR/k3kMb5re6VZi3d5F6aImFaJZUExqsLtzaS4+yxr0F9LNUlipJseSe7/6J13XP0TwaAa8ug5C9sc8UNlmxR9ZIsplauyatWfeR/uOboVsN/mRUIjcRq/0CfjXWH1Ong6V9hvEC8mAnED2Nw/3Qs0i3lIHjXgFH2Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRK2w9bk9YJyvdrgjSXZno8OOt9yRNpcrMZQQNi9p+Y=;
 b=C2Uz0MptBVUKzaA8JcWvTvuSIK7ujeQOo1DJa4GuSf9tkrVr2lMKKJd93ikf2gvfh7xZWyvSPmWyIMFHyifdTUJbVlsrBpOLU4H6bGL4aJ8BcQXLviVFQ87r2csgl5y2AUs5Yj8h455d6i8W2Bp/cnQTvnoiz0QrVNkZDWLmT54=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8066.eurprd04.prod.outlook.com (2603:10a6:20b:3eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 10:05:18 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 10:05:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 01/16] pinctrl: ocelot: allow pinctrl-ocelot to
 be loaded as a module
Thread-Topic: [RFC v8 net-next 01/16] pinctrl: ocelot: allow pinctrl-ocelot to
 be loaded as a module
Thread-Index: AQHYYwzpCasAgf1f5EeAbje1498LNK0WUneA
Date:   Mon, 9 May 2022 10:05:18 +0000
Message-ID: <20220509100517.g36qdu253dywjiwu@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-2-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf849019-6798-418b-c637-08da31a36bc3
x-ms-traffictypediagnostic: AM9PR04MB8066:EE_
x-microsoft-antispam-prvs: <AM9PR04MB80666621CF3638BB04032B02E0C69@AM9PR04MB8066.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zHE3vzoNzYxYqNgJB/Czf+P1UAKKp4NKJB4C/02w32uF9V4DCc6Bj4uOzbzea/0b7irUMrf5MzGhCcctAiYUJsYPbj32eYUlsYYhvoYX4yD+c7CQr5Iv9Sj8CkrJ8mJeX6gVS7o56XTIS6Z0p5sp37Om4pvJSphjr/8C64LqTc39/UCLJA80eCAtVRZ6xMjEImZMweo0ruOMzxl5nr1+/2RXL7jW4gHpzDNJDWgZoHPMIs3U+Xih57PAHcwlEub2NGrFPFETavMscahyBfK/hKPN3dqBPsuA6hZkQwcokzhV61JS+gJfRro1vwstmAe9QCmI0y4BacxnWahOqIU2aEvAuFaIL9CMQBiSGuSUMA2ZouEK/EpHvPAvKBcmIpPmqiwCiC/35SuRM1mRSLGi25mGJy2R7Tz5N523f+pHu7UJ3alqhL439v7AxFjPFYrbftkRosNMu2S0yVpfTCIFi3TRHtCwPb8POfeGrOHXmqptMmWidv+c6PcM9lGP0AsTVr5d0KcP3l1Bth5YUP9PKP5Wej1dQr0NLiUzac4Z1B6pIyLJvKeBCn+d6E+ddr1zlCNjD8X9TC1N4vCTz2AQN9OPqWMqCbwh1NHiKe3lipTXnGwXN5MZfNAUyVTZRzn3hoaT2hN4/3DQntdcO2sWz3zdaNo38YOJX4ig0VYN0DVJW0O9CiKz2EJ5rDnDGq5h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(4326008)(8676002)(66446008)(8936002)(6916009)(54906003)(66946007)(66476007)(64756008)(66556008)(76116006)(1076003)(91956017)(316002)(86362001)(122000001)(6512007)(9686003)(6506007)(26005)(71200400001)(508600001)(38070700005)(2906002)(6486002)(33716001)(5660300002)(44832011)(186003)(7416002)(4744005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hQ62ojZuHBHmatBnnhWf2AgLOxymGbBuhZiPWAGYMHX6dF2cJyp0TA+Ds+iZ?=
 =?us-ascii?Q?M0yGzRzhcGTzF7pg11JEqb7fkID3PCv+ags5FtrJVy2azhDDDXvh2ipu9cl1?=
 =?us-ascii?Q?opW1A8gbOViSKcHHbZ9evRiVtjhsH8BTeD89+Lc9M6RQVN/SBtB591+WkBvg?=
 =?us-ascii?Q?cFhO7E4wFgzfJ+BdSONANPWlIEjQlZp/8AqHbiDL7HDSB95xqiLLLxNJBqCu?=
 =?us-ascii?Q?gD3iF1xTQrm9thqtw68K7zvLFj+wGyxK3GK8ekNSAddp17JzjRWnYP2+xnqV?=
 =?us-ascii?Q?0Z2Ucgtwzdu1kSKxqEgM5OU+pqkP9Xd6Q8kV96SV3JusswO1HghYcobcejPp?=
 =?us-ascii?Q?92U7D0p7JHLIqTqhJB61QVQBJxp3kyovkUX2kj906hKBGp7sK+88XlJMd+im?=
 =?us-ascii?Q?QCTbYxR1Tjhie8kJjyMSRXfO0kdq+wn0FE/8Kx+H4fzmmk2rqvsRykPPQ6rS?=
 =?us-ascii?Q?uhzSce9iSkFAaC/OhuzCb8JpOkTlzBicdothk5awvN1rYwpE8o0YfbwBV9j6?=
 =?us-ascii?Q?VU0Y6rHS1/sa7ICMrWGz6euUkcz1OV4mzbKGbXLMzU716Cs+HP0N8pCpnFtF?=
 =?us-ascii?Q?3s4kUWuaQzeY/3yXpLzYxDI52zo5VWTGcReGCUk57axpC3R47R+eHztbvW6K?=
 =?us-ascii?Q?PJionHa2Agt2I9qLhevb37OV7et9Q0JbQx/6+g2EWq721v0c+fTr7atTnhD2?=
 =?us-ascii?Q?YETrgpOe+ooTf7hJqDO4Q+H1UtlsWPeddIj595nwOqNRlLFNvIYZut6XfTCQ?=
 =?us-ascii?Q?WpLjr8e2jCrClwdouX3gxh/+n7R685FieXhcOsHe+8PtVDa+aJPH5/jZ90h1?=
 =?us-ascii?Q?0J7+1UP68UIYzsnwOFe49BePbaHX8WKgWQrCEq3ID4fmGOlv7xUHWFaC1pek?=
 =?us-ascii?Q?ZdeaojkIwuYqFdp+KwnFu/epQN/e9ShRhJ2hyUqN4CBfD7Uwx+lG4RHtrDGo?=
 =?us-ascii?Q?2y1En/jV18ZpkLDyd0q2LdjI3yhWO42DseM5zsR64c1WHQavbbeXqmKXT9Rc?=
 =?us-ascii?Q?6g3uvlNSselGK+DL3q4k0mIwuRhkkF2A6RIbRY3kcMmDzGBL5Oh64MnE9oG8?=
 =?us-ascii?Q?WUJSLj7qbuKJTfZ69xVVtQaxtqoAaU78oPCJ6b4qQFGLe1CIb74Oc8FVe/vR?=
 =?us-ascii?Q?pKx7ut6+2wCdmrJEJ7le4TBGd8sa2a9+5dywC69PDAqEeP+rI1Ngiec3Oy5f?=
 =?us-ascii?Q?Zy4R4JHGLoXUHMIZjPB2stmX3iHPrM7IBzJY5UdVeZN+3vLkbhTIJzD3l2kY?=
 =?us-ascii?Q?1OAHjB60rCqAbiC+3UodQh23pAqKfyu0rx8ozoRIw++fs3Uv0pd0LDLYnrGe?=
 =?us-ascii?Q?0Js6hxEO6eWmQvS99/0Cd8ZJv3UIrLow6l/auH/Sk9oJCMqxFblc/bHimGWk?=
 =?us-ascii?Q?q3Q1zJZTKFD5N18y4/x3MJSNwxJkfFiXQPPIuRUOdIF1d/O14XXcQcoTcc1U?=
 =?us-ascii?Q?lt1XeBYvwpOzyLw7Bu9Pd+YyDLzsrzHDsd9SIJ4RfEmXo1t/KiXmyRCK+zzt?=
 =?us-ascii?Q?y8wPa5f2xNG3PU+FEUahKLmVhogokXX2RT/Dlsml1OCq1lhqrbjr9bx0cXiy?=
 =?us-ascii?Q?x1e9Eg6WV7qDY7Le9qupHhEGtCwLPb1PJx5yr20Rrqv2+VhRXICAnh6EL+39?=
 =?us-ascii?Q?n/Fsjgw9UGUXS+bo530dPUzRaMN4sM4Fz61Fy0RRo+xmOdlrejv0wEElpg3G?=
 =?us-ascii?Q?C/m4LqP5umldVlCu6ymBTx7xae8qeOZE7uazSsuc/IQLsf7DK6LtUJc978Mc?=
 =?us-ascii?Q?q37Qk9cqckFDxBvZJ1pJtTrgVgmt1Jc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E275FD73CD2ECD4F8DDCA0533055EDA3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf849019-6798-418b-c637-08da31a36bc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 10:05:18.3300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Euo/A24MQtyujlgrKVAFZaokhNSYteuXxS9nF1MJuNtQh7WJgPTuL41R2XtQC5KprLbisJkeb1twT7r8t8V5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8066
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 11:52:58AM -0700, Colin Foster wrote:
> Work is being done to allow external control of Ocelot chips. When pinctr=
l
> drivers are used internally, it wouldn't make much sense to allow them to
> be loaded as modules. In the case where the Ocelot chip is controlled
> externally, this scenario becomes practical.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
