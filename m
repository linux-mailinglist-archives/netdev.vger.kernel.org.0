Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6051C4DE49F
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 00:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241519AbiCRXt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 19:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbiCRXt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 19:49:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4E2DB4;
        Fri, 18 Mar 2022 16:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647647285; x=1679183285;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RNA7THF7ZUgoJX45T9t+RfqFSZxvKPjBQWzlehVZrqk=;
  b=mObIQM3ZjaP55rg1k4BAv1kYZY6It74k/pCUJRSttTLBsvpRAqNgv2ol
   3iBXL11vNh2l0rqzknHk6WSh8ov7wHH7eBdaaM1+y+PVP7h2Arh+fYulr
   qAKjpuBe5tV7LO/6L+Rd1WywXyl8Qhhikb0CpsOXEiA5yGjji5YbRw7Wg
   oanJSDheMZi211ly8fRAjmtFNHGpVqTxuNYU+skCoTl2HThZGN9IymojE
   wCMSYyA/RHMinTUOXNIo3PEkaOmeWjr1fr8zX0496qvT4ghqFXZeCIG6e
   idgRGdQshNEJ7a5gCbaHob53sQ/mbItanH5eOLns0heYRLBEYuYdDsWhF
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="282067712"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="282067712"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 16:48:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="645743994"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 18 Mar 2022 16:48:04 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 16:48:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Fri, 18 Mar 2022 16:48:03 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 18 Mar 2022 16:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYXbVvmb6AmoX2WStkOhPXgu2RqXaJ10oJXYa+y60q8ahRLGqXp4FZBVTk6Xt3PwVHQBdut8NeGFu+fR7bn89KOCaPLCbvdU9xDRjfFAO0s1RY8bghS+qNySvvq5c9mM5dX2TXcV2UxEGpJzDydN7vPq6Slc/2I5M3a4fV+h18CXbLQb6+CUFA2NIfUTtk/WXYN/TVFORqBsyJX8i5HvzwA8zQYD1pLw/X+v9ujUEzODW+/xEzNW6LiQrcUopUSUgdP5kjmGO28UXaTDpJo6BwY/O4QDvfyNSpLyQ8g8JeUEcUYN4//xbVxKIJKu3aKvnVbkhRp4CwT6cWaOpzxDeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPwax18U3C/qg47GROJT3HEJjlYEb8ckIDujzXqac+o=;
 b=KNyxklAvPY7KVr1QMhFkB/WJKpv3XgALanrA6nq/aBEXJKf8uaS/v9OEt7gYBqHQC0iBwOJhU4JX4dHU2CsBdde48D2U6U9rja/C7XXeWAoJFNTVS8KOYxvxUHjEpGhxzQ0PP5WWKaEzv65WHuRTClzPw649+5BgBFJQbl0F5Kjcj24g3G9Q983m6OY/hRDFK0HUEN9CFLRjQPBCnl1ljrU8wR+TKfHjY9zosE639OgpgQjCMyAHFoN1Izc7mtJ4SZcg8eGCdJTEwzlJwZrQ0vmnS7XnPRRbZocXyPfI+4g9upM6ISY0J9cBuEI3skopC0PUNaKuVKRALwCF1Hz38A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BN6PR1101MB2212.namprd11.prod.outlook.com (2603:10b6:405:52::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 23:48:02 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 23:48:01 +0000
Message-ID: <56cd0dde-600d-1bb0-1555-e66de8c37236@intel.com>
Date:   Fri, 18 Mar 2022 16:47:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] ixgbe: Manual AN-37 for troublesome link partners for
 X550 SFI
