Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF2968651C
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 12:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjBALPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 06:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBALPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 06:15:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12327A5EF;
        Wed,  1 Feb 2023 03:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675250113; x=1706786113;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oWbk1XMXG00BQ9ehBUh375OQGJwrR5A3XfVrqzZtDYA=;
  b=Tm9ka2kC3+Hf2nUjmltqM8ScFtEoR+wkeiK7fNe6jciDx6vukFLfYtRH
   0D36Jfm3SJo0gewp4cxC06zSKtLyrJeRRsBkO0H+GTQD1dElLWtWannke
   LWWCuSV95zL8D/AH9pFGMPuJ270vHmUmW0fb33xE1qWVncrnxQRDfIXEi
   acs8FDsiYomDHtsFbQsfxY6o+bIUClxzYjrdHj7g3iSSX0Id89e6gVJo2
   9heyyT+vEsHg1FuPRgGG+cB0aTPdBIuwfan5WIrc5n4dWo4AMfWuyshMq
   bv2XKLfGvKBucYRKchhjm9RXhmeXQvLg9qXBUuG7P62niDv3kRzEXIBPG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="329406565"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="329406565"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 03:15:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="642370103"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="642370103"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 01 Feb 2023 03:15:12 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 03:15:11 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 03:15:11 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 03:15:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYWH7v0VvSuxWzdDVq7M5C9W9sZYRY2l0NyCSIt6qpbiJjrFwKop5aic2Sbk9kwQ+5PAHqkKAzHTEZzoaRGn3PapJcBZOW7w7GQl2+rWVPA3b1v+cq/+pMhQRl9seUmQn0twJKyPT34XL69x/jv//CyLxPAcEKYIpjt66b8piKIqnEnW3FC37R2hod0otlgTzs1sTxGO3sFjENneUlguE0Yf79qJwsj0Ju520OQHbJpf8Xz5T0DrjA9aLo+oq9cyXaMBGxoWjFkSJJEimJhoh5Pn0O322ND0SlUL/thWUrVIpYoREx0YHP5lBGYaoCK+Fr8EUQnNCtvMcvvKFhNT8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l2+VAqHg1HsgsLwUW3qoSsuinX3WakV6SM+sZ8zFh1Q=;
 b=NJW4MZCX1CYoWg2ZMvhvHhCbfJQhR/evYlLXNAgt9pvSDrfhFsfm/icBcVkqX4+7f0h4WQ83lH9DGW2M2525/xWXaYUhB1iyiso0bUjjeKHwOWwat+VuPPBxxE5ykVVajrWI0ygbgRVetW9T1hMwic/sjfyieQ77oB3hCekhcX3cV0y7Z54/nZHJQYXArDB0gUoyyddaYxPU6mge8BauckXQNUCpdx+CPEX2TQnZ/TbHbo7Dbv5CYwl8bo4yPXdJkJo12JnAIFP0DKV/mxOVHMq2Wd5NAqtm6Ztp4YXnrK8nQxS5OYtgIJzRDd1OyTPNF3EnpgYD97ZNUlHVqWk9AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB8087.namprd11.prod.outlook.com (2603:10b6:610:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 11:15:09 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 11:15:09 +0000
Message-ID: <af77ad0e-fde7-25da-dc3f-5d19133addba@intel.com>
Date:   Wed, 1 Feb 2023 12:15:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH v2 net] ixgbe: allow to increase MTU to
 some extent with XDP enabled
Content-Language: en-US
To:     Jason Xing <kerneljasonxing@gmail.com>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <bpf@vger.kernel.org>, Jason Xing <kernelxing@tencent.com>
References: <20230127122018.2839-1-kerneljasonxing@gmail.com>
 <Y9fdRqHp7sVFYbr6@boxer>
 <CAL+tcoBbUKO5Y_dOjZWa4iQyK2C2O76QOLtJ+dFQgr_cpqSiyQ@mail.gmail.com>
 <192d7154-78a6-e7a0-2810-109b864bbb4f@intel.com>
 <CAL+tcoBtQSeGi5diwUeg1LryYsB2wDg1ow19F2eApjh7hYbcsA@mail.gmail.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <CAL+tcoBtQSeGi5diwUeg1LryYsB2wDg1ow19F2eApjh7hYbcsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0158.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB8087:EE_
