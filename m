Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D8867B516
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbjAYOtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbjAYOtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:49:08 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2136.outbound.protection.outlook.com [40.107.94.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F813530E6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:49:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyVDtptzpNQeQGmUUHzl797wHC7t73AsbrrCwd50KD9OC9mALWmK3reA1ASqCiHt0xbY6zqNuiJGb5BMMymw6A0shHleZQdYLN3/DYMQ0GyaGj5ArXUuyvR4Iad7wCyLITaGI0s9jA1eVwSulzhUCGitGIDvzbeZsrhImfdhQh9RZSyEVN6QN1kMHkTWiganE9tcofU9ejZ6XM/BgxWXGvyWX3+hFVAXLsWZDD4tFGNNt5cTR763O2/jn1cnQr/lsVdwPEjXA2p3PuaUKtb3osVqICh4cay9jbvtwdSQjQqr113uDLy2fQyRF38aC1yBxsFmO/toNutY3c+4Hx3BQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfpm73UDY/nam/6d0BO24R3NSSpDILhev0iT4gTGN1w=;
 b=fr0KwaM2q27bld9PEoIVpMAmP8U/z+2e5DP4ci0tIpR7o/WbzawzCATW2qA4wvTLDnh3xIR2p4fcPzVLTnHsItRwKQ/BwQVVMHvRb6Gvv6xSowTI+t6Nu0s8ecJIzEoXS7hBJrHJ5E/d4D9r7T/HfJwkhse2bPPMW1xV7QGKhudz3iNLNQGSEIvRKppe4AgBm+UJrLlKfkA7sbmdTlm/uWxDYSeWkA8i02dpSnKkJ44BFPkgswWgIh36jqYhlyyGp9iJf47ky61yLMWLRceoFduZNqs+5DJN22rhvW7eQkS72R77e+TZFUQjWIr5qfn/CrkA5EtvbWs5YVu9plDKFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfpm73UDY/nam/6d0BO24R3NSSpDILhev0iT4gTGN1w=;
 b=KLann+7M3NYkCglAY9kvSLMAga3xY44VgyQMiSnTXHEvie6io6jX+bb71tGS/fe2lbO2KKGlp3PFpRNW74X/6rmFea8KjHpnfj2qFnk+hY4TkpuDjNbZpYuuXC6+8h5g6mzpsUt++6ixG83lzN1Rhu/I8dJzboDnrruft3l2Z+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3869.namprd13.prod.outlook.com (2603:10b6:208:1e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 14:49:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 14:49:05 +0000
Date:   Wed, 25 Jan 2023 15:48:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sven Neuhaus <sven-netdev@sven.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip-rule.8: Bring synopsis in line with
 description
Message-ID: <Y9FBWkR3TjuV9ETZ@corigine.com>
References: <2d32d885-6d27-7cb9-e1e6-c179c2f4d8c5@sven.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d32d885-6d27-7cb9-e1e6-c179c2f4d8c5@sven.de>
X-ClientProxiedBy: AS4P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3869:EE_
X-MS-Office365-Filtering-Correlation-Id: ee4a4aa9-b57e-409d-977a-08dafee34e9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yw+xP0IhT48/7F+M2LdmaZnTg2lRV+Q/ADA9zknJXi9gJ14iURGIwu39nEGLQzgTo9iW9r2INzY4OL+FQc1bkXGdfW0VXMbPVxU6xvtqczrZYFqOGsbWvspHxtjKQjZSN9aG42uUde7SsPPpC5+SlLVYx8VHjMDE5GzegcZlAtUhx2Eg6XlkGOszzDV5B20Yay27qmCX4EH/jmnLtcNl5ty826/Dy+PXeRhptb5ZzEI42FoesTOWUthXrfSSTeZyLWfgNaN2xQ1W0DVGaT7yLhg/miX3w3AC9zEuInsSk5PnD/w1SAJYxkKF/nVjeTzGGOwE6xIK0q/FKXEa3vyGFuF2+hLeeC7bn7tTaCgIHkbV0TyAFAPLAnV9aJcoPP+wnhgVkQf2K+yu8e+NgBZF3evhre66uNDd5L/b9pMQn6+qltyrQA/901CJHcee0l0OQ1Xv6XMAuTwUzMtS7dW5SCLfhU/Bn72TgsxLkL82JboiVIdSGYwHD+fPWHTSfCx8Ash1+2D02XgA78yMvWf0mesdeCdbj1JDDCRUSpFrXHNnzSu3iZPpQJ9F7j80AzaX1+6DrgwnCJDilNBmzspKipPjOuUcbI3MUVVR1RJoAnI3QKGo0LHrm5pWoX4KFontQ/PQLCOg0PirhRcuP0BMJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(39830400003)(396003)(451199018)(83380400001)(6486002)(4326008)(2616005)(6666004)(66946007)(316002)(8676002)(186003)(66556008)(86362001)(478600001)(36756003)(44832011)(4744005)(2906002)(38100700002)(66476007)(6916009)(6512007)(6506007)(41300700001)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5k7++A9o4iqprgpTSB+EkNcNqcIOcODxejBS21/GQRchvpZTiFtpJJprUINY?=
 =?us-ascii?Q?X8zlSP0Rc5oZPlCY6IZU0LHdHZ2HtReBTow8bE169v1ZKqgXvKVxTlXGIvNf?=
 =?us-ascii?Q?P+KVoPNRk514lrownldtD6hKAJ1EwMiJiVsq/wWtKqJElUFRVJ4Zu+3ldl4l?=
 =?us-ascii?Q?WSEGJAAVmFmaTiji+0sVwpf85GgGjsP5WzyPD8AHB2Q1Z5WZ9p16vQ0917AA?=
 =?us-ascii?Q?2jBUMb9WA7kdFqHG4nNa24QzF3gqWhkDQsfg2idqcMw3MrC+FofOFTDczZbx?=
 =?us-ascii?Q?3MoWMqmJYSFy6I14PQpI1w2DjWTHpvewjSUUynIrA0mOcgUuud3Eo19IyKVI?=
 =?us-ascii?Q?dQyiy0v2BjC8N+SOeJjTtz5j8PU9BqX4bIkJM4jWz5G2ianGEcB/TtrIrXMv?=
 =?us-ascii?Q?NbgEh9k6OSs2i+rE/saGFiVKu61DXzoSsZoagwXdQVrOh1eSC2Sn46paelHb?=
 =?us-ascii?Q?pm7HqsOd4BiTb0OAACRrHXfmLH73C9MvXliSjXnJUdrezHFk0ZnO+FqwBNVc?=
 =?us-ascii?Q?VoV+hWer2jGJjkbFT6sImv3EOKOmlDWA6Xdf3Tg840G72hPoTVz9RTjV443O?=
 =?us-ascii?Q?l3fV1SWfRm66Evkzn02KFnxmNjXrwvAQuMEGcZlH9WjsXqbsQFresmDsxsD5?=
 =?us-ascii?Q?wBqsREOJUEueZAnJP7BjriaGZXdx9CfOUlVFAXUH5NGT6Jg/5QY62J4qIJkU?=
 =?us-ascii?Q?5vbI6/clngzFgETwtSO/QMixDKP2toQP4bh4V3vnU+pKY4nJRXjVGRfu49qz?=
 =?us-ascii?Q?WgNyjrCe4seN+RGY/nXbqRCqtA6rJ76dK/+v2vCnXgV6GYWSYTzGUrjsdSgj?=
 =?us-ascii?Q?1NbL0ace1fM5Cw0GGANa6XqpFQYJXS8mAr9ZAgd6y7B6NiC1TCPgvvVKa+dr?=
 =?us-ascii?Q?4T1DXT0KdIAySXQcphr7JNKasoNHeCBWL/8RELRODe/bezKYCtgcdLzEKJZ7?=
 =?us-ascii?Q?J2TTYKPa5+S3F6NMivyX/1JwpeGv0WWbG7p+q+WOWS9+LYy4Gd3nfJ6GYQOZ?=
 =?us-ascii?Q?1kdMNV5w6qpyMLMmtVZPj42g8da60cbsZO5miRmciblljzwV4RLzuF2YKQzI?=
 =?us-ascii?Q?2KdNoqmYXH9ZrJgY5tJnMyWcSLxQnTDjBjsOb7BYohI/1SG/rbT5sRVHi0/R?=
 =?us-ascii?Q?/uVULNwVRvPG1OMQS/cZ8Lad+Vze1IHGmL+jzWr36pQh+Wu9AmG6o/K0zjW1?=
 =?us-ascii?Q?T/JtIHL/u+9mmDP4e4nNzLUjUvSiACfIZAzoiRUpWoFAW4gR9eM6mmOqN0qk?=
 =?us-ascii?Q?ml8l7Z0dl26ZCyPAQMWF7qkEj28ywtzu01CdwSSXV/T+y6WNdwhVqidfPj+7?=
 =?us-ascii?Q?U++J9PScb2Tbp3+ZsLjFpt6AxrnSKnhnGL9MQdHk2Bc2Kj0wBePf7Uj34RKL?=
 =?us-ascii?Q?MfjMQCzqS+AYPtL6h5gyhlxDJywXJIANVZG+pEWqXK58a8ANktXDelrMxQgL?=
 =?us-ascii?Q?XVnpWuW6ef9pUW9ygzSEvqxYr/1UGC9O1eX8pAI9eyukKFDvnUKiaWHBVigV?=
 =?us-ascii?Q?MkkPQ78Gx0LBDKK4HVfe1CkqZ0P+j7DRJagLvUk4S7zosJ/2YBiO1eB43ESF?=
 =?us-ascii?Q?Mic9+mANhRKCkmq6U+jV3l/lVjTRSwLZ+2qtDjne516MsUgSeBY3QKPUakNu?=
 =?us-ascii?Q?iinS0rUFf4yuwjr8EenDE7ogi6q09Xejl8fm6FlIccW8ZFNBJG0E5eNxH5Du?=
 =?us-ascii?Q?JzyFxA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee4a4aa9-b57e-409d-977a-08dafee34e9d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 14:49:05.8684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDQpA8hU6pyzF8D6jdBZmQqm4xjUY7TJMuLjt8nE5G5VrQ5ASZHSpDNyrCWA5vBOrAk6688uMBCrZ7T7VUWBuwhlSO+KZfWyr7S+JTwPZvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3869
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 09:20:22AM +0100, Sven Neuhaus wrote:
> Rename the option "priority" (with the aliases "preference" or "order") in
> the SYNOPSIS to be the same as under "DESCRIPTION".

Seems reasonable to me.
But if so, should 'list' also be updated to 'show'
a but further up in the SYNOPSIS?

> diff --git a/man/man8/ip-rule.8 b/man/man8/ip-rule.8
> index 2c12bf64..43820cf7 100644
> --- a/man/man8/ip-rule.8
> +++ b/man/man8/ip-rule.8
> @@ -42,8 +42,8 @@ ip-rule \- routing policy database management
>  .IR STRING " ] [ "
>  .B  oif
>  .IR STRING " ] [ "
> -.B  pref
> -.IR NUMBER " ] [ "
> +.B  priority
> +.IR PREFERENCE " ] [ "
>  .IR l3mdev " ] [ "
>  .B uidrange
>  .IR NUMBER "-" NUMBER " ] [ "
> 
