Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A097A5E5F48
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiIVKEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiIVKEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:04:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5375AABF2D
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:04:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5/r7/8EW+eV7r3laIsGBKYqIjLO/QLvy5YvzWwCwb+lZUB0+rqvzE1K14SGI2b6rA5bOrqL6R6/9nP1ufrYat+uCp+f+tedTqr7ZUq2v4+JvyMszekWDTsUiR7+8A+6KBiFXuVVoorIRbrdbSSEOggJYsYn89iE5+x80me0bsoWfsLIUmReyVpLSlWK6CCG4nxZo40TPdp6laBDF08mOVzNGsLnNVeOLOzVC34TQBFWNVTS22+ki05WgKzVHBzK7dUOkdUZrANKg4PO4n1RzFyf/GHVNYFBc3dnbZlcDFRJ2HfP57UIcJ/cCW1corxDDmhoS6YlnbRO21J/6/gD2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTZAOpGUYBSYwc5p7Tyt/jDoFxEJw7veletu7dtFYfw=;
 b=FIPUArN2G72auXf9yfq+pyBwNomcLlfR6pXFrOMrIUBRsp/3x9fIi7pEsQuyMkC+ZvGSZkXIOE7jkRXeazoC8cnVYG6ju1K2P/MaBerqRYbA8r+SprGk8o9u0xM2CWfei4BxWWm1rScPwnzd6NKIk8OKKBEpYb5xks0+YqX5A/hB5VWKkc7n4YV6f/N9+r90J1pqgYanT7HVZ69CU+Jyrep+e+6kGZ8XitgoPOjxZRFawwWc1iv+CvK3LL6mqOdlBabWa+vJNsvmDEGZGnheoQ2u3nhtcbvtqxISTf0biWt7B1iB0iZYeS5RoelCfeWiEEj7wjBDcYqTP1T5NkO4sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTZAOpGUYBSYwc5p7Tyt/jDoFxEJw7veletu7dtFYfw=;
 b=fZ1SDNa73G6rKLn3qLLmi2HzuTi6r7nSr6ytT1bG4H3hO0jWJiXEfBtq7R8eRC/Lus700h23Av2PauW5G3/qrKHIR0UfDtO0tRVxi2FWLnsV8Bvupq/2nYBdkMJy1belx0iTA6LMIleiynhv6oiTvXpqFRRTnJyiadFY0gBdw9ngae2kzEG8bdBreHe3a9xlXB+Qrhvi1NXFgdQ7MKLQnBxH0tZQuiPG/roJwEPu3OQc63eVIR11qXrl74g3T5ujjoOqmXkTThPI0G+gPEK0RnLY9HsnUtxt7hW91TmKtUPpOGIU6Tb6XQqxF+MH5s9RUdiLJL6OHN/ZWLYgJvARqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6598.namprd12.prod.outlook.com (2603:10b6:930:42::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Thu, 22 Sep
 2022 10:04:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2f04:b3e6:43b5:c532]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2f04:b3e6:43b5:c532%6]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 10:04:07 +0000
Date:   Thu, 22 Sep 2022 13:04:01 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     petrm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next,v2 1/4] mlxsw: reg: Remove deprecated code about
 SFTR-V2 Register
Message-ID: <YywzERsOcCNLvsHT@shredder>
References: <20220922083857.1430811-1-cuigaosheng1@huawei.com>
 <20220922083857.1430811-2-cuigaosheng1@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922083857.1430811-2-cuigaosheng1@huawei.com>
