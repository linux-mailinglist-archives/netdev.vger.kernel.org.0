Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38CB5A8989
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 01:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiHaXhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 19:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHaXhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 19:37:13 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35EC792F5
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 16:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661989031; x=1693525031;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZlVLonYzZcOnzBeoCdqsCpRCjOxY62mjEWaEM6mhE2s=;
  b=JanqfToz3D1swqMzD7NSE16iVBB2YMuxWzLg0hrasp7A/sH+zq6GkilT
   +1CkZPuYdxYPIyBh4ZvrHmQGlkoCViHZ0ZFscmcboMWJTDfElGzYpFUNn
   zV1aMr4/+MO+cLFzscMNDxbGV+Yx/U45k/Hkctg2KVM4+c8QMexC0/5tz
   xGIDJaI/s+oLqZlEWLPPaOhtgZRzCtFAPie4b72ZdHfs4u5UAnrWxPWjA
   vjvgNmAPm+b/MkujvJfgDoJkWO9M94dacacIuwsXMUQnq+A0C9LhzHcu/
   hSxMctBM0XHBzZsjEaa+GEGCK11VuscsXtxjaeLrA1tE6X+y0RHT1C26O
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="293152873"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="293152873"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 16:37:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="589228522"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 31 Aug 2022 16:37:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 16:37:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 16:37:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 16:37:03 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 16:37:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L323XzLtel9aSnkgY9MEcXXLAO8Q+xRnDTiBotS2KdNyEKhtL7up/jM6/m/qKP+pdjF1CxNqywkDDl4x9ARHrFA3csN36BAhgPKwRNh8MI3Y27NEIxLgkPeXQmuLPgtF/cwszZWq0zFfQJUMOxLunCFenXIAsH90QDygD8R9zmFfr7LjUH4beXfiaG9HThkILIAvFlS9toV/19X28V8xW8fl3zApzYrEtFBiqAVuzikvIxafkLU3dHvQPcqOeYtjV8/S3HauoAK54QrZIWdqpZWSdvAEwvLPcBBNqrszS6nOJrvJq5tib2oOdmJzHPumKNmVoDd2EVk2anrPUXhiKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlVLonYzZcOnzBeoCdqsCpRCjOxY62mjEWaEM6mhE2s=;
 b=f8M9Vb7lmVzcMiNhGEr0XxBQa2t7qnV2GoPahu8blW4Zgyvyf5Ei+juWQZvcyan/W1DE8C7idJgZLtW4UkqTg60F1xnGkCmCKw4SqF0Mau6X9lM0GKiJtfiWtuEIijCtZF9AO5W4fTt97GcPcVsXMLfJPKFFjLGsWFRm43sqAjEDyNjdYtAbXo423/yjlxLUxxISLY84+A3P7WL6b8/1aIxdrH8Di+ZrIwy0e2sMTgEoJSVAsvT56xWE+pANndCtQXf+L5XmKYSjMzmZk1F6kmHAWi3DRMgkdsA2fHUIZTZ5AUTQKdPrCywvwgN39I+mbm4GzxfyA6Xh+nVJhSFWbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SJ0PR11MB5629.namprd11.prod.outlook.com (2603:10b6:a03:3ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 23:37:02 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5%7]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 23:37:02 +0000
