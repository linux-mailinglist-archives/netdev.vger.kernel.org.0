Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C4F5A1032
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 14:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241383AbiHYMTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 08:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241529AbiHYMTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 08:19:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABDAB0B18
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 05:19:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lU35R1OgLPwb1j7N8czKwmUOKUTYX9bRUN4rQwAhwfCcfCZkNNV+YWOTSY/WztRulJY6ZJB+5WeHjRZSwXndM2nGIETtxas1D6PmfEDYzIM+EugMIj8vHt8XiDIT69i7PMCwAZBxsxYL2SKagwjOniDeD56gRX5InN8pdE+8rAQejfPmFiZ1U5F5mVK+WUv66F8JJghMhTd35LcCNvshsFt/8HC3pwcNmtkqnGFjEWOK2mNYIkAa4BVSNNnSWyBsfPmr/tsiEu4VVxHl/6PyaJCC86cjgq8me882wvlk2/jn+EMLJ3I/eQ7XsrS6N4qtRQJt7DIz8up/KPx9ossitQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3wPKQIEDso6Cq86pTemiM4k472WzTWAiw76ZGiYAnI=;
 b=JHClpz9Fifcb5c3ftDQRDmCf3IS3JLb9XaCQDUfvmc1XM2bJiIHd9h6KBLSHg+7ygIAp0+aIiAZH6eVchfO0XXkElnkICDQo85UUdTLnVXLwK1IUblHZQTyzpoy5ArOueYB5j5D5eZPlVlDylcjZfhvo2sg+3dA75g5RIJykfkEInqAJMdHiLZtD29RcZfj506Z/ogpe/iPNxEXlrJQIlZyLF/05JBvXiwVtLT89T446Pwnm0zC/a78sFQJufaqS+JtKNHh+UsjQSpV0WG7pBH3dFlLTT+idMHyQ7E72n7SSO9V8iOPOopT511c5sV6A/Qys0LKPcXQ2W1EtplRO2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3wPKQIEDso6Cq86pTemiM4k472WzTWAiw76ZGiYAnI=;
 b=Bi0MSZnCK6fFV9GPRXzaKTIuA2f9UvdQOmqz/JIQpk4FzszKkB23pY7foLnp5oKWfnxJL63xMUJt6eB6fNfm7EUj0Pt3TCpEnXIbcWs1zE1okJKohKB5PjmhUsH3iN+ui9T3yLMpooaNDt3QbWQSLaJk228B9915jgXBLMRKzFDRgP2pmc0GwFuy1AM7uFt0b6K8aA6hprTIvnru6XrfisOY6Tg0a5ej/GFEvLJPY+1A8sdNuYaexKsvuXJKG5NmveQO0VQaFmqi9n5ES08ysIbdO/7EXzlKeXx8cR5feSvW6RVVnrn1Qo0JYHxAaXov346Ad272lLBTOTICy/K4SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by MN0PR12MB5905.namprd12.prod.outlook.com (2603:10b6:208:379::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 12:19:09 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Thu, 25 Aug 2022
 12:19:09 +0000
Date:   Thu, 25 Aug 2022 15:19:02 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, mkubecek@suse.cz, johannes@sipsolutions.net
Subject: Re: [PATCH net-next v2 6/6] ethtool: report missing header via
 ext_ack in the default handler
Message-ID: <Ywdotl9Zn2MlBhCF@shredder>
References: <20220825024122.1998968-1-kuba@kernel.org>
 <20220825024122.1998968-7-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825024122.1998968-7-kuba@kernel.org>
X-ClientProxiedBy: VI1PR0102CA0060.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::37) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 738d1ff8-d9f8-4818-940f-08da8694032b
X-MS-TrafficTypeDiagnostic: MN0PR12MB5905:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WrrmOiM8XNI7bQNOleIg7bW6WtRojFYDqUlTjwnFu9hwFZTBlDCaEUOk9yB43dzLiE2RKs7Y41+RxHgG8gtw7yoa595AbryqIS+O2ccimKmfMvepTrkscKOjUaOLSRQcMwB4XVhi0ErievdJUDuQ1+HitbQA/9JKSdUoOHJZSdZ/ow21MRE9j63zWrYyWrWRLaC9nsy1h0D47Dg5yoBwm9RpI0IFNgEMG2YPHXflRPSPFQYuzvymC/EE8SdSQwRLLzq0d0ZuKuvELAwDzaLI54nQPza7eZL7wm6DTOLnol8nJItDfNZvAsh9CF4ohplFJmqYCxvNsxEaxsI4MvzCgioDi7jSEaAbeIIIZMXJwNtUWBb8e7EwUqEUWpDyoJyW0eZHbet/oX3CuPzYNX78tPlY5K0UDCz0q+7O3IYqK/FxvRlhFmAvQEmO1rQmaVJqwCSplh6iPfZpSxGwGlVvrZLbiM6nhgJ9lnVArHz6f+JOA/GW5YGZrxwV7NzcgXgsEFtglXSXKefE9uHSruRoUtN9qlN7vpAZJ5jshtudGSGkSpGXgEm0nNqs7U95Zh8G20hbc62RiUUFhTXM8TMMGjPK64bX/k9oMERWRLmg519+Ln0yWngHcheYRWV+zawS+9Elou5Gt0X21qXPWQophNUkUXdLFcUYRYLqNWaicRkU8QWTRWgnoW4913Sly7JcjR7lc6Mmb1eqFZDDjObedg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(376002)(366004)(396003)(39860400002)(346002)(6506007)(83380400001)(186003)(2906002)(26005)(9686003)(6512007)(86362001)(33716001)(38100700002)(316002)(8936002)(5660300002)(4744005)(41300700001)(66556008)(66476007)(8676002)(4326008)(6486002)(478600001)(6916009)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?47xaMCtgCDfLDW74E1wZNRxjU03UOWLN8g/OktW8sIeShXA4xHBu8CY5q2dm?=
 =?us-ascii?Q?NIv/Z+4oxTCj15TfdByERgnaGVLeoA/rzOTgN3q6FjddwJJTmG3RRkt0N9LW?=
 =?us-ascii?Q?AQE9nbovY+U/ix0y2X2kVB94FMDw5oczs+RrULdGMbpAZVcpvrgT2FbiBlcf?=
 =?us-ascii?Q?GyooDIcw21248/1C/WhMT19ZyN8NAmYEkd8SluZQq2bLk2PrK3JBEMnIJR49?=
 =?us-ascii?Q?RsX55ovXg6DVe5lvoaTCPZK7nUeIFmr6KozoV8JKOy4Bd33hYxNUFnNEuegz?=
 =?us-ascii?Q?ej3SaGdzmNpMvrTA1c8A2gdR53tLy4rjaNc/l1VEkAnTEnNaPaAxFB6dBmgM?=
 =?us-ascii?Q?ufoVaTkFHrXhDorj2YhvwOWbpQkxcF4tFZC6toAxda8f4uwqXbelgL5gdII4?=
 =?us-ascii?Q?Rtsd89k6BQ9uQlzcm0ZeEn3sYNWHUTAzzwwcKP4WFuVw9bhymFYyKLul8jEw?=
 =?us-ascii?Q?GTmqx6fVaAHFpVrGhUiaMNSE7rPND5QqH3WgybeL73bOVORCnjvPD4Dkz08c?=
 =?us-ascii?Q?l+zysWe9n/GAYUKwnb7KoaCqEMd9bvPFvF9LaJ7fz1oOvu7LA/TWOousXB3P?=
 =?us-ascii?Q?i/TXKs8v6RxUH0Ba+TgFbxpeamcJPpB7bAp1HYIgc5OVgvL7LX6Vb+AGPRPL?=
 =?us-ascii?Q?2NVCXGWsTKU051q/mONfpiijQfyX7oU716CAKQpZvH0vxdMw6rOtVueVvzh2?=
 =?us-ascii?Q?p/ApWGtg9qxzdksVfvKduxcDDttUxYR51woROT/NlK0hdFBzH5UuTcmZj83I?=
 =?us-ascii?Q?P9m+1qU9tAOB21+2jCGg7e0ocxXvq43E0RBNBbIUF0HoHDWwZNKehTd1jP+I?=
 =?us-ascii?Q?3IUFtZD/OW5hI3Y7qtjJD1F3xXyDmIKXMO3vfO2HuSbtEEWv8qCwX++wp9HI?=
 =?us-ascii?Q?LWYeM6HncbfFXeDVcvGyyKW3HwS8cDPGwA8puXeyTe4ujT154aExTi8SLghw?=
 =?us-ascii?Q?uC1XiVWVfmmUgHJgr1GBpS5IMlBfAWayr/TB0bRd+fnKKTurkXc+UGzaWaVM?=
 =?us-ascii?Q?1HeqHdOx0zN8uiCYQAL/SrpWXLs+ozsrAv+eoz9jiNFtMcNphvdDzgYCMZQj?=
 =?us-ascii?Q?kO+RpBHn4B4ntxMWebSRKkgkVRelcA90lAvzxq6lCT49WrNd6N8ujBHU3mTn?=
 =?us-ascii?Q?GRA5MW/WunwMPXFmIlUaeyZCs+u1pizOJICoTRdbx8yuuiUzjSv+WXF5WE7S?=
 =?us-ascii?Q?SBz44cv4voGLnogA4ZXLKTbt+nHpBqkqEmV9oyhKcrEDHL9Tzb1gywwsWvKY?=
 =?us-ascii?Q?M0yNd5+TkQHsj1mr1FSD5szo1vy7lWBPVigCeTI0AuEIF+8Eztna1Mqf8goW?=
 =?us-ascii?Q?CD3X/BAuTzBnkisWtgsJI7fAExvCCWXSunsEpr4kEyzFbXklsrKzsmjzBR2j?=
 =?us-ascii?Q?oMFK6DmiQl6nySyfO8TWXJluAjvZbngs0rHyXh1CX2NNIxxLyuutHlfb4Ntn?=
 =?us-ascii?Q?13vDfaLN9LPHWlHKyxtU3/T7NDSxdDC9FXfvj8nrO1yv/pOjp97y+/PUyj/7?=
 =?us-ascii?Q?G+Two71tCDttzG5BqN85dvHRbGwcyz2gANNci69115CHhu5WuGFtqc+y0xeP?=
 =?us-ascii?Q?dwQ/LfjAWhvo+JtKSawEkrvsLW7bgY59CQEsmM4G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 738d1ff8-d9f8-4818-940f-08da8694032b
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 12:19:09.3909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2rBNS4WU0+3u3kNvaVxSuB/CSltGc6iNydToSUOFsFw/PKKlMDAqxy8cVO121m8idaBZ3iERBpnyGrK62Wd9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5905
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 07:41:22PM -0700, Jakub Kicinski wrote:
> The actual presence check for the header is in
> ethnl_parse_header_dev_get() but it's a few layers in,
> and already has a ton of arguments so let's just pick
> the low handing fruit and check for missing header in

s/handing/hanging/

> the default request handler.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: idosch@nvidia.com

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Nice idea. Wanted to ask why you kept the error messages for some of the
devlink attributes, but then I figured that user space first needs to
learn to interpret 'NLMSGERR_ATTR_MISS_TYPE' and
'NLMSGERR_ATTR_MISS_NEST'. Do you plan to patch iproute2/ethtool after
the kernel patches are accepted?
