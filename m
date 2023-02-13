Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1052694DF5
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBMR14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjBMR1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:27:54 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9183A1E28A
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 09:27:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0ifxa3up5cdO0nuhyK1RNrrF4UREwyw2ueDHF2CBgfj5pdYBOKuQHrgvtkPBR0Uteuw1iWx0r9c4V4xUhMLf4n7hoHBrePZ/20494DuDVARFmqvj1qerU3xhXFxtYytwex5j3NTbFb0gXiSEs6X1PfuLG4jYogL8rgMTfDnX4phuPO1RWWVNcK4mZPr/3mM5uLV9of+t4NFE3jXKugpfXCWzv9fpkZgB6Tcp2z7Rpx+rkeZO0YUGsWVXzWbpszGJGE7TuxXDopdMQg6T0eBCKGyc89pGwTNCDV6eAG/flHCYtSpW1EzfcCSTHmSa9kaftq1F7hDGrxS0IY99vCgtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yz6D5cfwMhWLdtyyfaVcyQDFDrx8YgMWN5+zbm+ZMTw=;
 b=odK2Ss4LcxumiomriNh064/AqtEg1jQHfY+wx5oE3CiNP04fgRtsP6+P/EE1uYwGSyPOjFPu7LRddgdDMKIONzbqcyQtf4ji7zIA7oIFjjprgyZeA/z4sFv8xyrDzlKtOdIXtauA2Oi/XAK/brOS5mSj3FvXH+vbabcOe9SrPK8/QebO8SUheZj/4Fc8nPDXaj3u/Jr5jPbORYljJNVsfvlOdFUXFtaoJfIJkonMlvGPw3+LH18Q5Dr0wpSpju89cONgJgG8yxaCHOtXKH7dd26Ktz5As2O5GqLCc2bP+MaxQR6cTs04fLCvBeOa1RHUDcBc7zrizuQ4h9ayQ4VyoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yz6D5cfwMhWLdtyyfaVcyQDFDrx8YgMWN5+zbm+ZMTw=;
 b=nlt1l2eYhjUMGrrXGejvn+eRbkWy5Y5Acpt8sI3wVNGwNdoj9/cuR1is1ScOqMe9NrZqeSp5FQKP6+Nvamj1E9WuxP0W/u4jYTjHvNdEaHLXd4bWsd1xe4+/3gZy81TEAY4NH/GvUhT+Uz7CfnJXk2DSjvhdKvoEWoAfAQUuTks=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS7PR12MB6333.namprd12.prod.outlook.com (2603:10b6:8:96::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Mon, 13 Feb 2023 17:27:29 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%6]) with mapi id 15.20.6086.022; Mon, 13 Feb 2023
 17:27:29 +0000
Message-ID: <8a584208-edac-b55b-4c6e-caf3eed69e09@amd.com>
Date:   Mon, 13 Feb 2023 09:27:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v4 net-next 0/4] ionic: on-chip descriptors
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io,
        Michal Kubecek <mkubecek@suse.cz>
References: <20230211005017.48134-1-shannon.nelson@amd.com>
 <20230210174537.66eec78d@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230210174537.66eec78d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0034.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::47) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS7PR12MB6333:EE_
