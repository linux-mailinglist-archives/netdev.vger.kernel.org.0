Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E21672A24
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjARVPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjARVOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:14:40 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5977245F52
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076422; x=1705612422;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J4qnRf38YZA5Cj6fMcK1nsJ7Mc+22WUbP+wmwPutStM=;
  b=dHwI1S6WTx+ajqEskOJc+Hehf4vpaH5bmTqdCSZ7pkmAyk90iKb7tzoS
   6qy18ox/nB/ZwUvH4zKHgvRH57MNo1kghBc1JnluPFc2zbk8Md8ioJkJY
   uaLxDa1RD0lkecJ/grCR6x6PJTkICgGGVoaPCHmLt6KlvRBs7DwyOY9qv
   AimU5VBP2a1wDlvS8A3jZ1eS7xdnvkL8f0of+DN31bYcQQCZxnyUW+Uwj
   rm21ooNBr6qMJf4/5uOowCZaDCaw1fv9KR+6SM1zdQkMAJSP4mm2xHqJj
   aYkG6PVpBCTIPzNJG9HRJy2tadQHOi9OZ4qH2kPttGMVwo7sO+bGE8FQT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="352353773"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="352353773"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:13:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="905272073"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="905272073"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jan 2023 13:13:41 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:13:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:13:41 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:13:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0mdEjDsyvnB3v2dIAPFGJ3DoyB12maq/6HSOuiqWYRln4q17aqSl9tWGgbOGZqCnhcrAcTOhPWniwa5e67w2JW5IYiScTubAZ6Thcajz6dcGQGqSaYdut7k9fBPi0qoPij73ZgqX/0EgAlEposKvXcPj5wUVoiEP5+t3QVv+kP5kZwvgK4xcX+ZRD/9iOY75rBSmz0oGWWE4mHI56cuV+K+RSKk9rJXCYNJ83dQ5WwH4NTZxoc8ONgS35FKyrRgcBgS6JDwM2Kmq02k7COmTypzYv/5om/0tAd7K+3TIT9e+TSmeGRL6aiJyyGXbiBTuZdJeSOW24LFjNfMgh4Zlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kA1PT56SmzhBEhxYhoaKBsq6mVheXGpYbjOYpm7ApeE=;
 b=LHC3BLzBqvQyP6nu9zRYyPL2e4nAYWuypw9Bxi00mFUlDMbJOLNOVuZgz6B9K5SIDUHBQZUlG1LpQh/uhfcj+gv8eAL66UFkU6Vx4Qfjb5AXdzS/HHl2X3BCAy+5/6FDlFR7RVN8nrKx4viHR4Q1C4r3jjfyBKMlzK2nsHrfm2qkokosyCt7vpZL3V/2WYbupBhKrtty5U3qp83F6WfzcTo9GqjtZbYSN+5a7wlcrxnjR1wMhwsuI5+7IJnSyQ+uO8nPqs8hdIBRdR0BrmM8bf69UyeYWSrYnq5rfUhqAxujLFfKKlK2dsY2fJVN5fec2Kx3yiyyVCgkvN5LmQ9RYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5107.namprd11.prod.outlook.com (2603:10b6:303:97::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:13:40 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:13:40 +0000
Message-ID: <799d94f6-f99a-ad62-b388-f20a777f8e27@intel.com>
Date:   Wed, 18 Jan 2023 13:13:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 02/12] devlink: remove linecard reference
 counting
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-3-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-3-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0105.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::46) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 97da1599-81bd-44b8-767f-08daf998defb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C8RGiIYMDQRTZhswsmr7mAjacr1SMVUH9jbAYgGTAIBG2eEN7UoKWbyUU8+ta0aqHqfrDlqA0+NqjiN4YuwIUX1/tDWYU3xFIpFwNmgwv1jsq1pjriQZCcjqZ9W6J0bmQnOjadbq8L5YUCnz5CcGhzShpLh6hweVl6MVnpgnTY96vfVTH2e6ZUxyogAiyeFfN+s5c+l+8XO/+ZskAZu+kwYbsaM1nPKiDltBZHB8OpCfcIjLcL1++965RrxKIlXt7oEsst3vFaZhGIP0xW1YfOS4qFKcErgqMr+LA9U25J8Z3V0i2CtS8ZqddblKFM1Tdtvr2toRd1PoeZH4lfQ/Q0VTOJPmfschVc5gFDdHVyWehWMS9hvSp1rNKenh6diatmDVul/ehZJ0/SkIwFw+WYtmCgh7vL1utqIQ2k0hGVRaaykGkGYX171Ysy+fmXHcZIcrsDKAJSRu/jUmXfqYNhiv07lP9c7cYqsZ0Hlk+FJMqIvZFef3nGdX/Xv4/JDwmgvqxf0LocRYZKlsWWQPVA/Oomg3PCF7Hato3ZesWTusQ9qZUz6Gl+sCgH3SCRXBcA6Vflk+lTt/jPI65FGcRnAJ0csZXQ6AoB7tWiro+n2fcoLNnP69p+nBv7/Buc2Y0Ykp03pzns2jvZ29utd/6yjZKg2l91eYygnukjRNpbdMZpn8FyyL/7ATxVAW4Emr2nl5kzG6OGJFWKwBKgzJAHwMlBVa+ZN2GALtEK6eT2o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(82960400001)(66476007)(38100700002)(31696002)(86362001)(8936002)(5660300002)(7416002)(2906002)(66946007)(66556008)(4326008)(8676002)(41300700001)(26005)(2616005)(186003)(6512007)(83380400001)(53546011)(316002)(6666004)(6506007)(6486002)(478600001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTNQWENsUjk3U0E0WVhwUno4Tk95aVFIYWNtVWs2cG4xS0t5ai9pb2JialB4?=
 =?utf-8?B?cWVmOG14bkl0YXIxMVp3SEEzRDdOaXlLLzhGbFN5SnI5ck56UWJFNUx1VVhK?=
 =?utf-8?B?VDFrb2RmdmZib2UxeDNVVzBIa05XLzhSK253YUl0a2ZseXBXTDNhdWpsTTFL?=
 =?utf-8?B?aVRnMmxZYWJtN0ZSWkhUc3NTckhXalBsT0ZWekpoRkNUellWRms3c0k2Wm9l?=
 =?utf-8?B?VkdFZENlUEtiM0MrWFRESlpkdCtmZnJuRERRT2VxNmxvU1BFUVNubnkvRUVG?=
 =?utf-8?B?TGtKMVBCTmx5UTZnUVZwOFk0RmxGT0E3ZzdJZDdZWHYyV2lNWkl4YitzcW5v?=
 =?utf-8?B?TWU5aXp4T3FKelRsYmRtMDFKU2FvK01nR0lwODV4UnRVVmtIVlZvcWM2bFd2?=
 =?utf-8?B?L3NrMHpuSyt3UGZpWkFXcDRFNTVOL3JBZ25TQlk0cytKaldHWEx6ZmRLblZx?=
 =?utf-8?B?dWZvS3VMNnBoakYvRDhmWmJnNlVQM0lyUzhvTjhpUlUvbmo2RytoRis4cW12?=
 =?utf-8?B?ZVMwblhlUVVVbGtZYmVqcW8zTkZIdUlPV25LQnVybitrd1RCOVY3YitVY2Rw?=
 =?utf-8?B?bDEva2s3L3RFb3lBT0N4ZWIyQyttODRsMHZkUkJTb3NCc0JueXpoU3dpRFZ4?=
 =?utf-8?B?R1pvUnVlS0xRYzZFb2lOcjY2U1JXUGsxWEpVWXhTUkVHejNnQi9FQmVUeG1r?=
 =?utf-8?B?UWtXVm80RTA2aUNSZG1qcXYwZ0pVNU9QdlVuNC8yaUoySTZ2V0Y2eklPV0M2?=
 =?utf-8?B?WS9kMUplK3ZYN0krc0VsOVZFZTlkNi9LWjFDUWhwWEdoUWRVc1NyOWx6eEV3?=
 =?utf-8?B?SnBxWXFGVXhrbGREVUloSU4xTDVVU1NkQUdZTERYYjNJa3pxV2Z1K3d6U21x?=
 =?utf-8?B?dXRFYmJ6TWFoM2dLbGRzM0JiZ3c2bWM1bml0VExGTzdpVzdlN2FUOWxDK3pl?=
 =?utf-8?B?NlZucGxnUHVZdWdrSW1ETEw4ZDBGYVVsQ3FSdDZZanRtL2hsVkppU0lZSWRs?=
 =?utf-8?B?YXdZYzdsMjlhalN0R1kxMk5yOVY5elU2UVgyUlhlK01oMU9FQ2ZjTVQ0RnFv?=
 =?utf-8?B?cmQ2Z2E2Q2Y4cUtQU2dBeDJqMEh4ZlBic1V6MGo0OHhDcTF3SGVCNVpycHFh?=
 =?utf-8?B?NEpqdisrNDh1MTVqUVNScm45cjM2WlNRdU5sUzZ6WFZMbHlma29EQXB0Tzhx?=
 =?utf-8?B?cnF0aThxMVpvRjRvbVRSMWJPRVJYcHAvdTVjajI2bHorc1lsNWJoaW43UlVo?=
 =?utf-8?B?WnI4VkJPcXRLb1BFRThxZ1NWOTNPQmRsOWExZnVXQlp6NTdrOURFWG5QY0FR?=
 =?utf-8?B?MFRsYW53UnVJbWtpZmlZa0xiRkMzUElVM0x3SCtOWUxNZ3dSVHRzbGJGYjll?=
 =?utf-8?B?b0JXR1ZiTU5WRVFpejI2eE1mUVZPMldEUGM5Q2pTWkQxYk82L05GaUFKMnJZ?=
 =?utf-8?B?S3BUdnBWUE1FaTVJamUzYXN0dzJySWRsVVRXWEJ2WCt3dUdPbGY0Z0Mvb2Fi?=
 =?utf-8?B?UXJteVpQZGFxbW1jY09PNGlZbDE5U1lYSy9kTDJVQ2FvS2t4V2ZubG5TK1N6?=
 =?utf-8?B?Sms5aUtIQkE4ZVVsZ2luUCsrNW9QYUlsbkQ2WkF1QlJTNHVDL2JjRFNLTVp6?=
 =?utf-8?B?T0tVdE80UkhKVEQzT0xHdjI2QTh4QjJUT1VvSUlRSHRPUHFlUENaQjdYb2tR?=
 =?utf-8?B?UzlnSUJrSUtPTFVrbnlrdkVBSm96bTdMOE1oQmsxMUJkb2J2SUdqUDExemha?=
 =?utf-8?B?c3VaWCtnZXJmcHVqbXlTTytwSW5idmxoTCtCM0IrckNNbVc3cFkrZHV4a2ZE?=
 =?utf-8?B?QURFamhnRUM5eDljMmhJbkF5bTNaamhOTjFkbzB1dlZJek50b3pSM3UzNzBk?=
 =?utf-8?B?OWZ6aUswRURXUTJabnZXUUFpQUdVTE9sR0pWOXhEdXZnNHJMbTF5a2VtelNK?=
 =?utf-8?B?a0FsN0tud3BUaVZ6ZkYxL0tCNzhXaDJwTVlMMVB5UHZzbE05WnYrRXJsTm42?=
 =?utf-8?B?UXQwYlZ1QXJlYi9NMkZrNy9qMlo4QXN6MEY5KzVacXhsaEtRUjdaRTNCZHBF?=
 =?utf-8?B?MkZEcXJlT2J3dTJGSmJpU2w0VXZlVzNyM0g5ZHpmYWZ0bDRzbVBPSVJxQk1w?=
 =?utf-8?B?cXpVUUNmSTJkendjL2FyVjJZalRhMnliU0xBci9pek9MbUdUL2F0WTYyWWxT?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97da1599-81bd-44b8-767f-08daf998defb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:13:39.8963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1deAJQUXAcdbTyeG/4FA0bFDBZMCv3XuTR0Cb0xtsjY+tX2e+o+WImcv0jmVeuPb2UglfLWPh+o6mc3v7qAkSm3dUj6oh7UYE/AbNuBHgjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5107
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As long as the linecard life time is protected by devlink instance
> lock, the reference counting is no longer needed. Remove it.
> 
Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
> v2->v3:
> - removed devlink_linecard_put() prototype from devl_internal.h
> - fixed typo in patch description
> ---
>  net/devlink/devl_internal.h |  1 -
>  net/devlink/leftover.c      | 14 ++------------
>  net/devlink/netlink.c       |  5 -----
>  3 files changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> index 32f0adc40c18..dd4e2c37cf07 100644
> --- a/net/devlink/devl_internal.h
> +++ b/net/devlink/devl_internal.h
> @@ -193,7 +193,6 @@ struct devlink_linecard;
>  
>  struct devlink_linecard *
>  devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
> -void devlink_linecard_put(struct devlink_linecard *linecard);
>  
>  /* Rates */
>  extern const struct devlink_gen_cmd devl_gen_rate_get;
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 6ba1baab80d3..c92bc04bc25c 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -37,7 +37,6 @@ struct devlink_linecard {
>  	struct list_head list;
>  	struct devlink *devlink;
>  	unsigned int index;
> -	refcount_t refcount;
>  	const struct devlink_linecard_ops *ops;
>  	void *priv;
>  	enum devlink_linecard_state state;
> @@ -285,7 +284,6 @@ devlink_linecard_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
>  		linecard = devlink_linecard_get_by_index(devlink, linecard_index);
>  		if (!linecard)
>  			return ERR_PTR(-ENODEV);
> -		refcount_inc(&linecard->refcount);
>  		return linecard;
>  	}
>  	return ERR_PTR(-EINVAL);
> @@ -297,14 +295,6 @@ devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info)
>  	return devlink_linecard_get_from_attrs(devlink, info->attrs);
>  }
>  
> -void devlink_linecard_put(struct devlink_linecard *linecard)
> -{
> -	if (refcount_dec_and_test(&linecard->refcount)) {
> -		mutex_destroy(&linecard->state_lock);
> -		kfree(linecard);
> -	}
> -}
> -
>  struct devlink_sb {
>  	struct list_head list;
>  	unsigned int index;
> @@ -10266,7 +10256,6 @@ devl_linecard_create(struct devlink *devlink, unsigned int linecard_index,
>  	}
>  
>  	list_add_tail(&linecard->list, &devlink->linecard_list);
> -	refcount_set(&linecard->refcount, 1);
>  	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>  	return linecard;
>  }
> @@ -10282,7 +10271,8 @@ void devl_linecard_destroy(struct devlink_linecard *linecard)
>  	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
>  	list_del(&linecard->list);
>  	devlink_linecard_types_fini(linecard);
> -	devlink_linecard_put(linecard);
> +	mutex_destroy(&linecard->state_lock);
> +	kfree(linecard);
>  }
>  EXPORT_SYMBOL_GPL(devl_linecard_destroy);
>  
> diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
> index b5b8ac6db2d1..3f2ab4360f11 100644
> --- a/net/devlink/netlink.c
> +++ b/net/devlink/netlink.c
> @@ -170,14 +170,9 @@ static int devlink_nl_pre_doit(const struct genl_split_ops *ops,
>  static void devlink_nl_post_doit(const struct genl_split_ops *ops,
>  				 struct sk_buff *skb, struct genl_info *info)
>  {
> -	struct devlink_linecard *linecard;
>  	struct devlink *devlink;
>  
>  	devlink = info->user_ptr[0];
> -	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
> -		linecard = info->user_ptr[1];
> -		devlink_linecard_put(linecard);
> -	}
>  	devl_unlock(devlink);
>  	devlink_put(devlink);
>  }
