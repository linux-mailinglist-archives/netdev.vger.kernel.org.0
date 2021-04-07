Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36B3357368
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 19:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348076AbhDGRph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 13:45:37 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:36000
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230073AbhDGRpg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 13:45:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/wQmVV+ZQG2m1HBxUqTh6cBX0fvTLldtF1HNohule7y6BE38kP36nGLFnXaH/YlP+FcNDf1fB3/IkZW+BxNz6YsO60+3tTyE1FBynElHnmhmMOlRFe9eF9zEwEkevERY7jh7wh4srLImrSRmla3J4GJMBEsOEF5rc9qavegJDMFj0bsor9+bl6nlID5KKnOQC91cLUOxIUn6YyjfWKv+M2BJvTMpsQRThRtEhuTYdpQVw8LBeRSabIQ/plfn/8BmiEyKuVRNdO8x4BZ79x5TBeb70LSrKH3wk6vD3ABAG7OfIT4eqjCCsBi1qJylfoV0WKoRiumTGO91/znxkFqyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcFmeTx628ADx2e1FTHIh/gVJl4uZEeYPlfbg6Iyj+w=;
 b=L8QYdNN3N7kopP+OYjN4VK5MkP2OSUR6HVbQe6lvgEOBOqEI4bpn1rSPWsrmyQl7faya/TkgduuOACCqrMCQ9Hrg9jGuLF30MdwyOvqp+YA7kIKglv9bQzmpruE9FBqogsxwzlIQJO1EgoMNrJ7eMN5ipyZmRzgsb5cY4U4J2loCuz2o8mD/yzAdtidBYXkRCzWHXIzEtPOge8ImOFFhMuZ3ZGjlvvo7nIysXf+RH0fVffj0ILZGfkhfWLDBtUkMwHgiSpNgblNG+5uiWtRW8YJMewHVxUIUIECs/VLIXs1/5nk/9gU8JC9t0WT/f29J0TN3UtbZsC2yh0YsKDI5DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcFmeTx628ADx2e1FTHIh/gVJl4uZEeYPlfbg6Iyj+w=;
 b=l8JYvrWIrGEQzm5WXjP/owVBNEcP63/HQLyyQPC0pubjgYDjpVq8FB6z3Hx+FCx1SbjBLCiCwUUh2SZ8S1eVKtbb02o49aBPGjKti0eSISpRKuohP5TnuS1Vhus/VPlu9G4DGs2fmS0lrgdEh8e+qx3ZezmdSiMRTfSMfBhg0HKYCmrPCJZxZDsk/kQJMRqlHhvVjh1aLinrM1CZtl4L36tCbCd0VHr7OxXUOIfFjs5tMWzXc6b7VdpPG5lo4zD1/OD+Yr1e4Htin1L/NEevlQyMKog5wkc1atDy+GFWIt4iEE8hD4ecbdVV2k8SkzBF/4a7nVOCQJpNhEITWJB5zw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Wed, 7 Apr
 2021 17:45:23 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 17:45:23 +0000
Date:   Wed, 7 Apr 2021 14:45:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH v4 resend 04/23] ice: Register auxiliary device to
 provide RDMA
