Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC33238ABE9
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241288AbhETLaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:30:00 -0400
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:24673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241647AbhETL1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 07:27:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcsKco2iq4OoR7Lno3MUxuTdyUWQz75Eei97Dj3ajyAbBDFyI9IdnB0jFZVhJ91Uo39dVryuRsYF/UXzLc69W6dLiIjp1fnlA0t70TAOkWSSQGbahwlL35G6UIyNshFgHIEK2GATa05vCpbR9TgMZFhnbEdJ+MuvhfdBzS90FUYs6JkRL8hk4lQhiCjMszZWUK1qjvNhp+OM2GrhxirospcoNAU/Ckek3WjdGMv4rN7Gp/T7sKmyLDncFYB9Iw3ApCN4IRLj0nfD3gSJ+fbkiecgDhG/qucwPlxSwnA/wrndiNnlwkZO5gB/WUcZkLgmvjRkIiqm0vsZg6F8tgF29Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6OebMnJF2YSfXr4zLeTHjvH8mvb8vv1oj54zjZ/tUE=;
 b=ILrI9rdV9k2+0QSOkn2NXG6ki0CJ3GW4SCGPATX33fb4OeqHLbfMiu81P9Seg3RavMUDxsoMBfqiuklQonBfV8lz4e2ceKn8T+CDLCSd3ifJOsxuejESqWcodEzm+xnl4o/gvkqsuMSRP6fC72Fuof5xbid9XGsAuV/sDuQw5yiBXOvCkKyBmpBHanbcf5s/S/UalLPtW78bpyGgwxkEqLxcc9qi16+UImt2B6P+stKWakF87HCuzEsKF/47P70tpYdAi6Jrvuw5tsIdvJe67jyjNhm1tRTzUlf/gJ68yxpo1Kj7//zT7zZnzA2L6K3Rc9KqDj+xpGp4a57rvCMhIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6OebMnJF2YSfXr4zLeTHjvH8mvb8vv1oj54zjZ/tUE=;
 b=B3pe678ZXtKE7gJnq6bZ2UIBsWWaSPvHr3fJzDPD8p8WJ6u17pDH7Q5s8rgulBJUomD94iX205rdHEiGL826Szb+XiFnqaRUnqzBaVzlX9NHLmFjiTrk/jGu6+9OwguI5zkA+J8T/ydQiHMrN3kv3nul32tsjCOzPKtmTJtWHi5Iamnyu3xpWznqZJs+2dwvHXLawaabrh6c9GSp7velqNcToYzCbKpi0/uAsmXqpU1rMJa5penDt1dGFpwHXZW1Q0c1OkzWt4pGZrj7baG0FMxeTQGcjFecNrhnr86Zuw4jkOVSWoMpFRP8IDsZr6BUdO5Qgcr3LVEu+/Y4c3/TCg==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB2942.namprd12.prod.outlook.com (2603:10b6:208:108::27)
 by MN2PR12MB3215.namprd12.prod.outlook.com (2603:10b6:208:101::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 11:26:25 +0000
Received: from MN2PR12MB2942.namprd12.prod.outlook.com
 ([fe80::c151:1117:48cf:f074]) by MN2PR12MB2942.namprd12.prod.outlook.com
 ([fe80::c151:1117:48cf:f074%7]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 11:26:25 +0000
Subject: Re: [PATCH iproute2-next 0/2] ] tc: Add missing ct_state flags
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        linux-netdev <netdev@vger.kernel.org>, jiri@nvidia.com
References: <20210518155231.38359-1-lariel@nvidia.com>
 <CALnP8ZYUsuBRpMZzU=F0711RVZmwGRvLBEk09aM6MKDhAGrMFQ@mail.gmail.com>
 <32e2a0ac-1102-3fd1-6094-052bd58415fe@nvidia.com>
 <CAPpH65zVzJpie9CmwJ6F5uyUq4C7dRfYV-yngwAFm+ARHdRd3g@mail.gmail.com>
From:   Ariel Levkovich <lariel@nvidia.com>
Message-ID: <c7f436ef-f18a-76c4-d9a3-d2a13cb00971@nvidia.com>
Date:   Thu, 20 May 2021 14:26:18 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
In-Reply-To: <CAPpH65zVzJpie9CmwJ6F5uyUq4C7dRfYV-yngwAFm+ARHdRd3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [193.47.165.251]
X-ClientProxiedBy: FR3P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::23) To MN2PR12MB2942.namprd12.prod.outlook.com
 (2603:10b6:208:108::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.27.14.155] (193.47.165.251) by FR3P281CA0072.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Thu, 20 May 2021 11:26:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b730666a-4154-46f8-0cc9-08d91b821a33
