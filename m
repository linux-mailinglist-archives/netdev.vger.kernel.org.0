Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F8F681507
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbjA3PbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbjA3PbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:31:16 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2084.outbound.protection.outlook.com [40.107.105.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC7338666;
        Mon, 30 Jan 2023 07:31:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+JdMJBJ71Nzeww99yOvFt07MaYJAhN1oPI+6HVfQmt+qtBJJSRrh4Kfdo8RdKH95P10QMcgcU6hyM5YTUI9j/vWRl4PUgOJv3/SLhAt4AHlKME7Lus7d+agvFQ9JOFnJT5HepZKAkJVOJ06ibuiPCrTSOQXRP8nzg89ugGnEGd2Ohayr4tw+uJtdz0EHuky68sNaPg4raalrAZ43BXFfcyypOifXHjTeVA2q1RpC/TAgY23hsAMNfKJ9uT8glYe7YE37aVuztobdbyFYhVGzxjqnNTghfZMPi6xwqqbUW+PswRYVdsWTO560o6UAMJOSIQUHnDKA2bR9BmeRVSCEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67DcJvLNo/4AW88dX1xX9wg5mzixvJlIjMJq++UfGQs=;
 b=VG5I+Rzo/tzKsRpTTgTco1/FIKw2ZUdNSG1OHoPiCELpUqIyZJmH9QFUFiRe2VW4jUH4BclLmUfEDLSYzsGV6reKZIn1E1ANAkYGfk+q+RR4BgqzgYeHPmr86NqUKhBw/+QL3ycl3rmyXnpYRavVwMlgcotKdOqXfcatHOUG0DU8ZT4WKm+IM7KOgNZRIpcyrpEV6BDg0WDjk4R8uDyS1AtAPcbXkM3fUe8vfSppLNcNL7luLdzlwizF+UN9Mm6OB3fukorp5uXu82hcEEMCeca1RUv9oHLgnrRUCR0wFBbIHn1j+LlSZnTBvCtZnL0UE53TMPJAfrQPsDKJrDqddw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67DcJvLNo/4AW88dX1xX9wg5mzixvJlIjMJq++UfGQs=;
 b=WRcNDKbi7jbiUX8EBCVSz1gdPHM7Drk0Dwni0pqZuwzhqOqCkgzy5sAXSGS6x2pt+A5rwF0J0UppZkdD/7voVdZ1M0nNiw4xdZFwi39ZBRCgY5h+c+8oYf+Yo3uiZb73jy2AcbnyWq2UOT9LDNlIsj2z0Bn3r0YdfDfEaZZoKmw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB9PR04MB8091.eurprd04.prod.outlook.com (2603:10a6:10:245::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 15:31:11 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 15:31:10 +0000
Date:   Mon, 30 Jan 2023 17:31:04 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v5 net-next 00/13] add support for the the vsc7512
 internal copper phys
Message-ID: <20230130153104.ab6u7efjg4fi4dua@skbuf>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
X-ClientProxiedBy: BE1P281CA0085.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::8) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DB9PR04MB8091:EE_
X-MS-Office365-Filtering-Correlation-Id: d551bd36-aae4-41a6-c75a-08db02d7039e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJ9XbS7GYGddGNuQwQf4nVZSgzqMKLPiCjGxK2RciWoedU2N7S4Z2UjM0hkfYFf0ykt2tMOW7kJZSSCyQARpf3+qxd1ebESX6cSGqiTt3FwtsKqaJZENTfgnf31P365EhTddVkw/aQG1CueklhwtpX0IMPnQ21KVAHKCM0tp6dPpR8+FGpQNkepYhRO2ZohXQOpE119nmmYTKXIgl+Gtttv5hIv9/p19qQhHANsLCD1Ce1sQPINKUUKEss8nPA2BMWJPWTBZuc3RLRjbbc9sU7S7qKf7PxSrf3UoUo6TSCv53i8wchEIiP5lmsyu5EDoPUTGKAXwG70PD8EyQ+OY0x6IF9r/Gs1pC7Ik6aaWJXDE3VvKAJQXKPDsCY+dt94nLxSVO/XUC0uHF7WVdM7A3lPbHn1bmY02nQBb1E5O9wL7U1wtld9XudaNUgzplG/FbOxGRroe641kdSawzGcOEflvTbbHsr0Y38037yWTTxGf2y7yA+bTk8I8yJTKpZnfrjLRSfUnBi01ej7JcR2ymMx/yzLG1GJumIDZBauCZ09Jy+j9N1nE8aU2P9fwXdrwZXdFDUUGTb9V9RainUUozZJ2exI+NDz79GA4O/qBHLask0tGCLdGliLw6DuMb6CpS6nH/rCaD9RH+ujlM2Eg8XLL7NaodErLp/NQgTmSZNs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199018)(4326008)(66946007)(41300700001)(66476007)(66556008)(6916009)(6666004)(966005)(8676002)(8936002)(316002)(6486002)(54906003)(5660300002)(44832011)(7416002)(83380400001)(2906002)(26005)(6512007)(186003)(9686003)(478600001)(6506007)(1076003)(86362001)(33716001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wv7YY9IEdylfn3XSkicQ92UaJPTzWOGtaz9kqx8BgL5VqQlAjVQXQTCl6Acp?=
 =?us-ascii?Q?15yDKq706xnMOpxfDNhlz4iX0hFKhIdZneQtQDdaa+smqJqQVODDfc9kVfB9?=
 =?us-ascii?Q?r9IxC+FaIKc4G5K+PNhfaTpWjsQk80yOT7Mn5DiNWwUobFtJUAT2SX/c71XE?=
 =?us-ascii?Q?BJ4xsoV1UTNpcRLQX3sZ4ozXuiXHr+BFpKXxUz+UeWvjSSsahZNcw2CcWcNn?=
 =?us-ascii?Q?7toRFdOKjf0hFKA9MVkuugIDduu2i86dWCTUDUn2RlE5Pe1jzmFqCJm5rVmR?=
 =?us-ascii?Q?a+11dCEHzDV4OJZEH1LqI8Las5pZVUCGVcT5a/8oEm2LI2ElpdzRN3itK7x2?=
 =?us-ascii?Q?xJUAeHOmMfwdtamfB/ysCYi8JVK8oWWiDpeodAYUOm5iBjYIU+KYZW2H3GWT?=
 =?us-ascii?Q?eN1s/pc+HTqcXa6SlUb3LqTRf2+MttNxXNu6MZCsI67OkILQLA7RqG7vEWYG?=
 =?us-ascii?Q?nJH1/WIeVwrmj/9Rzeh6R1Wj06q1iAZSlCyO1PKCGFpnLKVDuh9UwIqeBrbz?=
 =?us-ascii?Q?7Idmv0/70SmrVKBo5eKzYZcjmFnP8e4/zdhKZc2q4USQc84C9NT2cY/NCk6q?=
 =?us-ascii?Q?P661Z8e0iuErbOSWBM/R031wzGYr5lr6mLlY83RqFW3+zvgaG+0OE0joefzp?=
 =?us-ascii?Q?6QaUF1qEf+wy4oD2c35yvawQ483jAXsPGFkT0eVsilvo2vRQ32uj4vgEfcAO?=
 =?us-ascii?Q?BUEs804KFbXwcj0tu2FnNaixEHDu9Gj3wrZJzEVW+b0PjhNywnXHP36qlksP?=
 =?us-ascii?Q?+itXRLVsxG4mERYDg9sKXE//4r8yFy0x2YTRKVvUbvUt37BvDXXpRo8HfagJ?=
 =?us-ascii?Q?zr75r1D5rqm5y/m1yG0wGHW6up/VyUbFgyKGCi0zhu/yoRoRdCcIS14G6Kao?=
 =?us-ascii?Q?1NmkeTPAWdpTreIen2FkIEXbnDOi+LcOGZTZK+OvanPdiQHWhOI8HMmxZjJJ?=
 =?us-ascii?Q?6G4rVAfDLyJEOANHDAFFjfxaqz+NbuvKA/Ndd1pPudzqN9kthYU+xn/hJSCo?=
 =?us-ascii?Q?bFznMvetfF55jcOnmtbhKLGf7k1zEpEsaeVK1j7HqHswyfSGULoCr+IMo///?=
 =?us-ascii?Q?C8T3ax0WQoITpBNngMcDSiWZtkWy9RCTxcwSmQc071Ow5ZwVMUeLJQVoPS/O?=
 =?us-ascii?Q?x2ud4tTxDgV+aMpOJG7JILfAnv33GkNvqqw9PXzIEpRwlLK3WOPFG++y35ZW?=
 =?us-ascii?Q?1II5nm0zrfS3S3wpLDpQoOnCmnpte8gjV1QE+N2SfT2K7qQROM65M+O3UY2A?=
 =?us-ascii?Q?8aatp+zLitcEr0dCG8/BbOC9KHmaUDMin0h52sy+dGNxWSiEjJXMcHvdLpkr?=
 =?us-ascii?Q?J+ua6bHu7P0FushrHI9SbT2fuiv/mSmE6BGyxiHS6hMMj68DfRJowRAFwZA6?=
 =?us-ascii?Q?7FjgRe4mmrhIwj21K08mkaarhz3ibnKddrEyPiUY8k9jXOGJVGYlotd4adlF?=
 =?us-ascii?Q?0ydCpVkFCPKuztDBdPVihS7+V7Q8e8OqjEVUyJJJtC8IQVO9cHXCt282zLlA?=
 =?us-ascii?Q?P5E9oTB+Snn3UkWPwBqV4OMtNu3NfJH/P6QQFYtswtL4NzkgAh1iOhiiqNf2?=
 =?us-ascii?Q?RMToBWvlaKOPKIfEuWBMhQPX5tcHJDkfLVQLHnLC8bE0u19TTGHy+JIlplqT?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d551bd36-aae4-41a6-c75a-08db02d7039e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 15:31:10.7674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9gC3oWqUobmbVEkNFKRH+a2oDkWOOTIh50CCs0IzC8EY5yiBHHw3n7m3UGJsS6U3hvhL13JHtATsOeIoZBb7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8091
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:35:46AM -0800, Colin Foster wrote:
> This patch series is a continuation to add support for the VSC7512:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=674168&state=*
> 
> That series added the framework and initial functionality for the
> VSC7512 chip. Several of these patches grew during the initial
> development of the framework, which is why v1 will include changelogs.
> It was during v9 of that original MFD patch set that these were dropped.
> 
> With that out of the way, the VSC7512 is mainly a subset of the VSC7514
> chip. The 7512 lacks an internal MIPS processor, but otherwise many of
> the register definitions are identical. That is why several of these
> patches are simply to expose common resources from
> drivers/net/ethernet/mscc/*.
> 
> This patch only adds support for the first four ports (swp0-swp3). The
> remaining ports require more significant changes to the felix driver,
> and will be handled in the future.

For the whole series:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com> # regression

A minor nitpick after this is merged: please clean up and unexport stuff
from include/soc/mscc/vsc7514_regs.h which was added with your previous
approaches and then we steered mid-way.

Congratulations!
