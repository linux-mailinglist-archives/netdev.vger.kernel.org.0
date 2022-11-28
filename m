Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5C663B4C7
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiK1W0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiK1W0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:26:01 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AFD2FC00
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:26:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFUnqNKo9iTcnPf296Om8p1A7Nt/EVaODqeXO9kLL9zgRonq5Y4uWYvb2Sc9w4+ekr8slNPCeFxsf6oE7YMb+Ch7TYmEHGQ3hQVQ4k4K1+JlphnSo5or6BIFqgu5EmWS/MPNjmNvFihhX7Ydg/w5sK56woecxE7SxsRtdk+cflBbADQLX6w3ogq1haKGA3PoHNPJZ0qW1Dwgg3gQAG8EgkntspwfhB6ccOxCrJZ1ktbzXUjpRdAPySGnZhuIJYQ7+7zTIpxaLETTmHDKA8KTksFSLiKbMEys5SQ7n+4cXxFuDXotZzPYcBTWh5JtoSnL8IWZbwjk8yp3O54t08ii1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfNqz+QkkP1aE9UwMZzjaCLWgNoy1melsatmiXAKVcE=;
 b=gw1GpIipc6x2Ys2xJETYlz4rSmrmabNNd8McBO5nr6j3PLec6Ypqb9/SzMJhSFULu/GUD6reBrwPel/52fgIupO4ZpiGN0SF1v/7Rx+Uzi6ip5HV83gXCpCmr1VVCTokLgWYurv4J8djEbmTxLUZe1Tsa/Abiuby6zpxKMp2pY18aEUsX+FByYhQ9ES3lAId/KKxG0LxPMr/nTWD/Vbp3J4iNe0K7YVoWqeHpTdfTtJptm4Cu0AwzJB57BzQ/m8Wj6oBQlFwdKhQyn67M/q949vdIs4fYRh1kgDZBwtkE9Bvu1XnP0Vi9pxBK1Dc+j+V0zKWxRALR56OywOM3GfKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfNqz+QkkP1aE9UwMZzjaCLWgNoy1melsatmiXAKVcE=;
 b=vWcEnUIZG4fgydHxVlR+c/eObeD3z4vMfaMAjjEuIZFYVCSr0fugNKvfRE2GTs1e780FnCMJ7OB05KQX1hbtFbi80SD+7v1C51Tqk2dc26RE942+c3CXjHCNiUGsNR7P71P+KYfW8kMGA4nDMpn7GdDA+JYLoJte2lpnDe2hkwk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH2PR12MB4924.namprd12.prod.outlook.com (2603:10b6:610:6b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 22:25:59 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 22:25:59 +0000
Message-ID: <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
Date:   Mon, 28 Nov 2022 14:25:56 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-9-snelson@pensando.io>
 <20221128102828.09ed497a@kernel.org>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221128102828.09ed497a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:180::37) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH2PR12MB4924:EE_
