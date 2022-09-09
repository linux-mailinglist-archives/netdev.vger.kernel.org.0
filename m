Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349135B376B
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiIIMPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 08:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiIIMOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 08:14:44 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0611.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34726146722
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 05:12:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIfxAnOxBdx8/9aaORc0o469gqCRBXmx0sIv04VK1Q412POAaTKvhhfnbO/S/SyoFdsqtVYzelU+4W2clZxUuufLFpw5KW5N7/G/vX2QS01nvYbF3rbEpEL1bpp59xRbueaS+xtQRDE2Z6e/hG6I5S5m0u4Wz4x7k0WT/IoOi6JWx6jm/zWWURTkMItBZVMUliuGvyG7Q15REzTsijloD2bdAY9szhBfqRA5chMT15c4bg7fx45TPI5Ferw+xpa6byF6XER7SwNmyJvA2RXdWnt6KcdSkBxvDMhttLqzGHgqdsa0jxAKF1/3FkL0Vj0WP7I6dcAv6WlD4dQpdeCN0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfsad0T3JSybagjswvbYq9y48SgjVLh11/l5nid4HuA=;
 b=fjwdOIdo7PN4+w5urLfKb7CP67VIuKm+uS7aH7V/wtUfTqc7viL8zadLrjThkGgBs7qAhn8EXtLfNn2coo3HT4t9vmQwYGIMbQen1hi6IMmgocpQMXrQtAAE2HwoqtG7eRP7ZpxAGx80WkgBGamaYY1shmFFCatLdyQ5PMP47PWwCWyL/Q5fizhypUG5IgWtr45rhkfwQ1IRrpjRak3GqySwIHvDlYE69kGHHGLJRYV8apVOCQVgD4bWr23xV04swcKQbl8byvNf5GMkZ3NYMeYFqHYbPnmP3sgJ386GPRaiYY0WfcyDNSOqQso2XE9QnpERRsyKgTp/iIoDrdcFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfsad0T3JSybagjswvbYq9y48SgjVLh11/l5nid4HuA=;
 b=KSS/XtCRpWrn5hVeoIH2hbV2AXDhcT1SzZak3KBH9TVyH/V59cP1NJwnvx8mwgbz6DpSbNEZykzaNmarmE21+H79U5IDdQ18qgJNP5rKibVmGH/X0sE5bu5AIb8Bd+iCA+E1DGmDj9QJUi5xT+q1TgtVoNalZa7l5vgKgkGQ6Ec=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5380.eurprd04.prod.outlook.com (2603:10a6:208:111::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Fri, 9 Sep
 2022 12:11:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Fri, 9 Sep 2022
 12:11:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Daniel.Machon@microchip.com" <Daniel.Machon@microchip.com>
CC:     "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEAgAAg5QCAAItKAIAAGesAgABY2ICABr5YAIAGp+0AgAeuXgCAAG6mgIAALLAAgAKgIoA=
Date:   Fri, 9 Sep 2022 12:11:50 +0000
Message-ID: <20220909121149.424ztw6lrfq5jann@skbuf>
References: <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577> <87k06xjplj.fsf@nvidia.com>
 <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
 <20220902133218.bgfd2uaelvn6dsfa@skbuf> <Yxh3ZOvfESYT36UN@DEN-LT-70577>
 <20220907172613.mufgnw3k5rt745ir@skbuf> <Yxj5smlnHEMn0sq2@DEN-LT-70577>
In-Reply-To: <Yxj5smlnHEMn0sq2@DEN-LT-70577>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28d7b0ed-5196-46b4-c9da-08da925c79bc
x-ms-traffictypediagnostic: AM0PR04MB5380:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TllKEF2htxSpto3SqsMJujZ76LI26APdEMEVZO5OS+F9ggAeewOSBabCEPTdAiiQsAU2yeNEgAAI50l24NLrbrbjaAi9U3iyKL6LQMNMvHmJJUhCJVm+ObtwkK4JMXPhkZG5oThYK8U+/dYTgL4IhnJ8z7Q00DGLkqNmsJgHOhvAminUyyYc9IxIFf4pNDVXzPLa1t9+tSVYHbTeJDl5SCCEzEq6NYe+0ibXW6vd0pHQfNKx7JEG99g1SG2gkfH42DGQ0Gy1OCyX/FZpp/NVcQP/DRVXpEKoKfdtnzwFmwOU4SSfKX0xZyBHjotz4ACUyQ9/RgTuWVVrCzyO1OVbYnuvfcnZXa+zy/qzxkySWyVkqVIH+d/eOMQTVrghB5ipQJbejIRwNiUUg8XOLssA8gXzkwn9UO5xDj8dfuO1pp6kKchU7PfbCZ0VnLKnXcdKicf1VjnTBMIyyqZ/6oLm/mHihqp09pbYmF2XP1Eoh1E4zs/9pg6ULjhjgCNUSaUOl0rCRHlZWIDqix5QRWG6mWv2c0u1uweD5gUdrJL/p2QhfJQvnd/OFNTuyzWBHp94TwHkfsucR5BdSuMntKVA7kOPRieUaONWyOUvkJ4IvZG9VCFMha3avAOYEjIFwUZyOHsrppIrKlqsITRgfCONGwWHDaitVn06LcHaunOPTJJtMkEUKRC1DwOB5oYuar8CDyQaSCUd0Ug+CIZHvLqVf2Yfo+SknnwObGO56pGdDPfnzok810D+NnI5xaOU+e0qTEqskvY3/ZCjAIgdkubONQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(136003)(346002)(396003)(39860400002)(376002)(6486002)(478600001)(186003)(6512007)(26005)(9686003)(1076003)(6506007)(86362001)(44832011)(2906002)(71200400001)(8936002)(5660300002)(38070700005)(54906003)(6916009)(316002)(33716001)(8676002)(66556008)(66476007)(66946007)(64756008)(66446008)(41300700001)(83380400001)(4326008)(91956017)(122000001)(38100700002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?18td9pLHr26QhFME0AcpEewjMdxjCNLMAsPVWOjmUkNRJl+tFvkR5smxa9cf?=
 =?us-ascii?Q?rPx4CsllKcpzJ/7kWLAfRun9cBJB7fy/LvC3pjI2nA6xocnkhfcD+750Kl/S?=
 =?us-ascii?Q?wviISNvhGCVRbg/jUPDXCtHZuTXtNDCZ9MrOUMF8D/tMvCtkloCpX8daS3YK?=
 =?us-ascii?Q?T2u2SBZZwjL74kEeoPofTdXDjTIdDD0v71VXMD9akIrMSvcP9zMuD+qWZvkB?=
 =?us-ascii?Q?Ty6yERET/rIrD65iMN43bhGrJDvyyPEAScXqU6UGM4tYtwGn8ZtCMstd57nD?=
 =?us-ascii?Q?4XptTtZowzHNANlGwWNRTVL4KDNlA5+IVKvIhnPmPzsUkqCWkUUdkzD2nXx/?=
 =?us-ascii?Q?hj6pcdNPZyETzatb13IhzJU+CQ9nwyu2gg96lxmwj1aNVA5jfHTJw17DMgr6?=
 =?us-ascii?Q?Ep7RPaM7nCD/CiJLztLY6Fm8nytow7VzldNGCSzqGa+l+hEdsCYWKegwTZcd?=
 =?us-ascii?Q?uIdptOQIxOkG9kO4VCjzDq1TttwbOHvwhtqA+DUULPlGObv1nj2oXmsmHth0?=
 =?us-ascii?Q?I4u2pU4HW8Xvy3WfVPrTDU5Kt8E2U66xlM7RhD5cXmCOV3drv2C1/lX5lShz?=
 =?us-ascii?Q?CtoBsewyXn29OkbdWpkD4/JCyL/UCeA2JDU28u2TJ5RObhtzj/+cSS+qJFy0?=
 =?us-ascii?Q?BXhGY6NJCAQaAN9PpWcEaIPnitCJwdha4Nhyqt2bkZHqPKnlHfYUjGzESB6Z?=
 =?us-ascii?Q?rvp9/hDaY/c0LkemTGz1uwzeJtZJS0Z4+oqx6sraiYBJTxyfWHG7t1pFCrBF?=
 =?us-ascii?Q?N51HVDKO1FYZkgQrcYumZbyZRzLg4DnnRuLPhohr9iLRiKIDfQzGsBGW4r5U?=
 =?us-ascii?Q?QVj54UhRiRUt8fuhBYMRDNxTmHJLJwcE864ry24Sv3JRqDRRg8Q/IlJO2gEb?=
 =?us-ascii?Q?mf2BMArSaqwXvjTh3boDzW32Sb3m4kDABmRRbTWj1ubxJkoE73MwHMf0X0+T?=
 =?us-ascii?Q?LwmDmKpwNqvD9bI+9sImRMWnncyyFCkHlEQ1GYHqofbCGi1QVuk7W5DD2bpt?=
 =?us-ascii?Q?tXMJKLuXywy1CD+8zz0A8sp/Zmy4Xkb7lYMM93qYzoSc6EUZpSCnkJQgq+OT?=
 =?us-ascii?Q?IOLceHHjkvYKCZ4Us+iPGCbtjuqy0OD6rEJEvi2uVqZHkyqTHaNJCcfl489M?=
 =?us-ascii?Q?An14XH1tnrypkKNJUkA2jxIw6ssnYnFnCAf1pKtdp96+KRPv1GoFHpLyuAzH?=
 =?us-ascii?Q?7MWcE0q30ftERl/1U5KWeN+2Anr3WshUl+RNOb4hmjjlWdenXHi6Og72yf+f?=
 =?us-ascii?Q?jNXW0cwKlIl6aUXYlMkXaKHzj9SXPzR7vQYZ6qmlpAb1+9beguLE8r1/1zX0?=
 =?us-ascii?Q?m2warUeK1XhyjV/e9rDFfwT0ofpZpk4NZ7Zh+ajrqA8mv0KlneZQ90EbxK+r?=
 =?us-ascii?Q?9Rsds/Wj8ivSZl0sQyoGU4qKgzU+YEemJfwRGc1u7egtcouErjC/HXSc6aHj?=
 =?us-ascii?Q?19jSredDXbqWnfEd92cusEuLX4Zg2rDJVoE71NCqaKYjq/G97AqF1QoWfwdT?=
 =?us-ascii?Q?uhS3TT3QxstLDN3k4Y12yshx4CJWQCcCrINexLCQRRV1IEnePRoO0mrlQM2n?=
 =?us-ascii?Q?CqUBze3MQuANVQTuzN1ZwDX9FpJSd+3FZ8ODp81wow+mbO8EwyHEIwhc7sU+?=
 =?us-ascii?Q?2Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13E8BFF9193D6245B08180BB9DAC4E3D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d7b0ed-5196-46b4-c9da-08da925c79bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 12:11:50.2783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d0TbzCKwBEMzrve8gGLNt6jYGTOrIOwhY5wm6SHApmQHlSEuBZMRhF+4ANKGZATZZ5odJQPe6pbC+6Il8wKGjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5380
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 07:57:08PM +0000, Daniel.Machon@microchip.com wrote=
:
> Right, so VLAN QoS maps currently takes precedence, if somebody would cho=
ose
> to add a tagged vlan interface on-top of a physical interface with existi=
ng
> PCP prioritization - is this a real problem, or just a question of config=
uration?

No, I don't think it's a real problem. I think it can be reasonably seen
as a per-VLAN override of the port-based default.

> > The problem with the ingress-qos-map and egress-qos-map from 802.1Q tha=
t
> > I see is that they allow for per-VID prioritization, which is way more
> > fine grained than what we need. This, plus the fact that bridge VLANs
> > don't have this setting, only termination (8021q) VLANs do. How about a=
n
> > ingress-qos-map and an egress-qos-map per port rather than per VID,
> > potentially even a bridge_slave netlink attribute, offloadable through
> > switchdev? We could make the bridge input fast path alter skb->priority
> > for the VLAN-tagged code paths, and this could give us superior
> > semantics compared to putting this non-standardized knob in the hardwar=
e
> > only dcbnl.
>=20
> This is a valid alternative solution to dcbnl, although this seems to be =
a=20
> much more complex solution, to something that is easily solved in dcbnl,
> and actually is in-line with what dcbnl already does. On-top of this, the
> notion of 'trust' has also been raised by this topic. It makes a lot of s=
ense
> to me to add APP selector trust and trust order to dcbnl. This is the sol=
ution=20
> that I have been implementing lately, and is ready for posting very soon.

Ok, I'll take a look at what your implementation proposes.=
