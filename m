Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C182F35B2FD
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 12:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhDKKJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 06:09:39 -0400
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:7585
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232223AbhDKKJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 06:09:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyLK3OuriXO1OG8KpEQg0AO1bBK43YYWcp0w+7A68YvEhZjcb9X4MFPDVR1SpgpICxf9N8Bqo8QXIyRrb0UYv2fpYITAwJrJlirja8/wF0MTe364x0Pyss9GsXskbmnVWdiTNJ4BuCg74uR70w9Q/oL8q8Sc9akMRUqk7kc0sWOU9mSzgX4SKfVybm5hrhUw9+7zZeSg+SMSjwuRDonwf1ZPKMSj89VbV1nDiz32lVxjo1wjp3+D3HvTsyNDymyACKI3x1Y2VVDvlTDnuYyCsGW1/u4A8aadJyinJNYoan0So3KzFjQDAMh/nd6+HzguKaeoCVXSmKdytFpxXTfxFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niXmtql2X4hII0Hfz6p5MpyvVwsx6ieFpWWcK3XHtuE=;
 b=lkDYo0LSVyczaJTGp0uRJjVxuPC1OoDbI/w+fUJRc1qFIIO/hsU08wuQKjexFi4S++Xwir0ftPvuAGHRQy6Om6iNih9qlZi2zlvsBxxab7O0jO2Ww1NDavNIrxbXYS2oUl0jSK0Awi224QWxDWpg5/DpGvqlZCznuW0SXtcCot+h8piDc6Vr+DC6OB55pjvQrgcO+05lQ6Ni3PfR7+W/L1P0vF3urkyDrKS2gwLkixyu4BVDAg348yx9ZqSnH9AHGfEyg5f9HwcsYZ0zTxIEdn8GHYe/ymMo8AGf4ztbF5UwrzPVHJrJGWRi4QARqHhCz2PIDeng66n6cofSTgkwlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niXmtql2X4hII0Hfz6p5MpyvVwsx6ieFpWWcK3XHtuE=;
 b=DI2RNYNq4kiu5Fpj/cgfAdUCqUViA77IHaHkkibUf5BJz7umYya/hLobKXvubG9+d+mR7dZVVQJyL3YEy5ZetWv3HoRIlPZS8wyGWHmCJHfiwCtUVQnf4xjyNuO8lSQ1gWoKUM9LJLPeWzuMz81Dpvln9uo9b/qb8QB4BWExLFvg2C3akB6dHFMOVC/XQdp+R2L/qnPZwMENfBSa1H1q8MFS7eTVIE8tPkfitKYCFPXvxvZG0yVZGyw2dYZ/W3inheG6OjyS9rCSPEikURojd7Jd9DFlpJzv+9gXRboVRgvrhJIpagUO2cpRJlCXwsXdI7I/h8fpNf1WNHB+S28nng==
