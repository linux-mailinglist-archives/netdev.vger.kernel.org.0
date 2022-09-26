Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204605EA4E3
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 13:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbiIZL4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 07:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239286AbiIZLzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 07:55:04 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::61c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AD178BD0;
        Mon, 26 Sep 2022 03:50:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNjPWgpFxjs5sBo2mGfX+YzkHt1PszxAgN5XNnqsv5O8TPd4GB9BBOq+FTXc6ALtNsX7NQLRXMSeFF75siaPywBmnogc6yervuPq5waYFiiorRSStXjTg3viDwUFpviRHl4HpqU+K1/nG1MCfGyc7f3N0XGrPe1AApkTe9KVWTcdNJilLxAhVriZ26DoN3G+59voCO6gmcf2dQV+fR+p8lh3W+4E/RbgQOeywaVETTn/PTYIezy55G/NWj51eiSlfmVwMxeFcB3ptKUVX/xaekUYW1ArcbQ8KhFrlCIpwPB/ze0q+5M8TZpvSdxga/D8Jm4cRKzxFjQiKWxJDOcnDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxrVSNQhHHd8ZYqTUeRotBhttpRBrvnMjBnVuY2f7ag=;
 b=lzhQG9l0/ej5kCCuBbrpHx/z1veEOOFxbDDPSWaBI2K76SBsDvlb53yg6E1pXmbyPIu2dAHd25lzNeijP5djcslhHuGSo84zW1b/2SmDff8j1l8AN81sLjOKIZNcYeiH3NtmGGplMQ/by4bKEUW7cHDkrTelOJ9IYLVsuv03FH+YbLDyX8OpXUANav4aNGv561mjhkpttr+64IenLLqgPjHLx6hUglu87uZAneQ86BNuWZy9AMds94b9DcWObEZBAwVMQA2b5hhkZpd1syw3tge0L6XEr7UZ3lvPegXfigSOSvL1L54rxki3CL9zFwXSC2q7T3ZFYSwZAG9A4gbSDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxrVSNQhHHd8ZYqTUeRotBhttpRBrvnMjBnVuY2f7ag=;
 b=DQ6kpJ5/lDubMDbn5EfoS/GL/ThbHvi9Lt26TUAjia6ogRNwKTuKcCJxLTGEjEC1ovor9G3nsgIpvHZGDIcpdrAplA9rmxCIUK4ICXyCZ1O0KPWfBlZQyTnKrQXjm0qp1/zj041lTDOcYOu5vlSFzuI4fEx3m92L+9hYYDvH711YTNZ7i/Z4BGa+Mx/mvFIejzz1LeHFzaAIV3NplEaSIMbRHN/19152xVijz7MMZ/Yo2K08YvB4J41fzV4/wFPIsd5zWGKhKIDLyTPnbAZo7p2xSgPsvPeqiDvBscYLjPgEDwJtjDSPgqFM7MXTBapwZL8bbSx0HPuoR12KPQuRFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by PA4PR04MB7918.eurprd04.prod.outlook.com (2603:10a6:102:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 10:47:45 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::584:c4ea:a4f7:af1b]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::584:c4ea:a4f7:af1b%6]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 10:47:45 +0000
Message-ID: <d8224556-72cb-cb48-b530-05cffab2a6df@suse.com>
Date:   Mon, 26 Sep 2022 12:47:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net] usbnet: Fix memory leak in usbnet_disconnect()
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0000000000004027ca05e8d2ac0a@google.com>
 <20220923042551.2745-1-yepeilin.cs@gmail.com>
