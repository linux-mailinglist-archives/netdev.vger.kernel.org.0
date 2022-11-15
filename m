Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149CF629696
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238156AbiKOLBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbiKOLAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:00:37 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FBF26DA
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:59:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D04J+Qx2p6HSq82C/w4FwkZeRQY9wEagMPk8n/QIaSYD9TF71i5Wp46qxX37M5I8Ye4TlmOZt43n8GQMWr6AsGXxGZVvNIKWl6ZQwkjmAtEgULPlQX5UZr3me2Xb0i7cedr3TE8YudmUQyZzbWGCq4aoGdr1PpJDHzD/+JAZhNnT6l2cm3rl3YzZpqjU7tfs4TMhUmrvG5crluhde0YRvdLcIxFDfq8r4Pppn8wMk/rrXPicVmgv2K88Jo0ldWD8n1i7cG98MKw+VlV+LV8ktPMq1Ah1zsRS7/jF+FK/1F/aVeW1aMTC0BBcb9cb1OKFe8EqlzGl42l3VpyzMStflQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bPd3g46Sf7CpEBUG6wKBJ9pjEP3UK2BE1vh+HOqwNU=;
 b=iKbGffeDNes4dnFKUeVAxycvHATCOS+cpkgsziYalEiWhue01BYPtgwsEcufLMTo5PN3STkzzLNxQ7julHisLMLAgVBvE2zSvy2AL/5c+ND7M2tBPGh5Ia2YS6SBayIrpIbcLLm8nILFHZQIV12ARCA9XdG29rhDJJH7Ate9t+5popH+Yn6WU/ayvrc/RdQe673luBcaNLZKutNdUnoQVfOGrBD1Yfe2qsPHdplYPUJsNtv4bARAXWHrrDeJNO8Qypc3sA4ynbyskHFn8o4mMUVTW+PmqJgdcCWcwEV4uBieHoZCjbwqzh9L5L8hooh2TBnQMXesQY3J/UJaVZBD7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bPd3g46Sf7CpEBUG6wKBJ9pjEP3UK2BE1vh+HOqwNU=;
 b=BC8vQxlQTDfc3By0xkFdV2beWH+Hp9thslY8R4ZVf6j8plBGhwHh0FV8c/Mw+o6ShtULr5Na3v//tKW87A2fVD4x6GFs69laycM4Koy/E2w9ueWVleuvI5gkNJz813ZGDNT10KhCMROC78LBBbV9ZfXF9tRMYGao18ufDUqCIuQ74hqDtZB16SEM/p8Kg/FOc87KNogNiMFwWsOpPSNKsiH3Nd2Kz+8UqKlDKWBTfhyC+R7vhUCiHGftLoec4quV9Qb6SemPu42L5s9eoz8k6ch9o5x5IePj8F0Q5TmQw9Xx4Tjj9v7DV48c/7kNDry/yddERI5CLwO1jqwIUQ7wMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DS7PR12MB6189.namprd12.prod.outlook.com (2603:10b6:8:9a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.18; Tue, 15 Nov 2022 10:59:54 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5813.016; Tue, 15 Nov 2022
 10:59:54 +0000
