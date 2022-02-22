Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0F54BF6EF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiBVLIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiBVLIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:08:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62A8B54EC;
        Tue, 22 Feb 2022 03:07:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLiHbUG2RjwWbUCIEyG3AW5Co1xt/kgWimqjZutXd5MfKTGXgerIYcNGBrBc/Gd/vNqEe7syRBEfTHk9MAMbj8Fzi6zk+E3cyybL+fH/0aMQyKHDmQFMJlPXXOcacDokc1tPO01dgiWwATqWuDbvx7w1xreKD95juEILjJtcUf3x+Rt9DmzkhFQ1/upaU08HITGMg66OZpJEwGTeNnj5PeklLA5g3b6oZ/CIBCuDlVJfavxqWOCyRtDyq/U/DX0ASdvY8FmsOQu03uUcef2TTd+Og8QjRaKM03mlC1/LKTzyueuO0BMmcOps+Tl8I2huyAn7Wk3BMqwm8zdzTdynEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwH2b0D/0l76fx/cHsUiLbiJEzfuYOk4lGBh/Dsa6AA=;
 b=G8Mkw/L7qLNP3sn84drRGTtp+KRkj1+w6rZ2P0PHKZZiWO6E9YuXwVbVsvB7dcP2fzsEL/2LP6t8A9ZwlooxoNpKucWJBxTy5WbM4JbFZFMX3fkJuC8z+fCijAfsKCPOVtn/107fHpSg1nXZOgHaYqdtK0+hGY/G2ajDHAgUmtee3oean6+XBIPGZYirYXTdLE0AYrUQj936kZvnV0ca/xBEdkaP+nQ6LzlasPKZ3osFtmA7sHY8L8cSIvSBnF6K06XIFJbk5xjohgcm14FKwcvoRIBK7nJynws/iTLrbsU4ua+8xnC/QucerRcuYBgwpVgrogJRBfiSSIYCpvYu5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwH2b0D/0l76fx/cHsUiLbiJEzfuYOk4lGBh/Dsa6AA=;
 b=VECL/2Lf59CNazcI9XyYyC3bYKeUT2XV2waOVCstJqq6Q5leeJrSmhn7ZefEji5veBDvNrJkZiFypUmT1soZfFANT3rXBHv0/4mskmtcwMEPBGFKZeMJTFHl17vSdWXERFCKfBR09JaNKZ6SVsGuZfHUvKVL3uHL1AhOwhsLvDB/KSnVNGKVyWRKOdbu3rXgmUGTyCbwBwKuTq5IMR/Cm4rVUc+qSET00vC6MLAl4HV1CfyuGatVgUXieRWL0I5igl5wc46TkIMn8Ww2IQ7XrQ6YI8g7DB65/3Rgemd50nbpbq37BXk7aXIPSWARmxLzCWMB5es5eoxyxtlW5qXgvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MWHPR12MB1310.namprd12.prod.outlook.com (2603:10b6:300:a::21)
 by MW5PR12MB5683.namprd12.prod.outlook.com (2603:10b6:303:1a0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26; Tue, 22 Feb
 2022 11:07:34 +0000
Received: from MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a]) by MWHPR12MB1310.namprd12.prod.outlook.com
 ([fe80::5165:db44:70d5:1c2a%11]) with mapi id 15.20.4995.027; Tue, 22 Feb
 2022 11:07:34 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, parav@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 0/4] devlink: Introduce cpu_affinity command