Content-Language: en-US
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220923042551.2745-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0129.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::17) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|PA4PR04MB7918:EE_
X-MS-Office365-Filtering-Correlation-Id: 553ef41a-fa9d-47c4-8db8-08da9fac8b75
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9TYdiHmneHTOMIX5ZjtyQhB6BSGsV6x8Zcb3p0eYZQYc783GBb1jhq7CAfKRrL6hDNzDIBJyBJEUrUYdLriOYlq3MdDEZL6T1/39N8TfuImwS8sDtwxpOXwsfWiL+l3Xn/1q4mTVVSBXFfzTkLPp9p5fPK6GKYzmWCDJVw8b7lGZlMvyExHal2yVjPljwFeP9WnsiSQoTB57gVt+6qbQVDmDmaMVw++9hyv9wBWHLRnHEwdcReRz6uNVmqzXt3oJdOiJ2+4Uip1ljQO5cURh2uKFfYCRJqiqp7LrZKJXa1zxlypKI6qyVCSvMLO1J7Tasfe2CM4NIWwDo/0AmgcFNyM4T/hIi1mKzLkgu7GJVglbxauifzVn9inw0cGy8W3AK1K3wfz5rrNzJsAzFgvzha98HMzqnPAVAc/LieI67AQWrRndjss5DqpvoZnx5UBXl/2D0+rQp+p4sq4VPFspQets0t5xMPjeAbsnArpA92hm6re7WX71zZGvoRLIJlaCVuni3MBpK42QzKD1ZXfPz5zbLNkip+kPyS/43jVFIZERansYszbj2C/d6zjF6VZWvh3WtZhJNgfCuCdp5wHEts6xgqX0HXnuBVy0ALh3sNE6vZ3yl4HidPIHSAyHAZfYKDX6cMEixnzzWV2LXWeT6Yq/C3IG2l9W8n21/VuPRJHm2c35oUIM6+m+UwVIDL5YPX/bRVlMNB4imm1OUC0AsWwDHbYb83if+1pU4jIQFNuLxwbKHoNGRGi/TB9Liu/c+LhuNI5d64t+kneDE3k3V4xdJi0kXpf7z1S14p+okNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39850400004)(376002)(346002)(396003)(451199015)(31686004)(54906003)(110136005)(66946007)(66476007)(478600001)(66556008)(8676002)(6486002)(316002)(4326008)(31696002)(86362001)(6666004)(41300700001)(7416002)(6512007)(5660300002)(4744005)(8936002)(6506007)(53546011)(2906002)(38100700002)(2616005)(186003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXNaQllRaU1rbUNRVzhSLzdBRGM5dVBaUnYxeU15bUMyTndPcHBDRC8yR1lt?=
 =?utf-8?B?bTI3OTV2S0g0TWtKaWNZbkc0WGxQWjdtdkpUcUVYUkdKa3hTNUV5SGhWTWs3?=
 =?utf-8?B?b3hHMGNIWTZRRzJvR2dpaDgwb2pORkw5bktzaDJFNWJVczFFT2tMNzlmREJZ?=
 =?utf-8?B?K3VlMnhBUWtram1mdUJHS2ExVCt4Wk5GS3hIVk1aM2dnakp2VG94cG8rY3ZI?=
 =?utf-8?B?WnU4UGdKVkVBZVJKMENPdTh4NmIySThOY1pPUlVLZ2I4RXVVWVI3UyswTzFx?=
 =?utf-8?B?MlNka1B0QnVZUWptTnozeVExRU9uN0Z2WkVwcENZYVpmVVlWanJKVWNKeGlX?=
 =?utf-8?B?RFZVYjl6UXZ0Rk9icjhjQ2lNeFY5T1g2V1p6TlRoZHlQenlVcmNRcnFMNHFs?=
 =?utf-8?B?NFVFZzA0aTI4TVl1S3R2WU55SEtRczEreW5LN1RaVG85Q1BXK2NyL3VjWGxv?=
 =?utf-8?B?aUJDYVJRTnJWanhBWmtHL2VIUCtnVDg4VVBPZzFjUVZjaDA5M3ZvTzc4c1JU?=
 =?utf-8?B?c1NjOFI5YXdMaDYvN2lkcDBZK1ZiekVsYVAxS1o5NzNjUU00c2xNczlhYTBG?=
 =?utf-8?B?V1BXRWFVeFEyNGVtdi9nK3JmcloxNEgvMzUvUUdTR1dtaHVGbjhmWkxNWkZ5?=
 =?utf-8?B?ajR0NnJnM1F2M3drYjZhdi8za0ppYzgvbWhMRXZWTSs3YmdjaSsrUWNjaW9o?=
 =?utf-8?B?QmVpbWMzQ2l6S3B3dWVXM09wYnYxTzVlOUZIZzhqN0hBbkxQRVVqM0dBOWpF?=
 =?utf-8?B?dzhCRzhYZzVRVTdoODBtblBwNlJHMk5tcmR5R2RFbXlSVGdLS1BHbkxLZFl5?=
 =?utf-8?B?bXRsUEl2ZWpWWG54aTh4U2I1RzR4YWJNQ09YbkxleStsRmVrSUoxTG9vcXBK?=
 =?utf-8?B?T2xtQ0cwU3VCNG5xMXdrcUhyOTdzMVFNa2JmYzZUL2lpNHRncW5ZL0FWRDZH?=
 =?utf-8?B?bHJ1YWlkVHhTRkpRYitiNHFYdm9tQmxvU0VnYThGa2xaRUEzRzBiZkNZaVNH?=
 =?utf-8?B?NFBJV1BsNTZBNVZ5Q25xdmwrT1N6MXZTNk93WEhWNnlCTTlQY1pXZ3p4ZmhU?=
 =?utf-8?B?R043NzFyYXlTS1pmTm56aXFMUU9LazE4RlprbmtpSmIyMFpaS1V0Qzd5bGRs?=
 =?utf-8?B?OEhHNzhlSmhBVGdYL0VYL0FWRHBta0g0MnRidU5WUGdreVNoektXVnl4M2JL?=
 =?utf-8?B?S09uUW5LRmFBNkxkOC9zTnpOMndpcjhTeTZQendBLzZoK0srTGxqc1duNGVN?=
 =?utf-8?B?QmJUbW9LOVg0aks0UlFDcUJPMjMwUTJBb3M4SlVPNG1rOXNRb1c5bFE5YUNX?=
 =?utf-8?B?bFU4K1BJZERPeHdaYW5lOFpZbFlCWGtmVytGaVpFeTcrYlpuUUlSeGk2VVl2?=
 =?utf-8?B?YlY1V3h0cjFjai9JRDZvTFBHekRLN1ovTzBBZk9rWkUrZlY4SHduZzJKdElZ?=
 =?utf-8?B?a3EzL2F5RUhBYVBoSkYvRnBJMlhEL1Zzcjhqbjk3R0Q0ckVyVmVMRjk3cENh?=
 =?utf-8?B?Uy9ySFgyM1ZEYnBrbWFqbldNTElvc0hnQkx1T2RLeTh6V2hINndqSlpzZmhj?=
 =?utf-8?B?NlgrREJJSEdoVnpoQjFYU0QxaXFWY3FVcUR1Qko1UDJuR1NLT2o3ekNvYU45?=
 =?utf-8?B?YS9UZ3RFL1dyRnNDeWxGZ28wbE9jWVZVOEZsMjBnSWdMcE1NdUh1V3hML0l1?=
 =?utf-8?B?ZU1CLzFmNDUxRHl4VkltVFcrN1VaVU9kNGNXcXBtNFpkcFlSWE44UzJqRlg4?=
 =?utf-8?B?OWk3NEhobUlCTm9aSWxleFd5bnJBV2I4U1lCWjVQNW1Ic2JNTE11NlllR0xQ?=
 =?utf-8?B?QlZoTzZ0Vk1MeUFQOTR3cVFRS1l6R0Y5YktIZ0NzeG9yNWpzcEdjcjRSY3F2?=
 =?utf-8?B?SVhRN0h0Q25rMnJuWjZRejh4NXpVSUg0L2hYOTRQeHc1SlFJZHZWRW1EVjkr?=
 =?utf-8?B?RjNTUGdUMmkrL2hta3lza3JpVjU2Mm5LNlM0Y1Vwc1cxeGZtdjBNb3ZvOWlJ?=
 =?utf-8?B?VXRkWVcxRkFteUpaR2I5TjAzWXhINVBIZDdZeWUzUzBPbFdNMk5ISUh1dWdQ?=
 =?utf-8?B?Q0ppVVZHT0Y2U0Vhekt0dnBFNkxobmsvZGNLTko4U0c0cDNjdWM2T3d6MlRI?=
 =?utf-8?B?eEo5MmR1aUZBcy81MmtXdHdTRzRpRnZZRUNzbmFhYjF6RVNIYUliTjM4VnA3?=
 =?utf-8?Q?krJIEE7S91cVKKAYPxLfV26axUGx2+sEtyd4FkVnN2c6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 553ef41a-fa9d-47c4-8db8-08da9fac8b75
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 10:47:45.1305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIRFtAvM1OAtFNwted+w6DJBrlA2GOWX+zZsL7Pb8uoJCGOR2M7jpHZqd6PHHK/fLas+a8dK4eZdH/BnrZT5rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7918
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.09.22 06:25, Peilin Ye wrote:
Hi,

> I think we may have similar issues at other usb_scuttle_anchored_urbs()
> call sites.  Since urb->context is (void *), should we pass a "destructor"
> callback to usb_scuttle_anchored_urbs(), or replace this function with
> usb_get_from_anchor() loops like this patch does?
> 

please introduce a new function with an additional parameter
for that, so that we do not need to touch the correct usages.

	Regards
		Oliver

