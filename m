Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974D869AE43
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBQOnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjBQOnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:43:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD8C68E67;
        Fri, 17 Feb 2023 06:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676645014; x=1708181014;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XivHvRG4VuUvECRsTq2E3S3o4ajihtyyl/MYzsFQv2U=;
  b=HN4HQzyt5W7kfmUCyVfwMDlRrQjrfl0v0znrpJLwOuD+5PfWw7F4ZPQ9
   5gt2i4kxmt3VyNDTcrcQmMoZGlXKn2BusUbKV5HlnmnNrhSIFYTAXAdko
   tvvjTpcq8jDrXvOFjEHBVRxkxjx+b6Y7ExzAMmHyhXXfTjG6nqiOPRQBt
   4GMNhv9D6A35zWS2ZlLGM+i/j+uaY2tV6Zyvn5bS0Es8Kz3HLfqLaKZXD
   0tY1m4MhsCW9dALwvdZC4oR9zAD2oEolZyIWqZI87vC9oUYVKWnphF/AV
   7ZWXNk+TdLjVx29LVyA4eNlnR2FYjBhL9h5hMZQ3oMaJQOFaF9OCMZQGv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="312363786"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="312363786"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 06:43:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="794413531"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="794413531"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 17 Feb 2023 06:43:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 06:43:23 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 06:43:23 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 06:43:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsoAfrkK32J/oAKkvSqG3x2Rc9KtN6Pt58GDty9d6dw6L/eMtVQqZMweVbUzILTp4M4eOQN0ATCrTxJ9qgkU1y+9sUZd8N1GlztHDGOCjdmAGJKl+LUjcbp2LZnOyVLPrW40Vt4tibRT/b+0+UltrpUAnJz6J3O1F/t/JG13JxooOHW9e91BnMI3XNSWlQi3BcZ5JHQJhb969CuoBmdK0kPNx7m2FB4lhRf1fqRVQQBvGN1m3AS+sGBVHSvPVr33TRbGxrM0Bqadj+68kOEmyuv3bR0T9ZI3MMM54MCpLgrdG9jv6leJfblh9rUY5RUPC3bnbJdimp7+/B2tQRrMNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pi7JDQl3WmCqi+xnIfcq5ohoid85cPeqBQY7bysLBHg=;
 b=AYWUlrAj705amR7tCT9nFrkQ5KZQNFHOQ7stZvbpxH7+zi+gf4AN/Ck1kkt7QtbtvYAms4DMt993032TKiewdpNiLpqGdDGPRCgsQwDMadXLAW2CfKenG/KrwkeW3zuldEBeVNPMnCF6KP70f542XQMMq2csxqt5ofV5BpYPcPuMJ82C+6xYZ7t4IfKmOyrZ135BWDp8bI48hAA1phUxof6tzBnNhdXxMenBkmaXtCmEgcPDRyry2QuJkdMi2WDZUkUPN5VebLEl6StSkcanPhINp42dxTaInHeUSP+UR+tqlDgvMxgSULHxww3kCy0v6IeRHGQy3UCWndXj7KykpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB4845.namprd11.prod.outlook.com (2603:10b6:a03:2d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 14:43:20 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 14:43:19 +0000
Message-ID: <0bfc649a-33e2-fa72-6e18-1f94b1df1fec@intel.com>
Date:   Fri, 17 Feb 2023 15:41:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: microchip: sparx5: reduce stack usage
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230217095815.2407377-1-arnd@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217095815.2407377-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB4845:EE_
X-MS-Office365-Filtering-Correlation-Id: 049fb9dc-0025-44d0-086c-08db10f54f86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vi76QwnWfxQIBZpgvkrCLn9YxYUDRGazzc+qSUGEieRyEpy07E4otVekHzu0CRSQSfqtn0SuLXCDJLsU8TjXKkpVvLzxuIXkZEjXt2HFyLUezeSQrts3SSSa9gYPmXTI0GMj3XFIjwuXFDVrSH4m4F+Zz3oSbgGiwKelzQuz6PmN92mqD8ELIineK1sPuFc/n/nMsWjZDdgaZnNuNT3vHoNNCquHwKewyjIkCDW3EyveNBUOkoROBTslnjRBJefCOxbdEZt7ivdJJ2Bm9gmddiICZbUApGh6h4MHjP449WOEc4NU9ClqGHq2GkkLTXsxk5JDisrT1YmM2iOuOJViUC1RmS8N2/kbZ2O4ILDs6YiH+Bu7gJAeFU3XlGj0wcjHHdThMzgPd4F3mEXu4MYAai1IYTz2swssN3hAPAwtJNbbg1+9dJuSKdhlGDDoiVAsxEKREzg+033jNMKPLewuBI8kD1CSGHic6LJ8kQruZhNKyPkS9z3IJOwYtaUqHQmWY9OGiu6i+sDoPaWFty0Fv35e6j/aRjVWbtUt0nGLSaz8XX/HphxHuuGStVTPXv32Th8OO6UFvflMFGdIh0w5o9Qg+cYLCal91Xq4EGoO75Xe/AtrAsamIN1v36Z4ggkXSHjqhtbt3i+9cxh8z3v/DWMyQZCUQpI3H8/X2qp7KAQzPTxQKTw+Ydl3n2V5c40LwAjZ2bbyPfgO0XT4C2cVsnt7+g6sVXSDV7QeCNVKsIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199018)(86362001)(2906002)(82960400001)(38100700002)(31686004)(6486002)(6512007)(6506007)(54906003)(26005)(478600001)(41300700001)(186003)(36756003)(31696002)(66476007)(316002)(66946007)(66556008)(6916009)(8676002)(83380400001)(6666004)(2616005)(4326008)(8936002)(5660300002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVFuTENwbWl6M1NmQkNYT29YSnNJMWFBcU9XK0RZNzNNT2dWNi9va1FrV0Qv?=
 =?utf-8?B?b2tITEYvVER0OWNVVzB3L1U4WDVlekk1dE9uSnc5c2lOeU1kbC9GL2NScGpV?=
 =?utf-8?B?cUJCZURsblVtZWhxd3ZrdkFMSkJPclphYnNtb3hSRklydEpjUmtvUGxGV2s3?=
 =?utf-8?B?RW05RWFONi9rSm1mbUhkcnVwMVBxVTNTZUlWSXVCOXNVczBEbmFQL216cElK?=
 =?utf-8?B?aFVJNUNpdkFhdnE4QkNhdGgxTmpqaTlvUnlrNFZhUjRPVjVKV21KV3FUd2hT?=
 =?utf-8?B?N0J5ZjZnTE5FbTE2U1JqbVlUMFFhd2w4c09FUWE4Z1NqREZoZ1BpdTFxUEUv?=
 =?utf-8?B?d1laTFM3TE1vOW01cVBoTms3aGQ4RExmbEdOSTZJNUZPc2Iwc2NJbHovVUdL?=
 =?utf-8?B?MmptbTI3L2FndFp4SGNTOXpZaXNmcjNOa3MraUtnU2UwTi8xZGZqbEl0WWxn?=
 =?utf-8?B?OGFYRG1ydTVOVHJ1aDVQcFFCYmlIWGZsWHpZRDE4bHhmYTVkVmNaZ2kvRXJo?=
 =?utf-8?B?Z0VUR0c2dE5ZMXQweWZHc20ySnRhQktCTCtYUWtqSkdMYlR1UHJ0bkIva2lK?=
 =?utf-8?B?ZnI2UlhMRUVvWkxSeVc1TkpqU2dpdkc5c2t1RjRicG50NS82dHpTNktkcFcw?=
 =?utf-8?B?dFA2OGNFZzlKejlPTXU1VGk4TUErOG1IRlE2SFB5SE8xVms3YWZ4NFk3Z1lV?=
 =?utf-8?B?ZFBNenVvVUR6U2RVT1VmWENNQU9sQW1zQm5VazVUcGtiN2J1Z2JDR201MTlm?=
 =?utf-8?B?d2ZOSjZ6RnlIM2xnR09KSDdCbW5Id2NxemhOQlV2Y3o0MTIxVHFuaDluVG1S?=
 =?utf-8?B?TERFMGJyaGhzd0kwclovRUpYSnhqYnhUYUVSbmhOeUFjRVNsOXYyY3lrOE9E?=
 =?utf-8?B?L2wwYXdjdlFSc2x4NW5vU0t5WTY1YlZBYTdNQ2tSUmhyaXFUYWpXY0wrcmFI?=
 =?utf-8?B?NlRYNWRTY3lMNHFZN0dMK0orYVZXQmtxb0tjeFk3ZVRSU2QyM3ZWbCtXSkZu?=
 =?utf-8?B?NnA1Z0JmK3hPSnV1WUl5VE9kT3pqazUxL0p2YWNvNEVsTGlPcWgrbGZab2dB?=
 =?utf-8?B?RTF1WTdRaC9pOVAvUmhpRkJNNVZUclRHSC9FWEx0cHRmRnQ5ZDM1cTdqMU1k?=
 =?utf-8?B?Y0d6R0ZqOGc3Y2FYR0twaStnMzJYYTRvLzVCNFN5dVI3Rml2Nml3TE9LckZU?=
 =?utf-8?B?Qk9uOEN0c2tUVUdLNzh2T24wOXhXWStOWnJWTXpCNWlyRzdQd3JUcGZpankr?=
 =?utf-8?B?Wm1LczNJaXh4Ykszalh5dElwV1c5eGc3NmM4U2ZTYzFoQmRwanIvdTZKczdE?=
 =?utf-8?B?MUJ1WG9SazAwbGozT21VRWkybCtxM0pZQVZ4QUZQKzgyL3RVWGt0QmI5ajVE?=
 =?utf-8?B?bEQ0cnQ5MjV3TDFJZSszS1U2N21RakVETzRPU3RaOC91NVNETlQzWEtVbTJ0?=
 =?utf-8?B?RWQ1Wnh4UTMxRUFSQVlQTnlkQVBVRmIvOFZ0SVdFeHRPWlQzeDdpRk9RUHNq?=
 =?utf-8?B?Rk11eDRiL0F3V1VzMU81UEVpbUFtSGpHbHlwUG5POVdFREc5bGtxYTZseHls?=
 =?utf-8?B?eXZTSm9ndkNlTVBNUCt3WTNUM1lCdVM5NWsxVHRoNm40VlcxeDgrekxJekhI?=
 =?utf-8?B?Q2EveDJTamd5bitpYlRGa3kzeEduZ1lxRENBRm9CZTlLM1RERmlMN2UvcVVB?=
 =?utf-8?B?NnphQkpGNGZtd3JpZHJHNGlSSk51aUc1aTJhbTZMN3IzUUkwdzBHTDMySGRu?=
 =?utf-8?B?RzBYUW82TjNhbEFKb2hYWFhENzkvNW1WalRaVkQwZnFLZG85SUFYSHY4VVZM?=
 =?utf-8?B?U3pvSTMzU05RVHkxcVNIRzdMSVhLZVF2bUZmWGVmZkordnR3MVFVTVRNaEZI?=
 =?utf-8?B?OFcwUE1ZQ3JhZFJKRXoyeHBnemcvRDhWK1p0SVFNc1ZiVGtZMjk2aVVwalpz?=
 =?utf-8?B?NVdIQ1FvaFZsSEZ5WHU2S0tXOXNUWU9TRGVuYXFxcWtMcHprTHkvcVhBek9Q?=
 =?utf-8?B?L3FxU1JodmdORml2cjFneStQcERKRTJ5TmlwL2g5RFZMTGJneHZmeldROEIy?=
 =?utf-8?B?WThvRE1acHpNYmdOVnFQSlZpMEQrdEJmcGpvRG5oNWFXZDNYeEdIdDhHbFVu?=
 =?utf-8?B?NzZ5UUtncjJrL2UxeEJZZ25SUmI0MHE3RGhtcEo0RURoeUZwQ2pmVVl2WHE5?=
 =?utf-8?Q?bUCqeemVRPqDMBEuggca4Go=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 049fb9dc-0025-44d0-086c-08db10f54f86
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 14:43:19.3710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdl0+54kxGJI8n4kI4jpgEPAPxEgeNDiqfbFJIakaitW9j5JRLhni8hOIHT/mc4w1TJmjzM6HPXUF3A8Ccd3AmplKda8enP4zHNvj9WWQB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4845
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@kernel.org>
Date: Fri, 17 Feb 2023 10:58:06 +0100

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The vcap_admin structures in vcap_api_next_lookup_advanced_test()
> take several hundred bytes of stack frame, but when CONFIG_KASAN_STACK
> is enabled, each one of them also has extra padding before and after
> it, which ends up blowing the warning limit:
> 
> In file included from drivers/net/ethernet/microchip/vcap/vcap_api.c:3521:
> drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c: In function 'vcap_api_next_lookup_advanced_test':
> drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:1954:1: error: the frame size of 1448 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]
>  1954 | }
> 
> Reduce the total stack usage by replacing the five structures with
> an array that only needs one pair of padding areas.
> 
> Fixes: 1f741f001160 ("net: microchip: sparx5: Add KUNIT tests for enabling/disabling chains")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

