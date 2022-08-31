Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610B85A7BD6
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 13:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiHaLBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 07:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiHaLBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 07:01:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C9975CC5
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 04:01:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bzh8Pm2FaG/TzrNxSSV8wp/uebMEp34lB4wDUfteHnMUwR4EmlIu4JjoKXBm+RWrRbjzoB3Fkp5GdUfdPk9ma2KLQlZMi/MGmKv0GBG/RfEUXrRURC6zO0A1iJ9Xvo9LzAuAC/o1/THeyTZhP3MW8MJTsLYLbaJJd4wrxuG7WGkG+txZj7u0anmlJMtbC33lMsW/ItCnJ4ubO8SSQcu+iRAkRzP1HoB7XBteFwpoeW731HXbNHqaUH5xf4QHpGJQgIV/k1P1ZRENNeeEMIitnzxZh6atqO97MOJjsBdf9U+H1CuQ5G0eGyhLPeGSOVeRCG7Ovax7YckmSUF96d/lQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6of6VTKt48NXBirSFYRVeWtQY1mXiWqxUCEM8CQuw9s=;
 b=SqIIBZ1d4tKD8AntLCbJBtxdN9dDzl1JOhqsKZmO5YsyfdVz7YiX9Q4Zsp91JGt6XkZU//EQNBy3ONhf7YvFJJrKDe7tMBFsxuDFWd1Hfm8LWwFbzLvCJ75y+/7PWI1YD33qaW61OkbojF8qNMpIMJx3Vi0VHONBfkXQO9dqAhfcKiiscjqUHNhVfKDLl9rTQbZ42IQzGX6aG5PhCaJjGEJ+DV2aoJGsEL3z2PYaOTz6lumWCHZUgbXkyZcTjALxyd9A20ZQCCgUSukgDeojNxl8jtmy/UuS8gm2E0OK/2oDSTzb5KRY6SccW47TEb7jJXeZ6OMjurl3gGknRCfIog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6of6VTKt48NXBirSFYRVeWtQY1mXiWqxUCEM8CQuw9s=;
 b=jqOv7UqIDKLgwnF6TX50zN50W+0pLl+BT7zqJqD7ECbh0uyOsYxDbC5GLf0Omk2xqNFQs+XEPX9CHY/EUF9hMC9D9/i/VSWo8oHPB0BDJaypAw44wQfNW9daHY8Orbf7+uU792jWDnQmgOY3/Y3sw6wIJjTZJCaS6dSbl+4TX+4vPJKuY3y4hzlUQsuaQ4fwqqXHmOhDoOJv9s1X7Bmgq4JZPjiN7paP/goIe7/TVTUmZwMRpdd32ApyxETHzJiSuXLRtMYsMqYY6wLNb/Ik9KWj/YMQVRrPA+fFMY9tG9LZA7yTu0OmBAlFdUzMwzlWPaaTk9zKicSFjIm/8poZFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH7PR12MB5654.namprd12.prod.outlook.com (2603:10b6:510:137::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 11:01:17 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a%7]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 11:01:17 +0000
Message-ID: <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
Date:   Wed, 31 Aug 2022 14:01:10 +0300
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
 <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
 <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
 <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
 <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
 <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
 <20220830144451.64fb8ea8@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220830144451.64fb8ea8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0431.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::22) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f777b03-a31a-4d94-2528-08da8b4020d7
