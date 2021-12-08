Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE4446DDF8
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhLHWFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:05:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:59001 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239964AbhLHWFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:05:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="238189006"
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="238189006"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 14:00:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="601032753"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Dec 2021 14:00:10 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 14:00:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 8 Dec 2021 14:00:09 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 8 Dec 2021 14:00:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/rSjIpT57nG9CrfAN6b+tzKpLVMUaJIMawsdatvb+2rIouoAbDFedYi8o132g4J9tzapm1PtDBtr1UizxrhFSiEVVkCPP6wAitXqfh80Fd5ORDHdVFSFn+a2u7rl75k0cjrv/7xyYzprZFQS9ruM6NDLWx90rgNDqqEd8hkwQ0yKfXCrDuNGzlQQhmo9PoghrHRka+TXEJaWHHOp3s1EHeRw57B6tH1xgjTl7QMvWfS7WyFNCdd7PuoM84fswO/E6cefLKPaO89nFKKiDthsSCZGVQHXayW3JiNz2A/h4knKYeuwEXVxo3tuyTZcSjA+KBTl6xpkU+p/xg61L4v+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgz3lWAm8QLYvrIIcpGj55ky3jL09MJTTzCY/7R5NRQ=;
 b=c//GFpEIUod0n/fZ2P9GKefKo22Wo5x01/0lCQj15+/4nkBKqDjgsLlQohDGMf/RsFohkCGU74g37euD9b//toHJPjTM71BjOZ4dnlFvaC8Nofrs7bL7h2m8Foum8l3quUs3JysKSx1+BzxQkh/htiJbVahimFQKHII/M3V7dJZF5l+eVMgMmmqSkBwgQo7U0Z2/9SEdc9/NP4XqueaB49PgHV3nTAC7DICyVPdjhtT+FDZR3C54U6oNLFezXZAot7qvbDaMODBLUWQlvwaFH8BJPEpYR43K7DDRqs0RP/bSAUILvslQGeUtj2xjjqmSW5OQnmclnAUpBBPai4oN5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgz3lWAm8QLYvrIIcpGj55ky3jL09MJTTzCY/7R5NRQ=;
 b=lDgl2wLeaLa6Sb2Y4+htCeUEJpFWfsEHS9VW/YYyBtzotHnwHwX1tBdEvs8TRvELEv3xVKjiEGBaYOO2COw0Z/9/CxN748TGz9CE7iqjuzRrb3/m7H4yPKis5dtGlwX0jadPnqmIV7h1UN6Oq65yqQeRjYzxPS8OJEXn0Ade+K0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR11MB1983.namprd11.prod.outlook.com (2603:10b6:300:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 22:00:08 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::b0d7:d746:481b:103a]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::b0d7:d746:481b:103a%8]) with mapi id 15.20.4755.021; Wed, 8 Dec 2021
 22:00:08 +0000
Message-ID: <7fef56c5-b3bf-4aad-4f29-adfaf2b902b9@intel.com>
Date:   Wed, 8 Dec 2021 14:00:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net 7/7] ice: safer stats processing
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
 <20211207222544.977843-8-anthony.l.nguyen@intel.com>
 <20211207215853.692bbff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20211207215853.692bbff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR21CA0071.namprd21.prod.outlook.com
 (2603:10b6:300:db::33) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
