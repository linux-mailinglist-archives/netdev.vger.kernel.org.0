Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0D6E973E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjDTOfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjDTOfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:35:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F76A40FE
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682001337; x=1713537337;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A4m99IslS99jsjpbzesmgxrYJfM5ao2vUnO+T8J4QU0=;
  b=RKO7aTXAkjjQ6qCV4AAevsEeGTWjb4oabmXCld91uy9ESY2lgdbn/flR
   xeXol1c9048+fa/hhCT7hFA61FUw3vBSM8sxvkW0rc11CVHT+V3daqJbw
   Zz6CUV04aYxrhoB9O45aklZExMUsYgsE3nBDfV3jThrkCaNx08vbpma4D
   6mcaAhPRo/6KisdhE1FhJXF12ljntPgeACEMzNqhOdygfGPWpges+O1UU
   h0qYzqpd4D+94oTpipkxOYgYaP1GD5V/hJoI7mA4SUNKtxp7VewDX+3YJ
   swdI26cz1y7zgnwKZ7HhmNnkHAWrjjoMu+mBpj8kGoD8aIBYK2PUgrdcY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="432029338"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="432029338"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:35:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="1021597763"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="1021597763"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 20 Apr 2023 07:35:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 07:35:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 07:35:07 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 07:35:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KA9I61yhD9iwuYv+4++DipljV2rJF+Ab9cwocG37/nd9+eQNpjzMup6P739YqZtenTRpztZI98F2Tr8J8JPgs9C5kvZ/AWhpq64rRSXVMrtHRpSLlQ/TmOYYIB1XFMR70N9j3182obaZmd7+ZPCO0Tu/+TDCSuhThXyKaM38x/Y38PXXM660sJkuPkOCyNaV6JomKPVw3kFB8Ltjtyy3wzexrsHxZa5RB1QowGJF2kmd4pblli9Srnw1W+ATmY91zFvlLC6HljeRqydN1+eLiHP8PDBppAxOvb6B1ZsWfncv3mFGWD08UF0DYdpsFrkIynT1iVryhDaB9spFTGdSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezubyX2eOwhxZamgQPmatla0cvDpdLnu5XZakGzcLkY=;
 b=GfSKtlwZnzG12I4nQ1GoYJ7Mbjk8dGuokcgi2bHcwBb9QSQ9IBMIPdy3zKdVgodRevGNSJZFU0e5PwVM4xoOonEANRpCP/DFQBlAS+POFwuiZzNELQuX87+8ubRuFBywBE0plQI+kG1mBRIRNGdeLzhY+1ERZfZSAc8VwshtCX97C8ct73TAxVuqeL+QJu53RLaLZ4MQzprtFldGBmP4HY80ox0S3R6L5n/9dtpHBMrTdJh+xa9yM2llKdOg8Vg/deG+iIPyQ4KbfDzP8gvjglbPWPd6YgzWZGMAZ9ZYGs27/PZ7TT1vWn4vAEIlDzOpdU/qoDNdblKr99+Im1YGlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MN2PR11MB4616.namprd11.prod.outlook.com (2603:10b6:208:26f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 14:35:06 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:35:05 +0000
Message-ID: <21b89328-8c74-596b-3cfe-e71affd193a8@intel.com>
Date:   Thu, 20 Apr 2023 16:33:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Intel-wired-lan] [PATCH net-next] iavf: remove double
 underscores from states names
