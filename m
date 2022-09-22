Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3F25E63D1
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiIVNik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiIVNiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:38:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBBDABF02
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:37:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGnBX6wgFNOQ2rv1V8YCzQzuXRwvD+3l3qg2rmNDfMg00Eu2nuBtTFeKANwLW6nm7gly20IDl9ELlPy6YM5mF3pyTiReCL25b4goviSuhggfBm4pTzSnv1MmiPneg+eKOk+InZMdsTQ1CLFVEqe58lcsDeGr40uRuwpMA+MesZCGPKKD7B9gUd50rulRDRmgSM35/dIcvqHX/DdBwIavJxnMlbnBaap+czpWfO3crMbR9BUIiUGnsQVrNr3Ko4uGVAdaEUnpupCVg3QfzvmyUMXP10RoV51/T9owTM8ow9AvI7ykiR/Y1TFYvTOnEdRexTVKJCq18uFOYbAOAM+mjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPGLlBF7X3EAEWgkgOO9zxHIg3QBLLVjoPlFJgSXmkw=;
 b=aA4OS9aP8zvsrtQcVueOU6Wk7ibrQI552X7xN5c6J4gxXoBmqfBZNOlnfjS/ZKnP0fk9UN5AxbJDnytVFg3uKXHfSzD2agD9VSEqh1EljtjgNea+1gPl+hnsjfxHRFnW6/wTWSiozeJwH1gSCFP33mgcimWSJV6e8YCCnvgySSvD97Jz4aMu/3T8i8pueg+oJCQn/aB9rjL/fG++8zEH8SWG9NyOnCy1xnXhUTvBrBaJkftk8vfielu6Fem2WfTswthChUTqGzaanepDADMkeFGCPIOowarahJ3hss84J5R6ZTJ+m0CIuOfHljtx11kOG8tyF8ZsSlu1z4xmIdRstA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPGLlBF7X3EAEWgkgOO9zxHIg3QBLLVjoPlFJgSXmkw=;
 b=qCUnRKNnelkCL+ocie5eRrjBKOVzGfRuJugcq5d7FneSOSmpNbqQJNrzPqP26SL5KDp1+m24lEqWSvOq8chaopRK4Gc/YzYQBKfOggqOYdoeYwQsqJEVB3Ljh9rA39SSMHqehRNNdRQgRzis5n+vv3ujg0WvE/NPLZS3UBHbMtnFj/Tndr5pRELN80qXxiWoPMsdDqzLK9roCcoBLul7oD0fvcD3hJ+6T09zyhCXhzsutfDac02yTqkD5XKNR+wXzZK4ZWSPizAll5H7QsK7tUJm/OABzh2hmC7dIm0e8X+HVgXqC29dyq2zIywb6Ki8aOIUOrzrcNlFvNOxxXaHdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH7PR12MB7379.namprd12.prod.outlook.com (2603:10b6:510:20e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 13:37:38 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::24e2:5b76:cdee:bd15]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::24e2:5b76:cdee:bd15%9]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 13:37:38 +0000
