Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4EA4BF660
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiBVKos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiBVKor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:44:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3F1156C66;
        Tue, 22 Feb 2022 02:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645526661; x=1677062661;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ImdD1OwNCIPVnUjz9htYdUnYsnorPlfAS5cuPr2ybVc=;
  b=Tyq7ON5qSew43C/jwe1bIz5xYiyAfH+WcVn0JvC3zhMHA/ccEEcUho2C
   Hm71uR07Zjb3fd3x8qMrr+x4w3JWqR81JTPX0pLFbITZNv8Soqz9Nf70L
   VnDJQgR0hs0RCOz6krJxeU3V9H3FD1T3ux85MnrDAzG/KIQS8H2x9A0s2
   QX5CM9HATFVVIFkklI7POjA6eA9cxr5NX3O0jf1M5YlHfbhcDHbjB2lwn
   vSzP9dLfo3mt8qDEn/0QlMjsw/Fuayk6CMygwKPA/l2XBD6Re9VxjuLiU
   DbfjaphksRWDooWcedk8+bLS5awyQ7PbRUqiSpSHxTrYQbwOYNZXilNDh
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="235199814"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="235199814"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 02:44:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="490749731"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 22 Feb 2022 02:44:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 02:44:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 02:44:20 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 22 Feb 2022 02:44:20 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 02:44:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYUiRLTR+LkBpk0KhB8Kdc72UVSM4BN3CjGlXDLOz2x9uwapqFOukTDx6AkSjBhZFZPGLigbPpko5fm43HufvMvvD0W/wsl+Cr/iE6b6VZiWINfjZKzuCglH2mxO2O5ohyTW9+9JRBtjb5S4bClr5/CdDXImU02S7NgY0e3VMRkffaPO54OhsRa3Y5xA/u4pO01yU+nNZ1jE/dkCkTOl6yMa/5fMx3SwaKjsP0kzJO9N4pqc1aSAr27pE22pAHOt+70jiVJ58fAyTk96z0+G7hAVoEnXjUv3Uwh4rv9GySkff0O9PJyGCD+SZAvGpl3WNWcgT/+xYnJPGdV+oID2AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAz6UQ/asj3zrV5rFVTW3SyMy0g6rr3Fur66qwGb0e8=;
 b=N6xaWzXzKzz+sbTp/Z6hi6gMYPMvg9pxJMG3lw3BQ52hoTPsOvb9+Dyj4fToJrnOL3LU9Taat3FpACmbKd49eJcpFhjma9dy09smjjDQPFZdg2hWKyiIKnHit8dc9vZ9y7ncRoQRs20Sb9+Fq1VQKQnhqGfysyJ8dVtWW4Et7RWaRxdyHlKCuUGgZlsVTg7qrQ5BKdIeJyoRSW1NC99NdFEScP1PMCeGzkydXTYOxBioZX1RdU++ItZR7dVIRaJUlGzDNmNvG7chrIoDEWoq5/VdkIrZlGxFIINEL8twlV5ZS8XpQdT/wdmGlxdJh6KloC+j5sJu7bPiYSboSUkvwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 DM5PR1101MB2154.namprd11.prod.outlook.com (2603:10b6:4:4e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.24; Tue, 22 Feb 2022 10:44:17 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511%6]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 10:44:17 +0000
Message-ID: <00534db7-6b0e-7efa-11a1-d386e2f71a23@intel.com>
Date:   Tue, 22 Feb 2022 11:44:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v3 07/11] lib/ref_tracker: remove warnings in case of
 allocation failure
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, netdev <netdev@vger.kernel.org>,
        "Jani Nikula" <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>
