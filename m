Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9757337C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiGMJtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiGMJtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:49:21 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC72F6BAF;
        Wed, 13 Jul 2022 02:49:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWZMk+o7vMNMJ6ipMVGKzWM8z5G5LKVHvMyE9Sjx+lCq3ExhH9feWu75+JB1PN3VAsIY9mZInnAtcfY6nYw9CWsd2+EItw2QxY4N/puaFIsZHU258+3WY3Ply8+sP7UBIeT94m8RvalpYZxFzYfvV1I7nSsOAgHPW29GqnlEBznf+YwJcR3lNSWO/+vb2phnDRZYgl7uSfQOjNYiD8L50/FRxSCxDg44okejyPiAH+aU4BcjCr0cAnQkJbcWkDMCUPIVAROUdBqTNy9rT3WrjzxCqJiuSnTGZAhXxoziSLXtz0x5y60VNl4yATKJWSorxgGEkn8n1Qy9H1ITBsKT2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQDHYXBSiqGtSfCtEQYakVQSucdfXKK79khOVuSY6Cg=;
 b=CASWgMXQANUMwAu+CylPIodwbChrlT0WZyhqHl1dv3UpfEtlWfSDrOmUqque+YTeedaX73hXLXkiRDCvfd/C9615LSb6tPQ8pVgbQbY0j2z4q0OlLbf47NchMfzyaSznGbe/mjU0YFtv9Ch3duyXs8PboFvFIkezKjDAZN/Vaovoe/122owHsXG0uI3yy5nhsXhs+l6I78DU4XaGQ5CGKg6oRBkCVShaUZzovsonKIgcpjNp07Be+5X+L6k1Vc/8B2pF6rne75d2QcVwJ1idZGRpQ7iN9mC6TQTqLLeUMcV5pHt6Gg6sfhcw2Ztsd4xHIaQ9A70X8vR0S5vPPWU87g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQDHYXBSiqGtSfCtEQYakVQSucdfXKK79khOVuSY6Cg=;
 b=AnuRwGnwQJn0szwVbtD3UECOKrQedDN2857U2DI91d32FAPjcEz2GhtgXD5cBh61ZrNjyCIvW6ADx2+2Ll05eWwVseWC6HfajB9DRZDXubzcp718Tc4vkEXrGQZfdqH4enVM0vg1PKXk+a8uBER8VppEKhWUpsgQauHW/wxheUgG301icm7U6SMtMpskCV75j1PFfjnX0TbfUF7JKWrJx356XR4LOTnAk2l+bQP1u225iLLRVI58dsUuaDnTTl6CAHmQW/QIvfbHqEBRdUuFvaFnyWiSndnelb8qAqrWdzDO1fQM+SfcJ1BQBdZL/Z//yyU/NcfGWOFqEOTo6+F6Hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by PAXPR04MB9074.eurprd04.prod.outlook.com (2603:10a6:102:227::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 09:49:01 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 09:49:01 +0000
Message-ID: <9a96fc6f-23c5-e2f1-062b-39aa0c7ba724@suse.com>
Date:   Wed, 13 Jul 2022 11:48:59 +0200
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
 <0e2772a3-3c3c-b447-ecb5-e2750959b527@suse.com>
 <b11693ec-5d08-62e7-7479-a631edd5b1ce@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <b11693ec-5d08-62e7-7479-a631edd5b1ce@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0087.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::9) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e77f8f1-e75d-4268-6250-08da64b4ea41
