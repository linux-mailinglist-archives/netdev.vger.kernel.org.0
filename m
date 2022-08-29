Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E555A468E
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiH2Jzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiH2Jzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:55:41 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2131.outbound.protection.outlook.com [40.107.243.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7FF42AE5;
        Mon, 29 Aug 2022 02:55:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBTUF0xQmNAraJOAhfDfzmwtgEhJ+yBSHF27kqmc44Poaagaslil+HTRJQAQAjjMrAYZCn+9BCaXqWo5zsAWxtAwz6Hr1lRv5l7MDFYtxe9zT6C8Bj53c+KqXhH9WlPWN0t73e6QTkPFperGcdErFklIuL2XfewpaEZtRyHxYPT0yoi+5QQc1vVIjAAwqbMdJcJyvqxc46q214CElXhd6dOj0DkNLEPD/ahqkayaE81hORK+ZIZsQud4FAe63erwIQoIBxxVw3U0hE47OLNsmLJg+VQwNtlycLtxjFkg1tJWC6UltqrbmuSPeR7HxNJP30j9O33nEt8jBdW7trDi1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/evPD/eudXYVCRnFN0h1sTxn/bpCjtDSzl4WubTNexc=;
 b=i3SiO+Kex+mbY8F5guGpcfsyng01B0Nkix5ruWZ4m/N0XwXyhYfzf8XhAA/8tKWKZxV2OIeqh/NxhqKtcGJhqNlRZV5MX5Veg/e9p31wjylpRDb2rn9ekOCrumH3BZJHWF/t4Xzyeda4t+FD/cU5oJHbSvPir/1idqNE/W8IcSAG3GQ6hAb995jsrnjAJeKhJHFgfRHmgKTx/d2uXKhyrR9/GZoqNBd0+5j03FVy2sAIvteHrGIRrNG/bK/JTPyLZJaGOci3mszjApbTDK4D1H0MZLKsfDsJoy7OJXvKGAZMNlbitznE9okmQGaWAx7yWwBUCkXk0xtvk4FxYNvYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/evPD/eudXYVCRnFN0h1sTxn/bpCjtDSzl4WubTNexc=;
 b=bacUaa/DxyLXYlK70Pi1iMkkJcRJU9giBZ+Gm83XHTU/ZMO3ckCHhl+9LjRPoyXPMPhzuREXIqtRlxxHE1R8ixDXhbXSbQNVtU4/7VkO8daXRLcYr+mjz2Zwob3zjeQA05Lt/uujBTnHUF8KdrVi1C89dnTxYERl3a4x0pOT8lw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4915.namprd13.prod.outlook.com (2603:10b6:a03:366::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 29 Aug
 2022 09:55:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5588.010; Mon, 29 Aug 2022
 09:55:34 +0000
Date:   Mon, 29 Aug 2022 11:55:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Eric Dumazet <edumazet@google.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, oss-drivers@corigine.com,
        stable@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: Use u64_stats_fetch_begin_irq() for stats
 fetch.
Message-ID: <YwyNDi3p72DBvZ/3@corigine.com>
References: <20220825113645.212996-1-bigeasy@linutronix.de>
 <20220825113645.212996-3-bigeasy@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825113645.212996-3-bigeasy@linutronix.de>
X-ClientProxiedBy: AM0PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:208:136::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7af69fc8-9740-47b8-0dc9-08da89a49d99
X-MS-TrafficTypeDiagnostic: BY3PR13MB4915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2Mw9Q8vroRXJAdWJp+sx6e47/KgjC/hHTLxIyZouqrN1MtqsPbwBbKhwBB6AbgHLaI8u1asF8jXqqkZWc551WQ/AOJVVZ35rxzBuCjoVNxA8WYCnEwKUSlgWpiTZox4FAAiAyYt5+mGBI9RyK6FWAON4EHtjxV9agDyBsk3nVShDHvwS8Ub4dQhNobAIbRSNURLf1a0OJqwEFmPTXqPszzZWQSLFPWpBWq0oFdgcsL/955BIlMrsZdNeS9VWQOkpV3MFPYGHPF02dKcYtRs1BnPjoVch7l7YLb0K+JywzuogqQoqy8pIQ3EMScdhlInUwa2DWJxT1kn+Rk+advSPQHEUBCDKuHFnQ6KwF2K3pk/d4XGQTFWKwV2K8ss97nEBdLcXbs38f3Q2MTELIbG5neC7uE6fSVASzauUPRIH47qtyIhp9Mx1n/CxesAr/hGUsoALe1JEsZuohw1F8cXtu/HdywXpMMKmpGY3K7gVBvL9cWZJgpsAwS1UzFqe6rP5VCKphNZ2TCFQJyXsMbZaAbHF/1ju2vT5p5eNq11AA0j/DUix9o/EqiYLwYYLFv5gH+4NrfaC6AzUnbMROX7awXXXILTMSVS6MkuE8Xvpscg1pZcUTZkKudXa6xeoyOPOnxBmckVebsCDPt0kaFbxOcCdCwne4f0wjjkk3WkV5/iefkGF3LgKU+754tfI4S02BNl7+xP53LMXZz2tCTYtzWTLof4xP7JMCZm4hS4ujjtsnNip9mgXhRRVTB23f4O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(136003)(346002)(39830400003)(478600001)(6486002)(186003)(52116002)(2616005)(83380400001)(86362001)(6506007)(41300700001)(6666004)(4744005)(6512007)(36756003)(4326008)(38100700002)(66946007)(66556008)(66476007)(5660300002)(7416002)(44832011)(2906002)(54906003)(8936002)(8676002)(316002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N2YK+Cq6zfvh8+Dvqu0Chd2C9OwUJQnvVTxUHOieV048D6Io/j3P0R3eaKJe?=
 =?us-ascii?Q?VSqDx6nsiS9VJVpdnU2pgUge3LBIisOP2L35It2YDtacKQW99nF/IbWLNsrA?=
 =?us-ascii?Q?yi5RfusvohaLbj9e2tU1CZxHEdAFogrbkLTnMjtnPbYglt/cYnqyeTg/L2YI?=
 =?us-ascii?Q?Icj9Wzr9A1NJt1ccNOofXox+sX+r7/58OzPmP6rUC/WnG+dAvnj8ZmMAzr2u?=
 =?us-ascii?Q?yIr0OORsvM1kdOdFavk5U+PgQKkQHiFNWcANpnRBwmnSI4pEIEAuY+rLJp7/?=
 =?us-ascii?Q?KGDYcgwmnzho+rv9eSabM+7pQiL3aTkZVYR2QKgC10CtS+Bg9Fuyp7vY4nSU?=
 =?us-ascii?Q?lqd/YqlbLkw92fRNe+J//53pxa3ioWUixhfkXmXxehzSONDZWw8Jnky9RiC3?=
 =?us-ascii?Q?Tj6m9zRN+FxYOGYXOH+1pdREJapU+V3/8XTm2f/jFEyqETDg5uzEDKG2abpr?=
 =?us-ascii?Q?1QGGaTA4ks0KBDw7D5JLmE9iSe648s2XV/AY/DSkgzk+6HZ7QNhnHG0Gkon9?=
 =?us-ascii?Q?U+hriSB9ugmx3tfkYscLRnXZUcTh+WvMcjZpaVOnrM51TW0HYQSjEhxK7MQm?=
 =?us-ascii?Q?jVc6uQG4mtQfGoL45MU/Ywyc4tV9wgFO0Hdx8i89QfyZtRFLfaGFVYsTQD3G?=
 =?us-ascii?Q?3Y9pt+NcLzD4AWUeqT3efkOLnQNJt+3v5/78ZxNkSkxlYeSFcFtbrACez9Im?=
 =?us-ascii?Q?6cinM9c0hGzfUzGQ9Jmi8gHjVMJ/uhxtknFI1ETKiVeGlVla8mUHFYZpsotM?=
 =?us-ascii?Q?UPA5shDIT1DTOVoYDj++ACIckcc/V7WfxsKaqvOhe+CR57tTl0eRzps3zNNF?=
 =?us-ascii?Q?lOXxiNlCT9u4TYPF9dqywERBiuuuAF0L/EFsEXiEhw7Gj9Lkrune/FhWTpXS?=
 =?us-ascii?Q?EhqJGIj/dDVRVSDX5XqxzuwMzaFnsIVcHT+OpsvS8a1axzvxaN6Xzc/726PM?=
 =?us-ascii?Q?FCBqmiEDE6Tk3zR7r8R8Kkl1l/cy2vkZDoMcFLuhGwMfiGRDDeHwEjr0Z6w1?=
 =?us-ascii?Q?YVDK/5vkxV9yWhTRul8EJ/7stzRM3Efw//Is4jhUUpfgqqCObLSBRL0n79aq?=
 =?us-ascii?Q?b1ut05p+j78V6t0jH6tvgxPfOqhQEsnbT74UzaqMkoWjZsp2LgwXt4v7WjUz?=
 =?us-ascii?Q?qXs5Kotpva8NTWcjgW0uWVevBn5oA32XSsua5EdJYW/NJNSy3nLBH5Bv4FCr?=
 =?us-ascii?Q?qV9OmVMmuyYPrajbWykydt+grRFKHf5XJnr0qh/xkOOu8s7lCiVLy9b+RmOT?=
 =?us-ascii?Q?0t+/f+m/3LghEKUhuQJVPUOi6xY7gYVSU9MVR9Kulk+ePwYGp1GqgRXW3h4L?=
 =?us-ascii?Q?B+pAIbQ2sYBxbXirFLcJ8kAcqjKP3HZWLEaYIFeMCpho+9YtMLZSWpXNALeV?=
 =?us-ascii?Q?alRfNkOxgQ0hGuMkDKaKHb/RJOV8cO6+bNwlk9mUr9Y3kl3ZJqWE5t6w2fuz?=
 =?us-ascii?Q?mRClctsM943H2aPzZhsjiATDndF1iU4gK3zCbmLLXHzvi0HVwzKZ1tmfzSRu?=
 =?us-ascii?Q?XftO8I9OiQbqj2DBL3J6XIZvBVCjHwM1I2ku1e7QfPuxh+gmZ2VolWPJ6Wid?=
 =?us-ascii?Q?dPRR71eo8be4L4w09HaXDfDCL+ej+nsBCaMAyr7RiPKagdui/ctsF6l9nEYR?=
 =?us-ascii?Q?2GiX4xAlsdQxq5IDfQnhz4AnMo8cGRCnG0BSiopYy2tDaZooy4VrYT8KwoWY?=
 =?us-ascii?Q?zX6D3Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af69fc8-9740-47b8-0dc9-08da89a49d99
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 09:55:33.9447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdVfWAx5uUBYk5x/VlZwQ47qQOogoSI1CkLWEH2PEtbThrFQSdaPUs273MANzeIwFHzzEGARmFbOKBBqCOiBtMIjYlG3CUHXIUPk02M9huo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4915
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 01:36:45PM +0200, Sebastian Andrzej Siewior wrote:
> On 32bit-UP u64_stats_fetch_begin() disables only preemption. If the
> reader is in preemptible context and the writer side
> (u64_stats_update_begin*()) runs in an interrupt context (IRQ or
> softirq) then the writer can update the stats during the read operation.
> This update remains undetected.
> 
> Use u64_stats_fetch_begin_irq() to ensure the stats fetch on 32bit-UP
> are not interrupted by a writer. 32bit-SMP remains unaffected by this
> change.

Thanks,

for the NFP driver portion:

Reviewed-by: Simon Horman <simon.horman@corigine.com>
