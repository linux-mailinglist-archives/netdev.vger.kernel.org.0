Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84FC6A95D5
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCCLNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCCLNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:13:47 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D18A12076;
        Fri,  3 Mar 2023 03:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677842026; x=1709378026;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0/K76MMDDFo/yD92fQj4GLWYjIMf/hHghLDui6YKJZc=;
  b=a40x7j2pjFTdkzB+LWdlk5D88tw+/6wKeBjg/2Br97YNAlP9WfFfVqVo
   sYbJ4ISLA5NFatI9M7xXUILWUExVDevd95+enzQvcPkKi1/ITk4gncQO5
   0vR5WJoK1uN5uaBa+fbHiLguxUchr3S5YIkkiB32L8QKqrzFbTdESipPw
   eVEJnWefRUYMbPfpy6txd+3Y2/Ou3GDhr3fAPLJvvO5RK+tuBFRQILAhb
   uVQg0LJqCgzM3ytEcxXdhTrH2g54wOU9Elk/9H8SctMq/s7tJufT9LEH7
   veLQTkFT2PaOviuOuNLjcMTkGrPc/3FSOGnidcU2DXwmfi6r8ZzKPbMTn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="333743128"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="333743128"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 03:13:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="921080073"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="921080073"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 03 Mar 2023 03:13:45 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 03:13:45 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 03:13:45 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 03:13:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqa1wE4F/xV7Q/RKVPe66mVfCq5HR/pvhvFwkGtV85uC8xOFjTNvoAyGJKq9bevw6DjUCjQaFV+3g7BoJFJgg00L3HCWQM7tSUq0OsYt49WcfjGmYJ1gpxzI0qXZWrKSUjuCN422kEiEyXUY6FY3f+K9Asfx+5kJHRwiR9mQn1Jhqx5dUQTDpCMJWOJ8dHsQ3ZwTcIdJ7601HUQor/1PlCrykMaOIdJwKGiX4rtYs+MP0AQHcnnuenPb07a3XQ0/Ql8e380Fiuf3r9fhfE29CRNQw9wyAlxU82Q7i/UDZi7voIkU1jPJfG1jUOQ63KFaalC9L3ktiEgO2drv8+5epA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Fw0MQqYfoXgF3X3TS6jppb8CQqbvs5KiAvEmd1GARU=;
 b=PtlSIGTtgFeiX7nL6e+NT+ejrC1LMebNfC45HLPclVW80w63iOKSGsU3qX4NI2WUt7WZR5dNNvAtPgmN1pXUWc3xtCt6tOMouJfBtXurBDoTh2Mkcb9SvwrWAJ0HIPcKP+pVKFxps8zzojcUDvQ6PMSYuFae21O67epogceyKmg0045fxk0GyqESfqdt+Db6eyN+2GZC9IQmBnoY3l5tf9YoQIaj/pkvaRdg8MeFaQZgqtEpgM5N+1UvTkwnXSG6EfvvtvK8DxAGtR8SId1/tcDxsqNgG0WUm/frT4kAkRhAsdnu+mypfreGF3KKRTeF5pLr/0vKqaNYkQF5HXD0Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MN0PR11MB6057.namprd11.prod.outlook.com (2603:10b6:208:375::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.21; Fri, 3 Mar
 2023 11:13:37 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.022; Fri, 3 Mar 2023
 11:13:37 +0000
Message-ID: <2d221713-cafa-8460-df6b-ccd11f42e4cb@intel.com>
Date:   Fri, 3 Mar 2023 12:12:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v3] ice: copy last block omitted in
 ice_get_module_eeprom()
