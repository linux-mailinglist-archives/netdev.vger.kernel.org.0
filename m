Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEB437AC40
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 18:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhEKQpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 12:45:45 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:19687
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230315AbhEKQpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 12:45:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DApgJelVHJakizs+Efurv4crmTPiEiiI6uAPEDopvUctncnvT5LT7OLRj3Z5701796ssXvpKkXaQFm5bUD0zPMQjK9yKrxZqpVrI4cyc68zDEiefv+b+Oy/cRd0EkQDJLpimNCuxxl+fQ+OM89pIMXlmQEbZ3p8l/Tqbj+3Ofxk5ucVFEJ8fmmLgfRlh9z+HOvT9ZcFZ8LgA9H4Lk+qTQXUH1B9c5M3kjWGFvkL4JWziGNxQBAgOOukVE/tPS8WRvbdGtaytyf4sLtlq2tApHTGLhaMBO/7uJ4O3WjYjU6FssWasaSyWhLP0tZUAbWLz9w7ByOzr14J9W8kMS4wLDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eC01FncVWYDzosiyGZcTivY9RRspziqviEiLACzT1fQ=;
 b=gBZEgKK94TxctKfX0ui93ch7+teLGUfhheRdlbqm2zDSVeRET6z+B3IQz/JfmtD3uluw7MuSeA95ovNyo0Rxm4c68IrstQmJaoQG0pjxEQEnAg/0FWzedd4X7ude/QEeo31zYXLRbV+qPyjT8keyWKAKF+4OMqYvArOn38R89JDyah5VDzpsA1YdzFusdL+WoF6fDZabuYoDMBKIT0I9X0qZJsUM8wY7wLoEPdFPT74L36FYxLZTG6OOmjhUl9O79OCFgIU/Q0iFDF00MYGOk+GX0Lc/DPmPZfq3Cy6z2kKRvrrJwue/DFreW5mzKlOiZPc351uIiw6AuAXJHUWdag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eC01FncVWYDzosiyGZcTivY9RRspziqviEiLACzT1fQ=;
 b=IwHeWbHApwV/PSNHlh37Ua2BiWtpLxwCPJfaXRpa1FJwlybFnU0VAfr7B0mM4l8uNEa5V1CcBIwFJR/fgF8sE9F+qf8eKxOnzzmzEnckd7cIRLsgN34b1Lydy0XIeO5gRPlEDITSTES5U7tH4Ux5feezjdhyPfoFNWya4skKtmI=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8853.eurprd04.prod.outlook.com (2603:10a6:10:2e0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28; Tue, 11 May
 2021 16:44:35 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4129.025; Tue, 11 May 2021
 16:44:35 +0000
Subject: Re: [RFC PATCH net-next v1 1/2] net: add name field to napi struct
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        netdev <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>
References: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
 <20210506172021.7327-2-yannick.vignon@oss.nxp.com>
 <CANn89i+kZnGHmiVoQSj4Xww7uNwhaj8+XV2C+4a_6k+T4UcY7g@mail.gmail.com>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
Message-ID: <2ce5ff9d-7453-f48e-7e84-539752f72be5@oss.nxp.com>
Date:   Tue, 11 May 2021 18:44:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <CANn89i+kZnGHmiVoQSj4Xww7uNwhaj8+XV2C+4a_6k+T4UcY7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.210.25.135]
X-ClientProxiedBy: AM0P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::21) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.18.89] (109.210.25.135) by AM0P190CA0011.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.50 via Frontend Transport; Tue, 11 May 2021 16:44:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c02d088-b94a-4a4a-0fb4-08d9149c0f52
X-MS-TrafficTypeDiagnostic: DU2PR04MB8853:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8853557ACBC89B674A14E4C3D2539@DU2PR04MB8853.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UIyMPVGoOcj8n+wFCiijAkeXKFF1V1lNbHDzCPl+JR3qP0KpNrYQLdPolHziEg2MQxAL+fc6476TvWgP2pq9MSbudwim2uLVRLnuorfwNSsTxu8w+rJDzSQEjTiv3+5slxWN9CM7CL0jjHok1NaJeYKIlcFhDOsGnpY6/BMJXUfDhWivcGLeNQjscjvdsEuFDSiPox+le6EpieI5Qo7NlOXzBh7R1Be2laUDVQZeSP7q28pNlduUucQNAbkab2aLXzZ228N5xP1OC9Y5a3ak4Ii4U3HTeXDcVzfGgEr9HqTW98EelsNkDoSNQT1fV7yR/n98PtEUqN83W9y1azfwz/7WCbKqzl0WpodjfQhFgmM+QYL8v5FNsqxOIim/UKz39wMkXdLHOIUo67Hd4bW0R/TRELtRJnvJOJCm1xwnEQBPNeBXGlxBREEW19ZCAJlMxt1pa7OYZDQi92NX8Qr8nfLtUGIBpVsu99lBxvlWxzigJHmZ0MXf5G+eZzdvr2YmfbGEnS/962gLu67ebA3qI9IMx0EGskO8b7B9YyjEIvAIgD9bjHnmiZZkgGeGSbu5QEU+ZjfFJ2//CbYUp0O6HTobrf3EJj9D/0AywNOgaK16xlyuUskyb+6+WjtBGcurzYYTe/kW/Gzo0aSJ0AEm/7uBCyykycxvVTpMiC9iisTyNINM/Hwl7xg1sa9BZVEhPhNr17k2qR5UfcV7Ol70qA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(6666004)(31686004)(6916009)(5660300002)(2906002)(52116002)(31696002)(86362001)(66476007)(16526019)(66556008)(478600001)(186003)(66946007)(53546011)(316002)(16576012)(38100700002)(956004)(8676002)(6486002)(26005)(83380400001)(54906003)(44832011)(2616005)(38350700002)(7416002)(4326008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RmV1SGl0bzRra2RQVXdNV1lIcno2UVpCQVdpc2dyOVlBbHg5eXN3cEVIOHJ4?=
 =?utf-8?B?ckZnSGc2dUJwTitxSkRyblhlaDlBNjZyR2xzZDV4WURHa21ia3NXU0FQb0J4?=
 =?utf-8?B?VnE1Tm9EMjFLaHA3N0VDeFErSFZ2dDZtd1gyTDVuWnhzeXVER1p4Slc5VjFV?=
 =?utf-8?B?VFExd0dLWERKbFY3bmM0ei9Zc0dRS2hHSzNmZE8wd0dvYnNwdjJxaTkzQjZO?=
 =?utf-8?B?ejlsQzRBckwrdDhqZ3hwdE8zU3VLWTRBUUtXajVYRWVSak10Z2VmWEcwRXg3?=
 =?utf-8?B?VStvYzQrQUhIZENHNFVhbHZidysrenlIVUw5QXpTR1Z2TTFjMnBLelF1NkNl?=
 =?utf-8?B?ZkFGMitmc29vb0sxZU1SQkw0NjRVRG8yb0hrellraVhIQXYybzE1a1c2OWFM?=
 =?utf-8?B?ampIQ05XT2ZuaS80czVkeWxKeWdhdW56RFl1TmdIQUNubXZQd3JrR1FMenFh?=
 =?utf-8?B?N3BwakFFb2JxbC9KU0tyaWFDTTJ5d3RMSmFWWHNLdFVzaER6RlZNOUQ5Nm9V?=
 =?utf-8?B?ZG8xZnJOMk9xS0cvVkQrVmdmd1FJMXE5R1o5WVNZZ0FPTmxWRUQwa1FMQk9S?=
 =?utf-8?B?OUFhYzV5Rk5jcHd4UVljMGxWeGtrUVhYYVNrQklQcHFRU3BTSjlHY1JwZnlD?=
 =?utf-8?B?UVNEVjdhZHhZYjBjMVQ3SFgyTitKcXFMb3c4NmxUMWpiVXBOY0FKMUQybFNs?=
 =?utf-8?B?MzhJVHhDKytqaXMyUHFoZXdXYmRIVXo2bFFIcEkrUkxqcUNYcUFpZTRRajUx?=
 =?utf-8?B?a0kvR3ZsWkx1dm5hY2tHdWJGbGVFZERoRVl0R0dsL2ovQ1EzOElnSHhxVk94?=
 =?utf-8?B?M2c5RUlkMno4Ukh4VllnbWJjWWZ0SWhTNnlRcjF3YStvZmZzU2JrcmZidXpY?=
 =?utf-8?B?cW5KR25mQkp2MkdLaWV2ekFnYWZtL2hTVXhEdTZrT09sWjlGdnJvdlRZSERQ?=
 =?utf-8?B?bVJ0UENEQVRRWWllMk5zTEYwa1R4ZVdENThtd2Y1RFhhOWNOWmQ1aWhvWld2?=
 =?utf-8?B?SXdET0NFNVhNTVB5REY0LzR3MHBnRGVmdC9YZmp5K3VZQTBJWXMrS2EyalZr?=
 =?utf-8?B?aHRxYW1UYUZsbVBkNit0cmNHNjNOZm9hQ2h6OFNMa1BOaUMveEg2WXpWZExF?=
 =?utf-8?B?K1VkRzlKVHdNakJxRTR6YVlVYnMrOXVWN2Fmd2lvY1QwdFV2b05jd25YSVds?=
 =?utf-8?B?Z05KNFY2QlBxWnZ3Ui9pY0pLZ01RYjNBMmtXRWVVdUVER0Z4S0hmOEJWWWxI?=
 =?utf-8?B?UDFoY0ZSdk5Sek9raGVWRFZSejdPb3c1bVJVVmwxRzl4T0ZFb2VjTTZlKzNX?=
 =?utf-8?B?eVZOVFBnUFpBckFYU0pXa1JzNHg2N1NjcjMvRlZNY1k0OHBKS3N5ZVZnMnVI?=
 =?utf-8?B?VFRiK1hWaGJFYUhVS29OUjN4WEwxQmViYytyRTlNeXJMYmx2K2FuSkZrUlBN?=
 =?utf-8?B?NE1UMkI3V29YS3hCd0RBNUppbHA4bmtNMmpYeUlQWVExUm56dnhjSmFlcXFi?=
 =?utf-8?B?TDZYY2p0UmpwSUpFb2NXeFZLSVIrRVhHSUtlQkRMd253MTAxblNOeHM4bEx1?=
 =?utf-8?B?eDd0UDVxYjBiZER1VzI1VFE3T1FiZjB5cFlaRytKa3h0dG93OGw1N3AwcWd3?=
 =?utf-8?B?aUpkNEUzQkZMUDJUY1dTOWcvSW90K1JnTjM5MnhkSnZLQ3gwc0crdFZFMWJG?=
 =?utf-8?B?S3Fuem44cnhTV0ZmcGZlM1RXSHVLOVV6L2l2UjdpV3A4WlJQdi9SYUo5NGNm?=
 =?utf-8?Q?ABjsf8Jp0IGUBYupd5vlFrMnnoZ2BJ6GAJBHakX?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c02d088-b94a-4a4a-0fb4-08d9149c0f52
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 16:44:35.7411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ph0UlKkxW39d0TVzxZggANQcFWRp1tgiKLJ3BvJ3iYMv2FNNbqZOvxXrLetBSLn1tnJCh7I5UKI1edw1eYlMFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8853
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/2021 7:35 PM, Eric Dumazet wrote:
> On Thu, May 6, 2021 at 7:20 PM Yannick Vignon
> <yannick.vignon@oss.nxp.com> wrote:
>>
>> From: Yannick Vignon <yannick.vignon@nxp.com>
>>
>> An interesting possibility offered by the new thread NAPI code is to
>> fine-tune the affinities and priorities of different NAPI instances. In a
>> real-time networking context, this makes it possible to ensure packets
>> received in a high-priority queue are always processed, and with low
>> latency.
>>
>> However, the way the NAPI threads are named does not really expose which
>> one is responsible for a given queue. Assigning a more explicit name to
>> NAPI instances can make that determination much easier.
>>
>> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
>> -
> 
> Having to change drivers seems a lot of work
> 
> How about exposing thread id (and napi_id eventually) in
> /sys/class/net/eth0/queues/*/kthread_pid  ?
> 

This seemed like a good idea, but after looking into how to actually 
implement it, I can't find a way to "map" rx queues to napi instances. 
Am I missing something?

In the end, I'm afraid that the NAPI<->RX queue mapping is only known 
within the drivers, so we'll have no choice but to modify them
to extract that information somehow.
