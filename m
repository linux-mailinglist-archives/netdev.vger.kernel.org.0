Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C226988A4
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 00:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBOXNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 18:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBOXNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 18:13:45 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852AB3BD94;
        Wed, 15 Feb 2023 15:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676502824; x=1708038824;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0ao/DAi8jzcLvUAr7oEMWI6i18jffc8F6/bNhLiZ+Q8=;
  b=P3eXLEgJ/ROh/325h2Vc+hEH94usyt/fZK8rjixycmk71FFtYCiA2qXx
   9TgBL6prsr/FOBTJTcCPNzRtf8Je3n/OiFK7WZbmys/PfuANoHXwGyMW3
   0t/NK0mJffz4g2xx5S2EOZPxZEQ+cRofYvxuxrasMevA0x+I5JNy/Y96F
   ws2DnjlmDeqVLmnPltABhPeuwlBcUzpLz0FYPu+LyLU+gCADMRQ90AGnt
   7SKosMRi11ezfTvHuvP6s/tXsFnXWyPtVn2lrnd5Pi7XLMnknGwZQd3nP
   ozj+7XyHS2MvJZQ5OZKgUCcQhiI2nbKJDfgl7d48bczHRC7EkTpdHnPma
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="333720676"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="333720676"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 15:13:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="702347902"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="702347902"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 15 Feb 2023 15:13:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 15:13:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 15:13:35 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 15:13:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Monu6hC2YcduJDFdj7eiXyky2hq9mOCrGxKP7RBte6WHWxmoWuaTHQd/LRSOIQyZlj3+dl+WAQyzfKyACdPgdXjZJ2yLPMqElnDjMY0cs03437Oq5d6ZbiND4T3Ko5SopxCdgBScNMWChjB4J/Z1rCKv9Unh1cayujsMjwSD+jCJwOqcI3CBeRPjqgiKGNQnSwELcfl9B8u4tbUj1oYqX/LihS8EBqSJU7Lcx1vgQ3u+dapK3I/N9uZivjMELbNDCEB9Oub32/2sPaKUHaFvJBfY/we3VbA5DaIT/C9rVpDMIulsLR3rPTr3Vpa54TucWa0q9YjcpJXua8OYStFPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6Ir6z++eiGklWrfsiPSR2XnV+93DNarvsKO/z0gVx8=;
 b=CyvluWXoEAvDHulhUDN7gprR70eVrsEK/HNw3mOnvWtRt7iXO/MwjQFdxQ6Xy8+XKpvbjL5OpCda/M7UKEuAhTcZDrAd81fATYqamTElzlChCqwdaW6qgALJtzGSEKh31DrgWY0Q9GAARvQ6Bjoffx4mcMtlUWd4UTivCEy/Q6r8UEef+HR1q9ydKuwgVMLs8amTvexJTrfbVJOgBIuQm9xHG1DhM/MgA/2Hsb4Z+AFTA8Lu82PMlu6vEf37kKYCNVuwlpGbSyNk5+mZVOgOpj9LAj/5iyRSSUc6PKubPfUvnb86ZSjP8M4VvmGBTFTPafwx2WzBQDlN7vwDjMWCZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH8PR11MB7022.namprd11.prod.outlook.com (2603:10b6:510:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 23:13:31 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 23:13:31 +0000
Message-ID: <1fa87a9f-1362-126a-49d5-3df7e84555e6@intel.com>
Date:   Wed, 15 Feb 2023 15:13:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH intel-next v4 0/8] i40e: support XDP multi-buffer
Content-Language: en-US
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <jesse.brandeburg@intel.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <maciej.fijalkowski@intel.com>
References: <20230215124305.76075-1-tirthendu.sarkar@intel.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230215124305.76075-1-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0059.namprd07.prod.outlook.com
 (2603:10b6:a03:60::36) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH8PR11MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bb85cae-663a-4d01-d2e6-08db0faa4128
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDJCO2xAU7A6cJKc+xLe14XwJqhcFsRqaI4yPfCQozMTTm+/6K4HYCYMqkiR4HsD/7lOWyoet3EVr3dyT3zzF0O9iujLRkWrZC4lPzLUwPGONtEGyi/+TR+VKrt+EvqOfOrnjz6lu9IpcHH0+MIsRrfWlebHzAtTDOD1ghVHwWmwRTsBNdbdBo5ie6+pf9r7WOR2Hc6Z7R1l6HzsjLN2jYTBvyzwrZOdD3xusBsrcibayW9ysgGHefd/68kvkeoQy8x8k5ZpU72fqB+xM1V68dW1FPy7RCvrcQOUR2IUl07CkkG6fa+hzfmkAz2Npf99cIQJ2fRn/Lw6XxAXD2MvKBdrm+W+FcFfJy99KorsBsR7vQTVRVPhnyLTHNmuPrWbXgGBRbQPxm6UfWJj/uAuOCW0iF8Ubkev1Ih+YLTU3HSWq81weDdxUzkxNnic/5RxXWdII1w2iKFLfoPUsLwZiaYaVd6Uap52m0fwiTsW9J46h8IJWOsT3dHbwUrHWyHVSj527wR6cr/D9xXI3j2Avd/Y6KV/AQkXrSc0T4bxiETNeUhwbey0aT/JITnYtg/wjLtca5Aril5zkl3UfpBLhpJ+XZg4yJDjTKS44Mpu7CaPa7hQzrbZ9yk5cp/XMZTgQm5Bdmi7m1oGkzJe2G9tClK2kJeUInGsJkqJmtROFlhVnlR13gO+iDQU83fIwvzRb3i1P/Vc0/Tgr1a5mmtw7NJMV82BnmQUDr3FaaKg4u8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199018)(8936002)(5660300002)(41300700001)(31696002)(82960400001)(36756003)(86362001)(4326008)(2906002)(38100700002)(966005)(6486002)(478600001)(8676002)(26005)(186003)(6512007)(6666004)(53546011)(31686004)(6506007)(2616005)(316002)(107886003)(66476007)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUlYMURBYkpmWGRvZWlQQzhQSmoxL0xYdEZOUFZ3c1VKUUlsdVpIYVpzUUZ3?=
 =?utf-8?B?cG1razNBMDUxWm9WNGUvcU5hUHVENzFjVUhiR3pFR2UrN1ZqN3QrM1FkVHBu?=
 =?utf-8?B?MUdNUVh0N1NBWU1SeWd4ZkN0RWVQcTU5cmZhSkpMbUM0N3JuOTRKSDh1aEQz?=
 =?utf-8?B?ZEQvbjBNZ3dMRFpCUFZKcC84K1J2eVB3LythSGNiMUI1elZkenJqYzIrNXhx?=
 =?utf-8?B?ZEdESi9wZkZiY3ozOStvVFp6QUVHVytkQXgyRjBQOGlMMzlpZ0I0OTNBYVFH?=
 =?utf-8?B?NUR6VlhqanZUZzdDQmZTQzZqRWFlYkVOdzZ4TkljUUxiMzRyd2xscFMwK1Bl?=
 =?utf-8?B?cDdmUmQxZVh1YjE2Y3VQQ1A3WWpsZ29kcHpkOHdSL3pIWG9tK21tUEdDS01K?=
 =?utf-8?B?akVSSUlvVk1nejZMdHV0RjN6eSt1elBzQVpScXh1RVYvc0Q1Y3diT1JCdkRN?=
 =?utf-8?B?RWhIR0V0Y2gzNXkzN2pOL2ZwcWtvNkVySCs2WUYrL2VGZHMwTldBY3hwZlRv?=
 =?utf-8?B?UDJ1d1RRcDd4bm1jYllwVDA5OERyWExBZlBYU0QyN25HSVBhcnJBOStPSXJV?=
 =?utf-8?B?cm1FSnRmeTBKV3Q2cDFqWXJ4amJNUWUzVWU0cFZ6SXJUc0dCUkNwWW5KdmJw?=
 =?utf-8?B?TDBnSnN0YjdsdWVwTzZBbVY3MHlJQi8va2RpTjJJNDRzRnhoR2Jia084MWNy?=
 =?utf-8?B?VXRTN2YxRlpqU1Fic0M2eWRBUEpNTEE0dUt5U2dCcWo5YTdqc2RNWFZRUWRF?=
 =?utf-8?B?QmZmajV3bFd6NXVjZUU3M0htR0dUZFhTZlNwejViR1NvNXZOQnJ5b1BQaVlp?=
 =?utf-8?B?d0tGck5DbG9NNzZRZitpYnZLaUlrc3d3dzNuODkyZFVpajlZaDNOYlJvOVpW?=
 =?utf-8?B?c3dPVmxrMzQvRzNSK25hNUE0TzViUU9nQVJ5MExnN1NvVk55R0NsWk1kdnlQ?=
 =?utf-8?B?SEgxWHF1OHY3QmFUMlA0MkZiMzJLM1FFV0labFFzY1ZiemY4T0MrQktxZ1ZV?=
 =?utf-8?B?bFdVeW9vNVlTSlRXMEdwemQrM1lXb3hsQ0l4U0w3Y1h5bXI2UXpsVmp3Qzd1?=
 =?utf-8?B?WVhUUmFUdjVFMUpTNGpGbTh4SXF5dVRkQUZPaEpCQk5mUUJZL2lWRkhlaU9k?=
 =?utf-8?B?czFVTUd6anBTRmdOZE1SaGZHYUJoYkgvK3dERmVoc0w4eGo5Yktxc1ZJLzVl?=
 =?utf-8?B?SWZqM3p2VW9tbnZYTG5GZ2ZCcFQ2emFCUEMyVTJ2WFlmSjZMZG5SMDBTVVNh?=
 =?utf-8?B?NWYwUjZzTWt4V3Q0K2lvMVdkcjVFQUxXdG45T1FkS0tSSDQxcGZPUGsxWDJK?=
 =?utf-8?B?NzlGTGVqZEh2bmJRN2xIeXhHUDVBRlJUdGVhNUJPZG54bUF0K0M5N3BlUnRD?=
 =?utf-8?B?VlBzNjBkVDQ3NVlRTUhQU1hTRUd2WnlwNEhDcE1ENTdySHFNTEVkRGwyYVdp?=
 =?utf-8?B?SndRZnFYZ0JXeFF5cVlqWlpOWGN6SVNNVURreXBHOC9Qdm5sTGk3SytjSDhV?=
 =?utf-8?B?VkVUeTYwR1ZXdGxPcU54Ym9FRnArNHVHT2ovcVg2NWc4a0dXeFB3SmhUYjlQ?=
 =?utf-8?B?TldLMGVQR21jekFEdG04QWZIOUM4WFNmUEp0b1hleG12by9VTlg0M21NcGl4?=
 =?utf-8?B?bzcwVytVNlZrNmk5NnMrZkJYWUUvK2xaTWxNOGlJcmJzU3pSVTk4akc3bmRQ?=
 =?utf-8?B?WHJtU1FHT0VraGhVQmExbDR6ajRTK2FhQUdQeTkyK3M4WDExVUd4MUxXcGpz?=
 =?utf-8?B?WG9lbmNxaUtQcHRCcXg5S1BhRy9IZjdWTy9GMHdKbTgvcnZCMWNkOXI5WEZl?=
 =?utf-8?B?dDJnQkQvcGZOWHFMMm1oNU02NlBtY2U1ZnRZbzFoMm9kQ2FNMWRmeFZxNXpJ?=
 =?utf-8?B?cnBGV1ZsQ2RVWUJmQjFZQi9DM01xcUJvV3FRbmtCOUpEcjZLSS9EQjRZUTZJ?=
 =?utf-8?B?QmxKY0xTajd0ZTMyQjBMVW1uaGxZclZyQU1kR243OXhuWlZ4NStaZlk2VldB?=
 =?utf-8?B?elM0MERuU0JDMFpBRU4vd0NkSmp5em0zSWRoeEtHUzZKc0hMaXRKbEwvWHpS?=
 =?utf-8?B?NG5sblFBSy9VNzVVdXUyMGNGT0o1RDJoOFgyaEozdHNKQWd5NWhiT1BrN2h5?=
 =?utf-8?B?bFl4a3EyNDN3VWFTUUtocGdWbFp2eExZUGY0TlRMUFk1Wld2RkdLV3Izdlh5?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb85cae-663a-4d01-d2e6-08db0faa4128
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 23:13:31.8077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XcevhHwkgdDl6OpnCldEPFpfGNHZKCRIo8Z7FguxiotljfHei/UVvT59tpxa1HwmEl8dOxvfNeDiD2I06edRiglbJ6ZmHblAL1MO7Gf4v0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7022
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/2023 4:42 AM, Tirthendu Sarkar wrote:
> This patchset adds multi-buffer support for XDP. Tx side already has
> support for multi-buffer. This patchset focuses on Rx side. The last
> patch contains actual multi-buffer changes while the previous ones are
> preparatory patches.
> 
> On receiving the first buffer of a packet, xdp_buff is built and its
> subsequent buffers are added to it as frags. While 'next_to_clean' keeps
> pointing to the first descriptor, the newly introduced 'next_to_process'
> keeps track of every descriptor for the packet.
> 
> On receiving EOP buffer the XDP program is called and appropriate action
> is taken (building skb for XDP_PASS, reusing page for XDP_DROP, adjusting
> page offsets for XDP_{REDIRECT,TX}).
> 
> The patchset also streamlines page offset adjustments for buffer reuse
> to make it easier to post process the rx_buffers after running XDP prog.
> 
> With this patchset there does not seem to be any performance degradation
> for XDP_PASS and some improvement (~1% for XDP_TX, ~5% for XDP_DROP) when
> measured using xdp_rxq_info program from samples/bpf/ for 64B packets.

If you want this to go through Intel Wired LAN, can you base it off that 
tree [1]. This doesn't apply to next-queue/dev-queue.

Thanks,
Tony

[1] https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git/
