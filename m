Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2201C6D33A0
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjDATtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDATte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:49:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A71F9750
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:49:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3OA92xNSWqL4rSUt0thlnMuITQoIaeDLl//vg1IMIJ39rQ9M0zuKPMO9wq1/oHkpJYBnVSA2t0BL6kw3VlHhGxdXM0AZbAjipeVPNI0ppqIY71fDDOgXAYyjPCGD4+fqbgRsE103cCVQM+sVtMt3YurcQ5SVPFa0UtoicQBUI1j7a1BLUF5sisULQgsrJR1GlYPm3FMAm+MFbglxkaWri3ndYBD0oMxG6ji7x5+UU8SzpaiACxpCT0W8ZmPC8zpCB/YGAEi60TrcVaLlPU3DtloG0mCn/AqVoS69o+U602ZEgYBqYvQ693A70s1IelZYcrtuAGpPguIakKqoo+0Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qyCUluojQUNXwV32n/m+UtvcvsmcgcFuAyjEFp81o3E=;
 b=JvKN3tF16/f6aCru0NU2Oooaz/un1lOqT1auYMiPjFhrjUDJ3VFYH5oHJc+AIEsyAoQ84ia7ieKsm4V24Ps6ZgPnf5vvOTyCwBuixMv9YyIRefc8n0ViQoKvfthNHA0u5DDy+4pQsjeqbtZqwFfd2pGXK7Njhg/m0hwTuKvT0WZRRhkQN0bPfTmnFrfaEeI4deeYfQnUq7Hazfg1+qtf7T9ON5UeDN3AK0GR7NN95L51tWU1BNgCyXWlgvX4YIERzMjOm9Wy+T85IpWyRNbBef/+Bb3MkF3AL/OWukqz1MJh7A1TZoPuehqKhds6tYgF/8999u9snVqc61D1Za4qpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyCUluojQUNXwV32n/m+UtvcvsmcgcFuAyjEFp81o3E=;
 b=1Y5CSBP9cDQbiZDvBbREZt/VLN1bOj3Sxzk8UZhNECF1opJm0KnZZ6TbS/1oQ5shzNoB/goIGvdPnQwl2hGo60ceTar8dXS9Tp+dlCnSBHI58Ff+PMdYG3Q8ylgP2PjrnJy1A5kn5DLOPn+Q4GfKZ82UyhL9sKAVbGF3rnCslWs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB8987.namprd12.prod.outlook.com (2603:10b6:806:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Sat, 1 Apr
 2023 19:49:31 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%5]) with mapi id 15.20.6254.022; Sat, 1 Apr 2023
 19:49:31 +0000
