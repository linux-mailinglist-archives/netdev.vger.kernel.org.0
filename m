Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205AA494713
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358611AbiATGDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:03:44 -0500
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:17729
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230385AbiATGDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 01:03:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akFH19IJOZJg4OFeU1b8l7NtHUJPwSH2bgslOcUDNaBqhNXjaUxyGp3aTbPUPcoCWHOFFkHwjQ+PpyX3BRTbYrOhn7ImCoGk8nUUsNcFVPRrMegdWQWBGKr2XW3oeIR+7KzT94HIrhXdJ9MOVH7OP2m7beeTxMUDyfsGleHrAiCE/+UULS5JZi5krum03xviHZeS7DXV9x/FeuF4tBY3cbplju+n1ChQt/Z7dBo84mUApM7Sa7Ak1HBlM4btcaup7NidHIC9p6rDteDn/d9zMXjVvTLI4iCDLNEiRIeJm/ho6UYF4VAXHK2vfYsYJBDrlA4znwYipT6e+5gf4T+DBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noTwU6a9BBVDPvUaD9wKZQ+YJIeGaMfP+eT9RV/NTLs=;
 b=m2ruAARQM5YFK7EwEplXaZQsdftLnUY8VHDKOQntpyu+QRJgZ2fU6vLvI9xw+F5rcwd7hSNl5N3zhiS5qvDqp8ly7X+olBmJosuN/BsPwh5TfQK63szeGs3Lcc+KvlMPKD9PPFDsRcWNQrp6tpMcQPpxYzKbL7DWFCgb+rnHcgenZuu8hGUiI34FbnG/ra0NX+LIY+QrLQjfuVOg8nnfpJngbPSI5NfBdpQIQ4Yq5zgxp2QWELGY2FxgjRnedIpbxHoloro2KKxyNXk2HUCJC0pKJ0nX3mVXTHfdGu7cfWirsPqCAIfYTPLr7eoyO9H77drTNoD9I95k+2l84Q62tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noTwU6a9BBVDPvUaD9wKZQ+YJIeGaMfP+eT9RV/NTLs=;
 b=VfAfeL1RTaNrJn6PnxqqmIwDMuoARiVo6J3zqofYxlmdKZQTjNgL2hWajTi3HqFgQLA5pcqysSOez1vji8nRjC+INphcexliMY2erNiBof+kN6fRLsa7JBvGHJMPYqbGRtuaD4lsXfP5xuu51jT9sWbUuEW1tzqOs9Qua6X0nF++VxBq5x66kaN/kq+U3h7N9kNvCqQLaFsHqREPjwRa4D6lLFlUyfPiWRyekbcIrxX+izUnN3HZuWL7oRvO9lieQTs+dIoYC6GJFP5SkPuXU6jWjXDJzgTVj46DTLcAwhjY4GiAUGfV7W1DOPGzwsVfXVJ/VutMCVt7QUqSN8FeDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 06:03:40 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%6]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 06:03:40 +0000
Date:   Wed, 19 Jan 2022 22:03:38 -0800
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
Message-ID: <20220120060338.itphn5yq4x62nxzk@sx1>
References: <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220120004039.qriwo4vrvizz7qry@sx1>
 <PH0PR12MB5481F2B2B98BF7F76220F03DDC5A9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481F2B2B98BF7F76220F03DDC5A9@PH0PR12MB5481.namprd12.prod.outlook.com>
