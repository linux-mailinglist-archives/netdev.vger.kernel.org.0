Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E779069AAE6
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBQL7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBQL7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:59:06 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97721644EF;
        Fri, 17 Feb 2023 03:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676635145; x=1708171145;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t9ckzCDJ5/oExbeWwK89jKAkMOZPaY/3+8K+0IaTEN0=;
  b=biorg1/0I5lOHkn6Kcx+yto/QjIxnah5dLPrfIl3mXIQzLEBJcb2YZqn
   dbEMHWkOxrXigMBkkLGA3VydN+M1xM3bjHRhklel/x09a6mMY1agUzKGZ
   BvE0OBFmnTMx1Wecl2/wVPI7mChnSn2kQuKZrMx0I9W//R2thPDD3rcCc
   76e3kDZ8rveM9BJYpHtQd54K6XgRJiTjrmKR6+kYoIoipk9HBZqLvtCZv
   0FcxnCMdcYs6rFPqUTFFHyU7lPdY7TcM8eulvCtJGVPRDxoh42tn4NTfZ
   LS0ifIC4sJ20hCEfCBWsbhc9uIMa4ssrkcEgGYAFvaC63Ibo4c6ZvfU4p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="315685462"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="315685462"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 03:59:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="620379649"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="620379649"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 17 Feb 2023 03:59:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 03:59:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 03:59:03 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 03:59:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiegReTIfW86wfN9QGZr994EsDsrOsXJtrxtOxGN75zljPSyr50q7daKS9plELkyV/CVS3G4wdaDCMmrjnWMbBUgA5tYFSOCj6gwCQaJ6bkrSR2tvb9qA9rRM8UOiklGP6K5hU6j/pJY/BCCuF+++02TjFte6hxwX/v+IdcV10pGMlIjsK/ns+4EYuSdlZEI70ShnjzvVKzpVGYB2kjkhp5wpoyFq1FddF8Rp8RFcYjNr+kf3i9DleCevTiwXJ64xWjzvoabbowdkrmmLjF+78YzyU/KcvaMtX+vnGjd3XkEsR8FhWpjHk18KfeOfyVHOLfaFDOm88z6ZUPFm9tUSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehXHU8JzR4DqZI0cK6eRrtq2ZZUokpexUrPdNzJ0pGc=;
 b=Mo4gozTWAX/0J+sAnmIFUgVj/nxwwF0DX3hUOifWdmjfGUJlC3b8odxoeHbLycP+24rD7x20LoDHkoLC5NS4yKj+A7dbyMoX9CNJfihvWKgj6KDxr1tq7Rd42u5OM7u9/okFMwf6dmYzNWk77NlydjEJhfrUMj/hXZnh+2t/UDWrVFL37Q2mGUXQNiE4jU90v+n3kIGWM0JkIL7B/GyAl5UEuPix/TFIwFfmUptcFRTGX7OapFb627DdGyDtznlxE+qPXGkLpP7Lt6GurLt7I7obHvj1Xo1bPJJDdHscyWBHuDtnawqUUYMCfQT942+Fq5rJwJgc2dWe45/gvdYDHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA0PR11MB7743.namprd11.prod.outlook.com (2603:10b6:208:401::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 11:59:01 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 11:59:01 +0000
Message-ID: <4c92160f-b2ea-c5ef-5647-6078ab47e518@intel.com>
Date:   Fri, 17 Feb 2023 12:57:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/6] net: ipa: kill gsi->virt_raw
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <caleb.connolly@linaro.org>,
        <mka@chromium.org>, <evgreen@chromium.org>, <andersson@kernel.org>,
        <quic_cpratapa@quicinc.com>, <quic_avuyyuru@quicinc.com>,
        <quic_jponduru@quicinc.com>, <quic_subashab@quicinc.com>,
        <elder@kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230215195352.755744-1-elder@linaro.org>
 <20230215195352.755744-3-elder@linaro.org>
 <b0b2ae77-3311-34c8-d1a2-c6f30eca3f1e@intel.com>
 <c76bbb06-b6b0-8dae-965f-95e8af3634b6@linaro.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <c76bbb06-b6b0-8dae-965f-95e8af3634b6@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA0PR11MB7743:EE_
