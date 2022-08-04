Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AFF589CAB
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbiHDN3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 09:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239585AbiHDN3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 09:29:32 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2122.outbound.protection.outlook.com [40.107.114.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8293315737;
        Thu,  4 Aug 2022 06:29:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dp2KaLKngJxdXSKlqtg4H3eTFG9wVmpAtVnc44X548Sdjjncbs/drzSUSnPrpox65s00/S4RF/FRspuP9l3au3iObToG4smtKicqHnkJafdNBYG7+csl4XyvCwPpkAL9mARInW+8NcEisDRaBdWH96VBmA51M/e/6q0/z9QyR6nixXub31Blo7e3kVSdVG0URg0oD+c92awK4B7cmE9kuCFEPRPJmTUTdYNJhSsNA4Nu8H6L+urwu+yhf6HfGVhZtxeQveihhj6Vl3a0snNE/aCEYtGM0WwLBZjWwUzBD+x4jP8WhbibSPLF6K4eTBKQ1ruK5QxXDl+uVKulUm0cnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tPMteK9hrqrlCQ79TDN80HHfMJq1+xgg6OO+soxrJs=;
 b=hd6TQyLlc/Ssqa7RNC6cFMuiV1K3JTupdp8lj+Pc42NIEQHbOOEIGtOedn4iY3cGCEcdFwgo+97qNXpuyRAQTP9iKub+gN3W0/UiP+I+bAI5Jq5R1DmqzBLPYTmbo5o8Bo+lvXYBZVmlb7g+yDJqntf450nDhPx6VQKdl6C6Ow73KlQSXlNCDMSnm4mUGsSdUNGvXgbF+QEOkC5CA3LXqMP/yvVgDuPqgur5PU+rNZFYnN+6tDfiyN0QPr4sW7ulOf+BGiPj8HdWX5vjW3D19uZnESZDT4BzoS7lPz81JfNr3+dnFG1ZwzLyDBICp63P2+8iOpMaW7vD+Q4emti4dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tPMteK9hrqrlCQ79TDN80HHfMJq1+xgg6OO+soxrJs=;
 b=Z6fX3zd48NjwsdNqtfoMUU1SawayR42zQ4mKyNi/vguDk2Dhx04ZJSUK1bYZQM942ENiWe8HhytzxrZEvjtMT0O116b698HsG7SD8q0QPPPduCph5yw4Wg5LTD4ObjCftuHstvPo3Zcz7YRZDWMgD5CrpjLy9o5Qt3jqY82gZXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6967.jpnprd01.prod.outlook.com (2603:1096:604:120::12)
 by TYAPR01MB2175.jpnprd01.prod.outlook.com (2603:1096:404:1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 13:29:29 +0000
Received: from OS3PR01MB6967.jpnprd01.prod.outlook.com
 ([fe80::e9ef:75cf:65eb:d828]) by OS3PR01MB6967.jpnprd01.prod.outlook.com
 ([fe80::e9ef:75cf:65eb:d828%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 13:29:29 +0000
Date:   Thu, 4 Aug 2022 09:29:05 -0400
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Aya Levin <ayal@nvidia.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/3] ptp: Add adjphase function to support
 phase offset control.
Message-ID: <20220804132902.GA25315@renesas.com>
References: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588390538-24589-2-git-send-email-vincent.cheng.xh@renesas.com>
 <228ceba4-47a8-49ef-994a-fe898cdc7fc1@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <228ceba4-47a8-49ef-994a-fe898cdc7fc1@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: BN0PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:408:ee::29) To OS3PR01MB6967.jpnprd01.prod.outlook.com
 (2603:1096:604:120::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cae4db05-92da-4824-8bbb-08da761d5ba6
X-MS-TrafficTypeDiagnostic: TYAPR01MB2175:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pomyzmWM0VgRrD+lxhbNViBLr1k5FUJ5jNV7HhI5bLrxxtRpPRvJBsOUg08n8Bbbwx3XEXqdWnfaaNWhgL3jPysKgwtYZ3bPw7jazIhfGuVQQHAKKlXzWFycwBHEcnLRvHWNykqJbCE4d48dxD02fT2MPPQD6xYsyNJqhsoqpza5cIzNYkaNifB7Yilk02Tnx7UnM5UlYvvlL9vSQYFtrf6YbGtcFoBQ/6NpJw9QUrnB6f9bMSBnqzPTKwmxaiWDCoV2FfnKrwqdCrZpNyLIdjMxvoQCdclF54Vrp/VScKtXxj50WKmXNF0K9o0Ncpm6T++LKYVaSsD5cpsVMSesR4zul64PWahRwoz4rUgX28amDmEL2kI2eIgDN8oSKB3Ot71MMu5iEq2Hf4EoABFgmNtZJx1BjzhRIuBq6yIzkRhsL86Pb7MVGYPAfZb9rD6017A0FSlvCnPiperUlKx3yFz17RUuGeOb11Gv02UFOqHF20H8+KEpPMMKiTVJb16ar+fPNyQapBmvqFdS8/je74laPSBlcsk9UN8dUqDx5EZAvwWsth3jQ22I7ulVrEuEe0GdUgwqCUH+lTMsrqRE/SxG/4pqJsdsVAHKLjJde0ykoxvF5biRlYeKlr4AEnXDOqwtipZVn43WqjoUQLOnlDY9qOrK0j9XC7/oSjMpG3R2112s31Y10pM00shzIMB8Ph32bwzzIVtlGJEG/keXkBWkXggty7F4ixEi0PpT/idPjIQYPgB5HKr4r7aD8haNZ4954obwF8NK0zd2CmHxomIgCUAQcGVlZUX0wMlhxvMw0tKfJJ2iMttshvitsOZT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6967.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(2616005)(1076003)(186003)(52116002)(316002)(6916009)(38100700002)(41300700001)(478600001)(6512007)(6506007)(6666004)(86362001)(26005)(2906002)(33656002)(36756003)(83380400001)(8936002)(4326008)(6486002)(38350700002)(8676002)(66556008)(66946007)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXdibURqVDdlRzlOcUdzWDVwVVlQcDIzK3ZrRFZmb3d2VjhOMFBaWnVHVHc5?=
 =?utf-8?B?bEcxQVJlSmsxRHhIYTc0b0NrSG9YRGZWUC9ZTldEQi9yUFBqMEJEbkxyL05h?=
 =?utf-8?B?TzdXckdQZDkrSlhHMjlmbnFnN1ZxU0lqTXQ5NmpNeGFCMW4wKzJlZndGMkdN?=
 =?utf-8?B?VHlvZk05cGdBTWNSQkVFOVJ2SzZxcmZySjhtMkhXRDNIWHpvYWdabzZ5K1dQ?=
 =?utf-8?B?cjNxdkZtTXo4eEp1aGtoWE12b1RIYkNFYUc0VUJKR0tmdXRxRzU2Q01BMXN2?=
 =?utf-8?B?Smh5SFBmSjBZM0dudGdlTVR6Tkd1bzV0TnFUOTZHbDYyL1BwSHRNdmtLWVhY?=
 =?utf-8?B?dU01NzlTV0RSbmNkQ1Q5S3hkd2hXdS9mK1lGZGN2Qi9KZ3RkM0NDTTQwSmYw?=
 =?utf-8?B?MTlyc0lia0NIN1haNEZhOElhQUUrNUpxYXNCT01BTmVRRDJ2c25Kem5JZW1y?=
 =?utf-8?B?V3lWRXF1Rmo4TjRROE52TnpoNWdEb3BXL1lmeHN6NnphVGJ4OUVZaCtwYmdH?=
 =?utf-8?B?SDhvRnNKSTFrclZUOXkySk5jSExLaDg4c0tPa2I0VUpxMURlUlY3OWV2R3lV?=
 =?utf-8?B?a2tWT3E0VDltUUNKVXZ2cTJhaW1GZ3VvUURDUktTOGFjMnJSNFUrOUVCYitu?=
 =?utf-8?B?WHNSSzNXcDROdjgyb0FZd0daMDlKQ2t2dVMxNEFJRWw1TkY1K1Q4UXBqTmVa?=
 =?utf-8?B?QXhDSjg1YXVuYW9HQ3FmbW0zUVExcVZCc3hVc0Q1VzhTajdWVjR4YVRmNDhs?=
 =?utf-8?B?bGVuTmY1UEtoV2Ywc3g1cEhKUlNtcjhzOUNFd3IvU0Npc0RSWE4wb29Ba0FW?=
 =?utf-8?B?ZTFSMVFhbm9RSnJqejlGcnRaSXdpQWJOVlRSQzZXK25TRlgzTmxPdWpqdzZE?=
 =?utf-8?B?V3did2dJSHNaVHh4YnY3aDZwZ2c3dkxzeWZoSU1MNmZnbnRtbnk3ZFhaOTdT?=
 =?utf-8?B?K2VoL0Z5S1Q5TmZQV0JmRzBSUEp5MXFTVmFHZitLeWJZbG9kYjUxUG5wSXN6?=
 =?utf-8?B?V0tYcGRBSkN6WVpvUlJkRVlmQ0NtaTlWRFhCcElDQjhWRWhMaXUvdWFSSkMv?=
 =?utf-8?B?Rkk0L2FnbmMxRGpsYjc2VzhWUnRtWG5kTWJHZTVpVkx6eUdOd0pHUWtQSTli?=
 =?utf-8?B?d1o3R3EyLytNdkdRMS81SlRMSmJqMXgrTlZSS0JRQVNzemlkTGNzdkFYRmJa?=
 =?utf-8?B?SU8wdUozb2kybk9Ra0twZlEzTWtmWHJaNWtrZU4rUzg4UUdHekNZeE9RREtL?=
 =?utf-8?B?OWl2bnNxQVRBMFAzYmJrTytLN05xbDkrRHFQU1dLWklrQjdCd0NlQzNGTkxO?=
 =?utf-8?B?L2ROMjBhS2YzWHhWa2Jqa3FLaVVpVVFWdjdNZjR6Nmx2LzNzOFhqWndScUJs?=
 =?utf-8?B?NUFZOXRGKzFnMnhjUXVQVm1WeHBzNGVZRFB5aXdjWDBhVU5ZbC9aRjhtVG1y?=
 =?utf-8?B?QU51dkY0R1FQeExGendsdkVuN1Fxa1NVWVhSQ1NuVkRLM1cyZzNsTTdSWTZa?=
 =?utf-8?B?TUsrT2orU0JpSjFjcUVMaFliM2xVUjlTMHBIUDZYZFhTYms5NFhKclNBOXNI?=
 =?utf-8?B?NitzL3dZdUZTd051bk5LUmZzRHo3NWpKV0twcnlPZXJLZjM0WXZuak1yeTV3?=
 =?utf-8?B?d3ZQWkM0NVVvaEFaQS9KQVdhOUUrakZqbWpObWl0dHJPbGtrUjF6Z1F1YStJ?=
 =?utf-8?B?VUFEMDlMY1BkY0Y5c0pYMUlKeVA5bHBrOEZ4c0YrbGJ1eC9xZll0cnRWc3VJ?=
 =?utf-8?B?OHkwZ3hNWUZIQStJeG5BeTVnRm5ydXloN29uZGFBVGExNXYydlMzK0FESHQv?=
 =?utf-8?B?bzJRY25FMHk2UXJtcG1UQlZaMUZZenBkWGVldzFOeVUrakdDenBwNEFzY2FH?=
 =?utf-8?B?ZzlDZFROSkZ3Y3AvWmRCajlOTzJWaXRSZ2doNk00YWNwRGNzcm1jdzlHenNU?=
 =?utf-8?B?Q0ZMYjk0M05Ic3RmaHB4QjY4TXorc1lkRk45YnhsUVJTSkhXeWVMVTNIcjV0?=
 =?utf-8?B?dWFVeUROTlYySmV1SlBjMHFPdXZGdTFPbDg4WDE3UFdrc2x2VEo0dmprNWcx?=
 =?utf-8?B?bFlkWFJINHE5T1NZNUxjeXdRRjRhUTVYQWZIQjdQb0RnMzFuZkh3SEc3c3BW?=
 =?utf-8?B?UjVuWkxJYjczU2VvbTFqWDgxbjJKRHRQa1FvYzRpT0xsMU05RzJYUmp6cWJT?=
 =?utf-8?Q?KV0IiktQY2m97gb0mGWe0YQ=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae4db05-92da-4824-8bbb-08da761d5ba6
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6967.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 13:29:29.2918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMmfFboYyF+KlVgTydVyBsXGDgc2u4CW5TYuuRZNqkdnXBtDzk9HVRDKTakKcUbrhWVytEAvS5aDFjp8mWQFG3YCo+8OezVlhgxc5gR8d8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2175
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aya,

>>+ * @adjphase:  Adjusts the phase offset of the hardware clock.
>>+ *             parameter delta: Desired change in nanoseconds.
>>+ *
>>   * @adjtime:  Shifts the time of the hardware clock.
>>   *            parameter delta: Desired change in nanoseconds.
>>   *
>>@@ -128,6 +131,7 @@ struct ptp_clock_info {
>>  	struct ptp_pin_desc *pin_config;
>>  	int (*adjfine)(struct ptp_clock_info *ptp, long scaled_ppm);
>>  	int (*adjfreq)(struct ptp_clock_info *ptp, s32 delta);
>>+	int (*adjphase)(struct ptp_clock_info *ptp, s32 phase);
>Hi,
>
>Please explain the difference in the output between adjphase and adjtime. I'd
>expect both to add delta to current time. Am I missing something?

Yes, both add delta to the current time and the 1 PPS should arrive at the same location.

adjtime modifies HW counter with a value to move the 1 PPS abruptly to new location.
adjphase modifies the frequency to quickly nudge the 1 PPS to new location and also includes a HW filter to smooth out the adjustments and fine tune frequency.

Continuous small offset adjustments using adjtime, likley see sudden shifts of the 1 PPS.  The 1 PPS probably disappears and re-appears.
Continuous small offset adjustments using adjphase, should see continuous 1 PPS.

adjtime is good for large offset corrections
adjphase is good for small offset corrections to allow HW filter to control the frequency instead of relying on SW filter.

On interruption of timestamps, adjphase HW can hold the frequency steady better since it has history of corrections.

ptp4l will switch to adjphase only if servo_offset_threshold and servo_num_offset_values conditions are met, ie. when offsets are stabalized below servo_offset_threshold.

adjphase is most useful for scnearios with minimal PDV.

Hope that helps.

Thanks,
Vincent

>
>Thanks, Aya
>>  	int (*adjtime)(struct ptp_clock_info *ptp, s64 delta);
>>  	int (*gettime64)(struct ptp_clock_info *ptp, struct timespec64 *ts);
>>  	int (*gettimex64)(struct ptp_clock_info *ptp, struct timespec64 *ts,
