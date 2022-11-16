Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608A262C6D3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbiKPRuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238910AbiKPRt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 12:49:59 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2098.outbound.protection.outlook.com [40.107.212.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEC660E9E;
        Wed, 16 Nov 2022 09:49:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfvlupamU2Rx6w/iydZtxGugHLZbi9Vd+/DXYvewhTqYMPZyeu9VY+xbf9ELBtVizoAnwNYQSbF9r3DtMgxVwJTgCGtmaMwJhsUfordNfbPMGvyHb9Z4msYRJbpg89f+XoXB0ZE2Dioajx1EVQjI/XZcFBGkzedxylP7JP0CnWi6R7BeZgYbRbEVWUs1XDZdztKWRKpbdU7DHpm4Oro9dMK5zFIiEUjbgoolAtSLK8Z+Fij5EbbBckxAFxjtDy5qbsc6y3Am8BMeFxLm0bSSNffGlidiOnFuMVvQUTztnNmCjV1uiYbGtsNJ1WGd6TBUq+fbXIK+RSHnnFqsYmQVeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbWfYMceu15BKWlDqM63CTvXdtZVKHF8yk60E2SsBr0=;
 b=TyrXp/SvoKcHb6aonjFz4KAaG+WOUhxNiD/gYyaU/HJQybLR1Ui3GuY89ObYUIssUyGmgSNLi8Zrq9AmjX7y+bD38mZEh8ScQOqTydV7P8loTf9H13ue8aedZLAQxt82eEm7FStI689OEl9lfeEipt9F2QU8XjlYiWozvjdglWgnFYhqTS+NY2V7ptbQLMD1KCUlwbRBL/DCUDHLa6PypwBfs4q+YbA7IeVMoUV9kQN1d8WzhKPmsWvrVs9sMZHlZ0bhfgru9XYBWECISCdUsv2bgbtKYdFSrTTtnEzbLePfuG8aQymUB97gp+hLSz5FaqxL5nsYzramLE5TgXUEhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbWfYMceu15BKWlDqM63CTvXdtZVKHF8yk60E2SsBr0=;
 b=eRZwai0ZFDVfN54Y24Kfw7Kdvs/5ifNJ42lbY/M3WyHfxm0h80WJng2MsFnXdvtiYiKIPMu2Ngilw6mC7zS2CpcOK0ad2YqX8DiN7F5Sc9Xtz+41WwQY7n+YKVGFY2R0PPHeGmiVddsRVeSV9+8r1/+FnEtcvZsC0ng6VUqIVZJvuJ7aEMfyV2MarcVUb9TNPTotofXMSLHQsp/3NyQ/5aMnVmH4gj73CErw2Fqvt0gDIDnmifooJwVgmnWpY3QKSywghU1kIaeoG2Kks5sXL651f1F6ZzL2jvWJv7FWz+CnGpQhfbxscEALzb7lfSwUrAficpL2r7Ns89hZGSb33Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from BL0PR01MB4131.prod.exchangelabs.com (2603:10b6:208:42::20) by
 SN6PR01MB5248.prod.exchangelabs.com (2603:10b6:805:d1::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Wed, 16 Nov 2022 17:49:54 +0000
Received: from BL0PR01MB4131.prod.exchangelabs.com
 ([fe80::619b:37fc:f005:109b]) by BL0PR01MB4131.prod.exchangelabs.com
 ([fe80::619b:37fc:f005:109b%4]) with mapi id 15.20.5813.019; Wed, 16 Nov 2022
 17:49:54 +0000
Message-ID: <2c60c692-58d7-d06d-826e-ea49bb1eca13@cornelisnetworks.com>
Date:   Wed, 16 Nov 2022 11:49:21 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/7] RDMA/hfi1: don't pass bogus GFP_ flags to
 dma_alloc_coherent
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20221113163535.884299-1-hch@lst.de>
 <20221113163535.884299-3-hch@lst.de>
 <c7c6eb30-4b54-01f7-9651-07deac3662bf@cornelisnetworks.com>
 <be8ca3f9-b7f7-5402-0cfc-47b9985e007b@arm.com>
 <20221116154507.GB18491@lst.de>
From:   Dean Luick <dean.luick@cornelisnetworks.com>
In-Reply-To: <20221116154507.GB18491@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH0PR04CA0093.namprd04.prod.outlook.com
 (2603:10b6:610:75::8) To BL0PR01MB4131.prod.exchangelabs.com
 (2603:10b6:208:42::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR01MB4131:EE_|SN6PR01MB5248:EE_
X-MS-Office365-Filtering-Correlation-Id: 33e3400e-ea22-452b-cd07-08dac7faf7a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/FqSD1vxtghMTJgL9Y26aVrAiTDE36ZoX6d1B2zNGUoAOGu58wH9zyQYgvxf+4ZLNAdB3YRmeGPlQ0hQq6moj4F4YWCXFAY3q0iDlvX7Fibty3zLqW699s68aLIh/g176hjwfEzd/XD8gbnfXYKe9eNbg11Yue56vOkf8DWFrVPxTEncJPrdVRec9CUBkA16W9pkGp08muO+IUl/PFKEpSK1ymOORXNiW2yszwvFoFyVsOyJBscZ9wlWn6lJCuy/fuHAe/h5bI1S6XGX2vFEx59pJ4N7A++DQn2LSsQvxNtQDArWQk0oELSrfEMuYrcLLAh972emzHZuiXGdLchv+uv+kz1MjWgsa2kMRq6C9O4ud1nukO9pk9rriX8BxsJ+e3CF8xK1Gx+5htEOM67qz1c2QcMzv56MYd6y9nGr96TC80QI28aKreo0wBQmVQvCaXhTChRsknW/BkrnUPyKmK0tGjVYvtOfKPp9g2lrMEQNIp5slJcbAmy9YXZwiSOh/lCD2spAVUUjruIGWkZHa9+80DSdrW8ifMQ0MyXyQmJ76gz8PigoRv6WxmOWIZ10uwq2IclQ5T27/aPlRRqqQbMY62ywiSzE5OuKA50qXZvwcCvqHLXyBqsFn38xmVQlD7NGzUkf+4GWmHIhnGrEs86/1BtDCU5p+W2Dc781bVIxm9/lRn5veg9qcZsVR5k2OBhV4QUY/g/Qa4nhYnvHt3cdDsG1shKtMyBQaEUm0l/yfXEgBXH/3nvQ70w5yQK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR01MB4131.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(39840400004)(136003)(396003)(451199015)(2906002)(31686004)(66556008)(8676002)(66946007)(66476007)(2616005)(41300700001)(36756003)(31696002)(86362001)(316002)(38100700002)(6506007)(4326008)(83380400001)(110136005)(186003)(6512007)(5660300002)(8936002)(44832011)(54906003)(6486002)(478600001)(53546011)(6666004)(7416002)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmptTU5HZnFNVWVtQ3VDd2JiZHFVajRQTGJrN3RnSDE5Vi9zNEE5Vmc1U1lM?=
 =?utf-8?B?anBsdFVEd2N0LzluYVlqSWVCVTRuMlEyQkNaaUhzSmI0ZWRtQkV1YnZObStz?=
 =?utf-8?B?ZU5udFN6TnlqV3Z3cUJpRDBBVzlyODh4MFpTTlo4eUp6UnI2eDBzT005Tmp6?=
 =?utf-8?B?eC9HUWJMQnJuTG1MTUZCaTNxenI3eTVVWWZ6Rjl6L25mUTY0NU0xb01vdTho?=
 =?utf-8?B?YXZKK0gyUVM5RG5MdlZYc0dCSE5lQUtxVXV6YW5ZdzlGUTJFelFrZXNZcGlh?=
 =?utf-8?B?ajlGK0wrc1FtZmhjSTJpMG4xZmNkWVhlYXBjbDJ6Sk9DVEo2SmVKUUk3clZ1?=
 =?utf-8?B?SmJWTlY0TFRNZklEalFuTXBhbUJ2Yndzb1NnOVA0a2dWcDNuaXUwbkFUTlZ6?=
 =?utf-8?B?MkZlV3ZwK2dpaXRaa08wWEllTnRhRFN5N0dDcmdZdit0VkRQcVFFQzFVRTd5?=
 =?utf-8?B?OUFDSzdxTjgxWmJiaVZzeXhIM2w3SlBBbTVnTERrc0N5YW1TaTRFOTljanc3?=
 =?utf-8?B?MHdBbmJaeDVnMEt1a01hdXBpOE9OQ0N5ZEl1QzI0dGI1K3ZlU0Y3WHhiekxs?=
 =?utf-8?B?RjE3aDk5TldyQkQvVmFnamdtMGEzSTd2aHR5bDhMUDUrZ0F3azMyRlR0Zm8y?=
 =?utf-8?B?STNraHVUbkVsbXJlemxkUk1MQ3R3NEtDZ1BBMDU2Qm9XQkE5SlBXbGQ1aURP?=
 =?utf-8?B?TlBmZnRCWG9UMm5BajY4UUFscWhFOGFVWDB2OVpvWE1UNlBrVVRmMzJPMC96?=
 =?utf-8?B?dUFJcnY5ZUdUVC9nOUFMSGVpSHJySVFuRlZ1eGhuUGFhZm9BY054UnpxdUlz?=
 =?utf-8?B?VndTM2ZaSWhQYTd1NkhJc2E0amZuZ1JIelQvYXdPdE5uWEt1UWthdWRzNGNw?=
 =?utf-8?B?Mm52U3VrVnhWR1g1cVlqb3N0Y1l0TmF1SFovY2dVd3hXTldwaUxNQ0pWbVB4?=
 =?utf-8?B?bWQ4NWM3ZXJpZzlJZElOTThJcS94VFJudDN3SXR1ZjlhQWlWUHBmUVVnUWVr?=
 =?utf-8?B?UFhJNG5VVzRpM0JKemZLTE1KTWxidWlpV0RKQ1NGUGd5NyszWWpaN3ZQMjNs?=
 =?utf-8?B?ZGZ5ak9Ua1dCUzV5RnJiSzdoZVdpT1VlNW1kc2JXMDNIaVBEVzN3U3djQ3c1?=
 =?utf-8?B?bC9WTytHQU9WUGtVRmYydDlsVnZZdFZ3eXdCQjdyOUNPdTZ1MzlKeitpRWJL?=
 =?utf-8?B?TndRL09VSVZtZTFrelJOUytFZDJHTzEzU0lTalNma1BOQXRrZnJpZTNuNTF0?=
 =?utf-8?B?amRWQ1ZBMGRrVnJKTU94U25qZm5qdXJMSkFFUVM1RUhVVEJvWFduQU1rYlU2?=
 =?utf-8?B?YVFkbUpJT3FOLzVqTlpTbEhDM1U5Z3FpcHE1TTlLNjhQMkgrQ3VYbDh2QVRQ?=
 =?utf-8?B?bDBiT0tKR1JFR3ZDNkpwU25tWjQxVnk2TXRIaVJvV1JLSTh3SkVFTWN3UVRC?=
 =?utf-8?B?aTRxdUVnQjVvY3F0c08xZEsrMkVVcUVpK01pMDRWVFBxMUdEaFFwbEpvdnJT?=
 =?utf-8?B?bWZDNzNtazdjcGFhbkh3UHkyMW9ETTJ4MzVDa0hXcmVVNEVkdHUwRDE1R2Jz?=
 =?utf-8?B?TmlsSjc5WTM3SXhhZnliY2hySTA0YllwTG1ZSVVrVkc1ZHdmZ1lJZWFSNjFy?=
 =?utf-8?B?dFRlOU52eHhJdFBoS2JwN05yV2hhR2NKQ0t2Q2lZUjF2czNidHQvZ3cvQ2xk?=
 =?utf-8?B?R21iQ1U5OUZ2K01iR2NLQjNzbm5uUG0rMVl4cE1Bc2M0QnM0cmcwYVBkQU9m?=
 =?utf-8?B?dEJlVlZ1VzUyRVVPblFselBQOXVMRmdtMHdXTTJRc3lESkVScVlhU0tmUG5T?=
 =?utf-8?B?WjFZb1VRbjJUNjhnSjdxK2pTNnIvbVkzNGFnak82am9hNkdaNGN5UTB4RlJM?=
 =?utf-8?B?V3FCZDkxZEtFQThVZk9qOGlsbmsrWjJwNUhVM2FFdzZJSnU2S2lBcHVZc0Jq?=
 =?utf-8?B?cVFWUklHU3BFUGRSV2txRE84YkIrcXV5K2w2NVBVNVROYWwrNUFxb0JIekds?=
 =?utf-8?B?Ump5TEJVZWVZWTZVbkZiSmFDOXNIY3pJYzl6SjVwZVNFUjV2TVFtT24vSFVy?=
 =?utf-8?B?aG5rOVdwcFVEWEd0VFdweWsxcDNpeTJiMW9xY2EvTHFPQWxwNlNyanAxSlgw?=
 =?utf-8?B?ZmNDbmRsZXBrSDNhV0JCTTM0NWY3RHZhZExRa0RIdmVKQS9wMFJxQjh2TDlj?=
 =?utf-8?B?N1E9PQ==?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e3400e-ea22-452b-cd07-08dac7faf7a8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR01MB4131.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 17:49:54.2757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNKbPQLs0VMtzLVXcwchdYHN5xj3r15rggON2IKSlyrJooKsTDLaG85RgX1lcqgzoCbfzjXUWzVR+RT80rdHhPwE3s7vz7UG4IVRAyJTBoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB5248
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/2022 9:45 AM, Christoph Hellwig wrote:
> On Wed, Nov 16, 2022 at 03:15:10PM +0000, Robin Murphy wrote:
>> Coherent DMA buffers are allocated by a kernel driver or subsystem for t=
he
>> use of a device managed by that driver or subsystem, and thus they
>> fundamentally belong to the kernel as proxy for the device. Any coherent
>> DMA buffer may be mapped to userspace with the dma_mmap_*() interfaces, =
but
>> they're never a "userspace allocation" in that sense.
>
> Exactly.  I could not find a place to map the buffers to userspace,
> so if it does that without using the proper interfaces we need to fix
> that as well.  Dean, can you point me to the mmap code?

See hfi1_file_mmap(), cases RCV_HDRQ and RCV_EGRBUF, for the two items you =
changed in hfi1.  Both directly use remap_pfn_range(), which is probably th=
e original approved call, but now is now buried deep within dma_mmap_*().  =
As you say - these should be updated.  That said, the eager buffer mapping =
will stitch together multiple eager buffers into a single user map/vma.  I =
don't see how to do that with the dma_mmap_*() interface.

-Dean
External recipient
