Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D760E42FCBD
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 22:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242918AbhJOUFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 16:05:38 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:15392
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233148AbhJOUFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 16:05:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hz2Ufqf6cZwliHmdtIPPpt9nugX4P6AI+pKrG2BaPnAygYYtH6xfV3ZDS3gGiBK2ztSF7Dgywm+nOcGdZJHtBToZwRR3fgtbbc6wUhtkNXYJzNK/53u7ynDfWllpdZcAYYreNvZugBGjflWtMsKC7hkZZTj2g35NQhhV3j0wUUDsk5zf50kyVbGRYVDjNNB4uRjeKKXfkP2SnTIxpzgA5bSI237PgJbKYifLGwCZ7BSgAtkjPq/A4GdShzxnxa4CDjpFuJWPH5BaRKR/9/aUqAqumFxpGh7pj59YbUWz7S9jGQyZ+OMLy4WnCC9olCeyr1QBysG2OOzvLTAnrxqXtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIQ25e74siL/FPgCKdMThXxz7qFO13T2osa4Sq6pDM8=;
 b=SWENxMxSO8V0vGqFMlxp9ABYviRwJ7BgH1g9tavXm5c4kMZ8Gv9nq51cmAPfJ2RgUfdgDpcBey0BCcfW1LPWXmZ5qaeFNDqOuvQOw3+X8litgBz5Kz6jAq8k/TEDai8nLYIzJztRdLx+xJ1fOF6llBpnClr0H8A6376gmHQksksdB8iTIVj3uxWNXKQb6WknVqv8leryoo9JdnAT8CVs58OewSFQ0MDJtpgke4PO3Le1lW5vRCXi533RE0wVliluDo2P5iKsak/f079RdCxXm44ReIXrQcUGVqQ/lOCe4H2/S2TNA8A8f19BtfuMib2NRYW4D+mCPvmpNz+4nuW9Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIQ25e74siL/FPgCKdMThXxz7qFO13T2osa4Sq6pDM8=;
 b=WYWG+sOrFF4yIz7I+3TfZXyblWHrPyOxI2s9E/l06E+k/Pw0B5yUU3mVMdKE2ChMRIvETBLZ+04WIPFUok0QzB9K428R7XBrMfT/wq4bX0ESX5ggymKtQaEmqdCjM448yTl2yH/cggiNK/8lyIpbpu9g3TsF2KYxI7FjO0CRNbDWXrJ9osK8ZKOcrL5YhAPy2jEvqDt4az73k31hrZHrTjlzbPwlsQ11nhOzRj6OE5rivaJR2qJV5MlYDZEZcYdCGK87p23gwRdH4BQmFPhTouE9K1NZ6p4co0E5d2db0AsPG/ijKY55/li0r92gJ+G2F/6vD3UD9pTq4L6kg0ZT6A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5255.namprd12.prod.outlook.com (2603:10b6:208:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 20:03:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 20:03:29 +0000
Date:   Fri, 15 Oct 2021 17:03:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 12/13] vfio/pci: Add infrastructure to let
 vfio_pci_core drivers trap device RESET
