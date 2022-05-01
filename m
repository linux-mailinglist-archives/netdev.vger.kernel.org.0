Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905235163F5
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345321AbiEALMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiEALMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:12:22 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2074.outbound.protection.outlook.com [40.107.104.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00B24EF71;
        Sun,  1 May 2022 04:08:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffZgxsw6u9E3KRW9ppLa76IOTQz8lxkxx/H3j1fLI10GOdraKJhdBHoYIXkQ3ow9OvTiXA1wdw70N0S9QnbyN0eTce9CSWgeJnCT9eGd5t0VehQDKav34OYfc5on0tnMtL3As/4FscFnyeZs0KULZNBC/kD7BW5P3qoMCCzwKW9267/JrLZVL3bOSoW+oMJZbNTzVLpTTsQ7zmBrSVQQB8Ek37A1eCM0B9qAckCX/guVJDJXZMgH3rWppQUdcIsFLj0W3aUfpcKXtv7Y0q/dwqN3ZlxcZnYjoOcoMToPwvUH1FEXoveWEO9b24TY4j0FImM27VZMNBAkyrAFO0CcqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdksmhyGs+WPredcWFnSnJBwpmrY9N+QZxg/rE/4sLI=;
 b=mgW0su5i7SZWUCE8BHp0SQuE9xn8Y4lmdpm/Mq8r66ZTceaBlZRFsVThYbEc21aSs35rjNHM6EA9Q0SPINKobB/GHIH7k47F0fbLuapVnLGeLjGj/Y88JIyFpnrWdpzfKGg3Y97sFNLWg1SpI91VLECHYu+s8jvY+mhsA7MWda4U3wi9JUWaoWbyid7ETlBlP0OdF4skSmotMrO5uaJJsksPehTc0zurO75LV5/bex2FVWJm6gU1IihY+mhEpRtGebygzpTU/01wovL7u0yvk79LiS1d+EylMl0qCYJ3Mkw0GngCKQYrFgTBds9cvq95tOE0oFVOQJs4GBk/3KHbfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdksmhyGs+WPredcWFnSnJBwpmrY9N+QZxg/rE/4sLI=;
 b=qj10ZNRKvSLecRiaJyX2MSOmCbm7wiKRbnuntxegXPsjAyUGXnBXdBBJw8QGC7An4ZR3HeY4DsXvOjxQBdiAvyow/r+AlGhtCZEBfyR1MWYkRZoQ2Wsg8poa+QfZXw3I0SEgOoL+yJCFiiJXaGQoTSNGDKn8F0jYgfMOOqix2Cs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6862.eurprd04.prod.outlook.com (2603:10a6:803:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sun, 1 May
 2022 11:08:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sun, 1 May 2022
 11:08:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 2/2] net: mscc: ocelot: add missed parentheses
 around macro argument
Thread-Topic: [PATCH v1 net-next 2/2] net: mscc: ocelot: add missed
 parentheses around macro argument
Thread-Index: AQHYXOlYLJVK2paDukSvGrJFSFMX0q0J3dqA
Date:   Sun, 1 May 2022 11:08:51 +0000
Message-ID: <20220501110851.45nhyyl3ndqk6bwb@skbuf>
References: <20220430232327.4091825-1-colin.foster@in-advantage.com>
 <20220430232327.4091825-3-colin.foster@in-advantage.com>
In-Reply-To: <20220430232327.4091825-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac9318e8-13d5-437f-872d-08da2b62f979
x-ms-traffictypediagnostic: VI1PR04MB6862:EE_
x-microsoft-antispam-prvs: <VI1PR04MB6862432CEC968070AD2B62F9E0FE9@VI1PR04MB6862.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TylswFXOeHD4FCB7WPuIluw/WzzAIUNLusefDjHovJO1WdvhQ2+Mpo1eHfgf+M1fh+VZR0WBzpEpePxSBHcXLHlpgPLdjzrIqO3L9dvSg3maBJWKVoF16ub4KwFoCs1QlPzJ0/jTLw2vKnMb0tv5PO+mtpNw1ifvcNISKXNU0JX9MQowRTEyrc1/VIdpFRtDTXWc1zwK6taWSfmBwVQ9DitXeRnoYwP6kdm0NlI0zIKUYn4L9mqGn+ZnytroIHOJZ/XHLLgG7su1LIZqf9NNSxeoan1CrGByglrhMXfMAdqKSEg9tWSSLrLJCU45LFE8l6XxHg8dLlijD2iDMkITuK8PHM4ocuKJPr/uL3FnS345j+CZMRCcsoFEmgEHN9VOj2XatuvXBvKiVs1n+2QFJdy8tuB2bqfVowEEvg4RNIEsu0A7d0X4+57m/ms1dDBOT0LCkpflKSKQHxFrI6y/JLExnGPz9rX7uCvDKlED0Kqa4gkGGlEIEcAYRoaINZ/8I4URfS0cOq9nxcwQcLMsORPWWPineDBrXeKhrgqF/uYF8aSc9ChHa+IbaP4xuMglYcUeEFAzbJp9vJ5JN2asIHoJQxEN/YUNC9wjH5upq95/0ef2GcQvP6T9adhXLe4WGZ7CVZeKSLaIaWNNIdbYQd52UVTj4qUe0HIONEd52X93M4uWUu+An+Ncc/P3jFrbQnKEntYg+g8Bn9GuFF4CPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(1076003)(2906002)(86362001)(186003)(5660300002)(316002)(6512007)(122000001)(9686003)(6506007)(33716001)(26005)(4744005)(91956017)(76116006)(4326008)(44832011)(8936002)(8676002)(38100700002)(38070700005)(6916009)(54906003)(66556008)(6486002)(66476007)(508600001)(66946007)(71200400001)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f3Ej9IsmrKKfnUZUmZLBC5rIGuS8ckVYonJdd88EG5tVEl7R9c+NoFgtVoJ3?=
 =?us-ascii?Q?bexZ0BzmbWKTofFK3uiPdxONj/3Xc3XZxcJ4sntcwNQPX2Z0qie5zXKoF8cf?=
 =?us-ascii?Q?Slgy/4DxSJuXYUtGbH6zHhJuE4WGaH7dodA4K0YqO1O0G4T1+kR3SdmQ814q?=
 =?us-ascii?Q?+PZSGihdtix+D0x6dbK2xyo++d71hKSRBz0a4IFHTBNxEt8dHzZ9DOsukJiP?=
 =?us-ascii?Q?o+8UP+nmFqNYgNcOvKQqH8uXUZjALF5A4jiM2TV6NhCxoJCaLkk1Qu9gY7zE?=
 =?us-ascii?Q?6wbZaMo19XDO3lUuaMSnNDwJmE9nKynwuoMNDjrTVl32OULa/uBjxzhCTzB2?=
 =?us-ascii?Q?8VTd/1ZMY9XWi3q3IaDOGMGW1OhxzxQ50XCGSWFr6Hu508+Gaww4fYwI4aOm?=
 =?us-ascii?Q?/nIq1ATn1NAnzqctF6yOMwYypYuFGqAJqCbwuJwemWu0uCPKtTJuZwUb9RcR?=
 =?us-ascii?Q?1Ej6UskM1NZ/ThaA7Ntcv3IGSVyNxaMNnLPegLF1iVxbm2sa59xKwYGKmqO5?=
 =?us-ascii?Q?RYpNjxXx9hsO7JPfqYm1EDmVa1Ze45tDssihZ8ojwAvk4PyxcDFQ+Z+MNlLV?=
 =?us-ascii?Q?aYgIbEwpmPxvz7zxWz2b9Ddvk1ExAH4YwzR483CdHzuxkeHuczSOQEctofL1?=
 =?us-ascii?Q?1RrYS5AhJZ3IR4+6uvtWjbh9QXzEDEhFKYILMnIaOjG3SGchEjr8HtjSg2aQ?=
 =?us-ascii?Q?J2ILWJ2eWkLXjKTWiTsbJu3hSc2qmKQphJeH9pW3SvpLsdTKjbGMo9d7yq3p?=
 =?us-ascii?Q?GaPh2jtXod19Bes5x+C5+Ka6qiq72v2yTmocF34BMJLYGz1ufSbVxNb/XqEx?=
 =?us-ascii?Q?mQ1T0n9w0jCkBWdKiEBKxFkp75o+u8t3feKw/LFJc9CmPra2QdXTNBLnxgTF?=
 =?us-ascii?Q?/1DW4p3w6bCjJBNkSleuj48RcG/fWGfwVcPnLOruE0AcZEbz9jl8RE3xgMUz?=
 =?us-ascii?Q?qLrWwiiYt4A+aqvYwyUhgzym9Wz60FlFgsEtmdsUC9pNUhnyP5aEC1T/RUuw?=
 =?us-ascii?Q?sMcR1+j/M7+J95eFBErliHWlb4g7nheo/PZ9D3QWqLa/tjbEhROFNRhYXt0l?=
 =?us-ascii?Q?hml8AHbrULrMxiMQWqxYnV9v2Qg3Do4i21a5H1B6dBGuVh+N70+6YcnG/0Ht?=
 =?us-ascii?Q?JUUok81y1wX4soqFY/hPjitBkUWxfAJnB2upXm/1Ci6BHfOEHdTAWLD4lWvD?=
 =?us-ascii?Q?Ut4RQkcpnKIGGCBU6iwK1Hm5qpUjWLUu933+3i1fH+Uuc7zS8eWeOmc4XS0m?=
 =?us-ascii?Q?nmx0heGHDjB2cutk7VKT8FEZ7EwtXKLasCw9IQTe9BFQ/nay7dZGHUM2fNG9?=
 =?us-ascii?Q?58d3nnnChXDJ0LZQOE3ISLqNqjzEqacqESTzTtzm6nEh97YTvJlUMWZUmijy?=
 =?us-ascii?Q?otzLXpAfvcQSW5IT9UBaO3ILXo5jSI6bx9W9k8nAB0wEsLh6t0tQVgP2Fk2B?=
 =?us-ascii?Q?bnzUk4DlRPQurfX1Iw/k5l4XL7wWhYatRmRL1Vfb2DfB7m+RICT4kBigGWdN?=
 =?us-ascii?Q?sU+vRA0noqVexv8sUMWINIp9nduN9NPFPY5Zkad7DUljxf3oIbXR1+YeHe2U?=
 =?us-ascii?Q?cJrW3WiPjKmv63ZYEBGYH7cvcFcfen/2TgzdXF7SZPrThoNqF4M9r6JE2rse?=
 =?us-ascii?Q?wJoWXPo2R106NoK1qXwog2iLeV0BASVc6Si5aensKSPyyI41XItrNxIHSIHo?=
 =?us-ascii?Q?hiabdjOlJle0p59weIBB/sTYiQpj0Gq5psv8gbT/6r22aCgk4CvnWn5xXcTa?=
 =?us-ascii?Q?Qb1k3ym1prncQ8oadWlj9C3rYlYckLU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0891CED00D17844ADAF152CBD7D6BD7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9318e8-13d5-437f-872d-08da2b62f979
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2022 11:08:51.8470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9OKtiQt/RtHbiLYQf2YJ0B8+cnaCgaboxSA31Mfq38bHzRBUiDMIYmEyQIGavA7zW6T+2IidhG05nM2qEarRUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6862
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 04:23:27PM -0700, Colin Foster wrote:
> Commit 2f187bfa6f35 ("net: ethernet: ocelot: remove the need for num_stat=
s
> initializer") added a macro that patchwork warned it lacked parentheses
> around an argument. Correct this mistake.
>=20
> Fixes: 2f187bfa6f35 ("net: ethernet: ocelot: remove the need for num_stat=
s initializer")
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
