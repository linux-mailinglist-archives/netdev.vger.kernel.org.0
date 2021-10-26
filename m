Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1580943AE50
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 10:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhJZIum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 04:50:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:50238 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhJZIuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 04:50:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="253392732"
X-IronPort-AV: E=Sophos;i="5.87,182,1631602800"; 
   d="scan'208";a="253392732"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 01:48:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,182,1631602800"; 
   d="scan'208";a="497225548"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 26 Oct 2021 01:48:08 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 26 Oct 2021 01:48:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 26 Oct 2021 01:48:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 26 Oct 2021 01:48:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lS4BYE/jy3mkpcvtzxF+SbJBDwddWDqxUINM0eD26HCBYvB84L18smAGV8cC7IwpV+HQeduphUoezLLTuOMjoNOGcqhLmRlY1ABFkjb91/UwWPEFufwAZgrcXhn66hvZtJum6ANeN/jVI5GHdEXp8f9Lx0R5jzZJHYVE7xBwNAPttT2TK7erZ1sLEmIchcFn+MKofg4Hk0YxZYeOcpFJ2SVFfiN3iacEN9oaBFO+jFRuNE6BRMY6ixN3BbtYvXm1FB3udf9OUK/ZT19IsSATiJgzeL870fJTwMEUpnyryyU+YwXQmxYjq3qyEzZLkJHXTqUYeDBH+biYxjFym/0w7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NToebsJV4DYt8OhceCCvm/uPsIKD/tASlVlhBBigwAk=;
 b=aDADaI09YSJuv3qwxJiqdZGdURmb7hMmEJXqQYv5CMxIFv6QIFVjmbLhxqXlh5kCwaW1mFsTsu6ytefEDO6M3nQrLr1PRcyiihIaQ/qWqBFVpahzGESp7yYdl/MGH5/+zzbBev2XAExYjPHt35GQq4+5ZtICrsHPRV6ZLuW4aMUALbdRk6hOmRaqW/ASaKkhA/vUV6WEU2djJm+Z69kQhymPyPDWeIm40vwhWSrC3RJx1Rnw9Xh/86ypCCxTYvoM2QHYh+94f8+FAtBtUyvH9lEPWL+vBjYE5qLsTc8yGWWkqpLtfpLRtE9xCCRpxIJpwpJYqqSmlndSOj5ZmPXl3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NToebsJV4DYt8OhceCCvm/uPsIKD/tASlVlhBBigwAk=;
 b=OnnKg7BFfG2F5GV4eGsarp8Qjf4lLAKKjdYsl32UEBAh6D7j917iksegPVYVy/oQwJJp9r+uAh1w0BM+IJdkoornSsskVnhcAZI77IRHwAunTEeaXwDKqmEztkO3wr+1PID+xBt9gZ6m61ixm4I82D/wf28wPxeioUQ/bOdqkBY=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MWHPR11MB1565.namprd11.prod.outlook.com (2603:10b6:301:c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 08:48:04 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 08:48:04 +0000
Message-ID: <04ed8307-ab1f-59d6-4454-c759ce4a453b@intel.com>
Date:   Tue, 26 Oct 2021 11:47:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.0
Subject: Re: [PATCH v2] e1000e: Add a delay to let ME unconfigure s0ix when
 DPG_EXIT_DONE is already flagged
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
References: <20211026065112.1366205-1-kai.heng.feng@canonical.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
In-Reply-To: <20211026065112.1366205-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0013.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::25) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
Received: from [10.185.169.53] (134.191.232.39) by AM6PR08CA0013.eurprd08.prod.outlook.com (2603:10a6:20b:b2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 08:48:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abc2f773-d397-4e70-65b1-08d9985d52db
X-MS-TrafficTypeDiagnostic: MWHPR11MB1565:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MWHPR11MB15659F1C7F67074A640C294D97849@MWHPR11MB1565.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OhqED52gxuJ+8tOzRD9wTYHEZdS9IBc6Ba3ThktQgjT3J3xNpFMSQLqIXIM6LPcE7WJoNHQxaZZRnbI6lNKW8ZMiaJakHVMAhbmka30MhbTorpV69+6H8ZBD22eyp34A43vEe3/5T3SXsv2BUB4sx41Y2TIjR0rQTbqruzf3ST4SseQ4XkRQyLSDhK0ndElqCxwG8GlupwWEFl9Ifdlf2VXQIqS3u+C+IKaFuwEgJfeGHt7aYoFZtcAECYWevQ/OW8H86a19xE+OTjeK1cIGWbEeO2RA8ATv15GBPxCdZ6mlRXQue3tQGYuYklFp2DN9kJz2D1+/w8bOjo8KQfyikDX9Jf2Mi78Oj4cCjvMChgqpOcbkZMitf1FTnBUeZk3vLuiSkOit8am+jop9CCpZ8CJpdopWDy5eX+qXcPo2/Y5ImWgdl5z7iomQC0owBfxsmaOTCbH6kJWE0fY9JfXklTCz2+dq5jvYrKPLz6mhZkj2TAVDMTKcOQXoKJq8+ijyLyka+JI0x4e+cftjXTqDt+Vx+0G0dfTY6iM5CuNUJ7sVMo4h50Jo7gCjZMeRZR/VS9bU4Aa/srqXdJTSarphY5FEYkgbDr5g100XBFQuCNwhlU7BaSRED5Q6dHTHzPeU3ACZOUGJue6ozMg5RjmGBIU51E29lXQ0CpcYMIE5f7DMsme+vuwOQV58PdwYbDx/aJR9yCE73GOU51vy9nHxXGO6qtLoFeZtZM75PmL7m1R8dVDwoTPTKX0Dcht6jbO9PsEzz3ihJTPJMGJMGIERnti5hLQIGAelXUuitmuyrJZG1NI5RUNdyU5XyvDVWmZOy02VQ1iw93boGZgbMcFlBDfJsK92jaUxcvalkiByVGs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(66946007)(508600001)(956004)(38100700002)(8676002)(6486002)(66556008)(66476007)(2616005)(5660300002)(2906002)(83380400001)(6666004)(86362001)(44832011)(8936002)(82960400001)(31696002)(316002)(31686004)(54906003)(53546011)(4326008)(966005)(16576012)(6636002)(186003)(26005)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXpvcHdTQ2tybW1iMTU4M1lNMUcvK0JCK3NUZTdWTzJkZUVGRGVRSjF3NHhi?=
 =?utf-8?B?Qzg2OFN1ekl0NHJVc1pwOVo4c0RrMXg5RXVtWUFna24xQkdzZlhkWnFieE5v?=
 =?utf-8?B?cU9YUGRoNWhKU3I5UjJFMkpCb0grZVlucDdjQjlOKzNRcXdUcThuSkMxbjJo?=
 =?utf-8?B?Wk1FT3d3RzIwSmk5WGkvalkrZ2VrckZLT0lPYXVJR1dZdnh2RzVOOUVPeW1L?=
 =?utf-8?B?eXZHalpZY2oveHhBWGhRUjc1UUNRWW54VzRHaVNaZ3VONjBvWWk3NU5HOW9v?=
 =?utf-8?B?NllkZ2pvMnNMeFBweGN1elZDZlBWYXdZMXJtVXMwYWl2WmwzVEtWMWUzcW0x?=
 =?utf-8?B?Q0VERnNkaCtHRVB0UnhXQ2xicUdHY29xZk9DSUlwb2FGVzc5VGVGNzcxcVAv?=
 =?utf-8?B?U2VvamQ3c0Z3amJ0SnlmK1ZSRnJoaFE0RXplNnZJWmMrbVl4Y2ZNTWtoL3RD?=
 =?utf-8?B?UEN2akwzMDFTRkczMHd3ckRMU25ISm1vRlh0MEFtQm1sRFJvZnZFWWdZZEtj?=
 =?utf-8?B?bnJkTmVFaUhBVERSUXdxcEQ1N0NQNWp2QmJDU0NxMDNLUVhNSzJaNkFuUnQx?=
 =?utf-8?B?UGUvc1hDeUlGb3VIYUlxQmtQOXBaWTNkRzVFTmVJNlM2MTIxRUJvUXlxVzIx?=
 =?utf-8?B?akxnanV3TEpiZU5LeWQxeTJIZEYwdkZYTTgwM1M0VlljampGUGZabTZkbEhP?=
 =?utf-8?B?aU9JVngxQVBQS3ZJSVBLRGUvU2d6M2FLaTRia0trclFxRUxvZVBZZ0FZRk1X?=
 =?utf-8?B?OW1iN3hLdjIzWWpvMWJYWlVJQkFGN2drY3RTelF6bHdqQ05yY1M1UjY1Ympy?=
 =?utf-8?B?cHFxRTBvREt5TUppaytndTRvdGdMeTRiUDc2UjVRRjZYTkpXdExQRS96N3NJ?=
 =?utf-8?B?NnBLYkgxSDdpczhFVTlaVHNDajl1eHNHU1VsTDJ6MEhscmlNc25DZEJVYU4w?=
 =?utf-8?B?N21EMUErMWtYbGoxdjNHOU5LdGR1UU9vWVFvM0pEK3hBSW01OFpBWDRoQ05P?=
 =?utf-8?B?b1JmaEdkQ0wwNW9NMy9CWG5Hdm9hdWNQcis5Y0dPMkhvU3Iyc0dpd2hUeHNH?=
 =?utf-8?B?TUdHaWpNcCt1OEF6WTM2Rnpyb1dlTDZXREhCR0VJV2Jpc1pSL2p6NE15cGF6?=
 =?utf-8?B?aS9EeFJRMDROTzNkN3FUZEF1cm15MHFsWUpCSnp3TFY5VjM0Z2xDcnpaaDNN?=
 =?utf-8?B?dHQrSHFsdkNzM25aRTBXOVlMdXRPZEJwOHlseDd6ZG1wTmE5OHhySTdHUzFv?=
 =?utf-8?B?Z3pMOXAvaXVOM29ReG43dFJXT2lab3ZUUGQ4L1NUR3pLSEJmRWp2TkprQzcv?=
 =?utf-8?B?LzM5ZXpBYU9wWTlkaVdoVVcxZTdpOHB4b0dKTHpONXVZYndRSjJXZ1Y0UFpq?=
 =?utf-8?B?dlI2dVg5SkJIbGtWY3JpS2VET2xXTFQzMFNLOFplNVppMDhQRkh2OS9pTjBG?=
 =?utf-8?B?ZjVGSG5hdzc4bWg5aVhYdUtBaElRSzNmSWFveklWRFlpMnFwdDB3UmpObjdZ?=
 =?utf-8?B?RU9nUG9xNkhDUlZVRndldHpMYzk0cFo4Qmw4WklITEhqYXA5cVplRFRpMXRl?=
 =?utf-8?B?ZzJrTEFKekdvdG5abG1lK1VuSmdXZWV2UzJTVElZRU1mUFB5K2ZHaWlJaE5F?=
 =?utf-8?B?ZzBXOVZETnpSK3RCMjAxeDk0cHhlNC9MTUlWak00NXh0RUtmVHM1RGw5aUVi?=
 =?utf-8?B?VlVrRlRhOVRtWEpCSU5jREh3cXh1ZW0wVlk3M2NzMDRGa1l1emFIVG9tN2pJ?=
 =?utf-8?B?cHpYeER0ZUgxV24vSitlTXM2eUtOWUZ6ZDZvaHBtemFZOTliem1QQUJiMVB6?=
 =?utf-8?B?SnhhcGFYdkhadEVuOG1UNkhyM1F5cGtmV2VNaVlRQlJDb3JVR1FZU2lXb1JV?=
 =?utf-8?B?bU1NSG45ZEJVajBGWlJxVkRmc0g5OElEMC9lVlZJc2RkQVZIZ0svdFVXKzcz?=
 =?utf-8?B?eE5IOCtoQ05yYy9NcThXeGY5Lzhrek5XVTd3aTBOcXp4T2JBTHBUckhodDBw?=
 =?utf-8?B?MmFMK0NUZTcyS2ZaNWdOZFQrZ1pYaUt0MWo5eVVONWV6T0tQWVVSK3hXOEt2?=
 =?utf-8?B?ZlVFeE5DcllTRE5BcG56M1lkSFArU2N3OFVVRzZwU3ltSE16T1dGRFNTTlBn?=
 =?utf-8?B?Rm9ield6NmQrWkc1NThGbEd0cnlQb2xROTBTbktlUW1pc2lQVUpPUHVoWHMy?=
 =?utf-8?Q?pwZeHoKMV+XYDwreTtn/uOA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: abc2f773-d397-4e70-65b1-08d9985d52db
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 08:48:04.2173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZM5CNKs/FbrLo3trZygLmwtNJT9anXKVeoPJS4p4vcJ7Jnao9fOk3bc41mh6i5pmRyzYHAK94NeESyflMTbNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1565
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/2021 09:51, Kai-Heng Feng wrote:
> On some ADL platforms, DPG_EXIT_DONE is always flagged so e1000e resume
> polling logic doesn't wait until ME really unconfigures s0ix.
> 
> So check DPG_EXIT_DONE before issuing EXIT_DPG, and if it's already
> flagged, wait for 1 second to let ME unconfigure s0ix.
> 
> Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
>   Add missing "Fixes:" tag
> 
>   drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 44e2dc8328a22..cd81ba00a6bc9 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6493,14 +6493,21 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>   	u32 mac_data;
>   	u16 phy_data;
>   	u32 i = 0;
> +	bool dpg_exit_done;
>   
>   	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
> +		dpg_exit_done = er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE;
>   		/* Request ME unconfigure the device from S0ix */
>   		mac_data = er32(H2ME);
>   		mac_data &= ~E1000_H2ME_START_DPG;
>   		mac_data |= E1000_H2ME_EXIT_DPG;
>   		ew32(H2ME, mac_data);
>   
> +		if (dpg_exit_done) {
> +			e_warn("DPG_EXIT_DONE is already flagged. This is a firmware bug\n");
> +			msleep(1000);
> +		}
Thanks for working on the enablement.
The delay approach is fragile. We need to work with CSME folks to 
understand why _DPG_EXIT_DONE indication is wrong on some ADL platforms.
Could you provide CSME/BIOS version? dmidecode -t 0 and cat 
/sys/class/mei/mei0/fw_ver
>   		/* Poll up to 2.5 seconds for ME to unconfigure DPG.
>   		 * If this takes more than 1 second, show a warning indicating a
>   		 * firmware bug
>
