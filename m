Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904ED68C4AC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjBFR0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjBFR0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:26:40 -0500
Received: from outbound.mail.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7062BECD
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:26:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8zhgBkTp7YjLy5LcYDDlE430XSoMmH9UM62x8ep4c+NFohgXJFF4K9oUrEWtmD421h3iA8g+l0eH3iyptXuIYxXSnIwnCK2aTUZuQPNDr0am3oLV+jw1p15Cg0uZmKWt/dVQ5IwGKFNsroVCy96z99L5zrq8l5UtENm1ieCVAGFpgqu5k3vbKzyGhbXqpvRfdC69+lulyeLieTzNVDlp3Tn8qkd6HhNF8oqzv5dJb+PfWWg/ZD5C5T/P+s+dIOQyzzEi50VZ1i1flUgxWz3l2yenOcTPk+CqY+gFVwTLMOsOUF8gtiDZOjaQ1albTL2mgxX8tVNuKFELTfW+lOzUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhwchQEOpj9irvn3KFxmQ7Jbnyf4CCFcudtAddoTen8=;
 b=FKhZ0ARfOsaDySgnKKjqsDYlwfqtrw9rCoD6OAZShpJKpLsL56JQNlbyRbF+UYny/et4T2hhIGXBB3/q7SpbCd9NgmEEz1x2A4PZ1IBRbIoawNqnbOqobs4mviJcnjyZFlp41cZIgwZrmCpIst7p4u0K7rbIygFBMSirdaRMGYUoWLeelZRUy7QaNPtCjzUlDSYMq+Ho4+3CxVyrNPyBNin7Nzu4yNkQ7LlDdOBm0lAqUBuopNfkfAQ03/ubKHeMlFtLvTO5n2z7qZFx2v23FTKS8YMYBRMN9dFG/O0FPexxWf+t7fBmj6UX2aBF8ftchPPlViFIt1bsmZwj4LRo2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhwchQEOpj9irvn3KFxmQ7Jbnyf4CCFcudtAddoTen8=;
 b=RT7eR3Ry2HAVX/Q1tilizbPbMCZ6JZgGHJP98m+Wsiz5S2NESHsWKnoStRfNn8GBzBz6VuAJI7VChgXe9O5g5TypJIGatGb9aFqZ3pVO4V19Xb4FEY5o30240po8/DkmOHNn55tZ7yStW29TIBdOJ7cgvEE59vGQFoNoDJO0LdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH0PR12MB5139.namprd12.prod.outlook.com (2603:10b6:610:be::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.35; Mon, 6 Feb 2023 17:25:27 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f%9]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 17:25:27 +0000
Message-ID: <2cf1ed45-a2ff-b351-6594-01fb8fb9bd3b@amd.com>
Date:   Mon, 6 Feb 2023 09:25:24 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 4/4] ionic: page cache for rx buffers
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io,
        Neel Patel <neel.patel@amd.com>
