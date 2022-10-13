Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572785FDAF9
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 15:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJMNgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 09:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiJMNgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 09:36:03 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF3DABD78
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKlGL6XugiC3mybZogzy41nxKnA7iZIi0JVVABecvogskMUUlbCFdNpSwg4cTLd4Ll0hO0SCCAdg2/0y6bidSTqwAvvy1DP5e4oWX1JMbDERBpfG91/Bba3OCdlhJAg93qLAvn2fG8K40g3lznmkcb7dXD/CtrWx7b60HRStBTE8nR9fJTmRQf69ln2joQTRUBu96NVmrBvDoM1Ysq6SoVstfkKTXka1uh5JdxPToiXtrMHAVhSklAur5qX2a6/aSIr2hNOnPE/AkuVnoBPdXKUMuD3riun4NWbYahcHVoY0f1nGwWwyZK3PVM+lyQFztFF8oUFD3+P7EZKozMP13Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FG5BE8YUX4eEHEsI/rlcZ/Z5F0sf2Jh/2tqc1HvfvYw=;
 b=OyD9d4F4BoqpOxX0MDnQRmASyCKz9PGAYDn97HzMhJq/X7iS0U3kxOFrk0o532dYIP4EXI79c/KVJShmcxB8WG0KIwi40vMKy9aPqyAboKD4bcg6IXOp52IF/ePXotSkzOfAepteEH/7NeiWOWiANRTy3uO/dONuR+kUUzj/zbEHcxyV/z4BYcopBLcDZSsH7r6I6f9mgLuuDXQPIJb1k5cr721al9ZuDi/kPfDrwRvROBafIi6BApW5l9j/nEBU0JtBwkqxB3vhXkI+XPtDKWJmEMhiCIgepS2zB3HH2kbHTK4SdioaLXpxqwUifrs9Q279GqW6noCgFJ5+upxEqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FG5BE8YUX4eEHEsI/rlcZ/Z5F0sf2Jh/2tqc1HvfvYw=;
 b=R/9YBbvWAxHhIccbO2qLLKvZI6RrBHYY92vJ3vUiMU+FZdeboWoDU2kEz2jT7CUSbMoGPkaQVzmFUeGtM5hMf8aeOazELcSOdB6xXTab9E774fkCk15frG68OuwlP9w7VIjo+6D2A9JYPcso0uOfo/NpaLi/nL+Y8heQpW8wSpA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6207.namprd12.prod.outlook.com (2603:10b6:8:a6::10) by
 DS0PR12MB7582.namprd12.prod.outlook.com (2603:10b6:8:13c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.22; Thu, 13 Oct 2022 13:35:56 +0000
Received: from DM4PR12MB6207.namprd12.prod.outlook.com
 ([fe80::ca06:3a33:5bc7:67f8]) by DM4PR12MB6207.namprd12.prod.outlook.com
 ([fe80::ca06:3a33:5bc7:67f8%5]) with mapi id 15.20.5723.026; Thu, 13 Oct 2022
 13:35:56 +0000
Message-ID: <3977a1f7-eb5c-2d12-fa62-d501c56d3d9b@amd.com>
Date:   Thu, 13 Oct 2022 14:35:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
Content-Language: en-GB
To:     Jiri Pirko <jiri@resnulli.us>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, habetsm.xilinx@gmail.com,
        marcelo.leitner@gmail.com
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
 <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
 <34a347be9efca63a76faf6edca6e313b257483b6.camel@sipsolutions.net>
 <1aafd0ec-5e01-9b01-61a5-48f3945c3969@gmail.com>
 <ff12253b6855305cc3fa518af30e8ac21019b684.camel@sipsolutions.net>
 <Y0gLlKo8JGJKA7nf@nanopsycho>
From:   Edward Cree <ecree@amd.com>
In-Reply-To: <Y0gLlKo8JGJKA7nf@nanopsycho>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0384.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::11) To DM4PR12MB6207.namprd12.prod.outlook.com
 (2603:10b6:8:a6::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6207:EE_|DS0PR12MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: 970cb142-7065-4d1f-ee18-08daad1fdb2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UoKNU0FLJCw2ihKqGowpfM9Moy9PP6zM06URTSXLI487F3lO2jskxGb1Tzb7/puDuPgzm9iZWYFIU3nCoZF0moEHJaf3z1/1VWmvVI1fefpt5UL0zouULlTBeVFM4UtIYJ76eQD5Owq4nzRoPTQBt6MOt6Xb2pJAsdHhug+dvxNcaMl/99asvjBsaM5tbZdxFqfe8MvvDvF4rScohQ4me9b2zVdfncwXOgd3BOqZKK4OhcyHGkBoQ8FEKv3CGKNl3N19dXT+iCVA1IPoqUUmkJg43CM9aDedWzDgGsjR/afAFVTeevFChAXcl8KTVPDjWFFY/pTpZmFHeqRBy0FkRhzRb9RLdEWquswXILcc5sO7FAQAli6ldqEJXfxt/FKVIiEJX8TU6PjB1qP3ycpP5WHGX3OYYwyMFHUV9inBIGSLFs41SX1CCD+EZGK1FkK33Y9moNm8r4PHTh2CuVVQDPvdgo8azyDE0ja2RKozkTuv6XOGjexBUQJE2BIFI3lXmEFfnp87Wk+XGfDrjhTJnvr1MXiSXtewbdpOfTycRIFw0lIpWe8zN3HJmrbjHYJcGBBlCPZ+MNFYV/3MiEvbO6fbRr5485OO2/+Ug3siUaKJWGDvx0Z3mlBKUllGaledL10J7vFIVBJ724aTEhk404AN/NiLVJp4W3IMDy1JNekJ1nyiWaz2pKLqudiawoBeMd1cSEI/S1USVHI95V3qU9+i13v1Mp9+z+okIz8F3lQYcE6S93CEG7CnTmvwSzRcTaaOLLaaPMGEaF3vi8XlpPT+bXtCR/6p4a8ZeGeWiVg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6207.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(451199015)(66556008)(4744005)(110136005)(6486002)(478600001)(5660300002)(41300700001)(4326008)(66946007)(8936002)(36756003)(316002)(7416002)(66476007)(8676002)(38100700002)(6512007)(31696002)(6666004)(6506007)(53546011)(26005)(186003)(2616005)(83380400001)(2906002)(31686004)(15650500001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czFKNkRFeURab2JVdGNkVC84VUltZFZLS3lLa05POW1UQS9CVS9VOEViTlR0?=
 =?utf-8?B?UUV1UkM0L0ZNUnRHcjlyUmhKM3RONFJ5WHZ5MWVTNVFnK05raURlVlVYdEFZ?=
 =?utf-8?B?TWU3Y2VBc2U1TTcvS25uV2pSR2xYQ0NKaWhkK1lHVFpOL3RjTEhKY0Q0VWxQ?=
 =?utf-8?B?b24yRUtmRkZpbElTdGt0eWJDS3hhdFZnNUlWSmlHbzMxb09qMHFVa0F6V0l5?=
 =?utf-8?B?dlpNMm1mZnRmWXI0WlhvY1k3cUV2RER4NVNObzN0Uy8waU4zaXNmeXZrRkRI?=
 =?utf-8?B?c0ZsVmJ3RHMyZHFYcXRwcWZITVRrb2pZSytYeDZwRS81THRBR3d3dUdGSnh5?=
 =?utf-8?B?UHNrT3RYU3o2TmVlZFVvNm1LRGdSYmtPRmxodUVxcDMzZ1dsbG1OVGVvclBL?=
 =?utf-8?B?dW5IZmlPeXkrak9jYWUrZG1ZYnU2Q21zUy9LVHZ1cFZZYTVNTDR5T1Jpd2FT?=
 =?utf-8?B?UWhpU044ZlRRZ2tuaWZMSzdQN3h3NjlzbWVGYkR1QkZpazlGRlZBVTI5WWt6?=
 =?utf-8?B?cSsvb2Z4M082YzlmbnpLV3J0NTdabzAxU2cyS08yVEtRc3U3VGxaR2Znb0NK?=
 =?utf-8?B?ZkRHd2YwTU9EZm1zRXlGNnlrbmhDaU1RdGcxUCtEN1NxZ3prWlpwMnFnWjBt?=
 =?utf-8?B?RU8xSXc1VEV3Vzh6bVlsR1NqNWpOQTc4b21qeXppSjZOclFYR1dJYWFCejZj?=
 =?utf-8?B?N2g3TGFuZ2dISHJrcUJnb0xqV3E1My9saVZ2OXNTcStEazk5YmRRYzFJWm83?=
 =?utf-8?B?bkQ0L0wzcWNjMmhTNFlSM2VGWUIwNUVJeEphMmhKQ1RVMDREYXpHc1V2cUI4?=
 =?utf-8?B?dGNOM2lvbmFMS21SdlNYWVlNN0FCUXlnT2xXRnhnR3hBSGdmbE5yRFpqWnox?=
 =?utf-8?B?WlR3Zkk0ZDZpMlhsSms0VVFJblY0OVdiVkp2VEVGczh0UUhSNWdmelhGamNt?=
 =?utf-8?B?YjBBREVUZDM4YTNmK1F5cFdHRllZRGhXNmNQT0ZNNXVRR21sR1Nobkc2cEw3?=
 =?utf-8?B?aGZPdTFWcENIRm4wbXB4V0xDOVcvdlh1MWg2bitmbzErdEw5Ui8wN2JLNmdL?=
 =?utf-8?B?WVdHNHJBd09nNlFXU2tEMXFrK2FNK2dsS2pFYzZZekUrRU9OUWp5ZERQSEhs?=
 =?utf-8?B?UXJYWklueXhBK1FnMGJHY2VyREpzcnY5U3oySEZ1Z1ZXdE1uQ0ErU2xTWHZ1?=
 =?utf-8?B?L1U5aFRPL1FPWHNlTllENXpBaW5PUmxWL3hUSnBWZURxcEFoU2tmRER0WXg0?=
 =?utf-8?B?bnVxbTFHb1dCNGJ1cFRhUEdQMmZnZXNHUzQvN0FSeWRXTGNWMTFqUzF6VnJM?=
 =?utf-8?B?b1pkL2ZLOUxFY1hIamRrdGl4Q2RQcm9zTlVnaTlXam1WWGxOcGZnRDVWWVJn?=
 =?utf-8?B?aHFXUGs3SnJ4VjcxTXpHdFdUZmg0ZVRyMXRBYVdJayttVThIMmxXT1JZeVdh?=
 =?utf-8?B?SFFvN3lQTFhmMjBmWS95K3JsMUlWUnNTNkZ0MFpSQXVHRG5HUlFtMFowWERR?=
 =?utf-8?B?U3g3dm0xTmtuNHIrdktLZDB4eWp1YkE0aUo5alA1bmpWZkJCQ0RLNFNWMnN4?=
 =?utf-8?B?ZEU2YmExcFRWN2ZsWTJINlA2bXpxa1Q3Wk9ZakNoVGY0cTdvd2hMT2k5L0l0?=
 =?utf-8?B?cDR4OGdUb0wwczZ2WGhLaHY0MnFPbEhmVTBFUm0wMjJSdlFRdjVnM01tdXlI?=
 =?utf-8?B?SEU3dnBKaGFyYldyZVplSk1OcGJCMlplL3hMb3JmV3B0bGJFNi9YMDFiNitO?=
 =?utf-8?B?eE4xcng1Nm9TYkkvUGREN1NaRFVVbWFOajVONHc3UFNBRTd0MG5XWVU1Q0tT?=
 =?utf-8?B?ZWJDUlhJU1BRVVUyU2xVUzVQbDVhUlg2UlhhT2tzYm00UzJ3QUVKYnpBb2sx?=
 =?utf-8?B?N2t2S1hsQkFCRXVxUVgxTGZSdmcySXByeVNMWkI5dmxOOGF2eFBZZHJrNmF6?=
 =?utf-8?B?WnNwOU5qbllnOWJjbGZGNk5jcGtBVUlVZWlPN0Z3cTdvMjNGdlB3V1d0OHI2?=
 =?utf-8?B?VStCWjliOXNsakFyakU3U3lYbDdaeVF4Q1gxT1RmaFFMbU5tVk5LcGFvS2M4?=
 =?utf-8?B?NFMybFpuTDQ5SWdsck5BYkZ5M2ovNlVxWkR6RnBoTW0zRDNIclRnQ1ZoRkMz?=
 =?utf-8?Q?GlSI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970cb142-7065-4d1f-ee18-08daad1fdb2a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6207.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 13:35:56.1941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iM+UkzBBgX59otMBDYQweD0dSgttFb2Fyy/vFtgNwD9LdK9RTmWkwsQWbUSaKCiX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7582
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/10/2022 13:59, Jiri Pirko wrote:
> I think that the macro caller need to take the buffer size into account
> passing the formatted msg. So if the generated message would not fit
> into the buffer, it's a caller bug. WARN_ON() is suitable for such
> things, as it most probaly will hit the developer testing newly added
> exack message.

I disagree, extack is a best-effort diagnostic channel and it's valid
 for a caller to rely on e.g. %pI6c to generate messages that *usually*
 fit but can't be guaranteed to.  And original dev might well not see
 the WARN_ON() because he's using addresses like fc00::123 in his tests
 whereas the end user — who maybe has panic_on_warn enabled — has a
 real-world address that takes 30+ bytes to print.
Then there's things like %d which can vary in length by a factor of 10.
I think the net_warn_ratelimited() with the full message, as I've used
 in v2, is plenty loud enough.

-ed
