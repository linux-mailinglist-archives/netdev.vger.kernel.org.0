Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B26633C03A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhCOPof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:44:35 -0400
Received: from mail-dm6nam11on2074.outbound.protection.outlook.com ([40.107.223.74]:51041
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229764AbhCOPo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 11:44:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5kERmlnTcDBN47b86bFgwTfV35/wQ7cr74EoXOzEf+TzoTDLPrzsPzZicx8Z55GzcdCzUoBuPf0NIvhSLMfp2jqD/cyuzQPKY4fS1OYC+vCcPbdSFiHPnJdXzvjl7oq7DttSQcL++QugQSkoX85Y0SMaZENWj7K+21YTcaW86lGVWKqPSnWfLyTNT2380Wg3oHe+PiClCNvdJe3CKVAL7almykMF9LqHlQw+kRcWLep4kprbzZyQnkQjSAmGpZ08bKxg8x9h8adNEuqi0YyFHwGUmxxqIoKkIB6UAc2zaDMIhScyJ2kNaZkMwoIFYRZo8mFPhdFeEfNshZ5vtzDGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrcEKyxLLfRA2ghTLDadh5n8T6ImHMxOr/Vcv2QkIzw=;
 b=E+El5vqyjoPSRRfj9iD+SDiRSc1DLXcx88NVcNIGhp6QksPm6DEHxL2QweAWiM8dILqG6VxVxBfFYmevqWfwQk0XYQWbv8QqLoRHwfWE0ZOQ9rIm0ctpbxDZiAYqMwKp83HejpwaWzgxC3jeh2rxLkubLOCa+v6lDglqba8B2teeW3pRw9p+OxcWHAfA+T0Ba1SJ0mVUPTOBitX9oBus/PB8WCRz1EFjp1RGz+T1/E28EQr5d1XX0aHQRT0ofv/E9K/cyosbPIibhzUdFlTR/1suoALCmafHhWqlZgcfdfuHeP0uJPRx7X/c1HBlDPmkorsKZX2yNY7pjXbfmE/CVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrcEKyxLLfRA2ghTLDadh5n8T6ImHMxOr/Vcv2QkIzw=;
 b=QgaS5YaL0z3cfaLgSdsowf89CNS5dhcmBunrLjX4t94hK5QadJurpLvy9R/oH6Ytt660PxmYQz4tmmap2N748Ghhf0bgBAImV133ApUCdGCZrPV6C6bbng+3oZhbKnRBCjcU9NJs8J6RhhLDNrxqyiq1DTyBOqsIWU2oAfV43NaFwEM3xGc/E/73a5xng1Ve6+weG+XMog3a8GAc33QYqaPxKaZxbMxz+j1I7gy1zeVD+cDo8IwlQ4sjOoAGKKDnqHGwgnDrlKlyMOu6ZJJm0ilzW/gOdij2yIi6AKdn4BlYsdiCHmKfKHoHR02iHUtieVMzZl4LdTDUfNNHWXHaIQ==
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1388.namprd12.prod.outlook.com (2603:10b6:3:78::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 15:44:26 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%6]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 15:44:26 +0000
Subject: Re: [PATCH net-next] net: bridge: mcast: remove unreachable EHT code
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net
References: <20210315153835.190174-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <ad95c2f3-a3c8-cd56-1e83-e4a7d53c7f7f@nvidia.com>
Date:   Mon, 15 Mar 2021 17:44:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210315153835.190174-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::26) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.42] (213.179.129.39) by ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 15:44:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f0d6b82-5ee8-4c8d-f078-08d8e7c9362a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1388:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1388D1F095842923A230A456DF6C9@DM5PR12MB1388.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R2d43KBr+gaJR9lk8ZiDE0mCfmOrHGWUVLJnsI8mm0ZG8GyeHaNu3qpIO+AZ2M8/ytsN2glduIYK3OmJy+UMSwvdQ29UlA7d4RigqC/iyg2MVZbOECPAYUhQ7LIZ/WEs9S4VTzyTWO8FLKVBvNXMqKnG157e4y3lm5JeW0fQjBFhJwvZaDJjjZVNuzD2XH7/zodNfsqQYwzuXqlMCtvQkcFQc2WUQQtv6qmMFE3tL93w4OYfjgnNUjSpkK50ySBMs7g/gxnpMjkAFZxdnYR3XP4Ys8arSmeZcXPPSDbmA6YQWxbeVbYYuT5ZqMTJbAQlnAMA+AR97Ui+w1qCqirPDWjweQ+shD0/Snx3aSTrvZTGGqqa1BM01zxLCdR0hdRuN1k7OlBAiCuI7d9y1xX/vXJ/u8Q+CKO5RLA+vvs6D3p5xLmWhFCwQzei3jETckAXF6RVDJ51SP8iI750gRk6bed0gA8aahZxgqVPbX2J/3/T/g9Ay/fD40wfUCbq0PFfm+CepZYA69PKjEL79mKd5JNxDteZA7z4b8oqva+j98nHfhO+zFAnsdPZZFF0O7mka+0UI1xLoar4VYrKLZ0RNRxgbSk4mZZRl7H9rkeos7/nThMPcNxA/EWzY5WD0i2IibK7EYvbKvKkWDyjbaDn9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(31686004)(4326008)(478600001)(26005)(86362001)(186003)(31696002)(36756003)(83380400001)(6486002)(2616005)(956004)(6666004)(2906002)(4744005)(16576012)(8676002)(66476007)(66556008)(66946007)(8936002)(316002)(16526019)(5660300002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UlBNMThFWEthTS9DWk16dXN4NVZYb2doT3Z0bUcvditpbzBTSkR1S0hyUDR1?=
 =?utf-8?B?cWltUjJMemJwYkNGUmFSVFhUdzk2TElGbVNRMlZPbEJaQmdvaXJ5aFdLdU4r?=
 =?utf-8?B?RkhVUVZnSVVvZm1xNXJvRUh3QmI4Rjg1NUpyT2s3WGZvTXg1TjV5Mi9FUWxD?=
 =?utf-8?B?NjdxTHFHc2tCM0kzd3hrTnVxV2RiK0NhckhudTN6emwwY3Q2bmY3T1hqa1BQ?=
 =?utf-8?B?VzlzK2hOZTRLZVpyWVRhS3lHV2FqZTFxNFp1aE1jKzNpSUI3TjlDNm8vSWlM?=
 =?utf-8?B?SGY4MHg2M2djZjhWWFdHVlduazBYZEowbGgwUzUyMGZxaStzcnIrQU9ZbUYy?=
 =?utf-8?B?TnUvM0trOUNWTWYraHFVUmpsV1NWNFUzVlh2SG9DTWxiZ1BWVGIrenU4TjlF?=
 =?utf-8?B?eWlWcS9CZGtHRm1GZFhtaGd0N0grVzJXNmRmbGNYTzZZQXlXRm5QTisxQ1lT?=
 =?utf-8?B?SDZNaU5PMHFJZ1NQZmh1akNHeWVLSTgxUDc1by8xSDJCR1IwVmZNQ2JKbE5H?=
 =?utf-8?B?aXhNa0hCQUlPWktTanNkYW5DVUlyU2MzZUM1QzFCaVJxR2RvS0JCaGVOQTcx?=
 =?utf-8?B?VndVeExreDZ1Vm1MUjhINDRscTFVU2xTdjdEL1NCNmFhMnNISUpCZi9lbk1m?=
 =?utf-8?B?RG0rdG9VMDV5UjhLaWNqMmFhK2JzV0RGMm8yMGVtL0daaDl3Mm5zMFdiUVdi?=
 =?utf-8?B?VmFpWkFCYVpwQ2NqVFFwMUtkUXA3MDlXaXdCMXlYQktEVlNkVkJ3TExCZFFF?=
 =?utf-8?B?ZTVRR3FDYWhVa1pSdGYxR0pES1NDRWlKU0o3SXZaYlVCYWk4bmhrSEFhZ3Zs?=
 =?utf-8?B?MUlZSWhyNVlSU1VpZTlOQ3A0Ty9QUUpBMk5keE5ld1VYKzNiQVJ5NkFvSzEx?=
 =?utf-8?B?QjFvV3EyeTBjdHFzb1JNNEthUWlBQVN4WnRxSUpwRGVTOXdYdjVienkvM0ht?=
 =?utf-8?B?M2MvTDVrOTFpTkR6NXBFWDNNbkRSYXZZMXRSbXY4QVpKek8xYy90OFljSW9M?=
 =?utf-8?B?OFdIK1B0S0Y0dXpMUm9Taml4ckVxZVhFeTE5S09aYlUyTDkvYkxEVzJhalBI?=
 =?utf-8?B?YUpmSFppV0dnS1gwY3VIaFJXbFdZK28rdGJ2VDF2OFcyWDRKd0I1eXVjRzJC?=
 =?utf-8?B?bjZWSW9HK3hCS0s5WVJlL2w4NTVxTFVvajltamZPdlZ1andyNzlQTkczaFVN?=
 =?utf-8?B?R1lFZ1pIbGxjenAvZTFoYmxWYUdzaFlEUE44d1lGRzZ5bWh1TGdHRHpCVUpn?=
 =?utf-8?B?WVJERWd5WVgyZlNrZDljR1huZ05NbGZkQjJVc2tNTi9EUFR1K0piZ2NibTdP?=
 =?utf-8?B?TEdOVEkwVzl4RDFMSTNDMlNVdDZZNlNnNFAwUEtpWHFxRGxvZFpRUHpvSkxG?=
 =?utf-8?B?WC9mMUZ0WnN3clV2cmx4MitWTW55LzQ0UVlMS3BqYXhiQkZBdnB1RERvUEh2?=
 =?utf-8?B?eklXcUplNXppcGxvOUZBQzY1RlBQRFdnU2tzQTJYK01aOGp4WEtDYU9FK1FF?=
 =?utf-8?B?Q2gwc2wxOFRuS2ZtUDJhUGhMMUdEQ3QxeVVjSm9uRGt2M1k3a3RUWVR3NEhq?=
 =?utf-8?B?RGlRSWMvM0RNbU5nZFhQUUVoQWJLQVNNNU9scU1zdUpiNmQ3NlI1dHNFMU4y?=
 =?utf-8?B?SjJIOWRCbHJTL2h3MHFaVjNjaGFhRWlkQ2lNdHo4c0ZuQ0VqSHF1Q2IrZkRO?=
 =?utf-8?B?RjkxOFZRb3VaRGx6TEM2clFXanN2VjRQQlV1eGtJVFI4YzhTWFkxNHp0ZVVM?=
 =?utf-8?Q?Se+eoceafjUmSRxKYDaLHSeag4yHHVlVp52+lFw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0d6b82-5ee8-4c8d-f078-08d8e7c9362a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 15:44:25.9775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pj/hjgJH7kaxIQNTaWwq8krhCtrDDdA7YJFlcYDSvwY7FTD/boIQRaL5Su9TFbaeOpazfZUsraUAyQocFZTmgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1388
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2021 17:38, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> In the initial EHT versions there were common functions which handled
> allow/block messages for both INCLUDE and EXCLUDE modes, but later they
> were separated. It seems I've left some common code which cannot be
> reached because the filter mode is checked before calling the respective
> functions, i.e. the host filter is always in EXCLUDE mode when using
> __eht_allow_excl() and __eht_block_excl() thus we can drop the host_excl
> checks inside and simplify the code a bit.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  net/bridge/br_multicast_eht.c | 54 ++++++++++-------------------------
>  1 file changed, 15 insertions(+), 39 deletions(-)
> 

Oh well, sent the wrong patch version. I'll send the proper version as v2.
Self-NAK and sorry for the noise


