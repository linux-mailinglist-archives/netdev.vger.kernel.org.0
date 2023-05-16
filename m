Return-Path: <netdev+bounces-2900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6EB704785
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48D0128152E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1076200C4;
	Tue, 16 May 2023 08:13:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F8168CA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:13:36 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5317132
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:13:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLFHsrcy7CYDm7wMz+Pdzz6cIA4V/H3O+pyTg8OzGAq+R8osgDLomq2HeKFR7XLUT+xDIwtZjFhC+zmEEnXj/EZVVQHChBnaxijMYulFx47wVHLW6+VrHidDLGdUiFrbv6QOZsTgv1cAKamM32dpt08bf1mM97kWcxLn2jW/AJ9oWD4ptTK8ruGNCuQcdv2VxoRf8qtMQjunlVyQd5FrOIA/qLAGAWHe6jSD+mv6HYZgZfmm3K7PQff98EIKJmoo4RVZKwRpZkJLkG07Hv6bheCZrM/yUF+TCiFYHTWRqZ2rPRGptaTYG/kSApm/nunoMwybDB1WaxZ3JDOmO+V/eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HhhplqcmMR/jQ4zVp8x6aJ+om1xJ961TtvJWcffbqY=;
 b=NAwsROt7AlGUZOdBN0zyNroqENv5OnMbNfky7oOW/43PzR4qWzCbjUoSxOS43yrYzsLkL0haa+xuEW2UYXqc0WUjf9iVLgmTBU85a9Ml/moxQ4xfw69lvVsw2+7cJEdy8kjBOSLPDt7UHhwkl/MgxWnM3WyvR//LBbtlb4q2L3RYGbvNWw+YaGSCd/RTsv0WU8IQ5bny/oSeRuKImcHwG35S6K0HNJR8oBJY/HNNhO229rYMs+Gs5CFcIyWpDgaGPbtKGGdSYBpxCnDvcVWULO9XLZTHaEqeqEMWO8l9ksxOI70x+r1cYUjqt7zC4gZ+Pl43wCf7WRzofqRTlwF/tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HhhplqcmMR/jQ4zVp8x6aJ+om1xJ961TtvJWcffbqY=;
 b=I36yyFZu7GcB1l4xS9W9ANkDccJAvekP4+2Xnoc5txvAkAvX2NloMr/VtX8KhPVGaQxAW9XZaJqsG4PqHVK1+Sihhj07mbyZsi7tb92WsiBszHUKrY0uow84t0SttcF95/fiQRYrRD2YQX7prrJZJnBVSNXjOFm1QoDeybLbiEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3740.namprd13.prod.outlook.com (2603:10b6:5:24a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 08:13:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:13:31 +0000
Date: Tue, 16 May 2023 10:13:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v5 1/8] net: wangxun: libwx add tx offload
 functions
Message-ID: <ZGM7JvIckFCGcH9F@corigine.com>
References: <20230515120829.74861-1-mengyuanlou@net-swift.com>
 <20230515120829.74861-2-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515120829.74861-2-mengyuanlou@net-swift.com>
