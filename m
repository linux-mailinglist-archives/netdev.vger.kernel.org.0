Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D123B3F4DB1
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhHWPnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 11:43:20 -0400
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:12455
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231586AbhHWPnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 11:43:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RUt6w7WrV8Zw7JM7CrsEG4WT5xGQ3adP+Gvd7a7lkgyZun/KnN5uDoyGNdOfUJGl7ZUvkne5PltrivkEjaBmLdbXvWgJeNXmHptbwMmEv0Hq78kl8QS2c3n57Ar7BJQAkC9KSF1S9Wlb+Ro3KF4Zy2CV3o/IT4YiBsfOtls/MtlcNZv6aK6U2znCARF01GIxmaaUqCW9cmHsG1mp4LGLGECIfUuDNkt3FsRkmc8wK1uD/uNnRSCFkmFxHSJUudRZGjuZFcO++3dYCJxzcHOU7hoE5E/r7C/kAXBEdYAkA0YPXjcPi+YOszWv37EIPZcTY3RBLZbop+u/csFWFBCMjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeC/6TA8SQ65GFjRjqePo/wZt3CmVHkIQoKkDO1KkNU=;
 b=I094k1dd7FwafgRQph7vHUmDKWAkMImZwV10BeCZukGCXQnz6wNP8PTocbKzJd9HbyQnm/J5/2lowd0hTXM4zR16Bd/QaZBpA3YVx7Er3qN67ovzJSTzGmH9qeb/IJJA/tTLQF6FLMNadfm2zpQSNfiyS4uCjQdBnost+F+wnV8aK2m/u/va808nd8W395A9IYNS9FxPBTuZHOjI70khZr9e9GYbnTDtbOooRlBF1HpSfh/frND+HHKdLvX9mKG5v7advpw1UUrRC8k174a7OJGclyHrm1woDV6t/KX+1iwwmcIFtcg3njO9hnkaew7ygaO67gBKKZe4LyDgHFWkRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeC/6TA8SQ65GFjRjqePo/wZt3CmVHkIQoKkDO1KkNU=;
 b=pKL8qouLQIF0J/7Uv2NK4370+asYZZuboYO1nf18zo8c9qRSCgYq+ysqLWJvLu43G07OLi06VuDXINt+g/YvKKBJScHdJiJfbtGhXC8bsFc43JH+Lyt4wmAn4CshAuB/mjcJ+hQCHer4+ONBzBWp5EzNpnIKfWxehKiq+Hf++R03NHHjJzEz54gMfhFlhs4pKQe8wTsWLCzEV+J3+mP77Tq4DWDv1nGNXN54g9xUhlziaNMD4ooWh/Ngb6DbAb4BoxMXj8//YPOjrjT5DjVSf8n93dDrWQ4nQlrcvXLie8myFlYdSJqTO5p9xL6wHR7wOkhZg6jrrla8ukqg/e5tcg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5568.namprd12.prod.outlook.com (2603:10b6:5:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Mon, 23 Aug
 2021 15:42:36 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 15:42:36 +0000
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
To:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
 <YSHzLKpixhCrrgJ0@shredder> <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf> <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf> <YSN83d+wwLnba349@shredder>
 <20210823110046.xuuo37kpsxdbl6c2@skbuf> <YSORsKDOwklF19Gm@shredder>
 <20210823142953.gwapkdvwfgdvfrys@skbuf> <YSO8MK5Alv0yF9pr@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <5d3190a8-b0f2-f695-564f-318f1d1e4a0c@nvidia.com>
