Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BC45AB6F5
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 18:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiIBQzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 12:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbiIBQzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 12:55:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279784C60F
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 09:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662137742; x=1693673742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+SZSCr17E/osmj9Ub52oEZ5ke4FgBO3QBfgE2BPGYjs=;
  b=I3bsC86mnvxJoAvNw5deepbBRnsLdR9VxC/xldpcsqQD5yOd8vqR3U/4
   GzVo3RvpT7Kh6/6/qakm2NnaN2QHLcaIp0wswn1P/dq2NRmS7GP6XnglM
   bFI9BCaR4lhXEDDMsygPk/yEsXCnclqig0z1K/9eAZjFyjIsrtuYW0GSg
   r242LFwJW1WbhC0L5grXta10QCpFZcXnazCjGua0UpUvU/FaDMr2WIGzc
   cvrBQTsSUcbDQP1FHO9U42YBJrt03z+xJS2keQVHNcVAgBSq1X4b1thCy
   cj475jIwzVrqQZEDp8wZX3/vOwXQxo6IUsdVr778cxkUHS5QDl0Q6pNU8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="294760629"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="294760629"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 09:55:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="716582498"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 02 Sep 2022 09:55:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 09:55:41 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 09:55:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 2 Sep 2022 09:55:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 2 Sep 2022 09:55:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQUfmNHACOXGds+yqCA/QW1HlBvPWPYszohjVweEIoWwcmtfKZi3j3Dc7jbzmt/nquCcBOc64CfMTVfGRGodmy/QQki6dg61EfU91SbjlAbmQoI97rw7fVnaDD90AknIwSMZtpoKEHUUPk+nfO7w1Yor72rswBq9FU0Sctuk2ikaHeDzyO+zxy+JC/KSD7fY6txAh8OLrJf+sH+wpK3JDur9zYEBSn4SLMAwK6XdtFGXZpM/hzbOh6E7kBwscHrHyT1vfhpoQVIIQzD2/lw5RqVqHyHnYbcZf1g2jsoncSFIeaqH93zekAhaBDVh5TLRGFh/4zaFL1S8+Qx2gXgwHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4AkbcVEz0aPijhVM1VJ+lF28qDvqdDJRQIuNFHpTeNI=;
 b=fk9I9VpXkHBySy2eI6Rxd74Kx+ocPtyKP/J4IgmuaFU1jDHVN2DJ4HWnaTm1kX3Sxtsu5tCX/+UNAOkMeIw0S6LmTwSOSnqz3aZKg3K/5UDOrY2EvUVW/H5kgbaYjoVXtWt8yr/peowSVBlosf1g774R0Ny8O4TJ+p24NOB9DcEjD8PWXeTkypuRYj7W8LuU3sVktAPCFkHvKOmHQe2N1d+bZ7jz19fpH1gkjcyxLeujR3GMbaxyh/0g2dMbkZ4IYXj8MIYuLpMVhEv0HM6oIsoi0lyyCZbGwD4IqGRDjCSKJZQ7UOJ+RFK6sXSp05L3bg/lyBQkrSRfORAu8gR0lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM6PR11MB3163.namprd11.prod.outlook.com (2603:10b6:5:c::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.11; Fri, 2 Sep 2022 16:55:33 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5%7]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 16:55:33 +0000
Message-ID: <28e460f1-f130-7bf1-ad66-3b7080726b3d@intel.com>
Date:   Fri, 2 Sep 2022 09:55:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        "Michal Michalik" <michal.michalik@intel.com>,
        <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        Gurucharan <gurucharanx.g@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org> <YxBHL6YzF2dAWf3q@kroah.com>
 <20220901131835.0fe7b02e@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220901131835.0fe7b02e@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d408f0ac-763d-4e67-0a24-08da8d03f316
