Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB375BFCF4
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 13:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiIUL3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 07:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIUL3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 07:29:21 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70072.outbound.protection.outlook.com [40.107.7.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44690857ED;
        Wed, 21 Sep 2022 04:29:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmucJ6X+bX8M1uIkHro5Vgwleyvdsz1kaMgygvNN13n9NUb6B+xRd0a4xKtNIViBbyW+NsjaG3/sV7OvJj4deRbNb1X9I022/HO/s8t6wI6SKmVD9ln4/1fIntCM4wy30KyjNu5ymA0QFgvyxJXtEYM3oKm2Ze/jWwG4brj39Gt5olV1wgH7HziyYz5Ii6nE5OhPKYAxLk8iScKUjqee9Fx9JJSBLJ6jjtnffvHknkvzfEPwiMszz42UiyBP+rzjGSisTJlcyzLiy0Fa9HUQyGtNDnCJr+rY+8s0hrew+Ev0iDAAp4XJvubSq4rBCyzXeB1NrKf+F+gpqSigK5QpBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2oNd/lSuUxC3XzRUX9LCVQvUIeimJVjpjktaYrtShs=;
 b=Ne/AxlEtHTUfiXdIEXplKY4oW9Ubo7q5KgYM53+NTI4vPY8eyYS5rhMUi37IOde61LSzvlDiAPpwCYgx4PG8d/rXCfLkfckSM08taDaZi1SEItlm26wxFme6+nzKe5+OiMLVcMUkR+GHlSdVzFaWohyonHWcMK3CceXK87TrtRjyySrmPkc7GsvxWgfv6+Uem6Cri1syoAM5H9XK+edy692BorApKGcV2yKAewE3U/QQYaQT7dW4GJwjtwY1VYKOm6mNXQ3M5A0rglG2uqS2l5bcnkjdUmiqlpVjZ/6oeRngoIOqjAC0EPnANTldmuDX4/mf/kr2gq74NGyjMCdCFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2oNd/lSuUxC3XzRUX9LCVQvUIeimJVjpjktaYrtShs=;
 b=cc578xTw+WsK9CyBHOWk+KmWDleb7bzr4Is0HfvNVvhQa/z1OB4HBMqVDIFN+d07PI0T/V4XIBIJiPV2rHXO2JpupNs8W/WU0Oa/FgFlibmKFDy6T3uhKMUTZVQvi2MMzNrFtKi9zfd7qm3N+TTMPFErGVTghnA6koylUvgHmis=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7318.eurprd04.prod.outlook.com (2603:10a6:10:1ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 11:29:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 11:29:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
Thread-Topic: [PATCH net-next 08/13] net: dsa: hellcreek: deny tc-taprio
 changes to per-tc max SDU
Thread-Index: AQHYyE9hWKLuwg2RcUaJgx4+STifDq3fOt+AgAAHiYCAAMIyAIAAX/qAgAlj7QCAAAGjAA==
Date:   Wed, 21 Sep 2022 11:29:17 +0000
Message-ID: <20220921112916.umvtccuuygacbqbb@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-9-vladimir.oltean@nxp.com> <87a671bz8e.fsf@kurt>
 <20220914184051.2awuutgr4vm4tfgf@skbuf> <87r10dxiw5.fsf@kurt>
 <20220915115925.zujsneox4jqzod2g@skbuf> <87bkr9m0nn.fsf@kurt>
In-Reply-To: <87bkr9m0nn.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBAPR04MB7318:EE_
x-ms-office365-filtering-correlation-id: d942adf4-1dfc-4f7d-68a8-08da9bc48520
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: njT//U6XGz0eN88yk4YXXmp89TdRK5ZYpYdHj4qxx/WFgvb4jQ5sJ7ItFcg3120b+bu/CSIwCxqr8KXxT05lVH29gKMDBhjfU4bz8kD6BhiwzVYiPjrkxtLmL3f8t/aZejCG20bI+w0UGqZteQj/ykZzEYKBZB0MIx80HdyPxGEe5kyx31+Q9MqfdIbrBEddMAEa4FtsKBGwbbesEOmK3g5KK1jWTCFVveqsHz8yBTauaoo1RC9jmZuFGb8ZDt0lM6kDg3uLgYoJ1dueLg7kBRXitnjgG/AUkpuCGp3u0enaJV4V5YSH96n0kG6KpUx8FfTsN8KVxL2sBNsnlmSWqNDG/q598XwJBy3Zt4G6iGXGpQM4VDNTRxE7eMuyLMFuBo75PUROnN3XezZwOHxAeGZ5BsQXanbM0AgD7jDEyKwZgisQKN4RKUHuw6yemsZ1PIkx/9KznApw+VI8fR59EAheaBGSM2AZ5euEm9HXBuZjmgCTS+mrsZr0fiy4F9mRdllRKP8HrWbO5P9nak5oNF5Ou+2uOTF2UKMYIw3x1F/esVC2X4txHEsg/bMIkd6PkfUIEgPZX8bB4vZ/1EIx0dLd01/GdScHDF3jfPmBDhJViPq6i/R3I5LiE0rg6QsQisT0QxvGvPMZEJAl4xmkXWuSJNnh7B72rZbybEuUVDdPYK31sY5vx+s7mbXW4xv/xATO0dPtYyyA0kTRm3+ybfs/s0gnoIDirrxQicGwzF3FvRQ07zd0SsUQhihFztvEBK3zVT87VrGs2Ooy7Mvh1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199015)(2906002)(9686003)(6512007)(26005)(3716004)(66476007)(66446008)(64756008)(66946007)(86362001)(66556008)(8676002)(5660300002)(4326008)(38070700005)(44832011)(1076003)(186003)(71200400001)(7416002)(76116006)(54906003)(6916009)(91956017)(316002)(8936002)(33716001)(478600001)(122000001)(6486002)(38100700002)(6506007)(41300700001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A8rBCV3Lz1Cly4Z9igY17U+lDeHVE38PQOi8KHwtwNhbTMS9Czc36oNGST3a?=
 =?us-ascii?Q?onBNC3D8ZA5pO0KX229j6bXhIvpzmTtSDau+iTly2tHNu4YXYcVJjRwopnUx?=
 =?us-ascii?Q?oN+c+nT7CXVfrjRTeqDkg1cIG3lEvwM7wKlQ7gsy/wcGGGCV+MkfQxf6OFCY?=
 =?us-ascii?Q?FE/Lk+mnWCnPO/LSmg34xu859gcY89uHcj0rX65lIOplrcbNE7YtICSGMYHw?=
 =?us-ascii?Q?UMymZkuBVgl93rdhqAFYcTvaTxuPvVPecqav48/z+XK5IBCMUqU8sqmUuPVG?=
 =?us-ascii?Q?bfbzo94WPo5wNE6D14Vr+Pj6YTsef2c5wiNkvqXioYAdCKBjGlDSSHxuJ32m?=
 =?us-ascii?Q?xkkJ98EoGwMsjTCHOOwKc7UJYrt73OuLv81OM+bvIuCxj2na6nSHqOSem0gv?=
 =?us-ascii?Q?Z/KLGsRvlOHQHuWUqj0j9UAkZorcUM1xScj0rT//OJOD4N/qFNAg93Eq/Zgu?=
 =?us-ascii?Q?9M3Dbhn2x4hlKblJndeFVhmu1qrnLJFF0H/aZRB24fCeq/zETLW+Zs5B0xH/?=
 =?us-ascii?Q?pzNxFII8CnsuaRLEs52eMnljt01oypAi/oHiHocEcYiU+gPwH2d8xx3BegNN?=
 =?us-ascii?Q?+8EM7lKVCGjcCSMIn2yBRUCcGXwbCuA7RcSfb3kUIIzQxVxW4Fm/iLNr+s/0?=
 =?us-ascii?Q?zgjRIL5884ghA4lprilp0rW6zbZB9uCNLPPyo7Eue8SYv1cIaycitWCL1U9z?=
 =?us-ascii?Q?ANonMujMPfHucYMO6vMqfz2pmZPTeddBbdxNeHXfz51TLhqyb5vokkkaB8zh?=
 =?us-ascii?Q?25RDyU/z/k4CFaDTLHZfVXOK48WQTFgs/By3/HKAUxBQShhWebZJhWJIg9sQ?=
 =?us-ascii?Q?GIMi4zbDAmUm9Ovs5Dd+C53tN3d+EiBJHFXdNBGQ+ucmyj1/z6g12xoOQj2o?=
 =?us-ascii?Q?941mez2nzbRdjgcds+c1fVLAzr/ZevZlXtjt4NzIz0alWPsZe1Uh8lv5KV1/?=
 =?us-ascii?Q?KY5EZHKVBIaixLxDc2cGDkNW5shE8Wajvh0ttP+zgICrtIAxYAy5B5Rq/Djc?=
 =?us-ascii?Q?AxwOefNXrY76OCJJXhE+VtlVA//OMDANDHHz4O0x6x3gtY6Y0N+G5PxyVSnv?=
 =?us-ascii?Q?Cm5pfLr1YRmOyGy2dhpfoL9PNKW/wFgFZAeO5IHLmCIQ54TuX8t5yNf5c0VZ?=
 =?us-ascii?Q?m07X5PXCD+TFrVv2GT9BzQwL5Kzr7SEyylofM7eyUIOWZrBRRROYVKKCXEaq?=
 =?us-ascii?Q?4MwUweJlhL01QH6TwvcIaGYwQgaa9+JtvkVlnukpRDUncsVjrJaDYzljt88F?=
 =?us-ascii?Q?vPsREeWySwhloR+4+pSFonBQZRDHRIOmj61nqh9ERWnNZOT4hz2c4LNEeVTP?=
 =?us-ascii?Q?nddoA0HuUqnXUZCqgtUr05hTOudHaIqdPsroJ84G7u/cFvTDgET3bXZFnxHF?=
 =?us-ascii?Q?pqLpCNuJkdAXrmrGxZ1HVhkdALj2GVkpl3lPeXO/k9MIQxUCzeek2cBuX6hS?=
 =?us-ascii?Q?6u2YvjJdw5KmTtw0Z+oLi/XoihuCmVvX9md/mOkDEz96trLoYMpjki5MmXPi?=
 =?us-ascii?Q?3g2E0Qnn3Yev+8MNauD2aqFImmbPTt1kk+4Yl6mFxMHO7Bp2XuHOsh0h+wF8?=
 =?us-ascii?Q?9vS32R5gpKjpgtHnZUaBVd7xnVcB1WiARcg7GS87YHKy3VU55bdtKKjp/BAu?=
 =?us-ascii?Q?PQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <749FAF230996824683A10C145E0EA6B1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d942adf4-1dfc-4f7d-68a8-08da9bc48520
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 11:29:17.5110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8awi2jRloMmAavuFcdUfY3GgrhxeGrerCZdiHgQqEhkFS4kO0EELJ2SZykL6KKgas9ET6A/rHltAgpoyhu4lLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7318
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 01:23:24PM +0200, Kurt Kanzenbach wrote:
> On Thu Sep 15 2022, Vladimir Oltean wrote:
> > On Thu, Sep 15, 2022 at 08:15:54AM +0200, Kurt Kanzenbach wrote:
> >> > So the maxSDU hardware register tracks exactly the L2 payload size, =
like
> >> > the software variable does, or does it include the Ethernet header s=
ize
> >> > and/or FCS?
> >>=20
> >> This is something I'm not sure about. I'll ask the HW engineer when he=
's
> >> back from vacation.
> >
> > You can also probably figure this out by limiting the max-sdu to a valu=
e
> > like 200 and seeing what frame sizes pass through.
>=20
> So, configured to 128 and 132 bytes (including VLAN Ethernet header) is
> the maximum frame size which passes through.

Frame size means MAC DA + MAC SA + VLAN header + Ethertype + L2 payload,
and without FCS, right?

Because max_sdu 128 only counts the L2 payload, so the maximum frame
size that passes should be 142 octets, or 146 octets with VLAN.

The same is true with the port MTU. When it's 1500, the maximum frame
size is 1514, or 1518 with VLAN.=
