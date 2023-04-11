Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC506DE11D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDKQjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKQjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:39:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2139.outbound.protection.outlook.com [40.107.237.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9954B10E9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:39:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+Df++0Jdmb6ZjaTOCh6YesydYaNONO/uaAvU7t8tfxkJ6nAMx9H6xGqKV+ylR9uIPv7/I0eLgmq7pW1Iew7Imq6SoeN8oDNyuQTzRfes6FDOShHIlHOItWO+lzyuCz2ACy8rHPvtUkVLgqfwLyk/htVPKCMbDcGuOHh3ovsgccwEZOHL5Zbp09oqJBrrFv0fes3ZcEEY2k4NMxQkazeS9hkWi28uWr/cQHAydhxTKrV8O2lMhDEEfrgLb0KWkCVPDgI+29+2eyIl7fAbuhd/p/vFuZHplmBWiNMRmpAgeyPMreMKih0eBsZKRNGyuGVn5EvmWElQvhJF6R/TSbMEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rO7ROPI9ABdBghqXPBq4aIGHlyPxO6lr1ucKP5LK7n8=;
 b=cjkpiGS2FkQ/g+08WApmfhYvTKK2SbK+iFjPYhbyKu0qv8cwwI77nkhvSAD8en5BkyY67CVfbfwgiJw4o49s7xn1sS+qT8NcVHlGbfKynfzuH/P3kHj5/LBFgWNBMqiU5BSILudK2jmFL8LhRThy41nOYHV7xQ6GIGh78M4RpKw3Yr869+IC4utwpsDlf+vgPIRuoK2JIHJvLYnZIstxR3jR1al0JCrEWpicP8VQj5ttVXUPvEaRJfdUjwV3NcfporQsjNSv+OTyXBUUMArnxe+PeTwxHs8p7pPu3U7jDg8UNzWc3uEy9vpx5sxs0WDGBq13Ag9OYTcPCeIi20XcPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rO7ROPI9ABdBghqXPBq4aIGHlyPxO6lr1ucKP5LK7n8=;
 b=BeZ6GEksLim6NbqBSIQFp/lAxWujFZ4QjWJa66TB/s1Cd/LWdYFwyZn8JdOlV3pzWv7AUYw6nsDid2HRJUjxuCElJI2/1nG9ScBESKzGLpfOWs18WEghvk6dMkiegZSkDENyfMzINcVC2UVMWzIiVUN728Hpi5tgUPGEWUn5fC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6169.namprd13.prod.outlook.com (2603:10b6:510:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 16:39:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 16:39:37 +0000
Date:   Tue, 11 Apr 2023 18:39:29 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 01/10] net/mlx5e: Add IPsec packet offload
 tunnel bits
Message-ID: <ZDWNQbj2tsOK75SF@corigine.com>
References: <cover.1681106636.git.leonro@nvidia.com>
 <08b748bc72bc0256fee7c2280245ac2ab4e874c3.1681106636.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08b748bc72bc0256fee7c2280245ac2ab4e874c3.1681106636.git.leonro@nvidia.com>
X-ClientProxiedBy: AM0PR02CA0120.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: 1846a55b-26bb-4aff-1bd6-08db3aab56ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7E5sgca7OZdOrHM9NlWxjnmzhU/qR4GDOFILfZp3F9jcsf+ciHUmad1Fek2L7/GzwLWBFEOKMq4YSnIV+1fa1JBuK4AOXqSvBIh4INwPttroLonDMs/j5CfytMjVoqYdz4ZOwSfbB5AWOnWXFqq5pYGLvsmC09iD21pnFQHV5Gt0ef2o1DeI2WRClnQ44O5ANu8WdlDMabjlzKcxhLfH615bcNbwt+D3EG5fZNJEqJxQcf7XAghZKMOuAA2v6Y5bAIqc7wlM5brbaVWtZzGCF1ILUsN4ziHNZcZjeRapELoiSWvvCqClztfLj2cElVt/pAAI58digD08+g1e2byQfObscTIJaxldUm1vR+yYy45RCW2q/ZvcQVg/botNOvLVR3EB3y/w8bco1V7vFHnUY8SNYM3Ynk132PGjlfRZGu4DLCyYO8vxFkJ/p7okIlTngaynp72WEq48I75Zvo1Sp36sMJ9OknrTQxDJGV3K4RmuhmxSme+MXaTvCzTF+8vSuG68ZNiRjliyRKyI0rRyUzG8bi7W3lg/TfOH7AHZln2BoXXcq8S8NW00wKxtO97N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39850400004)(366004)(376002)(451199021)(8936002)(2616005)(86362001)(66556008)(66946007)(6916009)(66476007)(4326008)(8676002)(478600001)(38100700002)(6486002)(54906003)(316002)(36756003)(41300700001)(4744005)(44832011)(186003)(7416002)(6512007)(6666004)(6506007)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nfF3BE3m07orSrlx4cn3ggKfskYhBFQ/ESCqNKaMl9u3q/MlNo5gWtkeOKry?=
 =?us-ascii?Q?m4gHFajiy4qk4X1pibAh/nsUeqnY2EN1oa4SS4VHBtTZ7uC2Q90v1FuLL08/?=
 =?us-ascii?Q?UCF/uCXa4YtKG1wDinP531rJoGOnCm6WOnCB1Tp3+ovbBXwMSr1PoEQCtclk?=
 =?us-ascii?Q?j1gHC7sIAqhIEzRyER7FEGV7ykzLnpWjisraCFfIlLB6UIror8QZvUWyNFZN?=
 =?us-ascii?Q?X6SiCiLGH1cDb59SnsWnTzHKvlHy/m3TVidEZJ4Mrcq61D6yllaPkQe2b6eP?=
 =?us-ascii?Q?fCxHz9+SmZ2F/+q2ykoQhdACu0dSSIJBxKBV41l4cWM4ubyoEMken0clgANE?=
 =?us-ascii?Q?MyJ/c+jOTTBnnZATRVPufhM6n1H5977l83Ftf6CR9xE/8nPuWltA1T2u8z8A?=
 =?us-ascii?Q?SB+KAnVGH0wYwu0kbyqsNWd5fsF8eqqRWKSzFVOQRL3UAmGJh28JLreiuWqN?=
 =?us-ascii?Q?eJehnsC1o0K61pSs19R/7LcoA+PbLmcoFj6rrB6lYi0jBFzPrQhMHoQsJWuu?=
 =?us-ascii?Q?Y4dZi43UR0iBu70OfHUNPH5ST+ZRlLfa3EuJ7+cB8cEWir7+yVi8z5op/z7s?=
 =?us-ascii?Q?3F7+WDFba/EbR/xLguKChVCU0Oof6itYvFKheiRV5A+avOb7dgBjnQS/OpP3?=
 =?us-ascii?Q?DpZ2wPAf8HKnprMZN+c58vFTZFFzmw6R3htaK8kiOB7ByolwuBfq3ylZsf5D?=
 =?us-ascii?Q?7C+6lQ0xEiUSbBUzkniLOKf5soiBd/FkWSroRlhMDYHFZGF2LGaqG2DyZibW?=
 =?us-ascii?Q?MEWc0H6F/U+/Xl20rJUDeySJYuD3h8zi6baKvp62E8fX13krw9GPTF6+KDTU?=
 =?us-ascii?Q?wIclu+HwXLry0ncAtDv7oSDFm3RYubWgUUay1FYJ9Vx+Pf1Ot1eTc22k/6iN?=
 =?us-ascii?Q?n8JfA32nnqZKltYUDaYshpFp2VyCC0YvzPShTU/daDzvDXSN/f30uLhvSBhZ?=
 =?us-ascii?Q?K1DrHResrp8+IUEuIpIz59VDa7ohd9tCjis9C3FVrCE3a/uXZTPCiEmGWzNu?=
 =?us-ascii?Q?2bAOFaQWEJExDd6vy8IjZcxm7hlLJdoEvaUHfZKcU53uZ8tDS/ok1LWXE0WD?=
 =?us-ascii?Q?5KNNpdaQJ6SjwUVuMPa+8jTjSYe0YgDPP3u8JD6MB8/+Mxtyi/q+E+HISPFh?=
 =?us-ascii?Q?bh/46ZOHuzgghqlD4MVqIBrMC6tjDAVjZEfIsx//EmL0j47nuCOFz5czG9Q2?=
 =?us-ascii?Q?MVlK10rCVzmYbmvrr+nvKmBPalpC/OEV0eTAgbnmbBO6EafetMZwgsGs3Q4S?=
 =?us-ascii?Q?hVBNIkcw9lqXdU9iuqjOCk4bM9LtxND9vZN9yrdS7DgTj62wJvkNUCxJndA4?=
 =?us-ascii?Q?MVQwZ+D+/2hUQzO1ZRIzfe+j5E8A6tddnu7Gq5nOhQiKCa8C7OjBPe8aBoTk?=
 =?us-ascii?Q?zf4Q7tWY8dHHqbqZCFa6myGmUn6dOKHNnm3AEv4Y3QON6jPOYrjYMD7+IYxe?=
 =?us-ascii?Q?/EPafOX3IwimXLFz+vh8GMjfQqFAGyUF1+AxXv/xnsetw3gHAu5bV7zPkRpX?=
 =?us-ascii?Q?cWNtSjlvKrTvorEAbatW3AAvbWovbiDQ6CYzeMzbtI/GTPxV8AyRNCb4lDR3?=
 =?us-ascii?Q?xu2HB8Xh6QsxcgX5Oc/5KFKto3PeUl29yAaMF0gdN6PYH+utm9+0fFmigEoP?=
 =?us-ascii?Q?yaMhI7nIhggq54rLCSoUesjEDXh8iWXfLoa1vA9uCc0dMDSVbuzpQ6HZoIAN?=
 =?us-ascii?Q?morv2Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1846a55b-26bb-4aff-1bd6-08db3aab56ea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 16:39:37.7213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdNXhqhsbbxh1U/GgPvFkjkkay0oIvEZwaC/FWlmE7lIgU+yF1ljuY5+JZaXWB6CTpliA2KYDwnnAjEW0K962RN+LRqswr2vMCWreZfb/3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6169
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 09:19:03AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend packet reformat types and flow table capabilities with
> IPsec packet offload tunnel bits.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

