Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDD1674B74
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjATEys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjATEyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:54:14 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE2DBC76B;
        Thu, 19 Jan 2023 20:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189933; x=1705725933;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gs6TYfqQRhBk8a/4fGiK0acKobPiw+O5dGe4GOkRsws=;
  b=IvlipMoZnBsPVD9oOsSui8ADQwKP6UdSa2L2XSrehLJS70FKD9NxMapn
   WJbVW+HAFm1jAkyE3330CHXjMeycJk5Kjzb9fWfiIJLvgK8g//gdBHiz1
   Tt+Z2tDk2pVUqbMOabrb2typQpSqoUGHno4HvGIO8l6WYZN0o/2Owq1Kt
   QlZK/i1yOPL914p2eXnoANt3ztYH+g4k53dnx7Mef1wF2YHHYEURl6Vto
   3k6FuS+ScIgH8nXb9hwXQ6rOtjpa4Z4SQAPmn0esA218vcFC66qNqErcF
   A53OjQ8+C7R4jfXpBNmZLKgz63OhUYcR4xrPgSQwReRZwl1vr8c5yzRQz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="387742718"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="387742718"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 10:28:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="662206944"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="662206944"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jan 2023 10:28:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 10:28:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 10:28:51 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 10:28:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDCnD0Rxmc5ozt1BFFqp16+kpc2vW7uwICL620AWg0P8tiicRSWZaWYbbYk/sMx+GgGFXhuXp6xRD5SjwJ5NY1mPsy3XCr89g6dGMm63npzlZOlA6U9sIXHaiMDeBMOFT1oQDHKnRZBqjpASCOVFHCEILK+vFtz5q4vz1rvriaKsU3jWc5R/Gmb6n8qX22ytDNsBNd5JYM2hi0F6VbilmXmVU1FgtCOfWAvvZa8bOzsrcUIq7JsdikiIGPVBh3wH5bztJZ80C/bG7WHNS/YqGQCH/THI6NsKrAHZj35VMyR1mHvqnT64kdpt6oB4HXGz/AcuecDyCcdjKW0F9A+avw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFcFpz99Lp7HjTh84GjBchXguZQ7BchlAOr3bHJgpYg=;
 b=nLD387rOSm6Vfb6KDtqqIx6wktuiTBlYjEtdq2Bv2vOR/gOKchyhbNzqQ/8EdFlT1gP8UrryOFljyxzRA/vUEzb/p9ZiJUpeB7PRpwYKrGzghQqF/U5dhbBs1nhBk0d7mV+TaOaT6xtPDda96S/wwFdvmAHbAz8XBbUQqbfZjr26ebpCj0zMWgyq8lvpZRT2PonxMA/zfENTD0forpPkgbh2L1XTSz83tisWTK+laIsBYcJ8JrnikbOXxEkWSLsLaZZqzDIAWUPOA2ZYBaeBBLT3k9AKl0aMgVq/Ytim7sG0GyLdm8svrbkInylSMXm7ZBFoKBJsrfhqDJUBPahOqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 18:28:50 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 18:28:50 +0000
