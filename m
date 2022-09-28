Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AC75ED6ED
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbiI1H4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbiI1H4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:56:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB5212D38
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:55:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJ308AGxd778JdyxI1yGX3tMl+ZRRyiP0S+COhI++J4vSBhw4khYfVuh2oys/ZTshSn17Kv7wlNtom/pESbrwxnLkMa62CraeP2YvkhddjnQQ3Vc5fzpttrBQXK2xiqhJ3VQIX+ZE5OWRd2FSb4JyuCnCD2FY+sAC5cPhsu+Hfrfo0vFVQZw8rPaIAg71Pd+zg3neW9I8Mi+ApKvaoqVmwYVhG9dn3TXG0lbZ+eh4Zd076wsDQOqKJtkT2AyQdBwJSCSGyipj1ji8VYbc0eRPeZQMHSlwIpeNLdWXL7pYN9a2dnrPiNU3s+enIQsgAvqdc6IDhZV4esH2d149iBWmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QC1vGi/r9rGhShxk5t6t6PS0itIZUloM7ScZiLG0xnA=;
 b=JLs9a7mmpl1MQkayoPB+Ql+o3XHNPKRZ2Vv6aArI1tCk2iRVSqDcKoPuwk/Gox1QfV7bct7w5EK2blCjqfDYTGtzvsqsW0ZTBBtcCcrdSpyH649HFz13xVZZBwnjUeP1TKJUpTU/8doTwopI8TBT4iw/GXmZJb1QWhDi8eHEamVAwoosCHrT8wsFmB38/TThRIgvxZDnkGBDw5MnRwaNf58n+egddycbuBXz1RqQlTAWeOFXWTS4gtQw94TjYCLm1P+owDeCwLh4ZuLiBkIpxQJvgGUOZJC+ze2Ywd2uiLsBPms5S9t/VwprAUE2l2H6bamEOykvA93PT/7ePQOxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QC1vGi/r9rGhShxk5t6t6PS0itIZUloM7ScZiLG0xnA=;
 b=IeKjqJaNyV5AyXfVfyfJkSkyZDzNtq838uqUWb39rvGouaJAqZ+gT9QlQCF/B/hnW8gPHCUfNYSab8IU8HeSjA6YubjVUnswJzcPgdWB/2QCK88kiZv97e63z679iOiTp000MxGiGZVbuYD6WfibkAfRmP+EMzo48Joy0ooneORwco6ev+btH5I+dcyNatLLQ9iY7BZ6A0bqS8dqGx2u//84JHHdtjfEUVEMYiclXggOx81BK19TCRjfRbyS6Rw0LQKE23RXA2rof43KFhVQflC42hkv2ZaBI3V+3c03rNr1k1PVIhzEeLj5Kf6wM5Be7NWzieZIYw/ArCHM2VI3ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by DM6PR12MB4329.namprd12.prod.outlook.com (2603:10b6:5:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 07:55:58 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::c405:5d03:7aac:a7aa]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::c405:5d03:7aac:a7aa%5]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 07:55:58 +0000
Message-ID: <5a9d0e6a-2916-e791-a123-c8a957a3e3e5@nvidia.com>
Date:   Wed, 28 Sep 2022 10:55:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net v2 1/2] net: Fix return value of qdisc ingress
 handling on success
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
 <1664093662-32069-2-git-send-email-paulb@nvidia.com>
 <YzCXUN6bKSb762Pn@pop-os.localdomain>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <YzCXUN6bKSb762Pn@pop-os.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0364.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::16) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|DM6PR12MB4329:EE_
