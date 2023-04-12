Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258046E0086
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDLVLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDLVLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:11:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F9F59E2;
        Wed, 12 Apr 2023 14:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681333889; x=1712869889;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s9RbHy0M3yWf4ajtjxAqjUbffEPLu2wq8YP0+dPTkUI=;
  b=dTTSn/sL3oT4+cTM9SFZV4PR/2EwDNY4VjM4iJpvHazsQFvNwH8MTnwT
   ey6W3E75GUdmCN1OgBJytkt6eUBQrVGrUeJSp+u1JO2efa4MSm1N8sf/r
   h8JlKauhS8eLdEtlV4yiUaf6cdEoex6YuETJx8TEYMVklTNsHL+4F+EPQ
   aYvMqGvFpor2x7DhocUWmLRDIZtp33f5ySVPvnZmiApGNLckYGJc7Lg3K
   mfM49qtXSPS062D1+TgXysQ6QUeisiMZu5XOUrkWsSrqWi6wAM287J1GA
   9oaCgYlgroForZT32QwopvShBlomBFeydKiPoxiE+PdKWdqWjqHuOeCAR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="341514968"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="341514968"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="800490563"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="800490563"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 12 Apr 2023 14:11:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:11:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:11:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:11:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W03wYEKlAiVYcrEOTh50FJxfVHBbs1tq4fmYr76xGqED2llaxg5uPag+8psIPh5dBLbuNCZFMNHnstfX05we/3+m+lsAc7kNvB+t8EN47zaDri/8dHAMKv3XxyCxmQImFJtCQKGpg1L+sEHFBQi9z+6N/0f3LrNCAttAxSvAeV8jCh9Qd+sf3i8Tmft+J7VbxTDq3S1fGThuEas7suGeUR4lxuntKu7z46wtwILZ2xUQDQ0u54rbdgqVdxMmPsABywGVxlWSm2DnOMkYdrMztMb8TNgFov+0LPIAcS2r8B1W13yNjDirRCfXGGyxR6+HAk8j5/Kt3kYicy1rqWjTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDljP+Qs3oiihKC/wh3TraQEKs8uY6IzMYPxpRojR3c=;
 b=TIQeVyZFsIIhpQ75rwcc97xSOaerRLeP3TR1fJSa6VeV+NZO+c1FtQQr40ZnvJt7uTqBUqIbqdfpNNd7RKP26riiXE3NJI4MkE+DELM+iUa376ZQQV0fY8yJkn/+qbVB5S+30ya7PhV8iZ7snA44KvEpNDegJBIJr3rl8/jsgka4NVOuH0MGAUPi45X7ln2UIXo+wfrUXu46VTbTOn/Vhqpybw0ZXCJaCRx9f6E5Et0ebyNH0pOBQNdnEkqC37sneK2ZY/a5Qbfsc5OJxl+Jxvk73vbLj7BazKWFlM8iaSrvqxUNiwcDTW6HW0on3CmJDDRlR3BRmV6YLDZpd4fMeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB7754.namprd11.prod.outlook.com (2603:10b6:208:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 21:11:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:11:21 +0000
Message-ID: <369a47f7-8194-73bc-34a4-687f2e554438@intel.com>
Date:   Wed, 12 Apr 2023 14:11:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 1/8] net: mscc: ocelot: strengthen type of "u32
 reg" in I/O accessors
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        <linux-kernel@vger.kernel.org>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
 <20230412124737.2243527-2-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412124737.2243527-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::20) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: df6270ba-46e0-4bf0-2441-08db3b9a76db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ra0/GKTefsrTSZ89pGoBJllay9OSLIA/sFuz6HXvtXR7KkkSdlaV2MJUyQGzh46Ac5WsdIWE/l6PFArzpqebmGaZdPJXT6z3AXlb9y341VoykmzMwA7RlcZoQBcNpeFhCDO5b/tkelI8YAuoI79fGdDzrsLCSh6FDnvQCjU5KKfybpVhFZ3cp4N3J/Bo+DCBSAQ1EQqOT5NGUY2tYZlwqJhfrk/hTUfwKHV88GEbJyyHg7ASDqwh9ykP9DewhRGtwaGjG2cmg/+JQllUIw75yxFJu9rSzdInRfVLzCw0fi4SdwqXAInqETaMSkAZ+RtgBQDXafFnVcWj86J9GL2gAnSORaN3Nsu2Lgt7MjdNN/Sai/XegORrYmSOYkAXD94ex+9aN+3D/Vefs20mWyIHrnxemgZytQPpWeAe8YfKCRce71pSP0hU1idc7DYnlYm6whNspp7pNo+xVFQzSDR9x2oPTnS49xjjBwEJRy7NA21Yido/tgTFtG+sbq00nadN7Bo6pSj1HmHS8D1a8rtvo2CSvvwV8znclPmB5XhAIF8QuvgqWjY1TsMm8olT4CyllTuV5Tj0Y+Nu4L+GbiV9AHQdzPmY0XVfiywdvHJt0zdO215pQ8DngotaX9g/gC1pSfz06SUta1nUmYOtEf1vsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199021)(31686004)(316002)(8676002)(4326008)(66556008)(66476007)(66946007)(54906003)(478600001)(41300700001)(36756003)(31696002)(86362001)(2616005)(6512007)(6506007)(26005)(6486002)(53546011)(4744005)(2906002)(7416002)(5660300002)(8936002)(38100700002)(186003)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1hWWXNIK3BqVERGOWhYajJhc1ZQb3J2NXQwYTJySGpnTVROem1HbUtGWitV?=
 =?utf-8?B?YVc4cE8rQzk5K0FWREN1SG9wY3BHQjFRQ09wVllkMHh3eG1YeVFvbmpCcDI5?=
 =?utf-8?B?c2hxSUZuQjFVUlhyS3MrMHQ4am5LTk8xd3NXeDdQN0dnNzByTWFjYmJKVTAv?=
 =?utf-8?B?TDNFdCszSFYvblgyVnYwZmNtcTI4bHZyaXJTeEZwdGdyZlRrVnJlaWNJN3Jq?=
 =?utf-8?B?RFNEa0JESGs1b25UZTFtMjlhd0Z2T0lTT0FGcCtJZlBPVGl4aXZFejFTQmJv?=
 =?utf-8?B?b0Y2dXVGT0Z0enZnNmNFZU1ycmRxZjg1OEFyVHRFa0ROaFB2WkxVRjJZbUYy?=
 =?utf-8?B?YjJNcWNadmlETVRuUmhDRDlRYjdGdi9YakR3T2xydGdNZlFpK1lnK3RCSEVz?=
 =?utf-8?B?MFlBNXkwOGZKUUp2Vy9yaDZ0dHRzTVBrdnZ4VFNKMnA0NE9hMENHdWRCUGkz?=
 =?utf-8?B?QjExS0lpbzVTS29pSGxjU2FncHB5Q2tLTTNOanM5UzVBWjdnVG5PME51YUZz?=
 =?utf-8?B?OXJGWDRqQ01HN1ZvbGV2YTRYZTBKdC95MUxNbFhSdWZha29qMHhxNkJuMTlx?=
 =?utf-8?B?azFlWjdybHA0aWc3Q2VOaDdqTnRIMkJCdzk5RTRBdHlHM3hLVXhPd2xDVThV?=
 =?utf-8?B?OTVQdWE2VGJ6cXFuS1p5blB4a00rZXg4NWRxL1I2b0NCRUU3QXZ5Rkw1cHlQ?=
 =?utf-8?B?NHJaV2VqMlhBYWhNTkZZQkdVeVpyQlQ0bjlMczZLckpiOTVFN2dZQUYyaHlY?=
 =?utf-8?B?aVlMWUtlMmFaVnRkU0NKSURibTlUMVNWMlp6M0wvdWFhYjhndmJhWXR6WEo0?=
 =?utf-8?B?MmFOUlJqK1E2cHc0V1J1akwvSkZYaWEySGRVZGVRSU5sc1ZpODd1bnl1WVRV?=
 =?utf-8?B?dG1ISmVLUHlvZUY5UGlxd01DWnFkZmZwQ1diejRpM3lEMkN1a1NJQzJpdkg5?=
 =?utf-8?B?MXJJRUhDSVNxT2NWVnNwVDl0bDRYSEhOLzFycU9CbEE0VGNMOXZLZDE5T3pM?=
 =?utf-8?B?RmdxMUZ0WkJuaXNnZERxdHdWdXFqazViZ1VsS1BoQUQ4SVVWODFYeDNiY2l6?=
 =?utf-8?B?K0VNTFdXRld2ZTJZaHFQc2k2OUtXU0c0bElVNjVMaU5lMDByeXNlOW9sWXlV?=
 =?utf-8?B?MU5YNlJVUGVkVFd6U1NUVjdYamJUVDUzWGJPUHRNdmxkdzZwMHVkNGZndVNv?=
 =?utf-8?B?Z29yU2NGWU5Dd0JaeXYreW10N2pBOEc5SjJhRXZDM1BBOTdtM3RyREVqWlNr?=
 =?utf-8?B?aHJLQXVQeiswcDdIUUd2VEdUMTVuMEhYL0VGdEh5VXA3blhvbVhtK0drY3k1?=
 =?utf-8?B?YVUzUGQyeDBycFRkMitmNHJMcXMvcU9RYmpuZkp1U1JkK1pJbWZVZDcrWXM1?=
 =?utf-8?B?dGsvKzBlUE9YQ1NsRmU1MVEzODNua09QWU8zTjd2ZmNHSXR5Mk0vOWFvMnpS?=
 =?utf-8?B?NUJsdWpxNEhNak5BU3VJSGxyRk1lODBGaWdUdUc2ZzIrdTQyYStveHByRm5H?=
 =?utf-8?B?cE9sdEJLQ2w4NWl5TU90bEpwU2FQSjZhVVkrb0pmTlNEL0t0YzVvVE1Kanp5?=
 =?utf-8?B?VHoySk5UNG1MTnRxbXpmT25wMXJENFljSzRtbGxyZ0ZlWDVLeDRGeFBCSWsz?=
 =?utf-8?B?RE54QURtQkpYeExmK3RZMUhMck9sNkozQlVDMDFwUi9KT2hjM3ZMbk1YTEtP?=
 =?utf-8?B?YlRjWE5hbTZDM2VDakpoeEpxZzd0SVJMWEFxZVc5WkcxUnFSdmNGZXVhR3lE?=
 =?utf-8?B?RE5NWnptMkdBbm9tdEo0bUZzRW81eEtubVIzcVZlS3hPc1N6dGdXUVpzYytM?=
 =?utf-8?B?bmR0dDhBV1RGWUg5YlljMVJzcDdFOEtYOXZnVnh6TTQ2TlBuaEZ2RzBOWFFY?=
 =?utf-8?B?by9OaG1XblR4c012QmNucVFSbnJoTWdqZDd0dFQ5djhBL21iNy9xNkJQQjJR?=
 =?utf-8?B?c2dqMVVDMGVLNmRXQXBDTlphclZQRHFDRmZsVzRpeGVSdENQODZqK1VsZ3V2?=
 =?utf-8?B?S2lxM1FSR21xdzhyUHEvQ1plcXhPaGp6UEtRTmFVdGVMVS9ERndWZ0ZDU21P?=
 =?utf-8?B?RGFGRGtZV2tFVTh0RDdWTWJwUys0OEdiMGkxTjFiMVlPUnNQaDN4dklocXNQ?=
 =?utf-8?B?SFI1bkptczlHaXhUSk1KZ1lwdUdYWTAveUo4S3dFK1dNY0FkangwOWdicW5O?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df6270ba-46e0-4bf0-2441-08db3b9a76db
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:11:21.0371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ufcfknox1ieQyFdLP7Dz5aqTnKQ/KAGvQ5r5j+Ma2gZ0+jeoCwyXoRFriKmO238tPPLQfkJuL5+gIpIZfFh0kbJ449mu8wYOTwahbDUCoaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7754
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 5:47 AM, Vladimir Oltean wrote:
> The "u32 reg" argument that is passed to these functions is not a plain
> address, but rather a driver-specific encoding of another enum
> ocelot_target target in the upper bits, and an index into the
> u32 ocelot->map[target][] array in the lower bits. That encoded value
> takes the type "enum ocelot_reg" and is what is passed to these I/O
> functions, so let's actually use that to prevent type confusion.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

It  does make the prototypes a bit longer, but clarity of the type of
value you need to pass is good.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
