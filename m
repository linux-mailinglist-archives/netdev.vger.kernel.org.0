Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B620B3C3BE7
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 13:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhGKLes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 07:34:48 -0400
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:4737
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229688AbhGKLeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 07:34:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWGOa/Q5Q9ZcJVLbS8pxqgpsLRzT85PDRUVMknH75ihu/THUUT/lZc2W7wZI3YMA9inq1EXoZIJj6aB9XjXD37DCkex1oAvLL9I10BS5c8XFTfyAltT57EFahIYj2voUeBe056F3mAjreK15U37ib+8mTURW+8qgQyV4BK0pm3EuFTHv2fXPl9P4K92jiu+NZgs4Nm4Bndprd+rSXY7bTbuqEnys2mn2GgXLpd6h4QYDKj2U6K9Wl8gpSM4ShqKutC2SZRKqg5CmfywbXTGCNao5wc13lTu/PLfhE23o8wAqvj+CvJxMK/UGhan5i5kS+r+6Q8cPIlRk1+Cl7w+kmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLmFq1NT9wyJVX3wU45wjrJ4uSHRQzzBD9C+tn6D1L8=;
 b=YiKgTWjCcE+eRMxSIIMQglKwpKqQJ8SzwhobQogazC1VS0M6ClMLr95wFP6faPG6wch8MOe9da/NxEBYtAduyeBHL/p80+LxKPdujx41EK5DZBQ2TACtMP2OVmpTPnahVSRUs74CxEBIJtnWiB7cve2RFbBSZtwaASy43g/+/4C8dK6pQi1AnQEn8yj9Ld5QsB+QULbvtrYmgrhkQraPGHTlO99/Vd+ZcRUe2GSnZzxbcVdZpwBeulhlOaQyOjJ3yXMwFX2oV7NM5H4Yt3jX9aBl7GIxRKd1mLCT6dQTXLmG6NnFzkuFnlG9lHJ07wpwpkY0QPlj5hqo7GRPAydOCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=broadcom.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLmFq1NT9wyJVX3wU45wjrJ4uSHRQzzBD9C+tn6D1L8=;
 b=IkCfwJEL6aR9UJILiuSRDr5txR/lMKxDA7IIkUWrfo2waHXe9xcJ0j/xhzf164Gjw1lymwWIRhcbmX8XcAosmIsK0LGmD/8sqxZ37NeTBOpPuGi8mQRuwKiWRw8jDEaL6e5+y8+jc9Fpg0NnGdyxf1GOmnW+4XbHPy2Xqf7iZLMz/kdaiHOCKK6hhwebchhvF5e8TuhPuAE3E+jVwYgzw1WlpAEPsvQRMqQmrLB/8ssa5/HSS3FomH//vgfVNTn0+RQH6LqRALjOZeBLqOevodoqhKXb4ZdmJFByOpJpg2kYWBYezAc1mJOiwoyG/p5pDkLY2FQ2O1G/44u35Ilc3w==
