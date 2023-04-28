Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AE26F20FB
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 00:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346751AbjD1WjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 18:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346689AbjD1WjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 18:39:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B095BBB
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 15:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682721535; x=1714257535;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=17pyi59EY47xgUY6XQEaxOxWeBLMjPxQB8rxRizULg8=;
  b=CGpQfQfLWb17hXTHi3xRKmOxwojLIX8vpzsm55nifpNZTE/9JzOi/qBG
   V4jcLFrBlGoJrSVqVSU/0qI7fMKOIrrPb9a7ILhiqDTZqqJ4wvhv7MT1q
   Sy2O2EZNBdcu/Cl4rlbFBGXFrLlNxpwHWGFmsUiGmfCWorODtVJALM0+z
   bdTxmVjZFkAvMzz4rPMyDGPDZJnThtd7Z9imR/BG8lK7HfO8zZV57a2WS
   BKKB6e8BUr3lnDrN2swaktnrJrGqFD9yVl+XblL0r3/8O4YKnqhpKf5wj
   Rl0QhWPC2gxb497wRan1OLwNz4JUoYFPaGvajgCBCcWAXCgExRdLKcf1B
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="349904669"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="349904669"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 15:38:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="759820032"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="759820032"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 28 Apr 2023 15:38:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 15:38:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 15:38:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 15:38:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 15:38:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVBDmfPJ5iJPtDT0SMcMp2lR3yoeBEcgz5k0CuFG8ufXIAgfKP5c0T+/x12MdCbWrnD6C9eh3/2KBwIkBmUYMS/WbMSqWMyCQgeBpMDiWvjyyx+kqXU77pvSaJmulQB5gAKtTtidq142PSA7YFpJUQDrSV7gEYAteVkna9qVYRa6zu21MkTKPn5mPYE9S69jpnjMOCAawKufKI3wvP/XZVOtuHh80f48AN2CSYvmDddb45hT5RmsNMirJHY/C+6+GaQfpepTn6l4ZO/q+UGFRxTFgcVDOQcGIidaGWdcESAChUkPPr3WohsIaEXCWKxKmypCDsyAaBQ5vvAqpeYSLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGHyNA2B2uvj6aXFb58Zdwl+H23141wEyYTlaVFCE1o=;
 b=SIQBt31AW0+JG06CzFhYMJoiXfJ2a+TfwMk3cwYtoeUARaZ3rHmiJh8P1cxr8xK+QWk8b1icPfuRaomMCwVCe5avEchIOJvUuHqPTLpArBmf/rfEbBmgmZDCbgsP8yvBKim7LRvSvO6OvNDcHl15dLlNAljERtl3NttcvI199tgmbGGgEMPgLgzkuYlnn23RTC0t8s7LV4Vf6qN6xi/w2ZymgGicKttoBrEJYDtUmzqlExsCk3myk4Iv/SdzsILYQhZnxfCqMcAEUUpRRugtFsnwKY2yFcEBR7wQt1zNnPDpNruik+rWUjiQ/bo0b3Vp4gTWOYCTvO6S6/uhpwuY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SA3PR11MB7979.namprd11.prod.outlook.com (2603:10b6:806:2f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 22:38:45 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e%7]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 22:38:45 +0000
