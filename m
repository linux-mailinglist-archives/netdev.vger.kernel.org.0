Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A86D3902
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjDBQnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjDBQnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:43:12 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2115.outbound.protection.outlook.com [40.107.101.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FAFDBD0
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:43:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rk77sTH+miQ1TSPjjbeftTtNsZ+tRltTG4u5siBeeFqD9+AnfbwfFwWeqsB/mCp/7SChAfmcZJuZUPFy0nepwHYs87E7NddqKN+rBVrGBAkZSaA0Y/Tbup+pbrbZTsYJmAhGsEFa3fQO2w78e8QR0/akg5BQdAm9ZaQvp1AOsG91w+FISoawMO6dE5IpUK8ZBFvIjg6xQlDj4r1YnwFNHEX+Yf9p47eUq2s/D4X2YefR7qYo8upjWuhvXcRIPEHOpu9UiU/7z/qmFNWwUkYYE8hv0+AUgZZjS2etrzCOw7TT0VQTv2kzGRPIClEeMT99YYfrmGuHsYmZvpvPzLTBqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNuNJpfRo1bRnYq+Z4cf+1n2XUFyfmRym5B3AiYh6XE=;
 b=YzuGZXpHDCcyemBu1K+iJNlZY8DkO7J7o9CVfsZGQfP232oxpJHrPEo1iQE8PoGaYWAiOWAG9AzlHqt1zlob65BPddMuVlkw544t5/bclgcD6qxP3CnzWRAcfSZm3/pEkzxKb0MVL1Hgq2A9uCVaUtD7SL5OMHpOoBZ3OiV0JL8ZY04HOeu7cI/Dsqp9Iq7bAVhyCin+Ukak9wYYaN43vaZslsl8B/awKQVEg5Z5Kam/TVHKltxgaiO/UXKLG4KTUy1fWN/gwooV111Hj8sj3RA2/9H9m8KsogfN42Q/ETMFGUadSW06+fKL/uHkIyuSvaDGa28/ndt9Q/eo27EG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNuNJpfRo1bRnYq+Z4cf+1n2XUFyfmRym5B3AiYh6XE=;
 b=h39JAgxEWB42iAIxdltQg63Bgvly3JMPnN8kNg+uKDiNFr5KfXSsfixwY/2t7NtMtKLnMsWaSkzqSShmz2kw2kBY2EvRdBslPDQ8jM/if4laT2Q1gQP/VDxrxvjBpNWs+J0IipJeBLG34yAkVqUUrY3d2Zj0nkLbf3iyu5LZTVo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4160.namprd13.prod.outlook.com (2603:10b6:806:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 16:43:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Sun, 2 Apr 2023
 16:43:09 +0000
Date:   Sun, 2 Apr 2023 18:43:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/7] net: phy: smsc: add flag
 edpd_mode_set_by_user
Message-ID: <ZCmwlu8DQ6PDVtwS@corigine.com>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
 <61a0a91a-2743-52f0-e034-e256415c082f@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61a0a91a-2743-52f0-e034-e256415c082f@gmail.com>
X-ClientProxiedBy: AM3PR05CA0142.eurprd05.prod.outlook.com
 (2603:10a6:207:3::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: c1e4ce1f-3c7d-4b78-884c-08db3399574a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LFV/vEErXi4Tn4uUMJWaYiZN6QYdkx1qTwvI12ny2tcUgaf53rjgrp3baEr8eSc1gz6fOTOUHHBsvT1b4CqCw43S/gG8OHbYPoFepmVY4oW1MSNTAkNZdLv82weRmUuGGc7SqYdcisa5IYmxGKOflEuj5td/nBnDfi9pi5nkS4RPgjDB36/bEWk0P8R0F8aWNBtdEMxLWxKdo7J6xPJvsnBPtiNtf1fwipIMWAyCOJIo4suksyWskyNc1A0psS+PuRKZ0Ixop9hj6wKHcR9OGtiSET0ZuKcd/0bJcQB2JvnXx4uZCJO+ZrWmwFd6R7gtgrI4P+74TGmC07+jVHmzvkG2FNG8Mcd3Fw9Xh2XNegd1EthzclSFtah/EmVz2CEq5l+IO/gZP2cKjChhjeSCKX8O5yB0g82UIHr/SLqytfs2/pUq/5hG41JvtR6TPa4smSrxMg1eG8f/oVE9/AkpTJn1Z9+Vie/6kloIEaG84iQ13Tg6IE0u4U+gEs2D/hYYtKvyO1LHYr+k3rH7dF6TJUXntrmgAlgq3+DqoVXzFgFwf9Ny+zAPiJDoy7Kwz6PpYAnA4c4i3BEvJSkmaA0Mx4sDHPuxiIOM0ASmNCkUKNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199021)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(54906003)(8936002)(4744005)(44832011)(5660300002)(41300700001)(38100700002)(186003)(83380400001)(2616005)(6486002)(6666004)(6512007)(6506007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CwsjhM44OsnpRci90xHAdPsGc4ywVc2tSMZLkCqVS/jLWjUC46TcV1mTFeky?=
 =?us-ascii?Q?KK9hNbayKLA3gPBNxTqdO2amvwa8xdHzeWsvxKq1EqQ/Ybgod5UiJnJqX+Y6?=
 =?us-ascii?Q?yeAJRzGOlA6fXgrXAOk5qqrxd1k5T8ouROVuZyxpemvYNQxPxqudbM1LUqSO?=
 =?us-ascii?Q?i3UrWppPTM2INQq1tzIw920JRL/d+/a6oEPkhC60nyBnYmhJ9N6gK6VeV90N?=
 =?us-ascii?Q?8cI2XiLo8m4LP3xtKMwltmOu9LEGCU/Itav7ZBnWkpB5XySjnZC4l7P//sA9?=
 =?us-ascii?Q?rOPFaTzl3lN4uMgrf+0yaNo7KtG+tHNjIZDXG2UHAnXTliMDEIJrJkrrpmNb?=
 =?us-ascii?Q?P1QeZAv33X286u40Vu70RBTyIVGs8uK7uhEFCiwskjezIpOG1uSM7ksRba/k?=
 =?us-ascii?Q?gnbY31b9awpg2ofFCe/xPS+iqh8G6q3bBqmcnwnm00NG4DB5cD2IyKbixSTa?=
 =?us-ascii?Q?g3IkIPh21VILr3Q3/iyl8Z2RsC5tEsYQfN6kGi5nS6Fnsw1gPQtZy5vHeJMq?=
 =?us-ascii?Q?JSZGkjX3xSu71x1Bl0QMiN4A6cHnPUZu/cl9fBvUVehBrb+qeKaVWXLCFco6?=
 =?us-ascii?Q?hgzFFbaBNnWuGwSsW/al68R3G4CjSmrrDnf3au09QvAqEMirwLQrRK4+f0BY?=
 =?us-ascii?Q?MKLs1Dq5eDTUfy0jAUOHUVkPGoeL4FWnhcCSeLrPYAgKn4ROj218KXOrW/LY?=
 =?us-ascii?Q?8LPAcNTIve2N1/oiKBZtfALs2mn6y6A7eV6G+vwl6+d1yUzX36HE9VtRkKH2?=
 =?us-ascii?Q?sX0oJVrJIuceShdIQtAHnMH/pSinlVtC97ILLwTBgICHc0Bv7F4r9NwhrhJ2?=
 =?us-ascii?Q?C30oHYD7wJZibJAMJbPHRMdQLg1m00TiRp1OlufwrjA/JmiA6KzdfKZTfUVP?=
 =?us-ascii?Q?DhiAE5+V2E0kmmcTesDNVqkw2TYK22kzF5wHpNA6NHYq9HjNeZYWYNRJNzyo?=
 =?us-ascii?Q?gGV1Y2el79TGYHHOtAFp6G8sw4xrCFHDxM8AlLWCJknO7AcdIox26Lrjtudk?=
 =?us-ascii?Q?sI7Pmn+9nb3wP+AW9iDuacDLZM0PgaDZW2Xm4dZal2th0nMro6UuQhHZDIwu?=
 =?us-ascii?Q?KDCDxTrX0jGLG/jhFeSQ9GdHaLMZUsahP5DSzPxZeW1fqb+kak459Zm9F9L/?=
 =?us-ascii?Q?0e9nqYHe4fU1zkkPK+TqM7ovf6hrRJj315Blz/wsLuclojo+rhlULEO9ocEQ?=
 =?us-ascii?Q?coTnZ55PiPg9xGyfgBeYT3IRZBmUzKDELLVTHXxFEsnffaPNDgE6sAGvsoQc?=
 =?us-ascii?Q?+kV+DOfSyxvE7dgx2EzQURQYDnT+o4jSHnkv35VdspKy4qIAPSm+pyu7OvPI?=
 =?us-ascii?Q?mNm8tLHTWcruGRLwwCt0Cu56lmMnXvJAydinhG9WxZHxGssrlBaMBjh6eOBN?=
 =?us-ascii?Q?Oi0B2QcHk+FiuF+OeZ1+Qe/MI+Ao8shpH0HracYCRTxCO/OXOr0xT0GxDatY?=
 =?us-ascii?Q?/0A7r+yA3MPrc0sBfbW2f+uBBDzN9rTL444yXDeN3VP2fbGUbcSx2vWTcEk3?=
 =?us-ascii?Q?2HmwWOfbZV/2izbXcEa931bkWYfVDwZDjBZxbvg8Tz5GBVakKXbUUkrsmmIk?=
 =?us-ascii?Q?+MP3JRwP82EGgrlPGzU+oCf54edIygOuVcv3mwfhcg+8+NfGvYSs2vIpSgQx?=
 =?us-ascii?Q?fMhdpr9lBS46dfCuiSZTFytSVGEYq+0mkh+w8IdGook3vDCVBvBAlmrC9hna?=
 =?us-ascii?Q?GGtXzg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e4ce1f-3c7d-4b78-884c-08db3399574a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 16:43:09.2212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fudOY3oQTjhwBu59Ah7E/p94eH80Z3SSFSXmvkahbnYFb3oAkr/H69i6jQuofUBrY3bK9oyu5tk4FQiHUc3/ulEqn1bHDYpiCDSqxu09ioc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4160
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:13:35PM +0200, Heiner Kallweit wrote:
> Add flag edpd_mode_set_by_user in preparation of adding edpd phy tunable
> support. This flag will allow users to override the default behavior
> of edpd being disabled if interrupt mode is used.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

