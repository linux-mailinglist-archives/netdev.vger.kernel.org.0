Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B9C4DE50F
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 02:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbiCSBwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 21:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241769AbiCSBwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 21:52:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2111.outbound.protection.outlook.com [40.107.223.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC8C2BA3DF
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:50:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8aTO6ivN2rDDIJ7BuEJDrgt2qlnL4PaMKpy2bKaRdUydtMLwBwdB9+ioZGpLG2EDI5QcfAFwiA9CQFYPORW2Lqbw6pW+j8ZVEGB/x8TPP3ylAZ708Q1laruVtIiyV6sW17ouMyGle/cPYS7rQFdJMpVNNQ1StHWsyiisTlB2dmr9eRWJwL9o0Qr1cg7jLFOltwnuSJW3H0qRGKS03EsPGtBNXeFq0vnBqcy7sl2iVkjC1q8BbD9CSPgn4QnZcAvd9EYbK9SLZu3qN/0vwvO528exXJHrmT8oopKaa/1CzsxZctZUiyDQiR3bMBPl3Y/nXi8uQZHty6vQxP0bGOrwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UhYjE6KN8+oJqn7mLW+6nYFAU9Xd1CltkfOIaO/zpQ=;
 b=DyH6MDPfkVk0GzXN+1qtIH4jbHzDgHMF5J9dMf6z8Nw3JTC85FWGyBw5kKX4HLXAAEmTYBnkwiWUSWDNfG3OOX2PN3dNS2bI4t4bcEgOFpTO5I01WlG6zWzwzdrUN97wLl0yQvoNfdMGqeuOr0vUxTfv/i1blO9qUT1iFD6Xvx0uYT8l5XeiCYkTyTcCvKhN5SeN67zZo/EMVQIO2EwHYWBEDdH0nEk0deyP2So7BzaVQ5ajpj+vRcCGV0fd6OEnbR441YkFqM0Vin04GLi+KOHQAtipGPTM7oxa2kZHoR8bFAtJo6wMoaUAMqcjDKNv78wFTBXd1aamDkgjNZ+w3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UhYjE6KN8+oJqn7mLW+6nYFAU9Xd1CltkfOIaO/zpQ=;
 b=cj1rcdI4laA32OwIEgWaGEGuNmNx3nLjAYGTXWgOvooU+XdaSnRwvkHBb8kW9YpiiEbXpD1no7WOuKqOhMoVpNMqQusdW1PTqycWr2GNQPs2MxUt89zmDCO5vV9VecSYKruYfqhxPeepc993vcBpvuJ6oqyGdOkGqFnx1buLaqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by CY4PR1301MB2072.namprd13.prod.outlook.com (2603:10b6:910:41::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.8; Sat, 19 Mar
 2022 01:50:46 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::755d:450b:de86:75fb]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::755d:450b:de86:75fb%3]) with mapi id 15.20.5081.015; Sat, 19 Mar 2022
 01:50:46 +0000
Date:   Sat, 19 Mar 2022 09:50:38 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 09/10] nfp: add support for NFDK data path
Message-ID: <20220319015038.GA18238@nj-rack01-04.nji.corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
 <20220318101302.113419-10-simon.horman@corigine.com>
 <20220318105628.2a714e55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318105628.2a714e55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: HK2PR02CA0131.apcprd02.prod.outlook.com
 (2603:1096:202:16::15) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99c60708-e6f8-48c2-cd78-08da094ae2c0
