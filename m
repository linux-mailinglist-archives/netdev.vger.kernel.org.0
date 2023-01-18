Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8036F672A35
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjARVQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjARVQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:16:53 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5B811EA4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674076611; x=1705612611;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2uwMRlc1SDTxrzEuH5GQhR9jIzkbatDWs2zoL9OnQMY=;
  b=ZhrDG/4AfFNpmhbGssKJUK1JwUHyfvUFeKj1p/NU3wCTONxxZCYxgYIr
   11TKJw/rVnnv/PyjfBmu/+QB/SG4MCUQGRHCoa8IDf5lGortw8esDtaBo
   f3lJGEoEndu5Wh/AA0ej1fHa6a9xRk8RPxQn8N9vSOhaOW+ptcLqDw23+
   CfBJKxivdZcWHviD2GVyqVmbygh+qhvVyP/1KdBh0PX5WabEFf8oESSoG
   xuI325Tchxzx0MXyweS8ornc+QnSt22TL5nPaxjxZOaelEInfaBFvBUBe
   ISNOy9msf0OXp2sP+W9alJN1FQoC+lWt09P0tbeF4fgWq1qbGN4g0p2yb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="308664471"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="308664471"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:16:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="723246018"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="723246018"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jan 2023 13:16:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:16:29 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:16:29 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:16:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmKtZfP7hxdS3K4b1sMFWXt6qSg954fOgiGXjX5WM17IdIbL32nB0gsxvGSvut4nNGVqRoPKUErSnkYdMNNGv10O4Upmge5XRJfMahE/Ri/CCU3PBGIf0NGmHQ4spqEZXjZo3dDB2VIKoEzlg82Q4yjCFvWCun31EAHFAszHJbj1Jpbw790TSs9kYqDiqeZDmuOPZuafgUcuw8ox9ihXZtWBEsedcRR9cXvkUg0Y2wAXW8bJ/H+2pf1EpOjlyehejTtAgoVksauVHvMIYDsYC7+r920JeYiMIall4D1drnBqcIj0ki3d6aW87WsZ1s9HBjaiLoS+ztlSucyyL32jdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOY9o3lGz8SEqZ8P9n0QCQOT0rLV5OyOT6fitQCgq7A=;
 b=OLZda4EWlr++nvMML5nt/QN1jG/p+0TJHG4HxsgG20VrF2cXAMdiXA00BXKg4gZ11+SZvkMLKljJIUfaTaeLOELpbK7m7L4Imp34TH/w/B5ST3jcV9YGSCEyKccFP3ZKAeIx4m8FhTrEn96LGO2Pnj/581g/RsvFehZ9kyDNwOtcPnJCeSgV4bR1fvUIySAoVv+bQ6FDRIHIqakwZuh2zpGrH0wv/SLCDUay9+yrp4CsZ8CNRArdaQ43JFf52i0X/HLddTitEnIRzXJLnbNdlYDTKn9uSkhnF+6TjL+oLYwrv1LWJmcdluTutTsz2QElNjaUuLiul958WBlBGcVL1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:16:27 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:16:27 +0000
