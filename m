Return-Path: <netdev+bounces-8546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3DA724818
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1A24280ABD
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C894030B6B;
	Tue,  6 Jun 2023 15:44:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B6937B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:44:50 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F9A93
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686066289; x=1717602289;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DzOHD65ZAcraFtHO9MRnE/pxrD4cSSHcirhTC647VIo=;
  b=f1eFiyVKtBiKb45RDO3WU4KLmZ4D+nxvY4PnPVIaWuSUOyDiyJ10AoxV
   8UyGGhJ6LEQvIW38o2S/TdF3hyEEMf1QqoVYqVcQg+JzjuiTJTecvehIC
   +EQYL31AteM7OMMuIVlbHMfzknGD8+SMQCHqQVHiSU52180Nk3BhtA5+B
   aZXl+6NPizF3ukDiYPwZKkBSBFcKPZ4Iev1jIEp5MS5TFKxs//43qgiN3
   MWUzo4nqJUUFa2gJA9elTNzLnUvbrwzq/oXHFMJSISCQHAOhx3G778AQk
   ShVuuoSZ3OlemOTXD7iwyIL4RgnKhYS4CIrndEt9q85YvVVLvdzxx/673
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="420259633"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="420259633"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 08:44:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="955817411"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="955817411"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 06 Jun 2023 08:44:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 08:44:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 08:44:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 08:44:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 08:44:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqJxaF4d93NwkemldXsVeJpbTLi2m3CjoQ+gkqxvdNXb6ZgOUbrBSWXDjDB9DhqTyVX18LoKzz2smJudT4uNqZ1fHRpKV6Nn1JvRKraOTGXBVZKwnpB2Q0mGwSDO6Em1+aXINh1JYF5PQRHbMpxXwYgzdI7RU1wurK7OYYarQmCzbh/a5ysUipyUR4RRbxh7QmKvbZjMyE/G85XmEDUMfkUEIcCkqQ0v1nyw0WekRrIEMane1J/RHLorzJxtqjCMrfFvlIAtp+EVTsamdDhLLy/cxoSxMigiIkDANQFe5gaORcpSV2Qmgzblgx8a+uu3WzX5uKReeqEv3xdqFyq7og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7qZTPHQzfPdx8UitcGQ+tTFSLBlNTvjc2gsshEfcek=;
 b=dhYadFGQzdOmWy7M7ljrZ3O7xCLNbecMgIFVBRnXbcwkUx0j1+h+cKbivnanYqs7POdpMd5HdcFrM/2j0C6gRvH/uHRaZo4chU1GlQNauiYLUtYpDmHqUlj4VJc2kGxO2g67UW22m+xz67u22W9aQs3r0QZQC9jzALc+gAg4c/pbgj4bISg5NxsVKYL8PjvcpTK9od2DAEfR0QwdJZ61eQPIz2lp//iKumU/Lv6mBQz3TS3A/VSwcBIzmzDzSAv44JXXnSGXeWdlFZoh6x5TbASI5/yRj/oRl+eimFMCPrPkgJ8A041sGqDKrwbiIef23v/q3A5oypVM7ElMQXkVPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB5803.namprd11.prod.outlook.com (2603:10b6:806:23e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 15:44:44 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 15:44:43 +0000
Message-ID: <1e11a484-af99-4595-dc1f-80beb23aae9f@intel.com>
Date: Tue, 6 Jun 2023 17:42:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH iwl-next] ice: clean up __ice_aq_get_set_rss_lut()
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>, Przemek Kitszel
	<przemyslaw.kitszel@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>, "Sudheer
 Mogilappagari" <sudheer.mogilappagari@intel.com>, <netdev@vger.kernel.org>
