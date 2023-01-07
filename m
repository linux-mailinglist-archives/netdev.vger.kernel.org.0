Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F5E66113D
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 20:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjAGTQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 14:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjAGTQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 14:16:27 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018AB33D61;
        Sat,  7 Jan 2023 11:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673118987; x=1704654987;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZelTlSh8MwZV14bIuSMOOIKinM4gISpjva0lwBUHfwI=;
  b=KgNrFQQK6rrAI7plVF+KsVruOiXxpiNEQ0X4GjSqLLnSU3flPZRKKoAI
   Ro/upATCdZRxfNENJKExvIjAlJ5TTl1KMQn+Fw7ivIpHxZABPUdcMkx1K
   M0gX7cxHMczV9WhUh9odW9vb+dQxF6WxU/tPu+FEd91dWtPhRXp1gnrci
   SSpiuuhNpDclmSSbFdoiDjekVwUM4l6af/gmHOZiMFPnbPauy0+4SBhSG
   l4Y8HDFoRzRIl3cANYTUjEVmXMdqHmKA8X6crhqkMXsIzBnyhFb8Wpw3f
   MauP0ym4TrvZZ2Od7jAgIdz5PRRD6RftvAQ91+G82MvpOx+4K0RhiclCV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10583"; a="302360991"
X-IronPort-AV: E=Sophos;i="5.96,308,1665471600"; 
   d="scan'208";a="302360991"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2023 11:16:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10583"; a="658194551"
X-IronPort-AV: E=Sophos;i="5.96,308,1665471600"; 
   d="scan'208";a="658194551"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jan 2023 11:16:26 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 7 Jan 2023 11:16:26 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 7 Jan 2023 11:16:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 7 Jan 2023 11:16:25 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 7 Jan 2023 11:16:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9ESu3H+N/XZAhm0u8n/Sy1eeqDQtFUlR8VaU7dvZ/1sQTmC5ZqXcFcG1emPndDRuq5H2nxdQ3Jk41PzzDqqH/+Fs2ts2JlEyZUHC4vmWTtlVRyGsIH77/JttobWG0iouZneXlPVO5g6opIoVUyv7O4F/Kd6yQVI/FjkTCxRrsvRVXQeJuMZV/hx5ZWyn+u5hLIguFpL01EW2j2acYjCqg5OdU77W/O/oHdynv+swbU9NYQbNOdkzXz45hEENf11sb+plE4AYoKVLRmnmFmkD2jluMs9fSWoUNF3PpztWbAIT3ElblzBOJMqE1BAj+S2LA8g0BdUpGj8PEal8cTkCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCAqNmjjA0192SVeCf6B+d30So9/AQM6JGRblrfEA5o=;
 b=KXrrTaEab2fCVw68oJPFKv5iLTBPccZlrWlUW6BhWCWU4safWzVybq+xSK4jC3XpHGJM7Jnb+2xLcXT64tBTxI1jjk9x6xtU1bxB508MAAiefYMSHQUGOUIbKhNvcKriPxEmgJLwr2Z/H2f4HDbwAiSKsJnz0eqU22m2tM0KLiy14A7eM5/0omEJQKUmEpDvfWX8UVY+wCJMcIPKtuM0gTh4lJO+QKqahdeYj1Gq68MDl8+UUf+1br73YkYYo04vn4Y2mGeahZMoC0dJgRunvAZZv341bhi0SenyX2ryvo96nyt91NSJqpSwvVb8vUkmHQydSTsh9gF5IS3CtkvjNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by IA0PR11MB7258.namprd11.prod.outlook.com (2603:10b6:208:43d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Sat, 7 Jan
 2023 19:16:23 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::c1e:cae6:7636:43b8]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::c1e:cae6:7636:43b8%2]) with mapi id 15.20.5986.018; Sat, 7 Jan 2023
 19:16:23 +0000
