Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6266C6A1896
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 10:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBXJRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 04:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBXJRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 04:17:47 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CAF5506B
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 01:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677230265; x=1708766265;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YZaRC+5EnV/rDUi1l0Q600PbeYzdu110z5WNu9OVB2A=;
  b=I+ZIqf5zlf7JAkDqXN3OJW1KUGPRVlOdFHSibkiLJQaLJDoEFJVAoNd9
   SGkCdjr9TpHTnBZGnYLEVAS6QpM4GDW021GnbwhIkZ0hx1dePDjoGYOXh
   OMyaSaUUIXWyV3VZzWwJX2nxEEi5Ug5eqzsifR8HTLG0a8+IWCB4R5wHl
   QxLOJ9Q5N0tsgstjRWrsMf4f/2eB5EMJm+S0S3Xi4GaeeGfKe3/c64rQC
   fXUTTZjTEQ2IU156WsylPkDCrovZyapFz4MtKi+LSzflJhhtidYmpIOpB
   uaQboaIjH5TX8m7MYhSGgEy/vGQcrQSkt1f1LtXXb6Cg9+INRH752hmj3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="313069371"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="313069371"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 01:17:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="846888441"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="846888441"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 24 Feb 2023 01:17:44 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 01:17:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 01:17:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 01:17:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 01:17:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNGdoFP8AFZMqAMOyRe4ohsXe9VjgVWNHl+H4lgL8rsORnfTAsLALGWYN8CPwl7IpPy0O39LSj3n12XC51aEecYnBwEzfV50//qIaLy4TLbdJUWCGkbEJeSfFkUTlYMILTQh/As/xWgAQVSoNLyXPsKALd+I1HZThpilWO7yhHyd6PTQuuxKj/R0KrzjSLrKuK71PHsiB1LiSlka8m89/jbt7oASwW7EWpELpXw8K8CJZUi89eDBgyNjGroyhSfic+DeJINKPtiRY//cO+WMjhxazFIFpY7NuvcMosJBmQR5clWrOZVqMn4/ZTSy0U80ov2Fe9OSqr/+ys9VzSIh7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkB+WKBa26Cb5uRrRflonQxSMK7lq9kb2viioHNYup0=;
 b=jzf72mCzBS1hD4nyxVW2vaCUy+fNI6XZ6QP5ptVfNPt1QQt7m7tbS/HoGlW4dcLwhZwPhNrsG9ThysxkSna07Jrww9ovbnBXLZeqIBYbQsI8EEGuKbd4ImUCHANtd0EhPiguOS1W1h/qsyRnC8sQPtRfM1MLDgsOyYUpccLSw+7ZL7mNU21ERHMzZR+FMzwUC8d2lf1qenn8hgCp9bB9MbT0eleXZyYPce8A0PkRfSALBllxC3CALzDI5N0HPxwGYGt5l/Kva0ygLqNg1X/Et8B0PaYhiLOjfAZq1M9hga4RCimhHNGtRwjdsJlyN9dDlf0JjBMOefZFWFMtnNOfwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by DS0PR11MB7903.namprd11.prod.outlook.com (2603:10b6:8:f7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 09:17:36 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f%12]) with mapi id 15.20.6134.021; Fri, 24 Feb
 2023 09:17:36 +0000
