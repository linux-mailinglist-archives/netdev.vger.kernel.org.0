Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9A21D7E23
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgERQRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:17:49 -0400
Received: from mail-eopbgr140052.outbound.protection.outlook.com ([40.107.14.52]:32645
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727987AbgERQRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:17:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gG1yfQMiHTGOz/+BKBP/tw9tOUa98PdJ6NtSDNX0eVXzXN5yJsmlBDRfGz3Rb7UkqAIBL9HUjBSzGKJAiJ71LZQ4gvoPc0EznkmeBrkbsMykxx2cWrt2GfUzdINVxdXlk9OQY61rs/4QU+7VgQDz73mL5E1s1tXMt16CEWp3+uQzKsJGQfpz4BaqavMVzJVSkL1oVyKeZuNuv4LvvP8NHU705VXR1xO2zD1x374CxZJcEfZYgB2uzSNYpwAFqU12/pwtTvmDh7U+gRN9sM6ClFjntOK/RokKaGl0dMHu733afJpO6KJPLD7s9eXkieWp6q2nWL5EfjYM76aRDTVDjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFyArtvvgk9ru9QVrujnyufiTahn+KHBcqUhLqDbIoA=;
 b=MLB+S2/KZ2o71N15SdxPF6I+mr7pkMmoubAQefgCGIJ+tkxdpKmU7jhZYg2uBC1EJgR8Goi2A20a4O7ghDe+0OtEq/H/aGFMUSNqrme/PbzIVtVdPtZOVqc0VNUntgCwBO/gIXAS6hCxQZEMLhqt9RiiPWpopUKpL6hARufYTepB3KvcoVeuCOeBQmG8nrw0FD8tfrViqk32gzZylCZuv64bstvZhBIW8XAAo8X8hDKzudVdCCvavbCUWsEVAyYOvCICbtG85GmhD3pGBC6Plcb0F+4CvFaYJXU8Ck5JXc3q+SpRoeOQlK0j9OXp57YrJRC7zQqFFS1FvSRr7hqiDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFyArtvvgk9ru9QVrujnyufiTahn+KHBcqUhLqDbIoA=;
 b=kUiWShyQkz995UOHZlavs5FCzCwrUB6Vlt29nvld80xs55rBjjbru4orGNBv8UePp1oauTjbAPTaLdr7lLfvqsanGsI84YbPzzmWtD4CQQBcXu0j6KJACuKCmrewdBD6XavObAtvhheBv7Hme18D+gzJJKEPJzV1U9ckExoGqYY=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
 by AM6PR05MB5063.eurprd05.prod.outlook.com (2603:10a6:20b:1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.31; Mon, 18 May
 2020 16:17:45 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718%7]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 16:17:45 +0000
Subject: Re: [PATCH net-next 0/3] net/sched: act_ct: Add support for
 specifying tuple offload policy
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
 <3d780eae-3d53-77bb-c3b9-775bf50477bf@solarflare.com>
 <20200514144938.GD2676@nanopsycho>
 <9f68872f-fe3f-e86a-4c74-8b33cd9ee433@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <f7236849-420d-558f-8e66-2501e221ca1b@mellanox.com>
Date:   Mon, 18 May 2020 19:17:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <9f68872f-fe3f-e86a-4c74-8b33cd9ee433@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: PR0P264CA0150.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::18) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.105] (5.29.240.93) by PR0P264CA0150.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Mon, 18 May 2020 16:17:44 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 32ccf081-a0bc-44a0-24e1-08d7fb46ffe1
X-MS-TrafficTypeDiagnostic: AM6PR05MB5063:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5063130B7BFFE2A260E9702ECFB80@AM6PR05MB5063.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ud82HFnkGe+Pd10fx0LCpAfikjD5rQCd/QsJZMiqSX3EK4HSCQI/rHOrp3AV396FeF6MYjEapWFgSI2K6HSmqRFNjsCcEYQzWcyb3Hb/AniAq3hqhCNRruBLYBuCrEMLlFj6c/T7fIzYLUtM+A7bzjDnJN8XWpz3DITXqLfhPSCmjFq0BTw8H80o0Ih9oJvqB82Ol1jKa92K3SRoATr6I5JgN5LfiPb3kLo7f3Rd3tAhoi2LnFoqed5aDSEH3XWzFCeMrrHsfruqK9MZtz1WuxlEcDpOnMEIM8g0KofMnh4/ACPUYZs+1+VfSZR58kcUUp23BpLWP+UkLnpc6tHySG54SwTIDYU8Nark2GWDc7Rm+GI0wJFX9YBRINDHfXin8A/QSlzdysF8NXVsUE7lHxaWa7Cji+aHBLq+dfa62SJXVE3Q8Ca8gJkBeJeeXiRQOWo/yt4TMozqJbKM3p/5lRNVGwG36rK/Cd3FWLIghjd42KlxNdWWwjat5DWOsi8e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5096.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(36756003)(31686004)(8936002)(8676002)(66946007)(66476007)(66556008)(2616005)(956004)(2906002)(6666004)(26005)(5660300002)(6486002)(16526019)(186003)(110136005)(16576012)(53546011)(52116002)(107886003)(4326008)(478600001)(316002)(54906003)(31696002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9saJsZ6aM6vLbnLh/GL7utmOldZzlum5YMYMdQ+wcV1y2QtEx5vNEK6Du+5DfiM6Z5kzfXUwn2vE1y/q2JYg8TpvFkOTFaYS2FLBDn6gREZtKsj8RHxzQMdplCo0MADsZpL3Y4aWYF13T+J2dW033qOCtum+U46iYj4DOdZAU9Pi+d6oKuXTfodu9mnEaC1+TJ4kxFE6eN7WBotgvFy4bX76FIPFPf/GDZA/de3I2Gd7mgX3i1ki4nEY6aRIUdWgERQ/WXmmFyuobx0b7YQdB5Yws9inHyj7sqKvHxZQoFuJNJe0kKo9vqNJTad3dacOUIWgbivinFWdvP1Fx8UVU2oSz2ZzS2R6pfsqjvGnCPnsLHAAGn9hJb2UQxidSzpcvYD56H0Rb8U7coRayWRBcCQefBE7pARJwwjdJfu6dzgh9Bcj5Len30KPYIpZ6STS2aqvPHiwHcwb4Yq/JBQtEm9qJMpUFAesYE8dFjnSgCA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ccf081-a0bc-44a0-24e1-08d7fb46ffe1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 16:17:45.6911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WWnabrWhkl9HlsH2tZuXV354q01gGoDXl2GRdZwDU1YIBDkHHfDaggZH3BaKuicaG6VPhrFkcBRFLZOMJs/pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5063
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/05/2020 18:28, Edward Cree wrote:
> On 14/05/2020 15:49, Jiri Pirko wrote:
>> Thu, May 14, 2020 at 04:04:02PM CEST, ecree@solarflare.com wrote:
>>> Either way, the need to repeat the policy on every tc command suggests
>>>  that there really ought to instead be a separate API for configuring
>>>  conntrack offload policy, either per zone or per (zone, device) pair,
>>>  as appropriate.
>> You don't have to repeat. You specify it in the first one, in the rest
>> you omit it.
> Ok, well (a) the commit message needs changing to make that clear, and
>  (b) that kind of implicit action-at-a-distance slightly bothers me.
> If you don't repeat, then the order of tc commands matters, and any
>  program (e.g. OvS) generating these commands will need to either keep
>  track of which zones it's configured policy for already, or just
>  repeat on every command just in case.
> It really doesn't feel like an orthogonal, Unixy API to me.
You were right that a tc user needs to supply the same policy for all ct action instances of the same zone (not per zone/dev).
Actually, in my internal previous version of this patchset, if the user doesn't specify a policy, it uses what ever was configured before,
and if the user does specify, it must match the previosuly configured table parameter or override a previously unconfigured table parameter (or new table).
But we think, as you pointed out, explicit as here is better, there is just no API to configure the flow table currently so we suggested this.
Do you have any suggestion for an API that would be better?

Yes in OvS we planned on submitting the same global policy for all ct actions.

Paul.

