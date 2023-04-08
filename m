Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31866DBB2D
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 15:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjDHNcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 09:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDHNcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 09:32:15 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2095.outbound.protection.outlook.com [40.107.102.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11D159C0
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 06:32:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTkUMmtFNIoRfoWY5IczGhqMdhONrp5x0NXkM7QgGG75w6RfPfIackvHabk31jzGCAt4OUxidXBLnAWljywZp070frjwOgRoGj0XDIJBFkHFRb7/PH0QUOOMINc3qEW5Qpi5r6MOHL6gufaCy0Wtx/pXWSuhcc0ApZBiYA7nle4q/ufZn1qcBUjTIibuCUroKo/AFmbIk4ySuf4tVRwNUIpSNsOTPioWz7b0AZWrbTcCB0COPFcaknQdV5ueCBv8vEYOYQKakMSmQf3bneAV5sTX6VEclkAweopR7+vjUCDXOrhqQo87KRReHnJNog2DZL6IO7C5gB9Fp6NaZw/1wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAgrf2M8Arv6wwmFDFnKpDa6sMvtnKfMyyr+gygiRrg=;
 b=JR/Z6Zd7k8mIa1Bvx64FgMlfANL036eC5252Aj3rvJNzybD6lSF9bLp8VWrmUY2LOorDwpKX9I+7xGOG3fG4cQPBKdSOg1Gz7QeAu5MVZbdH7qn2JjHpCJvwclWt/mopFxjAlkSlhYJ4bC3Y1REc7YHVF3u1ivirlOoA4mxPX8BHQijOPMlUscvzqwSH4u/RV51GA6gDn3V9gmWdukZ6E6YhVadVNrYk6ScY2dByrqjaBzgxoD9mmGKy4ekUXqmcL1N1/28mzKgVLRcNtZUMcbOz8cbW3iQOMpAalWjNB36crZDKVRYgMMCqPDcDHhEakuf9D5D5sX/CXpVv569uaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAgrf2M8Arv6wwmFDFnKpDa6sMvtnKfMyyr+gygiRrg=;
 b=VRbAY/bx2Y9h3oF5rzw1NNzG5CQMTTgFj3D14XHnkOKO0NgI9krGpTkHYebEMpWNGZJ2F6Sl1b0TDMRyerO67nFhYaaDivinsFYS3psia5Dh4bKtZwdyKEU72Yz1uK48E/JXMSOH5gK0tXitW3drqNaggYivvVi5BbP0JscHukE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3862.namprd13.prod.outlook.com (2603:10b6:610:a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Sat, 8 Apr
 2023 13:32:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Sat, 8 Apr 2023
 13:32:11 +0000
Date:   Sat, 8 Apr 2023 15:32:03 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, shannon.nelson@amd.com, allen.hubbe@amd.com
Subject: Re: [PATCH net-next] ionic: Don't overwrite the cyclecounter bitmask
Message-ID: <ZDFs0wYQCaHTLCDq@corigine.com>
References: <20230407184539.27559-1-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407184539.27559-1-brett.creeley@amd.com>
X-ClientProxiedBy: AM0PR02CA0119.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3862:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e697226-1e76-4fff-2948-08db3835a850
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhgdZr0QIdG6V48IiM1rsdOZFS4ZGbtasPqmAiXWkdmwQ2QZbUrx4QxO1j/1CiWwDv1p2720iwMMznwYcBrhTC01OZlO7PghUj3UKugZLsrZGi3h0lU11ITM6+d/ixBSBS5A2mysW8kSSMT9/lM2HeAVKWLrkvERVRAZrXm9UfbS1+UIRoFFimTvtntqsU1o4dC+PSRTj86l1zlaZdYjI/fgYeveYvylrS+kUh87od72V/0E5CVIZH/l6IE47jvCkZVgQ5kYlAmzkQTEuWf6dX6SHifaLfJBaerKVLRxMVY7g1/pzZf26m7w/w4l+96ugjxxPyi663RzJZKeiRtvgFqwHRwC05R6dnqT+/ZM2SAOx898szkufvYExCJ5P3vAQb+wr9J0r0cjnbp60zm3BfAuvZL8owU4rR93D43TvRcvbZ4n3p68yIIgDkHW5hxC8o2jfSovx1QiIQ1uEMCvNDg97tyCm4/QaM0Qh8nUu6qLtDs5noBYlwrDua2N0tt2fROBLiBlfHmheJtqWCMlJsXVyPRPfn3qSCYaTHh22FIE8KInCtwhZrgaSMu56XRR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(366004)(39840400004)(451199021)(478600001)(86362001)(36756003)(38100700002)(2616005)(6666004)(6486002)(4744005)(2906002)(44832011)(316002)(186003)(6512007)(6506007)(66476007)(8676002)(6916009)(41300700001)(8936002)(5660300002)(66556008)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/ON1yYARmnn9yf/iqQOF5DMSUQP4LGEkTjdmlQTjFXN+/wgpPzFxQFYS6S2C?=
 =?us-ascii?Q?37nvxJ0OJj0AakS8QF36x4I3hErIhglLM8fvQQzw9P+7AJ1G9vtBYUZHXN+d?=
 =?us-ascii?Q?SDmbk8gSmb6ZxfccFBkQ19FsHicLCbnE2OxNe1WIJ4rPicBtu6FNC4HNA+rP?=
 =?us-ascii?Q?iTZG0MLZ5jfjkCphu0afchH1U/ojrn1PEHHfKvGCnLRj3Goh3gWHSsBVwnXV?=
 =?us-ascii?Q?kWy5Ks+oRM2Q8zx0kPDWa/ILTPZU/bGSRaLPSjLy0WNq902HxNrZJvGQWdVg?=
 =?us-ascii?Q?stv+yu3J0ZoJurGBKgGF6KG5dwstKGSz++BSbMMPyLh+0FaNchANDkbALkRF?=
 =?us-ascii?Q?DIpCU9PS6upE0DcQHWu8Ts6M+/r5FNEQNLLPP2KaHFvDgDi3PtO5VsHMiOO9?=
 =?us-ascii?Q?21JDMG6b++amc3w2rNcThYVR0v50PAzjFxVcq2PI1eETS3tMAAkolQ+l3ww3?=
 =?us-ascii?Q?THJUpZeg5ChfMSRKYZvkQUiYZCJTy2EvXDGS8mjB7b8dff6/bdSJkUFyh5R2?=
 =?us-ascii?Q?HgDm1D+M1KbNtZXw7LrtfCZ9v2bOfkstcRD+sI0hZE5GsFYQjQGNrzmWzl4L?=
 =?us-ascii?Q?v/8a3g9UMtAlCpLhe2FeEX/U9wDDaiHqSbNQjLtPDD+jp3XYB3zQsh+SvIhN?=
 =?us-ascii?Q?6aMGttfto9AywaXvTtCR6OqIO8g0Ypsnma95eUelAhQH29DA2IgJcGkuiZpR?=
 =?us-ascii?Q?+dMcRmUF0XN9lppXkPGWlq+KFz96Vo3hiJmHKGQJynpBe3itSYvMqgw4Qu9h?=
 =?us-ascii?Q?t4nnpdUliY8woTPUZ6z/YoVSWp3NOUUQ62KvEUk+9scUnlmC/YnB2fFngQ8J?=
 =?us-ascii?Q?goa0kuPtR03J3tiIuJRBvcfWxQFwvJ4XYWhPrOkXiqN+zjIlTuLsFdYlDM8r?=
 =?us-ascii?Q?61Su6ZIhH295u6Ba4XSz4PMY6/jDt3PDdXRAreG3DL8Ij5R9rv0NMlTb06Ue?=
 =?us-ascii?Q?x2cjzGdX6BgMAtyUIVAdYDyvS1SS2YP8PiClI7Hc99S+PlVSqRWPCGFLDciQ?=
 =?us-ascii?Q?3e/zSIjs6KODMreC4cuBGzCBcX7+FHtr446gnpB3Ji9ylcf3jzbbTrpV61Lh?=
 =?us-ascii?Q?nDm1s8GIGDbQpe24GHCc3dDmo4bjvkzGEHa/fUvGJLQE/lQ659UZxDhu+zg8?=
 =?us-ascii?Q?60V1ddUJl8ps4Z4v2Gy8g3Ea2Qfy7bSWVU/pr/3dbIs6D/yV7vaMG6PqTXH2?=
 =?us-ascii?Q?cijEdN5FnDy1C32FXW/DBdg/4eQD7s5cQS3iLJmUEa9B++Ase+CiFdRCE0B1?=
 =?us-ascii?Q?b1nu3viPOUC0qMVxv1GzJ2OaCKs4fsKXniS/xcs1smKZP0M8/xNTqzA7K5ds?=
 =?us-ascii?Q?Xewlt/vsAX0tfAKnXO6JqmX22no4hOSBfzxUbNC+jh1tfQ5+FJavEVfUJd3r?=
 =?us-ascii?Q?o2O/DirzCrw2NKYwwtWXSWQ3457xgHlzQbuz562ZDzu2JPsNMewELfdyRsgi?=
 =?us-ascii?Q?3WyYyElgydH2S1vzYjNsMJ0fKRA4FWXSEjUbjCIV976lNoP7dJ1csCPeEHdA?=
 =?us-ascii?Q?mbHQXAlDduNlOSamH3Yq5hWdnJjbfjRrgyBiEO75vfavYJuwV9WYqVUbKVcA?=
 =?us-ascii?Q?52rdZMgQqbXW4E6hAs7BQlqmfzWhnSpjEBMTUVwlxr51mLYiSzRt3Sk1a05R?=
 =?us-ascii?Q?miKtMVRQEk7Io3UXTWmiOni0UVPO7ktBGP573mVFW9m7bj0JNwRQ0rO14bZ8?=
 =?us-ascii?Q?EKIKKA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e697226-1e76-4fff-2948-08db3835a850
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 13:32:11.4824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWFIjtTbherUQd3Wc0Gt3KN6HQckbRsIGmq2oK83rBsQoCK0bTgVJafQ3KGE2fTMfH1vdVBOpgnFHWE8e3By7y6tdfTEgTeTFmA3VoOIg7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3862
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 11:45:39AM -0700, Brett Creeley wrote:
> The driver was incorrectly overwriting the cyclecounter bitmask,
> which was truncating it and not aligning to the hardware mask value.
> This isn't causing any issues, but it's wrong. Fix this by not
> constraining the cyclecounter/hardware mask.
> 
> Luckily, this seems to cause no issues, which is why this change
> doesn't have a fixes tag and isn't being sent to net. However, if
> any transformations from time->cycles are needed in the future,
> this change will be needed.
> 
> Suggested-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

