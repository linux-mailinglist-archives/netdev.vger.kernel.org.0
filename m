Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E316742BB
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjASTZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjASTZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:25:19 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CC4485B6;
        Thu, 19 Jan 2023 11:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674156316; x=1705692316;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xg6Z6grL6hfmjFVEfl2Vwj4vd4sc8QwfvqinASTX//0=;
  b=mDr6GYEZXLhXFTJKjzc/SPqN+rKaM2gnSuSvuMWgqpPFvsWCpFZDGLn0
   9xiL3P3dhOkaw3PbO5SkvGPXxG9dz3nx6u1h7/x/WBHJ5evSHxlfys54g
   UVjn/YHYfgnJcOnYpnKt17Nfh1Wa57emgfkmgUelf84fd2MN1XjM2eoi7
   Bbq49tGExzcgErYHCb3M+/xuvrZQyj2I5NApdIc+CExuNy8b3YxI9Iydd
   ZEVfJm1GS/ywHszJY9CO3e2Y7HKfCNLyEd8aiJC5Tw/+QeXTSIk5D0SXV
   sB1WUrz5CtcR9m0XmRJZl2+z35tzaUjdSvSSjp0Eugsn2gZwKRsh3VMU5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="313286187"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="313286187"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 11:25:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="768354360"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="768354360"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 11:25:05 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 11:25:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 11:25:05 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 11:25:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuEi4l2eIwj+aGn63QbmFlESsyv76cT7keb22StA+NGi/+3BN28p3LDRRIQZgkQg604eBTqp8+GJpR7ufjoctxQ1pyxgF3jj0tx9XflEy5gH2DDoss3IH0nCrx6SptNhP8JZOaos3s+X9qi3RBAhCJFY1uDbPRZs6IKt0hpbVyUMC2SjNt1qXgVxAQH9l2c864MifLYDoZOraVqa894DsKOZtQ5ieFeiS8t+TMSdRAAWqnsOMBUd4cthw+hph0NOf+mwQoo9X9qLqcik1sHyigVpxz0dqkT6jHy5EvVXNeZH946tZGMx9WRTSCSfODFemYZTnF7P2OeODHeQNWSFfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcTb23CYQ/mRE5eRuTgt2B1RkxSt8yv+sMGWYBLqV2s=;
 b=cChBoHMvvGr50N2cTpKoF2Vk69CEwNfpGrJa91vuWgBEaMYwrssgEv0icwKORp/TOi/1MYz1pYPgI9lca31VPhhY8G9QVcqyS/mfZ+okBs/zlqvdaKCdtg441SjojmvJ1KbqRI/VhNQNaPm2PREFaKu02VNBM+9mCXAInCPe/c/bzwiDHJEmQEofnT3oqDnaC8DQ9snbRY0V9RroMSWXB8KLC/C/wMWiL92tW49rvJaV3WScOkvwyEBbhHcCmJJd55GTVA/r4PtQfcWnUP6Fg8V0E6KB+ZBtMiI2j8bFwxCDmFaXMQLfkTkV0+VPkXIbOROqyKA1VpeLIeBdiwqnCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 19:25:02 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 19:25:02 +0000
Message-ID: <423a29e2-886d-2c41-16d4-a8fca5537c2e@intel.com>
Date:   Thu, 19 Jan 2023 11:24:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH] ice/ptp: fix the PTP worker retrying
 indefinitely if the link went down
