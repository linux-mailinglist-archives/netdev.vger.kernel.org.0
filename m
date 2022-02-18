Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376664BC040
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 20:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiBRT14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 14:27:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237057AbiBRT1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 14:27:55 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80053.outbound.protection.outlook.com [40.107.8.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4773586D
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 11:27:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npaIife9252e78+64fcqfffyoZZX16cqc2tcu9vBzeYfsaBFDTy+v8uixV/tKcvo/eATtmAqTly0XoWE4euAWpyUHUxUN1NC4AKsRpplhhTcqLstbRWwWFZUkWLvN09A+g3iX/T+1DbmcbxYD1eXtnuAflihGJKIyt9hWAlW8lmvj9I8G08HPcw8R1qqATvV6HHpFYNuvLj2xF7VLu39Ycaus3M83rOCpZqjISuc9WAp/UVzIOOZFwVqaQhseXG/D/1Nh2tk5qKVZBWBm/QTsyNfI+ytBDzfw/XjDRf/fMhNWVYxGgOpmDzkyoyqN/a4fLxC97M1b3vYBISnFFPSXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DebqU5beCIu/Ze47IXWFReCGx8V7zshbkvIk1pEoQsc=;
 b=mdGVyXjl9TEUXc8ccKj8qB8Y8latt4a9wIl95+nXqtL7Cwkei0/RT2bf1wUQf7Kj6EpDbWwrgiVSUhMa1Oraq300JSlXoKLGitnfI4LBLGplT9FxedY6hBEVzFekKiiZS5OqNMeBKgYst5K95lbW0Bexl7EIjqbAgr1P2vIP8oQgp2/43vlGbFNAs0ttODj+FH9EnEWV6FliKWSJI2DaXg2Xf2OwptPUCr4llZiQuFVngKveC+Swc1buGfWYM89g71nrGFtZPACvJrYO8vCe1+cnhkeVAhaETmOo9eG1ylD2SG4N09LlSgSFKM7lbpPb1cz7PyxZ9XonGmqhzHLEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DebqU5beCIu/Ze47IXWFReCGx8V7zshbkvIk1pEoQsc=;
 b=LPxY0VeEfPOuf3uXhU9rsogbO0IUC74B1oZP5poFVcNV1UpA2p5ALwBzGg+x2WO++mY/ULkLqLDz8m3I2r/7nYVLMKYe2qE6HIGQWoa0OyIAE0KmjSf82Aqr2Lw63vDk2E+zdP5P2lFyo/tMTUXRpsS1ssTJemi2b4Dh6VvtsFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by AM0PR04MB5635.eurprd04.prod.outlook.com (2603:10a6:208:127::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Fri, 18 Feb
 2022 19:27:32 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 19:27:32 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        richardcochran@gmail.com
Subject: Re: [PATCH net-next v2 0/2] Provide direct access to 1588 one step register
Date:   Fri, 18 Feb 2022 21:27:20 +0200
Message-Id: <20220218192720.7560-1-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220218183755.12014-3-radu-andrei.bulie@nxp.com>
References: <20220218183755.12014-3-radu-andrei.bulie@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0119.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::24) To VI1PR04MB5903.eurprd04.prod.outlook.com
 (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c505918-4c8c-42af-8bad-08d9f314b5b6
X-MS-TrafficTypeDiagnostic: AM0PR04MB5635:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB5635B26BFD8EB242642B57B9B0379@AM0PR04MB5635.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2HUbhzkC7hQMKpem9Kgmz9qp2TXO1nwNFMnLN82pzbVlstrogtdIdEEF5eB2prn/0mFkCTjEG9vuizD+3GmNvElf/BVi+Wv03sMkPoM1T7VXmxtOS+DNDTvzy91uFgiKVU/JmQoXMoZVMiVwZmjt89wvwDZblGQL9K06eMZMYvp5yuKpv0tBoIjr9FTn55Twa7NZAKnxRpHSeQEhRxhiJ9KnGYJ8gMZnR1C4Euawcu6vF9WJMJJKGEFYcNk9KBjNC/oCZ0HSFqu13aulVjji3CP6SqPzV6B7GjuDNz5RvOSGLgW2hkXjkt1nmqz+r8KCFHv5YcCY82EpDWKLqbqOeZbdlVt9Re2zFZtM7rkxi2kBYN9ZZAx4hTZcpgVwH4eBmSBA9bggmIT4JTd2lE7gR4JDkhd6eFq/FWYolmEwP+J+Yz7Zk96GnOooMuY+qBThVd2VlUCYH4JCOE0XUxqMcIg3GbzhWB/fizRUB15eLHLJri7Z4eygh3689dfOmAuWduy8XUQupeksjgKgJ1d81oJUxDqSOluwqV18V5JZ/U2PoxsK1ZgobLc63O51sEcScV6976XV0n04D4WdKec27X5ARihGACTU8FVrg0T+QjV47jk9hYq0jO+G9HAVyIRZDeUuaEgaLVAHN1HFTQKwNgUz7nx1taQ/Kj0SAk40VQv5uooIljz/0+HNARKUb2uHB7iNDc3D0rGYZ4iJFYNbkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(86362001)(6666004)(6512007)(6506007)(38350700002)(38100700002)(52116002)(5660300002)(8936002)(2906002)(83380400001)(508600001)(26005)(186003)(6486002)(1076003)(2616005)(66946007)(66556008)(66476007)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bJPonLpkvsWendl/eWBeNafZZ8S9cVDE2xGFc3VKqGPSNC7DP/sBvZ5xW5lv?=
 =?us-ascii?Q?tmOwLQAigrwoZn4XhinPvjo9HYc1MhXaTluxZAUcxwmJ4PyUxOkAFyWF0XNm?=
 =?us-ascii?Q?8KZARQmA9WQtd2BE4Actpey5OSL1qkBG2GPe/fN1yCcF8u0frlkMlIlgENhu?=
 =?us-ascii?Q?3hU9+K7E3NenJDiqyj9Wlzbnljl2DZmRl9TjJ6V4hU1oEGpY83RQskLpB7p0?=
 =?us-ascii?Q?yN7LzqynbrzUfUCGf760hbNZYnKUTzRobAJ4N1/hH/DESGF3fu6dg+dNLjHW?=
 =?us-ascii?Q?SecQca/Usy1XjZ1r27z1/XQDmCk1SM9Yosj4TOoylgdBVK81K/SPyOY0NeZh?=
 =?us-ascii?Q?g5D3hc8+7NCyuqO2MF8TU3vuJUIpFfHCGgVOtdNsS1T/MgPl7uBbglhU1wvc?=
 =?us-ascii?Q?3cHHVPhdXqRM9CWRhp0YL/WrDCONc+3a9bkaXTesBjSNgubk0mKf2mPmkLwb?=
 =?us-ascii?Q?SSL6NtGpDZxTv2jxf78kHWtveXTQ9WtXektIudv/uk3EFmyrds9hovvHFRIt?=
 =?us-ascii?Q?8RIStYf77QXkwoxDgFCow+0hrSgD+cUwVPFGirATaYG5Dpn9p8bLi2OKzxSh?=
 =?us-ascii?Q?xiCcgJseW+Gf3k5woNhewJoX0RHbpBUTQlb5V8ThH6IV3gf+SmmmrTS6EQv2?=
 =?us-ascii?Q?ZeMM9ke+ybXHESrjty/dmHnz9ij3gz6PHh4S+XeCW5bJo+3SjeNbzWMOd3Ym?=
 =?us-ascii?Q?RIXu7828jxjY+A6xH/4tdIIEOAHjLPD2HnXQqtYmwjM4XvkyYoqrqkW6g+E1?=
 =?us-ascii?Q?s5uUqTIW6y2hjL+mNuqZt9zFl1hFXjsQLarpbX8gVvCa6JkfN1kYOY4rteF9?=
 =?us-ascii?Q?4EqoTog9G1qjgbYGwWPasvYbZz1tbiut8YWTGjCmjhoW3MAvGsNP6bWvKnSm?=
 =?us-ascii?Q?ZvR7cGl7PETvBWaAbzWlmGhRkPpZonvkB0AeSKq6UOjXkYodTZ9sN+UXMCB/?=
 =?us-ascii?Q?hHcRrmDTtezzP8th4vEyZ4DnWT/cKaUKukvkpSkJN0idBmycgu1jSqDDgAM8?=
 =?us-ascii?Q?wgCMtuEDw+NyeEH5VBays/EVHsz+FHo0b/cUL9voEoIxxjBSc4qBukjRmR1z?=
 =?us-ascii?Q?9DfZstYidGJ3uOf3VOUOfaQ/7Z/vaP9YYNGlIvkHcIpPbVnsBxA3OP6oFnCA?=
 =?us-ascii?Q?WRftSqOC0uwM9Me77L14tr+o1THb/FNbBc9cISv3Z6dQuriC2sjihx7h45l+?=
 =?us-ascii?Q?tP1yrDeUPnHjqRYxr63SvfC977SmW1Ron4H0TGRXCoZ+Z+d4hOAyGUvW7bg+?=
 =?us-ascii?Q?vAVzx+APTYrFkZnfE/iwSzOPKX+9XwoofwQkVp34v5U4/JdhQc3JljtsoeE4?=
 =?us-ascii?Q?7lwm0ub+DyDY3aBOYbdjOfr1EKEjdMMImJQyqG0mh7rKcAiDazokxbQVl+Ym?=
 =?us-ascii?Q?io+sWouDcVrnviimz3qpxSzAOOpYQKPR7N1FyxbeEEHYH1SaLteQSOIW/zbT?=
 =?us-ascii?Q?kHsv8LfsY5GfPjbl5+2U3tNDG4AkM6Q/TT6JzHMB7kPuB80p84ru9WUgoG84?=
 =?us-ascii?Q?42kBrH0fJFwkouNSgRpyLzFZYZF9269Z4b9/RiSi5slLLQvzJDq4+W8TZczs?=
 =?us-ascii?Q?JpP/u74XOotDhrxjXVOF1IRBUBFSh/zEp2wgToCw8fuwHNOeTAkJ689gVDmF?=
 =?us-ascii?Q?X5pab6t5htb+sxSZ+tV/QZRBSCeZiayeNgzZt2peSW4YPhjQumUJ776uNDJb?=
 =?us-ascii?Q?yqcUPQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c505918-4c8c-42af-8bad-08d9f314b5b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 19:27:32.4576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gWU5+XOqzTvWxfNjT5eqveUY834kj/Mwg4yC2R1Yoam7t8Q6JYkf9OXFQlBLIwSBeTF939hHFFI1nENEIU8p8iP2/jT9xV7smgenP4Lq/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5635
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 20:37:55 +0200, Radu Bulie wrote:
> DPAA2 MAC supports 1588 one step timestamping.
> If this option is enabled then for each transmitted PTP event packet,
> the 1588 SINGLE_STEP register is accessed to modify the following fields:
> 
> -offset of the correction field inside the PTP packet
> -UDP checksum update bit,  in case the PTP event packet has
>  UDP encapsulation
> 
> These values can change any time, because there may be multiple
> PTP clients connected, that receive various 1588 frame types:
> - L2 only frame
> - UDP / Ipv4
> - UDP / Ipv6
> - other
> 
> The current implementation uses dpni_set_single_step_cfg to update the
> SINLGE_STEP register.
> Using an MC command  on the Tx datapath for each transmitted 1588 message
> introduces high delays, leading to low throughput and consequently to a
> small number of supported PTP clients. Besides these, the nanosecond
> correction field from the PTP packet will contain the high delay from the
> driver which together with the originTimestamp will render timestamp
> values that are unacceptable in a GM clock implementation.
> 
> This patch series replaces the dpni_set_single_step_cfg function call from
> the Tx datapath for 1588 messages (when one step timestamping is enabled) 
> with a callback that either implements direct access to the SINGLE_STEP
> register, eliminating the overhead caused by the MC command that will need
> to be dispatched by the MC firmware through the MC command portal
> interface or falls back to the dpni_set_single_step_cfg in case the MC
> version does not have support for returning the single step register
> base address.
> 
> In other words all the delay introduced by dpni_set_single_step_cfg
> function will be eliminated (if MC version has support for returning the
> base address of the single step register), improving the egress driver
> performance for PTP packets when single step timestamping is enabled.
> 
> The first patch adds a new attribute that contains the base address of
> the SINGLE_STEP register. It will be used to directly update the register
> on the Tx datapath.
> 
> The second patch updates the driver such that the SINGLE_STEP
> register is either accessed directly if MC version >= 10.32 or is
> accessed through dpni_set_single_step_cfg command when 1588 messages
> are transmitted.
> 
> Changes in v2:
>  - move global function pointer into the driver's private structure in 2/2
>  - move common code outside the body of the callback functions  in 2/2
>  - update function dpaa2_ptp_onestep_reg_update_method  and remove goto 
>    statement from paths that do not treat an error case in 2/2	
>  
> Radu Bulie (2):
>   dpaa2-eth: Update dpni_get_single_step_cfg command
>   dpaa2-eth: Provide direct access to 1588 one step register

I have messed up something in the 2/2 patch and the dpaa2 eth driver will not compile.
I will fix this in v3.
