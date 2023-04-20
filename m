Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FEE6E9838
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjDTPVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDTPVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:21:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2126.outbound.protection.outlook.com [40.107.244.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FF61BE3;
        Thu, 20 Apr 2023 08:21:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMyKInewMsFES1A9X/Jm3xVkWu3710Vq8ESaHa2XB/lprvReiI/rVZJMu9VgW+ZdqjxLO8LE2+OAsu42TXHJC3IQh1Y61gVBfpft9WlXH03/CL7KKres0oGiCt7RgpZA5/xCA/yXLPznjCRe7i7Tv7sZPUOxObo1db/crIKbpPRirEeAOuA2W7/bWaE1+kV4BuFg/AVRc0GmiXL3CPJ+AGOLcfiUNUa/WisJTlF9D1lSvlIKaVzSmbI9gt22WMM/fxb8M3bBmC/grD6vMkNcsjOLvVcZg4k+G5ofZ9EGpnBy5aBYPP5rVSNxD591grv6sCJEqNu0UgDfuH8iZb9DeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZ2/VRwFPUyzVd6B9WjI/1wsrxbmLXWHjuLUFONP3X0=;
 b=kn6a5oSD801HUU7BFfeN3tsR+TKpQTyEFV052Udqd7O8iMniOw1UNv9NWRf3KiUKVLccsAhSvCOBLtjsZMmzCuL/Kff3FM1TKZ4KrBEX7SHXOnWKDUqFC93wxWWvk/Ggywn54wb6rFeaKKGJugPR5jUV26bWmPg6EeoHyo0yflnBsH0WxJ+Umq5PxmWXGCdcdQqT5tDUpuqeOQN4G8Pt5NROe/srcR2GumWpkVMeCNtfiBXtvTIpLV8Hby+u5c+0pFPlYBdItMrh5mryKmCJUf28nToy81kkmUBjW0zwzoY7oYXnnWqTFE+OA4qGPQ/7cyRVG0o7KvzwGj0T+QiGow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZ2/VRwFPUyzVd6B9WjI/1wsrxbmLXWHjuLUFONP3X0=;
 b=sp4c1Iy/hijFQ6gn3z+qzHCcwwmkq2YXCNQaWu40Xh736S7hiLMj6hT+gwWG+t0HfKyBf4nWs+Lnr2792wmQ1wlk9XMkKVG+E2pvnBS7ZKWZhwB/Pe1L/toWimkN77B0Nd45NHXtrrBQl8b2ZWp8VuKJ+UzDZW5EK7H7RvGj52M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5126.namprd13.prod.outlook.com (2603:10b6:8:31::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 15:21:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 15:21:26 +0000
Date:   Thu, 20 Apr 2023 17:21:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net-next v4 3/3] mac80211: use the new drop reasons
 infrastructure
Message-ID: <ZEFYcQ08MtPJSZJF@corigine.com>
References: <20230419125254.20789-1-johannes@sipsolutions.net>
 <20230419145226.b2da2f556187.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419145226.b2da2f556187.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
X-ClientProxiedBy: AM0PR02CA0151.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5126:EE_
X-MS-Office365-Filtering-Correlation-Id: f5d67d12-3b19-4ec2-70d1-08db41b2e89c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PtqN6AfeWDgLymKmh2y4Zl78erzMmFuaP7HFohHhmENDCZPHOeLtKsuS/ko1QZJMYqd/sf7M080kb9SITbZ69kJzU3KVBQPVM3W5eLO+agVP35WkwJxrvfSbiWrrGCLrCMcOLkgf5ufdnFE+xcFG2X1/RS8KVv9IeBepNC4L9qMZqE1HsRsNt54z6QecVnpUN39RJFVl62Azb/6Q3QDafh96CcInhdT/rtYOz/wCTQQmDLsL5tYV0crQKnQvubJNFigiAbhDmxfwpBVw77uHS76YkiX4YI4bllFsESiB2P2UWlfGZg+xkvcomw1eDQD8IV0dk3GN4De7GbZqeT6KIrdrLGLhffoLIlCKIPv3xdi/qrhZqul7eOTUpPQpF4sxKAETvMSIZ6mKTN7nuwEyUJTOXNzUkXVrqP6Vmv7atKLOUKDa6R1oxSkdjWxGRa4WqXpw13SPLScYDOjJASJeRb/0Ss6uRFvLBGlrS5BVI+bsJyqkxt3+Q5fR5wOoMoZsVqmazpKvWZ7ewKv0SfrnIg28i4hyF5h3OIYKs0TaWCNS/DKMsnzMWhnMemvLjlVGPs1N4jaJFTOBw/bqkV1a8vB7CeNyqz2HvKuaWUarRo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(376002)(396003)(39840400004)(451199021)(2616005)(316002)(66946007)(6916009)(4326008)(66556008)(6486002)(478600001)(8676002)(8936002)(41300700001)(38100700002)(6666004)(66476007)(44832011)(4744005)(2906002)(5660300002)(6512007)(6506007)(186003)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T8hrOOKAcgQdXdixWpGsLXt0RYgNLDHNlU5t9ixbyc8yEZszn+w25LK6iqaw?=
 =?us-ascii?Q?0I34e6Riz1ZoLVTFOCmkLchzHOPIlgNEHOSWZCAAkk59auEXAtDsFM0XoCZa?=
 =?us-ascii?Q?pAv2j2988GqQGLR6W4R9B2/cPAbOoVELHtX7FtK48DI6xjXlpdGDAK1o2Vkm?=
 =?us-ascii?Q?ZUTmsU03HLIG1Tzho5m3yW4GRRO7TZirejI5XqECWkFIKYvunTX/+PBWRiVN?=
 =?us-ascii?Q?4uvq6KTN8Eg1LXjxNXxUn9ms+JQnNm3Q2iPDxNwcBWxOcMYibfntAE4NniDb?=
 =?us-ascii?Q?b3alOCH5jYXaFpw/VM/Dglc9I5M5BKE3Z4ihT86DjTe9tsjHmgn8xqob8yQl?=
 =?us-ascii?Q?14xse+NFJYJXGF8EB1D0fNQS0/PILoOy6jTLMlcAYN4lM/l6e/2/d2Pzntvh?=
 =?us-ascii?Q?/1/SSVEsiEjopDESTfIk/Cj15gsBL2nbuyFFo7kFnQxY3kiF3FIdWK234u+n?=
 =?us-ascii?Q?n9j1y6TpnCNnJh/f5ABV+4z234hGVaQnR2xcXgb2lCeNo/SB/ZPkW72Fmaz/?=
 =?us-ascii?Q?OUSl4Ca9i67gzdAFQB3l0v9jq+KVdLzk4F6gt7VDAW+zf7g3G+pGAgAcweOU?=
 =?us-ascii?Q?OIlIqN7+zn87oAid4RJKRxlZtVWfHS883IatiMyVFijsbKatnSMIKW/duwwJ?=
 =?us-ascii?Q?3qPDbcyDSDZLmpCFwpkaHQyiCZcBSuFhst0rdtycrOSh1yh6ExIBTxR1BEoT?=
 =?us-ascii?Q?YA1nf6KcAlMJxufszpH5Efb+1viOOhhDJ+IjlO+Eejp3CY56pB4FDyPqgp1A?=
 =?us-ascii?Q?371/nXv6KjcpxpMmSa8iEOXrgYVk5j7o9UvYHeHGPL0UmGoWukoEplLkZ31I?=
 =?us-ascii?Q?pvbYmbIgyspkh1zGHHg6z4JN2B2596+Y4b2a7Hp9u7vS6T1KP1eyZUo3MDqC?=
 =?us-ascii?Q?D70azcxryDlKOVOnfcJ4c24ryRs7QZbjqqyrtkeM9NIvROAXpPGmzpFRvIKf?=
 =?us-ascii?Q?Tzx0o73REMnI+WL606vh+CYQwyl5HTceTftSGk7Q3qOVyxlSq9UrUp8+Gul/?=
 =?us-ascii?Q?JFNGx7Ed0Swutvz6QP8LdkKYriqDQjELtOTRV+5EP0cK9zynbtvyM0oCI6VI?=
 =?us-ascii?Q?lJH9DlT1JsW249Yhr6g/AcsAZj3w4SphyIF7aZiN+kh8RzlPlXWcDzTQptd+?=
 =?us-ascii?Q?2YPYpXYDevrFQVDMmrtTSQ7imFNZZDluQ2Z+c7dGw0nnuT4e40QycN/pX8PI?=
 =?us-ascii?Q?efsrX1JFGKAQAkq59BNngdlv2elRY2C28UJc+R8MamTxDBqYQvi0FeUPY7FH?=
 =?us-ascii?Q?HCsJ8qD9jbo3HE7ZKLyoGTYpJ19BFFvkJwbIHnIf3medBbHwaido+H02HMQa?=
 =?us-ascii?Q?ZSIuIN6NMFyr30NFHMJZ0tqrugN+edHyp2XZoWoKM57gCmZUzUuH07C/yH0h?=
 =?us-ascii?Q?aCVhVg4lFjjuTr7HfDkjBhvNDnIsgksLDKt9PrMu6yL3G16aabtjU9fJXd5Z?=
 =?us-ascii?Q?PsiLDZsrrwsg1AJFvcfqRY4fdIDp4fvj8Xkmn88nT68lDBODM7gcrjwk++rG?=
 =?us-ascii?Q?3ui19An8uH0OYXVWY3TMMh5urmmYmYHNYZVrzMaBvOa9wc8N6w7E9Lxa1CG6?=
 =?us-ascii?Q?L6vQvXKjNNRBeH6rHB44PcKUnOOdeeCbkwdTWHFC6yDpyyaBgdwiszHWD0/V?=
 =?us-ascii?Q?HlLoxcf2Iho9MjMZYxRF2NR2xbvHGyReP0FZf/5i7jd2UM3F6yjPUg7xE/zh?=
 =?us-ascii?Q?uIhPOA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d67d12-3b19-4ec2-70d1-08db41b2e89c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 15:21:26.7536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Q32hvca4UkuDBZqjNnJaoeTJFNTQbXf5gEzmSkLe8LlPrb2SqnEtvRSCSTnS1eHuxtLZN/pqMKoTGfemNK5uObxAnGwc/PzfZoQ89KJu+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5126
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 02:52:54PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> It can be really hard to analyse or debug why packets are
> going missing in mac80211, so add the needed infrastructure
> to use use the new per-subsystem drop reasons.

Hi Johannes,

a minor nit from my side that you may want to address if you need
to re-spin for some other reason:

s/use use/use/

...
