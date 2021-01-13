Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195FA2F4B5D
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbhAMMeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:34:00 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9597 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbhAMMeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:34:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffee88f0000>; Wed, 13 Jan 2021 04:33:19 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Jan
 2021 12:33:19 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 13 Jan 2021 12:33:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3oOOJmYOvI61cFB0ojRZXwk8CbAWELNy/tK2SyJoLVhTdRPRskXT8QWRnjlmCAlO2rs7dUZipz3IrhPGyk2RB+myCtKyCpAxO1x/f/FHRSJH7kPBoOvW9PO4IK1lswHYZWzf+meW+WzExa7ENcnuFIb1vkMJe4J0MYlPnJJ03pmOBlZtcBu9dHAIxfkY524SbXPThlePd+c09H+hk8oP9oqm+gxzjSN4blAJpDbqj5siMAZj2cJlu8MMGvQIoY+pVq2sHykLAPA2dhOYW6Trp+B+/b/kEzidJFcGeporKw1enjHzpAshstxw7hhThtHtHjrsATcKMnkLMLR2nkCKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xD7QYIYafM4V9zgOrpdR2+XGHgufqC0863bIYn/71eg=;
 b=dWMex8a+IRtrT+r1zlZDA5l6/SDwxCLdz1pR01609jmV75y/EKLmxrqlI9fw9y01plNi6mbGoglo4ibIvxQxlheBXQ1naflbgkRhslnV8lVdrLHNjbwJGs7UT7eIBHChdCjBcyZuOzFrs4Uia6lyLzlqkwTDFSd0UoMTA2YjmS7TBhZOlhrXPMdpD7rAOapUWwrYZeOMzCTDtAGFC81P9QrI/tFjvaNBY99W0p/sHRgA19eZa270gTtZ/ntdj7NFr1lIbWu/xoAChCXpfYnPGbVtljH2ujzNohtlhtkeefRW9ZStTPehXAryshubMfcyqNJMup2AaTVIFPNNbBNXcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB2777.namprd12.prod.outlook.com (2603:10b6:5:51::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 12:33:18 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 12:33:18 +0000
Subject: Re: [PATCH] net/bridge: Fix inconsistent format argument types
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>, <roopa@nvidia.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1610531059-56212-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <0c4ef6ac-3d6f-121a-51bd-1abed4a75da4@nvidia.com>
Date:   Wed, 13 Jan 2021 14:33:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <1610531059-56212-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::24) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.209] (213.179.129.39) by GV0P278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:26::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 12:33:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cad5776d-2875-4877-8a2f-08d8b7bf67df
X-MS-TrafficTypeDiagnostic: DM6PR12MB2777:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2777D3145EB8B918927C697ADFA90@DM6PR12MB2777.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kJMzkGyellvOAks1TabQXvRhpXlsNY9vOonQJ/zeq0zln6krvR6aPkNFWI7/h0rYoEDYZB6pwLcHr0V63v9Rt1vaSUUKEmW9h4BAqJbP7/8pn5A9zCXe9wVCRcPY/wwK46bHhY/XJvz9bKJn7iacslAoXEmJ9Ba+TBRYjUdkHURXx1NhF8NSKTWTuvHrO7drIUi/fCDcwYpRKwJXfSSCfIpXFIyFj0O5Kn7Udc5/NmX5MaAlfNuhVvXa2Vp5j/o/jSEvEqv+BKhCtZKg4k/3r/NVCaiZ2GYar92/G/wyzfRoHeecHRufNaDg9VCqEQvDiDnMdssygGkr4FMPydJf1JNrmtC4nD/4GW51S+IZBdJdRLpPCupYvT78zy+4YlL8pxHSWtV3vGKKDeS2j4lIU5fM0Oqwu/pI3ExxZiKWr4cXWHHw/H2jnNZjAADvC2rVwuNhMZhGB9kEdDpC4QYJ+A6kQjKAo/s6XVZltswXFOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2616005)(5660300002)(31686004)(66556008)(2906002)(66946007)(86362001)(6486002)(26005)(66476007)(6636002)(31696002)(53546011)(16576012)(4326008)(8936002)(316002)(478600001)(8676002)(956004)(83380400001)(36756003)(16526019)(6666004)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aG4wTXJZV1lMQ21tN09KMVI4N2dPTytRTi9vMDV6ZDFXbXdmcFFOTmd3emhh?=
 =?utf-8?B?KzdvWFVzMUwrWEJoZ3BLUU41RVZEcFpxcGhCKzRkeG5QWW9FN0Jkc2UyVkt3?=
 =?utf-8?B?blB6dEVXeXFGYnZ4OUFxbXFpUTBOUHErNGJUU1J4UTZ0V0dtbzNUMGNLd1JV?=
 =?utf-8?B?U3VXVTB4aUE0dmcyajB1RGpkSjJmWHNvYTZpWVdXZ0Y2N01XbFIwbkJiRW1M?=
 =?utf-8?B?WnNDSUZUWHM0UVpvVGpNZS95RDFyYXJCWGxKUDlPclY0TTZiNlhrWnJoSEZq?=
 =?utf-8?B?QXorSVR1R0pNSnBDL1dGbFJzOXBGQU8zQ3VVdmZQL0lKSUxwQkxUTml2S3I5?=
 =?utf-8?B?M3NybXhMOVdDdkViZ0ltTklkaTVmb0JMZWMvK3Y0c0c1QzVOTkdmU2FIdVUv?=
 =?utf-8?B?NlpDMjNHdTl5Rmg1WFFvTVgzN1lNYytuT1FWYytXY20ycEN4OWVrVkFqSVhX?=
 =?utf-8?B?RFlVQnY4VGhjTnJURUI1VVFzbmdjWElYSW5lTWJGbys3ZWYveVptbnBQVHI2?=
 =?utf-8?B?a0VXVlNSWXBOdWxSOFlBMi9LZTlCamNQc0tKSjI0NUVmQUNCRE1TRTVpUzF5?=
 =?utf-8?B?SUpMc0QyUlpxUGJtaUFXM2Y5dzA2aE9KS0Y5ZDZVa0pDak9xWFFqQ3UyVUdu?=
 =?utf-8?B?RCtxbGxlVEh2VzBHYU0wdDZjRWk3alVkU0NYaXhVa1k0ZTVibGNhSnRScjRa?=
 =?utf-8?B?UEIxNWE3OGo3U0V0ME81MkJHb3hCSW0xOWg5cUJTUTVEVXRJMXhZMUdyYWFU?=
 =?utf-8?B?clYrK3RjS2tOOGozUWVGMnBDcWxDVDcyRTNKcjAyNVVidUFtYytqVGloOXBB?=
 =?utf-8?B?ekVSWEtWVTRXV2V4aXh2a0RGTFBXV3JzVDJFZkRJRFFxYjVvbk9VSUZGSlh6?=
 =?utf-8?B?ZUl6cVZWcjBnMHpZWTNyTjZoTmZVTHZrVjAwOEVvaSsrcS9yNG02aVJHTjJr?=
 =?utf-8?B?d2tuSSs5eFc2cE9neTVsNjVpNm9oL0dvNUNNbFNMU2gyTThLWGs2bjQySlBI?=
 =?utf-8?B?a1pyRW9NTE1kZ1R0SEEwN3JyTkxuOStITjBqK3dQRndCS0dISmFTZ1YwWUZO?=
 =?utf-8?B?R2l6aXBod094eUlSVkdBU1JDcldzOUdCQis0NDhOdGNOaHJLMUdTZ1hsbzlI?=
 =?utf-8?B?T1BpaVNxWnY5SkNPWTUvL2RVM2JxNk9NSHBYUzNDMkFoY3FNSncrNjVTU2pm?=
 =?utf-8?B?MGlPNkEwVHZuZlA0dGl0VG5Ca294bjhINnZVNG5LaW13NDhJaVhlVGlsNmor?=
 =?utf-8?B?ZE1nWnRDT1pESStQaFpkMVpEcVhuRHV3WFBFL1RMZW5McTdKWmhwRVJoSmRT?=
 =?utf-8?Q?rgyC1VLHXlyQ41TfI/p6OcFyB3841ltyRA?=
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 12:33:18.1109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: cad5776d-2875-4877-8a2f-08d8b7bf67df
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIM62wESbfg0Wc5JLEIGasClE08Jdy2Z1s5QHZOzKSXXP+JZQEL8o0lUYWPLXmWUqINoCZgW3aVOHj3eOsuAxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2777
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610541199; bh=xD7QYIYafM4V9zgOrpdR2+XGHgufqC0863bIYn/71eg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=aNbCLe6XJ1KhQSeT0IK+R6sMxABD2F8/D1ikECD1Zg8G0ecQ0JivHfJyOyaL6y6qV
         55RdStCWyrHN7S6PkOO/6LViAxgjnYRa387BUq4dovoCu1EmQ0VBMRAQ6gm8Rmg4oX
         p52ccp3evC6VevGLHRxuzFUH3ECLE5vLO97RUKNHdOr8X+HskbyqHG6gIsAvGVJOQg
         s4rF7S1FmWMpy47DYvb2gaXYgF8pJF4OV5vUl2QCSWxAr8IV4Psu84aDFuLxh8VXU7
         nMjDeQZMThcXqwfGlj8Pa8n9LkkoZYAG7g5xgNpGA9/3cbJNGrWZhKXapKlrnnBD8c
         d0MrA/HNosMbQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/01/2021 11:44, Jiapeng Zhong wrote:
