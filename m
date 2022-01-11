Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAD948B036
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbiAKPCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:02:31 -0500
Received: from mail-bn8nam12on2081.outbound.protection.outlook.com ([40.107.237.81]:33174
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243639AbiAKPCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 10:02:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGh3P6TuS31wvmNSFrQH7d9AhWQD3y7UE5p5XevIlUPt7jRf1VEYXctUXNaM4b01bon2IcJK2sxY3ZvJXuPW9mEYHcLajcQY1TYJzlnRDnpuhQsxoD79QvjZ7ON0P1kWSP/B5OexE7XXIWzUllyhyumzZRbVL9l/rHy4hMphsU6BYQGAwLFAzSg3GHqwDXEjaYa6QkvMaS3KKHPKVPTgO9Jojkq4AirskUIt2moSpg+8EhqLQOuZEIp04ejt9Dwq4c8ERAJjdGmSsmCpZQ+To0+pbszTGTRQc+PsvZGWp3OsY08jbpbzGe/dPKI08lh6tMZDKdUfhtlbjQ886ZC0aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KBxXipoDTLJKlaR53BND4VyKkOWk7WfbJCSM9Ld+3w=;
 b=McSAUQq1wtcvZEx3eo+USWevbcAusMJB4xPmgLxifjoIg7XCFrfkNKBYzwfETo4gklNZ8dTNE+8Sx7dFiGYVAHSSuLgSyEXXsTje/dRF7U0fECTNQbsAaPTDW1fOPWKf5TVM/xP52yQC15+sXikyEZJ3FqDfeqMTQISr0YJig8ktSK11VXP32zK1xAUAD2ZIX6bNws5rIrkWnyjuHTpGPjJWVcF+65c4m6NqInvJsW2G78A4gzUuFc0leJ3ebS+A+/MT5cKG3x92CL9QP4FQyzITFzNwncMFdSTdG3UbE1DTAnywNjslV0xAoD4+UPRWJOfEj/V1idUAbThg/mN6TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KBxXipoDTLJKlaR53BND4VyKkOWk7WfbJCSM9Ld+3w=;
 b=a7itx7iqDPx474I6JRprqzcs1rCq6/OMycYzfaIm4LgIMBbpMJ2XSbiLiMqejjq/wI1fE/LgY5ahORzzD4OC9nW7eDJ0+EPaAjz9D0RlfyU0uyEGk7iv6MGul+ojsEUv8V7soXsskf/MKjlI3zZqsxcr5ajyCY8JGq0awgMOFbrdWNgmxyORYOWlGCOyLYl9b/Pd3fcTXlXuJH8587gC0ZzlKeG9VtUvsitOUs6JUgvfWbv/U5ez6jwYZV1Q54YYSKGg5h4ZCNRseLQbvzvQTQNtMgZNUYtLdDGHoE6Wq5egY4R2cx2Yb8xjzlMaTU8TYIB46NujnSSqrF+dajukYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5031.namprd12.prod.outlook.com (2603:10b6:208:31a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 15:02:24 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 15:02:24 +0000
Date:   Tue, 11 Jan 2022 11:02:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220111150222.GM2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
 <Yd2NraXh3ka8PdrQ@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd2NraXh3ka8PdrQ@casper.infradead.org>
X-ClientProxiedBy: BL0PR01CA0023.prod.exchangelabs.com (2603:10b6:208:71::36)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27c93f24-1a4b-4fcb-f3d8-08d9d5135fdc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5031:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5031BF546A0DA4BC73AEA93FC2519@BL1PR12MB5031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQ/hKk5moXlJqPsVqaxAXZuxrZ87wxQpPx+XNhNw7hiNvtCVYObeQQNSlfGrKaMQSatAT1lHmbSd9/bi4fBqvp3pDoyPMP3wxzUYjX4pIPnN038Qx2MVO927gSB7dXb+2cP092Tv7wB/Nn8Oygtf8AcOENCkXDmb7uJFqVSdDR850B0rA3+81AOeN8oP4A9m/BExtl7MxNbXCX9N59Eq4dZUcsObW9yXexYYyUj0r0+ZfHDFOjclGBXjNtxGPZrK4/JVaBTzHrMgZpk2fG5YEV+tx7arfMzNTswJR80VsvabHIbHe5msqL4KR/YmOsslQFFzLrMM6UnGvFt7/ajIKfgF5VJadr3mdmUyjbgvpHfUD5AcQP2CAB3Iakt1wvzHwk1EGPSg8yYmpouX/1CjOWjvDeBLlbOaQ6JPBvQ3zB/dsnNd+AsYR4YzobvhxNS9r48MBIhjOepC9M/E4BAjwJ6wU3gfG1BzWckwjXrwF7kcRXFEWfOTwzedJxwd5pK2wXzLFdNPWjJ1X4B2PQmKRdeexLK0af2ji7VQUrD2rt3SvS1kQ8Jfu7kdfIdXohu/6LrXGWgzFr3r/K/FmMiGgeCVIOs51syF7JgICSFxlFKH7pWpPADVU7bzOCXIHPI/3g1HMtfgovvhHBPB52yeDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(5660300002)(508600001)(66476007)(6916009)(2616005)(316002)(4326008)(33656002)(66556008)(8676002)(6486002)(66946007)(8936002)(86362001)(54906003)(38100700002)(83380400001)(1076003)(7116003)(26005)(6506007)(186003)(3480700007)(36756003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W43gxgbL7140Qd1HtzS0MYrsnhQfisrgOKxvoHaxfy3sNzPJCWW8uXrhSRPf?=
 =?us-ascii?Q?tyUec5K9aezzsRPvdhwb9hIXhYRgtrxCQkbQXjxKsMxFm32Qesx3WNSI/4jD?=
 =?us-ascii?Q?f7aEg0nxiyzALswa5U8P6ZTDSin02IEQR1JdmG6suHBwEA8QqO/xMqzAT5Fq?=
 =?us-ascii?Q?8EOX9PIqoiYrh/QyDyuRhcy4kO6tsxwkr9NuPOD3QEZM1ZLQfduVw4MaVUXK?=
 =?us-ascii?Q?zTmOv3wr4zWUY8uXsEVBMjisdQlDuxBmg3800vX8q6RgWu3v9XLhmrHu/e6J?=
 =?us-ascii?Q?e/jMhb9POfxbhtz/9I9dQomimkmQN/sdVubsuB+mv7ivrUB3oxlFp3JIcHKh?=
 =?us-ascii?Q?8nOqGy2dUYprj5VCPhp3EuTfAk1+RF5DjPfPt8omL06c9yHkcbPAJNh/9Q3V?=
 =?us-ascii?Q?rGD9wq/CzoQ2txTGZKI+YjbBJV9uHtV9+QFhwTlYgqLVFv9x7WDq8wRvYcvA?=
 =?us-ascii?Q?ztuGxib+n0fEZExLG4yg/Jp9ZTw3rzeBXlfPSHxLVVXC62Rcq+GX/R83jKqL?=
 =?us-ascii?Q?WzwIibDlMyALOzWFjOX6zEzaW0ufIvMLY9OJrIyKISsGLLfbecjSUfpOaI7P?=
 =?us-ascii?Q?0KxPlWN67cGnR+Sjg5FZ//SZJFLhq7JaikMu+Dclsz+X9n90GyvGr4pv6p7a?=
 =?us-ascii?Q?xvnQCLfwz5ZqfHtzwqbOt6rPtz7cfiMvlPs/1q69z2B4tm9h9NkBnxRd8aFv?=
 =?us-ascii?Q?KKFvuwM1EJJqo3nTvviG4vOupCIkUGC5sVACpaHoMUY9cZifeaIw8z4EhjxY?=
 =?us-ascii?Q?0kYvTmMMoKknjDN7oSFNhGC5yS9zX19LggwgBrTmdOryEuMpMs7cvpKxSkIA?=
 =?us-ascii?Q?Pn9OjiQqureRlNzfnQ4j76fJfIu/Xthz4QNnfjp/r1J7PbNV5ugJfytXcV1Z?=
 =?us-ascii?Q?fed7O7XAVL7DxW6VlU8fwN10x6MLdcE3S9yysZoVEiYq304sENpfcgs9NKSS?=
 =?us-ascii?Q?ZUBZKlf1hV3fSMZrrDG4BnF2yBAPVwLwNpmYRMg8pxczuaKfoFBkP+M6aqRE?=
 =?us-ascii?Q?oCEwYVFqMuUoVpdzgjnbkOfOwBosc++dy0MfXMD70EWz6FIuT8B/k4sf0kNq?=
 =?us-ascii?Q?WROKi7y6oIMQLL7d8f+FGceuA9QadSsT5VsJhuFUa07V23PEO+FIByb2sjyp?=
 =?us-ascii?Q?2Dxi+25h2zDsCoAfaoPX96flbKFlTVXz0BJne9bXWXDFgi5LDCSx+DJ4ltza?=
 =?us-ascii?Q?O066uv3Y3T7v3jwEDjR+16qH83fV7PRkoswlPBlGCz9QCB+Q+URPMmd6dN1D?=
 =?us-ascii?Q?r+9gHVmrc54j/aZKJZQKmvAlloiQG/6DPqlV11jUqAra5WIQtfJ3S+nJbBJ2?=
 =?us-ascii?Q?BocF5tR8bG07alzyjjCcE62OGO98JeKZmS/dW4YMi10kPvAI+cg9LySwpbEN?=
 =?us-ascii?Q?3zpKlNKV67jVLH3vJ2XjwBb8ucxt5DY2Ffwg2yAxAr6hd8hunaOKEeGIpCPt?=
 =?us-ascii?Q?G08PlzVdiAcUCqWRxoMS/6KTAhuXWWqvfTGO+4rtP8/0Je+Fq/+ATMdFZg14?=
 =?us-ascii?Q?3xYbrWehHq57TM70VDpGlAoXp+nf/jR+NBdoP1BgeN1VpHrf9cEp1Gsb3u6g?=
 =?us-ascii?Q?5iOv7ZOoE+/FLfw7zhw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c93f24-1a4b-4fcb-f3d8-08d9d5135fdc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 15:02:24.0452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zdhezc6GdIvPrL9NZE8dPgUuUlbWhm4erGnzXJhNY3YHHC1khp4eOxheT+bEbkhQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 02:01:17PM +0000, Matthew Wilcox wrote:
> On Tue, Jan 11, 2022 at 12:17:18AM -0800, John Hubbard wrote:
> > Zooming in on the pinning aspect for a moment: last time I attempted to
> > convert O_DIRECT callers from gup to pup, I recall wanting very much to
> > record, in each bio_vec, whether these pages were acquired via FOLL_PIN,
> > or some non-FOLL_PIN method. Because at the end of the IO, it is not
> > easy to disentangle which pages require put_page() and which require
> > unpin_user_page*().
> > 
> > And changing the bio_vec for *that* purpose was not really acceptable.
> > 
> > But now that you're looking to change it in a big way (and with some
> > spare bits avaiable...oohh!), maybe I can go that direction after all.
> > 
> > Or, are you looking at a design in which any phyr is implicitly FOLL_PIN'd
> > if it exists at all?
> 
> That.  I think there's still good reasons to keep a single-page (or
> maybe dual-page) GUP around, but no reason to mix it with ranges.
> 
> > Or any other thoughts in this area are very welcome.
> 
> That's there's no support for unpinning part of a range.  You pin it,
> do the IO, unpin it.  That simplifies the accounting.

VFIO wouldn't like this :(

Jason
 
