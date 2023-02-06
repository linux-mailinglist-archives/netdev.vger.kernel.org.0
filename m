Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7938768B4C7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 05:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBFEJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 23:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBFEJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 23:09:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580D3193E0;
        Sun,  5 Feb 2023 20:09:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LeXXSIPdaHATjebrkTEV/TeZw/SafyNjo4GfB01klI2AKaUcuRROpE5tfUzkwAoZHPkwQt6vQmvMw8TnDKyzIRfgY8/x3ZCBYCxL6ZX/IHgrGmZ6G/eUV58Ug9ko9rxd89FMD00vko6h3jX54H0tyBsqH3SMARQiceG4gcR1VKmVPNHAE0xjeSdPhYo/CBAIljYXT7YUByyjqS+m6yRhPE6Jq/p6ugQWzVx5QCXGq2a/Hob1OjWF0MYvh/9TmhHIdnJY1KLl1J6TciT4uRbNRbaCz0Xz1qaoemMrroLxxNJ2YysJl+sbXFwjr4QWo5fv3ezNLEBv/d9BFJDIvBiGSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fY3bpSFHBpm5pEzUmdjbL7/3GqllCQUjth9X8vbCbVU=;
 b=bq9chXvw5uGuzInGYNxPoPiSxmxId8c7RmU9QZpaxPEypPI2PUWIjmJjzTWezB8hGUiRghnJU9Whe8RH+14pIdJQQ+jzYsvYg4R9o5/9Bk3zyXJXHY839ehgCvLY9NbvjDyODyO5GAK1US3WbOsBxvgh+Lgrpbs4deHNKhqrPD8sZLT1i+b3iWI4d8rSaLMv4KfMd7pF2QistCZHaBjrHGYuRPpuooKqcbYdhpQtRKP32oi6Fq1PyuYh49uOCeFhSWH5Q7zCrnGvQ3tBPE76NOjDbJif2VDTsQdmO39gSnapxSXXB5TJx5hB8un83XFLFZiqda7cLtAk7LsaIOOmIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fY3bpSFHBpm5pEzUmdjbL7/3GqllCQUjth9X8vbCbVU=;
 b=B0Y4N6ZRtmg//2w06zACYJXcYhtZAVLEpTPhicpXcR9YK6nP/3+VvrRmalAzPQ+PpfR46o1SDdIb5s4IgSuVQAfZPsHyri6wIWddSQzJanuxxmV7cvkL2+XT6HNNguE4+Ds/vhJZsouXpX4a6LUR3H4iP+KLmJmeUgu5w5L/SDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 04:09:20 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::e7d8:1e35:79ac:d6e0]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::e7d8:1e35:79ac:d6e0%8]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 04:09:19 +0000
