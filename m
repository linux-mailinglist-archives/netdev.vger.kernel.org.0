Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1D46478FD
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 23:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiLHWmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 17:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiLHWmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 17:42:10 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7CF10B43
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 14:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670539329; x=1702075329;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ommgQwdjZ5FmeJULF7AQ++4ebRXchlQGzFNq2jRbOQE=;
  b=HAA8FUqLFB/t6/Qxql6zKbxXvKNH+pSCEr7TzG70PQlpnxq2Yc+RepiE
   Kx6ehqis6oz2wVI/GeKZ12ul9Fl8/KPcXE3pZF/eLYYpurFKGdcrB99Cj
   JeURpaMnOQVmfADugjSZ2vKHFfPyymK4uxTlxOkNFgz6m/XIj4z4Ixonq
   bo5Q1TWuTG1PO+h9ifqegHYLVPQl77PfPnDR6X3gwr2zDjwW61JZRVu89
   Ce8d8kJ/912CSl667yWXokXfM8E0lS551hZeCUTLp6/1naPEHCLxnAqDw
   ljjRnwWAR3fz7OyKYhDD+YWcEWUEfExjnC6S7/UoKWPXjLZYl9Zrk0+f1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="381630409"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="381630409"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 14:39:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="735995839"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="735995839"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Dec 2022 14:39:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 14:39:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 14:39:30 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 14:39:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcpQNa+V2B9MqERm7j1Dx26osuQ4dUgE60Y7Kjob8xQerHSycZq+p/nUngBBZPMMjwvfFtYYot45F/fOzfhr7nx1N8Ux1QGSuULMa1Cxp/OI1OJ871HyKkIKd0EbgO2p0pEO6D2m/KKegDprLbtR6tDgHHXzvCajL6bdTUZC36x2SmoOHsyzA7sRHcWutBCxQlaGWMgjrC91hMH6lzUb3r/S0BJiN+OrQOM4Rc0dXAhJ6VaA8AV/EPRhqvuz0N0iLfa1tTfGkKAP4Lcq1jKxtzZQpEZoA1dYgTt9D5mo9HK9xAtmEgADe0rBv8zT1WbCuonPqJnTyZyS3vQleA2AYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EekKiZrkWTHi+m8HrxHBKZ+GXLDG5xm3ZtQRV5QOflc=;
 b=YF539anAkKtL5o+xJ+CwCqaLlGLcAVDlfge0nq23Hv+CwoUeLlw+OJIzlCgUe9tcdU6bOGw98F/zv161Ld4dRk5zt2quEWjG+dYaXah3y32o52bcwMJMlWBXjB+uEIsLHd19FHe8UiR7m/hH5UndC4K7VRyqCpoVYg1jRjpAe//BbiFgMFEO5GY9w5MCT/goSNAuCGixQgIPlqdjygCWGd+AhRDGTTrHukL9O7EUpCqhdrXo0BRYWhdbpViqnrZSaZZ5mqyfvhVlk78zts8IFWnwXExbiie+GJb3epf6oJa1CFSteHdZ4mcLtPGXmuzQH8Y1/gErJWLmrpF52i9vcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH8PR11MB6732.namprd11.prod.outlook.com (2603:10b6:510:1c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 22:39:27 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5857.023; Thu, 8 Dec 2022
 22:39:27 +0000
Message-ID: <b062430c-b827-3ea7-7836-ebf3aa5b0936@intel.com>
Date:   Thu, 8 Dec 2022 14:39:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [Intel-wired-lan] [PATCH net v2] igb: conditionalize I2C bit
 banging on external thermal sensor support
