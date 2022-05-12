Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D32524F8F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348914AbiELOM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiELOMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:12:25 -0400
X-Greylist: delayed 421 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 May 2022 07:12:23 PDT
Received: from mail.delivery-6-eu-central-1.prod.hydra.sophos.com (mail.delivery-6-eu-central-1.prod.hydra.sophos.com [35.159.27.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BE561295
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:12:23 -0700 (PDT)
Received: from mail18.euc1.prod.hydra.sophos.com (ip-172-20-1-91.eu-central-1.compute.internal [172.20.1.91])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.delivery-6-eu-central-1.prod.hydra.sophos.com (Postfix) with ESMTPS id 4KzYSy4ltvz1vP
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:05:22 +0000 (UTC)
Received: from ip-172-20-1-61.eu-central-1.compute.internal (ip-172-20-1-61.eu-central-1.compute.internal [127.0.0.1])
        by mail18.euc1.prod.hydra.sophos.com (Postfix) with ESMTP id 4KzYSw6d8rz1xn2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:05:20 +0000 (UTC)
X-Sophos-Product-Type: Gateway
X-Sophos-Email-ID: 8dce5c93b18f41af84722e4e1330240e
Received: from DEU01-BE0-obe.outbound.protection.outlook.com
 (mail-be0deu01lp2169.outbound.protection.outlook.com [104.47.7.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by relay-eu-central-1.prod.hydra.sophos.com (Postfix) with ESMTPS id
 4KzYSt2MskzbbZH
 for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:05:18 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9uFsUHkwIZPdUdrDUAhpH/0rYk6zbkDWQkJE3yDiGtZ43gzcrVEJz/s0Ll0xtS9/kwk4Qn8Z+lucXpCe68GTMzeopV0vUORlnMiz1nl6znlJe+p6NhaB7ODLyVfJHoBCdVVNfwuuQRAE4K1TW3of9pmWV0udSi1dMIOkntNg047Ogo4vMVvgid+PojZco1G1kH4AeNSSuwHpB5CXcCo+zoch5/qSzVaTQFfYOx3LeEE1SdCLybEMBsAdXucrwAnt3ZgDMgAkUpC3mHwmVw8NrA804pmSmqnuh+sYGNrKTAMk2GX4tS98qdMUuuH+bZraEYj/q7Y4DwQ9rM8cpdFFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zoy4eUrwpBf+HTACi6uXU9YUI+tmtowT5BOYSL8GV0c=;
 b=j4J2DlNde5GzXy1ryvHGX/iu4rctVmwDcqlyduzaLydhrDSYc6pSJ3eSCm7hCgZUV39W0gJ7/3I27lN5fZCe1mX13nN/cXQ3AvRtUTZO1R17d9RGZ0Mb2VngTw8qbEmcITO9Tj0VzC0UDrPJBCGsykbMhFN7G80ccGnXTV7Lhre+N6862NmOEpuDNwHTd1o0/UzCMzPlHwVbXqitGNxHjQvBjDey8vtzc4NYCiC9wsO4sVL0A+I/XLAeDMPSAe6TmGy+0wLjM9sqzS7qUQP+o9SPQC7wV5Rn6hAEZZ0YmXAGLjiVANE8OQ3ksgsFIOrS/+R9lvNnKd0vyg3n4/QJVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=anduras.de; dmarc=pass action=none header.from=anduras.de;
 dkim=pass header.d=anduras.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ANDURASAG.onmicrosoft.com; s=selector1-ANDURASAG-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoy4eUrwpBf+HTACi6uXU9YUI+tmtowT5BOYSL8GV0c=;
 b=L62C11wdMRbY6t974QaDr4e96in/Cs+tXekeWnOaWLNpVX/gfFjWEMKmCGEEoVGeNEN85+vcm04XfYJHeCnU9CO5qb9cBfCUvKWgu4l3gT65UDTRmiOUsGoio+l3zDDVDUMIR4u4WJPcMdhVm20fGzE/EiNiUhH6E2ObWQDsaow=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1652364315; 
 s=sophosf9aa68d74dee45c58aac945adde58f79; d=anduras.de;
 h=Content-Type:Subject:To:From:Date;
 bh=zoy4eUrwpBf+HTACi6uXU9YUI+tmtowT5BOYSL8GV0c=;
 b=ObnpHP34hsxQGx1fN06UWEwuXAB5vp7MDCkp9/r5kQOwWLDOB6v0MqP5RM7xrV5j
 EiAXDFke2ZjXYCBLj5jdsWW3Ydw1vfulY4Z4rAOadEkdpSnolupUHDWCcMBe+UpkZK8
 NlLuviFNybrqE7IfQ1vZ/IEzL5lTGSzBlc88/XV5F39bFipOlUesZE2j4sLFyGmlxWh
 rj7L65fXKTSjpcysC8mwV6WEs0gDpImpwxmvE5dXWatZug9YJPgcVXS7N65I7X/3NJe
 0Nn4QO0eh/SyT3eT+2wcmw7uiJ5QqjFuQKCQKImBtA0hzj1Bi5BNrVLaoacY7lfXXu1
 ay+IZTd8AA==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1652364315; 
 s=v1; d=mail-dkim-eu-central-1.prod.hydra.sophos.com;
 h=Content-Type:Subject:To:From:Date;
 bh=zoy4eUrwpBf+HTACi6uXU9YUI+tmtowT5BOYSL8GV0c=;
 b=IcI5sjhGydXFVhM0T362ESgUJJfwNdjvNzrtXkUHOgvpJvcKfvDDOtbf68pcOPOv
 6h22bmDbONtUrw6VdKhsEWgCpr0gR1ZWTs+OoMOzJrT9A4h4/5TdUVCZac/0cCMsXna
 cUJm/gRK3cOS6NPxANd0RK/UPE95zBzQhYejwtC0vO4ZeefeTapLK2Lps6caf7PwV0G
 +0zvqpJ5VQun/Z7ouK4OfEoLOEEGm5fg1Ihtfk4KhYbAqSwW3lIHxVrveWF97wMxY7c
 Pbs8LposRFLYsPHkaUyKwjZF5X8wA/h7mfQ0MQu/8do+bocw0JV0uG7YyRik5+qVnIy
 c4/DcPgADw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=anduras.de;
Received: from FRYP281MB2107.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:2e::5) by
 BEZP281MB2455.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:51::12) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.12; Thu, 12 May 2022 14:05:16 +0000
Received: from FRYP281MB2107.DEUP281.PROD.OUTLOOK.COM
 ([fe80::95ee:7f8c:c675:8cc]) by FRYP281MB2107.DEUP281.PROD.OUTLOOK.COM
 ([fe80::95ee:7f8c:c675:8cc%9]) with mapi id 15.20.5273.005; Thu, 12 May 2022
 14:05:16 +0000
Message-ID: <700118d5-2007-3c13-af2d-3a2a6c7775bd@anduras.de>
Date:   Thu, 12 May 2022 16:05:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: de-DE
From:   Sven Anders <sven.anders@anduras.de>
To:     netdev <netdev@vger.kernel.org>
Subject: Bonding problem on Intel X710 hardware
Organization: ANDURAS AG
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0072.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::25) To FRYP281MB2107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:2e::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef89f8f8-4a2c-4a5b-75b6-08da34207120
X-MS-TrafficTypeDiagnostic: BEZP281MB2455:EE_
X-Microsoft-Antispam-PRVS: <BEZP281MB2455C1E1B670A88383C298F284CB9@BEZP281MB2455.DEUP281.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gPXmBPHq4LB7rkwsCZcLsk7Ik/TFaItVdnVzIovHiYNOcsQm2Ef5ogNuD9//2OjdAhbTPBf8HSkf8/+mmX1qVlaXENh7Y8EzEnj0HImSvkFPy2C2+v2wc2dRKoIGZyAEquLyjkZ+hEKcpnmTBZqw85qQj+AMnWnOej+KMnz2/cUIhFu+DcSwS5k6uIh1Z/QD4nFG6NYhO3zCD6yilKNYvQn2TIEu+gXYDWP1YAb0e+jUjSvddB5DKHSQRmi4CdH9NuD3Y25EEGu0f0tCZDaXYleAQFtDmMAQdE9VamnSzHIFcS7IVv4ujJV7Xxi3uGPpPgpNXd5+jetEeYYMEs6q+hBnN2K4GMe3gKNce7PdgBblE1V6XJaMZifNAA2SNKTt5Y6v8fCCwv9NZWIEIEOASutAKxv7QxIjxq1UO1b1Kc+qvaZbC+gVt46MJedPIpwCvbx58MJ6SenZHO4PCbF7DHbhceUyjkUYkbP2xgQu4N2a68DtRNcMtz86gzuxGzgqQfLTEGvkS6MLc/5YQVClYmjjYJ6fu6FpgippM7OQAomkkk5FtC9J5+/mk+AgTTVdYNMY1jJw66jMAaOmMb8Lz2bgAs2B/LN33Q6yBa6/mH66qZJXXdIAfWTYdAARFmSS21qHCvD26jGTYwyLagdopMI6wTuAiCVmLL4Yr02OT3llUT5geoy1Kslbz87dJTR89RHWesCmAvsbmfawGgwMS5X3zMus2LWHaX6YTCnDAwONtklugISEI5o/G+vrRjf6/toMRKH5NVSo+o3TK6oibT9t/hf79P4oOm0B6HP3b3G5ivnF1K3qmO9toyinx+KP
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:FRYP281MB2107.DEUP281.PROD.OUTLOOK.COM; PTR:; CAT:NONE;
 SFS:(13230001)(39830400003)(376002)(136003)(366004)(396003)(346002)(83380400001)(38100700002)(36756003)(26005)(6506007)(36916002)(6512007)(316002)(86362001)(6486002)(6916009)(508600001)(44832011)(8936002)(5660300002)(2906002)(186003)(2616005)(8676002)(66476007)(31686004)(66946007)(66556008)(15974865002)(31696002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXpKejVpZGh1aXY1YjBQS1ZTMmorRDIwTnEvZ09TaWxYMytieVFQMW9MNTdm?=
 =?utf-8?B?Z3NlRjh6eU9BU2pwdG9XK08xN1BGNWVTWm5JcXp0Z05QemFjZzJVRGxrMWZn?=
 =?utf-8?B?UERlZTFrakdDbWpyQm9vYXVvRlpjOFo2dmJ0Vm1IRGVZZDJqbWlYU1lTWkda?=
 =?utf-8?B?WUZMMDBFSWJ6Sno0cTFMcmdBcHRhREFNYzA1ZlRLZTRiYzArbHVnY1pyaytw?=
 =?utf-8?B?SHRpeDFJWVZ3Q2szQkxIcjNobWJJWUttYXNPRDZYdHRqWjdrNXF2blNhUGNR?=
 =?utf-8?B?emtFZlB3MXltSlA3QXB2UGxnL1Q3VlFDNnRYWXNGRFQxYXE4aCtrZXVJa05M?=
 =?utf-8?B?dnFuM01RWjNDMytqaEVGckdyNG9XOVRPZUtXMVF1dGxWYnBSNjg0VjJvZ0Mv?=
 =?utf-8?B?UDhSQ3VWUENZQ2Y0Mlp6aUJNTlc3emwzYk1jcDFBd0s3QVhwSm9XNUpNZW9j?=
 =?utf-8?B?cHFHd3dRMWhycW5rNERCSkM0VTNDTmZ4eEtlNnByTWUxZ0RoajljempXN1d2?=
 =?utf-8?B?RTVCVXpIOUtoZlhJQzZWZERHcW5YWnJCWE8rY2pqSjBlSGxFbG9Sa0xSOWRp?=
 =?utf-8?B?eDdZSzlPdXdaY0x5SGRlMXhlTG5jaWlEMDFlRVQzdnNuTjZsNmVVamdPcGJ0?=
 =?utf-8?B?UnBTb0RVZSs0RlRUelE4ejcvUXAyL0FNWlRBSjJMbnphYTYrOHNYbnY0RWtY?=
 =?utf-8?B?V3ZodUg5cTJiS3VxZVBxWFlXK2M3TExkNlhPMHU4cG92Vkhjc0xLZjdVWFlW?=
 =?utf-8?B?QUxDTHlqOVc4Uzk3eE1GUUJpUWxoU2EzbGtMbVlUVGdsaVYzZDcxd3dJVnVh?=
 =?utf-8?B?TWxxRnRhQldhZy9Cd0pMcDVMZnBERnFFREdtVmFnQ25LTmNseVFlRmt0TWZ4?=
 =?utf-8?B?NFpyVkNENE05V05qSWFHaHM1YSsxOGMwWjZUeVFOdmc3UG85dG4vcWU3R3kr?=
 =?utf-8?B?TVZacFFlSWxnVms4eVkxd2xleUlNZGQwbVo3cWxIanNHZk9GTGwybFdicklV?=
 =?utf-8?B?dWk2WVFZS2xqa1FCRURGeFRiRXhraHJYbDYwVmpScXJEVXRjLzRyd2JZVEgr?=
 =?utf-8?B?NllybXplZng2K0NvQ0h3YkxFQmhTYnlWdGQ3MncrMUNYWW5FdmpQeVcwaFk0?=
 =?utf-8?B?amhhUWdsWGNzYk4yVzEyRjZDanlIVDd5bTZ2TExyNVhRdWFEV0QwTUljQVFx?=
 =?utf-8?B?TWdzck40RlZnd2dKemRyRHUzM2RZd244Ymt6Q2cwL1NUVXA3VzZVbldJSFRV?=
 =?utf-8?B?amZCK29xZDJyamg3VHYvdEFXZ2pQRXBMeUJkNHhzdm9FNFNIMG05b090WFdH?=
 =?utf-8?B?Wk5pOHArNGpQUGQ3RjVxQklzNUp4TXZ2VTBHNktOVDhwNFc0OHV6TEJmTDZM?=
 =?utf-8?B?R3h0K1EzWTJlMkhJNHA5TmVJUENEWmlTVE8zdlZjWjdlUHh6ZWo1UEFmKzJo?=
 =?utf-8?B?WUR5S2I2MzdPVFZ0dXVtT2t2MEFQb04vOHFoZTVUVlZ5S1BXcHBEbHV2TnFE?=
 =?utf-8?B?TzNtTVpQZU9OanozSUIrVjVMekVqTFE2WTd0WFpPc1JrZHJVa20rcitrU1dH?=
 =?utf-8?B?TmNJYzVkY2VBZTREZ2J1a0RXbUpnTXpUZ1F5eFp4TkNJUkJJYVMvT0lScTZW?=
 =?utf-8?B?azdmS3psVmhlbmprWmJ5ekxoaFFCVzJacUZ3YUJ5K2thNkluUUV2THVtRGNl?=
 =?utf-8?B?dFQrOXZ4SjlnTWZBZER5TkZ5RVBLV1prNWU1LzVzNTVTMU5seEpiUXgycXVZ?=
 =?utf-8?B?Um1rQzBndWNzSXJjKys3cG1VQnJ1TWZVOXZpTUVtNWFCM2V1TzhNYlBYUXk1?=
 =?utf-8?B?cGxiUHBKaXJLcGZya3ZhT3N6Qkg1cittaVhpOVhXaXNGNFlqMTdrZDlTZmdx?=
 =?utf-8?B?dXg5N0J0NXRmazE5ckl5OHo4UHMrMmlhMEhQVjFZTnZ1SGVja3JIR2xKQkZL?=
 =?utf-8?B?ajIxbFRmaHFHYnRqTTM1UDllTFJRR3h0YVE3OVBEM2RESENrdzNDTzM4Ymww?=
 =?utf-8?B?Z0d6OEpsMkNHK3krbHRrQ2pyeGw1endsMTdIS1RCQWxHVW9BYVlUd0diNCtz?=
 =?utf-8?B?djRhRDFEY2tBb2ZXbVBDNWlscUs4VExSOStUbjFkRE9ZNUNjWUovazhQempK?=
 =?utf-8?B?VUZ4TTRiUnZ5MGRsYXorQk05L3pKV1JFZTJ5K1o4RUxFUXU4aVBISlZuTWln?=
 =?utf-8?B?S1Y0VmNIblAyeXZwQVdyaVU1UUVCYTZJK0JlZ29NQ1RpN1UwV1RkQVRIaHFv?=
 =?utf-8?B?K2VWRStsZ3lrRVM2VUVDRDJHbmZZRG1ZMkF3citsWEpxZ0xPdVRjYjVTcjhW?=
 =?utf-8?B?UEZPSExxNnQxMmZuRnFUQXNqTldkQzBXRkdBYnV0ekltcmVLWFltdz09?=
X-OriginatorOrg: anduras.de
X-MS-Exchange-CrossTenant-Network-Message-Id: ef89f8f8-4a2c-4a5b-75b6-08da34207120
X-MS-Exchange-CrossTenant-AuthSource: FRYP281MB2107.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 14:05:16.8678 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 639cc95b-aa9f-42bf-b982-a592003fbab3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzttbSasTFpw5Ard34krsRLT7raHsh7dIHYDaZH65acI4YeKIZgWVkjFNoL9c2+0yQdiw6UAmGhjPq47EMgXLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB2455
X-Sophos-Email: [eu-central-1] Antispam-Engine: 5.0.0,
 AntispamData: 2022.5.12.133320
X-LASED-SpamProbability: 0.079439
X-LASED-Hits: BODY_SIZE_3000_3999 0.000000, BODY_SIZE_5000_LESS 0.000000,
 BODY_SIZE_7000_LESS 0.000000, DKIM_SIGNATURE 0.000000, ECARD_WORD 0.000000,
 HTML_00_01 0.050000, HTML_00_10 0.050000, NO_FUR_HEADER 0.000000,
 NO_URI_HTTPS 0.000000, OUTBOUND 0.000000, OUTBOUND_SOPHOS 0.000000,
 SINGLE_URI_IN_BODY 0.000000, __ANY_URI 0.000000,
 __ARCAUTH_DKIM_PASSED 0.000000, __ARCAUTH_DMARC_PASSED 0.000000,
 __ARCAUTH_PASSED 0.000000, __ARC_SEAL_MICROSOFT 0.000000,
 __ARC_SIGNATURE_MICROSOFT 0.000000, __BODY_NO_MAILTO 0.000000,
 __BULK_NEGATE 0.000000, __BUSINESS_SIGNATURE 0.000000, __CT 0.000000,
 __CTE 0.000000, __CT_TEXT_PLAIN 0.000000, __DQ_NEG_DOMAIN 0.000000,
 __DQ_NEG_HEUR 0.000000, __DQ_NEG_IP 0.000000, __FRAUD_CONTACT_NUM 0.000000,
 __FUR_RDNS_SOPHOS 0.000000, __HAS_FROM 0.000000, __HAS_MSGID 0.000000,
 __HAS_X_FF_ASR 0.000000, __HAS_X_FF_ASR_CAT 0.000000,
 __HAS_X_FF_ASR_SFV 0.000000, __MIME_TEXT_ONLY 0.000000, __MIME_TEXT_P 0.000000,
 __MIME_TEXT_P1 0.000000, __MIME_VERSION 0.000000,
 __MOZILLA_USER_AGENT 0.000000, __NO_HTML_TAG_RAW 0.000000,
 __OUTBOUND_SOPHOS 0.000000, __OUTBOUND_SOPHOS_FUR 0.000000,
 __OUTBOUND_SOPHOS_FUR_IP 0.000000, __OUTBOUND_SOPHOS_FUR_RDNS 0.000000,
 __PHISH_SPEAR_SUBJ_ALERT 0.000000, __SANE_MSGID 0.000000,
 __SINGLE_URI_TEXT 0.000000, __STOCK_PHRASE_24 0.000000,
 __SUBJ_ALPHA_END 0.000000, __TO_MALFORMED_2 0.000000, __TO_NAME 0.000000,
 __URI_IN_BODY 0.000000, __URI_NOT_IMG 0.000000, __URI_NO_MAILTO 0.000000,
 __URI_NO_PATH 0.000000, __URI_NS 0.000000, __URI_WITHOUT_PATH 0.000000,
 __USER_AGENT 0.000000, __X_FF_ASR_SCL_NSP 0.000000,
 __X_FF_ASR_SFV_NSPM 0.000000
X-LASED-Impersonation: False
X-LASED-Spam: NonSpam
X-Sophos-MH-Mail-Info-Key: NEt6WVN5NGx0dnoxdlAtMTcyLjIwLjEuMTMz
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

I'm having problems setting up a bond in adaptive load balancing
mode (balance-alb, mode 6) on an intel X710 network adapter using
the i40e driver connected to an Aruba 2530-48G switch.
The network card has 4 on board ports.
I'm using 2 ports for the bond with 36 VLANs on it.

The setup is correct, because it works without problems, if
I use the same setup with 1GBit Intel hardware (using the
e1000e driver, version 3.2.6-k, firmware 5.10-2).

Data packets are only received sporadically. If I run the same test
with only one slave port, it works without problems.

I debugged it down to the reception of the packets by the
network hardware.

If I remove the number of VLANs under 8, almost all packets are
received. The fewer VLANs the better the receive rate.

I suspected the hardware offloading operations to be the cause, so I
tried to disable them. It resulted in the following:

  If I turn of the "ntuple-filters" with
    ethtool -K eth3 ntuple off
    ethtool -K eth3 ntuple off
  it will work.

  But if I do this I see the following errors in "dmesg":
   i40e 0000:65:00.1: Error I40E_AQ_RC_EINVAL adding RX filters on PF, promiscuous mode forced on
   i40e 0000:65:00.2: Error I40E_AQ_RC_EINVAL adding RX filters on PF, promiscuous mode forced on

Disabling any any other offloading operations made no change.

For me it seems, that the hardware filter is dropping packets because they
have the wrong values (mac-address ?).
Turning the "ntuple-filters" off, forces the network adapter to accept
all packets.


My questions:

1. Can anybody explain or confirm this?

2. Is the a correct method to force the adapter in promiscous mode?

3. Are the any special settings needed, if I use ALB bonding, which I missed?


Some details:
-------------

Linux kernel 5.15.35-core2 on x86_64.


This is the hardware:
---------------------
4 port Ethernet controller:
  Intel Corporation Ethernet Controller X710 for 10GBASE-T (rev 02)
  8086:15ff (rev 02)

with

  driver: i40e
  version: 5.15.35-core2
  firmware-version: 8.60 0x8000bd80 1.3140.0
  bus-info: 0000:65:00.2
  supports-statistics: yes
  supports-test: yes
  supports-eeprom-access: yes
  supports-register-dump: yes
  supports-priv-flags: yes


This is current bonding configuration:
--------------------------------------
Ethernet Channel Bonding Driver: v5.15.35-core2

Bonding Mode: adaptive load balancing
Primary Slave: None
Currently Active Slave: eth3
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 200
Down Delay (ms): 200
Peer Notification Delay (ms): 0

Slave Interface: eth3
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 68:05:ca:f8:9c:42
Slave queue ID: 0

Slave Interface: eth4
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 68:05:ca:f8:9c:41
Slave queue ID: 0


Regards
  Sven Anders

-- 
  Sven Anders                  () UTF-8 Ribbon Campaign
                               /\ Support plain text e-mail
  ANDURAS intranet security AG
  Messestrasse 3 - 94036 Passau - Germany
  Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Those who would give up essential Liberty, to purchase a little
temporary Safety, deserve neither Liberty nor Safety.
   - Benjamin Franklin

