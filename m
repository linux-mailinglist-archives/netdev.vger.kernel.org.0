Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC10697FFF
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjBOP42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBOP40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:56:26 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4965037579
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 07:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676476570; x=1708012570;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cpqYtfJaK3C7KjJj9b79TJSZN82kxnkVQQhfikPSdR4=;
  b=QpPC/kRmKkdLVY9Dmvl8gFcdLPoa5YKP44NAGt3MValyItUJrMbuHgvT
   tVluoN3AgUPXJbhumMI8w86F6AjplILpkd09yOL/7ECd/0LMd85yCS51J
   ZVMHZ6GaI8mwfC9Lx9BIIKKnjOse3TBgEVTafWdXIfDV4WqE+78qhPpce
   baO+jCcwFD7Kp7hvOSqqxSX504OUltz29Y9UImm6zeFP8cRoeRSRYiz8c
   Mf91W+w0By9VR38mv0S3E+4uEBbvwWZtTvdZQFda3T2mZWFnB0B4xAxqG
   RDhbBrCwc4uWqtDvYlt78144OM2A/wsi18n/IPRriNnBeUEoIESzHrZS8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="319494700"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="319494700"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:56:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="671685379"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="671685379"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 15 Feb 2023 07:56:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 07:56:04 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 07:56:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 07:56:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaugFr2U+IbQ8fkDDrpLPBtgGOIENUczJ48x4zcgVZv/SvhmBFpT/H4/PlPX3eEHldq1ihRAqv8sWrNqjznzLBK5ZltCZZA3rfi4Ntc+FCJzFNU9IjzPaBgCmuf8fo12CfpQxJEhUyxj1+YRm40zGUJhT/188UJcbwt+c3J7+yAwwJQfpMHrBBr2Yz/YDXsoyUkNI5apITjUk5ANTYh43jEZdwdkQWQjvFoa8IE5lLHW1D+YNQNY9vrQh0OQR/6MuybC3bo3jpzNIhwCnUkFWqkBtyp27Thy7RMS9uuOEBgCmDobsCuTcTZJogLqdGjCOCFOaQsKH7VFJbi68Yi2XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJKElIkQeKpY5XzuV5/7EXhMD72+dERa58sMK4AMl68=;
 b=UNUBGal1N9ulHuRnYLcy96eyNh5WpOAQWg+O9EQcDW2ROWJIBSQVh+M/IWVyxOdnmWZXCdJ7Ij4+XI/qTCMqdhsVAPqfMRF+iMglt/nU1sHJPDaiXR+tkhQhLcALN1caTTCN18Xp2pkyNRxE1/on4nIM9CrAChbuU/BFQJn0QfBE1zDGc+lOvNprroW3JFmcsibxLVZYQqi+BKEkLl/eppdKQSvnmSZERrEST1RODm0PrXh0Y1wYDteGU0Mpm5n+YHlXlSdlEP2qt0DAalnXoTUHSxXZJoAIi/5HsQi0DgcCTcoENvD7G85QU6UYL4wZSVoIhUQL4OTuo3bXlT6R6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA0PR11MB4766.namprd11.prod.outlook.com (2603:10b6:806:92::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Wed, 15 Feb
 2023 15:55:58 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 15:55:58 +0000
Message-ID: <37577230-b6b8-641c-6b77-c28b8b6fcb8b@intel.com>
Date:   Wed, 15 Feb 2023 16:54:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH net-next v16] vmxnet3: Add XDP support.
Content-Language: en-US
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <alexandr.lobakin@intel.com>,
        <bang@vmware.com>, <maciej.fijalkowski@intel.com>,
        <witu@nvidia.com>, Yifeng Sun <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20230205155904.2318-1-u9012063@gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230205155904.2318-1-u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA0PR11MB4766:EE_