Content-Language: en-US
To:     Daniel Vacek <neelx@redhat.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        Siddaraju <siddaraju.dh@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <linux-kernel@vger.kernel.org>
References: <20230117181533.2350335-1-neelx@redhat.com>
 <2bdeb975-6d45-67bb-3017-f19df62fe7af@intel.com>
 <CACjP9X-hKf8g2UqitV8_G7WQW7u6Js5EsCNutsAMA4WD7YYSwA@mail.gmail.com>
 <42e74619-f2d0-1079-28b1-61e9e17ae953@intel.com>
 <CACjP9X8SHZAd_+HSLJCxYxSRQuRmq3r48id13r17n2ehrec2YQ@mail.gmail.com>
 <820cf397-a99e-44d4-cf9e-3ad6876e4d06@intel.com>
 <CACjP9X_v9AFVNRgz2a-qJce+ZqR0TzRzyd4gPFufESoRXmCdJQ@mail.gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <CACjP9X_v9AFVNRgz2a-qJce+ZqR0TzRzyd4gPFufESoRXmCdJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: fa04be6c-271f-4ec2-ea79-08dafa52dcc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KlgE4qA9TdQ2hS3kteQ15zIVjZqOf7MT4uagkTrdNqS6TykdmY+bOK0ocQ9Yl9ptDSso8WFTgBh/RKk1pI/7KyfZk+ZC2GX0Kv9MoqrP2gNQJj2xqJGBj+CptT6bGL9vtqzjM2/xPHt+ieLcgvO+mkQ+8JaD40Z3mJX9iEYhfm/N9Gag5sK51y+j2ti7rFZZHoMiCQxy/XJRO9FgYDHFSOUhkwNPAR71g1ng/QhnyEuJvtuMaVS9zv4XV1SC6gu2IVGVjIg4RznukNCJ8tqjEMpvIVMkC9/z7zISmhtIY1Y7PEH0FyGL2fYNxBqH8UoM4FzL/cIIa2NVgjhf5Hat1s21LDwZZK4lsulmcxAdlEMooce3kl0u7RBB5Cjnm/PX6bp1nzRlTfTTpylj2HjpjuETR8F/ojo5M32Ik3Uj5zHN+o6D5S04qoxY6OqHFaMa763/5EzPWKQmyKikhVngDENctYo9veTOxC91YJOVsbgKV4deeOElU1zsjhcc2TRawEP3o4xekq4KuNFN3kUfH4J9m1+qfUAzd1hSpSX4xH2xlA/tHXKCF963yGytlktMWPjH8k/m0diEAfl3tMMGKvq7N3sIMr9HeC5CXibIC+eCmAjHvpYuHA/P/K7ZiZW3tJqzn9SE8A1+tEPVoScwUzSrCp/sfn3wE6f78VVpwmRqzyhUdwzjQrRPRJH5NihblQj9aLuJyjcghlAVNxIefv4jL3V0x2HDj1LiIhKuDKQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199015)(6486002)(5660300002)(31696002)(6666004)(8936002)(86362001)(36756003)(316002)(82960400001)(66556008)(478600001)(66476007)(6506007)(8676002)(66946007)(4326008)(6916009)(38100700002)(54906003)(53546011)(31686004)(2906002)(41300700001)(83380400001)(2616005)(6512007)(186003)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVpESVo5Tk55K2RNZDcvdnFBUVlZd1pIZ1h6TzY0V1k0MmhtemNFYlh6NWxa?=
 =?utf-8?B?b3FwWDViWlBIdC9ZWTQwVWxXOG95eGVtL2phZ1R6ZmFmT2xqOGtOQ0c0ZitS?=
 =?utf-8?B?VWRwVUErcm9JUzVGRVlmNXZLQ0o1bnl6dHNHVnpsSkUyOWV6NzV2dW9IQzBD?=
 =?utf-8?B?d2grSkRpUFhZR1FHQnZ2eEZaajJqbTJCcCtROUp3ajc0RjFKUVFLTUZ5Rkp5?=
 =?utf-8?B?eXdBZVdPb3RJUGdLTzJ1dFB6anJTbEtzR1FJaEcrc1Bxc0Z5bUV0M2JoVXRW?=
 =?utf-8?B?M2ZxWjhndGNkbGRLVVRZdkVBMEtoRnlpbmt3MVROMy9UbjIwcXlVM2c2bVB0?=
 =?utf-8?B?TjZWaENJR1lHeWVNSmVoZkNDMU84aExaZFpJMlh2UStzL3hhRjNkY01weGs1?=
 =?utf-8?B?U3FtUmJ5Q2FvRFc5c2hyUXhITENRVWF4VDM3RmNYZTUxeHFZUEZZUnhsWHM3?=
 =?utf-8?B?QUNKcE9zd0hXZ0l0akpuTG5LcjRycy9MYjlmd2J5VWRhOGF5L2ltUkh0ODcr?=
 =?utf-8?B?UzZWYTdqckhQb1d3ZTlMZk54ejArWnF4MVYrckZXa1NuQURTV05kZndWaGhy?=
 =?utf-8?B?dzJrWCs0S2UwMXN5RG9iblUvU0hYVThNODlOYnR0eTlzR3M3amRRdlJhZkJo?=
 =?utf-8?B?clc5b3hnYXVvZ0VYdFZZdGxLRFlzekRVNmE3eklOdkNPdVV2b293MVdoT2Na?=
 =?utf-8?B?SGR6ZXV6Ukd0TllFSXRlTmt2cEErdVRqdCt1UXBjb1Zqa2ZCUVNHRjVBdGdp?=
 =?utf-8?B?MjFYUXlXS1g4b09xcHA0N2JDQkRmc1h4d0hoTXJsYVkwK0p4ZXAwWjhsdnhP?=
 =?utf-8?B?S1ZBVVBIS2VvL1JTOUxHTXJIWnNRYmQzc1RNa3VrRmsxOGxpMkRQQUR0ODR5?=
 =?utf-8?B?TUNuVkd5VFljMlpzM2g1UTRTN1BreldMSVlmVHFjdGYvMms0NVh0UTNxZ3Ax?=
 =?utf-8?B?bmV3cFZ0M1FJdVM5cTl1QzMxZnVhVU00VGMrUmZzTElHdkdaRmNRaEgzVHd5?=
 =?utf-8?B?Nnk0M3lKQjAwTnV1ejgzSlJBeWFBd0wybjhPL012akI1U1drSHcrMVJ3UW5R?=
 =?utf-8?B?RldwRXFnTUxGV012TG8vT0dTNWFnSHNURXdzcDl1czNMdCtwSzV5ejk0MDFC?=
 =?utf-8?B?TjZURERWQU1WSVMrb1hmNDBpNk0yaVRtbnJFVnkxRE43R0RsWU5ocHR6Vm9Y?=
 =?utf-8?B?Y3ZENGpQNEkra0U1VGhSdXdzbk15S2NORXVob0dJdURZeWZ2bnY3TjlIbFcy?=
 =?utf-8?B?YVRIZEQrUlhlUzVBaVZCaFE5THg5MWM1L0ZYUE5Zb29wQ2FqSVJmNzFyK25L?=
 =?utf-8?B?WG9QS0VWZUpOWGQ1Q0FMZUxYNzVvOGhXOWlLQU5lTzVyMVFvS01LL3p2dHg2?=
 =?utf-8?B?N1JlRFJaaE54YVA0S2pVQVZVdW9KeTlWbENISCtURkxTWW1jSjdnOEZaTjJn?=
 =?utf-8?B?VzI1THdCOXZLc3RvRkNVMjE0WGhPV2dtREhTVXB2dmgxZkF3bzRMTU14V21p?=
 =?utf-8?B?Y0pUYWVDTUJQS0IvTW5EbXFEMkVLbEhpTXZubkZxaHNyZWtDOWJRVVJsYm14?=
 =?utf-8?B?cHVlcjZXcEUrNEh4VU80d3ZpZVNRdklpWS96dzdvZ3h0VXExSTQveFp1dDcz?=
 =?utf-8?B?c3J4ZWZDNnRwaSsyLzZOcDkzUzZ5MnZ0K2N0TVZ0Y09XOU5mY3pFNXFQbndV?=
 =?utf-8?B?b1dPNHVhQXZNenZaaUJOckk5cVhxRWVUVWU3c0IySkJINFBaN0RuelYvdUU1?=
 =?utf-8?B?TTR3WEQ2azJzY1pvOEtJQXhjZFBPVmIzMXRLRzdraHBOcHhPKzFwNGhaL1U1?=
 =?utf-8?B?MmJock1JUHk4dWpTcHJvYjhHZ1R0RjBDd0lTbjJtaERBa3JlUnZueldWREwy?=
 =?utf-8?B?MURZVFVlTHNVdzBsRktZcmZvNkxIOGk4eGZWZllIQlA1azdTVm9DWDJEVjYy?=
 =?utf-8?B?akh6VTFWMkNndk5DUVlrWEg1ZVRiME1EY1pjWHFXd2tTZTBRZDRIa1puT3hQ?=
 =?utf-8?B?U1ZCWDNuNGxidi9lUjRiSjgvTS9wOG1YYXVoQW5yck5yNWpsN3pxUFpqNGpY?=
 =?utf-8?B?ZVFTaisrSU9ETkw1dmpva3Y3Sy9ma3RZdmh0UnJlSWM1dGs2bG1IU3V4S01B?=
 =?utf-8?B?R1dvQTJhU1A5dGVKTlR6UlY1ejRTbnNwMzc1TnlqaTRxcmwvOWdlaFdwWkNB?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa04be6c-271f-4ec2-ea79-08dafa52dcc1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:25:02.5879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fic6CLutbGa30bkYzqcnTUIJQNLNmLuEq2C0SWKs1WfVKKo+SR7P9AYVXYGpDwJVx0aoDjNDNgBZwgki9AH4dLYX8rz4OXIG71RpiMdAnz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7004
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