Message-ID: <2270b3d5-a298-58e2-8d9a-96e6cac7f8d6@nvidia.com>
Date:   Thu, 22 Sep 2022 16:37:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3] nfp:
 support VF multi-queues configuration)
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220920151419.76050-1-simon.horman@corigine.com>
 <20220921063448.5b0dd32b@kernel.org> <YysUJLKZukN8Kirt@corigine.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <YysUJLKZukN8Kirt@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0140.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::13) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH7PR12MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: 1feba4ab-e8dd-455f-757b-08da9c9f9d9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQuvCH1uvgOJ1vlg/uPpITCZpAwcQk8pUSKcDYF7a6AK3/14VCZFKxw0cgY+JFP+2x5EfeNpuLwgzZoydRQqmlaVCJdzy2LdqZ9d8z+QDjaLMJZZZRPfym2q+7CKNPPWxLk7Gv/R3FffUb41CHGTDHxjmc/MXld1yqX97WE4lwPKry3X/C6z0phr7ifDFB4eNr6HZjqzwhgkLgLcG6ZGvr++3fKQDfu7ej8/QkKZhcTFNajvZEERL2Xjs+x8fQS5BDnJDwtAkuli1ht+C4PhOS0l9MN6F7i/uS+WXw6PD6YwbT4JV4WHfIPtrppVVcPkZzFgEJPhIcA2hLKVHohLeWH5D2xdpJA9Vw0stScspi418n80VVRWkchy3cs0hsQ+5r6uqWO5Qy264H72tUmLI5TIA9eOeyefiib8BbYKnBu6wMt8V0Wo/01ALa6Hm5kj6HvewZCja1xnj0VnC+er+L9geky8DGiLzTLTbqRGoO52Fwwdb/3X1uIN00kPQ8VyTl174aP8DpHIynLUqO04lyxsqvXl0J+ezYS4Lgxa1clQgFCYeiRVr1YKMlbkO5dSdgbkQWzmqWzjLBtXkahph3WW1nTdgQX8WdLI9MTU3Bfnlesoo+5dBvTj+tBB3VEXdVx2ppTec37MCHBbM2Hu82o1c+N+JWQiWW2UNwwuay7Dq2wByuZKAuxOCAw4EsIlZSguybEX1SkHYn7hJBmGmYRKMKkwZuIwymfiwc+A4+O8Nq0kkpu3sVbUeVji7jR9PpfqZYiX7UtYU20GwR21EJXhk/5eST4/3vNUEjz0az0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199015)(2616005)(7416002)(186003)(66476007)(4326008)(2906002)(66946007)(6506007)(8936002)(26005)(36756003)(5660300002)(6666004)(316002)(41300700001)(53546011)(6512007)(8676002)(31696002)(86362001)(66556008)(38100700002)(478600001)(6486002)(31686004)(110136005)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUdrZllzamFzNE1Dd1ZvZnQ1OXc1akRGcWpqcHh4UHpwNUN6UHVaTjNlTjFD?=
 =?utf-8?B?VlRzZlQ2MWlZaG4xWW91UlFsclIxQk5YTndhYUFnK2FydXY5TGphb1dzYWlX?=
 =?utf-8?B?VVRZNjZSM1VjcTVEMFFaZU5sTzdFMlR3aXZTRHZXS0tablI3bC96SkVDUXRW?=
 =?utf-8?B?NysyOUNNRlZKZGlPTk05RVpDQUtpWFN4OG1ETDdRN1VLOHhCRWdyd1BQS0dV?=
 =?utf-8?B?WERiY201blhOM1g1QVJXVFlPMnlzZVFmNlJoS21QZDdyeHJzaDBQSlR5OE4x?=
 =?utf-8?B?MlkxWVBGbG9tNFhWQk5ROTBWdTVtUnBrN21Cc0lldnFLcUMrQ2pCcVV3Titl?=
 =?utf-8?B?MWc4enRGTXhmc1VRaXQ1ZEpFK3lrZ1I4TVQwRllMemZETXZEN3VieHYzbUlG?=
 =?utf-8?B?QWtnZWlnTGRQUFVrNm45SnRRUjU0cHphWEN3aFFpNUwyNWhPSmQ2NGlVTnhE?=
 =?utf-8?B?bWIrWXBSY0IrSlhyRlU0YkJhbkNLM0U5VEFOMEtmTlA1ZGRGR0hEOEpsdU9E?=
 =?utf-8?B?aXdGWW9kcDdablNBMk1WSElmcndHVXRQaDQ3cWxxbGhxZ092WTBjaDhQZXFW?=
 =?utf-8?B?SWJvNVZDek82MFZCT0RoVHRyb1h2TW1oeTJWazRISWMyQ0xEZkg3RldIcjVp?=
 =?utf-8?B?K2RUUzlSSm1SN0d6QWlOY2trbUhtTGp0NVdMZmdBOEJwR28rak9EcVk1UHA2?=
 =?utf-8?B?UnJLUG10T1dJbWxUdTJyRG1CamM1aTJFN2ljdzI4ck95Y3o2K21lZEdFdk1p?=
 =?utf-8?B?V2dNTkpzWTB4L1lqNS94ckVIMmlwK25OZjl1L2taRytQMEJRQm9PMjZKc3lO?=
 =?utf-8?B?cHVDMzdqMzM1Z20wY2ZTYWwvNmpPWWhCUzIxOGYzdnJBbGdueXZKVm9PRm1r?=
 =?utf-8?B?MGFrQ0RVaEczVlBWNzRuK1NxMUdMOXN6NCs0KzRXak5zZlFsd0NiRUZwSW5B?=
 =?utf-8?B?azdIUkdBNXlET01rbGdCRjlQZmtKS0RUKytoZjNZRzlQVUZXd01LMWJpZnZB?=
 =?utf-8?B?dWk5aHdITlEwNGZDVVlna2RDTjRZRkJwN3NrZE1sR3hEWkMza3I2dWdaQW1S?=
 =?utf-8?B?NmVqbnJnQ0xSclc4T2JSZk9mVUhHdHlpSzRsSDZlcUhFYVRkcEt1TGdMb0JI?=
 =?utf-8?B?TGx3cmE1OTRMUnJYcmRlOXRKTGJoRGU5RkI5ZTAyWXZhMjUzbHJYQ09KNXIy?=
 =?utf-8?B?b0RQVHpVanZKRSt3WGl1K0Uzb0dDeXhucjhSMkxwbDNaaUx0eGlseXZKV3R6?=
 =?utf-8?B?eGRZaURqSS9FSlRyZWl2Zjg4SkhiTkRnbi9Hak1lQy9tTnZ5SUVvQ3Raeisx?=
 =?utf-8?B?NVkzQ0VVRDBzcUZzTEU3V1J0b0plMXM4bjFwWngrbkg5MDlmSXJoVXA4Q05I?=
 =?utf-8?B?bjRGNWk2eU1JbWd6UGErWHI0R1BvcjhXMzFkc3V5c0N3L2t0NUZvYjJvS2NI?=
 =?utf-8?B?MW5uZEZPdFBGVHVjbFdwMGZ3RDNpcXp4TEp6OTdEN2xySWhWcUhUbXh0SDhz?=
 =?utf-8?B?SHhMMXJVY0ErUVpMaHZwVWlDaytqVEJvZlg2eDVIQXpXSTZzRXlyMDNzQk0y?=
 =?utf-8?B?VFhTaXpJalU3NXh5ZmUrdzRqYkM0OUg0N2dVa0hLUERkSmozUzJUY2ltWVFE?=
 =?utf-8?B?Q0FaUHIzTUVOZ2U5eVR6T0F1UXdrR29QRGYxdXV6L2pSbi94Y2hoSUozdTBL?=
 =?utf-8?B?QlFGNjhPdktibDdBTGJUMnlmRU9pUEJaNHNwVldzSERGWjV4VmRuMlYzekdM?=
 =?utf-8?B?SWkyc1k1d3Z5T3ZzTUhnUU9lYkw4bXd5alg1RE1jSkhYQ09hNjJVVFNuMHJB?=
 =?utf-8?B?YlRVQkZBZVB6WUhOYklWd2orZDU4WTZrTUZENk1xWksrdGdmS0RPOWI2TG0y?=
 =?utf-8?B?ck1UZENYcHJ4U3dIcjBDVjZHQzZYUmFHN3gxMTBvL3I4NndwTUpnc2EzUXU4?=
 =?utf-8?B?c1lCbWF3TGpTYzMrb0EwSjFEMS9zN1J0VXA1UzYzUWo1cE5xYXFtRVk5bklZ?=
 =?utf-8?B?THo0aGkyNEFpUmR4blQzT09vcHpRdkRkK1RESnVSeEU2S1ZkSXFvV0tFSDl5?=
 =?utf-8?B?WU5GZlkzR09tNmZUdk1EM0RwZDgyeS8xUEFrdy9JamlTNFJjVzlDUnhyVjlm?=
 =?utf-8?Q?akrFa5yGA14EkxOKPV+bOT3pN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1feba4ab-e8dd-455f-757b-08da9c9f9d9c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 13:37:38.7168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ldm9cpE8gItDBV8i0cjHd4HNR/eaLxmKG/KDW4OsTvFkLMwJVZe+KW+d99KYL6O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7379
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2022 16:39, Simon Horman wrote:
> On Wed, Sep 21, 2022 at 06:34:48AM -0700, Jakub Kicinski wrote:
>> On Tue, 20 Sep 2022 16:14:16 +0100 Simon Horman wrote:
>>> this short series adds the max_vf_queue generic devlink device parameter,
>>> the intention of this is to allow configuration of the number of queues
>>> associated with VFs, and facilitates having VFs with different queue
>>> counts.
>>>
>>> The series also adds support for multi-queue VFs to the nfp driver
>>> and support for the max_vf_queue feature described above.
>> I think a similar API was discussed in the past by... Broadcom?
>> IIRC they wanted more flexibility, i.e. being able to set the
>> guaranteed and max allowed queue count.
>>
>> Overall this seems like a typical resource division problem so 
>> we should try to use the devlink resource API or similar. More 
>> complex policies like guaranteed+max are going to be a pain over
>> params.
>>
>>
>> I wanted to ask a more general question, however. I see that you
>> haven't CCed even the major (for some def.) vendors' maintainers.
> Sorry about that. I should have considered doing so in the first place.
>
>> Would it be helpful for participation if we had a separate mailing 
>> list for discussing driver uAPI introduction which would hopefully 
>> be lower traffic? Or perhaps we can require a subject tag ([PATCH
>> net-next uapi] ?) so that people can set up email filters?
>>
>> The cost is obviously yet another process thing to remember, and 
>> while this is nothing that lore+lei can't already do based on file 
>> path filters - I doubt y'all care enough to set that up for
>> yourselves... :)

It's not that simple though, this series for example doesn't touch any
uapi files directly.

> Not defending myself here. And not sure if this is helpful.
> But the issue for me at the time was not being clear on how to
> reach the right audience.

It's helpful if the right audience is subscribed to such list.
