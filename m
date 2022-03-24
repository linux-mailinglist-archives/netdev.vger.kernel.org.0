Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2544E6885
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352533AbiCXSUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352502AbiCXST6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:19:58 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBA4B0A68
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 11:18:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CO6xMWfBqzyCBwHgllRfMoWfnx6iv9+2CpKWw4T8g4BixMVoDrCLNH5qGI3e+ueeDBl3Ja1ccy6rw38Md+Vmfxh0rExGF4szzvsYWVteOcOooh7rdK4j3Fc6efFNjraZBHoSgaXvmYv6uojwi7q6J/AqfyHdAnZ78Id6vyCTAwhyh5fUNlMrR3s9t2ANi4Hp1f23wz4if0vrTqyLncQg1p40DetcKR+bCff991dk1AXAtXs+kmvW4b5sO8YCp3SPCU3v4idqoLAo6MzLXGxb+l2FKy4yK0k+dLh+jQpeIIO3rAv4PH6sg5ebAWksU34lh636hx71tigKO2WjuDZqLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25WsncwLm44O5uqmuL1tCKu1Fcav7MFMjGa/CCVJthg=;
 b=DU7AjQZVdz5/12LnFJtBFSs+jWIh8BLw8p2KzFKXIueFy0QJU6qKm47OpQA0dhm7ot+TN6r+402joSX1+/DKUDHKG+LaRxc/1BfZQiKS+1da8981dYIr+2EfbJIM6ql7e/iEeOcpknjnZF8CSqVg3joyhyzcqIhaxWs2w7rm/A/m13dNpA78t6MGupgD1iWxvhae5F2hsFuMmrlTCOW/5lZF89Xx1a0u/np/t8HL+VoXvkJbKNqLUKb620DZTA219U6OWYo0E8NAOrhBl7PWEasKaVBu44UJ6Ytw+D+M+oykncT1x/qx2haWEDr42a8aDiXQNb74Bgb+fSiwy/HvTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25WsncwLm44O5uqmuL1tCKu1Fcav7MFMjGa/CCVJthg=;
 b=gOQ1VBlpGA38tPcQfUS/2dbLSndSlIhebYtb8R7VDRS9vCo+u0mx3FfQL8Mpjv5hLexs8VsGnRL8KM95K9CP9hg1BEwy2TfOGKxSJdnjLS4vpbMnWE4yNVn9PhAu4dHn9zMUpoJDcLnYp+/wDj8FztelJlfEgFV3H7IcIZHi6jU=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DBAPR04MB7463.eurprd04.prod.outlook.com (2603:10a6:10:1ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 18:18:21 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e52e:aa62:6425:9e9b]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e52e:aa62:6425:9e9b%8]) with mapi id 15.20.5102.019; Thu, 24 Mar 2022
 18:18:21 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH net] net: enetc: report software timestamping via
 SO_TIMESTAMPING
Thread-Topic: [PATCH net] net: enetc: report software timestamping via
 SO_TIMESTAMPING
