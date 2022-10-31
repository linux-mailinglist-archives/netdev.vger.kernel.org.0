Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18E6614090
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 23:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiJaWUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 18:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiJaWUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 18:20:08 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC7813E1E;
        Mon, 31 Oct 2022 15:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N80kpR++TYJC8kbGPZtfentlKFhyaNNPikZArmnIBw5Y3IYjGT/FsiUtGBuztdgr0U+asEfsDcfd00EJtexndD0BOHBAZk3Qlp4D99p271RXlbQX2DKNAiSpxWEvawO3Y7F2LAx2tved7KdcoztyDuKKrn8kj3vOaU8r5R0LKqc7RJbOz3Kzy6P/WtiZNmtn76CSjDk8UPZmCxUC9E8YBR7S+cqVOhVY6syX0Sh1cIk+pEPATwHqBLrMnzUMp+Hd38HfZN7LwA0ncctB4v97a/DE4+1OyIDxc7xY1xkpRQmdcvReRFmjdH3Aa/Efni/cLyzr7uBfeoJ7dOSyFbd8vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GL+u7I6vshLxc+lc7f2ceFRJzvgHSy476u86eYMqRNQ=;
 b=LGoeb6sHm+Rt1LljvLMFgyZX2kHmcPzzcUxv29YXFYlv2CsesWAigzCeYEsmqrFotGetmmYaOpYH80/ePAXrtwgW0hYLVFkVpSkfLPLg2mSoSbOBLTDc/p6lAjTmOTnS4wcXQx5d+X3WtSbL507JLsuUcOn1EFunRjqw+f3jdw8B4pH7xOnfjlkuhgY3JurU+mfalNLf4f+h4y/XHUuKyjPfhbQaYeGG1qTQWdakp72QkAgak+V4/WAEEXAlMw7uoFYfj7eMdu00AePEKAZcpTCjo2jsOjDpu3/mmv08vsuZnydDKijZsaxwGaUFv/Gj0AVghHRQlRCeS8oxDQRX8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GL+u7I6vshLxc+lc7f2ceFRJzvgHSy476u86eYMqRNQ=;
 b=jJLNUfWddmcW32lnVn5VVJf3MGPtghLkvq7d6NwFCxTNP+Fed1myItpeVN905Xr2PgVKtSfNNeOWTgcDWOqM6V7/zTfpN0JzM+7BCeIgpa+Gl9+hqYriFiWbyjokjbEtWsa5wcP0Gwpu4h9nbWaCVCgSitKIqHnKGUveFC1WQur/PyF7VfLRJyfK3vzbmZs2I7v6+yKjeIgkuNuUu4aE5CgqTM+Fj4n0WvTL3+ay4zTUjmEJd6KkqFUHQX9kQcBjD3pR4sIJ81DkBIW9vF2TCqUa6HJaJK3Ija6GgMTnmdgF03TF0tS/Ha1BhptVRVDWWVlg1b+hLU7HWbilyshB5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by GV1PR03MB8454.eurprd03.prod.outlook.com (2603:10a6:150:59::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 22:20:03 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::9489:5192:ea65:b786]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::9489:5192:ea65:b786%7]) with mapi id 15.20.5769.015; Mon, 31 Oct 2022
 22:20:03 +0000
Message-ID: <7aa0afe7-5bbf-b213-c83a-72ffdc19a8f1@seco.com>
Date:   Mon, 31 Oct 2022 18:19:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and MAC2
 as 10G
Content-Language: en-US
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
 <20221017202241.1741671-9-sean.anderson@seco.com>
 <VI1PR04MB580721D3F8DFC5C1BCAC6FC7F2329@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <348c4b17-1e2a-cd30-b0e0-3a88c24aafec@seco.com>
 <VI1PR04MB58073F629833CBBD777BFFC0F2379@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <VI1PR04MB58073F629833CBBD777BFFC0F2379@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:208:256::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|GV1PR03MB8454:EE_
