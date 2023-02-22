Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC3969FBBA
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjBVTI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjBVTIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:08:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA5B2333D;
        Wed, 22 Feb 2023 11:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677092934; x=1708628934;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gTip+AeBoTJ774iYsriRZEY5ObBmH5FmosLyoYgsm+A=;
  b=ZyHpnxCVb56I1r7SGzO2pC/+yCfB0CEwtpq9UH+ayqE9P7vQLeZHopMy
   Zd13TGgK6iCQ5sIfHI1QR3Uc8MnRx4J71zjSWdmidi7ieJak9Mlsz946X
   3ExzAoF9t7VSeZeYxAML6EzVB/y2BJrSBFTfu483QhK8iJaoLWCigSYgV
   +huH3lI0kPdnF4NKquZIYBSt5Ag4uojC5EV6J5qNgua+OdA7MT+rRO92+
   2n4FkfHu6W/YS57Vs9xYKywumK0nlI1UDzTs5/9bJuEBxPSTQnLRsXPUe
   wgJJKTXFhPR4dvyKdHlp4pDz5ATnTCYgGNIXSr6cJYvRRbJN2NbjGQQoJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="397708719"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="397708719"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 11:08:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="1001103162"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="1001103162"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 22 Feb 2023 11:08:10 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 11:08:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 11:08:09 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 11:08:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoMjaBibufpV22IwzSuwvk2jBIF6tjJ1yz4RoU7XO+hlsNaS/+WchmD5KksLOp1VFwScgz1DqedkJ91c4GnLIrs+Zab/u63WCEBiS5mnMLsi2r5zzTrqbf4GPGCNlddraU7s13j+hqv7B8LnnlKoW3JXBeIyyHZoUjUnwnb9C5F9N/EYfwkIvFQRbzWp/1dzHXb3xJ5gffgLwjlqNBY9DWo/wmlmBWkixQ8p+s33WkPod6NGcksHpqoG+Q1UzRS/7lptyCmEft7QkoqBZ2Fl7kpe/Vwt9jichSEok8o4jfx/m7OM0f8NltJhgn+XZ8P/hnQLm4bWjrJY14f3IXmi9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5unzdr/rhi7xKWsphC4Mk0m+OYexRp648PjRgt+1oMg=;
 b=ZqOphNXei+fD4x51HFI/00JOwAzsy0dVmv89efMeVlmx7oIoxwuC5UKNkpEUlrQZ7PAEZrjZlcYAGLIoFpoVEIFtF8/wdyHVAqke+Mb3zhGI8gQCPtLQ+TUHChA15f1dtgLuGaV+Ts9Kdui43qqPWW3NefH1GBCw3CfLzIcrsKr3BmdOcPXh+YFYVYTWb4dNBoXfQLjNQAElNdqukFgotLZplb0rgjNuVI7ftNqvLdFEhKW4OJnfedGJifOBTBfIMHyQ1raqVhpE9gF5KJ4CGfHAMvLPRMPTUO9m+S0oz0JLyHSsb2NEQdZGipjFeTtWRtCN0d5uvL9yHmp6daKe5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA3PR11MB8024.namprd11.prod.outlook.com (2603:10b6:806:300::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 19:08:06 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 19:08:05 +0000
Message-ID: <d04f822b-ac63-7f45-ef4d-978876d57307@intel.com>
Date:   Wed, 22 Feb 2023 20:07:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PULL] Networking for v6.3
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pabeni@redhat.com>,
        <bpf@vger.kernel.org>, <ast@kernel.org>
References: <20230221233808.1565509-1-kuba@kernel.org>
 <CAHk-=wi_410KZqHwF-WL5U7QYxnpHHHNP-3xL=g_y89XnKc-uw@mail.gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAHk-=wi_410KZqHwF-WL5U7QYxnpHHHNP-3xL=g_y89XnKc-uw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0451.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA3PR11MB8024:EE_
