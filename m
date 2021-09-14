Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12ED40B22E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhINO4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:56:05 -0400
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:40928
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231816AbhINO4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 10:56:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8zJOz3n5g7K7OB/OeqqXo9j4lIgiryU2Q3nqSqRQR+MHz1zJ6j9IXtLoEs9KJs1pNTdT38YN18dEGE1QjB9rrRbRPN1APc2QS3mCTnrGdoORhV6m/9zzLCGqgYIC0Cg9chdR92jdTEIcFZTOr+mQ6BmbuR29coOytXDVzWUadGXSJB/N42v1EQfyTE5yh3zVvVILZ4wHMqgS+u5dMIt+Dogr3O847tV6YuVwJn8q4al6flwUn3VubglgkKAycdwQg6t82XmK4WcljgKOqi2aiMrcLUkQCblPupSIorcinbRpDpPbCYKExby2KyOCx1vrUMaeQ4qayekFv5CzGk2Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fC/AEFYePfxEQFmmW5rHz0JEoxJ46krF8pgt5pE+PhE=;
 b=bjUXkJl71oEVLiaJyXFllsqsfkrr67Q5w0pRflnJr8SNuCFkfzQaNY8yRliR/3p0NLOHax/cwsq8WPPXEHBwn1fo/H4cOUHZ+Ga/tsTNMntctZpb1pr9eXIbAMBFv1MDlThzCq+eGSkEiXE2CNCvzyJXJSvu/mSVCJLtDh1rZCNJ/ZDWR6pBdxN1y+kr2y9mGX0QZQIfkYZ9ktqr1asqOFDI3lGa0pOyYNiCgOCyYY/uwa+dCHCaKFSwU86P0rf0cw9gvg2RKh52KJXPFxH6V2h/9/MFTFrsxkr/BCYFIedTifRhSaWs21jHCVrCMk1EGweCISr7nkRA2RA0adVH1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fC/AEFYePfxEQFmmW5rHz0JEoxJ46krF8pgt5pE+PhE=;
 b=IpvLJItmKZeHF4ZlnNw46Zz6Gzz0mjyPEc0y8kMDQTNgH2s+w7NQ9ApEluVTXTQAfUoIohfivu5JhW94WgueDMWPfeS/yEM2lI4bFQ/9rq8hfCAAb5fQGLANUM6M4AqcPhriGxjd4hPKHAi6oOtTgcO+5tMFF/BhIogbLqtv8yLM3MFG2MNDzIsEOCkN8iccnM/IBvIIyLj009wc6tcwG9D9hc/RRyUdvj5kefrstMVLVDcZzXgXvlkcniDHq8UC37cZGxdSeeTiOkwaWsSliaPLZRwQkcRTLELJ0oOFGQP+WRl50Vu2d5Y63qs5O7SfggbkaZxwEKc4sdwLXYCJRQ==
Received: from BN6PR17CA0035.namprd17.prod.outlook.com (2603:10b6:405:75::24)
 by CH0PR12MB5041.namprd12.prod.outlook.com (2603:10b6:610:e0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 14:54:45 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::8a) by BN6PR17CA0035.outlook.office365.com
 (2603:10b6:405:75::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Tue, 14 Sep 2021 14:54:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 14:54:45 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 14:54:44 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 14 Sep 2021 14:54:42 +0000
Date:   Tue, 14 Sep 2021 17:54:39 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <john.hurley@netronome.com>, <sriharsha.basavapatna@broadcom.com>,
        <ozsh@mellanox.com>, netdev <netdev@vger.kernel.org>
Subject: Re: Questioning requirement for ASSERT_RTNL in indirect code
Message-ID: <20210914145439.GA6722@mtl-vdi-166.wap.labs.mlnx>
References: <20210914060500.GA233350@mtl-vdi-166.wap.labs.mlnx>
 <20210914072629.3d486b6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210914072629.3d486b6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64b5d0f9-543b-4760-61cb-08d9778f977e
X-MS-TrafficTypeDiagnostic: CH0PR12MB5041:
X-Microsoft-Antispam-PRVS: <CH0PR12MB504148A438861C9607135D0AABDA9@CH0PR12MB5041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jIqCRsYKqJqAw2USERzrt9vZ7CkY4oDn6KLwL2Y78BP7YcRYZGHDwv5evBwUZpNXpWmnargjQIYgiV75+ZVf/8IB2+N9ZljqEf/cghcZs9tiD/Oh7dwthzsdwdq/bgxM6zr86Ibkg+WsayHebMsyMSHw4RB7nvze8nnZaOqEnqi9qBgClU/fwvE14rx1WJsakIyvbF6M3x4mDtZUXV4KAOLoo+wVDXQplICh9WcBESfmTF3YyM7qXYUJnJrbDPa66N2V9+uk0Mk1ym4n/+9yCJg5xpV/EGOr1Dn5UNn+6OKWLgcQypppKw/e0AUgAGR7UdrzAJ02GB7xCk8MxuBrAOd7GucU6OWn+LkJd5hYVjdLPTkOWpiiIfNcuTpiHpf6QwS5oitaT0CqzKn4ESz/0kqhE7W/emoh7PnzftrReTCkZFry15KiW2no89pNSRseV9ZLGwmKxBxwdbMzMVSiuuIX25PPXTR8idM2RMz3Iql9U5I9ebrsizcjigeG3b4KOyfP/hMBa0XOpRwV1jKY37fXfZAhOgCbOay5AYcGaG6ayk7n2KET6D1NW30gHE8I7L6C6Z9CPwZtsOKyZ+me0i7OCM+b06wCvXzFp0iT54upK2yUgNLNKXG8TUyXNUjDG090L4TfHQPwwPrtbXdVHfJzdBwAV3DwirckcGuqwlRa2vNu4NxaZwPDYvDzwaYedyOlyx/bE/VaNEIVU4QpQQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(36840700001)(46966006)(6666004)(478600001)(9686003)(2906002)(8676002)(54906003)(336012)(36906005)(36860700001)(86362001)(5660300002)(83380400001)(6916009)(1076003)(33656002)(55016002)(70586007)(16526019)(47076005)(186003)(8936002)(316002)(356005)(7636003)(426003)(4326008)(82310400003)(82740400003)(70206006)(7696005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 14:54:45.3517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b5d0f9-543b-4760-61cb-08d9778f977e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5041
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 07:26:29AM -0700, Jakub Kicinski wrote:
> On Tue, 14 Sep 2021 09:05:00 +0300 Eli Cohen wrote:
> > I see the same assert and the same comment, "All callback list access
> > should be protected by RTNL.", in the following locations
> > 
> > drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c:1873
> > drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c:303
> > drivers/net/ethernet/netronome/nfp/flower/offload.c:1770
> > 
> > I assume the source of this comment is the same. Can you guys explain
> > why is this necessary?
> 
> Because most drivers (all but mlx5?) depend on rtnl_lock for
> serializing tc offload operations.
> 

But the assert I am referring to is called as part of setting up the
callback that will be used for offload operations, e.g. for adding a new
filter with tc. It's not the actual filter insetion code.

And as far as I can see this call sequence is already serialized by
flow_indr_block_lock.

> > Currently, with
> > 74fc4f828769 ("net: Fix offloading indirect devices dependency on qdisc order creation"
> > 
> > the assert will emit a warning into dmesg with no other noticable
> > effect. I am thinking maybe we need to remove this assert.
> > 
> > Comments?
> 
> rtnl_lock must be held unless unlocked_driver_cb is set.
