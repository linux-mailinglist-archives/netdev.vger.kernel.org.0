Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9253D6BB8DA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjCOP72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjCOP7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:59:17 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF194222D5;
        Wed, 15 Mar 2023 08:58:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htKreARLEJxeSoLQDpHFeJMhzxiIAVgOPTEuOcv4F8LepGX7hVKPLX6zWtQvpegSj+BwPrr5TYC5RCA4k1ZvZSfwJ5782xnisjjCO7MrZAcZ7K11O8/PA3LvKbtRgaOGFXXZQDL06DEhwtOGd5x2lcbnCk9WmUfGQh0cEb2gflcWlSTw96DwWNKy/X+y7jKXlBUlYIzmPMDqd/eY+jhUKJMl1628Os0nfW4ep/1ymRIXCPTHPnhUkQqBHkxY+JJRfETkXSDjROMLLgUTOE9VdBcFauf2WSVyYYtUuHLL+/8ZsnA21C6FIovyG/qUoPR9K4YlWBruLLijhruBZ6D0sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lysouP6eiT5gCwWtoSVp/p0wBqT8qr2PqWje66MLmEs=;
 b=D4xHd9r3hMcMYGjAYAuw+FiGFfK9C/OfpjONKo6zFJzFF0O6qrONfdfQZehcAypxobdjIHCtqPPa99q7gt8Zam4TkiL3/r8eQrv1LvlgRWx+CXeTWMmb14Ju1XqrucUkgmPe+NuEmqNYTUkgyhL4MIcCfQkIXCK8FVsnlo6QTps49W6XGJzv5W1cCygi6PRQJluSho7/p6EHdYjMzO2a8wCDacXg0L0Jjeuh+4Haa9ukMWynHQyJeTv7/8qrbhBQXjH2qutHYvQfs7OGU1rh1yI5d4hims87Rh+5nGc4SsMYHlKYigs4BUhGGl0WG7i2SxYj3MACv4TXFt9y2u6ngw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lysouP6eiT5gCwWtoSVp/p0wBqT8qr2PqWje66MLmEs=;
 b=rBB5RL2vYivKjGFh+qF3Y0i3mzRr6F6w+sZrxJxg6ARytcDD78dEPxxWBITY80D79rGY1X8FpNPOTpQ8w1ieS6ieEK21tsm/SPE+24vQgk7g7zwIWwKieuJvKT8PhXlxAEYzu7S2Jjo2IUlaB49Nen5pKOrOY6bNXdLj0N6xHfU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5037.namprd13.prod.outlook.com (2603:10b6:806:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 15:58:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:58:37 +0000
Date:   Wed, 15 Mar 2023 16:58:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/9] net: sunhme: Just restart
 autonegotiation if we can't bring the link up
