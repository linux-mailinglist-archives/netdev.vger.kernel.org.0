Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8E75AB2CD
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiIBOEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239003AbiIBODo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 10:03:44 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60058.outbound.protection.outlook.com [40.107.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A97159A7C
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:32:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oApt/pwxyJvAzHvFXZ1HyhzuBNvKxqimMIKwo72SIGQgPmYkbjQncOeQGDzb55hW4yHQHDEa+66jjSeJsHabcGxThMFleeAfbE2ugrUAJxUY1oCU0jBWiYaTlykGIfKBZcKt4curnZb0ja7pYJjtS/hfkVCDF1ODjKGYtyQga0OUI4aAumKuMzAZS+yIv9m+p/cdQUjfhqnbYHbk4cvT3CG1tv2vzB6uUx7V/MHsildtHreNA4i4HPTTyCKAIo1EvmpoBTWRit733LgB3vgA5pxGMPrFfIq9nczEmKQyIpDq5nV67Dq0ZsnzHrvgah/QoEXpSeDRj1H+65Z18nD1gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pd6vXlKTuj7ThV2Tw0BiV0h3Yf+eCD9YDbKmL2zGFjk=;
 b=ZynQzXhnYseJUaaRe0WeddHDtiXqxRzu3UzvPewGWr1IywK+S0DmwOZcmOXbdkQirYp0LZEuo24INuvQQ2IvFUeQVR46OTAY+eWmS5PFcPmk48QDiCk9kUeBfb15J/+Y3GC+jIV4XUqEhqsAHZwHZfsa9ZJe02oA4PUrMgmF16Zr4XakWXS8PGxqfbs06DISGKuwk+roeZw8hai7hepIUy5zVXh4FGbqZXdrt6rTeNMEJ1Xi9HHytrKvR8xLCdAUsjArxUbN3k3vc/wNxN3a8fnGgKKido1/tdN66VoASrNlb622FWig/k2UzK7Ub4ZfKpTw+94tiQx0v6pnRYw7QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pd6vXlKTuj7ThV2Tw0BiV0h3Yf+eCD9YDbKmL2zGFjk=;
 b=VN6zu6uC7HRkUovwOTARr7/GMw/jRFU+qI3e4B6E9pTkGZbMzUcRT72vAFD9DLnF78JL0BfExKqF0toW8dzI/+rGV5l7h2p7xGEkxsTITpkOeZH0lIKQXitwTYfG2r+JIt/sHDsgyWE4lm6vmL2qM+pi6VoAeLbylhfv/4vdkj8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7134.eurprd04.prod.outlook.com (2603:10a6:800:12e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 13:32:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 13:32:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Allan W. Nielsen" <Allan.Nielsen@microchip.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Petr Machata <petrm@nvidia.com>,
        "Daniel.Machon@microchip.com" <Daniel.Machon@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEAgAAg5QCAAItKAIAAGesAgABY2ICABr5YAIAGp+0A
Date:   Fri, 2 Sep 2022 13:32:19 +0000
Message-ID: <20220902133218.bgfd2uaelvn6dsfa@skbuf>
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577> <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577> <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577> <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577> <87k06xjplj.fsf@nvidia.com>
 <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
In-Reply-To: <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cdd3983-f980-41d1-bdc3-08da8ce78f37
x-ms-traffictypediagnostic: VI1PR04MB7134:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0i3uw/PdCfqXi9bJ0lXBSJ60PyL05PTK9JCTTfK/WESfkJFlADFR9skrXu6AwAUWaTHbhw2rXZH6NZray7q+s5lBQo8l42eRhb9kah5DXf2hQtPzl/FFEBnoDpAVdEu9q0aSAXeiXiETPYGvvwGSpV+NZs9mAPHT2a0fTf0zwg3HG7xd0tZyBaPVP/qy8XHGanTAsHwW+akEYuw9lGs5tDBZUk4CvKOUQBCbijQy9VICk9psMSX7sWXB/8m9OKQaL5czVAnUvglki8EDS9RhakqSeFSaYuKGFV2PG1Ht9XNnn+YrPE2eNR6FYHB3SPzDP54P1MlaeNdafGPViCdk8wjWvkZCX334mdVOKkrsgoq+Xf7dRhyNekZd34j6Y/9GCEDN8SdYQ83mmk3rn3h9CNjOgudM1ZTKr+Zsih8sEkVeGQoJyKkkzPiNkP3XIjvNroCveCVzyXFKogxJpN6I+kbjLU337dGT9FbDBQHeyEKGnYaOA//H0QHZv4o09hT2z9aGNMumSVn0vbtYvM8H1jobbGZegRO+7B8okRWTbTrceigsduS+TAwZgnKeQeAKmxDqa/SHjpSiw3RxBWgf+tMEnpUXWTD5P5esAK7IkrZGQqO0bKi58rx53liItAKI/ii8dRiy7o3J34CVYjR83AWB70YCx9DekuKMaEOZQ1gccAT2c53jWym/wo1H0jADnnEM/TarYs6rFvCgu8J962BK1fkNO4fIuJ6l4lXxZrPjwVwY0nDNvoZdUj66K7c3W3JDATR3Uqo0KdGSxFdqlKEHFb5ELYl6kDAfqctyvww=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(186003)(1076003)(41300700001)(966005)(478600001)(6486002)(71200400001)(26005)(9686003)(6512007)(86362001)(33716001)(38070700005)(6506007)(53546011)(122000001)(38100700002)(54906003)(6916009)(316002)(66446008)(8936002)(2906002)(66556008)(76116006)(66946007)(91956017)(64756008)(8676002)(4326008)(66476007)(44832011)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H1RzWM6Numa39PDhvag70hODaH90M+dyw0YKTKKv0zJvvuLeU9ufiAZ/0G0/?=
 =?us-ascii?Q?6j7OHcR2exVQ0yQwaGP7TJgVGy8G+/VERTIo9U+rBq+d3uNTFW9LwoGV+ocP?=
 =?us-ascii?Q?EmugGy+eRO33dxGTpv1JVo3g0LLErOmrvVsaojO1xQJDsGvTd4QtYVi7mpKi?=
 =?us-ascii?Q?hmtrfwXno6gQuf2sfmbIA/xIbtOKH552bYX5WVRQFucpMv6R6Fq8qye7RAxo?=
 =?us-ascii?Q?KvEbxU0AKlCrey+03YSKL43dDOcA4wu4j1aBVD+f6uFZHTi6evQkv4g/MkW9?=
 =?us-ascii?Q?9tqHcYl0SHzFnoLQAOu8FPMjmi3WZK9dWpajt9495HoAzH1qS8gxp076FqT3?=
 =?us-ascii?Q?LH06YXOtZOoOcLrULldV34YlBSVqrbgXPfmroMW/yaWC4VUAvhO0S6eCCGG8?=
 =?us-ascii?Q?bFeTxu1RUqv7gn5JzcaTIRQos2pJ7gdgrKmiRgDNkYHwauIiT44QJdYkRJuz?=
 =?us-ascii?Q?8DXdY8WFZFA09GbGjXJQaVGkdIRZGQoSVP+FuWb29kvorTlzl7ALfSXAFwdc?=
 =?us-ascii?Q?zrWE8X+gZrUr51vOlOODiqyRaStfKYCjR6Cz74mTnd1ZNjeegapvgOfuZPxa?=
 =?us-ascii?Q?61GZZ0Dwr69i2dvBVjpFYIK49JxGtpalBtvZ5t9bxQkV+Iqev6Cdd5mdT8P0?=
 =?us-ascii?Q?K5ydbdeG3SAJDT8a/5BGUJkgrB7KJECWgLzcctPmh8BTJTf4EDrVKO625t5Z?=
 =?us-ascii?Q?OfMtexwEeNCgsFuwWQkGsOYSqM//Jl3X9lY3jdb1lOjS36WiC2MKk4WttatZ?=
 =?us-ascii?Q?mn+DSWoShcy7dOYQDGiW69pJoSU2deurSgpLMJ1Wp2BfQUrL0MFSmksJ5mme?=
 =?us-ascii?Q?y8AGDYGXzPAz4fFYk5V3SVBCbfQqVI+Cd/efe+RKkf1szuX/89cS1E+D0j7O?=
 =?us-ascii?Q?6DYOkGA7sZ32zDVyoR2CRj9ciS6xIFrqfmkG7E45ZuQkLz8ZvJzptMxQwOQN?=
 =?us-ascii?Q?5938tIWm+XHwGv7wfhcoQY7CuE2Gz9NhD9FzicYagmCr0yMq5McPSfNNUzSI?=
 =?us-ascii?Q?jc3wDNzarYZnLZ3blImLqj1uNI8rmqvW2V6AwNvtHMwNETpeSldVBefJS3/V?=
 =?us-ascii?Q?vpUqYwJvQ1dmjNglPxcbU8a3cjM0OH5wWtUvEeTYUxTtVwetpicmVp7+PCYT?=
 =?us-ascii?Q?WDtNKcjnZlhI4AdLzgBEpJTw1MVJxHm7BylqFkYFmbPEr9CETgt37rYc8OJT?=
 =?us-ascii?Q?VR5Kt/tSM8u4UkxexY9Vg5ic1ihCldWJyjaLCDlY9hIWxmSttxg1tpz3gXaF?=
 =?us-ascii?Q?YO22uI4C1ple9B5p+UHoIv978C4R5j9EDRJH5odJA0OBgaQqWCjHiOyxxyfQ?=
 =?us-ascii?Q?+YLfvcrVDIrDczqFAMmkxLJsu6qoFyjbrR4tiQ7H0Cp+jpwd9BmlI369KOBd?=
 =?us-ascii?Q?1kN+vmSwGI52oShq0boGNINQewH6YgB1pl0YxGxqJVxdIbPv6Fl6+KgxVCz4?=
 =?us-ascii?Q?f0DEx12OnHwLUm9TYX5OE977kf6ERJ/Y3jWETIWMyjp1HylO1rAIu0S6OQpL?=
 =?us-ascii?Q?Vxmpwj08qPJ1CdrpImuHLMk6+LpZQPtEDWRKrwX4bgX1x/zvAFh2MFkk2nYK?=
 =?us-ascii?Q?Cw22nh/RPpZkMo/ij8OxAKp17jb5Q15dstdpbAjl/jKAXeFhkTD1qq5XJ8qq?=
 =?us-ascii?Q?0g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7EC346BD3A04064C87C7F9FAC73D569D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cdd3983-f980-41d1-bdc3-08da8ce78f37
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 13:32:19.4319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UB5YhSyo1E4c7kYoE0OTQhhHVag8vpYax++LL8tW6wSwE5QQpscY7HIMrcsmn/7i9LajkiuaCssbskvBA48FRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 09:53:42AM +0200, Allan W. Nielsen wrote:
> Hi,
>=20
> On 24.08.2022 17:54, Jakub Kicinski wrote:
> > For an uneducated maintainer like myself, how do embedded people look
> > at DCB? Only place I've seen it used is in RDMA clusers. I suggested
> > to Vladimir to look at DCBNL for frame preemption because it's the only
> > existing API we have that's vaguely relevant to HW/prio control but he
> > ended up going with ethtool.
> > No preference here, just trying to map it out in my head.
>=20
> As I work toghether with Daniel, I'm biased. But I work a lot with
> embedded devices ;-)
>=20
> I think this feature belong in DCB simply because DCB already have the
> related configurations (like the default prio, priority-flow-control
> etc), and it will be more logical for the user to find the PCP mapping
> in the same place.
>=20
> I think that framepreemption should be in ethtool as it is partly
> defined in IEEE802.3 (the physical layer) and it is ethernet only
> technology.
>=20
> /Allan

My explanation given to Jakub at the time was that I don't quite
understand what should belong to dcbnl and what shouldn't.
https://lore.kernel.org/netdev/20220523224943.75oyvbxmyp2kjiwi@skbuf/

From my perspective it's an inconvenience that dcbnl exists as a
separate kernel subsystem and isn't converged with the ethtool
genetlink.

Regarding the topic at hand, and the apparent lack of PCP-based
prioritization in the software data path. VLAN devices have an
ingress-qos-map and an egress-qos-map. How would prioritization done via
dcbnl interact with those (who would take precedence)?=
