Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00517640CBA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 18:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiLBR7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 12:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbiLBR7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 12:59:32 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CF7E465D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 09:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670003971; x=1701539971;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SiBaj/Vio1m/9fqhnq1lvqJxXviHXUU65vtyiiz/UKg=;
  b=RwGfNNEQf+m4xaP7fX7AIJikPdE4L+ciN/nSP6xm6zk1ixKjoRhs9qlC
   WtHNDja0iR9tFOQ7dObfDaetI2EYEteZ5IhmH6jYq/ji8sTm7wtEQXgCi
   UkUVe5xZD5gLnQFLJXW1lGhTMfXdi9iDK/vJGpvXVUrRAOfPj1MdVBnqM
   Vzy8+GGsGZfVSIMye4s2ovdKSStpfufmJHV6GFr1ZO8nMGubtrp/gX2sR
   y50KLHxHJXYsq/IAPO6x39MUL+Ahwi+XeygsqeZvSuhmiGkbKGc81w5dW
   Y7iG14NHdlEuDsCGqLtoGU+HYqJHQ7HKfNqwjUQyM0QdGVW/I3Y9f+Ddy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="316034451"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="316034451"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 09:59:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="595524686"
X-IronPort-AV: E=Sophos;i="5.96,213,1665471600"; 
   d="scan'208";a="595524686"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 02 Dec 2022 09:59:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 09:59:10 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 09:59:10 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 09:59:10 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 09:59:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DALqw+kdR0jj1wpDgdeKP74oS1YvJojRJSa8UZKNk86/UDWYmHIOOyW9GmVwXWh5zzmuTgBS6D6lUrP+FExfX/B5MrzHj0stvF0OqGOLNMFm5On4kfwovwoefIAqk0IRjU09PvumVaLkA3VVQCy95yz/ZnwtszTjOCh8VSNX0NULmN0/zyydLso0mm2ew2HhSPCEFZDEtinGY+aIuEACBbdnF8kUZopYTodqxED4Uqa2QB7ZxUhMLkGF2w3XNXDnbk0kCCFYCAHo8l8SGaivfAIcp7kuv/6p7hr1HRnmp1avzhc7hVVtYyW3uWFYKv/LDk515KYfuX+fQNmc/s/hRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yea6iFVf2DGTsvJonWB/DS/zd/X+VZUzS1I4vnW8w0E=;
 b=FdpICF9N/ovCuttWdpDu0lqYm5JeqDpWb8DRFIfjHhHxw01r4cy2en2VZz1pQNzlmEw5a0DdN8+lzTDgfTBedYdILVCmQd8CDDo/wJVCh4hjlC6isjGc8nE4aBOvIusGnXboUDwyOM8EBOiF10atRmvK6nCqIlrhO5cvuafuyHYigL76GF1N2DCkFVTkLpOfCHKhnJRpcLPpFw0LmJ/5c8GQSwIAbZhciDRaBloLt7QDAITIyKKv8Scct1Oi15jLlF7o2y4i5E0Bg9xDwPFy3E0PNE5MtUeEqR7h0lVTMfsynhK+rekVk/Ff3ZbOuqsPBe1QAYud8UUapn4Kzhh/JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6259.namprd11.prod.outlook.com (2603:10b6:930:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 17:59:08 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 17:59:08 +0000
Message-ID: <a631476f-b8d3-7542-f8fa-0c910ec8ad06@intel.com>
Date:   Fri, 2 Dec 2022 09:59:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 06/14] ice: handle discarding old Tx requests in
 ice_ptp_tx_tstamp
