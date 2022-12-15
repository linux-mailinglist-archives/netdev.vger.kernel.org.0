Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AC164E15A
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 19:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiLOSwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 13:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiLOSwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 13:52:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0CA37225
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 10:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671130357; x=1702666357;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rNv/BBpWxZIBNYpMiHj92fZ9Lz7+aWZwZpCKTBuNdCE=;
  b=JF5N4fM6/zNZvl02I3K99cFCf2vCq5BFEtHVq7owNhGHqdx4B7LuzrFr
   BZyVXZ5628Z/TXbpcuJVwBvWLFSL7KwOLXV7IFrbBC3ecmahaWjXFi/wt
   u+TOQtB/YgCefUmvjzAPS0qMCRNieUM1mWTpldRFzgEjO0hb9OYxiLH1f
   oqWnHAuD1oR45LE35lBlRuVeSP9A5KkS04cXKcIGsxHTDgb8sIYJkvF4/
   247L6R2OyESs83/qk5lSaVLUZYlw4y9Csoai290fsk8QeXfkEhRRXgtYZ
   0lR6kaqePpKM9BGtYqu44KlIdGCMkb6Wo61k0k5yWGfjddtmRUozDsWac
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="318819644"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="318819644"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 10:52:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="649539390"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="649539390"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 15 Dec 2022 10:52:36 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:52:36 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:52:35 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 10:52:35 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 10:52:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atvHcnpcKWWpJ3KWy3y1mokUSl4A3sluA0nBnlG7Ad1cqlohe7MaVwM/XRe78qMA1sZqBFsY+IHA59ggSa6/trbTAdYhkuuPSdxfvR4s5Rlkegw9yXnaFj/ZZs8RSoO2ZuzPU66Nl5pp28bNnmetaU2NsXm9iWQqnFmILcie8ks1cwLXfJLS/IeAZdm6D8HQHuxeFbVPOAMZYieUHq4EgFFqRCkgUG1/pttg13ooR5Tu2DJd6atBCUStr/m8/xACZe5kIXVMA4xuaJqmx+tUkaoR3DpEFzXRJtgtgA5q5jfnGbkmVfi4+lr2FO0gxnYanBqlkFIaY/DS7RoExsTgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LbV17Ugr0QR6KjGwNsjTSr9I4rcT0odhJDJgjFmp88=;
 b=mVJWs5xEvYY2lCNHIY+5pklmTx4ZI/c4GllqdrQ+Eg1OjDEAoTPy5wq1OZKd/PrDNcAiFl1wP3Vt204d+IR2tf2F5OFAauKRJQUqQ1m9NaPuiNx4GdLU/LNmha5p01/p6Tb4EX10dyDp618Jm39Xo2Yvw0gPitqq0mpiKAwKrsPCAhwXAvNy82xAEAEz+mIRFd8hKFjcgRKbZdOdnJBKZuMvb0wkbYo+wyqktR6s+adnymEGrMtjAtAWm9z2LwJgUSljfHd+r6S/uCkiXGHQ+UMOCyjJx0TfgOf5+LxJthi7TmbxZpSzo9aY1XySNiG3kjDbCcEDbkU+AMjvKkRZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB6876.namprd11.prod.outlook.com (2603:10b6:806:2a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 18:52:33 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 18:52:33 +0000
Message-ID: <af89b94d-8cc0-17a7-2eea-ff0cb07bda19@intel.com>
Date:   Thu, 15 Dec 2022 10:52:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 08/15] devlink: drop the filter argument from
 devlinks_xa_find_get
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-9-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215020155.1619839-9-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB6876:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c4e9549-be5a-4b3b-509d-08dadecd8684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAqhPCRtFrdWUwwyHUje2Rfh2RU55xuMujBi2ESdgTu/rFLZWtZUjPwALt0PBYETo8XdslLo6VxYrE5IlBJEMS8zISatVz2UkrDn7IfbkvgxCjNOnTuW8dgSLsfNv94c1hzVpgGFX+jAnE2gkkNpJf+ao9bS7yOpu1BPSZp1v0S7Rg9HGRjDyg7LR2JS5SWkQGj7QtQRvs5joCfE+jB4ZHRV+rSObtQiZj+MKmJyVEhwtIxPGS5flUXKOqgNDqyad8BkP/8Koq0D7lA0XiF5WCezJ5bQ/sEdZu/bM0iJJrBBuq7AwlMvAVv6S0A5Rf2gOMhVMnPb4d1/srcH7OnqhOi5KXwHdT+BejV7qQ+Qu/PQl3TZcm1O3LLdJd9MhOq+Dwx2tGSD9hVe7sHLQihwudU6j0sUm5ywA0qm+ekmv9bKlhDCGu/7UNPVSQJHXqAockUtV/FPHow24wEEN31ONIalE1qJ3FlfvQDt9cBnf77M83xfUN8fYSEhcWAiaWkw1p4CwYsjj+aZno6Fyv1ZUF6ysEp4W/UNyJQri5At1WIJUs+mVXgF6nAmW+BWQ83IgCzKJgxHmM8dwifaq+mq+k2zhhCLNlkEKQevkE9p5EQm08jSm81jKSfXu174IhQR9HwH/dz1zaKR/8icchVJpgIg1SBdkVzKGOx/x1v5XGsDB0j12IYPL+pAURSdRTcix/KZUVa02L1sTvvYWp0oXayCNNi5R8O0mA16BuzP3AY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(36756003)(31686004)(38100700002)(66476007)(66946007)(2906002)(86362001)(316002)(8676002)(82960400001)(31696002)(66556008)(6506007)(5660300002)(53546011)(26005)(4326008)(4744005)(478600001)(41300700001)(186003)(8936002)(6486002)(2616005)(83380400001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVcydU1FWXMrOXZqeDluT2RuTTk0VlQvWFVibWdJUkFhd1ViTDJtSWJPNUJJ?=
 =?utf-8?B?ek1wek9sYmxDZ0JoZWludXJJSzlBOGtuUUVpRFc0azlFN0N2Mk1ublFWclVV?=
 =?utf-8?B?bkRqeDZtK214VFk3VE1yaU9nS2U3WndVRlVTZ212cEFlNUMxYlI3bFZraVl6?=
 =?utf-8?B?eTlVak1FWUFpSFBJYUpMRUxwTmh2bWFDS2xyampwUm1uaVVvT2QvcEtjQ09y?=
 =?utf-8?B?L1I0NTJmWUUrL2dHQzN4WEtZcHhoNnE3VG9ERjRwakc1bXRwVGs5dE5wMVRB?=
 =?utf-8?B?TW1zcWY4OEpMWlBqakxHVnNOdGlrZnN4UkE5U1phZ1hoOUtkZ2lwL2RQVytx?=
 =?utf-8?B?ZTZpSjlqRVllanp3VXFaVXhIeUVGQ2t6ekMzVEI1MHEvR3VmbGNTU2xRVm5o?=
 =?utf-8?B?U0F2eC9tZWxYcDltdzlzeHhCYVNQanRvYUhTVldneDExOTQzTnBHYVZxblpK?=
 =?utf-8?B?a09JQzkxQ0g0S0tnMFBmTGtYV1dHSjU0cTRJbWJqc1NQWFpZQzdicG1wbnkw?=
 =?utf-8?B?cUdydWFPQm5CMnhQbW9IdjZjRmRhUFg0VEhtTTkxZ2pZekQ4a2ZxNWs1V0lq?=
 =?utf-8?B?NGtXeVBpeXVrVXRJNnRaczRPcnRKeG91Qk1JQTVBMHJXZ0o0REd3Y0F6QjFU?=
 =?utf-8?B?MWE1UWRUNzZsS2I0cUpxMkMzVDV4andaSkxVNHV1YkdTYWFHOUZrZkh4SE4r?=
 =?utf-8?B?cXVISThBMDNoNWxNS2pabFRLZlA2TkZ1VXMxcThHcXMyYzRKYjZSd25OQXBQ?=
 =?utf-8?B?VGw0SXplY1A3NjlCSWV5RHdXTGZsa2dPUjdrQndOdzdQOGI1eS8ySk1VVTJt?=
 =?utf-8?B?MDFMU29RRUR3alF0YzV3azhvaDBQRHBQcXlucElERkZ6Q0xTb2VTRTBhb1FP?=
 =?utf-8?B?TUR3SmUvMGtramdBNUNaNjdvQnFSMG5wZkV4c1gwVng2dHdNOTZMOWZ2T2Ro?=
 =?utf-8?B?VWhOSUlRS3RubHpxdE5JSjRWLy9wSVdGbGJXM3RPRS8rcHdvZlNWMTBuc09v?=
 =?utf-8?B?TXZhSDVZWmJaRXFhT3lTRCtmWFVJQ0RMMHFvSzM1TTZnenpFbnJDTjVmM1B3?=
 =?utf-8?B?YlNCdVVVYmtRVDJ6Y0FZSi94R0FVZW1PaVV1MStsUEV3WFhjam1kTTZubVZi?=
 =?utf-8?B?cGg4b1RjVDJEdmFQaVRpK0E4UHMxRVdIV3JGcWFocjRHQVlRYm9yYm4rU0hS?=
 =?utf-8?B?bk11YjhkVldtN1FkVEZCQmROZHhPaHlGTmJnZUdIZThDMlQxbWZHSW5rQ205?=
 =?utf-8?B?TDlxcmlBajJSUW9YcjNCcFlHVGZrdlNBYzQ4QkhYUWxaM3ZRSVpadU5pcWxO?=
 =?utf-8?B?ZHZJMklxb04rbjJxYjk0THhqcjkxSUhiTm1lY3ZYR2MxbkJ6RlczZlp2NVJ4?=
 =?utf-8?B?a2FvQ29ieWRVYmd3bEVSdGNobm1uQmpoUzZaaDB3cGdTaE5qdi9HblBma2w5?=
 =?utf-8?B?TjhUbjM5SnBnSzg1Z0UvYzdXYncvTDJyM3F0ZlJpMHB6K3N3NjZCVkFQUzJ4?=
 =?utf-8?B?ZGY1elNUTXY5MHZXWHRjb1E4Y2JHMlhqZmNqdDFHc3JFTmN2cnNESUppSFRa?=
 =?utf-8?B?eFVtSWk2dk1FK1cxR2RKQWF5L05Qd0JIRVBWSEpLVDcxdmdQRTNXeVpPR3Jv?=
 =?utf-8?B?cHVPMUVBNlEraURaRXAyb3VWTFJCR283cGNSRmpzYVRDTnByQVAyZDk1NmV4?=
 =?utf-8?B?akVQQ0xLcFJ0cTNoOWs0eHR0TTdPS2JHS2grSVBSaFZxUkdCTGR5alMrakpO?=
 =?utf-8?B?OFEydWZoREJIUWcvazFIOWpteVh2elBLR09tdy9SL2ZzSEltTzM0MHRHbnZL?=
 =?utf-8?B?b0lZWmQ2K0hqN29FV0h5blh4cWFjSUNTRFJQK2ozMkNsZjh4YjVwcjJPMkNQ?=
 =?utf-8?B?eXRTY2JhVEdUMklENDN2TDJjNHZHY1hReEVDQnhGeTB3K0VwbGFMbk5hRVBB?=
 =?utf-8?B?RUpXUUlVUnZIMFhUekd3VFJ1R0MxM0VVTjZITjRhQUt3L0NNb1RWVGxONS9l?=
 =?utf-8?B?czhQMk9WYWxnRDIzUEZjKytLZStKcHNQeXk2d1Ryd2NUajY3eURUTzNRcUlK?=
 =?utf-8?B?T0F1STk3TFFFQVVpM1JpYVlYbDhBWHcyN3QzN2tDWnBqRUJ1Vlg5TnQ2bVVw?=
 =?utf-8?B?TmQxd1FBMGVUMG5ETHlnRDlPVUZQVjJWOCtrV1lVZG5jb1V3aW5md01jNU1n?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4e9549-be5a-4b3b-509d-08dadecd8684
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 18:52:33.4545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmsq0N797+oy7Is0K+JgQj7ybQ9O+S0VwQQGfDPnh4y88iTFWU/lMqzLbVMDPZLO8IUKiyqIocswim3duo77Zj0LNWrZ4eXlLt161bPF78E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6876
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/2022 6:01 PM, Jakub Kicinski wrote:
> Looks like devlinks_xa_find_get() was intended to get the mark
> from the @filter argument. It doesn't actually use @filter, passing
> DEVLINK_REGISTERED to xa_find_fn() directly. Walking marks other
> than registered is unlikely so drop @filter argument completely.
> 

Yea, if somehow it ever becomes necessary we can add something back. 
There are a limited number of marks available anyways.

If it does become necessary we can always refactor this back at that point.

Thanks,
Jake
