Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7836DE004
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjDKPwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjDKPwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:52:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF035254
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681228356; x=1712764356;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dnXGhk9QHlEZH47c945uDDjyJUSvPjXtlxejEaXJmBE=;
  b=X//IMo9Lk+7gu8mAZhHKWrnG1rIPkJkS8uM/biv2tL1Pa7AkKRrQ4/sL
   KoUoSk1iXK8Tko3JFACGocyMIoB0RaTUlzILu+gZkxmP5k6uMhlt+x0lM
   v6oEWxs5luoECjBMgbJbf6BNEGBm41TvugqQrPtgVAjkcQdS+RYq2iMxu
   dvtS4djff4i2p1fFpgemh/b/aT6nNmP3rIsSuxxZRqpRUezc4bTmAFkvr
   wNMcSvGtL7JFVNbzWZFjAwVFTPqcctf35F7CqMNcqmynzow/dbKzMjWsG
   F5WkU4MMyEg3NJ/MdDSdL1N9Oly38z/PEHDDlIhW96Qj/ihUlTpejYlgd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="429945279"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="429945279"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:52:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753187898"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753187898"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 11 Apr 2023 08:52:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:52:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:52:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:52:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 08:52:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeZe6tA62jibK5GZDd4Er7aDgubJxrShfOptJwLlDW9txmKOkU8RoltJVlbWY4a/Gx0FwJzrguEbhEye/jlqd8xTSnMaXWnVIxqHKIJte9ZT8mjG3e7l33OAY7Yu4Og4wrHHs+JHfxzU+WHGGaZkFezwTad2RoZKNc9b8nEa0QabSUJWWc7LaxqhRQoGIbODHR5qWHs74X5+y0tSDM+ndKj/Y2xjIae0I6ZwL17FThNlQYR3UsBfOs7SlA+Ha188y7ju46l6t6mpkUpGP1V4x/HyOS4gdA5yw4mBtB5vCxZNIauaC2pHOcF14vHbFRb4a74C3a3b7s/28PYynT46TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmPQy4eo2S87mgEHq9gZdvg+ss7qO4Dp7z+9jmOCyGE=;
 b=g9Aj7kjCbPVEHJ25NQa3awDPxvAxpawsSSPGXuRV6rQIcVQxS7mh5Pabo/1wZBfFZJg7pZxLWrPBvYPotsT80N3k+3YYG/CWzTm+O507bPW5QPuliIWelBVWPVcR7lBXDc/PF8aa7B2/zB/s8mLZ3Ecd2hPEiXfrxaO9uEP/EEzG+6pDiRQeR3EGa1odq92wjdrGd43RHmbMr7I9OxAnGpYQ2re0eDnE94WFV/sNnAOh0D9+aqfDVk2x+bTh7F4JDPkAwl4HzztZO9ih3u0R8CLrm0n0V3NxtgeTzVnEe1CzgoEbfLTHmm3ZxqZL3vBMHtaY3z7RxO4jHu3BDghbvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DS7PR11MB7807.namprd11.prod.outlook.com (2603:10b6:8:e3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.36; Tue, 11 Apr 2023 15:52:09 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:52:09 +0000
Message-ID: <50116c41-e943-f1e4-96dc-a89633ccc612@intel.com>
Date:   Tue, 11 Apr 2023 08:52:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 2/3] bnxt: use READ_ONCE/WRITE_ONCE for ring
 indexes
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <michael.chan@broadcom.com>
References: <20230411013323.513688-1-kuba@kernel.org>
 <20230411013323.513688-3-kuba@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411013323.513688-3-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:a03:338::7) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|DS7PR11MB7807:EE_
