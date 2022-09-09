Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA59E5B3591
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIIKuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiIIKth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:49:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0AE13F66;
        Fri,  9 Sep 2022 03:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662720573; x=1694256573;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uXVI5/vs/xw81zuliB5py48zOt5cg7Q0PMIyK4n3KJ8=;
  b=IFWvqPO37N1J2v7gJRqgFOIxqWm0Aj0X1pfycThi/0kKfnWWFwhd5KlC
   K+27pvzQ2CyIvm4K/Ap/LtKQIn4kMVpQPRjbCS0y6psFffnHlBn1MiRtY
   QWDHTA+odit+Nl3TiFvzRCk2OdfkZkUa+xnMsvbR9h/vifx5cZpbp3ZB1
   GC+ViBplvg/hTvwLhCGVAmBqFg9SvUiEEMIME0GfqnivQE4hIlqZRZBO2
   P4PtRaRKXu7rAoZGpvddF5WGQ+/IKw40483tC9CfmlklL3mawTe+zzjcM
   pOxipraE4XDouwQREKksoe9/3NuzHlmGDuMZTdz1cY3kfHdGQGLHWgOyZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="361404858"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="361404858"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 03:49:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="718926244"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 09 Sep 2022 03:49:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 03:49:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 9 Sep 2022 03:49:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 9 Sep 2022 03:49:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSrnf0yg4BCvrkzeoUgn0nN0t81QcsGdxyVsy3oFert1YESfQkW8GihhCfdafBxpqHRsI1mnaMB5eA22ChE1KBYhiBytG9RDLjdQ9qTB9hYVLlR/Ej363USMi9Dn0MvaULD5wWzzu2NgAfq4NYOc/rtCuUAaV51lMkynDrU5uTIDpATscr4WkH3NWa4O8KJKxR9KJA0eIxhvDmTfD1aM9hzMH0qJLUlV/MSRylxOjzYtn8V5GPv604tStFIz9zCg2r/xby0iiVjZoGBtmwFLMC7Kz6p7qkjTZolgbt/m8v49RZGul1iuuEr8vPWtsF8SFSX3XZqtNuCg7gqFvl1/pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgPuLHeGo1hgxe3Qdmui9ezz4hjnlbUumufZvvTKzfw=;
 b=T+vYkIzenpsa+tRmyYGoSytbOqh360DsIZyNYT/GFHZtGi73lvi7onyuiA4v1nPmVNh3tcI0TYMDuCtLixQ322Hxw/dPsvTeISCzfyZ2AdDkuQL1NoSaqctYIVNuzxBSrCxDVtAazB1mhWf3L8X2qiP/4/iy7/M5dDnwT54XvPZGJj8UmErQmnvP7o9q5MFjAZDZ6vLfJrjuPknlPAVPpeM2OI5Er4URHQVC4B9ISHND/R3wSiL+O7Pj0DS35+Xk3cwmD49ZrX+ri+vqjLXU+IVOGEpKmPo/K3XYo4CLHi0BmGRb3BmPYxbLU7ku5sfti1ixjojnaySaY9jTuG7uEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR11MB1251.namprd11.prod.outlook.com (2603:10b6:404:48::10)
 by IA1PR11MB6370.namprd11.prod.outlook.com (2603:10b6:208:3ae::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 9 Sep
 2022 10:49:27 +0000
Received: from BN6PR11MB1251.namprd11.prod.outlook.com
 ([fe80::e92f:412a:4527:d9fb]) by BN6PR11MB1251.namprd11.prod.outlook.com
 ([fe80::e92f:412a:4527:d9fb%3]) with mapi id 15.20.5612.016; Fri, 9 Sep 2022
 10:49:27 +0000
Message-ID: <f14c367b-fe4e-2956-b34e-8d54862a6393@intel.com>
Date:   Fri, 9 Sep 2022 11:49:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH RFCv2 bpf-next 04/18] net: create xdp_hints_common and set
 functions
Content-Language: en-US
To:     Jesper Dangaard Brouer <brouer@redhat.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <xdp-hints@xdp-project.net>,
        <larysa.zaremba@intel.com>, <memxor@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, <mtahhan@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        <dave@dtucker.co.uk>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>, <bjorn@kernel.org>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <166256552083.1434226.577215984964402996.stgit@firesoul>
