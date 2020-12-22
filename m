Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0B62E0607
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 07:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgLVG27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 01:28:59 -0500
Received: from mail-vi1eur05on2127.outbound.protection.outlook.com ([40.107.21.127]:33888
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbgLVG27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 01:28:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezTvw5NYgfnPNsx3R0uhno3dA+XAjU+AdpulfLtfx/g3jp3d5TYFPMxAhRXjW754pw5yOaDbo2XOFfViG0qFAhWaWX3adf/b68MlY0T/QG3420p+DbFSOZUEIYiMzCO0FmZk7JNKL/Ry6A5vSHHD8UZqck661zcWzDxXhtgch6htax+f46hvHSVWjD9nlEAl+Llm/GXgJupGSXhAVaRbe6J7asPsQjYUf1IPzs9yNBXWq/qB422M7Y+O7UNQvHisVPU3sMqugohC6CfPznCl5baYV39d5M1CNcxOmPAScExRbL/wQ8rftzEfDT5WHc3B/nFUzpyXKFKHl9TeTV59IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFbjvmWGWyuUQRSD+K/5eWXgEBu6pVkh/siqC1iLoIs=;
 b=F6NFKGd0pwZRMx9T4r2Y3zSMIN0pSd0GfU5Gj8IHwmmf0jkeZdROd9yyUO5ER7xF97Ov0NSi0U0XBYOMBSGO0KzzI4V3zxYvsYWXmZc3MdpctviuJPkRRWIjirqypTSklL9FyVGQZntWtXrRu03lAqs7kCsY8kWxmMfq2Wk2AmVlncRWfifyWnzhkBEd9L1bflx8RJJ9Op+KIwa+iG7f4A2ngtgJAIo8R3V04M+Mfj0h+ufWIBQpMrwn2rJEy80IanMC7rsgO6jgIdr3O/+cojWjmBg63Z9CTYsWzO2QL5a0qWKcCJ7znr6KhFDKMNQuxpSwxycoDiB9J9sat5jnGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom.dk; dmarc=pass action=none header.from=silicom.dk;
 dkim=pass header.d=silicom.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFbjvmWGWyuUQRSD+K/5eWXgEBu6pVkh/siqC1iLoIs=;
 b=OkPVKu8oYWKB4/lkIOP20Ru2TNo+Exss7y/YTm3yKZtVdN6iezOqaa8R1UeqDy5zgvtOTTa7IYzco3vN7FC949bO81bvSNtxgUplisUVCBotQ9EpnAMOM4oJJkN8edp3aODzRApNJXJ/kAOZO4VmfpBcr6/0eHkpO2mOdqrPX7o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silicom.dk;
Received: from AM0PR0402MB3426.eurprd04.prod.outlook.com
 (2603:10a6:208:22::15) by AM0PR04MB6882.eurprd04.prod.outlook.com
 (2603:10a6:208:184::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 06:28:11 +0000
Received: from AM0PR0402MB3426.eurprd04.prod.outlook.com
 ([fe80::58c9:a2cd:46c5:912e]) by AM0PR0402MB3426.eurprd04.prod.outlook.com
 ([fe80::58c9:a2cd:46c5:912e%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 06:28:11 +0000
Subject: Re: Reporting SFP presence status
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
References: <5db3cbd8-ec1c-a156-bcb9-50fb3b8391b0@silicom.dk>
 <20201221152205.GG3026679@lunn.ch>
From:   =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <mhu@silicom.dk>
Message-ID: <24cb0fa7-13fc-4463-bb3e-fcd1d13b3fcc@silicom.dk>
Date:   Tue, 22 Dec 2020 07:28:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20201221152205.GG3026679@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Originating-IP: [85.184.138.169]
X-ClientProxiedBy: AM6P192CA0048.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:82::25) To AM0PR0402MB3426.eurprd04.prod.outlook.com
 (2603:10a6:208:22::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.8.20] (85.184.138.169) by AM6P192CA0048.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:82::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Tue, 22 Dec 2020 06:28:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb893123-96d7-4c26-538d-08d8a642c111
X-MS-TrafficTypeDiagnostic: AM0PR04MB6882:
X-Microsoft-Antispam-PRVS: <AM0PR04MB6882DD52B2E3DDB85E57AB3ED5DF0@AM0PR04MB6882.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ApOYXHqsQf0ECFCt1rZxpmZMpcWREdmTW4CmETEmqYQpMWEHdirsJIaj6ez5xFrfVJdEgMevaFNvPvqLruEzRbVoqZv9E2ipVTQdDDgc1kbeSH8f32LLNzxwrSQtAcw2NA4VtVT5AJqSp0e3bFF/UKe+CYUIgeB7kbwh7LU6Ppa1CFJlzObpPw1JNixVnvrN4K/iuKoOz/z+DrZemLKzU8PSwDXalCpTR6e6nh71A01GjBOADXNGGh/qbucgmKYDM7ClzBhpDwWitF00bVg7DWRQDdCJwR/mWe0D+a/oQKMLfwT2KGIPE31Kpvfms111WDpBuedlNTkJp8ZlMVtPjwbupLst0NhB40FAkDQSEDW7kyufEhOU8J/lmAklBwzmj5m8xXk7vKP3SGQiQcKwtScjKQ6mW4sajBl2b7jf8kbTto4nLw7Ar/9zwlZw3YDcP1nMEiFO5vomYD03f52s8T2Wz6oruCBsjOLjICcQ5F8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3426.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39850400004)(346002)(376002)(366004)(66574015)(2616005)(83380400001)(6486002)(8676002)(5660300002)(2906002)(26005)(956004)(31696002)(86362001)(16526019)(66556008)(36756003)(186003)(6916009)(31686004)(16576012)(3480700007)(8976002)(66946007)(316002)(4326008)(8936002)(66476007)(478600001)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cE9SY2VEdytuU3UyQ0N4dFhDVmp1QmY0c2NDTWdKL0lCVGVDclhiZ3cwWld0?=
 =?utf-8?B?Z091S3BEbkFDOElLRnRjL05sc24yMWkwdDM4aGNuV21vSHlZYmRRMCswZ0lQ?=
 =?utf-8?B?ZGtXWjNhbElTNUFiazZ2QTd0OFQzelBKSFZSUUsyck5yYW1VKy9RZ2s4SkF4?=
 =?utf-8?B?MUNhUEtFV2QxU0phT1I0WjBFZjVVNE1HSGVRWkhJS2NNT3dBWVdreFpNSXdk?=
 =?utf-8?B?bFN5OXgycmxlbm9iSkFZL2JkajlzTkxESTRjbkZkZE5pZFVLWjRvU1Z6ckZD?=
 =?utf-8?B?d3o5bDA4WXRXWXRta0p5ZW5KaVNRUDQ4d1FoU1NqY1MwY1p6VkVyblJ1NXMx?=
 =?utf-8?B?VWg4T01yWXpYWXhtWGt6UnRFSWtZaUlMTUt5MHB2bytRa1VSdTJqcXpuRThi?=
 =?utf-8?B?bXhESndiakRIOGlMeDhNeXVBbW5vRGIwd3k4dlFGYzhielNhdWxnSkJyQXVR?=
 =?utf-8?B?TXNCdC9RS2l4NDZ4SjlHNlNDYjQ1OVBRYVpOSmpWZUloV29udmhzbGs2YkxB?=
 =?utf-8?B?TCttWXJSbWVjWVl3NWk1SnM0NGtXV2F4Q2w1enJzYmZ2TzV3OTJvcFRUckox?=
 =?utf-8?B?eTE0K096SjZBZFdvcnFicVNhZFJscVBrdWt3dTRJUHNDcEwwaThBK3pQaEcz?=
 =?utf-8?B?eGdad2NZRHlkMFFhTDhBN20rVzh0NHJOMnJLV2dZU0tLQURlRk13RTZZQmZ2?=
 =?utf-8?B?N0VhcTExakVud09EaHJGSS9TN1g3V2lWRjdUUklIcTYrMkxhdkJXdmtyV29I?=
 =?utf-8?B?YzMrdGFaZzUwaGFLRjNDRVZ4dUk3WmJxUGRXd2ROTmVZLzl2MWtjVmpFa1lq?=
 =?utf-8?B?bCsyWFhDUlZXWWRmYlQyYlVNRXJaclEzb1hkTDRjRS92WE1NYUgybjN2S1dx?=
 =?utf-8?B?bklZOHBkVEg2TVk2TEM1VkRRMjNVWFFzL1kvemdLazdka2Mzb3lxNjE5dGFw?=
 =?utf-8?B?S0VPTmJqejlRQWVuTHFraFRCcnA2K0QrdWNHVTVGTm9Tc2hUc0FKYmhBZUlY?=
 =?utf-8?B?TlNQMVpMME5KZjhHOVh2RGxjMVpzejN4TGlLWUJnRVVDMGJZTmR6NzFreFFn?=
 =?utf-8?B?bDVDTmk4YjNFQXkyV3ZyellBNXVsWTlrTGxJVGNQbFFMMm9kaHl0clF3dnJD?=
 =?utf-8?B?dVNSRC9Nb3RrQ1dWRlpqVXBIYlNDWTREUTNKVFNoN21raWU0eC81amJXbTFl?=
 =?utf-8?B?ZDg0SDAweXo0N0RVWFFSZklTKzRUK3JENy9nT2UvL01QQWZQdlROZWJGQktk?=
 =?utf-8?B?L1kxVW9tRGdFRkZWRlhZTEU4RHRRMjNUYTNhc1ZpQ0RrZCsxUTB6VlhORlk0?=
 =?utf-8?Q?EMjgO/30HnFY4Mckxmi8F8KjmNBnjr1HYg?=
X-OriginatorOrg: silicom.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3426.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 06:28:10.9286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-Network-Message-Id: bb893123-96d7-4c26-538d-08d8a642c111
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICHwNMTumWYcOFle15RBJRHb2PUiCwY5CigtkTgFt62kNJ33evxxaNj0PRmSNB56
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6882
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 21/12/2020 16.22, Andrew Lunn wrote:
> On Mon, Dec 21, 2020 at 11:37:55AM +0100, Martin Hundebøll wrote:
>> Hi Andrew,
>>
>> I've browsed the code in drivers/net/phy, but haven't found a place where
>> the SFP module status/change is reported to user-space. Is there a
>> "standard" way to report insert/remove events for SFP modules, or should we
>> just add a custom sysfs attribute to our driver?
> 
> Hi Martin
> 
> There is currently no standard way of notifying user space. But it is
> something which could be added. But it should not be systfs. This
> should be a netlink notification, probably as part of ethtool netlink
> API. Or maybe the extended link info.
> 
> What is your intended use case? Why do you need to know when a module
> has been inserted? It seems like you cannot do too much on such a
> notification. It seems lots of modules don't conform to the standard,
> will not immediately respond on the i2c bus. So ethtool -m is probably
> not going to be useful. You probably need to poll until it does
> respond, which defeats the purpose of having a notification.

You're right; a notification isn't what I need. But a way to query the 
current state of the module would be nice, i.e. using ethtool.

// Martin
