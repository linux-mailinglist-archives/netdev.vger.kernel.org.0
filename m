Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D855516E27
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 12:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384527AbiEBKeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 06:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384503AbiEBKeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 06:34:17 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AD862FD
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 03:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1651487447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wDCCtFoesKY3P84t12vQMmmKEQVIcbXFA0MnVTXz0/8=;
        b=aKmravIyOheD2nvZ17XAHF/1wVmoS0sV+R3Nz4sTtqnX7MMGJoQ7tUG1KP1AgUZGs+EAge
        Zdic8kCXXispxwmv4Y+lYOcBH8ETuPX1Ic3w1Hax76qptkLUsQdyZNbBIVqh0EGf3Fp8Db
        TxZ7GRm3bTz9EAws4Qmha4gC/SKATpM=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2059.outbound.protection.outlook.com [104.47.5.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-14-INKqVx8eNBiVIsuDk5GDvw-1; Mon, 02 May 2022 12:30:45 +0200
X-MC-Unique: INKqVx8eNBiVIsuDk5GDvw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXmVrg8VH8FxwMWuSSjCZ1gBVUgzUTWT+a46Jg+VhWiawvYEJdRVq012TXUNg3/iFo31ITOt5qkwgxYtkq6cnCnJKfOSe5qtA3UXVlyL0I4w6QeFM410gURNpwFxm9ujjPryGStiabf5k86yseofmZPSeHTclBrHC/EF9JQNNB6WnePtpmjZiFbSaskzazfB/nK51mBa0ZHEY/eondFoV93tVno/Ftw7KdK0JVag2NqR1HAjoVxcsWSr5e4y7BpC97tGI8KpLvNjaNpMCrEwQDKJ46+WUZyjweTwxwElTsSdqyxsL7sKC6Ig6UiCR5XdrNh5T1wjMm3XBBrWOJu4Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDCCtFoesKY3P84t12vQMmmKEQVIcbXFA0MnVTXz0/8=;
 b=d9zpHjMHhcq38LF7/78RQstUCxAcgQL/PHxdVqGDIBxopyywAyo4tm3VCtnDqPr+udmcWCKiGqHw51eZkihRLumyOj8KxQuQECq0gFb6Vgr7LEt+O2VQW6qqet5B/3ugwAcVRSFZgsztZlVOYfRy0Om/ObG+JNphO6GZh3dLVU1/SvIj09LlU+euOoUbk/gaZYlHvl5jkCA7Zb2j7rTodIk8jP4pRufYc9HpzDEIE04TiZfRAWLdsPiltMEaVG0x3Z+uvZZtz+JGxifNTmfPF8jWNhm5SLjvsfJgEMfMiJoHHAylusPZCyD5IvWgU83rqqkjsoYgchWNNqiPZ7pW+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by PAXPR04MB9374.eurprd04.prod.outlook.com
 (2603:10a6:102:2b4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Mon, 2 May
 2022 10:30:42 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 10:30:42 +0000
Message-ID: <830f3a9f-bd76-4c1c-6f3c-8193fbe19bb6@suse.com>
Date:   Mon, 2 May 2022 12:30:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] usb: cdc-wdm: fix reading stuck on device close
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20220501175828.8185-1-ryazanov.s.a@gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220501175828.8185-1-ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR1001CA0035.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:2::48) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9402458-517b-4c19-45ef-08da2c26cee1
X-MS-TrafficTypeDiagnostic: PAXPR04MB9374:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <PAXPR04MB93745117FC250A6B91BE5197C7C19@PAXPR04MB9374.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jb32okD//I6SEBfI9qhh0U05cy78C96np2beALSXXXKHdfrmIUH6sqh4nlb5aeZyiy/9TNGt0DHPdEmmMQfddhY7J/EdGBP8r7hliP8d6ofAOEW3DgbG0gP/hBxJEZcyHL30QOVTkTMon3vePinx0h0vE3Ob9Zk4npZtsTcoJvkgk1gUPBx5l5wu8HPY3neCCBn7UwkoS7MAgwkbH7y1ZvP4D+IfMQ8RN8P4AXj+wDpgZU83DvVCMA34xr7sb5qb8/Z35K+8+2ipvKobf2cslu+7zkXW3zEr+W9KxpHlBqLIm4kcS+xTwkfTuzmroH6KwO7UxrrIY7LsEG58N7jnkUy0sRSL0gaVr3gtUR1zXQvTFBxrEuWiRLgMOsfmnWOanTjWm+tVyBMVBcVyAhoS5XeYKlDZZklDg9eU1e/9NkrqkM97bDXEXXgAHfmUGRnOLp25phAlG9gMWqxJRxuYmlnZ9F3j4eJ03c9JQN0s9kVKKreA61Sf4eC2FQqxz2M4gC3mq5vJ2mUZVnpbtrYgxZpVVssyKLluZuHULeLw34SorynEuWJSLqe43hk8DHn1prLmdt/I7XkyFAGnwzrMThYnDZjjBGatCzR4UV4vXk5GnzYFqBFu5JfdGwkPqYyrFXrMYkuudkeI0FPg3GkSniqXzs0UP+k2e6SoG31L4NKaV00CGf4CexhWAtZ/m4Hfq8fgxDmZwAhmhMVhHHm7H8VJJcWQxd8z2vHMhObcYWQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(8936002)(38100700002)(508600001)(6486002)(31696002)(86362001)(6666004)(53546011)(6506007)(6512007)(110136005)(2906002)(36756003)(66574015)(66476007)(66556008)(8676002)(31686004)(66946007)(4326008)(186003)(2616005)(83380400001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnVYUG5TZS9LRHdob214QWNScE5ZU0s1T0Z1N1lVdzNkRmU4N1gyKzdaenEz?=
 =?utf-8?B?cjB0TjdGc0pUa0pqQldOWGJjL3BaSjFqdlU2eVlxd0JTc2Q4Y25pOWhURVN5?=
 =?utf-8?B?ajJIYm5IRlVmVnY0ZEU3aUg2cTcwUyswT3ovS0xiWXh6ZkZZYUNzZ0x1eXlR?=
 =?utf-8?B?cGl0SURaOVBkVjNJYXdpTk5RcVYvczhjb2FIem90UW1ra2NSakZTa1JYdmhq?=
 =?utf-8?B?RTlrQUw1UDJ6VWd6bjh1a25FcSsxclF5RUF3N3VBTmNnVG9qTWV0UTJWVUF3?=
 =?utf-8?B?R3BDTWZQbXppZ3BUdzFzajNRRkVFaHBSYldReDVpUzNIOU9RbXlGUWdVNy8x?=
 =?utf-8?B?aW1Va2Z4dHRZaktUZTVnVGJwb3NHT2M0T0VHbVdkaEJMa3pNTTdwK05obWt5?=
 =?utf-8?B?T0tCM0lVbEFvZHlsZzhNeWJyelVHRE9MeU5WeTNXdkwzQldzMmtQK25Rd3ow?=
 =?utf-8?B?VVpHOFhERFpMU1F1MlNGR0hGdm8xL1NxdmF2NkdQSkpFQUIxUUVtdWpGZnZp?=
 =?utf-8?B?WVQyWC9xNTRDNk5IRkY0L2dub29Pc00rYmZrZG1lb2g1VDBPSlpqZWpyREps?=
 =?utf-8?B?TVJnQ0o3SmdDN2hnOFR6TW0wVHFLK0JNbHdVMUZoVmtrb0VVeHoxZjBidXhp?=
 =?utf-8?B?SFRSbHZWYVMycjdPd2pDOWxsMC9ha2NReWRWd2huUWJ2Mzd1dklvU0c4Nmw5?=
 =?utf-8?B?VTlydHk0bHhOdlc1QkVTZGtYUVlRc1c3VzhjU2h0QXNoRVBGWGRkRGJGM2Rz?=
 =?utf-8?B?RXB4YytKN0FIbkEzblJ1N2hHMjBHUElxdkY0ejNHUURCZEN2T0dXVDNFRk4v?=
 =?utf-8?B?YVRkMkFsVFpHYVZJa2xRWDZwQi9jZTBtbSs2ZkNYaGgwRUgrejZHTjJYL3pt?=
 =?utf-8?B?V3BGbGszVkppSjVnVDI2SGpnQWpXYjc5V1J0Q1JYK1FiaFY0bFFSMGNlMnA5?=
 =?utf-8?B?am1DQ3dFSUU4RzRjZ1YrWHlOT21FWWk0SUR5NDBUcGV3amRFVnlNUExtd2RG?=
 =?utf-8?B?blhidmhsblhKN2lFOERkVkNqdDgwcjVlV2xLSmlCNndnb3RlMzZGQkdCdnRW?=
 =?utf-8?B?c1NObDN1ckx5b2RUOUFqWGlIN1FsaVJ0M3kyY0dqcDJuN3AvR2dFUlplSG1K?=
 =?utf-8?B?dWhNRkpuUzVjYzJ0NDY4RjlxTzdVaEhtS0hpS2dZeUlGVWV0c3ZsY01xNGNz?=
 =?utf-8?B?ajdNN0o4N080TkRoSnNTZCtjcC9hNlJjaFRJVE9rWGwvOWRQci9iL2p1T2lW?=
 =?utf-8?B?RXg0K2kwNEcxbG1FOThHZzViN2ZHNkVXQ1dTcVdPZE4xQm1XaGxpalhHNXBp?=
 =?utf-8?B?RFNLanhmMC9ZTUhVczgraklXdGc5KzFhcUpzaG5LYzhvai9hR3hTaVhmQSsw?=
 =?utf-8?B?Z05GT0RDNmFyYjhkWmRJcUxlT0NidUJpdmNHSTBzTS9CWTR4MnAzWWZrbWJZ?=
 =?utf-8?B?L1RSWWx3Rml2UDNWaFlnV1ZHV291QzQzbmNSbGdDcVFaNFB0dFNmTUN2WHJP?=
 =?utf-8?B?c3ZtZzk1K2l4STdTWjRnNXNWbzFGdEJ2NnMrclppU0pzeU5tZTF0U2ljQmQ2?=
 =?utf-8?B?cEh1VERxcGJ5eHNkeGVXd3JoenRYK0dpTFVFckFOSWRENHVGZXZheTlqVUQv?=
 =?utf-8?B?U29BVjBKQWFzYjhGNTY0ckRtSVhvMTJidDVEU0hadzJmclZwWmd1M3huZm9u?=
 =?utf-8?B?VmZUdE1adU9TcEhaWlp1MitTcVBLQncrTFNNMDRmVHEvYjRvTGlYK25BUTFW?=
 =?utf-8?B?U2YvZ2d6cjJkUXl4eThvU3JtOXB5TGdTYWRlRk9MTEp6bUxHRnBaODRuOXBV?=
 =?utf-8?B?OEVJUWZVZTlVMStFa1J0V2F4THBPeCtVVnIwR2NxQk83bnU4d1Y0SzVlOGFI?=
 =?utf-8?B?Q20xWlhqSVd6Q2ZCSDRlZTkxTHoxdlRIWGtqaVdQbVBhalNsb0RnZTRlVXZV?=
 =?utf-8?B?WFRoM0J5U0hZdHMxaTRXZ01XamxZMzJSY0NjTXFza0k4RjYyVFpWOU55dEJ0?=
 =?utf-8?B?QkkycVd3bjV2YXpjWkl2R2FwY2RPY2lURWJHUXEvVHh5aFZvbkFsTnhRcW44?=
 =?utf-8?B?SVJHTmxWTnV0RmxTZS9JNUhSSHZpV0VpOUU3SFNJZzJzM0lYU2Nyb2wxQkFv?=
 =?utf-8?B?WDdMNFNiZGpsZGtlUUxCYzQ3L2FRaDhHUE9sVS8wRUpsVkxETi9sTXVxOFlo?=
 =?utf-8?B?VlFjYlZNMVB4NFUxRU5rdWxSY0lRQk5IYXd1aWF3cjJ1WkR6SmpvUGJoMnk3?=
 =?utf-8?B?T1RRbkxFRHV5ajdzeGc3Y2NFSzBRUVNrSWFONldzTXZsWVVXMjI4Njk3cXd3?=
 =?utf-8?B?TWFENHpTdHk4YkZVN3FkZHBmc1Q5T2VtUzdGdkM3NnR6dnZiSkVtc1ZCcWg3?=
 =?utf-8?Q?JQcLkBW0XZ1ZgHb0IF25n9Fi76TlR3DQZtSSWLL9F4JwT?=
