Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AE46D9A3E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbjDFObP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbjDFOaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:30:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CDC93D3;
        Thu,  6 Apr 2023 07:30:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StRCY+hajkOtOX5fRUAk1AWPnsxUd3g8p2GOv/iThmZdflpU5Y/aJTUhzjHwwtM2gci7FRMi9GQFKU8gu9zB5KwUQucGs3CGRVuIY2h1IvCZRaViKAUQngujvBOD2bm4iwx4JQwsaNlg5mk97PAnq9dvYniQXGVIoQ/OOTGtp3cLlkoQEMCKgGo6tYe/DGLK6YQzVuRZpQ6qrhkHkgDMZTim6nvoANNFlG/WqmYcuvlQKWka5tYA0OTb9Kx6r9FZr3t4WQ1qxWTZ6GkE95SByHSGCB4TjsnaX5rFBUM15KXK98zCnRcnk4NRgUKgrA+5CtYLcP1OIK6WP/pF5kiaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5BZbLOUkw4PIu1tK85vwpVXdMxOqeorafZUd6rmGa8=;
 b=QPkmH7N4l3wT7OGSuWGPGcOXD0i9BAOKOpCh7q7cKrYrWZaxdXHNGUsneBj+alpuFbZdT0kqYc1sIky3wUOAteGyC0nB/08Yh+MlinXqphJLgfCDRK0tlMZCougmTVOJz+R0OBIcrPVExk23T38dSf5RjW1tEOZSYQpYUMARPrhHYyfBjMv4LIJxnkoj2P+CMevlKz19t5+EszAkZ5lxhx8LFIYWhqYWm2TDlUod8CzXPnAq5snkDMmiTU9fV1gRv+LpQnccEgii4VZumuB7hCtfGm5Adw0o2tJ11DBqIFDL6D4+0ee044G4Ggr4zhL+Fh5YzdScK2TQZLnt5RZjAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5BZbLOUkw4PIu1tK85vwpVXdMxOqeorafZUd6rmGa8=;
 b=OORaP3GPAwAIsRDHeYQhXqArJzqukDr/3ZwZvM8YwZ/j8mzC0R9AvqsCSBr1F1kqsTG8UInr5ViGYYAo+3+KkIGe+tdZz+ZllNGrAGbqkXnKJEaQW7rdUBcTXU4jggsuy38TscNGLMKnk3ZzuvTVeHQRo18h9g6VxVg3X2hvCiU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3844.namprd13.prod.outlook.com (2603:10b6:a03:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 14:30:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 14:30:20 +0000
Date:   Thu, 6 Apr 2023 16:30:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     error27@gmail.com, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Leon Romanovsky <leon@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Rob Herring <robh@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] niu: Fix missing unwind goto in niu_alloc_channels()
Message-ID: <ZC7XdVnYWT+o0tLf@corigine.com>
References: <20230406063120.3626731-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406063120.3626731-1-harshit.m.mogalapalli@oracle.com>
X-ClientProxiedBy: AM0PR02CA0005.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3844:EE_
X-MS-Office365-Filtering-Correlation-Id: d366e155-59ac-4653-b779-08db36ab72c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fBHM8Pwe6aRIN8qHUk7frm52LnrM4q2Sq1uY2gj9YkICDeZPureT2I5NmGnDcdylfHVsoTwvbCAb0aF1fWe2IWaHzjcmFtyxmNWidKB6oEY610PD74k68z0bBjw2RhVhjlj6TmyPU55RUqPBHhkWHo+W6wkD7zENGrcKpu/itiMvicOmEVhW2pkMBa/UVsZzS+EUD7ZBqKzVSd0yfYBZpwo5IaM0prp8xvygTKvAIOc1tSzzA8DaUA+JBw0PFdjd/1CxOy3s13p3S699H/bzFzLNa5N66pxPsfgzGA1WSIZcxEvIvwhrNu6i2XHFMwa8w5lznnD0eBsHOGWG9WmrHY+m0/+e7e6sY3lvc7DXKN2y/IzQG9TqC6DMe46sRvOADgaoSxakmYpibgnBnwru0uGdqRjOJFaRcYqNEONE2gcChTCK2Wh4nxWKw86Mk+nr5r9oBx2NWUbefLbIeaYnvmzggvxmOgmc6bTFe7fYJWCEN5QhMUgOnlJYPBETIZWO+11xcAQsDDfWxssMPdUJMWenNadOeff0d7JCUWQFEj1z1jXBlng2KGD9DDLMmkmpnzq8/FYX60jkFIaCsr8/8Ldy+4iL/9bhYlTVH+wih7lKBwMt7vnmZ9lfC/s8p/5zAzlKeVC4K0+OwR8TWB5CvaT8bGyTl+kJAJAfroFb/l0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(346002)(396003)(39830400003)(451199021)(6486002)(66556008)(8676002)(54906003)(41300700001)(6916009)(66946007)(36756003)(478600001)(66476007)(316002)(4326008)(86362001)(6506007)(38100700002)(186003)(6512007)(2616005)(5660300002)(7416002)(6666004)(2906002)(44832011)(8936002)(4744005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PdIYZGdv/fjsAR3SUFvb6N7oDZiDCyfTOogj1Ec2dZ8B7c/LyWSRQ6QZ9xrO?=
 =?us-ascii?Q?T/BZO+xCu77wVFVjE8NVWZxqE50uBdFwHQ3Y/RYTV07CuvMlW/jRDhbch1TT?=
 =?us-ascii?Q?EJhTIN7txjZPGKE5kq+AREoRqf6EkvdI26Er4oPGcRmSeUzSVUDqD0jwHtbj?=
 =?us-ascii?Q?FjVjsicui7XbsA11LcKg0MdNvPMtwLMAQrZEA/wS44/pFDAVCkL2+tAqK4lU?=
 =?us-ascii?Q?2VbM2VekxcnN1V+xgzShAtXfF/qcNE8x9h9fVD8UP/ZKeb+v89056q2vQOMO?=
 =?us-ascii?Q?Jr4M3kyBKmbMhnoY+T4vjJ9vVdxza5JSPM/pfcaggzDsiv6tJ8kylrhGoce/?=
 =?us-ascii?Q?dgVA4NadKDN+x75jyOgaUSNSV+lntuhZ5SKQxaNPhKsz/TRmo4H/uD1WtoIt?=
 =?us-ascii?Q?3v/Pk9p0qHQL9OkaWrRFg9XJ4y3isedctVyWAD3P6YyPkztIwrHxFSHtjceO?=
 =?us-ascii?Q?4jyLwOYw8rbIyCGF6hufFNg2kY6rplQ4kanIb07vtCKDI+3BXNMVreaZauOk?=
 =?us-ascii?Q?GqkNYugtHLKTZekqte1OjmBydn5DpxAe2jXNe2pYWTWlMqnoIcuGFXY54Y5B?=
 =?us-ascii?Q?8Jy8FwiZlLte80p7US+s+VQ6AOC8T39sSmIWAEsEQb9SzJZe/5BUlezOjGrh?=
 =?us-ascii?Q?LzG4qKDePFjawZo+ixVzCv/pOrDW7I8GR7Tlj9zbCaVxRkXnWQa30E2AyH/K?=
 =?us-ascii?Q?VCHnxJ7scc78/OfdmjMZKNsDy2Ugw/a92zGMEWl/O36oT5GrZwWzGAPTXbhS?=
 =?us-ascii?Q?D/HScRzhkRto6tCBubYT9BG3u+nn6Nx1yz0zdeAkSSutzOYE12kYUNK9DQw5?=
 =?us-ascii?Q?SkZVQjFJVzbTjc+c20cobnCv1Ql5b0yePNMaLS6U/vZQrMaWd6KlWApBy9Fp?=
 =?us-ascii?Q?zRu2X7euhqy5XVqxOj/zMFsSXYoekRD7pHWi1OClTzOygHjJaMRi0SNdeDdv?=
 =?us-ascii?Q?gUMzC4V3bqDSlOoeMMja4nK2Tlx40RKiyMikf9xPvT/BX9r9h+IB24lKJJIC?=
 =?us-ascii?Q?lt4LwuWmVQ3xAK++4ZKEZpSRWC6dZKXXvOBr1gwgMLwpHAYdf6loYdXsRw+O?=
 =?us-ascii?Q?GkfSq1owLw4La+9YxfekdZbYI6GwfJyXavpqKn5eaGV6xMrrcrvneuQM0wLp?=
 =?us-ascii?Q?FToLTfnz3uplYopPPWAKVxS96/kZBqOYHS8yMwRoiE0OuYyNQu7GVdP0Ne67?=
 =?us-ascii?Q?faNAASMJ5drbaNrQ6P84XaWqdA82JI6n39QyyRd0ec6h6CjYYeRRsP79lXSw?=
 =?us-ascii?Q?8GtQQvMIeKwtkMSOwKCk77ANEry+qm2nPVyc6Sdp2x/Jzegp/bEs15o170Qv?=
 =?us-ascii?Q?1Kqcu3Sg/Pl7YQGTszY/TfttGvB1aVARG6XntTvk3cvf0DjuIaltBBZZOHxo?=
 =?us-ascii?Q?LtPuK7/5edmAeMzzGT7V+WiGBrMZzbkj4qS/EHVmWEhJsre3ND/InFiNwXN2?=
 =?us-ascii?Q?RXLnQTiBAeBl+72qlpVLB/f6D4YE2LLZcMj8adqk0ch5iVahSKiXxnvPZNvh?=
 =?us-ascii?Q?cu/tncIjMLRN4R8+w7XFMC6DyqNQEZXyRU+U/ERPcToKeaPEaRmOJYMC/wfD?=
 =?us-ascii?Q?KgbtKe3wwNDAfaTlKivhjiVhW2o3o/qkr4yKXpT+W8rstiluhwcAY1goKrkx?=
 =?us-ascii?Q?znVo2S+DMz/XKOqtBy132f0JpjrghFwHEbJ8+Hwnz367tIxmDlG8/dS5bRmJ?=
 =?us-ascii?Q?cGrEzw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d366e155-59ac-4653-b779-08db36ab72c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 14:30:19.8674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gf/vawIsYejNrZR6SdHLU+Pg2D3fLXDTR9ezOtHtSdgv9cAKVEqulBi54KKqwvObF1jb4CK1V9cQxwitc/9jEqipBIAjpxTc8tePxi2vJ9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3844
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 11:31:18PM -0700, Harshit Mogalapalli wrote:
> Smatch reports: drivers/net/ethernet/sun/niu.c:4525
> 	niu_alloc_channels() warn: missing unwind goto?
> 
> If niu_rbr_fill() fails, then we are directly returning 'err' without
> freeing the channels.
> 
> Fix this by changing direct return to a goto 'out_err'.
> 
> Fixes: a3138df9f20e ("[NIU]: Add Sun Neptune ethernet driver.")
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> This is purely based on static analysis. Only compile tested.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

