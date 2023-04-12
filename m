Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C246E00B4
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDLVUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjDLVTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:19:55 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB5C83CF;
        Wed, 12 Apr 2023 14:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681334363; x=1712870363;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n1xiBa+mKyxmRWLMPT5Q3vnju2JenAdLise1l6vvNfU=;
  b=i59lGbcq7ZQMqWhYtceR847ggTh+/NqrqygGTM3tOGhArBiN0Uw+SNvf
   mqHlWzsAnDjaLdyieNPznsIZHYBj/E377uyFrKP88xRmnIkxFYPElEx+w
   5V0UfMpYm7ttQuvhGdzTzjxJDbwzvT5bmwi3v3g06+57CDzWQJY76bnLZ
   HzMEW2dFNSjKCanbJ5FfDe22myzCg/PskoVV9naDrKxTTl1YFxXbYLo/U
   qrdNA1waViLUWnzAh1JJOMsR2iJ5U3TGrQJbEOm9Qz54JX522JKuCllxC
   21SecZIpi7sNuLfzIYCuU7Bu3LkbpTQzv7ZSVno/JzE5grtAu8lyvbRim
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="371875085"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="371875085"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:18:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="778456195"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778456195"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2023 14:18:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:18:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:18:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:18:52 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:18:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjYlW66Y/WghsiJGPMvMMDUmjoruOLbl3iEWtvF1Vg0YIsyDqgeNHeK1vFObbEtYyCksqI4H7QN6ndAqoZpX3hKv4jPMsX1WRUc7UvjNgHJ3JeuhuMPdR50TJHz/+g4yDmgzx0+eF0H5XoeV9BNXP9VLyl9JTMRVsYbCvxU59X2oDrYZLj3pU98iPclGvjHWqqoNZMPJmZ7GCTPSONHew3pj4r7KwhZw2jU85wpdrpjOeS4iUTaaWk1cNH20xcfhhd0XNMZhS69e70recRyW079KjKDeQZEphwS12syg6t24fFBGv2RHC5NRyxc/h+UtiIKtXUqjLqo0dCJ+K6RqQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6x1SLnKe4QFW1O0GToEHGqZngTg+E/iOFXvgnWRsWuU=;
 b=MJ5pRhmRql1bmL6SyTyXs5X3DeGi8i3grSTKi2INSbexGvkkSOZiLXqoWW/y6eIjVmETQ7wqiUt920eTkg7kuJ9cViZvChpYtUOx3N+sph6VNv6xobZqqX/UlsbHOPE1kq9JXALicfw2HxGt9vsXFa2zfOOYoMXBnlJClyUMqXHIlQyOlbgCDdOIYKDXXKbKmeUEFd7PwZKOE8y7D4FWpIj7QdnqUVAdVejqD7HBVykZNWi2bML8gRgyNAtjq52AgN7vW621TBdxBGUea7nNxCMCh+LwirwNvHk3XhYGzYqLtN22rynAACTdX/b3fqqDtQsywcWdfSnQvDpFp8hTcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7783.namprd11.prod.outlook.com (2603:10b6:8:e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 21:18:50 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:18:50 +0000
Message-ID: <90ee1533-008c-f90e-5f23-f3c42cda85a7@intel.com>
Date:   Wed, 12 Apr 2023 14:18:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 5/8] net: dsa: felix: remove confusing/incorrect
 comment from felix_setup()
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
 <20230412124737.2243527-6-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412124737.2243527-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c041b5-f8fa-4fe4-5bf3-08db3b9b82ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmrh7Mso8t7r9MiJl1N0G//Y926qAiBm+INgQk/dSD4pEuiJ3ott0t6kU76yu2TKoltYUOQYDxr1seu2SFy6PD/ugg7IEMag9J4empmWVU+tH9yOqMfomTp6yytgFN/V+Oj9qdFFb8Sa9C9Op4BeSPfH7Wr4TwpbKuGcQHJpmXTBbr2vM9DxMGYpQm2XVQaq1LJGTdGoezE6E4UKyZA0EiGH3Er4vt37yDlYe59J5f7l2R1SWDWT1Z/3Z0RXlVPYN7MYZl0MrJBT08oclL+PQB/2FVURxueSByA4zMe6CQ2O7iV7Gf2so5mf8OwxwZZQqQqc/jNd17mXheugAO4dbsZbNvSt8R3giH/eBr8HQtiOcA1Q5iZ354E+o5G1hgEgyE8n6UmN6He1syJMauETwZ9edIAdymxK70AO+ESuOeuuE80PhGSyykJxINMbzjVBy4BGZm8Kmh74FWTHijI89Fn8tLS9+RsU8wwaYrGo5KDg19p+VHKls7UKrnAEjSTTzibT1v0eQxejDuv02NQabtLDho8IH/juiNkHfbkxfpCoJ3F0cYGDCjDWUmJLE1f5E1yfTnPxGfSLG8G1S21CFdtZY0J9wskOLGoTS2LWal8AxElVSYv0NTLYOXhhD/jJ142wxiarp+whbaP8PaNByw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199021)(478600001)(53546011)(6506007)(66476007)(26005)(186003)(316002)(6512007)(7416002)(2906002)(4326008)(66946007)(54906003)(66556008)(41300700001)(6486002)(5660300002)(8936002)(8676002)(82960400001)(38100700002)(31696002)(83380400001)(86362001)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkIvdjFpakgxaU1HaGFoRklaQUV6OFJuU3ppU09HamtmcWZFbGl0L1ZFYzBD?=
 =?utf-8?B?Q3VwWjIrZStpSEtRZzdFNURhWVA4bFB6dWhEK2lIRU1jN3ZNR1hDajRmS1Zm?=
 =?utf-8?B?M09rakVXOU9Ed0QyZlV1K3RLWGV6eFdYWDdXTXZHK21ZK1kraUk5ME9RZkJD?=
 =?utf-8?B?c25tTWxUVitDakZaTjVhUko4cFZZRHhna3h4ODR2Vk1DQ3I0MVU0MnZSWldl?=
 =?utf-8?B?cHNrSUZwUEE3cWVmb1JQeEZWMUs5LzEwV0NVb0tGQzRzVzR1ZzBTTVF5MW5U?=
 =?utf-8?B?RFRrLzBnbVNVenZ5cy9md096bFFtYVpBZFR2Sk9QOUVCWlQ0VlJzaXJYTk03?=
 =?utf-8?B?OGhFKy9MQWx0cDViZFJHMmQ5Wmd5akFFQWZnaEtMbWZPclEvZ0ZMK09OUFJS?=
 =?utf-8?B?QTZkSzduTHVyRXRxc3R2TFFEMUd1ZlBmcXI0YkVySllQOENOODR4RE81QXFo?=
 =?utf-8?B?WnVhMFREeFZjYVJFVFRaMXhEM0oxZkNYUUVCMTkxbHIza0YvWGoxYUd4OGRy?=
 =?utf-8?B?UHFNRXBpMy9wV2c4NXNuOW11MWxwbmtCdzIrU0JhU05DdlBBcU1lYjFzVXQ4?=
 =?utf-8?B?SUxSTTlUTnM1MWpaUHhIR1AwYWhOZXE1dzVuRitQMlFFMExQN3pNWFJSRjJM?=
 =?utf-8?B?TkRHL2VjdkpGc0ZKckdvUVUwRDJtQW4yT3JvZlg5d2ZMd1B2cEhCY0VESnRr?=
 =?utf-8?B?bnZCdXJzallGZXlxQjA0ZTZqWm9iRzBmbTB2T24xWEJ4T3JuV3J4c1ZEMW41?=
 =?utf-8?B?cFZsUFM1SHUzUGJKbHUrNC9XQmw5dDNLWmI4Unh2diswMmxhOHBHK1JXR1dG?=
 =?utf-8?B?U3JXN2QydUZjWkVLSDkwRjZPTmw5UDduUzN6WEcrY2s3ei8vWk1GVDdUN2tK?=
 =?utf-8?B?ai9TMFlsMzdhM0poL0VtcUE2OUJWNGZiVlU0eHJNOWhmWCtuTE90VmhSdVFq?=
 =?utf-8?B?TUozM1hpZ3dOK2FJZ0NGQWI1U3EzeXlQQjRVYlJ5VlNCRzdpYUFTSzFnMzhi?=
 =?utf-8?B?eSt3Y3pzYTJtMUpoTXYyRS9tMGhjTFZWS0pvRjlRN1h2VHU1YlpYdUsrQklp?=
 =?utf-8?B?aFVNcytqRWR0MFZsYUZpN2YyMFplUkdmVUNMVlJTRnBJRmxjZ0lySTBlaUNk?=
 =?utf-8?B?UGwwNlU0Wmg1eWVxMHM0UXh5dEJDUlFoWW9BcWtiRVR0TG5ROGE3akxUNktU?=
 =?utf-8?B?aCtRZ3hTSkN1VnZJWFc3YkF0ZXcybjcvRjhPdFFlV09kUWovb1NSM2daZmIr?=
 =?utf-8?B?TG9HdE9MNCtRQUN1citqVGExVGhCSVJXSEhpdXV0cDROcDAwY3hqQU1KUnM5?=
 =?utf-8?B?bWl5OVVpRHhHa0psWGVaaDdMQks3U2FSMlhwOUM5c2xZR2tFU0UwMWlzeUR5?=
 =?utf-8?B?MVE5ZTZYalhTYW1BMXpoREpCL0w1TWQ5L0c5ZURLQW5XK2dlQ29FTXJINHFD?=
 =?utf-8?B?cFhmZXhLUmJlRVZnTTZja1l4UWc5ak9zNmtKTzA4QjBydm9mSWg3Kzh0SlE4?=
 =?utf-8?B?RXMwZ0RRajJ3Y3luNDFLelR1d0k5c216dk5lV1ZiNFI2VzJhYnloVS9Ea1h2?=
 =?utf-8?B?OFBrczBMVGpscDZOSGp5eldCQTQxR1d5YU1UU1E1SUFFR3laL0d4eVFrSzlt?=
 =?utf-8?B?NFI5c2N5MVNrVndHWlNpZmxIOXB4djVOS3BYUGEydGVLVmZDOHBmb1dXTHBm?=
 =?utf-8?B?K0JxOWZORlgrbWszdzdCbVl6V3JlNlJQQmVEVHR6MW41b01jbVIzcXd3MUFa?=
 =?utf-8?B?YkJWVngvTUsyUHhqRlRwMCtwNGlvSEVscm5UemxGZHRGUjV0eXJuUTE4Wnk1?=
 =?utf-8?B?N2h1K0lmUnJMWDllSkExdm5jRURoMkU2K3BRNk9QTjBNd0taOTFjN2JuR0hN?=
 =?utf-8?B?biszZmh0VlhhbjdnQVpMOEg1M1o1VnNveTM4SXN3NUZPaDF0YkRkZHJBK0Nx?=
 =?utf-8?B?cDhzK2E0OEQrYnlEeVZtaEpOTWNXZXU4YnpKOHA1eDM3TWhLVDJxankrNlFU?=
 =?utf-8?B?UWdSWi81WGNzNmdleTl5TEkzd1VOME5oNHhyS1F1bWpMVDUybmVuMDFVaWxr?=
 =?utf-8?B?QVdBZjQ2c1pVbmI0TDgwbFVxWmpXSXMwQ21idjFVc2hUT1F6cCsrUmtTby9F?=
 =?utf-8?B?TUhuR0d6eEtZOUdMM0tZc29LMnVoWkQ5TnU2Y0xiMEdMTUtmN29Sc0FjT25q?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c041b5-f8fa-4fe4-5bf3-08db3b9b82ec
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:18:50.7651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lHvBaITkrB8K8QUPxvawgeE5UeAwipgWJU6/yoIiH+Zbjfot5XGxLGfb9sTF5vZQWHHbcVVrS7C62wFw5R+ljV8UU+IeH+/51dykF4ekJs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7783
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 5:47 AM, Vladimir Oltean wrote:
> That comment was written prior to knowing that what I was actually
> seeing was a manifestation of the bug fixed in commit b4024c9e5c57
> ("felix: Fix initialization of ioremap resources").
> 
> There isn't any particular reason now why the hardware initialization is
> done in felix_setup(), so just delete that comment to avoid spreading
> misinformation.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 6dcebcfd71e7..80861ac090ae 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -1550,11 +1550,6 @@ static int felix_connect_tag_protocol(struct dsa_switch *ds,
>  	}
>  }
>  
> -/* Hardware initialization done here so that we can allocate structures with
> - * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
> - * us to allocate structures twice (leak memory) and map PCI memory twice
> - * (which will not work).
> - */
>  static int felix_setup(struct dsa_switch *ds)
>  {
>  	struct ocelot *ocelot = ds->priv;

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
