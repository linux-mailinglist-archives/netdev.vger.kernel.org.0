Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8C0552D0F
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348218AbiFUIei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345984AbiFUIeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:34:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D32205E8
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMcbHwJdYKIgpQaSES0UCaVjyno0mTcHxgu1ckv2h82bkLViJV29Ztn+ztaMZAwYlOUGZI4dnz2RiIE/KBgzvKK0LzRAMBSkDxx8J5SpKQ0iePkkGo0M4RL/xnDSNqzvCOcj/IFNoQAz4QiNXXqq0rORPwQUtopoL+CmN/gftxN9wKdl/psnBaq5HwIVKg1pzgNAnYA6ig0YhumJ6QggdxSI7ML7ecucOX/H+jSeiuVf6dmNds0P/8vdNMMTVhbb8w4zY3xF4SmctbpqN6iYI3236X0TS83+Ooa8SAMQBzblQfBSYVClsYOsPnbuoEg+E7ST64sc3qXC8BXU4T1SKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVTL+/VH/upEgn+8tePVvLsIA2+gFZl7ElPXYh/QYtw=;
 b=QxzaWxeZh+0aT3tTnDW7Ip2N7R4ZpZGWtfvcSEYdEuOBuPTCCOF7fc27aTr6B3wv2GR3I/3oveMgtZfcOeCg/nsOZb+wUc4yIrOIYu4bUvQ9Anux0+OzO9g9P0bM1zkV7n+xdI1vzO6IMB/TweA1iUsqusHy5PXYvBZoyG3WogDEMdQrZ2JNxTq9P3PxFEozzE3tdiiFIO9mKQxiqo6/2ruaz0SxBGabMYKOVs9VtcGr/dZTQ/7qhiYAzA6KL5SoZPhIrlKdeJnpMdJNDM4XvWBOOqGQJM90X1AHWj+Tz1Pjq+IBh0jF3O01Zq/45s2GsTqJMKjUaQJyNqaQrBKWIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVTL+/VH/upEgn+8tePVvLsIA2+gFZl7ElPXYh/QYtw=;
 b=bROoZr0OSj3lY8zosrg5C8wEWhzfD0s6L3ETRBP4NPuThmV7WmG7Lemo6X7gL8/LeI/JRsv4//dEoAvAbDB7LuFG5YP0wI83ZDCBsqhoFyoey8wfWI0wJNRMSyuKUaZtjOMWrcEyNtnMHvyC09EdK/0ljxxHZH/523A/6vhX1ajgzlQ2R+5O4zMRuQzdVLsZ96947Op7GuOmYsugwJoPVPdoe2VLIxUlNuaDOpEcErTEVFW5VI+Ul6t++hp9ZY3nDS9h7ccPUQ1Ht/JorzrOjhHrsXir/lGJjJIuSRpPwVFR6TXG0ebF8M06kjShW5ZF1gafwq2vqsxShzj4XJXTLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 08:34:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:34:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/13] mlxsw: Unified bridge conversion - part 2/6
