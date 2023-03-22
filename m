Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738BF6C4FB9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjCVPwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCVPwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:52:30 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2126.outbound.protection.outlook.com [40.107.101.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D2723C56
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:52:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVpeGEKSmmz1VdDTIpOtXV/eamkywP3NBVMuQABtqlaYqEYI27TtrH/CwD5dypFswpSzQ43Z1E/Bqm7N9+uGRzWLOQY79ETQjbkmp2XeHnR2qGUKdH2KRE98+FNbmewTwLAr39gskUm3f7vYQ2at8JfsXFNMOkVPc/xFOKZLOuL/vHmoRkeRo64PsOU8RrhpVS/sg7ZUjQLMXQnedDpvp1lLQYXxrW89Snm+7IAf0rnevAhnjp2OLAheQiA9qjGZOy4l2p+O2O1nxp8dGOdyRfbLmfFxbg+jDDEAUFyjBVyrXgukWqL7oi8z6P9AhDPEnMr8AXnEDgXts/Gu33KabA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwA5qk44NC/NCavrPayoLK+1WGaCkryMzpSN590iXBw=;
 b=GoREiDYs7JTNEeOdX8wcCr7z1JWtA+hLD+MKDR73NwZffcReFyplZbJqgUtvJLPTjAff+kSF7pRGzTYD/KAeHs252J+Z8gbIjiNm5hb9Oc8VBenFMQNF5hgKfQlFzfKn96zOCGtfkBYzCYAbX+fuuQwi4lj45AYGYCUdS+p43UvqHc1vgnZJ+KbOSNsESMhRzC0P9qljtEG2HXfbENJAPg9+abpbLfB+sOSswu/OwIHdzY+a7g7KVHllcAXEL9h1m75GM0tIVikpczsWsl2x8wvbhq/ui5a71vRD2zdY/P2HQAHLt0lqEpYOIUbX3luKb5m550O2Shl2611AAa7AfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwA5qk44NC/NCavrPayoLK+1WGaCkryMzpSN590iXBw=;
 b=UKL1uNu68jCKlWpuAmR+qnzE9a8+XrnoWuItHNuCERclzyiwcXr4ODIAlnTTZ4pYIjrDvApDS2YzyEhND8ualfSWAr7P6qUxewFKlEZCHUYJ9Mz7rYpPmTqsYlgUiUyG8EdzCz/6dUzVSeNcsE/uXBXoLTrA05/n8gfshn6d1pg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB5048.namprd13.prod.outlook.com (2603:10b6:303:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 15:52:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 15:52:26 +0000
Date:   Wed, 22 Mar 2023 16:52:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: sfp-bus: allow SFP quirks to override
 Autoneg and pause bits
Message-ID: <ZBskK1Hg7mqfRxRG@corigine.com>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJu-00Dn4P-JK@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pefJu-00Dn4P-JK@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM8P191CA0021.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB5048:EE_
X-MS-Office365-Filtering-Correlation-Id: c739f5c5-ec7d-4fed-5e01-08db2aed6f34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qzn/Xjwz8us47V4krxyDeVoFl92SOih1Czm58EpOhezdrrAqqK1fXngzLYytmDP743nhyscjvTDwpmWdSpptErTYrFdiG/+2wuLTJGhYQTvDu3D/BhRxmsGm1Zovru8tsa4nHgYWjIwsbpMUJdKhxZmDBKW0uhrqKrSF5Q/zPWTxJJ/3zABjrSWaEZq50HFhlejcJFQsOyeTkfTQYN2mIBRqCwgx06mXXkwbBGQdQkDVT7vlCLlLyDGIrloHZo7xTIS1SimiAGXNjMxikiEj5Wqm8gh3CVLF56krC8N5SByjjir1dcvz5RH2xpLeVyvwbZUTlCoWpH9f2ubAVEyRDyges5qPNtjRFuRUD58B3QB4RpAfo8lG1LbvRGM6miBe6g8YzGh/us8AQ9j96SRxuMRjT9MHgR8cG/IjffeygPjQQOZo96/nKVaztwaKLiUixa8TxBP0WcUPHK8nwyjJGtLKz3Y83DGYcSW0usxgdetAFajLDSznqG/uU8Z8+/vG4kld/tYSxd/NtU7sIFw32AyeSuyAOjqbhYw9WiXBfg8AFFp9cp6/br9pGsul/JDkIMABaa1tVJP63PKj/Ka/Fa/4oDZjOkpFtz3VWMjDs5N8z65ijnueklQm2PPBeD481TN64jeM10EamXgxEqc2CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(366004)(376002)(39840400004)(451199018)(2616005)(6512007)(41300700001)(186003)(6486002)(4326008)(83380400001)(478600001)(6666004)(316002)(8676002)(66946007)(66556008)(66476007)(6506007)(54906003)(44832011)(8936002)(4744005)(5660300002)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Pe776LrH9NwAt8rMXOqMuCbpd28bMllQJd2zFGfurfZnPfJdyAomfKa0+1y?=
 =?us-ascii?Q?2u//PGEoFwNfekBSktfvjow7wzYZXf/PwuUtKIqFASQSLszzuL2xzr/LVssV?=
 =?us-ascii?Q?34emUYI7miED/TLD3YHZW09/mMsh106feH4Ervx7DCq1wwcYH+Kt+0/Gz8hP?=
 =?us-ascii?Q?zcqV1hwkYVCsJv6h1y97hL7iJ/tNjhGeXFrmURO51xBq3D89ZXAwfY6Dbq1O?=
 =?us-ascii?Q?oHcT0eeoxLC2DmAb4GeA4Dras+psSBawycTGTErZJCL9LlNmNtaIsbBV7mjG?=
 =?us-ascii?Q?i+9aI/yv3Iazv73Jt5S1wCO0gdauRKtTclV2oBKbUkg4lszBZeIcQ6rlJScp?=
 =?us-ascii?Q?UKG0JfCQgU74ZCofdqv4nuDUQBPnNGBbJfohvzCsNBo2wZUkCeZp4OpQ9+HB?=
 =?us-ascii?Q?90KrQ6dX4Et2CbxsMS/BTLqWFkL5o7tWQc4pOLHdCAxzmp8IZ65l1+ncu9Le?=
 =?us-ascii?Q?sWt486W2iDZvt+i9qyYSOuDEOppI7/Q4ECfpGv6JSNrIBAo36Oc+8bWKLOgk?=
 =?us-ascii?Q?l+6xigoLHkuRsPiRfn4RnHCinApT/N+tB2gbHgk0PuPEyHE3sSpF0otBo7C2?=
 =?us-ascii?Q?PnIzTz7nec7vW/ZEfL53iYTwTLyRFYEfddQrSAt0Xibkp8mqjCKWABS0/c7m?=
 =?us-ascii?Q?4MGxUc5byyTPdZYwl2WOWZUGW+VjaV90rdL9IJSIR+0nlYy6RUcIC7C5nPOd?=
 =?us-ascii?Q?0gMtJl6FV4RFlCAfkaqEECwT4PhqV+symUl9Vo1htSBaNSMmUlzNX2uiO63b?=
 =?us-ascii?Q?6I4aRGeN8ajqG5EnkTqn8KIaN4tmyKBHjQeyVdqRKtDYHi3lxedGswmjWli1?=
 =?us-ascii?Q?GAcaKSP2Pbqi5jKnvjpVnb3cSvB1o3Ls+FUZp/W/ro3h1G6NdzDEPrKPjWkA?=
 =?us-ascii?Q?bQ09urBKBzQuu8Quf3hlm/TLGMi+UO51WQrrj5X9R5diX7vCoirZMxpe31ok?=
 =?us-ascii?Q?mvPQeRldcdmAkGiXjFbrFkTqvKZDl/+t7iutFrC+aXj8AWmhKHaoYL5avmJW?=
 =?us-ascii?Q?c8XT83jiH1C2Pk9iDWM4TGgnin44LyCLiVwV1eAtkNaSzpPRiUqbebm80/qZ?=
 =?us-ascii?Q?V9Y392+Zerc8VynC12jTodymPH3nK39oGZ71Q7Q3Ssz5PKZQqfP/54G63Scr?=
 =?us-ascii?Q?Ff1lz/xo8eqj50m0wOTttUDVDcMdBM+e59W9WVFKXRI8cp/UdiL7kyhHlYDh?=
 =?us-ascii?Q?P3lqeRoS4rpCMUZoiGYbSgAg4uQEavYc7BO57LXVIqvJOR6x/1yFLGjv3KCc?=
 =?us-ascii?Q?Z5Z/jjb4f2U0hFeHb4JhZNBcCZ8h4qyQFMdjrzuV5JPcIhw+Hv8IfInJ79LO?=
 =?us-ascii?Q?0i45yV4i6/xVkBOg9Dva4kwjOkyESmGGcKI+v3zMGdwhzC0Dk3dLtoNqTUC9?=
 =?us-ascii?Q?1nfbPi2rGAC2MqbGEYxHZMsGfdHozyPP4Sxr4J2vGEj8R0DYxKM0Miwux3Vr?=
 =?us-ascii?Q?MhEguumjweuWYhfKqFop6u5nNptFc+bblv2F4U+WRZFdMrSpaQZBT8zCVP6/?=
 =?us-ascii?Q?ptA2m742TQkfeKRlvuMPVqYU+3yf34h0tgC8TZBzWmUHGBancOFADQv0Zqeb?=
 =?us-ascii?Q?3JqXQUpnjnQ7YZ4rCSJNaQLJWo6XXRwJwfhIU0u6oPw5g1lmjpMn3WmJHN8k?=
 =?us-ascii?Q?iOBcS0mM/N34Eu161j5yC3T292sLhM9dkx1bWvHuN49GBSIVHBWITimFS9u/?=
 =?us-ascii?Q?iNvppw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c739f5c5-ec7d-4fed-5e01-08db2aed6f34
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 15:52:26.6562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qf5XCpnaFFoLd1lwsJl1qi1mVTBWXZeLgLdJF92a2TvHVYVP3IUakjDiqQiCPFogVZ5Fa0+XZ/fbNbphEmRWuaQvteSD4fcxcO5R+J7TaPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB5048
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:58:46PM +0000, Russell King (Oracle) wrote:
> Allow SFP quirks to override the Autoneg, Pause and Asym_Pause bits in
> the support mask.
> 
> Some modules have an inaccessible PHY on which is only accessible via
> 2500base-X without Autonegotiation. We therefore want to be able to
> clear the Autoneg bit. Rearrange sfp_parse_support() to allow a SFP
> modes quirk to override this bit.
> 
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

