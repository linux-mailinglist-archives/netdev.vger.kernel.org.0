Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28F16461D7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 20:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiLGTpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 14:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGTpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 14:45:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB14716D3
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 11:45:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EECBXCpkpfBeQkbrs0TgMOirPO/V0ZSXusFpk/Svge3brfbmJGenV3HJlDVqsdVXKI3/z8bRfD43e64On/wO1EE2QbWFS/i0iAXYamVrOQXbD4rmMr3epZyY6aJOXMgdTpeTFv6mWuDow/wR3upxIJSfzjytwmqj9ToKo75KlD/2FS6/LTDU4npFCRm0b2sptf2oVdYPQm5U1NAH0gvon1gvtmgWUxPPZKpDeljJkmPqKiD63pP7qmVMX0mXS1Fj1L4qWf103LsnJTxl0vE7Gfss4XbK6QJbMSmYTXI7P9TslkW/kr04IkwBLS5BlqbfIcrqYuVpBBU1YJMLILg8zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ft63vGwhJUTwllO+Z5cDQcbjugTk6/z5lptESE1HWzg=;
 b=OzwVPK/J32tOCwHPhv8bYz7Ut+mRLw+BkRFhGaWIfIHNwO9OqwENPcEmMjXi+hjsxR0ISW0w5/9Koie6P+pnsbbv2lUdA5Oszzv5r8/OwwJ8PXcfrCA9RBkTIzqSsOhNNgz1Tg1Eeuj2KIB2j+EM6fJ4wcIhBvXSY8uIBj97GtXgEIjl6mIdeBmCG0Mb3/cE7np+BXV0S+iK4zgtiX//jkd4xDlxObhsCi+GO/HNgR+trWMzoWUgZ2TlnD9Ne9IkVwOWGK5umfosnybGCHGYCYO2XSiYAt5P4i746sc+C3FCs/gbqkraBHQCHBGVDx28B/t/7ylFhQozw5ajhFxcLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ft63vGwhJUTwllO+Z5cDQcbjugTk6/z5lptESE1HWzg=;
 b=u/AOAxZiqDMwx6jYIn9sKf+qKLsXU3P8fiqjR/srp63H6wUUHCsggtMCgSJkftDrqhmYUtmk8Vgl6MVPxgB8BcXrw+ZghnyVRVtorsBcGmUs6k5jz4MQbAF/Vmeo0zRAL5srvGKrdklKDRgz+tLTRnDVJiprBMT9cVXvH5njrP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BN9PR12MB5242.namprd12.prod.outlook.com (2603:10b6:408:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 19:45:34 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 19:45:34 +0000
Message-ID: <4bc5b68c-1a25-b1e5-0cd2-d85b31728c5a@amd.com>
Date:   Wed, 7 Dec 2022 11:45:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [patch net-next 1/8] devlink: call
 devlink_port_register/unregister() on registered instance
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Shannon Nelson <shnelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        brett.creeley@amd.com
References: <20221205152257.454610-1-jiri@resnulli.us>
 <20221205152257.454610-2-jiri@resnulli.us>
 <5e97d5b5-3df4-c9b5-bca4-c82c75d353e8@amd.com> <Y47yMItMuOfCrwiO@nanopsycho>
 <a5c5b1f9-60e9-6e82-911e-03e56ff42da1@amd.com> <Y5CU1DkXVRoz3PcQ@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y5CU1DkXVRoz3PcQ@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0001.namprd21.prod.outlook.com
 (2603:10b6:a03:114::11) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BN9PR12MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f89f060-baa9-43c8-99c0-08dad88b9b73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pNz7B5h34uIs1q/7m6yg37nEQujny/NO07nmT3+xYHM5lmkRwcl3sETSdIJCMiiBNwAbEGpbogWK6VpgrAfA39UNXoO01xsjJjO+U5vU/j8YIRcO89XMetFhGoNs22qYn5tVAXBe/3xAIFHCcIQVxJXn//87CJSA39f1iPtbfk31LnY3muRJLhzWIRHYzdw4SBmmwloA4gOR/YqAq8mkunHyuGciDCcVNvQrkY92XjIMl5jRHpm2XhpR0b2H6Js7aTFb5WwbaJhDmIXKSxQeaLtBnzMyWXyuLZ3eIK7jPQjlvMkJCYRWjBtvztr4k2chbFriQ91t7H7bik8xamMm6Gwdc5WgsNeQpbIqFtpAHHfKzBTosDhHEbnDmt8g3eZm98B4Cjj4Ec/ChLmIirILuQTjgZtiJLbtB4HcUPsZHVVy36BZcgVyqYWwrniuJgJcTHOzv7GfVDcbFQA5rYitHn8QQSsim/mC9ajEXzu5TWMCl+zIVWsUXphRTXz06TOBzbUcvmWkdBriHhE0Zh+IoPYh1U/PG2u+GEiCbiBE26KYTj3vlOUrR/VupYewLH7loEqMrt+8+UWLUCbrzAr0SWzmTBnFQhEGygcBAIpne9VK4kcVW8ivyalQNXXw2M1drWw7VLy+cexDFY+cbH3JvQ8L6WpXR3YGsGH52NqPUV3Dtn+nVXQHPDF1rdR+zT5zydNwdgBnl6myNvmz8zJvDx0+Z3kANrrq0ENFurHhsIY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199015)(478600001)(6486002)(31686004)(6506007)(53546011)(6666004)(6512007)(41300700001)(2616005)(26005)(4326008)(8936002)(8676002)(2906002)(36756003)(186003)(83380400001)(7416002)(5660300002)(6636002)(38100700002)(110136005)(316002)(31696002)(44832011)(66476007)(66556008)(86362001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0ZRd0tGQzRybkQrUWFLb0lQRzA4dVpkbGNOR2lXSmUzWlJHbFpGSVZaLzRF?=
 =?utf-8?B?ellZUVEwZEFsdDl6S0xCRVIwVWhlQVVpSlp2RVVhOUxsSy9sdjlpTE9SdklO?=
 =?utf-8?B?OVB6bVpWc3ZabndHTncwZ2tmZ01mM0Q3UUJaVk84QmJDbm9seWtqWWtESEtl?=
 =?utf-8?B?WWJLWWR5Rms0UStrN28wYjdEK2o0ZzdaOFczT0dsOGs1NUVad2xHZFhRQitx?=
 =?utf-8?B?S1ROYjJjNGlpTktidlhudHphSkhJSisyTlpMS0FsVkptcWE5NGJmRkRwWWRy?=
 =?utf-8?B?Smw4OFVtbEl6Y3JZbnZOVFBxWUpCWnl5dFVVdXFxaTBhNUtYOTRCbGdOWEhV?=
 =?utf-8?B?UkpTMHl4cmo5bTRwckVGQmR5VXM1VFBjNWVxSlhjdVg4RUY2V0RmakhSMkk3?=
 =?utf-8?B?Uyt5OVI5YVNkK0RHdDIzVjVoREZ0UXBIZlZLWU85R3prSUVHSFNPbDF6Q2dF?=
 =?utf-8?B?T0NDYVVRWEFJbXhBWS9yempmMFN3cWhDSDUwelBRNytINzNoK1Y4WTJPeG96?=
 =?utf-8?B?RTVxMlVkZStaODBkd2E4d1VrSDVjc0pFc3IwUm5UZ3hHQWRCYXJFTlpCUkN2?=
 =?utf-8?B?cU9SU3ZSVFhHMTJ1RTFCYW96ZEQyc3BGbnlkcDdFaFRlUFhBU2pycUlBYURI?=
 =?utf-8?B?NEFQdUVvN3lLclFsMmR1OTRvYTAyVnlucDBLRHlrYlRnNjFPajU5eFJjVG1V?=
 =?utf-8?B?UEdjZG1xNzFuR1UzNXRVN1VUWE1UOGlORW1RdW16YjVlSmN4eTBGNmhLYTBU?=
 =?utf-8?B?NGlUY3A5VDV3ZHBaVGd0TDBCaUpNdENLZENJeDVRN24ybTVtK2lJRlV6bXRS?=
 =?utf-8?B?N1RDa3MrNjVxdmgrbHBCd0RYZk5Wc2JBamsvWWxnYWVIK2p4WUNuTjZZenpw?=
 =?utf-8?B?azBWejRkOXZPZlZvZTVHS0NmM1A3R2hqMVVta0w3S3h6MEhtd1RvTElPajhU?=
 =?utf-8?B?WUZJUHJualVXejZMNHJtUjZjUGM2bFJxNkFlVjNEUS9IME9tM090YlpCcHow?=
 =?utf-8?B?UUtnQTJqRkhEZytlc2RyalUrTEd0SjRQWTNpTGNCbTVjN0NpRlNteEtVSjlD?=
 =?utf-8?B?aDZpa00vK1JQdGlaVHNXUFp3V3BZU05LbmlPdkRNeXorNzlqeFZIcGN5c0I1?=
 =?utf-8?B?STVpekFnYnJ3cXNHMURlWFpSeU1VSkp0NUFLdzhsd2JPYlZOVllMKzVPTGpj?=
 =?utf-8?B?dXpjeDNvY0cyOE1iY2ROQjdLcUhYZU5aQTFPY0JJemxBWHppMmd4Q0hyb0hl?=
 =?utf-8?B?SGtKUGc4dDd5SUpLMW8ySW9ueGEwSUwvQ3ZpR1htTG84dkEwOEcwVmtMYkVB?=
 =?utf-8?B?ZzNjbG04Y29wRU1naFVSK3pFQXZ5elFtWWR3dy95clNKRytrMHdJdEcxM2pa?=
 =?utf-8?B?UVBTblBTQ2JWQXZ0ZXEvbXFaV3ZOY3g0anJLYlgwbVRHVUoremZHMG9md3BQ?=
 =?utf-8?B?bmY4Z0kraXFzSmdiYitySThtWnp2WDdlWGxRUWdCcmZqN0d6SjFxcWdueUhZ?=
 =?utf-8?B?ZUZkdmdWeUYyZ3RPWW1mSmlQU0Vkc0lhczYzMDkxZCtnTUxBMlJ4bDFkT1J1?=
 =?utf-8?B?NS82NjUydHhFYkd0ZzdZY2dFSEpXbEdJazduWnlIcktSN1NlVVVYVzFYYjgr?=
 =?utf-8?B?bGZYNHl5eUhZRDVYNFluRGNrY3d5NkJvUnpCa2xyYVJ1YWRUNTd4TXMwQVJm?=
 =?utf-8?B?SzhWWG9SdmE3Q3lrU0pmdGFuRUY1bDlnQmJtTC9KUUdZSHl5QlFTVTBTZzZh?=
 =?utf-8?B?QkRDMUZCdWNJRUpTdkx4YUpBRzVvOHREWU9ZbVRlRUd3aWZxcXM3Q3FScWtG?=
 =?utf-8?B?cjAxTUdvSGdTN3NjTHlBMUNrd3pVRUdkemZualJXeityQ1hwTzhQZEw5aGxU?=
 =?utf-8?B?QVBoampSMmRHazR0dmdjVUo1YUJjWlZ4cExiTCtXT1lFMVRXMytKVTNHTHJj?=
 =?utf-8?B?Tks0dGI4bTFlUHhsWi9iWjlYU25mVTNDeWgrYnd6U3NRTmFFeEZJOVhJd2Qz?=
 =?utf-8?B?M1RKL1VJdEZlVzdzL3VFRFcyWExDcnRsTWtYQ3ZENnZwMlJ2WFRtT0NRWWl0?=
 =?utf-8?B?K2FKU2FDN2xWK0ZPcVhFT0c5QUxmbWR3bjFieFpvQkZFRzJRM2hTSHVzWkYx?=
 =?utf-8?Q?DF2axsuZDWP0xSXUnug2vVuQo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f89f060-baa9-43c8-99c0-08dad88b9b73
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 19:45:34.7850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGq5TXivh/aOUwFTlhiZ463O1iqlf8z8xcwVK6046i+B0oYhceDpawYKxPHhQYdA0a+rnkGFFtAzzpkY1df1/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5242
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/22 5:27 AM, Jiri Pirko wrote:
> Tue, Dec 06, 2022 at 06:35:32PM CET, shnelson@amd.com wrote:
>> On 12/5/22 11:41 PM, Jiri Pirko wrote:
>>> Tue, Dec 06, 2022 at 12:55:32AM CET, shnelson@amd.com wrote:
>>>> On 12/5/22 7:22 AM, Jiri Pirko wrote:
>>>>>
>>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>>
>>>>> Change the drivers that use devlink_port_register/unregister() to call
>>>>> these functions only in case devlink is registered.
>>
>>
>>>>
>>>> I haven't kept up on all the discussion about this, but is there no longer a
>>>> worry about registering the devlink object before all the related
>>>> configuration bits are in place?
>>>>
>>>> Does this open any potential issues with userland programs seeing the devlink
>>>> device and trying to access port before they get registered?
>>>
>>> What exactly do you have in mind? Could you please describe it?
>>
>> It looks like this could be setting up a race condition that some userland
>> udev automation might hit if it notices the device, looks for the port, but
>> doesn't see the port yet.  Leon's patch turned this around so that the ports
>> would show up at the same time as the device.
> 
> Any userland automation should not rely on that. Ports may come and go
> with the current code as well, see port split/unsplit, linecard
> provision unprovision.

As long as this is a clear expectation, I'm fine with this.
sln
