Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962CD4B7236
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240355AbiBOPk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:40:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240302AbiBOPkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:40:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09EBB0E9E;
        Tue, 15 Feb 2022 07:33:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJpArVOmm+L3YSOV0zwG6Bcds5VZrC+rH5jWQCMYt21727NVWcfuZDgnzR0++9UkA6xpC/aD9V/vrnQ5BB7DRnofI7H1pZlfGHmJc9BnOiifaJzLjd1hyxrLonWlXDvib/+GXtwmMHKQ7H0xCk6eNo4l5ainTBt/aCTXKQqRadGtbW0CGTJ4h/K00q/BiJp+PlaQ4qdeBfNhNzNClalZBUmobPei8gmfSy1StMkBopfWbhQygF/2e9wRZEk/nx2Jk8bMTrfTwT1K1fc6YO52mTRB1a3FQ7PtYPBKo0UywAAuX0qVhslXJm9G36vl5zZrIee10t9pwbXI7uxtUrHh9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0R8+iEud3jyAFlaHVQEo2WFtqTy4DIlS3LYEt3NVTh0=;
 b=JGKScLBYr4JtmqdTiMLkU93mZvILkSL6jKAb6Kg5kwbtmkZF5dwglv/ibpzRWsNowun4SNzW09I6JyGH60cX6N0RLIuCw/fHAoRaa/H9Ux7Y5TIPY2H0mWs8t+dafumxkiFHl/e3umIswtbQ14KyRNPqoAEExc4PpC6+/94do9U8cUloyk6r/yYEQm2TPYT6j+Dn3yak8CWkYLZwRl2VIZuwcNC6s88n12/S/ZDuVfJPRUJd/t5Od/+FxjF1ZiAIHcCRFMSuwN4RtIq5emzTFcvYfmVbG2+uJ3ILVnTR1gic5T4ubxg5kI5B5jIAgNuWgrCcw4EQC+PdoWrXuIXANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0R8+iEud3jyAFlaHVQEo2WFtqTy4DIlS3LYEt3NVTh0=;
 b=hz8G6JY4c2JLzq8bvmF39ivXq1z2R9BExd/SxSnEGwIGHw1/IAP2n5nEhjUYuIQQeZXjRpMa6JFV7gA09oA0G0GAGOJ+bj44DZ81e/Pla+d/KD5wgKXCrKfrT/Iq0MvLKi2HE95zXLLeTlX861eJ4tVub6A7sbd6SKF/0WVdVuPbHtjfXC2G2s7PePoguxQRp1K+9hU3PDkLluCkC80TPt/hqqTkr9Sio6Aetm5E/DZ3hL6C7pharsLTwLJC9axRrbD+4cXtOS6Yfc/lahLCVtiUwM+Hc4UPhHF1rMDU8VkomSavoOAIWTjSenZWS//VoJXcycJlzOZIb0EhAIjH7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BN8PR12MB3538.namprd12.prod.outlook.com (2603:10b6:408:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 15 Feb
 2022 15:33:44 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 15:33:44 +0000