Message-ID: <c4d4dec1-73e1-41bc-3b6c-e35a7121f419@intel.com>
Date:   Wed, 18 Jan 2023 13:16:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 03/12] net/mlx5e: Create separate devlink
 instance for ethernet auxiliary device
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
 <20230118152115.1113149-4-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-4-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0187.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::12) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: c327251b-7112-4f87-4171-08daf999429b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EP8t18MXd3mP4a4C2+2o2de/kKCNOaGlPGfREwqKQCWmq5i1AmjhXm6Pf0Fb+Sno6/pszzQlKf+M6LsUppEtrKdbYv7CozfAOF4e4ItDFZaNnW8O/T+xVZRQA8un99CZW53fpQH/uRnv9YWkVDRUWt49XU/8vdLNXUjtRDqfZDaLA+5Y73RHiNXelLLBSJZ2CD0b2rm8wLVY6Hx9CS+zOXkadSJgYEscq8m7OBsQOQ/aGhEMD3tsW063OmAJFXyKhUjKNIC0otHy4K1hh+1WAPgeYRyn9AjGUsKlSeWg6Hs2tCyrZ5v/gmgUaRJk6uP00q2Lj2bP6wd9SQ8WbyrlEOT2zxnrwI3LQ/ZDxOfyxo5PUsD4bStycea0cL8KxqLtIwjcCCo9L2sn5xF91Cwf7M1GvCYXf+IbJgJ1JJqhRs4brHw2JOJNmATWzie3QTANTu7arGS9jq+x+1niZerISUddRPgh3XeLg2DiXjYuU9IQo/qTqSE/qeZum5eLdN0+PK6vU1hbYGxRrvx+yifnNLST5isoYbVgRnFq/Q5EAo5M/gqLgCetii8BsyDi5GKHxVU2/9FAJiit0Aold6UvLYFsKOVLuAPDGiz8JvLum4U8EP4uDF2pBnakzVAVn8BYBkutv5g2LOri9Syv63CWcm8R4tB44/RTlhzmria9H5b/wL3x7fxgRVhrowFmyXfg7GNwmOsSj21HHjjyn2RyYdEGs1vdfiy8FUsHZJvegCI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(2906002)(82960400001)(38100700002)(31686004)(31696002)(36756003)(86362001)(4744005)(316002)(2616005)(7416002)(66946007)(66556008)(6506007)(83380400001)(5660300002)(41300700001)(4326008)(6486002)(26005)(53546011)(478600001)(186003)(8936002)(66476007)(8676002)(6512007)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGQzQVNMMllXZU05anhLM2JCS3g4ZmVBOUtPZ2o2dGJhMkJiLzA2WUVIWXh0?=
 =?utf-8?B?enRjVjBhVGkvZU9MaXNaYUNjcCtqTk1zQTNlMFIydnhyM2d1eWlDcm4vU0Jl?=
 =?utf-8?B?U2Y4YWR5S3hPNCsvVHRoUEUxNEFsODR6NTNzWHB4WC9WUkwzVHB4K3pRazls?=
 =?utf-8?B?Y0Z4SU5lZVlGNUNLVHdCdzE0aWJEaG0zTHBFR3dHaUZyUnpwOUZvTEsvcjNE?=
 =?utf-8?B?TU5Xc1lGWEZyWXVWdmNhOU42dTNCT2Y2QVluaTZJU0U1ZG9xMW5lcHUxNzNi?=
 =?utf-8?B?SU9FbXJIOFI2QUp0aU1QbUpHWnZEdlFqVUZRaXg3OEZtdmE4ako1L1BDdFV6?=
 =?utf-8?B?dzNWUDlWQW9XK2w0SVAvbG9wbDg3YnRFcGFmdlkveDNweE9oWktPQU9mbENF?=
 =?utf-8?B?cmVYMmlDYVpxclZ1Uy9JUGIrNm1EeDNROE9NQjRvQ2VNcEhTdHBxMnV5TFlO?=
 =?utf-8?B?RGRVcC8xUjVEay92M2UzMjhWMzNwdEtOL3FDQlN0eWQvTXNzc2ZmNkYrNGlO?=
 =?utf-8?B?dG5qWWpCSzMvODU4eHVMa2NMaTNQRCs1Vm5LRXZjZ2h5UVVKQXpQREdUNG11?=
 =?utf-8?B?Z2dvcDBnOUJOSWczSW5PMVNoSTFaN0FlVmZpcWVkejVuWk1kMktmMEwwT0F5?=
 =?utf-8?B?d0FoaVBqK0dicmd5cWlxTktZUUVvY2ZqMjcxWUVZSnVyZkZQZ1RJTVdYajBn?=
 =?utf-8?B?eGxSRWpLU3pQWmJYcEEvZUR5NEErYnp6SmZnRE9IZU5yTUtlTjFnVzJ4eWM3?=
 =?utf-8?B?TjhvdVJWelFjdWl2ZkdVeFZlY1ZPQTZLaEF0bERqY0VxVVhrdlI5bG4ra3ho?=
 =?utf-8?B?dmpXNE4xOGNobHFpM3U1V0cxUUh6L2N5M2ZKcklQVm5DZkVCN2xqcFd6NkRn?=
 =?utf-8?B?TVBaSERUa245YU5UYWkvNXUvNFA5cld3YWZ6bm8yYW5kNVNxOUE3UVR0NEVm?=
 =?utf-8?B?SjhvKzZvNFpZTWY4UHlxZnoyd1A4dEZCVUxNbGI2c3dOcmc3dElDQWFNVStR?=
 =?utf-8?B?VFNUTng2MGdqandObzI2YUo2RUZUeTZvbjA5YXUreEZ5aG1SajZ5c0dwaTNm?=
 =?utf-8?B?SCtmWTZmNE1ZNkxIQVhMcm1sQnFBT1JjTHd3WlppS2ZOZ0IxWTZmWWFNSDB2?=
 =?utf-8?B?V2xpdEkxMmtSOE9SeHh4Sm8waEtMUnBrNG80VE9YS2t1eXRuUW1YbkZkQ2dZ?=
 =?utf-8?B?dVl1bTI2OVpOMXhKV000OElkemdFL1FWaDVyNVNSZHJVOGMvZUpUbnhxbjh0?=
 =?utf-8?B?M1grUjYwdlBoV0dnQlZwMVRocDZ1UWl3UW9zeFJpaHZHRS9oM1BPeW5oUUJa?=
 =?utf-8?B?UTRJTkJVdzNsekxybzNLdmc3QVMxM004Tm5UOVVoeHNwSmczdFVEc0xMSWdp?=
 =?utf-8?B?d0hXNjFiTURCRXovaS9rcnVQaUNqN2w2dWVoelBLMHBYWFYyallxWS9TUHVW?=
 =?utf-8?B?QzVIUnQ2cURaVm05bFM3Ylp0MGJ4WUxaelJKYmpZNWw0VGpVdFBMWnlUdnU5?=
 =?utf-8?B?bHdydDdHU3Y2VHVoc1NsYjJzd2xNdkloVkZXd3RBdDA5dVB6cU1NQURjVFhG?=
 =?utf-8?B?bGg5SkhMUTRTcTFxaEJ1K0g1Y3c4N0xreTVFRUwrWnkzVWx1T3BOZ3FMbWw1?=
 =?utf-8?B?eDJtWlAwZG1rM2JmL1k4TWFLM0RHT2hPM1EwWXZIVUIrMUJWRjFjS3lNcHp0?=
 =?utf-8?B?OHNDa21JdnhpTU1HWG9xTGF4bkNLdE5wSEt0SVJGbWh1TGVMN05aN2JJVmYv?=
 =?utf-8?B?NFpKdnZ0elhjeXN4ZjdLWUZGTmgwcXg5Qm90L2xiRWtTTDdoTkE0T2JJdTRa?=
 =?utf-8?B?ZU5YcWZsQkRBTmp0T2g5VTQvUGhWTTdxMk84UEFwbUtWaFVaY2djMzFoODUw?=
 =?utf-8?B?QXFVanZWOGF2amN4c0hXdVp2U1BCUlNkUytmcVVzQWVCV0w4cEdmVlRtT0xp?=
 =?utf-8?B?ZVRnYTQzOFhaSjUvWUdJTDMzUFlPWnBXRVI1TytFWmNYWm16UDRPVEpscW5Y?=
 =?utf-8?B?d3VnOHhPZTF6YTBBeGNJd1FmTEhUZUluUlY4cVdJYmd2L0RPejNZU1doVUs1?=
 =?utf-8?B?TlF2TEd6ZXNITXlwdlBOeU9mNjcrQVp0aXdjaVNwMG9DTnAweEszNVpKeDlL?=
 =?utf-8?B?SGxQbXo1czNQcnExSDJWZXhXb0t1cmw2SE9NVnZ2aXF2R1daYVBIM3FIUG5O?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c327251b-7112-4f87-4171-08daf999429b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:16:27.0534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fh+k7VGUWoSPNP1MvL2fr6wTuGzys7kez9ka48FON2Qp7OGQDIf4kvF7CH+0zYoSGDexTFVdPbnnLdGMWL+jlGRvrcxI5D1TJQ30ZxDLxBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7381
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The fact that devlink instance lock is held over mlx5 auxiliary devices
> probe and remove routines brought a need to conditionally take devlink
> instance lock there. The code is checking a MLX5E_LOCKED_FLOW flag
> in mlx5 priv struct.
> 
> This is racy and may lead to access devlink objects without holding
> instance lock or deadlock.
> 
> To avoid this, the only lock-wise sane solution is to make the
> devlink entities created by the auxiliary device independent on
> the original pci devlink instance. Create devlink instance for the
> auxiliary device and put the uplink port instance there alongside with
> the port health reporters.
> 

So this would make the port appear independent of the main PCI devlink.
I think that's ok, they are a separate driver and managing the
connection would be really difficult.

Ok.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
