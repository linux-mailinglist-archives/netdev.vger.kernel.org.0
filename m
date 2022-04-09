Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D06C4FA765
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241686AbiDIL6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241688AbiDIL6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:58:02 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80047.outbound.protection.outlook.com [40.107.8.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C49CBC3B
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:55:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqDmo7uecLmscq6wPuexKF1WhjsXMHi3x03iAtdgL/l+/91cBWxO/0pmpg1xR+QkuxjxcWFWNWmZdeiDu/AznDUZun4d9bpskOvzd4vcPL7b5Tn6oTa9gHJOEbX1UgPyHOownYh3MChU+bOdp2wIQ1eSHt8sYUeUZKmqGHZFiMWI1/Rq4obqO5HbYuziJzE3y5C90UHgJ4fsRfDJOKoQTqKxWY8loLMxQqXKC2ev1pxLh51lXGcu9bGMkQhkdwSyn9ycZNQMYD7JZNeB7o5KirJSha8yfGXH8FarJ39uJH964kbAxUOrBsbcf3doIyCfM/qOxCRbQgZNrjAfLfefWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3Ulz3nfGegkqYzX0cDhgi8q6SEKVTeHB1h2RjZn1/A=;
 b=Ea880K0O4ZJ+aqdSkRR7KhTNyriwFD6D4tEqpuAbHm83iFCZotGucNT8uRAe9KzAG7oP6A2r3BGqHxxC4QJGSuwpBQfs0j2bpVlW2avz592Zl3eojZDU6ZDbiJusRfcDanFWGtieryXsyxmXisUHt3z6jPBmZm4QfZU2pieoFi6oUHnCsT9D+Q/LDUeBEt+7H82sPeE5uR1t2MgxJ+0lWogL4Aq6THakgkQiI5in+V5qxBgA0h7iWjBZLzw0J9fsttmM0Jzdy9MKftbiRvO55pdfTr2uI3XOd6r5IoL8INf5S7CSuGzGUztDkRM6aue8rZpQeGkhVurr7lQntvywwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3Ulz3nfGegkqYzX0cDhgi8q6SEKVTeHB1h2RjZn1/A=;
 b=qJx+po78N9hjJ0rNWdyXl0qk8AKncKORJKggmkA+qAnHMPLvmYJpy1dE3wDQHybeLNSCqfNtAf3I7/RiAStlJCVnv+HfSVKCELoVQUPhlOz38Yr3Fhfuo4KC7j5KDuOPdZBXOpTQdig49H0ZrkFtBDgvOckP2ntE30mpsFq257c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5552.eurprd04.prod.outlook.com (2603:10a6:803:cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sat, 9 Apr
 2022 11:55:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Sat, 9 Apr 2022
 11:55:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH v0 RFC RFT net-next 5/5] net: pcs: pcs-xpcs: Convert to
 mdiobus_c45_read
Thread-Topic: [PATCH v0 RFC RFT net-next 5/5] net: pcs: pcs-xpcs: Convert to
 mdiobus_c45_read
Thread-Index: AQHYStHwr+3eWz4dAUORx4HsSMXi06zne+EA
Date:   Sat, 9 Apr 2022 11:55:52 +0000
Message-ID: <20220409115552.fiadfovddubmo6mg@skbuf>
References: <20220407225023.3510609-1-andrew@lunn.ch>
 <20220407225023.3510609-6-andrew@lunn.ch>
In-Reply-To: <20220407225023.3510609-6-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c041023d-440b-4e9a-27e7-08da1a1fe5e5
x-ms-traffictypediagnostic: VI1PR04MB5552:EE_
x-microsoft-antispam-prvs: <VI1PR04MB555258C6385AC1175A4E3F81E0E89@VI1PR04MB5552.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oq7+M5dYusD2aiS6I5QrvB+3foc0GvARvZ/0+IJEoKLXHEIM6O92eos9p8S6BpnthMQlN6+PHfmnfDJLtW9+Pa1xqISpAss6rU3upLhLWHQwMxlNsdznGyGJmaqvOts+Pd95vahxbzDLcfxFddrP8o32BaQrmRkDcLVoULD4b06WF5b+0gt9cqDCRbi3almzXTHDtQTDg76XWtfLe4UonmsPP1xgtr6O5ckN6jMJqz41lFElrHTFDsxj+5yiqRVMVJ+wHOtsbzdGntxIqiaJk9SDqAgE/VUwPflAjzgv/U5PmN7aHIn3z0xAmBpxcEnEEvHF0FQuU19VpkIi/JLTTT0l4KXmtBCfZr95s5Ld1d0GTkNhwa7GNNa97/d/htyCSW/2KOtO4C6o9rYSqK29zYZTOgkNhAWlLQZZAq552B5M8rHJl7M82KAOeqVvEG20fOrru0KHhSUaZWj+4Tph2L+NrzMCCoxWw87VVLnamG82cRnCcuL+vcjuaV/vR8gvsAf59uK5lLulh0rGibsIfLW503pa5RI2CsTnflHRBF8+S/cZruYG8P6XfUCFFs1bsKk2FNL7IwKCofSGhXWtZhgkhBo75aDLlIwfu9mDmTJ+LaLgsaiH5hWD6cfKVDHq6hvEIPeipGL02x1kiSZGJ2uzPYdmV9nn+wuItpEYH+XAhd5I4Da1fEQ1yER+wreBr1VK6CfmWcerlfjS/1nqng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(26005)(122000001)(38100700002)(186003)(8676002)(4326008)(316002)(54906003)(8936002)(6916009)(71200400001)(33716001)(66476007)(5660300002)(86362001)(66946007)(66556008)(66446008)(6486002)(76116006)(44832011)(64756008)(4744005)(2906002)(38070700005)(6506007)(1076003)(9686003)(6512007)(508600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wfRXnUzJsiP7/FKUsOSlyV5+5q1Bfd8Nqjg5j34NYhidZVpy6I3caCgoAKwH?=
 =?us-ascii?Q?5ZZCV0qXcnSBE7eo38SA+I7Th2ec2b90pS1e/vfVqqEj0sbjI/ACAkha4Qu1?=
 =?us-ascii?Q?OTTXPxVXFIu2nHj7/6PIkK02fhCdkPEAxawLwTD4IBkkK4INdOLPDYofejzo?=
 =?us-ascii?Q?kSDfKsgb00v0Y/dOg4VDPl7897ROlom9aZgU+kZfo8RmyDbLyoDuGKwnbtlJ?=
 =?us-ascii?Q?i5ecfttV0BRYEOfSuzToWQk706KQcmRFhfSM07MbwXKC4jGu9UQHnwxv0XS6?=
 =?us-ascii?Q?DXDN/FVu0KUG8z3t9hjPK9uTjUca6Ua3hdoU0bZl0g5ZjMjBI0u8py4SpR/K?=
 =?us-ascii?Q?j+AedVn4uvHbyQZsq+vzWW4vn7EdXlAqBKAYM2upI1J3foaZjG6H+EQq3UlU?=
 =?us-ascii?Q?gNVfV0ksY7nQ0U7mfnZ5UEu/K8q1O2bgi1U4U2melgCIlvrC1iESuYTc4Q3t?=
 =?us-ascii?Q?61UO3XD/VRY5p9hKrplOZpTjjaJOOwsRzJsFgr78fqThoUCNCF686dT9LCfR?=
 =?us-ascii?Q?AF+uWy3YnfhmWS0XlfSz6JGMySDsiJKHK2vaJ7A92xxtLD+RsK7e6NOUJcFr?=
 =?us-ascii?Q?1sPtUlTx1zNZalJ9mSymZlnKZsujO1gIoPVJgGLPd93Pu6qOL7d9JFVKP0iE?=
 =?us-ascii?Q?T5aVh9GGFdq8F3Sy/5uLdx/Th1dQb07MvpMrGPmir1vEA222vDl1jROujA7G?=
 =?us-ascii?Q?QnjGd/fvSCtDv47xHZOTYvIxFzGrv/gMiRRL5E5uGEHMwCaFO13PQV170BBJ?=
 =?us-ascii?Q?hRCLYTLiVeb2iUjPpmvHnw5pnJ9H84OxWFgMbADPfcKGCZBYaMVYe4ppwyYd?=
 =?us-ascii?Q?3xx7wPCcKHtHeHZ7LuTjGMB+A73BIJ5Q2P2f8ZMdEFJr/sOsIXZAI3hhsPXn?=
 =?us-ascii?Q?vaYFlS91iH3KE92hqHeX9Z8czhgxE2S8dDRqW+YRciyON6ewzRC9gO70t88O?=
 =?us-ascii?Q?Uzz0bL/IY0Dd/4Z2n3SQPQk0iur5x0OWJ11rO1Lk1BRlHRPrcrHsktD17AYl?=
 =?us-ascii?Q?TBcUsX3gnHxecmAs8Z1Gpseqoky/0KRJdGlEWBo1MEB8LosRxqxDf8B5BycA?=
 =?us-ascii?Q?NJxIj8aHORxHOzPsGTzc9vWc2C1MzVLticRRFZWZ9OXYUXCY2Q5hUdm0a2sW?=
 =?us-ascii?Q?liwcqZHIwht4t72IK1qzKHBpdHaTbJAHb5sUlSqkIsGPA5/TJwc4vxqaJJ8H?=
 =?us-ascii?Q?8rbqn/IMmM72YluB/J0co1j1cq23c8xX3wtNJEHR4DiwWmZ7WRI+LSpa6JKh?=
 =?us-ascii?Q?BET0EQN6HkrEciBK46AgtWSLN67IXwcOXTcgy6jVZIBaX4v2xCes9CrXxn/F?=
 =?us-ascii?Q?rhpyslyv1R+iFaqTepUCQUMjFRQ9mltKBLhFf8pPmJUpbor/8in4pv9MgSD/?=
 =?us-ascii?Q?DdSC6v45gAperut3j/9uzZVxVKa+FKFpcmuWY5kpNBtPippOVTzEDgZnVOvh?=
 =?us-ascii?Q?9GvMlE2NpMf+ILXclsik+3Eg9P5WmoD4a1Hvg18DpWmn/AG3r1LZZY1RGkuV?=
 =?us-ascii?Q?4OcynZ1FsC4r/HfqLt67i9O4xhi8nwYAGguV0Lr3Nlg0z7xeV5ReemwUsCBE?=
 =?us-ascii?Q?VSncysbQ4Te/OvvOVHhQkJbj17259hPFhlGiFV71hW+ldnh9o4rwase+emUy?=
 =?us-ascii?Q?Liv9IVI2EUAfiwc8agqnp56R6rt/S2RkTvVu8bE6BnKrmwlPz8RX1gawFGEH?=
 =?us-ascii?Q?sv92Tcl+wmhQgokmhZdkKzdMW6Ms1M4JvxJ1OWQcia0ieZsAALIyNV4XFRHE?=
 =?us-ascii?Q?0tC0o8UcL/NyUMgfUq/uDwJgjz7/TsE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52A7707F42D54F42A789CF0474CD2DCC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c041023d-440b-4e9a-27e7-08da1a1fe5e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2022 11:55:52.9030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64Ma7o/atRcRjpkNv2IjfNjfjkz1HqDg2steQxbFavm9TUwGKTf0NqnmGEAxFnAYXtscmzSFSHTIeleR2+2Y6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5552
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 12:50:23AM +0200, Andrew Lunn wrote:
> Stop using the helpers to construct a special mdio address which
> indicates C45. Instead use the C45 accessors, which will call the
> busses C45 specific read/write API.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
