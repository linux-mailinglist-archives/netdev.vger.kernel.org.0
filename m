Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A7969C0FF
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 15:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjBSOvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 09:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjBSOvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 09:51:47 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2092.outbound.protection.outlook.com [40.92.99.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34952E3BC;
        Sun, 19 Feb 2023 06:51:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOZfDMfrho0FVWSL3MhDtbW/pTCZLMvlxhJoThJJ3Gmsb/nJCZzTcD1vWlSVX42b+Z4W1ODNbvfqucTdHJDa/N5WF99rnrwCfrTDiN8wUajTrp0e5n87BhqnmaILIPZFPOmepsmXfP1735toY9VwSpZz1fXTUrCxm5P5zjhKhZFlRcHVYdXYkGdyxjvUZbR/RLD4gJ8givoUrhlTwRSU1t+yg1IBn2R1cJVnN9F4Qul2X4QxeoLgkdYknFu+iTbnikw07k5u77JKNa8hfH4htvhLmRzGuTb3U7ZOEyTnyq+s+oZMYkUWmBdMWJobwECh5RLaqqmyFPZn9BxYt3/zfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Raj4PqD/OKlqffThxw2ajMmIyeA+PCBuwPWDJYTyo6A=;
 b=D8ClpSVIXVsm/WImKj+giQWNK5MTzEkThu3gRwZ2QQFiHnAP9h30opK82TMIL2ss+j5WboxGwE/mbO19U45w1dUhZrQLwS5txIjpWfpCbGz2raeaD5SDz0UGXsd+kXHNWbUpD9tY5qHgUuDUSd7swxF6L4F7rD7nfU2bnCeoiLATAxgJgNh8bQ4vdbi09BswEpfpuFmVJfTXiUaMYgDnEZy6ptPMqCcBaQxuRJp5yvFQIaxgvIq2XanfZj1qDDHkXMBiiMe5KyvsZrkpsCvOSCuq2ceFBShA/ARJFJtn9mpMWDoZ7c6I4OxJRaJv8c/y5PIlevmxbs2S9HJpPm33Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Raj4PqD/OKlqffThxw2ajMmIyeA+PCBuwPWDJYTyo6A=;
 b=B8Kdb0BWMxhXz+T2uA3ieHcZ5jCkt483rQXc2LrCSISVK87t+kIS7E4WF4Ipmh15jJ49MYGMFiqd8IxCpW8ci/maUy6qbBplGUoWLnwef/WfYIyW6oHkDfbWxo8frMvvDyfdutNFx2S9T1859rYG9BdlGT69Hho6HzDYbYn3gLVKBkmQ8jlIcQ5xaIxma6kzvqkK+1hebTXLOI2S845dLbuKIU9Way310X1X6+zBY9wSo4tObdjMTK3L8Upkhx39qjoYnbRXlewHuEGoQQbv0+6cZfvn5zFZ87OlXVdr9KFOZsJoSSYA7vlWnupHE+yaKyb0gUjn8Au3q+Z7wGYNsg==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYCP286MB2640.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:244::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 14:51:43 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 14:51:42 +0000
Message-ID: <OS3P286MB229586C1A9526C4F4FFD2234F5A79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Date:   Sun, 19 Feb 2023 22:51:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 1/1] net: openvswitch: ovs_packet_cmd_execute
 put sw_flow mainbody in stack
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <Y/IqJvWEJ+UNOs6i@corigine.com>
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
In-Reply-To: <Y/IqJvWEJ+UNOs6i@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [Ba6JQbb74+PnDd5FECsirjkA7KxeeMDN]
X-ClientProxiedBy: TYCPR01CA0178.jpnprd01.prod.outlook.com
 (2603:1096:400:2b2::19) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <0e64526c-6387-8a80-cd51-fb72d6c2faa9@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYCP286MB2640:EE_