X-MS-TrafficTypeDiagnostic: MN2PR12MB3215:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB32151EBF235D91BFB46FCC27B72A9@MN2PR12MB3215.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBZyogpIRHEt+tXXdB4wvd1F/ToaWZHuQyL28futW0ghfQrLPgsUODgASbVpU1MDjlb+cNqznprS2/qI2Q39S6jAya5iyPuUgBkGu0M1efV2KPlL0ZdxaR3R7+D2RiQO1zZbg7N67/YXz8NyZoTE/TdAOgZezTNo6J8FDxJiiJRl28xTpXFqDC1yIaHg/vVoaNvtVAUfTLKIm/Rzf04dAkrtgpo72zFpzZT4Pq7kQl0ktvtmzzh7SB/zGyojvubDREnLma/Q1n0cmYOWTa/hW7OGS8+zNy2aeNkHkutaOd2fsxPjSe5ZKv7qHCGBlf7f+2HeFHnK0SoNdxb5llDAvafG78OTNEMyYD5dftXxaOMTtTBGjj9JFSMCQYcSIJB10sMxkpJhnrBZYL6asp45WVh2oX4laahEAp7JdYwAe999q2mUXI3bpRiJ1UsitFkaaE40sDMUO7oizbRrSzYPiNaMZMrpPmtgXLgYmebDj1XhLkGBJB4W8l67O7NuuoJBB+HFE/fWLUktXAL6wrrsRWJgUwvQUNl2KTtTS1AATq76eYxxmY+uNepMY2Fo/5Ed3V0gpplXwdBZRYOOsngG2JzgKUzKoHn/uy+WOrEVuHCRYMafrPFTPCiPbN8a+5f78qg2ZBHNSbEelDoMa43vL/AJ+GhHgkZufC6YJY8hGYrTiOMEtswom7OKZ7iehsVN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB2942.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(2616005)(53546011)(956004)(38100700002)(478600001)(26005)(5660300002)(31696002)(83380400001)(8936002)(4326008)(4744005)(107886003)(186003)(2906002)(16526019)(66946007)(86362001)(31686004)(66556008)(66476007)(6916009)(36756003)(54906003)(316002)(6486002)(6666004)(8676002)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T0tQL1lNQTZKQ2FJZ0hkNEU1YndpVEVhZnVKUjgyRU5mWlJRSVVhQ016M2JV?=
 =?utf-8?B?NDhMYnlLWFVqa0FLcExHaGUrSHE3dDIrWXh6L3BYN2VyYnNISS83bFB5eWYv?=
 =?utf-8?B?d0MrVERwVHZ4WGpIZEx2MVBGNE1na0srWmtkaFg3OGhBR21zV3lqUjd3NHRr?=
 =?utf-8?B?bDhWNEQvQ3FpVklTYlh3RzFXbUZoZnNUMmJFRmovV1lERFM2Y1Vwb1gvZFdx?=
 =?utf-8?B?MllXdG5idWtuSmkxeU5Ya0lUbHJ3bElNRUZJZHZtZVdnVzF1bmZISUlza0s3?=
 =?utf-8?B?YzdlQmNpYnhPazBFeE5FcjRqMTYzSi9FNFNZS0lQQnlqQUZkSVRvQXVWcjJn?=
 =?utf-8?B?ZWN5WElBczA2dkVUT09LcXZPbDdFWVJDZHBITEtwRldkNHpTcGdzUlVSZEpE?=
 =?utf-8?B?U1pZRzlpT3YrUklNU0crQmNrLzBCNkJRZzNWZXZDTXdXUndPTy8xMTZ3aCtt?=
 =?utf-8?B?ZnNjTkxKajJmQW83aFBoRyt1eVZDb256TjhibDhZVTEvZXZUM0FVZGt6UEww?=
 =?utf-8?B?VDlSOUVJRUduRGllRFNTVzM5WUlnL0NwMFlkeTRTLzE5SDBDUWtGVkF6dVF1?=
 =?utf-8?B?ZUpQcmZMZlg5WGhPK2ZsR21oZEk4N2tjT3pnRGt3cGtPN2QvMEwyZ3JEenJF?=
 =?utf-8?B?SmdqMmNoRW1ONkZvYXZRSGkwbzkraDVQekYvQ01kOXRqZ3dMV1p0dUI3Tjk0?=
 =?utf-8?B?U2xrTzdGWjNHUlpnbGorcEtNRU9jVklUbmxVOFhpNktzRVUrL1FoOGs5SXpU?=
 =?utf-8?B?Zk9VdGdHd3MrK1ZNR0NpTmUzdzBnQTlGWndVdFhYL05HKzVCNThxSnFNNlNB?=
 =?utf-8?B?SDYzZ0gxejU2ek9WTVRTZUJzYkROd3l5bVpkemZ5UWdudTBYWXQ1NXVucE50?=
 =?utf-8?B?ZGtUL002dXJIbndlN2FGYUI0TWoxRENzZTYzT2NSZGlQWC9IK2tyZWsxWUhW?=
 =?utf-8?B?bnpFbXhwcVVUd2JKcDVPZkQ0WnVPSGdVUk8raTcrMS9lWXFScmtnbVkraEIv?=
 =?utf-8?B?cFVOMjl0ZnM0bUMrcFFtOWdIaTJrZTF4RThYVFVNSndxLzBlL1F0Q0RpbWkx?=
 =?utf-8?B?cDRQdVlEaVFGQzdqVWtHWXFZeUlRV05rS2JHY1Y0VldmQVN5OWdrUXc3Rml0?=
 =?utf-8?B?RXVCeGQ0Ukt5NWdtdjVxS2N3TmVpaE1qaVBaMHZKY2tiNmZLZG16R2orcVMx?=
 =?utf-8?B?OEFBVUtQK0RGZWhyODMvRm9qWnpuemRjaWhrY1RKVlRwQkZhZXdiTW5Xdmls?=
 =?utf-8?B?UG84SDBzdWFmMVYyRnVkU1BvOFpSU253TjFHYndQVHNaVnN0WG1kN2tYME5I?=
 =?utf-8?B?Z3l0cWV0cmYzai8yOEt0ejZDcThsVTgwTnpYZFN5RjNWL1RFam51bDU2YVFI?=
 =?utf-8?B?VDhyMUlhYXZEMVZkWTkyY1BvZ0dGMU1aVXZpSktwVEF4UTdVc2p4UjRIcHdM?=
 =?utf-8?B?V2l0dkFLdlZvVjRoWEJCbGFyeW1RZHBnQkZvNytpMnBCdjRVZjBHV3hEUWE2?=
 =?utf-8?B?WFB1d3NpenFuL1RiaDdzaHdWcE1UV2xXTi9tanlIbzBCYjRlZnpQWjBCS0VW?=
 =?utf-8?B?VGt4ZUI2TzlBVkc1N0wyWXlvd25xdFZJb3dBRHBCdHRmdGI3Tjd6ckFVaGt1?=
 =?utf-8?B?MVJTcThYS1NiZ2hnR2F5M1NiZU1aZVBDVGtHeTFET0trZXB3NnV4WGZnVWVm?=
 =?utf-8?B?UzRJOVJ0ODI3OGlWTUp4OExob3NwaG1nVEV2YlYzUFlGbWkwc2R0SlQyTTVq?=
 =?utf-8?Q?a5IW7VonAgPwfVndyisuYEciVLwIaUfhU53vGls?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b730666a-4154-46f8-0cc9-08d91b821a33
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB2942.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 11:26:25.0746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTtXsWab7fVPy58bXQcRKklHUQOzueDIXUbuDsFXSTQKEV5C5f11Xp1nCpkfE1C2vFIZlxBXjnzEwPSIuIAuxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/21 2:07 PM, Andrea Claudi wrote:
> On Thu, May 20, 2021 at 1:00 PM Ariel Levkovich <lariel@nvidia.com> wrote:
>> On 5/20/21 4:15 AM, Marcelo Ricardo Leitner wrote:
>>> On Tue, May 18, 2021 at 06:52:29PM +0300, Ariel Levkovich wrote:
>>>> This short series is:
>>>>
>>> Is it me or this series didn't get to netdev@?
>>> I can't find it in patchwork nor lore archives.
>>>
>> Neither do I. Not sure what happened.
>>
>> Should I just send it again?
>>
> Now that I look at it better, there is a double closed square bracket
> on the subject. Not sure if this is related to the issue.
> Ariel, I think you should submit this again to netdev.
>
> Cheers,
> Andrea
>
hmmm... nice catch. I hope this is it.

I re-sent it just now.

Ariel