X-MS-Office365-Filtering-Correlation-Id: 6100abba-4adb-4e3a-d3c7-08dad18f8698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fVduxo6p97ASrYkFFo3UWIYQa5/ysZfNknP21LXfUIMfmCmcq0fVFzZLdr0LiPRNpIbCZ+n301+mWT8nbKB9Vw+PfEwKdGMbqvwCLW0Y2g5UYUK/uUu0ej+0bjMahvkKBmiC3uSg4lA+raoGQX+Wgmscm1yYQZaQkT0+u9VDapjhIVWlc7UE8BJRgrwVEgMChsMzP1vWI4nniByVnFR8QbQeWfrfLllFbKtLmpcw//XTB5aiWGX0kCI/b68GiapNyq+7MbRs5V9JZwfftAY7Ool0UTJ+xx5/7YDE6tCYIGWHAIRCaBnNJGTxjeFj6r3wFkeGIyIf9EDhjP5ibSQlM7uFAjg0V3Ox+CNqcgmilQUUD1nzKnKLczPACmOQFhGND1ptr4142L6oJzvzm3oP0+KthaVgdwwG/qOX+znyH5JSY4KIURXs1Rsx5a25hz7GFxO+ZEFRATHtGu+361pS0L88xHBsHdNKVgH3GdfkBftZCz8bMdMJG6SiYHE43Grx2z97xA5akMpiL6Z9XRVEVBlVvqS6YD8GFlbw5oXGxMIo3RN1BvVen7paMXBMMzz+w5rcBoT07Hnb7ttlOyfTOHBbGKIYLLKX0RkFg06mU3yFToHHWuzy5GUluqqqqef4+p82hTE7YsLabMpmEuPaMUERiXY/zyUNgeRKyeAd63VUJOKEI/GLz0unTj3Jm3eEGWQBd5BzndgJzdL1fo+BTR2or1QUGSEQahRLxUOaob0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(5660300002)(4744005)(31686004)(66556008)(66476007)(4326008)(8676002)(8936002)(41300700001)(110136005)(66946007)(6486002)(36756003)(2906002)(316002)(478600001)(31696002)(6512007)(53546011)(26005)(6506007)(186003)(2616005)(83380400001)(6666004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVh0ZlpUNml2dyt2VWZGYmcyMmY2eVN2cklVVDlIT1hJRzdSUUtFSkpJZWZB?=
 =?utf-8?B?azE1dHRBNzErb0UyandrSXQ1MW8ySWxGd2txYzh3RWF6UkZaOW0xUXN4MnBQ?=
 =?utf-8?B?QklZWkZmeEhJSGl5MFZRRHFyb2t0aTVEN3dtZGR5bTlXYlZoQ2N0WVVoeGEy?=
 =?utf-8?B?T3dBSkV4VHRSOFhMY3lWNWNHSkNPL3JhYTZlckdjbkpWcDVaOGRkVDlSbXY4?=
 =?utf-8?B?ditxam5JRXlyWm5BZ2U4UzNsMGNoOHRoS3NWQnZNY29BME5Hb01NNFVhQlg3?=
 =?utf-8?B?c0ozbGEzWDhFem1MQnJzWW90Nlp4NUhRZlRGRjllRXErRFBGTjJnY21BdHhh?=
 =?utf-8?B?aUUxWFJsa1V0cW9pdUd1VHVJaHdGTU82NThqOWh0eFJnSk5LS3FRZ3pNeEUz?=
 =?utf-8?B?U3AwOGx3K3IzaWJlNXZvSVQrMnZZR3VsQjRBSzU0bEFSMlZOOVBUcU5HT3Nt?=
 =?utf-8?B?OHhBY3NHRTBSc1NiOEhiR3MrUm1LVmZ2d3JVM1F6SjE4ZEprRnpKSUs1VW9s?=
 =?utf-8?B?b2t0anU1TVRQazQycUdKWE1ZZ0doRUFkcXlxaEoxRHJlWGFyL0c2NXBKZU5J?=
 =?utf-8?B?Y3B6cjV6eUpVMDE5SEJ1YUt5MGNLSXdBNFlRM2wrbUNQbVFpNm1HMmRwdTI2?=
 =?utf-8?B?bnJ6bytZcnFNMmN3RWZRSnVEalZnelZSVTBCT3FlT2JLbHg2a3FUWCtDUVEz?=
 =?utf-8?B?ZnV4elhYdlFManR2a1hqQVBwdGIrSXVod2NsT1hua09Xc1lhSjY4bVJXbXFL?=
 =?utf-8?B?K2xIZnRUbWdKU3NJUG9xZ0pLNzVHcVhpRE1qV3hFbTZPQ0VUalpUeGk2dUZO?=
 =?utf-8?B?UW5FMkExN04rWFlvT1o4MHRZTVNJeWhwYmtsdFNvN1hrTWhyK0JHUVVqVXpx?=
 =?utf-8?B?OEFwYWJjdlhlUk5Kd0o4bk96b1JCQ29WazJCbE95TTFJelVOT3JZcVpHQXpa?=
 =?utf-8?B?SkpMN0d5MnJwUmVlYmsxRlowZEZYYkJWWmE4eVVuUW9CRkdKblBUMmZ1U3dE?=
 =?utf-8?B?UFgzTEJQb0svRHZ6c2JHaGt5Vkh4dHJ6QW1WZ2pGbmlRSDk2RlJWZmh0Y0E5?=
 =?utf-8?B?b3B5c1prbTNrU0dkWWlRczBnbnRvc0huc3ZQTTJuQUJLblZlaTRiWGozem5W?=
 =?utf-8?B?TTRma253UXFROWJZSTloSjJSOEFKRzhsQ3BRcmlZRGlHNC9wTTI5WFM4L29t?=
 =?utf-8?B?czRjY1VLY05jY0UvT1ZNR1BGckVBZnd1Y2pKTk1vZlpvaEpEWXllWTJ2aTFY?=
 =?utf-8?B?b2pRektwNElUSFJsTU1lMGhRUlcvMEszNWdyR1A0QlRhMTVYbmJaL1pYeUtD?=
 =?utf-8?B?V2JFOTJiM1NRdVRjSy8wakg0QndSdlBZYnExT2F6ZmxwNVhPT3hsa2IvTGNn?=
 =?utf-8?B?UjJ4bTBNeS9lSm1BTVZLdElhNktKakl3bk9lS3k5UUt2K0EweFN3cENzenlt?=
 =?utf-8?B?MTJHQWwxcWo4M2hWVElhMmcyNWlvdUlpT08yelVjSndINVg5TkJRWGprN0ZK?=
 =?utf-8?B?K2tyVSttNzFaQ3VkUXRKQXJrTjdBL21FL0ovWWx0WDl4eGxsMTFnNVhSSTQ4?=
 =?utf-8?B?WkV3TUVpTTAyMkNVVGFIMm1iNWxJUFJMVzVtc3QzSU44VmZ5Szg3YytsTGNL?=
 =?utf-8?B?RmlDY2Q1MVNlbkFjWWRzd25MMlVsNnRrM3Vvd0d3Z09KbEZNRitIYWRQVDds?=
 =?utf-8?B?ZnBVMG9jbkJvMndjOVpxNUxrYmlKaE50Vzc3VHNrQ1h1MUF4dEVqdU9jd05C?=
 =?utf-8?B?RzdxSUtxc3YvWUFxUHBrUDkzSGUxK0FRRWR0RE1ITnJPVnYybnR6Wllzcnl6?=
 =?utf-8?B?U21icjg5dEFnYTVKc3NSUUVzV0ZGRkRqL2M2NUZpNTN3OG45MGd3NVRTeVFO?=
 =?utf-8?B?a1VtaGFlc29CSGtpT0VuTTMyUlFzbHVwQ3ArUWxPZnBSSlBEZlNhTTFmQnQ3?=
 =?utf-8?B?VGhrOUFEbEF0YW84bDl5bWgzRHRmckJNcU52ZzVlNTdIc1p0bzRrRFBtbVVo?=
 =?utf-8?B?bzBlTHRjQ0Zhak9QdFhrOElvY3JDYjBVY1VYV1VKN3ZqVmZ1eTJLVFhQT0Ez?=
 =?utf-8?B?VjJtd1E2T1JLM29zaHl4UWE2VVVoTmFsTHUyOWdOY1N6SytYV09FN0s3d1Vq?=
 =?utf-8?Q?VQFVTwN0QBqFLZVg/CnYfYX1B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6100abba-4adb-4e3a-d3c7-08dad18f8698
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 22:25:59.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z0bu8lDRtnOHhVIORIpbYG6ZmPwWQdm8P1bKO9JaZq0yERVtYeuJI1hfsjWCEWKsOvAgMoQzFVkdf6leKlEbwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4924
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 10:28 AM, Jakub Kicinski wrote:
> On Fri, 18 Nov 2022 14:56:45 -0800 Shannon Nelson wrote:
>> +     .ndo_set_vf_vlan        = pdsc_set_vf_vlan,
>> +     .ndo_set_vf_mac         = pdsc_set_vf_mac,
>> +     .ndo_set_vf_trust       = pdsc_set_vf_trust,
>> +     .ndo_set_vf_rate        = pdsc_set_vf_rate,
>> +     .ndo_set_vf_spoofchk    = pdsc_set_vf_spoofchk,
>> +     .ndo_set_vf_link_state  = pdsc_set_vf_link_state,
>> +     .ndo_get_vf_config      = pdsc_get_vf_config,
>> +     .ndo_get_vf_stats       = pdsc_get_vf_stats,
> 
> These are legacy, you're adding a fancy SmartNIC (or whatever your
> marketing decided to call it) driver. Please don't use these at all.

Since these are the existing APIs that I am aware of for doing this kind 
of VF configuration, it seemed to be the right choice.  I'm not aware of 
any other obvious solutions.  Do you have an alternate suggestion?

Cheers,
sln
