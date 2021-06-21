Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172A93AE5AC
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhFUJNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:13:40 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:36985 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhFUJNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 05:13:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1624266684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJd+X/A94EI23dGd54cbNXHaDDEu78s3T1s4Aa+H7JQ=;
        b=fjRQ1rs4tl/z5xiJpIkYuBiR0NW6pLX0WcePy47PvttDOVa9arVuh02TKkSY0Y/WMWx1HD
        bjIgz0ad4MqJk7vHqklD8JqOGkQ/MQHJQRK/+lq93MVijQ0Q4O97Nj2uuSel/BOXtcJ2fV
        g1n/VNXy5UdvjpChtryZcbniJOtZ2rI=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2054.outbound.protection.outlook.com [104.47.6.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-Opm7prn8NZ-E9NydaPACSQ-1; Mon, 21 Jun 2021 11:11:22 +0200
X-MC-Unique: Opm7prn8NZ-E9NydaPACSQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPv516DMUrJjGFS7m+Lg8EnTD/69me6HnhP4/CgMV2fUc93fO6suZMV8XscI6ApKa+YczO3Oo4Fy8GvgMbw7VHGqFhWxCC8JIx1pU/JUW/fGik69QnS2GcWw0GZ5enww9LhmoZOGAuM+mZ4fvvBE++YcSTOJeiRW31DoNsK5+BeOwP9Bml1uBd981wmiVgVm9xlBI6h6KrE9ZE74vigxyHfod+oK3G8i2NlARRVbu3e4uh4BW84beduF768+Op9PTOHjM8pXWgaPdzJuzDXknQ8v+/CONOEpXdN0ZW3RjtlOkTOVNy/iiDGlq+NM8MG7Dvis5fZmV5S+h/qH0PhIzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9jZdH8jTgE+br94viYiY+w/AnMq06FxtZWjsUUZ7Ys=;
 b=gdUxMajyeRzcIMy5HAGVQssJYb9KxaqRVt/ePPgIEjHeaW45p1tXgyPk3p79kM9uYmeNK5RhYtIxs9kWnBI8ikGIbeJjfIDWx12g0JGvjTG5qmHw4654tRx2t20Yefn6q1tO0OYSRWiQq6FHJNCLRmdUb1/kwdwOo4O9zp3HAi9M6yNMuAODO559xpVbO3z29X/x4Cvjci7/iDKdntJtTQHHzZ3z4F/ZdQYF0U9TXivKr5jfs5k7rDKt0of6KFxvKWQagYUUMcF5ND0V5tbGbRQUSXLvs2jF8cdHxTFwV8vzyc8NKURTGL9dEsk08DgvLv0e1caeS3uoyJdHdbMp1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR04MB4995.eurprd04.prod.outlook.com (2603:10a6:208:c4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.22; Mon, 21 Jun
 2021 09:11:21 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::55a8:3faa:c572:5e98]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::55a8:3faa:c572:5e98%7]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 09:11:20 +0000
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        stable@vger.kernel.org
References: <20210618141101.18168-1-varad.gautam@suse.com>
 <20210621082949.GX40979@gauss3.secunet.de>
From:   Varad Gautam <varad.gautam@suse.com>
Subject: Re: [PATCH] xfrm: policy: Restructure RCU-read locking in
 xfrm_sk_policy_lookup
Message-ID: <f41d40cc-e474-1324-be0a-7beaf580c292@suse.com>
Date:   Mon, 21 Jun 2021 11:11:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210621082949.GX40979@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [95.90.166.153]
X-ClientProxiedBy: PR0P264CA0264.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::36)
 To AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.202] (95.90.166.153) by PR0P264CA0264.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23 via Frontend Transport; Mon, 21 Jun 2021 09:11:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9973ff81-5a7d-4ea7-1587-08d9349488ba
