Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17E76A1F16
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBXP65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBXP64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:58:56 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A8734F6B
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677254334; x=1708790334;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fw4fKj87wgIvXO3m+2vTkCuEJYM9vnZWDBzmpBBVtDg=;
  b=QdiJOjJ3GwX8TvsHJU8a+xGNb6wH1FSmcFURZ3QSSE1OrkJPH73nrimj
   zhLzNc/iojULlGQgdBzRMWOnIPUNa34ueVaZe07H3uvn9A4ZAO0dc4mrr
   cZTF/nMJqlW+x38+B1FAYIXvaxwIAhUPUIqC4rpQfYVT6++dfdzGk/cIJ
   8PrbCnXQpIxflso6YWDnEMI8gryY+VytJBEOrhaWVRDAjVXfJjhXxmBF0
   oqPIBztPXXRUoGB6VetNX47dvHO2o5b/hx8Oi44O58ZjJxM0GFUkQnCO0
   cweqS3VEuMF8m0JOQJypfgFzMoAEBMofgD3uDy9Ove3Nw2Qom/zbmspFB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="331237333"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="331237333"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 07:58:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="846984629"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="846984629"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 24 Feb 2023 07:58:49 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 07:58:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 07:58:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 07:58:48 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 07:58:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIjPGt/HGnte3DKuVHw30tKKsVbYgzhBrhSqwW8ImtJmmhyBXY/JJ+J7g2Le2yEwuwEw3XH+ywcbta75kaE2JilIK49xiJqspDepLaJJyctdP6bAikC35R/l7X4xVt6+Xp6lpF4rLaFUEfaVM1M5eMJjCyCEIpj7BRUrxeLRYrLL1NEBFTgi6ie2tyduu1YHFUPJcwtYDLjDBWn4DNbfNdhl9LJS5gzeUJTInRRN6WjkW0597Z1La6Ce2pyTXYyFDrhtCrJS5YT7bGNXCISxvzUqhDklWj1wFa22F0R/NbygeFEG0HEkTB5YZ1LQnl6CHMa1zOt1rk6Z5Wnqx22Wtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4jIXcrIPHPQETuvD9Td/2yA6GXAd73wiQZ8doMOtys=;
 b=n/1lyO3eHte64WpS8lD+tkYqIUwMJ7ReqJWrMsixuE389z8DcR4TcH0/mNAlFIiHzk+Yp+kflz1pHw8ekbAwDbe3K2Z6sP/2OlYTiUc11EyVY58xEHiF/Fk/P9rRIMJmCNnHexyINRj6R/HwuP2yyCZwguj9ZuZ1I14kisaXnJUQToTpBUyt45ROmCQ6oki9yYVqG9ROfnPHPIKinoV0Kkom67iVElyDNmlxwjPJuG+NUH2o8JjFQwhtLMUDfJeT3m6TePqecXlWHfMiwpkiqHFfnY6NZGooAtRU48RktUycjr+JAUSkPGewfdRAJZIw911njeeXo3qZkFbngsyPKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6475.namprd11.prod.outlook.com (2603:10b6:510:1f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 15:58:46 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 15:58:45 +0000
Message-ID: <5d8a47f5-b712-b19c-832f-e6492c6e729f@intel.com>
Date:   Fri, 24 Feb 2023 16:57:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: wangxun: Implement the ndo change mtu
 interface
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
CC:     <netdev@vger.kernel.org>, Jiawen Wu <jiawenwu@trustnetic.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20230216084413.10089-1-mengyuanlou@net-swift.com>
 <fb59cc0a-d92b-ca16-4594-79d54d061bd7@intel.com>
 <6BD03026-1958-41CD-92F7-CA629749D7CD@net-swift.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <6BD03026-1958-41CD-92F7-CA629749D7CD@net-swift.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0084.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6475:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b5f38ad-32d6-47dc-dc80-08db16800259
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NeVltfB1OoYyagAdfAEl+xXshUAWodflwpqB/zky1vqwH7lcT1AmvMt7Hu3RsYGOhicOf3PTmHQCNY4cb9Jvj+wuQN1Ps8MglNMM+HChAuykhtyuKKGkvRTWDExCrtDaB1QwY4cYu1K3bAlySqtKaNuR+AK02waMSw/O8iX9fI5ul7NS+7jbdvcGTE3i669Ki7B91m8AlcPXnf1AzkP+e7a7TBHdl3Ve+JHIrbBs911lxKf3tMUsq3L+1Lzykxfe/XDdkj0EslMreuqK7BK+033Q9CwyegDOMjwTk5zsQSgqeeJYt9ZSIAmONIwwkhScGcw5aDckGxW56IpxxgF+2jUHboDtxCzTK55xfe4YFy1GySVj6ZDFQK+D56zU1LG5fdAR7B89GCyFb47o3EtXWQhGKa+MT1NuQtDWLqDjI0OnyjvdfwFFGNzAQspTQyVqx2Sx2vTdfIrK24xSZ66h51tYs0u53DfM9BPYNp3JsQ66iWoinMuPZjecgDtHLnbCQUFzkgC/kgGy48nx3v5ZteMRDTZG3p6iNoXxHuvsRmehaIwtQHEhNnslR4fKRd9F5Dv9bG7e0HmtZJuclUVGv/GZfRMpVynPd7lEHLkdfgQp0lgWamDdeYAVZN665OtPCICnKOf8KKtvGjZKbnNrANSiSFxi2SiiRES+/2NDDo+I0uKJ93QaUnBQ+AflNUDhqjCZQrTvFN3f5z0Rv5ME2e7Vy/ZgcuPUqqX/q/QPBJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199018)(38100700002)(83380400001)(82960400001)(36756003)(86362001)(31696002)(2906002)(8936002)(41300700001)(5660300002)(26005)(6512007)(186003)(6506007)(2616005)(54906003)(6916009)(4326008)(8676002)(316002)(66476007)(66946007)(6486002)(66556008)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEtOSytNZnU2R09PblZRLzdTYzhmQkgyUDJGQ29reWQzL2w2TjdjWVlzVXVU?=
 =?utf-8?B?U2JhU1A2Y1Vxbmtua0d0S1cyV3NybGVLQ1U4SldINVlEeXRxV2RTeVRhdVJa?=
 =?utf-8?B?L25tVmVJdVA2RVF3cHZUWW1NRStUakd3Vmw5OUowaG1hZnJaQ2JYeTU3OWZK?=
 =?utf-8?B?enB0Sk9tanZ3Q212Q0lpM3JDM2Zwb3BjSUU2cy9keExjWUVKNW1ZWTgxQXZO?=
 =?utf-8?B?bjBNRVFjUmRzMTJ4bmQxQmoyS09DNU5hNjIwa0hERm4ra1ZhME5MSXNpV0RI?=
 =?utf-8?B?WjNFeTdPbmRqaXcxV09TSGwvTkZlaWxhNUNDVHZvZGlpdDE0a2grVVI3TVNh?=
 =?utf-8?B?KzJmZ1o4MGJlL2RGUXRIVW16V21QVWE0SUN6aG83cjRvNzVHWnFUQVdtNU8w?=
 =?utf-8?B?aS90RUZBcTBuR3NzdmhmaUREMUc5UDF1S2luSFNYWUgycGVvRVNlbExnSkFr?=
 =?utf-8?B?MkN2b1lmemJmUTlGZUVtY2g4cGhPZkJNY0VHTkNQSzJPcG8vZjRvVm9JaTdU?=
 =?utf-8?B?c09Pb25SOGZmZFhzczZPaXNLcWVkSUlLeUlsWmtzOWQ1eVlyN1FqMEF0Q3Na?=
 =?utf-8?B?d0RqNUZuN3VsRXZQTVR1OWFFQWVwSnFsSGJ2VVFaeGlRQTZCdG5LNFlnOW9E?=
 =?utf-8?B?Z2luT00wNjM4SG5wNTZZMDRkZG5FeTM0VTlPWlgrM1FVaVJhTnp6ZGtzaXNm?=
 =?utf-8?B?MFBhdVFtRWhxSzlNR3cxcHRvaldoVThmUjJwRUhQKzNWWmZ0Y2xkTlpvVHgy?=
 =?utf-8?B?M1BZNkluY0xHQXFDT2twUHE0V2Z1RGdDc0w2SDV5U0Nka0loQ1ZMRjMzQkZq?=
 =?utf-8?B?d0xjZE8zRzZkWGV4TGlRZGdSSHRDWE9nVzkzZVlxYXFVaWtta3dYa05xRTAr?=
 =?utf-8?B?amxRMUV1cktSQXBzdjh0V1poMzNhY0FzeElLMm0zcWVRWFZxMGdKNzgzRmFX?=
 =?utf-8?B?U29pSlVqYkNqMWt5MzhGSDFxZm5xdEJ0QU1hQ3EzRDJibTdDMWxGNThjbitM?=
 =?utf-8?B?ZXczWXFnaTErRVJBTmd6cW1vOGV2WDRKZ2JReUhmTE1OMkJ1SmRFY2Q1WnJQ?=
 =?utf-8?B?WjYzVGNwckFCOURFbk1PekZsVExtYnhUYy85THE4QW5yUWttTDQ0QXRBMzdt?=
 =?utf-8?B?d0U0NFN4empkNkpGM3dHNHlpZi9NNTM4SC9lSWo3amdCWHE4YjdDNEtsTlJ3?=
 =?utf-8?B?dmx6eEJsSVZUZGpvandLNEtLZ1ZtWlJZanFZNlJQZ2dYMjY4YjZreWtTMmw1?=
 =?utf-8?B?QWd1WnYrR2V5b0RtelNWRTA0c3VLdG5Wa3h0aUNSNi8xVkU1aU5YS1N5cUF6?=
 =?utf-8?B?ZGlNeVNSSFNOUkQySy9YeU1rK1NRa05neGw2RDI2dzkvdm81L0ZxbFhkQi9q?=
 =?utf-8?B?dXJrKzYxeHNKU1g0VXJnVlNYMTF1RnIvQnVQRW14ZDhXT05BSEFYSTFQS0Ns?=
 =?utf-8?B?NkdLUnF0eEdBaDFPRTR4Sm1FeUk0VmtpV0JxeGV0YjlLbTlnamdJWCtGR1N4?=
 =?utf-8?B?VEpIaFVEWlU2YmNuVCtKOWdoczFGQmJZdkgvTXpkU2pVM2M1WUQ4dTlPM1A4?=
 =?utf-8?B?V25OcXR0dUJxSnNmdGFIR015VlkvUzVxTjR6cWFlTDcrQ0psTy84S3FqUVNV?=
 =?utf-8?B?TkExcEpYZDlIVkFKVDk2bE1tbFhzNXZuYjVZclBxdzBEVlBsZlUrRkxvNlN1?=
 =?utf-8?B?V29FL1JWLytHQ3A1ZDA2dnp0QkFqV2YvaGlBaDNFWGxDemVib2xCdzR4aENk?=
 =?utf-8?B?WWFYT25ZZUh0NG9WTlkwSURXZkYxdnVJcHZTM2VBdTdBZWdrV2p3REhzeS90?=
 =?utf-8?B?ekZ0K3lsb01ZWHYzQytST0tYZkpocUNTS29jNmRuTHRNRU9naGFEUndaRFhu?=
 =?utf-8?B?S0hER2VkY2JPVlp6UkxYQU1CQnFGKzBKazZoWVU2ZFdYNEQwWlJoaDBkMXVZ?=
 =?utf-8?B?a0IxekpaTldwZE9pdXlaWkcyMWhDNVdUNUNDcDU5cWhTV094SHN0U01wbVla?=
 =?utf-8?B?UGQ2Z1dRdlRvRFRvUjdLTmJGa2hJd2tsOGxwU001b0J1Zy82S01vYS9DRTBL?=
 =?utf-8?B?Q1ZRU1ZRdW9TVGNzNmxVLzBBNkloSFN4d0F4dGxXcTNVblQwdnEvRVdieHls?=
 =?utf-8?B?Vm5XMi81dERLVEZRVXRUak5abTNTeU5VeTErOFRxZ3QzVDcrMm0xVXdnL3pR?=
 =?utf-8?Q?SqdFIcUePlBI9l73JBtRJCQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5f38ad-32d6-47dc-dc80-08db16800259
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 15:58:45.6937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2XAE9kSCz+uAfKyEp/Fo3vT51ia2+nYx/5BrlIXhFgCd1GuOvj6jJ9Cch5XjZtCsz4M14A59SnZTbn74SLrxM0C7ol3x3K2rzNo18spqTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6475
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

