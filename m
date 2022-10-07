Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2115F79B0
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 16:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJGO16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 10:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiJGO1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 10:27:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9021EEDE
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 07:27:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MA2sRcHG/VG9yZ8i+OPQL+iJMOPM9EwoSvlubUf371v0dBnmhr0K6btLIyFJa7OpPoR9pD9FM3zcQXeDbwUsh6/l6TY/sSvd6oxVBH6WW9Dlj11NUNYhTQoo3jv0G2MkhkNBhDF83ADfxiXP+DBujlfj0rFGLZsmUTI6xjaXxLD7Xv1jG6XWMSpn2AKKdnH9VbJFJXrj8/AzH8YRpEEhw+Qmn0qT3HqEKz8KQGpUpL3EMbbIZISNDgvwmQOa3gyrEun2BaMrWg1rHvOQBD7yscQzX+C4AeGo9CwdBJG4QJwsPw86ZMUJ9JRDuE4OxCIXbiiqpoheXsgWq5vTNk6wgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QE24tNrpoVhDU4ksP8jhRp84uYUFnTovu2SQLufAc6I=;
 b=csD9Iz2ZdexfTonshD+Y9f3dguloBhD3weCyrKzSstbxr8m4gGkz4x7GAfV9Jqm1xXr8NuesZv9JFRXCLZrA/d/c5TnnIoeu7WbVn0ZHA1Qws/SryjxJlFUwwrsxbAUh1Npm14NtHSJIRUDtLUd6IyzRmIog3QztcVrdCijc5DcpVvOMMDDC8pk6vsbcp9mtEvJPja6X55AHMNTnNQLWoIzPLSzY3RgKyrqeHd2Ez2DlGalTfs+d7jlHZXXwJPeO/sPeVKGtW0UVYJrKWWjIZbWsalFyk7WvqTlDd9X0Oxdbdss2cwKHMTzpGrBpHp77nR/fVh58EOXv3t0V0YUYFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QE24tNrpoVhDU4ksP8jhRp84uYUFnTovu2SQLufAc6I=;
 b=x64hTJ3X3iFn36vVnXYcrA5RCA+KQp7BhvFLnHNxpzIC305zo1g46hLupLQNwif4hzh0qRE7CfCGkGAxzjXlRqVir/NI7DinBgPpuDQobtwdA0mvUiK+x0cQR7lrdsk9vPRfz89jrTa2n3vjM8qwKf8yBnnpvSkH6tUzSldr7N8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Fri, 7 Oct
 2022 14:27:51 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccc6:f300:dfcd:145]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccc6:f300:dfcd:145%4]) with mapi id 15.20.5709.015; Fri, 7 Oct 2022
 14:27:51 +0000
Message-ID: <03333e34-cd27-35fc-0f4c-c436b7c2857d@amd.com>
Date:   Fri, 7 Oct 2022 09:27:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net 3/3] amd-xgbe: fix the SFP compliance codes check for
 DAC cables
Content-Language: en-US
To:     Raju Rangoju <Raju.Rangoju@amd.com>, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, rrangoju@amd.com
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
 <20221006135440.3680563-4-Raju.Rangoju@amd.com>
 <d377d924-d205-cd25-e3d0-7521ed8a3ca1@amd.com>
 <9a8552c2-0a23-ea1d-9d1c-56b7a6c75487@amd.com>
 <40b3f874-e7fc-4049-65e2-3ed449b956f8@amd.com>
 <77d8ea25-3557-cd6f-f732-20a046b29661@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <77d8ea25-3557-cd6f-f732-20a046b29661@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR18CA0030.namprd18.prod.outlook.com
 (2603:10b6:806:f3::7) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS0PR12MB6583:EE_