Content-Language: en-US
To:     Ahmed Zaki <ahmed.zaki@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230419231751.11581-1-ahmed.zaki@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230419231751.11581-1-ahmed.zaki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MN2PR11MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: deca4428-c4b1-4166-426f-08db41ac6ef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RCP2Cy4RPJBK/QiCy95Dor4LPRNavJQ27GU9Sba+WYwNj0FyoBljBc78Ix+yfr2G1XbzaiKrtaifuxdGq2B27eChfGhNLCaQs/APA4Qrve7qqpMGy0fSsAB9gpi93+CSfIgzvtKZJO/pBojYktBI28gbCvJa4969Vfp2mCdbNEo7GQRIuuU2lXSRM7/UC0E+bmtuXA9iLXM0XGDYfDE3jRq2mswfv6NEYBE8eQrcdI24UDhG/Jwm4mMzKhJ9PY4WpQ/71M65hArGQ8Njtx1livFNw9DoUj4+Zd/EtZeqmiboQVdnzxFHZn2yMAlmoKZUd5zfo9E5RyWarjqTYU8DERNkTrGmp1BdLLYIW88vGVoY+DH3BI7AnbuwxNUwI1g7EWqocwGjs00kxJ7vVpS42NK1h//WQkNJivM/nEPThh5v0uAx2/Wv3wkTTA3LAvM0Nr2Xw3SwPnjT0oXnE4vwkEqiNB5iO1kkaGg0wD0FAWomTnq3EQzEFkvpgZfAjn0EC6ZjEu4Dh9pFb+qKeTZ/8ZK5hLe+Oyx2CTuM3Lofysxv6kBNa7ZnBqhub3cRCcP56qQ39vu+SJBhYbbB4Kgatq4syQ0NAOt4PzExlGGmC9bKUxLy0kuD2yI/KO82nHto+SBZON1/ZPXgjLSl/Ynysny/JuR53n3lbjHNOqqf8WU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199021)(41300700001)(66556008)(66476007)(66946007)(54906003)(6636002)(316002)(26005)(4326008)(478600001)(37006003)(8936002)(8676002)(83380400001)(6862004)(2616005)(5660300002)(6512007)(6506007)(966005)(6486002)(186003)(6666004)(31686004)(36756003)(2906002)(38100700002)(82960400001)(86362001)(31696002)(341764005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVNwRmVkMzVRTHJJM2FyS1NvZjNNN1cyelRpbVd6TWVJREU3YWs1SGpCV0Ur?=
 =?utf-8?B?UXpWVm5yVUhodFhZVjZ2UWl6WlV2eUlpMkZ6aUVGVXRoV243bTZaSTVDWVVX?=
 =?utf-8?B?MENEM2NLSFlsanlRUmprbVNDNXNwdUlQZENFS05ub0RRQ3lyNzFZRnNtdHNv?=
 =?utf-8?B?cG8vd3ZuR0FFQXMwZzE5cFR1QmRxSkM3RnVKL0lVQ1VydkdPV1RrMWJFSnBJ?=
 =?utf-8?B?UUJ3RjkzUFRSbnliaHpKUEVpbjR4TUw1VFl0VjNkMnoxdy9YK0RzUUJRaVNV?=
 =?utf-8?B?eWFGK1BWczZ5aFFkc0tFSG5OM1I2eVV6OUhUT1ZaRVd0OHZGWkV4NFdTTDR5?=
 =?utf-8?B?VERBSnRrU1RsREtRczVzNEdwTHZyMlc3OWtoOXhpOTczSFR0a2NWdnNOZEtL?=
 =?utf-8?B?L2R0YmQxc28wV0M2ME5aQWs2dWhxekFjcG8rZFVLWjZ5S2Q5SXVTNS90OTBS?=
 =?utf-8?B?MjVWUmdxUjVLd0xuY0UraE5IR28vZkwyWHlQSkxCY2pzWk10VEJiMzV4L3dy?=
 =?utf-8?B?d2ZGd1pQSE11QUxkTi9xdml2eFhFcnhBeDZ6Z0V1T0l1OEt1UnZBVXh0ejRl?=
 =?utf-8?B?M3pGZHRpdFFxU2J0alB4MC9HOGhMRlZmRUU2dTFoMmI0dXVBRWhxYy9vYTBV?=
 =?utf-8?B?UWdzdjNmZmdxWGNNaDFJMFRod3pCdW5ZQWg4RlRyUGlNaVdCWVQ1bzNOOTlU?=
 =?utf-8?B?MXBta0pzRHJLSGFLdGt0VG9sY2VBV1NhZ29nZ1pZbC9URXVwdVZla3o0d2NJ?=
 =?utf-8?B?L3RmczZWMmxmUnZobUZzWkpVVzVNZm15dXg3aFd4anE3Qm5PVllZUEZhVHRB?=
 =?utf-8?B?OHNOSEtReFp2T3I4ODc3ZlNnVTNnZVRuVXlKdTBGQ1RkNHo3QTBVQW5pRDJS?=
 =?utf-8?B?UHhzT0xDbXVxVXFwNDBaTjV1Z05Wa0N3TTN6N1JUYWd2aFFYdytmRnJCRnU3?=
 =?utf-8?B?NXp0eC82TFMvVkZONGZNOFg5K3JpSU1rN0IzVnNXdUlVa0R1UjFKTXVIaFZZ?=
 =?utf-8?B?ajVwSkdKTDEyM0Q1ZjFrNDZhdzJMbTF5akNPdzVHOGxjbHg3RW9ubVBqZjh1?=
 =?utf-8?B?cVk0M25RZTk2L3BaK3lIc0hmWWtSRjFReDZuY0NZTzVZcnUya0V3MFpzUEkv?=
 =?utf-8?B?UjdRQ0xCWkZ3eDFNQlRxdzRvWVNjNm5EVU9zNTZWV1o1ZkFISXcyUjZuS25j?=
 =?utf-8?B?dUZqbEZQOFV5cG1kcVBZTzAzeWo5ZVdiZDJKMXJqaDJZTTNNeGVpa1ZuTWth?=
 =?utf-8?B?ZENGMVBsU0F2RGdsSWE2aCt4c3dCYjIycFZCcXZxeVZQRm9pRXVRdG1OcTFU?=
 =?utf-8?B?Vms1NWdJZzFsalJMc1F1WEJNU2JUUDFBYnBtek9nWDQ4UC9kajdxZUE4WWdw?=
 =?utf-8?B?c3hzanBsbkR4VnViYm5WbnVMSitSTTZ0N0I5TjZSYmNadU5qVzBKUVUwdkpY?=
 =?utf-8?B?TGU5VDFQd2lJWlhUTmxCRGF1S1ErWm1Da2dPVk9DWGZUK0VVYTJDTmJTTS9V?=
 =?utf-8?B?UjN6NE5aOTN1Qmd1TDVsSVRqaXZWTXpxMXYzM3QxczhjQ210bXM4UWQ1OW5j?=
 =?utf-8?B?MFQxS0w4QjU2bDZPWm41eHVsTUxNUWlMR2NRbDJuUFN5cUhRVWJxejN4K1ZX?=
 =?utf-8?B?SmFTdDYzZGpTbVFoT1dMOGN0YTlnM3lEWmlFeEorSjZoQ3U4blZFakUyRXhv?=
 =?utf-8?B?U01DUzFvM1BZMm5XcElZNERNQjRXZ1JnUDlFMEF4Ui8zT0NKU1h5VGJxMlBK?=
 =?utf-8?B?bHJUSXhSREZMOFl4Y2tqQnRkaGFCYStRejRnR3FYNFRGNU5uMzJDUVY1azR2?=
 =?utf-8?B?WnBYeEdzM0FERnNIVVMwZ3oxU0U2RW9RbVdZVktvMndrbml4YkdBMWx4anhp?=
 =?utf-8?B?aHpKaTlnV3c1MXNyTkVrcFhxcEtzRkEycG5KMCs1aVdzM2M5WHdXc2t2eWNv?=
 =?utf-8?B?Vk9TZlFEV1hvTmlVNXIxNFRlRjlhNTlGelQrTll0eGYxTlNlVlFkaWROeUpw?=
 =?utf-8?B?cG5SUS9Iek1uWG13U2NGS3hGaEJ1UzcwNndNRWM4Wk5zamYxZVZZbkRWM1V3?=
 =?utf-8?B?eVlWa1BJR3pkaFhlSnR5dzI0NFFSQjNySUw1VHgzdUw4ZE80VUhMV0VMVEF5?=
 =?utf-8?B?ay9ObHYrMCtkQUUyKzhyOVJNSlcya2orYjUweUJpay9DNE1oMmJjQ1l4d1lK?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: deca4428-c4b1-4166-426f-08db41ac6ef4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:35:05.7845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URUaV2ogZSHj1kSXPlOnoxZEk0z2Rxw9x21vTiTRkDoK1QVabNgWE09rqZak2gvLRIe6bonD4p1tRpwCaarkdqAKn9tmw6ZNMTtK1+NNoy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4616
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Zaki <ahmed.zaki@intel.com>
Date: Wed, 19 Apr 2023 17:17:51 -0600

