Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB7867132B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 06:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjARFZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 00:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjARFYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 00:24:46 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB954FAFC;
        Tue, 17 Jan 2023 21:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674019485; x=1705555485;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AlFYMrpC0cOeHaIrYAP8ryh5r70Bse28v4q4YDAHgNs=;
  b=ZLpKG2YMHrlb7N4E8i8K5D9CXzCJglC1qsSiXApWgHrMKh1FXKPDN+DZ
   RSSTJ0leWUV/yunZYakFfhJD9LVs+p7ks++dkYAhsEt8aXR/wRplg2Q9S
   VEiGycsrArkqep0oNWLYcnU9iJZajOznaWkXBiuX9S+CezQczwMUXmpaj
   lKyzPHNtqZ1hk+nNyzAoyxOYH70JuCuIh65WD3SWopUfHjetRoOH3Jw54
   50rkPVky9lDXGg4B29UDq7DNWEUM40era2qUwMbKXO7tNMXrSMeyPdjyO
   JOiKMvDcJ5Bl735TQDZh1SzO5K2VNmrwyo3F+6bqC9wJ6iNYB/esLR1Kk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="324954155"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="324954155"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 21:24:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="728042374"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="728042374"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jan 2023 21:24:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 21:24:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 21:24:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 21:24:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K385pAgvTl9+FdlKWU2TNOVwdu+I7wTqzvFw9c1KDBJj9Q0JiqEsF89AJ0O+WVub72q/k9IMHWY9NnduwcWUq2cDXej+jjH/O3WJ1ashrIxeX5q4IQ+2WSB1UKDNIH465Q1G5U28mHqcOA3qm0uwdIwpVH9Up3XJ1HrTS5hXFIW4bytqVp4cJXkHCOWm5iTvw0f5G6pod/D1TdJ2e3UZtrOs/PwReePelKzg08IJWA/j3FgAh5vvCg9z6zfZJB6F3FDPLoTmk5Qf2oxk7jLlYUv3J8O3nunua0p9+P7VUBTkwPY4XCkcUe29iHhIqFRRbFtzh4rbf7QudNQHw0lyPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lz/yIifC5vxcASynZA/h45jQOAfDJWmXKnwlcHPTMas=;
 b=BeMvx0pd66F/Y4O7fYgbocU8yFe8v83B3T8JC2fEFAC8PKb79uYOqch9aUeuCQyB7htcd1rDo1CZCtvaSIA4Wzrq5ey5TfLgRgiVFT5jPh1UXM8ej3Mz+exi49/40eeT7NStG12EShnQYJ70GAGHN4WwCbTG0iGD0QTIrU8xjq4jYldyTpUhE/Sgf4pMtJwNIsXLwsJEWsgMi1o5ZT3FtYfWkxIcUgLa9NGfjjxZzfW5nXE6c9uffXTbvobnqC3Fi4UGIvOPzZ6piAnE+DrKqaPHg+MM5P7ObEwMA0K5kcukyU1PNCiTor4cIyFnLMQO1IDkPUSC6Va9f4EeqSgo0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6738.namprd11.prod.outlook.com (2603:10b6:303:20c::13)
 by SJ0PR11MB5679.namprd11.prod.outlook.com (2603:10b6:a03:303::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 05:24:40 +0000
Received: from MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb]) by MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::7c7c:f50a:e5bc:2bfb%4]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 05:24:40 +0000
Message-ID: <d1088f1a-d9d2-68c9-ca2f-cf314f057aba@intel.com>
Date:   Wed, 18 Jan 2023 07:24:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH] igc: return an error if the mac type is
 unknown in igc_ptp_systim_to_hwtstamp()
Content-Language: en-US
To:     Tom Rix <trix@redhat.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <vinicius.gomes@intel.com>,
        <jeffrey.t.kirsher@intel.com>