X-MS-TrafficTypeDiagnostic: PAXPR04MB9074:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhudvRbpZ1Jk4oyzRTNH3i1TLT8yYuIHSMxa7oPZhDmsTiIfrP+xncFLuHxRB6L9BKojZobxtqEVOpkfSy1duKc5E/A1hJIWy8Q4cBlSZaw8HxQkWv7JlfF8Mw7B6C40gzQcodMfikYQxra7t7+pZAbL8pb2EpCojPF/jriVE1AsTlSJRNdUU+JqWdo5P+6QSlCFvN+RvcDOIz2W84uAZGKlII8AWOTmRqA2dFdHIZhCpXMY6LGgTEuOb16W5LiZ4x6EKROLzZpEbLL98eEWNT0oejO3dIuyg5xF62a6REMpsGoDxTVa1y/2L6uPjYLiwAqzDBjhOjyFBuchwXG+HdJtESBwZh3WjF6+8Kz7zU69G/CT6LITTMOMLuVdkQZP8MhcKImlZcfAubzeGTnm8eoxI7wktQcFeIDc69Ow6pnvJzke9kDuc3zyDEjU5YkvB/DPR41JJC/XBV06OjNKzQfuuwD9dYtYt91dWiJrli3PeQ3HLLA+8L4RYWtupPB3+MABgANEdOOMlg0LiYetSwcjQ/5e3mkls+qC0mzt835A5rsnOowwZQma22FZo0fa099OUMi7EjuL/pUM/KbLecV7YO/sp087f/1YqkPUs6hu7cEoWncWAhbEuIEkU0xn+n6Ha3QVfSaA2PnXUa9PjU/ujf5uKMb67cL1H56AYcA0yxitEuRL+CZS84JkvvLkYEtZLYCSeuGzCB1kp+INHUpxZPByt1VH9x4GZKr/0NxyRYwxM4btMQTxzK4a0Dt7TcZ/EXoiGUM54VtE6gfu0Us5Isgs9r3ksyhgedKyvuPHAPOqBWuxP5e3VPW9ozE0Dk1RE4NsjV+65cPBUh2Jenl/tZsubw7uHADH8OQbNH4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39860400002)(366004)(136003)(396003)(83380400001)(86362001)(6486002)(5660300002)(38100700002)(8936002)(6862004)(31696002)(6636002)(41300700001)(31686004)(4326008)(2616005)(478600001)(36756003)(54906003)(8676002)(53546011)(66556008)(66476007)(66946007)(2906002)(316002)(6512007)(26005)(37006003)(186003)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czRKTEtpWnh1V0F4cDBPb1RZUXlMdHNxZVd5M1hnV01VUUpzOS9qTzJrbldn?=
 =?utf-8?B?YlFHUnhUNWtZMDZjS05BVUFiaXZqTGhRTFJPdEtuUnV3L2NTRVlJMUtxMlFs?=
 =?utf-8?B?eXNQQTNMYmdLVW82bVpwRGJGTmd1dU1USi9DRXVFSXRYQzRrT0ZYaHFpM1hy?=
 =?utf-8?B?d1g1U1ZIRVFISHVZRThmWmZhUGtZSEc2Vm5ZdCtTRWZXeHNvYWNHZ25pdlhR?=
 =?utf-8?B?bzRabWtWSnNmS2dVSThDZzVOUTdFcXJtUTRGV2QvbWJTTzJiUXJ1MVlUYXlJ?=
 =?utf-8?B?aGc4VlUzV0t2WmhQTVJmYmJLRGwxRlFLblpMNldpOFF3V1FQT0VOZ0tJVk9i?=
 =?utf-8?B?RzRlTVBHcUJIUmdkYk9VRXFaODFoOGs1N3VkS2ZIUFlCMkZET2NNT3lMbEFJ?=
 =?utf-8?B?aSt3VVBPbE5VWVNnc3EwNVYrdHh3aUlBYy9WMEhESU1yVEdWdm13MHd6Z0ZF?=
 =?utf-8?B?d3hmajg4eXd0ZVhZVFBCeXdtWHJvSDZtTXNRQW4vcTlqVkYwUEFBUjd5Q1FI?=
 =?utf-8?B?VnRmWFRTTndaN3F0RHllYTlmYjBKc21mQjNQNFcvK21HdlpyeWJZOFViN2po?=
 =?utf-8?B?T0tWTnBxbU9sRTBNc1I3b0JpeW9lS2VVR2dqSHRBL3BLWlhIN1pUUWV4MFUy?=
 =?utf-8?B?bVBhMHdGLzd1MmdGRWFRU1R1UEMrYWJ1TWluTEdCUWwweDZla1c5SXhocFRF?=
 =?utf-8?B?NzE2ZktGRzFhUjA5SlpBeElFcndyQ3hNUm96ZkZIdkF1WlZTK0kzZ2FTbVJz?=
 =?utf-8?B?dXd0eFhWNnZGWG5uTDZRV3VZUkoxZ3pWK3RXUXNQbDl2N1VCdVIvYXdGOE55?=
 =?utf-8?B?Y21ySWpxTUo2Y29OL1JwL05BN3BLbnBFOTIvUWthV0EvWEs0WHd3UXAwZkRp?=
 =?utf-8?B?eWZKWURtS2JHRWFWVlZGdHlQaHVnWEpLVGwyeHdsZk1QM3lwQURGc01XZTds?=
 =?utf-8?B?LzdZTHVtQnZ5ejMyb0JoYStreXNCclVrb1UvbWc2NEVMY3VySHdVMmFxYWMv?=
 =?utf-8?B?Tko4Y2FwUmNTbHByTlUvR3NlOXBwUE9sdzhuWVBhOFc1V3JMNklOOEd5NS9R?=
 =?utf-8?B?dmZzcTBoTVB0RUhoMDdsZS9wTlNlYURXQlI4TDc4MzloVHZJQk9aeG8zUFRV?=
 =?utf-8?B?OWJlMDJDM0RqdHdqWERYdVBVS0ZnNWRNYU4vUjFOZkJFMWVCNXk4MEpVck5z?=
 =?utf-8?B?SURYRytoWmFJblpEcXQrODY0T3ZVSnpLdVpDT3JPWGdiR1dGMVhOZmZxb1NJ?=
 =?utf-8?B?dlFuSnR2MitCUkdSWDMzbzZ5ME5SVFp0ZkNrWkprN2pxQlpFaFJYRnpmSTBq?=
 =?utf-8?B?ZDE5UXhhREtlOU9DemVGMUpPZjlLL2hUU0Y3ZlJQQm9zYktpZzRJU2RJSWJi?=
 =?utf-8?B?TGRtYlZZbDhzVEhBTlFUK0ZyVnE1akQ5TG9XQnZuTjI0QkJSRTlvMXBLeE8w?=
 =?utf-8?B?eE5tMEFSWW1Ia29MV25Db0ZlNVVFT2h4RUJ4S0gwN0xjZEJrNkI5bmg1Uk93?=
 =?utf-8?B?TENaSGVYdW9sbFZOMno2ZGIycVNnS0dzU3piWXJKTGozYTkwSDJJSitKK2tj?=
 =?utf-8?B?V2JxbWh4NGRsUTdZcnBvK2ZGd0Q0Qy83cUdRWjVTVmRkN1NMRUdoYnlNem9m?=
 =?utf-8?B?OTN3M0tSby93UklIK3Y1aHB4Tkh4eDU2NUc2TDF2MStiYVlTR3ZVTUNPYXE0?=
 =?utf-8?B?Q0I5QzNvS1RsM3dIczdIUVBaWWJ3M1JhQW5idlMreHo4ZmJyWDBNZnVvNFJP?=
 =?utf-8?B?dUpIaXlzK3FXSFZEVUxlTWQvYmVjUUNMbXRzcnIvS0JrZEtQeVZ5cG8zelJp?=
 =?utf-8?B?T0pBRTNsQVlITGFIYnZrOGYzdzMxTFNQUGh6OHpVai96ZWRVZWZGbXAwc0Qx?=
 =?utf-8?B?RXJHanp3UGJkdnJuWkhJamNobUNlc0VNL2tzRUNRUk1vdUdPZTd5OU15QXFE?=
 =?utf-8?B?dnZmQXd3d2ZPaXh1d0FLOVFDNWhzTHhFcGJ3S1QxYUJpTFkrcEpYSkJIS0c3?=
 =?utf-8?B?Rkdlak45dmpSVzcybVlHRkVQbUd0cFVUNE04M1FlTVBObWtYZXd4VS90Tkl4?=
 =?utf-8?B?NE42cGNPcDRqUG45dWpLbG1wSXhBcDM5VGZnWkZBZGdSSnZZeEx0OUNtU1Vi?=
 =?utf-8?Q?wfzO406qvRqJc4oX5ueY3rCE8?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e77f8f1-e75d-4268-6250-08da64b4ea41
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 09:49:01.4953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKbrqYGYiu9sI1+QiLoj4euxAjdtlFONEKpXgyNrMkHxnbnDjn2u5dYFf27TMlwoNirNupvNYHILaTMfWNYTQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9074
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.07.2022 11:31, Juergen Gross wrote:
> On 13.07.22 09:59, Jan Beulich wrote:
>> On 13.07.2022 09:48, Juergen Gross wrote:
>>> xenvif_rx_next_skb() is expecting the rx queue not being empty, but
>>> in case the loop in xenvif_rx_action() is doing multiple iterations,
>>> the availability of another skb in the rx queue is not being checked.
>>>
>>> This can lead to crashes:
>>>
>>> [40072.537261] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
>>> [40072.537407] IP: xenvif_rx_skb+0x23/0x590 [xen_netback]
>>> [40072.537534] PGD 0 P4D 0
>>> [40072.537644] Oops: 0000 [#1] SMP NOPTI
>>> [40072.537749] CPU: 0 PID: 12505 Comm: v1-c40247-q2-gu Not tainted 4.12.14-122.121-default #1 SLE12-SP5
>>> [40072.537867] Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 11/23/2021
>>> [40072.537999] task: ffff880433b38100 task.stack: ffffc90043d40000
>>> [40072.538112] RIP: e030:xenvif_rx_skb+0x23/0x590 [xen_netback]
>>> [40072.538217] RSP: e02b:ffffc90043d43de0 EFLAGS: 00010246
>>> [40072.538319] RAX: 0000000000000000 RBX: ffffc90043cd7cd0 RCX: 00000000000000f7
>>> [40072.538430] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffc90043d43df8
>>> [40072.538531] RBP: 000000000000003f R08: 000077ff80000000 R09: 0000000000000008
>>> [40072.538644] R10: 0000000000007ff0 R11: 00000000000008f6 R12: ffffc90043ce2708
>>> [40072.538745] R13: 0000000000000000 R14: ffffc90043d43ed0 R15: ffff88043ea748c0
>>> [40072.538861] FS: 0000000000000000(0000) GS:ffff880484600000(0000) knlGS:0000000000000000
>>> [40072.538988] CS: e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [40072.539088] CR2: 0000000000000080 CR3: 0000000407ac8000 CR4: 0000000000040660
>>> [40072.539211] Call Trace:
>>> [40072.539319] xenvif_rx_action+0x71/0x90 [xen_netback]
>>> [40072.539429] xenvif_kthread_guest_rx+0x14a/0x29c [xen_netback]
>>>
>>> Fix that by stopping the loop in case the rx queue becomes empty.
>>>
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>
>> Reviewed-by: Jan Beulich <jbeulich@suse.com>
>>
>> Does this want a Fixes: tag and Cc: to stable@ (not the least since as per
>> above the issue was noticed with 4.12.x)?
> 
> Hmm, I _think_ the issue was introduced with eb1723a29b9a. Do you agree?

If it was that, then something must have invoked xenvif_rx_action()
without there actually being work. I'd rather see 98f6d57ced73
("xen-netback: process guest rx packets in batches") as the origin.

>>> --- a/drivers/net/xen-netback/rx.c
>>> +++ b/drivers/net/xen-netback/rx.c
>>> @@ -495,6 +495,7 @@ void xenvif_rx_action(struct xenvif_queue *queue)
>>>   	queue->rx_copy.completed = &completed_skbs;
>>>   
>>>   	while (xenvif_rx_ring_slots_available(queue) &&
>>> +	       !skb_queue_empty(&queue->rx_queue) &&
>>>   	       work_done < RX_BATCH_SIZE) {
>>>   		xenvif_rx_skb(queue);
>>>   		work_done++;
>>
>> I have to admit that I find the title a little misleading - you don't
>> deal with the issue _in_ xenvif_rx_next_skb(); you instead avoid
>> entering the function in such a case.
> 
> I'm handling the issue to avoid "an empty rx queue in xenvif_rx_next_skb()".
> 
> I can rephrase it to "avoid entering xenvif_rx_next_skb() with an empty rx
> queue".

That or simply s/handle/avoid/ in the original title.

Jan