Message-ID: <20210407174521.GA542400@nvidia.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
 <20210407001502.1890-5-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407001502.1890-5-shiraz.saleem@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:2d::36) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR03CA0023.namprd03.prod.outlook.com (2603:10b6:208:2d::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 17:45:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUCEz-002HGy-3T; Wed, 07 Apr 2021 14:45:21 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 124cc151-14ec-4d5c-00d8-08d8f9eceb4c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4057:
X-Microsoft-Antispam-PRVS: <DM6PR12MB40570DEA0B1770A1AD46A23AC2759@DM6PR12MB4057.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9a5JBbxTHmOYOpwGtIFGaJl4yoOtzovm9WPPORF2srDHV3keUV40ZT9B+Vv6Ryu5deumn8Umfr4rRTCbLI1UXF11MYFc6bbnh8RatcPExKJTEzNl8f0Qahds7MxefDdN62cnCvxNwjhSVI4Oqn5kW4U0mD928pvPDZHjaZxkcjwQVGd9wTIdoAk9VxEUeEajKgy6i8KNd0u3O5brFNiF7SDL39n+ATKZzY87nU9PzAo4CbUntax/a8ZKKppiPZ4/XGOXHEsWYoGKB3wlH25VfkK7RXyi5uJUu5BYlgPKz43xeHiIpTFWfVy6M66Pel2HzOPJhlPISFdSzhhNfwteJCzRHxI3xCoE9IwQhV4Vf9/KAWA/k+5nBGdW7TLwkk7mhgX50GW99yFGB3dhKMUmqLaoglwgxLkdI0jouS7yVFnWwUdA6Fzp/E5i27kWiS7L1xPbpXkwlIpCGUUCY966jdEr7gQ9o7ZVopGSmbqN7gh0FY6Cvf3W5eZRKn9ciZGZ4tYZZuTgWLiXSlgnhcPXIoJw8ad0pG7d5vdzwaQ/zunWrDMgecS1ra3YoLklWVPG5swRxOac7fB+P7qCyeRpzIuzAEI6KXxNU8eXOA8jjKw+pP1KQecihhGfeiQIgJ8axVokR6b3EOIkcfvJ/hVbIAp8JroZqSvw+WbNsCpR/bpo7EqQeojk/LTpgiXwv6iR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(4326008)(33656002)(36756003)(8936002)(2906002)(5660300002)(38100700001)(6916009)(8676002)(66476007)(478600001)(66556008)(9786002)(9746002)(66946007)(1076003)(86362001)(316002)(426003)(186003)(26005)(2616005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Fw/vy7TKDjk9DzoXuf/Y4MEctR4F4Q4O4m/05B+WYDN6N4I7QpzAtnK1xwQU?=
 =?us-ascii?Q?Qi/IsN3EL741Q+UYayyxn67VrlXOuMNEnkk9dkDStab+ME4vy4TVYmSdh2or?=
 =?us-ascii?Q?NH6wfvhDANhEq1AtUlQeOTHrecxyHHSuL4LR+Yg+uY9dD3fEFisOjpjXNLg7?=
 =?us-ascii?Q?n3cryJVsDlgwp1JX5y4DOPEEnnDUl4pUm4DNFvjwBNFNPgFPMCedDagqZUJK?=
 =?us-ascii?Q?L7Q/lg4mNP4XcvlAHBi9hIU8HKh7FRzRomQ5L8UAFNM4XgYEdh6XeW4W2ZJo?=
 =?us-ascii?Q?rM177KuQ1/aV2+DxWfs+jXjkXH03n5XLDu1D5ZjMlxkQhMYINX8/f7xWna7O?=
 =?us-ascii?Q?ViuROnm3iDR7yxuMCh91e3VZR+618Q+uSclQvwg3M7fyySGmJGuwQx61FWB8?=
 =?us-ascii?Q?jx5ZkwX4iJWpyluN3BqosDpr+d7mtxZT9B/zHb0VInpweUaLYf+3sIQa0dDl?=
 =?us-ascii?Q?0XpH3fHBpngukbucXt5eIp24E83IIuJhSjagjPZ7kPeXpLacLS0PcvpqOoSk?=
 =?us-ascii?Q?AW/hk7ddA+BaT4de4XtTI8AE6D9OlBbT3j/WkXZrn+wLmLcpf0PZtRtp1c96?=
 =?us-ascii?Q?YmO9sRbulyoBKo4VHnG517wqWrpQHfrzibM8cGs8HJj6XyWSLZw05PqIYO22?=
 =?us-ascii?Q?jGuem2dI8oeRWyN6xIDUQPu0yVToQEg4CimdtF1zvNcLIppvQmH/w3VwVEWd?=
 =?us-ascii?Q?lZFNeAqXRCvj3pxKOwETRn7OHkAxecT/Ct9qivugyI+Bfd6Dv2pX2O1uRv6F?=
 =?us-ascii?Q?+1rTQH6dL0EEZQadX/tkIBg/Gi0KeEtIPmnkwd0hqA8W97lJVJp4xQm0ql3V?=
 =?us-ascii?Q?vl9GWnpC+T7RPDtGStuaYbxM2tSFK1Ua6nu7UhDig7CTbVSekDzm6RRz3MlH?=
 =?us-ascii?Q?n0hLOLtuZG72gch70X7f1kRazfXR2HJ5rkbtimqrKNKimD4y+AfRofm9R8am?=
 =?us-ascii?Q?ARuGSSJZTcyJaf9qrK5aj+v5qLSNHkoP8pc9bKRw+LtM0a9G0k0QVc8vwrme?=
 =?us-ascii?Q?FMd7Wbuu3mCpKXezCvJUs9D+7+aoVbyFJMqAkaIlSepSGkCNFKd2f0s2kvcl?=
 =?us-ascii?Q?GeOsL06sEklGM66mTIDT9KJbPiqTSnvw8Eklri6VaF+gCxtHu+NkTxRZYCoy?=
 =?us-ascii?Q?6y8yqCFDkamcVuVWj84T7mD0Ej4WN/9QUdyYPtGfAfjSFSsmwF2I8RRB4oQ3?=
 =?us-ascii?Q?hhTt2DsU1kA38THQJPwT6qp0HDC+ne64eCUw6KJah6FFAEdkzAgGga1Gz9uf?=
 =?us-ascii?Q?7zCpiZ+BBQzENJYEJ+QdrkLy/opQbi7OEGVP/0vKTAlbmEWg72OjrnSdOOD0?=
 =?us-ascii?Q?D3MIchSHIf0RgRMsLAyV3xZuPAITTAYOWidTcIRh5MFS0A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 124cc151-14ec-4d5c-00d8-08d8f9eceb4c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 17:45:23.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tqeu54cVC5JewJb2KardGjJCUWhgN6DtaeGN/0J+B7dizo4V37FnMGmM+vQ7ZDqF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 07:14:43PM -0500, Shiraz Saleem wrote:
> +/**
> + * ice_plug_aux_devs - allocate and register one AUX dev per cdev_info in PF
> + * @pf: pointer to PF struct
> + */
> +int ice_plug_aux_devs(struct ice_pf *pf)
> +{
> +	struct iidc_auxiliary_dev *iadev;
> +	int ret, i;
> +
> +	if (!pf->cdev_infos)
> +		return 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(ice_cdev_ids); i++) {
> +		struct iidc_core_dev_info *cdev_info;
> +		struct auxiliary_device *adev;
> +
> +		cdev_info = pf->cdev_infos[i];
> +		if (!cdev_info)
> +			continue;
> +
> +		iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
> +		if (!iadev)
> +			return -ENOMEM;
> +
> +		adev = &iadev->adev;
> +		cdev_info->adev = adev;
> +		iadev->cdev_info = cdev_info;
> +
> +		if (ice_cdev_ids[i].id == IIDC_RDMA_ID) {
> +			if (cdev_info->rdma_protocol ==
> +			    IIDC_RDMA_PROTOCOL_IWARP)
> +				adev->name = kasprintf(GFP_KERNEL, "%s_%s",
> +						       ice_cdev_ids[i].name,
> +						       "iwarp");
> +			else
> +				adev->name = kasprintf(GFP_KERNEL, "%s_%s",
> +						       ice_cdev_ids[i].name,
> +						       "roce");
> +		} else {
> +			adev->name = kasprintf(GFP_KERNEL, "%s",
> +					       ice_cdev_ids[i].name);

This never happens, it is dead code, right?

> +		}

This is all confused, the adev->name is supposed to be a compile time
constant, this not be allocating memory and combining the constant
"intel_rdma" and the trailing "iwarp" "roce"

Just use the proper define right here.

Also all these kasprintfs should have their errors checked, which is
also why it shouldn't be written like this.

Jason