X-MS-TrafficTypeDiagnostic: DM6PR11MB3163:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dnf9TA1jcXZGfARJ1g2nPYr+bX0eAuCH51vc5eTX1aE8e65cc8t13s8DPR0OOmXqkRVcEGT/vY0Bvpk2iUTCsK9Iv+gdzMekrN/am9iOz2zzqUI2fZpfvYTWbCMiacwv21bZhjMpkGUKMmRm36Ia9JH3R1w1y68ve4MdGLcqH+qh94l0XXLnwh7bVz/X+gj73PUMA0VQqOJR9MMWpzcikP3EuZNJWJpUBAeA228XZrd1/ZhjHjP4lyTWS4mFw9qmL+cjSx8Mcl7WSHQHcQfJelL5L/DeUyqBTs2ZdJXIzmQ9haWanZ8JBzuTnrCrEKZEwlJoAUxBAtV+MNNyPFZc7pfwo0HrVZspfsamU6ooc/pxjEd26lXC/6ZZsgqGeKlxn91Ao+M3OFVnFDaky9vpJvqEHQgx+dHMlNw8sVl5OgiWOve4royYs+VG0ZHUU2mRaCq6Flb8ReG9izt9fKZVIS8YeUCw/prf05QdikWPIcALHE2Emhz8u0CMzUVZaGaC3nNYk+SA7H7EZtExVuBRUF26I9BVEiOxzkIWZ/LsJgFF0efkbF6UFLm8s4tG/2b8/0FDo6j2ojB11ymyHAPGVGCerZZbHn7BUfXy0Wo8Q9myzVhnwCqOw2ZvFj8xVQ8NhKHQcG7zTIZtDrB2ufxoe8Y9OxVZwEZoA21T4Obit7e5mpKrjfsR4bXaNONPos+49VL/IDofRmY58FhpEHOVYhO1thoOpqDW/dGQnLoTZkCvlaujOuawzA+33FlUbDmYYf39B9Hn/n1V8hAT8GjHt3fgVmk8PlDN2JZe5/xSNGw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(366004)(376002)(39860400002)(316002)(6512007)(4326008)(6506007)(6486002)(2906002)(26005)(53546011)(5660300002)(31696002)(4744005)(8936002)(41300700001)(478600001)(82960400001)(86362001)(38100700002)(2616005)(186003)(66556008)(66476007)(36756003)(54906003)(110136005)(8676002)(31686004)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0dZWEJaUTRCZXgrSys2a3RjV1VockhQRVZ4ODR6SFFKODlXT1I0V3dkZEdj?=
 =?utf-8?B?K0d1ZS92TTBpTFR6bm1YTzExekhkN1V0ekNqY2NzeWNSRDRRL1ZVLzBRV2c5?=
 =?utf-8?B?QUQ4aVR6Mnk4WmRrbEtsRWhlT1k1eFQ1c21kN1p5Y0tBeURRVitkbUl0UGpF?=
 =?utf-8?B?TGpaMTZEYk5QTlNqSXM0b0tjWWE1Tm5Ed3lCUUJxYzhKc3hsTkR0UFJXeXgv?=
 =?utf-8?B?bDlIZjIvcitIcmlDMG13SFA3eUhTTm40NGdpR2pnZnRQS1kwa3FDSE5FOGMr?=
 =?utf-8?B?UDd5WU52aldtUXFqQmJFd1ZEcUNEc0hrY3BUSnZ1VG5oYjUyVUV1SFpidjNt?=
 =?utf-8?B?QXJ4QXBDNFhGWitnNUFEUDliV1Y0Tm1LUEJCVzhmMm96dGIvcER1bHVJdWRX?=
 =?utf-8?B?TWkxekxuTmxUdFUwOUIyQnlzSVNCNUdoWWoxUkgycXlHbkpnSnJib2hFU2dZ?=
 =?utf-8?B?cUdjUmE1bjZWditCOURVNVkwV0gzalQ4ajNwK1J0UHFna2M5RWpBZXd6UFE2?=
 =?utf-8?B?a0RQVHBuQk0zNy9hOEJNNW5RN0hyVDNSbGJFWmw2U3VTY0l2Z1o5ay9WUlow?=
 =?utf-8?B?czBrUkZSL3RqYlZCZkpBeXRZOTBJOWY3LzdzVERoSGFDTEVSRGZsL2ljcG81?=
 =?utf-8?B?dE0ranQzSFJXNTJrR0hlWEwvN251Ym8xenMvYURzeldtelVLbjNnemFZdmJk?=
 =?utf-8?B?KzNXNTJPYi9ncEJWcUtJQzBzSzVoOHQ4NmVLS2ZFcVhyQVNTeEVGNEY1bmRB?=
 =?utf-8?B?bExiei9vRXkrdVU4MGxuUkVzdzhzUmR1cTg4N3FPek1QSWNKRXpiazhUZW9Y?=
 =?utf-8?B?cDlXZnBiODAvUWMzeHFhWU5aaUdkTkZpM0J1aFR1aitTQTlteXVPc2VWeHhZ?=
 =?utf-8?B?NVhJNWVKckRBMlhDcEJyV3VMZWRqdkhHdUFUejRCUDgxYnY4R2l6VzQ0Wkpu?=
 =?utf-8?B?Z1pVQnVMTjI2WGhBNHJ6UUlkYjh6bTh3SVJQZzI0eEJWM2JTQVdvRjc4Qno0?=
 =?utf-8?B?ZElTdEVnS2tMQzhKWUdJazNDVUVNT3hGTEhFRjlXM1ZBNkJLcFNyWFZVcmJh?=
 =?utf-8?B?TWNBVjR6eHhVQTljWUtGWCtMWlZnR2N2WnEwejkrTVhWczVpOTJXNW54RGpv?=
 =?utf-8?B?c0RUZUQzaWplVStFR3ArcEJBN0FaVHRZYzM5bDVCUHB5SkRXNzIvdFNsbzF6?=
 =?utf-8?B?VGp3UDNMQlVQZk5XUmJlVTJkTHFNazhOYzlCVGJ5S3FWUmpla3VYK3RVS1By?=
 =?utf-8?B?MHhyYldRWWRkWHZmSU42eFZGUkZXNE5GaS9vSzdNYTVSeVFLQ2h1djlUUWZz?=
 =?utf-8?B?TnczNVNhUlNzS3Y0ZUxZdS9QeWVkd3hCQkVYN1dLNWlrL090NDgzNWhuajM2?=
 =?utf-8?B?YnJ1bjBYL0REendhaTVXWTZhb2xSdzFKc2kvN1hiazVMSkkzTzQ4SXJCaUFq?=
 =?utf-8?B?NEVMMlB5cWhCaXk0L0lTR1RJeENaMTJ1bGVyNWcraGFQRXBXWSs4T3dyZHlY?=
 =?utf-8?B?bVVJSCtBcERZenVhdkxqa0V3bEdXODEwTDNBeEtlbXp1U3NqSmpWZ3ByQ2Jq?=
 =?utf-8?B?U2VmN2RrV2FDclNKT0w0NGVSR1IrZC9VOFZjMDl3RnVTdnpUMGE1RDZ5MlNE?=
 =?utf-8?B?R2lXMzZZU1psTjZSbnVnS3FiM1NrUEcwVWt3cGlHbSt0Um9DWEY2VlhMeDVD?=
 =?utf-8?B?eUdDdmNvZEk3RkxiNHozSDhpOHd2T3IwZTdYSmxEZHBVL2JLb0VlS3Y1Tmps?=
 =?utf-8?B?RjM1VVVFNzRyUXU1TDJVb2xKTk5QRzBZNE1kUmlDSWdlSWlhQVBZL0JzZ2dN?=
 =?utf-8?B?eEYrRGRzRFZuZUxLOUtTN2NLdEQycG83eXozY2pLbW1JTzJpenNxdGdCQUIr?=
 =?utf-8?B?Q0QyYWNMT29MWGFXMFltQlEzbVdRcEpGR0dvZUt1QU1mcVl3RE55dXR6UlNO?=
 =?utf-8?B?MzYvWU14RDNjdExxdVcyMEMrd285dStCWlNVNHEwMXZPbnJXUG9JRFVwaU5N?=
 =?utf-8?B?Uk5TUjZDRnVCVmlzNUlSb09HNTQ3T2wvNzRyN0gwdmRRYWFnOXNkUisxN3gx?=
 =?utf-8?B?Q2lOQ0d4VUg2ckYzNTNDTGZoNWc3dGZCcTg2Mm0wZzZhQ002VzhEblM4ZnB6?=
 =?utf-8?B?TzFoVzVpeGdKMksvbitkYzZlbTZ0aFN5K2szcVc2N1hMaGx4dFRrbHZDZUti?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d408f0ac-763d-4e67-0a24-08da8d03f316
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:55:33.0791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awp6k7eBU/B/+263EzQdCn4/q3J8wOmFyTYz8spXbAM9vOpUZN0j8yyiX8z5cCEchvT24nIk60Z2Gl9nxCfC+/KllgROg2yTbMmLnv+o3DA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3163
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2022 1:18 PM, Jakub Kicinski wrote:
> On Thu, 1 Sep 2022 07:46:23 +0200 Greg Kroah-Hartman wrote:
>>> Please CC GNSS and TTY maintainers on the patches relating to
>>> the TTY/GNSS channel going forward.
>>>
>>> CC: Greg, Jiri, Johan
>>>
>>> We'll pull in a day or two if there are no objections.
>>
>> Please see above, I'd like to know what is really failing here and why
>> as forcing drivers to have "empty" functions like this is not good and
>> never the goal.
> 
> Thanks for a prompt look!
> 
> Tony, I presume you may want to sidetrack this patch for now and ship
> the rest so lemme toss this version of the series.

Hi Jakub,

Yes, I'll drop this one and send the others.

I'm working internally to get responses to the other questions/comments 
for this as well.

Thanks,
Tony