X-MS-Office365-Filtering-Correlation-Id: 474d1361-03de-48d2-8f05-08db1288d095
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iqbk4h7pGIlKy+Z7nr0GcB84mgq1DW8B3KtlI0hlAE5Al8GHqC2e2zSIc1Ys13+YHdQDUrjqUqoG2llw/qTH0yCakF1XD4qV9bwSaH/I3ANGhC4iR6QhY5C18EX3TG6fqj74kAjBunxOv6f+eao7J46tqdCDOkw4zgbzoLvLhaoRKUkINaSxbCYIgC0MJ/g9T9eOiBTD2tZv6kl939IczlHe8Pt6HWTpPBx669c5eTHacKFGIA1qU6DI2dOoOpdaCPgGDtIm9z+ByKfSHXDxYjuMt9VkVRpTHz7/xVUHgTLgWqJ1WNybGiQpyjYVO4EDtb+PVZG0hTiUWEt9QAO97GxF7H1uyffJIqK63Y/S9YC5vLZBNY05NlF+7MBAokgrZ8PLwr+4w3COvLmnFHCos3Shpy2q87tiAQZj9KhXbpyk+talgtPnIOVcHk4wcLTJMpULqMg2G9nJBwkDPp1IKrNqpjVR9KVHQLrcJGWgyS7oMr7u1FFVXphpG7UR7/qOfY/gCQcvoI/RPJltycAhVVNTq3RivrEHA06pPQeL8BCX6Jr/Sc7ls5g6T3Cip7H41aaGIn/q8oKsncucho0pv0ioZ5mWLfbowghy99APEHufe6ulQbE0a9sccDK766ofuF88RTVaSdgGVSc/ouXllw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejNwNWN1aFFsQy9mRmlRd21DMEY2MW1sT2JNUXY3dGdQUnM4RGNoY1dQdTJ4?=
 =?utf-8?B?aDhhNk16Ris1VWRJd3FDd2l3QkIxNEswZnlFQmU3NUJYdkpQaytLM0Z5bWR2?=
 =?utf-8?B?NWxITERUWk5rS3pWcXNOa2oxTkZiUnNXcHd2ajZHN2J3ZWFLaFZxMGcvcmYr?=
 =?utf-8?B?Q1g2bi94ZEVPVTNWVTBiSkdYNXNSb1RmbkV6ZVMzcVd0azZaMEdFM3BUWWVm?=
 =?utf-8?B?eFRXVS9uNit5MFpFN0VoUjBIS2M5T3pjeTFPR1AxQzVTVkYvbUhBbkFWL01w?=
 =?utf-8?B?MmdFNzRRcHFnZC9RdVJJSXhHWXZaMHBKQ0RjYzBvcmF2NDJ4MGZ4SVpNNEkr?=
 =?utf-8?B?ZGZORlFoNVNvSENENDlSc05QaHlTMkNpcytRdmhoekJHbzlyUEx4aXBPOXJ6?=
 =?utf-8?B?UzNBZFZRQ0o2Q0loeDVWTUNuTXVYRkVhdUt2WVY3L1NpamJReG5PQWR1NW1v?=
 =?utf-8?B?UFdHdW80dFAyQlhqN2JMdGszblAyTk9hMEhXMDJzQjgyRWJBMmxyaEtQYmI5?=
 =?utf-8?B?WjdBVUNoUnhSc3VPNzNXM1h5aTdpVG1YMWxkM0o5bzNsYS85d1NudHp1bHFN?=
 =?utf-8?B?MEVMOXZ3enkvZEFHMFFyYktJZ0NXeUNGbTlwVTM1SFFvT3hwWXdFRXZJRCtW?=
 =?utf-8?B?cmYrTHFFa3lmTFdZNDNXbThrUTNkNlVtMC93US9CYWR3SndxaUJsRjh2S0pX?=
 =?utf-8?B?T1U1bWlYcGl2YnBJMlVNY0pVSmZodkRzcC8zLzEwcFJzYnU5REZ5aVVKWjI0?=
 =?utf-8?B?RU5EMTVlOVJzM2ZjVjlxMzhNZm8wajZFWnRwN2FhNDNYdDg2VFlhMTNQOERq?=
 =?utf-8?B?SDRBSnRiVDJSL1R1NERIL2NNR1ZkOVRXQmJiVmpRYVhlOGpYYUR1Qm1IWjF2?=
 =?utf-8?B?ZUNaNFJVdTFTMFE1Q091eHJvVDZMMnU3L0laMTlGWG5xcDJ3Mjd2SzJFWGxK?=
 =?utf-8?B?TWFRRzVFdUtpcVZTRjB3U1RpY0U3dUJJY2pHSG9OVWRpS2h1WjR3dzA2WXZ6?=
 =?utf-8?B?dmpxUHNKNTRuKzEwT01sS3lMTHdHR010UDRWYkxvbWJMY2s1d3dIUWYyWnJY?=
 =?utf-8?B?MHhBTHJ2MzNDeE91ZERyQ3hIb1pvVkFQbTFEWVQ2OGpyaVFsOGdCa2x6SWRm?=
 =?utf-8?B?WVcxSkg1UVJKTm1LNFBkY3FUcDR4RDM4OFhmNE9Dc01YVksxT1RaZTF4bUlR?=
 =?utf-8?B?ek41N2ZNVXd6bGd6Z0UweUtHeTRicUhhZXpLKzJ0Z1RhNyszbnlUeG1BVlNQ?=
 =?utf-8?B?aWZ4SldSVWVIbE5YSDRWbU14R0ovVGY2d21wVElUMHpweDhZejRkUlFuRmZ2?=
 =?utf-8?B?L2ZnM0xvZmRPY0Ira2xsejVmRG1yZGJOcHNzNmpISGY3eWVpNGIxeHU4OCta?=
 =?utf-8?B?cXlJNThOeFFpU2tFakk4YjJ6L3RqSW5YdDh3LzcrRUx6MDQwb0grdXBuaW9z?=
 =?utf-8?B?bHJzNjFGZG5kcFROemd3Q0VYQjZhWHRCRExwdno1Ym1xWVZudTJYeWV6WW0y?=
 =?utf-8?B?UHN4bVRYaWpWbG9oZ0ZPREhRQzdlK2U1VU1zaUxUQmpTRnZsM0hIVzVjRHFD?=
 =?utf-8?B?eVBxTERkbllGeXdyeksrZFJmSGpDSC9hRnQwL3VxOU1Ma3cxTHVOUGoxcW96?=
 =?utf-8?B?bDluWWsrNmJhY3ZwLzVBQ2paWTJodEx0SFVzVjMwa2h0OTN5MzBVNGZadHZx?=
 =?utf-8?B?cGRKVFhGb3pQSlJBS1Y0b2l2b2kzTGxXbkxZUHlJK1UrNkFzNk9ua0FBPT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 474d1361-03de-48d2-8f05-08db1288d095
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 14:51:42.9558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB2640
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Are there other code-paths that would also benefit from this change.

The change is focused on packets goes from user-space to data-path, I do not see other code-path that can benefit from this change

eddy


