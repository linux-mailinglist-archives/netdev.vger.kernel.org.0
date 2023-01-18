Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44D672A3A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjARVR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjARVRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:17:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F4437579
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076628; x=1705612628;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tunVwpu6KlB+JG0OgxFaInS28/ffIHVAAsgBsieeH+A=;
  b=oH7ObdnI/Y16CtF0LPi1ekxxd1KMSL4HN90U6QdhoxPELgRj/vHloTJw
   hm5KTu6kOY2AQeQjdIUUnt949BHG8D4W2rVKtDtAy4YxZAAZrr2oY7zx7
   L+6To2dKMPxM5tTHbDZmZrtop1lvyrEwi1pIu2bd8txDOAw1KDs5SfEih
   WLTsoX7nJl5HTgWHXaKf5zpfRRzaNCujZMXhVDGIA221uP8phECVtsCPD
   2pGl4QNaedyfVp1aKqliwx/UlN1XvS7Ao7DpAsod/JeNH5zSrwaTPc8MD
   N7WC8ihu+NlSs7WcocsszEMLAgBdendNywFDHHKRsopI6cyLNx5stYS1Q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="326368807"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="326368807"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:17:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="728388041"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="728388041"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jan 2023 13:17:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:17:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:17:05 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:17:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBd7HcFsbnBayDBfHVkPjUCmnS6FAWUw6rmKSSIaYG0GSX2KkV4mV6t+rS0lh4CWdpkkGMYVkSU+R8mjKmHUcgE30M4uKImJ+GolabFUifn3PV7tX6pgT3k1mFEiRj4ZekOcr0uL5v6YGTQPxMwGXsBWtbw8DYFES6dfyYX/lm3tp8AzxPodJMZ76quKJ6ttF2Ui36TGhxVYJiEZI5eM3/FJEeI1jiNqf+JoVmKz7eirfJ/CYCH2nN2PftBD11kLAlT7q3/SHm9EZZojyTUNUgOtpWwarW01noS0pCM3tAbNwJxyaSPa/BcQAzfPBg9PkQdraRLEcU/7RrGu9J1IcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KIxr38PU+hnkteceVruIrplUTFreip863mF1cw6jMiY=;
 b=iXQ8AqM03LZChSQSxxjpXfoP4qWPmNhaA4n/yK8dlnw23S8UtI7WN1Q7P6FdivrsTz7BhRv95pr+7DW3FXz3gzAGGxJTarh97ZmaAFniJRJPqcF4He5wm3SHIdmMcLzYdMLj7VS1SJ7PZ6IRbw8JzgHVnGTmyc5I6psftQkonTzX5r6RaqNGSR24pUPb5q4hE6Mch1b2LapvAkSFwJpHp1tE+ZXBSgFm6yHcqcvM1fzm7m6N2r1Cvn5nK5JPFQQTbwItKJV3L08WroWqQuukWbMfOuSOhyq8XKWpp1uwny3T7yyTDSTnocznenPKYoHT3VdNJdbp7aM+Jd9fU8ooHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:17:02 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:17:02 +0000
