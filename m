Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB9564722C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiLHOtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLHOtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:49:13 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2053.outbound.protection.outlook.com [40.107.8.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4109A9E451
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 06:49:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jq6R6B8yOuGpwMuFkUm0eswdrmtdhr2hwveeiu9l41opkBB+1f2me8/YzFu3hmeHfYnI1jXwOuXxqMZhE0DwLhxL00Ygeo15rE/PQhGjD1MrGEcMNC/xKM4V3Yq//xJsKzcUbIlvN3jOMviUD/LIxDhPH8++LQP+kx/LstQFeVqVQHflhFHQqU285bcCBlptCx+phGw5anXbmbICyKNs2BgAOtV98AjxzWARjsJAxznCN6byrdrxVuBCFit04i98FgqjjOcWcRRa98lvN3NhLOtosEBvpqpMyXEYlU3mIq4y3UC0OifoNUL5MSAhcIi5td+jTKlV9xoKBguIiiTgQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTUT4AIgtEaxI3i6ofw0LfGwBeBwqPjwJmD9C4X3IT0=;
 b=Liww5iF9QaHk1jUKeoWLVrNes7TyZMEz4wgp3FDj5cyDN3sbxLZCPL8gPAUvr/lMaw7CDN0t7u+BuxSEdGUzMeryw5o7ge7eeQx4oPrfJ6NsPfncX9clySRabbxbWzi+g5sESNKawxbl+7oTJv3M7j6sXOepflXmI+hPaPIbK8CgyJxPgnZoaE5uFQrX/TCRP9wK38+PxwDMt6xIn7RIp0IN7kv6VExOwityPoRhdbbcEBZrVFINVDN2p3g8QJkzv45zVd9gVbJrI+NCWrd9GN/0czKdK6kOLMmI9k4HXFM9C5PW/KvJWxmrU/lddOcMlQ5X6tb+tVgF2d/3KkB9OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTUT4AIgtEaxI3i6ofw0LfGwBeBwqPjwJmD9C4X3IT0=;
 b=Ml0ALotUHi40EQARAfvEYn5Z/arv3oeOH5syTVaM2P6ENb81C5ghN9EdetK2mkeHOqTu4KQSZ9VpBWhs/5yw0rvbZUaqBzUb89eGjpBdFrF6djicCBu6y0OkEwMmJ5qu4dOD0NxxzVeUyzF0+DfuKFzojAzayY5WTZhTlsgPkdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7927.eurprd04.prod.outlook.com (2603:10a6:20b:2ad::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Thu, 8 Dec
 2022 14:49:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 14:49:05 +0000
Date:   Thu, 8 Dec 2022 16:49:01 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: replace ATU violation
 prints with trace points
Message-ID: <20221208144901.tgdhp73n7g5uh7qj@skbuf>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
 <20221207233954.3619276-3-vladimir.oltean@nxp.com>
 <Y5EsWNfVQrl8Nb71@x130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5EsWNfVQrl8Nb71@x130>
X-ClientProxiedBy: BE1P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7927:EE_
X-MS-Office365-Filtering-Correlation-Id: 525c2c1d-0a79-4f81-426e-08dad92b5a54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qgaSTTngns5rqgexPzoWfKAbP2Eiua5Khj/YyctvoA8DZURifwdlrS7PmzPfJw+jDEdVYTLpfuiMpBAysqbJtNzCADYn/G+SII24bHxtB5d7p5t/85JxnpLIQ7K9WCyXxO/3Uwz5x6sMldwm16VDkICwsXsJt6ZYzONX45WZwGwb3fv7IZzRbpVBjjFyNhV2GhQ3Ogf47JVWD22KBbUwe7yTvnFSK20RO1/DuxOPBPLtBIl2DlwGlWGltwSCY9o2JeJy7lNHhsrYtHV6Z+pdo06tNh9C8yLi2GEytI9Go+6yK3yD/t5czUwm87DKuUKaIj5wU47QeLKdHWILwvMI9PEhcazzllRfgzvUs3yffSjAmaGCKZFvzVGiVGGI5P+F45+TdoW22jQKEQCpc5rxopDZhm3BuT7J/zYMVcMcFwWiCBhAKkKUN86cDLJQRbN6fiPgIkNSoy99mVpkV+HTzKp1HTIQwidn8HcbMJRXn8V3wSS4Gwz/t3l4be550CMrFoPeUWJurTvK54Wk1s2b9R5kIjPKpsfAxDPt/vqpnaqK+rRLwtt1GKd0qtOJwUfMpMpp5BkbKk/UdGMyttRazCWz+GY+tXVN9mqdOtmPprKz7ZmUiWYBDci+3nhOZEHwYHiaZDJy59fm4zUkW6dElw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199015)(38100700002)(6916009)(8936002)(86362001)(4326008)(44832011)(4744005)(2906002)(5660300002)(83380400001)(66476007)(316002)(66946007)(6486002)(478600001)(66556008)(41300700001)(8676002)(1076003)(33716001)(54906003)(186003)(6666004)(26005)(9686003)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D/lCKVSwe0seqNP+Vf7LxJ/s3hYlaO2YvcqHE2jGnalPX/gFOYOLxqHPZMjq?=
 =?us-ascii?Q?xttGcbEycguBlJzbw9tTarRlmtX5ZmMRaKbRt4smhHQgWLQ0jpX1HGWS6bTk?=
 =?us-ascii?Q?HNWwRkFNY+gUfghb4HMiJd4X7F35Eon3Ge5r/VHqVEh/iueH7OIL9KDJxcjX?=
 =?us-ascii?Q?xdP1ec777j2IZTQECQTYGpG4wBOPE8SAXYa1tZerFc+Dj5NqgqdW+hSse2Ay?=
 =?us-ascii?Q?b9o/nD6f8MdeC5mdB6BZ0lNOCQGunEa49hdxhN7Pmsg7ImFaLqW3mAinazQ/?=
 =?us-ascii?Q?whcJIw+YNb+eelkrRqaHhy9YS/oBcexdrdxAy63+IlSetxAQOQV9N10yCtXp?=
 =?us-ascii?Q?eXrmUjb/mp64DFIwFyKcyO1YKqRH+Yt7bvrqZ9bfunERyIPynMjNdEXg2lrg?=
 =?us-ascii?Q?ZS87HUb3OhGNz+RJ5gnaLocnrXAF4Y7eUZuYTM467fcr+srA2Uy/TaEnPvgj?=
 =?us-ascii?Q?MgiNXaFW9R3wq+mtdh69GKEenyT7yYJAp47kBR98kWhy68UODkiONitk/3pF?=
 =?us-ascii?Q?gwcgJy/aS8CJFyB2to+v2rZ1DNJQ4N/ynLtswCqd5eD2JTqfJt/B5bvpai02?=
 =?us-ascii?Q?XN1msO4kCpUOS1HxsDU+o713xpX/3/fq0raDzbS/NPpy0V0+g2R2kwrcoT02?=
 =?us-ascii?Q?KOQBIWdWvf4RDFGePvtvV2I1cJ1NwWLB8oS2oNg6n7SJCF/qCa3OrGrFXpkx?=
 =?us-ascii?Q?jv0oe4LpJqmyVWrU4MwYiFzJ13bME8ASeFZhGEsayX2HuP0UHH6UmN2/5zti?=
 =?us-ascii?Q?HZqqhVKbRTSV0YaxYrkMe0uiPA4lB0GAewUHhtliY+vjrePeFQip3E8Bzwwl?=
 =?us-ascii?Q?UAXglhtadjdCkDpqaH27QcGBtJwhSGrTApnZ85n0WHhf5a5nb4e5pcYBFNF3?=
 =?us-ascii?Q?ie3Asvi6hGtnwCzinFkqPUnflFWjaFhKkTUfgVrTGdEMlXe50O1XkrHW9JiU?=
 =?us-ascii?Q?9yD93JHNQvz6bpwkNPXfjZamPocrAUVnbU3NcBqEaA56r9Qacnp+nU421S7Y?=
 =?us-ascii?Q?AnSYNz6Ha0JuqOOucXdPZVS0zBkKSs1JEvmsp/uIFaPlawD/TxAfJScd4CNT?=
 =?us-ascii?Q?5l/7kycYu1iwPchlXVhNlix08ezW3ZjFyqxvoNbmRYjJyyIsDFB4njPScSka?=
 =?us-ascii?Q?wP3igipcaEOnrJK7M7BhbS1urcSkpEVLXqsfZuGdsAAC9QFlm3gwHnHe3Wkd?=
 =?us-ascii?Q?k0MJsWCiXXv9oFlHoALVf+yCLPEaY0Hc/+VlKlQHURqBz7XMuK0E4wwDA1fN?=
 =?us-ascii?Q?UlOORDIANokM/gHRsqI9AQtYYsXfUjAJvX1/GUM0zOW/ev296exTUaq50C1X?=
 =?us-ascii?Q?QCNf9W1iuCQAxAjafcnBmBzuVEeO9GUtzNjZCXjUxevBy6P8leaXldXFHIAK?=
 =?us-ascii?Q?vj2EhYiyXo+tFcuONYjHO5p2bj6x+HXE2NHwk24nO0SWIdLtSmtom25lWNJO?=
 =?us-ascii?Q?vIUp1BX64zbYu8zns5GFGUSCGWlbfEleQIsq+jFKezOZGALis4Z5yamT4uHJ?=
 =?us-ascii?Q?fR7IZaWC4UBEuiGY/u1PF9Ffwy/akCqAz0/0AfmHJYNS6bLjr2g/BvultfkD?=
 =?us-ascii?Q?twuN6pSh7T94ExrEtxXzvc+WGzkPYlut3wNfAs71GcY47nriHIvm6TvMo4lY?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525c2c1d-0a79-4f81-426e-08dad92b5a54
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 14:49:05.7700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6X3YkQlLiK2hnlP2fBmmvvR2SO9wd0lO4CoebKpWZZZrOaZ2xTS7di6dKxYMhRZqqTii54Nb9/LJECpkE3Zfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7927
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 04:14:16PM -0800, Saeed Mahameed wrote:
> > 	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
> > -		dev_err_ratelimited(chip->dev,
> > -				    "ATU age out violation for %pM fid %u\n",
> > -				    entry.mac, fid);
> > +		trace_mv88e6xxx_atu_age_out_violation(chip->dev, spid,
> > +						      entry.mac, fid);
> 
> no stats here? tracepoints are disabled by default and this event will go
> unnoticed, users usually monitor light weight indicators such as stats, then
> turn on tracepoints to see what's actually happening..

I believe that the ATU age out violation handler is dead code currently.
The driver does not enable the MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT bit
(interrupt on age out).

I just converted the existing debugging prints to trace points. Open to
more suggestions, but I believe that if I introduce a counter, it would
always return 0.
