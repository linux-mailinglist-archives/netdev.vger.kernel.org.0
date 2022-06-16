Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB55454DB31
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 09:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiFPHED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 03:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiFPHEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 03:04:02 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357A75BD13
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:04:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQNr/c89FijXKilLpzs0+sQlSKoQiJrRSIfIHb8lkrX2AE6N6tqIsY1tln/IAprisBGoZGmiCsZ3Sh+lioK2g8R1fErZQy7lHSZ7yMU80wfPpUeZcs7sdfHE70aYzi8xTxId7QQJOF9DqZpSKXc31W6eLCygT7VCp2K6gJddiUvsX7BxS3qW7glHUlwqRRu4jvjkUEEwc6wLYT6Kw71HrTFByonOh5ZGdVOZRs2WPehPEUj95DxMLw1Xh3dre3PoHnM23HgJgFnCtlvsZYoMs6G+HFbbdO5i0wysq1TIrNKCrSYa/YWCSQgCGRAJimUc6lQQYyRGWRPzmTNCbI+Ncw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vpi5An0Wi7WjmNGFvCltAqRoOsVydmj4U+NKrmzMBrc=;
 b=XDGh3MJ+kXSmwFPfUM2MSPW2Wwky3D8WABNL5EDGHrXccSpp7sgd/iDptt/TI/WOuq9Pe09Wl9sI3O9YXVm+0BSbJ9ukX9yAvZx1+atB4QsAVtegmyI8olf4O45OrN9nqmKOxzcPDIuqclyflpqOrMxgThcgORIgq61iPp2SDFMaP7bNJrsFfJCPcs6dlGEws754J+1tKz1NEpif8WBfB9eIVne2RReL3VSVjY7o/mqIsbA61Qo9G8LcjAK+JobmiQYveKhF4F6v3i+dd0D+xmAI3pQESV2bH785/nlatUhlJj85xnUezFfjV9+n3n402yyIJlKvslytTaURbl2qfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vpi5An0Wi7WjmNGFvCltAqRoOsVydmj4U+NKrmzMBrc=;
 b=S4tS8W3H2q1nW1LdHlrPKFUxAyowPt0n1ZY8izGvMhfJjMb1sgt9YwqipTL80e570ccfQaGvupxptd0biFacnJmfa5vtXxnFkqPGdnUn3dHpjamAQAQu1jIXSHj7NNooFN7TFPgVnum/zs+ttIf0sR0kVM795cbnfW5auckG93112T0lTJ0nm34FzrFkrIL/JuXC7kiad1joVFI6xtUwZU4hywsLLKfCUC/RazmrdmdrjVE7Hj3kxzCN/yc54z3hNZYSQgkIPN7QeYRq7aKSPQxYwYPknv1luOrMoGgaa7PRKWUNsvoOCJTUa2p3H9zOb+D/c9HFeoMtn/NjnfzBOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 07:03:59 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 07:03:59 +0000
Date:   Thu, 16 Jun 2022 10:03:52 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <YqrV2LB244XukMAw@shredder>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder>
 <YqoZkqwBPoX5lGrR@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqoZkqwBPoX5lGrR@nanopsycho>
X-ClientProxiedBy: VI1PR0501CA0027.eurprd05.prod.outlook.com
 (2603:10a6:800:60::13) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a449003-fdaa-4858-591c-08da4f666304
