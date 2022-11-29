Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF863B6AB
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiK2AiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiK2AiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:38:06 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B25624095
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 16:37:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcKexVuuO7+Gb6jwcfOfPnGFs6VDDzrRF5B+k2x7Zx+g4ZQWUmTdIBnH0HJhXPrrAWIe0aAr9rG1Lx1EjzjMHk36eFKMI/9BxVpRpOI25hu9YVt6yN7R6xkY/bxJ4K1BeFI8M8cq52aITQ2uKWNM5oYQDidJrznkz7pXmCEhd9jbUcbBrG6bxvS7Dah7vxu4YNDE+TEucg+SkclB0x4whuLjbvXz3R5HGsVwBmipYCmao18MvNDsZ0BQylveruKdaG7nHoK+T7XpdvACH6728FrSnI9TX52gC7HxGlBPxkwCbIiT0RGc37ULkNl9NrFY/snTmGE/OxRFVadyH5APMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQVoTEN21loqiP24qWTyMB/bf3X/f727Bq5I2Urh6PU=;
 b=gEDbK55OYRHIzQOq+f65CnhyKGg8W1t0DzmLYZy97PbDoCc3XZLR1t3ECdIJpUdajt/G629aS96aX7xUV4Ew63owPWx4RGv8z7kWTE+x5Sfe35V2K4XXmjBX6nLGZXCpUs++BtlTErrg4sGcNSh+dfh9sn8ZWe6bPFLkF2LMQf8gL26lCvdtbFrf8mLJvJXIaS0QGVpY7bkyJwMUKtbDHFadJzfxHEun8py5E+s5V8s2wID5e8NdoIKlrC3oxMR652VOIicdqXKvAWiO6hOR6Lzr643vmVsdD6GYMRV1xxKojv870H1rlBWF4TxdIESpSCJkxDr3mikeORR9H6Q9Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQVoTEN21loqiP24qWTyMB/bf3X/f727Bq5I2Urh6PU=;
 b=kUjLfu0R3sT6u4wJZQiTCBhqj/5D4m0yj9mXZKFuM3jY14yGdnVIQaK2FWOHEJ7Iwj/S9LinyAt2K9DXXTebKO0KMXfXJzWSd6JvWEvHH53s0qCoZCPdKkCjyFUy026W/kbbfNU5b4FX0ivdn+bKIOGEhFbysTATgtmqOQF9eJ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BL0PR12MB4945.namprd12.prod.outlook.com (2603:10b6:208:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 00:37:48 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:37:47 +0000
Message-ID: <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
Date:   Mon, 28 Nov 2022 16:37:45 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-9-snelson@pensando.io>
 <20221128102828.09ed497a@kernel.org>
 <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
 <20221128153719.2b6102cc@kernel.org>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221128153719.2b6102cc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0190.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::15) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BL0PR12MB4945:EE_