X-MS-Office365-Filtering-Correlation-Id: 5233a288-733e-4b42-a2cd-08daa126e0e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jw49Dj4IUIg2XxXGi3kN7n02mJdXCUuCZw2HTR/tiRgGRk/31LgGP5EkHVERjesfohLNMOq7qQDxjPcD/uEK4ionqQYwwh8WIcTSc3aaDnr5HMVMDT4UoX4PrmSRoSsBIgp3L7/uIS3ZnfmG2nlF1Yysowrk8yJRCiwbuFwxfHyzE7lh9MUyLQiO66N19cnlgCRy0VwzFC/VAhg5Jahhida7txGgTuxmr3jkiEVBYDJd73XjCGocFhmQObD4heknhPJAGKCOheqpjYJFoEFHSAkqkiaXO1PSbVHdNbR4oYNQx0eSzAa8uqUzOv+VHmAIeEkWEveG7NBIrIm6QhGxR+WNeGiK0VYEdeJ8eOb5L1R6ZpFoYp10bjuDRGDyg35p0AUaFtmUsZ8xULRNno2rVZHqXVUpMJNnEkIWI3ho6o6WNWZ2W0hQ+ILnbihNfM4jqZ1DV5p2yzSbtlQ5QNZXhbGFSzN/kiHWAMbsJ546191y999/PtQUjyNi8WaLk0wVgd6heptDoQgwSM6Xi7l/FuaIN+xmJ58DNRUc8JJerpm/D75pr3c8i6/8k5rpzIAAnFInd+zpIaWBtq4VdRvX7BBeC2endlHcMpjooGhGzGbLwOTafL2MRARdlDXL7Tu+A3CuWtYoXZAt8tNlqZZPFjqnL4EqUuEhdkA4Kx9PEIybimOWUxRBXPIgpa9646GBv/WIKllp4G01TyaRcwUA+dlYoSqVagr12JT//FpCETUYFJ5dRKaNuySbmCfFUR4yKC3PSbGsRtoSpTxyw5Ru3vhGVXr+NivuqdDpE1ldv8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199015)(54906003)(6916009)(316002)(5660300002)(8936002)(36756003)(31696002)(86362001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(2906002)(2616005)(26005)(6512007)(186003)(6666004)(478600001)(6506007)(53546011)(6486002)(38100700002)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3g1OUdrZWxWMWJ3S0VTbStERnJKTGJGN3lGd0owM1RHc2xNbzZEQitBL2Jy?=
 =?utf-8?B?R3pDM0Zlak5uSUdPOThObG9QcllkS011cGRnWHRPeXBwVmJ1bTNaYXZzMDhL?=
 =?utf-8?B?U055T0NpOUp0b0J4Q3BNSGxzQ2RtTTNqZGJrQWxjWjQ2RmlRaGNOTnA5Q3FL?=
 =?utf-8?B?Sm81Uko1SEwwY2QwSjJqZVNhenRtSUw3anA5cFZLdXhNRGhHVjNuQzVPTDRE?=
 =?utf-8?B?UTlYSThhcUZ2eGp1WTE0SEg0Ync4bFdrV3h3NEkwYm5TQmJiQ0dTWkEzL0VQ?=
 =?utf-8?B?Rjd1YmhlOEhMRnZSZUREOGZrbHdvVXdLSGJyUUtTeDJ3Z3gxSDQ0RXMzSmxa?=
 =?utf-8?B?OGJwa0F1UjFhL1huNXdjZmxhUEVzVUZLYlU2cXVyZ2EvMjByUzhvbXdLWjU5?=
 =?utf-8?B?Q3ZQc0VLSnpVYU9JYTdOZGlsTUQwemZPZDJaQXQyaHVRellWcVhpUTJ5MGM3?=
 =?utf-8?B?TkgwdWdPUVZlcWt5REkxREFzMG9zUHRpYVI2QkY0U3FWU1hxaUhCQm5BeGhF?=
 =?utf-8?B?V3FwUkdaSHNmWTlSenU0L3NnYzVSVDNRRmhleHdVWkd1dkFlbks5bXlvWVpN?=
 =?utf-8?B?dTNwRitTUTV0SlpCNUh2blA2L0cyMlpnZlZ1bGF6aUxlTk5yN25rV29SN3Bz?=
 =?utf-8?B?OXQxNG1keGhvaVBwSUZXSHZlWCt2N1phaWlBdmw2RXRjNU4rODZ0aUlyekU2?=
 =?utf-8?B?T2hBN0xWSlRQUE5XVFYrZG9tVjVCK3pDVTBIcGxxV3RRY29NL0c2Y2dKMHBV?=
 =?utf-8?B?aGhkelZYc0xmWk1MRG1URm5UWDNCUXRCdlF0T0pVc1gyT3NFRlNHY0toeDJj?=
 =?utf-8?B?d2FqamFCdDdqVThSbHQ1YVF2akdWVW1lbm8rVXM0alhSUHM5eDQ5cXViNjJU?=
 =?utf-8?B?cXkwR0ZRMEI3c0JlNWJQOWJGRmlSdFNVU3RrMG52Mm0yakZXcllzSUdkK1dS?=
 =?utf-8?B?Z0VtV0I5bmZhR0paN1ptK21DUWJiREhTZThWWitOZlFCRnJRN1k5UW0xc2hj?=
 =?utf-8?B?cURla3YvODJFalo2MmVmMEtTMWhGTFN4azRoVm5OR0VYb2FHY21KbUQyK09F?=
 =?utf-8?B?OFBJSGlBL1hteUJOdkcrVjNnMDdXUkN1VGNTQWJsSC9uZ1B1NFZxWktFaUlM?=
 =?utf-8?B?SDFDM0hLK0UvdE1vdDRCbkxod1RJMnV1dCs1S1FLdStqaVNYeHppQXkzU0wz?=
 =?utf-8?B?N0Y5eDQxSklnOG1WTHNTdm9yekxEaVJxdk54RmFCQWpZQVN2RXArb2dNaWZT?=
 =?utf-8?B?K2FSVmUwWDF1Y3pzaVlONnY5QWloalJpcVUwaERLODVvbXpteE52azhsVzlT?=
 =?utf-8?B?RkVkZUs4OS9kYlpueFNpUzJNbUtiQUw5R3NheXVDdWNUYVNiQjJxN0ZTdDZ5?=
 =?utf-8?B?SFVtOWo0OUpJclRlME1OUkt5SnVpbHY1SG5oZFhtUmVzancrVU9mUlpyMGtx?=
 =?utf-8?B?MXhXYnd3YUZYVXJTb1BaR2hpSk9kK04zTW03bGpHS0hFaGFaVmE1dXgzYzUy?=
 =?utf-8?B?RFZJZXQ1RGNYZzVRZ0tpOCtua0tIWTR4aEd5YytBWDI1NzdJb3E3c0pKWTRo?=
 =?utf-8?B?alo0VWlVYVYram84UUFJUk45V1VyUlVNUW1XNDNFOE1Vc2JuTmV5alozNVZj?=
 =?utf-8?B?bWRzWjBkbi9Lc0pFUjR4dXFZSWI5aFhRZG5NQzV4WDlMemJFVmlWYVkraWFm?=
 =?utf-8?B?OWY4b1EzTTBkQVF1TmJsdGtKTGN3bEY0eWtMdkNVbWhpVEViSVgxb0xIMGV2?=
 =?utf-8?B?bHlyZEdCUCt4SjRXNVZGaDJjQUJ5OFVSWjFqT0xJMXRFdUpYbmxZdXJVcVo2?=
 =?utf-8?B?bkZJMWNtSGpoSEpEWW91eUNtcEt5enV4Y0tsS2ZUc2NlWkpNY3JucW0zNzJT?=
 =?utf-8?B?VGFualBzb0Q4U2FmdlBIaXZFYjJyeXVVWnR2MTNjZVA2T2hlVjd6R0pOWFBE?=
 =?utf-8?B?VzZzamxYaWlza3Z5VDlIWVhaNDczVitEakh1M0FkbFBEQTBBYnViN1FXYVNp?=
 =?utf-8?B?MzI1K3ptQ3VvYWhLaTRiUlQvS1daVXNPQjU5NjcxbThVdFAxdjFHU3ZMamFH?=
 =?utf-8?B?THpsWFBnc05KT3kzUG9DcFF6Q1JSRkZvNENGVGxZQXh4VFhwTWQvRkdHbWN2?=
 =?utf-8?Q?SmIirS9YiOye+ACS9yNZavxoJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5233a288-733e-4b42-a2cd-08daa126e0e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 07:55:58.3108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvzDEbMwghDFpAVh+oRdXPeaP13mLOVvgSQa141X0ZeSLTxAxspuXlQxgnriPDtpS6hDPXy4+AnPzIqmM0IZhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4329
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/09/2022 21:00, Cong Wang wrote:
> On Sun, Sep 25, 2022 at 11:14:21AM +0300, Paul Blakey wrote:
>> Currently qdisc ingress handling (sch_handle_ingress()) doesn't
>> set a return value and it is left to the old return value of
>> the caller (__netif_receive_skb_core()) which is RX drop, so if
>> the packet is consumed, caller will stop and return this value
>> as if the packet was dropped.
>>
>> This causes a problem in the kernel tcp stack when having a
>> egress tc rule forwarding to a ingress tc rule.
>> The tcp stack sending packets on the device having the egress rule
>> will see the packets as not successfully transmitted (although they
>> actually were), will not advance it's internal state of sent data,
>> and packets returning on such tcp stream will be dropped by the tcp
>> stack with reason ack-of-unsent-data. See reproduction in [0] below.
>>
> 
> Hm, but how is this return value propagated to egress? I checked
> tcf_mirred_act() code, but don't see how it is even used there.
> 
> 318         err = tcf_mirred_forward(want_ingress, skb2);
> 319         if (err) {
> 320 out:
> 321                 tcf_action_inc_overlimit_qstats(&m->common);
> 322                 if (tcf_mirred_is_act_redirect(m_eaction))
> 323                         retval = TC_ACT_SHOT;
> 324         }
> 325         __this_cpu_dec(mirred_rec_level);
> 326
> 327         return retval;
> 
> 
> What am I missing?