> Fix the following warnings:
> 
> net/bridge/br_sysfs_if.c(162): warning: %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> net/bridge/br_sysfs_if.c(155): warning: %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> net/bridge/br_sysfs_if.c(148): warning: %ld in format string (no. 1)
> requires 'long' but the argument type is 'unsigned long'.
> 
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> ---
>  net/bridge/br_sysfs_if.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

As I replied to your other patch with the same subject please squash them
together and send them targeted at net-next.

Thanks.

> diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
> index 7a59cdd..16a7d41 100644
> --- a/net/bridge/br_sysfs_if.c
> +++ b/net/bridge/br_sysfs_if.c
> @@ -145,21 +145,21 @@ static ssize_t show_port_state(struct net_bridge_port *p, char *buf)
>  static ssize_t show_message_age_timer(struct net_bridge_port *p,
>  					    char *buf)
>  {
> -	return sprintf(buf, "%ld\n", br_timer_value(&p->message_age_timer));
> +	return sprintf(buf, "%lu\n", br_timer_value(&p->message_age_timer));
>  }
>  static BRPORT_ATTR(message_age_timer, 0444, show_message_age_timer, NULL);
>  
>  static ssize_t show_forward_delay_timer(struct net_bridge_port *p,
>  					    char *buf)
>  {
> -	return sprintf(buf, "%ld\n", br_timer_value(&p->forward_delay_timer));
> +	return sprintf(buf, "%lu\n", br_timer_value(&p->forward_delay_timer));
>  }
>  static BRPORT_ATTR(forward_delay_timer, 0444, show_forward_delay_timer, NULL);
>  
>  static ssize_t show_hold_timer(struct net_bridge_port *p,
>  					    char *buf)
>  {
> -	return sprintf(buf, "%ld\n", br_timer_value(&p->hold_timer));
> +	return sprintf(buf, "%lu\n", br_timer_value(&p->hold_timer));
>  }
>  static BRPORT_ATTR(hold_timer, 0444, show_hold_timer, NULL);
>  
> 