X-MS-Office365-Filtering-Correlation-Id: c3a328a8-88cc-4a95-e2f1-08daa8701d71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mfcQIYYqC03h29QjC1P4w5kLcE6tPy1S+2B271YBC2nUi+3AaJFMEzultvFfzHiHknIXxrx9YwQzAt8KCV1AZlaTXUXOsE1Fk7oVcT5X0CAMhMuKOITabvn1+Bu3sGmRSvmO5m6NsD74gik55vjiwl4aKtJFChh9HU9kZRowmOzuD8UYsEMpEPfbGuFyC+wIwlCWG0HCMEIdDmNhxvbW0Z7+/osswN2jKS4nGXjDjMTLul1teohmmUcNOVeOq3Wjc8malrIg0fXnWu7Tnbe88LYZSaXeGbKqOKHS55zZECwdJ6MOdwJCIWbJGaR6W6BdTyAzlBoa3EVMDNgabVX7uVwkgvIMQE7u+W+bnvwwzarWgYzA0TloqUpdCM9VInZxmCimCLEOz8thKbjbd/ywTxDaMrSMB4DBWjpv3OoJ4IqBff+YXUuXA/8bja1jl2EPawHfnnPpZJ7+PmD5hMbRAboTMdMEEIV5HqROnPMM+vKcxfVl85RpTfZcF29US+54mNJLDTiqDtfeL3G54OVyw1QOxD8lULCENIvzfiqrb7+sQxlBiBUKv/WAAWKrZfT7a5E6PAUNzyrDXjY55zKV8BYyfzsx0vWLKy6avh6zLukr17bKfpZiWmHmD2o1j8/WH4jTkyIcSGXNnLKmgGTFd1XqGuqCxaUbIEM0JOR6WjikFryf1lXmwyqNWhbxnJlM0lLKlKIcZ5YwY143oJscM3VMOtBSgSZsg3SDcGd6xau1SEyESQWR9Z5XGOg+4M9HOeChk/2VYFHBIfvCiC1r62TsSHxo8WvUaHKoFBtNDpE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199015)(8676002)(6506007)(36756003)(26005)(316002)(86362001)(8936002)(41300700001)(5660300002)(66946007)(4326008)(186003)(2616005)(66556008)(31696002)(53546011)(38100700002)(6486002)(478600001)(66476007)(6512007)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGxLRnRoQUw4UnNjWnlGZ3V0cTNIOWpTa2R5dHFKT2U1QjR3R2NvT2JHMGwv?=
 =?utf-8?B?S0FRU0NLZWNWdlNITGYvWURnd1NWemlMbzNKVC9oQkwxN2Y3NVZ1UTZMRlBw?=
 =?utf-8?B?dDRGSEQ5S2dyZWJ0MUQ0Mm9mVXZpU1FoMXBYYWdjcHl5L1pkRTA4U2xGZnlz?=
 =?utf-8?B?SW4wYWhDcWUrbG15VlpCbVBpeitxUHR6QXB2S3N3eTlpeSswOTNiS0JSTnN6?=
 =?utf-8?B?NWVYNWVFUm5IdjhnTTFhMHArZmZlU2FIYVk5ODBMTlJQbXJGTk43ZHFHb0l5?=
 =?utf-8?B?azRvTWFSQ1ZZVWllbjdMbDVQMStnUy9VbFJpN09RenNkQW1SQjdBMEVZd2g1?=
 =?utf-8?B?TFBZaCt3dllNNGpQZW9UMU5PeE5FcVRIR3U5SHBZRHZvNkxRRFhNSVZYRVp0?=
 =?utf-8?B?NGVpV1dkVFcxVXFOTUI4NDcxR1J1K3poRHcwS0lJb0lodlBvbndvcHMwVHFa?=
 =?utf-8?B?RDR0b05hbGpjNzFsaTF0M1E5eDFJT1Y1NC9nZTQ5c0owME1ZeGh1N1VnRmlW?=
 =?utf-8?B?aFZ3UHpQUEs4WjhjY1pCVGIrTi92cWEzeVJIeXcyWGVUempWY25UQ1lnNDhK?=
 =?utf-8?B?eExuRHViSTVrRnZLdGltcXlJWTBLWGpGZWx0YURnSzZneEU5SlpxK1dGN2V1?=
 =?utf-8?B?UmxzL2pER2tCYkVReEo4YVZhSkdQS0JNN3lIZnJ4MUJZTmEzc0FlendvZDNF?=
 =?utf-8?B?b1ZMYVVlaWxxL080cDI1ZlhReUgvL3QxNGRmM09PRzNmMXprVTEwWGJSemJX?=
 =?utf-8?B?T2kxRjdaTEt2TWhHQ0dhdFNRV0hpamdIVTZlSk92WkQ0OE01WFRxVmlvOTVC?=
 =?utf-8?B?VzRkbWplbngzUVBZaHpLNHBYdEc5bE9XcG1mUWhJNjh0Qkw3a0k0K2RXeDFy?=
 =?utf-8?B?TUwxQ2RTMG9mS041V2cxSWtmQlRWRFZiSENnUlp3bXU4Mit0c3JiU0dUZWFL?=
 =?utf-8?B?Nm15dy93eFlndXBONEMybDVxZkNObUgvYUpRSXBNajd2UGxPbzBqNzB4Yk80?=
 =?utf-8?B?RmMxQlYxWkVvdGhlOU9vSExQOG9RN1E5YlFleEJVdmpFcGUwcE1mS0dVNzVj?=
 =?utf-8?B?T1JUcGU0RjA0cUhITkIvMndmRStjNkJHU29WQ0JheGpZUFdRb2ZzVEsySU1V?=
 =?utf-8?B?NFBuazhEdnkvRXMrK0JxelEzMTlyMHV3bjVTZ3RleWtSM056Y2lRaFJ5ZnNF?=
 =?utf-8?B?MDFubUVHeWZZV3c1bzRZYU1ndXR1elh3VEk3TUhDKzN0TU8yd3k5YXJUWFlX?=
 =?utf-8?B?WXVQdkJ5Yjg1cC9NTnl4bWo3ZTkvUjRjUFhPcXZ3RWFpd3VrZTdmQlJzMjY5?=
 =?utf-8?B?OTdWNGIraWZ1WTNIdzVQcTdOQkpJMlZ6cGJ6QkRRdUpJaTZsOTlnNkZJOXp0?=
 =?utf-8?B?TG9zdVJYSTFobUU2UkxvRU1ZdUVXK3J4Q1NGUlV3ZTV4Vm1Eb2hlSEVpbHdN?=
 =?utf-8?B?U1cycTExS2JVMlJOVXdpYmdyMVNjaFY1U3poT3BSZ05QT202WVU3d295NFg1?=
 =?utf-8?B?blpJQ0FHTmh6Vk1ISFpxUzJteXppT2lSUU5scmtRZmJvc3YzOFQ0emE2RlZQ?=
 =?utf-8?B?Z1B5aERXeVFoc1N2SnkrYk52MVp0Y0pTZW4yRnlodUh6U0lTR250blhtdHZO?=
 =?utf-8?B?cFRtajJFUFBjU3hjM1ZTRjJJR3g4dm55dTU4VlRnVytjekxpM3pUckZmVGNX?=
 =?utf-8?B?YmZFMjEwd3puSUhVZWdlT2NGS2VLZWpFd0psaFpNRWpMNUZHSzQ1cjA5bnJB?=
 =?utf-8?B?U1QrSTVEZ2IyazJ0blFlVk1VUkUxVjNMK0NvOVlsMit6bHp4N2pzeGRvV0Mr?=
 =?utf-8?B?YUVOZFhkRnNnREhvOHZjT1VrNWo3MHJjb2ZVb0pmeUtHeWJKL2xPazRTQTVC?=
 =?utf-8?B?aHRaeGQ3UXFZRXBhR09ZRGt6UitpV0kzclZwMlU0eThWVDFpb3JKZVJ1ckpZ?=
 =?utf-8?B?T1MwdkZmQzYrb1BJR3Z2NmJ0cXlScVNjR1R2Uzh0WkVrdEdNTU9wanl3UUZ3?=
 =?utf-8?B?Vjl5Q3gyVk9nRloxTWxMSjVvOHNscTFseG9YZm05SWpWZjlhdXZBNk1QZWFS?=
 =?utf-8?B?NkxrUVBxdTNGako2ZjBPM3pic2NmMzExRjFUNThQT0xObGVZTU1vc1VVTmtu?=
 =?utf-8?Q?sfA76Ml2rMzTYdtwf2wE+wXe5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a328a8-88cc-4a95-e2f1-08daa8701d71
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 14:27:51.1558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nAzUPFZdB9Rrf6FEThTnFJQW/90k042oLhejO+/eEqcDiQmDOy4QZ4/pzoV++LnV2EFRaisyagW3fG0lsT5OEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6583
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/22 07:25, Raju Rangoju wrote:
> On 10/7/2022 12:34 AM, Tom Lendacky wrote:
>> On 10/6/22 12:37, Raju Rangoju wrote:
>>> On 10/6/2022 8:30 PM, Tom Lendacky wrote:
>>>> On 10/6/22 08:54, Raju Rangoju wrote:
>>>>> The current XGBE code assumes that offset 3 and 6 of EEPROM SFP DAC
>>>>> (passive) cables are NULL. It also assumes the offset 12 is in the
>>>>> range 0x64 to 0x68. However, some of the cables (the 5 meter and 7 meter
>>>>> molex passive cables have non-zero data at offset 3 and 6, also a value
>>>>> 0x78 at offset 12. So, fix the sfp compliance codes check to ignore
>>>>> those offsets. Also extend the macro XGBE_SFP_BASE_BR_10GBE range to 
>>>>> 0x78.
>>>>
>>>> So are these cables going against the specification? Should they be 
>>>> quirks instead of changing the way code is currently operating? How 
>>>> many different cables have you found that do this?
>>>>
>>>> Why would a passive cable be setting any bit other than passive in 
>>>> byte 3? Why would byte 6 also have a non-zero value?
>>>>
>>>> As for the range, 0x78 puts the cable at 12gbps which kind of seems 
>>>> outside the normal range of what a 10gbps cable should be reporting.
>>>>
>>>
>>> For the passive cables, the current SFP checks in driver are not 
>>> expecting any data at offset 3 and 6. Also, the offset 12 is expected 
>>> to be in the range 0x64 - 0x68. This was holding good for Fiber store 
>>> cables so far. However, the 5 and 7 meter Molex passive cables have 
>>> non-zero data at offset 3 and 6, and also a value 0x78 at offset 12.
>>
>> The 0x64 - 0x68 BR range was holding well for the various passive cables 
>> that I tested with. What is the BR value for their other length cables?
> 
> The 1m and 3m cables have the BR value within the range 0x64 - 0x68.

That certainly seems like 5 and 7 meter cables have an inconsistent value 
then, no? A quirk for Molex vendor or the specific part series, e.g. 
74752- or such in xgbe_phy_sfp_bit_rate() might be a better solution here 
than expanding the range for all cable vendors.

Not sure if others with more SFP+ experience could respond and indicate if 
0x78 is really valid for a 10Gbps cable.

> 
>>
>>>
>>> Here is the feedback from cable Vendor when asked about the SFP 
>>> standard for passive cables:
>>>
>>> "For DAC cables –The Ethernet code compliance code standard for passive 
>>> cabling, Offset 3 is “0x0” other offsets  4 and 5 - none of the 
>>> standards are applicable .
>>
>> Ok, so it's not offset 3 that is the issue as none of the bits are set 
>> and won't trigger on the 10G Ethernet Compliance Codes.
> 
> As per the Transceiver compliance codes, offset 3 bits 4,5,6,7 represent 
> 10Gbps speed. However, 5m and 7m transceivers have none of those bits set.

Right, and passive cables shouldn't. Those bits are:

   Bit 7: 10G Base-ER
   Bit 6: 10G Base-LRM
   Bit 5: 10G Base-LR
   Bit 4: 10G Base-SR

which are all Fiber standards.

> On the other hand, offset 6 is set, so the driver incorrectly assumes the 
> transceiver as a 1Gbps cable.

Correct, 1000Base-CX is copper, e.g., passive. So, as stated in my 
previous email, I think moving the passive check up as the first check is 
reasonable.

Thanks,
Tom

> 
> Transceiver details:
> EEPROM sfp_base offset 0-12:
> 0:  0x3   1: 0x4   2: 0x21  3: 0x1   4: 0x0   5: 0x0   6: 0x4   7: 0x41
> 8:  0x84  9: 0x80 10: 0xd5 11: 0x0  12: 0x78
> 
> enp7s0f2:   vendor:         Molex Inc.
> enp7s0f2:   part number:    74752-1701
> enp7s0f2:   revision level:
> enp7s0f2:   serial number:  726341570
> 
>>> Offset 6 – refers to 1000base-cx which is supported .
>>
>> Ok, that makes sense and argues for moving the passive check first, 
>> although the code doesn't support being able to switch to 1000Base-CX.
>>
>>