X-MS-Office365-Filtering-Correlation-Id: 3371146c-8171-4df2-11f7-08db0445948a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wjhQqf5sXxHTKJ3XTWXo8etooYEiOy6V3f6QqepfHjdwfeuRchcX+BYou0JW6psqVoLQJ7zSpnvB0BPegWdK58hYVF9/gpEhK50rCL3AC1B79n/C4QF8BSC/Ima2c1i4WvxxSKYObBIlAVonhoONgI5otPEUYaFcThv3GNThJNiv0TfboMpc9b8+zUfob29QICJBbD3KU9+ugY/IcxgeYEI47nX4Waz7z1eQvZ3s+qtaHel3HM50sH04Q88ir/o9EgTFQXI94SogoJbZis4tqVhsM4xipAtnMDWHWOtdM0c4KL3m29IfxuHAL6MC7Gm62p+Hq95TEfevAUwjQjWPtjiws//YsfaEaRFKuPUN34i9law0sUh/3kipmpBuw4UR14Dg+Mmkmwc5Tyb08uXaN/gQ6QamET5lRKFVtTO3nS6w6YcW9ouZ6cWSPXtiU/9UnPluiS8Fkh224R+/SFYURDlRDTLLC7OhRoEdFX7OxDG0qRHLaJ9spaPmUneU9WrdgGQa8y3JNQgVoh0qYgb90C4xJYGU6JGC9y+kkztdF6FdReLxZBZ4dWC+TPpgzZ4BYeY0HBaOXQC94L514eW8VB0ZgdTwreBwhJfpHLqrpzoMtbELf6Of3ZQkl9JVxh1Zd/2w3ZVxWpVJAxMQeioW1HL5zYl2Hzmdnf6o8T072WEASC6GA0NOOmT/yZSKT7kRI3VsEn2sfCrQLX/jM5V6rTdFuEZmjkCVQwbfJ20EDiS/bpiCyNcPaU55HCCzUOs0MaR9MfzqWNJL7/0UlnuK3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(366004)(346002)(396003)(84040400005)(451199018)(31686004)(66476007)(316002)(83380400001)(86362001)(36756003)(31696002)(6916009)(8676002)(66946007)(82960400001)(41300700001)(7416002)(2906002)(4326008)(6486002)(966005)(54906003)(6506007)(5660300002)(6666004)(478600001)(26005)(38100700002)(66556008)(8936002)(6512007)(186003)(2616005)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFAvV0tkSFFyQm41Sko5aUFWQXRMYVFqVzd1ZWI3QUpDTlpjdE5GMXNGMUtn?=
 =?utf-8?B?ZDJLUmxqNzR6bEEwK1R1ZHhOZUUyYXVTTWVZUVZMVFFGQjZZT00rd1hrcGxM?=
 =?utf-8?B?RjJvTEUvTUhqdGtJV0RrTXVkMENTRlA3TTkxK2pFWEZOVzBUdjdjTENnc2tv?=
 =?utf-8?B?MmVTTEVUUm5FRDVKQkxQS29Wa1hhK2l2ZW1GRmlyRTZyWFZFOHBaT1dPd0ZM?=
 =?utf-8?B?bk5VeFBleEcyQVg1RVlZdGRhQ0oxVGpjejVLdE9rWmpvRDVUWkg2TTJJQkFh?=
 =?utf-8?B?RFJzamJZeUI1UGZLVmFRdUdqdy9NQUVidWFjMk9WNjkxbzJHN0JaemZDMGtF?=
 =?utf-8?B?WjdGRW1qdmk1d0M1dmZNckpGNlBwWE83OW9IUnlYajZBc3dWUkRrK1R2MG5v?=
 =?utf-8?B?aVg4REJnNUxiMnN6cFlzaGRkcVJPZkJQR01DQytPcjA4NVlyQnQzM05uZm9B?=
 =?utf-8?B?dTZFeHU4VUdsV2llREJ3UTkybnFRUWJvYXNSV3cvWS9jSjdhZ1JwTGhkVmxn?=
 =?utf-8?B?UXRId0J1QlhURkd6YWdPb0tBOFl0MmN5MHNFZkdwQWhsWVRXUFB2QjB5QnJy?=
 =?utf-8?B?TzBqTmtLeGI1TzMrcU0xT0dRMWxDT1RwNXZZTDIzUGsxZ3pGVGhleTlVSmpQ?=
 =?utf-8?B?Mk4xQ1hyQUN6TlBoTDlWMGp0TVRuYmp2UHdBd29PK1JEVGpDT2o5SkxDNExx?=
 =?utf-8?B?cm5EWUo3ZU1FT3p4V2VtWXJqZUVxYjVoeHEwakRDOWZmSUFGNkFBL1c1R1pC?=
 =?utf-8?B?ckpwb1h2MitvVGczUTFVNTBLYzZoMjN0NmdQVlBSM2dyY2l3UHhGb1hHa1hF?=
 =?utf-8?B?OUh3aFBtbmlKdU02bGNaTDVRWkpUWE5kREtGMW1EckFmcjV5UGdUNTBiSTN5?=
 =?utf-8?B?Wlh0SkJsOEhvdTcwZjU3ZjF5SWliSHMvTXdBZTJlVTdxYlJWam1jci85Z3dB?=
 =?utf-8?B?Y1FsOWVqMURuWkFhMURVNDdlRk5xeEF1dXJLVTdGWm5ZWC9nQVFIVVR5VzBL?=
 =?utf-8?B?c2lNNHlRTzIzV01JYjdjazU4N2VKS2ExMEc0M09uOHk2djZaUnkrSU9UV253?=
 =?utf-8?B?YVJWbTQxV2xUcmtjK2JlT0hiLzN0SW04YkNoWFoyZFFJQ1pRb0ZZUFg1ZGVT?=
 =?utf-8?B?bWdscjFzMmhnZXRyNG5rV3puajFkOVdiUUdlWTY0NWdIcmx5MFJ1YkYxZ2Zk?=
 =?utf-8?B?dXp6NlhRN2YzeE1BRzhVOE9tYmJ1QjArcXVva3NCZHduVmg2Q1IrNE10bGtq?=
 =?utf-8?B?SWYxZWthNUtYbklUTHM1TW5mQ3pGOEQyZytLU3A4R0pHend2dUUvRncvVmFC?=
 =?utf-8?B?cExMVFdLY1JJZ0pNWGsxUzd1OStlTGF3MEFWYkxqb3puVUhNRTkzaG04dlFS?=
 =?utf-8?B?dmdKcG9UY3JIdm9jdnhrdzFZTDVldG1rM1NUUWw0VDR2cms5VU1ldFVsMzFJ?=
 =?utf-8?B?UVBkdVJLU1RaTHhEdW1KQXdTK25EWUZoWGEzVmx2WUNSRFJCR0RmV25hYWZN?=
 =?utf-8?B?WnhVbFlkWWJrTzhZV1gzb0sxWEVSS3FHMXJhMCtlQlc0NTJtclB0TzNSTUNv?=
 =?utf-8?B?MXN4VC8rNCtiZHFVTllyMW9SNlV4Z1NyU1RDeGJkMGo5S3lKVml2elBpcmdB?=
 =?utf-8?B?Y0JlbGlCWFlZdURSblZuMVJWd1JiQ1UzNWR1WGhCVkxib1pjOHZsZFlrM3pn?=
 =?utf-8?B?QWpWMUY2YWNnUGUrcjBQaEJPTHh5Q0c0VmNKV0MyMG1lL2xwTUNreXBKcnRU?=
 =?utf-8?B?OVEvSzV2QUxudTUzaDhMSjdMNWJTUU1XRElMbWhjYXAvNWM3SmdGVHpMM2FF?=
 =?utf-8?B?TkxMenJPbWpWa0NGNGYxVTdhcStoRVZCQUt6N3lDVGxVeUpRMzI4Qk4zZmdk?=
 =?utf-8?B?WVFKU3g4eFpsaExUbmtPcWF3N0hocy9oWnFpVmtXcWZWSHhzTEtOWk13dGlZ?=
 =?utf-8?B?MlhILytJSDlld0VRc2VQQURuOCtNdnZ6bGlnSnZkcS9Ta1ZBR1FGTUUvZi8v?=
 =?utf-8?B?MkxYRVpVV3VHakRudXhPOXkxVC9ocFNuTnhjaGtpNEM4cFkvaFc5Wk5reFps?=
 =?utf-8?B?TTdqMWVZaUZET0hFcFREVmxkd0dUUHIzQlFpd1RQdkpBLzRIektSZk82TzR5?=
 =?utf-8?B?czFsNkpKc2lMbkNZR3hnMkNqSVRSSkVubGUvSFQwOFdOZGdBZGlJSW9HL2Er?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3371146c-8171-4df2-11f7-08db0445948a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 11:15:09.7044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKPUk9WJlR+1JL3dxOTo6DycAtXVYWeY3pO4kfhhVKEdRsrUyYFboZnT/qyRbyt4nb+lnU7RnJZFEsTTB3KR2vSTf1Nyt0JVklxC6qZ+h6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8087
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