Message-ID: <0c4fb7d4-904b-9a60-54da-865e58e7ea35@intel.com>
Date:   Wed, 18 Jan 2023 13:16:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 04/12] net/mlx5: Remove MLX5E_LOCKED_FLOW flag
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-5-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-5-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::32) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f772939-c17c-4736-77e0-08daf99957c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVryafflnmA37E6VMydhQS1+LGKmhS7OKVQICdvrATZVwMLQ9QeqZaugf5Rpi2xeU9mmnx4gV6tzbXAK6ad9SuNmdkABukGagH6UxhX3wXRyKvSNxfGuwnjG+JmTyEtd6XqmhKWM4PJgegiI9tJNwpmFWWltqdM/hofjnayfu4AXqMFVAYtIujJr2dBX1yFYm/9qeObHzHloqtgL7OBiuHl6rWi/QXimjH294L3c6PlQRZ2CqDts1phFQKQNS0JzYP7GkNYcMEzj0fB4p2Szo3U5Q+h2KwZXWA1KRhQLTMUoStdxvmLQOwlLP6W6ela7N3HDZ57ckJjdK9pH+mP+rBvb6S21/ANBJY12LV264O10rpzphMq0RzY5l5lkIcLpFxewjI6TQj7AabKvAh8Xc8T6Un3kh3J4dpNAcpsBxS92C1J//sy/cv/BkRbBljzI7F9/7EPju/f6inyZIYivJIwpFfK00InZDVkQEaJZzWqBE6hipHFP+Bxs/aKtoz0/MEXJRc/tkTQV2brhkClmKzAsHlfWI1wrCrIBBx3jc5mBQsMAFUF3QBi6gU23S+eJaPel5OYKU8cCpMROZjC6zX5E9dUdELJTJrH/wRVRawxvoT0BDJ5GcEvsg7DWO/nCZ4wNnZYqEI+MZje6Q7CFVe1E/96jxbpvKR3GnQdyOkfX3TYFF5orVwTB01Hmc4DAxV5KaWmRTBwQLPAGLe18SgNFfaVQsNkJqukH0pgrYLI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(2906002)(82960400001)(38100700002)(31686004)(31696002)(36756003)(86362001)(558084003)(316002)(2616005)(7416002)(66946007)(66556008)(6506007)(83380400001)(5660300002)(41300700001)(4326008)(6486002)(26005)(53546011)(478600001)(186003)(8936002)(66476007)(8676002)(6512007)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEFIbldwVU4xWWprSVpEbGlkTGMzdVRjN0lIS043V1hZanVjYnJIekZlc2h5?=
 =?utf-8?B?aUkwbHV1ekpTZDNuenNYRUpkY3k2Y0JWa1ZwZHEzMlgxVHM0WjNEUjkvd0V4?=
 =?utf-8?B?VzRhSlhacHNJVHl3YTc5VjVLbjlnZlFUTjJRVVNwQXJzLzNXQUROUW9ualBi?=
 =?utf-8?B?TXluR3RuQjlxbDNmRURTaGMxeHRUUlFWck9qNkt5T2x6Y3d5UVJvbG8yZ04w?=
 =?utf-8?B?ZmVzVHozbVNsTXE4Nm9rakdLMkpkTWI2Yktrc3Q4L2w2S1V5YWxzY1duNlhS?=
 =?utf-8?B?UUZNVmEyMmlINUhQVlp5d0RwUVE0MmpqRG9QZTMydXphYk1VVy96TGpEbmVm?=
 =?utf-8?B?MGtHOHdnR3k2UVJJcGRPdSt3QVY0OXZOQTZ1K0hZUEhDeXNSQWczdUVmcjM4?=
 =?utf-8?B?UjBxUENwdHJLNnRzYWozMmtIakNsYTloTTU3KytEd2JkY1dJWEIwR0M5QXBL?=
 =?utf-8?B?RnFtUEQyZ2Foemc4K0hDYkdId2NvWDh6VnIxQ2FYYnFvcUZXcnJabkFKYVBt?=
 =?utf-8?B?YkZqb3haWmpvU1RhMzMyZWNYbUc5WWNZVTkyMGlMd2I5bVZFNzEyK1dGdWZB?=
 =?utf-8?B?MmZoTXBJdUk5NjhMd0l3dGp3dGlIN01lRVZ6NzRaVGhzUmtQa1I2U2RwWXhV?=
 =?utf-8?B?a25lTFhIZVA4TWdyNTFrN2tCcldRQXBaVFFiaHEreTQ1RFNrb1Bla3BBYTF2?=
 =?utf-8?B?alRud2xEalBsN2lkc0ZwQjZyeVNpWUcrMUJpczVKY3JwUUEvZEFzd0l2U2RB?=
 =?utf-8?B?L1ZwMVJMaTdzVTVLL2tSYjhCaXRoN2pUVlA1TC9lNGdaRVVPbVphQ2tPT3lN?=
 =?utf-8?B?WUxmZEk1Yy9objdmMVcrL2g4T2xFOWcwY3N6SEtvVi8xV0NSTXlUUVd3dGhN?=
 =?utf-8?B?UlRtTkVucnYvNGh6OXo3K3dkTDRVbnFjZERJQitFckEvVnk0U2tBaXJXb0FP?=
 =?utf-8?B?djF3REpOVmdtTmdLY2hpcG4xbEZXVXdzaVZrNVo0K3J2dmRjU255aDNPUVB5?=
 =?utf-8?B?bUNYSWI4WlNIK2FCUDR0cjdWQU94czZ2Tk1GMmF5U04rTnZXdmw0Y2FKUk5D?=
 =?utf-8?B?c00vbnREMkxpMDFPc00zQjFkQ3FWUGhNODVJbG5TN1JKdzRvclRMRkpWNjZY?=
 =?utf-8?B?ODMzczJPZjQ4cnhuLzJEaHRsRCtuZ3p4TUtrcC8vQU0vTDVtR0JFWlY0VDFK?=
 =?utf-8?B?WXNlWi80dU1JOHROV3lDNW9ydHpyWnRTb1ZNNHZNWkJuZUlvRXJmQnF4Q1Mz?=
 =?utf-8?B?NXVKTVhpVVhicFVObTBUN2IxZHYzVXpJa3hGdGcvcnU4QlkweEIvdThka2NE?=
 =?utf-8?B?Tm4rT2cxN1N5TEZWU2E0R00zMzNTN0c1aHFOU3JUdk1jYnEwR2ZRNUN1U3dS?=
 =?utf-8?B?Y21ZcCtkSU5BVmZ5MTMwSVdnNlFnRVJrRy9SbHYrcGJrYmRxdGgwQklNcTZI?=
 =?utf-8?B?MEcwWEFVSTVzcEZkL29ITEhFN2RLSmhlR2ZvRXFHWVVzZ0prOVc2NWlyMThH?=
 =?utf-8?B?Y28xRllrQzMraVE2eXBNU01sU21kSEwrM1p1UkVpZ0lTNFMrL0dkd0RUYjUx?=
 =?utf-8?B?WWEzRmhNcXNZdmc0Snd4T2Y1S3UxSXJYTy9YVS9mVHFQc1BGMXF1d3Z2U2xC?=
 =?utf-8?B?UnFJbHRqSWRPSERjQ3VmVkdUNGN6U3hWSGZUYlpJejl3WHVzU3JDdWZqY3J5?=
 =?utf-8?B?TktLSEZZRFE3ZWpXNmI2aXFzb29NaTFOMFQ4L2hZYU1jQnJRWjZuU3pXUVNH?=
 =?utf-8?B?NWtteithdmtpcXR5UUo4a3lrM0Y4RFVyVGQvdFRGajZjNk85SnBINy9iUTVa?=
 =?utf-8?B?R0dzdytyWktaaUJWRDd4TzNnemxyb3crdU92ODVhT2ZiVFNoYThiZnFOWk94?=
 =?utf-8?B?cDlqNnRzNUg0Mk5JNFlWUmhGbGJRQkcxd2lwc2RJV0Jjb09jcitnYjlCalN1?=
 =?utf-8?B?amtFaEtWMHNzaVd1MmRZK2xyQWo5NDc5cXE5bWhEN2VkWFY1Vk5XVHdZT2c1?=
 =?utf-8?B?MURLZlh2M0dBRHNXdEF6NERmNk93V0FRY24zU0MxYTMwazMrWHlqRjBtOVds?=
 =?utf-8?B?Z21RWERCcFV1RWRGQTVYbG1zcTZJZ2dvQWxRNmRkbUhCMThVdHBqdkVxb1o3?=
 =?utf-8?B?QXF3WUtFLytaSmpyS3JRaEFRM01rWmRSYTczSmI1RzBBRE1qRTNFZi9KSEhT?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f772939-c17c-4736-77e0-08daf99957c4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:17:02.7901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SmsfEafLugcn+JMpmSS73/IIuzZNeE150RFCy0sCY66GtVPvw7UIdS5WhF2AjPqi11TVMVdNVtBxQYkIg04QvFQMXqNeOHqY2sRfD4zhmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7381
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The MLX5E_LOCKED_FLOW flag is not checked anywhere now so remove it
> entirely.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
