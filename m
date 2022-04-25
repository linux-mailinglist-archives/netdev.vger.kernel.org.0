Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7F650D7CC
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbiDYDsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240934AbiDYDs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:48:28 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC9827B1C
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esODOVFuuVSnNUKdxFIKWUCHP2psS6VBr5/+MzBGgGaDToGRczS9eX6qG5Tq901mF0sOZb16djr6rvqJJDA+1YHVstn0krwm2M2jHSz6nH914hvrVYLR1A7irfT/+2Ln1WoQ2m5Hip8nVKEqLlQDTtUI3zP5b2K2C5jZm1Nw7mOiW9Nz/cu7hD9L2vtOo68bBND5tFRrAj/Svx+qqwXg54qWaCjsVKSNgBNdTWlNkCagRQgJ+1e2YDpHWoKxXHecuqAz1EWyUrwjDhwxdJViy/PtAOFLWAOLSMOx3Mg7UuWv9ri137Qr8RNz6THT4GEaWdN8V5f0CSX1TiLHZdJB/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+TgDVjcrCmTOq4zJ59NDk52PaS32DTzmL1CN5QPmVc=;
 b=UPyDBbDgz5G3kJpjWI3giENMkiBEaVAqRB62K4coQBFZY4mWKZAjxJq8S+vyrH9/3pJUdqydBspVS/7mrHSd/WC0XN+c8bdI6vJw/8KSMqT1FGNLcBzV7JSGqucNajXnj0FCkOJqmiKxlThOpmKVPM+uGsPc1Wp6xNAupwStZNZJo9ByURWaAbMX0Y6OEgu+qQu2lEUliHE1UxiTtnYMcoI0aB/Jny5gMv6baPQhcghyXg/xN7n4Kd1mcrNUNAqavvcaSnejUeLNogoT8VOq2PN4whefj9iFlKfrxiLUxzfeBDu9t6MNXNL2EqVWaT/xEpCbK1gSOk4AvcsVmZ8zHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+TgDVjcrCmTOq4zJ59NDk52PaS32DTzmL1CN5QPmVc=;
 b=VvxLjgnMfgr2y+O8W9AEzoJUdlzfpPuSWvRATNiJZhfwRfK+OtI2cTeaEX5JXfUnukRps91oVBs0RK4GLD/TPInb6JqRIQ+HYrNDgApG5Mbc0m8ezTRPVqXQffCIHEygvBcaPSPf5Xv1uzUAK+sXwy8/IlX+8+OEFpkKz/51A/6uiwKCnVhB2SjUeVPTzsMxNLE+bsk6I/WWUoege1cD6kDJmR6by+Tf0Vpo8VcngKSHUEd3EBzsRO7xOEJLWsViVvIXYpbeyxNEeOprtr+/HP0nuJ1EcU8/iYF7tCshY65LSGJLvWSghcnSRRVLgOqcrZQeXWmR3fnsSgL9imTmnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:45:23 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:45:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/11] mlxsw: extend line card model by devices and info
