Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE8F6082E7
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 02:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJVAfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 20:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJVAe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 20:34:57 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2077.outbound.protection.outlook.com [40.107.96.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D77631C4;
        Fri, 21 Oct 2022 17:34:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MD64DrTwvi+RTNL+qUvfC9rqlOxIA3TgkubVwbuMXB8gpOzJwvsxch0cK2k5pwku2XSERoaEeFePsnsIupRcd7MTgnEdM+3v2pZxV+13jvs7xsEgShJ3P291Ify9PbE3vWH7smsq4LkEL0fbH93cpZvoXzlYZ3JKOobu31c0DTXnsC3U/JGlqrZlwChhQB3YhwPkhTPZymn3i3aMhNUWUvUORvEsKPUDKKR+EmPFiirJZqjsK2ACAP1Th51eV5Kd6iyTvt2XhaH85x2gU7DRnwS5AbpkHxJPtwcbuHCwbRFQbcJO97Lyg3i2h3XPZu7ovY+GhePvYoOGLlurAn7oEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QSjtYw4fGNUvlz0t4xmKEfUUEFqIrvVANGhV3862hk=;
 b=bLExHY3ueg2pMVe88G+II8SFPp+q5YLGqJ4BUntUlFWhpSc8qOKPq0WEYERz+0SFU5RvpHdkO0jAKe2mjugkWd+zQpEwB602c1rLqfiMaSfry+HUtdmwq5Fvr4kU5lrW9/DtZCo4VhRyUID+H9Gbqszl6MATQdTEx9QdZU+Vaj1uaUVDcxmu8IAVWbyQ7T1YVJsGkzPO5Xt/Zoxp05MJjQOfnka1fduT6Gsr1ygSmR7n3MeaB999KtoFA24d4cHXBVhKIzavzznhPyyccK209fwrtsqalK2Zj2/dR+8V4XRiuz70C5J6MaaomoVVMuI5XE2ikrWal43sx8kdkPoYlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL0PR01MB4434.prod.exchangelabs.com (2603:10b6:208:81::17) by
 CY1PR01MB2170.prod.exchangelabs.com (2a01:111:e400:c615::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.35; Sat, 22 Oct 2022 00:34:49 +0000
Received: from BL0PR01MB4434.prod.exchangelabs.com
 ([fe80::28a9:57b1:9a6:c5d4]) by BL0PR01MB4434.prod.exchangelabs.com
 ([fe80::28a9:57b1:9a6:c5d4%7]) with mapi id 15.20.5723.033; Sat, 22 Oct 2022
 00:34:49 +0000
Message-ID: <b2de197c-0c5b-c815-23c8-3f90c2e226ed@talpey.com>
Date:   Fri, 21 Oct 2022 20:34:51 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
To:     Long Li <longli@microsoft.com>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
 <1666218252-32191-13-git-send-email-longli@linuxonhyperv.com>
 <SA0PR15MB39198F9538CBDC8A88D63DF0992A9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <9af99f89-8f1d-b83f-6e77-4e411223f412@talpey.com>
 <SA0PR15MB3919DE8DE2C407D8E8A07E1F992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263A40A380B9D7F00F02529CE2D9@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <PH7PR21MB3263A40A380B9D7F00F02529CE2D9@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:208:32a::25) To BL0PR01MB4434.prod.exchangelabs.com
 (2603:10b6:208:81::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR01MB4434:EE_|CY1PR01MB2170:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a889af5-6979-47d6-b6ab-08dab3c53a48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JTb8Agq20itwdKVGeg/EJ6/YLMMFQBwloAX+77XvlEheHQOY3X1dvmc2gZjh4acGzklRf1YOE8egUHOocOoAm7KJ3ZDu2ODC+4j25GJky8/qekvZy5bcQX7UC9XLUgaOWMuCGm62bJugDLahcgig4eOwJluO46iFxTLLndxckj4zxM6wHBrGqjJy3chTlyMENht/KSswgCOw9CgxMjPLwFaJgHraJXwMQ9igFRHnU8dGlZxm6MqTddghiniZGpo4k6VBR/gM44tN06OhpX9PGPg/8ibkNbtwDnsbGb/EWSPcrzxUu15lEum0RAL8PzI1c0W3ii9Rmz2YfgPoxX8dpz/m2dOhxyVAzDrbfB9gGfFVZ8sQ5PBTZONkmKMietyRw4yO/7+DNf2UXxGmlflru9xw34tPxXjH7k0M3d55yyyPOiLDU+kqCkzTIAnZViBi3KP75AAyLqP22RbHfwjd6ruHz5w8vt8g3+hm2K1ltKn0U0ih/9Cwia3il89VLdGmpb4a1ho+lO3b3AevAvInqBBm/64D2j4LGgPutf0G3gKAB+j4VkVp8MTfkW4dJ0wo/uvOepf19/pG8iMyM+I81Jt7YJlo31phuyqdxVeiS+Rtl+ZaYdPvemy3NPqVFpcCaLlev+ugTwVggFGpZNFQ/KJZ6dlYADC0Hav+H+AAUyiz88/l4csmdCut3yqb+NP0izxZZ8B+LtfL+DRK1xm2Zr+Rq6JDV4IaaV0bvbFTxH8yGBrDeZi3IZX5+Rn9Vr/9m5ZyD1pScIedKt8s8TyiM0BQYcWcTKwRJHgPMHxKrlwTHWGgR/U3pyg+ax+AjOEA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR01MB4434.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39830400003)(346002)(366004)(396003)(47530400004)(451199015)(36756003)(31686004)(86362001)(921005)(31696002)(66556008)(66476007)(4326008)(8676002)(38100700002)(38350700002)(52230400001)(83380400001)(186003)(6506007)(6666004)(52116002)(2616005)(6512007)(478600001)(66946007)(45080400002)(6486002)(110136005)(26005)(41300700001)(316002)(5660300002)(54906003)(7416002)(53546011)(2906002)(4744005)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dm9GU2ZNWjIrd2ZwVTdLOFkzazRiVzhtNE51T1I1Q1BwcDArSTh1U2VKT0JJ?=
 =?utf-8?B?Q3ovV1FydnhrMDdJUzg3MDNaSGlSNDZSczJ0MnJ5bGREb09MOHhsV3Fvdklj?=
 =?utf-8?B?Q2JBM0tEVzU4VEFza2pkVElZcDVSdGcxNDF0YWthNTM5ZTVtVVBsUi9lM2NK?=
 =?utf-8?B?ZW1zUmZGYjZtSXIzbmVadTVMYXNvQkRCWk5tQ1FIQ2JndlJkYnFsSngzeTJF?=
 =?utf-8?B?L29wS0tzNTM1OTdNUGRTZ2NKdDhLUmN6UDZObFNkM3B4RkhhOTdyaWpmMGov?=
 =?utf-8?B?VDcwbmFmQkd6N01iWGFZSW9CTEJkUUpyUVA5UUdaOEdvY3dBMGRRcGxvWlZk?=
 =?utf-8?B?V2FNNTNsZlNEdmtXejZmOXIzaUVKQzZVaUdLUlc0MklwSjJyTmg0MWJxVnRG?=
 =?utf-8?B?ZnFFdlRMb3RML0xYWnd2cThGT2NiZ3o5ZnRPSFFsVmNtUXIvNmdHOUNXaDli?=
 =?utf-8?B?Z1NoQjJ6WW5ydGFDN0ZZMFhHQzRHNytxOFZMTUV6S04zUEtCU2w0aGdacjlE?=
 =?utf-8?B?ZGphZkRDWjRNeGhKWVN0Qnp1bkoxYzlUbDc0S1c5T3FmbkcyZFhGMEJraWcx?=
 =?utf-8?B?akxHTjQyQWJlOHpzK3JCVzJ3bHZURktUb3B2UnZyU2JDcW5weEhUeFk1MTBi?=
 =?utf-8?B?eXh6NGtsTWgrY00rdTRhT1h5b0I5a21CMGY1SzBkZlgyNk5sU1BxT2RmR1A3?=
 =?utf-8?B?Z2RISzE5Q0tnRDhvdVhEVzAyblBLajlxM0FDMFNtNEhPanh6QmRJK1F4d2xC?=
 =?utf-8?B?QVZnczZWa2d4SUM5VWh0eFFRaTB0ODhxVnR1K0YwRDRIbFdvTXRncVRiV1lC?=
 =?utf-8?B?U2VmZ0ZVbmwxNW5vazFrc3hNT3FrVzg5Ly9zWTljeW90Y2ZMckNveFRQa3BQ?=
 =?utf-8?B?TU9PbFE0UTN5QVdidjBqR0g0Vnp0QVZYMUFKc3o4eVdNUkp6YzRtOTBkVWFw?=
 =?utf-8?B?Q3FhTXkycTdwUU9qN05VelY5MjgxWlEyVmxsMzNobkdOZWxsZGxwMDZjamM0?=
 =?utf-8?B?TjE0SkJBdTFXajBZSGRkV21ydmZvUWJZYkFmRnB1RHNUdHdUSzJRYXBIblFt?=
 =?utf-8?B?OU9nN1YyVVJnSWVwUTNMdTJRVHNMeUVGVmk1cEJlaTM3L3FGY05kY3Yxa3d4?=
 =?utf-8?B?Z3RxUnpnQ00zUVhvT1RJMHhqYUI1ays0L1Jtc3IvNitSeTFZTnRtekJtNnpD?=
 =?utf-8?B?QXU0RG5ZbnlZRDRqd3RjMzZ0cXVBRmwzKzZLNkIwcS9qQ245YkNOY2ZjN3Vm?=
 =?utf-8?B?TEh5YUR1VmcycTlWWkUxOHc2RzQrVmdGa3lCT0s3LzdJWmpkVTVkQ2dJZDM0?=
 =?utf-8?B?QzViVDMwdWlHNm1sNysvbjQ1eVpuZW9GMUUyQWZxUmtiSzBYNlR5bHJqUTJP?=
 =?utf-8?B?NVU1Z21aNHEzV1VnK1VVbG5rUGlwd21RMkl2KzBEUkw5RURLYWIzZVJDQ1R5?=
 =?utf-8?B?Q0NzNmhUQ2pBSG5PQlkySlJLcnNzTWlYUGZldVdvZ21meEFBYlFxNVNMdFda?=
 =?utf-8?B?TnYvQzZjbXhRS2UwVExac0V1WnQ5V1ovTlJrekZPd0FXOTFKYjhhK2NiNkM4?=
 =?utf-8?B?UXMxYUhWVEc0eEo3T3FOcWFNa21BTHdlQVJ6QjVZbHdsandONHk1UUV4Tjgy?=
 =?utf-8?B?VSsvNXYvRldrczVaSk8xaFA5bVM2TEtWOWhhaFVnTXg5b1R6eFkyK3R6RFJH?=
 =?utf-8?B?a0tkNkw2T3IyMTBnNis4N00rU1B4OER2UFhPRldkR0VMZUNReXFkalBHOVFt?=
 =?utf-8?B?UERjRHlHYjJqNGRpem5kbTB5OFJOQ1Nuc2J3ZXM0dFVvSTRCRDZhTVB5b2RE?=
 =?utf-8?B?SHB2NGxQdGE2L2VtcnBLVU9Ub1NxeStVSG5XcXFtbEZYb0E5QzlEc3ZuejRm?=
 =?utf-8?B?MGNXckdXb0hmRmFZSnpsWWRILy94MjVydHhic0xnc1djWE5YN3RJK0lUbnp5?=
 =?utf-8?B?MWEzaEp2amJEUHA5VW5tNzdON3hieVpZemFLZ0tWc0JvclZCNzhxQnZtSmZu?=
 =?utf-8?B?S1VTR2dmdGtRaWI2NFBqRjN5QkZvMnd5YWRBRDJaR1VJczlJNmJFeXVyZkN3?=
 =?utf-8?B?RWNTRlBHdHhraXZYeUErbkpDdjZWTEtWWGNBRmltWEVxUUFYQUNoVDFuK3NP?=
 =?utf-8?Q?t5T8=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a889af5-6979-47d6-b6ab-08dab3c53a48
X-MS-Exchange-CrossTenant-AuthSource: BL0PR01MB4434.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2022 00:34:49.5838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abHS8mcOvzndnenzLDjqo9amJ5g2BNwp7eNy8703ksN5+XPm/r02ZVjUJ6qftMmT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR01MB2170
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/2022 6:55 PM, Long Li wrote:
>>> The upper 8 bits of an ib_mr remote token are reserved for use as a
>>> rotating key, this allows a consumer to more safely reuse an ib_mr
>>> without having to overallocate large region pools.
>>>
>>> Tom.
>>
>> Right, my point was that one cannot encode INT_MAX different MR
>> identifiers into 32 - 8 = 24 bits.
>>
>> Best,
>> Bernard.
> 
> The hardware exposes the number of MRs that exceeds UINT32_MAX.
> There is no software stack limit from hardware perspective.
> 
> In this case, maybe it's a good idea to set it to 0xFFFFFF. I'm making the change.

Actually, 2^24 MRs is enormous in itself. Does this driver
actually support that many? Without falling over?

Tom.