Date:   Tue, 22 Feb 2022 12:58:08 +0200
Message-Id: <20220222105812.18668-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0201CA0002.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::12) To MWHPR12MB1310.namprd12.prod.outlook.com
 (2603:10b6:300:a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5bdf3e6-5e8c-49fd-7e28-08d9f5f386f8
X-MS-TrafficTypeDiagnostic: MW5PR12MB5683:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB5683D3E5A54E897F9FF4F5E4CF3B9@MW5PR12MB5683.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BeIGzUpiTGgw5/6AqO5XhRCNAk/4KoCp4kx5rVvTpN/Xm5Wqz2AhwCbU4NktLY9zFjVuDYbIkhrduDxg5GpzoSGF9D+u+4EII7A6BrSBenAk3M8KQ4qUR3L+clUtEppkFC1OumQEmbtfRD4abXi4Covb8Nk5W9KyAc8AonLjiB/6tuRpnx7/1mLqG0MYjwnCZ1aAD0GY//5d0QTY7NTOEoxtRY0RtrMyh/gmcedmVydvkwp9hb3QtUXoDWlcDR3iHxfBCq3CpdOt9+cSB14vIZ1E2iNwreTvYE3mZ2VaFLG3Ye9zqkrHDi6IlL/aeBC0djIEHMg4a5Uq4znZCE3WDZTvfJfLl1y0smMV+83AuvUt9i1zt27iM4XHJVBTv1sfqBGVdSr8sCWW9GNCO0naRvhkb90McclxY3XU9qPjHkr2p5FYlSIIP8GQoA67Kt/vq1GTosrcmC+cvA6ZNVoMYGD/4pdn7Ld9q6l+DLXntBFAQ3YxAR06NGddTmssgICCEgA1mPKR5zHmQ4uLxL6U07AbPLcVc6KwnyWK1jnBc1jYuc2NrcFgn2kDSUyNEGP99JRbUUK7x1Y5GsGp2c6+jOv8JfDjzitMT3330/AElaoNk2DQpnZQtZ9atHQVwcacLulwZrLkDYj0eJBbgLBgUAHb60pX1cFc3/Pv0lo2nXA13teNtCkIC+OyH06gWumUHTex8wPMCukOU0SMKb5s8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(186003)(2616005)(1076003)(26005)(38350700002)(508600001)(8936002)(38100700002)(2906002)(36756003)(107886003)(86362001)(52116002)(4326008)(6486002)(66556008)(66476007)(5660300002)(6666004)(8676002)(316002)(66946007)(110136005)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?todZIWMcE162RwGYyxQ0aZQDRZuWbVu1mMdMp5ZWqHZMFRmFuC1luz/UpBy6?=
 =?us-ascii?Q?XkyMKGHIlmQQjvdec63Rf7dw1+4iqs5AyCI2MhZppCN5/YlAd+3o+i5IFkyq?=
 =?us-ascii?Q?/+638uj/7UHOm7WuKlb8gR/qj2b6NZ3cygatkoyt9ICQY3SXLcCsdQ4galVe?=
 =?us-ascii?Q?kM76Gje+NP2AU/UF34GQVPOnw+MkIcld+9Qyhc53jB7c6SMAX+fojGl3acvz?=
 =?us-ascii?Q?mfrLiDueaT7igR8EM8zoDhRIaTONcy13mRvLXFuwD9V7nHpVH5IN/i5uf3xc?=
 =?us-ascii?Q?QByneaal2k1l/ahtQd23iSkDGhEQo7/GdaMsBmCBgQbbqWm/08vdHEseW+kp?=
 =?us-ascii?Q?PydlDiaXlOATEdwktrSZtnCAnIz3YaHINDShAf6dUz4XQexcoGpRHTFwXWeZ?=
 =?us-ascii?Q?fehtWdR2HPxMYUEf4ESEm/tEc8oKvWI48Ckq2S4YDp1Ey3Y0eRD6wHe8qGuU?=
 =?us-ascii?Q?VLnt+7MR3d8WkekNPjJQA6Ir5VKaCeYIYufRpebWZ2DIFN1QqhpE/dUX+KaP?=
 =?us-ascii?Q?8ggHUL27dpLI/9So6aURW6neuTPrScg8piY5N23An/yKcwp1ogudYpZseiLc?=
 =?us-ascii?Q?8fKgeR2BGOt9fnuqH5ZxVcrsOg42dP9PJbdw2xa4NVplRDOYrza/XUGlVOMO?=
 =?us-ascii?Q?JuyDPGaSJKbie9bGqgo6vAe8T/hzPfYT0hmLx/FPUqKPV4YcEecKGPGyJdke?=
 =?us-ascii?Q?pdIQRPVwhgWrSfcKDOQcW9vGeZTEZUxFrKYka4YOWAfnBzXA4YFn+cnpAY50?=
 =?us-ascii?Q?Owg2ZAWmIOR7gWuXdGxMtWymrhdhZiQlwb8DsOmvkLLgc3nEuTbHJQHeDOAd?=
 =?us-ascii?Q?MRc3L1QHbXHmGUnnnzf9kfUJVonzLg8LWgqysC0fbzkjQmvJafyBt9j4Naow?=
 =?us-ascii?Q?YoYZklRFWJRAdicNsBSBKGfO2tSQMWvn4AFnzZxeMLARrxxydo4XzAMNmu0u?=
 =?us-ascii?Q?+ZTVw+3OjXq8F7FZ4W0pxTU+mMwhGQ0rdMR8Ha009bIWYKXSbHicAMm6sfPL?=
 =?us-ascii?Q?MDxxm2skGhoqh45bD4Dx/bI4ajcpo9kzH0Lb7vfdHtwJqQvblr/l7Kk3mhTR?=
 =?us-ascii?Q?KqWgqs4jz4ODiaEpe9v7PqMW4lr4dDr2PuBWnVJR/3KJOpQ1mMX95mV8NYXM?=
 =?us-ascii?Q?fRuYTUg5LvuGyWshJwER7VnzWgRSLZIyal0eRzRgILhEYMbCGW4DGCTNG9dp?=
 =?us-ascii?Q?FuyPnEodY6njvbesaAiAyuGNKEJpccNC8kclgJGZek1GQxpmOOUAADqGW8QR?=
 =?us-ascii?Q?ZhFdm+89WaaKedMxmKhETdxNcpUC/TYZ/8QHgUUgeFaWp9qNH9QU39M7x3a2?=
 =?us-ascii?Q?Nw/DotGYYnDtSij/7ErhrKcZfMoKkVvt1Y0FouiagkfFWD49zU6wWIHKjOdI?=
 =?us-ascii?Q?4Iic2Tnk1NGp+cpRToTS8IpGc5qeXYt9QdCG0ce1DFuhwTR8KNgW8Bk1deDu?=
 =?us-ascii?Q?k57CH2GzLqy1bPHrBV+/Uvozoqok0MsglWQlyPZ4AAmcy44saBXHqJ2A46Ml?=
 =?us-ascii?Q?NPYAxfEojZvv4bTIoDR9vBaK38z9fenL00CzZ37zGNf5vmA8HOD6HWkZ/Gix?=
 =?us-ascii?Q?RPseV0UsFVIQ1E6mam0lg1Y7N4uBGh0LvcTDqktDK6Lo0PUT8IsqXQreCmUT?=
 =?us-ascii?Q?Oa5LXR5qgLUG96gVkVi30/4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bdf3e6-5e8c-49fd-7e28-08d9f5f386f8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 11:07:34.3988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Msa7tgUYUVBi3kLVVsiNeLEYA4I3JZiC04rDWU4I2daSv356krWilDwguax9jV1eDTNNSLPPoTnOafpuJ3DVVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a user can only configure the IRQ CPU affinity of a device
via the global /proc/irq/../smp_afinity interface, however this
interface changes the affinity globally across all subsystems connected
to the device.

Historically, this API is useful for single function devices since,
generally speaking, the queue structure created on top of the IRQ
vectors is predictable enough that this control is usable.

However, with complex multi-subsystem devices, like mlx5, the
assignment of queues at every layer throughout the software stack is
complex and there are multiple queues, each for different usage, over
the same IRQ. Hence, a simple fiddling of the base IRQ is no longer
effective.

As an example mlx5 SF's can share MSI-X IRQ between themselves, which
means that currently user doesn't have control over which SF to use
which CPU set. Hence, an application and IRQ can run on different
CPUs, which leads to lower performance, as shown in the bellow table.

application=netperf,    SF-IRQ     channel affinity   latecy(usec)
                                                      (lower is better)
cpu=0 (numa=0)           cpu={0}   cpu={0}            14.417
cpu=8 (numa=0)           cpu={0}   cpu={0}            15.114 (+5%)
cpu=1 (numa=1)           cpu={0}   cpu={0}            17.784 (+30%)

This series is a start at resolving this problem by inverting the
control of the affinities. Instead of having the user go around behind
the driver and adjusting the IRQs the driver already created we want
to have the user tell the software layer what CPUs to use and the
software layer will manage this. The suggested command will then trickle
down to the PCI driver which will create/share MSI-X IRQs and resources
to achieve it. In the mlx5 SF example the involved software components
would be devlink, rdma, vdpa and netdev.

This series introduces a devlink control that assigns a CPU set to the
cross-subsystem mlx5_core PCI function device. This can be used either
on PF, VF or SF and restricts all the software layers above it to the
given CPU set.

For specified CPU, SF either uses an existing IRQ affiliated to the CPU
or a new IRQ available from the device. For example if user gives
affinity 3 (11 in binary), SF will create driver internal required
completion EQ, attached to these specific CPU's IRQ.
If SF is already fully probed, devlink reload is required for
cpu_affinity to take effect.

The following command sets the affinity of mlx5 PF/VF/SF.
devlink command structure:
$ devlink dev param set auxiliary/mlx5_core.sf.4 name cpu_affinity value \
          [cpu_bitmask] cmode driverinit

Applications that want to restrict a SF or VF HW to a CPU set, for
instance container workloads, can make use of this API to easily
achieve it.

Shay Drory (4):
  net netlink: Introduce NLA_BITFIELD type
  devlink: Add support for NLA_BITFIELD for devlink param
  devlink: Add new cpu_affinity generic device param
  net/mlx5: Support cpu_affinity devlink dev param

 .../networking/devlink/devlink-params.rst     |   5 +
 Documentation/networking/devlink/mlx5.rst     |   3 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 123 +++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  39 +++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  85 +++++++++-
 include/net/devlink.h                         |  22 +++
 include/net/netlink.h                         |  30 ++++
 include/uapi/linux/netlink.h                  |  10 ++
 lib/nlattr.c                                  | 145 +++++++++++++++++-
 net/core/devlink.c                            | 143 +++++++++++++++--
 net/netlink/policy.c                          |   4 +
 14 files changed, 594 insertions(+), 24 deletions(-)

-- 
2.21.3

