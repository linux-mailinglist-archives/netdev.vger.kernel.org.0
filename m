Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4ED45A3D33
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 12:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiH1KnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 06:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiH1KnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 06:43:02 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B3212AE3
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 03:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XV2wsylDkHR+z/hQhHxITI0afr4Ji7+I1hx3ZgGQyrJZIlHNXiEyUGc7Xr0wHRSgrU376zSWffxnFIxjDf0zH/AdFDuCwzgkbwhsg481EQZFoe2OcTdXTIwWpBZqsa4Vidppi51D9vbe0Wfis4aZ8QiGZUm1xFW2QkaglmoUyYBEJE0vAMUmNlqVRWEdGXFrnbLQtu3ZsQn+EJU3tsQzWkbtN2auyPpFL4m7/WpSfAhsffvgoJ3bOYKfgFtqcZU2vX5xKEO/WEpcC/In7J2xRVHuG3o8R0UugcbUp9F8P+59VKJCHXCk0O40+KGRME9c/W0tYSPLW2amkb/IKUo+rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKZnJmV0JBJ/Svt/Ii7T9NfRFRWFKGAU/zRAk7DRE6U=;
 b=EWRlXU/3m4iRXUiEM9GSxQb/fhreTO5K2dhyE8InGwSxar9xkEMSeH9dGDjMlAbXdbcYgcsMiilCMMr+EJOyEKXElaF9VcW2Aca4+oBCHJN+6EMzqD448C7jeIQT002LLGassssHlzwcewfprESkLxR5+Y5iCbc4l1SnjApeJWZ7/T0JKEMXwWp9TSq656Twz/7oa7H0ZbW3XqfmOwBzFp4pMB4A1l8zUXWANcA54P41k67qSIKHJNthUAksrO7AN3WLb/+9z2dZucGDwLxGY9oVMFWOIY9Jx2g3oDjUmoSoIPyNWtm4tQ6KYOBgZ84zUnoVdWwApStVk+uivsO+Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKZnJmV0JBJ/Svt/Ii7T9NfRFRWFKGAU/zRAk7DRE6U=;
 b=nHSc7osTwvZYfmHpZzqswZnaATX35GnR3IWOz4Go9W7c6PdUg3qIggZHebIdKXgY6c2qUkXurOOfQUijMCf4U70rrnKfwE5wwxHEcQK/sCRvp4mZdExxAprFct17Uq86Uuqfv5xg2tHhHTc60xI0RkgSa+TC7PslA8sOu2dZApqNUx6N3i2fXcTHmOHmL95InRf9sEp0QtK18Pc8NNDj/5ZMGb5nPL3ZRgqp0Vp4DiMPc6kxnTXBX+qpfVV7FeW+PqOD/5bXAoeMEDnR7auBbyoGbWzGuRp2VNTDsqu6zDiMntRkn7+pSoBXgJNXHVBhnzIQKHyhXS3c+WJ+b+Wdfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SN6PR12MB2797.namprd12.prod.outlook.com (2603:10b6:805:6e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.14; Sun, 28 Aug 2022 10:42:57 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58%9]) with mapi id 15.20.5566.019; Sun, 28 Aug 2022
 10:42:57 +0000
Message-ID: <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
Date:   Sun, 28 Aug 2022 13:42:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
 <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
 <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
 <20220825180107.38915c09@kernel.org>
 <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
 <20220826165711.015e7827@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220826165711.015e7827@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0203.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::17) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6c80781-ccff-433b-6ac4-08da88e211cd