X-ClientProxiedBy: SJ0PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::11) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85d5bafd-e0b7-4d2a-1683-08d9dbda9aef
X-MS-TrafficTypeDiagnostic: BY5PR12MB4116:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4116BB59C5FF46701CDAFFF0B35A9@BY5PR12MB4116.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RXe49ZGyYS83MaZ9E7Z160u4ASsDleVEGyT88QhxG2+jTK+qlKRETaK4sgTNfVV1bMtwdeBlaQmHfJGAzUoEpVVAAu6hkmjvF1M7ilKgHFG73scTEa6rR9DJIOBNN6YhFBM/qE8SJo6WmNfK8T/wNc74EIvEs51kVz78Un1k0VZR/aJG2si0RVWS24ucdLQFiZfhbfqf8WBbff/HqgN6Hieg3FXG8rVh9h/dwguM4FrqrG4HSm+k9G/h2M2Gknzk7lewcBSLtUqAGqa4I98w4mmb8zPxNc0XufKKo32lONy1h/gNtoJpMcGAOBCBpSJA60gf7K7h2Yn0woTIpx1xXTabveFxPnifgypsh8cOnM6nW5xpOfuVxQ0fM2Irws+Q18O1u8BoyTvjrIFzQQ3C6Jrh+0inrWJib1Urc/vAPwbezFtx+ldDvNeWQapDAWojnLi8Aj6roPatjnmmqK06iOJ4XPFAdyZJzXNkj0HZXlyVbfqavRNoJ0OJzzZmK60y6JYhFMibXF3BP0V+oUCU85+nRZYanyPUxDo5NbFk3x/tGUOACMAvDKBnzr7aSUe9yzqQ8h6IxVXslUlFhElOhaavEo6KNULp66WYhrhqCKrMmHwfHLR5RykkYKBpmEGzrYR0xSVT6/E/aJQxzT9lACXOP+ZCyrbky5XZhWwqwFvz2EaQdfpuucn/mIeliKuXGEGYe6qBAACHA6yhq9zU+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38350700002)(9686003)(38100700002)(186003)(6512007)(26005)(86362001)(52116002)(6636002)(6506007)(66946007)(1076003)(316002)(83380400001)(8676002)(6486002)(107886003)(54906003)(508600001)(8936002)(6862004)(4326008)(5660300002)(66556008)(66476007)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jDKDi3+onubszseshGLFiYeUIjUWq+wd3pb0pnbHOBAx8t4uOqHScH/1nFJU?=
 =?us-ascii?Q?PPjRoxAWnJxS9LOH+iySDy0YwUdutl5NindvXJ0ObCVT9sPcr+Z6QLnnc7Qg?=
 =?us-ascii?Q?gUZl8jMzwlhYNYtozPvLSL9P6tGqL88A2yYu75GwxmqyKeusNwyZXUW4Ezc+?=
 =?us-ascii?Q?7youpk8D9mEmzVTXKpDq/iZUqNtbX1qBdU9FeA/CgZIVcWCVu7Rz9DZyc/z+?=
 =?us-ascii?Q?VLUL/u4ZHdEkYd9YkLJqapowr30TBS81W8BfeU4Vbb2wQCFyS9AW5ONq8kUB?=
 =?us-ascii?Q?QB8/UzOuk9kjiNRu1XiomVgt+J6rGanPcSi3CT8QMKMuR1aEmPnycJQWzxKM?=
 =?us-ascii?Q?AwxQjTNox8/1WJ1usCDsqT0/yfljaXy1VWk+hy3EWUquaWVh1QqcY1lPbbj4?=
 =?us-ascii?Q?jvM+kLi7HgpqNxr2V2IBb0KlviKyOZnfabipUtiPUrsaEiMIH5NlIJfLk/Gc?=
 =?us-ascii?Q?0VMa8kRo0Y2B08mZqOaoMNeIlpR3ZPdRBJlcRxdleoqjHaBcivYvkuol2HEr?=
 =?us-ascii?Q?OtkMvCyZJPPhl4W775cVUz7hcw4IM27GWOslFIBfnCXExJKMziScnagAcICN?=
 =?us-ascii?Q?jxEf4A1H+b3GBO9aJrpKTng8Af61AVJQqv+rTBvl9VMe+7ZKJg9q7CX7wdB/?=
 =?us-ascii?Q?gi8yMANpNBxF2VofsGePY8xIugSoBBRGlq4KfR268bau4pUofQ7aMDjv+yd7?=
 =?us-ascii?Q?KSTosKqaDlJ+HppGgeUNgAnOZJSyOiLDW4O/wPqKNI7iw7YGGE5p2oWHYohd?=
 =?us-ascii?Q?Wh7dCFRpIZ8elgTWrOyLqgPiVcgZF5CNfRT18gl90X/Gy+JXnIEORSuc3jjt?=
 =?us-ascii?Q?of/GNdVv+3bvu6/e+feq5Owc2+B9/Xq5Lt1RcPpyCFUojv8UmOUUJXlKJmGU?=
 =?us-ascii?Q?RDD2b/+Duu7tZnz2yUXd1gaYRQOzUvuUaPtNdwFcIGE5HOh8bOwbGOcpQq4A?=
 =?us-ascii?Q?EFdaS/SHGAa0q32iNkXyBCjvqbhjqRBuFxWztQ7HgRP4t3yzbhqTbPv1i+/3?=
 =?us-ascii?Q?suAaHxsjGjMfWRKX8VkBjv2Hr8aKLdwS/sXEg57S4/1rVkkH1Xv0S/4JVBT+?=
 =?us-ascii?Q?P9ISrDTP6qDoEuEVVt/Kmdzi8HlGiXFFi9xigLTHAUxw/0wBLvaozJMYmjaA?=
 =?us-ascii?Q?tU6GprnUSnEYqHjmpDCS3KU5J6Ug+A8kwqPZMusiW4r9wmavL/0qcdyTHV5e?=
 =?us-ascii?Q?Xm2NvgqKEEGFWF/k/N7o4y81K6dOGSo4CSRUAuNh6GbyKKJj2P+Tvp49Y5MH?=
 =?us-ascii?Q?CJtfPrvnU8Bg1jnEZgHUNDKO7c55CYSsIfkHih10XtehC1qRK04zcVhB9B8/?=
 =?us-ascii?Q?keY752oPy78SAuG3PYARRSEUPtP7HhWpyIqagkTnDEbULrS0sUOyi3+QqaQc?=
 =?us-ascii?Q?kLHiSxu6c7e46Tw7OBZH2zZH26kcVqE6StjK5xQ/NA7r/ip1vNnpa8RyWeRP?=
 =?us-ascii?Q?fpt6smC7oBNWXl9bTUbydF8HYbbjySqkNRW3GsOA+tAOQgrTk+UPa261fU+T?=
 =?us-ascii?Q?FYNYigs0/r3DN/U2cYNUY8tlfLBvO4rT658fAC9EiK3+MmmVnM+FZ3zFY5a+?=
 =?us-ascii?Q?f3shWZB3iAnp56jX+CERWHC26RURwfJqm2msbki39FjW5R3RiB7QGbYZRFfS?=
 =?us-ascii?Q?96tkE49VoLlMpwJlDuJAkeM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d5bafd-e0b7-4d2a-1683-08d9dbda9aef
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 06:03:40.0536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPTa1eguI7JFdL/jp4mg4mSJPaTroWH+FTeIQcuh3e1KSiU6DdXWbwcsaRGgvNWMc5PZ8GOZjjbKkXPKoImDtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20 Jan 04:52, Parav Pandit wrote:
>
>> From: Saeed Mahameed <saeedm@nvidia.com>
>> Sent: Thursday, January 20, 2022 6:11 AM
>
>[..]
>> >
>> >I do agree you and Saeed that instead of port function param, port function
>> resource is more suitable here even though its bool.
>> >
>>
>> I believe flexibility can be achieved with some FW message? Parav can you
>> investigate ? To be clear here the knob must be specific to sw_steering
>> exposed as memory resource.
>>
>Sure.
>I currently think of user interface something like below,
>I will get back with more plumbing of netlink and enum/string.
>
># to enable
>devlink port function resource set pci/0000:03:00.0/port_index device_memory/sw_steering 1
>

this looks like an abuse of the interface, I literally meant to control the
amount of ICM pages dedicated for SW steering per function, this requires
some FW support, but i think this is the correct direction.

># to disable
>devlink port function resource set pci/0000:03:00.0/port_index device_memory/sw_steering 0 (current default)
>
>Thanks Jakub, Saeed for the inputs and direction.
