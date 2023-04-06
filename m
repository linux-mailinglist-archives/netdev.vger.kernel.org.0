Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B516D8C28
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjDFAvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbjDFAvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:51:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0574ED5
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680742265; x=1712278265;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cYfD11TV9fzH8daBMZdbVk3ze7TQtPAB7P+AMpjRCoQ=;
  b=eI2EY5SqjCY/cE/3yDly4yxNUIPUNcaLJTbL6niCbXYypwaZN+EP4hEs
   G/eWqqu20YYDZT3/FCNR/8LwQqjEvHpR99M1miaXLsheFAp191iRTQfk4
   ZKOp5xHlTpGMmU8VM6PCMSiXrJxamlal8hHzIX9zhKP4iX9k9wUDPXgtR
   pl+Nt1FQsWlyeDBYLf/4LnCn27Q2SRw3zx7OLIE0v+o91U1ai4/KQHCGE
   ej5m0zA6Clkcmue0tQPQ6RQuIWcsnpEfY1IvwL0EUiDo5m71DQXBPN/L5
   EqWGZNrvD1aDilkhhULterqFoxk1Boe1S5dym5PuerV5NZ0zKPHYhAC12
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="340098888"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="340098888"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 17:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="756186448"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="756186448"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 05 Apr 2023 17:51:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 17:51:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 17:51:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 17:51:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBizx/EEoikys3+IZ++ft9v2pNKYWwPYhN0pNVdBd8bX4wDPB4jP723/jJKs0hrqCoc+4dLMn99axS4tZt8DiVfjVjbGPrGXC43BUQp/dVJtXBF57HRa2RSp1GELj4wxbsbHH8Gk6nq4EDRzKTtLRu6aiAu6cIkLcXwCV/6efx1qcCo7ZtCxUy+yOGd+nS6Ri3lMyxg21SskwaaVSBA3ZiGnzFUv33rZvCCUP+QILlLBJjc8iYE5y9yfpR6bULbZaaMLy7yhGIO6qMuteLBQ4/jiG81tv2ruCTqgQmKQPgpw9b+eB2q1uFmqTF8lV03OdGAHasNLQ8xGq6XNLuPzeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXgtJSADisNWDfQ3IzVlX5HDz7Zc9IvCkgHeMuRIwlU=;
 b=YJPswI373/xqXG44hq+xH3mthlRG6ehGhq0R/e6D4CV3s/jDpAjNhPkobKv6RAfadWaYo2T+eFVhaR8FVqQAmS4l/b5oL7QPqXiFKU1L9YqdLC6sAs0op7+I8Su4pa5ut5HU8flklKIRSbuIISQmUrduH0S/ncVJh9VrX4HOOu9h94ng3vIdpG+LpOz76RWIv1nT9h3IUY+KpB2aSBOADv3UF3JEf2mZchtVzBE7afAHTg8wcYXrpKNpu10FbHKyjkPlpmG7uUxXA2FnOlQcCt8hlPirkdGt+VExCgCdfLnMsP3Z363makatB4VZDKACEvcuf37MystlldTV7xaqeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7420.namprd11.prod.outlook.com (2603:10b6:806:328::20)
 by SN7PR11MB7066.namprd11.prod.outlook.com (2603:10b6:806:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Thu, 6 Apr
 2023 00:51:02 +0000
Received: from SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::a3e9:b91e:a70b:100b]) by SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::a3e9:b91e:a70b:100b%6]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 00:51:02 +0000
Message-ID: <99053387-16ff-9ed0-ef12-7bcbc7a7af2e@intel.com>
Date:   Wed, 5 Apr 2023 18:50:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net 1/2] iavf: refactor VLAN filter states
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>,
        Rafal Romanowski <rafal.romanowski@intel.com>
References: <20230404172523.451026-1-anthony.l.nguyen@intel.com>
 <20230404172523.451026-2-anthony.l.nguyen@intel.com>
 <20230405171542.3bba2cc8@kernel.org>
