Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80485E61A3
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 13:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiIVLpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 07:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiIVLpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 07:45:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B291FE4DAE
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 04:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663847065; x=1695383065;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G+lGOebf278BpbJe064Ytvif6KsikbLLswFct7g2/Q4=;
  b=U4EAsx1b0cRxZi+LMl3GV5zkP8Plx8N4DyVfjSCwvQQ8SdMrCZl8QSMW
   rW+qGw8i35KCXWAopiwpCqnz/x1JWIXMFlW+Hj49ng/hUtMhyP64vLQe6
   xZ/nCwrAk9RHn1lKGVB/iXXX7Q8LZ63FmgHxLC1gxSUnm+WYVcdA0jEcZ
   sEbsTmx1dyymmvvttHbuw+QeyR/ERM0Vwm0ewuf7UAC2PLXGSRKUMSQ6A
   x4PA3WL9lPJKvtqA5Zi3lxxdhoBIRBGYstmUdfc8uf60oj7erFhTqEl0r
   p9aPvjQnyneZw1A/0bponCa6tqpxVmyfxI3rzY1XnuiOAberqZbens8tT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301120441"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301120441"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:44:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="619761656"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 22 Sep 2022 04:44:24 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 04:44:23 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 04:44:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 04:44:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 04:44:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NO24WaycqlF3udVIzMIxvyaGkSxb7+f/2bG0SOM8DCwWYPawyDZdTzQ1wu04b/ho4S/lNZFVYXR0XAUSAzSjevWjn4vNj8iy8OwitWvpZG2JVCcAf28kf868AkaoPsfAmovWdiU7DcN8oNXeE42OZU1XhymvHoNbggAl8WKDiK6e9rGzhW7iQDTAwd5vRB983kkGuMAip+hOTx2ROUkbbX5Tfwz68jUdfRNUrcITYV4Ipt0cpjK52oWKsEA3fqaIlhuKNEXQFYuIlDa1Ni11J4nQqeuDBVBcQ3NX3FKU/DAMmGcNdzFmEqwttFMnwuBNjZlck61Zf4yrKoaf7pMW1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=InNSABV7tTg0WiV3Ox+7FcwZSYbqKp8E7O9k1e0UfIY=;
 b=DAvQrbWw0VlFsjA3pOd+BJzOh3qqxnPUmV9HT0FpLDKtsHE/UMkTSyGZksx+6TvRyt6aBSel1GoDyXCNzKywci8htgOGyr+xyypeGW6NxAue672MwkxtEbI5TjqER3XeqFsL5LlPU9MLdRt24s5AbxSOTrg3SmAmGz5mH7WunHhpbm5wEXJOCJxZbSzFB9KGIRlQVu4e1yZI2gNJrtWCQHcqlX6fcOCF6FVPR3CbE5XSE4ddviz67VHIAHNrqmw2NcAC96EWZsfZUsZuvLH0hdLWQLw+PJ8nmBx8PS4COU+x/Vqvx5yX9hw//KtZsl0EHlDUJeNviBMqZkcVCqPdMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by DM4PR11MB6213.namprd11.prod.outlook.com (2603:10b6:8:ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 11:44:21 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%4]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 11:44:21 +0000
