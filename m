Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354992F0CB5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 07:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbhAKGCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 01:02:19 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:40434 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbhAKGCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 01:02:18 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101]) by mx-outbound22-208.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 11 Jan 2021 06:01:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nF5kRZrRudpj+vG0x7rvt4EgpNeqjknxKv8smiSbOckIljOq0LkPWVUcqvL2g/d+m21aFmIZemvqOz+nVZfsILaMGJWItGaIE0LmzcP2RRy3KgiYVg1IlzxCx2VOu1iWL8JvdQIGUKE/ZrQnR61FIMWnxG171Y+urMSfcXVrjHXkJxhFjSG8I2O6x/Gp94vLw/whMxn9m7RCTyibJ4vsYcOnQp+MHu+r/VeDLkuKuUMoemDJGbRk5HNB4ZkOW6I265/5SrNzLo8sLL4Vz54aVeNDQg0irdcGNz00SohxOekWydXFdHsiQFEtz29qKtJxnC09SsH5otT9/MUZLd+ETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJYyfwbWSGoEulSagZV9TAkaEvmPpp94rL/RuhGLB4I=;
 b=JiLqImA9l8OHrEr2rKy/irCfzkUiBtQ+woAW8fpAFYXIMohOUmEFpdg69nXETQLsZkDydBggyMa87WO4I5msgNONvgjSvLLNCCjANE48jVF5EvIvuLRy0NbTXztgw+B/K9WCMVa6970q6Y0Q6h/jFlDFQYb+XzmFAvPN38rSI+nI8vOxffPs1Q9SsSs5R0rYhSquNBc8DKhdxBMMoLtznFYmESeRJS7jdavb59f1aB22lOZzAEQ0py4PD2nsonRJRUboCJiIUE57WCqsAh+tIxYRZesBNCrQz7h9q2DI4C3pUuuwtHF4vu6rLMNcxEjdU/RD6sLOmc1JvyXhoVwpJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJYyfwbWSGoEulSagZV9TAkaEvmPpp94rL/RuhGLB4I=;
 b=T6lZ03GDQY+McKeKzQy236/Bwg74ncIaGiIev1khHAUlSbNCIM7GCcz4Kff7AM0a9qcz1OX88UzRN1dTLaByuL+7J7e5vY8WMp0HQ2rMM+eYlRYG4YZNzHeLXk6JGUgY31Fi+JbyXHcNXlLM80wraEcIAdsiMo2CYTxPu5h/dtg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 06:01:03 +0000
Received: from PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e]) by PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 06:01:03 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kabel@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        chris.packham@alliedtelesis.co.nz, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, linux@armlinux.org.uk,
        lkp@intel.com, netdev@vger.kernel.org, olteanv@gmail.com,
        pavana.sharma@digi.com, vivien.didelot@gmail.com