X-MS-Office365-Filtering-Correlation-Id: f283648c-16c8-4670-e796-08db0f6d2118
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xWqcvHMmE86H+I+lYIa5aHZUdeSzuQnaeKu51JX1tXNEVqGIXC1J7kuPiAArsBgzQRMPrzTFXWLPMl4uRSReWMZYWapS6DVvMGt3E/lX6HlsKg8C5dUFwTh3NlHuWV77YFOt/XnK46XmD6l9iWJpuHBB+NIqyKU2CVywTCX1902qKquBjzD59LfB5XC6L2Hh4EBz+ReQnETO7WWJ/RK3ni7rOM2hLe3lsZAdJ1oh4Sg/sUpGXiHerJi+zfjmfUq9EGQZFMLgZE9jqMU3Tf7nX06F0r6gyaw7IJcvhDqtlu7AcwoUBqGCCNEyW37KsL1y1l3raIbuCkUM+KBsYi8+qGTEusc2/XNbCrfiO4SW1oCAH49qMA3+aIcf/fE/JfJrpwm7BVloaC1JGMKCDoiegcrcmhDoMTex3P5FU1R2iwoEOwcnz77m9uU3IdEg/B5LcMfldBbvPkSJTSlqZizsS5P6C3fUwZkYEptPibR0ACMHj7tIudKj1+Zx+e1rLlxWk7WmX/YEx6qkO2hBb3ZR6IrZLgrpWW1ZPPNegrjplJ6S++/rJnj+c412ABBpYkUU1vyumBDrwQRLs/nAjqbU5iUii7G3SH5Av+xfJ6hr2i26z4dT1IjVoy89EmIrK7AFd+VKgY2HwUit9nnidbzW7Amwl7+/jqDovThDxMc4gD9g7LNX7QQ0yLLTDtWtmMKPruDyxI1JJ63q/3sW4TOL02xzriqU9jrq9VAgS6iGFrU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(7416002)(6486002)(2616005)(31696002)(2906002)(36756003)(6666004)(86362001)(6506007)(26005)(186003)(6512007)(478600001)(4326008)(6916009)(8676002)(41300700001)(82960400001)(83380400001)(31686004)(66476007)(66556008)(54906003)(38100700002)(66946007)(8936002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3AvN1k5aXFZYjF3RDErYVVSaitWV2xZSU5VZ0E2S1ZrWkc0VjVvQkNZU0Ux?=
 =?utf-8?B?eEVWQmN4Q1FiUWNub096T0lrTDgwYTFyaTFLT1FQVHpxZStiMVR3R2E1clJE?=
 =?utf-8?B?U1FnOEdHbjR4YUU0U2lsemxhY1NOenNhbVdlYWc5N1RMeU9kU1hndDJjWnhr?=
 =?utf-8?B?dUFBTmtzVkMwb01TVmJXdGpxWnZYZDB3QXZxK1Q1QzYvQTEwSFFkc2EzakdI?=
 =?utf-8?B?d3d2Q3NmNzZ3L2szUXUvMllmd3BYQmhLemZTTnN0Ky9NTzE3UzZEZnRtdFNq?=
 =?utf-8?B?NEZkN25XQUNndExQblJOVkRpamMyUGI4WUhxWlZvUkFxN2UxV1dFbWFDcHhN?=
 =?utf-8?B?R3NOcm5DNXlhNWgyVThjV2ZHU01iclNFbU95L2ROSFVMcEtIUXBoeHpGM2lY?=
 =?utf-8?B?WjVUL3FxR0JScTVzVVZKOUF4TW5OMGhwT3JxdERwMm5MUVVvVjh5RUJWNFMy?=
 =?utf-8?B?ajRxUXpRdGdmalpDUGtoOU4zaXl6aW8wQitPMmpXNGhEK29qOExGelZjMWhr?=
 =?utf-8?B?SWIrUlBHK1lsODhIUWlkall5eS9QeXlRa2l4bkdIU1FGVE9qTHNRNGhGNG1k?=
 =?utf-8?B?SGY1bFNuaGtTOUZpMmJ5NmFpMmVCWHo0a0JTcVZoQXBTRm9lUGdGV1FSYjd2?=
 =?utf-8?B?eFY4V0JXTGxIcUw1WE5PODVUL2RzYzkvNU5zb3lvSG9VNU01bGZWbHZJNk1P?=
 =?utf-8?B?ZHA0aVZEVTZvR0d4Tk5BblE0K05IckVzOFJubzJXdmpTbUhWaFc0eGRUT1k1?=
 =?utf-8?B?TlU4SGRtb2NOUlZLMldYdkJMbS9LZU4xUzF3MUtHQjlJdStSQXFqTHBHUkZI?=
 =?utf-8?B?UFZPa25DNHZnRzZ6NkFlQUh1ZWpiOG52MUgzUTg0blN6K0FYQW9ZTHljV1Rk?=
 =?utf-8?B?N2VvL2IzSTZYRUd0UVd3c3dNNW1WZU9SM3c1MW54UVVXRHhoMHpMcDNXSVNZ?=
 =?utf-8?B?MDRkY2d5ZEEwcDVhTUFmc01pSnN6WEt3S09aRFBTYnI4WnI4NHl1MGNCTldj?=
 =?utf-8?B?ajdiYzd0dWZmdTVLMjArZjFTWk9idG5YNExHRnBZVit4cmtmeTV3ckU0aVEz?=
 =?utf-8?B?cm9GZjZ4UU5EZ09xd3RCUkdNaEliMzFKcTlNL0ZaMkl6aFhDSGFFUDZSWGJB?=
 =?utf-8?B?WDkxZEQ5clVnOVRaelVPNGZyUVplZHR1NWhDMllpd1JXS3o4Nk5Ycmx1SERF?=
 =?utf-8?B?LzhiWGJjb3FhcW5GYUMxb01aaHBRM015YUtURXZyQ3ROL3dUT25KaVJ6L2JQ?=
 =?utf-8?B?MXB5NENPSkxnL21sZWh0aVB6bmtiMllhSmNnT2QvNmdHZkhTUjdqSGRuUkk1?=
 =?utf-8?B?RW9LTHhndGhNenIyaFBidTBsS3J1bWlISGJ1TWJINGl4aWh5WXRSL1RtWXV0?=
 =?utf-8?B?aTdlaTFBVnFOeHczQjVJcUcvQVVTYTBIOEp6elJCMThCcGlRblVjMExyUUlp?=
 =?utf-8?B?dkl4bmRJU1ZPS1o0Sno2QWJxd01HZUo2M0EyYXA4cjRMRThkc0gwcVZmdVJp?=
 =?utf-8?B?NFNyczlqUXFzZEwvZ0l0RVU3Z25HYS9TUjJCODQ0RjFyV2V4RTlzNDNTQVpP?=
 =?utf-8?B?OU5kT1FWc0g5UldEMjF4RmtScWwrN3lBTkxTdjF6VUxxTTNyK1dJd3oxcnFy?=
 =?utf-8?B?ZlJDTWNMcDZHdTJDOURlU0NVamhRZjFWclhYUDA0Yk5rYlZ4bEVrc3BQMnAx?=
 =?utf-8?B?RVZxckxLSUQrV3I2UTR5NHdLUnNUUCtEY01qeGY2NEd0STM5Zk5ZaWxpTHBZ?=
 =?utf-8?B?akFKZ0JUUmtnTkphcHhvaGM0ZjRCWXlUaGg2MHl6eFZOajdqRXNJbnczU2gw?=
 =?utf-8?B?c1V6dGhYdWhtc05mMzZDSzY2Wm8vSU1DMVArUXBZT0M3Z3BKYlBNWGgyazVI?=
 =?utf-8?B?bkZ0aWRYSDRLZERPZDR5bFlta0xuOGtRVTFNVnJKQ0EwOTVJallwM1FhNkFa?=
 =?utf-8?B?Y0Fqc3dPdkNnRC9CQit6ZHVuN0I4WktiRVArOVFqZlNGcVA5ak9JTER5dWFC?=
 =?utf-8?B?aEpDaDA3Q3loYjVLa1dVK3E3YjFNN2hoQlJsOXA3bDlrS1ZKSk1NZjJXcGJa?=
 =?utf-8?B?UDlzR0RPWjRMMXJYYXVSTHh3UFAvdkJ4WmxOSTdPMDNHb2lrODFTR1RxdGc2?=
 =?utf-8?B?TnEraWUzQzlyNlljR05TMkFycysxZUJSL0ZaUXlram1xRGdub2hIaHA2U2dw?=
 =?utf-8?Q?NyvLEmmJRgC4/FOr0EKGMjg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f283648c-16c8-4670-e796-08db0f6d2118
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 15:55:58.7001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E92UvrGtNgVrTR4sdovogtNxyhpwAOUpvz6eLun6/c4ato/xSfzVbbXIgd+6KYul8H/13n6NxreDLxIauHhwGj0bTC1mXH/P/qvygdsN5Rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4766
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

From: William Tu <u9012063@gmail.com>
Date: Sun,  5 Feb 2023 07:59:04 -0800

> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> 
> Background:
> The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.

[...]

> Signed-off-by: William Tu <u9012063@gmail.com>
> Tested-by: Yifeng Sun <yifengs@vmware.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Hmmm, did I give it? Can't remember :D

> @@ -326,14 +327,16 @@ static void
>  vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
>  		     struct pci_dev *pdev)
>  {
> -	if (tbi->map_type == VMXNET3_MAP_SINGLE)
> +	u32 map_type = tbi->map_type;
> +
> +	if (map_type & VMXNET3_MAP_SINGLE)
>  		dma_unmap_single(&pdev->dev, tbi->dma_addr, tbi->len,
>  				 DMA_TO_DEVICE);
> -	else if (tbi->map_type == VMXNET3_MAP_PAGE)
> +	else if (map_type & VMXNET3_MAP_PAGE)
>  		dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
>  			       DMA_TO_DEVICE);
>  	else
> -		BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> +		BUG_ON((map_type & ~VMXNET3_MAP_XDP));