From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 31 Jan 2023 19:23:59 +0800

> On Tue, Jan 31, 2023 at 7:08 PM Alexander Lobakin
> <alexandr.lobakin@intel.com> wrote:

[...]

>>>> You said in this thread that you've done several tests - what were they?
>>>
>>> Tests against XDP are running on the server side when MTU varies from
>>> 1500 to 3050 (not including ETH_HLEN, ETH_FCS_LEN and VLAN_HLEN) for a
>>
> 
>> BTW, if ixgbe allows you to set MTU of 3050, it needs to be fixed. Intel
>> drivers at some point didn't include the second VLAN tag into account,
> 
> Yes, I noticed that.
> 
> It should be like "int new_frame_size = new_mtu + ETH_HLEN +
> ETH_FCS_LEN + (VLAN_HLEN * 2)" instead of only one VLAN_HLEN, which is
> used to compute real size in ixgbe_change_mtu() function.
> I'm wondering if I could submit another patch to fix the issue you
> mentioned because the current patch tells a different issue. Does it
> make sense?

Yes, please send as a separate patch. It's somewhat related to the
topic, but better to keep commits atomic.

> 
> If you're available, please help me review the v3 patch I've already
> sent to the mailing-list. Thanks anyway.
> The Link is https://lore.kernel.org/lkml/20230131032357.34029-1-kerneljasonxing@gmail.com/
> .
> 
> Thanks,
> Jason

Thanks,
Olek

