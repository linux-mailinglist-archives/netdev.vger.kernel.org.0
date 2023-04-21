Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E436EACC6
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjDUOYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjDUOYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:24:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2704035AE
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682087058; x=1713623058;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kaPYUPLTxobccM4ujXcR4Au+Y2e7x4gxa+7FNIpOvXY=;
  b=QJd7LQBcgTaruNJX67M9lrGBz3stCEwNNZ+g4Bge1BWLzjyr4SKWFTS4
   RphDiYdn7JpvP5s/bnY9PRfOMPWga1So70Y9x3ggoBsAv8Izinm00XlFp
   wC9oV5kvI/XZ5H0v11CbzhpzFcwsVgbIPBRsrU64sfp42Rt2n43GG0fKK
   IwzgKN2n5r7zcT4HEYElEKSO8Mokf55iLC0TGPNrgnrpEvaO780O2DRW8
   GOfTvbDNi6TYSyiVmmjRfGlNvv++LttBaQOSE/6op/VgfzXZ8Q+4wdB4w
   +KjiM0/F7AvxUzu/ZMU4sSFdA/RzIL05sxu8ylOhEDVwwrqykEncfpEBG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="326332736"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326332736"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 07:24:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="694974745"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="694974745"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 21 Apr 2023 07:24:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 07:24:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 07:24:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 07:24:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3ZcqW+ZLBzwf94plz6KLEaWEj1n0XNNlZCFNyejBKriVwxTzSSs69XKvcGXUXm6VwON+RJOk9+ZAb4RlwdmSZPMt4wFQws//oryMri8H95o3a4i6aOP1bWzUAd7m86XSCMHQ6iTwxryt6BEHqq15KMKPChwS8NwxDFAmrIyt/dDa6UZ6nCvmyj2zePKpepe6sm+Gt3GudBZbJrXTop0WnJw7HW9UkPkz05HZBRtDJOPmY+W7tyPnR5xCwh9mEOuZOERSzt2QODJ/QIc2sxxu+gLdYI+2QoKTL9P3udVTojY6S8wJhHH1Cz9A8BS5C/j0IFe5vD43WcNP8QJZfFIXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVGSgPqEGlQOHgAKRzvU6xHDRlhWo52WncNggVfzeto=;
 b=gNeVR+Nv4O5dJfMEftEkdSQHc6lpdqRwu82sfITn08Qc5mmiCMT9/dIHc9u/VRo+5XbPZIbC14hHJwdCdDS5awHPhI/trhrvoHgHqp2YL1J0x2GkLN9U79e3NIxismqQC7Lojg59A0eFUcXGRuqdnXtGgi+u0PU53WqOJ4crW1MaZAMDvzmPV3562wCwa8efPCOI8CxqPhXd8neYwLf7bH19LbmkFX2Gu/Ry+vOx2aAA+faIwK1cA/793iKi0BKy3+kQhvOmVB92ZehobNKz7C7foUGjepRsq9O/G7xX4zv5OygQ5C4yEY6p91472tK1xr/CCH6hQYpctgsf0qsxLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6476.namprd11.prod.outlook.com (2603:10b6:510:1f0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:24:14 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 14:24:14 +0000
Message-ID: <ab08efd8-3123-7560-0ef0-036dc156db9f@intel.com>
Date:   Fri, 21 Apr 2023 16:22:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in
 switchdev
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <david.m.ertman@intel.com>,
        <michal.swiatkowski@linux.intel.com>,
        <marcin.szycik@linux.intel.com>, <pawel.chmielewski@intel.com>,
        <sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-7-wojciech.drewek@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230417093412.12161-7-wojciech.drewek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: bce7f7ec-2d8f-4099-9152-08db42741478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqcbWG6nR2HNCy9zjrEcxnqblhxT34JqWDgXqZ7X3J8I9aOJ7Q3ZkQ28YR2bdn8OTD1FCIVDqKxImhr9ql4i9hwOfXXn/Du89sGyBA3FdlplaEdp109OH/abGV/1nCClQHJWMvSQonb7Qydu9aB6SjxD5/91MehRfmJLN6vBNB+eYkuIi4uCIggh2pKT6DqwlW7kzBTFp5M13l5FzisWfEA7g8or/yn/2+XleVTKyl91SBhU3MeEQcsFVri8UfEO0nIDN6mZUtwm1eD/Ar+Dqu36xj0uJ+sd/92LfipguYDsoYK3H/tjXkZRjaFeCVOokpYOe/7O3GDVVmmpYBhd1x/sSG1zyb9696pX2u58vC5wF1rMmA4XdRx5FopZbDn27d/MAw8GfYtevJ6ZyRXeAuoIflW0a4UQFd+grY5dpFPzDwIJmOjC+DJRX4B1VA4meNS6o+u/oafmpaKdDUAniRMlng1ml6ehv+dlJp2ksIwIoWeryl6HaQX88fmBE21VhDPVgJoDRQjdrlx44T/eksWwg1uEsv6HUywnyINQKLWWmIaVzEDT9Q+lpQnwG18aW8yGSzs7nqlxVEetsfVCiZPe+y9W1xakilKq7n+T5qS6Q/YtdE5IV5ln9nsB/bU/w5AsATiCQIGXgUtgjv4g0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199021)(8676002)(8936002)(38100700002)(6862004)(4326008)(66556008)(66946007)(66476007)(41300700001)(82960400001)(316002)(6636002)(2906002)(5660300002)(186003)(86362001)(6506007)(26005)(6512007)(36756003)(83380400001)(31686004)(2616005)(37006003)(31696002)(6666004)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFp4dTk2Y09lTVd4b093TUVrU0VCYld6K3B4MWJreW9IaEhQMXdZWnZOVkxJ?=
 =?utf-8?B?SHRkT0J2cWxFZDB2OHR6eVFQNXFYQ2s4MDI4c2J3OHJXN3AvcGJLbHY5aExt?=
 =?utf-8?B?TUZCUUYrS2thUzd0L0RBanFBd2toQU1zV1FIVHdCSWVkeTJvUVJ5NVVoblFT?=
 =?utf-8?B?bzJnK3ErSEtZakFlNmd3Qk1KaWk0VDkwVzJOanMxayt2b1FFNExOU0hmTUth?=
 =?utf-8?B?UVd0MzN2S3ZmQjZQeklRRWF1cG1TUDZERDBHazJXNGdZSnNRVFVpVGFadkdG?=
 =?utf-8?B?V2lIUUsvZmpTRUdkOG5GeEw0UzNWL3N1ZXIvZzIxcHZOREtTMENzNTMrZVg3?=
 =?utf-8?B?bklUMUN5SS85RXhueTNZZGhWWWdiOEVXWGlhV2xtR3FyZmtpYXd0NmQ2aisv?=
 =?utf-8?B?RnBhbWg0NFRuRTVBRWx3OGVJOFlucURTZEQ5N21GV2NyVmRTK3N6dGU1MEQx?=
 =?utf-8?B?TDNicFlmVndweWxhR1dWMFhtbWhSN043WjlQRjlqT3l5RlloZW01VVIxZFpZ?=
 =?utf-8?B?YSs4N1NaczFkNy9Oak8vMjdlUFdPODdBa0tnbjkwcTVDL1BoN1gyNVhaMTll?=
 =?utf-8?B?SXZnN2szTG50SHhxaGFKWVNHOEpEWWdTVWg4bHZndFMxbkVvOFhtWStHS1Ro?=
 =?utf-8?B?VGdVaVR2UlRvS3NtSW1qUk5WUW80cG9zVnZ6QVIzSE1mbm14dStEVi9JS0lh?=
 =?utf-8?B?d204Y2x2UzhBeG5hVXhPYlZkQUR3VHVSbEh4NnpNQS9PeXFJN21malBDakRG?=
 =?utf-8?B?bzlkR3dDQkdGT3hwcDZRY1Y5bzhLZG5QVys0a0ROeHFyckRFcmJrSUVwelRr?=
 =?utf-8?B?R29ZdTBPekRncHl0TDByMlNlUVN0cE1mK3M2ZjNlYWZ6UThkRlBmaG92dkQ1?=
 =?utf-8?B?Mzgwa1F1MjZNcmtqTlF4OWJXRUQ2a0lFdkRGMitlelRyZjlaZCtoRjdncDF0?=
 =?utf-8?B?dDdNV0NLNWxLT01Cc0QxTlBhUW02VDVmeENaSmE0MkhYRmdGRmd3VkxCNDlk?=
 =?utf-8?B?Z0VJYXphZWxSeEZ1MzZHMWpGYmhGL1g3T2tLN2JYU1FSSzdnamZDaUV3TkZS?=
 =?utf-8?B?N0pPaHJXekJ0VTlMVCtjRm84SHhqZFYwVHVRTHdHT2JBbUh0OTVNNk5xYmtn?=
 =?utf-8?B?aFc3cGhHUEI5eDRIZmg1cytTM3dvUDEvbmc2M0duOUVJTmtGK2RzUS9yTDQz?=
 =?utf-8?B?WGJkTGloc01KQ3ExQTEzUGxET1pFWVBFTDI0YlU4RFdTTmJ5WXhXNnFzKzgx?=
 =?utf-8?B?c3Y3MUp0ZUVUdis2S3cyVWR6S0ZFbUE1c2hjYWYxYXBKZ1VHQWN6U2VYL3Ez?=
 =?utf-8?B?QSticElJamxEcDRZSnpRUGJhamIyMWhDRlZRKzd4djUvM2JsNlRiN284RXNC?=
 =?utf-8?B?aHA2aGUzYnpnaW9KQ0N0cEZ1NHBZOWIxWGl6VXRJdEQxckphQlh5N3E1UGlH?=
 =?utf-8?B?K1dKdU9EVmN6b1JDUmtTWHVWeHJ0QTZFcU5kSVJFMHYzd2Mrcnl3NjlmckRl?=
 =?utf-8?B?MEpLckZaRTVvUkxWdjNqVWVHNEFtOHBIOTJSOSsxVHFSR3h2OHdNZTR6Uis1?=
 =?utf-8?B?VEZPUkJHRGRITmZwMTRTQzZ3cEhkcFI2MWNXRE5Uc3FOS000dFBsbGZqZWZW?=
 =?utf-8?B?UzZPRXB4MmgxYTduSEVqVFkwT1JkenFBV0haeDhNNXBkSFNTa3VTU2RKUmtr?=
 =?utf-8?B?ZHpHdTQ1MlRSWXU1SlNlbjAyTWV4VGg2WUxvOWZmVjh5TkZHay9OcjdTYmd6?=
 =?utf-8?B?cUk0V0RxbmtQakV4d29SZXRUK2lDNnlySzlpbktMYU13OWd1MDBNR1NESW9P?=
 =?utf-8?B?Z01HcGRjdXlSZ294a0NscHJpeUhPRUdReVVKcUVJOENFbjhSSDVvSjRkUDNm?=
 =?utf-8?B?N2Q3THFOaGlNcHNGQ0FOQVZKNjRtWExENjkvVXBaUjZJSys5b3BFbUR6TFV5?=
 =?utf-8?B?YlpNYzFmeEttYjVMRUhFMHBYTFA5UGcrbFZBZXRuVVpuTlBnNis5SUIrN3A3?=
 =?utf-8?B?WEJ0aUtLNTdKU2JCODZPWEZvR3BQS0JzMEJrK3YzRHNlaUtEQUpybEFlU1B5?=
 =?utf-8?B?SkhOWCt5Y3dwbXNUWlowbVhCSExmUDVrQnAxK2Y1Lzl2TjR4dzk3UXp6RUpQ?=
 =?utf-8?B?TXZ3SnJUWFN3MVVCaUs0bmk2WXVEb2IwKzROWG9qZzZLRzVsK040Y3NUNjlI?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bce7f7ec-2d8f-4099-9152-08db42741478
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:24:13.3342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SSkaeF7tALYf6GxgZTSOdqC++ufJulMropcRUoeRlhnpQpdFbrbAtqvhOLZkwjCocUsrcqq3Gy3TK5KYQR87NpK86wy/xxcSBYMm+y/JR3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6476
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Mon, 17 Apr 2023 11:34:06 +0200

