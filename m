Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD5766AC35
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 16:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjANPmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 10:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjANPmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 10:42:33 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2129.outbound.protection.outlook.com [40.107.93.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E7D7EC7
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 07:42:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNSdLvFmIWNKW5gbRpuPKczEiQwzz5DG5xb6ZJ/wLLl+EXPRdOW0/tJhSUvOmiHdc8t0rUNdk/s5KhmozxxnMRYOyYL5xUQ5vpMa13xt3erNMeMTvP5RoqDSgyZakdJt+ODi8Puti412FAc5P6o/BrAzrRyYuurhEYqkD3hd959LXX9KyyMvwJyfWHLwYZct1OJEmrm3yZKbEp/x+U6StLFm1CdQ281J8WnTFW2dhGftiBddtcTeErtqtAojvYI84oYY3TUXBmsSpJurAj4JWjM092DimiLwkdaWkqOXD6/DbS54Sld69K2LiU1g0MNoVU4IHEQXBAUoR6GZ+dXcmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrovbyD0eIU4qlsBsEtDEST3vJulvzpDaIuiNjs9jMo=;
 b=bjnZkL1bs0BNjMe/HLq8kVpx5CoBOLpiVWgwXJUsizNra6G1TqPq2wLothMTvjMDqtgBjGEydKW1LbEheSzesjsBzT3TVd2Yt5jEVVAEO+XDDst1TsSlWq8nJTgzV6rhS8N1tJu7eGNyRJxdAgFaNrkuMlqjyQILFPPR6vcRuEue02hs/QKvykEz0k0tBonk3hXLTE6k6yTCS3A2gHXyF58h/CNxTWOYdSciASSj5+BOFLAAyvYHtH++zeGvteD1gONAYwe4q5zjP0KHTJrWkxzVspXcXvCg75Ft6c/bMBv0U40zqs9As6fiMI7XObwxBYhICEGQGUNkA9rJTCgmnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrovbyD0eIU4qlsBsEtDEST3vJulvzpDaIuiNjs9jMo=;
 b=dK2O7Tjr/BfE0luEJPXvNRz+G6xz01cMXK1xDr8Vy/Ahv/e3OatI6tUDpnlrK0a7eQ0MV1JqBU4iQjZOYAKxfM5p3SucEaUG5ESjXEwXedON66AUQcFVK+JEKladEH8uO3Ag+acETR+5B7ZRVf39V1QRZ7i6So1Ag8ZsrzcxgDE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5767.namprd13.prod.outlook.com (2603:10b6:303:166::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sat, 14 Jan
 2023 15:42:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.5986.019; Sat, 14 Jan 2023
 15:42:30 +0000
Date:   Sat, 14 Jan 2023 16:42:25 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 09/10] tc: use SPDX
Message-ID: <Y8LNYWVRFK/fvo+A@corigine.com>
References: <20230111031712.19037-1-stephen@networkplumber.org>
 <20230111031712.19037-10-stephen@networkplumber.org>
 <Y8Ez09UmY9qzMlfi@corigine.com>
 <20230113093203.50235913@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113093203.50235913@hermes.local>
X-ClientProxiedBy: AM3PR07CA0111.eurprd07.prod.outlook.com
 (2603:10a6:207:7::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5767:EE_
X-MS-Office365-Filtering-Correlation-Id: b4c9f36d-3444-4195-2d1a-08daf645f221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1IApiroSPJZFgxxdix8CUbfCPklppZv5C7JqCRHtsOczD5LJg336qSpj1LhsanQo9kx5gkmOwEIEKQPc53vEqjj9muv0qxReuRUCUWsaBPuVok+t7wTcDtUF6nxaNKEjgx+YvGFvq6SdKy5dJwSEUFCuZJgV8MBM6eudtRmjnIIE7Igv4fwKe3i2u+op7gatYJK4z85zwjbmG/bsRBDciqDI9yfbOBi/hTiiiLdvp5jn4p9d27Rr4e01G60MfPQYEyDM8j/iewL48qoQYbRNnCMd7SX+z7STzz4kN7dLfcNGCzXr37qJeyYlpH7kRqy6f33LD9hFCyRryEJ4Ap8Gi8i7ECQTRi05l7jpva1/dczLrCOKbfDKSe9azuhQ+gy92EfSreGhn6nCVx86MFx2I/aQ3D3KahBBn5j3MmFxXSQrnj+0hb4TE97q/eZRMDbf6oKrz8v/hVPqpM8RM4ZBjg7S55PgBVKgL3VRBNfhGU+R9DCWYf4Tl3KQAuXFcELCErNHoo4AFcOc46rRmB/3+UVi7EPDrsO0lQNWDMAu66Z+E1zlouoyOapFRPXpn4WVriBmz8+ZQHvpI6Kv/9Fp8eQ4V7oxisY+hnMunJNp37EhKmX9f0HZ0b4fcu7zy5z3dKMajkwuYoP9fDDoRdTCw/efpzu8fqqj+8XM8OKmBAVisRyYNvT1ABS79wqdmAnx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(136003)(366004)(396003)(376002)(346002)(451199015)(2616005)(66946007)(41300700001)(8676002)(4326008)(6512007)(66476007)(66556008)(186003)(86362001)(36756003)(83380400001)(5660300002)(38100700002)(8936002)(6666004)(6916009)(478600001)(6506007)(6486002)(316002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P3UOQmta5h3ET9naFeNs/r+Ls3/GwC5DGBcI300fEmQE4xRkvhqPIrFw+FrU?=
 =?us-ascii?Q?pWpynMdtUqXgO4yT9PDconPwYLahU6YyqUcoEbvop0dvkD8hqnAw45oHRl21?=
 =?us-ascii?Q?rDqnFH7VVWa5wfoEpMpxMG2yUhq5owkXIdXyqbK9UGkJLgaQi/4DOgLfkL0i?=
 =?us-ascii?Q?g4WazGchzIHwc1ghqR688gaOaAzZd9t/D0MnWLzrPUKQSRi2s2OIb4Wx+d6X?=
 =?us-ascii?Q?CqeCrjMas6V2awqbpcnx2zFI8vTtKsOBTrTbym9SlSBsWozg/XkaXS/fO8Ks?=
 =?us-ascii?Q?lTzeqYF0ylUtyOxzezbwuaWnbMXVCzCs15Uu4Uz3OZjviTAUrIohlbWreQzT?=
 =?us-ascii?Q?yxAxW21GYxL6vyETYXMLXg4G5/RHjOlnjJQHE8/IozZa6pfXDSY7sPWo5ro3?=
 =?us-ascii?Q?OJftwrQLLE0SHGhvlrkXIcyKFno+ASEZ5oLYe8AKKPsPniyHPd6MOcHicEct?=
 =?us-ascii?Q?ySGRdaBObG2857RSQX6Rpaz5VKlgZ9nHJg+F4dh7EcU6fPhJuNTU4uvdtVws?=
 =?us-ascii?Q?KDvHA/BkEoYzL9HmfHllxk2JkJJ6azT1Vk6GQ9bMaXno1n7l7QiZSRFn6wpD?=
 =?us-ascii?Q?NDCbbQ9qWhpOh44OMxollIu6neqLMswC5hwiJG/mycZ00Cp4pxdvBWDJGM91?=
 =?us-ascii?Q?TmqqihPqt2SLw1JIUHgTExAGQDd0ENHOml1BUG4zX397+1xmaGkOTYMtJnIt?=
 =?us-ascii?Q?eyCmOK9uq904GZWMZ6rNRTlbkGWtEZuEw2B3pKis2V9YEcZqmIeOKlsqtP0O?=
 =?us-ascii?Q?FjM2AS9WOO4jr7NjoejF67UetC8rnl+UULI0cS2ELf135j6R+t2hr1uhBvOU?=
 =?us-ascii?Q?DBP15oXCCyRhbgY8YYDDqFTNz5+TBSkPB7ihnHhlBH6nprJW0/sr8lckr1rJ?=
 =?us-ascii?Q?jSyesLKN77twSA2qZp9+qv4ZoXtvA24hEiS3nfuUM/TdtGzhQR7lP6oy5GWL?=
 =?us-ascii?Q?LqhzHBnY9myZr41kzbZgmSp5w/bry2ZDmci/4YZkw4xxmxXy+TYMrLi9zFln?=
 =?us-ascii?Q?Qsgy4D0y6fU+F/XHC2/ft7fFrb8UDJdjhrk8X37RPKqeLMz/mPCsd4vJGkDk?=
 =?us-ascii?Q?Q8n9oAo222NhaOUrLkVlAz7siBpvkycrB2iIdWozidvaAHF3Zdlo95b97kTt?=
 =?us-ascii?Q?BR4W0L3DWqXFFIQaX2tYiAvVmIpSIRVfmC9ipHPBHeloxGlrF24RXbGFY2yG?=
 =?us-ascii?Q?2tAEd9soxDr2777WjFwzXv4MoeFP5Zvo8AbJQxO8rbzFmOhsXp5HBsYz0nna?=
 =?us-ascii?Q?U5/ZLOIJCA2i6rXERzYJNP8hsoUnZBsIPMZmLhQjfYqFrWOTkuEPTDlRtfhM?=
 =?us-ascii?Q?hL16syzNDwnZhnltkhUGhqaRqsOZoAeJi7mh65lcX7hSf/2AHej6H0iOv6am?=
 =?us-ascii?Q?kO86Jp2yY1JSLWnNOPyPrclocKf4TXuZs8rwLMpG3jEPKiuVlpZp2KgtqJKi?=
 =?us-ascii?Q?1mm54gns8fr0yj3LGMxZmSL66fxrMpFR98cGvuEGWYaYRuWKi5niMU950prI?=
 =?us-ascii?Q?YMgtHm3k9T8EfjlBPZdYTENpf5pVfSa9Y+Pd30+fnRUNvF5d2OL2rCZRU8VG?=
 =?us-ascii?Q?0Xg5rZeb0STP1FnGTDOyU3v3Z/v3CReQ7hpRSqGT8Lj5dQtWarHZeoeI0IC0?=
 =?us-ascii?Q?ENlhgkelgSDpSV8OxseN+OI9MZL5w8LhKKarnTaQVmRk6JNXGw9kcnVrit5s?=
 =?us-ascii?Q?nUhVXA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c9f36d-3444-4195-2d1a-08daf645f221
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2023 15:42:30.3190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnLOkj6kRLnjNL4Uvghv0sr+HwIKc2q4RjaBh9oMiBSXShLINaeY9WucIugWVrQzJYI28P6CvZDARb1IJqOJYuOLcS91t1sPmV0zqDhZbls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5767
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 09:32:03AM -0800, Stephen Hemminger wrote:
> On Fri, 13 Jan 2023 11:34:59 +0100
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > On Tue, Jan 10, 2023 at 07:17:11PM -0800, Stephen Hemminger wrote:
> > > Replace GPL boilerplate with SPDX.
> > > 
> > > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>  
> > 
> > ...
> > 
> > >  #include <stdio.h>
> > > diff --git a/tc/q_atm.c b/tc/q_atm.c
> > > index 77b56825f777..07866ccf2fce 100644
> > > --- a/tc/q_atm.c
> > > +++ b/tc/q_atm.c
> > > @@ -3,7 +3,6 @@
> > >   * q_atm.c		ATM.
> > >   *
> > >   * Hacked 1998-2000 by Werner Almesberger, EPFL ICA
> > > - *
> > >   */
> > >  
> > >  #include <stdio.h>  
> > 
> > Maybe add an SPDX header here?
> > I assume it is GPL-2.0-or-later.
> > Or is that pushing our luck?
> > 
> > >  #include <stdio.h>
> > > diff --git a/tc/q_dsmark.c b/tc/q_dsmark.c
> > > index d3e8292d777c..9adceba59c99 100644
> > > --- a/tc/q_dsmark.c
> > > +++ b/tc/q_dsmark.c
> > > @@ -3,7 +3,6 @@
> > >   * q_dsmark.c		Differentiated Services field marking.
> > >   *
> > >   * Hacked 1998,1999 by Werner Almesberger, EPFL ICA
> > > - *
> > >   */
> > >  
> > >  #include <stdio.h>  
> > 
> > Ditto.
> 
> Both q_dsmark.c and q_atm.c for 1st pass on using SPDX
> and both had no previous specific license text.
> 
> At the time, my arbitrary decision was that if no other license
> was specified the original author expected that the code would
> be GPL2.0 only like the kernel.

Fair enough. In that light I agree with the approach you have taken.