References: <20230203210016.36606-1-shannon.nelson@amd.com>
 <20230203210016.36606-5-shannon.nelson@amd.com>
 <20230203202853.78fe8335@kernel.org> <Y9484wAMzK+byKeq@boxer>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y9484wAMzK+byKeq@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0066.namprd02.prod.outlook.com
 (2603:10b6:a03:54::43) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH0PR12MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 6282b044-6c04-40b2-2982-08db08672325
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZLDw/k5/Lc1Xy8uXHWO5QmKYCycnS8a1pQvSx2fxeYaaSFBeay0l5BJXhl1DVJPmqMihGFgl8N6V/LTpt88q5957SFdWjLu/M7Q3/Mq2r6xhF61KWSq9FnyCDEERXhU2FfOA44iOh3zfJUdKRKLoHDLy2MDxrTZCkyQDGCya7mxhCd+9LNsP810fjV496ueQrAPIhhTMgYCwL/jYAyFt67TpFlr6Ojm4fdtkEN1mxs0SLxjzs0Fpb06kS9Tl6ULLFascWAm/CfWPJ5axXkj+27Hsfxh1ItcQOn6vUAd+PGowgQm/VnTc+O6H4zMeSGAtg72QCX9aEOv1nsE+OIWxY7kklaToHCNa9FanUteyGCr1XxOIPqzOmNetU5DfsijsOURQfVFFq4ypzPpWp/5wtK0XyzLs2nJQobbD/KOfNk6r/64nrHIq5TN1jJK357ptZtyeL6yyFUWs/qgDmOWBtAIMqHT+17v3+uHIb0y4bd1d28al8mXRcu5QHI3/0b1iSNM4msIC8Nf0tB1O8oDQ4YHfPFix+QpvczJHvXp3Om9CJ2fSzhbdHbwkEgUymxzdBpdz3i7lw+L+iF/vhsFhW2LKfaajmMJ5dMgqDK+1iNF/8CuqdiQaqCxTJ8XEcSLFVE6nR47mBxQ3om7OsVIJbwqX8iYbmxEcO7PaZ20RUzSSR76eScZal/WcNm6jzshKLVFrbYaxWuphGpAyEv5lXwhyghU27qcLldXGYb80Vo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199018)(36756003)(44832011)(2906002)(38100700002)(2616005)(5660300002)(8676002)(66476007)(110136005)(66946007)(66556008)(4326008)(8936002)(4744005)(316002)(6666004)(41300700001)(86362001)(6512007)(186003)(6506007)(53546011)(478600001)(6486002)(31696002)(26005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHFJbHVEcVg3NE1mdVlaNEduYjBDMnYweHdnMVJSdWNJVzhnRVEwR0JEOElC?=
 =?utf-8?B?NmtOckJWMmtsaW9PUHV0WDRobjFJQ2Zjelc0M2J1aHJJcHVLbmROV0JOb3RD?=
 =?utf-8?B?VnNxV1dML1B4RkVqa0N5Z3Bwa0NmWUtmU2kvVTBGU2lLZUNuUmIxNVJYWDd3?=
 =?utf-8?B?SXFlTXZFWkc1amtUb1pWUVN2a0NCOEMraGRuUVI1dmNNVjZTUFpFbENpKzhk?=
 =?utf-8?B?cEV2WmNmNnJvNVR3WUdhdVBKaGtITkVSaXQ0SVNEOXhRYkRZZ29hUkJFTlRk?=
 =?utf-8?B?WnhmcDBiVlUzanVQOERSQk1OZTVVQkRrODNRZ1pXOTdMUld5dkZSeUZKTUN5?=
 =?utf-8?B?MksyN1pIblhML2oweHdNU25oOENiMkZvaTJYaHZ3S1VRMlZNQ0k5VXRBUGlp?=
 =?utf-8?B?bHdvbkFKVUR0UUswNWpidU9qdUYxODk2eUhaSDc5SlpYOHloQzk4N3AxRGx5?=
 =?utf-8?B?UjJUMVZCaHYrbWZKSWxYaCtIMkFzcG5KUnE0dlNYUkt1aGUvTFBldnQ5QUJ6?=
 =?utf-8?B?S0wrZWRpc2hmeS9STE9xRklna2tKMDZtQlZvUzNleWhxVXcwU0lEVGgyNjZ0?=
 =?utf-8?B?UTVxNGQrbDRaMFlnZFgrSE1SZWRCM3EremdLOWU2ZmNPM2Z5R2pORXZ2MmtW?=
 =?utf-8?B?K0Q5ZHJMSXQ5M25qSitjYlpkYUFkWTdlYzN1cEE0Z3dmZERVQUUyQ045emtV?=
 =?utf-8?B?aitqcXJ6bi91Y2g0K3o4ZlNPQUQ2U1ppOHEvZERUejFQRmZ1VlYvRmY4bzV1?=
 =?utf-8?B?dFBDMlkwcGJycVBWdmVFRDFwMTJFZE4vd0NUN0VTQm9xNGJCbVJWTTZyNHZr?=
 =?utf-8?B?ZXpocWVEOHpDSSt0ZzdmZjhiTEd1NDNyeEdtVmFBVUhEQ3grVzFpc24zcnVs?=
 =?utf-8?B?YUlNbXN2Umk0NndieDViUVd5cTFJUEZJbFNqbWg3WlkyOWN1ZnJVUEFDTFJn?=
 =?utf-8?B?VzZ2TlU3WHVVYWlwekowZHYrc1pTYjJvcWo3QTZhbmdUeVU3emNpWDE3QzYz?=
 =?utf-8?B?Y0ptR1N5c1ZJRTVjRW9Fc2FoMksvcVRMNEowVlI1VlBSR09XbHNaTzFlSzR4?=
 =?utf-8?B?WnhydWVScFZzdVh6WERxYU1BQVVRWE01NERxT2NJUEpUN2pJdE1VM0NqTXNs?=
 =?utf-8?B?SkYvczRpN1M2Z0tOSldkellsUWFvcHk2WnV4RlF1SFBCMHk1c1FPcGdFOTZk?=
 =?utf-8?B?ZHMxanhQVE1ieE4vQjh6ZXI0SDVBRWRNQWcvaHZTZ0pIeHhYS1JFU2dQNWxK?=
 =?utf-8?B?KzRqMlR0UTNoKzViemdxTjVjY1lTbVR4cTJoWGZOdUg4R3RZbFgwVkJnaU9J?=
 =?utf-8?B?REthL2JJdytQZHB1aE9ZUlFQUkM3eG5Tejd5eDM0UnVpZVE1aXNXamJwdlor?=
 =?utf-8?B?WDhLTUw5c2dwc2FqSUFna0FJMWJxVGhRMVlXSDNvcDRGeEVSMEJ1d1VZeVV5?=
 =?utf-8?B?NWxhU1hrV2s5UHdBK2VMRm1Rb1g5ZmNmYWNBTWJKUEJUUDhTaEc5YzVITHNF?=
 =?utf-8?B?M3JzQm85MjhXU21YblVjUDErZ1Flb2VXUTQvMGxtY1RRS1VSN3RxYU44WG4x?=
 =?utf-8?B?by8yY05HVmRkeElVR2ZtRUdsckdGbHJvYzg1MDh1d1ViZkFyVC9EMnh0OEVT?=
 =?utf-8?B?OTZHZm5xL0ZDaEQvblZzOEpsRmVqdk5YbE13VkRXUk1ZTzFhbnRIeGZkT3F3?=
 =?utf-8?B?dE9obU1SRG4xcWxZa1pvbkxiK2F1cTVEN2cxY2VQWlZlTkRRVVQvc1F2MkE1?=
 =?utf-8?B?RFI2S2xZdng5YjdwSURCQWdLeVdkTHZzSkhYb1JsL0JnWVU3My8xMkljcDJO?=
 =?utf-8?B?NFlZZ0tlVDZMRUxpcjBNT09HZmFwczlBa2JvNUlEL1UvQWxQOFZBNzhlUjc3?=
 =?utf-8?B?Vy9OdmhsUVlRNFpyZVBwOUpIdEp1aFFxOHJBbGh3OERoM0xQMUpueWZ2UHE2?=
 =?utf-8?B?eUNnN3dESmM0TnB1YkFITHlRbG5nMXJUbGdvRDRqdERZUURtby93QUFiei9T?=
 =?utf-8?B?SEhzMndNVVZaV3JJekxNZ2RsVVhFZ1h6YW5ET2M0RGZjakU4Ky81bkY1ejl1?=
 =?utf-8?B?czFyYnhHMEkrZnFZSEFDZitaNUlaVjhFVU9XVlJqdW1lOWdTM0doaFJVd2ND?=
 =?utf-8?Q?K2ApXcVPPWw8En3hRn1f/7WvR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6282b044-6c04-40b2-2982-08db08672325
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:25:26.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQBgnODRSt5+bRshMveVuJQsOWbrrOkXIzsP5H1RMDYh1CzJitbz1C+1DgiMQfzFB2jd4cpZfNEnFqUgMoK67w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5139
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_NONE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/23 3:09 AM, Maciej Fijalkowski wrote:
> On Fri, Feb 03, 2023 at 08:28:53PM -0800, Jakub Kicinski wrote:
>> On Fri, 3 Feb 2023 13:00:16 -0800 Shannon Nelson wrote:
>>> From: Neel Patel <neel.patel@amd.com>
>>>
>>> Use a local page cache to optimize page allocation & dma mapping.
>>
>> Please use the page_pool API rather than creating your own caches.
> 
> +1, please also add perf numbers on next revision

Thanks Jakub and Maciej for the comments.  For now I'll drop this patch 
and post a v2, and work with Neel to see what we can do with the Rx 
buffer pool patch in the longer term.

sln