> From: Marcin Szycik <marcin.szycik@intel.com>
> 
> Introduce new "guard" rule upon FDB entry creation.
> 
> It matches on src_mac, has valid bit unset, allow_pass_l2 set
> and has a nop action.

[...]

> +static struct ice_rule_query_data *
> +ice_eswitch_br_guard_rule_create(struct ice_hw *hw, u16 vsi_idx,
> +				 const unsigned char *mac)
> +{
> +	struct ice_adv_rule_info rule_info = { 0 };
> +	struct ice_rule_query_data *rule;
> +	struct ice_adv_lkup_elem *list;
> +	const u16 lkups_cnt = 1;
> +	int err;

You can initialize it with -%ENOMEM right here in order to...

> +
> +	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> +	if (!rule) {
> +		err = -ENOMEM;
> +		goto err_exit;
> +	}
> +
> +	list = kcalloc(lkups_cnt, sizeof(*list), GFP_ATOMIC);
> +	if (!list) {
> +		err = -ENOMEM;
> +		goto err_list_alloc;
> +	}

...make those 2 ifs goto-oneliners :3 As...

> +
> +	list[0].type = ICE_MAC_OFOS;
> +	ether_addr_copy(list[0].h_u.eth_hdr.src_addr, mac);
> +	eth_broadcast_addr(list[0].m_u.eth_hdr.src_addr);
> +
> +	rule_info.allow_pass_l2 = true;
> +	rule_info.sw_act.vsi_handle = vsi_idx;
> +	rule_info.sw_act.fltr_act = ICE_NOP;
> +	rule_info.priority = 5;
> +
> +	err = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info, rule);

