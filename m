Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14453AA7B9
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 01:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhFPXw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 19:52:59 -0400
Received: from mail-mw2nam08on2042.outbound.protection.outlook.com ([40.107.101.42]:42337
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229456AbhFPXw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 19:52:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8D6W4EmaxPYcIXzs7uJPWVk7/hekPcU/2G1XneZp0VpRFeV8Du1fyFbGDkbZdFtyEP1vIKbZReVyf4/8eHlii0kTRGDwXw4bGnNunGkx+7TJ28bcv7ZgkwxgclAn2krbmbsOYDRlltqcLi4haTypfNDNDrulFq5Mujl46FYYJMtSsnnqduUlDtz6iGeWa2UOQ5yKr9ieahaEtx/STFXYYhn+G2+aLcOSCZvoPtCeeMBHfi/aBR7PW3AM8LLVVKYp9C/pr7YKl2IePXXtpowaSALwFim2rBTFKOIPwGH8Z5fgcxrGbRwQg4ECjppQhx6e25tjNiHDkdpSg+ToUAjCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fqv0YBRsTHnSoL9Fmf162EsifDb2kfpOqEQWK/fce7A=;
 b=ZCjgY08D9e9rbmYQy753s0gNGxVXUQUroteSbNuY7EDkB6QAjr/oaaE/orZE1spo8ryoDziGCxmn55K9Prz2JYNqI4LFg69s4eiqadRP/713jcAZx9b/LLpbU3feQGCTsZNDRnCoRV4T+lKu+CPZhQlGCk+oXxCjvzJ1PWr+33EnvPZtDBBP0qRIuzTDVJ8+TjCRwSFINF1yMAwWq7craMsh/mkwhdlp5Ldc9NwJRSczZOj5qiwIGQ30xKRUqCVsECntl65Ucka8qpqsKbr0wRWqEejMeXlAbXVEOO7rHJFybHZRffZXGHINdfvNkLV/WPc7CWOPvoDU4RxmUzEiEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fqv0YBRsTHnSoL9Fmf162EsifDb2kfpOqEQWK/fce7A=;
 b=fs1XC9Hf+Od4bTnTh9LQ7t3hBAQNQz2U/X1eljTCW+lPnTQFlprkRIJwX5Kn7/xFNOxHV8LABuyR5OLYU9ntEFNFGFoWLZ58cpRcR9hEA9sHp9326ibVOUCSmOmi3WAxNZTHnrFqA5uWpEb947MhOYy6dJi4MTUcFRQTcgk+ICOvpaXyuSR52L7U1GfWYggcP+JtLew+tO/BBSwQhFcLOFR2ParexGyNDrY6YrKXO8LVE2ldeNXj2BJf0AtAxueCavUh2PDI5FStxWZofCl1d3Cf095SKCiPSKe/QTzPrepBI7lGGMD46MkQoV1hfEQxmROEColMW1ECclPEPru1Qg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5522.namprd12.prod.outlook.com (2603:10b6:208:17d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Wed, 16 Jun
 2021 23:50:50 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 23:50:50 +0000
Date:   Wed, 16 Jun 2021 20:50:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 2/3] RDMA/mlx5: Move DCI QP creation to
 separate function
Message-ID: <20210616235049.GA1894497@nvidia.com>
References: <cover.1622723815.git.leonro@nvidia.com>
 <3bd27c634c8bdba836a4254ea4946a3fcc354109.1622723815.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bd27c634c8bdba836a4254ea4946a3fcc354109.1622723815.git.leonro@nvidia.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:208:234::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR16CA0039.namprd16.prod.outlook.com (2603:10b6:208:234::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 23:50:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltfJ3-007wrR-6M; Wed, 16 Jun 2021 20:50:49 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5145b5c-895e-490a-3604-08d9312191e4
X-MS-TrafficTypeDiagnostic: BL0PR12MB5522:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB552241246748E3FA4B0CE31CC20F9@BL0PR12MB5522.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQxZbP8odRGfHkhLZ/AcA9SAzc9ZsLJILVe/dHlydwmUcwD/1UIvMClWilga2J6KY3uEfpK5xmDxkqZHtJ68C9TvVjnFke1HZw3gHwyBMMNoz72Ed1R3MLPcKq74Iu+/uhKH1Ea1FqX7r3ljy09rh+ttN4yNISxx3R30w8JFQVfV7/b/MWTFhnjavxX79h6Y9e3zt+wveceN+7NvFo3cB83UrJOh8CRoUADu9vpX6gUSTmCH2Nd46VASqDxHCdW6I5mzSQ9mCFIfK7+w0v7QTX2JepBRx6eANP3snNmLIpTkM/e5ncHukz7OaB1BPKoW4641wiHe5AXt425V3dUYCxr3fRwn+S9MJZ4p1WCQbJtP57axh8DKakH3kNuN7KjA3LCAQl9GLz6nwUqvv710VFgLk5F7URerXh0PkfFQo9knvH91bicwsIb4FxCVl0M2fak9I/n/gNs/eNFAPkYumgG4Ckurd3GJO63TkuxZzm14UPBslp6yhUmYF+cqlB69b89w557QlpI9Y1AUzWEZgXDknqWFPUDYhzV3ZZDlBKmPSanTb45ukPzaHVpCAEsaroDwGVz0zRRX+z14ZsfQhHb+P18qulYLC5AOAfkutvQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(83380400001)(66556008)(478600001)(107886003)(26005)(5660300002)(426003)(66946007)(33656002)(1076003)(66476007)(38100700002)(4744005)(9786002)(186003)(9746002)(2906002)(2616005)(8676002)(86362001)(6916009)(316002)(54906003)(4326008)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0pxoXXlXkkBWpQ0guo/w0cH1c+gqN1Od2cUk/PZsyXVLLo/CTpVYq0Ad7H/x?=
 =?us-ascii?Q?WkZU7USd+bJleMhvTR2t/HJaZZ4OPuLCDQ/HbF8UwA500zq/geQKPLGQ0YfX?=
 =?us-ascii?Q?LHxqei52CVcJGWYV6rHdl9FI0EDcQAHpilsZ41M7CampYqtcFEPUHnDxxlZc?=
 =?us-ascii?Q?KjjE0xyyj6kv2oSIopnvgrh0eKCd/g1oIHDegxDtUwJsrIP9INBOQytg/SNo?=
 =?us-ascii?Q?eZIWUc2/DKB9OP2NQqVRQ6eAAG7+lYbO6DCncms2j3xQSPSgrJ5tYgXkwKHC?=
 =?us-ascii?Q?lL0R7bRYLouNF+Vn+XO0d0oea8nl4ebViz1ipRQt8OVNjsdNndARDJjSwPWD?=
 =?us-ascii?Q?bOXPO/xVqK3liGQdvYVhuuaIVhqMI5wF8C8f5PPLwZoP+XSeuf3IV4NYkymh?=
 =?us-ascii?Q?KcbJfYppsZGfDGa2Vf8obc+5B1XPNwWpJdMuk/RZqH6vAPtsTJh3507ekztk?=
 =?us-ascii?Q?PI4YD7PGRSoe0MUkUIep3Q8mKVggZmL93lWK6V+utRC/vfnQ9HFy/20tD5Rv?=
 =?us-ascii?Q?IIbFWO6DwsUkgMe3wv67jcUXpme+uUMFHZnaUdupWkjpuxMToznkOxlqMGkF?=
 =?us-ascii?Q?OZOnHrAdv90VxWCQqaQuC8JoyULNrsplucJl3T3tVVatW8LckkYSZjNFeRUr?=
 =?us-ascii?Q?5jLe/GK9+yZyBCgTT7STLVFHv17jKOvNEJgZQHmQ/DPYVYfSkV/2Kdr4qEEO?=
 =?us-ascii?Q?cblH0Zc8wd5GZkI2rVqj/g95HECNqOrXKmGeW5MbQLMl8EtRLR5Cj3Rh/Nr8?=
 =?us-ascii?Q?nE27GZV+VXt0jWUGCXFmmoinwQl2RCR2Psnex2qyKhZIOFKgbNHHcXTowuPd?=
 =?us-ascii?Q?5LxdgA+GmW78L7qcdnBq9ykON3a2tCABXkx/MR+mzYRdKl9wydG5CyYEkkGZ?=
 =?us-ascii?Q?25VIqn7Q7pfKni6uZ7qmYWzXqBjERwOoiINrmt30R/EAh2JX2T9Q3xhHjhox?=
 =?us-ascii?Q?90rlurhx85AU01J/KU4LqY5ezOT6+daqdvPC0GrO9curnGZgd+Ie9Ul69IDp?=
 =?us-ascii?Q?a4WQzopE/rGfRHhPas9D/8ffdJBO/o2Gqir9uqgLK5ZwFsF5NqqOHcCm/68L?=
 =?us-ascii?Q?ywlvNZsl75XDx8For15uHN0zlrt0me/0FsUGnEjegBF12VkaXkIodC/SnRmu?=
 =?us-ascii?Q?2dS28iTPwWIK0Bp51jr3LgSgDfQtwm/w7b0TCcKXjMKR5s1oyZmoYLKcDlH3?=
 =?us-ascii?Q?uoyBp2GPRINld9OQ9f3bzwfJslaNEYs5whShrQ9lKIxLggcTcHtd5jF/nx6k?=
 =?us-ascii?Q?VGf4uOEvBBgDSwTa0ljbvVFY76U6KBVy/YRET+tsyQ8yrQYmoK8zKLRtG3Nf?=
 =?us-ascii?Q?M3hiD3FmsF7ejMTp6b3IHRaY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5145b5c-895e-490a-3604-08d9312191e4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 23:50:50.2881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ioVhc0nc203FH5/uala9uXRaykMInmCe4nWe0j+U3zve9XwWbkmuP+QvoXR8tanY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5522
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 03:51:49PM +0300, Leon Romanovsky wrote:
> From: Lior Nahmanson <liorna@nvidia.com>
> 
> This will ease the process when adding new features to DCI QP.
> the code was copied from create_user_qp() while taking only DCI
> relevant bits.

This says 'move the dci creation' but this isn't moving anything, it
is adding a whole new function?? Please write a commit message the
describes the patch

Jason