Content-Language: en-US
To:     Jeff Daly <jeffd@silicom-usa.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220316192710.9947-1-jeffd@silicom-usa.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220316192710.9947-1-jeffd@silicom-usa.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:303:16d::20) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a6a6141-71f5-44c1-5072-08da0939bd10
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2212:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR1101MB221202F4D68A64959DB77510C6139@BN6PR1101MB2212.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RRIL+/WoeJlTAbjvD1DCH/PW9PYoWX3xugTkQ219IRrEz0RG6wqBcJj2gxl4bHOHm+P1SjRcTR/lEU29HxuwB3tZsjrb3O9BrhLbY2C8khbIiJgmmlkjBHlselAI5ezpnWopF+8MslfjqVtsofTK2fdcT/W1qW1IvaPOF8/sCCDlDHxPPvSOzGsY5ysPwbIhSj2jLwZdkxxyMpcgU0JyLKxnrd7RoSGhoI/72S6IeAq93K1RznfIyen2ma8H4w/RhzwhmOKTt0u0VSrSfe23ifFP2JP7Z5Ww8TlPuJGQbyNjT1hQ5fPu5BnEzlLCO29jXT8ZLBhGDRzNbp3/jTJp8HxlWJpPONKRUqiricKJ6Fxmt2gg9irTyoPsFLqvy3SWrucPYMOB7YYcrse1UoDYmGBNYMXy4rAzRgHZzThc4M6LAPYXSTmaoEm6M0iJ56Zhajp5I7lMCgSG81adJoGJs3odxLXH1sAzp6wlkmyBJihwsXJX9PSGcHhZdRSGhfTugr+undoFNI9S7ZM6WPQn3QJyOa7l9GRQsZG+PB6XEJQx931QW4L0Gt7obt6oKmC9dqhp9lLtLcQOU6AJNtohoDoqFJBPe81twify2IBWKLDA64JdlOjNEkIT6/Mp6ijgkYLUNErRdbargKFmS57NauT1bnA2xJdOqHcWqS8ves3+Nn04udjK5p28B/wPyUbPKgMtsmca5JozAezCdYXnzkgz/9f9etI8E2F4+w+V1u4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66476007)(4326008)(66556008)(6512007)(82960400001)(2906002)(8936002)(508600001)(31696002)(86362001)(5660300002)(6486002)(6506007)(53546011)(38100700002)(6666004)(31686004)(8676002)(2616005)(83380400001)(36756003)(54906003)(186003)(26005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFlaSGozRnpSSTJEN01JbUtRTVZwSTFQSkIxcnpUWXhsYnJpbjBNUWhIOVky?=
 =?utf-8?B?ZjZ5SnA5WlVqazFIaFZVMmErY1VwQ2trUENZNU0vWGpKNndyNFJHUlRlb2V3?=
 =?utf-8?B?MG1rbEFhTS9RL0VuNlNwc2tLZFZrMDgyVlZjRTdoYldtZGRIWXlEdnhzM3RN?=
 =?utf-8?B?dlBqbmRSWTZaU210OWNyNUxWSzZLODBhdE9qRlA1YWJ6UWdHYnBoTWVxRDhV?=
 =?utf-8?B?NFRCZXZUSDRKdEIxTjVHRFF3MDR5cHJzNlRuVWZHSTl0MDJRcks1akdpdnRX?=
 =?utf-8?B?LzIzbUh6STEzWUhPeTR3eWcwN0hFMzAzeDZtQ2ovMFdaM0YwOTlJWnZ0MnJS?=
 =?utf-8?B?NllINXJyUy9kNHNpUFViSlBDNHFOTE84TXU5VjZlVThVdnlZK1pIc1o0NkdS?=
 =?utf-8?B?blhNWjZNeHJjL3ZvNlF1dG44eFBBZlI5YVdyK0NuNzZvSnBQRGZxT0lrSXRJ?=
 =?utf-8?B?TEgzTVE5WDlVdzZMN0pESTExQTdFdWtxQmlRSU9KQ2xhRXpwTEI2Z3ZocVpR?=
 =?utf-8?B?ZXhTUGtjTEtCTXNsRWR1NGFwUEZjcFRzRzBXMzBHS0NkN0wxQlBKUGJOb0Y0?=
 =?utf-8?B?WmcrcUhIWWgzRHR6QjJldGFsbm82dnk5eEdUaXJDb3BvQjk3dEc3QURBR1lQ?=
 =?utf-8?B?ci9tcHZodEJuWWF4UDRCUjBhK250NXF1YUpxQW5aS2hxQ04wTDZiK3IyMW96?=
 =?utf-8?B?MDJ6aXVWcUZreTd2QmlycGk1RVBGMnU2MHdXbE4zZGRyaGloNnZoSmxJV2dY?=
 =?utf-8?B?b0lSNEZhQ0JMallXM2ZrUWlBSndRbVhxTlRCMTRhSEhzZ3laVlpDejlmeFdD?=
 =?utf-8?B?aW1KS3o2aVhNWjhHVFkyeWdZa1FocGtUcGVGbXE2Wis1MUFvT0ZFZHpCNVdL?=
 =?utf-8?B?VExuaHo2dHdxSUJ0b0RoT2R2SkRxY21MdFR6akdiNTRvcGxaalo4MG5Wak94?=
 =?utf-8?B?Z1FhaU1Wb2xNVmxYYWtyVjJDQ3g5aSt5Z09YSHd5WGtPalNiWS9PcW5iRHhR?=
 =?utf-8?B?eXROeDN1Mys0SkFaZXR0c2N5Q0s3dWNETGJLM1lWaTB2bVdPK3VvREZDMS9y?=
 =?utf-8?B?Z0toekVrNWxEaENFYVpnbWhhUURGb1VRT1VsaFd6NUVDN0VnNXYvbTFTeXg4?=
 =?utf-8?B?ZFZETFR0U1BmYlEwNWN1V002MmZLM3R1WXdwc05TRzdBMkUwemlqZThmTk9E?=
 =?utf-8?B?dXBGemprOHJmcDdjV254ekdlNHFOTFcrR1dLVlpTUDBydjJwMTlqU0t3MzFs?=
 =?utf-8?B?UThHaE5BRmRsWUtVdjhDeVVuRVE1bzR3OFNSTyt1M1RaNWJ5aGhlUko2YnRt?=
 =?utf-8?B?SWpySU53VUk0anFQbUxIR2FHUFJlWVpYeGxLUE1sOTUwS1hTRWdxS1MyNjBW?=
 =?utf-8?B?K1cvcXJUa2R6QTJQdXpUL1BhTVo0L0lsNnQ3SlJBcy95MUdRcHJ5S1ZnOUxl?=
 =?utf-8?B?NVZNWEtQQldpYThub3llM0RqT1ZNckV2SVZ6c2tZbm1mcHlWRUtTbzRFbVRp?=
 =?utf-8?B?N2Y3K0N0b3VoNGp5VmVkWnNpRUw0U1JGN1BralZrRlZScVZkNzBSbkhqQVdV?=
 =?utf-8?B?dTRsbHQ2ZXA0RlVJWUdsMFpFRGZjK0VtMC8vV1V4SmljUFUrV0lQZGh1Lyt5?=
 =?utf-8?B?TFkwNzZkdW1QTlpVYU0vZzhPZVFSVjAwYmR6WHdqWEszUGh1NWYzL25aODd0?=
 =?utf-8?B?eUkvQVdWbDF3MVd3Nk1Wd0o2azZYOE03cW41cWtQbSs3by9sWFdlRmxSVjJ6?=
 =?utf-8?B?c2svUWNrMjBjcEJGTHB5REZFK1ZoWXpkWWNXODdIZG5iRVhQa3ZDU2VuZWc4?=
 =?utf-8?B?T0Z6VnRDM0krbFVabEJ5YnRGYnpreWZ6VWRSbVNqRTBPMWllZ09GemdLY2dX?=
 =?utf-8?B?eVpaeE05TzlOWS82cGNxUFBaSjZkMXdEbHFUUmRLdEVrOGdrNDY5eDVOKzh6?=
 =?utf-8?B?SjlqM2R0T3ZUdGVkTEVPSENLZElybHU2S3lFMEdiVnVlYmhydFd6NlJpc2Zv?=
 =?utf-8?B?UE5qRUxwOVVnPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6a6141-71f5-44c1-5072-08da0939bd10
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 23:48:01.7970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HdNxyXwAdVvb5peRBd1bgwU4LtsT1YpLDW2pCq1IxDNbZwrR0hyQ+/TvrdyZ4CzIKwkb4/yAG05VVjX5EcoGRFPuhfIBRGOkPknJT+uHvQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2212
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/16/2022 12:27 PM, Jeff Daly wrote:
> Some (Juniper MX5) SFP link partners exhibit a disinclination to
> autonegotiate with X550 configured in SFI mode.  This patch enables
> a manual AN-37 restart to work around the problem.

Hi Jeff,

I talked to the ixgbe team about this and we need a bit more time to 
look this over. Will keep you updated.

> Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  3 ++
>   drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 50 +++++++++++++++++++
>   2 files changed, 53 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> index 2647937f7f4d..dc8a259fda5f 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> @@ -3705,7 +3705,9 @@ struct ixgbe_info {
>   #define IXGBE_KRM_LINK_S1(P)		((P) ? 0x8200 : 0x4200)
>   #define IXGBE_KRM_LINK_CTRL_1(P)	((P) ? 0x820C : 0x420C)
>   #define IXGBE_KRM_AN_CNTL_1(P)		((P) ? 0x822C : 0x422C)
> +#define IXGBE_KRM_AN_CNTL_4(P)		((P) ? 0x8238 : 0x4238)
>   #define IXGBE_KRM_AN_CNTL_8(P)		((P) ? 0x8248 : 0x4248)
> +#define IXGBE_KRM_PCS_KX_AN(P)		((P) ? 0x9918 : 0x5918)
>   #define IXGBE_KRM_SGMII_CTRL(P)		((P) ? 0x82A0 : 0x42A0)
>   #define IXGBE_KRM_LP_BASE_PAGE_HIGH(P)	((P) ? 0x836C : 0x436C)
>   #define IXGBE_KRM_DSP_TXFFE_STATE_4(P)	((P) ? 0x8634 : 0x4634)
> @@ -3715,6 +3717,7 @@ struct ixgbe_info {
>   #define IXGBE_KRM_PMD_FLX_MASK_ST20(P)	((P) ? 0x9054 : 0x5054)
>   #define IXGBE_KRM_TX_COEFF_CTRL_1(P)	((P) ? 0x9520 : 0x5520)
>   #define IXGBE_KRM_RX_ANA_CTL(P)		((P) ? 0x9A00 : 0x5A00)
> +#define IXGBE_KRM_FLX_TMRS_CTRL_ST31(P)	((P) ? 0x9180 : 0x5180)
>   
>   #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_DA		~(0x3 << 20)
>   #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_SR		BIT(20)
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
> index e4b50c7781ff..f48a422ae83f 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
> @@ -1725,6 +1725,56 @@ static s32 ixgbe_setup_sfi_x550a(struct ixgbe_hw *hw, ixgbe_link_speed *speed)
>   				IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
>   				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
>   
> +	/* change mode enforcement rules to hybrid */
> +	status = mac->ops.read_iosf_sb_reg(hw,
> +				IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
> +	reg_val |= 0x0400;
> +
> +	status = mac->ops.write_iosf_sb_reg(hw,
> +				IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);

I don't see a need for all the status assignments, they're not being 
used before being overwritten.

Thanks,

Tony

> +	/* manually control the config */
> +	status = mac->ops.read_iosf_sb_reg(hw,
> +				IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
> +	reg_val |= 0x20002240;
> +
> +	status = mac->ops.write_iosf_sb_reg(hw,
> +				IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
> +
> +	/* move the AN base page values */
> +	status = mac->ops.read_iosf_sb_reg(hw,
> +				IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
> +	reg_val |= 0x1;
> +
> +	status = mac->ops.write_iosf_sb_reg(hw,
> +				IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
> +
> +	/* set the AN37 over CB mode */
> +	status = mac->ops.read_iosf_sb_reg(hw,
> +				IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
> +	reg_val |= 0x20000000;
> +
> +	status = mac->ops.write_iosf_sb_reg(hw,
> +				IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
> +
> +	/* restart AN manually */
> +	status = mac->ops.read_iosf_sb_reg(hw,
> +				IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
> +	reg_val |= IXGBE_KRM_LINK_CTRL_1_TETH_AN_RESTART;
> +
> +	status = mac->ops.write_iosf_sb_reg(hw,
> +				IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
> +				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
> +
>   	/* Toggle port SW reset by AN reset. */
>   	status = ixgbe_restart_an_internal_phy_x550em(hw);
>   