Thread-Index: AQHYP5nyH+qYA1oJw0+1w7iMyPDcSKzO1viw
Date:   Thu, 24 Mar 2022 18:18:20 +0000
Message-ID: <AM9PR04MB83970980618B40DC1A0935EC96199@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220324161210.4122281-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220324161210.4122281-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e042332b-3622-46a5-d338-08da0dc2ad66
x-ms-traffictypediagnostic: DBAPR04MB7463:EE_
x-microsoft-antispam-prvs: <DBAPR04MB7463C0AD762DD75AD6AE1DF896199@DBAPR04MB7463.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RRwLIvQFzxkJ6DRaQhcbTrhc4t/Eow250mYRRf/36JaNHkxGWPCgvojEciCRxSxjaXUFTpC5Ie1k2/IFJBOOny1bfCmSZt2kdem5hOxSaGW2oiHJ30AVPjqIdGhqMpe3SuXIFwBAuRyf6OWAHekpn8YuK8JIasVPv05I2JqMtsL4hUzQ9sg0jjTeJ6rptm/TtIBxPc2P2YSXsdSWyxr/4R/4onOtsYeTRnFObrXNU0rAgyWsmj5LojAQOW8vQSIpk4AAg5lVsROoLWX6UjvYrxR5+mtGT+mWKRWW72FuOQCqhD5OPKl09dQNL+ncFVX6ndR/OW5zZXYzTBBSo7ReP4no5tK+4HlnozFkHOxIJ1YwUDP6ces7zWk3oCYA8E4FnCk8k3Oi3QoDmuc+B3SLYPLYAzk33yCNhl++u5LpmlrJ/C4AzU1+8mJxwSwLRDOciRrd1FiA3kPhcAc0PDCfN4ieuaOpTYBzMz/Jed7S9bgWh1IeMF4E8u/V1sTem8U8PtVjB8GU6lO05Z4Q4i8tdrLx0ClE8Au2XfTbtUWdgb0p+2wY0mjJovN+8rrFoX7lz4xei26iyuPEKxOED2pbbIaXz88Zkuc2DLmvunGehnI4VZwpb1Cub+qJ2LiKjjUXF74UExNVvsIsoeFbCQoK0UV9BYyL+WGE5z+cCUd7JsfKKAmMY0hyZMdMfWCh6KS19quWg9bHkNSGSlGnNUBgKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(2906002)(52536014)(4744005)(316002)(55016003)(54906003)(66556008)(66446008)(4326008)(5660300002)(186003)(66476007)(64756008)(66946007)(76116006)(8676002)(6506007)(33656002)(53546011)(55236004)(7696005)(508600001)(9686003)(71200400001)(110136005)(122000001)(38070700005)(83380400001)(86362001)(8936002)(38100700002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EtO/RXtrVuRD/4yo/w1XFqALwc5IwbjonDFyrkRX0+MAT2d2Cizdr3+Dizdt?=
 =?us-ascii?Q?j7RnTw0yJkwlz04XmWAFwA0h8aMARa23O/dwquRCdZK6rPLctJ4HZ5PasW4I?=
 =?us-ascii?Q?n0p/2moI4v1LidmPOIVYHCPyTVUHCv4CtmzmviwKrdJv/IQntGAtTX6ko5Sk?=
 =?us-ascii?Q?O5Iw14+jrTkOZgeRYCnEt41uqUIH8h2FvOrwpQPxm4LlF6Wh8jlXjPZp9mU/?=
 =?us-ascii?Q?TczANdJcSB8H8GNYGKI9y3qfmgza+kcOUlppRirgBCFkKqlaq5zP5rjQ8p3H?=
 =?us-ascii?Q?9DBhar5wnpA7WUNcuunn1et+3UQiWe2WXUq3AGp+vie0Hl6XfJQnt2ULreuu?=
 =?us-ascii?Q?2YOuQZN958jZnNnbs74ajkROkKjoQBxKzbCW/oWznpmGzdS1uxAN3MLhG2g9?=
 =?us-ascii?Q?wZGwMpZy5VpbLVBW82rX3m2HRllINfC5yS7gE2IGbtOGKZtkjkoorkw5sPrJ?=
 =?us-ascii?Q?XQbmthg6jix8KzHnPgzC93dz1+IbKx9/9MPZ3bhB3t0ConyPmYkjoTCAnBNo?=
 =?us-ascii?Q?VBBG6L6SC3u99xR+nq7kwpFg59+jX2ieECaxyFmH05iwO0b7KzxI4yYgRBW4?=
 =?us-ascii?Q?xRMK3OSQ9SF8W39qtGJMuKpyo17OfV/WYlPxJQtH3f6vyC0Kh03hWHy7LBlX?=
 =?us-ascii?Q?woNIBMa3xveCdd3hx6LOgPYVQenf8BHHAAau97AczhAlKuT8RtEqkXG7VkO3?=
 =?us-ascii?Q?gZJ47hYXw3zyEsIync/PLcMtpqGHhetsYUCCxpme3aGfv7A/40Gkp3QseCTa?=
 =?us-ascii?Q?QWRoUNcXY1ZuCJlxc7ndHiGtKJMn2tjWemglL3YpJ5Y0+Y3eeCkyo+iBsayF?=
 =?us-ascii?Q?tCDZWb8XGS3oVOBk7+7OGxwuxBofhg09I1vM6giNhrOMPMpTH2J9CQZpiMz0?=
 =?us-ascii?Q?P87nYTY8sb/Ys8leh7Pu+Z6j+gC4ZN7YAs1bYwfJNpomswoJ0RkaY8iMBSK0?=
 =?us-ascii?Q?83ufjjNupIpEm0jPWmtnhzIhb18hMLWW64mEkY5duj8ZDMHcARvDRgCt/wIS?=
 =?us-ascii?Q?hZ1m6WdDtBIJ9cuWSq0zm1Bb5gas6Yg955c+TAdMfQrf8ExzUol8VRnCHo17?=
 =?us-ascii?Q?YkRQ2O8/aBsZ94Cgtho2MCOKGBJmUYahKXu0P5+7hQBDNrYPU4v7SGWIt3Ca?=
 =?us-ascii?Q?4APpBCLrh5ir1XUTVZP1N8851Td2eWxD252IzzY8p04k/SoABoq9y1jMX2Cy?=
 =?us-ascii?Q?/pX/vKtsxgyBylVXnGuBJDHUzHLi3KtWcaZScbXgyIstctQWoyN/dYbGGwRr?=
 =?us-ascii?Q?EZbL+5k5v9CxFFy9CaHM9t82VLRIU9WoLeZzMbU1xXtaltC9bfkl7i+kLYyf?=
 =?us-ascii?Q?ggFpWwWji50L1VQWCE7eCZNCBGq3MxZ7jib6kgYxEWT2GWPltPhEuMYA5Idm?=
 =?us-ascii?Q?NqDXaJKzRnp3QAohP7Z4072/0sXfbvYHcxts458F3qFu7wkMKZlLG+qejoMM?=
 =?us-ascii?Q?xImJ8BtcYhhfhCGWX6rn1bKdfekjBb9YvHHjCTj84klsI6jWuDQy+m3VY9lY?=
 =?us-ascii?Q?a60VFDO0OrX2Xjnx/5gBaZXXuCiKwctwDYHPxYP4Z4fYqxsdJ34HaAn51EKL?=
 =?us-ascii?Q?K/RrV7bGxkD31fkAgy0e6kHLPZOM7cG/NiLVPa+16ojI+V77scJNYT/rAUG0?=
 =?us-ascii?Q?7/MyxhoXCYUsKoz3atAA9MXtLHK4keG49O9Fn24HOjnzBnretzbiYPPi+loD?=
 =?us-ascii?Q?0k2fXEF7bnBpKXthHyWe6D4EWpGCU1YV9Mx+AN8CZIfZqP4ponOLPr8+CLip?=
 =?us-ascii?Q?eD7d/RmDOg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e042332b-3622-46a5-d338-08da0dc2ad66
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 18:18:20.9579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: frg9ujBBnKs8DwBZITcs9U3SNw5FuS8shA91IW3zLAUZSEltjCFLJyxzgQG5yNxZHT9rJcLYCwWROQ60J09G+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7463
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Thursday, March 24, 2022 6:12 PM
[...]
> Subject: [PATCH net] net: enetc: report software timestamping via
> SO_TIMESTAMPING
>=20
> Let user space properly determine that the enetc driver provides
> software timestamps.
>=20
> Fixes: 4caefbce06d1 ("enetc: add software timestamping")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
