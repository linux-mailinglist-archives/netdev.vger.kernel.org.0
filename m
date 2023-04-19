Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B846E780B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 13:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjDSLGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 07:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbjDSLGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 07:06:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2128.outbound.protection.outlook.com [40.107.237.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1925242;
        Wed, 19 Apr 2023 04:06:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSIK+np28RjMbu6LHcLHjCaYOa8C+7hinfEAtxvay/pFwu1NEipXAFZuv52nT4owTcRQP8F833+Q0K6ncNUlZzWyDK+/KhwcDNsFiPQTMXeIoVRpof43+9LnSjRe/YPGoylVVgB1Zt56NNGjsah5ZzMK5Gy1nMAIfu0UPSxM5cwlQz8BdfCHQ/qGqI0ZxBZkqo+lIeQpeml0FRHzJnsuZ/OwANBQyQyzcS4TqJ9Q+6jRp1DJVYbD/cek/7hL8JmM2mdZ3HJi5cGU/PQxcK+L4Dce6Xpwo01Y8i5hiLYX1SF7JpiRltDjTd+CW3sN2FT/fi1Bg+tW5i0Tmx/ZIILfdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSXoVMugNnI5xHdIxi3peCE1SNA7ZzMUQeMI29T5ybM=;
 b=DXxyb6a5AAeKvOH9ZK3saLvrl+1ZeefYSbmv6qQK8HtJICUV1KBUvsTeazxznjLhgwjw64un1rWaH5tYDJ64Gg4RYH0BpY+sSyWoM7ei162wflL64z9U+tNwIY+c/1Ei6L3QmpBw7ze1I5Hj6XxuBsOWCi6ddyFpg7wzYTcyrmiBx1HW8+ObKQ3zLiQYLAEhMTLTPk/odEgYJu7chj5iEmGu6Wv+QiwnUCYk0xGjwX4UeN4nV2GxIYurfIZ+e1F+xwXv4Wdc8h9vpCwdzzZC096WXZfN0oXR3E1cp9PqUiBg5dSmCnxsxCdRlkhb+LSvYuC+FMp2SVU6ViBfMtCrww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSXoVMugNnI5xHdIxi3peCE1SNA7ZzMUQeMI29T5ybM=;
 b=uDrEf26OlAK3L13Vnq4JDNPQSYspA3usjzGBGtP2jF/m7KpUDbvWu5XSx0p8dglKEuSvA3NTMX3NASNf3LA2QWPsko+Lj/HAA/o0pGqnVm5JM90A4Ydh8tx5uWfgWs0qwQhW4xuMMRFa+A/azV+ERw36Mg1fNJoDKfTLO1ik+sQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5491.namprd13.prod.outlook.com (2603:10b6:806:232::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 11:06:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 11:06:09 +0000
Date:   Wed, 19 Apr 2023 13:06:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org,
        sgoutham@marvell.com, gakula@marvell.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v3 08/10] octeontx2-af: Fix issues with NPC field
 hash extract
Message-ID: <ZD/LGvJU/T8MtpGV@corigine.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-9-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419062018.286136-9-saikrishnag@marvell.com>
X-ClientProxiedBy: AM0PR03CA0102.eurprd03.prod.outlook.com
 (2603:10a6:208:69::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5491:EE_
X-MS-Office365-Filtering-Correlation-Id: 25cbebfc-d67f-4161-495d-08db40c6148c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: svmldkgbGg6ovjdlaNaZN9Dvo7oNZMTnXZWT3lJhPIrqtQI0g3ucFAOmK0iPV6HuTKG2wko4rImGIFgn+y3OvAd4+eNVnr/lZbAZ0/xliwg92cYvijeLtWkOUhtJ8R3VvtOs0+T39C5MOTxpYUng5aHXCPOJsI1WT60S/KjOz5xKMsZ63XTuM6t/0YiPvgkI7sd/yBXmb43ZcO8VoOGFl1Se5+rSfTQBmh6H0m9II3HSroAPsCxgy6ZocATM2veewtCsNXdFAgYPoWQe6veloXuZCM2m4iVCeggKZOAIPQ+zKF5Bnu+eNww+LUAuUkDZ+eXFidm/gckMMoX9QBMvOD2ZdTo9li9DQr9eAFPi/Fv50rQId43uRHTnrEeO8sDeK6XucCOGIZqJopiTyTn1Wi+SjxLiYMzeYUIcK9LusfRFGKo4QjVHhCPWQH0EZzE5WFlpuKckGHtLObjMiVmfmATWu4o8dgQhmjgAc7nm/iobz+njaWpktFaCwqhNxjds8eQw6novpEBnvSrq9AtohulvMxL04Ff/s+T1algDgKbf3TebPUTsYrD4C9xQ3ZrG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(136003)(346002)(366004)(451199021)(36756003)(4326008)(316002)(6916009)(66946007)(66556008)(66476007)(6486002)(41300700001)(478600001)(6666004)(5660300002)(8936002)(8676002)(2906002)(7416002)(44832011)(4744005)(86362001)(38100700002)(2616005)(6506007)(186003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GdzHSf7jk8Miw7tggzRwlPC3QmHwWJaKmFsPAECA2YhTnXYxV0j1pr767wI4?=
 =?us-ascii?Q?9oU6achf0CuA+oyKXJgi8gr42upHwaOAyx7gZagFbLSrfrsFRDDGckKeyS3E?=
 =?us-ascii?Q?gU7iI+1rY29oxZH9C8iUd+tuR7Ih92PJ33sbmNXwmEk+0+iJ+YdQPkqwofDE?=
 =?us-ascii?Q?IhkKPC2atd/6XfWN4dKOT8QtCemPQiEXCi5zpNmIKBxzaqXq7jDrCn03wczF?=
 =?us-ascii?Q?+86vP8fG4qkWz49CSFLN9iySpQVpBELlHPeq/i1Er1A+zJDlenNGI6kB+aN8?=
 =?us-ascii?Q?ZXXXHhzlU/IoTKneTz7q0ooEa3beKThQF1VB5jJ9/Yu8bRosFjVXPtIvgqDc?=
 =?us-ascii?Q?wbT/K9Rzw2cCOSzxDKt/E8COT9xU5M4BAUw5lNk5DXqFDFcsLuEIvwJU+CO3?=
 =?us-ascii?Q?+xK1xbG10LXpWqQ9uSPAb3u/+JRVINXAzHNns5gjtwtX+9iHkiFhO/lxzLn8?=
 =?us-ascii?Q?24By0BtvUeVZikstOJJw07T/wL5rRGaBDHk8VFp1Pz5PVSs7oShcATlrSwo6?=
 =?us-ascii?Q?ZCLZqutwk6tpg1ix/fgZzKxtqrRObUuRX4w4d0kWhMsMOZnDUhdZdvptehcI?=
 =?us-ascii?Q?dCkPweId+a1R+vDEguCwkq8OC3gjZwweQOkfSYXuVWkUhgHc6Xux1qpukDqI?=
 =?us-ascii?Q?hJ0uJO+v7EUizO5W0mzwlE6p16hlqylTTqVUB88mnbMUCne3i9Do6eT6nHlj?=
 =?us-ascii?Q?xM1q9C0J6KYS4ART4iNMk3UtXqaR37eGYQKDJMmcKYxrVUTI9LY2q0dOOegn?=
 =?us-ascii?Q?3BdrjtocKcJWHqy31hoj5ML5vt4qS8tb9L3GmLzG4lbHM3Eqe0F1cZhH5jw0?=
 =?us-ascii?Q?Xo97efFdO4KZFKuX6LNggxlcPUYUa/xgpYq3OrN30fv1I9mAbQeWCHaNf6P2?=
 =?us-ascii?Q?YiKhPpA5ArjikRnTxiVv6B3HIook2z75PTzy06Z6ZuLQu23mJvZPDJMvni4b?=
 =?us-ascii?Q?gsu5NV4NB49mrW52Ok/+Yz2hugyclfE4T7otyedg5NoRugQ+QoBCAJwo9FHG?=
 =?us-ascii?Q?ylB6BBmkkkOThf1VpQBdkj+AE476p9jSPe2PAOmmdPtv6HgeT20WvwhDvZ4t?=
 =?us-ascii?Q?aeg/DLWpoK5Bbyv7DsfWaA0MzdvWqK6/m5SYgZmmWCTU4Mcwulh7Uz/itm3n?=
 =?us-ascii?Q?FrLNxa5yS1Zd8F83cMuzNUHDQflCoBu8+IcI1rq2txo7kNifwrQI+/TYVEqC?=
 =?us-ascii?Q?b3vEkbI5+jrOa8g019Z+Bt2hTMOXoxS8BDmF3tE//1n9d/SQC3IlpTumK6Oo?=
 =?us-ascii?Q?fRj6zIIuE5Yz+aOjqgTjVB/LN4uSWlPJoM4rgFguv2QnR6RYw6tZM4ebeb2Q?=
 =?us-ascii?Q?Ugp5z77AI1CFJpiFVh8upRZ/PN8cunPMPD9etJRJXC/nucMduUHWvJfO2ZCF?=
 =?us-ascii?Q?/0CDwJTxgToXhR/0b3Qy1k5KYSQYBc9VyjE1fSwgGYkRPtasLh83TS2dqTps?=
 =?us-ascii?Q?N1FyEnyJBWfxVcyCOL2myrQK3X/27nePEhSeFxVzw++6SpyaAasfP3tjiHIn?=
 =?us-ascii?Q?NQ/P/J9tGxlR9DSo5T1hbKr2MEd6HW8ObPR48+HvEcddoHsPICVHcQtA5Nu3?=
 =?us-ascii?Q?IdJNbv0/VcOa8v4mJxkUVLknChB1f9r5NibRq7/7IKs49AQX7FJlfpjcF9c5?=
 =?us-ascii?Q?qjHuyxXj9ADlR2EQ7jXY5Cxf3t8MS7FNKy94fmmGVC1F+ATBQByTlaE4BbOU?=
 =?us-ascii?Q?5XTAVQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25cbebfc-d67f-4161-495d-08db40c6148c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 11:06:09.7556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HmM09gSiGhj4JpEcWsmPBLhRavXYybkfMXE2IQCuXQH5IjjwfhXoqf3BLOatHS5v3J3I5N8/ToQZoq1icveRw/PrmlvfGa2jOVzepYHVYHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5491
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:50:16AM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> 1. Allow field hash configuration for both source and destination IPv6.
> 2. Configure hardware parser based on hash extract feature enable flag
>    for IPv6.
> 3. Fix IPv6 endianness issue while updating the source/destination IP
>    address via ntuple rule.
> 
> Fixes: 56d9f5fd2246 ("octeontx2-af: Use hashed field in MCAM key")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

