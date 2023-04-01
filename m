Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13A86D2F2C
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 11:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjDAJIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 05:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDAJIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 05:08:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEED1DF90
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 02:08:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQ1qfi/5fU7ZbsZiUtUo0OUNEjxZ4uW+J2MndEHVbFjJjUSOYwv+vaiL3khZdEm3k2s2f370H/wkbaGQXhAt3iJXcncMQrxducfXUR2zvEq5LRFBJC8fb3/7PSiH+JOFlc6PaIilDQ6JMxUi0I/Ckl/spskRrug+NXkDKixRRy7nxaSx8KHmHPqBwyduPtsusYXaEZ/lWB6u83b70wMAeOMJH64X1ROCLsqZ4HzDsdLfSnHNdS1Q508qzZIHk/30VMqjhXv40uUrBFjqERQcoSO52TO5HWnFW8TfwgEkAWRlAl/tR4c8TkX2bEhuuO+vrgu/udPkm+G8cgYkMH88XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aun/A9bDRC+qxcX62Oo2jFi0wTI+2QjwviMa9pC+GIo=;
 b=iyVQ9pGMbMvlIdJCZd+gMad/L6ToCWOvjP5Z8o13I5lhrvdEfMQoMKaNDFeGvFi5nEbpBHJ4Ku0co8CHYrIs3kfCnzzdk/53AGLDUlxTpGHxVwEANYSPP/9xbLrhzSLgrHFv4fX5PMXwerrsDNOMaek3W44y+AeJO5LNhL8kQ0jjAKkQ21+XbRONG/dxBLSPOxrSOqp4c47E8DXLgZwxwy3x6NU8VNDLWoovG3RoMn/3chgUewXBJooV5SfviA+b7MOweiwuHnjHqlYDis3/qFglbd0sQ0CPrJQhxTLq8n0CeKQD97uXfd/+60KTSFXQkj5y6QOQ/T7pSky0xTviOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aun/A9bDRC+qxcX62Oo2jFi0wTI+2QjwviMa9pC+GIo=;
 b=a+cX0uJz7dIgGpbpXpaCnzoRO69adKadGIuOEIm5Iwd6bL+bqIJuJaT9Dq0r4ogxlfohGpDuAR4JMiWqxHghgTQzuH1SXWoWnari0jjNlP5cEChMfs1/arEzCckBGEcHUn+ZFi5oAW+fbn8WuYChYxIEkCgf/Hc97trvI41pQWM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4720.namprd13.prod.outlook.com (2603:10b6:5:3a0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Sat, 1 Apr
 2023 09:08:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sat, 1 Apr 2023
 09:08:33 +0000
Date:   Sat, 1 Apr 2023 11:08:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH iproute2-next] tc: m_tunnel_key: support code for
 "nofrag" tunnels
