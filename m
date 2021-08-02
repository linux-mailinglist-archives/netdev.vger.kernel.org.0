Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF353DD473
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 13:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhHBLC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 07:02:56 -0400
Received: from mail-bn7nam10on2077.outbound.protection.outlook.com ([40.107.92.77]:20821
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233243AbhHBLCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 07:02:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAVL2n00mHNPRDxZR7wphRxsxLVrEKkATBqpcuZaBajbr+jpaMEIngbK45a3S8gKlVr3mhbNWyPO7hMlyG6sYXN3elXURU03owdDj0Y/emkMztpQQsSFMzxmuM06TTzHF4D0OkGPPSLBya65vJoruWf+bwMf3xkm9RocKzvKNtx/QaSj/Y0CdJox/wQ+pRKYj+ngjNJJ4tWSOTSpm35NExrTM5tKPSPbZYVH7fO0eVkicB8qaFMvPUcSdweiEYtI5JWgEW2G6UmuGavSQVlw9HSI1OJU/0cu7cf8ojgEZnaO2ISEdrnO9I+MNImwDjMnW4/zt0g0HfL10mybVk8W0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywcs/tl2tzJDict3NJJ63MkaBh5wAKFE8bXjr1SIXGw=;
 b=LBDYRjMrQTWNgfgOFnMzuWyVnox7v0YNXtv3NhAcUrW+NNQhKkiWYOcp2P/CAO+HuFdNWgx3uFoFBH0pu1xPWRDJxDp2fJuEYugLQ5yalA+AFBemvRqxg6kP5DsQqFhxFMBDU+V6F+cd7/9UWMgTji9nHOhlN/ULMlVosypxo3kH2mNWhTXksHGbQdst/BEUwycCpWGM/i9CUOD+X/Uokp25clYDZmDbLAzfzdv26vWw++FVum3bdNsS5LNt9Snz+H5bpxhZE4UKiKh/qEH9Ag0LSpNiWB/pZlXf3DYAL1scFsuZdQYBLUZjH6o9gZmCRNQoiKrBJ7WkAzIb8zglog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywcs/tl2tzJDict3NJJ63MkaBh5wAKFE8bXjr1SIXGw=;
 b=idOmZRcn2fGXGxUrbmJU0oXOEKPUx1LlwTtviA+D0Ixa5NDRqJzCIf6htwQa2SaLfOq5NkoiMTAzeOtTrYDSDCVcPKlBfpCvgIVdOBTWiUyTaqVPGVOcVrfdpqK8T37ybpWwuQr876IgguQrymW7F91uks1wBG1iL3K4IrCUFI9vE2BK83eJ4sYwDrIMN4sAIk3CIIAriNJ0ko5N0jikCNJkBWwwVJGSj4jlD/fYxys6FRVhjUObTDSwuH1uESGgnqFh0q5erJmsyJua/+9y49Y7DW+59hwXe0xGZyukX7owevvxzop/Vbfz7ysuFl+qzdspwc4nSkK5R91J/J6KCw==
Authentication-Results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5447.namprd12.prod.outlook.com (2603:10b6:8:36::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.17; Mon, 2 Aug 2021 11:02:44 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 11:02:44 +0000
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <ff6d11a2-2931-714a-7301-f624160a2d48@nvidia.com>
 <20210802092053.qyfkuhhqzxjyqf24@skbuf>
 <451c4538-eb77-2865-af74-777e51cd5c31@nvidia.com>
 <20210802105233.64r23kucu4mjnjsu@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4d85eacb-152e-8e4e-bb18-ad2814d249c1@nvidia.com>
Date:   Mon, 2 Aug 2021 14:02:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210802105233.64r23kucu4mjnjsu@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0118.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::15) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.206] (213.179.129.39) by ZR0P278CA0118.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Mon, 2 Aug 2021 11:02:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 279d42c3-2115-49de-818f-08d955a50e17
X-MS-TrafficTypeDiagnostic: DM8PR12MB5447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB54471A97218C37925FF53AF8DFEF9@DM8PR12MB5447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cqY8KXcm54uOlU3P3G/DdbmWYZL258oCJv1tNekZLCnOP7F+qIGHelkPtHdi9OFO2s77Lw1RW+n0yOrxiUJ26m/SnZ4s+QFt4+qGZjAS5QaBJ2Q5H2+bd2gKw8qTU+r3YRJimwlLlRgsWLw3MYwrn+YqiQcpwKc1OyDyW12w3tCrV7OLjOZ0lkCkhf5ZXdcP9CLKSB6BDtmu2JHxPqmT3x9o+qZGlQ6h4UDiBUJP/SuLT+nahy41Rx4ky3VVFNn6GiqsJbLDCcsqAgA3hTJCq3tXq6hxPKBMaPTy5zcffOkXwTnhsbJcduvne96Pa6dbzTw0OXH0dxVBzD4jXlK+b5jwRqUC7bZBb2NLuVlO+/+r5fDMQWzZSz9i9SG6r9ryjjY9BOj+dMIfonC6/wdReUIFWN3yq98W9VXLwjLekOOuCBCxjM94HlEMPM97XQr5YtVLviXcbxVsZzr+a38nTl8/CLRx65vAk6gMw0zuCn/+uk6tmW0+95RTXxykKWV22kwHzVmxq24KIXXhL5OSk5uhR9Yol6NPUUIVk7Rdw/GmTi3YmDZK5/u2g77ehP5MTcBNvo7bHunResc2CLfEKgITj4xSz2s1TUQWu2aqhRsAvOqQ4AlbPuczEgrkFT/ulVveBxIRHiGU+9S9H2NywE4fuN/mF4YEy9ihlXIJGgbhNDgSqkmJONGoO4gzXbgFjJmatOTwKUJ6iY+kNTUnmGHPs+6sUrQ9wla7kZ5ZDFHlX3KL3QlWnPEXKafzxv+j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(8936002)(316002)(2906002)(6916009)(16576012)(8676002)(66476007)(66556008)(4326008)(186003)(31696002)(66946007)(86362001)(36756003)(53546011)(54906003)(26005)(5660300002)(83380400001)(6486002)(2616005)(956004)(478600001)(38100700002)(31686004)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3lyM2Y4R0IrT3QzaFRabWdXTHVJU25nMG5TUkd6dDRXSGNJY1pyallmak95?=
 =?utf-8?B?VTArSytnMTJqRXUxWUhSYkw3VXkxOEtiOCticUV5MFYxamhaNGQ0SVBIU3Nr?=
 =?utf-8?B?Ly9mOXRHcVRjRjVxMytabVlLWWJCaThuVk5WNkhBNkYzQ1hWNlRkYmFjWHAx?=
 =?utf-8?B?Sm5mV01nVHVqbU0zOVc3MUk5NDRtV3ZlQ3lweHd1MFhyQmdOb1RGSTU2MElO?=
 =?utf-8?B?QmdnT29vcFA2NmdBZERGUnRpdklUNUxnZWd6eHp1dzVUSUM4SFVidE8yVFBq?=
 =?utf-8?B?Q3hoV3h6STNFWE02ZlpDL1Q4QWZpR2lKZjk4K0lqVnBVU1p5TGkvMHgrc3R2?=
 =?utf-8?B?eDk5eWFEU1lteWM0U2c1UzlIOHJtTEZxdk01WVNIVmJKbEdveXBLL0FJSEIw?=
 =?utf-8?B?TUNvQVFoM3NNbjlFSzd3QjROdi9uWnNQdUF3YUVlbXV1ODlpNjZUZ3ZFMGxE?=
 =?utf-8?B?RjBFMTZYbU5jSzFqdlN0Q2R4bVNJQ0tsa0VFa3FFV1pkY1hNV3BTWDgxR0Zj?=
 =?utf-8?B?aC9Eb3hndmZNU1hqakhhQlVxNlMvb2dKL2hyaGRzQzhjYUxHOXZqbHJrTWZS?=
 =?utf-8?B?OEJBd3puNHMwM2hjcjlQL001RVRHclZlZGtVUDI2NmxHKzRubnhGSlBKczl5?=
 =?utf-8?B?RzJxcWc2OWFxdFVoTGtaUmtBQjcyaEhMWGpINWlCeEFtU290RTJyNkp3SzJL?=
 =?utf-8?B?eERCL204TndNQ3R2THJ4ZzZFWlZxN2FlREVyY0tqRmgrZDM4TXlxVEd0bWta?=
 =?utf-8?B?U0VDalM5N1pQaEpiNGJoZUhHeEF5RFA0enNERGdjalFvWW9HWjl0Smw5dFlw?=
 =?utf-8?B?bHlNbU5ic0oyVzQ2NGtEeDBWckNQaVBzRHNrRDJmdjhqc0s2cjdiUkdlS3No?=
 =?utf-8?B?Q3JZRHNSVVdWM3ExSEE1U1d2TGFGK1BuK3J1Z3FPbDZvamdzUVc4eXVjaXNN?=
 =?utf-8?B?TS9lM1VoTkh0WW0wdmxocUIwOWdGc01MNkVkZ2RaOU1uZmZ6c0tuQ05ocXhK?=
 =?utf-8?B?NWNvcmQ3SlFTMnNFblRxeHkxZk9FaStJV1YyQkVya1hMaFNHZ091dHJPZ0dJ?=
 =?utf-8?B?Q1FnM0ZvTTV6V2R6MFl4Qm1jSVhNbG5qVG02STlkS1AvbUhxOWlGeHpSVGQ5?=
 =?utf-8?B?d29MQk5xYnhhMzl6c2NHanVHTEU3akhsZUlEanRkTEduTkdVZjJLV3ltOExL?=
 =?utf-8?B?bzBmdGxDYWF6T1FmL3B5dnduS2JXa1FvbTlJT2RKcUFuUGRFL2M2RlA3dTIy?=
 =?utf-8?B?cUp0cnpIKzZjSDA5eFBaZUYzTUxEYzBZak5SKzhmVUlITE9VQjJiWFE2cWdV?=
 =?utf-8?B?NlVwRFlSMzVDMzlPdFJlYmxDSE9ycGRwNWRkcHZrZ1hzbmhVNEtoS2RRaHBy?=
 =?utf-8?B?aDFqWnZhbWNCSTdJNEFSUWpKcW4zYTA0ZnZOTkhHdkM1Qy9OKytjWlJ6aDJC?=
 =?utf-8?B?bkFacTN5YW1aM3hpZXNkN2dNOGFSNUpmdUxwVmNJNlE4cUZtL2RraTNFbm0w?=
 =?utf-8?B?bTlrZDVsLzNWQnRiRy83QW8raEtnNTlkdkRYbzZKVCtPZEFURGdiZE92V29L?=
 =?utf-8?B?NU42WjQwMWExR21MY3Vsblk5RVBBV2F3WEVPZzJFeWc5SWxmWUNldHN0d0VZ?=
 =?utf-8?B?YmtvdVV4dk9mRmJ1ekhGSWtrV1M4Q3d6anAvb0xMeHh6QWxTVWNlMEc2amo5?=
 =?utf-8?B?aGM4VVFMalZXWEJidjJBTU4rOTd4ZnJHTGNKZ3BTbmFyWVpsUDRWYWI1OS91?=
 =?utf-8?Q?gyKXVH7RxmwxyBalh/s4hWcypwgTI7YzUeN6uGK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 279d42c3-2115-49de-818f-08d955a50e17
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 11:02:44.4868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ulZ51po5KSHrHy/cHAdR39TizyudVXewvBWfx3Dt4Xg4HbL5DnYTrPRmNj2/GmX9Q591Itbuy7zxT32TEBZXuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5447
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/08/2021 13:52, Vladimir Oltean wrote:
> On Mon, Aug 02, 2021 at 12:42:17PM +0300, Nikolay Aleksandrov wrote:
>>>>> Before, the two commands listed above both crashed the kernel in this
>>>>> check from br_switchdev_fdb_notify:
>>>>>
>>>>
>>>> Not before 52e4bec15546 though, the check used to be:
>>>> struct net_device *dev = dst ? dst->dev : br->dev;
>>>
>>> "Before", as in "before this patch, on net-next/linux-next".
>>>
>>
>> We still need that check, more below.
>>
>>>> which wouldn't crash. So the fixes tag below is incorrect, you could
>>>> add a weird extern learn entry, but it wouldn't crash the kernel.
>>>
>>> :)
>>>
>>> Is our only criterion whether a patch is buggy or not that it causes a
>>> NULL pointer dereference inside the kernel?
>>>
>>> I thought I'd mention the interaction with the net-next work for the
>>> sake of being thorough, and because this is how the syzcaller caught it
>>> by coincidence, but "kernel does not treat an FDB entry with the
>>> 'permanent' flag as permanent" is enough of a reason to submit this as a
>>
>> Not exactly right, you may add it as permanent but it doesn't get "permanent" flag set.
> 
> And that is the bug I am addressing here, no?
> 

