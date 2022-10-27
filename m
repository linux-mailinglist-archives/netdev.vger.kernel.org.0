Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244A160F0E1
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 09:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiJ0HDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 03:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbiJ0HDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 03:03:35 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80047.outbound.protection.outlook.com [40.107.8.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8A2149DC5;
        Thu, 27 Oct 2022 00:03:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1y0WkYtgk32/yQg6umxS0OFCIga41oZfb+J+M/n+SI9hCLicQ1q6BkhpwwRoD37rm0l3l/3VVnPBD0T05a1wQBB0qUdjS0m54qX1iBHHR+p/BNmxBu7pJIRkXUzZYXPX8mC+vLfTS4NaBxDMDbz7WRXQ3QzVS6oXncvNY3q1yOq2Jv5vDhVArDAf7Gtix7j5QWq0QluUOH6rU1ES6zHXYHWcnvUq9xsFpUuqYcLfVX7uPaCsrVJ2/n/MbbHpVo929L/IjOGWtm6Zq+O3HFGdgmeO4qbQ1a30+Z9lkEu6aR8sDUV8MnBZNiY6kS647vJI7KQOzOCPioIVEVbSFVvoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9elMg3cn1uEMbldYjYL8v2HbLQMBQjmrz/Xxs7viBo=;
 b=enm39VYcuUpbgdfjzBYKcxzHJeGzw8QaUi3X5MXGDassIiz7OLA8flqid78f+tOKKYFAWOqxudhIDqhBEXMF76v7+e3sVwzquJrEr1/UB7z4xnrpYp5ktiIgAjAIAJ1gyMNV8b9/NXdht0OSVpSd61chZCjzOayibJj0OmeipkadYud5qpspJK/txHbJhBkodJNWb8TdDnmMA/hsoL9AxAGeWTwrmRP3B/MeeLdMhOa835rK9iBQScRt8fsyxFvRC2CTWbPbkDoToWXCpdqVdtct9BI+FgYhPIHA1c14VDIKp+WqQh8IKFZZwk4Ri63g5TrKyPQO3oTWV5F2jJ2aZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9elMg3cn1uEMbldYjYL8v2HbLQMBQjmrz/Xxs7viBo=;
 b=Fl7zs5x01VW93+9uZ+EILrYLEhxi26ZMRAnbuDvaU/WDWNyB5uJxlGmO+0I6AeTVlOAgilMKg4ZFvLWw7DP68YxQN+L9MQ2YlWMkCctkugbYvu46f+ORV10+zHET7EigyVA5JevbpLzQmmll8BecBKpuv/KqZjt6EghRpc8K4RA=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DB8PR04MB7148.eurprd04.prod.outlook.com (2603:10a6:10:12d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Thu, 27 Oct
 2022 07:03:32 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::f9b1:83:c855:6c2]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::f9b1:83:c855:6c2%3]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 07:03:32 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 net] net: enetc: survive memory pressure without
 crashing
Thread-Topic: [PATCH v2 net] net: enetc: survive memory pressure without
 crashing