References: <20230606111149.33890-1-przemyslaw.kitszel@intel.com>
 <ZH9S6wPIg9os8HYa@corigine.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZH9S6wPIg9os8HYa@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB5803:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b45e4b-c864-4192-de56-08db66a4f27d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DCi5zOby+6T/cpSZcFiAA/tWqI+YwT6z+AN4S9pQf+1G+7/1VeqDl6bHHVQ6pYMJ7dU/94uD5bzX3lActUDYLXB2roOM5FGrytYV6VrtGLk2k0bK3hp4U6UDNEmosPo1vyzDcDWR5KWBtcHGuIpf0bLEFkMQdjnMdV7mxPsdho8Ld59jmGExGt8o3i+q942fbDM8B++Put773BN/7eAvFQccF4X6jSkOMCudgskcWIGaSK+w0mrM5wMuBhBdx5DYgdJlPJMOe8oZ+qA1G0Ci4Q/6CvJJBAqqvHg/cY8gL5Ybl8b0k/fm2aYOYtwrSX4eU0iH1+QDFnH4wIxqWMA3mJArfF46yIR/UN058qAZGUB0YHwFNrE5DFs2RENl0EN9noxF46rNERdzE8muylRAH9TYA/gsDtgQ2+8ZW+LuyMk2srbRLWziweMf0qJE8u8MFi5q0XM2T1RfCqnbM4I/nINw4i5r3UqWsHjWTzKM1VT1YJ4Qm4lleigp0SxzXWiZdmwJa7sl4xKn6+6DijhXki+Hc8MzoKuT2tktxcpQawYkbOXbXEG6wrt8G1Yq8B16ElZdyxM4mdhwwb13jFxqgrYMjnkU00zfddmICUfFCVrkx/Cgqm5WVO64kx0D0aZxMe40nkqScH6pT0/rz7aeEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199021)(2906002)(2616005)(36756003)(31696002)(86362001)(82960400001)(38100700002)(6486002)(41300700001)(316002)(6666004)(5660300002)(8676002)(8936002)(110136005)(478600001)(54906003)(66946007)(66556008)(66476007)(4326008)(6636002)(31686004)(6506007)(6512007)(26005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1B1WE9pOEdQb3NXc1FOeDVvMC9ZQXhHb1U5Z3Flbi9scWl4bEcvRno1RGVM?=
 =?utf-8?B?VDJnR01FOENKYVg1bENMQWNHUjRMMXVwYnVUQlNjREJPRTZPeEpaR1dXZGcw?=
 =?utf-8?B?ZkwzYVJKUUVwN0pydy9iMzBpSFIwRjcrVU1udmVOamVTaHlwY1ZnTG5XMDZm?=
 =?utf-8?B?dTZxaVlXVXBJc3FBb1cxTVNMN1RyeFFGYzNhaVhRbnJubTF1eFFjczJFZWlm?=
 =?utf-8?B?Y0JaQmUwM21mdmZaWk1JaXV4OXlwaFp3Z3JPQ090VzIxVmdyNktVYXZQanln?=
 =?utf-8?B?NlRhdU4rUWQxdGF3TDFHemE3UnF2cXNrd3hrWTZvQ254OExlaEFIbWdnZk02?=
 =?utf-8?B?Y2FUeTZLRGhoZTErYUloWjM4ZWsvMWxuU212aVJVN29uWnJYZ09tTlJDMzBF?=
 =?utf-8?B?RHo5N0lGY3NkUkxVL1NyTldXN05IZWR6QUNyZHNNWXllNjM5R0s2K2JNZlJW?=
 =?utf-8?B?V2dlQ2FHblc2VThmUnF6WGQyWFVhdHBIWXRKMWkyRUFDK1hQTmdWMm5WbUEz?=
 =?utf-8?B?bG9WMzZaVENHaFpmUlRLUE9NQXZFU2tzekkzQjFEcUluZ2pra1FqSmhZeDBt?=
 =?utf-8?B?NVh6YXZYVzRQNmhRdGdFekNKczBpOWxZQ25lUnQvU2JtL2dUMTk0RWMvZDdj?=
 =?utf-8?B?UzFHcy85SFhJaVFCT1p6RWx3TzVCSUF6SUR3QXUwbVVVQ2pRZGI2YVdLMVJt?=
 =?utf-8?B?YXJxUTBkeGllaHgyT2hMMEtyTUNRWnM3WWloQld0OGl1OUFkQnN0MXJHa0NZ?=
 =?utf-8?B?V0hidHV0OCtZaHUxWlBBb0tXbVNtMEwyQmdOZnlvVDBZaGxRUGtVNDJNb0JS?=
 =?utf-8?B?R1lzMlBRV0FPcFpJS3NqbDAvQ05vc2dXZEg3Q3dyQUFuTGE0RVFzVURtNERj?=
 =?utf-8?B?TzB5c2JWaXVhRE81OWJWbDlEcnA2RjBaTWlVM0VXRUo2cGxHZkY3SU9zVEhC?=
 =?utf-8?B?NzVBVHE1aEZwNlBtZzl1RTZpL3ZBMC81a1VQbkU3NURLMmZ4UkJDa25Dbkxu?=
 =?utf-8?B?c3hmbXNYcmZab09iY1BXRmRvMmVoMmZzTFZtNHZ3d0NYbFo3R0o3R2VXT2Nj?=
 =?utf-8?B?N2dUWEh2dFFuZlFjK0c0MkhvbW5pQWxWYThSeld5cjVEMDlKMktBNXEvdThN?=
 =?utf-8?B?SCt2VUFrVExpSVplSERFNkwvd1V5OE5kM0YrTEd1VnhUNjY1dGhsL1ZpU21q?=
 =?utf-8?B?VXNJbXkvVjV2b3V0a28yRlVyNU1COFFSSExyL01xTUN2ZDN6V3p1d1hWK2dx?=
 =?utf-8?B?ZjFmcFRnK3ZDVFRCRUFZWjVsVGZ5RkZuL1JwNmhmQVdDek42OTlxQVdIbnpx?=
 =?utf-8?B?UEFWbEtHTXEwejR0YjRUQk5SNmp2ZXZlak4rdWtCbG1UMnpNZnEwa3BCVE1T?=
 =?utf-8?B?RkhkVHdER3FveERvdzhuSFRmR25WYnVRVytPMnRuaFpkeFY0Q2RUQnI4S0Yy?=
 =?utf-8?B?VFZEOTYzanF2Nm9lU1BRYWRyaG5YRmFqS3JDK1Rnb2puSVlGWTl4S3V3RVZ0?=
 =?utf-8?B?V2J6T1R0U3B1MDJOTERnN3dKODR1UmtZQTBlcHM3VE5LNnhFMkMwNFRSaEUv?=
 =?utf-8?B?M2M0Y0tpUnZDckxOWDdMVUdYd0I2cWtnOXpvYlRubk91RnhmNmI3TUxLTjBy?=
 =?utf-8?B?K3RpQWZJT29TREFoQ1hsWEhRVXhXL1NROVd1RkF6SnBOT2VNWnd2MmRNeU5I?=
 =?utf-8?B?WXRwQXN4WU54TkhWU3UyZXl0d05BdEZ3S0NsR3BDSWpia3ZPOG4wVXFaVWFn?=
 =?utf-8?B?dmlnWkZNaU50UmpNWlRGNTFGQWJQNHo0MlJwQ0pJbG9mL2ZKTDRUMkVKd2c2?=
 =?utf-8?B?YkhCdmVuVk5CMmJVajFhY2RrYlNBZkNzYmZOdXNEaDdCeGpvMUtVT3F5amFX?=
 =?utf-8?B?RGlPQjQvaDRYczZlcHRybFpWZjZvMDUwSzZsMmtBQW1KNG5NdUNJUlAvdk1K?=
 =?utf-8?B?aDJzdW43VXQ1RzhQejZOdHAvY3FGVzZrZHlTQThLNDJSdWZURTNtV084ZkRK?=
 =?utf-8?B?SUxKNG42QU9lRk1qZ0lCRnRqbEgyVXZTWWlhNHJ1cDFCNUlPSlB3TThlSmpN?=
 =?utf-8?B?MEpRUkVMRTQvQTllNngySFQyc3dPWGZRQ29aV0QzTno0YzNhei81RjYra1Jv?=
 =?utf-8?B?UnpmZDMzQm1pVGJRZ1dkSERINHBlc2VKbEx3bFRiT1JCU1dwZGxLYjFGdmkx?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b45e4b-c864-4192-de56-08db66a4f27d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:44:43.4919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhHE0aQnGOp3RygWuSRp2b7g36aOnDWwMWwWi0NnOSaMccWnc9BJiTHEv2/ZpuCTZ4iMZeRC27QTQMsOxpOlJu9Pg97mnW1Q33gXzdlN8FE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5803
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Simon Horman <simon.horman@corigine.com>
Date: Tue, 6 Jun 2023 17:38:19 +0200

> On Tue, Jun 06, 2023 at 01:11:49PM +0200, Przemek Kitszel wrote:
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
>> index 6acb40f3c202..af4c8ddcafb0 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_common.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
>> @@ -3869,6 +3869,30 @@ ice_aq_sff_eeprom(struct ice_hw *hw, u16 lport, u8 bus_addr,
>>  	return status;
>>  }
>>  
>> +static enum ice_lut_size ice_lut_type_to_size(enum ice_lut_type type)
>> +{
>> +	switch (type) {
>> +	case ICE_LUT_VSI:
>> +		return ICE_LUT_VSI_SIZE;
>> +	case ICE_LUT_GLOBAL:
>> +		return ICE_LUT_GLOBAL_SIZE;
>> +	case ICE_LUT_PF:
>> +		return ICE_LUT_PF_SIZE;
>> +	}
> 
> Hi Przemek,
> 
> I see where you are going here, but gcc-12 W=1 wants a return here.

So that it can't see that every enumeration entry is handled here? O_o

> 
>> +}
>> +
>> +static enum ice_aqc_lut_flags ice_lut_size_to_flag(enum ice_lut_size size)
>> +{
>> +	switch (size) {
>> +	case ICE_LUT_VSI_SIZE:
>> +		return ICE_AQC_LUT_SIZE_SMALL;
>> +	case ICE_LUT_GLOBAL_SIZE:
>> +		return ICE_AQC_LUT_SIZE_512;
>> +	case ICE_LUT_PF_SIZE:
>> +		return ICE_AQC_LUT_SIZE_2K;
>> +	}
> 
> And here.
> 
>> +}
>> +
>>  /**
>>   * __ice_aq_get_set_rss_lut
>>   * @hw: pointer to the hardware structure
> 

Thanks,
Olek

