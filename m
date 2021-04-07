Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A870C3573E1
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355088AbhDGSFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:05:45 -0400
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:12200
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355081AbhDGSFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:05:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwV5a+LrDio73kwwf1KUugh8emcnjOPpF5TrfG0CECTu0iPKmG4OAfrnOjULYAd9dd8trE2+GVV/37Mn1fzwmHN4Y8n14dB4jtzClMOBdE5o722e0GBENirshjbHlqPBIGAzN6Ti0iPfMPlrHT4uTzZ1PLMew0A3g9xBYTTKpFl8wzT+fkvrgVsQ7C1uAcgp2sVq5ipsJYSheGK8ms+WWPXltSYjj16vJElrKvlQYGmzCComrOIx0Clw7orBjJYAAXb3ixsFGxFLa7TUsGq2kcHRJdnV+a2Cvo2b6+tC77rhYz/whGgMqSEmpsbqZnY3stWg7eAffN3NXHS6Ds5qCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlZkq+7gKqwf1vtCDhm0GJDNCA10nTG6e5Gnd2xZfbs=;
 b=n7ESs+iUJry6Djm/Obc8QZIDsZCwjQAOplpFP3G76H04xPFp3NHSVgImetJR0YHGBoweO8UJRW80I7o4x21C3OM06BqycC8L3u6o9lSEGCuATm1Tb7PdlHlX60XPMJP8soCI/kZOpLv49IRynU6r1HUeL1C+F8NBwPUxLZUPyUDrbFY8EmxqR03lhljWIzAyJXu6jBXyYj8arGSPaK9s4r1VG5cr+JvpDCyZmUFphYQqJCl1BwcLTasVar16OZvG3YbxXjnyGyC4YJ5qGhgJPba5HwMW39K5VZQRfxwDagzWCID+CN5YO5MGNRNtoMOBopyFUy9R2l37tQK3p8YoQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlZkq+7gKqwf1vtCDhm0GJDNCA10nTG6e5Gnd2xZfbs=;
 b=saQ3PcJ97hR4E/7Zl5UKq5ifVtaQMZqdqoySKRaJgOJavB5Ss8/HMFDwUTSn3qHAg3Y3WXNF4fZ+CTlv5WFBCxzHpvzlRnspb+mu1a1+HCT9LcSgrzD/5vB3OwdlobNk3gTk0YjMiFn1UQdMQKLRb5Ad9Hbk/JWHUBscuO3ywp5juTBr82Trk5mw+L8v9z5PKH9l/fYgMrDiCjOCUH14q4RCy0yqJFbKPuqn9zTc6ZCUZayXsxihA5xDnQErNJrVRM5kRc7crCazpsfRW+kPgVRptP7JrZyrQfPpT/RdMNe/VuoeKB5GxwS8ArvTIRQRGHwBW/rksa3tQckWaWoakQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1145.namprd12.prod.outlook.com (2603:10b6:3:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Wed, 7 Apr
 2021 18:05:30 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 18:05:30 +0000
Date:   Wed, 7 Apr 2021 15:05:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH v4 resend 01/23] iidc: Introduce iidc.h
Message-ID: <20210407180529.GA547588@nvidia.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
 <20210407001502.1890-2-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407001502.1890-2-shiraz.saleem@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0060.namprd15.prod.outlook.com
 (2603:10b6:208:237::29) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0060.namprd15.prod.outlook.com (2603:10b6:208:237::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Wed, 7 Apr 2021 18:05:30 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUCYT-002IfG-20; Wed, 07 Apr 2021 15:05:29 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6969f11f-ae1b-4a87-796c-08d8f9efbaec
X-MS-TrafficTypeDiagnostic: DM5PR12MB1145:
X-Microsoft-Antispam-PRVS: <DM5PR12MB11456A9D212204708DB461D0C2759@DM5PR12MB1145.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gl7HIqZvDhqQIm3WbpsebNlZofaAYv6V3PtOnZSxKNWIyYpvQwjmzO+pJmGo70Q23Cw8hGnX4hZtxtBbaUHjCI+/pHmWBIchWLmKSewlI1iAjeTDOKOsUIufFQqbU50Cudimwpb6S5bahx1Hska+WWexdjd6wNIZgq9uvvBz4Gurjr4Jahdqjpqdy9gVXaiqP/BKuyBz9vItacq9P7zeRkOAtAhL0v1Xfsa7lsYNOFcNH/7q/FsLWLBb5CoBtsqSlfYHUmLA5huZOU8K/Kjv3kJoVDfL/ei44jztzDu3CSXiOBMV8V5CD5NDhak3bMgiaGBcVaGHn50B3N1h++LRtg2QTOjAF7WJXXgF6d0NsV9PEMQ6l7BpHRqDdrTZ8CkF0dzFBeDANdwESSPXvHV/tSHYgusuyZKYws41X4VN1w7sKjC80teOlhxZFyw76OZuCJn3G5Yoifh2QTv81ZX87UlSNTnmw0+5rWjSvup+L6AU3lEhFtSahqPwsu50ZP5+vScbTqOIgqp8R+JzHU1C+yWjJKyD2g8S/ER/66edmk87XztJCfqUwjEUTAqwvRICA6hsHlOqEUyt5YgXAGQTMgBuSaVcD5bB0caogendP3AVgvGvF1jJQ7cicMWViL2AoAjAl4CmtdeBzMx895QK0RDDIgYvSScdrB53lvElVPr3YXmdfEepltH+fw0WGcnF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(2616005)(33656002)(4326008)(83380400001)(86362001)(36756003)(8936002)(9786002)(9746002)(1076003)(316002)(478600001)(5660300002)(6916009)(66946007)(8676002)(186003)(38100700001)(26005)(2906002)(426003)(66476007)(66556008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?W5+YF+BaAZSbxsuSvP3TLqWfvNmC6Gw9QzZMvEbLwKlTqfv/ba3qbyIHC1zm?=
 =?us-ascii?Q?pFvQcnsPrQp8dkNfswKXbqBPWno4pzfMbMAyLAuKCn8yKQjuAbc7FvFu6Vpu?=
 =?us-ascii?Q?ZB8it0VxegrU+4gARkmRiI0/K8uMXprTCzFretsFcyacPJRO9dPenAQTG7UA?=
 =?us-ascii?Q?EgGSUrcRsEYxhEglZaw4MgyIqgucjyIkPaEcESBURGHIJxOPwyB8/eKfzSem?=
 =?us-ascii?Q?G/552g2PxIYBwKoXLxpkhMiuZcQT4PndauscOB0YFQZvUZPX4N9NvG1DqF+s?=
 =?us-ascii?Q?90U59WKfIyRELUA2JmDpuiIU3uYYc9NoCcceHrLN/iXMX69j9P+Cfh3rXeAG?=
 =?us-ascii?Q?mf9FViLAoIEBIQBk+BQ1B90pLrOi5D3j3QRR3WP4mHnfBhSlFHO+ftas7pAU?=
 =?us-ascii?Q?1w5fJds7epuLL7dPrN3ongMSVcHmKwljO3kEBc4+yVimLd/UdAoFwE4FhPi5?=
 =?us-ascii?Q?thA/n2LjeNwV/oZJwsRnDdoXtPUNCoXzle+81kEQBTEtM8nWbvYaY+SUPNzZ?=
 =?us-ascii?Q?GnhcF37UNclXndiq0KBUqxN0yYJlN4YJTEeqybWVbRoWW4w2tePsq5MKSQP+?=
 =?us-ascii?Q?sPG/qu/nDindwqIwhreBMcce2LQqplpkDyvFpH/46uvemT8TUyqqxphi+X0D?=
 =?us-ascii?Q?FdTPK3vPA4w3sxbsT7BTMi9Mcnnaw6WdNeIV+BJ33ytW8ckbLac5gwFkY+2m?=
 =?us-ascii?Q?/nJ5JZnbzXd0z10oEO1idBJOlQI3Q/SRJUsPA8A8VexcQxZ1Inz+/VwY9y+l?=
 =?us-ascii?Q?0/WfvSjAkVd3YBRt9E+Gbe1CLT0zg3iSIfr6e4zBU6VTKstKqHfcGYXbkmIE?=
 =?us-ascii?Q?8MWlhTE8sSxRz7PwyinFlKNsk786L2/dhwbTeOmmNkbxjr+qediDXMs+HDtM?=
 =?us-ascii?Q?neAtgV0HuawFzHjLspCICWIDXTFOop7GGdFhLmQjyxHjqdSn0VmDn8bb+1M4?=
 =?us-ascii?Q?Y7E+ZJWtMCX7F6dFKZ4vhNSdIY5hCKMtNOBFDLAOdgRDuoTA6x9oB74Ms3k3?=
 =?us-ascii?Q?jFG2hohOxh14N2jRSWOpqGn4bkWuZdpaKoOVh8VV1X25ZIfKhskxFqbTglFe?=
 =?us-ascii?Q?wVYc48ucWi4iILfjPTMVsm4JbEqbBSE4oHO0PwD/+UiPawsepqPtARJ7nJVs?=
 =?us-ascii?Q?beqw04LVCYoQjQZGfNkTxQjWO822MvkyeBgOLSMsd20LAixkQDEFXTgZGq7X?=
 =?us-ascii?Q?GUVSUQuNHf2xFBh9y0hrhlqvdQzGYUMn07t0wmIkKrG+XbhBvMNRZmDk6a4c?=
 =?us-ascii?Q?M6RnZ1HTAwtoVtplepFpQB816FkznIBHTqas1GV8Gav6kkD5BTt3NqkCd4nw?=
 =?us-ascii?Q?J9I/KZzKodoaf6lf9ykK0QPZXnDq5j13e4jsxucg26jVkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6969f11f-ae1b-4a87-796c-08d8f9efbaec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 18:05:30.3483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3bBcqZy6LXNCgALySdIi1hZ1Bl4hs0boqDKXRjvcXeUB+aejjCvgeGQlokXIlbK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 07:14:40PM -0500, Shiraz Saleem wrote:
> +/* Structure representing auxiliary driver tailored information about the core
> + * PCI dev, each auxiliary driver using the IIDC interface will have an
> + * instance of this struct dedicated to it.
> + */
> +struct iidc_core_dev_info {
> +	struct pci_dev *pdev; /* PCI device of corresponding to main function */
> +	struct auxiliary_device *adev;
> +	/* KVA / Linear address corresponding to BAR0 of underlying
> +	 * pci_device.
> +	 */
> +	u8 __iomem *hw_addr;
> +	int cdev_info_id;
> +
> +	u8 ftype;	/* PF(false) or VF (true) */

Where is ftype initialized?

> +	u16 vport_id;
> +	enum iidc_rdma_protocol rdma_protocol;

This duplicates the aux device name, not really sure why it is
needed. One user just uses it to make the string, the rest is
entangled with the devlink and doesn't need to be stored here.

> +	struct iidc_qos_params qos_info;
> +	struct net_device *netdev;
> +
> +	struct msix_entry *msix_entries;
> +	u16 msix_count; /* How many vectors are reserved for this device */
> +
> +	/* Following struct contains function pointers to be initialized
> +	 * by core PCI driver and called by auxiliary driver
> +	 */
> +	const struct iidc_core_ops *ops;
> +};

I spent a while trying to understand this struct and why it exists
and..

> +
> +struct iidc_auxiliary_dev {
> +	struct auxiliary_device adev;
> +	struct iidc_core_dev_info *cdev_info;

This cdev_info should just be a 'struct ice_pf *' and the "struct
iidc_core_dev_info" should be deleted entirely. You'll notice this
ends up looking nearly exactly like mlx5 does after this.

You can see it clearly based on how this gets initialized:

		cdev_info->pdev = pf->pdev;
		cdev_info->hw_addr = (u8 __iomem *)pf->hw.hw_addr;

                struct ice_vsi *vsi = ice_get_main_vsi(pf);
		cdev_info->vport_id = vsi->vsi_num;
		cdev_info->netdev = vsi->netdev;
		cdev_info->msix_count = pf->num_rdma_msix;
		cdev_info->msix_entries = &pf->msix_entries[pf->rdma_base_vector];

		ice_setup_dcb_qos_info(pf, cdev_info->qos_info);

Since the main place this cdev_info appears is in the ops API between
the two modules, it looks to me like this is being designed in this
obfuscated way to try and create a stable ABI between two modules.

Remove all the stable module ABI hackery before you resend it.

Jason
