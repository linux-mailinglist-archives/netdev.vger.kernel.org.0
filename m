Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6790535D84C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 08:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242697AbhDMG5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 02:57:02 -0400
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:55488
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236840AbhDMG5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 02:57:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz0rC87hIqA3LLmM/s+0D1/b2Zg4heGGc1gQjuCiRgLWmURzAbg87lrGV9spXXsBGu3MS6VsTsQQOBlKuIFcClNV9+CSO/k0EOdty0N7ZvQkFrh2TQpL8UGgCixbALqq2xlRGrX2NSm/ACi348MyCDwFWGoPT4UxpLUdc2jO8eFkeRg3v/OG68fcmYMZqn/uQSMJMNh5p2xyymQjMpFClAs+WDcmOEs/gblt3XJCTzbBZ7hJiUuJGGl7ak7VeTLuE4ZB2bor4Rj+ipJr5+1POwUdrsgxk64JbbFIeDBwRmu9RDtyqorysVD4I6YGCV0SU0QGuzuwRvPWStjryZg82w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qOP3qV3DygLImwIOHUmRb4BB2s0VXqlNW5sZOCif6I=;
 b=GxwCcoZn1wr62e/r0xmyp56i9KqBalSmvuQDyob8r/IvV4dX3OqRayJ+UXpCzr6PWYtMYdH+hM5RZhp9KYJZopzvkEfnLH92FCdYsqJLoPpdKOUuTy97Ym5vMf19+LdHRcVBVfG9xN7e8a6XOCr00azMgMLj+8DrRjj5wbv4zHijsX0TaTdaiksX+TggRIBdr2t7OBcR30aDMUw9Go9JrfRz3L3bObcSH+O+ZOYXFhrba1u2+CkYsBWgEGrzYR+s9vLSFdwuGrYCTvxidEY6to2W0iVeYU1Pc+u0ceJnUoTA4jidq+Lga8S9pGV7CjFHsJYaUbMryei6kWZlfztX+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qOP3qV3DygLImwIOHUmRb4BB2s0VXqlNW5sZOCif6I=;
 b=YP0iYpxfkf1bAYt14Y/iUnm+UdQq2LSHpMFfssMu5eRfoyREJfUX0DYCvFr8I3A7ZH23M33S48jtJ4iR8iPfP5mR5gawgCwqsqOkfXmvo64zFjmQgntqpjv+DVO2ioScEFASICVOhl7tsZojFRJ+LkOa5uAaj/mmIZmwsvKa0uY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13)
 by AM0PR0402MB3315.eurprd04.prod.outlook.com (2603:10a6:208:26::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Tue, 13 Apr
 2021 06:56:38 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::3419:69b2:b9a3:cb69]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::3419:69b2:b9a3:cb69%9]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 06:56:38 +0000
Subject: Re: Re: [PATCH] phy: nxp-c45: add driver for tja1103
To:     Andrew Lunn <andrew@lunn.ch>,
        "Radu-nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
 <YHCsrVNcZmeTPJzW@lunn.ch>
 <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
 <YHRDtTKUI0Uck00n@lunn.ch>
 <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
 <YHRX7x0Nm9Kb0Kai@lunn.ch>
 <82741edede173f50a5cae54e68cf51f6b8eb3fe3.camel@oss.nxp.com>
 <YHR6sXvW959zY22K@lunn.ch>