...it's overwritten here anyway, so it is safe to init it with an error
value.

> +	if (err)
> +		goto err_add_rule;
> +
> +	return rule;
> +
> +err_add_rule:
> +	kfree(list);
> +err_list_alloc:
> +	kfree(rule);
> +err_exit:
> +	return ERR_PTR(err);
> +}
> +
>  static struct ice_esw_br_flow *
>  ice_eswitch_br_flow_create(struct device *dev, struct ice_hw *hw, u16 vsi_idx,
>  			   int port_type, const unsigned char *mac)
>  {
> -	struct ice_rule_query_data *fwd_rule;
> +	struct ice_rule_query_data *fwd_rule, *guard_rule;
>  	struct ice_esw_br_flow *flow;
>  	int err;
>  
> @@ -155,10 +202,22 @@ ice_eswitch_br_flow_create(struct device *dev, struct ice_hw *hw, u16 vsi_idx,
>  		goto err_fwd_rule;
>  	}
>  
> +	guard_rule = ice_eswitch_br_guard_rule_create(hw, vsi_idx, mac);
> +	if (IS_ERR(guard_rule)) {
> +		err = PTR_ERR(guard_rule);

Aaah ok, that's what you meant in the previous mails. I see now.
You can either leave it like that or there's an alternative -- pick the
one that you like the most:

	guard_rule = ice_eswitch_...
	err = PTR_ERR(guard_rule);
	if (err) {
		...

> +		dev_err(dev, "Failed to create eswitch bridge %sgress guard rule, err: %d\n",
> +			port_type == ICE_ESWITCH_BR_UPLINK_PORT ? "e" : "in",
> +			err);

You still can print it via "%pe" + @guard_rule instead of @err :p (same
with @fwd_rule above)

> +		goto err_guard_rule;
> +	}
> +
>  	flow->fwd_rule = fwd_rule;
> +	flow->guard_rule = guard_rule;
>  
>  	return flow;

[...]

> @@ -4624,7 +4628,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
>   */
>  static u16
>  ice_find_recp(struct ice_hw *hw, struct ice_prot_lkup_ext *lkup_exts,
> -	      enum ice_sw_tunnel_type tun_type)
> +	      struct ice_adv_rule_info *rinfo)

Can be const I think?

>  {
>  	bool refresh_required = true;
>  	struct ice_sw_recipe *recp;

[...]

> @@ -5075,6 +5082,14 @@ ice_add_sw_recipe(struct ice_hw *hw, struct ice_sw_recipe *rm,
>  		set_bit(buf[recps].recipe_indx,
>  			(unsigned long *)buf[recps].recipe_bitmap);
>  		buf[recps].content.act_ctrl_fwd_priority = rm->priority;
> +
> +		if (rm->need_pass_l2)
> +			buf[recps].content.act_ctrl |=
> +				ICE_AQ_RECIPE_ACT_NEED_PASS_L2;
> +
> +		if (rm->allow_pass_l2)
> +			buf[recps].content.act_ctrl |=
> +				ICE_AQ_RECIPE_ACT_ALLOW_PASS_L2;

I don't like these line breaks :s

		type_of_content *cont;
		...

		/* As far as I can see, it can be used above as well */
		cont = &buf[recps].content;

		if (rm->need_pass_l2)
			cont->act_ctrl |= ICE_AQ_RECIPE_ACT_NEED_PASS_L2;
		if (rm->allow_pass_l2)
			cont->act_ctrl |= ICE_AQ_RECIPE_ACT_ALLOW_PASS_L2;

>  		recps++;
>  	}
>  

[...]

> @@ -6166,6 +6190,11 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
>  		act |= ICE_SINGLE_ACT_VSI_FORWARDING | ICE_SINGLE_ACT_DROP |
>  		       ICE_SINGLE_ACT_VALID_BIT;
>  		break;
> +	case ICE_NOP:
> +		act |= (rinfo->sw_act.fwd_id.hw_vsi_id <<
> +			ICE_SINGLE_ACT_VSI_ID_S) & ICE_SINGLE_ACT_VSI_ID_M;

`FIELD_PREP(ICE_SINGLE_ACT_VSI_ID_M, rinfo->sw_act.fwd_id.hw_vsi_id)`?

> +		act &= ~ICE_SINGLE_ACT_VALID_BIT;
> +		break;
>  	default:
>  		status = -EIO;
>  		goto err_ice_add_adv_rule;
> @@ -6446,7 +6475,7 @@ ice_rem_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
>  			return -EIO;
>  	}
>  
> -	rid = ice_find_recp(hw, &lkup_exts, rinfo->tun_type);
> +	rid = ice_find_recp(hw, &lkup_exts, rinfo);
>  	/* If did not find a recipe that match the existing criteria */
>  	if (rid == ICE_MAX_NUM_RECIPES)
>  		return -EINVAL;
> diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
> index c84b56fe84a5..5ecce39cf1f5 100644
> --- a/drivers/net/ethernet/intel/ice/ice_switch.h
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.h
> @@ -191,6 +191,8 @@ struct ice_adv_rule_info {
>  	u16 vlan_type;
>  	u16 fltr_rule_id;
>  	u32 priority;
> +	u8 need_pass_l2;
> +	u8 allow_pass_l2;

They can be either true or false, nothing else, right? I'd make them
occupy 1 bit per var then:

	u16 need_pass_l2:1;
	u16 allow_pass_l2:1;
	u16 src_vsi;

+14 free bits for more flags, no holes (stacked with ::src_vsi).

>  	u16 src_vsi;
>  	struct ice_sw_act_ctrl sw_act;
>  	struct ice_adv_rule_flags_info flags_info;
> @@ -254,6 +256,9 @@ struct ice_sw_recipe {
>  	 */
>  	u8 priority;
>  
> +	u8 need_pass_l2;
> +	u8 allow_pass_l2;

(same with bitfields here, just use u8 :1 instead of u16 here to stack
 with ::priority)

> +
>  	struct list_head rg_list;

[...]

Thanks,
Olek

