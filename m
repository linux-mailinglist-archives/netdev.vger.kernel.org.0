Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3FA43BE14
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbhJZXss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:48:48 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:40000
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240334AbhJZXsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:48:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wz8HwuWaR8YzHV+S6roDcIy3fO4g4g5NbejXjz+NQbTLbPSNZ7eBLn+K1dKC6RzLDW8ZjBjxuQmZtS/t3tS7klKF9s7gPzh2ABP7oat4he4jTAvyXF8LI5WCM0useiKMEJUvgWED7iGSi+aufTxbUFABiaE656dnHWGM04B/ldY0f4AtFHY9rQL0FdIMxQ0LT3pr1TUlTN3cO4O66rhW422kyWlSZ1MOsEs8W7IUhD6oWoe5dJa9zc+Tqb2Th6rY1uY7xL2zNr1WYrZ6/cdafaflLPfQxEC2qrxZAqmc3HF+Ugv2q+gY9mbxKWgAj5He4+ifI4J2f77wU3xhi1s1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t80iZrARqDyyrXqFJJYi3Jf5DqsQI/MbR49/VKz4y0w=;
 b=Fs+XmXikdQu3bRVKzr0apImdaJcGPFShnRcixsJJDRfGxT31izCnYRP/dwqfAe+0EAPnpKNUnndFvepMNcHRtFOCLx3+fo+PUksMahNJ2CuoaI9IUHwMVYcN0DYCJdlp/TbdKv09pHyQZWMTDPtD56uTYHEBbL/a2eGTqMHSUdqB20X9VW3aedg9CckMQSLsPHV040kDbYxuilnIwXJjl+rj+h8IlW9G4ktzOTbxF+Squ2sLav6y++5Bb6zV9Ldq0vTZyMSc3fvbIfAKkc2SIHZ0mfw/hlCtHWaueGCusQ+NiYnfnhzT7pXP9gxogZ6rPibm4UaDMhifXYKogkiBYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t80iZrARqDyyrXqFJJYi3Jf5DqsQI/MbR49/VKz4y0w=;
 b=Y0Db7UOVD/1j9fTlAb3tZwXfFH6oLSdOOQv3K9nvqLDVk+99MrMlSVqfu5GAd5hOiTwuQOETN1iYOaii/H44fZde3Xo4rwTAO+0hkhztZS05rX+ODvc6KXZVonK1ZyNKbgIbJZ4GgTWAX+N/ItI2bcenwzxDWeHW9AKTU1MmKIVQoXR9Et0OmBEoM+6Thm6tqxtDDcLyxF1tPO4W2s0Enw1zU9cE5qW7Wnx6+xdYuageDomCFIwtlPyuoqn8tqjnySSEum8EAdghZAs70cry2Ff7GS9sEU301jAcEnAJHFLfojCyOqAnVmYCBYKSM+7KsBi3YHzMLK3DbArribmm5w==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 23:46:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 23:46:20 +0000
Date:   Tue, 26 Oct 2021 20:46:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026234619.GB2744544@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-12-yishaih@nvidia.com>
 <20211026164228.084a7524.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026164228.084a7524.alex.williamson@redhat.com>
