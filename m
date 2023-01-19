Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874096740F7
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjASS33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjASS3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:29:18 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5570178A82;
        Thu, 19 Jan 2023 10:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674152943; x=1705688943;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FUk1sO600T0fiIMAgQGgTN+nVRbxQEtL7c/YdVW/PPc=;
  b=dpcGGrCJb7vgIZPtjV+VyfxIPSZxBPCpFkalIiqD+DXIE2F+0O8e1Rdp
   Vj262Ug6zatHCW7vK5bfCdds/hUviiCi8866j2wgz86OcTlPJEoMdrJaa
   VTC+UzrnRrEBe17B6rCDxt2vnJN46Faf/f636L2dJPrDhveZF0smrU5jU
   0COxRFZFJQz2yFkQkOclVIFU7XoNj/Yc/1LiVBTQcRtjP1tm1tTYQWS9c
   uCDUmrGPSfNkmTkkRnI+TbgdVzKaowwtBLPsvXjaHIvCXV40PnD2MDx+I
   tvHKSzLcrGRN4lfYvFOersSuWe3iKXGsGfJYegJtgr2koZV6717P01tbZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="324062927"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="324062927"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 10:29:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="834085189"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="834085189"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 19 Jan 2023 10:29:02 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 10:29:02 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 10:29:02 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 10:29:02 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 10:29:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kvkj7EZWEXbC0c6fhCJ7qwRitGhUq+1QkbXb3+XQsWojPZqsqN0viZQ7HYnEeL6q7xmP8D5gpFxICbF32V34JEnxsCcL88m5+I3csp67PARxj5uYzBUbllxnnTArZvy97HEWtefy1Meckf7r/uLk9myYWsTPWowHupexfmm7iwxQlTIcSUZOs5Sf7cPqaFIqoNqo5R7uc4WG91a2WT9pTfZeF9M0bu/H7LNtMCKkOglC2cmhdXAWNeSMBE6lMwXuVqFooOgiskJeL4dOKayw/VQRnt1sYUpnCES2a7i6a973fYbG7gIi0HNux6nU9Y/eL6OCYEeMbhsopxeMtIdCUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqL0jFOTSPNQjd3GDsvgrVWL+ZuYj03AuV2Gre5zB3A=;
 b=U1AcrHRLNn0MExPgkHSt1+Dlm3ccQbplQLu9fZ0GAmjaohgbFs1N5g9cUVzT/t96Wu8/zwj4P8dwgScECckLmT+M9yO5xG7096Z3lnLn2E367oCbDpPNTK3wFreaOdKR5KRNz3e+qw7tBGWAxRS63fDN/9zz4aRzMdhio2Ieopvawo5bEGy2DaAZAaoK8BLmk3CQi19eIwf18HHPw+esr+HAzPWM4i3KcaDxwvIKwvTSnWeE+4gal6d6DavqbF7vbCaR4+5+PNhc0yb4peVRrhW9GV2+FCVTj1IweeFTSheE3ooQfJLyWIBned7LtF/Hq1K5jpYfFFEHx+vyNkFoLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 18:28:58 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 18:28:58 +0000
