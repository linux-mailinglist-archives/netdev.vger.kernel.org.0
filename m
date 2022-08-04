Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40165589CAD
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 15:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbiHDN3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 09:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiHDN3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 09:29:50 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70054.outbound.protection.outlook.com [40.107.7.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBBA27B10
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 06:29:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRja6pAn99LemTjf/aVl+IU+eriPTRYr+dz4Iz8d+FZbMLjaOTyxqHqEeFOh6pujfFZTzTEyDJa+kysUDHqn+pnHG3udVLbb9yTu2j3RH9mIJRYN/8O4LUZtv/rcTbAm1sje3tMUm2RMfwZU+xiUoTTi70q7hkeTczuKV7g7n+X2srlkZkg1zFuZPPbN73f6PfeLAKFgnptkQe88UbkONUdYsd630+Jg5za0B6u1TBiDxIkXkqzpyDYSvvybgCXwyb4FEPT9bFgwfIOzvTY28liVsKMbucNX8IKZ823d6Z7Xa7x6N1JRGvheGgaBXrnY6waHgd99ms5Wqjc7pxKS3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pM8TFke3SJCy044gNikBR1vlqU58NjDTl4HHpJQzH/g=;
 b=LViDuJJOyXChtPADOZuz8Rp1VIHwAcrgIMvBk+aWPmY1xuYMeDP/yzUyQWV2GzIESxkNby0fBkuqj/aqDovZxQN4MLZ3d3+0FYiax5xwBBoX0HrrRO5teeQuOO35ccyXqfBs2f+RrzCVTKyMtujLdZe9K5MleScxnGU3FIApCgomjjI6eZDNpPDoD1x6y/esElVaDZJZsbfpgtmXi3nN4r85QqDviIUM/Br9ySW1TSq3lHP9F9YT867vqoQNAIQWoex9r1AZgbZVd/1AHBBm/mUHW8ZznxosTHgq38ftPH4JQQYCK27IjnxDpZENeMzY5wjCiShOdGdUijwNyRNJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pM8TFke3SJCy044gNikBR1vlqU58NjDTl4HHpJQzH/g=;
 b=LOpqIGFqTNQ34UazU4EZjULW9j4roqzsldDkzX6dXbM/VZdIwhMZxV9bJt9ik4bxSOb9E8rAdwUkfRaf+KvLq74MXz1dt99cKJWOMBtfrJtQmyrxnYX4PzyPBUWpishBCcdQhDRqdnS0cyYvd3pDPvrXDk2D7FmEPNL9ZFsIGnf8/sDAZKz7uK7GEc1k63YLpe8J9cDUGC6J+pDwF20hkr3Ax5AJcH8s+eOoCekwMbn/3UDwyAFeGbZ9H5M5aeUJ+RVZf7CksROLfAShdGGvrp4iDXBvkZxNu8/TpAPfqKYKshxtx7f+Y/5hKoAF34z96QV5UutEb0BRGtN5BZG56g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB9PR04MB8220.eurprd04.prod.outlook.com
 (2603:10a6:10:242::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 4 Aug
 2022 13:29:46 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6%9]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 13:29:46 +0000
Message-ID: <3017563c-0085-ae88-1ef0-40d1f89ef4c5@suse.com>
Date:   Thu, 4 Aug 2022 15:29:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC] r8152: pass through needs to be singular
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>
Cc:     hayeswang@realtek.com, netdev@vger.kernel.org
References: <20220728191851.30402-1-oneukum@suse.com>
 <YuMJhAuZVVZtl9VZ@lunn.ch> <34f7cb15-91e8-e92c-7dcd-f5b28724df92@suse.com>
 <YuknNESeYxCjcPrD@lunn.ch> <d8e45a94-e16a-1152-afad-2ebb15b48d67@suse.com>
 <YuvIqCBAcZTMh0xV@lunn.ch>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YuvIqCBAcZTMh0xV@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR0301CA0017.eurprd03.prod.outlook.com
 (2603:10a6:20b:468::33) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 315197c0-4675-4cf9-db4c-08da761d6589
