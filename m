Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F21D437BBC
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhJVRT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:19:27 -0400
Received: from mail-vi1eur05on2089.outbound.protection.outlook.com ([40.107.21.89]:34401
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233862AbhJVRT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:19:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSC0YXANCI5mAsbDexwPkHNCt7pelV5jjLruLjOnwbLZjhdU71hJ3X+p+XPPmaBIPvO97XiAXB/BpK2By38GuqPLeA96xYHAkWxrUwmIFm4spR3ZR7O8s9bFjxe85oOR71MeylnImz6GfRtMCBqgSWbYmR111EK82uILxKpVnuiSlMg+a6Uq90nQXqW/NZxKatSSmMbmu8IBaxMBqeSSUo7kdWmrdbuHuSa0ENMoHz4QTwtfTj5/yv0Z9OqKZy2mppu92l1YWzvfm0aLDtZEJmStvsO/QXMMytQ+DPtf4B3ZpFu8YCEi2CmAGlfOinsmCUd0fCObKnFRWuSNTIKbDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=js0ADT2bMlknr698JeTHeIizhGfhLbD/HG/NUD+dcM0=;
 b=XabgH5W9PnDyPp+aD5d6BVOVqk+lmKoaR5wqUPw2EWbZfG7qBHbpRX2VYs0+5ff5tJ7PRDo2p4XYmbbwJ8fwjueHp6fJyLDIQ0JDDE6/yCnmmTYQs9EEoDe3DAUuGdAAwMzXx4gVKbhXX0Ql2Tfmu25tFmqCShdg7aE4itYSLMqaNd5nqGwCZmApMyG2O2W/CCdeB8bkyG45CXCRIuIt2LxM4p5LV7AB4xoICjuhqmdM8ch7DVQOvlrA4qEbbzPjDCxs+1rc7Ff7VnhGlBtVtpVQsOnsb7wnQBLcXnBfPqht4RTAjYYIMfrsnjRVEQimysR9Gv/N8/PBxaVOUNF84w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=js0ADT2bMlknr698JeTHeIizhGfhLbD/HG/NUD+dcM0=;
 b=vZanzm10EygRAn09X7+yym1FigAiw+y1asxoXl65s1YwbR0qjprQQi+LryRikBLDXBMA+Bg1KSLuoQ4k5hY9JdOQ98mo9Xcd+AEUfHu43nsxVO/A067J16fs2pmqSR1T4SSo0DJC81r0RZPmcQg73ZwsS6k0IL9cFuYHLImKhpc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5365.eurprd03.prod.outlook.com (2603:10a6:10:f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Fri, 22 Oct
 2021 17:17:05 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:17:05 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [net-next PATCH v2] net: phylink: Add helpers for c22 registers
 without MDIO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20211022160959.3350916-1-sean.anderson@seco.com>
 <20211022100637.566fcdb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <d3477486-24e7-e6be-7969-08947840923c@seco.com>
Date:   Fri, 22 Oct 2021 13:16:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20211022100637.566fcdb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0025.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::38) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR15CA0025.namprd15.prod.outlook.com (2603:10b6:208:1b4::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:17:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71d60b12-2108-4e6b-fc50-08d9957fc539
X-MS-TrafficTypeDiagnostic: DBBPR03MB5365:
X-Microsoft-Antispam-PRVS: <DBBPR03MB536570D37CD8FDCE45260B8596809@DBBPR03MB5365.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPgO5DHAE4oPRQL14cAUHoZOj5eHWreUh+qFl3r7cg6RvXBgvhKjbKyrocS2C105ey/8CdxuZAiiWinMj2AVaAGBPjdPJq0C+DFbTn57agCSx8xTXcQA5jDl+CCXBvhw8pUqLDH5D9m5zSQMN6KB68WeZq8D+wkh0wxMCz/rmTdiCiNtzLK6/sNUpq60M7XQ11EmMGKDMjDnJsguipnaJI7HYsrXFa137orwhD0EGDNWB8A4pLHKdwxQ98veNQt+a0RMHJAMUHP+CCxhNxbdigkSWgKLE+ROk8ZaAsLYDj21ckKYfUHqkx7TR5MlqGaOAGPOTosAepsRymfdaIwhmIOVdKwn0B/tYwOlizjXxOp8r//aEm3CCzptOuVev1cIpn0b1E/F22JJPSKOnJ9d+A/o1OoPkYoDUPW/ADy59sGLNgetbP5KM2RHTea0PcY5zWjjrC6+qPGhHdgK9DP9Xoq//9d5ZZPxpemqj9J4ojlTJ1nh3ayKT10Hdj59UPe3RKfyAGuYN0tnoz0tomatSw53sklWLNLEj7a46s7se/P4NvKa2BMoj0WdBkH08lfWlXwCAjqukBFIcqwtmjxdM+c+Wmoa6HjKV//4z86OCiv0SVwXA8bHsA17Hb8vrRn9u/fzJFGxZ7Z7108MMow7g5sFJ5Q2CLGu6rq2FCh2pWKt/bL7dOAyYv8ChCwuibdmoiJsGpNgF9icvUyCS39IlC1OmWkwL/9TfZIDGztalr7CrViFkW/7sbauiVqicHa0x2ZuqtrsQFQ1X3tKQAH0Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(956004)(66946007)(66556008)(52116002)(53546011)(508600001)(186003)(66476007)(4744005)(5660300002)(8676002)(6916009)(54906003)(16576012)(6486002)(38350700002)(36756003)(38100700002)(316002)(86362001)(31686004)(44832011)(6666004)(8936002)(4326008)(2906002)(2616005)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnVpZU0vbzFSWno4SzRsOG43cUFjSmYrRWFPRmJtMVRxZmdQWEs5T3V0NFlQ?=
 =?utf-8?B?dmZUYk1ESlpiUnpJZzVrS2VzaGRnU2hhTEVIZXZNTGFYNFlpZGJaYVI0akFp?=
 =?utf-8?B?eEV1S29UejdYeUZ3K2tiSnpYTkgyNGo2bTYwSFJ3VFI3cjhOTGJlRkNMRXJy?=
 =?utf-8?B?QXM3NDM3K0NNUlBZSlArRG9MRkMySVpuMjBGMlpxOGRlUm14MlczcHRZdXNE?=
 =?utf-8?B?cFZXQkFEeG9heHZUMFN0cXliRXE3U0k3Qkp4Y1V4WmRjK2NWN0NPdkJaWUxz?=
 =?utf-8?B?a2R5eU1ERlMvb1lkekx1TmdoTi95cmU4aXpRVTVZb0txNTAxMjJ0MkQ3Yzho?=
 =?utf-8?B?aUNWbkdVZnRDMURBaFlZMWpUWGpvcUhwTnl6RThrYksvNS9QRExnaU9ReVpm?=
 =?utf-8?B?ZmZVV0QwZ2hLUG16c1g1ZmkydVlWOXFkS3M2NzcxdU1WaVhzMlJnU1ZZQjF4?=
 =?utf-8?B?aE9yQzk4Q2dSTXF5QnRFRktsaXQwYzJmNy9vNnAxRzJtUmR0bERBZHArRis5?=
 =?utf-8?B?a2YzeEErbjBjdUtxajFHaTZLK1I2R0dZd29nU1doRFFpdDVrdzZBYktWcDhF?=
 =?utf-8?B?NHYwUGpIUTZzeEhCczQ2dzhTVnU1dERzT1pVdnJTS0VWUGI5bEVWdGhFdnhG?=
 =?utf-8?B?amZ3dUdlcDFpbFBETlg0VS9wL2Z5WTNFSVhPUXV1N1AvRW9DeHJNQm9zUnh1?=
 =?utf-8?B?ZHVkVVVnQ2dKQU1hSkh5LzU5a1ZkTGI0MVdBS2UyNHJWWFlXNjcwK0FBZHBF?=
 =?utf-8?B?ZE9qS2pMN21DV1ZEN3lVdCtYaERDdGUrejd5L2RVYldmeS9RaFRvWkRpTzgr?=
 =?utf-8?B?MjVHaWlaT1h3NUZxcGxscWhNa1Z0STVyV244eFZzYTBUc2lQR2VGRlJaWkpL?=
 =?utf-8?B?OUk3elVEb1d6WjBpOGhSdUE4U3VINWQ4M293NGgxSEVLSVltNnZCZzdMWUNF?=
 =?utf-8?B?MVU4K1JYbW5VbCs4YXpnWDB4SEFnaTB4d3hickFYZGEyUFRxZWs5WkJBaDd1?=
 =?utf-8?B?S29hMEFyckNHSjluTFo4UDZKSHFSNzVxQkNzQ0NuNWQ0Vml5L09pdjV0MmZt?=
 =?utf-8?B?Q2YrNnNMdmprdDcxQmRSVUVZQjF0VHJlN3l6OVAxZGxRVDk5QThVcjd4elpX?=
 =?utf-8?B?anBwejNMd3VmUHZMaTRXM2JKMDE0TTd2TjRRcHdRRmUxSzhiZjVDYzVPcVNy?=
 =?utf-8?B?RFZ2L1hsQ1BoN3NPU0RFUzBwMlN3bmxMRFRDWUlrTHF4V0xEbE9WRE1FVWJu?=
 =?utf-8?B?SGVPQ2dOQytRYWc4WWQvSzZ0ajA3NmM1M2E2bWo1UmlBUjdONlZQc3oyRmFP?=
 =?utf-8?B?bTVuNWswNFRMMmpTTnVjWDV4NklsSnZSMUVlejl0TWx6U0Uzd2JFRHVUSHda?=
 =?utf-8?B?cEs1Y0pqQXBHMWV4RFVyVzJNekxkUityeEVEQ2JYbWRmQ2FleEN3SkpVcis2?=
 =?utf-8?B?Rjh0Tm5kM0F4ZFNNMGN5UHJqTnBHd1lmcHZYSEUvUHo3TzhleTBvVHV6eVdk?=
 =?utf-8?B?WDF5VGI2VHcxM3p4bHc3c1R2T1kzVkhOMW8wWmd3a0ZpOGxMVWZMWkd2aWlR?=
 =?utf-8?B?OEdkVGtLY2ZkSER3OVVTektwdnFCV0xaQml5SGtkQ1ZPQ0JUOGdFcG9pQjNQ?=
 =?utf-8?B?ai95c28wQnJnS3ljVnRzdFo4MDYzNlBWbFZqWEpBejc2NFYxYlNIMGtTMmha?=
 =?utf-8?B?YzNvYXQwSXJsaGhPb3RlSEhEUlEydHovMjZ1Rk5VbW1tZm42bHQyNDBXaFZk?=
 =?utf-8?B?OGwzRHVBNGpxeVVLOGx2bW1vNFB5QUM4VWdCbDlBNDhRZUg3WGFVYmpsZGUy?=
 =?utf-8?B?TWNlNGNmcWR2QkFyaWoxUWFvS0hrU2drY0RDQlhGRDVraVpYaTV2N21yR25p?=
 =?utf-8?B?amVwcUhmWlB2R2prUWdQcUc0WDBRMTB1TzJrYUVRdEpLWmRwN2gwaHVibU4r?=
 =?utf-8?Q?3wLLSsinnICjWhsHwkZLOvy+TVRNZdil?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d60b12-2108-4e6b-fc50-08d9957fc539
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:17:05.3112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5365
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 10/22/21 1:06 PM, Jakub Kicinski wrote:
> On Fri, 22 Oct 2021 12:09:59 -0400 Sean Anderson wrote:
>> This series depends on [2].
>
> You should have just made it part of that series then. Now you'll have
> to repost once the dependency is merged.
>

Err, I should have worded that better. This series does not depend
conceptually on that one, but they modify adjacent lines. Because of
this, I have based the diff for this patch on that series so that if that
series is applied first, then this patch will apply cleanly.

--Sean