I'd suggest the driver authors to reduce the stack usage by moving big
data to the heap where possible tho. Otherwise, there probably will be
a new warning eventually one day.

> ---
>  .../ethernet/microchip/vcap/vcap_api_kunit.c  | 26 +++++++++----------
>  1 file changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> index 0a1d4d740567..c07f25e791c7 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> @@ -1876,53 +1876,51 @@ static void vcap_api_next_lookup_basic_test(struct kunit *test)
>  
>  static void vcap_api_next_lookup_advanced_test(struct kunit *test)
>  {
> -	struct vcap_admin admin1 = {
> +	struct vcap_admin admin[] = {
> +	{
>  		.vtype = VCAP_TYPE_IS0,
>  		.vinst = 0,
>  		.first_cid = 1000000,
>  		.last_cid =  1199999,
>  		.lookups = 6,
>  		.lookups_per_instance = 2,
> -	};
> -	struct vcap_admin admin2 = {
> +	}, {
>  		.vtype = VCAP_TYPE_IS0,
>  		.vinst = 1,
>  		.first_cid = 1200000,
>  		.last_cid =  1399999,
>  		.lookups = 6,
>  		.lookups_per_instance = 2,
> -	};
> -	struct vcap_admin admin3 = {
> +	}, {
>  		.vtype = VCAP_TYPE_IS0,
>  		.vinst = 2,
>  		.first_cid = 1400000,
>  		.last_cid =  1599999,
>  		.lookups = 6,
>  		.lookups_per_instance = 2,
> -	};
> -	struct vcap_admin admin4 = {
> +	}, {
>  		.vtype = VCAP_TYPE_IS2,
>  		.vinst = 0,
>  		.first_cid = 8000000,
>  		.last_cid = 8199999,
>  		.lookups = 4,
>  		.lookups_per_instance = 2,
> -	};
> -	struct vcap_admin admin5 = {
> +	}, {
>  		.vtype = VCAP_TYPE_IS2,
>  		.vinst = 1,
>  		.first_cid = 8200000,
>  		.last_cid = 8399999,
>  		.lookups = 4,
>  		.lookups_per_instance = 2,
> +	}
>  	};
>  	bool ret;
>  
> -	vcap_test_api_init(&admin1);
> -	list_add_tail(&admin2.list, &test_vctrl.list);
> -	list_add_tail(&admin3.list, &test_vctrl.list);
> -	list_add_tail(&admin4.list, &test_vctrl.list);
> -	list_add_tail(&admin5.list, &test_vctrl.list);
> +	vcap_test_api_init(&admin[0]);
> +	list_add_tail(&admin[1].list, &test_vctrl.list);
> +	list_add_tail(&admin[2].list, &test_vctrl.list);
> +	list_add_tail(&admin[3].list, &test_vctrl.list);
> +	list_add_tail(&admin[4].list, &test_vctrl.list);
>  
>  	ret = vcap_is_next_lookup(&test_vctrl, 1000000, 1001000);
>  	KUNIT_EXPECT_EQ(test, false, ret);

Thanks,
Olek
