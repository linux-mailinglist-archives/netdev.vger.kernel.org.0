Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2905BA79D
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 09:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiIPHzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 03:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIPHzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 03:55:38 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01hn2234.outbound.protection.outlook.com [52.100.164.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147D954648;
        Fri, 16 Sep 2022 00:55:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uk1+7FGwS3pFCLI1TjUaT1ioo6WPqlHgt2O4/++iRkdxcgqJuuqcFlSFYD5VmJU+NOH1074dJfon0e4to1kgux2NwlPaOWlUTr/mrgoWowvnMQk65YAdo/HSvm+Nem3jP14VDYBKrgOYRRfZTVyXEvOsSqqPN0naTVGvnbkm6LP+DcYCEzEo1/h7cZo5bHeoQAj6sGcFsMkl0wPz2c9h0NaULkqtUb2fZBiNEdJRW0g15A4f/A1p7HuB+rtSjLBw4208aR0r3SIUwLrLn2wfxilKgh/kGgxDu6NKTqJRPaDCCDqWmmqsjPntUcbQGVOXuVGgwAxRn1p646xIZE4UTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs10Md+15nMnyayKLyd22Uv+/ZH79IcFcpzuzGLq1Fg=;
 b=S4nVCz/e09W3qdI+0Ke5vNP8UbmiWdexlJBkGs5m7lfce282bxQYQiLZO5r7FtOO3ScunHl6W1vHFoRc/NMHkivBjCgQf7HotgwGdJ633kfhGN+YTpCsuMrGHlN+IboP80xxjWghW/RrFhsM/jU6aZjbjYzetFs7lhqzxE746eUlkPhVQ+J8mL/wxTiwyWE210GPzhAEjL3fzF76NTsRVeieBOZ50Yy5jXPBdQv1UJbCFBIT65wO4beYWNAzBziOJiUdT3FTXhdYaGINb4o1JyPdPpp/KSOzYJouH1h2odvLZeRWvH/nvb767ZWcZrekd+f+kXVW9A3wwo686VfhGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 138.199.21.193) smtp.rcpttodomain=sbs.co.kr smtp.mailfrom=t4.cims.jp;
 dmarc=bestguesspass action=none header.from=t4.cims.jp; dkim=none (message
 not signed); arc=none (0)
