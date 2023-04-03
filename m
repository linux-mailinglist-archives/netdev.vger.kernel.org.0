Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDC76D4CA9
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjDCPx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbjDCPxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:53:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2139.outbound.protection.outlook.com [40.107.223.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD4A211D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:52:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGbBBCCVxR+gPkkCZy2scen0larpQL4MLeKsno/C5bkebWqO2R7KJ+bd8HBlfii/6imrKy3wb8vh7cgPyR25gFWVYheTSzxq8zY6LcSmd3kNDVnlXH2youG9h+S2zo6RppZDn0j81kKanEgw5s8cAs/Vo4YHR64GU2t7X8bkhGM28dwLhem7dGvgji+sHZd2RApKS0HBw5eB0/WuG4aVQtj+EgQxoECFlu7hFgeBiKbW5No1TT/OTwfB3SOouyxHql+xLFYN3xt3eqVETf8Qb8orLsOM8jwcWtW6ToUM+MCcEKh871g/cHAo9ANBneqRkH08nOL+2GfYhzeqQwMNJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWf5NL+vYKoY8ey2oA7jtLu6sGFstbl0wQ2/s3UEa5g=;
 b=cZKrD1CQ2wqUMz9ofkhu0vT5zbZsKOxSlcyGQQd8zRjS5rm6StHhT8qPg2tjh4pEMe+hFCBhcUOdXZb5Y4iuDZHlAOhZvoaJ4h4+NdLxC+bk+wF0m+X5kJdvTaJbfinzuzdFU3pEZAOP8xO+J+qzjqlTgma5aHpiHytDQuVGTzT4QE86nCx4JmqHa5O7YBmH1reA/RUBCdLWFWgVyeC4qCCwcH1HmkXO1TkStCjfJw+fyueZxAv0n3prSoXlOZojLQBnJNdBnpKyBuXQihCmdpFQobYB9iR5NDK8CJ9lQvgfFgUQaVoesEWcEGoZ/7KhNWyjLRihmyYPNYzp60+qhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWf5NL+vYKoY8ey2oA7jtLu6sGFstbl0wQ2/s3UEa5g=;
 b=q8Jg1FwpTspdjiID3W80L0r3UdQmPdPVGy941y/vVr80vq8O1Z+txjflOpor+n78F3aP+OlzJBWLyfQfoYsM2EY5pFD0hB3BydQWZ0WNeKx7Rdh2TdCjqf1EWKanXp7qxGg9ocyiRNx0yyJuLbllEPs3DbYbP2isBF+V3DKA1i8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3719.namprd13.prod.outlook.com (2603:10b6:610:97::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 15:52:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 15:52:13 +0000
Date:   Mon, 3 Apr 2023 17:52:05 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 08/11] net: stmmac: dwmac-sti: Convert to
 platform remove callback returning void
Message-ID: <ZCr2JbWaHJ3EKzey@corigine.com>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-9-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402143025.2524443-9-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM9P192CA0008.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3719:EE_
X-MS-Office365-Filtering-Correlation-Id: 4abcdcbc-d158-4781-9dcb-08db345b63fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JU8v0D4kv0GvTCTCuOrdk58uHUA6Myt+rlhbf7lPAT7YGeZr1A7/Pi29DtFh/gG27hqv2dmOIdvjCqblndIIzFS4V58LdVEbL2B8xgboUuE1Aln+Uvdz9hWFVWyjiMFdn3eHobFfxwFyi17zcugZqc+4hPzfJ4y8I28DaYj9NALVTbgqzhh+EHGwIO2EuzGpdK2ppDLoi6MnpAm7SqiJ8mymwfm19ldqnIVR0LMeIdJvAOpysbH74Ny0n6se+6pgFlphFq92PMjqt4rXomxF+4W/kY2ygWmwUf5xD7zWSigv2FTJKGIru9wsxCstn5YJPy7ccRN4GQa2dY2sOTqgeOEaY0HE7TYYo/T3w2JleIx+Iop3i9nx5LJG8JDBhD4G94PApCWS7Lu/N+4acRBogT8O8SlF/zACh+YvZIFD5nNgdvhj9bUTB7MvogAtdNFxbpyGvjLpUXIrY1uaIbTNmCe67q5cSKJ+vQ0TlVC1tttQL8iKUwJQxN96dvARXdyuLZ8COB4OKwfi3UfxbxC0oCBs1C2rQ6R2XHS6cyf7QdmjqrXxP5YhWLSf+onbOPcf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39830400003)(396003)(366004)(136003)(346002)(451199021)(6916009)(8676002)(4326008)(66946007)(66556008)(86362001)(66476007)(2906002)(41300700001)(316002)(54906003)(478600001)(36756003)(38100700002)(8936002)(2616005)(6486002)(5660300002)(6512007)(7416002)(186003)(4744005)(6666004)(6506007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEpOZGkvUElNV1VLNnNqYXRGbzRFYkU5V21DLzJlTHM5MXFqbS9FSjYraGU5?=
 =?utf-8?B?UlUxbWhmVTU3QlVocHlqUjk4aktYSmNLd0ZXeHh6Q1lwQzN4YzNSNm5YREFS?=
 =?utf-8?B?NHo3ZnpHeUNSRHpLT3Rpbmo2ZXVvUVRSOTJFcXF0MUZEOHV1RkFjdXJiSHBR?=
 =?utf-8?B?NDhyazVWVG5JbVdoK2s4YlFVQ0VSNFdVMlpMbWluOCtzS21HU3lBUUdvRC9U?=
 =?utf-8?B?dk1lTzNGeE4zUDlkb2xEc1BITmpQbmFKOFhBN1lLdlpFNVBuUTB1Zno3SlpX?=
 =?utf-8?B?UmFwT0hBVnpSSUU4cTQ0akJFamxDZ1hHYXo3ejI4aFRJNUdFd3hzZ1NQeVNo?=
 =?utf-8?B?cGhDNHRQTW9iYjFnRGdzd2srM0tDOWRtaHJYZVFvejc0VVQ0Q0FCT3RTMXdR?=
 =?utf-8?B?cTNUVkVuWVJ6SVhIbG9UOG1ZOENHWU4xSy95WUNiVnFwZmY2ZG1wTjVSUnVa?=
 =?utf-8?B?Y1Q4VDB4QU4ySE8xcmNVdmJ5MG95NjhubnpYVDQrZlBHTnYvU3lWdEZpN2tq?=
 =?utf-8?B?YzBxS1NBdzV0Q0JqQ3VobFpkbWllVnNYK3R6TXA3cEhGdVdIRjlaWDdKdU1h?=
 =?utf-8?B?TFdiL1JlcUpIemovMjNDYmNBM2hVSTBVaGZJUEx5VzJBQ1BWYTg4bkJyZ1h5?=
 =?utf-8?B?dGlJNFNleGtZRDBmSUR4SllBckNzS2tSemZTbXg4ZTdhakJmc3B1UTltcHVJ?=
 =?utf-8?B?a1gyNHpjL3NQcWN5bHBnV1MrRE53K0R6ZkFzL05vQ2V0dDBFay9saHh2bFho?=
 =?utf-8?B?dCt0RFF4Z1VBalNQZUJjMGtIeVhEeVFYcm9KVk9zbDdlendKUitGdFB1ZlRo?=
 =?utf-8?B?Q0NiajhKdk9EZm4rQVQxek9XSXBXSDJTMlNJUFBLbWZyOTlSZE5vMEwxNHZ2?=
 =?utf-8?B?MVZwWGxweDUreWp3dFNsYk9sSVRQelNIMHc2SzBremJVOWwrYmxWMFNkeWRl?=
 =?utf-8?B?M0pMc2piUjBqM0xnSFhBQ0ZCejRma1lHVStlUTJDUmRlUUt1TXhhY0dvRkRI?=
 =?utf-8?B?TmU4dUpiNVBHVmVMUmxpYUhsQlhycDBFc1RPT0JPMGhOT2JZTFBLR0NDY0p0?=
 =?utf-8?B?SS9seXorNnFoQTIvMXh4SHl2SENjdkRsNTBxV2VDSTNwbGRZbnFOMzVtLzN0?=
 =?utf-8?B?dVdjYVRDY015c3FtYjFxTkU0VVVZWjc4MVNPQSszM09RZytEajRSeGNHdEtO?=
 =?utf-8?B?ZmZMejJEZjhjZnFSaWtrYzVPVjY4ZWk2SE9RWmxaNHd6bVNuMTNIaG9jdTEx?=
 =?utf-8?B?SUQvRk5pdG4ySCs0NjFuSlptZjF0YmJuWnliUnN1cWI5UTI5WkUvd3kwZFF0?=
 =?utf-8?B?SGtXWnFPTmk5aUJ0c2tNbXZQZis0S0cvaTc0eVByS29aWHB5ZnhUaU9GWGJG?=
 =?utf-8?B?VVMzd0luU29PelVDaVpwN1Q5cUViK3VzRmJzR3hZS1NjQTF6dGZWU1hrMkZz?=
 =?utf-8?B?YnNYeW1EcWVldWp6Wjg4bnpQdm8vTXVzVVNrU0U3WnJTSDVUQlN5c0JHT3p1?=
 =?utf-8?B?N09JVS83LzZxbFhmK0g3SWZiVnJKYW11K2g2SkdkQms0ZElMeW9tNTlUU2dI?=
 =?utf-8?B?dVZpK0s1OFBvUGJHMllqUElJRVRlbUErMlp0N2srT1BTclpCUEhjcHd3d3pY?=
 =?utf-8?B?c2l3bGIxaHpFdDdWUVd0T0wxcGN5RGxyNTlKdm9qR3lXS1R0SjBadC8rcnM0?=
 =?utf-8?B?ZHROQ214bzVJS0hKZnZZREhSNld3bUUwRWJoaVk4M3NDSFBLN0RnK1FyUi9E?=
 =?utf-8?B?aVdXMWxDUGVyTy90ZUFDSFVHVDc1WGdNRVFTbHBUd3B4RG15aStqUjdPYmFW?=
 =?utf-8?B?RFdBTXBaR2NyUHVYemt1Rm1NbHNSU2crTlpwSkFtMHRoTVNMdUVYSTFtVHdN?=
 =?utf-8?B?a3loRy9HUEk2aHd6djhQY3ROSVMvUkJiNmJlTytIVWMrdUI3aXpvRUtQR1g4?=
 =?utf-8?B?bU9JSHllZ1EyeE0zdXhKZVR1RGRqVG5uek5PWFdZMzhkUWpZOEVoQTV0em9P?=
 =?utf-8?B?RWd3dDBFYTJqVzZkTDlOaElDdHZ2dUpVSDdnYWdkTm5XUDF4UXh4SGtDLy9n?=
 =?utf-8?B?TzJ2STY5YlRBN0o2Z3NnV2h2cEs0dVY2N1JXKzBlb1U0NFRsRmhmOHZDdmIx?=
 =?utf-8?B?Z092UkszWFQ4NGYrbjI1emVVSjhsWlZncVJLbTNNekNkbFJlcmI4ODBOR3Jt?=
 =?utf-8?B?V3lLWnRiVWFqdms1N1lMV1pxZTFFdXBSazZCQ1JkQzFJb1g1RXJRZFlsd09C?=
 =?utf-8?B?QkxFbW9Pd1IzL1lwcmp5TUhtd1RnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abcdcbc-d158-4781-9dcb-08db345b63fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:52:12.8955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMEKfon1oqXeC38JdSH7AZEgxsifIpPuBmrkaq/4+j9NfJR63RO03ol04nHYncxEw56uHUc5nEN180hAvIsIEYn2vzI92F5GG4rfE3uhYRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3719
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 04:30:22PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

