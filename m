Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BCC6D330F
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjDASQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDASQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:16:41 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA04C1A471
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 11:16:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAnEH2SMMnu1QjeafiuWdrZ9IPklBlv2qFSRPzlZMI5xhJkRvCTNW41955xATIHypgQDNZF7OI1wsKAzTWnfeUhUxHw6e8hwEdHttFgLuQaFms70E4lgxBPDqOhsowqdqFMZMQDmx8n8x/0aq6/2Yck53wsWIxtq2Zdlrb67ZjyY+ffDtrq6hUCFKjBnXIPUdOP8Ben/Rnn+yT4iGNUPBwMgqOGn2mFW08qbLsOZ3IgSs9uYlGXq5eWbnKZrCC1HM+YgfdIw8WKGDy++J4uNtjEgJTQWl6MSKIRYTDdtRHGuDBz6Y4mhehSMlstjMMTwraFwUHwxCESR+1AUel0QJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RInLddaB8aLonZTULzbnqHlDg4NacsQk6n0tR9XweiI=;
 b=kT9qph89r0RatU7BdWAhtBTwmZ/1JeQQcIyON/+uoxZ4xw9j+v+Z/jOHD6SYnEqiYbIZHrt7EmeUpOq4H3kdBE/zBk31FW8fR2lP0v+glV72ss1SF1Kd+E6YFUY2NrH4WquPxqH7B51sfjRAyHRVWqUg8ktfRVrxEjcacODNXe931OQWb8YpuVIRv3Xk0u5iiRS99ypNLThX5M8jnxT41gDtPbr1kSC5tiO6tWnmjLUPFDANavOSJbUCh79ueWn6pKMsO0Xuvh8unQ5EbTzqeHvpCTuBpmtdL6Z6E82fEjZUdWCFI5z9E+Era3tU8fKisULfMgN9J59/uk3qN5RHNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RInLddaB8aLonZTULzbnqHlDg4NacsQk6n0tR9XweiI=;
 b=Ytv9G7dT3elQFegVLTp0DGgbMENL8jTXHz9ThPg8n58D73l3I8uEFSYQBn9jgQIzI4jQ5zbLTZJrjOZc5AdAaFZw+r91/bHhEesflT8Qfv6/IDA4chlqqu53hMam0gO1ly8oaIawwPrTd9uz7f98XN9CaKmcA4qpWC2Qo6wm9mg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7055.eurprd04.prod.outlook.com (2603:10a6:800:123::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sat, 1 Apr
 2023 18:16:35 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 18:16:33 +0000
Date:   Sat, 1 Apr 2023 21:16:29 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Max Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401181629.l2qkc47q2vjank3z@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
 <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
 <20230331111041.0dc5327c@kernel.org>
 <20230331111041.0dc5327c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230331111041.0dc5327c@kernel.org>
 <20230331111041.0dc5327c@kernel.org>
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7055:EE_
X-MS-Office365-Filtering-Correlation-Id: c9478097-dc8b-4ccb-2b4b-08db32dd3936
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpln2UD0DCZJCH5/t7JpA7EtNRcxyH+DNSG77n5SDSTrmbsuXNEeOYDKDOXRlPCj1OFaVoWDa7agpffvXE3OWIbb9ygAeeXkkcvF1/KrEKYj3v46xLQHnJeNLifiC7ho66wYe/mhG01NTK1B4In6Uuv0JOJ2og81J3W3h1s7ix38OOmJSlPvUNztZ6k8gIkdS3U5i1BzPIR8cKZYhBOLF7cUsMqXLazS88gz6OJhP72QKQFW0TyIKs9oknRATIVi6PPqTFNjPoo4jC7LqTlv9B+5cR9omDymptccX01RXxm92zGqldoPNpszYMZQGnLVNLBFMOhP77sC6AEGuS4tzV1QjiqFcXeI2P/1hD2QhICWTwDgsUThZvS7YOGmCBd4lduGVzfixdICr2UTN38md3AKkQ5wyE0mTGSAnKXq2AXGrA1xN0iP0u+5/+YL7ELCrikgLBFvn01Zek9oNKpcAEgvAC8Jy5yZxJzWFcGmQQviurSkSehXKksqWEmUHbovXsSGmnl543ASx7RhyX6fua0sN3fo/5+mGU9IUP3EHdXakumr5hYKJIGjgmSxqUto
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(39850400004)(346002)(376002)(396003)(451199021)(4326008)(8676002)(6916009)(6486002)(316002)(66946007)(66556008)(66476007)(53546011)(9686003)(6512007)(6506007)(1076003)(6666004)(26005)(186003)(83380400001)(38100700002)(5660300002)(41300700001)(33716001)(8936002)(478600001)(86362001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWF3czkxM2VDR042YU9HSXBnSEZSaVdROGMzSHFoV2wwdGJSTkh0bmo1bGNW?=
 =?utf-8?B?Z0FXSm1yNHE5TnFjOHhFcmxZenR6S1Fra09NbkQ3ZmRScUFtYUdydjFOTlBF?=
 =?utf-8?B?WS92azExRnRPS3Iva1cxVCs0ekZCVXdOV2MvV0hDSjhiZExiaVJXQUVmNm55?=
 =?utf-8?B?TUU3VUV1QzFRdUlmYS9IYVhtYVk5YmVjRVZtU3JBUWVMRi94cVBIbDdNUDky?=
 =?utf-8?B?Um5zNHh3R0FBSm0vVWNUN0h6VjdqS09nYWVwY1VldTd4N1AvZFVlZ3Rod2Mr?=
 =?utf-8?B?QzA1MGE4NFlmcXE4RmdLWGxGbWhDdmV3RWtpZGVmbEF5WWFoOE44RjA4WVQ4?=
 =?utf-8?B?ZzJXUVk4VXk3SStTSXFjTW8yRG56RVRFSGFobmdwZHIwQjJaekVBckxJUjg2?=
 =?utf-8?B?RXZTZ0NzRHRmbFM5NWNXTUhWcHp0dHF3ejZOVytPYVMzQVBxMXYyejg5Z2JD?=
 =?utf-8?B?V3k1dWF5TWpOM2FqRUZWZVRGWnVaR0pOTWpqRE5idjdUWFlBSCtVU1hvQjVJ?=
 =?utf-8?B?STVWbnJJZG1ab2F6ZzRQZ3UzMksyaTYvaEg1ZVphQll3S1pxQ0hYWmhDVnU3?=
 =?utf-8?B?eEsrSDN6d2dlYlNTZmg0M3JFSzJnNUFuNzBvazhuY2xseUEyS2NBcDUrbG0r?=
 =?utf-8?B?Z2hNMEpVbjVqUHJvbVREb05Xcy9OVHRBSFV1a2g2bGxFNjZ2SlNsSXhPc3RO?=
 =?utf-8?B?QjQrNTRibElVRHhZd04yTTFWT3Y2NkR3OUlOMnFwaHFrd05mUTRuSjU2QmJP?=
 =?utf-8?B?bnVTTmdabVp6VEZrYjNEaFJDaWZsamw0VE93VjVVNXZvSXlMUEhKaG5lLzJq?=
 =?utf-8?B?NExZUFZ0V0djVk4yWDFGVlhoeDRrY1Q5WXE3T05Ia0tvVkdnUmJ6akxxTVBi?=
 =?utf-8?B?NFo1elIxbkl3R0RoYWNtU3poaXptN1pySDNodGh0YzJGbUN0aGdzZHUraGN3?=
 =?utf-8?B?UGRrVkhNVzhBbSt1ZjJXSHU3TGk3VjdhSXpPUWs4K1RnY0tGMklmWGp0QXdy?=
 =?utf-8?B?SlJ0WUpiL1BMMnlIR3FVOFk2MUszbGxOMTFPT3BFWkx4cFRORXd1aUtDZXNp?=
 =?utf-8?B?cW52RWpTeUwzandlSXQvelp1Nlk2dTgwd0VHa3c3TEllbjdZVlNzSGVBbU9j?=
 =?utf-8?B?Lzc1ejFyd2tIQnNBL0M1MXN2L1o5WjRNa1FtQjQxRUhqT2hqN2QxWW9KSDhS?=
 =?utf-8?B?U3Jya3hFdFlkVGdRbjdHTjlwQzUxOUp2cnFMSzluZVhkc0JlZEpiQlRSazNE?=
 =?utf-8?B?NG5CcmE1dXZ2Vm9SNmVNZHdacGpRY2d4VkNKYXVVTXRRSWNBQkdsSVJBOTV4?=
 =?utf-8?B?dDVEalcyS09GWm96WjlHRXpjTUJHNzBEaEw4OFZsVkZWdVJPYUZacHZvVGZs?=
 =?utf-8?B?V3ZiYU01WEZkY01lclNraEFHQzg2cFlyZVk5RGlxNmptczZpNzU2NHBuVUYx?=
 =?utf-8?B?aUZNMEFpaVRVSGN0MkVlQ1VnZzB4L1dzSE5ZTklEUUd6TmIxdUJTcldTS0d2?=
 =?utf-8?B?cDN2Rk5Md21jc0VFdS8zY1NCV05UaUdBVU5PSkJ0VnFaSFQrWTI0R3M0OUhy?=
 =?utf-8?B?UFNNOEtKbWZ2WDVYMStKb1U3eXRWbUZ4WUgzVkhEYzBzS1JsWGZDbmttd3Fq?=
 =?utf-8?B?V0VuVldhR0lKdnQ0QXRyeGtnaGF2QjNscS9LUWxzSlVpUlNVS2VpT3pxUEQr?=
 =?utf-8?B?WWRiQnNQbTNMNXhnS0lwWWhOZ2ExT0ZUVTRJbzhLYnowd1BtWkpHcDZQcVpZ?=
 =?utf-8?B?YXo4NnppY3Z1N2JhRklJbVo2Wk5iM0gybkEvQi9SMFcydlVUZWY2UWx5N25y?=
 =?utf-8?B?M0ZIWTVPeW4rNVF2N2V1VTkzUngrU1BjTFErRU0yRis5bnRIT3MyUDRReDBJ?=
 =?utf-8?B?QkRrMDV3YXV0bmxXeThtdGFKT2VWbGNLZ0ladG1hbmlKaHU4K1RVRjRLNVpq?=
 =?utf-8?B?RmlQQ2JkK0NuV0VVZFgyRDNNRi9sbEF2K3dCWDlnaldRQnBQUmpOSzR2T3Ru?=
 =?utf-8?B?TDl4QVJheGFNZzMzMVN1OUg3N0JEOEZ3aWhma1Fja2hkZitQQ3FCWWMxbDV6?=
 =?utf-8?B?Ylk4SE9qNEpvaHZTbkpjT1Vvek5yQWpsc242NHBzbDRoTm9KS1l2eDdKVzlQ?=
 =?utf-8?B?YlFHUzZ2a09ZbkhaR3VNSkljdXpGUlNYdXBxZGNkcTkrYXV4MW5GRTlESWZT?=
 =?utf-8?B?SVE9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9478097-dc8b-4ccb-2b4b-08db32dd3936
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 18:16:33.3977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHDDCFVS7H+Hy5+8mplNqCRKTluoZ7gTUsolj2qVXRW+jdPWDu+eJ3QgGszCJdH3RBSyz5X3EsBvwV3z1hQU7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7055
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 11:10:41AM -0700, Jakub Kicinski wrote:
> On Fri, 31 Mar 2023 11:51:06 -0600 Max Georgiev wrote:
> > On Thu, Mar 30, 2023 at 11:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > I wonder if we should pass in
> > >
> > >         struct netlink_ext_ack *extack
> > >
> > > and maybe another structure for future extensions?
> > > So we don't have to change the drivers again when we extend uAPI.  
> > 
> > Would these two extra parameters be ignored by drivers in this initial
> > version of NDO hw timestamp API implementation?
> 
> Yup, and passed in as NULL.
> 
> See struct kernel_ethtool_coalesce for example of a kernel side
> structure extending a fixed-size uAPI struct ethtool_coalesce.
> 
> So we would add a struct kernel_hwtstamp_config which would be 
> empty for now, but we can make it not empty later.
> 
> Vladimir, does that sound reasonable or am I over-thinking?

So in principle I'm okay with the NULL extack (even though we could consider
doing something with the netlink message instead of letting it go to waste;
a suggestion may be to print the _msg to the kernel log, like store_bridge_parm()
does).

I missed the discussions around the creation of struct kernel_ethtool_coalesce,
but I imagine that ethtool_ops->set_coalesce() now takes both struct ethtool_coalesce,
as well as struct kernel_ethtool_coalesce, to avoid refactoring drivers even further
than just patching their function prototype? I don't think that argument would
apply here, for a completely new API?

I'm also okay, in principle, with having a struct kernel_hwtstamp_config, but
I have two problems with the way in which you've suggested it be implemented.
The first is not really only my problem, but rather, I don't think you
can have empty structures in C - I tried!

/* C doesn't allow empty structures, bah! */
struct sja1105_tas_data {
	u8 dummy;
};

The second is that I would actively dislike an ndo_hwtstamp_set() API
where half of the arguments are in one structure and half in the other.
I believe it's much easier, and cleaner, to make struct kernel_hwtstamp_config
duplicate the exact same fields from struct hwtstamp_config, and copy
those fields one by one from one structure to the other (to avoid issues
with UAPI field alignment mismatches). So we could pass only the extensible
kernel_hwtstamp_config to ndo_hwtstamp_set() and ndo_hwtstamp_get().
