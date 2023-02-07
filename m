Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DFB68E0CE
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjBGTDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjBGTDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:03:36 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ECA10E1;
        Tue,  7 Feb 2023 11:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675796615; x=1707332615;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wfLJIYA0GXHdJKIRAqNVIFF3QdebguN9+eJ59bnFTmI=;
  b=IGbFNUn8WlxMW4OpFKW2QlvKT2U5HTxIkCt04sX2KVZQyvBVRycgsz+D
   16dkn/pJ/+dXMMgI/O58lbFXpuVKdvryMIhsn/MlU+A2ehRpxgZo3c1MF
   gZvPCGaAAdhAb+r6Pa90QSF338bw4/5i//dRPNJSpGH2LFNZWEcxecm5U
   5JwAfDLUsB08MUYhjFsdJMBO6MauUTL6/UyPHpWzINH7v3JMiTYKJrHMf
   Hd7j3Kq1o713JBJ90BsqeuEftbK8TxElyECaLJyZsO/fa8uUl3pkj+NuC
   hLk6UV+rcBcQToSeN/kuonwjbgvsnXfL30CZ8p8kyN3iqoBlK3mIisEkM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="415819452"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="415819452"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:03:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="755730538"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="755730538"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2023 11:03:34 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 11:03:34 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 11:03:34 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 11:03:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gba8Rsfbjq77IEQt4VBu+0g978rj2fzcDQ9Tp4eDqo9jnqQj3gdTTXZ4BiUm3u2vEwndOSZWlXb2Cm93FwQZ3U9QSMLL7Oh6hRkLvwP8NoIJCpFjmfH9shM0GrqIfa1cPUhu86lonnixyJcdFFfkqVJ+QlkLUqiZxVHL+Ps3caw+QgRgiRaF8d0/FTj0eDPg3v+KqAP4g83AlLUl7HBdxo1za5II+iIIM8cPtvKz6Ib0XBh7uxd8spyFJw7lCd2GenucR7uPTV9+JmVl13fKhJoNB/d8JvUNkP12kzmriG4RhmmybbkeY5M+Y87TbR7M2dq3MW0W7iEDAAHzJEgwSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUhYniJEQRQCDPqV7kuNkPRdfvjIFTVmrwMbJB0qjmI=;
 b=jwbudgNetInhFsHBne/dGXxbwN51LxDPl6wGXVzefQDz5IfcyFmffUxmAHGsb/en6WqIx4bz9b4vRP3BzAGv75dKvQiJXNNDVP6ULWFWDMbFqhL4ogmHreIZ3tnmQ0pN45YlED2IU6AX7XRvFTLxuvext4nG2iB6D/V9P7qC5cslU8I4M8lYDtks/bVi74Bd/xDGMqIAi6QkSusjveM/b/BIfOZuf49vZq1G4y0oUfQNQ3QMbDCNnGd212CuHpTWQ2yQm2mu7qI8Xd34k/mTUujMMqndjGWEhhBqoLjKXlrs8ACzcWEyTNwrdO6sCttw81U3VqBOwWR4oVGdZnoyeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 19:03:28 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6064.032; Tue, 7 Feb 2023
 19:03:28 +0000
Message-ID: <a8677175-0d4f-af01-23d4-ad014697bee7@intel.com>
Date:   Tue, 7 Feb 2023 11:03:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 2/3] i40e: add double of VLAN header when computing
 the max MTU
