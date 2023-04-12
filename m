Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E16DF130
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 11:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjDLJzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 05:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjDLJzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 05:55:48 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCCB7D89
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 02:55:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HArbMQ1QsXJc2qswzZdZHxtbcNT4byi3+w5yw9+9BRTgG8UGgDvfD1w+blxj7i4/myIkXeeRaKhSRu4Q2tFkoA+9+6QzfeRjf5xEre228BhY/9zTfK0Xu2tI+cE4CBp07L/YfBa3AK/WnFE/CjS0n+2vyRRSaaWbbaZKnNBpI/ihbr4rkDCXDj9y5G2qPxTecStaGZrDC8wHKHCkblr5NgMXR4X6NeVAKgUgZEYCAWjjtbTXWKbKxDhDtOzvNCLrUywhtfGkfKdjSvH5vwO/3Enxgfc2zUiW+7GGHB/tLCKEcE/rs+HcEJ+VA4ItTXikLYwCiM4rxDA+HTeW9Ok08A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTkveD1Z9Bx4h4aptkkd+IsNIBYDe4yyiD8yhUrnaeY=;
 b=YayikZQ3KdFdlFJ9LOr5NPMNhRtrd9lrp5aGNTBbJrj3Jv9hqHbfmvCe+KGBQeWiUi7dk4skK8gp3h92C4Q6ZF7KzVb6XpqNmJTyR8119PfXUPQmhJg2jvrY1cJ8RkaBTd/vnYUFt2hAsqLn45UvUh6pqYJgefWuKq2UFUN2AuesMLR4GJ+x5GXmdescx9wTfG48QwJ9XRLcsw1CyynSw1BauO8xE/+7RifdN9LqjBX7ZD48gVb0R6zQH2/bBW++b6nmX/ORY8dff/+KZakVxoiBDPzzEcgEdm2NI2vKxT6jJfyI8X9ECafPoBOBB5Bd7j/ZufehvIdFbkoyOYMbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTkveD1Z9Bx4h4aptkkd+IsNIBYDe4yyiD8yhUrnaeY=;
 b=bImegXVRxuZCMo8gWIaI/NcDVNTbyghV/pIgIR1DKbv2TvBYdBOh2tGNbqLwH5WQ1WyAS121P4ptU1WttPRHFJcY9BU32ddEQkqnpdzbre2LX3jTxwKygCKey/7w6S/kehbDcrejCqVTckh0nhrSfLHlhVfpIu6AINYY5xwOFF4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB8662.eurprd04.prod.outlook.com (2603:10a6:10:2dd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 09:55:38 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 09:55:38 +0000
Date:   Wed, 12 Apr 2023 12:55:34 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <20230412095534.dh2iitmi3j5i74sv@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
 <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
X-ClientProxiedBy: FR3P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB8662:EE_
X-MS-Office365-Filtering-Correlation-Id: e92b774f-73e4-4cf5-fbcd-08db3b3c115f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghX22q+u8K446xEoHAvhRZ0w+YcBONWsUBEdJ6oIFs7pRZfkaZ5jbSvUzjGxCFzdzCZsQ2KEQFWDMe5hXHra0OSyJSciQDJqBCnFVLk6UzTw5DLWRD+GvvO3DhPypZ9tjZsOoFqZ3l+UcllmCuhGYTbeB/YTE+t3eD84LiSNA0F4vm/JzcfwF0GN8UNnZry27r7azR/G/oiiw77Ch4YBKWFyS54TnO7Yf5RbiSp+PAhe0DtPxxwfKR0zY/VDpDgCrnCQevAaR4dZvu16t3sdg832YbN9czJ40Ib04kpYzFcmNzwsqp9qh5IEOFUibLKdQU5kbdSvNfCfvz4aMmEEkMzQgU3cRYrsvSdKtSTGAWubPAKzkQ7HZ/TxTaaRz9yYL9wZnJpevZq9p8SXJvy32qi2Vp5u7fFlidWHF0FbM1Vj1E6191+qjkJvqbj+JeDQ3MlUUd7bgBgVYdZdXqtz/+Y+Dmu/A2l8W/7YPXZKCqT5yKvYH4ioEH3JlH/tKmn9w7x+6R+MBbSXIsBQ4kOqJzPqst47rowHPRbUH4+nrjqUKOPjdTUyC2vmO6N9fpu+FBLNNZtpEKO16cPePy25yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199021)(5660300002)(44832011)(966005)(6486002)(8936002)(6512007)(1076003)(6506007)(6666004)(9686003)(2906002)(26005)(186003)(33716001)(38100700002)(86362001)(478600001)(41300700001)(66946007)(66556008)(4326008)(66476007)(8676002)(110136005)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BWSRBP5i0OQbzThmtX+5aN3byQBBBKaCEvG1Th+cFDI86tfqhs+9c3bwkRl9?=
 =?us-ascii?Q?DncMb4gleF21vLqPv0DMj0FYl9CCkgKdwB/PtGA5D9ylWAV4c2HnZXhZK6BV?=
 =?us-ascii?Q?KibE2R0Kt1RVF1iwYpkWS+nKl0eRqtckZNsDHcgq7foZA6XHU+jLLrefu9lX?=
 =?us-ascii?Q?MmrJmiKdVoDyPgBkHHSV6/WPQtYWA1A6JU4wuJayZ3t9xNim3SOwt88s2l8v?=
 =?us-ascii?Q?ITXSm6m3WHVWGgHnIkSZNjwGm926w9xbP1rfqcsC/w+wV82Ixhme+Ror0QFw?=
 =?us-ascii?Q?2BcU9Lfk3k4qxedBwlSs8eq7E9MLLFJRCsVjT0S9B7xuLnKUzGyU6WqCsOh/?=
 =?us-ascii?Q?v0lyeK3llONlrX1UIQPatGXJrD4dGINYrhld7g2S547XNEDWzcwQMbwHRkjS?=
 =?us-ascii?Q?2waNGrITc/cp2yaK4aZ8pAU43VV9vh9L/H4w8YHnOJYkKIgpPpPgqokySWuF?=
 =?us-ascii?Q?sx29P61tpQuJ6MJie8V7PPn/k/fOYmpyau+j+GoQ9xvdjYGPnHFEQrM8Ly73?=
 =?us-ascii?Q?cwXQwwiY9IxL5zJbHe1yvaSP2jhSJHS9ZxBj1Vl0ug7WwJ/Ps5JxGlwwq7oE?=
 =?us-ascii?Q?63tPUeGSKZ1tABZAPzW0QeZLvJouVa59GSB/lZzI5HLWClBTCrfBjaWVhAKQ?=
 =?us-ascii?Q?1/epVgPlHlEH7Do+mTWBz4kdy7EzDmFT0b7MRniVdlpq9d5tbV9jKbirWWj3?=
 =?us-ascii?Q?RZGiTgiaEcxql5mydxYv4x4HhxciHo0TO7Aegpeml70pjlTNOrCG1wzAMsZ+?=
 =?us-ascii?Q?b1EQbzisqosrTcNOfTztqAqhd09EJxGMpg/3VgC3hsQgHJeeatDAILLwd366?=
 =?us-ascii?Q?rEfJV7uMyGpqzVvsIy6u++oa+zcsoQsHxlqSpkKtobjKe00z/sG2XQrCvcEy?=
 =?us-ascii?Q?pAo62PeCP84DhewZErbiNfm3Y2o+Zl/Muwbzhb1zcBXkx2jGe8eMsxAeVgGr?=
 =?us-ascii?Q?Rr6WDRdrc8xC1HG170f7OeQ7qmmpsA2e7poQbyAf6yzkV5rswBugOqbAryCb?=
 =?us-ascii?Q?sRRkjQW7ise00Yjtw6EiVRCq6wIx2nKx6JHn8csByaSVvr6oHVhYOVtiHTZF?=
 =?us-ascii?Q?U1kPMOUnIm7jQlPTgOzWZt1WonxUwLsIz+Dq1zmnwXDndf+TpJ2bCl6MqiIm?=
 =?us-ascii?Q?1+Uuffo4+q695AaGTEPNPr9lt9hFsg9Ufx1YT2HneJt7S3KVT6mX0HzDmYeE?=
 =?us-ascii?Q?/cNN5ckVY09JO1mt9IYio1vQ1d33SqOCgYMSSBt0BDR7nZ2RiWjgQt5XzE6d?=
 =?us-ascii?Q?RHU+LXpDVHZavoi77kvXIQwcSLaMsKE3p30uvwfQIJKJrXniKTOBfA1mgkV0?=
 =?us-ascii?Q?/g8WcEZ04QDrIbt09hE4XaggPQQ5byrr3dzvThZzP299Nv3HLiOQJPebZLOD?=
 =?us-ascii?Q?hAM2D33bd4huKQ/X0eOImvOALWFGBq1BbB78ff6lzH+m9cs+IFmHkj3a9lfJ?=
 =?us-ascii?Q?oWmn0kQKu7N1JGnY7t2UTyuPzEwUAn4HV8X4I55vk8c55ZFkuQkgVFsEwC4p?=
 =?us-ascii?Q?fYdHxTJD0RHq9vOg1BQsrU7jdMyei7AMofwxgf7dHy4SBuz3jABhmM8u53kR?=
 =?us-ascii?Q?BeM0snUbda4kz+jKZVSuVYDIZlYttCmUeOl78l6/eX0mvxeq4dagNZASeNVW?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92b774f-73e4-4cf5-fbcd-08db3b3c115f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 09:55:38.0060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gt6M9zE4urUk4pe4ZKMwgwFcFbYt86TTHlIDuoDAMAo8sfcsRjb2eGUVlQSiK46nyYSQuUuK0VI8Hs4wKJRZtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8662
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 02:48:35AM +0200, Andrew Lunn wrote:
> On Fri, Apr 07, 2023 at 05:14:49PM +0300, Vladimir Oltean wrote:
> > This series introduces the "dsa" trace event class, with the following
> > events:
> > 
> > $ trace-cmd list | grep dsa
> > dsa
> > dsa:dsa_fdb_add_hw
> > dsa:dsa_mdb_add_hw
> > dsa:dsa_fdb_del_hw
> > dsa:dsa_mdb_del_hw
> > dsa:dsa_fdb_add_bump
> > dsa:dsa_mdb_add_bump
> > dsa:dsa_fdb_del_drop
> > dsa:dsa_mdb_del_drop
> > dsa:dsa_fdb_del_not_found
> > dsa:dsa_mdb_del_not_found
> > dsa:dsa_lag_fdb_add_hw
> > dsa:dsa_lag_fdb_add_bump
> > dsa:dsa_lag_fdb_del_hw
> > dsa:dsa_lag_fdb_del_drop
> > dsa:dsa_lag_fdb_del_not_found
> > dsa:dsa_vlan_add_hw
> > dsa:dsa_vlan_del_hw
> > dsa:dsa_vlan_add_bump
> > dsa:dsa_vlan_del_drop
> > dsa:dsa_vlan_del_not_found
> > 
> > These are useful to debug refcounting issues on CPU and DSA ports, where
> > entries may remain lingering, or may be removed too soon, depending on
> > bugs in higher layers of the network stack.
> 
> Hi Vladimir
> 
> I don't know anything about trace points. Should you Cc: 
> 
> Steven Rostedt <rostedt@goodmis.org> (maintainer:TRACING)
> Masami Hiramatsu <mhiramat@kernel.org> (maintainer:TRACING)
> 
> to get some feedback from people who do?
> 
>    Andrew

I suppose I could.

Hi Steven, Masami, would you mind taking a look and letting me know
if the trace API was used reasonably? The patches were merged as:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=9538ebce88ffa074202d592d468521995cb1e714
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=02020bd70fa6abcb1c2a8525ce7c1500dd4f44a8
but I can make incremental changes if necessary.
