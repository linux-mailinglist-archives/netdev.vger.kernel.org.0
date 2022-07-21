Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC64F57CB5E
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbiGUNHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbiGUNGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:06:37 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEA6820C7;
        Thu, 21 Jul 2022 06:05:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jj3Xx0MD13KkyTWA2FsyohUSSsJjyJgmOmtSggHIq5nxkefG0W1OpMV74BwhmXa1tSitlER5wb4L3eQO2942ONX4uB4fY1JQApQzEQ6KzkueZ4GoLFoWoemh2NdJTWcozBCAtxPKKM7QmOwju7H6XWscrE+UTtOSAP27WBc4XQkSsKx9WiQZu55JjRhZocVylnKSuBk/K4vnOs9w97R6E7OExQZlT5EYj2ix9g2DA67zD4H2DsHy2skfz3sBwWEh2vzDmbq7GYazI3Krip1lp9iB78CYYHusk0HsyWtCKi/FBkcERRq00NJv7S3tpfDFyn/PG6N+rp0BHasDtXeRKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5XRAcPcS/fnQe/QsvXDSZnzdw39kYnV4WEi/Zr/ULg=;
 b=JQSjKMceVB+lMx27Iz9YluQ/X2+JnV+QHP72VDRchd9L74NMgYjZxOMBYECy+BxMKsMPWIU3+GuTplUnDjsXzH5IDwywR8FbV0wxVrDmbVOH04L+Aqz6jA7vQoTMWDVUHY3yLiXV03Hbowxmcemh8q4/rOughdrD6MCInFGJnYy4oc1qiz3JAWjD0rqEGo9zVEjUAhwNkE1Dn/vdMVViJoJ510cbxXyR9syjOkkVOwzIyCMg9zlfRpZRLLEqmPqHhC8CeZdMmxO/0ermg0egvO8akaxCKQ9kEpyAF758rAqm7xA2D05qB+WMSjhOsCbAajBX4CNaRnxEcyY9wXPSTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5XRAcPcS/fnQe/QsvXDSZnzdw39kYnV4WEi/Zr/ULg=;
 b=rGxFthZ6YE2Qn1TTzhszmmsXN1dMPjJ+tahXRmzE4omXKhXFAwqBdPZiV5Dx/zHcPGuUtLy8m/I6L0kuhjGPSZATiKZLrEEQTWsY/8lcTRnEbr+mZA0m8HSAufqgMJPEWPRvqZNr5Y2+tV8nHa3D/z9AiIssrME6qil2ExF+atA=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0401MB2560.eurprd04.prod.outlook.com (2603:10a6:800:58::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 13:05:44 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:05:44 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 31/47] net: fman: Use mac_dev for some params