Content-Language: en-US
To:     Corinna Vinschen <vinschen@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
CC:     <patryk.piotrowski@intel.com>
References: <Y5GjAu4Uu6mg9a1I@unreal>
 <20221208112104.2769660-1-vinschen@redhat.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20221208112104.2769660-1-vinschen@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0124.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::9) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH8PR11MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: cd73371e-b4e6-4322-54a5-08dad96d0fd5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r1LrKq4R0sVpILySkeQDZlBBne1Ot0Ls3/u22dxXXYH0x+P+gAFjigXOFADsQDB5ny2qdM79/h+wnRk8Qk1faMtiUGIebpCSiK45ncDeMW6nzrStPxpXxe4WXQ0EHNLsZBevMjF2pGJmRx7ojxAE32rP7sl2Ys5D2d2glqJJ9MkDQiJGt79MacDzJUN1j/Jc5qt8IWHdDrGOBxFNy2YJCzosL5d35jZPN753ueIoH4wKPscMZRVzxOODyleNIcAV9AO7OkKMVhzKe90k3AobQGq/t5g1apgeNvctFzDtrfL5i6bxZA/ILxlhkoB9fjnO+J2oKJ3wYZNgiEtiEko1rT6DXxfLbs/MEENoTdQNGNBaV6k8qVtCo5jUUpCPsczENDdH/fxwXF8XO2Xt+MkirA0kfXp9/sfubjv60ReYXQaMdETiSgPTzlIhslE9WKvGfbwmcvCsebClj8zysaedeEJ0HQ/4K6mWb4PnabfqqMNwfBmJspt1cA1yc+AeYBr49wffmWw6iAPOgI+nhtIEPo9UPq+ik0rpAUTfmU30caBxCcdxAeng99iTt/kY/VTUXJbXMrBEXtT64OkYzsjfZJadpUJaxgb0qpwhMCzweScGeB6on8xTvaFbZFqPHfZcUlOAkUUh7RtW49Pg/isdi4xwDYSvybT7kSFgUkfF780QtIwfewR9v8X5hcBdaDkh53vKoKKiGOCVk12GlksvtnP9p40bqbw1fjxCXlGom8sTKT0xpmhVWLbbSBumoI1b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199015)(36756003)(31686004)(82960400001)(5660300002)(38100700002)(31696002)(8936002)(4326008)(8676002)(2906002)(83380400001)(86362001)(478600001)(2616005)(41300700001)(66946007)(110136005)(316002)(66556008)(66476007)(6486002)(107886003)(6506007)(6666004)(26005)(186003)(6512007)(53546011)(187633001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHRqdUdEeTBoMGRWYXYxOVU3L21KMlJZRDJxNE40MmRURkJxUUVxZEF2WVRW?=
 =?utf-8?B?eW11akFhRWZEWCtJVWpOdDRVNytwL2RnOEdlblc4SE0wNHMyRTZEeFlBT3Vx?=
 =?utf-8?B?YS9TS1RjeXhCTG15eVNTcjBFTzI1dDFVRHVuSjZ0amtQdDhaT080TUZBdVUw?=
 =?utf-8?B?US9UME4vd1pzQWFTUjBCODNtYlR4anB5UmROaHg3dytrQm1UU3VsaUFJT0NW?=
 =?utf-8?B?aytaSDN4c1hJcDlKc2ZtMklkUXNtdE9yY2dPdXpDYnVoTGZqZGlWNzAzTE5y?=
 =?utf-8?B?ckwva3EwcTR0T2hDOWs5UUNabU5SS29obllPNEQ0RFVvdEs5UExCSkhmaEp6?=
 =?utf-8?B?QlJFYWwxQUh1VVR4b2JPTU5zTUZrcDNwZ2RpT3dTNUhBNGRNWmlWVEtzUHRi?=
 =?utf-8?B?WTd0SEFra2tJZFQ1Q3NNWnlwZFBUcjlESjhUQ3JuNjBxVDB2MnQ5OW9lODcz?=
 =?utf-8?B?dmNjUDdFMGNGZG00ZWt1Z0hKQ0x0bXR0aVE0N0s4R3RmSThtWVVaaFQrSm9i?=
 =?utf-8?B?Nm5oOEhvMkRuTXRnek5HbU5uS094NVZ4T2RyRjRpU3ZPY21DNjhlT2djKzNO?=
 =?utf-8?B?M1I0WDFxcEFaVFI0Zk8ydkxyZ0VoNjNtYUEwQ2E5aVVNZ2NOT0QvM0JaQlM5?=
 =?utf-8?B?QzU3VjVWUkpGR3lRMnNjZHZ4aE9haEdza2doaUZ5UGphUkFnSDhyMDlmUE9h?=
 =?utf-8?B?ZS82dHZYbmFGa3lidE1JTnU1cjhzUWlGajlkYmlYd3BnVTV6UXNCTXloYytU?=
 =?utf-8?B?UFk4cnYzMnNwMXFyeGFuQzNBQ1piK1ZpYXNTN1F5T0V1MGE1Z21SMzJ3S3Jp?=
 =?utf-8?B?eHJyeFFiYWR1cW1CaVg2RmN4RGpZZWZTcCs2VTB6WEtETnVEeTNrSU9ZNHdx?=
 =?utf-8?B?ZTY3ZlhROEN6bnRpNlBUT0g4dUtLZ01iSzZETWFxSnBSQUJzNjE3ZVRlbTc4?=
 =?utf-8?B?SWM5WWlKWGtOTmlLaERZQUJQYm5JRkFnOFNCbjFVc29jcUZRMVZTZlZ2L21l?=
 =?utf-8?B?aGNJWmJjcmNHY1UwR2Qvd3RtZEJGWXptL29Td1ZFVXNKbDdoOXpMMkQwNTRC?=
 =?utf-8?B?WGNVVk9hV1hwSGptM3VtRWM5QmFMbE1UbTk2YlI5dlFHMzg2S0R1dWVVRHFW?=
 =?utf-8?B?aDQ1V042SUVyeDFsTElQcG5OdTUydUtCbHU2TkFtQk5NTUtvMHhBdGxITkZ2?=
 =?utf-8?B?bENOdndqMUF6YmE3MDdVSWtmQ28rSnp4d3prcHk3cHZYV3hxV0owa0FYRm9Y?=
 =?utf-8?B?b251UVJBZzhpZkhxMFdudzNNaDNOdVhwOU9XcVBOSW9rcmJRc0YvTUVLUnZ1?=
 =?utf-8?B?Wm5CVFFmekF1eFZrdGRsMVp3alBrWWdhTVhrOGJ6c0hWTHZEUzg5TGJhR2dQ?=
 =?utf-8?B?RkZnZklGdU0rSFdGVlY4U1NjNkNMZ0dTK1hOaXVuR1oxWWxPaGprUzNTNito?=
 =?utf-8?B?N2YyRzVzR21KcHBncnRCd3BKaHdIWVNIYndwRmFibDBjZGt6Zi9sbEVZcFBN?=
 =?utf-8?B?amhWNkViQUVJaWhFUnh4eks4ZE9nenRkSlFQTytTenhyZk9vZFMwS2ZSRWJT?=
 =?utf-8?B?Vis3Vm54NUx6dWxJRlAraGVzd1c5YUttWmhHZE52Tm04YzhTZ2NxVGFxa1Ra?=
 =?utf-8?B?N1BOdG9sQzN1QVZlQm5LdVZhNTFBUno0MkM5L1lSbVhFS3RPNVk3U3NEaDZS?=
 =?utf-8?B?NWY4WDFsVFhrNjlhcTRRSEwzaE15elRXYzdGVGNpTStJc1FrY3FwTlFEamtO?=
 =?utf-8?B?bkpjTUxmRzRvelRyb1VLRjNnVzdjMzFNVEVPVmRHeGt0eE1ITjZPZ0dTQmJk?=
 =?utf-8?B?ZHliSys4Z1hobUo2M3IrdXV0Z3dxVExQTGo2Sjh5UmlBYTdkbGRJUjZTaU1N?=
 =?utf-8?B?UVAwU0VPSzloYjFjL053L3dqeGdrMDdXWEJHRFB4SytZcml1RktmSWtKY1Vy?=
 =?utf-8?B?TmlMTVFueGhzM0UycVZ6TDJNRk42ejR3WjkwRWVTbHljdDJKOWVLTGsyWVJE?=
 =?utf-8?B?WElwNWlFNjEzd2FRV3lKNjlXYTcrWGF0UEZOVHhHcktUMUg4VkxxNGVtTWhv?=
 =?utf-8?B?U0IrMWN6eVdwaDd0clB0TjcwcjJIVE9Sb2grQ1l3eUUzMzZ0OWVQbjJrWkZE?=
 =?utf-8?B?TDdQbDMrZmFTL2pJZisyaXNBVWVGV3Z0L1VrNzZMejhXTGd4MDg1K1M5RHZr?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd73371e-b4e6-4322-54a5-08dad96d0fd5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 22:39:26.9929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkZ5j1aPQ6kJGJ/JxM7dfzo/wJMW+yPv5WgcAnPRNgbmRf1sh8tcEKzAvodg5MKkovgOP3kcCgxeTNOqxs1U9ceM1m2MOnXQMV+qngJPtI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6732
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

On 12/8/2022 3:21 AM, Corinna Vinschen wrote:
> Commit a97f8783a937 ("igb: unbreak I2C bit-banging on i350") introduced
> code to change I2C settings to bit banging unconditionally.
> 
> However, this patch introduced a regression:  On an Intel S2600CWR
> Server Board with three NICs:
> 
> - 1x dual-port copper
>    Intel I350 Gigabit Network Connection [8086:1521] (rev 01)
>    fw 1.63, 0x80000dda
> 
> - 2x quad-port SFP+ with copper SFP Avago ABCU-5700RZ
>    Intel I350 Gigabit Fiber Network Connection [8086:1522] (rev 01)
>    fw 1.52.0
> 
> the SFP NICs no longer get link at all.  Reverting commit a97f8783a937
> or switching to the Intel out-of-tree driver both fix the problem.
> 
> Per the igb out-of-tree driver, I2C bit banging on i350 depends on
> support for an external thermal sensor (ETS).  However, commit
> a97f8783a937 added bit banging unconditionally.  Additionally, the
> out-of-tree driver always calls init_thermal_sensor_thresh on probe,
> while our driver only calls init_thermal_sensor_thresh only in
> igb_reset(), and only if an ETS is present, ignoring the internal
> thermal sensor.  The affected SFPs don't provide an ETS.  Per Intel,
> the behaviour is a result of i350 firmware requirements.
> 
> This patch fixes the problem by aligning the behaviour to the
> out-of-tree driver:
> 
> - split igb_init_i2c() into two functions:
>    - igb_init_i2c() only performs the basic I2C initialization.
>    - igb_set_i2c_bb() makes sure that E1000_CTRL_I2C_ENA is set
>      and enables bit-banging.
> 
> - igb_probe() only calls igb_set_i2c_bb() if an ETS is present.
> 
> - igb_probe() calls init_thermal_sensor_thresh() unconditionally.
> 
> - igb_reset() aligns its behaviour to igb_probe(), i. e., call
>    igb_set_i2c_bb() if an ETS is present and call
>    init_thermal_sensor_thresh() unconditionally.
> 
> v2: Add variable name in function declaration,
>      rearrange declaration of local variables
> 
> Fixes: a97f8783a937 ("igb: unbreak I2C bit-banging on i350")
> Co-authored-by: Jamie Bainbridge <jbainbri@redhat.com>

Checkpatch doesn't like this: WARNING: Non-standard signature: 
Co-authored-by:

Co-developed-by: Jamie Bainbridge <jbainbri@redhat.com>
Signed-off-by: Jamie Bainbridge <jbainbri@redhat.com>

Would convey the same and keep checkpatch happy.

> Tested-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> Signed-off-by: Jamie Bainbridge <jbainbri@redhat.com>
> ---
>   drivers/net/ethernet/intel/igb/igb_main.c | 44 +++++++++++++++++------
>   1 file changed, 34 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 4e65ffe3f4e3..7f56322b3ec2 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -138,6 +138,9 @@ static irqreturn_t igb_msix_ring(int irq, void *);
>   static void igb_update_dca(struct igb_q_vector *);
>   static void igb_setup_dca(struct igb_adapter *);
>   #endif /* CONFIG_IGB_DCA */
> +#ifdef CONFIG_IGB_HWMON
> +static void igb_set_i2c_bb(struct e1000_hw *hw);
> +#endif /* CONFIG_IGB_HWMON */

I believe the preference is to put the function in a place where the 
forward declaration isn't needed.

>   static int igb_poll(struct napi_struct *, int);
>   static bool igb_clean_tx_irq(struct igb_q_vector *, int);
>   static int igb_clean_rx_irq(struct igb_q_vector *, int);
> @@ -2399,7 +2402,8 @@ void igb_reset(struct igb_adapter *adapter)
>   			 * interface.
>   			 */
>   			if (adapter->ets)
> -				mac->ops.init_thermal_sensor_thresh(hw);
> +				igb_set_i2c_bb(hw);
> +			mac->ops.init_thermal_sensor_thresh(hw);
>   		}
>   	}
>   #endif
> @@ -3116,21 +3120,12 @@ static void igb_init_mas(struct igb_adapter *adapter)
>    **/
>   static s32 igb_init_i2c(struct igb_adapter *adapter)
>   {
> -	struct e1000_hw *hw = &adapter->hw;
>   	s32 status = 0;
> -	s32 i2cctl;
>   
>   	/* I2C interface supported on i350 devices */
>   	if (adapter->hw.mac.type != e1000_i350)
>   		return 0;
>   
> -	i2cctl = rd32(E1000_I2CPARAMS);
> -	i2cctl |= E1000_I2CBB_EN
> -		| E1000_I2C_CLK_OUT | E1000_I2C_CLK_OE_N
> -		| E1000_I2C_DATA_OUT | E1000_I2C_DATA_OE_N;
> -	wr32(E1000_I2CPARAMS, i2cctl);
> -	wrfl();
> -
>   	/* Initialize the i2c bus which is controlled by the registers.
>   	 * This bus will use the i2c_algo_bit structure that implements
>   	 * the protocol through toggling of the 4 bits in the register.
> @@ -3146,6 +3141,30 @@ static s32 igb_init_i2c(struct igb_adapter *adapter)
>   	return status;
>   }
>   
> +#ifdef CONFIG_IGB_HWMON
> +/**
> + *  igb_set_i2c_bb - Init I2C interface
> + *  @adapter: pointer to adapter structure

Copy/paste issue I assume. This needs to document hw, not adapter.

> + **/
> +static void igb_set_i2c_bb(struct e1000_hw *hw)
> +{
> +	u32 ctrl_ext;
> +	s32 i2cctl;
> +
> +	ctrl_ext = rd32(E1000_CTRL_EXT);
> +	ctrl_ext |= E1000_CTRL_I2C_ENA;
> +	wr32(E1000_CTRL_EXT, ctrl_ext);
> +	wrfl();
> +
> +	i2cctl = rd32(E1000_I2CPARAMS);
> +	i2cctl |= E1000_I2CBB_EN
> +		| E1000_I2C_CLK_OE_N
> +		| E1000_I2C_DATA_OE_N;
> +	wr32(E1000_I2CPARAMS, i2cctl);
> +	wrfl();
> +}
> +#endif
> +
>   /**
>    *  igb_probe - Device Initialization Routine
>    *  @pdev: PCI device information struct
> @@ -3520,6 +3539,11 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   			adapter->ets = true;
>   		else
>   			adapter->ets = false;
> +		/* Only enable I2C bit banging if an external thermal
> +		   sensor is supported. */

This comment style is incorrect.

/* Only enable I2C bit banging if an external thermal
  * sensor is supported.
  */

> +		if (adapter->ets)
> +		  igb_set_i2c_bb(hw);

Indentation is off: WARNING: suspect code indent for conditional 
statements (16, 18)

> +		hw->mac.ops.init_thermal_sensor_thresh(hw);
>   		if (igb_sysfs_init(adapter))
>   			dev_err(&pdev->dev,
>   				"failed to allocate sysfs resources\n");
