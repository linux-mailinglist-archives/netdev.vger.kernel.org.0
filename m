Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002766740EB
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjASS2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjASS2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:28:44 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EC175A18;
        Thu, 19 Jan 2023 10:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674152916; x=1705688916;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C0wBtwiBuLHQZJAT25b0T4zlTm9BDMUdzqm5TX/U06E=;
  b=W3M02OUw8IhctmASaNt90TX/KI/QZuJhLDU2dOgSAGh8Iv0rNoHBHC2i
   EB67gAZXdxIg6emT1wkyHTuRYhNwXFxdhJiwErdyVZ1UoqKhraCWWwGqj
   Ho78IQlX7hovKqx2/aWKNQ5R1cLTSKHdI5W51q9BQqoKmERLz1OQzJOE4
   0HTisJ5d1lETnm4i1nTE1HegLABysKqCvvfu/eeavutjkBtnASpNXQagp
   wV++darDVRqGCENtK8LHIddLam55BgMQt+8RM2lo4VaIrJbNNoZGFF55O
   S1fsMq+Hsu8MZXUc5miRGA3ox9QX8Nkvv1VroWwkOi85T9Wo5szqGAf0+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305742588"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="305742588"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 10:28:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="749024231"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="749024231"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jan 2023 10:28:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 10:28:31 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 10:28:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 10:28:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJoJGyJAsyPWPu/7QUxI4ZpIOr2aq4t3r3l+ncEz9bfMeGYHnJqMHPkdlSKwEPwGzpWjK4GtwEGf/R+154G7AiyYQmr+HbzNalLE1NT7pA9yRNlOY2hpliIv+Lb+FVbAG742D7LD0SKqRfc9DzRQaZTyPgIJBgSYhmNo0NORjH5NLDOy4m9z6O7dM88FdZS9yyThUUN9V5T5H03OdNewWjDq6eTPRusoCBl8S4l0UOypPkAWrdq3tlmph8UB4fIsW/z73WPoh04sdh13XNYKWdtREPoaByd4F86T0RBKXfMXMmv9fhy6QhBx+sLMjuqpIARs6+FHOYT2Avs4ZY3U3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+7acQJrlb3lxg/mEDZ/JyTAIr63vmk0AzFVRIAu7mw=;
 b=Ov4ZhhbcIsI2xI/ZCb1IRaI00IRUdribSHvwPlU7Lj7r7Dv469reAfuLEtsL2HjjaleCMrpNUc/Lmz0zhX5kS4DiWkOisfR84mBG65Qzv4rWNdNhvyENzUCRplqso1eRZLiVXwHSGmasvPJA9zokFrvyhzrZ5j/U7u/UgT+coZJkzI0nyr9OoIFV+fpq7wrSxKXHPQDy237vnSH4g0pCxlwYJwOsbu0dX+WUKmbFOlnJBYMX24AXfU8SRU7Fb0lb+vP6NYggswV8HqMX7/oSPBEEAibGjvKJfhscqcESoOkPxFwRayGcGIGaNfugdZ3BV7jvZhAdQBkeEtgjUO+X9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 18:28:29 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 18:28:29 +0000
