Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBD65509A0
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiFSK35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiFSK34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:29:56 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDE4BF73
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:29:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsvANvLsGaIwhRz6ZZpfc9k7L5SlMO1SvVhu51Lgl4dXZvv/A4uT1y4sAtcT4d99f0BOqOUnE/aLMkfJyhtJJm7PB/RHG01MYELORV+74VgDJKNBLxAG+OcuiqzwleqOPYB/ZEWeHTW+sG9i8copv28pdPtMRq/8uB5QXMVAOQkUORMK8WdXRxHPMw30tYI64ZAQHvrwg98XQNM1xtknCr6D7kQMig+i9ZCbECFjhy9wvdlKOhy/jnE+ORk7CE+ELsO6Py2qpOkaQgokWqxJFkkzuGrEt1OznbNhdLO+tWU7rTlAXH7yXTjKyJqkiOQ2qc4xrc+4a2SL8Oxhhmd06A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pf90ESZOBi53p7G/f1pvEAcOLmBdIK9wB2OPMjXLD2M=;
 b=aVuUW/t9fOQPJZVhmcJJY1L5x9SA1COnZqYads5goYkPia39RcQGUqxqm58GbEZrYcDgHYTZ3bC7VROwbZqdecDkWHpT3HCaR55PUEewtpYkd9xTym/+/ixZUrAa1fQB3rvUnPTGUpDGg/znCA3ceLd1tfBrI2sb7lvKu5HzQpFusKTfo0yl3t4KYftjcMF8O5orA6kl39VvN50D9hJieL5kX0a4OsvUg6bflK3il25ytgVCvKKftccenwd0Q6HmcpqFlgU0U019zIPfFfyejszG4IAGDsnv4sK0QPKI/JondedAmJZzGES8xTVzj3XFr7236tQ+ex+zCKK8/g0OGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pf90ESZOBi53p7G/f1pvEAcOLmBdIK9wB2OPMjXLD2M=;
 b=MXYCPH393ifZlF9R+HQs0JBvv3DEaRsMJOncEzth1t3mPNCkKhwUytVzZvXx/KD5T6hVcCt2t8kKo3MdcPIRbvQMlgNWkgH2b6u64+/IUIemqvwtxdsVIRLAFrgr+S5NLgxuFhkkRQRIAXleCnm0rUIvRv+edZCTfot1qyAbdmmYJGaaLZI67+vErDKxOqcXYmN/pkNGR5GVturHx+WL4AT0rOB3W5Eg9tNYgDrKTByk2Up0+c2gfBEyEF6GnQcRufqQYwKfTTg0+HepCv3RFJ2+EVPkStWXHuSoA35J+66FPdF+Ymd+vl5VCgWr7nL+tMFRVK7Tnn9nSOCpOF+WFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:29:52 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:29:52 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/13] mlxsw: Unified bridge conversion - part 1/6
