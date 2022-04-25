Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEEB50EC68
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiDYXIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiDYXIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:08:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A695460E4
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 16:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650927918; x=1682463918;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pKUgPYvBeyAqzKKo2wv9ibXeF2ec4HxtPU0r1Fl0i8U=;
  b=aKrdnEAGCpY13tRRSHyBLxNiaTeMVIxREHB3canxdbXW1dDxRrbbpT/9
   L0Xc5iYltt4qT6iAeKxIabUzeyPfsOtQRWELDKwhShCMubLjqL/QA0Nvh
   CqkwCdI7cYE4ZsJPlr2AHMCBDjn8LvWrDXmx6efw4QBlGVTUFVFtj86V8
   g4J1TuU0qSmenIN4G7TWjkSatTTIgMVKPCLfdaqaedD3HywXv4XlDUrQA
   3jMwu95gsOhFVifpFKhfrrDRErtZFfVL2wSD7Fs3SpZNcgQQYA5zywBpz
   D/50yC9KEJmyWRnALt81r2YAydfRJtXPOyTKd7D5P54MxM6fLgZ49sUXR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="252759135"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="252759135"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 16:05:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="595451484"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 25 Apr 2022 16:05:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 16:05:17 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 16:05:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 25 Apr 2022 16:05:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Apr 2022 16:05:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qh7yMDWGpAqAq3y2B4Inz8j3bIzr68xnoefZYfWJxK7+GsEdcq81YaWHVzrRKmTXlI9HCReCKBB1KUCiWAAPD+ebP36/sWKauT8P+VLRX3KEdwoIgv98m9N/j4c4vG/zXjOjQrTjjIfsQleyV5xuFaNNwLz4ZDOPUwYjzEfsEa07X+KvnJik4f0stv42Zu4vpF/Ei8EDorhowsT2t8f7pnP8AmsO2blvH+rREh3eJMfX5LRfm6k5t4J+Uu7LzBDfCUqO/R3gZwzibDGTokmYE6YE5fvZY8sCko+oI7Idz3j8n6rh6VN8EOPlNurrVSQFa7u/m9AO9rLeXDFyCVyotA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmryCQTGaWAJqhte7caIxtAyUHa4iAGywtMuqRPcrzc=;
 b=WvqjrbF0noDaZHG2Nbz9WLhgnJTDRTij1vr1Hd3d+dslAkwitefcxRlyN8asTnCQf77+kPmEJAxpNDfjN8DRU5mhbhg3lwGA3PsQqzYZL1QXDavChPUYw6H2OawyteqPW/nYw0R3oYesw6qhRL0KmsHKq9jpDWsckH4TioN1wh7HdjYWGLJJ7dPBdh19TNmI7dHCkiq0jQnfVUrXyO2NzyaLek+SIz0fNLjatML3In+nvpXSKDyNcUz+/M2LYaPMlalez+vq2uol1sFIEZ6PuEdbPFJ6FRZr2nE4Gt+PGAGxRF7gHgNStmDXMopUAd4HBRtz2tLpOsh+B5rqnQk3/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR1101MB2270.namprd11.prod.outlook.com (2603:10b6:301:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 23:05:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::787d:a92b:8a18:e256]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::787d:a92b:8a18:e256%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 23:05:14 +0000
