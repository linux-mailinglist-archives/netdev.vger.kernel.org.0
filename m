Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D35A69AF0E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjBQPIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjBQPIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:08:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943E215CAC;
        Fri, 17 Feb 2023 07:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676646524; x=1708182524;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8gnEm+rAntbE/fGN/tr0te9HLEDvY6fsliEEs0xuWvM=;
  b=GYn+bD0eXlt6A3hSoF1HPk1oKQ4tZmpDxmBGPSq7M5anS/+l1D//+kRj
   wYc5cCdFwOeZqmAJXcaD+G+ASseNwULriwCF66OSlM784KGvsz9ymw9A8
   9Q775QUcv5uqGlKCr2K98iQX4+2hriRkVDwuaG8eixlY/ijDoBFYG5ubN
   3dcz649zysQ+tjxS6QzdP34XD/Eyx/gbBj2LRiwwNQf1G1QTONIHybU3i
   FovFZ1ADiqMRXqnn5ALCheT990ghkNSRTyUMkSov4QgK4ScYxUKyxb5Ge
   6mvoEfAvrbKGEgFg9YUhLwwd+RwKgmq4zFyu9AE7f7rxceM55WsVDiCqN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="332007672"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="332007672"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 07:08:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="999471859"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="999471859"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 17 Feb 2023 07:08:31 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 07:08:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 07:08:31 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 07:08:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcg7ppQ+20RbWlgv31drwcVHpUO4DRNdfGZOYGa7739duhJPla9HMYA27lBlADWT+PudCbD37iBMpJSxXfdE6Ht1bE6Z8dFjeNqoLiFu2JEbeCry5h57MlRK+mSYMDdQoyjo12oZflcKRDugiizOhbbWFo2Jienbfc6/cWrywt4nl8fCiiYQN5H7Sqxd+bt1OLeYg2/hgGL2YOTwM8ZNHB21QztKCJdquscd5oamYJR9+Ozebp/a9H9lM+3zU8LZQBz2ZOLlRV42WUDC9xQ/b0R0PYJ3RHYNvxMX6VHWvstKM6mpjICVRl1n9eP+UGLT2yn9rS4ZrQnG91moi7Mlew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsmQ9JMBqxYsPViymWewzNPAOVOGA0D0lT/6IaSPvoo=;
 b=C6P/7F/vGR5mbkRk3U43k/K2gty2k9bhnTT33WdVvzJ7gBQGeV92MgH8Nqu55G1ruPi2SQ7xED0ALG1W2xebOX8Fpr8lDAjPzVe9iALYJcOozu/GFjpumdESQF/jllt/YaDb5wASblcwhMhwdIJPA/oPGyVf3a+HRaiRNUOso9r6mdlBAwNB92yG5LXuzn/YelK/oY2y3xLWh3WcT3WhnZXIMb3xCi5lqcRMYKfkPYwEunqtPm8jM1gqAIxvJPm/hsvU2uK035d6reNXWSBczYFNVVh1izI5bWInCqsgaC895ZWmAPtZNbiLFLevroJ8KLXDVIwGDZUMO0NOmYAyeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA0PR11MB4669.namprd11.prod.outlook.com (2603:10b6:806:99::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 15:08:28 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 15:08:28 +0000
Message-ID: <e85d5bed-6c62-d055-d696-085f447f8fd2@intel.com>
Date:   Fri, 17 Feb 2023 16:06:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v3] net: lan966x: Use automatic selection of VCAP
 rule actionset
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <larysa.zaremba@intel.com>
References: <20230217132831.2508465-1-horatiu.vultur@microchip.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230217132831.2508465-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0194.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA0PR11MB4669:EE_
X-MS-Office365-Filtering-Correlation-Id: 23b1732f-0ba9-4cb9-f00b-08db10f8d2ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cTBJKIwfwOA0e1VXzQWd+RRZcnbOterP+5CdgYnM3O8UjvBPv9q7OBUjE6jvDY6/PgcXaaiajdsrjx7/FDA621CLntKKThF1x20Wy+Ja6ezKMuCVONgpyPt0GwY8o20S3oc/nZ1EeiKiposZQ9CmKgGiPCC+lrEgx30By5B0Pkb+kZp0WcO0ppGIi2ut4H0rRxU3p2QoAd0njRZsP9WxU9MrmC+A67vVNkwLE1Z0pgdjfUFLHAWSG9A8pdnNLLVGQYMEsPkcRwnk5skFmVrE0vDGDvzYk4+SvriCQuGe3O5GA8Lvx6XyP/APNU4C3prRfbFHq2LDAhlXrwSnGr1G4Xo+iGOYT4wKwZQTH85qBUE+Z3e4Snvc58d/nqb4yk0ijMIEpsO1Gb68lw0f/mfzBzZZNB1BCdi8FadSLhOlFZhrhQeQIIvJu0VpNCNH6GvgrBpzlYyPNNdiU2yiQDE9PlGoMjIfiUUpKiZPY2fwTMTQxaB4sGLV34IbpHZbii119WX691uZkt3pXZpPoa9OCLdNSYVozFuzCxuiRxNPIpHrf7BA6Xi9E3rcpfGYkjehv2vnRr3UDyl+MveIs4Pk/cv3Uwr1tn8UxU4he82LAPa/twgGamjVEfpB7SIlHSjKvHzo2rIzS0y5l8NYt5zDge8Kf6/sWsRqJndnnx+W29UcvHrXeTl8g4brZUEDq1LcQtJiFzy6bahS+eiGa5QSp3aKv8dGTTCenV+bPwKQ41U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199018)(31686004)(36756003)(86362001)(31696002)(2906002)(5660300002)(8936002)(83380400001)(38100700002)(82960400001)(66946007)(4326008)(66556008)(66476007)(8676002)(6916009)(6486002)(41300700001)(478600001)(26005)(6512007)(186003)(6506007)(2616005)(316002)(6666004)(107886003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0tnamdoSFVPUHVGSGttOFJpNG8zam9FMDRubHhHcERKRHVKUGZTQ0Qwd1ZX?=
 =?utf-8?B?S0VrTHdJMGdONko2UXFNSU9hc1FHanlnd29jaitDTnZkNjBDQUpLaGpUbWRR?=
 =?utf-8?B?R3hVRzMvUkFxZDNPRURBb1pPeWY5cmRKNGJxQy85blN0OGE1UVE5UVp6RCty?=
 =?utf-8?B?NktWaFdXNU94UkQyQ25rcS9TZVQvYjZNa0tmZEZ1SCtOYURrYzBVRUdCRzFI?=
 =?utf-8?B?djhSazhPdU9sRFk0clBpTjhGaTlJNFR1TjNmclhTVGdsTkV2aGt3RUJDVDFX?=
 =?utf-8?B?bmE0SXFrZ1IvdzVRdUNyeHlqSXFIMUZvbktnVWk4R1FMSlRuRXN3Nm9UVll1?=
 =?utf-8?B?eWZ2UjZPNGE0NTMzWEVwZnRxMzBVYUtRd3F6M0ZiU3F5TWhESWEzaDVaVVdv?=
 =?utf-8?B?UU5oNHV5MWJJMC9BeTl2N3NpdDRHbHRWV1M0eWlEUG9iTmgvallGOGozUTg2?=
 =?utf-8?B?UkErMGJtR25qTWxaL2dsVDZud1QwSExVNEoxSkRlNWNuZUgxc1FFd2lGdmgy?=
 =?utf-8?B?cHk1V1dUR0NVY0pRMFN0bU9zZmxKaHBBYnRQSTNidzVZazdBaVJ5d0RqdU83?=
 =?utf-8?B?dE9UaVJpVDFpWnNjOGxOVDh3anlqcGpOYXgwZnZLNHBzZ1RXNm9mYUplVXZY?=
 =?utf-8?B?Y1BLSGVuYzZ3WmpLUURxZjBXalJrUGk5eDJTdEt6eWQzT0I2OWEySUZUaVEz?=
 =?utf-8?B?L0o3TmVRQWVtRHlONFh6NVR0aHBkMGtwOThkVUlESURIYld2Y0xZN0xoN21P?=
 =?utf-8?B?Mzk5YUVUeWViMFh4WWJsVTZieTNtL1hOTGpscThwWk1hdXFqc0RsWmhvbXdG?=
 =?utf-8?B?eitDbGhtSkx4S1ZydVJmVFRWMERPdEloYklOclEvcTBRMDdOb3lnRytlb0dT?=
 =?utf-8?B?TkJtNFEvdlJxbkx6NFZzei9BMFVHbUFsY0U0c0xNSXgvUDJVUHFLT0pMRXZs?=
 =?utf-8?B?YVdCTCtSdnFmQzd5N0MvekYrMUNLait5WHBJRGV1K1ovZStkekVuUUV5TWlT?=
 =?utf-8?B?ODRGQ0V6Mkh3RFlSdTFTa2o2Rmt5dFBnMjIyWVpRVSsxSk80TGpVUTRMaVlv?=
 =?utf-8?B?UWJQVzNPcTdCdzhJVVgrVlpUekYvc1FQOVQ4cm9MSTNSa0tQQ0tXakdHWklp?=
 =?utf-8?B?cHdJLzFFTUdlWjU3RlhET0J0M2xWamdyN3l6YTRBM1R4WU0vN3pHdUc1VWhz?=
 =?utf-8?B?Uk4wbDh2N0UweTJpTktmN1BON0JrTWVqYi9YcFVLM1NZcmM2RDZzQlN1RjJP?=
 =?utf-8?B?c1FESnFMcVNxRUFUQ3lOak1QZThWVjdDdjU0aklETkRuOUtmbnVtRSt6Yy8z?=
 =?utf-8?B?SnNXUTI2YlhERk9hQjlZMjZLVWZtaW1YeTUxUmdFeTQ5U3VCRWcvTjZ0TUdN?=
 =?utf-8?B?TDRjLzhaVEdsNHlCMzgxMnRXOGVEb1pKSnJTVmlzTEVrQ3BYUWVxdEdRbjEr?=
 =?utf-8?B?RVVEUGRQK2VuUmdHWjMyWWdvaEt3c1JQUUs3TWFHNUI1T2I1Y2JFLzk5SVFj?=
 =?utf-8?B?RVBaWmlIVWJMaFU5TzVFNmI1REhwNys1ZzdJK1dFRUxSVG5NQW9iRlJ6K1lC?=
 =?utf-8?B?NlBBVHEvd09LQ3FKL2NRMmkwcTRXVmhDWGpDSXEwR0YwR1YvR3NhR2JNNkxP?=
 =?utf-8?B?Z1B6SEpZdTVwR0RmdWg3aU9SUHFDMi8xQldQT2NCTGhLVGhRN3dhUWR4RGN5?=
 =?utf-8?B?N3N2QTdoN3hMVVJvV0JHK242QnR6WElvT3Ywb090L1F6SW5GQ21MODgwTnJt?=
 =?utf-8?B?enkrMXlSc3FYWFFsYStUTjZrUG1mS1V6QnFWZVNpdFk0aU42YXMxZkhnNk84?=
 =?utf-8?B?cDAzNTlpZUN6SXF4MndaZ2UxMTNoTXhCRDFKN3YxemlkSnUxVm1KaXhQdE9L?=
 =?utf-8?B?aWF5QU9hd01HcDY1S2pJbDQ5VW0vcHA2V0ZjUWlMSGtpeXZUSmFLWnJ0MEhE?=
 =?utf-8?B?bDVuSW5XM3I2MFJnQW4vQkVyM0kxb24vWCtuMFF2dXlRQ2d6THpCamN1SEZv?=
 =?utf-8?B?VGs5ODIrRVBTNGFSR3ExeXNZZkljcEpZOU8vczAxMG1NYmwxMjB3a1dzOXJt?=
 =?utf-8?B?KzJOVzk5aWlaUGh5U3l4ck9vUm9NMUdrdWEwWkpZTGNRa2Y3YjVIOElzQWtv?=
 =?utf-8?B?S0NoUGgzWXZENU40WVRnZWlpSENCNStsMGpOcXlaU0I4cFV3djYvUXVLK0Zw?=
 =?utf-8?Q?jti8h+bfqoB4UyGgym7t4qk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b1732f-0ba9-4cb9-f00b-08db10f8d2ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 15:08:28.2415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZUl+r2mbQLb8UJRJXY6vU2jApurGJ5fjowsGZ3FsNvezEDo91254J940hW5O/YF2DVSAqu2vaNCFq3gBHgrbVToc+Vt0xGAt2jtwXLjtaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4669
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Fri, 17 Feb 2023 14:28:31 +0100

> Since commit 81e164c4aec5 ("net: microchip: sparx5: Add automatic
> selection of VCAP rule actionset") the VCAP API has the capability to
> select automatically the actionset based on the actions that are attached
> to the rule. So it is not needed anymore to hardcode the actionset in the
> driver, therefore it is OK to remove this.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> v2->v3:
> - fix typo hardcore -> hardcode

:D

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

> - remove vcap_set_rule_set_actionset also for PTP rules
> v1->v2:
> - improve the commit message by mentioning the commit which allows
>   to make this change
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c       | 3 +--
>  drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c | 2 --
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> index a8348437dd87f..ded9ab79ccc21 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
> @@ -83,8 +83,7 @@ static int lan966x_ptp_add_trap(struct lan966x_port *port,
>  	if (err)
>  		goto free_rule;
>  
> -	err = vcap_set_rule_set_actionset(vrule, VCAP_AFS_BASE_TYPE);
> -	err |= vcap_rule_add_action_bit(vrule, VCAP_AF_CPU_COPY_ENA, VCAP_BIT_1);
> +	err = vcap_rule_add_action_bit(vrule, VCAP_AF_CPU_COPY_ENA, VCAP_BIT_1);
>  	err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE, LAN966X_PMM_REPLACE);
>  	err |= vcap_val_rule(vrule, proto);
>  	if (err)
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> index bd10a71897418..f960727ecaeec 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> @@ -261,8 +261,6 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
>  							0);
>  			err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE,
>  							LAN966X_PMM_REPLACE);
> -			err |= vcap_set_rule_set_actionset(vrule,
> -							   VCAP_AFS_BASE_TYPE);
>  			if (err)
>  				goto out;
>  

Thanks,
Olek
