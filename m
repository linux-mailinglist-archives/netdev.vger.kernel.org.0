Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B8159C35D
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbiHVPsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiHVPsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:48:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D66BD2;
        Mon, 22 Aug 2022 08:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661183297; x=1692719297;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=paVngW/lRJb/g++TLAaQKYEYJyoXqsh7A43Zi4UOBUM=;
  b=QQIaWRPepJQZQwhI/ugf7uxGC1PD8eZJ62IvuFtCCa1Gr5bnKTlI8Xsb
   SJi/PnAuixl8n9lexyFa79SYfpm2SYfoEwQichXWOxCdCi61HsA8Orzb5
   pNXOEBkgCtBaOouS/mstOed7Vy18UOuO5QqUsX/hPYBNL2kuEKC36mVrE
   1L3Cod+lCRMOEzQaDsVEj8jhlsSurpNmpqf9XtP7Mxg4eqQ7VV/6vnEmF
   5OvRto3zfs13XegTSFvAamGhbuQsFAJrOd0Iw/cuEoYLSecVTyoFzLorO
   j6SOoTL/43azAKm1uLWdyHJdijx3BdXT0oCLtSA5AaQg7mG7rQF+jfxQF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="379739395"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="379739395"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 08:48:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="677261627"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 22 Aug 2022 08:48:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 08:48:16 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 08:48:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 08:48:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 08:48:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuplCnwjkUglUD/asRjwJLCLgqFdXVyFPk1t+Ormql211zSdNuh2GN88DYzrzWq2qB/3rGnv/MGYPQ+wSHm+sqXVIM645OcbO4KAHO/Odp+qH6XJVWoiQGul+vW92Cy/58Fq24CbaC/37SA6mOKn7Fz3yA4vXSZbPfFuX+RaGEOFWt/Sn9vAS/9WFlRS0AVi2Ej0P/Grq3RmNSHwm/linoN/IlSoeIlTq8vB6J4tiDGrqRDCD6/+B5G36DQaBcykAvlp1M7AWP7G4pxpypLiojfhcTjXDfPbVkuJIquvQr1PpYO7IGw+sEUbx2wekvsYt5H5RDM+v/bq+jrWmvXgMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyB39gG/0R3oKpsrDjR3DNO2BjU/WrZ8wlVJOP9vx/w=;
 b=M3bq3ezvP3QHL86DObJwYz+NS5OGnvPoE7Z+PcYeOt6TVLba2AR3F4WkHzcLkBkTI/0Fzn6MIMGuwGFd/PC4fhca6pfOODxaH0oZ5g8TwKRXgd6cl6Af/LLTLT1uQu2KhXTvgHQb6l6GPVnWbIJ5gbtYHBFn0KBu5heXsS+YLvrNYF2HpA7knxPwglT0lq2mucPxXiJTAXHQK2gdQ4bsyJhFztm+s9w7kP2g2uFs9GQSvYt8uz+96pF+xIdOfx311A7c6jQHyscv/gDtUZmvap4R/eXvFz5PoCMmNOUEk2knzfOlssgL4+PlJATSpUW/qPdosTn7/ryNUeYBpsxwtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8)
 by CH0PR11MB5250.namprd11.prod.outlook.com (2603:10b6:610:e1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Mon, 22 Aug
 2022 15:48:14 +0000
Received: from CO1PR11MB4882.namprd11.prod.outlook.com
 ([fe80::d51a:c6b1:91e9:b1a6]) by CO1PR11MB4882.namprd11.prod.outlook.com
 ([fe80::d51a:c6b1:91e9:b1a6%4]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 15:48:14 +0000
Message-ID: <5b397d3b-5a5d-e226-dc47-f4333a9cacf9@intel.com>
Date:   Mon, 22 Aug 2022 10:48:10 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 0/2] net: ethtool add VxLAN to the NFC API
Content-Language: en-US
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <idosch@nvidia.com>,
        <linux@rempel-privat.de>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        "Nambiar, Amritha" <amritha.nambiar@intel.com>
References: <20220817143538.43717-1-huangguangbin2@huawei.com>
 <20220817111656.7f4afaf3@kernel.org>
 <5062c7ae-3415-adf6-6488-f9a05177d2c2@huawei.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <5062c7ae-3415-adf6-6488-f9a05177d2c2@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:a03:331::22) To CO1PR11MB4882.namprd11.prod.outlook.com
 (2603:10b6:303:97::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 779a3033-ef68-40bc-e609-08da8455b956
X-MS-TrafficTypeDiagnostic: CH0PR11MB5250:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiaYfLp5trQ/0yqbvcqt6C7N6tCHrpX9M1V6fSO9/ntxdQTH4jqyUh+wh5R6FLxin0cl/pikEQyBuPcEkBmBfakhNNGTm0ccjn+g2IF5f5ipDbcRAaP5gMBMBUBe8baiikMzGfLf09Pz2gK9KnT4KGIcbw+QVQxak9JnkBSpP7Ac1onKU2R8FXyxqirmXzepqIc1xmNV2e4kGHd7FVzp94X0CO3nnSqmfqfJl2ZsVKm3vKgmuPtfeopRrMp+0WsBvFNgq7nzqrEXGcdtP13o6v5XLiXo6QiS+pWvU7mukfHDRVbkfjYzAxMwKGjTOrBhtNsQmzbQlM0bL7KWe8zGPZaIx5hGz6fHT2tgQv1u7XMw3BJmfl49sQWCiRsT8zS5yPOk68Wl2UScsqVLVftfCTy2paNi9TI5mO6OomA73aTVflVkTUxSd7j1N3eVGfYR3l85XrXCeoxnacKNEy2cA0Z3EJHDUyIV+/DoQpPrRzd0gP79FMqN/VcmSy2mBWaXIORw5OwMwPAwHyUevozNvyBoaMAPpR4daU66jTIHa3LIJB52RwufsLo+jodI+an9oqfpME695HHtqRM1tLsX6EulUK6mPhnuwRP1viSvT8ED3fh5DhLls1iPeevjWuQ6bXwviqDdRzKU2dt+MaFnY2WEFvG6uM2vxC/RF7MSjApurJOWJ+oMM/chMnkJ9aUwhKxiR5n6AgnJFjfGgeg+1mWEG8UU2i+pnAjFQ9URDcMyfyjIQe+OIjzTELlm3bRALoddXfrcZmjtqCXoYB+lzVOSJZv65B3eU8fza/IT9DVC17XKqgICJWlIMx6aq6Ly
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4882.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(136003)(396003)(39860400002)(346002)(186003)(2616005)(110136005)(36756003)(31686004)(8676002)(66476007)(66556008)(316002)(66946007)(4326008)(2906002)(31696002)(53546011)(4744005)(6506007)(26005)(6512007)(5660300002)(8936002)(478600001)(6486002)(966005)(41300700001)(7416002)(38100700002)(107886003)(6666004)(86362001)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0IweTRxSkVzczBKNWZBUlFjRjFjTjRGUmZYRXlpTjRxdDQ1blpKSk5TckNk?=
 =?utf-8?B?QUVKRnp5UG5DNElxZHZVNS9DVVMzMkZyU2dxMmMxUGpqT2s3Mmh5dXVSMlZj?=
 =?utf-8?B?eXFkN2dvWUV0TlFxcXVFbG9Hc0dUL1Y0WXNUQlA1U04yRzl0RkNVRHJJRG0v?=
 =?utf-8?B?SndVS21pbHJPQlNWR2FNYllTNjdEZXhzS3NuTnpac1FIVFNKcTc1MUQxMTdR?=
 =?utf-8?B?VllBaEUvM2czRytKNWp3VkNDWjB2T1p5Y2kxTmp5RGswVGZLdysxZTE5VDBM?=
 =?utf-8?B?MCt4Tlp3dFJkMEU0cFhDOVdmb05KOTJBOElkdm41ODN1WlJ4WFFpZDBFUHlH?=
 =?utf-8?B?ZDBJNjIzSExuOGttbXdtVEUxN0RWQmpoZnQrU3dBRU1sYlY1bnBhVHlNNzZj?=
 =?utf-8?B?T2VleWEzMHJJR3pnZWoxWmNKZHY5SEVzVmxRUnBZOG9KNHc5aGR3V2hESWd5?=
 =?utf-8?B?WVhqV2htaGpHZHp0UUZtZHl3S3MzSFJ2K3lCTlVqRjhaa29oQWhaSHBEaTkv?=
 =?utf-8?B?Z3B4SVNkZFY2MVVIUjZDbDNEN1pwYW5LcVFXbXNDdzBjY1BGa0M5dGhrVVpD?=
 =?utf-8?B?Q0wxeVh0WUY1WFF2cndscnRkTzBiVklsUTg4U1VGN1dNdS9JaUJxakx5Zm5O?=
 =?utf-8?B?S3JpZzNzaG55dkNJUkUzNmM1end6ZFZBZDVjei9sMUY2a1huSzQzTXNwZFd1?=
 =?utf-8?B?UnBXcHVGcVl4N2Z0TGpsQkxXU0ptNlFCc0U2Tks0c3Z6STh0VGVxSjZmb0xP?=
 =?utf-8?B?Y0dxY3l1dHZkSXpyVXowT1hKNVlSTWNGRlU5aFRZR3RoamxzY0JlMkQyMElq?=
 =?utf-8?B?YVZVa2NUc2xGc05zd295QVRFWHBFOVAyOGdEdWw4bjc1a3VTbmVJVHdTajZs?=
 =?utf-8?B?UnRwa3VMT1FFcHpIcEFpNEkwQUhFQlZ5WVRjNVMybUxSRnBGbncyT3FHNVR6?=
 =?utf-8?B?bjlhVkV4dkF2MEt2czV3alY3Nk9jSjI5K3pkMzlDTmp4SUVvOEJsdlNJdHF2?=
 =?utf-8?B?MHJiRDZnYmM1ZW1mQnB3Q05ER2wrdTNISk9wSHUzMUwxT1JrNmloWm1IZE9H?=
 =?utf-8?B?MWlJLzRRWGUya2x2Mk4yYXVZenRmcFJZL2oxK2JCSjZmRmZsVWJkZHBOdWV4?=
 =?utf-8?B?V0M1NHBvSit2S1dQTEFwTlJBSXZkMVhSeWxGYmIzMDZMV29LWjgxUFAycGlC?=
 =?utf-8?B?MjVHMllGcTQ4cUdxbXdQNnJPR09xY2tzd25MeG9zN1lKUzJoSWZjZkVtbzF2?=
 =?utf-8?B?Sng5RDdiNnVGUFNXWVRmeHRsWWFSYnAwWk5JMXdHQk5jZ2VhSGNCVmhKazBX?=
 =?utf-8?B?eTNBSE5PRnBnb1VIQ016MkU5TDF2cS9mRFF5YUE2SjlnR2ttN2lpSzRSSG1S?=
 =?utf-8?B?M0tOOXMzZktYTmdZcG5PdWtLTXpHVDBmbkNXS3Z3Q1llMzNXQXRqeEVyak16?=
 =?utf-8?B?a1pmWGg4MHBMdjlSR3FESDRFa1J4TFRieTkrTFJmK2JsMmhmSXpRakFOV1lF?=
 =?utf-8?B?NWpST3drTFVSOFphNERkVjVmWndDUFgweFZCT1B1OTh3TnBmaUhkMitDMXZu?=
 =?utf-8?B?eituSHRhV3FhTktKbzNOSnlaUlpsVGRoWDhDVnNSaENBb01PYVIrdlA0ck1R?=
 =?utf-8?B?cFM2TXEraE1xSkZabkYzYzlQd1EramJON0dVaER2VWp2NlVTdFlrazR5VkV6?=
 =?utf-8?B?bVBOVnhuNGxlRzcrUThOYVM2WTZra01PVzg2VUxIK2VFOXdaMHdZOXZxVHRW?=
 =?utf-8?B?SjNUb0V2aVV6a1VDaW1lbUdxT0RHUFFmN2tMUFlZeUZWdHF0R2pNampmSmpD?=
 =?utf-8?B?cDV4MWl3MmtUME44SG5HV0xlaGN0Q2JCcExuajFQNXZBNjZUQy9QOHFwMW1s?=
 =?utf-8?B?S3hFc1hwQ3FPcDlGL3VGSmpqR2pCSENvN1RzckRUQjVHbUdQT3I4VnhsSG5K?=
 =?utf-8?B?ZkZpQUhoL3prbGFSQ0NwUGlvYkQ3TmJ0S3VXWHRXclhGWmxRamNLVDJnUkZ4?=
 =?utf-8?B?T3IxK3dvZktlRXFNNXIyYTRvc1ZDa0VWWG9CVXZTTCtBSTBGeXJaaHcrc1Fa?=
 =?utf-8?B?N0hYTjJTZEZZSndzMzZldThjOVJlNkZTaTF0NkFHQmZkZDVvVUordTF5OUE3?=
 =?utf-8?B?SEZaRFAzdy9CTUNZN3kxV1o3YmljZXZVcmpkbVBDK2JCOHh3ZS9JZnpXZE85?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 779a3033-ef68-40bc-e609-08da8455b956
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4882.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 15:48:14.4151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96mGBs1hlVVxUqgh/vGGYk6PLJRhWkEsMxSrClb7FVE/khcCpRjElErzO1DYVz8Fa3kB/IzrN3+pUTllrHtzOy1+wUryTt9WQeKP2ybYmFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5250
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/2022 9:46 AM, huangguangbin (A) wrote:
>
>
> On 2022/8/18 2:16, Jakub Kicinski wrote:
>> On Wed, 17 Aug 2022 22:35:36 +0800 Guangbin Huang wrote:
>>> This series adds support for steering VxLAN flows using the ethtool NFC
>>> interface, and implements it for hns3 devices.
>>
>> Why can't TC be used for this? Let's not duplicate the same
>> functionality in two places, TC flower can already match on
>> tunnel headers.
>> .
>>
> Hi Jakub,
> 1. I check the manual and implement of TC flower, it doesn't seems
>    to support configuring flows steering to a specific queue.

Based on the discussion in this email thread
   https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/
Amritha will be submitting a patch series soon to enable redirecting to 
a RX qeueue
via  tc flower using skbedit queue_mapping action offload.

- Sridhar
