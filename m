Return-Path: <netdev+bounces-11620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FF3733B39
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC4CB1C20AB4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004F06AAB;
	Fri, 16 Jun 2023 20:56:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68B36AA5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:56:25 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3FB35B0
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686948984; x=1718484984;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EyjdpffhtCHwGXuDlxliHwe5XoZwPJC3gPCbx+ve6DI=;
  b=HXMHCnu4CRwiV7jljqNltpFev+4RaEoiaoa2ZxnojyrGSY/yDSlncMgk
   oJcFJJJyon/ZxGiXLvpuVhVPyN8Cm5nU609jg6/XRTzzSWQbkEPuznIaH
   9CAa4iOG7kxQogHDJwyUrt3vOttDqDYBGwXYattaRUqI2NekN+LXU3gVO
   EsaVn/T++u5nKnk/PhPNSdlQXQSSKemsO0KXXjSap96uRF94Od3e1br2r
   2vG0Jzx63Tq/LI6fXeF5JqUJboVyubrDBM3Xf1KecauesehQDwMw7lPh0
   ZdMNkQJKIv3ZxXFQe3QoA/4CDP6kSDWo6HmWmngQzmnlND7xr9Pf3xPxI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="344049665"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="344049665"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 13:56:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="802967827"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="802967827"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2023 13:56:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 13:56:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 13:56:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 13:56:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 13:56:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzxFooEMulIH7xGRQVF1/r7EgJ7pgTSDltCjBZAI6O5TikvUo3EBmQ+IdK3SWvTym0qGRMrx84PX5fa3dfH8I3aFgJ/c1Bd89SBfUF5a3Z4jRIwM6LcSFAdBE9VeDiSHrOfLqdEjw+GyUjDTYuH62c8b3LgbkqvPwUW2ktB1LB+ESu2VTaAVN1lSKovr/MOklKYWb02wIEulUnV9P7MtfHgbtL64qLfwfcPBhH7Zutplgo971xcUrWdobR+hEBPo0ixaqysbhFpze97BP1yQ9B8J0NDkjg2NB8E6HScQ6i8xQ3j300Me9ent/NPsZegvLjFr2GBA0Onh/8FgH/cIJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gj4mAT5p1DjCeq7YEsgGI81c/LM0vpGa923qrdQj0s=;
 b=CSTkyBSL2v39TVnciFN79t8Y3QYaPj4J0KIJSw6R6OX04HU3inRVSbZwPD060/xwYRLDPsnMdPUT1CUMwfs61kQ2L/DwKLsmQ+mTdB74x7WMLRKXRAwx2copyN1pXzJV4pZQeryg2/zXhu734gEIFYVRtgfEozRF8tz40hvt/YhUSs87aRgJI7T/8D/6hMDjOKvltWvN+GBJjhZZ8iGVoN3mflxTNxoAxYwzQ5B+J2rALmo2rROgiFF1n6blqxrNCVnPSe3MTjCfNyQUdGTg/agpwiBqFtYO0yQsM83KmmrKVKjEo2l3x2F2C6Xv5FuoPt65n6VzNA5FsQMP2+DviQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM4PR11MB5550.namprd11.prod.outlook.com (2603:10b6:5:38b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 20:56:18 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 20:56:18 +0000
Message-ID: <d34b0e13-1365-07db-d6bb-694625c8f82c@intel.com>
Date: Fri, 16 Jun 2023 13:56:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH iwl-next v5 06/10] ice: Flesh out
 implementation of support for SRIOV on bonded interface
Content-Language: en-US
To: Dave Ertman <david.m.ertman@intel.com>, <intel-wired-lan@lists.osuosl.org>
CC: <netdev@vger.kernel.org>, <bcreeley@amd.com>,
	<daniel.machon@microchip.com>, <simon.horman@corigine.com>
