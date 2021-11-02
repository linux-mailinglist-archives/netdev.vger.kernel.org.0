Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAC14432EF
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhKBQjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:39:18 -0400
Received: from mail-bn8nam08on2065.outbound.protection.outlook.com ([40.107.100.65]:60129
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234880AbhKBQis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 12:38:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdM7VDYkmDW7/pk8Et5LEpBbfbL99uj+FXFxN7K+6x8c0ZZL5XMz7XrIoZ0ATmPWEkGAUhA2QzxjnDb+dspMwGnYyuBeCUchjSuy7eFh2PlpnE11+xjMQYr0FD39anZB9gxMYm5Vq6jxohDj6IC5KXWsarsnCY+0wYSdcygmjN4/Vm3Jpy82glawodWZdRE2lqf16Hqz0Lz/ok++A4NLsl0eBx/L6JYdPxeMmPLfQvmCntE/1UfRwz6ZUJ3qJUdCL0hdT1nEmo+FaipXo7hyfwAL+gNa+dSoy56cW4nTqAHDAQuVSVV0CqsxNIod2KmloAens0vjTxJ5v0NeuAFzvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqf1BXeIYGxZ7xddyuVFVK1bkG7dP9x4p9GSX7pj8b4=;
 b=PIXn0zZcN3yu6b5PgvFN2TpGgv1dsDGFV2iIYPPgsLohRLDK151gom/HA9XlfsBKN4VQzMgpWPFAeBXzmL+gN6DOD7yUhQXzPorXV4p/7WcA2oKaVdzzNZRy7rx8JFEB/u/ZnFoBaFjaT9I70I3AeAMTJQED55kzdM+xwLMWu1UuWSOrJSJdaByLAX8/f/ktDq5e2basDQFwYZ67kAAMlBmEx8wKEzLMgYOwwTdSc4C6v3znDITzHfi8UI3StGSLtZxKS0Kcg92EKaVWT6OWyu9SMSVZR4XBLImZ3mv409oHUNEkreZx4g4IgDMhEL+pn6+LRnMflej7Hi2l1ECh9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqf1BXeIYGxZ7xddyuVFVK1bkG7dP9x4p9GSX7pj8b4=;
 b=OSGTXAyU0vCCpRxPp893cfptahzrfyNy+pQkexEZzQX831hvpWFZaF/zLNwvWhryQMKF7t0nIMyklUCDQ7L1uM80eyiqQ4ZDN1RHPcKvT8T+irINdqKDqWjYQOcD07yVGYvVj0bG1CFmnS3qAAhw28UfPEDNNt7AvD3Vy1EJ1S2gRaz401JhVptdH6LDI4T7cLy2cti25aPoBJEYW1hlMGAa3xV2MzsEDHBrhbQhom2qGqfZwnIhvcf9MfnY+TVpdNge8nQbbhhH4Ws58kc8w2lg4sH2t17NY+FU0QtxzZ1fcBe7wk1F0r4gE0Xy7wnfGjPfTa3TEG/I8HycaRLCtg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 16:36:11 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 16:36:11 +0000
Date:   Tue, 2 Nov 2021 13:36:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211102163610.GG2744544@nvidia.com>
References: <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
 <20211028234750.GP2744544@nvidia.com>
 <20211029160621.46ca7b54.alex.williamson@redhat.com>
 <20211101172506.GC2744544@nvidia.com>
 <20211102085651.28e0203c.alex.williamson@redhat.com>
 <20211102155420.GK2744544@nvidia.com>
 <20211102102236.711dc6b5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102102236.711dc6b5.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0039.namprd19.prod.outlook.com
 (2603:10b6:208:19b::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR19CA0039.namprd19.prod.outlook.com (2603:10b6:208:19b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 2 Nov 2021 16:36:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mhwle-005AqX-5r; Tue, 02 Nov 2021 13:36:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31b15be8-139f-48c0-cc36-08d99e1ee0f8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5175:
X-Microsoft-Antispam-PRVS: <BL1PR12MB517504A36391F631860CB0A5C28B9@BL1PR12MB5175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l7FWPm9X2kQECDoZtDAcRnBQOKLuhbGXTCXlnMv/FKg9pzi6FuuPlqkzVQgphnDTi7k+gLgeqNjZUbekRp1QBtVtoDpN8XEmvyY+6qmiyNOa0XboOgK1nBNts0VhD/9yNL1LbmlC1zP2g8Qk3G0hv8iCsDVie5bKQ28WbrHtV75P3IfptEy4+q67uXYFqNqih1PX5jgWZWVX+cvC6mS+ODH7mqdsizcV3FmcIdmM3Rg+EfezeJWxSVaoaK6W1eslxbiat2B7/sxOoXNsGSPZSHI96WPpiMK9kC43whLjU9D6TTITrzu+sQvGkocZ0Ni9G5qBjp8x5EZj1vV6aVIirNwKJNOQ3NzN6zo9mvemRlg3b2F5N5OFlv/v8grH6vV5k9xLoArcfejO+ODTeehNEiF5xqAzlnipnPWcI6QZtZRPGYBu8RdliKbuPT3Vng0YJZuBYDLaBugDSgtU+IMbk9Ivo+o7cdrhXToWnyfMMWEzADM5RP3jvLf4l7YSPOXltzbNvKF4wayQM12tbGIi0lnE9eq9cMYAP2Lhj/0gatZ427YL/4Lx/heRo8caNaHfTwiyzCMn2W1jAP0lcLZO5o8iC7NIm+liovU3O5Z/Z13kkSVcjakCM7YeFzuRE85/Sqf4wsRU6WDmKt9FYKU38w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9786002)(9746002)(426003)(4326008)(36756003)(508600001)(1076003)(2906002)(86362001)(186003)(66556008)(6916009)(8936002)(8676002)(66476007)(54906003)(316002)(2616005)(26005)(38100700002)(33656002)(66946007)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K1m6L6idRQkD0D+nQj9Nh1lyP6KzPqi/bR36PGo5RNLEtfDAuUwwh88qxDuM?=
 =?us-ascii?Q?pTdLgScSfqTlvr8HKI83nOXDtWZzf0Gj+/yQW2gyUx1UHKprGLI45mf/e29Z?=
 =?us-ascii?Q?Xcv2q8LyOO4i4oa7/E/MokvgJZHBu2whcezU4/P7FMxAtBotOWBZnubY9BOZ?=
 =?us-ascii?Q?5RDVNL3BsDYqUqc3hjiWfZBzGOKAEIxgbjm3HyBVnuiBRBMWZjFWEsTRcRpm?=
 =?us-ascii?Q?5GqufAMBY6aWZQKM3cVTaJtbSFCa++yCtFlYX8hizN54AwUoDm5EBRjP7Mmn?=
 =?us-ascii?Q?5dZL8RBZRcrEfrDD5n3/14Y5wDwxWGU1Bn9XxPRfgDCurGwn5ELv9Glc4Iiu?=
 =?us-ascii?Q?WDmreGkk9scXPk3hRg2qLWkaJUfZ3EaglT81itSXbpQRZpMl5MXIkwdoxEcM?=
 =?us-ascii?Q?XPtx0SWKM1a/n6MhZcl4kRiHnH1BT4j+VcwCICJUy4pwxouRFk6/F2nQ09AH?=
 =?us-ascii?Q?E/bT4U4fD360g0YFiYA/CiCimDSCPeA4x4bPzfMqq+P81vj4236/uwsRb6br?=
 =?us-ascii?Q?g38pHMvFqiXJBhJKm4LavBOozzxIdhAAlH4CF1qDBNc9sxZlgDGKAHjpkwLs?=
 =?us-ascii?Q?6H65+CtT8RsA74eX4tEG6hwRfg8sf9nHGdzvgh6/26lbQEgbCzrBN5yp/jVT?=
 =?us-ascii?Q?dg9ikz8MQWj6ElSYIqizxFfcVvfr41V6WkM63jWk4+sZEafe65usgSqvDq2B?=
 =?us-ascii?Q?sdx2yiPLfhJuAnUAi0L4GQ/LNbTSKo+nQ8W65VPVJJbMMudTlnhqyHWIaxmm?=
 =?us-ascii?Q?p7in55WLn2Xo2gdZ3wKzi9Y/z+qy7J/68xH6phzs2/6bLpI5hPyYpZj2EWfQ?=
 =?us-ascii?Q?YO4sJnBOdWdLQsGDFLkAkt9gd+28BBTd/YETYKEYz65mHrb5bKHwFabrzXKS?=
 =?us-ascii?Q?NFt7GRoCtNWvcsip36ZZB2CwR9ciZ0Ewa26gKoBZah/joyUOTz0+/wa4QHAt?=
 =?us-ascii?Q?+esqD/EKPbzSVObBHonTWA1XzROE8KiTeYw8fpwaL2E3h/5aiZ5BKeE60c68?=
 =?us-ascii?Q?A0Dj3hnrlBH2vRdspoa53DQSZU0G+mp+MBQQRkj55+RNJqBVz3+l2DmMzPdK?=
 =?us-ascii?Q?YxCWgHBQUPd9CChi12A042XZvvzg7EoCvBC7KTiV/usKIravJwyhP6uUT6qj?=
 =?us-ascii?Q?q6WLUL/ifpSZIdtAU32uguYUSPZaZnINY70Nt3hukqog3OJjsVMoNde+54Lv?=
 =?us-ascii?Q?HNpDYl6vkNywQTy7jUSHWvs9xQMPGjGGArhIeLQtcvs0v6CY9qB7BKu21ZiP?=
 =?us-ascii?Q?HO37FGmXa+/hFxXyUKIQgOOvp3EHY51OOPe/zrHm+0LpPByCHPkPl8JDQml7?=
 =?us-ascii?Q?b5ervmcJsS+PKF5ZWdxg6+XHAGlM71ltx7bxGnQJv+gJMFxc4FSVALFKtAhs?=
 =?us-ascii?Q?usSJq4pl45ozqRx27DK16jfpanXgVYWXWF2gPflf9mGGzOZThUy1M6zRZmvz?=
 =?us-ascii?Q?gOhv+i04Tpaj/cPholWlT0t7QvM659NBnbZRy1O0QdfSQAGrIGUgcVFvkjY6?=
 =?us-ascii?Q?558poul7pyqKQcs40hjt4KeunemEbTKqq/A59EaynIQ3YLjeZDkwZrwFdHT7?=
 =?us-ascii?Q?bUtOfDGUBg3y2dUH0pQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b15be8-139f-48c0-cc36-08d99e1ee0f8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 16:36:11.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEPWeqdWix2nN2SFPJLn4QgZSTmP96/suOtpG5NlzshzKehYLt0YOM5iqrdo73Yi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 10:22:36AM -0600, Alex Williamson wrote:

> > > There's no point at which we can do SET_IRQS other than in the
> > > _RESUMING state.  Generally SET_IRQS ioctls are coordinated with the
> > > guest driver based on actions to the device, we can't be mucking
> > > with IRQs while the device is presumed running and already
> > > generating interrupt conditions.  
> > 
> > We need to do it in state 000
> > 
> > ie resume should go 
> > 
> >   000 -> 100 -> 000 -> 001
> > 
> > With SET_IRQS and any other fixing done during the 2nd 000, after the
> > migration data has been loaded into the device.
> 
> Again, this is not how QEMU works today.

I know, I think it is a poor choice to carve out certain changes to
the device that must be preserved across loading the migration state.

> > The uAPI comment does not define when to do the SET_IRQS, it seems
> > this has been missed.
> > 
> > We really should fix it, unless you feel strongly that the
> > experimental API in qemu shouldn't be changed.
> 
> I think the QEMU implementation fills in some details of how the uAPI
> is expected to work.

Well, we already know QEMU has problems, like the P2P thing. Is this a
bug, or a preferred limitation as designed?

> MSI/X is expected to be restored while _RESUMING based on the
> config space of the device, there is no intermediate step between
> _RESUMING and _RUNNING.  Introducing such a requirement precludes
> the option of a post-copy implementation of (_RESUMING | _RUNNING).

Not precluded, a new state bit would be required to implement some
future post-copy.

0000 -> 1100 -> 1000 -> 1001 -> 0001

Instead of overloading the meaning of RUNNING.

I think this is cleaner anyhow.

(though I don't know how we'd structure the save side to get two
bitstreams)

Thanks,
Jason
