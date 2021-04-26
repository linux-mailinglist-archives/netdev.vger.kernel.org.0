Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180DC36B78B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhDZRHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:07:14 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.33]:55718 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233736AbhDZRHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:07:12 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2021 13:07:11 EDT
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2A1D2268D2;
        Mon, 26 Apr 2021 16:58:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F29AC4C006B;
        Mon, 26 Apr 2021 16:58:54 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gROc/8PnEqr8kaOSiiUc1qI1DFSjlW7NPm0u8q4A4YUyf1AbeI6ySK0C9LSK1+pDiWY/vBMYd/kDSSrsuGtCPcXnBxxIlq7ScHdrTGw3cc3bpveiYA3p+A/W3xJorz9QcepqvIhatnM7fMYiT+GfnIcOFxT/VByRn2mHGnuc5kRsiNzaSdpvtJDCkkL6kEzgihKgm+9hVBI3g3XhAmLZFq+oOTChCMc6fsZAGa7YVk72+ufSF2mRWlgQNEdsmnCL2BrNPNf/6hau9pqt5r/otYQn4uDNWt9usaUzlfcCzHElghO7EsMd0GuBCNKIrBWuQdwhoxSTMIsa+COqM4jCWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23tQ4IqTb9w0VeWAqCwIIDcCLioW2dw9VNpE++D9u3I=;
 b=d1zHjCfSO3xj6vvLlstktmatpeyrLpq7yB7B4+dSxIBHS3Me2XGDwq61B+8aRIvvQmYNRfzDj0YKySfSuojimbErKo1HKUM8cxP0uYUItg91y+BSmPRrcZz9VEzitv/4zJcnDYOtvCrD8mf6Zc81rkE/dQdSsQaescekzXXUMbZa6nwzmSKA3ksAZzp7sE3hZ1kznGsHZ6Gp/qb+ph2S6odYEetukx8S12vQhszRErw+mEAKYh8HvTnjU1SgjRE4vUnQhCZWzzm/97d0TBCvlqyLV2r/RIVIApRxcYO+t6n3HitCZOv2C1NaUjVzn3yTntw9JwLs04d8aXZ9uL8mGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23tQ4IqTb9w0VeWAqCwIIDcCLioW2dw9VNpE++D9u3I=;
 b=bE69VGi7pqMG5kBEuowR3gh42yR182i1HrZ0oE72M0q+yT9IwKqHZY8axICDjQwRTTNg/4e+xRm1OED9SiZpCJGCHdmL3x22vDkGMaI/V/DV7GT1IYD/VyZtC68URgj7ixA8kKy06y3jAFpwNMjC8KP3wh5s4frzlSu5wucAg6c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com (2603:10a6:20b:10d::12)
 by AM5PR0801MB1827.eurprd08.prod.outlook.com (2603:10a6:203:3c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Mon, 26 Apr
 2021 16:58:53 +0000
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3]) by AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3%6]) with mapi id 15.20.4065.027; Mon, 26 Apr 2021
 16:58:53 +0000
Subject: Re: [RFC] tcp: Consider mtu probing for tcp_xmit_size_goal
To:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Leonard Crestez <cdleonard@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <c575e693788233edeb399d8f9b6d9217b3daed9b.1619403511.git.lcrestez@drivenets.com>
 <CADVnQykCbF9jcFS6xE9fmaVnimSvY+0yOgGf=THA0-tnnyYPDQ@mail.gmail.com>