References: <20220221232542.1481315-1-andrzej.hajda@intel.com>
 <20220221232542.1481315-8-andrzej.hajda@intel.com>
 <CANn89i+E3z-iXSJh8316KSycYk2VTS-n0E=tAOj23fuDSi1Zjg@mail.gmail.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <CANn89i+E3z-iXSJh8316KSycYk2VTS-n0E=tAOj23fuDSi1Zjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0601CA0042.eurprd06.prod.outlook.com
 (2603:10a6:203:68::28) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 066ea091-2216-4fc7-b731-08d9f5f04628
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2154:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR1101MB21549F7721E88E5D6242604FEB3B9@DM5PR1101MB2154.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i5wj82ArIV/zRA5KuC2B3xHepWZkZVy7BMXutPbXReeRscwqJxOroazj5Vyg1zJhBZKvT/05d6rl8HCQ52On62iOCAcGG4J7x/CsdPyJ55VGDqOtVGq+Jy1bDaSzZFI1DDyDNPWLTC0CDSScAlavE3bqgD3qL7PtkiH4i66VoTYDenTSi2ZSt1QRbIg87RERt9qH5oBHYcSYcU5w7UTdcfCOMzyylytRvoc/S4pPllkp39r7EnxMnDwbO44Hwn9ljcGe4Q74L2TXQS973xPmG6/XxA3NNZssh2v0WXDsHuawLbxH8e+5PJEaDZQofjAyRx1fNgSDszscEXMWtPqLXUxpjivFmwH88f8g2ikz3rYwh7RUWClBewIE+BdkD6qRxFaQFlWiVvUlOzbGrDejtEYyik1yO10/hV1jWzULK6+mGCW6wxHHz77Nn0WKUf7MMubsZ7NN2Iw+yQ+LMpkFrfEciG5XmfqZLxELNq3SmLjNOE+vo0FNlTRPpOWTmAqflak+RU7QCfTsl7Oq6EpQVYIJXiNKgXdmTS8jwNHgrDTEiyh40dBqx4GgUQn+sDI86TlSt0tWn/Q82HNaY2YEGKdfoGMoKmmCkvmrsHK1fw16EJezKJryUssoIRa5ZLn64lNy8QN9Suq++yNF/sbgIZ7d4j74LdwuzCY/ZS5gwIamMc+0SqGQtqy3PZqGI7U3KI2gOaisaARMFHOW8w8juNxuCU+cgyqyBSnee1HA2Rc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(53546011)(44832011)(6486002)(31686004)(186003)(26005)(6512007)(6666004)(36756003)(2616005)(508600001)(83380400001)(5660300002)(2906002)(6506007)(8676002)(82960400001)(38100700002)(86362001)(31696002)(66946007)(66556008)(66476007)(8936002)(54906003)(316002)(6916009)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3BGdU1KR2s1MUYzeWswOUtCK1Q3aEhJYy9qWThrandLZDgzbVp1S1QvYTVK?=
 =?utf-8?B?RXpaUjF2Yi9vMzN4T2Q0N21hVDR0SzF0djdZcGFqS0c1YXZ5WUtVZC9QZ0pl?=
 =?utf-8?B?dHdTZS9QNWFvZmFITU94aEVSLzczZFRtbVIzbFVIM3dTMktaVWlreGFwNnZn?=
 =?utf-8?B?TVBzcndsTEJqdVRFeloyK01vSkh0d2xVWUhVUTRWRUFYaVNhYldoSVdxNlZt?=
 =?utf-8?B?V081RXExNXhlWGsvYmpseTJyK0dTM2tIOW8wbkhSMjJHUHJ4VUFRK3pMRS94?=
 =?utf-8?B?Uk1EdTl1NlAycnVuSWV5SWFZMjVmYkpRMGVjejYxU1RORUpqV1oxSGdJTDBz?=
 =?utf-8?B?RjhDNW56WHhvY3dnR1l2YUYrNEpZUXVRS0VXYUJKeGpUU052bWY3MFBwMmxI?=
 =?utf-8?B?cXFZN1Rhb2EvbUQvNVZNUlpNZDI1cnJOdzc0d2ZNSGRjMGh6ZkRyRlFyK09P?=
 =?utf-8?B?bXNPZ21GQ3lyR090VlhSd2QwaGVQUURMTU1wUk5pa1RrZENNSTlTbWErSEp2?=
 =?utf-8?B?NWNYSGlOMUFKRXdsZi9yMmlPVWNlK3FuNCtOeDBTY2lGMSt5dm4zUkVzU1Vk?=
 =?utf-8?B?M0VkanVMb0xjMTg4WjlvQU11TXBQZnRLQWpFNUpkdlRUTUVKNlBnTzF2NEN5?=
 =?utf-8?B?VGdIQVVaSlpGN2xoeS9Ya3FUNTlRSEZrM3NBdzJ3R3ViOWFOanlseXVBSXRK?=
 =?utf-8?B?cjdtRWFhR2NFNEcydTk5dFR6SHBtTDU2RjFZVXN6Y2NvczZlL1hYSUlVOUJJ?=
 =?utf-8?B?RE13WEJ0Y0hVc0l1MTF4djhGckFma0lKRHlGcFhqVVhiSUwzUGhjWTFMM0s2?=
 =?utf-8?B?UnZFTnR6aU0zZWhlVnh4NnRCSENvUTRtWUJMaDNYTExkUDJ4RkE5QXJ1ejRT?=
 =?utf-8?B?VjlCdkJvQmtXcXBvaFRCeWdvK2hmNi9LUGFRMDRBTjBZbVlVLzYrY0pvbEZT?=
 =?utf-8?B?aVg5ZUlkOStncFdHdGNSMjhKaG1zdWhlNDltMnF3aEJ5K2hjVU1VQ005Wncz?=
 =?utf-8?B?bjI2SlI2VFBXTXVMZTNMeE1JUnE1WHJkNU90WmUzTGFsK3Z0U1VBVGY1QktV?=
 =?utf-8?B?UCt1d1RjYkJ0RWJUemxSMVpDeG9yVDIrdjYybFhWM1ZJcGpibjZ4ZVRKaThT?=
 =?utf-8?B?a1RlS2hzUHBzbE5KcURDdW5iTVI5eXVKTzI4SE5EaTZ2UUZmaElLSlA5N2l6?=
 =?utf-8?B?UDBJSzJjWlYycDRGcWE4U2tBM203OTBEN0RmY1FRTWFMNTZZbitsZTNzSEh4?=
 =?utf-8?B?d2pzNTl3emZFdzJDOGtJZ1VUS1RPZnRROVptc1dyOEQrcHorNGlVWGMrdXRK?=
 =?utf-8?B?TFd4RFdtTWdhVGlyQ3hJOGNYaHRNTTlqaTQ4WCtGMzJlRDBoN1piVnNLUTdT?=
 =?utf-8?B?bmRJNGRDMDczQ3dBYUtjRi9YMUxnQWpTM1dNUEl6dWp4T2c5VWt6QU1ZdEdV?=
 =?utf-8?B?dUhzZEZRa3Z0WFd0ODNuS292akRiUnRMUGd4eXNhRGtacDgyb3lGeFgvT0g0?=
 =?utf-8?B?K3pxYTBFdTFTMlEvejBZT3RYbTJ4dU1zaFdFbjJiSTJRU3BocEV2dWRNTnlU?=
 =?utf-8?B?c2MyNVZYRkRYSG5QQVBGcTNNRnQ4UW1ieTJJTHNFd3hOUS9DYnhSLzNMalFJ?=
 =?utf-8?B?SitaaUlrUld0TEY1elRxZUdsMVhzRExNcklObHNZSmV3TG9sZmdtSmxSTkJz?=
 =?utf-8?B?YWNocThSd1ZScGJ3WHhpb2JqMm9TMUNVUEZzZUZqdTh5ajZQZVFYYWU0TkZG?=
 =?utf-8?B?VGRDNDVXNVZtNWhuclhLaUlmb0hhbFE1cTJobXF0YTkyMnliT25hdmdaWVhz?=
 =?utf-8?B?dDU0THBNVUI4T093Ly9Fa0VWTE1BdytQUlNJV0ZjWlhHdklPaVZaZjdjTEpD?=
 =?utf-8?B?dWR4QnZnQkNOd0I4NmhaZE56c1B0aFpkbEp6bVpOZzlsMGE5clNUbFdueXow?=
 =?utf-8?B?OUUvK0JjcENJKzJSRDdPQlUva1VFQTVxd0djVXlGV3NJTDg4N1dnbWFlVHZW?=
 =?utf-8?B?c0ErNHlBVG4vdURQNjFRWnRxNkI5L01NbWdLUWlJSC8zcUpWZDRXTzArNWNH?=
 =?utf-8?B?STBZTFBTbzNOeVpvbGlhM1NTZldsMVlnRjFYbUtCOS9aWStZbW9wNEZKOG50?=
 =?utf-8?B?b0Q0azJwOFJqT1lPVFZSMVJXUTdWQ3lOeGdBOWdJWE5vRC9UT3NnLzRiUzJF?=
 =?utf-8?Q?bjnF0vaK9b74qH3neGPUjlI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 066ea091-2216-4fc7-b731-08d9f5f04628
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 10:44:16.9852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vDlYZAixV3nYPfCjS17zRYxKjnSpTGKrcvsjUNnFT4COs/+h5iFgsTsLo+5cw8p/hf8Kb+SPYp/Jhv7xCRTgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2154
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.02.2022 00:54, Eric Dumazet wrote:
> On Mon, Feb 21, 2022 at 3:26 PM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>> Library can handle allocation failures. To avoid allocation warnings
>> __GFP_NOWARN has been added everywhere. Moreover GFP_ATOMIC has been
>> replaced with GFP_NOWAIT in case of stack allocation on tracker free
>> call.
>>
>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
>> ---
>>   lib/ref_tracker.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
>> index 2ef4596b6b36f..cae4498fcfd70 100644
>> --- a/lib/ref_tracker.c
>> +++ b/lib/ref_tracker.c
>> @@ -189,7 +189,7 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
>>          unsigned long entries[REF_TRACKER_STACK_ENTRIES];
>>          struct ref_tracker *tracker;
>>          unsigned int nr_entries;
>> -       gfp_t gfp_mask = gfp;
>> +       gfp_t gfp_mask = gfp | __GFP_NOWARN;
> SGTM
>
>>          unsigned long flags;
>>
>>          WARN_ON_ONCE(dir->dead);
>> @@ -237,7 +237,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
>>                  return -EEXIST;
>>          }
>>          nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
>> -       stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
>> +       stack_handle = stack_depot_save(entries, nr_entries,
>> +                                       GFP_NOWAIT | __GFP_NOWARN);
> Last time I looked at this, __GFP_NOWARN was enforced in __stack_depot_save()

You are right, however I am not sure if we should count on unexpected 
(at least for me) and undocumented behavior.
Currently we do not need to rely on some hidden feature.

Regards
Andrzej

>
>>          spin_lock_irqsave(&dir->lock, flags);
>>          if (tracker->dead) {
>> --
>> 2.25.1
>>