X-MS-TrafficTypeDiagnostic: CY4PR1301MB2072:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1301MB2072E50BA0B0CD78FD76C32DFC149@CY4PR1301MB2072.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RlvAvXJC5osSvZgLwM7MVaIfJjhTj13V5F0in8pOpY8hcfwAif/A6S3/RjMImppohhLppSiFDreRpTqMyG1IPKBAgTlv4AcWFeaa2/DQSPisqzICkLn5+t4DV6hKiRyIZio+jmWBsF0C4jn7s2csgqX/MPiLRfA9CJ+FAaw0DafIIZLtmOwLvmNMB5Qf1CslLGPUF8w8hgkMqgfb6GyTBVA9r+kpfTwFVrfvYHcxNKr9vzl9FlAok8uU3s0Tsm0W+68kvfpBSwFHSczzhT4fouDpwjTq9nZMkgbW3qgzijZIOVQtZ7JolkH4eXzBLJ80sQM1xrfKUCLsKCY4ABZuCunypZVqYbTboVe9FBX/1UwoXAZRgaJ+eCYrDkTGYK4u1idBBwISq6bV6YL5ZMgvUsclVeT5VqqZZSklu1xSZC9dmu70+Y7dS37qz3W3y0wEShkhzkYU6E1TGpMI6kxD8yZWWGcsKeDWq4k4c+E3z8WPMeUEYb+ViOEoi2vyw7feEliPnkrYDIUMbuzQ7Z2AydM2RPnb9jkE/3wxQT0765tQ96241nov3uXEPnrh60NBUNbp/HfDsckGScWqs9TNF9XimMpdKZyST5i8YIRAsL6Jc0ygXzN7BqHoHj0w6Kcyd6uQva3gox7ZbiIXTLWVT9sEr/kaiq9QhuGT/mlTtSV0B5/PDDpw1+s85gSd1JsgiZDAOaFuk6hmrpsxQXLHrX5XW955ivwd2W2+dLZZ5ah76aaDeU5s5V6LF9YWB9n3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(396003)(39830400003)(366004)(376002)(2906002)(66476007)(66556008)(4326008)(8676002)(316002)(66946007)(54906003)(6916009)(6486002)(508600001)(6512007)(6666004)(52116002)(33656002)(4744005)(86362001)(1076003)(107886003)(26005)(186003)(38350700002)(6506007)(5660300002)(8936002)(44832011)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nsYit6/5scT6fUFFbqR95a5ncxVXRO7hGN5KvtyJbeFWeyX3pwWcVi/kHHzp?=
 =?us-ascii?Q?egAPBso5CnnzxmGawhrf2D2eqEO/aLWeFCPqf+8I/8xa2XVlgxDEjsjifQqm?=
 =?us-ascii?Q?EidRxsYxQNEhIFhw4oB6qTSl3fIQZ2mb77HT9Pl1YEuqgR9JkokJAIqVmeWv?=
 =?us-ascii?Q?b6v0xVM44V847doN7BOHCcsrUKtmMX2vSTmKK3pTsviMFpY82RVr5dgkZGwG?=
 =?us-ascii?Q?lrXq+yx1XtdnQ0bCni1AF7Mwo4SQaQI3YVVdEmQM8BB+0tSx7uDcVjFyT6ia?=
 =?us-ascii?Q?4cBX5rALROw64uewJSM7L0MB6hkYx9iiOft/EXeNRYTISPqXnqOoLb177z5V?=
 =?us-ascii?Q?MNahtuxlBTZ7rEFPdk0XR0A2ABMxnYYBD1OUmqIVW+EWTXnDXHBSn3xx8RjB?=
 =?us-ascii?Q?TqPQNe3LsbH+0S/nbK1ws0EsRzkKt0sifcxo7SEKW0JX5AahLXvC+ThJRJhm?=
 =?us-ascii?Q?QXizF6mK+szq5qhepZmHZT9QYHjMnaPeVdgM6oPVYfFtHNpieH/DdwJXjQbi?=
 =?us-ascii?Q?mK8FmixsZB1ThREMWtoytRytvVPUN5+3iRxvW5AklGPgzJIyilpFDBR8dtvN?=
 =?us-ascii?Q?f0wsHZSEqwM0UWVe0Rzk5f7woLclrMJ4hgbJqGM8VEXm8btI8wjXc3bA9Kdh?=
 =?us-ascii?Q?1er6X+GBmLOL9++wIaH7K1q4dvOoLqP8g2BlraIHvVWXiuHYXfR2c1FfWJqy?=
 =?us-ascii?Q?krrwWRZG9VRGYz8KVtFddkOyuC81yH691IDbv+Mbz9EE/dXndnHnt7xI3hWw?=
 =?us-ascii?Q?AZgi4qp4GfCiUU1xHN14c0ZRAg94KNzXhUOgZMg5yHSKGQkcnjUDLMEwhaQC?=
 =?us-ascii?Q?RlulnaaNYFPvJAWYNAD1SY5MruPrgwB7xEv+MURllrNgF5avsVodKKNhPGez?=
 =?us-ascii?Q?I5WbrSOPUU7TEox08gRUYdtuEsOb5wV284ZjSNiFGN/qKKBFHypXjmU5hl7h?=
 =?us-ascii?Q?VCuw/hN6mcOXleXx5kLWHTFodKxicqS20vxGvIKTiPsIlHBFk/1cAmj66LD2?=
 =?us-ascii?Q?uQA+r4SlZ/GdSr2P8bmG7cPGA6mAK7Tet6J3k0jP5euo1vLxalnelYrAkFVP?=
 =?us-ascii?Q?ItczLry7rHpi5P85W2iTjBO/dcd/9bLnrokMyAsUi7pX7QCQG1dnHCd5baEe?=
 =?us-ascii?Q?zpkY/y3p7AUQdQSyqRbCXOtAIeo661yatUWWHF9xDWyg0B2rlfB8oWh2G/Es?=
 =?us-ascii?Q?5GCinT+TY8D41L0DP4ZyViwfGP2urGbCgFwaqSXN5B+A17dIydCN/efLm2JH?=
 =?us-ascii?Q?15im6QXZZZtBAC38D5QViYGk0iAKyc3C1Dibim+zyPva75ikCvZTzgubrwBI?=
 =?us-ascii?Q?Bzs+SOQNm2mYea9ZLE/A4WFg+h/g0Wvl6hLA2sshkT0/eexTXMKMOCYgXWFF?=
 =?us-ascii?Q?cMMKb76xAu4J3dgg5jUqa+XTEVjhhid28DSx9hdJ2kA0G6HYg1I7PkqwTJLb?=
 =?us-ascii?Q?tL8LmkwLkDqEvRm4IOUISBoeOzEa6f+sEs29XN0uRXpwK8gxRpXQ9A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c60708-e6f8-48c2-cd78-08da094ae2c0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 01:50:46.4873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bh/wCvKQkWy3yMvPPkZLgkYYgNvIpE5Uk8Nc6i/kpFlpR9Y/2JlW4cywvGm6hjxHi7YlWKv9RJHC4hGI38qFng2rcV4RES396pCJZvMTYcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1301MB2072
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 10:56:28AM -0700, Jakub Kicinski wrote:
> On Fri, 18 Mar 2022 11:13:01 +0100 Simon Horman wrote:
> > +/**
> > + * nfp_net_tx() - Main transmit entry point
> > + * @skb:    SKB to transmit
> > + * @netdev: netdev structure
> > + *
> > + * Return: NETDEV_TX_OK on success.
> > + */
> > +netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
> 
> Did I fumble the kdoc here? I'd like to believe that I did not
> and someone else added this, cause really it doesn't explain much :)

I'm afraid there it was(apparently a copy and paste mistake), and sorry
we didn't check that line by line. I'll just modify the function name
in the kdoc.
