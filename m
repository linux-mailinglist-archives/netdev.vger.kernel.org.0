Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7AB572FDC
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbiGMH7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiGMH7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:59:14 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2074.outbound.protection.outlook.com [40.107.21.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329F9E5842;
        Wed, 13 Jul 2022 00:59:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTBGE353DxjsJgC4ruYjqFdX9tzWrDCVhRDA0Ul5Eua1Xo5tD8rqcoLEMuFU6SsJyoDjop5xbPIp/vVcVt0+WgBvKYGPQwqKM0/gurW1Sn7qhLQKLXJq6PexbMa2c2F9H3CQ0Xo7+E8XMo2waxCfRgCeSi7tgN4xC+aevCusJWUWpEiIlboPp01iWQz5Iw3DArAz7wsFYLnoYfxGy+7K1kT+aJtYRJfTsbPetFUtSHc2e8ZNbPLo7i/LTjex1cTUV4rHc5PaM9kOg1KjDkuZpsmn2IKpm3HhOG+90yZA3oQnn0LFRkOAKHV67b8N5jypZdl6FBtvoyLlUN1nceHcYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLRAfDkq2S4VKeFcHHn+x8ndfKpQQsndJLbLjJfq3sI=;
 b=WGFd+QhYOSvcTjFs8LxPtsXg+aNkWMj/59obr7SfV2tOjgqGP32OjROaln48ldSLmNvd2uxGLrplLQjC9ZpGsKZ18/RhKaxoZL6KGPQUkhlxfZcECaywXQ2VDAYBiUhnzls+xTGdk3vWB728aVRuihFjxclVj0F1YY5ZA6234l/f9tdu0eR31k2iA3QTNV/dvSO7unGb3xeksoBC7IATtUgjeZz5S1nd2HbdTEznOMZnrNqoK1Lei74tVB5m4FfwsYEBnGhu2xh0jgXADQJwhALyH+9FqL2+snFqNjS8s/o9h2kDjDk7+ajnVcEf4HShY262+8cQweMsgkZINZT1yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLRAfDkq2S4VKeFcHHn+x8ndfKpQQsndJLbLjJfq3sI=;
 b=eKqDUiBI0G0HRyPZV30fevHT0Jke7ZPmNmVLQwUPfeydBtiyQgoS3o/KjCZWxv2uUkKb7pU+zJQBs1KBElwRfsHpGm7aIxOx8A/Cpw7x3nAQwWpuI2Ep4mlyvCPFmuQolx7OgjaIXvzPCgxxippDeRYnfdou3ZoPLEdLEk0VSYjSnZdA2h8fbk+zE+IgWpDe34kYOjX4S1dELJ+y7C30WttPLH3IoObkwt/AC20p9PteYvkuWFWCK7KFKMyPiwMTnj9q80kYExlaXO60a3xXB4QQlFAGYyqaj7kx3kPloEgx8fOvCuP+cVRwjXG2a7jz44Up81yD0Nx3qAS0UcvroA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DB3PR0402MB3660.eurprd04.prod.outlook.com (2603:10a6:8:c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 07:59:09 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 07:59:09 +0000
Message-ID: <0e2772a3-3c3c-b447-ecb5-e2750959b527@suse.com>
Date:   Wed, 13 Jul 2022 09:59:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] xen/netback: handle empty rx queue in
 xenvif_rx_next_skb()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220713074823.5679-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220713074823.5679-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR01CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::45) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4481ae8c-4e45-4ca1-3935-08da64a590e9
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3660:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mV/AP4gTHcsGLmFmUdoq3xK1FTtV5CmMXNksfrJ6XEiwnXsAGIC77pnr19MYw5UpHO1hbkXtrq+d+Zxn4j/yMOS474nRXr8/4Tt+u3R05pkTF5sILba1vI4PtI4zzcqtJYcUJ2nBgvye4QRLqgH6JeQxsDQabBmM/pACEs8or4ZA4M/t79uH8hHwyagKmzs4slg1idbgxSGWX2RwNtgz6DFU5H35WKJPE2El7b89pVNPOz/EWFmyLSP5GHfix3FR10e7tJFtpeCFBplVS30ozfnTe5ZVxm6hMb5mSt1yRGEMFT1v50aPgnmYHTvAdHV73IpoATGi4tGuBuc46O5AzO6ffq697l5eqWUUGLKoDdBIQEtZ3Z1BFhBkz5C7tcTpPNHZ6Sc0iaqrAUPHkRrYDmlUe2pm3zWzp8EL/ycrewijpa7YhtHmFBXy8YTyc6n/2K2bX9eNxAXj6W5ZsSqFt/cC428NdkyYO/o+e6VCay/Cri4kjzeQ8iRCRvJxjHuxu+slIgVZHI+P+FNsj+P3DgahKtTBsjKxnWgyRnm6wK7A4eOFvFKeU+aEzVguxXw2PLpORYNyo7KJCZSBVIpJCoHBiZYJYtsAQudJaOZUCsiv6kuvob/CBF4B18iPlnoODg0XtdZjvOTyH6JWBmtI9YF/vLsWiwjIbR1zeq220PjHiceTIHlHfXcamP30A3GsEcxDxcvcrtMJdcLIu4+EDrEV6lB4FwelNkjAxEfHXoUPbBdzQT8k1qPKcQpCJawTzVm+v7sojj2G1mETMdS/GvVOwV+XXZyW4jLfA4Lb5XE8NweHZcpIniNxB493rQK5wdXYEutBL4EghDE4plp2xAasryumX22mEJIXE/+LyOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(136003)(39860400002)(396003)(376002)(8936002)(2616005)(4326008)(54906003)(38100700002)(8676002)(86362001)(5660300002)(316002)(186003)(31696002)(66556008)(6862004)(6506007)(6636002)(66946007)(6666004)(37006003)(26005)(53546011)(6512007)(41300700001)(66476007)(6486002)(31686004)(2906002)(478600001)(83380400001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3R3d1ErRDVubWpwa1J0SWtOWGowVllwTHRvWm9hcTJ3cmQxVWVUWEZnZ09r?=
 =?utf-8?B?Zzl4Z3FjTTRqb1NFbVZqUHB0VTlNTXB2MWVNMTB6ZG5tS2NkQWRKUndMNEFk?=
 =?utf-8?B?QW9rSHZobXFuc09pS3RVM21KZFJpT3BUeFFuVEFwU0hpS1J4TkZRc1AzNmFH?=
 =?utf-8?B?OVdyRmJ3a1FTUklySC9Ca01TT1dZUzhpcVNuN2JGT3ZJWEtlYkp5SmpEZWJt?=
 =?utf-8?B?UjFqK0pnVHFnK2U3ZTlvRWRYVzVGeC9nZG13b2d3TXpGeVdLZlJTYTN3b1BK?=
 =?utf-8?B?VzcySkNVeVJ2blp6Tk9oRWtnZ0ZqZ0dzKzB2VGhVY2p3bWN4YVY5S1JBS0pJ?=
 =?utf-8?B?em5aenJUNWtPSEdhanZQQTAwRU8vcTFEMTRvMUlUSnlrOXhRMEoyWWs0L01Q?=
 =?utf-8?B?b3BoRmdZelVpNnAyKzE1T1BMNjRKK0dtUnNnS0FXRXNrUm42UVlYeFR6VTNm?=
 =?utf-8?B?RUhmOUJkcGFqakdPbVlCTHFWcGtjSVVHZkVPSWpGdWh1ZlJTWExhWkdScDdZ?=
 =?utf-8?B?eE1nWFo5ME1xY3lNQVJCOTJ5SEZLVEgvcWhWN2JmWklEUjdXK0M0Nkp1aHBV?=
 =?utf-8?B?ZnQ5RDFyRlRCNHVINmxkbHFERkFvQnVKeThwUjgzU005WGw0anh4MjhWc3N6?=
 =?utf-8?B?MEpQUjVqWlRVNEkzSm5SNHpaR2NJVzhLdEIvOXBWNnhIZVZLZlVHbStxdTZV?=
 =?utf-8?B?bXJJRWxQbTE4dU1ZNGhaOFVMOThaRGhaK2lSZjE1bmwrK0tSbWVMOGNGb3JZ?=
 =?utf-8?B?QnJPbFBQdkRwNklSdUxGejlaTXEzYjhrZDZuRHduMUhaRzRFS1NKUmVucnk2?=
 =?utf-8?B?KzQ5UW9rTGhRRWJmQlZhcWNKcGIyNnBjRTBqWGVSZFh2dUsvd2lNN25YeUhQ?=
 =?utf-8?B?dHVCRmlZS0ZuWmdoUHlUZGhZa0N2TFYySjBDbnpWcUdBalFSQnB6UmRCaXNk?=
 =?utf-8?B?WVVZYTFzZWhQYUlvemliUFkrSk5jcXE0cGRPUGp4VFQ4d0xFL1RRb29kTnM5?=
 =?utf-8?B?K25SWGVWQzdkMUhuQk9DNEllbFR1TXlTcWxaRnkwanJrN0g3dHVCcUFsLytV?=
 =?utf-8?B?ZzlISHpkSlJOeDgxbmthUjdYTE5RQytISVAxbnBWMHYxdEUzNWpQUk1hcTMr?=
 =?utf-8?B?Wklibm00dURkdWdST3RIVTVTRHRuYTg1cUtmL21MRTFsWlU5VHcrSXVNWEYz?=
 =?utf-8?B?Q2RwaWMxcEhWNXQ3MzBHTnRIeXc5UU1ycWNYL3phNWNFU09pa256UnhITGZP?=
 =?utf-8?B?aGw3M21neXR0K0VZUkk0L3ZDODRLVXpOblFyN3RXWWZtSEI0N3Nxc1QxdDlG?=
 =?utf-8?B?cjdWZ3BKY2ZIcjhnTGFRRnE2bGtHdHJOdjF0MmJmQTl2MFcyWUM5L2tKQzdm?=
 =?utf-8?B?Z0s1MW1EYmhsRTU5Q05jbEdsVE9iYnRYQUVDZDBxY1FwTnlvQVFzbnE3ekZQ?=
 =?utf-8?B?L2dkK0ROMmlSUHZYQ3hpZktqM3pMcTY0bWtqVXJhSkw2cnNQVjBqTFFIeGp4?=
 =?utf-8?B?K1oxMFlVcnZ3M1RIZHRFNXdrRE4ySHVFL1ZPRUVjZjBIb3k5emhlc0pRYVM3?=
 =?utf-8?B?WGVoSDN5TWowOEJRMzg4SjROaGNtQUR5cEtMUXgvT0tRd0hKTXFrTFpGVUFq?=
 =?utf-8?B?NkIya1RJWFRUL293QzlyUUxWdW1iN1Z0TUxUcDV5TnlCRUlURkhDRlh4aHJ0?=
 =?utf-8?B?WDJTSUgxNUQ0dFhEb1Y5V0JDZ1hhcnUzaVhzeDlxMnZEL1BVbUcxdTZnNXlO?=
 =?utf-8?B?cUhpNFFJUTFhRTNWTnU0cnRudFI4VEJjbm5IY0JXQTdReStveDV4elhQQVF5?=
 =?utf-8?B?Y2tzc2hQNFF0TUY1QjYzN2pxZndMZjBGYnluV1lIVkVmUExoRzhMczU4QUVO?=
 =?utf-8?B?MVI4U0pTMmxrcGFFNkR2VVRpZWwrTGZnTjNURDZuYit0eGhTd2xTUWFmSDd4?=
 =?utf-8?B?Mk51V3Y0TzAwa2dQRjFWQTNrb2VxOFAvdGJiL05Vak5ONkZGN2pNdGIvaFJr?=
 =?utf-8?B?UkIvSWNQOWN6NnNZeUM3dlc3QmMrZ3FYTk03TDgxeEpTOHg4NWs3NGNzejEz?=
 =?utf-8?B?Z0VzSk4vVWp3OWVHcm56YVBvR2g0Wk1reTBxanVtcXZIa1ZGL29Xcm1sK3FO?=
 =?utf-8?Q?NIuYEOKcAezD7jgzwYIpHlVCZ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4481ae8c-4e45-4ca1-3935-08da64a590e9
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 07:59:09.1181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMybfdWFkAqn2CFUjRHyxOozhGT7HZa7uuUKQgsuFuVhHsUPfAB307wtp6oGaE08QMo5WskflLlvE8K4OGwL6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3660
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.07.2022 09:48, Juergen Gross wrote:
> xenvif_rx_next_skb() is expecting the rx queue not being empty, but
> in case the loop in xenvif_rx_action() is doing multiple iterations,
> the availability of another skb in the rx queue is not being checked.
> 
> This can lead to crashes:
> 
> [40072.537261] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> [40072.537407] IP: xenvif_rx_skb+0x23/0x590 [xen_netback]
> [40072.537534] PGD 0 P4D 0
> [40072.537644] Oops: 0000 [#1] SMP NOPTI
> [40072.537749] CPU: 0 PID: 12505 Comm: v1-c40247-q2-gu Not tainted 4.12.14-122.121-default #1 SLE12-SP5
> [40072.537867] Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 11/23/2021
> [40072.537999] task: ffff880433b38100 task.stack: ffffc90043d40000
> [40072.538112] RIP: e030:xenvif_rx_skb+0x23/0x590 [xen_netback]
> [40072.538217] RSP: e02b:ffffc90043d43de0 EFLAGS: 00010246
> [40072.538319] RAX: 0000000000000000 RBX: ffffc90043cd7cd0 RCX: 00000000000000f7
> [40072.538430] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffc90043d43df8
> [40072.538531] RBP: 000000000000003f R08: 000077ff80000000 R09: 0000000000000008
> [40072.538644] R10: 0000000000007ff0 R11: 00000000000008f6 R12: ffffc90043ce2708
> [40072.538745] R13: 0000000000000000 R14: ffffc90043d43ed0 R15: ffff88043ea748c0
> [40072.538861] FS: 0000000000000000(0000) GS:ffff880484600000(0000) knlGS:0000000000000000
> [40072.538988] CS: e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [40072.539088] CR2: 0000000000000080 CR3: 0000000407ac8000 CR4: 0000000000040660
> [40072.539211] Call Trace:
> [40072.539319] xenvif_rx_action+0x71/0x90 [xen_netback]
> [40072.539429] xenvif_kthread_guest_rx+0x14a/0x29c [xen_netback]
> 
> Fix that by stopping the loop in case the rx queue becomes empty.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

Does this want a Fixes: tag and Cc: to stable@ (not the least since as per
above the issue was noticed with 4.12.x)?

> --- a/drivers/net/xen-netback/rx.c
> +++ b/drivers/net/xen-netback/rx.c
> @@ -495,6 +495,7 @@ void xenvif_rx_action(struct xenvif_queue *queue)
>  	queue->rx_copy.completed = &completed_skbs;
>  
>  	while (xenvif_rx_ring_slots_available(queue) &&
> +	       !skb_queue_empty(&queue->rx_queue) &&
>  	       work_done < RX_BATCH_SIZE) {
>  		xenvif_rx_skb(queue);
>  		work_done++;

I have to admit that I find the title a little misleading - you don't
deal with the issue _in_ xenvif_rx_next_skb(); you instead avoid
entering the function in such a case.

Jan
