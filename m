Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256E42ED546
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbhAGRQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:16:44 -0500
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:23265
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728066AbhAGRQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:16:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evFu/ZojbkWKxZ64Y+YvudIP3Ko3aX0431iJNC2Em0t3WA7qIi3sTOXgeqw2hKq37iimTj2nUrgnzNWUA9J7Uh45n9Jxm1DgOJKcPI6g2u8LR+EVUTc9gR2MUExyMUaXGJM4/UIx/w//7elB4W8iZ90dGMcfRyI9Z4B773ABkbT2SxWWffZdwEuiP6VGFpkCqOv5BbC0l+alPWm2aUQ+phuvyQ1kmGLOD6Mj+kKOgOHnZ1X9e/WgCx94+fN+uuqgRAkWnwrhfh8+q78zBShN0ercATUSBE9MqxJsDxm/083Y04FB+4Rn2ceoPAtrPbB3i7GqAm0i+cTStTmwudcw7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+oEi9thCOUyps6rjkrX3AtxaGAbw1x0Nt2fOhdQMKk=;
 b=fK8Yf3cZH1Ec720vwqcpjCc8MPTg1zVCd5vetW6rMo+mwATORqeeg+Usw69DSOA4+AMsaihhw8uNNogf7D3djbvN1uwJo6O/iIWwGehGW74sOwwxIwIAVm3SmJrzOW+hSJFkrixkxu/TsFWrRrJ1QyFPONgkzJHLe9aCdklY0wDb7+JcjwB2RoKnMMQvMuBW/qjXU47Kc8PvSqOOoYHUL/ZQRlMnEWdIlWCAWFQ9raxL0BXRQxV5/yNUZkje03dU8sFqXxM9LJd6ATgH6unuwS5YMIznlnNfLyquz8OPIS1q1mDgaf7dBMRUsnV7LjtJKOPrlkGTEDeL7sBZ9lrFGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+oEi9thCOUyps6rjkrX3AtxaGAbw1x0Nt2fOhdQMKk=;
 b=CN1H5qZLs9vYCgDMbkglUazLlhymm7uoLXjDfyvsZQ37E/d4mpGwQHEQ/TEttFe2g2wXXEyJkL28QmiXwcd0Oypw+9d6FE5VSL6XyLCBZYDWG6iEa/Tpu4uwock8AhMD13z4c6jfxX14+YloqDQFI6UXtwjrjEJtdRk5yxqurWE=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB4653.eurprd04.prod.outlook.com (2603:10a6:803:70::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Thu, 7 Jan
 2021 17:15:54 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::6467:fb5:1181:e8b2]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::6467:fb5:1181:e8b2%6]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 17:15:54 +0000
Subject: Re: [PATCH 3/6] bus: fsl-mc: return -EPROBE_DEFER when a device is
 not yet discovered
To:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
 <20210107153638.753942-4-ciorneiioana@gmail.com>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
