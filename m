Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349B757B353
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiGTI5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiGTI5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:57:38 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20B16D9E9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:57:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsdaWVw8SROWOaNhGrFXklYKwn3cwJyH/YwzENpS5SMzreIpdpS5sVEIRXNddolBUshYqWzd6ugV185NaHxjsK2ojimUdNmLlmITz8wVzy3Zo/+VlYxdI4jwaK5XT9hqlMe5s0/5js9hKzr9JHapAYzjHekRjFJEdkZypMGFLWTlsTRsVyvAz+xnZ/0PilU3Ssg3rt3/EqNFFZghyRbdDM7erY6cd3rVfTjXKBze5W3p/RQRptaT3RsJqE5hcuLxdjJVrrXSGeQ5F5Hw/80wjq9C3+leJzmYkVFmi8Jzwy/cBx6snOLwPxP4jkwoUDWnsG5sZDlP8RC5do/HFH26dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0y1uzy8SkzXbPea27VgFryDSWaNUXDyYjo/dhZ8hvk=;
 b=OgxSuQbGAMbGPS7nqnRgmmG5HuiFiqtc2Oa/2bVtUy71NyiNDMVIgfZBIMdBjpJYcvIKBpIhUfqKEpNrMwscM5x5uJHYsIlHNZ7oP9NUXiDazhRDjDfZ+TzlYkhXwCjuaKMT+CIJg2SkqmDyky1MVWQ6L7W6NwT828syMy82ZlA9eufV8BBZeW1tNSl+EoTZR0rWJR8yZ4HeG+qC4qCUYg6KJthL8pdrariDmeQkAL6A7qMxJSY9St6OsiHQzzslwAyR3tE2O2WcnjlRs9oreeiNiPdQ2rHbBi0BxyUROKeGGZf0VAdQbc8jS2V//yU9cKQUhH+VVKmEOaKb0kuuXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0y1uzy8SkzXbPea27VgFryDSWaNUXDyYjo/dhZ8hvk=;
 b=WfdxiO5E+f5Gakx4HHxK8QUE0Fm5JcnA/gC55gmuF1VbZVj3qmzV5JKToI7zhHNxyGKLmW8f8ytggl5yuaHz8qoJhGcmCLdGMzjkLRnAtTBXxBzFbKszcTaIHRs+2jUnTekYYTLqFl/okUKwjm2fUUxfFQL5TwgrhnRM0KkO2iCqhH2hWJgkhKqOvOodc9UgivOyH+ucbTHCyE/dlhPMz52kBqWE+QRyZVxLplrJSND4zqeP0JZJLh1IzOT6M3tPmyRaoMlJd7MK6wLCVMOkf6l+Z3fVG/j/GBF17W8qEgJxotiVDnUBLp/lCHBfW0B033v3GLbI5fUaTWmEYs8KLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 08:57:36 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 08:57:35 +0000