X-MS-TrafficTypeDiagnostic: MW5PR12MB5624:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB56241050D9BB37A287BA8788B2AC9@MW5PR12MB5624.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RHneAQcuhsavIZGs9KqHyg506lYFrZpoc9brbDYxvdzCA+IjItBuhbBjFhI0Lp4b9V1IPWDnNC5wjhJ+xSTArAGwd0aabSTogj8Yk9epp3RruPIRXslfXT0+R7zqO4B1FO3GcpOpAuyzorMr+CaAWR85g3Zqc6WtT8spPkDOJGwGlyqZMX45QOQaBR53B/GnTfbOGq5jcRAycZylHu8CPFaJuWNCirQUAoZo/tOMWRr98/Qaq5Kqlc8n3eFJAVHKo8ZHLYesjMc75N3SvXXtJj8sWZfnzrY5Vj9MkvHxMqOBkpI1ilhrH5pVidLlqdGrefwLFJg8CsLF38c0YcRLE5hxfqTu8wbJ6Zb8Lk9JALHHR1dgm3TweNOUq8nQqxTEc/UxKQxXK+tiEnEOkkt914c4henEpVKaUX15R4aT7pzqHXkRYKGMCBXxX9IoAbS+xsPlfPxmfGWw1RsFxyXn/sLCmlaHdtT5uiCGe9dGjOdSmOv6nXEkrMuOlZI8Aum/7NT54X6K2fh9t/9Fd00AI2h+yuDGRsyb8+PXsLQtPv8Pmy8zYEvDwbJgTYLeJv+Cz+wY+h6jciKwzMuKkyFlgYtTL4yWO3Fbuofa1QiT9Cjb+NDUkEKY0cWWWXqlSvQ24/ISXbLsouBdanuDjN4zaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(33716001)(19627235002)(316002)(186003)(4326008)(6506007)(6666004)(8676002)(66476007)(66556008)(66946007)(38100700002)(6916009)(6486002)(4744005)(83380400001)(8936002)(508600001)(5660300002)(2906002)(107886003)(6512007)(86362001)(26005)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A+PlZZ0G2fDMO8anIJFrIwHeXAhTYdhnOziUG6mCrwLQRGT+GNogey3vjDrP?=
 =?us-ascii?Q?I+wKBqP/pRL4K03hVHr3tNNwzxo5ZS4cqXj5bma1RqardarOfCmoTdFFask8?=
 =?us-ascii?Q?0KT5e+eApSWhhPxjvEsF8MSw4QhkFFEcwsLOyO2XPCmZr6uR0anzV/iE8FsN?=
 =?us-ascii?Q?HS5v2A3lyt520lSxwVyiEZG4MGWVggdU1XROWyq7fFmx6c3gwoolLvhobYUU?=
 =?us-ascii?Q?FqyVBIJVakMTHRqz+zmlJWR/5qaxYWf9hQPwWPTTP+LdgMTAR+6veoTvUCkS?=
 =?us-ascii?Q?MGLKrGSb3coCzsAp71lr+upYMbyOG2cMTY2ngJKt+SALnUT1wR3ASpEBmjgm?=
 =?us-ascii?Q?57Gd5WT9kKkbgousRwXEHVScjKOVCo2Op+qqYo57RRQ0Nq8jnR/Car2r+ItS?=
 =?us-ascii?Q?BcievKekThTJaogXMFpKV2WFDLU4TTMCReRTd/SstngKwdenheFIzPi86wdH?=
 =?us-ascii?Q?XGP3Sz5hlnH8UYgnf/BCoYLpsTXn1ixIYOiRoivIUEVDyiBG6alcYZUyp7Zi?=
 =?us-ascii?Q?Vfizh/viX3wY69QPlMYp//F/ZfUZn6EeteNWBMEbg+/QMtR9k1nAbdPNFPAS?=
 =?us-ascii?Q?gsFEUHBty4x7dda2Cg40znekC8t6yApxAswCBAfW60pVv8zWefkri0n1jf4L?=
 =?us-ascii?Q?odoAPfMswFYmPRHEme4BEqehav7SXZKp9MrpjJXmgQaSNCbgG1GfwUoPZA6C?=
 =?us-ascii?Q?Ux6+0/fe9+SYoBcj1IDpNyeuLpx2IKXARdmYdZZoMklxYLks6mF9I+tCZp4X?=
 =?us-ascii?Q?A8czAv7ubJ8q+U20DUhJyjnxv1W8UmouzWTH0+cZIux692k/pcDghQbUSDpf?=
 =?us-ascii?Q?9ZZDRoAanvOvnIH501XALpJ+D+SMMsCRBeQEhPlyXVB0vqsKxjoyGsxmGkgw?=
 =?us-ascii?Q?3fpoHqjNXhHSAVRQ7pdUc6dyY/hGH2KK7Yi3yLezp1XYNPk3vGbPBOIlnFap?=
 =?us-ascii?Q?ihP4VLBq2eKVII4M+nRLn84gK93DZc83yTz4y6FXYC4XFeLZi36DZcHFBZXI?=
 =?us-ascii?Q?i07WacRw+zwM1H0RTA1NtKkZ5ZOqgddcp2VE4bu8E8bjAtC8YLECXE7WBfIp?=
 =?us-ascii?Q?7Dv1sACZ9Kov8ddHoAvYMBF+EmS5/1cdHmQLCTSPfQpypsP/89aHXY+IsvQb?=
 =?us-ascii?Q?TD79fXfLzCdV09jgk+CmEx0TBHJtcmYkOyhKaWdBae6h1vY2nvZLRRq0cEaP?=
 =?us-ascii?Q?IBW9lOi1/U+tJmnpPg6ewmWQJ6zo7f2UDA3tWYV8QLI7dRS4IDFa4QRVXWWd?=
 =?us-ascii?Q?QwD99ipIN4ZkppI63iZBUzKsGetGMUH+DTXsX89W0Gk1ebgsPjO6A6wFs8fb?=
 =?us-ascii?Q?ep3EEHmtocEabgfjtoGiUDfU4wrgjmXaondbk1oRe7xyT1Jbi7DkFUETiyw4?=
 =?us-ascii?Q?auuzDZhLzBSwH53PfCyC/6cccUCdRvUFzZPrl/S4Wgo2TtVquEVsmlFZRru0?=
 =?us-ascii?Q?AgK272cN/zetaA8U3D6o2AFTI0z6ttq0J9q+se0QbMPHC/PqAPN6l0Rn9aDQ?=
 =?us-ascii?Q?0YxMwmqSZPhThdhkrxQUFyMGn9rId0FLCjT8CHDeVopdC3iqxiDyazVk0nns?=
 =?us-ascii?Q?kmkswh+fZh42u3LWff9SAbeN3K9j1XCZ7ScwA/wb8/5EvdnL9x9HriMXm2pm?=
 =?us-ascii?Q?epNsxigM2onn2WPULzGps7WDMfW2ghtacNTLPChrNH+ElDYtZ79s9g2f3Qvu?=
 =?us-ascii?Q?U650iajMWPFMnelvZ0c6p5ZKAEBmEYMJDLNiqqJUONDzHptvv2Yk5dalvLVy?=
 =?us-ascii?Q?NtzU4BMpYw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a449003-fdaa-4858-591c-08da4f666304
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 07:03:59.4396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66Rj6wmFGxJnxOZ5t2F1lmb3lRKBr++9AWibIzhRwoXyBc+qeZujz2TkmWXGvESGa+4PZ54sKpTZ16r3U7fPqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 07:40:34PM +0200, Jiri Pirko wrote:
> Wed, Jun 15, 2022 at 11:13:35AM CEST, idosch@nvidia.com wrote:
> >On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
> >> $ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
> >
> >How is this firmware activated? It is usually done after reload, but I
> >don't see reload implementation for the line card devlink instance.
> 
> Currently, only devlink dev reload of the whole mlxsw instance or
> unprovision/provision of a line card.

OK, please at least mention it in the commit message that adds flashing
support.

What about implementing reload support as unprovision/provision?