X-ClientProxiedBy: VI1PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ea8020a-326d-4bfa-51b5-08da9c81c9dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aaeVW4jxiCrz+BCcNO8Rck1Bypy1i5QniXzMeOde+rEpTCTGN2tKgyyOrepsPVYH0MnG7BLH39DM0+5vf5+KdP622Dw9Rn3fIKLF6ruiQtfCao++lY27uVElLH1DWFZT2JmMJtUjhwJXI+dosSXejxwPeggdJH9YFrXPoUiKXg+01LrksT8gf51nZGLxEefBPHKwf2sOfrCyji1sS3vulQD8MSJ10s41qJ1A4s1fWvmClY7obcsBJS4rFHlnQHpi2677ctfFL+QJULTUrAOCb32TzgOY93foz8krKtEUe+CJWqZgvsC7inuT1U/lUtwvn2GM5eg7JCBrOpVf9Cxs3bCcqWpAR9tJcR5yo9c+tTP1RRcKeut4Fj8csskr87Yp7YJI6yFJtk3VrbC9u3eVHCqh6Z72OSP58I/nZXk4kGSJB3t+ZvmaPAUOGtyWJ7edfT/owPk+CwLWCu7FCg5LR32Mk6ImTzJXel1Q665DzMS3ZOfPjlBszsGgniV3Ryq8ftEYDQKJu3DZPkQzuvfxyDoTjwmjar8AG1mMvDjMn35WTdSgtt3tf0WQ8ksYBjoq2dFpI4lpJYuLm5+rPn7f5EzqsygK/xH/sacyxr5hv5sHetNwVTXTYq71WzQRorHCs+wjbNmlBL7E2GQR4z7YQA1wF474tf4DJGXj2PljQOt9OvguAHlo5cx3GxliIIn0ARYRfqfwtbw+5LHsUiLJiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(38100700002)(5660300002)(8676002)(2906002)(4744005)(86362001)(6486002)(66946007)(66556008)(4326008)(6916009)(33716001)(186003)(66476007)(316002)(8936002)(41300700001)(6666004)(478600001)(6506007)(26005)(9686003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n2NKPKzmxZql+aEqlV2CijIJnjKQg1DNTycvUbeNm5T3LpaZJXCAfKfyAXxG?=
 =?us-ascii?Q?HZpvuI39pbVBmkellTG/ECYglN5OPGv1yBLIeyJ5ok12Jygp/vBabBOEpzF9?=
 =?us-ascii?Q?VNwL7d3flNkxEhlwUFIENv/Q7gtN+Rg2jNSzilV98YzlOOgK7zA2n+M3TNdV?=
 =?us-ascii?Q?u8TyvUIuLv8p6+IP2xrSdJr0CbRLNWgHvznJZi5t+oVGI68ZiKUaQ+9F70TN?=
 =?us-ascii?Q?KqWR+BnjHN+eJY0H0h4tTIQjpwxWRQWLZ4aS0edrpWehq5wHnqLYMXUaAuXS?=
 =?us-ascii?Q?eqCR1FH8OmAhizkVaWabVWlSb2hNk3ZnfdtP70+zb22AxrFZiMRBW+T9l0OI?=
 =?us-ascii?Q?d3raII1O4r+YUMxGhnpH2yDYrQKWc36ELmXfG+zVWwOlmqJq/u/rZqPt/kf3?=
 =?us-ascii?Q?jzE6hsvztl1uqnUo0QLNzmmr/nzCXACm7RZR1g4gcQ1LPETdVrbf5+GWM4wg?=
 =?us-ascii?Q?G5x2rvCvo8cDFkELqe9Ss262QAdyHpSZdN9cpdkfrri05/eY+cwnErZQrVYM?=
 =?us-ascii?Q?qlePoMjoLKdZfMaMCi6r45KrvIREHUH8l79oOW2fKIzB16nfyvXvvwtvmgxc?=
 =?us-ascii?Q?pL7WA1exUsxE4n6FmwLMTUWR5AoKEBAEjYr/NZl/osUZqRIgbLjxjULXj6PG?=
 =?us-ascii?Q?WkuMDhwISBLLK9rK0Eopr7DXxxNZDjfYIhADrjmIPznfdkgb0o7gWY32ipuT?=
 =?us-ascii?Q?7ZFVJLs1HdiZ1YSkFOiGtzGw8XslVIwa/crm/KPzoA6xzS0z+ZraY1HpJ51J?=
 =?us-ascii?Q?80wxyFB3XX1ipaZjRjmXn5bV8AvTWYw2G0ZCe9wJ+kb0E+NOiSapQtOxE10y?=
 =?us-ascii?Q?br2Jkxa4XAxiqSYIYWXKi3jZCzblFCME+HOOnjUUn8xDJKd4cMBFvT2MjJ9y?=
 =?us-ascii?Q?1pfGLMw8nRPjhTGdTW/Vk3/wiVfBtNliMsNAQr45IiMKcDJyadSMS/ru6DPo?=
 =?us-ascii?Q?6bsdW0gCqg0YF29vb01i49sMeFKUKjW7uIzcQkSmMzyt7bgU+c+xXbM9uFtO?=
 =?us-ascii?Q?aWiVVYlSneCu3CA+kVD6NBcGYBonYmlblanRXuBc6Ra+Sf5vgPLrPINzGLOB?=
 =?us-ascii?Q?xuEwU9OhCmo3epojvf40KPK2MU6zQZZ3C0laMoaAhxvw96v6Uq82Xma4B5GX?=
 =?us-ascii?Q?Qnmgv1zU6TzsHutjr7iwa2wWh4f1BfOTiPRK5m6aChpDRV2Tcb3tQuZ6E5mV?=
 =?us-ascii?Q?mdcG7rCDVBAz41yxbqsbFf1GM7g0jXWY3bkdmq5BCq+z3CK77e9o6d8p/LHH?=
 =?us-ascii?Q?+b6MvGx+aHxSoSUzpN49MLiEHaoq4GVj89nkdqOUTzGm+181ibw12zLDhbR1?=
 =?us-ascii?Q?9rNlnopCO8+AzLLmpW6PW30D9a9rw6uq95talwLZUE1JOJfUd/gvkCwXBya0?=
 =?us-ascii?Q?F5DZGVzS69v5Zc6Oj+A9ffcuRNlUxzlqft/RHk3HqWlvRpoKw5C3OxQucIfU?=
 =?us-ascii?Q?VO6L9Mkf/GlK6VfqbaHwmy/arSkPjRgsoRRBzngpxBXmVcKPMQ1JbAzuE67X?=
 =?us-ascii?Q?9v8um4fQkpsct8J42nUYHyLLz/Jp6UiO4yLdmt6ZWpDIgsQ1X7d1zis+4aod?=
 =?us-ascii?Q?AxPDqamzUJbI9Gx4aTYwAVO1aiXZIQj9YmYWZpN0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea8020a-326d-4bfa-51b5-08da9c81c9dd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:04:07.9035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fvLvYgUfAvRgeUuZZW8XJDA9VSxAME7KfIgXA+Yh1i/sSR7r6Azb6JlLsqANR100tEhrg3UflpiCRAiOrBjFgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6598
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 04:38:54PM +0800, Gaosheng Cui wrote:
> Remove all the code about SFTR-V2 Register which have been
> deprecated since commit 77b7f83d5c25 ("mlxsw: Enable unified
> bridge model").
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
