Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065A36606A3
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjAFSuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbjAFSuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:50:15 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4330A25F
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031014; x=1704567014;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lSDuFfnbtqwT4ZvqUzHjKbNonVz1arAUC+Y1RcG84L8=;
  b=nCaaMuxhajk+rtejytWqg9s0uuL4LumRrWFOFehw+PlVLTInpx2sVIEU
   ZeWhYUR2l5EBfviKBk+swBgogRZSXwGq7V9SLODWFw6bvpiGK5LA0ZTvD
   eS6GAHss8p7+HXQdc1PRL0B41/wd47QwN5clWNTD9iOM7irqSWVP3Kk1k
   ZMFrCnxse7P8EgtVb5iqGEYHTUk5S7udnqF0Hmw6hbc9bSI0oXJVaYHQW
   GtLjj7mRZVfibuJVNur6t9hMM1kUriETJv1aj/xYky503fqbOaMkfvCn7
   Kpr80mjPLNZ4hVGhX82s+f9oWLcFysVOxyKR5t06c746LhlbMze9Svgwl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="302236287"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="302236287"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:50:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="829992379"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="829992379"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 06 Jan 2023 10:50:13 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 10:50:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 10:50:12 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 10:50:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNuV6U0ETlPYb1Q+AdRo+6g1tGgGYSlzMIrso7aQyves9TqVmEGAod8gvr24nRGZrE/OeN8XzkbBdgwn1P1R85cL+a1brv01QtmG+uX0FXD6yhfvZpCKEUGhMnmjS/bUHm99UFnWikGD4ADatEcadU0oZH6aS26YyywViiTwA5hQ5DIZjNDe2LBCqCmUXqNjK0DLv9qaHBiq4pIuSLZisGGtYnHMy04hekkhEsAPgfKg+1Q8yz2pfJq7kUfIbs7ZXr+iXeJvRGOSEu7Rm5oJTa8zbxkrgckk57p3P7vJm+gFedcP/uq7AF23cGiln29Ai0kF+1YrmLLZcXFa+E0F4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLq+sRBeymYuBrwp9UN/9FQCk8uPAHkEhqjfCB0Exfc=;
 b=gDF+Y6J3/KUNaC5Qfte5lklxG8Ji3I0IDb7sLjn0EaM9BRCuiT6pIlvUl8oHhBSZs7yCjMQNdgFAeZyG1DV/SI6++Ivjtb8//kV8d3V74A93om51ExdduDxYEWCSpKWRGVhIepYyjz0QGOeVjxpG7XuDsmZtJhR6MweLbazzqAU64umYeFSJj5a09xIk9fRNjEhSfXJg08y5ltYAKRk7QHKqvJeRhfbPUn1AVNQiXxradhU73e8W7A7tbNRJ+YK3iPmU4IL9MAB6z+YndrTDUBS7sA8NmztXazHXf3T4Iy159OMkHRQCRLJp+AswPhTZHqqj9+eCja+CXfBiuxxGmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SN7PR11MB7068.namprd11.prod.outlook.com (2603:10b6:806:29b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:50:08 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%6]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 18:50:08 +0000
Message-ID: <72232efa-e29d-9e40-d3f5-96ac7fb556c0@intel.com>
Date:   Fri, 6 Jan 2023 10:50:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
Content-Language: en-US
To:     <m.chetan.kumar@linux.intel.com>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>, <ryazanov.s.a@gmail.com>,
        <loic.poulain@linaro.org>, <ilpo.jarvinen@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <edumazet@google.com>, <pabeni@redhat.com>, <linuxwwan@intel.com>,
        <linuxwwan_5g@intel.com>, <chandrashekar.devegowda@intel.com>,
        <matthias.bgg@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
