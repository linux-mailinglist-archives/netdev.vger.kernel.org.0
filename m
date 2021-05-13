Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FDC37F6C6
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhEMLcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:32:17 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:36257
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232141AbhEMLcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:32:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4jnESODmpO1JAiQMYpgFOTej6j7wOoNLlhu2qjrEkSY0mFJAhzObwfY29WNquQXBbt5vvX3mhAmWfHne+zZSBB0PKtwAgVfiC9PizcWspOzllHE9jxNkrZAj9Ci/r+sllYB8hcjxbwwD1+PBEx86GDbJvANbSrbma7AYO0cORvJr5A2JNmpCUIS5AgPcw+U1xMYDJuEUlYytxw7J++6wMQ6N5SYnrpMzMH+EPbGjtZLhJEOLYojBMlytspnsIEEfksFjd50nWp8SjXVZ+JYedBI6hW8UcKT+tY7MQiVROtzgV62KwB/rNQ7c6c+gw0oc2Ltpn+/8by5nxV9JuF2jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1rDoHWnKgvnPbBeA9WaG73j2PcaUGzAnfs4PmTE+1Y=;
 b=ZdhzUjsc8E9tp3EbcLtL4NtPSlWDGh2Ulyi0pwFwonXjMjRGtQtishxrqwjnuTVQJ1kZ1B0XZVWUNPSX/oPQPfEkX+A2dAOv77Ox0unpVyAStoNqN50Hd81QF9tYevAgcQijllm7Qmdheekq2l4XhgBRqOqC2AfhJbDFbwNWmJxE3lKB6qIc9we1/JaBI0FYI1hkHQ1VS4+4hFH3NTrVJf6x7MSJ27CZAl6KpT4LidoUhuRU3j4PoQ4YR9C4RfY2iEv1rfZjmIM39D2rAuNh/xwlF3Ye6WynTeO1wK6o2qRuiov7b8M8eWIY8zrr7h/fYR6zD55RalVfqWIOZ7EgQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1rDoHWnKgvnPbBeA9WaG73j2PcaUGzAnfs4PmTE+1Y=;
 b=N0EIRQiLM7QTDKqyIK9zeKAc61K3hmvYSRUfStMQm+LiUDKS8bxou3wgp5os82gWP55RjkR2qF5yEwqGzVPbQvhQZxVAQjj44RYvwZWvr2vOfep4Bdpxwa0zBkWFYkAiBHxcphjlKEXQZO6+fsnmR0TlGA9F37fTS5CL5hyHYY21F8IuwangHddVuIF++Thc0V5+H7/UIPjnS1QdNGG5mSI7iF5On/m+xHqlS9OxXTDcHEMBW28Tgi5oqPggFV9zDgKLD5S50+4MOfML/OCxgxhGduuXHE4ZV2ku/TMpgPTejivCIca8l0bnG66pX8OVIb/zLy+cFWmwC8Bi7uK9/g==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5517.namprd12.prod.outlook.com (2603:10b6:5:1be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 13 May
 2021 11:30:55 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:30:55 +0000
Subject: Re: [net-next v3 04/11] net: bridge: mcast: prepare query reception
 for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-5-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b58cbdb7-a95c-752b-78bc-9ab86d79f8f4@nvidia.com>
Date:   Thu, 13 May 2021 14:30:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-5-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0054.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0054.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 11:30:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6cb15cc-d4bf-4d96-4420-08d916029295
X-MS-TrafficTypeDiagnostic: DM6PR12MB5517:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB55171C31DA45C6C7A68DBAEBDF519@DM6PR12MB5517.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQXhLWBbQka9SWZoj6k7ltUuAjEb+pvUsaf+q3FZzQ/L3W8tU1fmxNtm25BxQyl9XWwEhuPAgShfeEXGZ6gQBoiLk3UNTU5glC487K3BFHpvob8VAeFidNdhhCtU82ZWEBa/qlsn4Fm3TLXgGM6xaBxmKJ1s8wTYVgAq7FSQL8gHV99ddkn25YPa42V/l+8NeA3SQJ+yToiWxdbWj9Bdq+b85n/nswj49jFACyGM+tIMl3J/ODX/6lMUi+mdVOqKkKLpJfvAQ4lVttqE8VO4d4xsykpFij0PvVhSKccKj/eMWNfOBsxK/0nYIRqtvhV0WQv+VJvNmq8IedxxHjZjQLfvmbQgpDJnPNRlaCkiUMgKsziFjSSMEgOvfnQyCNqSHIidx67ScyU2EvyqnkQEJTL3uIitxkZJLTl2v7wDSYraJFJnx6cmvTQFwoHYMa7QP33My4olWdUdSWD1CQFXq3Nh0cRXqIO1GF/SP/CIi20zpjmy/q71eQpWGnq7Awwhqe1fLV1mHRK5MNGom6lrmhXSmy482YpP1JuId8/4xhDhADpcyVj76V5/bGPmFJVhD3IUnkM067X9J/KqAguko3wVzKa/kHT+gj1eS8McPkK/F7KRmuuv9h/EB6VvhRaPwYVMOntt5RWMP4TNm0cxrutO7BOOyNFen8cJT6IbDKV9QMT29IqTdL6NKyfVtrGd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(6486002)(8676002)(54906003)(316002)(16576012)(478600001)(16526019)(186003)(956004)(2616005)(4326008)(2906002)(53546011)(5660300002)(8936002)(31686004)(4744005)(26005)(38100700002)(66574015)(36756003)(31696002)(86362001)(6666004)(66556008)(83380400001)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TzY5ZFBNdkc4V2lqaFF2eGdhMkYwWEl1RzM1MXE0Y2s0VGw0TkhXS2FRcEFj?=
 =?utf-8?B?bzlrVUpaUHQ3T0VEbVNORUlxOWl2VmRudGx4WHBTZHhFUmcrYThZWVhjVTRa?=
 =?utf-8?B?YkR1T1R2a3VkOTR0aGhrSEl1ZDJuQWV6MFp0NU83WXdOTWhJVHlLSDRxcVVO?=
 =?utf-8?B?MDlpU0FLL3p4aWVFTkhqWEdtNjc2bXdZVzd0dUdRaTgzUjU5aEQyOU1LRlBq?=
 =?utf-8?B?azc0SHZBeHN0VDlBUS9lYS9mUVk0QlpFSlplNDZKMzExQVpwM3M1MGsrcnBx?=
 =?utf-8?B?WWwvQjlPWFZNK04wa2FBeFFvTzZiVjNWeUpMSko5SFdCYTNaTHdjU2xZK0J6?=
 =?utf-8?B?bmVwUGNaSXF1TTR6UEtsRDFSK3NLQnFCQXIwamNpY1Y1SUl3Y1BCSmhOcCtG?=
 =?utf-8?B?TmJTKzRhL2JVTHRjK0d6VFRyTnV0VDRWZzcrSG5XVHQ0dTRvMnZkVXFrZkhz?=
 =?utf-8?B?MlFZQ1dkRVRxcjY2NzBjNVhUeFcwbDNUVXRsUjc2QlZheW9NR24rbnNLMVhH?=
 =?utf-8?B?TEsyYkhPQ0Y1VUpzdUZrbWtsLzAzU1NQMEo5QjNjWklDSDVmdEVIT0oxb1lN?=
 =?utf-8?B?cmx1M1Vkc2FWS1J3VHAwZlhRSHpCa3V4TTl5elgxVEdSU2ZHZlNoNlJZQzJH?=
 =?utf-8?B?K2xXZEJCdmtPelBIYkg5WWIzcWttWEFHMk82eW1pUmdPaG4rLzViSytzOERF?=
 =?utf-8?B?clJrMDNnUXdPcHUvVzF2SGV6Vi92QmZmUElIbU1vUG1YMFlrSFlXSnErRExq?=
 =?utf-8?B?WjRyL2FhNDU5MStzczI3cUNER0xEYjBHSGRWQy95dFhIR3dYUnFJQjFBdlo3?=
 =?utf-8?B?MHp6bGt3ejlsUTd1dDNORzI4eUZBdHFPOVdtc0ZSWElQUGR3VWV5d1N4Tzc1?=
 =?utf-8?B?cFRQdU5FZ1hmcEJjOXBkbmhrV25oUk9VL3FlOWlOa09JOEthU0EzK2pBU3Bj?=
 =?utf-8?B?Z1RLUkJtOUQ3MFNIQlpLWm5sUVlyN1FRREZ1dThZVFNCa0NrclkramR3TDlz?=
 =?utf-8?B?ajdkTkFJdGEwWmJkamQ4cDNvZ2lIc0F2cEgxYy9rbWNRcExNbWlmZ1VVbUdz?=
 =?utf-8?B?ZHdYOVZoNk5IOWs0UnB2Y2ErazljRGdhU3l3bjZKTTBtb1VMZzh2QVlUYm10?=
 =?utf-8?B?MnJwNVdrdE5MUm4vc3dLM2VvS093OTdwc2dOU1oyUUxzTEF4K0VDbFBQY1Iy?=
 =?utf-8?B?Y2dhTnlzek5XcWpnS0tCTGViU3FMUWY5NHhIdkh1dW1hMGhwdWFMK3pZWTJO?=
 =?utf-8?B?SFpGZDJodDRYdjlwcm9qNXdzaW5GOUs1elFkR0QvMEtoMnd3WStTaW9HRTMz?=
 =?utf-8?B?SDVNQmhwaWdCMm1BY3h3MCtaMXFpQnRSTzhLTzNzaEN5V2tqeFR3bmFBMDZZ?=
 =?utf-8?B?dEJTK3Y4WnJMN0U0LzhxZlo5NDhNY1d6RldIaGxDUlJ5LzVHVXIyOUlGcEJx?=
 =?utf-8?B?bkdQRkxiQVBadGtCMnhtTWZ5VVd6aTh0dUs4VVBFeUs2M3QwMFZLVTA4QWsy?=
 =?utf-8?B?OTdSTGZYVGhXY1MzemYrUEZNSDZpY0NqRE8vdFNLdnRLRHJuNkFlblJXaEQz?=
 =?utf-8?B?cjlBTUU1WHRMSHVtWHBTc0YwZUY5ODVSSjVnUDZkM3lvTlUzaENRMENYS281?=
 =?utf-8?B?SXZyNGtydkVIYjc2VUtOa29VOWQ3MTlhcmN4Z0gvaUlLTWFQWmNjUkozUjNM?=
 =?utf-8?B?SSt5bUJhanV0eThiallHRnd2em5jeDExd3JhbUNxMHh5QzF1cEpRS0xMUWNY?=
 =?utf-8?Q?oV98I2cboSA6gsqxuO9NtJBLUwVAoqDnmD6ZHaG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cb15cc-d4bf-4d96-4420-08d916029295
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:30:55.5642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNXxlDlJCZSfqQJqksR1mzhXvQ8VZJeHvCi/wSR+WMXvgHz8Y9EYWJKy/4y+oarCpnNffhaqxg28oTvVQb3ooQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5517
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants and as the br_multicast_mark_router() will
> be split for that remove the select querier wrapper and instead add
> ip4 and ip6 variants for br_multicast_query_received().
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_multicast.c | 53 ++++++++++++++++++++-------------------
>  1 file changed, 27 insertions(+), 26 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

