Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EA86E12A9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjDMQrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjDMQrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:47:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397E993CA;
        Thu, 13 Apr 2023 09:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681404430; x=1712940430;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=58sBDBle1B6AEw3V6//5BrXaYrxLe6W1w5WyrxYfdzM=;
  b=Mb0kPelNn8/uKXXZSwy0vodDW7X3AZSq3bzoJxlvTrnBCoTnZb3ydkkE
   idc7QKS6x339N3BTUYFd/FaJuT/6iotOa2VLV+5oONss+dAUZabla3pgf
   VDVNFvLWAVe4oH0edKmORLYRSeobtKu6rV/eE+MJMxo8xRVnNqQLN6L8L
   EiWGXt5i9zhDbcH/bIvDfCSAbEtnw0BSGTLwxTZoSB8/MirtUYIuCvMzC
   Bfgi/8iluHTGZLwfFJpKODZ6+zsqqnA8mZInXOOwp8V+yfn+cr37LkJzm
   JeAls6CyCn/iR5iRqywtOMVEHArnvns3gwIEL/Lc88QdKbXE+HWClWjsX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341734674"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="341734674"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 09:47:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="666843063"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="666843063"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 13 Apr 2023 09:47:09 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 09:47:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 09:47:08 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 09:47:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZvw8ZsDzev80bSWzVFOphATXR8MmqvjQA5/eljCFgKV/+eNW9FQ4wqVk4TzyBgyKGOQS1BLjp16evFz4AH7i6Z9DL2XNzJW8jR5tIP6QyMGwMLKAbCDbQybiy9bTYDr2PLEcVsexLQO26wWWZZsowyCsC578dGGs+LjQxUpW0+jmgaOro61RIqkMqQhlruzuX+I8Oh1zKN9IZksUrFQBd1Z7fKeBFFGG0LOkqR8Hq0qAMEmdZ8+iiaqEltnM+j9ch0tceKLvBlo2CEKrYu/z+Fby8S2oaCj8zP6+Qd6rAHWTtI8EtiAIcWByRzJv4PZJMNhTyJ85rmy79Llzr9xkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cKLsc2WvGNz3ChjTWj6YXRryLvB0YdjjztDnRbNukL0=;
 b=k0dzNe+mVwuy0YT5CKt8u75fPE/jRA4Lwsek1ok8FHjq35zeBjdwyTDjPe2eWC2WPDHs5bv2I6AfhKCFzX0Xsb89MSmhXxSl3KuWBWVW63dr2Cq+CGJ3z/wH3914+GOS2NXq3f7qOFZtnqszHQdF8XqMImwKdXywZtckN2ukZcGSVyMSydzp22Aekw2nImPRg6ECzkSsVjldrYRHA6T3uC9b8qQyfb+D/zScD5g0Qcd8viEN9z0F9UvcunLaKquGBKGUPHQrMnvLH36vIAsV4ebtVENOCu6Kxat7+4a25LnzbDbaquVKOGeIkTt9LJv2ZhlinV2ghkf2K6jGn5vr8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6142.namprd11.prod.outlook.com (2603:10b6:8:b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 16:47:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 16:47:05 +0000
Message-ID: <8d653ecc-4ba4-11fc-1f6f-1792bb18fabd@intel.com>
Date:   Thu, 13 Apr 2023 09:47:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v3 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Content-Language: en-US
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        Stanislav Fomichev <sdf@google.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
References: <20230412094235.589089-1-yoong.siang.song@intel.com>
 <20230412094235.589089-4-yoong.siang.song@intel.com>
 <ZDbjkwGS5L9wdS5h@google.com>
 <677ed6c5-51fc-4b8b-d9a4-42e4cfe9006c@intel.com>
 <CAKH8qBtXTAZr5r1VC9ynSvGv5jWMD54d=-2qmBc9Zr3ui9HnEg@mail.gmail.com>
 <PH0PR11MB5830A823C4FC0483BA702293D8989@PH0PR11MB5830.namprd11.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <PH0PR11MB5830A823C4FC0483BA702293D8989@PH0PR11MB5830.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0212.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::7) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB6142:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c1d2fa-162d-48d3-e0ac-08db3c3eb6b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SgFVPX8USx3SS/2Kx7eD9Bu4x9R9OKUXVw4rJjvzTY/9kfWjRLJlaBVgj3wtw74JDpnHLy8k9FbGnxq6U3AMMPx0Ke88z+1EirKyNGhvqcHVMlhe6prV89tDSL3nhYKhbWjdCM4S+Xi7RE71FW2ahkiDk+qIx0yFQW8OMLZ786EXE3Xkz13oNlZPYCn3MwoJfD1+g+3sEbOze57xZLmQZQOmfCo6VIGr9ESlhkNk4ggMATZKlhQDmQ63sPrSGh+wSn5Wk+hLSP4y3aa5Qr7LBiRI+lEcEaeh5r1Td/8Yl6381CoH4puLQDJM4jufHXt7QciV9YthpGKMuTtQHoSOWd7+ckhxXNMyWzvZWTMKZcMrGX/+7N4CuWT3dPkkd6RqHQCaHb8PrbkT7YRqBA55tGfF41LnWX8Ixo+jIkrXPTp8xJPzLw41MpF1GromjY9KSNWXLgXdUIE1pG8THBPxA/BO00tKHgaM+LHqHTtt7KpFM3f4nDknLcY5okMr9JOlpqJnr9aQyNqluQ1wyTfbz843sOAEUG7gxTIbosc+pLYsOhWF/WIxdRlsXD/g5n6+JpLu4tFGyilDnzsK7f6M/8xywEhynq1Y+9YRkpP4hlwBWl+2GboQI6ioVvPaPB1goGfpQIGSQbhR2CArMCKDJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(82960400001)(66556008)(66476007)(66946007)(8936002)(5660300002)(38100700002)(7416002)(4326008)(8676002)(31686004)(41300700001)(2616005)(83380400001)(110136005)(316002)(54906003)(36756003)(478600001)(2906002)(53546011)(6512007)(31696002)(186003)(86362001)(6506007)(26005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mjkra3dONVdlZ3Y1S04yVlNrWFpvZzRUNkVEODNaSmJVK1BOTWlVZ294TXhX?=
 =?utf-8?B?TjFJRTFSaUpsZ3pURUlMak9FcjRQWlVCV1BOS0NyV0hHQWJJckd5RURHTVp4?=
 =?utf-8?B?YlMrWkhzTi9tK1hiZzJSQk1iUDFBRi9Za05sR3g1TzliSXNnenVFUkNnWVBv?=
 =?utf-8?B?bStaakI4MzZub1pPUEUwRndXOE9wVlhGNjFHWU9qbXRRMFJQT20ralJXQUFZ?=
 =?utf-8?B?aU9iYndzUkVGRzYwU2RRZGFGWWM4OU9DdFl3TE5CcW8wTXpxUUJzNEJnLyto?=
 =?utf-8?B?UmE4MS9mTGphcjRUWGZiREJOWDl1S3BzU2RLU2E3bWFIUWpZaG02eTNmZ0pt?=
 =?utf-8?B?TCs2NTdpdkJXbWpSUCtTVkYrWXNLN2QwWnE1VUJSVDIwQjFrNVcyZnpFcDd5?=
 =?utf-8?B?OFlrUUY5OUVYdkx6ampNd3dlM3VzSzJFVzhSZHE4bGg0RExhY2RaanFjMndD?=
 =?utf-8?B?SGRCcFVkY3NGeXdBUm9rSFVkZU1tL01lRlFKcU4xL1FPV0g4OEtDLzNSeGIz?=
 =?utf-8?B?QTdkLzlnZk1hQ1NpNWFpOERraTAvK2lzS05pY2dGcytSNHpjaDVlSHliamFh?=
 =?utf-8?B?bkgwRjdmeTZGMlNXblBGWENQUXhQN2hmTGxObDY0YlJMby9wcmJac0tKYS8v?=
 =?utf-8?B?aHk5YWtlSmVKTXJLbGFtVkNhSXI4TWU1Y2V1N0QzUUxDbzk4VldTZ084Y2po?=
 =?utf-8?B?N1BpNmVwT0lGRC9icDBGSXJuQW9UOWdSaDIwN1pCdmpwdHQvb3l6Umo0ajNh?=
 =?utf-8?B?RFZEL2ZkVG1xSTVObG1jZXZkOGNZWnMrd2xMS1N0cWFWalVLa3ZQY09PWkh6?=
 =?utf-8?B?dUFQbmJpSVIyNWQvNW5oQm83TWFObkJuMmpQVnNiNDJjbnJkSHpVNStrNnla?=
 =?utf-8?B?MXp4TVNSaHFMVWRDK296TVg2Z0JaTS9wQVhOaTRDK3BUT2l6azI5ZS82K3kz?=
 =?utf-8?B?dnZjZXd6NWRUc1pTams1K3htOGxwbkxXOW56dmhDY0JwbzlNUE1yb3lhUGVz?=
 =?utf-8?B?cU1NdnZzOHR5V2ZXMVQvU2pRTkRCRGZzc1NDSTRldzZoUWtOaUtUdjZyd01W?=
 =?utf-8?B?QWVjdHVHWnRVcWdiZ0RVVUtLOEM5MWY2VVBwalZQOVA0aSsyQzRocm1yak5S?=
 =?utf-8?B?Tk1BSXowd2tZWVFLSHk3QlhVbW43Y2cxZ0w5eFJ6M2dLWlVsak1TdGMvNXZF?=
 =?utf-8?B?MEJrZVo2ZzNXQllOVVE0cjJydDVFWGhMOHBsaGFLbHQzWksvcmFHRDJMRkgv?=
 =?utf-8?B?L0s5WTJVMWdJeUVUSXplMjA5dC8wd2tRUFdEOHB1M0VUeWV4Q1NOd0VFZkpV?=
 =?utf-8?B?M1d2UzhOcFdtV1FXSHkrblErYml1MlMvTHNpb2VlazFqSlR1cUpKRnpnVFJu?=
 =?utf-8?B?TkN0RWhESG1mZDlFMTk1OCszZjA4RG5paWwvR2tBUmFHQ1B0dzlhbnBtNlln?=
 =?utf-8?B?TXVnZ0hZc1VNdEx1SkU4K1pSVks4RXdLMnlIZXJVdW5tWEJlTm5YTGFiSW10?=
 =?utf-8?B?YjAyVjh1ZmlnZ1VUdHI5bVQzMVVydlpaWktuMGIySVN5OGMvQmRZNE5zZUg3?=
 =?utf-8?B?K3JCRGFJazBLb0dEaTI3Q0t3Z290WlRVdlpXY0lVUEN0ZCtpUFZkNngwc0hL?=
 =?utf-8?B?Y1VSaytrNG9tNVlDSDFUWksydGhoTXV3TnhJaTM5VVgrQlBHS095WHNsdk92?=
 =?utf-8?B?bjVmS1poMjZ3MWlwYUFlY3BNV0JqZjVZbEZicTI0N2haaE1DZ0hHYUNvUWhF?=
 =?utf-8?B?SmJaUml4MXhCK2pxaWNTMXRIRzlRSGVETXBWayszMzZzalcwTmlQQllNOHBB?=
 =?utf-8?B?S3lGR21tTmcyTWVHQW84Rk1SampUKyswTXNMUXRSaEVkRnc1d2c3R0xWNDFa?=
 =?utf-8?B?OElubWFkTXV4eE5VSXlQY1YyZTVUZS9id25LY20wWVNERGlPMWJHbEh2K0RH?=
 =?utf-8?B?aVFZZ0pIYm5rWmdLU3IvVno5WkNveHYyOFNVblpGYXpiR3ZkcFU0OWViVHU0?=
 =?utf-8?B?NTRpRUprZFVuQzZ4d2xEUTd0VU5RWkxWYk1VTnJnV3l4Nm5kb25PMW51UU5v?=
 =?utf-8?B?Tk5jcm1kM1JsdVJ3QnIxTkVmUm9TaXFqVmtuaDhmVGVHd0NXa0hJRUsxdlFk?=
 =?utf-8?B?ZGZzTFZSdllZaVJncUhFVlZ2L2k0VDREbm9PeDdPQ1RicWZDbVlZbExBSGlO?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c1d2fa-162d-48d3-e0ac-08db3c3eb6b1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 16:47:05.7561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q43XQ+zFHq3zTfFKIXxIW2LlCLOOuewgyXKr2LudUIZYQk1xyvnkpttcbFZtA9GjZ0sB4mM8MaSdFZgn9GJAbkQqIQQDgYXLMJMtDuXrWts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6142
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 6:39 PM, Song, Yoong Siang wrote:
> On Thursday, April 13, 2023 5:46 AM, Stanislav Fomichev <sdf@google.com> wrote:
>> On Wed, Apr 12, 2023 at 1:56 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>>>
>>>
>>>
>>> On 4/12/2023 10:00 AM, Stanislav Fomichev wrote:
>>>> On 04/12, Song Yoong Siang wrote:
>>>>> Add receive hardware timestamp metadata support via kfunc to XDP
>>>>> receive packets.
>>>>>
>>>>> Suggested-by: Stanislav Fomichev <sdf@google.com>
>>>>> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
>>>>> ---
>>>>>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 +++
>>>>> .../net/ethernet/stmicro/stmmac/stmmac_main.c | 26
>>>>> ++++++++++++++++++-
>>>>>  2 files changed, 28 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>>>> b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>>>> index ac8ccf851708..826ac0ec88c6 100644
>>>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>>>> @@ -94,6 +94,9 @@ struct stmmac_rx_buffer {
>>>>>
>>>>>  struct stmmac_xdp_buff {
>>>>>      struct xdp_buff xdp;
>>>>> +    struct stmmac_priv *priv;
>>>>> +    struct dma_desc *p;
>>>>> +    struct dma_desc *np;
>>>>>  };
>>>>>
>>>>>  struct stmmac_rx_queue {
>>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> index f7bbdf04d20c..ed660927b628 100644
>>>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> @@ -5315,10 +5315,15 @@ static int stmmac_rx(struct stmmac_priv
>>>>> *priv, int limit, u32 queue)
>>>>>
>>>>>                      xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
>>>>>                      xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
>>>>> -                                     buf->page_offset, buf1_len, false);
>>>>> +                                     buf->page_offset, buf1_len,
>>>>> + true);
>>>>>
>>>>>                      pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
>>>>>                                buf->page_offset;
>>>>> +
>>>>> +                    ctx.priv = priv;
>>>>> +                    ctx.p = p;
>>>>> +                    ctx.np = np;
>>>>> +
>>>>>                      skb = stmmac_xdp_run_prog(priv, &ctx.xdp);
>>>>>                      /* Due xdp_adjust_tail: DMA sync for_device
>>>>>                       * cover max len CPU touch @@ -7071,6 +7076,23
>>>>> @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
>>>>>      }
>>>>>  }
>>>>>
>>>>> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64
>>>>> +*timestamp) {
>>>>> +    const struct stmmac_xdp_buff *ctx = (void *)_ctx;
>>>>> +
>>>>> +    *timestamp = 0;
>>>>> +    stmmac_get_rx_hwtstamp(ctx->priv, ctx->p, ctx->np, timestamp);
>>>>> +
>>>>
>>>> [..]
>>>>
>>>>> +    if (*timestamp)
>>>>
>>>> Nit: does it make sense to change stmmac_get_rx_hwtstamp to return
>>>> bool to indicate success/failure? Then you can do:
>>>>
>>>> if (!stmmac_get_rx_hwtstamp())
>>>>       reutrn -ENODATA;
>>>
>>> I would make it return the -ENODATA directly since typically bool
>>> true/false functions have names like "stmmac_has_rx_hwtstamp" or
>>> similar name that infers you're answering a true/false question.
>>>
>>> That might also let you avoid zeroing the timestamp value first?
>>
>> SGTM!
> 
> stmmac_get_rx_hwtstamp() is used in other places where return
> value is not needed. Additional if statement checking on return value
> will add cost, but ignoring return value will hit "unused result" warning.
> 

Isn't unused return values only checked if the function is annotated as
"__must_check"?

> I think it will be more make sense if I directly retrieve the timestamp value
> in stmmac_xdp_rx_timestamp(), instead of reuse stmmac_get_rx_hwtstamp().
> 

That makes sense too, the XDP flow is a bit special cased relative to
the other ones.

> Let me send out v4 for review.
> 
> Thanks & Regards
> Siang
> 
>>
>>> Thanks,
>>> Jake
