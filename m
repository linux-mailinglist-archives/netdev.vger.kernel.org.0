Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3196C674755
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 00:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjASXlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 18:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjASXlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 18:41:01 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE7D526C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 15:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674171658; x=1705707658;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fmhr+wRQkO5G4cai6y4vbcONuhwjj7GQSAfyLNRpM5E=;
  b=C8MHc5junca6aKOIRzgfAShvZaM0bFZ+1BmJpWs41ehiFqgFFv9NcOFK
   OJhhPDXrU1RFkoPqTEoajVaSt5Py9P5i0tWfmF1CviQ33EuibuPQvMRI0
   cUEiRs0SyqV3BLgf3Bp73zp2YFP44213Ka4JGh0MbRCSZriAt+r29fIsU
   XT0nvczy1ghjQTMPBsFmWfE5WYtbIF2rylspwj2/Od5ZJc/EJSkQTjfQF
   THTW1RttUAfJlINokF5wKF0+LW9DtQ96pDMD8pRZVV1l1qBXQMh+zr8sB
   lctD9LZ+fK1tcD3xTYpPQZVWxo019/9SPhj5ATKuyNH5EQ45iY4OhbmGQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305137109"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="305137109"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 15:40:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="905746527"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="905746527"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jan 2023 15:40:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 15:40:57 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 15:40:57 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 15:40:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaQA+nMdv4cf94dbIUusPwS8/rzn2tAHkUqVTsnhYwJL51oEaWhSnHTL3TbxlRw2G4fbTA/tuL6ImUCmNmwxOr+AK8acHYt9Rxqz2JfsHlojldufsTTk0LF1Leaer/mC59kuItYXN1I0IplIFnqTTdbKkSDvm6QntdcDhplUUABUfP/lVtu5MBhCixu3MLW6VRtlPRSKebzEUD+1FyHoN7RbZymrmjvJNAcJ7pH30D20YAxZ2QLbAvC5NM26FQcutYhtKvPSroapw7M/OwAsMSXtR51FlrykqOyP7KSTTSCOT+W/xtmlSZXQl5BfTejyhSPW/FAbcBHRwAzYAhTF6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdIq6STV73LHMO84Bcw7v/bI5h13l41HauxZBNnsk7Y=;
 b=BPnlc1w1oSs3+ihqvzqYBTE9XUB96892DoUg0he4hcoQdkUsgZCq7hvgXto7mrcNX/S5U/DyTNAaAhSlnD/m+PEmt1ytDuUmJudMTWQ4lARxpdkd8bvHlr9rDLfa7ox6aKDK8JcvxjRvVf5nQy+3jA0T8sqZUy99msI51snGwRczgnMHen02HGg1HMX9Y3JXhy2PpBzArUNwa6ex9rlwl85Jrxla/tZa5KEXsnEWGEs081JNYFzoZiexnhpdeqZEIFARPW6eN4BG4E9Q4PVR5hZyYqkViN94oz0duxYkuyrXF25tSJxRqG9N4JObOsjS/LsOU7uZKz/BWVJvioVP8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB6899.namprd11.prod.outlook.com (2603:10b6:806:2a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 23:40:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 23:40:53 +0000
Message-ID: <24448301-f6cd-2b8e-f9fa-570bc10953c9@intel.com>
Date:   Thu, 19 Jan 2023 15:40:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/7] sfc: add devlink support for ef100
Content-Language: en-US
To:     <alejandro.lucero-palau@amd.com>, <netdev@vger.kernel.org>,
        <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230119113140.20208-2-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:a03:100::26) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 99b5fba4-f003-47fb-5932-08dafa769a9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEM1cOfH2AUp0PXNq4ooC6p5l5lVOedW/0sIqCEqLuRv0KqU4Med+d6I7bX1utz9epeG3zf1X1AujnLpxDJvuBSBlofLV1Zpqk+B8lzZ/qsva8n7nrej8bby7/VQ7oiqnXf1jSiB/mQpW/IyTIyTZ+Ur7fr8mageiP+h0t3/UlvMIx8GMiwLxlB54mQvkZ5HvpIKrA3Pt1v8xCjKC7OH5g90VnWhZgviqGfbl7Dv1Ggq01LX0e15UdHJGsc12ip4Jrui1l6psBFQEOtLMgpOcEbCYe3lxP+f7BEFdgH7YTkLDDgqTEFjgRzWEMlXvgDCd6PwBqQY+WueFzYAFr4jk09ijpo4o+KjjBjer/tRncRWd1X92EnMessdpYS4ujn3vJcB2cAn/Kt3vdUMWgrJ2kjFC0n5jmneEQ0nDsmsYhe5zO4K3od2S7IWlzDdBDwYyNU0kkZbEKj4cZ773RTaursNzOcfv1LlcQ86OuUqzoqd2jtEiGRXbbeWVoUG2avA361Y4zit7sun+1Kx4uP+gQw91Alqb+qRek2f6BfIdH3phSH1oUud3tgis58xqUxB3Pn/Y7/30Yfay8j/XB5+b2EAAmimx8fPYxF9FvVYaXQ69yZMmuM1QmELtQ0bKuUy/Xy+YCkJTowLBNuDFhNhwFzFDXwPPAuLpFKKWF8oWEUBGL5/VBSuczdAPp26rhSFFrkYqIkq4KXCWE1eJzSiVkgAQcRIJ6iZ/SbHHsaZGP0VvjFY1E2SYrd43etbZOxW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199015)(5660300002)(316002)(36756003)(30864003)(2906002)(2616005)(38100700002)(83380400001)(82960400001)(6486002)(86362001)(31696002)(53546011)(26005)(6506007)(6512007)(186003)(478600001)(8936002)(66476007)(66946007)(66556008)(4326008)(8676002)(41300700001)(31686004)(2004002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDFpQk5kcFVRd3p4cjY0WXhyUXFlMXZQaUNHNmpwTm1DbEJMb2lDK0xkMWJh?=
 =?utf-8?B?R1VuNkJEYm9jamNCeVgzQzJwVGFVMVVodHF5WUQyMFNqMld0NWU0K1R4TWxv?=
 =?utf-8?B?L3kyQUJBZEsvRkowZDlkUWlJNndMcGJxSWdza2N0QmVhUXo2NTRJU3k5MWl0?=
 =?utf-8?B?UTRHUlgxK0tkRzJsT2QzaERDc3IwdEIyMERueHh6UHMwaDRjQlZwTllSK2dB?=
 =?utf-8?B?R2JBWWRMRC9TZkJyc0lIS1ljU2RTS2svL25FN09KcHJVUFRqUjhEWXJyd1V1?=
 =?utf-8?B?WlBPbVVUd3dZTnlOVlExTDhFMU5IY296eUIraXllaFV0bkQvc3pZS1J3SjI2?=
 =?utf-8?B?SnB1ajJRSWJtTVcrZFlPVFlQdGVEaHI4ZkhSMDdSUm53dnNjcTR3WUZDY3ho?=
 =?utf-8?B?b0ZWZCthd2kzZkRUcXFHMWUxK0FkNENWS1BXWW5qM1Z3bHVmd1crSVoxcHRq?=
 =?utf-8?B?dEdRZUhVSCtTeDZIdHUxcDJUWnFpdWpFKytrODRwc2VZdHQvOS9SUWZMbjFo?=
 =?utf-8?B?KyttWkQ1TTVUWXBPWk5LbnFyOFRybitzT1k3Z0FvUGpZbERoTUUzOFlBdzBn?=
 =?utf-8?B?Q1FMTllSckpYUnFwcndkRkpXNmI2YkhqMDJ6N09qWmVSUmpjb3FWZmtNMEda?=
 =?utf-8?B?eEs4WHRFRW9xa01VSjdnRFdaUSttMUlROERFeDM3N3N3b0VwRDNDV29rUHRr?=
 =?utf-8?B?SVJvc1pxMGNLUWtrLzZ6NCtrbE14bk9JRzhGSDNjb3FodWVzZUlCNG1PeTNV?=
 =?utf-8?B?d0lsSlhXcDY4UkpCMkVMZldJY05TOVpxTTJhWll2RmZCelRld2NFR3h1R0l6?=
 =?utf-8?B?eDVWci9sYUg5RlozSCtIVWtLdVh2bExiYlE4c3dPZFdVUkx6eFhvUERFeVFq?=
 =?utf-8?B?NzVoVkhLNElwd1dtYmI5TUZ2eDFOWWZOZC9ISStiQ3dGUWZ0UUFqNVd2UHJi?=
 =?utf-8?B?OWRaemVsREtIMitJWUx1UG10aU1yK0Z1T0o4enVKK0M3Yy9GYUdhMFBTUVd1?=
 =?utf-8?B?bDJRRkZmTDIrM3EvRnN2NW5vNmQ5anJJZXl2cGlUZ3lkb2xKdy9rNE92cVlz?=
 =?utf-8?B?NURSSGg0Zi9HMVJxTiswTEtFdURzSnZWb2k0aFJ1L2x1Ty9FaW1sSnpPd1Zx?=
 =?utf-8?B?dENOams4Y2ZRdStoVno1QzhmY3BLdWpjYTduV2dueEJxQk9XWUlkUTIydXUz?=
 =?utf-8?B?ODNZalhYT3JmZVZvZHMyMFNhZEM3MDhhVzVFQ1o3QjZGaGNPS09kVUh6WWxv?=
 =?utf-8?B?NFNIUmJkaVVMd2ZZYlFvM282WFd1QURKaVU0M09vWHgwVldzOE9JNnNRWnov?=
 =?utf-8?B?bXl3Ym0ybEVBVzJWdjVpL1hYQlQzZTd6aVV5dEEraGo0U3ZHM09Ba3g3WGFq?=
 =?utf-8?B?OGRpVElXMVp5d21TUVJxcTE1U0VUak1FOFAzMEhVVlZjcE5tOVZxOGxpQUlT?=
 =?utf-8?B?NmhtbUY5M0pjWmRiUVVVMFJ3SXpHRmZ2MFRlMi94ekt5STgyQmpzbHNOTm1F?=
 =?utf-8?B?OTBUQVJ1UzZYZ25OZkhHSEg4RjR4QmM1NXRucStLY2ZqSmszZFZ6QWJ2UW9r?=
 =?utf-8?B?R3RWL1VFNTJHUEtENEJyMEk5Ky9teTRTdTBjbGVYblI0TkF2V1ROMktGeDFO?=
 =?utf-8?B?L1Q3b21oU2htYWJYc0djUjA0dlRybkViYmx6MmxTYVNYcDJaeER5ckUzNEx3?=
 =?utf-8?B?OVpKN1NtV1FBUHZWUFdNVDZUcTB4NzlCMjIxQU8weWticzBuVmF0eXphTzcv?=
 =?utf-8?B?Y1NBRDdoU3FVd1dRU0dEYXNKWGlBQzNxWFduWTBMMzd2QW1GZVpvdW1RcW0w?=
 =?utf-8?B?dWszZ3ZPcjZFL000VjBtblNjZ2FVbmxWeTdtMEFaNzZDL2d5cmpvSnFYNlBt?=
 =?utf-8?B?dEt3K2ZraFlnM2VTUUUzckhGNjM5M3ROOVhmZ290VFZwV05uamtTYlA4RlhI?=
 =?utf-8?B?QS93ZFpaS2xkdXpaV1BPTndvNkRtUmhqRXEydEIwU2VwRDFNaW9UUnQ3eUM0?=
 =?utf-8?B?L2V5TTJYRFc0UVBwUkh0Mmc5Vld6REFiZHVXQjVKQVp3NUZvM0ZHZUViSytR?=
 =?utf-8?B?a1VDV1NDb3dKUjdlNGxQTjZyQzhLZ0NWS2VtWGdFVmdNU0xWMkxQOTIwdzEw?=
 =?utf-8?B?VlZIU2w1MHZaZHl2bUNqVytnSnZoMUgxaWZvMFM3aGxFRVRwSUJtcEdXM0VB?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b5fba4-f003-47fb-5932-08dafa769a9a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:40:53.4800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGcpqNKgtcxegG6azPTPl1OV/TbNTQNSN6rktR52enIa88YoH6VGshKexWHXDIRPJ7IAQTSCdI+l4q8yC3R81kho0+j2SYKP1cZZPZGZRgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6899
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



On 1/19/2023 3:31 AM, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Basic support for devlink info command.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
>  drivers/net/ethernet/sfc/Kconfig       |   1 +
>  drivers/net/ethernet/sfc/Makefile      |   3 +-
>  drivers/net/ethernet/sfc/ef100_nic.c   |   6 +
>  drivers/net/ethernet/sfc/efx_devlink.c | 427 +++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/efx_devlink.h |  20 ++
>  drivers/net/ethernet/sfc/mcdi.c        |  72 +++++
>  drivers/net/ethernet/sfc/mcdi.h        |   3 +
>  drivers/net/ethernet/sfc/net_driver.h  |   2 +
>  8 files changed, 533 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
>  create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h
> 
> diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
> index 0950e6b0508f..4af36ba8906b 100644
> --- a/drivers/net/ethernet/sfc/Kconfig
> +++ b/drivers/net/ethernet/sfc/Kconfig
> @@ -22,6 +22,7 @@ config SFC
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	select MDIO
>  	select CRC32
> +	select NET_DEVLINK
>  	help
>  	  This driver supports 10/40-gigabit Ethernet cards based on
>  	  the Solarflare SFC9100-family controllers.
> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
> index 712a48d00069..55b9c73cd8ef 100644
> --- a/drivers/net/ethernet/sfc/Makefile
> +++ b/drivers/net/ethernet/sfc/Makefile
> @@ -6,7 +6,8 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
>  			   mcdi.o mcdi_port.o mcdi_port_common.o \
>  			   mcdi_functions.o mcdi_filters.o mcdi_mon.o \
>  			   ef100.o ef100_nic.o ef100_netdev.o \
> -			   ef100_ethtool.o ef100_rx.o ef100_tx.o
> +			   ef100_ethtool.o ef100_rx.o ef100_tx.o \
> +			   efx_devlink.o
>  sfc-$(CONFIG_SFC_MTD)	+= mtd.o
>  sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>                             mae.o tc.o tc_bindings.o tc_counters.o
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index ad686c671ab8..14af8f314b83 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -27,6 +27,7 @@
>  #include "tc.h"
>  #include "mae.h"
>  #include "rx_common.h"
> +#include "efx_devlink.h"
>  
>  #define EF100_MAX_VIS 4096
>  #define EF100_NUM_MCDI_BUFFERS	1
> @@ -1124,6 +1125,10 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>  		netif_warn(efx, probe, net_dev,
>  			   "Failed to probe base mport rc %d; representors will not function\n",
>  			   rc);
> +	} else {
> +		if (efx_probe_devlink(efx))
> +			netif_warn(efx, probe, net_dev,
> +				   "Failed to register devlink\n");
>  	}
>  

