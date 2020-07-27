Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212AC22EB82
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgG0LyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:54:12 -0400
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:54240
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbgG0LyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:54:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRR/H1OrF4zU9NGbIP9AFaDY7fbRQLnjt7sSTefS3Jkz+/O2CYLI9eac+v+2MZFSL5W/XIONotnKSW6Glg0zQJkpsjRMC29FBHuWfID+y32F96Ujm/rRli6rqCXRrZtjlSnjAoOg5/uf+5VcGfv8kcoO236PHbb4/LOZJB5+b7zSVaNiAveUZZT6oaA0BbKtW8aHerZMHfQ9hdY3YaY4ralX6zRJY6vkEim1eSgQAvpHidJRDFrgfi4NnC/X0bxe01Pu0/WlntiYB0qBNcOMR8SsMhXBv1OigrPL214Q7EHWCsl+ohurEOAwy3LuNsCRTRLtyEmIrFcOTcaqOhglTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmyILddlzE6b8rLZ7uHEXEZPJLFMABXC0tskFTC2hQo=;
 b=CaXK8OVYZJ4J4ck+8hGeZwOsxdvvQLWKh//Kj6b4G4ZLUlx94tagzPrQdZzl7hr8yXlk5z2B/c5TkyyoeB9s7C2GPaivpfUTwuE76UjPaNFWHOsB60gHVjInBmTtvspxRdUwgN6vTWyiVvcH9Ahvshr+q0BBxGJdpMgGNo8Sj4O7VOPTkcRVxE2T5Bp75zpc5LayB5Ilu1okwIJ63N/2FweIpmfvt4Q1Xmkyh9ICUC/miZ6Wf04fUDrJc2Va+m0Nd4a7Yi/WkQVjsQTRpkirrnivkQs6KbXtGXaX3uQtY5RRZnt9OP+IMnRrBjqYTsqRkcWswEWT95SMPtipv89RCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmyILddlzE6b8rLZ7uHEXEZPJLFMABXC0tskFTC2hQo=;
 b=bfgrUSF964Pgru4UIg3qbUeWjuwZKpc4Xn/le9A7Z3E+leV34Jc5O2qwax3fblC5H0upvPS4M3V1zkrjHJaH10Q1rc950/qHdU8f2m1FCaF/xe+OtFfPkpGFKc1K7PgZKIL7kpbHw5kZLpi5yDl0DiKyjEUPCeR79VMdU4VnmbQ=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4599.namprd03.prod.outlook.com (2603:10b6:a03:134::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Mon, 27 Jul
 2020 11:54:08 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 11:54:08 +0000
Date:   Mon, 27 Jul 2020 19:50:12 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-nex 0/2] net: mvneta: improve phylink_speed_up/down
 usage
Message-ID: <20200727195012.4bcd069d@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0044.jpnprd01.prod.outlook.com
 (2603:1096:404:28::32) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0044.jpnprd01.prod.outlook.com (2603:1096:404:28::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 11:54:06 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aab0cb9a-6f8c-4bf8-112f-08d83223c4a1
X-MS-TrafficTypeDiagnostic: BYAPR03MB4599:
X-Microsoft-Antispam-PRVS: <BYAPR03MB459953A1E41920362F060100ED720@BYAPR03MB4599.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9iQybaTWsQa1FL4KTK9G0/5cq6BJIET5/Qw1hsr0Kq9uG3Srp551bgGOd6T1lvY37tRfFh7sGOBTGRsHz4Can54DMM4ard32MjYJM733J2RggnMCLb+MlgirJg6rph3kSSfzwDVCM0K3NbWuzOt0z0muz4AA40oS2NSJ6GtPhqcsumJwqib8eaUqgpVfEOS4vQ9krGIYSwPAzFzQpBjHf5agRY6KcINdmzA8lEqscnlSl3b3Iy/V2d3DKY5oWZUYB1+M2ziWwTVMVqePJml9xLSarGdHX1mC1gzQMjhiyJVCdHYFzPh3ANgRZb7X3Ub
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(376002)(366004)(346002)(39860400002)(478600001)(7696005)(4326008)(1076003)(956004)(16526019)(52116002)(66946007)(6506007)(186003)(26005)(86362001)(4744005)(110136005)(6666004)(2906002)(55016002)(8936002)(5660300002)(316002)(83380400001)(9686003)(8676002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TCkvoSrhJsCtgVFn8K4F+jAfR6VFkGSearQju4Bv6yjR0V9KI9OhLB5H3n5dHuJovjBQi5It/dz/O6nPiJTazn2QOhnl48XKoPP7lMDawjxJ599xl79D2z4i0fngvqPpzEdUOjeEjMI14c/V/kqqDpwG9zYrnF4T9rRvDUiPIHPbOFE4ZIVNp5xiaGfkN5Bqbf7GDPCSlj4Sjp9fQy5JTORcLgOu1coFwOY+Wa+/NbYBRbpAgb0BRhc7nkPU8v62IfEtZbnybCenbiMpmVsoRfBRuOOeOUCt0cHbX0/DgTh7qQdjUXSX6WxBHg0CMtGkOLxgm6CngHqpRC57Ij3tmupSZ4oPgMjckFlDvvh1Dl7MXukGDPlHSIaPirAVsq5ptZdgM4Mktdkjjmut/jjUxL7FiM2Gbou0Qgd9rqHyE0b3O+a8Hw8NsAeEX+SzoLfkSa7aI+prwYgbLX+57sFuVOk22wouKegbnnBkvsz4l94Md6qU1rwBBeN6UwImPl6O
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab0cb9a-6f8c-4bf8-112f-08d83223c4a1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 11:54:08.0497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3RIcUReGf3T1Z25I5AWy21X7SyxrH3YVHdaXKe7yZfe2mL+j9Ea8wciZtv1kIOzbUYIWW37U/TAH3AefghIPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch1 fix the comment
patch2 tries to avoid unnecessary phylink_speed_up() and
phylink_speed_down() during changing the mtu.

Jisheng Zhang (2):
  net: mvneta: fix comment about phylink_speed_down
  net: mvneta: Don't speed down the PHY when changing mtu

 drivers/net/ethernet/marvell/mvneta.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.28.0.rc0

