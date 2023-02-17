Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E7669AE9D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBQO51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjBQO5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:57:18 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D516EF09;
        Fri, 17 Feb 2023 06:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676645811; x=1708181811;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jD46+iV1pPJ8PURqSU0Eq+j0Qu1JZOYUutSYyFPzwCY=;
  b=c+LYlErJuc6ac9Ysn6HmGkQNO1nHtlLmMcADMPc/6XNTnpI++nuy8Yqh
   OaR1JBCfDze1xis/TylNwzgv0d5dE9MDblIhRHoyBHzCIbLitw/VXX+FV
   BXZ+Nkc8lXn2XOkn8jETegP2VZ4H3buUnrzzFavkz1J+vJ2bRKHVCUL2r
   cx+XC2KnQicROGcyofInaFcveAR5uW6uDHqrbRdaj7065yOjL6CuTnKxo
   VJEhPKRgS2GnCcmwhqTDGZMOvamBPYKf9HC2xvDW42zLj3iJ0s/fTcpN/
   urCY42N97bZ2t9ZEucJ2N0U0Xq+t/bddTPu9+7dD8ezmp7vXrKFXbSeqN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="359451121"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="359451121"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 06:56:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="844599135"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="844599135"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 17 Feb 2023 06:56:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 06:56:29 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 06:56:29 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 06:56:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kY6OPSgTCqFO1KuyD4sPz1rpK1F7OBmqlFd5+GTyry9BD+Q1jCxOCLN4Lj1hdNpw0lCc9Hh53QPk4cdfTrlIq3pfLOJIK5PevUJpDM0g5MDWMDsG/gbUWFZl40a9ovLw+iAG2Luwa2WY13/KgQGbEAGF6LVVXDPxwhB5wkCdzRD2kd8582TeV6qpNgJCURa7TNYxWwkvQyqz7oI8+mdVbN2yUcrmdrrXa25zGgH6iz72xcq/0G9XekcJHtNEQFSsi+hfCLyByym8siSwX1ILUgxJFaKXusB9v306iF9DWrBf1eG7KYoGM5/iib7SpUwI+qDFpwU63Vscm/bUxb1JdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teZn4XZ5+uc+0GchsqEwrGmCsH0ELQZFk+PkWOPQFu4=;
 b=Un33iUrc0ua+mVP+UZ2rBfVrLOSQfOSCC9TgHWriCCmSKvmMEGVAVgnif3G2dlFSeVlCfmFRzf6wG3pjVXD5BYhGWRJRUmtVhTc6Yr7slgohmGI4mQZeENJchcl2X/1fw7yJhRoWBFLGDM5MSXM4Y8E8dtpnGPgUk4kWjKzHsCAiO7iNR/XR1+y1uQtUihSw7leZB/fgzK37YsSnZr3PSk1u24X5fpNAkJJlzk0LUHMHbLJ8mghkpjq6ZP0tocdSBO/XBueA+RFml+hsw9HTAdQo/GGarkj0dhABoQaEo4wCHJbRbZTJv8u+n5K2PJFBVP2A3K6xwrEiCvc3AUusGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB6504.namprd11.prod.outlook.com (2603:10b6:8:8d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13; Fri, 17 Feb 2023 14:56:27 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 14:56:26 +0000
Message-ID: <a0898de5-5990-4198-cda2-fe22679aec90@intel.com>
Date:   Fri, 17 Feb 2023 15:54:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 net-next 0/5] add ethtool categorized statistics
Content-Language: en-US
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB6504:EE_
X-MS-Office365-Filtering-Correlation-Id: 78a3e307-5d53-4e18-5be8-08db10f72498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QWWBPKo+Xhu8q2x5YfILnzy2SVJOE7u6MbzonQYdrkLpsLGIqPSLqKDvI6Q8wYkoEyBd2JJotYQS+UBlVxlI/TtRpUg1+/g9qY5ALl2Ojc4bUelcv8ZsdjMlUuomh8BXejyVtA19m+KTN1mkMcfZg3xqlwX+dPVeYei88j8e49Nm3o4h3qwdNfCz35nS9eBp50+zVWwDMhOtYcUY3vXpx+iqCZQeohPRcWfXNXTeXFvukJwpnBhFR+pt/0DO81s2x47OUnOuMeFTsWsDRSB8bScbMmvKLIWfJ02LI3adWNYU1hI21L3KKXxGczCt94WQmfvygQXO7Ijf4ajG5M5i5e1rwgihCeTL0g8RNTFfK/ymsjLJAsXo00E+NVC+1csV8T4jKdCAXVdF0Nza+tbvGz8DvyEzlOaSTRq+3ukzuRVHQw4EBuwYucoIUilTc2wMcz3LY28rLvaHF7KDE9gEUsawYatWfOKziZLhdDsnUGckhJ2CXvAoV0t6wSyiX4OCga/rUcpZjjFgDbgOwcxivSvmHiJ2MhcfvZBiSVO0WEFZyBBBTtu9g8UZpXSQGfvgReRsviLsOVwvHjboeqBNRWRKQ/ZCIs8MbnfIm37YIuXn8EXcNy3OZTrLOA0dhmItnUDO5ZMlPMIhAp8W+vCmGjvxfCJIT+9PiUdE/QVGCY8D9GPlzRs9/EKHAJWnXPGn6F60O5cQf+EFyrydxUtaHg0+uxtcS4M6CnG6d1f3sQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(6486002)(478600001)(83380400001)(31696002)(86362001)(82960400001)(38100700002)(6512007)(26005)(186003)(2616005)(6506007)(6666004)(8936002)(36756003)(41300700001)(2906002)(5660300002)(31686004)(7416002)(4326008)(6916009)(66476007)(8676002)(66946007)(316002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dU1jRkZKdGljd0pjOWl0cGhpeFM0elFzTElhc3U4TlRuZmI4ZXpaMFlFaWQ3?=
 =?utf-8?B?MmdXNnk2VlpXZnFQMXQ0QXltRTR0WXJpWi9YNnFVcVFkNHBwVEprUk5DZDhR?=
 =?utf-8?B?UXNyRXN6eHpUTVhpY2g5NUdyMWx6MkRuTVdHWEZaVG9jeVBTR2NpelArMHNh?=
 =?utf-8?B?YVJ3ZWJTc1FxSS9XbVY3bXpYd2dOdUxIOFJNZG1TQTZPZm9Gd3pPMGhlZHRy?=
 =?utf-8?B?Ukk0Q3U5QUNrSHRXM3Jadkc2dEFzNSswRHlWTlN3TVNuM3JSMzNiUHdLRWUr?=
 =?utf-8?B?bHB1dmZkTVNVWStqaXlmRjRJRTBYakN3TTljZ2JEWXZHRFBFTlZtRmhoK2J2?=
 =?utf-8?B?dTh1cTZyNmpIUTdPK0xYRjNnYkZ5OWYyRHR5K1pIeVdHelRCbmZ5aG1jQWNW?=
 =?utf-8?B?Wkc0MjhETDJ1SWtXbDlDc244ZWFMNmoxZXpVNEQzREcwelQ1MFBCQ2RPY3Vi?=
 =?utf-8?B?RWhCSHAxRmNWUzZjOWVIeUY0Z3lVeGMwOUtzYXA1bmV0SWw3ZnRFOEJZZEwv?=
 =?utf-8?B?bWRJcTJHM0FnTTUvaEhiejVLQ0F5alhMZEtlSEc4L3VZa1p2SjE4RkdnRzds?=
 =?utf-8?B?azFDOUdDRkVPQ1ozVFZHbVNIVExsYzA5ZDZqQ0JSZHNoNUhjWENSNUw5NTdZ?=
 =?utf-8?B?aFpYRncva3hOSlp3U1g4T05tVlFRK3JNbmxOcTl2ZTR3VDc2ZWREa0pkeUdX?=
 =?utf-8?B?Q2NsNWJQbHRnQUxESDY0ZmUvOFppMU9Xbyt4NWZ5ZDdCYk4vUyt2S29Vd1Iy?=
 =?utf-8?B?dUpITmMycWNVOCs5bms3WkhwZ1pRamh5N1FVc21qY2NDaVpGdzdhU2hIYUFN?=
 =?utf-8?B?aERtYmdubGtybmVVMnB5VXpTbmVFcEFaVWJQRVBYczdXaFo0cUZ5VkdMVUlC?=
 =?utf-8?B?cWRHZEIwNzhtWkFZY1dZQnlMd3lUQ1h5ay9yRkxVbXFQQmFzV0tEMW1RUmMw?=
 =?utf-8?B?OVI3aVNFVlV4T241ek5qTmNwRDNsejFzRDJPa1NTMzVmUTlQRkJRcnYxUTJZ?=
 =?utf-8?B?dlZqMERFK29iQ1M0VU91aThzQnRmQTc2ZkxwUENXUWdScTlVRktoQkovY2pv?=
 =?utf-8?B?MTlIMThrRHVGTW1HZnpHMnlsNS9aSmhIaDJWVFd1elFDWWRIS0R2SVhhUVUz?=
 =?utf-8?B?aVhtKzZieGtmbmx2emFTc01jaVpndFRnS2J3Wnl2YTA3Zmpvdng1Z21BS0s3?=
 =?utf-8?B?N3VXaFlJNzdySGsrNUVlWWczQUpPODN1eXVxUHRJdnlQd2pjSDBuYWhJUkZq?=
 =?utf-8?B?RGxaTnUvaDUrbW9Ma1VmejdoOFlsWG5jWlFoYTBLSjhoekU1SzZ6YUVZSWZh?=
 =?utf-8?B?RVdoYlY2MXBlZlR4THM5Y3REa29KRXVDR0ZaendhWTlWVHMxTW5ZdjloM1dP?=
 =?utf-8?B?MytsR0dSaW85OEx6bmR6VDJwbWxNbnBKQjh5bDYxNEp4eEZDaVIrd3FrNHhI?=
 =?utf-8?B?YW16b2VvN3NoQWJNNWFJRUwzc2ViRVZhN05tK0g0MFJzOVQ1T1pGcCtjT2xn?=
 =?utf-8?B?VEFJdlFKUVFnbDZsa0FVcTYwUGRCUUxxaHNKSk9iMzl2UHdjN2sxSDA1YU1Z?=
 =?utf-8?B?Vmx1WmNITXQzQjVxdEtEaGppZk9MYWZSc2YwVWE4NWpWUExJZGJta1hLVThw?=
 =?utf-8?B?eVVwT3NQL0VNc1V2cHVYbnF5Z3VNaVEwTjJLZUFITTV6UlZqZXF5eGNwTXN5?=
 =?utf-8?B?dFZIQ3ErWUhhM1NCWTVOenJkUVRMUVZDNDdNdi9QZVJvbFlQZnhQV0wrVEdD?=
 =?utf-8?B?d0h1Y3VHOGRvNHA3cTlrRGpFQjJZRkpiVDdXY3ROSHdEaHhOTkNCeVpWWmlI?=
 =?utf-8?B?M0dqbndETHhnOFpNNVM4cVJvVmZ0VFFCY3c5N3NMd0JlZzU0RjBxdnh2bXhn?=
 =?utf-8?B?cHpzZy9SZXJSYTRkazl3dnFiVjVMZUprTEFmeTAxVnlyNmhTYS9oYkd5T05Z?=
 =?utf-8?B?cEdZQVlmOGRFNXY0NFZjNDU0Y1N3Rlg2NVNuRVppMlhpQTIwSXU2QStaa1RP?=
 =?utf-8?B?RmU3MWdkU0pVTEZWdU5HWGQvYjRXUmhzeDFKSXh2VkxDaFNaWkIwcmFFNG1K?=
 =?utf-8?B?eDRBSGZVQjU3S0hLZDJqK1BuczVoeEdhT0NCaVhrQnVZUU56SU1qYVpta01j?=
 =?utf-8?B?Y3Mvd3E0eGdyd3RwOCtHQmdDNGx1VDlHeUROeHM3QUNoSjNLamk0TVloRGVU?=
 =?utf-8?Q?0iWt+hQ7BiwwdFbE35s6mTs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a3e307-5d53-4e18-5be8-08db10f72498
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 14:56:26.1707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIXEpqXb02D2DtWlVM1RwUDpaZxRbOuOR/zW2NNmbP4+MUAkl7fOYWPTCsNIpvx5ZYl3KWFwZxG2io/ZhvdvGsBKwa4fWpSJYc4+/M9oER0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6504
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

From: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Date: Fri, 17 Feb 2023 16:32:06 +0530

> [PATCH v2 net-next 0/5] add ethtool categorized statistics

I'd like to see the cover letter's subject prefixed as well, e.g.

[PATCH v2 net-next 0/5] net: dsa: microchip: add ethtool categorized
statistics

...or so, depending on the usual prefix for ksz.
Otherwise, it looks like you're adding something generic and only
realize it targets a particular driver only after opening the thread itself.

> Patch series contain following changes:
> - add categorized ethtool statistics for Microchip KSZ series switches,
>   support "eth-mac",  "eth-phy", "eth-ctrl", "rmon" parameters with
>   ethtool statistics command. mib parameter index are same for all
>   KSZ family switches except KSZ8830. So, functions can be re-used
>   across all KSZ Families (except KSZ8830) and LAN937x series. Create
>   separate functions for KSZ8830 with their mib parameters.
> - Remove num_alus member from ksz_chip_data structure since it is unused
> 
> v2
> - updated all constants as capital
> - removed counters that are not supported in hardware
> - updated the FramesTransmittedOK and OctetsTransmittedOK counters as
>   per standards
> 
> v1
> - Initial submission
> 
> Rakesh Sankaranarayanan (5):
>   net: dsa: microchip: add rmon grouping for ethtool statistics
>   net: dsa: microchip: add eth ctrl grouping for ethtool statistics
>   net: dsa: microchip: add eth mac grouping for ethtool statistics
>   net: dsa: microchip: add eth phy grouping for ethtool statistics
>   net: dsa: microchip: remove num_alus_variable
> 
>  drivers/net/dsa/microchip/Makefile      |   1 +
>  drivers/net/dsa/microchip/ksz_common.c  |  70 +++--
>  drivers/net/dsa/microchip/ksz_common.h  |  10 +-
>  drivers/net/dsa/microchip/ksz_ethtool.c | 348 ++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_ethtool.h |  31 +++
>  5 files changed, 443 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.c
>  create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.h
> 
Thanks,
Olek
