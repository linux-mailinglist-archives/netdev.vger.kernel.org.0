Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E5E645933
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiLGLrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiLGLre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:47:34 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04olkn2087.outbound.protection.outlook.com [40.92.75.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227DD25E90;
        Wed,  7 Dec 2022 03:47:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnUpseeFN7jdqjE9guJIbn7eS1qDVP11tLPTXvezaYn0Tw3JdAEfmR1HKaRYMwVt9h3KYVPBU3qtVskaKapanpg9RdeuaeXqiPgbXcWiWxoKOYuEXjEh7RbShYAVRO+mgaG/xQI1RFJym7/SfVrqWUaPPT7posk67fMjPNlzWzFeee5oV5VNt8PCDrb8RzbM7VP2ih7pw13A7fbUX4jkR07V+ZkWQV6NJgdVQjakjHb9iQyKqCNIjd3kieP1zr96ejfSXgR7RvgnnH5xY8oKkJiXjbPrVGsVdRWXULoo3MP6Y+ky7Ei/KrapIkkZDjIKj7wZsyz2yXPRyoF3C5fm5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZ2BJ4IQwzf+6jFnNjpBnGcsekbhsTyI1VhHD+JqKPA=;
 b=YADaH9gSeCU7aoHyi8Duqc5uuD/L2EDcp5M/Qgp3C424V8e0c1ljdEd3kpwQFeq9NBwI9Gu4XJEal9fkCGJ4BIihnFOQPHZUf5Nl2V2EHrRdDjwqNJMJBct+mt0F0Oe2RoLeZFskUw46XfQ1UVgpDZIumrphx54C49Mr6c9c5ZBe33zQ4wNUP6FXbvbtAnvTaRKZ9CaEVjh8Y9TpbNfQF1rVpWSyKtlFcNp41p6sqGsR6HV3bKj/ap7oefDIy8FuBvlDew4vq5HB2xhC4PvENe23r1MwnJOpKWHazaB7uoP1prZuxY8b4E69EH/Kyomz4h5T1ShMI6ohG0yji+C6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZ2BJ4IQwzf+6jFnNjpBnGcsekbhsTyI1VhHD+JqKPA=;
 b=htHcvyR66JRMt4Xw1BaULMcLteqPCO0PzCY7fqID3B/UfmQyK2heEUw5gEBYvTxf5MW+pUUPIMqwxnVAm8yYq6MbOLFwRzdg2T25kGaMZmim97WFZZ1SxZTQICrrbPhXXfqWtUOxVgOJHTlu3K3eIT/zb0aI4IW/XgxZjqWr+N9cReboKVGUHLk7UeC2buiB44R+IrI9aW3JgmWvZaS+iFqiPO2FLxKx1R/2p1JB+nqHO/Rs1f2X0sVJoZUKf4khNN1Oa9os6sE8ARzkyL6mOLywhuw/KmJXfpwHhIQHJEyD8V/dYXGzRfBk4pSOig+HpjspLlyRDQBcxXC9foT2XA==
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:34b::15)
 by PR3P192MB0668.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:4a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 11:47:27 +0000
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b]) by DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 11:47:27 +0000
Message-ID: <DU0P192MB1547BAB562FED0D6401DF5B1D61A9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
Date:   Wed, 7 Dec 2022 19:47:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH bpf-next v2] bpf: Upgrade bpf_{g,s}etsockopt return values
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        andrii@kernel.org, song@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
 <DU0P192MB154719A31758750149418C73D61B9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
 <2118324c-a6e6-775d-77c2-75587e69e7ff@linux.dev>
