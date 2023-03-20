Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7AB6C1BE6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjCTQhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjCTQgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:36:42 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2043.outbound.protection.outlook.com [40.107.104.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76D83C1D;
        Mon, 20 Mar 2023 09:30:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJJvRbV2iz+sctviJ9lXz1N2Ap5LlgeNKs8btppMP8POs7DcgXRaTy2nBv7Y4XkbOx6gtb35Am+InDDeNLV2R2TJDGxQySU10Qn7v6NrpyDukaEZkCklEeV+SJNcHYG/wPoCwjP0MJ9ZJ93sILL4Z5sv/8m0q1FfYgI8Vpo9zfFPEHVKMUY0VVL+cigDeN4jn0zWt8/YibjH+SxxO9H/NDq3UO9DKvATxk8ohaXovSCpabohwvyy/D8jaokzNLKszCxX8ydyjNDM27062BkP9ix2LX3rHkihPlgAWBGruqaLIWC9EBV0QHMAYPfdfNcHse2L/Su4t4p05dkBlCPmfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlQhFVMXffkuktnRyxFLbV1lW+DqfW2E7VN3ZCaA+h4=;
 b=nfYgPbnzGfwjLIqUDTjoTI8HRcFwP1SoOtmSdDDwbtb5yvPTYmdldk7Os/VclDNHFVUBBt3SQvxLFBXPa8ZUxO1VAb0wHXnd19eewrrlHn9TbmwK4KQyuImx3s9SuC2j4/dZRFUWTKG13KjesuRa8/SICmMMuaojPlN4I9z7SBYdTLRHhcWVno+fiTAvEbAW9ZHQEy9D4YXM+Jal8Y74SfVDJ0GVSAHxIke4F9P2Wn2l6jQYApfhbOuhrT0YHDQMx3K6kCICyCTQe/gCm2KJBe+jpoCfrnzs9dN3fN2Lc/vuiQNjFMXt+adl78fTEX7GVCGgPhcrZEWfUyaKlZ283w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlQhFVMXffkuktnRyxFLbV1lW+DqfW2E7VN3ZCaA+h4=;
 b=o2zfyQ2Jt1hCqMQVXdSmL2sxoTz8ZjtRyx/g8q86Qr1Ej0HRLhX+ostNnVohjmpU4dmsd3lel9v1+UxtB5toxDyXG1m9FVbq9asCNMk899eBmhKLLOu/ZiJYAanyKNHMC8OwbQUFpvAIEoW2Aab/PGCTqyqW/yinSGb1U5ph1pc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8924.eurprd04.prod.outlook.com (2603:10a6:20b:40b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 16:30:42 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:30:42 +0000
Date:   Mon, 20 Mar 2023 18:30:28 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 11/11] net: enetc: add TX support for
 zero-copy XDP sockets
Message-ID: <20230320163028.vyjaye7vode2euxc@skbuf>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
 <20230206100837.451300-12-vladimir.oltean@nxp.com>
 <Y+PPzz4AHRxZgs9r@boxer>
 <20230208170815.nsq77mpkpf7aamhg@skbuf>
 <Y+PZQBWRqyNf9GlS@boxer>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+PZQBWRqyNf9GlS@boxer>
X-ClientProxiedBy: AM0PR01CA0173.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::42) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8924:EE_
X-MS-Office365-Filtering-Correlation-Id: c22f58ea-9d2f-49a9-614b-08db296072ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y1cGqvWXViGynTtFBuQrUsCwTfbE7BeRysGJxi5D+atKVLfD8T2wsQ4pjdFrkKsnXk0su2s4ECbjRgqbTFQ6xh7dm9viL59w8NcdbYNJTIEpGMJNQs7xDhJpMKO3Kiey49n6ozYtoy0AbcQMcaQzvqkUjEFornyp16ydg2jDK1iuxMRPaGVufmcBzOyOoSAX8liLz2sV/BUvZx/iHHN0Kx33lmRGKoy5mnmZRspJDpeniFG6gV98M+29FhTp1kwfKJtfz6XxG20WbcimfJXZRZx+eD+vgtICvfa/6GA4aMBex1VkM7cLQtNfGF7S8KsoZbCbzHfMExXbqRcnd1WweQyjnreCJ155ReBM0qXBRVW2M0wbVYb3qfjVsjdcCXVS2B/x4OO0yTUgHthtIDbKatU+/aQtxK/uR/F3pBFLWMWfM/GCI0KK9KZd728w4K+CwM3bf9ascwHmXseUe0jw5kvOJH5xelVf7y4OwjkcHIg12UGKOlHgbG3zoOD45MCAPnzkAv2+fD9BiINXVyq/XHeTdqVZeSXIrt9U5VxUe2JqSH0fytMJZgwIMH8/i7aDzXoSwprIyzLBI/KCmEar6zsiVSch0wTqyDGNLtIOk++LDQj38AbTqyFCWlnBnZom
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199018)(86362001)(6506007)(66556008)(4744005)(44832011)(41300700001)(8936002)(7416002)(5660300002)(2906002)(4326008)(66946007)(6916009)(66476007)(8676002)(54906003)(478600001)(316002)(38100700002)(33716001)(1076003)(6666004)(6512007)(9686003)(26005)(6486002)(186003)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r5Dcx02gBifw0498wxFuGIue6aL9PnNUiAYdmJ+O8ZC/zRLXQZUvEilQxIXl?=
 =?us-ascii?Q?bRzYyr/trM0BF0fN2iOt/brtC6H2gP12kvus98YIVA0JncOoNGcg+LIHHVQ6?=
 =?us-ascii?Q?5QnH+3fFZCLDWxgwhTxwCZiGf+FJdGXeHIGT0Pf+oYmJLuaC1l8Iwu0T7TSK?=
 =?us-ascii?Q?92dmsa6F7LtQ+ZF6OT7lA6v3w5i8AFL1d9DTF2zUojupXSS36HV79skeIUTV?=
 =?us-ascii?Q?BWoHUWgvTsFXp+SA03X0eTjdbe2k9VPEVDrXFt0bSMTHbRLj3fGCU7dF0BMC?=
 =?us-ascii?Q?6gTAHbN09LGqep64e8obvqZvysu046uLKef7IKtU6asgCF1HE/aC8cYDGTHH?=
 =?us-ascii?Q?KMnt+J1rdY3P7B3Spbm12e8XS+DNGo6vcLV0JOYM7b/FrIMMbvxtm5xgby8/?=
 =?us-ascii?Q?NlWVTw0pw4d5E9rAyfYgUJmZs0Ee1VKICNYHVviAaXN0bwo/hqDxtGM0uK1I?=
 =?us-ascii?Q?1lWaGINuGSbV7SupAj8/NP6xu5FUaYTNxqQ+8ULCWZoa2HoXZUfgwNZQd0O9?=
 =?us-ascii?Q?DgiFsuApuyt4u0xBVHU17Mr/NSG96Gds4ybwT77rNQ9KQPrRNV0ez3utHQU7?=
 =?us-ascii?Q?J1kzQE96IryWKjmcsMLfBMCiLTY6aAgGeMmQNQLME9NHOcfqPZKIu4W8R454?=
 =?us-ascii?Q?HXTY7TmBV8tP13HKhCXO4iiVw1gxkyMeXqfM+1ej8faRZu9B5aq9kvD0+Hbr?=
 =?us-ascii?Q?c44QZsFdYXmtpQPXbyQxnNO696CFH1Ry3oA3Jzrszhan8uoWGidC4vH/nbby?=
 =?us-ascii?Q?+z9J8eMCkwJsXE7YxHXX/UeXSqq1xehmiQ6V49lLbigzxxm880r7hfE5j/lj?=
 =?us-ascii?Q?X6uLoYmJYYq0PrvKOx0ci3VVbDa98EIthKZmFiFq0fIdnGjnE6MNS1f6JMBx?=
 =?us-ascii?Q?9K6ihJgjsbvcACUD38cvy18mbBWzA/BpF0LfD0b9OvMyoDy03sQSHvnudLax?=
 =?us-ascii?Q?Bt0YR87o1iThUBMm8bSJRRL0blsYX8Iizf9xYL8jkYxeJcj2LknhLD0ci3Zh?=
 =?us-ascii?Q?lsz3gZydGzaly8bhsYJOY7F1JPhSGel6y9FXT79y4hUJxg2sgv3loiW5GLL8?=
 =?us-ascii?Q?LXpogO6+Xya2hbNXnARZvmqXFCijW5bWctmHNeTcgLCsDV5JiCnv8QwOxanW?=
 =?us-ascii?Q?u5JV5HI/eMrftDVqOO1SHcbLT8Z67od6Mkp2xszTvjRWi1nyynrJpPBn1EM7?=
 =?us-ascii?Q?H1FDA0ZVSxkBTILoQVx/BnD6d6Bi4UQYHk3VXpZLUIbSh4WGb63cOcP1eFER?=
 =?us-ascii?Q?KgpGv+U1VUDijvj+g4H8S5x3O7FVvREJOqMPE9ott11oSKCyDaUfjIootcNO?=
 =?us-ascii?Q?upQYVtKd5ljQnYQMINQG3L1LFFhay3XM8cDwDhfNhCCxOr9UoxYQ8D1D9xsO?=
 =?us-ascii?Q?l4HRyMxpATqBQzxmmE+E00j0P4t/LO88Cir2l4G4hQtziRZxXp/ljob8eYZ+?=
 =?us-ascii?Q?OC/wRCxIJx9ljjXhhoqoH/8gjSMkfQUiLslNNu//B7/TiGNe6aekSEGZRvP+?=
 =?us-ascii?Q?Ub1u/szVkzm9OoQhlFafju+QKA26XMl2WAji/UJ5AAM+sF7ClTOcmZVR5Sjn?=
 =?us-ascii?Q?i2KlwbWUZRiMOrH2vdkRnJRJqXpNc+vL9WxfJGDMxq0yJ9AQMIWwBvsoliAm?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22f58ea-9d2f-49a9-614b-08db296072ad
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:30:42.2496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bL7KgLlb/wgjRDcJ/WyXFEd+RSyUyb04+By7RCJd10FcFypNDctrvtuNCA+AE0p2M0pbvwQ3X/zE5Obvj5yEpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8924
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

On Wed, Feb 08, 2023 at 06:17:52PM +0100, Maciej Fijalkowski wrote:
> Ok i was referring to the thing that using cpu id on both sides would
> address concurrency. Regarding your need, what i did for ice was that i
> assign xdp_ring to the rx_ring and within ndo_xsk_wakeup() i pick the
> rx_ring based on queue_id that comes as an arg:
> 
> https://lore.kernel.org/bpf/20220822163257.2382487-3-anthony.l.nguyen@intel.com/

I looked at your response a few times in the past month, and I'm sorry
to say, but I don't have enough background in the ice driver to really
understand what you're saying and how that helps in the given situation.
If you could rephrase or explain some more, that would be great.