On 1/19/2023 1:38 AM, Daniel Vacek wrote:
> On Wed, Jan 18, 2023 at 11:22 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>> On 1/18/2023 2:11 PM, Daniel Vacek wrote:
>>> On Wed, Jan 18, 2023 at 9:59 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>>>> On 1/18/2023 7:14 AM, Daniel Vacek wrote:
>>>> 1) request tx timestamp
>>>> 2) timestamp occurs
>>>> 3) link goes down while processing
>>>
>>> I was thinking this is the case we got reported. But then again, I'm
>>> not really experienced in this field.
>>>
>>
>> I think it might be, or at least something similar to this.
>>
>> I think that can be fixed with the link check you added. I think we
>> actually have a copy of the current link status in the ice_ptp or
>> ice_ptp_tx structure which could be used instead of having to check back
>> to the other structure.
> 
> If you're talking about ptp_port->link_up that one is always false no
> matter the actual NIC link status. First I wanted to use it but
> checking all the 8 devices available in the dump data it just does not
> match the net_dev->state or the port_info->phy.link_info.link_info
> 
> crash> net_device.name,state 0xff48df6f0c553000
>   name = "ens1f1",
>   state = 0x7,    // DOWN
> crash> ice_port_info.phy.link_info.link_info 0xff48df6f05dca018
>   phy.link_info.link_info = 0xc0,    // DOWN
> crash> ice_ptp_port.port_num,link_up 0xff48df6f05dd44e0
>   port_num = 0x1
>   link_up = 0x0,    // False
> 
> crash> net_device.name,state 0xff48df6f25e3f000
>   name = "ens1f0",
>   state = 0x3,    // UP
> crash> ice_port_info.phy.link_info.link_info 0xff48df6f070a3018
>   phy.link_info.link_info = 0xe1,    // UP
> crash> ice_ptp_port.port_num,link_up 0xff48df6f063184e0
>   port_num = 0x0
>   link_up = 0x0,    // False
> 
> crash> ice_ptp_port.port_num,link_up 0xff48df6f25b844e0
>   port_num = 0x2
>   link_up = 0x0,    // False even this device is UP
> crash> ice_ptp_port.port_num,link_up 0xff48df6f140384e0
>   port_num = 0x3
>   link_up = 0x0,    // False even this device is UP
> crash> ice_ptp_port.port_num,link_up 0xff48df6f055044e0
>   port_num = 0x0
>   link_up = 0x0,    // False even this device is UP
> crash> ice_ptp_port.port_num,link_up 0xff48df6f251cc4e0
>   port_num = 0x1
>   link_up = 0x0,
> crash> ice_ptp_port.port_num,link_up 0xff48df6f33a9c4e0
>   port_num = 0x2
>   link_up = 0x0,
> crash> ice_ptp_port.port_num,link_up 0xff48df6f3bb7c4e0
>   port_num = 0x3
>   link_up = 0x0,
> 
> In other words, the ice_ptp_port.link_up is always false and cannot be
> used. That's why I had to fall back to
> hw->port_info->phy.link_info.link_info
> 

Hmm. We call ice_ptp_link_change in ice_link_event which is called from
ice_handle_link_event...

In ice_link_event, a local link_up field is set based on
phy_info->link_info.link_info & ICE_AQ_LINK_UP

What kernel are you testing on? Does it include 6b1ff5d39228 ("ice:
always call ice_ptp_link_change and make it void")?

Prior to this commit the field was only valid for E822 devices, but I
fixed that as it was used for other checks as well.

I am guessing that the Red Hat kernel you are using lacks several of
these clean ups and fixes.

For the current code in the net-next kernel I believe we can safely use
the ptp_port->link_up field.

Thanks,
Jake