Excesssive braces around the condition :s

>  
>  	tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
>  }
> @@ -341,19 +344,20 @@ vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
>  
>  static int
>  vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
> -		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter)
> +		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter,
> +		  struct xdp_frame_bulk *bq)
>  {
> -	struct sk_buff *skb;
> +	struct vmxnet3_tx_buf_info *tbi;
>  	int entries = 0;
> +	u32 map_type;
>  
>  	/* no out of order completion */
>  	BUG_ON(tq->buf_info[eop_idx].sop_idx != tq->tx_ring.next2comp);
>  	BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) != 1);
>  
> -	skb = tq->buf_info[eop_idx].skb;
> -	BUG_ON(skb == NULL);
> -	tq->buf_info[eop_idx].skb = NULL;
> -
> +	tbi = &tq->buf_info[eop_idx];
> +	BUG_ON(tbi->skb == NULL);

Prefer `!ptr` over `ptr == NULL`.

> +	map_type = tbi->map_type;
>  	VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
>  
>  	while (tq->tx_ring.next2comp != eop_idx) {

[...]

> @@ -1253,6 +1290,62 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
>  	return NETDEV_TX_OK;
>  }
>  
> +static int
> +vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
> +		  struct vmxnet3_rx_queue *rq, int size)
> +{
> +	const struct page_pool_params pp_params = {
> +		.order = 0,
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> +		.pool_size = size,
> +		.nid = NUMA_NO_NODE,
> +		.dev = &adapter->pdev->dev,
> +		.offset = VMXNET3_XDP_RX_OFFSET,
> +		.max_len = VMXNET3_XDP_MAX_FRSIZE,
> +		.dma_dir = DMA_BIDIRECTIONAL,

Don't you want to set the direction depending on whether you have XDP
enabled? Bidir sync is slower than 1-dir on certain architectures
without DMA coherence engines, as you need to not only drop the page
from the cache, but also do a writeback.

> +	};
> +	struct page_pool *pp;
> +	int err;
> +
> +	pp = page_pool_create(&pp_params);
> +	if (IS_ERR(pp))
> +		return PTR_ERR(pp);
> +
> +	err = xdp_rxq_info_reg(&rq->xdp_rxq, adapter->netdev, rq->qid,
> +			       rq->napi.napi_id);
> +	if (err < 0)
> +		goto err_free_pp;
> +
> +	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq, MEM_TYPE_PAGE_POOL, pp);
> +	if (err)
> +		goto err_unregister_rxq;
> +
> +	rq->page_pool = pp;
> +
> +	return 0;
> +
> +err_unregister_rxq:
> +	xdp_rxq_info_unreg(&rq->xdp_rxq);
> +err_free_pp:
> +	page_pool_destroy(pp);
> +
> +	return err;
> +}

