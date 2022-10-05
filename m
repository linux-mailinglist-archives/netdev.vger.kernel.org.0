Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6855F5524
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 15:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJENO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 09:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJENOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 09:14:54 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13071DFEE;
        Wed,  5 Oct 2022 06:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664975692; x=1696511692;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eF99shaiSys6aA6t7fEnrdMrZdMZXqQmhWlfL+qzuAQ=;
  b=KDkSCs89WVSnlsvhVBHYGJ7rOzyy20rzdNbGH+y9rL19PQRAgjpL8hcy
   qEdK9o2YhYWwUId+5Og8Px0VLSIBVJk6K2g1jqZXDXMeyVlSu47Arjpcs
   fEPQoGvt6odw1/BfFxC2ZYWPtdW9Wr5zRciPK0/dc4jpYZHpfqobKcr4J
   BsVgLfUinpFjV4AD9UOvRwA+t/3VPcQ3DmPhU4GCCGQ5yJ1PmEgvxTDoj
   YAnSSa0fjjy2L7ILJEgYWbMSlLwNe+l9Fqsn4PiuY8aXrGnejIvnwlHhe
   47XIhDeXvz3dvop6gVEpFAAu/8nj2dW8jiCCYGOy1m8n8yQZ8EBmjg6Gm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="367268861"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="367268861"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 06:14:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="766720434"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="766720434"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 05 Oct 2022 06:14:51 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 06:14:50 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 06:14:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 5 Oct 2022 06:14:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 5 Oct 2022 06:14:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIsqH7uQtdznfuMn34diJv6nRmud1u/5B0rcCV4wK8Jc813Yky08yaSyh/jTmvBAVyhIyapCvQCcU6SiwE4Y2Ku15RpErInhvR1dx55PpopDjbfHtRE4rr7/X6e2jkD3UN4G8Fe0bJGNFLtDsuIgrQysIKAKzCjWxicUGFSpGXZWZNa6uvFOG/t7aKPQ+FUaikbTrO2kCWDFx1HaB8HTigTLVUWarYXcOie0iHEAa8TTB4Yd6ndmxfiWB66R1itBLQIHYOcJYwUTnF/kiNjeDjj7vmFcQBgz7S9K5WC8jUVi7ZaaFvkUuGcGfzc76VahL50Vc2ZbdGuO1BX91gL7tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuSYtOnyjcbEziIY/slmtKuwjGKdjDndhKApv2diWD0=;
 b=FOCpN4S3a1bA4ZO4G6CYMkdXzIGPcC0295PWsdDRZNZLBFKz293oM2CFqmXRmsiVseO4NcEjD6ycO/PwYEekyrzOLA1sJ/SWcfz8Rpf6prCJSiUKDJhcM1HVxZRGDV3c1UqNmB3bA80b6+WkvCt+6ejnO6itYNV0tPXPRBFf/HGR58TZ9Mv6ENGYakG5yewf7f2gPvlxcydgQl8WS5z/2Io9gXEy95BtiNL9gXJcJGH03S4xVaftHZ6mLyav2sqGZEy6/nWzPfMWpAt56ZrlGujkw7TYctwfDH3GsZaKp0lA+extMZ5Ke7niwt01+7MI534YPqrPrHhPWvyyaoHZgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR11MB1251.namprd11.prod.outlook.com (2603:10b6:404:48::10)
 by PH0PR11MB5628.namprd11.prod.outlook.com (2603:10b6:510:d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 5 Oct
 2022 13:14:41 +0000
Received: from BN6PR11MB1251.namprd11.prod.outlook.com
 ([fe80::fdae:254d:47c8:69b6]) by BN6PR11MB1251.namprd11.prod.outlook.com
 ([fe80::fdae:254d:47c8:69b6%4]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 13:14:41 +0000
Message-ID: <915e8a6f-c540-a44c-035f-331467fa53c9@intel.com>
Date:   Wed, 5 Oct 2022 14:14:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>, <sdf@google.com>
CC:     <brouer@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <xdp-hints@xdp-project.net>,
        <larysa.zaremba@intel.com>, <memxor@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, <mtahhan@redhat.com>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        <dave@dtucker.co.uk>, Magnus Karlsson <magnus.karlsson@intel.com>,
        <bjorn@kernel.org>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
From:   "Burakov, Anatoly" <anatoly.burakov@intel.com>
In-Reply-To: <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU2PR04CA0282.eurprd04.prod.outlook.com
 (2603:10a6:10:28c::17) To BN6PR11MB1251.namprd11.prod.outlook.com
 (2603:10b6:404:48::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR11MB1251:EE_|PH0PR11MB5628:EE_
X-MS-Office365-Filtering-Correlation-Id: 9091680f-8d0d-4038-b5c3-08daa6d3900d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPqlMEQjICwSs7O9iI76khD0pDgO2uT0QyjV10feBNGZddSfbX/8fStls4B9rrtn5PF5dc2dPwiBAgm5yQz33PgZ9vN5izOPLUaNHKMk1flN6BwkxOoezLvdgEKRsDt5Y80HaX5jC0X6FHFd8TBYS+W+bTp5RGFkNWo8YvC/af8L6ZBEBh4DnLfyeEvbQ4tcHtUvyF6dY7x+fYinM8Vn1jMTMo5t+MTGHW0RavFqoeS+xZ7FXs0rudhU0ngc/889k6LZSTmaC7JIb2aCXJSXOg4z0m36iNiyTrisVV3wkVjmXwPtFxtsJBgemdJPb7NKxzZ0Wo3HEhfsc5zpW65UkxmzGnUmtVgTfDLTjYaDrMP/aPBGdNmW14Z9TDIosHcycAVGHhsaBcl+PLeFiJJPdlNS9wq0XHI6ox2+Sg0vdnlLg4W+VJGybOU/VtVMIwgvnFsw2I+ai0+XK3aip7eQJtH9g7XCuW1mP1sLrZZfm5J8FaxpOzuz2/6Kq8ipWlkJDlh7cMnywb/3raVcClFVq4HzEGCrUcnvTZoj1Qs8tMSSnom1eI65qbobwepebzaC8B/V6PyPZv05e5xHyr5HM0GuWrP3vtNPWmBTFa/awZNp4yG/FmUhGXDL5CT1yye2oMgdeyqNgv633Wn3IVO2Ed0kLfgpB3P2oLcjrqMvHqAQEll3eMbGG0elrzWj2dofcGAWIikZ17OaU8GhpiPmRLZEkj5VNlqSmNcUyKD7GaG5UpW2db5vO9szc4+tn8R4BDS5QbJXF+vhQzJ8EmP5hiDplrpHCdsUWYtXya2/Mb2Rf4pDww/LgfC+8rVXH7mB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1251.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(136003)(39860400002)(376002)(451199015)(2616005)(83380400001)(38100700002)(186003)(82960400001)(5660300002)(31696002)(2906002)(7416002)(8936002)(41300700001)(54906003)(53546011)(6486002)(478600001)(26005)(6666004)(6512007)(6506007)(8676002)(316002)(66476007)(66556008)(66946007)(86362001)(4326008)(31686004)(36756003)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWlNMW5BamtLUUMraytVcmQxMkZDSkdXUnhOZDgvRS9WWDBmYW5PakJSUkV1?=
 =?utf-8?B?bUxjVHVqcXFLQ0NuQUs4V21sRC9NQWUzS0JGZXVvYU8wQzROVWxQa1BXSmc3?=
 =?utf-8?B?aWNNcTl6Z0taZkwyM3JCVTRhbGpYVkltRlZ1NkRWK0N6aEFDNG13ekxqVkZz?=
 =?utf-8?B?MkFDS01jUlRYOW5Ib0trcjJ0bEpQV2R3aDE1ZTN5cnlIaW1zT0VOWlcrS3Zh?=
 =?utf-8?B?a2JXN2NDMkpYY3NiZGR5TlBKc0d0RzJJV1BETWRRSFp3ODNmd050d0s4QmVW?=
 =?utf-8?B?Um1Oc1plUzB3bXBHeUhvT09JV2IwdkZkY3Ftbzlaa0pwa0xJZWdBUjF2eDVP?=
 =?utf-8?B?OGZNK1F2aSttbmowdm5XNm5nOVdseWhMNzBFQVFSMlVudTNRMEdjZzVQQUNB?=
 =?utf-8?B?bmMrRktneFdDemphK3N5eXFQamM0NXdLcmN5ZjdqeU1TLytEcVRtZ3YxYnRK?=
 =?utf-8?B?ZzZZRnBuenI0ZkxaV1lOaTgwRWMxMmRoTUIrU2lOMnNkYjRUOVhEZDlnYU9x?=
 =?utf-8?B?cFB5UUVsSDdKdjZQODVscWlSZkxUR3lyMWwvcnJWakk1bmxLTEJ5NmZqempm?=
 =?utf-8?B?ZWhXOWptZmVuaEY3eTlQSGdZT24wQUFnaGJTd09yaVZuRFlLekVlaGJRVWFx?=
 =?utf-8?B?Yk8rdnI2ZEdmaTJtYkpTVXREdzZsdEhvaHIyUVVydnVYaFNMQUtvQlRZVWFr?=
 =?utf-8?B?WTc2TlNyRkJ2M0ZlMEFjeXdLTTcyYU5LTkJBQkNCQ2FsU2VPNDdsRnduOE93?=
 =?utf-8?B?WXdBa2x0MFh2b3JLeVdod0FLKzY3R3g3akdxU0cyQmhpeEVocm5LUjhIWEhU?=
 =?utf-8?B?bm8yUnJWYlBNdUsyeFpmZDArR0pyZWpaa0RiN28wUGIvUllVTk5IZE12MnBP?=
 =?utf-8?B?Yjh3VG9FSEp1NGY0MDBodXJjTmJNcmFMWW1yRjUwVmlRZ0tHYzdoYjVrUU9r?=
 =?utf-8?B?bVp1bzIrazRhd0xkNmVmR3VrQzN3TjNJU2tzKzRxNksyRWxnNEw3RW1sNDZy?=
 =?utf-8?B?eU1FRm5jNGJubExnQjZadEVuSmJIMVp6R0JUUVVFY2xxRG5rR3FvckxkS2tn?=
 =?utf-8?B?cnQyUWovbTB6dlloZTBodHRsTTFMeVY0SzJ3TXFlL25pVmpWUzcyYjB4Nzg0?=
 =?utf-8?B?dlZkcTJHUUhCczdUb3RPZFI4bG8ranY5emFuTTYzUlFLL2lkTGhVOWdKRHEx?=
 =?utf-8?B?TTM4ZzI4NUxGcm9IUVV3OWFzQ3hTWnJwVUJCTTFzNCt6bEs2WEVBMDYxOVdW?=
 =?utf-8?B?VE1PMmM0TWpoSWRHbGQrZUYvSDl3dThLb0hDSEh3aHVOa0FzcFgwOVJJUUoy?=
 =?utf-8?B?d0F0TGp1a0l1OStPOTBOSHFQM2xBbGNLR245YlY5RVJBTmE1ZHZCdjlnbW8r?=
 =?utf-8?B?NkNLWTFycFROTTVsTUFNY3BWY0ZOOU92bTFtaFFiYUw0TFRVYVQySmkySUVX?=
 =?utf-8?B?c2NqVGFEZ1ZXT2p2eksyV0kydklrS1VnMDNmSmxOUGYydWhkQWtYbjIvR3N2?=
 =?utf-8?B?SXVETjF4S1hhdEJMcStudkFFaThIMk00Vit4YW9HRlhlcFdHdGwzQk5wNFV1?=
 =?utf-8?B?SHM5dVM1SGxpUU9XNStUUkQvZTNoOTl6blBMdWphaXZ1eFRLWEo0VkM2ZGpy?=
 =?utf-8?B?NWw3YURuWUY2QkZBSUxldEJ4c2NtdEFwckx3SWlaR2pxQXE0V3BQYTNBOTN3?=
 =?utf-8?B?ZW5UUXBRMTRONXhLVzdoQTVOLzR4OEd6aFBMdko1NW5IYlJBTVBmbGN6TzFF?=
 =?utf-8?B?b05JNFhzaFdMai9qMHFxL1dpSDFGNFFGV2ZoTVVMVlcvTTJ3M29yeGkrbHpB?=
 =?utf-8?B?TVhMSDZyTm5FVE1YdGJCNkwzeGF3cVNnaWxpMThVdG5hWm5aMEpaWS9Fc3Y3?=
 =?utf-8?B?ckJkMENyU1ViNkY5TVZNSXFpMGxIMjVselZBL0RmOFVJMUx3MXp6TXlWaUZ3?=
 =?utf-8?B?ZThTU1VzV2RDNndtOExMMlQ2U05PTkZIVHBIditwUExSV3d1UXp6ZHZsdmg5?=
 =?utf-8?B?RkhMOE82ZytXWGFpek5IcTVabFVFNVpRWjZ1bVl5WGZLMEZMMkMrWlhZdTBP?=
 =?utf-8?B?bVplK01OSWNoU2tOU2tHWFJBVTJqNEkzUUo5VTJHSHBWaGRTc1puaXBaRmR2?=
 =?utf-8?B?NS9VQko5cTZMcUlTS043cU9LbGVETGowVmZVN2RHS3pBRWJCT3FvM04zQTg1?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9091680f-8d0d-4038-b5c3-08daa6d3900d
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1251.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 13:14:41.4852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2MyyVmPXTYPB7tenXqc7eCRAvj8skHnwftVYkTX4LSyfGRsQ/OZDD93U0sFaZG0wxB8SD0BDcnNenGI24EaYE6LUNdAWYskbeQ9CA/rMZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5628
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04-Oct-22 10:29 AM, Jesper Dangaard Brouer wrote:
> 
> On 04/10/2022 01.55, sdf@google.com wrote:
>> On 09/07, Jesper Dangaard Brouer wrote:
>>> This patchset expose the traditional hardware offload hints to XDP and
>>> rely on BTF to expose the layout to users.
>>
>>> Main idea is that the kernel and NIC drivers simply defines the struct
>>> layouts they choose to use for XDP-hints. These XDP-hints structs gets
>>> naturally and automatically described via BTF and implicitly exported to
>>> users. NIC drivers populate and records their own BTF ID as the last
>>> member in XDP metadata area (making it easily accessible by AF_XDP
>>> userspace at a known negative offset from packet data start).
>>
>>> Naming conventions for the structs (xdp_hints_*) is used such that
>>> userspace can find and decode the BTF layout and match against the
>>> provided BTF IDs. Thus, no new UAPI interfaces are needed for exporting
>>> what XDP-hints a driver supports.
>>
>>> The patch "i40e: Add xdp_hints_union" introduce the idea of creating a
>>> union named "xdp_hints_union" in every driver, which contains all
>>> xdp_hints_* struct this driver can support. This makes it easier/quicker
>>> to find and parse the relevant BTF types.  (Seeking input before fixing
>>> up all drivers in patchset).
>>
>>
>>> The main different from RFC-v1:
>>>   - Drop idea of BTF "origin" (vmlinux, module or local)
>>>   - Instead to use full 64-bit BTF ID that combine object+type ID
>>
>>> I've taken some of Alexandr/Larysa's libbpf patches and integrated
>>> those.
>>
>>> Patchset exceeds netdev usually max 15 patches rule. My excuse is three
>>> NIC drivers (i40e, ixgbe and mvneta) gets XDP-hints support and which
>>> required some refactoring to remove the SKB dependencies.
>>
>> Hey Jesper,
>>
>> I took a quick look at the series. 
> Appreciate that! :-)
> 
>> Do we really need the enum with the flags?
> 
> The primary reason for using enum is that these gets exposed as BTF.
> The proposal is that userspace/BTF need to obtain the flags via BTF,
> such that they don't become UAPI, but something we can change later.
> 
>> We might eventually hit that "first 16 bits are reserved" issue?
>>
>> Instead of exposing enum with the flags, why not solve it as follows:
>> a. We define UAPI struct xdp_rx_hints with _all_ possible hints
> 
> How can we know _all_ possible hints from the beginning(?).
> 
> UAPI + central struct dictating all possible hints, will limit innovation.
> 
>> b. Each device defines much denser <device>_xdp_rx_hints struct with the
>>     metadata that it supports
> 
> Thus, the NIC device is limited to what is defined in UAPI struct
> xdp_rx_hints.  Again this limits innovation.
> 
>> c. The subset of fields in <device>_xdp_rx_hints should match the ones 
>> from
>>     xdp_rx_hints (we essentially standardize on the field names/sizes)
>> d. We expose <device>_xdp_rx_hints btf id via netlink for each device
> 
> For this proposed design you would still need more than one BTF ID or
> <device>_xdp_rx_hints struct's, because not all packets contains all
> hints. The most common case is HW timestamping, which some HW only
> supports for PTP frames.
> 
> Plus, I don't see a need to expose anything via netlink, as we can just
> use the existing BTF information from the module.  Thus, avoiding to
> creating more UAPI.
> 
>> e. libbpf will query and do offset relocations for
>>     xdp_rx_hints -> <device>_xdp_rx_hints at load time
>>
>> Would that work? Then it seems like we can replace bitfields with the 
> 
> I used to be a fan of bitfields, until I discovered that they are bad
> for performance, because compilers cannot optimize these.
> 
>> following:
>>
>>    if (bpf_core_field_exists(struct xdp_rx_hints, vlan_tci)) {
>>      /* use that hint */
> 
> Fairly often a VLAN will not be set in packets, so we still have to read
> and check a bitfield/flag if the VLAN value is valid. (Guess it is
> implicit in above code).
> 
>>    }
>>
>> All we need here is for libbpf to, again, do xdp_rx_hints ->
>> <device>_xdp_rx_hints translation before it evaluates 
>> bpf_core_field_exists()?
>>
>> Thoughts? Any downsides? Am I missing something?
>>
> 
> Well, the downside is primarily that this design limits innovation.
> 
> Each time a NIC driver want to introduce a new hardware hint, they have
> to update the central UAPI xdp_rx_hints struct first.
> 
> The design in the patchset is to open for innovation.  Driver can extend
> their own xdp_hints_<driver>_xxx struct(s).  They still have to land
> their patches upstream, but avoid mangling a central UAPI struct. As
> upstream we review driver changes and should focus on sane struct member
> naming(+size) especially if this "sounds" like a hint/feature that more
> driver are likely to support.  With help from BTF relocations, a new
> driver can support same hint/feature if naming(+size) match (without
> necessary the same offset in the struct).
> 
>> Also, about the TX side: I feel like the same can be applied there,
>> the program works with xdp_tx_hints and libbpf will rewrite to
>> <device>_xdp_tx_hints. xdp_tx_hints might have fields like 
>> "has_tx_vlan:1";
>> those, presumably, can be relocatable by libbpf as well?
>>
> 
> Good to think ahead for TX-side, even-though I think we should focus on
> landing RX-side first.
> 
> I notice your naming xdp_rx_hints vs. xdp_tx_hints.  I have named the
> common struct xdp_hints_common, without a RX/TX direction indication.
> Maybe this is wrong of me, but my thinking was that most of the common
> hints can be directly used as TX-side hints.  I'm hoping TX-side
> xdp-hints will need to do little-to-non adjustment, before using the
> hints as TX "instruction".  I'm hoping that XDP-redirect will just work
> and xmit driver can use XDP-hints area.
> 
> Please correct me if I'm wrong.
> The checksum fields hopefully translates to similar TX offload "actions".
> The VLAN offload hint should translate directly to TX-side.

Like I indicated in another response, not necessarily. Rx checksum 
typically indicates that the checksumming was completed and checksum was 
good/bad, but for Tx we actually supply offsets (possibly multiple ones, 
depending on L2/L3/L4 packet, plus there's also a need to distinguish 
between packet types as different NICs will have different offload bits 
for different ptypes) in the metadata. So, while VLAN offload may or may 
not translate directly to the Tx side of things, checksumming probably 
won't.

> 
> I can easily be convinced we should name it xdp_hints_rx_common from the
> start, but then I will propose that xdp_hints_tx_common have the
> checksum and VLAN fields+flags at same locations, such that we don't
> take any performance hint for moving them to "TX-side" hints, making
> XDP-redirect just work.
> 
> --Jesper
> 

-- 
Thanks,
Anatoly