Received: from SG2P153CA0036.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::23) by
 TY0PR04MB5635.apcprd04.prod.outlook.com (2603:1096:400:1ac::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Fri, 16 Sep 2022 07:55:33 +0000
Received: from SG2APC01FT0035.eop-APC01.prod.protection.outlook.com
 (2603:1096:4:c7:cafe::e3) by SG2P153CA0036.outlook.office365.com
 (2603:1096:4:c7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.3 via Frontend
 Transport; Fri, 16 Sep 2022 07:55:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 138.199.21.193)
 smtp.mailfrom=t4.cims.jp; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=t4.cims.jp;
Received-SPF: Pass (protection.outlook.com: domain of t4.cims.jp designates
 138.199.21.193 as permitted sender) receiver=protection.outlook.com;
 client-ip=138.199.21.193; helo=User; pr=M
Received: from mail.prasarana.com.my (58.26.8.158) by
 SG2APC01FT0035.mail.protection.outlook.com (10.13.37.242) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Fri, 16 Sep 2022 07:55:32 +0000
Received: from MRL-EXH-02.prasarana.com.my (10.128.66.101) by
 MRL-EXH-01.prasarana.com.my (10.128.66.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 16 Sep 2022 15:54:54 +0800
Received: from User (138.199.21.193) by MRL-EXH-02.prasarana.com.my
 (10.128.66.101) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Fri, 16 Sep 2022 15:54:27 +0800
Reply-To: <rhashimi202222@kakao.com>
From:   Consultant Swift Capital Loans Ltd <info@t4.cims.jp>
Subject: I hope you are doing well, and business is great!
Date:   Fri, 16 Sep 2022 15:55:06 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1251"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2600.0000
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2600.0000
Message-ID: <2b20268f-2e42-47c2-bd0c-c48ee121fe4f@MRL-EXH-02.prasarana.com.my>
To:     Undisclosed recipients:;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender: ip=[138.199.21.193];domain=User
X-MS-Exchange-ExternalOriginalInternetSender: ip=[138.199.21.193];domain=User
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2APC01FT0035:EE_|TY0PR04MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: 90470811-788f-4ee2-a951-08da97b8d4c9
X-MS-Exchange-AtpMessageProperties: SA|SL
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?windows-1251?Q?2iUG+g2lWGHXxlWKqtWIdGLggXHted5namaS2ioGtNysnkKHCPHlGjKy?=
 =?windows-1251?Q?KrbO6/tGVz0I/Ww+HvIvbxHadfJgNQ0dj4KeCVx+TUU2Rs+WJei6/PH0?=
 =?windows-1251?Q?2Jt9dyiYlpRwCwglCaPLFCFmB75QNU5hwo9l5pLptPwIF9sZTzFx9MVT?=
 =?windows-1251?Q?rrG4PoMoUSZRr6Lpn5X0528cv27R8AKN1kisZvJ4VrMtKghKNGRuyj1W?=
 =?windows-1251?Q?X3r1xG0+5rBnLtYJ1Jz1IugIJwwq62r9zZL7j6zT+AI+jBqQLlTAm6dC?=
 =?windows-1251?Q?rQPNsgxZuACjl39OiV2LEkUk6BxHcIL5yKeXM47TUMFLo70qabn6U22q?=
 =?windows-1251?Q?L6TIbAtGPXgQmYjX2HdOFInY9CPUSUS8d3LNEYKAiCWNIOo4OMcQDpIs?=
 =?windows-1251?Q?338W7F1B30zy0zQLOqoT/YKzoj6BaoRb+NRuPEoU+qFpJyeUKefaFFUE?=
 =?windows-1251?Q?A8sHek16ox/re6DtYM4rscLdNXCgmK8uPNxadPuzmVFQpxqUHtX/00Fa?=
 =?windows-1251?Q?QmPd+z4Rwmq8V+qsf04NHl+PhKSWMrrySEGyvIeKGOYrZXfA1Psk2hpM?=
 =?windows-1251?Q?+o3Nx1HtSIQeu3iG2UA+FRwEfrAsnhqgr+GvrbW0E+EfS68hIsBUeAw1?=
 =?windows-1251?Q?B5T01rz5XIp2YM920lYhVFRKld2BgQRxq4PG4TPnLjRqi2GBRHLGZQgp?=
 =?windows-1251?Q?3HSrorraSvd0M9o1A7vLSv2JWkYGtMiab/y5eHFCrgKfTXJ4Mvp4gduU?=
 =?windows-1251?Q?tPaiqpmOFvPNftHrjmJ+uJUvnX840QDmMILLFWsgcW6BE9vQlPdsy08F?=
 =?windows-1251?Q?/x52vvn4B8fANhGnD49rMKoWEwOpr0ggJI3EhMJOy2cq/1jeUFfIuhrI?=
 =?windows-1251?Q?j3mxYr+SvhKH6zaBwRPJXdkcPzcs/6iY3dJivgXODl5yidUVJomC2cDh?=
 =?windows-1251?Q?Q87A71EDviYnvQFNcIwmlQRECJ2ZzBxQuz3ds5asjKsjwV8MgigfsAKl?=
 =?windows-1251?Q?aOXhHbKxxf8Bl7OoRBgwQ5unMKNWnSyhb6fBw2zzWJrS4UJOPYLceDsj?=
 =?windows-1251?Q?XLtz1WWRl+llLW2XjzPBkK5XnL8PNZmZxtypyBZclCavL+9F8TFXG95Z?=
 =?windows-1251?Q?p5vB8zdNcqvcPmcippgYeqR/QTED544ktKsD9yofRGE5BBGEIEDFyh5x?=
 =?windows-1251?Q?KvON9PYX74RQeaw8PIsPJOgyBVkEZ20JsIYQZWu1SwVwnH1HFA77g2OX?=
 =?windows-1251?Q?54ac9lQGEanGUaf0pLQyYC+cKrXjkgY+bPyaRdvgPyN8mHAxLzY/mEiv?=
 =?windows-1251?Q?1044T42wJIuXm73cGhLVvgd9nL1upZ855yvgbdKJTnTWuh1utslDxA+P?=
 =?windows-1251?Q?mCx0oYh4TmV0/dorZ5J7NPasz6D5byVImkQYV8gyl7pN1gX5tkU+vZgU?=
 =?windows-1251?Q?ViuUZvY/3gKVqi/DT9/3eNdltRvGSHa9t+71FJwpXM6GQ3oXnZn+W5Os?=
 =?windows-1251?Q?8djH10HSV631q2RMvJ7vKLf+jinDfcwqpk1fCjkeyTblKHuIyTtavHBE?=
 =?windows-1251?Q?GdFfLyXxQiL2xTnL?=
X-Forefront-Antispam-Report: CIP:58.26.8.158;CTRY:JP;LANG:en;SCL:9;SRV:;IPV:NLI;SFV:SPM;H:User;PTR:unn-138-199-21-193.datapacket.com;CAT:OSPM;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199015)(40470700004)(32650700002)(156005)(41300700001)(31686004)(32850700003)(66899012)(2906002)(81166007)(86362001)(316002)(8676002)(40480700001)(498600001)(36906005)(6666004)(82310400005)(26005)(9686003)(82740400003)(5660300002)(4744005)(7366002)(7406005)(7416002)(8936002)(336012)(956004)(31696002)(40460700003)(109986005)(35950700001)(70586007)(70206006)(2700400008);DIR:OUT;SFP:1501;
X-OriginatorOrg: myprasarana.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 07:55:32.5484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90470811-788f-4ee2-a951-08da97b8d4c9
X-MS-Exchange-CrossTenant-Id: 3cbb2ff2-27fb-4993-aecf-bf16995e64c0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3cbb2ff2-27fb-4993-aecf-bf16995e64c0;Ip=[58.26.8.158];Helo=[mail.prasarana.com.my]
X-MS-Exchange-CrossTenant-AuthSource: SG2APC01FT0035.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR04MB5635
X-Spam-Status: Yes, score=6.2 required=5.0 tests=AXB_XMAILER_MIMEOLE_OL_024C2,
        AXB_X_FF_SEZ_S,BAYES_50,FORGED_MUA_OUTLOOK,FSL_CTYPE_WIN1251,
        FSL_NEW_HELO_USER,HEADER_FROM_DIFFERENT_DOMAINS,NSL_RCVD_FROM_USER,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5088]
        *  0.0 NSL_RCVD_FROM_USER Received from User
        *  0.0 FSL_CTYPE_WIN1251 Content-Type only seen in 419 spam
        *  3.2 AXB_X_FF_SEZ_S Forefront sez this is spam
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [52.100.164.234 listed in list.dnswl.org]
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.2 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
        *      mail domains are different
        *  0.0 AXB_XMAILER_MIMEOLE_OL_024C2 Yet another X header trait
        *  0.0 FSL_NEW_HELO_USER Spam's using Helo and User
        *  1.9 FORGED_MUA_OUTLOOK Forged mail pretending to be from MS Outlook
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I hope you are doing well, and business is great!
However, if you need working capital to further grow and expand your business, we may be a perfect fit for you. I am Ms. Kaori Ichikawa Swift Capital Loans Ltd Consultant, Our loans are NOT based on your personal credit, and NO collateral is required.

We are a Direct Lender who can approve your loan today, and fund as Early as Tomorrow.

Once your reply I will send you the official website to complete your application

Waiting for your reply.

Regards
Ms. Kaori Ichikawa
Consultant Swift Capital Loans Ltd
