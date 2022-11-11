Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D06626521
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 00:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbiKKXDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 18:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiKKXDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 18:03:42 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150058.outbound.protection.outlook.com [40.107.15.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B64812D18
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 15:03:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cy3Q8tjTMmBL6NU2O/nxMTVTf0C8bTONlQZQHgDSQ07tAV7WPJ+zXbQuF6YSLwEqdNtiyZ0lj36Gg58tW6ByJsvLjsHNIqHnBn36XKzjYFOg8E05A1XjBnTlzBfDQs16NZsJsSFkfTU63gyjTW50OPat0oTJYgD9K67mMO07IvmrEnK9sZDrmFZK4bsMlohKEFRdqzPFOrBeh/Bgk/jF81SDcIg9gowi/SnHdrn8E1kQs1ZXiRABBxCZNNLzXKXFL3T+17ztU3Sf0GugIVp95UK8/eybzP+RmM9mIzGTm312Ddd37OohZWsqCQ1gHn6PqdWl2G896vKnKzaH4xLhng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0k9bZ2zWqBu1yNRcmL0KhgCxot766ROi+DDbrR4r9QI=;
 b=HP9fQ6iEKtmpNu3GX+5oxcLiLYnEyK9wimIsdraHMImpcq9oaRm46NZolXIkXO2534A66vgBO6y6dHF4IM7ZYpDf5lWxW3/6OPX+cCKpWXB1X6k7fsqGPy7zePQDbHcB6Cy7RaesnvfP/RU7163pP1VQPMDdl83JhsXLt9fB2yqvAS2sABLrOCmOi7iX+WpkHZdn9yWQecxQmOYBiMa/+MG+btaN1tkP7R9/OMLMDUvNaM7WwPYF4lSei+dv5WO3oV7OwqSvr+YYsjV7tR9ec5tcMQMnTN4Kza4+MsMfL4rBjdbJETsS5qhJWtZDMQxtQatbgzMbOqZl2Q2on0lP5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0k9bZ2zWqBu1yNRcmL0KhgCxot766ROi+DDbrR4r9QI=;
 b=WoJO2eLPPb2R8ukzZJa+TotTeGHMajQBZL06kna7Zcyei4xA/ZDrE5B19VITKeXzpZ5QoOK3eLWbd+4R9joG8SLRaSGZc/TxBQKvlVgt24+nipnsDznDw/l0GIMrDR28uya75eJQ9qUvTw3jGiDBwwenIJg6LcA6cXmMunmUZkc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8579.eurprd04.prod.outlook.com (2603:10a6:20b:426::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 23:03:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 23:03:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
Thread-Topic: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
Thread-Index: AQHY6khKXSRkT65VOUC0q3byqGpP9a4jh7AAgAADEwCAA+wVgIAS9XqAgAAALACAAAKagA==
Date:   Fri, 11 Nov 2022 23:03:38 +0000
Message-ID: <20221111230337.7ctkuwmlerdntbnu@skbuf>
References: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
 <2bad372ce42a06254c7767fd658d2a66@walle.cc>
 <20221028092840.bprd37sn6nxwvzww@skbuf> <Y17rEVzO2w1RslrV@lunn.ch>
 <20221111225341.2supj4ejtfohignw@skbuf>
 <bcb368ce-6a16-ac9d-f2fa-b86b0d4c8ca4@gmail.com>
In-Reply-To: <bcb368ce-6a16-ac9d-f2fa-b86b0d4c8ca4@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8579:EE_
x-ms-office365-filtering-correlation-id: 8dc2edab-b5f9-4c17-1a9f-08dac438f7f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QPe5BroFAmu9cgkPZe2gsMWASqP8B415iyUfiWl9oGVuC0CPmG8lc1T+SwPwLWCCa2+vwlI3V2C2yjdVkZbed0fQiKWP12Z2rEzu8AWJhuiFg20inXetUEaU0r2GBZs15VLpZzl/pjlAUVX3v+VTrQvnvDX9oAZ4p99WCKbA7NSdPu1rRPn5YlJaRhVkJGumvLSAOHHsKwwE19pn12GIvgwa/eXr6cU+raTo3qJjsi/hRjrQrVqMOJq08+wdBn5oxhl+dS0e0Nn6tD6dNzEqVrVPmkL745jNArOGlB6hym8pge+7LNBq/oX47illgwpsgQwMjcEKGcLBXFkbXcxkXRPfAGs+lsbUbiZz0hYp1jp15oonqIzoNrEb56jvB/DekQPaF6vYpe2/hKlSSb9cVdUpTJ88G7j9t1gLFWYJsWFWcoCnYj+fQ/C5n0RSJWVPhXioVgJwqj5U8Rodm34BuJAITSvhFL7UOEOrGN+Rxpk6nlAsnWyOPUpsnWAx+vzTpsVWf0KMtNHzCanUMOf2GhZDc/v7b4b7IAmtQnYtaRVqnprr3EZGKl0Z7VTY8OFfHKdJvr89zOvdiF+8ReZ0fJdfW+w/QVQp4+qlDm8H2c25gIc2T0XG0e//te+fXHSfkgCX8E8fKqUjVQ/y4fJ3NTg+pU+QjWM7BPUBzWnPcCvbeC4xN3Sob3fM9QD72OqpbLfwM3A9oBa9yuYFamNfdxls44ipYy2u4vRNgX5Lm2XKuv/iQ+caQKJ5c2RoWTrguFNehW8wVKpg3m/GpxKe2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199015)(76116006)(44832011)(122000001)(2906002)(6486002)(1076003)(186003)(86362001)(38070700005)(4744005)(53546011)(4326008)(66946007)(66446008)(6512007)(66476007)(71200400001)(8676002)(316002)(54906003)(38100700002)(6506007)(26005)(66556008)(64756008)(6916009)(33716001)(41300700001)(9686003)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UIR+JG8IqsUGu35euVmFJlV8ttbltSgudoznCC84S5FjCAY9ZboByrD+IGEE?=
 =?us-ascii?Q?lEtGrT+qV3QjpTQGSgrLmVlUY/egGSlo2sxeipehArBsdHtwlWGOY70UpYtO?=
 =?us-ascii?Q?893uNuNs58CnSHD5pP7ROvzkk0NtFeaqZYPn1mhqr9kyP+TaIYvkKQK9w8mq?=
 =?us-ascii?Q?lf0uVpcaHqyeIArSdfpiXwJCu8ynG877VVRBMIEhWicEZ1vAEtCtw240Qwic?=
 =?us-ascii?Q?4/0jJ+GRrDVcSJvvQ8H1+gOWHVbIYAVkMsw4vwAleaKT9A6wg8H+rE+7VXsR?=
 =?us-ascii?Q?BaZJ/OLCpKCXijEYeRzkS7ynQC90W3hCNbEm/UulH384GF+gy3MOLCxGQ4AW?=
 =?us-ascii?Q?1XhTXfyd889/jAGirPzgOBLxhfS/6NdYRWN635MozidyiVMjIJY3KiedLsoP?=
 =?us-ascii?Q?/86JXaz1XH12eTyv3UIYYJhXfFp9L/X8ElXhTzkuodQSlfOdiPq52cH1t9T0?=
 =?us-ascii?Q?ENnWoeI4XsNBJYqFrOFT9/gQKu4qah1MeKgRFodZx+JgmpFiwLwcTqur9BRF?=
 =?us-ascii?Q?LUqFJSSQZ7n7//oeVNeZVun2YVJi+5M9rmHAjNSK3YHw1u6o0KQ0eCi0baRX?=
 =?us-ascii?Q?GQ/1DhMiefkGY3VdwRSQYIvPd/u1KPkh4F8o3dArkGV+uS4gQJ3Xi6V4b5uJ?=
 =?us-ascii?Q?iNAqMH1r02sZf+32NBA9UPgaw+yh8W9zAVkbBEUVYQ0D5x/7kHQQy17DTt4s?=
 =?us-ascii?Q?d9AAa4W36Nt5hVRlDGW8YVKKNHlMjwiLeVwbtMMw+CLbVWh9piJsus7cwVdh?=
 =?us-ascii?Q?6gYBf7WFubCICsQFzy1hyfGACqzUfw1VJNljcuRWqkVOqjw7LPsXA8QCiy/W?=
 =?us-ascii?Q?vv8T2bvtEaSYkJ/y0JONwT1VMMjtdy+MseOeRcKeB71VqooCRBcuktfE5+RE?=
 =?us-ascii?Q?xRx4h0CVpv+EwYbDQxMGad/6Pb+T/scmqoxOTbCScSsKT5m6IgWFsce4Fsgl?=
 =?us-ascii?Q?RrjWlct+0LR0g37N7DfawoNTZeuHC2YnnQ6Vi9gsG6LHa8c3Ais5FMAZZieb?=
 =?us-ascii?Q?mb1UNWLKJLHWJnVPRnq4B/S4rOuG50B+uQ2aN7GdwxiXEppLw3B5bm5Ey0th?=
 =?us-ascii?Q?zS9YGyG9Pd0vByFvQl1wXo721RlX8GA/PZGBwl9REVkTU+IMuaEwrrg2rZUw?=
 =?us-ascii?Q?eJET7pNTCHPAsxBdtHO/rD3ruzDluVCV3wlmi9ffk7SOqOtsrPx0fVbPjWy9?=
 =?us-ascii?Q?FG+at+6fjaIQfHqrfTkp58idmdx4dbqKkVdL4OSJ1DYWTamfARqTC0/DyutK?=
 =?us-ascii?Q?HSsx7w56s+VcjCfT4nXVnnBiWQjmmDX10bnmOYAv+ZxbXrkTfTMzebrH0aLP?=
 =?us-ascii?Q?wN4Sps6Qpz/nh6fvai0SK/Y9rsOT9YvCFu6PIgEMwS/84uVzLU9qUT07JdRQ?=
 =?us-ascii?Q?nLH7PrBSf55ThYm1EUUPmfr3zXET+ZjmfRJCrWniUjCiWNXcT6ej0f7Lfvoo?=
 =?us-ascii?Q?elfLDd9ftR9Fm02oSoq3XDGuZkmrff8uYk5Z/ayedq/EvFNOjE8TDu6paIOq?=
 =?us-ascii?Q?wpxUWfv5SdhbF/sqtXQPxsMFC12Peg0Xs5lrPyuBOS77kbLKGsoDi8V60FrJ?=
 =?us-ascii?Q?wzVT3swkV9GxT8gB7/Ne0SmKEUm1InbGDedx547m+JKJCc8/sA0OrlRMe/T3?=
 =?us-ascii?Q?gA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <44CBC3322CFBA2498FBEFEE3C651E3B5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc2edab-b5f9-4c17-1a9f-08dac438f7f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 23:03:38.3503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GjteT1NJTtUGWn+MEHVfYCIx5KJt+xmEr1AuryjsnTJtRXFdLiZG28tfcoLUVJX/Q7dL9DOZ8pKMlUo3i3YjIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 02:54:18PM -0800, Florian Fainelli wrote:
> On 11/11/22 14:53, Vladimir Oltean wrote:
> > On Sun, Oct 30, 2022 at 10:22:25PM +0100, Andrew Lunn wrote:
> > > On Fri, Oct 28, 2022 at 09:28:41AM +0000, Vladimir Oltean wrote:
> > > > On Fri, Oct 28, 2022 at 11:17:40AM +0200, Michael Walle wrote:
> > > > > Presuming that backwards compatibility is not an issue, maybe:
> > > > > dsa_tag-id-20
> > >=20
> > > I don't think they are meant to be human readable.
> > >=20
> > > I do however wounder if they should be dsa_tag:ocelot-8021q,
> > > dsa_tag:20 ?
> >=20
> > dsa_tag:20 or dsa_tag:id-20?
>=20
> The latter IMHO would be more explicit.

Okay, thanks.=