From:   Ji Rongfeng <SikoJobs@outlook.com>
In-Reply-To: <2118324c-a6e6-775d-77c2-75587e69e7ff@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [WnwgTHvMWlEyJQpAplBnQ2ff5ZxZstH9]
X-ClientProxiedBy: BYAPR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::43) To DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:34b::15)
X-Microsoft-Original-Message-ID: <adc2b8ed-fd65-19ad-33d2-b968d8b160ae@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0P192MB1547:EE_|PR3P192MB0668:EE_
X-MS-Office365-Filtering-Correlation-Id: 848f6368-db80-4d5a-702a-08dad848d08a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JykCh2teTsuK89jBGKFsOOamQIqq7qb+mtG7Jhq+JtZeor+tb+XWcTvgz07A4XFz18esX2At1wYkygMNfMW5JV8lcmudpYK0DE/5PqHgyxNK+AkCll1JcmbqluSwb0GnMElMLYx+7MIJinjGiqwOYF0FubB8+V137vuinvueb9C0RbKLrAzZN3acBAcIhj91c23bTJ0MLIzLBTHad0KKQzNs+pt0dCeyTSvU54IQKY5njRoW4EXb0MZeFdBXrcva3sGMxFj7E7ATAPa4gB/BPxBGzj6HhxXSartsmxIGHhBgy0WRlfXbXnCf3Pnk2KeCm4kk2+LXua5XNE4bnhKClreJwpYv7b9zYki+pPt6WT7fPubeCm+NzBnqkvvjKqVAg4OW4bnXShvADCctQCC2Khc9Dsx/oTD0J6tcRXv87WxNWKMMhbGu2Vna17+eH/s7bqFIwGAkgqXD0JIeJ85mrSvP3KX6qYUAGjgQ6OikyYcruz9B3bcmUIAaqGVf91nLh12W8THbQfkYdD8+1x5Zk41fSzByrxd08cX4BiDHjLSCXG0D2pFMyAVF2dOQqBDEfXjQ5E3DLLsndTEa6MTFfV1kvzB97gcGYtdh5JZr3ItpFcEE/6tpEFGRHNGgreVV8nl8A52E7zfewVUpfkWs3A==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ymg3allpV2k5WFk3Ymp5aU05TlNGNXAyRWtqL3dveXpJL0U1QUdWTElYdXBH?=
 =?utf-8?B?eUwremRMdVM4U1J4NlFHamYvMVFSeUFjeGNNOFpTdHdZUzZtNHhwVW85Q2ov?=
 =?utf-8?B?cnBuT1BFUkxxSHFqQ2JRRk1JbXdoYUpqMlJXdncvOWJKbW1YYkJqWTZpSWgv?=
 =?utf-8?B?aUw0YVRGdkF6ZVA5bHJ1MEd2Uzl3YjdVcG1LNUszVXVMbk1FVW04WDRnYlpj?=
 =?utf-8?B?bk5KZDJNVWk0Q2g1S0hOZEZLMGdqbEJ5N0NEb2xiVzBIRWszeFQ3dkZZSmp5?=
 =?utf-8?B?NzZUdTluV2N3Q2RUSFlzOEZWNy9WVVl1UWdla1grcjV5ZC9yQk5zd1MrdkNB?=
 =?utf-8?B?Q1ovdTNFMyt5QlczR1N2UnlmZEFBU2NzWVV3L2VhZFRwZTk2ZUttWTVEK1ps?=
 =?utf-8?B?dGtMeitNcXA4NmtLeGpDbHpBbTlLOHgydWxHR2tsMUQxVWg3em5vbFU5eCtW?=
 =?utf-8?B?UktvUW1xVVFzYmVUTUs5WXF5clZuODR0ZnNZNGRwMWlCYW40NHhVcnk0MHVt?=
 =?utf-8?B?WFFRRzNzc0w2MlJVQVRIR0todkExY2ZTK3pWYWFiNk96Y3A1TGN0VU56TWx1?=
 =?utf-8?B?Q3JvVzI2aDRuMTVSaWxRek04SlJSYVN0dEcrWVFkd1NNY1dxQUUzWW9ONWg1?=
 =?utf-8?B?ck93NEZmTUozcU05aVVBMVNNbnByWmhwK2JXa0pmazJFdkwvd1BFWlVTNE9S?=
 =?utf-8?B?TEk3ZDZrd28ySVl2WHUva3RNR1k3VjRuRjhUTjNURzk3MjZOalJ6WmdJQ0x5?=
 =?utf-8?B?UHRsMEZ5Q2UvYXBqUVZiSFVBZGhtUUk4UndxeURqbXptUWFXSnh1ZUVEbVBV?=
 =?utf-8?B?UmZTZTFvajJMY2RwckMvR2RaYlBXZDErK1pnZC9FUUNMMnVqbGtuNkVSWUlX?=
 =?utf-8?B?T3BZL2RXaEpxY1E1SkJ0eHMrbzdoazQzWGkxdDl5aHM1ZUdwRVJONXVRcmVP?=
 =?utf-8?B?Z0xScEJuQm15VDBxeTF4ekNtTWJ5andndlBpSGV1d1Z0bDBnY2Fmc2NzOXVn?=
 =?utf-8?B?aFlWQjl5SXRpb3JUaVo5V0pIZit4Y1RvQ3BxNTdhUnlmSThqZTdmY1Y0dFk5?=
 =?utf-8?B?VWg1V0F1RkhDWU9pamtteDU0QjBpL1Noc1o5NC92VGdrbXpSTG5rRzBHdWps?=
 =?utf-8?B?S1M1YkxEUGhkQWZ4b2U4Z1M5Y2pqdXlWd0dTSjZjeGo3VWN1WjRVSkVVTkE4?=
 =?utf-8?B?MUREeVgwUzBuOGZHQmY1d3lFUUM1aHA1SjVaMC8yT1JYOTJSVkIzNGxtMGRR?=
 =?utf-8?B?TURXZlI5dXRpYWZGa3ozODFxbXIrVDJ5VEJ6cE9QQVE1bzBLYXorU3JXdloy?=
 =?utf-8?B?eGpBb1Q2TGdpSXMrdFN6d0MvU3lHMkwvNmkxUEZXTEtNMkZBUDFQZ3poK0pj?=
 =?utf-8?B?VFlXc3RhV1ZmVnA5cXloamxIcEFUT0xPaE83SDZ3b3FWVDhVY1RXWEk1Wnd3?=
 =?utf-8?B?RjVlSTBZQmZRbUgyUXRMckNUc0xqcmw3ZXlmZTJDbjVNcFJEK1l5TUgreWhE?=
 =?utf-8?B?K2p1SkU1TVV0YjQ2VFRlREpxOVVVd1VqRnRRUmZLa0IrOEc1MVA3RmtrQm56?=
 =?utf-8?B?elVWbGx1aUx2VEx1bXlnb3ZhaWJjbzArTnlWRzMyYzgxcGdtSUFidVgxdVVO?=
 =?utf-8?B?ME5mSzh1dUlQWUpsVDV0anN2SURDNk4vak0rOWFuRHBJZzBrL3hxZ0w4Q1JY?=
 =?utf-8?B?TVZsVG1KRmFNUG1OeVU4aGVOdjZsazVlTlB3andpbDY4UkJmeHg2SW9RPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 848f6368-db80-4d5a-702a-08dad848d08a
X-MS-Exchange-CrossTenant-AuthSource: DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 11:47:27.6668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P192MB0668
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/7 2:37, Martin KaFai Lau wrote:
> On 12/6/22 8:35 AM, Ji Rongfeng wrote:
>> I have noticed that this patch has been marked as "Changes Requested" 
>> for a few days, but there's no comment so far, which is abnormal and 
>> confusing.
> 
> It is obvious that a test is needed for this change.
> 

Sure. These unique return values will be written into documentation and 
widely used in production environment. So I will add some tests, to make 
sure that they won't be changed accidentally in the future.
