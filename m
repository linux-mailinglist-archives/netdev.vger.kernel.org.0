Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836B967A56D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbjAXWNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjAXWM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:12:58 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D08113E8
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674598377; x=1706134377;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O//hhVEeUqnaIXAVnGScGPAnU8Rg6BpW1FBVq8pWboQ=;
  b=T5pqE3EYjP8DfcBci/1FjNvOhA9j2yqlvs9IYI21GTHdoIAFdawIvQig
   XF1JOne24c8l9f5DtVqv0mhD4Az5xWct2BG/h+k4YZxKbQdz+mFsypPd9
   U2EcUVAC1ZVWyqbHKU1tJnlS1N4s9b4PXHYJDk44VgNymZK0uk5kpSn79
   nFED3Xs1hKuiqwBn9AePrtCHSxas1Dhp+nB1Ya5jkHo+VMPNsvO9TRMt3
   fuufJaYLXzSdYwmNaUNUJmABOB5jp2xxmCVsT4cKsXwYeYLGnpE2A2m5g
   Pi6m7Ap1Reb3g7YAWwF69uZGYHVxhiP67UFyEnepE6VXiqb+O7NjY2PQZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="390923282"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="390923282"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 14:12:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="991040877"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="991040877"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jan 2023 14:12:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 14:12:55 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 14:12:55 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 14:12:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3aSMjn/nPcxpdf8GKZDkkBonysvcPTNFsu6h23wG+nNgrc/JqTUtlWfbdEbLJzB028my1CsjpScX7SHPuFYwzyjR+iIkGujQ6FsZUNoH01UcldcwI6QymXBtf/29ZEj6V0WXDZL6idJncNJuob7nbHYfjGUjZmOnb/hA929OTVZCbb1EvvnD6X6UlulnkH6Wj0pvBWzuN7bxhYtjQM/0YduaKbzwZlxIT+KW6wXutoI4aWtrvu6dERIRTWT2UgFMzGZl6kRN7ZTRmGJgEULL07h8ghaJvcGNZXZANTCSRdAXkhK8fAbOCeY1MoAGGO2Ublh4SIr2FzDfhHvIrZUuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwCZx+8az2KYgrZ8V7FFxdtMVhjCtAQJEUx6+q3NL08=;
 b=RozgD/JJ4orRUIahyxb4bfzb25cIlPJwjVA/TIwRJKzK2mD2JSJBMTP0uvNJxTORWe8apc7fWP72oM5ZPfMZp+0kFnjQr0QsNLVleQ9coSGhhKVqoyYlYFp9RCNBxIYM72nziArQyp/AvMqSWPoanvQNBVcFnesG0RvfmaMO1R3AnED2drrfp4E5EqSMrvs089pZ6nYij5Y+qSLjrsJLc39654FMLXGDrWfIznUPCfC9q5XOodgdcMu1fBl8n6kkd0l9cx9TYVa2Jve2rTo33Wkubo2wtkULjjD2yz3Cnqs5WWLFCUiBUuH3Q4mtvtk3czvPuVW/8ts8MN41bJglgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4714.namprd11.prod.outlook.com (2603:10b6:303:5d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 22:12:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 22:12:54 +0000
Message-ID: <a29b1cba-e890-cab0-61ec-6de7c1cd4682@intel.com>
Date:   Tue, 24 Jan 2023 14:12:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Content-Language: en-US
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm@gmail.com" <habetsm@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
 <24448301-f6cd-2b8e-f9fa-570bc10953c9@intel.com>
 <681cda5d-9f8d-6986-9e45-baa3a30628d4@amd.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <681cda5d-9f8d-6986-9e45-baa3a30628d4@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0130.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW3PR11MB4714:EE_
X-MS-Office365-Filtering-Correlation-Id: e1ca2a87-f747-445a-d5c2-08dafe5823be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTsYJ7MjSOpYK2phiZY1UqLBZ8M+JHWEsPugPCr3KpkBJiThgwKguayehA6TmyEqOYPsRmekLrx+/y4LQpS10o57bAXXK1mo382n0jMUXVbkN7dpwq7pm6cjDpAz0gW5UR9q0jWpCea4YIVnGOp+TodbRb3wDlsKxwfnfzHp1LsrbU7IBIaQaqmA+0zKukIqNpneu5Hv1POPJgnK2qbSeQ12ubzSG/+ywDkttmMs7luaEV5FK50CNwmSNL3X9O/ivETSWudQfxD9kzG9p3Ay9Hw8Nu9cRcRDXaW6W2Sf4eeHPZjhk9HS1bU4o1qIeiRjrbh2yk5g9edPbILQEoTf72u6L/xlq3gIqoYW63rAEWXGIA9wYlP3cCFQcTjM1Gdm4ohSAjY4Gjzm1bwFpCj3jYxe/Ma6snLrNmd3PxLbRcn/m3M++RE0UmVzCGqbBpLzJkSzqrxBe/u4pJ0WmC8txQc4Irxas3L/cr+ztxK8h4maJl8ekdcfmsXMJHsOnMC1YKb+r5oxlzywREy8MnbFTvMVa2pjYCEP7q7cRyv3JFbsgif/BTV9zKJmOy/IzbgSsfRY4og8m1poMlxOpgyQjV50nzG3SCOFWWYdDd8lZbFn4NxAKHhNqU/Fh5tXHc5nhzq0imoKB4RUA9vtL4sY2VHnTyf9+/+nm6Zx+ZwCVzuZx5ZwgKO7inS9kXI+jPYsyVuLT3ZIznJKg4jWd8k5NKamorQacDB1c0UFdw8CMck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199018)(66556008)(6506007)(66946007)(66476007)(5660300002)(2906002)(41300700001)(8936002)(53546011)(38100700002)(8676002)(31686004)(4326008)(82960400001)(36756003)(2616005)(86362001)(54906003)(26005)(6512007)(6666004)(110136005)(316002)(6486002)(31696002)(478600001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3ptUjVGTW5BaG5ydEhiVlNqdUNIT2RSYWVHR1oxL2tEQVpzaXhybmc2NkJu?=
 =?utf-8?B?KzFGcUh0MkFRRjM2QU02SXE5dmlJT3Z0bWdaaXdQbHI1UmZrRXlIOXIyNGlF?=
 =?utf-8?B?dENiMkRRTzg1N0c2QSt0cWZDWEZDajZtOXBrQitLRHhKTTlwaU5GMGUxdWtO?=
 =?utf-8?B?WEtqNnhWd0FicDRXcXE1Z1hqRUNJMzcvQk12eUdVdy9qcTFvcUdFWGtmcWZa?=
 =?utf-8?B?OEtkcHRqTFNFOXUvUEh6aGJhMEwzdkNiWUlRMU9TYUVqYWZKZG9PVldKM0Yy?=
 =?utf-8?B?OXhDSTVWemkyaHRoS3IrYmpOR2dyZGh4Sk56TjFrekZDMFB4M3c3RVFBb2d4?=
 =?utf-8?B?YnovbHdvMVJMTG1MRnpQdmRvaEZBWElnMnFvSjdqZS9ueEhPUXE0SDQ0TjFi?=
 =?utf-8?B?NWxkUDF5eWlUUkM4Vmc0ZVJ3a3dhbUZadzJ4U29OU0ZKNCtNYnBYcldLSUlh?=
 =?utf-8?B?U295d21PSTV6V1ZwWHVweUxJelVrS1NmamdDR0JYa1dmMHVWazJjN2dORFV1?=
 =?utf-8?B?NVpNRm5wVk40UTJvWnphYkhPQ3RGOTgvRGlVd1NzOVovUFEwTnZYSDhRNjV1?=
 =?utf-8?B?cFFLL3A2c1pteTIrcllkZnVjMTVBRnVYMklrd1VIMVZUZXRqSURsbU8weGhp?=
 =?utf-8?B?UUx3MWs3bUJXYk4wczFpbVVlMXcyUkROMzg1bUEwVWQvZUExZm54VS9nMytR?=
 =?utf-8?B?YnMwdU0xUzVkWnRDNDErL01nK3BaOUdnZ1pYZ3h6YmVuOWZCRnB5TnU3QmRl?=
 =?utf-8?B?M0luSkJIRkluYmtteVJmZW9qdEwyS0RuYnEvQ0Q1dFlpdUVnalNKN3NGU3kz?=
 =?utf-8?B?azBaT2JOWTFQREJuLzJIR1BCSjEzQ3F2aytaZkxUOUFDcjdSdjJ1MTNEdEVN?=
 =?utf-8?B?Y0ZkU1lyNmhVT0gxSXlOMDBpNG45eWtpa0MvTjF6QnBUMDVwVCtuTjhuR2xE?=
 =?utf-8?B?MDQ4M1UxY3RQd2xBQms3U1NqUlJVRUdheGFaSEtDVG9vdFBFdHBGajRZMEd6?=
 =?utf-8?B?MWFJbkUxM3B4VTRIOW9HWWY4VXVoQ1VLR3B1Wmpzb0ZKNksyN3VoKzR5SXZR?=
 =?utf-8?B?TFhXbXFENVFYVmJZU0d1U25zUGNkcDhGYWxxc0FlR0Rnd3VwUWdvNE12WE9z?=
 =?utf-8?B?VmhlQXBuWTdkbnN2RXNFbFhhZWxYcnZranpwRXhFZ0pjYzN4MUc4czRsWCt5?=
 =?utf-8?B?VjdiNjF4WTh5MjBRcnEzZlJFVEZTUnJIYno2WFhranY1UEVZTllGMHhnMC96?=
 =?utf-8?B?amwwMG03bXZweE1ncGhLTHlydm9BcnFDU24zaVlqTlRQS3AzWGVlSGZaY3lN?=
 =?utf-8?B?cnlVekM2MGRsUEp5bW1ZaGtwVERYUXMrL0pqd2d2SGFHT0VVSkhkNVE0WUFq?=
 =?utf-8?B?bHR5WXNMci9jd0lDTkUybHlMT0pqS2hYNitMSmY4R2ZOTTdNN0NkMFdPdWZR?=
 =?utf-8?B?ZW5vb0tXL0JibXk0WW5JWW5VNWVzVlQxbzloNDhUQ3lUd3ZIOHhZMkdUaUxO?=
 =?utf-8?B?MW5XK1k5SnJxNllsNkh0RkttZzIwb2VDK3FBR25xQ2tDUTJpZzlFUFc5UFQ4?=
 =?utf-8?B?V1o1UDFCYlpWWFJWZFV5b3dMa2k2MTV2bzNGMmYwaWl5YTlPMWgwREpRSFBm?=
 =?utf-8?B?bWhUZ0FQNzY3OXd4a1hicE5vc2w1TXlCR09WNXg0eWR0dEhlZTZYUTI2clBH?=
 =?utf-8?B?bWM5UWgya244cXl1eTdzWDNHNzc0YS9JdlpKQ0R0NFE1Q1g2emxJV1RIZVhB?=
 =?utf-8?B?dnVCbUNMZWxQa0MybDM0V0NySUVkcHp5UkMvbUR3QXVXSGgzV0hpdUJQRnZy?=
 =?utf-8?B?QU9vZDZTUnRpLytURi9LUVhhbExuaHdyNnZZYXpXRjQ1Sy9JVEt1c1ZqdCtv?=
 =?utf-8?B?WkRjUzZXbXl2dDhvTnNiS1FDZERpYjBxb3RvRXMrY3FmT0ZpdnFDNTFxbkRt?=
 =?utf-8?B?Yi84MEtwbDBVUzEvV1N2NXB4ZVNtRVdoMWlwRmdnOFFKK3BDOGtGZkgyNE1K?=
 =?utf-8?B?WVVYZWlJZVFtdlMyWTIzUmFnYTZzL2ZZaWEvVVIydXphMGxxeTNWd2dPZjlt?=
 =?utf-8?B?bzYyMnpPUWhGQW1TQXhIdEFocEZjYURmeCtUR254Ry82bWtBa0dtamxPUzJC?=
 =?utf-8?B?UmhBUEhkQWRNVnFONDBDUHdMdDJkSDY3cFFwZzQ3dVh3MEcvemVCMGVkN1Jh?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ca2a87-f747-445a-d5c2-08dafe5823be
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 22:12:53.8976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpj0jglNoOiWy2SFdQEu4Sqzh0h7nACnSEd6Fy1NtL1OriHqIUZo48dboyt0L5HiArEHWj9Jke0XjsOzdDIAjTvdNX8D5PKVu35AOZGKUak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4714
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/2023 3:05 AM, Lucero Palau, Alejandro wrote:
> 
> On 1/19/23 23:40, Jacob Keller wrote:
>>
>> On 1/19/2023 3:31 AM, alejandro.lucero-palau@amd.com wrote:
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC	"fw.mgmt.suc"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC	"fw.mgmt.cmc"
>>> +#define EFX_DEVLINK_INFO_VERSION_FPGA_REV	"fpga.rev"
>>> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_HW	"fpga.app"
>>> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_FW	DEVLINK_INFO_VERSION_GENERIC_FW_APP
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_BOOT	"coproc.boot"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_UBOOT	"coproc.uboot"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_MAIN	"coproc.main"
>>> +#define EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY	"coproc.recovery"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_EXPROM	"fw.exprom"
>>> +#define EFX_DEVLINK_INFO_VERSION_FW_UEFI	"fw.uefi"
>> Here, you've defined several new versions, only one of which is
>> standard. I don't see an associated documentation addition. Please add a
>> ef100.rst file to Documentation/networking/devlink
>>
>> It is also preferred to use the standard names or extend the set of
>> standard names where appropriate first. Can you explain why you didn't
>> do that here?
>>
>> For example, the documentation for "fw.undi" indicates it may include
>> the UEFI driver, and I would expect your UEFI version to be something
>> like fw.undi or fw.undi.uefi if its distinct...
> 
> 
> I'm adding the doc file for v2.
> 
> About uefi/undi, we have uefi but not undi.
>

I believe this is the same as ice, and we still used fw.undi. From the doc:

UNDI software, may include the UEFI driver, firmware or both.

Basically whether it includes the UEFI driver, firmware, or both it
should still be fw.undi, and i would expect if you really must
separately version the components those would need sub-fields added to
the devlink-info.rst
