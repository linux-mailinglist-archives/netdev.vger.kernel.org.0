Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8251D5A9610
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 13:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiIALwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 07:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbiIALwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 07:52:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3811118223
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 04:52:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZEQ3OKiIYpsQ3c6lmRVjDa6w3xGT8949Co44dwu8PtY/I+rmoxxAOwbSSzeWcyE4JAStPyk7vaSWIkrAbzNNttSAZxWaQskveE/dfABseSHmI8igHDnv22Vcj81oVDHEIQMhg2sw2LOpcRMTsaizVBrZE6NfLPnMsBprU14YoIPQnRAHaqzum+j+97VS2oux/IiYiSiN5p8wCGxB1RjurM88TflwuWunvxShL/bXeyWVlj00BjvDDlZ8fgDTR6y4LXLhkyBT8fSMuVeJ8kff7fyBpqnD9GJZ9aDcHRVbhkETraq1g1IjifUaqWNAa/vt5lbTV+FdCjRGa32Elk63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRmDi5w9hcahvfwrRcHwxXw7TVtmgB5zP1f0aMFKRyI=;
 b=gLFZzqD/XoJBuAeVxc72pahWclwn1+PSQWbJV5QeBXuKPKdFnvNm9QqUrJrAZckWLqriy06wuruOnGu1HMN4W0DzGuLAi+BFjHHxebWc6fYdixUXyQ3Q6hr0DbU1YHdP+Mm0jLleTMpguENe/Nzn0ef2aU3k9zW60u2q5tmVQa4T5fawCD3Kc3VrdkweW0ih6r9MXC9emvpNha5pB1ofCo+cDyKyvI3qOqCua3SXLe0+G7QYJ+EaHdXbbRVQpTKsu6TAGJWjJrTsIFgKADLyet+szZGF8f81jx25jAv2k3gMjr6zkr4IRomdn3NYpq4F5xVzVKr3MtuhpJuwFpbXow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRmDi5w9hcahvfwrRcHwxXw7TVtmgB5zP1f0aMFKRyI=;
 b=ucrrm2Fl1a3Nv4Qhet/xqFDplFLzZK8cAAbo7IkwSiBGuxZE0UF5Sm+IrMrn18mPIierHE3mUOCaSndul8x5buoi2Z9JJlRsVRWShkk/k3b3KKMh5zXSAF24nUKTkdOfvXycQHqMCrp6mrQgqezR9IFDNaNtub3hf/ERkCXuObSCshlBogc48jE6dtavtByCnuJuIBkGD/J5ha6/JLhjR7o1GPn/t/GEKiITpUr/elX3ImsBdFsZRNh9HVGO2JSP24Jx6iZIEWVLF7rh2dR6DgeInn/PoQYd0X2pMt8SDjrK/FCmCwL9dDtKXPKs5x1zkDO/3VbC5GhOgvRDVxH2WQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MN0PR12MB6198.namprd12.prod.outlook.com (2603:10b6:208:3c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Thu, 1 Sep
 2022 11:52:02 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c470:ce6c:1ab6:3e1a%7]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 11:52:02 +0000
Message-ID: <e1d57b80-2e62-8799-ce36-bb944ea85ed9@nvidia.com>
Date:   Thu, 1 Sep 2022 14:51:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
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
 <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
 <25286acf-a633-8b1e-95c1-9e3a93cd79ea@intel.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <25286acf-a633-8b1e-95c1-9e3a93cd79ea@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P189CA0039.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:458::11) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8edddb4-9789-4963-b1f3-08da8c106206