From:   Leonard Crestez <lcrestez@drivenets.com>
Message-ID: <ec77b414-32f5-b512-7f1a-fb939430cea6@drivenets.com>
Date:   Mon, 26 Apr 2021 19:58:50 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CADVnQykCbF9jcFS6xE9fmaVnimSvY+0yOgGf=THA0-tnnyYPDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.96.81.202]
X-ClientProxiedBy: LO4P123CA0323.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::22) To AM7PR08MB5511.eurprd08.prod.outlook.com
 (2603:10a6:20b:10d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lcrestez-mac.local (78.96.81.202) by LO4P123CA0323.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:197::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25 via Frontend Transport; Mon, 26 Apr 2021 16:58:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28b4d626-d4fb-4fe7-76d5-08d908d49241
X-MS-TrafficTypeDiagnostic: AM5PR0801MB1827:
X-Microsoft-Antispam-PRVS: <AM5PR0801MB1827057E659C83F30109C6E6D5429@AM5PR0801MB1827.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hs+qPocvjEUTR/ybhS6pNxFnZWYrNukWptfF0uIUN2bZ5dNATjLKp00u9kiEtErXXR81f2o7fcx6fBjaYFgstQoqWdULZQI6/ghfBIz4vdf4JCPUsH1aAVBkv7/JnZNiKop09dRU7eqoGzp+510ZfKuOADDJ+8K9FcwE+B3qd0LASHbBKEx0USzqwUl4zhbo89J+NyPQ0Q+z3gCpKZuQV++SBehR+by7v/StgcODnC1nP9AUE/lEipt8z2kU8NKXe7CK7x0Y+jraVWoiLeAoDslMmTpmioUnts6ZYpOxwmG+G+vOP04LRjSsX8/T4bO0aUC46bJOE98ra5dWKMEakVbvJ1+HiVxUvdZ32N/zXemJAv+K3CQtZA0OVlmxVSedUKD90lRPpYNvU6ZhhuUNeGfLDi7AwQqw67Zx1Ez0b1NWkofCWxCKzjSRUrhZh72t6IByJVDBmoPBSRlpRBN+P1w1ypOgQPg1yyge0bRQb5feCXKlRJL6fiMtSJqOmSP2ABeN5VBhoy/it/ZODd3hgOBJF9QDqS+Ba6MMvdHTTa1gDhfkHRcFh/3lRexQq8CngXTML3ZDt9mYzSmtFJLDk8ndWp90XT43w4KfTZF52kd8o/uFMSxuQ7xrrT5zmNlvmpGy4R0kqBOeiV1NAyW/7TrLN8NFAHp/M0Ei2QvB36+51ImkC05fFqEfb/wg/iYBYVnJ/lrQSV4ItBdsk24QpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR08MB5511.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(346002)(39840400004)(2616005)(83380400001)(6506007)(956004)(8676002)(86362001)(36756003)(52116002)(53546011)(26005)(186003)(16526019)(66946007)(316002)(31696002)(110136005)(478600001)(6512007)(2906002)(8936002)(7416002)(31686004)(38350700002)(5660300002)(38100700002)(6486002)(4326008)(66476007)(66556008)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T3hwSDNZNkMxWmwwcE8zTG1kUHo1MjJvYUxhQzdkTCs0V2Y3OXVSbUM5SUFo?=
 =?utf-8?B?UXV4K0xoYmZvWWR5cERudkZxSExJRFBsS2xMa0piMXNrWE1HemZwZ3NTQzJj?=
 =?utf-8?B?bzErMDI2VzNqakVlNlNMQlBtcmRmcUFhQ2UwNHdSSVY4MnNyS0NWYURtalk4?=
 =?utf-8?B?Zjg0N1I0SkUxVTdqS1UzZHJXTjJXcVZCWW4wdzVOdzVFbkhzRVU1L3hOY3VP?=
 =?utf-8?B?WC92alZpZVNGbFFnYzVDdFRBcGRoWGJPOU45aUx4WjQ2WXpkKzM1MHQxY0RO?=
 =?utf-8?B?MUZwdHNWdWttNWZ1NXVvODhabE5nVzJlcnhCbXg4Y1RqVjVFRTJSZFA3bnBh?=
 =?utf-8?B?alpUTnB2Q245YVBTdWZkNDFmbUFzWS9qc1VWTEdIb2psYkg3U3F4OWZxYnk4?=
 =?utf-8?B?cEZwVHU2UEJHSHQ1MEU5SE5oUkhNSXBGSldEZDE1c01lQmZNSkVmeEFubkhk?=
 =?utf-8?B?dnkyQmQwRXcyWklJTXNyWnV2TVc5T3UrMzgxK2JkZWR6RjU4RGk1Y2hzeFcw?=
 =?utf-8?B?YmZuczVJR0lCWFg2dnkvd0ZYQU1iNVFXa3l6akFPSDF5Rk4rMU1jN3F0WXQ1?=
 =?utf-8?B?eVIwRE5WUG1VenEzdk5TWlIzV1I4b1M0clh2ZCsxcEI3eEtwWlFtUE5XeEhL?=
 =?utf-8?B?SFc1OWtabmhIc3Ftc25SanJicE90cmJVTnc1UkZDYkVQTXJobHZMN2x5cFpR?=
 =?utf-8?B?a0xKTWd6ODl0WlJZRXZFeG1pcmloNnVYR1IxWkZEVVpOT3pHZHNYWXpMNE9I?=
 =?utf-8?B?K3ZwM0J2OU5tY1BSeTh4QXVKUGJoZ0NZZEZjSE1FaTZ6WklMcnpXeDZvNkdZ?=
 =?utf-8?B?UjFMbHg5YTBVM3liTmdSYnp4UGgydkRQQmhmaExqSkVCRWU2VURoZlVseDkz?=
 =?utf-8?B?cnZGL1hBcEsxaUhiRUZXVVVOWlJsaE5DZWU0bHRnVlJtMmhPVldNcVk4SmZl?=
 =?utf-8?B?ZFNBNlNpdlcwSXdtZno3VU53N1VGSWQ0NzBNK1JDWVhhUmV3WWF6OWh4T2NN?=
 =?utf-8?B?UHRxdXZFMmhBbDNjWWpUYUJyY0JrSytPNWR2NDQwQVV2RWx0WnNQOC9KTTU5?=
 =?utf-8?B?UFZPKzNtbGpwdXE2cmZ1ek54eUdCbzlJMG5RRkRQUEh5bmh4WldENXlGZHJI?=
 =?utf-8?B?YXNXUnpnM2wvWW1CVEY3ODNqa2wyUEI2UUFCbHBpazNySUlkMmhnNE9nMTdD?=
 =?utf-8?B?S1hXT2k3M2lUVmIvZzYxbkZpYjlTNDdjcm5ET251NEMrOU9IVHVDajlhb09r?=
 =?utf-8?B?QWV6NXJvaytseWNmbnBxaXRDVVhtZ0dyRHVYQkpzZHlzTWZ6YkJPZmZuQTJk?=
 =?utf-8?B?VlRqQTdFZTAzbTlraUdtYnNUNU1vLzFJSjZZcDloTE16UTRybUFUWmFSN1lx?=
 =?utf-8?B?blZqZHVqQUJCMlhldERVcE55ekhQdExBc3NXMjczZmtmTmNwc2tNVDg3bGVY?=
 =?utf-8?B?ZmtWTWpWU0x6Vkx5WWRqMzBQc2M4anM0WlFiZzRUalVSZlJJZkNYSTVKSFVI?=
 =?utf-8?B?eW9kVWdoMythU1dHTjBHbmdGcHF5bDVqSHo0OFZJaGhNQTBEaWNsNEVSWFU0?=
 =?utf-8?B?bFg0N3ZhQitHZTZXNk9NZjRVblQySzU2NmdJVit0dWpybm1hd3hEVVNJWXpp?=
 =?utf-8?B?Z1FJdks3UkpBVWNxNEN4VnVOYlhjZkF5eS9wMStESTJlOTBBNmczZXByUG1k?=
 =?utf-8?B?emVtOFJRSS9RWlBkL2NLVG5DaU9tbXBvU2pHTVhYekF2VUVOZVBFcEQyM1FS?=
 =?utf-8?Q?FfyIFN0HgF3zwSW7Y8yD4qrsqTrvUhZjz3kh2Zm?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b4d626-d4fb-4fe7-76d5-08d908d49241
X-MS-Exchange-CrossTenant-AuthSource: AM7PR08MB5511.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 16:58:53.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MC4qbWNr1QKL51eVEoX7a44yHfZ1nxnyra5XNF8em5lM/pLFh/Ey6y0hE5FDpV1ng8FVTnnBjkJmIjwL7Im6Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1827
X-MDID: 1619456336-fLziVoxzielr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26.04.2021 18:40, Neal Cardwell wrote:
> Thanks for the patch. Some thoughts, in-line below:
> 
> On Sun, Apr 25, 2021 at 10:22 PM Leonard Crestez <lcrestez@drivenets.com> wrote:
>>
>> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
>> in order to accumulate enough data" but linux almost never does that.
>>
>> Linux checks for probe_size + (1 + retries) * mss_cache to be available
> 
> I think this means to say "reordering" rather than "retries"?
> 
>> in the send buffer and if that condition is not met it will send anyway
>> using the current MSS. The feature can be made to work by sending very
>> large chunks of data from userspace (for example 128k) but for small
>> writes on fast links tcp mtu probes almost never happen.
>>
>> This patch tries to take mtu probe into account in tcp_xmit_size_goal, a
>> function which otherwise attempts to accumulate a packet suitable for
>> TSO. No delays are introduced beyond existing autocork heuristics.
> 
> I would suggest phrasing this paragraph as something like:
> 
>    This patch generalizes tcp_xmit_size_goal(), a
>    function which is used in autocorking in order to attempt to
>    accumulate suitable transmit sizes, so that it takes into account
>    not only TSO and receive window, but now also transmit
>    sizes needed for efficient PMTU discovery (when a flow is
>    eligible for PMTU discovery).
> 
>>
>> Suggested-by: Matt Mathis <mattmathis@google.com>
>> Signed-off-by: Leonard Crestez <lcrestez@drivenets.com>
>> ---
> ...
>> +
>> +               /* Timer for wait_data */
>> +               struct    timer_list    wait_data_timer;
> 
> This timer_list seems left over from a previous patch version, and no
> longer used?

Yes, I'll most a cleaned-up version.

>> @@ -1375,10 +1376,12 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
>>          s32 delta;
>>
>>          if (!sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle || tp->packets_out ||
>>              ca_ops->cong_control)
>>                  return;
>> +       if (inet_csk(sk)->icsk_mtup.wait_data)
>> +               return;
>>          delta = tcp_jiffies32 - tp->lsndtime;
>>          if (delta > inet_csk(sk)->icsk_rto)
>>                  tcp_cwnd_restart(sk, delta);
>>   }
> 
> I would argue that the MTU probing heuristics should not override
> congestion control. If congestion control thinks it's proper to reset
> the cwnd to a lower value due to the connection being idle, then this
> should happen irrespective of MTU probing activity.

