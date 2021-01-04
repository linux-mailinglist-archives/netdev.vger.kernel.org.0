Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2102E945D
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 12:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbhADLxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 06:53:07 -0500
Received: from mail-vi1eur05on2097.outbound.protection.outlook.com ([40.107.21.97]:14305
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbhADLxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 06:53:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/C34LiYcl33gZe6DN3QgINt/+y4QQtquX4cCSipXgOy4aNhBZmAeR8XiWOW3BHhkV5k3KvMsplzM30eFqsxkweyJIM5p/Maj2vae4ya6OnjreYB67+qb0mHADdQSW/P668YJ0tcwYVbabGUQXkMYWsGSce/lsh+Ok0AVx+MZWupiOk59QQYYWILVr5AUCZ/Fa4PLYoLEpyULfySMzi2HDFDIfbYJn1/pDYxA4L/6Y/w+NvMQlABWwQ12rv0AYyW26mXAVR4/pWYZTZjuYLW1tw/qob8F0LNSqYUzttqHJYcQhXC8kOxx7EA5UCJy1hDzVuDxLuh+bQvhIZkIRlgow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ojXxGxngabUdmSAPJdfqC355CI4Mmdzr+l8xvcpJMA=;
 b=fkxaTXU081cB/jlYZD4IO8X50fXYv0FYZhbYc+ObG+QPtAcyupjfJdmI/suUaOWReal4qvBfZz/cyy+dFmXuYZ9UUav9gOXScxotCHwXuai9nuTQqkccK241/9h8277vuS7NuPZrnkLPRIZPavp+ZnNoaQjwcob3yBGRQ3lxT2LMxPJX1YhMgc5/Whdc0MoaMXlUNv70q8F5vjY6vleWaz1lAXVx3dGjG2timgKXg21pyOg10pQlH8BTMlfkgSpb6JgdDXuk0qrjJmIFy5TLmz+OLjqh4QtgDvPwqek3dsY7IcN8TWuOt88OG988irkBpt4kfjKDIrQU+MIBtsRTXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom.dk; dmarc=pass action=none header.from=silicom.dk;
 dkim=pass header.d=silicom.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ojXxGxngabUdmSAPJdfqC355CI4Mmdzr+l8xvcpJMA=;
 b=o4UDbRL4/f7DtCAXkrSwsyqm5+QGKaWYBvGkrjTF9z7gFs9DeBSCrnkrdSwnPd9ynoZTa9HmQKX63nkFRoNS8xRLctuSFxaeO1DnnbfmXKWJ8XMNHNc4Xwo+rY4yjGl1ZdfvhLk/KLILf4/65EGebINopzOtRAJRaQyM6DizvjY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silicom.dk;
Received: from AM0PR0402MB3426.eurprd04.prod.outlook.com
 (2603:10a6:208:22::15) by AM0PR04MB6820.eurprd04.prod.outlook.com
 (2603:10a6:208:188::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Mon, 4 Jan
 2021 11:52:17 +0000
Received: from AM0PR0402MB3426.eurprd04.prod.outlook.com
 ([fe80::58c9:a2cd:46c5:912e]) by AM0PR0402MB3426.eurprd04.prod.outlook.com
 ([fe80::58c9:a2cd:46c5:912e%5]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 11:52:17 +0000
Subject: Re: Reporting SFP presence status
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
References: <5db3cbd8-ec1c-a156-bcb9-50fb3b8391b0@silicom.dk>
 <20201221152205.GG3026679@lunn.ch>
 <24cb0fa7-13fc-4463-bb3e-fcd1d13b3fcc@silicom.dk>
 <20201222142251.GJ3107610@lunn.ch>
From:   =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <mhu@silicom.dk>
Message-ID: <6d7cc782-ee35-838b-d4f8-990e374ed6b0@silicom.dk>
Date:   Mon, 4 Jan 2021 12:52:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20201222142251.GJ3107610@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.184.138.169]
X-ClientProxiedBy: AM6P193CA0126.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::31) To AM0PR0402MB3426.eurprd04.prod.outlook.com
 (2603:10a6:208:22::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.8.20] (85.184.138.169) by AM6P193CA0126.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20 via Frontend Transport; Mon, 4 Jan 2021 11:52:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57f932a0-d7c0-4183-8f1b-08d8b0a72f27
X-MS-TrafficTypeDiagnostic: AM0PR04MB6820:
X-Microsoft-Antispam-PRVS: <AM0PR04MB68203326EA78D0118AB725CDD5D20@AM0PR04MB6820.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3UM3vIWmoeWE+and8yF5U17KhXWLwEwRcFD2qhUgXSFNKyQtDdldUtxpj89i23jiZ98MuCoTKr5A/ipO0kN/V15YJRhE/Zc9fIVZtyzEgL4VU5lN4+usXBbyLDK+nPXIziyfImQNfMeJToVh8PlrdmkLfDdOhd2ATXtjx8ICNtgvrnf31oWzqx4YXEKOvEDD2hkJ9ufYgcbrBMxOsnXh2YBNZDws7pK8RRE9nJzQNtdodbpaZSB/SSftNqQrP9PJro+PArJuMJx8Ntm7lQ9G5q6JT+/fd4UTL1zj1jFZRQdv++mCQKWFbnZZOFauueAlxw/sQrMVeSX2omwVmiS3MoLtJzzK44j+Fphtez9Fl2ax2IvTtyDQnKCtL7OiTVTaH0TcjZhjmyqKA7dqxyAZmGxCHWNN/rZLY2Lpua61MSiQz5jaD30d/3WtpVtc73Tq/ie8lcGH+q7dBTqymvc1bZrBVCcFoov4UqhM92ol0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3426.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39850400004)(376002)(346002)(66556008)(66476007)(66946007)(83380400001)(5660300002)(3480700007)(31696002)(956004)(36756003)(2616005)(31686004)(2906002)(86362001)(6486002)(478600001)(4326008)(26005)(16526019)(186003)(8936002)(52116002)(8976002)(316002)(16576012)(8676002)(4744005)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGtVU3ZzSjF2Y2hvMDhJUTZlU3lPempZcXhEV1RVakdraDc0N0ZOMlFjSG5O?=
 =?utf-8?B?cW52SVpZMm4rekJpMGo4Vk0xSnYyM1J6TXdzZUZEOS9OWmxYbkw2ZTN1V3l5?=
 =?utf-8?B?dzJVWC9ab3FmL2s2aHNIdWs5aWU3U21jTFlmMDZYMW1vWlFWamlZZGltTUNm?=
 =?utf-8?B?eHBYY2V4SlNnZEQrdGNZOVl5Yy8rR3lTWVpBWEI4amRiQ0FIN0dTWHJEMm9r?=
 =?utf-8?B?eHFnczJkNDV3anBVVm1mTVU2VUxDQmZXbHppOXFqRXNKSGs1YzFwTTBVT3hl?=
 =?utf-8?B?RHA1anFwQ3lCdUV4ZmRKUENFQzFlZnlVd3R6cGJZY2JnR25ZN3ViRHpiMy8v?=
 =?utf-8?B?NkpmQUEvRjM3TjVFcCtoWW0vTVc5cmxmMnNtUUU3M2F2Ylk4dTZ2Wm8xZDRm?=
 =?utf-8?B?UGRQQzdOcERRREVmemprWkdVYmdpL3NxK2xONFlmb2ZuREV3SGkyZHUzY0Nz?=
 =?utf-8?B?NndSaGZEVVN0S1psclpwcm43eU5WZTVwZmZWcC9tbXJrRnJnN0dUbVR1b3pT?=
 =?utf-8?B?Q2FlbjdBWmdmOGgzUzRDenlJRE44UDZYZmh1S2Y0OTNDUUIzc1h0b3Q0UjIw?=
 =?utf-8?B?bmt4VWN6V1YrdUQxa3k1MENtQTFhMkY3UWcrSk5zSFdXbXI0S0RoMWtUM1hj?=
 =?utf-8?B?eitOeXNSR0Yyb1lpZGVzODBrNVp5aHRKMGJWa3pWREs2MU5adEZrU00xeXlQ?=
 =?utf-8?B?ZjZsNHlraE9veFJZbHFGc0xxaUlDTU5VWngwbUg3b1lNTmJjeE5GbFh4OHBv?=
 =?utf-8?B?ZzlIWTBtVjJBWVJIcWdkNkdsUi9ZV0NMdEwvMU1hc3dHNU9kSlAwbU1BQ1I5?=
 =?utf-8?B?SU5UN2F4NGtXcFpESVpZRW5xbTVacVFJeWxUaDhIeWUxWEV3RE9FcTBNcitL?=
 =?utf-8?B?T1VCT2o3MGVtQVBMRUdmczZ2aitmdVBxNjNibkhzNGFudGs0ZXhXMmo0L1lO?=
 =?utf-8?B?bkRVa25WTUxiTVJsUnF5Q05qK2dZSkxNZkkxa3hMVWhCekIvaEVPRzhFWkpn?=
 =?utf-8?B?WWxLUkV2UDlwdjZoNGJEODZnYllOWUwzSjJZWnB6R0RJME9PRE5ZRFM5aCtE?=
 =?utf-8?B?dXVYN0FST1ZOM2FPaWI0N1VkdnA1Q1ZjSHp4elRiUDlJaytUV2ttZmtES1Vo?=
 =?utf-8?B?TTdpT2JWVTQ4Nk91YjQ0ckJCS1lnU3dRYTBFazdpbjAzMW81cHdMVTZUUmJY?=
 =?utf-8?B?aWxCczQwaWZrT0hkUlNjT3l3OHBKVWtSN0V3ckVGazRyYkRnWnZkbkNLRDhn?=
 =?utf-8?B?NUNXSk1hSU1ReFcxMEhGRm9URWFUQVJUYnRTdCtLd0YrSTkzZmZPeThNVitD?=
 =?utf-8?Q?FShMUZNYv0rUSvLwTZqiFDgdZRPetIuiCx?=
X-OriginatorOrg: silicom.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3426.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 11:52:16.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f932a0-d7c0-4183-8f1b-08d8b0a72f27
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u81Vi+anx0MK43EwtIJSa1R5WdQchDUIQlnyQl+1ZnExhLJ3RCr3H0VFdwQkGXWa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6820
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 22/12/2020 15.22, Andrew Lunn wrote:
>> You're right; a notification isn't what I need. But a way to query the
>> current state of the module would be nice, i.e. using ethtool.
> What do you mean by state? ethtool -m gives you some state
> information. ENODEV gives you an idea that there is no module
> inserted. Lots of data suggests there is a module. You can decode the
> data to get a lot of information.

Using ENODEV would be enough, thanks.

> There was also a patchset from Russell King a few weeks ago exposing
> some information in debugfs. But since it is debugfs, you cannot rely
> on it.
> 
> Back to, what is you real use cases here?

Similar to the NO-CARRIER / LOWER_UP flags from network interfaces, a 
NO_SFP flag can aid when maintaining remote systems. So it's definitely 
nice-to-have.

// Martin
