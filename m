Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4036B0654
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCHLtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCHLtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:49:00 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2137.outbound.protection.outlook.com [40.107.101.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DFA4345C;
        Wed,  8 Mar 2023 03:48:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iv9QWotI3vB86K7bI7sUaZu1fc1cmWCh7y+9pOOr740ShX48wOB8EMTCU4noNGE1GA+Xbd/x4AR9iqUqJ8rwI76BuzLziFlJqGEiYEAnMSCbpOXh32fRrWtZZzv+FrqJQXWttAvu9RufmHcGbL7S6r0RWrjHo+/B/6CXAmGCUH+Wns/DFj9MTtlXqKBuGDjHbSJ7iNVc1lRC2Xs5CEUP34ilpOJFDgj720FnerqXEtjrx1ykXLda/8OcHrXV5c9UfZS4zBPx20D3C2gZ8XOG7nSXQZCBwSf/+EsBeUnht6p70+U2baDDLD8MrIRxhmJZtCP8VE/nd1cqR1ufz038sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBwpFfwA8+X6us5xbtWfloH0ya5VlfgnEddEHSK8MTQ=;
 b=FowT8jLOu5j8mj5BfykCjAZHASmik0F+EdGuN44k85TkutuC3Q7s+3O1HuFsPmWA81TGWYXSeaPpHMgRm42LlxC+93ACoCzwQIy3qSS+rIN6dhKX/a1Kpmx1jo8v7BLlIpKWNgP4dwzmaq9jOkoLqntT2Iu8lxoLPRjJWcK/ZaqO2xygNWGJDQQMEtfoeDwEHHDM8KmgJ1oqNsQ5SdgP/gWtp5mjPYTKFDCxzaP2FjLiBH0AQGc0rCuE7KuDyMgFleHoZ65mtswutYii8LWxkRI5/HRJGi6F26kmBJAzl6LSQ3vr59H52w00XJNfYF3/sjPmVYdHYVkXbNrftoNAcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBwpFfwA8+X6us5xbtWfloH0ya5VlfgnEddEHSK8MTQ=;
 b=q/Lw7kX2pv1jrmMgmqEPVY2wzEnK0PpS5ZVop+X4DiJlsdkX7b4lXn+u0+ZPzM8Rew87QJAIBbKkl0k7HsqYwxk9GksCUJvLqTyR7Nt9Eak2tmt6za6R+lJKvwVl4zoaei1s5uXGKpsWFpf41UEozVUseAE4Ogo1bidF7zAmefo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6061.namprd13.prod.outlook.com (2603:10b6:510:296::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 11:48:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 11:48:56 +0000
Date:   Wed, 8 Mar 2023 12:48:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     error27@gmail.com, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath12k: Add missing unwind goto in
 ath12k_pci_probe()
Message-ID: <ZAh2IeS3TnyllK33@corigine.com>
References: <20230307104706.240119-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307104706.240119-1-harshit.m.mogalapalli@oracle.com>
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: f0e07788-0f76-4528-8d62-08db1fcb1904
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q06x8wARh2JI2Hj7ZKvZPUdvP0vkcvLdol5+hY3TBJ+kXsntB4VpwlGjlj4B/9bYFLNxgPWL7Gc5rZU5p8HtuLPGxSsTNam5inkWDiFpC9l/CXQ1orsvG90bDN3v+0KSnhpxfdKvvIxXlXoRrC2YgZt7NoGhW9eyg6gOhpCBM6lYeJuzbzKYQSScyRDZ5SniWQe2s0Bw4/ViKEmrmJYK778F0CwjMJNibQv876EJp7cP50hwKEIX4DOoDhsjckmesOvFcEEVrszGwApb771KrGqRSr6KrTOkIdHETAkjvZSKnim19B19VA00CxbNfGv+dcPfneTarF4jqUIfFihFYUTrdYeojOPkjADe4CH0BiM6cgTYhb739G0HhWoZwN1UVNfVCsGIsUgt3XjHXSTY0KItlkZZfTMvASN1vQwmlOD2zMxU4JaD3ROmuxABbdo3VTUDj9sXeoiZs5tAKgcevAUbHmED3M5PkAne9uxsoId4zzM3Jxyl6aQ/GQk+UXrnSVbxhL4zAA734zXgQvCmzLMBjj/AX/HcpE+XuPn4cpRbcE7ufSGPyZhfPOSB110wy/w66Erp0UzDVr04/TtuNhDc7aE55IkBqu3Cn46ceOnf8go3z6v1Z4hYO+rrM1Ik
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(396003)(376002)(39840400004)(451199018)(54906003)(36756003)(186003)(44832011)(4744005)(6506007)(6512007)(2906002)(966005)(8936002)(6486002)(5660300002)(7416002)(2616005)(478600001)(86362001)(6666004)(41300700001)(6916009)(4326008)(8676002)(66476007)(66946007)(66556008)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YzEr/+hLKzfKQ+RO1dOShHTuiB7xYSr7XGAr7E7DlrHG5LIQxmeLWgL2Asx2?=
 =?us-ascii?Q?x+zwPb0n2yp6EL239HBqQC2Og0kF4xpNBqvxBTE2Ch4FXTCYUJfBHFD1/xLd?=
 =?us-ascii?Q?J/UwBA7C6r6vJtPpTE6gSS6ZaoM2zBBUSaDnGOU133+3QH7mQjYy4Mf4mMgk?=
 =?us-ascii?Q?NwgdTUEFPjYzXHZnwQnsFO7w0bkWK2MTjNPqrPx5cecHZpTGSDhEejV2eK6Q?=
 =?us-ascii?Q?urIsXfpqtspLvIbnnrqaQ4P/P7yoL+8VmLPnkVjmOxSI0FSN8LXBXeveGzl3?=
 =?us-ascii?Q?ZjjR7GZxerIWuGJlEZN3Mmnvo+GOVU3Uc+RTbUN7w/SKb3f19SSIK6xi5ysY?=
 =?us-ascii?Q?xXvZ4iLUqSHb1gCYzUBG3MHdHpBlOV8BaqZziyzUDFzERI6Vl8TubhzXNsD/?=
 =?us-ascii?Q?mUd6NgBP0ziIBVHWQ6fesnXle7tyPvYLvhMcOKriXbfS3VWSMMjBMnE23b+N?=
 =?us-ascii?Q?h0wjj0oV+TNZamdPeAt31jkOBXq+BhGlFNHtq+KJtyMwDKmmjw7ForcG1h6I?=
 =?us-ascii?Q?lCXPfM80QWkQX8CTV9b+K5poABsdSRgZPMOW2EqghBYMxq2dO0+PoRejVKFU?=
 =?us-ascii?Q?XkQiVmW6onPPT628woWlR/3bc7KZcR3+23zQJYqUldftyGpiGMtVR2X+5/K3?=
 =?us-ascii?Q?FsPilYYHcWlAMt1IwbecYBNyRdbqjdmXesxLhSlTyWY6zOwhRmlXXdRbpEBt?=
 =?us-ascii?Q?Q1VeDcoVCX/uxkcuj6JLkJk9oXZ5OYe9WP1cgiAhtTV6Vnc+e9xuorWIVTxm?=
 =?us-ascii?Q?fKnW0hetJKCbNrYUlB+6Xds5ithKAHV3uxurpvgv9gFaPnH88t5DQDy6ksDK?=
 =?us-ascii?Q?sz/LGhy9FAShkPUQvQexqAcHpE/OQjkXZ+AdkTg1LvM/Ir4RHf6Li+1sTVnT?=
 =?us-ascii?Q?9GOxkh8KA8Oax7cckc+gB0gFvkbqqOIlrmPXMEfFmvYdMayWKMcHlZNcks1t?=
 =?us-ascii?Q?FW/LtEHqUZlVS6eWSB97x7cTFWk2qwm+8Jf6aKqrqk/Z6GOb08Ms5PqKVXR9?=
 =?us-ascii?Q?Kk5PHxoKBWWyHFwsGJBO0nAUm4SRP30FAUpwn95q+K0juUtVLA5COSSpONRO?=
 =?us-ascii?Q?A6hJzmdbEBFkao8PcWZLx5ia+EpGst49n2bGtXSIlGwFbG/NV1gTPadKXZLw?=
 =?us-ascii?Q?FpRI4aA0rxiSi7YDGPOz/+7Kl2WKpW6HrYMk25O92zH0C7kNnQ+CI5/voAJI?=
 =?us-ascii?Q?xdTnVSlMeQs1pawNppcTdm7rL3fcGSfOQCmIgsjd9Kpw72zl8BRmMYsSLkxR?=
 =?us-ascii?Q?IiiDW6je5dwqvxzoZq7SossCLvCQDNbmXIQDJufpPDHXM0WLfk3PoBTiNRPi?=
 =?us-ascii?Q?2N0RiIgRxvKrnMKOQOYp7vxB1x8QC8EBKXyqIxB5zE8l8kuZQ2OJxiyxAK5r?=
 =?us-ascii?Q?rFCOtcojIWfJW+E+D4F/S1GtdioFfjjWrwhKFz2oshL9mdwGV/WrPQBBgJr3?=
 =?us-ascii?Q?knOgvxgE0UdKKCDRn+hzJROxqK2f9Ia2w0ubX0VDaAmcF3Ml3EC7+PGKmD6Q?=
 =?us-ascii?Q?iY8eEo7/tlitvdmGRHdy56c4K9svE3scAqp72rP5r+IjZ286OUby1yuubQbn?=
 =?us-ascii?Q?vLNR6DKWRJZ1yuE45cvmI2TfomWCCb4PGVMoYdW4MsK0r3tpfrfsNt1O1wTs?=
 =?us-ascii?Q?cIPdfar8mwjIiZr4NgqCGaEAlwsO978QRwoIP5PXLGgVQs93xQy0CyFQlWy8?=
 =?us-ascii?Q?EB5SUw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e07788-0f76-4528-8d62-08db1fcb1904
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 11:48:56.3638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lpWsyds3ZFpKvauQK49S+cbWNt9nc8HuGR84h7a4F/r+8bh5hkyn/ZvhhzMf5O7SISMa8BGWxlqIZMXXZE00xoE5yojmXTuB0SsXV63Q1gQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6061
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 02:47:06AM -0800, Harshit Mogalapalli wrote:
> Smatch Warns:
> 	drivers/net/wireless/ath/ath12k/pci.c:1198 ath12k_pci_probe()
> 	warn: missing unwind goto?
> 
> Store the error value in ret and use correct label with a goto.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://lore.kernel.org/all/Y+426q6cfkEdb5Bv@kili/
> Suggested-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> Only Compile tested, found with Smatch.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

