Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E1665327A
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 15:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLUO24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 09:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLUO2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 09:28:53 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2097.outbound.protection.outlook.com [40.107.223.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F9C1F5;
        Wed, 21 Dec 2022 06:28:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edSTFyknVQS7cjsxXJh7YZYtsWLGm1BhMGwGSRKm+mmK+ljz4a/psva4EOz0iALOd/8+Cu1lH8Hqq8KWNy7+FVd+6kGoryC6QaGn703JzRsMW+J+PerOVoIaW8zGSV/j/PGSXUVdwxGLlcQYbALjeOQXXbJXNxUGRJaEHMEHsG2C/ZvOqajclI4b83D3TV4QCh1G2qy/Lodc+HAEYHLflXkXYHKm0d8+VIhlRUbR9kLY3g3P6ZLrTAn+Ew0RYIC+L65NusvPolN3oU841OGHPDBlqGWcTbpGORYqHUbJ0/hwoE2rLbrgCmzwsOnvLcM6Tx6M4/fwIcp7c1giFkX4qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1smaSuN20mf22ESDFqt5t1J97rx9xqmvMKdYyl774/g=;
 b=bFVTTM0a9sEozhDPdOzhSOCSeExO2OKaUmap6KiUFBYIaDIijCRsqaD/icaDCbcHvJ6EsmNbbTr+cLGxRRmT0iWaMBsOuj9V930AwT8yS9NLnCWCC1fM0zreFQ9aN1kxLT2odNXe/EpngbL6MXb4WbE/xLLe2sbyRF77dPR1haF9iwNXA68KEpAJZ+muXm20MJVjy3uSrSXJlya9Bl85r3Adxl8F2AWNVC9sl25ia1gQDWDhLQ9nOjifCmg+o069qj7EYd1qvGk3r+mKCeeHrSa2PGo/9A/rRGcJCIopStIYiRyhHBmyGU67aeZZ4n4Z3R5AUJAB+MaBMI/E38SxMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1smaSuN20mf22ESDFqt5t1J97rx9xqmvMKdYyl774/g=;
 b=j8g6blRVemLbYWX99dleDrLtk+Kv8sp1Jvk0R9wZeTAolNVu/qFbEtU/Apvvwlx5VhjmiwHrAyEZT2LrWq0jFnD7CGgVBc+JybW6mFgqdBgnreDKAK8ShKhk2i5rxA3yGGqu/Tw9p84V1ujL4pFJqVafC3THd2cG7SjkKAL9t04=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3886.namprd13.prod.outlook.com (2603:10b6:208:1e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 14:28:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 14:28:46 +0000
Date:   Wed, 21 Dec 2022 15:28:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Aldas =?utf-8?B?VGFyYcWha2V2acSNaXVz?= <aldas60@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: remove unnecessary spaces before function
 pointer args
Message-ID: <Y6MYF02RgdtA3SJK@corigine.com>
References: <20221214205147.2172-1-aldas60@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221214205147.2172-1-aldas60@gmail.com>
X-ClientProxiedBy: AM0PR06CA0075.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3886:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ffe2513-f0b1-4723-d900-08dae35fab6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: prrNvkY8sYtfRoWCSv6O4vP11D/nBqDimVvhDht8Mm7sBfz2loGqzIJBTfPRNx+6+pYcd7idZiADUUqO/bPx3oSolpq99mleBEasKX9k5CtIBf0CGKNusW7hDARIbQHWGykRdKPnxJF5o+G6227Lbz3ckayNPB8CHpae2Ug3pveZ5N0195znfno9XJP7P6QoCd0eS20yoewb7xywiUWWdeqKbYzL8QyoJw3JwyXmgHw9kgoYdRX86WyvWigcp5bCEDD2guNvenBmzxAqzvMO6/SezpgmdGBu1MDh02phozU1KF81ICGl3HLjuDrIlmHEjO6EBoJUXGzPKoGXAYRTRKqBkSmajptgZKD3pE2plIXZfGB1T55LNPJl/3Lkp8m6sTD3i/aPDBRSajoCHKib8mbODQq2oZCbKmu9R2qUMZY4VK0mgaoQPFzGm6K22+42YJlFTkv1OjbWpQ5DTYAOZ6J0YYNPsH9QmvmkgvbP6kPVw26RyUJhwz57cqVF76yYRqtnhfSStEJlFEY9QAS4+rSdbXfnsQMhALg7Ig2/MPd4xMc9+p3hbrmLNx1xp5FwBPY1Bca8BP/Y9dokYl59axv8LQhwPU1UfOnNYl9tOSiVuIuzgiJjzAF3ch5JtAP9SCO6gX60cZapghfnsnga8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39830400003)(366004)(451199015)(478600001)(6486002)(6512007)(6506007)(186003)(36756003)(41300700001)(66476007)(44832011)(4326008)(66946007)(66556008)(8676002)(5660300002)(66574015)(83380400001)(6916009)(8936002)(316002)(2906002)(38100700002)(2616005)(86362001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmREdUFKME41SDg1aXJCOFBZdkJNUTNTMHliSTQrVGt1cDMyQTExOGVvNWZp?=
 =?utf-8?B?MzdibFNvRmlTdStxRzR2ZE9JTEV1bHJiNXVLa0RveGo5WkdFOXVibERuSXhk?=
 =?utf-8?B?YXd5d1hzanAxZ1p6YkJsTE95cWdQWU9lNzgzVmNiQUh1bkJQWUxYV0I3V0Na?=
 =?utf-8?B?Q2dlZXVzN3NrZXhEYzR0SG5rVm9DUkk2ZS9SU1hKVzhPSHhJZDRncXY4UUpt?=
 =?utf-8?B?ekFNYXE4ajZ5dEdsdVVwelV3YWoxUUp4djRtVFRON2tWVGZzOXZlcXVwUTdH?=
 =?utf-8?B?UCtrTlF6eXVYbjVYN2hwTVlDRDRTSHY3MzVWWS9JWlpZamh2TDVxWTN0RjJn?=
 =?utf-8?B?dWZWSzFGUHQ2WWdKNlB3eUFjRVJtWHVNaW4yQkNaNjByTnlVWkRTa3BPS0tj?=
 =?utf-8?B?WVJINFh0b1hBZGE4NFhXMHladzRadkQwNzkyMm94UUNaRHFqa0ttNkdLOEpu?=
 =?utf-8?B?UzgxeE1JYWNlcEczTDNPMWwwNXk1Q1YzSURGeEYycXRhTkMxakdqSHlPWi9s?=
 =?utf-8?B?VFV5U0xOVW1tWWNoYUI1cTdRbnpOaTI4UlZXMjVtL3p3ZFJIb0lRY1FjbXdD?=
 =?utf-8?B?L0d5bm1QL2NQQUNHRFhndWhXWkNTdmJJZ3h4RmRUdVBuemZWN2wzQzkxRkVq?=
 =?utf-8?B?Y3E0N0RWVE4yZm5oZ2s5YlhBek45MHZkTldrT0FMMjV4cHltcndSS0d4VkVK?=
 =?utf-8?B?NTZTODNlNnBENDlTN1Z1MEJaWkh5MmRVcDA2a2o2aUtSTVd5dGtNRXdod2Qw?=
 =?utf-8?B?RU15eGZTU1Y5WkdZYlk5RHBVc1FVUDFuSjRLbVNSNk5LVEFHZEVoN1hXcVAz?=
 =?utf-8?B?TnBUd1YzaUxhaWJaNTF4QnBBb0tZV2NlN0FjOUkrT1orK3RVc0cvNDVFTlkx?=
 =?utf-8?B?WFd0WDE0S21uN0dISmF3Z3haL2ZwZ21vamJPK1I4QllqeHV6d2dkWkVpdFBR?=
 =?utf-8?B?ZzVWNmF3Z3ZIdHIyWm8wNkIyU3ZWQnl0YkVnN3lFQkVvS1U1cS9Ob0JFa2pm?=
 =?utf-8?B?SUFBbVhIWnNTWE95SkhvQkdlVTRnWjdSaDhhVG0zUHgxZkd0ZmRhbFVSbktC?=
 =?utf-8?B?cXEyd1JVRFpWZlFnNTF1M0tGaXBXVDd0b3JvcTJiY3R3VkJMdnFLdy9lUHFG?=
 =?utf-8?B?NWlMMUlqWHkvVGtSamJKaW1aUUw3TlMvL0Q4bTVyMzkyRXNjUUltSDM5bVMw?=
 =?utf-8?B?VDhqdjlzM3B5U3NlU01iZW9NaFVtWXhxRDhqQyt4V0VCVThyd2cwT3Z1TUZZ?=
 =?utf-8?B?Z05kank5UjNZNlJmNTM0TGhlaTcrSnd1UWsyMVoxTE1zLzZydTZ3M0JMOUhG?=
 =?utf-8?B?ZTlTTWR0THl2K3BabVMwOFFtOFd3Yy94YllpclBEYklwNkdMYUErTnV1cFRw?=
 =?utf-8?B?cTNBWVJFVWNON3JZVU4yYXN2Vzg5Q1dhR011d3NaS2tjeHB0R0RuU3lkd1ly?=
 =?utf-8?B?aExtRnhwMGphQWMzMjNzSG1TKzdqdGRpdy9XWmdmS25SSm9kUmVmdGxOU3Nw?=
 =?utf-8?B?eTdpbXhqUzc4akFkZFBrRlBCT094cjNTR0ZhZEdEd1JqVForR004NUtYNk5C?=
 =?utf-8?B?WENjYzUxcVpJV01MejQwYUtsczBjc1Y3SjdVZVhBWTBncmF0YWtRbjBoc3ZT?=
 =?utf-8?B?aHh3a1k5ZDFORVNQSFlFVDdsMThoNXJMMTBwQUZ2a3k5bHRJeHF5U2ZDY2Rq?=
 =?utf-8?B?ejJpM3VtSHpLRWVQT2dlN1ozcDl5eGFWWGFnekRMT3c1S0FPeXR5VFNiV0c2?=
 =?utf-8?B?S0RSSXlDbnNjNmY0ZXIwT2JKY0NidTRNeXBZWE5Nb3orZnVnSVhrOGxhb092?=
 =?utf-8?B?TVpYV2RMeEdmemxrVlgyRmZ3blNDV3hDekhxMUk1SUdxV1VUTDdXZERFSmgz?=
 =?utf-8?B?Tmx0Rm1aeWJHTDVxMVI1NFhlRTV1YmlkczZUTFduYUZWZ2tBanBRcVY2SjZY?=
 =?utf-8?B?ZXBxL2FELzk1UlliYXQvNEd5L0RVUkNtcDByeWE2cWdxNWNDN2gvZnoxNmxl?=
 =?utf-8?B?Y3pTKytFZXM5Zm40UXVqZisxQ2o2a3VmeW9Cc0svOXplQTNEOW4wVmQ1NG1o?=
 =?utf-8?B?U0JaUGFHMVVGT2dXd3kvQ3RWczVEU2RnR1ROcGhOckNST0MzTVdvWHAwN1ZL?=
 =?utf-8?B?SUNQTWtIdDJxcGxuKzM2RS9uZjFYWUlQUGwvbW9DUElRTXF1Szh0TnRCMjVR?=
 =?utf-8?B?TFAxR1NJWXExZjQxUEFSS1M5UU0yUCtFVVJFTHZScldjaVpKeEtRNVJma2J4?=
 =?utf-8?B?VTFUak5UUzgycGFDbWJFRU5VZ1ZBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ffe2513-f0b1-4723-d900-08dae35fab6a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 14:28:46.5838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6B612CgCUGfVq0YKniZsKYISnDZWQUtOa5AOSyxgiK7FVGOwCs8GxxqN36+DwJUTX8s7By0L2Iya1D90DxsJRisNTJeiY1ZwU+XBnNKHss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3886
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 10:51:47PM +0200, Aldas Taraškevičius wrote:
> Remove unnecessary spaces before the function pointer arguments as
> warned by checkpatch.
> 
> Signed-off-by: Aldas Taraškevičius <aldas60@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index fc8c5ca89..05e4f4744 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -2057,8 +2057,8 @@ enum {
>  };
>  
>  struct nic_operations {
> -	int (*get_flash) (struct ql_adapter *);
> -	int (*port_initialize) (struct ql_adapter *);
> +	int (*get_flash)(struct ql_adapter *);
> +	int (*port_initialize)(struct ql_adapter *);
>  };

I'm not clear if there is consensus on the style issue at play here.
And so I am neutral on this patch.

But perhaps if these lines are being updated then the following check patch
warnings could be addressed.

$ scripts/checkpatch.pl --strict this.patch
WARNING: function definition argument 'struct ql_adapter *' should also have an identifier name
#122: FILE: drivers/staging/qlge/qlge.h:2060:
+	int (*get_flash)(struct ql_adapter *);

WARNING: function definition argument 'struct ql_adapter *' should also have an identifier name
#123: FILE: drivers/staging/qlge/qlge.h:2061:
+	int (*port_initialize)(struct ql_adapter *);

total: 0 errors, 2 warnings, 0 checks, 10 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

"[PATCH] staging: qlge: remove unnecessary spaces before function pointer args" has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.
