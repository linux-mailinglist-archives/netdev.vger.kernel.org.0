Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A40B4A5BE5
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiBAMKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:10:46 -0500
Received: from mail-bn1nam07on2056.outbound.protection.outlook.com ([40.107.212.56]:25414
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237797AbiBAMKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 07:10:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYvIg4ltK1fvEoiFUso5mbg07tJs2pFL5gEovZz9KNUBU78MSw4MFIFIihVGtb4K87bO6CqtzEFwbq1JTLeBTOY/dDN9COWtLvJbtmDW6uzwN979hyYH9VX6Q+UqsJXZSu6wzL7apEnENbFheQz/UtrhVU8FDcLC8YcuweY2SpZT5Fton88o3/PifiG11CunU82UzaT8+F4ml7aX+U+YzJrsMP32ve3PSITtvCCl7oda7uxaOYUfSDNzxH22AKKmQencL67thM5KAhBlcN9kqrsiCUO9++sUxsgZ4XcnUkaoHh+YIC8lCgxEYYmpaME87rZTcW+TvK/rZoNKM9VklQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKi+W4Fl/EwEatGk0WftUwk1K/YX0I6Czr2vSNvleW4=;
 b=lugaIblX33BXD/DVY5/802/OxpN82gDYHuyEaBOdnRkprHcTy/96TcZEopVhqssU/KYiLncESNaBVUsXz0eNvavso/cOel047YrEGpKJj2/Tm1QYG34ch0E+2cugyO3A7mSzckiXraPUyWQLq+xo6eM0sKxyR1oCYIMwMCeCJvYE2u24/Iw78JEyoSnB/ap1uLmk3J/GzRFRCYQ/gNz7F6RKz8lLV8tS5SHq3q45zI0AlpAGzK60vMXk7qd1GkTR7maPCLaeZd+vMkUNjQPlvPFGQTtzx15kppqmGP1vaQ1J/JOOuX8DwOyNQCsVK2CBUxLwj12pD8ArszHesfxC9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKi+W4Fl/EwEatGk0WftUwk1K/YX0I6Czr2vSNvleW4=;
 b=sMPvSw1UbWv5xOzB7CEaE8xPz3n+d1fwCAbMIYirmGrZVj2M2xKNPzRYIubZUXVMgRB2yZRrmWSmytlv2+rW9jLa7aL8aH7DdO6wzprCwRo60gZIsFyuZ4qVCch55+LatRyNHKkLhG/KttqmzJ4aOyBy+HSEdZV5AYfZVEcBYvBWmYHRA5c34x2Vd75730oy/ODIIyJ7xOu2a3kRvg+0qweI2ZlILJvnyBjAFuZBsDs8a6U6ggl2RnYrH/BPR1ipD4d/3eFbRN+LjlMIgSigUZlj7uN6Q2YiovVE5reoWsJn6ZHjef8FWYI7ZLKxVjlao53YFxE2iuXSLHAZBoQlNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1834.namprd12.prod.outlook.com (2603:10b6:3:10a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22; Tue, 1 Feb
 2022 12:10:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 12:10:43 +0000
Date:   Tue, 1 Feb 2022 08:10:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220201121041.GA1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
 <87y22uyen8.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y22uyen8.fsf@redhat.com>
X-ClientProxiedBy: MN2PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:208:160::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e5ec83a-84ef-456c-496c-08d9e57bdec4
X-MS-TrafficTypeDiagnostic: DM5PR12MB1834:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB183413331A439B2BE763FEACC2269@DM5PR12MB1834.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BukI+TLb2RUjqS0s5W48ii95IFfKqw9krybTeRYJxRIWpRxKhmo3KrbedyQXq9UKd2XkJghZ4vA6wABofI3h53pBUiuwKeTn/X+OqaNb+FnVQnmNgm4v1LyYcRhJp2zMDPjtw3jakEf/aLinu5H7RWnup7kbcSd+PgeU3exIsBVjwa47BVIMaQ2uESNXRiEU9LwpSsGWgx+elTK0gDIsUb11FSIg83dFPui53gr0374pkZHIWxqKMGC95mw+BGLfFnCrLjim+88tvnfVeBm79IOSo26a7fiI2Kec4Pwx1+7w8NTV+FsKWjF+5HLTCe6lHlaB8HYPkSBwapfK89wHcDhLQUI89PCuw7TwQueO6lpiqdgvoZl2pNa2Dy0/SCxKU+2kCZP41P73cgqT5WAvwQ/haJHik3JSsxFrNTkHYF845ivzv0r757Hmw8rYogLW3KfIyPawFET7bCXQakEZ4BTougUvDiDA3eDmm0anp8YnlptyAzgkzuytHy4xxQo0FZ6XOvMMjk0el3vg5RJHYLqnlXnqnC1xMpxNiVNh3YLdv/IakwvxWDOl0kgp1FFPVbf2ZciSWIhs+VD6oTpcolCdgAvnp6caNNd1bKSadIFXn6emYSYLhbPgT2Tm4pSI6vpzGyPwXERPZSgHvBGsQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(6512007)(66556008)(66946007)(4326008)(508600001)(5660300002)(8936002)(66476007)(33656002)(6916009)(316002)(36756003)(6506007)(8676002)(2616005)(2906002)(186003)(83380400001)(107886003)(26005)(1076003)(38100700002)(86362001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ltx0MDO/gdaHgbz1UiGBnntg9QPXEbxrqLqu+6B+c2Hkkr7+awAOLeJ8MCS8?=
 =?us-ascii?Q?B+xskw/y9AWWnsCGOhjVQuoGEFX1Q5MpBy+4X4/hxkmgAJF2TYChSBr88dtW?=
 =?us-ascii?Q?mhdjRrK4S3XncnoWT1u8iyluGafpWj5lIiWDy+U/4AnXoDqScUFOLT1s30tE?=
 =?us-ascii?Q?H1MlhLbX6Wfea9tr8lcuugOrUT3m8mMpDLAUuCTA0cWgofIpRVfqbrtr7Exh?=
 =?us-ascii?Q?2TbZtomu84PsdA19WG78jvwUced46QqkEj23pCuUO8RVm/xT1uAE1v0OdqJ1?=
 =?us-ascii?Q?bDuKCOaXEspz9VGus9aWRn1HCsjE4J9UkAZTS/WIMou/SCKUryVCGiXutDWF?=
 =?us-ascii?Q?+EGXhPjnDAGSU2Uzk0IzO2tGj6wCp411kIImiWDFhhEq6F9DBXyWvAjPOBbD?=
 =?us-ascii?Q?CYXkaLETSetaRoNHSS7YjZ4spHK11UOH8TrZoOjmIcxroun3hD75LGOQTUwm?=
 =?us-ascii?Q?oDOsDnLBRtCYN5gyS0a8f8SfNsrbS+p33e+AjEzUcEqMkuVkgIjhA8f0Awj/?=
 =?us-ascii?Q?iGMNoK+S6V09Y+oN3hYfsAuFQcUYI+jx0ID0Z1Ywsc2/0A7PjcOvqnRbXqKI?=
 =?us-ascii?Q?cGyPWaQrKimDDLz99Smrhp8Pi8oCNY6cMT/wXIOhF9v2AghOrpEUcoHJIo4K?=
 =?us-ascii?Q?WNsF4Zzxab27eNS3UhgrEMKSDHucJpoWxnw1Z0xvQSNApb1C8tx83MRohq4Z?=
 =?us-ascii?Q?ENb/+GaLeJQPUMNYrbU9fJVzBIjBn2r6Sn5B8R8mlVnQ7Pj3Efi/17Gc0QLp?=
 =?us-ascii?Q?D118lzNJuYoLR4hwXFAsE7F5K1eHXVToA2ujJ8WsllRD+iFIheoSqG4xot0l?=
 =?us-ascii?Q?nagxKr6DuzJH7UBdR2RxWAgeXesXBIOObWA/taREvDnhkBROWP9dMFq28bfj?=
 =?us-ascii?Q?MhA8xdMLgEj2jXwWLBoEKvn8JkcVZsnLda4hPBozIOv9K2vmHSGamLZyXpV6?=
 =?us-ascii?Q?D7V1FbFYqL/BhImjakXOYcb6IZBp/3VZAPRU0zoM2OT6EqpYtN9BZzs9ppvk?=
 =?us-ascii?Q?2q/n9OT8UFsAI0G5S/Ure0L4dFrTnTLBbde6QRShqe26wjdoBrEWcRBQT1yF?=
 =?us-ascii?Q?pz7ujV2Xe6vjGepDNh1RiO0rRvYnnIVHO7CTm2rzOvirhR1HL4pjCdr6rIxg?=
 =?us-ascii?Q?cH4yruasCn8NoD02ryCtDmqIqNdn3KZE8JYMOrA72f2oyxphximajlaSfLOS?=
 =?us-ascii?Q?V4ZqMV5RV600SZ2ehee14H2cyU3ILtVHNgM5mv2qjzThS4rmRADlnDsnN82J?=
 =?us-ascii?Q?TGlb/uFqPJk/dg39utC1F4IFa6X6UnIjRLazrHESh5lOJ3WiCirs7nmC/W6f?=
 =?us-ascii?Q?B5nBPEpO6KPiZJIFa0wsVkTBQV/2dKNOSzhw45cs22KspBZaVRPt+9E4huUz?=
 =?us-ascii?Q?T1gEaL5whOC+Urh0YSqVTeFNXbSxdlhE3I8PSJMVnBGZLKA+neo9IfLR+EgT?=
 =?us-ascii?Q?bkO9qBYokpJlPwfCw/ZG3u1m1W8CE2HftNuM0T72+VG6o29QLZUzh86oMnEz?=
 =?us-ascii?Q?SJRoTax9oD2ZrlJx+UUl/JiZgwILi1H7RTNp7o8LKhGR0moqIf49FKxNShcq?=
 =?us-ascii?Q?rYuvJvv1Q0NRoHLrweU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5ec83a-84ef-456c-496c-08d9e57bdec4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 12:10:43.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXz3O3r/Kr2z3ZZCwyKtQt86bIqknyjwAni/S9slAQH4+GqIsIfCM8edrDq99Jvw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1834
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 01:06:51PM +0100, Cornelia Huck wrote:
> On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > @@ -1582,6 +1760,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
> >  		return -EINVAL;
> >  
> >  	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
> > +	case VFIO_DEVICE_FEATURE_MIGRATION:
> > +		return vfio_ioctl_device_feature_migration(
> > +			device, feature.flags, arg->data,
> > +			feature.argsz - minsz);
> >  	default:
> >  		if (unlikely(!device->ops->device_feature))
> >  			return -EINVAL;
> > @@ -1597,6 +1779,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> >  	struct vfio_device *device = filep->private_data;
> >  
> >  	switch (cmd) {
> > +	case VFIO_DEVICE_MIG_SET_STATE:
> > +		return vfio_ioctl_mig_set_state(device, (void __user *)arg);
> >  	case VFIO_DEVICE_FEATURE:
> >  		return vfio_ioctl_device_feature(device, (void __user *)arg);
> >  	default:
> 
> Not really a critique of this patch, but have we considered how mediated
> devices will implement migration?

Yes

> I.e. what parts of the ops will need to be looped through the mdev
> ops?

I've deleted mdev ops in every driver except the intel vgpu, once
Christoph's patch there is merged mdev ops will be almost gone
completely.

mdev drivers now implement normal vfio_device_ops and require nothing
special for migration.

> Do we need to consider the scope of some queries/operations (whole
> device vs subdivisions etc.)? Not trying to distract from the whole new
> interface here, but I think we should have at least an idea.

All vfio operations on the device FD operate on whatever the struct
vfio_device is.

Jason
