Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E945F322E
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJCOvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJCOvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:51:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B9E248F2
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:51:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqcPCyJPf1TiFYb8LxYD6AB+WDyAwonM8x+BmSMw9/wAiK1CEw8U9+NFAob3FEIsQo38bVwwKutl1R31/GTQHQCEkVNf3yJ6yxsox6nVPaPv6crKPtXPDXXMcFAafbP0JxxUeNH6AeWiMOlAaKFKiuRA3MhSIrxtco4TGRHyTls/UZf8JqkkC5p6mRihaTNJYwfrg1948kyb/th9X52BUnOAEX/WGEurlvUO0aSc1eLwSDEWruUr25OQ/QMbZcEei+pyP0npDJoG3XnjX+fS3XR1pa71AewfHfhr5dI5zdbvE5rsKHee9SvD4cGalxd6AedZQIDlriJRVgCUWEvdvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHs3pUTRugt6ZCUBnRT0GvHvU+mmBWT+E6QqIvGkYRE=;
 b=eGPjt2cotgPAvJQJ5zGxEZ78dUr3fBXJ6hjajlfHZnWhcSHFtlk53xkotnkmANlZXvFvJQuiUNqS06AVEowzWoGzFpsj9gyFRxNHUPIOtt49kLVqpX2F/jfenF7XTWkOqUi6lcJQbsIWFRTlJcEQWE5jY/lda1aEYkZkF/6ewFsCqR0WOfcWesuQYmgIf+V6+V4LgZeCc/s5esBvXWeO/1v78O3r4zkA8FOfFt5ZnuBlEiJQ27aVDF4N5mx7ygthkDOx4P0jjHqZbPYkipymqCn1Lj/H+ZbUOYC7ivCqZeeIlTtDSxStuzUYIx5VRf++UDM7mCmYXUeMwq69EUf+FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHs3pUTRugt6ZCUBnRT0GvHvU+mmBWT+E6QqIvGkYRE=;
 b=hsnRkErlCcDhX08Sfo65s0/6MlhUDCtzN7p035GuPEjgXbnvJyolY4A4SH5WIe+DmGEzJm0EfY6jbJOZ2O/XauVFHWZKlwQpieNyTefVcego+7wO3Prn4OB8m+p+qB6IwIBd8B9iYonHVWua/OUxHd1HCZl/c0aEMObNoxH0gc4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7615.eurprd04.prod.outlook.com (2603:10a6:102:e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 14:51:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 14:51:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Thread-Topic: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Thread-Index: AQHYsb+mq+RKMZoa5EST9UiAwGJ6ra2ycPWAgACKigCAAHRjAIBGiI6AgAMO/YCAAARBAA==
Date:   Mon, 3 Oct 2022 14:51:17 +0000
Message-ID: <20221003145116.w6q2ksvvatellp47@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816203417.45f95215@kernel.org> <20220817115008.t56j2vkd6ludcuu6@skbuf>
 <20220817114642.4de48b52@kernel.org> <20221001155337.ycodmomj7wz4s5rx@skbuf>
 <20221003073603.1d98c206@kernel.org>
In-Reply-To: <20221003073603.1d98c206@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PA4PR04MB7615:EE_
x-ms-office365-filtering-correlation-id: dd404446-daf2-4f38-05d1-08daa54eba0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PKCc/L6ps0K7MCfyKGrUPuftLcfnJ2xnUvTAB3iGQkMt5rnLPhPkfqJWD2ufu0dAHChlIH4rxYKUfD43cfMqUIsx2m/7AOJeKOnzYw3KYb30WhkVTJmtMTynfgkwPhyi4pxd0jqHj4AEcAvpS9lD4cpGWGpYQiGvHjrMseMFtm/iyZ4XpZbAR7YgInyxGKA/qycxerNwHqfV7y6DAm77pefeagc6wQccDndalyRhtuWf0+NM9aUEIpIXKozd0dVJYGyQHuKGeKxLoI6zClF3D2lNRThvju2AXiXII2ilHYtyBdw55GR5dH8C/lxpXaXcDgLP6fD4xVqS1FworET5OKTuytvslEhVt0WHoxWr6OsCtj8JZYstC80ulaS5evB8X5uWahyUMCgDxbVLU7ik2A4y31gma6fRyWvgWGPn2yloVM3+mCT2U5l1XRuQusC5hrWeFTsk582D0zSaZorasN/f72wsVxCx3QPApiBljgpkzbe9j1N2zw+FYqLshLhw0aDEyrqJ9ZvbQlp/vUApFtbGCoUDLxKbFo0mgsszs9n1TkKxy2HD/Mb9mHGFgrTBESv65USghxhkuP5tW8yUQaDIPlwYEWonvMifMK+0sKfCIsYX8o3bwiuwbddeS+4kSznp7hhCkdPoSnuoxgq9HunaFaML0pOFRX2jV0YCNm5J863IvcgGgOdVL2s38clYbJcnDJiJbAKM48pW1Y/HNf2M7DbgwIZv8qstnVqeu2qrPZYlwOCqxsDXKL3vGIZtU9HZvOUrDWe3cwd0Zgspeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199015)(71200400001)(44832011)(6486002)(66556008)(8676002)(64756008)(478600001)(66946007)(66476007)(76116006)(66446008)(6916009)(41300700001)(8936002)(54906003)(4326008)(86362001)(33716001)(5660300002)(38100700002)(122000001)(6506007)(1076003)(186003)(6512007)(9686003)(2906002)(38070700005)(26005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+rtHv+WsGmHbGSQiPhHKg750AHfXzAAvWPTZ/HWbeDyyOh0i1yc3ubN0mHXH?=
 =?us-ascii?Q?Zhm8i8+HQkXvF4kHfFRo2MXdJJuLGF0t0O0gTqXBmJ6Q4dVLSoHw38CpNd+d?=
 =?us-ascii?Q?QvZV1M4z1ufeap8JPGvOej0+Y4Dg6jaJo1gdbuFC64lugkp8MffX3HJqceBK?=
 =?us-ascii?Q?bJISj8naxInTff0X6YqLnGVGCTdeqonM1m1voL5/Z5nmVmi4GRCOxg1dPTHP?=
 =?us-ascii?Q?R8Kgb3oom+onpQm5yh1fJZ2ZNG0LLnYqo29hZeT4N2xQYvecYJ7GNxUjmFWp?=
 =?us-ascii?Q?rLU86xWgR2aC+qj43Lcu5HDTR/Le+w+yl7TQAnmKsV09RbfmEurECHpzeg/H?=
 =?us-ascii?Q?25DBX9KWsgEY+uVDWoXBE3ZLJPLeZs3EES393B05AMckgiEsGsktt5OVxMRB?=
 =?us-ascii?Q?j1Y+wZcko88lFo6Ca9hyIploFUsv+3bjhTGBv0aNr8Tb6/o1WZ9DJmDNZ3Eu?=
 =?us-ascii?Q?xewiYSJ/hohMW0cRr4zk0eG+MXCz4QDutW/SWd/Z1jZY7bwEZhj6h5q/MH9M?=
 =?us-ascii?Q?8irskKWwBjjbLpzZDhXlDRQmslAYHlJfzZaGg0IypXzLFe7ZVLuo0mghHqYq?=
 =?us-ascii?Q?ux4DGIEqXJLSEkLqsSVT1FJeqXE0rVou7zQDW8mv+En6weyo/qJokULsS+Qn?=
 =?us-ascii?Q?NwLOgLkvYYCO8EaU2JRyGhudoObAXSQPJL1rXhTrm2EpLlYbspqDxgQF5TJR?=
 =?us-ascii?Q?vyyhEsffRALDUda/8zJOGVR17yj/ABkx0KWtPr1p7u5H622EiBGkGw/iTJkU?=
 =?us-ascii?Q?wgHRC9kLzGh4Tqp9XxgK5NAhHBPThP1OoOYo679JcRdNI+5vr05TeuUvMNHT?=
 =?us-ascii?Q?5nFagtPY8AlZrFa6U8dTymMxC9E5Stsm1gE9N2XZviCD04bYALi98515oc3/?=
 =?us-ascii?Q?MifLYchxPIEO8ZhuzY1JOe/3Fjvj7omWdUmGigjfL3npf2S/kPkQXG+9F9jT?=
 =?us-ascii?Q?qE4Xfhy0TCLqYWxGo4uQP37Nvwvy8Clq9TTbNCYWMILf7tj+8EdaZPavunOW?=
 =?us-ascii?Q?bxHBk4KGl4duOUolVjIM76oTpHpZjnU8+X8iLLZHqzVYGjdWpVRgIr67oyUQ?=
 =?us-ascii?Q?msKHhpv2BDVsW6RdNsfhELoMQRhYdepAPhJKQxb1jXBipiGQ0dpC1T7KovOk?=
 =?us-ascii?Q?BaQQoU4tn6/jqW4Q6NYVAo6Hm/qscbE0cYNvG9GVCCjOi/ySj4wNmwMZGA5t?=
 =?us-ascii?Q?a8qoj0QbuqUe2tZ2259qVCHKImS0TneGSMVyoHCNWUmgaPdA8iS+OP8zXSWX?=
 =?us-ascii?Q?I4q9xLKPnUpb8XaldToL8v3vSdzRtM3VkFM/pS6PMneekMtecIWh3a8ImRN9?=
 =?us-ascii?Q?DMT4Rpsa1pcw/dAB+WrPi/x648bcC3eTNVNLtrlIizABqadESLldDDM530OI?=
 =?us-ascii?Q?EKlwVfkSTn+I0WApvsgqXsNRrrpdmFfAwx/uGhiBboDo0AWYndpqpl+0iGL0?=
 =?us-ascii?Q?SkucnraSSrCgb1atJVBWqozcT6AyEMJloQFJCovdygyZPYckzPAoHM9SBp8p?=
 =?us-ascii?Q?GNAlLlEzF0vLQzehsBC0aAbL5Alb8+wif5CigW54vUq9jNXKV+k5lOQNaG2/?=
 =?us-ascii?Q?xIg8G13SO/WFCsBz9xE2lmZaLueN2ksTmELU8CDq4tgIFbZrX5Vgv0XjVu00?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <80A722E7A5242F4DB72DDB48ECF27BD1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd404446-daf2-4f38-05d1-08daa54eba0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 14:51:17.3572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q5zk6t0fX3jbwTytTKhUeI+NBivrbZASStHTU7VmdZjce3piKqlHPuv3T16d3glkKs0Qwk9c+L82oBpc55fmDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7615
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 07:36:03AM -0700, Jakub Kicinski wrote:
> On Sat, 1 Oct 2022 15:53:38 +0000 Vladimir Oltean wrote:
> > > Add a attribute to ETHTOOL_MSG_STATS_GET, let's call it
> > > ETHTOOL_A_STATS_EXPRESS, a flag. =20
> >=20
> > I'll add this to the UAPI and to internal data structures, ok?
> >=20
> > enum ethtool_stats_src {
> > 	ETHTOOL_STATS_SRC_AGGREGATE =3D 0,
> > 	ETHTOOL_STATS_SRC_EMAC,
> > 	ETHTOOL_STATS_SRC_PMAC,
> > };
>=20
> Yup!

Ok. I've also added enum ethtool_stats_src as the first member of struct
ethtool_eth_mac_stats, ethtool_eth_phy_stats, ethtool_eth_ctrl_stats,
ethtool_pause_stats, ethtool_rmon_stats. So I am not adding an extra
argument (another "structure for future extensibility" as you wrote
below). Hope that's ok.

> > > Plumb thru to all the stats callback an extra argument=20
> > > (a structure for future extensibility) with a bool pMAC;
> > >=20
> > > Add a capability field to ethtool_ops to announce that
> > > driver will pay attention to the bool pMAC / has support. =20
> >=20
> > You mean capability field as in ethtool_ops::supported_coalesce_params,
> > right? (we discussed about this separately).
> > This won't fit the enetc driver very well. Some enetc ports on the NXP
> > LS1028A support the MM layer (port 0, port 2) and some don't (port 1,
> > port 3). Yet they share the same PF driver. So populating mm_supported =
=3D
> > true in the const struct enetc_pf_ethtool_ops isn't going to cover both=
.
> > I can, however, key on my ethtool_ops :: get_mm_state() function which
> > lets the driver report a "bool supported". Is this ok?
>=20
> That happens, I think about the capability in the ops as driver caps
> rather than HW caps. The driver can still return -EOPNOTSUPP, but it
> guarantees to check the field's value.=20

The stats callbacks return void. We'd be relying on the ETHTOOL_STAT_NOT_SE=
T value.

>=20
> Most (all but one) datacenter NIC vendors have uber-drivers for all
> their HW generations these days, static per-driver caps can't map to=20
> HW caps in my world.
>=20
> So weak preference for sticking to that model to avoid confusion about
> the semantics of existing caps vs caps which should use a function call.

An even bigger uber-driver is DSA, with its own dsa_slave_ethtool_ops.
If I put "supported_mm" in ethtool_ops, and set it to true in DSA,
I become responsible for rejecting everything except ETHTOOL_STATS_SRC_AGGR=
EGATE
for all DSA drivers, which I'd rather not do. Alternatively, I put it to
false in DSA and I won't have pMAC stats callbacks getting called even
if I do support a pMAC. Maybe DSA isn't even the only one in this situation=
.=