Message-ID: <ZCf0i0jWRZOycW+V@corigine.com>
References: <c43213bed30edfa0d6fa1b084e4d48c26417edc9.1680281221.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c43213bed30edfa0d6fa1b084e4d48c26417edc9.1680281221.git.dcaratti@redhat.com>
X-ClientProxiedBy: AS4P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4720:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f82fe00-405c-4584-4c07-08db3290ab02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TlaYVWM2EL2heNxat4FcZjv+H/pagwignGhdN4hKR4bDDG72f1AU6ow8NQcucILzX0DAF5uMZGr87Su1nkEAdNf5e6X5sYfCF+zPa/99HCPgJwO+jiOhZsPPRN9qJDBLXXHVrTKThD5IDbW3LfmmVdWb+cYjSL/56mJIMtNCLodPO5Pixu0l8fiN35It3hJlkAzfZoUoOXv0cC9LzsmC/nWA7ZddDQau4lICY4IpX56rwwnwCVYYzYZxvyH0bp9/yITZF5d25bYST29Q//BGsncqr5AuZvGGJPM2aRaSvOCkohJQReGI0TkOEW7rHSewi/6Vv6v50FFtl53+wIUvXbXkEYJlkqbftP/KfcOujgBG99cWm1YaxGI/cAONicY07BN6Ud2CKx82w+9qS8w/y0KOT/6sgAnviCD6QVI3ImR5LWSg8GM7aKlwDxx9JYLmPXzN6ZGRlu6dCb4078uh8uIIsN59kPCJZub1W97615NW+BdK7hMsU9TQ6J1eNhnXFY3VivGEfcJmezpM/q4LrszjULzTV1RjAhZAs2UEhFHWd+bbEGgo5M5Qb9zh96xW55ah0Uu99BPOkRnRYDIZXq7ZnmMiXALt3wcX3xD6lUU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(346002)(136003)(366004)(376002)(451199021)(6486002)(44832011)(8936002)(5660300002)(8676002)(6506007)(6512007)(558084003)(2616005)(36756003)(186003)(38100700002)(86362001)(41300700001)(478600001)(66946007)(316002)(6916009)(66556008)(66476007)(54906003)(2906002)(4326008)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jwtYEonbAdqexNpdgaE3tRSEJWLbTharH0RNK0Zz8SlLep3XyKaYSeX1mbWj?=
 =?us-ascii?Q?oBynA5XzU12NlrgbkKhAyQ0hhn9HEbaP99xfayvcO17QtzV4MsUxxzw0+Oox?=
 =?us-ascii?Q?MVrmtPYAXHUniR3O0utzG1Uuu+CfH7l6gNUxJX2VUIlQuBxIMk2VoLsQDr2G?=
 =?us-ascii?Q?Wnc4z3+b3GmJ90wbsqrXe+bvijg/IDewIMxbL/9QPHvwwF/YyM44y/aJGzo4?=
 =?us-ascii?Q?7btG3etU6rLxqNnK9SKA4nvlEf4r/+e0Dx11UFioUMcjo0BLj+7Wequ8SO4H?=
 =?us-ascii?Q?7bDLepyQW6I5uI31MZf47h+291kJ2nnc9lK3xByrbhAjKoILXTeTQbpwoFXX?=
 =?us-ascii?Q?D07xwXzEFgvDeyKAuQZSaqD/2yc7HN/Nwt2dTt7KPaIeT8VGgRtIcIYuBujI?=
 =?us-ascii?Q?TMN0LTMYqb4itoKamisxnQHoTB0blUxnSKmR20F5LBxUV8XsfZ9C3Mo91S9t?=
 =?us-ascii?Q?Igy6VUdRJOwVAOvYYdcJHYTnpuHAAUkFwEhiyzJz/X/erak7Sw/8c+ntvISo?=
 =?us-ascii?Q?GnodIewsgcnexbygOgfj85b8Ijg4zsWs7Hhc1rNlxZMLZ2CJqq6HS3DympmV?=
 =?us-ascii?Q?qVzb+oGLiuaREFvN8HL+lRh+0vQlFRI4CkVQhWdgGfKpLgSpUlX/KzRyCjjF?=
 =?us-ascii?Q?qMKSlfdne+uisi8hCrpdQfJhSU+RCXgUWFMszsKYz4GFqHoAUk5mLGEAqhdG?=
 =?us-ascii?Q?yleYnv+WlfSJbkWqwCQSwS6t5Zgv09Wc8KXGzpJUDGxD5XSPC4qq8LgTwvT9?=
 =?us-ascii?Q?CwlgvguR3h/fsaqThfK8LM3NJGHHSfccGgXVsiAhg5jKs1BW42wPLtY+Bojd?=
 =?us-ascii?Q?EhCGvVKVt0c8bZ5tL7HAiiv2VNKSRDzvJO5VLnIyzs++a6sllgCKoNy5O2J0?=
 =?us-ascii?Q?XbiRsFC3VA28QyBgmtxSIHfBCxedkIUG510j293dedtz1ozaC5PAgApHt5Px?=
 =?us-ascii?Q?9lYHAaJ3Ot4+3N7UGa1AfTz2ozllBCifUpWjcabE1o4h8a5LagrjuapwpoCx?=
 =?us-ascii?Q?cbxPkKuWsq4EXsvdHwVqnx1/joJ2tssBaN06sIT+jmMMB2ClTt4PzdM7ZLPQ?=
 =?us-ascii?Q?Qwe+n2sVbTA7XLuulP9yQSSpyC+ag/Xr0otiQiK4bPqiRBhDj10g71U0JleS?=
 =?us-ascii?Q?6eFk6xg3FEmNTpR9dqjIf6NYDf16KkCiweyEr8SWt+1V80YKo2wNnr4s9jzZ?=
 =?us-ascii?Q?M+cJnOel0mBK0xjenDlceZPrV5ES5RHF/ua0aQbtOWchjcFszzEbk762duas?=
 =?us-ascii?Q?t8nFTc/kYR3Sczv6EiXnJQ4Cact9IcNYL7PKBzhAZray5ytu9TtO8nyEMT3b?=
 =?us-ascii?Q?wXEsbdK2yZiBJkSumuoZcN8JAieEAg35Rpt1KpkgLSqWt/cf7rtgzJlQCogu?=
 =?us-ascii?Q?1yoaX5ed2fG0hGe4M56XCvjS/qzQcW8XS6JNQ3/IfxGpGfHlgtJjBAZHz1Iz?=
 =?us-ascii?Q?HEWlV6I6BA63ZM0fayT+2XAiiY91dudiXFsIPNs/EWy7zbxq6Sk4OtNOD/Ce?=
 =?us-ascii?Q?0InGpyT7MzTl/AJWGJM5Rg+tJCr1PYVfblKCui/6MgaiYwrhFfHv7hiOU6Kc?=
 =?us-ascii?Q?RZ1yg1Ksqt6rfvt34zxVUciCaJI0yHl9PCvJ1ENX9d94NZj7jXK+WaoIRjmJ?=
 =?us-ascii?Q?POaVLgy3Nh2TbCF20acn/s/Jn/lYCwIj5Be7vLwvFVF3s93YxWj6DaJikyK+?=
 =?us-ascii?Q?lxGNtw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f82fe00-405c-4584-4c07-08db3290ab02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 09:08:33.0775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRUMf7W+MoKdxdZpJZtGE9LoxDmrH1FgjgTtwstjIOGd6nHi3M9MRHky01aPL3NbfQsqVmY/bHOFA4UbVDNh485vNYDxhm1FYTFpvyUcnI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4720
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 06:49:03PM +0200, Davide Caratti wrote:
> add control plane for setting TCA_TUNNEL_KEY_NO_FRAG flag on
> act_tunnel_key actions.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

