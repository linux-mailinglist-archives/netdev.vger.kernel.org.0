Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE236E9819
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjDTPLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjDTPLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:11:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9545581
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:11:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYdihCmuHiwbPind8dQh/OC0t0unVrQMHBw8vwN27rA0t6sENM70CXrliVufDUoTuTYEsvjfCwACqMLtc4SMcF0mjHRQe0COo8etoiJy0KEFIM+ZI8V8yRAHqS8ZukgTtFBXhuFwpCGEFDznKNUZGqq2ZDxGhkGDtHeOEDfP+e8lRCQas0EHh6VkxPQXOpyuUf/hbMttOzG8ZDaBaGDdHchee2O9kGlZr1ZXANGKXFj21QyyiiEOaPOL2CfDWRyPCo2raoNmc5PSRf8rPsOQZ2Vpqc9+mO4HGrw/h0JNbl13xnO0Jdqg2GW0p81tm+/mXWUFJp/3ONnFomSNltGHcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rH82NZ2B5LPmyXQ8GQbnq6SgNW2n7iFynpIqfHvuNI=;
 b=e4StCFS4bwrjz3/iEPEBa3ycXb2Ghfyyv4hUit2aurLhVgjCFWqLKiAmTGVakIUlDGjiE1AMYr7zQHShvFt8hpsei29cIlH9l+xCPhu8kfIXmiPjlr3vTeF31/XKnqV+1WPgLH8z+ly5U6qHVCMY2r5Gg7z7wyxbuSNbQMrrEL/UEPIsK3Q/J/Cz3GmJBzLHIbRzvNGItPW9QkLSe+7YUHlWfngtuKiUBEtJHlVYJSJupNGPUvqNXmwtPDmnbmtxulJBjevnlMdr6yG1pHhW93uzqGy+nQtpDC6M0y9FlE23Dbai9cdKcPQbNbZSmjXW5n0uBC4bsf76jzul5PSoXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rH82NZ2B5LPmyXQ8GQbnq6SgNW2n7iFynpIqfHvuNI=;
 b=WIfBe8C85bYWXHpoylROvWXcxCKsmr4EQ0oLL4Tyt8SA/5yrFip36eUP6Ez2LLkaPhSm6+ki5u1l3IoWw2HagSjoXqbrWHc0s8LRotcJkQoJhypLeIY/buNShUp1WJBipgbBDTZCaFE4fXkLM/IHtKSBJVQdWVn5G4H1hbAhyWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4419.namprd13.prod.outlook.com (2603:10b6:208:1c9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 15:11:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 15:11:02 +0000
Date:   Thu, 20 Apr 2023 17:10:56 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH xfrm 2/2] xfrm: Fix leak of dev tracker
Message-ID: <ZEFWALX9YrCd32hk@corigine.com>
References: <cover.1681906552.git.leon@kernel.org>
 <dc1db7b00f7a9f18edfe4148dffacc2a5381e824.1681906552.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc1db7b00f7a9f18edfe4148dffacc2a5381e824.1681906552.git.leon@kernel.org>
