Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CE36C7DF2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjCXMVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbjCXMVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:21:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2119.outbound.protection.outlook.com [40.107.94.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE92012CC4
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 05:21:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jy1q61ANhNdibHbGrB9VXQ6SyC2e3nWX1ewP8a52YSLRw18yOLmcjlMKaVefgzx21bcyKF8V/qQlpE1Emv6+MMPTV+QJYxhmTgUhFKk5NgEenCC2vVq4H76GcwzV42S4F342WPT2dwtCx2fWgZH8Hir29NmJ7qXItY8dMK7J9gq9xhPOBKcxmFzYhZ3Cbw0umWI2DQO0xi+yRH5M1hBSf+aH80QRXTqsW+csU9rxKe4DewhjDqjLXXNqCVFr6QvZrmf6z+3HNgIIQlML4cKNflhljMJ7UG38Te0yObLkpo9bhl/0sM2QX7lJBA0Wql1zkfoHfa2BLukIbbWc6b19Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPWB3vAySic5Pc8MUYdTWCPSKwLFycN5PLlg9go9vOA=;
 b=g1/6myMWEuMhyln80rLxpmTqyNHHjV0MVOd6DZbelTvhfwpI9ZIfg/tYeUXN6zuTU/5QCFbR8BP+XCyoWWqqBHjeX1PyL/xSW34FkGyhN6KUFpZdvmupo2RDtSnH3Co4SlTFkeg5bmCJJn7sMJd19/J5hEjCzGNtnzoPk81pBVviJ2jU6P4UnNNQJRCSQogmiLmHkNp+L0bIMkyFdwraXfbpxGnGgxxU6jva2jumujTOep86L7P2KesLnuuXIjL6ACQjQCI2VpK9uvZOrNlaX8NDKCQxYWLG5LiX8rRY500C5BHi4641eoFeegjhdgj+u2v+qOXjh0ylNHVKYpImfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPWB3vAySic5Pc8MUYdTWCPSKwLFycN5PLlg9go9vOA=;
 b=fBMArMi5qD5N8ynAeCzlahuHjeyvwJ0xdwCtu1ICcaZij8KRRpzPdWMBvvkx+v1WiL81Zg1e7eRUm/4lut9AKVhtdQtUD1QyWpc8h+khnQuv+OqRsNVlo9CNz8dGkdx509EgE9TtKP9DjODB8UXCE1vkA8lCMvKnYUO0/5NNKLI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3676.namprd13.prod.outlook.com (2603:10b6:5:247::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 12:21:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.040; Fri, 24 Mar 2023
 12:21:07 +0000
Date:   Fri, 24 Mar 2023 13:21:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: ethernet: mtk_eth_soc: fix flow block
 refcounting logic
Message-ID: <ZB2Vrq3TK8MmK9ah@corigine.com>
References: <20230323130815.7753-1-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323130815.7753-1-nbd@nbd.name>
X-ClientProxiedBy: AM0PR01CA0077.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3676:EE_
X-MS-Office365-Filtering-Correlation-Id: 89a624f2-ecfa-49aa-710a-08db2c623e7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJSh6KfUdUvgpsZwqI3VJ0UOOc7Xj7iyt6zU2rms6KjvYytKlISUD5WRuvbzA/SHdBfLjM8RiJNIWL/wGyszoRerjThO5WPTLBCMVkEP2pDAChrrb+Nux7rWCnpwnjlMlfjEqYqK+f0+9AEFi02KAkNUGshGZciWwX3+3HauXViW20oS/QEqDJxSxcaVHvIVod7SzTJbA8kEB/afSkdw7z6TY26v7XqO9lhZUwC/zgEAOiehhVxuyEF9nXtKsvqowsYdzKyf8pP2TOtGUeHoocOgguc5HLXra4Q8f54iimVxd0V1jv4Ztkf4D+D09pIogZA4o1726cTJlhSe1RouM9kKSCT8r2usKJd+Uoc4rp55+lWonjy71GVmWHP1zyMlflyjW0qK+Z26KVY8RBoXkInq0MlvqTZYDNWXBuTwDTF2pvq+J8ACG4jPwSXgpTaUb2Y3vMdHg0f0cC8Em/FIrGpeKF/7ImR4eXnzc6G0sGpl02213yJD8LlAohHp2e9fmP0UE97xs+pRCMafzImQy9jr7+uLKS8XqPfdSegsgzw3e6WxndQ590I9Tzn+NqtfRu4v4z6+VqNpzIsrPFRt7uatqfrBmmwbJkXH3+S6LEdXwsL+KbwFVF0kduwRbfnGx3KetOc4L9MlnTyEaOld79D1SSXqqIKYdavIXunGCMwV/VVjhp4XlvTJnY9Ev8G/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39840400004)(136003)(366004)(396003)(346002)(451199018)(36756003)(6916009)(41300700001)(66476007)(86362001)(4326008)(8676002)(66946007)(66556008)(8936002)(6486002)(966005)(316002)(5660300002)(44832011)(2906002)(478600001)(6506007)(38100700002)(6666004)(186003)(6512007)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vMyaA2iXHLIV9XFo9SaBX/gUWHziPDKrXjRRTH4SLNaYJEcF7Bxmgvd1ZtRG?=
 =?us-ascii?Q?YFufAIJ6BNc9V68rUKeoHh3QSV/IyXK4iAAOvVLnM7w9uuU0rvHC7uCq8Jcl?=
 =?us-ascii?Q?W7j5/HxprOn8dTZtUnbUO8XBvVdJ3m1WIn49XtakhZ9GRjuRr+BZ802j91l2?=
 =?us-ascii?Q?aIDju3GorbnnzwWNzqQgbbJHEskkiaDC83JLijLRkC20Qp6IsZsjj78BzIg2?=
 =?us-ascii?Q?KPj2TKM/KTJlNKo+4ynrSPqv5nYYXKAiv6C1PBoMngTYTI9Q6D8u45sQ715v?=
 =?us-ascii?Q?HkXFaAuqIkROZ4dzeEfBIlvyEY/mBUh9Fvc9Rq2vd3j17IFMBIsgGp8RjbH5?=
 =?us-ascii?Q?EizRhy1g3MlNiSNSR2UkT2AD9XOhhAw1IuGWbaYQ/HXj93XfgUgw6DAwa/cC?=
 =?us-ascii?Q?kQrMp35PQdOymiED3PQnTQWwylvaGGXLuunsA+Seayqrxj6TymGMXQ/jbeX2?=
 =?us-ascii?Q?W1hqiWqcklVreuZ+LS2/y0AnrOBVw5f41e3GJJOpP7YFxjpBkT4yj9EU54s7?=
 =?us-ascii?Q?BipUDfp+dvdURlC1z38Zrb9x/Q9UmBiRSCQpBm5q9b24UOkBEHks7sM7zjz/?=
 =?us-ascii?Q?/cFTdGkg3cW/oFoyvQB5D70xBAiDIYeyDX8yXZD24K+LUP3nCmmIlWLVLXhe?=
 =?us-ascii?Q?2ek2y2gq4JtCu9KxWn2HSWZCxKk5ZHkF+EgnvdaQiBIuLfm5xbfpZnvoQJvi?=
 =?us-ascii?Q?VBonTY6BJKFvcJYQfe6FBUqR0bOVS9xnSM/RDDvbotTj74P6fF7v4/IpeG6X?=
 =?us-ascii?Q?/Vohy8nGxhQRetZeWepSX3bE8UtzYigljOmEasXDSw6Yq8CCv814yhZtAwUv?=
 =?us-ascii?Q?Gl1Bsp9RuPgDf389yZwcuzHmyG7hnsJb8xOKuL+apIZn1QTGxe/rQ8B7tvAA?=
 =?us-ascii?Q?RHaexEz2UDsOAWPwLmOqdm8QR+BSIJYs1f4CXEm6mAMcbIFlMNAim22/Mh+C?=
 =?us-ascii?Q?NFnt3Gx64kTxgMv1kWpMGS4VYNnzEhEN27+yS+H8F5jUKwXFo/BAGmUt8oRU?=
 =?us-ascii?Q?emWeeX3ajmnakkmLA8F1Qion5w/seZHSnKoZo91cuZi3eG8Z3Izt70i0yfhK?=
 =?us-ascii?Q?8DjM2NQecVUQCHbACk2hEphTHIAzkqRLw1qWfcjZMd144H8NxDNp2wYHgf9e?=
 =?us-ascii?Q?EXY8YbUmZt3FdgWnc1+0yvCdnFeY9Y10nCyCKRM1gpT2KZhDwZ4f4sPbjHKE?=
 =?us-ascii?Q?JkcAE+VuS3EsE11yD2W1C6fGvmdhVBeGClnNOPYuNFKDmUUlkHXjDhCyZ9+p?=
 =?us-ascii?Q?//6levzGp4bFzpKWUeD+Ra1Wo2QYmosPbIn6YO4Ju3TnF39KD4Yn9aDuWVbm?=
 =?us-ascii?Q?K+QUOvqADJJbAx599LeFClSBq5Az8VNzHmasZwKl0Digeg9rGD3+5gYf4UPs?=
 =?us-ascii?Q?93/hYonuqwW2VZYK87+xVcSWNM1QJv1XDmpxHln2uRtrBDRdDyQBrIu0fsZG?=
 =?us-ascii?Q?p05ArfghReFVv00utIOBWfHxtpi5g1AKPnD9FjdW3zao+OOJQAeFskrFWWZX?=
 =?us-ascii?Q?v5jUyqdA0mXDXG4fzrI8PbUdjbWcHZLup/VkxaWqqyI+PsVsvI6P8ZkCKmle?=
 =?us-ascii?Q?yzrGpMw9tBX1zTY4A+TBURtZ9ntY+iJUxbc6MpOCfrJ4chIDECXN7XcL2QM2?=
 =?us-ascii?Q?ZE7/tMIq8DjqACaj45CyRwT+/2WnPT7FzO/JRl9gFGw0oZys/LDeUTAi7vUQ?=
 =?us-ascii?Q?gVKh4g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a624f2-ecfa-49aa-710a-08db2c623e7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 12:21:07.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Y50CyPm5U7PsXA8IVqrVpzOyQLXGP8CKvZJ/Zh1JJHU6F78HpB86UrGgHtLwGha8YKhn7xRhhl5R3KVfTqQMorV3TMxqezPB26DPMpfVNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3676
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 02:08:13PM +0100, Felix Fietkau wrote:
> Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we also need to
> call flow_block_cb_incref for a newly allocated cb.
> Also fix the accidentally inverted refcount check on unbind.
> 
> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

I'm guessing that this series is for 'net'.
But it seems that patchwork had a tough time figuring that out
and gave up. So CI type things haven't run there.

https://patchwork.kernel.org/project/netdevbpf/patch/20230323130815.7753-1-nbd@nbd.name/

Also, there is a merge conflict when merging net-next into net
with this series applied.

momiji ~/projects/linux/linux git diff drivers/net/ethernet/mediatek/mtk_ppe.c
diff --cc drivers/net/ethernet/mediatek/mtk_ppe.c
index fd07d6e14273,c099e8736716..000000000000
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@@ -459,7 -500,13 +501,17 @@@ __mtk_foe_entry_clear(struct mtk_ppe *p
                hwe->ib1 &= ~MTK_FOE_IB1_STATE;
                hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
                dma_wmb();
++<<<<<<< HEAD
 +              mtk_ppe_cache_clear(ppe);
++=======
+               if (ppe->accounting) {
+                       struct mtk_foe_accounting *acct;
+ 
+                       acct = ppe->acct_table + entry->hash * sizeof(*acct);
+                       acct->packets = 0;
+                       acct->bytes = 0;
+               }
++>>>>>>> net-next/main
        }
        entry->hash = 0xffff;
