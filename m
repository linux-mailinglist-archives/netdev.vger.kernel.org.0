Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DCE67C492
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 07:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbjAZGuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 01:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbjAZGuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 01:50:16 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121A93C29
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:50:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oej012eUlP/HlkE0Pw3+etysbf0mNqQEo8dhcFgozyK9jAlAao56XZu8HvwFJRv+CJtBxZ8J60B2cA8QjARn7cJHPfoWdc+SMvQUy4pcK07rLQOto9832M6u+dCkdKnKwxJftS7idNJQ/yE1f+O+n0MVKZIPQYbH4U4zgxKQyWqmasdjhFOEYCgB40tCr3mqpA9l/qhRcuPxsmkYgLF94mW9vWCQFks71JCcwhDpXNeSlxpDqE0QWeRT2s7EfqkI/t26s+E+wY8RfblXfyLUIVB0mgJA62x/2Z7osdyA3nOcnbv9SbYs8KIUcVz7NcmbxoPi9AyLnz8btHBRw/J3vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TK+kHOhnrzXoN4Ig+cuYaQM3bhjhMpc3uoXDWlNjXgk=;
 b=Oo6tbl6YfMstJF1QRsxbiX30eXCOQRke+Eq6W3nsr9KYfVNIfZQBQwKFdQmxMRjZWufPI/oyqf0tg3QTDR1gN7PdgcjJK7+EK5RqJO7lHzNc4RUfqBS29/YD4OOWlNx0aBMtf4u8hrPsSyWx5/r1XVrPxHXzYyo3doGveafTB7WYEbX9i1lS9HwGFJo75vWDlTSuAu2GtQ8QqXPbFSIvwyVoXKsegQZSzzddc97x54fx6D315sXiOEm2dzWUqrlUDIB8kfMikXtlw7yyXrtlYRAWeLi5BjH+OctFQNdQhhA1BYTJ6wyPT9L1274QTSWDDVOjsXlXmSXtVUC3RK4GVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK+kHOhnrzXoN4Ig+cuYaQM3bhjhMpc3uoXDWlNjXgk=;
 b=kOiOjLcLFg3X6dA8L8zYW09VXjv2+gqWh2lOiK40zxCcpLqc5oqD49w99zoSpC0vvtrnBwsUbzkAh8FuZ8FJdS8krmKh9IX+oTSFZYMqwzyypS8uiJ0u2WpRZC9hqUwZoTU1Ug2s8UtgyESZ3TMhcA9Z0x9XRLAhbWhsKTXAxUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by BY5PR12MB4885.namprd12.prod.outlook.com (2603:10b6:a03:1de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 06:50:10 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::a2d2:21cc:bc90:630c]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::a2d2:21cc:bc90:630c%3]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 06:50:10 +0000
Message-ID: <2234d6df-06c8-4f94-760b-c3db4a94a4c9@amd.com>
Date:   Thu, 26 Jan 2023 12:19:56 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/2] amd-xgbe: add 2.5GbE support to 10G BaseT
 mode
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, Shyam-sundar.S-k@amd.com
References: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
 <20230125072529.2222420-2-Raju.Rangoju@amd.com> <Y9ExAOZ5q6rrZoLc@lunn.ch>
