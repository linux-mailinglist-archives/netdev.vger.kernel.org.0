Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9270F699331
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjBPLe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjBPLe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:34:56 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096ED13DD6;
        Thu, 16 Feb 2023 03:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676547294; x=1708083294;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ii9hbDoZVgJhx9qQ0y3UI0tMXTz4GS6dOEVHyqaAcSA=;
  b=bM0QC0Dc+v7xFv166Q/27CiQm5PW+c+sAxzIW8cf9wGA7U19A+6xgC4j
   eggPot9JoP3mJKc4SXoh1D7UsFJKLmIpkjYgg7HUNdZ4rSHHj1hbxvu8K
   Ox0NowHLzF34xSMr4aQj3ReTpz5sWD7UZRv14Jy2nP5lM3+xtskYlS6OV
   1xDMo2cDH5G9qUHZAlnWt/cC4k3XKutm1XRy/DGx9Q7Aqnn5WdTfTQ+uP
   zItRqGK3KIyWiuuVptYzys+THFC8IO00l908igD5GjFlLb6biTZDmvlc+
   OU3n9r0i6nx0r3pdtOg7ujx1/K25R7oF6GYvSZuGoW69iXsYx2XHkb97U
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="331691652"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="331691652"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 03:34:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="793998010"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="793998010"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 16 Feb 2023 03:34:53 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 03:34:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 03:34:53 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 03:34:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOKTQT21FbiDDuS5/vct7MOInYLnhZ9ym5R07laNAMvAlBxLQm1ZQPT+X5N1/nJkO07frDaY22KaKdAmagkcPVX+8bGWdEKL2Uh4+/bfSQRmB74h1hxUqVMcZUpuRKnqM9sc76urCI0ZzFWayIL5zpdYVX6nvU81NY42VhIkzQY6wT/lhh3L4oi9oP2X32yD/O78FMwYr7XVjWVcHZi+Ziy/nko0EvtlF/ZVkf1PfcOpVIoSw/gBAHOqErQT8MLhXQxadaA72163uvVFeFtySh2r1RicUI+1zgMCdtGODDjV4i7tStVa/eg1qIiEbqRqqqlobPNAPdvr8RdpZzD/Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScDXzvEXQB+ec19tOaNzaiA4YX7MLZ9cmxS0uols9Ng=;
 b=iOLNBJudJnxysXV+TTBThXbP7LhF9lrXpWPlosmKYOovF/8bqbNT8eF+wCaCI8jC+XaIu2FQhWj8MWvezDwIkVsXuVCApJaCKJvwX2atICg6k479lCrcWUvPYFiS8UCxEviqcNTBedBV9euCZLbyKG/s1W0yUx7HWPdeuAM2OsyXYUMTkxx9AK+BcGQ1+mijl3aqoprwdPi/kAS/npB0sR8qrrDpV1VZHz9SiD/YS9lmTL1ltWXYt0a4FWtbsWL9HCobbrsC9T2VNKdysdhydm2Z/xCinAUmJupsfcFI5B3xgE3PmvA2Mn190E6pdR6CmW8JoxDhh9iWp4qn2PgG+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 11:34:48 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 11:34:48 +0000
Message-ID: <a7aef2a6-faa1-67c4-9c8b-305adda3ad9c@intel.com>
Date:   Thu, 16 Feb 2023 12:33:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next V1] xdp: bpf_xdp_metadata use
 NODEV for no device support
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     <brouer@redhat.com>, Larysa Zaremba <larysa.zaremba@intel.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>, <martin.lau@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>,
        <alexandr.lobakin@intel.com>, <xdp-hints@xdp-project.net>
References: <167645577609.1860229.12489295285473044895.stgit@firesoul>
 <Y+z9/Wg7RZ3wJ8LZ@lincoln> <c9be8991-1186-ef0f-449c-f2dd5046ca02@intel.com>
 <836540e1-6f8c-cbef-5415-c9ebc55d94d6@redhat.com>