X-MS-TrafficTypeDiagnostic: DB9PR04MB8220:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5llSWZIxcaP3nd5Gg/zNMJwQuKCBbmLVTlW/CrvuZ5Tenvv/oFK8M1jxPbscvTmw9EnRgjHho7+48i2+IbF16dRzfM0rLyaAQqgDwoMlxThhlmpWfMfBza1NTSty08kOEKnCWKMdf4o88QSZSksu9R/kc+mtpsQGeW6zTcn+e8zj12ZwDo+k5H0hslkOu8y2VRM9JrbYOh7YGrd4ptxo3+g0S70vfZqrKnmZWkAMS1LLYXgVRGTzPc60nS5QMa/pl7wIVevjWe+3v8mZ4ITd6g31TzGVfLOjGXQUSxynVOtnxb+FicmqDswwtsex+q4seBlbjmSb3kFzk/rnQE0vDCm97ZEyoxDHexBu/Sk/jXjtVnLVeJGpn3nEamaoKjCgxfv9y3axa9X2IGK+3V846dl2p3+oAjW3MLqvLU7tnhDWLkqCKqGF8GlGF7ycWa6f1WPyvglz7FGkd8STOns3Ud6tiSXkqf9tKj2ti2gaJwH/p2x6GgHDywwhsq4OaQflItod9Geb/TWNG6J9u2Kc5D4vMh2/q5so57m57lGUXNXCeL7Mn9ap1G9kSv/e5FKKSNJDja8Bvd9SqrK6T+1H92WFowUzg26g4hs+fzXtmjWkq+9AToFhW92S4GteFx2HzIts9XJn3r34oFjegNqbvWuoniEds9No9nDx/BoU1tT0P/vHI4WEdViHFVR+3wcwkaRfwan9thdI/QceOw1REIGQPqvyGIiVKYLdTj9R+fhE4ut4vRa3VXpM2pW4Y8u98r9Vc3zSl7c6m8HVj7rcDIlCmGULR5qhgWTDPDnznwfONL7NdQ3hSTUrS7sR9KojlablEuwDkym+8nTfxEokA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(346002)(376002)(39860400002)(83380400001)(6512007)(2616005)(4744005)(186003)(38100700002)(5660300002)(8936002)(2906002)(6486002)(478600001)(6506007)(53546011)(41300700001)(6666004)(66556008)(8676002)(66476007)(4326008)(66946007)(110136005)(316002)(86362001)(31696002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlpLR0kvN3VmMFc2MnBlN21RMXVPMXRqTDFPclhTYmhMSFl5NWVHZmxnbkla?=
 =?utf-8?B?ZHlZSGhuaTgxQy80S1BxYlBOZjlBVHpnL0ZlY3ZPWWhLeVN3ckNDNUoxcElK?=
 =?utf-8?B?VjQyS2ZrcE9wVHR2N1oveHhic0JqS0NNSUZLZ1lBcDFXT2Y5bVRPQi9Cc2s4?=
 =?utf-8?B?QTA3M1pYRkdOUkFDZTc2amdWOEpzRElrbzRZMExGRWVpVHBnMlZFNUM1RjY5?=
 =?utf-8?B?QTVhc2w2dFBjeHQxblhwOW4zeEJVc0JsY1ROOFg5OEExNG5HSVNwNEJGS0lz?=
 =?utf-8?B?cCtuY2ZWa0xFa240b0hLcEV5M0NzMER6QVI5bmlDRC96RjFqaDdQdlE5MzRE?=
 =?utf-8?B?cUZSd3ZUWk02OU1DcnI1SjJWVUJWNDE0ZEJKVURwSXRYd2cxbmswc1VOMk4v?=
 =?utf-8?B?eUJCNWxWMVdGRW1IMG9XcXFuRHhnbnpLb0FPSGk2TUdBdEdJTkR3cUpvREtZ?=
 =?utf-8?B?ZlFOMUVGcUtleU9GaEZxVFJUUXVDc3NSdlZid0pNTkhkWjd0dGFHWW8wYTd5?=
 =?utf-8?B?ZmNLMEJMeDNXYzNoQzZqRksvY3VVNjhQM2RGaEh6YVdIUmhRREF4V0hraTJ0?=
 =?utf-8?B?ZEFQTkpVL3BHVHRsbDRGRXFabTN2djlFK2c0U21ESnFCTFNyR2tBK05EOE9G?=
 =?utf-8?B?K1ZvQ0Y3WiszNnBPNHVkbUFTSWRObmptemh5V25HVnFmRDRHRFZTYVpCODdo?=
 =?utf-8?B?OUh3TTN6bFhySml2N3hTd0VGcStNUDlkRGtXck5TVm9EMHhnaGh5c0M4NG45?=
 =?utf-8?B?ait4K1lYNnhpVzA0YzZITGZ0YVdIRjcvS1MzNE9JSFdsb2VVTk1DeCsxNlkr?=
 =?utf-8?B?WDkyY3RzRjhITzRlWXlxV1FidWRoM0VKd0syY1E3c3h1Tm1udjN1ZFl5Yy9O?=
 =?utf-8?B?b1NJa1pSdzhBcG1wLy9WeXpzdCtTeVBoR1lqcW90VENtVHhXOTJjTjJ3TjZs?=
 =?utf-8?B?QkpRNE9GWUtjSTRJTjh3T3NWTzEwZ1pEUCtWeHZMZy8ydENmK281TGhvSXNk?=
 =?utf-8?B?L1RZL2VvZlZTc0VGSGdCdkljSlBsNUlZMTU3cTl3U2F1eXFsMlJIS25OVHhK?=
 =?utf-8?B?ckJ3RytpY0JJbmo1LzlDaFZ3NmsybEJrN3hZakhJUERhNWo1Yml5b1JFd1N3?=
 =?utf-8?B?UzhqMVBueVdIbmxXUnV6UnRXZXhDd1prMDFzOGkrdWttUks5dmZTSWR0UHBK?=
 =?utf-8?B?S1pzR29wcTZSSG1RcnlraWhRdTdSRkNaZUVUZWg4dlZnemJzREVZbk9Fa3JY?=
 =?utf-8?B?c1pwdjdWTXUrV09PY0UvTU0rNnlsVjVyV0dtczBVSGIrdkhuZWI1K2NsQkNW?=
 =?utf-8?B?N1BaQmtYOURLQUtqK09ubVB1NFlqYTdKdXFpdXFWRUtMY3pIMDFsaXJmRGZZ?=
 =?utf-8?B?cXFXS0ZCb1BnL3E2ZVA1TllNcWFhMEpoK0p5QmtMQUR1dFR6US9ON3V4cksx?=
 =?utf-8?B?WFEyYU1SbHd4YnhGOWNPQTFUbGxPdHJzemQwaXN6ZWdEcFlMeHI2N2JIdnpI?=
 =?utf-8?B?U2Z2OHgwNHd1Uk9vVVRmVGUrTHJBK0lYZEVzM2ZIVy9WM2lUY1pxcUJmSjJE?=
 =?utf-8?B?MU5zL2JaRTREVDBwRmlidENZc2VLYWxuSW5sdmhtMysrTE9JSUJ1dFlpTnp6?=
 =?utf-8?B?d1BZSHFGUnQ2WnJvYmFlTmNaSWpTSHRlUDQzWEtZWmwwdjFBQnVtYXk1N2Fu?=
 =?utf-8?B?OHEyanFZcEVUQ1VTTkZobGdKMFR0TlQxcHpyUCtrY1EyQVZCWGd0K3hUaTh5?=
 =?utf-8?B?K0drcUVGT1Z1MWd3cVN4RzlHUldFWFRVV2ZoMzdKaktYTCtxOXV5TGxBMzlC?=
 =?utf-8?B?MXdKcUN3QXJYa3phRUFzVndEUjNVN0d5ZEprZjdnTW83S3o2c0ZHVVR6ajl3?=
 =?utf-8?B?a1ErekI4Mld6aTBKTnFRYjdENEJ4cFRyNDV4TXVFWmdORHRwcUxNZUtJSGlW?=
 =?utf-8?B?QVUzLysvY0NSTVR4OW1MSlplTHB0dTVtUjNjNnhqQ0pOclM0THlUdFZQMGlk?=
 =?utf-8?B?ellXNHBlQzRtaTZSdGpLbmRVVmxoN0hIaFJvVlhXVllyaUNQUHRFREdsejhV?=
 =?utf-8?B?OVZmVWdhRW01elAyTFBsY1Y4MnNscTJqQTlzK1kyZHhhOC9za2ltVytjTm1y?=
 =?utf-8?B?aWZLb3RkN3Rob2xTRmlSTVBzanRESlNobmxaY2ZSb1JzS3k2enJRWUNHMlc3?=
 =?utf-8?Q?OOhCxvDv5hA51dE2jvZcl20cti7rVOmryU5DbW3RMZms?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315197c0-4675-4cf9-db4c-08da761d6589
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 13:29:45.8821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +y27TRqxwuVUzqtsLQkkldyADCcgcnSa7+tmaxID1NqgT7/5cchu6xRS+9wf4dzxGn/CbQMP/epE0OLzaTdGvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8220
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04.08.22 15:24, Andrew Lunn wrote:

> The problem is regressions. Current code will put the MAC address on
> both. I guess most users just have one dock with a cabled and the
> second is unused. Both will get the same MAC address, the DHCP server
> will recognise the MAC address and give out the expected IP address.

1. That is a rather esoteric situation in which a bug is exploited
2. We are at a philosophical point where I need to argue that fixing
a bug is necessarily a change in behavior.

> I would expect whatever MAC address is in the netdev structure to be
> put on the interface at resume. That should of been the MAC it was
> using before suspend. And by doing that, you bypass all the discussion
> about where it came from.

Debatable, but that's not what the driver does. It reacquires the MAC
from the firmware. I want to change that. Though obviously that changes
behavior.

I am sorry, but at some point a bug is a bug, even if some people like
it.

	Regards
		Oliver

