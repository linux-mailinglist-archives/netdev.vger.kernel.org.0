Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37766D5D85
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjDDKa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbjDDKaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:30:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6371FEF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680604253; x=1712140253;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0T8RXwqwGx+vFn0LB/yy0b+ad92xiajOSLlfP1MyZyk=;
  b=XJ0CT56nkr3pPncJVPhFFFvkBNu8vYYbJyFH8zWUNfKne6n4P4x952wr
   kKzAUk0UR9KbOtt4aoC3krdF3dyOPqRIRGofNrDl2VSshSB1QTc118zB4
   n9TDthzxsmSxDYWPS46u1lv+am2S/TM8G86PCdeWMrBpWBOHXrjufpPQ3
   +Tz1bd3UYjyds5+nBD7Kwi9aqNkREeOZ2uTWmwO1Z1FT1NUWbY6r/w9Nn
   mmllIrFlDmobhiEcudQl2YNimNCEGsLBP5Vzv/bZ7JZ8g4qNrtfPgN2cr
   Dj5TvHNAMbP/uq+0qEPM+h85mnOEfJYTyYhTKTjZgMEOx4lYd/ocReFX/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="340876128"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="340876128"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:30:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="829927316"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="829927316"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 04 Apr 2023 03:30:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:30:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:30:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 03:30:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 03:30:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwGSgtt1Hc4Y1MbTIqkj+cgEVsBqibA4iUxaFu3HAMqSOIrfLIti0R92D0eLaaCIfPIJexPz/gOhNDyhchkwmqRRWzb4wP97lHY1ckTy6fQxtV1pqNXIjQfiEPsmPnvjPQc+oiOu6fA4pzT10CRk4rbkVeYUG42hB+KQPLrdeM2EL5Pc1k7rBkqmSV6ZIFlGw+eVXf/dMnXkzAApiBPif+SRLI5I32DuZZUCmB07fXWhwQoApdol4VbxJ2kypcooC2gbz2iix7a9ioRRopQoPkcsk9EosVQgBvjOgXSCm8y7n2LZVm51c3HxyuTniGHVCloS5zy7uS59o2BN7cXtAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UGrKZ1gMtwy8Wg1S7zWGvZASNVuGx/hADMc2L3G+ps=;
 b=ODmJ96xR+8qUV2ZjiitBbkt8GeX2NwOeWap3PhT5vLPXhER++2oGB7x5yi8PfawPUDblUhLHhUCIFpa6gDuXZ2ByiYd1CRhIbY6+jo1VkU/0NK+qlBGgc7r4tMn2Y3X3ET8VfYuZ132I0FbOtIx0I8ZgkumQQrGBMLQ3wloN4MTYnUeoegyDFQTjUSs9fxfonAtvj7KI/ano6vr17RpnvvJl8hBvL+U1bFzXBf+90pHvBB/+CgMnBWlr0xJTv4REl94uJ3yGZ6ntfWtOQTRXbciRbNpHbCsgEtnl91Q4ey9RShcxCXBO2lHqMLbs/cjF+/KZwihMENtLSNpvBNC+WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB6790.namprd11.prod.outlook.com (2603:10b6:a03:483::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Tue, 4 Apr
 2023 10:30:47 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:30:46 +0000
Message-ID: <43a33d1a-3b04-86a1-b538-d906b517b7d0@intel.com>
Date:   Tue, 4 Apr 2023 12:30:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 4/4] ice: use src VSI
 instead of src MAC in slow-path
