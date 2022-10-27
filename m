Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261AC60FF28
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbiJ0RQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbiJ0RQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:16:32 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A62102DFD;
        Thu, 27 Oct 2022 10:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666890987; x=1698426987;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mJyf/w8NhBu33f8BUseSEzjr0oCdwuL6kRfCcvWSJlw=;
  b=igO2eXX3YSI3uMFcZ24/DOdG7MJZDzsKOv+1iVDqE4KHSN513OXyXKka
   zIQzwG6l8vsHZJY5LI7/VHKfW1Sqta2hUAhtkTyiITgGOdWeTrAl3H2jX
   kNUPs95ddJBpZBbtB72yyMYYfVwme8MYuN/tFT937/mQayUai9Ybyag2L
   lL9L0aCsyVpqQrhB9m8isBrOJzoMghxVOM9UzSJhonJhff2ctVIXnxqmp
   GHn9KNGY4wGhXiWBiikt52Zj0FNJptzaM2BbdPIteCcAUpsDsKesGvo+g
   u9/KQfYhGeRm7ysBISsOMPh3gHjs919POikwgw+B9KNuI5fC6M+NgTdUV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="309375014"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="309375014"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 10:16:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="737772005"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="737772005"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2022 10:16:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 10:16:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 10:16:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 10:16:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QD1ihJ2MX4Pxf00Y07v7JMcV2w3FMW1CTwlQCy+RlWWhZiBCZRaA+E7S+NG30jOR+jvBdD486uodpi/0RbAFf6/x9U3pzXK1lAabfasMLbH3JafsAKlvYpGzE4jL+MmQL987piJG3XNJFO4LCa5JhO1NCoBMkxU/g8M3T7Wf5CmLv8JNNo0cOk5DHMRdCCa7MZn6/WqXnxv4YtD2aP1Yge+m084Cj8tp95J5PnnfmC1Hk9DgcmeQAy2WYr45xIgiM4MSMinn/cNPVPneEF31IiocnYnGdKpCmuQBsoAD0n1W4MGt9qOXmqFf7L5BXiieVblhiSTWTXfcuwn7ZVq+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mmA1bAZVW3972c1fllDQwAOrWZMy/E6OZyO5abB3BsY=;
 b=gckNNMV73QwtBG0D1dS8fvd2P0VtwOs3nMMEuSScWOoB+rl0VXqT/BVg0XoW0cIVfcl1qDBkk8yoloAbI7cvcAEGFmzDOofN49rZ0D45S0AWVoNrPw5pfT4VK5r37xmt2CQ3x6kKUMkYTfZKVTcgeRmoQYMzU0xCKxCXbKUH+cggSNrIVU3/Plj/HvWYn+CeLEz6tAkv95jjJJfojgAJk6qfrB/upxOqomJMuTmPg6EmfrGrNWA6cRAGVEbewCFBi2WCfB6QyCZwr232l5ffKvMSZJwpt7QqgxOkZ3LWW1qNYSgWWkdV1ZlLCAx94lMpsaRqWV4iSmLwFVRoGxuL+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM5PR11MB1899.namprd11.prod.outlook.com (2603:10b6:3:10b::14)
 by DM6PR11MB4660.namprd11.prod.outlook.com (2603:10b6:5:2ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 17:16:18 +0000
Received: from DM5PR11MB1899.namprd11.prod.outlook.com
 ([fe80::552f:d94f:b6bf:e339]) by DM5PR11MB1899.namprd11.prod.outlook.com
 ([fe80::552f:d94f:b6bf:e339%2]) with mapi id 15.20.5769.015; Thu, 27 Oct 2022
 17:16:18 +0000
Message-ID: <d675d189-2e22-aa0b-f95d-9973aa812fde@intel.com>
Date:   Thu, 27 Oct 2022 10:16:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH] cred: Do not default to init_cred in
 prepare_kernel_cred()
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC:     David Howells <dhowells@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
References: <20221026232943.never.775-kees@kernel.org>
From:   Russ Weight <russell.h.weight@intel.com>
In-Reply-To: <20221026232943.never.775-kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::29) To DM5PR11MB1899.namprd11.prod.outlook.com
 (2603:10b6:3:10b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR11MB1899:EE_|DM6PR11MB4660:EE_
X-MS-Office365-Filtering-Correlation-Id: 85ffa0d3-3a17-406b-73a2-08dab83ef5f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iNgzYmpg0NYeAJTry0qNOD7APEYFE/7Z4o5Hu+4a1Qy1U1tS3914PWY7+K9pT+vN7+RZ1TUjWKP2HroF+5PEq2PNYAr3N8JYKbZhat6ATNJs8fc4AvA0KqYQTPAvwpyu/MZT4EC9zwYIL4DcMKIPzUOXVKSlPx0MQ5mmncoEpre8zPAn7CrUozKYgz1sumk+X4iGDegUppoFMlo1HcZn1D/jeZjDvmItDRlq20V5/1M44l94MgC7sCeF5IVB+DP6zzY3A1V/FDoUAzFTcjDWJo6ru9jslLDRoPPle00A4dijQm38STHRK7NaPwCWScPGgHDuvWvgaXNzhUv7L/71u35YquwRlr8knXaaY/XbguwffOWU2c6btWkB/UFoNRTmipUpXx/Jjfskr9Q8x5ZUtQpU9BjQ3hwH6FaVz6sv0Ho539DwObgla7l+NLOg2QYVPbxfgVVgl+S1RukC9/XP+0J2PSh4al273IEqoa/d0sLFOn28St0FSocddj7GiqcpSJTgdQRYrfzPh0X4Ae77y0XCUxQYwFk4zI+lE4YwQAvLVjzaDdkazld5Tfpy79tV1bifyIBRGruMWYIi+5tZ4QRn6AydWBW34fARVYoT7VydKEwRG4oNJL4q5WnHdFp1fBW3CtRn7X0uS95tl6zSwkuXXrbw4wucWhCoPM3Zz9eEsKmDkf9hUJDZ8Y6olyJuED738OpxwCJKDtQFGCvBYNfR4572oAMOLVeuCNzTriZFboo5Wo4BkttVV/81pjL0wu/1A1ttQ+5LCuY03/VnJqH0u1lP3kDhisT7F84MxVWdB0kpbP0ZPTYrwukMHuAd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1899.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199015)(31696002)(186003)(86362001)(82960400001)(110136005)(8936002)(7416002)(38100700002)(2906002)(5660300002)(45080400002)(66556008)(8676002)(4326008)(41300700001)(6506007)(66946007)(6486002)(6666004)(2616005)(26005)(54906003)(6512007)(966005)(478600001)(83380400001)(66476007)(53546011)(36756003)(316002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cy9NMFJqenU5RW9pOWwvR0xTc2ZQQlFlYnFHek0ybVJRendXUWFab1VoMDc2?=
 =?utf-8?B?RFZWYjd4U1J2SStOYXZxc0YyNUtoRjhRVjAwbndqa2R5bGtsdHNpSU9CYnhL?=
 =?utf-8?B?eVBBZnl4Zko1RzVUOEZ5V2xIeXR1d1UxckQ1UjJUREN5eVJGaUJsa2Vta285?=
 =?utf-8?B?SnRra2QrWmFRVVErR1h3aUNxMlBEMDZ2UzEzQXA0Y2RwdWZRUGRlL0xicU96?=
 =?utf-8?B?Nk5WYTV6VmtPTWVORFJlTGZ1cVhPakNKSjlOdFdVQ2hxcEw5Qm0rdzJJa244?=
 =?utf-8?B?WEpqQ1d3N0l3cWVNc2szQjZGL3RjYUFEL2NQcHRuNVpURnZwR2hseUtqTGV5?=
 =?utf-8?B?SFZsSWRyY3k0Ry9GR0ZRVlhkNXZvb2o2MkJISHhaVWwwUkpHVGVudElXczBM?=
 =?utf-8?B?MFpUR2Z0Skd6c2tpV2RmOHJJUHpVSStvRnB4Q1lzc1g1MW1nbWw2NTNkdUhx?=
 =?utf-8?B?Q08ySm5Ddmg2VU51eXZ4RGRnUm1yTkZjOVo4M3FJNHJVNE1nWCtpNnJrdjZS?=
 =?utf-8?B?SG9FSmszbll4bHI1LzRMMUlhdGp2ajFmTko0ZjJrRDR1aGJSQms2eW9WdjhF?=
 =?utf-8?B?eHpIOVAxNzBTYXpyUkRVVXRGbFoxSXNCS2hTTEtKKzY5Y04zTkE2eW5xdWtj?=
 =?utf-8?B?ZGJPcFpPMml2MmF4OTFLK2pyd04wUDZYancraHhhczZMZTc0L3JQL3RUSmd0?=
 =?utf-8?B?aU1QSjBYUmxncDRFazJyT0FYRC85bDIxcXdQNXE1Q3YwSm9tTEpFQXZwMzdX?=
 =?utf-8?B?TXRBK2cvS3NoTiszakVnZ1g5WHA2YjRkSG15WExBNkYvRWZJVUhhZllrOHo5?=
 =?utf-8?B?bnZENVVZQVUvR1lZVE5CR3pESlgrTy9rblpQbWRKQ0RBWUJmaXIxd0cydDBz?=
 =?utf-8?B?d2V1V1kxWll5SGw4YUNPeW5EVEUxd1N4d1g0T0R1TVVod2tacSt3MFdMNEo2?=
 =?utf-8?B?ZElzUXE5eTU4K2hXSkJpL1lwajUrS1M4ZGhEbDVVSGdGclhrZEk1OGFjQTIw?=
 =?utf-8?B?R0FPRThkSXRpbHZoZS92bU5jaDFCUXlQVEVqbHFxSzAyUlFuKzJDM2JBMk1p?=
 =?utf-8?B?dzVpM0R0LzZmNzFycnhWeW9IaWIvWHNKOTNDWGpTZ3J0cXhidFlrdEVaay9k?=
 =?utf-8?B?eFl3ZG5sL1I2bnYwR281Uy83TEc4MDFXUzhZUnlRSlBlOWpPVzZrcEk5UEpS?=
 =?utf-8?B?VEh2UzFibEVCd1dZVzZZREFPbk1ET0J5NnBrSFdHOVZnWVZYbVpFK3BPWTJh?=
 =?utf-8?B?SXYzM2FnanArdThPVVg1VU1FbHN2N1h4ckZiVDNsNHRuS0s1WkVxVVhuaUpC?=
 =?utf-8?B?dnFYUS9VSjk5R29aWWF2bUpUdUNCKytvZE5hNGphV1hRZ0ZMamFhUFpyM0Q5?=
 =?utf-8?B?Y0JoQS9hbEhqOFVKSS9XZG5LLzdHNmthSFE3eklvUWVCczAzNnhkbkVrbjNH?=
 =?utf-8?B?ZjdVOFVwNWRaS2I4UU9CVmpZaUUyYS90dlo4RWpDM3hoWEhlUGhLRW9hd0JY?=
 =?utf-8?B?M3lvRWJnbnk0cGRrQVMyWFRIR3lRUE1tQkxxMmc1alJleEc1TUxsbzBlamlq?=
 =?utf-8?B?L0JyVE94dkR2UEhaMUYwaW5DQXQ0c3RvMFMwV0FGVkNhQkxyM0V2eTUra3dL?=
 =?utf-8?B?cVd4cllhMDlNWUJmZGIvWXdPSFgyWVVZTCtId0ZGZWJ5M1M4WFNSVFQyTnQx?=
 =?utf-8?B?QmdUMmVhZ0pBMkdRL2hvaXQ0NURDdk9HanlacTUvS1VZNDFBVUF5ditHc2k4?=
 =?utf-8?B?THVyZmtHbFE3RkN4S1FOZDN6c0llYkJmWUl6d0NTakMwSEgrbXRSY2JxeWZr?=
 =?utf-8?B?UmkxMUlQZElCdG13Qjk2d3lvQzBXVXdsM2diMWtNQnhhMXVRSThkTmpkR1JE?=
 =?utf-8?B?NUtCUEl2dkpORUt6SFR4dmoyeGt0Vk1TZjJpVGx2VzMzWDhoeGZ3bGRoRlAx?=
 =?utf-8?B?RDQ3eU9QdHB0bG92bDdmZFlOdHZ2UHBVdmcxUmQ3SGw4eU9YYmZvYlc5M2xW?=
 =?utf-8?B?Zmw1c0NHOVRha1lHdEIvcVkyM0xaRGM4SURPU05UVzFJYUhHWTNGL3ZYbnNB?=
 =?utf-8?B?d0ZQWmNjRWorYkd2U2ZZckVSK0pUaFU1SVM2UkNQS2ZlSmU3eGZpbWFTN3gw?=
 =?utf-8?B?UzcrM3dPZzFYSzc3Q1h5dVlpOGYxQVZVQlFCdHZ3SmFCN1kyRWNibWs5QnZ1?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ffa0d3-3a17-406b-73a2-08dab83ef5f6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1899.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 17:16:18.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XLAhcqUhhpO6CD+t/9+R7ahEShUtChK2OcfPjRR315HYoOF3E6k0xNo3McOWlSi59hIE0DuqNDVsY9XNdW2cWRh0XvtJuBeiow/uBfhZM9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4660
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/22 16:31, Kees Cook wrote:
> A common exploit pattern for ROP attacks is to abuse prepare_kernel_cred()
> in order to construct escalated privileges[1]. Instead of providing a
> short-hand argument (NULL) to the "daemon" argument to indicate using
> init_cred as the base cred, require that "daemon" is always set to
> an actual task. Replace all existing callers that were passing NULL
> with &init_task.
>
> Future attacks will need to have sufficiently powerful read/write
> primitives to have found an appropriately privileged task and written it
> to the ROP stack as an argument to succeed, which is similarly difficult
> to the prior effort needed to escalate privileges before struct cred
> existed: locate the current cred and overwrite the uid member.
>
> This has the added benefit of meaning that prepare_kernel_cred() can no
> longer exceed the privileges of the init task, which may have changed from
> the original init_cred (e.g. dropping capabilities from the bounding set).
>
> [1] https://google.com/search?q=commit_creds(prepare_kernel_cred(0))
>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Russ Weight <russell.h.weight@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Steve French <sfrench@samba.org>
> Cc: Paulo Alcantara <pc@cjr.nz>
> Cc: Ronnie Sahlberg <lsahlber@redhat.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: Anna Schumaker <anna@kernel.org>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Michal Koutný" <mkoutny@suse.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Cc: linux-nfs@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/base/firmware_loader/main.c    |  2 +-
>  fs/cifs/cifs_spnego.c                  |  2 +-
>  fs/cifs/cifsacl.c                      |  2 +-
>  fs/ksmbd/smb_common.c                  |  2 +-
>  fs/nfs/flexfilelayout/flexfilelayout.c |  4 ++--
>  fs/nfs/nfs4idmap.c                     |  2 +-
>  fs/nfsd/nfs4callback.c                 |  2 +-
>  kernel/cred.c                          | 15 +++++++--------
>  net/dns_resolver/dns_key.c             |  2 +-
>  9 files changed, 16 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
> index 7c3590fd97c2..017c4cdb219e 100644
> --- a/drivers/base/firmware_loader/main.c
> +++ b/drivers/base/firmware_loader/main.c
> @@ -821,7 +821,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>  	 * called by a driver when serving an unrelated request from userland, we use
>  	 * the kernel credentials to read the file.
>  	 */
> -	kern_cred = prepare_kernel_cred(NULL);
> +	kern_cred = prepare_kernel_cred(&init_task);
>  	if (!kern_cred) {
>  		ret = -ENOMEM;
>  		goto out;
> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> index 342717bf1dc2..6f3285f1dfee 100644
> --- a/fs/cifs/cifs_spnego.c
> +++ b/fs/cifs/cifs_spnego.c
> @@ -189,7 +189,7 @@ init_cifs_spnego(void)
>  	 * spnego upcalls.
>  	 */
>  
> -	cred = prepare_kernel_cred(NULL);
> +	cred = prepare_kernel_cred(&init_task);
>  	if (!cred)
>  		return -ENOMEM;
>  
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index fa480d62f313..574de2b225ae 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -465,7 +465,7 @@ init_cifs_idmap(void)
>  	 * this is used to prevent malicious redirections from being installed
>  	 * with add_key().
>  	 */
> -	cred = prepare_kernel_cred(NULL);
> +	cred = prepare_kernel_cred(&init_task);
>  	if (!cred)
>  		return -ENOMEM;
>  
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index d96da872d70a..2a4fbbd55b91 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -623,7 +623,7 @@ int ksmbd_override_fsids(struct ksmbd_work *work)
>  	if (share->force_gid != KSMBD_SHARE_INVALID_GID)
>  		gid = share->force_gid;
>  
> -	cred = prepare_kernel_cred(NULL);
> +	cred = prepare_kernel_cred(&init_task);
>  	if (!cred)
>  		return -ENOMEM;
>  
> diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
> index 1ec79ccf89ad..7deb3cd76abe 100644
> --- a/fs/nfs/flexfilelayout/flexfilelayout.c
> +++ b/fs/nfs/flexfilelayout/flexfilelayout.c
> @@ -493,10 +493,10 @@ ff_layout_alloc_lseg(struct pnfs_layout_hdr *lh,
>  		gid = make_kgid(&init_user_ns, id);
>  
>  		if (gfp_flags & __GFP_FS)
> -			kcred = prepare_kernel_cred(NULL);
> +			kcred = prepare_kernel_cred(&init_task);
>  		else {
>  			unsigned int nofs_flags = memalloc_nofs_save();
> -			kcred = prepare_kernel_cred(NULL);
> +			kcred = prepare_kernel_cred(&init_task);
>  			memalloc_nofs_restore(nofs_flags);
>  		}
>  		rc = -ENOMEM;
> diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
> index e3fdd2f45b01..25a7c771cfd8 100644
> --- a/fs/nfs/nfs4idmap.c
> +++ b/fs/nfs/nfs4idmap.c
> @@ -203,7 +203,7 @@ int nfs_idmap_init(void)
>  	printk(KERN_NOTICE "NFS: Registering the %s key type\n",
>  		key_type_id_resolver.name);
>  
> -	cred = prepare_kernel_cred(NULL);
> +	cred = prepare_kernel_cred(&init_task);
>  	if (!cred)
>  		return -ENOMEM;
>  
> diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
> index f0e69edf5f0f..4a9e8d17e56a 100644
> --- a/fs/nfsd/nfs4callback.c
> +++ b/fs/nfsd/nfs4callback.c
> @@ -870,7 +870,7 @@ static const struct cred *get_backchannel_cred(struct nfs4_client *clp, struct r
>  	} else {
>  		struct cred *kcred;
>  
> -		kcred = prepare_kernel_cred(NULL);
> +		kcred = prepare_kernel_cred(&init_task);
>  		if (!kcred)
>  			return NULL;
>  
> diff --git a/kernel/cred.c b/kernel/cred.c
> index e10c15f51c1f..811ad654abd1 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -701,9 +701,9 @@ void __init cred_init(void)
>   * override a task's own credentials so that work can be done on behalf of that
>   * task that requires a different subjective context.
>   *
> - * @daemon is used to provide a base for the security record, but can be NULL.
> - * If @daemon is supplied, then the security data will be derived from that;
> - * otherwise they'll be set to 0 and no groups, full capabilities and no keys.
> + * @daemon is used to provide a base cred, with the security data derived from
> + * that; if this is "&init_task", they'll be set to 0, no groups, full
> + * capabilities, and no keys.
>   *
>   * The caller may change these controls afterwards if desired.
>   *
> @@ -714,17 +714,16 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
>  	const struct cred *old;
>  	struct cred *new;
>  
> +	if (WARN_ON_ONCE(!daemon))
> +		return NULL;
> +
>  	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
>  	if (!new)
>  		return NULL;
>  
>  	kdebug("prepare_kernel_cred() alloc %p", new);
>  
> -	if (daemon)
> -		old = get_task_cred(daemon);
> -	else
> -		old = get_cred(&init_cred);
> -
> +	old = get_task_cred(daemon);
>  	validate_creds(old);
>  
>  	*new = *old;
> diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
> index 3aced951d5ab..01e54b46ae0b 100644
> --- a/net/dns_resolver/dns_key.c
> +++ b/net/dns_resolver/dns_key.c
> @@ -337,7 +337,7 @@ static int __init init_dns_resolver(void)
>  	 * this is used to prevent malicious redirections from being installed
>  	 * with add_key().
>  	 */
> -	cred = prepare_kernel_cred(NULL);
> +	cred = prepare_kernel_cred(&init_task);
>  	if (!cred)
>  		return -ENOMEM;
>  
Acked-by: Russ Weight <russell.h.weight@intel.com>

- Russ
