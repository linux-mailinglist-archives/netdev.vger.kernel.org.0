Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD31C614AE7
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiKAMkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiKAMk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:40:27 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140134.outbound.protection.outlook.com [40.107.14.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5631A067;
        Tue,  1 Nov 2022 05:40:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBh144NRtIbm5v+YyIdZiS+VyjRQCJW3RS3A6WkC69sUDOeP/pjK+oyLAyNW7qCsxJ6eu/sFr3PpH+tiKvuKt0T/96z2eoWTEhgurqwL2y+1K6xjnjqClQFIt+luNzBXtGMS/wbkjEgOlPruzxbSJurOpwsBojRADQo7s0D5fq7hpO4FR28GtUBS06lcsyUFwFdYw62ER6jDzXaXryLvO6MC5UC6SIf+C0B79S4kFz8jweJUcg/xZ6Xu5N7Eq5jrDjVO4a7MyXTzf7dNJ86L4EIVXsxGPVW3gbCaYedGTmTkU7ZpYtEBgrWgY1UcbFq/eiYX3LVjddI1KAj4cQdsfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhpyxyUemrXZ17XenIOFm3sEUYmlgE9HLITjl01Uyhw=;
 b=l1hz5LJGzACacb/mH5yBMyOoszNmyINu+VEeypp8BfwjuFMCPls+JfSiV7Rq64Fbc9gu7VJ+methf/k7YTjcwBXMeZns1OcbMK0G4spU3f3SxiWlRQL0640MILMZE4eI7IhfTTcWDd6E8tARx2Pbx72t3ckgJyqYr2aP8Is85dYi2Rr3f7v7UsA90dVMeaQAGfsywEY1IwHga3N/C+uHGqFZmFAojtRNqpyvNveWbAEEV/N3+75+0a04zyP220Dol2mSh5KSZJu81fmAhrFvF8cx0ivC6OQZo9y4Hfjt8uIQgZC5nhUhrUpyea8kI/Vrc1w82UO/mNyAGM/DEJolvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhpyxyUemrXZ17XenIOFm3sEUYmlgE9HLITjl01Uyhw=;
 b=HBjxLzK99O6sQGU56u7fvQ4GkamflGVXkFV0fskIik5U5GNmfaprdy+1kUmSXLjpIAySCq33T5iIjqNzWPslcrAbeVuoEsADp7E79s96c5VFWEsac+1WSdHWy5L3fPjZfwpFrT8bhdH1FJYGWkYIFH1Ghx9beL9odvbq6j5rNCSGMgj0muXB0gSqfjDxDNksWVWa+jVOg7FOIoB4fvjZbyS/Dih9HCOnjRMLdPNaIi7RhhIWgh6GWJVAuKCQuMUOhRjl13oMFBiucKoJvW1tm/+J1BeucmwNHCZZF7zRgOXzBJfAIP4dnY/dM5Dmuq20hGnuUjHznL8aHa88xX3tiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by DB9PR08MB9659.eurprd08.prod.outlook.com (2603:10a6:10:45e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 12:40:24 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::e2ae:48d9:fe01:40e7]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::e2ae:48d9:fe01:40e7%4]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 12:40:24 +0000
Message-ID: <56da57f3-446c-fe63-b625-931fd9f0cbd5@virtuozzo.com>
Date:   Tue, 1 Nov 2022 13:40:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net] net, neigh: Fix null-ptr-deref in neigh_table_clear()
Content-Language: en-US
To:     Chen Zhongjin <chenzhongjin@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, daniel@iogearbox.net,
        yangyingliang@huawei.com, stephen@networkplumber.org,
        wangyuweihx@gmail.com, alexander.mikhalitsyn@virtuozzo.com,
        xu.xin16@zte.com.cn