X-MS-Office365-Filtering-Correlation-Id: 31cf6e5e-411f-4550-e1ed-08dabb8e0e3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uB7PzMQwnew+pYEMGtywFhNPSX0IGP/nrGEq/uGpIJAeDWvgS30ci0Q9c5FluJIt1SVuL9eww00TmBPVHEjZa4kf9JIb75bs9BEr5UN9/kQ3ipGNsXR2dKuIK+pMETHLhfV6T4fRaP7p+QRGS93BkobbnJcXGAsMec6eHw5ift4rvTHm7gGbIAX8y3+/fQjNo9C4YpxDLLpVfpMiF1PPxywdykshRLA1pJyoWVD/07IQyAY6kNyat4pm4cZd64RCT9RM/TGYu4HyS5ynxgpZyKPXgCPArgca53kDfXTFWv6Kq/P4Cw3rCFxcK7B4yUEYPvpxowDXmSG8ndcgwo94ecB8CnY6ap2CwkTrJSM0CPn7BtlLI/i1J/bGbnLqZaBIvq+KB3MDt6cyu6ua6teDNTz9LmG5Lg7d4+c78dnRIZOcNwFdAUfate1a3pyOSpQjVUrGHPwgaUIDR+ahp6AUV1rboD7xGwED8g8+42mBh4GZ5QnHuQgJEOJexTPf4tkAq1908u0vWy1gKekfntMyT77MzUhtK0GU5nQ9aoLuOOW+iYEMQen0ObtvwafnM0DVYI9gK0oLfd3+5XlIxOru3CvLMqhOItIrjSbqNR7GZFJDZb2JktwGGlE3QU9MXTHF4uL6p/ER+O9LCb0rfGbQtr5yF5MW8WZfQq6sfDXDlDn7YPi1ZTqCNkKb1ghwctj8UW1BAv75B+cJS3ltNj1Gk4H0NGVLBBM19v7sgI3jLyWzOU26wAeHQOHGXvSvw/l3BMZ9lOdvT7GqcO4mLSWUNY7LUt1kSC9CmWJv3iYX/9eRC0Z5PK+AVl5Uw3b2VhL/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(366004)(136003)(376002)(396003)(346002)(451199015)(86362001)(83380400001)(478600001)(6486002)(186003)(110136005)(2616005)(8936002)(38100700002)(38350700002)(316002)(7416002)(8676002)(4326008)(41300700001)(66946007)(66476007)(2906002)(66556008)(44832011)(54906003)(31696002)(5660300002)(31686004)(6666004)(52116002)(6506007)(53546011)(26005)(36756003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0NoV0tQSWNYWEd0SHRBOE5BVVFNUm5ZVlcxSnZJK3FXSHoyVEFUaS9HUVh1?=
 =?utf-8?B?cDNlSHVvS2RiQk5FR0FZTEVwRmtGZ3Z2eVYvb29NSGRRQ2wzQVRod3FvMmd4?=
 =?utf-8?B?UGlTOG8wMmhjUzdFUkc0K0ZoeElOMHdRNjNVNGIyR2ZUaitwTnB5ajBxb09k?=
 =?utf-8?B?RHYrdjFhUUpZM0NCVXA0OVRrMnVaZXNyMk95TmdKVGFmMk52Uks3OUdINXVV?=
 =?utf-8?B?dWlBZ29jWmpqQ2dnbTFUdStINGhqelo2akRVb2VHNGNYY0pBYml3SXluTjNm?=
 =?utf-8?B?bkRnbWsvYThYQzdONGhBWmpCRjlDb25OWWxjT1VhaVhuc2x3UXhFNHZqWnZi?=
 =?utf-8?B?VDk1UEJ4cDdwS3hKWkpCMFB4dThSWFhWQnVzQ2lWaFdsL0xNSTJsRnE4SU8r?=
 =?utf-8?B?bU1nKzdWYnErekR1WndVQzdsRjRDSTlNTnRzdjM2T3N6dmFDMnRXZ1E0ejky?=
 =?utf-8?B?VzJCd1JwclBXdlRaU2hXZ0tqTExqRmNTaHdvSzhJQnNSY1hJa0hIZm1mL251?=
 =?utf-8?B?QW5aNUNyTlZEb2NkSVQ1QXVXQmpta1ptbkx5MzJFbEhPVWhWN3VoVjg3ckV4?=
 =?utf-8?B?L3ZNaE1ndnBtQmxmY0N4djRZdlhsUHdWMnFqNHJxb2czbnJOVFJ2ckVkcXdu?=
 =?utf-8?B?ZzlvVktqd3dkU3RzL1VpbDg1RW16VGc4THgwSjJZcWNvQlNFT0lyQ1FkTXNi?=
 =?utf-8?B?WWdoMDBOL1YyVGZWaE1nOVVORmNLVElRSU9DL1VZK0Q2V0VkbHZ4L3RydFA0?=
 =?utf-8?B?SVJiMWhLT2N6WkkvcW1RTG56R3kxdEVtelk5N3BkV2xqUVlWVlFYU1RpemND?=
 =?utf-8?B?UEtYeW4vcmJ1Vks3NUh3Tmh2TTg3Y3dYNTFjancwdEdsMmtNcnFLclZRSjdm?=
 =?utf-8?B?STlTbUxMdXZVc0tPR3kxc2I5V29KV2NtZ09QbHN1VkFPUjhVVGRsTkVDWFpR?=
 =?utf-8?B?R2x0SytUcTh2QXU4K0tJak1JNllndVE5ajQ2VUxXRkw4YnZGMENQbGtRa3NB?=
 =?utf-8?B?eWYvSHFXYnBkejdUNFBoYUE0RUtLVjhFbDZRRTN3N1kzNlFxRmE5bGRLbnhs?=
 =?utf-8?B?NVNTZm9rMUt3NTZzQjAzRW9tRGxmcit3LzZTYUlaKzNva0duSkVYT0VLK2pI?=
 =?utf-8?B?V0dWRXFHajJQRHZFZC85ajVtZERUMG4zdytDVHZvR3hnNktGRmVlV2FGZXVY?=
 =?utf-8?B?S0J2aytBNHdHRndiSmxDY2NIRWNjMXJSdDM4RUErN0VobDJsS2FvTzBtaVIv?=
 =?utf-8?B?ZEU5NjRYTjdMSXFTMnpQSEZldWg4NE5nOGlqRFR4N0dvalBzTFloY2tEc2Q3?=
 =?utf-8?B?ZGtCT1NCMnhnWTQxN1Y3cHJsaFp5eW5BaGI1Z1ZZYUora0tmblhsN040RWc4?=
 =?utf-8?B?TzQ4UWY0K2tkTUFFTC9SUXRpMGZLVlpuR0ZsVXgzTWpHZlBrbys3UVlKL2ds?=
 =?utf-8?B?emNST0s5MURveHhkZVZnK1dOUW9QUjhhTC9yTVJzdVpxY2FNK2lMbW1aZE1K?=
 =?utf-8?B?ZmcxeDB0TnpoNnhtTnFqZjJobTFEMkszQzZMTXY0UmV1NGV1ekRXczBsdC9x?=
 =?utf-8?B?ZU9iWnozN1ZHOU9aem9DNlJsb1JPZUkzQitnZTZkeE5Dcm1la3JJd1o1L2tk?=
 =?utf-8?B?OEpQaHNPbUk0aWdlMVcvcTBERWNwZ1p3MndlSjVFeE4zemd2ZE1Nc0V1SGJt?=
 =?utf-8?B?QXJkMmYxb2YrNldkL1luM3VNYUhhYUxqWGNtelhJOEFPSTdVc0VHSHpxMWhP?=
 =?utf-8?B?c3dOd2pDcHRxVTRrWnlSdnpjVE1xbDZBbThPSFNOVHFSM3pKSk9WWWxnQ2Fl?=
 =?utf-8?B?TW5ueVBUNGxKWU1CMmxxbEw2VURkUUliMFdQNi9Mb0gyeFl5NVBKTnQ4bVdo?=
 =?utf-8?B?cFdKZUtoSEpvbXNYbE1yUytLelRTS3psVE1ON3FteEdIYWNiaTBMWDdHa2dl?=
 =?utf-8?B?UGZmZ2ppYXBRK1hlaFRSRXFRVEltcUp2cnovZmNCclpaOTNlK3M4Zi9iYUVH?=
 =?utf-8?B?bHFCbHRhNGJacFJKazNYLzhYMFBiNVMvd2wwaVo5Q0M4eFdtelh4eTJoSXBE?=
 =?utf-8?B?NThIRUM0aTAzV3pDa1NTNVppT2V4bkErd2ZnR3EveEk4bUVYQllrUHpnZ2lP?=
 =?utf-8?B?TVlPU24wbHRkaWhXYWJDQkxSRmpxYW9DVlA1QXh0dDUvdm1HTU5WRDJJWllB?=
 =?utf-8?B?VFE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31cf6e5e-411f-4550-e1ed-08dabb8e0e3b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 22:20:02.9745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86kbBs6aicCahHsJCGtU56V5sKPRyqpLRhzJrmmM7UP3kA++80haj66PlvsHoIMytNlOiQK3ELK2fLDzRLLEiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8454
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/22 10:12, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Friday, October 28, 2022 19:55
>> To: Camelia Alexandra Groza <camelia.groza@nxp.com>; Sean Anderson
>> <sean.anderson@seco.com>; David S . Miller <davem@davemloft.net>;
>> Jakub Kicinski <kuba@kernel.org>; Madalin Bucur
>> <madalin.bucur@nxp.com>; netdev@vger.kernel.org
>> Cc: Eric Dumazet <edumazet@google.com>; linuxppc-dev @ lists . ozlabs .
>> org <linuxppc-dev@lists.ozlabs.org>; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; Russell King <linux@armlinux.org.uk>; Paolo
>> Abeni <pabeni@redhat.com>; Benjamin Herrenschmidt
>> <benh@kernel.crashing.org>; Krzysztof Kozlowski
>> <krzysztof.kozlowski+dt@linaro.org>; Leo Li <leoyang.li@nxp.com>; Michael
>> Ellerman <mpe@ellerman.id.au>; Paul Mackerras <paulus@samba.org>; Rob
>> Herring <robh+dt@kernel.org>; devicetree@vger.kernel.org
>> Subject: Re: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and
>> MAC2 as 10G
>> 
>> On 10/28/22 12:30, Camelia Alexandra Groza wrote:
>> >> -----Original Message-----
>> >> From: Sean Anderson <sean.anderson@seco.com>
>> >> Sent: Monday, October 17, 2022 23:23
>> >> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> >> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>; Camelia
>> >> Alexandra Groza <camelia.groza@nxp.com>; netdev@vger.kernel.org
>> >> Cc: Eric Dumazet <edumazet@google.com>; linuxppc-dev @ lists . ozlabs .
>> >> org <linuxppc-dev@lists.ozlabs.org>; linux-arm-
>> kernel@lists.infradead.org;
>> >> linux-kernel@vger.kernel.org; Russell King <linux@armlinux.org.uk>;
>> Paolo
>> >> Abeni <pabeni@redhat.com>; Sean Anderson
>> <sean.anderson@seco.com>;
>> >> Benjamin Herrenschmidt <benh@kernel.crashing.org>; Krzysztof
>> Kozlowski
>> >> <krzysztof.kozlowski+dt@linaro.org>; Leo Li <leoyang.li@nxp.com>;
>> Michael
>> >> Ellerman <mpe@ellerman.id.au>; Paul Mackerras <paulus@samba.org>;
>> Rob
>> >> Herring <robh+dt@kernel.org>; devicetree@vger.kernel.org
>> >> Subject: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and
>> >> MAC2 as 10G
>> >>
>> >> On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC
>> >> dtsi
>> >> fragments, and mark the QMAN ports as 10G.
>> >>
>> >> Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan
>> >> support to the SoC device tree(s)")
>> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> >> ---
>> >>
>> >> (no changes since v4)
>> >>
>> >> Changes in v4:
>> >> - New
>> >
>> > Hi Sean,
>> >
>> > These changes prevent MAC2 from probing on T2080RDB due to
>> insufficient FMan hardware resources.
>> >
>> > fsl-fman ffe400000.fman: set_num_of_tasks: Requested num_of_tasks
>> and extra tasks pool for fm0 exceed total num_of_tasks.
>> > fsl_dpa: dpaa_eth_init_tx_port: fm_port_init failed
>> > fsl_dpa: probe of dpaa-ethernet.5 failed with error -11
>> >
>> > The distribution of resources depends on the port type, and different
>> FMan hardware revisions have different amounts of resources.
>> >
>> > The current distribution of resources can be reconsidered, but this change
>> should be reverted for now.
>> 
>> OK, so this patch does two things:
>> 
>> @@ -37,12 +11,14 @@
>>   		cell-index = <0x8>;
>>   		compatible = "fsl,fman-v3-port-rx";
>>   		reg = <0x88000 0x1000>;
>> +		fsl,fman-10g-port;
>>   	};
>> 
>>   	fman0_tx_0x28: port@a8000 {
>>   		cell-index = <0x28>;
>>   		compatible = "fsl,fman-v3-port-tx";
>>   		reg = <0xa8000 0x1000>;
>> +		fsl,fman-10g-port;
>>   	};
>> 
>>   	ethernet@e0000 {
>> @@ -52,7 +28,7 @@
>>   		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
>>   		ptp-timer = <&ptp_timer0>;
>>   		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
>> -		pcs-handle-names = "sgmii", "qsgmii";
>> +		pcs-handle-names = "sgmii", "xfi";
>>   	};
>> 
>>   	mdio@e1000 {
>> 
>> First, it marks the ports as 10g. I believe this is what's causing the
>> resource problems above.
> 
> That's right.
> 
>> Second, it removes support for QSGMII and adds
>> support for XFI. This is a matter of correctness; these MACs really
>> don't support QSGMII, and do support XFI.
> 
> Correct, these MACs don't support QSGMII on this SoC.
> 
>> As I understand it, you can
>> run a 10g port at 1g speeds, it just won't perform as well. So I think a
>> more minimal revert would be to delete the fsl,fman-10g-port properties
>> in t2081si-post.dtsi.
> 
> Since these two new dtsi files are included by only one SoC, I don't see an
> advantage in adding these properties and then deleting them. No other
> users benefit from adding them in the first place. 

OK, so would you prefer just overriding pcs-handle-names in the SoC dtsi?

--Sean

>> That said, is 10g even being used on these ports? I included this patch
>> in order to avoid breaking any existing users.
> 
> It is used, though less efficiently, with fewer FMan hardware resources.
> 
> Camelia
> 
>> --Sean
>> 
>> > Regards,
>> > Camelia
>> >
>> >
>> >>   .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 44 +++++++++++++++++++
>> >>   .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 44 +++++++++++++++++++
>> >>   arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  4 +-
>> >>   3 files changed, 90 insertions(+), 2 deletions(-)
>> >>   create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-
>> 2.dtsi
>> >>   create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-
>> 3.dtsi
>> >>
>> >> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> >> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> >> new file mode 100644
>> >> index 000000000000..437dab3fc017
>> >> --- /dev/null
>> >> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> >> @@ -0,0 +1,44 @@
>> >> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
>> >> +/*
>> >> + * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset
>> >> 0x400000 ]
>> >> + *
>> >> + * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
>> >> + * Copyright 2012 - 2015 Freescale Semiconductor Inc.
>> >> + */
>> >> +
>> >> +fman@400000 {
>> >> +	fman0_rx_0x08: port@88000 {
>> >> +		cell-index = <0x8>;
>> >> +		compatible = "fsl,fman-v3-port-rx";
>> >> +		reg = <0x88000 0x1000>;
>> >> +		fsl,fman-10g-port;
>> >> +	};
>> >> +
>> >> +	fman0_tx_0x28: port@a8000 {
>> >> +		cell-index = <0x28>;
>> >> +		compatible = "fsl,fman-v3-port-tx";
>> >> +		reg = <0xa8000 0x1000>;
>> >> +		fsl,fman-10g-port;
>> >> +	};
>> >> +
>> >> +	ethernet@e0000 {
>> >> +		cell-index = <0>;
>> >> +		compatible = "fsl,fman-memac";
>> >> +		reg = <0xe0000 0x1000>;
>> >> +		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
>> >> +		ptp-timer = <&ptp_timer0>;
>> >> +		pcsphy-handle = <&pcsphy0>;
>> >> +	};
>> >> +
>> >> +	mdio@e1000 {
>> >> +		#address-cells = <1>;
>> >> +		#size-cells = <0>;
>> >> +		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
>> >> +		reg = <0xe1000 0x1000>;
>> >> +		fsl,erratum-a011043; /* must ignore read errors */
>> >> +
>> >> +		pcsphy0: ethernet-phy@0 {
>> >> +			reg = <0x0>;
>> >> +		};
>> >> +	};
>> >> +};
>> >> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> >> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> >> new file mode 100644
>> >> index 000000000000..ad116b17850a
>> >> --- /dev/null
>> >> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> >> @@ -0,0 +1,44 @@
>> >> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
>> >> +/*
>> >> + * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset
>> >> 0x400000 ]
>> >> + *
>> >> + * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
>> >> + * Copyright 2012 - 2015 Freescale Semiconductor Inc.
>> >> + */
>> >> +
>> >> +fman@400000 {
>> >> +	fman0_rx_0x09: port@89000 {
>> >> +		cell-index = <0x9>;
>> >> +		compatible = "fsl,fman-v3-port-rx";
>> >> +		reg = <0x89000 0x1000>;
>> >> +		fsl,fman-10g-port;
>> >> +	};
>> >> +
>> >> +	fman0_tx_0x29: port@a9000 {
>> >> +		cell-index = <0x29>;
>> >> +		compatible = "fsl,fman-v3-port-tx";
>> >> +		reg = <0xa9000 0x1000>;
>> >> +		fsl,fman-10g-port;
>> >> +	};
>> >> +
>> >> +	ethernet@e2000 {
>> >> +		cell-index = <1>;
>> >> +		compatible = "fsl,fman-memac";
>> >> +		reg = <0xe2000 0x1000>;
>> >> +		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
>> >> +		ptp-timer = <&ptp_timer0>;
>> >> +		pcsphy-handle = <&pcsphy1>;
>> >> +	};
>> >> +
>> >> +	mdio@e3000 {
>> >> +		#address-cells = <1>;
>> >> +		#size-cells = <0>;
>> >> +		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
>> >> +		reg = <0xe3000 0x1000>;
>> >> +		fsl,erratum-a011043; /* must ignore read errors */
>> >> +
>> >> +		pcsphy1: ethernet-phy@0 {
>> >> +			reg = <0x0>;
>> >> +		};
>> >> +	};
>> >> +};
>> >> diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> >> b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> >> index ecbb447920bc..74e17e134387 100644
>> >> --- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> >> +++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> >> @@ -609,8 +609,8 @@ usb1: usb@211000 {
>> >>   /include/ "qoriq-bman1.dtsi"
>> >>
>> >>   /include/ "qoriq-fman3-0.dtsi"
>> >> -/include/ "qoriq-fman3-0-1g-0.dtsi"
>> >> -/include/ "qoriq-fman3-0-1g-1.dtsi"
>> >> +/include/ "qoriq-fman3-0-10g-2.dtsi"
>> >> +/include/ "qoriq-fman3-0-10g-3.dtsi"
>> >>   /include/ "qoriq-fman3-0-1g-2.dtsi"
>> >>   /include/ "qoriq-fman3-0-1g-3.dtsi"
>> >>   /include/ "qoriq-fman3-0-1g-4.dtsi"
>> >> --
>> >> 2.35.1.1320.gc452695387.dirty
>> >
> 

