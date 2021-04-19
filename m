Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F21363DFB
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbhDSIuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 04:50:52 -0400
Received: from mail-eopbgr700067.outbound.protection.outlook.com ([40.107.70.67]:63616
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235963AbhDSIuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 04:50:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1tYOKUc1J9WAbjG/TiBa474a+BPoU39z/Kiz+2HUjn50AdHUViurRt1XIABZ3b03ZYbFAxEVAegOXnaUcOdwcw2DoQu3T/qpRcZxHiiy+qoUDW/Jawxo9O6tDV+EAyQzVyxS2J4t2Fh8NkuqqP0I+iSYZukThoW6C4relhS9qQ9SclFLKdJd7MUZwJIV49+whirUo4h1Q3LEGRMv/e53vyDTdLLanLzyMCDwCRnxHKOIdb37tAw+CZAWK0W5vy6oOkj8V+ekfcS4v7rHKkR0cMXVW7qoV1QGEVFS98dxWMsJ35Lh6vzA6j0v4I9VP9XCiUHM9Te1oI4YiQPC6iYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfxMeeRVZexj+b/hK3dyjbtum4ydqszDm1/02Juc0ro=;
 b=HhxanguLEGKKQ9lKCyVspGuDagjc+mzBswmCBiJ3FmVQlF1CaBV4cM/Lmljt1MX5jEQrVvdEHDuVYFHxJoTJa1arUiwPoAmt1SUIri3FsxJmhIneYCygiTxFSgvrkNFnV+1mPl610wxCyPgm0J468KegHo6AX8i45BhbcERObmZSmMTiJ0n4ZXoVV9eoO+lGehAkRSEDXp5VtVHaKIXSDQxmlJ/0IERIS/ttIPPdjmhxR/ldYNzTbptTYkUFD9wrHVIm2DRydaLk+7p/fZOIpNsQR/B6hbMsXHVBUG7U8r4gz1czyO93qvvTFqWKMVbq7cdxQSvkIaJIckmmG1nALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfxMeeRVZexj+b/hK3dyjbtum4ydqszDm1/02Juc0ro=;
 b=IWzv+bW5g313tSxYnUcz/k+l2exSflWh0FNC7Z4GvfH7uQFTrJZBQrOGckoDQqeuVcraIhn6+GH6VpGxHgZxd/p/g/p7XDqPjBFc5Z3VYvHjh/EvqkS3UIvZwW7c05jrKAayqO9vEUz7IORhvk+iP5zj+BVZ0kwQOYAaDFuEDF2Ak4Wn0BFhhqjenBWPZGI/pqymw+G9cCv9CotYETXZ9wkwoQKCMF1kw4NacwrEy8OoeBSjNQHkhqxr0gkoBCbuUETj/INZElxjgT3Yb/6hw5FYgcJtK+59TH5rYgg8QJB2iOhepqhQ0tMxeIz0ECPNAEbPcM6dyZLAWRqKxwvlJQ==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4652.namprd12.prod.outlook.com (2603:10b6:5:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Mon, 19 Apr
 2021 08:50:20 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393%9]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 08:50:20 +0000
Subject: Re: [PATCH resend net-next 1/2] net: bridge: switchdev: refactor
 br_switchdev_fdb_notify
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210414165256.1837753-1-olteanv@gmail.com>
 <20210414165256.1837753-2-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <470ba0e2-34d3-c225-06dd-77cf546a4ed9@nvidia.com>
Date:   Mon, 19 Apr 2021 11:50:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210414165256.1837753-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0069.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::20) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.215] (213.179.129.39) by ZR0P278CA0069.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 08:50:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6626680-903e-4303-4b66-08d9031029a9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB46521DBCF6B4FCEFACF2D8E0DF499@DM6PR12MB4652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wciX4TCNvBStPWP9IJU3Q9JevzwYZz/Cbr43HAJ35+cSBRm7XlAFZMU9DifCNNyI39sT4t6MPxHSAxUQy5Og95lZrL5svUTWTW198df7wWRCNhSoBbfvvghs//KWJAwtwSDnMenoJt3obJ4gjSR4keWQCcSzwFpKaLMgrbz2mJV2cqSoKQBKrq2nOcv/pGcHDvbwxq6059KK9l40xfX3/8FGq7B5opPOaXL+1d6e/ho/w6YiyQEV1qHFAcJ5OmO/LWcW1NjQOKnDgAVJfzwkGDzE1J3+gEmYZfwMfMaoYbtNuj/ahLcOVBuNf3+BOQxwGXQXA6FEmLbbYQuaso/fwskw+MtEXGlzyHdyxEDW0ewzkxPlg0ddSgZ5o24ie+8Ss0Bhj5YjqGmY1GcM0eqGET30i7FFh2NawbZgbakE4cxjZcfn1axSqWBTrSTPoAxMgju/noO5r11dWNW5lyer68mrLCotZOeojjtAwsWZwLGQ9j1caheou9yLTdt3Sbz/PQIQTtHG+8JfwoCT7fm0qenIL4FcK0wUmMo1aQ0j5pkm7FWfUzNQb6gCt6LyJc3pCAevAL/2FTioDnN/bS27xqf1sWeVQFKREnwUNx/PouCa+TX88mRFjd3F4vn830oDLF79cvbwjOKbbh28o6bFwFY+46xSY93KthhYXFZexAgoYhCezKM7Xx30IpPXEyw6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(16576012)(316002)(66946007)(6486002)(6666004)(36756003)(2616005)(4326008)(956004)(478600001)(66556008)(8936002)(8676002)(31696002)(5660300002)(31686004)(66476007)(26005)(54906003)(2906002)(83380400001)(16526019)(86362001)(110136005)(186003)(38100700002)(53546011)(7416002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVRmYVpnZUdsS0E0dzZhcmN1clduaWRkREJFMzhPNTl3eW5OZFZYQXAxL2s5?=
 =?utf-8?B?MDFOZHdQeXNCUGhwZ0tIOS9ha0h6QW9pRmNuc1JBQlF3ZnBlNmFWTzNXVVND?=
 =?utf-8?B?dUY0dE9FT3BPSE15TC8rSmhweXF2cU9xNW9acUU1VjF6WHp0elVEOWpuNkRa?=
 =?utf-8?B?cGFUVlF6MEtWeXJlK0xjRFg4c2k3RDNucS9WRVpqdVVWZUdhOWhXNnVzVzAr?=
 =?utf-8?B?Q1poTWs5eWFaeEtuODVBK0I2dnJkZFpLRlphUC9mUTBCQ0l2K2Z1UFpOK3lt?=
 =?utf-8?B?VThNUFFYdWREQ05iSFI0aWYzQ2F2dFBDNmxWOWpJZUNnWWVIZW9tZTkra050?=
 =?utf-8?B?cUY0WS9Uay96N1V6VzlRYUVLNWVhZ2ttYkkwaWhXZEFEZXB1bk5DQkJZMVVB?=
 =?utf-8?B?d2hnZjEvRFVRc0lvbW9iR1NBcmsrWTlLRzE3K2dKNkM5M0xaZFVsL2pSdFd6?=
 =?utf-8?B?aGh0N2ovUWwzSm55a2RZN2JqZFpnbzNXa1pSTzFYeWVVMzRYdEc1VE1ZZ3Zv?=
 =?utf-8?B?Wkc4YkNqWGt6Ly9WMmk4TEtqdTJnbStoNGsyT3Bvd1VnT0VGUjZvK05DS2xl?=
 =?utf-8?B?YXJEQVMzTmpnSVNjakhiMXF3RG1YQUltdUtaOTdITlpCUzdRMllJcGJVNVda?=
 =?utf-8?B?NGNpQytQNnZ1Uit0NVF0cUowZTh0WElGbnpNOHZjNFppNnkyeSs2UjZBd1Yz?=
 =?utf-8?B?RGFlSzd6TTQwbHhtMjcwTDFpUWcxVU9ucC9yVTZjb1pIdkIreXozQ2VGdjFZ?=
 =?utf-8?B?Umd2WVFuQ3J6KzN4RldDLzRwV0p3bW9BVU5zNnNKaE82VDRuODlFdDZTYlpw?=
 =?utf-8?B?UGFJTG5KaWE2YmJiRHdkUXpnclFFZElLSmtmM20wL0JJYk9CK1Y2SVZwR3Z1?=
 =?utf-8?B?dXFKV3NnaTdBbFRvbit4VVF5SlN0eWtRdDRHalRqR2Y0WlNUK3NUejNMRVhF?=
 =?utf-8?B?ajYxN1pQUE5jTmJwL01yTklFOGlJNFQ4MEFDWEVEWU55WGlUZW9OQVB1S0RL?=
 =?utf-8?B?N2pQajlpWEhuNVg1M25Mc043OUl1QXh0WVpWTFp1MHlIZVVrRE1CU0RhQ3hQ?=
 =?utf-8?B?SGhrcExGTnVialJyTlAraFBmaXVOeG02akxkdUkrSFRvOEFNbTBVb1Jocm95?=
 =?utf-8?B?TTE4QUJDMndTMWRHdjAyWGR1ZlJJeFRtaFhMYUEzZDNRZUp6blh4UnRTU0lu?=
 =?utf-8?B?RHBsbmQrUHNGNnFDVDhjZHJUS0pvaWNxUkNjOE9CUEpNdFpOeXFWK2FYS1Ez?=
 =?utf-8?B?aDRyS1ZoN0RETjdTMlo5L2xwamtBelVJa3lVR3Mwa1RVb0FDRm45QUFZby9T?=
 =?utf-8?B?aFNJZU02RGFySHFmcHBjS1pFU00wOVVGcXlQaW5tWlVTalUxN2RlWWUybFhM?=
 =?utf-8?B?OTRCOVZnZmZUQXBoc1QvWHB5Z09GSklKZVRMeG9TMU1hWTJVbi91VTlUTmlO?=
 =?utf-8?B?anMyM1dYM2c0cjVXMGIwcFVOQWNBcWx6OE5RVklQN1ZOQnAvNUg0MUY2VzdN?=
 =?utf-8?B?N3pxMVQ4UDlLaDYyaGJWZlRERnR4KzQva0FjMm9DZmxIQytZcGJoRm9Ya3hS?=
 =?utf-8?B?TEIyN2hvM2F6V2tkZG9IVmFmenZJZ2Yxc3lsSW53MTlBSndGbGpUckVWTi9k?=
 =?utf-8?B?OFJ3ZHV6ajdWaHBUd1R2V3NTd0Fod2g5Z202VUM0YjBXa0hTeTlQTmYzUWFr?=
 =?utf-8?B?Vy80VVBVR0RMRVJ0aGpyYjZLbVFZaWNseXpIZU9EWVZzbUl0NlExbENxWHhD?=
 =?utf-8?Q?5X3+F5zYuPNSmGs1gvJyWpYWWhjcPt4J0T09RR5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6626680-903e-4303-4b66-08d9031029a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 08:50:20.4629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vep0dHDuwmPsqOKHJr4ctMfajWWaTHCkfxG4SDLYzMeS/ysmPkt0lu6d88cblrys0HnpcpOjx2rztbiVZAfH0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4652
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2021 19:52, Vladimir Oltean wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com>
> 
> Instead of having to add more and more arguments to
> br_switchdev_fdb_call_notifiers, get rid of it and build the info
> struct directly in br_switchdev_fdb_notify.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_switchdev.c | 41 +++++++++++----------------------------
>  1 file changed, 11 insertions(+), 30 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


