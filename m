Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BF567C258
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 02:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjAZB1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 20:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjAZB1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 20:27:30 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B16B12B
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 17:27:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/fp8/lznyxnDFXMaCIFoFN6F1V2bomZBMYUCxrNn3tT6pp/G/UuEPSbX2tzp5X8Tq4OVTDMvEQP314oKq36l2L0nsCDdvTCmAK3sqp/b8MZUQvBCZxMXUZoUnxe60fjvfauS6GR+Z+UDsU9h8+dbSbSVkXQJB4akg4g/YjRfZssuD5as08SkPNuoZTcW3KCXSXs1aLvF7kLuTxO5B1Aqts8EeUz6z4uDAkb/E1EXMngCf7GjDeaWXxW2UBPhpSLtcyEsCVOJ7ZpZ96ee7fMUw9o+vaWTcVR/YFLrujng6VHSvz9OD9037mv78XwC0w95hIQI7vJixVMOdxKNVWfhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lsYmDz817A294X8quiH3mNTeNNOMXbJmGvXrwVWygK8=;
 b=aahCDjZDYIye+Jvy8n7JK5ikPWrYPMmZ2yFmalR30Vd0+MeYnHaN8FKnpDYY1Zsu3sFYbMaOMjtbXUcF+1sCOV7BkFF1DT9afSH1YbH3hH5DV/LDHevQUl15h0l/vkt30bmw6rUjoOeGVJj/8dy5En3ASuCj2QCyZSXgozsQ+HQUT3S8Wl+jU5D7SWA+WplME+DYDkaAjMZOQMujO0P3K9irHA2QjaU4bMYNlbY0Gs/0/m6Z9nnoMpCzv5S1nb44lzS3DwQaiBuX2BSvhvBFRXZJLFULrDErS9yo9n+sBNpC/cYXOE5aiNHmugrALRP9FBJmyLw5v0Viy2zMnGy0gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsYmDz817A294X8quiH3mNTeNNOMXbJmGvXrwVWygK8=;
 b=ZVn3GEWOW5y8tbCWKujxl7983zpXnfPXZnU4FgD9l3NDx6DWHsPc5OxagkXGNkN14YfSH9EWN60I5g4HVLpAyQRgKZ3qQjPizZR2SuzaL+bOKQC3O/AMXNmK5e1uxBKQ49UEUc15W2BoDSVtVOTcm2qcdavWeTg3hH7QgukUM/dwDdnlt8uImR0p2aFPdJUoE0WhlqiUuORHD9eRVqqB583dhK/TddYZPiUK3h4NjpwQgcLw2ctVQICFtsU9AGVrmZ1GCTtU1xwIlX6X5KVZrVAtrtHPlpR2VW/3y0sFVlsdBQgNawTq1+wvNVX6RlZHQQ+HeU0azbHxz+/hrvdkZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by SA3PR12MB8440.namprd12.prod.outlook.com (2603:10b6:806:2f8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 01:27:21 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 01:27:21 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
References: <20230126010206.13483-1-vfedorenko@novek.ru>
        <20230126010206.13483-3-vfedorenko@novek.ru>
Date:   Wed, 25 Jan 2023 17:27:06 -0800
In-Reply-To: <20230126010206.13483-3-vfedorenko@novek.ru> (Vadim Fedorenko's
        message of "Thu, 26 Jan 2023 04:02:06 +0300")
Message-ID: <87h6wejdat.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:a03:255::19) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|SA3PR12MB8440:EE_
X-MS-Office365-Filtering-Correlation-Id: 0159867b-1e97-464b-88f7-08daff3c7883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APUcgMSfCtCLyyOSebzxDR/3ETrTOWrp9FMymCGiiU6+0on9WkaC+RacP1sPHevByWgUHO8B9vSQ72bwJu0ayDF4659FwfUc0mYFOuiHrWdZjXlZ3C6AFro248rGP4PWr8iRjqqd4bdIyVPh61oFX+rCsfTNrwKI4DHrjJsxJWAipo8JzseSEAytk7KZxdUDLSuFTnzfT8+XK50XHHoT+as8xCq3c0d2K3LNI6ildmEqPzP5KZlO4C40qKSdcOnkKUVwGeOVcPA2v+Qa4HtKt/a3prkd2jm96ggSWtHDDDlTOM028Iqx59fXvFnJTQbtqxzVAEh8HxjGAsbA/1K7GZJjmVZ4q17pMigYBU1mQlTq05gD4TxfkugkzSZ3EI3SIAEgHQHq5C/9BMYmHzYfEaN7V4xCKUbdNpQ1w1F96+vhSIwyfYe3klOs+fOpl6bbkdiK2kXGUDUd17XO++/VCs8EQ3IgPX5eP5aBiAu2AFYDgt2sSNLYubULc+00saichmCUp8sFtCGtt0J1+I7vQHANFlBO0GUsxmK81jXZhlUMZtjf1n61IFIj4z14W2oqVrnAL/mxNWnRUtOn14KGLrTKrZf5v11MowN5Fl8hXF6lSCxxauL/h0nrBGCARqWc5g91o/9WxXjyS84JZ6uAxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199018)(36756003)(6916009)(66476007)(8676002)(478600001)(4326008)(2616005)(8936002)(41300700001)(66556008)(5660300002)(2906002)(66946007)(83380400001)(38100700002)(6512007)(54906003)(6486002)(316002)(6666004)(6506007)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+lBhYOvibf6dxhOHl+ruT5sq6L7XariRZfAZ/TRSwabgMKcLVXUzeDU/58D8?=
 =?us-ascii?Q?7kxkCmnzltSl3+ek/3q2DLLZkUPbxn+fqBf2SZaokZGGhIhtn+dHfidfJ8W6?=
 =?us-ascii?Q?roYVYT4wglaA+XRo0NGMC+ssYoHfSDquw84KtvyX3YGvqTmFoJ0LguqR1pMu?=
 =?us-ascii?Q?R6p/zbcKCy+M78DotSMZt/6dENjzP5VE1pp9HZ3v5kHF7cGSCEhMfMfcXhPo?=
 =?us-ascii?Q?54mCFKGWUyMwmfSAohy7Ss0PZ6yaPESCQ8K3yyJu1SUDzZejl760f8GcvRcy?=
 =?us-ascii?Q?kDZAuE7QH2EXQ+jOW5yhpUjYgrdXBer+YLAw5tNWTXr20Qx3S6wPWlPKy2an?=
 =?us-ascii?Q?SLQo6SA62S34ahT/M9OZtN+Xv5nOXDI+7rzB0ukAR0fJTK+RuSKcFbKmScWl?=
 =?us-ascii?Q?WbXyd9beY4QpPtU8W09YPzEOF+NUDjEoHaAWSRwO4ZHElItzavljdsj5x2Ga?=
 =?us-ascii?Q?clxAAbA7Qx6cyT3oPLMEXmCl0w18xsJL9Aq0/VH9H4Bu12Zdk+2DVeFSEaxf?=
 =?us-ascii?Q?bCrGPSPz4KWJ1Zqq8xKMQ7kL4mRYTg51/nbdjJMOcOjmjNSE51WBy7ypTLlV?=
 =?us-ascii?Q?8SZ5q111pVgItZd+Tknlr7l5Vaigfng0dgSeqT/wyzb/NvOSL6+QZJPNRIBk?=
 =?us-ascii?Q?KzX06oAs8SPC6ztOmMjtgKtqZ8xLemlJSQIRiYaaJbSBCjA5q2hK/SLPleHw?=
 =?us-ascii?Q?R4t7FRupDkwAQq/5bklkZI2pKg90h23rBAnHmHRqrObDuwHyEtZygS7jjMSt?=
 =?us-ascii?Q?kUWlGwhVYMY58XoIELqr0lpkhmJx+JPABHgsjagMmstMR8yhySisHUTie9dI?=
 =?us-ascii?Q?ut2/GnxOowISGKDBHMOPBiT0MLhVtdRcGCU/6QcsNJyFXzIm+PC7hluyHduv?=
 =?us-ascii?Q?h2Fd86o/V7pWkLZHZlrDCmNTXRScqTW3iP8afiq51TNeG/35PpDVV9UVkWgj?=
 =?us-ascii?Q?eCQu41KA67mBCziWP9gXHKjGRcWj56KaDiac6U1Cd3Bcoj49+QgXcXIe6Xn9?=
 =?us-ascii?Q?SdGXskCB8efs0SvSCAabBOlYX4UgBbnm6G3wrDENwEqB4X00+636E1LbIHVb?=
 =?us-ascii?Q?m8xh1G0SXSpNXt0aQ2dPhlSQ07LqXT8CtdrL0NtSoyy2ZYEX9CbnrwJbGvIO?=
 =?us-ascii?Q?R6Q+g+Tf3d6Z1VrdCJDR6UqdY3uE2ejmQSZwXYJZfIgeM0aFVNvRuXkqO6zl?=
 =?us-ascii?Q?HuyG6NJdJ+PAJTeYwrIpwW2U33/RkbEtk/nbxkEwAEZEdAhTZre9pVOcA/JW?=
 =?us-ascii?Q?dzFZET6iWE9MMir+OY27HCsIE4AWKq3trzYQQrSgmG2c/Q7agMTz0830c901?=
 =?us-ascii?Q?v05LNXW0DoEqWpWcCv5Z9eVXuKcYlARV2hO3AjQUBtHVhZhqrI6Gh36KkDqK?=
 =?us-ascii?Q?H1auCXKxLYsbIKHP8oFQgaaz1+XEc7lf/0h53X+KoLeLbuFbIkbHQ03FQkhx?=
 =?us-ascii?Q?c3YB8LsQ9kXPoVc5u/waQnsCtrQaAOoWYSxJV8Y0dMegVAb2K6vy1256zX/Q?=
 =?us-ascii?Q?lx6BBjpMrGYhDglSmhTHT1QMp+nJjBkAi87jwWY4Qr71k733hSoiOGwDzxlX?=
 =?us-ascii?Q?QLa3M22tVyh/qbDMm3/pCeOq48uru9pKntnpylCcxecv9eqZvbHlu1qZNP68?=
 =?us-ascii?Q?lJg1r1ONnHp9Qd4oQYVMpjoB8Bdg+aXM33tDZaOP6YKYp+x65p482tMgPSUS?=
 =?us-ascii?Q?/NfZ1g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0159867b-1e97-464b-88f7-08daff3c7883
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 01:27:21.3228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jaX35V8NCuo/XojbIwFYyKSiEkZGqvCSyfIVr/tgfRtMSJDJHD8pBYA0uzkYi77WD+tmSJWrgiXlEjb2jytLSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8440
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan, 2023 04:02:06 +0300 Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> From: Vadim Fedorenko <vadfed@meta.com>
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> index b72de2b520ec..4ac7483dcbcc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> @@ -94,14 +94,23 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
>  
>  	ptpsq->cq_stats->resync_event++;
>  
> -	while (skb_cc != skb_id) {
> -		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
> +	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id)
> +		pr_err_ratelimited("mlx5e: out-of-order ptp cqe\n");

Lets use mlx5_core_err_rl(ptpsq->txqsq.mdev, "out-of-order ptp cqe\n") instead?

> +		return false;
> +	}
> +
> +	while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
>  		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
>  		skb_tstamp_tx(skb, &hwts);
>  		ptpsq->cq_stats->resync_cqe++;
>  		napi_consume_skb(skb, budget);
>  		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>  	}