Message-ID: <a9c89f21-6a21-e52f-fcbd-b3b8e7f623d6@intel.com>
Date:   Fri, 24 Feb 2023 01:17:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: Kernel interface to configure queue-group parameters
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, Saeed Mahameed <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
 <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
 <893f1f98-7f64-4f66-3f08-75865a6916c3@intel.com>
 <87a68b97ca35255bd7cf406819a2030e77c12f8b.camel@gmail.com>
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
In-Reply-To: <87a68b97ca35255bd7cf406819a2030e77c12f8b.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0087.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::32) To MWHPR11MB1293.namprd11.prod.outlook.com
 (2603:10b6:300:1e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR11MB1293:EE_|DS0PR11MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: cdd4c43e-faf0-44a7-c75e-08db1647f7d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gIHAgU0+AOLa0F9PeDyMC2wtHVTWX9tcZedsVRzPIymzhrb1H8hriTOgujsC/uToMwRMXW2Z4USG9BCYZ+tA/P+so/8PTk2YH+heOHZntmFdN1Q8hbNhOqbuBizAYUoainCMkMIymcWYjrYEKPRfRW8pCtv0cOS0uQS4sQWSXndReRuqNwcIcpzxry7GyoCtnAOSzB5ehgrPyip4NA6JmHExsJlrgoeHH+Xq3dEWMAQOTeeWMepdKNiv0LTv6+Bkc9STyF6LMR2EuvcsvYQcq8zJFbuIGvHnOOq2zeXRQeGNlwIjbqfXAql38B6ry5OJkN0DHobWIEiAM8hmSp2zYGj6LCtEpoEhLMgR6c+ao21PHX4QzekYyIIIR0hV5f21sI0HJ8tlMtEWxpixqZZ3WRbf6FJk7Kij8qX3iyndZR5pdqrBsx/F8Q8/280wowl4JSp/Ce1U3dUiLkrh0J3CBbSRzYxGFdW/nPnyCiHkUafEpNnojDTsyn3EiCGUPGgUrh7BT7raFmCNg0LbiZ6LnZiQnYZNeDRlWCaokby6U232XI+/WuG3peqnRk89lsBdAEjuCTQckGz/Ux3v96TCvlds0jZFauTsqgHOpom8Drm8XP4mAP94Ewz3aY07BHwt8/+/TppLUkZwQezsr6Q9Uk996GKAS2B9S0BiF/G8V2rVJJczqcf3jTzBPk+LntBV2oTm6Ik5VDxaW6Sp+GbeAlg1RvEXsBlGb4Yx9xUwsRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199018)(6666004)(66476007)(66556008)(66946007)(4326008)(8676002)(6506007)(186003)(107886003)(6512007)(36756003)(53546011)(26005)(478600001)(966005)(6486002)(2616005)(316002)(86362001)(31696002)(54906003)(82960400001)(8936002)(30864003)(31686004)(38100700002)(5660300002)(66899018)(2906002)(41300700001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDg3R1UzMXJ5aFhNRnQyaVFObjNjVmFOZXIrL09yS3BzWWNtMER5dDcvUElx?=
 =?utf-8?B?UnJPS3lNbW5aamFJM1p3ejB2dWNZL293dDZheloxY0hnSGo5bGZwaFBoQzgy?=
 =?utf-8?B?eUFQUEJ2MXlXS3huSm9ONC9XWmZTcTZiVkNoeVhLYk56SjI2YU00UWE1V3Q3?=
 =?utf-8?B?MXl2V2ZaSi90TjF3ZTBEODIvSEJTaEdBeWxSd1lsVnhmbkZGT1pHQTN2YWVk?=
 =?utf-8?B?WWZNT3NOMURMcDlOTlBOdUtWaG5TUFV2WmxnVjUwcmZHNUdYNjJJVkxjdjJB?=
 =?utf-8?B?Qzhxb0o5Z2ZTbTNYemZ3bUo2S0hXd3ZjNks5c01jZjh5aWxHNC96YTNoQzQr?=
 =?utf-8?B?Y1FCSEVvRWVzZmZVMjFlL3BCWkRwSFUzN3I0YlZvY0FpQWlNaTN6ZHppdXJq?=
 =?utf-8?B?Q3RYSFVyWlVsY2xEOHhOUjVqUGNPQlhGcXI0VzFuV1lPN0VNLzJWM3JGZyt2?=
 =?utf-8?B?UlA0Ri93MDh0YlUzNnhXYWNGNTFSV2U1dUFZelJjTjZQRklnNE9UQ1VqbTJY?=
 =?utf-8?B?QmEyU2M0UlJpWGJhdSswRVhJdUU1YXNXUDNYeUVwSVFxdFJOblhLM0pYRFlV?=
 =?utf-8?B?aHU0QjQzRTBpQWM0Ym1VVVlYMmdaTlYwZlUzWVJ1c2YvZkVEMU5UbS9nZE5J?=
 =?utf-8?B?NEEyaThtMldJelUxUnB5WE5rNEF0OVVZMjhCU1NzMlFyUnV6eSszZHRZYnRP?=
 =?utf-8?B?L3A4N1l0V1p5WCtMRHN3RDM0SWUvSkJOTjFONDlmb29LdVdmeHFzVW81RFJ6?=
 =?utf-8?B?SEV0bGh6bDVXSmlSb3hiUXl3UlFJV0U0U2FSdk8zWWdoZTBxSzRWN0FBNU9E?=
 =?utf-8?B?cTVmWWgrRmk2QkhIT3NJNDZKYmZDVERjVDRkNFRPd3FmZ2ZmVSsyUXpSdkJn?=
 =?utf-8?B?dEZuOGRjWldSU1I2R3I0TW5YQndRWnVtTm9qREVYZFpSOUEvajJuOVlFZDNP?=
 =?utf-8?B?bmZIdHRZTTNka2ZlVnd4THVHRmIwVk1WdFBYNXhIYWRJU0RqMmpwc1l0b0Z2?=
 =?utf-8?B?WXMyWHFPcGVFN1d6cEpiOGdzVjNTTUdTQ1MxYXFnRWdkOFhoYjFKcGJrajds?=
 =?utf-8?B?TEozdnFiOWtXdVdKQlN6NUdpTkRPOFVBOFcvOFN4UU5sRjVnbFh0RVNnUjNL?=
 =?utf-8?B?TzROS1NWTEJteWlFUG5NUmVIdEliQi9hOEJEM04xVUkwWGloSnJKVjBPNlNr?=
 =?utf-8?B?QXJZSll1NmFCMmxEMWJrcWZyZlJsNXNUazhNS3F3RWdrSEQ5Y2ZNeDdpcGFD?=
 =?utf-8?B?aFhxUDRRZGhLZWYybUNtenJOd1RWcE41NVMybk9RSFJ5c0pSVVljTC80b3Vm?=
 =?utf-8?B?UUZPa1Q3WDlzYkprM2NOWU1FUUVLR1NjRFdFRFdEdkp6UklVWmZqajRoVWtY?=
 =?utf-8?B?ZCsxcU5IM0ZUZC9MRzg2TFVLMFNKZDlFL2YyVHlUM0pqR2gwOEJrV1o2WWls?=
 =?utf-8?B?dCtydHhVSFNaajYwUUVoTVYycTVzMlcrRkFKeTUxam9WMjdTQXpZUStCZTNu?=
 =?utf-8?B?Nmk4NFFVbjA2d3VNU1ZUVnlBWVNidGhxN1c4RkNsTkJ2b1o1V0lsdzhXbzlN?=
 =?utf-8?B?TWxHUEx2UmpCL2dCeUdFc1VPT2MrN2l2dDBZMFN2dTNsTi9hRWZyejhKNERR?=
 =?utf-8?B?MEFXanI0c3V5RlJDSDI3NytLWUhkUDNYS0RpcnVnaEt4OEhPR3J4RnFZZm50?=
 =?utf-8?B?VFlCVW12bHViRGovcDBmR1ZJQTdnZXJ3QXkySUJHQUtQK2ZwMlFSQWlkbFVO?=
 =?utf-8?B?OTRjWEVjRytNVzlBM0lTaUlkb3gwaE1IdWp3TVlZc25ta3lybUhDWjkwTEFk?=
 =?utf-8?B?bDhiYzU1TmFYVGQzUkZRb0p2d2dWdG1FRXFjVkVWZHZKSHlqSXpScUV3VnVC?=
 =?utf-8?B?aDBsMG5UY0VrTzB0ZTBDWHJ4cUdtYVYyTUxDUUk1UWlVRGxJUHluSGVzMkVB?=
 =?utf-8?B?UTllcDNZVy83MzFKREt4ZEs2NVcwT0EvMWdETldzL3MrTy8rL0JJbVZkeU5H?=
 =?utf-8?B?NE1jY0ZVaUthYVRVZE1KSE9LaysvUUpkOTlOcWtuY1cvcU0vaGxGcmV3dThj?=
 =?utf-8?B?NzlCK01NQ0w2TVQ2MjBJZ2t4NWRFWHV5ek5MYW9jUE1xZHVKK1FXc0dlbGtU?=
 =?utf-8?B?ejkzMmdQcnBYNGkxMC8xb21wRWtqU0RSckFqakU5OElBOXBIZ29yaHhZaWhG?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd4c43e-faf0-44a7-c75e-08db1647f7d3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 09:17:36.1585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAg8Vx/sA9/hIlH74jOSnc/Rsf9L3CKBhoji3GHfH+gBvBgiBLa+w8xoS24KdfaoHfwFwr8g49l1/MlOILxcw16kmlKwCxRfFxEx2hMUhtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7903
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/2023 9:39 AM, Alexander H Duyck wrote:
> On Thu, 2023-02-16 at 02:35 -0800, Nambiar, Amritha wrote:
>> On 2/7/2023 8:28 AM, Alexander H Duyck wrote:
>>> On Mon, 2023-02-06 at 16:15 -0800, Nambiar, Amritha wrote:
>>>> Hello,
>>>>
>>>> We are looking for feedback on the kernel interface to configure
>>>> queue-group level parameters.
>>>>
>>>> Queues are primary residents in the kernel and there are multiple
>>>> interfaces to configure queue-level parameters. For example, tx_maxrate
>>>> for a transmit queue can be controlled via the sysfs interface. Ethtool
>>>> is another option to change the RX/TX ring parameters of the specified
>>>> network device (example, rx-buf-len, tx-push etc.).
>>>>
>>>> Queue_groups are a set of queues grouped together into a single object.
>>>> For example, tx_queue_group-0 is a transmit queue_group with index 0 and
>>>> can have transmit queues say 0-31, similarly rx_queue_group-0 is a
>>>> receive queue_group with index 0 and can have receive queues 0-31,
>>>> tx/rx_queue_group_1 may consist of TX and RX queues say 32-127
>>>> respectively. Currently, upstream drivers for both ice and mlx5 support
>>>> creating TX and RX queue groups via the tc-mqprio and ethtool interfaces.
>>>>
>>>> At this point, the kernel does not have an abstraction for queue_group.
>>>> A close equivalent in the kernel is a 'traffic class' which consists of
>>>> a set of transmit queues. Today, traffic classes are created using TC's
>>>> mqprio scheduler. Only a limited set of parameters can be configured on
>>>> each traffic class via mqprio, example priority per traffic class, min
>>>> and max bandwidth rates per traffic class etc. Mqprio also supports
>>>> offload of these parameters to the hardware. The parameters set for the
>>>> traffic class (tx queue_group) is applicable to all transmit queues
>>>> belonging to the queue_group. However, introducing additional parameters
>>>> for queue_groups and configuring them via mqprio makes the interface
>>>> less user-friendly (as the command line gets cumbersome due to the
>>>> number of qdisc parameters). Although, mqprio is the interface to create
>>>> transmit queue_groups, and is also the interface to configure and
>>>> offload certain transmit queue_group parameters, due to these
>>>> limitations we are wondering if it is worth considering other interface
>>>> options for configuring queue_group parameters.
>>>>
>>>
>>> I think much of this depends on exactly what functionality we are
>>> talking about. The problem is the Intel use case conflates interrupts
>>> w/ queues w/ the applications themselves since what it is trying to do
>>> is a poor imitation of RDMA being implemented using something akin to
>>> VMDq last I knew.
>>>
>>> So for example one of the things you are asking about below is
>>> establishing a minimum rate for outgoing Tx packets. In my mind we
>>> would probably want to use something like mqprio to set that up since
>>> it is Tx rate limiting and if we were to configure it to happen in
>>> software it would need to be handled in the Qdisc layer.
>>>
>>
>> Configuring min and max rates for outgoing TX packets are already
>> supported in ice driver using mqprio. The issue is that dynamically
>> changing the rates per traffic class/queue_group via mqprio is not
>> straightforward, the "tc qdisc change" command will need all the rates
>> for traffic classes again, even for the tcs where rates are not being
>> changed.
>> For example, here's the sample command to configure min and max rates on
>> 4 TX queue groups:
>>
>> # tc qdisc add dev $iface root mqprio \
>>                         num_tc 4        \
>>                         map 0 1 2 3     \
>>                         queues 2@0 4@2 8@6 16@14  \
>>                         hw 1 mode channel \
>>                         shaper bw_rlimit \
>>                         min_rate 1Gbit 2Gbit 2Gbit 1Gbit\
>>                         max_rate 4Gbit 5Gbit 5Gbit 10Gbit
>>
>> Now, changing TX min_rate for TC1 to 20 Gbit:
>>
>> # tc qdisc change dev $iface root mqprio \
>>     shaper bw_rlimit min_rate 1Gbit 20Gbit 2Gbit 1Gbit
>>
>> Although this is not a major concern, I was looking for the simplicity
>> that something like sysfs provides with tx_maxrate for a queue, so that
>> when there are large number of tcs, just the ones that are being changed
>> needs to be dealt with (if we were to have sysfs rates per queue_group).
> 
> So it sounds like there is an interface already, you may just not like
> having to work with it due to the userspace tooling. Perhaps the
> solution would be to look at fixing things up so that the tooling would
> allow you to make changes to individual values. I haven't looked into
> the interface much but is there any way to retrieve the current
> settings from the Qdisc? If so you might be able to just update tc so
> that it would allow incremental updates and fill in the gaps with the
> config it already has.
> 
>>> As far as the NAPI pollers attribute that seems like something that
>>> needs further clarification. Are you limiting the number of busy poll
>>> instances that can run on a single queue group? Is there a reason for
>>> doing it per queue group instead of this being something that could be
>>> enabled on a specific set of queues within the group?
>>>
>>
>> Yes, we are trying to limit the number of napi instances for the queues
>> within a queue-group. Some options we could use:
>>
>> 1. A 'num_poller' attribute on a queue_group level - The initial idea
>> was to configure the number of poller threads that would be handling the
>> queues within the queue_group, as an example, a num_poller value of 4 on
>> a queue_group consisting of 4 queues would imply that there is a poller
>> per queue. This could also be changed to something like a single poller
>> for all 4 queues within the group.
>>
>> 2. A poller bitmap for each queue (both TX and RX) - The main concern
>> with the queue-level maps is that it would still be nice to have a
>> higher level queue-group isolation, so that a poller is not shared among
>> queues belonging to distinct queue-groups. Also, a queue-group level
>> config would consolidate the mapping of queues and vectors in the driver
>> in batches, instead of the driver having to update the queue<->vector
>> mapping in response to each queue's poller configuration.
>>
>> But we could do away with having these at queue-group level, and instead
>> use a different method as the third option below:
>> 3. A queues bitmap per napi instance - So the default arrangement today
>> is 1:1 mapping between queues and interrupt vectors and hence 1:1
>> queue<->poller association. If the user could configure one interrupt
>> vector to serve different queues, these queues can be serviced by the
>> poller/napi instance for the vector.
>> One way to do this is to have a bitmap of queues for each IRQ allocated
>> for the device (similar to smp_affinity CPUs bitmap for the given IRQ).
>> So, /sys/class/net/<iface>/device/msi_irqs/ lists all the IRQs
>> associated with the network interface. If the IRQ can take additional
>> attribute like queues_affinity for the IRQs on the network device (use
>> /sys/class/net/<iface>/device/msi_irqs/N/ since queues_affinity would be
>> specific to the network subsystem), this would enable multiple queues
>> <-> single vector association configurable by the user. The driver would
>> validate that a queue is not mapped multiple interrupts. This way an
>> interrupt can be shared among different queues as configured by the user.
>> Another approach is to expose the napi-ids via sysfs and support
>> per-napi attributes.
>> /sys/class/net/<iface>/napis/napi<0-N>
>> Each numbered sub-directory N contains attributes of that napi. A
>> 'napi_queues' attribute would be a bitmap of queues associated with the
>> napi-N enabling many queues <-> single napi association. Example,
>> /sys/class/net/<iface>/napis/napi-N/napi_queues
>>
>> We also plan to introduce an additional napi attribute for each napi
>> instance called 'poller_timeout' indicating the timeout in jiffies.
>> Exposing the napi-ids would also enable moving some existing napi
>> attributes such as 'threaded' and 'napi_defer_hard_irqs' etc. (which are
>> currently per netdev) to be per napi instance.
> 
> This one will require more thought and discussion as the NAPI instances
> themselves have been something that was largely hidden and not exposed
> to userspace up until now.
> 
> However with that said I am pretty certain sysfs isn't the way to go.
> 
>>>> Likewise, receive queue_groups can be created using the ethtool
>>>> interface as RSS contexts. Next step would be to configure
>>>> per-rx_queue_group parameters. Based on the discussion in
>>>> https://lore.kernel.org/netdev/20221114091559.7e24c7de@kernel.org/,
>>>> it looks like ethtool may not be the right interface to configure
>>>> rx_queue_group parameters (that are unrelated to flow<->queue
>>>> assignment), example NAPI configurations on the queue_group.
>>>>
>>>> The key gaps in the kernel to support queue-group parameters are:
>>>> 1. 'queue_group' abstraction in the kernel for both TX and RX distinctly
>>>> 2. Offload hooks for TX/RX queue_group parameters depending on the
>>>> chosen interface.
>>>>
>>>> Following are the options we have investigated:
>>>>
>>>> 1. tc-mqprio:
>>>>       Pros:
>>>>       - Already supports creating queue_groups, offload of certain parameters
>>>>
>>>>       Cons:
>>>>       - Introducing new parameters makes the interface less user-friendly.
>>>>     TC qdisc parameters are specified at the qdisc creation, larger the
>>>> number of traffic classes and their respective parameters, lesser the
>>>> usability.
>>>
>>> Yes and no. The TC layer is mostly meant for handling the Tx side of
>>> things. For something like the rate limiting it might make sense since
>>> there is already logic there to do it in mqprio. But if you are trying
>>> to pull in NAPI or RSS attributes then I agree it would hurt usability.
>>>
>>
>> The TX queue-group parameters supported via mqprio are limited to
>> priority, min and max rates. I think extending mqprio for a larger set
>> of TX parameters beyond just rates (say max burst) would bloat up the
>> command line. But yes, I agree, the TC layer is not the place for NAPI
>> attributes on TX queues.
> 
> The problem is you are reinventing the wheel. It sounds like this
> mostly does what you are looking for. If you are going to look at
> extending it then you should do so. Otherwise maybe you need to look at
> putting together a new Qdisc instead of creating an entirely new
> infrastructure since Qdisc is how we would deal with implementing
> something like this in software. We shouldn't be bypassing that as we
> should be implementing an equivilent for what we are wanting to do in
> hardware in the software.
> 
>>>> 2. Ethtool:
>>>>       Pros:
>>>>       - Already creates RX queue_groups as RSS contexts
>>>>
>>>>       Cons:
>>>>       - May not be the right interface for non-RSS related parameters
>>>>
>>>>       Example for configuring number of napi pollers for a queue group:
>>>>       ethtool -X <iface> context <context_num> num_pollers <n>
>>>
>>> One thing that might make sense would be to look at adding a possible
>>> alias for context that could work with something like DCB or the queue
>>> groups use case. I believe that for DCB there is a similar issue where
>>> the various priorities could have seperate RSS contexts so it might
>>> make sense to look at applying a similar logic. Also there has been
>>> talk about trying to do the the round robin on SYN type logic. That
>>> might make sense to expose as a hfunc type since it would be overriding
>>> RSS for TCP flows.
>>>
>>
>> For the round robin flow steering of TCP flows (on SYN by overriding RSS
>> hash), the plan was to add a new 'inline_fd' parameter to ethtool rss
>> context. Will look into your suggestion for using hfunc type.
> 
> It sounds like we are generally thinking in the same area so that is a
> good start there.
> 
>>>
>>>> 3. sysfs:
>>>>       Pros:
>>>>       - Ideal to configure parameters such as NAPI/IRQ for Rx queue_group.
>>>>       - Makes it possible to support some existing per-netdev napi
>>>> parameters like 'threaded' and 'napi_defer_hard_irqs' etc. to be
>>>> per-queue-group parameters.
>>>>
>>>>       Cons:
>>>>       - Requires introducing new queue_group structures for TX and RX
>>>> queue groups and references for it, kset references for queue_group in
>>>> struct net_device
>>>>       - Additional ndo ops in net_device_ops for each parameter for
>>>> hardware offload.
>>>>
>>>>       Examples :
>>>>       /sys/class/net/<iface>/queue_groups/rxqg-<0-n>/num_pollers
>>>>       /sys/class/net/<iface>/queue_groups/txqg-<0-n>/min_rate
>>>
>>> So min_rate is something already handled in mqprio since it is so DCB
>>> like. You are essentially guaranteeing bandwidth aren't you? Couldn't
>>> you just define a bw_rlimit shaper for mqprio and then use the existing
>>> bw_rlimit values to define the min_rate?
>>>
>>
>> The ice driver already supports min_rate per queue_group using mqprio. I
>> was suggesting this in case we happen to have a TX queue_group object,
>> since dynamically changing rates via mqprio was not handy enough as I
>> mentioned above.
> 
> Yeah, but based on the description you are rewriting the kernel side
> because you don't like dealing with the userspace tools. Again maybe
> the solution here would be to look at cleaning up the userspace
> interface to add support for reading/retrieving the existing values and
> then updating instead of requiring a complete update every time.
> 
> What we want to avoid is creating new overhead in the kernel where we
> now have yet another way to control Tx rates as each redundant
> interface added is that much more overhead that has to be dealt with
> throughout the Tx path. If we already have a way to do this with mqprio
> lets support just offloading that into hardware rather than adding yet
> another Tx rate control.
> 
>>> As far as adding the queue_groups interface one ugly bit would be that
>>> we would probably need to have links between the queues and these
>>> groups which would start to turn the sysfs into a tangled mess.
>>>
>> Agree, maintaining the links between queues and groups is not trivial.
>>
>>> The biggest issue I see is that there isn't any sort of sysfs interface
>>> exposed for NAPI which is what you would essentially need to justify
>>> something like this since that is what you are modifying.
>>>
>>
>> Right. Something like /sys/class/net/<iface>/napis/napi<0-N>
>> Maybe, initially there would be as many napis as queues due to 1:1
>> association, but as the queues bitmap is tuned for the napi, only those
>> napis that have queue[s] associated with it would be exposed.
> 
> As Jakub already pointed out adding more sysfs is generally frowned
> upon.

Agree. We do not wish to have another interface to control rates and 
that overhead can be avoided. We can continue to use mqprio and 
dynamically change the rates using "tc qdisc change" command.

For exposing napis, can ethtool netlink be an option as I detailed in 
the reply to Jakub?