Thread-Index: AQHY6TRiZjWnDLnzvkSv/h/ebvX9va4h0AuQ
Date:   Thu, 27 Oct 2022 07:03:31 +0000
Message-ID: <AM9PR04MB8397AB65FDF4990B9E941F2E96339@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20221026121330.2042989-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221026121330.2042989-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8397:EE_|DB8PR04MB7148:EE_
x-ms-office365-filtering-correlation-id: 9a1ffb4a-42ca-47d2-273c-08dab7e95bc4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mgnfXNQvOtheqLuhn8GuSRbEEkEWcvu1SNlLZCBN7UNrZ3Di0OvY9R3t2mrGo5axbWVKf/AbNmQKtBg7PAtrpTyh/y2xd3uV4frEZeap5pVscS8ZK8KJYTJM3MzIUv71vHDfTGDVFFYFU88KkKX4TeiN5m95lOJBjlmML7WqED+BlEDphOjT7q5r5sILks7E6QacgSj2GtzT8qCtQIIYyFlbrRIRDQ+sn2JzmaLBFPrYGoJrKE5/rwtodvEcunnsfJ1z8NSMQPwm/NU09wYS97FRTT6VVl31hziUonCztHtnGN1AhZjW8R0U12pZ6hQNtz2w9J1/vkOTfuKYE1tRPYiJ1Xngju1V18zHAgjaAfhQSOWWe8RV4Qtht2wGwwbrMgA6DS4UqssAoj1s45+w2wV2lH9GGQYL6rj9QChLOSGmZfMPaSMqvXm0LjNFeCeMdmG2HeMEGgSpXlLlY+ARTILRoOnxOdjfUNowC4fV/EhBfCdhCRoENs+S1T6oEbtj7d8ojemLMvOxbhFkNtsdlV9ZpvtBzahrFKPc4uCE+YF9Cr9rixQgWocC0yhxbzUUQ4A8k9qPg6PWRk0lbKy21lhCgyiiwLjR70bmo+9qUrGlCiDIui8KB2dL/+WEUdsbrJSD/k4PqE9WbUNmEOqdhtW7ulWQ6Se9kMNQXMVbl+xefRdTGr3ppsuDmF2JZRelxa/4PLi7UkwrDfafhFz1lQ945Q30aidO5Ss3t27EoPZ5xu2V07/KhgyMqi+xVmzepB2kvePX/Y4x40+5agixmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(38100700002)(122000001)(8676002)(7696005)(52536014)(5660300002)(66946007)(38070700005)(4326008)(478600001)(66446008)(64756008)(66556008)(44832011)(316002)(186003)(110136005)(54906003)(83380400001)(55016003)(71200400001)(76116006)(6506007)(8936002)(33656002)(53546011)(9686003)(26005)(2906002)(4744005)(66476007)(86362001)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VjwQWvu9pead0nu+ze25nY46SGpua1kTF+2DzXG6GSBb6FwWLA6/ZNLspv6l?=
 =?us-ascii?Q?+b7QBCXrZ5ZUIH5JvA8HkdhlBn94xJZBr2uaZN1WKAPXLV/Gk4kweCbVyms/?=
 =?us-ascii?Q?ZMnM+4WhABzcNH+CRfXbSS9Qqm3NC1309Yb+2cXfwuujdqyCM3ZrnKsiFjii?=
 =?us-ascii?Q?85yV6ujFFFVUwc2cjtJXsx1Lzc1LyCPDEWV0Imz1szlm3tw6++3LP20XOsOX?=
 =?us-ascii?Q?6tZjuFa9Ikr9j9CAEFHUq5u6dxcLK5Y1HlPqQfywvJyzlSUCYS+Yxiy99xV9?=
 =?us-ascii?Q?yHXNt9HN0iQRHrD5w6e6TIjZ4waMzKnr3/CpCT5pSk4zQ3F28+cPY5W5Cwvp?=
 =?us-ascii?Q?f/5b1QwqltavG1efnpvZuap2sAd+3puXq0wkgU7Ag26pMlz54evd1QqKwoXF?=
 =?us-ascii?Q?JketyBpCQJNFepIahffsaj8dBAEu4vLxEQ4fAR1YDXdBS3lZI0Tcj8Dsf08y?=
 =?us-ascii?Q?w53UvvAJtveGk5PtmMFTgUXEO9kvrHvQITrfX6d+AleQAuHCdibKQiNUJjr7?=
 =?us-ascii?Q?SW1gEsWLL/jfqqdCLjOxn24wlolQtNOB2WSHeOejHkVMU0jr8ZVRwiSmjWB0?=
 =?us-ascii?Q?4xd4XjYBwkh0+NDTolg1uMCiCtpxA4hqAvtcM2cbOnzfFHTJ3sioww9pcZuv?=
 =?us-ascii?Q?AQDpJbar2ddgEp+Nzryurqs/v1qx3Y7gAA3VYEF6Sthr7XUjCj3+hRLAuPQP?=
 =?us-ascii?Q?QfXIz41F+rGDn78DUbr199RUNqSwX3Gf+ERil7lpaJfQEHzqs5nw2lybA8P7?=
 =?us-ascii?Q?gPbzQpT4YGQYySP/d+41DTA7sPS7WLwxzXIgNfWr6g9cgFq8r1qGVwmT1dR5?=
 =?us-ascii?Q?M5fY4LeOtvcoaw/DoKtx++MrJoY46kKqc3+kviPvroocCFEBAjsp4/7skiDe?=
 =?us-ascii?Q?Jp1rVixdd17nn2e5H3G7oy/XujdBQlblJmH0ReVB9KBtsOhe3f5mQceTMajN?=
 =?us-ascii?Q?m9C9sTuNKr/9ntQWqW9UxLTs/1YSIVcpMe7hMVDG9yRZK/rnt6vVrKN2/XkM?=
 =?us-ascii?Q?KWGiIlbapdNpWT0WxLigk3tbmYHCIigKk15BYu/EgJeqbDqgCMAXOuX93XOc?=
 =?us-ascii?Q?EQjhLGaim6MPjWsvNB2giro8ORiZqc9XGm0HkTPyllWD0QIr018wxBFSvkBL?=
 =?us-ascii?Q?JgqNRQIOspFTh8aItESonNvpD10gHigDa8C6CKnBs47ktLxoboQ7te8Yu4KQ?=
 =?us-ascii?Q?0a6OR9793yla4A1NVEXY7DywnExI8yNNpZGqbRJ0lx4v5QwXVF54fte2Duhn?=
 =?us-ascii?Q?boXZmEWqrZ7ofYzhCl/hBJmKs0sF0gfN+2Fdk4wmcbHe4hg2sJhdDsz7EIiY?=
 =?us-ascii?Q?y2ua1zWwJ0x/zJWGQYDaJEVYCnIegFjW/KeYr9pPUZP6nfC05vaZHohN5eyw?=
 =?us-ascii?Q?YINpWRyEdFMWfjG1ZRc3XuG/U6A0OCLavV+wT7S1D6J70iMYOZebZZIW1yhk?=
 =?us-ascii?Q?rLqheAzzUluYs7SqsODTgzrllQVEp5NlVnxPGsJWLC8qKoOlj2eWouiom8p3?=
 =?us-ascii?Q?ujHmGxPA80RO9EewbU8S0iHJw+zHmg3N5sKL3VxCxIQa1crL3o45bTupYgWD?=
 =?us-ascii?Q?unEmT4vUti4x+mt7KXQ9cNdrQKYnFzLL/grNEtx0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1ffb4a-42ca-47d2-273c-08dab7e95bc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 07:03:32.0566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hN4D1JUfuc2D/Rtvjqal3vMrDX2lffoyZqQAHlteL3YoDbwV1q4YF3LbwqIKLTEOEL/HdAXGHEsshlhlvIdIrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7148
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, October 26, 2022 3:14 PM
> To: netdev@vger.kernel.org
[...]
> Subject: [PATCH v2 net] net: enetc: survive memory pressure without crash=
ing
>=20
> Under memory pressure, enetc_refill_rx_ring() may fail, and when called
> during the enetc_open() -> enetc_setup_rxbdr() procedure, this is not
> checked for.
>=20
> An extreme case of memory pressure will result in exactly zero buffers
> being allocated for the RX ring, and in such a case it is expected that
> hardware drops all RX packets due to lack of buffers.
>=20

How do you trigger this "extreme case of memory pressure" where no enetc bu=
ffer
can be allocated? Do you simulate it?

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