Content-Language: en-US
To:     Jason Xing <kerneljasonxing@gmail.com>,
        <jesse.brandeburg@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <alexandr.lobakin@intel.com>,
        <maciej.fijalkowski@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        Jason Xing <kernelxing@tencent.com>
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
 <20230204133535.99921-3-kerneljasonxing@gmail.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230204133535.99921-3-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0070.namprd08.prod.outlook.com
 (2603:10b6:a03:117::47) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SA1PR11MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: c58080a4-06eb-47cc-19e6-08db093dfedf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQ/s/f4rgWt5lFvE3TPwdZ+CQRUwDe+eGz6lwuSJpjyQiohe/pGVs9MagD8EzUEwJzn68BR/SVmVO3SvaIKMkMmJbZSIjCkVm/R3fURL0NnhW8gApZEcWU0eqBMw4LDfgBMnDbxJ+ebfp1+LQc06cgsZZlY2x64rOdbFnaWC5zjKRdOk2HESNfLxLCFgfQvOdFbDDOOyGnnrMSENxJoMHpd7/eu1RidaKJ7fcVmc+Qbsd9FjFajcBB7AfI5TaNIKxjRDHmb1yllEHkrRDyxWvKF5B3XAelP0nvw17fwwt66OgsylkVVb3qRuNkBN5mtMudnq5WOL0TGhOOfhR326HwKTdHWcp/EKPKduwgVHsGI4vYI6USWVkfTABwM3yjgqhrxRPdOWP2BopYZwgjdXeFNKDrdcuNY8xXPlcsbTAhwAUyhME8RQHZG1OwmDy9nCMWwmiWJngn/liDiVopDc1ePKfNKqKurOninvEiJf/MIWWCT9SZIxL2Cmt6uOeQ/NudLKYyEbE9eNXwTpTvHjGRvVWjIXMoPYXv1tkUWxCnEJwYlZiyKqhn65wpT5eXyt/QDs7eqdmd1LxuMVh+iwoCzrk84HP39XvHxpy/vEn9YOOdBG1YNg7GAkQMtCD/vcSVH8xU9Qd3+ONKtsIIyT7H2/UoI81DZ4T6kMY7GHvdXdIhYdJSKJTB4oZnmM2LbdBJJ7fodN0u5Ys3gRbk/Zkc96ej0ZSQ1l0+5rwK4PNEAq47Ami3X2bdNLvk8mRC2NrknZ/nq1g+KoHN5FmlDzpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199018)(7416002)(2906002)(36756003)(82960400001)(53546011)(83380400001)(186003)(38100700002)(6512007)(6506007)(26005)(66476007)(66556008)(66946007)(41300700001)(4326008)(2616005)(921005)(316002)(31696002)(86362001)(8676002)(8936002)(5660300002)(6666004)(6636002)(6486002)(966005)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjFOS1BCc29HZmhBSUdXWWlFZWJTRytadWEybnBhRjdDalZrZWV3L001ZE11?=
 =?utf-8?B?Ty81QnBYVWZpYWw4UTBpMVpHV0ZXdGhJVG11b2FPRFdSMkJzSlNKRGxBYzF1?=
 =?utf-8?B?UE9yYy91ZTdLL1h5RDdEbHdOdzhEVDJrMjB4VzNMQS9FKzZuZC9rQktocEZp?=
 =?utf-8?B?Ui82MHR0N09mZUpGUUdQTUJ6VGhOWFozV0JUa2pPbVhkdWpFY2M5cEN5V1do?=
 =?utf-8?B?cDRhS205U2ZsMkNPeUVWTDRxZjRQRDVyamxlVG1GNnVGaTBjTDBTQ1NzcXdN?=
 =?utf-8?B?SHlXWnNhTThJN2lnR2JhSFdjV2haWkYvbXVoTFNaS1daUE4vcG80amJTZ1pz?=
 =?utf-8?B?N01SUDFOL0pSRVdOcElxTkhIM1lRSWhaYzBOY0xxSEhKdW1ObTdMNlhqZk1S?=
 =?utf-8?B?T2pGeFhpNzBCamFFenErbW9jeEVudEFZV0NMYWVYcnU5Y001N2hVNXBtT0ly?=
 =?utf-8?B?djd6N3lJZmp6ZFpXRDdQc0pocmptejh5NFFlWHc4dGNZUTV6TVhNZnRQUmVO?=
 =?utf-8?B?d2txOVFVWDRYREdPR0dGd3MxZlVSWS9jbTJoV2h1c05mczd4eDcvVHNuRnhm?=
 =?utf-8?B?M3M1eCttZVdvUFNrOEViNWRVYlVsK3RKUjZvTlVzL3JoVnhUcEdrcFU2YmV0?=
 =?utf-8?B?TTdUL2ZLc3pVaWNUV21TUFFHUXRhcW9EYkRmcG9Dbzd0dzBRSDlEY0NHNlho?=
 =?utf-8?B?UmR2MU5aOGpZdzA3WXVFaXVROGxTRm1aQmhkd0dEVWtUcXNRVXlCMGJrMkhT?=
 =?utf-8?B?R05DM1FFdUwzaWtIeEdsRUdqaWpKQTI3YjQwU3Nsd1RRSTFNaGExVnp0empl?=
 =?utf-8?B?WGNtUS9yVUFKQWhqS01VbmNGZXh5VFhNdXlUM3JjUGEzaTYzRytsNU05SUdB?=
 =?utf-8?B?SlEwdDNqZlRtUTJHaWdmQWVQMC9pNjJuaGhLbGNXcklqbUZ5cmZQc1M2dGk2?=
 =?utf-8?B?ek1rOFNmanptUjBpdkN6cGJQdGZkcUsyMkZzL3lFWVZ4WXQ3RlFOT3M3L1I4?=
 =?utf-8?B?cWE5RHNYL25WZlBaT0RKQnpWWVRab01ibjg1N0R5c1NlWGhTOEpKR09XbitE?=
 =?utf-8?B?SzN5VHRNUkxOVnZGR2RrYy9VUXFmMlBaTmxaZWhIUnRWUzN5L1R0WFFBaW5s?=
 =?utf-8?B?QUt6Qk1zWkJjUEdIZHF4eUV1M1R6cmtERitvejhkOVJNNSswbXdVeVhQNWg1?=
 =?utf-8?B?WjkrSjBpRzYrd2RhSGxoai94eXRwVk1CNm1PVUloekxMb1g4NThPOUV5VDhU?=
 =?utf-8?B?bjMwZ1QwWWNmSzVTS2hwNUJnNWpyVWtldzhkQXJnNG5hb3RkejBRMWE3NE1I?=
 =?utf-8?B?VmtuWXc3bURqMVRXK0kwM2pGU3BwcW9wZXU3emZ2NFViaEh1MWdPYU1BOUdz?=
 =?utf-8?B?SHhocWxCVVR6b08wZ21RN2k0TGhoWXZuNnY1TjdJUkg1QVhzS1RQc1ZZd2NB?=
 =?utf-8?B?emZJVWZjak9QMVZ2Q3ZqUXUwTGhnSGNjUGtjcGxNaFdoeHppQnBLb3BBN2V3?=
 =?utf-8?B?UW8zSmZWTmJvTG5VWTRYcWNrNWNQTWg3ektpV3czaFR5U2twcnRMbHRoQ1dR?=
 =?utf-8?B?N3pOT1NsVUhSUWE2akFVQyt1K3pjbHdaNjR0ZjNBeDU5Q3NPcTVjdThkOWdz?=
 =?utf-8?B?byt5VkZHMHIzUGhzamJuSytuNkZBTlNFYjlreHZodTFyUVFMR1lsY0FJVGtX?=
 =?utf-8?B?VDNTeWZZMy8xLzVhenJZNDF6WjdIVE5lN3ptdTJTYzZIeFBkWHpEcUFMN0lC?=
 =?utf-8?B?QVJCSHFxTXBSOEo4bnZrK2EwL0dwVTBqRGRoUDJoK2hYWHdFYXF6YkZjZkdL?=
 =?utf-8?B?WDhzeWI5dmJZL2pFcjIvOWU0b2lKMVJSSWVCNm9TcFZ0UmV4VEdYalpkN2I0?=
 =?utf-8?B?Slk4bWFsdkxiekxYRFpVOExaRXkxd0dXcmVNSnRQbUM0SjdhdkxJY1Z5QTVM?=
 =?utf-8?B?MkxZQ2xBTzdtUzZuK0RGY2JXejFLaUp5SFlsUnpGeTlRa2NVeUY0NkVHcytv?=
 =?utf-8?B?cFdMcHE3M2dQZXJXSjh6cnY5Y3pyU0llTlM4ZmhwKzlJb2IvOGI4QzNwV1Vo?=
 =?utf-8?B?Tm9uT1RqaGNSditoQi9lTjlzSXpGd29EeGN6MDlRQ0dHYVhSM2xsTlBQTGZ5?=
 =?utf-8?B?TFBJYkdmQThCTmVPZ3dvT3pGWmhHOGlYV3hHbWlsYmFzMzBGZHVIU2JOMEJK?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c58080a4-06eb-47cc-19e6-08db093dfedf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 19:03:27.8777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lx5g7XhBKIHa2COctFZbkF056TOrKX2cRsyfmbpACLDlQE28LkQRqyJCM9rRmWR9XBHjXlDhtilny2WVJpOPbYGQIlFkr45XQJjYr/86cV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6734
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



On 2/4/2023 5:35 AM, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> Include the second VLAN HLEN into account when computing the maximum
> MTU size as other drivers do.
> 
> Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>   drivers/net/ethernet/intel/i40e/i40e.h      | 2 ++
>   drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> index 60e351665c70..e03853d3c706 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e.h
> @@ -107,6 +107,8 @@
>   #define I40E_BW_MBPS_DIVISOR		125000 /* rate / (1000000 / 8) Mbps */
>   #define I40E_MAX_BW_INACTIVE_ACCUM	4 /* accumulate 4 credits max */
>   
> +#define I40E_PACKET_HDR_PAD (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))

This already exists:
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/intel/i40e/i40e_txrx.h#L112
