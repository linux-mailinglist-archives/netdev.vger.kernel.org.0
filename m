Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7624F6E00B2
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjDLVTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDLVTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:19:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AAF8A50;
        Wed, 12 Apr 2023 14:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681334307; x=1712870307;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iG2FyHNpb4elvmkRVFCHL741EDs46aKWmAVUBK0AGFM=;
  b=XRISCSkpOTAOhOydwXy8i1GIk0yN/tnxGZmbSWwpMZc6vDqO8yCPNLAk
   GdbH31KCExJ4uQyToT8C2luY3evIJXTrg6pfAkNQHPNKdQJ47Anr1Dh0x
   iSYsBdS2SWNUILhWcW9gPp8jMpjxt4JMeRtOiVQ3zjQXnoHVRn0AMiqvO
   9aCgTcyQ1VpCcdRg1/zcN8m5rbaXKSBUGGEHeLmNy23COJ1wuSaZvR7TG
   Zmmy8+UPWf3vbI+LASCVVqZ/Ww966GyJT7TuXfsfHLjbypDyfsR35PhRt
   g/LCwK/QnsRBB+M5f52auhvKRjjmIx5GE2b64H1zCeXcMuxcVG21USq3c
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409168475"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409168475"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="691680016"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="691680016"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 12 Apr 2023 14:18:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:18:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:18:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:18:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZG2aTWKDDPDGHzy94Fa8bA9gDuOw9CAgDfidaGA2aLv0y5l5NOzapN49o+ZP+dcyAYKPiYAWO1qOWDjl30Jc7DsDgsuYb88F0F/nO0YT2QED7sSHv38wzswwE+78mNcKX/fCHWSbsv5at7a4tMnU0pKf/xBLN0WFUAgdtpPMFej0j6pWTRefAqS1a0gbVuelcn1H+6mKBPdjR/obCDL8NzzlBJdIhPz2lhFsFm2KrbdcqkVBV8dyb9ib/IKwgA3jMo8LS7FSnDN0Y/0XG4b4KU82jN150uDHMIVJPRY2L/icRW0tcq8TNvGV68JQyMkXjDVG3Wur6sbbWzB7CKiAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40RD17X63kQekLJX38X+icwhDZeNOPrKNXYJJiSAqmM=;
 b=gZBXPRpQujHbVg5bI4r3jHgF86euFsBpRFIkMynlIU5uYvJ7F0o6EEe6u2M4VRxfHaMWopEoQU07ao+sKrO0DVwOsY8uHAqgE8t1w/Em44H+m1INhUdUNHjLBkdmpO4iWqi0sEmVW6U+IO0OadwZmTQdJc5F40/UxTjbNlN+6O1szYnxqP6hHu6rRFMYYl0/oW+3tC1XNoSUhgQAq55PCEFP4CcqGYkXuj2fPIw4OT7MTJyxmahdo9nt1oXIhApkLr+pQrYTwrDUMWw97Nn0agoiDyQ7x8xqqhEbxcJxzjQDLCD/YrfvInaGfmApatsFa54Fg42KX44uCJmAWsUprw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7783.namprd11.prod.outlook.com (2603:10b6:8:e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 21:18:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:18:04 +0000
Message-ID: <54a4ad72-dc77-557f-64b6-b33440efb38a@intel.com>
Date:   Wed, 12 Apr 2023 14:18:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 4/8] net: mscc: ocelot: remove blank line at the
 end of ocelot_stats.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        <linux-kernel@vger.kernel.org>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
 <20230412124737.2243527-5-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412124737.2243527-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::32) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: c2308fb8-c2ce-47e3-1190-08db3b9b6766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUnaHt3mDVpCLPBp1gPksFAaSXcjY7Si38cQs8I4Oa/vGHvWA8ZQ9/7IIpyiUzhC14jN4z3Vuhwc0cbJg3ek4ArGK7ydhXPbXi8oYj65kc/p+aH3NA7VUHJ7Y6A1pOBYKgkW/hAtplbqI5L9DgR1Ziv8oJEwyCAPOUxCIHosS5sNNJy02pQ1Bza2MJxJ9KbFKdmrN5KKsARpbfA8CyWmQveLjXxECDebcD22tlVYeLgfLOz1FdomLNuEQSl76KTEmn50d6xdxuYAbWU7ChfYgjwlE2qfh++f2WmwMCdHF39SS+Ojj3Jy9ILlOgQsZbx7sHlyAeZgTyeSKqGw51P/nOoNJn4PjTog/QMTbWMmekWc6DSfZVFgsDSX3ALLuhQRriZ6oUTgnA5z4xinv7HvIr5Rb3s40NYNhmg3gJ40Lg92tC0BEyiVhbTBKy/ZVnqbZf7SiR+eZDsI9VGomYb9ju0U6Mc2HCo2UMQYmWDUXHM591WDj6gsIG7Xs4sEt9wZCKIlXyrbTFjh25XyjiyhrxkpFTdQ+fjR1q7Oa+MRYjjdHskz9Csqxchq1oHPT+YdidhP6DuA8taxHLWe0wDhIgke3uaedlyO/AANhQjGo+U5dNvrTQxR4v7vBBdZ0d1zJl81h2UjS1B0NBs3SUTxMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199021)(478600001)(53546011)(6506007)(66476007)(26005)(186003)(316002)(6512007)(4744005)(7416002)(2906002)(4326008)(66946007)(54906003)(66556008)(41300700001)(6486002)(5660300002)(8936002)(8676002)(82960400001)(38100700002)(31696002)(83380400001)(86362001)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SklDaU5MaExEa09zUlJpNXN2T2JwTFRodXFEdk1jS09GNUFIaDV0SkgwUHRE?=
 =?utf-8?B?bTNwdE1aU1VNL0VDZ1JQeDBNM2pWS21nbVFTS2pDdjBLY2JNOE5aWlBmOHRE?=
 =?utf-8?B?eDgvbUJpWU96TDJqckdSWUg2a3drMGRLc0wvdzVya3QwL3c1K0QvMHJ6cUht?=
 =?utf-8?B?dGxmOTdha3pEYWtSbVFSMXAxTzV1Tm96UTkwaVZhNkZLSlBJTGo5b2w1V3FJ?=
 =?utf-8?B?TGN1MEhmNDNMNm1hSmtITWRrczV1TVhpSkQ3cTZIMHZoQjdteXlSNC80TzhI?=
 =?utf-8?B?WXpNbkFtMGYreFkzYkRWYWcwcUpsWEU1QnE5dDJhVUxzanpHTVY0dzFiT2Ev?=
 =?utf-8?B?VUxWUFpTdDhHVHphNkV0RTBRV3hjVXo0WDVIR0lkR205YjJxNVBzVEl3WEI0?=
 =?utf-8?B?OFRuRmhNbVJZMzgwUUdwRnMrelRTanFJb3p6ZnpRTjcyYkFVT3d4Ri8wR1p5?=
 =?utf-8?B?cGlSZjFnWVcxd1NEOXpqeG1GcjFodFpXTHhHdWdOdkFmeHN6c2hxUVVpMnJq?=
 =?utf-8?B?K0p2LzFZejZXd2NtVEtRSndla2VpVUFIajBmNzI5S3VIV29zb3ozTFI4TVpF?=
 =?utf-8?B?cDZqbmZzWjRuV3dwVlZHUk1jdTQyN2FYSWo1dXd0SjlsRDBZZHhLL1ZCbDd4?=
 =?utf-8?B?T3VtTlRMUTJvOTI4a2JCbUx2dnRCaHo0VWF0MUMzRU5OWG5uM1cxUUpZTG01?=
 =?utf-8?B?UFN3V3VMM0ZqQm95elROS1RQdVlWN3VoUG9wbG9GRzYvQkJId0xUTmNTZmJH?=
 =?utf-8?B?T0tLWSszczlrSko3L1lMOGl1WHM0OHRKZjZIaFI5OGlMWFdvd2JZb2NBbi9i?=
 =?utf-8?B?MkQ5R0kwTllvcDM5Q2JEbmpnUjJQK1Z0ekNUb1VRaXBMYzdXU2NiZW1sNExw?=
 =?utf-8?B?M3c5L0tsK3VzUkhpWkRZYnVmR2dJL2JJU1o1cXQ3VjJKMnp0K2N5K3pMS0RY?=
 =?utf-8?B?d2RCZnIwNGI4bVA3d1F1MFFaQ1EwQnBwTmU4eW1KQ3pQd1ZiRGtPNmIwOTVu?=
 =?utf-8?B?MEgzV1dRT1REanRSZUw5WlRiRzJ3aUF6MllKb09MMUFLUGNYQW1rR285QTJC?=
 =?utf-8?B?eG1qWjJkcyt2Y3BVaTJaOGRDNGQrWkVXR0U1UjczU0k2ZmR0czZTNmdFaVhI?=
 =?utf-8?B?L0xrcElmdzFPYjQ1M1VYN0RlVFNuTWpqKy9SeWg2MTl6V0IxVjNtSlVVS3B6?=
 =?utf-8?B?bzdBU1Uxc3pMVHpjemlrYUgxTWxRd0lqRGwvdG5JN3pWMTMycGh6MnRsakpr?=
 =?utf-8?B?Q0xVUUNDTVZHKytnN1JqZVF5TmxpN1RGblJRWUxGRkdWd1Y0K3NNMFFYSE5o?=
 =?utf-8?B?d29zUWtUOXN5WW5KZVorUnJxVDdYWE9Vamh3VGNZUW1oUWw4T2ZvN0xCT0Y1?=
 =?utf-8?B?S2dnbXplTTJSOXAxM3JaNmhmK3FXTko4b3N5YjhUSkpSRkZGR1pPaTVVS04x?=
 =?utf-8?B?YXhSMnBEOFhuQnhHa3FiM0poRkRvdGxTYVUvUGx1TWs3N3hIc0s1MjJKZnlz?=
 =?utf-8?B?WFJyRkF6TGJWWTVqTnpaY2ZGanZhSlB1MGE0NkxBU0FuVHFJa1V0OTd2eWUv?=
 =?utf-8?B?alV2cXRDV0YxYThSZ2V2TFpIZjMyVEo5K0VjUmtKQ0p0Vi9pYUNLOHNMUWkw?=
 =?utf-8?B?MGFXaW1TaEc1d05hcWhTSDZjY2dMaktGWHBXZjQ0aC9yTFFmNkNOOTlyekVy?=
 =?utf-8?B?bXpmWnRwaU1VenB6WVFmRUpmMHliUGMwSk5vUlQxb2o0VSs4Q3FBR2FDdFBR?=
 =?utf-8?B?R093TkNnOEN6Z2NaK0RLNnJkanZ6Uk9vUVU1Z2RPMTdNdmtpKzNDT0Jqa3N4?=
 =?utf-8?B?Rk9lY29QeXB0YXAvOU9DcVNvTFNyMS9BZi84aWJEYjJFTktXQzJFVzQxSWEx?=
 =?utf-8?B?YmVjUS9LUFB6d0FKZDA1NEpaKytxbys3bUpKMUNIbVU0clpjV1lBcVptZ0pG?=
 =?utf-8?B?NkI2cVRGWUJMWEh6bUJWTkdwYzZYZ2JJbHUzWEJQOUc1ZTJSSTRuWmUrM3Ba?=
 =?utf-8?B?Mi9rMUNDbVVXUTVSeDNhb0FNYTBQS29aTnlUNGFlOXJ4bHNZME1ZUzl5R1Vz?=
 =?utf-8?B?aGxySXkreEJ6RXZid296ZWpGM3kxWm5YUVpoWEk1dDY2R1pBL09zaU0zMVBV?=
 =?utf-8?B?SS9vb2NzRUwva1lhK2p3MzNvQnNmY25QR0JKV2h4UGxiOHVuU3BHUkVKRStp?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2308fb8-c2ce-47e3-1190-08db3b9b6766
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:18:04.5605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FIcM41EGCVMNM5DJJxfLDI4xcOLafa7dnhtwJRAUfvTVGqN4thmoJ8QlC+gof29hcaHCmGgOyPRSSJkLQfLRustYH+fqbehNJvjswZYDbPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7783
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 5:47 AM, Vladimir Oltean wrote:
> Commit a3bb8f521fd8 ("net: mscc: ocelot: remove unnecessary exposure of
> stats structures") made an unnecessary change which was to add a new
> line at the end of ocelot_stats.c. Remove it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_stats.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
> index b50d9d9f8023..99a14a942600 100644
> --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> @@ -981,4 +981,3 @@ void ocelot_stats_deinit(struct ocelot *ocelot)
>  	cancel_delayed_work(&ocelot->stats_work);
>  	destroy_workqueue(ocelot->stats_queue);
>  }
> -

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
