Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6E46E003B
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 22:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDLUzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 16:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDLUzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 16:55:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186B9C4;
        Wed, 12 Apr 2023 13:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681332953; x=1712868953;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pDO6FpCnkvUSXgRBpIxfmZf8s5GR0Uff/N1Rp7s+QpI=;
  b=g/U5lEweRr7EFKYTt14qjg+qCowNcF1YZiEhFmX813Woz36qVNnFAf9W
   XGSpHPq/H4dSsDJw5Enuv8H/maYpu1wbRCPI+t04cD3NYzSEDeZUhZtfC
   eenpPahvpzdcp/ffzaKXp7qY5t92AuXHclnDuXAYuDZM5MkmFf5giHcqV
   ZU0qDNkaPX0A3y28ZDFbT01JxLvO9UjhEOc6MpT4i16Gbu0NdKxal6izp
   3KJqTYKk7OPskpNIF5huIbiMgSuH6c0Hm063bS2zRcoXohRaZq5tVqJXO
   1elYTPKKG/FNnCbW6dSt/A0Gm9wY3ZKjYGAr/utZSZnqFQs57yW0fWEJr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="430307803"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430307803"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 13:55:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="863460445"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="863460445"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2023 13:55:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 13:55:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 13:55:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 13:55:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noTE0jvHQle6aaqOddd9m1n5r9D1AwSxmuW8D8h6OuGOOvDVu0+nbIR51KdPxZc7ZapLY0mVkbsxKTAG7Gs9F+krsOJhOMuLqzscd4CMiBo8YyGyRg5ztSjtVz+0d9vTS39NLM4ziwMgBCgh3S2nnZ354YaVY9QBavWi93jcH175ax1o5RukhN2Qui05ztht+QOQB8960vMEtUpjCMd2U9IBdhku7ewW3IeHMQmB24d53+B8UkvpENIW7g7JsWc8emDIJesN9gKEL8mFZvk6G6fWn4GPRcMUDdHG9KoRj+IZapju/JTbKreRq5iKkzF6MWGMK4o2AqbPeMCtQ5H1tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0kMPa4ZoKALyEqbAe150WD95ybBjrz/4FzL5+QqCf0E=;
 b=VkvfOJq//dm17OjoCWWBeseFgjRlya87JEnmDQYdJ03X+wcpGLIb4Rdioy07Gok5zVlt7PFcEPsntnk0UbG1l7d8si2U7PznTTOQEBAhjSsk+GFSRloY6jsK+zbQLA6WwF9sMsvbtlOZlgJziOEhXD8DVlnqqymazVbeJo34UgvBBXWsEu13GxtmMoumzacz4juTY9SqTbbFn/HsHov01D7ywaeMux7gBjH3VDnn51S4ysPFIxqsAolLtb6SWpbJu+l//xJyQHQrsMHUcyMoHQMuC4PEMogkK05YEqMeL1mcitpgK0m9K1u0hUUwBB1Wq4H24xt5bDaNlqq9Wa28Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB4853.namprd11.prod.outlook.com (2603:10b6:510:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 20:55:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 20:55:49 +0000
Message-ID: <677ed6c5-51fc-4b8b-d9a4-42e4cfe9006c@intel.com>
Date:   Wed, 12 Apr 2023 13:55:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v3 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>
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
        Ong Boon Leong <boon.leong.ong@intel.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <xdp-hints@xdp-project.net>
References: <20230412094235.589089-1-yoong.siang.song@intel.com>
 <20230412094235.589089-4-yoong.siang.song@intel.com>
 <ZDbjkwGS5L9wdS5h@google.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <ZDbjkwGS5L9wdS5h@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0063.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::40) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB4853:EE_