From:   "Burakov, Anatoly" <anatoly.burakov@intel.com>
In-Reply-To: <166256552083.1434226.577215984964402996.stgit@firesoul>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0015.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::27) To BN6PR11MB1251.namprd11.prod.outlook.com
 (2603:10b6:404:48::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR11MB1251:EE_|IA1PR11MB6370:EE_
X-MS-Office365-Filtering-Correlation-Id: 05a3a9ca-7011-4503-9efa-08da9250f712
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XdMRzxxiMB58YlJ6fspZF4PcBAek1Epb8PfuJgcU/73tzVtHCcwYrfMdWcJwoffLSMNAhXkQfiuRxaBGV3l8aOmIBkXMKoMGx4FqMESCtbpd2NhMoz8UFlgvIEWy8SVKy2xHTIGFX+3BXVsHWCTIlurkwruN72Cd24ifWRKshE6i/aOslXsSlx4ZdR/s/BRFUyk4mpTk4bCsDaQhJaPzK7aN6YPDKQeR/M86yFXLtqJUT3FtB0jtSacxobownSX7lJYJUYTwljSfHH8E16laiOtKKlcbAPzRUAYHSIzw0/uvJjWRKAh14ZP2fiT+94th63+NrXEIS3PZLAlcPEo6VlQJnQoPALGQY4huq+S62DhFyxUeJ9UbR9nhnRtCB9rj85UloJcfsXV1aU09ZaTjQ3VfiZkUuDjfPmrDE9HC2ZDx721E6Q+87HWzDE1EaWfKw4X19e2Gmstd4isFoM0dbKw2z1h7KIwvbvcEEIDikO8luKLOpVy6isDsk+X1vU8DzXgIjd2HJCMhZ/mHx9KJhXyl6Jeh20v1u2P7vyL61dVgENGqgfenmGIa3WAu6ZQUK/N0ShpMTsWwqBVEbGmpFdRdMwIIBfGg3varaDX5u7jtGw3siXFyg7acXX/YNWzntOiUEGuvAcrLNTcMsb7Ne2PIwty36JHzcryOQVT3TbW83e9dI+3JF4aIKKmoN3h34WsemBAcecjvcrCWdYaEwlsgvRDrP1tSOyMSvQsVFktS+MlE/CrlVHVEjoR3pL0Fykdd63Im6jDga5oNoexuut4KmHXnllOTcMIcNG1t8rY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1251.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39860400002)(396003)(346002)(376002)(8936002)(66946007)(7416002)(316002)(6486002)(6666004)(66556008)(4326008)(478600001)(5660300002)(38100700002)(66476007)(41300700001)(6506007)(36756003)(31686004)(6512007)(2616005)(8676002)(2906002)(186003)(54906003)(86362001)(82960400001)(53546011)(31696002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzZUblFLS3NKNTdBdEYvOHZwdCtXOEVTUkdIRjR5aGg0bXk1Zng5elhHWmNj?=
 =?utf-8?B?RjVORXZsN1YweERtTVloUVNZWVVTelpOZVAwUlFLamE5Q0FXQm9zSmhGWWcz?=
 =?utf-8?B?REI2UzlMV0g3SVlOeHR2YmkrNXhNSU40R2dnTVUxdERGeFhjU3k4SmFCUWxC?=
 =?utf-8?B?aUF3UFZZZmFtcHcvOWwwVVNVOGl5TjV1TUYrQllQa2IvZ2JCRTc4dkJGWldt?=
 =?utf-8?B?Ukhra05pV2Q0OGJWSjhWUWVoVVNiWWtOZ1FWQUJoZWl6OWZLdjh2SWtrRHhh?=
 =?utf-8?B?RzQvSXNhSURueWJOSVJWNUhXL25WM1FUM083S2dHQjRIaEFCTmdDNzluOUMy?=
 =?utf-8?B?RXAvYjU4WHlndGhlWXhoY1AvYnhhaFVCOUlmb2pTYm1TQTlJS1o3b3VmWGtj?=
 =?utf-8?B?ZFR4YnBJdXR2ZFhwalRVV3MrU25Zam02dkJZS1RSSXBWei9XcUFZSGZSTVpP?=
 =?utf-8?B?dExGRjNqM2FIZGZKVmhIZGpIWlVZWGl1T0xUY3diSmxrWDNRbjBHODg0ZERQ?=
 =?utf-8?B?UU0wV0ZFd1FNTFVWUjJ1VmViV0dUTU1pZjUxV0trQVJZOElxS256NXBhdlZB?=
 =?utf-8?B?Mk1jS0JzVUw4M2Q1ZVdRVUw5aXovSXJlNGJ4QVgrK0J0SXUyZUtSSTB6bVZY?=
 =?utf-8?B?Q2dOYmxZc1FZTisrNnN6QytncDR1M0NVL1V3Y01oUHlTdjBGeTlEcHNOK1J2?=
 =?utf-8?B?cUNIMElYWjhDbHVLTEZjQ2NzNjcxSUk0V2J0VXlJVE04dXpNeHRqU1BjQ0JC?=
 =?utf-8?B?ZnU5OTlVVGErOUc3eGwzNUNQZGkwYm9ZVUNiZndqRUxvaGc4WXBYLzJWSnlE?=
 =?utf-8?B?Wko0alFERExoMGtDVFJyaGxKWjNZcEc1S3JnRVJXNTJxcVJjczFYZmZGSTRG?=
 =?utf-8?B?U0Y3dE1YZXhPdnd1MmxTdjBnRHhtQmlCQU1FUDZOS1Qvb2NtU2wyU3l1blY4?=
 =?utf-8?B?REhYZ01YemRsM3JveDVNQThGWGl0Y2Vsa21mODdFa29OQyt4a3BMVllyM1lL?=
 =?utf-8?B?ZXQ2UGx3Rk1raXZMN2pJeTU2cDhacjREWklmeDJCWUVJMWZmUm1jdW1hWitN?=
 =?utf-8?B?cEtiVWJiMlpiTnJVZG5TbHNYc3BtNExJZ2R4ODVRcGM0MC93OGYrS2xKT2Jr?=
 =?utf-8?B?NWZFZEFxMkYrbG01ZFVBbEM1cW9kTzVXRDRLeHB1MFd1UXRwNFZhaFFydWpT?=
 =?utf-8?B?N3VKbGhEdHJUUkpIQ1R6aEVGM2Rncnc2QVQ5bEt4UzBGb0w1Z2JKSzVpVENT?=
 =?utf-8?B?eEJEMGJFNDM3ektEL1Z1WjFHQ1RJQ2lsQ056RldHMWcybDhnRXN5dllhYXVx?=
 =?utf-8?B?UDdSUDJkQzZhZGM0REE1dDZJMXl3cklUZlJwRmVhckE3V2EyTDdiWVAzZ29Y?=
 =?utf-8?B?WndrSmRIRHBnd3hUS3h0TnlIUWdXb0pQTU9EYWNsU0h0S2RNalhJb002dm1X?=
 =?utf-8?B?cmRjVGIvS0dHRkhESE5yeGwxOWJoZHphL3JxLytFclUxWUdFLzZXV3I3Nk1G?=
 =?utf-8?B?TTlaSHhvT3UwYzRaRUtQN3ZxSjd1b0pZNisySkxxck9acis1K25WUGtUbUN2?=
 =?utf-8?B?NmpXMTR0cjI1S2Jyb3JXakJaTEs3a0NwR3VIdkdhditxbnRsSElaRS9HVE5l?=
 =?utf-8?B?ZWd0QTd0MkZjL3pmVTlOSjlTUWVjWVlmM2t5WEF3SWhZd0hZT21rWktndTRm?=
 =?utf-8?B?ZHFnYVl4THgzaDQ4SVRUa2huM2xWZEVMaGxyR01iOXJ0UXFFYjR0ZjZra3o5?=
 =?utf-8?B?V3ROT2ZtRHNKQWt3T2RwbER3Q1IxTkY4WWl3OUd5a0JuMG13S0lMQytaQzNO?=
 =?utf-8?B?Q3BnQzVTR3Rac01PL2dHV0dzMVUzcDVCZHNETTJhZ204ck9Jd2dURUpObGFU?=
 =?utf-8?B?UWU4SDllR1ppWFphKzhmR3FKS3pmS3hzSG93bmpjTFJTYVRRNlF2MlllanNq?=
 =?utf-8?B?aTA0c3d5d1Y1TnlwMk5JNlh2ay8ySWtTdm5MMWZ5K1VqVnZMMWlHdjJGRDYy?=
 =?utf-8?B?VjM4SGMyZEVTYTRnS1N2akloSHQvWGxQZlBTV1NCdWVHcWVGU1BCMzNzR1lQ?=
 =?utf-8?B?TnVQblQ2TDdMUDdWNDc2TzVObDZIVDVXejk4bXRjc0cwQ0c3QWdDNnJVeDB0?=
 =?utf-8?B?YzhaRkVvbklwUUMxenRlSitMTTNPQW1UR0ZiTjZyY1k0cWRhVkoxNDdHd0N2?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a3a9ca-7011-4503-9efa-08da9250f712
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1251.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 10:49:26.9703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aTgZgMqQ7z2a6hEBgdTYSnGJ4cvaMg/WbwmhFkpyIuEEB7oEcpkOLcrv9XmRYlGdnXskAW0JHppyguMJDgNOaxPwjor3BobpJJiSAr3LB0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6370
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07-Sep-22 4:45 PM, Jesper Dangaard Brouer wrote:
> XDP-hints via BTF are about giving drivers the ability to extend the
> common set of hardware offload hints in a flexible way.
> 
> This patch start out with defining the common set, based on what is
> used available in the SKB. Having this as a common struct in core
> vmlinux makes it easier to implement xdp_frame to SKB conversion
> routines as normal C-code, see later patches.
> 
> Drivers can redefine the layout of the entire metadata area, but are
> encouraged to use this common struct as the base, on which they can
> extend on top for their extra hardware offload hints. When doing so,
> drivers can mark the xdp_buff (and xdp_frame) with flags indicating
> this it compatible with the common struct.
> 
> Patch also provides XDP-hints driver helper functions for updating the
> common struct. Helpers gets inlined and are defined for maximum
> performance, which does require some extra care in drivers, e.g. to
> keep track of flags to reduce data dependencies, see code DOC.
> 
> Userspace and BPF-prog's MUST not consider the common struct UAPI.
> The common struct (and enum flags) are only exposed via BTF, which
> implies consumers must read and decode this BTF before using/consuming
> data layout.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/net/xdp.h |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   net/core/xdp.c    |    5 ++
>   2 files changed, 152 insertions(+)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 04c852c7a77f..ea5836ccee82 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -8,6 +8,151 @@
>   
>   #include <linux/skbuff.h> /* skb_shared_info */
>   
> +/**
> + * struct xdp_hints_common - Common XDP-hints offloads shared with netstack
> + * @btf_full_id: The modules BTF object + type ID for specific struct
> + * @vlan_tci: Hardware provided VLAN tag + proto type in @xdp_hints_flags
> + * @rx_hash32: Hardware provided RSS hash value
> + * @xdp_hints_flags: see &enum xdp_hints_flags
> + *
> + * This structure contains the most commonly used hardware offloads hints
> + * provided by NIC drivers and supported by the SKB.
> + *
> + * Driver are expected to extend this structure by include &struct
> + * xdp_hints_common as part of the drivers own specific xdp_hints struct's, but
> + * at the end-of their struct given XDP metadata area grows backwards.
> + *
> + * The member @btf_full_id is populated by driver modules to uniquely identify
> + * the BTF struct.  The high 32-bits store the modules BTF object ID and the
> + * lower 32-bit the BTF type ID within that BTF object.
> + */
> +struct xdp_hints_common {
> +	union {
> +		__wsum		csum;
> +		struct {
> +			__u16	csum_start;
> +			__u16	csum_offset;
> +		};
> +	};
> +	u16 rx_queue;
> +	u16 vlan_tci;
> +	u32 rx_hash32;
> +	u32 xdp_hints_flags;
> +	u64 btf_full_id; /* BTF object + type ID */
> +} __attribute__((aligned(4))) __attribute__((packed));

I'm assuming any Tx metadata will have to go before the Rx checksum union?

> +
> +
> +/**
> + * enum xdp_hints_flags - flags used by &struct xdp_hints_common
> + *
> + * The &enum xdp_hints_flags have reserved the first 16 bits for common flags
> + * and drivers can introduce use their own flags bits from BIT(16). For
> + * BPF-progs to find these flags (via BTF) drivers should define an enum
> + * xdp_hints_flags_driver.
> + */
> +enum xdp_hints_flags {
> +	HINT_FLAG_CSUM_TYPE_BIT0  = BIT(0),
> +	HINT_FLAG_CSUM_TYPE_BIT1  = BIT(1),
> +	HINT_FLAG_CSUM_TYPE_MASK  = 0x3,
> +
> +	HINT_FLAG_CSUM_LEVEL_BIT0 = BIT(2),
> +	HINT_FLAG_CSUM_LEVEL_BIT1 = BIT(3),
> +	HINT_FLAG_CSUM_LEVEL_MASK = 0xC,
> +	HINT_FLAG_CSUM_LEVEL_SHIFT = 2,
> +
> +	HINT_FLAG_RX_HASH_TYPE_BIT0 = BIT(4),
> +	HINT_FLAG_RX_HASH_TYPE_BIT1 = BIT(5),
> +	HINT_FLAG_RX_HASH_TYPE_MASK = 0x30,
> +	HINT_FLAG_RX_HASH_TYPE_SHIFT = 0x4,
> +
> +	HINT_FLAG_RX_QUEUE = BIT(7),
> +
> +	HINT_FLAG_VLAN_PRESENT            = BIT(8),
> +	HINT_FLAG_VLAN_PROTO_ETH_P_8021Q  = BIT(9),
> +	HINT_FLAG_VLAN_PROTO_ETH_P_8021AD = BIT(10),
> +	/* Flags from BIT(16) can be used by drivers */

If we assumed we also have Tx section, would 16 bits be enough? For a 
basic implementation of UDP checksumming, AF_XDP would need 3x16 more 
bits (to store L2/L3/L4 offsets) plus probably a flag field indicating 
presence of each. Is there any way to expand common fields in the future 
(or is it at all intended to be expandable)?

-- 
Thanks,
Anatoly
