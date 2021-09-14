Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5132840A66C
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239600AbhINGG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:06:27 -0400
Received: from mail-sn1anam02on2071.outbound.protection.outlook.com ([40.107.96.71]:18765
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237875AbhINGG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 02:06:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWbweP5df6G+JF1XgzKJkLrRp82TayxOTr1qdtgsHruYd2x4BxbJ+rOqF0/G/djJ+BfN3Yzk0EmtPbv2Pq+TM/tYA0bXZm5q2Ufi4xMngmyAki5KCIj+Jx8TVcP0v9mgjTOx3qsciBLpiLVP+h1YQfmko2rvdgd9e3RcsZV791hgZ3e5tK513ms5veJAJIj6LkHHuxQz2C6h8Df6UXsgxCrLaur+twIMwvzyheQSkrk+U6+T3dhCk8tcn/nhU4t9DTarGU2vXypgkeJ6jj3ju4h1PxYtDczxjmgN/GStQh76Dkz9DMKqlDJEdRhzeK5A4bZeQF78UhVN6moDYm8LwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lkF/4N4vQZ7z4iEu37ATwm+kwJqcfzBxMpRuUmib1Rk=;
 b=beGbWT/Fv8NLqKJln4ppGeXNaw5GxaU563xtVubNsOh3tS6uDsuMmPuyX3avvmp6+r1cvhbTEUmpbfvXTFrmxx9XupQjfy6Xy5dLP84W3y4T+3xrSQr+1i+pwfUlNapAw9TwV99V1PhnVWASJHwXVpHuYxDvCJ0jOgdIrTFtKaVRBpH3qhoUvle7mdnQdPclsTMU9A5/YgfoCo6bo5PVS6MqoF+hRJ60PiW4uCRO39oRvLWdDI2JYlb9YadT9jephh+2hyjeyv66Y/O5BmwQeYSRghb4ITcLc3uf/QKxArBoc6tjX4BYvxdKuOdkAgvudNU7pi8dJy3pO38jkzJWXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=broadcom.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkF/4N4vQZ7z4iEu37ATwm+kwJqcfzBxMpRuUmib1Rk=;
 b=M9W7wVWO77ktUVIl4tL5EJJHeGdQ2wSVyFj9Z+/Kzn8VGNTvXWcwWoMNGu6QgaXh+nLesGnoT4JRGaszD4V7IwsuJtjXUCS71sGIX9h1Z5KAaIGMqfuLy87VSXjsAlW0U0nMJxNUTP+E+Rku4a6wjPNj+Hrd4hck6dIGMMqb4PVE5y3tqmH6wjuhlCvCJ1MVGXUmeS+5yeCBOryPu+BHI6G3HU2CrAryI1FLNp58Lo8lWn76E3SibqPMfCcMp8pE2OmGzRXjWLRKYnABiAVaoR5stJivmub9q4woJOYcdP9mXZ7Fo8F5MSb4oGoO9s/R7asxVNZzTkVLoJpegTyQBg==
Received: from BN9PR03CA0703.namprd03.prod.outlook.com (2603:10b6:408:ef::18)
 by BL1PR12MB5093.namprd12.prod.outlook.com (2603:10b6:208:309::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Tue, 14 Sep
 2021 06:05:07 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::b2) by BN9PR03CA0703.outlook.office365.com
 (2603:10b6:408:ef::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend
 Transport; Tue, 14 Sep 2021 06:05:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 06:05:06 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 06:05:05 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 14 Sep 2021 06:05:04 +0000
Date:   Tue, 14 Sep 2021 09:05:00 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     <john.hurley@netronome.com>, <sriharsha.basavapatna@broadcom.com>,
        <ozsh@mellanox.com>, netdev <netdev@vger.kernel.org>
Subject: Questioning requirement for ASSERT_RTNL in indirect code
Message-ID: <20210914060500.GA233350@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5034a92-04c3-4165-e6f3-08d9774599fb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5093:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50938DC1798585CDE996B918ABDA9@BL1PR12MB5093.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x2QKWLCqjf5VwQ+oNkhhxyQOxHMjd2nVHn8PoWa1dojPnYOxdZtiRKCy9G1WjSOpKwlJvjWHQ/1mfesSTQXyJq6ytmhx7ipZdIItG40fXXC/bQlapBeegtmoJqgXeg+QaFjNRIOvxgMsq1wPWKxmZP0JX/e7C37AJ1t8wJrCvQ4K55RVRiYftRMJAUsLncBtfqtN562J/dGhDvVJLUzUjc4HdKZvL+K8ZO1ub8JlwWgUl31ik8QRapwLRv7gi7AX27ezoRsjMA11AruSgNwf1P8lvufj8oCV5znQDgRIuNnOAv6nHGEwnNEfFwcWdIgZUsUV0rWxtymorEeZrugRcPtpSUz3nK+77ceCVFsPV26JWZtV1+El94J7Xoxx1nvzoHj35HIjj1MDruOGHt/yweMielFv/hNQ9yN0C9abxv4il8JJncf0naoSdHwMacdTJB+WQ/FOy/yezt5RKWnyohsq0HNH+62Qxl0B2EqcqHCaupHrhSEjLK9U/3Vn3MU3ChVDC5wgXC7Q0jEysaVbiRTGCSGtiweribjwdAyuvcYo50r88DVKrafBP8jHqmbCQ2Ag7ausA0KE1xRRzqNH1idB+/fkRCSqIYmENBtNj6rddC5Ry7haCh8v4h1bd2AFoJbJ7oSAt+Farlzu74a5Fo2D34lv0GTj1eAIDGBYCUx9AG2NSwBNev9D7YxOd+eUet/1T8spa7F4Z5FdKlz/Eg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(36840700001)(46966006)(8676002)(83380400001)(86362001)(478600001)(8936002)(55016002)(82740400003)(26005)(7636003)(1076003)(7696005)(5660300002)(2906002)(4744005)(70586007)(9686003)(426003)(70206006)(6666004)(110136005)(186003)(356005)(16526019)(47076005)(36860700001)(33656002)(36906005)(316002)(336012)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 06:05:06.7848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5034a92-04c3-4165-e6f3-08d9774599fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I see the same assert and the same comment, "All callback list access
should be protected by RTNL.", in the following locations

drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:1873
drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c:303
drivers/net/ethernet/netronome/nfp/flower/offload.c:1770

I assume the source of this comment is the same. Can you guys explain
why is this necessary?

Currently, with
74fc4f828769 ("net: Fix offloading indirect devices dependency on qdisc order creation"

the assert will emit a warning into dmesg with no other noticable
effect. I am thinking maybe we need to remove this assert.

Comments?

- Eli

