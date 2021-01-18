Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9C32FACE3
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388730AbhARVmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:42:47 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19911 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394861AbhARVkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 16:40:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600600190000>; Mon, 18 Jan 2021 13:39:37 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 21:39:37 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 21:39:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdlPSf6mn3vU2UMn1sbCethV512kwtJL6fthJFtt3TNnDELb8C0gwdLc+1wgh1w32HRH2v8yixXV8x9xu6JGQih5i1GYuRmvgzTXnIJ6F1mowmfhLf6Ssoqpv81bJAOb+orHzRcsy+HSF2PYltiTrjCkI5icH6hFRo9Jrc5QG5yvTYiZ5ceMq6ZHFTUIt8oWKu1Sg4334rbRN0FbZrfLuWwVAe0mcY6aO1OSBYCxYe/qsZn/79VuK/alNcK5outd+QCEXH4ZJG2gS5us6BLEOYbO/EMQnSl0LaJHIzPMYSZOKwhCKrGZTrn1jgUzUjL2XiUvUOl1QZ353sm++zeU3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdfYBvMa8LNyHkRyEtaHStOZr794nuxZw02BF6Zfg5c=;
 b=DB12L0k6syCaaJf06T4IJQ3eR/RoO2l+g7JZUV7HXTjewuG0fsFVnSiu7dHTLyBxgmwIZOsUPRujNvq7GUpE1bovU/xv0OTZFBC7JVUb0iXrEP9I65DI7YF2prz4Kk/jcFCX+yef1YdAd+c82klllhZnlYyjXdFBWV6/TvBcaNjT5NeLRsp/lkZpOGnJOhqnr6sFEn1A2+Lavdz1qmalnx9esG0sF2WxrM1tZXuNR5v4dgayvttRXW2twdEnoP0zwZ7upXgTzrx4ShDniD0VsEIBFi6cqW9J5SjaCbHpqXPeXFi3WVAiE6Isfv00vaBfPpHOp+0IImnNROQ3IEHr6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB2684.namprd12.prod.outlook.com (2603:10b6:5:4a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 21:39:36 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 21:39:36 +0000
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
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
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
 <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
Message-ID: <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
Date:   Mon, 18 Jan 2021 23:39:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0037.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::6) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by ZR0P278CA0037.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 21:39:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0eb67ccf-be02-4b23-537a-08d8bbf98ccd
X-MS-TrafficTypeDiagnostic: DM6PR12MB2684:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB26841106D59F9F6D71F52840DFA40@DM6PR12MB2684.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SiEPcdhzlw0h63OQVw03vbdaNzL8NBtvjug4unMw8ZjsP6eRSWGHP7kKIi7tAt/MuLrEISg11Kj1Q+W9bXHTL05wA4vJJN7Ffh3UG41vZiMkA8brN0yJoW5M7C4AWxQmk/PtpSoOkmeFtnBVWaynDlHGRTIKcc5VOOCsWlCr7fS0Hc3/TNJjv/ACzjdETifzZrrm0l1rYF75HuL7JywoPAYzw+ZifoHjK2LSjAbC8p3eNWzP9wzMIU02YLwDM2h3ukkiPpkORzYya5UWifZv2WLw2MgcHQPYto6sl1YsJ2wMo1CVTHyttkJsTMaglV18jtNG6gyGRg28jJHe2hqK8qUJxikqi6xR5iq06aXRlB+irhJtPK8PFZMXbIV3l9z0a2D+59V2EcqNLR2fKRlntJ/Bi7ya17RTe4CmQ/i9brCLR79TC9yXQuWoSygRAkQsKtrJIUFIusNT4jemdpZYZ24xDUPOdG2Wua58kfHFz6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(26005)(316002)(4326008)(31686004)(7416002)(8936002)(6666004)(5660300002)(16576012)(110136005)(186003)(16526019)(31696002)(2906002)(83380400001)(53546011)(66476007)(66946007)(66556008)(36756003)(86362001)(478600001)(2616005)(15650500001)(956004)(6486002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dXlCb2VtUGZJWCtBNlg4VTk0dW5mUmNra2x0RHF0VHRXNWNjUXlkMEgxWVg3?=
 =?utf-8?B?SHdaTkxzaXpnOGNvanpPQWRMdzJoY0UwQ0pjQy9QaTcvTEVnczZUNERXT0dm?=
 =?utf-8?B?Z3lCVEVRWW9tUGJ2VTd3elV2bERFUEpQeXZRelpWRkxOUnpsTm1Qb2FUNHRm?=
 =?utf-8?B?ZE9pK0o0Sld6VUJGaVpvK0YzeWx5YW1NOSs1S1plY0pyVGsxYW40REdKaVdX?=
 =?utf-8?B?RDVXdzgyU0w2dUF4cENIL2dWYk9pMXNKTjFQaHp4czRDcG5nbjlNZUNPejh3?=
 =?utf-8?B?bkpDemFQdzRzZlNaQ1hCMGc2aURabStSazNRSmdmNmh0MnhYZFIwckdpQjBV?=
 =?utf-8?B?QTBxMW1GUWFkVEYrR1cydnJoQ0s5alpWaWg5MmVkZ28vTmUzTTVvdDhIYkIr?=
 =?utf-8?B?OGY2SlRoWm1oSTFDN1ErVTVpMm9oMjlnOGZPYXFjL1VPN2xUeDhDUjlDYWF2?=
 =?utf-8?B?YTBmVGxvOFkrR29WMVYvOVVIcjA4Rk5PcFptNVQ2NFZGVVNybmFZSEhMTnh3?=
 =?utf-8?B?Zm1lTHdtY0NUQzR0RUFuUXFBQ2UwcXZTVHozL05WSXp5b2lYcGpHQXlJWU5K?=
 =?utf-8?B?REFHeHQxT1o5TzU0NmRPOHlWVTQ0aEZpRFIvWmNJT2ZkdElES0lSR0FiSzlr?=
 =?utf-8?B?cjVoRGhzYUdxOFdxN1Jrcjg1RE5keTJ1b3ozaFowbWZiaUMzK1ZKdmkyMmlo?=
 =?utf-8?B?TlRqejFjTXZpYkdmYUVDWnlYeDFmdVpPVnZlOFlKL05Nc3lXdm0rVk1FN1lK?=
 =?utf-8?B?cHBVZ1laZDVaM2loS1Z2ZlpKamhVRjAxS24xVWpmaEpqRmNLOE44SzF0UDFm?=
 =?utf-8?B?VUFPSE5KSWZXQ0R2Wm5JZC9PbzdjWHhUVDJWR3lVMlBHR1lkK1VPQUprUnRW?=
 =?utf-8?B?SXBxR09VQzJVSmNQcXpyUXhmKzZBMFBqV1RySHZ0TzFGMjRFblB1ajJMOG9a?=
 =?utf-8?B?L0w3OVprRmxGM1Q2cEdZQlNGd21maElXbUZRRHBSeG5XdXlTUUE5a1podklN?=
 =?utf-8?B?YjFnOGhQeSsvQWZQZmt4T0U5UGZzdUIwdFhWY2wwdkRRMGZwS0ZCSEZENjJk?=
 =?utf-8?B?Ykhad3pSdXV0Mnh6T2RiSHVzOVp3SUJmZGx6UUZXeFJOU1BqR3NRdUpnaUow?=
 =?utf-8?B?dlFEblE1T0Noamg3RVBYR2k5ekRBb2JScm50OUM1MVV4NVVVcE4yWHdZLzVU?=
 =?utf-8?B?L1hNVUEvWlh2Znk5U1VrVGc1U29oOXg1ODh5OWIwNXN3TnErcndPSFVMYVM5?=
 =?utf-8?B?enpCeTFnVW0yTEwveGxBRzlzUTlsb3hNUFAvVlNza29hYVRLcEZHZ3JHYWNE?=
 =?utf-8?B?bURYSGZJUGJCdWVGaDFtUHAvSTBiVUR1cmdMSmpIUmJQVmZNNGc4UlRCOVl4?=
 =?utf-8?B?ZUxGdlk3N2lUc3J2VUgyK3U1R0lkVy94cFBQL1pVQURNTnNWbEU5Y0xEL3pC?=
 =?utf-8?Q?y0aKxOvC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb67ccf-be02-4b23-537a-08d8bbf98ccd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 21:39:35.8891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iALrsGICAQgJR9/tagnXktb+7RWhi9FkYu+oi0JO9NT4J5YF045Watnz/qsD3fHvhYN6hEdb/rqIM9ZmOIv1PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2684
X-OriginatorOrg: Nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2021 23:22, Nikolay Aleksandrov wrote:
> On 18/01/2021 23:17, Nikolay Aleksandrov wrote:
>> On 18/01/2021 22:19, Tobias Waldekranz wrote:
>>> On Mon, Jan 18, 2021 at 21:27, Vladimir Oltean <olteanv@gmail.com> wrote:
>>>> On Mon, Jan 18, 2021 at 07:58:59PM +0100, Tobias Waldekranz wrote:
>>>>> Ah I see, no I was not aware of that. I just saw that the entry towards
>>>>> the CPU was added to the ATU, which it would in both cases. I.e. from
>>>>> the switch's POV, in this setup:
>>>>>
>>>>>    br0
>>>>>    / \ (A)
>>>>> swp0 dummy0
>>>>>        (B)
>>>>>
>>>>> A "local" entry like (A), or a "static" entry like (B) means the same
>>>>> thing to the switch: "it is somewhere behind my CPU-port".
>>>>
>>>> Yes, except that if dummy0 was a real and non-switchdev interface, then
>>>> the "local" entry would probably break your traffic if what you meant
>>>> was "static".
>>>
>>> Agreed.
>>>
>>>>>> So I think there is a very real issue in that the FDB entries with the
>>>>>> is_local bit was never specified to switchdev thus far, and now suddenly
>>>>>> is. I'm sorry, but what you're saying in the commit message, that
>>>>>> "!added_by_user has so far been indistinguishable from is_local" is
>>>>>> simply false.
>>>>>
>>>>> Alright, so how do you do it? Here is the struct:
>>>>>
>>>>>     struct switchdev_notifier_fdb_info {
>>>>> 	struct switchdev_notifier_info info; /* must be first */
>>>>> 	const unsigned char *addr;
>>>>> 	u16 vid;
>>>>> 	u8 added_by_user:1,
>>>>> 	   offloaded:1;
>>>>>     };
>>>>>
>>>>> Which field separates a local address on swp0 from a dynamically learned
>>>>> address on swp0?
>>>>
>>>> None, that's the problem. Local addresses are already presented to
>>>> switchdev without saying that they're local. Which is the entire reason
>>>> that users are misled into thinking that the addresses are not local.
>>>>
>>>> I may have misread what you said, but to me, "!added_by_user has so far
>>>> been indistinguishable from is_local" means that:
>>>> - every struct switchdev_notifier_fdb_info with added_by_user == true
>>>>   also had an implicit is_local == false
>>>> - every struct switchdev_notifier_fdb_info with added_by_user == false
>>>>   also had an implicit is_local == true
>>>> It is _this_ that I deemed as clearly untrue.
>>>>
>>>> The is_local flag is not indistinguishable from !added_by_user, it is
>>>> indistinguishable full stop. Which makes it hard to work with in a
>>>> backwards-compatible way.
>>>
>>> This was probably a semantic mistake on my part, we meant the same
>>> thing.
>>>
>>>>> Ok, so just to see if I understand this correctly:
>>>>>
>>>>> The situation today it that `bridge fdb add ADDR dev DEV master` results
>>>>> in flows towards ADDR being sent to:
>>>>>
>>>>> 1. DEV if DEV belongs to a DSA switch.
>>>>> 2. To the host if DEV was a non-offloaded interface.
>>>>
>>>> Not quite. In the bridge software FDB, the entry is marked as is_local
>>>> in both cases, doesn't matter if the interface is offloaded or not.
>>>> Just that switchdev does not propagate the is_local flag, which makes
>>>> the switchdev listeners think it is not local. The interpretation of
>>>> that will probably vary among switchdev drivers.
>>>>
>>>> The subtlety is that for a non-offloading interface, the
>>>> misconfiguration (when you mean static but use local) is easy to catch.
>>>> Since only the entry from the software FDB will be hit, this means that
>>>> the frame will never be forwarded, so traffic will break.
>>>> But in the case of a switchdev offloading interface, the frames will hit
>>>> the hardware FDB entry more often than the software FDB entry. So
>>>> everything will work just fine and dandy even though it shouldn't.
>>>
>>> Quite right.
>>>
>>>>> With this series applied both would result in (2) which, while
>>>>> idiosyncratic, is as intended. But this of course runs the risk of
>>>>> breaking existing scripts which rely on the current behavior.
>>>>
>>>> Yes.
>>>>
>>>> My only hope is that we could just offload the entries pointing towards
>>>> br0, and ignore the local ones. But for that I would need the bridge
>>>
>>> That was my initial approach. Unfortunately that breaks down when the
>>> bridge inherits its address from a port, i.e. the default case.
>>>
>>> When the address is added to the bridge (fdb->dst == NULL), fdb_insert
>>> will find the previous local entry that is set on the port and bail out
>>> before sending a notification:
>>>
>>> 	if (fdb) {
>>> 		/* it is okay to have multiple ports with same
>>> 		 * address, just use the first one.
>>> 		 */
>>> 		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
>>> 			return 0;
>>> 		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
>>> 		       source ? source->dev->name : br->dev->name, addr, vid);
>>> 		fdb_delete(br, fdb, true);
>>> 	}
>>>
>>> You could change this so that a notification always is sent out. Or you
>>> could give precedence to !fdb->dst and update the existing entry.
>>>
>>>> maintainers to clarify what is the difference between then, as I asked
>>>> in your other patch.
>>>
>>> I am pretty sure they mean the same thing, I believe that !fdb->dst
>>> implies is_local. It is just that "bridge fdb add ADDR dev br0 self" is
>>> a new(er) thing, and before that there was "local" entries on ports.
>>>
>>> Maybe I should try to get rid of the local flag in the bridge first, and
>>> then come back to this problem once that is done? Either way, I agree
>>> that 5/7 is all we want to add to DSA to get this working.
>>>
>>
>> BR_FDB_LOCAL and !fdb->dst are not the same thing, check fdb_add_entry().
>> You cannot get rid of it, !fdb->dst implies BR_FDB_LOCAL, but it's not
>> symmetrical.
>>
> 
> Scratch that, I spoke too soon. You can get rid of it internally, just need
> to be careful not to break user-visible behaviour as Vladimir mentioned.
> 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
	t=1611005977; bh=bdfYBvMa8LNyHkRyEtaHStOZr794nuxZw02BF6Zfg5c=;
	h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
	 Authentication-Results:Subject:From:To:CC:References:Message-ID:
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
	b=lOH2ClNGfg5hhcLMJSlOtsM9K7JoVYkrv1v5FBtgFxxiiWBcOGYir2uqdIfXvMTD/
	 LUTYZ9tVzvZJ/tKymoPhlR+V27URN1nOwkEdz3k1u46QcB+3eQa1blAz8c8bU/HMAP
	 joO4AKJ9BIuG/sc3ZTAX7jdOE3JUSOmCdfhqTCNc6sGmaVFBAwPrrhGPVth3niCkc7
	 JwfTXir+8JtBC0XV3Vw2DiYs8RCX22S/48evhzu6O3PNsmLTFaOZaDb0Ep76MquFPu
	 rjCjXH2ZfG9J/D9YchY/hybtGMRK4aruos1La9mEVi6WzUeW+PhR0/FiXzfW/6fef7
	 cswqoYtddosLw==

Apologies for the multiple emails, but wanted to leave an example:

00:11:22:33:44:55 dev ens16 master bridge permanent

This must always exist and user-space must be able to create it, which
might be against what you want to achieve (no BR_FDB_LOCAL entries with
fdb->dst != NULL).


