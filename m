Return-Path: <netdev+bounces-11902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D0D47350BE
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF8781C2094D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C59C150;
	Mon, 19 Jun 2023 09:46:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72C6BE6D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:46:29 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2050.outbound.protection.outlook.com [40.107.7.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725BEDB;
	Mon, 19 Jun 2023 02:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAG/Qv/Fvw+3mR6uI6AFiEjhOCs+Y+7matZG3Ep2b5N7EbIzSOBuebEZqUPCqbHu89+Hq5tPP8p/cTtxoV/yQqV+hhixCQA6FSFs32UG2KORPnHV4VxUdlRf/85A3TYpmU2eMoFd6R7oSzNau4eaD8W9eD1dMon2PZU8dy4aTRxZ9NLGVafUbMFv7wW9Kh0rh7wJOER36pD50Y2FkwBRBIDn7idUJ7LCVkliVn1aFj1RovUaMedsCj4xz7v28raDiPt741dEuQx3zoBqgYg/RkL8jTOKh3rGihd64Pyx7LJjrrB11cmE/ZEgvb2UhmxR1s4UD+buZrlhiXnRkmLmFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVzKKd5BwH+quXiUby+N5gP3+mo+IY9ldK6NnQXTpTk=;
 b=oAp6tVFbW3w9DHq7+VPsoZqIFUbfpFRAVW1Srsw0pp0mT7e7rjzvcRwHWJcrHa6rEGk60mFTevo8VkzLxYPwz91qFHoAAEFxDK7Tf+Sr3rlCGkw1Mw5Ul4ouVWk2wc6al7GnWaCKXtGZvdGAE3mSiJvA74H9zoGHRrf+1OkDWE6SEqlkEwKtPRKN01dQK8J/V3X6IOWyqPZ5esM8RhyyqwSSOqzNO17NEVXv7hDOpZeEBw+ig480NeKiYUaR28BRSk0YXGPm9HEtqHOidVhdN/OITo+XPfzGVrA5FLwuW2kPP0FfsgZdDfqJRMeveUjX+xzULQAsNigJ2Ue/vMM70A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVzKKd5BwH+quXiUby+N5gP3+mo+IY9ldK6NnQXTpTk=;
 b=AW0antfqN8jwRl0vndDK7Aq8D7EGCUXsXvoCsW08E2Rx5gQqC4JMGruj819fee9f8/k5XkTD4nCxwztfbz1pZTMJjr9Hl8aBbLXUi8tJup7TsyXZmuV18kfSfI+nE3bvnWPZbrDm60vytwCGOvHFRlzhQkG/5F3abh0mbqLYZLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by DBBPR04MB7914.eurprd04.prod.outlook.com (2603:10a6:10:1f0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 09:46:24 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:46:24 +0000
Message-ID: <7eda291f-1e2a-1af6-ae25-785b6eccc281@oss.nxp.com>
Date: Mon, 19 Jun 2023 12:46:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v1 14/14] net: phy: nxp-c45-tja11xx: timestamp
 reading workaround for TJA1120
Content-Language: en-US
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, richardcochran@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-15-radu-nicolae.pirea@oss.nxp.com>
 <20230619085831.dnzg2i5mqysc6r3r@soft-dev3-1>
From: "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20230619085831.dnzg2i5mqysc6r3r@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0024.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::16) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|DBBPR04MB7914:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d1297a-c1f5-4c06-5e95-08db70aa0b24
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qjzQDJY34q8Y9tRaDs+910hmCOMLfzdtnSSKg8nivDoSWsmoER5y6XNfKBJMi0QTB2NVs8Zh9mfiOhvrPeCSf+4UvtunGo0HXzrMcjhO4lMWq1L8cAp8V35RtEeFLqZaGlKnqSPSb3QlIFMowKGdlfcQLb2QOI2SHR51dw70v0Ye6Bh2H+Dvuoe6zLStLaR0tFXBFw2+5P8hQUAH6PfXsjkKR80uMNOeHTbCESom+hVl69/mh5R+8lurlJhX4xRGWNOw6Uf2+4p5AuUoSGjIZikzZURDo252LRcIKb5vKaeZwEu+nI1lUiKRU3PhMl8pvmqjcxZC0MnxAVHTB3SUm1niuuaQCxAiDRhaxwqMIWGABa1B2+5a8adM3lULsZst0bk2zXO5QMnYEPz+nc2EdcquFzKK+ucRRQ7dsxz0ujuW/sIAwCl1KC43kF27Ke5F9wrPlZ4mr0mMSCP/5iJYcst6RO6Ha59NOqZ4mNftfzGqUwcB2CHIJY1/K9N85h5a7TcoLF+Z/Td/QE6xSKSGWVR/yHRWfd2VHwTqjKA+IVSrPOqQzP38UX44d+n4pHL/c3o08IuzGXftJVtCqRW8bumpwx64oP7caHLdW7XLr9uBdjvjyDYYk3E5JlJ97tATVcWFI4FT/+HCB3XP3yi37A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199021)(478600001)(31686004)(66946007)(66556008)(66476007)(6916009)(8676002)(4326008)(41300700001)(2616005)(83380400001)(38100700002)(31696002)(6486002)(86362001)(2906002)(5660300002)(316002)(8936002)(4744005)(7416002)(6506007)(53546011)(6512007)(26005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDZEcWhxWU1lVFg1ektWTDh2QXNNWFlFQys3cXZOc0E3MjJrV2RzWDRWKzFW?=
 =?utf-8?B?c3hTVmNmS1crZ3Q0bnVzdDVhcmtWcWQwYjZxNW1uYk1Oc1JTaGxyYW9SenRa?=
 =?utf-8?B?cjNhWGJyZEptUFAyS0NMSU9kS0NZRFk4YmNSUVhXS2wxSThXRkFqa3hVZ3oy?=
 =?utf-8?B?RlpRM1JIVzhzNHVEY25PRjl0OStPQm1iOEVEOC9WMGxFU0VQbGNoNm1GTDJt?=
 =?utf-8?B?MFRYQUV2aCt2NjdqZG9ZQXJEcHpoNXZiWTVEWEFZaEo4ejlkTEcwZVUvSzFq?=
 =?utf-8?B?RG04WE5LRFkzY2UxbzQ1UG9WWVduVG81b1RrTFlQaFN3ZmZIbW8yL0txeWtZ?=
 =?utf-8?B?WTlYM0FNQlRwUVNjUDJGTS8yMHNXSFVoTURhVXc5QmFwc1MwUENxWFR6QkN4?=
 =?utf-8?B?TEJPV0R0WXNLYWFxVGlWblpYK1p3Tk84NklIcjNwVFV0Mi9UTHByb0ZVeFdV?=
 =?utf-8?B?eS8yVEQzMG4zNzZqL3orRlRSbGp1S0ZGblB3SnY4ZmFrZXpSc09JOHFTNUlz?=
 =?utf-8?B?NElUZ2duYTZncThXMUx2VU1kcTNuL2tRMVdlUzVYOGJnZkM5N0poZ1JuMDBZ?=
 =?utf-8?B?em0xUGJnNzN4TyttYTFCdDNuZE1MbWRQdXNsWlYrU1lTQ0I3TlU1RWVNV2Ni?=
 =?utf-8?B?U2tTZldzZ080dE5kVE5RNTNsckxUdHFQZDRaT2ltYkVhdXEzR1ZSQlIxQzJL?=
 =?utf-8?B?UE9DeEgrS3BkbnhEVkNkQkF1Y1hEU0dZekVGWUxwOXdORnoyYVZnN244YzRH?=
 =?utf-8?B?VVhSU0RDY1JpZFhzTGtLc1plclFYUkRnMzdaOGZVNWFtT2FMbUpScnNYWFhF?=
 =?utf-8?B?djFPSndIUnF4aHZ5VXROUFBIeXA1QVBmVlNUT2Q0aGxGM1UzZ3F2WVc1dFFD?=
 =?utf-8?B?c2lOYWNSZVRuQzI1dlVxK29jTSs2S2Y1L0d3Qmdpa1lhZW1VQm54Q2FTMnd2?=
 =?utf-8?B?dTFtdFpTNGd4TmJYRkxJT040UGhQTlpCRTBIemRFVVhQOGQyODJuZHFXZmh1?=
 =?utf-8?B?UkpXWHIrcWhoSjJ6NGFsMnRBY2NEei96SlZVVTV5Wnh0RGNEdmMvK1dnU0xF?=
 =?utf-8?B?eFgxZzE0UElCMDZjeDVpdTlUazQ2MnREZ0lwa2UrZUZYb0xXTmJIeUFPUEV4?=
 =?utf-8?B?aWs2NFMvc3ZDdU5tSkdKQjhEeFJ5TzNiMzNML1d2cmttWHlEWWloWlpMYnFl?=
 =?utf-8?B?b1pMd3ZITVlXUzdpTkQyMjBxNXBCVU9ZTEpVNHNmMTl6WnZiUi91eThVMmk0?=
 =?utf-8?B?ZGNSTWlMcDhoMFkzUE9sSUJSYjV3VmZvQm5XejY2c1JYYndYYmtVbDIwS2hv?=
 =?utf-8?B?bnBPaFlTTXU1UHd1M3hmYUJqUjVrdEhxeStMS05jZkF0Q2k3cGJJSXBKSUEr?=
 =?utf-8?B?SWZxWVh6dUdJSUlJSDI3V0U5TW1Ta1RCOHRtckhKUU5pampUZnhuKzdhZ0lK?=
 =?utf-8?B?YzhmTnZYZEhjUm9oQ09qeXRJRXRYeGltaXNncEJpWENVUDZWVml2eXVmWTRC?=
 =?utf-8?B?Z0dGQzdxa3FYY0hFRlBYRGxtRi9xN2tWNXNtakl2YnZlcVFQekN5ZyszZVZI?=
 =?utf-8?B?ajBYSXhuQUpDWERzdlQ3OEZLcVZ6cWpBeEVSZmZ1SjJhdityaG9udjNmY2o1?=
 =?utf-8?B?MW00Umt4NmZ5aWNabVUyQnVVYzR2eWl6dTNSb1VscGRQenNORXVCcVlzNE5H?=
 =?utf-8?B?bjZMS3RKbDN4VGpSV1BrRHZmT2pqaW9pb3kxTkRYVU9MVTJSL0hLNnc5NXNt?=
 =?utf-8?B?MnhGSUFsYjM5MDVZdWtFcHA0RHhSczMyUGo4WGNCV1BMeWpoMGtoL0piVThv?=
 =?utf-8?B?MDFhSFNEQ1ZPRDlURFZUWlc5WGRqWkh5N1QvNG53OVdJZ0x0cUhtUmw5bGsr?=
 =?utf-8?B?VWVKVlhXek10Qnd2OVZHckNZVTZOOEJjakUvVmNVU1JpT3ZpcVpEcCsveDlv?=
 =?utf-8?B?Zmg5amY4c3loRDRFT1Z3VVFvUkZXNHpjcms0elRza29wS2YwcGxZMjY3RDR2?=
 =?utf-8?B?KzF1RmZzVzk2dHVORHVlUVUxR21hNzZPaXZLa0Qya09jeXFFNUxNZ3p3VWVz?=
 =?utf-8?B?WUVMWDM3ZjJXWWdRRi9EcXJSL2tUbVhMcnAzTHpNdHc1NS9QMWkvOVpvNTV0?=
 =?utf-8?B?VU1SaVA3TWdyaVZibS83OXNSWU5ZWmF0K09nOWg4d3ZldlZmc21McU1MbVZi?=
 =?utf-8?B?bkE9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d1297a-c1f5-4c06-5e95-08db70aa0b24
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 09:46:23.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LA8ZijIyJiiYwVZCe9rqGb/K2yazjf7SMApWInqkV5wDDDRnijBeBNF3p67w26jdEeYp4BPpuOFCAZRh1Ww1aEltopl7dw/TKwzK0E0FNyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7914
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 19.06.2023 11:58, Horatiu Vultur wrote:
> The 06/16/2023 16:53, Radu Pirea (NXP OSS) wrote:
> 
> Hi Radu,
> 
>>
>> On TJA1120 engineering samples, the new timestamp is stuck in the FIFO.
>> If the MORE_TS bit is set and the VALID bit is not set, we know that we
>> have a timestamp in the FIFO but not in the buffer.
>>
>> To move the new timestamp in the buffer registers, the current
>> timestamp(which is invalid) is unlocked by writing any of the buffer
>> registers.
> 
> Shouldn't this be split and merged in patch 9 and patch 10?
> As those two patches introduced this functions with issues.
> 
Ok. I will merge the workarounds in patches 9 and 12 if it looks better 
to you. The intention here was to implement the timestamp reading 
sequence in a clean way and to add the workarounds later.
>>
>>
> 
> --
> /Horatiu

-- 
Radu P.

