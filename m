Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F3E67E5B7
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbjA0Msz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbjA0Msx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:48:53 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C6717CF1
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:48:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjscYmaKAMlXjirNYM/9zUDXnASN1mQGx5AbwcmXsvgV/41QHZXgeaBCXgex8T7OmmKDzsmAQmqt31dtv00hbIk4M33bGWpiwFO1sdx4sAcQDbjv+R+Mg6sg/ilyzH2cwQ0AsIWO/bIvtJB4afHslS5M9+2aLSwNhNa5paX7rMm6mpNAItXnpn3oULCe1ebaYWnhbAKHth9CDy8+KxM453pwLtdbDzQqKg3rEHwAuJ2xkJW6HZHT2/1F8cAGO4Ah5y4YvQUvDD/9TkNnT3oBexVJ8Dx7gHdMxE74FE2yXSXJvZEZJLgvdpTr4VlrmppkBpawbACs88gEpmv/g9jaYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTpMnWKwV54eu85qyXaZoKFjPNBOhL/2OsB2p0/CM6A=;
 b=aIKVZtcOZ9c57uFbfisUTODky/3Z2NwCdiRuBr0agZWSffdAmsPdQqo/K6ee+8uIua6eW6EujKlDPi8e29bkM2wXbB/j6UUsOsoABkpAHFRO99lUzOxarLQuognUjHPQzbRxmijJsaKQsfSnbHeYR0sqHG7vOQfaK2FKE8kiTfbg/4Qqt54tcwsU/Jw6QYEYaAZsS5hR4GzPIjXiv4zjZSIVMDVVnrD+uvvpuZxZy39K/BS+yEyNfW9PqHcwA5/nFG4qsPDiPsezQ+NpziPuSi+AlRNw1ctCTKz9n0ihroyjU6KYX4zPk7ndx6Ku6omMj3ieN/1Q/2H76eKt37aCqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=labn.net; dmarc=pass action=none header.from=labn.net;
 dkim=pass header.d=labn.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=labn.onmicrosoft.com;
 s=selector2-labn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTpMnWKwV54eu85qyXaZoKFjPNBOhL/2OsB2p0/CM6A=;
 b=Y8opzscG/fLjaIQlyGhC28UAJfau5a69A/Z2+W/HCzs1EIEAmxyxl20Ez1jJJGOYoh4p45Ccc+iDZcGC921ceIWVfly7mr3GH2OqhJL4ihS//0/VFtPdFHxWjQmFwn7i+LjJVlC/8pofvRJE0ojejn1QeTy19y9QmgD3o3VVFIM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=labn.net;
