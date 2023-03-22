Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704EB6C57BB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjCVUe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjCVUeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:34:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC48848EE
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 13:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679516732; x=1711052732;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fudQqmbne9mWBTqJM9URFl8OtxlDdh9rkhtCbMjTTww=;
  b=ckD0FdI/yGNtY+eb86yqEsXU2IcFobIVr7QKXW86/9mCUcEwDACwD2eC
   z1io8fl+3kmXu4YpFRptbGmxood3y0TWlc6dEQWsLC4UKhnIl80Kkefs9
   LaoN9Acf54LXDgRFBAV5RKQSvmPwZ3NQseqVpkJX6onzw3Akt3iMvMo7D
   jE6uDFiswpacDmQ7Uf7MYkWk7ELWrbyLsajzULXf7BpPb6U5npzb3DL1M
   N1uz45FbNyK3PaBdQuSeLCEuIvqN/jO7Lu1MAVa1p3ZF6T580SCtq5p3r
   W9y6Sh8KR9lox3eINUla8E96bJ62LKl2u5djptooZVLy39bsFCKQhwOHL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="341683280"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="341683280"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 13:24:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="805989754"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="805989754"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 22 Mar 2023 13:24:31 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 13:24:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 13:24:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 13:24:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 13:24:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjeQ6k9RLUKwnD+sj3c//sj7dnzEWGjVKcaBZZTE05HrkhZ9dv7jHUzoRHm7W8ZeFVjl7av5gznXIv8MfQu2fPmJRQM2z0+3byW/IsvdYe8KooJbh42BMAcSTI7M7ONbnRiOMIBZP/H/J8D3qA/TXvtkp1/uz8FG5rF8Wct0XwCQfaVxTtz+WsT1CbUL0GDU9+T9o1FANy+7AerwaYKIg5o+tUp4tph1AIHyJgZ+eOjUZK6O5seX6GclcJ6vvXoXliBuTwlqulV37XdQjvaLLa9oZwcPTzGbgy2pyysWnmXeOz6TNGOeuKnhX9uTBAbHyLXbfBcikDflk1cO6nCPeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16t501F/LVF0OQ39YU82HWYPIUdrzjShPzMI0IMEjz8=;
 b=lQ9xvzmUbNa6cWRb2pjwBE8DmiXBVlTv3pUGWUyOr6xka9zIeyw46o96u85CiERkHsUrOnd8Nc9mTKFXtonCbAJakV+sMwVXriTWrcK8S/ePJaOlFi0+fsvjz419B85zHKpCyZsHROlz07zn7DvOB8yCTL5A/x6w+APceqANqvUNtLAXG8Qf0N9eQsOzs/7k0mQhKhbWQbx6FOXEFJcDzAxZzOJ9Tnc3r2WhYtXV1UkBFExUqG2qs0Nbyy+n0WU63n7SmET+Br4zm2Qit8xdJejhZtSDX3ni+QS3vMxIvWs8cs86F0Hk+TZMijJoE3trqLZW5r85yvI5xDPn7tfJRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by SJ0PR11MB5037.namprd11.prod.outlook.com (2603:10b6:a03:2ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:24:28 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::9612:ae25:42a4:cfd6]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::9612:ae25:42a4:cfd6%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:24:28 +0000