Message-ID: <efdaecf3-4630-77b7-dd98-7f59b9f744b8@intel.com>
Date:   Thu, 19 Jan 2023 10:28:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6/9] ice: Remove redundant
 pci_enable_pcie_error_reporting()
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>, <linux-pci@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20230118234612.272916-1-helgaas@kernel.org>
 <20230118234612.272916-7-helgaas@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230118234612.272916-7-helgaas@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0230.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::25) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: 31c954eb-f61d-488a-3256-08dafa4b0268
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zmb1lGYaTcXQOjVTpDbxy3AiAaX4CbNafbb7hHqmk4hYfGJQRWNfiqxxryJgRL0zG2PJAI79gyCk1+PlWKhW+Mln4/Okwg7TD1zJ4s20EkMiHwC/YzHK76TUYxDK5RJI1bIvqVa+wOablNNJTQkbCTZ7g1fAwoKPuSyeT8Z4D11xabNnnK7ulZfCV+6omIkw8pvli4JnsG/AgDr6M1/b4TmAvnbEr0keNxSRd29vZzPVWlj7q0Vp3P2JhFaeGAsrRDexmvTcuZuMbazLXx/ZMPUP6uR23CQdrEAzYjPnskirKu4ZcVIWbxDPIopeBf+4wq2Do/AZ/vCAKow+E6mBqlBEWYSwe+WUz36j6acBicltclTMUCcaaFYc7k1V/B7XEvic/4BDtQX3sw5S1wwVc5fpWS3xsp2ZEQ2An4W4JpG6HoHv9t+gUBo2n9yK/8bInaJ6Stcs2UoYltGyg1YiOzSvwmGrwysrU/q3TxuSc/g/R2eVPG28wOx2aXKtYKOfGPgC5NWcNhx6wACiYHJQss/WdiNkvmEv/nLgr4fCzipEr7Rh7p+MB0LRabSY46Lz12rXC2ULxrJM1p/JgDfHvg/0u8BPzv8pQlVoSbQnFdQAgrBs2aJeLKWnnjkuVQIls6ENo1cJ2jMuTamx0mBkYMbJC4XDC6d40HXn5pjs+eSY3DVbOMvKq087BEIFz7MJpbfL/3JRWaO3N07mM22IUP644865tsy4SBVYPr+Ge8s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(38100700002)(31696002)(36756003)(82960400001)(86362001)(31686004)(2616005)(6666004)(186003)(53546011)(6506007)(6486002)(478600001)(26005)(6512007)(5660300002)(8936002)(2906002)(41300700001)(66556008)(66946007)(66476007)(54906003)(4326008)(8676002)(316002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUJRUGk0UTdzODdMTzc0cHIwSU9KcGZ0SS9TS1pvTDNXc29DbUN1dTcveURm?=
 =?utf-8?B?Smk3aUdJQWQvcU0zdk9nQlpYaXNoYm9XaE5PNm1LanRSb0cyaWlpQ0lRcW54?=
 =?utf-8?B?dklGTVVxNjZieTZaSGxEbVJLMlRvbU10OFY2aG9YQWpQc2wxdUMrYmg3YnZC?=
 =?utf-8?B?dURzSGVFZ1R3Sit5YTgzVkt3dnFHc2FiUVZMeDVxUmlnbTk4emtMdUU5Y2xK?=
 =?utf-8?B?UklsaytGWG5Xd3Y1NGh3cnJYSU5hRXI4K2cvWDdHdmJVejU2ZURqNVBaVXBP?=
 =?utf-8?B?OTM2Z3JaeFRRc0lXV0xBU2FyTGprSlpIY0RCdXl2dG1GV21UclE4MnhSUXpH?=
 =?utf-8?B?dHNtbEltL1NaTUJ1akxRYlVXV0ZMYWw5ZVdmSHNvSW83MjhoYU9IV2srTjYw?=
 =?utf-8?B?bzlHR0hmWGZhN2FMZDFOSlRLRFRKMkswVzNXeXorQUY0bWFwVUt5dUlQaU82?=
 =?utf-8?B?Nm1ONWFsYkJVeElvODRTN2tvU3dNait5NFRQMjRzZFdRVDZIM21qOVdUYlBz?=
 =?utf-8?B?N1haZ0thUGkwVmhHemFOWm9sK2d6bXg0VVIzVnhHa3gzUVZGcW5SaGprcWNl?=
 =?utf-8?B?QWx6K3hmbWZaUUhCUHpiNWhWbFFiU013Zmw1bGJDbElob0NvLzd0MGN4bFc3?=
 =?utf-8?B?dUloeXo3eHRtVlVnZVNPb3hwSFJlZ2Y2ejEvUXdYNzhEYjI1blpnYjVhWU5M?=
 =?utf-8?B?bUoyWHlhUGwzbm8zZVUrb2I4U2Y5dGlFWTNMQThxUDlpbGdmT1hpbGpFcmdX?=
 =?utf-8?B?c05VL3hlZlVaVzBwSWh0T014azBiRzByOW4xNGN0TjVpeE05OHRvOE4xMHlB?=
 =?utf-8?B?WDg5TGNJT1cxaXpSVVFYL2xSVU4rRUJ5bnFjV0F1bllaM2ZOOHRxTzlxUmRF?=
 =?utf-8?B?Kzk1R1NoUHpiaTJtSGYycUFKTjRJUWcyNmhMYkR4UGpZcjcvOXlOYURKc0pB?=
 =?utf-8?B?WnZSOTlQVHNydDNFWlJOWlkya21rOEtrbXJua2E3V2JpVHRyUE5zcVVuYTFo?=
 =?utf-8?B?WEpFWUdLYmlGaTM3d2Z1TENyQWdVNWJoWnVETTV6cTA2cWY1Si9JNHNiQ2J4?=
 =?utf-8?B?R0V4QitZYXorUnZTWG1GV3F1UThzR3J0bmdOdWE3R21lTHNIeE5UcVlQNFBB?=
 =?utf-8?B?eGllK2Z2NnB2R0czdjhCT0J0QVc3MHB0TGRQRDVNSXN2cllFU1AwSFc3Z0Q0?=
 =?utf-8?B?anpZQWpCcTVRUi9hZFF6WHBRZDhiS0ZoZmVjZEgyRkY1TDZuMmMrNUwxcXdR?=
 =?utf-8?B?NEU5UURlWkpvaStFbFhzMHhVOXppU05ISlZSWHIwV0Q1cE1JQkRlSHFiNDBJ?=
 =?utf-8?B?ZjRuRDFVN3VRWitCcHpqTC9uUkJGU1RnUXV4RFlnVWprZGcvek11TS9wZVFx?=
 =?utf-8?B?K0NyWnFNTUNJSmVoOE8xTHlqdzNqeFJGaG9Vb1hrdDdJWTNJSTljRFV5cDI2?=
 =?utf-8?B?SWs0bDVXWGJZSU5PbUlGS1EvcjZ0WUdXZkQvOUtXNmRGNGdVNm8wcnVGOEVq?=
 =?utf-8?B?d3d5WXFhcGM3MkdZdVc2TnkzLzBqL0hWUU1MNmlYSEpYdkdRTndMU0d3MGpD?=
 =?utf-8?B?MUlpQlpjZElIM3l2a3NFVnF4cm9KeHJ1dkFpd0xMVmJDUk0vTHl0bmlxRWZK?=
 =?utf-8?B?WFpoZSt4Z25zWUczZGN2U0pINHMrN1hrK0k3S2FuRE9IWi9ObWh6SVVVWnh2?=
 =?utf-8?B?T2dlM1lYcU1wb1NPRXRwZVBZTERjVHdnVUQwZ2p1N1hSSjFHbXRST2tjbFBY?=
 =?utf-8?B?WnVHNVZ5WWM3Mks2T0x4MENjUEJjTElZWjhlWVBiZHAxTVVqWHl1eWF6ZUpU?=
 =?utf-8?B?Lzk4TWN2aFN3M05RYmJvZitsLzRSYS9CZm9NYmovaUZORURpSitKYk44eTNK?=
 =?utf-8?B?Zm1qYUpvNEFuVDYvZ1ptL08yK2xSK3Q3ZG9oUGhsblptYm1aZG5mNEFCNmNh?=
 =?utf-8?B?b2E5eUJEb1UwV0lCNTBQWlVVSDMzWGpmV0krTjFYN1ZOcVRDYzk5OE1BYkQ2?=
 =?utf-8?B?UTZoVG0zYWZ2bElxeWFsQUxudkh6bnRrdkcweXRVSnFkYXJSb0pJU0s3NVZW?=
 =?utf-8?B?SnZmaHhMYnhTdmxXcW5rdS9mUjVrbXluSWoycjVFall5Sy9sbEI5dXFVc1Uy?=
 =?utf-8?B?SlFXazkwRUJXcHBmS2o2MVZQWVJpTnZIOFVtOGJpRkNWakdhZkVjeGUzZmsy?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c954eb-f61d-488a-3256-08dafa4b0268
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:28:49.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LxWL19z6jtJ7KcQfPoQKuqAFktJZ4esLT9tE92BGAXWWAklSSmPD+3qVzzt88sLntxpuJpqLQWrN0VXGGsEjDKYvCVTEJPHOBJkrl4Vaeg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7410
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/2023 3:46 PM, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
> native"), the PCI core does this for all devices during enumeration.
> 
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
> 
> Note that this doesn't control interrupt generation by the Root Port; that
> is controlled by the AER Root Error Command register, which is managed by
> the AER service driver.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> ---
>   drivers/net/ethernet/intel/ice/ice_main.c | 3 ---
>   1 file changed, 3 deletions(-)

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>

> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index a9a7f8b52140..9fb68919df02 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -4672,7 +4672,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
>   		return err;
>   	}
>   
> -	pci_enable_pcie_error_reporting(pdev);
>   	pci_set_master(pdev);
>   
>   	pf->pdev = pdev;
> @@ -4975,7 +4974,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
>   	ice_devlink_destroy_regions(pf);
>   	ice_deinit_hw(hw);
>   err_exit_unroll:
> -	pci_disable_pcie_error_reporting(pdev);
>   	pci_disable_device(pdev);
>   	return err;
>   }
> @@ -5103,7 +5101,6 @@ static void ice_remove(struct pci_dev *pdev)
>   	ice_reset(&pf->hw, ICE_RESET_PFR);
>   	pci_wait_for_pending_transaction(pdev);
>   	ice_clear_interrupt_scheme(pf);
> -	pci_disable_pcie_error_reporting(pdev);
>   	pci_disable_device(pdev);
>   }
>   
