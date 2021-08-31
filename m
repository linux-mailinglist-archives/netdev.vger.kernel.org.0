Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E443FC4CC
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240513AbhHaJFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:05:19 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:16384
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240447AbhHaJFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 05:05:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5alcUD5kbwL+7/+DuWp2wio3neFdynJ76L7DG+/4ppbKqUt3caUvJanNPY4qITNwP3A+sNe+kCZQ7oABxL+GjukzlvEdoUu/2IGeFMdCIM6B56Wv00m1m5elSeOUx74pUnLBX+ulZtyya7ktiPmhH6vQkRMi9tlQBcOYOWqUN2jjBYy2gDunjmz4kKvl77McZPtEYkPWN8wHl1gNgIlPRjTXCxcRoUpV8J1C3qKkpxZ17o26pMRa0w8Xws+cGidU04tfjdpxXm5/i+qUdvELzzlYd48n/Np0gvmJcmZxc0Qjt91lTFhsuESKhTI2YdGRCzOBHzxdg+1c+v7+JkKBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiThvV9zUrF3noKuqGQCCpskJ+J72Au/4puaGOrR2j4=;
 b=KceOXrwIo5j5Q9T3/EK4bk4XhdyR6i5eXNApPP+h5RMP85ur/lx/xL9sicbf+iqYvcM/hP5EgaIB/ZJ/1lfWXYXTmEXBgK6DLRPflRb/m7TbGmGksQNdlOct5DRF9hYA3qbbFK095uY/frJA8XWzxATbwlQ9yCEQSgMx9bkFUTkhgqCw5VI8wetVI830FmURVOfZYGNiVxVbJCo83pRzUcK35I/7PJZ+WCr071pq/7yvnV+2arI0k1uHDqjxVaVVc4NnxfTY0xBmGI2MSAWxjcJP2Q7kUhBS6xPnzywQRBDqF2jfklFxrLpvCCANhh4qhcufuu+jj3kbVYj1QIgVHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WiThvV9zUrF3noKuqGQCCpskJ+J72Au/4puaGOrR2j4=;
 b=TIb95/1w5asvzbsYZXZ04nElUc4pgDU//ApbBVNI+OBxM5ZSmKOxl462RnwkVXtfN3HJZol36hGJC1tKRjYV8Km/z7L+BSrdLK6yLypq0OhcSCgXZ/WGmPdKBPlHyvT2W6vJQyXVHSuQuVjQVMTzog1Jui8gOx3G7kOnWPf/M2ROFSjb5xFw6fUlHoPvDWQi5uMZxy/QALouIf4E6wKnp10TmKT5iBhju6ofSdiBi80bnLX/P33h8NU4KoACtHUXc83s0u63RjYVwB0M3MfQZBX2crNrIsDejGOuYn8Lgq835LUdd6HCW9jEwblAJm4lZD/5wmiYVJX9yI0aswVcrw==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5496.namprd12.prod.outlook.com (2603:10b6:8:38::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 09:04:23 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%7]) with mapi id 15.20.4478.017; Tue, 31 Aug 2021
 09:04:23 +0000
Subject: Re: [PATCH iproute2-next 06/17] bridge: vlan: add global
 mcast_igmp_version option
To:     Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com
References: <20210826130533.149111-1-razor@blackwall.org>
 <20210826130533.149111-7-razor@blackwall.org> <87pmtuoulz.fsf@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b14e6b19-96d8-71ce-7e7f-3318356ed7cc@nvidia.com>
