Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DD76A4549
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjB0OzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjB0OzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:55:17 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF6C2279D;
        Mon, 27 Feb 2023 06:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677509703; x=1709045703;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1pN7SKozBSiGOLiN5Hzjkplu7cBYSGbNXGrDomShYkw=;
  b=VJdivAZwMUVN/uxSp8a11N70VbEW8+0TW/ED2iQYE4S7E1alzZBsxCJh
   tf8mdQEUAte4UX4/DNOuFhuisf4t439maZBGKJkp4hpFxHtendpUVv3Bx
   gbcTezWGKuaB9VDJ0mwB1O/2796rqQiFjJn8qoABq36vlw4EUROJu7T9x
   nuKmfl5HM10cD05mHKuXJ4yUdAvsOn9QWSycjQewAFzw/ddlupqM2E1vk
   rVo41RW6ld/xGkb93dPCmdAJQlI9goM9+KoEuYQTDJXiBEh8AvbWjdXo3
   6CePeVwfq2E61ve2JkeN7HNzPlbAbLl8iRUKO2VXSSdr/jdLP4KdgDmFQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="322119307"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="322119307"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 06:55:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="783415126"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="783415126"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 27 Feb 2023 06:55:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 06:55:01 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 06:55:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 06:54:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m75omimun2lUKNNLwZY9HQ3wWYDUnj12WJumAY/bDJ9y3NAND+so8863c/RQoanqJO+hZ6fvEVKQ4h/jSeyHKh9sfxz8GnTTPynB6y7GtOhLAKNOZGog+aHYVwmyXjXwmKuSf+Nx4nvNZBikIMBHfnKk4QBh/pRPjo30GP/lKrQUNwxCdFZM5DL+ATC4YHzG4OCcTgkGHdZrY7YRcBV5x77LDuUJGxa4IqNoFS8FSPJgvFKnRPD5B82gGT2rikX5y00F3y7dkBtm23VtuIm2wI+YbIDIbAKZ33OLD52XLEob8/Udyrzw33BT5UObob9xUk4wOtYBSCENj9Ee6RAdYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kfn5nuhYVRZuEm6RK+V2VC3UsrCmHrqwoOy3s7k9kLs=;
 b=gUGBBjvZOE1DSNtey9jeZQ5r7ZIJH2nS0SXvW6/xyUNJiUNZM52zEAfe20BO4hPefAMfTPObKlAFHVFrNa4egsPCJHoxO74zkMKNnHAYpgpjg0MIHKM8sH5APa6HUuDd8/DSDw9bo/y/DRxA9MUMU0YExVnZPWaC9IYkbx1F4HhVv26etV/Lpnn8vVAlLtAjkd3PzjMgVc+X1vL0NRh6uV8cg0c3Z4+/QRdF9yGbFvs6Rk7Q3YBaG5TRWwawf/i4ye/3gV7G1Zgy9Z74n4hwEo3yANPoqyAV4tVz9Uo4gt6lpf30+JLZWHpnMOuA2yTvHcuyyjtXXT6nh9fh1xrt/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB6192.namprd11.prod.outlook.com (2603:10b6:8:a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Mon, 27 Feb
 2023 14:54:55 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 14:54:54 +0000
Message-ID: <2d3ccbe7-262b-c579-a8a7-eea84d7aa91e@intel.com>
Date:   Mon, 27 Feb 2023 15:53:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [xdp-hints] Re: [Intel-wired-lan] [PATCH bpf-next V1] igc: enable
 and fix RX hash usage by netstack
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>, <brouer@redhat.com>,
        <bpf@vger.kernel.org>, <xdp-hints@xdp-project.net>,
        <martin.lau@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <ast@kernel.org>,
        "Stanislav Fomichev" <sdf@google.com>,
        <yoong.siang.song@intel.com>, <anthony.l.nguyen@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
 <b6143e67-a0f1-a238-f901-448b85281154@intel.com>
 <9a7a44a6-ec0c-e5e9-1c94-ccc0d1755560@redhat.com>
 <a499a5df-e128-b75f-50d0-69a868b18a71@intel.com>
In-Reply-To: <a499a5df-e128-b75f-50d0-69a868b18a71@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0028.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB6192:EE_
X-MS-Office365-Filtering-Correlation-Id: fa9f8af6-74d1-478f-69cf-08db18d29641
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ah3J62zEoeRGdbvZcbp/EkRX3H31zI0oYe1pfO8HbACqfQkwcqFClkmg9WXcNpVpWscWqJAybR7nf0+Ap0OIAxp4JFzKgfBBWCqmE0CSPZNMZotpFYHtJ40wQWpyL5Mpm7SxLg7hlL7sv+gNBmcb+qYTBSZt5ktWTkNPILIt/Yon04D/62W+oBkNI8SXSKKS502AlqArrazHMW3WNryzJwXHMNOm0V6cYV8b9snefRtfiXPtxZhJBTUUJKE34gKzptG9dp6J/UOrC4acXjiL9Fh1tM6NucTg/V4RSY7T4aohN4vXMbJ7YD5MGVVH7Iuv0yOtGZDVA1fhl5GAj6oTZoaY8uuqqQKX4XHJvpD4tIbYgY01UKO2DsU/D31SxvcABqYuggbwx8Qz2vBrzhWBNHqT9w+7G885cHrzDVPnfaX956vTFAkYgxS0Wj5Ffu/hqCEoXy6kBtWtyaReT++3MmlIc2SnGncAvbidx7SpvQ/4m13PyKMZqjPVEXYglOS5IRaFR01xytATMMxFKzryH5smia5keKSxe27qVHVqgCwej5BW5WI9oVilEIMs+6fdy8fnX0NDdQCEaIgEVAZ+BGaYM+WAckL5mR4a5gahiN4NhFleY2dqqa9JaTJhBvSPxTI5X1cYEQbToXnERgrSPVQ+f01yvyhAVckUSdU5+ZUO665LRfuLdb3lB5wfwSLmqDM2mJ8fl5mM6vm8x70pW/J13nXI3WF0ILesGk/BpfU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199018)(86362001)(6486002)(31696002)(54906003)(36756003)(31686004)(5660300002)(186003)(2906002)(41300700001)(66556008)(4326008)(66946007)(8936002)(8676002)(6916009)(66476007)(6506007)(478600001)(7416002)(2616005)(6512007)(26005)(82960400001)(316002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWFTNHhrNGhQTmZyREtuYktlY0xUOVJhbkJsUEh6UnEzRXNVbWlSTy9pREJH?=
 =?utf-8?B?bERyN0pGNjUvZ1pJZGROaXdTRlhRWFkzV0VPaG1SMWNyL29Qc2htd3RtYzNK?=
 =?utf-8?B?bG96VU1TeUxLazJQTHhZWm5TWFIzVE1jb292Z1gwYTNQNzRzNGJ0dWNlczNB?=
 =?utf-8?B?UDFlbEdEU0J3NEp5cjhicG9LT092R2s4RXFZZlNuOGFsYjFMSG92RGxFbHRt?=
 =?utf-8?B?UGUwNXZyZzJYdVhsZDdLK3BqNC9RYkVWRXlsQkVIRXZ5cWdWMUV6Ui9OdDdY?=
 =?utf-8?B?akxsdkZmWlZOVkF6WThVM08ybWZkQTNTSnFVNnRjdGxjYTRIUGtOcUxBQ1dD?=
 =?utf-8?B?Z2FJNDNDanVCUXBEQ2Z3ZDVsTzVMbmlWR3B4emUxVlIveC9pSlE2SnBrUmJl?=
 =?utf-8?B?dThnT28vMTBuYW14dndjdmRQY3ZTRG9xZDQ0aWFERDlhRVM3UGRWMlA5dERq?=
 =?utf-8?B?Tkw0U3RYTDQwbWdTVDZLOWhSRWxLdHE3MXVCUDJySFVBRlNORDJ4b1hQWElE?=
 =?utf-8?B?bGtieks1Y2lpaVlEZkNJaTVRRnJlY2VRbDNSVFZuQjJJbkpvdHVOMlRkNmN4?=
 =?utf-8?B?ZE5qYjk1UG4wZHYyRkoxczJwdkJCS3hkNkFHVFFrck1kKzl2N1pNNHlLbHAy?=
 =?utf-8?B?ZEZuUzViRHYvZmtpT29tWFFvMTcweWVWMW90N0RiWjNaQUU2T3ExSThLSndi?=
 =?utf-8?B?YVNLeTNuT1U4VDFIMUdZS3lTSmN5MWpZM3FscUIvM1cveVJKK2drRWRUU1Mx?=
 =?utf-8?B?elJGWnVpNDdXMXE1LzVsaFRkcGpNS2RsZmsyNlNPMG9NVUVwTDNqVkVrUDFF?=
 =?utf-8?B?WFV2TlZlSk80TzlqUS9Ec0h2aEFVVHoyU3NwQ1VicTRESDJWOVkweGhDQ1R6?=
 =?utf-8?B?R0NSNDZYQnNKTlBOcWpQVC91aUNEbXBTMEVHS3dQc2hsVUQ5c2xHTzNiaHQz?=
 =?utf-8?B?UXVvVzlUcnVFVlpES05PYjFTL0dWdHM4NjZITDFja0dRQTV0L0pCRldLQ1dN?=
 =?utf-8?B?NTc2YmlhOUlmWnA1TTBaVEtHblR3MnVsbmhSa3ZRN1hMR2VEOHNvenowV0pN?=
 =?utf-8?B?d3hLWHYvc29NUFBvTmdlM2RsTE90eTBUclI0MmtBYVgzZEhJNElnajRyN1dN?=
 =?utf-8?B?bEIyYzVzdVpFdTNQSU5pQjFLblg0SDl3cmZlZy9hNmxFV1NNWE5XWjBJWHRN?=
 =?utf-8?B?L2VkZFlOM1kzVEJtU1h3VlRNMzFaZjh6emd4TnJoc0F4Yi9ZZDUwTDFmL05T?=
 =?utf-8?B?Q3ZORnNPUmplckV0b0lhakFoTWp5VFlPbXczZWZQR21NRE5taE43ajBtaDhp?=
 =?utf-8?B?S0wrYVJ5YlBCeGNsVllyVm9WZ2lMckdmeGpZRXdLcnZZRmF1eUZscE95S2Iy?=
 =?utf-8?B?S1Y3Wk5kSU5ielhYcDNJTEt1ZGxaeWFsdW5DMVQrUTNyekNGVXFPY2FCMjlt?=
 =?utf-8?B?UVdZRzFWL2Q3aENzVGl0QjZiaFpEaFZPTDRHZXBOK21xQU9Hc1ZnOUVzNHhL?=
 =?utf-8?B?aDlJNlAzaHhZdG90eEpqeXp1cWRrZEdWaG1mSWtKazNaRmJVb2t6ZWM1K1hI?=
 =?utf-8?B?WG5wSXNuVDhIQStyNlQ5WXgzWWwxQVBYWDkyU0N0NE1kaTJSZ3hVTWJkV3g2?=
 =?utf-8?B?eXlHT0VqTi92ME4wZTBjT2R5TW9NcUlEQmRMdTlHeWFDTG8yN1c1WlBoMENS?=
 =?utf-8?B?dnpXTEh2SVVWZ0FUdXlGeFlhR1RjVkhLMk9keFNSTUlZZUI2algrRWIzSDJm?=
 =?utf-8?B?cHJpUXdMWmM2UWJydVVpNVlUVmFKOTI3aERtR0pNSXVrcGovUTA1RnpzS0ky?=
 =?utf-8?B?RjdoSWhhcjdIMXJJRThEQW1zVVBQZ0hWc2NBR3orcXY3WFBDbERxRk1ISUFz?=
 =?utf-8?B?eGU5THZralBmc2R6NjR4SjI4dVFOeEhvYys3YktXeDd6VlFZdVJiZjNtaXlz?=
 =?utf-8?B?aHg0M3FoTUdkUmxKZzJ5MWx6V3RTTlAxSmRSWVlDNGRPNjhuaitxS3NHR2Ew?=
 =?utf-8?B?UzliUWVLT2lPU2JqQ1ZLWGg1TC94WGFObFdDTUNPUXMzWXA1aGlxOWk5dy96?=
 =?utf-8?B?NXpLQXdTNlNzTFhmbTBPOTY2ZzFLakRxdEV0M2VrNldlYzRUcm9SV3dqK2ha?=
 =?utf-8?B?LzJrNVhKMlhnckxrT2tTb2hjYVFZVjdPY0NTZDJBd0tIMExlRFpMLzkwMnl5?=
 =?utf-8?Q?1v8dOBX6iNJxSOD7xGRDo68=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9f8af6-74d1-478f-69cf-08db18d29641
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 14:54:54.8937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6aZIVMEgEFB5HGhwWdzz/E/GK+NDVDQnhIVi1ow8db7mne/ZIJcDpD3f8FBHO8dqzq/I5tx6O2YE1qD7Erx8KBvWdTMAcL81d97iC/c4QHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6192
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

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Thu, 16 Feb 2023 16:43:04 +0100

> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
> Date: Thu, 16 Feb 2023 16:17:46 +0100

[...]

>> Summary, the only thing we can save is replacing some movzx
>> (zero-extend) with mov instructions.
> 
> Good stuff, thanks! When I call to not use short types on the stack, the
> only thing I care about is the resulting object code, not simple "just
> don't use it, I said so". So when a developer inspects the results from
> using one or another type, he's free in picking whatever he wants if it
> doesn't hurt optimization.

Oh, forgot to mention: I just don't want to give people "bad" example. I
mean, someone may look at some code where u8-u16s are actively used and
start thinking that it's a regular/standard practice, while it's not.
I've seen a lot of places in the kernel where the short types were used
only because "the queue index can't be bigger than 255", "we won't
handle more than 64Kb of data in one loop anyway" and then the stack is
full of u8s and u16s and the object code (I'm talking more about
hotpaths, but generally is applicable to any code) is full of masking
and other completely avoidable operations.

> 
> [...]
Thanks,
Olek
