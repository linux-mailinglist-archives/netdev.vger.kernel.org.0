Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0F252CB04
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiESE0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiESE0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:26:32 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2076.outbound.protection.outlook.com [40.107.101.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E33035A86
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 21:26:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khTGgtIxjHuIWdkZzDo3fjZFX92bJNSAhUTvg+eG/as653XH+pnNKCQQoqakk5WZ7hkzvkJhgT1n5xrEmxflKDr+WmUnLa+cYF02o7cM9tTjdZxzV9O4RlpR+iNNIMbwFqxRFL1aTs/LM1eV9lxZBl75O3d4JaAB6yyanfxrLDmRnVxFenAvfcgu3jZEH2zDdmptj5kBWW7YDtdMOT1kxTvN7IZ5YN7pINej9/LLfDgozLBColuH6qPh9VaTAXaUCeVg2XTFcquw7xwdN/WJPNDpOUtA418arSCcMmx2SL3huHbZa6q1gPcyWVcEVNRbhn1OQTD8tZjqxeFRU4V4Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAaC4bieTIMFnM4BRaB+4YyO34wgq2OCc5Z6tT30QcU=;
 b=RrCkZ1jq11lcw3rQD/Akd74LjDhhyWhvoTXAV+0FXkZsLY3+V7ewkRIcd1c1mllPUvpUY+f7RgcKdyFO/simI5hxcBtJq7qU8n6w04mOODaR2acecD+njHCN2WrdGL++dOocvZQf23xA72Ruyc6ixKRCnZOjkYDrw/Wj/YZBi1tEpmnxXDkBOSD3U89gnUtFjTaQOPuZlou6xTBi8TTxCKa12iQW02x3dn3GK3sZWjVLkZtlLXjJkR5JJxyq2bAoN5x6KlXIcCaiKk9hr3S2/uvK4jgAN1k2/gEhqpvqnkDy16X0iWn9hRhl/jIV8/j3zgyar196rNynv9xgdreKmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAaC4bieTIMFnM4BRaB+4YyO34wgq2OCc5Z6tT30QcU=;
 b=I9KSOhsdH9QCqkv6BLRYym3gaLiShoIh7rE75Cxw+v8J6RyCk6diTM4wndUaAfbyvV4qDUa38bubsDQm+IysI6PobAjhr1Kushj+WhdhPQwaNHzm6XcyNut4GIDvy3khYlvRcq259glTZjGCCnntSJacRJ+ouHJVoxhm9z2JZKB1ffiGjlW/osWJN1KLHbqSYs8NkqJZA2w4TkriF/Cp2bE5bbd8FRebGOedJ88mloAbiDVdomfwgL3WwvTWQhOU/8kYyvXK+BJKRFXOsaidSV4/Zd5ThzfHKLhhPteda+p/jxFDvyhJih4dlYIwqXCWr9uqCwzkRNi1C1MXS6iXbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM4PR12MB6374.namprd12.prod.outlook.com (2603:10b6:8:a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Thu, 19 May
 2022 04:26:29 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 04:26:29 +0000
Date:   Wed, 18 May 2022 21:26:28 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 16/16] net/mlx5: Support multiport eswitch mode
Message-ID: <20220519042628.e2yqi37ceyks6rbv@sx1>
References: <20220518064938.128220-1-saeed@kernel.org>
 <20220518064938.128220-17-saeed@kernel.org>
 <20220518172141.6994e385@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220518172141.6994e385@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::8) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f94ab185-9855-426b-535e-08da394fbe96