Message-ID: <6c2fc025-007b-8207-ad46-8a9662e5f7f9@intel.com>
Date:   Wed, 22 Mar 2023 13:24:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [pull request][net-next 00/14] mlx5 updates 2023-03-20
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230320175144.153187-1-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230320175144.153187-1-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::28) To PH0PR11MB5095.namprd11.prod.outlook.com
 (2603:10b6:510:3b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5095:EE_|SJ0PR11MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ee9bf0f-34ee-47f5-f574-08db2b136fa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LlVLqFlfs4IZ6OX/N9H3GzesUOuQAcmDNLM5Ao2Ficd2Qgqq3iHyiKedJC3OFIqWD1in8qJ8Et6hwA4BC5CvEm6JjqMSW8t6qB/7yOODhlac1Ox2WoZx5GgNaB6puqUCCHjN46dpHoIaRVMtiEn9AzCBopxSmxY4fhLb3ZTN4QY+DUiwEjeAlVWNI466nfPqemaPeM1DAl6Cq2FlQinLMfm2mAaQ/SPqkj5ZMQwfDUyleEr2tOWoxW//5cn8tktiilhJWwYcFldBTSBbfgqLUqaGRUS3mXQ8sYn/0cdZevmqsWhTbBDYCB3c+NK0Ha4GVPei/S1dSPROMOxSbgaCTNsDKZHZrBHHcvvU/eqNpHyZatGn+qJZIC5xHi15kGABuqWAkf3HQ0prDdjMWgqlxLIxhk9XDBQRld7Bxw7CYzh3WALtUygnRxvNRbAS9zWzzIGhhcEKauk/x7/keNIWyZmX89MCwqPsLkc+fBloODPu3BJc7V/yOw+EYPQ8H+0HMNoK0kdrlxZNjuob1xB8XEjgC0y6bUhbVOz/cY68lwrN3px9nm03FW1yTkyWy0pOEkNS071JII4USd8fu/5ktQMLKR4ES5Wfcchk6VXj3SascGNCosfv7niC1Ll+05/dCRAbxDsN4em/m5ITxpT/EK6zGQaubXmNa8Ib8cwcrprIaHgDTt7zfyomWVUvvrbDAcNuVJP0hTQk/p9lMM3UNK8j3pn2cjycOTwYV2scCU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199018)(86362001)(2616005)(31686004)(82960400001)(6506007)(6486002)(6512007)(26005)(53546011)(83380400001)(186003)(38100700002)(31696002)(110136005)(2906002)(478600001)(8676002)(54906003)(41300700001)(4744005)(316002)(66476007)(8936002)(66946007)(36756003)(4326008)(5660300002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTMwR1hpQjYvQ0o0T1BWVnl3MTZKd0RSdVBwVFFKSnU1cCtnelh4ZmxMMlYw?=
 =?utf-8?B?VkJTb3dnUlQzMDNmTWJxRkk0MkppUXp2NnhOd0FINi80Vmgvc3lkamtZZXFX?=
 =?utf-8?B?U054Slk4cEgzZFVQQm53VlRzaWFJQzVaOVZaZVpXRVVTVC9Vc3RUdHdZeEpr?=
 =?utf-8?B?aEl5U24yVklOdW54OHNwZ3pqalU0NGh3NUFZbm9BQVdmMld2WFQrTXAvZURQ?=
 =?utf-8?B?RHQwdkZLWDFhNnpPSFlUckhaaUJoM3pYclNNQVB5Z2ZlbDJxRDVtWmZLMFVT?=
 =?utf-8?B?UWs0NS9JTThvOFZtOGZxSUhqRTdnVURXSmszakFNMkxnclpaMC9yRFNzcW9L?=
 =?utf-8?B?cWNnZFJRRGFrMzhDM1ZLcUZzdWc5VWI0OVJzOXZUSkZIR1hPejBrK1J5cENm?=
 =?utf-8?B?cWN3d3hKVUIvVzhzRFhMSTFHNldiQXFpbEpmVW9tczZPWUtZNkxxcjVkOXM2?=
 =?utf-8?B?MkJsT3EySmFiYU1RQW50dnVYUy9pbm90cXU0MVIzcmlPNVI0VURvaDdFM1Ra?=
 =?utf-8?B?OFZsMjlpcVBxenFDY0p1TVlZR0lQVmFSUXJEOVY4KzJmek9SMllqd09GTk1T?=
 =?utf-8?B?ckQxWlc4ZnJXWUx5N21OUi9zNVh0bmxxY0NKOFhqQWt5d2JmczEvY3BHVmNY?=
 =?utf-8?B?Y3RhMDNXeERMbUNUN0JQUDdoUjVSMnBHWHZ3THR4amVEcTk5QlNQOElWSnQr?=
 =?utf-8?B?ZWpLVFpSZjZHaDhqNFY3cFJOaGlxdTR0WXlXYi9EVGpnLzVMTmw1NjFVdEEr?=
 =?utf-8?B?aXdDaktId1c2VXUxNmsvK0t0UFVGMWFMRU1pUGtkUTZQYm1uSEtaNFd4SHNG?=
 =?utf-8?B?Q2syQnJ6dkhXekpaUzN0VkY2Uml0Ukl5N3NtV2lWNWQycjlEd3Z4b2RDd1p2?=
 =?utf-8?B?d0p0MjFQZzVLVjYwVVNwZkFlTldCUE9NaG5PWU9ZMnpaZ3d0dTJ2ejlsaWJt?=
 =?utf-8?B?MXJQTzlXVUFlYVFPUXZxVzZKdm5McFFpUFZQa1hGUmVRbnI0TVFnQ2tnbkpt?=
 =?utf-8?B?VkZjZ255bXZmRFpRbVZUYzVkWXhiVkNscG9TenU4dHV2N2FPY1hRTFhIR3Bx?=
 =?utf-8?B?MGVsdXBSamFITU9TTkNvaGpKTCtQWlZhRlF6ckhYeFVUZkozNjNycG1OMXFs?=
 =?utf-8?B?alAwSG56VG9iaXE1THVSNGxFdWU0RXB1YlREamxpM3htNGU2V0tnTU1jT1BN?=
 =?utf-8?B?dVFJc1doVzBCVG10VHdFRkxMWkJmUXZKMG1STnhTUlplNlQrMFZnZElHVXEw?=
 =?utf-8?B?alF1cFFUcUs2d0cyVnNQWmdxSER4cVgyczB4L2hkYjhEK2FpTVY1OGJUNWtV?=
 =?utf-8?B?aHhnanRaTWVscFZKSklJTVNlRkhPcnRMWCs2OTgvMjRxdUNFcUptWHBZUFVi?=
 =?utf-8?B?ckNMblh0Rm1Wd1hKOFhQR2h4Ri96SC9JeXozMHA5SXJhMFhWd3ArM2plMEFB?=
 =?utf-8?B?dUtHT1liOXZvR0g3THd3WHNOaFlUZmdPclF2RlY3dmRIK0ZhdGRVeWN2NmtK?=
 =?utf-8?B?MldYVFNnQjlLeGIzZ3ZZK3lYQWowc2FIb0pWb3RBMmNDUER4UUZ5a0FHVGUv?=
 =?utf-8?B?ZnF1RHRrVG8vcWZDSFhlVEpHQ2Z1ZXZLNm9mc2pxaFN0WDlNZmVIVC8zWm5B?=
 =?utf-8?B?ekxFenlhcXNSUXM3LzN2bHhZNnFJc29hYjJYN1U3ZFY1R0xERUFKRWlTREQ2?=
 =?utf-8?B?Yjk5Z21ia3FOUTBvY3RHRGlmOHlxNFZsZDVzTlJRSlVja1BnZEU5d1hWWWJh?=
 =?utf-8?B?cGNTRWVUL2YxakVqZUc2blkvYXZQMkJ2Ris3UUx6Z1JsNmorN09QRWFaQXZ3?=
 =?utf-8?B?UWJOSC8ySlZXMFZobXRNcG52RkNOTFZCUFBpUkZsK3F2Z1BRb3BDWXI0WWNK?=
 =?utf-8?B?TS84VmhrV3psRTA0c0E5T0JsV0V1QVdpdjNCVlByUkIrYUtrZ2I1UGdWLzVK?=
 =?utf-8?B?UnZpUTk3RVk2QlU5T0pEb0xUMFU4R09YQ000a0JUSXF0cDQvZHpDSklkbjcy?=
 =?utf-8?B?WmhYNVZUbk96V0IrZ2laa3Vnc3piRmxLSUhjRnhFLy85VHFOVG5UdXlEYlJ3?=
 =?utf-8?B?VGQ5S3hFRVRiZ3NONitWQWJJbHg3ckxjdUNweCtITHR2ODNnbHlXS3Rmbm9B?=
 =?utf-8?B?MFY3NngybGVoalM2Rlh0aGhMMUloU2YreHBHM2RXVDZVc3EyMmJrT3JnR3Zw?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee9bf0f-34ee-47f5-f574-08db2b136fa9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:24:28.3026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmzOi74Ch3MGMEBezJPrIjDth1k26liE+e8GGD9b3rUWd4rOND0BMMdqkhdHqAykU94E6cAhUtUpFuzLQ+PNBkrxomiao89JV+r6bnlRFsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/2023 10:51 AM, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This series from Eli, adds the support for dynamic msix and irq vector
> allocation in mlx5, required for mlx5 vdpa posted interrupt feature [1].
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Thanks,
> Saeed.
> 

I read through the whole series and it makes sense to me. Nice that you
already have a pool structure which is suitable to allow dynamic
allocation without significant changes.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