Received: from MWHPR02CA0016.namprd02.prod.outlook.com (2603:10b6:300:4b::26)
 by BN6PR1201MB2480.namprd12.prod.outlook.com (2603:10b6:404:b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Sun, 11 Jul
 2021 11:31:57 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::67) by MWHPR02CA0016.outlook.office365.com
 (2603:10b6:300:4b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Sun, 11 Jul 2021 11:31:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Sun, 11 Jul 2021 11:31:56 +0000
Received: from localhost (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 11 Jul
 2021 11:31:56 +0000
Date:   Sun, 11 Jul 2021 14:31:52 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Nitesh Lal <nilal@redhat.com>
CC:     Nitesh Narayan Lal <nitesh@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>, <jbrandeb@kernel.org>,
        <frederic@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <rostedt@goodmis.org>,
        <peterz@infradead.org>, <davem@davemloft.net>,
        <akpm@linux-foundation.org>, <sfr@canb.auug.org.au>,
        <stephen@networkplumber.org>, <rppt@linux.vnet.ibm.com>,
        <chris.friesen@windriver.com>, Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>, <pjwaskiewicz@gmail.com>,
        Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>,
        <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        Ken Cox <jkc@redhat.com>, <faisal.latif@intel.com>,
        <shiraz.saleem@intel.com>, <tariqt@nvidia.com>,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, <borisp@nvidia.com>,
        <saeedm@nvidia.com>, <benve@cisco.com>, <govind@gmx.com>,
        <jassisinghbrar@gmail.com>, <ajit.khaparde@broadcom.com>,
        <sriharsha.basavapatna@broadcom.com>, <somnath.kotur@broadcom.com>,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>
Subject: Re: [PATCH v2 00/14] genirq: Cleanup the usage of
 irq_set_affinity_hint
Message-ID: <YOrWqPYPkZp6nRLS@unreal>
References: <20210629152746.2953364-1-nitesh@redhat.com>
 <CAFki+LnUGiEE-7Uf-x8-TQZYZ+3Migrr=81gGLYszxaK-6A9WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAFki+LnUGiEE-7Uf-x8-TQZYZ+3Migrr=81gGLYszxaK-6A9WQ@mail.gmail.com>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d87f20f0-bfa6-4f23-06fb-08d9445f7da0
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2480:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB24802983309FFE6EE0AB5D2EBD169@BN6PR1201MB2480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +RDWxT3KGcmiN03387OXHoMdOimG53fjS211NOgNHqEsaFDF/iJ/h7kSd61L5hjwro2cNly7eIF4V839JfrglEP1KqFrHh0QehBZvMtaiD3xdZW8FQRJy2NICUUla0RcchXFiVCUU4AS2V1qttRa7oFPxiDzjsCCH8/eQwqz7G6HGu55S/kvLu0A9iKDldFa9vRNszvp/oiNQudeD83UDv6OVLdMHFFY9paug0qsyDq2pUSx8dZdFfLk1JwP09mI3Pj5KjZdMohGR14H6q/y1kjWtVax4ziObk1sZfVa9t3rX2FRxc9Z5h6lgZzZBTe+o2GwxF0bsCHdelP56wtd+Z4Go/Kn4GpalSg2VgRp8aRwnPkgPjaUkk6iG6t8DaP6X2x6AFJCOGjjH3gjxGbfXQqlXTg36hWNYs0cW6GHhpVMuJGEPjbG3AEqPzal3FDoukAcv129Y7QuIFBGMYaq29TZlpJ1GrxDlhsCJarmmu9N7LQSUvq9bHZ5NYP6zGTw1/hFnmmXs32wZbr9WJJdBUUUtlyYe8TU4QvZyczOEA4ypkt0pvIDXVFhClpLNADEYhA1Jz39EF00bRGiZoWrhi4cvITrQhEQgUDhDopgHfC6qdZkPoEtY80fTQ18TCP3wit71ouoDuqAIkgr7wlbJa3JOykhaW3bOt9HwVfIjlC6mVvh/G/7RgeT8W70iU1zxwChwx/6XiIyeODQe4ets/2sKiqSpslRt4v86UOK55I=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966006)(36840700001)(5660300002)(82310400003)(426003)(7636003)(34020700004)(478600001)(9686003)(356005)(33716001)(70206006)(70586007)(8676002)(6916009)(316002)(7416002)(36906005)(186003)(16526019)(83380400001)(47076005)(6666004)(86362001)(36860700001)(82740400003)(53546011)(7366002)(7406005)(4326008)(336012)(26005)(2906002)(54906003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 11:31:56.8568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d87f20f0-bfa6-4f23-06fb-08d9445f7da0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 03:24:20PM -0400, Nitesh Lal wrote:
> On Tue, Jun 29, 2021 at 11:28 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:

<...>

> >
> >  drivers/infiniband/hw/i40iw/i40iw_main.c      |  4 +-
> >  drivers/mailbox/bcm-flexrm-mailbox.c          |  4 +-
> >  drivers/net/ethernet/cisco/enic/enic_main.c   |  8 +--
> >  drivers/net/ethernet/emulex/benet/be_main.c   |  4 +-
> >  drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  4 +-
> >  drivers/net/ethernet/intel/i40e/i40e_main.c   |  8 +--
> >  drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 +--
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++--
> >  drivers/net/ethernet/mellanox/mlx4/eq.c       |  8 ++-
> >  .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  6 +--
> >  drivers/scsi/lpfc/lpfc_init.c                 |  4 +-
> >  drivers/scsi/megaraid/megaraid_sas_base.c     | 27 +++++-----
> >  drivers/scsi/mpt3sas/mpt3sas_base.c           | 21 ++++----
> >  include/linux/interrupt.h                     | 53 ++++++++++++++++++-
> >  kernel/irq/manage.c                           |  8 +--
> >  15 files changed, 113 insertions(+), 64 deletions(-)
> >
> > --
> >
> >
> 
> Gentle ping.
> Any comments or suggestions on any of the patches included in this series?

Please wait for -rc1, rebase and resend.
At least i40iw was deleted during merge window.

Thanks

> 
> -- 
> Thanks
> Nitesh
> 