Message-ID: <202b15a2-8aca-b183-23ee-8bf1d5ed2edb@amd.com>
Date:   Mon, 6 Feb 2023 09:39:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] amd-xgbe: fix mismatched prototype
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230203121553.2871598-1-arnd@kernel.org>
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20230203121553.2871598-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0001.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::6) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: e15cac59-e970-401e-fee7-08db07f7eb68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zZMbMjy07VoKbu8UnvBtMtJ11ww8K0zJ6CEyCZg/XCywQdLCZ0GnXanNSHvtVsN3LS8vd3ySQeUbaSBlcJE6T3wCL+ZUdqbr3zvzAf7N2pF3YwzLVmQKmCJ5k8CdAtBqKJnmOgPhkDy+zJe1Hq1R/8xM/0UtrD+I5vx5Q2fgG1+t+StptqxuP7O0UHF5LO1+qXAZVRHiLJ2eZkcXM3pywa5qpeZXRyVDAbEe0OCH9yCttRuP53Uguk/Qnzshb17YgHvWvLqole/1Ec79KK5Kpf2QkKI7ATNiAz2Vp20KE21JAIZhhhNiI/NbHqdpu9vr8ndIe6lFHsCjeioKftN2KKzgZKsRK9KYku4G3+y2/PgCm3ng2KyQyKz5vBUjlMMIVd8+ybguy8VkqyPo94MchPcuGbJtpnr6+47wAf5CWePOf3bkuLYWHD0rCipBFh0rD10p2toM3DfdHtX00TPIIti/oR5bZ51hx2JXYM9XZ5M5er+/FsWlPZk/j81XXj0cQfWLTEjGvi4AmxRaHuJWBeYBV+XEOywIpCQ1InUornxKABi8cO3HLDABIUaraS+8eLeuoMscNTWeVY3LVPdltMwkMQGu1yqQQQ7AdvKzoKq9FgIjm6LrdigbIFD9oggZFRWVdwNfSiENkvEy2hxr3CH+YI+rRaLagWUptuHX+pvt268CEPN2YNwMymEJHR25MjMjdbWTTe0hyx9g976Aqekp3E3RHdhwCr2LJqp7+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199018)(83380400001)(66899018)(38100700002)(66556008)(66476007)(8936002)(41300700001)(66946007)(8676002)(4326008)(2906002)(5660300002)(6506007)(53546011)(186003)(6512007)(26005)(6666004)(2616005)(54906003)(6636002)(110136005)(478600001)(316002)(6486002)(36756003)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzBzcE9DdEE2Q2hJdjlDajViY0hTVkY1OENVeXg4Zm5hMS95S1NRczhMOWty?=
 =?utf-8?B?cnMrTGg4REdGL3QzWDdSMkJQY1lyY3N3aDU0aERuNmJCNVVnT2lWcEVKK3lr?=
 =?utf-8?B?dUtSc0ZBS1JhanMwS1J5eGNZN2ZIb1BoZmZUQlpkeGJMUjE1WU4weTN2djJU?=
 =?utf-8?B?NWV4NG5vMW93TWdrNmt3N0ZJSU1yODZyeUV5MVMzMWpZdjBXNFBtTnFlcEV4?=
 =?utf-8?B?dFZsNU1CbmNDS3BubFd5Y0tWUjNiUkFhMTg1cFpOd0s3b2F1clA1ck40NFE2?=
 =?utf-8?B?T0dLemNTQlRpQW5ib3VYTDB6ZVN0US9XMFBpOFl3WVJWTWVBc2NFRVdxaUx0?=
 =?utf-8?B?SU5CSFpvR0NxcFBseUxOME50NHZ1cC9TZE9DY00wTmJkbkFkR29WUlJhR0ww?=
 =?utf-8?B?Q3BOQ2Urd2p1Zjc4Yk8wS0JVUWYwbXErR0FpQXNiUWs0WDBXSTNxUlV4WXlS?=
 =?utf-8?B?bzNaOVNwNzNZTEtIS09LUjlSWHdPbjRGZFh1U3ByalZLNitqc0R6MHJ6VEZY?=
 =?utf-8?B?bU5ZM1lSZU5zWWJjSGlZSDBqb1pmR1hFbldvS3JGZmMvUGx6TEdkamRRYnhM?=
 =?utf-8?B?THlqeFZ2cE5zbHg1bE9zQ09WNlQ1QnVQUXc4RWd4VnJtQzBseWREWVB0ZHdm?=
 =?utf-8?B?ZzRoUGtWYU9WdHNSZU5zd2o0T21XWWlHL3o2dHRmT0pjU05aK0t0ZU0yc1FF?=
 =?utf-8?B?RW5tOTl3ZklXTTMxSEFFYnU2cWhwQSttZjlhYUNPc1B4ZGJpOC9CK2tYTTIz?=
 =?utf-8?B?YXhsMXlLYlczOUcxWlNRWU5SeUpBSnM5WEJaSEYyM3I0VUhKQjZ2OVJQVno1?=
 =?utf-8?B?YjlMODZxdVVVWU1jSkJ3TGVxVk9iZlQwSzJ2S3c1L0lpaUh5OENVVGxMSjcx?=
 =?utf-8?B?QUxRUStzZVM1M24xcEFCOWM3bFR1RnpYaUp6emhEY0tWTzlaT3FLRFFLQm5z?=
 =?utf-8?B?dnlOTkhnWW1Bem9MSlI1MEo1cUYyQUVXUzhBRGROYUFVWUxMcUhCTit1c2xF?=
 =?utf-8?B?NitiOHl0cExKNld3aWZxVGdsdTJ0VmMwaDVkMnNGWTc2Z05Da3d0OTRwU2Mr?=
 =?utf-8?B?TXJNdHhZcy83Rkl4WnZHUmYxR1NMUGRQb0tNOVdFNkR0VGdOQVErTGZxWXln?=
 =?utf-8?B?M3Z4VHNmaE5jRCtOTmhsSk9Ma2lvazBwUStBdWVRSmxMVnFlVlViaFZXM05m?=
 =?utf-8?B?Y0lXRHRrTVBLcGtuR0RSSG0zczg5UHhLaGtxMXA4cjZDdVNTeC93aW9hWDJk?=
 =?utf-8?B?ck9jRURubTUyUlJHcXJTQ0I0NVkwcEY0RzVSZm1vNXNwYVlzeTlQRk1MeE41?=
 =?utf-8?B?Q3dzTDZzNEhIQk5qczRyNTRWU2czeXpGMzJQNHJ3Uy90TlEydk5naENBOUIx?=
 =?utf-8?B?QWx3KzBHNFdKdzVuN3ZkbERYSThpdUZxaUh1ZzBOejRuKzNWUFVtWktWeFJN?=
 =?utf-8?B?bTZXMGp1SlJraERVc3YyVXhVelRVZk5OQ0U4dlVWVnIwQlJ5cVVUUXZxYVI1?=
 =?utf-8?B?c2FnSmVZSGhoNTlBcXJ3WkdFSzU0ZjhtSXE5TVBmR25XUjJOaUtzYVRkV2tZ?=
 =?utf-8?B?Sml3a1l3OHdtMUYrN2MvOTlsK2pSOVUyTG9pandYWkdtQ1Z5VEtMZGExSXR3?=
 =?utf-8?B?YlEvN0NucmlreTFyU2JRQUxvQjQ5R3NibXF0L2NTc0FEcHNWQ3JUemlxV2Z0?=
 =?utf-8?B?NjdxTGwvM0k2SkVOTisrYjdKNWRHWlZhTVFQN0JTbmYzRytBT2tiTFpsYmRF?=
 =?utf-8?B?c2tINHUyaW12K2ZXNStHK1FpaGlUaUpxcExacDZDcnZ0OCt6MkhrVW1XMGJ6?=
 =?utf-8?B?emM0VklLZ2h4L2JHTW5qbThtUmVaN0UrTUZjVXcyYkxVVGkrWXlXY1Y2SEtx?=
 =?utf-8?B?YzJFbzBTRU9qSE5hNWFJWGdTNEsyOFJhbThVL0FTcngzejhtY3hUNW5QRVcw?=
 =?utf-8?B?R1ZrRUd4NzhkTnVBNzkzRHdYb3lIcE14TklVaDJZNEYvRkJwZndXckZlN3di?=
 =?utf-8?B?MS9CaW1SQ0o5Ykd6Y3VObUh6Y0F2ODVQeVV5dFhxM05DZFh5Y0hYNTFMOVdU?=
 =?utf-8?B?RVIvVUFsWVlDNUNoWU9LSjBYcUkrZWovc2kvcDdPaGpCK2dVN01xZ1laSS9Z?=
 =?utf-8?Q?jmqKIV1gp2nazlt2JWodAGt5Z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15cac59-e970-401e-fee7-08db07f7eb68
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 04:09:19.4974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JesEIaj1bOkS9lUfdJ9tvtYZ7jpU5NEOchRIDvbGn13j7GoMrLnFiYO6xXEVI86DPoM19hLshXeHdPBhA6kZhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2023 5:45 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The forward declaration was introduced with a prototype that does
> not match the function definition:
> 
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:2166:13: error: conflicting types for 'xgbe_phy_perform_ratechange' due to enum/integer mismatch; have 'void(struct xgbe_prv_data *, enum xgbe_mb_cmd,  enum xgbe_mb_subcmd)' [-Werror=enum-int-mismatch]
>  2166 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:391:13: note: previous declaration of 'xgbe_phy_perform_ratechange' with type 'void(struct xgbe_prv_data *, unsigned int,  unsigned int)'
>   391 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Ideally there should not be any forward declarations here, which
> would make it easier to show that there is no unbounded recursion.
> I tried fixing this but could not figure out how to avoid the
> recursive call.
> 
> As a hotfix, address only the broken prototype to fix the build
> problem instead.
> 
> Fixes: 4f3b20bfbb75 ("amd-xgbe: add support for rx-adaptation")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good to me.

Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Thanks,
Shyam

> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 7d88caa4e623..16e7fb2c0dae 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -390,7 +390,8 @@ static DEFINE_MUTEX(xgbe_phy_comm_lock);
>  static enum xgbe_an_mode xgbe_phy_an_mode(struct xgbe_prv_data *pdata);
>  static void xgbe_phy_rrc(struct xgbe_prv_data *pdata);
>  static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
> -					unsigned int cmd, unsigned int sub_cmd);
> +					enum xgbe_mb_cmd cmd,
> +					enum xgbe_mb_subcmd sub_cmd);
>  
>  static int xgbe_phy_i2c_xfer(struct xgbe_prv_data *pdata,
>  			     struct xgbe_i2c_op *i2c_op)
> 
