Return-Path: <netdev+bounces-5564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AC7C712270
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6EB02816A0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D7A5680;
	Fri, 26 May 2023 08:42:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C7C3D62
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:42:04 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2117.outbound.protection.outlook.com [40.107.237.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503FB18D;
	Fri, 26 May 2023 01:42:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZV9xts5dV92XqRTBawaalHPJ11I0zlocm9dQhC9slJFBLScnyx4vDzeq5Gg192aQYr/tGeAaJF4ViC98HOpPN2fyyNJm+kpUQva98j83Xgu5PPV1zyZqsXy4vMl33+US/AgsZ2neZXm+zbrSG9YyH/BGdPyGNIARsnf372l1l+XokKpz9qsxhPg0JdYoWWOW+ereOA/B0XUonix0Bo9vzdYFQzGN7gSpxz5VIYsn7piSp0kmqpmic1ibTTYZ0WZEMGr6g5Ap2dr2GCN27DpoMKxpEPbbj0VJ1GxMMd1WIeU3VfxKW0lfbC1/U9DkE3Rh+Tn1PQ0BYfY6Yk9MUejpBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CSxUHjIVbx1t90yweYpGi//XAn85wFkbSLg+L791ll0=;
 b=TbaUwIoQLc45lIieeALiIss/kXJGcbaNueVt/PQOODYUwwwwecinV+oOHZ38K/v48Ron90y1Vdi0FelH46Psqdf7+qHsfPraoNRaFCcQjwPTawu+EumHV55OAS63Mc070dzh7c0xis8Rh8tFXxCRGZGFvMU6ID3V7m0eSgO6LnXbVYHrlH+sT1eobbrul86NIe2hfZl4RbaMgwM9YJwrZPsYaJAVywt11/b0KJZC3E7rR0atZIavJBRE28Fy4q0ydPjvHsnQbG/xRpQyQ/0IMzz+2yoOvVumzYWBGr2dhqNgIXpQjyoSzvNeoXxT9GJMBQcqWhWEqhqFd/J6108mxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSxUHjIVbx1t90yweYpGi//XAn85wFkbSLg+L791ll0=;
 b=uXAQwq+fTkdVoG1PVqOYIeizN6xBIxRuE4PaDLUX0zRmDut3YOV9bKtn8lV4C4nNgngCOItbPZWVnmLGyVkjjBlESvoR64bmK3t2GEW2hWUsB19vOo+gYvu0zBGRgtQUay49XpfkPEqu7mKmNBg1UMr4bMHwGSSbU1MovAH43Ww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4947.namprd13.prod.outlook.com (2603:10b6:a03:357::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Fri, 26 May
 2023 08:42:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:41:59 +0000
Date: Fri, 26 May 2023 10:41:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: George Valkov <gvalkov@gmail.com>
Cc: Foster Snowhill <forst@pen.gy>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-usb <linux-usb@vger.kernel.org>,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/2] usbnet: ipheth: fix risk of NULL pointer
 deallocation
Message-ID: <ZHBw0l76XThhVS2Z@corigine.com>
References: <20230525194255.4516-1-forst@pen.gy>
 <ZHBlShZDu3C8VOl3@corigine.com>
 <C0FADE3B-5422-444A-8F09-32BE215B5E88@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C0FADE3B-5422-444A-8F09-32BE215B5E88@gmail.com>
X-ClientProxiedBy: AM0PR10CA0012.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: 70f8ae17-662b-49d1-b89a-08db5dc51230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S0P5ccs5/TEWgN2ktoxw71+1APhmCNwEBsZN9UUN3gZImx4XMGMgXK5Pr+l7Azu1Nmav4m08M+Y8xmy4Ar3GZdmWmjfCY/1KeLRC4W6AvE//q5Gh84OpMFBQUANH2hBAYcKDGTUVlnzTqKCTG9DozedjIE7gpH35tB5rVR3X5R1HYEuYG7hwC1Pn7g+/pIq4s60M1m96SztuhQt60SgSsvmxbQaJBTb03Q55/o1jhfcMCevBfOIfZQ8uem8g5YPhYPcjDk5cGrMA+Mve8H8359pUnI2KaMVrJkFMxyrxXVZM2WgiCC9i9glCCiVGL+rKiC6NAzQHFi40Vf2FKw67DnvRu+cs1V1tsIZn3+SffKr7IYvycgZ/a77guhXFO5SVojvsr8pczViFpLWfAknu1kvj5m+Lucly+HSxVKgIDQGmb9MiBToSAyAWGxRPEOCO9JbinTDYX6PxgfqtBQyR3Mzntr2v6U+L7ThFmisb/pZHy0oHmRKPb6OjJ6WsHSg2oO0UKB0N62YCKXvH5FQBJNwX4G/mJ+I5P6oo3aizbyX7o9l/ZPxuQAQ4ZJBmUMgQH9MtlCyhOtR6ai/uBxHWIB8n1sDFQkdMkpCG12xcxak=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(376002)(136003)(396003)(346002)(451199021)(86362001)(41300700001)(6486002)(478600001)(316002)(6916009)(54906003)(66476007)(66946007)(6666004)(4326008)(66556008)(5660300002)(8936002)(8676002)(6512007)(38100700002)(44832011)(53546011)(83380400001)(2906002)(2616005)(186003)(6506007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjQ2S0lJUGduVWtKd09pbG9DMEtnNURmUUlEaThKMllWVVM5RVc1SGdnWmhl?=
 =?utf-8?B?QW5YbG41VS8vcjFVdjZBRFJLRW5BWU5xZzdIeUV2b3c4cmc3UDdMVXZ4dTkw?=
 =?utf-8?B?VmhQcVRIWDdIYjFLcUpZVjhTN3kzT3dwQm56SDNpbGRNejYyZWxMTEFFR0ZJ?=
 =?utf-8?B?aVMxZXZIRndKV0ViUWZpTm1OOEdOcTE5MlpWQUsxbDdncEd2c1BNSFpxbHZJ?=
 =?utf-8?B?OTI3RXRXejFXMjZjV0FXV0FhZXQ2UVg2NkU2aXhPejh5U05ySFN2TVc0ZmhB?=
 =?utf-8?B?Y0RBOXAxMkExT21RSjR1cjM5Y29Zd1lCV2hpTXcvdngxdGJ0SVlKbU5WN3Rs?=
 =?utf-8?B?Ukp3YVhNeFBJblZ4QjV3SUpjUEJBb0FoczdvUDl1b2l5amJnS2hpdE1mYWpC?=
 =?utf-8?B?V0doQ1FLMFVDY2F2VGxLcThuQjdsUkNVZUJlUkxPTWVSaHJjNUZNbmZ1MWNJ?=
 =?utf-8?B?MGROWCtKMkI2b21QaUZhZFhXYitGeDRkVllTWllNNXhja0ovY2NoQkF2T1dN?=
 =?utf-8?B?NHJSYXY1WW1OZVg0eUVZS0YrQjRrYnMwR0Q0ejZCNU1BNFZBM0dlZUl4OHc3?=
 =?utf-8?B?ellJZnRZVTAvYnN3Q2I1Y2NaZm8wN2pZQmRZaWFTZUxqV0h1Sy9OVWNhV0tT?=
 =?utf-8?B?ZFF1c0dUK1ZYRnRpZzNzaFFseFppRDY4cm1BOGZuSE0za3dxcUJGQ2RBZHFm?=
 =?utf-8?B?cjcycVdFc0V0UWdNTk0yNk9jZjl4cXhsMnh2SFBYRjNDQUx3SVRFQ0czVW9r?=
 =?utf-8?B?RTZPZkk5VGtYdHNzOEFQUk4vRFpueFdRbFpSWmRrcjk3RVpKVjdVYUNHVThm?=
 =?utf-8?B?RFVDbU1oY0JVb0xhZHkzOS9kVjdPSjNFQktPY2VaYXh6UElUenpwcENjeGpD?=
 =?utf-8?B?ZWEvZUp2V21IWWR4dzYrQU5XUzQrbWRzZjJGRjNtK1pVVWVrSVdoYU9KSmts?=
 =?utf-8?B?ZHNmY2haL0M2LzN6dkw1cjVKY29MREpFeVBWQ2dtWWY5bFptUWJIdURjWFBj?=
 =?utf-8?B?L2taVmRyTlJkZkxiN3E4dGdxSmR5cGlocDVmelNKOUJHS1JjUHZtcWZTbE5Q?=
 =?utf-8?B?aHRiRlgwNTdLZEJLc3FnenRLdG03YjlxaWVYMTBRbnlDV3FNZklQdHREUlE3?=
 =?utf-8?B?UStKaXpRWUx4OHE0ZU5vYlptNTJkM09LSXUrU3ora25MQ1R6YUxGNVdBa2hu?=
 =?utf-8?B?WnFvbDRxTGNHT2d3YWthd3E0N3c4Q1hvVG11dFZEMWpkRXB3UUdJWjRISnV5?=
 =?utf-8?B?cGpwSW9xS3lFWS9qRm1Ub3NmTTdqL2hVTFZFQlhFcjNybE9RQk1Qam9oUjVQ?=
 =?utf-8?B?eVA2YkkwSHR4YzZDMXl1cmZtRlZ0eGxPVVJ4RDNzZXFyazVhbklMNktkVjlH?=
 =?utf-8?B?N2FoYmVjc3lZdWVRSmpMNlVhQU44cE9QQldmWmRuMG9wbEZMVExrQ0JEMTA2?=
 =?utf-8?B?M0VMYVk3eW1YT0hrV2loUG92T1pYUmxVVjVSL215dVNSaWhQVU1kNEozWXli?=
 =?utf-8?B?TjkyTzQwK1V2cjh6VmRKdS9mWm00U2l1dDFTcFBJeTJvc2dQUlA0SE5GUnh3?=
 =?utf-8?B?MjZhY3hHZndBZXI1OWlKYzYvRTNnS2V3RE5rWkJ6cENsRGJpeVNidUFjSURh?=
 =?utf-8?B?OTNPN3FMVGU2N0t4bmprMW1rcFY1NEVxMlpWTjRHU3p2OTZFZ3krcS9qbktR?=
 =?utf-8?B?SnY2bzNpQnNMcGVYL013R2dKU0p2QjNidnViTGZEV0lyaXdZMzZ1UGcyZ2VS?=
 =?utf-8?B?VStxUGNnaUZ0aHNaMk5BSHhWRHFUSFlmWnIzOFdUbHJDbjY0aFVvVHdvL1lU?=
 =?utf-8?B?Zi9hR1dJSCtTeFhJWkttOFlGeTRNeklXdXRwVzZKWWwyZEVKTmgwc2RaNWVL?=
 =?utf-8?B?VldsU0RsWXNPSFZrNTlCY0Z2eUt0ZnFjSkZSK1hVajN4Q3Z1L3JIdFdMZ3k1?=
 =?utf-8?B?RFAyQlQ0SStxUnhySVlXWlVwNUpCQlVESG42NXNGaEdFMXRoTStZYVN5ekZo?=
 =?utf-8?B?YWFQNGVsaFdQald4dHZJaHF0RmFKWXlXMW80TG1yVXBFR2NKbHZiVXJsYnlx?=
 =?utf-8?B?ZGRIRnhUcUE4SlQ4ZXpvQUpRcE5JQnMvSkp2UGdtcUdEZllWcnpHOGs3NDlP?=
 =?utf-8?B?NWp3RnVOcWkxUWRHbmx4NW5GR28ybUloc1BHOFNoQmFXYkxYU0tnK3BPM1dD?=
 =?utf-8?B?NGQyaDRrSTdabHZqVEVhZEx3RE5DOThBREJGUGxPN1U2SkxGVWxINkg4eGZN?=
 =?utf-8?B?Z3ExTm5vVzh0L2hKMmRmcjY4SEJBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f8ae17-662b-49d1-b89a-08db5dc51230
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:41:59.9033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOrYEmdVpcKAuuAe2zuzQ/xS9g7NMCW3AoIDrepzZYQSFwUO3tqUYP9pdp4pghplNtn7d9oCQ+Yu1twJZWfJ8Qky+Bezu9voexanalY5Aa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4947
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 10:33:21AM +0200, George Valkov wrote:
> 
> > On 26 May 2023, at 10:52 AM, Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Thu, May 25, 2023 at 09:42:54PM +0200, Foster Snowhill wrote:
> >> From: Georgi Valkov <gvalkov@gmail.com>
> >>
> >> The cleanup precedure in ipheth_probe will attempt to free a
> >> NULL pointer in dev->ctrl_buf if the memory allocation for
> >> this buffer is not successful. Rearrange the goto labels to
> >> avoid this risk.
> >
> > Hi Georgi and Foster,
> >
> > kfree will ignore a NULL argument, so I think the existing code is safe.
> > But given the name of the label I do agree there is scope for a cleanup
> > here.
> 
> It’s good to know that precaution has been taken in kfree to avoid this, yet at
> my opinion knowingly attempting to free a NULL pointer is a red flag and bad
> design. Likely a misplaced label.
> 
> > Could you consider rewording the patch description accordingly?
> 
> What would you like me to use as title and description? Can I use this?
> 
> usbnet: ipheth: avoid kfree with a NULL pointer
> 
> The cleanup precedure in ipheth_probe will attempt to free a
> NULL pointer in dev->ctrl_buf if the memory allocation for
> this buffer is not successful. While kfree ignores NULL pointers,
> and the existing code is safe, it is a better design to rearrange
> the goto labels and avoid this.

Thanks, that looks good to me.

> >> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> >
> > If Georgi is the author of the patch, which seems to be the case,
> > then the above is correct. But as the patch is being posted by Foster
> > I think it should be followed by a Signed-off-by line for Foster.
> 
> Yes, I discovered the potential issue and authored the patch to help. We’ll
> append Signed-off-by Foster as you suggested. Thanks Simon!
> 
> Something like that?

Yes, I think that sounds good.

Please wait 24h before the posting of v2 before posting v3,
to allow time for more review of v3 (from others).

...


