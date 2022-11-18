Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD1962FBF7
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242366AbiKRRsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiKRRsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:48:09 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ED85ADD0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 09:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668793688; x=1700329688;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nn6yQqWASUj1OWqLAXHc07GJ2ctXliRwBaW3MFeZw5I=;
  b=NL83ROUTVgnDiHoO/3AxWJyFx4oRYeCUG1T7jevkewp+9TDJ3Zz70etw
   yQ6wqM8LWIzERFbVFv0o5R1D5UPZIi6Vp9mYA3FluZNxI70gE3PN8TZDT
   mMhnULvD2IwUjUBAAcQZPO6kbeY5kIg0ghsFevVhj3Tm4GEIUjJsLuP8T
   39h5G2km0s98qRqEmleseGZBJP8xMW1nKRnm8JSU1GVy7QdbTAqR84I44
   f3ZHCYiW+S0GkkfcdyijmMMcaBGLJp2woibErMNxeehBNRxkchtxJMVGP
   529ju6Y/m2k7p4zMW09qqBsNTypv3T+eCr9/uCmNwPouUqEnDG2iqk+iW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="314343851"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="314343851"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 09:48:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="642591397"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="642591397"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 18 Nov 2022 09:48:06 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 09:48:03 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 09:48:02 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 09:48:02 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 09:48:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRF825hTWy2aTEL9LYLCv33RLgtft5jOCvrMjqGhtR8s8C2uUWjIepuc6Axq4zSEcyj8wcNfI2TnDoaG0x0m71Dso6ly8l9QTeAZJysXh8VxX5pUIk4jKk2ySuo7QeoGp154t63udgbwsAgTfvM0KuYA9+e9RNa2NEi49Q0Vl8YWIDDGhgmN4of9xrS2ZwZ+BfzHoR2mNevGdZIVh2aFRspuIed3Go2n7bIfHUB27oLza92Oy1n0P4bDGITurVoYjJVrzCSqvEyJJrPRAfzCurF8WJH1flFnDKUVzPds63cAcuUOzofQOYtpawaE/Y6qNIit7cIvDTYnExi47n0VcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jmU5QJ1M0VIskqopm9ZLjfg2zZfNgW5wrKQuhabvV4=;
 b=DYR0FTru9gilzU5nvqhSZY963V6b+V2fMJrhQAr+C6ORRru8czlILuiKn2G2dDu8LL5WFh0ypyAPhcltI/2Y65C+OHniOBoNHpIsJaq8xbQHdJgC2uO51BCyhLEPbi6Z97ZuuFbR9v25AOCJDfJYp73b9zUUzlem4APn7/ODiul3OQvOHc1uRdb6MZFZW8EdU5TAUijg5UxgdxudxBuHSVUD153w6TyF+RWgAj9c1fZ9+1cyck0wLx0C9lmR9v/NUreB/Miw/5+KmpbKra2vtFJkj94/ODxKAHstfRuCIGrIqGmnbRUsJ0e25Cjx7J1NNRmUGpuwvcVZ1/ogQ+JmNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by CO6PR11MB5665.namprd11.prod.outlook.com (2603:10b6:5:354::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 17:47:56 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9%8]) with mapi id 15.20.5834.009; Fri, 18 Nov 2022
 17:47:56 +0000
