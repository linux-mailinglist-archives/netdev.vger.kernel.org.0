Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F8A393285
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 17:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhE0PiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 11:38:03 -0400
Received: from mail-sn1anam02on2074.outbound.protection.outlook.com ([40.107.96.74]:16002
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235168AbhE0PiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 11:38:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjhQjTD3CyXu26XLewPJzK0z9am3/y3k9tcT7P/GyET0NimiSq4k7FZL6j4J0YFzOkwX0j/QCEVhzPuWCv2jLGcRoqQcBgLXNzeXZlZ3SGII6Ug2xW18/LBbLaIFDCGGJRiL9GqJ1DwxYI0Z34wF/e/ghvIYQQJsPrbgaV9g6TL6qUmxmR1rmWeQRG+qOwS+/W1J8Ve9y8NKxNi4QwPlGw9HIXSTg5zlCOxWINIELrwr8dDiTizOI9R32xUFnJHZuXFHW8TD7YeqykhPy8HSAqIeqV8pLc5uMgoSAaBPdT/BBKhLkjd8lWN/gTTlKhhkS/nceQ8XDp38Ze71tyIfPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXA4ZeiZx6HDS3llE33nH4QbOLgEcB7zHfvJDwZHBM8=;
 b=XsDhvTkQG6LLB1B9vPAq0XISYh8oekmCRsz+C0An1SYMbVg1eR2yKOn/0ulUzlFZ02F9/XUubZVixmy3Qp3zun1wPTTPyyC4sPGgphCsViV6bKFJxmxwpWx/TPmO7TxUEIrPEdbDHW3xBgXRbFRzFtOp+nTG/LlvxLNtijZuTprp5+8mRXpuxYkEiZaAu/RyPSdJXhotIOm7LeQ4jvbXuKrpn7RL7BVppwUwXEKcsCqnEYSliZjmu3ge19v/WkgcVlcQwXL2YPLdBUiTn6S4+bCpt5ac8etgGTD/gZBXCRnvwZ2Cx3sF4i6ZQHEfDdfigFlsozAgG3MIrscL6OSvCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXA4ZeiZx6HDS3llE33nH4QbOLgEcB7zHfvJDwZHBM8=;
 b=F4x2nK44xX9Wf5qlAHdOM5IaPhZCM7iJ02awJ509+O3rYSSkT/o+WtR7BsGX+fNxYjrCiidD5ve/TLe0EpyqqJyAN9RVPsA7Y0YgbgRwSIVq/ppRSuEvg+3RWiNwrUT3BKSOdl8oDUSF71HABQyX9E1/xR1EcwNfXIu1yvyf7TJMXnZw39ciVxzxiLkIgZufLhuGRb7gdegeNJFuNcw9qKQdlT7ekT6AsSzpx6m54bhvAC6FmA5Gi3TXwrveewqviowIo98BJxH8u6EpRvdWcj4N76IbYtKkjnVbU4xn5MK3ik5jsMXWPT7GAOS+vGuZFRkehVs8p/vxoa88MtNFTw==
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2935.namprd12.prod.outlook.com (2603:10b6:a03:131::12)
 by BYAPR12MB3366.namprd12.prod.outlook.com (2603:10b6:a03:db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 15:36:28 +0000
Received: from BYAPR12MB2935.namprd12.prod.outlook.com
 ([fe80::a152:8901:e13d:b86b]) by BYAPR12MB2935.namprd12.prod.outlook.com
 ([fe80::a152:8901:e13d:b86b%2]) with mapi id 15.20.4173.021; Thu, 27 May 2021
 15:36:28 +0000
Subject: Re: [PATCH net] net/sched: act_ct: Fix ct template allocation for
 zone 0
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, paulb@nvidia.com, jiri@resnulli.us
References: <20210526170110.54864-1-lariel@nvidia.com>
 <YK76nZpfTBO904lU@horizon.localdomain>
From:   Ariel Levkovich <lariel@nvidia.com>
Message-ID: <021dab3f-9ca3-ffeb-b18a-24c9207a7000@nvidia.com>
Date:   Thu, 27 May 2021 11:36:18 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <YK76nZpfTBO904lU@horizon.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [193.47.165.251]
X-ClientProxiedBy: FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::11) To BYAPR12MB2935.namprd12.prod.outlook.com
 (2603:10b6:a03:131::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtdk-erikc-1.mtl.com (193.47.165.251) by FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Thu, 27 May 2021 15:36:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7dbcbb3-6215-449e-a592-08d9212531b0
X-MS-TrafficTypeDiagnostic: BYAPR12MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB3366359C9C3A6EE7E1D13E8FB7239@BYAPR12MB3366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOohxdmJjl1OVAe5XS9Ey45zep3tvhsct6lTxMOJuBy6IY0qMzxKmFZHIsshm7jSab9dPXZXnZMRuAttz6w2hTdrpoVY93LMOvSVTFB2MhNNQkB+vywhVzmPq+JqeHSTZezT1cP0duiJmWI4VSJi71tLyTO1fmLTJtMC7wmVJyeJ4O2wWc0BCacEQod7z4eeKO1OYiXaJwx9O7QOUuY2ouQol9iz1WgY0Bt64SUs9X5vwaf+cU6iF2pygmFfSCkl6AEZ9CXjFrOy0fYHE3LGRTp0YmRW8c+WPu9B5BupuVHFsYLso75VmG6yniyyDMvOXtSvaURurT647dRC59SMJhyYkgXopJp5LMUXX6xhaTNRvy/Qs2g5+IwtIyLiifta2ZxqEU4KTvYjDH9HLErCarUtglP5hPng6SvUeOZ4nUZ57niXvKSy2yoRE/GCIZhgh24j0MUEVIdnlOrGrt6t+LI9DV7GvRN2uHS96j7cG1e7gQ0UVNsrqgw8KiKEtiTfDM0UpHq9GZ658rohCYAsUqPEjE6w05n46pT4PovJlm3Su/TuALl8H5PTEMbaWuxVwyS1gMqbThhKi6gjcGc99duC1UuF08PVykuCcKYrvZEJetpjPmRdgvqPUiYfp20bwLu1YKTJ92Qxdx5rvvaNt0/n2tIEYMBb+zlgv8BTlqm7PyRZJqA+ueo9mbTTg/h1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2935.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(346002)(396003)(5660300002)(8936002)(6512007)(478600001)(38100700002)(31696002)(36756003)(31686004)(6666004)(8676002)(16526019)(83380400001)(186003)(6486002)(26005)(316002)(53546011)(66556008)(6916009)(956004)(2616005)(66946007)(2906002)(66476007)(86362001)(6506007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SUFWWXptc1ExZkxoaWdwMGQxc1B2OGlkRWZWcUViVWFRRkZpeXhYR1VHN2JS?=
 =?utf-8?B?QU85YXVVVWJFQWJSMXBPTmJlcFBzai95bUJKZjJ3cElZS3pEOXEwOU90TnRl?=
 =?utf-8?B?N1RlTllTandVRnhQM0RFR2x0LzA5VndZekR3MXVwaGV1QzVzaVZMSjdyL3d5?=
 =?utf-8?B?WUlaZGNhTDdaZUpwbEI1Ti9IYm51NjVpR0dhL0d2bjZHQW91T21nelVHSFBr?=
 =?utf-8?B?SEpJdEpocU56KzlLWkJGTEJsUnFYNFhsTUloRWk2cHhTdlFDcC9mdUhEQmxK?=
 =?utf-8?B?T0o3Y0EwU2NEQld4M3lxMjNZUnhINTZOTmNKTHE4WCtXS0hVdmVSNm9BdlM5?=
 =?utf-8?B?UWt0VUYrVDF6VWVTUUg5N3F3SjJndXduZlJ6SitvZmtqNmJJTjl6WEU3bG80?=
 =?utf-8?B?QzJoSHVabGpvWWQwZXpjK1V6WFhKTkZ1SHozMUpLVlFwdUl4d2lCcmV0Nm5G?=
 =?utf-8?B?eVlabTZucjVlRStlTmZsRnIvbGVWZmFpQ0ZLTzNGa0Vlc2ZlanpOMWY1ZmZK?=
 =?utf-8?B?YmdaZ2pNdkxBWkRxbkthUnR0ZU02Ynowa2hEWmJiRmMrZklSWFFlNGdIRlRu?=
 =?utf-8?B?QmwxcWFqbWJPNDBEV210MDRBQmFTeFdiNGcyM3FWb3RMSlAzRzEvODlVRjBG?=
 =?utf-8?B?UUs3aUx6R1FiQWF6bDhDM0VJd2lyOWZSSzFyNFBZVlRlR2pOd2Y2bUF3VzE4?=
 =?utf-8?B?QUhaRS9weXRXTi9DRHpaN2ZIL2FEdDZNRkxYb1BCdnZCL0xveHRwQXRacHl5?=
 =?utf-8?B?THhWK05BbDhFMUdUVEsxeWRqTnlaL3N5OVFCbFFoYnY4QkYvSXFCSkk0T3BM?=
 =?utf-8?B?RFFrUUg3SW5uVkZnTEpYb25YakJENU5idnhERmhhc1dDbFF4aS9ETWN3b1Zh?=
 =?utf-8?B?akZ3dEsvRktkSHdtZkdqL0tBVERBUkZWLzlEUllvNnVzVitHS1Bkbk9ubWxt?=
 =?utf-8?B?bkVEcGQvbEp2eGhpcyt3S0NjMFhzc01NS0tVOVJUT2RhcittMlFPUVhFVHZU?=
 =?utf-8?B?dmI5UTlISCtJUHlMcElpTVNLNHRyR05yTy9oeXQzckUrWUtHTmhIUzhvcTFs?=
 =?utf-8?B?OEYzcThwODk5MlNUQjNaZ2gyelN0alFaUnc2MVlOSVpuSy9XK2tvVzd5czQ1?=
 =?utf-8?B?L2VMQnZDRzhrODFQUVpySDZFZnM2TnhYdk54aUkzU0YwTlZBSGlVS0dWTVFD?=
 =?utf-8?B?V2ZlRk1uNHFhV2tkK2ZCQm9RbWc0WExnU1BzdUpxYnh3dEhyaE50Nm1JY2h3?=
 =?utf-8?B?NUdpZFQxNGxjQVQ0R1pnWHRMb2RvQjBScVVyU1JyOEVTb3VSbnZlMGN5VGNV?=
 =?utf-8?B?MTBnZHVxcGdWMzJDTThhN29CYTdBbnhHcWUzeDl2NGRFS2lJaVhqRXd1VHhQ?=
 =?utf-8?B?a0dnVlpnUXRzMjRFNjl6aDRXSFRPUlhjT0QrYWtsSktSWnU1YUtEUTBMK0Zs?=
 =?utf-8?B?VFE1bVk2YUdmeUcwWWE5RGVPMzh5ZDJwelJFcGsySlM3NVM5dy8wNHpOZXph?=
 =?utf-8?B?SXhmcys5NWVkenpQOHR0blZ2N2JOU2xjT3IyOWpoSEdpQjZRQkNqUkRsbmJ5?=
 =?utf-8?B?azYwM1RyQ3ZjQ3E3dktCOHQ0Z2trTGM3Y2grSGQ4NEcrU005c3pwSDJyOUt2?=
 =?utf-8?B?ZEJhYmtnQlV2YmpaMTkvQVcvUUUvcUxtVXQvbExzSm5nTlhHaGxqVmE0V0pz?=
 =?utf-8?B?cDBuOGx4MTNMMFp6dlQ5Z24vR3ZNVGVFZEc0MWpGajVxUUMxYjBwOUlIbmhM?=
 =?utf-8?Q?/1zM1G6kxefMbz0RRJjfe7Af9NmYL2Ocx1A79IB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7dbcbb3-6215-449e-a592-08d9212531b0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2935.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 15:36:28.4360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32eI/CDsenI4XPUdOEiJ6JfAWufL8X4iFSujTb9pPsDBwC3D2Jpnx2VJGZ7u2RQGZETCY6RkrD2j81igBsJ8QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/26/21 9:49 PM, Marcelo Ricardo Leitner wrote:
> On Wed, May 26, 2021 at 08:01:10PM +0300, Ariel Levkovich wrote:
>> Fix current behavior of skipping template allocation in case the
>> ct action is in zone 0.
>>
>> Skipping the allocation may cause the datapath ct code to ignore the
>> entire ct action with all its attributes (commit, nat) in case the ct
>> action in zone 0 was preceded by a ct clear action.
>>
>> The ct clear action sets the ct_state to untracked and resets the
>> skb->_nfct pointer. Under these conditions and without an allocated
>> ct template, the skb->_nfct pointer will remain NULL which will
>> cause the tc ct action handler to exit without handling commit and nat
>> actions, if such exist.
>>
>> For example, the following rule in OVS dp:
>> recirc_id(0x2),ct_state(+new-est-rel-rpl+trk),ct_label(0/0x1), \
>> in_port(eth0),actions:ct_clear,ct(commit,nat(src=10.11.0.12)), \
>> recirc(0x37a)
>>
>> Will result in act_ct skipping the commit and nat actions in zone 0.
>>
>> The change removes the skipping of template allocation for zone 0 and
>> treats it the same as any other zone.
>>
>> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>> Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
>> ---
>>   net/sched/act_ct.c | 3 ---
> Hah! I guess I had looked only at netfilter code regarding
> NF_CT_DEFAULT_ZONE_ID.
>
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index ec7a1c438df9..dfdfb677e6a9 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -1202,9 +1202,6 @@ static int tcf_ct_fill_params(struct net *net,
>>   				   sizeof(p->zone));
>>   	}
>>   
>> -	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
>> -		return 0;
>> -
> This patch makes act_ct behave like ovs kernel datapath, but I'm not
> sure ovs kernel is doing the right thing. :-) (jump to last paragraph
> for my suggestion, might ease the reading)
>
> As you described:
> "The ct clear action sets the ct_state to untracked and resets the
> skb->_nfct pointer." I think the problem lies on the first part, on
> setting it to untracked.
>
> That was introduced in ovs kernel on commit b8226962b1c4
> ("openvswitch: add ct_clear action") and AFAICT the idea there was to
> "reset it to original state" [A].
>
> Then ovs userspace has commit 0cdfddddb664 ("datapath: add ct_clear
> action") as well, a mirror of the one above. There, it is noted:
> "   - if IP_CT_UNTRACKED is not available use 0 as other nf_ct_set()
>       calls do. Since we're setting ct to NULL this is okay."
>
> Thing is, IP_CT_ESTABLISHED is the first member of enum
> ip_conntrack_info and evalutes 0, while IP_CT_UNTRACKED is actually:
> include/uapi/linux/netfilter/nf_conntrack_common.h:
>          /* only for userspace compatibility */
> #ifndef __KERNEL__
>          IP_CT_NEW_REPLY = IP_CT_NUMBER,
> #else
>          IP_CT_UNTRACKED = 7,
> #endif
>
> In the commits above, none of them mention that the packet should be
> set to Untracked. That's a different thing than "undoing CT"..
> That setting untrack here is the equivalent of:
>    # iptables -A ... -j CT --notrack
>
> Then, when it finally reaches nf_conntrack_in:
>            tmpl = nf_ct_get(skb, &ctinfo);
> 	      vvvv--- NULL if from act_ct and zone 0, !NULL if from ovs
>            if (tmpl || ctinfo == IP_CT_UNTRACKED) {
> 	                     ^^-- always true after ct_clear
>                    /* Previously seen (loopback or untracked)?  Ignore. */
>                    if ((tmpl && !nf_ct_is_template(tmpl)) ||
>                         ctinfo == IP_CT_UNTRACKED)
> 		              ^^--- always true..
>                            return NF_ACCEPT;
> 			  ^^ returns her
>                    skb->_nfct = 0;
>            }
>
> If ct_clear (act_ct and ovs) instead set it 0 (which, well, it's odd
> but maps to IP_CT_ESTABLISHED), it wouldn't match on the conditions
> above, and would do CT normally.
>
> With all that, what about keeping the check here, as it avoids an
> allocation that AFAICT is superfluous when not setting a zone != 0 and
> atomics for _get/_put, and changing ct_clear instead (act_ct and ovs),
> to NOT set the packet as IP_CT_UNTRACKED?
>
> Thanks,
> Marcelo

I understand your point. But if we go in this path, that means going 
into zone 0,

skb will not be associated with zone 0 unless there was a ct_clear 
action prior to that.

skb->_nfct will carry the pointer from previous zone. I see several 
scenarios where this will

be problematic.


Thanks,

Ariel

>
>>   	nf_ct_zone_init(&zone, p->zone, NF_CT_DEFAULT_ZONE_DIR, 0);
>>   	tmpl = nf_ct_tmpl_alloc(net, &zone, GFP_KERNEL);
>>   	if (!tmpl) {
>> -- 
>> 2.25.2
>>