X-MS-TrafficTypeDiagnostic: PH7PR12MB5654:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9fm2pq1N9yKLZl512OQ7mjCqjM4H2QBpsftBJTLw5ohXV6lk9blfx368VsnjpsVDGV7okDo/JRrsLWHipLgCvFv9muA/NoC3yiF3ilvb4UTt5JV+eJEUFMgcgmJdyMoq02Mo+WhaOnVK+OBa8W66I5O8l+vVdx6MUvrOiILnmduR/3szYFmXY+tiJJGDCVewhYilfSKVs89r7fB+qDLurEPbZ9RKuqKhycxv+mATUVRIXRMcmYo4qwpPfdWOWLnBIfbq3tCPk5jO332bqEmQkP4rAU1874XEY/HLRU5wKSZEsE97YOQaFgzyxSmwxqEBGK3GfR4IZaIqpAR2NmDNay42YvBjEhSoNyfFm1eZXFbJh+r9+WxSxqcWw3FTSk4MPkoJkuCAiMxfzypAeaQSZUXA39C8ogSf+O63ecySVnTHTk6iZwYB/GeV+dJT2xd91kLYAxTxIxvZNcxztFdu4xhfo5z6kAGFHu28ghvMCfkQq4zooIzTghFEDSCTUTONaOgD8mcj0lzEjE/XjSQRN8linweJIgf7+ClQDWQoce/MdJLUpI//K/Lk/5SZ2BA2qa6lOER4TV+OtH2ashiJwzqxqB8EgN/5RdHOUTVCLp22MM9cpXsmqiwrfvE+hjnOQQf42Yg4DBUJHp5DV4W5KdRA6+7JKZ7h5aW3xFwjkIHTo6ife7Zw/ha3aylPutaYYbubiVC2NRLllQhLxFlmWWciCBzWmAKPvDviLs7d/OrOgEBM/C8zA0FNIkJ/CR8CtIygfa7isb1BYmgO3BSmGmyCOfT2bdMomgx26kCCdLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(4326008)(36756003)(6486002)(186003)(2616005)(26005)(66556008)(53546011)(8676002)(66946007)(66476007)(31686004)(2906002)(316002)(110136005)(83380400001)(54906003)(6506007)(38100700002)(86362001)(478600001)(6512007)(31696002)(8936002)(5660300002)(41300700001)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmZlbmNDbDd5ODZwT3pFOWo2cUpzNWF0Y0orTlcvTy93RHlNWXRseXk4Ujhs?=
 =?utf-8?B?cklVTzBLNWhmQlVuQ2NtVlU1S0NtRVV6V1FzRGlrOGJ5ZUVMVjR1cWdNV2Jt?=
 =?utf-8?B?SGs2c3lIRTd1c1l5L1RvYmQyelo1ZFBlTFJZdW9TTUp4SVB0VTA4aHFiWUtL?=
 =?utf-8?B?ZzZ3bW42VzUzRnZDYVdaeGdTR0Z2TzgvWGdZS0pQRU82cmFBRkY1OG8yMENn?=
 =?utf-8?B?cWlTckVqYzV2amp5VkNFUmd3S1FEY0tLTUNSaSt6R0lld0dOU3Y5ZHVRZTlt?=
 =?utf-8?B?aUw3T1ZkT0NPdnFRSEdyRWU3cmdJb3NxUTRnWVBxWU9FcHJTZjBGRUpkajhS?=
 =?utf-8?B?ci91VFV2cXJNNlRhUjJ0Q0xJTFhvVHYreUNmS2VIOUlzV1pHeno3MnZ0YzBr?=
 =?utf-8?B?RHlmUUdoZUNvalJJMVdqQ0Z5bU1FaGdNSWo2TmdlNTAvWitaNXZTVFN0S1Nn?=
 =?utf-8?B?OHYxZTBnUDdCZHVRYTNta0hEQ1NsY1J4a2xHOTh0cjFqOXRkeVBqeDZ4UzRJ?=
 =?utf-8?B?c1VsZEk2MVZsa3AvY2dGTzJITzNxKzdjZjhRMUxodDYrNDF1ZkRHVzdpZy9q?=
 =?utf-8?B?SlNkZGVLWTRVam9CRlZmTWZaWTFKR1dlLzNweWdoRjJVM3RQajBWUVhZVVdL?=
 =?utf-8?B?cm4vMlRJaDBOV2t0Z1NGRHI4VC9DTUx1SU5mbVNFOHdPN3FxTUhWZk0vRWFZ?=
 =?utf-8?B?TWxtamxJWHB5clhBRjNxVjRncW9vYWI0OVdpL0I1L2E1Mk5RaC9mbW55bzFo?=
 =?utf-8?B?ZVF1QmhKdzVpVmc1M212UnJKQmpQVGZZSkxabUREUDJjQXpIencyaGM5VXdy?=
 =?utf-8?B?N1duNUZQTDRQWkEyc3FJcktRTmUzcjdJMko1ejRhOFJqVC9rT2NtWnFNRi9H?=
 =?utf-8?B?ZHBaM0NZN1E0eXpsRnhTZ0JEN0ZHRVVyNk00QSt5anl4ZHFVK1V0dGw0WGNm?=
 =?utf-8?B?UDRwaXFIQWx3ZWxqSDZHRnB1RVhMZ2RGSUNQaVd0UktQbE9ZcmpDY3FXdDI4?=
 =?utf-8?B?SCtWVWNaUE04R3dFb1M4YlNxTWU2bVlTTjdKWTVrejhNY2krTm1FaUgzL2M2?=
 =?utf-8?B?VXA4c291YXk3ejVrMTAvZnlkcVVNVlgwSjcyYVVvZ2FpYWVNL2IxdzhaZWRj?=
 =?utf-8?B?VXpwdmNib3BZbE9lNkE2LzVpK2VJK2VpaThPb3VLODR2bGk4R3Fpb2VWbnlS?=
 =?utf-8?B?RjcwQ3FwNzJOVUttNGtxZXd6UkdrYXRkcU1jTFFHdTFrSFJmb0VnTFh2ejlu?=
 =?utf-8?B?Rk94bVRuRVJtMjJmQVV0ZmsxTVB4ZnFmd0xESll2OWdjbTM5MExWUDRPbHd2?=
 =?utf-8?B?dXIxQ3B2V2RNMlo2R0xKVGVQZWsxVlRCcEVKNkpDU0xTR1VRUFVDMTJNOWlB?=
 =?utf-8?B?dUVyZEZLQWVCMWlqQ2J6bDBZcVUzdXlQSFROQ1FOdFloS1NoK3RZSkNaRzlP?=
 =?utf-8?B?eENlSGorYzBIeVBXQzZMOHZUbGFGREtZMitCQzZZM0RtdGMxRlQxY1FML3M4?=
 =?utf-8?B?a1NMKzhDeWh6bjZ1alFWUjR1ZmQ3dWwyUVZ1YVQxYU5GZGY0QzNpNWo1MzI4?=
 =?utf-8?B?N2c3M1F6QUFXT3Vmc1p3QWxlSFNZMGJudVpvdU1rTTIyUXJWbC9oV0Q0emVG?=
 =?utf-8?B?a1hQaFFTcHVHVU1Pa2w4dHRUcnJvYjcvTHlKMG5ybHJFaU5OL3k1a3R5YW5J?=
 =?utf-8?B?a0ZlclE2dnYwYWZJUFJrei9aZ2dSTXA4YXZ5L2kwZ1JTdnRhaCt1RDFVRFNX?=
 =?utf-8?B?RWdaNjVYWFozdHd5N3QvdUdXT0xOaXNhSWFLUzJ4eUpMR2RsWTFNdGdqRFZI?=
 =?utf-8?B?SU8ybUpHa3R3U2FlbEIrLzFRNHRxcWh3NlhpZ005dEVxcFZ6bEtFbmVZYmVu?=
 =?utf-8?B?QVlqZ3R1Q2FMS3lIQWEvTGl6OVZLNjNkakcrQW9jTmJhcmlDbzBjK3lwN1VX?=
 =?utf-8?B?MDBEZlhIU24rY0ZWcDg3d1V6anUyK2FNUFBGZHpwZTdlcGNvMnRrYXY2c21v?=
 =?utf-8?B?SENFN3RPUVVWK1RnL0tXUlBOZGxMK21NcVIxOXl4ZTRFSWNKbkJiRE1hR1g5?=
 =?utf-8?B?SkNNUlN2aHYzbWx3bDJDMm9JMHJBVHFEYVNoZHJqNmMxdzFrNHVMcmxlRlRU?=
 =?utf-8?Q?XltMrVdJXEkuetXyS5Xco0kJH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f777b03-a31a-4d94-2528-08da8b4020d7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 11:01:17.3202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXTT85JBpApS2yNhDSbJEKRewKFnWsEuB+4H5G0e4KfzNjj6OPhL4czxAvBlJ4pf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5654
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2022 00:44, Jakub Kicinski wrote:
> On Tue, 30 Aug 2022 13:09:20 -0700 Jacob Keller wrote:
>> Gal seems against extending uAPI to indicate or support "ignore spec".
>> To be properly correct that would mean changing ice to stop setting the
>> AUTO_FEC flag. As explained above, I believe this will lead to breakage
>> in situations where we used to link and function properly.
> Stop setting the AUTO_FEC flag or start using a new standard compliant
> AUTO flag?
>
> Gal, within the spec do you iterate over modes or pick one mode somehow
> (the spec gives a set, AFAICT)?

When autoneg is enabled (and auto fec enabled), auto negotiation is done
from the link modes according to spec.
When autoneg is disabled (and auto fec enabled), the firmware chooses
one of the supported modes according to the spec. As far as I
understand, it doesn't try anything, just picks a supported mode.

This whole thing revolves around customers who don't use auto
negotiation, but it sounds like ice is still trying to do auto
negotiation for fec under the hood.
Looking at the reasons Jacob listed here (unspec switches/modules), it
seems like all this can be resolved by simply setting the fec mode
explicitly, and to me it sounds like a reasonable solution for these
special cases.
