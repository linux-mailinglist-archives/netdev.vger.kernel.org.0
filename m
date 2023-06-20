Return-Path: <netdev+bounces-12122-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE957363F6
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA6E81C20A65
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 07:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1160246B3;
	Tue, 20 Jun 2023 07:05:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C501119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:05:35 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2161F10F4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 00:05:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQVi3nPZKqAkzSaLaR12BfcekSsR3bYT1DXZpAR7js+eOhf42e6q3A5yj8V6x6boPMESb2y8LBj6DKr/tKytHIEn4ODmHkTJYp6IZLqY1UVsGNt47yfpp7/6iRRMH/Wb7QO/pTmVW+bDNrlk29nE0a4ShQngMSBBfc5C9gHfZXQ98ow2KC7lFKnXfaH8pC6MxdMj3FxVnr4iBpxiIf8sH/EvNW0SoWul/QnEWSqwfcXP8qWTPBFC7AA1xhXPoZSbyyrz9/tZFVgg1jAmAIFvjQpi0geC0GHP344UmO68wM3w9C70/Wu+La73QqOpEP04aLhSXQW9sEPvQ4I6cekz2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMqtSmhKjC95wrolQgze9RJtD/mU4QvVaKP6lLDBz8Y=;
 b=ktSQFuo1b6TSjLRQqsILaz/wJLcDlLCwSIW8PUN2dwEUcS4mrP9/LrHWJtGxhCP1AKdKV/k9i7VwqWogm+2zwZjvpweoP3AcJF8Aqn0FOt3c/TTKPgvN1yoBTySlkIWectqM2IxJRD/kKTldreCG2X/0P3Xw9d7K/zCYvWm4NXZ0LohR3jspEwj3SgJUfWXO3aBmfuYdjJ0o7/htHtRtvmtI0+9FDC+yu3tqoeeK2NB+lCJ0a2wZduUdbDch4DiolAY8lB5tfU8ncp0XRYPk2HWUeS0QgI+wSejHW6Q7ODUJopMW7sGKdShiujl4rCOYXdeqGl/f3yaJFS/gek8qFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMqtSmhKjC95wrolQgze9RJtD/mU4QvVaKP6lLDBz8Y=;
 b=eYnSu+uvjZmcQS1IiJpADL3ZXBIJcakbzUNjPbQovsfgnzqNEwzeA6I3jRgF6z0gXFEIRKpFShK6nVgQyMqnNz1mzocS78FU7ZRHbGzt+sVfn2w/ZJZ9Mn/7YSkK6iLUJ2pNTlgg/js80KD67znJSWK8Cvd/xz1jABgA0BXkOBI88hj4yewHblpyD4E1i23mirYk4neJheFojInjiC9ztrbmmcxYnxgqEBlIzcI8dt0Firt7+E//Cjop+dPDyyjMmvPkUFLczoBqYSPvc4eq5nHojTkn7aXDBeXNMulmxGGix1VAXBSwQjMMc+1wwpqNbeFZsggLvu5Nff3HbiEbvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB6901.namprd12.prod.outlook.com (2603:10b6:a03:47e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 07:05:30 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 07:05:29 +0000
Date: Tue, 20 Jun 2023 10:05:23 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com
Subject: Re: [RFC PATCH net-next 1/2] devlink: Hold a reference on parent
 device
Message-ID: <ZJFPs8AiP+X6zdjC@shredder>
References: <20230619125015.1541143-1-idosch@nvidia.com>
 <20230619125015.1541143-2-idosch@nvidia.com>
 <ZJFF3gh6LNCVXPzd@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJFF3gh6LNCVXPzd@nanopsycho>