Message-ID: <20211015200328.GG2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-13-yishaih@nvidia.com>
 <20211015135237.759fe688.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015135237.759fe688.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0012.namprd19.prod.outlook.com
 (2603:10b6:208:178::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR19CA0012.namprd19.prod.outlook.com (2603:10b6:208:178::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 20:03:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbTQO-00FTN0-AS; Fri, 15 Oct 2021 17:03:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7036aead-3356-46a2-3550-08d99016db48
X-MS-TrafficTypeDiagnostic: BL1PR12MB5255:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52553B62110A35C3D7A282F9C2B99@BL1PR12MB5255.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awr/DiZUnehD3Kh26bgtNHpqoTKuDLBWyQ88rBRIuERwRzuUDdNSSTG9KmYLfOyJPfN7JZz8j73v3W7YbCji/KV1K+zIKvzqWnvpKVE1yJB2N/Z5yy1l1xbJZ+aCDrT9qYH0XkFjatTT6y5FXwiDlY8ReYwGCQt28mfx0uCqt9H14Ia8TKehlW/Zdv1adWvhqC9POD362XO+f0r9Ry943YYPHSxAenMEJDMVzIStDxEQtZQi/agm94UYDX6ReGl8bbxvpGoQHHDxAkbVDAhoxDQBjjno8NVr5hY2z3bZNM2QvB9QN0vv56MDSAj1HOTZUPMSkKery+ivlkfnNMHKcTqzfkYwgeX6knv5A/TnFMcTNkdaERdPk2ngtIrl1NQtgXcLVvENcfPAnzFlUdTX1b1ocDlnaBEVwkiqvuFfC5QL9bJQPUd8zwMvk8+s0RaZdPztNZlrfPb0uAth7bEJ0kj6udXgqrTloAz2r0m+FxGIPyCWMj5IfQzujl654bh1yXG8npLDKed5clTkTzBWqOYVMHfEcnHWk0Vv9L5cN25XOZvfMnABW5ljuWnxuteLEB6rcUf4YIXoIz2qbEaOMtbOVS8thV+9ysVv9n/6V86Kxp1qC+URHHgexVnl1BIPRW4AnTphFxTJRPcvhObifQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(8676002)(86362001)(186003)(26005)(2616005)(33656002)(508600001)(2906002)(83380400001)(426003)(1076003)(38100700002)(316002)(66946007)(8936002)(5660300002)(9746002)(6916009)(107886003)(36756003)(66476007)(9786002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jwH5DOgEjoNKswPQO6LWipE9wXD3EpS5TpsM8200fhWGI49y7WB+ppkl9nDT?=
 =?us-ascii?Q?32q+BHutJS4zbfqp8S5gJbgmY7mnynyGelHWh4J8unPZ6NsS4XuMhXzkvXZf?=
 =?us-ascii?Q?gXKjh6AEncGvku1969sj1c74GrFq2SBroNl9aDD3bF1riNqWd8/BJwU6GBxs?=
 =?us-ascii?Q?yD8UgDRORyzy6WV/+1sIT9o0aLP3l+GrHK+6G39YDRvLvjiICP9shFxWjJbx?=
 =?us-ascii?Q?G7sdWVLGPGUXhNspcKOEwWTDbzij0St+g6AhAGVRdkNTCFgFxeFjmgBD/4f/?=
 =?us-ascii?Q?AcfBwCpjoI63YDHlk6wHduckb2tWgKdKdbrct5agUPJQsc61ORqNwe09FPUJ?=
 =?us-ascii?Q?mf8iPE+19J9UWdhJGVYIuPLn93FAvcMC8UEFakta08xdvyCIOqtGwspvor5/?=
 =?us-ascii?Q?5JfjYcrMPeOQ4dmMZdUChyw7o+tQbFUBTeOOAEPaQhK5ZEIkXv+o9cgDZF7f?=
 =?us-ascii?Q?AOwhSn2Kafj2W3bQHuOOX0ZJK5E7Ql+y3/Q7uEQGDHvPLsyQN6W6+ApCxx4l?=
 =?us-ascii?Q?iGz5EJplaJDcXYaQ6uEHrbYv4h04EdU9chZBzARBlqqCBHL563rS9HC7vIO3?=
 =?us-ascii?Q?wcHbqslXLdOfmt3J7qiy4Xl2krme8etZiQ25rjU7Elu9YM13G0QiHjIIdQZ1?=
 =?us-ascii?Q?P4hauMRmVgIjq7+iLOV7Kwzu2C5eWKioS9rMk9E6RcPifq+6gmMHvOSzwPzx?=
 =?us-ascii?Q?Sf98DrlnSnkuAFkSzbGgyvEWnZPBLuJJRRtbfTL28lmk8QUCXnwxK5GGRlM9?=
 =?us-ascii?Q?teOnsysXkFq7uSkm3ylVl8YopsiJz1Ilp3GXzhlyutVJhQx22xXjt/uTXJ9m?=
 =?us-ascii?Q?ZYKi1UCzFJY8peC4zqYIPs/o82whqx3uF8V6Vahzob7kbFxzzU0nJxOUxEOn?=
 =?us-ascii?Q?6j64+DjdkD9y1AndNneYwR0h00mkMTEvw7hbYDBZeDrXSuWXiFwFjOFimNwu?=
 =?us-ascii?Q?hINv0yOepYJ4Yn0apVMc8+WtyeeC+i3fp59NZ7+O+k6Sv9qRT/alDVd5oYa7?=
 =?us-ascii?Q?I3qKKyeojTibXythc5Ln2KHrQzqB4EX62JKGL9JMdPiOr8V9EumxIEENFTnF?=
 =?us-ascii?Q?KA8arwKCI70G9L5f+/pN86A4kkQPNg4Kci1YeWviLQhdJuPfVNGuJSH7GsP/?=
 =?us-ascii?Q?C7HOZ36N/VgzlHjnvalmlVZ2xpPKm6YgjXkeeGoYjkOw8gRHXKLInPydA7ni?=
 =?us-ascii?Q?luz/xHcrwARKS6WwIBKTkhtFNc4FdTkEf4rvjQ+DXdQnPkFZ3ylh14Vf3UYd?=
 =?us-ascii?Q?8YN9kMgUHEfyKv46FSFZ0141cR8/KWvwP2Fx+C6qcTCS7GD9Vl9Dl1VMfzWN?=
 =?us-ascii?Q?Qx1q95axeZHJbk1KWJCzdspy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7036aead-3356-46a2-3550-08d99016db48
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 20:03:29.3304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XE2rhMuPxGqbZA9WMp8MSTzu7S/fKoEJ0+Jz+6na5ZsQFED73eqK0o2FwCENra6a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 01:52:37PM -0600, Alex Williamson wrote:
> On Wed, 13 Oct 2021 12:47:06 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > Add infrastructure to let vfio_pci_core drivers trap device RESET.
> > 
> > The motivation for this is to let the underlay driver be aware that
> > reset was done and set its internal state accordingly.
> 
> I think the intention of the uAPI here is that the migration error
> state is exited specifically via the reset ioctl.  Maybe that should be
> made more clear, but variant drivers can already wrap the core ioctl
> for the purpose of determining that mechanism of reset has occurred.

It is not just recovering the error state.

Any transition to reset changes the firmware state. Eg if userspace
uses one of the other emulation paths to trigger the reset after
putting the device off running then the driver state and FW state
become desynchronized.

So all the reset paths need to be synchronized some how, either
blocked while in non-running states or aligning the SW state with the
new post-reset FW state.

Jason