[...]

> +			if (rbi->buf_type != VMXNET3_RX_BUF_XDP)
> +				goto rcd_done;
> +
> +			act = vmxnet3_process_xdp(adapter, rq, rcd, rbi, rxd,
> +						  &skb_xdp_pass);
> +			if (act == XDP_PASS) {
> +				ctx->skb = skb_xdp_pass;
> +				goto sop_done;
> +			}
> +			ctx->skb = NULL;
> +			need_flush |= (act == XDP_REDIRECT);

Also excessive braces :D

> +
> +			goto rcd_done;
> +		}
> +skip_xdp:
> +
>  		if (rcd->sop) { /* first buf of the pkt */
>  			bool rxDataRingUsed;
>  			u16 len;

[...]

> @@ -1470,6 +1591,25 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  			rxDataRingUsed =
>  				VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
>  			len = rxDataRingUsed ? rcd->len : rbi->len;
> +
> +			if (rxDataRingUsed && vmxnet3_xdp_enabled(adapter)) {
> +				struct sk_buff *skb_xdp_pass;
> +				size_t sz;
> +				int act;
> +
> +				sz = rcd->rxdIdx * rq->data_ring.desc_size;
> +				act = vmxnet3_process_xdp_small(adapter, rq,
> +								&rq->data_ring.base[sz],
> +								rcd->len,
> +								&skb_xdp_pass);
> +				if (act == XDP_PASS) {
> +					ctx->skb = skb_xdp_pass;
> +					goto sop_done;
> +				}
> +				need_flush |= (act == XDP_REDIRECT);

(same)

> +
> +				goto rcd_done;
> +			}
>  			new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
>  							    len);
>  			if (new_skb == NULL) {

[...]

> @@ -1755,13 +1898,20 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
>  				&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
>  
>  			if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> -					rq->buf_info[ring_idx][i].skb) {
> +			    rq->buf_info[ring_idx][i].page &&
> +			    rq->buf_info[ring_idx][i].buf_type ==
> +			    VMXNET3_RX_BUF_XDP) {
> +				page_pool_recycle_direct(rq->page_pool,
> +							 rq->buf_info[ring_idx][i].page);

Too long line. Maybe add a `struct page *` variable in this block to
avoid this?

> +				rq->buf_info[ring_idx][i].page = NULL;
> +			} else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> +				   rq->buf_info[ring_idx][i].skb) {
>  				dma_unmap_single(&adapter->pdev->dev, rxd->addr,
>  						 rxd->len, DMA_FROM_DEVICE);
>  				dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
>  				rq->buf_info[ring_idx][i].skb = NULL;
>  			} else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
> -					rq->buf_info[ring_idx][i].page) {
> +				   rq->buf_info[ring_idx][i].page) {
>  				dma_unmap_page(&adapter->pdev->dev, rxd->addr,
>  					       rxd->len, DMA_FROM_DEVICE);
>  				put_page(rq->buf_info[ring_idx][i].page);
[...]

You also need to resubmit the series to add XDP features advertisement,
which Lorenzo introduced recently.
Other that those, looks fine to me, my Rev-by can stay I guess :D

Thanks,
Olek
