Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF06D435353
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhJTTBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:01:40 -0400
Received: from mail-bn8nam08on2080.outbound.protection.outlook.com ([40.107.100.80]:18607
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230076AbhJTTBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 15:01:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFLxlCBwkgvL6hQxMnw8zhM/5SCf3GX8frPd01JMEMaHpWg/Pe+DKUBfxm1CUf4Bl4qjFM5+T7ADTtnS1RBkPX6dAc9kWP0rCKCQlv4EYoPki9ZD0NzpMJfQsU8yHVVuFeVTdnGG8ovM8Ow17F801gFfekfnylNNpExC8vB/IyKf0wtqRVHKqW9dY4xm+SaiUuMDGYfL1aEqsnzUg+a826TcPU6q8+kUy6IT+GwtUBNbZ7IXxeP89itEVEc0jGQl9kS8wGg9M5shkWuKWqqz7JuxbKUrP63guZgMvMoG/jDJ/lG4zlqmGyQ3lZJll0fRn1v1GzA+DEFWLq6r21Rh+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBbvUhyYow1GAucMPBSKuq3pLX8oQ0dXN5aBdeApgz8=;
 b=efSkE1mDVdUrbk4BxBSIQx0AYEqFh/6sw9hLwkW4cj2fvOtdgDOsmg+9d762aZdrAO8SBg7YK4bJ97JOmOVrT2mWvJX0VC8UNLMNZycPcyrQkNPGyjBljKmwk2UUwhdbgRodwdrd4mjFZ3Iu3W/kgqzlRbmsOxkiQc7BiIKPWEUJIwFNCT1wuV6MkyFYiVaNtdtcFOCe3qW5lNH1Xz/Z+qQp4gfykDoNZ/42C00NYQ0LVvO0Ryx4D2O3sDgMWK2WklhpnlmYYfHrfYWBRGIfAuDG4ziunRjlole/s1Q2M8w5Le1lRDFZb9vZf6pKD2ffNuVlhagQZbnot8roNSzk3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBbvUhyYow1GAucMPBSKuq3pLX8oQ0dXN5aBdeApgz8=;
 b=g9B+oz/zGkwjNpbJVOEuHmua0ZI9MXAkeR1POVlfEul86ZuLFWsgadaD/CsaN6JftuTusotfh37qxhwFNC5s+qtM7MekFNXDhJXTy3rFtrNJiOrgxVQsWlbdxSUwEr1DMoJgzYm0wZPiabDFjD92Yhkc5zQTPmiz7dXQeq9KwmL9liAKA3M3yxgLR/8X4fsdldOnWyJ25Vtb0t8oV/ijYbD6qUZrOmF4ctkKHun6Gwjicm/+fRMJrzGuecxxozE/tO4m30yNmibQigqN76MoLj4hcbkZvECioFy4f5Gzu36uKjgAdS4xeMkirHOhkbq3ZX+mKIvfu9V+Z4MD8VaoNw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5239.namprd12.prod.outlook.com (2603:10b6:208:315::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 18:59:21 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 18:59:21 +0000
Date:   Wed, 20 Oct 2021 15:59:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211020185919.GH2744544@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020105230.524e2149.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0389.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0389.namprd13.prod.outlook.com (2603:10b6:208:2c0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.11 via Frontend Transport; Wed, 20 Oct 2021 18:59:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mdGo3-0002BR-Mu; Wed, 20 Oct 2021 15:59:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0b92a8d-5ea7-413d-87f1-08d993fbb994
X-MS-TrafficTypeDiagnostic: BL1PR12MB5239:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5239C8616F1B575D8609957BC2BE9@BL1PR12MB5239.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPq1oM6nYkjdLuWaXUaTga1IUCH28yZ2P1nhCrvUtFGd1EcDGDa8/8AxbUiRdMMrc5w1+JMInApy+82RF4MVLij55sQtVfR/4oei9gGHmOLIALGa8Sb/7DSZVmSogjwBrErTGzX+80fz3DGXjVRVtTM7Ee4M/JjdvRw1nRvRp8HQDMLoXti96w/IwshN1S8kQGh4ynkz7urohL8LuyXTHC/GU49EoXansR/Lz9xL4yscpy3swwLszSxdjPNxtlSuM1FYG10T3/I5DAowsbIAfcoZgnhRAvIWchgaWnKlageV4NmQUqaRM8py7q/EIiP8jrbgVQPgm1VhJmpFMFyvGOH/cpwjgGR8lfIOuRVf9uQeMrnFbN6geY8FhcT92IIznDlitzhWpzAnK5G2kCPTI5RIn/jEGiUDZIK+T7CociLTa+dZnGCtjFEGlLhGwQ1HDNgJu8CQ+411lpKYlcwlJGiZCo0NRu22OPXFdi+SsREx2GYYemiR62eVeJqdpyC75n9mWbFA0YXQfO7MYV7/l26a0kOw1xxTb8MyNccn/eLEhXelvivKHezx98HWRRY28vO5W3MxQYglKvXeZEoA73u5BUYFsSsss1J9um7XnT7E7jO0eDDu+xNZjkgqkcP8oKWBzW/3jL/IZKXzTHBouw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(8676002)(83380400001)(66946007)(66556008)(9746002)(9786002)(6916009)(5660300002)(66476007)(186003)(54906003)(26005)(2616005)(4326008)(33656002)(2906002)(1076003)(8936002)(86362001)(36756003)(38100700002)(426003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?71cBFJMze/yEqTiYCv/1hAwNGYYmfntl27MYvOxUxQtwGkPHFtEi9wMvXEL+?=
 =?us-ascii?Q?j5DZU+5bL0WN3cC8zeCe1MAVgWTOfYBgYoG6U1XcdJhqsOsPxPL0NfnGxqIO?=
 =?us-ascii?Q?EtKNSCttvlmgfqcS++6LbXvGIBqSVVHk4eKVSAYYPJu6LxLBmAp+4xQZFJub?=
 =?us-ascii?Q?EGl5Iq7viL0YBXnm/8e3nYO3X2SDu0GIY/H8sfrAaHnivDRTLDCacKbszY0W?=
 =?us-ascii?Q?AHGKNYmTGMavM+/QONqJwDERBO7Jc2S4YPxu0T9b1cOC0ZA+dZERdYeITpLt?=
 =?us-ascii?Q?1E2l1Emrmo8SJ9QNZ81FNnre6TJXnH1+3E9PtQ20A15wRvav963Lkolom/IQ?=
 =?us-ascii?Q?xsh2Aasxw7wOGOXjRZIc4HRgmm/roCrF9fgv8/r6BINVHz4C5xEMFRFD2xIj?=
 =?us-ascii?Q?YA0pNnDqthfxBscU6fXtPJRXK4w5+lD7obHmNYjO2+Ia3yllMEkdW9dnn8Hh?=
 =?us-ascii?Q?Z1ZJcYiLZDkmWZ+PpxPHzC+UobDZxdR9ATTEPMB+phQ0+fd3M8uNaAn4RhAi?=
 =?us-ascii?Q?lMMq3fkJMp42oeRjXC1PZcSyuU+HczH5XFkbKvYdy51zgV4VnczLl7p3e6NM?=
 =?us-ascii?Q?wSIC5FXdZzB0W9RooeOoqOHkIFFAO70DJGirvV9N7uTCamXvC4su2qrZqpMX?=
 =?us-ascii?Q?tnzGbRO0SUCpsq4N+iPvMxpuSsQ3HS9JbqPz5Y8h/MaG80Q/0+LRnahgSesu?=
 =?us-ascii?Q?wetBJ67ntXqf7EL4yTBXzE5Jq26DUuyBt4B6HYMDVgbS65r5MzSRwfoJuCSU?=
 =?us-ascii?Q?jHvOgeKLfKZXtnLbuT7/4eFI57Wj9qBQjrNClp2ofJ5PhDBJyIHPWQ6/kySV?=
 =?us-ascii?Q?u0DuI1I0nm4OOclk2UsOK4KUqu5seNys67PPles6Z9NHCNKcSYjk10BAUpp2?=
 =?us-ascii?Q?7Rd2LC9LA2TJjCnF90pgyrM2zxCzS/yONfTDnM2E2D/BaU5/HMLWPuT71Jsc?=
 =?us-ascii?Q?0FiR6vtjLePFwXq4/spF/TfxbhJEmkkCNd4hC1y9QSx9zB/J1hamVtE5GaAG?=
 =?us-ascii?Q?CRS7JwVEgrtY+O4L+7OvLd+z55jcN+V1vuchllre86HoHVbtIMK5v+xgrAP/?=
 =?us-ascii?Q?clSK90rUnxOVPThosaMm9WGNwSbUqFl2RD8ucSee2MMqGKi/W7dmV3JyYMc7?=
 =?us-ascii?Q?Iptg77PWTinz3HMXkiLnNbAH6aBeo5WeO0ldT89sXVFw/B2L5cJQLU2PjqQu?=
 =?us-ascii?Q?97aDf7Y8gp1dsEco4X7yMSnEpPKhS6f+Ujn/WK9GECQB8c6DuCL/IWvwbs6D?=
 =?us-ascii?Q?o78V3NnsOM+TmFaFq/XB3ydasSN/avmAzbowa1mDT6/FihO8hMw9CNEKW9Uv?=
 =?us-ascii?Q?83lBYwVU0MVfmnpd9HNuhw71qCpSCpBV/at4BJMG9KukGdIDWWmNZtM/tNX3?=
 =?us-ascii?Q?VL+mySHyn80KrepMw4qWEEtAb5wMQDfZ22/GMZ4gKinCsxSZPCECucziAt6y?=
 =?us-ascii?Q?g9OpCmnnpZs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b92a8d-5ea7-413d-87f1-08d993fbb994
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 18:59:21.1240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 10:52:30AM -0600, Alex Williamson wrote:

> I'm wondering if we're imposing extra requirements on the !_RUNNING
> state that don't need to be there.  For example, if we can assume that
> all devices within a userspace context are !_RUNNING before any of the
> devices begin to retrieve final state, then clearing of the _RUNNING
> bit becomes the device quiesce point and the beginning of reading
> device data is the point at which the device state is frozen and
> serialized.  No new states required and essentially works with a slight
> rearrangement of the callbacks in this series.  Why can't we do that?

It sounds worth checking carefully. I didn't come up with a major
counter scenario.

We would need to specifically define which user action triggers the
device to freeze and serialize. Reading pending_bytes I suppose?

Since freeze is a device command we need to be able to report failure
and to move the state to error, that feels bad hidden inside reading
pending_bytes.

> Maybe a clarification of the uAPI spec is sufficient to achieve this,
> ex. !_RUNNING devices may still update their internal state machine
> based on external access.  Userspace is expected to quiesce all external
> access prior to initiating the retrieval of the final device state from
> the data section of the migration region.  Failure to do so may result
> in inconsistent device state or optionally the device driver may induce
> a fault if a quiescent state is not maintained.

But on the other hand this seem so subtle and tricky way to design a
uAPI that devices and users are unlikely to implement it completely
correctly.

IMHO the point of the state is to control the current behavior of the
device - yes we can control behavior on other operations, but it feels
obfuscated.

Especially when the userspace that needs to know about this isn't even
deployed yet, let's just do it cleanly?

Jason
