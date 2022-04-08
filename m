Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE884F9E15
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbiDHUQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiDHUQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:16:16 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D96377C8
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:14:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNGPHuSvRZc9h90Strcd1ZbVDHLzh9IersspDVGklZO/lAEm9JV+78VotEfh6BtxJ6dX7/k65Q2Vz9pKoJM5Bl+3ZD0eb0CybBBoyIzDo5ZZPJNdtAD/Jo6WfvXsXlPTX1Dm9SPdrwDEzidCZlho/bu4dShDCtvMh4J260U02IgbpauQI1qL4KPyL3m9GUPNj1+//BE6Mjcwj6qO71RIxAZQJK6us0pew39KDI6KvQc5L4FgLHqVY5qH6iF1OpM91FOHYbOGF1gBa1wI+wZsTl0J+gIfwNCD4HcJcQDeQgldoCsgI81alecmyt1iXQMxl9wqDskpVcj/TSOP6L+xaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfBjxrBg49GXo4n43IGGnRe8Xh+WWoE/Z3zIf8mGPRI=;
 b=OOa3ugQrb3sEobX05ZKHpx3BzYfqKsnCaNz8VOT4QnFP5/HM7eDOM6pQBcWIjOdVyILchXGF0o/WK7kXrwan24II4zpQ7azJgzyhiizHMnWe4hCj3AerpC1JWNqpa2gxGz+vUXqP3fZ3eEpW8oUFeTwWJArj4jetxhfworC/HQ9xFjKs0lleMUvhN/EKrLnqBtsH7o7gbnx4+zINRLV6LzBEOHuuYLQheiGCwnP3TC1jBQKZqGlkOC/IR/kiMgNRrcZApv7U2pATDiTO/bKRUWyyzVNLo8IF1DXRTorw2N17ilZxZLy4IrXIZ7YzpjXh1hXz6KfhvphV6aHRvwS0pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfBjxrBg49GXo4n43IGGnRe8Xh+WWoE/Z3zIf8mGPRI=;
 b=JG1bT34dfirqTPFEEMgDk9xTA52ByrB2GSq4WOTwTDGThzD+1rRuqADEt7SjwiIi5s418Js6qCFY9TxDiQ150/Aqg1/3wmh66gfGC7u2//JGABlpvjZv1xjAAkNQCtS69HHD10vyeZRlArA1eI3N+3jkexD7nT8nIhoOnyou1sA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4275.eurprd04.prod.outlook.com (2603:10a6:208:58::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 20:14:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 20:14:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Thread-Topic: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Thread-Index: AQHYS4PpJFoPHwGopUSskoKVo9n1g6zmc16A
