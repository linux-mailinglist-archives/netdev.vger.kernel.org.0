Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0667F9A3
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbjA1Qpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjA1Qpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:45:42 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25382A17A
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:45:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEwQQ4KnuCpZUgNMAAPfQLf53V+iGw8xdfobNxnUKjJfIFs+EGNmtKtppTY+wp+Pt2oKCW0IpNNcHl/fGlYs13ThkajnRHmjPJ01NSfXoy3PfZ1ixzeTHTbMhcWXyS/qeK5Y+f/uMoIGhV5gqHWLYhRDFz+KxrzBrcYDQvDGMfnRNHjAoX/4Zn3tQoJKjfcsc4S7kLsmXMEiGh4iD6qDm9KUnMks3sCQxZhN1DQXbNWRY/Y+tnKQ0nekEr1WNgpXFROcRRrWN/0vQQ89YNEkcaCPfcDvoRmXMG1P96Haz6fEO0qao2EbPqpx4q/qGKHaqt3DYfAh+mTmFqkv000Sdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7o+sNI7xIog4ElY2Wo1AwXgaYftUKUo/b98trw/F/E=;
 b=Zvb3Y2iMF2ftcKxzIID0QRB8aHgH7y9jS8WN8lNBz5xOQ2dNAlcSlzvyCEqr5Uiw9/rlkwOwhOwpPWuz8Ig7akCA8j8RjPRk2vhaGN+dLN8PUSvm6nze9vBBmw0ko+QJ/AG4SOt6AlwhIeE1yDYGxGr3LmILrDAqSyo6NYZsTizVHKF+wZG5vXDMaBpZOdWLEX6MAyCED/ldoCcaf2SPjOwpMPg1TQm8oTBkeElG9k1n6QCJcGUQ2aOe3T20iFldyP+ErtPLSSIRPDNRt1DLboSEjNxZN9Beuu7iyttXwt9okapEWUM/b+ngFBTtOKWTV9Tz2q5nRa1bRYt4yZFctQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7o+sNI7xIog4ElY2Wo1AwXgaYftUKUo/b98trw/F/E=;
 b=ZTdjXMFvA3OOZC0UOKzntlxA+FKFI+MuzxZXM/4J/v3YRyhv7gJme/AycBOaclTfdjaGAYF/q+WGk0BUAvwH8Ipf58BkEaOJPjQHrX6XRzO3vjPC05VpVD4/b2f3K2+VghRVrCkKXesni+KAT6rLlT7sp/+ErPoYgfYfuvwj4Qw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4937.namprd13.prod.outlook.com (2603:10b6:510:79::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Sat, 28 Jan
 2023 16:45:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 16:45:40 +0000
Date:   Sat, 28 Jan 2023 17:45:32 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v5 2/6] net/sched: flower: Move filter handle
 initialization earlier
Message-ID: <Y9VRLFWWwEUSUWHa@corigine.com>
References: <20230125153218.7230-1-paulb@nvidia.com>
 <20230125153218.7230-3-paulb@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125153218.7230-3-paulb@nvidia.com>
