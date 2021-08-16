Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26723EDD54
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 20:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhHPSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 14:50:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:52328 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230445AbhHPStj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 14:49:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="276945794"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="276945794"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 11:49:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="509871736"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 16 Aug 2021 11:49:03 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 11:49:02 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 11:49:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 11:49:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 11:49:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISu8QDto4gUrQti2dukDKgEGglCwDEz5nncrapWx3MuVCyAX4Vg9x6dThE2ZDAkRQf76l+k6dlvWdYqlHnqmXqj2ZPTyjOFfGS2S+xyVw+Pi8TmJBlyOFfP6nfSJ8DnCxTeUNTf9J6eWCmisrfhF7Ce0zM2JABtIe8JSQxVcy84vFiS3B3CvYs9d/+vJYBsr9Me+xbM0Ts2d9yNUGN5nn9TmXyFLhwLtFqfMeqhPHYHVteQxiM2CeSG7zh7Ylk7/ijWKz3GYkvWnZOQYQ2w8YutRTONkFCa+Zm1RY6MM5PaCongjL0oSbmzefYFBF8khZgnEV9/wa9s3hkWvSY00uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oP8MTGrJtJ3RaJF1l4MZbOmvnoAovmBWGLftYCqwAGo=;
 b=BfV9m7ZTzWCiTSmLFlsl2Yqls8zwSH0s4SQPpQ1UFtb8CtnML5Vq1sjil3UZ1qVMDRc7CkdnJx/ZnuhOWb/Mym1jK3vd7X1xkPoxG/dwmWrWeBl8EfCzg/p3DmlXmfX85GIpAtLyHb0gW1uh1uccUarp8GDyXfzIYpL8XREkw0vMPYNb3o/arqKEnOEyumV/UTUuVxaQQZfo+02Pgrg7nAU7JbSPxiWgFmcR6RlTJOnGl9mc2oQbX+LQnAbwDWmOcRGeyxozulVaBdvT9eYrMEe+ifw1JOZg4uzXeys2+SPlHes2hbXtUXIiXG1fMKtNmfBlAiea8FIoEAlws80JBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oP8MTGrJtJ3RaJF1l4MZbOmvnoAovmBWGLftYCqwAGo=;
 b=eG3JJznlRPRMlws9f9/EIGOwPrhVkrbqkNG3kpT8wRiYq4gmnekA1tt/s47MNKmMtwuGbUPjdGMTyaoSYUmGFXgbOkAZpYSKyyyuS2yWABGshMEOC1QcIHQz/JMUviS31lYdhnK2f46H+DgTpyk/ZFbMHdGitH9q8DPhVibIC4E=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR1101MB2318.namprd11.prod.outlook.com (2603:10b6:301:4e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Mon, 16 Aug
 2021 18:49:00 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::45e:286f:64a1:1710]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::45e:286f:64a1:1710%9]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 18:49:00 +0000
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        Aleksander Loktionov <aleksandr.loktionov@intel.com>
References: <20210812092513.3e5ed199@hermes.local>
 <20210816081456.46d2730c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [Bug 213943] New: Poor network speed with 10G NIC with kernel
 5.13 (Intel X710-T2L)