+ netdev

Please add netdev ML next time you send networking stuff, not only Jakub :D

> No need to prepend some states names with "__", especially that others do
> not have these underscores.

What's the value of this change, apart from 400 locs diffstat? I don't
say having prefixes for general-purpose definitions is correct, but...
Dunno. Would be nice to have as a part of some series with assorted
improvements, but not standalone. Or it's just me =\

> 
> Link: https://lore.kernel.org/netdev/20230406130415.1aa1d1cd@kernel.org
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>

[...]

> @@ -468,36 +468,36 @@ extern char iavf_driver_name[];
>  static inline const char *iavf_state_str(enum iavf_state_t state)
>  {
>  	switch (state) {
> -	case __IAVF_STARTUP:
> -		return "__IAVF_STARTUP";
> -	case __IAVF_REMOVE:
> -		return "__IAVF_REMOVE";
> -	case __IAVF_INIT_VERSION_CHECK:
> -		return "__IAVF_INIT_VERSION_CHECK";
> -	case __IAVF_INIT_GET_RESOURCES:
> -		return "__IAVF_INIT_GET_RESOURCES";
> -	case __IAVF_INIT_EXTENDED_CAPS:
> -		return "__IAVF_INIT_EXTENDED_CAPS";
> -	case __IAVF_INIT_CONFIG_ADAPTER:
> -		return "__IAVF_INIT_CONFIG_ADAPTER";
> -	case __IAVF_INIT_SW:
> -		return "__IAVF_INIT_SW";
> -	case __IAVF_INIT_FAILED:
> -		return "__IAVF_INIT_FAILED";
> -	case __IAVF_RESETTING:
> -		return "__IAVF_RESETTING";
> -	case __IAVF_COMM_FAILED:
> -		return "__IAVF_COMM_FAILED";
> -	case __IAVF_DOWN:
> -		return "__IAVF_DOWN";
> -	case __IAVF_DOWN_PENDING:
> -		return "__IAVF_DOWN_PENDING";
> -	case __IAVF_TESTING:
> -		return "__IAVF_TESTING";
> -	case __IAVF_RUNNING:
> -		return "__IAVF_RUNNING";
> +	case IAVF_STARTUP:
> +		return "IAVF_STARTUP";
> +	case IAVF_REMOVE:
> +		return "IAVF_REMOVE";
> +	case IAVF_INIT_VERSION_CHECK:
> +		return "IAVF_INIT_VERSION_CHECK";
> +	case IAVF_INIT_GET_RESOURCES:
> +		return "IAVF_INIT_GET_RESOURCES";
> +	case IAVF_INIT_EXTENDED_CAPS:
> +		return "IAVF_INIT_EXTENDED_CAPS";
> +	case IAVF_INIT_CONFIG_ADAPTER:
> +		return "IAVF_INIT_CONFIG_ADAPTER";
> +	case IAVF_INIT_SW:
> +		return "IAVF_INIT_SW";
> +	case IAVF_INIT_FAILED:
> +		return "IAVF_INIT_FAILED";
> +	case IAVF_RESETTING:
> +		return "IAVF_RESETTING";
> +	case IAVF_COMM_FAILED:
> +		return "IAVF_COMM_FAILED";
> +	case IAVF_DOWN:
> +		return "IAVF_DOWN";
> +	case IAVF_DOWN_PENDING:
> +		return "IAVF_DOWN_PENDING";
> +	case IAVF_TESTING:
> +		return "IAVF_TESTING";
> +	case IAVF_RUNNING:
> +		return "IAVF_RUNNING";
>  	default:
> -		return "__IAVF_UNKNOWN_STATE";
> +		return "IAVF_UNKNOWN_STATE";
>  	}
>  }

If you want to do something really useful, pls replace that non-sense
with O(1) array lookup:

iavf_something.c:

const char * const iavf_states[] = {
#define __IAVF_STATE_STR(s)	[IAVF_##s]	= "IAVF_" #s
	__IAVF_STATE_STR(STARTUP),
	__IAVF_STATE_STR(REMOVE),
...
	__IAVF_STATE_STR(RUNNING),
#undef __IAVF_STATE_STR
	"IAVF_UNKNOWN_STATE",
}

iavf.h:

extern const char * const iavf_states[];

static inline const char *iavf_state_str(enum iavf_state_t state)
{
	if (unlikely(state > IAVF_STATE_RUNNING))
		state = IAVF_STATE_RUNNING + 1;

	// ^ or better just add `IAVF_UNKNOWN_STATE` to the enum
	// to not open-code `RUNNING + 1`

	return iavf_states[state];
}

You can even just copy'n'paste that and make a patch, I think it would
work :D
And attach bloat-o-meter output to the commit message, I'd like to watch
the result :3

[...]

Thanks,
Olek
