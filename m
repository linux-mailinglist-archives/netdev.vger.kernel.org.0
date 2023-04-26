Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C008E6EF7BD
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbjDZPZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbjDZPZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:25:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FAC26B9
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682522732; x=1714058732;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PGv+vTtsKo5cxeNk/pzykcrtgfGhENH7PuUTEHkfGFQ=;
  b=Y1lGtmIzECVsBKeC41H30jptjw0WDAtYBIZnG54pr67GfQq/VVnwbKW9
   8wqMRTOoZAQ5T4Fl967rvQGDDs+s61PueeN1EAhndRzuuLg03fL5UAAc7
   Lw/VZJKhhWEI8u5KzbsfXhw31Z4uvqnTfLTX4PK0WAYsRAYAlf2r5LaUG
   QjiE1jqvGe/ms8h2I1Xi9Nk4yFokVg/BstWyP/b1GnXMxChX1tGGcAtwz
   9d12vGm+9GfITuudhT/sxh2niVBACe65BP8xhs/4nhCtb1QwAu+99A2IK
   LBN6tr/vBlvnzAF13WOD0zR8fq1/4t/awFnRPG93h83OKH6kAfbz1Hbri
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="349078059"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="349078059"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:25:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="763361698"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="763361698"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 26 Apr 2023 08:25:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 08:25:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 08:25:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 08:25:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 08:25:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2B0Ecn3Qfu9q0MUKThAkV05p4ovyyGxylrp7idOKcUv77fIgD1GMiN67F3CCtptp5XG+rEVprDNw4pTKb/VN+HOKO5S0X+J8kwUj+im2tbfeLpDpyKwSfT1AvDWFk+YPmGZlZ7lFVS67QBd0cao0yyc5V4z1tegmOjHklrwo0a/ZZ1n6Y9lBqyJ0tXdzzJvZgyHKiMjCHcgN31Efjx+TaFfxctmLw2gAjJ7CdykZ4GXbG4XBOhP5j35GHVgynfwIMTcZ0UVnMY4zrAZcJpxiVVUSMKUWyDw2VHUVJ0PrppIWbo83xyCHF5I0PzV/2Z+03NL7raq3C/8QHyRjmXP1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLAu+jMSjUdo5hN+quZmi3Ms8ATwKFgkEhuyXQoVONw=;
 b=RqP22V6xBUJpdxxGgC+e2lYpAc5+rHwxMuwLbGLavnqE213k/67HDLBBlks65j+U+HpIyLDhqY3fUSWraInA0BOp1fM1G9ddozMnZsBV5V9uhfkbhtfQTJK/7cFP192grJbtzOKEUMGD6qybupR38Z7yEE546MbKBvhve6LYCpRs3Xyl/yd0hqxOwcsaS8nPyg1/siiPP4dKfUp5TB7qes8asOwhjcMMfrKrIdVurSuQv1FZMTfvARxFcKsvCm1Ir0MXHW+3N/l5Fdr/1HeQW6X2TUHDzvgcrWfN4lETQCOl3tCEUpVcyiHOnhcXxT7Kbnm9TCgFODeNFlqfP/ciKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB7072.namprd11.prod.outlook.com (2603:10b6:510:214::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 15:25:12 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 15:25:12 +0000
Message-ID: <97e4fc5a-85d2-3b46-12c3-7e893a3305d8@intel.com>
Date:   Wed, 26 Apr 2023 17:24:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in
 switchdev
Content-Language: en-US
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-7-wojciech.drewek@intel.com>
 <ab08efd8-3123-7560-0ef0-036dc156db9f@intel.com>
 <MW4PR11MB5776FC269FE6CFAA5B0E73DDFD649@MW4PR11MB5776.namprd11.prod.outlook.com>
 <MW4PR11MB577640D359484E99EB333D05FD659@MW4PR11MB5776.namprd11.prod.outlook.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <MW4PR11MB577640D359484E99EB333D05FD659@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0243.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: 748059c3-8b2a-4aab-62d4-08db466a6d7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ylR5GsN9vIutbzEglmtE/dDjTE1Q9EJGTPhyVg4v+W280Mwbjp17PmmrbN7998kpq4hQgUTvYgPSSQwvSjPNuTfIR75Z2bXJoT43LGY9t1wiIWkavYtTVUwO6t0q147xf94jF4HdUzRxqqXbaqG/6WoVZhMtQC4GYb36OuhopYbXxqwv4i5xDrvAI5kcILCPtQcWJDDqZqBJDIXlYPOZwD8fluIj2kpHE28Tqdy57gweoXpmbl+blMKSGYWEu8M5jGhzMoU1mJoFOSosMHN1vAR49S7MFzzdWXbz0ngOUKD5ZgiIKouDVjeMEwC8Ay8otMxETSPJcxUHM4HzR7yEHhVHIa+zbu3WtQyAPznP5Lq7Ahf/OCoXhtnJTPw7YzdYEZgO9OCtqBz1GLIxxUmnIvLPQM+MU5VlPV7iNXyja1xk0ZtyEAuzPp7JEKxTfaRaE7rUbnn965IwfimGJK6Hx7B7oge1C+F5YihGyivGUsxHhPYpj3fZ7pDAw0Qr3tI2kuuNWjr4Oc8MdygGokHiqQC9oVAfqMAQpslAQkgEF8AYFxkf3+UlVUbPVFWT75REXd0gj1vIcXa+qKwz2I6iWYhkmE30nfbosjLVcSA8JnJCAy77+3AieFgJDHjQ8aSZyBqFUg7LTbBIZEJVjyXFSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(36756003)(86362001)(31696002)(54906003)(478600001)(37006003)(6666004)(6486002)(8936002)(38100700002)(6862004)(8676002)(41300700001)(66556008)(66946007)(82960400001)(6636002)(316002)(2616005)(4326008)(83380400001)(186003)(66476007)(31686004)(26005)(6512007)(6506007)(53546011)(4744005)(2906002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajNxSFRCRGRVWHQ1cXRBd3d5Q3BvUk9GaWxrR1J3YTAwUmE0MVlIczJTUFRF?=
 =?utf-8?B?S3lvNjFEK1pVcjhUekxmSm9YTnJkUndrZ294eHB4aEtnM3EvVmFZMGJORzVq?=
 =?utf-8?B?eUplSUJiWlFhTThjZkxyY3lDdGZ0cEszK21MbTlGS3gzSjJBSStMUkh5SWJr?=
 =?utf-8?B?NkVzKzBJazhHOE43KzQwa09aMGtway8xaDdSQ3U0ZUYzMEkxZGh2QXhsNXY0?=
 =?utf-8?B?TEo4SCtWRncyeHZic2hMRWUwbjlJak9HTDE5VnBtWlVNb2xPVDJyNXg0NEFJ?=
 =?utf-8?B?Q3pRUWpTTmdyVkVPckRyY0hFc0xZdXJ1YThmWVFsWE1ZSlpML2E3V2dJa0hn?=
 =?utf-8?B?SS9XV3Fjakl2aHlXZHAyVHVrVjZ0dGJRTmRRbkMySzlHV3pTeTZEOUxad2ZV?=
 =?utf-8?B?Znc4YWhUQm5tQndicXpSTHFmUDVJYzVKZk1Ba1ZkcDZETlFEcFZMZFZmRkkw?=
 =?utf-8?B?WmplMStiMUhDL3VreEUyQSs5K3Zxb3NJY3ovVm52OHZnYmZuNGtxeUI4TVNC?=
 =?utf-8?B?aURycFpvZ254cysvMkR5R2dKQnR3WndsNENTMHFCenkwZG5Nb0ZnbHVRbmRm?=
 =?utf-8?B?UDdsbUl5bWUzSjRpcWYwZ3lIZHlUMkJzcFBmaTRCTHVsUU5tQ0I4ZG1XK1px?=
 =?utf-8?B?cWl1am43ejROUW5HSGRBTnYxL3psbHk0N01nTjB4RVNtWVZUazdRQzJ0bWhW?=
 =?utf-8?B?RElJcGFCc2JvQUZnY3RoNkVVMTFUQnBTYmx5VklwS1AybkRqVFFNZDhzMG9u?=
 =?utf-8?B?Mm9xQTVkbUNDR1NwbHF3UnpJS28yK0ptdGp5by9ncjVvTkRCUFl0TVhpMUNR?=
 =?utf-8?B?SXVWM3MrRjZWdUlsRVZCRTJERHd5S3JjZkVJMjdsbWt3azl1bm0xbEV0SGpB?=
 =?utf-8?B?cCsrb0FCZlk1cDZOM1ZIdU1hMkF6WmNjamFRK2YxUWFXNFRadTFFRzRoOEJZ?=
 =?utf-8?B?YklMWkpVVjd5Um96bkx3UWM5bmpPc0VjaEZrRVE0NE1kWXltSEQ3RzJUK3B0?=
 =?utf-8?B?UTFCZENBVXhXZ2hzVFdCVUxvb2JnOS9vSHVBVUJWdXRmd0k0K1k1WTZBMVFn?=
 =?utf-8?B?UjFTY1VmVjJibytPanRwdFJnVGc2cTNXR0hpaXBQMlhOZUJrS2JHRi82bjRa?=
 =?utf-8?B?b0diSGtrYVhyaEp5dkFueW94NVV1Y0NUUk1rOENnVHNvcVQrV203alludmg0?=
 =?utf-8?B?N29NeDI0dE1nTDVVS25VVit2UXpyRWJoTUQ5MzNxK0R0RkJzL1dtSWlobkdF?=
 =?utf-8?B?RjBsRjNoWXhmalE5SlNnYktRV2pGN1NHZDEreWM1UWlnVXYyeEVudlo2blZk?=
 =?utf-8?B?TVRjaFZkZDFwVVlocXNRaC9Xc1dZNE1WZ3R0NjZrRG9JTnc4SzlSVWNQTWpv?=
 =?utf-8?B?cWtPbktSeHV4UFdVems1LzF4SDU0M2RwYjd3QzQ3aWxqd25BNkhhTWk3MVJY?=
 =?utf-8?B?QXozNlptUzc3WGowbVp5NDdjam1Wek9Sb0M0c3hWOE05OUJ1V2V5MDJBb1BX?=
 =?utf-8?B?cGJxeXpCK214ZlJiaEJRbkh3REJ4eTlpSWprc0NuTHJpK29ka09IR3YvTFdm?=
 =?utf-8?B?a3ZTcTd6engyUFNHcGVnT2YwcE53bUkrVkVCdEIxbVhaZllpbGxuOWE4UHZj?=
 =?utf-8?B?eCtRd2NVTkZORzBvK3ZGN3JtMUtlYjhmM2ppRXlzbGdxQ0I4bXR0NFpzc2k0?=
 =?utf-8?B?UTNKL0V5dGRPSGZIZmc1VFRhWVJKQVBkdzdTM3psVHpCWlZuc0pZK1Y1UjJp?=
 =?utf-8?B?OTdPNmoyMVRFcHhFUGRwaFh5UkJ2WkxJaDFzZTA4ZXNmYjc1Z1NZd2RRK2hV?=
 =?utf-8?B?MVdHYnJKQ3F0VDlqZHNKM1RmR25sc056RjdQb2xkQ3NwOWIwdkhBaE1sc01o?=
 =?utf-8?B?QVZnYm1JeFdwMDQxYUdid0VjcHgrYWJmREsyaGxYNG9Nc2E1b2pIWGlFRXV6?=
 =?utf-8?B?ZG8vOEY0Vm03RThydkh4MGhlZVhhc3ZSMFdHMk9YQ2xwUlpHUjRCUHNOaThB?=
 =?utf-8?B?NHFZdGEyeEF4dndBbzNsVC9UTmtoWGd4UXlrY1J0UzJINnRFczhEc2dvM1cr?=
 =?utf-8?B?b083dWorYWUwSUlmcVo5azFDV0F0T0VDajFnT2dIM0RtK0pHU1RRR2Fnd2RV?=
 =?utf-8?B?OU5VRnBOQUNMN3B3akFKMnR5dklRc0ptY3VnQmFZVFVCb0VtbDlEbElsd3BG?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 748059c3-8b2a-4aab-62d4-08db466a6d7c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 15:25:12.3339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsgoPj9gztoahyYDyA2xmTqWdsM+JXMfXKGL/A8e6EZGFXUlJ4Fx8eVYfZVBoph7Q3hvyxtGzrWh55BDdQjEur7296OxgsVYBsyaj9wS6AU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7072
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Wed, 26 Apr 2023 11:50:56 +0200

> 
> 
>> -----Original Message-----
>> From: Drewek, Wojciech
>> Sent: wtorek, 25 kwietnia 2023 11:18
>> To: Lobakin, Aleksander <aleksander.lobakin@intel.com>

[...]

>>> 	guard_rule = ice_eswitch_...
>>> 	err = PTR_ERR(guard_rule);
>>> 	if (err) {
>>> 		...
>>>
>>
>> I like it, less ptr <-> macros
> 
> Actually it won't work, PTR_ERR would not convert pointer to 0 in case of success.

Ooops, PTR_ERR_OR_ZERO() then? I forgot there are several macros for
different cases =\

> 
>>
>>>> +		dev_err(dev, "Failed to create eswitch bridge %sgress guard rule, err: %d\n",
>>>> +			port_type == ICE_ESWITCH_BR_UPLINK_PORT ? "e" : "in",
>>>> +			err);
>>>
>>> You still can print it via "%pe" + @guard_rule instead of @err :p (same
>>> with @fwd_rule above)
[...]

Thanks,
Olek
