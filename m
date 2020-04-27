Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40281BA575
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgD0Nyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:54:38 -0400
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:54146
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726651AbgD0Nyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:54:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsmrQId10XI19VG3O7CxCnZlww74W9Y/EGMiFpdVX+LiPWG3GEWBSI8mEX/zVwxQ5YUxUB5XJfLeAoSc+p9RHPuyfiQPnedST28OXaXeQR+l7AJ8XNZ8V0CigsTHIEC8WXFtVRIne1tB6wZjPT6nTRQwbmSOralghvkXhclbObUvBzmBYi/moU/kkV7L//3/bADzP+yWqPmJ+FIiAtxmYXjvWRq8yQ/4lNcVQ9l7lzAPdxbfpnoTcP+hmEOgoXulT7DNGOEDUTwyaXpD1eCnj3Pohwq6L3xm98Ek3NikUCIcR8o+794g5PcUW0DTmaELA2rlLXYrym5qhCz3tDgJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6csxDieYRY3sWO9On4H597mWtqDBwezDct0O28PD9w=;
 b=lofAUisCUQPQb0SG0/jHkHsNAnxbshSPqWFz+122Xk2OL/SHaE/LE5IyhH64/SHmOIzkdmBTeBrsd6TKUEOcXW6UNb1jd/hXAbx7jQQHitZjF6sV2sSosFkpo1/UarJGlc9raC/rcUOGHzYAbS6onpu0oLZTM+ek3vXU7dQSsUIJ0oWRc9VxmzDBRnnttZqZeS+GL7cOxYB4RagSucu1XsVcwp1rSlk5SzTfawm7nA82KvX9KZwW5f+8wZeuf5pGCr7s3bNrCLuYH6BY2LWDK+Vszszl9NFPaWaHBBo88IlLNhKZoD9kk6XOMIMeArEOlka26JOYi93FAkMuKPqe9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6csxDieYRY3sWO9On4H597mWtqDBwezDct0O28PD9w=;
 b=KbosIm3fIT+8mSzL208jCud4Xrm4DjOAsIqT2l9P1RFiI2Ic8D6EkowZe1sukayKHIf6vONcMmVh5zNy0XdkrTPluvqRr7/KyCcJh5Qkmwl6FlaKqR2bO540hPuvISVROS4oQYSU/Bsrx/hpiYkB7S9UHY2X5VHr4y065NHldjQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2382.eurprd05.prod.outlook.com
 (2603:10a6:800:67::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 13:54:34 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e%3]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 13:54:34 +0000
Subject: Re: [PATCH V3 ethtool] ethtool: Add support for Low Latency Reed
 Solomon
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
References: <20200326110929.18698-1-tariqt@mellanox.com>
 <20200327105108.GH31519@unicorn.suse.cz>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <2b110b9f-2b55-7064-69be-19e17dfd1b39@mellanox.com>