Date:   Fri, 8 Apr 2022 20:14:08 +0000
Message-ID: <20220408201407.cl6juslapnwx73bo@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220408200337.718067-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a484bdc7-4cd4-4f10-cf02-08da199c56b0
x-ms-traffictypediagnostic: AM0PR04MB4275:EE_
x-microsoft-antispam-prvs: <AM0PR04MB427589C7C774FD7F8116D523E0E99@AM0PR04MB4275.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: THFF0OI0IZERx7jTZ/fvvCYhrBHwJkvsnn/FuDylCCJqeEy7yxTNS0+6WRgsCfujy6r5ZUz2vGbHovKx/fcKSmLcjyDTvqFaH/M972F0zcPkSB6xcClsylkqvaY7Vk1lcHZNKsZHXaBun/H5Rrgr5AAe6PuQJZfQEoe5K/agI3fsvrJgCgYvFitSRvj55VMmcYjYbMRLP7DGIR6X4b9GQwlqb+rrhD0tcCdxj7oFM4/DYTdM9ium5SWHM2LvxGZI+lY7uXe4yCr1rfSZ1H55OM+rzun9dX0h9zg1ZgaG/OkaVChOith5QjmFmQ650qJ+PFTtVxgaFh9ElTZ+9xPgzbG0iYigf1XFHI4ZJuoPfd9OpkBdtHKNUmHzj6LsNO9gilrCWxk3j1ABHTzM9rkzeVp9MkOFeUA1jBKCkgvJ4O5pua+QoSwPWfncF2KoRF1xJyCSdqWBVwuuBqk8BRoPSX6AwRrnQsZOnpAwsK4x0PlvgMKV7KQMzBcyuA779thVB2YXmHqq+2DACPoY0KLonsegPu6e7niecs80KY15j9Z843MY6ANtr6S3ro1hCQPUFusUTx5FFzLOc0GrbaHXXds3airULjmGih1NZKNdDYB6wLlwuxMUzb0sFE9/q7J+XTVAVn4EfsMWlmSGACamgNWoFnVhD+hXRm8RaVbS9ufEDxOhQxmtwW1fYvRFpV+uXic6CqlJMTsogHncykP6E3bKjzh9+zwbdXSBiKnTIkqmcrFhXggL+kJflJOSpt/MCt8Fa0posRstLLr/uv4GfAJ5p0K+ekI5UuBPjp3FGYc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8676002)(966005)(44832011)(54906003)(66446008)(64756008)(66476007)(66556008)(38070700005)(7416002)(33716001)(71200400001)(6916009)(5660300002)(86362001)(6486002)(508600001)(9686003)(4326008)(91956017)(38100700002)(6512007)(66946007)(6506007)(26005)(122000001)(76116006)(186003)(2906002)(1076003)(316002)(8936002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0dzgn/7jzDDLVeEDwcMFsO9gWthJxkh4ZRe2hJ/HHov+tKtioIvqyN1KtD0d?=
 =?us-ascii?Q?ft6KYXdXGaC8PyrMUl+jFR6I0A4N7tvbB1fR6jrJfg5OO5nCmqHQKHso8Hz4?=
 =?us-ascii?Q?pmAaclGHgYh+6m9ThSxHgx7BE6ydZaJfCxPGDlEO51wr1m6Mgm1LHkx2PscT?=
 =?us-ascii?Q?vkftpmQZhiOdTRiMN9LcvA/qU6X7wNt5G/Ybb+U9CgKwVB7KTHVxQA4RIhXN?=
 =?us-ascii?Q?Qz28VYbGG3TJe6wKqvEy2kKiMl2YGfNdLwSSn2VEMv9qp1WGI2utx4N1SC8U?=
 =?us-ascii?Q?+2ZL/xkkk/uCDVXvHPD85/aWwG571wlXONyoqL3PPRxKqxGxeyq0yi2h/Isi?=
 =?us-ascii?Q?vv4082xMkNnJnkLlcFLTxwPKk8Ldd/AKWmXBA3RKTdVj0vPcBKcibok0byIe?=
 =?us-ascii?Q?2LT0yIFSYVZyZSha2S0ulZHSSgp0re4Bhc2cdE+CmiQ+qWU2wt6Z8MHCHfc7?=
 =?us-ascii?Q?JBlW8z6Ql5odd05RGipL067aF47RH+5oXGId6nWQ7qHk5OUmRg+4GZK4et6n?=
 =?us-ascii?Q?u/P6tROhvbwN364xVwKPJiyIZSA962D62bxP9bAKI5lFG+bwNqmFxN/+hBft?=
 =?us-ascii?Q?r+Wt0h9OB/HtMv8bzjRlT7JeRT2tWtE0JQ0BGuK086BcmW6vh6M25O0kxnu3?=
 =?us-ascii?Q?Mw5SXZlkRnCul6c6K1Y/BOdijGU14JMwlImouJ7HR2Rq1pHB6AC7iJedqocI?=
 =?us-ascii?Q?fNcCG1H4GqhrwfRavoFFjvFCGVsYJ5O6pGaGEfwjru5EKkIgl4iUMKB/zS9u?=
 =?us-ascii?Q?YSdPLUmiZy6ojQMSucyFsuflq4c0PVf14IgtI+3g2cnK5XYPwCfMFtZsPGSl?=
 =?us-ascii?Q?7BcJ/aRyQirFO1Fvvthv6J7W/c22ge6Wkvcp7D/8A8SpQDiHtrRWN7Qa+F83?=
 =?us-ascii?Q?ZfYZPdQA6+SIjC79/WpCEtk7UuHpD+wiUKbao6XiNj3kBCWSMAyeKlRNi//+?=
 =?us-ascii?Q?Y9uzf05BSIc/AMdyh+ZLRuRr07jzh19MX9nIQ8x0EMSIaiN9EbVopaa1vs5w?=
 =?us-ascii?Q?o4cMFmvrFA/puaRGpR47c8cNZoXgU618UtFLUWIHnlwNVeoqy/EMX5HhIxLh?=
 =?us-ascii?Q?Fqed6KRkeIXImeIMy1PktG+XnlSXcaytTel07CvPAvnHpzAy+CC62MF1nW6W?=
 =?us-ascii?Q?cHx1cAUcMLWDKJB8Ky3VnFaxulMo0gcqVEK9IMxXj+k+HZjAb/LzrC/TprZQ?=
 =?us-ascii?Q?tO9q8iglLRgZEw7moyUwAAz2VWsUccYBXxHR1mHa0AwQBTB14zOoryiIjS6M?=
 =?us-ascii?Q?5lmpzY8h4mD/ZFoqAoaRKRdNbJ3oIthagSj7T8NzHw5dqW3b+x/uh/CGk6GR?=
 =?us-ascii?Q?bJBYnsvzMdDE+3nrkxhHr/Dv4aYPBrXzpDD22w1PhTd5ppL43BVKj9Ir36Ea?=
 =?us-ascii?Q?6KspVV4w5kPFfbjnLMSTb1kRPnkwM+HXqX/vRsV3Nj8sAstd516bKPrtac4L?=
 =?us-ascii?Q?dor0dEM64Y+DwUbIsVrUKkfVOiTaBxT2b0s0px6AXDeoXqSrBILkFIExMp+x?=
 =?us-ascii?Q?S+GmNMARsVjlSZy1KA4CVgLPuaBIMbrUgxUKj2exOvHKbMhIAoE4OxFbFWTA?=
 =?us-ascii?Q?wEqdYpgoF3thitPW2//4rmOOMWLpiGR3275+xJs0UNQ81KDQ+/6/rLZVi6V1?=
 =?us-ascii?Q?FyvEPRVv3LWYuXchxyvAPBf2K+s0q1g6Qlxub+MrjLiUL2lEqSgmy9EOQkNT?=
 =?us-ascii?Q?8s6/pZTIA14/AjvhUEntJPi4zAVJgMs6G6xpFjBl4aDQoWgpo6Gf7tTKmn6S?=
 =?us-ascii?Q?uUFTNiccui8RkiZmIi0qAoZhNGFIlU8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <98E090EA6831E64EA74416AD22BA73E9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a484bdc7-4cd4-4f10-cf02-08da199c56b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 20:14:08.5117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UOceA8lJ5sdw1qgp/lcfQqpR6Iv9ncF/oyZuoVNvZtCvWW+CfZhjkAmaeco15gM+yiYaM4qn1kuL7m5tDBnECA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 11:03:31PM +0300, Vladimir Oltean wrote:
> For this patch series to make more sense, it should be reviewed from the
> last patch to the first. Changes were made in the order that they were
> just to preserve patch-with-patch functionality.
>=20
> A little while ago, some DSA switch drivers gained support for
> IFF_UNICAST_FLT, a mechanism through which they are notified of the
> MAC addresses required for local standalone termination.
> A bit longer ago, DSA also gained support for offloading BR_FDB_LOCAL
> bridge FDB entries, which are the MAC addresses required for local
> termination when under a bridge.
>=20
> So we have come one step closer to removing the CPU from the list of
> destinations for packets with unknown MAC DA. What remains is to check
> whether any software L2 forwarding is enabled, and that is accomplished
> by monitoring the neighbor bridge ports that DSA switches have.
>=20
> With these changes, DSA drivers that fulfill the requirements for
> dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_filtering()
> will keep flooding towards the CPU disabled for as long as no port is
> promiscuous. The bridge won't attempt to make its ports promiscuous
> anymore either if said ports are offloaded by switchdev (this series
> changes that behavior). Instead, DSA will fall back by its own will to
> promiscuous mode on bridge ports when the bridge itself becomes
> promiscuous, or a foreign interface is detected under the same bridge.
>=20
> Vladimir Oltean (6):
>   net: refactor all NETDEV_CHANGE notifier calls to a single function
>   net: emit NETDEV_CHANGE for changes to IFF_PROMISC | IFF_ALLMULTI
>   net: dsa: walk through all changeupper notifier functions
>   net: dsa: track whether bridges have foreign interfaces in them
>   net: dsa: monitor changes to bridge promiscuity
>   net: bridge: avoid uselessly making offloaded ports promiscuous
>=20
>  include/net/dsa.h  |   4 +-
>  net/bridge/br_if.c |  63 +++++++++++--------
>  net/core/dev.c     |  34 +++++-----
>  net/dsa/dsa_priv.h |   2 +
>  net/dsa/port.c     |  12 ++++
>  net/dsa/slave.c    | 150 ++++++++++++++++++++++++++++++++++++++++++---
>  6 files changed, 215 insertions(+), 50 deletions(-)
>=20
> --=20
> 2.25.1
>

Hmm, Nikolay's address bounced back and I didn't notice the MAINTAINERS
change. Updated the CC list with his new address.

Nikolay, if you want to take a look the patches are here, I hope it's
fine if I don't resend:
https://patchwork.kernel.org/project/netdevbpf/cover/20220408200337.718067-=
1-vladimir.oltean@nxp.com/=
