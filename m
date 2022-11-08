Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F5D6219A7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 17:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiKHQlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 11:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbiKHQlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 11:41:02 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF44528B9;
        Tue,  8 Nov 2022 08:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667925661; x=1699461661;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DqX+IB53Gc5DmuxOjXYS9pS/ijKLpSAz51zrX+0wSQg=;
  b=ChHb0x8eCsZj+kasvEO9H5s1lrpGiNqPBlmoUeuV46pp2RGoSmns2F4A
   oOlAAvkxxqXB3JAthkad4/Z340eF6Vx/8ORJTgBCoSos7/0JQrJRUwSXW
   goLx9O5we2RVZxkC8PMhtL9lgfvLAJUq5Dr8Qlx6O8gNSxOxCMncKEmTe
   CGgL4Sy0efQFB0x1PWJP7BUl/wtY0MLwnXL93GJxY40S4Dup6YreMOR3z
   GBZo+x9zM+ffZowy8aZ12h5BvekSnIuYSwkVfu4iQdFAIukvOIbai0u9c
   fOMRwuzpXZiqNgYxct8EZ39SkEYq5Z0ieIuCvC3v4ujuBCYjNHfdziWcw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="337474443"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="337474443"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 08:40:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="667651952"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="667651952"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 08 Nov 2022 08:40:52 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 08:40:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 08:40:51 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 08:40:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xcvy76SujcxCSHpr/jYC8YP5cIDZ8BhLG+Tj3eV4/5EXEjpUxY9JT+0Ie4Li7rjxi3OSIdgqzB1gyZnHcyykpxSYUSxOLkWmpAUu2fBxnUd1GPQte9nzYWdqwL0bHiaZGoWCQvtpVmH5h3RCpPy+UAS6KbtXoqi7KCbTSqnslp363bnaN4OH2TCEyFfyCoLranVA6oaRNcesgmRVvXsT2ELt5g/OYdp8LlZ5XdatkOj2BOrBWnqGNb/PGxo5Y2Xncxr5jHpY2F9gNu1+aH5QjEKzcPtK5dAsVs4XVNhQ9c7+oHAqWEbgxv8HmU9s18si9hfGOvdvQ9ciq4kaywtBMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZ02cxx6UOb5/8zkvVXUWqCvaK03/pH3FOgptEM036E=;
 b=iVYQNW2T+pHLM35x+rkiuV/L4GQih090hawJ3PIDYuiZQ38NSwTElwiADcd9phJsm6Wy1wynGrQ+u29aA51JojU2q+wXCopVzIWolJcgvQndPMyJMxnMh0W1KrN+ytB0m2j1X6oSkGF3wI0cc58SHGnRMaEu8weKmHeW/bcTGzL7l/SvhtpWoqJm/wXAyD+4GhTHHA1fgtOc/NpUOpfnXzMofXpqtiCxQo4cHuM783MOasjbosjVGlaW0HH9fpr+BFelAGC4gTXBmH8+XsWqY3QRYsbkoHHbjNZMeQ5iLKH6HwNic3hGUx/MD2CVayPuF+4q5/LhSS+AyfxcYWpLuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB6442.namprd11.prod.outlook.com (2603:10b6:208:3a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 16:40:47 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 16:40:47 +0000
Message-ID: <7bec731c-f650-3c03-05d3-d1d430751179@intel.com>
Date:   Tue, 8 Nov 2022 08:40:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net] iavf: Do not restart Tx queues after reset task
 failure
