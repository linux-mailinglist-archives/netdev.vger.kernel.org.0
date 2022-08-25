Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8404D5A13A7
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbiHYOci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiHYOch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:32:37 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00064.outbound.protection.outlook.com [40.107.0.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200894BD01;
        Thu, 25 Aug 2022 07:32:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NL28nyn4ye/ysUK6sXr1r8jJZs+gDt2H5zum3qrrS+XI/qjAGk7Lz8O6PLHynJF4X0+frNDd4BLylRGxa+UEXUc9pNtE8aRQs7r2hM/QPq+mdA5/TJ4Tb4am2ElPKVKwQO7DUEl22OwdYNVxyPS7hZys7wDYU7WCveMLG1xWr/CWnbPCvoFAPxvoQU9fNUP5ap8z1PGODHcFFScTkp+SIpxCJzDPgbcMGfwGgh91eT0CTmn1bTVCVXqgOri32U64lwplW+OtrSAOFYIwqwEtsXwzpZyeoIZWK3/z1GhI9ZXOoja+j6A+jbqJphS+ZryUW+2chWXKIBAq5tKbzhv8qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvSaIuJQmSyXY0RybAWKH9ws9nJrW/d1zaBwlUqg0KE=;
 b=Wm57/aCVG5uauY3ypz7lNEEo42Gv9EzpQdkXmy25qZ2xrn3jbW5aebrsOoCh/kqa+6A+1oHzv/9uX7h/0qrNGPaMifkzh247fNOEO+AwcntokQ54xuBliL2uZCGWNW0+i11G2HyasOT03mLu3WsBL5kS9OLzlfxiBxYG6XITPrijG0mpfDOqUxcaf6XQT+8/8yK4Y49zrSOm5QCHXZdTRO6mQIZHAT7Cn1SadgVC6se2KLfS+Xj5BVAeT3gGkjmcxE5YIYv+47er4LI3DzqQxC19UxQyalzrs7zXnj8BAqk+jm078tvcByNa98/1/IjuNRM+ceY+4p515PFKOkM/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvSaIuJQmSyXY0RybAWKH9ws9nJrW/d1zaBwlUqg0KE=;
 b=XvNuyiNL7qN1pkZIADxIpozUJOelwY43eXWlFyNsSSpOFjn6p6MtqRMJr+pXL4wv0FvjZB/PghhrMmFmV0NXAEfm2RkHpdQ4J1lLxTobuUWKvWXB47VVehEapRMVUrptU8m2T1AIBY8d4kiZPgJntwy8VPm+HT4KCD+WWISHLr53QVAEE2ZpmRlsoO418Z0kFB4srM7Zn/4oOqSdr71V1hIMqCnOZX8LPMgvi7ZpRYt1vb6YB5vKL51W02yODqIZ1tW3ycKYiMCOL1SBcgmyDVWoaoFI4DPt8/6ACSN+OLpdvTI6yksNey60jA7TG6U9MltEVXIQluBcrCowGqPTkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7182.eurprd03.prod.outlook.com (2603:10a6:102:104::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 14:32:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 25 Aug 2022
 14:32:30 +0000
Subject: Re: [PATCH net-next] net: fman: memac: Uninitialized variable on
 error path
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <Ywd2X6gdKmTfYBxD@kili>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <ab5f4ddc-12d2-0f60-e044-0134c6be97de@seco.com>
Date:   Thu, 25 Aug 2022 10:32:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <Ywd2X6gdKmTfYBxD@kili>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:208:d4::20) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cef7bc4-9942-4926-c5eb-08da86a6a442
X-MS-TrafficTypeDiagnostic: PA4PR03MB7182:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYRAoYmrd8Xb9gfnKxYReO7JaNUdx38LAfGBcjmlP/sHOseh2YlUatE6tof4xaNTPtPpDRQOa2C/yxHzJpHxa0FO3PKwryXy721O3AD+dyCRNTjePEEa7fIqwMTos6tmFmguvOPUTl2qE5JX/sr52ZosKHg7mbFGLoNKt1qMIa9ZzuCIBUWN5m9UyWhaaDh51ttCOaNgjkrSq8gGmBuUVKnRyFwNDwhZLTO4gSpb7Ferc5RoAasa9bClSXbyVzED0H1B7igBzUKy5yaQgm0rv35QuOMvNdNPjds8DttDFd0S9mrsFFz1xGjyDCOQQidjFrzI4jSOrkORfrPpcazurIbuekntgZROFk3WiLIeMoKkwK3kwPoTr/bjnvQUYBqMKkCjcW5aZH//VYN8hKmfGsOVyBki7gkIIBX4b4SNBQtAqvDcOqVH5th/wXZK2mC1z8CI/MO46WeXbLsz1eovPurqfHnFwNY0WU5TgWnAKf6KDhPVPanaoAVTwVjpoj+Fwz0UaqTq6Zo0izgvaJanWm7K72rWiE2bz+FwpzUaR9UOR6MPquLuCXEcn/yRIpr6CPLWiwErgPuib0UM90/4NUnHdONMRoqCan+i7Hoi5c1XAJ3iMdhJC8iwzDN2OFHZ6Nrhu0UOS+kywqG6vidlzwlrSSlUqiUwRpp9eJUbHPzLwuO+5DmSC0fqtYyllO9WgJl7Dzc8R9l7DSbCCtjKSHGxdB7eR4jbWqDSorYMukYzeOHFTdY9Kj6gZROitPGvtmAa+nVgEbeM868zXXGRXGgAz0o57TtB5J4U8wGbONQFzR430GlTWTONahn5dnDQ8ebKOUoqJDrg4/4r5hLo2Vs5HiJ5HsgImhZPtCeCPC0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(39850400004)(346002)(136003)(38100700002)(54906003)(31696002)(2906002)(110136005)(31686004)(38350700002)(6506007)(36756003)(186003)(316002)(6512007)(6666004)(8936002)(6486002)(41300700001)(66946007)(5660300002)(26005)(83380400001)(8676002)(66556008)(4326008)(478600001)(52116002)(53546011)(2616005)(966005)(66476007)(86362001)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ty9aRW9HdEtLcytsZm9rMGI2RHRqVWZPME82QThqQWI4c2RuUjNiQjVtSi9t?=
 =?utf-8?B?cFpjMmZnekpIL0dMa1VZUjhkT0V4cDFobk9BL0R4ajlIdDRIc1NkNk5CMFJi?=
 =?utf-8?B?VXFpY2dXaTIxSjQ4ZzYxeVluaEdzb3Z6RXZjZjZXSjdmMUQxTU4vNjBKajlP?=
 =?utf-8?B?alRWL3hDR25scmxva1pNYUR0dHZpb0Zuemh4VXo5SzVIUjNmeXVwYldRNGNn?=
 =?utf-8?B?c0hIcitCQms2Mk95NTRGeGNpd3BkbFZhR3BKcjhSMlZtM2ZMbzZhM2UyNzEz?=
 =?utf-8?B?d09iY0QxbTg3Mnh6UlIrY1MvSmJxaVA1TGRDVDV3MTRuYitoU3lQWCtCejZq?=
 =?utf-8?B?d3BOMUFONjlyeERPOHd4ZWRxRzQzNjZOT25SYkVZdmRhKzI2NG45K1VBQ2d2?=
 =?utf-8?B?UmtCb1d2aTdCbWtIU2NJbU9JZ3d4aFkzb2YzWHhYQWRHUVRrMjM4blUrRzV4?=
 =?utf-8?B?SERYRFU4Tk9RU21hdWZaOFB5TzJZRkkwMGg4S1g5KzdpbjdsbllkeVgvcXRT?=
 =?utf-8?B?UzRvdHRMT3liQ2g4YWUwQnhjRERkak1aRS9OK256ZTNhMkRDL0JFeDVWUWY3?=
 =?utf-8?B?YmMycWZCSXQ3c3ZycFB3N0F6WEVMOWtiTVlUM2JYTjQxbStxTFkrMnhERlRu?=
 =?utf-8?B?MVNsMXIwR1dTS2pGc3UyYzJpd01ZT0hCQjlERkpWVlRCc1Iyd2JKdUpvYTBq?=
 =?utf-8?B?cjN3SmQ3cUFlYk5IZit3ZmFEbjlzelMva1FFbnFXQzZmSFdrajcrYTc1U3Ax?=
 =?utf-8?B?bjlPZ0RiR1h0Y0M5dXhsamNOZFZ6Ry9VNnJvNGk2VGF3cVI1NGIwSVZNMUkv?=
 =?utf-8?B?RnN1bmpZUEFnTzQzU1M0OWZDZjZHT1ZWbUhmVDgrSWJNekJjVDZ3Mms2SGZz?=
 =?utf-8?B?aHlYNGFGT0lDUlY4Z0xQc2NMQm9BNHB6R0l5NmdOOGhNUXVCdW1KT3FzR1pB?=
 =?utf-8?B?bUU3blcrT0s5Y1h6ODJXT3VGMU5oUGQvVlNYMzJGU0k3RXJqZnRxb1I1bHFh?=
 =?utf-8?B?U3JYa3BUNktjemJjLzIyc1kzQ25vUlFnak1KRVFydW5YRStIUEtDV0UyMGky?=
 =?utf-8?B?MER1RzBxSmlvbFUwRERFcURVRFVKZnF2QVdzOW04Q2kyVlFSbkF0V2U2TDhC?=
 =?utf-8?B?WjQyRUw2b2lKT3Bja3Y2bElFTk44Zzc1NERvTkJpZzBFS0tpUXFyWnBZT0FW?=
 =?utf-8?B?ank2Z1BKSTdkNkVOMGoySEZUOUNqQld0WDk5YnVmZ1cvNjdKUmtaOWYzWndB?=
 =?utf-8?B?cVR6c2RBY2xKUnV2WEF5YTRpdG8rL1ZXMlhDYi9PSkI5a3F6eS9scFM0T1Vj?=
 =?utf-8?B?RWZLeEJOWjFML1BCWU1TcEdMV3gza1o3K2ZDMFovSEUvNnRTYkxWWlNqNk1K?=
 =?utf-8?B?NTh6U3ByajNaa1ZYd3hrQk1INUdLVHIwb1BJTkZkYzBhZmEzNkFRRUNFZWRZ?=
 =?utf-8?B?T245WkcvV253ZHVPOXFCWGdQMHZkekMxUTNaYWRlc3Y4RHJnZ29LVC9mT21T?=
 =?utf-8?B?S1lCeVNDdWFvZmhlY092elpBc2dSZmlkS3BsUzQyNjhYMVhZdnFnbjB2bnBq?=
 =?utf-8?B?QXF3WTlnbFZtaDcxemdIWEdwT01IQWxKYTFRamdPcnJsdC9FaTBWRXRvWXJZ?=
 =?utf-8?B?UXRLQmU3RUhDdDN5WGtPSUpzMkdpaWd1MjZpM1dUaEY4ZmRFZ1ZWcXJlbFhV?=
 =?utf-8?B?VFZwN3laNVh6eUxueU9HR2R6VlEzT0Q3cWJtakhkRkppZjFoa0xrL3lkL0Np?=
 =?utf-8?B?VGppbXg0VS9CSFVvcjlzSHVMNXdCM29wakhpeFlCaE80RTJDcSs3ZmQ2VW9z?=
 =?utf-8?B?bWZPLzRWRFZhbkJJMkpHbGUwWHNjaFl4Z0lqMGdlejdIaDNUNzBFOGtacDJT?=
 =?utf-8?B?SlVhb0xhVnp4UngyU0hMUGVDcVhmZHBONTNncWpDcnRuUVk3UWNwRkNJdldC?=
 =?utf-8?B?OEdPTzlFN2dMbHdFYTNyeW1uYnBsamtSWWJvK3Q0czhIeTVjcEZ0NFQxZFNm?=
 =?utf-8?B?SldEZ2tpR3VPM0N5bXpjazNRTDh5N3EyMzVBU0tLZFczRHFudy9sK1A5NVkw?=
 =?utf-8?B?Q1h6TGVua2FpeHBZdW1Pc0YyNzlxODZmWVBIQ01veituelZscldNck5rN1FC?=
 =?utf-8?B?UmQ0RDZXUFJaQ1kvZ0VIM2UwSkw4eVB1L0VOdFhWQWZKQmtnZ3VOdDIvZEJq?=
 =?utf-8?B?Tnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cef7bc4-9942-4926-c5eb-08da86a6a442
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 14:32:30.9566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pB+K7ZZkW88NXKtpkS2u06rxvZcrvh23U0BcjA3DmCHZoaqrIV/uCuRJ37j1IZ+12MqB27w6Ej+NTxoReK2jjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7182
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/22 9:17 AM, Dan Carpenter wrote:
> The "fixed_link" is only allocated sometimes but it's freed
> unconditionally in the error handling.  Set it to NULL so we don't free
> uninitialized data.
> 
> Fixes: 9ea4742a55ca ("net: fman: Configure fixed link in memac_initialization")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/freescale/fman/mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
> index c376b9bf657d..f9a3f85760fb 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -389,7 +389,7 @@ static int memac_initialization(struct mac_device *mac_dev,
>  {
>  	int			 err;
>  	struct fman_mac_params	 params;
> -	struct fixed_phy_status *fixed_link;
> +	struct fixed_phy_status *fixed_link = NULL;
>  
>  	mac_dev->set_promisc		= memac_set_promiscuous;
>  	mac_dev->change_addr		= memac_modify_mac_address;
> 

This is also fixed by [1]

--Sean

[1] https://lore.kernel.org/netdev/20220818161649.2058728-10-sean.anderson@seco.com/
