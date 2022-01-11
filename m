Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8439548AFFE
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 15:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243153AbiAKO5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 09:57:48 -0500
Received: from mail-mw2nam10on2054.outbound.protection.outlook.com ([40.107.94.54]:17089
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243134AbiAKO5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 09:57:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTxLc+lCRmU4nwZ0PzrhZvQCdEtES4/5ujLR39FRptLqDtyGaAjJ01kCQz8MjJ/J0fij4y+2ZshJtqSRH7GngMhv8jvY1rzEu4WnG80Q/LR1NRqF9xYar8B8oAkbfpcy1LqhY7AmWBit2CXK9UuhKM0kXOnfWOeJPaTUUSfpAEgYtM13OFsI2gUG5X9n6TK89NV1GHf87gulmivT+m+tyA5jZlfvi66WD3tpnMWp1NI5qK4nlDz54X8ZjvyGaSeBymzYndsIuehMDqqcJBI7iFYKHptHK8Yla1WSU1fj/6zHb/GKtMXN/Nd9KIO+eRnrcSjJVLQOQ6coO/CKKkCMug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8h8fwLuj2gAExVuZdTuh4D6+NIFxryXuo6nnF9q3Jg=;
 b=hW6tojQbcZH/fQvxHZx8vpB+2eW4ooK8AIaGmgatmBn0ed1r8ZWEFNCaSvKsSbkP/cjKxz63WOoiME+YFqehiyVh1dmgh2ONJuvVyabpbArqDH+vHHijNWhbvxCiOxHkwoi1ZzowJXOmxnIrXsLQ9vXzkmfs23Ive7TpsdqOp3nkjfTbP9CgZy5wnt/uAqo6MpP9Xm+NQ1i10PsAXzzjQXcLHp9/w5aCuJwrVTeWcvt7WzgTf/0BV2nAtUiw0Ow7nt90q3Ed9c1DGhvAZ6+ieXOuGmhs5o7szp5aDKhRxhBY64mPqBlFZzrDCMj+XwZgaJ6bNX2FdTWXFyv8yzn/jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8h8fwLuj2gAExVuZdTuh4D6+NIFxryXuo6nnF9q3Jg=;
 b=Jz8IN9t1q45k0UVjlrWBnGMAOl6z4qXmYz8fH5LcODbo/Yf6G9+mzyeGsfCSUXCZlWyM+nQT6bk9pYGxX0zSWJbAlJEdIuift2X6Q5hsN2eayRwLIfOaOUM59bA3BKV8ISLwchn31RyPHEzezxLma58JKSBVhEecsvuyb9Ne3A0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BL1PR12MB5303.namprd12.prod.outlook.com (2603:10b6:208:317::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 14:57:45 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4888.009; Tue, 11 Jan 2022
 14:57:45 +0000
Message-ID: <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
Date:   Tue, 11 Jan 2022 08:57:39 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <YdXVoNFB/Asq6bc/@lunn.ch> <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
 <YdYbZne6pBZzxSxA@lunn.ch>
 <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
 <YdbuXbtc64+Knbhm@lunn.ch>
 <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
 <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
 <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0055.namprd02.prod.outlook.com
 (2603:10b6:803:20::17) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f11437be-e1de-4f1d-6d29-08d9d512b9a4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5303:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5303BDB09A472072FDD91CA1E2519@BL1PR12MB5303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kq6jfzTh0i4FlYSU6YkvuLmruKmpkirqWx+rIO8lOvmJz/AXU5F7adTAQ0mooQysR8Lek7kzYo/TINURYJmNUHbUU6f5Ys6ApjkPGD5WNb3HIuUGPWKolTlzR9tjIX9AIf6fZEHT4DCVDpoz/Co55yd0+LPRTwmwXLLlAfh5sX0Sc2MZvoi4kt6nuN+TjKbKWy2V9GMaM1yFIGQH2t43FLDDpXGG/O7oVG6Qv0vOyPN1wMIE5rIgRMyd+Ko4A7d6R55hviSs6tNL4E+K6WUJ87HHBgXc31+Jk0edErcj279X9mOr+4+v7AbawoPMmfCSvIomSBvBGJ/pLeL6sZNHNmcVYLT1fc5pePlhmDwCxGC5MzM4kh8YkeASCIogQIVjGk55eGu1Nx4fBJxbvHcvyaoG+amOLjmf8x17/dCxrXLI8hs4HqFkJCG5ugUBAPaBl7MONPipF9PJyQxYny/g0acnJgwjFgQTD+hzCFvy3uA/MfnjyhWur8/NvT0e1f0U3jFeEuityIHXPDhN414U+9/iAhPTQT4yntFyibdooPCqowq2GByxz/RDqE3r+KcTuPLgYWwPPy3lXXERKEYJDFFfxPFITplxbn00BzWEDOympL4hOCrSAim1cW+l5CGIh6VQuEfn7bMWYrlB8PFB2XytJ/8vISaPdN1Pc7xUjlGBEL+OYqd7icVzj7n3f4iZjBQtpZ+AE9BuEYstC3MWgEv1MyL9b1dccH/Q26E9tbM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(36756003)(66556008)(8936002)(2906002)(4326008)(86362001)(6486002)(110136005)(54906003)(66946007)(38100700002)(6666004)(83380400001)(53546011)(6506007)(7416002)(508600001)(31696002)(2616005)(8676002)(5660300002)(186003)(6512007)(31686004)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjFkMDlOM3VEajNtcWw1bWpUSFFNNDBJSmZscjJxcmV2TU8wRWRtaFd4K2w0?=
 =?utf-8?B?c0ZsV0djd3Ric2xvdS9GSElWenE3TUw1ZFRwaFlJRmlkckY1dVBYQzNrcytJ?=
 =?utf-8?B?NWJaNUxsbWpMWThjbk5GWjBhdHoxbjFxTVo3Ui9ZWjc1bm9scy84bXpNcUxw?=
 =?utf-8?B?ZXRLTjBaa3JWbGRrQ016a0xFNkpBKzdRdE1iOUFIZy9JM2JKOFBmSGpBWXlR?=
 =?utf-8?B?UjhmOExXSEwxOEtGa09JajJmdllVc2RYZmxRMDRjUWJqRHhkTHRVb3MzbGZU?=
 =?utf-8?B?eTR2dlRudW9oaVhVQ01nQ0w1T1NJNjdDN0F3QTErZmhwQXVucmgrWEdzTTFr?=
 =?utf-8?B?b1dOQVA5NUdBUmdkVUsrZDRBNDBSakluVExpN1dFNFhBR1U4T1pTay91NzNX?=
 =?utf-8?B?WWVqMDhUT2tlNGs5bEt2VnErL2VMRmpsMDJld2dXZ3B5YnVMU1B3VjNZaEhC?=
 =?utf-8?B?L054QVRZVW5rVWw0dHZoY3BDeVViYWhDVWNzNE1tZ1RhRm1BN3BPcEVZRm1R?=
 =?utf-8?B?bkhqT2c4K21sUFpSRFVZTjgzQTZNTkdUdmpnM0tMZGEvK29Zd1JEL01vTnFh?=
 =?utf-8?B?S1VqSkRIK2huRVpJWXk4WVBOd3VWTEJSejBOY2crSEpDOG1BdGtLTWFRSmhJ?=
 =?utf-8?B?bHM0Q1VTOG1RT2o2TDUvZG8zTjFJaTdyRTNQbjBmbDBTeTl5NXErQkhFQmVP?=
 =?utf-8?B?L29wcUFhTUVvQmg3VlJmbkE3QXd0Tm1wR284SXlrcGdVTTZLWkdMQTdBL1pG?=
 =?utf-8?B?SXpXRFhRQnF0OEJiL2xwVUhFd3AycFBGdUpOcmNYQVNIZzRVV1hBWHQyRER2?=
 =?utf-8?B?Ymc0LytWYkJHK2ltajZoWTRrZUZlUkgzRDhCdjNGQllyczJhcUJyYTM3MldQ?=
 =?utf-8?B?RDhtMHYvcnQzV3M3eTF3Z0U3Vk04NWJQdm9vMlFDVCtqdlJidHc4OTJ0SWtG?=
 =?utf-8?B?YVFVYUNkZmJORkFGQm1wUHJ2SUdpRGpaVWxhdUhQZmQzOTZpRWk5TER4NEY2?=
 =?utf-8?B?cXlBamU5VjhydDRlMWhLUTNJcXJZMnN1Um41dlVGOGhDWW02TnI5Vm9yWGhx?=
 =?utf-8?B?VGdZMHc3MGNmbnpITklzMDNDWExvKzBvSHZueVVSUUJoSDdjMStHYVgwdzRz?=
 =?utf-8?B?Qm9Zd0t6WFY2cDlITWNHeHZvdkVhNjZDcnJ4OURMUjIyR1c3MlVjaE84R1Yv?=
 =?utf-8?B?YXpBdGpvRU81UnBMWUNXN2NNek95TkNBMmVUMW5oL212cE1QZGZkc2hpVVRt?=
 =?utf-8?B?L1I3TldpSmRsUUVtNW5iNnZETUJqMUtqQzVMWllRU2pUc0dnSFlYL3N5dkpU?=
 =?utf-8?B?L1Z1MlJYb1NXUGdpL2s1dEkralI2VjJMMUZCbDhhcncxMUM0a2N3anlCVGFq?=
 =?utf-8?B?WTlHNFREOTZFWTl3UDhMMjNYaFkzV0NqWTU4SEF3QjF2Myt1RXMrVjJ6a0Fk?=
 =?utf-8?B?L2ZReHdqMFMzdmNqeTR6WmJJckdhbHFYQVNVSmxiOTRXVHd2aFVuVDEreTVl?=
 =?utf-8?B?eE9nRzBUUi9YTGZhR2txWGR5bzMxaGEyd1lramY1eEcybFc4bGFGQ1VwSnRw?=
 =?utf-8?B?QkZNQ29Dd1dNbU1yYks2ZnA0NVpObWpJdU95T2JjblZpRlJ0VUpnYW1oNDJu?=
 =?utf-8?B?dFNnekFjS1J6RDVXTXRkak5HbnJva1VFUkp5WUdTa0hLTGVzL1hnWFdabWVo?=
 =?utf-8?B?M2o0VUVFY3lOTmh5a0dDc1FJZFk4NjgyU2pOY3p1MGlNSUoyeFJRNlJvZktl?=
 =?utf-8?B?cE9rOVBhNnpZTmtxMzNXSUd6d0Y0VnlWWFNHc05DYlJpanVzWU1LdndodG9S?=
 =?utf-8?B?N3ZjbkhQS2dXVzNvVGJjTDRiR0ZUUjJSS0tybjR0QnNRMk0wMmlIYjhvYXUy?=
 =?utf-8?B?R1JXaWdUaGJ1Rll5YlIvamxnbklQK1lDbDhJNlo1WHZVeWh5OTFpZnVqSVJk?=
 =?utf-8?B?T0xmMCttYkRlMFQ0a0lsYXd6dU9OaW0yUWQrcFREYXJYS1lFZ1NIN2RaRGVH?=
 =?utf-8?B?VnVWeUVPcG4zRUIyWVBXWk1YSXN3LzlWSEJRUkpXdUR6UUlBZ0FkQzk4a1F0?=
 =?utf-8?B?Y2M0MVI1MzJuTHFUZzVZWWZwWEVHZ2EzbXJBeTJQVlg5SzNFaXFoVUFoV2gz?=
 =?utf-8?B?dDF5TGphSGFXa0NEMFNubmFjRmJXVUdzSWhxd1lmeVZINk9VT1p0b0cxZ05Y?=
 =?utf-8?B?R0gxNkdaZzFFU0UzRGpEck5UU1Q5bWZRVDl3MWJpaTBuaTBJVzVEWCtMTmlU?=
 =?utf-8?Q?u0cdUY5uKmzsC+Z3P+I9UHKjh0MFyQSGD7wvth/3sc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11437be-e1de-4f1d-6d29-08d9d512b9a4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 14:57:45.2042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDJDNfIgVeI8fa5WYqFDdvvno/kPYtc0WpfifuX/8CtGV4SPOohrW9AQlJhuECcFSAgf3KjKaaAk6I/YOLrkuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/2022 19:51, Kai-Heng Feng wrote:
> [+Cc Mario Limonciello, the original author on MAC pass-through]
> 
> On Tue, Jan 11, 2022 at 12:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Mon, 10 Jan 2022 11:32:16 +0800 Kai-Heng Feng wrote:
>>>>> I don't think it's a good idea. On my laptop,
>>>>> systemd-udev-settle.service can add extra 5~10 seconds boot time
>>>>> delay.
>>>>> Furthermore, the external NIC in question is in a USB/Thunderbolt
>>>>> dock, it can present pre-boot, or it can be hotplugged at any time.
>>>>
>>>> IIUC our guess is that this feature used for NAC and IEEE 802.1X.
>>>> In that case someone is already provisioning certificates to all
>>>> the machines, and must provide a config for all its interfaces.
>>>> It should be pretty simple to also put the right MAC address override
>>>> in the NetworkManager/systemd-networkd/whatever config, no?
>>>
>>> If that's really the case, why do major OEMs came up with MAC
>>> pass-through? Stupid may it be, I don't think it's a solution looking
>>> for problem.
>>
>> I don't know. Maybe due to a limitation in Windows? Maybe it's hard to
>> do in network manager, too, and we're not seeing something. Or perhaps
>> simply because they want to convince corporations to buy their
>> unreasonably expensive docks.
>>
>> What I do know is that we need to gain a good understanding of the
>> motivation before we push any more of such magic into the kernel.
> 
> Mario, do you know how corporate network and other OS handle MAC
> pass-through, so we can come up with a more robust design?

The important thing to remember is that many of these machines *don't*
have in-built network controller and rely upon a USB-c network adapter.

I recall a few reasons.

1) Consistency with the UEFI network stack and dual booting Windows when 
using the machine.  IOW 1 DHCP lease to one network controller, not one OS.

2) A (small) part of an onion that is network security.  It allows 
administrators to allow-list or block-list controllers.

The example I recall hearing is someone has their laptop stolen and 
notifies I/T.  I/T removes the MAC address of the pass through address
from the allow-list and now that laptop can't use any hotel cubes for 
accessing network resources.

3) Resource planning and management of hoteling resources.

For example allow facilities to monitor whether users are reserving and 
using the hoteling cubes they reserved.

> 
> Kai-Heng
> 
>>
>> I may be able to do some testing myself after the Omicron surge is over
>> in the US.