Message-ID: <9507c745-2ccc-1ab3-77c7-e83b309181f6@intel.com>
Date:   Mon, 16 Aug 2021 11:48:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210816081456.46d2730c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: CO2PR04CA0191.namprd04.prod.outlook.com
 (2603:10b6:104:5::21) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.214] (50.39.107.76) by CO2PR04CA0191.namprd04.prod.outlook.com (2603:10b6:104:5::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Mon, 16 Aug 2021 18:49:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdda9816-2d7a-40f9-36f8-08d960e682c9
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB231880DDF08C34B241F3D6AE97FD9@MWHPR1101MB2318.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T36mbYdivz/aR7exN267Q2aDakLgXVUjWc7iRfrhUSc6rn3hAfivPsr7O6ASWK7i5bNJxIbMELDP9giudsPkeV59jSNE5oF3B52PwA26BcNzAwRYAW4c6x6knSGjKoYyKmO98t3Bf4xokMoLxvdDtr2PxD3hpY+sQAT97iuWDDsGbhkphFs0BmzGKY0G2naflB4b+t2UWEnx0rFxl+JHLFE6etHMHitc7+MSN7jT2kNvqPfbSgaI2xdfzdS0rGE7zZdrzU6KNd+/qNGTl4xFPNxxIYKKzhU52lsPKs2tM+lkH0yzWHSSN6Q06E3zY6gCGmc54hWf8wXzgrAhEBHy07PdPzcvd/18eLaXeYEoip5IX6TrKeK4OdxgazLfk5D/5cuMtAjfQU/e9HH7IJlZuaE7dETE56sZIsy7XxwG3Hq++5Q9nWONC2ru5e5Dr0hCmRiqnR13t2d4Qd4Ulgak7ovN/o4k45lJ3z7sRWdilorE6ajpsWc6mmI37oRtTxnd6Q/sBxEJzJmgEVN1eCyNraZxGtRjfarHSzc6reVKy7FV8nJn9M/nTRfQN1buBIx2+GwPinoyXTPsYUgptlKFGLSOKsuJspG0Tu3l9m7qO3iV0LRJ6PdiYsOVG2A4ePe05GAMvuSlhNkvOyQ+KfY90xa6AYjk+wYCf0AzYuxEy29wQwKiNf3QlWfVQ5VhK8R3Y/cSsRIxxUdqLRvgkN4vk/1huCpzUzHZ5z0w1THsSOy9rJRDGphCx9KMNHTMcJWR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(31696002)(86362001)(8676002)(8936002)(44832011)(6486002)(316002)(2906002)(16576012)(54906003)(38100700002)(107886003)(4326008)(26005)(4744005)(66946007)(6916009)(2616005)(66476007)(66556008)(5660300002)(186003)(53546011)(31686004)(956004)(36756003)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bll0aVRiTld1REdxeVdZdkNnV0FTSDBHaGpacGFlZkp0RmJKWHc1MUV0Y0Qz?=
 =?utf-8?B?MFNCVWpEdGFpSHBTNnpsZFNNdHpQLzd4Vm5EVHdBNlNBOXRaT2ZTL1VuRUQx?=
 =?utf-8?B?TDg2ZjBCN0NBcEpLbGkxZk0ybWZWbml5a3BOaDY3Y1MrYWhrekxaeXlYcTBv?=
 =?utf-8?B?N2JQVnNETXhrQ3dielA1RDdIZ3RuNFVuMlFycW1pWmFwemlJZUdiVGVHSG9C?=
 =?utf-8?B?Tll4QlBrd3IvbEJwZ3NFWnF4ZFExZ3ppbFFuWHNLbWxpK0RBcUNtZzdMaUxn?=
 =?utf-8?B?UERPYmF1dGZlUlNvcERSTnNWOXdrZjdRWlpnUjAwMUJXc1dmUEJGWUFBTXZr?=
 =?utf-8?B?Um9NZlhDWmtNaWpLZzJSQ2xra25hZ0lVd0MyY1NRTEZ3ekFjbGlOdVhrcEFr?=
 =?utf-8?B?MXlrL2REYjJCcS9nOXVTUXNLVk41TkJYUTRMeWx1c3p5NGhoVTUwWjdvWTRi?=
 =?utf-8?B?NzBtUzN5eXVyVzJYcDNyMkhkTzdsYXNkYVNQS2lvWEFPMkF5WFFlbmJLMDRj?=
 =?utf-8?B?ejlCUThuZUJTOXhGazh3ait5eDB4bmVJYmZrdmpOa1FwRFlSVlBTOG9rZ3Zz?=
 =?utf-8?B?VVBtRkRaWFJtZTNvZGFvYzRzZUkzVFl3R0ZQeU00VlN6MlFFUlQ2bGEzZEti?=
 =?utf-8?B?TWpObGtnblArUVhWLzJwZmlKMTJudWo0WkRXbFE5MzFGVGZYR2NWbzlDRk55?=
 =?utf-8?B?L3FlZ3RodUJZTzA1OHJQbDZRZGNUUlhtNXlOdUxkdmZFQ3ExanRHSUxXaXl1?=
 =?utf-8?B?WmJwcEVwMzN0RjVrVkUwTG9May9NV2pzQkcxNUxsdmtXdndHcFZTMWxmakZT?=
 =?utf-8?B?OVZrL2hHS3NXb2hQbzBQQ0Z0SkgreGdmQk5xRmZ3QXFwYmVxaUFEb3RWU3NT?=
 =?utf-8?B?d3lNUS9OUkJST2REMU12YmdieTZSYk1kRlN6a1JlbzFSWHZ6U2tja1JpZ0FV?=
 =?utf-8?B?bzl0U0lqN0VONUJFTnlLVUhsZStIUEd6MlpRS01KaHIwOElvdG5QWWNaeGh2?=
 =?utf-8?B?VEJqR20xM243MFFHR0hUOFE5VGxyTUQ4MUo4ajgwT2JENG1XS0FjcXdmd3lB?=
 =?utf-8?B?ZlFmZ2o2NEw0YVNuMWZkQk9GNVdvWmFPWE5kVDdTUXQ5L3JrY3BrTmRPODFk?=
 =?utf-8?B?RlZ5OFFzdEpzN1NFUmthaVlEVS9xQUJzRWZ3TWVMSjh5encwTkVJcUw0dU9m?=
 =?utf-8?B?WkdWWlAyQWY4N0p2blFsWVdwWlgzS2hiTjFmeFBHQ3lsNXBjc0RNc3VUeVI1?=
 =?utf-8?B?WDVibGlzQkluLzZwQk1hQm14aGdIWUdtNC9BYUtseWFtL3pvblFmcGVYRHFh?=
 =?utf-8?B?MENONGJudlh1cE1qR1ZTZTQ0cGV4T0RzSjExZENnVW9tMGUyK21qS2o4UXdn?=
 =?utf-8?B?RlNheUxvNUhpL0VKKzlGUklCaG1MWTQ3L1pETU5VMzhnTkl0cnhRL054VzBX?=
 =?utf-8?B?WDJrUHJPM0pFYlNjallsYVlPeWM1Vkw5SDlhSkVwcFliV3JsQjZBT3lTY1pY?=
 =?utf-8?B?WXllSldpSmd5eTlIa1J2QkJBYUs2ZnZMcjV1TS92Y09OQUZDdXpJUURON09I?=
 =?utf-8?B?L3pDb1QwS3VTWVh0bXUxdWhQOFUySnZnd2w0bUVyYUZUdmlOTytjTUw3TWQ1?=
 =?utf-8?B?aDRnczBQUUtHaUZ6azFYZFFYUE9kWDJhK2xQUHJWbzRLUWJITzJERXRDdVhx?=
 =?utf-8?B?d1JtSm9CVkdRS2lhQkVFNXlMaHFEcFhrRUdsOXpVRTA3WW1JZTlwTmlVU1dq?=
 =?utf-8?Q?XJZudbA/aYOkn5jDnn5jjpgxZ6yj5pUcVy+5WiP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdda9816-2d7a-40f9-36f8-08d960e682c9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 18:49:00.4487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHg7kFFFX7DsEp5+V6X+wYhjlYZQipnhOUzG5S6fwX42jTIrjoozd7fxAhIEwq/lqJRxWijqiHfWPb5RLMsg4hJU6tDLgWjOmnQ7oIhTO2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2318
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/2021 8:14 AM, Jakub Kicinski wrote:
> The problem still appear in 5.13.7 (last one at the moment).
> Jesse, are you aware of anything that could cause this?

Hey! Thanks for copying me on this report. I've added myself to the CC
and I'll file an internal bug to get attention to the issue.

FWIW, I haven't heard anything about a known issue like this, nor has
the lead (Aleksander Loktionov) of i40e. So at this point we just need
to investigate.

I've also asked the reporter for some extra info in the Bugzilla.


Thanks!

Jesse



