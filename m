Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C88539FF4
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 10:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349865AbiFAI6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 04:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345836AbiFAI6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 04:58:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD3E50044
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 01:58:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMaTRph8Wc0Kj1PKQggS/gE1av0mbRi4AZ9Pf70TNi8EhLzETsMwivP1nr1ncqbp4fAGHmpDAbRDzRJDVKDFAj4ey6Dszxj3btuKL2EVn5QZ5maT6ulqrbSACzN+PotwiM9E2r8blHh3QwJaL01lJnkpFCS3ETs5xFrBy+Z7lx8K7XH80Mco3L3rhlQMeZ2lXUH2lWQfwrg5DYPc6BzGriItleNKJham/LjDntT3EOgaY/pEjNMr1IEpjhelBlhhwj2nVyWHff1cR+ISh8f+DCvrFZ4gCrmeKN59V/mRAbLIvZtxYN4EUV+Cs1dSUPqIMS54TAzg0eWseiJPrSxqNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XkJY4X8Uxmxthmje4nFnDF0ZrBqCpDZ+2zAW6NzEQ4M=;
 b=SQYrZZ/3KEwIuiD7RL2UJ+LuT2UG9FSgElr3V8z+LwKWcPUJg+2OZt+YUHmS1ueOK4WXXLhbcgZprEUVLwaoDoy52e3AjdZWjevH+zxSvBP+dABqzad8Ku2xKwNdxeoQdyyOecIHbikAQDOdRV6uBhmZG4IXac8LlnHun+9TkXlVAhYyqF/D9bZ0LW586llvxlcKO393XNbid8DznjePCB3dUC4zMNAnEFrBBtbXLVTByd16P77nZ9W2vbfMfVZnUIDyDXj6L5hatgS8OO7oCWOHIhBi8ftrPNyJvukb4iX+tgAEETMT0WGylRS5qlhwXzjQ/b5ZkzQotVKvWD3LXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkJY4X8Uxmxthmje4nFnDF0ZrBqCpDZ+2zAW6NzEQ4M=;
 b=GT79c9sMrdMCh5nKUeQEAXUfs8mwzZo0PSWws3m8P9ZJfRLmQAz7ARZR6YdA5p5r19wgXq8kBeiidOjg5IWhD9RCo7j+opXnssMsSfoYpnxb4g5tuJU8g/JsDiGpD0minHucclbw2S4+ERtxqBYQagz9x1NPj6sYwF9iRSOLynZt0l0haYdaLYPYmdHPIRW90fWlVIVMdFYUWZR3G8WihM0ZTiAeCyu5qWHNwgkfr6iQbYEmkjzmzUPZh6Tz+fVPBCBYlRNAsXlTw5cBGToKmscApTWaOqRFlKc9Ku1bSldo01heLQXoQCPxEu8FvSjHMtEyRVsdNhdthtQJSWKRBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN7PR12MB2835.namprd12.prod.outlook.com (2603:10b6:408:30::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Wed, 1 Jun
 2022 08:58:32 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb%6]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 08:58:32 +0000
Message-ID: <b050eb9a-b627-4efb-8095-d3be52ca3264@nvidia.com>
Date:   Wed, 1 Jun 2022 11:58:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS
 sockets
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org
References: <20220530141438.2245089-1-maximmi@nvidia.com>
 <20220530111745.7679b8c4@kernel.org> <20220531121829.01d02463@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220531121829.01d02463@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0070.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::34) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 420c2a27-ddf8-45a1-0c93-08da43ace74e
