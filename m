Return-Path: <netdev+bounces-9875-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2BF72B056
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 07:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BAC9281417
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 05:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30B61848;
	Sun, 11 Jun 2023 05:11:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6ED139B
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 05:11:45 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA19C30E3
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 22:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686460303; x=1717996303;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6kdb26NhjRGM5mWBm8bwHYC03EpYYHJS/kOwNHRIIB4=;
  b=UrlWEjq93JqDeL3SI/Mj4l9CyFFyxtmwmowCPwuyYYLSU/PYvtd+CTGz
   u8viKSzuSHpFsEt6X1tp7Hse3EvkVoEN/OSaYl9sQ/TbQVfiMNrfxrkIH
   FTwSVJDT/fVbWQgu2aCfwhwYUlhmpl3te4tHuV6QVislh/dJ+uxVf7oID
   IiRsHI+qSVOl7ZNGvhMc/QcAMlc2212uY/E8xT2UpPL9HZQm3ILIFMxAS
   qXMUc5+BrYSr75Xvs3gCTilrhWLGRW39SOmN62B7D+8I/wGPllPkAmxEB
   QYh7XPOeOYypb58t573mpF2LJsOa6ZJErKNlVYCp30wVBiEkr382qNtlp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10737"; a="342517460"
X-IronPort-AV: E=Sophos;i="6.00,233,1681196400"; 
   d="scan'208";a="342517460"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2023 22:11:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10737"; a="704984599"
X-IronPort-AV: E=Sophos;i="6.00,233,1681196400"; 
   d="scan'208";a="704984599"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 10 Jun 2023 22:11:43 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 10 Jun 2023 22:11:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 10 Jun 2023 22:11:42 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 10 Jun 2023 22:11:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFs3z5P0mEeBKQQ/bIEVwy4cPue9XdC6qI4ZgVA/KBRfJVL/FV6zrvCxDG964Tzii0/GazhSaEC4KNgb+i+7GrGVH6QjrRF74k1L6GRsGH04CzJbF54Zq+C9nFTEhyNJSQw7+M9KuKHozqXR2YHUBDzI/NK2vBvBjbsdMLHFMx62UE8elQ9PrZvh3Q8RKo8qriJv36xum/qmMkp1h6tolBlRy42cJnuKfoM6EFZkt16dL7mfVqd3EYjQfCHW+v1pY3tT/+lJxbDX2v6IFGMU3l7vE6X+csdv4s0kXisaKa3OdYs/bgVrIpvfcDdKy5IPKiLP9TiaRdoaKQkKqd4cAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brJempsLQGV57LudIa/cJqzctTrzFHbFgoEvVQf+l7s=;
 b=JPhUL8lFVYosKOZXXSfhnr66rFf7/xpenI/d0L/A8yRFAHS8qFTDaPSDgoKDcXoUk6XGwSkJ65drnKyp1HVv+EEECGzhOi1jqfuV/+1sD27ax6q9BHwqdYh4DrNhFeXXTkdDMkoMjQLDNlGXOZ9XY3BcNnQbNDn0Vxf2rtebaGIk3sVc341MM/DlprQ4+lBGvfzdNP1yjsDP6MuNjrtzsqPL7WtWvS8gqJPRB73MJJfHrXcv1m8A+oUvpknfQE8YQgap1OAMsTuttSJgKJEPA74qu1gL/eLwRFo02KVjpu2XPRAY15/NGNg7nKCPMrQUhRi9Co8QBmO9VNUlerDbdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by MN0PR11MB6057.namprd11.prod.outlook.com (2603:10b6:208:375::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Sun, 11 Jun
 2023 05:11:40 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4%6]) with mapi id 15.20.6477.028; Sun, 11 Jun 2023
 05:11:40 +0000
