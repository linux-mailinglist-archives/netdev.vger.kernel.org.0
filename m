Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747AF6C5750
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbjCVURF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjCVUQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:16:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20723.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::723])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702129438C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 13:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IECHqZKbRgNM9VJl2Q4tStKooeV0NoNmTMbQiisz1RuYrnmv54NzqfOnW6TaJSkT6x0MA0ol0FmZrhJ0wA06ZxmdDgG4OHDn/udJrgTpn6Ccxhw5mbK9E5hgRkbklGRxrE/sRLqunqVqXBxhPo6uYOUGK5d+u668hO0e6kWH3w/PjNFbHZHka4VakJIhSNbf5Wrh8Gj/dgTXhlYJMXZVhbjJKHeM0IsqSyYQtLYC6IUzdE3r0lLEcGB/gqeYigszIFh7ESA4jozpwH7QYb5V9BkYkhJ44s9F43+JxJMl8EVTdjfYrI01JBBCaamfCORkQEiEMfvExz/ZHJxx6ZQ3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtZ3pqbga1kDDAD1sJMqje9M7xfFNBV3JdlzWaSFqG4=;
 b=VPAPUgt/f4nxpsbHrE/Xx8CV0pOEBfdKUuZT7w90L3M73y2EwV4YsP+P+fJkmGkNl/5v2Kl1fyL0BZwrkC6hCy+RBTC3CAChRUzBn4RmIGqLlugJknWTbFPaIyTthHKqwi9+AZtNJptt0AbPV1OGlozQrc0tri6O5d8rGzqobh2q2xh+xPvJNYWQxbM3C5e2eJF/rmhFdB2On3EVTFGRJ8ob4naCF5MaTOx/XC6iSvYNfF04oH7KwruLgYBMKRFJlQzfdVMLymshZkJQcgb/DHfA3EZb36e3DjOYN3+K/2xe/bH82J/YCn9t1gYWWRIG6hpMYEhFySMU6cCVsi57/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtZ3pqbga1kDDAD1sJMqje9M7xfFNBV3JdlzWaSFqG4=;
 b=oSjL1SyBszhMOjqfpLA2TONXQpdNMLEwhvkO7JPRz+w9ru2Y9J2+SaHXF4MedHk4FwxMR7K9QOuHGTlEAn8bYCVQrouE5kNVhKWU79Rb87X5cHhBXfMW8U/CC+Ygn/3CsTPOLrIMOXPFveUL6IWpFHVhj8Z2ebMs0ZynAHX1y0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3854.namprd13.prod.outlook.com (2603:10b6:208:19e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:06:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:06:00 +0000
Date:   Wed, 22 Mar 2023 21:05:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
Message-ID: <ZBtfo1q3E8u1bwD/@corigine.com>
References: <20230321133609.49591-1-nbd@nbd.name>
 <ZBsK46vmNtjxJZH6@corigine.com>
 <ZBsQwVODyLg+x96e@corigine.com>
 <95878ada-e3ec-b563-3f64-b989241a87a4@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95878ada-e3ec-b563-3f64-b989241a87a4@nbd.name>
X-ClientProxiedBy: AS4P189CA0008.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3854:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ccbda0-e9e4-47a1-8fce-08db2b10db9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsIlAyCX1vzjMALJCabELWuQZOK2IzJrzofB2uA5Kt9pbrbs/yKsfqLTJaRwMll5/aw8XkO8wqTEdS9fa0rQU9drq5jL/wYrqZhTutnyHDOf5zhfd3BuCD1W66DcCLaRRK4XyjNjQKogj6T6L37cOUK952DNWr7gvoCS8xX5oVxOm8f8tdFinpSCrXjEfB2luhk+7A1f0h0BuRfeYfEvikbYNTrds309fFbuj7hSErqyvItLF9vd+2vzXPvmmsWOlp9W0VVt0BbseQ9RrHuPwlMEK5Pby9ax1ftjhQd5Hs0zP+sHoDg/8MhQTA+jdyvbfyUAuWPZu/5l/wOtvO1RHuIGzMc4eeLKGDe2S7j1bfAIdAJr9uvc7vKFlfc3GltwHPLZmZJKqj+b0mlFBa5GMrv0y7TNGEK2zaE8Z9XpUCxH3/C1Cf3WZyKR2OdkGqdNi1jg1dXzzcqw7jooI19c7MH8dP9GVUMzVB74QUZDqGb9UYbRSZpX0TbmOwx1zJlZ+fUI90EaaJq13EByAhWk1VlNNoJuxzNRHPzM7CcMrKpMU9NRsnBYUPQmIkcoxppwk8lXMmBeTzMrjzUzva6t2jumSMVuUYDWCRATJMylN0vbbFLcih7/MLhwBmt6FdLJ/lyxN/NR+jtmxm5z/IvvITKkVurMahrLgV5ZtZLSPe0MM+gqKkpSXy3y8ukVn8SE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39840400004)(136003)(366004)(451199018)(86362001)(36756003)(83380400001)(316002)(6916009)(4326008)(6486002)(478600001)(8676002)(66946007)(186003)(6506007)(6512007)(2616005)(6666004)(53546011)(66476007)(66556008)(38100700002)(8936002)(5660300002)(41300700001)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dhlmDVXAoUBGAutFsp+dDepyvSP/+LFpX+mPbl/FJ19vnoUcaouF3zL0b8lR?=
 =?us-ascii?Q?oEIugRa50Mu9gjGNPgWIPcc1dsYzzmfIOEYIZA+BPMt8d89pwt9LXpA7ujhg?=
 =?us-ascii?Q?wWXm1DJvIPtogrWgeiHPR5yJRN5fe3zj3UEaMZto2QLxQTW5zPSLYODREQ8K?=
 =?us-ascii?Q?Jd8Hfh6DotLtzz7ECpV5cxP7gAC8vL4dYsZOb2KUmpVPEUxonL16K1SdDNaJ?=
 =?us-ascii?Q?JLH3O9uzx/kkSxpy6UNgjqJROE5/+AKLTJvUBsm4JzsEhtZWjqS8efYr7NAM?=
 =?us-ascii?Q?eBpJvgrbzRRYTo5aCEL9o/oxR4Hb5PeBnTY2HhBdfhG3IAxPuQ69Y9Jemmfh?=
 =?us-ascii?Q?i7onW+RP0BNygLgwGZwssOk7lBI3WU3g0uR5v9iFvwIk8Rs8iPGfHiQ+HzzB?=
 =?us-ascii?Q?IMUPmD8FgTjnNi4YCCBWrKRJBi8TceG6yabvqnNBGdAGLR0SPOIHG2Bex6IF?=
 =?us-ascii?Q?FtIeL50fO6AEYn5oQbM7F9aZynz/qa9TUHcdGO+cXjx5Ss9cSPZIPkfLQ04c?=
 =?us-ascii?Q?6+4/wcfsqRdsmipup/oOYwpYSiHXeyJfJYdzojg8UyS5r5cowTImvdWaOf9U?=
 =?us-ascii?Q?TnahquEdcc7jmwkQPPlJLTSVZez4+mx3ahEk7fihxyG+Xb498BrHNLmnswcN?=
 =?us-ascii?Q?AgphTSiHIaF2ERNYQsBROXuD9EMGQjEI4u5EZFuG6qk54yeHUH0QD5Iu44jJ?=
 =?us-ascii?Q?LagqmEYT7C2DN6OYPa/XPQnsRPdzj9kgX0aEpltqGrpAjpp7HXVhUzRGe1Tj?=
 =?us-ascii?Q?pB+5Bu8Z5C4nM/b7dhZcuWqO7w6U8++CEzJi77ZxPGa7BtQSqD6zHmxc0Z9g?=
 =?us-ascii?Q?p3sqhM2UVkC6Rn2XRUQ8hkU5e9nu4Nr0yf8fsS8OAmKBWaHram0T5Xjq8wCh?=
 =?us-ascii?Q?I4GEgXJjI3OIRaiW2QSBCeTbmC2O1vB66QZSZxiI5jdgT0ATxD2CA0ePsafO?=
 =?us-ascii?Q?YBoHtp72QfUFzjDImC9bEqXmEinXQq0xw1xNn0t0tV6VnIGXeLyUff1bNTZ6?=
 =?us-ascii?Q?dK8Nj+gFieKjxbVSKu4zChWG9JRi0rzko730hdPMU78+txGDWzgyfaj123Uq?=
 =?us-ascii?Q?mMY7Wp4ss7W+8vq1RvghGhKgBwhBjzlzFoPd28lYEO1z0Ip7PPVPO4oLQOr7?=
 =?us-ascii?Q?HnJQjuWt+9llvod9kIEaywurs64Wt6tjJQdztwquow1/8i0cRutmwFi61NdQ?=
 =?us-ascii?Q?vrux9HUbu9oDHcJsWQa48Bj6gKS03VHmcKY8kxqB6u5OoFEKmDla2bPhGoT0?=
 =?us-ascii?Q?1pL2a+KLXU52TcMvg28ZW3K9vm1laDuQHI8FPGwOM24XQcpfNVlqIFlegfEJ?=
 =?us-ascii?Q?qxWx34bBHpi8qVlpnDiY0hwbSTnXUOITnElycvXgDQ7w3nhI3IPt/gKlNRV5?=
 =?us-ascii?Q?MSYZE9wDq4LJrD5PntDPn1TGtTgdr/x2eKNoJla/aNz6syZgtrxBeEXYZ4A2?=
 =?us-ascii?Q?FgTQJqhAnE898/JiEzk9w+1mBst29ewsDs37xKjAO9/GLOYVyHAqQb83ez9D?=
 =?us-ascii?Q?l43VJKYu5Hlqrkb770uWR9EHDOw+/EGA8Pb/qg2sZkyS1VCCy/1+K6/qUKrR?=
 =?us-ascii?Q?mIhne8c8XGt+sy5u0cwS5Na7DU4mTuKjkhThCNOj6KSDnDluhQKY2DejfB8j?=
 =?us-ascii?Q?J8b27X+GW/6+ssaR5znTahfFlfiLs1+5N6I7NRUFREJqMtV6LpzX0Or1YSAs?=
 =?us-ascii?Q?vluQPw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ccbda0-e9e4-47a1-8fce-08db2b10db9e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:06:00.8536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b2S89JSFQaaTgKqnXUCRW8ywiUSCbkGgTF09n5rn2bdH2qVJ516qPcgkPE5f8UOlPwyfdiFNnDYesl8SZy02SEa6vz0gQZ6oLOzSYyeCm5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3854
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 04:19:41PM +0100, Felix Fietkau wrote:
> On 22.03.23 15:29, Simon Horman wrote:
> > On Wed, Mar 22, 2023 at 03:04:19PM +0100, Simon Horman wrote:
> > > On Tue, Mar 21, 2023 at 02:36:08PM +0100, Felix Fietkau wrote:
> > > > WED version 2 (on MT7986 and later) can offload flows originating from wireless
> > > > devices. In order to make that work, ndo_setup_tc needs to be implemented on
> > > > the netdevs. This adds the required code to offload flows coming in from WED,
> > > > while keeping track of the incoming wed index used for selecting the correct
> > > > PPE device.
> > > >
> > > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > 
> > > Hi Felix,
> > > 
> > > A few nits from my side.
> > > 
> > > First, please reformat the patch description to have a maximum of 75 characters
> > > per line, as suggested by checkpatch.
> > > 
> > > ...
> > 
> > One more.
> > 
> > This seems to conflict with:
> > 
> >    [PATCH net 1/2] net: ethernet: mtk_eth_soc: fix flow block
> > 
> > So I guess this series needs to be rebased on that one one at some point.
> I don't think this conflicts. My local rebase tests didn't show any issues
> either.

Ok, sorry for the noise there.
I must have messed something up when I checked earlier.
