Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FD1561F3D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiF3P1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbiF3P1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:27:16 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA763DDD7
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:27:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljB9bLjK2DfSPSwNvaM3weNik2mcI1+S+L+S8aPwHDnh/cUibjAlICExZCPhYs835FTgZ1HNgpY3BKuY9hQDmE2hk/EhnEQVy6XLtfhv2l+l1yVRpBfua1UTIsutI5342qgYSJ9Xm8BS3ANDiB9z2xBhBxvr+8AEJD9+DivZ7kbXVDxX1mc0+GLlFnf6G+9jExSDVIaM1RaT0BOt9m/LI486V5i2vQP0aJ52TSpyuYZB4UJ84LR2JOAxLM2Mz5yQNBfbu/eh4wwx0TKcUw/Odsp0Zc+dpQ4S2twn9LEKisTFwCvuCh2A/qH8p384JjSTKWwuPVgVZ5MSPquJsvtmbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSZCVQsRpXZT87usWC4/aOl59pmtEnk/O0Zb93QZ4Uw=;
 b=KNXNN2urIHAoreEpt+eoj9lqoJ15Qmry60OgMyGPRKysnmuOmG+jP9ZBvUyTbnxLLVXQTvtn+lrocHb9ykaUKeSiCV1r6YN1jeYJr5HlHLXNybTTiW6pM6yp4caPhMEcZGk5BhDIxQnfLM0j0rz4sxsZLjCzHZ1aiO4Pw1dClCWdtvmqGSbezf8LbpLVcMk6WiH4Y9WkDxi4oQt1Vc/2Q1rC3heKJE0BAcPVToter61+J6s0qDhv6E2GazTeWCsRx0D9G3YV+MoyzCrHuECX2sUFAQRn4mcjYrVoVkNij7pnHv6N84CM8XD+6RnletHXOsbE8W6Rpp0GF5S3M0qkDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSZCVQsRpXZT87usWC4/aOl59pmtEnk/O0Zb93QZ4Uw=;
 b=mDmXmqeyWbqeJGwPkYlS6QwL4NqYtSw3I9kYv9XLg2ABmBFsXwhvlGvjwrq3z1l/ZrQLQNLJZJlA13vJqs5wra7cPBvjKgOEZjnJopEN2SErMT/8/0vpHfHCfMOb8yI9jNqSMGMEpikssefH9xGvToHwzOfZRVtO/dqLGX8w9LtxA1UwYoPX0HcrXGMJhHYoiQKuaOXBS7l65YM/tFv2xPtl5POgyrzbjwAp7YcYZ7bfNlsQ6lPQByPEMsWALMsBnvtJch3ovLZjQvPW5/sJcLQ1EnZO2E9rrFTHngVLu/E4bDfLIPmHIhDuqfr0ZY+9EsLoUM9rJYHFZ7hCEQSI0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3725.namprd12.prod.outlook.com (2603:10b6:208:162::14)
 by MN2PR12MB3936.namprd12.prod.outlook.com (2603:10b6:208:16a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 15:27:13 +0000
Received: from MN2PR12MB3725.namprd12.prod.outlook.com
 ([fe80::dda2:9cd2:27b3:144a]) by MN2PR12MB3725.namprd12.prod.outlook.com
 ([fe80::dda2:9cd2:27b3:144a%5]) with mapi id 15.20.5373.022; Thu, 30 Jun 2022
 15:27:13 +0000
Message-ID: <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
Date:   Thu, 30 Jun 2022 17:27:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20220620152647.2498927-1-dchumak@nvidia.com>
 <20220620130426.00818cbf@kernel.org>
From:   Dima Chumak <dchumak@nvidia.com>
In-Reply-To: <20220620130426.00818cbf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0156.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::17) To MN2PR12MB3725.namprd12.prod.outlook.com
 (2603:10b6:208:162::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8196b8f7-52ac-4022-42b0-08da5aad01aa
X-MS-TrafficTypeDiagnostic: MN2PR12MB3936:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vn7gBCwsLV7IGc+W4JGaNGcXtP1WJhiMuQMOeEBXc86KhH/UhB904Z7nZUbcJGtrHnwg6O8VL2UL282+3nZFi2kKaBfBFmIplNN4rlIjl7JqTK9EEjz8lZBwggbzow6dPaFZjzg+7w3m04GLWW5CsPbT1+Hw8CenLX2eXkyb5zyJBPh8Ks8Jko+Q4JH3K9ZYs5xsk1asQ3o1AjRrkbN33K40xggZTuY4f0f/65+3aiuA5WayOY8NMiU9DDiPHbkKRBkR7eU/lW/SJM1pif18yFbqPth7jNSqIe3e+9XQQUoqgzMcyMz7dYbYy6mPqdEhRWFt4aqtpZU+ki4YnVGgxcdekof7cttzUk6wWXYSbBjcJuTacWbvLEC+SKJHl5u/KkMMZz7WxhRrP8O3LW3OjHp5+l9y3mrFnV1kTLMFN20JKyPpZCjtUy0IqXOaOQc1T6rfDDd6RLuZ04kTvsLiAGFTpR3DRAAci0j+xSRd3mKbRxkcVVVKoS/pCKKuN+ZyvlyqpYLoTscnMIwj0QZs9J7mIujhMeDLtNUD8gzjhJhfA+Vc05kSYkKK/v4R0Z7EodXo3U/MOZ352I4/xZ3PFk/V1TxN+uLHgwJgKfYtbYvCIuLH9WKY8WyOxNnpKwHnulIEO8t4ivTGUMEuMrp/k7mmwRW9N2uSl+2IJ3DBiKxsJreCpTigX8XPQaPQ/+AlycOnkTpzyOIyVnYgs5i+wYW7fvBrTpWv2GA2AovyT7CXSO0kLpmz9esHIETSYa2dD/VHzYuIm4ofwaxEe7bO3v2zyZt/HsO3Jn/3BqCGythj3MZZRXOnm8I4hNrjV49QmDWg2/eOS/X82YHbSa8NvCeM+ERCNCuw0f5+etFOXNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3725.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(186003)(2906002)(26005)(6512007)(2616005)(83380400001)(31686004)(53546011)(38100700002)(41300700001)(6666004)(66946007)(66556008)(54906003)(36756003)(6506007)(6916009)(8936002)(5660300002)(478600001)(4326008)(66476007)(6486002)(8676002)(316002)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WklEV1Z6ZStGRkk4MmJiZ3ZlYVBpcnlITDAxRmNHSXZNM1JrRjJidGs0cGVu?=
 =?utf-8?B?Nk1KeVZWNCtZV0JHZUhIT056a3hOZ3ZOdS96U0V3ZlpxMnBLNEhsZHZYZmtL?=
 =?utf-8?B?N0hNNlBYMjl6Vkw3dGtRZnYxSmo0MnlKZjdoUFFwZnIwZDRHa0xwZmZTNkVR?=
 =?utf-8?B?dVkza28vc0pTRldLak5YVlRZUkl3M1J5Y3g3NmFjNTZlcG12MGNYWTFEeUFC?=
 =?utf-8?B?bkFXWUtkZ2psZnZMVThHNzFBQjJqTXNockV6cVBLS3pzdUpTMWZ4Ulptcm5n?=
 =?utf-8?B?aVNXdnl5U3lpTTJaL3kvNXA5dDRyd0pXNWJUc2hBZExSc0tyRjJpMnR4M1Bj?=
 =?utf-8?B?ZWh2OThUMG5ZaFVkM2ZqbnN5RmpkRVBxU1h5NDg3ODJYLzR0VTBvUlNpSGpz?=
 =?utf-8?B?SDMyQmJ4NzRzLzUyL2ZqZGdzU3RwQlNLbmk5ZHNycnFaUzZBU29pVlozdEJp?=
 =?utf-8?B?RFpEcVhhbzgrK1NCOXlBajA4RXJvWUdNcm5Pem90bzRKNU5lc1E1OU55Uy96?=
 =?utf-8?B?WCtndnVUYTdJWTlSa2Z5Q3ljTy9GODhjRXhmSDZ4VjJvQmhPRnFicE1MaFlO?=
 =?utf-8?B?VnYvamVGMkVXcVhET3RTVnF6WmlpaW10aysyMEw1eTVwT3NZaVM1VmtobVRM?=
 =?utf-8?B?TWFlVDk3Tm9nWk4rWjRScUpMMTBwYWlPdFczaDFZbUcxZmRsNGZ0ZFU0cU9q?=
 =?utf-8?B?YmM5RTdiMlNEY201dVUwYnJPYWNBbHpCMGJ3K2QzTVoyTW8wNkQ4cjcySGZR?=
 =?utf-8?B?WE51djgzV2dLd3NMN2RtaFpsNzhJVWVnWEhpRlllQVl6SVE0TEVma2YvS1M2?=
 =?utf-8?B?ZGJLMFBOYnk4TWtlZ2F5V0lQVDNzbGhjS1BxdzZzdXdTSEV1eFJOMVgyYTZw?=
 =?utf-8?B?SG1KUjJvQThPR244bm50YlB0RURwaGJZL2lBQVg4aWpJdWFlZG5xVUMxRUlv?=
 =?utf-8?B?M2VEZ3lXRU9IUFVNNFZlSUEyVEFHREN6SWlObUIzV3lPd0xLTnNGQ2JpdmZp?=
 =?utf-8?B?RVIvUkVuUmZnWCtTOEZwK3BVNDJiYkcrUU9TS0N1VjN6dlFmUW1QVWlwUWpO?=
 =?utf-8?B?cUNHSWdjTG4vRUF4dWFoSnltMEMyOEFoZXlXTFQ5K2Z0RkM2YjhabmtNYUs2?=
 =?utf-8?B?eU1HSUQwc3FtQjgwTVAzd1RUaDVRZlgrTDZmYU9ML3VFbnJ3RTBqWW9XaUE4?=
 =?utf-8?B?SXo5SWV4cno5R0pldFJteklhaXZaeVY2QXRiaitwY1J5OXhmOGhSSmw2eHdX?=
 =?utf-8?B?NEdvbnk2a09vQ3VJR2prSk1XOTBBWDc2MWRUQXdxdlc5UHpqQy92a0U2NXJD?=
 =?utf-8?B?VjlPbEg0SmprOGExOTNZbC9lTUdPWHpkbzI2aFZCbndOL0JKcE9RZ2NWVGhm?=
 =?utf-8?B?VktGNEZwRDRETVZ3Q1ptYk1oQzI5Vmt0ekNEdTdXVFpTcHlKazM1SU1Ja0wz?=
 =?utf-8?B?bXNDMXFNUTZCNURZdUlram9qYnROUE5BMnQ5S1JwVXExVlU0NHhxRVlJQ08r?=
 =?utf-8?B?YktZNitYUFZNYkZlcDFyOFJoUFd3VHFEcjFRWTFid3k4clh3ZFJmZDVSdGZi?=
 =?utf-8?B?c2piZjVDQWdua2w3UlZPQzJrN2RzVkdhMHZjNnJmWEI5c3VNaXRiK2o3RVoz?=
 =?utf-8?B?MngyNGZtS2k1S3pMam9CWnp3ckNPNEVMTURSWFZEWndiVmNkbmxFbkVnVWdU?=
 =?utf-8?B?RlBvSXNoMGZ4KzdMMFFabmg4L3hzaHVEN0dBTHhpb2lxNmNyaVpCU2FZUEt4?=
 =?utf-8?B?M0xYTDlxNE53b1FZR0pIRUg1Q3JPVU5nN3Y1VkJZN0dzUk9KSDY5bi9hNmZ2?=
 =?utf-8?B?WGdEcXZjMmsvbWkwS0RtK2d1cTNRN3lEdEl5cmdEMWllUEJjQTNERGhvcytx?=
 =?utf-8?B?bnY0SFJObzlaT2VEdDBsZHRSWHlJZ00vQzRGaEJ1VFJtVVUrcXdpTzVrSjdh?=
 =?utf-8?B?QzIvZlh1QVYxdVdObjQ1OFZOTDF4aEgxa3MxTGNDNktabXlCM0VOYU8xa0VR?=
 =?utf-8?B?Y1BYWWF6UE5PN0dVS0FuVTl2QTIwejdjMUxHQmhjcDdHWlord2pQUEdNMDY5?=
 =?utf-8?B?WUlabEl6SGZFamREcHNmaUM5S3g0WnRvWXRtU3FpWFoxc1JyOGoyWlgzc2Ja?=
 =?utf-8?Q?USTOKH38gVi6HV+cOlX0LUNli?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8196b8f7-52ac-4022-42b0-08da5aad01aa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3725.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 15:27:13.1998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYWDciKTuZGEH3TMtaAJwWNJgqfIeyMvBAcDjUzRdFS1txXnevnRlj6oUDDG4dzNKVY18Kw+Av/aekwLqyRtJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3936
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/22 10:04 PM, Jakub Kicinski wrote:
> 
> On Mon, 20 Jun 2022 18:26:42 +0300 Dima Chumak wrote:
>> Currently, kernel provides a way to limit tx rate of a VF via devlink
>> rate function of a port. The underlying mechanism is a shaper applied to
>> all traffic passing through the target VF or a group of VFs. By its
>> essence, a shaper naturally works with outbound traffic, and in
>> practice, it's rarely seen to be implemented for inbound traffic.
>> Nevertheless, there is a user request to have a mechanism for limiting
>> inbound traffic as well. It is usually done by using some form of
>> traffic policing, dropping excess packets over the configured limit that
>> set by a user. Thus, introducing another limiting mechanism to the port
>> function can help close this gap.
>>
>> This series introduces devlink attrs, along with their ops, to manage
>> rate policing of a single port as well as a port group. It is based on
>> the existing notion of leaf and node rate objects, and extends their
>> attributes to support both RX and TX limiting, for a number of packets
>> per second and/or a number of bytes per second. Additionally, there is a
>> second set of parameters for specifying the size of buffering performed,
>> called "burst", that controls the allowed level of spikes in traffic
>> before it starts getting dropped.
>>
>> A new sub-type of a devlink_rate object is introduced, called
>> "limit_type". It can be either "shaping", the default, or "police".
>> A single leaf or a node object can be switched from one limit type to
>> another, but it cannot do both types of rate limiting simultaneously.
>> A node and a leaf object that have parent-child relationship must have
>> the same limit type. In other words, it's only possible to group rate
>> objects of the same limit type as their group's limit_type.
> 
> TC already has the police action. Your previous patches were accepted
> because there was no exact match for shaping / admission. Now you're
> "extending" that API to duplicate existing TC APIs. Infuriating.

I'm sorry for not being able to reply promptly.

I've re-read more carefully the cover letter of the original 'devlink:
rate objects API' series by Dmytro Linkin, off of which I based my
patches, though my understanding still might be incomplete/incorrect
here.

It seems that TC, being ingress only, doesn't cover the full spectrum of
rate-limiting that's possible to achieve with devlink. TC works only
with representors and doesn't allow to configure "the other side of the
wire", where devlink port function seems to be a better match as it
connects directly to a VF.

Also, for the existing devlink-rate mechanism of VF grouping, it would be
challenging to achieve similar functionality with TC flows, as groups don't
have a net device instance where flows can be attached.

I want to apologize in case my proposed changes have come across as
being bluntly ignoring some of the pre-established agreements and
understandings of TC / devlink responsibility separation, it wasn't
intentional.