References: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
 <e9e8285ad5ade22fd4ad31b1f90c8934d2d10be4.1673016069.git.m.chetan.kumar@linux.intel.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <e9e8285ad5ade22fd4ad31b1f90c8934d2d10be4.1673016069.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0174.namprd05.prod.outlook.com
 (2603:10b6:a03:339::29) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SN7PR11MB7068:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba78e0e-d9b8-459e-6628-08daf016d542
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hp+rEQJhnUJBPeOZ6oCn+B1kZes8yozxjXUSimsvcwB1LlQyhwwNLyVB4zrdE3F3lJqRl2jEC58YT0RGWuJdGAu2faUNy5e1fXDWphZLWUQ3Zu1S3aq1twr/KEX0cK+txMFwgbFA1R6TrVSEKeP0QIOsyKoGAOCkuEBdc5RjMYAwamPc5Ry+D16mbS1drb9O80lNlqlhQeCgTzrdIzS6bz91Vb8mJjlYrf/l/7levQpl4hbNMHnD7XQXHU13ldvA84H5ILF7suPKGKPPK4IJdeorwyH+tv8SlauiUtyDhZVDsf8OihcPJzE3R5+Qow8CKcoqq9jDRib3LIp3CrSGccNVG63zTz/U/jvPjuwRPoKOdlaAjh/6B1D8Pl0lbN4/wlYoekSfnt/Wm6EjlMZ6TRD/kSS924jyrG+8n7gWNFgdG1eCK2Ju2xuO/NTtSAh0JIbOqWhvRlxYCwlcUzRlTyU6JsNb2KhZFDyjMkmZtPNjbELbRXVog/YXzKFsYZdKDL5JKVOGjBB6/TIwjxqve990hxGD+6o00EJGuVjjMtpQkn6uG6LOP08MvMKNBKLrp2tOOpZHUj9sMhnSvtK5F57jcWUMeptiE+7euq7joTn8JrqAxCTNgjBcl2gc1f8eikGdXmjAMw6+KkarSdLqmU2lctX5MD2EFOpBYxsNWIEDyszb7YM5CQvZYOU9ZxVebuv2kjsbE1FCqyUWVFkB6SALJ6TOQYzrVtT9KrTkDcc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199015)(8936002)(38100700002)(86362001)(2906002)(31696002)(83380400001)(41300700001)(5660300002)(7416002)(186003)(53546011)(316002)(26005)(2616005)(6512007)(8676002)(478600001)(4326008)(66476007)(6506007)(31686004)(66556008)(66946007)(44832011)(6486002)(82960400001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejl3QjFHNWRZYWFIeGVLSEtpaDM0c1RyQ2xLRDVMTWtKc3NiL0VEYXlYdTEr?=
 =?utf-8?B?WENXZ0M0KzFTNmZVWG5jMjk2WW81OU1CeUwxUUwwKzdCNVhFYkI1QndkOVNq?=
 =?utf-8?B?aVVlZDM0UU5WRXBVVHBaZHI0VEVLc1kyR3dhN2RwOG9BQWZsSEV5S2dMdC9w?=
 =?utf-8?B?UW5CQU45VDRXa1VoOGNZOFRUb1k1SFNPd0dRMHkvREo3S3NDdlVpNnBIeC8w?=
 =?utf-8?B?U1FWZmJ3bHNlcko5RHluNjlQcUFJSEF1Zm1Mem00UjNwT2txcWMvaTdHSCtV?=
 =?utf-8?B?YnVTRzFNUVFhcFczY1FocFFDcU9FeC9xbTN2a3JhbHBkbWxEcUtXNHFsL3l5?=
 =?utf-8?B?TGwrMEVIeC8yWkZPakJFYU5ncFdCNmJveE95d2xxc08yQ0xzQndkZFRBQUdw?=
 =?utf-8?B?c3Q2RkNtaUpqQ0t0V2JJcXZwbXJRRmN5SjM1dlBQK1dDRmJoVnN2WnlDenpy?=
 =?utf-8?B?b3M4Y2JROGE3OGY1bC81TGg1WFhqQ1B5MUw0VEhYbkNrU2sySnlPdUhtYXNF?=
 =?utf-8?B?dU1uRTVIMXhCNHROaDRDN0Q0TFBaVERnandPcFFRREVwMTJUQ2x0YmJpN0JK?=
 =?utf-8?B?S1N6VC8yOHF2VHBYUEdIY2hjQzIrSXM0dlFRZ2hsM2IySUpDekdEWEdrN3Fr?=
 =?utf-8?B?T1FEWERJcnhLcVpPc3F5WjJkNW8wYnF6eVcrdzhQd2c0RnQyWkdzcXR0dngx?=
 =?utf-8?B?UjNiUkFndHhiUUtwWG43cEdSOUhDaWNwVmtNMXRwZ0Q3Tm5tWFh4a1VaRkRV?=
 =?utf-8?B?ZXR3Ly9UMmRhazQ5Rit4NVpxNG9ZdmZxUDRPemppeFRVRFQrMW5oUk5QY1Zm?=
 =?utf-8?B?azExZ2JRbmlhaWVjNEVVcHF4VXZOUURsT2luZVBDVno2NFRZQjJGbHBmcTdO?=
 =?utf-8?B?L3hhRWpQYkttY3p4L1RWTE1CdGJpcjJROVFmdXcrbnFENSswcEdycDNzRG51?=
 =?utf-8?B?MU0wMkJMNnJpNlNlSS9qY2NFUERpMDc1VnhVb2hIVHNJNTN2RDUwdkFUbGNp?=
 =?utf-8?B?bjlDMi9tSUtMQzM1WmNFVlJhUkRxcWRHUktjT0VnOWpnTWwzTGo3RnJ1Z0V4?=
 =?utf-8?B?OFhWbzByM2ZnU1FTNEVXSGFVL0t6SFl0OENrR0I4WXdtdGJtNkxnR0s2KytU?=
 =?utf-8?B?ZE9IQXFHM1JTenZZNWM0ckNJWGxLRWU0MWx4Z3Y3dVRQWTdySU5JMjJXQnN3?=
 =?utf-8?B?djc1RllpSjRCK1NaeFFYeW9IMG9BNHFSTHA1ZjRtQTI1bFBXTGMxZXUrdmdK?=
 =?utf-8?B?NHdXUDBrSVBQSUZCVTd0U3BHZERVUm9SUGVxZTVBbnhFK3pyNU4yTHpKYmFC?=
 =?utf-8?B?eFp5L0grcWlTbzJjeU82Qi8vUjlxTnU5cVV5a2o0eE1uYzIyWnJsUDBWd0xt?=
 =?utf-8?B?QnZoaVg3Rnd0UHVldHg0cWdrcnpjcmFHTjVVRFpRWHppV1VFTFdxbFZleGp0?=
 =?utf-8?B?WWVjM3FPbnl5SDJPZFhYTzBzMERsbVNLaXhySTFuT2VSVGQ1LzVzaFJlZ0xj?=
 =?utf-8?B?UFZQUnhEU3ZDY0J4ckVqck14TlRXcjBKaVFkQ2piODJRaTEyT0U3SWt1MTJo?=
 =?utf-8?B?Z2JhMzV2NjlGVzVHMHhDL3Urcy84Q1ZLM05RbWNBR2taRmpUMW5mZWVsdTBC?=
 =?utf-8?B?dmZ4WVFXWkNZNkkrNjBBVGxaMmxSVnFKSk9rblZXQ2I4QUEwYm1aNTFVYnV4?=
 =?utf-8?B?M2NKTkZ1TUhzWVZxd0Ywb2t1V2xJbnoxcUcyOEs4VlhhWnVYT3hicmMzQzA2?=
 =?utf-8?B?M3kwVnNsYXdOWGk0dWJFKy9RaW5jWHA3NkxleU9ueDFzU1BtT0lkV3YxeVpN?=
 =?utf-8?B?MS9HUXQraEM4aE1oUjRhNWdFS0E0eG1GOVp6czFFWHlONHFxR0pRRS9GQVRU?=
 =?utf-8?B?aTd6T3RKMmltaTJZV3BSZEJwWVRRdzZLRzRyN2JzUE5NZmpWVSt6SnBLamVy?=
 =?utf-8?B?RkQ1OXVSbTFZaU5KWXJoY3pocWtDNGtnWlBRT21sNDV6QmFzaUpmdUJzQUs2?=
 =?utf-8?B?Y1VmRjNqbjlqSUJ0dmxLQjlTZUhCSERUUW04cDVzemtrTnFTeFkrWmJxdGd4?=
 =?utf-8?B?TUZZN3RnSEU3cHNoWFNFQjhiTC9LZ3VOWUpFRHZvNXB4RkpuT0dCUHNtcTQw?=
 =?utf-8?B?ZjMzZGFtaWl3NUpodi9kWHBVdk1GanR0bXNvd0gzUUNtYzExRFBidzNXWkJo?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba78e0e-d9b8-459e-6628-08daf016d542
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:50:08.6847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWLYMMhTR34QKqN3w10hmZTEwshjoAe+pxCDE9FaLnKWMYwg3LvSF66civu1zLgxbjAgFNmaorZSf51SHNHwS+2ns5Gw+iuR2M8quUYgJmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7068
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2023 8:27 AM, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> Adds support for t7xx wwan device firmware flashing & coredump collection
> using devlink.
> 
> 1> Driver Registers with Devlink framework.
> 2> Implements devlink ops flash_update callback that programs modem fw.
> 3> Creates region & snapshot required for device coredump log collection.
> 
> On early detection of wwan device in fastboot mode driver sets up CLDMA0 HW
> tx/rx queues for raw data transfer and then registers to devlink framework.
> On user space application issuing command for firmware update the driver
> sends fastboot flash command & firmware to program NAND.
> 
> In flashing procedure the fastboot command & response are exchanged between
> driver and device. Once firmware flashing is success completion status is
> reported to user space application.
> 
> Below is the devlink command usage for firmware flashing
> 
> $devlink dev flash pci/$BDF file ABC.img component ABC
> 
> Note: ABC.img is the firmware to be programmed to "ABC" partition.
> 
> In case of coredump collection when wwan device encounters an exception
> it reboots & stays in fastboot mode for coredump collection by host driver.
> On detecting exception state driver collects the core dump, creates the
> devlink region & reports an event to user space application for dump
> collection. The user space application invokes devlink region read command
> for dump collection.
> 
> Below are the devlink commands used for coredump collection.
> 
> devlink region new pci/$BDF/mr_dump
> devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
> devlink region del pci/$BDF/mr_dump snapshot $ID
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
> --
> v3:
>   * No Change.
> v2:
>   * Remove devlink pointer inside the port state container.
>   * Rename t7xx_devlink_region_list to t7xx_devlink_region_infos &
>     use region index in initialization.
>   * Change t7xx_devlink_region_infos to const.
>   * Handle remaining packet data if the buffer is less than the skb data.
>   * Drop t7xx_devlink_fb_send_buffer(), push fragmentation logic to
>     t7xx_devlink_port_write().
>   * Add "\n" to log message.
>   * Move mrdump_region allocation to devlink initialization.
>   * Drop snprintf for CTS command fill.
>   * Drop intermediate mdata buffer & zipsize.
>   * For mcmd use strcmp instead of strncmp.
>   * Drop set_fastboot_dl instead use devlink param for fastboot operational mode.
>   * Drop unnecessary logs.
>   * Change t7xx_devlink_create_region to t7xx_devlink_create_regions.
>   * Use BUILD_BUG_ON on array size checks.
>   * Use ARRAY_SIZE inside loop.
>   * Correct indentation.
>   * Drop odd empty line.
>   * Push common devlink initialization code to t7xx_devlink_init.
>   * Use skb_queue_purge instead of running loop to free skbs.
>   * Change t7xx_regions index to enums.
>   * Remove dev in devlink container.
>   * Refactor struct to separate out devlink static and dynamic data structs.
>   * Use min_t.
>   * Drop unnecessary var assginment during initialization.
>   * Change while() to for().
>   * Correct size check.
>   * Rename result to ret.
>   * Clean-up error handling path in t7xx_devlink_fb_get_core & t7xx_devlink_fb_dump_log.
>   * Drop __func__ in log message.
>   * Change NOTY to NOTIFY.
>   * Push channel enable or disable cb to port proxy.
>   * Use array index in t7xx_devlink_region_list initialization.
>   * Drop t7xx_port_proxy_get_port_by_name() instead access port name directly via port_prox.
>   * Drop udev based event reporting logic.
>   * Drop get_core prefix in goto label.
>   * Remove unnessary header files.
>   * Allocate memory for mrdump_region->buf inside get_core.
>   * Remove 'region->buf' in t7xx_devlink_region_snapshot.
>   * Destroy workqueue on following error case in 'devlink_init'.
>   * Remove useless checks(dl->mode) and condition(dl->wq).
>   * Support devlink component versioning.
>   * Kconfig changes to select devlink.

LGTM, but I wouldn't mind having someone with more devlink flash 
experience review.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


