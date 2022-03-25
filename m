Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817DD4E7807
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 16:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376902AbiCYPgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 11:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378692AbiCYPfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 11:35:31 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2099.outbound.protection.outlook.com [40.107.23.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832102E6A5
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 08:33:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fd8HFk117ID/+njxp1F+Q1aZov+2Hj4CKByDbB/ms85j2qgvlFpQAB2hh1qsD2L3ZH5wXdTWtqeg8cN44wuC81BVALeacfoi8UVsNcNJWA8Tq8SooEk3GpGfGEjUVJIV4uB6Pn2dbWUGFU2vbpuwSZuIQR+YkijX9aBAz0pNHbHB+qtBAS14do9knW2NMdI+wHDf9jTw5173+Uen0D89lVcvgXXNVorWkCW2q729WRYbNp74UmhCFr530GsW64Y06myyaptrGI7KmadPE8fwnPp2GH51hCtPV9acQ+a0qTu9hCNTM+osQNuT9f0HHVYcqsKVbaGRk5+TUwOgKoIFzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnbswNIHRrIYJaiq0YYns/DmE7xQAp5t+CRzg/NekjQ=;
 b=dLS3SL8uQoezEa7Z06gxiXcbgPL96mf6Ur9Z0J0oKO4het9ecvecuZFQy0aLj5JluPN2J8eHQG4UqUaZAUgckz7Wz7ramqsmVL9/wEQDlFc/Jf+iyVkec4wNw111bk9aFEH/fqWfFqmMxQNjAzFtDfuKPz6GFaw6eSQFfgZwPVKRAnhDE2huvFNR4DWn4MvdTgbdgfQdZFjJ9TGGSK6bqQAgikv9EOLDplxRiFbpJjUIh+1G7lgIJOsrncNIZJ8l/wnWnCBvIQPs7ZoQzguWlA8EO+svd3QAKwig4LdXyI/oH9zOzFoRQnkOKmiYhDjBpkB3MJxpIUd9kG5JJFeHrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnbswNIHRrIYJaiq0YYns/DmE7xQAp5t+CRzg/NekjQ=;
 b=G2YqzRkhHyfAvXBFQUte7K9t+npreUWV9/vF0tfy6twPn0dv4NXwAEr3pDbOv3Z4iBl75OxxM7+nUfJ0fS/szV4fVjGzpUcCCzacYJifrhx1D3pAhkk6S7WSBQtKuIBDkDXLkGQMA/F+upsjxcFneBo6+X8vtDtBHFcfORJTNHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GV0P278MB0082.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:1c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.17; Fri, 25 Mar 2022 15:33:54 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::7d6c:79fa:a2e4:ede8]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::7d6c:79fa:a2e4:ede8%5]) with mapi id 15.20.5102.017; Fri, 25 Mar 2022
 15:33:54 +0000
Date:   Fri, 25 Mar 2022 16:33:53 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <cphealy@gmail.com>
Subject: Re: FEC MDIO timeout and polled IO
Message-ID: <20220325153353.GA1108006@francesco-nb.int.toradex.com>
References: <20220325140808.GA1047855@francesco-nb.int.toradex.com>
 <Yj3c+cDzdvsUbYtp@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj3c+cDzdvsUbYtp@lunn.ch>
