Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02926BCECB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCPL5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjCPL5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:57:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE42ABDD16
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:57:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5VWe6C537Vy1CbBx4FIPgGRqpe1Q0Sr5mEVM6ZcDO089YP4jU9wB4Vd/c7p3AHOFN62ZrIlwSEo9wTXzfdYWR+qvQ1Rh8btVSA88EVo6DLDS4fZFzm1hwzO6a5hc2GX3CL4SGP0LF8Z9OaMQ8X7xij/kmaNHG0bL3Sa+wdulySXer8XzopPdW8SUfSHKMIpfaetAHpDk7g/Ea80ll5imxzA+BjOOHdf43aPzglQ/+z9kzWf5jdvUJkcOJg+I/rcIG19pJYopNYTQ6TqDw52yGgDCyhjrIyJ85oS+v+BIUJSI3ZxMR4KPbHIu/9B3dFvd477CqTyyrlqum8IJKCTGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmERWaSwOvzzUpVfqujqVBgvtWkaUi2kbHDUfRFE+pY=;
 b=B884udBAbCB5fw/uUWeC0YIGYa/Y8GtL83CZ2cJmZ9XB4PcaIAjTtPq0RzH3aU/7vCq7TKAT8TMPF/PBL+ZK/bWmdZzUHwPt/FSqv2ZrFZFJ5BTtqsgfplN4l7fXmnCSffJioLkr8J3kPSEFhGp77NjKZfE2bDLBsZiupfOVVxUWmgt8DZbhmUVGOAxjsXTGkMzvP7F/KQqu1nOBRO1gLqzmdBqQtgSmH1maJ7VgXvf476E2+227EOfRJ4x4z4jFQ0mMmPVTFoplQKEvv7thxgc149Wsr4opQ821vpSu97Ph2MkJvKpzpbZKDrwT6ZPKQsXDHnb2iUiR9DbPiKe4eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmERWaSwOvzzUpVfqujqVBgvtWkaUi2kbHDUfRFE+pY=;
 b=igjimBfIEl6qF9H6ZcDlIKJB8M5CX8jnbERuOV31CqhDSyZIx5/nbZ0pf5pXL5hD07vxm/nkL6d5Dwgq/YzeKYo7tKheAD75FhqhRIqtOTCLN6TGHpJ3mlb7wWT1c3kAme6CVhcJDjrTpmALu2UyCfKqspJVv7/19dpethvrmNaDDJLJxEM6JUYEOIFJzBrppxQWbzvqHZxy48fo3yqXu8Bu8pdndGBKYT2tfaLw7YcH8Uon05SC0pWNodUeX6R0BX0hFCQELgA/8PMeO28lyrRrlo5OzOl9mTvVRdGDP3MhaJdoBUF7qf5Wy7QJNtpm5dPYa7xXQ3ls1ZCPnvdGOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 CH0PR12MB5235.namprd12.prod.outlook.com (2603:10b6:610:d2::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.31; Thu, 16 Mar 2023 11:57:37 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c707:d96c:a864:28a2]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c707:d96c:a864:28a2%5]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 11:57:37 +0000
Message-ID: <30cb3990-80ce-ca07-6d73-cdc00d0ad7b8@nvidia.com>
Date:   Thu, 16 Mar 2023 13:57:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
To:     Shay Agroskin <shayagr@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-2-shayagr@amazon.com>
 <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
 <20230309225326.2976d514@kernel.org>
 <d438ef12-86f8-7415-4690-3e378ac1048f@nvidia.com>
 <20230313120942.75599b8e@kernel.org>
 <pj41zlbkkv2v6z.fsf@u570694869fb251.ant.amazon.com>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <pj41zlbkkv2v6z.fsf@u570694869fb251.ant.amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|CH0PR12MB5235:EE_
