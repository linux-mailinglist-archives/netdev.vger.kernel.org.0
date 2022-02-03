Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F634A861A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351154AbiBCOWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:22:24 -0500
Received: from mail-mw2nam08on2059.outbound.protection.outlook.com ([40.107.101.59]:45888
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349153AbiBCOWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 09:22:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbalHvaGb4jm556EDxr7daRvbOqJmSkbOa6YDQ/x5dI64HqbB2ZiX8e8d0KLCt2fX0j1lNf3ysdKR4QgTx+nGxqDDRt4ccdonBbdMSdhkIz/38XHFbKapPgArGw74yKLoaTjIYGBRfS4TR5Ke8Q5muzByzy/0+s+JfvWzzWwo6NYP9okCq6kTkZHdnfG6u1D/EPShJNpLJNlF5DpgrD62GccacQma5To9RRXvv05yrR9vgF1uma+UuUdtE02TN1U7LEYvcjfZnkbIkQUQJMweZXNw5mgkEDB36Gl2HR/6bgF/I2ob0CcizR7T9I++d3CAVUlF/V5dMnsMHFGHa2g6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2ZdFXR7oH2eHhjhpszfZhPdzMOv0K340Z9VU1lLycU=;
 b=GbLVXX62XI0jN0yMnqquyL1UP8kN3ZngULcN5EcwheDsFO9jH5afEppo4Iz/pIqKElnkm4bEccF/562jsCB4TmqzGYxdt0xZIdoCm8AjdA3Jlu/jTIHoXDRpGtv35OWgZoriWR2wXDB3aB/PEoTzTvnneWaAPff3RuX/Vg8WHEq092x9tcFnK+zV6AvHjg0bxy6QQfpt7YsZkdZ+dJGTmDrqltyTiiPozfIbvuf9p3pSQeZ8JZABuP+PXWhywnPfFK0L5tFfhDoBGEiOrnOTYFgnOkNOKtx3q1DRve4sG91IXrC2CDVFd1QRjkOxDle0AhfPiRiClUkNOpcRqx6CDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2ZdFXR7oH2eHhjhpszfZhPdzMOv0K340Z9VU1lLycU=;
 b=Ga9SHONUXusaJ7GLJ7Uzo5XI/PwzuOgVn4aBuHOuGHmhn0OifS1PjjZStP/FS32yirCyB9Y5N9WEZfC8+eQ0FDTnMdg86UjzTh7x9e0GRT36IaoyRHXbV6F4/ySORMfQOCyaiwAqSGS8Etig5CgfdrEJZ3yOCO/2u3bDceoEN8L+2VBlSmMtKvmg3tXe7NpW1ct9Z99jquhRGYMAGTvrR1D4lcZhe5KYjxI5vWCbvS/SHhd1lxl9RJIR/CbLsRCB+xulpeYoUzTm/0/H0OmgkBBnuON/boiQvNWuIDn5WW4iisTFy520XWHKfPI8c7GE2qO/0bOCtv7Q2RBeagvrSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3487.namprd12.prod.outlook.com (2603:10b6:208:c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Thu, 3 Feb
 2022 14:22:21 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 14:22:20 +0000
Date:   Thu, 3 Feb 2022 10:22:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220203142219.GB1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-10-yishaih@nvidia.com>
 <20220201113144.0c8dfaa5.alex.williamson@redhat.com>
 <20220201185321.GM1786498@nvidia.com>
 <20220201121322.2f3ceaf2.alex.williamson@redhat.com>
 <20220201195003.GN1786498@nvidia.com>
 <20220202165444.44816642.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202165444.44816642.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:91::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1358dd2-603e-4dfb-e72a-08d9e72096f3
X-MS-TrafficTypeDiagnostic: MN2PR12MB3487:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3487EB6A0B60BF266DBE7DB0C2289@MN2PR12MB3487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YeCNOjTMjFKnhQiW6EfWkeBU3eQt+80y9j1sHVqJ3ZbQWvwj5Ieem4a7EEY68H7Wr4OIwu1yRuR40aR9p60HW3eCvqLYAV9e7fQDOO0LffG+0Bee6tteSJ2toUXM4y2h/WN2MjoZwumytRxrK38uL70WoSWvbxWkR6790SO9kKukxp6lAvYRTov1KDeLsoBVtW0aoUoFlhCQV8S8p1lpCCKui6STmBPu+PssrIY/vD9tRluvNVh6ZHdgnax4+qBjiuLoXRJWZsnAcvIOfLzE8+qxEmwuABPwOphdNMvdIC7JxWEkUkKqsPWoJmI8gDpv18f87qKbRFK4N/j6Wj9cmhsLT8C0ULdDvz8vb5pZbU4kTrBA6tCxenZljGvVpgBxhT1brgCwwIPnDbkV2voNjZjmEATUNIrh2bd19bmxzaTL6yK8/Sar3OKz8pcpq5DlGhfShIj7rGmLmqu5gxE3hb0cEvlGD2nLoB5lncGqE8l6JAMPQuZSyILLA+JSAnZPv40DONIaLtzN2dNB6rSG+1odtTPTREMRhVC3vpIEwzoiWdqFyIkfq7uIVKfc6/d7Wv/e8oC9vxTIlk/7gYTs8ehMTe7EzqEK8NE+h9tnpnyH00jC2H5UTl5QCRtSfoSH19jpkcUykA1oUnEoMuv+0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(83380400001)(2906002)(38100700002)(8676002)(8936002)(4326008)(508600001)(66946007)(66476007)(5660300002)(66556008)(1076003)(26005)(6512007)(107886003)(2616005)(6506007)(316002)(33656002)(86362001)(36756003)(6486002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YqMk8yDymRSK5oMr5CSi/woyCLZKLLjDJHwaSFYODLNEAvF9mfgYVotHfU61?=
 =?us-ascii?Q?YmHZ/KH3ETb/W+Pq95gDkUTg40Cv030A0+J7v1L8RiqgUK23dFVPU37L20ca?=
 =?us-ascii?Q?7FCmO+jczYQ9aGwCSzKAj0beGIYvLPdr41hJwS3zaJ5FSQS0/7KA2rzrwUKV?=
 =?us-ascii?Q?IwDT3jY0u/mdJQ7utD0lY1kjYvUC7ZnIiXybKTKFUnzI/1EG2Qzzr8KfR8XE?=
 =?us-ascii?Q?oNW6jWAoBHktOKG0NG9RlRzCprLl7ESs4F4Nr8v8qKso2Rp50JpBF+l3sHcZ?=
 =?us-ascii?Q?RY77JQ36SX+FsC2A9b3JvQe6JcraSpCgcHgRu8VEGWxmuWSsMgxDAWrh31At?=
 =?us-ascii?Q?e4gbnchPPFO6jcBH/LTg9SqwmfQsUKcGJ1fluNyX8SjzpadKR6g7jfRl04i3?=
 =?us-ascii?Q?pBqvALLbQ6pfywJ7US9R6Q5zDr9PglqpfjeYVjaiakWH/BrlHknW6Z6H1gBn?=
 =?us-ascii?Q?zHi+PqpPkPs710SlsPY3VQaM45N/ascM0xFiaMjk+VtQOEIDXuK3LZ1cy8fX?=
 =?us-ascii?Q?8r9CZYNTtpgM3i+0sn3gU4oiRvfxXWqTjpOlZVuucdryNRpN85LcEKLrGWdn?=
 =?us-ascii?Q?5tORSG6G6/I9qwHjTyhTWDvLn+PTFJM/icxiAZAqRIIVaGaav6IPj3rWsbXV?=
 =?us-ascii?Q?Uxe3jJc+K/6OEFvrTnKeUXGkAukKZpkDaMqOmeRhPeaGCesoplQlFAGfX8DA?=
 =?us-ascii?Q?yp+0Glo+TxFZHIMhs+FZ8FuINYwKpb58BDgXC7t8JzwI2VIMV4hb3pxE2hhD?=
 =?us-ascii?Q?jxyMM/U4wK+0BKJma9UpM0Jiq3DoLJpuUu+WeB2pOkSgaU/8eWt7uEcTcuzc?=
 =?us-ascii?Q?PqKI4DFT5HtB3VaPmW3+DujAlRAxvuyPXV9eJyXWDhRk4y33Nxfxx1/PEB7f?=
 =?us-ascii?Q?JuECG0GuSByty7m91gQio2GP6d1bkVKYYNEFpcAK9w5Kc+hY4EQcdZs8lzA1?=
 =?us-ascii?Q?3xNyb0CkqJ0DlqyCO5ufTk/J+QFDVQMd+0fYf6Ov0t62hexouji1DFE0yi/2?=
 =?us-ascii?Q?Bu0x7LeRKN0ODgWGDMQYoSlnPCf+3HA6PNq3DCznQ8uyoPPHR0Yb5wFxdXRT?=
 =?us-ascii?Q?Z2lEIWkF0Et7K27nnEXbp6xPC9Ne4YeRwK3TSHeA7PAPIozhMK6uAEELJh+T?=
 =?us-ascii?Q?JBXHXT7MBxq/8ez4+LzcOlZH/C04LE3rcLqZ26zgzZj4nybbifFA4ih9DFWD?=
 =?us-ascii?Q?lTwRCsNF7k/7FBRX9rzcFPgUbza6PSOuHfzrhxHSNCfJuJSXNrgR2hZH09ha?=
 =?us-ascii?Q?7RRG1oB9xu6YsGYFgyhFKOXRwDrH9No8Fy5NXhdoxcU+nLAAfgGYKfKl2Mil?=
 =?us-ascii?Q?h/0boG8DY3PEBk39tNVww7D2Y18U5puPVDkjXd7flxvVmKTw1DcFJn3kqMx2?=
 =?us-ascii?Q?C1UE8gBdC4XA+y/QHYpfZgLlGdjQPFBzOLZZShCL5OJmOREXZCK9XPBexN9D?=
 =?us-ascii?Q?OQ070G3/A8puOxXJQWlz3T9Ssq+uzQaEqhogaqWxnnzyvAWe16iDC+IW+LCK?=
 =?us-ascii?Q?QhVB84BxOPT80vyGWxVZxQMnKOphe7agPRyglc3Opvm/xaZi5R5XN8iUs8XI?=
 =?us-ascii?Q?n5BXRvtpW+51pXUFFN0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1358dd2-603e-4dfb-e72a-08d9e72096f3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 14:22:20.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XA4upOAOpjITnst87eRe1Bn4DOlEyKSkceHJKywLUYRwRQgx8FVAL1L/TxVOQOoR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3487
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 04:54:44PM -0700, Alex Williamson wrote:

> I think the argument here is that there's no value to validating or
> bounds checking the end state, which could be done in the core ioctl
> before calling the driver if the first iteration will already fail for
> both the end state and the full path validation.

Yes, I had a version like this in an internal draft, it was something
like this:

if (vfio_mig_get_next_state(vdev, set_state.device_state, 
     set_state.device_state) == VFIO_DEVICE_STATE_ERROR)
    return -EINVAL;

Which is fully redundant with the driver, only does half the check and
looks weird.

> > Perhaps it is confusing using ERROR to indicate that
> > vfio_mig_get_next_state() failed. Would you be happier with a -errno
> > return?
> 
> Yes, it's confusing to me that next_state() returns states that don't
> become the device_state.  Stuffing the next step back into cur_fsm and
> using an errno for a bounds/validity/blocked-arc test would be a better
> API.  Thanks,

OK

Jason
