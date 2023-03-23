Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176ED6C6B05
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbjCWObT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjCWObR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:31:17 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2098.outbound.protection.outlook.com [40.107.237.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4F62004B;
        Thu, 23 Mar 2023 07:31:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cajOilFPivrYs3F9dSq02XQr1pHYb4wiVlfAf8MajA5F6k1ib9Hk3ou3CGE7Gm5qiUvFFrRki+ip01FMegLXWryk5uthIMlSGF6dmj/Nkl8veTyf+XI3XORxn3IUgAeeKu7Lf5AWJW4J5j2loKUo0dv83Tmqz5a87B6zkcfx2AnuX1kXsGD+zAVhRQt0mPoUPn6tkAE5DN5VZkrUbfJ9hgxlk4lhmd9Mj5YTZ84sjNNvElOW2IR7be7UnlmYlZv8pJKcGjpGtKV7xBaVPbDsixqSJD2mKuW3Lv/4tkQ1JhOn4NUb5lVEPVqsNNaRs+9RO+fiXPEJ2ngoWw7VlVE4GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxQWlnU1IY3iP4uzGctcgqVSqaZ8+1A1/FHudsipLyY=;
 b=J+SEzykWOy/oQkoqJDxez4/N1o4vqd3n1yJ+2v/8fzs33YQjnVkNyfkmlAn1sWs69dTiyTkHs4GO/ruJjEk6qPAFyxU8Om2oHKeWFv7GGHLPCpnfbbYplfOJuIooyUFfrKfFjI/zuWhOcBj4p1wvQROEDW7T+ENST1szJnFM2fr6JLxjmN+GPcXkcb5NltaoVoQ3NuvOnFll9AkReU21QN/BzC8m1jMmHgAivv0bdl0j1HVfXKlCSz6wfdzA9ordrfe2Q0ttfdtG948jhQg9IO2pnTx8t+e0Rt34iQ9TvPn0OlITd4p+b//lqfgnZyVh5K4Ora4G5kc+gMuz9MR0Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxQWlnU1IY3iP4uzGctcgqVSqaZ8+1A1/FHudsipLyY=;
 b=R0oZNgiy/PW9lTkH2fcejn5YkxZcx/LK1nfRgCJC29IKPpuWDMQWn+8hjufFmKpSlCYi54qgN+hr1VHzO2W03l3R/Uzlc/z/aycGNUqyZfTs3c9b1lG4/N0dvlQP8cTB6ICFNxifScE6mXysWYQtjQ+ygEP+26BubTd1anvq1/0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6133.namprd13.prod.outlook.com (2603:10b6:510:294::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 14:31:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 14:31:12 +0000
Date:   Thu, 23 Mar 2023 15:31:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     hildawu@realtek.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        apusaka@chromium.org, mmandlik@google.com, yinghsu@chromium.org,
        max.chou@realtek.com, alex_lu@realsil.com.cn, kidman@realtek.com
Subject: Re: [PATCH v2] Bluetooth: msft: Extended monitor tracking by address
 filter
Message-ID: <ZBxiqB7uboVw23Jl@corigine.com>
References: <20230322072712.20829-1-hildawu@realtek.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322072712.20829-1-hildawu@realtek.com>
X-ClientProxiedBy: AM4PR0902CA0015.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e368fa8-6415-4baa-9e76-08db2bab4064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Imi/TMaBVVLpsk/oC55YExPJSPwltym20hGOW2SVtrKOJR3AzdePj2Z+6Cpfvkkp3EVOO/E0VbFeTE0J532EFALEAvyhqUpZuBNupCdYsJLAkzGN3dqvpdt7+BbE3el9M8dNcQ12uJUr7iGjtUWNAVRbRj3wX+ScOPZEbvBzd2DznlfqTmCcag2aWfsGL37Ct7POzX2fUcSBJNQrmP3LRd1uzX2ekfLGKrtqXiblrHPdKadkxvEoRFx9nMfbYbQTgJsWk4BcUZ/C+32Gj7/Fe0fRWQVi6fk4OLhs3UymmNFfFVhJEW6rzy/ukry4zKBY8KqRU2euKYV9R7d9kxYJYQS8dW/P0IUPEcyTbdWZtiG7aDuV4PFLAut3WK79WeHGdpx6enfK7umfxYn0XmZLYcjlW+txXs8ctrl2dg78T9V0wo/027ys9lbEwGw3F4gfqoomsLCdQB9q9/J1IWnqUMLRJTDqsWL3oQMDxmZ2Wk0oZ3Nj5l189dmTtHsfJ8ryMgRy8hdqMMzg392WuXp2For2s9swlpfOED8bI/MFjM8cispHMqeigv6PnvKFa3hxo3PwrbzjlIn/b568crSeThlxuUniF8VAInzN6Q1M3ZBs1Pzq+2xlZswRWZUw+fpC3nWGG57Y4UJgtd5aWB8E0GXPZx7O7VNNqor3mfeFZzfX6vucyQjqdIx76SVtsTT7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(136003)(39840400004)(396003)(451199018)(2906002)(5660300002)(44832011)(7416002)(41300700001)(8936002)(36756003)(86362001)(38100700002)(6486002)(6666004)(83380400001)(2616005)(186003)(478600001)(6512007)(6506007)(66946007)(6916009)(4326008)(8676002)(66556008)(66476007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iqWwDitl5Re9SVN9CCvldSfDtxsyyqSUxWI0J39hegOFDffDSwEC16ZQgO8A?=
 =?us-ascii?Q?paT3MA0VkxZpYjH/qVo/nbhrXLVm2Tc10kztTZ/F9Rja74BkRF1ICehTTNuR?=
 =?us-ascii?Q?2DfSPFFJ2pCo7a3LOJeOO53pADQW+v6212owHtwjQCpAL3/m4+g2FEu9W7wf?=
 =?us-ascii?Q?tP4z73ni64PbLDVRg3suYI0pwr776KArPNAXBKpGZp/54hFsv1TpHt9BSLv5?=
 =?us-ascii?Q?a4h7b6Qqd2YC/WihsTZfL00M8lqhL4z5Maj4GoohT7hqkUYIlVjgHHq3+RQN?=
 =?us-ascii?Q?qT2E9QO+uGeknO8WIBffTlb0DOG0Cyt+4b/ivpjoNngpkNLgO2QM9/wnlsE4?=
 =?us-ascii?Q?NmEGjEgeTea/i7Pa6XWLrw+bQRN+HFztJGVYn4nQ1YyPWpzw5Q+aYyY52m4p?=
 =?us-ascii?Q?hw/5KEedJEYKDjY1U1ckSuq2mXyCD5ruDCCF2y0gDJPDG/knVgn8mqgtDfYb?=
 =?us-ascii?Q?TH+NVl4ADBHSeQzGm7zAkNCAJG+lljWJ+IPWourUBge9hXefE9aXIgadTPvA?=
 =?us-ascii?Q?9Dr5Vt2q07xCp5XZed0dd7NVUpVETHaFfL7flKUnVWtiwsEUDz2uzVQtJqVv?=
 =?us-ascii?Q?+gwJRpv5D4ESHstt/maBxET8Aa0cYJAAyAg1vy4AYJoDskTdIb0GvYBygOJk?=
 =?us-ascii?Q?dF4+bCCgOm9WHpwlzv74obbUECkFKMkDfz2e2lLiVeiCYT/vcdvt0k5Y1qaE?=
 =?us-ascii?Q?yih0cBGVBxuJ/T7RteoLd1ljV80PjeN/CKJCEora2FebYlFYOeYVWq7nnaCn?=
 =?us-ascii?Q?Fb5u4nPcHxQ9XicqBUj0dbTKXWTGHtcNa8PkrCJCBTwqJtAz+SuBCftLmccj?=
 =?us-ascii?Q?L5OWFNf9jugMG0Ql13PAHkpuD17XKK7mh/NKWba8scByovep0bi/odQHRhAX?=
 =?us-ascii?Q?tjrLxdNo6CjxqlGZX4a2Zr6Y9svQpeCePcWP6Otk/MU5rrevM1yBP80QWLeU?=
 =?us-ascii?Q?63GO+tFHOrJPeNhJF9YBeqelrobn/KcaxwBqA4YsCxEq7LmTQ0hiVDT0Mrm+?=
 =?us-ascii?Q?1jENjw/ldpU6iJZ/RwVhD2lxl2UnSHtMj/QPMDbGDCQhEddSOQtqFizBsYa+?=
 =?us-ascii?Q?Dy3GINo9mJbxCp48dOIg9wwbNHLIiN7Hzcgor7D6VbEMK96XDrUrSjkKpSVi?=
 =?us-ascii?Q?pwxYjsNULqelRieCaNfz3AtZ0h4DNqJsmy0LAuhYOzNDtXgGFvhfTUxvi9aF?=
 =?us-ascii?Q?LxRfCGT1z5x1TiuuCzuUD3ZBLmEDz68puSMg/nV7gDnTIOE1B8+SHFIRsiyq?=
 =?us-ascii?Q?eGMix1UpKchx/RCviK+4QCjdt7/qw2OZUjNgva1ZKnpYIWSbI7Lqz6MrsZe2?=
 =?us-ascii?Q?ZrsK8u9Zw0XM12G6UdfBC3XctXuuTjLW8n88MlAE0EfpFWTBCqa8jbtsoyIg?=
 =?us-ascii?Q?IEkOdzGfmiiFGpOoTotnncwtIhxRM3/JT04s1T6fcNJrM+FTF68A19RoL/Fg?=
 =?us-ascii?Q?2EjbzkRjZVW5M4rFn/i4y78NloWRbznkbXXYQ9HDmxAMxsclSNyKQCO/Kcio?=
 =?us-ascii?Q?VIAU06DclIvTIEyqT19xX6+DCqS0zDhCWb12725ykOjbIjn25EmfRgyX21VX?=
 =?us-ascii?Q?DER9uYj4NlBAnPwQCLnabjmrfye6E/w6RyJxC7gWSADniVxoeIDP+Xplks8J?=
 =?us-ascii?Q?twww1mPad/6wa5cn1+LFMLlb5PC4eceZftZJJHUeGcXG+oBhKXTDb5gF8hSu?=
 =?us-ascii?Q?tyyzmg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e368fa8-6415-4baa-9e76-08db2bab4064
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 14:31:12.5138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2ZWdwFS+r3lZrO6ISPA6jg3GONrv1fQHZxqcZquOZkMjp1fteBMRRlT6RP4ip5iR8PyqWMFE/CHdqr4j2BSiLFC49hhd2wMJ2PDLFUU7i0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6133
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 03:27:12PM +0800, hildawu@realtek.com wrote:
> From: Hilda Wu <hildawu@realtek.com>
> 
> Since limited tracking device per condition, this feature is to support
> tracking multiple devices concurrently.
> When a pattern monitor detects the device, this feature issues an address
> monitor for tracking that device. Let pattern monitor can keep monitor
> new devices.
> This feature adds an address filter when receiving a LE monitor device
> event which monitor handle is for a pattern, and the controller started
> monitoring the device. And this feature also has cancelled the monitor
> advertisement from address filters when receiving a LE monitor device
> event when the controller stopped monitoring the device specified by an
> address and monitor handle.
> 
> Signed-off-by: Alex Lu <alex_lu@realsil.com.cn>
> Signed-off-by: Hilda Wu <hildawu@realtek.com>
> ---
> Changes in v2:
> - Fixed build bot warning, removed un-used parameter.
> - Follow suggested, adjust for readability and idiomatic, modified
>   error case, etc.

Thanks for addressing my review.

If you do need to spin a v3, then you might want to consider using
reverse xmas tree universally for local variable declarations
in your new code.

But that notwithstanding, from a code-style sanity check pov:

Reviewed-by: Simon Horman <simon.horman@corigine.com>
