Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6828D43965A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhJYMcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:32:05 -0400
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:52192
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232582AbhJYMcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:32:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdR4vjs6RBTQyhQTXE36nyKq+xmfLj+sXNVYLrqiixAaXM4DJ/RVbtrWKgdunSP1ChFcp/bcpFdBM6OkULzH8M647HzYhVNJxXicCfj8iWoSURLE+Y3AtBgTgmAxdLqxgcCs3TPhSh85JQafO2HcmC5jKU9wGtH4iLzVdZF1oXkT5Fr4N6vPqGDTJPZQjXfCK//z5XrzEe34KnbnWUoNPzJX9vbvFTC5tmWtbg0e1gqOLpF6Daytqknx/W2gzD0Juq94CNjfrIyNCVk+nAg05A6iXbS7go9u/Y+5D88pxOKoHIoN4GLuUNIXFwVepiBMGVI2cSu/e5D45f9m2yu1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J073eYuArjfHrxNsCd03JZSP94vs07MSo6+SoNPefjg=;
 b=ik5Dl0hDpMrt8cv2RspBSX75muGG6V2qRsiOKCtmbSvs2Stq28W48sHIwUs34Pwr3pug6Eq92xnIHTNDtLFmKFR06Rr8C56y6bXFNr7HzMiVZ1n7NltvyYeWXA0Kagmffmlzd8eBjjHssPBN4ICwRviipNjz5P/j2M1xqvJc6SdtDt3lZ5tasE8VlouXHzA5UofMrkKzwkKKRLBEdNNHIwzqcUkpRxzVY5++RrV1wAQ6jC6HUbNuXfLWPFYdzDsfYQ5Mdy0x0Wliz/AlDpaW2llPdI0VAVlaoVR+IwFnAUWdGgDNFPkZdz0kYJpTeCan+EL0axvqo/XkQ99D5VfHSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J073eYuArjfHrxNsCd03JZSP94vs07MSo6+SoNPefjg=;
 b=QbzP89aVf2T0gwUpm3SfT2vNMPfXeLvdj9/VqCQ38VNgBLf7uz07w8pxuayqDSjQBDV+qumjupcmPJvLUYmYGGDdVwSASMG7RCo92roU8Pw0zNdFzUZFHoqyqe9Y/Ce9nQJxRQn7KBpMQd4iOAl6A7tMCrnaFpakPOJiDU5C/9EXz3sAR8wdBn4PsCSTaigkytZz6AUR5Pl+KA4gwf2PFnZlid2BMp4ISBtL72YjcCPr94LqeZoJf8yKKGqn4LjyY4WUvEeNup9ZfoygeJTAHLcr3v2bbRrkjdLAT/dbSOL4BaClhSv+OGg7xvA0Gdq8UKpSAmjLN7052q+y7Rs4rg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5524.namprd12.prod.outlook.com (2603:10b6:208:1cd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Mon, 25 Oct
 2021 12:29:40 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 12:29:39 +0000
Date:   Mon, 25 Oct 2021 09:29:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211025122938.GR2744544@nvidia.com>
References: <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <20211020185919.GH2744544@nvidia.com>
 <20211020150709.7cff2066.alex.williamson@redhat.com>
 <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021154729.0e166e67.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:208:fc::39) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0026.namprd02.prod.outlook.com (2603:10b6:208:fc::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Mon, 25 Oct 2021 12:29:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mez6g-001RfD-FP; Mon, 25 Oct 2021 09:29:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2dfe8f3-6cf3-4189-1fd9-08d997b31d43
X-MS-TrafficTypeDiagnostic: BL0PR12MB5524:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55245BC1E2D00CA0000ADC16C2839@BL0PR12MB5524.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsE2vk1SpQpPGnQGAPdwyW4G7BDFs0SdM9xcPv3t1S7Ws+HGzaLDRuZzq0gtvmi9IUuCVFiAAwV0stZjgYp0rTUH24Z4BKN/gU0KkY/GHqDeSyDT3FWXSYVjj0hhzQcSWrtw5pe20aFdkz+3e6JpVLoZMdogK0y6sD6b0mSmBn7NrTzxEAxUYn1CILrT6feu8J5XN0GB80cQyAFHdvWHQL7j1sUvIoCLybBdGmZLFIhd/CGpM6t5qRhrzpzAeBcysZFq6u9qVolW68pKQo3/V3PS70vkfzWJNNIeeofQ9cPqq6MwzU/A+Fsre7QHseabtZoIYkLIlkE1Kr6eivWaZ0KduVfI55MfBg8WIZ1WQ+RYIh13jQrP5Q0S6tuuwBLivgsHakCgYvzYW+xCQrCTqHdV4UHvE9TwSuL4ZIpGX+j+iliJzVPVrEsPmJLDM1cyzrWcE7gBxD9cD0Np9DfI7kXxsDxAkVWvfmiHjDb20m0Y9EM6irgtW0on4fZ+POYZNkD9gNjDG1/VX9eDo7BOZkca/dPKmv8hS25pPm7IxGjtVmtpbq84qDUY1aIOz6DeYm8ADAvXDbcoMDcDBf3zN4OEZ3Hcuhmd7HCHN5VKuR8XBTEGuaT/u5y5UqVUcVT6cAo8GYmKY1T11yTQUpNcAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(86362001)(8936002)(8676002)(54906003)(66476007)(1076003)(83380400001)(316002)(5660300002)(508600001)(26005)(2906002)(6916009)(66946007)(186003)(4326008)(426003)(33656002)(36756003)(9746002)(9786002)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RVZbb8bA75kajrpuQWCZ1pCDdwHcpNKO0pgrZ+imIxOEHRgXbvRKOUiPmblU?=
 =?us-ascii?Q?7xLmRUKUYLsyFBzUhnMbdul3WEsZzgiAUONTQDZv9IjpbKWnVG7iZih1LbwV?=
 =?us-ascii?Q?ICgEL1Kb/Ime/EVhmKMbE3DGXTC8cFLTRvD0Nq35ocjcUaDVFKAPhFqzFC8S?=
 =?us-ascii?Q?Wj69ay0eGQucDoW8iowsOjk+jrQUB7s2+GPCrU+R/hODLgI2fdtrrpNXDp3o?=
 =?us-ascii?Q?9P/Mqy9Yxu76Dr1qPFCOFjAjFKewlgHfHUYQOTlkFQXxyCqSb5JAKsFeN3bX?=
 =?us-ascii?Q?BXUTZWtC1y49Mm7n2y95GUlOYCvoFzju411N+mBGV7uhiUiWnBQ2BJT8xmme?=
 =?us-ascii?Q?xcerMNaTHn1T3wynS0Tj9N19zMZzesa9F+lKhIRzhofVUGzBpRhDEdW//TRT?=
 =?us-ascii?Q?KRtBLANvrbpM9Q3x0Bp4m3LoRr9gt1F4t85SOJNbtflBb7FSo3q21N0HyFQl?=
 =?us-ascii?Q?938QTYCsr0p4oBGIUPzWsYlCer8fu1C7zBvBvGbQMxv+rnt4LfpvDRg4g1Pq?=
 =?us-ascii?Q?GIyskYpQLxMgW3KaCQ/cDi2YAG4qiGQja2+Qtj1DnCe1BiDA5Kdhk5Lt0vYs?=
 =?us-ascii?Q?Vjkx2cFBEU3MAyCi6+WY1ndQQ3kO/3bSFnZcNP98DcHf0R0t9HWyv0KIdjjK?=
 =?us-ascii?Q?aA5anQqC4+46NK6YtBHJWbREMkZhAcVvDLrN7Tvu3eYLOxBaiQPOCsFOiyDr?=
 =?us-ascii?Q?CsviYq3mYc7JFWkPPy/lJG5D4WJ5z9qCvcbGZJ7pwMSceNsZ8FZAPwKGc7jV?=
 =?us-ascii?Q?uLuusqCyhTVXbtsDMNTe39KX5r8ZnTr+lhrL1Vl7XITHoWQGjutwnjhcVjM4?=
 =?us-ascii?Q?dhSTLaz7ERAgpUiNdMOiBEj9k/IBa0W3BFfVQ4TugbE1wcx7DjgcjyISuVUq?=
 =?us-ascii?Q?5lxkcp23E5KHKDXPSjdbQ6ZK8cKcaPYfgkIAhUIXGsmgE2IZm4im0foyYTkL?=
 =?us-ascii?Q?DqCTIzm1LtMDw+CW32J69wkDCUKq91rAMYyCdUv/8X0rk9gcPjm9Y33PmUIk?=
 =?us-ascii?Q?Qb/LbsSxAaDks5x20wqzZ88R3BEI6f2gvQJoKutsk/Bh7hT+aWhmcZgAlQQT?=
 =?us-ascii?Q?eNmnmd0Qyu9wfLbFOYnMQI8SgrNDAkRwXRWY+zp+IOtCa/fYxxjrfJbl/gHp?=
 =?us-ascii?Q?/sc83K+xIWx5GDgiB48T9silldPqNBSs40IS0WXshHFKfHPSE/cDGyjyOROq?=
 =?us-ascii?Q?kySJE2/16xK2hhwo/H8wb9hWd9aaq2pB0ADMjJl8GAhvYImMoJkY3UCcW+FE?=
 =?us-ascii?Q?xH6ybX2MZuhoMbDDKZHGo168YBvnucBUdR23Kejg7cnWtAyXv7B4f7wOb+8P?=
 =?us-ascii?Q?u0miyqz9unw5YhhYhOawln2ipMidlMNah1Sj6qCQXunkRakOXQ3N7DAmZcoB?=
 =?us-ascii?Q?Npfko1Ah9tbh0tp2pSaVW/WfIrA1MCmBAn/XBDKnz1hlc+HV/ZS0Yo/LzxpJ?=
 =?us-ascii?Q?FTt5KWadZXaX9QPHQwWvLEPm2SrFw0g7Mtu6JId6/wW0ll+ua1d7zOXs2LRH?=
 =?us-ascii?Q?l/QRCFJ/NUVGybEykAnm/ZO6RRwPXr0WbMbyiuweM5uaoLvCxKyOx7yKYeim?=
 =?us-ascii?Q?91BNubstmiXsGHMqJwE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2dfe8f3-6cf3-4189-1fd9-08d997b31d43
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 12:29:39.6967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bekFGLX9s9fQLsWp1MifZ9W4mKckQUTzdsvQJf22h3djAQwLPGDuXEkzqOIvgxvo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5524
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 03:47:29PM -0600, Alex Williamson wrote:
> I recall that we previously suggested a very strict interpretation of
> clearing the _RUNNING bit, but again I'm questioning if that's a real
> requirement or simply a nice-to-have feature for some undefined
> debugging capability.  In raising the p2p DMA issue, we can see that a
> hard stop independent of other devices is not really practical but I
> also don't see that introducing a new state bit solves this problem any
> more elegantly than proposed here.  Thanks,

I still disagree with this - the level of 'frozenness' of a device is
something that belongs in the defined state exposed to userspace, not
as a hidden internal state that userspace can't see.

It makes the state transitions asymmetric between suspend/resume as
resume does have a defined uAPI state for each level of frozeness and
suspend does not.

With the extra bit resume does:
  
  0000, 0100, 1000, 0001

And suspend does:

  0001, 1001, 0010, 0000

However, without the extra bit suspend is only
  
  001,  010, 000

With hidden state inside the 010

Jason