To:     Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
 <20221130194330.3257836-7-anthony.l.nguyen@intel.com>
 <870d718381cea832db341c84ae928ddfc424af64.camel@redhat.com>
 <0917b04e6a1439d2730bdae2f87a847a3c76951a.camel@redhat.com>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <0917b04e6a1439d2730bdae2f87a847a3c76951a.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:40::29) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY5PR11MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: 310f5096-c349-4b8b-8ea2-08dad48ee781
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rz9DJdbIKHMAAejMQZNlpxhgTvP5zFhFXCg4gc7FKMNZ+IhP6Kqm4Xnv17H5Jbu7KKs6HB7Rw31DJZeFxI1rxDtYViHTdNTWgrH/+mc5qhQ45HTiFQ2j6Wvn9ptyM8og/hb+p3Gfj0AsKSVPox3QtRSEb/hJEP+wdMU1hfJQbL/Iz8ogjCCtjSCAY6VbLZ+giHD5KQgc5qWDGomzLDFPOyACy+dp4miwMPE6FgYekMLTiMIxP46wQ2uCP8rn2ELRgM0ujJy0qBVRcSYOimkBSn+23gEPwxMPHKU4708iG6i4cI5UmmB1CwbC5r7umguHU6pbN5/dETQtOT4KPO/luavixQDAci0ZgFR0WZZ/ner4FZTfiXL3czJ866Vn2CKARnTLoyzkq8cHOB6PKn0WA58befhb6KDPenAURHO135tIDDZaplhZd0N4CB7JoGAeGPtIbOJ+dOiKe0E2poAkPm3usrgyS9TyyPksu7AEi82k8MMAKINBsVnWJ9YxjTTJMbqsIoOIRjgTpMjEoJnbcvlskiPZsmUAXOQGU4hDVmeeAOKQN/1L7+PNGerg4ET1jasvvdsjd66FHeitX20o9Fm6siqKU1jgd16MdbVrpB97WlBXdP+BZ/OGxZuDDo3nlCSHnxsckT7olkYBVCPij4MClf7DO5FkugajGrmkl+33ToAG13sAFy+1vA0vn+DiCI8QrUzM6+1Xq7piAxVN7UDDljeJWDaDpwjsM0erZlo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199015)(2906002)(6666004)(38100700002)(36756003)(86362001)(186003)(6506007)(107886003)(53546011)(6512007)(31696002)(2616005)(26005)(66556008)(31686004)(8936002)(66946007)(4326008)(4001150100001)(83380400001)(66476007)(316002)(41300700001)(8676002)(82960400001)(6486002)(110136005)(478600001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVA0YmpuWXlhTTY5MitJd1VpcmlMaUlPZWpzTWV2aElMa1pMQ2NHeVNEQ2dE?=
 =?utf-8?B?TE9ET0dQN2dkbHVJY3NFcGZsMWh6MURDZUlHRVBOYlBZR3IyMXFRd3JFZTBR?=
 =?utf-8?B?RVZtZ3dpQktQVGRqbTFyVXRvcmVhK3JTOTZ2cWtiL0ExR09GalRneVlORGZC?=
 =?utf-8?B?bGxHczA1azZWUUx3U3hBWkF1ZmtSRmFrYzVmMlJHZEdEL2NlOEY4RkFpbUpE?=
 =?utf-8?B?eG93eldTbURreE9OY2V5RDlJSXZjcy9QdGlCVDFLSm5MZFVwVWU2UlBLZGNr?=
 =?utf-8?B?NzQzT3BZL1kvYUJOdUNFaExWU2FFdjkvWGZ6Nzh1LzlCVGw1VUhkQ2VRTzF3?=
 =?utf-8?B?eEpkbUF1eFRYSm9sZzkra21FUmhVcVcyU2xFWlRJMnJTbUJaaXQ5Y0dnRlhV?=
 =?utf-8?B?UkE4cnBSZ21GQ2VGMjZ0NkJXMnIyQm9tK25qWW41Z0szN1ZSZ0pDajdhR3BL?=
 =?utf-8?B?czFSL09RbDZ4RkdPUTZ4Z29vU1J5N3FaSlUxYWI4V2ZZaytpZ0k1TlBOai9s?=
 =?utf-8?B?b1FhcGlycW1qbGdoRWZJOG5pSFNPeitSUFZOb3pYeE9KbHBzSm9mM1ptZFll?=
 =?utf-8?B?TjJLaTdnKzdjOCtCWkdvL2kvdmpyZG5qRVRKWFN0dEFRaXBRV2VGZzlZM25p?=
 =?utf-8?B?TXQyZlRueXJQL3dNUmJaVVBPZlVhOUlWYUxqREowNFh1aXkvWXBnMW92SHFZ?=
 =?utf-8?B?TndsZTdzWTM4Zms1MzJOb1lkcHFybVhDa1E3bjV4WS9jeUNSMXBYelZmVzlP?=
 =?utf-8?B?WWVscVkwUU44cnlvdlltWUhnSEMyYWwyREJ4eVRvdTgyTENpWSt2R1ZzeE1v?=
 =?utf-8?B?VG9Pb2NJVUM0akd1Z1ZxNG9IcUd3N2xSdE1ER2o1QkhWRmFqK2RidUFCQ1ZG?=
 =?utf-8?B?ZVp4TjRXWWF1bllwRHFhUTdyM0FvRUpFeFNoc0hRV09kSyszZmw5dGsva2lB?=
 =?utf-8?B?T0liU29ZZVlVd1RPRjFCMW1VWW5ad2Erd29rSzZPdXJuMWtTbUQ4NlBQNXIv?=
 =?utf-8?B?d3I1OFMxLzkzQUlRenVRWTJ5ZVZNTFMxUDRsQ0F4SGhVQ0ZPNU9pZ3dZTVli?=
 =?utf-8?B?OTJ2U3dPdXA1MGx2ZkxITUJyZ2VMVkNCM0V5NkNLSWhwV3RRS1d5ZlZIck1U?=
 =?utf-8?B?SldjTlI0ZUN4djd2THNIM1FWaUx1a1loN3JlSkg2aVFyVUxSWVlBNmlyaS8w?=
 =?utf-8?B?UVNEaUtXZ3J1QjZRVnFQdXdIeUFsTGMrWDRpa1VNQ3lydlhRT3B3YkpmVXd5?=
 =?utf-8?B?T1Mwc2N5M2lNeHdSV0pyRDY0Wk9FOHBpa3VVQUdnSjc3NjNpZjVQY1dDNTJv?=
 =?utf-8?B?ejRLMnpBL2RSVjg3UU9Sa1ZLU0RRVFdOVXBpd2RYTUhGaEpzVnQvMEpBRFlj?=
 =?utf-8?B?cXVEQ0xvYlA1dWFLU1kvSVhRUFUyLzdsbVVzZTdhek5nK2x1ZnNmR3pta1RV?=
 =?utf-8?B?SW1TczFiNVpSQVpuWUk0YTZQY2NodWI0MFZzN0sxd2RjcjZwcEROOUNYMlR4?=
 =?utf-8?B?WFJaZUFvVk9LaGg3QWZzN0NhQ2RtS0wzOGU5cjBza0txMENnaTNpTzFGZHZR?=
 =?utf-8?B?NEtTTitvWkFwd3IvTjM0dHRyWnkrekVwek5pU1FMdGt6U0lBZExuZjdHdjFl?=
 =?utf-8?B?clltNVhWTStzd2hKTXZRNWF2dFlWcG5zWFBnYkRjMTZVUVExM0JCV0dZK1Q0?=
 =?utf-8?B?Z3RZOVJqMlhja1ZHRUR1YUtaK3hiekwwbGRibm1udWZTeG1XN3RUWGpVdjBs?=
 =?utf-8?B?UkMzL2ZhQkgxZHR4R29FTkNIbUMrSzQ3b2JBWEdVYnQwcnZLSEluQlh5a2JO?=
 =?utf-8?B?UGVsT0ZUZWNqdEpUMUxZM20vdU90S0U0RGFFUGZ5TGRuOStiU0RqVFRBanBx?=
 =?utf-8?B?NVBnMlhMR0pxT1liNlgraGkyL09lVlBOaDFZdlk5SStLUEQvYUlFY3JlMFQ4?=
 =?utf-8?B?MFVmNDNzTHAxNWlVeWFzM2ZoWjlkb2U5Y0lzaklsNDZ6ODRPRVp0b0hoNU1Q?=
 =?utf-8?B?bVJlWTVMd2tKakZGMjRBZ1lITE9sOXFLbUNrTjNJMEVHVDcyTm5KTzBjUFQ5?=
 =?utf-8?B?eDUxMWtycTZ2OVk0VFdGMFVjaWplT3JqZ2VUTjBzU2ZFTzV4Ni9CcTJzOExT?=
 =?utf-8?B?Tm9xV2xZRmtuR1lDV25yRFdHUllISWhmU1Y0NjZ4M29HV091OXpJRnN2T0hG?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 310f5096-c349-4b8b-8ea2-08dad48ee781
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 17:59:07.8940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hdwjqT5A0yJ2P551hLhZxB3smdaadpM90t2VYKBq4gB4mablMT00lgnE/mVrAuT8n8sBaO+wi753cLSgbJvb9NN/uemyHKSL8N2wNYM0wsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6259
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/2022 7:04 AM, Paolo Abeni wrote:
> On Thu, 2022-12-01 at 15:58 +0100, Paolo Abeni wrote:
>> On Wed, 2022-11-30 at 11:43 -0800, Tony Nguyen wrote:
>>> From: Jacob Keller <jacob.e.keller@intel.com>
>>>
>>> Currently the driver uses the PTP kthread to process handling and
>>> discarding of stale Tx timestamp requests. The function
>>> ice_ptp_tx_tstamp_cleanup is used for this.
>>>
>>> A separate thread creates complications for the driver as we now have both
>>> the main Tx timestamp processing IRQ checking timestamps as well as the
>>> kthread.
>>>
>>> Rather than using the kthread to handle this, simply check for stale
>>> timestamps within the ice_ptp_tx_tstamp function. This function must
>>> already process the timestamps anyways.
>>>
>>> If a Tx timestamp has been waiting for 2 seconds we simply clear the bit
>>> and discard the SKB. This avoids the complication of having separate
>>> threads polling, reducing overall CPU work.
>>>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>> ---
>>>   drivers/net/ethernet/intel/ice/ice_ptp.c | 106 ++++++++++-------------
>>>   1 file changed, 45 insertions(+), 61 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
>>> index 1564c72189bf..58e527f202c0 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
>>> @@ -626,15 +626,32 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
>>>    * Note that we only take the tracking lock when clearing the bit and when
>>>    * checking if we need to re-queue this task. The only place where bits can be
>>>    * set is the hard xmit routine where an SKB has a request flag set. The only
>>> - * places where we clear bits are this work function, or the periodic cleanup
>>> - * thread. If the cleanup thread clears a bit we're processing we catch it
>>> - * when we lock to clear the bit and then grab the SKB pointer. If a Tx thread
>>> - * starts a new timestamp, we might not begin processing it right away but we
>>> - * will notice it at the end when we re-queue the task. If a Tx thread starts
>>> - * a new timestamp just after this function exits without re-queuing,
>>> - * the interrupt when the timestamp finishes should trigger. Avoiding holding
>>> - * the lock for the entire function is important in order to ensure that Tx
>>> - * threads do not get blocked while waiting for the lock.
>>> + * places where we clear bits are this work function, or when flushing the Tx
>>> + * timestamp tracker.
>>> + *
>>> + * If the Tx tracker gets flushed while we're processing a packet, we catch
>>> + * this because we grab the SKB pointer under lock. If the SKB is NULL we know
>>> + * that another thread already discarded the SKB and we can avoid passing it
>>> + * up to the stack.
>>> + *
>>> + * If a Tx thread starts a new timestamp, we might not begin processing it
>>> + * right away but we will notice it at the end when we re-queue the task.
>>> + *
>>> + * If a Tx thread starts a new timestamp just after this function exits, the
>>> + * interrupt for that timestamp should re-trigger this function once
>>> + * a timestamp is ready.
>>> + *
>>> + * Note that minimizing the time we hold the lock is important. If we held the
>>> + * lock for the entire function we would unnecessarily block the Tx hot path
>>> + * which needs to set the timestamp index. Limiting how long we hold the lock
>>> + * ensures we do not block Tx threads.
>>> + *
>>> + * If a Tx packet has been waiting for more than 2 seconds, it is not possible
>>> + * to correctly extend the timestamp using the cached PHC time. It is
>>> + * extremely unlikely that a packet will ever take this long to timestamp. If
>>> + * we detect a Tx timestamp request that has waited for this long we assume
>>> + * the packet will never be sent by hardware and discard it without reading
>>> + * the timestamp register.
>>>    */
>>>   static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
>>>   {
>>> @@ -653,9 +670,20 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
>>>   		struct skb_shared_hwtstamps shhwtstamps = {};
>>>   		u8 phy_idx = idx + tx->offset;
>>>   		u64 raw_tstamp, tstamp;
>>> +		bool drop_ts = false;
>>>   		struct sk_buff *skb;
>>>   		int err;
>>>   
>>> +		/* Drop packets which have waited for more than 2 seconds */
>>> +		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
>>> +			drop_ts = true;
>>> +
>>> +			/* Count the number of Tx timestamps that timed out */
>>> +			pf->ptp.tx_hwtstamp_timeouts++;
>>> +
>>> +			goto skip_ts_read;
>>
>> This skips raw_tstamp initialization and causes later compiler warning
>> when accessing raw_tstamp.
>>
>> You probably need to duplicate/factor out a bit of later code to fix
>> this.
> 
> Ah, I see the warning is resolved in the next patch. Perhaps it's
> worthy to move the relevant chunk here?
> 
> Thanks,
> 
> Paolo
> 

Ah. Its probably a failed rebase. I re-ordered patches a bunch while 
trying to decide what order made the most sense. Yea we should move the 
hunk from the later patch into this one.

Thanks,
Jake
