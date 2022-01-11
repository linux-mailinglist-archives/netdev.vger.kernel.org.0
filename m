Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C761348B8A0
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 21:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiAKU0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 15:26:53 -0500
Received: from mail-dm3nam07on2042.outbound.protection.outlook.com ([40.107.95.42]:32192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230469AbiAKU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 15:26:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYxU9CEQRG2H0pWdXAISmBz5ZOERIZK9jLlB3U/V/Ph4Tx834YjrwpYJTyTnEfgqaWBBbKZ2c8at1m8jY6FT09JRhLDzisH3Musx7/yWNkcwfzvNznj6lZz9MS6bwgklppxrw0QDDbtsQsT23mCkrSNC/3jCEiD6CzCpngxgrShbOjGHBAcbHm8lcuL4xV4vvZZLw9Gt9oU3J4a/f9IZQHO/VD4c4isC4xWa+oLhU5/4b+zJVmkYscfGkgZcfaspC4V43qX/Mo3sQ4dkefVEVRra4eVvDhC1BVkbJstuKSIuJizMdTHE8vQvv2mBlfR0dK7rWHXhTLRToXiqC2X9Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ymR5zGL/a44gqeCFzvZGVleXs4ZKcaX+thEeMALz+g=;
 b=Tx9dN2Q0D/YdzlYPTCg7qDa7WN82Cg0KU5h60FQiMthCGRpwPfL4tEPW9FR6wHm77j1t8IAN9HpB1maKxtnMOO5a/j9eYqioGEPzScAhZXUI1+gibweKlkI2KVQWOlvmdClLCd4lV2+b2HjN/mAjqEMes+YHEyY7DAaKO/I+xA7ZBnIMirQMeQpjbVkl4A1f0atxskTE+VIlLiZ6oFl2DobFBaSuAYbXjlQ4ychrSiLFLQhCBcp3Rv9pQEYl3CAj6dkMp0epssZBPAWESqOUimkwF35q3CyjVokBDOHowsMaA3lKjsNa3REQZltcoahha5w5csBgx41erNwFg399Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ymR5zGL/a44gqeCFzvZGVleXs4ZKcaX+thEeMALz+g=;
 b=QtG0q6dIyhGCPzHdshBFIs25I0708hxMs9daBn4xN7lGnJF1tBC4V7bp1lyk/3qh0+OOczmHmv8vyn5qxPZ/DXhuwrsH9QvUxXdg+sqM1ISxMsCJVA+AmAnUCLpI80Sz87aai0MScBRvR458Lgu79PxAc9zJXz8GnpR85EKj2VFSNiU20x60YUTmyrdiPSKHZqLD9kp5OdkVaOQbGlQIsP5SzizNyq1PNPXYUpIp0rgWWr3pjR+9/ZrPFAJUw9UQEEICInrhdYtqwSXeXmYzmgK//m3+E+hqBm4HsN6luVIq8Y9RuVh1CC+6E2wXy/K2jIquc87XSiT8rsrbtJqIPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5029.namprd12.prod.outlook.com (2603:10b6:208:310::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 20:26:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 20:26:49 +0000
Date:   Tue, 11 Jan 2022 16:26:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Matthew Wilcox <willy@infradead.org>, nvdimm@lists.linux.dev,
        linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Phyr Starter
Message-ID: <20220111202648.GP2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <CAKMK7uFfpTKQEPpVQxNDi0NeO732PJMfiZ=N6u39bSCFY3d6VQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFfpTKQEPpVQxNDi0NeO732PJMfiZ=N6u39bSCFY3d6VQ@mail.gmail.com>
X-ClientProxiedBy: BL0PR02CA0058.namprd02.prod.outlook.com
 (2603:10b6:207:3d::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd17d90f-1604-49e2-c7a4-08d9d540b20d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5029:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5029C26EAFDB84CF075E3A96C2519@BL1PR12MB5029.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkMKUtFZzLfl+PSSE1XAEz+UCyg/UiffbHEircgfTcFSTNg4VPupfXp3QugiXGFnLGlcQ3zphxMajDrcsf1vMnTrbWAJ93zyKVmEsdp4vZ7yJx0FcO9qEXzd1COYD9P3AT7GP+CkMa3FF+u7KtAV8s23rowgbYTa18XgsUAUWqzs4hkwQfcShuw1n9oPV+5SL7vcTMAG6nYvGjqnznD00h0eKzlVwOvGz71tpg08E0Vy3gfeRuBa5sVyzpM6HUL8u68ssPFBg0RqRxfA3BZA1OfTvqA9nh3pBs/CHBmUuGi33swobwjm94lgN/BmpSKNGthTPxtUCr7nH3PU9orFFyP25qSxEU0aiTrinhU5tiic0yxTWbgsTBTlR+lyrT1an5a5IhTUIPYZLH+0FtBC047Im0sCFqw+E8U7PdHfNkqfo9df5r+QyvN2QoAL9Kr8i0w9Lb8VoNdtgeQgk/AMnNyOTGKaS8AaHK6zSlCpwZOGbtYP0LBfvEx000aMiPTkl13TJPdO96fnEqxqUBCPHTOkZ3ONhilV3RZTOr8TGckX7Mg0oLrqhTkwhBXSDjyb2182yb9tUXgKMPoD4dSy+1b4qkSSsvx8n1q06M+PNgJHxFMkgqyIwCZwZTxtB8EsqFaQXgMYKiC79u6sI4Dhjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(6916009)(5660300002)(66556008)(66476007)(1076003)(66946007)(2906002)(38100700002)(7416002)(4326008)(8676002)(3480700007)(8936002)(26005)(6486002)(508600001)(86362001)(6512007)(7116003)(83380400001)(2616005)(36756003)(186003)(316002)(54906003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5rIKfzHBPqIelA8UupQt3jyMXkwxNsiSUeF4rsOQuRoy8xoZeFZ46OcmFUQv?=
 =?us-ascii?Q?atY1mYqv9LpLrrFvE/vJ75QLU/o5pl/0EeGNaDJTw0sOpyzASi48unT0uNm+?=
 =?us-ascii?Q?W1RYKiL1jdNvA3Dcz4TL384xyMXCnFRAHiMqRMlK7NE5uF74ixex6/ju21zG?=
 =?us-ascii?Q?D+SyepfXmgai6ffWcyts+2I2yzh8GCX1iWyh48sPqBxA31xsyrIhUK5sGuR8?=
 =?us-ascii?Q?PTqOni3jNWhsIFA1y7KReLuQVMaakCekei33KpSc86fNK+PKY9bCk3bmMSaQ?=
 =?us-ascii?Q?Qrahf7toAhemUuXR/yHXlzoNjGOA5m3qxStwJTKfAzMF3JPANuvJatrggY8o?=
 =?us-ascii?Q?RlIJ3/vQCGk+03abOmMW/liVEIDNCjIzfPTMB9LuN8L2wSo5ie5M2scza6f0?=
 =?us-ascii?Q?PDlCvd2GEmRJBv1sdWT5qnSh1gXZsSVpPaqij6gYyL+ku+sIuiGu375vlt0F?=
 =?us-ascii?Q?FaXDBioFY2Nx+lYDtg2y+YwbkLffdMWgzJPaKLFZgM//FjlxNE/2WFfCI3fp?=
 =?us-ascii?Q?/c/KbfDC5AuqITOtXWFPVw76jmLPjrkGzgeryp41YNmZre/4KGuAF0UJDgxA?=
 =?us-ascii?Q?EH3IE5RzXEVzm8t/DOEUazIsM9EsS9/dVOZmH18ZRwFrzWpBmfm8HkvHKeKd?=
 =?us-ascii?Q?W4nKJVYMiNsHlnGkOWC5MhmdlbantwDoy/tmZpIs8gRr0c/3aoHuJVRa7Yky?=
 =?us-ascii?Q?3iezvMKcMjipvvuFrwNulIPaW+M1HN2mEnL2+Eueezh8I2R1s5kh8z2fVwUa?=
 =?us-ascii?Q?zRaJbpkJ7h4qNd0VBGC2mNZNm1L/Ni+H7AvW0wjCNTarhBYDApEYn1tCZ1Ul?=
 =?us-ascii?Q?rSondzJTJBrqwRXGhSyJqK098UyENAvvWxXCFf47gX+38NXCrpA0JPAENbqx?=
 =?us-ascii?Q?RrPin+WxJJmNTT4YtCiIPCO3oP60/vn+z/0EE/I4RfMZAYteO1qiS/u0yWgp?=
 =?us-ascii?Q?Hl6sM58fCnKnaZwloeTOSzeEntzoh+9fp+ctgeFA6EmP7LPELs+qFKBEYg1S?=
 =?us-ascii?Q?DTAOP1o1q4kT6bCS0FJVPsHBpbIo7AB0MROOdWUoQOiNSUAkYSQCEUwQxYUU?=
 =?us-ascii?Q?rT0nc3CNf6KLedxK1636dJkPBJAsr60xOoJDkMN1E7hIl8+jfIy6V07u62I6?=
 =?us-ascii?Q?syIY+0yWmFL5vgqxJNS6BvMDs9jGT7PolkLcz/vAJT+CvQdQhRhFzMycfj5S?=
 =?us-ascii?Q?iWEJa4EJ/omFUQa99ZPYbE0NJg3QTjGPvrVHLl8URtiU7+ImuI82scdewO3v?=
 =?us-ascii?Q?qzDL/R23ZUZkqnpoFKJZXeUQE61vvnzb1jTXLuVU8+ZYXRYVSpDkp7ZoycEI?=
 =?us-ascii?Q?2InxoWSqg7xOPM5hOV095hZ2oJH+DqL7fZlTvWxwBP0tGCclg/afoUXfy1cb?=
 =?us-ascii?Q?Yp4UStMFkJi6zX3ABF/t3F2Y4Xi0L8xVs5fHEHUOKNrJPFSNFwCcPktmsx5V?=
 =?us-ascii?Q?MqGuMH6QNm4jVUF9eCyRoo+hF959jJKkMO5pYql9ckVE33TByVF+Ga/7sAxF?=
 =?us-ascii?Q?65uRZbOZoMQAwRPwdPLEcgwBO6y6UWNcd1XgEbOBm9TSknYc3cWRNPj0PEGf?=
 =?us-ascii?Q?H65LCzTOCxREFnrwpG4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd17d90f-1604-49e2-c7a4-08d9d540b20d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 20:26:49.3849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYBPcPP6ultUA3sQEPcEcXMB7bjMVU2guEqzPZYYyzG+xAwlJjDZHiBK0yjNz4Dg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5029
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 10:05:40AM +0100, Daniel Vetter wrote:

> If we go with page size I think hardcoding a PHYS_PAGE_SIZE KB(4)
> would make sense, because thanks to x86 that's pretty much the lowest
> common denominator that all hw (I know of at least) supports. Not
> having to fiddle with "which page size do we have" in driver code
> would be neat. It makes writing portable gup code in drivers just
> needlessly silly.

What I did in RDMA was make an iterator rdma_umem_for_each_dma_block()

The driver passes in the page size it wants and the iterator breaks up
the SGL into that size.

So, eg on a 16k page size system the SGL would be full of 16K stuff,
but the driver only support 4k and so the iterator hands out 4 pages
for each SGL entry.

All the drivers use this to build their DMA lists and tables, it works
really well.

The other part is that most RDMA drivers support many page sizes, so
there is another API to inspect the SGL and take in the device's page
size support and compute what page size the driver should use.

> - I think minimally an sg list form of dma-mapped stuff which does not
> have a struct page, iirc last time we discussed that we agreed that
> this really needs to be part of such a rework or it's not really
> improving things much

Yes, this seems important..

> - a few per-entry driver bits would be nice in both the phys/dma
> chains, if we can have them. gpus have funny gpu interconnects, this
> would allow us to put all the gpu addresses into dma_addr_t if we can
> have some bits indicating whether it's on the pci bus, gpu local
> memory or the gpu<->gpu interconnect.

It seems useful, see my other email for a suggested coding..

Jason 
