Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD536926F5
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbjBJTln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbjBJTll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:41:41 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B5BBB84
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676058072; x=1707594072;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kVfCbYUfvFkRkY6HghVfFLelC1egyPg5bYmsdwxyMHs=;
  b=V8gAb71SRs5FjnND57T/FjRFQpTkRjeNyhji4OYftWd/CX/ZRrQIDAEB
   lo9Bxg09SlXOR8twLKGBvFSSUQUBn23GOw22cO5vunTWGnbq/C6b8MhZr
   eiKP21M3TKd6pHr1zCU/EtJn2sRY4g6D2zjDwRuP0npXwQwRR+0b1gjM5
   NGrEY53e3qCIjjmqDh+UvferGLyL84XujfOrGr7HQVgkIe2g/3K87vquI
   qqih5lLEoxAolLgvb619wL+s51Gx3v7Isjmyorhr3XgPAnTKrIJTzC/wz
   FK4adXGrigTfRcVrz7WTETML0uxlNbgomSIn8h4d7a2qU0tLGrdb7DUXF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="318528035"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="318528035"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:37:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="792089648"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="792089648"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 10 Feb 2023 11:37:58 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:37:58 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 11:37:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 11:37:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/xaffw4YgHZiZk/S8sPFqjL2UUFOZLHSw4vhM1nllmRav/3ZSOp4FBFxp7ZgPi9d3ATxCKE61AUJd4N8hP2XONIk+mw+3368Dgqsejp2uMN4i51yPlOy4gjQtl3j0nIzbcExXz3Yh4A5dX7D6ea5Z1EjM28HvE8SU6z0MpZJi+boHuw8lyXKxU0p6w3oHqeJ/ArAkuSXn/EsjRbmAA3ySm2wftXghP0yLU0G7Y4vsDT4NDvCla7OWeV+zt+iQBBC23veBHUlleB9DNSGC8hYyxGY4icE5I2OVVrehUYYEzAnVKSmgGqv5M/HsNYgcZuj0zNmsu475e0TtlIy9koiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NmG03gMytDHyOUu32xpdIyrOrVi8YDqjdi7ABHQrdo=;
 b=Odx51rRJEeSOWfw+TuCoLajupUuarHjfm+SDJGWZ8CvK66WcQdzdhcfkSPNypaABUS48r9+Kw0vUir8wrwQt0HomZAK3u3cN5wvQf7/74CAXANOW4ms6iYqyFvaiITpfM5W7m2KuwgeZoOYqIIdtVtpL3JOmdW3gx7H6VVWT0TZYZLcw1kVUfPFy4vqV6l5TRYf98q3bP5yvSXmVR9aFLBn0xkd7TOI8rdsy0zdszPzQ6OxlnMH7Vjfo/aK+EyBFxVZf6fxXH1b4rFQ3iRp/Rlf6XBPSfCHSzLS9Z/S/AxuUpJK6FpPao90gMTF5jdOElF+GpMg+Q+UdNSWarxEJVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB6663.namprd11.prod.outlook.com (2603:10b6:806:257::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 19:37:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 19:37:52 +0000
Message-ID: <3e6ddb39-02dc-ec30-0085-0a9c70664c5e@intel.com>
Date:   Fri, 10 Feb 2023 11:37:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v2 5/7] devlink: convert param list to xarray
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <gal@nvidia.com>, <kim.phillips@amd.com>, <moshe@nvidia.com>,
        <simon.horman@corigine.com>, <idosch@nvidia.com>
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-6-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230210100131.3088240-6-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0083.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::24) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB6663:EE_
X-MS-Office365-Filtering-Correlation-Id: 26055565-934b-4832-d210-08db0b9e4cd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umDNA5EQdaSAj42BLpvSe/X5riQ3Ha7pLHWDxG6pREmy8u2OAxgv37q4mLn48wReWLqWInJlK4CA43wtuVA/hsq5MPq75RtOW0DAJP4QWLn6iIxAU89M69l7SzluYEU8SRdS22ONC3MrPs8X5TQaBausn5lKLWtn6LWHC+rMODqNDp8BtRV0ucBFDp01kjLZgZBqM/b4vggwF9m7o15L42yKJmCYxP7j00QVEhR2rYt68ae9O/vjDNX0T5s0r/JwPOa5aEDGMvPQ+BKgRzEKRyJd574mSW/n+gW4mLHpVbJ9asdSnwQ5WUE3qxMOTie7tHLoy3fgxPY9CgFgaKOURgiRsQQl/pqbERZmzyUVUpUrLCabJo7hU1ScdCpv6DXWs6PApeE+DrnTyMrpJqBsUZtfVnYin4W00+KXsJHM8Pg7ieefTBRAsnz7cem6oBwZmdkwbwua6ZIcgqMCpyMI8IlsqTm8nGMvE8FSsQblRPBqSOcfC+aOmgNiCM5aKxhHFZ8iIVbX37ZEd5E5aAheC+pTUMfK/nzIWB8LxTRDawFeyOeYKT5JIrnxA52xzE5QkJ8HwKGlUZ7Rh4+i6n3KSDYOS6ehHcLcPZeS+MuCixJdE3Kv3u/9pilJwOnQVjJ/XWgCcypUKFOis3Jp4/8MEcUusdOMYt8UKI17XORbhr69qVQac+UiL7PyhYvHoGwXpkI5pxXIycGoZPUsSpkm3pb/mRYVN/GxW8pMMlg94Jk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199018)(2906002)(4744005)(83380400001)(31696002)(2616005)(38100700002)(86362001)(316002)(8936002)(66946007)(4326008)(5660300002)(7416002)(82960400001)(36756003)(66556008)(6506007)(66476007)(41300700001)(53546011)(6486002)(186003)(6512007)(478600001)(8676002)(26005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2dEZTJqLzM4UGNuTFhqeVRLVHVCZ1ZLZmtDYnNPVUpsSlZQTmp3UWZqb1Nu?=
 =?utf-8?B?aFpNaFk3K1R0aGN5dzhCTitNVFk2d2Q5RktXMHpaUDFjc1pqT1ppakJWQ1dy?=
 =?utf-8?B?dEE4YWxWckpTdDVta0FBRHY2bmpvS2FhSTJSQmlNMUxyVWZZaGhVTysvQk9i?=
 =?utf-8?B?eUF5ZFMrYVZrdXFTK3U4UWtpbGVRSCt1VGxGVmVsMHhWT2c4Q21TdzJoOEZQ?=
 =?utf-8?B?a0QzZ1ZuclZkSmFnejQyTXROamlxaS9vdzRPMkRuNWo5M1ZuQ2NFYlBURi9L?=
 =?utf-8?B?T0dyOFpIREE3cVV5U0pXTkFsOUxZL2RITWFqbjBqbCt5Szc1RGpVTHJlMVJD?=
 =?utf-8?B?SXZqWWpHYzVDdzJYcmxWNTM1Q1llY0lWR0JZSVYxYW0xTmhXNnltSitVSHNG?=
 =?utf-8?B?NmQybTU1bU9QbmU3R0JpUC9vM01sWTk1Z0ZES2hmQnZGbURoVVhnb1A3MXZs?=
 =?utf-8?B?ZW5CWVBKaTA5cDhNVm5XVlFLcmZsdnBHeXF1TG1KVUlvOWcreEYzWWlBRXBv?=
 =?utf-8?B?ZDJEVnNqRnE2Yk5GOEpHamRNam42bXhITWpaVDMyOXE5UDJKTzlmN244Tksz?=
 =?utf-8?B?VHVBM04rbE1RNnJFc2d1cXE4S1RSRGp5R3ozOGRQQThWeUVwb0MrYjNaY0p3?=
 =?utf-8?B?UGV2SlBVNGg5SnJCOTVoczIyQmRMaHRBaHZ0VEt6RE80aGZHZFFCWTRBN1Z2?=
 =?utf-8?B?V3ZVbVdMNFp1WDQzT255VU1ndWhXUmltQW0yMGRaU2U3ZitTWENmbWVkOWtP?=
 =?utf-8?B?MDZDTXlzVzIralBkTWFkTWxMR091QUlGWnVyT1p6ZXo0Sy9HdW85OWJKdHVl?=
 =?utf-8?B?ODdGdmRRN2Zwd1NOL0lEdHpocklhbkg4UG5lR2lKUS9ydzFrZGpmbnNHR3pt?=
 =?utf-8?B?Z1hna0pOcUhXT1RqL2s0TXczZXk2b3M4c2hRY2Mzejg3Z29Ob1lGR0tFdG5K?=
 =?utf-8?B?RkE0Y3JLSmlZZ2wrNFZXdlhLNkxMNzFsc3ZDc0FJZ0QzSW1TT2Rwa1lvN3A3?=
 =?utf-8?B?cEtRaVNSYzFqNXlGWGFCVy90Njk3Kzh2YWdOSS91ZlhIcGpRbldJMWViYS9N?=
 =?utf-8?B?MVF3cGs0dndjcmdPN1hWWmVPRER1Y3ZSVmZZaGRnUTFyajhibjludWtWeWIy?=
 =?utf-8?B?SXJNcUNMdDNkdnlCWjl4MUUwVldDV0VUWkZWd2pPR2dqNDBHSnd6RTBDVXF2?=
 =?utf-8?B?bjZhQkZIcTNxaXpWeU92Qi9LK1Nsdm5BZm5Oa2tMbVRFMGtVMXBhcnJjSlFZ?=
 =?utf-8?B?Y1I2ZXJUUHpjL0lvWEZkVk1uWFZLN3hqMTNDSmlJTTlXeGZnWEtGWjZZanUy?=
 =?utf-8?B?OTVua3JhZm5kZS9adFRxeG5IdHc5VDVTS3lUaDdoQXp5QktOQWNXenFEaXQx?=
 =?utf-8?B?QU5Qa3NQU0l6QWFsemlDbWxLeWtkQVUwZVpheUEwSHFoajBPdmEybDR5M0Np?=
 =?utf-8?B?U0lCSGhUdmV6RmF2bmFVTGpZbjlmbVg2OTRGTnpCUEN1c09kUVk4dlUrSXVJ?=
 =?utf-8?B?bDBRUjJnSkVoT2p6UldhSUI3N3JnTVNrWnJ2eFUxRUwyZmFRUEVsRm5qbU1C?=
 =?utf-8?B?YTM1bHd6TnFRbGE3c0w2QUQxUkRCMWRaV2VWT09vRmVISCs5MmlrbGZ1SVNp?=
 =?utf-8?B?dmVOYktWQnlPanhxU0F0Y3lveWt4Z0pUelc0aDBJZUhoWkxTWXNaWEI3aVJS?=
 =?utf-8?B?TTRyYkdNemYvenFFYVdQbjdVVEhrSFVPcnl2VVZ3YnBZTzFCYVQyb2huVXdy?=
 =?utf-8?B?RU9teWhEZU9ra0h1M3B0WEdSNHc2TzMyUWM0L3ZIRW04U241Z0ZLNVhES0cx?=
 =?utf-8?B?YTd0OUVwWjhyZFRvM0RPS09XcGFFekJxMEZBUGMrNWdCYllpOGJ4YnA0YlF4?=
 =?utf-8?B?MXIrcm1XdEZSUjAweThVT2JYSFVld0dDb1NCM0FPTW5mQU9XNVpLZWp4U3lY?=
 =?utf-8?B?SE1NaXZwVHhNQWk2YXByalREY2oxbXhUUzZjd2pzSDFrTloxUWtyWUZoSnhW?=
 =?utf-8?B?Y2Z6algwd1FjbnF1MWJqNkxONU1lb0t4R04yQ2VwSStoSW03NjdJOGRmanlh?=
 =?utf-8?B?S2dzdGU5L3A4VnhxSm1ybmdBN2JxNmx3czJsaUdJbXBhYWJJRllwMmRWcTdF?=
 =?utf-8?B?ZWR4ckZ4QlpWNHJTZGJtbFVQMU9XN0pZS05YZmhuWE44TjlkTjVhaWJNc2Zh?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26055565-934b-4832-d210-08db0b9e4cd0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:37:52.7048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSHbqnl6s3iEVkFsQW6eG3bE9gNVuJJMVNsc8efZjY/yam+CXihkoT2LzX6Y/D2rzvdd4p9cUUdk+PQB++K/N1sFL7ypv7/JdctSR6yiM3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6663
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2023 2:01 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Loose the linked list for params and use xarray instead.
> 
> Note that this is required to be eventually possible to call
> devl_param_driverinit_value_get() without holding instance lock.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

That makes loading by the parameter id faster too since we don't have to
iterate the full list. Nice.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