Message-ID: <0e7161d4-e237-97c2-1c74-d3054669fc44@intel.com>
Date:   Mon, 25 Apr 2022 16:05:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
 <YWA7keYHnhlHCkKT@nanopsycho>
 <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO1PR11MB5089797DA5BA3D7EACE5DE8FD6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20211008153536.65b04fc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO1PR11MB5089A8DC692F9FCB87530639D6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20211008171757.471966c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO1PR11MB50899080E3A33882F9630C98D6B39@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20211008182938.0dea0600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20211008182938.0dea0600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38c02c7d-600e-48c4-c289-08da27100e94
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2270:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2270E0F926BDBAF33626CA24D6F89@MWHPR1101MB2270.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JvoheIOfAJr+8WK2MoZeT8fDSQNk6SrlVW4B6ep9uugSgaWjuvePIGv8dfrxaqd1f6zWzZQJ4FP6qIaNBbdoHyBRzOY4HcvKuJLffFhq9EoLm6mUN5xW5NQlj1iQTG7CLSNudRtbf8gZbfV0UAnwtOIn0fICBWbjW8HZGQ9coAlkkjaN8Tgp40cCXcXpOJ/TXQNMKJEYsqCibxYDeuEZPEuWI5ZtFx6dgVMC3mtB72s+Z6mt0lpF6f/mHt87SktHF4gSmxyEZP8RnxHbtl/hen6aBb/lYvopg2tYlysIcCRKBXkFWGyFv2nT6DJxT3E5lfQ7iHCgPjXKRN61Myei6U87KwduAbB3nG3J4b+he2Jl+UUv4w7rkZyi/0H+Mn5qb8d/tRmKFCV6MdNF936adeGXHxvADNOwt0rWFVC64tf/knzQxSzGRqEsfXDympQl60o6+rIh2oobpyHnxvD1HmhDxFxB3QiRUPlG6lEr5NMc2EZcpKkq70w4qUJOw7D+QGexuyG8akN1mRdHvoJa6+VMzmGXVm77VLkUGL/QT//JDhhTGWi2AKOFcopqoyKu33NWzPMbxVN6DcGh2iSf1AnCl/pfTBEqRPbgdQ+hPnomFZVVo7YJYPSFJp5oQqmmOWjf/MULWDiL2A0U6D9NkfnB92VjAUfiQwIzeQs8CRC8RPSAtO3K9BiY+L3SulF8Au6F3DEF5qzbXDUgNoSN9ElFjh+53p87QcDk7Bhblvk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(86362001)(2616005)(54906003)(15650500001)(508600001)(8936002)(2906002)(82960400001)(31686004)(83380400001)(4326008)(5660300002)(186003)(8676002)(66946007)(66556008)(66476007)(6512007)(6506007)(6666004)(26005)(6916009)(53546011)(316002)(38100700002)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDhQcCswaGh3cnRkQzR0aFRhYytEWHBsZTNVeTFDeHlqME8ycHJxUlNRb0dj?=
 =?utf-8?B?ME5DbGlVMkhmZzZCRDExYXZlNDZLNUxhNDZ6NXgwTGlQVkpaUEhnUnF1eHNz?=
 =?utf-8?B?Y0dQazNlbXJpaXpHRUJwSXZPR1BJc2xYOW9hdXlOWXFIRU14SjVKNFZYZzl4?=
 =?utf-8?B?blRpR2s3RU1ac21iVzlLbUJuYWY2dGpUakFvYVVpOGJCZ0FDWmdUbHVQUlhB?=
 =?utf-8?B?TWNPZE5vU211WERrT2hOdmFEUHovM05KRzE3UE1JMmF4dkZUZkYzeVk1Yi85?=
 =?utf-8?B?Vm9tcGJmdEJXVmhQMkVJTkdPK0YraUI3aUc2all1VmJ5MEEwYjM0ZE9NWkEw?=
 =?utf-8?B?NEFuSjZ4T1JEOEpFeVh5aFVxakdsK1BQOEdjcmVSYkhXTWNySCtXS1kvd3NS?=
 =?utf-8?B?Uy9qeldQZWFUbk9qRFBnd2JDc1ZDVlpOcU5Fa3Q4cGFxelpqSHBHaHpVT3Qw?=
 =?utf-8?B?NkJQZ2RXbGJuVjlZY2FNLzhOM3RPZnBERHNqbEN3UFZCLzhDNFNMYU9WMDA1?=
 =?utf-8?B?NGcrcldDekhBTWt3Zk9QRXB2RG54YXBMTi9tVkc2aGJYclNid1lNbjlSMjM0?=
 =?utf-8?B?dk84ZVVKOTFqVmwwTkdFd012TldMTDhSQlVOZmFMVys5anJrWHVLbXpuNnhE?=
 =?utf-8?B?clhRK1VyNkU5VFdhUWw5Ung3OVZRUEdMNFBDNWRCUXI2S3RHZXJWWS8yK0sw?=
 =?utf-8?B?cTZGOXRRYVFCZDFOQUpackhnYm0vY2tjWDJ5cXJtL3dKWDBkYWhBQ29EV3ZR?=
 =?utf-8?B?WGRheHlLd20rTVhTekhPeTFhTTN1SGV2Mit3dTMxVTZJL3Rib3MrcWdvekJl?=
 =?utf-8?B?ZW5QT2F3dFFzampPU1Z4VTdQZitDVXlqRFFYZkN4cW80VDJoTnM3aEVLVk5M?=
 =?utf-8?B?Vm5jQjd5cWIwdkphS0wwRHM3VUZPL0EveG5IamtUeVlIcGR6OXcyN1V2a29w?=
 =?utf-8?B?RXNRclJrZUppUkF0MXNRRG9rdm1EZmtYbEhCV1R0MXdkTnJzRjg2a2NYS2tD?=
 =?utf-8?B?VjZwU2JHa0JIV3l2amxSTFRpMlRVd0RjTWdLR0tvaHJaWTFDQzA4Mzl4ejR2?=
 =?utf-8?B?VUw2MzlLR1IxRThNQ3BmeVJwaUY1MU9ZaHNFLzZhcVVjMmJSTDdXY05EUERl?=
 =?utf-8?B?dnRFTkVIZ21PVWdzMkhTaGpYcVE1eGZrbDVma21PVGJ5WW1pZ1RBM0p4YjB1?=
 =?utf-8?B?amdaaE5BOTU0OU9GZ1VWNEYrbEZsL0Iyb0ZHdDJDb0V4QW5ydE05SXRJNVlR?=
 =?utf-8?B?bWJocFU5VDBIbTBzRTVDcTUrY2JVQ3lkN25qVEVJTHBoeWZEZUU4dUZmbnNx?=
 =?utf-8?B?SXlaMCtuRnc2ZC9JWGFHcjBWN1hJeWpsZ0dvK2ZnWXBWTG81ZDdOVXIxamJP?=
 =?utf-8?B?dDl0Rzk0VTVIQUdPZU92NE14WGdCYmFubktUa0luVHdmaDlpNFY4WlNPNDRY?=
 =?utf-8?B?UzlWc1orNnh5UU5jOFRxZEthOEQ3NUhkRnZJYktOUmpOQ0JJTHFOalYrSjlX?=
 =?utf-8?B?dUpjUC85VGNQN0NkY1ZDRU8reFU1NHJ2dDVUMXdFRlE0N29TMk9SYTcwNFpF?=
 =?utf-8?B?Qk1abnI2MUlLVHlJLzJrNnhMZVNEeGcwazVPRzlMdTM3eTRaNUUwdi9CTUp3?=
 =?utf-8?B?Q0VWNUE4VUVJK0gya21RbGtlbndEYmxEY3hQSVZ3Zk9qalNqdXhhelJvUnVP?=
 =?utf-8?B?VjB1VDZkRjJvQmdMZm9NRnU4a2VKOWF5bC9ZbjJDQnV3RDlldmZqN1VQYjI3?=
 =?utf-8?B?T1RERHZBUjkrYjBwa0ptYis2ejQ4eDFWTjl0bElaVmlXTEhhRW40dUlnbk00?=
 =?utf-8?B?MDVsbk80aU9zNDAyUTRJYkEwQTlDd2VhcWpvTFF6NzdJdG5YQU5LUVNHTStC?=
 =?utf-8?B?d2pPT3l1WTFBcm0xYk83VTlrZXlCU2pzSjhZOUttVXBaNThDRStxK2N0akth?=
 =?utf-8?B?RlFiVmIvWnA1Wm9rOWpRU2pnaHFTT0hQUkM1dlVlK3VzUlRRS1diRzlCM0Q0?=
 =?utf-8?B?ektkbVVNVUNqams4TGJ3elhSRm83MmJRYWxSSDlnalFoekhldVY1NWVGZmUv?=
 =?utf-8?B?bHF4QW9nd2huUVZkVEpxNXlvWDRPd3pnWkg2S1BRN3ovdURHVko2S0VyNS8v?=
 =?utf-8?B?cExZdncvNjExMXhuTUtQNm9mWXZTNTZBRUVuei8zc3BJQmFCZ3JUdm5uY3o4?=
 =?utf-8?B?Wk5FV3N3VFIwb1JXRndPemx0TnBST3pXRFRkbm9wN01aK1lScU95QWJjZ0lK?=
 =?utf-8?B?Nlg2Tm9aSmE2SHlzWEl4elpCcHV4cHVCeFhlK3A1MTJoNXd2UlY0TlZJbDYy?=
 =?utf-8?B?SHVHaXhaYWZuOU5vTDV1UWVVOWo2c0lLOG8xbUozZEF2YXRUN2F2MFZqZmd5?=
 =?utf-8?Q?mfhQsWgIMxjlPC+g=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c02c7d-600e-48c4-c289-08da27100e94
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 23:05:14.6436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nk2/Qk150iZ2C12k/9bFEIq/T97yrmfaxNI6ZhOfPNtJOLRwY5MXc2KgKEfCIMp83irHyjveDMUitdq/wAye3Ng/ekSSYSG5TJ9odmLeqmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2270
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/2021 6:29 PM, Jakub Kicinski wrote:
> On Sat, 9 Oct 2021 00:32:49 +0000 Keller, Jacob E wrote:

Heh. It is frustrating how easily things slip through the cracks. I
dropped the ball on this.

> I think the current best practice is not to opt-in commands which
> started out as non-strict into strict validation. That said opting 
> it in for MAXTYPE validation seems reasonable to me.
> 

Opting in would only help future kernels, and would obviously not help
existing kernels which currently do not have strict validation. I
personally would prefer to migrate to strict matching, but understand
the concerns with breaking existing usage.

> Alternatively, as I said, you can just check the max attr for the
> family in user space. CTRL_CMD_GETFAMILY returns it as part of family
> info (CTRL_ATTR_MAXATTR). We can make user space do the rejecting.
> 

Yea I think this is the right approach because its the only way for new
userspace to properly protect against using this on an old kernel.

I'll update the iproute2 patches to do that.

Thanks,
Jake