Message-ID: <501c0e7e-fc18-9331-ea08-726af358b31a@intel.com>
Date:   Thu, 19 Jan 2023 10:28:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 3/9] fm10k: Remove redundant
 pci_enable_pcie_error_reporting()
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>, <linux-pci@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20230118234612.272916-1-helgaas@kernel.org>
 <20230118234612.272916-4-helgaas@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230118234612.272916-4-helgaas@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0006.namprd21.prod.outlook.com
 (2603:10b6:a03:114::16) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: 57fd4b51-ab5b-4935-38af-08dafa4af63c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zO4aGEkPeK37/8guCO10FqOvNx5we39jb+tZfZAI1UrD+IlI12DBkTlL/qgwEv0DMTNkUH0B0cmvAG4AlMRenn72CqgvZAFRSi+c+unSQpp+qhuOQ3Kb9Is5xg6Mno3ed3O9gQuMjIZjfn2wjiUSw6EazZSp0obYyb2he7r/Qi0AyUrFzJzZeNpD89+AqvCFNsnSbRUrirC6VrODK02PU7xr4GNGSv3UCOuACe8dpZJ83d2WEHzxdlkEFAbK6GAhMlENaRrwzV0g2hK/QRxV2MGEK7a89lyYNSQcpNdQvOmWLBc3cEDwYcLiSVKmYArPIvt1Uq1VdsODTULD/6U+HsRB0/7vxUGU30fLQ6qgTDFDt9RXA05s5wHVcAymHpTdVOYU3XH32d2tD0x0cP/++IYxm9tvL0hf9ELlHPRlLer7Kyl0B+I7at+rPTQXF9dSJdgCmLlXQ25q7DxA1BIgzI3lYHdx54bDRotYfO+xZ3DfNkQ4TXRri/1ofDgv5+7zItjhWuYXBOihrsP4kRZTScPy3SajSttbTgQWGRpXFNJhnhAAybG4NXwJbQBONp1YN4HGUtzs5Ig7CqSo6ciozte2ZEIbYM4GlrGp5UpubTX+NhEH32exkPeFhN6XPbqdIYEaPyXVXZbEDhBfiKycGYxUJZvB3u+88EgXG8+eb3+YdyEgTbD1OAG0ssK653TbhLB5VrouXPC3VR29HhvpMvuS6Q3wqyRZ17D/EIIDUYQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(38100700002)(31696002)(36756003)(82960400001)(86362001)(31686004)(2616005)(6666004)(186003)(53546011)(6506007)(6486002)(478600001)(26005)(6512007)(5660300002)(8936002)(2906002)(41300700001)(66556008)(66946007)(66476007)(54906003)(4326008)(8676002)(316002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3RWdFd6NVlqVU96N2I4bUp1SXNwSWt4VGJFenZZT3hlSldCVWw4VFJQekJn?=
 =?utf-8?B?aW9PaStaN2lRZVkwZWNkNFFrYmVvaDk0encvb2xVUG1GTE1jaGhkNzFhNVMz?=
 =?utf-8?B?aDZUdlp0S2xjOHFzYzJiYm5lSFc2QWk1MTFlWDZIYjgwWFJkeTdrQzZiS2pB?=
 =?utf-8?B?STJzSThSVUt0ZytVcGFLMzZiNFZuVkRMTzdzVDNBRk1mUWNnM1ZheEFlMkJa?=
 =?utf-8?B?dzhzMU5nK2VPQWZOZXdzbWJQdkg3anZnQ1VlN01GNDcwVElXaW9hRU0xRmdH?=
 =?utf-8?B?d1RIQW5ZemY0dDV0cm9TcHNYOW9BRjlBSzMwK3ZlMzIxNW1yQm0zV0pOWjNx?=
 =?utf-8?B?elBoVFVDM3hUeXA0STAvNzVzOG9SbUhCNFVyRW15Q3B1ZmloaUMzenhERnFO?=
 =?utf-8?B?b2lRbk1GK1hGampMZTZSUXd3OEFFYi9RZFhyYVkzL3RFdThjUlAxMlVrcHA4?=
 =?utf-8?B?bVgwNXcxcU1HS3BaeWR1aFNKQmxrVlJSY3U0K01reGV1NmhoK3prMGlUVThL?=
 =?utf-8?B?NngwbWNFMFdFK1dreUExRmZhc2hZUlhRdDcyRDcrSHhEK202Z3FMZTZabzhL?=
 =?utf-8?B?V3dqQlBGRUNmU0lrVWtKVlBvNXdFRjJLaVNlQ2kzT2ZnU05wUkt5TWo5dG5M?=
 =?utf-8?B?UFNOdDVhK3lLV3MxZ01ERHBvQlpaWmpXZmZqS1AveXJFQ2FXb0o1QmdBT1Nk?=
 =?utf-8?B?Q2I0UnRTYTgxeU04Y2xqSHE2OUVQd242bzRDUWtydVNKSEZzeHVYcHFDdzBT?=
 =?utf-8?B?TWNiRUhNbWF2QmlHZzE3ZldUaWs3eGF6UWswMjBraXJ5aVFVYjFyZHBuUUo4?=
 =?utf-8?B?aTF4WTA0dFFFZ1RweFlFVWFKZitTMWZPdVVsL3VYWGRSTitzOVl2aWNNTjQ5?=
 =?utf-8?B?WnlleFh3R3pkeVF2RjB6ZWVROVlsczFtSU9ka3BNT2NDZ0M2VDhSKzJZR2lk?=
 =?utf-8?B?QUJueElIRlJYQ1hRcmZ1QjZjaFJLaUxncFppOWxCNURNRi9sTFdMZXA1d3o2?=
 =?utf-8?B?S2tqR1VvcVh2eUdUWXM3QTJrdkIxaXN4YmNocFJMa2pXTURJMWlmNGxxTmIx?=
 =?utf-8?B?amJ1c0t3Uk9qNzlqSzZZbmNKa2IzWFA4YUFQU3F5ZnBkQ2VhQy9ibHdRVk9L?=
 =?utf-8?B?MU5LdTNjY1lmcVJvTXBvRjlldStqWU9xT094cHluU1MzQmtRSnJzdEdENjVz?=
 =?utf-8?B?MS9Ga1M5Y05qUCtRa1JVY2xvRE1OSHh5OTdXRXcrQXVBSFN2RmROTzAvMElz?=
 =?utf-8?B?UWJGZnJKZlQzRkh2allTbGxRTWhlWElOVkFqcXQwRmpmVzRndGNldVN1VGxX?=
 =?utf-8?B?cFlTVC91TWJlNlg1VFFkbjZVSE5FNVZPcW1IaitMTHlLUzJ1L094cEZkd2ow?=
 =?utf-8?B?UVZWVEJwWEJFd2xnekpybWRPTk12QjBVcHJlL0pZRDE4K2tIdTFqeDdnU2du?=
 =?utf-8?B?djFhTTNoV1VGZDFsMVB0bXJDQ0c1eDBJeTBHY2dxc3dyR1VnSGlNUzdhcUJG?=
 =?utf-8?B?bFh6a1J6V0tEdjN1QmlYaDhOUTJMMHJQK3I4cmUrZUdqY2M1RzhENVUzUHdh?=
 =?utf-8?B?bGFtKzFvTUZXeld3OENMZVh5NVlMY3JrdnQyZk94RVMwbmVwM0c5aWt0Q0N5?=
 =?utf-8?B?QWMrWTYrQmV5cmtkK1JPTDV5TEhJaXQ2VVdEVHNwSENMUW8va0pQWUltbWpG?=
 =?utf-8?B?SzN6MUtGa0hka0VQNUloV1N0UUNwNHhkMm1mMzUwWW5melpqQUJHdXU3ejh0?=
 =?utf-8?B?d3FaODE5aXdyMytEUW5oY1kzTUFxS25GS1FKK1Z6WnpzWGdWOGJOdjZaU3BW?=
 =?utf-8?B?UGk1QnBoOGRrczRDc2w4Y05qTmtCLy82OVdoN25ZMVp3cGIxSWN5cXNYOW9j?=
 =?utf-8?B?MDBaMDRkMm5XQmVKU0JUVElsNG42eGJ1eUVGZlFyYm9UVnFablY2M1lPM1JG?=
 =?utf-8?B?MEV2Tmp0RFNXS3hrZ0JJb2JsLzNnb1VRaXpSdVB5OFVVUkNZUWtQWjhreEVn?=
 =?utf-8?B?WmJnWWZyekRnNnJKTUE0UStSUm5aQ01NbENObHRVYy85WFpMOER5S21WTVNi?=
 =?utf-8?B?aFY2WndiVS9lanp4SEhiRUZKTXQwUEwwbXNnQS9zRVdZdDZEMy9aTkxubDh1?=
 =?utf-8?B?MjJiU3hHcjV1d05jU0JHb2MxaEp1N20zS0trOEtqREFxZ3I1b2VPaUU4eVpp?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57fd4b51-ab5b-4935-38af-08dafa4af63c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:28:29.4824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xPSP82jhkGRJ3kcEPwsboWXU3yP0kq1seLMLxuqXEn81iMWX9J50W8QIP6GnGcyIcCcYwhWr9G+ZtrOphyuYUD85r6qS2172XUimbtB9ug=
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
>   drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 5 -----
>   1 file changed, 5 deletions(-)

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>

> diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
> index b473cb7d7c57..027d721feb18 100644
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
> @@ -2127,8 +2127,6 @@ static int fm10k_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   		goto err_pci_reg;
>   	}
>   
> -	pci_enable_pcie_error_reporting(pdev);
> -
>   	pci_set_master(pdev);
>   	pci_save_state(pdev);
>   
> @@ -2227,7 +2225,6 @@ static int fm10k_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   err_ioremap:
>   	free_netdev(netdev);
>   err_alloc_netdev:
> -	pci_disable_pcie_error_reporting(pdev);
>   	pci_release_mem_regions(pdev);
>   err_pci_reg:
>   err_dma:
> @@ -2281,8 +2278,6 @@ static void fm10k_remove(struct pci_dev *pdev)
>   
>   	pci_release_mem_regions(pdev);
>   
> -	pci_disable_pcie_error_reporting(pdev);
> -
>   	pci_disable_device(pdev);
>   }
>   
