Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E40A42C856
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 20:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbhJMSJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 14:09:00 -0400
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:17760
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229814AbhJMSI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 14:08:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miWZhCNAKQGYkEDU0yVrZkUYNA4mhfI1ALiPwK7yNGrHHvxSYyARHv21NIzi2ZTdU/4vKOBkQXvxKdXtZnCeTjQHvgOfijG77efY6DkOwYmyEqqAjZIK1J0rx3qLZVBmK/QS7Sonmn49OxjW3ybw+KDO+ao/uZvXmkVK96CLseuUqypf2rplsbevgh8FEWgA1EPGS86lnsBhZSHfUfELTvOWNZOyEXAuIdDL9qlXVzvnkhvu2olojzcqLel7Q06oeOC0jhsIJxC0bJljcDptqAyUx+XGS6tgsT6AeXSuZB0YyTu9qqln4SRJ/eNwsEXiwd74rNidkmEefwBQRTcCdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6yOPD5MSOO5uGJ0sLl/wr/y0gfSWT6BMuq1oZERb/M=;
 b=PNhyV1t/Rq/Sem6awmWSRylpqzc88fJ0onXVa5njKA6f5OsJwo9nJPWXrFny1NSFr3ceRIwmOmoBn9wshAZS7Ri7TxybLIMVH54xjJaO76GFJeonphhY0bY3DT18ZD3CTwEdfEh9p/Bflp0KMcsJH/oPbVlQ6EkGcL2jDg2sYsoFFwrI/2NhbuxYJZWGVEnNgWn1pYkdZcsijxyVMVJiQfAacccSfSySF9algs3AnVLxjYWh28p6LKbpjAHftWEvFl5SK7+YIiCH+tQitsAmA5yUMOsN99oAEjux8pr/drxqLMYfamElNSi2mcrZrg/eY/hE2VBBPSi7z1WAjxbWXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6yOPD5MSOO5uGJ0sLl/wr/y0gfSWT6BMuq1oZERb/M=;
 b=DryNIiLD/YcRVbfBqjmpJHD13iVqO0IZcdr7hr7HZ3V8mNvJourA51xkJNQ3OPhyLvQFSjKyFQgwzOg9AbSLscTWYg6hLc60UTzn3ngFvLWA/AcrZXvHzSRXMhhJ0eW7BvKcyqEYhKVsaKxgE0flXAlnG9r2rKgVGH/wfNxgg6BnLYjOjxmnyad4kwerYNYY+QRKAjnB7fypM+cKVgijxi7DD/S2BxS1fCepE0Iw/6v22lorDpAeHC2E/5LAHaNto6Mwl45R8lvPeR85Z7TT9XZlfk/E+58KNB+p8YEdVPCHYN1oDXPTDRLhC77gqAzBU2V78jle7ivQCgkHSsT9wg==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5239.namprd12.prod.outlook.com (2603:10b6:208:315::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 18:06:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 18:06:52 +0000
Date:   Wed, 13 Oct 2021 15:06:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, bhelgaas@google.com, saeedm@nvidia.com,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 13/13] vfio/mlx5: Trap device RESET and
 update state accordingly
