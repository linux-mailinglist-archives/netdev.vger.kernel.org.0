Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B082F42A948
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhJLQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:22:56 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:10368
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229496AbhJLQWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:22:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhT80msuKV4VjN5qaf5/BqKi3V8RIyO1mToJYGETTZqoOu07s95YTB3ztvCdcXEQY/cuN4mMKEKqo/6Nyu5KeFCC7jMaBtGGjeXqwjdRtvpLxQZbmyoBbrK0sW303p0S2r6eAbbxpucZ4hpdnG15U5E4a2tqopq5afCnrj+JGusvKGX4B83YlAHPiWFei6W2O/0oFK3itB1G2zd/EkJ+X5wInYENvK2V7pWugOTLPz69sm+EsbdLZuqE1yfcczwuMEhSY8ONBOIKTighhXab25Al0eqQl7Vg/IlBWhzX9BjZoYf8KH0FAPksAvSadskMKCBE8LSw2R0HT8UITKzkfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xDsBtUcUoalMDbM2V+QCUOhQniND/cBZIttgb6nf6Q=;
 b=REVdmTnpY0iqPeRQnCsxstRFthgCAq6XQSfNn+1jmPiu96qm1iwclfLDp3HDxLNpg9TZIPRZuEiPWU8+wrURL/AhZXMl/0dZllfYCSHcOBeTz3WbYy/At1uZwnR942fSlB3Sht++BMtWl1060QISzfIJ08uU+krypQhoNaHCnIwBCCKoYX9IFvHay2Yv+v8UkwN/NQMbWqetu8pif/eOItc9iA8w0wJBxuMMxbBdCL+AKlyHHDc9RFI4XkDbxFpcG/5DMg05XH/qCUEtX3cUIc+vlc7lbxX6lABUs211F3MxYcYZ0b/kv9QYO53RMSB4bp629oZDJqGjQcMNYI/B6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xDsBtUcUoalMDbM2V+QCUOhQniND/cBZIttgb6nf6Q=;
 b=zWM3eR9Cv7Olti8QZxvTuM1h+q22RM18FpgpQqM3/6WcQzFrESFbjTg9yC8HXUx8Xx7jCJOFHEOaobWnsbCOp5O4BJdmo5PN6AYAtU9Mtbe0nflGddPeQcTwrcI44ETYAV3Z+UbWlSseFi9hfdsql68fVfoX159E1GYBSxiKu4A=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7243.eurprd03.prod.outlook.com (2603:10a6:10:220::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 16:20:46 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 16:20:46 +0000
Subject: Re: [PATCH v2 2/2] net: macb: Allow SGMII only if we are a GEM in
 mac_validate
To:     Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <20211011165517.2857893-2-sean.anderson@seco.com>
 <20211011171759.2b59eb29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <163402722393.4280.13825891236036678146@kwain>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <10781413-67e5-83a5-9ecd-52b6c81ee1f6@seco.com>
Date:   Tue, 12 Oct 2021 12:20:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <163402722393.4280.13825891236036678146@kwain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0053.prod.exchangelabs.com
 (2603:10b6:208:25::30) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL0PR0102CA0053.prod.exchangelabs.com (2603:10b6:208:25::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 16:20:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a222d5b-6a9e-4d19-7b3e-08d98d9c3ef7
X-MS-TrafficTypeDiagnostic: DB9PR03MB7243:
X-Microsoft-Antispam-PRVS: <DB9PR03MB72431A8E69D7AC3CB4644BCD96B69@DB9PR03MB7243.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oetlzcTJ4M+Q/tbuKyGECB/jkRIdtH+J45/6ixQvlD+xw63+kdeYx+JPkuD9xvEle+Rf3fXCTN4N1iNuSgJT72sgfOsP+SvfXZUqoKZF/dJCGAYPlYAYZUB9oojqf6blJbGfZhkCXvF8NpN6+WYVJIKzTwnINLPetwCZXu4XoG7+ENm58lKiktqP7gimX3R9qtp+chqACRonoRrd6ihzBvEzxzhG9Csz5N31r4TmLbhJHOgHVUWZRS1mpatTXGNJ5cTGI4Q8U3zWM8v5QlRVMCBsVbb63xbUOGDA8klfXwCW4x6xgM599LPWVZLL4NbYg1sc2PNzaAbOjjhXgu03QXwzIj6Wg3DFNI1nVxxDA+nE6SlQ6m8SqkAAbCYT49cafY5gmKvOqOMQ6rFU5B1abC9c6oe06dvfGRF2TcDvZCmjyN2WKJvLNme5PmOUwNx2jsn4VC9CJnSmvSraqNlW/JuvfedRB45uh0dTWzuLdP4xv4IkfRB6ennnEdwMvbieVppr5FtqRsDH8X2m2zhSRH85w1HxXYKVr/IJh2TJBuREmHaRXba1yWMGJw53YnLC537dvx/d/EwA6NkxtctK8wS7lFlnvgiyuXGnI1OAfInTvv05s80ckyWDbl4aFKZGyYlQKpRGwXGW2m5dFpBIpDFAGFi7AivZ9BsNGnDw788daRdzmQmV7UifwU8sZnDx5TbYzS2uCVoGjnzK7EQpNV4IDHrpVeRMtRwr9ngDdhRzhieBdmhn3cGx/5tLTps3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(8936002)(956004)(66946007)(31696002)(110136005)(86362001)(6486002)(2616005)(66556008)(4326008)(66476007)(4744005)(83380400001)(54906003)(316002)(4001150100001)(508600001)(5660300002)(26005)(36756003)(31686004)(6666004)(16576012)(8676002)(38350700002)(38100700002)(53546011)(186003)(52116002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlBsTG9kd1dFNFNjcUZ4eHJYeDVwcUVxQk00bkc5cjVzOXdmczIvRWdsV3o5?=
 =?utf-8?B?cnBxS0c4eStjdDhSYWlkZHZ4ME8zVmtIWmhtQk8rZ2tmUmxiVWJvZGRGclR3?=
 =?utf-8?B?Z2FGeU8vRDA1TTFPMmhIKzFNTDh1WmNiR3UzZ01xaWNTa1g2bVRqZWQydC9J?=
 =?utf-8?B?MUJMSFFsVEw5Y3RnOHpacVZ4b0N4aE81NWN2SS9sUlVtWHd0R2g5cmZ5Q0g1?=
 =?utf-8?B?MWZvVHY4WkdlS0dwQUlYWEFrZWwyVjlwejNNZDRDR3BIQ3p3em9xNDFpL3ho?=
 =?utf-8?B?bFo1emtUYzhqOFNWM0hwaUVvQzRHc2pBZjdTaXl0WlY1TkFkaE9Pd0ZIV2hi?=
 =?utf-8?B?aXRrQWpDeHlsak0vK04wazV6c2NBaXFQSDM1MjlMWnNXU3JvWEtxREdQdENr?=
 =?utf-8?B?T2QrU3VYbE9VNXdGMFR4UlgyMktwRWZvSitFYmwrNG9UQi8zR1FrVXZzK1BE?=
 =?utf-8?B?aFVSV1EvbGxndXlDWGpLUExSMExEMnBYNmcwREVJaTRxWkwzUzVZM3Yrd1do?=
 =?utf-8?B?ZkVJM1dLMzZKemFGRWxOSE9DdnppVzl1RU1VSVpOdGl4OGUwQi9ZN21zdnNU?=
 =?utf-8?B?YnpGZ0cvbFRkd2ZJRnZkUEp3Uzd4QURyeXNPUWF5c3IxN3VZNVYrSEJqVDl2?=
 =?utf-8?B?OXRFd3FHRktacXJBT3E0QVhMbVVhQmwvRnd5eDNXTjl2bnQrc1RocFJaby9J?=
 =?utf-8?B?S2JSKzBoWms2L0tRNkZsQlVidEZoVnJRZW5OVVZzRWV5WlZ5WTdEanlhRm8x?=
 =?utf-8?B?QVZ3UUhCT2hSVTR5ckVmRkFpOE1xeUJqTGoxYk50M1VsYk0rMDVhTHJGRGp1?=
 =?utf-8?B?cXVCeE9GYzNEM1NzcmJKVHhaMGxPbk8yYWgvUFJCTThhbFRZdi9TRkw4enpp?=
 =?utf-8?B?MFZZMjdNNWpER0MrSFpIRktJZVNVMHFXTkVIMW82YlNIU0tQaWlNVXVkaXEz?=
 =?utf-8?B?WVhXRWp0WjlhM3AvaFdYQXgzaFREdk1XdlpoTUN1WVRIRndzRXVlazJsZFVm?=
 =?utf-8?B?QWNFK1IzcnZwU0Q0TmZVM1VaaG5tc1JQaDAvZFdkUmNGUkRXUTBzOHIzTGpq?=
 =?utf-8?B?Yk9yVFNXdG5NQU9Uc25KUWVleC9PdUlRU2hSWCtpMWJTdXowWFgxY3JRYUdL?=
 =?utf-8?B?MElDN0EvckpoWGg2MUV1NEFoYkJsM3JVS1owV056N3hxemdOenltMzArT3dO?=
 =?utf-8?B?UjVlanhRamdURGlrbGxBTlhEaE51c2o1UERzaUVlRFFKQkw0YUgremR0dkQ2?=
 =?utf-8?B?cnQrZXV1RnVrWUdWUjRVL0dkQk5Qb1FCREVaSHV3TkJ6OFR1UnhxaVR4Zkhk?=
 =?utf-8?B?ODhubXpyWW5DeEg2dTVPTU9wMUM3UWpZYzlySFRObGl2WTVaYlVkTFE2Q1Zh?=
 =?utf-8?B?QUNONUN0UksxUFBrSnI5Sko5QUtqQURRd0NLRjllZ0VQRFVQMDFqeHZyOU9P?=
 =?utf-8?B?SUVtVFEzUHVsaTRlNjlTMWF5cyt3c2dySUlOSUExRnowQWNwMEZqVzIrcXJH?=
 =?utf-8?B?bUtiS2E3M2g3S3RadEFXMnUwQ1JNSHlpRk9pUnEyZHZDQU9ud1IwbDdGZEU4?=
 =?utf-8?B?K0duNzI1RCtuMVF0YUdqYU9mcWdSbmdpdjdydWJRSHBuL1VOT1FyU3BYNWd3?=
 =?utf-8?B?NkMvVGlqeVNSNVVyMSsrOVBCVVkvYk9lSUZObWF3UTVSa252eEc0RDNTSDNn?=
 =?utf-8?B?OGJ3SnJSSjF3UXp1MTJOd3Y2N2NPdGNRM3JSUWZuUjR4UEd2UUNJSHE0Yjk4?=
 =?utf-8?Q?INIo9ee7JLMHfR/yOty+3mZyCNCvfRBOirkqqZ/?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a222d5b-6a9e-4d19-7b3e-08d98d9c3ef7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 16:20:46.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VskTMemSsEahZLC/1xHt9ZtMnWpidTqCE4kaCq+omebqnWO4iQonPr0lMAwLI+6Gru0NqXH0284VE5rms4vaGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7243
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/21 4:27 AM, Antoine Tenart wrote:
> Hello Sean,
> 
> Quoting Jakub Kicinski (2021-10-12 02:17:59)
>> On Mon, 11 Oct 2021 12:55:17 -0400 Sean Anderson wrote:
>> > This aligns mac_validate with mac_config. In mac_config, SGMII is only
>> > enabled if macb_is_gem. Validate should care if the mac is a gem as
>> > well. This also simplifies the logic now that all gigabit modes depend
>> > on the mac being a GEM.
> 
> This looks correct.
> 
>> > Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> 
> If this is a fix, the patch has to be first in the series as it is
> depending on the first one which is not a fix.

Ok, I can put this first then.

--Sean
