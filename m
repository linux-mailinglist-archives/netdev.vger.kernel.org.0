Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA634CA96
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhC2IjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:39:09 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:45856
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234191AbhC2Iik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 04:38:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nala3H4U8tXtcEVeFPHlbI01npcNopXimgL9gZ99/WYA6KtY5bjFNlSYoUBqDfRGFJfqfIePolD250hbScsj64amPAhOMSFdMlvBA/c2aFsq0HkLqmjSMJyybzx3Tp9jRehrFGZAhgZ5OV1sVeO6BKdnIsomqxghgflGu+BessswFv6DSeaJEA9TnGlDYZ30okyY7ptsVhYNJHFdHQMtJ3qTkXyt2c7n6qQD2i1kifCW7OiKK0lb5WV7ukT5GZ8r39PtzWpwXWtJpTP3m9+5bBFBy2ML9RsxTQnHpS4fIvu7I9SMv1Vz7gfYFDEFfJiXJ+RvnJMhYmT5lBidVcqEWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOcdve3W7d5hKs+/bon4OlpX4iyXjyLrFV/G7y3IPrk=;
 b=cSqb5CUtUmsnscHLMjjeyy1QinXSUBxcs99kiI/8sNdHJ1JLddr/EIXpe/hoqulQdNuDh0oXiHjiIpAC1UA6M/qfVSk0QmAdq/J9Ox/sZ5D10KP99ZU2L4eoR4ARIIbzn7f2w3EsvAGeS6yDMgYSTXOnTTpna58DjsDmBcEC5vijW+Z+YpI3QWtg/cqyZzAcwJ96FiCXq+gdEhet8ps97mt7Gqguvyyk4CmjILMvi59YyY8UNMhKnWlZGYUvpZ30964ykKrtMxO6S1zIaaIWYxHzX9ZeFwLV1UtzUF+s1ul7MiAoduXc+C8kcfdxRhuhZAQSI/7uLHvR3DRCx3nOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOcdve3W7d5hKs+/bon4OlpX4iyXjyLrFV/G7y3IPrk=;
 b=hqiN6iCXCKJQZHOaUgnYOlfvyvBMZqdUVxgRqVzEG7wqPgMHVQsKLTNt7Ids1LdevPDreoBSdQG9bz2pR3iSn0vl7EmVdtPa2l5TNK/GDJAkdc4xuD5XVbI+8K43joVv1YRyU4YElHGRB5XLi8KbVLRF10nd8dXjzBZLObzR8CVR4YLBTwM+pWF7tNPjkRCYE+u8aImBsIYqTSnF01Hn5rJkTHS6hijTN/+3qNRWRQFx9sBxIh2+ADkkNqCzNvTVuVvpvlrnTTFm8Ua+zuA0syc8JzZCgpS7Awvv4zcCii8psnxh8tmjfo5m1me1H+J/O1Nulug/KEFxAceiaSMBtg==
Received: from DS7PR03CA0211.namprd03.prod.outlook.com (2603:10b6:5:3ba::6) by
 BL1PR12MB5158.namprd12.prod.outlook.com (2603:10b6:208:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Mon, 29 Mar
 2021 08:38:36 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::26) by DS7PR03CA0211.outlook.office365.com
 (2603:10b6:5:3ba::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Mon, 29 Mar 2021 08:38:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 29 Mar 2021 08:38:36 +0000
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 08:38:35 +0000
Date:   Mon, 29 Mar 2021 11:38:31 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <jiri@nvidia.com>, <petrm@nvidia.com>, <liuhangbin@gmail.com>,
        <toke@redhat.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net mlxsw v2 0/2] mlxsw: spectrum: Fix ECN marking in
 tunnel decapsulation
Message-ID: <YGGSB9D30MagfbtZ@shredder.lan>
References: <20210329082927.347631-1-idosch@idosch.org>
 <20210329082927.347631-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210329082927.347631-4-idosch@idosch.org>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d33816c0-8ed8-44df-b557-08d8f28e0b75
X-MS-TrafficTypeDiagnostic: BL1PR12MB5158:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51589BF7F1BADFBB75F4B8FEB27E9@BL1PR12MB5158.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/bHxAncIPKLuwbxhH22j6aYntOsV0NGocTPjPV9+gqHYhz/wqhWhymD21LOZxISV3T3QZxK92s/2+pyXYSxdyNO0VbB1IlH0CmfXgG409LZVYjDBoVEUFBk3UNQe2AeSlBxvUme6gOlJk2ziU2Hd0y4wXQncJz0+RFiyRUkdKb1US8JQ9qFIrtoQN/iV+tHCfFE/kQvuRDXhuiSbao0pEKbhusqUGSYWgclCWq6kn/rnXRP2AF1aS9YLnXhTalBLLPPyRS3SG3Nx6xNsLS+oUARAtcHrson+wb3yo4YEN4tgkND2R98xQdixUBHguIptSxEQODcq/yPkWQeABTTPfw6Zin1QbMKD/1QFs9KAuX6Vxq0M269GpzCPR+5nJlkFMagRF4ZV92mvm8jfQ10ZNCSOsVnt/bWsuVQp4aGZVJ51jQoToFy0h7g+IaggYNfBPvTAGqI/1yT7Ly/7An7jjkSgWrE71PMuDxPpeqsgkePo/YiCe8Y4ckYdQ6iJK3ITG0dCgsZPceGVlZZfEIWTxeR1sLG/S9xs09kWdXcSDRc0Y1Nf52VsEOCtufXVgOtWXy9adOUwXDLCiVeSCaWdXwn+ZRzbKL0ihp0FuxwKQb/8l6t7o3y/0d453Ql8laHoqTt+cUlERtP5o+Udxa1NJnag7uSxMdky8+vSqsCO80=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(54906003)(316002)(36906005)(86362001)(8936002)(107886003)(6916009)(8676002)(186003)(478600001)(26005)(16526019)(336012)(4326008)(7636003)(9686003)(47076005)(70586007)(36860700001)(83380400001)(6666004)(70206006)(426003)(5660300002)(82310400003)(36756003)(2906002)(82740400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 08:38:36.3257
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d33816c0-8ed8-44df-b557-08d8f28e0b75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5158
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 11:29:25AM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 fixes a discrepancy between the software and hardware data
> paths with regards to ECN marking after decapsulation. See the changelog
> for a detailed description.
> 
> Patch #2 extends the ECN decap test to cover all possible combinations
> of inner and outer ECN markings. The test passes over both data paths.
> 
> v2:
> * Only set ECT(1) if inner is ECT(0)
> * Introduce a new helper to determine inner ECN. Share it between NVE
>   and IP-in-IP tunnels
> * Extend the selftest

Sorry about the "PATCH net mlxsw v2" patches. They are the internal
version of the patches and I sent them out by mistake.

Let me know if you want me to re-submit.

> 
> Ido Schimmel (2):
>   mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
>   selftests: forwarding: vxlan_bridge_1d: Add more ECN decap test cases
> 
>  drivers/net/ethernet/mellanox/mlxsw/spectrum.h    | 15 +++++++++++++++
>  .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c   |  7 +++----
>  .../net/ethernet/mellanox/mlxsw/spectrum_nve.c    |  7 +++----
>  .../selftests/net/forwarding/vxlan_bridge_1d.sh   | 13 ++++++++++++-
>  4 files changed, 33 insertions(+), 9 deletions(-)
> 
> -- 
> 2.30.2
> 