Content-Language: en-US
To:     Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     <sassmann@redhat.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20221108102502.2147389-1-ivecera@redhat.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221108102502.2147389-1-ivecera@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::15) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB6442:EE_
X-MS-Office365-Filtering-Correlation-Id: 535a79e9-8ead-4229-5a01-08dac1a7fd0f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /IdsIEjO0flFHRCRir7Mh13gR5EbeBJGuZACme0Up2xnaffqmGuN3TGNOMKw1o9NPFChcegHGfG9ABH98wBcczcj4rr+CoJcpxR9naQH9dJDE9LHsDEv4JwGrKXTgU+MLEW4JtWiuWaRDHsBOM3NZlWDSegerquePZi37VMfwuEDPcMz/sLfw7ukzTM16MxKPvWKzJD3XRSq44cIToKbeOU8MmLC/wsiGPFUUGvlh2W4gN/KLu9u1iG+ZY4pnEB3d7ma6ha51Xq/04dh2FK19yCNmKDZR5GbYChQM6WZQcDZk8h4qf7SSKXU5bFFJdKVamrNE0tBvtDq0Ymrz2fnl5j4eQILYZq5i+57ifHDhSbvPx0cm3KabgrPmHxA8UnBMy3i6/2w9GkK3pCJskVW6L7qgry+CfhykUSqoBK41+2/dWr6mCBCKAf64/CPUVa+5UzrQo9nGN58Ncru18Q1Y33+jY2Z9+DDBaiW2tcOnaS7qFg80MGUoF+xInsSUGy7PAZ3rY8i1RWz8lPYdXxY0/Be12eQ56NPLlFcLbDcctgMkyDhA58FLfqjWcoaMKZIZww0VNa1B1PAkHTIbCXiMlweTzdtX+bxRc8ZBQjWZkK/2yaS6vJM2p3vh9DL2q4fSkY/mRT1f/sq5hRAWOntUSM7LhpymUCGyF490I8MKLTQHGGecS4PVZLwOvRcgUBGvG68/oL2AO7z7mCVEtTdw2BtPqVW9dkwMLpvjl96KA3FQBF7NuNrloifLJFVQgNwC5X0E34Ewj09l61Rt5qaxdGe8BPouaQui4Hhrqd+p8k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199015)(316002)(4326008)(6486002)(66476007)(66946007)(66556008)(36756003)(8676002)(478600001)(2906002)(53546011)(8936002)(38100700002)(41300700001)(2616005)(26005)(6506007)(6512007)(6666004)(31686004)(86362001)(83380400001)(54906003)(4744005)(82960400001)(31696002)(5660300002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnpXaWFtYlY2VFVmMUFOY1JUcGdpZ0liNjBBSVBUdlNaaGRZWXRYQS95bVRh?=
 =?utf-8?B?dXZOOWRyTDJPbU5ObzRlV2g2Q1pPbU9VZmFvZnlOaUg0Rm8ySzNHc2g0aHZ2?=
 =?utf-8?B?UkpzWHhmUHdJYlhkdWRSUWU4Y24wZmZyNTRtdGUrcHF6V3pNVHcrelcrTDM2?=
 =?utf-8?B?T05GOHFycFlOWkptWVVVUSsyMmhTUnJTbzduWHpLbFdDcmhYS2xmWTMyMXN0?=
 =?utf-8?B?dEkxMjhYdEJGNE1NU1hEdVYzd1d1VHdSbUI0SFB1UmttMHFMVXB6UmlpdndU?=
 =?utf-8?B?b1pKWTB6dXdCbnQvOXRpUS9oYzFScVhVc3NlSm1HRlpYN3lHSVJocFo3Zloy?=
 =?utf-8?B?QlAwL0t5d2J3SXdTRUFTdVR5U01UMkRXd0tuVDdHWDNzamJQaHhBblI5aXU1?=
 =?utf-8?B?TTFQYXg1cFVoWXo3WjlHdnJyTzFSZVdkcHRmR2tyVjdWSWpFL29nOGY1R2Nz?=
 =?utf-8?B?MXpOYzA1UmNxaFQ1S3kzY1J4UVBkbDNxNktqSzI5Z0pXSHZlT21ISW12aW1V?=
 =?utf-8?B?RXJUK05PVEdRN3pZZ1g1MllzeUQwSzNEZ3BMbHgrVzVMZy9BdWQzVlViVGNu?=
 =?utf-8?B?VjIyMVFqODNiUGhBQzN1Qy9LRlF6UjFqR1ppV25nZmZaWG5NSTVzcVBHZ3NN?=
 =?utf-8?B?cjRFc0FiOU9uNFlidk9kSmpkQzVDbWJhL1FzenZMR1dqdFpPc3lwYjVvbkU4?=
 =?utf-8?B?N1dNdlNBRjRDNFVmN0Rya3dZTUNzaHIrNXk5UEVCZDNLZTdKY3JNTjR4T3Y0?=
 =?utf-8?B?Q25EaU5pVDhJQkRGL0hoZVpjaTZJenpvTXA1MXRSQkFONmpIdnZMb1VGdXJv?=
 =?utf-8?B?OTdHbGd0RlAwdzZ6bnRuMmNPSGhJTnRCNGs5MlZqdUhqZHBZcmtQWDVnTnBa?=
 =?utf-8?B?bVdOaElkUmNlejhDeFJ4Und5N1M1aFZCUmdqdmxYMHkzVEx1bHp4YnBQL3ZQ?=
 =?utf-8?B?eE42TGliK3hsaVAwZFczVVRZU3hvR3JlaXJPM2gveXBVaVc5L2Q0U3JqMG1C?=
 =?utf-8?B?Y3hzVEkyVFFyRlFDU3VPbTZMRFMweFJzSkg1N3ZEUTRTME9hRUdONmtpYjNH?=
 =?utf-8?B?eVRPdk5TWUI5Q0ZoTzFYenlCcXFWRnYzakV2RXRCblNFRldQejFzNksvbWsr?=
 =?utf-8?B?SmtKL2paaXY1NlZ4U3VQUHZLb2dadkNtZjRWYWVlNytUUldvTCtHbGhIUXgw?=
 =?utf-8?B?bllBMVpaM1dJRjRwanBoVkZ1SHQ0b1VEZmNIMGVHRXVmZnFZNVpkbXdYUUJX?=
 =?utf-8?B?UmhmMW9hM0RDR2ZIMXgrYVNRZU1oWTI2MWYycHJXUTVHK2RNODYwb2p2UDdp?=
 =?utf-8?B?eWFFdWU3ZTQ1UU1CaFVaUG5XYVZNSkxHK0tPRm84ekwxUDYvcXZ4Ym5Bb1Qw?=
 =?utf-8?B?SXFmazJpN09oeDQ0M016SGxJQ3hGUi9sUFpSTThxUFZ5Wk1iS1pFMkUzUWd2?=
 =?utf-8?B?SWR2VXU1TTZlYlViYUdyVFAzSktrVUdNQjkzNDdEWWZYZ3Y0aFRvdGkrYmdq?=
 =?utf-8?B?bXdXMlJ0eXN2VndIWHFjaU5zVkRUVU9jQjRHWXpQZEhPQXVXNjY3ajFIa0Rq?=
 =?utf-8?B?QVMyTDR6c2pLNi9HcVpGTzVNSkFNdkw1bk1sNXNadUVKUm0zditZNVcxNG16?=
 =?utf-8?B?ZVFGZXlRbmFXRGJsbm14T2tkT2xZanVKL1RRRGcxTWhpKzB1dnN5THQrTkxF?=
 =?utf-8?B?ZWpqRDY2ckRXSUNsN0ZETHplaUpBbitXdE90eithZzlZOHR0Z3g2cFZOSVlq?=
 =?utf-8?B?V21iV0hpVWlEUzFCcG1uMjlobXY0NFErWC91THFFbFRtVHMrT3oyNUFtTmln?=
 =?utf-8?B?TDhobytPa3JTT0ZjUEZ1emc1Qk10azIxY1ZmMmxDdzU5WktCQ2hMUmJyazlI?=
 =?utf-8?B?eFFXeXRZaFJ4L3dlMmpWaXk4OWg4S2JJaDZucVNDb0RwTkZQKzJMMFBDam0z?=
 =?utf-8?B?ZUV1OTJEK2pPdlBMMWtFRlU3WThKVHlaTzE4VzViRGtVSFJHVXpCWEVlRUZG?=
 =?utf-8?B?NTZtenR5cFJlOS90anpMSVAxbUxEbnFMS0pnRjFvVzR6TzVNeVhIbVRGajZm?=
 =?utf-8?B?N3VBbklESVU4d002TFREQlo0aVVna3NjSG5ibjVmV1pWcFBpN2hqUG9MZ1h5?=
 =?utf-8?B?bDFqR0VCb0NIb0ttZjFTMXhRT29QRXJWN09nMlVncnJiR1VUTDRzRytqT3h1?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 535a79e9-8ead-4229-5a01-08dac1a7fd0f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 16:40:47.7262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3E4fONHEmplPHkxYFCq4Rxy2+0pvs3P5dY9WZbl/vtladofMdaI+nsXyDuVN4p4E0z+BsspXHJKRKpO/U4NjgXjN8ydI2ua4TL637kznUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6442
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/2022 2:25 AM, Ivan Vecera wrote:
> After commit aa626da947e9 ("iavf: Detach device during reset task")
> the device is detached during reset task and re-attached at its end.
> The problem occurs when reset task fails because Tx queues are
> restarted during device re-attach and this leads later to a crash.
> 
> To resolve this issue properly close the net device in cause of
> failure in reset task to avoid restarting of tx queues at the end.
> Also replace the hacky manipulation with IFF_UP flag by device close
> that clears properly both IFF_UP and __LINK_STATE_START flags.
> In these case iavf_close() does not do anything because the adapter
> state is already __IAVF_DOWN.

Thanks for fixing this. I thought we'd removed the last such use of 
incorrect IFF_UP munging in 7d59706dbef8 ("Revert "iavf: Fix deadlock 
occurrence during resetting VF interface""), but apparently we had 
missed one...

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