CC:     <netdev@vger.kernel.org>, <llvm@lists.linux.dev>,
        <intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230114140412.3975245-1-trix@redhat.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <20230114140412.3975245-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::13) To MW4PR11MB6738.namprd11.prod.outlook.com
 (2603:10b6:303:20c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6738:EE_|SJ0PR11MB5679:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f31502-fabd-412c-e68a-08daf9144c1c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0FF0CK/ksSM2WiaK1UI+Fd0VTwFcp5tNG208uzDyhc9YtyG6ghK1Vz8m6c8gM2eBzqu5Me6nZBFvYVrJvPfEeJQM/uOFxOzWepte+/qOLyRt8EzN8evM3nPbpLiR+ID3FSlpQZ+y98//9nkRONmAdQn9g0pStSvtm2VExWqAmU4NlUf7ayn3Ay2MIQKQLUX3Nt+fWJDEIS3ob5iBQV6MrPTSFXUI1rgS3h9sMjCU5SOoBtAbD1qSUQxzcu1ZVci7bJ0LzxP2QK9ke872L0YHhC71a7nU6gVSAgy34AsuoAlWUUXE3P+hwYpYHEPnQz///0YTB0FC88pg5mayWunotQuae/4YiLCA8kSaa9q4QCU8ZKMFM5Ybj2qnd6ReNRLHeZ1Z1EJEh+D0yaNfZRh7Ty1RLh6QYXgQv22AWWi2M7YJDM5gk6ywIQZZsOL6Uq46v/IjFHU0ilMbt8W8gZTbA/ufVpa7fHZT2pRjqBsmOiDjeQ68KvfvXHaP20k5kaZCkJ7pOgkkMRVIO2QRwvN2/CwDqVWcCmYue8wmwv3MhiURvS/ciGeVcVJLJXXiWXWwgjSGNKFXnQdOsjv2hiWDOd9mRaRaEJp80ewehgRVArJ2rqMrWImyqwwjDgusLQYfnSzFIsGtTl5kix8Vp+pi7FxDOCm+pTr5XvZ+ORy6ztwwR2GKRhn5Eh5riqX2iPq029VsPVgH3vO9NSQGkv2ngSDvS6nibXWehiQbzzX4qB1VTTj2AsZoqbArgs3pIHCD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6738.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(31686004)(86362001)(921005)(2906002)(7416002)(66946007)(66556008)(5660300002)(8936002)(66476007)(82960400001)(31696002)(38100700002)(316002)(6636002)(6666004)(53546011)(6486002)(6506007)(478600001)(36756003)(41300700001)(8676002)(4326008)(186003)(6512007)(83380400001)(26005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTM0TUVDRWlFd0srYXBUMlZvS0ptdTFxZUszVFZoaVlKNTllUmdKNHpWTnZm?=
 =?utf-8?B?cFl5bkF6S2FLdThTdWhDL3Y1QnA4Z0RjMEI4U3QyYmtwZUs0S0Q1ZjJaRk85?=
 =?utf-8?B?VmVqa09tKzFOd1UwTE41ZTFIZW1ITGNoeWxPMkJ6UHlrc0MrMmdJZVd1YWZ3?=
 =?utf-8?B?NUI0dlVQcW5VSHg0MFBmKzM3Vjh1Z2JJMGUyNGltLzBEbDNEN0pLVVMrd04v?=
 =?utf-8?B?T3dSeUN1QlRTTi91dXFTRzA4TTVPNFZRMHFOaHhUdVJhaTJtdmtWRGZUVWZJ?=
 =?utf-8?B?elMvWmV6cjYwNEJYVjU2T2hBRnpuZDg0SzVoU2lSMThzS3RiMEVhTmdrNWJy?=
 =?utf-8?B?OVVWMlNHQzJjeGNQVldYLzd4Nzd6MjV2RklyVXhzcEx1UC9TdHdoSGxKOUg0?=
 =?utf-8?B?RDh6VFppdytOTjZ4cUV1Ung5cFdscWo3cE55REF0WlBXWnZCR1RmS3pKM1Vn?=
 =?utf-8?B?Y21IUTdiRWhGSzhyZnVLcmNHVkluUXd6a3o5NWRqK0xOMG9ubVBlOW9WT1hV?=
 =?utf-8?B?bjl2WjdyUFpNNmV2R1hRRDVmbGJranZzSU1vcnBKaDhpSU5kdUxqaEl5QXBB?=
 =?utf-8?B?ZU9CVlhxbDQ0c2c0MlRMZk5xa0dVcjU5U2h0YUp5SFNzczcxNm9XWUkzT3kx?=
 =?utf-8?B?VkpWaUxSNEh1bXA1YkNwSE5xUmxjc2xpUGI1YjczWW5CVWI5ZW1mdnR1VDAr?=
 =?utf-8?B?d0FWSFJXc2tyWVNaRVBPR00vQTJzaElTZ2phNU1MSHlQY29sRVRTenoyQ3Yr?=
 =?utf-8?B?TlloeTBtMXI5ck9JUzBoRGx5TTRFMW0rVEhNREo4TWJOeGhEK0RYVlVMbjFH?=
 =?utf-8?B?S3pQaVRnYVhHQUhrSVNvQkVqSkFPeXZEU0lUSHJxbVhEcjNMM21Va1JsMXli?=
 =?utf-8?B?aVp3ZDJGbHNZY0lPaHU0YXQzaFNvbnh2OVc1NmJIMFJ0SDBjVUpkekRpc2JE?=
 =?utf-8?B?Y2t1SGhqRkNVb081cjV1SDJDMnJ3cVFTQTBQUXF1QzNTZFhvYjVzc20vRnYr?=
 =?utf-8?B?SWtQZFRxcUt6L2JsUkl2RGRvOWpKaGtTQmRDdWtkUDg2Mnk0NWZmSlpmWCsw?=
 =?utf-8?B?cXdhZk5GTnhWSTJLSkhzTUtmMlkwR2Nhb1NBZUUySzBBaW9FNjUvcFVzM1RV?=
 =?utf-8?B?NGhMWGVJT1FnRU92NFZXdXdoRmNQMWg4elVjWW54YS85NkpKRVVGWVJzcUxO?=
 =?utf-8?B?UWwvbDloVzZwRXZIY0pOSUFxY01pOUlWRE9GUE95cmE0d09vb2pWM1BCb3V2?=
 =?utf-8?B?V1Q4NHZnYnFoZzFUVFR1ZGh5MjNGMEkwTHBnTDhscC8vakZyWWxBMmVGY1Rq?=
 =?utf-8?B?VjZzRnlucmt3cjlCbXo1Z0JzMWFYVUk1UDlVYWZhbTcvL1BsclZjQWVhcnN2?=
 =?utf-8?B?TkxGZWgwTHl1LzFiY3hESmVwbzA2K0V1QW9GNncxNzVFZ0Q4UmlSWTdmWjMy?=
 =?utf-8?B?ZDBpRGRzWnJSalhXNWdvNlRxUGlXbDVkcXNHRERhVFRESVNrbEdOSWFWKy9m?=
 =?utf-8?B?VEQyUnMrYTZXOE11WEp1MTJLeWJCUXhRWk1XTVoydzk0VU5WM0pQZGFDekI5?=
 =?utf-8?B?TjZ6bkc2S3V4SEZhU0RsdEJRMnVxenBPV2lGdFh5c2RSQTR4R1VXdE43Ym8v?=
 =?utf-8?B?Rml5ejZVVXYyYkpUYU5lRmVBcGJNUnFwdk1Ha1lPMXBvYXU3ZWZqMFJ4SWlS?=
 =?utf-8?B?WHZ0Um80QjdCalRWbFZ4eGl3VTBZTEJXYjR0dWdndWVXYUo5TWNQWit4QTJI?=
 =?utf-8?B?bFlWNGtybUpjMXpxUDRBT2VscGV4RmJpazluOWhJNE1HdDFYbGxtdnVYRytV?=
 =?utf-8?B?OUc0cmdWVU1pQlYvc1lKamw3ejFEZ3NNVmZNSWNTbmFQL0IramVGT01vK0R4?=
 =?utf-8?B?M2k0YW1CN0xRdExDbmdJU01jSTQvdFpvQm9MM1laOEorN0o5Z2VrNU9kM25w?=
 =?utf-8?B?SGZXalJPSnJrbC9kTmpPRFZxcC9XYUFWRk42enFweFJOWjBlZWdyUlhlY1E3?=
 =?utf-8?B?ck5XNmplWVYyemxLb3VTakFBckszNklZK2ptNlBkbWdnRGR3emdjRTcvTHFW?=
 =?utf-8?B?b012dFhoVnpMUTNFeUhZS0h2T09HakFEazhrTlFZRlVnUlU3RlNnSHRxWHFw?=
 =?utf-8?B?dWNIM3pTcFRRSXBJWlUxcUZBaW8ycUtuVnRybit0VGN4OFc1Q2xlcXMvVlNx?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f31502-fabd-412c-e68a-08daf9144c1c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6738.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 05:24:40.1424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sL1+6TWbV6EjtqHmFvFAILHdyWdLAOopSvmUAlfHOm9kGws4ULZz0Wn4mEGNyyzc9QqEUhVqnSR0BlU8bDnTEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5679
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/2023 16:04, Tom Rix wrote:
> clang static analysis reports
> drivers/net/ethernet/intel/igc/igc_ptp.c:673:3: warning: The left operand of
>    '+' is a garbage value [core.UndefinedBinaryOperatorResult]
>     ktime_add_ns(shhwtstamps.hwtstamp, adjust);
>     ^            ~~~~~~~~~~~~~~~~~~~~
> 
> igc_ptp_systim_to_hwtstamp() silently returns without setting the hwtstamp
> if the mac type is unknown.  This should be treated as an error.
> 
> Fixes: 81b055205e8b ("igc: Add support for RX timestamping")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_ptp.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
> index c34734d432e0..4e10ced736db 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ptp.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
> @@ -417,10 +417,12 @@ static int igc_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
>    *
>    * We need to convert the system time value stored in the RX/TXSTMP registers
>    * into a hwtstamp which can be used by the upper level timestamping functions.
> + *
> + * Returns 0 on success.
>    **/
> -static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
> -				       struct skb_shared_hwtstamps *hwtstamps,
> -				       u64 systim)
> +static int igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
> +				      struct skb_shared_hwtstamps *hwtstamps,
> +				      u64 systim)
>   {
>   	switch (adapter->hw.mac.type) {
>   	case igc_i225:
> @@ -430,8 +432,9 @@ static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
>   						systim & 0xFFFFFFFF);
>   		break;
>   	default:
> -		break;
> +		return -EINVAL;
>   	}
> +	return 0;
>   }
>   
>   /**
> @@ -652,7 +655,8 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
>   
>   	regval = rd32(IGC_TXSTMPL);
>   	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
> -	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
> +	if (igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval))
> +		return;
>   
>   	switch (adapter->link_speed) {
>   	case SPEED_10:
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