X-MS-TrafficTypeDiagnostic: AM0PR04MB4995:
X-Microsoft-Antispam-PRVS: <AM0PR04MB4995AD3A885735B007FA13D7E00A9@AM0PR04MB4995.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7K2XesgQ73rW4ZqJg3cZdVH0yMmVOZVVD0JW72YhnuW9Kp669IO/lRI/YoucTr3+oCEHd3Bho8CRn87XxZkSFgbuB7QpNZit0qVt9FvkutlYxuRT9gsHSpwadgxYQcg9A+6H7PSA//2wDIs5J6zG3pWl0OZRXRxmH5nDSWkDYCP0mnWO0j54jTSM9pElrFsTWc1RbBOW+SeeUKzgDVU2LbwqBAFXuXZJ8HthguoZ7LGDJL2ZGCheepCvhAg1/c3zDHaW8UUS7u4MOIJlF5JbvGtWE2Y5sDSVRe8xdZKxMvHvm/MS/t+a1Eu7a72BWpIkRX/TZhemQXfRPfikwtbKAuww7tPwiFNcTjaJ2ADy96UsnwAVOdZ1z/EfWXATuTT8uyJUkefVd6jf0M9lYW5CoF9s3biDUrZW9Hyts4cPUuZxOCj6pva2JZa3BwWz0a4hPslICIJ1oJVPHTnQHJmIwdAN4buExgSE8SYDvoZL6K/MFEKmRRNAycwnJDPoyCwKD46iH1ZObcZy/teKycc3cL86sqtqjWcxR8hZUM63mK78zvaQTa/CMAWKBzhXS1C/2OZwmCew+tIS/9dGuyS01izw+Agt5xu9pKAtNq5zEEa6NWGdpVBE9PGWDcE03Kb7FkXt7URvp1qrk3fk+npgWM67OhAM+x8M6g2Dwq3Z9Vcq9A5g4tSVirfJW7MGL22W5ZVKPIxe2b9yto1hT71AsBffYzh5tiZSjqblxbgOZAoeGETDQK4MJoP1jtPohBov9WoGSXJ/KIYAO0EHfbTg/KHMyU/YKA7uucGo8Qdr45M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39850400004)(136003)(366004)(6916009)(31686004)(2906002)(8676002)(4326008)(7416002)(6486002)(478600001)(66574015)(8936002)(966005)(83380400001)(36756003)(956004)(5660300002)(53546011)(186003)(16526019)(26005)(54906003)(38100700002)(316002)(66556008)(16576012)(31696002)(2616005)(86362001)(66946007)(44832011)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0IPDZj6vDCNY3upuKwKQ61ZSnwfUIu3I4hfrxeppXqmu8jSVCEq655C4ofwn?=
 =?us-ascii?Q?L30BPnznKq1dAUHcTzvU1xBQLlWhVgnNUysAqVQjVbhAVgn+KUtJLUW84PpY?=
 =?us-ascii?Q?FrE7ekc73fKQBmlN6+5/GUZeA9bC85+mcOmwE6L2VEYcrHXqdoN4dcxKiO2R?=
 =?us-ascii?Q?75aT8/JfeRcslnX7726vvbvpG36ZC2KxxMJOvJh2YHoNml9eqB9eyyLX4ZR/?=
 =?us-ascii?Q?6hRX8fvl4dUrWGsA3uXyT/rEKsGroM5HND0SGn8fU8YCTqAvTF77d3RuxLHB?=
 =?us-ascii?Q?liHsv8DSnPfGt8wdhIaTB2lV+rYCXTzMjvHSu3lul4CWqQMX8q8+Xzm7tARn?=
 =?us-ascii?Q?P4tQILPnLLXkdByqmjM/AB45cqNlc0fQoaeom9RA8Ehhg5zmIQpg84pce+AW?=
 =?us-ascii?Q?6HQ9TYUf/tY/LFZsXX1iiGb0J669QQKQssQCoWL4xSN5GL0a3p5/QkKSkXkh?=
 =?us-ascii?Q?P9ohz/GUYnmqoHbl4hInwNWAxqkNPwsgu0uI8IknbvhowKruspkM/+ZWAo5Y?=
 =?us-ascii?Q?xc4dxqpw0iAPrQRl3EvparPexCxGxI2z7a2U5JLKIzqaa0ZeqPf1tJVvICT4?=
 =?us-ascii?Q?/EDUdrv3Y9QSyOeD++VidpVNEp7Arpf2y98e+2TBvP5d3yM7o/x9bv9fP5Aj?=
 =?us-ascii?Q?+Aay+7kwevP4RXpMBvX2OEr27lqL6PTPiKODLhFy26Y51O4Sx3qpnVEr9Wb8?=
 =?us-ascii?Q?mqAPadI2mBuhCDY9o/SrapkKKxHu8K9CEE+WrHi8tYAq/tODy4XcMXaynoN5?=
 =?us-ascii?Q?IX5HJuh8FZZ5Le+huRFdlilLnLHvLJkEfSf2jLcSQNrfHAFUJBiB1PHcO/Cj?=
 =?us-ascii?Q?sHjxBK8ocBpSxnlFcFLLb2k+LFGXCNmEvvqwL1kLd/IH3HQvkfy9dfA3++oj?=
 =?us-ascii?Q?g7A1YvMiwl6FDGNY0vzr83f7ToE35MfqV5bea+HZKsPeG2VcqM8uI/9F0nz0?=
 =?us-ascii?Q?6sXqhRAD3ZxwxSzKAQp3P5ZjdsbLHKNnGxXPV5gmuthEk5KjdvIFwWEPQ5ph?=
 =?us-ascii?Q?YA2aibPdTXZHAiG4DDlkNVIEbfMyS0fQV6DMxvJ/+aZEmXHfR7BcF2M7UC8+?=
 =?us-ascii?Q?JvA1Y6VhSYcriGbX48/8BohxGEKE8XgpXQGhPcpNqUGCrxDKVFAw0OS0N742?=
 =?us-ascii?Q?SwajDmRK/YgEygaKZcRbEEluQHT3xyG1FTsVpA8CYbA3QbkwvTKvddj8CcCy?=
 =?us-ascii?Q?p/DGqgO2i8edg6DsQoESi/qnLuHoZddb3mryIVd9XPdgb1lB0WdPRMYMpON4?=
 =?us-ascii?Q?ls9u91yoQa+isO+VB8LzOUSuWa4OJgtWqLfAFzWP/J/+qgPK6cfscCPt23Vo?=
 =?us-ascii?Q?Rc/PRoj9CBAvgZ3muqJFwcCi?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9973ff81-5a7d-4ea7-1587-08d9349488ba
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 09:11:20.8843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4ayeQec6Hoq7YSl2pnZXnffd/2T9pc13VTGqVwE7479QIbhlHXjx70x8yOid3YQHPEkwIxjcJ4osJ3OR3vrUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4995
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 10:29 AM, Steffen Klassert wrote:
> On Fri, Jun 18, 2021 at 04:11:01PM +0200, Varad Gautam wrote:
>> Commit "xfrm: policy: Read seqcount outside of rcu-read side in
>> xfrm_policy_lookup_bytype" [Linked] resolved a locking bug in
>> xfrm_policy_lookup_bytype that causes an RCU reader-writer deadlock on
>> the mutex wrapped by xfrm_policy_hash_generation on PREEMPT_RT since
>> 77cc278f7b20 ("xfrm: policy: Use sequence counters with associated
>> lock").
>>
>> However, xfrm_sk_policy_lookup can still reach xfrm_policy_lookup_bytype
>> while holding rcu_read_lock(), as:
>> xfrm_sk_policy_lookup()
>>   rcu_read_lock()
>>   security_xfrm_policy_lookup()
>>     xfrm_policy_lookup()
>=20
> Hm, I don't see that call chain. security_xfrm_policy_lookup() calls
> a hook with the name xfrm_policy_lookup. The only LSM that has
> registered a function to that hook is selinux. It registers
> selinux_xfrm_policy_lookup() and I don't see how we can call
> xfrm_policy_lookup() from there.
>=20
> Did you actually trigger that bug?
>=20

Right, I misread the call chain - security_xfrm_policy_lookup does not reac=
h
xfrm_policy_lookup, making this patch unnecessary. The bug I have is:

T1, holding hash_resize_mutex and sleeping inside synchronize_rcu:

__schedule
schedule
schedule_timeout
wait_for_completion
__wait_rcu_gp
synchronize_rcu
xfrm_hash_resize

And T2 producing RCU-stalls since it blocked on the mutex:

__schedule
schedule
__rt_mutex_slowlock
rt_mutex_slowlock_locked
rt_mutex_slowlock
xfrm_policy_lookup_bytype.constprop.77
__xfrm_policy_check
udpv6_queue_rcv_one_skb
__udp6_lib_rcv
ip6_protocol_deliver_rcu
ip6_input_finish
ip6_input
ip6_mc_input
ipv6_rcv
__netif_receive_skb_one_core
process_backlog
net_rx_action
__softirqentry_text_start
__local_bh_enable_ip
ip6_finish_output2
ip6_output
ip6_send_skb
udp_v6_send_skb
udpv6_sendmsg
sock_sendmsg
____sys_sendmsg
___sys_sendmsg
__sys_sendmsg
do_syscall_64

So, despite the patch here [1], there is another way to reach
xfrm_policy_lookup_bytype within an RCU-read side - which on PREEMPT_RT wil=
l
deadlock with xfrm_hash_resize. Does softirq processing on RT happen within
rcu_read_lock/unlock - this would explain the stalls.

[1] https://lore.kernel.org/r/20210528160407.32127-1-varad.gautam@suse.com/

Regards,
Varad

--=20
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