Message-ID: <b9284d54-3153-e074-8a07-0812b26fd290@intel.com>
Date:   Sat, 7 Jan 2023 11:16:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/7] ethernet: Remove the Sun Cassini driver
To:     Anatoly Pugachev <matorola@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-mips@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <sparclinux@vger.kernel.org>,
        "Leon Romanovsky" <leon@kernel.org>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
 <20230106220020.1820147-2-anirudh.venkataramanan@intel.com>
 <CADxRZqw2K1QT2cEa6U_4DUxgYrwMiZzU4Qy6iXVm2WRTYVa=xw@mail.gmail.com>
Content-Language: en-US
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <CADxRZqw2K1QT2cEa6U_4DUxgYrwMiZzU4Qy6iXVm2WRTYVa=xw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:a03:180::33) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|IA0PR11MB7258:EE_
X-MS-Office365-Filtering-Correlation-Id: 19ba3264-0946-4f7d-9189-08daf0e3aa29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9f0R/yHgrzZlTTJsrBfwXvk9iQmXPBZilriXMiRkssZVQ4UKutH+FOo9q0586//NeK/ZljIBEwxozL4SJ3XBFzeTGR8gaVfZr4LG/B3rB8O0QfXALlw1wQ+9qbrQslTTpCWBgRv9dZExnmQeri/zEfMplRwwfXHkD5nYPdmvN6fcC/ptTmOX+Mmn+MKH4kkSALZZnsqdNV6ULdYsBH8h7rmam+pk3kmLyW83kufnNTPqQOUswK5xvRnaVKVmzIlZUpAyUaYvd9AlHIG1lTXES9Hf7o35bCeIiGXRn5s92EcYmnBjk1BQT8aeK7kedgZsYZy3h+V6DrbuKaM1FU3rExVg2a/ZlZgE99zxyyxYjohJ3VLDVrLHUMFoEBJ5klSiObTYaFdg3vp/fuVrkxelj+c2LfgEf3wJbwdClQxQd3RF1tThjp1RiPzBWZLht093dgjF7YMfNog3Q2jfz1zdtSBmXkLiwUGgfJ4hNdovPCQ/VmSzheZbT9ulPa7vs/JH3DUoUlCuPiD7dQXfZXAw4EPI3kx5DDUHPtR0iKhxeQsxPFfFaLCWBDjvmiyuHQ7KWbwNPXB+6Qu4iPJvCaFRjr572oSA3YmB98UEJ85OYyxfrK51nTT+ewAw8opQAwZPGfnf0bDtAow7eLJdZJKLR6wj6MUVSCfOx+L0cm17DiXc1zBEdulB3Bjlr/+m3z/cy2x+cg9hY6rjV19yfEUHD+lh/qWcwL8SU+eYNLMUkNW1W9tYl/lmAbc/xL57UDTWesBYR12FfFS4/xyAFzPhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(26005)(478600001)(186003)(41300700001)(966005)(6486002)(6512007)(31696002)(6916009)(5660300002)(2906002)(66556008)(86362001)(2616005)(66946007)(8676002)(66476007)(316002)(44832011)(36756003)(83380400001)(38100700002)(31686004)(4326008)(6506007)(53546011)(82960400001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3dxU3d4MUZ0bkdrUXZMa0ZnZUpjR1pTdnpYNG9peUNMejNXSFdLL1hpYXdV?=
 =?utf-8?B?WUkrY0U1Q041SUJ1RWxieGFJZmo0eEhIMHkzeEZJYmhrN1lhVG0xQzgxT2Nl?=
 =?utf-8?B?SStlNVhUUVphRElaR2RYOE9vRFBlTkN1d2JzS0Yxbm15dGtxU2VDYVhKNU01?=
 =?utf-8?B?K3NrekQ2VFVaTnVrYlpIaHZTRU1GMW4rUUFrZnpFb0I2THM1RDM5alFwWE5r?=
 =?utf-8?B?L1VuRUl1Y20zRDVyUzlWNm5DTDZSZkRTanNialZMYThldHFWYm5ZTmZLaTA3?=
 =?utf-8?B?YmNaTTYvL1kreWg1Z21PNm8zMEQzWnJzSkpRQVhoa1oyV21ac3pRMjdmUUto?=
 =?utf-8?B?Q2t3N2FzZDJ4eXl2NmNHdysxU05OWCtDUzdjb3BNWXNJQjhNdXg5R0VoRFRL?=
 =?utf-8?B?MVBvVE14T3I2Ynd5amRubndtd1NHZmtac1EzOTVNNktaSUJMY3I0aDNiTmVX?=
 =?utf-8?B?U0dnWFN4TU9maUt1S3gxQUxRcHJsTDFZRXlQWDFQYTU2Wnh3SXRRY0ZTa1Fs?=
 =?utf-8?B?NEhVNGJhakNGS1Q3WmZHRC96d2JZMFBicXZTSDBrVkVIN2dRdVRGMTRzSzNT?=
 =?utf-8?B?ZVhKbVJzUXcxdnVSemFPbW1tSk9icHhuNDFnbmJLd2QrVXVLZW01bTJKay9C?=
 =?utf-8?B?QlBQU0FrZlB6NEJNL3VUbXBhQTdOMC9GL3FJelBuSUUrUEJic0cvc09CSnJB?=
 =?utf-8?B?cG5wSTdKT0llN1VuMnZGNlp5eEorMnUzUjY5SlJocXl5TmN0RVRWZ21MVG56?=
 =?utf-8?B?UzhmM3BkSGc4dTR6NU5NeVR4Y2p4VWlEZlBTMXM4SzlqRnQrOUtYVkNTY2N4?=
 =?utf-8?B?amVETldjbVIwS0M5eW9sMzREQ3dXZ2VYMVVxRVFldDlxUGJGTy9sRi9RS0Ja?=
 =?utf-8?B?cVkwZ0tEQXRNNUJCNExFV3RKRDJidjYyR1plYkNqNVQ2UkNVOEhod3ovUHJq?=
 =?utf-8?B?am1vemRJL1pERnlvdzQ5N1hScXJKREFOTXBzRGJNWVBzY0pDc1ZhaHVIdHUr?=
 =?utf-8?B?dURNdHY2UWpwa3FaTG4yRDF6aWxueWg4WU84elhxMzUrUFQrbGVpT1VsN0xv?=
 =?utf-8?B?SWpSZytzYUxEU3VzNkY3c3JGY2xvaCs4Wk44MWNDM0xKYXJ3ODBHM2YyNHoy?=
 =?utf-8?B?dFFEeGM5VnNpYmdZdmVYdnI2UWJRNmhnUzJTbG9yVWZ6NldnMVlIUjNsOHFW?=
 =?utf-8?B?TlFtMUM1b05wMXFpSXhJUEJIek1NbnY3RTFpcjRwb0NZTlRUdWVBeFF4YS90?=
 =?utf-8?B?M2JwVmo2K21rTGNnNlRpbUQ5S0xBc2JtYkE3UTFLa0NVRExFV00xV2h6cFBM?=
 =?utf-8?B?SVFVaDRDM2hBKzhadFR0bGV4UElnZ0VhcUpEamt1SzNOWmtkdE5lNkdCNi9q?=
 =?utf-8?B?NVBKWWRLUCs2UzR0a1FLR3M0My83MHZkTVNDMXFtZmg0UnFyaGI4UmZNVndk?=
 =?utf-8?B?Y21zZ05tZkxhZXgraHBsM01RYS9hU1VLTnZOYlh2YS9UY000bjZuZjRWUnNv?=
 =?utf-8?B?Zkwzd1hPZ1Bsd29NUWxZQWJPcTFEWDcrU3NnVGV3ekgzTW5XNzBWMC9qZmZl?=
 =?utf-8?B?bUI3U09BZUIwcWpJWk5KOXpmS1dKWVp1RlVDWVFTQ3NKNDhwL0hTTyt5WlBy?=
 =?utf-8?B?ZEJlOFFoMlF5NytqbGNCM1RFRjNLSHF3WGtKMEJGS1BSM2R3R1doNjVmZzFi?=
 =?utf-8?B?MFJxRzdsTFl4MVNUWjhHcUJUbnpQVG52eU4wdUpYK1lVbEZ0b09iTmNXOWZ6?=
 =?utf-8?B?SlpiTnhjZmNFamYxYmNFanliblVzUE02Vm1Pd2tnNWs1M2E0VkhOcDBJNTlV?=
 =?utf-8?B?VkVjK0R2ZldVSkMweDlkUDdwRUo0cGhsamZmM3hlWHVKYXorVDJQUkNJV1o3?=
 =?utf-8?B?TE5KL0RiN1dyU0hHWDdGQndQTzl5YkkweVV1cENLMWcyMUI4TDkrUklMa1Zv?=
 =?utf-8?B?UCtIVUpBUDFVL3oyZVp2WUtZZElkREgxS2ZnajFpdlJZaGtpdUFKWi8vby9C?=
 =?utf-8?B?ZzZDQmxwT2ZOdjhTazVWU2pwK3BWTXRRNnB6RGxLaDNpOHE5UUY2bGZtSDlD?=
 =?utf-8?B?dS9rbVRFdGdiclJIaWV0UmFDM1Ricktza3NvU0NTTXRDUlRWdHlNUHE4Wk5z?=
 =?utf-8?B?WHl3cFR5ZXRGQWNGS1cvWjNwb0tmREtJOERSd1lNY2NyMmE4Y0JXNWdva2I4?=
 =?utf-8?Q?vJrr9dKzhviQaL/NHMUJCKo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ba3264-0946-4f7d-9189-08daf0e3aa29
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2023 19:16:23.1012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NILFcK85o3hsMunurRybLbiTvSCuuRKwQmiZIKx249gqwTPyNW6UMWHjFhm/C2kTR4q6BiDrSg9dhWv7HHsYUO38nPrbimABTmx5mcqIYSICIXYjbc7FCXZnkWtZn+J5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7258
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/2023 4:25 AM, Anatoly Pugachev wrote:
> On Sat, Jan 7, 2023 at 1:00 AM Anirudh Venkataramanan
> <anirudh.venkataramanan@intel.com> wrote:
>>
>> In a recent patch series that touched this driver [1], it was suggested
>> that this driver should be removed completely. git logs suggest that
>> there hasn't been any significant feature addition, improvement or fixes to
>> user-visible bugs in a while. A web search didn't indicate any recent
>> discussions or any evidence that there are users out there who care about
>> this driver. Thus, remove this driver.
>>
>> Notes:
>>
>> checkpatch complains "WARNING: added, moved or deleted file(s), does
>> MAINTAINERS need updating?". The files being removed don't have their
>> own entries in the MAINTAINERS file, so there's nothing to remove.
>>
>> checkpatch also complains about the long lore link below.
>>
>> [1] https://lore.kernel.org/netdev/99629223-ac1b-0f82-50b8-ea307b3b0197@intel.com/T/#t
>>
>> Suggested-by: Leon Romanovsky <leon@kernel.org>
>> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> 
> Do we drop/delete a working functionality by only taking in account
> git activity ?

No, but in some cases it's enough to at least start asking the "who uses 
this code? should we continue maintaining it?" type questions.

In the cover letter I did say this:

"The idea behind putting out this series is to either establish that 
these drivers are used and should be maintained, or remove them."

We have established that these drivers are indeed used, and thus 
shouldn't be removed.

> 
> What is a proper way to decline patch series (vs Acked-by) ?

There's no tag that I am aware of. I have seen people say "NACK" or 
"please don't do this" followed by an explanation of why the 
patch/series is a bad idea. For example, see the other responses to this 
series.

Ani
