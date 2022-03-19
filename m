Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1308A4DE69F
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 08:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242325AbiCSHKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 03:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbiCSHKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 03:10:33 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2120.outbound.protection.outlook.com [40.107.215.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2AB4CD67;
        Sat, 19 Mar 2022 00:09:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaGLPfOo34DkzNziVOMeNY66hNH2Bsyx0Br39lcLnRH5gTykD3700MhULeIIeGGntdjJneLoncS7oLTL/zXCm71MYVlUpwuuMayaLeZfZeNfZTsAUBrCdLby1nRtyWmfhpQNjOQ3Pu5ISoQVy4FGLPKRMjukgrnmMeg7qnt6tE7XqrWvCYbJU3niwBaYvd+jmskzPpaeOZ7i6CjrN4vmSB4sVtmGC1PWjh/EuSn6XewaJzu65DNzXqowWmFf/3nVCzmgofdlDTU/GtusVFI1pJhQcvJxEDucaTUw3v5q/GkE37AoAC/G+xvvNgXy/+ox12JSMvLwjVg4iFf/ZFeFTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAxoQcoC5fhyXWJybJpr5KtFLmZeimj3BURd34nmioY=;
 b=WwkNW5qRRSoNiPahmsdofg82+DnxwYZAGinI3NlT91NBkBaMoP82SzVDKqDc3Cp+K1C4BdSv7jzFKnTWrXrtreZLBXvo/y8VSIpp0rVe8F5oExgKFfte62AIsecBklcCKg6dToZsb+tg35AbdfxUXJ+njYNPJn2duVY8kte2Wm7DlKQks7fkDKBMhbj6xFWUlnreaP7fedyyjIWlD2PQ0eo3JAVoZ2Ku7e2KlFdlDH+5XnGaHHP6VHxURnYtGb1xn/2bc/UfnrYMh0lnsJRNxlk2yM3Lm7UVbyvb175VZNVROXdDYS+XS238+QHapCxjgapltRCIJyelvL762Mq2rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAxoQcoC5fhyXWJybJpr5KtFLmZeimj3BURd34nmioY=;
 b=Qzmp+yuW8hl3iO2cO4gmkdFU1+ncoSQnedGsblg8T+a58Ouoi6h6V1eg2RNFaDwGaw2RWD4ujBasztl5tW05Xv8iChotGXZZA+pXtOMqhgZpb3QriEYAU5YcZcEmpPdQdv7IQpyEGDGuHQQk5F3PS72IjlPwCSsFPkaNAHV8dqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by KL1PR0601MB4082.apcprd06.prod.outlook.com (2603:1096:820:2f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Sat, 19 Mar
 2022 07:09:06 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5081.018; Sat, 19 Mar 2022
 07:09:06 +0000
Message-ID: <a183d3e8-563e-6e0c-9796-4053e2bad6b7@vivo.com>
Date:   Sat, 19 Mar 2022 15:09:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH linux-next v2] selftests: net: change fprintf format
 specifiers
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "zhengkui_guo@outlook.com" <zhengkui_guo@outlook.com>
References: <1d21ee8a-837d-807d-14a4-4ee1af640089@vivo.com>
 <20220318075013.48964-1-guozhengkui@vivo.com>
 <20220318093300.2938e068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Guo Zhengkui <guozhengkui@vivo.com>
In-Reply-To: <20220318093300.2938e068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK0PR01CA0064.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::28) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 808ed59d-b037-42eb-215e-08da09775ac3
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4082:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB408222804CB3D9E33CB3C746C7149@KL1PR0601MB4082.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8tIeuiYtGRj0GxAAcqE+3j0IRFdBCRr6GIzJnxG4NEk8qpRO/MxH7lmxPnO1kzotPjeYltmY0c8vZVeS4OGq1JbgSx5gdAeYWodXIrngD7hI4IwDSJXaJo2+6cfh4Z4m3FDjwrRX/v4mcOAppemlVwkDPDO/m8TQtAaiI8b4d2E4DNm+bg5IKHNLWQk/3pbRl9xbm/56664jkguW+yyOITTGDODCmExt3VSLtJ6yma09/JzSiDZHiIVOFBMELKci4LMJV1fs9WSwBbAJorjRy1kfeAnAO2EbDkpW9GVHLoAHPY1g4IsBiqrPx7mC/wsSfhhiFzhv7BPNz+FRxd+Za9LGCWMr0ynasAduWLO9Qc5X2wc2wM9yF6JsdQ8tf7Y552fjvk9OJkhEb8qrA6EYqnPK96IAoezF1lXrKLvDHfD6nK5s835CpQmanaMOFVseZMi6mNESyDuKGKjs8CzMdS+HeVxY15qblE1ZuT9q/qucgVvtQTjgGwmBz1zXF0ZooygmI3Mealb1Cn0R2EbGtLBlLvuGiMc8fAIsDNRGhrWDwBCn+z3iuFGBOm/NqBXFjvayDmQUv7Xp3i2ZafIX2XLFpvYLhtASOwgRXpJTcnzWCwYtqP5WX0DZCCrVtjiMpjTDwwtFM2r4RQvFpI8u6RJbILLwMbcx7WhWSUBJsDtASf2HYIr3K2EvtiBTiLPY87Qovxf9pH64Erm9AGdO6X+O5n2BUgAPuphCpHP0XhT9ojkq3yKTXpDNV61yp/9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(38350700002)(4744005)(38100700002)(31696002)(508600001)(8936002)(36756003)(6512007)(6486002)(316002)(66556008)(66946007)(6506007)(66476007)(52116002)(6916009)(186003)(54906003)(4326008)(8676002)(2616005)(2906002)(86362001)(6666004)(5660300002)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0kzTER5TDg0eEd1M1NINVdPdmo4RnpjK25QUVhJSXJGLzhlbk9IbjNOSTVl?=
 =?utf-8?B?THpGenZ2MUpRUTFWTFdEbHVCYUR1bmhPbm13QWxDbUUrcTE2eW1QMWlqVTBR?=
 =?utf-8?B?TnZHK0lLREJJZVJVeFl0WWp2bDlNYlRCR2NKUm9oZ0x3RDRRT2wwZEU2dlU2?=
 =?utf-8?B?c0ltOUQ1aEhoY1pLVEh6T1JyVEFScFhuRi9od1QrRFd1YnJnbzJQNUkyb3NH?=
 =?utf-8?B?ME1ENW43Nmdock0yNXR3SFRQL1p3RWFVQk1hb0Jwam5yWHJlZTk2RlllTGJJ?=
 =?utf-8?B?SDZHa21sbDNBayt5YldNWTE3VDlqTVVsanVOa0pmUE92Y3llOWQwMTdKREpw?=
 =?utf-8?B?YzFXTUF5UzRybkhBRUtWeXZpRStFeGV5MDQwdXR5MDl4QjBQUFhBT1ZydXJO?=
 =?utf-8?B?Y2tybExwOUg2QTRYRmhqUzFFWU9nMGR2c0FjMnRZZEVJWCttRjAyWHkvdG9R?=
 =?utf-8?B?T3F2YXcvUjFJblQwNzY0dlZURlZacXhQNm5hVThCanNsOWhNUStXcUVWRkZY?=
 =?utf-8?B?anNsRk9pWWlQZkhEYUFmMzJmdXBOOWRoMUU3NkhFcUlpQ0QvN3ljd1ZKUVpq?=
 =?utf-8?B?WHo4TGIxQXFPRUx5ckIvUXVtVEY2RWNVekVXK2NLSG5VT3huaU1peXlaM2ZZ?=
 =?utf-8?B?aUF5MmxvcWdHM0dyKzdlbG16MDIwRmJWRFNXMlVmTm5tanYwWmxaMzJ1eEhx?=
 =?utf-8?B?UHZpZ2p1bURwUFVyZlprUGc5dGxlM2FnMW5zQVZqTjBVSzYzUTMrQXh6enJz?=
 =?utf-8?B?WmNySHNISnRXWDNHNm83Sm5sU2VtdjR3VGtURXFoOFhLZ2hLRHA5YnFKK3Iz?=
 =?utf-8?B?ZG5MamtkT0xLVm9ZVGpPRkY0L2w2UHQrZEJWQUthM1RqV1JyaW1rSDFTVXA4?=
 =?utf-8?B?QXgvRWllYlVOR3l1VFFhNlhEVVJwVWN4b2o5VzRKaktYdkNpSkRsK2xvSkxj?=
 =?utf-8?B?b1NSSlo3bHZqczVmcjNtTkd0V3hybitxMjNYV3M0RU83Zk9OT0FVanFtQXdm?=
 =?utf-8?B?UDcwSHF0VitEemJ3UUZVU1NYOUg4OXgvZG1yemd3aFhHNm1CTE84b0lSVHYr?=
 =?utf-8?B?dW5ycWFuVVduWXUzb1F1TTZBdXlVL2xjSzFWRjdBVG1SVVcrd2xzRDJHaFY0?=
 =?utf-8?B?RFlEMERvbTV6N3hvcnJkdUxwYVVVU1NYWEZ5OHFyZU0zZnYyMVNlTGhTcGlJ?=
 =?utf-8?B?K3Q2b1M3VlhaaFRQOE11cVNmNjlWSDJTWTB0U2lBYWQzWXFFWTduQStxR2pV?=
 =?utf-8?B?eXFld0dkNGEzUlFBSkFxTFRUSTlSZkJWZjQrV2tGSHhLaXVPNXVqQmhGbW13?=
 =?utf-8?B?SmQ4aXZMUzN1bHpWZVkyTERjVW9UUmNLL090S0E2blVyclpTTE9ocDROb1hM?=
 =?utf-8?B?MExWTjJzUFQrc011TlFaTW01dXZYaU16YXRUbk9nZ1U1VlRtdEdRMVA4aUxz?=
 =?utf-8?B?bXZ4cGlvTkJZaldZNDRYdXQ0TjZOVk4zY2NtY0RLZUY1L3lzWkNiOExocGJF?=
 =?utf-8?B?Ni9TYlc5TTVOdTFpZnFSVHRPM083Mk9DUXQvcXB4d2FzV0x5UEFTcGZweURV?=
 =?utf-8?B?d2NEaGNsSGY1RHZWNFhWVkEwbGFHeDVMTG5pd0MxbXdndXl4Q0FuUXRnNUtZ?=
 =?utf-8?B?YzZoS2tQMnJISUJjUjJSRzIwUVhHYWU2OHdKUVFrcDg4YTlnaURTdzVNVVRW?=
 =?utf-8?B?eVZya2FjN0dhWC9GTUFPdld4Ky80Q2Z0aUhiUUhmMlB5WjBLRG9iT0NhK3Jl?=
 =?utf-8?B?SzJETXFWcDR2Q0ZYYytQZld3b2pCS0pWSzdCelh0M2o4QUw5c2UyalV0dkxq?=
 =?utf-8?B?d0tVeHNsUGRvU0ZRaTloZTNhWnlVSkNKVGRJa0R2SHBvc21ETEhDNVlnOHdx?=
 =?utf-8?B?M015NkhOVTF6ckViU3RJd3RkWTFEeVdXNGRkRnozOVVubXJRVGFTNzRVSVpq?=
 =?utf-8?Q?x8x29c9dsgITCTEnlmtX8TLyrYpFKJiI?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 808ed59d-b037-42eb-215e-08da09775ac3
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 07:09:05.6873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CIybM4H7BI/FNadKHfX9HDhwtEwfOsKy4/Qzoc3eM+U7kjfCUmIjp3EXciYE5GGKjQpe5eYlcRZ6rRD598XXgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4082
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/3/19 0:33, Jakub Kicinski wrote:
> On Fri, 18 Mar 2022 15:50:13 +0800 Guo Zhengkui wrote:
>> `cur64`, `start64` and `ts_delta` are int64_t. Change
>> format specifiers in fprintf from '%lu' to '%ld'.
>>
>> It has been tested with gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
>> on x86_64.
> 
> No, not like that. Please read up on printing int64_t.

Sorry for misunderstanding. I wrongly thought that it's just for 64-bit.

So I should use `PRId64`.

Zhengkui
