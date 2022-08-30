Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253455A6C42
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 20:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiH3SdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 14:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiH3SdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 14:33:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B5F6CD09
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661884393; x=1693420393;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JvB9OcgjKkK2979cKOE8f8/SYpvg7BXOMBuRwP8S2mI=;
  b=n+mthOa4YjIpQ+ZlVm+cBggxUKgz8SUEbdrOAhqqnzQo1OuX3t8lNP7V
   Vjw0A7R+RJPehoOzC40LlpdCGpOFrYPPI7vzDhj24X3ZPY/fHU+lnf8mc
   X/dFUurVRxvQbPxbGJ8apInoZxZfAiolim3hMKgAagIaDOIRC9I/+gdHh
   uvRZdo8yuj8YmnOlvajhN0Sp9IaCfvuCnHKujR38l1I2pP6Um9lIj8XLk
   1S3EUtTy2IY1wz6Fa20KALUKyedEQFpVR+xdrmZoUEenJ5pG/TRI+tRsf
   hTyZaiJYSbRXyXcbO8xRlEb+5tBnaOwsn2Kfmh499eKh9YPbQtnge14zO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="275019243"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="275019243"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 11:33:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="680148187"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 30 Aug 2022 11:33:12 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 11:33:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 11:33:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 11:33:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsNsHmmHbkFZiuLkPd18l1Hv7tv6VboTWvd9+4uD3rnW7kyPEc2Ei5/TavyyN5fLcq1fWkS5S+UonY024F4eTuPhDzIpEgzHUtPwYb+jO9KCqaI2M/SyyBQzBPsKG3GtYG7CYWyUJUzaiqcoXI8uXfq+AnGXMdl48BkNzyXcEaFF07MGX70MJ+IqDbWtvlK103DQPA4WTVf0LIuuathjMWdSfbTHkaLhd/D5k+ai1wy2o8JtTfjn9D9XUyRwNWUvCEugitTWPZ3N3aJUo/3XL3Is+pipc7+7rmex1a/q0b3O6Vnr+1NMhRkEilkvh3ElgDMligkE8NEK3uvAJ/dYqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFfluVfT669U3Putm69DK3I5efJkGFuzGdNkjRcJgyw=;
 b=edNlRz3dviH+6mZaB3TXXFFKkvKRcB1wqTb3Uu91B0nfGhGFn+wOzIOBum9988+RUWh69jVKnbIxZPQktFoCMrxrFIj00z7JTbZmCyxN71zs8ngC4CaDQPX1wo3FFu/Xz912ArfLQa7sMmUdFoOk0X91VGCgYq8E3HtnznURm7tqQAU3EFmEeyHnBpZhVtRAn7IWEafMRCobHTbwu6G7G31q5yqELvPJcF7tGDzWiAKoWOtBVeFSWXt0H7cu/TgzhDhRncPW9z1g2g732Y/5ht+1p/dct/o1S4vZ7tRJ/eqWk70nC13fEFa7XjukwWCvOYu/8NhhWwY3zBe9lzb6zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4921.namprd11.prod.outlook.com (2603:10b6:806:115::14)
 by BN8PR11MB3812.namprd11.prod.outlook.com (2603:10b6:408:90::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 18:33:10 +0000
Received: from SA2PR11MB4921.namprd11.prod.outlook.com
 ([fe80::cd77:7dd5:224:6690]) by SA2PR11MB4921.namprd11.prod.outlook.com
 ([fe80::cd77:7dd5:224:6690%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 18:33:10 +0000
Message-ID: <3b248522-3193-cd31-3452-78e02b95c369@intel.com>
Date:   Tue, 30 Aug 2022 11:33:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 5/5] ice: Print human-friendly PHY types
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        "Anirudh Venkataramanan" <anirudh.venkataramanan@intel.com>,
        <netdev@vger.kernel.org>,
        Lukasz Plachno <lukasz.plachno@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
References: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
 <20220824170340.207131-6-anthony.l.nguyen@intel.com>
 <20220825200344.32cb445f@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220825200344.32cb445f@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0390.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::35) To SA2PR11MB4921.namprd11.prod.outlook.com
 (2603:10b6:806:115::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bb5322e-915b-4a6d-e6e8-08da8ab616a4
X-MS-TrafficTypeDiagnostic: BN8PR11MB3812:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4t/peVlQoe4yIrFQ/pP9rvPT4D1URZcmNYXUEdeZPqcvDbL3HJq+Zjy7rnetxiVvXakIi6QPlU3+jL6G76W0+pDNLbqNOr0qLQPoBRzH3fnejlTt1/yzajGTK1bv+ZZyMpeXnD4vYxVoAL0+nBs/wE9iclwF3Wr5Y73FSfAiO+ZP2X2Gifu7XsKbNFJYyWFngs7T5AgR5o4rNJK5Yb9MBcDLl3W3WrivAQHKTd2yj6B2Qrsx+pYHAhSVnra9xJyr+Ai6YwmuDzvNLAdZOnbKqyrAdBLdDcQ6LtQxyGsfmqcdYBdzMX//ui5g8cGs436pdZ0tpNdftbRGsDmQGt+XSHm8P3HYliSuK03wkjkhpRh+rwoznQimPJehLLaBDc44LHiQigS4SVbZOqKIW24edKLZbHHS6/GtxoegfS1MeYIJp4AM98yc8JF+MP1NMGD2niI0BYHzW+vW1MH1XhkvhXcwbqw669gzEFDxGXcPuDMBBnb7GhUGKdyQ5fMlGBGuoNQCRAb7zcxQLKkhWVaE+Qlq4i1zr0qpHjvJdfMOuUONPd3OpsQ12vrP559HNa0AbF11lARdO/z8QR+E9ZhnCIv/hDoykS/tAuiQeqOqNCn+13YKDw545EAlOGY9dNtg5s0a+GUwHCsOk6sSrG+eaSOonM1A+WtPlSG1jGDnEC/G1ihjjcmDjHToEEXobFrLqGdTFPS5QkHf9+LJQeaJf2AYRUrI1XNpWqAm7NvaYmYZh0a04KfSfD3vPWD7Nm2IvEPPPgkmZv4ZtENUUpHmO4imfQP6uZaEi7huxiSEhQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4921.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(376002)(396003)(39860400002)(2906002)(66476007)(6636002)(110136005)(4326008)(8936002)(54906003)(66556008)(5660300002)(66946007)(8676002)(2616005)(316002)(31686004)(36756003)(44832011)(41300700001)(6486002)(6506007)(6666004)(478600001)(86362001)(107886003)(26005)(53546011)(31696002)(6512007)(82960400001)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVRZZ01hVk1IM2Z4UzdWVkFuV2ZKTDBUdG43WWZKZStYMWVDY3VqNWdzQVRh?=
 =?utf-8?B?cTczMEtwQ2w4ekVQaDM1c3RZZ2tpVUg0RDlzdmNhakdwdE9lQlFOYVEyODNo?=
 =?utf-8?B?ZFh3UHJpSGhxZ2lnQ0psMXBOZzMyR2YybVNXK2FmdXJSZktZR05iNjFEYzNq?=
 =?utf-8?B?UU5GSWtWcGhicW0rU3d2QmxFWTdicWlmbTFYWHFhV1owUkc5Yi8xK2tpUFVH?=
 =?utf-8?B?R3pGem1mRVZjSGlJTmtNd3RJSUZxMmN2WWl0bThubFY4cVpTQWNMRFVtTERj?=
 =?utf-8?B?ZmZncVF4bElZY2tXUXhIdzFZRlBSR0hwSXcrcENTVjNHaE1HMTNYQmF0aFh6?=
 =?utf-8?B?RW1CazNMTUR1YVVGSFVYWFQ4UFdmVXI4V0hoZlJ4MGVvOWtOeGQyWHQ2L3Y5?=
 =?utf-8?B?eUJrWDFJVkVrOTNsSm52emVmeE1SdDBEZVZ5UnlSZHNuZG5QOXBHMjRPNXBm?=
 =?utf-8?B?dkovMXo1Tmo4RVVKTXBDbEhDS1lQUWxBMFh1d3cwTnRvK3pxS2o0WEJKbEQr?=
 =?utf-8?B?OWdxUXdHK1BvS0tjUjBkMUtIcUVmdm80UXNJcjczU1B0THg1Rk9menZONlJk?=
 =?utf-8?B?dGU5TlM5OEdKN0FRZ0xwVGxDZEk2aHc1NkxGS0tWbTFvM0VVMGRLS0pKM1ZY?=
 =?utf-8?B?RkV5SGJnK1lvKzM5ZDQ2bnd4bXRBNGlmWG9TMkIxL2gxKzJuRFFQTmJGMlBS?=
 =?utf-8?B?TjA2RFFBdS9KZkFIdHVRKzZPeW81VHoza1hZYnVIeWNFbHAvUmZVZ1d0SGZ4?=
 =?utf-8?B?MGdyQWV0ajIvVDBUU2g5Q3ZwMG1pUTBMbDhZb290SGhLTlFKK005bHdTSHJj?=
 =?utf-8?B?a2ZuUWRBRDRYaElzKzBSemNIUjFLTnUyTU5EbTJFd1d6dmtoVWZ5Wk92RGxT?=
 =?utf-8?B?eHNOdEtJYUdPT2VSTFBaemlEUWxFa1ExMjhEM3YxMDBxN2tBV1dWS1c5Q2JT?=
 =?utf-8?B?M00zNXY0TkxKblBKejRoam5JU0Vsejk1RnhERk5XaURJdFRseG5SL3c1a1dO?=
 =?utf-8?B?OHFwNkEyWmNNcFF6S0lNdFZ2cW02YWFvZk1hNm1wM1BzQ0pjK0hidHptVm5a?=
 =?utf-8?B?TlhkdFVXNzN2bmFHclByTXFIcEVuTk1Fc1MyRDBLTTI2MWVSMGdLZHFuYndW?=
 =?utf-8?B?UlpsaFRDRTdIUW5qVnlNZExVOGI4Yktqam1UZmRucWtLZXVycXAyalpnS1Jm?=
 =?utf-8?B?R2UwQ2ZMOW5zY3lJdnFPRXdjRlZGMHZtMXlqTmJQSmRrQi9YTmZTdUJPTkwx?=
 =?utf-8?B?cE8zT3lsNkZ0ZWI4K2MvR1dEVjhwckl2TzBVa0plWnZnN0dKZHUrWG5nbnR4?=
 =?utf-8?B?M2h1WW14c3hNaHQyOUpybEVxdUVsVTNxanUrVUI5eHVvTDhISHlaSEVDM1N6?=
 =?utf-8?B?Zm53bS9aL2dNMFp1V1dzQ2xjQ0NLSUxFdVFsWmF3VUFwL0dJZHJCZGJzY2d0?=
 =?utf-8?B?dEZISGN2ekZpd2ZGSlh4eXl1QkU5eVQvaEsyemNHTld3Mkc4RnhqU0lUUGd1?=
 =?utf-8?B?NTJ0SlBQZm1senJIZjhvSFFmaVI4REx1UDZyaTlNbkdHMVE3ejhTaGhBeEFx?=
 =?utf-8?B?TzV0L2VPWURsbnZaWU92TkNLZTdrVE1rblBTNWhZeURmVis3czZkQ2FpVm45?=
 =?utf-8?B?cHpONC9qVnBTaUpEelpKczZCYjhQSWJkaUkyQ2RpS2o5ZXJNZnBzR2s0L0V5?=
 =?utf-8?B?Sk1kdFg3RnVDRGtPc3JwZnhCT0ZYclVaRXZVNU1oRFZOTmVidXpYV3dqODNs?=
 =?utf-8?B?N3hlM3FQZUtuRGREQzNmMUlkeEo1bFpEbjZOLzh5M3VGRUlKZHNQb3BBeWJ3?=
 =?utf-8?B?S01JTmxGV1lOYVdjTW5iNjV0aTRSOUVFMDY1emE0eGlnMEVEazFKWmV3eUJn?=
 =?utf-8?B?Q1k4cEc2enZyRWorUVo2dmVtTWZlandWVFE2UDFGSWU0b29iT2NZbStMYlZG?=
 =?utf-8?B?Qm1BQUdkQy8xeFVsRXZaSWFhM3FWQTlqOGRyL3lvYUZXUTl3NFNERlEyTUlP?=
 =?utf-8?B?bDNKcUR5UFc0ZmthV3dOekhKZ05QczVrZUUzNitPUXB1K3VnVjNwTUVrdjRE?=
 =?utf-8?B?RDVkcVY1RUU0emVhb1h0RWovRUFZRkNGTWc1OHhNL3ozZHZDQnRVVjk5cEgz?=
 =?utf-8?B?ZkZuNFYybGREOHczL1haM2VvZEtPWCtkM1phd2IydXhDK3pKZUsvMFJwTTFu?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb5322e-915b-4a6d-e6e8-08da8ab616a4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4921.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 18:33:10.0713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqCpQk/MyE4PNFB6EPE5UxWWxdOFQvbBRlksUFdx/QFy2JYBuVlj5AD3Wi5rFZhLKsVTmGmR3a1RrsZFkm4pCNqiMAPNykzKmO47wia2ISA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3812
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/2022 8:03 PM, Jakub Kicinski wrote:
>> New:
>> [ 1128.297347] ice 0000:16:00.0: get phy caps dump
>> [ 1128.297351] ice 0000:16:00.0: phy_caps_active: phy_type_low: 0x0108021020502000
>> [ 1128.297355] ice 0000:16:00.0: phy_caps_active:   bit(13): 10G_SFI_DA
>> [ 1128.297359] ice 0000:16:00.0: phy_caps_active:   bit(20): 25GBASE_CR
>> [ 1128.297362] ice 0000:16:00.0: phy_caps_active:   bit(22): 25GBASE_CR1
>> [ 1128.297365] ice 0000:16:00.0: phy_caps_active:   bit(29): 25G_AUI_C2C
>> [ 1128.297368] ice 0000:16:00.0: phy_caps_active:   bit(36): 50GBASE_CR2
>> [ 1128.297371] ice 0000:16:00.0: phy_caps_active:   bit(41): 50G_LAUI2
>> [ 1128.297374] ice 0000:16:00.0: phy_caps_active:   bit(51): 100GBASE_CR4
>> [ 1128.297377] ice 0000:16:00.0: phy_caps_active:   bit(56): 100G_CAUI4
>> [ 1128.297380] ice 0000:16:00.0: phy_caps_active: phy_type_high: 0x0000000000000000
>> [ 1128.297383] ice 0000:16:00.0: phy_caps_active: report_mode = 0x4
>> [ 1128.297386] ice 0000:16:00.0: phy_caps_active: caps = 0xc8
>> [ 1128.297389] ice 0000:16:00.0: phy_caps_active: low_power_ctrl_an = 0x4
>> [ 1128.297392] ice 0000:16:00.0: phy_caps_active: eee_cap = 0x0
>> [ 1128.297394] ice 0000:16:00.0: phy_caps_active: eeer_value = 0x0
>> [ 1128.297397] ice 0000:16:00.0: phy_caps_active: link_fec_options = 0xdf
>> [ 1128.297400] ice 0000:16:00.0: phy_caps_active: module_compliance_enforcement = 0x0
>> [ 1128.297402] ice 0000:16:00.0: phy_caps_active: extended_compliance_code = 0xb
>> [ 1128.297405] ice 0000:16:00.0: phy_caps_active: module_type[0] = 0x11
>> [ 1128.297408] ice 0000:16:00.0: phy_caps_active: module_type[1] = 0x1
>> [ 1128.297411] ice 0000:16:00.0: phy_caps_active: module_type[2] = 0x0
> 
> Is this not something that can be read via ethtool -m ?

Hi Jakub, I saw Dave committed this, but I wanted to answer.

AFAIK ethtool -m just dumps the eeprom in a hexdump. This data is part 
of a firmware response about "all the things" that it knows about the 
current link and PHY/cable.

these *debug* prints extra information on the phy that the driver gets 
in one call, but is not clearly mapped today to a single ethtool command.

Would this be a good candidate for debugfs (read only) file for our 
driver, or should we just leave it as dev_dbg() output?

