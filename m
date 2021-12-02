Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A212465D57
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 05:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344863AbhLBE01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 23:26:27 -0500
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:21024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344756AbhLBE0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 23:26:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Etc9Uw2whJ0f3t+6yhzq1vvHk/6UNfeqpLAUM/8a9rvGqBLhwQbkcMknPtGP+xVK0aP18qBF0e+E3CHMlJkN59I5ljvtgPdm6PI0HoilMoLJ4zeHaiODlLFqExCkuex0VdOzlOr1qSWa2CUWeGAK3snpbfU1Ieq9ze6HcHW4hKWap+f7zKETGUFPB1uQXfw+cvhA1I5gwSoAATlgKpD9QVh539cJRHSTlItV7bk3yT45aVR+lhNNF7QPUr4oCRZ7Kt6lZLUqJkcO9HcrCRVVT6EKdjRQ/S0gsItlAxSYkCSWznzkAO/krirxMWKWZ+o2iejmwht3LZ8n1K3RV6Vgvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KgkFZCVhtpXsJKQpqSAKM4HP17Wrr2vp7Vu4wkxVlNw=;
 b=KUVBHicWdZq5eUqymLUxd1pVZPeEet6Jb+3iX7XoPpmMxQj1ZUsSHqYGsRis1IMYpNUCl+XkARrqcCP8KSWaI/aB8aZ4dbQetQ8xF8Hr9SH3Q28YBLXDfsKlsAPE6tmQw04tOnQjVA+ss1lQ8IzMIw1rnZ1EItlhXMhi3+o4zyeJWQPzpovXUy0DtPDCC/lS6LSkeiFPHPQRc5fy8jPiCnOyE4kPKCi+MxoiBLsMqpBl8tAsxZHR29ZEuBzmhcxclpfUEOKVOrfkItyV85ciCXSzobQb1O360mAB8nrq3JkZsqDt53Xwlc4NE4zPidPuz9+y3zm5Yi3br5A/1ZZucA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KgkFZCVhtpXsJKQpqSAKM4HP17Wrr2vp7Vu4wkxVlNw=;
 b=Axx6KC7mT/3vlb/NUHR0pxWrsXt/dZALywwA4s57ywP1z18y/XctIVN0KH50zEQor2vdSp1LGbcDp11KpdhFpam3sFesyPmP1AQ0k7T1A7Du/DTweivrqQFcAqPs1ryxeXLY+PDDyYdxylVb29qO6M8/HEomhuuzOPQZR8GxZvHkJn+KuQjvqrL/WiSvnm5ystQJn7JieKoA7JwzKlagSHNQJ2lt/m37zdqR67CTs91LmoZ6zJU0ZjinHsdci3jdC1/ru2SI1Iv8rIiESZs+kpJ20yoMPNOKiZZfH6wM2KnDoYKuSj1fY8jENblXpZ7JW+AyPuEmt+FBnCB8uUe5uA==
Received: from DM6PR13CA0045.namprd13.prod.outlook.com (2603:10b6:5:134::22)
 by BYAPR12MB4693.namprd12.prod.outlook.com (2603:10b6:a03:98::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 04:22:59 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::6) by DM6PR13CA0045.outlook.office365.com
 (2603:10b6:5:134::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.12 via Frontend
 Transport; Thu, 2 Dec 2021 04:22:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 04:22:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 04:22:56 +0000
Received: from unicorn01.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 1 Dec 2021 20:22:54 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     <virtualization@lists.linux-foundation.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>
Subject: [iproute2-next 0/4] vdpa tool to query and set config layout
Date:   Thu, 2 Dec 2021 06:22:35 +0200
Message-ID: <20211202042239.2454-1-parav@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f4af3b5-af92-46b0-d396-08d9b54b6b2e
X-MS-TrafficTypeDiagnostic: BYAPR12MB4693:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4693D5AB1CE9D95DB734FC95DC699@BYAPR12MB4693.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nV9mWc7mfbw0NC12YK2lo0hGGMJUn7Tq2ciz8VUK+lUrDXoVuhBb9VGHSx9qOjz7oaawLTxL0p2zt1cB3zaTWQ8HxYoytb+xPbA4qAzM1pyE4hUimbqfo0UDXzTDOja1onGsNsmLhBlbfsGXnaXRJ09SKRnejlr/FQ5JHfdsikvODNKkwQ3DuLadjhtiTgilMjis/ILCC+PseozecxpPZ0QvYU5d3R2GryJQ7OQFTktAOIlUslvombdtclNosgOCeL1O6X3CUCTpcIKa1zVoveEJwkmxSLYueY36bZb2pry5sJ7m7/R+c/EHCVNiTbpkj4SSJRH0JTHpVheaiIKgxGyflCx5YY+2QZ9/bcTmSdscuMadAEcwE1BD1dpy3vwdUbluVMZos6KQEda8+3rDAexEEOfSEnuf9xIPktDIpOa1MrX/3aciriQzkBPlZbl8tQYZRsJxjUBk8hRoHmTx8Pb23CnKu5a3nEhqNusVHyEe/TnN9ZmYW1FtBA0TLs4qHDD5Jfs3LCwOJP4sJfAJAH47GOXCWXWpEwDYoHqsUuvrO/M7N3qHNm7/KPhXJ/GR7Ud0mn2lmMidhr6urYaWBOUtdeu82f56zEgZX/eh1AiaY+ChS+h8j049zKHHQC5tiayMK19zIsLhk+CTVPrYZQU5am8y70dxDaR01ceYaLEiogbgQSql1IcDu4/3K+mU28+JRCXU+kmdtohLT223xLvE8FJAknewt/i6DEwfFgv1ILtf/t++L1dfkXBMb/9N
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(107886003)(1076003)(2616005)(82310400004)(8936002)(6666004)(2906002)(336012)(54906003)(83380400001)(5660300002)(47076005)(40460700001)(426003)(36860700001)(7636003)(356005)(36756003)(70206006)(110136005)(70586007)(16526019)(316002)(508600001)(86362001)(186003)(26005)(8676002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 04:22:57.2697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4af3b5-af92-46b0-d396-08d9b54b6b2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements querying and setting of the mac address and mtu
device config fields of the vdpa device of type net.

An example of query and set as below.

$ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55 mtu 9000

$ vdpa dev config show
bar: mac 00:11:22:33:44:55 link up link_announce false mtu 9000

$ vdpa dev config show -jp
{
    "config": {
        "bar": {
            "mac": "00:11:22:33:44:55",
            "link ": "up",
            "link_announce ": false,
            "mtu": 1500,
        }
    }
}

patch summary:
patch-1 updates the kernel headers
patch-2 implements the query command
patch-3 implements setting the mac address of vdpa dev config space
patch-4 implements setting the mtu of vdpa dev config space


Parav Pandit (4):
  vdpa: Update kernel headers
  vdpa: Enable user to query vdpa device config layout
  vdpa: Enable user to set mac address of vdpa device
  vdpa: Enable user to set mtu of the vdpa device

 include/uapi/linux/virtio_net.h |  81 +++++++++++++
 vdpa/include/uapi/linux/vdpa.h  |   7 ++
 vdpa/vdpa.c                     | 198 ++++++++++++++++++++++++++++++--
 3 files changed, 277 insertions(+), 9 deletions(-)
 create mode 100644 include/uapi/linux/virtio_net.h

-- 
2.26.2