Content-Language: en-US
In-Reply-To: <836540e1-6f8c-cbef-5415-c9ebc55d94d6@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MN0PR11MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: 34b7620f-97f1-4d91-956e-08db1011cf6f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tm082rcfzi5RYG/M568R4983KA4Rd91GRKmJ59scWmwVTcwTiDpf7xJwTFL0P2De8w8mof6Xn8uqyFUL5xZBdkEB9Tsfe/2o4Ve+ocN0yZntlj0IlvfgRo+z06iHLbri4lDIt3eIIvoYAgrI2bu2fGOpNyDaXg58UROdi+qGGek1PPiXZtwAFgfoYgTCPUWW47GxSYGHDLA0sPdL1wD0W8TWN7Lr+63UD7FS62AKS5vjZtNYhGVR+eH0RaYPKTlV8z2S1KDHrXH6rMJIDTd0NU5QD65nXEWNjsRmzHORXIgjQ9KjK/V8Jm8lmuEWbN3zb+3KkgaGsi35oxKYQ76mP25AcqLQaCzJJUV0RzVuiXmV0dRMTNe2a6UnZPx2m2w8AwRag4qP4SDyw7+PXBbhhHRhFKP+BwY8o3zVFjhwwNKreusrIncw2DzZWogCiyCzNNtv7pZLmrfmO/Uyg6C/BdGDH6phD8I/0UmaxmdOlHzelCr2PQIYQvCXu9PEu1A7cgs+TnfO8ptonIoq2kZGt0nbVsH/YSLMbzxp4r+dG+/jJLbr5wq0noVuepipjrdZaeNr08CN9cGdK4HqdfgJ2bfegg5742vHCypiqXg8mdAFfNZEiVL7xG0JH7enR8F87xDdxnVoV/DQk1l9qCk+z2Ca6fZPOjk0seGXjTud7fnqRIKN2UQoMEzkMi/Iacx86qnJk+z8EKY42r4ko+SAdTBwHLR/o0597eCtgg2vLfsYVwXclYZJkqK/rF5GAczfr91GPxN9n59+3Lv99VsU4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199018)(38100700002)(82960400001)(8676002)(66946007)(66476007)(66556008)(26005)(83380400001)(54906003)(6512007)(8936002)(6666004)(478600001)(316002)(6506007)(41300700001)(6486002)(36756003)(186003)(31696002)(6916009)(4326008)(86362001)(5660300002)(31686004)(2906002)(66899018)(2616005)(45980500001)(43740500002)(134885004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlEwL1RkS0Nzd2dqc2xFSzh6MXh3OThMbHhHNjRabTdwbzBVNlFtRDFId1hP?=
 =?utf-8?B?QnNhSTFUWWhEMnhjT1RMZnpyRWZsbUlTSVFWeEdhQVlNRUFWeUwvMUhwTmtP?=
 =?utf-8?B?R0pGdXkwckkxTkd3aVV3YS80cjNkQjcrUjNFcU4wbTRXU2pnU3BtOTBDZU93?=
 =?utf-8?B?MWptMHNDbnhJQVdEcE9JcS9UbjkzRXY4UE9XRFlJSUZwbzBtYklGeXhNNUNs?=
 =?utf-8?B?Y05TcldrMWpJY25ZTmw2YzFGWGxUcE9DbEN0ellqQ0NycisxTlo1bUJaYkJI?=
 =?utf-8?B?bm5VRjIrSTNKMm8vaFpCQkMwMFE5dCtaL2pBMk5QeTYydzlINng3RFFlMTZx?=
 =?utf-8?B?YzVDMitDbjhrVmp6UDhxQkduQ1p4UGpOZGp5cjluckJqMVE4SG9QNy8vY0FG?=
 =?utf-8?B?VFJ6RFBKNG54K284ZHhuOVI5OVBHcVgyQ1h6QmRjaHVIKzZCVG8vTW9CUVF4?=
 =?utf-8?B?ejdjMVQ1MmFmUzNaMGNCdlY0YmV3YXFqVWExSEZkd2dEc3NqZ2o0VEVwOWJ1?=
 =?utf-8?B?Nmw3SGpySFluOWZiRWRWbUFDMXZXTlJIajE2Y3l6MGd4ZDFIT2c3dlpQanVu?=
 =?utf-8?B?WFh4elZVdVBkeTRqdXE4TmFkRU9QdU1PRVJaYnAzNDdidzdHWVUrTTkzZmxO?=
 =?utf-8?B?aUJlbm92cmY3TW9xeU05N1FKR05KemdUTlQ4Z2J3dEV1OGVGTjZhc1VMUi83?=
 =?utf-8?B?NGs2bjRWeVhCeExwVnZsV3d0R01pUitRUXAwM1hNV3JUTkZsbm85eGd2eTBQ?=
 =?utf-8?B?TEtmSlAxTGQ0TndhYU9HbzhBMWJIc0pYZHRSeGZkNDlCQXlVMFpjUDY1MDdq?=
 =?utf-8?B?MTZ6Umw1S29MWnpFdW5raUVRR2FPOGdaRUhHcERPTXFEZnovU0hFdnlhWkdW?=
 =?utf-8?B?aVU5MWxQMDN0UkZBZkxpaldsOFNwdG9kcGlsemJrbzQrQU45eEloUlp3Wlpp?=
 =?utf-8?B?c0VZajgvUmlVWExrbXFOODZIby9OTkhzWDFQbXUyWCtBQ3ZLN2JRbHBvRG1m?=
 =?utf-8?B?dXBpTnlRaXk1bm5ONmJjMm1teHF2U3EyMGE1RDdtRzVvaDU1c0VINXZPTWNY?=
 =?utf-8?B?SDRqMWtlN0tIZkhsTGtmNXFMajVyRGlqa0wxSkovODZoWkhENC8vb21mVGJ2?=
 =?utf-8?B?VXJtQ0o4MlUrRnBhbnBsZ2JlUkZEeXhOZFN2dFBRKzFWVWJWaTMrVWp5eWVI?=
 =?utf-8?B?Q3NYNEJFUzVjSDY1dWRCZlEyd3pjN2JPR1IrQVNpSGJReGVZdFlsMU1tK2F1?=
 =?utf-8?B?ODM1NU9VMXN1cUlBUFAwaFRHMGpmc1NLMm91WEVtZXJMNzV3Vkw2RzFmbUE3?=
 =?utf-8?B?NWZ1c05kZE4yUUV4ZGdtbStVT3ZodDlkWGFuN0JCQ05JS1ZGUDZoOGVQTk5s?=
 =?utf-8?B?N2JoVzlINnJmOWlmZ0s2MjdnWkxTL1NvT2h4bi9vZndRaVlyNXJmSEF2K2Zk?=
 =?utf-8?B?UTZMbVpOSHFHNlRicXZXTjBYSjZrclBGM2ZydW1MeHFTalgvWUFvM0hXdkFL?=
 =?utf-8?B?em54T0kwaDAyZXBOL0NpRUtmcVlIWmNNNFBxWDZhY25QTmtuQjFtZ1h0Wll4?=
 =?utf-8?B?ZmI5WlNZZDk4ZEYyVUxhWE5WeS82NXhlTDgvNXAwdHV0ZTFGNk9ZTXdvWUxo?=
 =?utf-8?B?cEJHQ2dxbVdUQzJ3VTRyV0xETk1QOXdhVlZjZ1crY1dkdnVKL25xSjcvV0JL?=
 =?utf-8?B?Y2VXWVNXSEVIOXUwRUZFZTBwU0NuMk5UU0k3dHlsaHlSa3RUYU9PQUllOUMv?=
 =?utf-8?B?QWdKZUFKZkZzeU44OHlJRis0bWpJRFBhK3ZyOWFSOHVyWlN5Q2lTd2RJNXRz?=
 =?utf-8?B?dEloT2ZuSFJ3UmF0MnE4RDcyaW1xNzJ3Y0oxZzZpYXJIckZJb3U3VW9IdjhD?=
 =?utf-8?B?NUR0ZTZUc0J6U3NGek4zcmdmNjJsaWtkamVTQjAwUGcrd1RtQ1pHUUdwMjV0?=
 =?utf-8?B?UlV6V2I5ZGdKeENudUVGUkFybG85MUZDSkpaMHM1V1Awb013b3ZMdDVqL01y?=
 =?utf-8?B?ZnNsdVJVN1VxOEdxelI0WklPZ0dCbVpOTHFjbWdXa2p1QWw5SEx1SE8yQnd6?=
 =?utf-8?B?ZnRDcEc5UFplV282Um9XUFg0WU1VZ3hLdjFyQW1mUFlVN0JsZFB3b0Zvd2la?=
 =?utf-8?B?dXRMZW9wNkhtZjZ4cWVoOWxHbE1jaGRDQWN1ZHFVZFlIRXd2Yjl4QnozRVZ1?=
 =?utf-8?Q?Mff5fzaqNxGzQ1D3b5qv+9o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b7620f-97f1-4d91-956e-08db1011cf6f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 11:34:48.5616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tnhDDGXygTIuQh2VBUSgeDj10S/wQCivlN+FxfmGgwKmzRJ5aQ1jHu1TaUN7Tkz9BzUbRrhbSEiigpqk8ksGXHD37oyFny7sgEKcebirid8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6011
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Wed, 15 Feb 2023 18:50:10 +0100

> 
> On 15/02/2023 18.11, Alexander Lobakin wrote:
>> From: Zaremba, Larysa <larysa.zaremba@intel.com>
>> Date: Wed, 15 Feb 2023 16:45:18 +0100

[...]

>>> I think it diverts ENODEV usage from its original purpose too much. 
> 
> Can you suggest a errno that is a better fit?
> 
>>> Maybe providing information in dmesg would be a better solution?
> 
> IMHO we really don't want to print any information in this code path, as
> this is being executed as part of the BPF-prog. This will lead to
> unfortunate latency issues.  Also considering the packet rates this need
> to operate at.
> 
>>
>> +1, -%ENODEV shouldn't be used here. It stands for "no device", for
>> example the driver probing core doesn't treat it as an error or that
>> something is not supported (rather than there's no device installed
>> in a slot / on a bus etc.).
>>
> 
> I wanted to choose something that isn't natural for a device driver
> developer to choose as a return code.  I choose the "no device", because
> the "device" driver doesn't implement this.
> 
> The important part is help ourselves (and support) to reliably determine
> if a device driver implements this kfunc or not. I'm not married to the
> specific errno.
> 
> I hit this issue myself, when developing these kfuncs for igc.  I was
> constantly loading and unloading the driver while developing this. And
> my kfunc would return -EOPNOTSUPP in some cases, and I couldn't
> understand why my code changes was not working, but in reality I was
> hitting the default kfunc implementation as it wasn't the correct
> version of the driver I had loaded.  It would in practice have save me
> time while developing...

So you suggest to pick the properly wrong errno only to make the life of
developers who messed up something in their code a bit easier? I see no
issues with using -%EOPNOTSUPP in every case when the driver can't
provide BPF prog with the hints requested by it.
What you suggest is basically something that we usually do locally to
test WIP stuff at early stages.

> 
> Please suggest a better errno if the color is important to you.
> 
>>>
>>>>
>>>> This is intended to ease supporting and troubleshooting setups. E.g.
>>>> when users on mailing list report -19 (ENODEV) as an error, then we can
>>>> immediately tell them their kernel is too old.
>>>
>>> Do you mean driver being too old, not kernel?
> 
> Sure I guess, I do mean the driver version.
> 
> I guess you are thinking in the lines of Intel customers compiling Intel
> out-of-tree kernel modules, this will also be practical and ease
> troubleshooting for Intel support teams.

The last thing our team thinks of is the Intel customers using
out-of-tree drivers xD

> 
>>>>
>>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>>> ---
>> [...]
>>
>> Thanks,
>> Olek
>>
>

Thanks,
Olek
