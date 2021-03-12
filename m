Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8681933943C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhCLRDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:03:39 -0500
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:58305
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232679AbhCLRDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:03:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QD1LSMYTlrE2EAb+ljhxLED+hukF+ypwcPUtKIJIakxjfSMf4vB8p/dIoR7RKLzl6mV2yWNp3QYJxJW6F+PcdWfq+wzMq4aidzg7PQtaiThyeV+zG1W4ZG2sb4abHEgDYYNM3rZnJd/CBxoSzj/10ulqGpxkxHE0PyNQE/K9gcFmV6VmrRtnGHGdDvZgEAepRz2OrbkzSAjHSlj8EC4ZZImUMlwN/c6Bozb9RvCGmjGSKUuwMiSzG2yzKCpxGE+T23ax0hUg/G4DJUWqpNjfttsA6lVqPJcgx2KRl2PLMAyUZcLiyIT8sEv8QBsvfSDGJRxH29YCt8hJKskx8mcixA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEWDywpfOnZ/nhqcTpOMvLYzZMswDNhFwVIbzd02GwA=;
 b=c1rFw+ghV/CG1U1s4h8aqD/FaDUIfGaeLiMr6VksKspYX275Zkloh0jNrZpxhVzSAzLsZePVreuOSkg/IvK5ri7BVPSXS2FtBjPtOduMW6jd0hqPZxiAxZbRA6xbckcpl5RHg7wAb3pcdFDabIWJG8v2HuJWLfQyvywJEXqnobIYeoKhTisQ1ZsTNXiknLYBCdr2ZZRj9zz7OXs8ijJggLlkKQQDYYgCTuxTbCo+/vNqKNqHm5vWZTUTVOu/T4Y+weZyNpnDgRyn2rshYKk1/68CPoHyV7KHCxlzX7MUD/N8xnyL/cnbKguP1N9Pwth5wws2yx8mRj0wysa/whVEXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEWDywpfOnZ/nhqcTpOMvLYzZMswDNhFwVIbzd02GwA=;
 b=SDK2KQwgeLbMklxQwsq81eiXY1u4aY7vk9yg7hKFsUnFrFnqgFjcWu3r0AljE56QGP52++WNs85O86fSb5ECLoz5Xp1XQWBu48EhqoGXfvK/pXxQclWKWgEOt+zw++N/cS8x/CokT5nKxsCTFRfiUNVsvgW/Az5AzhJuE6awqz6/4Zn6+KW/jEnIaSqnVB6yJbLOcxRjJ0QNa4HE+sltChszptGXYMWkrU1Wy8j/WjEk0ZN4ihCkhazw1DOD6cqKyakIws1985SapwzBqTUEiORxKQWTB2Zg9Uym60as/ne3BGlYvirPbmGuxwQmS4RqZdgxdj1BMIw9g43jQm1eIg==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2602.namprd12.prod.outlook.com (2603:10b6:5:4a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 17:03:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 17:03:21 +0000
Date:   Fri, 12 Mar 2021 13:03:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210312170319.GG2356281@nvidia.com>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com>
 <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
 <20210311232059.GR2356281@nvidia.com>
 <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
 <YEsK6zoNY+BXfbQ7@unreal>
 <CAKgT0UfsoXayB72KD+H_h14eN7wiYtWCUjxKJxwiNKr44XUPfA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfsoXayB72KD+H_h14eN7wiYtWCUjxKJxwiNKr44XUPfA@mail.gmail.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR11CA0022.namprd11.prod.outlook.com
 (2603:10b6:208:23b::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0022.namprd11.prod.outlook.com (2603:10b6:208:23b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 17:03:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKlC3-00CBg4-On; Fri, 12 Mar 2021 13:03:19 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3983dee-03fe-426c-825a-08d8e578bd44
X-MS-TrafficTypeDiagnostic: DM6PR12MB2602:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2602CFC9DAB7C8C61812D23AC26F9@DM6PR12MB2602.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIRGiqV2iyCUESyCOv+5ru8cPzhHfz4xH8+Ha0vSNwFnCPMtSAXIwcWBaJNWZ+bCmZvKl81WHcJJssP0EyoNei8yF0TF9W/Bxh7fx4nXDhfwP8B2LvY9G+C3iq7ayJxCzmYGt+gDm32tk2HDJ6r9FXp14h4e3SafYJkSrc+xJ96imV0S2YsJ7XfhHyiTjp5xt2lkFzkxRxxnoZtwrnAs6qBQNsFZM9vqeuPdx8upPKE8y5acht1WTXH0Nz6YWNlJpgLbc98wvWBRZqrBXIXGjOe+lhBiJLVyRDAO7UEtmw2eO5bTIzaUQ55oGBj7YLlwM86J/LdszTo7squOLyJH7GlBsCQYU1ej7PdmA7xsxBfYsE4Jgbq5W53f9H0KsaDRreDcXOnEyejayz/kZDvuVeUa3Q6oTAtd0IPC07GmhavcW8d8nH2W1oY+DudYlAm3wMTQ3GGtsPFZxyRDok44eC2cim+O+b8t4Vj03Zrv4prL6WcnoCH9n81i+rOqUQ7r/vemz9a9jrOY6j+8PcrspRquCFt3TcYYYo06Z5TVTiS82pn7+Mmtj2OBHV0cEQeW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(33656002)(66946007)(66556008)(66476007)(36756003)(316002)(2906002)(5660300002)(4744005)(1076003)(7416002)(26005)(426003)(9746002)(86362001)(8676002)(2616005)(4326008)(478600001)(9786002)(6916009)(54906003)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pP2zZ+UaRG8bhMlbwJsc9WvVD5nHXyqw1oGimLeBOSrLvm+AFqmTuUlSpkmB?=
 =?us-ascii?Q?rzJiBG4B/ni9NoEh/26jAUpQpURgdezEXQOSMEVCDQOLNS22q46J3XTKvVl1?=
 =?us-ascii?Q?O0MczJUAOwd763o5Xhf1UJC5tjD2VhdW2IMKIYnoPsfpmsflAyN0ZGjFJ3OF?=
 =?us-ascii?Q?g7bJUa0hwf3zpe+d2ATC5+OB/twW2TsXQZT3gC7g/9ETB/kC9WefzsvdXkeW?=
 =?us-ascii?Q?a1g3L5uHQ/zgSR5zvoFTV1i15WoZ1GTLhUhJdE3HeNx60nCM/vRMkAoMcEUz?=
 =?us-ascii?Q?Tde5TYTw75mjijcn+TbfKrlk7p9dLqb5II6TfxicmmknQOd+WkfjtiI033I2?=
 =?us-ascii?Q?AKE9SD63oRF38iAQJg0+sQUMGOuGK+kDGTKvPbSYKzQ15O8Yhlv8n5wzZQL4?=
 =?us-ascii?Q?PQI0XZEkTG4WvOEwWpo2pQLObMkqoQUCgNTxWT5s5vEAGYTICdCgXeoQ86B3?=
 =?us-ascii?Q?mdDCsMHWp9tHPzYa53q7dmMD0k7DC5dhKW3lrzS+cWiQ25fLMvxtpVflMMxv?=
 =?us-ascii?Q?dS5WatlsxsEO0zlnhefOprO6MqvHab32kawisPkMyUH2C9T95GKJCv+SBWg+?=
 =?us-ascii?Q?wuFGMVNtHfYi9ueMo+FOP0b5oM1YSTtqR3RVAUnrUnIZ/1FZ9vSMy9yHKQ8c?=
 =?us-ascii?Q?f4LKaZryk9IHyiAlfDIiJbGt1enETYyOK1/RGH8/aXNYlAdn7QsVgXJGDEku?=
 =?us-ascii?Q?sWm1i8o2aOhW1uBQILpZxGprvRR2MRaitX4rHAnjcObu8j6FE9pPDJmpkL/j?=
 =?us-ascii?Q?b8D8NjG5m1/wnsT+9wjbgN3go8fLpCmHCFcgqEYFShqMN7qcFRAU3r752LP5?=
 =?us-ascii?Q?FGsAV74kvQBaX6qqkjcVBywhX2EvU+OpSOfspEeh8Dejm8Hgrn8+vmKA9fi+?=
 =?us-ascii?Q?xda/KidvtsTgLQE0XxFo5GrUVvjGz5lwaAEiJlJN1xDgHWz5XH9rjkYIYHJp?=
 =?us-ascii?Q?6rGCHtRueOoIKP7VKVw260qPyZ7AKHk8lO76d053QisLwwbPXUoLtTMoRdhb?=
 =?us-ascii?Q?ZbiIRBLk7/bUd1Mogk6lk7yvTG6CjZIRngArKrHUS+soAL+uLRD/odCQ90lV?=
 =?us-ascii?Q?FKgHRuW9b9z1DBll4XPyzb4bFyQ44/sq95cK9abVeRN078pqwabvFU3G89ef?=
 =?us-ascii?Q?AfTDnTWK74b6NQV3vVsVZepW9m7LlD1Xrnervad7HW3x4u92AITZlcZQw1PP?=
 =?us-ascii?Q?kcLFBOCGR5mtXaN3AwH1CSPHFST1/lpO0e0iCSzakFIlShktgY4XH0NiGd+E?=
 =?us-ascii?Q?eQ6FfP9TJBAM+QmvDOjtl6e9mRm0hf5uPFmkOLojLwYhIkvqUwUL+0c+4ij8?=
 =?us-ascii?Q?u1VNL6lQzw4Zyax9NdJg259+mcVUX/8xXErbnoeCTFhw2Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3983dee-03fe-426c-825a-08d8e578bd44
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:03:20.9283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHdb7NwW6LkBKg/lEr8Sw3mLeKZQ/IG0NlTqC3QZ5+l1k8rZVL2Ob9DwJjmW5P8V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2602
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 08:59:38AM -0800, Alexander Duyck wrote:

> Lastly by splitting out the onlining step you can avoid potentially
> releasing a broken VF to be reserved if there is some sort of
> unrecoverable error between steps 2 and 3.

If the PF FW gets in a state that it can't respond to a trivial
command like this then *every* VF is broken. It not a useful scenario
to focus on.

Jason
