Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02B69AE5E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBQOvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBQOvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:51:41 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D403C6C029
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 06:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676645500; x=1708181500;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yTKkfII8FlRHSV4zr8HJjCP3LZDwngm013XPm7+jjXk=;
  b=SdtnTMVRPq7Y85u8q2iRMSUZt6wLPakhllZdtT6Mtxn3AMWk21V5WRfi
   AkBWnTkFfLKKXX3HcJNzlLLsZvfY5EKd99P0CxfNHov7v+jU11+5zXcJQ
   HRrSU3b11Ob6vvxvIGYQv2n81WikhjJqFaLDjc30JzAXinLcBxgxkqjKX
   wsiY/kwp6t+RtBksW/GcwLQXOJjvypJmlt9MLTZVoP1oyv7EVEbGgTZa+
   2o8FpL9kdask6G1xoxE5Hlx66tRq0u8Grnue2wU6Gz20Mkk7cjJC6Q1Kk
   VVhF9CqJM7y1GNKEuEyLGi7QmjyBi5SYqBNoqUADsW+ca17/bjZIelosj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="330662069"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="330662069"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 06:51:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="759391109"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="759391109"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Feb 2023 06:51:29 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 06:51:28 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 06:51:28 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 06:51:28 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 06:51:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpDPW7q7qbQkgFKSe6pV6Djt9ZJiDvGELtkklVyfIdEztEJ2S+qGgt9paGITA/X2QcA6wqLaJmVqM2MZay1qi5ZmY/o0rPI7rJhtS0bqEZY8cQVd7peXV6oL+lFdTjkR11Z29VYjEaKooBQqP/1HeFg0O4Emrz0ZiJPJptfF62/L0a3KnwlWn8cLB0CoqOOeEYYsTrgZIa8qDezbFZFvhVADhleLOcoa2M7sjWC+73oNy8GcMmRuhlgKDfr1SbI47JCBaTALbEDSdmI4JxO+sOxHLW4sgM6q09y47rNwGPWHgFtld6MicXxhlTTDSv/p2RAOZ/K0XliMVWcezEFAlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hz7iOdWZKosVv3/ulrYjHPdjMQzt3XGDBWQUmj0WDI=;
 b=io9VFBv1uxGp6qfbgscVrHiGZGHurKTnYtlWfg9lf4SUNtvy07WM/RpBO6yxeTdNBzeDXhcy6FzdQUp8Au0f9Dziws9CP0endiRMPYPVXCXUCa+fSNmJZiycHWrsSOiaPRlHJ745iVOmlLC769ppC0v5uJsLHIT4F7qicDLjZ0OPAKFd/ZMWEIYpUeoFRzongi+vrYofVMhGLFUD6jm2iT4JU8CVemHU6YrAgjC+T6KUmz56vl5JXstySR79bpvxKiRGTz6+mAM881Si/QNuGFdOo32T68k6Wp219PPWc7GYJBRiStb1DGM1+VBvvOizJNkU8Nr4sGJF+fRfntzX+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB7173.namprd11.prod.outlook.com (2603:10b6:208:41b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 14:51:25 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 14:51:25 +0000
Message-ID: <3489ad7f-36d1-2726-d99c-0060865d015c@intel.com>
Date:   Fri, 17 Feb 2023 15:49:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1] ice: properly alloc ICE_VSI_LB
Content-Language: en-US
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <anthony.l.nguyen@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
References: <20230217105017.21057-1-michal.swiatkowski@linux.intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217105017.21057-1-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::21)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB7173:EE_
X-MS-Office365-Filtering-Correlation-Id: 63ba6a32-742a-4f2d-3ced-08db10f67154
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHm1cfc6cGrXTX5Y6D3ka4DbyNzazssABW8r1Resg6NTHLs+eozfCqUJISDabbhvE+qWPnCHewyn0w0mLobMXYTG5zvnvfU0Le/uYIloOFEZEevfLwYSfXNoa6eSWtDVkx3XIvQZYzwFhsq+4fnkJ+r2xk/hQpaLVI2xXLRwapTtun82/tWRsA6gnhpTV1y4sEhM1htIcSsF//xpaQI1ls+gyPLq1mva74FFz3jJ8VjHHydYnzjALEvzuyB/VAAbC2lgsKEGj1qgn/YmS/zgZ7Z/IjmCppc0ysRYYUo6I2MEH+QPN7VLMn1fspU380gylbSrMsUXYXqENTUj9VLCNlfUeJ1Dga8NcW2DUPkDk96o6D90rz0yzO1IbySjXNv6D5CcrSRrebleS/2mG93BA5qmv4gmVbYBl3r6BmUuPqLh65K8qNKK7JGS9VDBI95EVAuK+lSLR+PQUaECjEFK30VpX9yhmdJUpem4SaQaZU3Ew8i69w6Q6yhQWf7Pv/7FaQ+3iozEwf38dJld319Qu5Sg1y2u1wJ1GKLlNXJfjwq3vExDFzBq5rpD3C+k3pffag99YOr1yQrL1ki+Bb6GDazWC54tmkvKVUGufY8mUx/JnGrPCYeZNguvY3iMNUWGqtG9WK11pyirSYaLE+BcK4dcL2nbGCo/apqUdt/Bsh2IakUJ6Q8g6Yj18snYTkYwk3eGyCauL74OPLyGg43RH104IORyN8tOxmk+2SBE0uA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199018)(31686004)(8936002)(6916009)(41300700001)(66476007)(8676002)(66556008)(5660300002)(4326008)(66946007)(2906002)(6486002)(316002)(36756003)(478600001)(6512007)(6506007)(6666004)(186003)(2616005)(26005)(83380400001)(82960400001)(38100700002)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjBBQW5ISTAxeEhWcW1pVDlyTk5LdVVEUGJncEZ1c3FhTzBhK29oaUVNS1Vl?=
 =?utf-8?B?SmpTc1hDbFJTWUJxZDg5OWd4M2xWdTY3ZEpnbE9BbndGTWNaK2ZITDdDREVW?=
 =?utf-8?B?OFRYTTB4WndMVmdZVjhlRjU4WWFKTWlLdjFlbGRER3FqRFJ4eHNCbVZIalJP?=
 =?utf-8?B?U3hFR0VIRUdJNm1QbS9xMmtpb0dHTTg3cnlVNEllYTh0RmVuZHZlVGdZTUlC?=
 =?utf-8?B?Z0F4ZjJNajNkL3hjYkhwNVhoWkdiY0ZkKzNFeGRMeTFMbG4xejMyeGZDaEZU?=
 =?utf-8?B?VWRYdXpXUnRPb1JXRm15SzVaWG9NZXVVWXM0QkRrVlY3RCtuYTM5ZTRUNFQw?=
 =?utf-8?B?Y2ZGejJJRGljZmRCdGVHbG96RXoweVBTcDBnWUFvcHY2bFdTZGxyNis2VXQr?=
 =?utf-8?B?Z0hPeEdhcmt3S0ZBNEJHa0JzYU9Qa25BQmU3UVVQY1Z4SXh2ektKUitya0po?=
 =?utf-8?B?TWFNU3lWWWs4RmpUREtxS084TWVvRUFFN0xrTXNYb1ZLb20rWGlwbTE3NHBB?=
 =?utf-8?B?VWJOb0M1R2w0d05HYTgyRE1DMVloQUFiaVdjdS9jMUtzdmtnV0VIaCt0VWhD?=
 =?utf-8?B?c0thbTROWjlubzVqVCtkUkZ2YlVxd1ZNb1RiRjBweEZYMTdsMUxSeXZqcmJ6?=
 =?utf-8?B?UGJFZDd4UTU3WUhKK2ZlbTRvaWV0eW1OU2MvYUFXS1UrZnppTmQrT0k3L29S?=
 =?utf-8?B?QTJBQk5xNm9JYWpNUFcxdzdZV0ljYUJCejhUOCtKbmxpdHB3TlRRdDBJaVZ0?=
 =?utf-8?B?UFZQTzlkbEZacW53NVVBekl2SGhxSERoNXUvT3VscmlwUzIzYThOLzZYRnQv?=
 =?utf-8?B?b09aRk5sWkVQMy9ITXVodzJ0bGczOC9tV2RzMlpuMi9NTFltaE8zRE1XTUdT?=
 =?utf-8?B?SENPelUySDlBd1lXNlhoZml5NnBCL2JnMUFhOU55bHl2MlozVkYramZiZi9h?=
 =?utf-8?B?Qko1WXVjcWZ3ZWNLZTUyUE5DWkN4Y3hEQkJxNjhKTGRtU3hyT1RNSFdrMHU1?=
 =?utf-8?B?cHdUY0w5akdjZTBJVjhjbWxiVTBJNmxWOC9HYlFhZWg0UTVIcDBiVzZzc2I0?=
 =?utf-8?B?dEM5RU9Xd0pKUmZxSm4zcnRtaDVMczFxVHpOTDUzMUFqbXNHb1p5S0dRRW90?=
 =?utf-8?B?S0E2ai9Tb1ZDeGJ5WlZJaTlvbk0vYmY5RjhUajR2UkE2NUkwaXZDMlRSQlJP?=
 =?utf-8?B?dnZ6dVZwY0M1NmdTT3Q1SGxZSm5kdUg0a1RaQURkNGh1WEh4RjVSbXQ3eEZQ?=
 =?utf-8?B?WmFLQy9IL0JwWWxWaEw4cTkzU25zS3Zwb0tla2EvZXFmV0VKWEQzdmdHMUpx?=
 =?utf-8?B?cndkVW1yNnZhODNEcjhTUHgxTXdTZ3M5QmcxNGx2b3hmRTlWOVpFb1g4Mmtm?=
 =?utf-8?B?M2ZyN0RzV1ZWU1c0Z2d4VHN2cktEQzFFMGFvRFRqSCs3QnpOdWZRQWxWeW1w?=
 =?utf-8?B?QlZDQy8ycjFJYVZVY2J3RENrTmZOT2VQMWl4b1drSGZzQ0IzK3NwSEI1YnFK?=
 =?utf-8?B?RmNKTHFMY0VqWHpMTExPNlM0UGpPMkxSaDJFNHp0eVVGakFJVFhlTlc5dlVL?=
 =?utf-8?B?MjVhckltRDhjQTZqNVlnR3QrK0lVOHBNU25rL1VIenhXRklkM1hkTEZRY3Rl?=
 =?utf-8?B?c1hiSHkvUXlpdlFvOHBldXN0bUMrdm5hMHcwMHE5ckRzSXIzQnNtMFpJZnV4?=
 =?utf-8?B?VVRlWUNMVFZieUwxcG0yTzI0REZCRFpzdlBuNE1WczFVODdrQjVmeWZ5UkNQ?=
 =?utf-8?B?WklYbXByNnhPR2F5RTZ0bDd2YWNUUGdGdHpQeVA2YW1FWGxwR1lUUWVsTy92?=
 =?utf-8?B?WXdsWkJnelVpT054cTlielorSHFMcFRDbDVuR1MxVGtXbDl4M3pDUjFvaFRT?=
 =?utf-8?B?MU5KWHFDQldnbi8yV1lRWHhIU2QzSGVmaDBqY1Y0eG81L1o1aTZPOG5rWnF5?=
 =?utf-8?B?MXB1M3dmdVladzQwN2p4MnB2eGN0NGhIaHlkZGhWOG1TTnkwdXM4SWxxUVgx?=
 =?utf-8?B?R3dVWEpRMHIxY0R5RW9UY2hnWEN5b2ZQN0dMb3d2STVvQXFaczU2WFJJS1RB?=
 =?utf-8?B?endYQVBNcHV5dWdNdnFlTCtQMnJpMlI2a3BpM0QwQ01vWkRDQWFxY2cwNm94?=
 =?utf-8?B?cmczUTNHYWZ1bXUxd1RweXBtTUlGRmNGdkdSdTJZZHNFOFh5SjZBeDRjbDF4?=
 =?utf-8?Q?R4rYQhsBrxyJ9ZX/nTCAJrs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ba6a32-742a-4f2d-3ced-08db10f67154
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 14:51:25.5058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ojLPfK2pqimdnK0qTZBDiwlLoP3splPm30rIjcs6zXVrftgSL9BGJaDAyO3X49qeh/oR+zgbxu+QmvLP977GjM0K3TvSqxOftK4aPNa79g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7173
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Date: Fri, 17 Feb 2023 11:50:17 +0100

> Devlink reload patchset introduced regression. ICE_VSI_LB wasn't
> taken into account when doing default allocation. Fix it by adding a
> case for ICE_VSI_LB in ice_vsi_alloc_def().
> 
> Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
> Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

Too late for 'net-final' PR which did hit the main tree already and I
believe there won't be any more until 6.2 is out, so expect it in 6.2.1
only :s

> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 5e81f7ae252c..3c41ebfc23d8 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -627,6 +627,7 @@ ice_vsi_alloc_def(struct ice_vsi *vsi, struct ice_channel *ch)
>  		vsi->next_base_q = ch->base_q;
>  		break;
>  	case ICE_VSI_VF:
> +	case ICE_VSI_LB:
>  		break;
>  	default:
>  		ice_vsi_free_arrays(vsi);

Thanks,
Olek