Message-ID: <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
Date:   Thu, 22 Sep 2022 13:44:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <20220921163354.47ca3c64@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20220921163354.47ca3c64@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR04CA0159.eurprd04.prod.outlook.com
 (2603:10a6:20b:530::20) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|DM4PR11MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b3755fc-e7d9-4c6e-9ec4-08da9c8fca4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mK73n+waQwlNDftzzL9dDb39XYN9IKkKJjQHsYSL+gD70LA9gZUUShEu8mrYXxDHWnDaG667Aef2vi6OWElXd580OmNDCevSuQBsLGagETE40J3a/McvaG9W6wh4cP+dzgafj9LEMsF4Ngg3Fe3cxqE6tcn9wQU3141LeK72PKCLmcNweCkVReXj2VWRBak1tSgNx3JX5FijfNjI3Jfjkd4wlk5eNrvvK4KO/AD/XpL8q9tjzpAe3h07a8POrzI0ja6rheuuiM+/p+Z0ILbCs54kFkJNyFo8xqCtHw9h+Zjb8Er8A+4V531TAF3jCvVCJPlO5MVV0LWUIdT4/zbuT19PSEyuxBSD2LbGZuhSou9FzemeIX9XHxC0SQIC2NHrI4tIHtxWvbusIIMp7aLt9YoK+0eEEe+3IaJb8p8cWWUEAolLKak+ohngvGGM01HyEihJDMZg3VD4y00idXA9bMPdDZP1yabJ3EOI82qrqMUvNk0FuCTRLc5n/asnfanBjVI+5NB64KvmOp8/ve4ss6PH0dvy3BH6RssfIiSohzEfsCyYGnuIqNQbyBIRctigtuKuiX5gcQ4Mu/9CpzGwivHP17zisVr1lT48tXCsqwMXb6aP7LonefbycZ6EUaTweo3+UVsoO+54UmCeqNK1IjigY8nZMehs52P5xuH4/vh7iJ8hFITHgaLtOG6zQ13Q+1VkkmSmCaoq+KFGhB3eEJrAuZdaZkmSH+qATiMQo6ssAlOe5ISzYlzILAU70BfI5SfYVGr9kqfPwfE0cnW0kcX7XBmhiQT2EuJb3jr/Ymo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(8936002)(6916009)(316002)(5660300002)(86362001)(66476007)(66556008)(66946007)(8676002)(4326008)(82960400001)(31696002)(83380400001)(186003)(38100700002)(6666004)(107886003)(41300700001)(6506007)(53546011)(6486002)(2616005)(6512007)(26005)(478600001)(2906002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWYwelpwbVVtUUY1UlVsR0pqUUFXVDU0d0FMY3hzOFRkZy9wY3p3YjFRY0Q5?=
 =?utf-8?B?elRrUTBYSkFvbHY0ZW5EVGIzQjNDZDdYU2wyRFBtSG4wd08ySkMvTFhEQ1g0?=
 =?utf-8?B?bHg5Nnc5cWZrbmtpZ2lib0pSN040cFN6ZkVHdC96ZkJFQ2dwSlZSRHh0aWRq?=
 =?utf-8?B?cWpxQlFWY3E5SjQ2c0swUFI0UXN4NEticTlZeW5heTN3Y1F5TU1EamtEdWw1?=
 =?utf-8?B?UUh5cUx5UG8wZUl5WVJ2M1ZWcWdUUFBseTU5OGR5WVhXSmNtNUVRVWxER1Nt?=
 =?utf-8?B?RGZsblVRNy9Dc0pUaWRtcFhFNmpxUTNmMEtybUlIejRRYmxxeW9HaEVnSjBE?=
 =?utf-8?B?YVVsMUtWK2VHWlc1Z3NOS1VTWHBPNGtMZ3J3YlVJc3BjR3dRcTB2ZE5uSUkw?=
 =?utf-8?B?SVg0TmZORy9Ea3pBSVp3c2hkTk1qVG9wTzZCRUQ0cWxKZy9KbFhoUGtUOGYv?=
 =?utf-8?B?b3BoaTZqcUFEcHNHcmJLM25qbmdBalJscGZIVzVyT3dldld1d1VmVDVaWGJC?=
 =?utf-8?B?NmZUTHJJeG1STWErN3lqeGxnOFMvOXREbHdRRkdhanhzY1h3bDhvR21Yb3FX?=
 =?utf-8?B?Z1hnMU9JYmxCVHBMeWMxeEo2a2tScEtUcU9tVkNub1c0TzhRNU51QUUvOHkr?=
 =?utf-8?B?NnhUZC9HSzZNdnIzRGhadXd4WEc5U2VBRHBuTWNxeUZoK1U0UWtKWWVHNG9E?=
 =?utf-8?B?eHh5b0xaeTZjbFNSYlpsc3pFb1RQdmZ3bTNFN21FSm1zRTRwYmtXR0g3eWVG?=
 =?utf-8?B?c0FqUjE1TDdhcWp3aXREZlBRM2dEcmcrQXJCeWUvVzIyTVRncXIzQnB2R3hy?=
 =?utf-8?B?clNrbks3R0dBNndrSjQyUzRmeisxaGNwWjBQVUJ6OXJtYkt0L1htNXlFNWJ1?=
 =?utf-8?B?aWQ3MWxOM0E5eXVqVktuNTgrcFlSUFh4cng3bk9aV2gwd3NrN2VBZ1BsM0o3?=
 =?utf-8?B?SFhOL1JMS3l3TlVOdHVZNWF5QXhmblI3TDdKdGZ2QkVSSWlmRDJ1K0lsaUds?=
 =?utf-8?B?Slc0cm41SmRMRnYwRU5admxpR05SQzV2QnhYU1JHdElDUXQ0NmdObEc5eFkw?=
 =?utf-8?B?SEpxY3p4L1lmR3RGbEEzQVg1VTUwV3JBTGlITWJ6Qi9TcGJZOHpTblpKUzBT?=
 =?utf-8?B?TGM3YktJcHNuY29hd1djM2V4OHJ1MjFsRC9wZ2ZHN284YzRUQXhkempZUG5y?=
 =?utf-8?B?M1FHNXVZVVpPeFFBVXUzcEpWYkxUcTlmK2NvUW1xYURQaWgxdElGaFRPaXky?=
 =?utf-8?B?U2wrTTdyZEd2c0RLSGxOWEJhZjlQTnIwYU13Tml2UG9HaktBVzgrUHFWbHBr?=
 =?utf-8?B?bmZoaWM1TWVnOUxBZHRGNVNMOHRmU2hOc05EaDU3cDV4Wi9hd0xyMWVIREJW?=
 =?utf-8?B?dzFmbGR4NCt2bVRiM1R6WWZ1SE9HcGxhVCt2V3ZUU1B5cjVENHZmYVlkQitN?=
 =?utf-8?B?bXBqZk8vNmJVTWx3SHpzOTA0eFpxSUxDQUY5aEN2aWR0cE1WWDRYUVlJckpy?=
 =?utf-8?B?N2Nyeld5ZVk4SjBkS3o2Z1BxaXhYT0ZXSStLblhZN3IwRjk3Nk5LVmkwTmVZ?=
 =?utf-8?B?cDlzMUJxaUR3ZWM0Y0F5QnhYUTJGaVFsNWhUUUhJOWJYb0pJdmdWVFdnVkFY?=
 =?utf-8?B?ZTB5S3JXZUlYYk94UVdQWDdQUGNjeUExWVNQWHdsdllLc3NoUG1ucENEb3Vv?=
 =?utf-8?B?SnMwZVl4dTZ6Y2U0cno1SFV6S1hrZHhuVDlIMVd4QU5uSG0rcDRIZk91UE9o?=
 =?utf-8?B?aHNxcUJIckxIWTFQTHFLN3Z6VXFabjczejhSZzJKSlpvemNSejdscVV2dnFY?=
 =?utf-8?B?MWlhVXROMjcvL0xiWlpKckREWm9WSng4SjJjdC9tS0liT1hMVU4zYXZnTmFq?=
 =?utf-8?B?dHVuVER6dWtmTmNrdDBDQjFSNEZKRGpFcXBIQ2VuZUxqR1dVMnlNREZIQXdq?=
 =?utf-8?B?QjRPQnZub0kwd2JvSTQ0cjV4TnZCMWlwNUJxTnlkWVg4V2VlWkNJbmQwQmdI?=
 =?utf-8?B?ajdURm4zUzZYZ1lpZ08vK1JiUTd3bGtacENqcjlucEM2MjhaNDdzd3dFWlow?=
 =?utf-8?B?aFd5TXFMYnpaWDA0ZGV3SVRMZ2RHalB3RHhuVUQwOVIva0RpRHVuSVVsb25N?=
 =?utf-8?B?TWpCRlFvaUtkb1dCRG4vNEFobzYxNCswdHBzYWI4ZnFualJKdXFrd0RZWkJL?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3755fc-e7d9-4c6e-9ec4-08da9c8fca4f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 11:44:21.7318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RbB0KuC9OKGuCkKsX80ZIl9GAqryiCHvzVxOqYgwwVxI3sXpeDCqNhR4ruH6wPXfblOYrzlHBrGju8h04oV30K69AvX7Lc0lW/W13atBZSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6213
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/2022 1:33 AM, Jakub Kicinski wrote:
> On Thu, 15 Sep 2022 20:41:52 +0200 Wilczynski, Michal wrote:
>> In our use case we are trying to find a way to expose hardware Tx
>> scheduler tree that is defined per port to user. Obviously if the
>> tree is defined per physical port, all the scheduling nodes will
>> reside on the same tree.
> Can you give some examples of what the resulting hierarchy would look
> like?

Hi,
Below I'll paste the output of how initially the topology looks like for our
hardware.
If the devlink_port objects are present (as in switchdev mode), there
should also be vport nodes represented. It is NOT a requirement for
a queue to have a vport as it's ancestor.

In this example we have two VF's created with 16 queues per VF,
and 72 PF queues.

User is free to reassign queues to other parents and delete the nodes, 
example:
# Add new node
devlink port function rate add pci/0000:4b:00.0/node_custom parent node_199
# Reassign queue
devlink port function rate set pci/0000:4b:00.0/queue/100 parent node_custom


node_0 represents a port and doesn't have any parent.

[root@moradin iproute2-next]# devlink port function rate show
pci/0000:4b:00.0/node_200: type node parent node_198
pci/0000:4b:00.0/node_199: type node parent node_198
pci/0000:4b:00.0/node_198: type node parent vport_2
pci/0000:4b:00.0/node_196: type node parent node_194
pci/0000:4b:00.0/node_195: type node parent node_194
pci/0000:4b:00.0/node_194: type node parent vport_1
pci/0000:4b:00.0/node_185: type node parent node_184
pci/0000:4b:00.0/node_184: type node parent node_0
pci/0000:4b:00.0/node_192: type node parent node_191
pci/0000:4b:00.0/node_191: type node parent node_190
pci/0000:4b:00.0/node_190: type node parent node_16
pci/0000:4b:00.0/node_14: type node parent node_5
pci/0000:4b:00.0/node_5: type node parent node_3
pci/0000:4b:00.0/node_13: type node parent node_4
pci/0000:4b:00.0/node_12: type node parent node_4
pci/0000:4b:00.0/node_11: type node parent node_4
pci/0000:4b:00.0/node_10: type node parent node_4
pci/0000:4b:00.0/node_9: type node parent node_4
pci/0000:4b:00.0/node_8: type node parent node_4
pci/0000:4b:00.0/node_7: type node parent node_4
pci/0000:4b:00.0/node_6: type node parent node_4
pci/0000:4b:00.0/node_4: type node parent node_3
pci/0000:4b:00.0/node_3: type node parent node_16
pci/0000:4b:00.0/node_16: type node parent node_15
pci/0000:4b:00.0/node_15: type node parent node_0
pci/0000:4b:00.0/node_2: type node parent node_1
pci/0000:4b:00.0/node_1: type node parent node_0
pci/0000:4b:00.0/node_0: type node
pci/0000:4b:00.0/queue/0: type queue parent node_6
pci/0000:4b:00.0/queue/9: type queue parent node_6
pci/0000:4b:00.0/queue/18: type queue parent node_6
pci/0000:4b:00.0/queue/27: type queue parent node_6
pci/0000:4b:00.0/queue/36: type queue parent node_6
pci/0000:4b:00.0/queue/45: type queue parent node_6
pci/0000:4b:00.0/queue/54: type queue parent node_6
pci/0000:4b:00.0/queue/63: type queue parent node_6
pci/0000:4b:00.0/queue/1: type queue parent node_7
pci/0000:4b:00.0/queue/10: type queue parent node_7
pci/0000:4b:00.0/queue/19: type queue parent node_7
pci/0000:4b:00.0/queue/28: type queue parent node_7
pci/0000:4b:00.0/queue/37: type queue parent node_7
pci/0000:4b:00.0/queue/46: type queue parent node_7
pci/0000:4b:00.0/queue/55: type queue parent node_7
pci/0000:4b:00.0/queue/64: type queue parent node_7
pci/0000:4b:00.0/queue/2: type queue parent node_8
pci/0000:4b:00.0/queue/11: type queue parent node_8
pci/0000:4b:00.0/queue/20: type queue parent node_8
pci/0000:4b:00.0/queue/29: type queue parent node_8
pci/0000:4b:00.0/queue/38: type queue parent node_8
pci/0000:4b:00.0/queue/47: type queue parent node_8
pci/0000:4b:00.0/queue/56: type queue parent node_8
pci/0000:4b:00.0/queue/65: type queue parent node_8
pci/0000:4b:00.0/queue/3: type queue parent node_9
pci/0000:4b:00.0/queue/12: type queue parent node_9
pci/0000:4b:00.0/queue/21: type queue parent node_9
pci/0000:4b:00.0/queue/30: type queue parent node_9
pci/0000:4b:00.0/queue/39: type queue parent node_9
pci/0000:4b:00.0/queue/48: type queue parent node_9
pci/0000:4b:00.0/queue/57: type queue parent node_9
pci/0000:4b:00.0/queue/66: type queue parent node_9
pci/0000:4b:00.0/queue/4: type queue parent node_10
pci/0000:4b:00.0/queue/13: type queue parent node_10
pci/0000:4b:00.0/queue/22: type queue parent node_10
pci/0000:4b:00.0/queue/31: type queue parent node_10
pci/0000:4b:00.0/queue/40: type queue parent node_10
pci/0000:4b:00.0/queue/49: type queue parent node_10
pci/0000:4b:00.0/queue/58: type queue parent node_10
pci/0000:4b:00.0/queue/67: type queue parent node_10
pci/0000:4b:00.0/queue/5: type queue parent node_11
pci/0000:4b:00.0/queue/14: type queue parent node_11
pci/0000:4b:00.0/queue/23: type queue parent node_11
pci/0000:4b:00.0/queue/32: type queue parent node_11
pci/0000:4b:00.0/queue/41: type queue parent node_11
pci/0000:4b:00.0/queue/50: type queue parent node_11
pci/0000:4b:00.0/queue/59: type queue parent node_11
pci/0000:4b:00.0/queue/68: type queue parent node_11
pci/0000:4b:00.0/queue/6: type queue parent node_12
pci/0000:4b:00.0/queue/15: type queue parent node_12
pci/0000:4b:00.0/queue/24: type queue parent node_12
pci/0000:4b:00.0/queue/33: type queue parent node_12
pci/0000:4b:00.0/queue/42: type queue parent node_12
pci/0000:4b:00.0/queue/51: type queue parent node_12
pci/0000:4b:00.0/queue/60: type queue parent node_12
pci/0000:4b:00.0/queue/69: type queue parent node_12
pci/0000:4b:00.0/queue/7: type queue parent node_13
pci/0000:4b:00.0/queue/16: type queue parent node_13
pci/0000:4b:00.0/queue/25: type queue parent node_13
pci/0000:4b:00.0/queue/34: type queue parent node_13
pci/0000:4b:00.0/queue/43: type queue parent node_13
pci/0000:4b:00.0/queue/52: type queue parent node_13
pci/0000:4b:00.0/queue/61: type queue parent node_13
pci/0000:4b:00.0/queue/70: type queue parent node_13
pci/0000:4b:00.0/queue/8: type queue parent node_14
pci/0000:4b:00.0/queue/17: type queue parent node_14
pci/0000:4b:00.0/queue/26: type queue parent node_14
pci/0000:4b:00.0/queue/35: type queue parent node_14
pci/0000:4b:00.0/queue/44: type queue parent node_14
pci/0000:4b:00.0/queue/53: type queue parent node_14
pci/0000:4b:00.0/queue/62: type queue parent node_14
pci/0000:4b:00.0/queue/71: type queue parent node_14
pci/0000:4b:00.0/queue/104: type queue parent node_192
pci/0000:4b:00.0/queue/105: type queue parent node_192
pci/0000:4b:00.0/1: type vport parent node_185
pci/0000:4b:00.0/queue/72: type queue parent node_195
pci/0000:4b:00.0/queue/74: type queue parent node_195
pci/0000:4b:00.0/queue/76: type queue parent node_195
pci/0000:4b:00.0/queue/78: type queue parent node_195
pci/0000:4b:00.0/queue/80: type queue parent node_195
pci/0000:4b:00.0/queue/82: type queue parent node_195
pci/0000:4b:00.0/queue/84: type queue parent node_195
pci/0000:4b:00.0/queue/86: type queue parent node_195
pci/0000:4b:00.0/queue/73: type queue parent node_196
pci/0000:4b:00.0/queue/75: type queue parent node_196
pci/0000:4b:00.0/queue/77: type queue parent node_196
pci/0000:4b:00.0/queue/79: type queue parent node_196
pci/0000:4b:00.0/queue/81: type queue parent node_196
pci/0000:4b:00.0/queue/83: type queue parent node_196
pci/0000:4b:00.0/queue/85: type queue parent node_196
pci/0000:4b:00.0/queue/87: type queue parent node_196
pci/0000:4b:00.0/2: type vport parent node_185
pci/0000:4b:00.0/queue/88: type queue parent node_199
pci/0000:4b:00.0/queue/90: type queue parent node_199
pci/0000:4b:00.0/queue/92: type queue parent node_199
pci/0000:4b:00.0/queue/94: type queue parent node_199
pci/0000:4b:00.0/queue/96: type queue parent node_199
pci/0000:4b:00.0/queue/98: type queue parent node_199
pci/0000:4b:00.0/queue/100: type queue parent node_199
pci/0000:4b:00.0/queue/102: type queue parent node_199
pci/0000:4b:00.0/queue/89: type queue parent node_200
pci/0000:4b:00.0/queue/91: type queue parent node_200
pci/0000:4b:00.0/queue/93: type queue parent node_200
pci/0000:4b:00.0/queue/95: type queue parent node_200
pci/0000:4b:00.0/queue/97: type queue parent node_200
pci/0000:4b:00.0/queue/99: type queue parent node_200
pci/0000:4b:00.0/queue/101: type queue parent node_200
pci/0000:4b:00.0/queue/103: type queue parent node_200



BR,
Michał

