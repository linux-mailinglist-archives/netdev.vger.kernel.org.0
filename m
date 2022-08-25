Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943645A097A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 09:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiHYHIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 03:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiHYHIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 03:08:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABCF66A4F
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:08:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXf4zyJW6F8NbLmfMAa8KE9zWEy+V307Wj4Qx+egYy3Rn2JdaRMOPzUYlrqs9SaZEqxn5MLBFWQN8ikkJrn18I0DN5IIoe96HNDe1QP+skT4WFGslbV1ZCzYJqDNZ6yW0WKlToKJrp8z37j+JlU8eJx5hVfu/Ij7OJJ/AnalAq5nOQNzhaYO81Xn5vNzi69bCoqz8iALyIbBPFKLAP7TLhdz2H6x7GoCq+DIKAn4ljEZM1sF2fozG/QN8rN6bP9fLMAlsqPqKEP7//pDROM0/r7fSKF5XRhRlyLLVzBpkNiIEYcqB5xgmDmzdV5uvYncGBkWnoyGOMyHb38iDYGs9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/u8Er8u38MwTN+ERlK9gYRdOf1+pDcaJRKIQ43zjI/o=;
 b=KKomX9T/sD6VqZVJ6dokJgIykdcns7ZxsuuQKz5ky4QQo5RJ0F/CR+XDN+/FsozW/99rw2zXXN0EQhwuJxGvtd97P5AUixcCbs6H7F9SZ/IPFMtybSTcE9eEoWucnHg3eXuTX1EANGt3KbcxmgUxR0N5ym6uq573vlx+Tk/jJ8sizkcTx7w4ejgYC7ELORGYQiXshsiTaKs3/hY7oZvJ7GcaHhYTTypXiq2QQ72jd93ao0qLDRWH1AK/EFOBeSErnDs8QbAlJ3UKy1H0goWLrfvWL9ORoxc5iJ83ASZ3gf7EdnOxgJ1BkJp2Q+MWMqgkSjjssjyMhZ4cUVumzzwTRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u8Er8u38MwTN+ERlK9gYRdOf1+pDcaJRKIQ43zjI/o=;
 b=fYUo+kA0Acb1PX+kXAVeeWU5whmG7npVwctis7KrhO8bdWDC5p3gU4CKNoY+WGN/Qo2fcERIkN8AWH029dKk6PHX9FAX7Nd25KKfhfw90buKkzfJPq7gZzG2m+22ANN36ff+m8DyWrtsnK4iChGgRUvjY2F7c98qegH5fbQGverCG+TpZlfo1dm4OmpZHSa8iuN6v74Hjy4S9YqfLhIB4KVWgMVB6Ja4xK2EkJLb+4DafD5B6UQZeludF2uFxTkkJvUu4ytXjd+m3qWXy33ZzcyYzCrOMd973ARDFNCntboKylcIHBssandDGCQI7wFMefAvEVKyFqboHHh+ryCmuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 07:08:11 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58%9]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 07:08:11 +0000
Message-ID: <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
Date:   Thu, 25 Aug 2022 10:08:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
 <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::23) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32211a33-9e1c-49c0-c8d2-08da8668923f
