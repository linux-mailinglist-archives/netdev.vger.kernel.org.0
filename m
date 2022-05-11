Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66423522A65
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbiEKDX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241776AbiEKDXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:23:15 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2093.outbound.protection.outlook.com [40.107.215.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DCB62134;
        Tue, 10 May 2022 20:23:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPHuwfZM4qFExbI5g/rvknttIn7K8QE3PeGrGQV77KuwJm2mum+xsX2kBaw2BnjBiVCkq1q27zoQ90STLOZxPZWJyr0YIx0xN5tQi+3uHCMQJjq9GmcYUkLXhcA5xCnaG1Ley5zYKZtbfrD9y6fcpGn6NCmgpYD2Hb+oE9xpNCYJMTQBN3/mJ6QupHSF2XIy1KOEUC3dw6AjsroE1tK589Zy6/SIOj6iC7lPD1LUsg7/Tyy46x9z8zerNHPIXbJLmR/sA5ynyWHF119+FLbh9et4moFzcTd9DBNf06PKbQSYLzzncr11Mus4o9SQ2bpEhnaamt/qowWo+xVBFyOuYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqBF3K4Kb6leG4SsJnlR8AX7cnYhqCeXGOH69VrwiHw=;
 b=oKBkUufi7KjRENrj45JVSbCtL17hbEH1EJSf72Mh+WmBPr3h1SOyThOEuWOp/faUTJeUtVhDmlH39R3L4zZ+e7P17g9XxMpnlgaqfO+FUXHZpgqaODxuuHkkvX9sqXAvNN/FRJJjlEepv/Qx7KS9hBCaJBb3xDNjy+JphkX2TQ6ow+NXCOxi/G167i2tw13qt0aL3nq940uN/IVFERFpyncQGo66SQYRI4HlAba3CKuuAq1d66SXIADklxaMVN3MW6JkfN4VUSRR8sf4LBF63CwuSzp84G5t8B+kGoobTPdnGJ9wD5gD8ItsblVQzvvLInokVa5lykgP2oAxYuIlng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqBF3K4Kb6leG4SsJnlR8AX7cnYhqCeXGOH69VrwiHw=;
 b=TEix0JRAweuSlXdd9kgZo0k1WVCUSkt1weXtf3zPUEy7yXYNFZH8er55Z8hZp7fE+WOuc0Giyfug/aSLsrVhzlsAfFkp7Dx9Y3PJEIULPC6QAmzgdVHN9QFsYW/4/WsxtJ7qwDbO84Sfv8RSj9UsOMdULWgJ7Sj369ArZSKpzGw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TYAPR06MB2238.apcprd06.prod.outlook.com (2603:1096:404:17::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.13; Wed, 11 May 2022 03:23:09 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Wed, 11 May 2022
 03:23:09 +0000
Message-ID: <18a40fc4-75a7-2619-71e4-80b50b133abb@vivo.com>
Date:   Wed, 11 May 2022 11:23:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 net] net: phy: mscc: Add error check when __phy_read()
 failed
Content-Language: en-US
To:     Antoine Tenart <atenart@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220510142247.16071-1-wanjiabing@vivo.com>
 <165219411356.3924.11722336879963021691@kwain> <Ynp/124xVt+lUa6f@lunn.ch>
 <165219683693.3924.12337336334738761045@kwain>
From:   Jiabing Wan <wanjiabing@vivo.com>
Organization: vivo
In-Reply-To: <165219683693.3924.12337336334738761045@kwain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0015.jpnprd01.prod.outlook.com (2603:1096:405::27)
 To SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a509c7b0-9218-439f-7670-08da32fd926c
X-MS-TrafficTypeDiagnostic: TYAPR06MB2238:EE_
X-Microsoft-Antispam-PRVS: <TYAPR06MB2238669B528DD045AD50DF34ABC89@TYAPR06MB2238.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JzAvcstJjjV0baP25f+LzOY/szvcc2w+lWLwLHgJuupdqIxa51ba5yCrMdPowKEdhcUhqU1LsPYTbiV6i8XPBtMnOq2jKIMuXzyyUIU9stGsWvYvc4TC7yUIWmAQ+vkGwZcxTgAHOOBDHIvUGxGPhcP1tHfvHS14aBW3gHDteBExtAFqohFsdX1ba1ZoZZmPmc6HXXYTrWaGtz8N2S5qxOZ7/Cp1lCH8Ktv8ZTgFdbLRokQekl3aQeEhLQ5zSvA2tYgs8mjWkvFWPfLQQfRe7AaPfMxYbDpVfh9M5/1vQ7CPTq+Y/cO+i+aKH+ux6upsT2my+6gqt7PLDYws7ifaZB3ijNAnni6kdVWk+T7dPwHzmGx/9g1KDct3RPpkUqxmY89bzJL33g9pvL46DDQFJ4/etSHjpfpQK7Q3LoQMrG6ttkdWFboqcqF9/zaXPUjwrSOFIyfg8jjRpJmvV2/ZfmB0NeFbTZ0bSATGtqg7pw7BsyDZ8lp+kQjeztLKUOnAndp4wKFS+x2NNGt/vVMCn7JCAzInRQPnbB9MdBV/MUvGf//jNgLy+6G2UZDGYQacbWLyB7PeT6BFp6/FSuzy9Ymo1cDD0OHAeeaC1tmsmQETYiFt61AyBaVHJ85FpyQq5eDab3zMWy4BCeEVh40gIfLvH1pNIdonoV9635WOpD0MJAw9RBv4Yy3WgNrtoG+3mzu/yS0eppuoPAAXlNRcH7qmSmahU+V5o2hIJp0KKg7+9S+IrVxVxGtQUMnBgt922aaWWEaooQAdwzsP5ys2pX5smcL00KE9YTXFHb8mDRo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(86362001)(6512007)(26005)(2906002)(49246003)(4744005)(5660300002)(316002)(7416002)(8936002)(38350700002)(38100700002)(66946007)(6666004)(54906003)(52116002)(36916002)(110136005)(6506007)(53546011)(6486002)(36756003)(186003)(2616005)(83380400001)(31686004)(4326008)(8676002)(66556008)(508600001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTlYZXBmSnZ4ZkNza2NsZ3dTSDhrc3hzUzdWWjZwNXB2Zmd2ajlUeWRhUDFn?=
 =?utf-8?B?TVpoUEZCWjJZN0s3Qy9zSG8yTXNlWTIrU2k3WTZVMHRvTkxkZklzK09lTkVy?=
 =?utf-8?B?akZPUzU1K1pZQy94UTI3V3FZV09XcVRIS0g0SlM4MnhaNGhtSUNYbUFydHBS?=
 =?utf-8?B?V3VNTXY3SGdwZHAzclBsWHRHTldZREovVi8vOWUwaVFEUVpGQXV1c2dqcFND?=
 =?utf-8?B?dUtEb1FQaWtYTmY1S1VreGhJVktnMk95SVdzaXdoWk95SzFjUEg0bUJkN0R2?=
 =?utf-8?B?TGFHdXNTYkxyYURhY3FiYTBnOWNUcjdsQlc2UWpZdGxxaFVRdGlNRy93VzQz?=
 =?utf-8?B?dFQ4WUE0NDlWUUVKeVFmbFZKMjNNRVYwRHJKV01NNG5mSUtvTm9QVXZSemEw?=
 =?utf-8?B?R0QrUzdhQ2JqcXEveHB2VVJoOFRiMzM1MnRla2lOOTNnUnIrNkdnaDhBeTl3?=
 =?utf-8?B?NDQzRVREdWlqdGc5aHJTLzQ1T1VkVUxqTXJMbXdMT1BUbnpsZS90OGZTQTVE?=
 =?utf-8?B?blkySUMweFVMbkVSM00vWU1tdTR5OThkOG9xOEZRbkphYVRkVFl1MERWY3hR?=
 =?utf-8?B?TG5vZmpEdFRUZkVJMndBYW15bW1jaHRZZUNYSFFKV2VQMEFHcytNZHNlcUJX?=
 =?utf-8?B?dWwrTTdtQ2pWVjl2anlkRjFyb1Z2SHhHajFxUXlkZFdTQStCY2NDdG1scVNT?=
 =?utf-8?B?OUFKbGpMVGtOLzFMZ2V0NHlDRzF3bTRKZGJMNGxjL2tLVFdTd1ZCNDhVbGxq?=
 =?utf-8?B?V0I1RWptT2tLRXBOUU8remJkTkRHeUpKdXFzTTNWNE8yU1ErczRCOWRGM0s0?=
 =?utf-8?B?SUVkWmc5ZkxnbWhjU2dTN2QycE5DU3Jwa2IxSllGQlJFL0NyZUVRK1ZwRkZW?=
 =?utf-8?B?RG9pU3BJYkVpMWp6WnQ5aWlpNGJmY0dVQTFvRmZVVG1HbDd1TEdnSmw1N3pE?=
 =?utf-8?B?WUxpSThvaWc0NHhaTU9DYUdNSzZ4emtJamZsVFBuUmJFSldLRmtaQWo3b1Bl?=
 =?utf-8?B?V2VqS3Q1REdwQmhOeDBFcFFQQ0dtdXUxWHRBYng2dFpXVUJGalgydGhhQm5J?=
 =?utf-8?B?WmVBdTlZSTluNGZSbmlyZVJWNFBZdlBOZml5UlJFM3dVd0g3TmJqZlNxRHZW?=
 =?utf-8?B?Ui9RazhodU4wNFFxSEZsd2JrZnRJNTZZTzRZRUg3amozem4ya2JGWkJlSFk4?=
 =?utf-8?B?RjRZalQ5SThmWW9wZ2IyakpnaDVMMEFYdE1LZDgyT0p1blJGZUFQeDJjZGlY?=
 =?utf-8?B?bkxiS2NtblNTMHJJZ1p6Z05Zb0FMcS9HWXhUUUVwZ3I4bnhJcDcxcDR4LzFo?=
 =?utf-8?B?dGpYY3kveGZ3WjdJc1lkOWUwOVFsdmttbnJ2WCszVjNJS3FlbGtOQUh5NmJE?=
 =?utf-8?B?emdkelBCMWxSd29oVUZLQ1R3N1RFVzBOWTZ0T3hjTFlWQTl5Q09KSEN3MktQ?=
 =?utf-8?B?SzJXSEh2VlRZMjgrdHdrWVZ5c1JKY2EvcEtzNTI0ZnBXR0JVc0RGeWMwS0pW?=
 =?utf-8?B?WkJ0a1l0UjJnaEttOVBMbzAzeDJvOEVYYjlWRHdmOEs3a1I5ZGFDSC9pUTVQ?=
 =?utf-8?B?bm81cUJ6TzJrcUFPKzVrV0M2aXRSa2oxWlk5MEM0M0VqSjhlV2NkLzQ3RElT?=
 =?utf-8?B?L1BFNDVqdUpKWjFyQ1FQaXVtZ2hNVk5rVkRUd3RFVEZqNHF1RnBLOGxweG1j?=
 =?utf-8?B?YktXOUQzOXB2ZldDQnFVd3h5UnI4dnk3VkRUN0tZYXh4ZXNlMlNIbW1NWkN6?=
 =?utf-8?B?K2k3R1VhcFozU3BhRFd5dlNrWlZOT2RaeWFySGNZVG13OFVTWVZPckRuYUpB?=
 =?utf-8?B?aDZFdS9Hc21xM0daU3F0NjFLUmRHUW56dUF2YnpNNHF3NmlxVTdMZkgyczlC?=
 =?utf-8?B?ZFdqcmpIZkNaTXphaldCR1FjSjV2VERHdFI1ZWFvOEl6b2I5VS85SEVBZS9H?=
 =?utf-8?B?ZXhKSzN0WU9lSXVpZWxUR3B6eHRtaVI0bG91MnBnVmZSaVNTK3B4cEd5M2Nl?=
 =?utf-8?B?amU0QWd0b1VBQlJVWDEyUmNlRHRVeGhiWm9oVWdUUXlONm1SaXdPaTV4ZTUx?=
 =?utf-8?B?SXRxN2pWVEVNSWhYaHJhS1BoYTQ2S2xlZ05lcENCbU1hMmJ2NndmaFhhSVU4?=
 =?utf-8?B?a1F1dU0xM1dtRCtEcngzOFk0VUM0ZG9ZYXlqTkxZV2NVNDZmU2RNYmhXdHgy?=
 =?utf-8?B?T3hGME5zc2w3ZFFoaVNtMXJlMmFRSjVWWE4vbGl1THpyc3ZhaXJ4WVUza2pa?=
 =?utf-8?B?NHFXbmdVZnFCWC9RUkk4OC9yYU5ReGEvZ0Vmdlh4Mk55UzlrNXc1a3ZQaGNj?=
 =?utf-8?B?RGdKM2NnREY1MGIwOTBKdyswRzB5U2M5ZHlzOTFRNHhocldZS0l2UT09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a509c7b0-9218-439f-7670-08da32fd926c
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 03:23:09.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nod2hZGv/Ay/D1icf3o7gyuo7tAOExCppnc/RBAwKriZx2rZsOcziR5sQw+vrsrhWDKCkW1hK/NeF7864fgZjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2238
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/5/10 23:33, Antoine Tenart wrote:
> Quoting Andrew Lunn (2022-05-10 17:08:07)
>> But i doubt this impacts real users. MDIO tends to either work or not
>> work at all. And not working is pretty noticeable, and nobody has
>> reported issues.
> Right. On top of that there are other calls to __phy_read in this driver
> not checking the returned value. Plus all __phy_write calls. If that was
> found by code inspection I would suggest to improve the whole driver and
> not this function alone.
OK, I'll try to improve the whole driver and send a patch set for this.

Thanks,
Wan Jiabing

