Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E63D1D4C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 07:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhGVElz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 00:41:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:48546 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhGVEly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 00:41:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="297130642"
X-IronPort-AV: E=Sophos;i="5.84,260,1620716400"; 
   d="scan'208";a="297130642"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 22:22:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,260,1620716400"; 
   d="scan'208";a="577097177"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jul 2021 22:22:24 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 21 Jul 2021 22:22:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 21 Jul 2021 22:22:23 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 21 Jul 2021 22:22:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvEw2zrYP4GtnIyEenbH3yV0bmEvE33E2+8J7hh67ReAc0OvU29X/3j5XplW3y4BSwujBFYL4v0LLHqy4AaZd+Q37Jcj0iTD1s5cRqrl4yjueMrZl0uuqqAzEytowYh5uPPk5syZdwGUZ08Rt5ilkV2LK1UgirESP7VYcmK+55xi5SmAFUT8QgaGCok/EDkfvIsFpyNwaQeatYCXy4NEon2PTcn94HxeK8Z7oo2bZ1G9rXwMvOMxWTPW6Py7VGDy8GgC2J+KmyE1KNlYcxbA0XmKsIECbn2ajOWOCn5t+z4fEGHiPQeEJonwHB21Yr9ecSJRjiZ3KGvdsjrjGHq2Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngJDWB7HxdHsuJqPWtbuqPfXSJWOTg8CWtGBog5lBPg=;
 b=QMrSV8Db3kP7Mwk+KA3lcz0CtIJk0bf4eDMlA/acKtTijOKL3h5lml6gctSb6Ia11icwtIrm4oU4Y1hGyiHMe1v7AX5uE4k4/SS8wAjy1yt+xh0fQOo85kNtUsQBxDtrDEPBiYVrQn+Q2ZSnkBHFxghQplgAvhEFEEuBI5HkVh5baegPxoDGuOLMe98njq6UStzNSpRIcv+87RcgSD6t8snefHtJZ8QAp83R6nCvuKlmukSxgtwpbQ3LCIy5rIo2bwN9YwKBP61UW37jWy08bSJdwMyb9KiPQybZ9hTJBW3tSn/GWjP8ax4wBtwE3IGtDsmckfPsVG+T9bzASekJAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngJDWB7HxdHsuJqPWtbuqPfXSJWOTg8CWtGBog5lBPg=;
 b=kAXBPGW/TcS9HyxR3KfZ/Wv3QhN968XH1Q9YjKbTisDkyuOSKejM8zIqMTYKfExhRAEnAaPxUBQELeiFW899k/eNYZCE81ZjgN/fdl4TaY/JGyv+efVqw3WKJNr2izYkeE4lwuB+7igsn1EJopP0tI3a30nn4Dsi2563eNOFBlo=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR1101MB2334.namprd11.prod.outlook.com (2603:10b6:300:72::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 05:22:22 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::b856:1bc7:d077:6e74%4]) with mapi id 15.20.4352.025; Thu, 22 Jul 2021
 05:22:22 +0000
Subject: Re: [PATCH net-next 09/12] igc: Remove _I_PHY_ID checking
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <vitaly.lifshits@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
 <20210720232101.3087589-10-anthony.l.nguyen@intel.com>
 <YPg0PRYHe74+TucS@lunn.ch> <6cb7fbe9-35e2-8fb1-11fa-cbd6ce01bab2@intel.com>
 <YPh7KTyNQScVjp13@lunn.ch>