Received: from [192.168.1.214] (50.39.107.76) by MWHPR21CA0071.namprd21.prod.outlook.com (2603:10b6:300:db::33) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 22:00:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa665230-f10e-4a97-b6a5-08d9ba96193c
X-MS-TrafficTypeDiagnostic: MWHPR11MB1983:EE_
X-Microsoft-Antispam-PRVS: <MWHPR11MB1983288A923DA04CC215E00C976F9@MWHPR11MB1983.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+wKGSJdH+hxt8t8vopvV3fcWQFtocVyqEu/tk1uAJ7s57jLvcSvBvXgcaim4nlugcMUPcdR5Dx33IE4EG6CEjuFyXpS5fcG4xckvJSU9FaJ09MSD67Ziw3Qc2uDxVMGX8IFxFHDAc5qC37zAGZSmsNm+lPJw/w0ElXqUXyKm6dqhLLPK/30J/2WD5ZceaRmXN1ojc9nrIMhgSubQkbQd4bHg+N/QXwbawBezgkp+EwPt/YAuEBWtux7oB1Q9i5ZYJcZF0z2S07zYjYRWB/c7qvEbt4OA8r46wdUSqiywP26ftiivh5P7aSOMGPu+XZhmnKKjuMu0JOe7Q7ch/aA9/fExTdrNtZdLvLpiK8RDSbK+FWoVXjayEdI9mE+2e4Pyop39EAvj0C9Vc4sH880L4C4QFvTUZrN3diNVJqh1nKPDjtbmiUo0VXsX3HUef66C18k5UJA20N6B83rSSJJH14JCKbgHuM9l5ebjtYPX6Vnqjw1MR54S2zuMcJOmtx2zTPRH7a1sqdd8r+/CQL4b31WApz72KBpHb9q6il7bQYuVGuRvRz9ifO8TqKSggpDKiOY4+8fN5VuAHMuTpXLPZkbyOAzf5C6z0s4yK4DUpICc96LvLHayhbPcvF049VYPuKDcKKFafA3OjhizROEtOOprjPXzPm8FFBHYpigm6AFNs1lhKEsDV0chr9//mDjMtgm/JHxLpmsOYEEvtAgFlZDVh/PzjEwg+3rvKXB/HLPjKcbHFL0x7QU5tWYqAak
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(36756003)(44832011)(16576012)(2616005)(38100700002)(83380400001)(82960400001)(316002)(6636002)(5660300002)(2906002)(956004)(6486002)(110136005)(107886003)(31696002)(31686004)(4326008)(8936002)(86362001)(26005)(186003)(66556008)(66476007)(508600001)(4744005)(8676002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlA0ZWFYckxxREFmbmpqTGwxVHhmYWdIWTVhUnBPNC9rOS9xZTE4U2hCeDJI?=
 =?utf-8?B?STM3OUNyUk9YSGRsZmdFR29WbVhIZm03Tzk0c2didTVZL29wd2IvZWZaTys3?=
 =?utf-8?B?ZnVnQXFEZ3V2N1RHeEhKM1duby9OdEpzODNqRjI4THhxQTVja2w3TjBSOFVl?=
 =?utf-8?B?bTk4ZU1GaEl1MHZiTWlBcHpVZm5UQjQ3b0xMZEthLy85TlJJaTFjZ2dHVU1v?=
 =?utf-8?B?Z1BnZkttRGlsQXFmajFWOFYyNnMyaGlEY1QrYTQzYU1jWU50VmxJU1YvT1RT?=
 =?utf-8?B?UjNReUNkcGtwK2RxVEQ5azFBaUJiRnQ2LzRKdkRmKzlINnU5Z2ZTUHdydHBQ?=
 =?utf-8?B?d0ZXUmVTU0lBdWtkbTFLVi84czJNMnlQbzNtSVYvMmtPVk8zamkycnBaankv?=
 =?utf-8?B?aDY1YWJIVCs0TGFlV1dORHltWDZDOHh1R3p4NjhMakhPTGJPT3NtQ3lTZk5h?=
 =?utf-8?B?MkJQcjhBeStWTDRFV1I2cGM2V0lUYU1IZHRxNW5TVVluS1VZZWRSd2pFdG1R?=
 =?utf-8?B?Wlh0a0FmS1RMREZGaDVpZlZOVzhlRmZUemI0cVdtUFFZUnIrZ3hWeCtRU2tF?=
 =?utf-8?B?eENHcmIrK01oMUErSkpubnZZTmd4YUhybWpDTEJMRmF5VkJsL01KZ2tYV01W?=
 =?utf-8?B?Z0g3NmJQWitRWDUwRUE4L1hyVnhOdEppMG5mVm1GUWFTYjBmTGFWYVRTZEpH?=
 =?utf-8?B?Q1k1VEtsdEpvSW5HU2llK3VnVnBTdUhvMFk3K2M3bysvcEF5ZUJRRDZMZkx1?=
 =?utf-8?B?SnhZanZxdUExc0pSNFhieVVKNkRjT29tanp2bXJhZ2xFVmN4emltMVpKa2Ft?=
 =?utf-8?B?bFZOYlEreGdzOHhEQUhHbG5TM1Fwa2hvbTdBcTlxQ1BEMEo0VE1UOWZwOGgr?=
 =?utf-8?B?bmVwSHVIbmprVFpUaDZCbWlkakU4SUozS3hIUGZFYkNIM2g0N2d4d214V1VP?=
 =?utf-8?B?VXYwTm5ybzJTTEc1RG4zSTNvUXBzYlVQbk1CVXcrUU5MNzBZTndrcDJuMWdK?=
 =?utf-8?B?WFRYdlcvUmFTSlltRWN0SUw0dkhkTGQ3NzFCWjhtTkY3QWRmempGRFMzZlFK?=
 =?utf-8?B?ejJnU09qQ1Q0MkJpa2xIK1dpOStmOU5ZRjRpVUgya2ttcDZaVk5uajdKZG41?=
 =?utf-8?B?NTJsWHUveGJsUXd6OXMxUlpVbDhBK0NqdWowUEdPUU5mNlVLN3J3cnQrQTA2?=
 =?utf-8?B?VFNuOCtRZkNOeWlLazBUUWxkdE1LN1N2dktWb0hHUyt4VzZkeE5FVU9wZk9R?=
 =?utf-8?B?OTcraGsxZjlNZUJ0cXFHOUVUS1ppQWI1d2FCcGVrR2pzOEh2cmR3YnZJOTN0?=
 =?utf-8?B?NitUNXIzd2MyV0JpRFl5Vk5qS09DZGlrVUlHcEhsYmdhZGRNQnNsNks3Zmx5?=
 =?utf-8?B?MGFDVVRISlg0U1BKcEZERUNKWjQ2MXN3eHBpcXZ2YlRPTmVjWUlNU2s0MFIr?=
 =?utf-8?B?c0graEc4M3pxL1dCcGRLTFVVT1dOaHdxeFk3em1UZU9CTXV6WmIyTGdRbGRs?=
 =?utf-8?B?VExLWHU4eDRVeWJXVVk5bHFlQktFVkhPRmxJR3oweDBrZlVkb2lxL01WOVhJ?=
 =?utf-8?B?RUhUWFJBcU83L01oUlI0THBIMDM3Uk9vVTlnRU5ocDhNVnBhZGZ2QWZqcjAv?=
 =?utf-8?B?T0I4TXB6WjI5bXNjV2dzdldEY095MFdJaTh2YklqMTB2eG42bUJ6RHVhME1N?=
 =?utf-8?B?bVlIN1BZNlhnSnlvQTl1TmtDWHhKTjJEUzdSdk1HUUZtakFSOStBRUZxeWNB?=
 =?utf-8?B?VFp3ZFFndmErOUFKV2kwS2t1NVhNRVV6S3Fpb0J5U2xVZndPb1RHZ0ZOUHFZ?=
 =?utf-8?B?bHZKQmsxSVo0V0ZaNjlMZ2syRlNOYjVxQklpRFlpSTBJenJiNzFSS0RQRmdy?=
 =?utf-8?B?ZHlINzhmakd1bnRoWjhJNGFVOU9HRlY3ZVhWSWpyWlRONHNpaFRBREhCczll?=
 =?utf-8?B?NUJvNEhyNkpxQlBNKzRhL1paYWVPM1kyOVVFeHBPbXMvaXd2RUVtOUdZYXdL?=
 =?utf-8?B?R1U0SW1LdFhQeWF1QjZxQngwMTM2Mm1NaGRIZzZSbjdYZ1FiRmFXaWJaaEdz?=
 =?utf-8?B?eEkrbCtRb05EVnJCT1VndVpOMnVaMmdadTBGNkllOHJNNkphSUd1bndPUzR0?=
 =?utf-8?B?MG8xVHE4Tko4WXF1WVBPQ05LNnhIcXRlSmxqYWJKeWg4K0xLOXYvWjdwSmZs?=
 =?utf-8?B?R2kzblAwUWxMRW4zQ2Q4b0JkdXBDTXp1UlVhUW8zZVVQbjRuK0VieGd4b2pD?=
 =?utf-8?Q?Lt0V3+5N0LHKzGb73JeTWCizZ07/8xxSYAag8OrnOs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa665230-f10e-4a97-b6a5-08d9ba96193c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:00:08.2488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FW6PFTV3D9A8w7Ec6s5NlqFgvf2DZ8L7J8Rq2oeepZTdyl92iAG/WOxQJuSnf1rSRpTAmTWTr4+InJ3vvVNSF0YQGhMkme00PMwU8CcYK24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1983
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2021 9:58 PM, Jakub Kicinski wrote:
>> @@ -6219,6 +6227,7 @@ void ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
>>   	 */
>>   	if (!test_bit(ICE_VSI_DOWN, vsi->state))
>>   		ice_update_vsi_ring_stats(vsi);
>> +
>>   	stats->tx_packets = vsi_stats->tx_packets;
>>   	stats->tx_bytes = vsi_stats->tx_bytes;
>>   	stats->rx_packets = vsi_stats->rx_packets;
> 
> 🙄 in a fix that has to go back to 4.16?

Whoops! Yeah, that was my bad. Looks like I owe Tony a beer, he already 
fixed it and sent a v2. Normally I'd mention whitespace changes like 
that in the commit message and not include those in a "Fixes" patch, but 
this one slipped through when I created it. Thanks for the review!

