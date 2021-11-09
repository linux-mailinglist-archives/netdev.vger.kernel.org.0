Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA3C44B2B1
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbhKIS1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:27:18 -0500
Received: from mail-bn8nam08on2088.outbound.protection.outlook.com ([40.107.100.88]:44641
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239510AbhKIS1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 13:27:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QyJBt+o8M8nBaJobortA6eIXeCp+V8Cg9jlYnDFNtyVfZZWNqcogmT5QOJxsI3wwfcRa8LVAySwUHPoHBrv+5vuEYZDvsuuex7P1mMw1XMNgzkyTejBbk6TP+gwd1BfN0FmLCvyH2l/krf+SE1zTJXhf7RgRM+CV26Cluf8aJIoPSCto/avPrV4Mw7PzoXjRWgxvyuhr4EoLLy08g+/abWlHdSWVilYDU8Qi9EcB6lexUV+iWjDKPTtbbttot8VYyBR5mVFe0mQlsHdElsC9zrjx7F2ShPrG7d6TYak3jkf6RsY8wY4xE43X7CCkvAyH841VzYkASwpyz1rNIxKmWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0Af6Rjo+BNXLXWBzjUrga5gQQEeo/zazf40/EAmzN0=;
 b=ZEgOaLzO/0g80EVnkmruMNxEpacc7uD/Klo2vylkhBqc/Wihk7Fe6LTCE2nMP0c3OjxtZlBCQ5LXO6R5EQiZQ6g/2LNOH9LpiG/jJSVwM3rkej6xMfvfXThoYJ7VlFrsFBh7R1k/oF/F/NNHG+xwqOmUf3dvzKLZ/3aM8ZvWu+mVXCdcnX56Cc1jg4jPfURit9N4j9Qxv0/tvba+O4/fJbry6pkfsY/voP6HjRKOolLYOYO2py7EljquYsdG1tg1P9+OQkVbIeUogFYP5a0v8lNmgYVUFS4EWOe+yfrO19aST3yeBSRrJDxvxRZxaHmvNsekuwfl6UG18KJmSamKTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0Af6Rjo+BNXLXWBzjUrga5gQQEeo/zazf40/EAmzN0=;
 b=W6BE8MCuUBWMwrvkglNQPlY/khyh3K26KyuIgnWpiUd1bqOFBqNgiYkzplG/c7cVi0O9hfVpmGSgNLVa94IN9q0VAG5w2eMMIwCw3Z7oQ496BBruc15p84Zsem0wVJnuiCdscWkez4WNQkLPyH0nFWYA6A2Rrc/11STLutqYhY0dHk7SlWmX4Ey/W0bx6RmOdudB8qGb71CbFCfS+z1nrEZsvaC40rHz/eEsfpgrkYIcjsTubaToUs4hTh438yTVLHKtWgQ5cFTuhJhiRDUzBbEzXN1jp9aMGwN647HwFSi589E8bLbk2zFPIukZilh8R4BCCJAQZyq8Uq2QyO3x6A==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 18:24:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 18:24:29 +0000
Date:   Tue, 9 Nov 2021 14:24:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211109182427.GJ1740502@nvidia.com>
References: <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: BL1PR13CA0284.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0284.namprd13.prod.outlook.com (2603:10b6:208:2bc::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Tue, 9 Nov 2021 18:24:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mkVnH-007huH-I9; Tue, 09 Nov 2021 14:24:27 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c688f258-0bfb-41ac-c01b-08d9a3ae2ae5
X-MS-TrafficTypeDiagnostic: BL0PR12MB5506:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5506993DC7AE5E9C633D0A55C2929@BL0PR12MB5506.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aykn5n0J5LKxdW6+vmngan1c5H4bWZBxCSHxDDmjINbRrO1ANSCumdGZha8ZW9Zc1vEwyiK3QFl/i5cIT1IbrxAPCyfAlExT4MQ1/WftpdyDT1xyCb5h0fjuTSt9HVgGOI/vCCxAauztxpA1RMl2Trsd8bLbdChhoQwoqZzA9Fadzl52bhJ4P40eiTAaRnuGOBE6LLVFcTU7a81QApbKIxtIIWMfLwvL9m7dwWtnzZmncsAIfMp9SI+IPpQB+CCm+95J3y4IddxlMhbLAgY35lUb7DF0ZXyehGypJocfbZ66uw85dde/rpaQfG3/6mLCWY9W+jkkvhyHalVqV03WCacnx03GVgVVVfvxSbkQtmvkwBzTSyqlPRIooswQV2j9aHZ7zzk3U5P+MIr7xnq6lwoHrFIfg9EA8IQXwPn7Cg7d1eUuugAHYBQIHYzmdwUf5Pwk11iMu20mUJwyj25cMQS3OcnP8r/1Su1sy7HBU5dvwYEB7a+h0+7rtZyucq1JLmazyndRnBe1Cbt+cc1i+Cp365qbSv3Gi5/c5tNGD00W/lXkNd2HSj+OWMtyz5i3iaIt09g/4rqTxxQuVO6eUmmUIVWjV8xPbuq3ECkGmh6HGB7JMZx9dKKeZwZgV30zwHoLOeQi68WbJx6FLCsPdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(33656002)(83380400001)(8936002)(2906002)(2616005)(4744005)(66946007)(54906003)(66556008)(66476007)(426003)(6916009)(508600001)(9786002)(9746002)(36756003)(1076003)(86362001)(38100700002)(186003)(5660300002)(8676002)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7pDZT7GXQAm1tmoeMjOI4PKJw3M6PjiVYr4Unv5uE2lXhjv2dHWyLLzg6q7e?=
 =?us-ascii?Q?EuFKt8wbNFrNFDEwp9HhCNxxXERHfsi4DCXcxMpvppVGmBbx6PL+hI2Fr8A6?=
 =?us-ascii?Q?d3RMklX0S85rTGopo1E9FjWJ/7orOeMHsk/hTe1xNpv4ZyMdrbkOroG1ydBD?=
 =?us-ascii?Q?R+aZ0RD0xLYk1/Qz+tWvckwRL3Z7VhomZ+9d77NhTCCSnuyPtKnr7pwFQARo?=
 =?us-ascii?Q?WDs5VMiYJ8s/GJT8N43Wzow5gNWhYw0dCMtJe6i6fb3AI/nb62IIWi9eCs7V?=
 =?us-ascii?Q?/a305wua9A1DWwIw4wLoQ4YvWJw0Zeeb6GrmIdENGvD+DajGaftEYUpw3YhR?=
 =?us-ascii?Q?Vaa3D+bymxkFIrhX/ai+oh17uHyKGgKRaiFWuxtjk3fTZjApWBeAzMssPI2X?=
 =?us-ascii?Q?JKEC8791sXALn6WtNAknKMbBmBkMloL8rAMrmQA4leNfxu8+uXVdPyXfgBfc?=
 =?us-ascii?Q?mnV5eI7rssjqaJaMB1iM/DnrQIyUzZQLXy3J6ycB7L+jilr17b4QHWsLwLEG?=
 =?us-ascii?Q?GtjX/SzfSn+2mjmdFthTfH/th9l9KPyTmlbjzgGwWtlCvH7tecIpCC5z+A0A?=
 =?us-ascii?Q?TS+RG96lOdl9WRbOKL91PuE5jh5vXIBd2yNnZKawnwdLffF3H859wrdSusoU?=
 =?us-ascii?Q?G/NxZHtt/ShBjwew+4Cuw8TuvWcGElvWo7pKcjkIjBFUACgws2i4QRnCtmId?=
 =?us-ascii?Q?ngHWnxfZA/bvV2g4lnrtg316r4rjN+8RlnDOmV8O47fKZSMaVsL88woM36J2?=
 =?us-ascii?Q?m4n8HXGiOHt2kCNTe/gWg292t+buu7PkNTy0gs0x7bovx70UKzfFxqz3Ulvu?=
 =?us-ascii?Q?KH0DSyVnzaqmDyTyCUFDkaDJ5eswIEI0irTZWD3apl837vmlJmZ5ot0GTQVx?=
 =?us-ascii?Q?JbBln3E5UM/Ngp00IwvA6xXJpcEj9VLm7tx/X7+tHVcbr3FI+NWhcDMOHGfM?=
 =?us-ascii?Q?vMXYasheSCvBHPnem/HnEgJT88NdcuWB83bHs4RQZXCUbegG7N3MwLEMXPlf?=
 =?us-ascii?Q?8vEBr9W8/Phq0VuLxVNPKCiDzXiUZcq9VasXwGwiyDlBHYdrZ2D0T8CY3Oiy?=
 =?us-ascii?Q?FVZOpl9NJothfXfo9YwcHgIlLJkWYP+PVV3R3jUJrHtTa4Eme8uXtzIwtl3/?=
 =?us-ascii?Q?VQZ3V1W+SxXuoNhZQV2pYXSCUEqSq6Lm4pRcvITq6iYXzsy9wFhtijb3PUJy?=
 =?us-ascii?Q?PZC7gLtUsizXsQdPFNM8D3A95L41AVtF8TgSovZvkC9hnvPwyy3KC3u7o0jK?=
 =?us-ascii?Q?HDWQ66uPnG34rWwFyV4bJhoqGAzt9/Y1BpbXJMPYTHKfj8DiZjRFqKOzu2vP?=
 =?us-ascii?Q?aLjgw5kckjBpJSD4lXfTZKgYHPh+XWMFZPHtU6cNS9ebBUY+2qaMovGg/QdJ?=
 =?us-ascii?Q?ySGQ88Hc3BpxdTz9m46TAyPTSSFM0E5Gghj2ET0V36pGQI0Q0Ckf6wW4FFBs?=
 =?us-ascii?Q?uPsWhqQZTJxhymjNDu6XqZNk4B8jBvO5dN6HRJd9hrZPD4Q9ufuuaca0iszz?=
 =?us-ascii?Q?ugAM4ZIm9zMjuk6BYLL0MaH/sxuOdGcaBGE9L1u1fng1gRPf7EnfJanP+9QH?=
 =?us-ascii?Q?NmElaXWe2yJsvG+p4LM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c688f258-0bfb-41ac-c01b-08d9a3ae2ae5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 18:24:29.0526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9Cd/LlriKIVVROYP7yuyOOfvgXOsBIIjsepwokTwnyid/b3IyyVKjneq/zB8Yk3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5506
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
> > > > I once sketched out fixing this by removing the need to hold the
> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
> > > > over the devlink reload paths. It seemed like a reasonable step toward
> > > > finer grained locking.  
> > > 
> > > Seems to me the locking is just a symptom.  
> > 
> > My fear is this reload during net ns destruction is devlink uAPI now
> > and, yes it may be only a symptom, but the root cause may be unfixable
> > uAPI constraints.
> 
> If I'm reading this right it locks up 100% of the time, what is a uAPI
> for? DoS? ;)
> 
> Hence my questions about the actual use cases.

Removing namespace support from devlink would solve the crasher. I
certainly didn't feel bold enough to suggest such a thing :)

If no other devlink driver cares about this it is probably the best
idea.

Jason