Message-ID: <8871e062-8511-36b1-630b-6632cbd0ef96@intel.com>
Date:   Thu, 19 Jan 2023 10:28:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 8/9] igc: Remove redundant
 pci_enable_pcie_error_reporting()
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>, <linux-pci@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20230118234612.272916-1-helgaas@kernel.org>
 <20230118234612.272916-9-helgaas@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230118234612.272916-9-helgaas@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:74::34) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: e0bdbaa0-2386-4960-82fd-08dafa4b077b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GYXgNnFv5iZ43vXcIc2duEGyN7dm+QmIb1lX/VM2DfausNl76BI8PwysHnOLCMsHVjtZtnFfHa6vKAdBOxtTtGWutWESIXDb15FkIh3QVULAuPMAZ5zH/B00v2+8MQ+wZmZ7TerBIeJqyRbNtepq6utk+lkBtN2FbgDpsVY1LT1sH4f7t4q0+3xabG6irXzhSaCTEPMMLJ9hw6ELAMZXMIPhwjGlBcNGEaZBlSOE6wdX03nhneTB3otzW+OSn5io7MQvtv/AAB0WuR6NV2wIALAl02ZLKC9edFqnFLu37eh3GY46DkyiybtGeE6BaMBnXH1K1M4chxZQmcoEtwLTbiRzPJymSBnKYKY0xfD64Vd5SBnVDWMVe+u5sGyDBLEOL0o8ms9pA1PzPEPoG2aoBc/nLccgeUtQYn8o19xVf2C399Y8j1ilio5BQ14UFp44F0SdkmtiUnrz3cxLzIReueUZ6GSebS30zKN39jjDBTBlzx/7R7BXZdD8jDEKHEwmlEL0YUcpmIqP7Lq/4EcjD1WSxE6VzrbcMbdbyheOWXRDUE2HADqTORZcZjQ1dhVAaiwlQg2mqymWZTPHpWz3mhKNNblDZ9pSjcUUeYKAdrD+SmK2Bkb1FgFZA31SBtc0Fq4SvGZqQsQdk5QRBZ9Agkn6PG7048AspDF4YnxZ0RWVl4MaAXABGjczvsAtiW4SzDLWZkEsSsqBG3X3xrs6iHn0lpRQ36z4FeAwSPecTNE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(38100700002)(31696002)(36756003)(82960400001)(86362001)(31686004)(2616005)(186003)(53546011)(6506007)(6486002)(478600001)(26005)(6512007)(5660300002)(8936002)(2906002)(41300700001)(66556008)(66946007)(66476007)(54906003)(4326008)(8676002)(316002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmNPazh6OGVwcDN0ckN6VnFEdGdHeVo3dGpQdlpUSG01a0FXdkQ2dUlKWEpi?=
 =?utf-8?B?T2dHSGQ2clQ2SFlOdS94UzV4YUhETUdZQ2xsZ1RFNmN3WFUxUEgydnRVc245?=
 =?utf-8?B?YkphOE82ME9RVUx0eS9QSnBNZ1dUTTd2T0trbU9DTEpQci9NMDBncStmd0ta?=
 =?utf-8?B?aWVWRzNud2VPNXlMNmY0ZmxWVVQ5TUp6Zm9HZzYycXU3LzVUY1hTcXBKUjI3?=
 =?utf-8?B?d3RHYVlkbmtHbzdMbERqSEZUU21CVGRybVQyam5xbktHcFEyZUhRMS9NQUF4?=
 =?utf-8?B?RHNWNXJlc1VObThGRlNtU0ZQeEJpb3MrU0hlQWh2d0FNZktZWEo2UkhLa3BP?=
 =?utf-8?B?UDlITml6Ny9MQnowdHJmdXpOVVFvc3RCeEhZd2xJdEZORlVQbEpsRk9xWHpV?=
 =?utf-8?B?UFlqN0ZnQVdIcHdYOWM1NkRlMWZJQkFNaXJVcXZYRXgwNXJEbnVWcHFLSnNE?=
 =?utf-8?B?cWpFdCt0aHF6eGZBRkFaVkpJa3BCSFd0R1YxWG5kNXBzVVp2L3k5RU1Sa2hP?=
 =?utf-8?B?enMvbXdyL295YVRseG9YaGZ1TFpNQ2dVYXFTTjhDbjh2dFhEWU1zSlViZTRO?=
 =?utf-8?B?dWxGMEozSGRGQnBNUUZNNXpnYzFIZ2J6ZWppblQ4ZFBpbW1TdW9JYXJQcWxR?=
 =?utf-8?B?N0kzd3JZZTMvTDJXR0JIU2lsY25VQjdFUDVSOWRNQzg3bDBYUUtxMTYxN1lk?=
 =?utf-8?B?U0pFZ09Ud0dsaXpnUVdTZjhIb1VNYkdKVS9yOG5aUVpCakNNRGNCeFZJR3Ns?=
 =?utf-8?B?Mm5VYkZSVkhoMFRNMUpjTTVxZHNsaXRDQU8vSDNsMytHbVNoOU9mY1J6TXNk?=
 =?utf-8?B?VXhhZHJkV2FoQWR4U01ocjBhbE1rZFh3UG1JR3F3UmNZWE9UemliMFBWRnlG?=
 =?utf-8?B?di9tS0FvRkRNT1RyTVFwV0FzWTgydlh1RDRLSmViSG53UDcrNi9vQmg4V1FZ?=
 =?utf-8?B?T1pESlBlVWZhcTdnOEZqMnBTczJIdVNwd0tYd3kwZUlQSGFJa3FPT3BrQmFm?=
 =?utf-8?B?VVdRa3hrbndVeHY5em1YT0hXcVcwSWZrcFRlVkpwV2d6SlozNWU2Ti82REJV?=
 =?utf-8?B?T0dWL3hZNkpKYXU2d01MSGJMOVdmY24zdDI4MXNqNnRDUEpNb1RaOWhsa3Zz?=
 =?utf-8?B?UlM0WUNGalZ2VHJ0N3V3YU1TVWF1OERyaU9YLzVZNlRPWmVxa1I5Zno3Q2dS?=
 =?utf-8?B?V3puM204TjVsRm9xMUJvV3RiV3Z6aFlwNGpGcjB1OC9kNlovbzVuYlE1V0Zp?=
 =?utf-8?B?K1NJTEF4ZmpiTUtWYnVnTHMrZmNTbVBzRXlkVXJuakZ4d1ZNd0NnMjlId2do?=
 =?utf-8?B?UmtMK3ZWbW1WMHQzeEdnLzFBbkhEcXNkZUgxY082cGpnaWVoQ3BkSjFXQkhl?=
 =?utf-8?B?cERELy9uUFFMU3dzM0lJNExQbzY2U3FnTnBYVmZUaCtML2xpTzJkbzc1QnN0?=
 =?utf-8?B?RUdSd1BtdUNNMHpWcnhzbGl5cy9ZOXI0NzB5S2JHWTJ0RVg5T2Jmc3hFUUg0?=
 =?utf-8?B?WlU2S3FIc3ZIM3pvZnFLaitZYzZvWWM0ZjJTRlh1Y1piMlZFSnFKQ1E2aExT?=
 =?utf-8?B?ZWZ0ZWYzMjNWV2dxdWhOYVhYbXRGWkVXOVVCaXRkRzNqalphdDNPWmdtOW5J?=
 =?utf-8?B?cUdTYUZxcmRHczZwblZtUHNLT3FUeXgzKzlqamVhMnFZc21UOE9rL3lvNzJs?=
 =?utf-8?B?R2dqRkJsZ2tSdTZOcVI1WVNCTzhzWGZYckdKeTlvSE5ZeVVIbjBGRmMzOEVS?=
 =?utf-8?B?VFE0VldkeEFrbUhvSVRmVDRQeTVVa2VDZ2N6RmIrSDhpMlNuVUpSRVVkNWpW?=
 =?utf-8?B?aFhoV3VSbWNZOHVrUXphOFF5NWhibnJBNHpWUlBObnd1ZkJYa2RwNUlQaDdS?=
 =?utf-8?B?eTBaZHJSb0IxWXIzaiszTzRCOXBqbjBHRVRROVFub2xWRnFaWmpuWlRldXNI?=
 =?utf-8?B?WHgwZzJZRHk0cmJBSWhZZWtpMVhKYmZZQ1REWXJuWGs5OU9uNzJBWmx2THlP?=
 =?utf-8?B?ZUVRaFpxZ05iQ3RpN0VWZ0JOb09waG1mWWRVQzFhcFJpRHNGNGtDRG52dEQ3?=
 =?utf-8?B?eHRsMXh1MmxDS1dVRzdPcjBSVUhDcUZET1lJRTBKNFUwbGgzVVVOTXJ6NzVV?=
 =?utf-8?B?V2x0R05VTmhBRDY2ejVDOVNwRk5Oa2w0NlRNeTdMZFlremk1cmZFSnltL1J6?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bdbaa0-2386-4960-82fd-08dafa4b077b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:28:58.3560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xpNiAiFiNgGmFSn4+twR6ZAhAiEtDGlyLjNAoybdoRWDlJQ9CE2qtSr7ItQf25zHhfj63s8168h4e4sb4JDGIxL+UVi3rLG3Icp3FzedAgI=
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
>   drivers/net/ethernet/intel/igc/igc_main.c | 5 -----
>   1 file changed, 5 deletions(-)

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>

> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 44b1740dc098..a4df4ef088a9 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6430,8 +6430,6 @@ static int igc_probe(struct pci_dev *pdev,
>   	if (err)
>   		goto err_pci_reg;
>   
> -	pci_enable_pcie_error_reporting(pdev);
> -
>   	err = pci_enable_ptm(pdev, NULL);
>   	if (err < 0)
>   		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
> @@ -6636,7 +6634,6 @@ static int igc_probe(struct pci_dev *pdev,
>   err_ioremap:
>   	free_netdev(netdev);
>   err_alloc_etherdev:
> -	pci_disable_pcie_error_reporting(pdev);
>   	pci_release_mem_regions(pdev);
>   err_pci_reg:
>   err_dma:
> @@ -6684,8 +6681,6 @@ static void igc_remove(struct pci_dev *pdev)
>   
>   	free_netdev(netdev);
>   
> -	pci_disable_pcie_error_reporting(pdev);
> -
>   	pci_disable_device(pdev);
>   }
>   