Content-Language: en-US
To:     Petr Oros <poros@redhat.com>
CC:     <netdev@vger.kernel.org>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <scott.w.taylor@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        <linux-kernel@vger.kernel.org>
References: <20230301204707.2592337-1-poros@redhat.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230301204707.2592337-1-poros@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MN0PR11MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e93a015-02ea-4b50-97a5-08db1bd8553d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: THdio/S2iePjXEkyreeSVO+JqR+c9P9K1vUXVmP4m0nx+khyazZLD3o1LyfW2cda+SXlkPg4zGW191EAihM6Z2uN70NNweysj2sTAcKpWdYfbfgFKAElhzTBUCtXdlYJDRaFC7Js9DN4SoMd//PCvwNhqSZVzyIRA17MRFgZytWn5Mldacou24CVUvCU3EXCqcviGoQq/Hh7msr7gi8csKk3zZ2474VSvcrkpfN5dsJYw53KTjY584/4Fv7jpF66jwdoWvuJ97BNb0QEQgUHoVR9V85o88lz6gFuopokR/XxtUaJ1KS81e91Pu5XV1xKS9GrqxmoxIKxsLPXZqFzlBglh4w7Zrb31Lw3eA1aUfnOImgXhX66C7nBR1roznUUTQmLam4+i30RAI23mwWk4oDG2gCEblJu3G1ItPzCAbz7ciVoNxcTkNcfPDwO+HeIBMqrljkYRdwyAzP1hPaeCFVNwMqBQoWCo+GaBLPE2mQfCIsvZtG3XqENDr5wxeQVKNtvH8M/C8DTvCfviAsOlw3meA4Vy5ZBR/UXwYdI22cKjxtVLlke3O4nLzvDRCKepyus8plrXLH3QIBwEQ8GfutCzzl7EcAyx/1mxMZ18pnsrX5cXgA5qLIXQv6+CvWiYFL5qCuze1yvSCgot+uFuvhIiwqOedmBV69DmaRcikSl1g5PnOgxaoUcRrIAX6IWEbjUyk3w9dLdbinDUHmm0oVHrOkBOCTjzILls4l63o8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199018)(4744005)(2906002)(31686004)(5660300002)(8936002)(41300700001)(66946007)(66556008)(31696002)(66476007)(4326008)(6916009)(8676002)(83380400001)(316002)(6666004)(6486002)(6506007)(478600001)(6512007)(2616005)(38100700002)(86362001)(82960400001)(186003)(36756003)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzBlTUQ2Y056R2tqOTBObVU0VTVkQUFGbzRoSmRNNWlZZHBHR21aNmxnOSti?=
 =?utf-8?B?V3BnTjVGQzNVVVFuYkc1SEk1RVh3TWhGaFcwaG9GMVp0Y3p5L2VwVW4zWUF0?=
 =?utf-8?B?U0V3b3Y0Qjc5VEhYbFJIT0VMRExqVkFJTVh1VGgzcWVEYnpxWTNuU0VjL2Zu?=
 =?utf-8?B?bWFyYXlFbFA4d2F0UkpzanoxdU5JZ0ZZV1djemZKWklZY211SWdzYnl3RHlm?=
 =?utf-8?B?eG1jVFlHblRxOUdDa1FXeTlrNSszZ2xmcjlUaDZFMlJpSWZRNUtjT1ZFUm1z?=
 =?utf-8?B?WmhlOU5HT0JNaTRkcHZwRHFlMWVISUpqOVZQVFNZYzFBU3VwVVQ2RmJNdmlC?=
 =?utf-8?B?NlVReEh4NnR3OUFWRVhoUDFyc21ld3Q2ODBqaUFRV2FROXVjQ2lWcldjKzFG?=
 =?utf-8?B?dHRYNW9NNmJiNGNHMi9hMzVOcjlkd0pRdk9Dand4ZkpKZ0UrK2F4RTBrdkJ1?=
 =?utf-8?B?NGl5UG1vZnIyclZBamFHTWNlMHhCYnRZSVQxcEZMVm9jRGZIMFhUMTZKMVdC?=
 =?utf-8?B?L2hlNGRjdUJBNHF5aktXWmpKMUV6UG81VTZYME0rR2NGeDltVDU1bWZDbU5j?=
 =?utf-8?B?d09tYW1EK1ZiZ3NOT3hyNU9HOGN3SkN0UitKVFhHcDJnZ0djZmpOSUtjWVA0?=
 =?utf-8?B?OHNlYnRwQTAwbm04OTFCS1djT2JOeThOTjhhcFh6SEIrcUh3TlRwRHd1L0pv?=
 =?utf-8?B?MllUcUpnblViNHV3V0RKdUtYcEdNN09iZUZaRU0xcnNXK0NyTE9tdnBLVEZs?=
 =?utf-8?B?VHB5L0huS29VUFAxRitxVFN1eDd0Tk9MZEdYcjA5dThyKzJrZDU3Rm1QNFAz?=
 =?utf-8?B?NVFvdjRHSmJhbTZPV25uKysyRzZEOFQzWllLcWZ1dGJVc05RSVNzNFV5djlK?=
 =?utf-8?B?STJNMjQ5SGw5UCtpeFF5dUpCMTl2WHY2SVlYMURSWXdHMnhXR3F3TnIxdUZ2?=
 =?utf-8?B?bGtJdkZGZ29xQnpJZWIzTmFEb3BkYVg2bTgxRUNFVUlzTHFEN3R5NzBLTUJY?=
 =?utf-8?B?YVl0cndWWmNKNmpaaW1FL0o2eUVNOVAwNHBiRmk2OWk2bGRlRTNKSDNLdy9y?=
 =?utf-8?B?OHRQVU4xZlJoVnllOHZ1TTZCKzNCVkkrcEZuOHZRMnV5UGQvZERCRVJ4NlE1?=
 =?utf-8?B?UWw1UUtURUdxN3Z4UUZLb29mb29hMTRlckIrL3YrR1Uyb0J6UFFwM04wdHhz?=
 =?utf-8?B?eVVJN20wYnpSVGwrRUxHTzVDZnUvbUdXbUhXKzBOSDZEeFQyTG1qT0Y3a3I4?=
 =?utf-8?B?WUthMi9FZHhxSk4rUWpFTFRYKy9zK2d6eDdUSmt0T1M2bDFPS01nNWZhRGgy?=
 =?utf-8?B?bXR1Q3lQRTYydjRER1RWOTl1cjZCWFQwMWNVV3BKNUFoakQ1U2luVm5Bd2Jz?=
 =?utf-8?B?QVFTRmZseGswVktyVUhOZGh0Z1RkZ1Jkak14VVprUGdZajd5dHNKc1AwUUZj?=
 =?utf-8?B?Vk9DYXQvTWh4L2liVllpdEN5MDB2ZzdSaGpKM1pmaDgyYlk1cHdmMmhDbFNh?=
 =?utf-8?B?SFNFYmZuZ0psYW9QT1pZYjhVcTRJWEJDZnBqOU55dGIwSFIxSGJHL2ZuQ3o2?=
 =?utf-8?B?cnhXMXdocmowMUdBdnp1Z1d0STQxbGhybE5PdmVHZVNBYTJVNzVhakdKTk5a?=
 =?utf-8?B?NzJGc2JmYldRSlRNMEhOUU80ckxJMDRsNmZEakFBU0w5cHVCZFBWNGdHUE52?=
 =?utf-8?B?NytVSThPazRhaG9kNHVQRE9sN1pUbnlxbER3ZHJrc1laczVJS1phOVlJb1hi?=
 =?utf-8?B?MkltSG80UjV4UzVpd05lRXB4cjh1RldBSzNsQUpyaXdualUvMFZGVDMyWlJ3?=
 =?utf-8?B?ZittKzlaakJ4TlBXVTdSenpBR1AvMU5kNU03T0lXM1BDQ3J4dURtc1dITmxX?=
 =?utf-8?B?M0x0Q3p3aVRITHp1WlZ6dGtWc3dWUjhvVzUrZUlwamtCQmdCeW5aRDZNSmdZ?=
 =?utf-8?B?QVRaREZrU3lML2F5QTl1LzJyZmVuU3lyNzhCU2hmQU1FdkFzQ1Z1bHFKeExk?=
 =?utf-8?B?b2xwL1FqZURWYmF5cUJrWUNwZXkwYmo0L3NxQVF6aVViaWZVcjBTMHErdUdF?=
 =?utf-8?B?UXN4c2t5Q0FleVFsUjJ0MnRlcnc5bXdXZ2MzZGNxTHVsb2JzS0c5UDcrODVo?=
 =?utf-8?B?RUlOOWVMMzBSSzVnQWJyUFltVld5eXFDdDJqekMzbnJsWjQwQkowT2lNRVZK?=
 =?utf-8?Q?Gg/JxfDT2YkNn6PFZmZdrs4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e93a015-02ea-4b50-97a5-08db1bd8553d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 11:13:36.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O+vH+Nx5R7jT97RF6MsbVOzeEE2DryHaicMuEfOodhoSmzdtX387Kl6w+fjkMYSPRGtkg4CrQKPz/SNmGfjKTCpI8jaFu0MFi9MXH2JXJus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6057
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Oros <poros@redhat.com>
Date: Wed,  1 Mar 2023 21:47:07 +0100

> ice_get_module_eeprom() is broken since commit e9c9692c8a81 ("ice:
> Reimplement module reads used by ethtool") In this refactor,
> ice_get_module_eeprom() reads the eeprom in blocks of size 8.
> But the condition that should protect the buffer overflow
> ignores the last block. The last block always contains zeros.

[...]

> Fixes: e9c9692c8a81 ("ice: Reimplement module reads used by ethtool")
> Signed-off-by: Petr Oros <poros@redhat.com>

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

> ---
> v2: memcpy unified calls
> v3: copy_len is now declared in if scope
>     unwrapped line before memcpy
[...]

Thanks,
Olek
