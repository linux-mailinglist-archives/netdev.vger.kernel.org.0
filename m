Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9D5589992
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 10:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbiHDI6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 04:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236811AbiHDI6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 04:58:01 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80041.outbound.protection.outlook.com [40.107.8.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793AA27FD6
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 01:57:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BG4zHjJWfdj5t2H3PxstSZvYUn4YVCVtrRZxzhIMTCd1ly3p+NxkflQjV5ViAAI4UhD1QD/OviPCuVCkgD99cy0wjj0Hg9LebZZyvUk9NYKaUomBOBXrj4t/jFom/iAV4kcLYQiPpUxxIOXyZDwv4n4cPIXW2ooqYqihlISJyHsthBUglamnlcukDGtONHANbXzS3/yteOLZuLdEXiM06e1hTd+8fauHc8o4fPx1dIxEmGgbOy9z9jw5NBouHJ4n7ZbtSiryaGn2ocJ0sFlVZLzmlj+qbyAyCfVNxm4albWSkyWyqxKpol6/HiXjJxnDHHxmPGFDdxHn6zWZ4L0Mog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STTUP/ybG2QODXyUTcSrOJgVVdy0fh1swyigNVFJoGk=;
 b=hRMgtU7PRHbhAdDfWjNAdGnyFSZxpFnhuqjObLmjZwztfFtqf3Zqd0NWg6NZxLonAIqtkxkG4d2XPUWLuoZG/GJOvLYA0+6dc4ZbXUgw9Erel8rLFMABtaFMuTn12+iBTdqGxhJdjOQUQ/PQIYVlCZ8rLcJbmXuT+k9GnAbrQuDGUc/Eaon7YGUmXod4eJJ2giXNqG+rF0JI+AlqsuAF4tBXuqqsJ5I0JRmB9i2q031DG5zLLjrxfVWOa7wgJKsC77gh32qH58sa/ER+PSngItOlxMl1jPFcMnKVS+4/IxEXoCvcs/915BulKrrfxK8HEmtPhMTSHv4RFrABNBMHNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STTUP/ybG2QODXyUTcSrOJgVVdy0fh1swyigNVFJoGk=;
 b=ItnWarSbvCqmSFW4ejS8Fx5IlBhujv/hYnDHUSiopKwwkyXNkl6zhtyYu4C19MqlFKZf7f8vTVo9uG8fWzorcSkLP9epzfPg9ovpM4l9OuIfBtibO+r9nC76SDsl45sgz0hQAFmMtBqd+eFDLBuFqRAT8fLt8AbJqu3sZrXxB6CGC0QWb+K5iISblm/2AV0tsYf91Ne7Im9awSx/hEpcb4xSik55vi+gsTwAQi3R0GSzOP7IYpIsVhByzqcAI2lNX5CWvCjJaa2/kyCoMl7KN6CjWNOAWjCdPaRBS3DLig++A4ov0vNZ1se2llW+5MeQEiI+wV8pm7S2VqwNxloc+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB7PR04MB4731.eurprd04.prod.outlook.com
 (2603:10a6:10:15::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Thu, 4 Aug
 2022 08:57:56 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6%9]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 08:57:56 +0000
Message-ID: <0c27917c-572a-7e70-3512-9357fabb458a@suse.com>
Date:   Thu, 4 Aug 2022 10:57:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC] r8152: pass through needs to be singular
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>,
        Oliver Neukum <oneukum@suse.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220728191851.30402-1-oneukum@suse.com>
 <0f5422bbeb7642f492b99e9ec1f07751@realtek.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <0f5422bbeb7642f492b99e9ec1f07751@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P251CA0012.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:2f2::33) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b1f7995-3869-45b6-7365-08da75f76c4d
