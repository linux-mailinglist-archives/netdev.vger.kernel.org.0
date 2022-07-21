Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B68957CF7B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiGUPhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiGUPhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:37:01 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9768CBA1;
        Thu, 21 Jul 2022 08:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPnaF1WknL9xnXbvDdFq87JedWlazfgPlO4SOqfyu+lrXVWeGD8MPH2oCx6lPZ2nT4mrKXpD99qGgBQD1gU8+InSPUSXp9SWnMm1lMEYPq1OjSvRR7/u65BEpkBULFgrkkonACi9vIPBx628+gfh/E4Wx9ybEYWRVrsj09yU67R4MvjiGElOgCmRYWVOkmW3YniWKHfCIDpdDXAjveGN12P2thoJ7CxxmaeAGzXdVrIKWpI7F+x/dWIRSHg3jrsZNK3DETXtDghzi+NBsPGZgaCt4ZwWGDZGI6BR4S5Qk2Kj/PZLZ0/6gxCVkzxpLr1kn/42U168l9tWnlQinEnVDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TL1O9+QeW2jGwMWHacTOt0HXzWHwMRtUSW+9bCxxSo=;
 b=eDil8R1ewxDvGupLuI8J6+COT4QuyVjxnbB8s4Al+JuODs225vOFLTr4ax8B3pVsyTRY0WbQhqE+LR9B4PkDRDQYwAjImFfA3c8Bh8t0ZpjB36Es51eFDuxZa+L1X2oxjCde05yEYQrg4IlTndSTL04ILFHJZgbqHXlJ99xL3daD+gxZHJX6VhaJ/audRN8tkM/R8PQM0YJpuxiP7AF8/WBBA0VeB1PuJ8PuWFTRVLzutI9gT2zkws8x/yrbNZ28DPisO4HfAOly0KahN6L62fiZdCJWn0TOODWy1Dhsi4BSp5I8faPTqfbdiDW35R1CDbNWZqRIGHztvm01e/yPsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TL1O9+QeW2jGwMWHacTOt0HXzWHwMRtUSW+9bCxxSo=;
 b=pduOn7B4/nbjsXXV4XTLdx4kQvjtQKFy8nTnxsn6Cy2GpUVMyhmS7MbPd4uvaqYVdjLu/REl4yLnRUB0HOBEyMVq8EvagsugmNyKCz6NrJEnOtb1tVqt9K8CflmufVZrAX9sxiA6PQwrwdECUOn+GoyDHkkGEXOPsqLiOUFmqGTzdGjlhdD8+btmyv4nqH/PV5r5XRFbVfxuDXLU7oao4cLZIC1hRzdsyaaAF5AI24jPu9Y22Ou3BLdfqlu9A2c/+alBJkq7F0/pbfXCkKcEmGVQ8GYqfZs4+JDeMmpp0zAChu/ERmGUf16onsirNL4AXqWA0HD/I8Wa/Xb9tlzeIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0302MB3280.eurprd03.prod.outlook.com (2603:10a6:803:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 15:36:42 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 15:36:42 +0000
Subject: Re: [PATCH net-next v3 37/47] soc: fsl: qbman: Add CGR update
 function
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Leo Li <leoyang.li@nxp.com>, Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-38-sean.anderson@seco.com>
 <VI1PR04MB58075DFACE3A36F4FDCF7ED7F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <17e8e50a-efbf-0cfd-e9b3-756f527f1f25@seco.com>
Date:   Thu, 21 Jul 2022 11:36:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB58075DFACE3A36F4FDCF7ED7F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:207:3c::48) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b93d3fad-2eb8-4c19-eba2-08da6b2ecfdc
X-MS-TrafficTypeDiagnostic: VI1PR0302MB3280:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZOQx9SuYc+vzBFOhAb+GY1oQeCgFsUH6/ryGc3Fa0lUr8EGzCPxS/44U8aTARY7K1WCeN0Na4iYtZsJ48CwPRFS01ZgvktGqYEjhfRZiDgEyKOeNQa9/tRF4DkasYDwD67SsCMdAV1y+dMWikqjc0xh0UWpUflEzCRx4DP73tCbaLpOw7gs3cH62rG+EYS2+inC+z/YzJsELnpFrW4Im1AZk0vkeZImNeTgGbUFejG1jiTV5PkZ/WDN5ljZ4nPgHcz5G/DHGuKCRpSWyFgtGPU4e376HcLRrl8wyvyTJS0DOmIkbk7TNYEHhsXrgeKjGfTtB1TH3dR8dHHOuUTmv3+BLEoXzAY8j4ealRK6aUlHILc8gRUCE611EgsBl2dNkIvxiiORTPGyh0rjkbOPC5P4/ivclwqH5SjrF9fX8O52edo0xmBcDMFOWILYY3Lqq+udymuDi812BWSA7I8NaLpegABG51sUM78vRzjADWZhAkLhlTWElDB7UlGNb1ONoIWd388QJhJy4bGYToyvwcWc/7ImnWca0oPR/uPvskqx0XzH2V23LvbX2yiIkT7WHM+HB9H5ELRXV+tAwET7uss30QlvpB0FInOtgO6Ye+kUjfURuYbcjgCrlBvOHRtWWYbohGQ4PE7HPDqvRQgKG+DCX2BquatDjDnkYdK3MKtt9P1MRgXNxFgYMsfuZ72mdTbsh87GBO/Zoj/60G2CUl3DBxwuBVy080DFf2VRx/1R7bwH9afFY299hZ0uE0NQuz1yKShrpRul9vhftZLPj1dbER3ZVlJWMPB9geECBNC6jD0EwPcEQhNV0SdK8H/V+dZDSN4bpzWEMgJlsMzPAkwFRmbdGlRxrlylMzizMxDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39850400004)(376002)(136003)(38350700002)(15650500001)(6506007)(52116002)(36756003)(53546011)(8936002)(5660300002)(7416002)(44832011)(6486002)(316002)(26005)(31686004)(478600001)(2616005)(41300700001)(6666004)(6512007)(31696002)(86362001)(83380400001)(186003)(2906002)(110136005)(66556008)(66476007)(8676002)(66946007)(4326008)(38100700002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3RTNko4MFlvVzNTdzBxQ0dXS0Y0TDdSeHluQUFjYTA0a3oyZDM5KzhJQXZk?=
 =?utf-8?B?cVdlZUtoNk5ZeFJYUXZBYm00VXBqSlM2WEJRV1ZaVUhwS1JuTEVWVm5ZM1Jk?=
 =?utf-8?B?ZzRWdVNTZ2ZCdGZ4VnRZWnYyWkhQd3VkQ25YTmFrN01JeThzZmlmS0hJRU41?=
 =?utf-8?B?Vm85cDVJcGl2ODNaSVBmMnM1ZTJLVmdNblpnR1pFeW8rOUJYQUhqckRGcXpZ?=
 =?utf-8?B?TTlidklaWnQwSTQyaTVsK2toT2tlWVZVUG9BMHV5c3M4YTlXNVRQQ3V1aTJX?=
 =?utf-8?B?a1RYcGFwYXNQTyttMzhsbWZpclR1WldjWXdTeEZNaDJ5K0YrUml6S2lWQlYy?=
 =?utf-8?B?cG15b21tU3QwNllJcm9PN1VJbThyelJkdEg1cnhrTmNwNHk3cTk5YzE0ejBE?=
 =?utf-8?B?KzV4TUF0eVM3dEZFNHY2VndVM2tXVzZJa0lEL3ZCNHJpUThqeGNhMmp2bkdH?=
 =?utf-8?B?Z1dPcHJFbUhQWm85ZXFTNkFKaDV4MGJUMDRrMllybjIrTWxma1hnUmdFSWRz?=
 =?utf-8?B?Wk5ZUStXRDdBaUdHd0lqOXJGTk45Ni9paUo5dERTQ1pCazBRRjFTVkRqL1Z2?=
 =?utf-8?B?dkpsMUt1OVFBbzVxQW9OdDdIN29XY2tqQWVaL2dlb3BBZ1JiekdncS9sdEhq?=
 =?utf-8?B?Mkw1MWF5Si9wMW1RRFA2SWRUOW02RUlYOFE5RzY0UXVtdTBpcWZvSWlUa0Yw?=
 =?utf-8?B?SFR2L0tualJlOUFxcVlOZDNoTHVBUHVMMWV6RERLMVE3TFA3ZXJFZ1g2NHc4?=
 =?utf-8?B?bWtxcDEwMDFmQnRDNmRXZWp5bUN2WEt3bU9zMlBmR25tYk5zSEJFVzY2WmVw?=
 =?utf-8?B?RDFraXh6bzdMQTN2Y05aQVJOY3BqUjFxZEZxNTdNWlBpUWVacmRWbWNNMm5u?=
 =?utf-8?B?ME12eXltWlQ4V2RsUU12Ui9aQURwOGd3K3QydXE3YUo0MkdMcDhON2VZOUZI?=
 =?utf-8?B?Z2d6bUMwWEN4QlpnSWlzRVd1VmF5L0QvUjQvckkyMWp1NFN5UHNPQzRiT0Rv?=
 =?utf-8?B?NzBVczJRcU9xaDZuTE5YSE9QbmIwbEhYaFNwNWRTUVJJdXk4a0lnMVNGbTg2?=
 =?utf-8?B?K3QxYXFpcVdyeGpHaE5jWmF0ZUNHYXBRY0lpUUVVMFg4NVZTaGpsVTNMaVpk?=
 =?utf-8?B?ckNGSHR1eER5Y3dkZDhjc3RzYUhONVVxNnozUU5pd1o2YTdobmt1YWR2ajd0?=
 =?utf-8?B?SlMrUzdJQkxBSEY2enZzeCt0T2dqUGRLNkl5U1ZaV2s4WmtNeXJvRzd4R3VS?=
 =?utf-8?B?UUQrU0pOSnVoWjJQR3MxeVloU055U3F4ekhTbzVETlNvS0p1dmVLb2IvQWVD?=
 =?utf-8?B?SS9VckRkWHB4NWQxZDhzUjA5R3M5SGdjUHNNdG9aUk5yTjVSZnZoNSswQjFM?=
 =?utf-8?B?VlppZFBpVTlUTkFUYVk3emQwaTV6MkZzaU9OZVVwSTVsUDNwT0I5S2xqR2lG?=
 =?utf-8?B?dUMrNDlNOU1YQm8wM2Q0M3U2WVo2ZmhaU3FiWHhWZUQ2bVVHSlh1aGRQU1RQ?=
 =?utf-8?B?d0tGN2JZMitxSkwyTC9EY2o4VSt0NTRGMkhpbmd5TzdaQjBhY0U1aldXemxq?=
 =?utf-8?B?QnNuZmxReHdpRHQ1OG81NkV2YWVwSTBxSEFQajNRRy9ZSDVXdE1ScndGQ1hr?=
 =?utf-8?B?RXlSVDNJeFhMalZVM0NPVStpbjA1WGNMRGJ5Zlc5OFpTYjFDZmx3QXNEeWZ4?=
 =?utf-8?B?bEdQN3RFMzZmendpT3dOeFNxd250QnJnUVdXSlllaC96bHZtVFpIdVh3TGtE?=
 =?utf-8?B?Z1NRbmRHMUdUMUsrSXBSNzVSYXdWNGk0cUlDN2F0TU9vUCsySkkrR0NvNnZ3?=
 =?utf-8?B?eEV3KzA3ckRJd296dzJGWFB1bUJmT2d2U2xxUWNEYXhueWtxWldWQk9zRk91?=
 =?utf-8?B?V3Q3azgraXA0S2tHMnpkWWRwNXpDWDJzSEhPR0dRNVBxcWpPQ3llMzNPNE10?=
 =?utf-8?B?M2VjS3VXZUtCRDZBRWdqRG5vdldKREZzOG12NnNVWXRMcmpRelpwZmlDeEw0?=
 =?utf-8?B?LzFPZ3FxN2VZVm9SdFpHRGpKdjRiWWlqbmNHL1pDd0N4dVdFTDZ5ckdPbzhW?=
 =?utf-8?B?Rk1WOFRQcDZxTldkYk9BRUFGVGoyZ1hQV0ppY1ZhYWhzbmlzeFVFQ1FFR3pF?=
 =?utf-8?B?Z2NvdmVUa3FjYU1HT0swbVE1eUw1K1JQekNMdmV4VUpUaHgveUxLMFVwRlhX?=
 =?utf-8?B?ekE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b93d3fad-2eb8-4c19-eba2-08da6b2ecfdc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 15:36:42.8094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIwY2NE0qtYnLQOtjr7i3ADzv6IVi4QOJvEtQagA069d/Khb648Fzu273fscPVU4Zh/4h17h8F0ITRgfpsImKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 9:18 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Linuxppc-dev <linuxppc-dev-
>> bounces+camelia.groza=nxp.com@lists.ozlabs.org> On Behalf Of Sean
>> Anderson
>> Sent: Saturday, July 16, 2022 1:00
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: Leo Li <leoyang.li@nxp.com>; Sean Anderson
>> <sean.anderson@seco.com>; Russell King <linux@armlinux.org.uk>; linux-
>> kernel@vger.kernel.org; Eric Dumazet <edumazet@google.com>; Paolo
>> Abeni <pabeni@redhat.com>; linuxppc-dev@lists.ozlabs.org; linux-arm-
>> kernel@lists.infradead.org
>> Subject: [PATCH net-next v3 37/47] soc: fsl: qbman: Add CGR update
>> function
>> 
>> This adds a function to update a CGR with new parameters.
>> qman_cgr_create can almost be used for this (with flags=0), but it's not
> 
> It's qman_create_cgr, not qman_cgr_create.

Thanks, will fix.

>> suitable because it also registers the callback function. The _safe
>> variant was modeled off of qman_cgr_delete_safe. However, we handle
>> multiple arguments and a return value.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> Acked-by: Camelia Groza <camelia.groza@nxp.com>
> 
