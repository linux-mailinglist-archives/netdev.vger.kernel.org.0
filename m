Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B2D68C4FE
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBFRjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjBFRjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:39:18 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E3B193E5
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675705152; x=1707241152;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zV8+MBPI5cTK1yhGACTJWSCgBIhWYmj0i2ue20djAJw=;
  b=FAjT3uTbTQJ0snERp55LzoTV4jzbgJVi6G5B8xAtP2WpJu1JiEedGu1x
   7lcXLlR5zwf6Js2nN5nlUnv+RExzVMmJKBQ3/B60W3ZDVdGKQJdEpp3p8
   UJSvzPCqjoCMCBLAkvyv798/iYirtB0ajutjY2ojcDN2o1Apg+TqBZmFZ
   v/SVeIwYYR234DiTdoLWqSsldKLwxPXeyS4KyNwB21LCXHUap+n9mO2YL
   ppHUBZCGvZmHpp/kzUPkoWMMtTrA5aWiWYu2ut4ZGa8ba7fu4xCykH7wb
   6rnKHnhVD9QhnrOT1HPfb7HaHm/viVTQ5ddDa5orjwMAUErvt2qdxwLoe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="326950491"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="326950491"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 09:39:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="735209497"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="735209497"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2023 09:39:12 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 09:39:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 09:39:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 09:39:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 09:39:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAbIYhxmZOM6JW/WNStvgQ7bCrTi4WVntZQ7VBFrLf8oo/QwMc1aM9FcmFfvzpbOebk5mJ1H0URx+E4q6BDfrJD7PQ70/Jr+JUBqtzOr/NzcqeBRYoELLsX4lAXcV+Kjhh98RqMrK/uh22E43bznAsifosALKn/8so2j2dWMK1AA2Qz3znq0xsS7V/+436F1iuC8QocfdTTmOp2/H6+zx/p3QhFIPsW74awnfaLWNafaaH4B9nfi6wrW8kLTX8SewjKOhbkChcH1Aoj5+OC9k7JUFCDWi8iOoPQptGCeV/YQSXs+Y0CTVxYT6GplVxlz3xo+l0UBUxzNHZUtIx47/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Jruv+VhButEBP5iwmoeyDuGte2+Il4b2p3Mn7CAcAY=;
 b=Sq+4EMXQOgnyCaDG8TLmv9lDiRLQIgNxIfR9kg72085hv3WtO7R4LWWUsILmJF+JjcBU6kEi4VsDY2n4vxtBF60GaHYyW5bQ1wb/XXs/MIG2VvPOnMqIIwSR21x95X37yCBR7UqQ+6FekAqqKcM/ZJDtZIvQ/My3Yw8x6ZTFLHgMHVmVkleljSWaRIwp+7IC2CJREDUADhZHxREE2DAOhffXhLx/CifpwzjWpcw4KHwCY+sePG+oG2bQaQ+zGJZAH659UVMC1q12eFAyyY0Mr9FbZsFAk1U9ag2YkVm6aeIYX5IGRwrLkmyLAdDGo94Vv/49Qp4lcfBBK7ncOKlm0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN0PR11MB6159.namprd11.prod.outlook.com (2603:10b6:208:3c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:39:09 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 17:39:09 +0000
Message-ID: <b667f787-6f1b-19c0-d980-dc9ba801932f@intel.com>
Date:   Mon, 6 Feb 2023 09:39:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net] devlink: change port event netdev notifier from
 per-net to global
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>
References: <20230206094151.2557264-1-jiri@resnulli.us>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230206094151.2557264-1-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:a03:255::31) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN0PR11MB6159:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d643cb9-e3fb-4b18-28ea-08db08690d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hch0Xwx7AhyTRoMV57K6N+40DZgvLcQesM6PmkTh+1UsSADN7y/KsP5BzfFoDTaBrScqaKtd/JHxGkqrF8mFTA6RgD8VCJrmwmaPtnHUVHPTckxUdDaTvnVpLrQUBpxWjHpi5P16BjnWi7nXnlMbrMx0/BRErDRCTIyVSl60bWiHv0TURa3qEPZxP+vb7zMnFhXKwv/hjiqC1CAF8KxD71BkbrPRRZAtS+sW6uqmprLywt2UQsD1vBNIVMLVuKH/hN8lkEycetnAZVSOm6mV/A4kKRwfaw3sXTchY7TJiZnMxw8R46+hW1V+HAm353SNyvBgSpHTiHcRIvoYElbxwv4qZsnWR8fQdeWfHxaYYBtAeHiSe9jFokQ9J3Q9vF+AyGU30wxRJUgRwWsHtj1SbCClj0yt8wdpuBG/s3IcjSvPwc/V2x3H24/bB7vXEJ7gp3Q5QJVZtmwJX1934JcM1efWW5eJMYGj+hv8GfRbyhsR8jDFJY0iih4zf1Wcf92UvJrZCRk9HPYG3DHRtySZeEdfAuhkLgs94KIb6KzqJhoPx/9BLOEC9qe4jZlO0P6zrsMGXhh3i864Grf9KrPaHTVnA4MYcKmE6DcYH9WUqYk790FdWjL33DMhP8Ml/y8GPG0k7ZOjRegooMr4TZ8Vxj66eYoI9X+651eyjnhDM5MKmKocCFuVFJn5BDSmMOQvx3zHmHyeAweivgNkj6N6DkvkQvNq3e8DxRSIHK1xmuQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199018)(66946007)(82960400001)(38100700002)(66556008)(8936002)(41300700001)(66476007)(4326008)(8676002)(2906002)(4744005)(6506007)(53546011)(2616005)(26005)(6512007)(186003)(316002)(478600001)(6486002)(36756003)(86362001)(6666004)(5660300002)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGxkc1Nrc29NNk5FMGJ1NEJKWG0vbGN0RnEvWmd4VHloNTFnU3RRdFVSN3dF?=
 =?utf-8?B?d2lYb2RkcFpISXVGSWcrcmJXekJoSEJjYmRINE5mejVyMElYNllXamVzM0JN?=
 =?utf-8?B?Qmlqam5XaTl5RG1QQ01tODNRd3laeGowM3hYby9UYUlyVFhVR3YyRzd2UzVZ?=
 =?utf-8?B?VXUxUmgvWUZWTVVIYXM0dkZhNW1QUnY5TmpYcDJEY0t3SDZRMFVqRE5ib1p1?=
 =?utf-8?B?WjRYWTYrLzY4ME5SN0xFK0wrSjdGcVJSS055RWV5NGtBRW5paVB1OGZGQ01J?=
 =?utf-8?B?Q2FQclNab0dUN3NQU2FOWHA3RGN6d3VJRS9zOVRoQ0xKOWdTc3RDS2dyYkFj?=
 =?utf-8?B?SXBjN0lTZVpaZmxxRmNHMVJsWmg2byt2QTlrOFNwSUk1d0prUWwxcTBwR25P?=
 =?utf-8?B?R3hMNlVTNU5RcFZkRUQrR2thUGNWektZMzljZUIvNnJxU05KdjF1TlVUMnJY?=
 =?utf-8?B?WURMM0V6OTRMUzFoVFIvV3FmTVl4eERiL1FpZkVYM1VUdVRhRWtyT0JkS3U4?=
 =?utf-8?B?OHlTQlV0eXdXQnJ0Rjh0ano4UUZpdTJ6QThjVjlicUkvSmZNaVY2QVRZMlhH?=
 =?utf-8?B?bTAvRUdYVndtODJoQmJmOS9zTXRiSm9LZ2pKdU5OdjloU2lOQUUzbFVxOHBP?=
 =?utf-8?B?NnNzV2pybS9CZXNieVh3VXdUckgxNFJJRnh0Q3dxZUkwOWJsejBYSy9Hcjl5?=
 =?utf-8?B?bmVKa1JWdmcrcExSQTkwcVRmMmNxSkY2dzJSNUxmaFExWUFYSFpPdmV6Q0I2?=
 =?utf-8?B?RWdjYjRoS2RlcmYvNmJ3aWFmL3h0dVNnRVErdTAyRy9qbUZDbi9aenBML2Ra?=
 =?utf-8?B?dmdaaDRpYWFjeGRIdFQwb1hmZmdYbkFrZlByYVdMSVlTLy9yVUFSYmh3bnpU?=
 =?utf-8?B?ZnJjVWV3aWlLdityYkxPQ3RWTDliUkhMWkNyRlN0Z3l1dFdaSmlOYjdqaTBU?=
 =?utf-8?B?S2o0Y2RUTUkwVTNramR0aExPZWl1TVloVmtGWVR3RXRxc1k5R3IrdDR3RGV2?=
 =?utf-8?B?bW95K2hEMXpraWpvaS9maFdPRU4zanFkUkEwRloyY0dKNmdRZ3FTV3hhYlpZ?=
 =?utf-8?B?UHdNekFReENmTHBBL2szQ084M0p0YXowV3JZczl1YXQyL2MwaVRYbEFwZUxl?=
 =?utf-8?B?UVk2K002L3VlTjQydy9MY1h2L3NiSnYreVdZdnovVGhQTHZrbHR5Y2hLL1Rt?=
 =?utf-8?B?cytML3k5YlZ1ZFhPTWZzQ0FuUFVKVHZaT3NjemRNaitJZnVxVXNqeDV2NE9O?=
 =?utf-8?B?ejB3ZHdXeWdmOXRZNldJSnNzdlIyRkFCdTlpVU9DQ2kxN00ranEvT0xNK3VQ?=
 =?utf-8?B?bzQ1Y1BTWVl2Q2x4cFJuSUpWOVd4R2lLTm4wWmttSUVwMDc2MjIvVjJQN1FT?=
 =?utf-8?B?dCthZFlxREc4RXhPWUx5N1RwbmRTWjRtN3FOeSsyYWtBdGZwMmNveFNER0lz?=
 =?utf-8?B?RzN4TkcrU080d2pNZmgzbEVzUGpZSUR4VkNvY0Z4Vmd6RzI2V2Z2YUswY2Vm?=
 =?utf-8?B?YWc5VWhXU2JPQTJRWS8yZHZYVEFhTHc4SGRJcTJXeWZLc2RoNVdxeU5xMlhY?=
 =?utf-8?B?VTlkTXJKbDhnRzgveTlkcjhxa2NKemVrVEEzK2FpU296d0YwM2pjRGpVdXZE?=
 =?utf-8?B?YU9LLzZ1dlhqS21KUmZpS09ZcHEyRFBqcjRBNTVWYXV5WGdiK3ZwYUo3eDNv?=
 =?utf-8?B?OVRYSGc0SHl4c1FoclVoZEhQVVNnOGRRZ3Vyd2NMeFZzM1Nic29lS2x3Y2VP?=
 =?utf-8?B?d0tzSlhXRlo4b3pLU25raGdYSVErb0NteVBYcXFESGcvQXZiTVVZd1IwUUYv?=
 =?utf-8?B?dUp4TE8zVlA0ektuZlBHYmU0eUhmTlN4R1cxek1HcXBPVUtvMEpObTJ3eisz?=
 =?utf-8?B?dEFPQTQ1NUgwR0Q4c1RVU3VpQndzb3hzQXNvem5TOXZ5dUFQbU1lMzM3RTBF?=
 =?utf-8?B?R05BdU5pUE9PMGQxSlFMdkpTQ0ZYQzJpOFhONHVzTm1JeXhUMTlZcXp0SWdl?=
 =?utf-8?B?cm0rcGREMTE3ZTNlRGdBeXFkNFp0ZkhQVUhnWkJ1REJJNkJCOTM0UjFtWUJR?=
 =?utf-8?B?QXJhTXBqT0ZXUXpPZmV5dnAzVFVqWnVZUTM5cjVVTHdZZ1lXZklkS0d6V0lt?=
 =?utf-8?B?R3FHbDNnNTYxdk8yR1N0QTU0TjhzQStuRmtvQmE4NnNhekNxNkNmeEhCK0o0?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d643cb9-e3fb-4b18-28ea-08db08690d43
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:39:09.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbF71C0xvkJOFNmj8yPDR4WLSAUbQcI2aQsQCfei+NyU6wWF6XOtnwH5fFsPxZ7owjN0XQ7e6p7n7nHRKJIJBPKtBjdDzFMK07KTZOMXNzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6159
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



On 2/6/2023 1:41 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Currently only the network namespace of devlink instance is monitored
> for port events. If netdev is moved to a different namespace and then
> unregistered, NETDEV_PRE_UNINIT is missed which leads to trigger
> following WARN_ON in devl_port_unregister().
> WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
> 
> Fix this by changing the netdev notifier from per-net to global so no
> event is missed.
> 
> Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Seems reasonable.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