This is a hack from the previous version, removed.

>>   int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
>>   {
>>          int mss_now;
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index bde781f46b41..c15ed548a48a 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -2311,10 +2311,23 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
>>          }
>>
>>          return true;
>>   }
>>
>> +int tcp_mtu_probe_size_needed(struct sock *sk)
>> +{
>> +       struct inet_connection_sock *icsk = inet_csk(sk);
>> +       struct tcp_sock *tp = tcp_sk(sk);
>> +       int probe_size;
>> +       int size_needed;
>> +
>> +       probe_size = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high + icsk->icsk_mtup.search_low) >> 1);
>> +       size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
> 
> Adding this helper without refactoring tcp_mtu_probe() to use this
> helper would leave some significant unnecessary code duplication. To
> avoid duplication, AFAICT your tcp_mtu_probe() should call your new
> helper.

Yes. This function should also check if RACK is enabled and try to send 
smaller probes in that case.

> You may also want to make this little helper static inline, since
> AFAICT it is called in some hot paths.

It's only called when tp->icsk_mtup.wait_data is marked true so only for 
a brief while every ten minutes or so. It is possible that this "wait" 
stretches for a long time though.

>>   static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
>>                             int push_one, gfp_t gfp)
>>   {
>> +       struct inet_connection_sock *icsk = inet_csk(sk);
>>          struct tcp_sock *tp = tcp_sk(sk);
>> +       struct net *net = sock_net(sk);
>>          struct sk_buff *skb;
>>          unsigned int tso_segs, sent_pkts;
>>          int cwnd_quota;
>>          int result;
>>          bool is_cwnd_limited = false, is_rwnd_limited = false;
>>          u32 max_segs;
>>
>>          sent_pkts = 0;
>>
>>          tcp_mstamp_refresh(tp);
>> +       /*
>> +        * Waiting for tcp probe data also applies when push_one=1
>> +        * If user does many small writes we hold them until we have have enough
>> +        * for a probe.
>> +        */
> 
> This comment seems incomplete; with this patch AFAICT small writes are
> not simply always held unconditionally until there is enough data for
> a full-sized MTU probe. Rather the autocorking mechanism is used, so
> that if the flow if a flow is eligible for MTU probes, autocorking
> attempts to wait for a full amount of data with which to probe (and as
> is the case with autocorking, if this does not become available then
> when the local send queues are empty then the flow sends out whatever
> it has).

Comment is from a previous version, should be deleted.

--
Regards,
Leonard