Message-ID: <cd67e60e-6907-755e-38a9-a53c29d8a7c8@intel.com>
Date:   Wed, 31 Aug 2022 16:36:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        "Michal Michalik" <michal.michalik@intel.com>,
        <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        Gurucharan <gurucharanx.g@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220831145439.2f268c34@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::22) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9ce13ea-c771-46e3-e4b3-08da8ba9b444
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5629:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l3kO9znPJW4hHSN4eYd/GrsF8ljM1VpmRb8og7+6wWgkSTfZka0O8G6kx3RuwDls43JjkgRrleDtVO2febYXtQdIRPk2WGdM+M8nVzPWu0ZFsO5v+vFR9ZpTDGpHLweAD6gBERs0HVr4YxT5IJiBzC5Vxmkh2i5Hd52PxhTt9yZZ2KdBqKCcT5jgt/4f3xR56t91Ln87+G+hfg7Pp7aEiZBtGp1LNcfbt8XVY+fN+EDPQSSlJ+qQSkdURMRb3THg6DfUnx7omP9sguEL9/vt0r1RPDwtd9Lmatz41XLXisYo+vYPAXOWZo/wmY5WvSHRUdlqpYfQAuBwVA0h2mcMGWg4u6sMbwXN7kf1GRrE4eVX4Yh3jL09yCZGSz4SHtEemwCNWD+OmXeNozmC1p4D6tLdlVU4kb3BimUMOyayhkfL/CBB/Zs3hq+qm6zhk0WsnrPoOsw1xkoAxnTN4ZXwbBglj6mckKvf1QwyQsoSQaA8r1IskHgRI94IIS8zQPh12j1RQ9ocu2+ZPGYaZNzY6ZTGlxohCzXsYs+yMCfctDDmT277VNcicnkK2vMusMyVchyxdchu9LM0cUZ94kpif8HUe58mmQROMOBUpyeAtoL1t3CBpYA/7zMg1IR939IrllGFe/vNpNVm9QZgGuNHxL0pMEVk9DbOzKOxroGF46kp+ETuUrxY1RfU/Rn2RZ3rnXbP4JVU9tQwagR79d8sgLOPfhSaLJ0yvMKjFthLPJEt4WO5JXFY6f/fZCTXgCEboSoDVmBLlRs+aGjWUmicdOddANPDt0DvMWIefDa+7S8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(366004)(396003)(346002)(39860400002)(8676002)(6486002)(41300700001)(4326008)(478600001)(66946007)(66476007)(66556008)(2906002)(53546011)(5660300002)(6506007)(558084003)(26005)(6512007)(6666004)(8936002)(31686004)(316002)(6916009)(86362001)(54906003)(2616005)(82960400001)(36756003)(31696002)(38100700002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzNMS2V4ZStkaStuVzlMdjB2SWk1eTFDTnR4cDQxRzdHVlpFZzlrQ2djSWc1?=
 =?utf-8?B?Ym8xbUs4UXdRSXdnbFdCcG5DNUYwUk9ma09QNjhWTjcremhjVG5ZUTFWK0dV?=
 =?utf-8?B?NkxIaVFvSjdnRjZJSis4alJKMUR1dzRac3RkZkdaMHIvWXdnbDFtTnFWdlJz?=
 =?utf-8?B?YXV6NXJrY0orZG5aUlFaUUQwUjJyck1iZU1HQUI1QURPZU04eGEvZkJRWC9u?=
 =?utf-8?B?TjI0RlRDam5qVWppMWRkRGZNcE1UaG1LUnJtdUg5OTNRcXZkZmhLc1ZnbzdB?=
 =?utf-8?B?Z2tZMjEvRXVzcEkveFlUd1I3NC9wSUVTdENFN1NxZnU0SHViaDZZRS9udkhi?=
 =?utf-8?B?em5DMDI5NlJzTkcxSzY5dHJkSU5LQ3NlMk5Pbk9hTnNSR3NndUZFTWErWW1J?=
 =?utf-8?B?TUVsUFA3UlB4UVE3VGlkdlQ1TlloRnVsUjRORFJ2aFFBdVg3bUZQelFpKzR4?=
 =?utf-8?B?Ni9FOGFFdmdTUGRONWJrY1p3RlZLeVNMWDE2RHVQVDltSWhVZm5OMS83aFR2?=
 =?utf-8?B?WVBvN2k4enVyQktkYVFRUzk2RHZsbC95Q3U2VEZELzA4Nk1IR3hCQlBEcWdJ?=
 =?utf-8?B?blUvWE5IRkwzdDR2cCtUNXRJMHF0Z1I0aCtYYno3akRvZk5oSi9odkcrWmpi?=
 =?utf-8?B?UlBxN2h4elY2KzM3dzBhemszWWpiL1ZRTy9zK283bmJua0sxU0Q3RzB4ODJa?=
 =?utf-8?B?UzZJV3RnaS81SjRnb1pvenRzS2Z2SktRRnVsdjNzMFUvWUdGN3N1MzFpTHRu?=
 =?utf-8?B?R013dUdvZFE1Qkt1dkJwWU16R0p1L0x5UDhCUU9aQWRLL0g0QWZWNzdhQVpQ?=
 =?utf-8?B?bGNQeDlhaHpxaERRcmc2SDJaek5BYjE5bDkwTE52NEtHcXdOWC9RYllLY1JM?=
 =?utf-8?B?eWtRNmxXT0pFT3VVam1tbXNib0NLejNyeXY3ODZOb2pmM3VwMlJZVlhkelRS?=
 =?utf-8?B?YTFkWllCMnJTZ081L0lhZVdKY3dKbFptR0YrcHNkaXBMSjJmZEdlZWdMYjh0?=
 =?utf-8?B?aUpIWVAwUXVXZDFUc1o1TlltZ056QVg5bFlTQkdQSzQzdlV2UzB4VUdsQ25s?=
 =?utf-8?B?SUpVVFFnS2RidDIzNG9Pd2Q3NGJWd2xBYnJNMXdHRGx6NHU4TWhWdDhxUFIy?=
 =?utf-8?B?S1RCREpvSVVrTFVDSVRZamo3MHdiU0wvVzVNT0FvUlpkWmtLSTRpWGVpRk1P?=
 =?utf-8?B?WlNXODRBdEduLytBVzFDcGRxTDltd3ZkVjhFRC84TExKcGJSSTZYQU1tZEtJ?=
 =?utf-8?B?QmcvaTM4OG54ZUlZcDNNREpRMG4rRmovTmtMSGszK3RiWEROR2xkaWZDVVRI?=
 =?utf-8?B?M3RGT1VtcUZDY1dwWU02UlZ0dlltSFZKSE1pVVRrOGhqOGlFcnZ6YVhrSUFI?=
 =?utf-8?B?YWtDNkZ0VzVlWHBJZU1UeW52Mm5tSURiLzdZSWtmWktVa3ErUkxBS053ZFVn?=
 =?utf-8?B?cXFLOVlGdnFWUlE4QWk3cFFJaTVTRjJoTHA5TGZVVGM2R2V1dzg4TExCT2Vu?=
 =?utf-8?B?N1VkMzU0dDIwSTVLckc5NWhsL0tRQy96aGRJS0s5RFNiRjRwODJ0ZHBkSWpk?=
 =?utf-8?B?VzZtUEg0WmtsM2lKMDZuTzg1YTFpaFBxbFhrWC9oTDVmVkMwU2VCVFd6SlFO?=
 =?utf-8?B?bllHZkNUbFRNa2IyMDAyc2t4cVl4Z0JVbUFvdlFGT2pkKzBqTjFTWERJZ3h3?=
 =?utf-8?B?UExWL3ZNL1FYRW44RzRaYTdad1dQNkliM1pqN2RnOVJpaXA4OEhQSjI1ekJ3?=
 =?utf-8?B?bTdoWFlFSGpiQ29vRGhOaXFubmxKODkvV2tYVk50VGFzSkJzbGdISHVrckJk?=
 =?utf-8?B?a3IvUjNEcXZkNjJqTllsMForMnR0djRlWFNYdE96eEF3YWRna09vZUw3VzM4?=
 =?utf-8?B?UWQ0NVc3RWpVQ0xuc3ptWU1tRFp6ZWZwWms3S210bzV6WlVEU0FFR08rRXVC?=
 =?utf-8?B?SGpqS0RMc3IrU29iSDhqR0xPRm5jazJxUk4yU3JsZ0xoWUlSSjJSUHV6d2di?=
 =?utf-8?B?VVp1b0JSWTZ0QWcwTCtoays3OFVrTytvdmZjcmZRUFhkWmhXV1NHOGYwbzFo?=
 =?utf-8?B?MTYxUHBuYk5ydHRwZWhJU3E0WVpNVXFLMjc0T1VudWVQZG9IbXV6S3lkMGE2?=
 =?utf-8?B?NTJLeVpEdk5uWE8reG90SkxuanVSTWV5b05NMnlDVWU4c1BwU2JxZTF2ZTk4?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ce13ea-c771-46e3-e4b3-08da8ba9b444
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 23:37:01.8994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvpT8bXQAyBpKieUWA9anEq1QFAUEpKLE2+DgNCc66CC8p7Pav4sI2ePNjeoeRi6bzrZMnOxI2Ox2PT6jHRVtT0HX66ruMR+2/kXcWL1XvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5629
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/2022 2:54 PM, Jakub Kicinski wrote:
> Please CC GNSS and TTY maintainers on the patches relating to
> the TTY/GNSS channel going forward.

I'll be sure to include them on future patches relating to this.

Thanks,
Tony