Message-ID: <ZBHrJiWlTydezWWb@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-2-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-2-seanga2@gmail.com>
X-ClientProxiedBy: AM0PR03CA0028.eurprd03.prod.outlook.com
 (2603:10a6:208:14::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fa1540f-0eb3-4d3f-5722-08db256e2310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qVKBn019/MSQG8iunwdn1fANg3fDRxWYValBYWr5WWU/c5x0N7l/WrGOVdblaEz80NZXZRaGvdAhTD+ufwxVm4dVzxLR4xTDq3nvtNhQXqJO7IeVoCSDW0AkbD3+IHrLnYWbp9FAeGkx8Q1y57pvgRC+PH6VOU1ZjDk2WfQ610QWZLaMxYe7EQ2+kPnT6O+ie880AGijQhzw+FVbf4X1hNxXGps+1axLQNxfTcD2BNa/fELqGPVSVScTerVpZyHepCl4dIFKtlCqBIm3WsxwDsS/tgc1t9mKcGfhRh2zH1SNP/Tic22g7Wyku+efY3mw4JMUaEPEAsCI2Mg/5yZWeobox+Q6mDUS58/26D8WezF0JfcYRjsK4bRRqaUV9hYE60D/gPSGo8HzoV/Fbq4O4wVjlxJLL5VqaffJDHlqSNLs/+tmJ3HJ4oRhnOFzJM3wFqwLs1/E4i7xazFEp8kBk+pI6iSWY7zf+nuRrQ1oCYrpAG/fijuJe2tvdO6Omyb6uQbfNHuUnKiZkUvXyQuq5+PYQiO/tcmRbpJ+UuWWYz7dP7Ve5dDtY6/dUEdDPPP/3ju9a94k/IoOziXuezDcsXNbNhjg33UAK6P4RfZ32dof520UCtKew32J8HclbzzJMFB776Yvqbp51kF68/4bDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39840400004)(451199018)(8676002)(6916009)(4326008)(66476007)(66556008)(41300700001)(2906002)(66946007)(38100700002)(8936002)(5660300002)(4744005)(44832011)(6666004)(6486002)(6506007)(6512007)(86362001)(186003)(36756003)(2616005)(316002)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8C5Oir1GtHDEgYFm7uvcwrqRPB8kKv1MbvoU2CR19Ij5OKit78GYB4jEF8At?=
 =?us-ascii?Q?k/S+XjdcncNvSJft1jKGe5o+OKrC9A7MQuAToPeGgDcBBm1ih31HJS4R/881?=
 =?us-ascii?Q?bdyoWowQ+ltn0S+Jl7FhzI3NlD9CjxxoRU07aV8ckgdtruoVeHCJJNkKSJk/?=
 =?us-ascii?Q?W9MAGxrM4/oYlH+a05Cpj9XeYrD1GmpvNyAY6Gi58WKFSgX4Xtrs1pEpenqn?=
 =?us-ascii?Q?Omcra84BlX4lLaGDBUeSOxCPrCFGPCLRso3cayY+ldoF3SNxPbbPCe8UwouN?=
 =?us-ascii?Q?PeJnoexQEWgzkfkwAC6NpX4i3j0v+SnCeX/N8JWRUggF1w7OvRC04KhDX3OP?=
 =?us-ascii?Q?9yZHclxrfRCN7mM5F++Oijtp1JLW6yPZbAaJeR3vzfmrny/xoKRNvJ+ioHJX?=
 =?us-ascii?Q?s0S7QQkmhHP7KdETd0Jwz9YbppGICbOskRqVDU6VRjrWHWXd/A2HEc0r6d+7?=
 =?us-ascii?Q?Pkn7w6ij5IDgtOsdAE/iy/Z30wOdGDw+Z4YE9M5U+FQWSaMkRHE5RWbOmOZY?=
 =?us-ascii?Q?G4ZlBBAvpM4asYyQq02ientgYDkcM4S5V+gjTEFBf0Kn99rZwbuEMnl1ZIC8?=
 =?us-ascii?Q?D+6Eutz3e9l7nYiZQtL5xRovW19LfUTmxpyap1iery+CTbyUyJSMqpmvNtYR?=
 =?us-ascii?Q?WOHMmF1ChsEBqnH5v43YP29tAkUhdYkxqmF/DfYzdN4zxVIIdnrJbkioxuDr?=
 =?us-ascii?Q?jFVPRryzzkETFkh0N1zRepp5zo8msxi9ooo4dc1j8pGSRH04j5xq4xegsZ8X?=
 =?us-ascii?Q?3WEGMb3jR8KAKe1DL4YvfCTKg8Ri45YD3ZFPD2/1hvUOjg5qjXlcAiwF2jFg?=
 =?us-ascii?Q?lYG9l7TVib5A1xjNSwyIhbrVMzM9QxtwQmAxtRxd8QE0iQRUB3FRIn+Q6eoH?=
 =?us-ascii?Q?1NKfUEEJchpze3TdX2riBsGdY3XDQmYcIIqBlJe5Mxv6SpDJfvebOTv3jkhJ?=
 =?us-ascii?Q?EU6IP0cHYQBO2UWsrEURNX+/f0vDFuLY+1I9xHV0zpEHEZNqgIPNkjZxisMx?=
 =?us-ascii?Q?VDDKgoIo9C1He5dROqUbHI0bQXgXMO1En4Xb66+lM4sYrtOKMVZmlWuRzJhI?=
 =?us-ascii?Q?9GVSUcw/JwOM9MUFaY++nZNCp58viaZX1dWHZA/EZMrwjPATMN/DARSJdh/S?=
 =?us-ascii?Q?4uUiM82NF8wD8uisXCeV+NXgcgbyv91es1UHvaaMAogQWkpdWHUDANOS3iyL?=
 =?us-ascii?Q?gWIbwMjsqE/xd1jzipsYQsn8IDzqhjzLBl2hjVfN5BdqggQdrNYuMjUuWK8/?=
 =?us-ascii?Q?YbnMWxNtY0Pgi+hfGJ8y9xIIZ+bDkagqRZkP7bp4cqEbFA8jgQfGHBlAeJpZ?=
 =?us-ascii?Q?xxg/k9VjV4pFyDZItpXyzxnb+EKv7qmobWTVTgir4rnj2tbil/PQpCeEYelR?=
 =?us-ascii?Q?/VhagkktRgE24v5LfZDEwaqTFXGKsfCBtYXBJdxBVwRvE7jG0ObYA5nvJ+hT?=
 =?us-ascii?Q?lWEXLhtzwwb3Y9DkEwYLs2urv1YPUdEfZmFJtnSU/vx4PHgaEo3l+A6t36m9?=
 =?us-ascii?Q?sa6CXZXgEIOaH+7f/UlcgbUbtqLE8GulZa2QQcFpZG+D8gax72awvwK72fTB?=
 =?us-ascii?Q?05XpmhuuIRe0eSffBXzvvBIVWewLx3/Y7cTS40JDxFXVCePAD5M87EBQiRtT?=
 =?us-ascii?Q?ECHqm9arcW1OmJj375yqyP5yM74vUSQvFygZzAQEYEVZ9HtJMVcj4KJVjGEq?=
 =?us-ascii?Q?lToC8Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa1540f-0eb3-4d3f-5722-08db256e2310
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:58:36.9190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wA5khOdh1PeRfI2ggVN1+WFag2KIhZ55pfYkAdLIWIFEc2+wn6iwTGIWzT4dE3tidn0riZ0B5EI9LDze64/0QlMZKEDxIFk999BnBCFsWy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:05PM -0400, Sean Anderson wrote:
> If we've tried regular autonegotiation and forcing the link mode, just
> restart autonegotiation instead of reinitializing the whole NIC.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

