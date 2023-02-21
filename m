Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E74E69D7E7
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbjBUBLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjBUBLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:11:54 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D511F919;
        Mon, 20 Feb 2023 17:11:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9uJDyl+ogXFR9GBTxudHDxc999Kc6N9vtXq6QepaVn02YPdr5ehyNqzezC5hwRNn7wwYb/xxcnq8HdySW33NiId2PBLi/mBuTqfAE6LRMnBz07cmV31mmHs1mUm7NKgkV9JPZqkbyOKrc7mfXbB2FMGFGZp3xZMLJ38QvxVtR3ch/yudZsdWuxTSznvaI/qLJzz0RH0/pn1MTYhR42tQ7eWLW0ZmUvFJPBi62Gwenu/xZ08jY7bcnVCqm07d5s3m/BXmZm4tTJ+LNDTqgGMrDsK9eSWlAiIiGpw6HpyBB8rTzo3qWZn1YyEwKyx/t1+DpjWAVHKA/CLb+Zavv7Kwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CD3a9lvUwakJzUezXERTnEf/c39TZiDROHnOC/xZpM=;
 b=EpSHSkS2c6N/KAawhVqhrYqudEbibLHnVRX6fWblpnIblXeFGdYgLSmZa1fFetcgH0YLxC/utMSHqtRC/O2gMF3x3PqfX0YSJmC6EeJGVCgbc3AwgAJVrG+QjYQKY2PLqT0Zq5Ay42mHAsS+XYh6+6tjLW/HzarWoUvoavoYaBtfN9CtsEgr/Hc2FEXdmoqp0+ieYHM5IR5yY37s3OU2vq5KCr9xz59DilQczwxdZyPNNVw2dwmPnFR9FHFELhVzbubJK5J02wGDVHpSxxSbOMlG1j4igv0UeOyigUAPhGQujNjuPGU9oAZA3Sd2ZxOIRjPX8ivbCBHnSTr1pg1o2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CD3a9lvUwakJzUezXERTnEf/c39TZiDROHnOC/xZpM=;
 b=CeznN/b6YGUK7glwtrQEShbKbZzJVqb6Ul7S5iSG3r6GNYUFqpdHByw/KziXxHdtLzfo+LBAzP6LCwvX5SrMkqinaSg+HkhaK5ThHwLgQ+LA2vo630R67liBgjFD4SA4PN/pQ/aYH/xecrxh80wscQdMZRMYxRA62kYRa9tSXj6/eDOdy4aE9EvmGFyhtFbgS11/CvuY8gtu17X6/Q1RPIyJdWt1sEVZ0qv3/BKq+rW7zGaAhdVLeUmj8mEdXjxcNMAqhrDXSlDD3BGVFAIwENbQZ1PF+4a78o138ZybnmffhYnnemvH9yqAE6tbAfA5h7SIO3QEIa6ZeTCyNCecpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Tue, 21 Feb
 2023 01:11:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%5]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 01:11:50 +0000
Date:   Mon, 20 Feb 2023 21:11:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v3 vfio 0/7] pds vfio driver
Message-ID: <Y/QaVdnL+URV7oAk@nvidia.com>
References: <20230219083908.40013-1-brett.creeley@amd.com>
 <Y/MTQZ53nVYMw9jI@infradead.org>
 <4220d8d7-1140-9570-3d6c-ba70c4048d98@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4220d8d7-1140-9570-3d6c-ba70c4048d98@amd.com>