X-MS-Office365-Filtering-Correlation-Id: 135addea-26dc-458b-f5fb-08db3aa4b539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJMsIaxdmAAQV2qU+l2do0/wF7Z5+p/KoaB2f+xZ1G1WETXJino0wpjdk6JRa7nwFNWtyl+7l6xH/7nkl/uOpc4DG24ZyxarucoNQ12n5sqWKoraeqHGhACyLLmrC7V5LRPNAAL8GbetlViob9e0L2irclHdCV8PhdmIc/uADrYapmcDm/w1JHhhbm4OJAtH3UeQZ2AF2tb/ZSody7NoxUacN3+Q62KJkYumbspSz26nMmKacsqsb9z/DcBXbO3+rako9DzJA1TZijO4mNLVLPsI7y16HWV4ZSzq4+6CUSMiF5u57oNPl4EOiX8/ywUQ8Tb/1Rjz78R05rmszGUlU7sccfUuCGCXHnV6Gsi1uAVIof3DbZnzyN79G1u6lNW013eDVjtL26bpKhN057TKvQnqRz8tCIRX1Un+KEjLHsC6F0K2up4sIwwYCXxqlGqiV0vLEgXFNWCIO6Ewa0aNEuOyNJ1WzR8RS9or6vAmSxIUxrUMLoiaMFZETwXRiV74BNYJoUtcEkIAfAQraHFCpY3enqVniyRuTa66C4Wbs4Xeqhu+931BJ6JI84wdQXDsZmS1T5xDiJhvG+qNcOzB8RyXus1Br1zRh0IIpxeBWqXAZGx1g2J7sOXDFA0At7gPtWQXmZzaLrSaXVnZyd61pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199021)(478600001)(53546011)(26005)(316002)(6512007)(6506007)(186003)(5660300002)(6486002)(2906002)(4744005)(44832011)(66556008)(66946007)(8676002)(41300700001)(66476007)(8936002)(4326008)(82960400001)(38100700002)(86362001)(31696002)(36756003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHBYdWdWL0tscmtvaTdKb1pnQ3cxUEZzaGJoRVVwMUdsTktUT21VbVYyaFdq?=
 =?utf-8?B?RDF2V3l4MzAyZm5qQVFDS0xENUZham1kTDUyUHdnc3VpNFNHQkJVNzVmT3I2?=
 =?utf-8?B?Y0dPejhUZ3ZhTUUrZTBhZTFNQkxmL2FCZnRwTlFNem90djIxTytuY3I3TVNC?=
 =?utf-8?B?NVk2bGN6b05LVG1lSElSYTN5eTQ1ZTRXSGg1YnNBdndoRWRLcTZCd29RV2Fk?=
 =?utf-8?B?eTNDd3VVcTVBdXNUQXVQdUprbTdnSDB4MlNQVFdORSt0cnIzU1o1QXZoRVRr?=
 =?utf-8?B?c1ZTQkYvYm9yWkVFcUErandqY2ZxR2dsSGJkeE4wa256b2JOWHhvbDFrMjhw?=
 =?utf-8?B?QWZXeHE0THZ1amJoZVcrVkc2MjQ2aWVRRjlIekdjclBuM2szOWVzWVVMOCt4?=
 =?utf-8?B?NTZPY2drQWJFWWg3TkxFWjRpZ2YvRThqUVBvUkRyWUlkVTFSN0hYYkZFWlJV?=
 =?utf-8?B?MWhkVjRXZE9heCsvOVZMNXZrY0NEZTZmQlkyZXkxZDUxd3FOMlpsTWZYRDRv?=
 =?utf-8?B?aWpaaXZSTVZ5NUgwTVJDR0orbW1ONUNlc2h3N2tFRVdQY1FFcWl0cXNhdWhs?=
 =?utf-8?B?ajdGbEs3L2praXI5MjllUlM5Z0lvT0xFblVkTVhjRUROMkVjZG5nbE9ZOGdK?=
 =?utf-8?B?L0hrTG4ydVBITFFiN2xVYWJzbURTZ25TRHRRUGIzQnpFd2FzczN3RUZmdzlk?=
 =?utf-8?B?OG5RNzczZHU1dnRkUGdjUWwvMjd0U0tiK2dScFcyRnh2NVRVVmJuM2pWMGI5?=
 =?utf-8?B?QWdYZUsxRnppeWU2UElnOVE3bGZsQVAybnoyQTR3a3ltcnZ3dTlLZlB6UCtE?=
 =?utf-8?B?djRpMzRPSXFXaXBiY2Z3ZWlRWTVSeWhPUU9ZdlBCeWdXV1VlTEI2Y3UwSnFV?=
 =?utf-8?B?ejZxS2ovalBxYmNrZk45YThIT3lPR2tVSElYUXQ4ZTY0TFZHZTBqUllQeVFt?=
 =?utf-8?B?RTBtM2N5cjhXWVRRbkFSVExTWTVKVzBCRi9hb20xWlloaEd5UE9rS0hndEZy?=
 =?utf-8?B?MEN4WEVJeHZ6cWR3bDhURDZaRUMzNUJ0d1kxVUcvV2VwVlRVdU5iRnlibkli?=
 =?utf-8?B?Vm1qMmo0YmdRdjgyalVDbGg0SWNFdjMyZHdzbzlEQ2FzME1XQ1VTakpmMS8x?=
 =?utf-8?B?NDFBODJab2JUZ0xQcEQzU215M3BlVjJOdmZSYnE3Szhta1ZoOFJaanRuTERB?=
 =?utf-8?B?Z21BdjM4WEY4U2w5ME5HRFJPanBiNnlKUTFUeVNvZ2JHQmN4bmVFWlRaNVVH?=
 =?utf-8?B?Mk5HeldOZGJNRXZnMG1nNTJFdXFQUmJ0NndqUlpyWVN2N0NIdUhvb1JCNVFB?=
 =?utf-8?B?dDJmVmw2dEV3ZGRDL2VtdGhyMHJKMUZzakNMTmRjTzBoWGthakwzRjlWdUdm?=
 =?utf-8?B?MDY4c2tpRnpWNXpXQ2YwcC9lOUR2TlJCYXBZMm9rL0NoZWhzRkRkbjl1S09J?=
 =?utf-8?B?S0o4MXpmeVBET0Y4U0tqYURGSldQbkdBTkxsM25BaE5rRnFBVzlXalplWjZr?=
 =?utf-8?B?bENocVRqMWZ5U0QwclpZdEt3OVlDVUVjWnZ5RTJydXBud2o3Ymtob0NBM2hz?=
 =?utf-8?B?YjNqZGRieDErdHZjY2lSZzM5eWxaTGphOStnYUxHK05Palg5ekZaTE43TGVy?=
 =?utf-8?B?bWdWKzVwdVp3VlBYNzlUblpvMDRRSWNNNDRhUWowSVd2T0Rjb240Q2RUNDNq?=
 =?utf-8?B?NDBqa1JsUTZUd3ZCQ2Y5WmExYWYwa3BMRzVqcm5pOEhMVkhWOTQ0ZFhaQlpX?=
 =?utf-8?B?VmRvYVlvME5KRlVEeUVtelFYcEI2N1RGdlpvL3pDMm5keWREWW5OMVBuUVJL?=
 =?utf-8?B?b2YvcE5nalFXU3FsU1BxU2RPVk8xQ2x5bFhSTkYvK05kQXVPb2dtbmpQM0tH?=
 =?utf-8?B?Nm90Z0hQUkRMNThiS2tCdzVadFdTTk1xR1kyR2JIUEduN1RScnNOdlh0eVpM?=
 =?utf-8?B?eitFVmM3SFM4cG1UNlNQSjh1S0FVS2YxTGtCYU14YkplcUtKcVJuS1JzbkFH?=
 =?utf-8?B?WnhOdFBpZ2JrQ0plK2YwLzY1eXNENWlvc0RpbHdhbzI1Z01UUkdGREdLSU9w?=
 =?utf-8?B?dDNLR1Z2aTNnNWhsYUlmODJUTE4rbVdTZSs5UGg1R09mdldKdkVxZldHa0lt?=
 =?utf-8?B?b3oyR1ZibzlJUkJHbG9KYkFHa3B2b0NNemd0NXJRSDJIQ3RqOG5QU0pWdFky?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 135addea-26dc-458b-f5fb-08db3aa4b539
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:52:09.5172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2BGGR46cXqXFIuUTJlaPezoQ7ug7g12doitUININjG4mV5N4WlY3ygy/9VtGbj6GqDpa6mXv6JGNOLFo3vAnC9cU80hM+FIp8P1qivIGq+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7807
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/2023 6:33 PM, Jakub Kicinski wrote:
> Eric points out that we should make sure that ring index updates
> are wrapped in the appropriate READ_ONCE/WRITE_ONCE macros.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: michael.chan@broadcom.com

Looks good, thanks!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