X-ClientProxiedBy: YT1PR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0124.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 23:46:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfW95-002Era-JO; Tue, 26 Oct 2021 20:46:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fb7695d-2571-47a7-d3b0-08d998dacfe4
X-MS-TrafficTypeDiagnostic: BL0PR12MB5506:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55065D13BA90555CC48274CCC2849@BL0PR12MB5506.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZdxZkvgCjz/PCW9Cv5LGpqbqOYvwQn0ntml8GNgMlsvoQMFx0Ke5qpctM7j42GbEEoTAsxSpfdvndEnb9JCIQbbmK5/D7mji/j1koBANR167DJlfOyVx5VSzZ0JWhj2/Akllnjuj9Q9TAWkhBHs0K8mUsE5meqtmquYkyIubh/8b0rumVrLRkq8Asak0qnSzhZH953PCsRc2tlQ6NKHKVYSGUblA2KsGT2Qs2YpI/ApfOOpiDpSv7pYKxSNygawF+cA3LJs8W6ezMH2xBWnTZhlKtJPqJh/ar06sCZAFcYzgXfUcuAD5lKP8Ok/p5EorPP6b4sOIojBJBvK27cBoXWpGIXZ+mMHcsHZMon2Dm3wyQjGjlgiL7h4T0xXmvd7vBTeEEnXXY+5+tXY5EfN9Pzaeqypy5Y0PJhSmzPW6hAiLiJhMGb8UMcO82WXqrJ2E/UC4vVFCQJhLyNFeFTIBDRPBOKxIml5PvKoPMSdo4dRjd40TuQm7mEGxOFx0RzqS+xhS1JypSUIKgVYn84GcOlLqsynewNl/ppHbd19wJRK3jbEjYGyC0b5WBd4oN2yA2sr3AA3bKhE4RWo4aCiRlBOntUFDhVSpMQ3g+HO86MbHZYTqAPjtTEpmFNwRxakpVXyXqgc3iM6eFn48+IgVDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(6916009)(26005)(66476007)(4744005)(66946007)(86362001)(66556008)(33656002)(8936002)(316002)(426003)(4326008)(36756003)(2906002)(107886003)(508600001)(8676002)(9786002)(9746002)(1076003)(2616005)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oapm0T9+YxjkisNlf/nxUl0VNqNipfEt3ttKWt8V2cRW9nqv2aklyHSJSKun?=
 =?us-ascii?Q?6DqYwbVh6yHaz4szQd4RUohTfrAphbBETaOBGzuiGQPQvS8cUeIejLGAfC0j?=
 =?us-ascii?Q?npsUfFnPuCBXyljaNiZKtYVcmPMyfQa7BnJe9gncaxQ+xqq0HZRe5VRfZs45?=
 =?us-ascii?Q?MPY9uCFClymZtRABkI9lGR0nsL5ebPljxLprfHVVC6Hw+RQLFp8X75bSfGbK?=
 =?us-ascii?Q?Evzuz1xSGeuERH1Z1govCOZH6OW1zMA//az5surK1GpeqEnRvvROHHqvmLa4?=
 =?us-ascii?Q?dZv9dMOSf08EvqAZ7uvPIetcRdbB9s5KHgPYpL86mggyzrJSdgR9nqygV+wy?=
 =?us-ascii?Q?K60tYgSOpTRAILLgZ2eAaPD3CyF8PAyBzPH1Q1n9q6RRG1sDlQJdx7j3VKsV?=
 =?us-ascii?Q?iuQqFhwH8nJnZYPocy1QKhxnJ3bMsO+pUBN3PE+lYAeVC1KK1R4TZTtAWzF9?=
 =?us-ascii?Q?GhWLdOuFIiS2+gD9y26wF9bXDmXAMtsqc5VfGpg+Ij+Ypt0EzOO08GL5kQti?=
 =?us-ascii?Q?vInkkPyF3x5ktPKRhLaF/b3tdPcN3dI7V56ZpZfdVvaopoS2FK1/iwZQEI+D?=
 =?us-ascii?Q?DCKsnzsQU95W7UdFY1iCGbh7/vkEpT9FO7q4NybPbwQUXOI04iF375Z5bEkU?=
 =?us-ascii?Q?CDQeCm1d9OKHbMdnV+zwNUf6oVYBebfaqe/A39/e1x9Ng7rbb++X4MBzPjBg?=
 =?us-ascii?Q?XPCinMv/ayhqoXHEj5wsjKgIp9ADRfNMlfyuHyhhWwUCsQpg/Rbk+N90tZDp?=
 =?us-ascii?Q?9F3C959XalYdUKbzFIdDyZ+aSTMkIvjIAxr5ntt91P6Ai4JZJkQLPRSCJ4xg?=
 =?us-ascii?Q?Bc4xXd+vADm+ou6Sw0q85uYMZvAIMohdPqG4lhKB4UahIwlSFkGOBUY0WPvy?=
 =?us-ascii?Q?KiDk8S0oyK1Ntmkj1c0A2pP9QbogFvU17HF9og9BOPW3MPqSD2hPbUwsAz4E?=
 =?us-ascii?Q?4hcvqi8g7xLVJTa3eQLV3f0jEIuu2FQ9IheOdciEli8k/oaiQlLmSVb4Lmm0?=
 =?us-ascii?Q?b3mEp6e9EbOGCI7Zl3Y6mGD+8W1WQfc53oOr6HsuSHEzAfdAZVwUmH/fJFHK?=
 =?us-ascii?Q?DNPF7HORoq8qMrbEk9//TNOiKJg+qvKoVUITveWvkpuB/0GJxXMHsq78Vcs6?=
 =?us-ascii?Q?rBOuK2+4fZCMiPXrKrU2cHc+hOMwu7KMWLnUDtnucP20OYZiSBv/u2afQ4O5?=
 =?us-ascii?Q?g9kIdG9n/My5uwwmziG+Dv06wpw0wNa42zvdhTJ5dT1xCRgpyJv+fvpbsOyy?=
 =?us-ascii?Q?DrM7WMHXu7K8ck6GWAAvJJBe2CkjDKMjzdiCmLqp+S2yQ2SSYWjeby0f2uzH?=
 =?us-ascii?Q?CrbwxykZln8GYisvL+u3ZRlapE92/tDC1HvsuL7l9l95+/fAPWSbfUtJbEox?=
 =?us-ascii?Q?zaMEUljGDWn7AJ/URt5lgtIantnQQTIxJ95Dp46U90N2xEedix2kUD5C3M6d?=
 =?us-ascii?Q?FrGEvSq0N7ZDixoKocbQ8mzrpFsZdDj85YRHkR2gapthORCNbgU75cDV+Cjm?=
 =?us-ascii?Q?6urScK5KgyEGsikYk6YmJj37AnLeTGvfbonScBTP9doFCmlFpXFrnKH6KzO+?=
 =?us-ascii?Q?I2I5UbFB1uK85uFq5go=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb7695d-2571-47a7-d3b0-08d998dacfe4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 23:46:20.9152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cN/zkfqK2jgJ62RUI5UfqGDiITN4nAMLDOX59nj00A3tsxfVoA0F9ufbmvxBrWeI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5506
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 04:42:28PM -0600, Alex Williamson wrote:

> > +	/* Saving switches on and not running */
> > +	if ((flipped_bits &
> > +	     (VFIO_DEVICE_STATE_RUNNING | VFIO_DEVICE_STATE_SAVING)) &&
> > +	    ((state & (VFIO_DEVICE_STATE_RUNNING |
> > +	      VFIO_DEVICE_STATE_SAVING)) == VFIO_DEVICE_STATE_SAVING)) {
> 
> Can't this be reduced to:
> 
>  if ((flipped_bits & ~VFIO_DEVICE_STATE_RESUMING) &&
>      (state == VFIO_DEVICE_STATE_SAVING)) {
>
> Maybe there's an argument for the original to be more invariant of TBD
> device_state bits?  

I definitely prefer to see it explicit for this reason.

The shorter version relies on too much implicit stuff - eg that
SAVING|RESUMING is rejected at the top and seeing RESUMING as part of
a stanza that is only about SAVING|RUNNING is less reasable.

Jason