Thread-Topic: [PATCH net-next v3 31/47] net: fman: Use mac_dev for some params
Thread-Index: AQHYmJcRD/SAUH4XZ0yB4FotEmPi0q2I0+XA
Date:   Thu, 21 Jul 2022 13:05:43 +0000
Message-ID: <VI1PR04MB5807CA73C8557581F4BCC77BF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-32-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-32-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f916f582-99ba-4f03-fce6-08da6b19b872
x-ms-traffictypediagnostic: VI1PR0401MB2560:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: czd1bZ8Fl6UlvW4aqvflseGo38HbG2K6g0VYtd7dh5Y+UeJjmWeL6NypdjoO1mamIYbaDKZfNwxVu7Ymfe0AiFgR8I58C3VdsUqlBev51pqy3gPTfA+Gotoz4t80Q05RwTziJTRyg/4YBf3KwfyO6IA+RUmOkGfVHzZqGa/HIYpOvmRRlgKy/nc2oybMvhJNm3b+3CBftkhinnmzVSB6Qqbw2v7oBDKNXywvQkjAy06Mi9eSZ0f8F32DiPyjHQ7shHgZG1gni3xXhTf9QUpP10vh1Mz5Gh3PBNF+dAjsTMQvvai/U6Fg5WyS1+AvgIFqlpDn8T+/n1RIL+xUT6cTLJGjNVRuaQg7A399kj43+tTIRHvzEWgBU1Wprp8ZePYUb5AVoLed036iuQ0D1G1Ll1Hi5gfLUhsizsb3nFgRBLZ5tPIH63DEih3kiWo78KJ4e5O+CCH0gJmI/VFS1aSlWChChvLA9vgn75HC7vM4xjbccngvkVRUa6G0UordUXIggEaRaga9/57by7jedJsRapJNeBvSxr8sjs9okBW84MMxgg+jxBPBufa7N0qj0kOgwFootolpUoJiU45R5cOeomc9ZhvL8KN/Pi1vHqBXPEvHcmtXZoeOHWHVcfF44DRayqtakAt8caWOk0j+dFyRyRP3if1LKeY0UBCYRHAPVQPVyfoEKXaRsJ7QyLd6vX187kfej3NGflOvz+sCzZit3p9yNWB6FwzrSCHcjvyQcrj0MB/I1AuKpkZYWnS+J3wpLpTyZCfxPTMl4DOi6QLf3iDU/5tBtSKXGTXATAZNyvo1XcN6CF1+0eIwfUV5p4kq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(110136005)(186003)(9686003)(86362001)(26005)(55236004)(7696005)(38070700005)(38100700002)(6506007)(54906003)(53546011)(83380400001)(41300700001)(52536014)(66476007)(55016003)(2906002)(33656002)(76116006)(66946007)(66446008)(4326008)(478600001)(71200400001)(5660300002)(8936002)(316002)(122000001)(8676002)(4744005)(66556008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZB1VbPEKi942giEkToHxPvczTFvi2xCpgUgzNBjgxdmXH3ue+8Qbb8Is7NNW?=
 =?us-ascii?Q?UteELxr4Q0UQOrZ75ob3r63k/hwhhM8AZP530l4jlsEZqKb/Z+8LBS0Bc9Ob?=
 =?us-ascii?Q?g8gmcRrVDPHopxA4wfZ+mCgmdnPIH7lYGWTR0g1H9+QfmFsrq0vCet9vzPeJ?=
 =?us-ascii?Q?sRa7hjAv3gK2wlrI3qTE+qDMi1iKiUwqHASUL8mj0hjEsDtIrG8avphyO78F?=
 =?us-ascii?Q?UguUAQ8TLSsW7a1PQ4Uj3nh9p8a3UuxxH9nPjC7Pt5eLim3BnccSC8Bae+CM?=
 =?us-ascii?Q?qKo98L7yrsvmxImXGXaEcgvBsVkGsVzF1a+8uM5Gqg0k1/77Of1JtqZHgWyQ?=
 =?us-ascii?Q?seP5oFrlJUBa7e6+BeLeGn7Ftz7g3NbuUDMtpJp7kW2Av/jSuuVCq6zrGlKb?=
 =?us-ascii?Q?INyRsRZKy8a9K5JqxX5sCfM2xdlBI6M9yvljWW4e9ScHgHGkNfhmWyxTvnZa?=
 =?us-ascii?Q?gt6/z6FxvZf/6dVfRTIjc22WLzhbup07UYyITmQSUfxZEK3dqUL2rT6YtH5/?=
 =?us-ascii?Q?tksqHyVKaDV9HlvGO7IhZa8RkW4gmzD8INPKoUi4okaSPZrAuVrlSxbOyv/g?=
 =?us-ascii?Q?C8qLYN8B9rAsdUjn9MZNIvhgNJRLIwsCSETu5DAv0LmBFArrkSHyJP2bNHjK?=
 =?us-ascii?Q?XAKI2U5cDOFgJ26e7UI9xgdFnvOw6lAuGNxCyjTQ3PnVp1bGHMYci7i0PFdE?=
 =?us-ascii?Q?WtTZl6K7j1oWaQTvn6v57+vs/Nmb5bY6uCVffHVTRJ5ASsr2l4hZIlNn36Jz?=
 =?us-ascii?Q?dZIF/KGAODsBz6bHM5kK8hISwl5iRj9xmzzwxw+G8c2fSUiuc4KyRoUwYQUA?=
 =?us-ascii?Q?6g6zQ2xHJQws7SpEqtDiscpqgoJrcTjIIdxZMOaarSXt2dIKoOeec6B+2LM3?=
 =?us-ascii?Q?O0VJ7vxYEpen0940jbTzsqD28Z+tXad/o/yClNaTKlC4Jsf3lv3c1hJu1k4C?=
 =?us-ascii?Q?81r/TPx5xr6yFHs+8wpsmGikeZmGWiRHaJrL9RqO5nWZnkGXWC3dbsoWR66W?=
 =?us-ascii?Q?WGJ0pjxntjoZd7Do+QTCC04UxlZUrTrsYzNr9xw2KZG4z4VrYdaVveNLtc9A?=
 =?us-ascii?Q?UHYe6PTJOKlnTVjwBBQJVY5iYArM30N7hv5hFjenANsKBKOlrxLd29XMSXhJ?=
 =?us-ascii?Q?nVasPrqOh1utm/4kF6ubWJz67q7+6EQJh9FRToFMMXfppBBix4anjImy9aAo?=
 =?us-ascii?Q?X6bQk2Rq+T58XCR1lFrjtIOoFfjmgQYC6nOPkMu9aAcTfFQwcYB9W9lJW7Bq?=
 =?us-ascii?Q?tSXTA3xJURr//GlenGSG05bHWNm6l2YLOA8eDYazM1PSiSWvzcpIDoJgPLza?=
 =?us-ascii?Q?CaCLU2Kvs0jOx3z2TCoESocL8yR9y7BopalVU9pH3JomE0Dx+4KhZMEvU1zQ?=
 =?us-ascii?Q?M8BSsROiRjG6iDJZxcBTWudfmdaPURWeJcCidHpZYBbgzgUniiYTJ4DvDsHP?=
 =?us-ascii?Q?TMhOSBW/zhlXCEdVOMsQp6e3zzuSEI0lt+avX2VPZp9UTe9ENrWtF9UW1ilg?=
 =?us-ascii?Q?b59sf46LlRwgdJ5b3JSKHDgJc3A9TFGcrjc7hMkvLTSwQmJFN6n7q5oVaO4Q?=
 =?us-ascii?Q?CfUubXboTwl70wsBfmbTamzXFsJJuUN4d+OD+5Nl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f916f582-99ba-4f03-fce6-08da6b19b872
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:05:43.8619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V0SO5IPVTR9m1HQrq+NyFllXkxVsuq8DH5EuXckLSuHEgcIR1ovVCmhfzIsHhuyYzHUmF68Oocj01VQACYaCVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2560
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 31/47] net: fman: Use mac_dev for some
> params
>=20
> Some params are already present in mac_dev. Use them directly instead of
> passing them through params.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>