X-ClientProxiedBy: AM0PR10CA0104.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: c769f5ca-e49b-40dd-78fb-08db014f16d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MIxs+kPLP8Yrydda8ZTShZ6INmtEtOZUYSJ9Ub2cyyzXQUKTj3A1sXVa+4qkzIo17hWwXexzbiSCB+qJ0p04IbYFBmNnm8AnKOdAFVxYDThiGAeAUPKwO9faVaCSZBTRq+nUsoSbb9qhDq4EyPRUExJUT9N3qCTO4CIz760Ar3/p8ufYBn3K3myLKgJFSmaXe1n3fxh9Mw7yWCmdsxEa31ydP7K/kXl9DK7ifhZPP/JZAQTrdrBCGrdBmISuZEek3etI3izmFPbIqy7pKL5HiFTDrFJ+XE2oTbhvnFmfWGqRpy0dr+WfbuLJtKj8MbLKaoiwcmm7JD2vmfyRDssOGLuB+9jcz5Y9OiZoMq3A80X0lDzIDOcPtofjOnvn0ue/1ekMjBkMB0SiMGfGTK6S2XOPlGQTDBClbJnNF7h5MElcS/xl8Riq+flHDj+8eDiF+SMaom30qGSTo9O4ldliYnav4pShND+UvnsgQRoPLzemlpAdTYzNS/cMR0eU2J+f0AfhSMptqXDIgT61UIVCB+DdJBYjgG82zMXqeV6qK5hqYo4oelcnZxCRhTJuKFSBt0R2Q02I5kMn60TqznZZvxFyIMZy6NYobkrDAV4Rfhqu09ziq+cJuBWJbuoMMVS9ubVId2yNOWr2CGgYhmL+pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(366004)(376002)(346002)(136003)(396003)(451199018)(8936002)(316002)(6506007)(86362001)(478600001)(6666004)(38100700002)(6486002)(2616005)(186003)(6512007)(44832011)(36756003)(4744005)(54906003)(7416002)(5660300002)(2906002)(66476007)(66946007)(66556008)(8676002)(6916009)(41300700001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bX6msWH0507qQWTSMKsocOalLRSxmPNH7+jwM8Zbze9/bhLpZ/WygP+3SLVV?=
 =?us-ascii?Q?FE/Lnuo5VX/LmZRF453L/W2uedkYaUPPPqL5m4KBQoJ/mU2w6WPP5HL6383q?=
 =?us-ascii?Q?6aLWews3Rw+XQTHqB/OVaT/E3AENdwskaMLOxnXwFWwbi1ERRkM4JkN42qoT?=
 =?us-ascii?Q?dsTtfrkNPo6niJVzfRU7GPmFktgz3CQTLt+d7UVeJaQKooBTqYGEepa/AuPX?=
 =?us-ascii?Q?wNvUtEVzJFGXlnIygs/L4nchKXlEvRGcgNDQwmtE/q8/d7UrPNw23xOL8iOi?=
 =?us-ascii?Q?8zKPbuqdGyghjKXbGks7uC4zZR1L23w2xaodno5wYQkdcYgPXri8PU+EeuYj?=
 =?us-ascii?Q?epY2Y15r8ghh8717+80r5GMhiR/Fp+F85RuC0CXdQeNnpK2TrdPK5y79vToy?=
 =?us-ascii?Q?22TJVkPMBBdK+mE+b6f8NKOkGpatSxvSy0iv6Jn079TfLEv7fJ/DXYCkDcxj?=
 =?us-ascii?Q?wVok77Q5f5iaoQuGcu3aUjxapQz4fFBXar0AgNWnGItmUuHVOnXO9uVQU/Ff?=
 =?us-ascii?Q?yUbyXJhJAwBlLKN6Nsx/+akv0RSEwysgX8L9CeCjE/v4eSvUM5hJRNGShMLq?=
 =?us-ascii?Q?1s8zxmql/6qQA+giojFnhjFspmnlrOTlmH/VIetUlZdfi/8ACZuMRZz52+V3?=
 =?us-ascii?Q?NKX3Cf1g7shi/XjRTGHF2sD9GA33vV9boJqZ56gMubEfvYmZCUIqc6ooNoFp?=
 =?us-ascii?Q?VTAUgpeD/117g/KqONwLy5IJ9GjuGCiKFwUzO2A93z+9Fw6CKGi+uL/74y7u?=
 =?us-ascii?Q?hoQnq/Y6VTSLXRVA2ZP24wOu8D0yj4/h/sz82/wws0bSCMNCPdKUlWy5Ee2f?=
 =?us-ascii?Q?TtfTBBaP02UUgs7Cuizrsf0H4kxWmEkpWPThrMvZmqU/x3HIOTjcPfsTVKk3?=
 =?us-ascii?Q?lz97mjF8qa30tK9/izyz3uSkENvT/NdZSB94MIoYbQhh/Oromd3JQJEtca7j?=
 =?us-ascii?Q?ds5oH6ysQSfmgPKZJ6Iht2kdsMUS2dFldAF3W0hu8QNpilW1t82dlYKOAMlt?=
 =?us-ascii?Q?xKnF4986JZUiyGX7mECyW60drmi2OjGBwyWqvy706V1TNyPcc9HF9EoxWCgm?=
 =?us-ascii?Q?Ror6h059xBkw4a2MaeuSBD93vZGQ1fa1jGKa/I4lsrtLbumQywuAGTfAvV3P?=
 =?us-ascii?Q?Psg19cCTkubbL4Q0D9YQnETQb2tBvYmm7RQ18dCSH6b53RCPqj+3EME0mln5?=
 =?us-ascii?Q?oHRoez2wgHhToVqfcs0PttsOZNbzHLf65cf/GKtjcYB4DBvJ1u8uxiWvOj3d?=
 =?us-ascii?Q?2OujBXHKxZS9kyeeqwOAvZp9UmTRBTNTZ+fdpsKtkFBJk/z97KPIbz8+W/XG?=
 =?us-ascii?Q?TqDaCAPajIz466TDucH/Cb75+SUbgr8fnSKfBJizlLon6EmO5vDsFqaX1jft?=
 =?us-ascii?Q?/iYdskTEZpHHcRECVM7gC8h7O+gpoYxCR7TymkLV1GoY/vm7oRkpKEexf0xL?=
 =?us-ascii?Q?j/mKVzOIHvfmJuD7LmrIJ1Jgwvohr/TI8vczbBBHXNSTREdbj0XLLNrAP5nI?=
 =?us-ascii?Q?OIgwKVNOq/yBUYm2uKGhnapQK01pZP48auK/jJPaPBhR5SrozHoGJLrJCThO?=
 =?us-ascii?Q?ZuIfpUV2R+Q6xBWGO3WILrftIilUcniLtneog14DjOonsk1IzvjyjMDEgYl/?=
 =?us-ascii?Q?Jg2uvuCVlMY829GfqtboGTFaBSg4kK38U+W//xuljWjN/+UPpFx9+dAMRnXG?=
 =?us-ascii?Q?OrnHcw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c769f5ca-e49b-40dd-78fb-08db014f16d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:45:40.1777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRcFcbDHCOlNpflClFMh038QbcTN0uP1dG/GndAoWxzLsITU58v7B4zvAWIZ9qQWDNff87jtKFCuWNSzd4zvHBYjwf311Ccl+THyCC0Pupg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4937
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 05:32:14PM +0200, Paul Blakey wrote:
> To support miss to action during hardware offload the filter's
> handle is needed when setting up the actions (tcf_exts_init()),
> and before offloading.
> 
> Move filter handle initialization earlier.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