Message-ID: <20211013180651.GM2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-14-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013094707.163054-14-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:236::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0047.namprd05.prod.outlook.com (2603:10b6:208:236::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend Transport; Wed, 13 Oct 2021 18:06:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1maieR-00EcUG-Fb; Wed, 13 Oct 2021 15:06:51 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4883f0db-9364-4c38-d748-08d98e743be4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5239BCBDF5642C0E37342D34C2B79@BL1PR12MB5239.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E/H9HZqWh7RYFtIJ5H+y4kDi6B4HlaNZKMz01nxp4q1+g+FPtOzy22lD5W5OV1bwQPjmHKV7VaA3U/XWUoAhZkF2JDkdQBWaeAt0F4KGM5zi6OEJxqLjCS0ucev/chHPbjN53/1bXwqJifaxCwjbkkSjPB2bpflNt4oGALv/M2BP3rpZBwOCyBRlWhSbITOCr3I4FE5yZSQ7aTwfhdaMTD6pKgUHfZAj+pZ7jV0aqcKyJoGOoVTXP862fnfr0nGA40M0O0HBaSaNETBzi6Ae2nJSuIVJZfMgqXxx8wGk27T9dTNkV/vxrOkPyOTpTm9QvxWr4uq7dTUvfYN5DVOnUsWp+oOPbWMdkiic8pQFi5OQeBJiyySfaiw+0g5uUaINLhUwwaPDtWzH+bhbxEAtwuCMlf7q9LXFzGruLaxArirWB1HMESCU7gB6dwgSpmKFJSK+7qfrpqtLFMF27XTTr7hi8SJ2NtzTcKHEqFwhYjJYnfotPY5wFrPgfyTm6vrO4Wyf3IfBHVBEYN86obQTVvsNpqZpyJwn6nWB5AoJgHNWAyEBfg/QF1Nbf4O4+8VN54fuhj7YS2jSkZ7wJLB3IQskJ6xd9curE74JpiR98CeXp5IJjXGezIG7DK5X2/T0WFZZiiQJc15jhHZMWCL+uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(26005)(37006003)(8936002)(33656002)(9786002)(9746002)(2616005)(1076003)(4744005)(86362001)(186003)(316002)(6636002)(36756003)(15650500001)(508600001)(66476007)(66946007)(38100700002)(66556008)(8676002)(4326008)(6862004)(5660300002)(2906002)(426003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZMYHJ41tWNz4AynwzwT/3JRnktL9Crzz/oNittcESBJdAw2CVCiIsuD1UMb?=
 =?us-ascii?Q?EQ3txFQzMpy0JU5csvV57Ct0b3af2UBTA5OAtaFDYJjeY+HDKhMW+4VcXWJ8?=
 =?us-ascii?Q?vA5DmowLHltUdtSzLlBoW/tgMINvc70gMUsRoT8QEFCqLnTR58VKfVN+4PF8?=
 =?us-ascii?Q?HznGUYrKd5qkvnpG4p5Anowabsmc5f7exzzyev8siB8jTS7hKaHBTV69f0iR?=
 =?us-ascii?Q?UtxlEwpBVDV7bVvzAtrwzE372MXgocKgurinTF9xIKlAQ+E+IhA+OEIfmtEu?=
 =?us-ascii?Q?AoxIB5PV2JKy1+KdAx3YDqC/yYjKjbaBVUNoAkUMYmXuYiMKdwHDm8Z5pK04?=
 =?us-ascii?Q?PT3YsqEzxciMJo21NtLQa636bManw/sQ5OfeG/XEhOnm3dBmAxlcibWo2Gwy?=
 =?us-ascii?Q?PQhT/l3+gwZ9UvlUAqk/702RkdgB5g99lut918xhoEro64er3+uTGuzRN6Yx?=
 =?us-ascii?Q?RFP0ydF5DaOPcTuLg4ElRFdxbFPB8y8jb5yiqlzJ1tMg/M/im1BIfHvafsUT?=
 =?us-ascii?Q?0AR+E8u9Iz7mufORLt/3zy8WMBQ97iVLZMYsBENS9UfqnoWFQRF2iP6RLsmt?=
 =?us-ascii?Q?Xksp0HepwNO9aO+9I22GoIl82ufcOowp5Ajiz/Z64t4X+0KZIpAMghtrw9Xu?=
 =?us-ascii?Q?CSR3D/BF/6XplSZCAfolxZb5nkZ2wEVOtl2d40NuvJQBb+V/6sI4cQ84/V3G?=
 =?us-ascii?Q?aq6ukKsU5COnZRTiqS3bREHgVJsIbEC9d8eVKo+t4kWJKFI+R23G7VS2BWdv?=
 =?us-ascii?Q?rNYGkVp8lDezAM3j+klctVfyyifkCCjBovw4LExcvDL1qrOc/elec4FCrOO1?=
 =?us-ascii?Q?preOJce5B41JifvCPL5pdmcjs2MNyrHYCVlNPVAkd0rn2Xx6Y0XdjT51Mkon?=
 =?us-ascii?Q?ZOeo1tVoMAeHDnSMEgXv4UTyPqBOTz3ngC09p/z2WGaayU9eT6j+1G+Pbbak?=
 =?us-ascii?Q?L4tyEE1PoTlvT3+1q7/mu1WawBydsfNZszJm8gOMfjjz9O+96qB2Cad0sK3b?=
 =?us-ascii?Q?shaol4H1IPxMdBxgHU79oupRhJJInRmaWeYHAUUDb+mWdWdEXWseMZ01fSmj?=
 =?us-ascii?Q?dY+DU3oCHXRJFs66QXYuKSkc8T2Am023WbP+ZYbBN4vfamiM/4hBz8TqMq/t?=
 =?us-ascii?Q?LlrHLXXbbQ04BJgRgpdp85IaaIc+ohyyDP1ZzrU9c+66OpSkcx2S9f7AyQ5Q?=
 =?us-ascii?Q?2eu+v+MMvRXyGGY/qS8BHHzZPBWKHacseNMtEVGV5JPqwwoHlw9tgudphXt+?=
 =?us-ascii?Q?1t0QhCtCphuzg4tLAKvmPld62ietJUd1DRVoIYrOGXGXWf2LAIdl7i9LpiTS?=
 =?us-ascii?Q?ZslcmbUVkp47hqvRKAz4mIeDSrUi0RwRSVlSn+BDGVogbw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4883f0db-9364-4c38-d748-08d98e743be4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 18:06:52.3512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWpcrWM34DbcoN0qVAAuLMW7ANAuRNGkVGogOzidXiXSOQTqrhlh4QCyoTeiwttL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 12:47:07PM +0300, Yishai Hadas wrote:
> Trap device RESET and update state accordingly, it's done by registering
> the matching callbacks.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>  drivers/vfio/pci/mlx5/main.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index e36302b444a6..8fe44ed13552 100644
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -613,6 +613,19 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
>  	.match = vfio_pci_core_match,
>  };
>  
> +static void mlx5vf_reset_done(struct vfio_pci_core_device *core_vdev)
> +{
> +	struct mlx5vf_pci_core_device *mvdev = container_of(
> +			core_vdev, struct mlx5vf_pci_core_device,
> +			core_device);
> +
> +	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;

This should hold the state mutex too

Jason