X-MS-TrafficTypeDiagnostic: DB7PR04MB4731:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 80Yp146LyKarASkWqO3nQWmAHYT418WNq0aPCb83L3v0syCzSJ7ntKgceWbbLSOYdT0rzPVBdLf7hMI4wG5e4kbPnyUvWOJfzZHbLiSI/VhmnT9ApQghMP7zS5Ou2OFu3vd1PTsrV3x9QCe1odvIsNsR9sFE0xh2miHQgvyoZ/NokqWADIQyRKK7/hG+oHQvA4JP6mfo6SrM5p4sUMRVmdizf0K7snwECxIxCgjPjwQyoc+ujdY4TZNkeNKCtCRugKaVuw7CteNxIXHfTIE4XH7VgocMjs94YZKH1L7mizRbu0bCrXKjEBXbFqw8BAk/r8UTN7dqem79MpWgGKEZX7A+i1WDI486G61XRGXLifl60nkM4HKkvvU+CGJFXrHcy0U+wZsuNitk3t3bLuafm5jYTjhSWeiWWBDdytTZgTPRr6pKmO35Vjpo9Wb3+3KgRfjbr8Ryx0D37H5PLoR8KOHJ52iBMAK6bpBY9Tn39y0ZeeXje+QDfjx/Bpc0wyG2vOiiG9kCdWdO2yyHnzhg89X6s/Ig8GAi5OQfzSSSE5Wi4jskpv3NVcmX+/NKZOEPe49umhGoJdp8ssNJ4D06ZdsiBNJRDLuEUP7DP/WLuSnMSq2oZEYXFaIN8P3m3oeXOwGrpaZepJ56kcE5a2ik3i94+HSpPLcwqy2ipujJyInIYFYTK7+E51qodTnWQwzH+dtW5PpBkbuEJP/zFhkz9o4KHYKvVTOVTCu7zNxhxqb6G7AR0ekZxg9tt5UVdCpXCsdFXhRziAPOhPzVIofvepYM89cSNXOTLNf+Xa5nnPNOc0OJk6dGm5hjambo1W9V6DyUg1x/E6k4zTJZkj9jiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(396003)(366004)(376002)(136003)(186003)(53546011)(36756003)(6512007)(38100700002)(86362001)(31696002)(66946007)(66476007)(83380400001)(8676002)(6506007)(66556008)(31686004)(2616005)(110136005)(8936002)(2906002)(478600001)(6666004)(4744005)(41300700001)(5660300002)(6486002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wno1b0RrTy82UUxwUTI1bkdmWWtPbGp1Q2JLME5hb3U2TzRnSW1xZzUzQzBP?=
 =?utf-8?B?WVBiMmZrUzU0TG9GZ0dualRaYlVGTVhFTmlybVZqNVlZcm5QN1FWZjNTRjNR?=
 =?utf-8?B?M0ZvRjRtMGs2UEFiNUY3Wm1Lbk5DQzBrWURiSUowcDYrb1dLU1lFNXlrWnJT?=
 =?utf-8?B?RUdyeWh6WU54UGo4V2dvQkc0bm5SRmZlZ2dCMnZLWEVqdDBBVWxaSXM4TUNK?=
 =?utf-8?B?QVJ4ZnVOOUk5UlZkb0ZDbDQxT3l5K2xiNkwvZkg0VDlyZVZjV1RLQXIzOVAv?=
 =?utf-8?B?SzBVQkdtSkRNa2pKQ1U5NElrNmhRcm9jenpzZ01HbjdtZXk4cXpNR0RUT1pl?=
 =?utf-8?B?am52OTRyLzVJdDJrSmxiTFBORHlGbEFmUXppRm83NlRWcGpRRTk0YUpRWmpI?=
 =?utf-8?B?MG9nYXBkdHdGMVlWWEJ0YXc1bzJaZmpqMjdVR05nT3dEL1h1Z1dxS1p4N2hj?=
 =?utf-8?B?RDNxWW1pM3FLeEg2TmxIcXdRUUxLYVdBODE0bWxqUXV5Q2xmYXhKYUhOSjBO?=
 =?utf-8?B?bEdaUlF0QXRmYW5abVEvNEdmQzYxaHo2SnlUWDNSeG5yMWhaUFZKODJCUFJ3?=
 =?utf-8?B?T2dKcFhvQ2MydTBkdThkaWE2TE40WlFPWkZRVU9wTmFOYzVNSzR3cGtCRXdv?=
 =?utf-8?B?TjRBNWRKZlAxa1dPdnRGK1NPM09NL0U5eCtpbFJSU1IrRHE5aEI0Z2JqM0Vz?=
 =?utf-8?B?eG9hbG1FWDFUOXBoKzVBN3NvekRNS1JXY21PVzZQQlN3eklBQ0dYNzlKa1Fx?=
 =?utf-8?B?clJIanowOVA3WEd3U2ZsWGppZEZ0S0FGR1g0Qm1Bd2M4WVJiVE4yWjE0RERM?=
 =?utf-8?B?YU5QT3dncWRDSTlxTmdySnFIRE41b1J6QzlWZEY4dDhNU1E0aG5MZjhmd2pl?=
 =?utf-8?B?d3hZSlllbThLdi96R1hmM3RUZHV3clZLVzFJM3ltYy9PT0UzaE5KK3RSY1Bk?=
 =?utf-8?B?U2pvWFR4SVdFeXZaVnJ2cy9LZ0pFOGtrQTJpcUFVeDZ0MVhseXVDNVRYT2hU?=
 =?utf-8?B?NWh6K2xpQ2xjVTB5ZE1waDFFNjJRK1RJU2VOTE56VHFoM0lhYlZqd1RUckZQ?=
 =?utf-8?B?UnVRZXNQZTduQy9NSDFmOXVQdi9yNnlSSDdITEM0NVFsQnBWTXFxZ3BiUjRa?=
 =?utf-8?B?NWhjRTBhbDlXL0lQb0I1Q3IyNXV4YzY3U0NrTjZUMEVoaVlPeEdTZmV5c1Ew?=
 =?utf-8?B?czB5NDltck91ZENiM2llTGhaelpmTHp5Yk1KaDdNd0tsMkdyVU1iQXJlT0Ra?=
 =?utf-8?B?NkVmZ2MyQXJDcmVHdVpjYnZWeHZvK2tWdXVmMkNBc0QxMDFSUmlIUGdDblFQ?=
 =?utf-8?B?WkQ5VXpUeVRIdk1wQVZ1a0ZMSmZFdDBKVkxQRW51M2dXZStpa0lsRXE4elhL?=
 =?utf-8?B?NWR3c2J3dXV5WVpPUzVqdjY2NkhoOVNydVdxT0loeS9LTnJ5OE9SQUh0cEV0?=
 =?utf-8?B?d21NNFlNMks2YTh6YVUyc1NBMElBZ2VWeGhZVE1uN3RmajJsSHhwQ1BEYUJB?=
 =?utf-8?B?WVFDbk54S2JCZXlyaE1VZzliQndxdzV1Tm5BRWk4MTZoSEQ3VmxRSXA4SS9Z?=
 =?utf-8?B?M055VE1TbGhud1NMUk9IU2JLeVJuWnNKT2xCdjZMQlB3dnJIR2MwdFRQa2JV?=
 =?utf-8?B?cnNxOGF1a29SdStISng0QlVKQmJ1UWxOWWE0cUVRNkZmcUJLazd1SFBKL2xh?=
 =?utf-8?B?TkdmZFhBbFBtbTZHSHZidW51aVRHeEZ5TDNNdHR0aDJRWEpNUGVTMkl4K0hr?=
 =?utf-8?B?WXhwOTg4bHZLdWN3QjdkOXU0U01LMmZ3TWtQNW53MTEzcWtBNmtLNkt6Z1Rx?=
 =?utf-8?B?VnBJN0Qrd0U0L09SeGRGeGU0VVVuT0tISTdQSDBxSmxIamVmZW9ab2RyYjFo?=
 =?utf-8?B?VTR6eXpNbFZ4WUNvZHNKUnlTVVpORnBsWVhyeFA1YnU3aThJc1N0dVBkV0sw?=
 =?utf-8?B?UlU2S0lBVzhzWWhJeEI2ZnF5b2cvUWlpTnNzNTM2Rk4yQmt3d0hadHlmT1Nm?=
 =?utf-8?B?K0JMRkd6dHppeFFQTHlwVUhUTnFDZCsxdzBObVAwZGt2cnEvblI1TjRhTFRh?=
 =?utf-8?B?K0d2Z0dXM3RIVW9Dd3M0YkpFQnh0Zmlpa3NKRDZzUGEzNXIrKzhISXZrWUZ4?=
 =?utf-8?B?U0pSSWY0ZnE5bEFyZnFnYTY2RWQ2d2xEc0R1WEZ2cmdXa3ZJdXhFSFRZZno2?=
 =?utf-8?Q?JN9gwfTv67op7I7VZzNDuymGQ//H8fFrwvJcLB15WUqs?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b1f7995-3869-45b6-7365-08da75f76c4d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 08:57:56.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zjKjh4i8MdQTE1JnSNQiyr+fS3q/NhbrXwDHmM9ek6lEgTU3LZFtNrhmb8l5nhCRDEHd0Nau9/WX1iHGHNyFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4731
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03.08.22 05:48, Hayes Wang wrote:
> Oliver Neukum <oneukum@suse.com>
>> Sent: Friday, July 29, 2022 3:19 AM
> [...]
>> @@ -1608,6 +1622,12 @@ static int vendor_mac_passthru_addr_read(struct
>> r8152 *tp, struct sockaddr *sa)
>>  	acpi_object_type mac_obj_type;
>>  	int mac_strlen;
>>
>> +	mutex_lock(&pass_through_lock);
>> +
>> +	if (!holder_of_pass_through) {
>> +		ret = -EBUSY;
>> +		goto failout;
>> +	}
> 
> Excuse me. I have one question.
> When is the holder_of_pass_through set?
> The default value of holder_of_pass_through is NULL, so
> it seems the holder_of_pass_through would never be set.


Hi,

here in vendor_mac_passthru_addr_read()

>>  amacout:
>>  	kfree(obj);
>> +failout:
>> +	if (!ret)
>> +		holder_of_pass_through = tp;
>> +	mutex_unlock(&pass_through_lock);
>>  	return ret;
>>  }

	Regards
		Oliver

