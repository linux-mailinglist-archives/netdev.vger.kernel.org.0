Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D594FE66B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357902AbiDLRBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357900AbiDLRBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:01:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC8718E3F;
        Tue, 12 Apr 2022 09:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649782770; x=1681318770;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IHxSViZmANBxulkb0Jy+0k4kIK2djGUICDcrjB6ncBs=;
  b=PUAHFGfQGhUwX14Ed4K7lvCzOdGgas9sl/5ry27Gl5m/kK4F6pVmnsbK
   41Uzj0TkK7k/D0nYchukYzWfhF3DjbsSqQUhWbBfpUPR64s72UcAYo5ua
   z/eILQgn6iSFIJFPShNZ3KuAalbF17h+9lRYmCbHYpZsNMkCYhxcbU3BN
   ts7IcYrmqx7jj2Hlv82W9oBIujkjKSKQWvwGbcohwEVbxiGitAzcbV5A0
   Lv27YKKjxwPKk7Afo4M1/Hqr6HIrecmqhyCZlGk6eE41grrN3w9oW1jec
   /Cg0ah4I9H3HD1Zb3inkJp3XTyOcJ5y/VpwcL+M/Vfb9x6oWvjkswI6Ft
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262620054"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="262620054"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 09:59:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="507628347"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 12 Apr 2022 09:59:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Apr 2022 09:59:01 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Apr 2022 09:59:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Apr 2022 09:59:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Apr 2022 09:59:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/ROrIZu4SAU+O8/lgggLFoilZgn+mp8bxZ6FLvqCnuCZ3O4Z4zTOWqfGQMfIR2pyYmDzf0FWR8rhLHiaQgHjwV+sWMAN0onazejRRcI4nVnYmJIxBqD8XPtA3/vIBjerAb+brkRgQnoHcNFjxQf/od1pJXhOEMsgukdgkKRXQmV+MHor8V6rbKYb8j9u1/33pjnFxYv+Iggh+jDrl929eP9mb2eT/zoqVIQ3yyEcuVuEec/EJKS4qV8vgs3hOWQIezrWhF1UVKreWl38BUoJwJ0yHVRuNQgan+/vvp1xi/RxgmnWpH+8HbA2ulSKdjRBPdl32/1POkEu10LFIr5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvXHiyS9/TrH8tDmbkrSTlFUVAoNmWPfxBUj/5h4cXg=;
 b=H3Gb8/u3NV7Uq0eqh48O0HqNKy52on+L+skiioSDQEjmKnXEKuc3aQLW6GcGYGfGe6ptBPQW6bXKBDwz9RqnV21pGYkPktDgN+lXA0Su4jckYf/YvTsO+sWZWFOtID7Y1hlu6XQIHHfZheonC8yM+l0FscsMOlz9Wr21fGevpBWRg+maa1xlOO7KcWAMNWrUrpY5loZtv5znZxFEfDOThBp8XINFj0jLf0qXhv3HqpMAYq/A//zKk0iW4zh96o3xBuOY/Pr/okYSYA0uMbAVOFeLKL3AaK3tiz6VUYmklMxBgeqPPBTIZuTDq1p4gyQ/wEt34QaqYf8dAwLgb0zYzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BY5PR11MB3944.namprd11.prod.outlook.com (2603:10b6:a03:18e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 16:58:58 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::815d:8ff7:538c:b10e]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::815d:8ff7:538c:b10e%9]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 16:58:58 +0000
Message-ID: <092c941b-a057-5cf0-97d8-0c061768dae7@intel.com>
Date:   Tue, 12 Apr 2022 09:58:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] ice: wait for EMP reset after firmware flash
Content-Language: en-US
To:     Petr Oros <poros@redhat.com>, <netdev@vger.kernel.org>
CC:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <ivecera@redhat.com>
References: <20220412102753.670867-1-poros@redhat.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20220412102753.670867-1-poros@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0006.prod.exchangelabs.com (2603:10b6:a02:80::19)
 To CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34eb4cde-59d0-4c44-1f17-08da1ca5bc5d
