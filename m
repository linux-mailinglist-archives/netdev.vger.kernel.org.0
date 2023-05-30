Return-Path: <netdev+bounces-6255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 167E371563B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3E602810A9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED23110944;
	Tue, 30 May 2023 07:09:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA48883B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:09:22 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2119.outbound.protection.outlook.com [40.107.220.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CCBA0;
	Tue, 30 May 2023 00:09:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7dV/eGQG9lsGCXGH93AJnpZNhmsq8/MTsc0tDWDQsZ7fS4xwBYlHeS/3zKnfuT2ln4Q5d9KtM4sD0kmJafn6dF7b1ZEE8/CdMIhHpshDjr53vHNW4+8MMTT+qZo2MwEN5ZgKSzwYcvKxiGcncLFU6tF9406VyCDlpCoP6XXPhk7QjOkASOofz9+v57DXCAUvhKZ0dFw1uCS1gN8qCHMmOHlEMCvhnkRaGygYm/nUlnOUKj1roeYCdt7ETdmVmuQqjChqRQoQ90CArLpBUWWnwq62KJRfVKx7LhbI20NEPYlyDhwqy0v6gDxDf/gARPPdM0sthR42PyEpgDqA9fzEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EG3RTjsD4cxSFoab/0Mpg9o7z+lp/3LSMJCda+6Qibg=;
 b=K6L28+2vaK4MJ+wQHHGnNgMkuTHOy3qn5zwaXTKnmlcLM/XGFP4UZ7Hh2UpCNpF80foSpmZ9JWJZmpTg+qpNZx5/xYy8pdm1ytgNr9A95aeG46KCYeBZ6YgcII+9BlD7eCQ1ajGbAPrVRTMeCiiBbTqbo+mZm1SJ+7Cq/fn2nIamC13ZoZDw1OG5jeMOFOYMB6P091t2TORT5lrotLvgv3zeMFQOMslpPxWT9ktV86Xp/e7FpmBEpUuX6UxcUmhm9xjJfrJGHbQ5Y8DWeWOzmRIqHiBcmFu+iwDVOZ/lTpcQrILfvgZ3K6Q8DmGX5xuzOiPI9c2GvBXwrK8UTIKf0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EG3RTjsD4cxSFoab/0Mpg9o7z+lp/3LSMJCda+6Qibg=;
 b=haE/dqsD3UGMnlJsz4kEzQLYhjHB8iVNhnjLq0k1yOzkWM6gke9JCIW1AQ96+hImmzwX9dVtdKV++T0FIbLF4oAapuvQC/1wxkEErBWsUBXnhw/+IiWDR40qy+wPxd0PAmuhC4CSbutd0QHrP1rFfx34jyg4Rgj/tyQ7zEf85Ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6072.namprd13.prod.outlook.com (2603:10b6:a03:4f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 07:09:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:09:15 +0000
Date: Tue, 30 May 2023 09:09:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bert Karwatzki <spasswolf@web.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	elder@linaro.org, netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: Use the correct value for IPA_STATUS_SIZE
Message-ID: <ZHWhEiWtEC9VKOS1@corigine.com>
References: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
X-ClientProxiedBy: AM0PR04CA0048.eurprd04.prod.outlook.com
 (2603:10a6:208:1::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6072:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d17515f-03e1-4735-b1f2-08db60dcc72e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f378oGUib7QpChMYciI1f8KeORnPsjZHmzuJvcPDDo5YwOVPNsGGuaNstYxz7zPyF5znycKl3NC3r2LUUh4u/70KJPfLaqCysidfwfD+XCDej7FX1B5InMtwdN2sIILKLB0phEHIJrOSIUeGnwMEJNAm3HEe0OgZgyz4ukBfG8svzKzRWnB1mSernIyyvwjdeNxnKrdzu5sx2PN8EYIqTpgqY+fZj018BN6/oDc948MSf6yv7zvS/W1u0cgRMAjLok0Y4ByyBTgbCUQzOcDR2upSEh3TbbwHJ3RqCpnk/Tn3EDDGUakPsrxPQ+8FqweZccU4UnoUd/ynWgKMyJZ1vJaP/1Hy+oWDHXDUCpGBY4+eWWd4Xh36CFOxEKBaS9qv6vhtmGpLdV4h+q67XAEwjxJIuegFrau5XvL/ZcfVhoLu64/jJA2zbZxqsDE+jdDQIeGIUBUmXXprjjNCGGk/w4Vx0WQb0QL6TKqbo85Rr+lHU+uMxmTXwwveUzaajLBqpJ7hioVvZizQkk9xxMZXAbsyaKqf7Dy2WVvnVwsX/yhMXinrcnXWBn36d/Y/5u/i
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39830400003)(396003)(136003)(366004)(451199021)(478600001)(38100700002)(2616005)(66476007)(83380400001)(66556008)(66946007)(54906003)(86362001)(4326008)(6916009)(6666004)(2906002)(316002)(186003)(6486002)(6512007)(6506007)(53546011)(41300700001)(36756003)(44832011)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G2wNr7I3q1Lnk4yKyZaNN9TGsgUcPFiS8gQCdoUgmLnsxkTUgsshat5Ha6XP?=
 =?us-ascii?Q?TetQYpfpr5H2hub2oMcK4DrtbaUU7m7XIlgUYc9ptPgb2s/MfARHSD5hMVDz?=
 =?us-ascii?Q?hH3manwoW2rHXx+bnjTJ8/OM01B4y5xB9hKVgD9ZDvdB7nzBKzEAmmvNM3Yj?=
 =?us-ascii?Q?XZwpGF1m2V4v0ImzRl4pNspjEMC5lLFP0EdFU/BKApuTMNmWgC51VLaKtay1?=
 =?us-ascii?Q?KEJM0GB5MAhR9DruZbdxRlZtMCTt/uRN3dJ/GqL1dm1MH2R+aWgL2GeaGdTy?=
 =?us-ascii?Q?k9bQzBXMj07qSBgtxiDmxdJsMCsgj4/T9JwrJUAu+310I4/BKzW/P9NXWK0i?=
 =?us-ascii?Q?tt1Y9N65RJFaHvcFtP5vM2nvBDXVc7SWlzVfJAiGpXp75O0dzkKPLrS3cTAr?=
 =?us-ascii?Q?zLekmvjauBHuJtvBTEc7G6X0URYYQYDnCZQgqBLRnnvXYWaABFqTWQzpm5jr?=
 =?us-ascii?Q?awOqsu1Qrz7zTcrDJmoDA065H2nEKFrKgzTmbPUz27NoXClk2Ic0+7XTOkc5?=
 =?us-ascii?Q?Wp86nmuKIr4eBqdyRK837NEA+9iCzOIjTD8CHB8mCItZ/7eN3HvMm+8Ein+c?=
 =?us-ascii?Q?XEyPS7Wb/DqA7T69tDGlrcEc1UFLIdRXPUYVZ/fkVG4UKlV1jtvGcXJS0jp2?=
 =?us-ascii?Q?wuJDR+KBje8cane39oogLlXgr07aWzV9W4kzkl8UOs3AcZ7dhjSXvtgiC8QW?=
 =?us-ascii?Q?wzY0JYoBN2RdKvI1D/VxsB+aJeHG4sAFgIEBMLr6LH8tUD9Piw0gnOxZ3N/4?=
 =?us-ascii?Q?GQM59MSIlOEVDwHhWFPYtkOF/zaGWeRLaK+Jrnn/9gUPVBMKVUAFSE7YOA3l?=
 =?us-ascii?Q?bNBgFd3PCgCdWBfojAOvx95twKfYhf3Oh6HaQu6X/qudivPn39sYZgXedIAR?=
 =?us-ascii?Q?qj8xKo7XCRYLMG98CN6mv5P0Dw3u1PxoOxktbD/iQxNpQey3PgXLh1kcGrm9?=
 =?us-ascii?Q?eNwyDwQIUb+e2QLpcEIA33fBf26kRSIGkOg19k/b4YcOG3LVN0eWult1SCJM?=
 =?us-ascii?Q?eq6xA56Wsn7Nl3og/CusjL5jh2JT0MjV7jWUaX/WhB6x92unEJw/d9LVqhv0?=
 =?us-ascii?Q?tXUtbj4CeJvjTwQx3pI9Pc6ZHUp1jdzFUNJNNAARWro3GzKKwrv4CvHfsUX2?=
 =?us-ascii?Q?clkGlSLdTiz1f5Y23Xdu9ZMrVRiWaUU57H93OyvkYaDXH71RItZ0gp7xgzun?=
 =?us-ascii?Q?8S2a4J+k7/gLfEtczeTdp5NscD0nWm0qW2D1cEJ02Q14G2JxEZUYe2GEGGmi?=
 =?us-ascii?Q?9RoM7aWKJ4TGkloC5oBGaksRAxlNGpOrqGkp3zNESK2syIH+iUNsqvL0QdiF?=
 =?us-ascii?Q?KSjy95zeE/PyAolFX9Kn1nsWnR9wWZ2v4S9DOjsk8MFLFqk9mIabkP1ElY/h?=
 =?us-ascii?Q?0WRW2Z/MzI/bOI2WxpaflczRUtlWl9HnFw967+wDh62y5ERHvyCRHaJOwQfD?=
 =?us-ascii?Q?XW6AERz8ea+gIjkfth7hUdGpz9s1nLG2szBbMI+GMHy1llp/BHbeNcTfRUrx?=
 =?us-ascii?Q?1s5Udv/Ueeg57y14LGsBFoHrS8jYQxunxOtnUsxnxlJiMMj75lob2NlvduAD?=
 =?us-ascii?Q?3fISVX00joMlCS3YBfSFKPoAP/+c3uu+oRBqX1GNYJIH0Q5G3dHXXffb6Tm0?=
 =?us-ascii?Q?kStS9E77d6ugW9hfeIYWYEWuQrx8xINaTarg4U7tHgR2G+UWvCOf5gcDaZjw?=
 =?us-ascii?Q?2vl2Rw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d17515f-03e1-4735-b1f2-08db60dcc72e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:09:15.5985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DocmbrPJL6aa3+kYFVVxbb07l6io9r52E31AAh4+rxqDXUkb1uD5E9jfkCeMX0RT6yAuZKtLhQ7c2nypfBysRsUHFmGTU6NEaGk53pGoT30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6072
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 10:46:25PM +0200, Bert Karwatzki wrote:
> commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c introduced
> IPA_STATUS_SIZE as a replacement for the size of the removed struct
> ipa_status. sizeof(struct ipa_status) was sizeof(__le32[8]), use this
> as IPA_STATUS_SIZE.
> 
> >From 0623148733819bb5d3648b1ed404d57c8b6b31d8 Mon Sep 17 00:00:00 2001
> From: Bert Karwatzki <spasswolf@web.de>
> Date: Sat, 27 May 2023 22:16:52 +0200
> Subject: [PATCH] Use the correct value for IPA_STATUS_SIZE.
> IPA_STATUS_SIZE
>  was introduced in commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c as a
>  replacment for the size of the removed struct ipa_status which had
> size =
>  sizeof(__le32[8]).
> 
> Signed-off-by: Bert Karwatzki <spasswolf@web.de>

Hi Bert,

As well as the feedback provided by Jakub elsewhere in this
thread I think it would be useful to CC the author of the above mentioned
commit, Alex Elder <elder@linaro.org>. I have CCed him on this email.
Please consider doing likewise when you post v2.

FWIIW, I did take a look.
And I do agree with your maths: struct ipa_status was 32 (= 8 x 4) bytes long.

> ---
>  drivers/net/ipa/ipa_endpoint.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c
> b/drivers/net/ipa/ipa_endpoint.c
> index 2ee80ed140b7..afa1d56d9095 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -119,7 +119,7 @@ enum ipa_status_field_id {
>  };
>  
>  /* Size in bytes of an IPA packet status structure */
> -#define IPA_STATUS_SIZE			sizeof(__le32[4])
> +#define IPA_STATUS_SIZE			sizeof(__le32[8])
>  
>  /* IPA status structure decoder; looks up field values for a structure
> */
>  static u32 ipa_status_extract(struct ipa *ipa, const void *data,
> -- 
> 2.40.1
> 
> Bert Karwatzki

