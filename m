Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B0043D1AA
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbhJ0Tax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:30:53 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:10691
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240789AbhJ0Tap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:30:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RH/8ttk0yI+MCJqDW4ybYriqsx+DcWNUlBvUU/VTbmNtPqMYqyAVeGTIW4aABeDaS8jaXTwkbUyYNJQwrajoWYGSsumv0rjtCf3mSGRIkZTZR7EcSIMjp4XgcCeJyYJiIWygvIuWLIGrIXsruvTEi0noIQEeC5hQoWKgjOIq7eBu/gS9F0WCphrny09Qeh6cghZmvN+FIv78y8/YQDHNsIo7CKP3occOlXJCNm1hLxUJpaxrXBVmaR7H0tmPi/21uM0ACuN0hvpz0//ly8pG4D8iBNxmZO0DQnpWDjO9oFbbMBa3+Cnldw1s1uhBVt+5cJRdO2XEEeMab4nm7yW1Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04D5lrLrINFflYbV6sZxIECyN+dxg1+0VftBgZuKoBo=;
 b=eF1T0ErPmRse2Jo6gW1cZzxSOHpSUResqucwK80RbWw5af1m7n/ozbeXfdGwKdCjGa7TDXBmLQlv7G+TiqeDyn6HKGzBLK1FjAe2lXRgzi92bOA0YNxrNmL3nnkyG4VKN+CKo9tCmFRqm7da50464srqtWDBcFMEUbcYFOBDaZ85oOosi4mVCAqe6eEUdyWzGgToqeqC7m0WDFgMKb6fON7HhX0wXnvuEjus1Kx8Zdn/LH/gkRL7mPHPql6b3Oj6wr8AdLAH1pSAf8P4FFBa+2+t0VpQLpvChUVBubnzNVZp6XjQk/RlMgqV45SBT/Z0vXWJUdVijBd7DBX1O71hgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04D5lrLrINFflYbV6sZxIECyN+dxg1+0VftBgZuKoBo=;
 b=XpvHEPVlFEmcaCvSKWUfy87y6lCmpHvlwNBjf/bq4oXuqD2CIph88oDUCjvO4lR0sx1+5j2Gs71XVjN3sX/b598tPEukypXsSz0qGE6CIvjTdQEtN8aQUL+tmZ6IeNDAd7QI4/wnfl7Y3SMmsI0OY8MNDSxyM1VmFJbdtPAd5rYFZFl2UKV7qGiLNXfIfKetGxPjVqAitc+P2ETtANdyZsLlgjoYjXRm/RdT6LG8crYDASr3pFa2MnJoFoplkWrm7bMJwQxFTR0iw02CtEcVh3WxiQ2yC84DqJsYTv0wuXUyFTbZBqoNyNJeJm+w8etoJSweg+HsOWsAvF6QyGzxKg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5054.namprd12.prod.outlook.com (2603:10b6:5:389::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 19:28:19 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 19:28:19 +0000
Message-ID: <a8d9df33-408b-a2a0-2e77-754200ff7840@nvidia.com>
Date:   Wed, 27 Oct 2021 22:28:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 1/5] net: bridge: provide shim definition for
 br_vlan_flags
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-2-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211027162119.2496321-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0155.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::16) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0155.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Wed, 27 Oct 2021 19:28:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7f10219-dd8c-4412-8c90-08d9997fee32
X-MS-TrafficTypeDiagnostic: DM4PR12MB5054:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5054263C045AE946C8040346DF859@DM4PR12MB5054.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SC8EZdQXyutU0VnWK3LbyhH8YU0wJJ3ZrVsEM2bE1CX05tX10FylfFyi5izk/PiIXvs214BvPwp3Lxb+IntDozI6yCRCNDjrctqi8eRHMAaaPN+bbZghbPqn3idWhlOFZliFekms2fNm4kCvrJb3VG5OC6JKEPDC/37F0FdQKqOkX7odm3MfT20TjjXyUlttNYsC7aPhKikI/yCKi29Lr5ME4w0BcXfXfIqYzMiL4KgCMmKKvd/RSMynSq5qGIWzCli6UxIJKYvl9PO8QCpQ2gbs+XLNUPABFfSs1r8uED4qTQt5lzgP3kmg1bakn1vY5F1h9KNRwLBH7MX/+oga3mvewioFMBnoBbMVVoJbr63RXwINM/LKZKo22/+pFD7tXT5et+UWj5gFz/5LI3NvDYgYy5dzN+NjUQ/uBjY1D0/s1G9U/+TFeqXKOhqWf5eg3NOkrd2quw0t87gLz0GQaogId6AvETg1md2mQBPcZB89n9RsOK8pmicey5LYFtVZI5N1T85cH2Rau6qwtgr+a3s1ax931lS3K5GRxeYX0bJJuQTqeEz7n/MLSVvXRjEFdnUlIRKUpUqIAF11FuUq4b70jS/qwQ8HTzAFs9QCFcBx8rc2JRstiuK/00JxUYValpNHVOYQ4AeFAdB2/lPReppEtSQOZdEfBzFCBTma82TLQMDc0KpxGUZmN/DE/xwflCdalWEJN96lxOSMHxkey419gFszH4YKN7JqlX4ToBc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(26005)(2906002)(38100700002)(186003)(6486002)(2616005)(31696002)(956004)(5660300002)(316002)(66946007)(36756003)(8676002)(66556008)(54906003)(86362001)(53546011)(508600001)(107886003)(31686004)(16576012)(83380400001)(8936002)(6666004)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2dTbnJMd0ZkTlF0TnBiOEovYnVTN2dxaUo2SjF6OGlpN1MwVkZOWG81NEtL?=
 =?utf-8?B?azEyYXdrWCtXQ1MxWUVBM1I1TEhqS2E1cXZJdksyclRtTFBXL0VsZHpVMnJB?=
 =?utf-8?B?alNqRlM0V0w2VUlJTE04Y25qY20rSzdpaWZGbjRaa2hwYUc4NzhsYzd5TnlS?=
 =?utf-8?B?dytzZ0ZkQStRc0g3SXhWbnlqeE03RzdnTzc2L08xVmpPSmtTV2N4Q1JkbFgr?=
 =?utf-8?B?TWRIWDJNWHlzdi9yUXpwQXVuUkFBSlJhM05ESkh0Ukd1bWF6N2tkNEVFR3Fv?=
 =?utf-8?B?WVFpSmVRak54bHFDSjN0cUMxSnIzaEJQenpBVzVxckpDTkZiVkp3WTZCZjRn?=
 =?utf-8?B?eHNRZmZKQUxmTHZCb1hvL1pPL2ttbVI3VWkyOHprYmZHS0d4bTluNk5Vejgw?=
 =?utf-8?B?dkdGN21UT0g0WnBZVW1CU2NVUkFXenNwRDR4RnJWL012ZUZ3a2hPdXZGZUMr?=
 =?utf-8?B?aFNaMjcrWjZoRkI5ZXNqNHNxdHpBMzZRZ0h6eWp6aEZObDh2QW9WZGgySWd6?=
 =?utf-8?B?WUREL0pqRkkrcWR2c3RXR3pXNSs5YnY4Z21oVVhvaHkrTnlDU0g1cnRnRFR5?=
 =?utf-8?B?bk1iQ0E5N28zb0tXdERnS1JyRksxOXVOU25DM3JmckFrMm9DbzBVNk5FcnN2?=
 =?utf-8?B?UmU1OTU5VzhsM1UxdkxrNmQ3V1YwSjlvVWVabTJyZi9VTU9WcVdCYWRwR2RP?=
 =?utf-8?B?NDEwRmpDTzUyVjlRT0VTTE11ZUI0SVZWZFdGcS9xbWJkT3dSalRpeUJBb0t6?=
 =?utf-8?B?SDMxZUQrWThlOUN3VXNFaFpuZXQ4bS9PdXV0NTVSQWxESVY1Sk13eW1rQzlT?=
 =?utf-8?B?dFZTOStKZk91V21SQ2RxWloyUDIzcEU5M0Z6TVdUYlA1NVVsT2tIeXpKU0ZL?=
 =?utf-8?B?dWxEQW1rRXY0UytBWkpiQXIyaHl6MjNhRmIxaFhvSTIxUjk0MUJwczFKL2s1?=
 =?utf-8?B?M1M3OVVNdUlDN0JVM3d5a3ZnN3B2eDk5T2pMeUdaV2tlak1FbEk5TkxrREtw?=
 =?utf-8?B?SzFmMUpUMVpMODY5L01qWVdZVlVody9BSFIvR21rMlZsZDdVc29JcDVNTDJu?=
 =?utf-8?B?MGpIb0NEOThpSWV1WlFpeE53eUZtUFFiM2hDYk5GM0dPMU4zdTdabnRuTjZs?=
 =?utf-8?B?SWdDYW9SLzNORWpDOERoLytDdzN2a0tZYytEdDUvTXVMVVYyTXVwa0wrVlVx?=
 =?utf-8?B?cWdkZDZ6YUIzYisvZWdleHN1Nm5VdnFCY2tZNEFJODNhNm52SmUvdlJ4VFVn?=
 =?utf-8?B?SVhjM2VBa0FaSVFzVkI4WDJQaW13MS9rb0R0R3ljWkU4aW90Rm1HcHdQem1n?=
 =?utf-8?B?dC8vbFArd0xCYkpPRWdDcGMxcWkzM2lvK0tYQTBkQmZhakwram5TOW1WblBr?=
 =?utf-8?B?NmRQTVBUM0JlV0F6SXhaS2xzRm15RS94VjB6aHZlYzVKQ0RiQWRxbnBxZ0RK?=
 =?utf-8?B?cFFINzFEQ1ozTmF5Q1BxRVppMDlvOHZvWWdVMjFTSmRUbmZhUG5GeWU4dkJp?=
 =?utf-8?B?YmxaWWw5SVVxKzJRNTR5bkh2OWluL1dBQnhuVlZ3UlpJNFIwRzIydXNZK2Vh?=
 =?utf-8?B?OFg5QmFxQURQblN0QVM5Y3MwbUo1YXh3c0lRQzRZb1ZTZWVNUi9RZmFCaVc1?=
 =?utf-8?B?WmtNQXc4NU9raHlBcWxIV0x0cUVsTFlLbEpMc3R1czQrRmtTbFlvanRIZ1or?=
 =?utf-8?B?VVVENGE4T3lvV1U1dm5paU1SQW1ZRTJ1SC92dFAzMGdYV0VYRTJwTmE1SW9X?=
 =?utf-8?B?R1pyUkEzWENUVFhtR1FJem51b0ViZzNvakpiOGJEMDlzeGIyYVpqb3hkR1lK?=
 =?utf-8?B?V2YrT04wbkN6WTFoRmJWdFB4ZHdYSUdGKzNvMHRFV0k2OXdVM1JGdFFBMzZi?=
 =?utf-8?B?Z29jYU1LMFdrUnY4K2tNaE03UHNNS2g5OUxJZWhoRmhUMTROeE14bUdLaHZD?=
 =?utf-8?B?N2Rhb2pNVWIyakFxZjdneUFhTFFiWCttWkFneXNyTGNaYlV6UzU3VmpoQ3pS?=
 =?utf-8?B?RWQvQ0R1bjBwL0l4eE5oTENKRUlVS0NpTjRyTUg0UnFwcHAwYThOSDhubytD?=
 =?utf-8?B?UXlhc1IzK09NN2s0eU5CZ2UraUpCdzdIQXoxSkY1YVZTeGxiZ1pzTzJHMisw?=
 =?utf-8?B?T0ZSUUlDdDQxSjhpYy9ySmRyNnVDcXNvRWdqNUEwUnlySFg4VVZvQ244em9M?=
 =?utf-8?Q?7uecYOTdmGomljOTThcYM98=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f10219-dd8c-4412-8c90-08d9997fee32
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 19:28:18.8978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjMuO/mKxdyU5uvnRzoUmzrOsDJijg23+dBGN7EuWLyTZNrWdGPbQA2v7VRjVM1CtWqzXC/DoF7pT5d2L9Gyrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 19:21, Vladimir Oltean wrote:
> br_vlan_replay() needs this, and we're preparing to move it to
> br_switchdev.c, which will be compiled regardless of whether or not
> CONFIG_BRIDGE_VLAN_FILTERING is enabled.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_private.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 3c9327628060..cc31c3fe1e02 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1708,6 +1708,11 @@ static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
>  	return true;
>  }
>  
> +static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
> +{
> +	return 0;
> +}
> +
>  static inline int br_vlan_replay(struct net_device *br_dev,
>  				 struct net_device *dev, const void *ctx,
>  				 bool adding, struct notifier_block *nb,
> 

hm, shouldn't the vlan replay be a shim if bridge vlans are not defined?
I.e. shouldn't this rather be turned into br_vlan_replay's shim?

TBH, I haven't looked into the details just wonder why we would compile all that vlan
code if bridge vlan filtering is not enabled.

Thanks,
 Nik


