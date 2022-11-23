Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927956369CC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbiKWTU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiKWTUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:20:24 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010F69BA2D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669231224; x=1700767224;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AIrFZ64hC12H1N6zgmpyK1G0J8BTJ22PCMf8Q1M5jJs=;
  b=dljiIE6vFx5eD6l6NzAWse00R8RNACXTk2bHMs+tRD9Fe9yoc1Sg3myw
   dGluAQLmvQWsUFD6VXaK2uOCi6NMRUe1+bCYnGS+42v9iwcnxJrKQ4Aot
   b2cDI2P9kE/yrEsZGzv57I/IDEdIW6m2g6TCern/cb4Mw4G9LMf8647uc
   7pA9XgPRos+/pgiSfyIhZaw8re7xJHR6uNbhjOL63LR3/JKOmWCga1p9B
   MbNEPPJMilPpafDhBJOa7rTFDdk47E71bO1c9JgtNIaNUv2/8Wla8viti
   kcVaTS/JF4h3uSld38Qw+LD8GngFX0g3iyvlLVwRwY41wwx7simV35vxi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315964593"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315964593"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 11:20:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619736204"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619736204"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 23 Nov 2022 11:20:23 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 11:20:23 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 11:20:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 11:20:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRmCEYZNcp31VdtMeGgCRbe21T98jHVTVQnTKihITSyBB4L8FsbqvIqEXGcoU2jPS8dcgLIx3PiCG/E5Cwmj2mvddwflbDSWOrHqKZA8UOzwi5pE8lE/AoVOi4A5pWHPMxzAsgKNoiL7NY8VX2ZsXWESnvVREw23dEb07+pQM449kXT3Q9jtUYLsx+1FzWBXSxL7+iaowN47tHpL9URgx9Z0E1uzz9wffpBYguD4Y/nboV19fLnItVWU7kQVmBu9MIvns62Fto7wmAteajkCe5cCuqjcdChUaYLaYRm4U01nutg/qb0vBecqbCeq+wDqP5fk0NQkk9Rd6Xe0uLsTFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DrE3Chbg5AzrLEVYhOc+vdWCpcSBPzsJGffatDYqaSw=;
 b=RjXh66ebDUKsy7e0GW7E8wO6C9YmabDpmSPMnGt+6/1lJweIoxdZtgHYbjGz30BEE/9SKcytTqtJgSwtJwyawCg2AnGdWNatfVccQnzekQ9cc1hCJG1xZiee4BbjWgoivHxfvJLO11N0N35VqtXUZc5JuyVIKrD2EthboKGJFEbp6+uYeOIIAtiC18yXXNgSF8e7XhNQ7BQ40g0EDVRlkjCKPR9eDAyiNY/ltzitKC7yzJC5YVBygXqJJUa5MdemTWgtxSLo8ptJUWkwN+ky0zofrtn79OYAIjWxr0IpO8VuskQbFvd+1HIe5wq4EElJtpsoa5iE/1wB8ylFG6FaoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB6697.namprd11.prod.outlook.com (2603:10b6:510:1ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:20:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:20:20 +0000
Message-ID: <26b24a81-8147-de8f-65d4-6e4a01d0e90c@intel.com>
Date:   Wed, 23 Nov 2022 11:20:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 6/8] devlink: support directly reading from
 region memory
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
 <20221117220803.2773887-7-jacob.e.keller@intel.com>
 <20221118174957.7c672c75@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221118174957.7c672c75@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB6697:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d5a1ebc-4d40-43e1-90f9-08dacd87c343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQQkeVSvtdIxuwkEK5bve7O4oEXH9Qcx+MwhpkrNXDQFDi5eDIdWqUaKS36cSyPoWsvzYLZC8AlRJBqqEk1ndfte40H0I7UMtxhhLCO5BNLMUGI+FPniwbj0iDkQJhOeibFZmhpJDVFOwJrS6DcLpcgHXrKj5gUgg6TJ8IbCE86Eae1TKFhmTFW1F3LrUxTZxUXTKH6LiU+sUEXZOxD55dcHqMRuH7gp5K2XAknRoomY9Batj6qtNgr5fSN/jElNonZn53NEg1U+QaQx8CrdXnhmJfO6qHWMjMdJKLg3DgrNuiaSZxC68DUxE7jNnb4+ZlVbFuIWrurAErfaLw7qt9kipXUPJ2vzrG3sMdLk/naTRmVFz9gezeqRuvxolcc712P5aSpWKpfPaEvDc6Nab2IDPBiv47FXyCUJUoOVQkoYe3A41550QivZ5B7iwxYZBVbzb6f7vPEwO+ewvgebQ639E7OeG9qHIIiTlvwi1wFxs12NSsn0NsDM4SIuOmDBl2O+KTSInlM3SPNuBP0Oyz16sKq22tJTOxBR+32Ms+qrShgG5sABS+6/1U+qSmsUEBSrGr94jf2au0VKOpPvXOPw0TQML3y8GdLN5L1glLWJzoq6ODfRsoLcjtHyLjGyn9R1QPpHmYU6M5YatdLnfKnuohDogI/7Gq+jsLYyXodDNy35PXVDlHRS+KZ4mYKdnfrwNNBGWN1cb4mqcR/wK1f++GqOjAluVIN7wOOhdmA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(36756003)(31686004)(86362001)(6506007)(31696002)(53546011)(82960400001)(38100700002)(4744005)(66556008)(2906002)(83380400001)(8676002)(41300700001)(8936002)(316002)(186003)(26005)(66946007)(5660300002)(6512007)(4326008)(66476007)(6486002)(478600001)(6916009)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2lIZDlDakRTeEk1L0VzaHA3WEp2eDVjUFd1Qzd5K1NQQzYyQjlueDE4SXFY?=
 =?utf-8?B?cm5UTEZGRVBxMjJwSDJBeE1kcHdxSXFOTjU2TUd3bWJzV2RnRUpwb09id3hX?=
 =?utf-8?B?MUdrUlEyMlRFMExyVWpUWmc4RnRBMk55SUtZUS9JVXJaV0pSMUlqOFAxeDRt?=
 =?utf-8?B?Tm1TR2I2TU4rRUpEenlid0dtV1NhakREaVF2eHlUYVRUNjQwekJWcXJidHd6?=
 =?utf-8?B?WEJma3JTR0JrT29EUzFSdU5ZaXhRYUxkcG5PNjVYTEs0SXdmNnVYSHRYY0g1?=
 =?utf-8?B?WFJLNnlub0J4UXorMGwxVjVvMGR4Q0Rld0ZBcGN6NUlDMkJ6QmRtZVd4Z3FQ?=
 =?utf-8?B?Rm5FZGhub21la21KUk1MUW9IcnppS3N0U2pKYUZSQlgxOHFUc3JSSUthcXVq?=
 =?utf-8?B?ZXBVYXF3NlF5WEVSRTlhSnZRNkwybTNRdG5UZ2JmWW55clVReE9paUlhejZu?=
 =?utf-8?B?dW9EaUpTSFB0Mit5UWNMVDJsMGc4NDVDbjN3cGJZbDFLQzBNK20veDkvZ0I2?=
 =?utf-8?B?ZlJLZkE0MmQ5YkpyNG03djRRTXQvOE5jYm41bGRZRFJvRkRTMXdRSU9VWWtu?=
 =?utf-8?B?TUN3akRLKzFYSkM1ZWZ3QndYU2p6VWxDaTFUeGZDVUd5a0RWRy9rM0hmOE03?=
 =?utf-8?B?NjdzeVlhbHBGZW1zVUxhZVp4T05vKyt0emtCRUVYOHI0Z1FBQjBLVjJvUjlI?=
 =?utf-8?B?WENGWUl3N3hleGF1TlJSeTEwUVMvaG5tZUZZNkdKYTJPUjdreE9ybU9NS0hH?=
 =?utf-8?B?RUJNUSs0SGh3Ky83dXdZQ1phWHNzZ2tDRktyQVF3SndKWFBOZkVvSUkzNWwv?=
 =?utf-8?B?ZWtpTHZ2R1VrSFduRXJQMjJBWExUa1hJQytOZXZWVGdVTWsvNVJsRCtOclBu?=
 =?utf-8?B?MzQ4bHN0VUk1K1FaZFBpcFJKTU9iaXJ4YTlpNjNwR29lVUZDeEJpWG1obHlk?=
 =?utf-8?B?N3BNY1JqU1RKUVpUQVZ1UTFhbGVwblRybCtZTWdiUU5LYTZOUGlOOUhnMUl5?=
 =?utf-8?B?NXBYT0VldFliWVJhVS9Sem9GOC9KeU5mYm95TmlrR1AzVElpKzVWRWZtMjZk?=
 =?utf-8?B?dE4va0ZpK2FOMFl3UitFTmY0YUNRVnlmb3grMWdPNDBqM2R2dE5GTmFXeHNq?=
 =?utf-8?B?RzlsMDFyYWplMjhyYy9Vd3ZheWRQTEM1azNUZWJsYzVXWTlwS2JSSFBBUzdx?=
 =?utf-8?B?d1N4aVZ1ZktxamZzbzJqQVR4VmNJZHZUb3lGbE9zbzBNRUlyeStCV3BCTFVX?=
 =?utf-8?B?UFlGWXo0NDdpTVFpdHZaa1dVd2F5NkVHd0pWbEh2QVBsWTBTNGtvbmpXVGF6?=
 =?utf-8?B?ZzIzSkVoa0lkYkdwNmdMazNDYS8zeWt1YVZVUkNwZ1RIWlJtZUR0cjNTbUYy?=
 =?utf-8?B?YlN2RjBYTGg0RnJFMDQxaGY3Y1BNbU1wM2c5RUsxVFNzQ0ZQY045UFErclp1?=
 =?utf-8?B?MXFNcjVBTVVacFRpWVhuMFRrdFUvWmRLMldPVW5hWlBvQTd5NFRCdVRmRFRX?=
 =?utf-8?B?eVJuRnFqWGZ1aTAvU2FwbkpUdkJ2SjJFeWR4SmRrYUtJbHBsc2JXcmFoZmtR?=
 =?utf-8?B?QmQ1SzJucFp2UzVHRHhadWplTkxneWsrd3dFNk13ZXBuMTlRdnpkdENaYUdQ?=
 =?utf-8?B?di9uNjdYeENhYmE1b3M2SHcyQ1NyT3VveXQ0NVgxOVd2UDl1aVFwTUdiTXhl?=
 =?utf-8?B?aStoeEhOUkVYaGVpeXhmQjVOSG1lTmhGTzhSUS9WL1NjR1I5SUVBNmhOc3lS?=
 =?utf-8?B?SXVkYkNNWW0vYjhYUnJlT3RpaEtXbnE2eHBDN0dWWFlaNVpwTXJ2bWJzV0RO?=
 =?utf-8?B?Tm9acVZ4YlQvNmdYTS8wbVFTQmlwUDdaVGtibzF2NnhTWEFzaGNxYjYyV2N5?=
 =?utf-8?B?SzJwZ2I0ZmNqZmE0TVZFbHBvZWZ3dFM3QTEvMGc1ejF4YWkyenoyc3NtOExI?=
 =?utf-8?B?UjNJbGxValZkNlZMNlhDVDVwMkFLZzM0OHliNFN5bzJhWkh6VUJQY1hVRW42?=
 =?utf-8?B?S0VNdEtrR01tU1doNFRxMWhVR1Z2ZTdUb3hiOUhyMVJTaFBOTlFrdDkrNG5R?=
 =?utf-8?B?ZllTekt3QWZZSFNFSTJLUmR3ejJnajkramJNV3NvUjdtbThlZ1dXdGU3WUQw?=
 =?utf-8?B?ZnlRTm5kU2wvT0xwcCtreW5DVC9kU2k3N1FsZWtyNStDN1RaWk5KODA2c3A3?=
 =?utf-8?B?NXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5a1ebc-4d40-43e1-90f9-08dacd87c343
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:20:20.8641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwaZx4o73fgo4go2rfn8/FVG3klBzft3v3RKofBYPwMMEo4lBvTQ9psDbTfZnutL0cqS4GguzTOQ85fBT1VyRauCnhdvKaG8UUgbwa3HvII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6697
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2022 5:49 PM, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 14:08:01 -0800 Jacob Keller wrote:
>> +Regions may optionally allow directly reading from their contents without a
>> +snapshot. A driver wishing to enable this for a region should implement the
>> +``.read`` callback in the ``devlink_region_ops`` structure.
> 
> Perhaps worth adding that direct read has weaker atomicity guarantees
> than snapshot? User at the CLI level may not expect the read request
> to be broken up into smaller chunks.

Sure. I can expand on that.