Received: from DM6PR12CA0024.namprd12.prod.outlook.com (2603:10b6:5:1c0::37)
 by DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Sun, 11 Apr
 2021 10:09:19 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::13) by DM6PR12CA0024.outlook.office365.com
 (2603:10b6:5:1c0::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Sun, 11 Apr 2021 10:09:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Sun, 11 Apr 2021 10:09:19 +0000
Received: from [172.27.15.30] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 11 Apr
 2021 10:09:06 +0000
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     Honggang LI <honli@redhat.com>, Doug Ledford <dledford@redhat.com>,
        "Adit Ranadive" <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "Christoph Hellwig" <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        "Jack Wang" <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-nfs@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-rdma@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        <netdev@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>,
        <rds-devel@oss.oracle.com>, Sagi Grimberg <sagi@grimberg.me>,
        <samba-technical@lists.samba.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210406023738.GB80908@dhcp-128-72.nay.redhat.com> <YGvtFxv1az754/Q5@unreal>
 <20210406115323.GI7405@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <1ac705a6-0504-fa6e-4d4d-5256b40c363d@nvidia.com>
Date:   Sun, 11 Apr 2021 13:09:03 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210406115323.GI7405@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f19b0805-f25e-448a-a41a-08d8fcd1df33
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:
X-Microsoft-Antispam-PRVS: <DM4PR12MB52299544E03557F393570383DE719@DM4PR12MB5229.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itazsxFFFurAQjJ+0VnFXXXyGDMTFZuxOv2X6p5cBARmhMA3t1R5Kwe1yptq8GKTm6CeVwmGv3rlAMTeDPPI5JBXlPyHMHjhA8wjy0Vp8eFyF/ZhMPTy0LiCcIge0FPI9Ze5hzl+SaLDI6Y5jriciZlvHfzuzMQPm+KG5UpeCrzWIshfklsYQ7QmIkclJyFdYNS02NiQ+//3KARZ0oc1NAensmkh0zQgrvgXE2kUksWudp2RDKLJeZV2XFtdYJFcUOmlrHwTth++XXTtsQEbXWohZyPv4F0qLtcZjF+MtCMdyg8JgqnUdNOInrYSA+QIwkPltvcJFWQOW80ic7QAOZ64Z/b/b/uGWLRZX52DOdWJlAc/sOMVEDt2trKKWIHNGYDxedkQhtUI7UrVhlA7olVui8ASc0mTews0kPm171JEXso8+1i2wU1pxlI8N2PAWQDtpr5jjqiOKJbIogeRfkpkUouTrSgpAx7O/xWKgQxq4BWYUvERUQDEu9b0HwqYou7FVA6lIS0yxeS9eOSGRiVrhoI3CoH+Da2hk9IeEi7ZvGIq/IbY5ik6Q1mPgRZMT5/Ji2zb1n4LySXBLUVWGE3rcijzEciQ9fqW3bItnhttnvSprYPNdd8ZTGNT8L89BMwfofuP/LovKUubNZ6c0NZ4u04T7I7l7yFY4h6Tt5q6SyYJdMBUb3xFFNrJK1ckwzuadyt4Lw0jtmr8TmjEdkGNaX6+q8BJfTgJfWUw/79AKjVgdLUESE08h3JLh8tLMcjPSBbAvaUEH8BIQXwJdg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(46966006)(36840700001)(31696002)(36756003)(86362001)(70586007)(82310400003)(53546011)(83380400001)(31686004)(70206006)(7636003)(47076005)(336012)(356005)(7416002)(7406005)(110136005)(54906003)(26005)(36906005)(16576012)(16526019)(8676002)(316002)(4326008)(186003)(426003)(2616005)(8936002)(478600001)(5660300002)(6666004)(966005)(2906002)(82740400003)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 10:09:19.4933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f19b0805-f25e-448a-a41a-08d8fcd1df33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5229
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/6/2021 2:53 PM, Jason Gunthorpe wrote:
> On Tue, Apr 06, 2021 at 08:09:43AM +0300, Leon Romanovsky wrote:
>> On Tue, Apr 06, 2021 at 10:37:38AM +0800, Honggang LI wrote:
>>> On Mon, Apr 05, 2021 at 08:23:54AM +0300, Leon Romanovsky wrote:
>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>
>>>>  From Avihai,
>>>>
>>>> Relaxed Ordering is a PCIe mechanism that relaxes the strict ordering
>>>> imposed on PCI transactions, and thus, can improve performance.
>>>>
>>>> Until now, relaxed ordering could be set only by user space applications
>>>> for user MRs. The following patch series enables relaxed ordering for the
>>>> kernel ULPs as well. Relaxed ordering is an optional capability, and as
>>>> such, it is ignored by vendors that don't support it.
>>>>
>>>> The following test results show the performance improvement achieved
>>> Did you test this patchset with CPU does not support relaxed ordering?
>> I don't think so, the CPUs that don't support RO are Intel's fourth/fifth-generation
>> and they are not interesting from performance point of view.
>>
>>> We observed significantly performance degradation when run perftest with
>>> relaxed ordering enabled over old CPU.
>>>
>>> https://github.com/linux-rdma/perftest/issues/116
>> The perftest is slightly different, but you pointed to the valid point.
>> We forgot to call pcie_relaxed_ordering_enabled() before setting RO bit
>> and arguably this was needed to be done in perftest too.
> No, the PCI device should not have the RO bit set in this situation.
> It is something mlx5_core needs to do. We can't push this into
> applications.

pcie_relaxed_ordering_enabled is called in 
drivers/net/ethernet/mellanox/mlx5/core/en_common.c so probably need to 
move it to

mlx5_core in this series.



>
> There should be no performance difference from asking for
> IBV_ACCESS_RELAXED_ORDERING when RO is disabled at the PCI config and
> not asking for it at all.
>
> Either the platform has working relaxed ordering that gives a
> performance gain and the RO config spec bit should be set, or it
> doesn't and the bit should be clear.

is this the case today ?

>
> This is not something to decide in userspace, or in RDMA. At worst it
> becomes another platform specific PCI tunable people have to set.
>
> I thought the old haswell systems were quirked to disable RO globally
> anyhow?
>
> Jason