Date:   Sun, 19 Jun 2022 13:29:08 +0300
Message-Id: <20220619102921.33158-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0038.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9312c68d-7dc0-428c-05a9-08da51dea51d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11931235FB5C203D67A45DB8B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +EHZ5p1iql9Pa9Rhcq25Mkpv1dLqSIaZYsg87eJPufATHp6GHQF42QFqx/yFruef+ZqtSXgIwzhiqdXl9yekB/t9i27skdA2KNZ9fNyyiSeQv1yLQP5IhxtU5XgcuFb7xaX9hLxA2IXRZfPcZ5ljn7aBJ05LZfqsl/pXGvjslFg91k94RKB3D67phb02oBkbdkBCwwsUInX3JDUyNQmZP7ezjmfCCCIYpz3uC8IrUSRj4ZxbSyUiwIOTxxztjcGu97MMcVFYXDPgsgSpHfCE8SM6WRW1Qu4+OuwqZAqt04vDRGV9/xoRr15DLuuC/muzxxzBGbfV6rMQSLQ79AFRsgn4zO7OHRaT5IvFj4bGFGO/p+IHcMlOlk+Y/otFbEpaWlO83D7TIIrXVB98XzdBt9So5Kf3jmm/1pT1d+F9w8Gn6En2gwopDuAJPcmqgRcbJnvaNV62Q80/eWvgQG6rLqJJKkG6VhwbdxUVvy7KFpozhvtl4sFI2LlIchzkyfwloGA69ZjLpSRvO7w8vUD8iNP/M1VsGwWw5+YzenoSvsWEKHV6twNST1aRJmh+6pVZysXZk9mmJPRsyLXNV6Gj9rhbRK0QVXUj5w/lRAr37d/eUWHzyx7xUcYBbf0EQvAJASNiDwGx/uCXcdHVSgkUyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(66574015)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?98hcaKqYzQQLffCuXb43OzyIGRl23INq2MvxcDBM+EYuQ1iXsbxn+wNtF7t+?=
 =?us-ascii?Q?OSofYSyBZEA0t4nmb4nys4+O55Y14xgUdDScNrsy37dIu7NVTF4nz4/fvXDB?=
 =?us-ascii?Q?C4V8saW8GRbfzAzsGKgy6jCIt3E96T4962AH0GS4gxLlZuWba8beamuVCcdq?=
 =?us-ascii?Q?GiYrIflByNDCUeQfaXU0XHkp3gKO8w0/TDg8+HCSGZbENZTY0YcMcDp4fLRF?=
 =?us-ascii?Q?alSPx1cF4CKSFnlUiO/dZQKtvLTwMINsGQ2N2fjryzNWjUadw2MwMIbYfTUS?=
 =?us-ascii?Q?ktI1b4Xp04yDnL3QdJ+YakbhqhB4H5WSw1blM6+GDz0GQTPHWQUh8aV5lpsZ?=
 =?us-ascii?Q?t8axuGk7cMlGL7tSvyTT2rfujSibKQaAnjXzdVvR1Np+d2ngNE3mQaxKpfJe?=
 =?us-ascii?Q?zi//AFB25GZG51HelARc5XSup3ZAT1RSzEQTQbMFmkh8Fst2XNN8KfNXyUtd?=
 =?us-ascii?Q?mO1VBCyiGsmtOKqx7Ys3+gxP0dJtLsFiMy/vxDn1PJEuOC3eL0VCVdwktGn0?=
 =?us-ascii?Q?lPGxEit5YA0pZ+mhb1HpFE6s6pnc4/3CD+wG7tl+H/c7RY5KZV4P7fDehdkc?=
 =?us-ascii?Q?+Ky4Uv8WHOvwhHYPENAig3/9y+x3Vgkew8LLrkqMKuEBQFXiEyGvcFjaNYNS?=
 =?us-ascii?Q?gZ3oIDRrN4E90cCKi9Ze5iwwvXqFmr7o3Q/5M5eEi/GUncdVj7TQv+Y2NUrV?=
 =?us-ascii?Q?5tMc8Bty9ZRGg7yLdJRCM0WDWchwwa7Ts2cZNzHkWbSpxaE35JMlHDe/Vn2e?=
 =?us-ascii?Q?C6JwugmVxlFx2t5Gly14S8GvyZcfCX9HHdo7ENhoQj9HUO/vqS0iTozslAOY?=
 =?us-ascii?Q?yfScar+MjVh+PXw14CMLV9/z/cvOhv9eY5TWyw4s9NTZCB1ZUYbjft9SNjSE?=
 =?us-ascii?Q?o4DfHOb6C0D5MEQ2pBVwlKIJ+N/B1jUnMFRdgSJ2P3wtzMKTpXJ0OvX5j8xk?=
 =?us-ascii?Q?lhfWG2MhFJyUtBPGXSQcNnYyTjB+ft0Z9lg/ECdOcc5Q4qRxyYFFeeOYsICP?=
 =?us-ascii?Q?LCqHW3ES6Tq6NYWEGcEURJyXxuAHI4aAJC2MeZB8CMDgIQqtcYPazrA+G0hw?=
 =?us-ascii?Q?ZDP2P4F5WAfq9gFsiLK1AA47vvIoolU2iTCKXZw4/7d5TJhKeHSYWMNATuLb?=
 =?us-ascii?Q?q4eX5QRAufIBxmVLlUI/ITcxfxHJ7WzPEdZPXHQZwrji3MHVdf/bsyz4DXom?=
 =?us-ascii?Q?HKTJtCWgNt0dKgMTM9Eea8x1NF94et2EfDlcj2igsg/LDhqYk8CUEuAHCw+R?=
 =?us-ascii?Q?GFQVdIIKGyMKZGMOReDywxgu5Dsygf0MAeao6nMcy2k9sa+kc8965Vjx/58z?=
 =?us-ascii?Q?GnOzaC4AsjPNC+MaiVkDM3AfYxig86owJ69Q5h0LB9YnDtOJW6Vak7M1AYA8?=
 =?us-ascii?Q?LjjR/fUdEHbVi0s4lnL6QJKoP3msQjb7LwF9fAIO/TCVIv142N0Q4isFk7b5?=
 =?us-ascii?Q?QShz8FtKHbxaliCFUFbIQzFekGwG4rHv+0sHQCvR+PGsFQfUwRnhQXkxWLQ0?=
 =?us-ascii?Q?8gZT63drccfksC2xRNEcGCQmM+WtTIhPtKJMRKGiNoNB8rwZGJPys8dJcBOF?=
 =?us-ascii?Q?cqC4/oVse9+e2drswKcXDDsf7GV++qCz17Ge7IpVK+K94rr6T8u5i4VFwKmJ?=
 =?us-ascii?Q?yoTKVdOYo0WcgmibIW//xs00JDMBnFKgRTc+TcJyzoZ0+9HG5tIdr+2NWUsD?=
 =?us-ascii?Q?9JnU/aS5ltWjJ5WYvNkDvvSevp2zkYy+jFEkeZg73t+KJBCWUJqTcmPqv8u+?=
 =?us-ascii?Q?DWmHUjdzNw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9312c68d-7dc0-428c-05a9-08da51dea51d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:29:52.2484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3R2g9oU2/+igBHlAHTLWNFTck9wv02cmkVE+UudNcm/i26351SduY0Roy/JcJKbPYFPoV6UV6QYoQhPfrv9buQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set starts converting mlxsw to the unified bridge model and mainly