Message-ID: <d062a0d1-426b-c6d8-6e5b-bcd00449bce2@intel.com>
Date:   Fri, 28 Apr 2023 15:38:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [net-next v3 03/15] idpf: add controlq init and reset checks
Content-Language: en-US
To:     Shannon Nelson <shannon.nelson@amd.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <joshua.a.hay@intel.com>,
        <sridhar.samudrala@intel.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <willemb@google.com>,
        <decot@google.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <alan.brady@intel.com>, <madhu.chittim@intel.com>,
        <phani.r.burra@intel.com>, <shailendra.bhatnagar@intel.com>,
        <pavan.kumar.linga@intel.com>, <simon.horman@corigine.com>,
        <leon@kernel.org>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
 <20230427020917.12029-4-emil.s.tantilov@intel.com>
 <66742b69-dc39-45ac-3018-e295670d2a3d@amd.com>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <66742b69-dc39-45ac-3018-e295670d2a3d@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0185.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::10) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SA3PR11MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: 63d3e657-582d-40f9-b36f-08db48395347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksMf1Dyy6/xCu6FgaNrvXTgRsPzSm4w5To2Aj10qxxh9Pm121SkdAFYi5+D0aUZsQJZJE6Q/5maQZ9yqTY9lsSotS2GqJ3uhvYJ0BTFW2Fkmb3kITZv7yZT8e+04CY7aFIwirhcEdDq9FcISj+bbZsVPp4W4nIsSVkqh7T6IO8Dhf6k34r4MKTZXCE4RG1xhMKour1aW8ZGSOVDlSYgl16NH95BU4gjO37cel247yI/30T0cIv1CABaJFUR5L4CtxldO68IOYrMq4iuScmemoG38PrNfzvB6ramdRb7yCKz/pS6xekT9gYkoQQJxd4B21wtwkkuQkBjcd0NCNTWhP1T6+WMICET0cadXNTBlxjoTS0W2P66A+nUwZYSQgPm+umoSK16Vu2AABtiXkR/xdiYcOsjNSXui3du6GheIG2a8k2oKcm4G1XiAXGeV/W7Js/iN0bc9qjpyjIxuyLWDY4P2L9J/rMOmvBHDI56mbf6WIqS+TvkkjGvLBheL3yI9xD25CppvD4z/cH7EZtzX9y2G4jUabPGa1A9uJC4OBFEX5wT2xs/YYVPPinka4Od6ZAzIpQzV9s1xi8djKfg+rz9lGL8LhpbjcM7HBsNp4IPc2hCw8ydPVG3ubNPJcnRxgXLVaRraGmCrPJsVXxdgfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199021)(6666004)(31686004)(82960400001)(478600001)(83380400001)(6486002)(38100700002)(186003)(2616005)(316002)(66946007)(66556008)(66476007)(4326008)(7416002)(41300700001)(6512007)(6506007)(30864003)(66899021)(26005)(86362001)(53546011)(36756003)(8936002)(8676002)(31696002)(2906002)(5660300002)(43740500002)(45980500001)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVlpRkw3UHpsbG5hYmRHdGY2K0tDRmdRTjVNeGF2bkJFU1hhT3JCQnRrbEls?=
 =?utf-8?B?dXBvL2JWZVR3ZkZzcVFVKzFzYk9VVGVydHB4ZDBRZTJHMUJMYjZua3JVNENi?=
 =?utf-8?B?S21lTi9vNFB2YnMyWVkreGlZaW1CdG9nWDh1R3l0Z0xiMC9xRURDZWNXWUc5?=
 =?utf-8?B?NEppaUtyUUdhbFk5MEFhM0RDQUJiZkErekVxRU80MDdzb3kySEg2MHg1VEVZ?=
 =?utf-8?B?STRlYzE5cUVCbkl5YmphZDJHeUkrUys1MXZtanlYZTdMUmpHZG52MHZzYWdK?=
 =?utf-8?B?S3BQeGwrVHRIcDZFNVFyLzVVZ1JCbVhodzJJNzZBTVBnT2kxVVozMlkyVTZj?=
 =?utf-8?B?UGZYYW04cTcweWszcTRmOWpybDY4Ti9MQnlKMFNpMXltKzlQSk5kQnRLRE0x?=
 =?utf-8?B?RmpIN0NaMVRFUEFWaTNmWGdOZmFDVFptS3NPTG1IWmdOWG5Fdld1cjl2Kzdx?=
 =?utf-8?B?Ky9TcFNQYVZkQ1NRRDI4ZnIrWFVWaisxTjV6bWJvek5TelBrem5CVUtKMUdn?=
 =?utf-8?B?b1IxM3hLdXpia3IyWU1GNmRjRTJFTndZc2RkYnBicjljOEFpZVR2L1F2U3Vw?=
 =?utf-8?B?MlR5WktSb05aVmZ1OXpDZlJTODBaUDdzalB0VTVpc0tIdVowai9pMmtmaW43?=
 =?utf-8?B?dDNEcHBhNG14a0cxWmx6bHpjZ1owNXBVcEw3Yk5DbE40MDlWd1Y5azArOFpV?=
 =?utf-8?B?cEdLNmlsV29IY1N3TXlrOURDTDZKeUVLT1dCZUs2elVLajF0YjN4Ujh0VXdz?=
 =?utf-8?B?bm55Qjc1UFlSK3BDbkQ1TW5TblNJeDQzWUgwcWFpK2tqTGRpYUI1cDVQaFZQ?=
 =?utf-8?B?NnFyVm5SaVUvN21DbitNVHU4UGFSUzJsTk1wOE8zRCtkRGIvbE1LNkFTZlhK?=
 =?utf-8?B?T0RLblJGSlRHa28yOEFvY3BYNVU1aDlUUHZOUXRkeU85R2tpeDlTR1ZwdWRU?=
 =?utf-8?B?RTk3Tno1cXFZTUJYY0o0S0NYclJMOTZMSXphSlZJZGZmNVVyaVp5cnY3OUc0?=
 =?utf-8?B?OFhybU1qWW9PL3lScWE5MXlPVFgrb1lBY0VKYUwvK0h3SGRrVHVzSkNiamJS?=
 =?utf-8?B?MkpBM0xhQ2JUUUphOFpMa2FkbG9RZXg5Qzl0L0dnb1BMYTRIYm9IdmkwdzhU?=
 =?utf-8?B?WHNyNEJOUkU1bURZUWdYQ2N5emU4OUFwdHdDM09JZFRxeGxtdFM0amVxZTlK?=
 =?utf-8?B?T2lIMFRhSkJDZFRVTmh4VkxESEtzNFhyY2I2anJ6SnJzZDJMb1F4MHJ5VG1P?=
 =?utf-8?B?S1VZM1VlQmZnQm50Q21ZNGg3WnZWZzJwVEoxR3M5NFRBcnlOSTFnMG1iK050?=
 =?utf-8?B?VFNFcXN2blNQTkU5SDU1bm9HOTdOWTBOaFJTZjQrcFdKc1FYNGZtZTRkT2tw?=
 =?utf-8?B?azgvajN0S2paREFONGh5YjZnVlRrYS9HclU1dDNzTGZGanp0dS80MGhhT3Vm?=
 =?utf-8?B?L21xOHZIaXpYclpIc2F4UitLdTg5djZqNHZ5UUhnMXVCZlVyOVpSWmg2TWZP?=
 =?utf-8?B?NnFwaVdhMnNWbHFha285K2xqV1E3SnBNT2tseGsxdFN2WTM2aTE4NFhSS2F0?=
 =?utf-8?B?RjlQTUEvbUl2TmVwNGpBZkZhclozeU1rU2E5SnRoa3FIazFJMjQvSkFGRXRk?=
 =?utf-8?B?Q1BPRjBsRlVrSHNZQVNQbDg1TFBLeG8xZkVZVmZtQmh2VFBacWppdjFQSFg1?=
 =?utf-8?B?djZRSUI2ajRKQ1QyVndyZ2VpTUlmak5wQzBWRVhsZ0FQRzJKWElwV2JVYThK?=
 =?utf-8?B?bE1Vb2I5Zlp3UWF5WXgzYVIyZnJ0WDR3YnZaTW9tMU4vV0VMaXJsOWxhTEZT?=
 =?utf-8?B?MEF0UytrbWxyVk5hQ0t2YjJOdTJoQWdhZVBwOWhPQlVSUjV3aWFleldxTjZj?=
 =?utf-8?B?bFk0TnBNWjhmQWZYcnBQUUlDakhyZ25vRk9DaTJUMkpHekY3a2FNM01weW10?=
 =?utf-8?B?VGhkWG5KRi9Mb0pUc2hGbDRVUGhEaXN2MWZGekFXajlUdkt6am8vK3cvM2JH?=
 =?utf-8?B?eU9iRi9Qdm5lVVlmcnNTN1NVVjFtMm80cENkZFpKVFlZTjZyeWNwUEZOdHVJ?=
 =?utf-8?B?ZGhPN2JUNXlINk1lblliek9JSmlsTkFreXdsVnNJaTZ2SWdqaTE3TFdlSCtl?=
 =?utf-8?B?QXV4U2txTSs4a3lGWHpzeFE2MkZ4TUdIYTdTMFFIcnQrWmtscEZwWDVTTTZt?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d3e657-582d-40f9-b36f-08db48395347
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 22:38:45.2994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RD6efK06CuYv9Ft206JySKBqlC7/ENWC15eLpA879yxNUFKUiI9sd4W6/wdbuzvLyavLpgYf3/vY6EulXQbJuwra1MvaGmj6eWB6nRuH+s0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7979
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2023 10:16 AM, Shannon Nelson wrote:
> On 4/26/23 7:09 PM, Emil Tantilov wrote:
>>
>> From: Joshua Hay <joshua.a.hay@intel.com>
>>
>> At the end of the probe, initialize and schedule the event workqueue.
>> It calls the hard reset function where reset checks are done to find
>> if the device is out of the reset. Control queue initialization and
>> the necessary control queue support is added.
>>
>> Introduce function pointers for the register operations which are
>> different between PF and VF devices.
>>
>> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
>> Co-developed-by: Alan Brady <alan.brady@intel.com>
>> Signed-off-by: Alan Brady <alan.brady@intel.com>
>> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
>> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
>> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
>> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
>> Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
>> Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
>> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>> ---
>>   drivers/net/ethernet/intel/idpf/Makefile      |   8 +-
>>   drivers/net/ethernet/intel/idpf/idpf.h        |  93 +++
>>   .../net/ethernet/intel/idpf/idpf_controlq.c   | 644 ++++++++++++++++++
>>   .../net/ethernet/intel/idpf/idpf_controlq.h   | 117 ++++
>>   .../ethernet/intel/idpf/idpf_controlq_api.h   | 188 +++++
>>   .../ethernet/intel/idpf/idpf_controlq_setup.c | 175 +++++
>>   drivers/net/ethernet/intel/idpf/idpf_dev.c    |  89 +++
>>   .../ethernet/intel/idpf/idpf_lan_pf_regs.h    |  70 ++
>>   .../ethernet/intel/idpf/idpf_lan_vf_regs.h    |  65 ++
>>   drivers/net/ethernet/intel/idpf/idpf_lib.c    | 145 ++++
>>   drivers/net/ethernet/intel/idpf/idpf_main.c   |  51 +-
>>   drivers/net/ethernet/intel/idpf/idpf_mem.h    |  20 +
>>   drivers/net/ethernet/intel/idpf/idpf_vf_dev.c |  86 +++
>>   .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 128 ++++
>>   14 files changed, 1877 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.c
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq_api.h
>>   create mode 100644 
>> drivers/net/ethernet/intel/idpf/idpf_controlq_setup.c
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_dev.c
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lib.c
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_mem.h
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
>>   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
>>
>> diff --git a/drivers/net/ethernet/intel/idpf/Makefile 
>> b/drivers/net/ethernet/intel/idpf/Makefile
>> index 77f5500d7707..9607f61db27e 100644
>> --- a/drivers/net/ethernet/intel/idpf/Makefile
>> +++ b/drivers/net/ethernet/intel/idpf/Makefile
>> @@ -6,4 +6,10 @@
>>   obj-$(CONFIG_IDPF) += idpf.o
>>
>>   idpf-y := \
>> -       idpf_main.o
>> +       idpf_controlq.o         \
>> +       idpf_controlq_setup.o   \
>> +       idpf_dev.o              \
>> +       idpf_lib.o              \
>> +       idpf_main.o             \
>> +       idpf_virtchnl.o         \
>> +       idpf_vf_dev.o
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf.h 
>> b/drivers/net/ethernet/intel/idpf/idpf.h
>> index 08be5621140f..0b3b5259bd43 100644
>> --- a/drivers/net/ethernet/intel/idpf/idpf.h
>> +++ b/drivers/net/ethernet/intel/idpf/idpf.h
>> @@ -4,19 +4,112 @@
>>   #ifndef _IDPF_H_
>>   #define _IDPF_H_
>>
>> +/* Forward declaration */
>> +struct idpf_adapter;
>> +
>>   #include <linux/aer.h>
>>   #include <linux/etherdevice.h>
>>   #include <linux/pci.h>
>>
>>   #include "idpf_controlq.h"
>>
>> +/* Default Mailbox settings */
>> +#define IDPF_DFLT_MBX_BUF_SIZE         SZ_4K
>> +#define IDPF_NUM_DFLT_MBX_Q            2       /* includes both TX 
>> and RX */
>> +#define IDPF_DFLT_MBX_Q_LEN            64
>> +#define IDPF_DFLT_MBX_ID               -1
>> +
>>   /* available message levels */
>>   #define IDPF_AVAIL_NETIF_M (NETIF_MSG_DRV | NETIF_MSG_PROBE | 
>> NETIF_MSG_LINK)
>>
>> +enum idpf_state {
>> +       __IDPF_STARTUP,
>> +       __IDPF_STATE_LAST /* this member MUST be last */
>> +};
>> +
>> +enum idpf_flags {
>> +       /* Hard reset causes */
>> +       /* Hard reset when txrx timeout */
>> +       __IDPF_HR_FUNC_RESET,
>> +       /* when reset event is received on virtchannel */
>> +       __IDPF_HR_CORE_RESET,
>> +       /* Set on driver load for a clean HW */
>> +       __IDPF_HR_DRV_LOAD,
>> +       /* Reset in progress */
>> +       __IDPF_HR_RESET_IN_PROG,
>> +       /* Driver remove in progress */
>> +       __IDPF_REMOVE_IN_PROG,
>> +       /* must be last */
>> +       __IDPF_FLAGS_NBITS,
> 
> Why the underscores on all these?  Seems unnecessary and messy.
Probably makes sense to remove them.

<snip>

>> +/**
>> + * idpf_ctlq_recv - receive control queue message call back
>> + * @cq: pointer to control queue handle to receive on
>> + * @num_q_msg: (input|output) input number of messages that should be 
>> received;
>> + * output number of messages actually received
>> + * @q_msg: (output) array of received control queue messages on this q;
>> + * needs to be pre-allocated by caller for as many messages as requested
>> + *
>> + * Called by interrupt handler or polling mechanism. Caller is expected
>> + * to free buffers
>> + */
>> +int idpf_ctlq_recv(struct idpf_ctlq_info *cq, u16 *num_q_msg,
>> +                  struct idpf_ctlq_msg *q_msg)
>> +{
>> +       u16 num_to_clean, ntc, ret_val, flags;
>> +       struct idpf_ctlq_desc *desc;
>> +       int ret_code = 0;
>> +       u16 i = 0;
>> +
>> +       if (!cq || !cq->ring_size)
>> +               return -ENOBUFS;
>> +
>> +       if (*num_q_msg == 0)
>> +               return 0;
>> +       else if (*num_q_msg > cq->ring_size)
>> +               return -EBADR;
>> +
>> +       /* take the lock before we start messing with the ring */
>> +       mutex_lock(&cq->cq_lock);
>> +
>> +       ntc = cq->next_to_clean;
>> +
>> +       num_to_clean = *num_q_msg;
>> +
>> +       for (i = 0; i < num_to_clean; i++) {
>> +               /* Fetch next descriptor and check if marked as done */
>> +               desc = IDPF_CTLQ_DESC(cq, ntc);
>> +               flags = le16_to_cpu(desc->flags);
>> +
>> +               if (!(flags & IDPF_CTLQ_FLAG_DD))
>> +                       break;
>> +
>> +               ret_val = le16_to_cpu(desc->ret_val);
>> +
>> +               q_msg[i].vmvf_type = (flags &
>> +                                     (IDPF_CTLQ_FLAG_FTYPE_VM |
>> +                                      IDPF_CTLQ_FLAG_FTYPE_PF)) >>
>> +                                     IDPF_CTLQ_FLAG_FTYPE_S;
>> +
>> +               if (flags & IDPF_CTLQ_FLAG_ERR)
>> +                       ret_code = -EBADMSG;
>> +
>> +               q_msg[i].cookie.mbx.chnl_opcode =
>> +                               le32_to_cpu(desc->v_opcode_dtype);
>> +               q_msg[i].cookie.mbx.chnl_retval =
>> +                               le32_to_cpu(desc->v_retval);
>> +
>> +               q_msg[i].opcode = le16_to_cpu(desc->opcode);
>> +               q_msg[i].data_len = le16_to_cpu(desc->datalen);
>> +               q_msg[i].status = ret_val;
>> +
>> +               if (desc->datalen) {
>> +                       memcpy(q_msg[i].ctx.indirect.context,
>> +                              &desc->params.indirect, 
>> IDPF_INDIRECT_CTX_SIZE);
>> +
>> +                       /* Assign pointer to dma buffer to ctlq_msg array
>> +                        * to be given to upper layer
>> +                        */
>> +                       q_msg[i].ctx.indirect.payload = 
>> cq->bi.rx_buff[ntc];
>> +
>> +                       /* Zero out pointer to DMA buffer info;
>> +                        * will be repopulated by post buffers API
>> +                        */
>> +                       cq->bi.rx_buff[ntc] = NULL;
>> +               } else {
>> +                       memcpy(q_msg[i].ctx.direct, desc->params.raw,
>> +                              IDPF_DIRECT_CTX_SIZE);
>> +               }
>> +
>> +               /* Zero out stale data in descriptor */
>> +               memset(desc, 0, sizeof(struct idpf_ctlq_desc));
>> +
>> +               ntc++;
>> +               if (ntc == cq->ring_size)
>> +                       ntc = 0;
>> +       }
>> +
>> +       cq->next_to_clean = ntc;
>> +
>> +       mutex_unlock(&cq->cq_lock);
>> +
>> +       *num_q_msg = i;
>> +       if (*num_q_msg == 0)
>> +               ret_code = -ENOMSG;
>> +
>> +       return ret_code;
> 
> I've seen status, ret, ret_val, ret_code... can we decide on one common 
> use and make sure it won't get confused with a message recv'd status 
> variable?
>
Fair point - I will look into cleaning those up.

>> +}
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_controlq.h 
>> b/drivers/net/ethernet/intel/idpf/idpf_controlq.h
>> index 383089c91675..3279394aa085 100644
>> --- a/drivers/net/ethernet/intel/idpf/idpf_controlq.h
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_controlq.h
>> @@ -4,11 +4,128 @@
>>   #ifndef _IDPF_CONTROLQ_H_
>>   #define _IDPF_CONTROLQ_H_
>>
>> +#include <linux/slab.h>
>> +
>> +#include "idpf_controlq_api.h"
>> +
>> +/* Maximum buffer lengths for all control queue types */
>> +#define IDPF_CTLQ_MAX_RING_SIZE 1024
>> +#define IDPF_CTLQ_MAX_BUF_LEN  4096
>> +
>> +#define IDPF_CTLQ_DESC(R, i) \
>> +       (&(((struct idpf_ctlq_desc *)((R)->desc_ring.va))[i]))
>> +
>> +#define IDPF_CTLQ_DESC_UNUSED(R) \
>> +       ((u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : 
>> (R)->ring_size) + \
>> +              (R)->next_to_clean - (R)->next_to_use - 1))
>> +
>> +/* Control Queue default settings */
>> +#define IDPF_CTRL_SQ_CMD_TIMEOUT       250  /* msecs */
>> +
>> +struct idpf_ctlq_desc {
>> +       /* Control queue descriptor flags */
>> +       __le16 flags;
>> +       /* Control queue message opcode */
>> +       __le16 opcode;
>> +       __le16 datalen;         /* 0 for direct commands */
>> +       union {
>> +               __le16 ret_val;
>> +               __le16 pfid_vfid;
>> +#define IDPF_CTLQ_DESC_VF_ID_S 0
>> +#define IDPF_CTLQ_DESC_VF_ID_M (0x7FF << IDPF_CTLQ_DESC_VF_ID_S)
>> +#define IDPF_CTLQ_DESC_PF_ID_S 11
>> +#define IDPF_CTLQ_DESC_PF_ID_M (0x1F << IDPF_CTLQ_DESC_PF_ID_S)
>> +       };
>> +
>> +       /* Virtchnl message opcode and virtchnl descriptor type
>> +        * v_opcode=[27:0], v_dtype=[31:28]
>> +        */
>> +       __le32 v_opcode_dtype;
>> +       /* Virtchnl return value */
>> +       __le32 v_retval;
>> +       union {
>> +               struct {
>> +                       __le32 param0;
>> +                       __le32 param1;
>> +                       __le32 param2;
>> +                       __le32 param3;
>> +               } direct;
>> +               struct {
>> +                       __le32 param0;
>> +                       __le16 sw_cookie;
>> +                       /* Virtchnl flags */
>> +                       __le16 v_flags;
>> +                       __le32 addr_high;
>> +                       __le32 addr_low;
>> +               } indirect;
>> +               u8 raw[16];
>> +       } params;
>> +};
>> +
>> +/* Flags sub-structure
>> + * |0  |1  |2  |3  |4  |5  |6  |7  |8  |9  |10 |11 |12 |13 |14 |15 |
>> + * |DD |CMP|ERR|  * RSV *  |FTYPE  | *RSV* |RD |VFC|BUF|  HOST_ID  |
>> + */
>> +/* command flags and offsets */
>> +#define IDPF_CTLQ_FLAG_DD_S            0
>> +#define IDPF_CTLQ_FLAG_CMP_S           1
>> +#define IDPF_CTLQ_FLAG_ERR_S           2
>> +#define IDPF_CTLQ_FLAG_FTYPE_S         6
>> +#define IDPF_CTLQ_FLAG_RD_S            10
>> +#define IDPF_CTLQ_FLAG_VFC_S           11
>> +#define IDPF_CTLQ_FLAG_BUF_S           12
>> +#define IDPF_CTLQ_FLAG_HOST_ID_S       13
>> +
>> +#define IDPF_CTLQ_FLAG_DD      BIT(IDPF_CTLQ_FLAG_DD_S)        /* 
>> 0x1    */
>> +#define IDPF_CTLQ_FLAG_CMP     BIT(IDPF_CTLQ_FLAG_CMP_S)       /* 
>> 0x2    */
>> +#define IDPF_CTLQ_FLAG_ERR     BIT(IDPF_CTLQ_FLAG_ERR_S)       /* 
>> 0x4    */
>> +#define IDPF_CTLQ_FLAG_FTYPE_VM        
>> BIT(IDPF_CTLQ_FLAG_FTYPE_S)     /* 0x40   */
>> +#define IDPF_CTLQ_FLAG_FTYPE_PF        BIT(IDPF_CTLQ_FLAG_FTYPE_S + 
>> 1) /* 0x80   */
>> +#define IDPF_CTLQ_FLAG_RD      BIT(IDPF_CTLQ_FLAG_RD_S)        /* 
>> 0x400  */
>> +#define IDPF_CTLQ_FLAG_VFC     BIT(IDPF_CTLQ_FLAG_VFC_S)       /* 
>> 0x800  */
>> +#define IDPF_CTLQ_FLAG_BUF     BIT(IDPF_CTLQ_FLAG_BUF_S)       /* 
>> 0x1000 */
>> +
>> +/* Host ID is a special field that has 3b and not a 1b flag */
>> +#define IDPF_CTLQ_FLAG_HOST_ID_M MAKE_MASK(0x7000UL, 
>> IDPF_CTLQ_FLAG_HOST_ID_S)
>> +
>> +struct idpf_mbxq_desc {
>> +       u8 pad[8];              /* CTLQ flags/opcode/len/retval fields */
>> +       u32 chnl_opcode;        /* avoid confusion with desc->opcode */
>> +       u32 chnl_retval;        /* ditto for desc->retval */
>> +       u32 pf_vf_id;           /* used by CP when sending to PF */
>> +};
>> +
>> +/* Define the APF hardware struct to replace other control structs as 
>> needed
> 
> APF?  Your change notes say you removed these references.
> 
Missed this one I guess.

>> + * Align to ctlq_hw_info
>> + */
>>   struct idpf_hw {
>>          void __iomem *hw_addr;
>>          resource_size_t hw_addr_len;
>>
>>          void *back;
>> +
>> +       /* control queue - send and receive */
>> +       struct idpf_ctlq_info *asq;
>> +       struct idpf_ctlq_info *arq;
>> +
>> +       /* pci info */
>> +       u16 device_id;
>> +       u16 vendor_id;
>> +       u16 subsystem_device_id;
>> +       u16 subsystem_vendor_id;
>> +       u8 revision_id;
>> +       bool adapter_stopped; > +
>> +       struct list_head cq_list_head;
>>   };
>>
>> +int idpf_ctlq_alloc_ring_res(struct idpf_hw *hw,
>> +                            struct idpf_ctlq_info *cq);
>> +
>> +void idpf_ctlq_dealloc_ring_res(struct idpf_hw *hw, struct 
>> idpf_ctlq_info *cq);
>> +
>> +/* prototype for functions used for dynamic memory allocation */
>> +void *idpf_alloc_dma_mem(struct idpf_hw *hw, struct idpf_dma_mem *mem,
>> +                        u64 size);
>> +void idpf_free_dma_mem(struct idpf_hw *hw, struct idpf_dma_mem *mem);
>>   #endif /* _IDPF_CONTROLQ_H_ */
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_controlq_api.h 
>> b/drivers/net/ethernet/intel/idpf/idpf_controlq_api.h
>> new file mode 100644
>> index 000000000000..32bbd4796874
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_controlq_api.h
>> @@ -0,0 +1,188 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#ifndef _IDPF_CONTROLQ_API_H_
>> +#define _IDPF_CONTROLQ_API_H_
>> +
>> +#include "idpf_mem.h"
>> +
>> +struct idpf_hw;
>> +
>> +/* Used for queue init, response and events */
>> +enum idpf_ctlq_type {
>> +       IDPF_CTLQ_TYPE_MAILBOX_TX       = 0,
>> +       IDPF_CTLQ_TYPE_MAILBOX_RX       = 1,
>> +       IDPF_CTLQ_TYPE_CONFIG_TX        = 2,
>> +       IDPF_CTLQ_TYPE_CONFIG_RX        = 3,
>> +       IDPF_CTLQ_TYPE_EVENT_RX         = 4,
>> +       IDPF_CTLQ_TYPE_RDMA_TX          = 5,
>> +       IDPF_CTLQ_TYPE_RDMA_RX          = 6,
>> +       IDPF_CTLQ_TYPE_RDMA_COMPL       = 7
>> +};
>> +
>> +/* Generic Control Queue Structures */
>> +struct idpf_ctlq_reg {
>> +       /* used for queue tracking */
>> +       u32 head;
>> +       u32 tail;
>> +       /* Below applies only to default mb (if present) */
>> +       u32 len;
>> +       u32 bah;
>> +       u32 bal;
>> +       u32 len_mask;
>> +       u32 len_ena_mask;
>> +       u32 head_mask;
>> +};
>> +
>> +/* Generic queue msg structure */
>> +struct idpf_ctlq_msg {
>> +       u8 vmvf_type; /* represents the source of the message on recv */
>> +#define IDPF_VMVF_TYPE_VF 0
>> +#define IDPF_VMVF_TYPE_VM 1
>> +#define IDPF_VMVF_TYPE_PF 2
>> +       u8 host_id;
>> +       /* 3b field used only when sending a message to peer - to be 
>> used in
>> +        * combination with target func_id to route the message
>> +        */
> 
> I thought this messaging was strictly for PF/VF to CP, not PF/VF to 
> PF/VF.  Do we expect to have PF<-->VF or VF<-->VF peer communications? 
> Or am I misunderstanding the meaning of "peer" in this comment?
> 
It's only PF/VF to CP. In this context "peer" would be the entity on the 
receiving end of the message, which is CP.

>> +#define IDPF_HOST_ID_MASK 0x7
>> +
>> +       u16 opcode;
>> +       u16 data_len;   /* data_len = 0 when no payload is attached */
>> +       union {
>> +               u16 func_id;    /* when sending a message */
>> +               u16 status;     /* when receiving a message */
>> +       };
>> +       union {
>> +               struct {
>> +                       u32 chnl_opcode;
>> +                       u32 chnl_retval;
>> +               } mbx;
>> +       } cookie;
>> +       union {
>> +#define IDPF_DIRECT_CTX_SIZE   16
>> +#define IDPF_INDIRECT_CTX_SIZE 8
>> +               /* 16 bytes of context can be provided or 8 bytes of 
>> context
>> +                * plus the address of a DMA buffer
>> +                */
>> +               u8 direct[IDPF_DIRECT_CTX_SIZE];
>> +               struct {
>> +                       u8 context[IDPF_INDIRECT_CTX_SIZE];
>> +                       struct idpf_dma_mem *payload;
>> +               } indirect;
>> +       } ctx;
>> +};
>> +
>> +/* Generic queue info structures */
>> +/* MB, CONFIG and EVENT q do not have extended info */
>> +struct idpf_ctlq_create_info {
>> +       enum idpf_ctlq_type type;
>> +       int id; /* absolute queue offset passed as input
>> +                * -1 for default mailbox if present
>> +                */
>> +       u16 len; /* Queue length passed as input */
>> +       u16 buf_size; /* buffer size passed as input */
>> +       u64 base_address; /* output, HPA of the Queue start  */
>> +       struct idpf_ctlq_reg reg; /* registers accessed by ctlqs */
>> +
>> +       int ext_info_size;
>> +       void *ext_info; /* Specific to q type */
>> +};
>> +
>> +/* Control Queue information */
>> +struct idpf_ctlq_info {
>> +       struct list_head cq_list;
>> +
>> +       enum idpf_ctlq_type cq_type;
>> +       int q_id;
>> +       struct mutex cq_lock;           /* control queue lock */
>> +       /* used for interrupt processing */
>> +       u16 next_to_use;
>> +       u16 next_to_clean;
>> +       u16 next_to_post;               /* starting descriptor to post 
>> buffers
>> +                                        * to after recev
>> +                                        */
>> +
>> +       struct idpf_dma_mem desc_ring;  /* descriptor ring memory
>> +                                        * idpf_dma_mem is defined in 
>> OSdep.h
>> +                                        */
>> +       union {
>> +               struct idpf_dma_mem **rx_buff;
>> +               struct idpf_ctlq_msg **tx_msg;
>> +       } bi;
>> +
>> +       u16 buf_size;                   /* queue buffer size */
>> +       u16 ring_size;                  /* Number of descriptors */
>> +       struct idpf_ctlq_reg reg;       /* registers accessed by ctlqs */
>> +};
>> +
>> +/* PF/VF mailbox commands */
>> +enum idpf_mbx_opc {
>> +       /* idpf_mbq_opc_send_msg_to_pf:
>> +        *      usage: used by PF or VF to send a message to its CPF
>> +        *      target: RX queue and function ID of parent PF taken 
>> from HW
>> +        */
>> +       idpf_mbq_opc_send_msg_to_pf             = 0x0801,
>> +
>> +       /* idpf_mbq_opc_send_msg_to_vf:
>> +        *      usage: used by PF to send message to a VF
>> +        *      target: VF control queue ID must be specified in 
>> descriptor
>> +        */
>> +       idpf_mbq_opc_send_msg_to_vf             = 0x0802,
>> +
>> +       /* idpf_mbq_opc_send_msg_to_peer_pf:
>> +        *      usage: used by any function to send message to any 
>> peer PF
>> +        *      target: RX queue and host of parent PF taken from HW
>> +        */
>> +       idpf_mbq_opc_send_msg_to_peer_pf        = 0x0803,
>> +
>> +       /* idpf_mbq_opc_send_msg_to_peer_drv:
>> +        *      usage: used by any function to send message to any 
>> peer driver
>> +        *      target: RX queue and target host must be specific in 
>> descriptor
>> +        */
>> +       idpf_mbq_opc_send_msg_to_peer_drv       = 0x0804,
> 
> Why would these alternate message paths exist?  If the point of IDPF 
> model is that the CP is the center of the world, in what cases would the 
> PFs and VFs bypass the CP and talk to each other?
> 
Some of these are only applicable to CP. You're right, the naming and 
comments are confusing. We'll clean them up.

>> +};
>> +
>> +/* API supported for control queue management */
>> +/* Will init all required q including default mb.  "q_info" is an 
>> array of
>> + * create_info structs equal to the number of control queues to be 
>> created.
>> + */
>> +int idpf_ctlq_init(struct idpf_hw *hw, u8 num_q,
>> +                  struct idpf_ctlq_create_info *q_info);
>> +
>> +/* Allocate and initialize a single control queue, which will be 
>> added to the
>> + * control queue list; returns a handle to the created control queue
>> + */
>> +int idpf_ctlq_add(struct idpf_hw *hw,
>> +                 struct idpf_ctlq_create_info *qinfo,
>> +                 struct idpf_ctlq_info **cq);
>> +
>> +/* Deinitialize and deallocate a single control queue */
>> +void idpf_ctlq_remove(struct idpf_hw *hw,
>> +                     struct idpf_ctlq_info *cq);
>> +
>> +/* Sends messages to HW and will also free the buffer*/
>> +int idpf_ctlq_send(struct idpf_hw *hw,
>> +                  struct idpf_ctlq_info *cq,
>> +                  u16 num_q_msg,
>> +                  struct idpf_ctlq_msg q_msg[]);
>> +
>> +/* Receives messages and called by interrupt handler/polling
>> + * initiated by app/process. Also caller is supposed to free the buffers
>> + */
>> +int idpf_ctlq_recv(struct idpf_ctlq_info *cq, u16 *num_q_msg,
>> +                  struct idpf_ctlq_msg *q_msg);
>> +
>> +/* Reclaims send descriptors on HW write back */
>> +int idpf_ctlq_clean_sq(struct idpf_ctlq_info *cq, u16 *clean_count,
>> +                      struct idpf_ctlq_msg *msg_status[]);
>> +
>> +/* Indicate RX buffers are done being processed */
>> +int idpf_ctlq_post_rx_buffs(struct idpf_hw *hw,
>> +                           struct idpf_ctlq_info *cq,
>> +                           u16 *buff_count,
>> +                           struct idpf_dma_mem **buffs);
>> +
>> +/* Will destroy all q including the default mb */
>> +void idpf_ctlq_deinit(struct idpf_hw *hw);
>> +
>> +#endif /* _IDPF_CONTROLQ_API_H_ */
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_controlq_setup.c 
>> b/drivers/net/ethernet/intel/idpf/idpf_controlq_setup.c
>> new file mode 100644
>> index 000000000000..d15deb9ac546
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_controlq_setup.c
>> @@ -0,0 +1,175 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#include "idpf_controlq.h"
>> +
>> +/**
>> + * idpf_ctlq_alloc_desc_ring - Allocate Control Queue (CQ) rings
>> + * @hw: pointer to hw struct
>> + * @cq: pointer to the specific Control queue
>> + */
>> +static int idpf_ctlq_alloc_desc_ring(struct idpf_hw *hw,
>> +                                    struct idpf_ctlq_info *cq)
>> +{
>> +       size_t size = cq->ring_size * sizeof(struct idpf_ctlq_desc);
>> +
>> +       cq->desc_ring.va = idpf_alloc_dma_mem(hw, &cq->desc_ring, size);
>> +       if (!cq->desc_ring.va)
>> +               return -ENOMEM;
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>> + * idpf_ctlq_alloc_bufs - Allocate Control Queue (CQ) buffers
>> + * @hw: pointer to hw struct
>> + * @cq: pointer to the specific Control queue
>> + *
>> + * Allocate the buffer head for all control queues, and if it's a 
>> receive
>> + * queue, allocate DMA buffers
>> + */
>> +static int idpf_ctlq_alloc_bufs(struct idpf_hw *hw,
>> +                               struct idpf_ctlq_info *cq)
>> +{
>> +       int i = 0;
>> +
>> +       /* Do not allocate DMA buffers for transmit queues */
>> +       if (cq->cq_type == IDPF_CTLQ_TYPE_MAILBOX_TX)
>> +               return 0;
>> +
>> +       /* We'll be allocating the buffer info memory first, then we can
>> +        * allocate the mapped buffers for the event processing
>> +        */
>> +       cq->bi.rx_buff = kcalloc(cq->ring_size, sizeof(struct 
>> idpf_dma_mem *),
>> +                                GFP_KERNEL);
>> +       if (!cq->bi.rx_buff)
>> +               return -ENOMEM;
>> +
>> +       /* allocate the mapped buffers (except for the last one) */
>> +       for (i = 0; i < cq->ring_size - 1; i++) {
>> +               struct idpf_dma_mem *bi;
>> +               int num = 1; /* number of idpf_dma_mem to be allocated */
>> +
>> +               cq->bi.rx_buff[i] = kcalloc(num, sizeof(struct 
>> idpf_dma_mem),
>> +                                           GFP_KERNEL);
>> +               if (!cq->bi.rx_buff[i])
>> +                       goto unwind_alloc_cq_bufs;
>> +
>> +               bi = cq->bi.rx_buff[i];
>> +
>> +               bi->va = idpf_alloc_dma_mem(hw, bi, cq->buf_size);
>> +               if (!bi->va) {
>> +                       /* unwind will not free the failed entry */
>> +                       kfree(cq->bi.rx_buff[i]);
>> +                       goto unwind_alloc_cq_bufs;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +
>> +unwind_alloc_cq_bufs:
>> +       /* don't try to free the one that failed... */
>> +       i--;
>> +       for (; i >= 0; i--) {
>> +               idpf_free_dma_mem(hw, cq->bi.rx_buff[i]);
>> +               kfree(cq->bi.rx_buff[i]);
>> +       }
>> +       kfree(cq->bi.rx_buff);
>> +
>> +       return -ENOMEM;
>> +}
>> +
>> +/**
>> + * idpf_ctlq_free_desc_ring - Free Control Queue (CQ) rings
>> + * @hw: pointer to hw struct
>> + * @cq: pointer to the specific Control queue
>> + *
>> + * This assumes the posted send buffers have already been cleaned
>> + * and de-allocated
>> + */
>> +static void idpf_ctlq_free_desc_ring(struct idpf_hw *hw,
>> +                                    struct idpf_ctlq_info *cq)
>> +{
>> +       idpf_free_dma_mem(hw, &cq->desc_ring);
>> +}
>> +
>> +/**
>> + * idpf_ctlq_free_bufs - Free CQ buffer info elements
>> + * @hw: pointer to hw struct
>> + * @cq: pointer to the specific Control queue
>> + *
>> + * Free the DMA buffers for RX queues, and DMA buffer header for both 
>> RX and TX
>> + * queues.  The upper layers are expected to manage freeing of TX DMA 
>> buffers
>> + */
>> +static void idpf_ctlq_free_bufs(struct idpf_hw *hw, struct 
>> idpf_ctlq_info *cq)
>> +{
>> +       void *bi;
>> +
>> +       if (cq->cq_type == IDPF_CTLQ_TYPE_MAILBOX_RX) {
>> +               int i;
>> +
>> +               /* free DMA buffers for rx queues*/
>> +               for (i = 0; i < cq->ring_size; i++) {
>> +                       if (cq->bi.rx_buff[i]) {
>> +                               idpf_free_dma_mem(hw, cq->bi.rx_buff[i]);
>> +                               kfree(cq->bi.rx_buff[i]);
>> +                       }
>> +               }
>> +
>> +               bi = (void *)cq->bi.rx_buff;
>> +       } else {
>> +               bi = (void *)cq->bi.tx_msg;
>> +       }
>> +
>> +       /* free the buffer header */
>> +       kfree(bi);
>> +}
>> +
>> +/**
>> + * idpf_ctlq_dealloc_ring_res - Free memory allocated for control queue
>> + * @hw: pointer to hw struct
>> + * @cq: pointer to the specific Control queue
>> + *
>> + * Free the memory used by the ring, buffers and other related 
>> structures
>> + */
>> +void idpf_ctlq_dealloc_ring_res(struct idpf_hw *hw, struct 
>> idpf_ctlq_info *cq)
>> +{
>> +       /* free ring buffers and the ring itself */
>> +       idpf_ctlq_free_bufs(hw, cq);
>> +       idpf_ctlq_free_desc_ring(hw, cq);
>> +}
>> +
>> +/**
>> + * idpf_ctlq_alloc_ring_res - allocate memory for descriptor ring and 
>> bufs
>> + * @hw: pointer to hw struct
>> + * @cq: pointer to control queue struct
>> + *
>> + * Do *NOT* hold the lock when calling this as the memory allocation 
>> routines
>> + * called are not going to be atomic context safe
> 
> Which lock are you referring to here?  You've got several defined.
> Maybe you can add a check to be sure it is not set?
> 
This is for cq_lock, I will update the comment and we can also look into 
adding a check as well.

>> + */
>> +int idpf_ctlq_alloc_ring_res(struct idpf_hw *hw, struct 
>> idpf_ctlq_info *cq)
>> +{
>> +       int ret_code;
>> +
>> +       /* verify input for valid configuration */
>> +       if (!cq->ring_size || !cq->buf_size)
>> +               return -EINVAL;
>> +
>> +       /* allocate the ring memory */
>> +       ret_code = idpf_ctlq_alloc_desc_ring(hw, cq);
>> +       if (ret_code)
>> +               return ret_code;
>> +
>> +       /* allocate buffers in the rings */
>> +       ret_code = idpf_ctlq_alloc_bufs(hw, cq);
>> +       if (ret_code)
>> +               goto idpf_init_cq_free_ring;
>> +
>> +       /* success! */
>> +       return 0;
>> +
>> +idpf_init_cq_free_ring:
>> +       idpf_free_dma_mem(hw, &cq->desc_ring);
>> +
>> +       return ret_code;
>> +}
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_dev.c 
>> b/drivers/net/ethernet/intel/idpf/idpf_dev.c
>> new file mode 100644
>> index 000000000000..7c0c8a14aba9
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_dev.c
>> @@ -0,0 +1,89 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#include "idpf.h"
>> +#include "idpf_lan_pf_regs.h"
>> +
>> +/**
>> + * idpf_ctlq_reg_init - initialize default mailbox registers
>> + * @cq: pointer to the array of create control queues
>> + */
>> +static void idpf_ctlq_reg_init(struct idpf_ctlq_create_info *cq)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < IDPF_NUM_DFLT_MBX_Q; i++) {
>> +               struct idpf_ctlq_create_info *ccq = cq + i;
>> +
>> +               switch (ccq->type) {
>> +               case IDPF_CTLQ_TYPE_MAILBOX_TX:
>> +                       /* set head and tail registers in our local 
>> struct */
>> +                       ccq->reg.head = PF_FW_ATQH;
>> +                       ccq->reg.tail = PF_FW_ATQT;
>> +                       ccq->reg.len = PF_FW_ATQLEN;
>> +                       ccq->reg.bah = PF_FW_ATQBAH;
>> +                       ccq->reg.bal = PF_FW_ATQBAL;
>> +                       ccq->reg.len_mask = PF_FW_ATQLEN_ATQLEN_M;
>> +                       ccq->reg.len_ena_mask = PF_FW_ATQLEN_ATQENABLE_M;
>> +                       ccq->reg.head_mask = PF_FW_ATQH_ATQH_M;
>> +                       break;
>> +               case IDPF_CTLQ_TYPE_MAILBOX_RX:
>> +                       /* set head and tail registers in our local 
>> struct */
>> +                       ccq->reg.head = PF_FW_ARQH;
>> +                       ccq->reg.tail = PF_FW_ARQT;
>> +                       ccq->reg.len = PF_FW_ARQLEN;
>> +                       ccq->reg.bah = PF_FW_ARQBAH;
>> +                       ccq->reg.bal = PF_FW_ARQBAL;
>> +                       ccq->reg.len_mask = PF_FW_ARQLEN_ARQLEN_M;
>> +                       ccq->reg.len_ena_mask = PF_FW_ARQLEN_ARQENABLE_M;
>> +                       ccq->reg.head_mask = PF_FW_ARQH_ARQH_M;
>> +                       break;
>> +               default:
>> +                       break;
>> +               }
>> +       }
>> +}
>> +
>> +/**
>> + * idpf_reset_reg_init - Initialize reset registers
>> + * @adapter: Driver specific private structure
>> + */
>> +static void idpf_reset_reg_init(struct idpf_adapter *adapter)
>> +{
>> +       adapter->reset_reg.rstat = idpf_get_reg_addr(adapter, 
>> PFGEN_RSTAT);
>> +       adapter->reset_reg.rstat_m = PFGEN_RSTAT_PFR_STATE_M;
>> +}
>> +
>> +/**
>> + * idpf_trigger_reset - trigger reset
>> + * @adapter: Driver specific private structure
>> + * @trig_cause: Reason to trigger a reset
>> + */
>> +static void idpf_trigger_reset(struct idpf_adapter *adapter,
>> +                              enum idpf_flags __always_unused 
>> trig_cause)
>> +{
>> +       u32 reset_reg;
>> +
>> +       reset_reg = readl(idpf_get_reg_addr(adapter, PFGEN_CTRL));
>> +       writel(reset_reg | PFGEN_CTRL_PFSWR, 
>> idpf_get_reg_addr(adapter, PFGEN_CTRL));
>> +}
>> +
>> +/**
>> + * idpf_reg_ops_init - Initialize register API function pointers
>> + * @adapter: Driver specific private structure
>> + */
>> +static void idpf_reg_ops_init(struct idpf_adapter *adapter)
>> +{
>> +       adapter->dev_ops.reg_ops.ctlq_reg_init = idpf_ctlq_reg_init;
>> +       adapter->dev_ops.reg_ops.reset_reg_init = idpf_reset_reg_init;
>> +       adapter->dev_ops.reg_ops.trigger_reset = idpf_trigger_reset;
>> +}
>> +
>> +/**
>> + * idpf_dev_ops_init - Initialize device API function pointers
>> + * @adapter: Driver specific private structure
>> + */
>> +void idpf_dev_ops_init(struct idpf_adapter *adapter)
>> +{
>> +       idpf_reg_ops_init(adapter);
>> +}
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h 
>> b/drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
>> new file mode 100644
>> index 000000000000..9cc9610990b4
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
>> @@ -0,0 +1,70 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#ifndef _IDPF_LAN_PF_REGS_H_
>> +#define _IDPF_LAN_PF_REGS_H_
>> +
>> +/* Receive queues */
>> +#define PF_QRX_BASE                    0x00000000
>> +#define PF_QRX_TAIL(_QRX)              (PF_QRX_BASE + (((_QRX) * 
>> 0x1000)))
>> +#define PF_QRX_BUFFQ_BASE              0x03000000
>> +#define PF_QRX_BUFFQ_TAIL(_QRX)                (PF_QRX_BUFFQ_BASE + 
>> (((_QRX) * 0x1000)))
>> +
>> +/* Transmit queues */
>> +#define PF_QTX_BASE                    0x05000000
>> +#define PF_QTX_COMM_DBELL(_DBQM)       (PF_QTX_BASE + ((_DBQM) * 
>> 0x1000))
>> +
>> +/* Control(PF Mailbox) Queue */
>> +#define PF_FW_BASE                     0x08400000
>> +
>> +#define PF_FW_ARQBAL                   (PF_FW_BASE)
>> +#define PF_FW_ARQBAH                   (PF_FW_BASE + 0x4)
>> +#define PF_FW_ARQLEN                   (PF_FW_BASE + 0x8)
>> +#define PF_FW_ARQLEN_ARQLEN_S          0
>> +#define PF_FW_ARQLEN_ARQLEN_M          GENMASK(12, 0)
>> +#define PF_FW_ARQLEN_ARQVFE_S          28
>> +#define PF_FW_ARQLEN_ARQVFE_M          BIT(PF_FW_ARQLEN_ARQVFE_S)
>> +#define PF_FW_ARQLEN_ARQOVFL_S         29
>> +#define PF_FW_ARQLEN_ARQOVFL_M         BIT(PF_FW_ARQLEN_ARQOVFL_S)
>> +#define PF_FW_ARQLEN_ARQCRIT_S         30
>> +#define PF_FW_ARQLEN_ARQCRIT_M         BIT(PF_FW_ARQLEN_ARQCRIT_S)
>> +#define PF_FW_ARQLEN_ARQENABLE_S       31
>> +#define PF_FW_ARQLEN_ARQENABLE_M       BIT(PF_FW_ARQLEN_ARQENABLE_S)
>> +#define PF_FW_ARQH                     (PF_FW_BASE + 0xC)
>> +#define PF_FW_ARQH_ARQH_S              0
>> +#define PF_FW_ARQH_ARQH_M              GENMASK(12, 0)
>> +#define PF_FW_ARQT                     (PF_FW_BASE + 0x10)
>> +
>> +#define PF_FW_ATQBAL                   (PF_FW_BASE + 0x14)
>> +#define PF_FW_ATQBAH                   (PF_FW_BASE + 0x18)
>> +#define PF_FW_ATQLEN                   (PF_FW_BASE + 0x1C)
>> +#define PF_FW_ATQLEN_ATQLEN_S          0
>> +#define PF_FW_ATQLEN_ATQLEN_M          GENMASK(9, 0)
>> +#define PF_FW_ATQLEN_ATQVFE_S          28
>> +#define PF_FW_ATQLEN_ATQVFE_M          BIT(PF_FW_ATQLEN_ATQVFE_S)
>> +#define PF_FW_ATQLEN_ATQOVFL_S         29
>> +#define PF_FW_ATQLEN_ATQOVFL_M         BIT(PF_FW_ATQLEN_ATQOVFL_S)
>> +#define PF_FW_ATQLEN_ATQCRIT_S         30
>> +#define PF_FW_ATQLEN_ATQCRIT_M         BIT(PF_FW_ATQLEN_ATQCRIT_S)
>> +#define PF_FW_ATQLEN_ATQENABLE_S       31
>> +#define PF_FW_ATQLEN_ATQENABLE_M       BIT(PF_FW_ATQLEN_ATQENABLE_S)
>> +#define PF_FW_ATQH                     (PF_FW_BASE + 0x20)
>> +#define PF_FW_ATQH_ATQH_S              0
>> +#define PF_FW_ATQH_ATQH_M              GENMASK(9, 0)
>> +#define PF_FW_ATQT                     (PF_FW_BASE + 0x24)
>> +
>> +/* Reset registers */
>> +#define PFGEN_RTRIG                    0x08407000
>> +#define PFGEN_RTRIG_CORER_S            0
>> +#define PFGEN_RTRIG_CORER_M            BIT(0)
>> +#define PFGEN_RTRIG_LINKR_S            1
>> +#define PFGEN_RTRIG_LINKR_M            BIT(1)
>> +#define PFGEN_RTRIG_IMCR_S             2
>> +#define PFGEN_RTRIG_IMCR_M             BIT(2)
>> +#define PFGEN_RSTAT                    0x08407008 /* PFR Status */
>> +#define PFGEN_RSTAT_PFR_STATE_S                0
>> +#define PFGEN_RSTAT_PFR_STATE_M                GENMASK(1, 0)
>> +#define PFGEN_CTRL                     0x0840700C
>> +#define PFGEN_CTRL_PFSWR               BIT(0)
>> +
>> +#endif
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h 
>> b/drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
>> new file mode 100644
>> index 000000000000..8040bedea2fd
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
>> @@ -0,0 +1,65 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#ifndef _IDPF_LAN_VF_REGS_H_
>> +#define _IDPF_LAN_VF_REGS_H_
>> +
>> +/* Reset */
>> +#define VFGEN_RSTAT                    0x00008800
>> +#define VFGEN_RSTAT_VFR_STATE_S                0
>> +#define VFGEN_RSTAT_VFR_STATE_M                GENMASK(1, 0)
>> +
>> +/* Control(VF Mailbox) Queue */
>> +#define VF_BASE                                0x00006000
>> +
>> +#define VF_ATQBAL                      (VF_BASE + 0x1C00)
>> +#define VF_ATQBAH                      (VF_BASE + 0x1800)
>> +#define VF_ATQLEN                      (VF_BASE + 0x0800)
>> +#define VF_ATQLEN_ATQLEN_S             0
>> +#define VF_ATQLEN_ATQLEN_M             GENMASK(9, 0)
>> +#define VF_ATQLEN_ATQVFE_S             28
>> +#define VF_ATQLEN_ATQVFE_M             BIT(VF_ATQLEN_ATQVFE_S)
>> +#define VF_ATQLEN_ATQOVFL_S            29
>> +#define VF_ATQLEN_ATQOVFL_M            BIT(VF_ATQLEN_ATQOVFL_S)
>> +#define VF_ATQLEN_ATQCRIT_S            30
>> +#define VF_ATQLEN_ATQCRIT_M            BIT(VF_ATQLEN_ATQCRIT_S)
>> +#define VF_ATQLEN_ATQENABLE_S          31
>> +#define VF_ATQLEN_ATQENABLE_M          BIT(VF_ATQLEN_ATQENABLE_S)
>> +#define VF_ATQH                                (VF_BASE + 0x0400)
>> +#define VF_ATQH_ATQH_S                 0
>> +#define VF_ATQH_ATQH_M                 GENMASK(9, 0)
>> +#define VF_ATQT                                (VF_BASE + 0x2400)
>> +
>> +#define VF_ARQBAL                      (VF_BASE + 0x0C00)
>> +#define VF_ARQBAH                      (VF_BASE)
>> +#define VF_ARQLEN                      (VF_BASE + 0x2000)
>> +#define VF_ARQLEN_ARQLEN_S             0
>> +#define VF_ARQLEN_ARQLEN_M             GENMASK(9, 0)
>> +#define VF_ARQLEN_ARQVFE_S             28
>> +#define VF_ARQLEN_ARQVFE_M             BIT(VF_ARQLEN_ARQVFE_S)
>> +#define VF_ARQLEN_ARQOVFL_S            29
>> +#define VF_ARQLEN_ARQOVFL_M            BIT(VF_ARQLEN_ARQOVFL_S)
>> +#define VF_ARQLEN_ARQCRIT_S            30
>> +#define VF_ARQLEN_ARQCRIT_M            BIT(VF_ARQLEN_ARQCRIT_S)
>> +#define VF_ARQLEN_ARQENABLE_S          31
>> +#define VF_ARQLEN_ARQENABLE_M          BIT(VF_ARQLEN_ARQENABLE_S)
>> +#define VF_ARQH                                (VF_BASE + 0x1400)
>> +#define VF_ARQH_ARQH_S                 0
>> +#define VF_ARQH_ARQH_M                 GENMASK(12, 0)
>> +#define VF_ARQT                                (VF_BASE + 0x1000)
>> +
>> +/* Transmit queues */
>> +#define VF_QTX_TAIL_BASE               0x00000000
>> +#define VF_QTX_TAIL(_QTX)              (VF_QTX_TAIL_BASE + (_QTX) * 0x4)
>> +#define VF_QTX_TAIL_EXT_BASE           0x00040000
>> +#define VF_QTX_TAIL_EXT(_QTX)          (VF_QTX_TAIL_EXT_BASE + 
>> ((_QTX) * 4))
>> +
>> +/* Receive queues */
>> +#define VF_QRX_TAIL_BASE               0x00002000
>> +#define VF_QRX_TAIL(_QRX)              (VF_QRX_TAIL_BASE + ((_QRX) * 4))
>> +#define VF_QRX_TAIL_EXT_BASE           0x00050000
>> +#define VF_QRX_TAIL_EXT(_QRX)          (VF_QRX_TAIL_EXT_BASE + 
>> ((_QRX) * 4))
>> +#define VF_QRXB_TAIL_BASE              0x00060000
>> +#define VF_QRXB_TAIL(_QRX)             (VF_QRXB_TAIL_BASE + ((_QRX) * 
>> 4))
>> +
>> +#endif
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c 
>> b/drivers/net/ethernet/intel/idpf/idpf_lib.c
>> new file mode 100644
>> index 000000000000..d4f346312915
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
>> @@ -0,0 +1,145 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#include "idpf.h"
>> +
>> +/**
>> + * idpf_check_reset_complete - check that reset is complete
>> + * @hw: pointer to hw struct
>> + * @reset_reg: struct with reset registers
>> + *
>> + * Returns 0 if device is ready to use, or -EBUSY if it's in reset.
>> + **/
>> +static int idpf_check_reset_complete(struct idpf_hw *hw,
>> +                                    struct idpf_reset_reg *reset_reg)
>> +{
>> +       struct idpf_adapter *adapter = (struct idpf_adapter *)hw->back;
>> +       int i;
>> +
>> +       for (i = 0; i < 2000; i++) {
>> +               u32 reg_val = readl(reset_reg->rstat);
>> +
>> +               /* 0xFFFFFFFF might be read if other side hasn't 
>> cleared the
>> +                * register for us yet and 0xFFFFFFFF is not a valid 
>> value for
>> +                * the register, so treat that as invalid.
>> +                */
>> +               if (reg_val != 0xFFFFFFFF && (reg_val & 
>> reset_reg->rstat_m))
>> +                       return 0;
>> +
>> +               usleep_range(5000, 10000);
>> +       }
>> +
>> +       dev_warn(&adapter->pdev->dev, "Device reset timeout!\n");
>> +       /* Clear the reset flag unconditionally here since the reset
>> +        * technically isn't in progress anymore from the driver's 
>> perspective
>> +        */
>> +       clear_bit(__IDPF_HR_RESET_IN_PROG, adapter->flags);
>> +
>> +       return -EBUSY;
>> +}
>> +
>> +/**
>> + * idpf_init_hard_reset - Initiate a hardware reset
>> + * @adapter: Driver specific private structure
>> + *
>> + * Deallocate the vports and all the resources associated with them and
>> + * reallocate. Also reinitialize the mailbox. Return 0 on success,
>> + * negative on failure.
>> + */
>> +static int idpf_init_hard_reset(struct idpf_adapter *adapter)
>> +{
>> +       struct idpf_reg_ops *reg_ops = &adapter->dev_ops.reg_ops;
>> +       struct device *dev = &adapter->pdev->dev;
>> +       int err;
>> +
>> +       mutex_lock(&adapter->reset_lock);
>> +
>> +       dev_info(dev, "Device HW Reset initiated\n");
>> +       /* Prepare for reset */
>> +       if (test_and_clear_bit(__IDPF_HR_DRV_LOAD, adapter->flags)) {
>> +               reg_ops->trigger_reset(adapter, __IDPF_HR_DRV_LOAD);
>> +       } else if (test_and_clear_bit(__IDPF_HR_FUNC_RESET, 
>> adapter->flags)) {
>> +               bool is_reset = idpf_is_reset_detected(adapter);
>> +
>> +               if (!is_reset)
>> +                       reg_ops->trigger_reset(adapter, 
>> __IDPF_HR_FUNC_RESET);
>> +               idpf_deinit_dflt_mbx(adapter);
>> +       } else {
>> +               dev_err(dev, "Unhandled hard reset cause\n");
>> +               err = -EBADRQC;
>> +               goto handle_err;
>> +       }
>> +
>> +       /* Wait for reset to complete */
>> +       err = idpf_check_reset_complete(&adapter->hw, 
>> &adapter->reset_reg);
>> +       if (err) {
>> +               dev_err(dev, "The driver was unable to contact the 
>> device's firmware. Check that the FW is running. Driver state= 0x%x\n",
>> +                       adapter->state);
>> +               goto handle_err;
>> +       }
>> +
>> +       /* Reset is complete and so start building the driver 
>> resources again */
>> +       err = idpf_init_dflt_mbx(adapter);
>> +       if (err)
>> +               dev_err(dev, "Failed to initialize default mailbox: 
>> %d\n", err);
>> +
>> +handle_err:
>> +       mutex_unlock(&adapter->reset_lock);
>> +
>> +       return err;
>> +}
>> +
>> +/**
>> + * idpf_vc_event_task - Handle virtchannel event logic
>> + * @work: work queue struct
>> + */
>> +void idpf_vc_event_task(struct work_struct *work)
>> +{
>> +       struct idpf_adapter *adapter;
>> +
>> +       adapter = container_of(work, struct idpf_adapter, 
>> vc_event_task.work);
>> +
>> +       if (test_bit(__IDPF_REMOVE_IN_PROG, adapter->flags))
>> +               return;
>> +
>> +       if (test_bit(__IDPF_HR_CORE_RESET, adapter->flags) ||
>> +           test_bit(__IDPF_HR_FUNC_RESET, adapter->flags) ||
>> +           test_bit(__IDPF_HR_DRV_LOAD, adapter->flags)) {
>> +               set_bit(__IDPF_HR_RESET_IN_PROG, adapter->flags);
>> +               idpf_init_hard_reset(adapter);
> 
> Should you be testing for RESET_IN_PROG already in progress?
> 
The reset_lock should make sure that is not the case.

>> +       }
>> +}
>> +
>> +/**
>> + * idpf_alloc_dma_mem - Allocate dma memory
>> + * @hw: pointer to hw struct
>> + * @mem: pointer to dma_mem struct
>> + * @size: size of the memory to allocate
>> + */
>> +void *idpf_alloc_dma_mem(struct idpf_hw *hw, struct idpf_dma_mem 
>> *mem, u64 size)
>> +{
>> +       struct idpf_adapter *adapter = (struct idpf_adapter *)hw->back;
>> +       size_t sz = ALIGN(size, 4096);
>> +
>> +       mem->va = dma_alloc_coherent(&adapter->pdev->dev, sz,
>> +                                    &mem->pa, GFP_KERNEL | __GFP_ZERO);
>> +       mem->size = sz;
>> +
>> +       return mem->va;
>> +}
>> +
>> +/**
>> + * idpf_free_dma_mem - Free the allocated dma memory
>> + * @hw: pointer to hw struct
>> + * @mem: pointer to dma_mem struct
>> + */
>> +void idpf_free_dma_mem(struct idpf_hw *hw, struct idpf_dma_mem *mem)
>> +{
>> +       struct idpf_adapter *adapter = (struct idpf_adapter *)hw->back;
>> +
>> +       dma_free_coherent(&adapter->pdev->dev, mem->size,
>> +                         mem->va, mem->pa);
>> +       mem->size = 0;
>> +       mem->va = NULL;
>> +       mem->pa = 0;
>> +}
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c 
>> b/drivers/net/ethernet/intel/idpf/idpf_main.c
>> index e290f560ce14..4bb0727f7abd 100644
>> --- a/drivers/net/ethernet/intel/idpf/idpf_main.c
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
>> @@ -17,6 +17,21 @@ static void idpf_remove(struct pci_dev *pdev)
>>   {
>>          struct idpf_adapter *adapter = pci_get_drvdata(pdev);
>>
>> +       set_bit(__IDPF_REMOVE_IN_PROG, adapter->flags);
>> +
>> +       /* Wait until vc_event_task is done to consider if any hard 
>> reset is
>> +        * in progress else we may go ahead and release the resources 
>> but the
>> +        * thread doing the hard reset might continue the init path and
>> +        * end up in bad state.
>> +        */
>> +       cancel_delayed_work_sync(&adapter->vc_event_task);
>> +       /* Be a good citizen and leave the device clean on exit */
>> +       adapter->dev_ops.reg_ops.trigger_reset(adapter, 
>> __IDPF_HR_FUNC_RESET);
>> +       idpf_deinit_dflt_mbx(adapter);
>> +
>> +       destroy_workqueue(adapter->vc_event_wq);
>> +       mutex_destroy(&adapter->reset_lock);
>> +
>>          pci_disable_pcie_error_reporting(pdev);
>>          pci_set_drvdata(pdev, NULL);
>>          kfree(adapter);
>> @@ -73,8 +88,22 @@ static int idpf_probe(struct pci_dev *pdev, const 
>> struct pci_device_id *ent)
>>          adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
>>          if (!adapter)
>>                  return -ENOMEM;
>> -       adapter->pdev = pdev;
>>
>> +       switch (ent->device) {
>> +       case IDPF_DEV_ID_PF:
>> +               idpf_dev_ops_init(adapter);
>> +               break;
>> +       case IDPF_DEV_ID_VF:
>> +               idpf_vf_dev_ops_init(adapter);
>> +               break;
>> +       default:
>> +               err = -ENODEV;
>> +               dev_err(&pdev->dev, "Unexpected dev ID 0x%x in idpf 
>> probe\n",
>> +                       ent->device);
>> +               goto err_free;
>> +       }
>> +
>> +       adapter->pdev = pdev;
>>          err = pcim_enable_device(pdev);
>>          if (err)
>>                  goto err_free;
>> @@ -98,6 +127,15 @@ static int idpf_probe(struct pci_dev *pdev, const 
>> struct pci_device_id *ent)
>>          pci_set_master(pdev);
>>          pci_set_drvdata(pdev, adapter);
>>
>> +       adapter->vc_event_wq = alloc_workqueue("%s-%s-vc_event", 0, 0,
>> +                                              dev_driver_string(dev),
>> +                                              dev_name(dev));
>> +       if (!adapter->vc_event_wq) {
>> +               dev_err(dev, "Failed to allocate virtchnl event 
>> workqueue\n");
>> +               err = -ENOMEM;
>> +               goto err_vc_event_wq_alloc;
>> +       }
>> +
>>          /* setup msglvl */
>>          adapter->msg_enable = netif_msg_init(-1, IDPF_AVAIL_NETIF_M);
>>
>> @@ -108,9 +146,20 @@ static int idpf_probe(struct pci_dev *pdev, const 
>> struct pci_device_id *ent)
>>                  goto err_cfg_hw;
>>          }
>>
>> +       mutex_init(&adapter->reset_lock);
>> +
>> +       INIT_DELAYED_WORK(&adapter->vc_event_task, idpf_vc_event_task);
>> +
>> +       adapter->dev_ops.reg_ops.reset_reg_init(adapter);
>> +       set_bit(__IDPF_HR_DRV_LOAD, adapter->flags);
>> +       queue_delayed_work(adapter->vc_event_wq, &adapter->vc_event_task,
>> +                          msecs_to_jiffies(10 * (pdev->devfn & 0x07)));
>> +
>>          return 0;
>>
>>   err_cfg_hw:
>> +       destroy_workqueue(adapter->vc_event_wq);
>> +err_vc_event_wq_alloc:
>>          pci_disable_pcie_error_reporting(pdev);
>>   err_free:
>>          kfree(adapter);
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_mem.h 
>> b/drivers/net/ethernet/intel/idpf/idpf_mem.h
>> new file mode 100644
>> index 000000000000..b21a04fccf0f
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_mem.h
>> @@ -0,0 +1,20 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#ifndef _IDPF_MEM_H_
>> +#define _IDPF_MEM_H_
>> +
>> +#include <linux/io.h>
>> +
>> +struct idpf_dma_mem {
>> +       void *va;
>> +       dma_addr_t pa;
>> +       size_t size;
>> +};
>> +
>> +#define wr32(a, reg, value)    writel((value), ((a)->hw_addr + (reg)))
>> +#define rd32(a, reg)           readl((a)->hw_addr + (reg))
>> +#define wr64(a, reg, value)    writeq((value), ((a)->hw_addr + (reg)))
>> +#define rd64(a, reg)           readq((a)->hw_addr + (reg))
>> +
>> +#endif /* _IDPF_MEM_H_ */
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c 
>> b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
>> new file mode 100644
>> index 000000000000..facf525e8e44
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
>> @@ -0,0 +1,86 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#include "idpf.h"
>> +#include "idpf_lan_vf_regs.h"
>> +
>> +/**
>> + * idpf_vf_ctlq_reg_init - initialize default mailbox registers
>> + * @cq: pointer to the array of create control queues
>> + */
>> +static void idpf_vf_ctlq_reg_init(struct idpf_ctlq_create_info *cq)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < IDPF_NUM_DFLT_MBX_Q; i++) {
>> +               struct idpf_ctlq_create_info *ccq = cq + i;
>> +
>> +               switch (ccq->type) {
>> +               case IDPF_CTLQ_TYPE_MAILBOX_TX:
>> +                       /* set head and tail registers in our local 
>> struct */
>> +                       ccq->reg.head = VF_ATQH;
>> +                       ccq->reg.tail = VF_ATQT;
>> +                       ccq->reg.len = VF_ATQLEN;
>> +                       ccq->reg.bah = VF_ATQBAH;
>> +                       ccq->reg.bal = VF_ATQBAL;
>> +                       ccq->reg.len_mask = VF_ATQLEN_ATQLEN_M;
>> +                       ccq->reg.len_ena_mask = VF_ATQLEN_ATQENABLE_M;
>> +                       ccq->reg.head_mask = VF_ATQH_ATQH_M;
>> +                       break;
>> +               case IDPF_CTLQ_TYPE_MAILBOX_RX:
>> +                       /* set head and tail registers in our local 
>> struct */
>> +                       ccq->reg.head = VF_ARQH;
>> +                       ccq->reg.tail = VF_ARQT;
>> +                       ccq->reg.len = VF_ARQLEN;
>> +                       ccq->reg.bah = VF_ARQBAH;
>> +                       ccq->reg.bal = VF_ARQBAL;
>> +                       ccq->reg.len_mask = VF_ARQLEN_ARQLEN_M;
>> +                       ccq->reg.len_ena_mask = VF_ARQLEN_ARQENABLE_M;
>> +                       ccq->reg.head_mask = VF_ARQH_ARQH_M;
>> +                       break;
>> +               default:
>> +                       break;
>> +               }
>> +       }
>> +}
>> +
>> +/**
>> + * idpf_vf_reset_reg_init - Initialize reset registers
>> + * @adapter: Driver specific private structure
>> + */
>> +static void idpf_vf_reset_reg_init(struct idpf_adapter *adapter)
>> +{
>> +       adapter->reset_reg.rstat = idpf_get_reg_addr(adapter, 
>> VFGEN_RSTAT);
>> +       adapter->reset_reg.rstat_m = VFGEN_RSTAT_VFR_STATE_M;
>> +}
>> +
>> +/**
>> + * idpf_vf_trigger_reset - trigger reset
>> + * @adapter: Driver specific private structure
>> + * @trig_cause: Reason to trigger a reset
>> + */
>> +static void idpf_vf_trigger_reset(struct idpf_adapter *adapter,
>> +                                 enum idpf_flags trig_cause)
>> +{
>> +       /* stub */
>> +}
>> +
>> +/**
>> + * idpf_vf_reg_ops_init - Initialize register API function pointers
>> + * @adapter: Driver specific private structure
>> + */
>> +static void idpf_vf_reg_ops_init(struct idpf_adapter *adapter)
>> +{
>> +       adapter->dev_ops.reg_ops.ctlq_reg_init = idpf_vf_ctlq_reg_init;
>> +       adapter->dev_ops.reg_ops.reset_reg_init = idpf_vf_reset_reg_init;
>> +       adapter->dev_ops.reg_ops.trigger_reset = idpf_vf_trigger_reset;
>> +}
>> +
>> +/**
>> + * idpf_vf_dev_ops_init - Initialize device API function pointers
>> + * @adapter: Driver specific private structure
>> + */
>> +void idpf_vf_dev_ops_init(struct idpf_adapter *adapter)
>> +{
>> +       idpf_vf_reg_ops_init(adapter);
>> +}
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c 
>> b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
>> new file mode 100644
>> index 000000000000..87298c99027d
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
>> @@ -0,0 +1,128 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#include "idpf.h"
>> +
>> +/**
>> + * idpf_mb_clean - Reclaim the send mailbox queue entries
>> + * @adapter: Driver specific private structure
>> + *
>> + * Reclaim the send mailbox queue entries to be used to send further 
>> messages
>> + *
>> + * Returns 0 on success, negative on failure
>> + */
>> +static int idpf_mb_clean(struct idpf_adapter *adapter)
>> +{
>> +       u16 i, num_q_msg = IDPF_DFLT_MBX_Q_LEN;
>> +       struct idpf_ctlq_msg **q_msg;
>> +       struct idpf_dma_mem *dma_mem;
>> +       int err;
>> +
>> +       if (!adapter->hw.asq)
>> +               return -EINVAL;
>> +
>> +       q_msg = kcalloc(num_q_msg, sizeof(struct idpf_ctlq_msg *), 
>> GFP_ATOMIC);
>> +       if (!q_msg)
>> +               return -ENOMEM;
>> +
>> +       err = idpf_ctlq_clean_sq(adapter->hw.asq, &num_q_msg, q_msg);
>> +       if (err)
>> +               goto err_kfree;
>> +
>> +       for (i = 0; i < num_q_msg; i++) {
>> +               if (!q_msg[i])
>> +                       continue;
>> +               dma_mem = q_msg[i]->ctx.indirect.payload;
>> +               if (dma_mem)
>> +                       dmam_free_coherent(&adapter->pdev->dev, 
>> dma_mem->size,
>> +                                          dma_mem->va, dma_mem->pa);
> 
> Should the be the non-devm version of dma_free?
> 
I am guessing this is related to your other comment regarding the use of 
dmam? If so we will clean it up as part of that conversion.

<snip>

Thanks,
Emil