From:   Sasha Neftin <sasha.neftin@intel.com>
Message-ID: <2866eff1-cf02-9d07-e424-23e7ab96a99a@intel.com>
Date:   Thu, 22 Jul 2021 08:22:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
In-Reply-To: <YPh7KTyNQScVjp13@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0086.eurprd03.prod.outlook.com
 (2603:10a6:208:69::27) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.168] (84.108.64.141) by AM0PR03CA0086.eurprd03.prod.outlook.com (2603:10a6:208:69::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 05:22:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e133c7cd-be38-4b5c-ee70-08d94cd0af2f
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2334:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2334E4DE2A9EB04C60893BA297E49@MWHPR1101MB2334.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uigc5RvOrwDptp7ZTyWwHc8Ls1WIMcsnl/09GlBZUfvgdRG8W5gQ9whIftqG6KeFZ0GLAAqo2CQ8sB9/zTxz7snnhbq7Q+uUaD6ztFvUQQq9Du9/MIzqGXY8UZIenztOopj3qsBEah1Zolhb2R4zFM8k12Xfg9BWmeQvAm9+nU9e4GTvQS/qb3jEKDdVAy1PClbg9iUmMc9mypqNN02QhfHw4MgqbjQPS+5Z9x7BK7JHu6Yqs8bUGK/K6OcsyskJ9R3i9dnrBgUwtCztOiUUoxm9zyeJ5DrHLG+N+3hmYGMjOWzXJlYC9cIKQ9xgufd/+AakqQasYOECbJmn28D5Ug8v9EM1gjl4A59eZGCProWZmeYM/qe477/c73gs5J3WlCfsmDLZw1gwblKXRbeDm7ak4B5hxcq2Nk850XMgxf8ahH8UqquYkvjWhT7DPWrjoJC6xjv7PiNcMV1s/tY+6xxBEKPJT6gjFnp01w6/iMymRW+uzT6C/i7Ag9eOPlbqDDz9jkPe5txNK47J73aMXS+kxnp39ggy7v/j7VN+5LTjdb6GTJcxuMrXicWjM1ygrSn4iJ2xz+tfth1SFNA2pKa7+XzC3wQZLW5w0EKm9ltkdP8oQjrnV7jTBPB1NYVUscnwgJGNGpBpY2DybJvPTJLq14FZiE4zDWeJmXZnj7nkCBkOdVej44TU6G4lpegEHoA9aIMW0ZK7KsI0vlQlnAslE655RX6EAASzPHUkzGEyb9AzFWRcmzHHAyiiAMeC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(6666004)(31686004)(8936002)(54906003)(38100700002)(478600001)(6916009)(8676002)(44832011)(2906002)(4326008)(16576012)(86362001)(316002)(5660300002)(26005)(36756003)(83380400001)(66476007)(186003)(956004)(66556008)(31696002)(6486002)(66946007)(2616005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3cvQWhXV1ZiQzQvZ1JpN0t6UHVoSDk3RFk0ZUxpQkVqbFFNQ0ZZaERyR2ZU?=
 =?utf-8?B?ZjRWNTFFNGlzSGNTRkl2OEJiVCtzM0YxRHFGajJMUTZaNUZCbFA3SDZRWDBy?=
 =?utf-8?B?U1c4UFQ5c1hoV0dVL3FGRjI3YllKY1M3ZVFMVDVURko5REhqTW0vOUZaRzRq?=
 =?utf-8?B?a2VWVU5ha3NZeGRYVXh2YzlnalRYS2J5UHNnQSs4bFNGdWhld29zdkRHc3Jt?=
 =?utf-8?B?YU1QM3NpMUdaRjBMY25mTFA4NWNuQU1ERWJLNXBESk80T2hLVFdtaytyKzJF?=
 =?utf-8?B?eGFUOWR4TUFrTEZRM041dXJhdk93YStTQWsxcXZxeElKdlN2MFo3VVdwNDdq?=
 =?utf-8?B?L1libmlJNHhYZ1N3UEpZWlh4dkpIT0M0b2dncUFSQmEyTzYvZ1JYT3NsckJK?=
 =?utf-8?B?UkFOQlZmT1BKNXNqTEJ2UEszNS9BSzNhMWN4d2xEWUpiM1ZWSE1tOVJ5NTg3?=
 =?utf-8?B?Y2dFdGlIckJrRDNxTyttUlpnT1lHWXlRK0RjNnA2bU51Z3RXMkpidGpsVVcw?=
 =?utf-8?B?dEJzRHlLM3dNWHFEV0hmdUhVbkMzM1RPSHI5NWhveGRSdHRhczYzeUZIOEEy?=
 =?utf-8?B?djhKalc3ZDV1U2xBV3RJNXpKNGthdFgxWEorYTRkVmM4eXdhdXRxWFh4RW9W?=
 =?utf-8?B?T0k5elhCa2RwR0RGZk9LYXNGazBhR1Q5bXFlS3BTOFdPMldMZmRTVk1hTDhj?=
 =?utf-8?B?SkFMOFdMSm9JSUd6ZThrK2VRbXVzSkpSRE1PQnU5eVZ6elE3bTNvYXdtbHVU?=
 =?utf-8?B?U1l3am10M0ExeWY3cmVmUzVIeEI0V2tpTndhQzViWXRPSFpxZkt3bk4yWVIv?=
 =?utf-8?B?eFpTeDRReThucWVyT1dLdmJzS1ozQjdaa2xLandaOWRMV2JWNGY5U2YvWU5j?=
 =?utf-8?B?NGdSVG5HNXU3UDZ4Y1ZYaVNGc2hMWllCUklyN1JPcG9hNW5OYWtmNGVqNGdB?=
 =?utf-8?B?ZSt2dmNRYkZ3RFAvc1o1anBmQVc2UC9MWTZsRFg3SnNiMytDMjVyUlVnajZ3?=
 =?utf-8?B?ekVWN0tnQW9wb3M2UVEreUdMSFFmQkJuL2JRSjJCRFFhWkpLUFpvN1ZUUDZz?=
 =?utf-8?B?Z1NtZm9kMEhEQTZnL3Npa3ZnU1o4L0oyMHVKRS9lVzM4SVJwT0wyL2QwSUJv?=
 =?utf-8?B?RFptMDdQbXE3MHprbkxsR0ZHMWw3L29hdzltcng3Qkl3azJjZ0VaSk4ycFA5?=
 =?utf-8?B?eHZZUnh3czdHaXVOMzI2ekkzMmlCcG55dkxkczNXVEJ2ckd6MTIreGNJUTVL?=
 =?utf-8?B?S2JtZTVMdXpHU1hwR3RqYkJ5OWFHaXY4MVFqa2dYK2JaempqOVRhVFVoQ1pZ?=
 =?utf-8?B?dFNYZ28rYlVScHFGMTI5cm5Bb3Raeld5cndOZTZRR1NtbWxpc2wvajRJVXhM?=
 =?utf-8?B?T2dlT3NBVyt1QlA3d3pvalhMaFFFQnY0NTJxTHE1end0bm9DZ1EyVU1GZGd6?=
 =?utf-8?B?VGI2cHZ1S2FUOENjMm1BYmhYdGFnSE5EZm1TdnJMQTA2cFVQSFVJZVlvZW5K?=
 =?utf-8?B?SHNLeThXQkgveDlKdHNGTE5pMkMzTmM1Y05Kc3VBemNXQ1R3a3I4RTlvOGFy?=
 =?utf-8?B?d0tDQnFWUjR0RHFSS241SlA2MUZBZXhKOS9QU2ZnQ1NsVHFBbUZkZWUzWnpY?=
 =?utf-8?B?TFZUaFoxUUpkRXpiL1BGQ3FFZ3RNQjBNblg0MzNSSnIyZXhDUHNod0ExMVdP?=
 =?utf-8?B?Z2M3MWlaN1VYSnVsUC96MDh0QnNoNzRHTEtBTlJLS0ZiRkFFWDRyS1Y5cThR?=
 =?utf-8?Q?80Mkw9rUnKNurqgGPYCngS2atQHbh3oYDNb82V7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e133c7cd-be38-4b5c-ee70-08d94cd0af2f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 05:22:22.8287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PM0YmHtJYOA7Ti7ErOYUGkSQOsy2jOwLNTksPNNu1ttrt72WCGal3ZkvklrzBNRbmqVXIA1hWTdMMa2woEXtPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2334
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/2021 22:53, Andrew Lunn wrote:
> On Wed, Jul 21, 2021 at 09:02:13PM +0300, Sasha Neftin wrote:
>> On 7/21/2021 17:50, Andrew Lunn wrote:
>>> On Tue, Jul 20, 2021 at 04:20:58PM -0700, Tony Nguyen wrote:
>>>> From: Sasha Neftin <sasha.neftin@intel.com>
>>>>
>>>> i225 devices have only one PHY vendor. There is no point checking
>>>> _I_PHY_ID during the link establishment and auto-negotiation process.
>>>> This patch comes to clean up these pointless checkings.
>>>
>>> I don't know this hardware....
>>>
>>> Is the PHY integrated into the MAC? Or is it external?
>> i225 controller offers a fully-integrated Media Access Control
>> (MAC) and Physical Layer (PHY) port.
>> Both components (MAC and PHY) supports 2.5G
> 
> Hi Sasha
> 
> Thanks for the info. Then this change make sense. But the commit
> message could of been better. It is not really about there being one
> PHY vendor, it is simply impossible for the PHY to be anything else,
> so there is no need to check.
We will clarify it in the commit message.
> 
> 	Andrew
> 
Sasha Neftin
