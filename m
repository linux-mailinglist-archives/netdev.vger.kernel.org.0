Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459E55A6C7A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 20:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiH3SmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 14:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiH3SmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 14:42:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8C86E2D0
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661884933; x=1693420933;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mBcxkNhp7t6CwMOeKa2ogQg5b2NlZh2CvUAmP+7f3Hc=;
  b=nKgh27FnXM+OW8l6oMnKoOybr1M5CVtO61DWr0jEcJQT45dEsejXMAre
   TEQZ3X2jIwbqHd1s0vVx0Uo5z6qyiZZBaZ/Fffa0PAYvk2rg8TCEup/1k
   APB79xW7ouMBBjWfy5StkFTEIxct2p+9WK88PnrkIs9ajwnAzXJBrILfs
   y5D9nzwem3YPX7YnsQajiC1J22vLMLjzWl0Ibuq4vVBWy2gWkpzNlM+jZ
   uHkVtkLkr3/g/vOOWtatmFAVpzErsaN5DILSgTTw2Qk0N0zLGXw/Scd8u
   SWhFJ3e2S9K4Rbdlnft5i8pUeWYSRc4ZCrQLKVefAUNJAR3x7kXrEStnI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="296550851"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="296550851"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 11:42:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="641509413"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 30 Aug 2022 11:42:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 11:42:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 11:42:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 11:42:12 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 11:42:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyK5DZtoQvDS9S4EzOkU2hJ6TbzEQzjFLbQsfLGm94rCOf2U0y5t/K7RdMAmQmS2eYIYR8DlftC4tD+9Y1h5bOYmKtZXYIKs53cyIBKh3TGWyAY1ThD1ItbzxlLO7Dho249jBo6IPeXLLu4BqcHhPBp9Bg6kmUrKcMLw7euc72nrIMz7WtEzfY/3WeJZqEyqikd/M3ssFJkQTBmywQ751ZjNKWns02wvPfe2QFrIoLOFiqHSqqZgAVEMsH4P/92IBSiZgyZwqVexVN31+1Kpa5MQGFz8o64ucJc1I4FBv6aevoowHC/2Wt0lQulnwP/1nea93wekaVFFjF2wgxVnOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVJt1P5oNfQ3cqe2/dRGTlC15yu2UdXr2nkFpDrpkIY=;
 b=EydETE1eHGjYtPNYrLVcsfhhctIwzpPQCkgYDCdzeurwEIMUAZKt+oxW4yDozsUJkG5MOEAUs5FebbFRcMExjh6RLXktshq9dBXiuEKMRMhLX0bH33cT6YtmN9NvuCMBZbs3E2JBDzQ5wK1mJekFbNlDfzAERwAM7AUPzAKsJZw8c5QzfSDdh4MFXPm7Yr6BWLu1fA9e5Dmf9f1JuCj3KfpswmDmI2AgbslG28AdWQpYT7LSKi0je/1jG46GQchBH/sB4USo2aRTIWBjjwvYKky9FpL824JtoJ5SMjmyY8WlQcfBQ+3anc6JF8nwKoISDogx5C2JevwaeUkGywQtvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4921.namprd11.prod.outlook.com (2603:10b6:806:115::14)
 by MN2PR11MB4477.namprd11.prod.outlook.com (2603:10b6:208:17a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Tue, 30 Aug
 2022 18:42:04 +0000
Received: from SA2PR11MB4921.namprd11.prod.outlook.com
 ([fe80::cd77:7dd5:224:6690]) by SA2PR11MB4921.namprd11.prod.outlook.com
 ([fe80::cd77:7dd5:224:6690%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 18:42:04 +0000
Message-ID: <687cb51d-8a57-ef60-5432-e63f4c01b53c@intel.com>
Date:   Tue, 30 Aug 2022 11:42:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net] nfp: fix the access to management firmware hanging
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <oss-drivers@corigine.com>
References: <20220829101651.633840-1-simon.horman@corigine.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220829101651.633840-1-simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::8) To SA2PR11MB4921.namprd11.prod.outlook.com
 (2603:10b6:806:115::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d4af83b-c9cb-408b-c169-08da8ab7554e
X-MS-TrafficTypeDiagnostic: MN2PR11MB4477:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SjQNuw79BrgeVPrRT5JAy6duQrB2maTUODuKdM8q69sfEriMiog5NLXBGiVZxV4GTlunCCPt1zt59N0mBH5kzin86LsGWSARe8CfA5q9y0BOKjYfiafyXFxeK7fPsGlIapvlWKYpVbl+M571GWVKSML4Zt3v2qxAbwYfwt5GQw3A97qYpEFVZWeNSkV/2XAotbKm2KcCYZExADMO+5aqQpin5GTooVCYBsY8+mU4F2rvdGlSTDXaj0MuhaYLu4wEsZGMk4Kc/At+gCcqzKy40q2i8aO7Uf3B36ke3S4ryySXdXraPE16M74D8gXveX+u2qYY9X2W2xFxQY2CU1LBF9qh14nhULcRo2COgErNMfgayikV2uvJff0gNKQLymP1C6MOAL2/wyZg/rKmkaepXcdiId4ME/UblMJxUAzgZMJLM2UDXIBEtClhUpgZhIAHteTp1nC9aRHEXjhwWFnyF89EgoUy+f5ryw31no0TJDogo7EzXYrJetb10uMQYDsNjXmWfAV8zlht3a7FniwvdAfNzdwMV0urybjbXtvGzwDs/IziNBH3QIiAZcK1boSne+FGZsf9JYkdOCdiMBaUBpmL96JMDjBfzizrgOvBeobmlM2hjnXpzczWnPtNnXuOvusqwVkKa3bXGw6OErdcbiOxyVJJk7VUpzvhRsYjOK1+ezsUd59K7jvrEWPbwcmQnnnfpInSXjJRMLLqh/lNXXq1+bK7VUkkvFyG49mmYYxjZ9fb1JjPLPBsIWdpJ8eKWaG6XLzSVraCRDtLSUBntmu2Ua/GxMfVMEWWUKgZtI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4921.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(346002)(396003)(366004)(8676002)(36756003)(31686004)(316002)(66556008)(4326008)(66476007)(66946007)(86362001)(82960400001)(31696002)(38100700002)(83380400001)(53546011)(5660300002)(6486002)(26005)(6506007)(44832011)(6666004)(478600001)(6512007)(41300700001)(110136005)(2616005)(8936002)(186003)(2906002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1pqR25OeHIvcStoVWp4aEVOZjFJYlZMekNsSE9tM3ZDQXNFMFFZU0xRV3dQ?=
 =?utf-8?B?Z3RwbENxbUkyODMydkJ4Vjh4eU5kcjFBL3o0K1ZxM3BGMFpid3pjZjhMcHNh?=
 =?utf-8?B?MHhVNHlSYytBSldWZzI2MFM2MWZnTU01V0F3ZjZOdUthNDJCNzRidEQ1TjY1?=
 =?utf-8?B?N1UwSGxlbzV4cVdZWWlnb2ZIR1daNDcrT1haa01BSzUrQ2FhTGRkOXFncGh4?=
 =?utf-8?B?YVVUeFN0MEJ2aWdyaUQ2NkNyUHdIdzJQM3ZBNWZjem51Mm96SlU2NW11dlZB?=
 =?utf-8?B?RHhmUmk5bFJ6MXZ4YXJvK2s4K2liYXJydjI3N1lvalBCamlma2NFSDNBdS9P?=
 =?utf-8?B?TnI1UkZoWGlKRTRDZnNZZ0o1Snd6T0Z5Rld0T2MrYU9pQTFSeG8zM1M0T2JY?=
 =?utf-8?B?aTNGQ1h4WDZ6RllDRnNSYzZJalUrTy94eUFxTXNWeG45eDloclZueDFHQ2RZ?=
 =?utf-8?B?aWtidlhXWTR6ZEhLUE5iOUtmTjRMclhpWVQ0WTU4MlE5MFVPU3ZFaUxLV005?=
 =?utf-8?B?V3NjTGlZVDVaL0pqMHgxcVZpamZvaHZ4QVpGcjlXTkRZOWhBVDBHMEFkT3V1?=
 =?utf-8?B?dHE5M01HcHRpSmJuK0VPeUcxME5hMjlQVmZJWEsvMGp1cGdhd2JtUTVlamNl?=
 =?utf-8?B?WHNSYysrRHhMdGdMbGxlOHEwcFRJNHVlVHlJejJia0tmVXFCOFdwK2s0UEIz?=
 =?utf-8?B?a3IyQXVVajNqNE9FWFZNUnJrWnNTbitPQjBPQ0h2Z3FETHBhRXc1ZkNxYUVF?=
 =?utf-8?B?bTdta0tCTDBkL1g4YWlMc1MyZEpyb3crUWMrN3dYSmRKeTJQZ1pvaE5aMDY3?=
 =?utf-8?B?SU9YQ0xYYVVhQjBZTWxocWFYc1JSNFBHZTlPUzRkM1JCbElGRFptZE9TMEZz?=
 =?utf-8?B?L2dUdHExMlRnS0ZIdU9tOWFVdWVDS09wSlN3c0ovNTZLalVqMC9qYXV3ckNR?=
 =?utf-8?B?M2tKWmVLU21GMGp0enlsQ3lTbzZkdTVWM01CZDhPaU9HcHJxemVROHhiVGln?=
 =?utf-8?B?dDJmWmxpWmhMbnAyVjBmaCthclZObzR0ZkJrUjFsMkVIbjgxOHUwNkN0VmJi?=
 =?utf-8?B?OVZ1YVdMR3AwdkNQVXVNQWlEc3RrMUNlRFFoelBteUV0eTg2Nnk2dy9ub2dW?=
 =?utf-8?B?K1NlUll4RzB2K3JmdWFrZk55MnB4VUhGYnJnVi9kM3JudTVOa09maUNXN25K?=
 =?utf-8?B?RUtlQ1NzOXV5R2d6Qk9LMldRQy9DRzBOb2tNT0QwSUJ2QStjNmtBRjR6cm5F?=
 =?utf-8?B?YytjYXdWcnN1bXBQQmF3cWM1VlMxbERoamR1QU9TRFhpZGltTkVQS1IwNnB0?=
 =?utf-8?B?OXZnd2h1QmsyUHVQQUFjQWRzNGZBVUxzNkl6czZMd0trYmNYVEhXcnlTZlFh?=
 =?utf-8?B?Vm5Fd2dCOVI0QVVJTFlIR3ltRzh2NktLMjJTTnNaR2xMS2NaK09qQTQ3N0Nx?=
 =?utf-8?B?b2ptT1pGK0dhQlJxclhQSktIUHRGV3R5cHppYjAzU0szeFllYm0zOW9udjlo?=
 =?utf-8?B?WmtKVVF0Z29BUXVKeWZxQjFuVkpIK2M1VXpCcjFPTGM0Z21KdXZqVnROV2tO?=
 =?utf-8?B?TUlObEpERTJEY1ZZdnJDMytSQnppcEkrdkVmOHBlZithUVFEd2x2c2o2RzBO?=
 =?utf-8?B?SG1MNzNweUJuMTA0bkRicnROOTZaU2RrbElzTjJhQU42VktSd01NbjcwNEhB?=
 =?utf-8?B?L05EM2x5T2lwTnBCZlhZQ1g4MVJVVW5ETWlsSlV4MktmYkQ4TmtlS1paUXJJ?=
 =?utf-8?B?UENGUVBYTDlhL29QV0dUNDRiUmFiQmc5V0U2MVczTTRSNFYyQzFPUEdwTDFm?=
 =?utf-8?B?Umxyck9VSGF6aTZjenZGMU1yVWYyUFZ2S1BtMnNjbERrRmF1N3pzU0hueCsw?=
 =?utf-8?B?YWFWeTRnME8zU1RBWnRhS1poeFNlK2wxSmpjTXJqYnFCQ0o0OFFUTytDSlVz?=
 =?utf-8?B?Zit3M2NBMTVNM3ZCaHJEUTJ3emVKUVRXVTRmU2pKZFJtbEZ4QXV6RWhGcWVn?=
 =?utf-8?B?QzdzczZvc2QzdFN6NldRVmNnSUpvRFdEUlpGUFhjOFdqT1RXd1cySGlFVzFP?=
 =?utf-8?B?QXpQUFV3VDFsaVJNQkJCenI3elNYQ05nRHQvMWN0QzNZYXp5VGQ1cGxFRWRs?=
 =?utf-8?B?dW9maVhaSlBOeW9Kb1Z3dE5YbmRvdEdabWU0TUx6eU5qM2crSlJ3UXVyVkJC?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d4af83b-c9cb-408b-c169-08da8ab7554e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4921.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 18:42:04.2427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erQ5UTCSFMwWYFK1dVKZtsCp1elqzEVj0MlFuOdu0l2y+MfoFYy3hCJcKVXV/xqBdMDUyZoKZeaJfpmVnPH70BxkMVzBwxjtOlQ2xujbvMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/2022 3:16 AM, Simon Horman wrote:
> From: Gao Xiao <gao.xiao@corigine.com>
> 
> When running `ethtool -p` with the old management firmware,
> the management firmware resource is not correctly released,
> which causes firmware related malfunction: all the access
> to management firmware hangs.
> 
> It releases the management firmware resource when set id
> mode operation is not supported.
> 
> Fixes: ccb9bc1dfa44 ("nfp: add 'ethtool --identify' support")
> Signed-off-by: Gao Xiao <gao.xiao@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Looks sane!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
