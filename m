Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97606DC52C
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjDJJiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjDJJiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:38:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2094.outbound.protection.outlook.com [40.107.220.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B5F271B;
        Mon, 10 Apr 2023 02:38:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnkwiVXF+M7LL8XhI/Awb6QSM302ZU1grLKaIx8DDPHIhjNJRNIFfzVkU5ONmrET7+2tcja4RLm/ZZ/CIt1EooDOEeMhuzw0+5rodkOVEl1b0gJMo6e+Ot2Sw9q02oXVoeV5Nz2tlo/NcRF4HrJSqzU7SKeVcWXKMb0sq2Ywa0errGMMXAVw2JH+uaoM5krUbPjByoL1iJ2h4QtMvN/HRfCuAoV2Khtw6aaj+BHv4XqZUob0r3knMiN6b55SHdUvlf4UBC14IjIhE4ryymlinvy1AJS6FAkbAGEVOdeIA4AjGtMDKEuWIJ+ofcn98VFgOEf3UFHSms/DA0iQUPZ0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LF1fv9mfW1J/O3eOUhj8tLr8c8pZl7pZBspSbCGxAxc=;
 b=JtU9AzQ+6n3ZFqSTHKK3+jm7fnDlO1qUU4XHx0YpLRCUcAT84H3jaeGW9sNW/KKQVciFM4v7Tq7+G+TGFELI+BXMI6X+tov6cy3PkljV7zjMkI7n27j3yHe55UXUz0WBechOgmChYCLWMtsHuk0mOIHZD+oViTebg4PDQQOMt0NRxGWdXQfjNN1QP4aTlpMSju6r/a0VVaZ7PdGR5SRtJcRnRArDDdZ7awPOpHJbOkVkQdDRH0aFhYkGw4jXPv5RMqK1HOKD63o9AU/TsPR5z/oA8udVRKd35RM3QeD6U8lv7roW68WwQXruF26fzjhWJ9x27AYqoIp0JpXigPAIZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LF1fv9mfW1J/O3eOUhj8tLr8c8pZl7pZBspSbCGxAxc=;
 b=CLJQF1yfdRn8zvMxJFC8zGVZogE/5JIVSbdTtqaiPpKvYQNkuAJk2YYGMU3Dx3rFvtLor7SwMOHV4OzyLm6t1oIWRX6wMbp/1TAjx6Yuy0iQ0UQQ/sMyckZCEj2ijTkjukly3EWYcbQ9dSwgVXXpRdtgKuTPS0P13ZTqRLkD6WM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5900.namprd13.prod.outlook.com (2603:10b6:510:168::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 09:38:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 09:38:04 +0000
Date:   Mon, 10 Apr 2023 11:37:56 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v7 0/4] Introduce PRU platform consumer API
Message-ID: <ZDPY9BPr6QhJbnH+@corigine.com>
References: <20230404115336.599430-1-danishanwar@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404115336.599430-1-danishanwar@ti.com>
X-ClientProxiedBy: AS4P190CA0039.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5900:EE_
X-MS-Office365-Filtering-Correlation-Id: da84f250-856b-4065-d1ee-08db39a74839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sc3hNr5LTrgsBVwT62Qj2SFvffBsiwnsW4UyUaXBD/+ep6lKOSgUx/Fm2MwVHrSlwUyrj9UbcDHgy3TW6IuuFQ6nvbrWWk+0L8erhQYHdSumqnoZWODLPfLNOEdfqXbNgR5A4BaPXc5rK67VwF+XdlFi8cLaJVw/EJcyCkrQZFYGEeD9lNJ7P+6ZjeNiSfRYIirpmVuMrZ+iqwpehnmxrvrNgH64L5Y/0+V+3Zdy3WExddiJafK9fRLaDCSoareruEr83dJtqaebqw3WeAhQy+eTtY6TkIE5cyaGGRa9rbpO0rvkR0aM2j/7W86i3YeFdv2Oi1Sl5RFFr7gootjXuWyoQA5qqCgtE0XoPjsq+o/BGcaRZLPfJ6E1XGF/Gt67BwLV4yoar6ei5v2ojjiR4ayk6K9ffDk4DA9xyyJNSjlZePtN/ybn3DJUPOcSc7EhHvORG6ceecIYf8snVEhULzERZWcxEUTN/lhIG1l4VHHtYw2xm/fvV3DVe5upKQfKKwVOONNMayzgiAzIgL/xynOrL32At4SzFP3qYo8Rwm3EwxON4LV6JEfum5KNWJPwBIVmvvLIHtzJHJ84B/i7byLfhvpNKI1pwWeWH8Gx6to=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(366004)(39830400003)(451199021)(66946007)(4326008)(86362001)(316002)(6512007)(6506007)(66476007)(66556008)(6916009)(186003)(36756003)(6666004)(6486002)(54906003)(478600001)(8676002)(8936002)(38100700002)(2616005)(5660300002)(41300700001)(4744005)(2906002)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JbuosVnZ34Ksa2knF1x6KoXZgI3k+sCHCDGjeASplVAHngfhP3EWZRTBKs5U?=
 =?us-ascii?Q?PuKmK4yRQqcJ5Fjdr/m+Ffs5cZLvCJE+116GufL11lLS0X0pKQycBsxy5n7D?=
 =?us-ascii?Q?1iXFQO5xvbt1XfiLgHhdJQw1vB9U/8oVpVO/+EEeyQwnWWO9CPHEVAN+KyTw?=
 =?us-ascii?Q?OlmueI4GACT/79rk67czHqtu4QckoeafEB16+lSjSa7iDHcwani1HqUM105S?=
 =?us-ascii?Q?7RHuQutYALdbzzTCtmKN07DpDb0Q2UWw9ZyiIBQwwcBWT+izdzcxvaxZu2cA?=
 =?us-ascii?Q?nBEvQoLy5UwCfIvthtztcr0bcUDPGPRakE/VfOilCXMmpyM1HYpWBKifrEw3?=
 =?us-ascii?Q?Aj5kd+IJKpInEPG6UhS8DqBkms4+pMbwEh/pX+n9gT7yO45LXWo5W9to9wGA?=
 =?us-ascii?Q?qjyhWEzORlXlbiHZQc202oecUsPsgWzGGZJ2i+/KlpHW2MPTbrSXRD3chLfn?=
 =?us-ascii?Q?m9v68w4IKWa2OH5ZvUa0eFKL/Z4UqMLcQuKLgzL684DbCmMYT33tpVON6FKJ?=
 =?us-ascii?Q?SCt7FBsIAkH7nfrkmAfkZMIBigwynx4XdQc2p1KWeaaD8hIUrlb3uQnUhJsl?=
 =?us-ascii?Q?Dx7wPl0oGm6ytmoCBJrlaeHTEqtsWrR64dq58sIkeVH1QXOaBIlg7k8OXYwt?=
 =?us-ascii?Q?MCRvetkayJLt78mZjOiJun3UP34JGX5JWnceaicDMfZWPU3uMrekj/ggAnSr?=
 =?us-ascii?Q?L1TM34EyvK7GE2Z76its0pZln8zJHYfoA705+SSoB2PMG9A0o3HKCgd+7zzB?=
 =?us-ascii?Q?CUNczBQoL2+Ii0j708jfR9LhrqGJd927FPnyt6fAizwDcP7KyhJGhMAzwo+h?=
 =?us-ascii?Q?ljQ6BJmFWX3mzIFKtLPYTJOo/8FGRbn6bfU6bwBJeEymNK+RzA1uJ9aGalBJ?=
 =?us-ascii?Q?OZHCuT6T0OikFHJg8BcKlx1O09ENvCoKtRi5gTrwoO2d3hvqOTUDevI5zXW/?=
 =?us-ascii?Q?SlPADxEVET06v5qeTrT7cI7iZ/UVFQleKEWOkwEn50+Ijdu5QGY6NVb1k7yB?=
 =?us-ascii?Q?a+HylMuYVNLIHhc8+qbSSkFAstrqEIbEUq8NsMtc4UO452duuzLwKxHuHCgm?=
 =?us-ascii?Q?yKmdq1zRav4+IR3VHuNONWXC3Fib/EALhvIbCoQx9UaLsWM9hOWZMVkjadhD?=
 =?us-ascii?Q?I94TrssRkDiIE60MlsKl723OkdDCmLl4fj9C2N7WTz3gOjrUooggCVmKGgB/?=
 =?us-ascii?Q?jgr+dY6FBgag7fHC0P3Y8ezaMml7e3SjgIx2ge1FSLmiI4YqklOOyfwHZk5g?=
 =?us-ascii?Q?eydRf7iAb5LIcff1JaHPsg5Sbf172Hu2OfsIrrnl9wQuvWoxALseq7pRN6Vt?=
 =?us-ascii?Q?mSefOrR3wFtcoTkQMbMSSVh0yu3WG74QdR2KChw4DLLkFvA0ERV+LuICdIbC?=
 =?us-ascii?Q?iofs6iqBKQa6BbEqb5nAWdPHcvQpHTuRi83xMI8YYTDg1ndwe8oAay413LpA?=
 =?us-ascii?Q?kNqhljr3sUt1c1RzAA9z2NW20rgHWUn8Lw6Gt1oMssLgbBU+qb1Zgb5gFcYk?=
 =?us-ascii?Q?gDainq7Gwy54Uiatrxxlum+D99/gWNzOq3xtzUERXgohVA//BrsK5GjkU5fq?=
 =?us-ascii?Q?4aK6AvuRJXm2EB8OP16AM9enlCpTx2+h+uiuB/0MtpKXqx3wk0EcQXak+cCP?=
 =?us-ascii?Q?J4Uhyyjo/cU8Nh+R5X/0HKCnl0wjhIbCv9KuX1SLaQ2mwUau7HaWSubqO0Wh?=
 =?us-ascii?Q?5x2J8Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da84f250-856b-4065-d1ee-08db39a74839
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 09:38:03.8984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RTEO/8C9D33sWxFfjxj2O3bdZskk4QxDgEJDCleNvyQ/HrJlmtSPzTXyKBEJ6lQu8fgjICmVOBI6dr+M51W48alXlw9q4IlH3az3qqBdTu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5900
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:23:32PM +0530, MD Danish Anwar wrote:
> Hi All,
> The Programmable Real-Time Unit and Industrial Communication Subsystem (PRU-ICSS
> or simply PRUSS) on various TI SoCs consists of dual 32-bit RISC cores
> (Programmable Real-Time Units, or PRUs) for program execution.

...

I've reviewed this series from a code style, static analysis, etc.. pov.

I'm happy that issues that I reported in earlier revisions have been
addressed. And have no outstanding issues with the patchset.

So from that position, FWIIW,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