X-MS-TrafficTypeDiagnostic: DM4PR12MB6374:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB6374A50256834260E0A77BBCB3D09@DM4PR12MB6374.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0sNstFdQ1KQEVTye+Hu5QrTOgt0j1tpgSAXTKM1mfPU3NlpZ4zlQYYIeJIMCc+5wmKthJoWavulQtbckxb5eszMLmKqq2/Y+TfiAN2ejEzEoKUuTBl/cXVbawU1VT0Sgdch5AnxyGKYwakwA4vPuYtG7xnTZyHtswDdG7lZUU0vmLbjl/vbG4XaG8cIPOPdV/dfWTYcQg2XIZPWkAsCnq41hyxn3rV+Cdnr49r0p/EnqEf2VTKrUH+fy4CH8HVxzKql9qMU620n3u3gJ8iDXSo1CXAOQCgdstU90bReT2CS/aJJqM9tjsVHcoJcBBJ4zBUNxArrh1uzbLdabXZKCe62C6WoKm/xjGwuWst2Xu8U31G08n6Ij7fV4YUxLOvkgWkaqjM3D1SVnhJiGBECFrUVOn9i6bFaL6cgOP6VCE2G1/m8itFY6WagmF7nWr17jbynNyiuzhJD7WV1Yma185wMISmEIMz5V6kNRoe6jXG1lMCQHX9HRphLXzDqdK6Hp+grsqGuuAiglilBnFtEVpd7mmUKCL8In1MQo383TscbHX4fe29PAiFxSxjyQv/tZuoIU3tbwlfUOJU14hLJAL9NAR/T4wg/RTG62XvzzwReyzMTah0akRvCK9/hAKBPD9+I3bRx3sswyVNrNJRpbUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(107886003)(508600001)(1076003)(186003)(6486002)(33716001)(66946007)(6506007)(8676002)(5660300002)(4326008)(6512007)(2906002)(316002)(86362001)(9686003)(38100700002)(83380400001)(8936002)(66476007)(6916009)(66556008)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkVtSjFPejR0M28vZkFyWHM4WVM3WFR1NThqNzVCdmd3bUNVTi80WmVIZkNk?=
 =?utf-8?B?WkVzQkNOVjB3Q1RxZC9FZTFNWFVZQUZqQXJYY3VjUUtPQmY0WTZBb0dXRjly?=
 =?utf-8?B?cEpxbzRycVpraGZGallkUzAzMmN4dnV0b2k0V0dJNTI2eTR0Uk9jUFFtWnZR?=
 =?utf-8?B?cUpVNDluUGQ3NStyY0ZxT1F2R2Y4RDFQYVo2bFlRUHd3VlR0cU9ialF0aVJR?=
 =?utf-8?B?cVV3V0ZnazIyRHpiVEsxd3o3anVzSVZ5SGx0Q2FTS041OFNLSVlUUHlEcnIw?=
 =?utf-8?B?eDhLQVFJZ3hXck01SkV0Y1p5bGNPUUs2MHd2dm9oQitYUmJPV1hVYVhUak55?=
 =?utf-8?B?WE8xSno4amlPZllnUW0xVDRPdnJ5cmhzM0hSbzgyNmpmMWNoeWk3a1VUdGlV?=
 =?utf-8?B?ZFM3VkgyNkF5cGlKMUdKRXA4djNCUDhjSHZjZHVsVGdSdk44ZGpBblVKcmFF?=
 =?utf-8?B?a2NlaytzTVQ0S2RRem5GWit4T1JjUkNZUHY3VEhsbHY1dTBDRzFOQzJUL2JT?=
 =?utf-8?B?QmYzZ09Ga1pHYXhKbHMxb3doVGo4NTR3bVlYSDF5bGFUdVUrMDlqaGllc2Zj?=
 =?utf-8?B?TzBTNU1zN0h4M3hHTG1rYUcwOE04TlZ2UlFLa2xEc3cxWVl2VmZ0d016NVlI?=
 =?utf-8?B?eU9QbEEyY3FIMG5HSDJJa2ZQemgvTUEyenV1NDRWUFBCRUxEK25xcm02Zmg2?=
 =?utf-8?B?ZndTUWNqZFdhNDNkZGZIN3RtYWNkVHdBN0lBNU1vT1dBNmg3MFlsTTZtUk1I?=
 =?utf-8?B?cWMzaWd0NDlUUEYrbmtjSHVpL1RyS2xZcjFuNlYxN21xcnppODByZ1VKMFR1?=
 =?utf-8?B?ckxtOE82NHNKWW94R2dra2FSd3hHV2xmNDY4WmxWbG5RY3lNaWRhVTJPVUMx?=
 =?utf-8?B?QnZGa05WM0lBUnFkYkhZemZ4NkhRTm1PM0E2UVUzTXF4ZzkzelpEZHR3VVRk?=
 =?utf-8?B?UHUwZVVDd29RUzZ5YnJtcnF3K2tNRHNxRFlUcU1kSHZjY2t3eVU5SGlQS1J2?=
 =?utf-8?B?MFEvNHZUbVdjcWI1b0NwbElhWG9QQ1pXQzROWGJDZkxwYXIxSHkwWG9MSzZp?=
 =?utf-8?B?ZldJN0Rzd0Iwb3dORzRuVWVwSnhqajFnL1VLdXpDLzhzVzlURDRHVFJGVFJh?=
 =?utf-8?B?cjBEeUFobW9LR1ZPUXU3bE53a29vT1hUc1hpRkxlbGJSbmdreHRVNlJab0FS?=
 =?utf-8?B?UU0zQTZiMTJMOWEwdEsxTWZ4WnpMUzJuM0djbXl0SmxRdUhqSmd3T1ZHK251?=
 =?utf-8?B?SEJ3WWNNV085dnVzQTlvTDl4NjRlSEo0V1plRnFDaGRPVS9OV0NObm82N2hD?=
 =?utf-8?B?RXpyNllKOEtmcVh3KzBlWFhrRjRGREw1VTFtL3ZOV1lWQ1pxYzVmN2svRUdn?=
 =?utf-8?B?Yi9pd2xXVERTTmxoNGdTeXRtWjk3S3dpeXBSNkd4M2xIaXFScGo5RnNmZHZB?=
 =?utf-8?B?eUZrV21xbGdxWUR1cE9qYW0rRnBpem5tUXIrYlI0bms4TGFuT29kVUtmNnBj?=
 =?utf-8?B?YTY5NW10TjZ3aUkrT2kwcVA1ekFEWEJnd0ljbUNuM3FVYi8xanppV05FdHg2?=
 =?utf-8?B?YVc4U3RML1VnOUpjd1NCTWs4dGl2WXFFTlIrc2pTWng5YVZBYnp0QUhIWUFW?=
 =?utf-8?B?NU1IaThNMnQ5WWZTR2hUR1dzZ003dmdBWUJVeEgrOXhsRGViajlsdTNnRUdK?=
 =?utf-8?B?ZHVUblJCSzBRZXJoUU5TanZvTlRWT3AxYjhnRHM0bytkMENqUThMbVhNVHpX?=
 =?utf-8?B?ODE5bUlnc2JwUWRvUno4Y2E3dmJZRWdZY0l1cCsydE51V0ZweGJuQnQ1ck1i?=
 =?utf-8?B?U2hyTGJnVVZ0ZmxlZWozbTVHNnpqdCtXUGVNVEpwK2Z0dlB4bVR5U0xDUGdu?=
 =?utf-8?B?MW5IUzhZUFFSbXBrVkgwUDJwVmxSY1hCdGt5Z2ZkcXo1QURVTkRnWjBJY3Ft?=
 =?utf-8?B?THMyb0s3d3RiRjcwS2ptOGRnTUN1RDkxcUtzbHJGRk5OS2NBMWk3clBYNWNV?=
 =?utf-8?B?eUhYMTczejhKSjFDOFpSbTJURVc2cENKNG9iZ2FJR0JhUW14MXhOeTFxQUZp?=
 =?utf-8?B?aXJ5RXQ4MGFDL05EMDVXY2NHRlBMMzBVZEdFRW9kWXhaQ3VQL2VzOW5ldHJn?=
 =?utf-8?B?blQ1eWJHU1gwOG5lSEYyeGEwMThVUFo2ak9LL2xqZW9KL1NycGJpQU9iUXpt?=
 =?utf-8?B?T1U0SXBtZmROelFjakhJenZ1UGQ5SndENG0xaWRXUnoyWmFibTd4bWxWaGp2?=
 =?utf-8?B?VndIdUY4Wktzd3NXVy9FWlZNQStVVHExVDZ0WDV6Yk0razJveHZDa09wakNo?=
 =?utf-8?B?bUhuQndyQUtsaCtrK2R4Q3JFRzhxbjI5Z1hYMkxWREJCeUdnM1pFdTM0cmZw?=
 =?utf-8?Q?2yc7WJNmGl/iUjm3cOtmGteISzciAzV/HvWfv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94ab185-9855-426b-535e-08da394fbe96
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 04:26:29.0006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jo7YxIL3ViuNLzuR5AbfaMGjMSNK2X/CCxCBzEvGppVMTiAdzZe2uuVsKlq1XMT3Qx+JQlbCBz7IUcjoACTl6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6374
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18 May 17:21, Jakub Kicinski wrote:
>On Tue, 17 May 2022 23:49:38 -0700 Saeed Mahameed wrote:
>> From: Eli Cohen <elic@nvidia.com>
>>
>> Multiport eswitch mode is a LAG mode that allows to add rules that
>> forward traffic to a specific physical port without being affected by LAG
>> affinity configuration.
>>
>> This mode of operation is mutual exclusive with the other LAG modes used
>> by multipath and bonding.
>>
>> To make the transition between the modes, we maintain a counter on the
>> number of rules specifying one of the uplink representors as the target
>> of mirred egress redirect action.
>>
>> An example of such rule would be:
>>
>> $ tc filter add dev enp8s0f0_0 prot all root flower dst_mac \
>>   00:11:22:33:44:55 action mirred egress redirect dev enp8s0f0
>>
>> If the reference count just grows to one and LAG is not in use, we
>> create the LAG in multiport eswitch mode. Other mode changes are not
>> allowed while in this mode. When the reference count reaches zero, we
>> destroy the LAG and let other modes be used if needed.
>>
>> logic also changed such that if forwarding to some uplink destination
>> cannot be guaranteed, we fail the operation so the rule will eventually
>> be in software and not in hardware.
>>
>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>
>GCC 12 also points out that:
>
>drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c: In function ‘mlx5_do_bond’:
>drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:786:28: warning: ‘tracker’ is used uninitialized [-Wuninitialized]
>  786 |         struct lag_tracker tracker;
>      |                            ^~~~~~~
>drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:786:28: note: ‘tracker’ declared here
>  786 |         struct lag_tracker tracker;
>      |                            ^~~~~~~

it's a false alarm, anyway clang and gcc12 are happy on my machine:

$ KCFLAGS="-Wall" make W=1 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o
CALL    scripts/checksyscalls.sh
CALL    scripts/atomic/check-atomics.sh
DESCEND objtool
CC      drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o

$ gcc --version
gcc (GCC) 12.1.1 20220507 (Red Hat 12.1.1-1)