Message-ID: <164778f1-f2a6-1e82-8924-a4d7ba073e23@intel.com>
Date:   Fri, 18 Nov 2022 09:47:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 2/5] sfc: Use kmap_local_page() instead of
 kmap_atomic()
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        <netdev@vger.kernel.org>
CC:     Ira Weiny <ira.weiny@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <20221117222557.2196195-3-anirudh.venkataramanan@intel.com>
 <8192948.T7Z3S40VBb@suse>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <8192948.T7Z3S40VBb@suse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0041.namprd11.prod.outlook.com
 (2603:10b6:a03:80::18) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|CO6PR11MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: 43bf863c-43db-4bb1-07ae-08dac98d059f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kewFnXbije0HRga2Ti+Ny6TXQzRSMLxBf+yXuDygpqBR0wDxmdp21QeZfvtRF1Dpfp8slYt5gTuB2PlneiNGjDR9Tg8a2LHG5Yo91WUtH2+0bIKPe8SrO8W7bNUsSL+HXtApLdc8FN4bWt+7SZUjCcQNLWkcUozBQ0O8Am1UdGLa++k4wcUI/F09kFQE1AGXPz7tvl9QbzMJgkblyseaakdzfI5PsCEegsqlgB2wOJ6Q2PMRwB1N/lsL4Tnv8NG/6X/c/f6JXWR+ZCSwJ5JnGIzmdsnLppLfDAFTguHbEiGmdSWqYO6Ux7HPJ7cHhjVtxvUoZJgGrBhGRJFnsCyejgmUTN7SkRPksGzGVoe4CIkVnBrJgGst5ldXIHVvI+J1+f2g5YbzZRroJMZfq/bhj2/n2kG0dAlGgMVc0lpNiurrH3soIe9q9L/IqNImYZUlR1T2Rc5QwMzla6jxs5DgUWZ6LABc9jsizYdA0LLINed+Ks+T8MLkIs9/9lug5OE1KtRdywGYpjUGv2+/dL6MftqnoBvnZxUKc8wiAsxwi9tBndWnUqop//OF7sJEEbx6unes4sH4dD76M8Sf/BQnVpDc9WNpUG7hFetOA/mCKxl4AHoDAtNKShOaH4oFv3S8TX6HNR1zp/95F15x5BtWdlxyHosEkZHb5jym5qJF1uhpILR6u5yiFVVAlh6Jtw/9Z7Ky1kbns9yWP4BTgwrHwBuPNAfQD6otgElbskHeL3o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199015)(31686004)(83380400001)(2906002)(66946007)(66476007)(66556008)(41300700001)(2616005)(31696002)(86362001)(82960400001)(38100700002)(53546011)(6506007)(54906003)(186003)(8936002)(5660300002)(8676002)(44832011)(4326008)(4744005)(6486002)(26005)(316002)(6512007)(6666004)(36756003)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW1LbDVObGdiUEg0aHUzUjNUZ2dDU2lEUTRueEhua2U4M0xWaWpocXRKdXJO?=
 =?utf-8?B?cTFNbTU2Zmk0UDU0WkwxdTAyVkMyVkdwblk0Q05SVC9zNWdwRnFsNVZ6ME5m?=
 =?utf-8?B?cCs2dDFMNUc3MW1oYVZLcHlzSzdvbDRlSmV2UnRjWkxxeXQzUGFVdGE5ZnlV?=
 =?utf-8?B?RUhSdGpUOEo5b1BwMzhPR3dSSDVGY1hyYktySmppQ0tSb3ZsSnoxc29DZDda?=
 =?utf-8?B?SjBZTDJucFk4ZEpKUzNTWk93OU1mR1EwckROaG5XcjAySmhWUm8zdFVNZFJ2?=
 =?utf-8?B?SUFlYzJISEttV2tuR3hWN3VHTWVTYVhpQ2l0NStTMFFOcEJ4amZUaFhjM09H?=
 =?utf-8?B?ZE1BUVprUnE1YVNYdXR2bDZIMnZzMitmU2ticXIxeVN0U2NYUjJteEZ4Z25N?=
 =?utf-8?B?MEZ5VGpyclVBSUEwL0V6UlNXdjRSUEV4c291YVZqQzcreTV3Y282YWc5bWs1?=
 =?utf-8?B?WkxaME1JcFpNZmxxblBRRjhwcFZJZHVzRWZGTnNkWlZhb1Zpb0xwQ0MzR2p1?=
 =?utf-8?B?YWtTVXdkOXVjUDMvbDZsd3J6TWlKakoxMVhvRzg3LzJraXFUZ2N1YUpKNUVx?=
 =?utf-8?B?NEJLTmJrMjJEb1BobzBtdFkyR0h5YWxERXQ0SlRZUXZuKzFwTWZ1T09CTTRp?=
 =?utf-8?B?eGJ6N1p1V0o3aHgycXp6eHhUV0hTZUh5VThWcVhkY0Z6QVNsdWtpNDY3aVZu?=
 =?utf-8?B?US9RSGowNGRvVWF5Q2JCZU53V3VySnU0ZUtUN3B2VHE3T2xaazVVZjVHd282?=
 =?utf-8?B?R2MxRUlUR2pMWlNqcUc4VXNEYlhhVWtIOHFDR1Y5Q0d4cDlaVXpUU2VpV2hw?=
 =?utf-8?B?czNrbzkxUTFoSmllYWRUd2w1MVpDSU52dEs0bkxaOE1LcUZMVWU5VVM3cEJP?=
 =?utf-8?B?ZzhuOUlHTWxXaUVIdXByKzJiTnlBdkxXREVvemkra0hrbjlSWXJhQWtucW5C?=
 =?utf-8?B?QlZzRGNnUlRxcVVFZ1BSaWRaTVhscW93M2pDbk5mZG1ZRURiQkNxTE1YTEhU?=
 =?utf-8?B?MVEzSEtGWnFQbFJBb0dvZ3RKUGlmNzYzc2lSd0haQ2RMY2R0RzQ1amhEc1dh?=
 =?utf-8?B?REdWbStQYnhWSldYcFNyMkpXT1VzZjd6WWxnZkx4cWFMNmM3K0FHT3ZKMXln?=
 =?utf-8?B?ZmcrVFBKOWMvc3NycUFja3VLYkpWdTFFVVNtbmpURzgwaVNUQ2JYQXpCak5S?=
 =?utf-8?B?ZWwrNWxLdnIza3ZRVDRicHlvbmZQVk1Jc0lOUzV3Q3BITkhaWVk4R2NrODlQ?=
 =?utf-8?B?K3R0RTZJejFXYUt5Y2pubFByazdWelVxaHZmdWFLOFNtRkxmUUREbER1R3BS?=
 =?utf-8?B?cGhQQ1UyRngxanRlV01uUndaMkFJUXkyZFJnZm1ZT1A1L3JWOVB1RjEzTDBq?=
 =?utf-8?B?UUtjd2pRc05ySUJubGRkWlM5b0xJRm50V2lxaWlhMEx3ODJCcFhqZmNqN0NC?=
 =?utf-8?B?ZGRCT0wwTURYTEo2M2xXSTZtQmdDbnpsZDc5UjYwMXlTQUJlQVE5SWVqcHNv?=
 =?utf-8?B?OHRIWm9SVXJKZitrb201UE9URG9FM09Bb1BSN01DZEUvY1YwclZ6b2drQ054?=
 =?utf-8?B?SDNqSXpPbmFSYU1hcVpsaHhHd2NPQldaM3RkbmdEU3paS1k4QVBFSGVBQWFO?=
 =?utf-8?B?OVJXVDU4WjlpZk1ZN3BNTEV5WHMwZUlFZk9ZWmZGdDhVRHAzVjhWRDVKNWls?=
 =?utf-8?B?eU44ZXE2eTkyUS90L1IzVEpHRDFUOGgzZ0JNMVRIbUdFZU1HdnFHZ3E1aVZn?=
 =?utf-8?B?RVNMY2p6d3lSOGhrendrMit1TEVWcDFEZ1l1UGhFNzJwSmpOSEM3OGRNRTA0?=
 =?utf-8?B?N3l5UXpucXBpbm9tY3M2MnU5WHhxb2FveHJaZDJFcGdDV3pJQ1FNN011SzVr?=
 =?utf-8?B?UVZRcmFYVE1XUU5HcFovTVN6MFRua2Y5UHg5a0UySkFkeS9rR0N0RVFadWtL?=
 =?utf-8?B?N3EzOEx6WFRWN0tCWDBMTWVheUVvcFlCMHBWdmdFcWZyNGkzZ3E3L3l0TEJs?=
 =?utf-8?B?aXJYTEVRcVA3YVU3eFU0MjlwMWM3QU9IczR3UGxHdFhHQzdHOElGTGdiY2t5?=
 =?utf-8?B?K1dyZXBLblZiQ0MwaU5GSHdqejIxZFc3dzBIcU9iRWlmU3g3NmVsYTN5ckNI?=
 =?utf-8?B?TlFzVmFpQkh4a1hnTHVZdXZacnAycHdKSkRkSmNQRFpieUZEQ3FHendmSktP?=
 =?utf-8?Q?L0uf9nyrRpmnwxBA70A8RJs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bf863c-43db-4bb1-07ae-08dac98d059f
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 17:47:56.1998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0t2MBW3/N2iuBaD1NSLhyjDGrHtVUwdxxzFXLEqCJqh7+XqQvkaLst6p1TpCPBc6YHhTkLC2sXb9rKuhvHi8JDHRPKC6iafNSQXdWM/Kcn67J8q+SK4OP4dNXcNPSp/V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5665
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/2022 12:23 AM, Fabio M. De Francesco wrote:
> On giovedì 17 novembre 2022 23:25:54 CET Anirudh Venkataramanan wrote:
>> kmap_atomic() is being deprecated in favor of kmap_local_page().
>> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
>> and kunmap_local() respectively.
>>
>> Note that kmap_atomic() disables preemption and page-fault processing, but
>> kmap_local_page() doesn't. Converting the former to the latter is safe only
>> if there isn't an implicit dependency on preemption and page-fault handling
>> being disabled, which does appear to be the case here.
> 
> NIT: It is always possible to disable explicitly along with the conversion.

Fair enough. I suppose "convert" is broader than "replace". How about this:

"Replacing the former with the latter is safe only if there isn't an 
implicit dependency on preemption and page-fault handling being 
disabled, which does appear to be the case here."

Ani