X-MS-Office365-Filtering-Correlation-Id: aa37f949-57ce-4564-7971-08db150820b2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/I4Op/Z8K2wpfycK7u75hTfFav6UBI5AJVfLkbArr1HzF8nOQmyAQamq+rcA3DyuvYplDQifjZJI6NPcXlv4dZbwle6sfc0f16hC/6fQG6LHxVk4cKc41Tu/+qHZKgU7i9GiQite8a4Btxnsw02clN828RRRdEa5YU1v3VFG0ZsG0d8cfB1i1onqC4OgiGNtBYWd6sgFlYiiz41oQ57dDLcj5vTTrtAis+5shbw49IGUEsEZo2QvEpPhr3KKbjylxTT1a22D3H71h1OtGWmdhMXWOHbQCbiXTeIT2GjaD3rhPvG3HKPNTAIyvhIT/gaqrvAZt82ZNizOB6vMuc7W3xupzFBYj8Uq4HA1MtRqzT0bOVjOgNaGY3iJGRt2lEJo3nR9QwiqXBNyPBp3+pwGxvjTqab2CdO9dKZd8s1MUphe/qXkBVwXl26k3uV4/Br8Qlmdsdeuz3oPWaSmppIZbdJAbw8ev3WYg0GmhGux0VOv/BzR1z1eoFrzNQhFT7gdXMvmJqL+s3aA+v+DB2P8qArJS76qzKLBBOmYaBFSVqqvV+QYMI+utyDV0iRe2/a5cUIyshjVKEA/kJHgeqNrhX4XQwoL2Fk3Cz2KiXI6/1hrXpb/fn/2w6NomXfOZnREfI1cDAJpl0M2dVjVwTO2pESeIt4mcpSl0WbH+tfqRku2SxHy7fPY0WFuq9A3KwCuV+6pOILhzh+t8V0nLZMHmrtfJN5Z48xrF7t+OVCkWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199018)(8676002)(6486002)(8936002)(5660300002)(83380400001)(41300700001)(86362001)(53546011)(6666004)(54906003)(6506007)(2906002)(66556008)(66946007)(186003)(316002)(66476007)(6916009)(4326008)(26005)(478600001)(38100700002)(2616005)(36756003)(31696002)(82960400001)(31686004)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THhSa1JycjJNaTZkRHRWbFhTRVByNnBsRTR0bEVHaWw0d2lJSzZyeXNSUXhE?=
 =?utf-8?B?QmRJalBsZ3Q5MGhoNE4vZHNDcmdTRUFzSHRTUlRFazZUZWVTbVFzbUNZRDJT?=
 =?utf-8?B?Tk9UdmRJaG1PVnR2bmE2NW5jNnN5L0Y2eXRmSGlKVHdqSXFSd3dkREVsREsw?=
 =?utf-8?B?bnFsVUNjYnZjdUtBMUFCL29qcHZybXpaUExxVm9NWFlTVnlMVEs2LzlHRjBD?=
 =?utf-8?B?YUVDL1ppRDBFUURaczlveFY0QVNoWDBnYWUzSVhIY2RDNkxCWkJsdi9iUjhy?=
 =?utf-8?B?UzNVTUVjS1YrZUFudzAycnYxSGZvUHBqWElhR2N6THlWbC93Mk5PM0JXLzhL?=
 =?utf-8?B?aklPT3kreGNYeFdtWkNNbWVqQ0tCT0xLWTMwMkF6V3h1dHBYMTYrTGhiSHQv?=
 =?utf-8?B?QWw4bWlab2Nnd3F5aWdGK2VXN0JYTDFsQjBKbTJzK0ZYb1h4d0ZsZHpBdkNK?=
 =?utf-8?B?R2EvUHlsd0ZXVGVaQkFDK21IRzYwOXRBQXlqODJqZWtnT1B6RTczdERyZGVT?=
 =?utf-8?B?U29jdElZd1R1dlhqeXJhc0twN3gvcStkWCtMWmF0QkltV2ZSK1RDRHBMUy9V?=
 =?utf-8?B?c2hpN2lrVDFGdXdXY1YrUHMyWVk0MXB2Nk9FM2JLNU5DUXpvbG9SZ1M1ZC9z?=
 =?utf-8?B?Kzd6RThBcExSR3dVTEVnQTdrSExNTStXQ2x6TjN6bjVHbDVsUCs0M2pUalll?=
 =?utf-8?B?SjY0MjdxVEhIbm50eDVKVGhoWGxKMUdOUU83bVpZVmVCclRUOEw5ajMzeTE5?=
 =?utf-8?B?a201Y1VweWJyaUxEbUg5N3pNYWQzRnpKejVOMHh0U1EybithTG93aFhSdGRR?=
 =?utf-8?B?UXRXL0didE9DSVBVVDVWQzlZT1h2YWUxS0FLeGJLWm12K0ZIRGRKNkRueDE5?=
 =?utf-8?B?NlF3TTR3d3VoK3ZCRHVkYTFCczU0amNyaFpTWWJMU1pWbjV0TTYrVnI5alZs?=
 =?utf-8?B?UW9UcWpUQ29GUWZQeFIvakliNjVneXA5c1JGQXBQeEdyYTdTK29PN1FlVFdP?=
 =?utf-8?B?OEZ1STcvZkYwOTJmaXg0dEMzYi9wanhYUTI0WXVTTE1QY0NSV2E3MHFXMjhN?=
 =?utf-8?B?UmZMUVZDeTMyRFV6Z0NZM09RZjVCVnpNSEdmdWUwS3Nnblo1RFQ4SXByb290?=
 =?utf-8?B?Z1g2MTVnZmlEek9sb0daSzhTZExlUXI3ekRqRUptTm5Ialpwc1VSOWN2WkN1?=
 =?utf-8?B?YXhmaGh1VDFaQmFHNHU1S2N2aGsxU3hwcElEck81ME5xUkdhcmJYRWNMcjBp?=
 =?utf-8?B?cUkyaEhySDBvQVErUENaeE1iQkpZWDhzN3JqQ3RzbjM1bVhCUmgzN0xGK05Y?=
 =?utf-8?B?VzV5V3JxT0drVDFucjB5cjQ3RXlpT0t0Y1IyS0xEUGV4ZnNKZUlzbi95RFlI?=
 =?utf-8?B?OWw3bFAxRjliSitZL2ZrUW84OXgyTTZiN0pPWFgyT1JTSzY0azVFVDRFUVNi?=
 =?utf-8?B?SzgzRTlQTFVzUnFCY1RLU01GckRLRXA3WEdJakVES2VreG01ZUt0cjM5WTNI?=
 =?utf-8?B?bWk1OHFaTWo2aGxzWTNhTk05a1F0ZUtaRFJPdTFYaXhBZE5zS01yVnRLai90?=
 =?utf-8?B?NVZncHVSeXhSUlhZaUZ2aWxUZ21tS2V5RG9pMWpsMkJWWEJLVDFpamh5NkRu?=
 =?utf-8?B?NWRzTytxT1VKODRmenJmNmlnTGhidngyazFJdzVuZFJWamQ0eUVRNG02Sklw?=
 =?utf-8?B?TWF2N1pmbW9STkNSVzBTaiswMSttR0srOUorcVZ6enNENnRpQm5UbXNIeTRa?=
 =?utf-8?B?bVV5QVNHMHEza005ODh6eEFuY1dTc1A3cWJWdnFkQ0F2bTVVQkNwSDVBZjI1?=
 =?utf-8?B?UmxFVkRHak45L3YzM1BFN29ZZ2F0bG4xMFp2cHZmRHN2aUdRTVVQYU5kcEIr?=
 =?utf-8?B?WjVlOWN3VHRseE5yYjBXV014NkowQ1pPTlA3VlVwU2dia0tYNFRlbTBXQVRv?=
 =?utf-8?B?UVptc2FLZWh2ZVByVjdjVGY1MGVjSGR1UmlFTzdGeWg1SDIvL0JNVm5sMTBW?=
 =?utf-8?B?Yjd1WUQzYi9ScGFxRHc4VkJKb2c4L1B2OExLdmlPb3ZLYmphY2N0bHRqNmlq?=
 =?utf-8?B?ZS9sK1hXRDY5MnhjZWc1TjNJaUZtT1dIQURjZ2s1UEV6MkpGYmgvb1pFaGRN?=
 =?utf-8?B?Vjcrdng4cjhCa25uaEdiZlBrcTlWcUZDeGJDZWJRVlNJd3ZRZWlFMUdqT3V2?=
 =?utf-8?Q?xNUOdCbJDi6nJaiSBIbBY6Q=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa37f949-57ce-4564-7971-08db150820b2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 19:08:05.8046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1gVdHl6rDfLivXdyZC0E4zv8PMZ0QTaUTDnC5H38IFYpHNud8GsPMOgozw0ynNq8v+NFrrOGtIc2JBBL8xxVRMTOh7pqEVl1KUE7gL0egA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8024
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

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2023 18:46:26 -0800