Date:   Tue, 31 Aug 2021 12:04:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <87pmtuoulz.fsf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0152.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::10) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.175] (213.179.129.39) by ZR0P278CA0152.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Tue, 31 Aug 2021 09:04:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4f8e1ac-ca3f-438a-50bb-08d96c5e531a
X-MS-TrafficTypeDiagnostic: DM8PR12MB5496:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5496308FF0FFCA30192E48D6DFCC9@DM8PR12MB5496.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NewVx2zmQHvyej3MBmMLSIpV9dY3YCpo7xWQGLC6zxgmVGcVUefjlT2MToRIaRYH2M33PNeweDgU2QFhpbaNyTLEzyfcQbpsmsuY/Jn8ho5sqg5NmHOtRVu2pYspIKqja3LvDKvUQT4dXgM7Mr8wZot/MBeMC5A1yCOh/xG4XJ0DJfHt0qcFz/pVfMtZEKhxDJh8jz9dvWQK4RhmtiO7B69Wgd/W17AH3S2NrpnAE05UcMAjFKsWXVa4lrby/NZPtk5EuGpoATGzPoJzB7rGFRLXxyvxuGHhfpK2Y7mwuds09IAkzaxAMiTrDuQXHwbExfWb4o2xkDUxC6c/9DSjnsWB1ZNWXLg8S/39er6JyYQ04NXYzTwQ/3cko8gm+awiwMemvcrgvdQa27ATXeNXh6FEjp98yMpVzBBIZFxxHWclTk073YxKgES148R5/AFYq4TQxDitgRxUBG8k3ywZY9QwuYHxv29S204Nv7qHRd/Fh7b/9mpAuYSoD8jTHesTNWhP5/nPf13YNYv7bLT/ta2/G0bdr7EznlZoIpV4KPZc2knxxSrJd/OptIhNnQnevY36EcByPGs652YNwO+0B6ApYIYfQwH/nTbG3svz5alkmQJRCmqgrm7UTTfDIlyRXcCjG1CrUI5XwqJ1Tq6P9YWrWfRX2xzEqKblJzXJEMwVmKg7KqgQPRocB2FpL+ywQqEXYOSpfEt3jFXIeGadyDr0s/T1D2rBzoRiJEa0oKIicwmKSCfIZiS4v3+YU7fAxMa60goHDzDeDLB36I9D9167Gg1M0nMdqiFGemFwHAj6GQ+BNAcptJO+A0QU3h86
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(478600001)(2616005)(110136005)(36756003)(31696002)(316002)(66946007)(86362001)(186003)(26005)(53546011)(83380400001)(16576012)(956004)(966005)(66476007)(31686004)(38100700002)(4326008)(2906002)(8936002)(6486002)(8676002)(5660300002)(66556008)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzhRZTBheFF3L08xWVdwYm4rMkdiYndlOTlLTFVmK09iZTFUWFFRRE8wcGdT?=
 =?utf-8?B?eCtVaDdqMlhMK2ViYytnYVZ6RldJNVJxOFRNK1V1am5NTyt5TnZsTVdjb1NC?=
 =?utf-8?B?K1FvbWV1VWhCdGdDdUdQQUhxYThkZGlPYm44YUM2bFFBNEpqUThOVjFNY0JY?=
 =?utf-8?B?MXZyNHNvUWFsYW1paG4rWmxDWjV2M2o4QW9VdGFoUjJ0b3RHa1FZc21qa05P?=
 =?utf-8?B?VFQ2d0NLL0hmWWJzSGJBNm5jMmRYV1Mxa1JyWEZ0UHoxTm16UHk4dzNQUTkw?=
 =?utf-8?B?a2lNMktoREN1R3BNdERZSW90MGtvM3d3QmZDdVhWYWRUcGhncSsyU3NSRVh1?=
 =?utf-8?B?cUVQUit3Umw4cWwyUGFPWjlEQnhwUnhCQWdVRkh1UTJMS1I3T3NQKzJqYm1U?=
 =?utf-8?B?K2xJRHhxOXBaNXMyRS9nSFV6WEdsY1duWWVXekNWbklEYkR5eUxiYzlpR3RY?=
 =?utf-8?B?KzJpbSs4eXNaYVdiU1F3U1FuVFZiY2NZT0Q4MUZxTVByNytEL2RwRENGSmVz?=
 =?utf-8?B?SXNYRHJIVmxEWk5ZQUhQTkhUQkNWbW5wRW9mK1hsUVhoQ2RqYnZOZFdvdFdQ?=
 =?utf-8?B?a05xT2FHWVJXTUdScnErL0k0aS92VHZ5dVdyVlVxekNEdCtIWWU0c2Zhalg4?=
 =?utf-8?B?eTRpZ09EZ0N3SVpFRGM2L21MaVk1VmIwaHBEYkdCMmJFdVR6aGdIRjAwZGxZ?=
 =?utf-8?B?OEtPYVoxOG9UVkZIQkRySVdaYnFpMTNsV2ExRDdDOC9NRU9xekpVcHRzalVZ?=
 =?utf-8?B?UVVCaEFnTVJSTVFadlBqVEF3MWEwT1MzcDNJeHltWmIwemJpR3phMDEzeVB0?=
 =?utf-8?B?V2hKOHVCa0ZmSmVpQjM5R0NNc08yaGp1QUdZMml0eS9TTy81c2oweVpLUUdQ?=
 =?utf-8?B?M3dJd1VoMlJia1lRQmVwdjMrRythMmdvUld2N0VjZE9YTUQyMVFBUDhWOThR?=
 =?utf-8?B?d0g0N1ZlOFI4R0ZVK3d4UW9rWW1teTFpVDBvNUZRVWx6WUdpa05QdjJ0R1cx?=
 =?utf-8?B?aWVZNy9RUElETWJUUU9tbXkzZHliT3ZKb1pmK1E0NkhMK3BCVDJhd3FGdGhD?=
 =?utf-8?B?QyswVWppdnpMeXFJMjFSQmJrL2xROVRlVHBTMkg2Szc1QTgvUktnazYxeU1m?=
 =?utf-8?B?M3RxSkZML1ZZVllqSzYxYklTSHNrSWFmSXV3Q21wUnBsTjlyRUNCVVlRckNO?=
 =?utf-8?B?UnQ5Q2wyV1NqOUZkTUYwcGJEYlZzYWNlV05vWnA0a1JUUnl4bmZER2syeDRo?=
 =?utf-8?B?V3NzeHRkZWhrWTdKWjlad29PZjdxYjVsa2xDd3pLU3hRNVJQVWQvd0pXMmFS?=
 =?utf-8?B?YWdFYnk4UTBlc0hNRCtLcXR6c1UwOGI5amZZK3pUamlYdGlVakRaVDJxTkwv?=
 =?utf-8?B?cFlDTjkzeXlNbTNydmNyMnc4NkM5ZjlITWlyL0g2dEk5YjVjdUtBRm1JcGZE?=
 =?utf-8?B?T3Y2c0lWOUR0YlQ0U2MwTlp4YVc5eGRCM0Q3OHROcmYzanFWUVFUOGZvQzdN?=
 =?utf-8?B?YmRpRk5zT0pvOE1qZTR5NUErajlwRjBmYU5OU1h3ZTk0Wi8xZXlQekxocW00?=
 =?utf-8?B?NnVjRUFsWjV0aE1BbTloVVpWemN5dFNYelFXam9zdUdnWkdoNU43aWtkdXAx?=
 =?utf-8?B?MjFpYURSTVBpSy8vYWFqSFRMakd1RWR1Mm9wUUlwR0prQ1Bnc2xVT3VyeWJR?=
 =?utf-8?B?MUNzUXU1clhpTENPSG9nUUpIN3VDRDdYMGNxdWd5b3o1UnIvZkowK0IwSS9s?=
 =?utf-8?Q?hpu791WMuZ8ToBv1rXKbsM9N5TLw3Z7LvMw1HZY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f8e1ac-ca3f-438a-50bb-08d96c5e531a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 09:04:22.8914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZlTTahEvWWrND9DfNyG/+Op8YvRiL+AB4KMY/10ZUNA5vxkgc5p/z8TECkIAxNWXPLZJfVY9Dpuo9rg4inHdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5496
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2021 12:02, Joachim Wiberg wrote:
> 
> Hi Nik,
> 
> awesome to see this patchset! :-)  I've begun setting things up here
> for testing.  Just have a question about this:
> 
> On Thu, Aug 26, 2021 at 16:05, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> Add control and dump support for the global mcast_igmp_version option
>> which controls the IGMP version on the vlan (default 2).
> 
> Why is the default IGMPv2?  Since we support IGMPv3, surely that should
> be the default, with fallback to IGMPv2 when we detect end devices that
> don't support v3?
> 
> The snooping RFC refers back to the IGMPv3 RFC
> 
>   https://datatracker.ietf.org/doc/html/rfc3376#section-7
> 
> I noticed the default for MLD is also set to the older version v1, and
> I'm guessing there's a reasoning behind both that I haven't yet grasped.
> 
> Best regards
>  /Joachim
> 

Hi,
The reason is to be consistent with the bridge config. It already has IGMPv2 as default.
I added IGMPv3 support much later and we couldn't change the default.
I'd prefer not to surprise users and have different behaviour when they switch snooping
from bridge-wide to per-vlan. It is a config option after all, distributions can choose
to change their default when they create devices. :)

Cheers,
 Nik

