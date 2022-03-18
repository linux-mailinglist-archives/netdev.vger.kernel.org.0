Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F924DE258
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbiCRUYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237965AbiCRUYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:24:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CE514145C;
        Fri, 18 Mar 2022 13:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647635008; x=1679171008;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rowzScbnxd4nQIpuCqqPnBnCfTVIUzpkbknOxnhgkC8=;
  b=ETZIXDLHn6h9++lcW2LVsqGQD5UDWHMYTiPEAW7tObO/Z8AfyZEUYBCb
   xZ+KUNu7/trYxQ1Zgv9uf/JjDkEclEzcyFucQVgiX4F4lmp5pcqABs6+G
   m6ZXPtEaToU9JPTUKQ0Pcw8r6PSziDBPssCVZbYG7bjkhxieOShT31DXy
   3WcOYr9Fap2fPntVurA0hgJmpzJnRTOv6am1jgW5EC6IhYPXQ74COKcG2
   YSfvV+HqWiaHz47TIv5VrA4zFgxEHzCp2Vx6YvPvnC6DBPFsVWm1AC5HQ
   HSLaui2Na8t5S4l4mfgKs/yKXe8Cm6DceC10qiO7Si0EucPaZI40B+Z//
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="256942659"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="256942659"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 13:23:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="550881137"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 18 Mar 2022 13:23:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 13:23:27 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 13:23:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Fri, 18 Mar 2022 13:23:26 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 18 Mar 2022 13:23:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oi/v9gOXMJG6Tfvz3yD+LDZZk6he0Ss2sW4R+DdOj1t7aC4QKo8uSXZbpF0UvgVWeZbNh3vjKT/JY6HJpt+TOmBUEp7dODa7tvyy3AOFqH373KtOMtDoQn/e75B2q78ajLV6C2Ff/qUjZx6EQK3fLU0YYW31V2QiCpQYAkOukq6chf492b+dKL+63hdTsKFyvWYwk3WbKuzbfGJ2DMvXUF0PCSdB7z6s/h60ndCIIKWG2FcOyg2IRw3Yo5pPnmhLGubDR2kACJlCAX06hflRW8gXrkc9w1yBLBKkDrG7NapBfZzWvsF54yEc67J6sCf4lHTeYHL4DYliEgZ2rUzDSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTpgfMu55Emk9i96ffup0Dt3tpsPnxmZB8oBI+CMXDM=;
 b=crWxOx48aGYfo25NY1r5K6Jgx62MsAz4xsoBmOE7VlHC8mtCK5YVVOY30ivW3hjqq5CWdE8mIbJrkOpHy3DvZVwVVkGvd0aqA1dphYl7jDLCnui6nIS0rLfFiUl9hMH69lMs7P1dnmrd6b4Eevl7tXmEg3MmREdyNpBJpOlQyH5Gfs0j8VHUVCzycnKOEkcY0OFBoyFXfZ7RhvDZAshb0WxNskoA772E2lDH/EAALbv0k1FxrSD2MSD3PNVrMPWV66yC0E3Wlgc0p95JfMeY7st47DqbfAstrizKmmhme16LKDfR8Nk+LRVz+9g/eoeLP+QPXSq5Rua71//rNtAz4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MWHPR11MB1278.namprd11.prod.outlook.com (2603:10b6:300:1d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 20:23:25 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 20:23:25 +0000
Message-ID: <6fab3fee-5177-4bc6-c8c1-355d5803441a@intel.com>
Date:   Fri, 18 Mar 2022 13:23:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [Intel-wired-lan] [PATCH v3 net-next 3/5] ice: switch: use a
 struct to pass packet template params
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220318161713.680436-1-alexandr.lobakin@intel.com>
 <20220318161713.680436-4-alexandr.lobakin@intel.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220318161713.680436-4-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::11) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 255e0687-9dc0-4f95-83d8-08da091d27a7
