Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7606E9696
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjDTOEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjDTOE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:04:28 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CEE211C;
        Thu, 20 Apr 2023 07:04:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAQfcAJefXDzZ6yqbDKfQZWVPV/MdaOdgyslpQPNTm2xaHP8ZMy9b1Sspxzkf0r2aj9ehAQksBJA1xR/RzKBxYaU/ZjGvwkqhGHfzqEAccAOMs9+QyYz3la/gQL5cHZ/7oWCMYfUY0B/yQfNzNJHgRQs7nLSO/mO/1SLmrS3nKM9TXWMBkOkCNzd0Kpxv4NbHoAvzc5lrCT6+sD0gsZlt+aHDdEyhLANSdwyQf3fLSh11Yz2QlbCTPjIlgrY3t9qrVTUH2W5r4t/ML2nXB4G1VqH9k/FhOsldbpHM8FpEkEBqOzkIgGT0LTYtBzdHPIKUOX85yWzgzQfBaehvQ5e0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jY/SDGCpXtlD1vs7nPm+ueQ+Mg9JgCSz56hAObbyr0s=;
 b=Chm1pwE7q5D6jsyMZ5xC2WuLo8lEkIoXEUhHBMReoyPX2CnYaUgVvHMosxhWEgLpeIEbW4bMyr2bMf/g4PmNspdn3lXbv+vz92bZ1eALSRkfbc9jzAoIBxGKl/jiQ8aRVJ/gU3C94WDjKrsAKwrCJOAnEoS5ldtIy+YjfPLTPLQeiUQZkF4yrZXtSV0BQUKbpzx5Nq6QDb8hKBUHOyVIc4kYFqH7ZJLoEiHvl1fTS9qg4c47QriObTD/LbnU6O7st0byXGhAPWcKBd8ha2jt6mwT1pVi+XU6loUHbpbQrZ2xXeNN/JoGrmapzwSF3w95dOyjlXdb1paPDRQ70NAmBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jY/SDGCpXtlD1vs7nPm+ueQ+Mg9JgCSz56hAObbyr0s=;
 b=RS5iVIorYxE8CSXz7ynUXwgl/u07nc4XmMOb3RDqxTcI6uLZkx4fD2BBv/HGpXsySoapCsXwVSYETrqlDJlBPAcgaPBaJK5C+dXoOBsaiIR7/GZ+wOfNBPioyAkMC8rysIFvQ94P3KKLHzvwJRFOhFYuy68yANTxUyQGGKsNG8Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6071.namprd13.prod.outlook.com (2603:10b6:a03:4f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 14:04:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:04:22 +0000
Date:   Thu, 20 Apr 2023 16:04:14 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath12k@lists.infradead.org
Subject: Re: [PATCH] wireless: ath: work around false-positive
 stringop-overread warning
Message-ID: <ZEFGXruk/Onq92IW@corigine.com>
References: <20230417205447.1800912-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417205447.1800912-1-arnd@kernel.org>
X-ClientProxiedBy: AM0PR10CA0126.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6071:EE_
X-MS-Office365-Filtering-Correlation-Id: dd21cd40-274c-4fd8-67a0-08db41a823f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e45VBvl9cwrcDG3KJAFJttOc0oynwxI11EtTiEMBPQMcw/BzIIz85oSokgWsYBg7rnD7riHgfbx8/AZZbw/0v37HThDuht2PnyjzyGaHQD4JUyOecgK9vZHs/u1I1VcXnvnoRNxwkxvTwtsXgrRNyc6dhESLbs3mU9fek7Pu8rblfM18+4YF5Lw0YXwUZuje7xPMkUM/ilMHbFuTFAdlFCMIxcVBXVaCxfDA99vdcNDtuJRiJh/SlH09pkGRIZ9ZkRfbrTRsOVasjWT0/HQPWSMhSi+ESSu29rOgXo45V9C2NoPNZrtjKZB46Ee96CqNGi0J58gLYSPSz8qQbzgEwejsJchhOyN5SFNJGXEx5MMxkukgdQevFfBO+5lXMrWbvoEjoeVLieQ4z3iBUFchgy0GrXbFB5L2VWF5Naj7UvDKs28YvnK2iP58oQc2jmRxhR2dewdN/5sFerDoVEplX6GJthyfCkC7TUo+F31R8ApMvum7ZVXgi2yKk0IPzbb8g3TbZO7owsspM8TPaLhMoi71V4OvKLVa/ZDMz/+uqs4CucmsSw8jT1YuFFnOyKe1S+Z7WBUhiza8v1pRUXR/M0+vwHSg0FrK/CFug/SikqE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(366004)(39840400004)(396003)(451199021)(8936002)(8676002)(6666004)(7416002)(36756003)(2616005)(6486002)(5660300002)(6506007)(6512007)(41300700001)(186003)(44832011)(83380400001)(2906002)(4744005)(38100700002)(54906003)(66946007)(66556008)(66476007)(4326008)(6916009)(316002)(478600001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jv1KCjHfP8D0CLOzr74PShLBXndU2j4C1z+M3JOe1Oh1T8oXD7lszrSiDQHM?=
 =?us-ascii?Q?im6IYWb3qnIh8T8rIenXxRdkzt1MDcuKndRvYbJB93tY8s3EN4wl99umiDQ9?=
 =?us-ascii?Q?P3UHr1eDVEBwFFCGwhDsh+h5Ls8fTjeX0y/1hRDoukSqln2ygAHsyBGDS75k?=
 =?us-ascii?Q?RV9nyZMEJAj5d/eTdFmzUx5sfpIyErMD6CkJzwGGpsScw9Xf94lIeo9Gy6BL?=
 =?us-ascii?Q?crFMVpzwTCMczZNtycQXqs863gybNyhwNNVz57EPeOedW5+tPbUkFQsWDxj4?=
 =?us-ascii?Q?AP30+YG7miMXtiO/Y3CXyz9zcBs5YrFG+vXnzZSYTV8VIh2Al8XiZeg56HBM?=
 =?us-ascii?Q?/on/RI36b6eOdqIC38spnmkMfiBlp5G6CyLOoBX4J7qqyOJyHV2mNYeq4xFJ?=
 =?us-ascii?Q?u/reKKhYj8gJhY4zfEjRHiQv+9eQcIbo1BrLqIK0iKoNrzi/AUc863GKOzv3?=
 =?us-ascii?Q?l5SKMDgog7dgvtiwDmJ8n3snWNF5tATjMdYrqP3Ti2hAPRKVOHnQkboTy/Pc?=
 =?us-ascii?Q?+2/xCfrkuLcQFYmz55Tk7FmFzRzC9b/zA/LInt7HTcbfBIZ++YDnGiQnZuTM?=
 =?us-ascii?Q?GmX4t+dTX8wv5ZYjP6ROFhSXjDOw8R3y6xLyUfIH03LtnxaTACdwHoOF3+Du?=
 =?us-ascii?Q?dYty8bfspnNSRe+UXPiIY1Gko3ZH7wOrzEWzQWM+6s20JzNFv9E8FbHBELIH?=
 =?us-ascii?Q?mwJb8ZvjO8sq60l14/QerM5paqbrQkmc3h7ZpL/X66JQXPNiPclpcEPH8iQP?=
 =?us-ascii?Q?H5Pt5Y0PoAaqpFPeJSzc//CNlZSLdxwao+UsPzq/DIKwdCl08ZUPAKBo0y50?=
 =?us-ascii?Q?IbTkzoyekZZ3bH4KBXTvunSzkkZAhUUKfpKB7n0lBkPq21B51TvTCHUZzEge?=
 =?us-ascii?Q?VDtekEo0dmuNvMG2gSxZJZrc+eamwgz4vtrCd6E7V1/SzzCLaxvgyzpr/Mg7?=
 =?us-ascii?Q?S6NHI8IDpskBqAqEEr2aPqxTaps+PcDhYimy90TnB2l0/TE0vfZIX82b9fZa?=
 =?us-ascii?Q?gAzWKSk/AJJM2G9s+rWN+x242Jt0qIdD+ZsHngkHHQQ1v6lw4QZ9pSLPJ7wQ?=
 =?us-ascii?Q?KnZ0t/iTWC+wwr65FLRHleXxO0aXVCUN+NG7E95dWv0uSY6p1q3HViUpuRF1?=
 =?us-ascii?Q?b06Wvs8t1M92a8wDmkuxdsF3m0Py+8phtKrvI/FEK642xAr7GxEBES3lCG7B?=
 =?us-ascii?Q?BTVrNT3CWS11rOnkp2T+4mUlAK24VvRANwg5Hv7SFgKj3w6HfsJmU2kj2rLa?=
 =?us-ascii?Q?uLwuuvuhP/IO6hTI31AICnm8MUhNvdrQ29Z+dELh5Y/mM0ypjaXzOCKQDgf+?=
 =?us-ascii?Q?xdkIX2hUs4FxLln/FjJ5dVMlSKMUtIb+ALAh+MCr9uu45SWsw0NtybpRKlTL?=
 =?us-ascii?Q?Km0vMcGElWIqmIcjm73FJIg4M937/I4OdBzvkE3RkByIMT3l/IxqCJx5avzM?=
 =?us-ascii?Q?cjqsubXZm2VtgzRr7rqAtwJLTPlLK2+FBaAGN/RWzHoFnR6i0cPiuGNvjGKE?=
 =?us-ascii?Q?yKOsySZK7r4t++ggqUDPNY2FqrJK1D2gYfVxhaJ0EGhpSGKren/cCP2O+cq7?=
 =?us-ascii?Q?jn5nt4PHNuSssa/Ou40iKCIhDcQ/zyvoLmgDyK2qv0amkj1U6oDaIjTA8gTg?=
 =?us-ascii?Q?cNjxTHT9PLqH7OI8j+Snap75RNt9bnleWsH5N27rbDN5FKbSrlcyzKtR1GqT?=
 =?us-ascii?Q?oj0Waw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd21cd40-274c-4fd8-67a0-08db41a823f8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:04:21.9045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A06hm64zU5cor6diqG4/6VH/x0DXienby69zdgG49M8JHUH0vXQnIa5MQeYCvR146ztAg3qequ49Bahoo90u9trvMC9lGJxe32xcMj0fgr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6071
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 10:54:20PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> In a rare arm64 randconfig build, I got multiple warnings for ath11k
> and ath12k:
> 
> In function 'ath11k_peer_assoc_h_ht',
>     inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:2665:2:
> drivers/net/wireless/ath/ath11k/mac.c:1709:13: error: 'ath11k_peer_assoc_h_ht_masked' reading 10 bytes from a region of size 0 [-Werror=stringop-overread]
>  1709 |         if (ath11k_peer_assoc_h_ht_masked(ht_mcs_mask))
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This happens whenever gcc-13 fails to inline one of the functions
> that take a fixed-length array argument but gets passed a pointer.
> 
> Change these functions to all take a regular pointer argument
> instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

Note: I was not able to reproduce the problem described above.
