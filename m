Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B9B61864D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiKCRiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKCRiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:38:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F32140E4
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667497091; x=1699033091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L1+adDTbgNzB3hI+qB5v0/uPN8sM7Fffmg7x9vDl2AE=;
  b=e+erqYa93O39KgA9TZOuxBNIYqI8Qf+ATthWVeHD54F/lntF9jNN+5CX
   CpjFHBbdqe3KQq0NnbO8pTfXnxomU4jD/cMfpWfNDvYEitRhiBn28ow8R
   3lTt5jymLbHUJauG6wlhHu2I8dA3BuEHL0ojUiknud9QgjTmd5KiIT9/G
   4qoNe3heOyvDjqMgbp4GKXJZjceyWn0koWqn3sSBM+LePHgnTamu9VHkt
   HQY1cZXs8kgCdJdrkChsTjC8Li6WQB+yurtZEeqrA3Gv+v2SZG5tuTTtW
   6m4qFqPp7ALolWeLF9h+ESUM1kja/l24s733+qwNfuZHCgkaq5D6FIHPm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="311488920"
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="311488920"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 10:38:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="724032114"
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="724032114"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Nov 2022 10:38:10 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 10:38:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 10:38:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 10:38:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIcE6MtYgrwH2ILbtfHEMsoUPcFn+++1b98QXIQ/lDXdrMB2pnYFL7amBUf7DGxK7MLUg0DSFqbbLTlRl6TBFhtqD6bypKuIsWFS1Ds0PxBE4k8CrRq0Cuf2zNl3mC4ofHxN8GxqE8ruKfOJQHKE1/p05w1yF9BJyJz2zHX9ddqI8R/cARq8Mocth2su6ZF12oFLlDnF+5b5lwPnIoALULE4MSxFPMz5V/4NBWYgzpwYTUipqjQiub7TuHWVEczeh6t5wD9d+nQiwWdRSA+l5blVF3Pn0usIHdECU+5FPEId1+UtYcizfxdJMDsl0QupObf2gHlkikzeGU5BzVzCtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrbtHYPHZ2Gf2Ia5M3hP0t8CGCJChdVu5pel4S/gt5s=;
 b=WT511707t+oizOEiBOSsKKU/N8Wp0DphsiZDpJnRN76Iv9muWCy/816+7c9d/1VtegldfkedkQOCcAro2ZJdnPnVtETvJYSHKVGDpaH0LKWfBPfmIKpLCQck91+5fUURENFvbU5qH8z0NMeqixqhnwwmjmOtMVm+BgwRYAHNuUgEgMo8S5Qhw7pxUdR/quteQM+V50hnABbyavxuubEnFH2+4Gpec94oJmjNBRZznwUOUUN6vCbG4McDbP09aicYAfhjudKc510gBujIJHv2002xVLXQ0hRZR2zSIovnhCfRyov+EcmXhwdXXOsU/OvLGFbpQCQIT/4aCNTUpurG8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM8PR11MB5624.namprd11.prod.outlook.com (2603:10b6:8:35::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Thu, 3 Nov
 2022 17:38:08 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%6]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 17:38:08 +0000