Message-ID: <29b89807-6ff6-34c3-53c2-e56825a6977f@nxp.com>
Date:   Thu, 7 Jan 2021 19:15:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210107153638.753942-4-ciorneiioana@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [86.123.58.157]
X-ClientProxiedBy: AM0PR02CA0031.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::44) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.105] (86.123.58.157) by AM0PR02CA0031.eurprd02.prod.outlook.com (2603:10a6:208:3e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 17:15:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71377b6b-df45-4fd5-e74b-08d8b32fe3dc
X-MS-TrafficTypeDiagnostic: VI1PR04MB4653:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB465366671C2E546050EE36D4ECAF0@VI1PR04MB4653.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e0kQprWBWdgodUooJ+RgjWDHaVf+nQPWsHu3fKGEqmjNNInc9i1Ck5/lKJokfT80criubBk5+rtpiRwmUWYOl0Mtn5DCTQ5W5klsE7Cf6ZffZ6aA2ot6TfwIaLw/KnTQwW0WYcVbGBgqpyTs98R2T22YZIQUkQBIvhJvtBPJuVZ8YEt/zRAlHmEhogNb/4fFc/4DlBxLluKFPg99EzgkRLaAoR4BhpIyW4jld/NwkTBzmrvb/1oqXvcLBZh2LLJAiOKuRtmTFACAA566199tCjTChkbBH2mOC5GTMKds+e6voEF/aSeloIxOSuh/uDy/6aZpl8XFZHGsWV49kgwUaUiRhg7ll27vcVUCDmlJfEUCsR1U+puF1AEHThsTO/JL4VFCkF9pLH4UAeV15QZJrtC9I9gCPBJWfQeRVWMNDIg1rkwsvaxHorx262amwmxvsvb8xBS/FSteWM1nRKw71Yl8hm+fzul6OgrH6D8iqZI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(4326008)(66946007)(16576012)(36756003)(52116002)(8676002)(478600001)(316002)(5660300002)(31686004)(8936002)(6486002)(66556008)(66476007)(83380400001)(26005)(2906002)(53546011)(44832011)(31696002)(2616005)(956004)(186003)(86362001)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K1oxRXY5UXNXYm9pRXlVbnVqWVFhdy9mTlZwdWdhY1RkektyUXg2VlU4eGdG?=
 =?utf-8?B?eG1mL01HdWxXWmdhR0pNMUhtYVVVVFkyUnBqMHhlWnVyMXN2RE83SXRKb21r?=
 =?utf-8?B?bFFnTzRpbkZ1R0R0bGQ0emtMVjQ1UUkyVmwxNkpubVh0cVkyZ04zYkhWUzA0?=
 =?utf-8?B?RGc5NmV4WnVLNlNSMFE0L1AyNnExQnFvd0RvdTN3MklyVjN1ZE1wQzY1TUlK?=
 =?utf-8?B?NXJyV29tQSt2cGUwQXJBWXYxMk9Ocit1ZjJ3RWV0K3QydXF4TjVIQlk5YlVs?=
 =?utf-8?B?d2pLN2thSmNBSG9vMXM5dnpWMlJiVTJ6dU8wWXJhUGtTbkVUWDJId3M2Q0VF?=
 =?utf-8?B?VEV4TDZ3ZXBKUkZGUUlGU3RxVzl1ZEtQWWM4azh1K0NrRFFqTExWYlZISUgr?=
 =?utf-8?B?OVhuQWhZZmt3M0hsY3VhK1VoNjU2ZXZJdTMvUzVVYm1JMDIxQ2o5M1NHcldN?=
 =?utf-8?B?dXBRbVRHSDYrVURjV0NsdENwWDNQTjZvcVdXeWovL0ExcytVa0x5ejZJb2FL?=
 =?utf-8?B?REczWWU4SnBZSEl1c0FPdmlNdEtSeHUwYTZpSGE2aWdUNUlLYnMwOU9ucmI5?=
 =?utf-8?B?RkxzdXM2WGF3ZkNZWVFDSmR0d3FXN09tSGpaWHl2dmZsMW00Y0tteEhrZUNH?=
 =?utf-8?B?Nlc3YVpHalBQaENzcnJxVnV1cmdwU21Ha0MrdldWU21OaXpRR1V4U3I2MCtF?=
 =?utf-8?B?SC94K3FNaWdiL0dxM1ZXb2dQYjhpMnNhYTZtWmhHTjBSdzZsQTJxK2JjaWtR?=
 =?utf-8?B?KzVDUFY0ZGpxL0tLdHlaN3FkeG14cFdzRU43ZDdISnl4dHBtZGJoUkorTWpK?=
 =?utf-8?B?VlZBbWg1OFQxUEUwV1lpTEU2SVBOZFRjL3o2NXlvby91Wm1ONm9XYXQ4cHZW?=
 =?utf-8?B?cmpsVWpRbGZsU0NzUEdtTk12QURISEFKMVl5ektVOXFWaXFpdEhZejZjZ0hS?=
 =?utf-8?B?dVNDaVdyTURZN2hpSzFkeGxiNHNWN04zSm9zY2pSbXlFM3l1VHk4Mk81dXNq?=
 =?utf-8?B?d0hDc3gzS3R1aXRlNWRnbEZCT1gxZjcxcElzVGZnR1RNVFlaMkZTVzdORHFK?=
 =?utf-8?B?bTNZdFpSREtuWHl6ODZPV2dOcjNjcWx2bFI2UEJTdnVLVjNMZnpYOTE3T2hE?=
 =?utf-8?B?NllrU2w5YWRva2p5VTNHWnlDaHJvdGxhV1psQm5EMm9MdHFmU3dCeWMxd3Nu?=
 =?utf-8?B?VmdpVjBYRVJHQ09ONGcwOVZmNjA4Uis4c1pvMTlOMzI5TFJ3VHZxa0MyYjYv?=
 =?utf-8?B?N1dnUlZrdEhNdkZ0MCtvUXJpODJnVjliTjlQNXlaUGtwU3pMZTJ6MkxKOGxu?=
 =?utf-8?Q?7qwrj1n1eiCrSKaRAcTYmwejiuUuEv+47n?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 17:15:54.0215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 71377b6b-df45-4fd5-e74b-08d8b32fe3dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FyGhn2vSN8IWJwPpHRGQfoYCYOdc78oA5J0L9cTuLXZKLeooYzaqFex76tvpY5LSTGRuqlpzxwK+bo1BoCJ6Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4653
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/7/2021 5:36 PM, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> The fsl_mc_get_endpoint() should return a pointer to the connected
> fsl_mc device, if there is one. By interrogating the MC firmware, we
> know if there is an endpoint or not so when the endpoint device is
> actually searched on the fsl-mc bus and not found we are hitting the
> case in which the device has not been yet discovered by the bus.
> 
> Return -EPROBE_DEFER so that callers can differentiate this case.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Acked-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

---
Best Regards, Laurentiu

> ---
>  drivers/bus/fsl-mc/fsl-mc-bus.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
> index 34811db074b7..28d5da1c011c 100644
> --- a/drivers/bus/fsl-mc/fsl-mc-bus.c
> +++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
> @@ -936,6 +936,15 @@ struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
>  	endpoint_desc.id = endpoint2.id;
>  	endpoint = fsl_mc_device_lookup(&endpoint_desc, mc_bus_dev);
>  
> +	/*
> +	 * We know that the device has an endpoint because we verified by
> +	 * interrogating the firmware. This is the case when the device was not
> +	 * yet discovered by the fsl-mc bus, thus the lookup returned NULL.
> +	 * Differentiate this case by returning EPROBE_DEFER.
> +	 */
> +	if (!endpoint)
> +		return ERR_PTR(-EPROBE_DEFER);
> +
>  	return endpoint;
>  }
>  EXPORT_SYMBOL_GPL(fsl_mc_get_endpoint);
> 