Subject: [PATCH net-next v14 6/6] net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst
Date:   Mon, 11 Jan 2021 16:00:37 +1000
Message-Id: <20210111060037.13553-1-pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111012156.27799-7-kabel@kernel.org>
References: <20210111012156.27799-7-kabel@kernel.org>
Content-Type: text/plain
X-Originating-IP: [14.200.71.209]
X-ClientProxiedBy: SYBPR01CA0042.ausprd01.prod.outlook.com
 (2603:10c6:10:4::30) To PH0PR10MB4693.namprd10.prod.outlook.com
 (2603:10b6:510:3c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.71.209) by SYBPR01CA0042.ausprd01.prod.outlook.com (2603:10c6:10:4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 06:01:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2119a789-0a77-4c98-5423-08d8b5f6477f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB461689638F0477BBBDA7A90C95AB0@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJuNaW8cBUFlJwfo/DP4CIggxbtXH57U39PE0nngduX8MhkPw/VhDPufb6fM+R/gmHoWLCW7WNX6WYSy0vbo7FF3VNc5UdUZVwfYQNLAMKDogGqQ/LeCSfFDC8J8d4u210+Ax0kY31/qMMLwCfOaQKquqrQoULllVh8d48v89egXn5ljOz4XTw2G7iUPsBZJtfrfD11XY9ncjqiKtzg7FaFRuVsgyKy2ug2C0dK5O16xNhLw6F7v7qTSAHQLuqIs/INvAZAtKd5qmWU4IxDivxRoZlxlWYvEMuq2QKkaenhiUDHKIRBzq5k033k96mRtJsX3gInLQej5MQAdZ0VW/Otr/VkmiqsYUre+iE9RZBbGEmTNJv8s+jdckW9kNavbHufP0S6k8YTxH0OY5aTwuOBYX5a3NdzJmflYwRmLSVcQxERlsUDayZ3v9jsy/7af6Z1e2boDx5ZHBYZHyEpWUdaJE6t/6cx1Y3Pj6G0A4aU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4693.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(376002)(136003)(346002)(396003)(366004)(6916009)(86362001)(4326008)(16526019)(26005)(316002)(7416002)(8936002)(956004)(8676002)(69590400011)(2906002)(6486002)(66946007)(6512007)(2616005)(66556008)(19618925003)(186003)(558084003)(5660300002)(1076003)(66476007)(52116002)(6506007)(478600001)(36756003)(6666004)(4270600006)(44832011)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?W4dDsWU8C+IoeD2GJ6p4D1luUFCD3yKmm0bJae0EmvSwdiQPLBEs4ywz0FrI?=
 =?us-ascii?Q?csJn1Vnrk7b7Swm7jtKxET4TOXpq0u191BPUVltpBCTrd1up7auFNcq128W0?=
 =?us-ascii?Q?PN5x9f3lL6/rGKwbO0TaKMsjIpqtRhcfR9uIbjelDmBsQSnB4/aJM59PPdgp?=
 =?us-ascii?Q?EpyLx79AmGDTc7b77hOtmUZdJWBrC5Lsr4czETFiUDb3Tb2WNhi24++dET9f?=
 =?us-ascii?Q?udbzLf+3GP1DTcRD8a+RHYyRjbbaNwOhdUJEoS1y/REeacl7kVx6kaPhT4BH?=
 =?us-ascii?Q?NKWv+xdonS98dkBQTjhOEpWSG5vXH8PCcsViHl5RjVTSJ/5y/HWb7QKHxrsh?=
 =?us-ascii?Q?n+urnixckBLOga1HBquXoJe/tRiJx2oWHP+yr/bazkP7+TZ8wQ+xdJgw0a5D?=
 =?us-ascii?Q?KvnTbczqVocKjvz0aR82qerDVFR1+Y/cJmqccXNiQ8cLtZHBD7btlShzDle7?=
 =?us-ascii?Q?XGQtC8betokxTig2+6xTO71NDfFFc90oQ49sm18B2+chZx23lNu2SXszd6YY?=
 =?us-ascii?Q?6nAQ4CgOQzXKhor1FmW0RLdGR/5xvwdLQjb44WmrwMiPF7FkMEAHiMohgmQd?=
 =?us-ascii?Q?zHyGZaOY+Ukp2Lh5kPrWJB/g9a3CqpMz52xsOWnkpn0YcqoErJn6RRRyG+DO?=
 =?us-ascii?Q?kIK4NdZ1cufZ80mXDkgLU80j33eZ6qJ8uNZ0ZYt3/ZjBE4JlKxig/a6aqccd?=
 =?us-ascii?Q?7z9iZTPxQqZOOByEXNWigq4hPXMN/Y5jZQ9gRJ+wNFihtlSjcB/ZiMcZUOY9?=
 =?us-ascii?Q?FuHAl/tK4kvIxD7PVeWQNDi3AKl23ZVx64i4I5YgIhOnhBss6BuHBeI9ejS8?=
 =?us-ascii?Q?3e3p/Vl7JopQGfFu5HPhsaYeYZZkFHNT6pvu6SCZd9RybOFfF3k/9apRipuy?=
 =?us-ascii?Q?hP2UE4PrUGGyT3VYbTjVqNOm5NCU7BqmGgq+XyXIAhGSNvk//W/KlNFVibkw?=
 =?us-ascii?Q?F3BmE4cMxffyqv3Ae6KCCsICccGKoodWVOueIdnDN738/uOnmnmsvTdXkQH/?=
 =?us-ascii?Q?X/x/?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4693.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 06:01:03.7859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: 2119a789-0a77-4c98-5423-08d8b5f6477f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+3+ABif9hz8Y2HRgAt81FJqOUeytB1E0wstfrHwh3uqxFCGMCqRXmp4Sq/JkThJTZh7Rf18BwBW3n6ou+ck+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-BESS-ID: 1610344864-105840-5418-73966-1
X-BESS-VER: 2019.1_20210108.2336
X-BESS-Apparent-Source-IP: 104.47.70.101
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.229468 [from 
        cloudscan9-121.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