X-MS-Exchange-AntiSpam-MessageData-1: HLERR2n488K06Q==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9402458-517b-4c19-45ef-08da2c26cee1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 10:30:41.9470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwefKor6iGq1ELMTCzmbX1EnNFPUT9ovw2hIiB6A8Vz0/FicTiCdCB3jXcGfxX3xALbIKglz1PkR6ZX9kdWjVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9374
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01.05.22 19:58, Sergey Ryazanov wrote:
> cdc-wdm tracks whether a response reading request is in-progress and
> blocks the next request from being sent until the previous request is
> completed. As soon as last user closes the cdc-wdm device file, the
> driver cancels any ongoing requests, resets the pending response
> counter, but leaves the response reading in-progress flag
> (WDM_RESPONDING) untouched.
>
> So if the user closes the device file during the response receive
> request is being performed, no more data will be obtained from the
> modem. The request will be cancelled, effectively preventing the
> WDM_RESPONDING flag from being reseted. Keeping the flag set will
> prevent a new response receive request from being sent, permanently
> blocking the read path. The read path will staying blocked until the
> module will be reloaded or till the modem will be re-attached.
>
> This stuck has been observed with a Huawei E3372 modem attached to an
> OpenWrt router and using the comgt utility to set up a network
> connection.
>
> Fix this issue by clearing the WDM_RESPONDING flag on the device file
> close.
>
> Without this fix, the device reading stuck can be easily reproduced in a
> few connection establishing attempts. With this fix, a load test for
> modem connection re-establishing worked for several hours without any
> issues.
>
> Fixes: 922a5eadd5a3 ("usb: cdc-wdm: Fix race between autosuspend and
> reading from the device")
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>
Acked-by: Oliver Neukum <oneukum@suse.com>

