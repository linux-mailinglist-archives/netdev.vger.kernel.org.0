Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A747D1C4
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 13:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbhLVMet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 07:34:49 -0500
Received: from mga14.intel.com ([192.55.52.115]:10978 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244903AbhLVMeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 07:34:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640176486; x=1671712486;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a+AGv2B3cITtlMIxMLc+Ws/AJG49z6OTkEzYTF9J8RE=;
  b=YfP0SdouTlpn5Izsqu6Bvce/7UcNKVB/I2KW3G46i6Qpv1EwWU1PdFwG
   a9yh05NVnAMRzvzHtSKmhRswJ6fFXkIpeTKfOoulMgUNvhjZH1udvQm2P
   C0gcI7ggnzeEEULbirr4E65PQltNck+ewL1pb2yNcMJPm5eACet7MCPur
   4CwFuygF5MSGGI/31PVkRtYtHHIJdpWAtqPebiX0k4A5XCF96LEm60jSy
   6u5jVAFOMOF4PD1PCmx2xqGw3HKG1coQ+vb96DLYUTchqkpdfcibDCJcA
   r5MHt5uB/PYk5iINVm+ujMJK4xbXpbHnldrYBw6qNqLXbacIhqdGm5wjY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240832516"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="240832516"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 04:34:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="756298692"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 22 Dec 2021 04:34:42 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 04:34:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 22 Dec 2021 04:34:41 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 22 Dec 2021 04:34:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAkk/Gxv4EbjRDhxK8XHj6orCfceWgLMn9PQw3+qfSnGMK8SVg7dvmSDG8X280aVqeYzi6OPFsPjvJ/9j4r7ix7YEWUpRD5QUQ80koPvGEjRCQeme/vkfU9Kjl82SuwA+hyXVo9WZFrlt0sLKtcjF9Ib+2w1kOMI7nMWVV6K+NIlNWaZ6MVgaVleUkr5pA+4qS5t6wBmeSczQiWVOm+2gyzaSIcqjoEb7qtrjv+VxbUg0NpDf8an1X62cCtYFvFk2NFAo3Yg5TQj1vcoLIi53M/6x8MNE5OpOk0OiRM/9O1iP80brKoPPSSmiS0Xezo8Tyuj+R13mo/nNGpzIIfveQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hU2G96bpwvcTx36JTf40m7BM6A3gVvk0ZmXMVsGfmCw=;
 b=IBkz6pMn9U4MA/mT+ujz/exylmltmTn3x4nId4BrKbWkW5Je2EHeH/MEROE+DsnLbF09UKxWwbKuljmRC2lsW4kJnTSUFQknrx/7ZbkipmQPMfuJHAtO9g2QNAdnGt86fR/Qce6lYV79Ame41zG/NRXuoRZQg4U07Td4zhQv4XresXu5McjbgdcKycsvIvXUnav8Bo1BeiYU+daZc2aKcgBwkTkgqawwUbTTJlqjYFVSWwSead5vO61ObIpGLR4ljIJtQIMOPovikdazEe1N4z7zx9NvuYJvCsL4wAI6mhgf3dBcYhc2JCNimgb73gA79UyAbv2y+a6ama5rulvpeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR11MB4049.namprd11.prod.outlook.com (2603:10b6:405:7f::12)
 by BN8PR11MB3666.namprd11.prod.outlook.com (2603:10b6:408:8c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.17; Wed, 22 Dec
 2021 12:34:39 +0000
Received: from BN6PR11MB4049.namprd11.prod.outlook.com
 ([fe80::cce3:53d5:6124:be26]) by BN6PR11MB4049.namprd11.prod.outlook.com
 ([fe80::cce3:53d5:6124:be26%4]) with mapi id 15.20.4801.023; Wed, 22 Dec 2021
 12:34:39 +0000
Message-ID: <43f04a56-8f1e-6325-c9bb-31164a4fc6ee@intel.com>
Date:   Wed, 22 Dec 2021 13:34:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH 0/4] driver_core: Auxiliary drvdata helper cleanup
Content-Language: en-US
To:     "David E. Box" <david.e.box@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <mustafa.ismail@intel.com>,
        <shiraz.saleem@intel.com>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <leon@kernel.org>, <saeedm@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <vkoul@kernel.org>,
        <yung-chuan.liao@linux.intel.com>,
        <pierre-louis.bossart@linux.intel.com>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     <andriy.shevchenko@linux.intel.com>, <hdegoede@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <alsa-devel@alsa-project.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20211221235852.323752-1-david.e.box@linux.intel.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
In-Reply-To: <20211221235852.323752-1-david.e.box@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0071.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::16) To BN6PR11MB4049.namprd11.prod.outlook.com
 (2603:10b6:405:7f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49f3d9c7-55ba-4037-a825-08d9c5476bba
X-MS-TrafficTypeDiagnostic: BN8PR11MB3666:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN8PR11MB36669DE08A989F607CA75352E37D9@BN8PR11MB3666.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xh/pKVTdN+fOWPfcXPtBpKWFRma/ybIMlpVK7pFq8DrgeAtnpBpWiyvsuXHDgRuZyrFpMXQ5rIdL1xG8L1g51nHbX5LlIOU32G+EE+CuEyhKCfJclaJKIUM1vW5vpxJ6oPYTLy7RKw1kpK3wT2y0mdjedn4SVMJNk1pstIQpFYHD6DgfYZhXm8kw+72P3RbG1fRo/o2sARajZ8yktZBwwvyOxUEMnC8Sebbw+0ykPjY36SxxDNKWvjfhFJurxJqm98XoWA1WF5sSun8Pdwr/E1OF++CoA+sp6Rn3Gdc7ZagvoIvlRDUXep8IlbM30hwFZbxiZ/0Xxn3xgaRq19XL2y4V2i3RtIgQPc+sMHfNnt6ZJQpzkqTnWJ8VrLZz/vz5EuAkj4ND11lCyAj/3vdsLyU8UXSc7gqvf94cvVV2Q3zA4gNyhNykqbXzyqUMYyUnpJp3NEasGZfqgwVljkPk/161K/kuGPTBz+ckjIHv1TV0IkLTyfin0zzI4PfFMr94jUsEwB2gQd7R+eNj5Es8e4RBXoQbh1K6bpKIqad91ol901WXen47C72DK4Q2N3aybiNP/wjk+NKTZ9TKBOB2EULqhsJYU0cfltf+8DiCAKEf6qE6LIaOTvlJk+QD6uzTmoehNYAIySFyA4Lc+z1UAK+B/jUpa79OkggxGUl8ZZ9WsV47GeeVRBraAqAMWMe+gKSODUh4Gw3xXDMap0GYCxaektwvbdY2FYFadvHyx/aEksqu8WB7NXFBuImng8Gqq6KVrIeFQFBLjXlXqxXsNMaz6dKH0UfR+JjZPl3kH2nO7469IAjMlhmIrG3mVLdFovR1zxSb0TxMfi/Whg63QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4049.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(8676002)(36756003)(38100700002)(966005)(31696002)(82960400001)(8936002)(921005)(6666004)(66556008)(66476007)(508600001)(186003)(66946007)(86362001)(53546011)(2906002)(26005)(6506007)(83380400001)(2616005)(5660300002)(4326008)(316002)(4001150100001)(44832011)(31686004)(6512007)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VW9MTlJzRWZUeXhIbUNlcW5BWWNzNE82YVhYVzdscjlJRmYrVldFNW4vOFBu?=
 =?utf-8?B?bXJvcG82Ynd0S2o0aVRvOVZ5cGpNaUMwcWhyb0l3ZTBiUUUreXM2MkxncjR6?=
 =?utf-8?B?Vkw1S0w5TFl2YUN0UlZzamo0WlNLc2JzaGFKZTdMTUh1ZkVKbTZGRlhPN0Nk?=
 =?utf-8?B?V1UyVzgrUnZ3MTdKcFRTZnVrZjltSlRIODBWQU9LcXhDcVV2V3Z5MHlzOFdO?=
 =?utf-8?B?dDhZalkzZkRCSnUzOVR6Sm5VVTB6SE1PU21rbFZncElaNGY2Mk9yOS9INFVn?=
 =?utf-8?B?Z251UFozNjB2Q0QySnBuN0c3QVAvZUxTS2U3TU5kVklCMEFzaUdDQ2RyckRp?=
 =?utf-8?B?TnJUdVQzMDE5V0hEVGJYQjNYemV2NUlaSTIxbFdSaVo3NzhMTnZzSVJDd1Zh?=
 =?utf-8?B?RUg4MTRCRlB5RVRtQ0NtRWpSaXYyK284WUVoNXVrai9saGdOU3hWc3VNaEdp?=
 =?utf-8?B?SG5Rdmc4eE1EQ2Q1M21FcmJsQ0pZM3ZZK2tmQ3pyYVYva2hKRWU4eVFzVU1r?=
 =?utf-8?B?OENJQTBlY2c0SXFNVHMvM3l5emRvdmtaaFgvcGZRUlFBN0RQYlBtcjRNdU9l?=
 =?utf-8?B?VmlMVFRKR2lEclZiRDhiRGk3enpIRDk5OU03WUtJVzdMSm1neU53RCtQVHZW?=
 =?utf-8?B?akh0ckM5ZDI2LzhPcVI1RVlyVU9hK1hIUGsrakFLamFLb0RSaXIxTTc2eng5?=
 =?utf-8?B?dWVBbk5wRzdWK295VXczRlQrYmQ3UlJOZjMvUGhvdWNpQXljdDRZWVU0cWU0?=
 =?utf-8?B?SEJ6UmsxMU5BU1pseDhHek0wcEl1c01Jc3VWaW0xT3l6c3RkelJoUEZUemVj?=
 =?utf-8?B?engrRVkxdlhTb1Z5dkZLNkx3UkdlSjhkandVamlndFNxYXFDSzVUSkJVcnFr?=
 =?utf-8?B?dUluaFVTME9uRVRET0t1eHNka3gvcXVpUEo4SlNaMDNjY2tzdVNmeU0ycTM0?=
 =?utf-8?B?ckt4dTdRODZIYjZpMGQ3cXg0ZzRObHJMRXZxMVRCdTBVb2tRWmlCYlJlR1ZG?=
 =?utf-8?B?ZGRuK3pZYTIxa1hKVVJlRjVNT1IzSzZWcHY5cjluaGdLWllNN2ZmVUJROFgy?=
 =?utf-8?B?UVNQVW5hSjNVNDN5MnpuQ21YSmJtMmgxODdBeXUxaUl1TENiZUVNdWI5MEpm?=
 =?utf-8?B?ZWprK05NN2VxbTZtSHdnOHlUUmdDOXloRVQxcUM4eDN6QmZEUFZkK3FUK3ht?=
 =?utf-8?B?QVc5QXMzVlV6eTRkNHF5dzdPUm95SWNacEFaczZZb3h1dHhxbE5JU0dGMlFw?=
 =?utf-8?B?citnWE9vTm9Cc2prR1dMQjE0elFDL3FxU0N1UGV2N2REcDdZUlMwaU13NFE2?=
 =?utf-8?B?bnJCWTl1bEZIN2xmdDVPTERkQzZ6ejZ3bWpMSjdlQmUxNU1wblpWRHJyWFpj?=
 =?utf-8?B?Q2p6UXYrRnpxUXRqUVRkQ3BzTUJ0bk1WQVVuV1UxZk16NDVnaHlvamNQbWVy?=
 =?utf-8?B?MXdMTWZKVDhsOUtHbkpGY282MjdNU0pYNkh0aFAzMHJKUnRQOHNzK1dxM09O?=
 =?utf-8?B?MXJsUWhwQlE2VE1CY3MxUS9sYWRKc2JkYjRSOXBGR3NKblJBd1VYQVlqdmNv?=
 =?utf-8?B?NGNFV2pKcVRaQ2lDRnlkTUtrVVl4SUMyQTVKVWFJZUJ4cWJlOUZCUVZpa1Ay?=
 =?utf-8?B?UVZkUnB1VU9yelF0SjNYRGxIZnBPNm9PQ1R3YW40Qk80ODlsRDZFN2IyRmpq?=
 =?utf-8?B?TFB3YVo1WFpLS1JPWVByNXdqeVRsb0IxcGpSdEJ6MktnbXoybVpkS1k3SjdD?=
 =?utf-8?B?a0kvdWl2VmxsREVsVjNKNmlrQUxhbnZ2Q3lhZW1NYWJWR3BWWkpoWFV6OENT?=
 =?utf-8?B?RnErc3RwSFZqNVdCZDJVNkhjRzJwOTRndURPVjJldXJiZ3QvckswNmxaNGxz?=
 =?utf-8?B?V0E5WU9nUHV4b3V2U2NYbUlrdnJEcXNiVUk0UG0xNHl4RzZHeU9YdTVSSXlw?=
 =?utf-8?B?Skp0a2JjazBqbnphR0lCOXpVVHBuU3MwNzY3OVF2VTBkR1Y3NFZ0Z1lROGIz?=
 =?utf-8?B?K1JQYldGNXJ5MFk4Rmp4VjNLNHlGN09nQVI4Y2VpbVFZaWlyakxWU1BWaGhK?=
 =?utf-8?B?ckpFSlZQNDQxVldUZUs2TXNQWmFsbWVLYm5lSkZrVUJXWjAvb2RpdnlzMFN6?=
 =?utf-8?B?NTRmUlNHYnpCQmRaZUZQU1k5L0lJR2EwWVBlRGFoaEpUQzkzUWVpN2lENTNT?=
 =?utf-8?B?Njhtem9zKzdnYWlhYjlOc2ZrcExsUEgwVGgwbCtiZXpsM1NsZHNnYUFHaUxM?=
 =?utf-8?B?SjBpaWovSUZ0VGV6aDNHTUxJbWV3PT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f3d9c7-55ba-4037-a825-08d9c5476bba
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4049.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 12:34:39.3768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CK0HVYyrXQrmtaHa4SOeM+4dvVoIjmRS+8nD7OElv9zI2R6obLMcaZJOiuz9nb/rUcuHvqyTcE3Avh4JHeFVmOp9MZKQAXXHdVdf8lbtnws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-22 12:58 AM, David E. Box wrote:
> Depends on "driver core: auxiliary bus: Add driver data helpers" patch [1].
> Applies the helpers to all auxiliary device drivers using
> dev_(get/set)_drvdata. Drivers were found using the following search:
> 
>      grep -lr "struct auxiliary_device" $(grep -lr "drvdata" .)
> 
> Changes were build tested using the following configs:
> 
>      vdpa/mlx5:       CONFIG_MLX5_VDPA_NET
>      net/mlx53:       CONFIG_MLX5_CORE_EN
>      soundwire/intel: CONFIG_SOUNDWIRE_INTEL
>      RDAM/irdma:      CONFIG_INFINIBAND_IRDMA
>                       CONFIG_MLX5_INFINIBAND
> 
> [1] https://www.spinics.net/lists/platform-driver-x86/msg29940.html
> 
> David E. Box (4):
>    RDMA/irdma: Use auxiliary_device driver data helpers
>    soundwire: intel: Use auxiliary_device driver data helpers
>    net/mlx5e: Use auxiliary_device driver data helpers
>    vdpa/mlx5: Use auxiliary_device driver data helpers
> 
>   drivers/infiniband/hw/irdma/main.c                | 4 ++--
>   drivers/infiniband/hw/mlx5/main.c                 | 8 ++++----
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++----
>   drivers/soundwire/intel.c                         | 8 ++++----
>   drivers/soundwire/intel_init.c                    | 2 +-
>   drivers/vdpa/mlx5/net/mlx5_vnet.c                 | 4 ++--
>   6 files changed, 17 insertions(+), 17 deletions(-)

Changes look good, I did post one question regarding possible occurrence 
of dev_get_drvdata() not being accounted for in patch:
[PATCH 1/4] RDMA/irdma: Use auxiliary_device driver data helpers

However, it does look like a blocker so:

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>


For the record, I did scan the following files (users of struct 
auxiliary_device) from drivers/ directory for the missing occurrences 
and found only a single one (as mentioned earlier):

drivers/net/ethernet/mellanox/mlx5/core/dev.c
drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.h
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
drivers/net/ethernet/mellanox/mlx5/core/en_main.c
drivers/net/ethernet/intel/i40e/i40e_client.c
drivers/net/ethernet/intel/ice/ice.h
drivers/net/ethernet/intel/ice/ice_idc.c
drivers/infiniband/hw/irdma/main.c
drivers/infiniband/hw/irdma/i40iw_if.c
drivers/infiniband/hw/mlx5/main.c
drivers/infiniband/hw/mlx5/ib_rep.c
drivers/vdpa/mlx5/net/mlx5_vnet.c
drivers/gpu/drm/bridge/ti-sn65dsi86.c
drivers/soundwire/intel_init.c
drivers/soundwire/intel.c


Regards,
Czarek