Content-Language: en-US
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>
References: <20230404072833.3676891-1-michal.swiatkowski@linux.intel.com>
 <20230404072833.3676891-5-michal.swiatkowski@linux.intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230404072833.3676891-5-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: d2650927-f70d-447a-2d47-08db34f7a6e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaBIYRWtyfE7h3TH4hHhwyqODK4TOKWKEmS3kDesktUp1wyfOPTUoZW/p0zqpKi1ht5JLH1BDnxc0JW95d9pM7S5mPj+dr6AzuYy1bvQmv91BVUl+1sTlZaSo5CFcYwT4fJ1MYPVi0OlDjC5FxVShxRkb1TfRZJwIQZ+J86P5hyi26rJU7U1JT/TKJa+dR7VaUlJnf0e+iHf7TeWHasYCrdv+w30ZgNqjnpy/X2+k6TtrhFLogUR/UJPKB3xCuMSNDpY+OGNLfxWkNTv9hJNO7C7eAuEKveSE97g3n9EtD/hrJBDK1IUIo0atV8yKeFIbiUlJc/DxXR8H/MzhxNh9vwaGMbnw2nBEWTbzsFvVXpSR7j4rznqSml4+L/BLGBRQ57QE6W/l40wycrjqkXHfbdDqZwRmrYcNAHtgRznvKDfrT/lbZR3weizbitSJw0EJC7aEX4KB4qfftLG+egfVaEfZLt8bYAix2taNOLVrxA88QcAii3uEARAWREQxltwvuPhG6+bMgurQn+cwhWnCK3fYV2A+fVVP8BpFT+dSfvykRmV85bP0FWo8U+2yBWTmPKe6sdB3JhPzWEHITvaNgL1Hc7QsZgByW0r1HGkfRwXGXVsOZJMimjgPXOEaV5JYAFcoTxzLUgXzDYphClh9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199021)(86362001)(31696002)(36756003)(2906002)(31686004)(2616005)(6486002)(186003)(26005)(6506007)(6666004)(6512007)(4326008)(316002)(66556008)(66946007)(8676002)(478600001)(66476007)(6916009)(41300700001)(38100700002)(5660300002)(82960400001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OW5nZUpZOFI0VTNmQWloVHZrdkNONjhidDI2cE9jeEk1T1hJK01LZHp0cEd5?=
 =?utf-8?B?VElFTGNtNlVUdE5nVVVaelBtRnl5TEJWd1R4TUxXZStZWnFiYUxiVnB2S1hD?=
 =?utf-8?B?Z21DUkJzWTR2UWJGdTdtRDJiaFg1SVNMdFloVzM5MFJ3ei9xTkp6MWtTK1Bl?=
 =?utf-8?B?ODhzU09HUkR3U1NVRXkvTWhFeStoUzk3c0crYXRzbDdaRi9RdzVIQjh4VDhP?=
 =?utf-8?B?TVRHV3oyRUhCUUlGZHBnUzNOdlR1MHpmeGx0TW52OTh2cHQyeHhWQlQrbGxI?=
 =?utf-8?B?SkttcUtiVXd6MWN5QTF5YTdEcHJXa3JoTkxRQnNsN3hIV3FUUXJHeCtYS2FO?=
 =?utf-8?B?Q21vMGtLY2NvRFhRTzNOTDAyZEtKeGk4eUhzcGtZVVpYZ25wOHJ2WEl4ZjRy?=
 =?utf-8?B?UCszWWpyRlNCY2thVVEwQzdaZlhBeDFvRVp6OEFOdXNVNWZ5akVodGdOcm1H?=
 =?utf-8?B?K1A3RDRkY1NzdXVPYWdNMGZEamY1QlVxekRkbEMzTXBqUTBXUHJhWWR3K29u?=
 =?utf-8?B?UkI1UERpQ0VTcFZURmlkK2lTbCt3cVRCdEFmMm52ZThGVFFxWXQrMS9ZK3BE?=
 =?utf-8?B?WHdkRDd4NTdHalJqYVpEbFNFVEt6YTVRU0lLU1hPQzFMekZYOU9TQVNNRkly?=
 =?utf-8?B?Zm1SVjRsSnRyTjdIWWVqRlJnbFErYkErZE5sZjEzbm9HSmN3UG13Y1JES0l2?=
 =?utf-8?B?NGNYdmFEREpTb2NGajFIbE02TG53MkhaU1FUQkd4T0NNcjg3TVEyTzZqSm92?=
 =?utf-8?B?cHpGRXJ3S25uOWNGVEhuT0RSK1N3cU1NY055UXZVMTY2RUE2QTIrVVhQR2xi?=
 =?utf-8?B?a1hOaTUrQ05JT25FSkxCZ084SC9zL2RUQzc0WWx5VWR6clczRjVGT2hrRkZw?=
 =?utf-8?B?R3AxUG54VkltSThMNHM0WHFKM3FwNWUrZTlxNHNTeCs5VmFRRk83MkVUKzFV?=
 =?utf-8?B?SzhlSEdhb2VYV0J6TE5YaHhOUXVHdzVQNVM5WVdUckFiMG9XMzhRWWRuYUtx?=
 =?utf-8?B?N2o3TTl0U01ZdFZWNzFaVkQrbFpqK3hINmZ2SmVMOENXY0hSdnV6Tm5PL2x4?=
 =?utf-8?B?NU1KRnc5TG82NVJyVExHMDN1MC9sOXRKMlpUbXJQK3JseHJORXB4aGhOam5W?=
 =?utf-8?B?N2F1S3l1NWpCc0pxSmxwNWpqMUFFN3QrYk55RlJSTDF1QXVyYlNBVXpBM2dR?=
 =?utf-8?B?amh5Mjl6RkFqbWlvWUVBcEZZejVWanE0VzRzNHdXamR5L0FjZ1NWOWJPSFdr?=
 =?utf-8?B?YnRCZjgvRWdqcDVTYnhmQWF3TGdzcFpYeU0yLzhxd3ZrVDRrSFQ0ZW5tWlNR?=
 =?utf-8?B?NFUvUzVlN2ZsL1RtSjZhNFpyUlBSTW9ubHNBV0tMVG5EZUplSDNtSGhpZU9B?=
 =?utf-8?B?a0pXeVBTU1NQMlRSSTdqdlFxa1JRWE1aZlVhall2MzFRMldidzZGeURkbExk?=
 =?utf-8?B?L0VRaVc3bHVmWkdhei9zNFVKTXZYUTd4QkY3Q3pCcXpQSVFIWlJ0Y0Y1ZHJs?=
 =?utf-8?B?eVpsSXVBZTdOZ3R6TjRXTGY3c3l3U0YrWjVRd2pWMHRmKy9KemRMcjVzZGlU?=
 =?utf-8?B?UlhLaDlodWRtdmJUcFJNMURrY3VCVnlvRStFd01SZFhLZ0E3QXVkdEFQK2hU?=
 =?utf-8?B?YmdoUFlTaDY4UFAzbXdRMW81c0NBaDdhQ2RVVFNDWmhqRXc3MFF0a2RveWpr?=
 =?utf-8?B?YVRmS2lWRE85OEZZWVFxTG1CYzJwbDI4c05rVDg0QytmcjBvSERCaUxQLzhs?=
 =?utf-8?B?eU82T0RrdDJ2akdCaWpYVTVRTkp0dmVMVjMzbnBLb1NWelNDR2V0SExoRkhS?=
 =?utf-8?B?TVJYNkRFNCtteEd2ZlBsWXZlSi9yWWdBeEo0UVlHTXlDeFFtanI1VFpxWnJj?=
 =?utf-8?B?dzJQVkdLSGwyeFVDVXQwcC9xTERaamJpV1dWdHlFT2Vhb09vZWp5b2s5R2VB?=
 =?utf-8?B?cU41L3VjcVpyV0tFSCsxY3VQc0EwMmM4SXhPV2FnZ2d5bnc2WXVVOTlRdXkx?=
 =?utf-8?B?VDdMbmZNL1FKOE1JSUY1UVJOZFZNTHhQeTVFT0tZUHlPVlRsVTc4cHdGakNN?=
 =?utf-8?B?R0Vzc2ZBdnhQQnljV09FYnlvNlhFR3lxdVlKYTVpN0YrOXF3WU13cUtDR1Nz?=
 =?utf-8?B?SHBPTmtFeDQxdkxubTEydzJkYlZzOUFnNytkdlgxN2JpbHdHUzBsTC8vQ1JJ?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2650927-f70d-447a-2d47-08db34f7a6e3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 10:30:46.7155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GopQIw5Da+rXHup91aFWv3IyWN0g1CWhLrB77Adesvq62+Bs9mZzj3+3WQKY1Ytj89QPmwp6OlKDpLwkMxFjOUqJA2SgHmsBhYB9r36GcLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6790
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Date: Tue,  4 Apr 2023 09:28:33 +0200

> The use of a source  MAC to direct packets from the VF to the
> corresponding port representor is only ok if there is only one
> MAC on a VF. To support this functionality when the number
> of MACs on a VF is greater, it is necessary to match a source
> VSI instead of a source MAC.

[...]

> @@ -32,11 +31,9 @@
>  	if·(!list)
>  		return·-ENOMEM;
>
> -	list[0].type·=·ICE_MAC_OFOS;
> -	ether_addr_copy(list[0].h_u.eth_hdr.src_addr,·mac);
> -	eth_broadcast_addr(list[0].m_u.eth_hdr.src_addr);
> +	ice_rule_add_src_vsi_metadata(&list[0]);

&list[0] == list.

> -	rule_info.sw_act.flag·|=·ICE_FLTR_TX;
> +	rule_info.sw_act.flag·=·ICE_FLTR_TX;
>  	rule_info.sw_act.vsi_handle·=·ctrl_vsi->idx;

[...]

> @@ -269,10 +235,18 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
>  			goto err;
>  		}
>  
> +		if (ice_eswitch_add_vf_sp_rule(pf, vf)) {
> +			ice_fltr_add_mac_and_broadcast(vsi,
> +						       vf->hw_lan_addr,

Fits into the previous line :p

> +						       ICE_FWD_TO_VSI);
> +			goto err;
> +		}
> +

[...]

> diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> index ed0ab8177c61..664e2f45e249 100644
> --- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> +++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> @@ -256,7 +256,9 @@ struct ice_nvgre_hdr {
>   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   *
>   * Source VSI = Source VSI of packet loopbacked in switch (for egress) (10b).
> - *
> + */
> +#define ICE_MDID_SOURCE_VSI_MASK 0x3ff

GENMASK()?

> +/*

A newline before this line maybe to improve readability a bit?

>   * MDID 20
>   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   * |A|B|C|D|E|F|R|R|G|H|I|J|K|L|M|N|

[...]

> --- a/drivers/net/ethernet/intel/ice/ice_repr.h
> +++ b/drivers/net/ethernet/intel/ice/ice_repr.h
> @@ -13,9 +13,8 @@ struct ice_repr {
>  	struct net_device *netdev;
>  	struct metadata_dst *dst;
>  #ifdef CONFIG_ICE_SWITCHDEV
> -	/* info about slow path MAC rule  */
> -	struct ice_rule_query_data *mac_rule;
> -	u8 rule_added;
> +	/* info about slow path rule  */

Two spaces after 'rule' here :s

> +	struct ice_rule_query_data sp_rule;
>  #endif
>  };
[...]

Thanks,
Olek