From: Mengyuan Lou <mengyuanlou@net-swift.com>
Date: Mon, 20 Feb 2023 15:49:35 +0800

> 
> 
>> 2023年2月17日 01:38，Alexander Lobakin <aleksander.lobakin@intel.com> 写道：
>>
>> From: Mengyuan Lou <mengyuanlou@net-swift.com>
>> Date: Thu, 16 Feb 2023 16:44:13 +0800

[...]

>>> +static int ngbe_change_mtu(struct net_device *netdev, int new_mtu)
>>> +{
>>> + int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
>>
>> You must also account `2 * VLAN_HLEN`. The difference between MTU and
>> frame size is `ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN`, i.e. 26 bytes.
>> ...except for if your device doesn't handle VLANs, but I doubt so.
> 
> The code to support vlan has not been added, so VLAN_HLEN is not considered for now.

What do you mean by "code to support vlan"? You want to say that without
some code, your NIC/driver doesn't receive VLAN-tagged packets at all or
what? VLANs can be handled purely by software if you don't configure
anything on a device. Unless you have some strange HW.

>>
>>> + struct wx *wx = netdev_priv(netdev);
>>> +
>>> + if (max_frame > WX_MAX_JUMBO_FRAME_SIZE)
>>> + return -EINVAL;
>>
>> (Andrew already said that...)
>>
>>> +
>>> + netdev_info(netdev, "Changing MTU from %d to %d.\n",
>>> +     netdev->mtu, new_mtu);
[...]

Thanks,
Olek
