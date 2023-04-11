Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92636DE7EF
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDKXTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDKXTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:19:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E068D2D63;
        Tue, 11 Apr 2023 16:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681255162; x=1712791162;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vYIuLP78AQH6uRSgNMmyKvJn4dQkrUDU9XCoAIN3+L8=;
  b=MS5oLiCI4terxNrDQJHrD4SsP280ZLrLcK27UYS2rE5W4jtRNOVfQByN
   WYCRAOdrD6HrceCOXNNJ9tatnTR3ZfnoD9yT8i7CZrXzETgZp0HafoyWR
   hOgUtAxTc5u0cg1ScTOY5Iy3hZGJs1IZ5UTzYBzo4VOqxiKcGmBggKDeT
   H4/TmeDj5xBs4l1GO8mNgA7w093VPOr3WiLdwA1R39LJp5QTZUFuNFp7/
   ziijAcHMaw3kxG1FdPF2DfozadXQq5RLIJKt+OMToc9NpX6WUmLB1d3f6
   bOwHoQLbH6HAjbpvXRQHB/b7lVAn4tI+DjuClhJXknXXKXwnSNIG/VtM7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="408897431"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="408897431"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:18:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="934900084"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="934900084"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 11 Apr 2023 16:18:59 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:18:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:18:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:18:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvaLnKXIRAWDZeD+kgp0bk1jhIIh5G7UlY/Vi5cBe+FlZtX4JwEmozr7blpvoF9Zk4ajANq0ox5agE5kjLdCMg7bp9CepduaTIPtIvJ6/+F9xjlHALu/vD/Pxc4Bh0zPh5TMmb6v0wT6BG8X9AVWhBeWVdgxxu4paREwXO7sTOCqZ0vKrh0+CjLZzXgod1SGChEt/kfxchFaQTiIxZYCOTNwWXq4gH4erTF+zc0PBtUdl/bu/lRLzE50kPnD7FhRUI82Uhkfbb34J+oVNVjYCm3xJ/w6z7XnlsvrpYKiDOOmu/y3bcMuW3mmOerERxvxuxnybgebXkMaxw3fbMCsQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2kb7nAZJbNSyxd4nWmlUFzEkTh9cJfTxQRpB0f/FiA4=;
 b=S1s2dtA+GOLu8KJ3rvF8SUmR0PXQcqNFbuYDXqjC/wd2e94pPF+HK7QgMRFtwUJxXNbsT0VobhqgQEcxFWhD2yEPmAZ74eFcLScQRrQlgAN3PgwnnXpMOP/7nKGzhJWxAbuJIIHJp5pmBNOdsGMIrDh6spIdDqLqn8sUYE2qh9mmk0FzmZDYWFYAne9WXv67kESFf75tuwM1qpome/k+p34emsTw4IoOHvpir3FnIJ3k+gXeUPXFEb5FsntWh3sTgPmnkMhhfe1gowibYX3sLM3yXCYuZdoq8G+HVFnfI0AhixXq1pvZnSR0zLFoIYiX13lL4q4jxXBobSJstVjhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7781.namprd11.prod.outlook.com (2603:10b6:8:e1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.35; Tue, 11 Apr 2023 23:18:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:18:54 +0000
Message-ID: <013681a6-cd92-9d0e-5e23-971844ce1ea3@intel.com>
Date:   Tue, 11 Apr 2023 16:19:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH mlx5-next 3/4] net/mlx5: Update relaxed ordering read HCA
 capabilities
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Avihai Horon <avihaih@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        "Meir Lichtinger" <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
References: <cover.1681131553.git.leon@kernel.org>
 <caa0002fd8135086357dfcc368e2f5cc73b08480.1681131553.git.leon@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <caa0002fd8135086357dfcc368e2f5cc73b08480.1681131553.git.leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 26a3eda8-40c4-4b31-af05-08db3ae31e3c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZsSjpGviQkPImFrKR7/7629cpj1mtGOLMv+Mberekw1h8/nqyKx835rSTkl94pgNGUkprQJog9kQwRD+JKd5pRJLjrDaVsJXq6QP+5AuG2rLP2CbI2fSinAC9wxkUM5/3bAjmWCUXfcTZA7hgpTpf9MxH6XtsWwabTYr39qv6wcBrZGjPk99zEUZb+wqvYOMzhkUqAl7g4lEi5AJUV1fTkXtv07ryAdWwQWA2mc9wHWjZNivWiAvu+BAT3ICIUuqqZGEvhKn041UiN2O6mwCEiRZ+hsVIzTyvpm3TBJ0OhxoQvgBUQ5aP6O9YAqclUD7FCscdRg/KMVgdqWdSXHENyZNI03Z/rTUEF0S4hhqGYQTIczKZ03iFSg2ItWWpU0TAEL0An91oXXh6z9CQfhexuBeOzOWF4H0YasfkMMWrFaij4MARN4YvIKuek7ey522Lt4LrT3tRJA9FyZ6Cw0kxjoxQwmKItbdNjxAA8jv/2H9xLIAEe8LFqkDfjucMGXwm4dFlWI0THWPlbDO4U32ptrpCx1lrG0ogm109LK/keLQqi/bn8dVpSJ6z4Vk5ehXu4Wf+Hj/esTF5HsZ42soge0cHnd93YyeCTNHwXDROCinx63qnQTC/wqzF3NQ3+xcofVyQm3Q7Qr9ImwwZsC8sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199021)(8936002)(2616005)(86362001)(66556008)(66946007)(66476007)(31696002)(4326008)(8676002)(82960400001)(478600001)(38100700002)(6486002)(316002)(54906003)(110136005)(36756003)(41300700001)(83380400001)(4744005)(186003)(7416002)(31686004)(6512007)(53546011)(6666004)(6506007)(2906002)(26005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXFpTDZISWtSNmIyY3h5dEYzdHk3cUVLUzRBYnZtQmVDdnpLbU8waCs4ZXE0?=
 =?utf-8?B?UDRoRmtpa1JwWUtYcXZNWFFrRDBHcFNqbUpMZDBSRWVaSmFRbFN5ZmdhbmpI?=
 =?utf-8?B?QTNDVVAxcDF5R0dPN0RlSTNwME9KTGRvRExvK3d5c3hRTkdBQW55bTRuT2RS?=
 =?utf-8?B?KzRvUnl3Yk5Dc3FhYnROWDd3cnFyK2xqbVYwWDhXRnpUQXltSWtML0hJMU5F?=
 =?utf-8?B?S3l6VCs1UFVycFR4MHplRFN0QVBSSi83UzJhdkl6MGVvRTRjbHNwSlY5eWFs?=
 =?utf-8?B?Qmt5Z2RHQjhTTmc4N3FQL1gwTFV3UzF0Vk5LelRFTGZ6dE5iYklSZ254azkx?=
 =?utf-8?B?YlYrVzdVTTh2c1BWTW5zU0tIMnpNb25qYndDbU84cFF1ZDNqWDl2NG90K1Uy?=
 =?utf-8?B?MHc2ak1USWdsTFZVVGQ0UFdYbVVYa3N6a2orK3I2Sll0bGUrbXh1Z2FjYUZ0?=
 =?utf-8?B?U2RScm9paG1PTDlsRlNwT05peFJ2QUdZazAvbWh2aDJ0Yys0aGVLc3MwYm51?=
 =?utf-8?B?SUVLd28zRkthUlRDQ3hlSUxlaTJkcEx4ZzkwS0dBMVl5Nit6WUJNVFZhOGk3?=
 =?utf-8?B?V0xwQ085M0NnSU9GUnpyWmFlWTQwVUZtTjZkalgzanc5TE43S21HOURwajds?=
 =?utf-8?B?dUUrQWxtcU9hVllUZ0Mya0plTHRiLzFpRnJ0R2V6RlBGYS9uUk1zSVhSWDVj?=
 =?utf-8?B?WitGeVRZZW54Wko2b29lN3lEaHc0U0JCcTBCSnFtblhONUF0NmVBamRNYS9U?=
 =?utf-8?B?OWR0Z0pyUHdEOHh5NXdSclZyZk1qWm0rdlF0MUZ3a2lZMWdJalNyMU5pWmsz?=
 =?utf-8?B?RkpHQWY0T2xrc1dKSmRDN29OcGY0eS9Rck5TejVTU3ZjRnhuQ0U1U043cGc1?=
 =?utf-8?B?dER6WFpUM28xUnlvOHgyYXZ4Q2txYUt4L3I2TkZRMWZ1STdIcGhncUZ2bC9H?=
 =?utf-8?B?djAyRjRhV0RDb1RXeDZDOFpOSWFvYmJGdTNqaHo2YXE3YkdzUHZYb0prSkdz?=
 =?utf-8?B?cWJXRm55QW5xY3BxL0IzNVlZTlhEWnFxUVRFZkQ5V0FHM3BFbHkybndTaUht?=
 =?utf-8?B?dG5GZGdjRWRyN3BQQ3p6NXFTNUFjN21NeEpyNjdEdGJ4VlNmbnltWVF4cVVa?=
 =?utf-8?B?Rnk4cXlJSUxpV0hnaWpYc21jd0hjNzU0bUxiRE1MMUxZMGFFdnFpMmVPOUZQ?=
 =?utf-8?B?Ty8vbGhYK290WktBdjNNdTNNVURLOUMvbzlvdUoxTEUrakw1MVdLQzc5dVN3?=
 =?utf-8?B?RW1HVmZyMVd1S29MdlNJSmI2dit4MFR0UlNoSUdGWmwralJTVE5Ka0tlQzJa?=
 =?utf-8?B?ZEtWQUY4VnJuQ3pId0p6ck1OOGhyY3pMdnR5ZzJtK1lOU3BIUlhwSldta3pl?=
 =?utf-8?B?eStReUE3OWg1c0p0NXBpQldQYzJaeS9EQnFFdit1WkJQOW95MElyS0hWd3Nj?=
 =?utf-8?B?VFRrYmt0WThnWnRiRkpOcGhEZzN1MHU0VXpBM2hVTm01SitGR21acWNET0c1?=
 =?utf-8?B?OThSNjJqNzdZZGoybkFrZ241eDBWMmlOeTd1bHU2WndUY29DTXA2d0MvLzZI?=
 =?utf-8?B?eStldlRna0s1SnBYL2gwVENhbnY3Y3M1SGRCcS9ENUxJQkExa09QVnlWNEti?=
 =?utf-8?B?NWlJRWg2Mi9WZm8rbEFPTFNKQ1pReDRBdmVLcnJVbkZqZkJ5Um5zYS9jRGVW?=
 =?utf-8?B?Q2s2L3Nici8rZ253bWhtVUJBSlk4REdzTFkyNDIvcGZVaUdZYzZPd1pVOFF4?=
 =?utf-8?B?dU8vWDNqbHdBOC9vZ09LVkN4aDZBY1V1T3oxQ3hpbWZNTTlvSnNDTU9VV3d5?=
 =?utf-8?B?VDJUZ2Q1UzgrdDBNUTJVVXpTQ1VXZy9wUWlJb3lxdzlpOFc3aFJIdXlwbENV?=
 =?utf-8?B?eEpNR1Zna0R2alRERzZ0eDdDWUM5K1hWSCtMUzFqWFlJRHlSMEhUT29tdjFI?=
 =?utf-8?B?bEg4eGFBaHduS0k2ZERUbmZTd0YwSWg3TVBGUTVua0I4QnVEK04wN2dmbE4w?=
 =?utf-8?B?UFhQVW9tZ2E3enBMck4zNFJMMVlCQm5lMlh3VytKL3RHTFNrN3RtaEg1ZXo1?=
 =?utf-8?B?MXJJRUdRYkIraWU5U0RIQXdKdVBLcHFBUjU1UmVxWFJIVWlOQWJqSFBiUG9Q?=
 =?utf-8?B?QTZIL1JVVStKWDBSWU1kUXYvOHA2cENHaVNVUEtEMmw1S20rR2drbW5UcGFP?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a3eda8-40c4-4b31-af05-08db3ae31e3c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:18:54.4905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVlTZBqwJabGgRguIjidjDZCkPkntrI2XFDiJv3EA95fHdhJzit2tZdm5TUS5E02aofPk3oWT5NnuYjlnydLGyn/EAwoI5ZDtT/OkhNJ5Eo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7781
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 6:07 AM, Leon Romanovsky wrote:
> From: Avihai Horon <avihaih@nvidia.com>
> 
> Rename existing HCA capability relaxed_ordering_read to
> relaxed_ordering_read_pci_enabled. This is in accordance with recent PRM
> change to better describe the capability, as it's set only if both the
> device supports relaxed ordering (RO) read and RO is enabled in PCI
> config space.
> 
> In addition, add new HCA capability relaxed_ordering_read which is set
> if the device supports RO read, regardless of RO in PCI config space.
> This will be used in the following patch to allow RO in VFs and VMs.
> 
> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> Reviewed-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---


Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
