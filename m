Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5DF62B46A
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiKPIBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiKPIB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:01:27 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2066.outbound.protection.outlook.com [40.107.95.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B6C266
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 00:01:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Al+XYblkCZu8StTntwEjJ9lTF+ZiQdUjrYyIjaDlqZdpdofXcQQcZSj8VUbqnd+mJtlJomkUeNxC36XQWZLm/cvX6EQEBjxu8WPeNtH1SPXhoLi6+2c6ltwdQgxGs/u8vOTgqJWsKXuWYp9s3xmjM0EBD892UzUD1poHDbi6Ggu9Pjzz+osA2iFYnDP69jBTMjj1zFi1BQhGSycm9DLmsik++aRq86jJM7vp0PQXVoNAurC0V6FgqRBGRV4X1JzwxercD6FdnQcRXzCLfvCqVRNRFqNORdiqa3Qm68rflMinzdgBKyRNziJWgKfbLJMLlMnVkNFNyyMPTBYWvOo3FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWRIvjuCfmuWWky1xkfwm9fbEJlu9oXOrJySLM17jQM=;
 b=FXRLf8FwRYM0ru886VhmHHAUGwvUo0WtnRi+dIuYI1iUFF5OzSxfdya1KRN5a7hUVW7yL7QyvUPV0cKuiRnxzYnE6gZcrsd8tzGpzqQkPyfXmYkecX0GmyZrxCk2P4J/nty5Qp8HUq9QZIv/l50RGUIEV54Qmi2K0RUxkTNVA3f6l7hxQ68UCs1adscpyqrtghjR2HsnSq8ntnC1Df5+P+oZ42iUb+UKQWL24IcVCl/X14vya+UfBw0h4/a+I4NBHzYEH/Z4E3s7wbdmTIiQYdc6csLCUxUi/PjFZJNMvNo20c8bdnIX+qMALO96UqUXCZtwqf3FBqeoS7KCIPLzgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWRIvjuCfmuWWky1xkfwm9fbEJlu9oXOrJySLM17jQM=;
 b=eL0mYc7nbVnW9SJpJUL4Wdsl0PrpeEJnPv+jiFweEnvV54yv9AGBMYOnNG7fVHIUp7pl8JZkORdxF1qV5CZFK8wOXKWOAVdKIycScWyTsQp2SsYIPciDkKDJmk3trQogNFd7JoQi0PEMQIY1qoHgbF3scl4zRFg3/s8OQPcZSYVtMQTGs783eIhF+DrwiQlphkezcUlqsH2nMGqQSCcyDL3ekGugUAJit+/hUY/tnlZVOLfqywJf3Ltz36LYVuZ+TSZytn14DCzytOOCnCZCxUuFk3axIMgggSlPFQAEXcGba6kKOyNcUT9XKGKFBn87fxSHaA0Tq/yshAX+q9wMBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB6591.namprd12.prod.outlook.com (2603:10b6:8:8e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 08:01:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9373:5894:9cef:ada6]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9373:5894:9cef:ada6%3]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 08:01:25 +0000
Date:   Wed, 16 Nov 2022 10:01:18 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH net-next] mlxsw: update adjfine to use
 adjust_by_scaled_ppm