X-MS-Office365-Filtering-Correlation-Id: 2280f081-25b7-4c06-c81f-08db3b984b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3DRnJL6yKTvP9Q0UR+LlBxBpj3JZwk5lWg+DQfTnJNWhmUmOekoqQ4EpBKMITrcUEdefWkPHPdohZO0CEjdzpj8UZtUvQcE246sTGXwvum5yylq1tbxIyM6bDsKwNcjCkux1Fz+t4HMMHxYr2q/j3oBmHVNI/wj7FyQU+5M9VoI2dW0WvxO3ukoMxtTyMTBmq4K1mQjPhph+6xKtImSBinCbl9ftql10FLznnXtpQZTjpKeU1IQBT61wePTLMEDY0QX8/oksA03yXN92OkQTb6ivWKGLVaNgxvGIY9ELSGje46EUxJRjgrbybnqV3G5DubTm/mMwSFUPBxp7QxbbF8GVF3C2ToA0C/VyLpqohuHAVSgUVeJop23BAw/1Z5hYWIr7pN8i2ki1fC/zDCfGuSk+GI2cj7wZsLPKgnY3ZjdJppP1Dym+sZA/a5TYmd057fIZssrRkB/5qCjGb4NobNj9uduP+L6V6nZ20pqAfucRNMUT7w2x4TFmEdWJi0c0D2pBpyD9BZ95tK7iH362RpX/RweUlBCEQU7O61IJ6qa4ZaPP9pkwdMoW5fdPYMFZ5EIyefTXX/JD34a9WORhqXcD3ncYA5Gvo8voAGEMZmXYUikPY/PRS98JnRls7x3YqQFycdcie/ual9HO45fhFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(346002)(396003)(366004)(451199021)(5660300002)(7416002)(8936002)(478600001)(110136005)(31686004)(6636002)(54906003)(6666004)(41300700001)(83380400001)(4326008)(8676002)(66946007)(66556008)(6486002)(66476007)(316002)(6506007)(6512007)(186003)(53546011)(26005)(2906002)(2616005)(38100700002)(31696002)(36756003)(82960400001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG1hT2N3eCthQ0xSa2pqSlRxU3I2YVo2eFJ0WHFCSENoRE5FOXBrVHZzMW9W?=
 =?utf-8?B?bHozYjhwSTNwMjd2WEw0a25vSXNWOUtwT1F6c0Z3QmJBR3VHZWs3VlVpN1ZN?=
 =?utf-8?B?dTQxaEZXTDV4SVgyeFp6QzNXd0kvRUlRamhENmdrNjVhWW8yNEtUSHFjcmFO?=
 =?utf-8?B?MHduMXNnaXd2alRGakFMaElNcG5OdytYV1JuQ2NKcTVMb2JncnZTRDArQ0sx?=
 =?utf-8?B?V2ErTml5T1lxYjdQZlVTbCs1TGhCYjJ0VkFXdkt3Qm9YS3hxZXdFNkhZZWEx?=
 =?utf-8?B?YlUxYXVJbjBuSFpTSDlKVVp4WGVWNjE5YkVhc1FFMzBjemNNUDljYzQzK29w?=
 =?utf-8?B?a2M3OFFhTGFCYTE0aWVEQ1lCMTVvQ0VraC9sVFdxUU91RSt4aXIxMmRVbkxh?=
 =?utf-8?B?eDBQelUrVkplTFd6RkhHQmRhQmU2K0VTQmt4NDdtbjIwaDFYemREejYxa01V?=
 =?utf-8?B?RS9Ka0k1ak5mYUp0WG82TlZYcjgveGtsT0VMMjZlQmRxSzNaU3luT3ZxSlI5?=
 =?utf-8?B?MHFaNFpzZ3hpM1cxclB2S0tidU9QV0liUGQ5K2FITVVrejEwTFhOaGVyTnEv?=
 =?utf-8?B?RFkrbkVBdkUyQml4UWV1aHhQK0ozeEdaVUNrNUR0cE05cGNMYjlSYUJLWHpk?=
 =?utf-8?B?S2x4dUp4WlZkWnY4ZW9xT21SQnBzWVRDaGxXWm01Y3ZwOUoyVHh4VEp1eU4w?=
 =?utf-8?B?TXE4Z1NaL1Z4VGRkR2d1RFUwTVZjSkdEYU9maHliK05VbHRLdUVrV0RMaHN6?=
 =?utf-8?B?SkJnNWl0ejBlSVpVVWlZaHcwY05vSGZGalpudUYvWWZoZjhvMkV1OGc2bzZ5?=
 =?utf-8?B?alVzeE1GWFRvNmFxUXcrODY1TEF0dFBudXRzSkNYQTJVYWpOaFR1cjc3TTd4?=
 =?utf-8?B?TkcyenF0ZStvOEovOU45VDY1SG1kMlU3NXB2c0NvLzU3WkhqbXdyVmZmdjEv?=
 =?utf-8?B?b1RuWWhhR1VOcG1uYlZXOWxjWFd1NTFrdWpzSncxakN2bk1mc3FWTGIwaXRO?=
 =?utf-8?B?MjJoNDVBeVpScGFIMnR4QktxTmJ3R2FkYURhWHZPaEFHbVBJWWU0blJOdlE2?=
 =?utf-8?B?bkZndlFzS3JlUXVVQlBkbk55azIvWnZNamEza2tpdE12Z0xTZWNRTUdLdDJN?=
 =?utf-8?B?bnlaVExRSkdjTG03T0l0MlluM1U2SkZBNzFZeHUwWTh5Y1RaNGpiaURZVGlD?=
 =?utf-8?B?ZzdnZGtjT0ZWdHFIRDNjckdjUURmZWw4OVJnY1p2UVdJQllydDQya3gzbmN3?=
 =?utf-8?B?dlVXVCtXeDhSTXNVcGdxT3IrRThaY3RrY0J3TTNHTGVTamtBVTdqYlJvSEhm?=
 =?utf-8?B?bkc3dmUwRkxaYS8xN2RWdWEyUWtBM0VCK09TbExvWFE4YkdOTUtQR2kvWEJY?=
 =?utf-8?B?WXBZbGsvWDF2U3h1ZmRpS2NGQ3g0YUgzVEdnOU5aVVJMbVZ2cGFmNjAvWG1u?=
 =?utf-8?B?bVVkT0ZOWVgwbzlsNjQ1NlFLb2xPWWl2K3RQdG44SStSd0VkQ0x1YzJiRmg4?=
 =?utf-8?B?RDlpcytvcEtiZDJUcGpDRDhseW5KOEo3V1dqdzhkeTRqVi9YMTFIeHFvMXVl?=
 =?utf-8?B?djlxVHVZenZqdUNHMDJDN3R4Nml3MmlyZjJpV1R1SzlhSmxjbDJvRjYwR1B0?=
 =?utf-8?B?VXVkaElnL1J5L2RLcVFTRHpqRXFNc0JUMnFLZlliTmtwY0d6MlhIV0paSmox?=
 =?utf-8?B?UncwazAyUy9NdnBLNCtwbVUzMHRWT2M5Y0NtNTJuK3k0bGhycTNJOWhQMU1w?=
 =?utf-8?B?a0V4MTZITnJvVnRFMmFRdnpwWTJwZHZXYzlCOUNPYlRyM2RUZnlaSW5WYmdX?=
 =?utf-8?B?NXY0aWxlSFlHbCtjaGNsT2Z3SlJPRmVWMlBVQ21EY2NJNjcyeUNDdG9yYVpO?=
 =?utf-8?B?M0JFQTJTaXl4ZFRkYzRPY1JZbWRUcEQrU2VLcm5HT0tldlp3dnQwcEFEdVZn?=
 =?utf-8?B?N2I4TUc1d3NCNE5aQzk5QzdZNm5TTzJpMERPRm9XZ2tUR0hiZ1p6ZzVXUVhE?=
 =?utf-8?B?dWN2ZnYrZUtkTCtYaWRvSjhtVDdOZnJHSFZZQkVGUkNJYW5Yd2FPMlpUK2FR?=
 =?utf-8?B?WGVrWVZzS291cHV0Wm1CTEJiTmxoV0hIR2RHYlFVV2IzNFp0UnZrUkJOZlJr?=
 =?utf-8?B?cG5Ba0hOZlF5R3J0aWZBMmZiRmxTcXhXeHFQc1ZaQkRRKzFqV1dSQU1sVTlR?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2280f081-25b7-4c06-c81f-08db3b984b74
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 20:55:49.2453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBU5D3tbj6PmJybMk4E/QrsFCfmG5M2WzzC+cfNQ/NxRp+cUEqqXEsR8b7sQXeryG7V94otNvEoZOrpSgzmsl4UdLzbjWocm4zqTUV3ICig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4853
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



On 4/12/2023 10:00 AM, Stanislav Fomichev wrote:
> On 04/12, Song Yoong Siang wrote:
>> Add receive hardware timestamp metadata support via kfunc to XDP receive
>> packets.
>>
>> Suggested-by: Stanislav Fomichev <sdf@google.com>
>> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 +++
>>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 26 ++++++++++++++++++-
>>  2 files changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>> index ac8ccf851708..826ac0ec88c6 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>> @@ -94,6 +94,9 @@ struct stmmac_rx_buffer {
>>  
>>  struct stmmac_xdp_buff {
>>  	struct xdp_buff xdp;
>> +	struct stmmac_priv *priv;
>> +	struct dma_desc *p;
>> +	struct dma_desc *np;
>>  };
>>  
>>  struct stmmac_rx_queue {
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index f7bbdf04d20c..ed660927b628 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -5315,10 +5315,15 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>>  
>>  			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
>>  			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
>> -					 buf->page_offset, buf1_len, false);
>> +					 buf->page_offset, buf1_len, true);
>>  
>>  			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
>>  				  buf->page_offset;
>> +
>> +			ctx.priv = priv;
>> +			ctx.p = p;
>> +			ctx.np = np;
>> +
>>  			skb = stmmac_xdp_run_prog(priv, &ctx.xdp);
>>  			/* Due xdp_adjust_tail: DMA sync for_device
>>  			 * cover max len CPU touch
>> @@ -7071,6 +7076,23 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
>>  	}
>>  }
>>  
>> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
>> +{
>> +	const struct stmmac_xdp_buff *ctx = (void *)_ctx;
>> +
>> +	*timestamp = 0;
>> +	stmmac_get_rx_hwtstamp(ctx->priv, ctx->p, ctx->np, timestamp);
>> +
> 
> [..]
> 
>> +	if (*timestamp)
> 
> Nit: does it make sense to change stmmac_get_rx_hwtstamp to return bool
> to indicate success/failure? Then you can do:
> 
> if (!stmmac_get_rx_hwtstamp())
> 	reutrn -ENODATA;

I would make it return the -ENODATA directly since typically bool
true/false functions have names like "stmmac_has_rx_hwtstamp" or similar
name that infers you're answering a true/false question.

That might also let you avoid zeroing the timestamp value first?

Thanks,
Jake