X-MS-Office365-Filtering-Correlation-Id: b2cc7c2a-197c-4349-cab8-08dad1a1f040
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DpcyjOL2tOnjLmOuEQP93aV0eWNcpHDuAWCcBUG5VJFM1Ff6DOIXhIikkJdHgKO+cZSRdOSuUphE559UEKtxpcbu6hgcB4/jhfD9eIBgQf//msyARrJ1+yfQC6bZERzfaU4dJU2c+WWFG4Ihb1oEiC4guIsKgi8iNTbqf/bfqEnE87eOVGgUKgAhY51jQN5VldshusGIZLgY2wptWUa3Tn0oBcEQu7wD8TtPecNtOh7/EPt1qBEBCz/IISuoSQyQG2ZzbReZwZBPSypBUr3r0L8DYf/U7/PWR0QBxH+XSdzSSoTj4b3XH0tRdyprtVax15gVD6geyuaJquMrGuPURWVB/xwhUvLeht5Z7hiulqUll1wju3poEXRWWeP733fzdpuRTMUbQ7fQ4S0xhhT0zzS6C19aIglyND+8VHlR4m2bFMaqd158/0DX0jhaFKPpnk07p04PH50ri7Zo/4qdX4sauFmL8+C1ISHlnkbSekwKDQEkw95z47KO2nrkZez09hSUZiQ3LgjW3sapJlSk2MAe14sJGfY8fY9RIZraJ/VUw+DZVuIONQq3xEFYRnkSorX/4Ba7V+lLhFMzgZm3bdLl8uis+XpyQPSPrvXE4Yfrx3BDUn+eRfAakGi6qkk4VYweKw6n9+I0edLZAGZRbsdyKLOn1DrxD83vcNtW6wwqwbgaRfOLhiNA/PLP6YBKZkfjWGP9fV9AZqAt+PvPhA+LFrQsG3r380N5uEk3m/E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(6486002)(6506007)(83380400001)(31696002)(478600001)(31686004)(53546011)(316002)(26005)(6512007)(6916009)(2616005)(41300700001)(66574015)(5660300002)(2906002)(8936002)(38100700002)(4326008)(8676002)(66476007)(66946007)(36756003)(186003)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUNYYldVVGZza2pVZ0RrcXgrVUU1TGxCUzFnaW52d2lDQTNBRTQwdndVaHNz?=
 =?utf-8?B?cjVONWpvTERRVmRVWDNpclZyNVYxbXJOa2oxVG1JMG5ic2JiTkxhTG5yNDRD?=
 =?utf-8?B?WUEvbEFucjAzZmpUS2NMcTNEeVRoZXB4bVk5SlZKcTVDZStEUGhYQWZmUmtJ?=
 =?utf-8?B?Y2VlektHQVZndWlsTmVNeGVGZ016eG9ocXlNdi9OWk1HOXh1UWJwTitTMGJt?=
 =?utf-8?B?TEtNRUdxN1pUbzZTNG56L3pCZ29zVWZveDlpMVhnbFFBdlZMeXdkczFQWWlL?=
 =?utf-8?B?cU4xQlRveW4yRXg1Mk1sMGdkUU9kZ3lOcGo4ZEp2SVNEYzNpTElyOThMQXJy?=
 =?utf-8?B?Wlc3ZWdZTFpydm4waEhyMktleDlyMzZjbEZxZDY2TWRod1ZyeG1NRHF1NC9x?=
 =?utf-8?B?K05adUdyd3pidkUvK05KWjVjWmgvWU01QTFJRStNNm1zd0o5T3lYSGJ3Q0Rn?=
 =?utf-8?B?ejZONm85SDhmUGZ3TVNjdXo2YmRJckl6aGQ2NXU3ZXZSN0hobUs5YVQ4cndZ?=
 =?utf-8?B?a0NTYzg1SmZvRTV2UFQ0MnF6NFQ0czluekVYeWQzdFBqY2Iyd05IRjFoS1Zp?=
 =?utf-8?B?MkRNM0NNM3krQTg3dm80dGhUcC9uSWdYMTZZYkF5bTZnYk1FdE9RYlFHN0R2?=
 =?utf-8?B?N1ROd0N5V1NzSDdGUTF0QkhMWWpoSC9tYytmOEJqMzRQdStaY0JDNmZXRFBR?=
 =?utf-8?B?aHJsZERVS3JZRHhxUDhpR3V2S1hMSTAyb2ZjTUs0MWc1R29uUlIzYnZjdHB2?=
 =?utf-8?B?SjRacXZaY2FFVnBsOFJPWk51K0NmeW9pS3ptcG5lUnF4YVY2WkdOcGltQmVR?=
 =?utf-8?B?cldYRUdOSnRPVWE2Z1FLQ01ETzRhZHpYMTdnUUk5YnlobUhLTFU0Vmw3czZT?=
 =?utf-8?B?NEkzdG0rZGkrU2ZDR0VtbWpZNW1vemREOFpOT2tMNmhJZ3h0Z0dhTnZMZEZz?=
 =?utf-8?B?MXl0a0JoR2dmME9ZRk1vbUE0UDltTEppeGlZQ21UU3o3ZElOVlFiOGtoYXdu?=
 =?utf-8?B?eVBRWi9nT3gwb1NNcVZHeDdZNis5enlSMmJNcUhBa2pXWU5JZFhacUp2UWNC?=
 =?utf-8?B?Q1BmSkI5NUp1dXNTL2ljTVFWcFl3U3FyMVhsY2Q0aHgzei9rSitiN0VVN3ZP?=
 =?utf-8?B?Y3NJQTErSWRPc2RVa2xXWFVsYzNZcDdjUjEyc0tLajZqL0FMWjQwT05PZkg4?=
 =?utf-8?B?ZVd5YXRPVlF4RDR1OG1WeXhtZ0hkK0FrZTl1ekFaWUdySDFRcUU2ZmtkWnhO?=
 =?utf-8?B?Vm10VWw4bnQwcUFzOVo5NUFnamRVUzNiMmowTXJBWkZWR1V0VnpqbWthTHU2?=
 =?utf-8?B?czlNY1k2amhJcWtNelZmaEFxZU50WUpqL0xRZDNQZ1RnajY1QmkwYnNaZWl5?=
 =?utf-8?B?NVdlbHQ4NHAxNDdLOVRvUmxCUTk0YlVMMUYvYW9iT0EvRnJkOUdOaThNd0d0?=
 =?utf-8?B?R0xtUlFkenFrRVFVVXdGVE01eFJBUHNUMlZRakxTRlY5a1FHR0MvTWU0R29t?=
 =?utf-8?B?RFc3a2FqM3lQeG1KVG1nTjBXeUpicFpsZEZxUVBaTU5FYkNEYzJYSkpVY3Zo?=
 =?utf-8?B?QWplekIrTEJCa1hzU0VEdld0QmVGTGUzV25pWWtjM2xOOW12NVptdmdnbS8z?=
 =?utf-8?B?WlB0TWFlRzJzekR1bXFsN1Vvd3ZpZlJOSk1tY0tvdWQzYmNkOEFsYXZvdVhZ?=
 =?utf-8?B?dU5md1cyS1dYenBOY2pSbWZkeWJVYmw0cWNwdVU4VExENlNZZGhjS2QyZEs0?=
 =?utf-8?B?enZuYkZuU1VNZHhoazg5bkNFTU9ZNXZVanI3b2J2UnN1U2EvbkhFYVhDak9o?=
 =?utf-8?B?UnNJMHRxRUNMNG96RFRKT2pVbnM0SFo1b3RzeFZ1RFNLL1JlektCb3JuL1ZT?=
 =?utf-8?B?bDJTN3RPbkVUTkFGQmw0aFc2VU8zV2FTNllmZ0xITlNIRkdnKzNsR01BL2I0?=
 =?utf-8?B?MWZXU3pOREdrNy8rbkxyOEdtMG5JYkJERkN2N0h5K2cyR2hxVFMzN3lQTU5w?=
 =?utf-8?B?Uy9CaGp1ekpvaXJrSk5CaFh5MXRYWndtNGd4QXI3N3dsRlNNcFE4dkgwMHFW?=
 =?utf-8?B?ejkwUTRLSVQwa1k0Qk14cHZCYVZzeGlQVDNoaUhYYklwWHE5VTcxMUhSWjRV?=
 =?utf-8?Q?Qv7ZFhfGx5zZiMCyzzRR94bCL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2cc7c2a-197c-4349-cab8-08dad1a1f040
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 00:37:47.8486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jl9W+zU6kdsyUB0Qoc59nKoIbFNrr5dkEp+HWKJ5ndgqwXlUQ4yVPiyQmD74NJNA/SWmWUXzKB4liWU/2Uyfmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4945
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 3:37 PM, Jakub Kicinski wrote:
> On Mon, 28 Nov 2022 14:25:56 -0800 Shannon Nelson wrote:
>> On 11/28/22 10:28 AM, Jakub Kicinski wrote:
>>> On Fri, 18 Nov 2022 14:56:45 -0800 Shannon Nelson wrote:
>>>> +     .ndo_set_vf_vlan        = pdsc_set_vf_vlan,
>>>> +     .ndo_set_vf_mac         = pdsc_set_vf_mac,
>>>> +     .ndo_set_vf_trust       = pdsc_set_vf_trust,
>>>> +     .ndo_set_vf_rate        = pdsc_set_vf_rate,
>>>> +     .ndo_set_vf_spoofchk    = pdsc_set_vf_spoofchk,
>>>> +     .ndo_set_vf_link_state  = pdsc_set_vf_link_state,
>>>> +     .ndo_get_vf_config      = pdsc_get_vf_config,
>>>> +     .ndo_get_vf_stats       = pdsc_get_vf_stats,
>>>
>>> These are legacy, you're adding a fancy SmartNIC (or whatever your
>>> marketing decided to call it) driver. Please don't use these at all.
>>
>> Since these are the existing APIs that I am aware of for doing this kind
>> of VF configuration, it seemed to be the right choice.  I'm not aware of
>> any other obvious solutions.  Do you have an alternate suggestion?
> 
> If this is a "SmartNIC" there should be alternative solution based on
> representors for each of those callbacks, and the device should support
> forwarding using proper netdev constructs like bridge, routing, or tc.
> 
> This has been our high level guidance for a few years now. It's quite
> hard to move the ball forward since all major vendors have a single
> driver for multiple generations of HW :(

Absolutely, if the device presented to the host is a SmartNIC and has 
these bridge and router capabilities, by all means it should use the 
newer APIs, but that's not the case here.

In this case we are making devices available to baremetal platforms in a 
cloud vendor setting where the majority of the network configuration is 
controlled outside of the host machine's purview.  There is no bridging, 
routing, or filtering control available to the baremetal client other 
than the basic VF configurations.

The device model presented to the host is a simple PF with VFs, not a 
SmartNIC, thus the pds_core driver sets up a simple PF netdev 
"representor" for using the existing VF control API: easy to use, 
everyone knows how to use it, keeps code simple.

I suppose we could have the PF create a representor netdev for each 
individual VF to set mac address and read stats, but that seems 
redundant, and as far as I know that still would be missing the other VF 
controls.  Do we have alternate ways for the user to set things like 
trust and spoofchk?

sln