X-ClientProxiedBy: MN2PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:208:d4::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 03a21f95-49d6-47e4-586e-08db13a89c56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJtieycb2GC9V7uZ7ywj14Ka0YjCOt9bAGHPPc56Bo0zbjQwICSbCiCcf69Xuk7ndcoYzl6OVy+XadpsC48D5p7KVMGcdUr7DEfKPC7QhHg++N6p3QG3ZqgJFgdZcyfbQw50JzOnHbJazpt3Ais6yaFO8JailRvYWw82LChkB2w1ElU41TORcsbVZa1F0W+PjN/nKfIOr7uAQtLPzEX1wKdZf9ICRON35NhiZMKQ48z04X1ZISHWxAOsuAZ7TLirJCCCXJFtx2M/KQO7e/ZmF7xq3TpICQJxH30m52UVJdBJPv1V+2TjPxeoH9AgzqSeG2J629s+sKHEyfleIYDnuPw7BAb2j2fJWZWJFLSnkzb5cgM9u7PDx+8M8aqJnqNT8f8GKaPI949kBW1sKIYK5/2FfHwVxUeKQ22Y+mLnIVzOFkNO+pIXPsEPwMLwXfgE0aEYiz5z1xi112baau3WmEtRRzIli8biIpw3ZQorde5V1srSBZwwq/kFtg8cFxDLBvT3nbHNkrpvEfk59od9j+MBIwtcU7S3XtTQRjHegIX0yMuGtuYPcWkeDk645PGbx+lCitM1Pg7l2nYTuGqWKCkdaT8RjmdaWaPB0QtsqbCivUbh5g6aYB/zBPraR8/IrTeeaYE7TQDCQVkEqhYHIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199018)(36756003)(86362001)(38100700002)(7416002)(2906002)(316002)(41300700001)(186003)(66946007)(66556008)(4326008)(8936002)(8676002)(54906003)(66476007)(5660300002)(83380400001)(6916009)(478600001)(6506007)(6486002)(26005)(6512007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7UVZPuUifPGb1ezvevbrwI5JeohgovVsrNrV111o1ZIwkyg/RX3YdAeREVK2?=
 =?us-ascii?Q?FpG0F6rOReBPNSebFHLqMzZ0qeAFa7da3U2SGsApWhIVX6LWl5qGiuVHxJc7?=
 =?us-ascii?Q?Za0mrMuo69mdrphiEdmC8hgSc0ygqcibklFPLMhVXMzEo/fjhFAnQPk164zY?=
 =?us-ascii?Q?4yFagYWup00jIZ90hTjfmlmRi3M6p6dnUloRTvyQMjUTAhrPfuN1Re1PGqd6?=
 =?us-ascii?Q?OsRUE9OcTDLb4zsJAn//9x02JijBqsxrdMCvZ0w5vyhSh/0uNyt6OauaArWW?=
 =?us-ascii?Q?bglnoR4KKKJCn12eLGdSLfNBXoHgTGPsF4j/f4xd3w9XYrgH8yT0iE1pn7Uz?=
 =?us-ascii?Q?JSj3GrPe9RCC/kIr/F/xEKCCvenV5qP/NTT1xVI52ul/3bPVCpdSEOELopDK?=
 =?us-ascii?Q?zrS+0LMNmmFsB07JQs8+4Sz7UD9mAeS7nBicfFKpY8cHvc66Ys7hWdC0zeU2?=
 =?us-ascii?Q?3T/2Xxh+SUYwSyXiX+Eej4nH2NA5K229seY0FHeJO0et8xO9CPjx9Akj8Jep?=
 =?us-ascii?Q?psac9OoMUldaJIbdgN2C1D4UV7Izy9klE4fxv0vYOrHelgYb0Byvw7ScHGuA?=
 =?us-ascii?Q?bAjJoXAe+3fP/fQkTciGN5zUw1UIEijF2NDyAxNsmGt4c6ZCGM4NUlV7KrYy?=
 =?us-ascii?Q?2S7xEXNLfWv4SJfvuoM8qlXEP6FXFteijU/srcOOcvMAmsi6O8aQaDkNJMOi?=
 =?us-ascii?Q?WTPuyaklt9xfc388DCytry/u2AZEwf7f3opLITOKxjax0AzIAHib0SWq9bcx?=
 =?us-ascii?Q?kAUTVkzC0H6U5+y3inIMG0FeBKjR5/fTVEuz933wmKMuZhUU9MlStCtsb6x2?=
 =?us-ascii?Q?J+BJ5TO46DoX4DJeVEbE3Zqm+R6P1wpPHKNx/+0/E/gXINvjKgE/SZiX/9jl?=
 =?us-ascii?Q?PB9DLAzn0pFTiLElHs+Sz0gFjIPs7+8MjyZta+D70D9v5W5IA9rRm4CCTnAp?=
 =?us-ascii?Q?T2rLCvMlyQnPxqMbamudNdw1Vwm/lnEUKw8DOKfZYgv58TJhTNB7mR4igfnt?=
 =?us-ascii?Q?LOgcrsnBpVDs7Xz77S/V/MRq5yPno8dfsZZEZIaosvRrtVaRNPyz67+bn3vF?=
 =?us-ascii?Q?BJ52O9SAxuyu2UTz6VIzc75c7kupmnHXtQ80rR38Ixi87WGyKIAfnlblr1Ny?=
 =?us-ascii?Q?Y/InQgfoQFrYUwTgFAKn1+GK8zVDiI2789aFJVQOlzcNe1Ciucmw/A7De2Jc?=
 =?us-ascii?Q?uTxQs1J+kFuPxC4v+uqegGn0sZUU+qzwktakC00pOmhX7XXOuPIINrIjMwrp?=
 =?us-ascii?Q?Tm01FALax/yp+qh7GW5KfGaHtCnsjcrPktcnyLTY0/6dDcvTDA9310zxhh76?=
 =?us-ascii?Q?8nEUET7liNoiVL84QhUfDivligAh49RYP6a8hRmUmpNidX0azVOb2xXXWT+/?=
 =?us-ascii?Q?hP/cNfo+vHuTIhg0UUnHk1HiCJPKQ6CBYxR6HEyph6MRBRhI1qOXlf8e2U3C?=
 =?us-ascii?Q?MtPFVp/xrLk1lZRc9pjGc2HKxWedpxUknjAM4fRrCy9Op3v68HjHmsVrU7tD?=
 =?us-ascii?Q?c7a2xdKYHd4ziFGbwItcCM9aoqDD4cupTrRlKs1wsEqIqZ97lR+WFlK6+6Ha?=
 =?us-ascii?Q?RHyUiz8YwzzN7QNC0DcsHMisD1EswacwDfm/dL7H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a21f95-49d6-47e4-586e-08db13a89c56
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 01:11:50.2956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWZtMjPwsWtSUAOgd9p1zs6msMYmpFS1wBndb/kXw8u92Evo2VG3h2URlyL6zxdC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 04:45:51PM -0800, Brett Creeley wrote:
> > On Sun, Feb 19, 2023 at 12:39:01AM -0800, Brett Creeley wrote:
> > > This is a draft patchset for a new vendor specific VFIO driver
> > > (pds_vfio) for use with the AMD/Pensando Distributed Services Card
> > > (DSC). This driver is device type agnostic and live migration is
> > > supported as long as the underlying SR-IOV VF supports live migration
> > > on the DSC. This driver is a client of the newly introduced pds_core
> > > driver, which the latest version can be referenced at:
> > 
> > Just as a broken clock:  non-standard nvme live migration is not
> > acceptable.  Please work with the NVMe technical workning group to
> > get this feature standardized.  Note that despite various interested
> > parties on linux lists I've seen exactly zero activity from the
> > (not so) smart nic vendors active there.
> 
> 
> You're right, we intend to work with the respective groups, and we removed
> any mention of NVMe from the series. However, this solution applies to our
> other PCI devices.

The first posting had a PCI ID that was literally only for NVMe and
now suddenly this very same driver supports "other devices" with nary
a mention of what those devices are? It strains credibility.

List the exact IDs of these other devices in your PCI ID table and
don't try to get away with a PCI_ANY_ID that just happens to match the
NVMe device ID too.

Keeping in mind that PCI IDs of the VF are not supposed to differ from
the PF so this looks like a spec violation to me too :\

You have to remove the aux bus stuff also if you want this taken
seriously. Either aux for all or aux for none, I don't want drivers
making up their own stuff here. Especially since this implementation
is wrongly locked and racy.

Jason
