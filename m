Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18776ABDEE
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjCFLNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjCFLNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:13:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2132.outbound.protection.outlook.com [40.107.223.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF391AD18;
        Mon,  6 Mar 2023 03:13:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAEmqANv5qgmGwlqDnDRtzcw+wRXsvzFKqqRbLfOXC8TM6FGFgloJfZxFYdFC2j7/opoqeQ7DGvSNiCtL0mDa4gBQFIJk2zRvzEFIbgCaV4LYaHUCiexPf1yqFbhjgRLcPB/ePQ0QyjKNAckt/2MEYjfNLOAvLIw8ZRAa8tVTwlxW4HPXgpmw3kicVLoNVdkm6x0TtPc7bcQ4a2ZbHLShSTwGq2PAC+sSRcZfwmNvKqv/l2sGy7H/hn2oSRzhMlyicLTgGfyCxE/cAVvWKTe1bPq2yzXs5c10k1GW7pouDAFTPw6p+/VXT7oUTF+74I6KjE1746pKCivbNxvsUMyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zymKDE8g34EADkjEMn9VR7rUNQIsir0LX1puGJSF/Qg=;
 b=KQNBZkxUA+EBjkFOsh1mTDIVbYwAKiEBMIugLla1Cu5wKqNQt4L5UlyJT+E0jxBDcMQ8hhLxpmmUNe3zU+BSLuhGCR8uVquRiWjAJ2yb9tVEpCKLADIeHKzfkmU5vhC2ysxnwMSqUT+4NlYKFZdZxzKhqqj2QFxKkiWe3PKAcpkJ6NkgTCR3/1C6ysAJp3tzMVnH8CJvvmzbzIKcoyfGkFLbz0wTYGQ/MfJB4CJa28FYCf3qJj6MYkXgMUhgEDtL0vDYBylsX0VU61KBEvlo/WF80YxX1Y47v5zS85Qhj7zyKIwKfv9sQjHJONhmh5W6F7zdRDz6XcfVUa+Dq3gs3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zymKDE8g34EADkjEMn9VR7rUNQIsir0LX1puGJSF/Qg=;
 b=tcmrSJq0565nfhXHCkt0ZHsEB23OWbtI+szf8/+222opOtfVWa6DS52ncz51QJm8VWejR5IhNFvQFdv87/xvDYDCQ/p1yWuLMEMV7sDaBgu+dVUHnOs+NvbeeIjZKsZKNIuGeVQak+EVBYJvALaNJPIBGNVb7Jq65bG1dz6Py4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6184.namprd13.prod.outlook.com (2603:10b6:510:25b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 11:12:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 11:12:49 +0000
Date:   Mon, 6 Mar 2023 12:12:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-man@vger.kernel.org, mtk.manpages@gmail.com,
        alx.manpages@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH manpages v2 2/2] udp.7: add UDP_GRO
Message-ID: <ZAXKq6DD/aUQ1kTz@corigine.com>
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
 <20230302154808.2139031-2-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302154808.2139031-2-willemdebruijn.kernel@gmail.com>
X-ClientProxiedBy: AS4PR10CA0014.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6184:EE_
X-MS-Office365-Filtering-Correlation-Id: 50af6d1b-1369-4f98-9448-08db1e33b8c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5eiXDpD+tGlpoUvAgbY4a8OJMEPHfzXHrRPXtTVDEqC6Jr7SMdwdGVUtBcVhXvZvWPO9is8MIFATRA+yOpKP21+bOkzYqqMzydLudeFGe4HnjaFDKsxBPHXXKPBt7TYx2G6AjHWV8kCNhbHIA4C3kCHt9Y6wI3DJsRZwIyuBYc/MpSyPrJqVuIMiUMu+iYrJyx7/RgJUMDtnNoJCHbAFg3HesCLd4x/dyM69OwWaWdXSHeTHbERCaM1l5tfCdMLA3AamRxxiwDCMBEjngYhhhXkStVoWf6owgNgCA1HMUCsndB5ubva5bq0mnR8u6rqxKWR+wyi8Todp1Q/Em+I1BKIceRS94mI3onB2lAqJUYiBx1xuR1LKrch/SloscDsnRsigket/m2WuRXSDXRD6FNdCn2BxoiMRsOHW+SXaV15gytp+e0C+Ry5sakMv6eAU0IAGeKbSyQJA2Sy1nKSihRJgZqzae8UcdN09z201xKKZOy/+x00fy9VZVtC5gHiU1Pv9LvNKu9DOy1vpcMy5XlXvgreeHiBPFZOCjsoG8H8t8T2TXIz47ItIU2xMPNGMJsdbMha2TEyccw0oXovaqUfBv7Xxd8ljgnx28tizghpjlyVCIv1gIUZK0EAXYk9IpsB6FizbDPfU6xoY4ZjvBHzayNJquYde4ccVJer5vJ2dorzri3KziWkk7QmwZRgP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(136003)(346002)(376002)(39840400004)(451199018)(6506007)(6512007)(6486002)(6666004)(36756003)(86362001)(38100700002)(186003)(2616005)(966005)(66946007)(66556008)(66476007)(41300700001)(4326008)(6916009)(8676002)(2906002)(44832011)(8936002)(4744005)(5660300002)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FjXckrV904xl3OdliB6RxmyMIpcYPG5RXVdnMVuqvTj5hgVMUQiDK5Ud3UKE?=
 =?us-ascii?Q?GQyt1dod/plRxUE0xl1TXnAYlUZhg16ITIPaXukgGf6bUcw6DEYvHpx55vpr?=
 =?us-ascii?Q?X3VWVCGKz4rah9rYbhHfvZlKqI2/F9gR0EpHLAx7Les7bXcVJmjIWF27lm7f?=
 =?us-ascii?Q?K65S+4WYvxgku+HxK+t96bV2nTN6rh8bp4Pf2zxUXEIs/6eY1X/0S2Jg+Eme?=
 =?us-ascii?Q?e9sQWBFVrNYk/SZmyw5cC2av50kspmy62okigEbqeWCdL9p/xsVyecm7tuyq?=
 =?us-ascii?Q?oujsk/gLhpQ7P1RxGAzRegciP5V7xfIwcj9S/CJvccdx/M/oza0QoPIBYCLl?=
 =?us-ascii?Q?txns69MIeys/NPeXXroMa7JuZvz+9rbteT6x5jArKKxKVpqqmb7zhGiuIMD1?=
 =?us-ascii?Q?3HfsIbd+Hwalwte8809czaAfi4MSoRARFTddH8z7HZqdzjz8wr5pQCHOiUPl?=
 =?us-ascii?Q?jkvIRcRsQToPvzgSvb3Grjcv0Ghyk1pCcStvWBDuyJm+Kt7Xsme9i6qhXWd4?=
 =?us-ascii?Q?irGXSjQMx0SvkreRYcQrWm7yJKYtiA5FraWSZ6374P4ua20PRQdrEOvEoam5?=
 =?us-ascii?Q?nefU+tuaIXTglOXVoSefJhuQFGH8Hr6LqQaaBY4aRlzbfWHQmIebRodS586O?=
 =?us-ascii?Q?sicPKbSGzsocW3h3WyvoY7pOGnw2MV5dpzO9oUmJqfKOk2FJ4RRX2J3xHh+8?=
 =?us-ascii?Q?eQnsqOkMqZjrrtgfm6mNufXqBFIwQzYUZ4sZ3ymQzPuMjxb+1mYiw/MryC5l?=
 =?us-ascii?Q?GaSKvKVYkThzHoDhJrR0R1GYdISqL0lPKtdKbiHF8ba9EMAVABmsRi/APSZg?=
 =?us-ascii?Q?NvNc9ePbipWZdDW7MMsYY7BESG4wQRz/oyN1lv4KhYNcFJr4HZ3SO3VSwSUK?=
 =?us-ascii?Q?EICgG2gLKCaSmMItke5RKOXiDPS0uT+vzJdjHFcC6PT8BT2WEMdoN+BYxVsP?=
 =?us-ascii?Q?8YAUEt6DCLFcLvyr2bJ8aGNGXCeP3BQFkf9iL5sNmNDscNR69ea2ypIvdE1m?=
 =?us-ascii?Q?14vSTi+ymqVasrlOP2fk2b4lnY4iYcm4BdPzMe/YZfz9bmpklTU4JV1In1Ak?=
 =?us-ascii?Q?0HJHrKYLm7FQElgxH+rS94dH0mnmnWrtta0rNfr2c1v955HcsNA+U0Kad8Ga?=
 =?us-ascii?Q?ihjVwmXlZTLTeDHkxYDlf/yPDqGbz3lGM/dM51ZSKD6ZVIBzF7Owfzs4qkmC?=
 =?us-ascii?Q?MvOg6q+OUjKvnWwLhLTFJlEJ3VsEVIxxHaMOlP1uVcYs/8U67Rr7OR+i6vHv?=
 =?us-ascii?Q?Xk42DJFKpqDr+B8EBrWJ0Yhg0k5lA7n5XDXZ4QGMZFgvhdlj6hkw4YxUfcur?=
 =?us-ascii?Q?x8OxOdd8RfT8M7WmrGyJhtd7pReLNSBRDC4d4dfuE4z5HtmBCKWbxBTxpOme?=
 =?us-ascii?Q?Wd4S24p+8xkcK0XSafOZuC3TBoDL1JcZSZ5CURU7MS426xKjzR/PzXiUC2pV?=
 =?us-ascii?Q?hTqcaiquKUhTryF/ZoAeWM31CvgCWL2JvQieDK52Le4nUiOxihA70bLwWAUm?=
 =?us-ascii?Q?iORvx9xwDWrmGj2xE+mR5174zEYPzxQdN1czXeoDJxVOoJVvdVuMz9Dm3Pqz?=
 =?us-ascii?Q?Qa5DgYR653TRwGvfkwn0FitTpH1DtM+JLtx+JVmgXQYfN1GfEGtPjE5lQ/f4?=
 =?us-ascii?Q?/1nCWqPKpKL4PDMFYMophHDXA5nH5tJrbNzFmz5zB6O+O1n6kQmv7Sy1TRWO?=
 =?us-ascii?Q?htYbWQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50af6d1b-1369-4f98-9448-08db1e33b8c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 11:12:49.7300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsXKsoKENxF7Mo2o0AYFO2M3acC4JgfplfXcfJ53VbVoj34u5L1luV02zlH04uYo4iPrr8tVp6J9mn+WP/n+QXi6WBXHrkE0U40GlbLfgYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6184
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 10:48:08AM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> UDP_GRO was added in commit e20cf8d3f1f7
> ("udp: implement GRO for plain UDP sockets.")
> 
>     $ git describe --contains e20cf8d3f1f7
>     linux/v5.0-rc1~129^2~379^2~8
> 
> Kernel source has example code in tools/testing/selftests/net/udpgro*
> 
> Per https://www.kernel.org/doc/man-pages/patches.html,
> "Describe how you obtained the information in your patch":
> I reviewed the relevant UDP_GRO patches.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