Date:   Mon, 25 Apr 2022 06:44:20 +0300
Message-Id: <20220425034431.3161260-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0050.eurprd04.prod.outlook.com
 (2603:10a6:802:2::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2589e006-b0da-40e3-0f00-08da266e06bb
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02559CB53540C1F0CD4269CFB2F89@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kSHCgaAYVJfbutlRcm91oY9IXOVqA2Hy4PxPnsJqN6iInqVJ9uVKMuIiPshmxH3YvHtPUjS45JGEoskPLF6PvNPLK5DX17ANbknKwNGjLveTSNUxaPONfEJg0CEFuS/vzla9FFnrR8XpX3znSHDPCFKbEnQD3Q1F8VidVl7Bk4ChHFsrh8of13Ar6kHLA67gkpmVtPzg6ljCQqPGzA6DOP//VwLnxXGyVcacapRFSzGjzSPDlVP35Xgs5uDfYxxGludHyizEdBkBBJyNPRevhNnlIjyLVQKuK3Dii1+Zhm5gFKbzqemiFPCbRwOWBm6UGLVmk50SV/O+Oi++oAtDKAONk9+tuy7bdHypZ79jFrZ3TFMQ1dPTzLT5YtbeDAmBWgO6KHiyKKfoKGQcjsaKDFE5GRhA2jJjWajEUUB5CFPfBGBcD3aIkoXZOEabUcTamLieawoyPIKUN5gcbw0f1Cw5rIYUj2mGGTeNvOQJVk91wGGxTxVN4AK5QpS2QPRts5W4v8MOX0PAQNV1S9GriW6up2sU5eM9FCD+kr7UOt0YKIaXEU6qGkRaU08pSrUlk/ByexBQ0OT28R/E9rm5+M37D/bK3R8k8vkqMAcGXTqBVY/OHnY/MWsqhT6MRi/ICu8Ka/6InzCSEOoT6boeMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(316002)(6486002)(508600001)(8676002)(66556008)(66476007)(86362001)(6916009)(38100700002)(66946007)(5660300002)(6506007)(2906002)(36756003)(6512007)(83380400001)(26005)(186003)(8936002)(2616005)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A69xOqI/2CdGiHUoUuYdT06qXqtU9UfeOMT0T0rKO/ssaJflzRjYQI58gd+u?=
 =?us-ascii?Q?az99O9VbPPqUO1DKY35suAp12RqyyYzul8hn+J6AYgsEG5mCfv5jEnVg9BZZ?=
 =?us-ascii?Q?Ne+Mx06oUDEUfWrtqUbdpqGrZ98pyYM69YpqdjzLu+kgC800Fk6AUh5xwULL?=
 =?us-ascii?Q?Fcej4iOXCff2lw8iDKaAnysFgDAS1lVNi6EGaTDFymNHr+3JdApoyj1OlhwV?=
 =?us-ascii?Q?+XfKhmOcphcZwOcXBQbvyqSkfN9T6/vUJgHVZDaHwg3vzIWn8/beYxRfjjWM?=
 =?us-ascii?Q?e44a9gEkpCkEq9lAL+Og99+xoAeMCSN/0Q/tqycW/cHrd97ElXSS9hG3T+dY?=
 =?us-ascii?Q?R6xW3TGzZAz5p9bjDY38daZkIdDrOSZwVI1ZkL4FpISybt2WR287BNf/46/C?=
 =?us-ascii?Q?5t9rw9WipnVE5QmB9BVG+AKLfQuKUOcJ3WxESO+qRf5n1MS+rJ8nGAkU5Jv/?=
 =?us-ascii?Q?t4GOcAGAYDCLzf6dscvjUQfQqKOxTwqpiuLLqM7XTKu7mucho0pxFZYpyN8y?=
 =?us-ascii?Q?p2a+OH4DXV/C5sY9XJ4etvmowiTuRYp5qEjq9Sg07c418/adqFXXGPmAW0qt?=
 =?us-ascii?Q?O/uHtDzWuLviu3F8o0yzM7Z11FzrfV19l+xsXGmJA3MA80wVsD5alvD06qqW?=
 =?us-ascii?Q?BljF0uAyHY91YWC3ebw78Nu7IOB/nYL6Za+9wtud7Ra3PPYdxqbhFe0FEnMJ?=
 =?us-ascii?Q?XJIzJl8E+6+nT136D6fknoGiCQ+GeqO5riMmcDcZHGAumPkIclnBURlWw8vb?=
 =?us-ascii?Q?tHaoTBPuwkO6WLNGkefxsrYTldMDkROHirYfgTTCOV3xDyXr7AyYb49or6H2?=
 =?us-ascii?Q?cIdYtIQHXo7j9k+3cE5KjElQZSmCEjoKadcEppgzESi8L5XOvFQoesRBNQut?=
 =?us-ascii?Q?gDcV4aOx20JZaPtk4ym80Z4r/az9dYunDf5DVwzqTVavC+DxTctvyZyFQuVZ?=
 =?us-ascii?Q?y0E69fW2L0hRsJ0joeqeQN/E9wNS1VJhZ9rJ+y0kG5Ld0bsfIcuj8nt0/db8?=
 =?us-ascii?Q?9JqKfAmvj4W4sH87OetJfSvMBA5ZLayrw/2Zu0hw0YikQgNkq4ppCzdlG4r/?=
 =?us-ascii?Q?zEIl1vA0ARtv08m7QlGWSq6jYOXn3ygX99SWxSSpD1iPW2RPn4SNM8I5Eb/U?=
 =?us-ascii?Q?iowAJeLENTTnwGDCS2GnQsDaripCqxMuzHqlrYT4pNMHh8oWRyjkuny13tmk?=
 =?us-ascii?Q?CH5W1h/fP+a9LwEKtHJtCT4CK7h/VCgX4NAomlHL3XKJ05u74IwJ0w2yKOwb?=
 =?us-ascii?Q?PZsMvZHY+GG+BpjZjH7tPLVvMYxzSnFG6YCDm+JhVsfCbFTLa8ByV8Mnv5Hk?=
 =?us-ascii?Q?FZXmrK8PsqDuHSPsdCZJ13z64rR3SsyQGUcXKGp+y7mZS49JdD0PqKYUZeSp?=
 =?us-ascii?Q?vW6pD1I/hm7+Kk+4ECR7zkHhobaFkPVxyb+NhGN1TvGEqIizLiHu7P+sAP7b?=
 =?us-ascii?Q?N2P87RXn3Qqj2ZJsaGRd5BmH2PqrZ7bNuPTRhN7xlfsBBC2ofLdZnYCK8Kfl?=
 =?us-ascii?Q?9ETQqNeYvIGkQs8TgxYlnXi1AEqT42mWsdG25a0BD9T96MSdbiIaZNkx6RNd?=
 =?us-ascii?Q?A6L0uzHWIHS/Kh1noPHIcOlDyW1dKuuKaxG7x83s6qafhw/Ws0MF4vIl/jqz?=
 =?us-ascii?Q?N7qLSuk5Jek0ue/LYxQxaxTfMBeQBbcMMk7iVGHN0K+/UlS1lPX75qdmzC0e?=
 =?us-ascii?Q?/5smaG4CCNpmEvqthPm/2j7eB+WJVea7+HAIjK7yqOi0bgrKvFXkk2DEC5di?=
 =?us-ascii?Q?Ccmj2MX6Ww=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2589e006-b0da-40e3-0f00-08da266e06bb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:45:22.9401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mr9E88S3m+mYraSF9BP8a5DAmUYXrip3x0d5w/IbSdrt9n+rB+22KPtE4C8RZX/nXIK49TN+SsT4XfYTOB5jzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0255
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri says:

This patchset is extending the line card model by three items:
1) line card devices
2) line card info
3) line card device info

