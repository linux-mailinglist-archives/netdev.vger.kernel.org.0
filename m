Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AC54A8C52
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353724AbiBCTQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:16:49 -0500
Received: from mail-dm6nam11on2079.outbound.protection.outlook.com ([40.107.223.79]:3436
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344163AbiBCTQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 14:16:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyC0r2A+yePMGlrZk0H1WesifKgeGa2Dtkv02tiVkhMBTndy1CnB0UoLLEvVYxqwf6i52kYdF3FBfLmhUm/B2R0aLnyT+M1Gk7mst3dyDN/gZeK8sfTXl7Qk8/xikD9NDtwMReJ0XXZTGXNIHJgcK5CgE33bAZFGNwoMh5qZUbIhfRZly3hq1TTVOKl0yBzHUhouhdJVL4h/dnVEaBpToDN3MhigjRl4FKC+/Hkd2RXEb/hbxMrYht8Qu8615hzaIcJOqYwqd4BWmvh9lNJUsIlhnEOBUoG1dBUac9yAgXqAxiPzi4USeu8fRJ7lTaeq3hNr7/9P3GoCuXcmnZb7VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n98yuG/mf1/vvuIU0sQJoq9+LJecB8qhcZ1jeys6YVY=;
 b=Ax7MbIf+LhsM8zdBZbHOM2Iz+lo9qc5o4PNBXXgkHu5dkM2ooJBPcqm6B2BlVaB3wvkbmHvPBhcRCFvpkYVC17yeOTmW3VgvnkasgEbKgVci2Bn0BT7vaZm6/CxXjeXvV20U9z2SgJuk9lx84bMsoSdQ4ezGnA3xOBDGqy4Odg789Dkmvg8Nuye5w98qxudArhEtMNuVZVqmdCiHGlP8QiwTfEYnNvf+qaGPgoY1+lVJ77CkL5qbaeVbnWAmPxu1gimIDldPR4XJ7hmEWbKpYHP2h7yto4xypyHnmMPaSlS2uCNVl/EcM1uLBRqpYiH7tG0AlDpfiUYSdCt9INPSVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n98yuG/mf1/vvuIU0sQJoq9+LJecB8qhcZ1jeys6YVY=;
 b=JVeZmOCFLvCb+8UEYs2KIoEGVKVYm/HaG1DeRwhjV1ybo7+/JOZWaP9oyFl/EJO7nu75yjmZQNxBfNnvSDgVSRcfRQu3GaT09uNtIo2YjWdnX68mVedYUxJaVP671FRYERU3iKbEnUB6sCYGLBgEW9+JObYbSG6FncVF+vGdxrmkUkI439swRx8jK4wPddzqXQpaGQJfDEsnrKoi/PjBO6c9WwLQQk0QtTsB+dp+yNdllFtKx5IAKtbWIL6xCCiUgEE5Q17YdyWejoKC9fccRLKv8shkZr817q9cP7cT76QyUOphhPBaJW/FiDU9bOLNT/ut9SEzTMrvtGN7edZgxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BN6PR1201MB0179.namprd12.prod.outlook.com (2603:10b6:405:59::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 19:16:46 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:16:46 +0000
Date:   Thu, 3 Feb 2022 11:16:44 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220203191644.focn4z5nmcjba4ri@sx1>
References: <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220120004039.qriwo4vrvizz7qry@sx1>
 <PH0PR12MB5481901FE559D9911BCE9548DC289@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481901FE559D9911BCE9548DC289@PH0PR12MB5481.namprd12.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::19) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab95a799-ea3e-4a96-c233-08d9e749b85c
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0179:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01798FBC39640DB4BC4D75EAB3289@BN6PR1201MB0179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgrjOwRjdRjCOD5VcwG3ePhD/FUfqOIShWjq//XwG9a9qCCpYSEVpt7qn5ZQ9Pns6VrRW4wyi9CVzY6E8DkeycH0CyPHLNegn6y06JI9bfxTLdmpJoPeKzflnrxyRNa6wclla56lfKd/hcCZm3/Qurkp7ZDPFtmF2iL6Z650SrdKzaLXLJH3Il0UexA8kg4RY5pMknLquY/XvuIkZSXE3eF/qQ4t+btErzEaUCYDNZLzMWYEDMyBvK2Pwv+0ENRUmFknofsUn/LDbBxIkyhMT65DzuRGiTpqOEiIndB7E9lLWH+6cP7pmJJCq52yNnPz2UD05f6tX09U5YL+x5tdAR5aOwHarWtaXyHihyPHLtppQcscqXTXxqCxtz7BuYPQffIUxVlc8Rhwheqxt2iqrCdMfjS37dRLs/GTENrN8qrEUXOtjXLglKMa2O1AHBwaT29XdzWdDX91UMEfg3+qrGH4xKkKjdEAQ5hjMUqDw097YjX47KfQUrueWOKUbAi2NJJGYoq9jjVLQr8lKfh6ghsu7JzyOgrboMxSLlrnSJsraziltKw5XxG9m2S3ASrBMFGW9Yy/ivEgRCr2QRL+fhhLWGtiHZLROQBOASzTlJBcqbWgVfQvVR4EMfSs/uemUcPqNFprUK9piGc5UJHMgQRtQsVv4HQ2ziOZ3VjGemiIlxZi+02OdQit3HbG2j79htUG578AAwXxOdOVx4/hzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(86362001)(508600001)(6636002)(54906003)(6486002)(33716001)(316002)(8936002)(8676002)(2906002)(66476007)(6512007)(5660300002)(9686003)(66946007)(66556008)(26005)(1076003)(52116002)(186003)(6506007)(83380400001)(6862004)(107886003)(38100700002)(38350700002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r68H0n2zP5bY7gmUWro8AAhPEPtswHYr4HcDwJJMSuWMI7R55fuYGxh6Ace2?=
 =?us-ascii?Q?JIlWCl0+GUvTH17/Di3Lwz6+SEetwJqD4huLsJ/hPBeZUMpueTfZjOvfS1s6?=
 =?us-ascii?Q?Z0EWOzbJDfqPofcoFZUbrZuDwH4bAaDilI2KNv+clUaZcOdW/yavffQv66dv?=
 =?us-ascii?Q?JRpLuuEizmBVAXDFkfB/lLsFm1fBizv0PS5K1OpPwv4a5SFG87GWcB1XvsWm?=
 =?us-ascii?Q?sVjmUE1ZYnDJYVaPUnU5dkiwYMO/pWtm6sgKJqL8PU7GAvo5rgaiuY6hnVT9?=
 =?us-ascii?Q?Oz76rhM57eTuCmvtL+Ew6KcwXpe20SD40oEfHqB8z0dCrUAauRLnyc0PPA6v?=
 =?us-ascii?Q?+7MAd4qhy/fjs27pIPcqR7XHs4iX2RE7onV5mKPd2WdrN7bcfzcXq0mYUwih?=
 =?us-ascii?Q?GHV9Hk8/Fk4U2MpBTp6OqL0/4kEASCQg9fGaa4gR/XxekApmL3TkLEv3bYfQ?=
 =?us-ascii?Q?m4ufnRFnqwACbfiVKnGNio9SsA4i4IwZdORY7d4XmNWFnVKGxMyrD3cKVfYY?=
 =?us-ascii?Q?eW5umwfdmzsgVKxMGUb5jCKl4vvNrcpS6D2hmiyDHncMTmzXguL+Kun5DnSv?=
 =?us-ascii?Q?tCnxvRzsxLeDNDaHMm/3Bdh9FC3GkwEkicR8MzCUwkztxJOkRzoDtSWa0Nyq?=
 =?us-ascii?Q?2dPWn8AnBOKptUSzIq4aGYFkAjR4mjHnRNMM8L+h6xzgiJsUUbK3iLaIS9oD?=
 =?us-ascii?Q?+Wu6NVEizseEYLXxiu836UhRDbqkmKzwd4Bvl2suAKK40B6DZWWUWoJ8KsVW?=
 =?us-ascii?Q?kZ9DPuEHYZ8nIVDvIk6OZuj9vIugt16ijSSsai6FdSs1sCgAN0++QgdFM48B?=
 =?us-ascii?Q?BE6O7gkV8vjfj0hZc0HWg0l1YOA67Jumww6mzik0eJmObCaF+e7blmQU0Pjm?=
 =?us-ascii?Q?bxy6TP4ZqRFKAHTixcTZJiFjkXU/KPNqfttjPowD9gzTGNINJ2WrGdFyoHF3?=
 =?us-ascii?Q?O63spjh3HvgkIrI633p+2pf1NIRmE6WOkzg7pm5RCjRE1Q2RXzHCLoXNAPsH?=
 =?us-ascii?Q?aB4nXAarvPElrfruuQWyjEpJ9+XO0dzKweirMZPB2QxGJB43qKa9GUqGt3TP?=
 =?us-ascii?Q?pFH8Fxir5aMomffaJp+4LqlD6I3s2Vyf7DbKcyGWzBmG+pLmqS9AhbF+FhlV?=
 =?us-ascii?Q?dkdgv9a3/oSo1WKCFREovU0ujzqjZw+3gOLV5Ltn3er7UcdlmoyAa7w1cMI5?=
 =?us-ascii?Q?BugrKy0XI2JwhZVw8jCbaCv0++rumWqaXLdZO7uU91nz0wptgKHyMoCWvddn?=
 =?us-ascii?Q?J7b8gF94y0rHHC/gSw6ACdkl7aDPy4EUWiDo/0XS+eN9eYkWSWEWOiQLbg3L?=
 =?us-ascii?Q?c1X1BOkQJ0Dq/YfzZ1McasWf3ay1d840AylN2Mo8qa8UANWAh3bGgxgoFE21?=
 =?us-ascii?Q?C9rt+GCA4p7Zhj84Bgvk6daE7YqCS6zRc1Dh1cJqSx1lHn2rRRviqewmeKey?=
 =?us-ascii?Q?ZESJ0x9Kf5MhiLnYsfF+UaZQ+V5zAjQ5Vzd5V5LVaEBU6XuBOzOdr48saVrd?=
 =?us-ascii?Q?3LNJRtJAAvGtpaaxg/9RZwW7E8SgGBoR3Jroe5VCALYcPdgeVoJzAk4kteT4?=
 =?us-ascii?Q?WUMzgwSvt7GGcAEFTSWZy4MQ7sAPEdggHHOrsa7hhKOVOYTvN67F1GhZh7ar?=
 =?us-ascii?Q?bFZfuhKpnT3mxOI+2tfqUKI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab95a799-ea3e-4a96-c233-08d9e749b85c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 19:16:46.5881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkPrPftq3NbEQrhDqREjQzgrnIQs5qSFzjQWX1abCrdQwyzCh+/nwdCBrpBg92R2T5jL0Ah7Txix4Q5YMzMcMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0179
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03 Feb 18:35, Parav Pandit wrote:
>Hi Jakub, Saeed,
>
>> From: Saeed Mahameed <saeedm@nvidia.com>
>> Sent: Thursday, January 20, 2022 6:11 AM
>
>> >And _right_ amount of X bytes specific for sw_steering was not very clear.
>> >Hence the on/off resource knob looked more doable and abtract.
>> >
>> >I do agree you and Saeed that instead of port function param, port function
>> resource is more suitable here even though its bool.
>> >
>>
>> I believe flexibility can be achieved with some FW message? Parav can you
>> investigate ? To be clear here the knob must be specific to sw_steering
>> exposed as memory resource.
>>
>I investigated this further with hw and fw teams.
>The memory resource allocator doesn't understand the resource type for page allocation.
>And even if somehow it is extended, when the pages are freed, they are returned to the common pool cache instead of returning immediately to the driver. We will miss the efficiency gained with the caching and reusing these pages for other functions and for other resource types too.
>This cache efficiency is far more important for speed of resource allocation.
>
>And additionally, it is after all boolean feature to enable/disable a functionality.
>So I suggest, how about we do something like below?
>It is similar to ethtool -k option, but applicable at the HV PF side to enable/disable a feature for the functions.
>
>$ devlink port function feature set ptp/ipsec/tlsoffload on/off
>$ devlink port function feature set device_specific_feature1 on/off
>
>$ devlink port show
>pci/0000:06:00.0/1: type eth netdev eth0 flavour pcivf pfnum 0 vfnum 0
>  function:
>    hw_addr 00:00:00:00:00:00
>    feature:
>      tlsoffload <on/off>
>      ipsec <on/off>
>      ptp <on/off>
>      device_specific_feature1 <on/off>
>

Given the HW limitation of differentiating between memory allocated for
different resources, and after a second though about the fact that most of
ConnectX resources are mapped to ICM memory which is managed by FW,
although it would've been very useful to manager resources this way,
such architecture is very specific to ConnectX and might not suite other
vendors, so explicit API as the above sounds like a better compromise, 
but I would put device_specific_feature(s) into a separate category/list

basically you are looking for:

1) ethtool -k equivalent for devlink
2) ethtool --show-priv-flags equivalent for devlink

I think that's reasonable.

>This enables having well defined features per function and odd device specific feature.
>It also doesn't overload the device on doing accounting pages for boolean functionality.
>Does it look reasonable?