X-ClientProxiedBy: ZR0P278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::11) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6ede99d-500e-47e5-159e-08da0e74deb4
X-MS-TrafficTypeDiagnostic: GV0P278MB0082:EE_
X-Microsoft-Antispam-PRVS: <GV0P278MB00824BEBB947E6BCFCF8C830E21A9@GV0P278MB0082.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJ3d2j9RoMhsYy7r5zWRPvFhDPfAMRMf799XqIExI6WvkWeapq7j3Qn73z/Tfkoa0ZWybpH88DW8CORUbqrKU5Nk1GEJNuNNyxVagwoQ9NmoNP+BeuewijGSi6rMDjbuWQOkWJhaPXFwG0/CN1XKo4EG4M2k63ZcFF3GFKwJTIx7CSfdw6dEZheXclEN0L6AFcdhu292kOBxFYDQTF3qBrkulBjOnqTqluAS+tTkTOI1OD9SwgFO0IGeF8WKK9PJpsLxHzIb+keYh/wtEWug2uImO8R8j9gEFLkPqF3JIp0gGuKmfBZ1FxHz8tQ84Wo76uht2BrER5pe+e80cis/ImcgcEu+bTrHZxIXahn435DKliKgE7xXLn4kkk23Mb4fgQ6arfEzKtXFu07cU/1ZEHsW+jfKmfGn1tyT9qXXKjedr/EEDUuOg8mN8tAMIcAieWpjVCZrBs/triLFqt0DNTaH+zFlPLinc9RkVVaCQTkubxyahXtMvJRg0mzWEp+NBzBNYVRw8u1ZJLWhGrD4TQFi7AlnH835HoYv0lGT5hDjRfnEvc8CRvT8L8HvD5qDAGf4ZFDWqwrzOrPLis0iT1+EfBQ5En31tOBh8fEYOZ0NW0XBVOneZnFI+IG5AODKul9BQFnGXqJ9YL7km91U7PlZmFo7fJbQW2ndPsH2md2NkSNEwfcPRo8sKk41/GhhUl+MyBsY0uPhMFzrccoNwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(38100700002)(38350700002)(86362001)(6512007)(5660300002)(54906003)(6486002)(26005)(66556008)(4326008)(186003)(8676002)(66946007)(66476007)(83380400001)(6916009)(1076003)(44832011)(508600001)(8936002)(52116002)(6506007)(33656002)(2906002)(4001150100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PoSM6cDy5Vof6Tw1xMgH37KZkXA//gzk/K0qpAfr9KMSxm66S31uyPQ3p5d?=
 =?us-ascii?Q?5+MMaFmgJ9fGREpzl10P10m2yqx3BK6aq9MCH+IYbdLSUlTQFW6Z8eRXCVFZ?=
 =?us-ascii?Q?7Xfzh/htguvLudQ+uClz0CppxWWtUyL1xfEUQ+Soq1vcllXB/awpytYLSHas?=
 =?us-ascii?Q?E6NZ+QFcx/QvC/2+oOUJDiuGV0Bhq0t/w4UsuHMIJRCCH3EG5EY3jEj0Lp8+?=
 =?us-ascii?Q?GS+5DD2AVoAU793xuEfEGeKK0TRcB/lBjsHbD41dRSN6DbOtEZhxjhlwzbwz?=
 =?us-ascii?Q?S+9JhGU3Nap3ZiXXBpximM3lglVWQMsdHx8nVFlZnqksYEOOebd7TXfpU52V?=
 =?us-ascii?Q?PBrlL8k6bqTYokvfxBbL0y9tJK6Y54aRNMls9rBOvVRPFGkztIoJL4/7gZIB?=
 =?us-ascii?Q?hyRTUKlqM5XYrDM1aHO4d94i5cVfuIpSpiI3RiCIjagqxp/+VlNOCdVz6iJg?=
 =?us-ascii?Q?THG0ZRR6x+ZIjnmCyPBKsA1LfNnDXJXbY1UKAsdsQiMsSIdsaEbggewRi1ir?=
 =?us-ascii?Q?8cwmnDPhlm6w5Wrb2LDbYN75s+aeib9vjPiQDqqLzkbL7Z2P2Su1nyf2aUlq?=
 =?us-ascii?Q?OdnfzASRgn7k/5rayn5ALOungnOOIRVJoIJWCgMaodyh8ZtbR68wSTd8I8tw?=
 =?us-ascii?Q?lEVTGdbgYPLdXSrBzOf/9RY9DmaIEKeNV7k2JrlGnIXDCp2AqCIoItw9AJ8Z?=
 =?us-ascii?Q?ZHJaa75POHJPnXhFtvsW5tDtjD0gcslYUSlBSKNnmyzYDndwAJTDGw1Z+Zw6?=
 =?us-ascii?Q?HvC3rj/+UTh15oLoX2nqdoiS0IRSV8NKQuTzlCjl5EPUoVQmPR8ZR/1l0IA9?=
 =?us-ascii?Q?j9T+NlPLoEfIf96IG6ySXsvdYV6mWT9UfzM+OntQcfvtTAuvjazozC/mY30y?=
 =?us-ascii?Q?7nfk1TZHt7B+Ozryn4Nt0VSw2aW/2Iibb8EhzL8SqWZVmupaC3frNdKew41d?=
 =?us-ascii?Q?KeZEeSi1sHGdo4FteGfndmJ8sWLAncv8tCEXyBsx3AKlAg0YzlaL5Aq2xTBs?=
 =?us-ascii?Q?R7iFlvwuWtkcN60zKduJB4jIBTwyMu8zhvLvZ/X46DckPrKKb+vv5Y++hxGZ?=
 =?us-ascii?Q?ud/RiBhgA+gBgf72CJqKsmXVE0meojSdY6xjqOi9jc47uWU5IXCtT0xCCq54?=
 =?us-ascii?Q?ygjkcswn3McrT3vRJxE9gTEutcGMpIicVmJ1cD206yBLhOFms6aJLMXcOvTv?=
 =?us-ascii?Q?UBTUari055B32hnxaYJBxryb8jDktNAfCY7dAac4eqSenHJumIahErNo4SCU?=
 =?us-ascii?Q?iHH4XkA04PQF3z4O89bTf1GKzUDexgRWGPibK5upuqbOXttX0cIPWmKpY2y0?=
 =?us-ascii?Q?dAWsb1SZ9mD3sG2qCKgph8gRJRySIQ7A9Jm3J6fUSKxfvlVdeBd1dtzfm4gw?=
 =?us-ascii?Q?Z7A98XtEwM3QX8Gpu/R8s6OQl26pb/+puIHPMxHtWdw+ztaZkrRZ0jUzIblu?=
 =?us-ascii?Q?XpUlf3BQefQPHzzh8Y0A8eTbJEPqrc/KBsIkhQZOs521XfrhvN5L5/+NIGV0?=
 =?us-ascii?Q?F2GN9yAp3P3i5hTGag39qOEJqq+NSzSFDrQKu1F6l6uwn8eKkBEyMqJ0JcUX?=
 =?us-ascii?Q?OiCHDqgLfY/DvKZ9uWAkUHheUJr1GWpku9yU+uvsjWLZEF3zM/gbe44aHNPH?=
 =?us-ascii?Q?kLcEkw9F2WowTuN5i1y26bEGq/Ys7/VyklNjm4vr40SKkAgBhlHujSLzlhce?=
 =?us-ascii?Q?jyntSCyxbktrmLtsNw3OM6QJcMaRg3YJjlCMhklcSRELdV4zw2aZlOXVRrTL?=
 =?us-ascii?Q?C8WjULzFhIC8wv69GuzNiZXYCyrn4Hw=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ede99d-500e-47e5-159e-08da0e74deb4
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 15:33:54.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CfBLnG+xMRx2D4paUslJywMaJpXV+3XSH+3WFsF1jLGtmZQKa15rOVOUBCx4Rq1Ft32Ebr+0drhrO1jM5LARsv5XEQnlkK6uJdWFpGDaIOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew

On Fri, Mar 25, 2022 at 04:17:13PM +0100, Andrew Lunn wrote:
> On Fri, Mar 25, 2022 at 03:08:08PM +0100, Francesco Dolcini wrote:
> > Hello Andrew and all,
> > I was recently debugging an issue in the FEC driver, about 2% of the
> > time the driver is failing with "MDIO read timeout" at boot on a 5.4
> > kernel.
> > 
> > This issue is not new and from time to time appear again, it seems that
> > the previous interrupt based mechanism is somehow easy to break.
> > 
> > I backported your patch
> > f166f890c8f0 (net: ethernet: fec: Replace interrupt driven MDIO with polled IO, 2020-05-02)
> > to kernel 5.4 and it seems that it fixes the issue (I was able to do 470
> > power cycles, while before it was failing after a couple of hundreds
> > cycles best case).
> > 
> > Shouldn't this patch be backported to kernel 5.4? 
> 
> Hi Francesco
> 
> This patch was purely a performance boost, it was not a bug fix in any
> way. That change also caused a lot of pain. There are at least two
> different implementations of the MDIO bus in the FEC, and they
> behaviour slightly differently. So what worked for me with the Vybrid
> broke some other platforms. It took an NXP software engineer talking
> to there hardware guys to figure out how to do this correctly. Which
> is why you will see a complicated patch history.
> 
> I personally would not recommend a back port, unless you can test the
> back port on a wide range of SoC with the FEC.
I can test quite a few of i.MX SoC, but there is more than that using
this driver. I do not see a reason to push for such a change if you do
not feel like being a good idea.

> If you are getting timeouts, i would suggest you look at whatever else
> is happening in the system during boot. Are interrupts getting
> disabled for too long? Is something blocking the running of the
> completion?
I tried to do some debugging, but it was incredibly painful given that
the issue manifest itself only after a couple of hundreds boots. I also
tried the very simple workaround to double the timeout but it didn't
work out.

Bad enough the issue started to appear after updating to a more recent
5.4 kernel patch version.

> Or just update to v5.15.
I will probably just keep your patch in our tree till we are able to
migrate to a newer kernel, it seems to work pretty well (and yes, I took
also this [0]).

Thanks a lot,
Francesco!


[0] 0f0011824921 (net: fec: fix MDIO probing for some FEC hardware blocks, 2020-10-28)