X-ClientProxiedBy: AS4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fbf1070-a3e9-4ac5-8132-08db41b174a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YP/oSAoYgWkYf9Y7JsmnZNG27RBcuezaeA0xMf+NtLe4vbcG+Utb2qhxmcCIGoG6TFukZqPU0Uvn1uOzIGqSOzeQ2DMXG9DLKknGjvGL1AM3L54QBz/MkKowHK92UamCmb1buM04DG03dTUFa37Y5sY5awumZBa+WydTgxRGGPgYmFb1areo1KnGfPGmUMvSXzVttdClL4HZfgvLYmkL2mj1ws6BLqz3Qzo2saBEjBunMvcD6ZwXuCv+BKHhgbnwjmkEop8E5LzIprQoCp2YHBUDEt7inxIwzRSBU8QC3sTlxpsCnPaUzkPy5Ks7IUWhe1JMdfNhef5I99wfOHrp/fY4UMFbMoEPfB7SR/ybp5sya7pe6nlj5koT/g3ATnBEf6u0Cl0NJFHFoIpPd9kXNHeIIVSuwYHLstWJXuBgUGgHrha2xuUpTjAepJV/wwwi4Gb1KcgZNllrL0ECPYGODLppd+ZG8uHZ9ed+HJHwN7zk4U85MjApnZng4czL4CyFV2tlBKGXUgzlmoMC3+gPFatiFsmAZ3eoROnYksiLC54pcKccnLJ747NesAu4Ok0P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(396003)(346002)(136003)(376002)(366004)(451199021)(2906002)(8936002)(4744005)(38100700002)(8676002)(7416002)(44832011)(5660300002)(36756003)(86362001)(6506007)(6486002)(6666004)(6512007)(54906003)(478600001)(2616005)(186003)(316002)(4326008)(66556008)(6916009)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O7Rl76rkz1y9Nj6BVtben19paZ3lio+OxYqjA9N1gTjeiUUchRHqWyGrb58c?=
 =?us-ascii?Q?LT0gJ9VpmHlIvpoRFT/34JPF+RR50vIqCieVwUvKb7++cS7ONvcnrMUz0Flw?=
 =?us-ascii?Q?+VXZa8fR1xIBkC8CIR6j8MjmTEMl1wHOEEydXjOpDSSUH7rS4S+0bptj+guQ?=
 =?us-ascii?Q?Ol0ydg/8pBphUCIIqFtBQUiY4imOr0sM9bvjSUlo5b6cFD82B3AndKqsl3jv?=
 =?us-ascii?Q?lknebepdHHAIwZOqvU4wRBDXMIEZEZ1TtmoD5SWoUFh6TgNoofYqhl1sDaYJ?=
 =?us-ascii?Q?K2OfqVgyVsEA1/RdTrrXzrLsL5LzSIq+omEq155m8yOu4A1itIUTt/yRmTjF?=
 =?us-ascii?Q?849d8H/zkMj3NBNLE+FlcGCNQjWAG0xiWUAh1nQrzZnQILuB0mb8rrYaDAMo?=
 =?us-ascii?Q?+f5NayUZ8BmWUhfEwobCJUtbVrJUiS8aVvacomqK/9nYXz9pUWpyY7lxq3vS?=
 =?us-ascii?Q?8Umcnzty8B3qfsE3mukmTn2myJMf7EogX3jcjlwG73UZ0mAJCldFpn0gSjgy?=
 =?us-ascii?Q?BfU4VAMvxvaLntJnruHjop2RUjqmV5NEUFpXAC9VH3xmnnTTTdZfDzyV0Vm4?=
 =?us-ascii?Q?FkvKvnZibrw05kDjqgpmPOD1Vr+EcGk6lIgqRRcpbuNqQmQFuL5CUaIwy0Zj?=
 =?us-ascii?Q?U2AbO9pqmnTZrgpOKFD80wjPkaHAEh3yPKOPv5ETzVkVmdqJFRnFEfFC2nOk?=
 =?us-ascii?Q?DvJDVaG2kIcq4bwoPxNU1wfxoBAvKVqx0rhjPwjA/N8h+LM6p+axhQw1cqcZ?=
 =?us-ascii?Q?I3dWpLZF8o+tS6EvQQjjdg5WHuXjaYWw5+pq5oJDDeJ1hUl6Xo3GGN87Lf4Y?=
 =?us-ascii?Q?8uz7EbxxmCfXoVLaYETcJEx9udUFOPKBCsTHJwzyGadH2aUrRFecyhECPmp9?=
 =?us-ascii?Q?AvVX7aNEO5JgETPHJdsg9k6hC7cPVKJrqNwvdETybdr4otpgIncoUYU0HuB1?=
 =?us-ascii?Q?ta+61jRKG4SZsyRfKmyktomYd7uLSF7vwqhQDIS4HFr0inZNeO04+DwnvOzC?=
 =?us-ascii?Q?7MSLlSeqWSLWKg3bIND7CdZieaymsQbr2ofRWdK3LgGvPQMkeuRP+gH5GBQu?=
 =?us-ascii?Q?z7k1/m/CdHDdEW7OQke3HUVDeAsHiE1mKT12vaVafrkcCWiXzoE0AOirtLxR?=
 =?us-ascii?Q?RsfMEnAAR00uKG9DzTf9DJDte2X/naC95XlQRRho102b+YtoJtnbd9Q7qaLv?=
 =?us-ascii?Q?KkoYmwUuYEU7I8qxYVniK70juh78s7ohAhHhdlSDAcvqTVxcyEj/JASV8R4Z?=
 =?us-ascii?Q?mfFK1r5lHf+ithQj3KLwtCjGMHBVXn0EFV8g6P/smkSZ0hb5e0KmVGysYRWY?=
 =?us-ascii?Q?xZW2j4h2ogrMXCGAgwLEgnjvTzI9y4sV5nk9ARIcwZYRIFJ+gp6r8fFkUQ0A?=
 =?us-ascii?Q?iVjLaTF7PvpFXqSPNlRZDV3dvX3wQju2T4/t7IG0Cg9AbyIa+rDOfAzTrU/z?=
 =?us-ascii?Q?GymIANGrG0BVfF862ZMoGLfd1OExotEkTXlMJrjmlAMJilr9nzyw7L01hStm?=
 =?us-ascii?Q?HaK5CNsPQlI3tXbLjwIXvezthNdsbvnPDVrvO/59iD7L2tw+QRFlI2/DB/i+?=
 =?us-ascii?Q?st4Pf4Dv8mm++XPoEyY5pArHHvaVlopq8CwnbAKapGdvb31LUAtuMAagzRPu?=
 =?us-ascii?Q?zDD0b/Cs6GUpKVDBgtK5VfIBFi8541fWmQK284EPXfYO8m0Z6LSk2GlGK0uD?=
 =?us-ascii?Q?yuMVTw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbf1070-a3e9-4ac5-8132-08db41b174a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 15:11:02.8321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Aqa0ggotI5Wega3VOUt8M9iokmw/wz5DQKxgoHdK7W1t/llNdofg5G1bcVzePIz1RzfqbLgDgUcLST/+7ag296oRIvI4Kydsp0DeNp3sxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 03:19:08PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> At the stage of direction checks, the netdev reference tracker is
> already initialized, but released with wrong *_put() call.
> 
> Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

