Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE905B5F02
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiILRQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiILRQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:16:19 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130041.outbound.protection.outlook.com [40.107.13.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA9E22B11
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 10:16:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bp5Q06ar3/WVT/4MH7cCQdJpRF/jqIQ9iiSAfSfgYAiVUJSWJK52gKNSxZV187bXUYVHZ7IhEIz4Aw/Rh6O56ESP1pTcjiWxLhl/Y58E38BeRaf6W8Y+BQcDBlz3AXPMDoUw1oLgvRlxMp3xVH5ClJgTrgVNDM+g2eKXOtmlDQwbJnITx1tYxxBIUYkq/LOpkwYeXFIU1WO62DdTQWUHzmnTvBlQqnpjI7iPZihAwdPxbDJ/2GYgZZmv1UIOE8U6rdjdwOOpRVUNxYgmDoZkr2KIwE3fEI3MboTJH9b9Dv2Zknp6XOYGekdJpNICB4QkOuPs6VQH6MmxjBhMUVGVeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a62zYFC/nJ/DOZCYyMxxZMEs17aWwvmon2vY5dSHLIE=;
 b=AMLZ9QhnVakxYvSj7VGurWJ52rkRkXecz9PeKeF3d2+LTotAHhAyO4YPyAS+tp43u3Pk8ZpTSYTWvb0eOr2AMRA1eKBcINBWsYBJrrquEg0U2n/b3l0YwzeBznB3rIPkN6JUK2qt09gOy10jn2Wixa3Vb9HeckQizOIa39OoyjJXH1fXoeOTl3vLvY299Kh/CQBRa2cvYhUJmv9eqZkJyAYUYdR0a5bUCN+7anqDrhreADLH7eFzILcn/M9+gjbZKktfwGSvs01BW3UR8tX0FBinlYkftRFq57CmU/2ovs+peL3cJ0ORpk/anzREEqNkzFiBiiceLhHk3NwJiDuBFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a62zYFC/nJ/DOZCYyMxxZMEs17aWwvmon2vY5dSHLIE=;
 b=BRkXh70dySxnP7YO/dvThzUO85lIIPvIUcnjc21XRXfvtRLnyXAHRDq+OVyCXVj07BKJuLrKhV6yVErwy08tMxR1kVVpTCRMi0tv1plOsyOb7hCghtvnWPRb0mJdkxmlrmdBViKauO+TZ6pvFLXhJpbnFc1OpcWAQCHTz4fO3W4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7996.eurprd04.prod.outlook.com (2603:10a6:10:1e3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 17:16:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:16:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     "Daniel.Machon@microchip.com" <Daniel.Machon@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Topic: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Index: AQHYw3oLFH1ClvQDs0ym2viLZxTp663XCMEAgARbygCAAJ5YAIAADOEA
Date:   Mon, 12 Sep 2022 17:16:15 +0000
Message-ID: <20220912171614.jtxnnc43dvh7khzj@skbuf>
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-3-daniel.machon@microchip.com>
 <20220909122950.vbratqfgefm2qlhz@skbuf> <Yx7b5Jg051jFhLea@DEN-LT-70577>
 <874jxceemc.fsf@nvidia.com>
In-Reply-To: <874jxceemc.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBBPR04MB7996:EE_
x-ms-office365-filtering-correlation-id: dad86547-4e57-4b07-8be0-08da94e27fd4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RJoy9ssB0SEeJMLOX+y7WWfXNrWLQWDMEs9tSdHChstEXqnFYGnjzmxdnwxW44ymQFm4w6+xKdyslWT8CIP+nkH8kAOGWgXwOuTYXrFcU2rJKM+BXY7exefkcq0GTEEfV+y+O2AbTqfxD60JP03kw/YNPgCl99+OY0SORg/aCVdu028f15KZEisdnE2CRB6MCBkO0ENM6+Up4JFYpTLgczHepFM9hHpUvRLPCyctCvpHxsKkrMkhYFTiwpbeabCTXnYQ0MoVU5+O4c7UHE2mDn2MQ6oYvK9u+TJbn+eooV0oZLMDF+5VJKqXNZvz0EveYFv+B+r+JVEAabLzoMAM+cA1zpDypxHGKXG439XvsMs4Xwmc0vP0XHiC3Zjlpyg3xlv2hxgbN9xcM37Kj4VtIxZ8Fe+iehn2o+Ullb0DgBKbmuIsd2x+06peGFRFPupK0rsyWR+ujT1GfWlQ4jyuBBK91yterQ9axQsbu3ElYYEXGvoYTROhtgWuClDUKyvxFOivQwwnnAUaAXCaZoB3c8kbwFMoEYJIqQHusINU66ETlTcqcRWAY3GESblXrF6f9wXAMI8nclJPDXBFuL5dtXTn9woIqX6z0GWRqi3zDyrBgialJseW/OAyaHfIg6rYqcpGp0/CoIzeLQL6Xv+0hByz7vvAheYSgxP0gKSWLEptq5xFFxQeNuvzU1EKbXdn7FUdCaHTfmaTepVVPc1kueNUgyqquMs9z3T2FGwSeUXvrqYl8359K5b2u3MP3waWCMD0IeFFYYN3RY0MnRgJOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230019)(4636009)(7916004)(346002)(396003)(39860400002)(366004)(136003)(376002)(451199012)(316002)(54906003)(41300700001)(478600001)(6506007)(2906002)(64756008)(76116006)(66946007)(8676002)(9686003)(6512007)(71200400001)(66446008)(91956017)(122000001)(44832011)(8936002)(1076003)(5660300002)(26005)(83380400001)(6486002)(186003)(38070700005)(6916009)(66476007)(66556008)(86362001)(38100700002)(4326008)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bortQ22wUSyNJ5tOLox3aN8tONMhD1aL2McLi6mUiZAFVeSmKcY4aNcKSLjR?=
 =?us-ascii?Q?f2JF9XgkWL9e1m5RL+5Z1hVxlN80YARipsXvsBvznnH0xCVyIGuzK+mrgr9D?=
 =?us-ascii?Q?hgXQJx2Iy9itsHOD3oDq7YhQBrlxn+DrNKRXWDtv0yi/rn42P/StRwgyWxFK?=
 =?us-ascii?Q?4IfwhVX0LMlrQSVSMftr5f3eO7uEsVCebvdZ7XftlLfFf4fC17a8TXOMsrT/?=
 =?us-ascii?Q?l92/Cc6ZEbdaOd0S71D5Uq9eESBfmDB2SakogokHka6dzkGVC9uTqflnoLxf?=
 =?us-ascii?Q?g4PDFRUFcScg1X4ZCBN7Amvy/deip6i9h6VHolKq0Su8e7veNglH5Lc12Ywz?=
 =?us-ascii?Q?f0ebqMJSPsiGPTLMzk7GKQd+ZvZFBxkzm5U26MBADKjMBI+4zpZVmBzhavW0?=
 =?us-ascii?Q?V53GSIHwQsZSr1tpvvnnH02VirP7Ear3R7XQtiBBcxOair6tyZEfDa6cVlXk?=
 =?us-ascii?Q?Q5Rd7OtUm5k4isNx/18F9/uaEBXQPPCgHnIgvKxwTa3+WsLHeihi3T40bmck?=
 =?us-ascii?Q?p8VSPxiUVNcsop0L62InvOjAeKRXZ53cMcZsAMCtI+gsJ7DGxRA56AZ3Skme?=
 =?us-ascii?Q?kQcoZjUBBAl7Fn66PGVx7y8OoGAqwrYt0166DxDow8EyS/3ejbFCBVvVvgNW?=
 =?us-ascii?Q?zAgZsA41bKHvTk3m2c+0I6EWr49UU5OdW/VBP8U8kDGPh9czRYBgMCmJJ7D/?=
 =?us-ascii?Q?BuH17/BSqj0DuTUlYTCydCmFgFElnOb4OiQPlwmwvhSM6tBad5rnyD8tPgQA?=
 =?us-ascii?Q?ir+M7W7zWjvuH5xzZuTEJKzUnC24OFdLJxGzrROGtPW3Iq0RD6MkKZ0XgCEw?=
 =?us-ascii?Q?ia5txX6XeHG7joanEf2AJtPHgsdgzj6FqU02FVA8DrmcwL9+YsXxSkIM5mg9?=
 =?us-ascii?Q?mMKZWCGVqySr7yyNgS/8vHxJq8QjlaTCjCTYQjVGgk9QDWMZ4hPfXcNF+NK8?=
 =?us-ascii?Q?HZkSNZZWPrzV5NekaVrEQowFqW1+KVWYU2DSOQ9h9IRnpH01va5fU64R7Ks/?=
 =?us-ascii?Q?3hKRu1zfO7DeSlDMjfJdejHgiFxPIWalNuu/qFi+3uYGmwlCSS7nsEuSX+2F?=
 =?us-ascii?Q?F5jo2zKBUi14dKhyVruYE/hfnaS5cXkdngr4vS15io4pO5an2QVhoVEISjGo?=
 =?us-ascii?Q?yRluRmA4sD6yweqwVEaun2nnK/gBSp3ummkaDESmEHbD5BRY+wMIPek8ubr3?=
 =?us-ascii?Q?jrmj9hiacqLufKXuJzpMqANhjwy+RPryT631UZG6T4mXlQmehrIS5L8vapBy?=
 =?us-ascii?Q?DJuObfTwTFGWEHsgXW8pfOJGMAqVet42zHaJ7ebFAlK7U6dzTLqJhSaRnODz?=
 =?us-ascii?Q?6hwUptE+waoBi4fx1ugG0SKL8dhEr9hosrpslDOOFmhZh5cfKnJIpYzjjBT9?=
 =?us-ascii?Q?4QnHccfVKzhdkamzUdinw2yZ7WNWmPzRC/tPf523qQey6whYleGuz9kUPNLq?=
 =?us-ascii?Q?VjVnpWPAm4TLQOh20V2yngE9ginEI6diHqzbkxRDDcUpkyiSVUAwLyg39JuJ?=
 =?us-ascii?Q?Iqq9fmwMNjxx2KN7tIbvlke8qw7/rp0NZ8OQL1zECBi+MuAIg3Ety/R33g33?=
 =?us-ascii?Q?CvRCbCVELGXgx0QjXiJCCtlVhMmlB2hh1gXzR7kzsWg4+MSL3kimtUnF7sxr?=
 =?us-ascii?Q?Xw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A0468C59FB5DE438ADD928A81FCCB5B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad86547-4e57-4b07-8be0-08da94e27fd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 17:16:15.4345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5SPnilewdetzPSHG1wNqJgu2S0LjtpNk5YigM5fWWf8yIotKenkNr6BgaO5Nih2UMVnQa7SucfK7q+yiZBZAZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7996
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 06:30:08PM +0200, Petr Machata wrote:
>=20
> <Daniel.Machon@microchip.com> writes:
>=20
> > Den Fri, Sep 09, 2022 at 12:29:50PM +0000 skrev Vladimir Oltean:
> >
> >> Let's say I have a switch which only looks at VLAN PCP/DEI if the brid=
ge
> >> vlan_filtering setting is enabled (otherwise, the switch is completely
> >> VLAN unaware, including for QoS purposes).
> >>=20
> >> Would it be ok to report through ieee_getapptrust() that the PCP
> >> selector is trusted when under a vlan_filtering bridge, not trusted wh=
en
> >> not under a vlan_filtering bridge, and deny changes to ieee_setapptrus=
t()
> >> for the PCP selector? I see the return value is not cached anywhere
> >> within the kernel, just passed to the user.
> >
> > Therefore, in your particular case, with the vlan_filtering on/off,
> > yes that would be OK IMO. Any concerns?
>=20
> Yeah, it would make sense to me. With the 802.1q bridge, the reported
> trust level would be [PCP], with 802.1d it would be [].
>=20
> As a service to the user, I would accept set requests that just reassert
> the only valid configuration, but otherwise it sounds OK to me.

This sounds good to me too.=