for the ingress acting act_mirred it will return TC_ACT_CONSUMED above
the code you mentioned (since redirect=1, use_reinsert=1. Although 
TC_ACT_STOLEN which is the retval set for this action, will also act the 
same)


It is propagated as such (TX stack starting from tcp):

__tcp_transmit_skb
ip_queue_xmit
__ip_queue_xmit
ip_local_out
dst_output
ip_output
ip_finish_output
ip_finish_output2
neigh_output
neigh_hh_output
dev_queue_xmit
sch_handle_egress
   tcf_classify
   tcf_mirred_act
   tcf_mirred_forward
   netif_receive_skb
     # here we moved to ingress processing
     netif_receive_skb_internal
     __netif_receive_skb
     __netif_receive_skb_core
       sch_handle_ingress
         tcf_classify
         tcf_mirred_act
           tcf_mirred_forward
           tcf_dev_queue_xmit
           dev_queue_xmit
           # sends packet ...
         return TC_ACT_CONSUMED
       return NULL, and leaves *ret untouched
     return NET_RX_DROP
	...


> 
> Also, the offending commit is very old and this configuration is not
> uncommon at all, how could we even not notice this for such a long time?

I blamed the commit that left the ret value unset for the first time, 
but normally netif_receive_skb return value is ignored (as mentioned in 
the comment above it), this time it isn't ignored because it was chained 
to egress processing of the tcp transmit path. And this specific case 
where I chain tc ingress to tc egress came much later (with the commit
I blamed in v1 of this patch).

> 
> Thanks.