Content-Language: en-US
From:   Ahmed Zaki <ahmed.zaki@intel.com>
In-Reply-To: <20230405171542.3bba2cc8@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0112.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::14) To SN7PR11MB7420.namprd11.prod.outlook.com
 (2603:10b6:806:328::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7420:EE_|SN7PR11MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a01e90-fc48-4b41-4886-08db3638fec6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WPUUbdMmyvhP1VTov10Nt8LRUCSxeEy3ny98RjKk6mmyfhtveg3FayZUdxwzk6aHZMEg7886YRoauJN23j3ird+OI6+I77VQ3N17V4Tmpm8r3H97Fty4Isuqu3M6sz5c/LvFI0izAJm5ScEV2cFDjvZjhjzgclyvodv5yuSeSKSqn8udT9+tGkbWxADnYMsQH6q10Fx6b9LnVYx0gMBmKw+rthYje+HqKgoEtXivlF8Hkng/8w7bH0LK4dLq0wVIj7xnL58OTeKZds/mCyQgemLzJcqCyKzoa5r8xjmGkxorr/EfR3b++KF++0SyjGd6A7TbVCX+Oys9Ol1G0OEjD/RkkOV4UMz9VT11eykadFK4mm3sauJZiDrfytkpmK7j5MPJq5gk9wxtbnwpKQwOJABcCvR07baxV3/whsTGcn9qFY2bOxc+QzTyzmneojIRxBRb76Um625rkNrrA0UPaj8/hz3oJTmMIAlufSgG2WBgEVqboTBTU/TYDhlpX2EQon0LRX5RA1wH1/a5IYgeSU6Y8XvjlRyzjsGb89FtNa3/57Mx4E47bpAsDRxpXxX/gMIvqoUY6gYojgLP4pEXGLAm7/2jPy3enHsB/mRhdrKFHLfnEjorgiMIR2YS/pPx8UzqpCY2V/+yq95zApQRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199021)(4326008)(86362001)(6486002)(8676002)(66946007)(66476007)(66556008)(31696002)(2616005)(5660300002)(2906002)(186003)(26005)(6666004)(6506007)(6512007)(36756003)(478600001)(31686004)(107886003)(53546011)(44832011)(6636002)(316002)(110136005)(4744005)(8936002)(41300700001)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3pkRHM1TCtJeWlNSGF1ZVEva3M3aW5lUlNSNzNFaGw4eHBjVndKWkpYU2Vt?=
 =?utf-8?B?QUpkQ3M4TmhSR3FIeHdHYjlPbUIxVmtCTlVHVGtZMEpRWWVmL2NIQ3dtWWs3?=
 =?utf-8?B?YVc4WUg2YXBUUkpteVJaYXlPUXdiU2YxNWJ5V0tVbXBPOWFqdEFTTVZYaWdj?=
 =?utf-8?B?RkxCNWMrdXUvRlZqaTROQlF3U0QzZXAwK3ZZMkRleDlqQUtWUjdQaWxsR3JL?=
 =?utf-8?B?b2R1NVlyODJkdjQ4SHJZaXNsRGNvT05oYmd2RDJYcGVCcTV1Slk1cGtMUkNW?=
 =?utf-8?B?WW0zQ3gwVTN6NTh5dHo2dUROcExGRGpIQi8zNGJaWFRSQkt3MGZxQ0ZZUjZu?=
 =?utf-8?B?eCtHSW9RVmxXZ09vM1htdHYwZGpCOWRtNytPek90L01tK0h5TXZqVXRjdVFI?=
 =?utf-8?B?Z2RKTndmNElIeWsyZ1pYcW9Bd3NmSEpibCsrMGtVN2JndTNOWDJFbzh2OFRS?=
 =?utf-8?B?YkljeWVVK1J6Uy9DMG5VVG51NGlJTWpmTkY3UUVjOURhOXRVTnErNXVuM2Rj?=
 =?utf-8?B?MmNPcmJ0SytHZXplNVQwNzlLUzFLWFo0N0ZpSndaM1pjbjNWQitHbml3UVhQ?=
 =?utf-8?B?OGpZbVVQbDBqejZuYjJ3ZkptTU1pQjdXbnlCY3BMU2hncmVRYWpYU01xdWFu?=
 =?utf-8?B?RmJvZld2ZHpsTlpERjR3ZDJHbmoyVG8vbUtzMjY2NUJ0QXZNdmhGakJGbkJ1?=
 =?utf-8?B?bjA2ejRPTXd4S0w0Q3A1RG1yNHFPTjFXTlg5cUFWRzk4UkZYYkFja0ZrRnhu?=
 =?utf-8?B?S1QxRGNydldxbysxdCttSEs5MFZjZm80Sm5rWFZQMFZrQzA2Nk9LNGFSYkxO?=
 =?utf-8?B?cVV3aG9DWjJCVjFXc2t2TDZzU3QyR2xnVFhqU2ZQbVNVRVIvMVcvay9Pa0c5?=
 =?utf-8?B?WWxmZ0gzTmxWK2ZhSG1DMUVvNG1lQXp1MUtWN2Rmd3g2M3pTdDB6TERXaHdh?=
 =?utf-8?B?ZVB3azJLVldKQVEvMzRUTFdWQjkvUHFOTGdNTWlZSEZwVzNJQ2ZvRWFnL3l0?=
 =?utf-8?B?a0FlOWJuT3pEaWc2RmRnRjJlRVZxY0oxcldqaEJRT1FrTG5TMnkzS0dKWXA2?=
 =?utf-8?B?dndIMHF0MmVJYU9zQ21QdFp2NTZqRzh1VVM2dzk0dUxTSWRoemRvdVl4Uit1?=
 =?utf-8?B?WXJYYW5pYjZsK3FQZFNvV1BCQnRtOW42V29SbDNqbW1Cb2hORXpJWm5wS08x?=
 =?utf-8?B?Q24zYzVqZHNGRU9YUE1aVDVrbzd1UUJ1U2JHblhsZ1dpSGs5TmZzbGhuS0Zl?=
 =?utf-8?B?azhVMGp2L0U2RnJyWUZ0d2xoYnVTV2s4TGF0RlBZNGFDTlpGbDlhRHh4NjZJ?=
 =?utf-8?B?a0RRU0VTTHRvOUJXRHZFck04U0RGcW9jSFRPYVc0Y3JieDBHMm9Vb3dzQWFV?=
 =?utf-8?B?amFDRVZ2bDJOc0YvMnFJNk5SOUVOZ3FjakxDZlFuaHZ2ZGtHWkpsVFIyK1p2?=
 =?utf-8?B?WXRyQTI4WnNXcGVCb1hWdGU3TGNSN3N3U2YwczVTVnJLMHNlb3NLNnhoOVZN?=
 =?utf-8?B?WkdGVk02TjNPZEtFRC8xbnVvSlB3bW1uZ2cyeHdTMkFGSzZpVkpMTXhsdWFk?=
 =?utf-8?B?ZHRwT0xRYzJGbldBZWlYSXZES2dkOHBtYXhMNlk3NzRsQ2VENFdZRFIwTjho?=
 =?utf-8?B?OVNVVXZoQUVPYU5HRWZGS0Jqb3M5UTFTUUlkcVFXZlZYUDNkZis5R0RSOVdE?=
 =?utf-8?B?NVJ4Umk0ZVJuZ1g0TTJXbzR1anA4WVZJbEZubWNwY25NeWNoT0EwbjNZbFRQ?=
 =?utf-8?B?dHhDNTgxbGZTM282NkVVNjdJTllxVW9nYXdBelc0SVdFUW50S0NSTENsVGow?=
 =?utf-8?B?UEE0eVpWeFEzSExqd2NHWVQyMGl3SXE4R0xRVk5PQktWTzdNRFpPdG10OFVY?=
 =?utf-8?B?bDRsQkJMMWpkRGEzVnlMMnRLSmtMM3JSZGpGNStqK3cvOTVsSkFOQ3dzOFhq?=
 =?utf-8?B?aWxkbWdTNmxrS0d3cjFzQWhiRjBCcHluSWZyaGx6TzJDTld0ci82M3A5QUc2?=
 =?utf-8?B?RWNKQkhma1BnNWIzSUNxckcvUFV1V0Y2SDlTTUhIdElOOGdWWXJCOEFZRUk2?=
 =?utf-8?B?eC8yZzBjVGR2dHh2ZVpoNjk2VzVGN2RUbE1TRzJEcDZ6QlpIOEU3V0dadm8z?=
 =?utf-8?Q?RPZKHMP9kYRkrx3dwRpsK2zrh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a01e90-fc48-4b41-4886-08db3638fec6
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 00:51:02.6366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLoQ2JhtPgsNQOEMJqpp/CCEUDl/dfuSWPxgkLGdSxbJ8xqUd/BvAW0cKT5XCCNVeF59QglthVeAq+vKuGyokQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7066
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2023-04-05 18:15, Jakub Kicinski wrote:
> On Tue,  4 Apr 2023 10:25:21 -0700 Tony Nguyen wrote:
>> +	__IAVF_VLAN_INVALID,
>> +	__IAVF_VLAN_ADD,	/* filter needs to be added */
>> +	__IAVF_VLAN_IS_NEW,	/* filter is new, wait for PF answer */
>> +	__IAVF_VLAN_ACTIVE,	/* filter is accepted by PF */
>> +	__IAVF_VLAN_REMOVE,	/* filter needs to be removed */
> Why the leading underscores?

Just following the convention. iavf_tc_state_t and 
iavf_cloud_filter_state_t have these underscores. Same for iavf_state_t.

