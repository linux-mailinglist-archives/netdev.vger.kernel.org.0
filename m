Return-Path: <netdev+bounces-11032-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DEEE7312B9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 185582815D5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1792F53B6;
	Thu, 15 Jun 2023 08:51:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A210EDF
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:51:50 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B330CD
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686819097; x=1718355097;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2nQNQBIPu+zjSxWVJHNMYe0s67lM6KxzLvpuSwToxBk=;
  b=ROgszr+RT2osp9A9i51NZfKiQp8tWnf/gAszeJ6cWIsLbN69z3YqLwYt
   PqsJn+uKyMU5Yrm2dt/LsgZ3i70rPdLP6RMGXx6T8q4/RICRROWv7P8GM
   0cTRXabSuei4C2cYGnnOmRy7pBxHQHJ7dFVghiwSBHpKqkc/20AcnqUzK
   ayWjnYrmySXLjUG9hIRhNEt/dmoA3X+tMq0fPcEdZ4SPSrBMKfbDkMNki
   wXtRp+OjeGFwJ8WOUWw7h4MAYM6zzMOcP31ERp3OKzYQn1jhzaZyvPZie
   x2CjZxSmoiU7spaXQ91qEq3jeBXrPIeQ2ah81Ya8s5ziaWXDm8XC3jEcz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="357734515"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="357734515"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 01:51:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="802261824"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="802261824"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Jun 2023 01:51:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 01:51:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 01:51:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 01:51:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0Eo3nxQ0q9IETK1h1zYMUxuOdFXYkkHVNBF4dXYlBQ8aMqqURuUq4s4LX9gy/eRcvKZSapMW+Ru2tMuSclwdD/kbJeGoWjwFYYJYQ0yh2IDKV01vY7yfEQ4QEmn6hxgjD7wNbgqwDRoTJRLDtBgF0fpV5D3+8ODO2iTD294rJ1UfBCf+obfirRTy1PqKwUiEB2rAz4hKMIx0glKA55zM5Vobih/vYVFOKm9OJCssgBAcKpoRzLI83bJP43p8ubspLUgqNMexeiBrqpoA6JejXLUwOqG1tKpS40LCMwV/AuMOKvobYZUPLMMApZx5m8sVbZXdDQFxChhRL3fddaHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVmlInaRnmynQywjoMBdzflZY0i0g9t0ZmsZ0Pp5tT8=;
 b=FEj20/W3ZchiVzw1miwD9I3bEpIY4yByr+GZ6Cl/ECy/XczWF+J6QPp/IHkA5LeAFc7P1U3EHf+dmc7kTazQsmZ362WB6KLyLoqGuL0oI7sU6jz3GOoc2mmXaWvzByUX2X7zGtJ0Hh5R9eYqCG/sBz8qpQx23ltgX3SZnqpe41SngyC0k8srTs0t8biUR8y2rzknoubZXiq6CSdIO2Y3JEnjI+VOo2iuJR9EPlSXX5OkyfDyGcUO7hYcU6lx/2iC2nvSrBwf96ZOHi+kG27l0IDiIlzZBagw9u7jCTKTBn4fUlU/5yPHc9K6T0r0DKkM4wj1Sn5YJNNo5glTFdoVIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 08:51:35 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 08:51:35 +0000
Message-ID: <e15cba8a-8e3d-e804-ba8e-6feea374f1f9@intel.com>
Date: Thu, 15 Jun 2023 10:51:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net-next v3 0/3] optimize procedure of changing MAC
 address on interface
To: Simon Horman <simon.horman@corigine.com>
CC: <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<przemyslaw.kitszel@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<pmenzel@molgen.mpg.de>, <kuba@kernel.org>, <maciej.fijalkowski@intel.com>,
	<anthony.l.nguyen@intel.com>, <aleksander.lobakin@intel.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
 <ZIq+SMD6fdMU84Dg@corigine.com>