A bit of a weird construction here with the next step in an else block?
I guess this is being treated as an optional feature, and depends on
efx_ef100_get_base_mport succeeding?

It reads a little awkward, but I can't think of a better way to arrange
this unless another helper function was used to combine these two calls
in order to avoid the extra indentation.


>  	rc = efx_init_tc(efx);
> @@ -1157,6 +1162,7 @@ void ef100_remove(struct efx_nic *efx)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
>  
> +	efx_fini_devlink(efx);
>  	efx_mcdi_detach(efx);
>  	efx_mcdi_fini(efx);
>  	if (nic_data)
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> new file mode 100644
> index 000000000000..c506f8f35d25
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -0,0 +1,427 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/****************************************************************************
> + * Driver for AMD network controllers and boards
> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#include <linux/rtc.h>
> +#include "net_driver.h"
> +#include "ef100_nic.h"
> +#include "efx_devlink.h"
> +#include "nic.h"
> +#include "mcdi.h"
> +#include "mcdi_functions.h"
> +#include "mcdi_pcol.h"
> +
> +/* Custom devlink-info version object names for details that do not map to the
> + * generic standardized names.
> + */
> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC	"fw.mgmt.suc"
> +#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC	"fw.mgmt.cmc"
> +#define EFX_DEVLINK_INFO_VERSION_FPGA_REV	"fpga.rev"
> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_HW	"fpga.app"
> +#define EFX_DEVLINK_INFO_VERSION_DATAPATH_FW	DEVLINK_INFO_VERSION_GENERIC_FW_APP
> +#define EFX_DEVLINK_INFO_VERSION_SOC_BOOT	"coproc.boot"
> +#define EFX_DEVLINK_INFO_VERSION_SOC_UBOOT	"coproc.uboot"
> +#define EFX_DEVLINK_INFO_VERSION_SOC_MAIN	"coproc.main"
> +#define EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY	"coproc.recovery"
> +#define EFX_DEVLINK_INFO_VERSION_FW_EXPROM	"fw.exprom"
> +#define EFX_DEVLINK_INFO_VERSION_FW_UEFI	"fw.uefi"