First three patches are introducing the necessary changes in devlink
core.

Then, all three extensions are implemented in mlxsw alongside with
selftest.

Examples:
$ devlink lc show pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8 state active type 16x100G
    supported_types:
      16x100G
    devices:
      device 0
      device 1
      device 2
      device 3
$ devlink lc info pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8
    versions:
        fixed:
          hw.revision 0
        running:
          ini.version 4
    devices:
      device 0
        versions:
            running:
              fw 19.2010.1310
      device 1
        versions:
            running:
              fw 19.2010.1310
      device 2
        versions:
            running:
              fw 19.2010.1310
      device 3
        versions:
            running:
              fw 19.2010.1310

Note that device FW flashing is going to be implemented in the follow-up
patchset.

Jiri Pirko (11):
  devlink: introduce line card devices support
  devlink: introduce line card info get message
  devlink: introduce line card device info infrastructure
  mlxsw: reg: Extend MDDQ by device_info
  mlxsw: core_linecards: Probe provisioned line cards for devices and
    attach them
  selftests: mlxsw: Check devices on provisioned line card
  mlxsw: core_linecards: Expose HW revision and INI version
  selftests: mlxsw: Check line card info on provisioned line card
  mlxsw: reg: Extend MDDQ device_info by FW version fields
  mlxsw: core_linecards: Expose device FW version over device info
  selftests: mlxsw: Check device info on activated line card

 .../networking/devlink/devlink-linecard.rst   |   4 +
 Documentation/networking/devlink/mlxsw.rst    |  33 ++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 +
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 237 +++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  87 ++++-
 include/net/devlink.h                         |  18 +-
 include/uapi/linux/devlink.h                  |   5 +
 net/core/devlink.c                            | 303 +++++++++++++++++-
 .../drivers/net/mlxsw/devlink_linecard.sh     |  61 ++++
 9 files changed, 739 insertions(+), 10 deletions(-)

-- 
2.33.1

