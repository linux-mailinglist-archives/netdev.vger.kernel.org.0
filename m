Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BC12FAC76
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438071AbhARVSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:18:43 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9828 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438023AbhARVSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 16:18:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6005fafe0000>; Mon, 18 Jan 2021 13:17:51 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 21:17:50 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 21:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pa2CHg3xpPAKViAj1MfwzekzZKwcZSnWCjO43JoI2QOCWCEEyb8MkZjdBAags6hUa/yVhkuHxu2pfWO4KAoEdWsVHgLzsRKxmHRYAgArJV1y8fxl5QVSOtebJXrZYNgB5sDnyXSFR0Ct+TdyhlwWmPW5zEkaicxoKsFBZJ+e6edo5rtVuy7+xt1a671HbYvFXkI8T6NH6zqQ/IxGVrtSgd6iGGmXNNbFZQMetxIrq/NpVl+PlWWvmHLsMkicsErExB2Ec46B5x/DufjWD2UswXVTWcQ1It0meR4dvSiQAkkstL5VtRPBewfLQ3i+lSSmLGhidecUxq7A1VGcPJo5kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxYEIOohooMjdZ8O4g4JjVbW62+3wpQrTKh/ZoO+DTI=;
 b=BjWTWVhnnBEu/L5M02tvSnmhIWUdWr7dvImgwSBHl1CxKuoSRB4U2HGTJJL0wiIf0DZo5/yxiJjp0QgmS1Fq7iBilIJAnbV5Z/eHzCexEc2zCz4Hyk19UJux09knhtUQcQrjs7EJzQyq8aZN4ryr1pMd4Pp7b2BRl5vYPFew1CbO06CfLWwcDu2P4Yj+CA2lwQZlpDbFvIPsxR8D41o4bYZAnjmB7187QGuOwC6NwY0lt34limAcDlhQ2YNus5iYNKYmWhQg1KDprqnhIJgc7KLVfkt3NKTkYBYmymwqHNTh+N9hR6b0agadB/JBPslkS4x7hkSy/ZV1vra1ooXwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 21:17:49 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 21:17:49 +0000
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <roopa@nvidia.com>, <netdev@vger.kernel.org>, <jiri@resnulli.us>,
        <idosch@idosch.org>, <stephen@networkplumber.org>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf> <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf> <87o8hmj8w0.fsf@waldekranz.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