X-ClientProxiedBy: VI1PR06CA0180.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: fc4c831a-eb20-4a24-5c88-08db715cbb2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HIYhOZN/Ugs48gYOGCuqaL0pQtuNy3EsjzMEC714ek7xcj7Sy1+eGSAJg2g1r0aIp/XL0OHf1ZrEOkBmUHHQWqvGqxjxU2uEcxpVpyOd52BuTvUBjGt64Hn3GXxLcLCZXj/F3GgppJwj+kIk/e4k6W11bSTA+flMh45dseLqbtIz/ocdB9XX2lTGbILT1XfNUwBwkiNhZ1ulmhLlkGhoSY8QUgccXmT5vyWQo+JhF0yw3ox0q0EmoQLsBXLk1y/tkRl+NCIpQoEhRfOmY/m/ICIzEH5URnC7FLR82zz22hHoOnl7qYFrrzI+SjeeC3ru6PTqaLYLMPZNhnawgdLMCGRQj0mMmn1P76FsSRMUnNYBCKW8gy4x5LEglmWr03WtJOLd5XihSx2u7t20GVpHRLH7Zac0C3yBukEHl5nc/u4gM/CY26dXr3xxMbw5AEVXttlRMg4dvSd/KollC5lTRb/UGEnNFhjX+7YobjNhvassWH01uEHo+5wo/qwVgYkImuySM1gME/618J2+wVxB1tADvimWAQJ34fEiQ2+N89rPWdqU4sK7TEpfH7jzn0XC1fGZtkvlTJNTcr+sZIW+jaPxFCqynLP3nXFghaNkwdw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199021)(8936002)(41300700001)(8676002)(33716001)(478600001)(45080400002)(38100700002)(83380400001)(6666004)(6512007)(26005)(9686003)(186003)(6506007)(107886003)(6486002)(86362001)(316002)(4326008)(66556008)(6916009)(66476007)(66946007)(2906002)(5660300002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wa3fqe4lBOCI7LP0RH5x5Lqhpa3SgfaParjX8PYIxp5Qwo74wSW27kNcTW5f?=
 =?us-ascii?Q?deoMN5piMBf/4SE5bxjk034Xxq2SRgdja+oOEJIv+i/l31e4ZXnovwoclr9G?=
 =?us-ascii?Q?fq8w0Yd65KGyEkt+FF1F7i7Wjauq8r3fMoBnMXDcspWUw8232YuL1FUSJGjH?=
 =?us-ascii?Q?Uo8y2Sew+sHN1oIk5kd/oiORX9gsfZx5NCjLOk9/1dreEnWeSsoRUKcnUW6T?=
 =?us-ascii?Q?03Qe7vAOh3xFK3co89iO59gUR9n273DRdTganjLVCw746xV0bo3P+fydNV3A?=
 =?us-ascii?Q?75piqjqgO+IAnDPqajZoCLrFLZgmkkXICNWwzgLDHYCKCrJLHQSwHxUYDUNF?=
 =?us-ascii?Q?wTnXtP+P2R1KaOYNrZIaqalO6arlVmVL/noIFRq8fEkuT73n8XEBXLOPg8pW?=
 =?us-ascii?Q?EyJw41dXTOZ/nEwtUqnfy4RdpZ5n0DVSXDFMXO65zu7FsK5T67UAa8ggBarC?=
 =?us-ascii?Q?xFa9cpJaRTN3O0RTQVhqlG8WHapGea3QWnmwVwb+hC+n6tRC5UScxrdeFQ5p?=
 =?us-ascii?Q?UdGyohkV6Gt9z46BTeLF4oYMJQ5SMMOBLqX75pcEqRUldLl+UqJvOnxJbZKI?=
 =?us-ascii?Q?FquY9CDG1e3BgjwlbJLTYDoDJDVKVvfcblNKXXwYWlCHZ7JYUJut9vuiipUG?=
 =?us-ascii?Q?Yo58p32B0DlRwLBXtKic7uxe+tYE8vfnDvoNSs0f/zEXbNS3KVKxtrOddQ/c?=
 =?us-ascii?Q?bMyMn1SvTQG//WtMnSQ/SMbyF2QzzzpJPEO0RqCwUpGeiQQuNU1r/fyr1Yel?=
 =?us-ascii?Q?HJxtkfWT6fi2gM5ZsILqKJb5E7fYJH/ZxauicDRFXXL8eRpGIA+mD7eGIez1?=
 =?us-ascii?Q?ixMmAljAWeLlohkB0L271kLHrDNM27fs1ko2EK9HHa08nDoudj0DAQCmc+8t?=
 =?us-ascii?Q?gK6+D7hVE32suAACZhKpURWLEr81ciDsaAWTT3D0E36uUZ/WOhwBo+Pg160V?=
 =?us-ascii?Q?IEH9WETMjFnQf68i3bX5DLgMd/SEcl5/LGRgd7uL/tJQNf6lc54F3Pm1tle0?=
 =?us-ascii?Q?dA4Cb4A88T7tMNL7LlW5UjxAaY6bxQtueGJVDncmOI3grGhgqMnMyXX+4poL?=
 =?us-ascii?Q?vzaNB4JPK3pxOclQ1C0ZceABEqJoYKJGLJ77K/+GRSBnjrnZLDQUGetoZLeC?=
 =?us-ascii?Q?czzcxXj2AgL/W7EJaRXkrrcFHpK3uzsGP/rn2TLM+sRXBDShgl3AEQburcJy?=
 =?us-ascii?Q?Be44ouG4spq+L2JAN3fPbDIpXxYCi7G4P0SxdeUitGFBvmwJOAlPBBJu7Qbr?=
 =?us-ascii?Q?6qfQJQaeMm70FvkdTfv8cHTI5EuaiGqRWw3uXRRh5JB4UQ6SCqQvGRSCm6kU?=
 =?us-ascii?Q?22BAjHMlDOnQzxDo2gUo/EULNZBKuxEQvmj80wuQuST/eKXdljLOqqEmPlBY?=
 =?us-ascii?Q?rknyd4F3+ntcqelYXeMgfsJLLk3ch9iaCKpghVmXS/w9yOJ8qxAUMsD9I8E9?=
 =?us-ascii?Q?TJUHRD68R278dI8EiZZuF09lmorkye53ulKIsNC17yl05+jqwYYYMJfKFp3q?=
 =?us-ascii?Q?iWMrWUWmyUHgRWR6fRQQjfCW/g7GpLHsDdqPXNpARCji8+XMFDDhXcl0AfRK?=
 =?us-ascii?Q?eoueqfMFreCsmlUzpnnMqiPSiL1izp5RRjbLq6Zk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4c831a-eb20-4a24-5c88-08db715cbb2c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 07:05:29.5825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uUU71WVCPXFh+KA4tf9XNc0pzVCH/7fkJJBbnEPO+MfbgXP0zJa8w02nEl1/tMEadou46iXACzzAe3GvIEfhLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6901
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 08:23:26AM +0200, Jiri Pirko wrote:
> Mon, Jun 19, 2023 at 02:50:14PM CEST, idosch@nvidia.com wrote:
> >Each devlink instance is associated with a parent device and a pointer
> >to this device is stored in the devlink structure, but devlink does not
> >hold a reference on this device.
> >
> >This is going to be a problem in the next patch where - among other
> >things - devlink will acquire the device lock during netns dismantle,
> >before the reload operation. Since netns dismantle is performed
> >asynchronously and since a reference is not held on the parent device,
> >it will be possible to hit a use-after-free.
> >
> >Prepare for the upcoming change by holding a reference on the parent
> >device.
> >
> >Unfortunately, with this patch and this reproducer [1], the following
> >crash can be observed [2]. The last reference is released from the
> >device asynchronously - after an RCU grace period - when the netdevsim
> >module is no longer present. This causes device_release() to invoke a
> >release callback that is no longer present: nsim_bus_dev_release().
> >
> >It's not clear to me if I'm doing something wrong in devlink (I don't
> >think so), if it's a bug in netdevsim or alternatively a bug in core
> >driver code that allows the bus module to go away before all the devices
> >that were connected to it are released.
> >
> >The problem can be solved by devlink holding a reference on the backing
> >module (i.e., dev->driver->owner) or by each netdevsim device holding a
> >reference on the netdevsim module. However, this will prevent the
> >removal of the module when devices are present, something that is
> >possible today.
> >
> >[1]
> >#!/bin/bash
> >
> >for i in $(seq 1 1000); do
> >        echo "$i"
> >        insmod drivers/net/netdevsim/netdevsim.ko
> >        echo "10 0" > /sys/bus/netdevsim/new_device
> >        rmmod netdevsim
> >done
> >
> >[2]
> >BUG: unable to handle page fault for address: ffffffffc0490910
> >#PF: supervisor instruction fetch in kernel mode
> >#PF: error_code(0x0010) - not-present page
> >PGD 12e040067 P4D 12e040067 PUD 12e042067 PMD 100a38067 PTE 0
> >Oops: 0010 [#1] PREEMPT SMP
> >CPU: 0 PID: 138 Comm: kworker/0:2 Not tainted 6.4.0-rc5-custom-g42e05937ca59 #299
> >Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
> >Workqueue: events devlink_release
> >RIP: 0010:0xffffffffc0490910
> >Code: Unable to access opcode bytes at 0xffffffffc04908e6.
> >RSP: 0018:ffffb487802f3e40 EFLAGS: 00010282
> >RAX: ffffffffc0490910 RBX: ffff92e6c0057800 RCX: 0001020304050608
> >RDX: 0000000000000001 RSI: ffffffff92b7d763 RDI: ffff92e6c0057800
> >RBP: ffff92e6c1ef0a00 R08: ffff92e6c0055158 R09: ffff92e6c2be9134
> >R10: 0000000000000018 R11: fefefefefefefeff R12: ffffffff934c3e80
> >R13: ffff92e6c2a1a740 R14: 0000000000000000 R15: ffff92e7f7c30b05
> >FS:  0000000000000000(0000) GS:ffff92e7f7c00000(0000) knlGS:0000000000000000
> >CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >CR2: ffffffffc04908e6 CR3: 0000000101f1a004 CR4: 0000000000170ef0
> >Call Trace:
> > <TASK>
> > ? __die+0x23/0x70
> > ? page_fault_oops+0x181/0x470
> > ? exc_page_fault+0xa6/0x140
> > ? asm_exc_page_fault+0x26/0x30
> > ? device_release+0x23/0x90
> > ? device_release+0x34/0x90
> > ? kobject_put+0x7d/0x1b0
> > ? devlink_release+0x16/0x30
> > ? process_one_work+0x1e0/0x3d0
> > ? worker_thread+0x4e/0x3b0
> > ? rescuer_thread+0x3a0/0x3a0
> > ? kthread+0xe5/0x120
> > ? kthread_complete_and_exit+0x20/0x20
> > ? ret_from_fork+0x1f/0x30
> > </TASK>
> >Modules linked in: [last unloaded: netdevsim]
> >
> >Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thanks, but I was hoping to get feedback on how to solve the problem
mentioned in the commit message :p