References: <20221101121552.21890-1-chenzhongjin@huawei.com>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <20221101121552.21890-1-chenzhongjin@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR09CA0065.eurprd09.prod.outlook.com
 (2603:10a6:802:28::33) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|DB9PR08MB9659:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c175629-71a7-4f17-f3e8-08dabc063f26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFggomur8Trv7SuJ+h4sH6VDJOjC2bv5AP4loAZc/A+bbZ2WNL158fjy3jTgrVUuKjJayrjZ+rf77x3F3vAwPNLL5JMcG1xEXzjd7o3p4wvzbtL4UYTofhg2msZfXJPQsDpSX8osF40lcICHVS5OzprJ4JFZmmmaeVf8hvopdfHFFLzAU2UNwipGqAbRFTA7cDWgM7XX0XtJFAGDVFs3RkyLxI5kM7eEyhwVi+whJujqZZ4BhUhS0Z2OoMtiNrBoIursuhJ9jkoQyNW4BHhYH0xghQOBAy6oKCegQmZAMavfa42xkuIjjjH9kvNc5+Cjt3HJKU9yYjmGu9aKQGjYDqK9Dgq3iKDF/CmPZcRaPVJ8+9sgt1iILkDW4zRw51d/0I19WSgZt4sYLM0NaX0asCgLGzvLVvzQC7HlQUL3DoTfYTIZ5woeyIpo688UizKGQRLv0kj0th8f/+r2lF5P1hTov2amjnA+nVVrnVCjvQChH7riSbntc1o+vYJx9BOvC3cWAcOIGLMvB9E8UgxXXYFlxvu/9J8wqWh8BtP/ZmmZ4g2WvqKV404eml98QOiYEBhsORaJvXKTvmQMZEMoEXZ4s2RgCj7khUkAQ/qkHxYbX1ZZ64QAXCvLiGPGu8IEAzCNLqZoSmDSzYzG30QHwwwbKF5BrhpKJXoX1mX0gbMhSrbs4vHOo+yt2My+950owh8PA6eezNXNuDKWibiIao0PA8mIY+n5XBLVgeKxTLzcoSdy6zm0xH4fKZWQ5plqGP4bBtMSA7GSmx359YnCf65uB/8LSdkG8WZdadf8VZE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(396003)(376002)(346002)(136003)(366004)(451199015)(478600001)(6486002)(53546011)(31686004)(66476007)(6666004)(316002)(66556008)(5660300002)(26005)(6506007)(6512007)(41300700001)(2906002)(83380400001)(31696002)(66946007)(86362001)(8676002)(38100700002)(8936002)(2616005)(7416002)(186003)(4326008)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHdlVWhWTVBLODhGVmhnV2ZCWHNFN2RKeFhiY2ExQU1ZYkpDblJDTE9jYlk2?=
 =?utf-8?B?eFU5VDNxOHhVL2VyQ3dIajcxL0JlUmpKMjJhTFEwK3N2b21tbFpjMEN1T1Zp?=
 =?utf-8?B?MC9pcG1QMkFZeFFrODF3VW1nL2s5bUZBWGxjTEdKSW9zaW9hU0ZhYk9DMldU?=
 =?utf-8?B?N3QvaWFMdlh6dmMvY1dlUWZNVzIzTENrbU1LSmRYUmc0NG1vZlIyOTFnMGdi?=
 =?utf-8?B?aTBybXNFNXljQk1BMDNBczlocERFdnYzaWVtd0pYUHdkNGJlOFQyTkhuVXR4?=
 =?utf-8?B?blpBUW5Mb0tSN2FyNkF6L21SdmN0UnVPWkRnR3kzdmJtR3diZjVCTStuUkht?=
 =?utf-8?B?NWpNcFYzQ243ZkR1NHV0ekJyano3R0x1TWdZMU1JK0RRMHBUZnJYanc1M2Z6?=
 =?utf-8?B?L0JZeENXZVV6alUwK3J1TEQxdCtaczdxOXV5RmhQRzMzemREQWs1YTlUQzJy?=
 =?utf-8?B?MjRjbnRyZ1kxbkVhc0hQR0MwUmZNb3oyN0h1R05CQ25tVWVRMkljSm1Qb3Zp?=
 =?utf-8?B?UUMyTjhvTlZNMDFHdHZDaEs1MitYZk5scFlxaTdlWGlOVUtjMlVDckZhNmQ5?=
 =?utf-8?B?K3pRUTV3V1BKWEIrSi84SWRIdUI1bEE0Zys4NHA4eTZkTTY1K0ZDMjd6TTc0?=
 =?utf-8?B?UURxOFZTcHo2TTFyQnh6a0VDVitFVlU5SXpybmRpZjJFVW52OENUcVAra0N4?=
 =?utf-8?B?ZmwzbjlLS3ZQc3Y4a0kxbjFHV0tYd2xaVk5HVWVWcDRncTgrUHhndUV6SldQ?=
 =?utf-8?B?My9xQzNtNXQzVjFZUS9WRGZvSGdSTHNOVjVrSkJ3RWJ5Z2ptTnNZMGNCSDJj?=
 =?utf-8?B?Zm1zRXRLdXhUYktBZjJESlE1Mi9EdmRzbEV3cjJrQlkxY3QzL0ozWDRmcGZi?=
 =?utf-8?B?QTZYR3M4SWpkQUl3RzI0c2YvRTk2aUJucmNObjh6eHBmZ0t2VUxmZUJRc1Ba?=
 =?utf-8?B?emJwK094eWh6NjBDZnQ3NWY2SXpDeUVYZTZuMEhMOG5hMnFTN1JEN3NrbWpH?=
 =?utf-8?B?aDRrSElYTVcxZVdiU1YyVCtqbTB2amJxc21Lc0lvTHFxb0xaVDJmRzM1b3Jk?=
 =?utf-8?B?Q3lQekxVMVYrckZXNUxPOHphd2NpY2UrQ0xlNkU2bzE4ZGlaQzg5SWVXMUtk?=
 =?utf-8?B?LzUyOEtuT2RqZUZiQmRNR24zSHlraDNSeStuN0tqdXRiSi9ybE84ZlpBeVBT?=
 =?utf-8?B?M2ZtckpKT1N2c2lMRXc5UUxqc3hza1lLNys0RGxmZXdEd0g3TlltYmV1MTkw?=
 =?utf-8?B?WVJoNjUwWUd4QU4wOWpDYzBBSGJnNkorUFdqVzdwMzRlM2hua0t0eXZMOG1L?=
 =?utf-8?B?eW9vY2pOckNOWXIzblo5cVU4Zk9KT0dQcEhmUFFnNnErQnRGN3hIYjNNdkhh?=
 =?utf-8?B?cVdpcjF1em5GTEhnTzVtVWlnUXgyQ1pBb3MxdlNXMGttTXVFVFhzS0NkOXZ1?=
 =?utf-8?B?NlVmRHplOXRveTI5WEJhQndHbmlWL1Ara0ppM3VlcWNLTS92cE1nYVlHTDdz?=
 =?utf-8?B?anhub2dWN2diVVBYMVdyeWFUVGpZbmJhMlIrVHVNVTc5aVlYZG10emtFVkhZ?=
 =?utf-8?B?UHFIcVJ6NTJyWWhnd2hSRERiLytMbUk4NGluTjNOdW55UFpLMjhqQmFRTzVh?=
 =?utf-8?B?U1RadlYxeWdiUS83S1huM3VpVGFnc0lXVmdKRmNFTEFuTm84N2RNazB4Zktk?=
 =?utf-8?B?MGd0V1pDeGphWHpLeEVoc0s5bndmTTV4Q3VCeWNKcjlxY1d1STJQNzQxMHhJ?=
 =?utf-8?B?Z1FaV2p5NFczR0Zyb1VMck12eXVFR0QrU0lTTjNEdHFRbWlDM0F4MHhadDJi?=
 =?utf-8?B?czZ2UnhJRjA1dGRZRkZHNTNBci9rTDlpSkdLdlZiR0RkQ2JyZ3hyQnZmczFs?=
 =?utf-8?B?UXd4ZXBXTHNMNlB5aG9WZjhuVmZCVEVkVEFMYVRPSkRBUkRIaFBmcERFampV?=
 =?utf-8?B?NEI1d1QvTWVpeHZTdWFNMXF4K1FBY0NDQTQ2cWNFZS9HMTE2VVU3ZTZnUnVo?=
 =?utf-8?B?N05BdDZnM3l1WFBmVHlwWmJ4VzNYUVpkUTgzQXNVdmkycWlzOURxalZEK29x?=
 =?utf-8?B?empUU2tuU2szcTRQdHM3OW1waUhFUG5DbWZUdXk0a01PMnMxbXo1ZnkvSEM3?=
 =?utf-8?Q?L8XABTIgLx0isn2B3D1dTA7cZ?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c175629-71a7-4f17-f3e8-08dabc063f26
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 12:40:24.2783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5L2+5qXQWFJ96F/iS8V5XYmHg5B+Mw+1vBAuxFXm607dRievc5h3rS7KX+L7gfZ0VjUb6OAzAy5OYDhL0tFZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9659
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/22 13:15, Chen Zhongjin wrote:
> When IPv6 module gets initialized but hits an error in the middle,
> kenel panic with:
>
> KASAN: null-ptr-deref in range [0x0000000000000598-0x000000000000059f]
> CPU: 1 PID: 361 Comm: insmod
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
> RIP: 0010:__neigh_ifdown.isra.0+0x24b/0x370
> RSP: 0018:ffff888012677908 EFLAGS: 00000202
> ...
> Call Trace:
>   <TASK>
>   neigh_table_clear+0x94/0x2d0
>   ndisc_cleanup+0x27/0x40 [ipv6]
>   inet6_init+0x21c/0x2cb [ipv6]
>   do_one_initcall+0xd3/0x4d0
>   do_init_module+0x1ae/0x670
> ...
> Kernel panic - not syncing: Fatal exception
>
> When ipv6 initialization fails, it will try to cleanup and calls:
>
> neigh_table_clear()
>    neigh_ifdown(tbl, NULL)
>      pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev == NULL))
>      # dev_net(NULL) triggers null-ptr-deref.
>
> Fix it by passing NULL to pneigh_queue_purge() in neigh_ifdown() if dev
> is NULL, to make kernel not panic immediately.
>
> Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> ---
>   net/core/neighbour.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 3c4786b99907..a77a85e357e0 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -409,7 +409,7 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
>   	write_lock_bh(&tbl->lock);
>   	neigh_flush_dev(tbl, dev, skip_perm);
>   	pneigh_ifdown_and_unlock(tbl, dev);
> -	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
> +	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL);
>   	if (skb_queue_empty_lockless(&tbl->proxy_queue))
>   		del_timer_sync(&tbl->proxy_timer);
>   	return 0;
Reviewed-by: Denis V. Lunev <den@openvz.org>