X-MS-Office365-Filtering-Correlation-Id: 979c16ce-3993-4a5c-6d47-08db2615a287
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tHUGysYQwPG82w7A1yCBl/XC684zO+YPfG0/1e4x/Dw6eiGvAlXp7CsRrB4vOsBQzeGq+GQFwDdo4B7Lrg8lP1HbpVSkYG5LNdoglUnrX4udsi9xIQrFk8paDDfVqw6+sQJ0G2jdWSIprKDB6n1ESO3SbGrKVDRSGAzlD0AGDll1DWf3rToz9CvOiu9Y8dQKylPvtOo86VQwjrKhrlDBn0vmMj8xdwrg5DylbT7qD+JHW8V+hmRBWYZE4eEeyrnGRoGpELGoleFWUEz00XQS5VsZlGLKbfv46E1uPHCQI4TZMWOvaI4MhFW7sPUQ7V8doQXFZZd67w1KpC9HC3f33dPqlejfE13tHTUlw0L/4Baxp94O3RtMd3Y+SXNcgaGsOURge77atDg1efNdXApD44Fgx70zGn0mAka6+IaSW5X+hedHJin9H9nff3ATfqGnOQfjCpfkZz3MYHClnJPJNhzaRCyuFQFJ17fwf5GhsK4nbkA4bJeeOtj4Dm0hPa5J4OO/d8cfvFyQXHx4uvcnnSzXmnCU/NKuPOz6cFMtNxgrv1DrltOg55z0UA6a8vPlHaglf8e2ssN7xV1djtuQtan90kTfrAC0Yosr4ry7CwTjCEMFpOASbB7BqVD/nHz03iFsKJ0HGvW/hL0jYom1MT5/SEQINrk3Y8z1XkfVYrt7Jh836VZotKHMg9lokWnRtVl6EKClcnaYhOnY1XR0SFAlFq1/90HrOXebZaGPFwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199018)(31686004)(41300700001)(7416002)(5660300002)(8936002)(2906002)(38100700002)(36756003)(86362001)(31696002)(66476007)(8676002)(66946007)(6486002)(6666004)(478600001)(66556008)(4326008)(83380400001)(54906003)(110136005)(316002)(186003)(53546011)(6512007)(6506007)(26005)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekx2U1JkZ242TTNiNnhHMmhYK3FjTm10R1NnM0ZGUEdXRHorOGxkZU1mSVkr?=
 =?utf-8?B?OTVJZHQySStNMmNNSWJpL3MzbE9jSGV5Z1ZodTI1aTBTL0JhZ1FRTE9GRkx4?=
 =?utf-8?B?ZzBGcTVpS0VhYmo3UVRhMTBGQk03a1p3YlFoSHdjMWRXNjRheS93REQ5UkY3?=
 =?utf-8?B?V1NHSXNQUXdKNWlGOUI2bEEvQ2lRNERFQVo3MjRMSHZXMUM2OTVaeU52NlVa?=
 =?utf-8?B?bDhFNkVCczlVeXlYQVlNbUFqUE56VVlFS0JTWVgybnlxeE0rWmtaUHMxdmMr?=
 =?utf-8?B?R0dsRk9ReE41VjRZbnU3MDV6aU5VanB4eHQ0S1ExU1RSc0JOdW1VSzYvZkpR?=
 =?utf-8?B?UlU0SGJOOHdtazhWUVMxUzJwdU4zY1ZJeDEwSlUrTEdaTkRLVnlFUXdlS1FQ?=
 =?utf-8?B?em1yWURRUTZITTVEY1hTOWcxeXpLbGhGVVBSZ1k1RG1uK25JRkllQUN1cjZK?=
 =?utf-8?B?alJDcEE1b2d3SkkrN1I1MlNscmFOVnpEMHJwcW1SZmM1TzlXREdQZjlzb092?=
 =?utf-8?B?eWhlNGJER254a0NvL2lmbkszd0FsTHlENVFOSTYyV25pZ096VTloUTVNU0FD?=
 =?utf-8?B?b0VwaldMMWt4SmRiVERiUHdKVGF1UFAzazJXQjB4SDBVNXNoYndPVTdCOWho?=
 =?utf-8?B?N0wyUkJxdUZLQllEbWtFWUFxTXBNbFZ3c3E1dXh6RzFUOVRCUThwcVlDSnp2?=
 =?utf-8?B?c1JwV3kzUkFSanY1dno4ZnFZSlR0UVF5SmxZckpBQkQ4MW9xM0xwRW5qRzJo?=
 =?utf-8?B?M0d3QU9NdFdiSHpQY2VYNU40YnpQNHBMK1dHblZqTEdDV0RhYmVYMFd4YnIw?=
 =?utf-8?B?RW1FWmQzd0JaN1g4N2ZDdW1IaHpjNXBBeVJwM3dPRlJ0WjI4V0I5SStMdjdK?=
 =?utf-8?B?OWNja0JvckVpbEFhbnY3RzhoOGw4Y3dsMEgvMXBRblJqMHYyQU92YTczaUlp?=
 =?utf-8?B?T3JaaEszbXI5Umw2N3BOeHBCK0NxbzZIeW1SazRZeHJpSWxGcFVINU8xckJx?=
 =?utf-8?B?UmxuM00wOWswU2NveUg5RWhLelFEbENwUnJKUVNmRUpiWDZtOFE3MDV5RWJP?=
 =?utf-8?B?cHdrNEJiOURpaTJqMTF0M0hHdGtXajZpMEhDRzNWOFN4RmhteUVZTVVPZk9z?=
 =?utf-8?B?enZIUEUyUHZoSndyQ1gwbVFuNFJKSk9qZDFaamdyeldUWENTOVMwQVhoZzBS?=
 =?utf-8?B?QSt6R3EvM1dseE1TbU1kaE5pbUltTmJoeXhKTnIxbStLbHRlRU5mek02cHNu?=
 =?utf-8?B?ak10L2d0QlN6YXFNdmUwSG9KUXdnL1lQU0Q1ZHNSb2FqcE04dUlVaWh5QU55?=
 =?utf-8?B?c2xtZGtvdHVreitER2JTUFljNTdybVJpa3RyMUU0MDZEUUluMGw0OFVpdHcv?=
 =?utf-8?B?NVE2RmhvN3dzdVUwY0ZBVUR0TjFXbVBPVWZGbkx1M1FCS0lzWnN1ZkNWaVVj?=
 =?utf-8?B?ZWlMTFVYazNYR1dyNVBHcWdZQnlPaFVydmNQYzBod1FmNkIyenlFYm10d2dD?=
 =?utf-8?B?Ynk0R2czMktCRHRSSGtySzV1RjRhQ1ZKRThlMDFQS1kxSExoVUFxb1BNQ3hM?=
 =?utf-8?B?MkxYYkJ1RDZtNC9kUFI2Nnp5cEQwUnU2RkFCeTV2RlZTcVlSb1l1enc0THJj?=
 =?utf-8?B?VHdLcDFHVWM0NVFpcVIrZlFiVVpURFlodVpEUDJDV1ppU09TNVZMRDFvd3Nr?=
 =?utf-8?B?azQ0TG9ubGVic1Z3cHdQM3RzV2R5UTNLVkZlQzZMUUVoNERYWmtHencrZ3pI?=
 =?utf-8?B?VTJGRENVNytiYmx2ZHNCZzNqaTUvZHNlQUxEbUt1RXVUK2NhMVYxKzgwenBs?=
 =?utf-8?B?S3JTQlkxVmZQWlFPaVlSM2h4T0s4Q2F4OUl4OGdoQzVUY21vN3NUaDRHdHJk?=
 =?utf-8?B?SmVjTXQ1RnRaWVZmVVZrNTAzdHdzTUxBVDhCWHVzdksrVXRpVnlKUElIZVNT?=
 =?utf-8?B?cVpyRll0cjhIakRsYjd6bUNobElwY1ZLRFJKR1BSZmFncWJCUHBaWFR3cFMv?=
 =?utf-8?B?N2I2OFhKUzR6cWhWdmNFR29oQzlwQlV0SFhlbmZuTEp6TDUrYWZVOFNoalBw?=
 =?utf-8?B?dm5taFplN2QzanRKZmVxTXdnWVdNVE1CQ2RrQ0w0YjhJd2Y2WGdKZ285VnVk?=
 =?utf-8?Q?hUTmQ/OAnjeXUFbpQGImVeaqX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979c16ce-3993-4a5c-6d47-08db2615a287
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 11:57:36.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ViUgfUOpqPlDju3swR2JbRzwY0qXEkpu7te8vWVQ+l3BuKX18K7BYpFpupwNWVtJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5235
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 17:38, Shay Agroskin wrote:
> 
> Jakub Kicinski <kuba@kernel.org> writes:
> 
>> CAUTION: This email originated from outside of the organization. Do
>> not click links or open attachments unless you can confirm the sender
>> and know the content is safe.
>>
>>
>>
>> On Sun, 12 Mar 2023 14:41:39 +0200 Gal Pressman wrote:
>>> On 10/03/2023 8:53, Jakub Kicinski wrote:
>>> > On Thu, 9 Mar 2023 19:15:43 +0200 Gal Pressman wrote:
>>> >> I know Jakub prefers the new parameter, but the description >> of
>>> this
>>> >> still sounds extremely similar to TX copybreak to me..
>>> >> TX copybreak was traditionally used to copy packets to >>
>>> preallocated DMA
>>> >> buffers, but this could be implemented as copying the packet >> to
>>> the
>>> >> (preallocated) WQE's inline part. That usually means DMA >>
>>> memory, but
>>> >> could also be device memory in this ENA LLQ case.
>>> >>
>>> >> Are we drawing a line that TX copybreak is the threshold for >>
>>> DMA memory
>>> >> and tx_push_buf_len is the threshold for device memory?
>>> >
>>> > Pretty much, yes. Not an amazing distinction but since TX >
>>> copybreak can
>>> > already mean two different things (inline or DMA buf) I'd err > on
>>> > the side of not overloading it with another one.
>>>
>>> Can we document that please?
>>
>> Shay, could you add a paragraph in the docs regarding copybreak in v5?
> 
> Document that tx_copybreak defines the threshold below which the packet
> is copied into a preallocated DMA'ed buffer and that tx_push_buf defines
> the same but for device memory?
> Are we sure we want to make this distinction ? While the meaning of both
> params can overlap in their current definition, the motivation to use
> them is pretty different.
> A driver can implement both for different purposes (and still copy both
> into the device).

I don't understand what it means to implement both.

It's confusing because both parameters result in skipping the DMA map
operation, but their usage motivation is different?
What are we instructing our customers? Use copybreak when your iommu is
slow, but when should they use this new parameter?

IMO, a reasonable way to use both would be to only account for the
tx_push_buf_len when tx_push is enabled, otherwise use copybreak.
