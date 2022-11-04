Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BF56197E8
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiKDNcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbiKDNcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:32:51 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60054.outbound.protection.outlook.com [40.107.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F91D2E8
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 06:32:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIPhsNaDLmXngBPz5GFQe6SNIoL8w54wO2lrivJaw1GwgA5RgDasRPjs1t5OWxR++DqHpHpibLjB068FOh3KmMeWZc1Qd+lAfrkUNQV8HvAlgJQqEB5qm/F+ExXjqq+aQ4AECw+YqFh96JsmFUmvHrpJwJ0RDIjf3bCP3hvsQLzf17KkaQrtxrCD+QmbdIh/cEEoX3k0JNs2yE3uwVJ6V+O/rIRrp6DjQLXyRNiX/3OBKoTsy8EDFUN2WuuQlsAcE2mODkclrNif3sYtWhmw5ySJg5xYGupfrvDbAnNiZd6LOUZRZlVmGTrJUWqiFHerBdMU1+7uQEecGRMQCczYbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlWQKMOXA0Ng2uyQ0/Udf6Ncm4Wv34cv2K2WMppiU0U=;
 b=PQKEv51ynEufRm877ui9jiY3gpZaH2G/kyMsjVelX5AgZgCKPsSlD+1yCMbBW58wnNHh7lJryX597+gB59FPa8eh0RvQERVr2d8zlYxvWTNr1EJYDpOJFYZd3LHr/fab8/PtvfoSka8MJ3scGLw2SCrkVioSkzdRuaLAIcuPDGiiIFAtw13ZUpnJUx8bEMeXpSC2FUBkL22KdoJW2n5CAnXvQObypGzzB04d+J7EJn63YUacpXGvYE3BP2B5cFCPo2fl0bKsZNWkADFCQJ/3LREVECwHtowhgE92oYJiVF5357dxKiziDi77gXMDqo8pydWkdbE4LI0d62DJynDo4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlWQKMOXA0Ng2uyQ0/Udf6Ncm4Wv34cv2K2WMppiU0U=;
 b=WX0eK6cxbIHxm+8oDPPr6dpPcf5sPiCZA10czFur4ibLZM6X0d/isDrDHQY474xGFTr3PecAJATfHEN2zoMdFfpOonxQOUzjRTybAavRo2xz6gHdQg0nr/yk5PQiGn0XNZ9a1Uhb1Pu0koIR9A6VrjUCA8GREueWjRGv6H4qpIQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9073.eurprd04.prod.outlook.com (2603:10a6:102:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 13:32:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Fri, 4 Nov 2022
 13:32:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Topic: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Index: AQHY7efc5i1n/1Oz0kGxX/wEp9VJma4upEMAgAAC6ACAACDfgA==
Date:   Fri, 4 Nov 2022 13:32:48 +0000
Message-ID: <20221104133247.4cfzt4wcm6oei563@skbuf>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
 <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
In-Reply-To: <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB9073:EE_
x-ms-office365-filtering-correlation-id: 3b0d3c47-a81f-4f55-6e92-08dabe691050
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7USht48PPlqb63LsW+U42bggtb8NWs/O+pf3lWuw6WWdd2dnRs2mFSNJK4Rxg4DfgvsBQ1yyc/tNh65V9Lqd4FvkyQtqTqqdn6p4zY0bAAB1PRSLF4CGZzlK24IhpBJaRrjB3CaMjfzla89qJmw3YdM+xRtOS2V1xOciwzEP0or/eiPO81gd1MmhAm/RZNKthylKJMnVYapZMzFrbjktv7nIaZCE9LvpSj06Bm6l6NT5oQ2p5ePgMch+whkRqhxNjeG1RvFwJXvjPkGgxyY2WtnnQl+Vcuvov20+o7RTTE/Bgr1zrUoZRhUZZmUUv7LdiT5OMmeMHMbCxI0OL7tFnWL0IeqdJT+DATxEf4yx/aZawhRU1dCVpBLHpuZX94AMZwkc0pc9ttgHAUyo+VLvMdX/FiKnunoCymvaBBBZQ7BKiaZNuCMLUKg6kDUU69dEbkn7oVcFuaaUJv736gptpvNUPjC+D6XhcR7dy+OgrSEFl6TZHJyK8FSZ6+p+evc8iW90q2/eAvzvwXum82mBvr2LIqWIkU1xrlcfj8P4VMssWYz5w8Drl6VVB7QTMGOo16X8rkqq30UjZr4Ywnlgyv07/TGJbAib8d7u1/FUlD2yTlLF95ta5jBnzDo0ENoZ6XMb+wPo1nbA/UypCzw4gy4xVxlAJjgDiRSBPoWB/DgicEP+1802kOZNV+HrypJ8QL5V7jE6FQ/JWEPErPOIQLV2icsXuIsDT5gEupqs62217/8uHG/dbiIdRA1QPdVUSbkxvvi1HgJKeTl4Gc+2fl7g7BUpZcsL8piqmT77wPg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(66446008)(4326008)(38100700002)(66476007)(66556008)(64756008)(66946007)(91956017)(8676002)(44832011)(76116006)(122000001)(6512007)(5660300002)(86362001)(2906002)(7416002)(41300700001)(26005)(186003)(1076003)(83380400001)(8936002)(9686003)(478600001)(6506007)(966005)(6486002)(71200400001)(38070700005)(316002)(54906003)(6916009)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W0znw+6Ib+V3dE+y8ClT7GQjtnj5hJLGlMaSjAX/jf2uTtMKNzt6en2oa2sK?=
 =?us-ascii?Q?FNqKtoN1ZGn3LNA6H2B+fjPIp9lCAL2Nz0iNCKvGixWQt7XNqvmPEo5BQb2N?=
 =?us-ascii?Q?msdeIdovwlv4lDn3YXr9orh6n/4+Zt2f86JLCA3sLiwlkVmnsTY8xUzvepnX?=
 =?us-ascii?Q?ln9a9fEyk2Fc4ctfu8ijRDVaZlcGa6badIfavc4cvcQRGFYsHoHJox5avZXF?=
 =?us-ascii?Q?Zl6tfGzOhHfRUwujK60I5YgU+nefNi1CdMEem+Z7kT06Zj4kgTOQAZWD1PIF?=
 =?us-ascii?Q?BjDmIImtvtE0a8Gsln8qkHYMBYzmBiye7bk0iITOdfZ1Sa/3BW6g7NWzNRod?=
 =?us-ascii?Q?rI+9baz9bfPCQ6Xk5lFHUSGTx8C5PGbWVsmoZjmJcxEUkstjbmGl28VN2Sud?=
 =?us-ascii?Q?dP+bPj7LPyWNxlyZg3dEJ5XuSfVvCVpm0olrB/B1kT+JiFCqO81xScxK3H4+?=
 =?us-ascii?Q?b9OH+jkZ5iLw5++0eduRVIFr7zAA1aIqmkmeT0CFfRGbac8ozCfULB+qZ/sY?=
 =?us-ascii?Q?wufZ70nKXyNTGYYeX0t18uvggtK/IX595tUWOetu3b6q3KMQ5nJHCanWWytt?=
 =?us-ascii?Q?TszKBvs6wwP8w7YtruyzohB8FA4UcB81PuQlH8P4tQiPVD90n2PMzq23bW1G?=
 =?us-ascii?Q?plQZ7PAparlcA/Rh5zDwGZaO9FQguoJzSD17ZJgi7/t6yhllirzULA3YfPtx?=
 =?us-ascii?Q?B4MY5QZsQzISrLKHU0z+MMhs6qP5iIu/Y279D1MqQZjZfCO9Lyj87FThPme0?=
 =?us-ascii?Q?Zz2kDC7psq3PjHs6z4EWAThO1wLlHKGWoHzg7kvsAokAnl5qfTNXcaYQhv2J?=
 =?us-ascii?Q?Ok/+KUV5cVxy1c4mJKLk4yrFkB06ZceFxuecf+XE70F4zAlD0PjEtZ+8T+IW?=
 =?us-ascii?Q?V/KPD7YBa6KMO6SmNJtUgpyQ5y96wSoHWijiP7EpKST6xgVP+WwhoIpnYFjv?=
 =?us-ascii?Q?prMA11q5SeWFSUOQ362h432I4pXxYbOoGvAAwztS/Bzj6dl0jl+hKe79S4dv?=
 =?us-ascii?Q?dmGNzawzu6ad438NURmji/rmJ/hK6o5P8UfVSxAXxBh2qdMRrwVO+O/P0jow?=
 =?us-ascii?Q?cOaMDpGeBJt6u/aU3cy807oZaHnVMAfHb1s7lklIgqn47/Ngontqua47oI26?=
 =?us-ascii?Q?ArCxzwWnUNtYW3zYsyVzHGregDsXxHmX7EsLv4dPIXP9O6JuSWbgDudodkMz?=
 =?us-ascii?Q?JnjtTF+aIAW7Cf91ms4FTJ1rCSACZPSBGAZSsaMGbymrxk0GZhDHToRh1z+d?=
 =?us-ascii?Q?/+rncmxVQjbe+40wVy/bKNlEGb7giaZHloDMF0G07lJCl4ByWjZiuu3NHCy5?=
 =?us-ascii?Q?51Vr6JTGpWBkt51E7DVmmQX6ey2/UbkemN3iZQw73N7R7TzboOqd4hiKVaOL?=
 =?us-ascii?Q?oPWahs42DtzWmUfIG49O4wK9QmJyIzov+vk18NUSEbnLVZ2HY/OPMbQHEi1E?=
 =?us-ascii?Q?uVPoliIjqAu6PYR7rc5McspzI8QLbtykcheHNojJXFFdriu1lWLUVp20R6C+?=
 =?us-ascii?Q?57fODUkihBaosOliMSLLVy2YFYHcQb2Y5tEwllkaDYhYxuNYqA63PTSinIb9?=
 =?us-ascii?Q?UHZyy8sNUMtOnyuAGV6Vvaer+2GKabxHAQI6K1WuUZr2g0w9y5B6J0ZTmMei?=
 =?us-ascii?Q?TQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C430D0B415EF764EA4CCAC142A007ED0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0d3c47-a81f-4f55-6e92-08dabe691050
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 13:32:48.0584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nucDcFtKn2AcvG8T22dBkr47w5wyEFtAzIe1mdPJSSN+xQZ6SYI4/5LpDSaOA4iW7XTKpo5LygAUxyirV06vuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 11:35:08AM +0000, Russell King (Oracle) wrote:
> On Fri, Nov 04, 2022 at 11:24:44AM +0000, Russell King (Oracle) wrote:
> > There is one remaining issue that needs to be properly addressed,
> > which is the bcm_sf2 driver, which is basically buggy. The recent
> > kernel build bot reports reminded me of this.
> >=20
> > I've tried talking to Florian about it, and didn't make much progress,
> > so I'm carrying a patch in my tree which at least makes what is
> > provided to phylink correct.
> >=20
> > See
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=3Dnet-queue&id=
=3D63d77c1f9db167fd74994860a4a899df5c957aab
> > and all the FIXME comments in there.
> >=20
> > This driver really needs to be fixed before we kill DSA's
> > phylink_validate method (although doing so doesn't change anything
> > in mainline, but will remove my reminder that bcm_sf2 is still
> > technically broken.)
>=20
> Here's the corrected patch, along with a bit more commentry about the
> problems that I had kicking around in another commit.

The inconsistencies in the sf2 driver seem valid - I don't know why/if
the hardware doesn't support flow control on MoCA, internal ports and
(some but not all?!) RGMII modes. I hope Florian can make some clarificatio=
ns.

However, I don't exactly understand your choice of fixing this
inconsistency (by providing a phylink_validate method). Why don't you
simply set MAC_ASYM_PAUSE | MAC_SYM_PAUSE in config->mac_capabilities
from within bcm_sf2_sw_get_caps(), only if we know this is an xMII port
(and not for MoCA and internal PHYs)? Then, phylink_generic_validate()
would know to exclude the "pause" link modes, right?

In any case, it looks like coming up with a resolution for DSA's
phylink_validate is out of scope for this patch set, and that I should
just drop patch 4/4 for now and resend the first 3.=
