Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6C262F12A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241928AbiKRJ2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241925AbiKRJ2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:28:48 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91891FCC7;
        Fri, 18 Nov 2022 01:28:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGsCdJKK6AXqDZ0eTs4h86+4qZw7wHl9tV3vcU5RypzYoaMkRvHq4NWeUAkKc/5vI0Ye+yDS9Xmz6Cc4fmO+YiYqEvI/oONNoFbdTqjcR2w/dud64LWtfNRQMj8cJe0yRupfGyWeppb3+Di0jbaB2VzLvNl0rrwpZlMTE9N1yNdCdUON4aTSVy9xNu/7nfCMHfje5wAdMTQSHkYgu2y/ASO/YSH07bFOrSsbbkWwcuWZ6bZwGpehpIhodM+23Xu/Zg5Qg+CyT7i3fQGADnD55An64cVeH7IMy2UqdKi3cHmbk/bGDJzbcG/T8s8o7w9BWmbREbfd3euLIAx5kcX+jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xB0dEt6GeKS1EUI//Rqqg89O+YxpBjYqruLsJa/cCgE=;
 b=OpVI2bwbNeLvgyX1PnC5OYeq+OklDJ96KL5zu1ivFf8EPAwmgp2umOCDzgninwZM4LK0vh+Tv8OqLu/3g+BtC77BbVkgD6OieQDGq53Vs6fPsagBc4/8rkHnzPS9DDl7dk0qZTA620NqGUyJ41qv8LPm6vgCYupUwVeqKO4WjYLP4FVEiUy+CTieOz74ez28flCUjUH3beeDlBvH1A1SSlWgcDmmLd29c16BJH7nhzzOfVKHjX3nPLE13tBhxQ4dlAObIv+OQwvXc72RmrtzFHHWOyv2gIk4CgHXYOS0F5Z9jkffczK7Xj2vkqprTTgVQB8T7rmDS5K3bLXFsd5Ujw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xB0dEt6GeKS1EUI//Rqqg89O+YxpBjYqruLsJa/cCgE=;
 b=T9LqTUBnzZTDtDidg4MN+/atwOAg2lE1NSt8rCcWuLrNZpp7BCCXLQ+j8S9jMeQGYJPFkpij+KrIHeuZTNLD9/pODJ8vF2VT59RTtz8rBrX0Y592cuplh6kQSQUJQTJOkrL8+LcklkQBVZhFtpTU54c0OQU3U27mNMdrbPqnFJwSkmoFwMxzMCUCIt6D0STNtUMDfT2Xsx6LojhnuK0kBdfplPpBq/4B051gN+71iXePTsezat3bnR3rjoB2t3fMlNTZfofh+IEvaf0vbkIJinPvNau/pq5NMS6EYmtrMXcJYn4sF6/iXsCgXgvIhkexyY+EOfFCf0WeXUyqU2/7pA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH8PR12MB6914.namprd12.prod.outlook.com (2603:10b6:510:1cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Fri, 18 Nov
 2022 09:28:46 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::8edd:6269:6f31:779e]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::8edd:6269:6f31:779e%5]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 09:28:45 +0000
Message-ID: <662fd424-7f9a-eba1-a223-902e8e463021@nvidia.com>
Date:   Fri, 18 Nov 2022 09:28:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] net: stmmac: tegra: Add MGBE support
Content-Language: en-US
To:     Revanth Kumar Uppala <ruppala@nvidia.com>, f.fainelli@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-tegra@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org, olteanv@gmail.com,
        pabeni@redhat.com, thierry.reding@gmail.com, vbhadram@nvidia.com,
        Thierry Reding <treding@nvidia.com>