Message-ID: <17b1328d-f94f-b0ad-d1be-3a3cb78e7e64@intel.com>
Date: Sat, 10 Jun 2023 22:11:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] amd-xgbe: extend 10Mbps support to MAC version 21H
Content-Language: en-US
To: Raju Rangoju <Raju.Rangoju@amd.com>, <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <Thomas.Lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>
References: <20230611025637.1211722-1-Raju.Rangoju@amd.com>
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230611025637.1211722-1-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0027.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::40) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|MN0PR11MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: a8386008-bd41-4f12-0616-08db6a3a56da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MX0RVLyoPM0+d8aOO+wSf/javSlVQtdcTyxuThqZbGUiNWPH5fhBOe/lH3pndHJiFdaYVDa9JuDkt4Kz1D3IfwwRXZ4sEM0X32X3K7m2Y3t+MY9LnnAcCRMvJ+bcaqbPXVZ+kZMhal+LLrtwpXRHLuzeHrBnfzK12ZslTyVy0bzvFg02N/lTLPBf+90gPF2oe5NP/MzswOEqv/Out5/nXlcTsRZMu50ApwesGN/Bej7h9fM67498B9r8eWCVQDrX+9AurUWivardsz3ejxAEVcUWXEHbQJiW6ZA9zTG5Hfc0FN5T9zOff9pgyuDMQDwFILdO6zegTvWMsAfkMDBXHtxvLsHTmAbFD8n8ILBHp7w7bNI8Fm2s4tgu7sIlP/WOlBmS3XexqptMbGbLUA+MNTD7ZvrHa5GxDom5dNNDIBEUlJGC6Ela7sYPd7IOK037teX/xLhmw2JNzrELWMYf8cPrsdyVBnF36nS2TuG9IhdilRR60JCY5EvrV0+1ZsIG/j3JCMomF0pzTKE2kIR/QspAr7q9WT3zsf3JWnuIzpXrNL+FJAeo/3az2gF9K8TGJ4ehp4KOll6Y31TP+JHIc0s1gELdSA4n3s97s1lcZ1ADRB25h7kCeUZS8Np6PnxDTdKCfN4VhZ9CXlvRz53pEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(2616005)(6506007)(26005)(6512007)(41300700001)(53546011)(38100700002)(31686004)(6486002)(186003)(478600001)(66556008)(66946007)(82960400001)(66476007)(316002)(4326008)(8936002)(5660300002)(4744005)(2906002)(86362001)(31696002)(36756003)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlR0ekU4NzQwd1NhTm9HdTY0a3ZHeVVzaDNqSFJnd1NWUFpadGFHY2g5L1ht?=
 =?utf-8?B?OFNKc3BKM204R2ZUS29BNWNYUzZ0Ni9NYjY4OUk4Yk5ieS81QTlxNVNnWTVI?=
 =?utf-8?B?ektXMFlCc2FYQ05DV2JZeGdPdllueEJPdWRMSVcwV2Z3SkdCVmgxb1BXYjhM?=
 =?utf-8?B?eDdHT1lITmw0YzNyejZYaHNQbmtvVWZNYm9IMERyYU8raUIvdHBiNVRDUkJy?=
 =?utf-8?B?RjluN2JoK3NNZ1JHQjcxNktvcGNDa0VUOE1rSng2bFRJZENvRmJTM3pEVHFC?=
 =?utf-8?B?eUY0bVlMNWliZ2pDd3lPOHZuaThjYXdGa0xFRnRsazJsUXpKR01US2pFTGtw?=
 =?utf-8?B?dTB4UUw0TTBOUFJ2UERpMGNNV1dQTFR2c0VBZUlBL21ackx3VnhMMDRXWm5V?=
 =?utf-8?B?KzIzaEhQM2RhOWpjTnBhSS9BTnJVZDJ2VUVtRFBsT09pMXVaWnVONnFseFZw?=
 =?utf-8?B?VmNIVDBzM3hsY2Z0TFlMZklhY3k4VG5tajRmaWVGaGVDbS9mNnJrTjJJVXpy?=
 =?utf-8?B?aEwwMFNwTVNYRVVoS0N6blgraDhWNHpORk1JNnlZNHVpMVl2SUg5VTlvMlJI?=
 =?utf-8?B?RDRoTEFXa3VJa1FlMHBjMy9YclM1bkcrRUlFa1dyTkUvbHpvZUI2WFhMY3pj?=
 =?utf-8?B?R2lJWUxKV3M2SEYzRDZ2anJjWnBGQVJ0amhIVGxBTFhwQ3E4YVp5YVUvekhL?=
 =?utf-8?B?dGRrWFpxdXdxSWhPUG9YcXhvMVdpUTJqR0tWL2tncXZ4K2VEckZKb2R5R2ls?=
 =?utf-8?B?dGR5aTc2VmRkNldkYlErNVlSTjduc1VCKzdnREZVWThNZTBhL1RXS3piRXBs?=
 =?utf-8?B?OXBvUGt1NUJoVU5OUHlOdkNOb2xxNzBkMVlkek1uREVxTTErZ0ZwM0M2Qkdp?=
 =?utf-8?B?Q09HNFJOZ3JuOVV1Y2JxMXUyK1NveGxRTlhrZzRpQ0M5bW9WaXVYZCsyb0Vs?=
 =?utf-8?B?Uy9CRUNMTEdZUVQvTXhIWWZCNDhZaytTNWp0VGN0V0FBNXJRMGxhQlJNcHFl?=
 =?utf-8?B?bmlIcUlLUnlVZG9mWG9HYXdYSWJaL1Qrcms0UzRMdzJDVlVWU1paOWJpQVZU?=
 =?utf-8?B?ajlPNzNZd2RQUkVnaG1mMXZZWEQwdjJ1cVBXS2VDUEFUSDdLU1czMVhwVllU?=
 =?utf-8?B?UDkwOWdhN1NmR0d0aVZxOFVjVHc0VGNBVnp6L3hJSkdkNS9aaWpUZ0xoVDJY?=
 =?utf-8?B?L0JlRHg3OHNtdzBOVkpsUDhlUjZlUVEvOHkzNHNrN2g1SGVWV0ZaMTJyOTk0?=
 =?utf-8?B?UkgxTXlGMUZYeTRVaHdIRmtNdXZFamkzNDd2RGRKQjdVTjVUQ2F2cTc4Si83?=
 =?utf-8?B?S0pXL0hXVW41VmFWVWRDWE9ybkFPNkxpK083S1UwM1cxUklEcUl1TmhrdEN3?=
 =?utf-8?B?aHFMeC9Mb3kvQ0g5dlJRMUp3cVZDRk12ZCtkL1p5ZDFHbTNKUjRrTjZBTm9N?=
 =?utf-8?B?N3ZDbzJvV3RoSVdCMUsrZW8zaFFZTEE4TW5YeUtUNDRMM2pPeXNyUWw1aHFs?=
 =?utf-8?B?YzZNMEh2djlTVkJhSWFZSitRS3JDblpnZkRQb2pYTkJIQ1NZNGVITVprMVVJ?=
 =?utf-8?B?eDBiU0JYaUExQS9nclhiSi9JODFDdldLREFzem9xSTIxbGVTK3NNMzdDYmFw?=
 =?utf-8?B?MytOYkFSb2RRV2M0YU95UzhDM2ZZL1JIRjFvOHlpclNLT2xOSkdRcnBEYS8z?=
 =?utf-8?B?QW5NRjgxbVBvUmNIdmdZWFUzVERodk8xb25CRSt3L0xRR3J1VGV0RHhWeVcv?=
 =?utf-8?B?blJzYlVTZVk0Qnh5U0JEN0JSckQzN01Ha0tTMVdWMEc5UUxRemFBZWVqVFdt?=
 =?utf-8?B?VWdhcmVoZDRUUEEzQnJtNi9wT2thSkdGWG1HS1Q3cDdpeGhMUkM0Y1JWVjFx?=
 =?utf-8?B?ajFTcU9MUSs0a3dsbFdzK1d2N1RkZHo0MXc4ZnBuSkRENFVuaGdiV2hMaUV0?=
 =?utf-8?B?NzJKM3U5cmQzS1RWL0NnRjJYUEVBeWp0b3VhQmh2ZE5najVEei9vTUhyZVA4?=
 =?utf-8?B?UXlHTXBsRUxzVkRCTDRYM0Ewem5aWjdEbThyMDFRR1NQbWw4ZlhuWVBRSEVa?=
 =?utf-8?B?SjJmdUNQcUlJZHVpeUpoQjRYanphUmxrOFJpVkFsTThBSjAvQzRpdE9sUW5R?=
 =?utf-8?B?RGZIRUJFVmlUN2VPb2c0d25yd2hmTm0rM3dxMC9CYlFIREdqYWwwelFoVG5r?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8386008-bd41-4f12-0616-08db6a3a56da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 05:11:40.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMefSG/RZcIGvU5buKyEpZP5FsmUIUXKnIKdbiCUtuDhctmAfw0eHwbS/clsp321zbF+FE7KHO/KnfxpkzkED8+xZktKyUBu5nITVdC1pZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6057
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/10/2023 7:56 PM, Raju Rangoju wrote:
> MAC version 21H supports the 10Mbps speed. So, extend support to
> platforms that support it.
> 
> Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