Message-ID: <6e775522-db04-f187-1f40-c7ecb1b8e5a6@amd.com>
Date:   Sat, 1 Apr 2023 12:49:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v8 net-next 07/14] pds_core: add FW update feature to
 devlink
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
References: <20230330234628.14627-1-shannon.nelson@amd.com>
 <20230330234628.14627-8-shannon.nelson@amd.com>
 <20230331220908.2a2fa0bc@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230331220908.2a2fa0bc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::21) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: 851db73c-d1d3-4c30-0602-08db32ea360b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hG9PlsiSWjedFgYQl8H6pb6BRUXpYJSlMK71ut0qhGrllaWrElWi6Uee2LN3NxhzDgdLRzUjrTL9yIy5qFZ6cYHzNL7OyIu5S8B1kmoeA3mIaWSgTnHyUuxr9b5bfYmmwhakmgWZhT0Ale3s8k75oBManxbi/jwqqcP9i9gZdLN0PfEV66JfC9i9V6KRcYT+nlUX0tYaL1ZfKbJEDzxOV3hliK59TOCjVXduXGyvt+tiKzx2L9ld+XJ8X3RbC6mrhg02d9P/Ow5lt5eb7K5w1zbJV1ZBd3670mIjuYkHgKIneTcrlP1xVUw59Sc6lJBs+Qn92t0pcwDL9GL/jj563z6I45+XsZ0AM307c2e9+UFFRGd6l9wr2g6fPjAp7CclbuiT+bW8vQNGp2KrCdZaV2eELvcLsKVFPCObJ8nwbpERksrn1HC0L8S+5gvzGmqwiA5Hjo9DASb8pcEyrSiLGnzDr/ws2mnaK0C1v/vQPRtkrDO62athB4b5btUoWxMyBXJvBWsakZq/764uoUPimffwNC8WQgeSKj+1pp+Q6NuPiZO4WfHsUP7XTeAhYLBmGAhGEJ5deu+aNg/HZeZszlBXlnUVXCoMCWBZ2VA7WBF8Ir/fA0lpGD9telz3gDowJGACqZ6wDajYZyI8KMCVFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(478600001)(66556008)(44832011)(41300700001)(66476007)(66946007)(6916009)(4326008)(316002)(36756003)(15650500001)(2906002)(8676002)(8936002)(38100700002)(86362001)(186003)(5660300002)(83380400001)(2616005)(53546011)(31686004)(966005)(6486002)(26005)(31696002)(6512007)(6506007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dG9oMzBSYzlDN3NDdVI2alNYMms3bkFMMXhrbjQvRW1Bby9NZFZ0bGV3NlRH?=
 =?utf-8?B?UkIrNjdUcGNXbzQ2ZGd5WUxxY1l5ak4vUXZudmJ0SjFndFI2a0d2WmRHQ1lr?=
 =?utf-8?B?TVRzdGJOLzk3dkkxSVVqNDBGZCs1Vi9qZVhVTVRGWEZWK3dXZ0FRdE9GUjIr?=
 =?utf-8?B?dVNBUXdFYWJvZGpGeS8wR0k4cGVCTkJIWDE2M2dHeEJGMUkrUmc2TlVEa2tq?=
 =?utf-8?B?YkZ0UFNXRGRNa0FNeXlvNWE1VjhuVzNUVjlvOFo2SnRHRThhRGRzaWptK0pW?=
 =?utf-8?B?MndZR2NsTHR3M21XZUYxZktvcitIemlVY1laMjFoVjIxd3BxMS9ETC9nQ3Fk?=
 =?utf-8?B?dTc2MmYzc3hDOHRnUDN0eFAyN29MWmRCRyt3SE5vQkFpQXB5dmVxVDZWdnVP?=
 =?utf-8?B?c2pmcjhqUmVPTXNad3B6UEZZdnJLMzA1ZCtzYzRqZzNpeVE1dDJTTzlLL1VU?=
 =?utf-8?B?Qko4OG5xRm9zb2lmZXUwRWFTZHNmTTBnMDZzZTdhOUpBcWtzTENualN0UkVD?=
 =?utf-8?B?MXVSL0Q1amR3TjZ2MUNYUjRJT3VIL3JLUHJNRGpnTDJKY1RmWk5La05YQ0tk?=
 =?utf-8?B?RE1UK0cyL2I1ZXVtY1Q2emQ0YTlEYytMVTdVUGRuVW16VkFodEFVQUZCQmtQ?=
 =?utf-8?B?VVdieGpWS2N1cS9BdHJyYjRsZ0M4TCtic2JxZzlXbzRUSTQ5elZ2R2I5czJD?=
 =?utf-8?B?cFJER3hYYlhzNEZXZnZuM0UrTU15UDdSQzJCeUdCSHFnWi95YUx2M2xhSGt6?=
 =?utf-8?B?Q3lXTDN3aHd3VGdBVEVMbktIZitaZFY0ajZDeEdLeUZ2Tml1YVlzZ1ZrZmlq?=
 =?utf-8?B?RGxLSlluMzVSaFFmRlIyM0x0N3RFbzN6Sy9xRDk3NGhNYy9BbjJCQmZIYyt5?=
 =?utf-8?B?ODIvMGRaNEtIUmhLUmFCcUdyTmhFV1ZkdkxVUTNQU0c1aFpIeTNZVVJBMzQ4?=
 =?utf-8?B?Q0g5UGNDamllSEZzcmJJVklwVVEyR2lIUngzUzB1a0pCQXdQSkdlSWJjdDdw?=
 =?utf-8?B?VmV1TzBRZlVrRlBPZ2svWU1qSDdKVG95aDVoa2ZVRzBVdFJyeUpkU2ZTblFv?=
 =?utf-8?B?Q1I0SlNxQmk4N05yY2NmUlBYUGkwY0hwRXFIRHlFai9mUXcyYXNvN3hVQVRN?=
 =?utf-8?B?TDJzcm9jL3pWRWZsbGFLdEdCMUlXNGpKNTM1Yituem9SMDZYVWlyTEEyTkd2?=
 =?utf-8?B?MURLVWZzb2xmdko2ZzhPRDNDbmlmNXRuZ0hYdVNvN21zeDRiOEJoT1I1dGpw?=
 =?utf-8?B?ODUvTkdQS2Myb2M5TG9iRC91bFljNXorTGhPNVY3SThPYzNpU1FkdE1rQVdj?=
 =?utf-8?B?N29Ibm5aWlpMOFNZNytqbldGVUUxQ1JQYkVQdzFoRllPQURDMWdHei9BZy9P?=
 =?utf-8?B?RUdBaXRkd0U3ejJhUExqakx4eEtEczNSSUhyd2NueVNtTDZDQUZYQ0JpY1Fk?=
 =?utf-8?B?cU5WOWpvNk9sbjM5WGFiSmoweWFXYU9EMzVuSC9zNHFJTWhFZXBIYmZTczd2?=
 =?utf-8?B?U2Y3dDFkaEFIa3o5WERPL2NqZi9ydGpCWEd2Y2lzc3NYTG5aRnFVUno5Z0lG?=
 =?utf-8?B?N2RoaVRUV2J0SWZsSDFRcE9WcWRJR3NoWFZPdzFBSnBLaUkyOUhIYUN6Z2NV?=
 =?utf-8?B?d0VtNkMxa0w3VEIwSUJpMS9tZ0loTVc0eTQ1Y0VFWFdheGp1V1BVekMxb3Iz?=
 =?utf-8?B?MVhHMC9RMkc3QjdYV1F1YXZwbHM5UmQ3cTJyU0xqc1BSYU9QK2FoVC8zN3k5?=
 =?utf-8?B?MnVmTVhldjI5cm9UNVdNdnorV0wrOTVwR1FCbmQ0OU9iY0lubVB4ZEhVYjZ6?=
 =?utf-8?B?d1c3UXBMY2xtYWxsOURuREUxZUVLdHBSQUI0bXVyWE9ZNFlUbVZOZXZFRFZs?=
 =?utf-8?B?OXNsWDd3bitoOEUvL0RKME45MEJaUzFJL3E1TXFZbGlxbUQ5UXlSUlUveE1M?=
 =?utf-8?B?NU9lUFYrOG1MeC9CYktXbE5KVlhvRDBOdlRCcUdtanZqOUc1WWo5QUl1QUlF?=
 =?utf-8?B?U0lBQ0RlcldFOUgxTkFEcXlvazJLNm5VVUNyNnE0ajV0QWFoV2hsOW9NdjFw?=
 =?utf-8?B?d2dEYzZ4TDlRL2o1L0JPalBPK0hHaURLcXY4Zy9kc20zb0hod0JYTGJmTytW?=
 =?utf-8?Q?3focZEz3thiXSHTVErcGCcGoh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 851db73c-d1d3-4c30-0602-08db32ea360b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 19:49:31.4843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLoLyNINqIFou5yTWNh6BCc9OhafqBUA88POg++SGiUg489+zeuTkVG+l6hP5/r34Tl08bagGFDr6xhwlyyZjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8987
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/23 10:09 PM, Jakub Kicinski wrote:
> 
> On Thu, 30 Mar 2023 16:46:21 -0700 Shannon Nelson wrote:
>> Add in the support for doing firmware updates.  Of the two
>> main banks available, a and b, this updates the one not in
>> use and then selects it for the next boot.
> 
> My memory is hazy but I think you needed similar functionality in ionic
> and deferred implementing proper uAPI for it? And now we have another
> driver with the same problem?

I don't believe we discussed bank selection for ionic, but did in a 
follow up discussion from the original posting of this driver back in 
November [1].  This expanded into a much large thing that no one has 
gotten around to working on yet.  At this point we simply are installing 
the new FW and waiting for a reboot to make it live, which I don't 
remember causing any controversy in ionic.

In the ionic case, we did have a short discussion about nomenclature for 
select and enable, and reworked the timeout status notification.  This 
code uses those same methods.

sln

[1] https://lore.kernel.org/netdev/20221212103450.6a747114@kernel.org/
