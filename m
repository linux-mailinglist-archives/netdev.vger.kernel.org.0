Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80226E7D70
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbjDSOu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDSOu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:50:58 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5429D10D7
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681915857; x=1713451857;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bzKg1c843IicoBNTItc8rQaApbyzs0XyU5ghoGnnLyo=;
  b=TS/i3P16zJqZeBa4uNtmkRUszh6v17jdyTcy+zZ0tCN+XUoQyhanjTxn
   eNkc1QDEtYRxdkSfOvN+Dh2g0wIV3eOJphy3o+z+jFBMGmwE1p57NEVMt
   ZzLsddYOnlgDmtendZ5MXhdRV7RaYPRmqX+SjbmzIgZ2f0QnuKDaLz9bX
   qfwYhoIk09R5nukXGhaNJORH0mC6wDFXpue7m1uP9J/OfugbNdmoerJeb
   tYZc1lThJRb/6TaHa9sXzxo8ziMJjL+DmQEc9PJOlv0ma2+Wpu/I5P4lh
   L/2k6Hjz3YZ/PJaIcPS0VduPbQxKB1Up8k33cvi85Tifz/fJ/v8f/y82v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="373351024"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="373351024"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 07:50:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="668970848"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="668970848"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 19 Apr 2023 07:50:56 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 07:50:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 07:50:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 07:50:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRgYIeTf1XB8oHHke2I6JOPIX9JUTpKPUEVC9yEI9A21p8TJ7z7JeZWv91jSOgoqoz4SXOVqKJ7D3bx+YILUVas66tuaCgc8yVeef8/VnhivKpfiUlak7xOu9rKFjmeOB/IObghU/x01M42KtINhxXPo+0Gvo3YLDBd0piSfRcWRf7evs1CVLUUYKqRsPKSRHRlTwnlRdILx+yfNidhkCUycr4GoLvsHJiYuHo+srU5TOlfo3gGPHFA//ivsOoc9DSSiTA+SrhjqtcgDlqMqgy+oig0Y/mVUirCIZb/6KuYn86aHjnGt3b8C7q9Xe+6ooMiMZf3rjpAfi3/EUuV/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80KzcLa1k9TtWOulg7EoK/++auitFtq9sQnRS2M+Uac=;
 b=ihS6ZKft8IHJKrXCisjUCoxLx2qduPdk6DhyG81Sc84Pdwtrcbis5vAGrBxbNmLqXKZbewUcrBOxffDOGd8/HioKWBKhE8bC/Aujt+epNVopYdTk/RGSnhegNBT0xv/9cIzcbP7BVeZM+96P/ip+ub4f0IkFsID6al6qzHsvX7s+fgCglKk3a21ymhq8/9AUwc432KhzcRv+yDT5Orba5xAUTo9fujybOFJWtMw+kQhni0PW1I/J0f/gJWtefLnxP7gNaDGFM/P8zMKeErqcdIXyW6OHnM+Xec7W/I+ib6V5Fxs9dn/Te7GzxKdR5FPLzD34x+IyWenE+j7N9di/QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB7855.namprd11.prod.outlook.com (2603:10b6:208:3f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 19 Apr
 2023 14:50:54 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 14:50:54 +0000
Message-ID: <4ccc2643-788d-03a9-a022-04045c85da42@intel.com>
Date:   Wed, 19 Apr 2023 16:49:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 03/12] ice: Unset src prune on uplink VSI
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <david.m.ertman@intel.com>,
        <michal.swiatkowski@linux.intel.com>,
        <marcin.szycik@linux.intel.com>, <pawel.chmielewski@intel.com>,
        <sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-4-wojciech.drewek@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230417093412.12161-4-wojciech.drewek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0687.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: 5700a27d-0f9c-49ba-e5a6-08db40e579af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KhUDcXDa/WQH3gcCEiHb5FESmqPvp79r9wj5uJeSd7+odtk40sRdD7E5er11ZeKW4tQ106vfbvyBHZKhKJg7482526D2Yd9E2oNqPfMqpzNXmMgUFFs4hWOOPlnN+N6rcZ/NqTVZduMGkmjABhh9Db2Gcudcw7QdooQIjC8huc9CDxPR2dH5oyMGTEoN04FSMExjkrFC2OUx/tBsaQLtzneE0fzErjv0n3kTgFgEaxu6NFU7F1QuleKlMlkWC/nA2B7mguROVwjlfqmrED4k3wIdl390yTleWYcXGWaIRLXaFHGFFJkhwOOTK02G6+k4uTG4Cfo1h8NWRMVwt2q4F5J8/9k0PZ/+FUiUhH8w6iYVaJq64TQC7lkq0i8F+blR0fy/OxPcRTdXjmnm/OQpWBPZxHHS4Ln1Tg4QMhvozyE4ytHlfJwj93hFolbNjDE7IOSRNY7d7EnrOi6kNFHK7Dok7Yei/ZBt99U0w3sX5hGndpm1R4OsSxMTaMrbbnKsdnRUxI377VlkUqQGzit0UqNzjOLbEeSGLQ0ZDCGLGDVmDLFKYrdkbmDNprGU2PM0U7t+NytRBlzkf7zHlu49cCKxNJmHshablaKMZL4z83NQKXnh5AUyd/0CH2DXYhVfiX6a296DFmHLe0yXhHxUuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199021)(2906002)(31686004)(8936002)(6862004)(5660300002)(478600001)(8676002)(41300700001)(316002)(36756003)(66946007)(83380400001)(66476007)(82960400001)(66556008)(37006003)(6636002)(4326008)(186003)(6506007)(6666004)(86362001)(38100700002)(6512007)(6486002)(26005)(2616005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTVzYjVZUzRzSzdCRi9DaXdMZUc2dVU4WkpWcnhoZUNTeVlZWnFHWnpsVzEx?=
 =?utf-8?B?dng5TUN3R3FNajUrdFJkeEJsbWFMd1E2dWpuQXR6VG5VSHVKN1AvNWpGdkZV?=
 =?utf-8?B?cVRIUm44V3lpUlg1SWkzdndEclJSREpJUXRRZHRPNXV3ZGlBVnMzVm9OS0FU?=
 =?utf-8?B?NjQvSUpvUjlwd2RHbUZkNjh0R1BzZmYyYWFRVWZjbFNiaW9QQVA0aktvTS9H?=
 =?utf-8?B?NFRPMnN5b0RTZURtNnBueDNrMkVQTWMyYXpoOWoxT3V0aGw5b0tKMHlIUmJ3?=
 =?utf-8?B?anhCSnRMaHRTMG1wbDZhd2lMd2orbDdZNWxVTm1IT2Z5d3ZCVzh6NnhWVW9Q?=
 =?utf-8?B?bFFzZDd4Y3hIclRjM3U3QmV1eVM5WHNWN2NRMm9ObU41bVh5WmEzQVVnNW00?=
 =?utf-8?B?bkVxZFdvamtVMkpHYjBqVENBZjdETm9sZDZpSmJYaVptdTdOKzlXbkdKZU9M?=
 =?utf-8?B?N1k5cm1UdXR1YmtsS1BTRlZLcC8zZXFnMjVZRDlCbXVnZFRvOXA3UE80Vkc1?=
 =?utf-8?B?dG1YT3ZLQ3VORnlsWlQwMTM0aThDU1RMcHBjenRyOUVXR0J3RTNlSnc0K2tB?=
 =?utf-8?B?dWVIOURaODBiZjYxYXRuUlVsZVU4Q0JwTUxscVdKUUlpL0lkQTFlUm5MQ1BP?=
 =?utf-8?B?djFxa1lEbnFZRjBEbVVrLzVsdWhpYmlpbWs3ejZsYmZKK21pSExjcjUvWktp?=
 =?utf-8?B?QllqdHdLVWtvNFZkVTRUclBJNmhFVHEvNHphVHZMQjJld1JrT0Z1QzhQWHUx?=
 =?utf-8?B?SkovS1JLWVBHVTF4QVIyZFU3NGlSNHVjOVZjVjd3NjUybzNVMTVaaU9SVjJa?=
 =?utf-8?B?WnVOeHpQbktoRVVjYkgvTUdCNzE4WCsxR0tIL3M4Ykt2UFYwclE5SWdvZ3NU?=
 =?utf-8?B?Qno3enFSbFdyeUczSzQ0OWs4OW0xQUJlTzFCeDhrczZvaVlqVXNHaitOMlp1?=
 =?utf-8?B?ZDc0V2VyWDJ5dVo3MWo1d3F5bXB4ZFN4R0M1ZW1NV2N6OVgrZ1FHejVRNDNm?=
 =?utf-8?B?TDNpTGdrVEt0MnpnbGkxSU5HMFp1ZzQ0Vi9hY0xKdGFnd1g3VFhGSkx2NkE3?=
 =?utf-8?B?R0o3K0JRVDBxUTBkUUo5QlBiMTQ1NGVrVEEwZXV1NzNzZTJwM09IZTBJS2JJ?=
 =?utf-8?B?SmpTQnU2L08xRTl2OGpJSlUrU1EvVkcwSEtGWUxNazIvYjJwdjNxb3pIVjYw?=
 =?utf-8?B?V2x2Y3V0NUVnNTJqdTNEMTlCQ1hmMzN2aVhrczRpOXYydHowWnF1UVB4NFJr?=
 =?utf-8?B?SGNyQ0s0VWhzdFpMWTR4T3dqbVVBTkdKZ0YwL1BEUUV0MTRIeGdZNnFCMzZN?=
 =?utf-8?B?OTJvNWtzRS96OHErSGlva0FEaVpEU1ZoYnlncTIxRlFvcFRvQVlFaU9RK0Vs?=
 =?utf-8?B?aEJGYld2blFTNzJvcUpwZjk3NTlsWkhXNGRGNzhJUUxkQTg3eERidWVXWUN3?=
 =?utf-8?B?VG5VLzlqUit4NnEyNDhPelRFaVBCMG5hZ0NKU0JpRys3WHh5bGw5UTFxbGJ1?=
 =?utf-8?B?Y2pvSjllZExSWWVWK0tYNDRhMGpaVTIyZ0lnTE9JcW5EV05HajBEMEVBTWcw?=
 =?utf-8?B?Tzl1R1hJalZWZys0ZkNlT2pXSENsNEVJWTc4T0IzWWJmZ04rRjY3WCs5aW1m?=
 =?utf-8?B?YjhBR1l5S29CdXZWM3hzTENBTTI0bHVIYU9ERVFGQ2oyZFNHNXQrbzRmalJY?=
 =?utf-8?B?OUhQRGlmL0h5MlhTOEZ5NjdlMHArRGg4b25SZU51NHRUbFVJVVp0OUhvMi9U?=
 =?utf-8?B?em1tRVNDbWR1Wk9XdzkzK2cwVW5WbU5SOUJpRXl3L2h5MTBPRnRpR0syWDNn?=
 =?utf-8?B?N1hjN29SWU42QWthNWk5RElVWVNRQm5HOWlnZStWWmphVDZVck1DTTVJd1hv?=
 =?utf-8?B?Q2xRVFpXak9GYVBrVEdHSXdTM2FGMFJrdTczZlJpZk9wdXdFdHIyK0xsQTkw?=
 =?utf-8?B?cG5iaFB0NWFodjY5RFZRTGx1QkZsMEpzSk1EZkFVeXcycE1Fd05YWkhFZmt0?=
 =?utf-8?B?QjFON2lXamxGWWRmaEYyQit5ZkF3a0FJdzJnd01vczErdDN5RkQvQ1pwdnBS?=
 =?utf-8?B?aGNHblpYY3FoZGhDaUtIMVFUZi9lb0k2R1I0ZWZGNVlUd0htcnJla3E3bmZR?=
 =?utf-8?B?RjZOc3lpM2RXd3EyM2JPeTZ5Zm1hQ1RNNkxMNFFoSHo4bk54U0FHeWpmeDRM?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5700a27d-0f9c-49ba-e5a6-08db40e579af
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:50:53.9153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +tOoxs3SZNNjipBvPggG90M8odxbfFFtovHNh+jQcVp57rPn3UHDG8i9WH3dlo67SeJgmVzHmM/FluOSKAgp6OmwTVZssD/MiVXuyBZol4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7855
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Mon, 17 Apr 2023 11:34:03 +0200

> In switchdev mode uplink VSI is supposed to receive all packets that
> were not matched by existing filters. If ICE_AQ_VSI_SW_FLAG_LOCAL_LB
> bit is unset and we have a filter associated with uplink VSI
> which matches on dst mac equal to MAC1, then packets with src mac equal
> to MAC1 will be pruned from reaching uplink VSI.

[...]

> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 3de9556b89ac..60b123d3c9cf 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -4112,3 +4112,27 @@ void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx)
>  {
>  	ctx->info.sec_flags &= ~ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
>  }
> +
> +/**
> + * ice_vsi_update_local_lb - update sw block in VSI with local loopback bit
> + * @vsi: pointer to VSI structure
> + * @set: set or unset the bit
> + */
> +int
> +ice_vsi_update_local_lb(struct ice_vsi *vsi, bool set)
> +{
> +	struct ice_vsi_ctx ctx = { 0 };

Nit: prefer `= { }` over `= { 0 }`, the latter may sometimes trigger
Wmissing-field-initializers (I might be wrong here, but anyway).

> +
> +	ctx.info = vsi->info;

Can't it be combined with init on declaration (you either way initialize
@ctx with zeros)?

	struct ice_vsi_ctx ctx = {
		.info	= vsi->info,
	};

> +	ctx.info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_SW_VALID);
> +	if (set)
> +		ctx.info.sw_flags |= ICE_AQ_VSI_SW_FLAG_LOCAL_LB;
> +	else
> +		ctx.info.sw_flags &= ~ICE_AQ_VSI_SW_FLAG_LOCAL_LB;
> +
> +	if (ice_update_vsi(&vsi->back->hw, vsi->idx, &ctx, NULL))
> +		return -ENODEV;
> +
> +	vsi->info = ctx.info;
> +	return 0;
> +}
[...]

Thanks,
Olek