X-MS-TrafficTypeDiagnostic: MN0PR12MB6198:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUZHB9oidGe/pS6jQQdB8bwLzsxXitF3CjpaSF/iM0NQWmCFz/jxIptUo+fYdJ2Z+3bjhy4GSWOTFlc1JYyJ3HQWts2UsDSGa9G1vEMl9ZHfNOqh2TaQm1XiO8TYx4sjIPVEmwmS/vxDb2XX8A6NuHSBZklr366YnpsMkHXIpoYK4pOZonh3L2EoP8EWwO8sdvZzMaqojw2MK3xeQt6qcI6ZXjS9F4H5rIjNTVVEVzZ5rINCjyuT454BIvTSJI+5DCUKzS25b1SXTvnENolMcCtk6SNYovJWsH/eWF4tiBR/ZfOEQmsHh0wcgo8w8OBE3JYKsfeluXcr2k2619HwLdyzAuMfsJblIwef0uesvqMWqZgB49EBKkx515PumnhI1m6iH5cE4wEQmPZ9RE5Slin6FL/e0jaNcO2+984AE4KivMGMQwMmvT8sRr6wMEnz3girrfSg+G2GaCpgvekPRw5k6BJHkqg294fyA16ruaFmYwDeJ5S6kEGvazRMQwZDnkT5oGGhRfPVPu7oHBVOl8fKa95Byxmil4UvHXoqg0OS80s6aeSAcyfEHKfcJ2JRyxf7nZvt5bHf82kOp6fa/F5O2rkHOjf/CUoT1XOXVlNQeNTmeZSoYMfbCZ0/AhlhfU05TopmFEw/55SKUsd+FEYT3Vp8lCtqi1ZDluc6nRtJjytBG/03m/lub90sisnxfma2Zz2eIe6lbCiEwJ5GOgff3Uc5SvOn+EP8S51zPdu4ZYLKM92Be1lHeyacmbAiobG9rH/RqbVIQ1hqbefWYB6bxGJzN2dXu2PTunmsy0o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(83380400001)(6512007)(53546011)(26005)(6506007)(2906002)(2616005)(186003)(38100700002)(86362001)(31696002)(8936002)(6486002)(66946007)(5660300002)(41300700001)(8676002)(478600001)(36756003)(316002)(4326008)(110136005)(66476007)(31686004)(66556008)(54906003)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T21FenZaZTRQcDRnZTA4T1U4MXFxdUVDSS91SHBnN3d0Ni9NNXE4dHVPNDda?=
 =?utf-8?B?R0FUWW5ONzlUaFFaZTdLZkV5YzEwOXpDbFJYcGROb2tWcGtVUktrdk9mTnps?=
 =?utf-8?B?KzVjUTVEa3dNVzFLNkUranltVHdSS3RlbUNTd0wrTkIrS0FWRUVhbkRiWjdv?=
 =?utf-8?B?STFSZDVKUGdvMUpzV2pIazhrT2o0TXVlOTVtdGYyeGdoSmNwR0Qzdkk0Z3I4?=
 =?utf-8?B?TFhoYnpQTWw2ZDhuQTV2VXFuWFErdDUwZVErZjN1aXU0dnYrVTFxWVY4dXVr?=
 =?utf-8?B?VzRWZWZQaVl6eXlWQ3UzYWdSZElPczV4VjlkajlNYk0wRVBYMlMxcXFhRGVH?=
 =?utf-8?B?MXZKbWZtZHB0V0ZRVlB4K2NuRGxtSWwxMUZnY3VLLzk5QkVPY1FYKzVTTngz?=
 =?utf-8?B?VWpTajkyU2VKRVFLV0V3Yk9IakZKYW81Y2swdWRyL2FPZllaMXVaM1FSZURV?=
 =?utf-8?B?Mkd2QTE1c0h6Y1UxNDNzTFltb0VRalg3QnRXbnlnbUQxOWE4NVRERUZKRmRI?=
 =?utf-8?B?eDVQaWR4UDNJUjYxdDhUQTBWOEZveHJ5dWFuc0ZpWUFzdHNSTEdzQUlhWFJI?=
 =?utf-8?B?WW15S3RpaFcyV0F4VWJsNGlKV0hTd015UDQrckszQ1lDVEZkbE9na3VxbHFU?=
 =?utf-8?B?eC9YY3NSY0lmbHM1aHo3NmY4Uzdtanp3Q1BrZmRnNllGaWdHMHdRblNkdm5M?=
 =?utf-8?B?NXVJRXhtK0lKTU85T2ZTbFFHczdUeU1QU1FOTjhXczNwVjRkYThkS2ZkZ3ZG?=
 =?utf-8?B?bUdHM2xqdDVnaVhTTFhTbXpKV1o1czdXbWNGWTlqdHFHTEFHUnN2N3l0Yjdo?=
 =?utf-8?B?bDFHY0lZNDdES2hmV1ZHN2wxY0dkZk40TGNVNzZNVlNvbmVySDgyK2luWlBS?=
 =?utf-8?B?WVNmVHRLRVE5V2Rjd0JRK0FMV0tDWDFQejhOVW5YdVRUbDdubHFpSjcxUjZu?=
 =?utf-8?B?T0laL0NOL3FUQVlxNWJ1dGVxVThtWEZzZkRyWHdabkNrbkRkMkVQVkNyNHlV?=
 =?utf-8?B?OEpnZktqU0RVY0ZOdnp0cWdDOEZFRElhVENKNkFKbTAyWjR6ajZWSFZIZ2dR?=
 =?utf-8?B?am5VM0tkVVg4M0R3dWVYMHd5ai82U1BULzcxVmxTK2ppczJDZno4OFZoMXh4?=
 =?utf-8?B?aFFycHJlWFZ4Z1VwajF3RGl5djRDdWc3ZEh1ZGRQU3dZNlpTYnJDMTdrVDVD?=
 =?utf-8?B?ZmxVbGNldk1lWFlSM1B3Nzc4NWhXWXpVWHJyVWwzSGhPR3hlaTJBNkppYzgx?=
 =?utf-8?B?SWMxblBKaVFYbUgrcU1iVTR2Nnl0QzhkeHBCYllOYzRLdnJUYVRERHlmcWF4?=
 =?utf-8?B?UldUUU1KeDNGM1Z4WElDLzZQcElzTWVyY254eDkzVWZzYlJoL0IrNTZMeVdw?=
 =?utf-8?B?VmZ6emJtNG1QZGE5US9kNTdhNTBKNkwybjV4eS9UeXdIcytIcTBJb2NaOU5Y?=
 =?utf-8?B?c3EvMERucndQWk1nRm5rRHlJdXd3MjhmbHVOYm9UZlBRQ2pNUitOc1V1djM4?=
 =?utf-8?B?UjlrWDYzcTFNUFFHVXVOa3ppTVJsVFIwZFpGNzFiUnpZS1UzMHRwdGRlQk8v?=
 =?utf-8?B?aVhDWHJ3ZmhqeThSMXNGcXNTZ0QwZkxkTlI1c2x1TzAyMk55dWZiZkY3TnQ0?=
 =?utf-8?B?Z2NCVVNlRUZ1SVhuV0NzNmtsM0Frdy9zK3VWVEtHbFg5QnpTdzIwTWhyRzJD?=
 =?utf-8?B?cStVN2JLeEs1U3ZUNFc1NVdnTWpQREROUW55Z1UxcUVLNGJvTEsxRzlONmg4?=
 =?utf-8?B?YnhyU1lVMFlQOTFqSXBVQy9HdEI5QTF1R0lEbjFXaU1GQ3BKbGZTWCttUUJO?=
 =?utf-8?B?N2krTE5DTFNCRzVDQnp1M0VuQ0t4eElQSnR4TDg2N1g3d1BVYzltYjcrRGRM?=
 =?utf-8?B?ZHNoRjF1dkJMSWJBd0k1REVpc0tPd29jbHY5SXNhSkdxRUpWRlpFdWdTdWwx?=
 =?utf-8?B?ZGRuNlRJYU1NYndvcVo0WHZKWHNZRFBZWW9vVWswTHhPYVRzMEY2MDlTMTdT?=
 =?utf-8?B?b0FGZjdaR0ZmamdXY0xmWFU4c0xKUVUzWjArTXkxcHlSbys1MHNCWlkyVm5G?=
 =?utf-8?B?eEhDaUFYTXoyOFdYbHoxZjQ3R2MvVmdRdDVPQXR4Mnk5R2RRdklreXlGc1l5?=
 =?utf-8?Q?rIqgXa9I4lFqKAoJTWc49/1zg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8edddb4-9789-4963-b1f3-08da8c106206
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 11:52:02.0192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: br0ystWs94o8oOca4Z8+wceaIQlMagDnWPcqVUSxCoUGdbtlDTwMIimhhNA+Yyw/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6198
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

On 31/08/2022 23:15, Jacob Keller wrote:
> On 8/31/2022 4:01 AM, Gal Pressman wrote:
>> When autoneg is disabled (and auto fec enabled), the firmware chooses
>> one of the supported modes according to the spec. As far as I
>> understand, it doesn't try anything, just picks a supported mode.
>>
> This is how ice works if we don't set the ICE_AQC_PHY_EN_FEC_AUTO flag
> when configuring our firmware.

If auto fec is off, whatever mode the user chose explicitly should be used.
What I'm referring to is when auto fec is on, then our firmware picks
one of the spec modes it sees fit (according to spec).

>> This whole thing revolves around customers who don't use auto
>> negotiation, but it sounds like ice is still trying to do auto
>> negotiation for fec under the hood.
> It's not really auto negotiation as it is more like auto-retry, its a
> simple state machine that iterates through a series of possible
> configurations. The goal being to reduce cognitive burden on users and
> just try to establish link.

Cognitive burden can be reduced by using auto negotiation?
