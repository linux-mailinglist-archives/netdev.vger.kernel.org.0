Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C796042BC39
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbhJMJ6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:58:09 -0400
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:17025
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236501AbhJMJ6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:58:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOOPNIN7Mpo1w2etWC0yUTbug0hUR+L9HdNLO8fLvdR/dlY13453oJBW1ZpQ4fBaCjnLjI9WfkXhbd9IAr1x2q/u1q7yjE/klrexauM0Yo/q0Cq9ufjzIoAE0UhFpPy1zEKPl6JMbbmBzlfBXU1dHLU3bg4510x87pRX20vc9JIPRYqVVApjJlwdTTq5oeIIWbTWWIynz+2pqKF78midqHID3ISeUPgleG8TDGX4V0sI0BhEncJ+D/nZC6TX+2wzI9Q+bmMU618MdcMQ8khnGkxiZnN9Piqu2hPbtjSfEAbzc5s+7HJdSLVoUzKklD3FbsnNe+ZzWbTGMetztDJfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWc0CFVzg/PgNIWZBVlh/jVvPewaCvQUf57URFxxPJw=;
 b=YNYyDBLniFWBMDsOasTdNji2r+vLEBrwnT2SiSVofJF0exrz9CP+j9TZuUamml7MsW5VvVkTUZm0IuAdJa0IktJo/8jB6mHMsD3lCgZP+N3vNzkQbiuC/YEo1iBpFWjMTrqnGA6JcXV/APukBVebechLmwwSDL8UhmQI9NYp7O4IGQw08TI02J8oJ48ydvOGXD1sXxnB2pZkfqC7Mo2bl7bgjS64g3aQqBzWezqgfCmYKmkv3E+qlb06VxXo+AzXP04pNs+FkvPVtsDgkKdw/1Hts6TR09NJ/2py3CprkbmG4PEUjsxSe+RExfAS/MX1B3UHlMoRSp82wXIl7bSZtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWc0CFVzg/PgNIWZBVlh/jVvPewaCvQUf57URFxxPJw=;
 b=VkGwSYAWCO3OAX7CDi2MW+otrrymeHYs1ld21iFFORIuFu7R95VddUqqGABJiiLVHa+gT1xjsdjLHjq6JqiE0SkxxelfqJmJmEebt5V0dgxhNXRjpQTtRMmGhbxgnHdwjyMfpwKNvln70Kh//icEKAGiGGEp801uAncNkaDWx64=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB6018.eurprd04.prod.outlook.com (2603:10a6:208:138::18)
 by AM0PR04MB6786.eurprd04.prod.outlook.com (2603:10a6:208:184::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 09:56:03 +0000
Received: from AM0PR04MB6018.eurprd04.prod.outlook.com
 ([fe80::9556:9329:ce6f:7e3e]) by AM0PR04MB6018.eurprd04.prod.outlook.com
 ([fe80::9556:9329:ce6f:7e3e%6]) with mapi id 15.20.4587.029; Wed, 13 Oct 2021
 09:56:03 +0000
Message-ID: <ca7dd5d4143537cfb2028d96d1c266f326e43b08.camel@oss.nxp.com>
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Date:   Wed, 13 Oct 2021 11:56:00 +0200
In-Reply-To: <20211011125815.GC14317@hoboy.vegasvil.org>
References: <20210927145916.GA9549@hoboy.vegasvil.org>
         <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
         <20210927202304.GC11172@hoboy.vegasvil.org>
         <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
         <20210928133100.GB28632@hoboy.vegasvil.org>
         <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
         <20210930143527.GA14158@hoboy.vegasvil.org>
         <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
         <20211007201927.GA9326@hoboy.vegasvil.org>
         <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
         <20211011125815.GC14317@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0097.eurprd02.prod.outlook.com
 (2603:10a6:208:154::38) To AM0PR04MB6018.eurprd04.prod.outlook.com
 (2603:10a6:208:138::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SOPLPUATS06 (84.102.252.120) by AM0PR02CA0097.eurprd02.prod.outlook.com (2603:10a6:208:154::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:56:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc25c50a-d552-4a3d-4b79-08d98e2faab0
X-MS-TrafficTypeDiagnostic: AM0PR04MB6786:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB67865B06744AE67F2F8CB9DBCDB79@AM0PR04MB6786.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9iS7vklCaC4+yJ7UzEgQixaT8e+oBzOINDDYcav46gqv5Yha4QoFoSRPBmx+ptkywThfV0dKjy6kbCbbyZpJ62Xn41IWp2rvB+hIf28WhuZ6KYpZiRqB4N4gFd1OaASLzaIuG0GWEmNGOJkDrRDpnr8nLMkXg1ikRk5QxBEOSoUsUcmpAIwdDCTGm2wzVavy3Z1RsVbEQ4OoWPlEPf2ETZHHyFwGtbL5d2xkJYwKADxzgLidCC2KxsbKYBO8NfhgfKIqZfrdPF1iqX3ZPSHH8LjV60yG2ELEomTt6R5uTGfEORZLEsrccqrGHwkVVDC+jA9geLBWGXKFc89jDFW6HMLj/vw2VXMyGfWoXOKV8GrtN75VxLM2UeTq/VRjGNxd8aKvqMuimvCx5uoNUPHkVGaZ+vyvmL5p5kydy1xYcm5paf8Cz1OiuhRszSUNIbuMXe3+yW7cY7YGLFMKTej3lyvLQA7/oAlvbl88BBuTCAA/oIdHzOAk3DHqUKvb5PH0VjGmvrck6NLJGSOSiUHwcK34dl4qacgEiRJBnOEbS1PEsOAFTaTltjt3/XfnmSk6vna2SEorVwB2++w+Dj94/KTB8jwjW+YsUiLUXYj0EVhFRns+MrEdm7owP8tYmMoMKTo6jFWHrFeEh5pUfMgU8mBWN9sRNUlN8LhqpyIbzNCTc6AG9/LYL7ztRuN+lSk7VFtdhih1HSwdOmF72XFAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6018.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(26005)(186003)(6496006)(52116002)(508600001)(2906002)(4326008)(5660300002)(83380400001)(6486002)(8676002)(38350700002)(86362001)(6916009)(66556008)(38100700002)(66946007)(66476007)(2616005)(44832011)(956004)(316002)(4001150100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1BHam0wUGNWVXRodHlJbzB4bmJhMmFvNVNCWVF4eU5sb0tEa1FOVzh6Q3RM?=
 =?utf-8?B?ODFxUU02TjdkZnFzaFk4WmVycGxWeDNsUzIrV1JsY05ra0VNRGZ0dHQyVk9v?=
 =?utf-8?B?aG80ZXZIQjRCTlY3amlhQjJlVnNHcUtvV2RMSTJudktyM1BKdVlIdmhFNlVr?=
 =?utf-8?B?aW1pN2tDSWJoUHhJbndGT2ZVWEV0VS9lTGMyU2x6ODZlUVJUbHdaSGpTZVZp?=
 =?utf-8?B?SUNyeEFVMDE3R0FycGFGcW41cjJITDdxRVo5Ymc3azJkYWJhVFJKT1dKcUF0?=
 =?utf-8?B?eFVhblp1bHRXY2FVZzRFVUxwMURmVUt1NjQ1UnJMSGVIWHBHMHhlendldzdL?=
 =?utf-8?B?Tnhnb0RtZ00vcER3RHVIdVZyRUVlTHp5dEdJY0RxY0xCNkhNeE9FL0dsYTJs?=
 =?utf-8?B?bVVjK2lDZ1hwRVh0bG5NUUFhWFkySENXZGozQVdLa2xrYzZYUm5aSEZ1TGIr?=
 =?utf-8?B?RnZMTnpJMGdPRjI5aS9JbW1GZ2praTQ3NEUzbXpieG9RUzF0cW1NS2dXQnZL?=
 =?utf-8?B?dWE0ZHEzT0RFN2g5VW9SdkNCUktsbW1YOXA4TU9LTlgxbUk0eGVZY1BwNkRp?=
 =?utf-8?B?RlVCWVExa21KS1hITm53L0p5WHRhR3JaNVhLS0FPT2pVVG1pZ1R6ZmZkbG03?=
 =?utf-8?B?Wi80SENQMlZKRzdQQU5jM3NRRnJsRU1zcDk4dEc2dVd1OXJSNnJ1M2Raakdn?=
 =?utf-8?B?cnNTTlhzUEFqYiswcHB4aVFSamwvVEhKaHlyZXdOTXBPdWRGeC9VcFpaL3By?=
 =?utf-8?B?UUlPS2Q3WjJ4Q3crK3AwcmUwbzdSbXRBN09xZGc1RkRxZVd3UDZ3SjBxTVo3?=
 =?utf-8?B?ZVExNmk5bXBwT2JWajEzcTdOVFdoRlpUZ1BqSTF4alhuVEZoTGlkK1ZsbndP?=
 =?utf-8?B?ZzZkaXh0a2o5MU1nWDRSejNoSHlXTk1kd2ZweFFqS3QzbDBIc1Z4dzd0THlx?=
 =?utf-8?B?cE9JVE9GSm44by9GVGxqd1RQaWN5Vk8rMVQzSXlsTVdTMkN4dGtqRWVzOTB0?=
 =?utf-8?B?S3pJaWxyRXcwcmVPR3U3KythcjVyUk9VN3FDdXczRXMrTW5zRWJZVk1Xd3N6?=
 =?utf-8?B?TEhIQm9BSlRKU1AzbmVscHczdkN4UUgxVzd6TDJ5cFlqQzBqNHF5TkFDYk9i?=
 =?utf-8?B?MmhQamc1UGgrTWlIOUlaS1pZREFjdVBTY1A5YVJXUDRnMzcrS0xOWnNPT3BP?=
 =?utf-8?B?NTRVbEtzYkVIQXZ1LzdPRm84Wk5RV0Vxa1AyVDVYSkZIODJaRFFVSTZEbGRB?=
 =?utf-8?B?ZGZ5NG1oZDJmNHpZWVp0bW1QK2kwc2VNdURabTlYQzh4VnJSdk9JVGRTeHhH?=
 =?utf-8?B?SE44N0Qrc2lXclJ6aTN5ZmRtdGhELzdYUVcyYzJFQUkrbEdFK2JELzNQcEhm?=
 =?utf-8?B?d29qSkYxL2FoSWdNSWtXL25DbVVqbFU1eHFWRHJxajlPOGZkNyt1eEUyNFVM?=
 =?utf-8?B?bjJqdFVmUyt6ZWpQd3dyOVVhWGZ6NDVPL1FaL3BDWWMwNGxvVU1pY1IzL0Np?=
 =?utf-8?B?YWt5SURZZkd1WC9GNWVxcCtkNisyQU00MEVWdWJUUEd6UFhtR1kyU3FhQk1u?=
 =?utf-8?B?ZHRBbSt2Y2pGVWxMbjJrRW45eTduQ1hzdlYvWmtDc0UvU1NXeklLWXBWczVk?=
 =?utf-8?B?bG44ejFZY1hNd3BIYXZhOVVPRUdndk1IMGRNNnBaVDJXZzVHdHR2VGxHNE8r?=
 =?utf-8?B?ZVo5ZlY1MGlqNGNYdENEdXprU1RZb2ZMNVRReDZBWmRpNXViVWtXL1hJYWRD?=
 =?utf-8?Q?gFNJ0NRHhFRBEDX/mdL1PcRWfgyUQ4kjgVaMdfx?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc25c50a-d552-4a3d-4b79-08d98e2faab0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6018.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:56:03.0461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QWTYGiYq72Dz319B3BRsceelkzFrGWLzDAt9dZrTDqnENRDtFdtdBRXbNChGecO7/jBRLzlVjQWqK/RZ2z54GOeK8qLVp689xZGYrtMzRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6786
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-10-11 at 05:58 -0700, Richard Cochran wrote:
> Here is a simple example that has no solution, AFAICT.
> 
> - Imagine one physical and one virtual clock based on it.
> 
> - A user space program using the virtual clock synchronizes to within
>   100 nanoseconds of its upstream PTP Domain.  So far, so good.
> 
> - Now a second program using the physical clock starts up, and
>   proceeds to measure, then correct the gross phase offset to its
>   upstream PTP Domain.
> 
> - The driver must now add, as your proposal entails, the reverse
>   correction into the virtual clock's timecounter/cyclecounter.
> - However, this particular physical clock uses a RMW pattern to
>   program the offset correction.
> 
> - Boom.  Now the duration of the RMW becomes an offset error in the
>   virtual clock.  The magnitude may be microseconds or even
>   milliseconds for devices behind slow MDIO buses, for example.
> 

My proposal includes handling PHC offset entirely in software. There is
no way (and we agree on this :)) to change the PHC offset without
impacting children virtual clocks.

Done in software, an offset adjustment has no impact at all on virtual
clocks (since it can always be done atomically, not RMW).

So with, no hardware clock phase adjustment and limited frequency
adjustments, we believe it can be made fully transparent to virtual
clocks. And that would improve the current limitation of no adjustment
all, and would unblock the support of features like Qbv for devices
with a single clock.

Thanks,
Sebastien