X-MS-TrafficTypeDiagnostic: IA1PR12MB6209:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MNPmSLGbf9tb5pygvemmt7/H0sM3jpcRcVZC763OTff0M0SUALqTX9wiu+jIG0H3JWUGCDC3FK1o7KWHdaJ8bR/UpfDHzYxI0+EFtqk8kRLsKJSAIhOIWRSGXon1j8u91f425b5CzuSIpTxcgZCdgPynI8rPFu5b1g19MFKn7VZayJz43owPTLo/iF9p7f0MZmqynAfD/ADVaM5Oais00BNipc0Ypc1WTLhjvVO9mxEYlqqiUjpwMG7f++D2OsnphjlrhFCLOm7yRcVEq9N6g9zsqutUBN++0s1pCS4gV0tk/vE+8jPCSTAGS2x6sexQsCd00vFCMqv7yjeDzohkRn9NZ52IzqUHpad/ep1SAurOwC+aaIKE9WfPlaR7mFNG3m9AueO0IOar91CHsJqcvp1iznscYIQlOVqaMQ9Fhmmeoc5ODrYCJ7e4MKLgicZXAzq97SiqsdGoAy+qBSP8S6L/Rfgs4Iwy/RQW+ylniYCZ43GCH32TM/ebCC34fsOYhe0/yzrnrnL5cL/iEwx75zi8ndZIMCMT1CRjK8E/z/GnJezas+0q4qY+0lgE0oVlcdSI637icowUIrvXf4YMBjUPxcTa9fnVKnl718uvCG/iWygrUxlS/h/AfMzYrpCDU6kE6slPD18nJaB0hg/vX6YFDaDbH6C7yTEWvIDyQYEcJmf3n/YhrkL/+5Z6gGdoqxstAUtPNV4wi3mozkFs29IUzMs1rXKUbRD9jH3SfNLNMgbfLPr0Tnd5bImzK5k9y47cFFW7qsrIzhrfI1e086eWRSW4nJYdFNlqOxKgalY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(54906003)(6916009)(31686004)(36756003)(4326008)(478600001)(66556008)(66946007)(5660300002)(6486002)(66476007)(8676002)(8936002)(38100700002)(83380400001)(6506007)(2616005)(186003)(2906002)(53546011)(26005)(6512007)(6666004)(41300700001)(86362001)(316002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnNEczRKUHpSTU9GNldFUkt0OXJ5ZGltQ1FLUUl0R09jaU1xSkVjWnQyTzFQ?=
 =?utf-8?B?aHM0WTZQWEFWdGd2Q1VuaDg5dTRkWFh2VW5qZ2ZUNmdiL0t6Z1lqcDM0aGVD?=
 =?utf-8?B?TmpPWktLMjJuWXd1LytTNzN1aTZhZlkvNEpRV200UUFQdW1lcFRYSVUxOTRG?=
 =?utf-8?B?ZWRpQmpHQWNzamZicm9NMkpURGUvcWEyWTFUb3BPRTFldDZYK2w3R1o5Smdk?=
 =?utf-8?B?QkNjWS9odndGRW4rRzA4NFhUczgvYlZ1M201d2FJY29uWldKelM5TVVLNHUz?=
 =?utf-8?B?bUFDcGUweG9UcjVnWFlxS3JXUWpyR2VzR1g2MTFsK05RcHcxSVcvem1CMmgw?=
 =?utf-8?B?TmNqeTlvQndkMGF1bmxsT216dGY0WTR1SkR6YXJBa1JIVWh0aWVqSlE0WWNB?=
 =?utf-8?B?MitSZzVyUEFRRURnbHorSXlvRmJ2N0V5Rit1QWd5VlV6VnRVUUZQOU5WQmxq?=
 =?utf-8?B?ZGlBK3NjWmRhZElSRzdFMEIrN2laWkNBTjlhNFVjTG03LzNKUWRNTG5KUHlO?=
 =?utf-8?B?R0hYNWFqQWF2cVRTbEh1M21yekZidkNSREUzNWtkcmVGQlFLOGZHM1Z2a2Rs?=
 =?utf-8?B?SmlERGFIdlh3ckZVeUxPZFp5dDhwa1NTMEo5d3piL2o2dUFZa1A3NXU0dWtC?=
 =?utf-8?B?V242V2gyVFVET3VxazZMWGtXTTRUZWlVQU5iNGhxQ1A0Q0JyR04zQVRiU05M?=
 =?utf-8?B?emNJVUc1cE5SR2ZHcHlueHByS0IzUU53SFpGSlpDdS9VUUlXTmpaT0hSc0d1?=
 =?utf-8?B?T0VkU29zT3JxVUlFTjJZbTFVQi8xaURRYzhwRG5DbmkxZzBHZXVJeHBBZ3Jl?=
 =?utf-8?B?Vi83dlVDbGo1Vll6Ylh5NG9JMWRPeUpyWnpLc0NsWUxycUttV1kxSVYzbm9m?=
 =?utf-8?B?elArOXBuRXFFUUp0cjZBTkpkbmZqWGE5NGIrK1Q3Mk5qL3B5L2pWL3RQa2V2?=
 =?utf-8?B?ckJVRzBLV01wbXQxTzA3UTlxTmdqQmEwMG5iK2NjVUVzYkt5VXlzaW5lazN5?=
 =?utf-8?B?a0ZkclBVaCswL251bFp4RFp5cDdlazJaM09nZVgzQ0pFQ3d2WTZmdFJpamtn?=
 =?utf-8?B?Mm1RLzlDRVREZXA1UnZWY0dveWR2Yzc2UWhCcXpFam5haVQ0Ym5tamU4YUFY?=
 =?utf-8?B?MVpEWCtSdUlBWWFGUVEzNWVPcFpkK1l0cG9FNno2REhkcmFzQThTTFRtRzZO?=
 =?utf-8?B?YkE0R09kTTk4WDRGZml5YjR6d1RGVU1hVWQ2NW9nV1Jxckl2QVFTTFJIS0Iv?=
 =?utf-8?B?UmRubnZrSUhYYmZXM3hETFYvWnV4a1ZqS3AzemFvM2d1bUhoaGYvNE5hS2hr?=
 =?utf-8?B?ek11VHFDWExVTHEzcno5cHYyaXh3Uk93WkNwNUpNNWRCQ216RGg4K0RUUzFs?=
 =?utf-8?B?VjJmUkNyRFFKQXhQUDFLUW43L1FIYXJWdTlVUk1YbEV2dGlFTjZFbkhBZllt?=
 =?utf-8?B?OE0vNlJTZUpsbDRlRjZVZXNxQzNoeVBHUlplcll1R3k4eTdQTFdYSndSajli?=
 =?utf-8?B?T0ZFS2Z4YmhUbHdvWDNKMTBuak1mOXB2S1F5eGQ0ZUtIU2pES2VFK1hUL0VW?=
 =?utf-8?B?VnZhMFZTU1JQRVdqcW5kUUxRUmplcTlGbDV6SVhKdUJDUmhEZ0NZeFVMVk50?=
 =?utf-8?B?YU5IRVBVTGM2VzVuOThoZkZCcXF0aUpSZ1JDR1ZxV2d0enEvTkR1TisvMFQ2?=
 =?utf-8?B?MmE0b2dvd3RPdDNxaEZSeE51OTJUcnZyYjh6R0FzWFNOL2JtdkxiMUliVTZi?=
 =?utf-8?B?TnpHUEtxUU96MmRQaDRtYmVQRDlBeGxOWERvV1UxZXRHMDZIN05kM1QyWU1W?=
 =?utf-8?B?V3dVSkE2UVhZNTdUT0dVcU1lM1hvLzlPZGY5dXBJU3JzanU5NDdRa0R2Rmpr?=
 =?utf-8?B?dS8yVDFGSGdGNWN3L05RR05OODdva1VIQmh2QlQvQmFaNEs0Z3FzMUgvcmZm?=
 =?utf-8?B?OHRBbWRuMDlYWndFSWRic29uYjZjdGtxWlV4YUhWeEtXS1BOQ3AwSWM3N0ND?=
 =?utf-8?B?NWRzK2FIZVdGZ3dvbmZaYUxuZ3NaTVpuT0lyWnJ3VUIwUTZVbXZ2VmVwQ2JZ?=
 =?utf-8?B?b2k4Y2x0V01SelVXSTJVa0MxeE5BR3ZIMDZyUzFuYmdUMVNjMEJxNVNURHdo?=
 =?utf-8?Q?5u9RvGMMiZZT0MnjZXSVuSmUz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32211a33-9e1c-49c0-c8d2-08da8668923f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 07:08:11.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phTpJ5nqcUY9n2A38R0eN/l4cGb3CX/X62kLgxhD1JYDB4fg1n/XrxBgXZQqY2DK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/08/2022 20:40, Keller, Jacob E wrote:
>
>> -----Original Message-----
>> From: Gal Pressman <gal@nvidia.com>
>> Sent: Wednesday, August 24, 2022 6:36 AM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: Saeed Mahameed <saeedm@nvidia.com>; netdev@vger.kernel.org
>> Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
>>
>> On 23/08/2022 18:04, Jacob Keller wrote:
>>> 2) always treat ETHTOOL_FEC_AUTO as "automatic + allow disable"
>>>
>>>   This could work, but it means that behavior will differ depending on the
>>>   firmware version. Users have no way to know that and might be surprised to
>>>   find the behavior differ across devices which have different firmware
>>>   which do or don't support this variation of automatic selection.
>> Hi Jacob,
>> This is exactly how it's already implemented in mlx5, and I don't really
>> understand how firmware version is related? Is it specific to your
>> device firmware?
>> Maybe you can workaround that in the driver?
> For ice, the original "auto" implementation (which is handled by firmware) will automatically select an FEC mode based on the media type and using a state machine to go through options until it finds a valid link.
>
> This implementation would never select "No FEC" (i.e. FEC_OFF) for certain module types which do not list "No FEC" as part of their auto negotiation supported list. (Despite this not actually being auto negotiation). Some of our customers were surprised by this and asked if we could change it, so new firmware has an option to allow choosing "No FEC". This is an "opt-in" that the driver must tell firmware when setting up FEC mode. This obviously is only available on newer firmware. Going with option 2 would result in differing behavior depending on what firmware and driver you're using.
>
> I thought that was a bit confusing since userspace/users would not know which variant is in use, and my understanding from our customer engineers is that we don't want to change the behavior without an explicit request of some kind. That's where the original private flag came from.
>
> As for working around this in the driver, I am not sure how feasible that is.
>
>> I feel like we're going the wrong way here having different flags
>> interpretations by different drivers.
> I would prefer to avoid that as well

Then maybe adding a new flag is the right thing to do here.

That way the existing auto mode will keep its current meaning (all modes
including off), which you'll be able to support on newer firmware
versions, and the new auto flag (all modes excluding off) will be
supported on all firmware versions.
Then maybe we can even add support for the new flag in mlx5 (I need to
check whether that's feasible with our hardware).
