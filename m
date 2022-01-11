Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616C748B2F1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243067AbiAKRK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:10:57 -0500
Received: from mail-dm3nam07on2045.outbound.protection.outlook.com ([40.107.95.45]:37724
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242530AbiAKRK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 12:10:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJ2WYwiJbouCPbl0Jw9vQRIOmQwfv5ZpGZVE9aRK4ibdY9TdBTMYMw5I0kV0nEKdrYXgMTLy5lhD+ez4sHj+ra/XMNohAbpwEak/YqzNEjxe5RhXrKeLoo5TTAeW1NyUmTqstgbORRGRKF/iE2RqSLkNYQb+wpbEIbOc9hjzxN72He+mLub7wFwBC4y3MavyaLhQBofGP10m23ahPtEoRkzVy/Y1QDS5pGyPJYfmpHQ+FIrOsnMXD4jL1u2V+fH09DPZVQQ1Y1GxjE+LPOGPSlvOtzMEAzr3ujgUpqaPrReEnR2/gpQK6nuzn/bfKsVH6hvJw+IOZ0kCUqoHT5tShA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xedOC1F1W1n2Wohd+WzAHly+0aPq5xVn1eYpMAi+SXs=;
 b=CEDzRPkkJUB+21rCHC3FzZrx65a8Cl6cCBNGNBl/vyKzyf1vt4eA24IDcalVL2hnIZpjc4c8t1w7qwBXHKON/IrAp2X0QM67wmErVJW7v1XFuQDGyp89IvGYKyhhcQxBYv499lGjk/WnZ/bWUP4w8vSWoAWlHI+oK+zGWikDI1ttVTFlABYr9znxA08ffu/wfkAeCrv73NO0vBpGCeDz/JWafGx4vRHRydIl3qR2x2PGSZdi+yaN7jtT/h5RQ8DhPdwbDIISmABGGmzIACSPVoCyNSilTkKq0IQK48jnfOwSsRblcDiC7zHye0fPwQzW3tCM58YB3Fw/ZlqHgJBYLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xedOC1F1W1n2Wohd+WzAHly+0aPq5xVn1eYpMAi+SXs=;
 b=pv7w1BAQw7zWptGFk52RngcefJqDVOzBLgO6USk6sXetHEzuIP1goPpHjqZ6Q0i91KtHOwAjcR3JP3mC++VJfYUgyvc3oLZ5SbcdrXc4orFkDmTRePHkEX5Sttqtwa0vQQ0thkKNsF850AraYiHKU/Z3nZvXoqK6Zg0yC+8mI2E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 17:10:55 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4888.009; Tue, 11 Jan 2022
 17:10:55 +0000
Message-ID: <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
Date:   Tue, 11 Jan 2022 11:10:52 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <YdXVoNFB/Asq6bc/@lunn.ch> <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
 <YdYbZne6pBZzxSxA@lunn.ch>
 <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
 <YdbuXbtc64+Knbhm@lunn.ch>
 <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
 <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
 <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
 <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
 <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
 <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
 <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0123.namprd11.prod.outlook.com
 (2603:10b6:806:131::8) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dcf5ec2-1c2d-41b2-1c41-08d9d52553ef
X-MS-TrafficTypeDiagnostic: BL1PR12MB5061:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5061A91AFC99CEB0803C26B5E2519@BL1PR12MB5061.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGYUxhuWkHoo/yxfQRWHIn9tXfpSjJorsbs+PS78GUXGFiq/kJGonfanvFTsBX4PZHILyRhFFWAznHWoAfr9rb+IklIxLupIpqtz8iuOlJT5xTWsUUsLTc4Y7iO+hEHGX9uDMz7+UhyLuazgWTFKL+uo3xsNbmyf7rsVNJTRc0T95FKQQ/csX0VkYn1roRmazTmsPJ+hgpuv2lqW79PT/W4xwtmbdtT7N5+50g9KhyDowJEzleowzSVJ5io8z7H4yVQw7QpYS6bLMom2qlnr54FaKATWXBzbbneF1Ctvyz13cng5mZ57Jd4VY7ScoF8OpRaFNm4RM8KZedC1TVwv3Z8DoCR6LNTAwl6d/+ZxA/sTcDdhhOkXOqDd/ri2tUOnNrsholgn6DomSzUFbP9s5H1A9bFbv7OHJsWaP6QYA5KXWHa71MbkqJYzTGc2Jo9NOKIQIi0QsBhburJm9BOaAkqP4L/NzvJZFLCyprCOXnTFB+CnkEhyttrk957U7oB1uDU8e0Av9EHiG2dHvrzR6Kj3UgtELlTkO9VQevBCdgm0UsIdHNIoyBQNsgZcmNg4OB01svlvi2eBCq9gv+7GC7dn2ZVTPHo/ouznKsi0pV0HETY74GIHZxegNJf546tFMT+wBoHdooRjCucWNePWSYsV4MgAeMhwk+VOE9HQIxLv4Q/aURW1SdHntnkVyEsJS+L6JJqpn3ujv2A64KDMxkC/B418NBxXZK0W8WBNJA6BVF1Jo192ITNTlSpDXLx2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(2616005)(31686004)(6486002)(8936002)(316002)(4326008)(6506007)(6666004)(31696002)(86362001)(8676002)(53546011)(2906002)(6916009)(36756003)(54906003)(508600001)(66556008)(38100700002)(5660300002)(7416002)(66476007)(186003)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vllsa25wV0cxcnBpZzhqcG83anJuTFdOaFJPMHQ0VUcxMisrOXF1My9wNjVD?=
 =?utf-8?B?TVFKbFRNN2xZREt0SkNISSt0dGhjelJwbnllT0h5Q0JGNVppamRKbFdTb2Nm?=
 =?utf-8?B?RzRxN0c3WGdsbmZ5bG01c0ZQSTJ4bHV0L1IrRktJVE96cnBIbWlXR0V3VU11?=
 =?utf-8?B?VmVYREFxVkRJUGsxbkt0dkNtQVNnWkRWd09xYVZNdzBvaFFnUStTSmZBQ2pM?=
 =?utf-8?B?WjRQbys4bTlsa0RYNWlNc0RmZjduSEt1TUR0TERqeXpEUVhJOWFQeTNnMENN?=
 =?utf-8?B?aFhycFpxOGZEN1dYSHRhbG9EQjNVNUwxdDJON0hUTkJDNERjMHZ4RFl5U0dH?=
 =?utf-8?B?YWs4NW1KUkhsUnRHd1FqY04wMnZKdUI1ei96UG5ZYi84bUN0ekRSa0RDZmJK?=
 =?utf-8?B?SjlxV2xwaWJxMzBac0lDckx1MldwZlAyelhVd3JQdG1XVDc2YVRBSzhISFI4?=
 =?utf-8?B?Ykp3Qk1VdHlVZFZiZEpuMWFGWlhWazJOUGhXOFc2VS85NG9maEw4NFJ0TFNL?=
 =?utf-8?B?TW5sSm9LQTdwdDZmOWloOFltVDVZSDd2SXRtdllmVnpDdEpUaEN2OVNodEYx?=
 =?utf-8?B?N0pFS3EzckwycGJWLzQwTHQyUlZFSDVDd2pudUxvMkNRNXB3UDBJbHZLYkpX?=
 =?utf-8?B?UnZWNXRzNXZ4MVpUTkJHSE9WaHE0QklSRlNnaVVPOGxsamlOKzlqWHZ2TG5h?=
 =?utf-8?B?RG9ueC9XMHQrK1pKMW0rL2wrdXJYOGl4N1Q3QUtHQ3NaM0labDFRazNLQk9T?=
 =?utf-8?B?ZjFGc1cydFFjUGpNNnRpQ0Q1WnVlUDRxTklsanlsTnhpTXNid0N2OTVHNkFv?=
 =?utf-8?B?NGhCeFJmOHQ3c04xSTFWY0dDQXN3N2c4VE51a3k2eXhUYnZHS25OcGZhNC9W?=
 =?utf-8?B?NGoxTzYxaS94WmQvZ0FScGt3eHVtNlRRa3ZZY1NNdW5kbXBOQXdORVpkdFRu?=
 =?utf-8?B?V01adllrRzdNVXk4clBSWUVJUUxWUzVDWUlSRFU0V3ZQdDh2Z3hkWjMrNENZ?=
 =?utf-8?B?RmpWK3lwVHZodnVodTJ2djcvVWpxNS9FcFBVaGRXWUFhYnlqUVE2R2c1MStu?=
 =?utf-8?B?ZWdKM0w1ZkJLbXJIRGU5ZjRvU0lWai9VTWFXbVhTU3B4dDMvY3VadnVYMjU1?=
 =?utf-8?B?M0YzRldxZnU0bXVib2NxQVJYdUVMWm9YOXprUDZrdG9PMTRaSGJRZWljV05u?=
 =?utf-8?B?L2VWWlNXdDVCYjZJSGVmNXJaLzQ1ajRhT1U4VXBwSENvVTV6NitUV0cvV1F1?=
 =?utf-8?B?ZGRvM2NiUTRUUSttUGdlWDFKdjBjUHpLZll6TnlKU2NGTzlua1NzTkw0NUs0?=
 =?utf-8?B?S1lvZlJDVjRsb2tZZXAxNkozeWdENG5kdnJ2NWFpMUptMEdlMWFVeGNBSFdN?=
 =?utf-8?B?SVNSbWJ1STRDL1VOTWpqaGJGMWtkYWEyMXV3OUY5RTc2dWJjWWhUbDVuandI?=
 =?utf-8?B?N29Uc21TbGtSUStWVzZ3RjMyS043Skt2U21qeFVYSEpsMnhlbEpKQ2c2V0o3?=
 =?utf-8?B?NzRMYU9LK2NlWDJ4L3g2OTFVRi95bzNWeEp4NFh0R3RPcCt4cjRvaUkxc3NR?=
 =?utf-8?B?VEpJeHVMelpsNk5PRXZrL0lmVFh6K2pCVy9PS3JXV3Jadzd3UktObWpmaVhM?=
 =?utf-8?B?MkdCa1NkVkRJM3FoZnZsQlBRMnNNcHkway9mY096UFBkK3VRencyVndKZ3Uv?=
 =?utf-8?B?Rmtic09RVXk0Sk1xL0lLUTl1OWpoRDAvQXFEQ2puZ2tZRWhUSktSazVWRGMv?=
 =?utf-8?B?NnliQ0h3SVhJUlpYaWZHWndWTkY1S1R2ekxEUUhVa2VkM2prWGlHNmpjTmNx?=
 =?utf-8?B?dlcyZ2xjQnRBcWlLTjNjTkJOTE1NcHZVcHBJSzk2OWluSzV0cWpQdEROWVA1?=
 =?utf-8?B?MUMxVlF4ZDlTWXpRQmdSenY5eHZ1VXk2S21wT0FxbStNQmdLZmpKY3U5Ykdu?=
 =?utf-8?B?akF0TmVrN3lzVW9oeE9keHhhNFI0RTFMM0s3UEp1eXdNWFFCaVBtUUsreks2?=
 =?utf-8?B?a2hZUDRvZnpMSFF1NHl3YW1ROHJ3ek94eXdHNkhOb3o4K0xUQUNXcjk4UERD?=
 =?utf-8?B?ZXVYdXZaSVhYRXo1cjBzTmx2dzFGZkJjU0tYM01nUE00eGZwOFd1dmRvNWM5?=
 =?utf-8?B?WWxRTlY2T1VUZEtYN1NmWnVvWlZZcis1QWxWMHdMbzcydkc4VDdqeUJVS00w?=
 =?utf-8?B?OWxVN0ZwbjlUYzh1NFg2ZVZFa1FpL3FDbXAraWdLeUFuU3VOSFdUOVdvUTlv?=
 =?utf-8?Q?DFFu3n5i8GmpNGo5myjWllj6vln4A+21tzdAm91WD8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dcf5ec2-1c2d-41b2-1c41-08d9d52553ef
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 17:10:54.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mXTHYzAGzw/5tdnAtYaZHEf1DrKYsiq7ckt3iYvxVzFcg0mcr0DUd9NXxloxEp3LAfe2fk2KgM1ZGjHUTMOdWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/2022 11:06, Jakub Kicinski wrote:
> On Tue, 11 Jan 2022 10:54:50 -0600 Limonciello, Mario wrote:
>>> Also knowing how those OSes handle the new docks which don't have
>>> unique device IDs would obviously be great..
>>
>> I'm sorry, can you give me some more context on this?  What unique
>> device IDs?
> 
> We used to match the NICs based on their device ID. The USB NICs
> present in docks had lenovo as manufacturer and a unique device ID.
> Now reportedly the new docks are using generic realtek IDs so we have
> no way to differentiate "blessed" dock NICs from random USB dongles,
> and inheriting the address to all devices with the generic relatek IDs
> breaks setups with multiple dongles, e.g. Henning's setup. >
> If we know of a fuse that can be read on new docks that'd put us back
> in more comfortable position. If we need to execute random heuristics
> to find the "right NIC" we'd much rather have udev or NetworkManager
> or some other user space do that according to whatever policy it
> chooses.

I agree - this stuff in the kernel isn't supposed to be applying to 
anything other than the OEM dongles or docks.  If you can't identify 
them they shouldn't be in here.
