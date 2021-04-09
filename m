Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E43D35A395
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhDIQlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:41:07 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:35651
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229665AbhDIQlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:41:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AH141uYNFbVqu93iW4emaPmLm5MEa3PUlzKuTZi4vaGNBDuNrUAlsFInF0TJXLh4uTpYas1VJuSPeoX9S7mnGnwex83v0AM9PFSRlO7O7XJYPssZjjKAsEAIqb8UL4umU4H3CN5nItmDvmvixUqpsnpDVwlvAQBw2jUHasbylXqqsS+n5IZZ9IhyT6H4ThhV9jxymKTvPIwjnbGddFeNu4eJIbx/9WjntdZKgzZAqbTtG4RPrhBeSfCYvIcuKopXxVUCn0spI9JYixETe82/cJcYzl1JlqRBzIph5uIAkuqylgo62QvTSQpZO4bIKQHH6XcPZzuLLex1lb2QZjE3aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89vZy/AAstIH758oNPjsVLf8WUKDU5Y/7tEJWneEiB0=;
 b=VsPMYFrzEJThJ1H+5kOHWEGztl2ysiDNgLL9NNJU7sYO/tGPcKvf2fkCbz1umsJtNVzxxrkOyzoTzfbOmdScghQ5mGK9h0LrxG+d3OFOYXYI3STjB5zT4zxWyKaYU4xiz0/2QMcaHeV9hSLlvxLRI9jKFx5WBb3JgaexvqGxIbAwSxT+m/ZJ6oWOv4wFqOmwTTEWjJDTUC62yTZ0bxDeAStXkQOtdaZ3oeqbB0SwhSmT1zC0zNwNE9DsoPB+CNzrKXASTuN1ol/lbEc4IecZCbxFqHLXY8DrZWXwHnll82OlNJetygSgwOHiUHn6fOq1TgcvR3vfDSkc11LjcKT/ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89vZy/AAstIH758oNPjsVLf8WUKDU5Y/7tEJWneEiB0=;
 b=jPCvT+4krAPzNBf7uSwWySHJp3KzPd6PhsXrRXoG2GIzTdPmWjdpphEgO7lpQk3HeSln909IE9wP0X38DqfGrdgNmSToD5khCk6hYezHMwAy4gZ1gnqQXCcWt34gLSHpVamRlY8UURQ06h1U0NNPJHZd+9L5Thz5j7IxAbmQ10r2TkQnN+T/81auxZhjmKmsuvsBON4aFSNTTS0/IKEfpiDk91FCL2KAKpX4hx2VUjelo+TDlkOZ06XF8pl4KIntWsswR0OVmvH0aRCOtizm9GEZ+bleXficiduqLbFgvzAoeWLoaURtG2hY8ufv7/S/6NBk2SrPGeo68o0idvTOGQ==
Authentication-Results: talpey.com; dkim=none (message not signed)
 header.d=none;talpey.com; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BYAPR12MB3094.namprd12.prod.outlook.com (2603:10b6:a03:db::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 16:40:49 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43%6]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 16:40:48 +0000