Content-Language: en-US
From:   Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <Y9ExAOZ5q6rrZoLc@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::35) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:EE_|BY5PR12MB4885:EE_
X-MS-Office365-Filtering-Correlation-Id: 1713a874-5d93-4df3-a140-08daff699151
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kPRk79LoI0PGgOa1WnCG0gbnZEmDRWJsx/4WJ6IFhXp1x2phjUzdd8ARLpqf5Lm1p82hF5PQ0AOEaHqCYQdx7A4cm1OS+ypoLQpDIsFY8fU7NXH93tnkJvMYmUyqbl8NOe8qhALeGDfv5hBHTIYVDDB8y3IFouP+GO51XzxN9ua/eMPWG3yzFRBf5PVJWWQrEY8HTMOZtl9nWoQY/HdvfKneg9UcsbyDq3nKcGC/6qFeNW3pHacePK+A8EIgaeyY1lUzj66B+lgeVwbOMl/ZayoNh/VPNmNTEW6LsSZB/2UbX38vI3qlbFHRDp9I8veXR99FAH+kEchNqOuzzPvBLE5Dv0y9AfqKaesz7YTcWm/egsmDNZMb8kCnbmfK+O5Fu/K1GmFKJ+Nx7pG5XDVPFowheAfPB8f4V4LJaKY9mJeR4+adPsHfMXD0iovvqaeBEwv1ep5Bb3uPe7uxXieyd7ip0ReopHxVOK5Cvp0LROf2aeyRESvEXK+YMCU4yZJ8r+E/hmNcQdMtxbzt4wY5IrISeqNX2t48/PD3GRzFQ77yn3mahxBCb8sVcEREbrxZCvQZ8qK1Pfe7PJ3wlJxJivOUfc0OAXvNcvoIFqX38X9QtCxmigjONmLN5BWwpfFdFNvUDMrDumL5/AajhU7gFD+x55DlSDhBX25QpNHMuqEXrzR7rd76IeR4pq1BBQQ0iYUpKUirGSTpbNkxRMcD7M/Uk/JYsYZKs3DoqfOET3w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199018)(316002)(38100700002)(41300700001)(8676002)(6916009)(66476007)(66556008)(4326008)(66946007)(31696002)(4744005)(5660300002)(86362001)(8936002)(36756003)(2906002)(53546011)(6506007)(6666004)(6512007)(186003)(31686004)(478600001)(6486002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXpXY1JUV2cvRVd5MW9lOXNmWElxaWRmYnljT3RPenhoRHJjR09kNmp5M1hk?=
 =?utf-8?B?SjNsT2RPdThyckpkRkxud0I1WjhzaE41MnRpMFkyRXphREhXeUF0WnZ1ZnNS?=
 =?utf-8?B?YnlnQjVKVkd6b1JpOHdhcXhxNnFMWENmMGt2Z083dTFHQ3BLL2hCK2Z2M2ps?=
 =?utf-8?B?OEdkSnNYa3JvM2ZjcERTUmVkcUpjZVFIREYvSUFJOFFHNDdiOXg5WFpyeGFU?=
 =?utf-8?B?MjNuODFHL00xWlhPaTFuK2wydzhOL3dxeGp4U2RXRFN2eUlJRXZaOHhOejZU?=
 =?utf-8?B?Zm56MkQyU3hYOUVUVkU5Z0xacWhNQW9ud2I4SWU3QTB3QkRoU29WdG85R1lZ?=
 =?utf-8?B?QXNNRCtPbG1wSzdGY2s5bTJaNENiRkhjYXRhVkVKeUtNNzJ2TW9lblNncXdO?=
 =?utf-8?B?WWh4OGZ5bDd6d1BHbDBhMHVWTHlvYXYzYWJ3RmFUY2hDZUFwM3hxQy9iMFFH?=
 =?utf-8?B?U01nTStmQVc4NkdOb1FpNERhYXdqMmhTMk1ERnd5c3BRTk1JQjM0dDZBNmxo?=
 =?utf-8?B?ekhRa1NuKzRzdElZaWxlMjVSWkxidHhDdHdKMWpsWFJBdFBwaHRpTXhjY3VR?=
 =?utf-8?B?bWRLdVFZSm1ORlZacVdkTFQ1NDUwSkxmeGx2T3pOVldjU0lVeUdINU5QV2ZO?=
 =?utf-8?B?ZGtCVjF2bU5tRlJoTEUzelVJTmlRSE42d1pXcXNROThhV3hscTU5TjdNZkdj?=
 =?utf-8?B?bVFKbHZKQU5acG1oaWtiTkd2cm1oakF6RllUTlpqeVluQk9ZNThHbTBFM3pZ?=
 =?utf-8?B?S1BlWnBYVWNJMk1yQnV4aWp4Qk1rQ2o0TUE2ZVltV1FVaGo3YUdiOFdMWnVZ?=
 =?utf-8?B?cGM5L3Y5N1NKMUJTZHBpZ3E5citxR1MwM1JCV0lSMGV6cVZkK0ZxMG1yMWVG?=
 =?utf-8?B?b2V4YWphTUt5eE5YeVh4c2RqemUrdXRXaWp4Wm02eVM4citlR29QUGt4cWhq?=
 =?utf-8?B?aGI1QUV4N2pkenowdmxkcWl0a2V2c3pDbFlTTVN5YU1nczUwYWkxeXAwZXhq?=
 =?utf-8?B?VVhiUXZVSXMwcUxoUUMrUG1hKy9lZjdiRlREV0RRclNrQ2pwSE9Va2p1Nk56?=
 =?utf-8?B?ZU9WZ0xDWkw4akF4MDRQS2l3YXJxUGRuVGc4eStkamNOQjU3NWREUytGNVQw?=
 =?utf-8?B?aElUSFpVaUl1K3p0T3ZvMFR2UzRURTlUVWp6K2JxQTlrVFFLNVhBcUpWVC9W?=
 =?utf-8?B?dE1aZHpmeTR1S21WMEZRcld5a21SNEtIOHVLdnRYTFBDdGFRa2F5UnYzenFj?=
 =?utf-8?B?L245dGNlaWpzM0RndUN1ODcvcDF1a3pobk5oekJNaGhuaDV2UU1WdGsrbGtG?=
 =?utf-8?B?N1VpNHBTRk80U3JzWlpGS0MybkpTbVVzMmlqcmJNZ0hVQkRsRTJVNXhZcDM0?=
 =?utf-8?B?NFlMVkxkT25xQTBvOWJMOVJOSGgrcG9tTkVUTjFndzFPbGZELy95R0VRYmFv?=
 =?utf-8?B?YXhBVFRLYzQvOVV4Y1RHbllONllPcnEzaWFrL1ZLVFZzUlRKcFZ0OWVMVUJn?=
 =?utf-8?B?b3B2WWl3NUFiNTVOZFJVemJ1SFltbUVKckZvdXlUdnlpNURVV25hRjdUc2Fo?=
 =?utf-8?B?SFlxVFVWdUgzK1R6bjc1bHU5SldNK21vNTkzTk10OXRBcTBkaU1zY0FYREVx?=
 =?utf-8?B?MDBSVllRanpMa3BtZlF3MmIyREkreTBQd1BkYk1UaUxJcStzT0lCQzZGanUz?=
 =?utf-8?B?MHkxdyt1NmlBMnpROHR2aXBsWVlpdnRWV3A3b3RvOCt0TnBPZXhKVnlQTEZI?=
 =?utf-8?B?QkZtaXpYZERJZFhrd0U5UGhGMFJ4TmROTkI2d1BZcXBNLzYySTFyZGo4TDRG?=
 =?utf-8?B?MFEvS3JSb2J1ZjF5TzdSa0JIZWtEZGpVQWpWOG9KWVhiZHlwOU53b2JuVnE0?=
 =?utf-8?B?bUVvb0FvUVZ0MG9yV0wwdTgzNXM0a1J2azBPMTRiaTV1TERCWjAzY25hRnZi?=
 =?utf-8?B?ZWVQazlpWmxXQTArZjVLd2VtcGE2MitTY3MrZDdXTGl0VWNBdUJxeHBlLzBG?=
 =?utf-8?B?MXdiVm9lbHJWT0xCREJVUzJwY2x3dHh0NG5vTHZaaUIwWXFSLzRrM2gyS01v?=
 =?utf-8?B?NHNUbXhZL0FLSGFKOVRxMklIYitsbGxxMmVaVjFhYWlhODBwN2ZsUjNnTUZp?=
 =?utf-8?B?bUhKa2JqNGdONnRQNWZPRXBOQndOMVlZRkduU2ZyeTh6bkZmSS9aMmVIM2FZ?=
 =?utf-8?Q?XxI9o6jW0RBhFkxnZyaGGOAyD9FWxHGqmpkBl3TJuYZA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1713a874-5d93-4df3-a140-08daff699151
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 06:50:10.5571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdwOfOydc8KCkcfkQDCZNh7TlFQPpfAG7tjmGMXnvgSYT8AylU8Odarodm2MNmAt/0SzAje40lbMI/PHnkQJYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4885
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/2023 7:09 PM, Andrew Lunn wrote:
> On Wed, Jan 25, 2023 at 12:55:28PM +0530, Raju Rangoju wrote:
>> Add support to the driver to fully recognize and enable 2.5GbE speed in
>> 10GBaseT mode.
> 
> Can the hardware also do 5G? It is reasonably common for a 10GBASE-T
> PHY which can do 2.5GBASE-T can also do 5GBASE-T?

No, the current XGBE hardware does not support 5GBASE-T.

> 
>      Andrew