Content-Language: en-US
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <ZIq+SMD6fdMU84Dg@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::21) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|MN2PR11MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f9f78e-070c-4d36-7ec9-08db6d7db91b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUPWa8FkZjHNUUqtQTzrQW1iCsbPT8NL7xhJtodY78S1hyfrSQ3dzqOj2p1LcmQ83mli2sCncfYqBPCqAA/G2oMFHXeJbvb+XKaw5oQB/+ujlVSO/R/+kzn23xfz6Jn2jpZK8yEUvQvMRVOKKJzrJSBqpxfdGdWdxJ1R2iSpRoisQzNs4l3a5bYwqz8P7bsqOFBCqJD7KJ6rG+upw1cMwe1P8eso0ZXT9lMAkabfj2sLOGa4m7p3+ixqCyye+Jbxo5X2JI529FSwaHDxsMZ3SZorhFag5sLqUCwLZ4tGNyrYGPdoKN9XXAXWO0FT2hvvJhpsdl3Nvpffuf2RA7iGJPt/KlyMCIcdH438OivmD3+uWxViRep/hSpNq0FIFw1g4j/d20VxOYnOSxoC8pW1PtksL7T+8TwjHA2BaVx+nhmwiGP3116OUz9lFU9z0D2eXY2spRCsLg28qEq8QspX69wahCa9uhvRZRtLpkUkn/qc7c55pJ9H7Y7tjuxF5RGDdbATXVqE+UrR0rsXloKnGKG2Uweaf/BRze+155GCODnrIh94cnq7rajv18WuYkq6gCIuZvAsAwqwbs565foHkrIS86DCAAXILLgwKfOliGEGxbDho0anyN2At4VDxiIXplmhFo0faJyY797/jMOBaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199021)(5660300002)(82960400001)(38100700002)(2616005)(53546011)(6506007)(83380400001)(186003)(2906002)(4744005)(26005)(6512007)(478600001)(66556008)(6916009)(66946007)(66476007)(316002)(6666004)(8936002)(6486002)(8676002)(41300700001)(86362001)(31696002)(36756003)(4326008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzRqdHQreUtiMnVTdGFPNWFadTZsSXVYenozU3FlMjdUZXNubHQzR1VFMVAv?=
 =?utf-8?B?YlJ5UmRsTzdGVFBwZGR6Wlc2Umk3VE1CRHoyWUhFQW8weCswbHphaitYOXJ5?=
 =?utf-8?B?QkFxaDlmZk1Za0k5QUpSM1IvVlJHQzAySEwxK1dpN2doWktSWnp6TFJ3TzhU?=
 =?utf-8?B?Y1pPVW42VmNxUVhlSEw0WXZYQ0lINjhnd3M3NU1HbnRLb0FuZDdnNVU0bkRZ?=
 =?utf-8?B?RStiYW9tTnZkOWNKd01XSFMwU0NLRUtBeFRGbFgrdndUT1pXbzhOTlFjbktM?=
 =?utf-8?B?SXAydjJsY2VwNy9jZHBMOWJ0M2ZYTFQ5bU9aMnR2Y25qOUE5STEwY0dQcnox?=
 =?utf-8?B?eTd1VmxsZngrdkpIeXZzc3ZaSVJERE5tRVR4WmNTMzYzMmlXc1dhSXRHRmQr?=
 =?utf-8?B?dG03TFpyd2ZlY28raEtEZUgvZldwWjgwMXROZ1B4bXorRUJCUEcvc1pmd3Fi?=
 =?utf-8?B?aHVRdVBhRmg4dEErNURnREFPcXB4T2dEekVSdHhlZm5HcHFyL1lPUlpKb1hr?=
 =?utf-8?B?SHJGVUxka2V1TW9WSW5FN0lPQnFQdUJXL2lXdlVkMWU4N1B2T1Z5dUVWaEo2?=
 =?utf-8?B?N3dQcHBYR3N3K2JrV3RZc1YwU1c1SWpQMTNpTVNWN0puNVo0YTVzemJhdXJv?=
 =?utf-8?B?VUFEelEybkJDemc1OHdDK0h4NEQxTDdiV0g1bjFVS0RTOTJRR20xNDZqeHZk?=
 =?utf-8?B?TkVIeFg5UHR6OXRYb2U1ZDd5S1JuMXgyNWoxSis2ZjA1aW9qYU1IT3Q5S0s5?=
 =?utf-8?B?VGg4ZG5OOVowdkJ5NXdxMHZ2cUVOV0llS082R3grVmEyZlpaMjkvRUw3aTJU?=
 =?utf-8?B?MHcxcDNSalEyRXNyMGJLMnJWdmcxc1J0ejJCM3hYUUQ4d0FnVmpHVlVVMFRp?=
 =?utf-8?B?YWdhVWlKcGNUc1c0aXRBVHc4T0FqVy9XN2JQenVIZkVHbWMva09ENjJPcjZR?=
 =?utf-8?B?YmQ5ekQvZkthTnZtM0lNZ0g3UkRmMFVuNXMwN0ExMzNnbEtkOVdBUENuczVj?=
 =?utf-8?B?MkJobHpDdzF6U2pWTVpkTnVzQnR4SktCN0dCdXp4bWd5ZDRJMUtERUllakZY?=
 =?utf-8?B?SGkwL3Z0Q3VnUGFacWdtbDNHSVExL1RuTTNjVTIyZlRTWTdzQTc0REJpY09l?=
 =?utf-8?B?QW9XdU5tL2I2enJSS0ZVYWlZZjBJWjZPMkthc0JMcldkOXN0WjVhUnZmeWRP?=
 =?utf-8?B?TmRxajRQay9XbFhBaEY1clBmNDZ6WjRZMkJ2Y3V1NXBwYllucUppQVNoUDg2?=
 =?utf-8?B?RGZiL25USlRpNjlLUFYvWTNBanVhdUUxR0RXcGEzaGxDd2cwUlc4Uk91dTRZ?=
 =?utf-8?B?N3cyb1U0N3FDTFJCUnErWkxMS2RUSlNOTTV6Y3dGbWdIQzFMOGRmaVB1Vk1N?=
 =?utf-8?B?aU16cGdZR0pPTUp5M3dYaFBMNlRweGo0UURUeUhWRm9vekswU0VQM2Y1TFZk?=
 =?utf-8?B?THVnQUxjdHRZdjgrZ3FSdXhnV0hZeGhkYzh1cXJCbTBPcWpwR0s0RGhzM3Ey?=
 =?utf-8?B?d3ZXUi9DUFdvRENVMU9jaHM2dDZhTnJSWHFEREV2K0EwRHFDOGVlNmVSQmxK?=
 =?utf-8?B?c1Y4YnVOdUEwMzhrL043bE5WZlVQY0JSN1Erb0swcFN0VEhMQmZnU04xbTN3?=
 =?utf-8?B?djdoUHpOYm95alZiVnczVFMxRmNNNmtzRXFqcWpKK3hrM3ErRms1dG5HV3ox?=
 =?utf-8?B?TmVqaHQzTlhxbTBQWCt3YTlUb2pwdVY0Y2QxWEJFVDU5THByYmhWWWFCdkgw?=
 =?utf-8?B?Wko1cVFDYjBiUy9GeGJhMXFIVkdML0NPaDRrMTU5ajJKRjEvNnhFVnA0dXlx?=
 =?utf-8?B?QmkvaEU0My83ZmdDbXdydUdJcGl0R0hYU1d6Y1o4N0o4ZUZJWDJuSGs0b3BC?=
 =?utf-8?B?SmRTNGx0SUtCWkFyMk0yVXlKUzBYOG9nb2dXY1JTdnNYM2JQODZwbmEyejFT?=
 =?utf-8?B?YUdlSXBteDdOOW5jNWhCNUlxOXlmMEpQUDBJV29BTHFEc1RhU3NZdE9TMDIr?=
 =?utf-8?B?KytFaWM1YlBkUGk3aG5Xcm1HbTcwRStWUm1oOW1qVnZNeUczOXVhZnI4aUZS?=
 =?utf-8?B?Wi9aM3J6K1dkTmdENE4xSGc3Y3ArcDRpUGNPK21sazl5QWJoNnhqbGdqbE9N?=
 =?utf-8?B?QmVwZlZBNk5aTDNiSmp3MVdPNnBQZ1Jna3c2aENqMnYxc05mOG45V0NvNFcx?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f9f78e-070c-4d36-7ec9-08db6d7db91b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 08:51:34.9595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: veiAAj0mqfFEQFGjv95hMqOntIcmnz7U5BF7EIffrd+whUn7qhjpbxLHBiVYaitV83z99Li61RmRLTxaWUNRuYrsCTi2VmJi4y0D2B4sIHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15.06.2023 09:31, Simon Horman wrote:
> On Wed, Jun 14, 2023 at 04:52:59PM +0200, Piotr Gardocki wrote:
>> The first patch adds an if statement in core to skip early when
>> the MAC address is not being changes.
>> The remaining patches remove such checks from Intel drivers
>> as they're redundant at this point.
> 
> Hi Pitor,
> 
> I am wondering if you audited other drivers to see if they
> could also be updated in a similar way to the Intel changes
> in this patch-set.

Hi Simon,

We already discussed this in "[PATCH net-next v2 3/3]". Other drivers
should be audited at one point, but there are hundreds of ndo_set_mac_address
callbacks in kernel and I don't have resources to review all of them. I just
fixed Intel drivers for now.
When this patch set is applied someone else can work on that.

