Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F46D393373
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhE0QQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:16:59 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:57860
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237303AbhE0QQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 12:16:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y26HNcPnH4jIHn4FO5Im9/V9bs0dN3fcSg1rvJAhkBRTX9VVobrW21c9pjSaTEt6PY/aqBWcd7Uy97bMDUKpYK6ZTiHFft9dBon5/s3C8YpmKCEBODP3KGkFzMeylif69Lvixe/75YcinFhTvRBCOdrMy7ihZffu2W+HqKIyMPmoVJ2eG37kYe9AJK1KEo3IR9o0Z0Bj9GOwsXIZ6MqK+nCoeZdEEht0neATSOKZ6P6mf49yHRh9ndLELs5If/coUs0MGTICGgiBF8nirHfyuMy8ieIyz3H2pICo++WecewpjMDB5SJwYPWrs7ridgzabgL87m9RkC/ReOGx7+ImKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhh/ORsw5jQU+jgXM1ntOvvUKZeT3r55saHBDPdJssg=;
 b=R1u/Fh4/pA/4TaMs52TO0fg9CZHP0h0Ilog4+x3tx1kh9Rxgzs+LvG4Eh+2ynBxCCgpDZOq5IVNUr0CrP7nx26mSwv7R8xd3NnkeLM5VJhobLF/vG7NRGsZur5BzlpSN50b7D2wlJb3X9my4ZZfzYHo4H53BuQfmGeFdL4CbzE5PpB6IPgkdiNM6A8Tf0mlNjoz4y5NEJvUEIbhJxjVGPcqZsHbaNiVUlg/zmBnuJhP+Ac2fWh+u/qY+P7FPUFdgb9t2FrjB9FhGkiKUOVqJlUpklnSoZLoyxFjFy0bBGSkSm6lC+ey7uLKecujiQ3NGBloFHcQtUgyCDibmxPUEMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhh/ORsw5jQU+jgXM1ntOvvUKZeT3r55saHBDPdJssg=;
 b=qJvRofdcQ5y4xga1F6iP6A141fOKxiSrorU4Kj15q786UQYj4J1bUO574GUqiDMhaZcbICLAqzADiSPLOUGxHopsdDrDPGWRKOTOaJLDmgs71h7mjBnNt2rHS9fdCjXvVCU75vNgsfpnM1SzOGA/IJqjHB6IKYobUuAMAn0BSakX/o39gKdfx5zD24iBamXNFdUG643HKsox1kPPjjSVz7IjDaoepKLD9WSKmgkS0dDTLzT08GoAjZXnTeRpMwijwn7XR3dwBPrrxgZe9UG+KDzpQ7b38gQLh+ITChTsNe7Ia0txFMGKLNVpqkvzqUN+yCsPHMESf7MM8sdQNkDYEg==
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2935.namprd12.prod.outlook.com (2603:10b6:a03:131::12)
 by BY5PR12MB4323.namprd12.prod.outlook.com (2603:10b6:a03:211::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 27 May
 2021 16:14:31 +0000
Received: from BYAPR12MB2935.namprd12.prod.outlook.com
 ([fe80::a152:8901:e13d:b86b]) by BYAPR12MB2935.namprd12.prod.outlook.com
 ([fe80::a152:8901:e13d:b86b%2]) with mapi id 15.20.4173.021; Thu, 27 May 2021
 16:14:31 +0000
Subject: Re: [PATCH net] net/sched: act_ct: Fix ct template allocation for
 zone 0
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, paulb@nvidia.com, jiri@resnulli.us
References: <20210526170110.54864-1-lariel@nvidia.com>
 <YK76nZpfTBO904lU@horizon.localdomain>
 <021dab3f-9ca3-ffeb-b18a-24c9207a7000@nvidia.com>
 <YK+/zn0R+M4lYfC+@horizon.localdomain>
From:   Ariel Levkovich <lariel@nvidia.com>
Message-ID: <5db2e2b3-c768-661a-dc05-fa850c8d066a@nvidia.com>
Date:   Thu, 27 May 2021 12:14:21 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <YK+/zn0R+M4lYfC+@horizon.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [193.47.165.251]
X-ClientProxiedBy: AM8P251CA0025.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::30) To BYAPR12MB2935.namprd12.prod.outlook.com
 (2603:10b6:a03:131::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtdk-erikc-1.mtl.com (193.47.165.251) by AM8P251CA0025.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend Transport; Thu, 27 May 2021 16:14:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76645b70-36f7-418e-029a-08d9212a8275
X-MS-TrafficTypeDiagnostic: BY5PR12MB4323:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB43236BBD7034C52DC2F8405AB7239@BY5PR12MB4323.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FofxR1kVMoL76pdliyZpyM9cPMZCHziPE4T4x9wEGkpZeoHQBP0UzaTWlVRkEEBpyloJcxsDJdZo8D/L1K4B2rUKG8P3cWPwRkDu5dMr7eveK3jD/vznQ0es/W2RI1OjoHtZGTmCRTGAv9n2X30BBC9aGWZjCzk75DScxMs7J4zYxvIsY2fXEGlHdl1T1tRMZhvM6fvLjvDAQGqCGPzotyxXDE0GVWp9l39y9o8u2ss2KhLOkTby3m/x1rhHgzPxQG01z5QthaBVR7qG+XRXJpmHuP6Mp8etjpbqilAvlPzfOnleBal7ztxNSRaCu9aCucCw6P8TB6LS44wRAdY8Bd8hIPnkp+PpA9rzqbzBKgHtfBHLiwMgYo4cNk3SSPvIVWs5548455cteOEId9eU/CH02XgyHEJY5KZVyB1ueE0M5MVyKUzaGlT9KOPlfoScYhdWAflTe+JBe48PlL8AE9bRVplMQBzU8UaOKlIirtdeJUgulz4HkZefsgJ1fayyhlSNigMWGHBljdGr1Oj0lRQwDcbLtPKYCXfMQoFQpMsklqoPfhTA4k0QFIG9YbuS/wynxNqDrL0ZTSL2WLNvaoQpBHoR3iOZ9NgnIombS4PUjlMT6vco/oi6XdqOVgMSvfz22lgbt7ozVFP2Cnq9477gWSmSjmmv2yWO6Nn35BHNm5kMAgO2W7VZTJSibenN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2935.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(83380400001)(6916009)(53546011)(26005)(4326008)(36756003)(2906002)(6486002)(8936002)(16526019)(956004)(2616005)(186003)(66556008)(38100700002)(5660300002)(66946007)(8676002)(66476007)(31686004)(316002)(478600001)(6506007)(86362001)(6512007)(31696002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dDZYQ0lBcHd2TXV4T0txb0hLbVdmaEsyNUJsMzZiUjNWU2VKNi9tbW54WndQ?=
 =?utf-8?B?NjVXOXp0cm5ka2dpdVpIYW9oYkJERVBzYXVzSnhSYjBIZGh4dXRUVldHdkRk?=
 =?utf-8?B?NmgzQklNL3ovcFNhUDVqY0tXWC9qNVk2dkR5T3JJaVQyenh1UjJDOTBrNllQ?=
 =?utf-8?B?VkVwL0JjSHhIamNBbXhSYmZWdUdmT1RvYkswTkFDVThyeGMrcDFHQWp6WkhG?=
 =?utf-8?B?d1lZeGlLazFVcU1yZW5veVdjWllHNVRrZGtrWUdxRzNYd21CdGFmK0xyeEN0?=
 =?utf-8?B?cUkxZDZnbFpLbHExalpHeGVCcmFCb3U1WkEvUDBoZU81Z1R6QkxkTVh1UUkz?=
 =?utf-8?B?UXozbSs0N1VNR3Y2UDdYZ2huc0lOdlU0N1hXSllNU1czVU92MDFsWWtjaVky?=
 =?utf-8?B?Z2FwL0VDUFNtcFpvYjVvWHVDUWJqTHNuNzNDeGRtZUowVWpLa1pvenE3RmM1?=
 =?utf-8?B?ZFhIZkdtdnNac2RVQU5sU3M5SkVBaDFReUIybnJNVWZMVjhOQkxTeG5sR0NG?=
 =?utf-8?B?WTlWRG5yQjNPSHBJMkxXcDlZNGVDYWZZMVltMndWMEZ5WmJyb0N5WmovSFQ0?=
 =?utf-8?B?c1R2OHlXQjBVK0t0cFZiRGtBUnNESUhkTllEQXZDcnErVnhaYUJpaUNXY3VG?=
 =?utf-8?B?d3Rqd1haTGJjZGYxbVYvMVdyVi9LUXBtdmc2ZVBpaHBGdEZhSEJzU1ljZXpt?=
 =?utf-8?B?Z2dES2MyVi9CaUtMRTVUQWdpTlF5ME5TUWxPUkcrcUg3L2ZFMHVqUVovYzAz?=
 =?utf-8?B?MlVlS0trekZJUVdiOURZbjBPNEUzYjAwRlpQbUZ5Ty9iK05FcFUxdnlSUkFs?=
 =?utf-8?B?SXZERmhQOVZrY0k4YXg4VDhqdGNVR1JHOWlGZjFvZExyQnhDSHZaRkQ5RzA1?=
 =?utf-8?B?WVg3SW02T0Jza1lKOFJuUnBqQWViWEtFS1lPNHc1UStURXNFUlVBNVZJdkdD?=
 =?utf-8?B?RUxqbTV0SHpncnpKZC9LOGFwNVkxc2ZYNEh0V041WGFHa014TlArK1lBT1Uv?=
 =?utf-8?B?SjRkSEMrSEl2TDh6NkdLdklYdDJqYXFiekFGQVQyQUkrWjgvSkNUQW5SMlYr?=
 =?utf-8?B?VnZzbVBlNHNiR2dpYnhsYjVqYmdNUWgzN3lHYWJLNDlOejVjY2Jxb0ZOeXNj?=
 =?utf-8?B?ZWxsYnRIdHp5TkwreVBRaUc0bUZzL0NWUGJkcFdBL0U3VmRhN21COTdYdi84?=
 =?utf-8?B?WEJOdzh6dUZNVTFDL0xuMnFWTzRhOW50eStmanQzNUtZV1dQS2FhV1B4MjZr?=
 =?utf-8?B?NmlsSm9lS05yU3RMYTFhRE5FSHlQdWtBK1h5MW5hN1B4cTlia2FZVDVNV0VT?=
 =?utf-8?B?OEU3alJmVTBNajB3RktTbE1RRHBUMzdvYytvdUoxb0dXd0M4Tzg5dEhSTUV2?=
 =?utf-8?B?ei9TbUNHZFBXNnI0YzB2a0kycDNQbjJzaTNxVkJPUWZqTkwwWmxlZC9laFcw?=
 =?utf-8?B?S3ZBSkpzb1VLRFN6bWpERmNreVkyVXRqRGRWSElQcEllWFNBR3g3V251WkF4?=
 =?utf-8?B?b01tRUNZeC8xUFZiTDlVd1VoM3VTS2ZBbUNHRFV4dUZod1hDbnp3VjA1U1FX?=
 =?utf-8?B?VXc2Qi95QjRFYS9MK2RIN1NDTVc4dzJKbGdiOVZkeWFhU21reS9DOXZ2OTNP?=
 =?utf-8?B?bDdOaTQxMGpmS3NsVXl1VUtreHBlYis3RTlxSVBIcVIrTHRUMkpFM2FtMTNB?=
 =?utf-8?B?ZGRERmQ3YTN4UmxGYS9SN05UVVlHTXBJQkI3TWxibjhuc2VqMVNMc3lKd2U0?=
 =?utf-8?Q?dL3SJWDVvDghVlnIVgMy9jLYBQ+eDgT6xGw8rDJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76645b70-36f7-418e-029a-08d9212a8275
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2935.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 16:14:31.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: biI2UVgUREBcQvS/l0aHwfOLisHlHP3WX1lLzagNyaG0W9HAyV/1QggpRg5lJ44FyTelOxWeYF4UTdEFl3Eeuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4323
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/27/21 11:50 AM, Marcelo Ricardo Leitner wrote:
> On Thu, May 27, 2021 at 11:36:18AM -0400, Ariel Levkovich wrote:
>> On 5/26/21 9:49 PM, Marcelo Ricardo Leitner wrote:
>>> On Wed, May 26, 2021 at 08:01:10PM +0300, Ariel Levkovich wrote:
>>>> Fix current behavior of skipping template allocation in case the
>>>> ct action is in zone 0.
>>>>
>>>> Skipping the allocation may cause the datapath ct code to ignore the
>>>> entire ct action with all its attributes (commit, nat) in case the ct
>>>> action in zone 0 was preceded by a ct clear action.
>>>>
>>>> The ct clear action sets the ct_state to untracked and resets the
>>>> skb->_nfct pointer. Under these conditions and without an allocated
>>>> ct template, the skb->_nfct pointer will remain NULL which will
>>>> cause the tc ct action handler to exit without handling commit and nat
>>>> actions, if such exist.
>>>>
>>>> For example, the following rule in OVS dp:
>>>> recirc_id(0x2),ct_state(+new-est-rel-rpl+trk),ct_label(0/0x1), \
>>>> in_port(eth0),actions:ct_clear,ct(commit,nat(src=10.11.0.12)), \
>>>> recirc(0x37a)
>>>>
>>>> Will result in act_ct skipping the commit and nat actions in zone 0.
>>>>
>>>> The change removes the skipping of template allocation for zone 0 and
>>>> treats it the same as any other zone.
>>>>
>>>> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>>>> Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
>>>> ---
>>>>    net/sched/act_ct.c | 3 ---
>>> Hah! I guess I had looked only at netfilter code regarding
>>> NF_CT_DEFAULT_ZONE_ID.
>>>
>>>>    1 file changed, 3 deletions(-)
>>>>
>>>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>>>> index ec7a1c438df9..dfdfb677e6a9 100644
>>>> --- a/net/sched/act_ct.c
>>>> +++ b/net/sched/act_ct.c
>>>> @@ -1202,9 +1202,6 @@ static int tcf_ct_fill_params(struct net *net,
>>>>    				   sizeof(p->zone));
>>>>    	}
>>>> -	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
>>>> -		return 0;
>>>> -
>>> This patch makes act_ct behave like ovs kernel datapath, but I'm not
>>> sure ovs kernel is doing the right thing. :-) (jump to last paragraph
>>> for my suggestion, might ease the reading)
>>>
>>> As you described:
>>> "The ct clear action sets the ct_state to untracked and resets the
>>> skb->_nfct pointer." I think the problem lies on the first part, on
>>> setting it to untracked.
>>>
>>> That was introduced in ovs kernel on commit b8226962b1c4
>>> ("openvswitch: add ct_clear action") and AFAICT the idea there was to
>>> "reset it to original state" [A].
>>>
>>> Then ovs userspace has commit 0cdfddddb664 ("datapath: add ct_clear
>>> action") as well, a mirror of the one above. There, it is noted:
>>> "   - if IP_CT_UNTRACKED is not available use 0 as other nf_ct_set()
>>>        calls do. Since we're setting ct to NULL this is okay."
>>>
>>> Thing is, IP_CT_ESTABLISHED is the first member of enum
>>> ip_conntrack_info and evalutes 0, while IP_CT_UNTRACKED is actually:
>>> include/uapi/linux/netfilter/nf_conntrack_common.h:
>>>           /* only for userspace compatibility */
>>> #ifndef __KERNEL__
>>>           IP_CT_NEW_REPLY = IP_CT_NUMBER,
>>> #else
>>>           IP_CT_UNTRACKED = 7,
>>> #endif
>>>
>>> In the commits above, none of them mention that the packet should be
>>> set to Untracked. That's a different thing than "undoing CT"..
>>> That setting untrack here is the equivalent of:
>>>     # iptables -A ... -j CT --notrack
>>>
>>> Then, when it finally reaches nf_conntrack_in:
>>>             tmpl = nf_ct_get(skb, &ctinfo);
>>> 	      vvvv--- NULL if from act_ct and zone 0, !NULL if from ovs
>>>             if (tmpl || ctinfo == IP_CT_UNTRACKED) {
>>> 	                     ^^-- always true after ct_clear
>>>                     /* Previously seen (loopback or untracked)?  Ignore. */
>>>                     if ((tmpl && !nf_ct_is_template(tmpl)) ||
>>>                          ctinfo == IP_CT_UNTRACKED)
>>> 		              ^^--- always true..
>>>                             return NF_ACCEPT;
>>> 			  ^^ returns her
>>>                     skb->_nfct = 0;
>>>             }
>>>
>>> If ct_clear (act_ct and ovs) instead set it 0 (which, well, it's odd
>>> but maps to IP_CT_ESTABLISHED), it wouldn't match on the conditions
>>> above, and would do CT normally.
>>>
>>> With all that, what about keeping the check here, as it avoids an
>>> allocation that AFAICT is superfluous when not setting a zone != 0 and
>>> atomics for _get/_put, and changing ct_clear instead (act_ct and ovs),
>>> to NOT set the packet as IP_CT_UNTRACKED?
>>>
>>> Thanks,
>>> Marcelo
>> I understand your point. But if we go in this path, that means going into
>> zone 0,
>>
>> skb will not be associated with zone 0 unless there was a ct_clear action
>> prior to that.
>>
>> skb->_nfct will carry the pointer from previous zone. I see several
>> scenarios where this will
>>
>> be problematic.
> I don't follow why. When the skb is created, skb->_nfct is "entirely NULL",
> right? Done by the memset() on __alloc_skb().
>
> Then,
>
> @@ -950,7 +950,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>                  ct = nf_ct_get(skb, &ctinfo);
>                  if (ct) {
>                          nf_conntrack_put(&ct->ct_general);
> -                       nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
> +                       nf_ct_set(skb, NULL, 0);
>                  }
>
>                  goto out_clear;
>
> would restore it to that state and not have a pointer to the previous
> zone in skb->_nfct.
>
> Thanks,
>    Marcelo

I meant if there's no ct_clear action.

Assume we already when through zone X in some previous action.

In such case skb->_nfct has that zone's id.

Now, if we go to zone=0, we skip this entirely, since p->tmpl is NULL :

/* Associate skb with specified zone. */
                 if (tmpl) {
                         nf_conntrack_put(skb_nfct(skb));
nf_conntrack_get(&tmpl->ct_general);
                         nf_ct_set(skb, tmpl, IP_CT_NEW);
                 }


And then in nf_conntrack_in it continues with the previous zone:

err = nf_conntrack_in(skb, &state)

    calling ->   ret = resolve_normal_ct(tmpl, skb, dataoff,
                                   protonum, state);

            calling -> zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);


I encountered it by accident while running one of our test which was buggy

but due to the zone=0 bug the bug in the test was hidden and test passed.

Once I enabled my fix to alloc templated for zone=0 it was exposed.

The test doesn't use ct_clear between zones.


Ariel



>
>>
>> Thanks,
>>
>> Ariel
>>
>>>>    	nf_ct_zone_init(&zone, p->zone, NF_CT_DEFAULT_ZONE_DIR, 0);
>>>>    	tmpl = nf_ct_tmpl_alloc(net, &zone, GFP_KERNEL);
>>>>    	if (!tmpl) {
>>>> -- 
>>>> 2.25.2
>>>>