X-MS-TrafficTypeDiagnostic: BN7PR12MB2835:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2835263CC2885C1B7686B0B8DCDF9@BN7PR12MB2835.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ltIMcUc2mlUffdS+0FfJFg4UkHVFkaAVbkMpD5qdkuQPQJQk2j9v6OzajrzbsCnYk22v65jNb6LfHnQsHSIvYvyEnJzehMOTKX+fpF8aPyTF0bRZCxuubIaqrJthSJaHnr8cH+VuwADHqkhiiyo3yg0vP0VKL/jsX4el4EeeUC24zPQJykZYyAdyRF06K4E44AmbCc+q+RWEKwk0430FXiluwdLmRH/RWgTYmL/wjq+ymfKBTz1yJyemapsLUBtLeHFstiM1/LoyV9NWZzDeWJuK120iimbm7Ccs7YJbW6//+eTdhxBYqfrxaYIBv5P3yQTuMvrzM8rHgu25xT2BSfasT7cGM73CPFTlmF52mqLJgGkJDaeU2g166rq7Z1yKEMYXTXuKi2IksICfWjdXisW7yOO2+2mYyCSwvy3y8gNAD8QXLl38i9nYWxUT14lHmpkVWz5ZpHW3sTMif8qLer6FKZoub70p3mXcMHVHzUN8QpNBEv/mJO5S/6LniA7BFpDDrLu6hOhbYdBUDok7Qm2tS5C+j7AvSNwa7d/uZDEDnLRb9yTxOyDw2tUNh98oDfpOSNQj3/W5zMaFZYwnUFv2nNB/kV71SgNVDVIE0Lv3jx1MLTrYapO9VJK03UF9GRUh/9+GqZcyClm2LO6f/Fbk0UZZ8wdvPJadHDCLYq+XlHqblb1ZAprAxJQNwNB01JqWK4LeYWUVZqkEWGHKACBruuVKlwxxFTzysNeNrJIgMQCBrPhkZjrjMBS0fGgC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6916009)(316002)(2906002)(5660300002)(31686004)(31696002)(83380400001)(54906003)(66556008)(66946007)(66476007)(8676002)(2616005)(38100700002)(8936002)(186003)(4326008)(508600001)(6666004)(36756003)(6486002)(6506007)(26005)(6512007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTNLM2tsZ0haYmIrU1dnaVpwbGFXeU1kNzBmYkk0dlRZR1dmZW1YeUdVelYr?=
 =?utf-8?B?QWY3b2NMRno1Z2Z3MkdLWVhEQmxYMFQ3MWJGQ3NGdjVOVGtRVzdqVllMcVN1?=
 =?utf-8?B?NFpXaWJqc2F3b3p2VTluV01XbS9OeUYzeWY5T1cyMWZLanVTWWxoZXl1U1No?=
 =?utf-8?B?SzdBSllJV0JEajFRdzI5Z1FFL25JbStXQ0sxKy9ZOG0xUmh5R2QrYUwybFZp?=
 =?utf-8?B?L0dySUU1ZHU4ZWQ1M0tHUEZreXFFZXEyYTBOUU9SQVBkdWdRV3BxU1phSno0?=
 =?utf-8?B?eGVKMzlPTDFXblVTdnY5bFpNR0xxc1BoTGZYUWpzUWhEeWFJaW9tRUFsa3o5?=
 =?utf-8?B?UmJnVjVmTk9xVXVQeG1pa0xKMzUrODd5R1FSYjBxRDB0T1NKSFJIVVJOV3FY?=
 =?utf-8?B?Wm1yelpxKzJHbDBEQ3loVU1hNmszUFNCNFJYWDg5cEl3WUR1RzdqRE05Qmpr?=
 =?utf-8?B?YkJ2RGtwZ3hVYk5KcTZEQjQ3NnpEUmJBc3pLK05KaFVXczBhSUp3WXVnWk9J?=
 =?utf-8?B?dzlKWDJxdjIwQkRiVUtmclNsK2cwWVk0Z3RjK3drUVJzK2xWMUQ5MStqMGxI?=
 =?utf-8?B?MWJDcTFJUm9wNnFwcWh1T085MnhoTWFyZ3NGRjg1WFJINzlJVmZBUXg1dklU?=
 =?utf-8?B?M0VKMDhUL0VCOUpMSkR0Y1QrREV1Y1MvU2VPWUR1azB4bHhLN2VyTjhQT0JI?=
 =?utf-8?B?eVhwTzdGTGdPUHNDaEhPVTlib3kwNVlGOGtGU3crenE0RGJGV3h4VjNFRWd4?=
 =?utf-8?B?RFI4Q1Nadjd4QXBZUzNTUjloQTZGallzZzlMQkIyZno1RGVlK0pKclk2Q3FM?=
 =?utf-8?B?dWRqNW9JTDlTOHQ2ZmNYOHlLS2tQbWUvZnpyNW5BeWdsc3VLQVU4eHE3Qjds?=
 =?utf-8?B?TEg5T3JTTkFydXNiSFdBTGdRSkUwd0JzMWJYTXdmZTJQclBmb0tkR0xYcW5h?=
 =?utf-8?B?UGVDSTVCeGZGWlNGN3JBWmdDdVowUlN1TTNUb20weDlmOUc2eFo2TkZUcXJS?=
 =?utf-8?B?cFNPaCtWVUN0eko3dWtEQUNaOERiUUNIckptT09na1hDNXF6TkZZQzZTbG5M?=
 =?utf-8?B?TzFDNm9TbnBsVDFrMG8yUnZHNVdQNStmVXBOZVJjNzZTZzVub0oyR2lNbHhM?=
 =?utf-8?B?c0dJTDliVnJ3ZEhyam1ST1B3eExicWpBaDZDYkFmdzRLMXdRcUJsMExrcDRo?=
 =?utf-8?B?QnQxODNSUmdWSlFvQUl0akxzWWk4ZkxUUVBMcXcvNGdHaWRuV2RtQkROR3hp?=
 =?utf-8?B?eWpPdVRYTnZqbDJrUHZZZzU5Ni9GaVpJT0c4ZS83bGlSVEhwYU52UEMxekdr?=
 =?utf-8?B?YTl0ZWJibXpVK1haaE01aWJnaW9hTjBrN3orazZHQW9RTDFEZ200anlEZ2x1?=
 =?utf-8?B?MHhQQ0dGNjRYTEIzaklXb3ZqMWtKZnJRTmozSnlibXdXNWY2TUhxTitEV1pB?=
 =?utf-8?B?NXhXeTFXUGt1a2Q5ZlNmY1JmYTM2TjcrZ05iT3BjeVRvYURMRFVYcFZJL3BU?=
 =?utf-8?B?emtlbTRJbzNadkFPZGtKRWZuWE1nMFhRVGxSMlVzd0V2QzFzWk5VN3JLbnI4?=
 =?utf-8?B?cnE5NVBNbUhuUllzajBRVHdBUVB6Mm5hL21tcjVFV0pOR0xUSkVRQjlsNTlS?=
 =?utf-8?B?S0VLb0VXQVAvNFBraFQrV0QvNWpjZEIwYUZ5YS8wY0JlNDk3Z2x2ZFVZUE9P?=
 =?utf-8?B?MS9xV3JxcVFvQTRRMUI2Zk5idmtPYnBQeDVocnJDUXYvUTJpQTc3a3NjOGNt?=
 =?utf-8?B?cXVRa25VNXpkMXdUMVlXNGlOSS8vK0VlK014aTZQcnlaQVZLSDdmM2d3d3VI?=
 =?utf-8?B?eUhKdk9GMEVMVVpPQVZZUEVwY0ZwWnBqUlhyYmdkTVFhVDFSSU5KSmZKUjBZ?=
 =?utf-8?B?YzBnNnZKS0JKajh3QjY5d0dqK24xazFQMG1EaGtPMktudlFaeUVtVTJ0b005?=
 =?utf-8?B?elIvZENuZjc3MGRnRmxzTkdIK3VVb2V4aWQyT09nSDA4bDNTUWREOWlQYk5S?=
 =?utf-8?B?RVBKRGJTT0pSaURjbkFhSXlEdVU1aDdaOHdEVHV4WkMxb1J2MFB4K3c2L1oz?=
 =?utf-8?B?ZHBKekhtMVZrWi81Wnk3QUVaNUVJYWs5UGFMZVQ4YUdPeGtoZlFKZXlXMkRv?=
 =?utf-8?B?ZnhmWHNBRnJTWkRyT3l4Tndjc1VyR3BFblBhV3RLYlpmei9xWG1wZ1BoTlMx?=
 =?utf-8?B?MEg2RlZUSVV5d0Q5Y2ZOMXFBUkNVNzI0M2d5VGFLREYzZWRMVnYyRU90d0x3?=
 =?utf-8?B?dE5MOFBGNjNtUWZkb0RvSnozTytoeUNrcHVXamlKNU04VWE4NXRPa0dEeW9m?=
 =?utf-8?B?bU5yK3FDb2I2cFo2ZGN4TlNsZFRPV1BnNnUxRWIvMEpxR0hERUhmZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420c2a27-ddf8-45a1-0c93-08da43ace74e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 08:58:32.3246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8c48jgnrtccIGLVPnBKJjS2EQh7yDPKrmL1684WvCsY7jl2xVRWIJa/y+TAA/tmlLlwaVCoBW+wLiZr/njiBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2835
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-31 22:18, Jakub Kicinski wrote:
> On Mon, 30 May 2022 11:17:45 -0700 Jakub Kicinski wrote:
>> Also please send a patch to Documentation/, I forgot about that.
> 
> Actually let me take care of that on my own, I have some optimizations
> to add, saves me a rebase ;)
> 
> Does this sound good?
> 
> 
> Optional optimizations
> ----------------------
> 
> There are certain condition-specific optimizations the TLS ULP can make,
> if requested. Those optimizations are either not universally beneficial
> or may impact correctness, hence they require an opt-in.
> All options are set per-socket using setsockopt(), and their
> state can be checked using getsockopt() and via socket diag (``ss``).
> 
> TLS_INFO_ZC_SENDFILE
> ~~~~~~~~~~~~~~~~~~~~
> 
> For device offload only. Allow sendfile() data to be transmitted directly
> to the NIC without making an in-kernel copy. This allows true zero-copy
> behavior when device offload is enabled.

I suggest mentioning the purpose of this optimization: a huge 
performance boost of up to 2.4 times compared to non-zerocopy device 
offload. See the performance numbers from my commit message:

 > Performance numbers in a single-core test with 24 HTTPS streams on
 > nginx, under 100% CPU load:
 >
 > * non-zerocopy: 33.6 Gbit/s
 > * zerocopy: 79.92 Gbit/s
 >
 > CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz

The rest of the text looks good to me and accurately describes the 
limitations, intended use case and possible consequences. Thanks for 
taking care of the documentation!

> The application must make sure that the data is not modified between being
> submitted and transmission completing. In other words this is mostly
> applicable if the data sent on a socket via sendfile() is read-only.
> 
> Modifying the data may result in different versions of the data being used
> for the original TCP transmission and TCP retransmissions. To the receiver
> this will look like TLS records had been tampered with and will result
> in record authentication failures.