Date:   Tue, 21 Jun 2022 11:33:32 +0300
Message-Id: <20220621083345.157664-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0101.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43df762f-25e9-4199-aeff-08da5360de6e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5213:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5213426C1B0D9839ECEBA3F9B2B39@DM4PR12MB5213.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9PJ/P4rPQ9o0OaeiUuwjL/qTdk5t0grG7Ro6mJQ7l2it0ZndU812p/ZONXuzqrRjclMXf2VEScmPsd21pwaDq6Fcl4dbmYgldMurRkKp9nZq0mUJKhzIy30TfAK5mEZCKqSLtMrFVxP2w7jGqIP4mSF7se7Da8V3sesW1MdUL1/fdikAttF/z+jfwOJR8Yyd7EaDkGXfVi7xGaDS+OsfA575M+y6QW0dnzp0YZfGZk+hQ7gOqE7xNGUusc8sYcYUQlpDZchozC8nFtXBAx6g0dFrr4/0cRBlVh5qw+emuezDC8eVDCB7EJforiSKDcauenbQ50jGUpQFqlpT3GygoHIMnVTenipGQkaAk7i7LHkwhMVZQIGiLYUwJM2UMl9aW7DcwwlL+8GQb92ac44RRYu/vL+IfjTgz+hcQBtRGqHIKu60AMh9FdxdoH3X0sT4w2pqVGWZ22BGEoiuCfqpuc2W5QgC1KmThKyL4nSJI8nQWievwQQg76C85jZchhjz+6/6yjsAKKcdNRyWNl6T/+FBJhkOcuptRQFyGrwVtiyfkY2Q+HLjwO57Zk/XGlZN14b9fRwRnGynHMzP+O1AI3El7welaJKMkMOorC5/5/2xbMcoeR90g47eejjBINqU6t/eLLGWZXPaUGOf5Zj5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(5660300002)(1076003)(66946007)(83380400001)(186003)(38100700002)(6506007)(6916009)(2906002)(36756003)(26005)(86362001)(66556008)(4326008)(478600001)(316002)(6486002)(2616005)(41300700001)(8676002)(66476007)(6512007)(107886003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ycF2aNibfY/C3X7DmShVdBHemcfuirx9nYTFiaq9x1OYHk4TvAL7SWWWdUm1?=
 =?us-ascii?Q?Dilr/ciIQLHBs2k88LoJW6PqRAVMPnysgE57xsV/OU+iOD39hFKvNmo3ucvX?=
 =?us-ascii?Q?tuUpIWOB3SnDf3suYhjkap07DyMYJK3qjrVjjRIjDSM5bTLnBm3d7Cyfe8ea?=
 =?us-ascii?Q?w3KivQurPWO/IvBRUbD85tCvz+SZyVTPSzA0cwMDWDXsspztKzWn4qW/jWVD?=
 =?us-ascii?Q?sEAVGj/bYAJWimrfQu5ok1B7EeTM7EVTqVr0yeLXMyLYAUkw1kBO3+yiz1hO?=
 =?us-ascii?Q?zgj+Bw66vrKFFdf0mgEiq4Z/kYPE0ZOR8RoLgTfVTGS17NpzXjJjta5EfYDp?=
 =?us-ascii?Q?MdyBQVlo2OLiEM+C9I+nM4Ib8MrtzLk3S6mR7j6DNuF8UUSLB3tsqnuebyrH?=
 =?us-ascii?Q?xegqrpmh5SW1nq1NjDk2NTQf1pXRrc/KP8eigeFZf8SvS++XNPvY/0uvajpj?=
 =?us-ascii?Q?dDIoHOhaPbIxgUVyn6ESzyBWoVXQiw7LZ0EwoMtjlXvJpZeH4Nyben2Lez/p?=
 =?us-ascii?Q?oqyXzyC+y/uEVZ5gGklx1GR7+/IPEAg1ag8lmfkyzHEqIdH3cpk7pmyXLEbR?=
 =?us-ascii?Q?wNmQbrBa0o/wiSTY3JPwrf1v6GtLDFk4aEPptKk4pInx9+Sg5qXoOSiYAQAO?=
 =?us-ascii?Q?s69Em9pF94QqrSfRmicXE+hrp940JaixATgLSd0+pERTS+PiAkGtwfpj6hab?=
 =?us-ascii?Q?naEcRIi8rtf1iGpwdkAArMeNTDN2xv+W6R/EYgMs6tOz0CLFSqOcQBivWnUO?=
 =?us-ascii?Q?9ExkD9EPxrbEiIGOB73/ZQb8wDAQLGSt5ykKbFxpQw1Uokr6N8Ds4p37cbfz?=
 =?us-ascii?Q?NZhpF/myo+zS7htY/zaomY2xBA/8rEpKpUM0jWcdZnDYg5G0Q9IPF1UcxUR7?=
 =?us-ascii?Q?C+QkLPBgHpbp/eZRDvz8yAVczx/6HzwAwnfcfePxHOSA9TZxFH/p03AapxZB?=
 =?us-ascii?Q?/0FyDAYtQmbZlRXOv8nF0PN8m+zyXVDCvRahTc4C9krzjmDO7EppVHOy+u0j?=
 =?us-ascii?Q?UDbrEOZLukP3dRvbnSLAcAsrYkztL9lf8yNAd+CZgrjsHUvpThKpB7+0X8F5?=
 =?us-ascii?Q?dd6t/VPnCN0z0hp44pnfFvVtiGeBfENOYiwL/2yJJSnjNQkZPj7CoVWN+GQY?=
 =?us-ascii?Q?rcftOdkz+vf1YlsXLmYCYOgKg4uo3RdN0wvp5z8oGVOEjegS+9MKFj12iNe7?=
 =?us-ascii?Q?eQgMBK3BAypTWB7i/C816poD+jJuoW5bF8Nu9L5zJwscXI9F+EIp5Mc9jDxe?=
 =?us-ascii?Q?sjksFTBZy0oTn1b05DDe6kb8XSJpbtOqU1tTFqanUhAkjRItJj/FpsX32br2?=
 =?us-ascii?Q?xz/2m3BvZP14x7TRr8G3278NmosqQuZqvYeRnwJcr7uIdA0gCgEGB+5TMEJm?=
 =?us-ascii?Q?gBi5VMEvY9sZvTRoktEHTCyg5pM79Hv2Bf9xnFkdrFV5iE8o40bvCxxJdjs8?=
 =?us-ascii?Q?aV1UaV1USFF/ciIBzB1XWcaIRDt906Wh5Jr5yeoQy7n3mVkx3G5wSz2Zhpch?=
 =?us-ascii?Q?GG1UqcAAqKyMTzjf69ZY34Yzgxdla1kSDmu2Hxjv+qUHa2HFObEC1AJGm1Lk?=
 =?us-ascii?Q?gBya1PbDPP29bDGRXaqw/P0t+Igu2OtLyf5mV/m1QZEor/e6ST1hBAhRQdcR?=
 =?us-ascii?Q?HRN+dEI97hDERj7/e+RQ9Cs4AwOKxf0gX6GY+pn6jH2A0rvRAhHkTIWgMG7k?=
 =?us-ascii?Q?SU0grry6ScE9U2DV9cMg1pJhhdIRctdJkXsad86v4iUUAeAerN3ia+w0xlbM?=
 =?us-ascii?Q?woE+2b32Pg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43df762f-25e9-4199-aeff-08da5360de6e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:34:34.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZ+/bA8H9ek2lhGhxUczwzv7dAosqMyXj05lkbjZD7EFp1ABq6yBFWUw76n02vWE5ldrQenyzolGFL5TVPa0uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second part of the conversion of mlxsw to the unified bridge
model. Part 1 was merged in commit 4336487e30c3 ("Merge branch
'mlxsw-unified-bridge-conversion-part-1'") which includes details about
the new model and the motivation behind the conversion.

This patchset does not begin the conversion, but rather prepares the code
base for it.

Patchset overview:

Patch #1 removes an unnecessary field from one of the FID families.

Patches #2-#7 make various improvements in the layer 2 multicast code,
making it more receptive towards upcoming changes.

Patches #8-#10 prepare the CONFIG_PROFILE command for the unified bridge
model. This command will be used to enable the new model in the last
patchset.

Patches #11-#13 perform small changes in the FID code, preparing it for
upcoming changes.

Amit Cohen (13):
  mlxsw: Remove lag_vid_valid indication
  mlxsw: spectrum_switchdev: Pass 'struct mlxsw_sp' to
    mlxsw_sp_bridge_mdb_mc_enable_sync()
  mlxsw: spectrum_switchdev: Do not set 'multicast_enabled' twice
  mlxsw: spectrum_switchdev: Simplify mlxsw_sp_port_mc_disabled_set()
  mlxsw: spectrum_switchdev: Add error path in
    mlxsw_sp_port_mc_disabled_set()
  mlxsw: spectrum_switchdev: Convert mlxsw_sp_mc_write_mdb_entry() to
    return int
  mlxsw: spectrum_switchdev: Handle error in
    mlxsw_sp_bridge_mdb_mc_enable_sync()
  mlxsw: Add enumerator for 'config_profile.flood_mode'
  mlxsw: cmd: Increase 'config_profile.flood_mode' length
  mlxsw: pci: Query resources before and after issuing 'CONFIG_PROFILE'
    command
  mlxsw: spectrum_fid: Save 'fid_offset' as part of FID structure
  mlxsw: spectrum_fid: Use 'fid->fid_offset' when setting VNI
  mlxsw: spectrum_fid: Implement missing operations for rFID and dummy
    FID

 drivers/net/ethernet/mellanox/mlxsw/cmd.h     |  25 ++-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |   9 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   1 -
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 120 ++++++++++----
 .../mellanox/mlxsw/spectrum_switchdev.c       | 155 ++++++++++++++----
 6 files changed, 240 insertions(+), 74 deletions(-)

-- 
2.36.1

