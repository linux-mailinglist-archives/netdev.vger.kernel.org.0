Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110D543DD1E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhJ1ItC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:49:02 -0400
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:58488
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229800AbhJ1ItA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 04:49:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VecJVSpQKlP919iHRzX0mk4ZDk7UnTifnhkRPiDexSBzjaODuNG+bwcv+14PG0bVI59qKMQ5V5CUdxK3rfIu738GzHTlyfjvmqHRdt85bpFBHXTsAfqwMSNZHd+Icc/mrHPouchobGfb2/OK1MkBJ6B+FXZgIPzJsuwmnU/Ey2xwNk3UZ54uCY394K4fRA2EjBaZf3lJ+DpT2oLcO7J6a3/FzT9G/lw82jvOWVxe3TtLdthQpj4ap1nt5PL2L9xCHSpv615eog9JKrVczEisu+ExNQfMijPhOqMVmotVhOzfjGFz9HWMJNpBLs9oGKtRhvZlCGgK1Kt/RwuNWCc5Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLAZxiTA+78CLXOSr711soUJ097nahu3ZKrhwNuOX3c=;
 b=Rgum7pYIpTCWIJ2y4DIogeqJ2ksWBMyE29Wn/7ls7vcTp0G+n965pWtVjxRFkYGL8YukoSLJWSYU1CuWYYpJ8aA4qsKyvS5f99zD0xPCb6v8gSZYYCErT+StGdxxeBc3wK71k5schxch3cum51pl/wbqw787afgzRCxVVhyZqiX2PW3zXdxUv8rhAzT7Dn3UclzsejJPQzF6cPLOBEu5+m7ICiNufOb/V5aMvjF1ytJR934CzO8zbGo4l5SRcfcWET5kOQGUOaARKg8aHl1H5xsiBTDV2RCu76idYNLQCDeSUWokgQdZeU8t8ayRyLm/nNWy7c3ilL1/YwZhGfZ1MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLAZxiTA+78CLXOSr711soUJ097nahu3ZKrhwNuOX3c=;
 b=dWvBw6yfvVS35Gh3NGQ6M1kFRN5nKna8qDP9YYpxAbCPgZtPcJ5NDrYlYx/UlccGFhYmlu740im1JM3mcp1iDUjEuUPmvi3HNC/HwfL7uX6ADmP5XJBpRtAwwx8i3zLyfO/kArg1h/lbOQmWkReeMzbTjuakS1AmF6adOMJWrGx3T+uJKX5wICuB86ZVAEHZkgIouY1vpWTWJG/8KSscVlcR2ITLkjne4ZMBDkD/D+BCrBMKkEAvJMMpD4aOH2CmboXWr4Saj0JBcSisCj36zKNKDUvdgfD74Q2CwUHCEP6CsIPVJ57V0Ph7JqnT8ieprlg+ugIwsl/zd3emMjDzKg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5038.namprd12.prod.outlook.com (2603:10b6:5:389::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 08:46:32 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 08:46:32 +0000
Message-ID: <6c46c469-10e4-be2c-c128-178042aace19@nvidia.com>
Date:   Thu, 28 Oct 2021 11:46:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 2/5] net: bridge: move br_vlan_replay to
 br_switchdev.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-3-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211027162119.2496321-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::10) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 08:46:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1f18dd9-1771-47b7-80f1-08d999ef710e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5038:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50389187E7FDE7E63CB0E9B6DF869@DM4PR12MB5038.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtYSMgYPpjmwieth+bniMCftkLjBcmfFRWO3wM3sx9RD+G0RKcEyYojqIC3Li+W7V1Q/HAfvo8zJnTfZy4pahCTnkX0SyOm3ic7fhZbinkwjdNgrAPzZrHLZ8YIxXHi5cDAf4nPryF4RXWKKU+lfQ9WrWo+jEhmAbA6Os18wz6lc5c9Wy9Cpw0iSc34zMTSz5fH43+1qwh9YIOhiMncvDsA1dHQWErZG1+4GhxV9NDAZtnuglQad33tj8T1gID6DDYO1vml4b2jdwRpmmlSVu2FweLTjc4NOaknv8IU7EbwYCMvJrI4lSrwuwYJjrV0UaK8jjcFQSThUGNDcJMr9zSEpoks6gUKupcgMI0PhzWH8oSYet6LaYdqddW3n4kNalHiJe340EsD/WuW2JeLZ9HW7dVo3FsEGIStVq5KrO772c7wgRCqCT15684ooXCpTnKfDNth4K3fiiWjq1HuUWwvOW7toAztwox+1cNn2pG31mEO3VO4s5fFXqSU74SzQO1a9nVY3yPBpGVaI/ZJ2FerQRGKYOj3PNzWySnVod47dP6v5k79zVdWjLhxp7zSQ/9V0Pi1G8OTZ6OPkAtuOeXjoWcSM6rBJ+1G8jn0t163PgeBDINrrAEXlbH1DfcXSadxNFOxUDSgyTDb5DRTtyDWy+eJheKnHt4j9VeV3C4F4cdx9CMFPD/wzUAqhPg4JvwGkUhn7Z6KtdggNhR7gZR+km3wgZ/PbFlgm4he1oX4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(6666004)(2616005)(5660300002)(8676002)(36756003)(956004)(38100700002)(83380400001)(4326008)(86362001)(31686004)(508600001)(16576012)(66556008)(186003)(2906002)(8936002)(53546011)(6486002)(54906003)(31696002)(316002)(66946007)(26005)(66476007)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEd3SzF5Z2lwcGhEU2RMNGd5bk51Mm9qV21KTVRnM3ZzS2VQZlZuQ25Pa1Nn?=
 =?utf-8?B?MmdQaGtOYVl2SSsyazhTeWxENjNyQlYwS0hlVWdreFllZFdVWkxRbTZLblNW?=
 =?utf-8?B?Y2NqZURkZjNhU2xVTEpRT2VzQlc1eHpBU3JSSUZhbHZ4bTJ1Q1FBWHVUZnho?=
 =?utf-8?B?TnUwUnpnYVd1bng2ZE9NU2hWMXlCOE9XVXFZVFUramV3ZFFWOWpKYTNQTHM3?=
 =?utf-8?B?TVJBV3Z5VGhmY1YvNDlFRUZTaGxKRGIvdThEei9ybWlZTXgwRWwwRzVpOVM2?=
 =?utf-8?B?ZUdYdlBDVm45U2Q2UzdTOWhpbWlOVS9reGkvUU4xUytJcnVYTWZuWHlVMitD?=
 =?utf-8?B?TS92Nisvc1dSZ2FldWMyd2c3RHdIV1c3bVdSVUMzZW5NcUVaQWJGdGlkbVln?=
 =?utf-8?B?OE1hVXQ2V1dCRk1SSnVXWHZUZFdUL1k2dWlCenZBMkZGMWhxT2J4emZEWlhX?=
 =?utf-8?B?ZThINFJBbHN5b1RxVEhHYWd4dUpCMGR4c3N0SGw4L3BlNWFUOGl4NURhYnhR?=
 =?utf-8?B?RTA1SlI2Wm9LUEpmZmlnTkNqYkhSTFVoNVlEb0VsOHR3bnBheDZhejFWMVZK?=
 =?utf-8?B?bUVHbGpjVnJueHo1NFRWc085Kzk1Rm1KbTdJdnZKR08zTFdFempRYlN4cXJC?=
 =?utf-8?B?VFc4dmx3emRNYjhFbnJFMGR3SzZ2UGM4ellVWVlHRU41S0hTUkc0MU5LSHFn?=
 =?utf-8?B?c2pNNzl0UDJuZlpBNml6djZ6dDVrWkxYak4zcTlGZWluWldhZWNJbllsR0pK?=
 =?utf-8?B?bHBHSWpISlozM0RReFowaUltOVJRNkJxWGgxK1phallod0lRdFJWYkhlRDRa?=
 =?utf-8?B?S3NBY2E5M0tuUVZUTzQ4UXZwK1BIeDBsL2dLU3d5R3lCbzJCRXR4bGRYOEVS?=
 =?utf-8?B?VDYrWHQyUC9peTFwSEpHTVlndGpkNk1WUEFWWmIvVkc5K1oxYzA4blY1Yzdy?=
 =?utf-8?B?UlRLeWhCM01hakFWZisyYjdQWVkxQndYT1RnM3FLSTNNUmNDclcvVFQ3N0la?=
 =?utf-8?B?VWhNVzdUbUNOZkMxaGJlTDIzQWZsR3FGOUdXL1dDZW9vKyt6a0x6aG0vM1Nr?=
 =?utf-8?B?OFdFaGpyV2p5TDBHeDZhV3EzVERnM3V0bndQWXUwQ2d3U21BNDNDZ0NOYng1?=
 =?utf-8?B?YWpRSFhKeFZKbjVZN0k1YUVDQVk2dURvTEtZMHdCN3lZYmpSVDkwMVZ1MTZO?=
 =?utf-8?B?ZlFVRi8ra2tGUEZJa3huUE51SVgySVV6dTdiQ2Q3WmlNSUZyeDUvT0pSTVI4?=
 =?utf-8?B?NHh5K2daZS9RRzUrcDUxbXI4aVNqSWxjSjFqUDdWaURmK1dDblVlL2N2TnMy?=
 =?utf-8?B?Wm1kWEJKNWZpcEZwWjM0UThNOVB1dHpxY0Z5MnEzVlJkMDY3MHFYNHZIcm5q?=
 =?utf-8?B?dHNialRldW52Q21hdmFZSjc5T1J4OUlZeURodGlDQm0weDAwdjZpQW9LN0VV?=
 =?utf-8?B?bVl5ZzE4bEZTSkpqZWRHVjdPM2lPOFJDcDlJMWFlSmZ0Q1lDV21LV1BaZm9w?=
 =?utf-8?B?MUVTUUZxeHhpU21RTHpGWldGQjFueFhHd2lMTWhSd0RTMWRLYTM0TUQyVE51?=
 =?utf-8?B?cmJMamc0TUkzRTlLekpZSEpwQlZBaHBRUGRsTUppdHpPR2NLOTZqMWlyVWp4?=
 =?utf-8?B?QXlZRGNDTEcxWE91aDZ3U3lRODYyMHhkMEhOVnUrU1hmUmxJelJNK2svRE85?=
 =?utf-8?B?cC9VNlo0Y0Nvb3ExalFxWUsraDFhT3p4YmZMN3JMWVRIVDJ0a3F6cXZxRlhp?=
 =?utf-8?B?ZUI2bXZNcURXYndlclE0T0E5QUh4dW9vRW83MktTYVNTZGJpWnlacVUvRjZT?=
 =?utf-8?B?YUw4anBMbFlOMWt6QWtvR3BiekRaRFNLQ3kvY0xjQSs2LzVpSE9rYXdnWmQr?=
 =?utf-8?B?Qkk3K2p5MG11eFpYbVMwU3JERHJvNFRPOC9iRjF5RTVMVU9NVlViZnU3YTZ6?=
 =?utf-8?B?Vk5XY0pDMVNGQTgyY2ptaHFPOElDenNyUkdydUE4Z3pRcWNSamVwRitFN2lH?=
 =?utf-8?B?VWNNdHc5OWlTZ0gvUHdyd05mNlRPZUUyZytiNUoyYzVkWVVzY0RnQk1vM3Vx?=
 =?utf-8?B?MGd3S083WUc3UXNFWEVkOVFQcE1lUnJZajBHVzBQN0JUZk95QWNGNE4vZ0x3?=
 =?utf-8?B?YTFPQThsS1JUd01QYTVmMkdNaU1hbS8xcXpEczExcFJkWjlZTHF4UEFTNnNB?=
 =?utf-8?Q?va1qORVEQY0oJus8GGADfd8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f18dd9-1771-47b7-80f1-08d999ef710e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 08:46:32.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ku41cDKBTdBqgsO+D1UTOw8NF5wHeKBUz/XUfpziGIrJLC7CCDVc695TxYQzKLQt75MIWoinoZTy2hFdDPnkHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5038
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 19:21, Vladimir Oltean wrote:
> br_vlan_replay() is relevant only if CONFIG_NET_SWITCHDEV is enabled, so
> move it to br_switchdev.c.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_private.h   | 10 -----
>  net/bridge/br_switchdev.c | 85 +++++++++++++++++++++++++++++++++++++++
>  net/bridge/br_vlan.c      | 84 --------------------------------------
>  3 files changed, 85 insertions(+), 94 deletions(-)

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


