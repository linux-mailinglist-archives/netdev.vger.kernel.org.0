Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D342369186
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 13:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhDWLzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 07:55:44 -0400
Received: from mail-eopbgr760053.outbound.protection.outlook.com ([40.107.76.53]:21984
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230243AbhDWLzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 07:55:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rh8fKdbbWjLPTvcGNHQ2XnWYWSuPpeO0wryd0g7lyhUnnxjqfrjfkVhLMme++MqUHH4acmciHATpf+/+z0oJzfAdKep2v13wCJcylhNCY9j9QLJeZNFJyDeoHJxLLan3GJ4O6mIWtIN6Ljia7ccFGivL+KAXdYAcQSrDlyDrHmlGzTyf3fWgTjJQRR9C1laF0iZInaFwTGNPytHlIW/J1LR+gcAGUBrl22FmF7ElW7g7ekTv9Cs+H2RnrUOsu4+UBxmLkqeaNUYf5oCOMJExKxbviV83QPat5y3kbaCHyc7beJNbBrBBqsjtFPCEeeLGvp1xUsjcht0koY75rdCXyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6+yKfGiyo/+yNpj9yyZY5eGjwULCpsj629ejI/uP4M=;
 b=GboBglvrWsT5ap5KsJYOSgusjuhTiKrNM2w86AY1w0xhQXidpsHpwDs+iuEzP6eqHQMH7IrmgJHIyqL9vpCw8LoUqqLQFgPwmQe39JTL7Oa7fpvcPeguG6oPTX+BZ4z9c3j9lnIXo2Rqlfm3KQBgFbgUBTB27uL+L79iloYIZJ50ok7KBa8fEPAl0swOST+4cHOlOKZe4P+OsWugIDTLKHdQw/rvAkvSn2ZIaT6QnLM3ccGN3k+8j/99jKLCV8t3J7Pci6HQPLy4UnzdNqAaZdW8iTbxwLxpO++J3LH2IJdVH+hl8kJspP/HEbek1j4gbIUzHo0A9wxdAcb5efVTjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6+yKfGiyo/+yNpj9yyZY5eGjwULCpsj629ejI/uP4M=;
 b=cJGxLfHKeiRAJE2UEh9M2lbYj55+rzRmk8D5lyTKKZ9cTad/gieyMtFcr/NHe5uHhKvGYzzuk+Ayp1I60zSZp4jQwDKnQqOcWh5co603pn7xJD99X+QAGmR7zcvLB5z+6raWNGxTdlSX1cmnPO1TOGenFtOqxPlqP1xvfjU8ywwzXH8Vye4s49vp0goevRpYz2l2l2tppE/f/64trY6Nzif68WyRzUnaxvDG9HAhEuDS3xeKP8NuD7ITkk1WZi9F2ujdDWWCTgotWyrY+T/V67wUCTSUgw8ZYt/Kvb/kc9AhARsb/wbtjKEackDqZxtMyE97h9N78eO20xFN1SDgKA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5230.namprd12.prod.outlook.com (2603:10b6:5:399::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 11:55:04 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6%2]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 11:55:04 +0000
Subject: Re: [PATCH iproute2-next] bridge: vlan: dump port only if there are
 any vlans
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, roopa@nvidia.com
References: <20210423115259.3660733-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4b013db4-5b82-00f0-0535-ff57a876a899@nvidia.com>
Date:   Fri, 23 Apr 2021 14:54:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210423115259.3660733-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0160.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::18) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.215] (213.179.129.39) by ZR0P278CA0160.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 11:55:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dcea4f8-b1b4-4a85-4efe-08d9064ea1fe
X-MS-TrafficTypeDiagnostic: DM4PR12MB5230:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB52302CC3E49576DB0910367EDF459@DM4PR12MB5230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKJxsMojlgxPBRSyN/8CQAWlO5chg5F42bSjBbd7F6cGQseXsEcwzXaxjz265y1YLm6uKWdrJBytID/0gk84kGqboJemI9h4b+nk7p1DV+Y+VrkaVbgYbgFg+r5bxcNkQnDfG6AB+Dzf1LY2yzLbJnMFQLJCj+Rn6DPVIzRaFntMTBroxF9oSKV9t9VLiFK8CsyHgVwfW3bmExrkgSLFtKms4OLxsTKZMQuZdN/hx3uZW/HRa2N7nQEnv2iSor5pRW5DeNKgcbeIJoDsPIT6GjD/HNMzORmuohTJY1mKdy3GbMP0XT8DzTMw7JWRmJ/Gm0+YOobzcehPmoPZONc5zRf/CiI+CmmjvLz6dMgJypX0BATf2Dx2V14N8PSrd3aIqCBIWLD04mmO6S/MMbQsuj1xjqesF/JluDsPi3H5Y1QwW/ZuO5b6kntMYOcpNH+8ex6/TTzdIvE771+wQXeddgfaymQumFcCaw6vjaVmzGfpJdaO0cJxbPQMS+DVXsLNNizuU3TmN5cEh1E+mXyVNFxLnbpYPSR8YgxS9F1WhsEnlEPLJ/ZQphwe3xH+IZ0rQGKtzX8KcTvcWff5Nlc/U7+n3piWfjZzbSGrtKcJL8lG014kjHAj79g/coVWZxwz4OVrtJbxQcWwoftpM/Uf5xiyQez/Fp2Ys6bqrJ7/xYE1SZTCfjzCEbDcMAIzon9O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(8936002)(8676002)(53546011)(2906002)(4744005)(38100700002)(6486002)(31686004)(36756003)(31696002)(5660300002)(16576012)(86362001)(186003)(2616005)(478600001)(956004)(316002)(26005)(16526019)(66946007)(66476007)(107886003)(66556008)(6666004)(83380400001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGZoemVHNGtVa2pGSzFIQUFZeHZ0THNSUFdoc0l3VE1yWDFUSnpsRTB1RmpB?=
 =?utf-8?B?RVQyQlNudE41Ym5Jc2U3NmRNSTBleFM5U3FBNTVqaWV1WnlxQUZPY0s2NnhF?=
 =?utf-8?B?aFUrdEllTFJFd2MxSnphNXN2QTVKVGMzZVJlblAzMW10a01zZnNkQlhTMkhZ?=
 =?utf-8?B?d014V053TERENWUxb2VsNURFME5obzRCVHVPbUtoMG1DeVFtUVpERUY4RHlv?=
 =?utf-8?B?WHl5RXkzNGh6SnA4ZFZzNTkySlR0OGdjZWRSRHh5ZHFhakVKV1pIVUZPTTA3?=
 =?utf-8?B?dTFyY0Zhc3dEcDhJQnJrM0FQcHFla0tUbHgyUHVKL08zemZOdWVFMzNnTEdH?=
 =?utf-8?B?MlZmTXJrWUp1cFNwcExyYTZtYmxSVVVFTWVsOGo2UDZZYzJpV29Sd0dmbW1E?=
 =?utf-8?B?ODNURVVFc0pVekZOL1IyOGlabzgrMndUYnk4NWNHVy9Ic0wxbkN0cW1vMENv?=
 =?utf-8?B?RVJLWVdPd2NKLzlEZHlrSHhZbHd6V25qRXB0Qm5KTTAwY2JHcXYxRk00Y0U5?=
 =?utf-8?B?WjNEc0IvQm5sWDBxM0taSWJ6UU5WKzR5WXZCdWtMU05nTGdsRlg2aVhiKzNL?=
 =?utf-8?B?RFI1OEhEbVNvc0dhL3EvRFkzSU9NSWZpZnhxcGlha1pWUit3T1F1V3cwK0NF?=
 =?utf-8?B?Q2p0dnZ5ajFaWkR4dm5Uc2hmcXRybDJ2ZVZqTmFWWkVyVHRQWGdSaEdNU3Na?=
 =?utf-8?B?TUprREtYb3lhWUozcDFyUGgvTmdsMDgwNEhPMXZJMU9lM1J3WWphcFl5YW91?=
 =?utf-8?B?WnlTcXVsbUJiYTdTUU5oeTVPWjNERFdrUHdtbnpJaWhOTkttZmU1Y2JicWtO?=
 =?utf-8?B?VTlZdVFGYkQ5eHV2YlFrck9YVEpyS3BmT0VBdGoyMEdXTGtSdUh1d0MvcnpB?=
 =?utf-8?B?c21LbWFEZGdlS2NhaXRucHNkQUY0MHFxQjd1c0NpMmZkbHhzNFdlOXVITXZr?=
 =?utf-8?B?K3M3bGhHSksvZnY2dEF1VUMxS2pVekJkM2E2RXkyN2dSSmdPVzlxcmk2cEtX?=
 =?utf-8?B?M3VBdVBxVFVWVFh3bG8vazBIbWVmYjVrZlhKbDhpWGdlbDYveFlHbXllZHFE?=
 =?utf-8?B?b2dJdHY0SmRRbjE3NGZ5dFlBMTdhekh2ZHRMbTJhV3NkeGhCSzJQWkl4Y2ta?=
 =?utf-8?B?TmcrSVFGWkZSTjExZHlDaHZFT3FnS3htM29PMVd0d2pRbTVXRUIrb29SL2VD?=
 =?utf-8?B?K2NFQ0lTNzZVSXdKV1c3aHllK05YajJBTDFzdmxwUXllRm0zcURPSklHWGhD?=
 =?utf-8?B?cmUrYStVWmwzcXV4VmtQRTRkaHc5RzlUZE52alRMQ3dXYmViNmVmMjdjVEJr?=
 =?utf-8?B?WkxXMWg1U2Ixa1pwelB1TndaSFgxYkMzS3hIR2hsOUVqNTFTbmVMbmtwbW5J?=
 =?utf-8?B?UEdRMUo5ckpQRnJjZzBNU0MvSWVLU1pVdFlldGpJUnFycWk4eTN0c2g2OERa?=
 =?utf-8?B?bEU1dXFoUXhFdU5hT2hYWXFoV0hzMVlHZktVZGVCem1JRWVLd3lQSTg5akha?=
 =?utf-8?B?M1ZzTSsrKzVqeGhjL0VrblBPYkN3Z2kwZk9mMW10WnRnSDkxUDIvUGlianRH?=
 =?utf-8?B?S2srMGdhWUlGbWVzNVY1TGdzc0xFVUt2VHhOUTZpdU52ZWd5UDdhMWJUd3hl?=
 =?utf-8?B?OGw1dUZEMmxCTVBNSVRqTDc2WHhqWnNnTGovVzFoekljcks1bHlQY21td0ps?=
 =?utf-8?B?ajR3ZkxQZjVOd1ZYbFNLWTc2Ujl4RUpGdVJybHBYUEhQQ1lEVkwyOVNpVWIr?=
 =?utf-8?Q?67Xj25b3Zda29huh1sShsuhuoZrIVqcrbE/WFkM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dcea4f8-b1b4-4a85-4efe-08d9064ea1fe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 11:55:04.6820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flat7xYtWuD8E6q0aZaNQOAai9u8XUO15KjaeAbgqRHV67Un8vu5XspLfwJ2Sz0Mi0EoRjE3gbMH7jHhDWAIAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5230
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/04/2021 14:52, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When I added support for new vlan rtm dumping, I made a mistake in the
> output format when there are no vlans on the port. This patch fixes it by
> not printing ports without vlan entries (similar to current situation).
> 
> Fixes: e5f87c834193 ("bridge: vlan: add support for the new rtm dump call")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
> Targeted at next since the patches were applied there recently.
> 
>  bridge/vlan.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 

Aaargh.. sent the wrong (broken) version of the patch, sorry for the noise.
Self-NAK