References: <20221118075744.49442-1-ruppala@nvidia.com>
 <20221118075744.49442-2-ruppala@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221118075744.49442-2-ruppala@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0085.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::18) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH8PR12MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ee4854-07b3-4b1e-5b0b-08dac9474a7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/oK9FfS2poIk7uSu3Hm0xPjBM0I3tWppuCWw8Wv/++cYyU6o7Bjh1vk3LLhDrNKYvUXnTJWysp//F9lLqm2F1FrHCpD0WUZHREk5D1sgWPnQOXmnEgb5rMD2A1lI8FWh/tcD9R9V0F6XgH5/NFpHpyKJ4Lt5bA5Bv0DnJ3BNTsnkf1IRQu/WgITWqLUwWzFQ03sTBm8AmmDWznC0HVkE6XbjRDpidNDZLMFSFT0A9nvY0WnqwsonbGNPVDxVAK7mLYscgKGvpPQlzB6KVS7l73YmO2lXhGup/1LSIUZFnUFxh+NSlMnlbVXizHnF4hzX+AKP97NA/KWeU0cHsLvfXHpQaPH/3x3BAwOAycjTYm3mXofE2XzGlaSWqznavy0vd3IdS2b/+W06UAf4Ck4WWN9JiQ2PmY8QFNKISSuHeS05SZh09HoRY1njhBl4XSqY9pllBdJwD6HAHIda5QsNrWcHjytygUDDKUP43TBbsYyJw23uGO7OkOqZJBwltbMnT8u9SjlzCpFk+ZMnymwrWcsGXAEET6rUKOz6qN/V3to9Zn8ThHcm3FjneuuWhjD5c6UiBM9nbQz/dTaFR28dZ9lXKqkl2uZtzbiFRYBsnZGNfNZm8jtq0hT3DgMEsQuPZc7eYM0q2jmFYIDmJ42lkGYgdiQyqH3Km//6cPt9R0m7AODj3/Dop6FNFIkwL5Ezq+d/oYVt2TjGoQWFQ+GcIiaLA7LxmAehswkiCPceV0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199015)(31686004)(478600001)(53546011)(6666004)(6506007)(6512007)(107886003)(2616005)(31696002)(83380400001)(38100700002)(316002)(66476007)(4326008)(66556008)(41300700001)(66946007)(186003)(6486002)(8676002)(8936002)(5660300002)(2906002)(4744005)(7416002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlJ1M1U1K3lqNmFOdFVjVXRrd1M1UGdkcnlQS2t4QityNmpzYTNZbUxiTHhE?=
 =?utf-8?B?Z0RwbjlqdjBkS1dBQ25BTFp3c0EzNVBramJPNnppNjc3WjJvRVlKM0xFQ2Y1?=
 =?utf-8?B?WVNvdmVNQm1LRkNtc0xsaGFmbDRzekY2QnZ4NVQ1aW9XM1BoTUFyQU9mNVoz?=
 =?utf-8?B?eklNZXhWdUxaNnhEcVJ2M01IOUpGOGRCejFRVVhkVHVTTURDV2lhZjFuNG1h?=
 =?utf-8?B?WGtSclgyUGhwWnlaYnpGcHNWZ0NjSXhRWlB0U2Y2Z1pNR25OeUl5ZkVTay93?=
 =?utf-8?B?Z29Wa3MwczFBSXNhQ1hmQ25EeDRrMS94TjF5YWtMMGtDTENQdlYrejJEL25G?=
 =?utf-8?B?ZEZrOUVXbkdxcDUxb01wbGYrVEdSMjFwTTE2TVRKelNWMHA0NHFxZ2FLWVcz?=
 =?utf-8?B?R01kSy9TbjdEZG55U21PN01CdnZMNVZOQ3MrQkluUDB0WTJHY2tzaHQ1bi9t?=
 =?utf-8?B?WjAzVXJoZWlCOVVNbHdDa1Y0Z0d3N0RmeGpraThHVURESUhVR3MvRnJBa0NG?=
 =?utf-8?B?RjFBYno5RUJhc0NzU0JjUm1VdnpvM1BjZ2JpMlpBMzA1aXZ5U1FPcytqaGVs?=
 =?utf-8?B?YTgzMC9BVGF0QmJhTUptNXczRWZlRkR4WXlIVjBXMVN1VGxOeVhiM1VNVCtm?=
 =?utf-8?B?b2FHUW9wT3J4M0dNdllCTm9rK3oxNGIvMGl3MHI1N3RqdlBtWXdlNWI0c0xl?=
 =?utf-8?B?bVRlWmFyc3habDAyQ1l1Q0l5TmJoQnpUeXBzYU9XZWRCQkY0WjdqZFhMMVhS?=
 =?utf-8?B?c0JDNXVMMWZvcndJY3l6VTFNM0JSVmUvQkUvVk14MWppUHk0elg1Y1VRTEp6?=
 =?utf-8?B?M21JWXhieWRJR2FOQnJFOFBDSjViT0g5ek96WFZRdWdaaFkzMzRVV2VHaEow?=
 =?utf-8?B?TEtSamQzeWF6Q1hPRzBzWnJOKytiUEV3cUNRelVsdDQvUzU4S3NieHRWSUg1?=
 =?utf-8?B?cnJ5c1g0c09oSkFZclRSdStscFpZN3FnalBOd2U2am90OWRycVRNNnFIZmhI?=
 =?utf-8?B?TDZiTHI5YWRIWksxajB5Z1BWdExKaGdWQTN2NlRPSXBWb2doNWEvVHluTmRO?=
 =?utf-8?B?U2taNFFvMjhoQW5KdkM4ZG0wTXBScWpWenBDaEZDL1BXUkRoeU80WW4yS0Fk?=
 =?utf-8?B?ZVdHYU94czllaHN5OHFrUDZUUGZKYkZka05HRmN2SEhjdGkvWDk3cmFOVnBU?=
 =?utf-8?B?amFmWU5wb0M0VzJlWi9CeTZaSDFTSktLbWU2U0p4dDlIbklGbElMRVk2Mi9U?=
 =?utf-8?B?aWY1d0M3b1h3ZVlqWWdCaks5eHppNzNaTlpLeHdXb3ptSHZZR2ppTnVPejhx?=
 =?utf-8?B?RFUvOEJqYUgwVU1wUmdFemlEbGZEd0dmOHk5NUJvTEFnLzZSTWtWcU5SZ290?=
 =?utf-8?B?d2JvanI0R3p3YWl4R2o4MFZzVGdZQTRmQTBxT2RlK3BmeVh1ZWhHcTdEcHR6?=
 =?utf-8?B?aFBiRkE2dE5FVkhPa2lzNkREcWlIRDllSmlaaGEwWldwMjZ6RzRwbDN0SEQ2?=
 =?utf-8?B?TkJmWEx3ZjNDVy9KL1M1RFQ4SjdsYlB3TXlFMEczYjFXWkxHTVExTkowNDQw?=
 =?utf-8?B?WGpMenI5VUxXV3B6QUdGSGV1RlV5M0RMQk83U0NNM0psZUl0Vll2b0ZmenhC?=
 =?utf-8?B?emkwdnJ3WUJiUXFuNXZOMXFrUXcxeUlPUTVGY0NQUnBsWllXellwc3ZlSUFY?=
 =?utf-8?B?UjEvcWFZR05aRGk3T2FrUWxqUi83VTlNOHBTWGpSQVh2ejVrS2lQbUR0THc3?=
 =?utf-8?B?NWJlWmVKemszb2FjNnZmVEJCYURHenVEQUd2SnJQL2xpNDR0anQxT2h1WWlS?=
 =?utf-8?B?UEJGT0tVc2Q1Q1VKRHVLWkpvMnBUdG5pY3U5ZnFoZ1J1K2pYdkxMV0lQY1Bv?=
 =?utf-8?B?bjNINXNycnhDai9BM0VGMlRrV2M2b1BWZklUZ3kzYVJJaGRvd2xBOWtNRENl?=
 =?utf-8?B?L2hZOUp5TXk5S2o3NHVBUUJGYzV2Ui9EQnZOVmNQTXU3a01MbXpxZWJuZ0tV?=
 =?utf-8?B?UWV5M0o4dGNTTlNFSHR5djdOSkhWemhkN3hjL290VFY4cmRsYW9ZWHJBUXRS?=
 =?utf-8?B?TExqM1VBRzBkRzQ0cTAyalZCQlpxQ1MxN3BMdjMxRzJsR2pOS1dNZnZJbFZ2?=
 =?utf-8?B?SWMvVy91Z2xzemZOYjhGak5RN25WdWJ1Q0toQnp0OEl1S0k2dUtKdHFMR1Vy?=
 =?utf-8?B?TkhwbTdqVUxibEdJa0ZuTU5rS1hhYlVpS01VaC9vd1o2Y0pmbitZMVcwME5h?=
 =?utf-8?B?akEvOXh4K2UvdGlKWTF4eGxFTWtnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ee4854-07b3-4b1e-5b0b-08dac9474a7b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 09:28:45.8461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8sa+keO5vdRzqZWFBA6BtrQW9+swqk0yRAZ43lO+GoPniUKan59ICTaWtUSnTSKMoTM3pycTRdkn4L++aY1vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6914
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/11/2022 07:57, Revanth Kumar Uppala wrote:
> From: Bhadram Varka <vbhadram@nvidia.com>
> 
> Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
> NVIDIA Tegra234 SoCs.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> Co-developed-by: Revanth Kumar Uppala <ruppala@nvidia.com>
> Signed-off-by: Revanth Kumar Uppala <ruppala@nvidia.com>
> ---

This should have been marked as 'V5'. If we need to resend please let us 
know. We are also missing what has been changed since the last version. 
I know that in this version the following changes were made:

1. Reduce time spent polling for the RX link to be ready
2. Propagate the errors when bringing up the link fails.
3. Added suspend/resume support
4. Ensure clocks are disabled again on probe/resume failure

Otherwise ...

Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks
Jon

-- 
nvpublic
