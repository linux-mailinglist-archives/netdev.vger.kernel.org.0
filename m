Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B14584671
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiG1TUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiG1TUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:20:03 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2086.outbound.protection.outlook.com [40.107.21.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C4E6069C
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fN9YuHyafAZJX2ty5dps6xk6iVTSX1rFS+U+Y6NEtB/gfABh2TLMAU4ya8br25/9S1rIiGVZKyiHq/904S7YT6iWS1QATQL5mZosXMrDqisoyaYiJpaME/KoaEz+aRg8lxEUFMOVzMMhmLuNQ3lcAWT9aO2s73/TKgPt5ir1lRFQwCvRyUxknQoTLWcPOcpwBmvY26LBmw7ljnQ83ajpBUqEaf/GytKgQrsD2/LH0eHTIYTrrjVLl/9JElcECKOqyqRkhot7ePUOGigGhGRAbKN5l8dIqIRBZrLOBKbRXAAxEHPnk/qvlTZ2FsWzGlue0KaVMrrTQ4JNvgUZGeSohQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BX1S0F+32T4u8an9RH5/15PcxnBofoDFGucpW/mqAA=;
 b=imwgmYOYq8lCGGWNP/RlmbjWdm8R9n2J30mlvq3lKJWzPtFZmjT4l+SHYXrJRfZuh1+YF+TM/pJaUUsUiOg8qJN4cjLiuOkbX//B6cIuTe9z2pNV5ptP0V5JYSXMMjsFbGSlxbrH9sG6D0z1bx/QnMut6UPC/vToq5gKEOPDryIRJBc11ELRRuBLifzO8mD6pMsuVxTQ3GDYD80Quw6sv0uEwkU2ndh20kAX0DGhUM6lx4eoA3tgU780DlP1zBKIZ8KEaSxHkxHMhvw5droxhMOSlXot7cxKyqE7wVmeav1hYIRRw2ZJa0EzqjIaYA2h9LU212Y1OPN7N4xJ9KU0oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BX1S0F+32T4u8an9RH5/15PcxnBofoDFGucpW/mqAA=;
 b=1ZUQrDh2wwpmhvNjayH/yOOiyXOc3Vak1dvnw64FWvOJlxpZU5/zaYR/UwbOZuINXf1Y+5jrWs+jmv8Va+S3qjx+oC9czJeUTNoH5gYQTDo3RW45iB19vKnSexUSYjGAT6fWW/iCYyYaJFAt8tA6nUgeHItAQwVSQQr/yENkXBWM8+sZLfPQe9bRDXMMbZI1Ueth90CJXEQBBNWzw93Gb0awXukb0AGFe/HvKt//ZJY9tL8xnhraMXV4Xzfv4j+2fhmv7RSDBTUPF95wSVf+cihwvlzm/OKnP72CfNhW9j12W2BYtfwEcJLryK7DCeIGV9qd4HA81K7STIUSxIiR0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by VI1PR0401MB2590.eurprd04.prod.outlook.com
 (2603:10a6:800:5b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 19:19:58 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5458.025; Thu, 28 Jul
 2022 19:19:58 +0000
Message-ID: <1d50fb2a-a1ad-10a8-8e15-1fdcaa47d5ee@suse.com>
Date:   Thu, 28 Jul 2022 21:19:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: question on MAC passthrough and multiple devices in r8152
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>,
        Oliver Neukum <oneukum@suse.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <444df45c-ec1d-62a6-eea8-44a0635b2fdf@suse.com>
 <837bd96f9d574d3db0a4b71a9a8761a8@realtek.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <837bd96f9d574d3db0a4b71a9a8761a8@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::19) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8566c5af-62c6-40c3-f4be-08da70ce2908
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2590:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGEgZp+oufHI/RebpnB3FNOzSO37fMty5Ea+iKACXWIS5I5rsLMcntrfImWRmaBdl39tffFhsU4VB3t7se9oBAjh8UgGc7wGHCMgoJJDEzEUN427oM9i4HhK6MnjTlkNgtXCACRDGcuGGUzvkymAW/7qST9BzCSRKUz9gDufsotKwsWfwxHBrN+6+V224VKPBa/JN+TR7XedVjzjlwotieBHK3hCTdHL+RDmLmJSNfcnVk1hMSCGetX+ByI199N+An98qmiB87+Ad4yMRhw8+fwE8U9JOAHPVr7WGRpzN6N5D9FlW27Bi0IJLZBK8nmADniGty67HQVQhfaiMJPOnNF2SdONJtHNR0r7ElUNyUVGLoFMnNsLIFAJV2PG20YqlORvkhvq+m3UTUqK53ZHDdOXMsAH6xbOIbrFLWSpapcUMPkcHrPFmLHhDBV0L381rV4yByYP6YR0NTEAI5KC5TTxzfCPPglcS/gip/uA+YeUv8Xo5wjZfdxDfXdCNvDneO5gI95mKLzU9J2+BeBnBaKvZIF2whBSdT7U6GzqMxA0bCAgmBi6zhzo8ro2k5i9jm0l5IlNG4MW+Wwu+kbQJ1wBqtqGt/yehCU2jeEPFAIXVTAMWOnM8TEO4oSiuypWjl5l0vrHbm79OTOCBs2U9uYGkKPurEaAE1boBmC6UuOlSfgFLVFRelC2ZXrg/o7VcVXIKkfe9VGBL0nd82gjvYoaFUtpsF8FU2E//zDfMAVGiGPEJtrCD/nn4YMQLvFYphr8g0tRVPf8VwAuCrLD2to/mmBlRQVVg6GcpakxnqZtfu1dM98qVTdOobNhkZaX1w/143gDcbgllk7/Dsq4Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(376002)(346002)(366004)(558084003)(86362001)(31696002)(38100700002)(66946007)(66476007)(8676002)(66556008)(4326008)(8936002)(5660300002)(6486002)(478600001)(316002)(110136005)(186003)(2616005)(83380400001)(41300700001)(2906002)(53546011)(6512007)(6506007)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXdiRTZYRVdxa3l5Y0NVajJpWTBKNlFnc1U0Z2ZzZFB2Z1ByRmc1S21hdEkv?=
 =?utf-8?B?MXdjcy9GUE9mYkNTcE5ub2dpR3hFVlN0MGtZQ0RuWXA5MjNvSldYMWRYK0dV?=
 =?utf-8?B?U1hnWDVBUWg1enZ3M0JVbEtCK3NqNnZIUy8renRWNjJ5cC9iT29WRHJ3eGwx?=
 =?utf-8?B?eWVBVWZzWDFKcHludWRKeWUwSy9IMTlVS1A4eTZ5cU1KenpmakE5TFVNc2JF?=
 =?utf-8?B?RHR2SWFvM0xJRTVYUEdPNStoMzI1Yjl6MFhBQUdIdjNKUjRaa212amtpYmkr?=
 =?utf-8?B?bVBZcTZyVmh6QXc5dm1pWVJVNmhvUEJ3NEFrZVVMUTlLK3EyQ3NwWHRja2pl?=
 =?utf-8?B?VFI2UGgzeGg0WWx0bWRqUHpCSUNWVjVLVTNQQXlQc3VBM2hobmhLdUV3Nms4?=
 =?utf-8?B?aC8xcHo2OTBKN2NBdWp0YlpERXV2elAzYUxEdXBPNC9mN2FlVVdLQm9YNmdZ?=
 =?utf-8?B?bCt2VWp5N2VRSGZtL3NXbnFPNGVjdVV0d3AyUUNDY0RQT2ZlMUl1R2RXYTlJ?=
 =?utf-8?B?dGpFT3k5WkZMQ3duTlo4MG5KYVF2Y1NtWEVUVmNLYUdHUVIzZFA2RC80a21x?=
 =?utf-8?B?Vm5EQWJSdkFDaTlTeHF6QmhrYktUNlMzWEZZYkowbXJRb0UxdmlyYk5WRHJh?=
 =?utf-8?B?aUhRQ0VVWktudFY1cU8yRUJKWm1FNUp1c3p4THRlOWxYQzJyK3FrOFBJc2FR?=
 =?utf-8?B?VENBUkhVNm0yRG9KZm91ZUJyY0grMHZXbFFZNkZMcWFuZzBOZFdZTjhJRnYz?=
 =?utf-8?B?VWhwNytrWmtiZHlBV3hUUThjdTR4c0xQaWJsSlpEWWtLeHVJNkU4NVloZ2pD?=
 =?utf-8?B?Rk9yZ3NraCtkSVpRcGxtRlE0ZnBZS1d4d3FkS1NWK2UyY1RqK0VOY3ovYndw?=
 =?utf-8?B?eExPWGY0d1NValdrZlJvMTJrbm9mNzZ4UVhOVU51SU5ROXRJTXo2WXl0d2N1?=
 =?utf-8?B?eHorYlZoZU5yTUdpOVNRcW0xYVFscjFXUE9Gcy9RYlN5ZEhrTWxMY0xjYnBp?=
 =?utf-8?B?MGU1SEc2UGVUWFRLMFg5dGF6SUFHb25QaElxMXN1dXhrOElwVWNsdjNwUGto?=
 =?utf-8?B?VWM0WTNmSElWM1QyNVY0ZThuend2QXI1N0NWUTJ1ck9ibjBCOE0ydjdjVkY5?=
 =?utf-8?B?Qzhid0N2S3JqaGZkeEJoejhlY01qVndsOHQ3dzVQNXZaaVAxYkE0SlVNcHFK?=
 =?utf-8?B?Z2RjM09PclJXejc0SFJVaDB6K21ETHE0eld1d3BJaHk5Ni9EZTBrNFZsSmxC?=
 =?utf-8?B?RGtWbmZzOVFNcUptZEVrQTArSEI4NUdPRVJIQ2I0QVR4bENBRkVicml3WTAx?=
 =?utf-8?B?K1lvbXFqUGNEaUo3QmpSUWpLQ2JXeXlwQlBFVXFPRW9wY0laVXFuM1hTN1VU?=
 =?utf-8?B?RlFsWExzUGZWNm9oai82LytZQ1MwKzZYemVwUXQ0NTZVSzRaZVN3aWx5NC9H?=
 =?utf-8?B?M0EzQnVRTFJOeEdVQS9DV3hMd3RJU05wdnJmSDNoNWd4WDJYK0NvQ3pxdk9W?=
 =?utf-8?B?TldGTlpoUHBEYmIwelF5T0pkRmFZS05uRGJYVzdVQjN1MEtZSU1pMy9FSG9j?=
 =?utf-8?B?UzVIUXM3WXdDTnNyRGpqM2JVQXUzTnY5eHRiRkVoRDZTZzNKQ1VjMVV5aGx3?=
 =?utf-8?B?NnQ5d2xVNHNqMHY4TWtSQ0VtUGduNzhXR1hOSGVyOXdjMmlGNVQ4OVYrbUh6?=
 =?utf-8?B?MzQyN0J5dG9PamtvZkhvbEl3d3VFV1AxWXB5NHhXUis3Z1U3a1FXUlgxYnJF?=
 =?utf-8?B?ZDkrcWpQTEJrdk4zdTErbC9CcStXNzAxUXY3eGd2M3BVclBGSkJycVhxMlJZ?=
 =?utf-8?B?Zy9OdUFvUkNVaFM3Uk9ObWh5YTlZeWg3TDVMR2M0aWdwZERKSVBqZXBGazBO?=
 =?utf-8?B?aERQMW1GZmplNEsveUZSM0laY3ZiYWxCUU5JQUVMQlNVUFN2c2RjV1lMbVJH?=
 =?utf-8?B?dEw3K25tWXFzQXIxejZmZFQ5TGhoc1prRjgycmdxN3JBUmY5Umo4WG1Pd0Mw?=
 =?utf-8?B?SVQ1RzN0MmdSemg4MWxjOFE0M3VIL2hoRkJTdFFWV1pQbW8xMFd2Lzh0WDV2?=
 =?utf-8?B?UCtKT3hBRWpHMFVBTXZjRmc3QlY0TE00VGluOXUremtub0xRVGduUEcwdkxW?=
 =?utf-8?B?azRXZ211dm9VMTE5WW51V3JrWTFYV1hlaTk2T2QzbEFtdVRJSWJzejhOaC8x?=
 =?utf-8?Q?/l86PDitX0hFnPKfMvpGEi4F+eitbVAbkCPc8lPaGtZQ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8566c5af-62c6-40c3-f4be-08da70ce2908
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 19:19:58.2560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLjfHw3/Sx0QuCo69FG1O6/gv+NwdZ8z9utvdaUHdFy6lFKkZ0R6xsDzl5ZGbQNIpuo1sAAXTVx2KPfF7BGDTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2590
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.07.22 09:59, Hayes Wang wrote:

> In addition, the Dell limits the specific devices to
> use the feature of MAC passthrough. It could reduce such
> situation.

Understood. Nevertheless, giving out the same MAC twice
at a time is a bad idea.

	Regards
		Oliver