Here, you've defined several new versions, only one of which is
standard. I don't see an associated documentation addition. Please add a
ef100.rst file to Documentation/networking/devlink

It is also preferred to use the standard names or extend the set of
standard names where appropriate first. Can you explain why you didn't
do that here?

For example, the documentation for "fw.undi" indicates it may include
the UEFI driver, and I would expect your UEFI version to be something
like fw.undi or fw.undi.uefi if its distinct...

> +
> +#define EFX_MAX_VERSION_INFO_LEN	64
> +
> +static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
> +					    struct devlink_info_req *req,
> +					    unsigned int partition_type,
> +					    const char *version_name)
> +{
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	u16 version[4];
> +	int rc;
> +
> +	rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
> +				     0);
> +	if (rc)
> +		return rc;
> +
> +	snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u", version[0],
> +		 version[1], version[2], version[3]);
> +	devlink_info_version_stored_put(req, version_name, buf);
> +
> +	return 0;
> +}
> +
> +static void efx_devlink_info_stored_versions(struct efx_nic *efx,
> +					     struct devlink_info_req *req)
> +{
> +	efx_devlink_info_nvram_partition(efx, req, NVRAM_PARTITION_TYPE_BUNDLE,
> +					 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
> +	efx_devlink_info_nvram_partition(efx, req,
> +					 NVRAM_PARTITION_TYPE_MC_FIRMWARE,
> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
> +	efx_devlink_info_nvram_partition(efx, req,
> +					 NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
> +					 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
> +	efx_devlink_info_nvram_partition(efx, req,
> +					 NVRAM_PARTITION_TYPE_EXPANSION_ROM,
> +					 EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
> +	efx_devlink_info_nvram_partition(efx, req,
> +					 NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
> +					 EFX_DEVLINK_INFO_VERSION_FW_UEFI);
> +}
> +
> +#define EFX_MAX_SERIALNUM_LEN	(ETH_ALEN * 2 + 1)
> +
> +static void efx_devlink_info_board_cfg(struct efx_nic *efx,
> +				       struct devlink_info_req *req)
> +{
> +	char sn[EFX_MAX_SERIALNUM_LEN];
> +	u8 mac_address[ETH_ALEN];
> +	int rc;
> +
> +	rc = efx_mcdi_get_board_cfg(efx, (u8 *)mac_address, NULL, NULL);
> +	if (!rc) {
> +		snprintf(sn, EFX_MAX_SERIALNUM_LEN, "%pm", mac_address);
> +		devlink_info_serial_number_put(req, sn);
> +	}
> +}
> +
> +#define EFX_VER_FLAG(_f)	\
> +	(MC_CMD_GET_VERSION_V5_OUT_ ## _f ## _PRESENT_LBN)
> +
> +static void efx_devlink_info_running_versions(struct efx_nic *efx,
> +					      struct devlink_info_req *req)
> +{

This function for doing running versions is very long, and seems quite
complicated. It's difficult to parse what versions are being reported.

I saw that your stored version used a helper function to separate each
thing out nicely. Is there any way to do that here?

> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	unsigned int flags, build_id;
> +	union {
> +		const __le32 *dwords;
> +		const __le16 *words;
> +		const char *str;
> +	} ver;

For example, you've got this local union on the stack that seems to be
reused a bunch...

> +	struct rtc_time build_date;
> +	size_t outlength, offset;
> +	u64 tstamp;
> +	int rc;
> +
> +	rc = efx_mcdi_rpc(efx, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
> +			  outbuf, sizeof(outbuf), &outlength);
> +	if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN)
> +		return;
> +
> +	/* Handle previous output */
> +	if (outlength < MC_CMD_GET_VERSION_V2_OUT_LEN) {
> +		ver.words = (__le16 *)MCDI_PTR(outbuf,
> +					       GET_VERSION_EXT_OUT_VERSION);
> +		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +				  le16_to_cpu(ver.words[0]),
> +				  le16_to_cpu(ver.words[1]),
> +				  le16_to_cpu(ver.words[2]),
> +				  le16_to_cpu(ver.words[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
> +						 buf);
> +		return;
> +	}
> +
> +	/* Handle V2 additions */
> +	flags = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_FLAGS);
> +	if (flags & BIT(EFX_VER_FLAG(BOARD_EXT_INFO))) {
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%s",
> +			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_NAME));
> +		devlink_info_version_fixed_put(req,
> +					       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
> +					       buf);
> +
> +		/* Favour full board version if present (in V5 or later) */
> +		if (~flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
> +			snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u",
> +				 MCDI_DWORD(outbuf,
> +					    GET_VERSION_V2_OUT_BOARD_REVISION));
> +			devlink_info_version_fixed_put(req,
> +						       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
> +						       buf);
> +		}
> +
> +		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_SERIAL);
> +		if (ver.str[0])
> +			devlink_info_board_serial_number_put(req, ver.str);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(FPGA_EXT_INFO))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V2_OUT_FPGA_VERSION);
> +		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u_%c%u",
> +				  le32_to_cpu(ver.dwords[0]),
> +				  'A' + le32_to_cpu(ver.dwords[1]),
> +				  le32_to_cpu(ver.dwords[2]));
> +
> +		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_FPGA_EXTRA);
> +		if (ver.str[0])
> +			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
> +				 " (%s)", ver.str);
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_FPGA_REV,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(CMC_EXT_INFO))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V2_OUT_CMCFW_VERSION);
> +		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +				  le32_to_cpu(ver.dwords[0]),
> +				  le32_to_cpu(ver.dwords[1]),
> +				  le32_to_cpu(ver.dwords[2]),
> +				  le32_to_cpu(ver.dwords[3]));
> +
> +		tstamp = MCDI_QWORD(outbuf,
> +				    GET_VERSION_V2_OUT_CMCFW_BUILD_DATE);
> +		if (tstamp) {
> +			rtc_time64_to_tm(tstamp, &build_date);
> +			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
> +				 " (%ptRd)", &build_date);
> +		}
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC,
> +						 buf);
> +	}
> +
> +	ver.words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V2_OUT_VERSION);
> +	offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			  le16_to_cpu(ver.words[0]), le16_to_cpu(ver.words[1]),
> +			  le16_to_cpu(ver.words[2]), le16_to_cpu(ver.words[3]));
> +	if (flags & BIT(EFX_VER_FLAG(MCFW_EXT_INFO))) {
> +		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_ID);
> +		snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
> +			 " (%x) %s", build_id,
> +			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_NAME));
> +	}
> +	devlink_info_version_running_put(req,
> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
> +					 buf);
> +
> +	if (flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V2_OUT_SUCFW_VERSION);
> +		tstamp = MCDI_QWORD(outbuf,
> +				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
> +		rtc_time64_to_tm(tstamp, &build_date);
> +		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN,
> +			 "%u.%u.%u.%u type %x (%ptRd)",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]), le32_to_cpu(ver.dwords[3]),
> +			 build_id, &build_date);
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
> +						 buf);
> +	}
> +
> +	if (outlength < MC_CMD_GET_VERSION_V3_OUT_LEN)
> +		return;
> +
> +	/* Handle V3 additions */
> +	if (flags & BIT(EFX_VER_FLAG(DATAPATH_HW_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V3_OUT_DATAPATH_HW_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_DATAPATH_HW,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(DATAPATH_FW_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V3_OUT_DATAPATH_FW_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_DATAPATH_FW,
> +						 buf);
> +	}
> +
> +	if (outlength < MC_CMD_GET_VERSION_V4_OUT_LEN)
> +		return;
> +
> +	/* Handle V4 additions */
> +	if (flags & BIT(EFX_VER_FLAG(SOC_BOOT_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SOC_BOOT_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_SOC_BOOT,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(SOC_UBOOT_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SOC_UBOOT_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_SOC_UBOOT,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(SOC_MAIN_ROOTFS_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SOC_MAIN_ROOTFS_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_SOC_MAIN,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(SOC_RECOVERY_BUILDROOT_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SOC_RECOVERY_BUILDROOT_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(SUCFW_VERSION)) &&
> +	    ~flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V4_OUT_SUCFW_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
> +						 buf);
> +	}
> +
> +	if (outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
> +		return;
> +
> +	/* Handle V5 additions */
> +
> +	if (flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V5_OUT_BOARD_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
> +						 buf);
> +	}
> +
> +	if (flags & BIT(EFX_VER_FLAG(BUNDLE_VERSION))) {
> +		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
> +						GET_VERSION_V5_OUT_BUNDLE_VERSION);
> +
> +		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
> +			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
> +			 le32_to_cpu(ver.dwords[2]),
> +			 le32_to_cpu(ver.dwords[3]));
> +
> +		devlink_info_version_running_put(req,
> +						 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID,
> +						 buf);
> +	}
> +}

In the ice driver I implemented each version extraction as a separate
function to make it more clear which versions where which. This running
function could benefit from some organization like that.

> +
> +#undef EFX_VER_FLAG
> +
> +static void efx_devlink_info_query_all(struct efx_nic *efx,
> +				       struct devlink_info_req *req)
> +{
> +	efx_devlink_info_board_cfg(efx, req);
> +	efx_devlink_info_stored_versions(efx, req);
> +	efx_devlink_info_running_versions(efx, req);
> +}

Do you really need this to be a separate function and not just inlined
into the caller, efx_devlink_info_get.

> +
> +struct efx_devlink {
> +	struct efx_nic *efx;
> +};
> +
> +static int efx_devlink_info_get(struct devlink *devlink,
> +				struct devlink_info_req *req,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct efx_devlink *devlink_private = devlink_priv(devlink);
> +	struct efx_nic *efx = devlink_private->efx;
> +
> +	efx_devlink_info_query_all(efx, req);
> +	return 0;
> +}
> +
> +static const struct devlink_ops sfc_devlink_ops = {
> +	.info_get			= efx_devlink_info_get,
> +};
> +
> +void efx_fini_devlink(struct efx_nic *efx)
> +{
> +	if (efx->devlink) {
> +		struct efx_devlink *devlink_private;
> +
> +		devlink_private = devlink_priv(efx->devlink);
> +
> +		devlink_unregister(efx->devlink);
> +		devlink_free(efx->devlink);
> +		efx->devlink = NULL;
> +	}
> +}
> +
> +int efx_probe_devlink(struct efx_nic *efx)
> +{
> +	struct efx_devlink *devlink_private;
> +
> +	efx->devlink = devlink_alloc(&sfc_devlink_ops,
> +				     sizeof(struct efx_devlink),
> +				     &efx->pci_dev->dev);
> +	if (!efx->devlink)
> +		return -ENOMEM;
> +	devlink_private = devlink_priv(efx->devlink);
> +	devlink_private->efx = efx;
> +
> +	devlink_register(efx->devlink);
> +

So drivers implementing devlink typically would allocate the devlink
early (almost the first thing it does) and make its private field
something like their main private data structure.

Obviously you're adding this to a pre-existing driver and it is
initially simpler and easier to keep it separate. I'm not sure what
other reviewers' stance on this is, but I think its preferable to
allocate as an early stage and register once the driver is ready to
accept requests from user space.

As for a reason why, implementing reload support effectively requires this.

> +	return 0;
> +}
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
> new file mode 100644
> index 000000000000..997f878aea93
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/****************************************************************************
> + * Driver for AMD network controllers and boards
> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#ifndef _EFX_DEVLINK_H
> +#define _EFX_DEVLINK_H
> +
> +#include "net_driver.h"
> +#include <net/devlink.h>
> +
> +int efx_probe_devlink(struct efx_nic *efx);
> +void efx_fini_devlink(struct efx_nic *efx);
> +
> +#endif	/* _EFX_DEVLINK_H */
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> index af338208eae9..328cae82a7d8 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -2308,6 +2308,78 @@ static int efx_mcdi_nvram_update_finish(struct efx_nic *efx, unsigned int type)
>  	return rc;
>  }
>  
> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
> +			    u32 *subtype, u16 version[4], char *desc,
> +			    size_t descsize)
> +{
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
> +	efx_dword_t *outbuf;
> +	size_t outlen;
> +	u32 flags;
> +	int rc;
> +
> +	outbuf = kzalloc(MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2, GFP_KERNEL);
> +	if (!outbuf)
> +		return -ENOMEM;
> +
> +	MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
> +
> +	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_NVRAM_METADATA, inbuf,
> +				sizeof(inbuf), outbuf,
> +				MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2,
> +				&outlen);
> +	if (rc)
> +		goto out_free;
> +	if (outlen < MC_CMD_NVRAM_METADATA_OUT_LENMIN) {
> +		rc = -EIO;
> +		goto out_free;
> +	}
> +
> +	flags = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_FLAGS);
> +
> +	if (desc && descsize > 0) {
> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN)) {
> +			if (descsize <=
> +			    MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)) {
> +				rc = -E2BIG;
> +				goto out_free;
> +			}
> +
> +			strncpy(desc,
> +				MCDI_PTR(outbuf, NVRAM_METADATA_OUT_DESCRIPTION),
> +				MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen));
> +			desc[MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)] = '\0';
> +		} else {
> +			desc[0] = '\0';
> +		}
> +	}
> +
> +	if (subtype) {
> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN))
> +			*subtype = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_SUBTYPE);
> +		else
> +			*subtype = 0;
> +	}
> +
> +	if (version) {
> +		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN)) {
> +			version[0] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_W);
> +			version[1] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_X);
> +			version[2] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Y);
> +			version[3] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Z);
> +		} else {
> +			version[0] = 0;
> +			version[1] = 0;
> +			version[2] = 0;
> +			version[3] = 0;
> +		}
> +	}
> +
> +out_free:
> +	kfree(outbuf);
> +	return rc;
> +}
> +
>  int efx_mcdi_mtd_read(struct mtd_info *mtd, loff_t start,
>  		      size_t len, size_t *retlen, u8 *buffer)
>  {
> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> index 7e35fec9da35..63b090587f7a 100644
> --- a/drivers/net/ethernet/sfc/mcdi.h
> +++ b/drivers/net/ethernet/sfc/mcdi.h
> @@ -379,6 +379,9 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
>  			bool *protected_out);
>  int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
>  int efx_mcdi_nvram_test_all(struct efx_nic *efx);
> +int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
> +			    u32 *subtype, u16 version[4], char *desc,
> +			    size_t descsize);
>  int efx_mcdi_handle_assertion(struct efx_nic *efx);
>  int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
>  int efx_mcdi_wol_filter_set_magic(struct efx_nic *efx, const u8 *mac,
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 3b49e216768b..d036641dc043 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -994,6 +994,7 @@ enum efx_xdp_tx_queues_mode {
>   *      xdp_rxq_info structures?
>   * @netdev_notifier: Netdevice notifier.
>   * @tc: state for TC offload (EF100).
> + * @devlink: reference to devlink structure owned by this device
>   * @mem_bar: The BAR that is mapped into membase.
>   * @reg_base: Offset from the start of the bar to the function control window.
>   * @monitor_work: Hardware monitor workitem
> @@ -1179,6 +1180,7 @@ struct efx_nic {
>  	struct notifier_block netdev_notifier;
>  	struct efx_tc_state *tc;
>  
> +	struct devlink *devlink;
>  	unsigned int mem_bar;
>  	u32 reg_base;
>  
