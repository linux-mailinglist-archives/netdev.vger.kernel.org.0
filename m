Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA834B8766
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 13:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiBPML7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 07:11:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiBPML6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 07:11:58 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08925205FD;
        Wed, 16 Feb 2022 04:11:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMV3oXLxaWwEtX5Svkcbmu1SgU7kkgdLvGwHA4xlI3PNsBtQsG0rIo4NrwAZF6JD8/PA9P7xtYyaRnCDXZN+uwilsXMmOmc2eDpumgyljY7yCPG2vdibNN++rL6W8UvIHz/qvb6JoP4KosxTxWOWrFNnPjfO5xb/PQQNg6CKfbgiwYBhMUkXvcbYcpi/FFanZ6LZsjHOmNcYzycY+ETrfn0IvXJjIZ7VCv6x0wxNx5NBB89zsyl593Y7Y09RleEWnHF0g8Pjl9Hf+E+9O/qUjuDGOWGm2RUtUwfrnE1+BFYQ2e28Zk4l1PWAWh7AX543lOwUh50uQzz3dk6mpKhgig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZ76qCaSYVcDl0JcEoEO1PEu1phAxFknzVxhxrhslUU=;
 b=I01IcYXcD97OICz0SfL/unIW3bt21mnn/U8ovMragKBp6Av+CCAAUH78zULSLNcCXFUV3N6KHrHrpt93s+5jgNQVdIqOSmCEUVdq0cL5QWvJCM+VErUb3BRSvAXwNoSfPjgRgGIb0kjjb5qvd4Q9FObFarA3helPQxANppjgPEai1xHFxImUIL4kNso5EEty1VFNbpaBgXnVhky5a/xEYwhtU9XdDljp4lRWuOBYhTUlankoF8zgHPKmF8hrI/AaXJnA8WQ65KLM+FBu+5qtqBW6T8waxV3RVWSiaWBfI0rp6P7Nt6im0BOfmz7i9sB+s3W6Y72KamdKKgIwJKfRvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZ76qCaSYVcDl0JcEoEO1PEu1phAxFknzVxhxrhslUU=;
 b=F5lmbPe7ENKlUyILRDlIfZA+eN4p6Ge2r7w1J+dM0IOwtjcpjV1q5p+Dswqbp62Zgn3s/fbj3k6ycMLhPiS//JCzCIKn1hqHQAVCE4SpokHsQldXwDKp14pjaMWhkG0Aul5BlLPwN4Gr9Mmqsuq8ZvTHzL55+00A1I4eXL8BHTR96XVkBCI7PsgEAcY+mqfESuSfaJwarAxSYUitk0BX/02RVdEEHy3JVZZiNRTaBwKXtJPlhLt/heVfKj2EX6jxAXu3b1pdyLhrWv2fYy66XObu0pBq4qhe46TXS8J7sWDXrvVHTQWE2wHUkE+1AeRdbhEfRcwqUTLZ/0Snel9K6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1256.namprd12.prod.outlook.com (2603:10b6:903:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 12:11:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 12:11:41 +0000