Date:   Tue, 15 Feb 2022 11:33:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220215153343.GA1046125@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <BN9PR11MB5276B8754BA82E94CF288F8C8C349@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276B8754BA82E94CF288F8C8C349@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:208:d4::31) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02824be1-919c-4bf7-6864-08d9f0988d11
X-MS-TrafficTypeDiagnostic: BN8PR12MB3538:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB353860F747B1E1C01C3DF097C2349@BN8PR12MB3538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1kQ5gIA57bFVgMk6yu/MuSEDoD2H8PWutRy3R47O4gUmcGMZ/2gAzhDLqqOD8bRbPN3WKuRnCaUm87w7IczFTlqQBK+3PjNMLz3XhGMp15f/O3lM569G3b21zuaMTNKw7t8uO5dnjVbFuUjO2f3s3+xnWXasWzJuBTfM5IifBwN6jVyeXr6CX/cEICpzAq8erwVt1JTWaAvhvqrXxY8lCGuTH77PHQJRAECzwdhGB2x30+vxQkAuyoM/YH8t/2zisfv8mZMjAms5KXo2Wr/18eKXUDOM5L2IULkSpGSIPkZbsEPbIGw7eiVITNnTRe2oIHziy1ISgkRqKn3J3VrNYPez8qCGKshnnp6IPyR7KU9EZNuuhaFllB6vnm5bTf6sn1/nH0NoiED7JEDohvZHmNoi+e7SEq3mt85IKWXXzacPhDlOz/F7g77/S0qnhFnWkx0G9hL7e7jEkfwslFsXml0t7tIKuy6LEa4hO/hFbYSSsEyzv+X4oUdOF1QktJAsk3l3YV+A7Bba0toiQ4LQAEdBvRlkS1XmIctwG0iqIZ7xuXdnYzgw+ZSKj/yWjRAIqdecU08huNAVQkChK+6+imE30hH7qSTd8hOD2u9hedfvHsa0O7ii3T2niXGsH7dRpq7NVRCEu7goaizgq8AVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(5660300002)(4326008)(36756003)(66946007)(66556008)(66476007)(38100700002)(8676002)(316002)(508600001)(6506007)(33656002)(6486002)(6512007)(86362001)(6916009)(54906003)(2616005)(186003)(26005)(1076003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UjXC+sOFO1QHraXSSg1jemBop9mUCq7OrfjUvUPzuu4+cx+4PwfsczyMLGPm?=
 =?us-ascii?Q?oPrm0CFffcWoMqtbF18yLVJr0BZAQLOFWTqFeYlHGt7G+N2WAa9IMcXgasse?=
 =?us-ascii?Q?n89PldjpoKtmVQVfM2ALMuQhUlvvCNSm+duWGNYkF8pSdMRHsLQ+IhcgA8m7?=
 =?us-ascii?Q?8XkoOfur8h2+tIVB413UNbY1a+HWiPBDwCDlaqFB+rti5wQJu9IzfTSCVCFF?=
 =?us-ascii?Q?A+yiChNMM+wp2WvLTcNZT9uVhXp5YecOnnNak1oMDvlzu1/d6OlEIq5TDnYd?=
 =?us-ascii?Q?WscgXJhXAdekyMQqdWrOFfU+4pksXJ4wBWQmHwbC+IGEocmtd0X2uRL8N95Y?=
 =?us-ascii?Q?8RgJM6Yslhsy8MR+JhVx4hoJMtZI7s7txVV9qmBjibaLNRp556eT3uISHb3g?=
 =?us-ascii?Q?I+8fxzEeB65smK6ScNoaNtfOJCNrBk140dZku3bdDO9gmDE8VSetZq7y9IK6?=
 =?us-ascii?Q?hguPCvUtm/yXOJ0VOMk/WCeesuPvCaORlKvotDkvu9VQTCJiNMwWwW0+DGn7?=
 =?us-ascii?Q?iaN+E+O6jQj0OESutJ7JI69uEI523c0zBH2hB+6ybjOaxFNYqCjz24TGmxzp?=
 =?us-ascii?Q?grtpavl03zFok9kb4TaY6gRnmGXTh2Gzo6FWtSC7SyyO0DKocXTY8SWNKTsW?=
 =?us-ascii?Q?apBvAvmINw6XTGqCoTNKuC12CTfu9FobpvFOYgFIvcrTflHuP4NQr/dHN653?=
 =?us-ascii?Q?j20gCrWqSpLHWAOKLIRldrtxog8F6ZW6bp3HF8VhN31MB3WdsoxLzzt4a5/4?=
 =?us-ascii?Q?yrvLaDJ7nZsSCIjbr7CnFs1G2cy7WxhZZWaulslCPLVnNgwwtR84dpqB/CG9?=
 =?us-ascii?Q?Q35PhX9W2MHddY4D5/74xPpZsvFOs9suzujkrAetDvmvTuh6VAYJ77UKa3cu?=
 =?us-ascii?Q?pBVfXadepAXGbhsVXNlIMuQtqP5OIk5BSlw4X68TfDuhCLM5Pz736PjjqwTd?=
 =?us-ascii?Q?DrGL41sukZBOVDEynztO0v6ikIgzMAxwShxtsAei40ZRHGzGOnivvyH0Jh+K?=
 =?us-ascii?Q?Vqs0HF/TbvfClAta2m3fgbZhisLtzpAaoz105Gauzc0qvAiUs3maqNf+ooRC?=
 =?us-ascii?Q?8Re8a+xKpcZ4cz3XG2VKmyxymrJ3RNuKm8Hvdl8yR/5XRxPEN0/ml2BWFLbH?=
 =?us-ascii?Q?u7ta05W/Fyek6Wko+UBulQARuMQyW7JSiJxCSs74oGYUzasliPvt0FQGuxuj?=
 =?us-ascii?Q?JRPXgQkEJBhVk3YL90n6k3ZuJUAGl7RTSnpjVjAaVC8hrMhjMDzvAsuaTgU2?=
 =?us-ascii?Q?toaUCFnOq/VsDKFToirGt8GgaUpbYprwB0Q+pNSJy5bcSEvChnu3vcCHzgjF?=
 =?us-ascii?Q?+FoHanN5eu0Un/RwHln2iJthJ1bgS1WCOc4BXvLgDORMCju0lTBpfc6+B/mC?=
 =?us-ascii?Q?bcnlWLNEkGQCwbPp6aYpSJkji+P3aRD6zLGQ5Wejm+g6VqrEpAdyCw5q9vvi?=
 =?us-ascii?Q?u4VZMGs4gKY+cDDmFtDnkpWQkbD98jCo1rVNKfYlDWKjVSv/JAz1xB7JHN0/?=
 =?us-ascii?Q?f9aedjQ4kAie8F0yY98kYbzYckIJbuz7+NYcS4GakO490PfTN/00hX1EujDi?=
 =?us-ascii?Q?44UW2qtJMJdJzUb/B/g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02824be1-919c-4bf7-6864-08d9f0988d11
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 15:33:44.4402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: arU6cePeO1NVrPJK3B8tA8YauHC6lUzzQwjABafTo0djaWds11+oska7S7MuZ85e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3538
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 08:04:27AM +0000, Tian, Kevin wrote:
> > From: Yishai Hadas <yishaih@nvidia.com>
> > Sent: Tuesday, February 8, 2022 1:22 AM
> > 
> > +static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
> > +					       u32 flags, void __user *arg,
> > +					       size_t argsz)
> > +{
> > +	struct vfio_device_feature_migration mig = {
> > +		.flags = VFIO_MIGRATION_STOP_COPY,
> > +	};
> > +	int ret;
> > +
> > +	if (!device->ops->migration_set_state)
> > +		return -ENOTTY;
> 
> Miss a check on migration_get_state, as done in last function.

Yep

> > + * @migration_set_state: Optional callback to change the migration state for
> > + *         devices that support migration. The returned FD is used for data
> > + *         transfer according to the FSM definition. The driver is responsible
> > + *         to ensure that FD is isolated whenever the migration FSM leaves a
> > + *         data transfer state or before close_device() returns.
> 
> didn't understand the meaning of 'isolated' here.

It is not a good word. Lets say 'that FD reaches end of stream or
error whenever'
 
> > +#define VFIO_DEVICE_STATE_V1_STOP      (0)
> > +#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
> > +#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
> > +#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
> > +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_V1_RUNNING
> > | \
> > +				     VFIO_DEVICE_STATE_V1_SAVING |  \
> > +				     VFIO_DEVICE_STATE_V1_RESUMING)
> 
> Does it make sense to also add 'V1' to MASK and also following macros
> given their names are general?

