Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94F5630E8
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiGAKDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbiGAKDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:03:19 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60069.outbound.protection.outlook.com [40.107.6.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CCCCE1C;
        Fri,  1 Jul 2022 03:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8iP15PSoODPRm9jHndIotMXBsh2BgHXbIPM0K2+cwi3HERyRyS/Om5T81OrDctAUKDTYFWGLEeA2fb4HFAH8pxG0lNto8TApXljkBHvhCwRc3NGYL/HYX/RnRnduTsOjvum+ae0xKC4ffgHppX9AnUJntrlKYTP4E8fJ84y9T8cES1kX7fnqdXj4BwzMG8n117Biz/IbiJpjG+j0CORYAkLJep5kiFpXooxtoO/KUjjRoFK/g7zzKEVG7xocDaao4Z6meobq5G2J+H9sZC8Nzlo50dYkzcOaABznbSMejNm0jPtbvCF/9zBGTpbSgFP9aGEzrYPOrx1rkmNFBUsQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WoFgMvMH3Mao9CrHmPaZ9vwyZNm+hgUwKu7xWmmWAsQ=;
 b=hSGl2Pzpdrfdcjk6AGSCRpRdrFGcSKk6FPQcMiEcRgVzaVNV3/gcYDvXkolDMyGxRn7OwewPer46Ex+rcXBBsGcqLb84fUaIVlaRdVKrriqXWzE50XMnPm6kNCdGJdgnzg/BmQWtNy1NCCSepCtUCPHcCeMx6gyd3qR04QXkcrSHwYK1wrWcT6wzqfBMgWOowQpVckSVwg8gZsFqpaC+au0BxOoEiGP/S5DIDpO8jPjRDdeQxYIzvMzX+8zJO38HkNduVWDb8TO22PKuJVVyfYvIZlVNpa/XSU/vlhN2ss6JvE9Lu67ZYeZGVSQZZQMhEuR30EgFVZZKfJvIXgfAXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoFgMvMH3Mao9CrHmPaZ9vwyZNm+hgUwKu7xWmmWAsQ=;
 b=pfsiUIp/HTJpHe4cWqbuLb+M874yywuXQ0/MEiSgLaCyFGa16ZMzCFhnwiHIbCJlJO53OCsgLjh3iQWSCZaCK+n5pqHyjfX/z1vzeQpuj7ocYBGYQwhMziz5b5Wf5Ubd7qdargQjnCjUZOVye07dv6H0lw3Zd6AudS/FuKMIKWU=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by VE1PR04MB7327.eurprd04.prod.outlook.com (2603:10a6:800:1ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 10:03:15 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 10:03:15 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
Subject: Re: [PATCH net-next v2 04/35] [RFC] phy: fsl: Add Lynx 10G SerDes
 driver
Thread-Topic: [PATCH net-next v2 04/35] [RFC] phy: fsl: Add Lynx 10G SerDes
 driver
Thread-Index: AQHYizxxgRetEOVzUEGZ10DjfnbHAK1oHZSAgAAliICAAQn4gA==
Date:   Fri, 1 Jul 2022 10:03:14 +0000
Message-ID: <20220701100313.qjiwfqirnw2pgjqi@skbuf>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-5-sean.anderson@seco.com>
 <20220630155657.wa2z45z25s4e74m4@skbuf>
 <0ed86fb5-4d26-4fb2-8867-adf9df1eea2a@seco.com>
In-Reply-To: <0ed86fb5-4d26-4fb2-8867-adf9df1eea2a@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3733722a-df87-4039-9e64-08da5b48ea32
x-ms-traffictypediagnostic: VE1PR04MB7327:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bslZWxRppr4qdBgFIsbXyNdQZf4igXQmdRBOV71DPKcOp4rUJVnWJahrC4/RBK8ABOGx1Ln3+CoFYLlZqcS5PFd/GIN45BQYxzDJW0YVOZe/ua66v4wLJBqmDBrJk6Wk2lHzEbxNbAJg8KA0n/2QhXKxEgUli6GVwFALKvVQtn5jTYS19z3aOllHY/Llbl3fz4F8oq+7p9KC4TNzQZjqJ0IsYN8VFpuR9hx5Y5AbVXT42I/3ytD0t/eUGRW1MLfxoworK07z6sgg0zNKI3rUj6g+kEckpRl+pioraTm6jzcC1khJ0J7PBxiEP/mpFty+b/xGiDDL+lFV1OXOqWCfq47V53LO0NKWMs26KEd1MudV1g6S7ewGWLLlW6Tp5prMbNQ72wk232DILXPwSuIaLOiVqFBMIxfALm9A3DEgoBMRsL6BGGiwO1DgCcK2XK8MIZdFxTTXIvyW8+gSyMGjYNC9CxkUaJDnAiZfwX34IiHvXi6ITnQ/VfWPBasZ5TR212rdULm7mFdm86K1LdIPxLIec33nEqD5R69OaDx0hpNRV5BpauIzQLOQ6zPKl/XUMtRdOV6KUblONxYSWYq5Hd1fnp571/neL9/bZERqInjyekj3JNI+XbIBVBkeVU1ZwqNJHf0MaZWGMMHdTVhMAj5bZ/uXEFFa23W7ESoGacgnAfZpWdZYXj65NDi6A5HfH3XOUa2Tg3cwXT2rNcypOPLQfuxFNAY3vse+L2Y6gh2b0CkwPDfA/lc+akb9lirQQ/j8NLYhbgZyimM4I1c3P9lz40A9ouEYM3TxmAEVG7B0UAyfgwtU1jEeFNL+4GShbCfWbaZndpreWT0R4Xl+J0q1o8kdf87vK9Q4L4eLd7I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(396003)(366004)(376002)(39860400002)(136003)(33716001)(86362001)(6512007)(6486002)(53546011)(6916009)(54906003)(41300700001)(26005)(83380400001)(71200400001)(44832011)(2906002)(316002)(9686003)(6506007)(4326008)(66476007)(66446008)(64756008)(76116006)(91956017)(66946007)(66556008)(186003)(966005)(122000001)(8936002)(5660300002)(1076003)(38070700005)(478600001)(7416002)(8676002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fpRjiC9d42iDeXuVB0LqJIyOLOdKLf2zd2XlbUThdJBbDUBuGMyc6D2t9Lwo?=
 =?us-ascii?Q?xVr0bRMcHoDIhvcrbl5LDLvfi9rZFzy2XR26gZj1KVqvJeWinZMMVV88GUvZ?=
 =?us-ascii?Q?dNtD7WvM1Xulva1+Wvq4zrzYwEs6iPXjVgApdUh/iU5vp3Q5tLSNJgfWG618?=
 =?us-ascii?Q?Jcfvh/lMXt35YYxVK9zVqtdj5O+ZgH9UjgLPLHeZ+ptSf4JtRRkcpNa7wWsX?=
 =?us-ascii?Q?kKGK+I6wBLnFlbkvA0GS5othz1Wxgpm1YtX2n4J6yuSrt3biksWfJamKb1cj?=
 =?us-ascii?Q?t/jH98qgPdxjkbSBbyIIpLDYfWu6j76BEJdSzAjZFGW4bZC2xH0SomSTkJ6A?=
 =?us-ascii?Q?3tzn+YidzS9vUgk7TTcat0PjXeiU7fHFf6r/+sODXfg/tUaHU9K58f5I61Ue?=
 =?us-ascii?Q?KtWqzbSyRuy8fJZCnGkvjru5VbWf1n9gD1uXhaX4fC7vIrrVn5INCCf9UucP?=
 =?us-ascii?Q?T1LQsSSIJgrJconTWbyC9Ik2w8v+akMb8JsFYFw0PmDK+1TLpD009v/tOn/w?=
 =?us-ascii?Q?Dw9ilwaaknL0+6ohfmv7Uf62Auq4n21ovAg1nwLObA+iomZy4Mem0eIZnJvy?=
 =?us-ascii?Q?zVvunHSRXhO7N2Lgx7c4U2m+P2gUqJ3RRkhvsAppA69UughnUmoqjKov4Obc?=
 =?us-ascii?Q?CZW6jAE+woq/gziBsatzCHwF4m4ZuHI2otKYv1BMyE1iEEUe1oc4Zi1cr0eN?=
 =?us-ascii?Q?yLJRzn3oUnP8AGdQpuCeKkOYoirQLhJw65D6LjyDc7tW8iC2H9PoQzGR47SN?=
 =?us-ascii?Q?iZuQHAwzWVG5XKDYPf19k41Upr8ghtofhvgFX3MYwLxV/oczAGmMQhuwKOpA?=
 =?us-ascii?Q?WRhLCoJd1bN4hC5O7kYEhJ6jSuH/SHDYTDK6092D6tIFiVNMwbKouGRK+UuM?=
 =?us-ascii?Q?Rc6wWHUn7ghENDhjbuQf/bxOY1Ru163Iz12XFkg7InFpNY11R57peJpINdOI?=
 =?us-ascii?Q?4ZdeMpl2TSqxdY2pbU9vbKJCIQu1Tz/I0MAVRjRjN/rkeYdlM9DAjkLDC4WY?=
 =?us-ascii?Q?PWDR/SXAzVWAmS4RjVSuwuMiEuDfSOVSp6twLM5VOCQ1siZ0e7oFDyWs6bwp?=
 =?us-ascii?Q?/mNFmim/bQGj6PSaoy8mGsSLl4pJnKsYkRgC8fj2sKxwaql5z36yVplKBgGz?=
 =?us-ascii?Q?rUdng5hpJ371QgZ3fpEQ/0R3J/MbdmtC9WZo/xKeirBKxXSYcWRT0LWKT+EY?=
 =?us-ascii?Q?6mVcMqEqMychF5jHE19gKU/PRo3NMhNJ9SgM9loZ5FlOf/BPm5CyCqT82Ed5?=
 =?us-ascii?Q?+gWwu6PzYBVddx6iLcTC0vHK1FMxcACVRHbtT1mPOkGMwEq3kHZTESniqM1+?=
 =?us-ascii?Q?NUf6ovZQFA8zg/GWCfPKNPcixT8HoKYqWhvxFRPDLBPJ7RP2/EHlBVO8EDjp?=
 =?us-ascii?Q?urNsOI2E5b965hyU2UFaJ6EZPKwN6UEWFi7Uuq4T+LQLj5UqdBcJb51syPeb?=
 =?us-ascii?Q?sJ/KwGEqJ1MarwL4BqQBWwf9Suylr9jsezgM0H/St96+4qEVJxPnWXki0z4/?=
 =?us-ascii?Q?pR6g/g9fOYGrh7wHzz32skNp8wu3qWGQhIKMk6AeHFPz0OWbi+meglNQgVpy?=
 =?us-ascii?Q?9c5WDO6Bup2Ed7OIIy/jAJ8CgnPNRqLZUn9InakkK6YjSM29fXFVn6UT1UJg?=
 =?us-ascii?Q?ZQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A3EC7BA59ACA649B3FFCB5CB0C9EA05@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3733722a-df87-4039-9e64-08da5b48ea32
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 10:03:15.0836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oCBlKG1Fn1lMOhRrezXZHR3DbA9KOCFSSX00RzwVI5Qa5tTbBq6mqh1nupzqul8lXpdFTdEyHiAAgrSYpJwFMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7327
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 02:11:17PM -0400, Sean Anderson wrote:
>=20
>=20
> On 6/30/22 11:56 AM, Ioana Ciornei wrote:
> >=20
> > Hi Sean,
> >=20
> > I am in the process of adding the necessary configuration for this
> > driver to work on a LS1088A based board. At the moment, I can see that
> > the lane's PLL is changed depending on the SFP module plugged, I have a
> > CDR lock but no PCS link.
>=20
> I have a LS1088A board which I can test on.

If it's a LS1088ARDB one, you have to bypass / disable the retimer which
is between the SerDes lane and the SFP cage. I have some i2cset commands
which do this, let me know if you need them.

By the way, I think the LS1046ARDB also has a retimer. What are you
doing with that when you switch to an SFP module (SGMII/1000Base-X)?

> >> +There is an additional set of configuration for SerDes2, which suppor=
ts a
> >> +different set of modes. Both configurations should be added to the ma=
tch
> >> +table::
> >> +
> >> +    { .compatible =3D "fsl,ls1046-serdes-1", .data =3D &ls1046a_conf1=
 },
> >> +    { .compatible =3D "fsl,ls1046-serdes-2", .data =3D &ls1046a_conf2=
 },
> >=20
> > I am not 100% sure that different compatible strings are needed for eac=
h
> > SerDes block. I know that in the 'supported SerDes options' tables only
> > a certain list of combinations are present, different for each block.
> > Even with this, I find it odd to believe that, for example, SerDes bloc=
k
> > 2 from LS1046A was instantiated so that it does not support any Etherne=
t
> > protocols.
>=20
> As it happens, it does support SGMII on lane B, but it mainly supports
> SATA/PCIe.
>=20
> If you happen to have some additional info about the internal structure o=
f
> the SerDes, I'd be very interested. However, as far as I can tell from th=
e
> public documentation the protocols supported are different for each SerDe=
s
> on each SoC.
>=20
> E.g. the LS1043A has a completely different set of supported protocols on=
 its SerDes.

Yes, between the SoCs there are differences and having SoC specific
compatible helps there.

What I am not sure of is if there are different instantiations of the
SerDes in the same SoC. Will let you know when I find out more myself.

> >> +
> >> +#define PROTO_MASK(proto) BIT(LYNX_PROTO_##proto)
> >> +#define UNSUPPORTED_PROTOS (PROTO_MASK(SATA) | PROTO_MASK(PCIE))
> >=20
> > From what I know, -KX and -KR need software level link training.
>=20
> There was no mention of that in the datasheet, but I suspect that's
> a PCS issue.


No, not just the PCS is involved in the backplane (-KR, -KX) link
training.
Depending on the what the link partner requests, the pre- and post-tap
coefficients (the TECR0 register) need to be changed. Those default
values presented in the RM may well work in some situations, but not all
of them. They are usually just used as a starting point for the link
training algorithm which will try to get the link to an optimal point.

Here is an application note which describes in more details what I just
said: https://www.nxp.com/docs/en/application-note/AN12572.pdf

> > Am I understanding correctly that if you encounter a protocol which is
> > not supported (PCIe, SATA) both PLLs will not be capable of changing,
> > right?
>=20
> Correct.
>=20
> > Why aren't you just getting exclusivity on the PLL that is actually use=
d
> > by a lane configured with a protocol which the driver does not support?
>=20
> PCIe will automatically switch between PLLs in order to switch speeds. So
> we can't change either, because the currently-used PLL could change at an=
y
> time. SATA doesn't have this restriction. Its rates have power-of-two
> relationships with each other, so it can just change the divider. However=
,
> I've chosen to get things exclusively in both cases for simplicity.

Oh, ok. I didn't know that PCIe does this automatic switchover between
PLLs. Thanks!

>=20
> >> +			} else {
> >> +				/* Otherwise, clear out the existing config */
> >> +				pccr =3D lynx_proto_mode_prep(mode, pccr,
> >> +							    LYNX_PROTO_NONE);
> >> +				lynx_write(serdes, pccr, PCCRn(mode->pccr));
> >> +			}
> >=20
> > Hmmm, do you need this?
> >=20
> > Wouldn't it be better to just leave the lane untouched (as it was setup
> > by the RCW) just in case the lane is not requested by a consumer driver
> > but actually used in practice. I am referring to the case in which some
> > ethernet nodes have the 'phys' property, some don't.
>=20
> The reason why I do this is to make sure that no other protocols are sele=
cted.
> We only clear out the protocol configuration registers for a protocol tha=
t we've
> configured (e.g when we go from SGMII to XFI we clear out the SGMII regis=
ter).
> But if the RCW e.g. configured QSGMII, we need to disable it because othe=
rwise we
> will accidentally leave it enabled.
>=20
> > If you really need this, maybe you can move it in the phy_init callback=
.
>=20
> That's fine by me.
>=20
> >> +
> >> +			/* Disable the SGMII PCS until we're ready for it */
> >> +			if (mode->protos & LYNX_PROTO_SGMII) {
> >> +				u32 cr1;
> >> +
> >> +				cr1 =3D lynx_read(serdes, SGMIIaCR1(mode->idx));
> >> +				cr1 &=3D ~SGMIIaCR1_SGPCS_EN;
> >> +				lynx_write(serdes, cr1, SGMIIaCR1(mode->idx));
> >> +			}
> >> +		}
> >> +	}
> >> +
> >> +	/* Power off all lanes; used ones will be powered on later */
> >> +	for (i =3D 0; i < conf->lanes; i++)
> >> +		lynx_power_off_lane(serdes, i);
> >=20
> > This means that you are powering-off any lane, PCIe/SATA lanes
> > which are not integrated with this driver at all, right?.
> > I don't think we want to break stuff that used to be working.
>=20
> You're right. This should really check used_lanes first.
>=20

I am not sure if the used_lanes indication will cover the case in which
just some, for example, SGMII lanes have a 'phys' property pointing to
them but not all of them.

Again, powering off the lane can be done in the phy_init.

Ioana=