References: <20230615162932.762756-1-david.m.ertman@intel.com>
 <20230615162932.762756-7-david.m.ertman@intel.com>
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230615162932.762756-7-david.m.ertman@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0180.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::35) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DM4PR11MB5550:EE_
X-MS-Office365-Filtering-Correlation-Id: 6870e955-0199-4091-6cbe-08db6eac21ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 34HLc4mu/8GzjcTf/zoumXhFvGsII4uaaAq02vGdp4G47EypcTuEUIWYuEHjQgN9RAPFpVnxR8P5/W9zaTgtLb5hDXIk7cO0WFEV70dGTLPY/53f3lmYc5fkqwkBUcZzwWGcaywAdLDmyYPEsBaN1+gz95FT4MPfELvuqFs9igK77gr9Zh0wheX3+5+cHLKHGIQ4V+Y8CH84SnCYmBp0z7GqKH4iO651pB6s9XdyPARkGpjpQe9svl3uAZ1nFtBTDyw/mbfVrpH2nYzkRwLuzEo09uj2u4+RoJ0BgU1frE/AUVDJz6Y31DTnPUNhi7OTM1ZcEIZuCOnHDXnR0MsMww40Xkd4sAr9M6dyqcDos0duE9tvKwY7jltpmYvBtXIF3a1dmZ+3FCDjTYXViLt9axYDbtaUWVKkWWKL40OsYHZxOJX9mmhgw5DFEZ+h5S4Muhc6DMUQjTilv0cDJyg4B5NZAu5aRcP6QvPa/Xunac2/en+QmcMgblNOibbliTWW3lKmbnMzQLZAQ2Avg2EH4ecHD4tNRvFpxN4X/BQ9SBisXYL17YRnNg6Ep0dPIehC0nB73j1HKNbHIEvKh5Cid10qJOdlCpSPHV/gU7inHyEOkkTHL0CZVaIGtTzBVxHxRPbt1ffPvH+chi2uvA2u+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199021)(31686004)(31696002)(41300700001)(8676002)(86362001)(66946007)(66476007)(66556008)(6666004)(8936002)(6486002)(316002)(4326008)(36756003)(478600001)(6512007)(5660300002)(26005)(83380400001)(6506007)(2906002)(53546011)(186003)(82960400001)(38100700002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWU0a1BmK1lzQTlVS1JxQUVjSXFxM3U2YksxZHF0L09hQ0YzMXpwbXVtRHRj?=
 =?utf-8?B?cHV1SUJoaTRVekFiSU5aYWNUMXpHOWErb1ZhcG1rZW5YSVpXNUdTN1lMTEVo?=
 =?utf-8?B?RDRtNEJQaThDR053ZUtnOXd4eDlWenM1VkZtNXNmbXVVTjRDTTRCN0pEeThr?=
 =?utf-8?B?K05EcDNYRXQrYlJVTnhSdUhzd0x0WGloZHc1N1B0eVRRamlhcmVWV3g1cEY4?=
 =?utf-8?B?bkJkQjVSbS9DNmZhQ1BFVURlM2FMYkZUOG1YT1pZMVNySDVMMVlsU3N0YktC?=
 =?utf-8?B?UmFTK2NCekhvdDVXQkZSQWF2NDFLYjNtR0ZHRm0xc3JLV0ZOSnNNcUM0VVIx?=
 =?utf-8?B?cDROMDJjU0oreCt6OHhZNTlLVmd0WFNtRW1DMFk1QmVYY1pyMmRwL1VaVXor?=
 =?utf-8?B?V2FFbjZVMFdZdTRqWkY4a2V5akZPUkRoQ0RRMXJtcmIyaVZWd3J5U0Y3Y0VJ?=
 =?utf-8?B?ZXhNODJ1R2FvMTFzUlFXWjhIdkRvMVM5MnM2ZzByR1p5b25pVGlBZmRCM0Yv?=
 =?utf-8?B?SjZncGpwaU0rLy9xKzl1aG9Nc1NDRXd1bC9kL3MrOWVNbSttdUU4YUYzY0Fl?=
 =?utf-8?B?eFUzeVY1ajl2by9aMy93MVFSeGkwMlN5b1QybGRDTkdrZjlWblFYVENCaE0r?=
 =?utf-8?B?WFZDVW1MUGF4S0lZUW9McmVEUldsKzl5cTNFUFl6MG5TMjJEK0NPeVRhVC9U?=
 =?utf-8?B?WU5ndHRXRldxV1pxbVZTdjhNZUlXNjVZc2tKTUdUYm9ueWRGQ0V5a2NFQXdJ?=
 =?utf-8?B?WVJkOTlWSFhEb1cxczdCNkxVRHpoVlZlUEx4SCtPcGxtS29Ydkc3UjRCK3l0?=
 =?utf-8?B?dWdFclgvdVBwZ3k1OE9JN3Rmei9XS01vbUNZT3ltazBBYlp0UnVRVTJIWlN4?=
 =?utf-8?B?MlV6UzlwZiszSVc5Mm95UlB6ZXJFK2hsNFg1N3o0clpTemJHcU94Yjh2cHc1?=
 =?utf-8?B?Um90cVl3R09FS200YzBTcWViaHhSOGFXU2RtY2ErL2ZJNFhNbDNyQk9EdWtY?=
 =?utf-8?B?WEkzNEs1d2NCby9nZThxT21ldE1RTzBIaVM4S1NEOVFyTFdPeFpobjNibWZM?=
 =?utf-8?B?amY0eHhoM0pZMy9RZmY3UXFLT0JNNjd3ekFhUU5yQ1lWWmVKYnRrNFIwNWJO?=
 =?utf-8?B?K2tDRDMvTFo5RDZRZnNyR3NRRGd5aTdrRjM5eVVqd1ZrcjBuM1NrT3Faa1hE?=
 =?utf-8?B?TWpmTlVzdzZxQmgzeGhsV1BXSGdZbDhSWW9mYTRUZmFmQzRZakdEZEo1RllO?=
 =?utf-8?B?cHMzS0FqSmdOTEVnbHpYNUlBd056Qmd5ME5YK2VSL0x1MEkxY3VoSHJvOTk1?=
 =?utf-8?B?L1Q3cUFMaG5RZm5vSmV4Z3YwcWEwT2pYTmIvNERJT29XZHUvWFpRWFo1eUIy?=
 =?utf-8?B?MnE3WnZMaVRXOXRRaVN4Z3VyK3htc3RXR2Z3R2lYN0lOMDdLYzNDZFJKRTdR?=
 =?utf-8?B?TUhtWmJoSFYwdjRWb2prREhBWWtVcG5nWUl2WmM0dno1ZXRKZEVmMVBMamc2?=
 =?utf-8?B?aFlubUpXNUQwVHptWEZNcS9JbEdTUFo5QmtaWWFnMW9aTFd1T1ovZmR5REV1?=
 =?utf-8?B?NnpyemFXTENlcThJNEVIM1Uxa0lCMDI5ZWNiOHNGRlNKZldudk5QV2JwM1ZL?=
 =?utf-8?B?NUE1RDdadFNRbVhkUFZJcm51OWRjSVJLM01SS01rNkFOVnpLcVJaMzFRMU9S?=
 =?utf-8?B?bUl6ZGtSSHNzdkFvNXVXTHVYYnRxZytOQ1lYVGhYSmtPV25IVWJEa0Z4ZWIr?=
 =?utf-8?B?TmVFSHdRS3UwdXJUTHRwaEo1ZGdMRWdSYmxZNmlSM01tYlB6OFNBK3N5OVM3?=
 =?utf-8?B?c1hzR29ESkRwRHBWSzJoNUpPRlFGejdJRDJ2S1BzQXpycjEzdURNMFBka2di?=
 =?utf-8?B?WVFWUlArczIxZGdYaTh2bVptVjhhTE1ENUFFUmNTYU1Jc3ViOXJJc3NhZ0Zr?=
 =?utf-8?B?K1VQRVNjeDliVHo0bGdlSWRmSFpTV2RtcEJQNjRSTWlqaTQ5akxSdmtQbWhB?=
 =?utf-8?B?aGNYUU83Y0oxOStVTEZtSE16MythaWp0WHVPS1hsSEpDU2pvWVc4Z2FqdmV5?=
 =?utf-8?B?UnB4TURhMERhRlE5TTlKeHlNR2h5UHFoWWJRVFF0T1JnNHJKWk1PZXZUSXdB?=
 =?utf-8?B?UVZBcFpTMzJKaGl4WG82L2hTazkvS1pCbTNuT2pCcUpITm9VaEladUx2dkxq?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6870e955-0199-4091-6cbe-08db6eac21ea
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 20:56:18.7803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzlyBWi/o4wmVg7S06NY4ykOq+I0bprRu8Ujs6zegsBtNwKfJvxbzVJgCrkcqUgdiMY/KIK3nYJ7uk1Ax6zyhxmRNhXoKCKzARG70VlWhJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5550
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/15/2023 9:29 AM, Dave Ertman wrote:

...

>   /**
> @@ -622,6 +1324,69 @@ static void ice_lag_monitor_active(struct ice_lag *lag, void *ptr)
>   static bool
>   ice_lag_chk_comp(struct ice_lag *lag, void *ptr)
>   {
> +	struct net_device *event_netdev, *event_upper;
> +	struct netdev_notifier_bonding_info *info;
> +	struct netdev_bonding_info *bonding_info;
> +	struct list_head *tmp;
> +	int count = 0;
> +
> +	if (!lag->primary)
> +		return true;
> +
> +	event_netdev = netdev_notifier_info_to_dev(ptr);
> +	rcu_read_lock();
> +	event_upper = netdev_master_upper_dev_get_rcu(event_netdev);
> +	rcu_read_unlock();
> +	if (event_upper != lag->upper_netdev)
> +		return true;
> +
> +	info = (struct netdev_notifier_bonding_info *)ptr;
> +	bonding_info = &info->bonding_info;
> +	lag->bond_mode = bonding_info->master.bond_mode;
> +	if (lag->bond_mode != BOND_MODE_ACTIVEBACKUP) {
> +		netdev_info(lag->netdev, "Bond Mode not ACTIVE-BACKUP\n");
> +		return false;
> +	}
> +
> +	list_for_each(tmp, lag->netdev_head) {
> +		struct ice_dcbx_cfg *dcb_cfg, *peer_dcb_cfg;
> +		struct ice_lag_netdev_list *entry;
> +		struct ice_netdev_priv *peer_np;
> +		struct net_device *peer_netdev;
> +		struct ice_vsi *vsi, *peer_vsi;
> +
> +		entry = list_entry(tmp, struct ice_lag_netdev_list, node);
> +		peer_netdev = entry->netdev;
> +		if (!netif_is_ice(peer_netdev)) {
> +			netdev_info(lag->netdev, "Found non-ice netdev in LAG\n");
> +			return false;
> +		}
> +
> +		count++;
> +		if (count > 2) {
> +			netdev_info(lag->netdev, "Found more than two netdevs in LAG\n");
> +			return false;
> +		}
> +
> +		peer_np = netdev_priv(peer_netdev);
> +		vsi = ice_get_main_vsi(lag->pf);
> +		peer_vsi = peer_np->vsi;
> +		if (lag->pf->pdev->bus != peer_vsi->back->pdev->bus ||
> +		    lag->pf->pdev->slot != peer_vsi->back->pdev->slot) {
> +			netdev_info(lag->netdev, "Found netdev on different device in LAG\n");
> +			return false;
> +		}
> +
> +		dcb_cfg = &vsi->port_info->qos_cfg.local_dcbx_cfg;
> +		peer_dcb_cfg = &peer_vsi->port_info->qos_cfg.local_dcbx_cfg;
> +		if (memcmp(dcb_cfg, peer_dcb_cfg,
> +			   sizeof(struct ice_dcbx_cfg))) {
> +			netdev_info(lag->netdev, "Found netdev with different DCB config in LAG\n");
> +			return false;
> +		}
> +
> +	}

As you have to respin anyways...

CHECK: Blank lines aren't necessary before a close brace '}'
#893: FILE: drivers/net/ethernet/intel/ice/ice_lag.c:1388:
+
+       }