Date:   Wed, 20 Jul 2022 11:57:30 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 06/12] mlxsw: reg: Extend MDDQ by device_info
Message-ID: <YtfDeoEaaInwXCe3@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-7-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-7-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR06CA0189.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::46) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c69f536-ce7a-48f0-3e53-08da6a2de3d4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5753:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rDBNYVcONiwcbTN3qf/n47tNmKDRlvHOEDkBo/H//0/wDV3x87V++OxwUlA0KLAa7n0xln21tuBOSzqcJUvX9Q+7R8hFIB+NaEzn8xfoGYHrbRciPj765IP2FYcQdczKCwpqa8O3h/zgu7Su1ww/MgThfFxj81wxQc1GA5d2aN6d6IuUBU4w21HYu4WJ9qa6baZI4kf65hhFr7OyaU84T1SEiBBDagk8dLDYraO9g3tKdJMu5xddHO0SyGJb8WrgdwqVrik94rsu+Ca6f8MYhZxPtA/nDo9ldh0EM9KWgs0Vc+XIEMZhMbwdrMNoyyUBGu+9rx6TQC9InB/S9jXvz6/q+xeRCANxErt2IKoEJEiJTPExFTn+sGNtBbmQnVN4HNSrTPTryJbx5Xq3p2ZEjRIrFaZg6YypXEHKjgkqrYL5yFnxzUoYMourFTUlb6DAv6pVWODU4vleAyXeF/1owwCQqKDGjzDHl60+3Lh5xsRocRGXavl7YwQZvFINh3aR8GN1puKbS+4QVOsDPlatDMRng12z0gtfA2YB34uyThMWO4DeIMPSXZIc4szttrKRNY5r6p9XM9LqMqyPSw6qp3y8ylDymjX43JKDLpL0oie21ZKlDtx89eDwPRCr2OfAFxdr7c5t7HwjZzOi7ZpczwFsmkoynicP9ICCIVq8z122fClrfWC7sIrg/llD1lPIzbadS+LMSrnpiAXo6RySqPk1HqjWALDL8ZzXmYeF6sdS4yzjsGLOaEnNkR6FOZux
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(346002)(396003)(366004)(136003)(39860400002)(66556008)(478600001)(6666004)(41300700001)(186003)(33716001)(4744005)(8936002)(5660300002)(86362001)(66476007)(6506007)(66946007)(6916009)(2906002)(316002)(4326008)(38100700002)(6512007)(6486002)(8676002)(9686003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DC6K0OAkNJb/iraTZT//nFdplrIhe3RuCGZSNkgIGMWicRmX6l/kmcfHW71X?=
 =?us-ascii?Q?3SJ9wG5Grc8EPnNx+Gntn7TLXUGp/sBQvyYql6vEyhSC+UXhbSYU0t32NQJi?=
 =?us-ascii?Q?lchtFGHkzOKprhz7F2Zy5VxJs58mg2hhT7VrKssfHsO/Vw3rg4PwwWRGj5AI?=
 =?us-ascii?Q?CXmt2XRdTm6brnmnMZzi9tphKwU6T5taSuM6eHZVPkrwI+hEWtm1V3y+3sAK?=
 =?us-ascii?Q?7y1bmhuwsqlmEyj6hXijOftP8Qbw8FKM4KNUyQB+FRBedzT2UsrTzLdnDgnR?=
 =?us-ascii?Q?6nGkE26BtpxNTw+nPx/pr1+ljy9okj3bIn1Krt5vvbwfMA3De4TnBWBlzWgL?=
 =?us-ascii?Q?TG3vr74Kx4MXarKt9Pxib3L+HovSCtG6UBtypDfAZBLzAG3I/Wx4wBXPa1+0?=
 =?us-ascii?Q?ow2lW1KEOwyWsNq8U2b1BiLBOtwcqtDphqgtiVXrN+Azo5MtPCEOSajqHScP?=
 =?us-ascii?Q?b9GprQR/gGzbt+SpFEwWTMeW1TFrgbAK1j6eB+1UqxtLFhKaWiaKAPs7u4z9?=
 =?us-ascii?Q?5+HXyFdLWpYj7R9ne1TzRLkkdTse+kTHuon6UtyL7v5NIb0CCZsoOeybtXP0?=
 =?us-ascii?Q?jMC53II+WM+385XLOG2hDsQx4yEjXBZB/vT2Ddqf3A7Fb8Ga6zNupwnhsJCp?=
 =?us-ascii?Q?rU0P9KQ/ob0H4zng1sVJ8pbAJfXaWOvMDXbIG1TrXVi9oMJ1pZSBFpBERKcs?=
 =?us-ascii?Q?d0mNGxaHyxABRUkZxP7f1zx7dPHVihyYOXeu/hO2Qi3vykmtdB6ioGHRKzm6?=
 =?us-ascii?Q?uQbsGWHK5ueYwmlSY+hfbBfVv8OP/3nZygtt2/211MJVKQL85r4r3pSirVA6?=
 =?us-ascii?Q?tZVKQQxptY2Gu4vUNxmUMulm3pSraRdAyUIdvgNcwZ2ZmVs+WFRdgkda2St7?=
 =?us-ascii?Q?CpuSQCkZT6TUO5PYGey7GnwuoiWyVGx9YhjB4Mt4rJTCjjvVIgOB1mIogwaR?=
 =?us-ascii?Q?tfjQNtBMXcx/25mNzlE9A5fvp5VEpqi3Lt0nY+AE0Yk/fdk2CDZtH2dpt6SP?=
 =?us-ascii?Q?2TCS/cjY6pwp68fpJ924hs+F2t+Obwyguw9lUqCEjOOTdqB3u+2105IRZJ2Q?=
 =?us-ascii?Q?X9av/OXEQ+go9DOl3VoIKdtjH5ryTje8oJsdSQssquyDMFyWriMXPNp9IYOQ?=
 =?us-ascii?Q?SyToEWJtfNUet8c3nHfANLbjsuyFgpxvtlZLFvRleV5GA04Z+n75B5izvrXA?=
 =?us-ascii?Q?wIwUea1e0NedY0wNGlONAp2scGWAaOsRRZrOv429Diq3Bh83Ll6yyuIxkhgg?=
 =?us-ascii?Q?+yhoodtMWENC8cpyfftlJMZAQH4UuwGfu31bjBp/jJnrbbGCAVtgElLWsgNk?=
 =?us-ascii?Q?+s9IZBmY1e+mYAxxam+ozHVe7lhqb3TAH2ATH+6wuZFEPn/dMrgXVz9kqTfB?=
 =?us-ascii?Q?vRRuGnchdMTBOKQE2iwK1GfECkSjbHvbFZHLkrE7jvcLHsjgfXlmKai+s4DP?=
 =?us-ascii?Q?efc6ZOmxDGFZSRW78ZVDDXDaF78o4cgiO6qWM2Lac3UpZs9pglxexht1XCST?=
 =?us-ascii?Q?7tvP3KEx0n6rCy39iAhiRBZaW9k1NrvRCIEeI6hyTKE0KUjL8vw++RnSqStb?=
 =?us-ascii?Q?7vfEDfxBA6kFeLVNf24kDGerUp8rOyES9RxuvkYs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c69f536-ce7a-48f0-3e53-08da6a2de3d4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:57:35.6006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gt3/vYEnWUCvyciBLlSXcdvxn6Csw/a0Ms3wZB8/a9hIkkbKwcLqMUj88lk4/c47uS7j+ObxKv6f05LEVYUbKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5753
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:41AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Extend existing MDDQ register by possibility to query information about
> devices residing on a line card.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

I don't think this changed since internal review, so:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
