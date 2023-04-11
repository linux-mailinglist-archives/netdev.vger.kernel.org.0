Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0076DDFDC
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjDKPoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:44:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2101.outbound.protection.outlook.com [40.107.93.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69C02D41
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:44:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ndp1nMJNQxyY1SAJaKjk0Zw3Xuzz0hjI/BYttYG3CIhHLs8bpSULGfAqXSJP+klitRN69oLOo5Pt6ZTgl0sfxuArzuUnsgxqZGUmppiugU5SMVYW38S8q8y2e4T8BvVnP8YwASdEjqfslWvdUmh0fcF/2lUUq4UTXHCJq/z9P+EFfN+9mV2/8SIUS/0m24L3s7XeR9tf4yxMJERm8LsQISaif5EVjwXFDr8MCFGWL0f/MTHJNmgJje2mwspO33pwyrtYqrZ+gFKwn2/t7T8JANK47TZ0u72f43UMVWYFVyITC7/O6qs4bTXYmuCQufr+kG7+Y5ArObYgwrB04Kkj2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2K2sh2a9o9DaWJvvIGKLhwZ+hxv0aIn1zehnOlJBGw=;
 b=gQtd7Bbwi5gMikn+XLS62J6OMB/ObdXuVM+IwDNOuKsZ1u/yERGv+KaXM8F+6jQtd9666h3Hr2gpJKNZf5e9LSpNSS26hewbjGHDBeKntLH4ogxGYak0a8TgbL8acV0H9ON8RIykptjgVj++QcT7uA+EDqhv125c60JtlnnJ+YbMT9wswLoo1mxYdgNf7pFtJBw9EBARM96aAOabYjyAM6H08K7IIJsHItC1pSz9Txo9BqIAK1zZu++ojy40OFKXLgNo+v2UUKnTeFCwCgLS4JoFV9m0RVWbfMFK5GBz8XewH7sml9hY4dOdumUoF0BbKqYGT6BIwGMmWgwwDrsEOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2K2sh2a9o9DaWJvvIGKLhwZ+hxv0aIn1zehnOlJBGw=;
 b=auumnJNeoUKT+3KiBOsUPEMCYjoJkkZOOhLwHhCzGt06ED2QkZ1lNjYWQ0X9jsDLjxa2dSauLiKBgZnmQRG7ZGSjLQvv1M1jJVfPQrXXpa/wlsgs37VjqvVOu2bkrXeEU3kJK+COchI2Jv6BAKDxk2puf3Fu8us4Y+sRy+oC6Ck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4940.namprd13.prod.outlook.com (2603:10b6:510:a0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 15:44:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:44:39 +0000
Date:   Tue, 11 Apr 2023 17:44:31 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <ZDWAX3KKRmGL02E7@corigine.com>
References: <20230411130028.136250-1-vinschen@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411130028.136250-1-vinschen@redhat.com>
X-ClientProxiedBy: AM0PR02CA0215.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4940:EE_
X-MS-Office365-Filtering-Correlation-Id: f0d62caf-3fe1-4119-9fae-08db3aa3a8df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXhBCa+HHANcAd4GLKxj/xCQE16wCNKBC/qSgMsJx3EQsG2zxcOopH91AMTJwE1/9CNhsC2w5fi2jcmLcVPDMix2DKG1K4Y5XHrT2CNhMW8ZoUgsXUTkRRCc4s7sMWRwMBMkBqUTuN/tC/9bwCzakCgl9zB63Lpd6n4DVLvXnG1EVxjO7WL6xInM/WWJ45BWx0yL/404cwyz8waD1nLfSMsQ9qcjsiBMdBouJBQLFiymT0vI8wq8dLcoueNCjV/4eyVEyKhvuQ0yXWGM4fqD+jwp70LPWGdLGTqWwXWUIKn8XerEvplAPo5c3eizM01jgI93EwIvIcciRhx2g8xngSeRX2zR618r28JLtXdsyqilbIHmu+wrh6ZogpeHZlWe54MzKleo5d+Z+SJMmTRQukL81Qsco4d6hIHIvBunWU+1FnI0oAmXzwfy56pX1e8gpo8MZ0oKg/GxoZS+UQ1QW0E5NPnb35Bow5rTlP7zPtj4toFYH4BEVUewOCcD/rvByXJTIi7PM9RTfuxr6bxP7mprk3HQgLxi1RBqQEfsyT8FLp7BrVDtZD2y73yPwMq+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(366004)(39850400004)(451199021)(66946007)(4326008)(66556008)(478600001)(66476007)(6916009)(316002)(54906003)(5660300002)(44832011)(38100700002)(8676002)(41300700001)(8936002)(186003)(6486002)(6666004)(6506007)(6512007)(2616005)(86362001)(36756003)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jPlhftdtFBEnnAxlnDR3iCV6uyjp/tdJ0t5jv6fIkJAXuvr9G+0EKhtnLlm0?=
 =?us-ascii?Q?Kz5SQIi1ywispl4MUMvYNlKUJLmu2VeqK/6he9A30aC3tDSfO2YeYZlu7ld9?=
 =?us-ascii?Q?xoQdxgOmHgFmhinx22uzQGyGmLLolqd0+YXJB6erwTfzGEH7ASKMjjYVvya2?=
 =?us-ascii?Q?ipoUDAb8cpDitvt/hhQD4L6IQCTRoqP8C59Ku1JUa3sRu46wwQuT4u34J+Iw?=
 =?us-ascii?Q?jrimuUyLNYzR36iK3mopNxrnO6dodA/Ck2WBY3OnMKuSuC0A5v2mIPF026+v?=
 =?us-ascii?Q?wE3AJp91s6UyHVVtospU65dyxTK1PDoAMe3ah0fLQGY1nAdhJTFHgMqW/CUm?=
 =?us-ascii?Q?lEdVZkFItUm0fTP7seu/x9RRrf6/vYck1EhUYRmRYDZQUuw6e0j1sWCLIeCx?=
 =?us-ascii?Q?Fr8yFhKRurYsnXMzMNCJG3W4UuUQG1vtSS882JnRAufgIWiiGKWe9WaTSQ8r?=
 =?us-ascii?Q?nXk0+IDgv1ANno9+ZR56Kz/UdZsd4gn1fxWe+5haBIUo1pnmqG4xhmMx7Hbg?=
 =?us-ascii?Q?pX416AceDTLPwUrLK2ccwn2TC2Zwm+A/bWtKnb6Zljf7fVn6ERv7ImlugSnd?=
 =?us-ascii?Q?ayOdP2BuIduCgDh80tuV/Yx8tLifUt4p7y3BiZVt7AG85yJvLB+THF0nIp0j?=
 =?us-ascii?Q?fKOIU2yiwgkhb0LT/ZBPqGj7vxs63Y3umfwpeer2nfgmJUeSP1hqFigdDSk1?=
 =?us-ascii?Q?6YiRhrIvahVVHOAemW/GRIeFiNqTuxWhjmeVK4WwrIebrdU1eeiXMYEduYj+?=
 =?us-ascii?Q?CwgK1+gkHRNzfxsZ2WLBXrfwbe8R4rXFmt7XKVsjtBlB9D1BXzfJG4wjlYae?=
 =?us-ascii?Q?aqeQgOD7cjWTmRgVYZ/nzSHE0nd2G/Fxdw6S4sP9RtE0tNxnZOEqXVOovq+x?=
 =?us-ascii?Q?zE0VxbxSRzExcpBfP3vG2u7YVq2V2nK6SkVNQi8RW/7inCwXueqBcxdkwvBo?=
 =?us-ascii?Q?jiDDdCNkIWbPlFGm9wFZ1w2dpZgdOSTId8I4vmgwynEkdvyoaSWniaIFYHXA?=
 =?us-ascii?Q?D922fD9bzNbdR/BzjXq7M1EEsSJU1nbMX79eszzkjuYyITo9KTKVo6fxQ36/?=
 =?us-ascii?Q?6R0fYhZYYiUAksoL369e8Kem0FDPQYoe6Qt8uUkIlezhnSAYew/TvvxgO8nH?=
 =?us-ascii?Q?1JiSpPl1QWhcor+LnNCLmPrKMcDXGbX4+g5VImN9lqnqMMLvT65Z4G3k8hjt?=
 =?us-ascii?Q?/tHXXRZScCMaYrrEBS1vZXHk/yuzwHMksj2mK+S6SCJKRQhn7mOXqYuS222s?=
 =?us-ascii?Q?djKng+BQ20G0TZ0VP3Apkf8J18HTgvsXpIgvxOWX7ZbmXLN0JLs9ycmJqOaA?=
 =?us-ascii?Q?BM8Dwj6m2IzDq89yZznr73p9EDv4nrgpvbR2xYKt3kLRqR+eoszHrZm9r9bl?=
 =?us-ascii?Q?8EJtnOvBb8kpnPrK5B+fNYYfOOvvZzDBZIyE6zvn57kgGlwzKNzZ6yVPOBAP?=
 =?us-ascii?Q?4MM81Nf7FvhxWh3B980bPMer77nUtbQxk9HqzsyjXF4oM8jPz/weqAqfeAf6?=
 =?us-ascii?Q?1LTCx0W/CneV7X6KFvXmRix6XklJZiE/TlIio8/TDgXoKub6ydeKNE6ThrOO?=
 =?us-ascii?Q?yNn+AziSaI0PuSO1zqMuCUhHQtJ0m/mocHcnvTQWuKt2QzcHFC1eae3bOj1x?=
 =?us-ascii?Q?AhkBAlBSrwtWo80IULE0vf6e/iIqS4vyLpg58u4NqK8EtKR52Cpr85DEK9c4?=
 =?us-ascii?Q?HL3v9Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d62caf-3fe1-4119-9fae-08db3aa3a8df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:44:39.3610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/G6BwJ3Fb/ChuV8+9BLdJqKU2+epSK22R1LTtHSVXEZqBQ3OMppuX254CRGMOAZDagIXH2cvpQFBWkt6ryWjLT3Oa5o+zYE8NF690/OQl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4940
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 03:00:28PM +0200, Corinna Vinschen wrote:
> stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
> like TX offloading don't correspond with the general features and it's
> not possible to manipulate features via ethtool -K to affect VLANs.
> 
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