adds new device registers and extends existing ones that will be used in
follow-up patchsets.

High-level summary
==================

The unified bridge model is a new way of managing low-level device
objects such as filtering identifiers (FIDs). The conversion moves a lot
of logic out of the device's firmware towards the driver, but its main
selling point is that it allows to overcome various scalability issues
related to the amount of entries that need to be programmed to the
device.

The only (intended) user visible changes of the conversion are
improvement in resource utilization and ability to support more router
interfaces (RIFs) in Spectrum-{2,3}.

Details
=======

Commit 50853808ff4a ("Merge branch
'mlxsw-Prepare-for-VLAN-aware-bridge-w-VxLAN'") converted mlxsw to
emulate 802.1Q FIDs (represent VLANs in a VLAN-aware bridge) using
802.1D FIDs (represent VLAN-unaware bridges). This was necessary because
at that time VNI could not be assigned to 802.1Q FIDs, which effectively
meant that mlxsw could not support VXLAN with VLAN-aware bridges.

The downside of this approach is that multiple {Port,VID}->FID entries
are required in order to classify incoming traffic to a FID, as opposed
to a single VID->FID entry that can be used with actual 802.1Q FIDs.

For example, if 10 ports are members in the same VLAN-aware bridge and
the same 100 VLANs are configured on each port, then only 100 VID->FID
entries are required with 802.1Q FIDs, whereas 1000 {Port,VID}->FID
entries are required with emulated 802.1Q FIDs.

The above limitation is the result of various assumptions that were made
in the design of the API that was exposed to software. In the unified
bridge model the API is much more "raw" and therefore avoids these
assumptions, allowing software to configure the device in a more
efficient manner.

Amit Cohen (13):
  mlxsw: reg: Add 'flood_rsp' field to SFMR register
  mlxsw: reg: Add ingress RIF related fields to SFMR register
  mlxsw: reg: Add ingress RIF related fields to SVFA register
  mlxsw: reg: Add Switch Multicast Port to Egress VID Register
  mlxsw: Add SMPE related fields to SMID2 register
  mlxsw: reg: Add SMPE related fields to SFMR register
  mlxsw: reg: Add VID related fields to SFD register
  mlxsw: reg: Add flood related field to SFMR register
  mlxsw: reg: Replace MID related fields in SFGC register
  mlxsw: reg: Add Router Egress Interface to VID Register
  mlxsw: reg: Add egress FID field to RITR register
  mlxsw: Add support for egress FID classification after decapsulation
  mlxsw: reg: Add support for VLAN RIF as part of RITR register

 drivers/net/ethernet/mellanox/mlxsw/port.h    |   2 -
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 353 ++++++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    |   4 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |   7 +-
 4 files changed, 335 insertions(+), 31 deletions(-)

-- 
2.36.1