Date:   Fri, 9 Apr 2021 13:40:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tom Talpey <tom@talpey.com>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Linux-Net <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Message-ID: <20210409164046.GY7405@nvidia.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de>
 <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0033.namprd20.prod.outlook.com
 (2603:10b6:208:e8::46) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0033.namprd20.prod.outlook.com (2603:10b6:208:e8::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 16:40:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUuBa-003OOQ-3d; Fri, 09 Apr 2021 13:40:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 880a2ac7-7e2a-4846-1ed9-08d8fb763a77
X-MS-TrafficTypeDiagnostic: BYAPR12MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB30945C9F5AD4307F8DFF9CCEC2739@BYAPR12MB3094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mvvl+c/GHk5sTcz0XmSJ8e71www3v3K/c1kcII5PUnnmkjVPZQvIV4tHPo2CAeXArOd+qaaEMjVbSRp+f07yu5ae7YsLgNS52utDpPRjaKiswMi4GEKJt9BapErqca2tnGWWKOl72iPvSgPXXgcRFIKwa8oN0s3+cllp+6ycsuB1xNUE0srYVe0s65FLMsirxZ5qhBbc14uCYS+QGh2W/iv/L9tG66ADauLpRBPGSFbY6EgeWkJXnY6os/Vyhrk6XcHiG23K+we5ku1GZ/9fcF7w6zffxcIp/gyG3JoT2wZ+K6Vdo57nDkd8Z9x8iriMqTe/bX0CPYDz6kaBfsVtD17XG8HJM/FgzDMRqZX6DnLOOCRF8//qIG7jx785brG3BjMox9fsWjf2YXO8Z56np2aXbYH6VNS3nbVJ/svap0QY8M5llcgNLXdXAALxDgtNkwqq9F56f5RgGqNH784foYonlcq27/Cv+kF2tpQucCXbUujXXpxhiYrP6siKTncRgPZc5dV9V037kM51gMlI3HuahWjY3qJs5sjBgrHvMGHxXyjcUWqdJO5vejwq2HdG+0cwoZqSG3ljd84TS3qbQnbMj16yjrrpd1T2mTXr/z9yJ0D5dPoAua4f/EWM/JpawpH83gksG7RlBFSZh1IJTI0+3tetvrU98R3DNa4btmo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(86362001)(83380400001)(8676002)(66946007)(4326008)(7416002)(7406005)(6916009)(66556008)(66476007)(1076003)(38100700001)(9786002)(9746002)(4744005)(478600001)(186003)(426003)(54906003)(26005)(5660300002)(316002)(2616005)(36756003)(8936002)(33656002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uBU4O1NTO5ZUJTZIbHF8VCmm+OmenUl3LAC1u6odT9GeTD447WOloiGbx53w?=
 =?us-ascii?Q?+iNmOEOQn0UaOpXVGdjH1/SIG84WiCzKKB+5P0gzqe1oUjW7PuwPm4DnHiO7?=
 =?us-ascii?Q?LaH3yQUP2fWVog0A0b3LBfIHoV6rCcjr7FlXqoVxQC2r+FWEZJoWxqhk8n2S?=
 =?us-ascii?Q?BDTp0U3Ps5AgcW2a9gXuKbma+q+cN40JYHmK6qDJq2TJj33nvKlCgwbx3/KN?=
 =?us-ascii?Q?VTBduchvsbW9TGE6tpgpao56WQrg3HrOi8E2zC4DR3mtAoCP7Ic/qTzeV0+F?=
 =?us-ascii?Q?zxr6qxR2/SbWRl2dsrFGSwixtPr9MOl6U7wTuiwBxLCBgnEar3axWpcMcgMZ?=
 =?us-ascii?Q?BEDY1x/rXFBhKoyDH1BOHWrlZmNAkJYgWyJic7yRWcTgMJ4s3QTeNzh6DBfa?=
 =?us-ascii?Q?w2d8BqNzGmz7wLsQS0Cwo43lKCvkazVGzHTxxuibmA5AYwJrxtTaoYsJwlst?=
 =?us-ascii?Q?Sm+VHjIf20DLx454TraxPho/jpsIwoJECY/pyCP2dwTD5EbMfwQ7MX26lFKN?=
 =?us-ascii?Q?irnruPvzzyeRxlyr1RkbCuS3rmNJERo39JuW81AqJQNBnPf9lt5tD7A09ydc?=
 =?us-ascii?Q?P+FCSMJKxH/fBjn344eyhkhVb0ZJCjmaeoJSnYjxdaWy0K35ZqxE261WbirZ?=
 =?us-ascii?Q?sXMPGtvPqigSjeolH796oCLYhDDiS8EpXyj582xBYnWWPe0FXqGiIS5jpwCF?=
 =?us-ascii?Q?KkYipelLWiZXFli5Ai5E7H8WvBvVJnk9mMHBUFXtlNsMNdjy16WQnivoj6kL?=
 =?us-ascii?Q?P+dF8QZD93i6Cbpwt+LrlMyN+tmudyYwOkHg0+13wN9XWGpLi7gRQO5IAM/a?=
 =?us-ascii?Q?zwM9Cmy0xLfhoVt65r0vEEyz7Ppb6gSy7+f7zOEmZ0ko+XJNvgPB1oHRmAGu?=
 =?us-ascii?Q?XYYpYRQBPyFWxLqeFX0r3sVBdTRxZ7rfjEWEVpHpu/iveMqbMG/QdiChX38v?=
 =?us-ascii?Q?mjPZbv63xgb/ID60yhL4dX5vgUVPFmav0kwHX0Xda3le5gngCNv7qspkSuHh?=
 =?us-ascii?Q?UbLtsb4289XOe6uWe/6JkLSm/eprNUqzgFA/FOY2LP/WOEW5u8ZGfzfvG0gK?=
 =?us-ascii?Q?W7tl5EO24XnAFs7zsl1HnFM2Mnb21p9cd7d1JRtJtMQ4gYQoXB9r3cQ4w8NU?=
 =?us-ascii?Q?Qv1wUxum+xeaf59hqqFtjmhigBDzfSpRmsJK1GMmog30h1jWiEvjDtGFz8GE?=
 =?us-ascii?Q?BJ+XMGaOBNrnL4e6fOsvHWlskde3JORcBsS9xclw/IFqqdf2Aa7M/auEATF3?=
 =?us-ascii?Q?urk+haB3kNyAH3ECOVSPPkYw6Ynm48Pw+MVteS3pjyKUJ72nwol+1+g4eS/u?=
 =?us-ascii?Q?hnCgyxUey9t+IK87Le/8Udpc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880a2ac7-7e2a-4846-1ed9-08d8fb763a77
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 16:40:48.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: peztA7mPp4ryhfSOW4eEXfga8Kl2DysvOmOkJdwMpXmU5fXAf9CmbHHcRFConrGQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 10:26:21AM -0400, Tom Talpey wrote:

> My belief is that the biggest risk is from situations where completions
> are batched, and therefore polling is used to detect them without
> interrupts (which explicitly).

We don't do this in the kernel.

All kernel ULPs only read data after they observe the CQE. We do not
have "last data polling" and our interrupt model does not support some
hacky "interrupt means go and use the data" approach.

ULPs have to be designed this way to use the DMA API properly.
Fencing a DMA before it is completed by the HW will cause IOMMU
errors.

Userspace is a different story, but that will remain as-is with
optional relaxed ordering.

Jason
