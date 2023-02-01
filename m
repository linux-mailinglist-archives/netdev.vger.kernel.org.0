Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7256864FD
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 12:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjBALFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 06:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBALFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 06:05:34 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359BE55BE;
        Wed,  1 Feb 2023 03:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675249530; x=1706785530;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uwEboZnHiLaEsc2m0cJVsOJHzxeHctMj+n/rrNLJ8Yk=;
  b=KX8jgrfHyyq7DPZhn9LnbQjs7rccqR6OjtQ1syo3mFTW1OOALfJ7TUQb
   G6eLz8D/adOFGUQpSqOKj2WiY4Jny79SSLI8Rtl3QBtp5JG4SfUvVY3oV
   LnxNERmAt4iP2ILbfp7g63SVGBT1X1TR7acKr9cnHGAbmN3sEOldAigby
   nzDDjBlcTX9wlnThdHbparKCTN5Ss+7E/VnVqqLFgbX8t6sCq8gGcUr8c
   kdUKfp+DtytD+2HkxP2ARZ24wu5yU3A1aip6XlH3t1OonLdC0U1BsW70G
   i4wUcUbBaWqY4oT7B2j7RlLUjNTc2Ayr808Ap6B5XjwPBeRfl3SF1vt4n
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="307773546"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="307773546"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 03:05:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="753641021"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="753641021"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Feb 2023 03:05:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 03:05:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 03:05:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 03:05:28 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 03:05:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D827M8RhgBv3YC2zm4j91G+diQql5AyyEktLXGYflO4Fcn8RIaOCp2HXL9I+HgjI3qkDQ+2MqSSWeEzzya9md8rRy8qUGo03eRKX+nzIl48aiyEI/y7D+7FQgrFUuKxpGKEAH1ZHUoV6IGgT8NoXUTQkvSrltfiBvXOZ+525iCgmoYtez9SwFyQ+LzginkDMhgCELCuhR/VBsNATC186Ui5iSexMjBYckSEHVzsaxNU3V8KfebbD7D0bMFBt53wHDQpWV3yicTYl8seMi5+BEQjCq3zskrmDGia3GdTMs37EeSvZ0LV3zGVuAl3h/saiW7/7w9Uhg5azNL2vQcVjxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTDZHNqxU3GzD+RkRlT2Bt1C5vQKELM8b3+/R3Ys8fU=;
 b=llaq7Rdr7aqkPaelxPodaS1hqDAiCcNcljed6VezzFNPLpNS7QZ8E7hMlXowc0XjTudoIWhOab3zX/qj6pU8MS1RBWQJwXkA/sUFHjzHLB8I2p5Zw4w/x9Dn0kT+txhQnMYVBTvByNOsXg6lSDk7Jan+Fc8Yvt+7GxHMSgntIvhrIpDbMfLDZ8ySaNOJUn4md5XfdAwqaKxEljJ7IZEJCWfTVEX40TcRvgv8GqrJ8DkadvKIKMXLrFLX8YcYhTALUiJI749RNBV0Cp1GrqLG164G4LkatsXYWst47nAl6fe2XO7cpabHfSNO/HxaX87shWb5GOgw4XqaPPQ9xt6C3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW3PR11MB4682.namprd11.prod.outlook.com (2603:10b6:303:2e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 11:05:27 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 11:05:26 +0000
Message-ID: <f0d52a83-a027-1872-1321-9bf7884bcffa@intel.com>
Date:   Wed, 1 Feb 2023 12:05:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH bpf-next 00/13] ice: add XDP mbuf support
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
        <magnus.karlsson@intel.com>, <tirthendu.sarkar@intel.com>
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0096.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW3PR11MB4682:EE_
X-MS-Office365-Filtering-Correlation-Id: 201735ee-c5e1-43bd-a07b-08db0444390f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BARJ2hdab02X9603KdvPtMBYns5XNSwXm37KOFXqRPYVKy7OspjN+5oDydMwqz76NsFHsWaY1ATFJbhbTxTWfEt+X/g6bExUHUvTaq89lW0fLuj9PrMlTR6kkhu/y+VT7WFATpfEad2VYymsVnvKA6EyWERd5B7Qk+IVEerwMhzVOdfpRM/rkyULpu0aToVgo0mCsPEQ5EwEAkPqlK4VFZMaZyl3Y2jCbkfCgNVimC/cdNaF9czI85ZtWsLx9WEu8sTwHg+ZvDMKU7GrJ1BixOUaiX5u0prVvEzCN2BCky5BtcuXLXszjzw13u6A25GFgn42YdVwPdzxjTRrpB91jOkqmfRg1fYMQJuatxqcKgeYxO6YTAL2bsvEnoKXstFxWiZ6PMEWd7AWgYXtETE2DJ2S++87lBP1kw4ZUWNX1Hbkyr/qP3C/NM64IDpnJybqeKqo8mXdBmZUBY5mvFvgz1p6lg+TGXbR+Ikjcx22XiPAoDuIBnpi9RYKV8O7uqAdUQA9dibrQqTSZwlK2+z1puojJroF9Gbv9sGW0VYBiCj6sXLDKJ4j6Nah5I33zkVk5sFXBAXntQMekkGPput5oBGS6aL6Y8wLJ/RXyPfjqDa81Ki03yUDUn4l52wP81c/oznqqiBvj8Mqd42vtxBLFNrZ+WC9ShhF/KG7S54/tRMzvWkP+9Cd+XcxIvP2CzLsWsecrK3NmW8elWpP3V8occxfCXJ14BrD4CEnn5sV55I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(316002)(31696002)(6486002)(2616005)(86362001)(107886003)(478600001)(82960400001)(38100700002)(6666004)(6512007)(186003)(6506007)(26005)(5660300002)(37006003)(36756003)(83380400001)(2906002)(6636002)(66476007)(66556008)(31686004)(41300700001)(8676002)(8936002)(4326008)(66946007)(6862004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2ZEVTVJaSs3eXdMU25VTzFhSHdsWTFjQzlTTGJXOWR1NzIyVTRLc2hlcmRR?=
 =?utf-8?B?UUhzZmJLWVROa0YxdVJkR3NBY2hxZVROZGxPbUg1L3BmeVc3VEVnUzNFa3NC?=
 =?utf-8?B?QW5SazBTOHN1d0F0OFNoVU1rcmwrY2g2a3lGbVVETEg3KzJ1NHQ4eE1SRnA5?=
 =?utf-8?B?Vm9XN0I2M1c1TDY3eUxzUVZkQ1pTVGJ4dG1MN1ZYVW42Tlk0RUxZaUdCb3ZC?=
 =?utf-8?B?cG5rMzlTMExMZmlxQkxQZk9SV0VpakZvb2pXMlljWjZlNXp2TklQN0t3cE5R?=
 =?utf-8?B?VVVEaUtOenVZYkNkYUttVFM1QithMzFyMmxQclplaG9XL3hHeDgwMnJEd0Fs?=
 =?utf-8?B?TndDbG9WU1N5RThnbmZHZ3RJVnVWZ21iZkVXaTE0M3JFbFpyR0RRS25JbVR4?=
 =?utf-8?B?dkp3ckg3dm1Ddnl6SytIeXZDWW5jaUlGT1pVM2QwUnhheTl5M0NacG41OVRE?=
 =?utf-8?B?TURsRjdjNWRDWFRpL2tuejNCZThLYzRQZ0dQeXZaa3Nqbi9MSDllVlFLMFhh?=
 =?utf-8?B?S2wzaWtPVFA5TjN6bDN1WGRBMGZrRXR5TFhFTllrQ0xHeW54VXg1OW1zOUJ1?=
 =?utf-8?B?V2FRdndLclNSUUx0dFNPT2N0NDFsMXV0TFBNeXNDMGpCWEFuMDI2bjJBTGxj?=
 =?utf-8?B?TENwSzRnVW0rUm5IeDJEeXh4TnM5bVB1cmM1Q0RCVUg4TENWR3RlT3VJWVE2?=
 =?utf-8?B?QU1KbjlWV1VhVnl1dUFIQmFTM2daV2pOUVpaR09wdXBoVSt3WkR6UmNsN3Yr?=
 =?utf-8?B?a2lTTTd5aWlPNHV2ZS90U2pVN09mQWNRN0ZwL2tUTmc3STFlL0ZCaUNaYnJr?=
 =?utf-8?B?bzVEZTc4T0ltYkp3UW56Q1lXYnVwK05qRFVTeTNHZEEzZk5xU3BXUW5FbTd0?=
 =?utf-8?B?dTFUbUxNUnMrMHpTMllDell0Q0NmSytFTFJxb3JhaW44TGtocmExWEkweU5T?=
 =?utf-8?B?bTdla3U2Q3RkV1h3N211VTI5NnBMZTQvMnpWOWtyOWFUanc1ZGFrbGd1VUFR?=
 =?utf-8?B?T2UxdGwzTFpGdXJHMHAvZWgxZklndkxRODl3bzZJUDcvdGxVRDdkVUYxQ0VC?=
 =?utf-8?B?MllGNVloSCtUcThNd3NPYmVFRU5SaGE3QThPSDFKWkMvV09oaEV1bFdadEZT?=
 =?utf-8?B?VklyV2xTNk5Mc2lSY3B0WWM5OGZMZlcvaTNiRGdYUHh0RmFWMDE0cE51bndD?=
 =?utf-8?B?VEQxM1FXeTArV29jTm5jVWhpM0cwYlhqRDRwRVNEWFBXTmNoRXJuQXhjNm9W?=
 =?utf-8?B?THVZOEQ0NUNLVjNQWVo5TVJnZ0NWaW5MbGd6VEJSeDJUemhWeXFLQUVpa2dD?=
 =?utf-8?B?SlBmUHYvKzdzVEtrVGd1VzhnSGtkRUdwd3RNVHJUMCtXWVBHT1FaTnkxakwz?=
 =?utf-8?B?NW15bFVqTnRWOTQzTFBVbkNLZHZweFFDa25HNCtNR1haY3FpU2tYM2toOXdw?=
 =?utf-8?B?d25PcC85dmNxNTZRcHZkVHFVZlptb3BHREtuWStpRkh6a0pHamlqcnF0ZHJQ?=
 =?utf-8?B?T3FoUTk5OXYvQll6MHRWSE9TdXoxT28zdXJJYXlPdGk2KzFrTGZyTUliQ3NC?=
 =?utf-8?B?RHg1K1hiMlJPNXZsUHVIUHZXUE0yeUlkN09FbE45RjUyK3IxRGJOTGhIcXVJ?=
 =?utf-8?B?Sm8yK3hOb1E5bTFJZVNMekN2NG1rS2VEeXUrZEtVaFRXM2VXeTg5Vm9ER0dt?=
 =?utf-8?B?R3NxYVY4UlRFMXQ2bGFwK0tBY09vLzZhd09nQkQ5ZXFqZ1ozalkrRVppbnRZ?=
 =?utf-8?B?aGFPYkxnMzQvWEVJR1F2dXEwbnFIQTNSOFA0NDg2NTJ1dTBpc1hEcGFDTWJS?=
 =?utf-8?B?Q2oyZEZGM0JKRGxxekoxU1hsZXM1ZHFMUmhDT1A3SmdzTVNlK0pRcUVsaGFo?=
 =?utf-8?B?S1Jzd1VPQzBOR3FBVG5maXRiVUxGSkE2M2RFVEVKL3d3UEhNZEVJSlFKWWpi?=
 =?utf-8?B?QzNYWmxYeDJwaHF6NFpOSWYyMWY0Qkx2TnZTOExtNjRiTWtiemVlM3dLY2dL?=
 =?utf-8?B?bzE4QlBFTm90SDR4Z2hMWkdRZW8yVGM3VGlIVjRHOTAvNnBFNTJWVDVBNnJu?=
 =?utf-8?B?V3AxbjhDa3lFYlRUaGQ3OFAxREdaM0U3cWpvU2UwUTJvN0R3MkJQUzhwRVZR?=
 =?utf-8?B?ZmxoWElQZkRodnM0aVJpcGdmbXN3anJMekNNaVFHbWQ0c2M0Rnk5M1YvK0k0?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 201735ee-c5e1-43bd-a07b-08db0444390f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 11:05:26.7482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cEFMpJb6l9KGWZJV4lTYop+VjbY8GptH5VonLM8RCHVElSVqqn0NRjxPiwjzEjcTE+iyOmB1JXcug7oTa+c08Lr3qWkz+zdEuHBMUD0PoAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4682
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Tue, 31 Jan 2023 21:44:53 +0100

> Hi there,
> 
> although this work started as an effort to add multi-buffer XDP support
> to ice driver, as usual it turned out that some other side stuff needed
> to be addressed, so let me give you an overview.
> 
> First patch adjusts legacy-rx in a way that it will be possible to refer
> to skb_shared_info being at the end of the buffer when gathering up
> frame fragments within xdp_buff.
> 
> Then, patches 2-9 prepare ice driver in a way that actual multi-buffer
> patches will be easier to swallow.
> 
> 10 and 11 are the meat. What is worth mentioning is that this set
> actually *fixes* things as patch 11 removes the logic based on
> next_dd/rs and we previously stepped away from this for ice_xmit_zc().
> Currently, AF_XDP ZC XDP_TX workload is off as there are two cleaning
> sides that can be triggered and two of them work on different internal
> logic. This set unifies that and allows us to improve the performance by
> 2x with a trick on the last (13) patch.
> 
> 12th is a simple cleanup of no longer fields from Tx ring.
> 
> I might be wrong but I have not seen anyone reporting performance impact
> among patches that add XDP multi-buffer support to a particular driver.
> Numbers below were gathered via xdp_rxq_info and xdp_redirect_map on
> 1500 MTU:
> 
> XDP_DROP      +1%
> XDP_PASS      -1,2%
> XDP_TX        -0,5%
> XDP_REDIRECT  -3,3%
> 
> Cherry on top, which is not directly related to mbuf support (last
> patch):
> XDP_TX ZC +126%
> 
> Target the we agreed on was to not degrade performance for any action by
> anything that would be over 5%, so our goal was met. Basically this set
> keeps the performance where it was. Redirect is slower due to more
> frequent tail bumps.
> 
> Thanks!

You forgot to add my

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

for the whole series :D

> 
> 
> Maciej Fijalkowski (13):
>   ice: prepare legacy-rx for upcoming XDP multi-buffer support
>   ice: add xdp_buff to ice_rx_ring struct
>   ice: store page count inside ice_rx_buf
>   ice: pull out next_to_clean bump out of ice_put_rx_buf()
>   ice: inline eop check
>   ice: centrallize Rx buffer recycling
>   ice: use ice_max_xdp_frame_size() in ice_xdp_setup_prog()
>   ice: do not call ice_finalize_xdp_rx() unnecessarily
>   ice: use xdp->frame_sz instead of recalculating truesize
>   ice: add support for XDP multi-buffer on Rx side
>   ice: add support for XDP multi-buffer on Tx side
>   ice: remove next_{dd,rs} fields from ice_tx_ring
>   ice: xsk: do not convert to buff to frame for XDP_TX
> 
>  drivers/net/ethernet/intel/ice/ice_base.c     |  21 +-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |   4 +-
>  drivers/net/ethernet/intel/ice/ice_lib.c      |   8 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     |  47 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 408 ++++++++++--------
>  drivers/net/ethernet/intel/ice/ice_txrx.h     |  54 ++-
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 236 ++++++----
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  75 +++-
>  drivers/net/ethernet/intel/ice/ice_xsk.c      | 192 +++++----
>  9 files changed, 629 insertions(+), 416 deletions(-)
Thanks,
Olek
