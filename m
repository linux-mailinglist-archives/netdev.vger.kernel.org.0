Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13FF6CB6F5
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 08:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjC1GVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 02:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjC1GVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 02:21:03 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611463C11
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 23:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2ZdFqHDguGpUYQs7z6IxGPmOY9v/xkEkZrPsLQxbc4upCnxWBHAqg/9JKhwcq9wj+VpDG9T50Ak7uwEkiNbSxWfibfNOk//ocpsq+ie/1QiNsJLniT9fgjwZIalO1zxNaO+7mgQTetzYb5sXtv13ETG3woJmp46Z/M5NT6axbGmYtN+9d4/JwNVhjRmMsJd9wXqCz3MKlyJTn8YZKl7KOGXcDbo/QINwHQTsouhjKnCZXkLJP5sYyk5Hdfh6Nf/FkGIaGSU20F374tmB1HKyh34/krFeANI3+dBSqCFDaDmNtflChzJovGw09sPwXxQRmqN1UDT9zBj4C0P93rrbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQfTUH29fGYs/TN3o/zgcSFpHcDCj5KGwviONMJMkMw=;
 b=jQeTWRKFvtgdYI0xm/qhWctqxjUV4+GmINz9Mb9gU0qz0J+NDKM7m+H57vwmxZdeapbKttaK7PjmJ/NXwAnipX+5hvviK7QboDwh5zfPWCWMH5J3Y+jSfxBq8ZlGq8b26LQLA7gvwkCVwPpI+rUOiZsGlKT0P7JQwaQ9tZdHFgKtSAfRc/qmSO6OXTkF9Cw9kCiwj7pdsa+0HZKBi7d0zd1XqqtosW75Sp7n4WYecjmYD/QxnAaZNHnFwd0Li4AQoc+X+xGWHHThbcg2PxFxJNUXpalut41iz73HdKgmyO3nLVaHjIqHkk0w+3wZUuaB9A5ZmNkvh1VfLfqL6B6Xwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQfTUH29fGYs/TN3o/zgcSFpHcDCj5KGwviONMJMkMw=;
 b=xDZQHRhHQ99gt8DiBV9358Y2JJetirPnB1sahUMOYy4S23NcmwBrQZsBSwIb1vGgoxsz6kzNveZDSMU0zdnutaJogDCUi7349sOe60LJBPA0Sw+M0xAuveCY2cHK7/CbaRGBl76UQD7IQHza8/TQ4FqpwmSCnnExdvXfjKz83H4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH0PR12MB5091.namprd12.prod.outlook.com (2603:10b6:610:be::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.33; Tue, 28 Mar 2023 06:19:32 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6222.029; Tue, 28 Mar 2023
 06:19:32 +0000
Message-ID: <822ec781-ce1e-35ef-d448-a3078f68c04f@amd.com>
Date:   Mon, 27 Mar 2023 23:19:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
References: <20230324190243.27722-1-shannon.nelson@amd.com>
 <20230324190243.27722-2-shannon.nelson@amd.com>
 <20230325163952.0eb18d3b@kernel.org>
 <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
 <20230327174347.0246ff3d@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230327174347.0246ff3d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:a03:100::38) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH0PR12MB5091:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d3588bf-6c5c-4977-aa2b-08db2f546510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rj+7jJqkdpFbG1jQemqCoukQsRMgt0THJMgLCFGpBjiB1t5cSYuh+FwNOPwsXT9BhsfiRPa8Vpt4GSvPl17HobcqoPc20Kg326wfSNVTLkuS7TxqSozrqg9nOo6K89b+aujqfu6/vRKUn9r21ecyJgh9xiLoZtpL5JVPsTxoQvEIt9VM6Vhw6GgyNUJykVpOoZI04E+FPwygays90RrRIFZzw8UV3wouoWJxUsXZjAhc+1TwvC7PA81oXN6f1dTQvZysghrtV6yeZpqI0xhjclTM7YROvCTn/bR0GguPP8DD115RRAVffNainrpkEmo16Qydk+H8PUV4K9XZLANfH/rs2MOv33UCj+OZQMP6hX6BCQZmhPSrK/THow30WT/5BqAcsGHj9RR3mfrYPmqYPyfpjIl2BaAVMlledvZDXPCTP8x1JKKI2CTNIm+JdmF1Fx3rBIvDsAkDI+eBF4c3W8BjhbojQmGIFDnO0n5mNyswiB3ZjYpWo8jGmc6X42TKuGbcFroYTijnt+HFZBfAOclZyoHHiphIKolQbOdx3zVoa5b6HqnQD7uw5CxmGDRz0OVD0hPejU0xh9nW8ASc1VH1OYcLUdwG8NpCJXyJ0OppDf5DAITEgpOqDQEKJAjaoaNKXGEHoOPnQswncdcbcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199021)(186003)(6666004)(316002)(53546011)(6512007)(6506007)(26005)(2616005)(31686004)(83380400001)(6486002)(478600001)(44832011)(38100700002)(31696002)(86362001)(8936002)(5660300002)(41300700001)(36756003)(66476007)(66946007)(4326008)(66556008)(6916009)(8676002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHR2Y2FTR213cjRWdkZnVnhOeDV0anZYTzFXalpqdzhFR1hkRCsyRUpxWmtq?=
 =?utf-8?B?QzlkNHdTU1liekR1U0I0SElLUE9TS253NTFvUFFnd0t5blhZWE9aL01kZUM5?=
 =?utf-8?B?MU1sZzBiTmYyQncwcGEvSWtSMkJGZGdKNTJuQXNCZ3BYNExFWlI3cllXYmFj?=
 =?utf-8?B?VitIZHRWYXpvRk45RGV1MW0zV3Zua3ZubVh0Ym1lSk1qeHplT01PZHJ5VXFU?=
 =?utf-8?B?elVnZS9pbTY0UENlcDVyYS9QOFd5MFZ5WjhnZEdkRmFWMzNBMDc1bnlpeGo5?=
 =?utf-8?B?WHNraVNlZlhHVk1mRU5GektFWTBvNDVLbFFTUWUxUVBWRmRmSU5vUnZCOWJE?=
 =?utf-8?B?RXE4cWtQRXRNRndvZWJuc1BNTklCSVB4TmlEQ1hkZHpTM045M0gxZC9lT1R0?=
 =?utf-8?B?bGcvZUd1STgvc2kzQ0Q5Vm5iK0RpRk1RYnRBR1VrNVljVlFaV3hEb2RtTUsv?=
 =?utf-8?B?MHF2OExCUGxtMmx5TWJhRkZyczBiS1BPaHMyRmU1NVZTT2xTcEFwOXRqblh5?=
 =?utf-8?B?VSt5MFRkSDV3WmFCdzJ5L2xxTWNTOFFncmtybnBvZkVGVUxmRnZ2Z0I1a3Vz?=
 =?utf-8?B?MDRHS1huSkpnTTE0TzR6Y2pGQng5aHAvZVFyVW5DZ0ZMRnV5OVZwSkppRE43?=
 =?utf-8?B?VWpYQ1llMDl0QnFVWjZsbnU2UlNrdnZLZnVvUmtzMW5PVWEwS0Q4VE9LdXVF?=
 =?utf-8?B?eGlOOXBuVmtURHB3Q0pvYmlYakFHaXE1Tlo1Si8ybjZpSitsUnFsVUczUzVl?=
 =?utf-8?B?UWlxOVdJeGNLWGttbFNycmltUmlSRmNwZGp0WEZSRkRMTXZIVStYRjVMQnVo?=
 =?utf-8?B?QW1FN1paT3MvRU1YTG5Vb1BqU040bEtBSVVMNVFpV3luTkdZNC82SDhCSnVB?=
 =?utf-8?B?OGE0RWd2RkRBSGRlYytraWt3VDVyaU9tanJUZllvaEhCQ2VhdkliaDAydlVX?=
 =?utf-8?B?ZDFvaWRjemxRVnNXVlM3WlhoTTk1aHpHaEdjTGh4UkRYN20yc1g3K3ZZekdx?=
 =?utf-8?B?aDlkV0pEQVpqQTQzTkRQOXUxQy9FR1JuTllvc0tmQnJPTGRzNlREdndBaHpW?=
 =?utf-8?B?WG5ndENVRnVBUjJhd2FBWTNSVlFPTlhXa0l5VDZQK3dpaHorVFp3bml6ZDRo?=
 =?utf-8?B?NCtrakJQWE95V2tWUWhtOUpRMytyOWV3cDNaVXdVSXVGdVFTbjNLTmxaVnpt?=
 =?utf-8?B?bm9zZExBVFhPeVZzemhpVXhQMTk4VHBsV3JlTjZjNUxJRm9XTDRianYrZktW?=
 =?utf-8?B?MHpFY0Q1L0g2R3R4RTd0YmFHaGVpRzNndlg3MEYrR2hYZmRuSFBiU0J6VjVP?=
 =?utf-8?B?L25QeEpDb1Vpa29NOC9JWjBheHdaYUd1ZnAwMEdibU5ERXRocnVEeEZTMENN?=
 =?utf-8?B?V3ZaVlg0TjQ5YU9pTXFSODFGQ1RNaTkzdklsL2pVa3Zwc1NkUWM2YktTUVU3?=
 =?utf-8?B?UUYvcGV4ZDIyTHovekZhQTRiUWppUFdlWnUwaWgxUy9KbkR4azR4UGttVGE4?=
 =?utf-8?B?MEhUenNMYVNRdzN2SXFseGsxSWFDTSt3MTViak9jTmtlMkp3QTg4RVdIcFZT?=
 =?utf-8?B?a2txeEE3emUvcHZDZnZvemJRa3orN3lYcUVIYmFjN0tOa1FGVkw1cVB3Y1lw?=
 =?utf-8?B?cGJ2ODIxNXMzTElOOW1ENlpiRlZRVzNxdHBCdGlkZGhqSlVHT1Z0K1YxUGt0?=
 =?utf-8?B?OTJoTjlSd0lvaGtoblhBdkxMMkFVKy9xNlhuVlpENWlDUWNmTUtodVU5UFg0?=
 =?utf-8?B?YWVpVDhYUW5wcUVhcE9GTFExbENNanZPTXZRWkF6MWpOeDZjRGtmeDNidy9O?=
 =?utf-8?B?K24rcEFHZkhqelpkaTN6Q3gzR1NvRjVvb1VmeFpHeFhSb2pjNFRWWkJVajVP?=
 =?utf-8?B?N0dpa3k0WldQTzFHTi9nR25uVnIvM05uMTNOank1N1Mzd2dsejZENVY2K09T?=
 =?utf-8?B?SXNIV1JLTHZERjYwQmxaSm96QkNhYzZDVSt6Qy85OU5XUkYwUWhNa3gyYk0r?=
 =?utf-8?B?MFc3VmhOdlB0VmRXNFRvN29LRTlDWW1vTGlySXptbnR0aGkvOUo0cW9JQUJL?=
 =?utf-8?B?cFZONnB3ZjB6elFEUHAxUTgzUjdZOUd3L2U4MFBsWTJZNU5QR0pJY2NGdDlL?=
 =?utf-8?Q?l0ffAftc43cZVe4/uTPP0mMl4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3588bf-6c5c-4977-aa2b-08db2f546510
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 06:19:32.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2O7ywkdRaJFuBajvMwyHDWXddD5WHmvPMmV86wMRtpgEuXphZ0hMIEQQSjnooTSnysWB6ehTNeNfPKfwjIPUUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5091
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/23 5:43 PM, Jakub Kicinski wrote:
> 
> On Sat, 25 Mar 2023 21:07:22 -0700 Shannon Nelson wrote:
>>> Don't put core devlink functionality in a separate file.
>>> You're not wrapping all pci_* calls in your own wrappers, why are you
>>> wrapping delvink? And use explicit locking, please. devl_* APIs.
>>
>> Wrapping the devlink_register gives me the ability to abstract out the
>> bit of additional logic that gets added in a later patch, and now the
>> locking logic you mention, and is much like how other relatively current
>> drivers have done it, such as in ionic, ice, and mlx5.
> 
> What are you "abstracting away", exactly? Which "later patch"?
> I'm not going to read the 5k LoC submission to figure out what
> you're trying to say :(

I'm saying that more code is added in later patches around the 
devlink_register() for the health (patch 4) and parameters (patch 11). 
This allows me to have a simple line in the main probe logic that does 
the devlink-register related things, and then have the details collected 
together off to the side.

Obviously, when I update the code for using the devl_* interfaces and 
explicit locking, those two patches will change a little.

sln