Date:   Mon, 27 Apr 2020 16:54:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200327105108.GH31519@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.37.56) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:54:33 +0000
X-Originating-IP: [77.125.37.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5fbc7cfa-7dc7-44e2-121d-08d7eab28451
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2382:|VI1PR0501MB2382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB23829BC4EA68E60EC1C51EE7AEAF0@VI1PR0501MB2382.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(66476007)(52116002)(66946007)(956004)(66556008)(2616005)(31696002)(86362001)(186003)(16526019)(26005)(31686004)(478600001)(53546011)(5660300002)(316002)(54906003)(2906002)(4744005)(81156014)(4326008)(8676002)(6486002)(107886003)(36756003)(8936002)(16576012);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d9HDHtLYZ1d0UzMi/223/Hy2JWVpomJRcQ24QVKhIPYfvR8spvKLcmR//678u9K7qV1GwHvzf+Id0IjNKZd/Wn9Bel/PfOgRdWSlimT/50IZxFUUWJ3/X8ZvKi8RY7ybZ1GuLk5uSXBvKG/sMYUaR8Q5nC9QWYNXLZEACWNB7YKwxH7LmnIknFcv1JEbxZP2uc2/Me2/ONr2tL6ljm7TsMgROIHJjKE2D1RmQ0+QgN2ZgoOenuc5YeoFmJEHysJG4w3PU7t5RxGXVlcNPc+8ejKx+UKzfJHNaxzdT4aDnSJJxqflxvDmnXI4jqtM1DsEjIGdUjjXSmM44zZDLlfj1QBfIQj8xg+icJuSqEHjp8FJyiH5yT2PG9V+EC2ZV1gapHgpcuSrKfU8t3SDbeaTWS4kAIiiShEpBFnXYcIKuAj559LR2msH9QpfmgrDdYM2
X-MS-Exchange-AntiSpam-MessageData: KrkfMEyfOG8tNYjVgX9/Crh7fbBBSO0sJGs+YVxBlR0xvpOzHoGzFT3JlNF5XnfYy9JEo529FlvCedR7HdwlLGeRcF66jsKllc9xqdQ5xM0bSYdqCL/ORugJiGstHIZNudCxqNlurQWvRyGbWO6naK9L6DhZ5xaq2vM6+OJvmjhDgxTy5e/pmgFEMiakNsCYo42LTfku7Go/gI4+OION6BUzcqsDH8S3FRvxFgNOOg+31fxrpn1m9ucCoRa3KfWoC+SAksX5BccDufpGj313kN+5Hc5LUKeR5Ecd/W3UopMH1h78jEKuIf7nu/LOSE64b6KjVQn+c1mtm52LaDxB3YwKcF99vypdYC/XT/7a59LC5IYiUaMmPaTNBb3RbGvsb7N1Sf12iugX9+Qp/0LXCfPAhaJqKjWz/zir0ftoQ+AjcbHVdCUia9WzXc19uLA5IQXp15k9O/ZkV5kAbxvzn8DnFP8hX30B2AfjDvhfdEREDxBWUp0JDNQA1eUNDhb/FsBHJTO55k+EmkdZry+/3z/NNjjBhFr8dKHhtO/N2EbHgUn4IxPw+wd9A6r6Wx0arwWDtKVtkaAK0TmxlkAEX7MRWq88zP6qHXQcK1dKOcpWfEz9y+ocJEP99Fae+qgYDP3vo2RH5jBPcDsT1z4CUKsOGv1vjrtffpggKS7SOMHNx68HdxXiMVfpVOpSDcYrMsmQKyCP1simrlrnhLq5RCRbWVyvBOieZNfA3NgzQUa51bNq+GvtwQ2i4vvT5KXDpQPnhx/yevDrcSLtpNh55h9K1L3irGCaLyyHzjXGXyA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fbc7cfa-7dc7-44e2-121d-08d7eab28451
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:54:34.3707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00RuEy17bsugBjLik3TATDlbCB/WPFFGl5iNIWy2QCuikcN9T5TjNSaMZ/ONJZrjFjnPjAh2AUnEX59uJaFwfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2020 1:51 PM, Michal Kubecek wrote:
> On Thu, Mar 26, 2020 at 01:09:29PM +0200, Tariq Toukan wrote:
>> From: Aya Levin <ayal@mellanox.com>
>>
>> Introduce a new FEC mode LLRS: Low Latency Reed Solomon, update print
>> and initialization functions accordingly. In addition, update related
>> man page.
>>
>> Signed-off-by: Aya Levin <ayal@mellanox.com>
>> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>> ---
> 
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> 
> The kernel counterpart is only in net-next at the moment so that,
> technically, this should wait until after ethtool 5.6 is released.
> On the other hand, having the entry in link_modes array would improve
> compatibility with future kernels so that it would make sense to apply
> this patch now.
> 
> Michal
> 

Hi,

What is your plan for this patch?
It's not merged into master yet.

Regards,
Tariq
