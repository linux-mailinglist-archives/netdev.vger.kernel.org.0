Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7EE2B1B17
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgKMM00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:26:26 -0500
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:7744
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726405AbgKMM0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 07:26:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEAUZkLots3XOaD1ADG8EEpdsfbB7ZLjTZMWyECYT8szfnDz6YRxbfus+8yv6K77nOZ688OkanbCAfMLkoVst49Txe/3FokK6acFlxuZr0oSsVMHbGFt8q/diShnbvjm3fRaGqOvzq1hVOvGa2M5QjEzClC7D6SXD7PlWZGj3dYNCH49dPyT9+oqNoN4SHq2QXUrtkhQN34hdK14ExTAp7+CodAjDULceOwb3fDM8GSr2sk7FuenAaHAioPcMgnIcQ9eMcS5HHO/aeqpIRa6JTB1oLg/IZnRhmouVxdSoiubTtcOLo36YK3MSvXKFi7M+RpgWpGwau8TfsAqFoI/pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I+PkPESAdqUTFKr84KSx5S6CHhJ2etNaraPjSN98yE=;
 b=BncM76asoqHjOoqtkt+Q7b5emwAk8tKJLCca7Taq3VaryelyKqABMsP9YSzM+liccnVhSDoX4B3lCWw9ejSYjVhjd0/cNGI/V6xXyE31u7gu/Ix/2zAUbhXuS1hElSZ+g3FSuVPkxxjJA9Qlb/4wLmcHiYDm0reDLO6m/RFE/9nZLd63k5GEFCANxMGlixGrVgEnAF/C2Ax/UGxD4Rr3uF0KH2KQR/OZitfW2IBFB/rJF8ou42M59QOXA4dyMQ0+LbCh17/4AL0ApxqounolLfp4WttHOK+oiAuHWiaHuctob2drPxX8g01hViIaRNFzWSnQdV13/ztgejqABWGbig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I+PkPESAdqUTFKr84KSx5S6CHhJ2etNaraPjSN98yE=;
 b=L5sKYoFxF746Qwo8MKv3EunvUp2BHrvlba+LwGul8t//0mBgPqJdJ8EsqGu81eK38gJwVapqdhFxAx0KBm4D1yY9A5CrTZ74EVtOdJpsMH2dhY2/gsFc0N2gYIdMTpLwfzBBhyhs0x/dCVM47w9Y5MqOrlkz0i92s74GK7OsxUE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB2603.namprd11.prod.outlook.com (2603:10b6:5:c6::21) by
 DM6PR11MB4075.namprd11.prod.outlook.com (2603:10b6:5:198::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.22; Fri, 13 Nov 2020 12:26:23 +0000
Received: from DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::54f7:13ae:91ef:6ae4]) by DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::54f7:13ae:91ef:6ae4%5]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 12:26:23 +0000
Subject: Re: [PATCH] tipc: fix -Wstringop-truncation warnings
To:     Kang Wenlin <wenlin.kang@windriver.com>, jmaloy@redhat.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <20201112093442.8132-1-wenlin.kang@windriver.com>
From:   Ying Xue <ying.xue@windriver.com>
Autocrypt: addr=ying.xue@windriver.com; keydata=
 xjMEX1nnURYJKwYBBAHaRw8BAQdAZxROH3r87AOhslT5tP2cdYcg89+pbHiYf+LIny/C0fLN
 GDx5aW5nLnh1ZUB3aW5kcml2ZXIuY29tPsJ3BBAWCgAfBQJfWedRBgsJBwgDAgQVCAoCAxYC
 AQIZAQIbAwIeAQAKCRC3Qmz/Z9beRSLiAP9kPgF+mG4F3elbrVTen/sybJfZidnvF1YVq5Ho
 sUbt+wEA6ByAVvGqlEbt4SE1JP6xVgTzwlwihyCgl/byRAQzeg7OOARfWedREgorBgEEAZdV
 AQUBAQdAsdHm3QQyX4RnhnVEmywHpipu0cUyHWeuAkYuLavc5QYDAQgHwmEEGBYIAAkFAl9Z
 51ECGwwACgkQt0Js/2fW3kXZKAEA0jTzhaLbmprQxi1BbUmAYtlpQCrrjCWdpFGwt5O3yO8A
 /jVE1VxnEgu71mYXX1QE1Lngk+SPVEfLm0BVZFk9fBAA
