Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEF5683574
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjAaSgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjAaSgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:36:24 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D9430F7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 10:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675190165; x=1706726165;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7cSXu+RPI/+RFxxMUt+7jPkg/BFxBWAo1flQlXtWiEw=;
  b=aoOfjZGTFnQp8FeWICZXBLwpq/n10Ya4Y1FW1QyYEuMKaRGysd9DNmmq
   F1OLU3IaDj/+lsoE95cViflasLCkVrGTRZBw4GfokkuO5QKiHil2DfEZB
   jNH00QdKGyff4zEJoBwvE8YCeXeDNHE5MaJvMuGCJlSGMQWfaT7+g3vSC
   kifOajcv/r+IoUVdgYZMAfSYbvTUwXI6e7VPsLU7gNva3gQicSMec3L91
   gTeKKQ1gR91DSLzRsBDGhvByeYyIwPHEsqtVE+ck3lGrB8jBKrC7nQ1Rq
   JlRFnZModzrOa7CyJrzFa6+Gtt5T3RequSbQJ7Emp8CV+7bpwMFdpMWdW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="325623010"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="325623010"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 10:36:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="657990459"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="657990459"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 31 Jan 2023 10:36:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 10:36:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 10:36:04 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 10:36:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGQ17gshOu2QMJUtFR4KY6CykltmJOCD1A1CnyAMPPS+8KmQP3KstQyxvfOEcjBqDA/f8GvCbUaK2ct29svIfe0pOdc115hnQjyRDZ3CsIFWEAq/h5d5aXOzJRV+GXYEPoXZtf0BEHffgQOTYD3Gx003MT1Gt/k+UVivdETcSFWXmuNUnxhXQCnLHhVCoXK/8eDSmdRv6KBlUogSd3yQTXW28F0Su2DnP4ESJBiz/HvD0EZHUISJO2hhI080T/PblqGA8ZBTeRJm8mQevPgOQHNVdqZ0mC2VMLK6HPFfY38mBNILUBl+gTNB4MoHfgRMDtfOz6BZmHZxlmZHadV9Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrvEYdEc6I1IZUywiTa1OLXijuvR5b1Avk/zTq6AXpc=;
 b=mxmwCppn3cW1c6E4uYWUYcOlivJ0pjlducTdmRCq3yPV1PJF/xHBNkLwRHA/vid0JSKfOe0GutjZUx35+x1RxkOLiMQCziq1yENrgt2LAHpu+oRKekbZb4hZ4qOj0giY+l1yzxzJk341oDzHi85dE1nhPdULCKaGLV/a9bxPZmY1Jn+xqX+sx8EzH9N32EzYqGMydLFnjp10LYCKfDHui+W3+GyOIM20ZG5/HeOgPP5v8QGBGTI1OXicB3MSkxeAp4NCwBONxe2CkuP/gBh+1t3vm5OfMUVZcQiCA4+wy0pHCXFaFQyc3cB45MOStkz0NB9Hl3kCq3mP06JEim77tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6016.namprd11.prod.outlook.com (2603:10b6:8:75::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 18:36:02 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 18:36:02 +0000
Message-ID: <345c4cb7-13a2-ff93-13bb-fc8fbdb9dca0@intel.com>
Date:   Tue, 31 Jan 2023 10:36:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: PHY firmware update method
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>
References: <YzQ96z73MneBIfvZ@lunn.ch> <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch> <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch> <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch> <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
 <Y9BCrtlXXGO5WOKN@lunn.ch> <7bd02bf6880a092b64a0c27d3715f5b6@walle.cc>
 <Y9lB0MmgyCZxnk3N@shell.armlinux.org.uk>
 <c60f97a680a6004a2c1d04d2007b6d09@walle.cc>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <c60f97a680a6004a2c1d04d2007b6d09@walle.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:a03:255::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6016:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ff03caa-00a4-4178-a432-08db03ba0126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0Wo559+jkPkMPrmoP/xGBFT/2TkRWrV9iw+NQfwzGBCMudRU308S5UNmBnca0hsEw22w+iX677PgvMYaRc5dvNpl785G6FGRFX3T+mFD8r6sEhgTvtPVJOFrz82g/43l12mFPm1BGpzghVWJ0gFmxEAp9ofTGB59I0befLFJuHNsn6dUoFRx0H9WdE8KHDLO+x/d3NxwhrsX8hoY6QxYwagbMsgynCBBgVEQUr3iGfTe/O3DEBFCi+Q1UkAkVwnuoAUkyZSH+Ga0Vi1Cs36phpwQXP+L4LDu/MKkH1n2imjexYusrXDRREuFwwb8H4AFZaLtee/AnnR5PhM19mMsLhIJILbU+DTFpiruox00GHd0nOxO0hp86JIyte8ZQ4jFdiDQ3o/ETfpSFv0NIG2OU1BZy3VaM/P+oCulG6x+x6B6bGICsYJx1YekfCjVXzwrm2xLDjoN/ruTMOJAiFGrQwHOXAn40KWZM6RL3ou2nlWFiVqjvRpvQNgehmuu3gHkRRAMJRxZRc5+ztHk/KFpqqMsTPBJ/6g8I2+IJxEKn46FOoPHPQAWIrq3L5nFi/2m+430xvB7AiqBFv2jt2EO3mxNwC9QLVmXwICUH8CHWUeWU0YYH8Gl3RPCpDGyeMzukTn4Tg391y83vvYwi8emODfy0Ut6C4u3iaXBrni0gcZt9iRvU/NpJObwy0e8pXIEUyl2t6qF3Pbzc0S3tPurOXKPx0iEKCHHpnHikxYDFk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199018)(8676002)(110136005)(54906003)(66476007)(316002)(6486002)(478600001)(2906002)(15650500001)(41300700001)(8936002)(66946007)(4326008)(66556008)(5660300002)(31686004)(86362001)(38100700002)(36756003)(31696002)(26005)(6512007)(186003)(2616005)(83380400001)(82960400001)(53546011)(6506007)(3480700007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDV0dEdEdEpRRG5yNjl4Mm5sRlFxbHAzQU1rL3ZBeVdEcG5LS3htRHJuUHBy?=
 =?utf-8?B?V1pkTmZ6Z0dma1pySkJmQXlMTlhIS1A4a0dUMFV5ellTRnFLUk9mTmJTRTNk?=
 =?utf-8?B?eWFGdVNuc0F4b2lMZzBrNVZkalpMRDVVL3dwV1oyWWxBZGMxT1FhZTY0Qmxi?=
 =?utf-8?B?TzR0S3NQNUZFZHdhTTMwbmZMb2hRSFZHa0dOU2N2SW8vOURGbHhaRTFwTDEr?=
 =?utf-8?B?RmVhUlErNWFXbURHRFZrVHY3T1hwMDg0TGthSGxmR0U3V1VzTWJmYXQ0RTVN?=
 =?utf-8?B?Ym9CdWpNOUFwTTVHeHBaK21tcFYvMDNwOGI5S1FHeUhWUytJZC9UTkplc3F2?=
 =?utf-8?B?d052QTI4bFU3NjlETDF4ZlNSTmZ0UlpFVnZMOEZqalBHYTJFN2xoOHNseXQy?=
 =?utf-8?B?V290NWREWTh2Y3VKdXBaWkpwN1JDVW9oM3kvVmhBT2tGYk9UU2lQVDZ1RG55?=
 =?utf-8?B?eVlEaWRDS1Z3ckFTVmtkSWFaZ2dSWXZYdGVXRUxETWd2TmovbVljYjdyWlps?=
 =?utf-8?B?Y1RGMlZoN25DOFpsbmlFeDltNzdNdGtkSHJFUjdOZVZ2Sk8wN2FHNWNuWUJs?=
 =?utf-8?B?STVLblhjSGNLZ3RLR091b1pCeExBVVdUNi9RZjd5a04wTGdsS2pwRDk5ZmIx?=
 =?utf-8?B?NGVDQlZuUkZNNXozVTFPUGxVSzFqUGlxZjRPQ3c5OVA2cTVrZzN1TUFIN0hk?=
 =?utf-8?B?T2hiNnpMWnpQTWVZME5MNjYveVFHSmVNLzdobjdrSTJuNEpzbCtGWEZIb1Mx?=
 =?utf-8?B?TEVvYWdyUmp3Q3VpVndJdy9Id29tRGMxTWR5VkRBdlJESFpXWGJPd1hudmhL?=
 =?utf-8?B?VWtDcXBPYUUzM2N3VU1paWJyK1JtZ0hJOEw3Ny9qcEs0blJNT3A0b0R0czI0?=
 =?utf-8?B?MGZ3UjZlMFBycWZJMCs3NlJ4eTJDQ1A4QVhKVHJ1UWM4RFF4NU5GQ0FaUllN?=
 =?utf-8?B?aDIxQ1luTWQ3WndvbUdVb0ovazNjRDdNWGZvRVVpNElzVlhLSHZCc09jZWNP?=
 =?utf-8?B?dUNZQ3hpb1pzOFlGK1h5L3pHRFo3a3lwUmVsUXJubndiMHczZU1mZlpDWER3?=
 =?utf-8?B?c0xHNmU0NE1nNWcrVlAyNTVwcjduVG9sZUhWb1RmMjlNV0E0N2pnMlBNTDVv?=
 =?utf-8?B?SFRDNkJuUDZjazhoalMzb0Zyd3FKcFhvTzhNcEZyQzNJSnZwaG5CS1RoT3VZ?=
 =?utf-8?B?WWFRRFY5V2dKTDlma3Q3MkJxUm5ObW5RZXB1dmF3TTA3eU02UzE2cG9IU0xs?=
 =?utf-8?B?amZteEJKT3NRZlBSUmJQSFVpV21PYUJHL3B1NWJEcm5YYUsyY3ZldUk5SkFO?=
 =?utf-8?B?L2syMjQwV0Z0NGVzd3hydCtuaGk1THcybFN1UEtkY29oclFveEtrSlc5TjZk?=
 =?utf-8?B?RUJpVlJHTE5zNi9tSnFLcWJQb2hnYlM1azFFdmtDY08zUk00TGhRNXdnclZ5?=
 =?utf-8?B?cldaTVEveU0wcjBsczhDRU1VY01mclNnb2tQSlU1L2QwV1V3d0tQa3VUbC9C?=
 =?utf-8?B?TzVuMGdRMDJ6eGd2RFBXNmpna2lQTUx1b2ppcmg5dk9ySVJiVEUzaG9FcXgy?=
 =?utf-8?B?L0tRU1p6T2lpeklPT21RYmYvdmVLLzRqeS8rVmQzVnR1UlFoQ0tPTkM5Ympn?=
 =?utf-8?B?REd1REQya21vSlBEL2lUODAyclU4Q1FwVm95MnRYWGdVeUVma0VLZ0FOdzFh?=
 =?utf-8?B?d0JLa0RmVlJmck1ETDFmOWV0Umk3Q0tuOEZad1hLcHgxRm5IMkV3WE9GZ2Zp?=
 =?utf-8?B?N0R5WnUyS0JNdGdGRUE3Y2NNK0NUWGlQeXk3dm8vM1gvK1FjSVcrQU1EOGF0?=
 =?utf-8?B?V1RoUjhsKzIvZUQ1citvZTFCWVlTUmlkc3NmTjRDU1kxNVAwOUNrWWNXSlRt?=
 =?utf-8?B?TFNvVTVCRURKWmtqR080aWpQSXk3bDRCZUdqRFN1Yk82MHNTNnRxUTYvUzIy?=
 =?utf-8?B?QW1jZGJSYUphWlNHeXcxVDFlcjBCbk5BUSs1YXNMdnRXREVrWTBXMEtudnNV?=
 =?utf-8?B?eDhlbC8yVnhoTXpDRjdscFFLK1lHbnpXcFJHVTIrbjNnaFlWenV3ekZOUWhY?=
 =?utf-8?B?QUNZajdlT1c3NGxBdkxZVXBBdFhLWlUwV0VnQ1llZmxtK3Z4REhuaEVVT3pN?=
 =?utf-8?B?dmJtdDR1NTVPUis4WmZNU0xOcE5jUVgzS0huUVVqaTROaG5DdVphQ1J2a0ZZ?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff03caa-00a4-4178-a432-08db03ba0126
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 18:36:02.3041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwHz6fCyJ09BQ7iXk993N0rskZUrj6U8l6MqHcX+IJ7BAj55MqNmiYBLLAxTQRjEy4rjE5vvU/QESmxacPeH7TX0u9gRQP7D4ir0sgHWSUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6016
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



On 1/31/2023 9:48 AM, Michael Walle wrote:
> Am 2023-01-31 17:29, schrieb Russell King (Oracle):
>> On Tue, Jan 31, 2023 at 05:10:08PM +0100, Michael Walle wrote:
>>> Am 2023-01-24 21:42, schrieb Andrew Lunn:
>>>> One device being slow to probe will slow down the probe of that
>>>> bus. But probe of other busses should be unaffected. I _guess_ it
>>>> might have a global affect on EPROBE_DEFER, the next cycle could be
>>>> delayed?  Probably a question for GregKH, or reading the code.
>>>>
>>>> If it going to be really slow, then i would suggest making use of
>>>> devlink and it being a user initiated operation.
>>>
>>> One concern which raised internally was that you'll always do
>>> the update (unconditionally) if there is a newer version. You seem
>>> to make life easier for the user, because the update just runs
>>> automatically. OTHO, what if a user doesn't want to update (for
>>> whatever reason) to the particular version in linux-firmware.git.
>>> I'm undecided on that.
>>
>> On one hand, the user should always be asked whether they want to
>> upgrade the firmware on their systems, but there is the argument
>> about whether a user has sufficient information to make an informed
>> choice about it.
>>
>> Then there's the problem that a newer firmware might introduce a
>> bug, but the user wants to use an older version (which is something
>> I do with some WiFi setups, and it becomes a pain when linux-firmware
>> is maintained by the distro, but you don't want to use that provided
>> version.
>>
>> I really don't like the idea of the kernel automatically updating
>> non-volatile firmware - that sounds to me like a recipe for all
>> sorts of disasters.
> 
> I agree. That leaves us with the devlink solution, right?
> 
> Where would the firmware be stored, fwupd.org was mentioned by
> Jakub, or is it the users responsibility to fetch it from the
> vendor? Andrew was against adding a firmware update mechanism
> without having the binaries.
> 
> -michael

Well devlink flash update is already supported, and typically assumes
you got binaries from somewhere like a vendor website if I understand?

For non volatile firmware I think its the best approach we have currently.

Thanks,
Jake