Message-ID: <0a9050c5-1df8-db55-755b-38239e5fe7af@intel.com>
Date:   Thu, 3 Nov 2022 10:38:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next v2 06/13] genetlink: add policies for both doit
 and dumpit in ctrl_dumppolicy_start()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221102213338.194672-1-kuba@kernel.org>
 <20221102213338.194672-7-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221102213338.194672-7-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0172.namprd03.prod.outlook.com
 (2603:10b6:a03:338::27) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM8PR11MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: f0628c9b-a674-45ed-53ad-08dabdc22c0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3YUmd5gDAUfiOx6cSOrY8m5MFudNEg1qV/1Z58iNEPG2+0IaQKMAGrDj/g1lpzNFRLo8O/p1h+3MSnp/Srg4OsPvvmeWgFlaIN4QMyMCuiqQdmdByKchM8KFjW7SLRmDAqA12FyXDDPJ/1oXoWVQlrXSrFmRsruC1gG3pNA5URkUj6UI4tbIRpX01cTFyax8Afewn5/7TVrRWhZgI6UctoAtm82Kvk3f+ELET5O0QzqL3O06zYers2Z0aiEMUcym8sUK3htALTbYe50Bh3APCXr078T8WBB2nuuGno63+rMJD/zP75pQtZ2HmW3/0g4NSOoqgac0QxPn4NT+IxAtpxpyQWh5Pr/dtnTjIwcvC+vTzRuteFNm7K7X+NtfMURUcNfWKfzUV3JHgQSvAC+eOTzi/2hbNoKd8s1eJePrrJkS9PxIe/iTuF76L0DEox5lou+PHXzeWulRY2Wpzwg5+AKzNOzNsAOxEKtZEXNthkpIRAv3CAJgogNYOfJW7NF6KT6hFuVIlQB3gHu6oEMeLVdqhzi/Jut0c0I8uYK2ehY6yiT3flDTUvcEAeRDvROLE+r6uBv40vbxwsmfHIV0NbyirYWP2iDeGOB1E+YpQGEPTXht4wO3XEbkedphbmxtA3HqKKiJP8BtDEZwflpy+wdFtrUnyEm7ROpZoFmms2Gd+IGfg1Sex4AedffcVzbB4SPu7OEXQkaLcs3b7OwN8P50FU5WDZReKrom4uF0BathR1gSMWPZp8VSxqESKeEkJ5sk3B9Idya/iCOm2L373iIeDI4cgWtqXLpae2NlNjc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199015)(66899015)(6506007)(36756003)(31686004)(66556008)(8676002)(86362001)(66476007)(186003)(31696002)(38100700002)(316002)(41300700001)(8936002)(82960400001)(83380400001)(26005)(2906002)(66946007)(4326008)(6486002)(7416002)(5660300002)(2616005)(6666004)(6512007)(478600001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVJjQjRzNm1EemlQb2NRZEFEeEpwS2FkVWd4djlEaFV4MzM0Y1ZPZFl2dWNO?=
 =?utf-8?B?M1FLZnI3VDlVSXpSWmZQL2c4cjRtNituUFMzeTRGdUovV0kxZWV1RmxQMEtw?=
 =?utf-8?B?ZnI3TExvQi84eFZKNllEaU9DczdVNmh1aTUzTXk1REVlSkhEdHNZdkg0aHIr?=
 =?utf-8?B?V0xUOWVEUDBuTWtCVHJWNUcvc1pBVmlVL1ZxTlF3V29pc3JuaGNlN3FyQjIz?=
 =?utf-8?B?YnZaWHhBaWpzOGFFdTEvNHR3SElMNGFjY0FBalFxeTdvRmVKQzZ5bWhUc3Q5?=
 =?utf-8?B?dTBqWmxSeEg5NU5ZMkZSU2NRTkl2emdUSVM2Uko4MEVDOHl2ZzE5bDF6d1lN?=
 =?utf-8?B?WXR4Zm9iZ2tqbTRhZVNGZHg2amhBOFhMYWdQRElMdlJIU1VCMkV1OXdhUTZl?=
 =?utf-8?B?RG1WWjN5OE9WU0dJUSt6aFZyRk1QZmtaMloyZkthdng5WWw1SXV1N2lmMXBZ?=
 =?utf-8?B?MjJUeCtzWEE0NEQwb2c2SmdLdXUrb2hNQ3pFeVFuR2VYRC85eUJoNE5nZG81?=
 =?utf-8?B?NXkrVGJHR3dRU09ld2JVd1hvejRwRUIxOEVxNjhzbk82TzJvczVOZlhySHdk?=
 =?utf-8?B?Y2k4TXFORnZUdzdJYXdHd2hnbWREYlR2Z3dkbUhUalVOQmFHNmt2QzRGN0FQ?=
 =?utf-8?B?OXA1NFVyeUhhdnczYjRVU01hRitsRjNPRTFNTnoyT01YRkxtWkxpMnZlK0xy?=
 =?utf-8?B?cU9ZRUdVbjcydENESkVKWU9MWkd2azhCcThGNzlwTU9IVVNXRHRxV2g2L1FX?=
 =?utf-8?B?TUJqQmI4b0YyN1MxTUs4dzRWbWZLRVowa3FxL3MrRnNzL3lVcVpBMkYvYkNM?=
 =?utf-8?B?MEZtODloMnREZ1ZSQU1GcFF2eVJ3alovNStleDlaQjZTcWdKRm9aUnErSVgw?=
 =?utf-8?B?SUEzNmtmeUlIU0xrM1NwOXp4cWs5ODhJZ3p6a1dRL1UzR0hURm1uaDZGVWpJ?=
 =?utf-8?B?VGxKbk44bHVSSUFpQzVtYUtQOVZEVGl1cytJZ01GWVFHSVFnMFM2N3YxWk83?=
 =?utf-8?B?Rm5MVGxQNXdXbk10Ukl3MzZQeURaRjV6WC9IWHphUUxGRXZYMWdWVzIxVitI?=
 =?utf-8?B?OHlFVkxQbUJlazlSZHBqYUlSSnd1NE8xeEZWT3JONC8wNTNIOTAzZlE5M1lF?=
 =?utf-8?B?REpqTEdCZ0VoOXp6WWFjeGo4L1F5VmJiQitHUCtHUW8rcGVZaVVlUXJIRW5C?=
 =?utf-8?B?bTJ5QW02Nkg1QTFIS0JNV3NLTFBqUWgyTXkzcjhvaDFHaU1zUVpmb056OFVM?=
 =?utf-8?B?QVE3cTkyNnA0ZjhJNGJ4MmdyRlNPQlhUSUhYMWVMU2JBSGkxcllSb1ZET0x0?=
 =?utf-8?B?QW9lV3FaWmJubHp1SXB6amZhUFZSRDloN1pFbXpYRThwVENkSlRBbkNPRjAz?=
 =?utf-8?B?dkFac1RlYmZod1B4Syt4Yk9lT1pBZi9DY0luTWJpMy9QY0lZVllVYmxlSlF5?=
 =?utf-8?B?Q3FCYWNBbDgwamRuK3F0UVErbVBhMjFDZTJCaUZTeDJrMjRmQjZDOHh4VVNZ?=
 =?utf-8?B?UVJkL3pZOUVXNG9XZ3RTczdEYnU1ZHhvT0tmWFprMmswbEc2bjZvSFJJazZm?=
 =?utf-8?B?UFM4bjlsWUYxbFpGejY3ZTUyUi8xa1JYK2NFZjlHUk1kZUw3S2JYY05MMTMz?=
 =?utf-8?B?bTdocTFobHkyUnh4b1BPVkpMNW0xcmZ3QkRXRjZiUjRGQncxeDhpWHdTWnJH?=
 =?utf-8?B?TndJL3hJRVRBMlVWajdKWG1mZlMzTWcwcFhtRDVyYkRpTXZXdWYxV0RxVUkr?=
 =?utf-8?B?V0ZOQnZpZGJwbW1CMDRoRjcrdGovZDJlby9FakNvSzZabDZkQVVjM2s3TEFZ?=
 =?utf-8?B?YjhnWE1TQzR3NjFFbkRrdmo2ZmFRSy9tdGpCUmM3NHRVM2ExMFF0ZzZtM2dM?=
 =?utf-8?B?Q1B4Mm1aSTRBLzErUFJlUS9nVUNmeXVoTlFpOFU0S2h4Z1M0cGhOWVcxa3BC?=
 =?utf-8?B?ZHZ5R1ovWjZXY01PSGUzVlNjM2dCSCtNUTZaR3NWQzVKc1BpODk4WlNvREJP?=
 =?utf-8?B?ZnZPK05ydTVVRnozVE93TGVKMU1maVFXUDFuZkdLSE83Zkh6bEs4SkRFdU0z?=
 =?utf-8?B?R04wb1MxbVZYREVkcWFhdktUVi9ISU5TMDI3aE1IKzUvems5UFlPeUt1bWlH?=
 =?utf-8?B?bUpLWTdDVytzSXdoMmt2NktVRk1QbXVIazhoMmVZMURwTHpHNWtUREtUNlhh?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0628c9b-a674-45ed-53ad-08dabdc22c0f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 17:38:08.8571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7v10tTM7VDvF43+ed1IefaIO1rny6HQYEDkqDXgwAPk/6WLO/QubXafTDtShhNMEWULCdKTlQRkGLSaEZe98+W+RAQMdESW4FKwWK1BJtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5624
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2022 2:33 PM, Jakub Kicinski wrote:
> Separate adding doit and dumpit policies for CTRL_CMD_GETPOLICY.
> This has no effect until we actually allow do and dump to come
> from different sources as netlink_policy_dump_add_policy()
> does deduplication.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   net/netlink/genetlink.c | 48 ++++++++++++++++++++++++++++++++---------
>   1 file changed, 38 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 7c04df1bee2b..d0c35738839b 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1260,29 +1260,57 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>   	ctx->rt = rt;
>   
>   	if (tb[CTRL_ATTR_OP]) {
> +		struct genl_split_ops doit, dump;
> +
>   		ctx->single_op = true;
>   		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
>   
> -		err = genl_get_cmd(ctx->op, rt, &op);
> -		if (err) {
> +		if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
> +		    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
>   			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
> -			return err;
> +			return -ENOENT;

We do lose the specific error of genl_get_cmd_split here, but honestly 
not a big deal since I think it is always ENOENT anyways
