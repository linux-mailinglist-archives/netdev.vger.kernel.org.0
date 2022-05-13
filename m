Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E22526242
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357648AbiEMMrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 08:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347460AbiEMMr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 08:47:29 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7819F36B4C
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 05:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coOl+sa5a+pjy55cxC+hLIdXatELU5EgF1gYxY+oQFHPdOkz2Rp94MqfCkldxIibGguI8CrS0p7YTpkU26HgaDGiNJ4fND6TqGSQG1W+vItfY7P4LLFVSpx5/KVbZcdRcJIUtwmQ3CdyPn0r3GP2GrbLPUln7wJRxSinXHf+/llty5+EUxv9RdwvzuJdk7VBZQpxwn49bMt4I1Ljbu8hI3bt4+s9n+6zqcrpDItJs4ZTlSAEy//z/INkY3cfpz+IBn3QDx8CD1JP2yheIaGgYeC+IgBrbqLDTEO4Fbfmep4XT3YFym51rz5angnoss0XUODZdFW6oPR7toz2+IM3LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0y/lUHn2lmGilcKpcDJIAk/rbRuVKze658djjynYfv0=;
 b=XBDywKG1vNLhjqL90Z+NvrU/WLVj9I8wTGQ5zFI4xoSL6B0Gf0Ia2A6JCcIREieouC2t8q5/nGy+X/oDTLmNc4ZAA0eUxytoE8zhvYLlsd2iSYKUpBwDG14/ehlHzkgEEaIaq+IVeeqqxkmTH4YOpWeo/0QZkV3IE2Uk0UUbmO6N+BRdipyvuNvU2MAfFUevylEvZ+/Un2pe/cTrYPu4PL7s721xprr1oRYjJMIyqOziC4unz9k7A2yrceLlXlD7mymamYoL1oyh/AXaMjmsoUp33/ZGbswWuPEEuaXNBQ11WQu/GkEeje1Zastgfqh95A/l52RgFY+uBBpbk0VusA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0y/lUHn2lmGilcKpcDJIAk/rbRuVKze658djjynYfv0=;
 b=dAJItVkhAb1Rp5+EgFzpS7EQIdG5AJHy9SpsJvb8OVVWOJHOhILcky0f54DKFge1N0A0EBVsRRqW5dthOXkQI5v8Vxwi3P3ls0xDZ0iua1W4cU/ebazdocvBKO0qQ1IOCFc06F6kb44w+BZ3XlradE58SMHPtFAK+thKmgus4pByU/+2HKM0F41Yjq/lN4t+QAKHdHPlxdnhJfWkWnrsAo3wm2TVhqh0l5Z2Nvq/ghuPQnO6f6mShl+Uq1zylD+PeO8MuVg8iNr/zGy81PjhT4SumQYDwG2qa1WPZGP9qW1DFmrTx5vgzTTLRFSwG4GZxxd/+cn5Okp0Neli4K4BMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB6182.namprd12.prod.outlook.com (2603:10b6:8:a8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 12:47:26 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5250.016; Fri, 13 May 2022
 12:47:26 +0000
Date:   Fri, 13 May 2022 15:47:20 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Message-ID: <Yn5TWIZPBVLFipVD@shredder>
References: <20220505225904.342388-1-andrew@lunn.ch>
 <20220506143644.mzfffht44t3glwci@skbuf>
 <Ynd213m/0uXfjArm@shredder>
 <Yn1wK78zKzcgzg15@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn1wK78zKzcgzg15@lunn.ch>
X-ClientProxiedBy: VI1PR09CA0095.eurprd09.prod.outlook.com
 (2603:10a6:803:78::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37af7bc3-8c81-48c1-b7ec-08da34debb6b
X-MS-TrafficTypeDiagnostic: DM4PR12MB6182:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB61821E4D3EE539DE3A9D9A04B2CA9@DM4PR12MB6182.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKF7HxnQoDib906Fwo00ZlFdIwAc6TPTI2/cq1rhtBbuz+UrMNzU3vpbF50B/3Vtc14fq0C1WsIdpf8oWOAMTOt13i6kDxthCqhUSdF97hleNPK+SXKkFh9FHGFW0T4XgWijk2KTkuvDpPdebcVc5Om7/KC3C+hBCiSp84y370HTzWIvP5puMcKW/aUK1Apku47IJLGuXBCPUkcOTo43E9uSNJSiEAfYPdtoNA3JaFM2h5uIwNcO9jLAYP19Gz4X1GbyhK3C3xjf3yEYqYwu/F8n7FWE/V8U+pDyKm1hbNdJa35P03hwYOCWZ1w1TYiqHfS0cs4yyj8nnfolG+mzp24mr/Cl2ACMEr5F40yszw/DCFjPqlH3uLpva12HvR0KjESiSZ2Ajak9qdnGyRQ/evFr9k8XQZiUK2ASayC6D5d8sYfmx0LX4m0ddG9pVy+TjDHygWRShlsYJPtdKTAwpW1HmhY621IUm/44nAfkbZlNtWSaBWrI7UhxoUSuGaX0OedS1x+Aa9SWKlGG3ONitAo6O9HhgwM4Teb5XiW0kAlnXPr2lpIWUaF1dIBSYhQJ6jq2iX/on3SPj79rKXPAE9IHsTDVYQG/1rehDlbNfMbJcbqak4p12PbFmOlKfERy+az02XGurt2a2+5g4MraiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(4326008)(66556008)(66946007)(5660300002)(8936002)(4744005)(6506007)(38100700002)(66476007)(6666004)(83380400001)(186003)(8676002)(9686003)(86362001)(6512007)(2906002)(26005)(6916009)(33716001)(508600001)(6486002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?niXtldLrekRPhR1GfLhFcy6yPEhCYd9hpnWIqUlb86JhhYMJMM0LV2GohR2t?=
 =?us-ascii?Q?GBMGJ6jJN+fEqItgVFC/RXa6Ff4lghoeyKbTE9qLoM3U99FA30tIQ1P4ntuo?=
 =?us-ascii?Q?NRoD6q88vfP/s+ZbvlQBc8uUySClXv5hn8ysuL5m5qqishEOWGIYC6y4rvCv?=
 =?us-ascii?Q?TobGlAKL4+ZTbLiPsKoHuErSz7+LryIwjdd770k8adUMuvMxKA9RQ4tsZ15d?=
 =?us-ascii?Q?TqXZXwygd9JyfneRlu2jRQRSvzeqnSjdeqCDVEGCFY4YLBXjfMp8V6odGq5O?=
 =?us-ascii?Q?/Y7FFbkQkPsOGbMGe3VP4nWX/r94is4YpXj6OHDp0mPce8oJKuNhTyWprXJ+?=
 =?us-ascii?Q?6ye4KhYT4JDUTmbR0iR9U7a0+ZKcXUwhekPqyjxJOzBn7tkYz2jESrpyG1Qc?=
 =?us-ascii?Q?ghWEk7/U7jUJY2JWHxRabSTPGJsknKWKKAb0mrp8xQR3dP7SqUEt62Tl+IDB?=
 =?us-ascii?Q?QrvMie72bgUgvUpzo/N+p5unxDkfm6wGznqY8pD6O2SL55iDztfOSviolYgV?=
 =?us-ascii?Q?rXtajkxGSqkohv64T9Z+Sg01Q2SgKC/COHvmfxC7NtezsrQS6kE2Y4F44tSj?=
 =?us-ascii?Q?5ZtXEuVvULgT1C3L2i0QWRtIT9L5tTkyuYmDXYtFAjLqyjYcHGGsjM6biQup?=
 =?us-ascii?Q?APULkz0hkL6+mTz9U+hEQtsiGaaP15FK7WFmStbzEuj3V+/rSKdA+64slXiZ?=
 =?us-ascii?Q?FYoLfKfxs30hUy+Sj+82k9S0uyl0mqpnFkSU/8PcYTuRpCRbxB8hnf4rC973?=
 =?us-ascii?Q?8Q1x+5Jq3I7EYqXzCjQa3VBdOsDwvY6kY/fWSQmbVX0FXX8nQwo472cn32Dm?=
 =?us-ascii?Q?sgtJlOGdKNnKrnHerAt4D7p6Z4yigEo7XD6L94llG3jK59PUHiR76zd2C7Fu?=
 =?us-ascii?Q?WT7RyvTbx4ZV0bElNJrO0Z9I4xt6SyHUomOonnyyOqSDvJxJ8Hf72hnjjdbd?=
 =?us-ascii?Q?EBZfwWzy9Fz9n+Ti/wwPXVyv+csR7tXxqLO+p/9rM3CFf0JHNIQPtVIz0Lzd?=
 =?us-ascii?Q?xqRP2AGkz5+9ReG7XwSs6+50lSN5EIJlp552aXbwAQqIrif7WmGmVMyD1FOZ?=
 =?us-ascii?Q?wXbGsnJI4XkUWS2c0Adl4G2TMuzrRSAbcAo8eZZD37o1vIGmDAE5D2nZXHgx?=
 =?us-ascii?Q?53d5IhE0AMOkQxbvggRc5JuUq0LRcR/C+OCQokpPjq4ODHtpn9yrx+tVOg2Q?=
 =?us-ascii?Q?WyyyhTWAuvUc1RcvzGYEjW7znmYtrtV2mJhzPy4IKf2n3EXIeXaP5Ax0HXTo?=
 =?us-ascii?Q?A2Q9flt1T37JHuWTqPcxbtlOeWNLZqdzkhUggk5gAQixoXxDKpLqaRnLX8Nn?=
 =?us-ascii?Q?ntMuBtfW5k9KWh5Bgq6UugSifea29qRz3fV6D1FBG/eWSmA4DQWMfw01rRR+?=
 =?us-ascii?Q?lL+5EF5PXP41fJGJYueZF0CeUKjnqC/gbYBSDYba5PgOvV7HsY8gEQH5dhqP?=
 =?us-ascii?Q?yVO3zH1v+7sYaS//DIRmtLrKrp/AgQl4KNZnYxIpaF1mUM/ZVbqoFV7Cz1Ur?=
 =?us-ascii?Q?sngKzUmNoardyu3Gr74pkcob7VbGyoUKHEfmZ9Q7JNLqpcthM3z6TY6z4enD?=
 =?us-ascii?Q?BB3Eb9OAjAAJQoObd1E/AJgurvt3FpHpTH/TU2wY/UOwJVOu2yMllRcUsMKa?=
 =?us-ascii?Q?rI4wWnb19pIhhElQgXC+zvyq6DDM3Co3KwppW+c6+lqF1488+mMJiyXukTlM?=
 =?us-ascii?Q?N1Bx1WCSr3mAcXZsOYTCzbHzeu3dJ1Nesjye1wChqKmUROHdqTSWDaZTfvs8?=
 =?us-ascii?Q?AYlEK77G9w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37af7bc3-8c81-48c1-b7ec-08da34debb6b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 12:47:26.1410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zr5ZF5lRcEBjR2rQuWvr2vrlu25l1XvuBVGGVULX69fLO4/bnh3nXImx8y7eX+tHNbJBZo1KKvIyR1//4bvKXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6182
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:38:03PM +0200, Andrew Lunn wrote:
> > I like Andrew's patch because it is the Rx equivalent of
> > br_switchdev_frame_unmark() in br_dev_xmit(). However, if we go with the
> > second option, it should allow us to remove the clearing of the mark in
> > the Tx path as the control block is cleared in the Tx path since commit
> > fd65e5a95d08 ("net: bridge: clear bridge's private skb space on xmit").
> > 
> > I don't know how far back Nik's patch was backported and I don't know
> > how far back Andrew's patch will be backported, so it might be best to
> > submit Andrew's patch to net as-is and then in net-next change
> > nbp_switchdev_allowed_egress() and remove br_switchdev_frame_unmark()
> > from both the Rx and Tx paths.
> > 
> > Anyway, I have applied this patch to our tree for testing. Will report
> > tomorrow in case there are any regressions.
> 
> Hi Ido
> 
> Did your testing find any issues?

No, patch is fine. Thanks!