X-ClientProxiedBy: AM0PR04CA0119.eurprd04.prod.outlook.com
 (2603:10a6:208:55::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3740:EE_
X-MS-Office365-Filtering-Correlation-Id: c45c4ffc-34f4-4b60-574d-08db55e56fc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PnGPAndYgEwqafbp5Vtgj7TpbCnXrevnduO5Nlxv+Tj2oCFYW5ym41rhjrae7pWhGCp9KSEWX12HuptmmR1t3sNpwLUAeOsutG55hqkbr1M5uhVW6JdkuPqQESf97MUwU1HNRoHp9AbjqkQa7boqdMIefEjMcPeXoc4Y1Kj2fSHvJ/9cUdiyPjgDLOgJM1psBKx85s//8/cPzLU1iKyte/KYZgAO0XiRMzexKAyqN4sihwrhumgucqYQRNjXaMbBfdKdhVAg0DTI86xsTfU9V99yC7oJYZ3vbgYyfnssmOEWbWN/wNVOjsT/J8T3e/TWjuy1Vzcc4BC2IoapGCXLbW2fxcEPtaHSfP5YcyfP2CIds1XbkSkJB3iQ01iENjZCZyVV+Lei/673nnyNjLak5v8W4nmHbrOrLgJUupNGKBzp4RUCU9z7RAiDaQfy4MJxR7uujdKhdYDxdBpZbvFzfwXCLuDArSc5qchFY9YWg3ed/cyHxefiuqyl1m9+pAkhjEIodph/1i4EWeeE8FqN7FPvGISbjkMh/61410AbBa9Xe+jGhJFZnkAyEqnY1VEX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(39840400004)(346002)(396003)(451199021)(38100700002)(2616005)(186003)(83380400001)(2906002)(4744005)(8676002)(44832011)(6506007)(41300700001)(5660300002)(6512007)(8936002)(6486002)(36756003)(478600001)(66556008)(66946007)(6666004)(66476007)(6916009)(316002)(4326008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CT8NJ9nhuqwV0MpHWqT9DkxcY8u7cd0S/4XRgTa52ZCjlj4R+MTFX8KP89g7?=
 =?us-ascii?Q?2z1OQFzENIB36iKiXqQAxQTxgSfdAk2QPXqb1mjVLcJPLR9CgrTk7G9trVIS?=
 =?us-ascii?Q?7IwR7IPY7kMQnnroaH1NWxvue1NKe0raNzNTYAy4Csf0avcd/nhu71GqQWUv?=
 =?us-ascii?Q?x3VPUbVhq/mt2LZuDp3j55qb/HtDkUrGs8EwkoCyJAXCDQ8M5HMiqMRKV8TH?=
 =?us-ascii?Q?AgS0kwMnZfpnfpc0+qWgyL3UjfemYwJJ/bBQJLUeDIMkblAO/in/lyNEBpyl?=
 =?us-ascii?Q?6DZh3IyOKHrwMiPz+F5OtiBbmNUuQV3khsWveR9WUosXw77swsw7vBa7yiEW?=
 =?us-ascii?Q?lvGdrNAXTAh7qZwxfEOzp0o5wkQzVehhzlM7UH4NKYbics+h5FMOl8/3ikRd?=
 =?us-ascii?Q?OD8sYHRa5FmaaJN7Iu+VZaMoQ4awtXTsV7uRv7NCrAJY0G7aS68bK62o+O91?=
 =?us-ascii?Q?uOxHzQNq0SmtwH6Pxu0GuZSOPqgB/nrM2XusUi7s4DaV+TYnWdRkHQ7lWuSZ?=
 =?us-ascii?Q?hklgh8jIi0dIYIkeZ2/rxPuSJtNwDsF9zAS2Xnzh4Y39qHiSEHImN3KOqLzR?=
 =?us-ascii?Q?Htf0qu14lWgAtMdEfKjz0acNHR17fvKjvuxFQqWMDacvHlqYgx/X92CnhKIF?=
 =?us-ascii?Q?SGEmTswJm9Tut4z3PtFXxtRoOOeZKOT1IgydVP2y6Gk/HnjmBF07wmOGPR4T?=
 =?us-ascii?Q?GkYw42jI3b0Vlh/cAFfE/sQncMWYYvmuolqSkPm+WaP2nnympo3HYc/NpyGM?=
 =?us-ascii?Q?7EJcTW2c5K7G5LGz6E2cb+tU1MbYU1xyBdNpdgpUC8QVHz33OJ9WfMxAsXgv?=
 =?us-ascii?Q?2T8/DBivlhMqqFMSXwWbbjlYsRANnsHpwH0B7h8mMMumUTqGJUsbOAJJpCyQ?=
 =?us-ascii?Q?3igp4eqjyKOWohqTi77DOe+I/NgKrpH6EY1Bua37YWq/tlkvxkxfzAHjRv6s?=
 =?us-ascii?Q?f/eqMnk7cXovdywokA9Zw5g1DbUfiXd7xl/nTxdvN8Ls9jOrl7lbdye45LIP?=
 =?us-ascii?Q?bP9WF+G4cHvyaOcO6q22ep7VeZGuWcQf42fv7Q8KHGtpNOf02vXGOjrDnqfa?=
 =?us-ascii?Q?qXBKAOCQnMGjs7x5mvl+hP4Ld4D1AAa19OnZR086a+iZn2X4wxYByb1FTTY7?=
 =?us-ascii?Q?OJrkqxdEw3FiV8bqnbgcA9EQOvBnuFYASFjVyL5ZePeHRYe1IuvcHeeIPz+m?=
 =?us-ascii?Q?DCc76NDSr6arNTk7cs7haPuifpt6ecBGrFhVejrORoaXF097081vrreYe7vX?=
 =?us-ascii?Q?dh/eCw3p0a9Hn1HzWCZ7oj4DGF7EDqxKB4UPVU6wFyEGFJA/yVzxp8TtZrOG?=
 =?us-ascii?Q?IvP369uImEZSLo3a86cJgWmVd8JLaZxQnEu5RIizLhJiq72TPms3Va3ykpMI?=
 =?us-ascii?Q?NLDxojJ6PRZQjolPunI7HMT4TWyRAVcjeDT8W6NEQW77RGQGuWndWRVxNzz2?=
 =?us-ascii?Q?+3DHcT94AYj/rQGMEnGIII7RDowCpJkPk4QFYjHkVZW3Bh23OfD2odEnnvEn?=
 =?us-ascii?Q?XIZ6Aw0JC/WH+9D7h46mdNbdTvfioKQceqWQ4gKoHizOu6OZgOErAdtehRB+?=
 =?us-ascii?Q?Y9bXwZOscO7kDtW0CcQltnk/SmqnV2rjeA+ByJNW8/bw9lk28r8BdJ8fP5H5?=
 =?us-ascii?Q?GqvBAer4OFDpqCtDli/NvUHi1Hqvj5nVb2mlG7E4s/3697yGOhQEhl38swNC?=
 =?us-ascii?Q?uuyD5Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c45c4ffc-34f4-4b60-574d-08db55e56fc0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:13:31.5555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UV11fIAvQKeB+bB15kW8Fa3fH1AEli+Z4iG3Kv/vobeRoF1XnMkqIp1vxkArrjEm5/GWKoMzGwH+Wr7tLthCtnlVE7WaOa6BZyQEZc2jGgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3740
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 08:08:22PM +0800, Mengyuan Lou wrote:
> Add tx offload functions for wx_xmit_frame_ring which
> includes wx_encode_tx_desc_ptype, wx_tso and wx_tx_csum.
> which supports ngbe and txgbe to implement tx offload
> function.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>

...

> @@ -326,6 +324,33 @@
>  
>  #define WX_RXD_ERR_RXE               BIT(29) /* Any MAC Error */
>  
> +/**
> + * receive packet type
> + * PTYPE:8 = TUN:2 + PKT:2 + TYP:4
> + **/

Hi,

The comment above looks like a kernel-doc but is not.

$ ./scripts/kernel-doc -none drivers/net/ethernet/wangxun/libwx/wx_type.h
drivers/net/ethernet/wangxun/libwx/wx_type.h:328: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

...