Message-ID: <Y3SYzkIJYjBpViNn@shredder>
References: <20221114213701.815132-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114213701.815132-1-jacob.e.keller@intel.com>
X-ClientProxiedBy: VI1PR09CA0179.eurprd09.prod.outlook.com
 (2603:10a6:800:120::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB6591:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a6deee2-ac3e-40c2-c200-08dac7a8c1cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MmEFcWhWPo0r73CKUCfpts/6ZvPPOkTbzYfgjPj7RmZ2ygosbtjBODNdBdK+QO58IX+Rb9yohOAF5zXntMgeSEadmQkeKbvf6Y1JyeG/hRi3MkBPFZC/OFosMm0owyzSk3soaDx1beEr6RABK0mAhq4sGTVTEO/BwHqEF80Js38KRaJB9jIMs0f+JLysSWKZKf3w5WVE1Cm5ewdGzhMgnrBB25C1Y/iHxvV54KKYSKWeML62nEoDwNRuCTZLzj0ACSCs8c+ySJf5t4SxbIZ0QNVzBAnXR7LLG4wfY71qyx9ltq51M9deTC3RbqiLIEdNhyGhvLlwVZ8GtHLXa8q7yaf9wujf4TPn8/oNaEsIqU9p7hweiIKIyj+y489Xw9Nk3X+3VlMtgE9r/92W8GiSnuggEnOKHuZEKffoqA8k6SIptyKwTSXO5MxH6kmOAWjMyNPvPVkAJi4Sbsc1BKadp2OasrX1kFEvOkAens3Kv7Dga48x3Pk3UvtaEPrtRpjJ24DWd2qX7iuAq+We1tEmM7gA1UnKYwJkt26Ynq+A5YUKOqUM5n61ierYQYSrtPe+IaYkO1DkzSya6cegpQ56w3UanDuag5FaXoxIZGVwBAijsVgoE68GX7fRPYyPofkksiONYDJrvBQft5XLYb/ayGTLC8XIzUxkGbZ117F9DqrJ6g8gr2DRZ6FK3K2+jstdRma+DzoYxV506CVAZhklkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199015)(2906002)(8936002)(4744005)(41300700001)(4326008)(66476007)(66556008)(8676002)(66946007)(107886003)(86362001)(6916009)(316002)(6506007)(478600001)(38100700002)(54906003)(5660300002)(6666004)(6486002)(33716001)(26005)(6512007)(186003)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7U90Sf4LHfhMI/7bm09ELOaUaj1YP55Gxm7bBwEyV7POXDIp0VrETY4I6gzF?=
 =?us-ascii?Q?1bLiH9w2JI0FIJ51Cg4bVvsnr2aDBS3/XdJ6ML6s2XB6UUVCeaF/J/m30my5?=
 =?us-ascii?Q?P9W4bXzUVr7QsB0QjuKVW0VfrwYFNy+tzKP19zVr6jZfa87Bb2okhRsfFkNW?=
 =?us-ascii?Q?Ma1GjkC8COt2Dn2T3qFx2mmURUrHYg2wUTeYWZVYHqD5x5PeMzLPI6U9NGI4?=
 =?us-ascii?Q?iHv0thrZ+iPA/zK5LTRk5QwLKILlNig8ZHUVcg3zKgLDF0glXIWJnruucElw?=
 =?us-ascii?Q?rbbUVd84zMkub9KSKOAbBNdYfwRGh25Q0mNMRNAhxsinnyUlirKs0doly3WP?=
 =?us-ascii?Q?yLV+HkeppbHpToOXCakVJIwn9J+gyhL9MBjISnOly1mAgQ1gzRchQDkdCs3X?=
 =?us-ascii?Q?IXPjWZPYNLhHBjMbqDP61fRPbOloBzy+V5/0JuJxp0Y3BpwHFzZHofM97uSV?=
 =?us-ascii?Q?J+6ye7IfDgKveSQGppd0NsiPs+T2m6gfb6mGFo82CyMlg38z9OIbNAx9SGr8?=
 =?us-ascii?Q?nAMAyWhqoo7HilfD/9Os7tujSQSiEKjWB+ytnHmb98b1fRSBy/mGyADiccVb?=
 =?us-ascii?Q?YknEOx47FbbmmUt+r7UGaWd0MULkLLJeO2tlnp2Xd+zEjYW4ByZH7WAvCGfR?=
 =?us-ascii?Q?x3UJwrRvCfPvF7mwkTDpeYyHqqWCNVjPPO15eZITsN2zccQTseINrAfh2sVC?=
 =?us-ascii?Q?Wltuf5zatGq+QQUEnvKILJ2867xNTsbtuM+yxmdo3RYdgkk/ZCRv1wxMt4Fc?=
 =?us-ascii?Q?CMGyfjeFzw2l1JNgjlkz4p8E5IIs9m8AHlE7ZCBxtfu/TcInDmt1HeX764b+?=
 =?us-ascii?Q?fE3roemYbIn7caJSovHYiBlFOlcqvlUcJJqv2ENgrgAf7bzwSFjSIrIuI9iB?=
 =?us-ascii?Q?gkvl9zQQeimcJVzPDmgmLC36hBR3Pcrerx8mKG9Wjn79FK60Q0lm8xfzRNiz?=
 =?us-ascii?Q?RNogJgK69j3sLBZMnkZe/fhdH7CiRzaS2tCXYNuEDfE7KXJb/SFhvUSKQDkf?=
 =?us-ascii?Q?HnuINCKPiQb+eqZKPqRtGtZMG9RuqZdWKABjtKi7sqr+Rma+rkKluPU6ACB3?=
 =?us-ascii?Q?H2EgN7eDkwhAYcpRyXmEVQBEZbsUmMcU7RfsFjMyrPpxlceg4+Fv+e3sDomd?=
 =?us-ascii?Q?K4fVG3y48NnorCozxAFCm6b8h3+EzBFuXHOpSFYtMftDGJK5I2DWAaIvqjx+?=
 =?us-ascii?Q?hQIEA31rZSWeWTooGI2o5oyFTjuxhH12XnYlW7Xnz+VD2LiP88OugQD/Eg3o?=
 =?us-ascii?Q?jHLe3hh5+PwtUoyLrDcUpEiExlRw5Lu0rgrd/YuQK73birIXz2smLD/Kzqxq?=
 =?us-ascii?Q?r7Xy0gb+g67Gzl+VitbPM9aTaycPAjqVYyL0wlfWQcknO/yalHJ5OGMNm75a?=
 =?us-ascii?Q?nORS+0aU9NRvKLCvG8f/wJmh/8M8CkeSfwHJrh62Ko4lmWMFmdf50yoi2Sn1?=
 =?us-ascii?Q?FpIeks4a/LC3qqOOlv/k0d0+95dIxHvih+YPdsAFu54UyZKRuSM+eNeYFlFE?=
 =?us-ascii?Q?SbmYMZg9i8DzgmOoEq7TI2OeN0Pul1jgh6MttP86eefBnMBssykJQnldFtaG?=
 =?us-ascii?Q?1INmPY2ePsoyBXR48MJa3xlgs5MDIL0eMsvPFIfI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6deee2-ac3e-40c2-c200-08dac7a8c1cd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 08:01:24.9235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +CBUVvh0XPQ3L+QKTlMqeCRynbXZKUnLp3UQKYWD2eClFsCsiQ/xEUX5/joGq9owz9IXOB7yrShDwv+haQ8bzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6591
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 01:37:01PM -0800, Jacob Keller wrote:
> The mlxsw adjfine implementation in the spectrum_ptp.c file converts
> scaled_ppm into ppb before updating a cyclecounter multiplier using the
> standard "base * ppb / 1billion" calculation.
> 
> This can be re-written to use adjust_by_scaled_ppm, directly using the
> scaled parts per million and reducing the amount of code required to
> express this calculation.
> 
> We still calculate the parts per billion for passing into
> mlxsw_sp_ptp_phc_adjfreq because this function requires the input to be in
> parts per billion.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