From:   Christian Herber <christian.herber@oss.nxp.com>
Message-ID: <d44a2c82-124c-8628-6149-1363bb7d4869@oss.nxp.com>
Date:   Tue, 13 Apr 2021 08:56:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <YHR6sXvW959zY22K@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [95.116.220.255]
X-ClientProxiedBy: AM0PR02CA0081.eurprd02.prod.outlook.com
 (2603:10a6:208:154::22) To AM0PR04MB7041.eurprd04.prod.outlook.com
 (2603:10a6:208:19a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.178.39] (95.116.220.255) by AM0PR02CA0081.eurprd02.prod.outlook.com (2603:10a6:208:154::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 06:56:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 518f7e5b-fb33-45bd-f043-08d8fe4948d9
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3315:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB33157DB0AE1D5EDAA4099FB5C74F9@AM0PR0402MB3315.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMBUXZ/ZEI2DPjLmHpf/agLhk2W8gF1PsYIfJljN2fpfE7BCYejb3QXCihLdOYd1GAYLCz446+cUE5a/6I/kAcK2lHolCTYFZgiYp16buy5Hgs2w8Jth+aeqThtKoQ00hN2gucubssPvj+Yk4cIBvNm3ikA6MHwlfqZaGxKa823ZLwQch5s47h1tNdMgl0MDHzRrWgGKOhfIqCDCfGjUOIlhIM6++ZYtJJloTeC1OAQrS/qdHBYinDXRA/nkI7wPeLAyDvpGEn5Z0TvxYbXXI9nw4kumcfYsxaFNGGIwn5saYjhqJ5i5PONUsnj3zlFMHdVRUX1Ol4y90CeMpSSPw4CTmEiBsK0X1Abn/YcYaYePDXva8iRGwgY5jGmtm8uIXj0OwNhoYR9SJu8Y2rUsF3T/WrwTtsxiCgl1LmurQ58JR+5HnFuG1xznY9vDYEvE8mgYUitCmSsJYKOPOi10pdZP3/7Z4u+/lkvbRlbUI4zEnPFLWeLT6Y7838FfoOijKLAmzOGoo3qAGY87B47A/OXWckh5DVmV9KjJZ4ZyRFZwoRydwcYBHc5NOntc+LRJq8ekYFvkF+KkCArjkRKppsQVFMP7VRLb/q7L30yYRj99RwsupzH75u9evdNwpXr0Oe79UBjdkvGtuER3UBJZ+I+0cA+0wekJukz36jDdBGpniW5N/iYzxdwAYK+sGC2OtVOnuZMUI+nKHAhGs6s2bwGnrdfoWl9JhW6MwzCIPvg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB7041.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(66476007)(186003)(956004)(6486002)(38100700002)(31686004)(44832011)(5660300002)(66946007)(38350700002)(2906002)(31696002)(16576012)(316002)(6636002)(110136005)(86362001)(54906003)(26005)(8676002)(16526019)(6666004)(53546011)(8936002)(2616005)(66556008)(478600001)(52116002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MUVzNks1U2RoMC94empkUUV4YkIvdzg0R3VHWkNiMFA4QThiSy9aVTJvMDZL?=
 =?utf-8?B?czF3VnZranNHWmhoM1lNYUJQcTVuT2ZZdmpxU29WRmhXSVcrS2J2RVd4ZVEz?=
 =?utf-8?B?cEVnbVFaYlFDY3ZzUldnQ1ZzbmtueVAzSEw4VExwcDU4akNQNG9PU01MQ2dI?=
 =?utf-8?B?NU5qWG1oNWJsZlo4UzFEQ2cyMS9GZm5wRWlrVkk0V1NLZ3RVMHpnWlNmQXht?=
 =?utf-8?B?akoybSszWjkrTDVnZ1FHZlg2WU9RVURKS2gxU3EwSDIrbFFXSnp3TnhzWGtl?=
 =?utf-8?B?RGtCYnJsSGlLUW9idFM3VTFRRFNZVGxxN0M0SzkyY3Z6ZUJsQmVXL0hlRS9q?=
 =?utf-8?B?TlF0cnpUeHNtaU1Rcis3alE1ODBsZ3BGR0QzMVltMmFtZDJuamcwdWRlUHN3?=
 =?utf-8?B?Zm1NZDJvdVRlUXh4Qmowb0NkUjAzMzlHOENJT3VkTHVhTmZlK2Nhd0VMM1VH?=
 =?utf-8?B?QXFqQUc0dXRJb3FoNG1NZ1NuU1FOS3lsOEVIN3c3ZFhUcGluZlpVandRTDRv?=
 =?utf-8?B?djUxY2F4Ulo4UGVOMWw0NUdmL0lFMERRVldmRG9Hd2RJelZEb2dTemJmZkM3?=
 =?utf-8?B?dXhDK3g2Z3VYSHRHTFpoRXRJYnMyT0Z4Vy9vVHlHQUdpbWxYSFhBMzV3NUda?=
 =?utf-8?B?L29mUXEvNlRYYlNURy9pVWgzZjJQcEUzY2pBYnowOStTK3pWR0xpU3JtNHpX?=
 =?utf-8?B?QnEycGlmOW1SVkJQVFptUjJxU2tseW1SRDVlNEtjUjR1dlZCalFkeUcyZ1Mv?=
 =?utf-8?B?YXlwWUY3YkdoR2dTMXl1eDJzZHhNNHRlRHBRcXFpRUtwMkxmL3dycFBoM0FY?=
 =?utf-8?B?T1REUFpaN1dnQlV3WXhEUUQ3ME1rY0JQSlNYNHBHa1kzajhLYmRyZGxIQWo1?=
 =?utf-8?B?UjBxSWtsOUF6ZFhHOGt4alFpWjkzbUNqb3Q2aHZ4N3ZFUzZxSHd5MThaSlF5?=
 =?utf-8?B?QmJ1NTlQdzRpWFh4elVxZ2FhK2NmVjdZek8zYmx4WFhBUUp6NzNJd2h5UktO?=
 =?utf-8?B?aUFhR216REFNVGdNNmRXQ1RrZVVrNXVoYlEwQk92NzRhUDRMRDk2SGphZ0ps?=
 =?utf-8?B?UGo2S2FKQXEyazJCUVVTTmJBcjFwT01Pb1k3MmdpaXZiWUNkWitFOFVXa1M3?=
 =?utf-8?B?d2xqNEhlQVFLZUpWaGNXbzNwUCt3TmszVnFOWFVXanZ6TGVGRzVNdWZLcG5n?=
 =?utf-8?B?Wi8zbUw4MWtvd0JnenpiT3ZncXBScUlRZ0FBTmlzYzRlVm1mdENSK3FvYURJ?=
 =?utf-8?B?T1J1QjJGNzFsN3hEY0ZGaDBBeW9NcURTOHpsVHNGblBvRWpTbks0a2tndXdk?=
 =?utf-8?B?WWQxSGUxa3RtZUV6a0YzeXNmbGI1QWZvb2M2bFlBZ1A4bHU2TzZoZ3JCMVE4?=
 =?utf-8?B?dGxnM2FGb2lvNHQvMXJua29yRzd4NUZvMmxiS1M1Q2JuS1FVM1Q1YjBkMUlx?=
 =?utf-8?B?ZUMxNURybFQ5N2dZMGNkVWJ0WWVlQ3F6eEdqemsvRDI2SG95TFlUU1YwNWg5?=
 =?utf-8?B?SkVyNzJoMkI0MFRubDkzeTJKbE4zanc2dEoycGFmKy94RlBxa0JweWNEdHA5?=
 =?utf-8?B?U0NHYVE5b3pXcmt6R3F5L2JnMDJJNHRyVittSDFJUUQ1aFJLRjlVd3NmOURr?=
 =?utf-8?B?NG1jdmNRTW5TRWVlYU8xaGg0aWRrNGJnUEdyaG0vWmZ0bDR0OUdmU01mR3Ey?=
 =?utf-8?B?Y3hmMVZ2aTZUTFNEOU9taEhvU3JEUFhnUjI3K2laVkt4WGRWbUtlQk5MQmZw?=
 =?utf-8?Q?74Pky9iG1Cx+AkP7+OHRuXytaTYbkIY84eWsgv/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 518f7e5b-fb33-45bd-f043-08d8fe4948d9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB7041.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 06:56:38.3385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktksrqEbwBzkQu0fST2eG0TrADl5KqHQZz6Rn+qo6Eh/rlA/AFGmG0b5CuK/QMWceHYFmt2uvbWOZW/s8WwNNsr8dIObZnx9/toz6MWcp54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3315
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 4/12/2021 6:52 PM, Andrew Lunn wrote:
> 
> So what you are say is, you don't care if the IP is completely
> different, it all goes in one driver. So lets put this driver into
> nxp-tja11xx.c. And then we avoid all the naming issues.
> 
>       Andrew
> 

As this seems to be a key question, let me try and shed some more light 
on this.
The original series of BASE-T1 PHYs includes TJA110, TJA1101, and 
TJA1102. They are covered by the existing driver, which has the 
unfortunate naming TJA11xx. Unfortunate, because the use of wildcards is 
a bit to generous. E.g. the naming would also include a TJA1145, which 
is a high-speed CAN transceiver. The truth is, extrapolating wildcards 
in product names doesn't work as there is not guarantee of future 
product names.
The mentioned TJA1100/1/2 are *fairly* software-compatible, which is why 
it makes sense to have a shared driver. When it gets to TJA1103, there 
is no SW compatibility, which is why we decided to create a new driver.
We want to support all future Ethernet PHY devices with this codebase, 
and that is why the naming is that generic. The common denominator of 
the devices is that they are NXP products and use clause 45 addressing. 
When you say we don't care that the IP is different, that doesn't quite 
fit. Just because the MDI is different, the register map does not need 
to change much, so it will be easy to support future PHYs also when 
using different PHY technology.
Moving the code into TJA11xx is creating more issues, as it assumes that 
the devices which are managed by the driver are always TJA... devices 
which may not be true.

Christian
