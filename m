Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241BE5874CA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 02:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbiHBA0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 20:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiHBA0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 20:26:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3876554
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 17:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659399968; x=1690935968;
  h=message-id:date:subject:from:to:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=dpLWDJ98L7fLHpG+1X88xwt2q/bLC7umoa47Moen2bE=;
  b=KrQKtKpa0q3i3UwTbVXKkcbaxMvnHYrF7g9r5CkLVprh3VMXX0wlPfEs
   Hll5SR9eXZ09qjEfYufRCZ3KUf5cNop2Uu3wu6Clt5yo3q5ov3156KDef
   V3DFg6nNydZyVuVIoyhqUWhb76k3cR+kmd35dw8cTfFA++XUx/4Zei3wj
   tnSzc5jeCfFaBKdHBqqJlSSVq3moNVIYiWclN5/HgXsOIrtPOWb6H9lEV
   4dAWKwTX38LcRH2ZUMDgokOOXZQT/5Qvj8Yhvlota2NpNGUgyR2z86Spq
   sYTfcA09eXCGG0CwlBgLPryDzO9tQaefqHOYcHFrY2sKroqtvQr4Yo/E8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="269050872"
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="269050872"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 17:26:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="661390183"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 01 Aug 2022 17:26:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 17:26:07 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 17:26:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 1 Aug 2022 17:26:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 1 Aug 2022 17:26:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xm6oaEcAoTpQNKdlFPErrnjRLAwfNhF+f1XRUwH7aHs+HaZq1LCieVRLaINBJ8ypwa32pboHV2CPSiaD7JuPQcrCehS77ATwdH8fr7cvPTr7DaKcA5bCU3R+6gRcmHKeaUVxoPc03pEuhJUu7Hkm273kZYUjlE4b1X8ObOvK9iu8wEc3dggwzb/IglnTGtllDfY2HnJmwu8yDS5mLpmnkTeD5unN1GynSPnjUhlBBS47vBjTVTqMbV7vo1cw0H5+LWpoJ3otHYWdQzNn13NJXrE/2Tl8W3lS+RADCxAB3QzJ2fPWU/RjJAxK+Nu1ZPa7SyxevqImAhkBYZnAuvSiuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JS5WPUE/RGovSLRsX144ee+g16PQGaMiTTqQ0JfXfsY=;
 b=lnj/cLc03WtC2R71GQr6xQHugfsBGwKivCf7F6BT/2HSylfDLu7sLAim+vYQR8uqtzsv4ypxPgJnkeAmG33Nv3kGajVAbPX5mGDjSy3cTPp6Fo6K5VR1jLdmFsKyDh/ZKIe2Ptl73nFdKg9Pwot2plzSq3wHFC06hLNg2LNKfXMRPiicXe16SoEc1qZPIKdLmAiPYh3al7BcoAT77zV3xOMYEueuX1gSA8ZcVm0cKm/sDn2PzAtejGyJmRFPTzoQ3sHEmh7Oxk1HnwKvXkDBaOvRCj9PfGRqTNItFdNxOcbeBDCW+bntasvVquzfg1t831tpJJPORUyKOHjcV4OvVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN6PR11MB4097.namprd11.prod.outlook.com (2603:10b6:405:7e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Tue, 2 Aug
 2022 00:26:05 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 00:26:05 +0000
Message-ID: <0048e66d-6115-4b71-0804-3a0180105431@intel.com>
Date:   Mon, 1 Aug 2022 17:26:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: Fwd: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Ilya Evenbach <ievenbach@aurora.tech>,
        Alison Chaiken <achaiken@aurora.tech>,
        Steve Payne <spayne@aurora.tech>, <jesse.brandeburg@intel.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>
References: <20220801133750.7312-1-achaiken@aurora.tech>
 <CO1PR11MB508966EB7A3CF01A58553536D69A9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAFzL-7tX845o2kJmE4o8EhbeD-=vkR6rmaiz_ZEWfSD4W+iWEA@mail.gmail.com>
 <CAJmffrqxwFyRGpMRYRYLPi3yrLQgzqnW5UKgbgACGNqoN_hsVQ@mail.gmail.com>
 <CAJmffrr=J_s9cFw5Q58rvZRWLpsrDnx3RkRXS3oLZDYY3BrNcw@mail.gmail.com>
 <bd24eeb0-318c-71a4-527f-02832b74250c@intel.com>
In-Reply-To: <bd24eeb0-318c-71a4-527f-02832b74250c@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0205.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e3b73db-9efe-49aa-cc9e-08da741d966a
X-MS-TrafficTypeDiagnostic: BN6PR11MB4097:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xytf78SuQPvaZAtU5u5vVCxMZlIpUd9u6Kn7wOqn+FCzrJdcfsUIMGiBzImo14cmJhTNPwry211cewJ+XMYPWPHjeRXhoj5FPmlmfk01qVZv3MfpXLpkMLx9a9zYvdmoaYmb2YJkBNbM96SF2va+L08twk/NojFfdO9eBz55DenoxABL2EjviEfw0EKYzk5MB0jGnZvP6UZfs61UCYcfVJ1lUYnR+4YVm1WK1RMSqx21UP9AOh+KWlSr6wgZ8v/FxhUcNSeUqPm3+0VHk5Fx4iwVifPlewdBE7x2saKJStqgmQFg4AC4yE0OfA9Pp+UdxAqkzrFUxQ+VbigfViG0928MhE6ApOKY3FQsJ4bcMBmKpGUWQ0kZAKk6AaV9seQ1hU8O2Lg6GJh8zBbziaYQu2mX7MK2Ck/NfE0+90dWC3dDe2t7NmxEhLB+EhkP1Km4avi2F3irJ2HzPHzNNONrXj67tr1dFX8awJVtK6n2zW1/WNp4QUNsHBCTxYdNiu3VCkW28jkg/4+pBlAmZYxnEfHsDpTSPGcdDeANTbn1Yr5fwbSukcgVvOTqhrEruEm1QgveQNebyAI6o83hsI8UByQ447E74ln7V/A4ppNi64cAd0JmXTQeBHkZPonAFUmBuVs6wXFRKIz2KE115Q1rbc7TUHLyotv6jRzAw53je7JSeEXufo30vAX4UrdVxx/SdYiHN2a35fGa9jlsXYo6wC+0ouzwGz8jDgx4wKDlf3L1qYsvpG7NlevScg7KGOppZ/aYoqCGF6ezgAQGy17lOFDNgl0D9gl1xphiVDRHuE1nDWJBnYLu4EyqrBVgkc6zSl3X23PthUTTCC3ucs53yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(346002)(376002)(366004)(83380400001)(6512007)(26005)(6506007)(53546011)(186003)(2616005)(82960400001)(38100700002)(8936002)(5660300002)(8676002)(2906002)(6486002)(6666004)(41300700001)(478600001)(66556008)(66476007)(110136005)(316002)(86362001)(36756003)(66946007)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2taMjFlOUM3Y0RiWHFJQThCZXRINzVqRDhKUEZtTDV6bzlqSVpxUUVxQmVy?=
 =?utf-8?B?RVBDa3lleDYzYlFqTllJVE8wUDJxQUVGcWo0bnNoeFU4eXJFcnVwb1hWTUlM?=
 =?utf-8?B?cmFYOVdCdkx3bDQrVExXeDh2Q05kd2tOV3ArRnlFWTRtVnNaMmk4ZktaMGx1?=
 =?utf-8?B?OERwYVl3YXA5SVpzaUZOVG1VWjN3Vm1ZaTBvbVovRjVpZStCdyt1am9jRDM4?=
 =?utf-8?B?b043MVZqZHhBN3NUWTQ0eUFJZ2RjRkk3dFE0ejV6SW9YSkNiRStCQnJ6WnVm?=
 =?utf-8?B?TkI1bVB0dXRDWTN6YkdJamRXUVZ0dHlkSnVBMzI5aHZUcTJqUFh2SEhLQXVF?=
 =?utf-8?B?ejJ5akRoK3AyVXB5TVpMMUEwZ0hqNlhiQkVHWHBkZnFWSFZhc3Zxc1Bzc1Jh?=
 =?utf-8?B?TGVUQ0Nhc0x0SG53WGN4cHp4elEyL0l3emE5c1ArOVk3eWZGbm1aYXBpZFgx?=
 =?utf-8?B?K2FnNUswSkFSWVZGTGgvTkZTT3JMdGZObFpuckVGY2NWeDFQQlY5eHNINC9l?=
 =?utf-8?B?eWJTckgrbEFzb1ozK2lGZmhaeUdkRkIxV0ptZEZJRlhpS3VnN20wcThUY2lO?=
 =?utf-8?B?bm9wR2p1dWdEMEx3eFl3S2NpNW9vSDRzTkN3b3BRaE9qOXNUMXJFeVFwYmtp?=
 =?utf-8?B?aCsyZWtsaEFHMEIvbU1nM2NnN0xLVmdKNDBtZnY4dEUvSWgvQjZzb3B2UnVx?=
 =?utf-8?B?aTlCOTdyZlhIVks4NHMvN1A5cjR6MUFMaVZJSzVsSkY4UUlRNVNSMGZpMUln?=
 =?utf-8?B?ZHFGcVgwT0ovejVLbUkyZlhGYSt2TU1IbUtBamNNbTZZZFdYNFFWNVAvQkxm?=
 =?utf-8?B?aWFxbmtBNnlhNTlEem5RalQ5Zk5OWmNiTnJtOFAzYWFDOEZDbW9DUC9LMTdU?=
 =?utf-8?B?UE91anFrejN1Qm9RNG82R0VvK3VBZHMvNGpmNXMxQnE0SU5EWjh1dUtWeWhj?=
 =?utf-8?B?MzFWUFMrY1Rad0NoZ2JqQ3pJWHJ3SC9PY1U0WmI4K1dGVW1mSHM5SU1heGhs?=
 =?utf-8?B?WVlaSDlwcXRreXMreURtZzltMzZHYk9ZdmxKLzI0eVRMSVBzS242b2tWekhh?=
 =?utf-8?B?SEJ3NWUvS2hnNkJKRkxyZStiV2ZlNzF0cHZScjIveGlWb1Q5WFB0QktvenB3?=
 =?utf-8?B?bmYxT3pvNlNrZjJoam9PTGl5TjUzNFZmQ1BFbDBxOExHTGdpWGRaVnlydUVR?=
 =?utf-8?B?N3B6STJCZldtbmk2MEdKamhJc0dDSzJuRTFuaU14a3J6Und2dDhkNzBGUExL?=
 =?utf-8?B?U0cwQlBqOVkvSXRBL1JLczRKNkRtR1lyZW1GWGZ4eDhsNjB0Nyt4MGFEZlVo?=
 =?utf-8?B?V094Kzh4eVhKdHhuanRkVXNCSVNKc09DTXBIaFhFaEUzZnJhVkt5R1cwM1Vp?=
 =?utf-8?B?Z3NoTURUdVNRd3kxekE3SFVGQzgyWnpXUTNaL2RQd1BHM1pPc05ocmFBa1Z2?=
 =?utf-8?B?L2RMZ3RDbVdOdE1oVTk3amRWdzRWd3dOT1czYWMvSkFCVEZ4YndpMG1TM2o5?=
 =?utf-8?B?MjJVMVRGRk1kdEI5TDlrMTlzNW9oaUVIVmJpbFBqaFN4L05mNndnUmswb0Vw?=
 =?utf-8?B?WFhyN0p6a1d2TnJDTGF3aEdnRjAzcUpTMThzNXpWbGQ4eC9xTWJFOEh2bHNn?=
 =?utf-8?B?NTM4aE55UHVEVzdJOTZQWHQ1em9YYjQvc2ZpYkdGWktDbCtRNldUeHd0WkdB?=
 =?utf-8?B?Z0FkRTJsRmhhbmlaRDBZTzJQRDc2QkVGQi9XUWhtWCtzdElTQXVFWVJ4ZkJo?=
 =?utf-8?B?blZ3U0F4VkFRWEVpNTg2TFhMdGVMbGlRd3FWSEovWFRKRDBZYjlMcXk3am8z?=
 =?utf-8?B?aXpMRFB6cXQrc0gxSzlOMmxBcUFsSGRZaHExQVRMcDh2WTl6a2JDc0F3OWs1?=
 =?utf-8?B?MTZ5K0xkWkZObHA5cGtZQUFJdG0wZ1E2bk55NUhPNDZEcjl2ampqMFpjNzFn?=
 =?utf-8?B?ZUNYMEIwMVdHSFVBdFdyL2pUS3NQTmRmNzVTVkp2czA2VWtrSXN3UTFGUnBV?=
 =?utf-8?B?RWFaWk0yb28zZjhoY1dEMkkxWW5mMFJlbThvdDhVekl6ZmxlYmNRRHh6YWtR?=
 =?utf-8?B?MlhjVmM0WGs3SDhxdXRkbXdjVmhZM3dFcVFvcE5YSnk4dDVwb0VOek5tVDhF?=
 =?utf-8?B?VW9ZUlltZTcyL2hsdldsV0F0bTl3WFZVNXVyS1oxZVk3R0ZiYVd6YlV2b3dC?=
 =?utf-8?B?NXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3b73db-9efe-49aa-cc9e-08da741d966a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 00:26:05.4206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcIkDPc0MNU5HA9ReMHLdFhSUxP3y5/SMNMUt0/xP7FoE6RWvhTKVVsxuBeZcuj4htNRAOvcn+j+JD7BIRP866eL7HVQFxo8duz+jZS8K7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4097
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/2022 4:29 PM, Jacob Keller wrote:
> 
> 
> On 8/1/2022 4:00 PM, Ilya Evenbach wrote:
>>>> -----Original Message-----
>>>> From: achaiken@aurora.tech <achaiken@aurora.tech>
>>>> Sent: Monday, August 01, 2022 6:38 AM
>>>> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>;
>>>> richardcochran@gmail.com
>>>> Cc: spayne@aurora.tech; achaiken@aurora.tech; alison@she-devel.com;
>>>> netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
>>>> Subject: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
>>>>
>>>> From: Steve Payne <spayne@aurora.tech>
>>>>
>>>> For an unknown reason, when `ixgbe_ptp_start_cyclecounter` is called
>>>> from `ixgbe_watchdog_link_is_down` the PHC on the NIC jumps backward
>>>> by a seemingly inconsistent amount, which causes discontinuities in
>>>> time synchronization. Explicitly reset the NIC's PHC to
>>>> `CLOCK_REALTIME` whenever the NIC goes up or down by calling
>>>> `ixgbe_ptp_reset` instead of the bare `ixgbe_ptp_start_cyclecounter`.
>>>>
>>>> Signed-off-by: Steve Payne <spayne@aurora.tech>
>>>> Signed-off-by: Alison Chaiken <achaiken@aurora.tech>
>>>>
>>>
>>> Resetting PTP could be a problem if the clock was not being synchronized with the kernel CLOCK_REALTIME,
>>
>> That is true, but most likely not really important, as the unmitigated
>> problem also introduces significant discontinuities in time.
>> Basically, this patch does not make things worse.
>>
> 
> Sure, but I am trying to see if I can understand *why* things get wonky.
> I suspect the issue is caused because of how we're resetting the
> cyclecounter.
> 
>>>
>>> and does result in some loss of timer precision either way due to the delays involved with setting the time.
>>
>>  That precision loss is negligible compared to jumps resulting from
>> link down/up, and should be corrected by normal PTP operation very
>> quickly.
>>
> 
> Only if CLOCK_REALTIME is actually being synchronized. Yes, that is
> generally true, but its not necessarily guaranteed.
> 
>>>
>>> Do you have an example of the clock jump? How much is it?
>>
>> 2021-02-12T09:24:37.741191+00:00 bench-12 phc2sys: [195230.451]
>> CLOCK_REALTIME phc offset        61 s2 freq  -36503 delay   2298
>> 2021-02-12T09:24:38.741315+00:00 bench-12 phc2sys: [195231.451]
>> CLOCK_REALTIME phc offset       169 s2 freq  -36377 delay   2294
>> 2021-02-12T09:24:39.741407+00:00 bench-12 phc2sys: [195232.451]
>> CLOCK_REALTIME phc offset 195213702387037 s2 freq +100000000 delay
>> 2301
>> 2021-02-12T09:24:40.741489+00:00 bench-12 phc2sys: [195233.452]
>> CLOCK_REALTIME phc offset 195213591220495 s2 freq +100000000 delay
>> 2081
>>
> 
> Thanks.
> 
> I think what's actually going on is a bug in the
> ixgbe_ptp_start_cyclecounter function where the system time registers
> are being reset.
> 
> What hardware are you operating on? Do you know if its an X550 board? It
> looks like this has been the case since a9763f3cb54c ("ixgbe: Update PTP
> to support X550EM_x devices").
> 
> The start_cyclecounter was never supposed to modify the current time
> registers, but resetting it to 0 as it does for X550 devices would give
> the exact behavior you're seeing.

I just posted an alternative fix which I believe resolves this issue.

Thanks,
Jake