Message-ID: <11e23a8d-766d-fb65-40ce-c7a1fdf00c3c@windriver.com>
Date:   Fri, 13 Nov 2020 20:26:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201112093442.8132-1-wenlin.kang@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR0401CA0008.apcprd04.prod.outlook.com
 (2603:1096:202:2::18) To DM6PR11MB2603.namprd11.prod.outlook.com
 (2603:10b6:5:c6::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.155.152] (60.247.85.82) by HK2PR0401CA0008.apcprd04.prod.outlook.com (2603:1096:202:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 12:26:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d80f7892-834d-412e-a385-08d887cf5562
X-MS-TrafficTypeDiagnostic: DM6PR11MB4075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB4075DEFB00F9E438692E3CD984E60@DM6PR11MB4075.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gYvjYCZuUquf6FsZ7hsKBEJcR0OhWhFvi1Jth0xZWabkkTPq1l2iCOtv5etvrZI6qgPT+m/ChoiSe0jLZzNDWyh+GgPlfCSLA8VxIcPK/HXYvTehRlJPekBl41gpzc27ZGM8Ub9tCM0rk38h3mZUVrpWaOLzmci91d8xjXgWpkhWcjae1MXMUHqOdCU99/jO+PmAWoQYpZV1vfBpTqgDSTo1lWpgEDbZxGO2WX9VszykkK3LUShfWrvilPvmsvzE2XZDj+p0uoU+5an1TxjUHnWCpGBMVLeu4XQ3T3NhvxtNPNj8Zwur6USJG3k1iFjQQz1d/ILKjNkZPd2i6xmpmzxKcVAbmLcOb7lDkiFI0sux3AbnAdyJDtuYVRl2RhuDwPye8ZE8HupMUNKtIboezA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39850400004)(136003)(2616005)(5660300002)(66476007)(16576012)(8936002)(83380400001)(52116002)(8676002)(66556008)(66946007)(6706004)(36756003)(478600001)(956004)(316002)(6666004)(86362001)(44832011)(31696002)(53546011)(6486002)(186003)(2906002)(26005)(31686004)(16526019)(4326008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JxFoefKlfe2VglSU4S3O5NzRhpoGl5q1PV5DsKaxK5ZwzeH9KiXRqQbAwyPSlpufs9yRI+DtJ3S2gapxKdaLvLj4ayxEACg95L5olWeQpC1DlsZVslU33gpDzS6mIMk+0WYVgdIFtU5MTIMAqDTQ+XWOtYOuRjevxD2lk058iLRYpCVRy102322n6HsHBtGkSDMZJO8lrRul9GVK4NQxsezKt6r0CKtcxxH+hIPDensBZVI6WTMAWtLqf5EI64KJ5pN3mhIWahJsRQlCxntMz/NQDPfQjEZN62pYYmmMfyCQw0vXKLMx5LBknaI6YchOSfNBuzbUBQjHulOkEo7andKKegNTtPHpBiNrzH4AqxWGlQA5Q3YaWN2FGQj8/N4SdM8+iRTduf1RwiSJH3NBuEnZOhUDtwbwcDYn/ymG2JU1wT4TU4IQnPW+8VGu0RV2aJlmP+2ozLHi2zuXC6tL6JaHzNG+J5+XZLYG13BZ5TkvWFtSUbhxdLZE2It1zeXu4WgVKKJGqzJhsNaaWQgQb/3f0Cx3ZoL9SISQzY36e37XfkWpGwNxpNr2bc3ApKLZAZmhpz/z2G1y3Efr0OX+KFam7xeXyux/H+ex0Fb6DLghLsgcDhoKs0DF6+uvOcqs0sfidxJcF978Lh5DTbzDVA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d80f7892-834d-412e-a385-08d887cf5562
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 12:26:23.7890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x1MJfQc9CkkftZlyzvFaUEYNpV9ePVAXrTaPOwXN6XiRqr7lIFi7PljZyMG3vTRrfKq36nCMBJIWoGZM/YWsAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4075
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 5:34 PM, Kang Wenlin wrote:
> From: Wenlin Kang <wenlin.kang@windriver.com>
> 
> Replace strncpy() with strscpy(), fixes the following warning:
> 
> In function 'bearer_name_validate',
>     inlined from 'tipc_enable_bearer' at net/tipc/bearer.c:246:7:
> net/tipc/bearer.c:141:2: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
>   strncpy(name_copy, name, TIPC_MAX_BEARER_NAME);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Wenlin Kang <wenlin.kang@windriver.com>

Acked-by: Ying Xue <ying.xue@windriver.com>

> ---
>  net/tipc/bearer.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 650414110452..2241d5a38f7b 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -139,10 +139,7 @@ static int bearer_name_validate(const char *name,
>  	u32 if_len;
>  
>  	/* copy bearer name & ensure length is OK */
> -	name_copy[TIPC_MAX_BEARER_NAME - 1] = 0;
> -	/* need above in case non-Posix strncpy() doesn't pad with nulls */
> -	strncpy(name_copy, name, TIPC_MAX_BEARER_NAME);
> -	if (name_copy[TIPC_MAX_BEARER_NAME - 1] != 0)
> +	if (strscpy(name_copy, name, TIPC_MAX_BEARER_NAME) < 0)
>  		return 0;
>  
>  	/* ensure all component parts of bearer name are present */
> 