Received: from CH2PR14MB4152.namprd14.prod.outlook.com (2603:10b6:610:a9::10)
 by PH0PR14MB4607.namprd14.prod.outlook.com (2603:10b6:510:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 27 Jan
 2023 12:48:48 +0000
Received: from CH2PR14MB4152.namprd14.prod.outlook.com
 ([fe80::1292:b72:bdb6:5bab]) by CH2PR14MB4152.namprd14.prod.outlook.com
 ([fe80::1292:b72:bdb6:5bab%4]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 12:48:48 +0000
References: <20230126102933.1245451-1-chopps@labn.net>
 <Y9Oi+np1iaRJhEY/@gondor.apana.org.au>
User-agent: mu4e 1.8.13; emacs 28.2
From:   Christian Hopps <chopps@labn.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Christian Hopps <chopps@labn.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, devel@linux-ipsec.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        chopps@chopps.org
Subject: Re: [PATCH] xfrm: fix bug with DSCP copy to v6 from v4 tunnel
Date:   Fri, 27 Jan 2023 07:31:54 -0500
In-reply-to: <Y9Oi+np1iaRJhEY/@gondor.apana.org.au>
Message-ID: <m2h6wc16tu.fsf@ja.int.chopps.org>
Content-Type: text/plain; format=flowed
X-ClientProxiedBy: CH2PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:610:4c::24) To CH2PR14MB4152.namprd14.prod.outlook.com
 (2603:10b6:610:a9::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR14MB4152:EE_|PH0PR14MB4607:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fe6598a-5b08-4c46-90ee-08db0064d580
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jx7Kdqaydxu9/rlfRja1yNWLGl4Pg0flKWNq40ExvmYE8wBBi/H7vAyIbFxNiHMqdWyZDC3YeCWsF61j3B+X3O08niGtyUB0zCZkmfenj6N2ELbdsWGM/uiUIM2FLvLUbA4LjabzQ3F22l6N8U8PSbTyduSwla9CnSHizP1iPW3qbwlE+rBF1au/Jmq+/Vg5hpPD5Bnni71DfOm9qY5Dya0FgfgtD128saEXQHjlMEq58skxBre7Ewyh8CAM273RtPhG6RdUBGuBaQGB28mN1Q/VO0SDHj9C9ineObfB/n44whXvgXdg4jSaXLBgES3yt9DfBghvsDlBMJHMCU6M/ikL7ph6DBa1wEyHOEFtdGidcfg1ZYXglhrxkCIUY82v4kBeUQrfY87f/dzSMfjG/8/NhwKjgDCoow/d7qoaIn1MHW2PTJp6OtpwNUh1xhTGSvEgvN8P+n6oUT+otA1m6NF3BKEQyz2MyTW/9aJD+6fFpnIaj7piEpPhOY1uymdXvTDCmOZEPCpBLf+NMcttzva24V3Bac9xPbiUEJCNcNx5psEaIMBm5CC12g2siFTTKYpACY6C1sXVXxemMN6mN1rz2yn3oSeoPHUJW0pPeES2cQhAyKqZJYsMfS9kTJkMH9ZRMBhQRd2rF+r58DLUAd8L+svD9s2Vj8P6DLOWXhvjwedeywD0/yT0gNOo6Xyn2BHVVhwW+8yLelCP6OSFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR14MB4152.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39830400003)(396003)(136003)(366004)(451199018)(5660300002)(6666004)(54906003)(52116002)(83380400001)(2906002)(38350700002)(38100700002)(6506007)(86362001)(66556008)(66946007)(26005)(6512007)(186003)(9686003)(478600001)(6486002)(8676002)(6916009)(316002)(41300700001)(66476007)(4326008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kXC6wcpDQ7/SKSrQwJsFn7bl/riO7XAHRpbwWewyfehAesT8pejUhOInG93r?=
 =?us-ascii?Q?3hxe7W7K3YifDUmyOHut/zZl3SHX4/86Ah8McUs/Jcd3jfFl3GYsEbqoJlua?=
 =?us-ascii?Q?mEeOtr1ygImGv8J1ykI5UV6fpb3F4gsofT8gDYPjp7vtoZ/jSc+k1slM1ZzX?=
 =?us-ascii?Q?HRXz2ZjsU4x3eclThc464TBUhLJCJ84aBVN2x3tpX3dL/drWUY0yU3XjNTdl?=
 =?us-ascii?Q?s9F459KMGhdH1ndMn3J9YAm2OM6xFHLEU5VQfeUSgOjdQjufCjJu8x6u0ZlU?=
 =?us-ascii?Q?1e3BJZgyF3YHO34pK3uPKQK401hcNrl3NRB/PRXHmgRD3HCTVUGbRM+p8ZYr?=
 =?us-ascii?Q?u+Ur0zOHVw+mSo7v7Zkwgp3P4g2CfljXwUwN976G93Uz2dyMNDciZR9jZqJf?=
 =?us-ascii?Q?dFLjN4dgRVTt4ELBo/UzxG+PraKkTvkMiEXyybOhkhGDpRoZ/XFK8/QT8bCt?=
 =?us-ascii?Q?kBgGexofaIfoGCBp9+fpPcmqgcSzLjfhTOwBsFIf54PnkqZvO2HQ065frUsn?=
 =?us-ascii?Q?p9VEddSDYUz9lKoyMYF6wBejFpltJx5rZraMO35DOWo1sMEP3SVipPutPJQh?=
 =?us-ascii?Q?0FUuF1bs3zri+9/k38pV2QK5S6aMXHIQhKnlfG4leCQo3l43d9bRz8ZCcQRs?=
 =?us-ascii?Q?JHzusGSr8PGT3TaD94GOFBoDjyi43+ddri6licNoqLPo60nYt/Xxxs4rOoQE?=
 =?us-ascii?Q?Z2FkPB3fRawZITsJ4LvstmzsHeCHdcAMfiftUDMSQ27HOeKpsbCnW4BBMx41?=
 =?us-ascii?Q?BOZZ+F9rP956NYUJXiw33JS5qWweqmzO3DGxAy4Jl7XFiSaJtNGHKe7Bw0cf?=
 =?us-ascii?Q?EqCOX0T9iMg2ZW2Otjh3GuAjJivKVQuz8WMkuFnNJ44PWSDBCtkdOxKA53TW?=
 =?us-ascii?Q?Yqbc1wE4HDL2wELdSiyas2Uj7z1wEKHMH8MdSQPjVVyqOAluVRz4A5elnrUz?=
 =?us-ascii?Q?kR5mHVHfB3QaB4vCI52uPEKAfUmgygLl4X9sE6o2hI0E+q+L46GSbjl3UIaD?=
 =?us-ascii?Q?oJEwYG8uJV4hHbI/IY8FjrsWicyvrPfdWU48PV7DQNwAivmvjBqsc3Yqepv2?=
 =?us-ascii?Q?mMIBB8R5X5cIGj1HPgPwLYnkPvPUOtaKqIKMVKXqgFxLISUXhmRkgS//cJuR?=
 =?us-ascii?Q?SGpZ9hOfDZ9Ju9GmRNYVRHEO0NKACcylT+js77nVB59m8oEXmlc/EMJ+ECEC?=
 =?us-ascii?Q?vQks16X8om2Akz+UXADtXZNeHfnPBUAKn12fR+hmjrfQ0dKgWcclisIL1h6W?=
 =?us-ascii?Q?254MUEAjBAiskwjTHfbrZcjNRov4l0YmjKWI5RxX5vIRSSVtew4fguxVdRb3?=
 =?us-ascii?Q?gKznGmfYWuYIiYyqu+q6KH73kA3JyfSWajxcezBMJL+B/mOs5aMiRCha4+qV?=
 =?us-ascii?Q?SpjHVXv3etKN4ePPDSMQ0tRswIDPO1uqijedufEyFpLAMGJZECsJG+iF3Cj7?=
 =?us-ascii?Q?RAqUoJnl075wsHnHKiJ3Q2BbNFFmjh9U9vwMj6hGg/wh9L5/RszIiWe3HnUg?=
 =?us-ascii?Q?dOqw67yK+wWoahc6oEXK+DUSlnSOshxLxkm4abMsGFqIrMQxqB2YvDzkWckH?=
 =?us-ascii?Q?t5TosYcZKETT4kxHbcGy4RR34yfj0kC9stFD82pe?=
X-OriginatorOrg: labn.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe6598a-5b08-4c46-90ee-08db0064d580
X-MS-Exchange-CrossTenant-AuthSource: CH2PR14MB4152.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 12:48:48.4102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: eb60ac54-2184-4344-9b60-40c8b2b72561
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmkY2Kt8nn3DNPICM4k7oBXrnPuHrY2FztOAoXM54xayeZb5gJic4/vkC9TrOq4YNQEAEJ6EB/ggUKBCwKSh7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR14MB4607
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Thu, Jan 26, 2023 at 05:29:34AM -0500, Christian Hopps wrote:
>> When copying the DSCP bits for decap-dscp into IPv6 don't assume the
>> outer encap is always IPv6. Instead, as with the inner IPv4 case, copy
>> the DSCP bits from the correctly saved "tos" value in the control block.
>>
>> fixes: 227620e29509 ("[IPSEC]: Separate inner/outer mode processing on input")
>
> The broken code apparently came from
>
> commit b3284df1c86f7ac078dcb8fb250fe3d6437e740c
> Author: Florian Westphal <fw@strlen.de>
> Date:   Fri Mar 29 21:16:28 2019 +0100
>
>     xfrm: remove input2 indirection from xfrm_mode
>
> Please fix the Fixes header.

Yes that's what the immediate git blame points at; however, that code was copied from net/ipv6/xfrm6_mode_tunnel.c:xfrm6_tunnel_input() and that code arrived in:

    b59f45d0b2878 ("[IPSEC] xfrm: Abstract out encapsulation modes")

Originally this code using a different sk_buff layout was from the initial git repo checkin.

    1da177e4c3f41 ("Linux-2.6.12-rc2")

Why don't I just remove the fixes line? I didn't want to include it initially anyway.

Thanks,
Chris.

>
> Thanks,