Date:   Mon, 23 Aug 2021 18:42:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YSO8MK5Alv0yF9pr@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0006.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::16) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.23] (213.179.129.39) by ZR0P278CA0006.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 15:42:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe678d30-09f4-4f46-9201-08d9664ca118
X-MS-TrafficTypeDiagnostic: DM6PR12MB5568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB5568220DC04ED312B5EE4774DFC49@DM6PR12MB5568.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZH/uP66YcS8FzoQQO1HVGcpX86msEDn0h8wbK8M4DRGf1+lv36HChU/WRfGu1UNj7u8rDQkXaHNB0f3aaO8E4NRtvs3L99Zgz7bXKvKHA6e9A+wiBs6HZR2EzYROqyCXw+n0AnUnC/JWGeSR9v5uXwf0p7DHnFCYMKIayJfOUtYFC4aOPv9Kll9sqvkwsGndFAAX93G6c2Ki2XjL6ee4FxDE8/0lTfCjkpOZUl5b1UeBwELVAWIvi1ZmfYe+6pD8v5xrLwVY4gKf+duFa459O4rsGNpLI3OHQTU+I2PN5qO5YNsaTDGNkLhR7xIdSvZHPCHGtSeAjI4hEWL0mtaniX3Ior1dQAodpH3+vQ4vxYcmdYdkazmLc4K7XcR5yoJ2NogEKCv5uLyeKREGGE+dVPco5H9fjOgn4nlO4sAVhqr/+0q2Gl/qYRGANwxWB0LrPB49LPqc9zESK0KI+gtEQeF3VGbeZ3sH2ugmtCMHk2ve+s/E5DE0QBm9PPj70Al+S1dWWhDdxjR3+9dyzCz8kieAPZj0wlSZ/V9QSVdM+k4NJ0uHXdwTN9VQJbRPXRZTLUJ12QM/IdGCkkCZEW7N1Lg4RAxPMrpv9B6PMgtOh6w9fH+s0TaMZw0JeY7a002OieQkqp6TPn0HqVjC+EAXOdgBOgBiVP8DIPJ5PQIEUtEqpmgX7/KzXvarKMAG3jEVFzC/dCTZ/oQEgLbGLDi1xhSR3a/TV/NfyK+Afjxcok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(2906002)(53546011)(31686004)(16576012)(7416002)(316002)(38100700002)(478600001)(6666004)(5660300002)(7406005)(110136005)(8936002)(4326008)(8676002)(66556008)(31696002)(26005)(86362001)(83380400001)(66946007)(2616005)(36756003)(66476007)(6486002)(54906003)(186003)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1UvUThPcXVQZnN5c2NreXBFL3FZSmJqck1iWkNEdHlPNUUwc3dxek9lOTRZ?=
 =?utf-8?B?aEkvWUlXQmJjZDhxOVZBTFFhZ2k3ZkF2Z3RPMzQyNXZOeUhLRy9vS3pOMmhv?=
 =?utf-8?B?MG1xbVNkZFF4dVgzRXREbWlFMzJoSDdKM1prdFY2cHdTTWh4T2NmVzFDMVBt?=
 =?utf-8?B?RVpKNnVsNHY3d0YxMWc2a3FwM1l3N1VZRWovWGdIZGhKZ29Yajd5QlFVZno1?=
 =?utf-8?B?RTJacm5QNnppcGpWQTN2RE5FY3M1cnVnWG1CYkYxcE15R3Vpd2dacDUwNmE2?=
 =?utf-8?B?d1BLemd6TzBYVnlBeC9neFV5ZmpEZVdHaFk2YnNFb3pOK081VzdOWTQwbUNp?=
 =?utf-8?B?R0c2ZXN3eHVEMTlidVZRbTFMbTNQd2JEbUd6a1UraFcxTzNLeXVHZVpBWjJX?=
 =?utf-8?B?SnJCd0t4cjdiUk0rb0xLSFFqUEg1N2E2dHRYT2RXTHFocDB4S05DUE1XZ2Ir?=
 =?utf-8?B?RmpTQkpKNk9MNkJoVzY3U0dSbVBUbFdjUDI1R0l2N3g1bkk1M0tOVVgrYVRh?=
 =?utf-8?B?L3BWQnRPWVd3YlUrenVIWld0Q1pGK0wwSFJwcG1JaWx3NHlCbEN2RUFPd1h2?=
 =?utf-8?B?WFJWUHAwU2gwd2tYaFhnSjVqQy9kTFE2eTJGelY0d0N1cU8vcjRhTll1dGlY?=
 =?utf-8?B?dWpTZ1RPT0o3VjFNcFNKYy9QTDFOVmU2amU5bmlXd1JYc0FId1k2dlBLam5x?=
 =?utf-8?B?Wm5KWTVZR1ZqWW9XRWh3bVVsUk1yLyszWTJVbjVzN255dmF5NERyZjltakZR?=
 =?utf-8?B?enVIWEdWcUpWbzhsZzVIaTU0b0JPOEYyczZPY2YvczlHZFZFQUdwaWtPSXpF?=
 =?utf-8?B?NXoyZ1UyNzVocUtLTmVGUlo0czM0TndtR2N4V2p0QXlJdTVKQ011Sm1aanZp?=
 =?utf-8?B?aUQ3enM4MFhjc2Nhb0FKY0VYMHdRU0lXQTVqd3NuNnJZYkUxTlhLL3k1SGRJ?=
 =?utf-8?B?YXVnbHBXWnVYOURWZ0lOeWh5TTFyVnh1MUZvaEl0S3NKd2VHR3Y5cm14M0Jz?=
 =?utf-8?B?cng3ZGdCSXI1S052OWJUdElBM3QxVk9zWUJoRUp5SGtyMFJ5NW9Mb24wYi9x?=
 =?utf-8?B?RjJlWHZJNE9aaUoyamRDQUQ2M3M5dUNIeVVPMk53VXlqZ1NpL1gyRnM3Z3dG?=
 =?utf-8?B?VjB3MEYzc2NpUFVtREdRcEttMlRMRytiQWdkTVYxSGRQTkxva3E4NUxyNjVE?=
 =?utf-8?B?VldrZ0JSM3VLWTZ3KzRpZllwQjNrS0RWQjdka0pQUkJEbktvUHFWbWM5dktW?=
 =?utf-8?B?ZUl4VXpUNXdFQ3VDYlVMSWVSZ04yYzdLMHIxRkdtcXVscFJzMEhCc3I0c081?=
 =?utf-8?B?Nko4Q1VJWGNaeUJKT2x1Z0FHNGN1d1RqaDY0em9Ldm42cmtBUTdjYWtvU0Ni?=
 =?utf-8?B?cE94c3VkTExoRnJVeE90TmJUYTd2LzNHYU0rKzQ3YXRYNmsyNkNjTWZ1dnEz?=
 =?utf-8?B?dmlqMDFNOHJKTTNwSGljNFRoM3dHamY0SXVTa01KSVR5VnQrSUpjOTdYdi9J?=
 =?utf-8?B?RW1tYjFCV1hZeENYU0pINFd2WUFoTGNOR2doaG1SRDJkTGt6WktsaEFiVy9l?=
 =?utf-8?B?eE0wQUhKUzIwUlptYXVlRVZmd29oUENxeEQ5QnFMWUZVc085NCtKSTRJSVRS?=
 =?utf-8?B?U094bE9VdGh2RzVhRkZiaVFmbUFCbFk0YW8zb1B2S0dHbVNuSUx5ZTVpTENW?=
 =?utf-8?B?bTJuU0lFb2JyYVV6TnJHZ3BnTzhDNm5ZNGVqVXk2eVlIYitod0dOV2JHOXdS?=
 =?utf-8?Q?IXpi+uWTO08a9WXGdStQA6xhPCEyreL2LA8m8Fo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe678d30-09f4-4f46-9201-08d9664ca118
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 15:42:35.8524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i+ZP1CMV+kC5Lms4XJFprWj4UO9olst3lA7K4DLZryoFYWWZtaFywjrOWBbSQD7/wnsTZgGx9dwDGGyY3mmK0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5568
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/08/2021 18:18, Ido Schimmel wrote:
> On Mon, Aug 23, 2021 at 05:29:53PM +0300, Vladimir Oltean wrote:
>> On Mon, Aug 23, 2021 at 03:16:48PM +0300, Ido Schimmel wrote:
>>> I was thinking about the following case:
>>>
>>> t0 - <MAC1,VID1,P1> is added in syscall context under 'hash_lock'
>>> t1 - br_fdb_delete_by_port() flushes entries under 'hash_lock' in
>>>      response to STP state. Notifications are added to 'deferred' list
>>> t2 - switchdev_deferred_process() is called in syscall context
>>> t3 - <MAC1,VID1,P1> is notified as blocking
>>>
>>> Updates to the SW FDB are protected by 'hash_lock', but updates to the
>>> HW FDB are not. In this case, <MAC1,VID1,P1> does not exist in SW, but
>>> it will exist in HW.
>>>
>>> Another case assuming switchdev_deferred_process() is called first:
>>>
>>> t0 - switchdev_deferred_process() is called in syscall context
>>> t1 - <MAC1,VID,P1> is learned under 'hash_lock'. Notification is added
>>>      to 'deferred' list
>>> t2 - <MAC1,VID1,P1> is modified in syscall context under 'hash_lock' to
>>>      <MAC1,VID1,P2>
>>> t3 - <MAC1,VID1,P2> is notified as blocking
>>> t4 - <MAC1,VID1,P1> is notified as blocking (next time the 'deferred'
>>>      list is processed)
>>>
>>> In this case, the HW will have <MAC1,VID1,P1>, but SW will have
>>> <MAC1,VID1,P2>
>>
>> Ok, so if the hardware FDB entry needs to be updated under the same
>> hash_lock as the software FDB entry, then it seems that the goal of
>> updating the hardware FDB synchronously and in a sleepable manner is if
>> the data path defers the learning to sleepable context too. That in turn
>> means that there will be 'dead time' between the reception of a packet
>> from a given {MAC SA, VID} flow and the learning of that address. So I
>> don't think that is really desirable. So I don't know if it is actually
>> realistic to do this.
>>
>> Can we drop it from the requirements of this change, or do you feel like
>> it's not worth it to make my change if this problem is not solved?
> 
> I didn't pose it as a requirement, but as a desirable goal that I don't
> know how to achieve w/o a surgery in the bridge driver that Nik and you
> (understandably) don't like.
> 
> Regarding a more practical solution, earlier versions (not what you
> posted yesterday) have the undesirable properties of being both
> asynchronous (current state) and mandating RTNL to be held. If we are
> going with the asynchronous model, then I think we should have a model
> that doesn't force RTNL and allows batching.
> 
> I have the following proposal, which I believe solves your problem and
> allows for batching without RTNL:
> 
> The pattern of enqueuing a work item per-entry is not very smart.
> Instead, it is better to to add the notification info to a list
> (protected by a spin lock) and scheduling a single work item whose
> purpose is to dequeue entries from this list and batch process them.
> 
> Inside the work item you would do something like:
> 
> spin_lock_bh()
> list_splice_init()
> spin_unlock_bh()
> 
> mutex_lock() // rtnl or preferably private lock
> list_for_each_entry_safe() 
> 	// process entry
> 	cond_resched()
> mutex_unlock()
> 
> In del_nbp(), after br_fdb_delete_by_port(), the bridge will emit some
> new blocking event (e.g., SWITCHDEV_FDB_FLUSH_TO_DEVICE) that will
> instruct the driver to flush all its pending FDB notifications. You
> don't strictly need this notification because of the
> netdev_upper_dev_unlink() that follows, but it helps in making things
> more structured.
> 

I was also thinking about a solution along these lines, I like this proposition.

> Pros:
> 
> 1. Solves your problem?
> 2. Pattern is not worse than what we currently have
> 3. Does not force RTNL
> 4. Allows for batching. For example, mlxsw has the ability to program up
> to 64 entries in one transaction with the device. I assume other devices
> in the same grade have similar capabilities

Batching would help a lot even if we don't remove rtnl, on loaded systems rtnl itself
is a bottleneck and we've seen crazy delays in commands because of contention. That
coupled with the ability to program multiple entries would be a nice win.

> 
> Cons:
> 
> 1. Asynchronous
> 2. Pattern we will see in multiple drivers? Can consider migrating it
> into switchdev itself at some point
> 3. Something I missed / overlooked
> >> There is of course the option of going half-way too, just like for
>> SWITCHDEV_PORT_ATTR_SET. You notify it once, synchronously, on the
>> atomic chain, the switchdev throws as many errors as it can reasonably
>> can, then you defer the actual installation which means a hardware access.
> 
> Yes, the above proposal has the same property. You can throw errors
> before enqueueing the notification info on your list.
> 

Thanks,
 Nik