X-MS-TrafficTypeDiagnostic: SN6PR12MB2797:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RZrYSK/otRHKZaA9Fk2GigHBDC8lQCgeE8Kz3et8umRIV14biiYdTu4ALHTzZZN89uVbwZWNR3UZOz75FFgXThO4q9QZsWBb7ejp89nWZzxuDTRfcuMtkCh10g/FNzhozde3Apx0eax2xcZVxYk93I4CVW1J5hRjdtDJEQeK3lhs6jdt3tOukcs4J7oALiI9GtQwT+CE/M9q5BcR4381IoRp1Y61mZ2yvmq91R34JeI/bXfr6LuT9LRudFyYGRuG1VWUOdYMHvrXw0B7Cnct69I1snbKwlP4QycstBe2oTARMzYnItI9M8ej59QpUrrBvl8X68APWcEGEJI/xUg20YStScIISN1ylYiSdPfLDptquhnXMs/tpb4h23XwXfUXbSopBTOhGJ9AU9u/UX9+p+CdXzZbR3UkHMC2Hd+GloOc4DvrzAgPvyBECzBLml3Nkcv0spQpiQ8FXavHmuUSTkXNxCfvas2G9QnUBKOlwWqTBXhqnUVGKgSpkvohbhyap2cbPwhrCnhtaLQbiiCf6i+aaow5PntBCjcWgIlZ2UR2o4yocGDARZ1Wb5wAbdv+ummpWbz+vjkmatQuo+knIK52VkT35/mSXTBLVdx399N9U5RJuCncTWJwXGQ8tX8rUvV2rABmIeZR7u66t5BIiW3vEB4tzRcdFDmwBb/doEmLpFeRQ3WtnjsTgM/N6sdmpJtitrkrllOvkQZmSK3SC8BBV97CfYtww4bM7Zq8Nene7dv8EUxtQEk+s5bN8o151PtIVxAUbJCECNkwdgD89PXOYz6tCA0DhM5YHPQ7Z3w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(6506007)(38100700002)(53546011)(2906002)(2616005)(6666004)(83380400001)(186003)(26005)(6512007)(8676002)(31686004)(86362001)(4326008)(6486002)(66476007)(31696002)(66556008)(66946007)(316002)(54906003)(110136005)(36756003)(41300700001)(5660300002)(8936002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEdheEM1S1ZBN2tENzFiWXVxNXMwWHc5ejRpbDQ2bHNJZDhnUE4vMDZQYkRG?=
 =?utf-8?B?Y0pCaDRhenQxbkRmQU5jbU1CYjQzTENFa0wwNEJWZUc5cllZdFhPenBKZXN0?=
 =?utf-8?B?akIyV214RC9DanpBOEIvcG4yZCtiQ3dFVkhlbmZ5KzZ6S3dSbzFkUzRWRlJO?=
 =?utf-8?B?c3Uya2FkMm14K1o3ejROSUpWekk3VXNwUTlZL21od3g2SUE5MGtYMS93NkE2?=
 =?utf-8?B?K2hxR2EwdGw4SkdacW5iN3IyaXp3UzRsQXZ3WEl5dTM0ZSt4WnVnZkZSb1B5?=
 =?utf-8?B?bm5CdVoyTDh4NUZqUGloY255aEFwakQxTnRwcFlvOUN0MUxLa2d5azFkSXFQ?=
 =?utf-8?B?WEJMa1ZhNHMzYTk0TlVXR05WTmhNTGV5aDJPQUMvM3d6U29ieXhzRHZEaHV4?=
 =?utf-8?B?WU9uRU5WYjRkZWVQbmkzNEF1R3VvcWZEOVltOGF4RXQ0bXd2WitnR2c3K1B6?=
 =?utf-8?B?Z0xsRFFVQldwbVRqSTNMd3R4MktTZFF1R01zMkZsZi9TUjFPSldNOXoxV25J?=
 =?utf-8?B?T0lZakJJSHFYbWV4ZG9hRWlvTW5mQVc5cC9CU04wdjdtemhXQ1ovN3AybkpL?=
 =?utf-8?B?WVp3TmV0aW5WOSttZ2hlWTlHZnFVZThwWm54SG5KenNIQ0hwZWFhOWZ3bWpp?=
 =?utf-8?B?WHJZS3p2NUJXM21sbFZVY25iajFWMkZkSDluRE9CWm43REtrV1h6L1Z6Yms4?=
 =?utf-8?B?aDRqbFhoOTIwYkpSQStTTUgxZWdTeEhOMDZDMGxLUHgwMnVjQW5sSEhkRnFs?=
 =?utf-8?B?MlArbUQvaGxnaXhOUkRmc013VGEyekMwa2ZBcUdoWTM2N2w1SzhURVlNZElL?=
 =?utf-8?B?WXZHSU5IRDhNM0Ryb1FmOHZHaDdGUnpRTDI3WEtaZ2pRVlUrVENlQjFBQTlj?=
 =?utf-8?B?UVpLVDZvYjNOK3NJRytTTWJ4aUZicnFseVhHZ3JzOUkvaERMTGNQbUJpTGRm?=
 =?utf-8?B?YlJodUhsL3FiOER0eUoyQTRiWGVkNTZBOG5wb09QVWVOVEV0bmlTWjlXOGI3?=
 =?utf-8?B?Q0U4NXdyU2Q1SitFQjBYNmYwM1hGbmY0cFBHUWxIRE5FNDdBVkRmTk54Y1pK?=
 =?utf-8?B?N1dDMi9GWmJVcTFScHNucE1HN2pDdCtjYTVaU1hIZzVlaGp6YVJMNWxzSnMx?=
 =?utf-8?B?ZkI0N3VreFAxZTUyUlo4ZzR3cmNnMDVYL1pKSmFpR1pCTW5lUFBLNHgxcGtK?=
 =?utf-8?B?NnNCbUd0NnJiLzRXVVlhaU1kSVplSlNmTlFqWjJrbTJ4bDROa1A4bkl1bnNy?=
 =?utf-8?B?dzhMdEhuMTZJZE1wQ2tMSXlwN28waVdxU0tTYXdieGluMEtOQ285VVczS2gz?=
 =?utf-8?B?QUlZZ2ovdlJON0dmd0ZmY1I0bWw1RCtqSVRORGwzS1oyR3JGd2ZpdVZUekpw?=
 =?utf-8?B?QTVLZVlxd0tQNk5kYVBob1F4QnEvWG80RnFIeldhZGE4MnVrcmdTMk85WlFK?=
 =?utf-8?B?aUtlRXRPSERsQWlFQ3Y2a1gwUlhWbWg1QU5LZFVqeGt3L1Nxalcxd1lhcTZ3?=
 =?utf-8?B?MHpxNUtBbVhScnlLMkhKVHk3Z1Jab3Q4Slk5U3JQdUdZTDdlNjVJRTRKZXls?=
 =?utf-8?B?U05UZDdlNlB1OVBmY0NMNW9pSkhkdlF3MU40QXZ5Mk1pazhPTENJNWlLS3NO?=
 =?utf-8?B?cDRYdWpOOUorSG1sL1huemdBZVU1RGhBT2NWV3I5VUJYZXovanY0ZitsdVk3?=
 =?utf-8?B?TUE3R2xFYnFvYmlKT0RnMDJES3E3MVNJZHB6L0Jsc25QN3czajJGZGs2MjZz?=
 =?utf-8?B?bFdmNlVVMk45SjlhY2VRWXVsRnpDWlhkcVZGSkNKNjZjMzM2VDJUbWVZb2FL?=
 =?utf-8?B?eTJacW90TVU4TkhKak5TbERxZmJoQ2JYSWVscWxxRkNNaWFtU3o4Z2V2SGtN?=
 =?utf-8?B?a0d3M0Z2WEkrcFFreFBrSlA5a2EzVTkrSnkwUkdJS0IvTit1cHNhUkYzWHlL?=
 =?utf-8?B?dmdPS28xYU1vNmptSVVNeWxMM2ljdnhpRkZIQmxOV3hxUW1ROVdWNWdTOFd2?=
 =?utf-8?B?WFJrbmdSVENiYmxHZzZMRVpyWG5jbzBFYUFBb3BMaHVEUHFTTzN5WThUTWty?=
 =?utf-8?B?MUVBdnpra3pZQ1VaaTMxc2I3bjlqNUpBVWVNWFczSUNpSm0rYVJ6VElBYTVS?=
 =?utf-8?Q?jzkwzMpw7WdqtYfGdtWe7PZiV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c80781-ccff-433b-6ac4-08da88e211cd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2022 10:42:57.0870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8RvwESDv4doOHhtaM8x9BVUL1cVxvZeAo0MpvMgnQeS+F4o1XM3aRUl2TI3Y+6HB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2797
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/08/2022 02:57, Jakub Kicinski wrote:
> On Fri, 26 Aug 2022 10:51:21 -0700 Jacob Keller wrote:
>> On 8/25/2022 6:01 PM, Jakub Kicinski wrote:
>>> Oh, but per the IEEE standard No FEC is _not_ an option for CA-L.
>>> From the initial reading of your series I thought that Intel NICs 
>>> would _never_ pick No FEC.
>> That was my original interpretation when I was first introduced to this
>> problem but I was mistaken, hence why the commit message wasn't clear :(
>>
>> This is rather more complicated than I originally understood and the
>> names for various bits have not been named very well so their behavior
>> isn't exactly obvious...
>>
>>> Sounds like we need a bit for "ignore the standard and try everything".
>>>
>>> What about BASE-R FEC? Is the FW going to try it on the CA-L cable?
>> Ok I got further clarification on this. We have a bit, "Auto FEC
>> enable", as well as a bitmask for which FEC modes to try.
>>
>> If "Auto FEC En" is set, then the Link Establishment State Machine will
>> try all of the FEC options we list in that bitmask, as long as we can
>> theoretically support them even if they aren't spec compliant.
>>
>> For old firmware the bitmask didn't include a bit for "No FEC", where as
>> the new firmware has a bit for "No FEC".
>>
>> We were always setting "Auto FEC En" so currently we try all FEC modes
>> we could theoretically support.
>>
>> If "Auto FEC En" is disabled, then we only try FEC modes which are spec
>> compliant. Additionally, only a single FEC mode is tried based on a
>> priority and the bitmask.
>>
>> Currently and historically the driver has always set "Auto FEC En", so
>> we were enabling non-spec compliant FEC modes, but "No FEC" was only
>> based on spec compliance with the media type.
>>
>> From this, I think I agree the correct behavior is to add a bit for
>> "override the spec and try everything", and then on new firmware we'd
>> set the "No FEC" while on old firmware we'd be limited to only trying
>> FEC modes.
>>
>> Does that make sense?
>>
>> So yea I think we do probably need a "ignore the standard" bit.. but
>> currently that appears to already be what ice does (excepting No FEC
>> which didn't previously have a bit to set for it)
> Thanks for getting to the bottom of this :)
>
> The "override spec modes" bit sounds like a reasonable addition,
> since we possibly have different behavior between vendors letting 
> the user know if the device will follow the rules can save someone
> debugging time.
>
> But it does sound orthogonal to you adding the No FEC bit to the mask
> for ice.
>
> Let me add Simon and Andy so that we have the major vendors on the CC.
> (tl;dr the question is whether your FW follows the guidance of 
> 'Table 110C–1—Host and cable assembly combinations' in AUTO FEC mode).
>
> If all the vendors already ignore the standard (like Intel and AFAIU
> nVidia) then we just need to document, no point adding the bit...

I think we misunderstood each other :).
Our implementation definitely *does not* ignore the standard.
When autoneg is disabled, and auto fec is enabled, the firmware chooses
a fec mode according to the spec. If "no FEC" is not in the spec, we
will not pick it (nor do we want to).
It sounds like you're not happy with the spec, then why not change it?
This doesn't sound like an area where we want to be non-compliant.

Regardless, changing our interface because of one device' firmware
bug/behavior change doesn't make any sense. This interface affects all
consumers, and is going to stick with us forever. Firmware will
eventually get updated and it only affects one driver.