Date:   Wed, 16 Feb 2022 08:11:40 -0400
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
Subject: Re: [PATCH V7 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220216121140.GE4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-10-yishaih@nvidia.com>
 <BN9PR11MB5276D169554630B8345DB7598C349@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220215155602.GB1046125@nvidia.com>
 <BN9PR11MB5276BED0FC008B974B8750058C359@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BED0FC008B974B8750058C359@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:2d::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 105ee6e7-f00a-49dc-7471-08d9f1457d88
X-MS-TrafficTypeDiagnostic: CY4PR12MB1256:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1256A43279E6C76FDBA14686C2359@CY4PR12MB1256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGfCJxP9cCCfbiqvdr76Rx5mAKEMwfmdDqSvVjf6afAG4vlTK6rwn3CL+YeBRqyX5LzaH4d3X5pE8Aj8z9/8U2eX7xgS1s/2D6CXuoDXUlDrfFF5QW+tkiCzfnYbEc8DqvmWol4uZAnSSF/7LUV+QS4X/n31Ekm5zvcHgqTt0piQ8yUri4By4bj/PDo2UUWZ81OtucC1KztU+w0tMIGAukvSMjdPzo8GGIv1KismGTnRTBgLVx00vL5cy3gBb9xWrMqTaIxb6hI84HYeRwhkuFlGyQN825gZYPcPB3DYUNY7EPvaX8pM9xq68JJARrykfUu2XRgzUS5NEvaomt9JTV+iqLWmXPwkqtzAwuPQfzzjPstXWvcsIk5kXOY4sjWAP1dp0GB+2dGLKQr+3DXTM5LfFfniRPx2MNZeNtT5EbqAmhbuW9DZEYaDKDKBwusW3kuebJ+Wlg/Dao0T3dQGWxFklsXvUavuczLtoayn98n26xquyCXzSesoTG88zc6anlmFdHGqGD+d4zwdw1qt9qzgvgH9ZFwL9+EUEa+nD0H8nWPOP0cpVYjfoZLrAshEcCvdhs7YZmQ5q/ukAYLMb6VIeijmwx8FgfF+/6nm/GCHCo/mrGT14V9RLofllUydQM1vmEDA1a4SGDIqXIsaXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(4326008)(8676002)(8936002)(66556008)(66476007)(5660300002)(66946007)(2906002)(4744005)(316002)(6506007)(6512007)(1076003)(26005)(186003)(2616005)(6486002)(6916009)(54906003)(508600001)(33656002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cz9QqMIphSkYtAGa0DoCy2eAhnC6BL24uwOqMNpiohGjLSNYlqD0qzBJCM48?=
 =?us-ascii?Q?uhUmSW/4WU2isPjMVp0ep/l1veYh0lRMemBJOitlBA47R87JN79arJnHCPio?=
 =?us-ascii?Q?kHuw+grN4NfrvUpl18FsRqmFP55fQQ6kxdCyzuNCK58AMjVNEaGP8+sCD1Q2?=
 =?us-ascii?Q?6dk7w0CLFMV08fndi4WpA8OK33BvdtYx2Hta8C+eAQ95P/dRq551IupJbZNf?=
 =?us-ascii?Q?O0mIWwnUv47efGrdsu20hXzqMHKxOa+yZHu15Z5OZVo6XZLzq4ldGJkRJvgV?=
 =?us-ascii?Q?Q0VYYkf057oiCnJ84qSCgikWFbFlnGQzXANIwBEpYWuo2aQBN7zGT71yA6+r?=
 =?us-ascii?Q?2L6l1I8RNCzheDdTLRSHWIB5+7NhwNiILKdf45MFaMtYuJspX0jeSjXTei8x?=
 =?us-ascii?Q?0KEliJ9srRBSk5oNUZCU6CVv4N9bsNzPUmgWOeeG3N5ea/TighkXVBDTRhJh?=
 =?us-ascii?Q?9p3O3TzuC3jO5C33gS/vSI3KQUcGTvUb38UL6puuPVmXmdU5/ptpsGOVfglS?=
 =?us-ascii?Q?J+bTnN66eF2abM4JRjLzWjwApgp33Z/xaCuyYllooo7bGsCruXCjYu6I4C1u?=
 =?us-ascii?Q?jUAVWhI4lvaStPUaB0hLlZDcchrRj1mdXT1/3r7c5xJ4/4JqGuwMEaGx8/oo?=
 =?us-ascii?Q?7Bve6OHmhe1EvtPPN6ox8foY3KGuZJaMZ/v4dDAExB5pXQRcepNBKMQXD+XC?=
 =?us-ascii?Q?DaRi4++3tfC0cm3D0DVkX95PnFtj/tkMoZWp5aYoougl/jJ6XBPYK0oEp73W?=
 =?us-ascii?Q?VXi7lMutu/mjyz6PeVR+PM7gvU+ZdMR9RlkyjixG0J4ZgSV0+k/DvmmodAXl?=
 =?us-ascii?Q?4jQ9bujtDVTMPcJXUdpdlmzsbkcziReG1Q5k+UJC49ckTT1kHOh4PJQH85ER?=
 =?us-ascii?Q?7gdmjpMQZCQ40do4UQ/pVItwkgQfKVyNGF7keih9jr5IXBgQ3qJtWjPC88it?=
 =?us-ascii?Q?l9OenQw9GtmMbfGP1WL2k35oE3IOm0F4QuKi6JeRwcDgMAD9fn9yWHWjxWH0?=
 =?us-ascii?Q?EMQbrljsf6usqngWy0CnXHwsz30HAFvx0Lz2lemiGCXwFwjM65g73oC7/fGI?=
 =?us-ascii?Q?ap0wx2QkJKnKoT2qj+hKk6ZqSaEtUaoPCyKjEy/B3hBzWt5lSVgmZW2l9sSl?=
 =?us-ascii?Q?qpa6pUKKYrIPaQiFX5SAP3RyBMeUmnu6jyRX+lMa0AW7Ot38AFbxkM0GeNXj?=
 =?us-ascii?Q?ET+aqFN7bMa8lWStWTzhHa6Ag3AcuuldVzeo0kzeyEAy3HYsXSkSxWhOqVtx?=
 =?us-ascii?Q?HQDqxgZvcqyRUCdJ+XhpMRIEtRzpTamCWEc3UVLzH0m7sgWwvWUrBKrRR+VL?=
 =?us-ascii?Q?guGJdpoyH10bHMhtOPqQXXWdaLLw1kdtbJGM4oAABPhnwB4bMBSsCGNfhKYr?=
 =?us-ascii?Q?90gu/FgPcfqFHM7oGQGcpfR7BqwkA4io3xb7QmCrjyZD/3YYgMY8pv/Jp1v3?=
 =?us-ascii?Q?aEjKU5DG5R9cWszIqteHmgUEQbVXAaKiOSOJn1vflbI1kEH4bZpGdmau8Hzs?=
 =?us-ascii?Q?JXgLlfdIopYkvOBbFqXMaSSi3G1qe2eePoMEojS2LbXu6DHVf7EuxgmLMs3V?=
 =?us-ascii?Q?jareBeoD//3jyfESZbM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 105ee6e7-f00a-49dc-7471-08d9f1457d88
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 12:11:41.4673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rFSs9hxWUYlqvv8oHmvZkiBBO2jkkEuwLZUX6Ot4vhmc70t5Hk68T5V6svhogMPr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1256
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 02:52:55AM +0000, Tian, Kevin wrote:

> btw can disabling PCI bus master be a general means for devices which
> don't have a way of blocking P2P to implement RUNNING_P2P? 

I think if it works for a specific device then that device's driver
can use it.

I wouldn't make something general, too likely a device will blow up if
you do this to it.

Jason
