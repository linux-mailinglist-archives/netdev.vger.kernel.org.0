Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A91696900
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjBNQPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjBNQO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:14:56 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0426EEB
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676391273; x=1707927273;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UUcYrxezQTlLlD/udprzBeNbuCSe4BAA2s/pICxrzqs=;
  b=OasqFBNn0ySf+iH46RlCR4fJKLYgateTjUw8uSSlriFxPXHuPOoN+0JH
   WVJC3CJMdBepUr/7o9LSC336yh57zm7Wjsvak4Cnwp/FnjaqsHQpuCzE+
   S0tX1oond73eIB2CQTfJw1p2RraYQliVFGP93BOs/ED0AzYBB+F1gkyTm
   VPj2fDdyttKtwT+ZpC/93XB0KZBcIs4XDKtJGLuvwRNRPNywDXOmVKZ5i
   vvXQwNwY+6YFPNOxEqW5Ku1pvkY5oOEZq2PniGK74T6JcldT5Tg59BLQf
   AiCYPngag7Q8kp63rjkZkaITxRwet7iZOFCONeW5NxXJtdSdcfEEoJuUf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="319227748"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="319227748"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 08:14:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="701692804"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="701692804"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 14 Feb 2023 08:14:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:14:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:14:09 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 08:14:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 08:14:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVCVv5AOj42NZOR2Aw1TlngDbJSgUUElq9YFjNvqJYoEnmAnIEPe1yEsKtfPDVvQWBQNQ0OiZRTmoDlqVk3DZUVkjb6kXzSNHFAPn+vp62vO6WmogS4FiSJ31H8w8dw01O6yB1+t9+4vb76OgpJZd8T2wjlEmB+YmMNuFtyo5Hn3gzuoB1AWP4V2yclj+cwpf5XCwQoCaFnuolXkxJbd2qEriJiT6oYJVgVZoROQglziUrhC0sX04KS98lUzRSdozRfHmCbcTWRoPZy4TMTXYz11G16mGrEOMxz0TRoPR4SKHbmmB9jjnZrTvQVItqB6gZl8g5dzbut0OlZTccs2/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NwjPjYx1/iHACscEQUi51IMujNG6FhEM4s66MXZ1dM=;
 b=HQX3/qV2mPBhvW850QLsq0hB+i/pXXbo7pJFctjFT2QVCcKI6SzFgCQk8hKtTbsOzWW2qCgQt6NsPRBzv1FfAO7AQ2ZhR89cGU2P3VaXrAYDAxXZjrUwXMedKjSY/IvXIEiEi9QAVB9ycWtK7qA+jQ+u5sWAeRz94k1a8cXRu4UTFD2yg29iXE2HuLUNLvKKpGLfJ/5nCqWPqSMBTi1WzRDfizs7BnXNH/oh3H59mQIlOrExF0hl9vE1OAcK1OFmm3o53UNtPNXM4QJ21KjYqlDiKRaUFp7Nxp/rc9vKjUFJx7WLznTdQkfmUlKYiJn2Ucjl6Q3gtv1uEaUik+9YJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5636.namprd11.prod.outlook.com (2603:10b6:5:357::21)
 by PH7PR11MB8010.namprd11.prod.outlook.com (2603:10b6:510:249::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:14:07 +0000
Received: from CO6PR11MB5636.namprd11.prod.outlook.com
 ([fe80::ae83:22d0:852a:34f7]) by CO6PR11MB5636.namprd11.prod.outlook.com
 ([fe80::ae83:22d0:852a:34f7%9]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 16:14:07 +0000
Message-ID: <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
Date:   Tue, 14 Feb 2023 08:14:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jacob.e.keller@intel.com>,
        <jiri@nvidia.com>, <idosch@idosch.org>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
 <20230210202358.6a2e890b@kernel.org>
 <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
 <20230213164034.406c921d@kernel.org>
Content-Language: en-US
From:   Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
In-Reply-To: <20230213164034.406c921d@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::34) To CO6PR11MB5636.namprd11.prod.outlook.com
 (2603:10b6:5:357::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5636:EE_|PH7PR11MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: d2b0387f-85b8-4cc0-324f-08db0ea67fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ttOlicF4WGfhMRxMNMf7XIVBo/zyTAFcnaz8ScBYHaXApduNHISRiFD8X2INGAbRyiaYDXXUGaz4JTQ8AXTX93oU0Uo1iWW1ykMsS2WhocMsCLV9Dt5pjrjO6mAhlpDji6YLMuvj+GbbWw88UED95AacNBBwVYXviPOQP5SsZkg98Y/CRwG00lZ0MaQUBX/ns/3lKhltBrh7D9Ijss6yAOSfFs4Tcobj7RBhVF4F12Y8lTepDoF/Nq9f7c6Htb+uKtYBm8HPUb3RPczHgbqjtiExzyuIhqqPVCD1Gj+GkzqquTBMkTUhIlXJlNHdjuOUOdIYYSLtw8p3Fsi4H9vLyFjcyklek09fZZ0Z4Ps/+tllKoMu9Ujecm7J0VLahjx96VGm7lHeKEEsYrOhpDmIkse/7SplAH64DUmuzVFBJjUO7LXFBnpsoweBEY4wt2v3ReVEPqvHMrhyMA6qGrz0WssJigfvlEsL+IPHolgKpvx3S93gTZ7lJA7oGNKe2PKquAAQTZ/tRe6DQQ260QXX2RDvV6/9XRssXLmq5HFGp7jO1iMV91bk7SKe+tV3id/u3Ki8NZ5LFb5j02WoDFIUpbVzj8qzBcwKSTO8LTyYs8MvYl8VqQl6afwF67rmxQo/5+4cc5PvltQmHujnoK3gMw72xnHa2lag9oUOGGYsfQkgQjas4hMlQBLQff0I3e15Hkig6cKTySfJvDlMlhfke3WEcMFPopeV5EfRHhLKabg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5636.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199018)(31686004)(31696002)(2616005)(186003)(26005)(53546011)(6506007)(6512007)(36756003)(8936002)(6666004)(2906002)(478600001)(86362001)(5660300002)(6486002)(83380400001)(82960400001)(66946007)(66556008)(66476007)(41300700001)(4326008)(8676002)(6916009)(38100700002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmFQejl5cUZaMEpydkxjVFV2V1lLM25KTlBoQ2FpNkg4ZWlHWmgyTkZlWG13?=
 =?utf-8?B?cUFaSTBEQnI5T3VJeE14cURZOFJDNUtoWC9wcGpqOUljZ2M5YmE0cGNTQXha?=
 =?utf-8?B?T3dzY2srZ0tXTVBHZUhwbmU3N2txbjQvUTYzT0tkYWJoQ0drMDZmdTJzVllk?=
 =?utf-8?B?Vy92bk9xWUxQTEYxbEpnRkRtS2FlSHo5SWdXcVgxbkR0ZFloK2o1NVVyOExS?=
 =?utf-8?B?MWxURzI0UU9NSVlyTXkweE9ZNE1LUlZua3JrNzZTcDg4MmZEaDhXN0l0ajB0?=
 =?utf-8?B?d0FtUElkZm1TWWNFWDNvSHdIL3JJMjJLZjU2SmdiUldYaXF2bEd1NmNlYmVk?=
 =?utf-8?B?TFUxaDFVYnNobG92ZkxKWlpad1A3QlYzUjVjT0J5WEQwWnI0UEFOZCtJVDhJ?=
 =?utf-8?B?R3JpaURoU0RJUjEwcFhCSE5zQXczaVdLbTEyWGg1aitHWkdnOTFmQTYrR0NZ?=
 =?utf-8?B?L2xUN0xvb0prL0VUeHhwQ0NUejRyUUl1aEplMkhtTWFLb0h6WWFTc0VEb0JS?=
 =?utf-8?B?YlJST3FBbzlIeHhZQ3pPRkY2TjlYU044RlJ3V1pzcFZMSXRoeHVKeXN5QTBU?=
 =?utf-8?B?MzNLZnJNSEpSWjJTeHNPWWNkMEJXRDFZQmZwRjlyOE1jRXBFT2VlTEg4UWE3?=
 =?utf-8?B?blBqeWdmOW16S0pDeHdqRkNBMXNGbjJmNWlqRmMvNWVHRlE5U3JML05WZldN?=
 =?utf-8?B?bjR6VStWbFpkK3FPVDVPNGw0bkQ1M1pCRnp1WmJpRlBXemkwS1hQOVJhSzJN?=
 =?utf-8?B?YXVKOUdvcWxqT01yVGVQSnBVaTNhbDZvVVMweDg1SDFHKzlaYzRZR0wxTnlF?=
 =?utf-8?B?bUVGMU1Sc205dFc1NmNNTnV5cWVaOUFscExtMmVkcTMwTjZFU2tNUnJKRFRr?=
 =?utf-8?B?UklORU92SzhOU1grSml5NW4zUWRTZTJVWU50aVpCRDgyNXlRcEtFa0xGeFI5?=
 =?utf-8?B?eEFZQ0RITENIWmpyN2xJa2dKMFdPaDNYWXR6alFvMEQvK0hUQ0ExNEZHYVVu?=
 =?utf-8?B?dGIzUkY3bkN1NWZOS2szWEQ5UUxqQkNGdkJjZmU2VFJ2MEs5U3pzVndQMkdi?=
 =?utf-8?B?Tmd6cXNUdWdlZnUzV29JOHp3WklBTlJhVjUxOXNQZUhTdnBOaEpvSjFnd01X?=
 =?utf-8?B?RWFyOWxKdUp3UEZYdk9LaTVRUlg3TVFLM0RXVWtoNGtQOVVQVVZKT1BHaWdJ?=
 =?utf-8?B?NlZ0ZlVEVmxxNXBCd01zNUdKdEEwaFhIQ25xM1R6ZUdlSjJyMnVnZVZjdVZi?=
 =?utf-8?B?S0VNK0hBMjlOQkZTTThqcGJVVnY4OUtDakcvOFB6RjhYYlltbWRaLy9GVnM2?=
 =?utf-8?B?dUM3L29XTGs3c3hKOWJMeHVEYm43cWhaM0hLYXJmQkRZOHRoTGFQTTNVY2p6?=
 =?utf-8?B?OWlDT29lWDN3NTB4MTZ5RTRjTG05NnVSUHY4OHJMVVdEeS9abUhUeCtCdWVF?=
 =?utf-8?B?bGJ6RjNyT2JSaTYxNFk1L2tmV1doa25IVy9qeXZaV284RW5WTzNjVUJLeHVm?=
 =?utf-8?B?c1FTbGZCelF0VnZ3c3FKREVTVUs2S2czMCtUWGVTYzZHRWcyNHdXMnJKWUdS?=
 =?utf-8?B?MURzVzRzUTA4YmxTem1acjJqT1pDaUtDL0x4K3NSTG9zVmJRRHZIdmtvdWtH?=
 =?utf-8?B?YmllTXNXbW9DMmliTWxCdXg4YndBYXBpa3A1Rm9jTWdCSWlQczRoeWJOdkM5?=
 =?utf-8?B?SnNPa0REOUZ3VUI2cDE1VjRha21aTFJMQTU1Rk9JUUI3Uld1UTVSWGVjeVAy?=
 =?utf-8?B?WmZUSjFNOUttRzV4UjBxMTZjSTI5MnhISmN1K0RGZFlVQ2tqKzZtT2wxRjJw?=
 =?utf-8?B?M2U1cWcyRnlGOUxpVGpCQ3VobXpUZ2RabG84MGpPWW9LUWJhenJ1d1dNUWNt?=
 =?utf-8?B?WG5oZVIyb2MzVE5uU3Y1aUg1M1hXNVg1dDEyRXZmMEpTRHFxamdzeTlzT3c0?=
 =?utf-8?B?ZGRzT3dEemJVbTRZcTMrVVN0Ly9lVUxEdENwbmtJelNyUm9lMkhNcC95MlJB?=
 =?utf-8?B?UXpHdEJ0cFp1bnFwcFB2THU0UE5jTUcwT1EwTHQzU0h0d1pWa2hGMG9TTmts?=
 =?utf-8?B?NUEyT2JFUXRLdExDRU9kQXhGcUUwVDg5Q2dxRFJQdnVzZjR3ZVVqalNGQWNr?=
 =?utf-8?B?SWNMUDQ5eTF5WVRoWkN4QU14R2ZPOWJhbzg3cXI4bXBJM1dUVEN4clhTdzl1?=
 =?utf-8?Q?JO4y5nUqJSvp7DvzHeSYzN4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b0387f-85b8-4cc0-324f-08db0ea67fb0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5636.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:14:07.5318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDxW6fegt+7vrhRWpwVFVs2BCDd9K4JmGhWTIDcLDhxAqM2KIdr7RnrB199CIQZSEfvYMr6NtR3CNJlRObi6qu/EeasTNX+KwFBemWd6PuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8010
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/2023 4:40 PM, Jakub Kicinski wrote:
> On Mon, 13 Feb 2023 15:46:53 -0800 Paul M Stillwell Jr wrote:
>> On 2/10/2023 8:23 PM, Jakub Kicinski wrote:
>>> Can you describe how this is used a little bit?
>>> The FW log is captured at some level always (e.g. warns)
>>> or unless user enables _nothing_ will come out?
>>
>> My understanding is that the FW is constantly logging data into internal
>> buffers. When the user indicates what data they want and what level they
>> want then the data is filtered and output via either the UART or the
>> Admin queues. These patches retrieve the FW logs via the admin queue
>> commands.
> 
> What's the trigger to perform the collection?
> 
> If it's some error condition / assert in FW then maybe it's worth
> wrapping it up (or at least some portion of the functionality) into
> devlink health?

The trigger is the user asking to collect the FW logs. There isn't 
anything within the FW that triggers the logging; generally there is 
some issue on the user side and we think there may be some issue in the 
FW or that FW can provide more info on what is going on so we request FW 
logs. As an example, sometimes users report issues with link flap and we 
request FW logs to see what the FW link management code thinks is 
happening. In this example there is no "error" per se, but the user is 
seeing some undesired behavior and we are looking for more information 
on what could be going on.

> 
> AFAIU the purpose of devlink health is exactly to bubble up to the host
> asserts / errors / crashes in the FW, with associated "dump".
> 

Maybe it is, but when I look at devlink health it doesn't seem like it 
is designed for something like this. It looks like (based on my reading 
of the documentation) that it responds to errors from the device; that's 
not really what is happening in our case. The user is seeing some 
behavior that they don't like and we are asking the FW to shed some 
light on what the FW thinks is happening.

Link flap is an excellent example of this. The FW is doing what it 
believes to be the correct thing, but due to some change on the link 
partner that the FW doesn't handle correctly then there is some issue. 
This is a classic bug, the code thinks it's doing the correct thing and 
in reality it is not.

In the above example nothing on the device is reporting an error so I 
don't see how the health reporter would get triggered.

Also, devlink health seems like it is geared towards a model of the 
device has an error, the error gets reported to the driver, the driver 
gets some info to report to the user, and the driver moves on. The FW 
logging is different from that in that we want to see data across a long 
period of time generally because we can't always pinpoint the time that 
the thing we want to see happened.

>> The output from the FW is a binary blob that a user would send back to
>> Intel to be decoded. This is only used for troubleshooting issues where
>> a user is working with someone from Intel on a specific problem.
> 
> I believe that's in line with devlink health. The devlink health log
> is "formatted" but I really doubt that any user can get far in debugging
> without vendor support.
> 

I agree, I just don't see what the trigger is in our case for FW logging.

>>> On Thu,  9 Feb 2023 11:06:57 -0800 Tony Nguyen wrote:
>>>> devlink dev param set <pci dev> name fwlog_enabled value <true/false> cmode runtime
>>>> devlink dev param set <pci dev> name fwlog_level value <0-4> cmode runtime
>>>> devlink dev param set <pci dev> name fwlog_resolution value <1-128> cmode runtime
>>>
>>> If you're using debugfs as a pipe you should put these enable knobs
>>> in there as well.
>>
>> My understanding is that debugfs use as a write mechanism is frowned on.
>> If that's not true and if we were to submit patches that used debugfs
>> instead of devlink and they would be accepted then I'll happily do that. :)
> 
> Frowned upon, but any vendor specific write API is frowned up, I don't
> think the API is the matter of devlink vs debugfs. To put it differently -
> a lot of people try to use devlink params or debugfs without stopping
> to think about how the interface can be used and shared across vendors.
> Or even more sadly - how the end user will integrate them into their
> operations / fleet management.
> 
>> Or add a proper devlink command to carry all this
>>> information via structured netlink (fw log + level + enable are hardly
>>> Intel specific).
>>
>> I don't know how other companies FW interface works so wouldn't assume
>> that I could come up with an interface that would work across all devices.
> 
> Let's think about devlink health first.

I'm happy to think about it, but as I said I don't see how our FW 
logging model fits into the paradigm of devlink health. I'm open to 
suggestions because I may not have thought about this in a way that 
would fit into devlink health.