X-MS-TrafficTypeDiagnostic: BY5PR11MB3944:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BY5PR11MB39443617112CFF7CE23DE2FDD6ED9@BY5PR11MB3944.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBlv9TmeKbYikvOg3UWTXyL1jOeqhsZpK3aBV6/+7wTqAVcUvfhlqkN7W8WSoEaQ6yRL3Th3a/KG41LzMQaPtucbPedgdM6XRfnrk5vjmhWM4y8RAasAX2hleBujbnzSd7tsm5g3tqU5nfMXn2NBLFyGYOVClSb/T4/WpJAS9iWJjungnf3UuxgmioieASCJeLwmCWBaHryk9AFAkFgpDH/UycxZeXJHkbCelYCUt2syXoI9ST4rmTGqmm3SZBy3Ij9Eb4fPJZ/B2s0OuZ2pu5xdh5k02FeR0na5ZAc5kaqgsnho1AERCY4/5q0J38Slc869AE88jfsLS5NgIOUSUt1SXBbNTkZv8OIBGb6+4P4DLU02HEv7c1bD5fqufLd0JR5JN0JR/BRbhE5xTtpu9WKvX9VyZoVO2KItCn0hTIINK3oDYdGgCXgDA2vOB8OjpYHMzG+5iRQeuu+I5eWCoqD76pG+KZHQKK4/tS9TE6Zya5FUTnsDDzKTrnPiBaiqnXx5jQAtmadoOTbbirzi6o/omTjJZ1sM1GFmw9YGZoX91ZqCpB4WfJ8WcTC94bB0N/2SndzWx0unP3v0uVZTNfQazIF+R5iNJi70utZwWkX82dCW2a04LM1XzhwUapz1LX+KEKVy7lrsWWdCA2fBdraCJoYUCxQ/aAoxIi7UQ9F7xu6NyJOpQeT0y+4b7MX5uOzdVRggCA+sK7p0sossHYTRKDC1gAd6rl72ow3Q6Rk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(38100700002)(36756003)(31696002)(66476007)(4326008)(66946007)(66556008)(8676002)(5660300002)(6666004)(6512007)(6506007)(26005)(186003)(316002)(6486002)(31686004)(53546011)(2616005)(83380400001)(86362001)(2906002)(8936002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDNkTHhWTVRjdWlmb2RmZlZxRFdGNVVpaGlmRFBzMjFFWXBsY1VTQk9GblV2?=
 =?utf-8?B?SlZwTHc3WjlPMWk0R1NWUkJ1WDF0c0oreEJJRE83Uko0OG56d1hLN2xSd1py?=
 =?utf-8?B?cjhhd3ZOcS9YNFlEaFlKcjdkZFZ0NWtyb3d2eEpQMHI2Mzdnd2NFcTF6V1Nr?=
 =?utf-8?B?cmJQYVZPYTUrOGN5akZVTWNMbGR4MldYYkl3bEtUMm1BSzdYdnUyaGQwdFMr?=
 =?utf-8?B?ejc2VVROMnpkZkJ0M1VxRGpDNEFxWnRVS3gyeHcrR2wwMitIQXRVcGtYTU5r?=
 =?utf-8?B?eVFTVG52T1ZvcUlXdlFuMGdFZ3BCUEJNempMdVNhaTArMkR6TWE0QzdkOTYz?=
 =?utf-8?B?bUd2akxIdFdrQ1lIV0loRkhRUnhWV2F6VHBFeXA1R3drZFU1dUtJeUlramtW?=
 =?utf-8?B?ekhkVEptYWx1YTQ0M2ZnNDhONWp5NmdtZnFBVzY0b25rM2N1WTcyOWdCOExz?=
 =?utf-8?B?aUFlS1ZrSkkyUkFqOGI2R0pQQTNyelVndHk0M0t0dENDNERxR0dKTHJjY1lL?=
 =?utf-8?B?YnppdVkvYTVhL1FRWmViMXRjQ0dubmdudFJsWlJaZ3RyN05MWXpGUDEyZktt?=
 =?utf-8?B?ZzIyRnRENUd1b3VybWtRWFNQWW1ZVmlnZ3MzaiszN2djekEybWhVUlVYT1dj?=
 =?utf-8?B?YUc5RXdEVFpPbFArZitMTFkrZFpKV05SUTRTaU1DYmFpQjA5QUw0RHo3cXVp?=
 =?utf-8?B?dGtxczNDZ0g4dm84RnVPY3FFOHk5WEo0SHhoS1ZzRXUrRXl3L1FjU1N4a1Bq?=
 =?utf-8?B?aE4wMVVrUy9rUlFheGRxOU9SK3FnUWpINXNYWkh6cGMvYkJRenpXQXVBZEpX?=
 =?utf-8?B?b216T2NaVmM1aWNFaVJMTG5sb21QZDZkazRHZTNvYmRaV2dSZnVpTE5ZMEFE?=
 =?utf-8?B?ZVNvcnJlczNFUDB5TFdmZzlDSGFMajREWmdrbVZSMUxoQ2JFaVMxNC9wQTlV?=
 =?utf-8?B?alpsMmRoaUE1V0VNTDkrYTBHSVdSMUhudmkrRjA3VVhwNUVyeVcwdjEwSkpO?=
 =?utf-8?B?QWU2dk0rRkFNVHAwLzJBWUczd3ZDOWhJcGxiaTBkVVkrZ0gzaGZuZ0V6N2to?=
 =?utf-8?B?NEYreE9WRzZ0Z3dFaEFZU3Uzai9pVW9HQjVKN0I0Z1FSUHR0UHRtTGRMcVR6?=
 =?utf-8?B?eURJdW0vMUM3UHRFTTE4Ly91K1RBeWRmNGI1Unl3WFNjTWNBMmdIRm93aDh2?=
 =?utf-8?B?TUI5SndxNlVqTWM5K2V5T1E4YjFzZnh0aW95ZWFZWHV2ZVZEMzAvdHhRSmI4?=
 =?utf-8?B?ZGg2c3dPdFd6cEtLbHdFNDBVRFE5ZkFmTjBoZkNUamVpaXExK3J4cUhYNUd6?=
 =?utf-8?B?L3I5OWgra2V5c2plM3RXdS9VUXl6bW94ci9hWEYwWGsyWFkrYTJIdlRDYS9q?=
 =?utf-8?B?cDNpVEs1elg1WU0yMkV4bnB2MGJpZFoxTW9EWnhBWGdWa0p6NnFuWlVSRnly?=
 =?utf-8?B?bnVLVkVxZmRDVk5TSG1EazFZUnkzRTNPR2g1WUkwd2J4YTBvUGh0Qi9HUkF2?=
 =?utf-8?B?Q2F6RnBoYlBDM1ZyM1RZb0ZsR3FiUkNJZndzQXVpcjBzRXhNUDBQSHl0V0Ew?=
 =?utf-8?B?UUZ0dnpJQkVZUWk4VUMxVDZCMGExazhleUhFSnFoMnNnZnZINXZIaG56YjBj?=
 =?utf-8?B?ZmQ0UjhLM0czT2xUT0dTcE9aREkxRm56SVVjSXhOUkIyTTVZanQ4cXdreHdu?=
 =?utf-8?B?bUF6dlU0Vmw2VER4cU1FTU93bEVnNy9HaUZWOGRveU4waGs3amJiREtmSlpp?=
 =?utf-8?B?S1dSc3RwcHpjSVBrMWJBQ3kzL3JRQ1ZWQlBnTTlrT2cyK1JvdXlhckt3eERz?=
 =?utf-8?B?VS8xQk9zY2dMQSsyM2xiT1Nnb0YxdEtXQnJRNE9oUU50V2FvdWljYXVTNEty?=
 =?utf-8?B?SFFlbzdocG1iZ2s3MTVMUTAzR1lCU0hOZEdBVXlzTWQzb3g3UmdSZkVDVWZF?=
 =?utf-8?B?OVpHdVRVVzdxV1pqQjU2VW9XWFJxc01wSEdNTFN1ZkVVbGhSazFpcy9Qb1Fo?=
 =?utf-8?B?N2xWSXBXdkx6OEJUZ3NBY0dLZ2tWRk05UTlZbUJBekdUN3F6R1Jod2hrYzUw?=
 =?utf-8?B?TUVTeCtORjc4dWl4OHpJZjkvMnV0Y1RVMFpBT2QwZE9RK1d5T2dLdXludXBD?=
 =?utf-8?B?Ry9zaWNFY0k3dkxzOFUvTVVTRWxqQ3MwejYwdHVGK1VrOFNVL0NGempWTHNG?=
 =?utf-8?B?YXBhWFJHalErZEwxazhYODRwenFNaU5qVDNxdnR1b3BvWU1VaS9FazBkM3hq?=
 =?utf-8?B?M21mZ1liV1hIMjg2dGtaeVY1TTlBcnFJbEM1ZVJ0VjgrTkM0YUp2VzB2d051?=
 =?utf-8?B?TWZQMzlzTzZqSW50WktpbmhIN2hsQjN2N0Fxby9OQ0U4Ty9EL0F2SEIraGxH?=
 =?utf-8?Q?HLPdJz8+izaltf+4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34eb4cde-59d0-4c44-1f17-08da1ca5bc5d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 16:58:58.3778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZoO77CF+qLsXK6ieksNsUwE+0wQL6WJmiqndCheb+rLdEF93YhSBFwrZudv8/dYlnXBNCfIYfx4Q9BbIrsY8DTELnoT61pZM1LKjTDyyz9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3944
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2022 3:27 AM, Petr Oros wrote:
> We need to wait for EMP reset after firmware flash.
> Code was extracted from OOT driver and without this wait fw_activate let
> card in inconsistent state recoverable only by second flash/activate
> 
> Reproducer:
> [root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
> Preparing to flash
> [fw.mgmt] Erasing
> [fw.mgmt] Erasing done
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flashing done 100%
> [fw.undi] Erasing
> [fw.undi] Erasing done
> [fw.undi] Flashing 100%
> [fw.undi] Flashing done 100%
> [fw.netlist] Erasing
> [fw.netlist] Erasing done
> [fw.netlist] Flashing 100%
> [fw.netlist] Flashing done 100%
> Activate new firmware by devlink reload
> [root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
> reload_actions_performed:
>     fw_activate
> [root@host ~]# ip link show ens7f0
> 71: ens7f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
>     link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
>     altname enp202s0f0
> 
> dmesg after flash:
> [   55.120788] ice: Copyright (c) 2018, Intel Corporation.
> [   55.274734] ice 0000:ca:00.0: Get PHY capabilities failed status = -5, continuing anyway
> [   55.569797] ice 0000:ca:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.28.0
> [   55.603629] ice 0000:ca:00.0: Get PHY capability failed.
> [   55.608951] ice 0000:ca:00.0: ice_init_nvm_phy_type failed: -5
> [   55.647348] ice 0000:ca:00.0: PTP init successful
> [   55.675536] ice 0000:ca:00.0: DCB is enabled in the hardware, max number of TCs supported on this port are 8
> [   55.685365] ice 0000:ca:00.0: FW LLDP is disabled, DCBx/LLDP in SW mode.
> [   55.692179] ice 0000:ca:00.0: Commit DCB Configuration to the hardware
> [   55.701382] ice 0000:ca:00.0: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:c9:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
> Reboot don't help, only second flash/activate with OOT or patched driver put card back in consistent state
> 
> After patch:
> [root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
> Preparing to flash
> [fw.mgmt] Erasing
> [fw.mgmt] Erasing done
> [fw.mgmt] Flashing 100%
> [fw.mgmt] Flashing done 100%
> [fw.undi] Erasing
> [fw.undi] Erasing done
> [fw.undi] Flashing 100%
> [fw.undi] Flashing done 100%
> [fw.netlist] Erasing
> [fw.netlist] Erasing done
> [fw.netlist] Flashing 100%
> [fw.netlist] Flashing done 100%
> Activate new firmware by devlink reload
> [root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
> reload_actions_performed:
>     fw_activate
> [root@host ~]# ip link show ens7f0
> 19: ens7f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
>     altname enp202s0f0
> 

Ahh.. good find. I checked a bunch of places, but didn't check here for
differences. :(

For what its worth, I checked the source history of the out-of-tree
driver this came from. It appears to be a workaround added for fixing a
similar issue.

I haven't been able to dig up the full details yet. It appeares to be a
collision with firmware finalizing recovery after the EMP reset.

Still trying to dig for any more information I can find.

> Fixes: 399e27dbbd9e94 ("ice: support immediate firmware activation via devlink reload")
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index d768925785ca79..90ea2203cdc763 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -6931,12 +6931,15 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
>  
>  	dev_dbg(dev, "rebuilding PF after reset_type=%d\n", reset_type);
>  
> +#define ICE_EMP_RESET_SLEEP 5000
>  	if (reset_type == ICE_RESET_EMPR) {
>  		/* If an EMP reset has occurred, any previously pending flash
>  		 * update will have completed. We no longer know whether or
>  		 * not the NVM update EMP reset is restricted.
>  		 */
>  		pf->fw_emp_reset_disabled = false;
> +
> +		msleep(ICE_EMP_RESET_SLEEP);
>  	}
>  
>  	err = ice_init_all_ctrlq(hw);