Obviously I pointed to the statement above, I don't get the question here.

>> The actual bug is that it points to the bridge device, e.g. null dst without the flag.
>>
>>> bug fix for the commit that I pointed to. Granted, I don't have any use
>>> case with extern_learn, so probably your user space programs simply
>>> don't add permanent FDB entries, but as this is the kernel UAPI, it
>>> should nevertheless do whatever the user space is allowed to say. For a
>>> permanent FDB entry, that behavior is to stop forwarding for that MAC
>>> DA, and that behavior obviously was not taking place even before any
>>> change in br_switchdev_fdb_notify(), or even with CONFIG_NET_SWITCHDEV=n.
>>>
>>
>> Actually I believe there is still a bug in 52e4bec15546 even with this fix.
>> The flag can change after the dst has been read in br_switchdev_fdb_notify()
>> so in theory you could still do a null pointer dereference. fdb_notify()
>> can be called from a few places without locking. The code shouldn't dereference
>> the dst based on the flag.
> 
> Are you thinking of a specific code path that triggers a race between
> (a) a writer side doing WRITE_ONCE(fdb->dst, NULL) and then
>     set_bit(BR_FDB_LOCAL, &fdb->flags), exactly in this order, and

Visible order is not guaranteed, there are no barriers neither at writer nor reader
sides, especially when used without locking. So we cannot make any assumptions
about the order visibility of these writes.

> (b) a reader side catching that fdb exactly in between the above 2
>     statements, through fdb_notify or otherwise (br_fdb_replay)?
> 
> Because I don't see any.
> 
> Plus, I am a bit nervous about protecting against theoretical/unproven
> races in a way that masks real bugs, as we would be doing if I add an
> extra check in br_fdb_replay_one and br_switchdev_fdb_notify against the
> case where an entry has fdb->dst == NULL but not BR_FDB_LOCAL.
> 

The bits are _not_ visible atomically with the setting of ->dst. It is obvious
you must not dereference anything based on them, they are only indications when used
outside of locked regions and code must be able to deal with inconsistencies as that
is implied by the way they're used. It is a clear and obvious bug dereferencing based
on a bit that can change in parallel without any memory ordering guarantees.

You are not "masking" anything, but fixing what is currently buggy use of fdb bits.
As I already said - this doesn't fix the null deref bug completely, in fact it fixes a different
inconsistency, before at worst you'd get blackholed traffic for such entries now
you get a null pointer dereference.

>>
>> I'm okay with this change due to the null dst without permanent flag fix, but
>> it doesn't fully fix the null pointer dereference.
> 
> So is there any change that I should make to this patch?
> 

No, this patch is fine as-is.
