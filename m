Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A565A4C54E8
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 10:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiBZJak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 04:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiBZJaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 04:30:39 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2124.outbound.protection.outlook.com [40.107.212.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD19E298CD2
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 01:30:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YN+3DTnJ6C16SCNWdoG7DMZqLZcHnq4hJIHlq6JKKOOG7anAN6G3R5JNBbx7Q7vbEaopMGtD8ZiVzaHNqXIk3nqPseVf0ngebhTOy9vlpij+fyOL2Xa0G5ecVLMYJnbvmIBYG0E4124VvgpjR5Utb5UjP0Iu9jEAzhQDaJZheQEPCZVRYbhi9zzkMllF/lgUbCNFNRz1kDVU7jVorOas308+a8PtBYC+f8DieyD/qZfRk7WjGb/akNhTGd4/DWvvYKaCLel9kiwv8+OaZH3B82geKjjLBm9LmXSd488JhyiZYN9rWkNbPo62j9YQ96hxc936krotebxXLvV2Ov0iGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNi5/QFBG4G7CC+C1gYVVASgmNgNwEriKEDFr93KhqA=;
 b=YAAzn3aFCERAXJWZwyPoNt4M4OAXD/svPHIi1rZbg5G4texcwZdnAIdNGSgh2JpECKTKc7gI3ssbVCCONsFz/3LKG7vBI9af9gF1ex5+20Th0789fdo4u3KZ2b3F4wKmNiyCe/st7TKd6CiyKfQRTPayl+7KcOmRw4o6siCXMbcmv+yRUUg9xcEzZErBANOsqqtKMw+D9FB/WtzBRwj0zgRXnWBJOFOTd4EsMGcrDAS9Ncf1Wm65UedtZZ1ty8YMfD/nifUqpb5TYR1g4jU4NUjwdFiXT9/BiyUR9CzjNNMqX/PNKHbHa+UUibBxAhw9XaSRUJraTvicz2Lfsa2cPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNi5/QFBG4G7CC+C1gYVVASgmNgNwEriKEDFr93KhqA=;
 b=Zd9qBIVuTqateKehxXZn02SzxabrtXZcZu48vXKa9QlWtYhvcHZ0Y+Yl46kNnvEyxxEcMybuF2kGc+mBvj2jlOhH6ps8qCe1aFcUkHxoHfKzS1KpV+9u/vcGvyR4BIt7w2MSfjCV2GIR5zYf5gjfBVtGzY95bUIPMNxp0l24s44=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by DM6PR13MB3292.namprd13.prod.outlook.com (2603:10b6:5:19c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9; Sat, 26 Feb
 2022 09:30:03 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::bd75:57f9:c0f:3d1e]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::bd75:57f9:c0f:3d1e%4]) with mapi id 15.20.5038.011; Sat, 26 Feb 2022
 09:30:03 +0000
Date:   Sat, 26 Feb 2022 17:29:42 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next] nfp: make RSS can be switched on/off by ethtool
Message-ID: <20220226092854.GA2253@nj-rack01-04.nji.corigine.com>
References: <20220225085929.269568-1-simon.horman@corigine.com>
 <20220225074809.1302cc60@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225074809.1302cc60@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: HK0PR01CA0058.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::22) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 654189bd-42ee-4d43-ce9c-08d9f90a910f