X-MS-TrafficTypeDiagnostic: MWHPR11MB1278:EE_
X-Microsoft-Antispam-PRVS: <MWHPR11MB12781848346B427D9ED8D988C6139@MWHPR11MB1278.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ESUkzYlZxbwoh6FyjEpXq/X+4IE6q6KWA8l7bEZ5DKlipsGeYTfeap8LMtHo4/TvOVo+W3n+SjCON2mhphMVlcqqszW/+TXFPoapk7+HYF1/gGoCeC3n+lj9yYGXb1CLtww+ditsOPzstWAwX3s05EKzKah8z3HnMK+y+zk8o8E/1kTJN2IfL0Qx5VJnj8jHSlh4GS3WGlXJPgcmko1K0vNrTQyfi4ZiP9G/TIIkobAMzNAzDqGHyR+tAvgig/vhVCtwqcvsKaPFPKKTWLvv89E9RCFY3peaU3Ynz1ZXSXLSLoe1vFc244ejXnbTQFXkMH6f7xlBnntlGXn+OTs3pCFCZDVmeYT4Epj77Xtb4Kxy5Of34ac2tqOA7JoWPLA6Y+226q8TDZJvZsClPPWByqdEAa58ETgrsoB1M4yNlQ1dTdy0UICNar8BBzR0aF8CqS1fSDvh0ocT5j44X5oAIbqmQR2BAmx4AXBkEAjH6pf4EuC+YdGphD86BIqirL5z+YftQveXA7QGDPhpUQkKnkxnYrXsMd9M0lqJRF7g2vTyKnjnOkWRRSmdSsH2Prl4MVMIhAhJRLQR8mkAnFoX0Wz+TTmekCOgnjzXFFM3L+w1Nlyf2YmiK9THyJE8PwYGEDqk/b9qGuVTD4fwEvdGAh8Qart8rddP6Fy50gMS2fPea5PViwgj6/mbsqKLwznG4DEA4vbMfjQp/kn2aVhQuhqG2wCiqwfvO7n+5uvCuR5jS3gh0dGPqBsA3kUqrJ7VqgbxhFzYClhsx66KhQFEqqKBRZd6MSN8MZIyFskgbAbtUPvuLZdsO9WwJwL6r1iW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6512007)(26005)(6486002)(966005)(186003)(53546011)(83380400001)(38100700002)(2906002)(31686004)(6666004)(82960400001)(4326008)(5660300002)(8676002)(2616005)(508600001)(66556008)(66476007)(66946007)(6506007)(31696002)(8936002)(86362001)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXhPYnNmenRLek1LeUdZMU1OWHNNeFFVOGxHTTQvQzNOdHdvL1gyRVZUWUVN?=
 =?utf-8?B?NXZkS1RiajdMMzEvekhXS2xVV3RLUk1rTEdsODZxbmNoM2lrTXN6dnNHTjln?=
 =?utf-8?B?TTlKeDVhdVVIcFpaZURSRXlxTVl1TkVraUpmTmhERGpJM3BUNitRRDhZcmpI?=
 =?utf-8?B?RDZMVTd5bmdsclk4b1ROS2ZxYkRGTGxNMVdTbTEvZ0crK3NtdUx0OEwxZmtr?=
 =?utf-8?B?ZEcyQ3NlaWUxOW14VTRMdExNb0hYWlJYZFM4NEFIYmdVdWY3dUdIeE4va2kx?=
 =?utf-8?B?dlduSU1IMC80RkZVOFJ1RFZlRGl3U01mKzdXQnpxbHBXeHhuTEFDM1dEZ1R0?=
 =?utf-8?B?aXBUaFc5ekpaUXJObXdET2E3UXZOd1IyTzZxN0d5citzc2Urdmh4QXovSThw?=
 =?utf-8?B?S2Z6bTNhNnFkTGN1VHJtZ1VUMmdzc1JkY3pPK1dBOTh1VkRscmlmdWNyVWJU?=
 =?utf-8?B?RFNEOVBiY1F1cnhmVDVPK3lBdSs1aDdlVlptREZPbDRqM0U0RHpMbHQ4bDBT?=
 =?utf-8?B?eHdDN05sOXAxdWJRMHpLQ01wZHhkdjYxQitDRnRFd2pLOWlUS2hlQlk5MGVr?=
 =?utf-8?B?K3pmRm1wQlBRZ09lNHc1Zlc2K3NhT0o1NVdKaTVwalg0dm9SNXhjRHBxeUZp?=
 =?utf-8?B?L24zZ3NqclN3d2JpWTBtUFZ3RTQybGtTTFFiNTlicHllSG9yUXg3SDVVamta?=
 =?utf-8?B?NzdMUElSYncrZWNxQ1NyQ01Iem5rRnlSai94VVh4TURJdjJoVllnN3NKcWM4?=
 =?utf-8?B?UE9hOWFwaHhsZmcyMWphQ256SGtGTXlNQy9taWZxYUViWThhZC9CbXZONU1l?=
 =?utf-8?B?OU9sSmYyUlh0aVZ0VVJqY0VCN2xFTFkzeGhDbFlxSUQrSUdrVzJuUkcxWjl4?=
 =?utf-8?B?RHpmdHA1QlJzZ1JUc2l3ZGwyS2F3aS9ZSVRqMU4xYndRQS9XZHV2bDJaNnlw?=
 =?utf-8?B?enZ2MkFlOFlRRFJ2S3ViZTNzY1Q1ekFpZnpROFBIdzJpckJQdFVhQ3BEWG1D?=
 =?utf-8?B?dlA1a0VaV2JUY2lnZVpwUkF0RVdEK1N2aThLdXdZWkRSeldaeUR6K1ZpUEEw?=
 =?utf-8?B?d2RRRUphL0pmVUJ0Njd3S05uWFlNdVVjV0tKSUR6NzhZMzZJQXViczZnNTN0?=
 =?utf-8?B?VW1uT085amN4TVJsRVlsOW1QRS9NT0JDSjErbS8xK01ab2xHdFVjTzZEQm9D?=
 =?utf-8?B?OFp4OGlZZ2JLdUZGMk80cnBQMmdzTFkxYW1UUlZPUUV1NXlYZGJsSExwdjZp?=
 =?utf-8?B?dk5MK3FVcXJGQTdpd2Znd2NzV09MV1MyaWs3dkJkTEdRRVIxOHNMbitTWTBL?=
 =?utf-8?B?S3h5MEphY0ltMXp3VVR5Q0Z4aVlnUnVMVU52MWhSaUFOcDJwYmprK3RVdHNM?=
 =?utf-8?B?NFNkUjgwVmdBcWpaNFhVdGhXdzdTdzNVTnJJTStON3MycEJCbHBJWDdiME55?=
 =?utf-8?B?ZEZIc1l1dGZvWlp1NkIxWFhhQnlIL1FlQUYvM2FDNlNFL3JhaTE3TSsyNDNL?=
 =?utf-8?B?czFPbmgwM1ZVREJuSi94Y3k0c0JJdVhmcXhJMDgrNWI3cG1PRjIveFRwbXl2?=
 =?utf-8?B?RkFvbktGK1NDV2IzclptNnFxNnB5MVBuNnRmVGFVREdkOUg2R2lZTjVEbE5J?=
 =?utf-8?B?ci9GSDdEMnRrS0JON3oyWUgzQm1aWFlSQVlkamk2TGY0S0VCT0FZdWJGSnFx?=
 =?utf-8?B?bUNiZG5vK0NOK0tmTE1pNzc1cC9XNWl0MXM5VE90WEdaVkttQ0xuNUNxY1hn?=
 =?utf-8?B?NWtUR2tmMjVzaXViQ2ZwUW00V0kvU0YzZWhpVGovWXJyWjZNVzdrUmUyaUUv?=
 =?utf-8?B?NmZMbWpkV2JJRGExb3gwaW5yNEtKWWJTaGVDQzVZWWkwb3QvYW9KUmdLc0FN?=
 =?utf-8?B?QkZUakZXMUZvcHlNRFJuemdhUzlicGdzS3JNdUlSSlRVSjBGQmprY05zYkxP?=
 =?utf-8?B?SERuTWE4bzlXalBKRmx5Y2NRYmdTZmZQNlZMdm1KYUNRZmRDQlA4UkxSdzc3?=
 =?utf-8?B?ZmxpcEFjbklnPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 255e0687-9dc0-4f95-83d8-08da091d27a7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 20:23:25.2212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFBCImE9RElecxK8Z+hBu7kh1WBbv9XtxdoJI9oICVRVDX7ERGSe/hbaelJapPTnKB63MRn2VH3uul8shkSjW1DBAxJWIwGJlLG++HCVJvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1278
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/18/2022 9:17 AM, Alexander Lobakin wrote:
> ice_find_dummy_packet() contains a lot of boilerplate code and a
> nice room for copy-paste mistakes.
> Instead of passing 3 separate pointers back and forth to get packet
> template (dummy) params, directly return a structure containing
> them. Then, use a macro to compose compound literals and avoid code
> duplication on return path.
> Now, dummy packet type/name is needed only once to return a full
> correct triple pkt-pkt_len-offsets, and those are all one-liners.
> dummy_ipv4_gtpu_ipv4_packet_offsets is just moved around and renamed
> (as well as dummy_ipv6_gtp_packet_offsets) with no function changes.

Looks like there are 32 bit build issues for this patch[1]:


../drivers/net/ethernet/intel/ice/ice_switch.c:5638:16: warning: invalid 
access past the end of '<noident>' (8 12)
../drivers/net/ethernet/intel/ice/ice_switch.c:5636:24: warning: invalid 
access past the end of '<noident>' (8 12)
../drivers/net/ethernet/intel/ice/ice_switch.c:5632:32: warning: invalid 
access past the end of '<noident>' (8 12)
../drivers/net/ethernet/intel/ice/ice_switch.c:5630:32: warning: invalid 
access past the end of '<noident>' (8 12)
../drivers/net/ethernet/intel/ice/ice_switch.c:5627:32: warning: invalid 
access past the end of '<noident>' (8 12)
../drivers/net/ethernet/intel/ice/ice_switch.c:5625:32: warning: invalid 
access past the end of '<noident>' (8 12)
...

[1] 
https://patchwork.kernel.org/project/netdevbpf/patch/20220318161713.680436-4-alexandr.lobakin@intel.com/

