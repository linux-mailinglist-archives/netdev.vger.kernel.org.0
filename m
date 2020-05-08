Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5541CAD5C
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgEHNBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:01:09 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:20366
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730140AbgEHNBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 09:01:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4GbWXOysemfzSt3asIfq2pp2f/j9Uppw6aqSu0yzpzeWH/RC1JKqdk95D+3MDdDEUA0kCO9VahkeFEibU9kCcysgh37znyD4n1YCZWPU9FARa2e7GtgUibsuQahyd45WaYzzfmrWEJnHxFuYJloeMOtwN8+AnotMbKMQ7ghllMnwUkqeEzuZYKcV/eTPde+io7OrROdzd/nCPZIeq0zpZ/mWiNybPIL7FV/0MTCdLQOWa2LPnMXdHJo8g7J2OXGzHAOGC2m/F4MmajQgzEGVkcn0jXA8LSNrYu+R88pkeGzwiy4uiInRCRf1c3cq2sXAlwQ/U1akWnjBtvI6G43yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJz+cE+tegfyRGjvbagmbvmB7km8HeQK8umYOKJRa0c=;
 b=LEUNmBYxg7uC01HoHVnahl9mLnEnUd6BuU4GBrcLo+cuBxeRNpQuylrjKpy8W+A3/DwCBdyvNc3Ndh9c6xRMVGQp8qG9xulWtWWpjvG1fMpGCLJt2JR4Vw7n+pDEz5JfRLRTJIRYNMl+C14xOtYrgA/3hcfP5zJ4PdUVqa6tjy2IrdOYSbL2iAtghlCQDi/xMCbqIk2I8vAIiDAm5NSpv3Tqn0PauQa+Qjm0Mx7i4+dxznXLVJ0V5/B4yUbOXsBPRxC10JUk4/SQ18rRMJdEu3dV1tny400BBoAdIuGxxkrv2td2eOB8V7bMQGSuHjZQXuW5qLQcIQtwug+oExAe0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJz+cE+tegfyRGjvbagmbvmB7km8HeQK8umYOKJRa0c=;
 b=VX8t7gO6KW+XmZ88d/zsJ4qDLMhC+0DBApoa5nhNJUh0sWWuuO+PN7aTQT7U+KKKQaicAAxrxc+gUStRDSk+t2vRz6AqRvOGKqe/DiQRA0/2Bmolizq4OBnnJbflLT5vmAwesPs9OvRFfJq9KxKi/ZaX/cqbfiU2N0Ub5BXilJ4=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6632.eurprd05.prod.outlook.com (2603:10a6:20b:136::12)
 by AM7PR05MB6775.eurprd05.prod.outlook.com (2603:10a6:20b:142::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Fri, 8 May
 2020 13:00:59 +0000
Received: from AM7PR05MB6632.eurprd05.prod.outlook.com
 ([fe80::94da:ac7a:611:781f]) by AM7PR05MB6632.eurprd05.prod.outlook.com
 ([fe80::94da:ac7a:611:781f%9]) with mapi id 15.20.2958.030; Fri, 8 May 2020
 13:00:59 +0000
Subject: Re: [PATCH bpf-next 10/14] mlx5, xsk: migrate to new
 MEM_TYPE_XSK_BUFF_POOL
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
 <20200507104252.544114-11-bjorn.topel@gmail.com>
 <40eb57c7-9c47-87dc-bda9-5a1729352c43@mellanox.com>
 <3c42954a-8bb3-85b1-8740-a096b0a76a98@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <cf65cc80-f16a-5b76-5577-57c55e952a52@mellanox.com>
Date:   Fri, 8 May 2020 16:00:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <3c42954a-8bb3-85b1-8740-a096b0a76a98@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::43) To AM7PR05MB6632.eurprd05.prod.outlook.com
 (2603:10a6:20b:136::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by AM6P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Fri, 8 May 2020 13:00:58 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9864655b-a7c6-4726-34b0-08d7f34fda93
X-MS-TrafficTypeDiagnostic: AM7PR05MB6775:
X-Microsoft-Antispam-PRVS: <AM7PR05MB6775A3C37F028FC1F492CEBDD1A20@AM7PR05MB6775.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qnyAJy6jGYVpX/YyokH9PFPMoZBk9Et2VfPeZQBlKhaa/rPxQQyIWarVL1A8mLVidZimh9JjYHX43A8Jh938hRndHk9PnqIPsm0UW3vYszlYC+/gWBJYrAmt4N+TZVjgGHrUx3bJ84x+7Ovmvk4c8pK3vz/c6LOBN9YZgP9ihMrQirR8XqmdZ2MW+6V19rg7A3gLNlmC7ioFqsW9Fbb4EnuGrliMmDMBxwyaJrF8iVh9N5acGh34X06fIKGNud436nzZKjaL6twMDV2xPpNmlkjJSLVBCGNeqM/np0KM5A0IEvTchQofHLi7+lQSF9aFmQc7z4xpVYydvMEgZP9dri25937a5K9mpPxxYREJKidMzmDRUZhFT4Fjd1dggzsTgVLeciBY3bFt8Az+IiSEy4saXeNN0eH+QNObtGYbdcyQJRHyPtuz/hHYz9pTFpI7SZFxPy8vzKjbafPtsJyoWFLx4CRAp9x4YwvQ6oyKWPySvJfp7m/z+FzXI6L8IyV0vUX9nB0Iyxc7PCI00s2U040YIIplTfuzYEFEg2fVTL1y8rwsCxetWj6N8ERsgJsm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6632.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(33430700001)(66946007)(66556008)(36756003)(66476007)(110136005)(31696002)(52116002)(7416002)(6666004)(956004)(2616005)(16526019)(316002)(26005)(16576012)(83300400001)(6486002)(83310400001)(4326008)(83280400001)(83320400001)(83290400001)(31686004)(53546011)(8676002)(8936002)(2906002)(86362001)(5660300002)(55236004)(186003)(478600001)(33440700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HPsNEFLPQOAUYkDvJahEF3lrVBvCrRVyfxdJAAjpHHhKHJpK+dH/X82m6sVSajlo9hGApShc3RQz9ewd7eyEksufV+ylaiX2/J/PpwDiAnqXGc1DFMi0ODe3zWYIkE+xWvuFH6vRKLUp+ihwZSFQ1dhtp91NPBa8LzUFqWuR3ZGEi3/Bz8rDJoXaM2jxEc9dfwF2n8wNwm6hd7L3/fTFOqUcLwu2vfeyZdAWAqty3Hh9qOkoNWNIFy1WLvij7s+9fh5PXaObGlD463Tm/FV9Rrzu0uaxfIDxNkyxAjEvLPAl/Mbtn6Ngr9udNu0VUKCmlJpta/eDfsiTe//NfomLEmzUMImZDzbjg8Pc1Y1z9IlZ4Z1SRH4JX8o3oy5gBMV9zBZ9sE1zC9vslE3BCM5q7tGyIRBTYeXkQc17GOb+VujzofznDrEQBMyJxNvCpSGEBHFuMUUV+KFbRSMZ5v+bnHOCuIQyyAh2aIUzaC9H77LqeLZEJlVlsLKjfyhUoPM9
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9864655b-a7c6-4726-34b0-08d7f34fda93
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 13:00:59.2455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: meVOw9Vzp8kk1H5RKlA0q2j1sQQjguLry+nQcQzA3n6VT0TOTCi+2lz2pLbP9wXgm2wEkbZwduwZu7vKHHjswg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6775
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-08 15:27, Björn Töpel wrote:
> On 2020-05-08 13:55, Maxim Mikityanskiy wrote:
>> On 2020-05-07 13:42, Björn Töpel wrote:
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> Use the new MEM_TYPE_XSK_BUFF_POOL API in lieu of MEM_TYPE_ZERO_COPY in
>>> mlx5e. It allows to drop a lot of code from the driver (which is now
>>> common in AF_XDP core and was related to XSK RX frame allocation, DMA
>>> mapping, etc.) and slightly improve performance.
>>>
>>> rfc->v1: Put back the sanity check for XSK params, use XSK API to get
>>>           the total headroom size. (Maxim)
>>>
>>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>>
>> I did some functional and performance tests.
>>
>> Unfortunately, something is wrong with the traffic: I get zeros in 
>> XDP_TX, XDP_PASS and XSK instead of packet data. I set DEBUG_HEXDUMP 
>> in xdpsock, and it shows the packets of the correct length, but all 
>> bytes are 0 after these patches. It might be wrong xdp_buff pointers, 
>> however, I still have to investigate it. Björn, does it also affect 
>> Intel drivers, or is it Mellanox-specific?
>>
> 
> Are you getting zeros for TX, PASS *and* in xdpsock (REDIRECT:ed 
> packets), or just TX and PASS?

Yes, in all modes: XDP_TX, XDP_PASS and XDP_REDIRECT to XSK (xdpsock).

> No, I get correct packet data for AF_XDP zero-copy XDP_REDIRECT,
> XDP_PASS, and XDP_TX for Intel.

Hmm, weird - with the new API I expected the same behavior on all 
drivers. Thanks for the information, I'll know that I need to look in 
mlx5 code to find the issue.

>> For performance, I got +1.0..+1.2 Mpps on RX. TX performance got 
>> better after Björn inlined the relevant UMEM functions, however, there 
>> is still a slight decrease compared to the old code. I'll try to find 
>> the possible reason, but the good thing is that it's not significant 
>> anymore.
>>
> 
> Ok, so for Rx mlx5 it's the same as for i40e. Good! :-)
> 
> How much decrease on Tx?

~0.8 Mpps (was 3.1 before you inlined the functions).

> 
> Björn