X-MS-Office365-Filtering-Correlation-Id: 03174331-41cb-4d8a-b945-08db10de5bb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GL053+ZWY4go4eNWlrSXDI1kMO9y02O52Qp7U2Ra8ol6+PztHPvTs0+8FZ2aLEw41TJqiS1HIptbcqI3np8GpfmcRbU6PudG1Q9/u/CmB1WdW+ZwRguf17WUgbQso80d7orFmmCgyy5zWFaCc0StJk41mEq63tj+Wz5mkMzFxOE4WemcRW/07utMGVwr+wM91VzIWEwGKuD+YEKiyILnWfdtY0yC9nCLCb7+VeRl3qiSJuE9EsyXMx80rTWriv/6lSAZKaoVep53jpA1f76w/nS61FMaVjeLpHTi84BJUtHe6NathrOv41Gva8Y/CXg1GL/310VbeYQQlucmyCEzaurrDeNtCL76vrNCuZ4ZKDWgxZfzvp0T7ZJLzAlrd2J+61nIOLjXTUbzlG9OIGga6ZFP5CoHfDEPZ15yH1zXENd4zYNUKVpJqOHuYdzTJDU0zYjVfmV7SawyJRMtpH5jGqL2KAZvgUP4fBF3E1Zl2dar77U1boAlhLFiPpbQ95wGp/SLRYysZCC01ui58v7pFYCvn/vdZCVodupaPfzh/ch9uzt7YjNQsWc4zJLdtDK8bF2mvOuFbTnKtuHOEul9S1YcwizF3c16aoRUedueqcfsiGk8PSSyMzUz5jfVo08SnUtZDTCVlfq3r21wnMHAbW7Y14iq+1m9awasG8+GZWCeYhxLcAo0vSVBOgPAeLATPcm2VewzOghLwIhTUN95DZ6uMuVym5Dcy6WLG0R8ces=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199018)(31686004)(2906002)(83380400001)(86362001)(316002)(2616005)(31696002)(41300700001)(6512007)(26005)(5660300002)(186003)(7416002)(6506007)(53546011)(8936002)(36756003)(82960400001)(38100700002)(6666004)(66476007)(6916009)(478600001)(4326008)(66946007)(6486002)(8676002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWVJd0grS3VnaTdsWXJ0TjNybHNBRW56bkFyVjNaL0pSbmRFZHFseHo0Y3BY?=
 =?utf-8?B?OFBhSFliaGt5U1ZJeXZiNG1LVmJrdHJhcXk1WVBYY0NudkEyRVk4TTZDQ1ZT?=
 =?utf-8?B?eC8xWkNiR2hnTlJxZUxJTFdFdVhnSkNxN0JZQks0TDhJS29VRWNqck5lU0Y1?=
 =?utf-8?B?ZjdBVkJ6TTYwQkZVVVc5VFhmQTNZKzdwanRJYXB6Z3lWS0ZUZmplNTA2cm02?=
 =?utf-8?B?c3RkUGgyUUw4ZDQxM2R3MXBxTXo0eUxCWEkrWVpaKytOYy92ZjVYcWhUTENK?=
 =?utf-8?B?Z1g0dE5lNE5ZdHVlTVJTQnlsWXU5MllkcTBUN1VBRmhDMXNqTTJOTGNLNHg3?=
 =?utf-8?B?a01OWkczdFdhVlg2NnpvWk5WY25XRUx5OUNNRVFtM3NQeVBrYXRWUDFTN2ZH?=
 =?utf-8?B?VmViZHBTRmF2WHdramx0SDAzZ1hvTkwxU241YWhPWTJtNnhOOUZkZ3VJL01C?=
 =?utf-8?B?Y0lLeG1OL0IwQU91U1JjZmRoWWhzREJ0b1hkTjRuNm9hdFFnL1ZuZEhjNUV6?=
 =?utf-8?B?THlrWUNKMGRWK25RSXB3L2IvdytRN1JHcDFaU28vemFPRXM4cFhlQ3hGOU9R?=
 =?utf-8?B?ZVN0ZkNSTGZJaUhyZHllM2FkRGNXWk9NVXp1NGtXc2hsTDFuV2Z5aVJ0VkQx?=
 =?utf-8?B?QWNrOWlpQ1JWeThLdG9rU2JkdE1ybE1tVHJZUjlKc25FS0ZlWEdQVDVUaG1Q?=
 =?utf-8?B?NDNRY0tNZFBDcXBYanpaTEdVZ2lOTzlWem40OG1sd1NEZEhFUnZ2Sm9ydEN1?=
 =?utf-8?B?cCtlUGtXeThmTTFOcDdHaktCbmpZYlRvZytMWVZnT1M3eVFlemVuRDZ2SS85?=
 =?utf-8?B?OHVFQWxQVHhsN0g5Nk1FeTJ2THZrQnpKWEFMbDErM0ZpdGdwQTFCTlJIS1dj?=
 =?utf-8?B?UGVYdU1MTlhhRHIwT3ltNEpSd1JZNUpuUm5kL0ZLR0JFZ1F3Tmk4ZlAwckc4?=
 =?utf-8?B?NThPZTQxQTVlbGxDc2hPMjhQcDJvV1ZFL2UvK1FnbEdiSFN0eXZCSStjL3RD?=
 =?utf-8?B?ZWxrYzJCQ2xLR0xuQWd1aEVCV0FYdy9xRTRyTTBFKzRoSW1YU3dDVk05TTZK?=
 =?utf-8?B?dnZZMUFHbnFPVTIycy91RHpQM2Vqd3FDMU9RN28xelRvVXVYNmpVV2FNenRq?=
 =?utf-8?B?M0Y2SWt2TDdvWWNadnBSZmtoMXZnVkpad1dkMGg0UEgzdGN1Yk05Z1k5SllO?=
 =?utf-8?B?MWdxcDFCenpZUGtjaUJkUTRGTGZnY2FwQ3JRQWo5K0ZMdG9yaFpEQnErb1Ey?=
 =?utf-8?B?cXpSblgwRnB0T2lWYU94SFhqdW1BQlJwcno1VlBCYktyM05vRXAvSWExVVZD?=
 =?utf-8?B?NWd1ZjV0WkJNVFl1ajFORm9lZ3IrZzFpQWxvdUZIVm5FSGNhQmF2RFdHbGUz?=
 =?utf-8?B?VXFtL21CUE5IeWtZaDRoM25FMktadUFUcEIzd1hhWGhCZUZoMzREd2tBbktC?=
 =?utf-8?B?OE8wc0JPYUk4WkpIRFhkOFF3dkdWcTN2UHlqUXFBQVp4UURzdnVhRmdabEo4?=
 =?utf-8?B?TVorRVB4S2ZlNzFMWEFkRFp5aTg3N3ZIVmgvc21panlqQk81NEdSMTcxZXpC?=
 =?utf-8?B?eTFvWGszVnh2NTZGLzRSQ2pPTWZSNWlyNXUxRy8yRDlycGxaZFZBR1pWenBN?=
 =?utf-8?B?VHhRUDgyYnRqSEtRclN1RDNEUU1XQkRjaXlJNGxuZlNxd041QU0vTy8rY0o1?=
 =?utf-8?B?d1ltb2JzMVdwZjJTZGpHS2ovaUpoY1Bmalo5SlNzOGxLcGtJZDBpNHRkYTJU?=
 =?utf-8?B?bmZaNUxiUmI2UzY4Q0ljV2RlWFVBTzJsL2xzSXBMTEVpS0RPNjdPcGtlRE5P?=
 =?utf-8?B?amU1SWhFc0NCODBWRzBaUWpHdTZ2cUM2OHJrRU8zZzFiVVcvbmpJakFkSTBL?=
 =?utf-8?B?SHNZK0crNFkrOW9PZm5iQzJ2L1NCVm9wbjM3NjNpcDFLQi80ei9Ia0t6MTVB?=
 =?utf-8?B?ZDQ4SVJiNlBTVWxDSTNoY2pXck40ZEkvbW1ibm13YWVoN214SExOSjFHc0tB?=
 =?utf-8?B?aXhiMUtTZThHOXhBSGRGMXNYM0E1OGFXK1VmdUN2a2IzMmo4Q3JjWVRLTmRP?=
 =?utf-8?B?MG8xNnZtMmYrNUdkTHJXQ3hMWlN3WmFEcDk5Y29wNXpaUlJybWFjcVhBWVFv?=
 =?utf-8?B?d2pGNWFtN3RCdWozTXN4aHpMaDFZOGRvMENydlZGZFNEYkRFSHQ0cnlCbW5o?=
 =?utf-8?Q?z9SuKU8l6z/WjNJ8q91unl0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 03174331-41cb-4d8a-b945-08db10de5bb5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 11:59:01.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JjfUORLuBPd6Ryvgz8V3wNp32nPQszueb1cq5LEgHRzUW/KikfCyJ7jC+xEI31NUrNB1DaLRgRae8/Y3cuLwdJT8B89X17bvjtgS6SPBw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7743
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Thu, 16 Feb 2023 12:11:11 -0600

> On 2/16/23 11:51 AM, Alexander Lobakin wrote:
>> From: Alex Elder <elder@linaro.org>
>> Date: Wed, 15 Feb 2023 13:53:48 -0600

[...]

>>>       gsi->regs = gsi_regs(gsi);
>>>       if (!gsi->regs) {
>>>           dev_err(dev, "unsupported IPA version %u (?)\n",
>>> gsi->version);
>>>           return -EINVAL;
>>>       }
>>>   -    gsi->virt_raw = ioremap(res->start, size);
>>> -    if (!gsi->virt_raw) {
>>> +    gsi->virt = ioremap(res->start, size);
>>
>> Now that at least one check above went away and the second one might be
>> or be not correct (I thought ioremap core takes care of this), can't
>> just devm_platform_ioremap_resource_byname() be used here for simplicity?
> 
> Previously, virt_raw would be the "real" re-mapped pointer, and then
> virt would be adjusted downward from that.  It was a weird thing to
> do, because the result pointed to a non-mapped address.  But all uses
> of the virt pointer added an offset that was enough to put the result
> into the mapped range.
> 
> The new code updates all offsets to account for what the adjustment
> previously did.  The test that got removed isn't necessary any more.

Yeah I got it, just asked that maybe you can now use
platform_ioremap_resource_byname() instead of
platform_get_resource_byname() + ioremap() :)

> 
>>
>>> +    if (!gsi->virt) {
>>>           dev_err(dev, "unable to remap \"gsi\" memory\n");
>>>           return -ENOMEM;
>>>       }
>>> -    /* Most registers are accessed using an adjusted register range */
>>> -    gsi->virt = gsi->virt_raw - adjust;
>>>         return 0;
>>>   }
>>> @@ -170,7 +145,7 @@ int gsi_reg_init(struct gsi *gsi, struct
>>> platform_device *pdev)
>>>   /* Inverse of gsi_reg_init() */
>>>   void gsi_reg_exit(struct gsi *gsi)
>>>   {
>>> +    iounmap(gsi->virt);
>>
>> (don't forget to remove this unmap if you decide to switch to devm_)
> 
> As far as devm_*() calls, I don't use those anywhere in the driver
> currently.  If I were going to use them in one place I'd want do
> it consistently, everywhere.  I don't want to do that.

+

> 
>>>       gsi->virt = NULL;
>>> -    iounmap(gsi->virt_raw);
>>> -    gsi->virt_raw = NULL;
>>> +    gsi->regs = NULL;

[...]

>> (offtopic)
>>
>> I hope all those gsi_reg-v*.c are autogenerated? They look pretty scary
>> to be written and edited manually each time :D
> 
> I know they look scary, but no, they're manually generated and
> it's a real pain to review them.  I try to be consistent enough
> that a "diff" is revealing and helpful.  For the GSI registers,
> most of them don't change (until IPA v5.0).  I intend to modify
> this a bit further so that registers that are the same as the
> previous version don't have to be re-stated (so each new version
> only has to highlight the differences).

No, it's +/- okay to review, as you say, they're pretty consistent in
terms of code.

> 
> All that said, once created, they don't change.
> 
> Thanks.
> 
>                     -Alex
Thanks,
Olek
