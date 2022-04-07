Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D604D4F7D42
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244543AbiDGKvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235831AbiDGKvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:51:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118771E68CF;
        Thu,  7 Apr 2022 03:49:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8rh29d4rupw7BrY1juOWs0quxUUTmDN0vHPOBnhWSzi8Zqjtr0nQBo7dAJUYiiZRUT2yy16lrrXk+U3o1tN6QTf+9ZNOkyEc3Tz+CoAd/vqfMoHs7999S0DGWItHoc3P9TB/spCwHfdor9BmBfUgEyPSkYskYwiKwZ9CZaxy7kLx+6gg62HyyxBwq+KB+4kN5du/VO6gy8YoGv+3BLAKEjTC3+wuyztYkZbcLhmv22bw/47hHG3sedqzAB4aiQzWYbwq0gQxX4sHygAXkBiB44OCtEU6e1WDoCcH4+W14nH5NwCmYZ8Pekcy7F/e5BasIpN29bXCrzPPApPzG4Kzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HMRqyhTGKTN3kelDZXyYldqS93RRmXlW7Eamy1Jg4qM=;
 b=ER1WGksCcDAXZ9BGoiTYtgRT2LO1cja9V8O2tymp/jd5XreWl3yEuy8IlKIyhCkeXM3+NU3ytFNBhlaDNw81O1k10SMqxNKtsWaTmzmk9mwnHZ87h3cyHt1nxEB8+6Fvl3vAUgtgs5fI83YAtVOlvRCUiSrvjzzf3LFzQVIsSFjQQAZn+E1DGyxGVQf7ChP/TDFCA8gl8tSAaQVDXlcrIsabKSlOtMgZRtzSACB2lzgwzBLZYbmTeEfFuBElY0yxaSVFtCwYA64OSPZYgcTwYeXlBVzT5XFzr8N1jvgbEwU2M5pJFCwYLEgp+gkF+CMT3h60ENmtqQlEOe8o9yyazA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMRqyhTGKTN3kelDZXyYldqS93RRmXlW7Eamy1Jg4qM=;
 b=sr31H6vS4sRlxLlMq9a2Lyu7qQ+Q2rmv5VIpTRb/oUQ5b9P1dnTlyKXIkLLqzL+zH2Z5j7sadp1Ew4XG5d6Tq5slOCDK042YalHV7F31ModqIKnKdQDnze+HBl+O4y8JZMPsdA9Go6CHqdFbSekpdVtdM7rKq9iYvTlBF65QyazrXJl2z4lc8yaEnNgasMwJbJIwe6WE0iNPx5HShyhDeLgHTca4kXoYpar50DW6jFnJVqbPj5HdGtEuXW/wg2n1EuQkflPl6OoHUsP76pu5FAmy3XsTzm2YW6SxljfNLnKTo38wTLmGOYMm+7G6+MVSi4LnxuJI5izanTnbrlxNrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MN2PR12MB4455.namprd12.prod.outlook.com (2603:10b6:208:265::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 10:49:13 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 10:49:13 +0000
Message-ID: <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com>
Date:   Thu, 7 Apr 2022 13:49:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK
 Rx queue
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        alexandr.lobakin@intel.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0417.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::8) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71fcc59a-a94e-4e32-c6fc-08da188440e3
X-MS-TrafficTypeDiagnostic: MN2PR12MB4455:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4455365C11151102EBAA254EDCE69@MN2PR12MB4455.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4AtWFRPG0whrdP5f80i2SRC/rrw73DIKjHtAzJbDm3aVX4eodRbI5+rlzg7oSZub4p4O8y2NoX8Z2FskjwcZCLdtDLS4hgtclA9+8EXJGZjXD7jHPupc+kkFZapfLxAdvj+fYAjD93jjBz5FT9DWKY5e9PZtxpAZ5t5z/nMHQR+JnTrnvEXzkyPNpHT82AbyiWVo1Dy50ojBMkdiMIW7rZqzBI0jnD/Hnft8WQem+Tve64Lka8c91hKMFNtL0f8+PXbJLwIrYLhP5/eTi5SZoZUT5VljsL+zTGwyHHTPIbajEIyXN0sgLlHZI4KjEZFHrHbsfKQmZfR+IpayH7vxgFC8omVjjCYenyXfbmeSRoB3IJk9SswlDD+8Bpuga7CXk/XpGCWoTCYQP/Q68Zpd8ykNByFEGkgycP1cXUWkcb1IcRrI+kG6nC8vOVKbw8lDK/Z2nre9eRxvFrgk2YUmElvicGcM9bOVXb9roC7aUpq414bEX8Dr7jcGdaX8SxCGxWDjEZTYqk5ZBERxr12JIw0gHnSEPz6+VQWm+bOMlH63zxAgN30vBCfiQobOyQMq2T5h6x2kpakSwz6QMQdEYy8u+vcRH4KslPi+TaeOdbnw8wgYFtCxha/ftoUSQiW3qGSvuGkRjM7VZM3fDRFR481JqzwRi7jwO/kloxCYC03CiH1skv4Gqhss/XpEhqIoZC7bfZiV8+va/M0RXZAuqWs/1IItqnHu5YX8bxUDS97D+UscBUoNVQiWNkweNBc2jOFFvvkuz2JdpPBkWH2R4UbgMI+mZpPtHLGIZGP2A0gCczzpB5ijOJGhkkUKE6jjlPSLbTyiD5vRBGvtIBPQMrm83D0NIyV8tVJ5Y3nlD1g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(31696002)(86362001)(66946007)(54906003)(66476007)(66556008)(4326008)(36756003)(316002)(5660300002)(2906002)(8936002)(6506007)(6512007)(6666004)(186003)(26005)(66574015)(2616005)(8676002)(31686004)(107886003)(53546011)(966005)(6486002)(83380400001)(45080400002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S09sZm1ERmRSZEJ1bkRvNFNqUWVEa3RFbWZUVHVXTGE4Z1h2cHd1T1hWOVoz?=
 =?utf-8?B?allJdTBpVnRFYzFZTzFyNHhDSjlnQ0xkZnBId1pianZRblB0cUtGamxLYU1R?=
 =?utf-8?B?TGhUTzhGOW9xK2xlMndhL1hDOG8wSDBwL0syeTU3elEwMHFBNkgreFE0K3dL?=
 =?utf-8?B?YytjM0FuSXpsZS9kUmFhRTBvbmVzL1FiekdrQnpQYmExdE9vRU02YXdPaUU3?=
 =?utf-8?B?TjJyTm9ZTDloTkNvV3l4ZlphOGJlb3BNVEZRWUNBeHFma2FCSXo2UHk2bkQx?=
 =?utf-8?B?UzRMLzBxUmxTQzRWcnluSEdPSXIyVkd3TXJUR1FiWTJuUGtXZ21YQnp2T1Nk?=
 =?utf-8?B?WUJJRlB1azFtNGF2WWswdlZ2OWN0QnBOZ0RaNDJCSVNldzhKcnV1b0lwNjYz?=
 =?utf-8?B?K2ZkamJkVnBoZHNSNGR6ZWo4ZldBb2NnbHpZOWp2aWhQNk1EZFNqbWpLMUN1?=
 =?utf-8?B?b2Fxd2d0Sis5ZnQ0SWZUb05sUFc4Sm1iL0ZUUFhheHlhbzhra2xyMWhCWmpq?=
 =?utf-8?B?RjBtUG5vWW10M0hhQ2tocjdQelBMMnE5MEF3RHFtd1ptckJTQ29LMitwWHZH?=
 =?utf-8?B?bEVYWk83L2dqeXVUdk5xczBkbW1FcjRkVjUxbFREQlpvUVlocDhqYUYxZWpw?=
 =?utf-8?B?SlpxQ0Z0Skx2UnNWclZ2eTRja1lZT09ZN3lzV05EazhjeHZRWEZydnlzYnpr?=
 =?utf-8?B?L29qUldRa3cxU3QwUTFDcVFqcjZqbjJZcXhCaG9CdVQva0dVR3JpSWw4Z21Q?=
 =?utf-8?B?U2pWYVRJVE4yejZPb2ZDSVlhbFRwQzZDK015SVVzbVEzbVpIUE4yVVRwUlB1?=
 =?utf-8?B?RFV4RUZOM0RscWNrbFhaa1h0ZzBFYXFHSytRSlllTnFpZi9wN0lHTEZXUUF1?=
 =?utf-8?B?UlpGa04vSUJxclhEcW5xWkdmM3hOWHlGVlhSbzdleDJNZncvRXlZU1JhRlJ5?=
 =?utf-8?B?QzR1Yk45aEs2UDZXZVdZZjNvTmJjOWEzcDRPdXM1THhpZExlbGVpamsyc2tI?=
 =?utf-8?B?MjFWV3dVRXdOOVB0WG52QjZ1R0NHSm95NENaWmczZUdSN24yNCtkVjFrZUph?=
 =?utf-8?B?ejhQbnI2MDlwdXZyd0l1VkEwMm5ubFNZRkF6a2ZLWkdmMkZBS3prc1gwZTVh?=
 =?utf-8?B?RW5uWGhHWGZsT0lmZGgySTZyOE91ZUdaTTZ2ZVd0dXYreHdWUTNHekhoRmlM?=
 =?utf-8?B?ODBmZmFld2lzanowRldxK2FDL2R3ZUNEREd1QXRZdnFMT2FkK013WVhQOUhv?=
 =?utf-8?B?ZU84Tk94eGxGODJaeVFCTHlETUxNcTlFdUovN3FtcDA1M1dZei9ZUW9BdzJY?=
 =?utf-8?B?bWg0cy90Y1M0STkzNlp6Y0p6UW5PN0Z5QkMzQjNaemE3bWJGdERnWEp3V05F?=
 =?utf-8?B?LzNseHdjU3NjT1UvRFZKaElBcWJKemFuM1kzbjVpN2o0V2RYdFhqbmlwVEVB?=
 =?utf-8?B?bUZIMkFMcjhTL0VCcXNPQmRxMUlUdXJjMWxHWUpnZDRxeURjNWNjNldrRG5t?=
 =?utf-8?B?K0NZNlJnOTIvUFlkMWVRbDFUSEpLMWxNZGc2NWZnaHliVE1MUDkreXJhc05O?=
 =?utf-8?B?YkFvU0tsWnk4SkJnOG5zM3FxaGxORmJZb1AzeVF2ekhKMFBORDhZYU95T2pn?=
 =?utf-8?B?ZDVJVW1KMENrTHhJbmJRclp1SngzM3VGdzZOL0F5ZTBIa0FGM1FjaFNaUXVa?=
 =?utf-8?B?aHdKQzd2bThGaTVudU81RjlIL1dyVXVJZjhMT3JFTy9SQms4NTdiYjc1R2pN?=
 =?utf-8?B?UTNTUGtxS0toUndWSm9tcmZZbVNSb3FCZVdZVE9nL05iMW1XTDQydklLM2Ny?=
 =?utf-8?B?aVg1SlRWNUYwdDRJdXpRN3JIVkx2ak02SE1WM250N3RwRS9mcDBMa3I1R08z?=
 =?utf-8?B?SHlCOWw3eTlram5qaUZlUCtOUTM1alBDVkxxSVhLQTJPYitrWkppOTM3Qmd2?=
 =?utf-8?B?MW1UbnJPN2ZMQTd6dnpSRTl4dGRUeDdvZGpXM1dwYkRtUCttUmVBQTdmMGlj?=
 =?utf-8?B?azVFaUJiSENIU3I5azBoU2FXWWNYVWhYUHZ1c2IwbUJUN0tBZjV3b0JaMW40?=
 =?utf-8?B?Q3lNQTY5azJUbThHRVFtRkZXWndSM3dmeGwwM2t4aWFBUW1UQ1RsbndSNEZF?=
 =?utf-8?B?UUpnUFpHdjhaTWJFYzU0T0JyN0NvTDN6SGRBWUpNdlJkVEp3WFkyakd0c3dh?=
 =?utf-8?B?MnlVb3V4UDBmaXpXczdETWZ5cjJldXRvQ1RwTHlTcjdKcEhtZmFIa3lCRm9i?=
 =?utf-8?B?Tk9QKzFGTzFhRWJBWVV5OEhVSy8zN3ZwQmtPeFZNRTl2Wk9yenQrdzBmbFZa?=
 =?utf-8?B?MWlpdFp4MTBMdTAzeDk1aXJYVUcxNldaT1YvbTRLamlIempxYUs1UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fcc59a-a94e-4e32-c6fc-08da188440e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 10:49:13.1952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nx8LVIp2OCK1ug2gnjVzKwNCBbf2yI3b69Qc68fZbLKZsb2Q+7bJP29GugPsE6Em70EVTPYAVfHK6LQIJJiQAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4455
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-05 14:06, Maciej Fijalkowski wrote:
> Hi!
> 
> This is a revival of Bjorn's idea [0] to break NAPI loop when XSK Rx
> queue gets full which in turn makes it impossible to keep on
> successfully producing descriptors to XSK Rx ring. By breaking out of
> the driver side immediately we will give the user space opportunity for
> consuming descriptors from XSK Rx ring and therefore provide room in the
> ring so that HW Rx -> XSK Rx redirection can be done.
> 
> Maxim asked and Jesper agreed on simplifying Bjorn's original API used
> for detecting the event of interest, so let's just simply check for
> -ENOBUFS within Intel's ZC drivers after an attempt to redirect a buffer
> to XSK Rx. No real need for redirect API extension.

I believe some of the other comments under the old series [0] might be 
still relevant:

1. need_wakeup behavior. If need_wakeup is disabled, the expected 
behavior is busy-looping in NAPI, you shouldn't break out early, as the 
application does not restart NAPI, and the driver restarts it itself, 
leading to a less efficient loop. If need_wakeup is enabled, it should 
be set on ENOBUFS - I believe this is the case here, right?

2. 50/50 AF_XDP and XDP_TX mix usecase. By breaking out early, you 
prevent further packets from being XDP_TXed, leading to unnecessary 
latency increase. The new feature should be opt-in, otherwise such 
usecases suffer.

3. When the driver receives ENOBUFS, it has to drop the packet before 
returning to the application. It would be better experience if your 
feature saved all N packets from being dropped, not just N-1.

4. A slow or malicious AF_XDP application may easily cause an overflow 
of the hardware receive ring. Your feature introduces a mechanism to 
pause the driver while the congestion is on the application side, but no 
symmetric mechanism to pause the application when the driver is close to 
an overflow. I don't know the behavior of Intel NICs on overflow, but in 
our NICs it's considered a critical error, that is followed by a 
recovery procedure, so it's not something that should happen under 
normal workloads.

> One might ask why it is still relevant even after having proper busy
> poll support in place - here is the justification.
> 
> For xdpsock that was:
> - run for l2fwd scenario,
> - app/driver processing took place on the same core in busy poll
>    with 2048 budget,
> - HW ring sizes Tx 256, Rx 2048,
> 
> this work improved throughput by 78% and reduced Rx queue full statistic
> bump by 99%.
> 
> For testing ice, make sure that you have [1] present on your side.
> 
> This set, besides the work described above, also carries also
> improvements around return codes in various XSK paths and lastly a minor
> optimization for xskq_cons_has_entries(), a helper that might be used
> when XSK Rx batching would make it to the kernel.

Regarding error codes, I would like them to be consistent across all 
drivers, otherwise all the debuggability improvements are not useful 
enough. Your series only changed Intel drivers. Here also applies the 
backward compatibility concern: the same error codes than were in use 
have been repurposed, which may confuse some of existing applications.

> Thanks!
> MF
> 
> [0]: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fbpf%2F20200904135332.60259-1-bjorn.topel%40gmail.com%2F&amp;data=04%7C01%7Cmaximmi%40nvidia.com%7Cc9cefaa3a1cd465ccdb908da16f45eaf%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637847536077594100%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=sLpTcgboo9YU55wtUtaY1%2F%2FbeiYxeWP5ubk%2FQ6X8vB8%3D&amp;reserved=0
> [1]: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fnetdev%2F20220317175727.340251-1-maciej.fijalkowski%40intel.com%2F&amp;data=04%7C01%7Cmaximmi%40nvidia.com%7Cc9cefaa3a1cd465ccdb908da16f45eaf%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637847536077594100%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=OWXeZhc2Nouz%2FTMWBxvtTYbw%2FS8HWQfbfEqnVc5478k%3D&amp;reserved=0
> 
> Björn Töpel (1):
>    xsk: improve xdp_do_redirect() error codes
> 
> Maciej Fijalkowski (9):
>    xsk: diversify return codes in xsk_rcv_check()
>    ice: xsk: terminate NAPI when XSK Rx queue gets full
>    i40e: xsk: terminate NAPI when XSK Rx queue gets full
>    ixgbe: xsk: terminate NAPI when XSK Rx queue gets full
>    ice: xsk: diversify return values from xsk_wakeup call paths
>    i40e: xsk: diversify return values from xsk_wakeup call paths
>    ixgbe: xsk: diversify return values from xsk_wakeup call paths
>    ice: xsk: avoid refilling single Rx descriptors
>    xsk: drop ternary operator from xskq_cons_has_entries
> 
>   .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 27 +++++++++------
>   drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
>   drivers/net/ethernet/intel/ice/ice_xsk.c      | 34 ++++++++++++-------
>   .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 29 ++++++++++------
>   net/xdp/xsk.c                                 |  4 +--
>   net/xdp/xsk_queue.h                           |  4 +--
>   8 files changed, 64 insertions(+), 37 deletions(-)
> 

