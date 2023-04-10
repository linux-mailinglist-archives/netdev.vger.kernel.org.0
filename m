Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AB96DC41F
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 10:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDJIA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 04:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJIAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 04:00:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2090.outbound.protection.outlook.com [40.107.92.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6184C40DF;
        Mon, 10 Apr 2023 01:00:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgbVgZEqQtTuC8XZb5vK/WUxYBe6LcBoSe0FqB8nVxCHfsDWcfrZHvhbiGGPj9QhshnFegdO0yMKCBgo6Z5s54YHAlwmxK+Eeph2mHQyHU5dbEI8mFKVdrHXy2gO9iNtW2UUUikZYsBoVOAZXi5Vp52IveRnNd/G8N4PPY+YXir47qfdbXFHrWqVyQOVs+KlY915lo7QoGk4mAcPNPAiQQ+xb8Pg83jJqAm8ICzgnpCmBqFRR9L/8BiNDLZ/TQLGGOYdQKeoEm0q8AwP13P6o/wDhkuYOFAT5+dXRf4Ye9zdfiJxEt7rdUmSs8pU1eRgM2kgrTKDwJH1Kv39otP4xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXJTtRtAhRn9V695KyFBf4P99aKl0SfCwru58byVtM4=;
 b=Md4HdbSSf07TqK5DfRa/uyciNNsQ3CaOGHUEPA7TxfSvBX5tfpFvPLgtbpe4gnCpw4+JDbD2YwMYch8yXq6MRGHgX2qbhtQUXnDe0JlAYEq8+5EUybNMRyefpu1rRutJBlpNMUhzNs1+ZEHBfUXa6KeaKZWelflIuCEwYRfQn/UPsrv/TvZdUWtby5K2uTK6RHm7nvP2P8V7uU4dkBWBUnhfU2CTFNbzYnGQo74T/p/8PuEXwLUMeQWe4UFAEIvQzNFJmKbDjOn4ixAchYYluCTcgM0WBl6RnaFlhKuoArHYh6MfgqTIfpJCuPTEmCtqKjmaNUc1rl11dj9pqBtF/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXJTtRtAhRn9V695KyFBf4P99aKl0SfCwru58byVtM4=;
 b=pUXpbtyc75qeO/E9Wk2w0vECGTGzn3+KP/hHgy8UTmujUiGDjg9JTAnn9Gv3Zeba9IIAMmmqLhzdBKPT18LA5TNbK2YmwKoOeeyzYrOr3O74ZXevum+2lUMtThLc8takWNecCpv6jBX+Htx/ra++6AjVDVJ6AlHH9qVodPcypwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5668.namprd13.prod.outlook.com (2603:10b6:510:113::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 08:00:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 08:00:50 +0000
Date:   Mon, 10 Apr 2023 10:00:43 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        error27@gmail.com, kernel-janitors@vger.kernel.org,
        vegard.nossum@oracle.com
Subject: Re: [PATCH net V2] net: wwan: iosm: Fix error handling path in
 ipc_pcie_probe()
Message-ID: <ZDPCK7KVRIz1sIVB@corigine.com>
References: <20230408194321.1647805-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408194321.1647805-1-harshit.m.mogalapalli@oracle.com>
X-ClientProxiedBy: AM8P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de24c85-c11b-4999-844b-08db3999b301
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /LsHFtaSc+1gEdyxK+x4uZ0+0kZwNfFaWZ8v9HJOrxjMzENSOPbDMOxibLY8wF2oTxIpzAl1rbzNtKYU91xHxmQqvvyGai8DiDuwO6d2CsRRbapjdvgYz7wC66Gxp4Xa+mZN6PXHDMULqURC33MNZWI6lK34Iiz+bR+O/p76jbwWUj4ros7ylZ7ZIvR5vM7wQ+QYWktEf6czWhW5+NAl2JaDx2dT/7GehFQMD6P9XamJ6600mfhy3NzhcjvPWeIB3wU1f/qC2lpakQHNKSxlbfK9wxfYaUfhGPCumj0I16ua8JX1iY6Y7Af0fKQqRnBYvSAsSsBaRIXxCV1LezWVfUMNPURKNTkBTXkdxLoARj2PXRnwPN+HZtX/vNpoFfoiNAjzrL+MbvFjpkYo6NUIhM3IyBolJ3UXExtBaPcqLeCWENQgvBOrG12qBBlwwFPLLc2t50MmZoLSQWIVQTQMfkjutkHUkOG6nEW7nliSfFbCJ4hgjqk9mUxhJQO44yCIWQi6Y8XooydwtFy4s0PMUwlf28xIbHCH0rjo8zUFDsCZL4sjO3i3u2MEtgq1bmKYgtdM4iVaUdW98kGYzJYiBp0x7avODmcgt/ndBFRrXco=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(346002)(396003)(376002)(136003)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6666004)(6486002)(4744005)(2906002)(316002)(186003)(6512007)(6506007)(44832011)(7416002)(66476007)(8676002)(66556008)(6916009)(41300700001)(8936002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hid8c2fAqn/EgXlZ3bgXbzPWrxJiiX67DQ9qA+9AD76e1Z+3yfi7w0GpevCA?=
 =?us-ascii?Q?lCHqbwLoKkPsjZsejS5ilMB/wR/aCv99UT+QWgfsuSfgQHXgH8EmItRdqn6q?=
 =?us-ascii?Q?uKYwfdfje5gk+Z6xuoPD67RwJD8Fx1xcOjAq3JBG+m324/YwbJLvmiiiV1TN?=
 =?us-ascii?Q?PH8cOrFO8Ft0cvwcpTkqbDBA6N0/QNRnirjdiu1CPo/EgS8dcPoFSkkji2mv?=
 =?us-ascii?Q?yzDJC9Dq25324gb79aUpwpb1I5G2uaI25NpGlYeRx1rg0mOsRoh+Uaxk+iV5?=
 =?us-ascii?Q?bmIaswF12d1brrHXTTeqrhDmnH9DFuWxvj7btAraUOmC6bdw8IO9+JLKJLly?=
 =?us-ascii?Q?tfRiO7zMLnYxHyFtq+MZocRvu1qZi8hIiaM4+lGyYtyEjPgbZ/ICfylrYySw?=
 =?us-ascii?Q?zDlJ2WnPTHYt1FvaK9LyTNJJexl1dHYzjk39/otlErZ+EZLg1YSMl+9vdGun?=
 =?us-ascii?Q?QdT7xhWxkuCheQdK3/j/bZTA0EQ6Pli7I6+lkG3/ZFX8yPIDrqyWJT1LsdH7?=
 =?us-ascii?Q?PUJVauR/8KLanVEfNY+AWOqUXWuSodDwCxbCfeC4ASeH8GPlDj3Lcxp41pWb?=
 =?us-ascii?Q?R1oDbAsc0iNOKRyt5KViZiyLzTSr3mthaigbF4qri7XtcWOubiURvXkZ7FEN?=
 =?us-ascii?Q?jLutw/jaM7Wz92EJ2svJoiXq/FYqZsNf9AFOqSRJjIF6TI7Ft0gSPOy8EUUL?=
 =?us-ascii?Q?PpN3qM4LPAFNqeueB3oEQD9YymrV+Rcj5r6jxCFRuh9vW5E/5MrnuyjXht4O?=
 =?us-ascii?Q?BneFhr87s11KzFYGT/IMQTX4LlZnCR2Ht22GjdLyaOoIhB9vfZ1kh7gs7D5r?=
 =?us-ascii?Q?yNR8vpaYL5xB7hR0Pge0uHMCmRDc4t3seM2LSWUPbj8t2iGabRTvwhFvngKg?=
 =?us-ascii?Q?BIXMBBo25LX50fk5RDw3J1iZSQidOwsGnsP5LRbZPbh1V1Qkn2vJlqKmfREW?=
 =?us-ascii?Q?VG0tj5fx8AzFFUdty4lNbsnMrLcsTYpoowjfek6T8BDr05xAF29zWrzodamL?=
 =?us-ascii?Q?o2ZPT5LEeldvVeNJS6mW+5+1SI52vUodbgSbh41jm3oALw6N3FaqZifuvSNG?=
 =?us-ascii?Q?EoCvuG0A4xwS3mUWU7t8cVyHz2tplhB2SE1sQEvRGkWCiB0BOnJVyfxvJqWr?=
 =?us-ascii?Q?M0PNznq/sMjnufKY9GH0SNK9kpSaC0xjvdI9e1Ck0ZCQujMM7cEoDfN1uCTf?=
 =?us-ascii?Q?3aipJQ4TmZUg33zCmBAHc75RIja+iLjQSvVA05Aca/W0We+2VAqmYxUUGw/q?=
 =?us-ascii?Q?KInLb54H+DZZHAVlgY6Na7LcQrf5g6DB4//lSULO773iCMU7rVtL/nihaUt8?=
 =?us-ascii?Q?rogFdeRtQqEtBj0zD3HJJa1g9s5pb4qQ/cOquV1qdLYrP0R6xI0rlUTnSNSh?=
 =?us-ascii?Q?/XYz3YbdDmkoQhHOajtad1FcIZgPvZDl2oUtzQdhLOkD0HbIithAEQIppRub?=
 =?us-ascii?Q?2YEIWhszzA5qx/6acnnWn049cHnjOyEusoQEPBPDAwUi8L4hMlGXPD8dt5Lg?=
 =?us-ascii?Q?FxOtL4AeUQReuk3CF9fAO1AHYtoSCy5LoRhQ8JUEa8nk6tf9u9aCVyvGaoDb?=
 =?us-ascii?Q?PRSWwHsfnj8jMuO8nboQUd+spSADKJGlB1D3ZEGW8onhvIKk0GjepeRAi4Qw?=
 =?us-ascii?Q?q9ws3PrDAhiQDjLcSlA7XQZ8nnSVyYcege5EhBObqT07B7UVLcDSeHo/vYgE?=
 =?us-ascii?Q?ve65Rg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de24c85-c11b-4999-844b-08db3999b301
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 08:00:50.3449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObKe2f0zAhJ+n4VJHIoCAX6vRASmO8z5rztiWz2WQ17QS8r8gsrDThfJeuzMgJqyy2ehLlTu0uscHL60+7bHWEmGUDqPrM/qSMZL3aIND6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5668
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 12:43:21PM -0700, Harshit Mogalapalli wrote:
> Smatch reports:
> 	drivers/net/wwan/iosm/iosm_ipc_pcie.c:298 ipc_pcie_probe()
> 	warn: missing unwind goto?
> 
> When dma_set_mask fails it directly returns without disabling pci
> device and freeing ipc_pcie. Fix this my calling a correct goto label
> 
> As dma_set_mask returns either 0 or -EIO, we can use a goto label, as
> it finally returns -EIO.
> 
> Add a set_mask_fail goto label which stands consistent with other goto
> labels in this function..
> 
> Fixes: 035e3befc191 ("net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> This is based on static analysis, only compile tested.
> 
> v1 --> v2: Address comment by Simon Horman(better goto label name)

Thanks!

Reviewed-by: Simon Horman <simon.horman@corigine.com>