> On Tue, Feb 21, 2023 at 3:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.3
> 
> Ok, so this is a bit nitpicky, but commit c7ef8221ca7d ("ice: use GNSS
> subsystem instead of TTY") ends up doing odd things to kernel configs.
> 
> My local configuration suddenly grew this:
> 
>     CONFIG_ICE_GNSS=y
> 
> which is pretty much nonsensical.
> 
> The reason? It's defined as
> 
>     config ICE_GNSS
>             def_bool GNSS = y || GNSS = ICE
> 
> and so it gets set even when both GNSS and ICE are both disabled,
> because 'n' = 'n'.

It was me who originally suggested this and I forgot ice doesn't have
its own Kconfig file and doesn't guard its options under `if ICE`, sorry
=\ It would work if it had.

> 
> Does it end up *mattering*? No. It's only used in the ICE driver, but
> it really looks all kinds of odd, and it makes the resulting .config
> files illogical.
> 
> Maybe I'm the only one who looks at those things. I do it because I

FWIW I do as well, ironically enough :D
But I have `CONFIG_ICE=m` on all of my systems, so there was no chance
for me to notice this. Thanks!

> think they are sometimes easier to just edit directly, but also
> because for me it's a quick way to see if somebody has sneaked in new
> config options that are on by default when they shouldn't be.
> 
> I'd really prefer to not have the resulting config files polluted with
> nonsensical config options.
> 
> I suspect it would be as simple as adding a
> 
>         depends on ICE != n
> 
> to that thing, but I didn't get around to testing that. I thought it
> would be better to notify the guilty parties.

Patch is on its way already, it just drops the opt and uses CONFIG_GNSS
directly.

> 
> Anyway, this has obviously not held up me pulling the networking
> changes, and you should just see this as (yet another) sign of "yeah,
> Linus cares about those config files to a somewhat unhealthy degree".
> 
>                       Linus
> 

Olek