No, the point of this exercise is to avoid trouble for qemu - the
fewest changes we can get away with the better.

Once qemu is updated we'll delete this old stuff from the kernel.

> > +/*
> > + * Indicates the device can support the migration API. See enum
> 
> call it V2? Not necessary to add V2 in code but worthy of a clarification
> in comment.

We've only called it 'v2' for discussions.

If you think it is unclear lets say 'support the migration API through
VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE'

> 
> > + * vfio_device_mig_state for details. If present flags must be non-zero and
> > + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is supported.
> > + *
> > + * VFIO_MIGRATION_STOP_COPY means that RUNNING, STOP, STOP_COPY
> > and
> > + * RESUMING are supported.
> > + */
> 
> Not aligned with other places where 5 states are mentioned. Better add
> ERROR here.

ERROR is not a state that is 'supported'. It could be clarified that
ERROR and RUNNING are always supported.

> 
> > + *
> > + * RUNNING -> STOP
> > + * STOP_COPY -> STOP
> > + *   While in STOP the device must stop the operation of the device. The
> > + *   device must not generate interrupts, DMA, or advance its internal
> > + *   state. When stopped the device and kernel migration driver must accept
> > + *   and respond to interaction to support external subsystems in the STOP
> > + *   state, for example PCI MSI-X and PCI config pace. Failure by the user to
> > + *   restrict device access while in STOP must not result in error conditions
> > + *   outside the user context (ex. host system faults).
> 
> Right above the STOP state is defined as:
> 
>        *  STOP - The device does not change the internal or external state
> 
> 'external state' I assume means P2P activities. For consistency it is clearer
> to also say something about external state in above paragraph.

No, STOP is defined to halt all DMA. I tidied it a bit like this:

 *   While in STOP the device must stop the operation of the device. The device
 *   must not generate interrupts, DMA, or any other change to external state.
 *   It must not change its internal state.


> > + *
> > + *   The STOP_COPY arc will terminate a data transfer session.
>
> remove 'will'

will is correct grammar. It could be 'arc terminates'

> > + *
> > + * STOP -> STOP_COPY
> > + *   This arc begin the process of saving the device state and will return a
> > + *   new data_fd.
> > + *
> > + *   While in the STOP_COPY state the device has the same behavior as STOP
> > + *   with the addition that the data transfers session continues to stream the
> > + *   migration state. End of stream on the FD indicates the entire device
> > + *   state has been transferred.
> > + *
> > + *   The user should take steps to restrict access to vfio device regions while
> > + *   the device is in STOP_COPY or risk corruption of the device migration
> > data
> > + *   stream.
> 
> Restricting access has been explained in the to-STOP arcs and it is stated 
> that while in STOP_COPY the device has the same behavior as STOP. So 
> I think the last paragraph is possibly not required.

It is not the same, the language in STOP is saying that the device
must tolerate external touches without breaking the kernel

This language is saying if external touches happen then the device is
free to corrupt the migration stream.

In both cases we expect good userspace to not have device
touches, the guidance here is for driver authors about what kind of
steps they need to take to protect against hostile userspace.

> > + * STOP -> RESUMING
> > + *   Entering the RESUMING state starts a process of restoring the device
> > + *   state and will return a new data_fd. The data stream fed into the
> > data_fd
> > + *   should be taken from the data transfer output of the saving group states
> 
> No definition of 'group state' (maybe introduced in a later patch?)

Yes, it was added in the P2P patch

We can avoid talking about saving group here entirely, it really just
means a single FD.

 *    The data stream fed into the data_fd should
 *   be taken from the data transfer output of a single FD during saving on a
 *   from a compatible device.

Thanks,
Jason