X-MS-Office365-Filtering-Correlation-Id: ca5eb4bf-1f47-4dd0-90e1-08db0de794e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y5ESs0f2U2qmho7nRNsLhOGweOe4CxGQIdXWzW4Nlp/NEqCr5bTbS1L9HG1Z5/eZ0qONRShXmJjto9LWp6UWc2DtHVtwMWjcdAsqOZlh/yuN/SKUZcTgbeI1AOhiperw4dHKoWWUvMu/vVkebWSaZ8Q2udKYYjsPDUKb/EOyzs4orWKj2QMLoN/8w1z/WALVGxnv97vlq5JnOz2gDJarS5404Zi+d+qRhZrsllRqvp6ysl1shOviz+LpFWfJMTsBK9dYO7VTNTPZHT8GVxWnroEIx9iHqwTYO0LsKpZWUxIFSHF4M1lSFkrFE/dQX/XXmHqT2MlaLuqQt8B9iblXSEbcWETsC7BzF5aXnN5PLZCliN3qhXvqlZNm1IEOpDiEiPBHlsxovl8TtWlngs8vYcuw5jbCZbE+GJum+O4qgRhzvqIUtYu//OaOgXSP+Xfew6HKyo8LNwxzIma8JSsVEApI1aCQYmr1a4RjP/a6HqTDsWA2q7dV6zieYyLDeZ/gmZXrE3YfNdF3RSDSgfOMwKEuOfFW4FSdaqxYiO+ZoB75/c+FGzOhnE8O2uBpqtb6LEQRdNk3r1Y+o+4NICurSD+KkqBZ7y/WGg5xI9mFR67OxiSAae/rVBiLxr74eVl0vuvAJOOHvRNjJmM2EyHYLl2qL+EFtlWSowu3m0DlLRpzq/MfaETVJqGtHAWbVTK38H926hIw3I+ZTXjgP1ZbTkUALV/Di51ZJV7BLjRvDeE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199018)(44832011)(4744005)(86362001)(2906002)(38100700002)(31686004)(2616005)(6486002)(26005)(6512007)(53546011)(186003)(6506007)(36756003)(31696002)(316002)(66946007)(83380400001)(66476007)(41300700001)(6666004)(4326008)(478600001)(8676002)(66556008)(6916009)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnIyekRjaVh1NkorTVowZWNaVUt6UGlOWjVPMFUrcW5kaUMzd1pUOGNWT1cw?=
 =?utf-8?B?cFFEUUIrZjVmeXlEUmlXYUhWVlBLY3RsUkU3dGlJOG5ISGlBMzRqOVhoUk9r?=
 =?utf-8?B?RUd0UzgyVG8zZlltK0ZIRmRlZHlsV1pPR01rb3QyeVJCU242Z0hlVzJKeTY0?=
 =?utf-8?B?a0s0ODByQ3ZWempOV3VpRlc2Y3dRdmhRZjdVUUZrdWRySkIyWkdzYkJpaHBG?=
 =?utf-8?B?cEprUjQ5ajAyWjA5YmZtQVZYSTY0RWpDSk90cGdaWGF4bXV0Uy9aVHRXNHhq?=
 =?utf-8?B?QjltYW4za29zRzB4OGsybkM1ckFyRkVnU2U3QUl4T3NhK0FVT0VQUFdYZm1E?=
 =?utf-8?B?TVBITVg3dkI2b1lFUnhCbXVob0JHbjg5RllmSEpvckRCYkZleFllSHdkZGFV?=
 =?utf-8?B?c3d5ODFiS1ZMcFpCN0VJdEp3VWFVMG1CdlZUN1pMd2RJeDN6ZTRqS1E5MUxB?=
 =?utf-8?B?SVBYTkRiZmt5aHZocWRtRk1vbmFqUTdWbjk0Tit2SHZPMk9mcXVKZ2FGd3NT?=
 =?utf-8?B?T2x5ZlhNbWx3c1JwY2R3Wm9SMzJQbVZoTGh0VlZsTDF6QTBPYlY4V1NyREl2?=
 =?utf-8?B?WmxsUnYveFBtdHE5VnBGNzNvUm9ZYVFVMWY0T0NCTmVjdFM0U0pOZmYwWjBm?=
 =?utf-8?B?RlhjN3c3aC9XU2FoYzhJQklLR1hQa3dUZ3Byek5UQmcrT1oyMmt6TTQxU0ll?=
 =?utf-8?B?TUk1TTI1ZDNVV0RuOTJaZFN2NWRFQ0FpNjZTcnFjdUI0b0RDZ2I5aTl4bUVT?=
 =?utf-8?B?UnBqZUkzWEVDRDg3cHp6ZDV1WWQwZlQzM2kvdCtVL0dtQTN6dTBkZ2RKUkk3?=
 =?utf-8?B?ZWxOdjFOSUc0N2tqbDYvUUFKbmhaWlN5cDFEN2tveVFYSmtxNzQ4a0FQRXBk?=
 =?utf-8?B?bi80Y3pDNCt0MFduSmhnSWdzK1grRXNZUHFXYzJHWmpucGhqWHovM2tYOW1H?=
 =?utf-8?B?YkQrcGQ5alNSVUlvSFJMeUVoeEFOYzlpUnk0YTQrT0hCelBLN3FTVUNyVWdY?=
 =?utf-8?B?ZzdsN3VTZUNNVHJDVDJlcy9xWWJMOGlJT2NyYlFvd2x6Z29hZ3FNQ00rRElj?=
 =?utf-8?B?bW4rRUlGT0tHR3hxbnh3SXF2SUExcVRubFY2MEM0YUd0eEJjZFJJS2d2SHVQ?=
 =?utf-8?B?YTNzc0g4UTRSbmZ6QnFlZ3BRdmdIVnBYeVRrdXFQbVpYY0ZNWUYvcVcyc3B6?=
 =?utf-8?B?dXA2VjA2aVAyenBuaFRJRm1YbU9pY0lYVGNmVTNXMGR6USsvZ2hTVVFoRWdP?=
 =?utf-8?B?YzkrRHJBR3BaQUwyejI1Rkl0QU92Sk9QRHpMZlE1VG9DL3JFWnJZOEhqOEFz?=
 =?utf-8?B?ZFcxS1JKTmpkcW5odmRZMXdhRW5uTFJPRFY4YTRIc0E3cmJpcmNaVW9qa2Zj?=
 =?utf-8?B?VDRXdjlTYVJMaHU0Wmk2ZHBseTkvb3FLTEh3NWp0UUlOdkw5VDlQdjJDT09y?=
 =?utf-8?B?aWlFNFdMbUYwM05ZRG40TDlyL09mSDJWWlo5K1NNQUFNV0NvaVlibHF5Z1Bn?=
 =?utf-8?B?ck5xK2wwWmRkKzJSenNGYTY2c0d1RVJZNWV2OFZwelEyeEt5VzJ0Zkw2UitY?=
 =?utf-8?B?NkRia29uaUZ0UUlhTlVMaHRhb3A2NVRkak90SVZ1c0c5RlkxbmdWUFM0cGNS?=
 =?utf-8?B?MFRkTjhKSUlBSFFtQWhkckIwTFBqTENXR1J1U0VBTk9vMTgxY2VsMFJwbTRD?=
 =?utf-8?B?bmJQRjg5WVhwcnA3b0picFAxTi9aZzdJUnBRUXhDZ3JwN2lYUVNZeC82SlJP?=
 =?utf-8?B?RVF6M24rYjZkYlNvR3dvWkhVeFpXQWxRc00xU05WMkNOZWxoeE9RbWRCaEhs?=
 =?utf-8?B?YjBqU2h2aU15eFB1WGhTcGFtUkY1bHhYSjIrbmVpRy9ZenBSVXZIRWtxR29E?=
 =?utf-8?B?NHBEZklJSlRyeFBxNGlrdTg1Wm9XZldnRHBZT2FsQStXcU8wWVFPbmZROTNV?=
 =?utf-8?B?dVhHU2RYa1ZwQ3RUdmRTQmlDOTFiUWZBMksyMk1jUk15UTZWYVJxWGo3ZXh6?=
 =?utf-8?B?M2MyRDJCTG5KN2lGaTA0QUd0UjlPSU9obnZ5cklHdVFVUWh1Tit0STRPaFp0?=
 =?utf-8?B?THVoaUI1ZDBzTUwxcUQ2SGV3NlJlQ1RwekFUWEZWbWNVUENSMm5iK2ozSUp2?=
 =?utf-8?Q?ne0COU/h8Ne7MMgQNYjKgpYoc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5eb4bf-1f47-4dd0-90e1-08db0de794e5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 17:27:29.1936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1bxX7KxovbSp47xeg9uVZRKyQ/DMToTKA1zcVDAT3u821kSjRehYp0QFQTed8EhLbyoUpbUbLT8TlZY4PQ9GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6333
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 5:45 PM, Jakub Kicinski wrote:
> On Fri, 10 Feb 2023 16:50:13 -0800 Shannon Nelson wrote:
>> v4: added rx-push attributes to ethtool netlink
>>      converted CMB feature from using a priv-flag to using ethtool tx/rx-push
> 
> Neat, so it is close enough to how hns3 uses it?
> Or at least the behavior of the knob as documented?

Yes, I think so.

I'll send out an update for the ethtool utility in the next day or so.

sln
