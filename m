Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982C03F3ED1
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 11:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhHVJM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 05:12:57 -0400
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:56288
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231147AbhHVJM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 05:12:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbQOB9svEzBa59/+54+PDQCw0j19C6pD2IzzpCVYkk0gFPnMF0j/Z134krPujuFq7vvN+fP9SvrDWzwwVpMAwpI9HSGVyLqUqDjulS/jQ+qSDagXrYVRSlobtArrjSxhl/hWCrAP/kgLaa2F0RM3DHNWuygS4cxAmiKL4iHj7fnip7YQ/P41MXVAA5lehrwBChwgoSxCoUV3PWnBh1koPyUJImdc6Lk88C0t+Fc6kIDOC/HVBKPxLFFCNH7N2izG00y+BSYMn4a7vrM049BYS375gU8FVjO8RV95AsBxdDPikEOQzhpX5oEGyacilbeBFL4eFyrg0WilBdUt1gqWkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=no69iBVWnbGGG4NO7oebgD0kjN20zjSqCitlJLDMNgk=;
 b=TS6jv8XFBmegHzlZHYjeus46DFcwT/gIAATC2s4+nXYmb3MonDv2QupQnJNLA59EJsCSMN8FVBi7immBSYll0U6SzeBRKoYVIAexhERT+oy65argxgO63I54K6mm3RewMFTU87rDHc7cEmf1u7lv/b/UnbORd3cQNcj11jDgzzr2zHUeS+iwCsuPYrwUrqloKmgjaQ3XFjP10eKKjn1n35LNpuFKSETM9XbnAKgv9xBAPnC6zT6IKFB0yDq34P+apHjvhxDaOSh7ua2LEqIg65FU6Kqz3M+dU02/XRiRLgJIVZoF2Y8DV1BEdoLiSuC4mjPZ6kICXVqv6kx8IgekBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=no69iBVWnbGGG4NO7oebgD0kjN20zjSqCitlJLDMNgk=;
 b=JW5wNYa8sBNVc8XrQdBJJVvRqjwaY/7zaA8GgZytpS4mkKeNJgQo0KXw30C3GKlYdO+OuJFFpsIH9J1VmIZzTyME77NCYQ405+2jCulCMMzP3La+gE40vzi1HPXNbdc1vUpuan5M8JQoABiitlvEIzVMhW3ZNe2nCr+OvtffnRmDHw4MfMLHP4bXk+Deyt5itjUD0u1dM1kw3dofFsMKXSvRxBerT4q2JORKTcDN4gExiRvbqwvjbvdd4qMP3bORt3+byxyGb9FiI3Wlf6DK8ZdZB+8VpfwL/2LUwxFGWZrDcl6fbxDWkfEOzWN60A7lH5htmR8TwFXGnhjjboQabA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5358.namprd12.prod.outlook.com (2603:10b6:5:39c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sun, 22 Aug
 2021 09:12:14 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4436.024; Sun, 22 Aug 2021
 09:12:14 +0000
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
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
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder> <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder> <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com> <YSHzLKpixhCrrgJ0@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
Date:   Sun, 22 Aug 2021 12:12:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YSHzLKpixhCrrgJ0@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0010.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::20) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.111] (84.238.136.197) by ZRAP278CA0010.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 09:12:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be0959b4-7824-4121-4942-08d9654cee48
X-MS-TrafficTypeDiagnostic: DM4PR12MB5358:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5358B9F7E1EF6AB6E0C17988DFC39@DM4PR12MB5358.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12QzTjVGuQeoD1MS67zxMnxdx5HT/kyYYpD8n5yZucMppnblYrgPqjWSNWVNdvgR4yLnlMzfiC6A6aEXLVp8YUSAelW/Wqgw//KkCKIrDT44jVuvkkECzqqpl46HEbu3VpIGzE/toWYRqcyB2Nu6t5cK5WlhNRXcDd9Fx+7AUnoYnuJEC+qA7ON72VAnWBeW/nRVQsjpSW07Fk+O2TYtBH6774f4KTCLTPqW3vxICOHjB990O/qonn/bn/IsWgpPomzgC//9rHeN0PVNGSa0t19zwkyf0fcY7ahUtxJcXhDT5CcavHPV6qDQUhmk2dXJpiP/52jkRyb0k0XldNWmQezWoQkHK/EVGtCPZ5yC1abj/7S1qtwTSGiRC6FuzEGdqRsvqG6QU6gA3j/MrlTz+HP9zVoWsXOZ2ygNq+vfmca6oGFM/Sg5uYXgBCjxGxrcKLeXAV6mAQq0fEsRGNwVtuxFCTjxCJgLsQOmGXd+svsftG7hRtnCXp/sHLFogNYSxVqN4nI+lRy8GXVFD72gWeuWZkeKhtqXvZ60B2EcVdUxYqfgMDuydLQJH9CaKBKQn+fe0w0+D1kSzBD2HGtXy5JGjDI4t6yb15LTyoRd1r/ubc1yurUANsdu7b/rHIWLbOASPWbkfmH12cb5QqdCAVLi20ntPPLjZrpJIw82i11R26K4nzSq2/zRBCL9Cvie/zOt0mFizBr6wtLRsXz6m5cgLMX1ghFCTwVJAc90zmw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(7416002)(66946007)(5660300002)(66476007)(478600001)(2906002)(7406005)(38100700002)(2616005)(6666004)(8676002)(53546011)(8936002)(956004)(31696002)(31686004)(186003)(6486002)(83380400001)(66556008)(6916009)(36756003)(4326008)(86362001)(16576012)(316002)(26005)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGQ2S1ROT1dWbFRtRkdPTHBiUGlJVlQ4SmwxYU1aMWhaU0pxZlhLd3dqOVdj?=
 =?utf-8?B?MkErR2xERnZZYnpMSHpZQWRkMzBXaC9vWFg2Q21Rd2tiU2xQem1hdlZvdlZp?=
 =?utf-8?B?UG0weGpDbUZvdy9BWTJsUUFBUFVjMndtV2swTGo4S2MySXMvaFM2MDRPMUtB?=
 =?utf-8?B?cGZGN1FDUUR4MDJhZ2FYcHVqdmpjaTFDeXB3Y0JZUWJWUytXYjU3NjVBUU1t?=
 =?utf-8?B?SURwNWhzdVhkMm9mODZtM2ZXQ3k1YjV2S21hdmZnSGpsZnBsUmlXeHErbmM3?=
 =?utf-8?B?Yld5VjZtcnZ0S1VjQjBUOThJUHlVdmdRc2F6ck95ZUo0ZGNwNUdDWFY2all1?=
 =?utf-8?B?T2U5Qll3a1lhL1BTUDJmRmd0dmtUbU9BTVZQMzFlUmNTOWJHOXgzbW1mTTVi?=
 =?utf-8?B?blNacWVhWWhrRHZtd05pTEJIa3ljaFRiMGsyYSs4RmlmR1ZMaldGL09FQVN2?=
 =?utf-8?B?eUVVMGl5ZG5VQXA1ZFo2WXdaMWkxaGdhOEtZYnhYUSs0OUtGMVVPY1JmZlYy?=
 =?utf-8?B?cG5XUit1QlJLUXRqWDRVbDVtSWhMRjJYdXVQTUJXNzJjZzhUSTBqS3V4c3FS?=
 =?utf-8?B?RXpIUjdmS2k0Y0xFNHFFUUVGZ2IzSTBtSFFMZ1NyMlFtWmZlNzdraGE5OFh0?=
 =?utf-8?B?UTdFK2psQUtOOFh4OGtjRzZOYmpIV0FhKzBQb0NkTG1DMzM1OGFSa1NXWDFO?=
 =?utf-8?B?RmVvN3NxWStDbTJjaXJVSitON2N3VUVYdEQrTEdWdnliY2twQXlsbjVNRTU5?=
 =?utf-8?B?WG9tYkFFOE0ySVdscUt4c1NsYjVmamJCbXF4SGRnMGkwUUkvYVMwSERHTTlx?=
 =?utf-8?B?RnY5V2p1TDBBeitud24vR25LLzE3d0hmVGhicUpObURPQzBYSE1rbHd5S1lp?=
 =?utf-8?B?MXdkRERTeG9KMzY2SWF6cnFLTTZHZkhuQkNZeU1GRDZ4alhtSTdLQWoyU0N3?=
 =?utf-8?B?UEk4N2JoUktSTDBHc3JNQVVaeWNnVkxHYk9FMmcrdmlaOExzTXNva1ZSdjRy?=
 =?utf-8?B?QXhYZHh6VmR0REpvS1NxRWZLU1JQWDZKWnpMYUpJenQ0RFVPb3QrSHVSRDBk?=
 =?utf-8?B?dFZEcXJWL0hUYlZOUDZKSXFPRTg1RmVNbmpoZ2NDM3E4bUtFUWxRcE85NnAy?=
 =?utf-8?B?WitWR3dtRi9oSERCTnFkNDB1QXlyK2x6cFFEVkhGcGFSRnVOOXZtcHROSWsr?=
 =?utf-8?B?OUNYNVIvaEFkb1EvMmtlTUpyem1hQ3NHeE05U0RoUkx1RERRbEF4OHZlRERC?=
 =?utf-8?B?VVRhWmVOVHBYMTFVMUFOcVE1SGJwYXExL1FMN3gvZ2VJc2RoUnRyNEszaU5M?=
 =?utf-8?B?ZG5veTJNVlJOYUEvN1RRS0lvRTVwN3ZoclVuenc4WFdWcmNNekpUY1VpamZS?=
 =?utf-8?B?c00xQlpqcW9JdHdudCtIRHRGU29MQ3o0WTBRL0VpZUhPMUxNWkh2UjR6VHkr?=
 =?utf-8?B?YS9ObnpUTjZoUEVTTjRjYVk3ekRiVFZqd1VPUnUvVDQwZEgzMTZBbWlNNG9I?=
 =?utf-8?B?ZUZVQ25sTkoxZFNGcnZ1U3FtVGlaZFN5cG5FSklGTmkxKzVsZ2JGS0NGdU1D?=
 =?utf-8?B?R1d2VHpXTlU2WlZlS2NSUlVWbHI2alZubVplaWxEdFFKTldYNTRWOXp2MGxj?=
 =?utf-8?B?b2VLbmJYU1VmOHhzeHFNaXhwdmZTMFdRZmljaXVIcFRuUVJ6cndLWVJOVFhO?=
 =?utf-8?B?U2lCdWhpRVlRZkZSMG5Lb0llWEVTREIzNGZwWWY2MUtGeGRqQUV1VnJzZjZv?=
 =?utf-8?Q?AL69p2VNjFeV90YSS30P8IGnjz4MKn5COfZvzP1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0959b4-7824-4121-4942-08d9654cee48
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 09:12:14.2247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94H7EjZ575URa1vQGTOW073lsLD9yr5IIPKuTEnPYscDl3uB0PjQnaT7D4ask1vMAwvTnTvSMMSxaL8tR30l1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5358
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/08/2021 09:48, Ido Schimmel wrote:
> On Sat, Aug 21, 2021 at 02:36:26AM +0300, Nikolay Aleksandrov wrote:
>> On 20/08/2021 20:06, Vladimir Oltean wrote:
>>> On Fri, Aug 20, 2021 at 07:09:18PM +0300, Ido Schimmel wrote:
>>>> On Fri, Aug 20, 2021 at 12:37:23PM +0300, Vladimir Oltean wrote:
>>>>> On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
>>>>>> On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
>>>>>>> Problem statement:
>>>>>>>
>>>>>>> Any time a driver needs to create a private association between a bridge
>>>>>>> upper interface and use that association within its
>>>>>>> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
>>>>>>> entries deleted by the bridge when the port leaves. The issue is that
>>>>>>> all switchdev drivers schedule a work item to have sleepable context,
>>>>>>> and that work item can be actually scheduled after the port has left the
>>>>>>> bridge, which means the association might have already been broken by
>>>>>>> the time the scheduled FDB work item attempts to use it.
>>>>>>
>>>>>> This is handled in mlxsw by telling the device to flush the FDB entries
>>>>>> pointing to the {port, FID} when the VLAN is deleted (synchronously).
>>>>>
>>>>> Again, central solution vs mlxsw solution.
>>>>
>>>> Again, a solution is forced on everyone regardless if it benefits them
>>>> or not. List is bombarded with version after version until patches are
>>>> applied. *EXHAUSTING*.
>>>
>>> So if I replace "bombarded" with a more neutral word, isn't that how
>>> it's done though? What would you do if you wanted to achieve something
>>> but the framework stood in your way? Would you work around it to avoid
>>> bombarding the list?
>>>
>>>> With these patches, except DSA, everyone gets another queue_work() for
>>>> each FDB entry. In some cases, it completely misses the purpose of the
>>>> patchset.
>>>
>>> I also fail to see the point. Patch 3 will have to make things worse
>>> before they get better. It is like that in DSA too, and made more
>>> reasonable only in the last patch from the series.
>>>
>>> If I saw any middle-ground way, like keeping the notifiers on the atomic
>>> chain for unconverted drivers, I would have done it. But what do you do
>>> if more than one driver listens for one event, one driver wants it
>>> blocking, the other wants it atomic. Do you make the bridge emit it
>>> twice? That's even worse than having one useless queue_work() in some
>>> drivers.
>>>
>>> So if you think I can avoid that please tell me how.
>>>
>>
>> Hi,
>> I don't like the double-queuing for each fdb for everyone either, it's forcing them
>> to rework it asap due to inefficiency even though that shouldn't be necessary. In the
>> long run I hope everyone would migrate to such scheme, but perhaps we can do it gradually.
> 
> The fundamental problem is that these operations need to be deferred in
> the first place. It would have been much better if user space could get
> a synchronous feedback.
> 
> It all stems from the fact that control plane operations need to be done
> under a spin lock because the shared databases (e.g., FDB, MDB) or
> states (e.g., STP) that they are updating can also be updated from the
> data plane in softIRQ.
> 

Right, but changing that, as you've noted below, would require moving
the delaying to the bridge, I'd like to avoid that.

> I don't have a clean solution to this problem without doing a surgery in
> the bridge driver. Deferring updates from the data plane using a work
> queue and converting the spin locks to mutexes. This will also allow us
> to emit netlink notifications from process context and convert
> GFP_ATOMIC to GFP_KERNEL.
> 
> Is that something you consider as acceptable? Does anybody have a better
> idea?
> 

Moving the delays to the bridge for this purpose does not sound like a good solution,
I'd prefer the delaying to be done by the interested third party as in this case rather
than the bridge. If there's a solution that avoids delaying and doesn't hurt the software
fast-path then of course I'll be ok with that.
 
>> For most drivers this is introducing more work (as in processing) rather than helping
>> them right now, give them the option to convert to it on their own accord or bite
>> the bullet and convert everyone so the change won't affect them, it holds rtnl, it is blocking
>> I don't see why not convert everyone to just execute their otherwise queued work.
>> I'm sure driver maintainers would appreciate such help and would test and review it. You're
>> halfway there already..
>>
>> Cheers,
>>  Nik
>>
>>
>>
>>
>>
>>
>>
>>