Date:   Mon, 18 Jan 2021 23:17:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <87o8hmj8w0.fsf@waldekranz.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0069.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2a::20) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by GV0P278CA0069.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 21:17:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f4b328d-29e4-44de-4682-08d8bbf681ea
X-MS-TrafficTypeDiagnostic: DM6PR12MB4106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB410620C47A8F5CD0A3346FD8DFA40@DM6PR12MB4106.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4aadFb97GhYYwBXbL3r0FzCRjYUVPyglv/IB0gqH2Uwajp/b1NO8Fo9GnhAV5LffECt3AVjqd94jKxNVxL8K27sI1MQrkBVbUjn4JH48ydkI0Va9G8hf7fWOEqsGRi2XB0JVOQbXiVCXjU4jWXwglzekGZ699icMG68utVX/ymahZtw6vp8lWtkMwgZZTKBl+jKQxdLPO/BVag/Xe5TqE88SPQxyMj6mBwFl4UDcAYA8IVp3cu08ncQJFFYSZ89NMHnx01TDsha/3FWkK5OVOxgTrz884rxjckuvHB+PEaqnm2hVfMCsQLSMjVIt54gm1WY7DQrhdMAnbPxkDtiveIEdDz1t/r6q4Jb5R9OCBeUr65Z3FuuVrvhkP9iGjf0poAh4PYYfls0K0K3bDND+nsW9UuCg1/NLn0j2G2dxP4Ld3PlQO4lVYnj+vOJTmsQnPw1Q5+lUZI+4cE+/tKW6OWzeKjG9MkTL5YSA8wPwe8A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(16576012)(478600001)(316002)(110136005)(6486002)(66556008)(7416002)(31686004)(186003)(6666004)(26005)(53546011)(5660300002)(66476007)(66946007)(16526019)(956004)(15650500001)(83380400001)(8676002)(86362001)(31696002)(2616005)(8936002)(36756003)(4326008)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a1kwYlRwajAvbVNoZ0crQnFqR1FSMFRPUEpyL3JoOVgxSVBybnAvYytWZE5t?=
 =?utf-8?B?SFByYll3SWlIZHlpa2o2TTZaaGkxYlB0TVN6VVFTL3gwemtHNFFBVFpJaTk4?=
 =?utf-8?B?bHA1MGw0S1U4bHI4Y2tjU2F3Y05MMTBXekRRblZxMGNFY1E5SlhEcWwvQ2ZJ?=
 =?utf-8?B?ODc0VkdqUTF4bnkrblgrTGx2ODF2TmFaTDVQOCtGMzNUK0V3dE1xYjdtbTVs?=
 =?utf-8?B?RXd0Ujk2bTY5amgxdGhIV3Vab1JERXNzVWFiVERGZ29RVDlpQkFLOEZPQTJp?=
 =?utf-8?B?R2RxYW04TTE5Q01PWmc2aEtYM1A3bmRtUW1Kb2gwWUJpM3FRbXFqVXdZMHRM?=
 =?utf-8?B?YWRKb3VHcXRySDZMWTFtYi9BWFZJRDVTVVRzd1dIU2JZc2Z4T3c1aUlPb0U2?=
 =?utf-8?B?V3FxMThtYi8wczRlekl4K2VZdWJjZDBzWC94Y0xnLzJvTWFNNElrOU5zczlT?=
 =?utf-8?B?VGJOZ1dsRS95OXg5Sjd5ckRGZ1MrS1VEWkhCVERlWElHd0tNMUkwZVNiS3Iz?=
 =?utf-8?B?YnNZNnYwamhYY2JYN0U5WWxHU1pnbThFbzhsWEFROEZrOEhOamh5QUxSbUlD?=
 =?utf-8?B?VUJuQkpDY2pqc0QyWEVtQ2J0TUE2YWhnai9QbG1DYVk3d3Yxc1VTRHZqMHl2?=
 =?utf-8?B?dnNMUll5dzdWNTU0b2w3cWlkMUJxSHRtTFJXZDNYUE4xa2FEQTJHSG1EOEwx?=
 =?utf-8?B?VW40d1dlL0liMFRabEY0SmxkekxRa3pSUGdWcFd2eHVDdVR3dk52VzhINVlF?=
 =?utf-8?B?VjFHVzJsR1Jid1VqVUJORDRWdUhPWWF1WjB5MStIcUkrL3lBSEFHejQ4VTRq?=
 =?utf-8?B?WDlSR2Q5Rmw3QTRoa1gxYVd6LzNGdEJLZkxSdkxmUzJYZEgvcGFBUjkxblE1?=
 =?utf-8?B?am9Mczl5ME9ESDBnMzdFWVVIZVlSWkZIcWdUQzQ2cnhKcm43N3B1Q0pOTE5l?=
 =?utf-8?B?ODlXRlVaSytXc1dJbmYvVUhxYmZQTmFUVml1dnJIRnljTVZNc0YwTnR6ekc5?=
 =?utf-8?B?clNFY3dVT0UvZVFldFhZRnJLakx2T21IWGpydG84SkVtMWJyV0JYM1NXZVFJ?=
 =?utf-8?B?eWw0RnJlZWYrRWQwd3VpbWZWMEVkNUo3STA0aGxRckJjajhud0l5aktwMnRV?=
 =?utf-8?B?L0M5eEUvTmhIcnJBL3BENUY5Z0toZnBNeTJYZDBvRXRpUkd0TStlKzRBQVNU?=
 =?utf-8?B?S2wyeGQrSkJ0NVNmeE1ocUh0cU5HTjloeWRjS1hnS2x3MlliNGkwZzcxZHhC?=
 =?utf-8?B?QmR5UGllbURob2MwQU03OTFSUk9iOVpVeVdYYlUyZHFlWGlWWUNRTEpyLzZ6?=
 =?utf-8?B?U2R2dFZZYVFYNWlXVnFOYlMwc1ROT0VtTGJHNCtJaG5Ea0ZNaUJaY0NFRzlG?=
 =?utf-8?B?SHkvV3g1NFV2aFBSMWxJZ3BxQi9xUXYvVnc4bjN3VVgrdTVvS21hTUZzd3JG?=
 =?utf-8?Q?/UXQUuV4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4b328d-29e4-44de-4682-08d8bbf681ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 21:17:49.1178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tO55ZUOW/boptte/TnyxoMId6XVvDqXbiJnvvI+Sh3aZKpbnWlnZuCVNpKg1prDornT5rEjy2c/0/G/RbCFCng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611004671; bh=fxYEIOohooMjdZ8O4g4JjVbW62+3wpQrTKh/ZoO+DTI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=pp+oMYjjsVfW6AbeHdY6KYStkJ8f59+O6KwGrjLahQAbchBXCmLFESCIjBFwHoG+Z
         iwn9lBjwhqZ0Cgapgj5zK+BjndRCCJcuRGndFKNAm5t2U+khbHwaW6jpbrt6JiZqTt
         jac5kzHI2UN5t23uE3BwKci9rANCX/pY6h2JL8yuHQahtxMXzRnDacLFeNZ11ezUnt
         aRjaJRn1Sjz7ixWG3tJZ6zYeTlvl5m5oAuY0PeYdvVFf9HwT9hXgo+jnlSewkl1vvH
         fnhh1/q3dprJxzvdty56MX8L8ehcAKhE+g0qEJUOc2FCR1lDPi7b7DHeXZfuEIzJfo
         5Kx/OT7UCJylg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2021 22:19, Tobias Waldekranz wrote:
> On Mon, Jan 18, 2021 at 21:27, Vladimir Oltean <olteanv@gmail.com> wrote:
>> On Mon, Jan 18, 2021 at 07:58:59PM +0100, Tobias Waldekranz wrote:
>>> Ah I see, no I was not aware of that. I just saw that the entry towards
>>> the CPU was added to the ATU, which it would in both cases. I.e. from
>>> the switch's POV, in this setup:
>>>
>>>    br0
>>>    / \ (A)
>>> swp0 dummy0
>>>        (B)
>>>
>>> A "local" entry like (A), or a "static" entry like (B) means the same
>>> thing to the switch: "it is somewhere behind my CPU-port".
>>
>> Yes, except that if dummy0 was a real and non-switchdev interface, then
>> the "local" entry would probably break your traffic if what you meant
>> was "static".
> 
> Agreed.
> 
>>>> So I think there is a very real issue in that the FDB entries with the
>>>> is_local bit was never specified to switchdev thus far, and now suddenly
>>>> is. I'm sorry, but what you're saying in the commit message, that
>>>> "!added_by_user has so far been indistinguishable from is_local" is
>>>> simply false.
>>>
>>> Alright, so how do you do it? Here is the struct:
>>>
>>>     struct switchdev_notifier_fdb_info {
>>> 	struct switchdev_notifier_info info; /* must be first */
>>> 	const unsigned char *addr;
>>> 	u16 vid;
>>> 	u8 added_by_user:1,
>>> 	   offloaded:1;
>>>     };
>>>
>>> Which field separates a local address on swp0 from a dynamically learned
>>> address on swp0?
>>
>> None, that's the problem. Local addresses are already presented to
>> switchdev without saying that they're local. Which is the entire reason
>> that users are misled into thinking that the addresses are not local.
>>
>> I may have misread what you said, but to me, "!added_by_user has so far
>> been indistinguishable from is_local" means that:
>> - every struct switchdev_notifier_fdb_info with added_by_user == true
>>   also had an implicit is_local == false
>> - every struct switchdev_notifier_fdb_info with added_by_user == false
>>   also had an implicit is_local == true
>> It is _this_ that I deemed as clearly untrue.
>>
>> The is_local flag is not indistinguishable from !added_by_user, it is
>> indistinguishable full stop. Which makes it hard to work with in a
>> backwards-compatible way.
> 
> This was probably a semantic mistake on my part, we meant the same
> thing.
> 
>>> Ok, so just to see if I understand this correctly:
>>>
>>> The situation today it that `bridge fdb add ADDR dev DEV master` results
>>> in flows towards ADDR being sent to:
>>>
>>> 1. DEV if DEV belongs to a DSA switch.
>>> 2. To the host if DEV was a non-offloaded interface.
>>
>> Not quite. In the bridge software FDB, the entry is marked as is_local
>> in both cases, doesn't matter if the interface is offloaded or not.
>> Just that switchdev does not propagate the is_local flag, which makes
>> the switchdev listeners think it is not local. The interpretation of
>> that will probably vary among switchdev drivers.
>>
>> The subtlety is that for a non-offloading interface, the
>> misconfiguration (when you mean static but use local) is easy to catch.
>> Since only the entry from the software FDB will be hit, this means that
>> the frame will never be forwarded, so traffic will break.
>> But in the case of a switchdev offloading interface, the frames will hit
>> the hardware FDB entry more often than the software FDB entry. So
>> everything will work just fine and dandy even though it shouldn't.
> 
> Quite right.
> 
>>> With this series applied both would result in (2) which, while
>>> idiosyncratic, is as intended. But this of course runs the risk of
>>> breaking existing scripts which rely on the current behavior.
>>
>> Yes.
>>
>> My only hope is that we could just offload the entries pointing towards
>> br0, and ignore the local ones. But for that I would need the bridge
> 
> That was my initial approach. Unfortunately that breaks down when the
> bridge inherits its address from a port, i.e. the default case.
> 
> When the address is added to the bridge (fdb->dst == NULL), fdb_insert
> will find the previous local entry that is set on the port and bail out
> before sending a notification:
> 
> 	if (fdb) {
> 		/* it is okay to have multiple ports with same
> 		 * address, just use the first one.
> 		 */
> 		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
> 			return 0;
> 		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
> 		       source ? source->dev->name : br->dev->name, addr, vid);
> 		fdb_delete(br, fdb, true);
> 	}
> 
> You could change this so that a notification always is sent out. Or you
> could give precedence to !fdb->dst and update the existing entry.
> 
>> maintainers to clarify what is the difference between then, as I asked
>> in your other patch.
> 
> I am pretty sure they mean the same thing, I believe that !fdb->dst
> implies is_local. It is just that "bridge fdb add ADDR dev br0 self" is
> a new(er) thing, and before that there was "local" entries on ports.
> 
> Maybe I should try to get rid of the local flag in the bridge first, and
> then come back to this problem once that is done? Either way, I agree
> that 5/7 is all we want to add to DSA to get this working.
> 

BR_FDB_LOCAL and !fdb->dst are not the same thing, check fdb_add_entry().
You cannot get rid of it, !fdb->dst implies BR_FDB_LOCAL, but it's not
symmetrical.

Cheers,
 Nik


