Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93906DDA0F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjDKLuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjDKLud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:50:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2139.outbound.protection.outlook.com [40.107.223.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8393A87
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:50:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jplH0EOBTocDDgL3zyt9/ZLSpNe35PquTC4nH+VU1VAIqrcUkbfpeEL9FuYPmnZCnBnlC+n94dm+XWtDuLdURn+UvZhAehIxvBeiPBAqxUVKN2cH0PkrmQdJ6ig4qIj60+b8eGRsmb4nlfHjouRyZHDSrj7OjEPNvHPDlgB80DgS2cc33VZKmT5HVXIztpcWE0SI7DyyJ7NDhc8fGy7Qvegqbz1P5UAHgktaWk9yemqQu5pT0zEP9y/MjJkCeIcN8sUax3Sa3zZGnVZEhPpqlJtUydOtMK33/H6xIP7TqrhAtGNeFLTAsrYGiFCcx8outvQ6zwfaOrkNYvJugmTOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fEH4k9ceb5/CveOrNSSdcVPzLo2N4fy3U8fdJ1+WPCw=;
 b=fCx+fVbAP64lzERPZDjcvgRp1MP0E66ILUwJETeu9AAPXKCYi9OKtOkIec+NSA2S1luLw93mZDxFJIgTbNNxIotOSEyDJDs5678er7dydE+g7GH/eaD9p8Jqmr2ecZtanNFTwXY6v2KGJVQYNLfKTf7UkCOWgn6YNPOkgsBZ8ycRiSnRq3yV1M1TESct0HUEY3/HLdIGI5SamZoWOP9TiNksR+KF3mVdxhu8fAGFUNS0Wr48SwF+CLvq/yLxL7RXcd3+eMY5m7xvhIm4EspB4vBU/BmbWcQTlTqpOwb7RARAd/LpOHopZpIkkhzay/+bQHsXjKyEEEzHCZIW9vYDFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEH4k9ceb5/CveOrNSSdcVPzLo2N4fy3U8fdJ1+WPCw=;
 b=FyAIb5mPxW/14JaJYPRWJl9VQeEhnGCd45lVS0yyA9zSFoxCGHJz7wfUgfLFM8IOm6xgQ2PbPet37MfsdiXMFWiTcZBYsokqtpIHD9I7nes/0f/Hfvh+WZYlxRYtKACDFk8XmxxvBWvGnqbt+bime4FFplqISfYww29tmaqeT/0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5415.namprd13.prod.outlook.com (2603:10b6:303:196::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 11:50:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 11:50:22 +0000
Date:   Tue, 11 Apr 2023 13:50:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: thunderbolt: Fix sparse warnings in
 tbnet_xmit_csum_and_map()
Message-ID: <ZDVJeJd3mM0kBdE4@corigine.com>
References: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
 <20230411091049.12998-3-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411091049.12998-3-mika.westerberg@linux.intel.com>
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5415:EE_
X-MS-Office365-Filtering-Correlation-Id: 283ba7fd-215b-4605-f0d9-08db3a82ee1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OajZoRqVZ5CwkKvWS6FFKIeCzVCljLuu0wg0zI0DMYOqec7PoJDb5tXYyt2kGqHE6qeR4lVZoo5pGVf+OSQimL3yEm5oATA5ppe0VRnOtNvv28FW2O8FBM/ciN3FcXAmg75ltv6G2pW4zSDbEwEwcgbVh3bYgZikuToEOEkyePu0oJSaNZgBTw9Dx0/WunKe9A6Oe65rJl5iLk+cDpFt/dOlbsZJNF9FI32pln59142Jl0DtrVQ/BMuI5FqD+iRskM1yZk+1lcnPx3f1kMGywRLPDZdvoF2bhYANfH45fsq22WgwEmao41xUpoUsp+H3daGrGcoJSqYOtjorrkksx851v3Szx0DkFO7Is3JQHtf+UfO+34lpb69CX215sU+Iay4Ij5l3cc9W2piaYySxi7cEoCMqfN/aTyh9IbiREXC5sXUDgQ2yA6ZJ8d/uEgRNuWQQ2IG8RDP3SGThYEGrl69GhMRH/WeG/ZbO/nVQhZ/FYM26pSdxLkCiJVFLbAcXSatD7xCXcqnLs6HEGC0gCPX6+paSD+2q5331NEo6GczYVBwYKFwGfp+4dU5bGBBa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39850400004)(366004)(396003)(136003)(451199021)(478600001)(6666004)(54906003)(316002)(6506007)(6512007)(186003)(6486002)(2906002)(44832011)(66556008)(66946007)(41300700001)(6916009)(8676002)(5660300002)(66476007)(8936002)(4326008)(38100700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nWXUC717RT+d4UV3p3Bo6RJSR4h2CWA5ELyZK4RqGFnHC8R0Weq8dNtsBI/e?=
 =?us-ascii?Q?k3dxzGlDkeACs8Zyl9NNuaCurflH/nl68/c9zSiVlI51YZDM2nNEaZ3gX/e4?=
 =?us-ascii?Q?KJxEi31HoEdv8QenZmNo6pv0PiGixcjJLtX7D6ETshCXyJ2W5/c8czJPE/yC?=
 =?us-ascii?Q?oh/gKJdFjySx6ARLB7hZSJm8tb/gL6mfjVyuSqchUjliQCqekX9bMSq631YQ?=
 =?us-ascii?Q?AaVCopM0WUAaFQLB4LVC8mTbWKUpPTG1RlfRDwsFjWVE2xi9t9RFi0kLj2V0?=
 =?us-ascii?Q?tf+IAGI0kdSG1tEhHSJVJAsZYcRGHBb95iLAQafGPtGGtio9eqzo9TA0TMew?=
 =?us-ascii?Q?iKoQKBPJR/EwfpKsEytOex+oGFfOJ8A4HsJOyljnvHikpvpiFaPXJ+/fmghF?=
 =?us-ascii?Q?AoVF8BrCljsMUn/pIb4uUIWE5uScF1qs9CAEDraQeurU3P2HUqZW3Yqc5ktu?=
 =?us-ascii?Q?4UIWrlZLOIjc6WuyEMju59QZkEOfVI+sgQZne4Mec0D9HUHVmhEq9eMLct0L?=
 =?us-ascii?Q?8oxwZzpvi5g6Y7M0bC6XYvA97YhamlRKmMgKoklqAmujlZebjyIurmo5UtVd?=
 =?us-ascii?Q?Aq0zGoXdtJfffq0Myz/gw/h7KUaCq82JEuaA1+Lo9p9JjeqPTizvw/CIqtBQ?=
 =?us-ascii?Q?21sHS7/PtoZHzIYrTH1eyZPbytZdtUQE9zaQ79A6WIniALpJy53YkjWjxAgp?=
 =?us-ascii?Q?osynHO1RYHa1lw5OdLdyPi5A8igQ18MboFIIHgM2HN3fPapz/hoSEWrBKA2u?=
 =?us-ascii?Q?YbXOu1QrLNPYO4feqdnm2KO+IYykB2zBm5vsvpBN+BZQsh83RMG3HboHZ9hF?=
 =?us-ascii?Q?jW5SyC2AT9EqZep9HngBwzt4NTkwdkMRTom+YrGSYPdohXX6+m6OH+7JyonN?=
 =?us-ascii?Q?2u3Tm64aRx2ac85D8u8qbvVKx8kf0zWCdkPNPTkQfNXjjPRG+l/gBfZ3eP6W?=
 =?us-ascii?Q?PmU+Chlbsya/alVpmRZoX1Q6ch9pjiYCUR1UsJF7IELofae2Wyr/CChiR4F6?=
 =?us-ascii?Q?ct3tfv3/ylK1TRWWYEF1wlKZLcfDGbMp+lPACyWh43I+CCQVNNfo8eqCz7VN?=
 =?us-ascii?Q?tM8v06iLSByyN3/sPEU9SQymaldfkuwkMOVUid07KWVMG6zzu9lNWGpwfycl?=
 =?us-ascii?Q?2HaY0I4dUXRFwVgwZs+JvJRRYctVIGXm0G+wXUtDMVVMkg4vt8yH0Y8MOfR0?=
 =?us-ascii?Q?VbWecb4NypO1FjyTKHUklFp3Nf6NYgkdz44pm4LHOfLye9WzqN7HvB4YGZ9S?=
 =?us-ascii?Q?uLD7qh+l12H2abR3wy8NKip0trPEU7dkHom6AMkXOU0riPfYvgCy5VaKwVpY?=
 =?us-ascii?Q?6dVosx0gSYrVeV//I/dfHe1fzieJoGrYtYKRWvZToGiZvQCBii4bM5pHG06m?=
 =?us-ascii?Q?LfXCfypwBS4rz1h1PqMkKMGzEBB1ue+amLaXomsC2536oVlxcpMUtnOBue/X?=
 =?us-ascii?Q?1dvSa25NWCMqAwUZ1vkGsZIu3c3SNko0oPV0/rgFc48INEAnuc1GxSM9izeP?=
 =?us-ascii?Q?IoFS/mTLMFNSxNis+SpBPqNB50Ec3zQ6m19670HCZM3s2493ZcN6Clo2CUXj?=
 =?us-ascii?Q?tyeP3jLFS16EoUTm3YLrWkqIa3uyeI1L7I+zpDTof5zQjp9dE9fF6BOmcI+p?=
 =?us-ascii?Q?bThavc3pPk6alTLwBAaX+CCLJdQquWimGHXfy1C0BRUAjSI8R1gspz0c/oUD?=
 =?us-ascii?Q?eOgoRA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 283ba7fd-215b-4605-f0d9-08db3a82ee1a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 11:50:21.9733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VWi7y0OK5kBhPrQYDabUI4cId+1EEbdQRJnxNqqzT1a1Re5gA9i8mBiE+jc4pUjiag2Em2OA0Iz0eTqi/WFSg/Y7dGE1QkimZlBbB4D3zhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5415
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 12:10:48PM +0300, Mika Westerberg wrote:
> Fixes the following warning when the driver is built with sparse checks
> enabled:
> 
> main.c:993:23: warning: incorrect type in initializer (different base types)
> main.c:993:23:    expected restricted __wsum [usertype] wsum
> main.c:993:23:    got restricted __be32 [usertype]
> 
> No functional changes intended.

This seems nice.

After you posted v1 I was wondering if, as a follow-up, it would be worth
creating a helper for this, say cpu_to_wsum(), as I think this pattern
occurs a few times. I'm thinking of a trivial wrapper around cpu_to_be32().

> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/thunderbolt/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
> index 27f8573a2b6e..6a43ced74881 100644
> --- a/drivers/net/thunderbolt/main.c
> +++ b/drivers/net/thunderbolt/main.c
> @@ -991,8 +991,10 @@ static bool tbnet_xmit_csum_and_map(struct tbnet *net, struct sk_buff *skb,
>  {
>  	struct thunderbolt_ip_frame_header *hdr = page_address(frames[0]->page);
>  	struct device *dma_dev = tb_ring_dma_device(net->tx_ring.ring);
> -	__wsum wsum = htonl(skb->len - skb_transport_offset(skb));
>  	unsigned int i, len, offset = skb_transport_offset(skb);
> +	/* Remove payload length from checksum */
> +	u32 paylen = skb->len - skb_transport_offset(skb);
> +	__wsum wsum = (__force __wsum)htonl(paylen);
>  	__be16 protocol = skb->protocol;
>  	void *data = skb->data;
>  	void *dest = hdr + 1;
> -- 
> 2.39.2
> 