Message-ID: <6d41e6da-aaa4-6569-d027-896e25711c86@nvidia.com>
Date:   Tue, 15 Nov 2022 12:59:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
To:     Jakub Kicinski <kuba@kernel.org>, Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
References: <20221109180249.4721-1-dnlplm@gmail.com>
 <20221109180249.4721-2-dnlplm@gmail.com> <20221111090720.278326d1@kernel.org>
 <8b0aba42-627a-f5f5-a9ec-237b69b3b03f@nvidia.com>
 <CAGRyCJF49NMTt9aqPhF_Yp5T3cof_GtL7+v8PeowsBQWG0bkJQ@mail.gmail.com>
 <20221114164238.209f3a9d@kernel.org>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20221114164238.209f3a9d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::13) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DS7PR12MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: eeb17c76-a48b-4ccb-0ed6-08dac6f8869c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7BaNnCoMjIUuunZfzhGj2Ydfh01KR5EHN37oGcMGsu06AsOpdhkLOxasiwgV188kaIE6mRh5gTCySGnxgL5dR8XK9F+4IfenSNNKYLfv2Go6mTXdq8pkPT5w9GrljYZF+/t2Jhg2wK9S0lWduQ3M8xhrFQ2Z3ydHlfuC8X/Oeltro/8sxnrc8M4YYU4mjgoF9Os4NIZLq/HPJmMNh416MN9/lXdn1e2WbioBnAbeJQFiVcYegsgwZQ9zbxi+jzbC0PK67PSANWQkTMg+OorU0+SktkWaBHPgppQSq/297yEDxesQCjz7mWMRu3EJFJyNau7Q6OjqonBbOgfaTFr2prNw6MFKnmRxKExkzHDljwQEHQlWvjulHT/9ICQ41tNfZDA5NGiNCIl9Roj1p79GxkcHIAqoHweTE6n5W5IRaJ/W/ekpcUB+Vc0pUjTDjgl1QdSrzIs+SQWEqxSq5gBMWXYyFNRUwJUvZifG7usAQxkReP1zDUI4lFOdWKW6IM/jr4wM5cojDWcC+cniIzebGooRbLYXvdIfGcOYAqULv/n56LZ3NxenCexaDIKGEwgu1AlPYIfR4ZVnS6pcA8I8f82prFwrRveriDfJxFJxOmVf7CyvDuxJKzkmFWdByheFQ+B3mCLBHzQhHta73wPBVux8cZ2CdwfTPPli9W5Y7HTaB/DcK8uoQoJ8+g7f0sIFM8XWyODAcLN4rPzjapxGH7QC+rBLGV/Mo91JLcPtJZsb1qvnFVRfga+SqLC+0nvZd94d/NPEwtqLuGA9jBcD+3ZH3LEmAsCeyQ0JWFSsb+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(451199015)(38100700002)(36756003)(31696002)(86362001)(110136005)(54906003)(316002)(6486002)(4744005)(478600001)(7416002)(2906002)(5660300002)(4326008)(41300700001)(66946007)(8676002)(8936002)(66556008)(66476007)(26005)(53546011)(6666004)(6506007)(6512007)(186003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bitDcExMaXQ0clBMNUgxRDhmMjRheVVTZDJRYzNwNm9hSlNsK3V5Mlk2QzNn?=
 =?utf-8?B?V2w1QXhJU2JTOFBmRHVwdTRPYzZSL01pVTRZWFN3L3E2SVQyK0xrQm5SZ2xy?=
 =?utf-8?B?MVhBek5tUW1tbmVxYWV1QXVXZlg3aUVkRGJybDduWFp2Y0k1NWJJVnlJeGlF?=
 =?utf-8?B?OUdEb3lYY2p2bjlZM3hPRlR0MHJNSENZT2Y2cHcwNVlzZjg0K0xPbmc2Nksw?=
 =?utf-8?B?NUYrYzFIVm1tU2NQMmFRS3MrNG5HVlBaUGpQNjdVRkZTQVVxcjVvUmZrUElQ?=
 =?utf-8?B?UElJZkdJbjJtaTF5ZkZiNDAzWkVhSEVEUlhMNWRsL0JZNURSdjBlOGx4bmor?=
 =?utf-8?B?UkVsVEU4N3Q0dVA0MWkxeGo4N3JwaEtzL3JEclM4d0NYSXJzUTJqMW5xN1pp?=
 =?utf-8?B?WmJNTEJnSEVNaXNBYmdob3pLUEtmd2RXMHJNYWc5K3k1WVpvNllMbEZEK1V5?=
 =?utf-8?B?VG9qS0dvY25QaWJqRUo0VzVla3V3Vmx4MTE0Uld5eE9iQTIvNXU4Nkh1eUhJ?=
 =?utf-8?B?TndON01ZTGQrb3dKdXY3dkVrQVZCMHdoWFcrSitCNjI4NEtBa0xSWXpYdHFz?=
 =?utf-8?B?a1U0N0RLSms4SXVOU25TNHdBVGFuS25BME5VL2dibGF5TWQ5SzUrWTZvZGdQ?=
 =?utf-8?B?VDZnaldIK29PcHVxTFoxc1hiSm1SMVdzcnRUY2VET0I3cldwK0NMME1vcGVP?=
 =?utf-8?B?OHN2RFdxZ0RoWC8xV0YxMm94QUNYaXl5aURvSlBrOGpwcUZnZGZQRlN6UVlU?=
 =?utf-8?B?UXdsckN6azgralIrNWR6NzlzZkNnM0JKNUl0VW9heC8vRjhnNUhiTFNrbmF1?=
 =?utf-8?B?WHcybVBtWERnNERBZHczWjI5eHJvcWJTMVdtalN1eVg1d1VDWkJzajFTV2Nm?=
 =?utf-8?B?enVnWWZMc1dxcnpqaElvbERkODJBMGd2UDh2UVE3NWFRVzNGNThVcHc4UGFn?=
 =?utf-8?B?SHFWVG9RN3VwNTZ4VkFnYUVuZ2dobTJtVXJ3L09GQzZSZG90TzhFdS8yOWhm?=
 =?utf-8?B?NkhLQVBJWVk5eE1PTCtQVWZ0QkhNaFJ2RHpjNzBtaWJYSnFGZVdzN2pVRjNk?=
 =?utf-8?B?dzhKZDdORXRjWGhRVCtJbG13MEZMSzRVdmk5UTNxbDZMamdvN1g5M0wrSVow?=
 =?utf-8?B?bDFwekkwTnpaaXZDTmx3WHRxbFRITGg3SXhkK1BmMGc3elV1anZ0TklrZ1g4?=
 =?utf-8?B?M3JjTHBkeDlRVWxRelQ2dnkwa1MrMUdjZ04vaHRicDg3Rlp5cVdXendwSHhY?=
 =?utf-8?B?dE81QjdEL1JmWUtyMHQxdGgyaFpFMnBRVXZwOWo4eW9qbU14V1NxWC9Ub3ZC?=
 =?utf-8?B?SGVmZG5IdjduTXZyWlE1UXo3dTU0YnNMaEdISVNjeGxUNlZiSzZpR3JINDcy?=
 =?utf-8?B?YVhnTW9aMHJyRW5lOCs2TmZkaFlHSTFNOWZ6NEV1VGlUbElCLzk1UHNia09V?=
 =?utf-8?B?bUR1WnZtbHBiZlZ6WkF1NWovUGs3dHlsaVJCbFZVQ1BRNHgwN0JwSHdBcHNG?=
 =?utf-8?B?WDltTzlQSW9tZGtGR1VIWnRTeERsWmlxS2VhUTVEZmM4ZHdDQzc5dE44NzNI?=
 =?utf-8?B?QWZPc0MxZ2R4QnJFSWd1M1d6N0pucmNSeWhocHFlNFRxY0JBMk4zNDRLUWRh?=
 =?utf-8?B?LzhzeWIwMHE1TCs2Ykd2UWx0UE51WE8ralVxMUpIMWdaRE5ZR3k5UG9pQ2xX?=
 =?utf-8?B?NFY3dkw1WE02T2htbWp4WCtzRTFERGJ0ZDlHNEtxNWJNdUNTdVFiN0dMcWRM?=
 =?utf-8?B?QWxVNndpaWdaUS9ycDYyZ21nbCsxVWNUZHJ0a3d5elgxZkFFTzhGUnZLVzRD?=
 =?utf-8?B?RmdVZHVTVFJobHNrWGNISGpiSEtkMFM5bmRqbU5KSVhWc0h0bGNBT1lFenkx?=
 =?utf-8?B?NUhYRzczOXN5aS9aWC82aVIyUk9KV2xqNXFvUU5jR1gzWnY3OXhsV2x3bVNn?=
 =?utf-8?B?aU5SU0lIcXBrNmdEekNON1Z5cEFQREdmd1VmcUFTK3ZiWWtpQ2pnaEwwc2lQ?=
 =?utf-8?B?MnFpYWlmaVVlVzIxOWlHVEtwdmh3b0RmeWZza0xBS2VSdVRSbFBLUkJ3TlNW?=
 =?utf-8?B?ZTlRRXVxbmRuMTFCdUd5VUwvdWxKQUVPN2xXeEFzUHBBLyszc1JZMTAveHVS?=
 =?utf-8?Q?P5bdWCRZ9ydmp1gv+LKVPpHxz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb17c76-a48b-4ccb-0ed6-08dac6f8869c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 10:59:54.0940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymvXU4ZvnAK+TZdge+zfhYzqYy81o0Ont2E66jixyKBzkbiMmuEClSiPaN02BCFS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6189
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/11/2022 02:42, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 11:06:19 +0100 Daniele Palmas wrote:
>>> Isn't this the same as TX copybreak? TX
>>> copybreak for multiple packets?  
>> I tried looking at how tx copybreak works to understand your comment,
>> but I could not find any useful document. Probably my fault, but can
>> you please point me to something I can read?
> FWIW it's not exactly copy break, as it applies to all packets.
> But there is indeed an extra copy.
>
> Daniele's explanation is pretty solid, USB devices very often try 
> to pack multiple packets into a single URB for better perf. IIUC Linux
> drivers implement the feature on the Rx side, but fall short of doing
> the same on the Tx side, because there's no API to control it.
>
> I've seen the same thing in the WiFi USB devices I worked on in my
> youth :)

Thanks for the explanation.
How would this apply to a pci netdev driver?