X-MS-TrafficTypeDiagnostic: DM6PR13MB3292:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB32927CF0102D356337516D5EFC3F9@DM6PR13MB3292.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8kCn5glT+GBjpEl6oQM0NZx442goHx6LqgdJ3hVrsrSV25z/DsMPdBDXEY6rh5lNptIJ2wW43b9qwvWYTq2NDTORrYTyTm2nHNZ1eZPmk1VlLSA1dDJ9Ij5pQrvRIQarnOU1HEzN+t7DvYeK8aSxbyH7MLVZqaqq3Gjewt2isx4QPq5uOF6wLj+XRWKruVBBiE3QimiWQ85zVvPk3omyadCmBLkTE1umFiRksRr4rZ7rx0nDdonD+OX0E0eDCLnqt1dXKZk3VDyL97G8xdihl3TJm6zBcJOtBs1JRRVsc/nex2ws0BcwHDlUhwPQ8GZ3TQQKIVuqWl0zBDMlUD8R8L0zEgErQ2kzV8UR64FM/j2GbvwfGXq6aWlwsSacIG5cJG6BI7k7FAIMLKOMkE7g/RfrebLdih4AYhlekzqlJ8PZ/0/rsEkBaHtag73uV+RW5eP2mzN2OpsIg6XjA9ONGqEGTJKtZGKmT5OQ3XHXaiajeNnruhd3wuiNf7lrMFoszTSwsmDWOjZw0xe0oWOo4FxJTVShzAdudWJ3FF2JiW7xK3oscgA2fWGaYzxRhflHsu/FZbzk5ExcRkbHYj4U+r8wC4ST/H91K3m2nPWnzy6yx/mGB6dio9UOYSCRjjtJhpxGtS4emGeKHVBs8h216Jz3oD0b5Vu0YEYLUGa9bmhnfkLo5ybGs0oAypp2guvN/uR7an4BtnqbCU5x3gdhTLh7viiE0jk6BY+l21t9E8OGdIR1VeqU1jgOatyePjn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(346002)(39830400003)(4326008)(66476007)(8676002)(66946007)(66556008)(4744005)(38100700002)(44832011)(508600001)(1076003)(54906003)(6916009)(6486002)(316002)(86362001)(33656002)(8936002)(5660300002)(2906002)(6506007)(52116002)(6512007)(107886003)(6666004)(186003)(38350700002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r4dvV20Za/KWaPI5uNlY8bf8qW4Jl4A6omk6eZ6DWWIpsAnu5Kxz6QMc9n2k?=
 =?us-ascii?Q?QvKHCuaZWKkCogKUfb60ZrKlCDnFVXaAl7WfRV7nct5fztDNjqhPIMCHkbx3?=
 =?us-ascii?Q?TvrvovpH8thDS+hWM4CEDcJyjHIhOyeb9f9QMLochytsGESIL0XxiN9d0EMS?=
 =?us-ascii?Q?sif0iJmt2PasA1ZDMpB2w/WVaSravAMFRDH0Jzc18h0ElCcaQ5/Y7fiRFbVm?=
 =?us-ascii?Q?UrTMtx3msVZiDIH+DK3rx1IoEOechQ/QpwyTkHMVBoQr8akkttrS6WPjqkWo?=
 =?us-ascii?Q?qqRcgzHTs6+YihNFZKm1eyoYl9B6VdVbTU9cT9afNC3P+CtAGpWFVIxLbjAy?=
 =?us-ascii?Q?Q3pYbKrNaq3/2GoEfYBRVYtT0p9IgM2Ya+b+uvreHVI4DQrTSbgB1n3w8+1h?=
 =?us-ascii?Q?QVTIM8hIUHCDygT+qZIqcIUVJ0qOSYOPUt5mRmyB+dpXLkp+ii59ZR0aj/Gf?=
 =?us-ascii?Q?KKaQChczxacSLON4IUJsb7fDOWfQY0rylxRKR2U2BDvel1z+MvgVuvx3OvnT?=
 =?us-ascii?Q?8e2qXtSa346cySNjjfJ5wfk4rrLAYOGVMR/neBWOLtE1uIXlghaW8AhhmJtT?=
 =?us-ascii?Q?F+nHi3jz6zbDegF5iiwysGywR70OGAYLBHrSNunEBEyhrfLQyFd9HRdJJJJ8?=
 =?us-ascii?Q?y1BDaIB8TyFovu9ITvBuFxkHG9QiZftC/c82DByitflZ2/Zr6YnUvwzQ5l3g?=
 =?us-ascii?Q?Mtk+8y/+RUhtOENo8uBdEdwakQHsk2P0/9GzsmZFK5TiLHQZIYM6j+VTZ9kG?=
 =?us-ascii?Q?WmaIdxB5l0gRQvCf8zr3t2baN4nUZ6C3KffAoBFycXIUv2k5Hh0oxiqR11/d?=
 =?us-ascii?Q?XGbDtKryfXfcmyXcATGzQhplFz80QWKmaK240Yz1J3gdFpEuL3J1UOFO3JjG?=
 =?us-ascii?Q?3NHXAoSfGoNNk97cf+w93ItafJaK6N/gmIV5uN+VYbLZzESVrM+u3P2qUE1e?=
 =?us-ascii?Q?dIJiBHy6Fj6DO37EUWYKYzg3uzJZ/QFwhlM+1RF6yX9FYzedNDMake6GTiy0?=
 =?us-ascii?Q?si98YFYC2E8CK0JTa3nlLayOD6eYYg2OyNZyRPJCstQMzm7MLF+RLJMnB0Z6?=
 =?us-ascii?Q?QdyR/aWoud+dvuF32HTEpTNlv94IqPbHa1e3qKJsNY7YNhZ6wuNnEy6kZ+zs?=
 =?us-ascii?Q?8chBCPkTsDu7/5lPdDjqOzTFoqlNHJqpc8X2zJLYWEjdNX52T6WBUWdlU5wy?=
 =?us-ascii?Q?wFKyjqjDLW6VRMmRudOBtX37MSFNareBAzScBzQZ33vkZrkM65+BQqpP0aH+?=
 =?us-ascii?Q?UnSLolQfZF8g0ePegqqnOeMgkUBsg9UZtxXdRvPe5gvo6uWTtL16Vd/ygCFj?=
 =?us-ascii?Q?HU7Hsi/DiBoFha0i8pzfXTMTRgiQ2EoSiQU4HSAiYqK3xNlL4H5ucf4H5QQt?=
 =?us-ascii?Q?6ZccMp/aqGG02D2h/9weAUoG18eM8x9OplWr4Gpvmve611gf4bml3e/aYddY?=
 =?us-ascii?Q?GGadTleVFdP63wSLFuGA+3nosKIYLlU9hyXBtjoWzsqSydsaR+CHbnLuD/NF?=
 =?us-ascii?Q?+ipwivQPX7QsNyNCQUqk/BEIPQ0J00SYI8h4SA+qn3Ra+Yb1iUFSH51g5q8J?=
 =?us-ascii?Q?75JxKMw+0tz3DVLb18PnS3kSQvKiUbUF4BA5xm7MimFcannlhDgJpwxBX5TY?=
 =?us-ascii?Q?VTe9hTNeUiGzzu+63watLc4vYHhv/M+KfWIkC9fR5+k+HKcl5jcauwHMX8bZ?=
 =?us-ascii?Q?XfGGeQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654189bd-42ee-4d43-ce9c-08d9f90a910f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 09:30:03.0700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqbyiLs1E7swskNbbw/1IihWPdzEUmsIZB1xfamlKf88oQHTKmkAqjz5UzOssHHJu+Jr4KKZq5Q9S7Dgd1YUguL6/HPHf9hkNv9iL9ArqBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3292
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 07:48:09AM -0800, Jakub Kicinski wrote:
> On Fri, 25 Feb 2022 09:59:29 +0100 Simon Horman wrote:
> > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> > 
> > RSS is default on in nfp net device, and cannot be switched off
> > by `ethtool -K <int> receive-hashing off`. Implement it now.
> 
> Does rxhash mean RSS or reporting of the flow hash?
> User can "disable RSS" by changing the indirection table to all-0.
> Currently rxhash controls copying the rxhash to the skb for the nfp.

Seems you're right. `rxhash` is to enable/disable rx hash offload only.
But it seems that some few nic vendors also use it as the switch of RSS.
Anyway, thanks for correction, please ignore this patch.
